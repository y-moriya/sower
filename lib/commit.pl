package SWCommit;

#----------------------------------------
# ���J�n����
#----------------------------------------
sub StartSession {
    my ( $sow, $vil, $commit ) = @_;
    my $textrs = $sow->{'textrs'};
    my $pllist = $vil->getpllist();

    # �J�n�ς݂̏ꍇ�A�������Ȃ�
    return unless ( $vil->isprologue() > 0 );

    # �m��҂������̋����m��
    &FixQueUpdateSession( $sow, $vil );

    # ���Ԃ�i�߂�
    &UpdateTurn( $sow, $vil, $commit );

    # ���O�E�����f�[�^�t�@�C���̍쐬
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
    my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 1 );
    my $memofile = SWSnake->new( $sow, $vil, $vil->{'turn'}, 1 );

    # ��E�z�����擾
    require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
    my $roletable = &SWSetRole::GetSetRoleTable( $sow, $vil, $vil->{'roletable'}, scalar(@$pllist) );
    my @randomroletable;
    my $roleid;
    for ( $roleid = 0 ; $roleid < @$roletable ; $roleid++ ) {
        my $rolecount = $roletable->[$roleid];
        while ( $rolecount > 0 ) {
            push( @randomroletable, $roleid );
            $rolecount--;
        }
    }

    $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $sow->{'textrs'}->{'NOSELROLE'} )
      if ( $vil->{'noselrole'} > 0 );

    # ��E��]��ۑ�
    foreach (@$pllist) {
        $_->{'backupselrole'} = $_->{'selrole'};
    }

    # �����_����]�̏���
    foreach (@$pllist) {
        next if ( $_->{'selrole'} >= 0 );

        if ( $vil->{'noselrole'} > 0 ) {
            $_->{'selrole'} = 0;    # ��E��]�����̎��͂��܂�����
        }
        else {
            $_->{'selrole'} = $randomroletable[ int( rand(@randomroletable) ) ];

            my $randomroletext = $textrs->{'SETRANDOMROLE'};
            my $chrname        = $_->getchrname();
            $randomroletext =~ s/_NAME_/$chrname/g;
            $randomroletext =~ s/_SELROLE_/$textrs->{'ROLENAME'}->[$_->{'selrole'}]/g;
            $logfile->writeinfo( $_->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $randomroletext );
        }
    }

    # ��E�z�����蓖��
    &SWSetRole::SetRole( $sow, $vil );
    foreach (@$pllist) {
        $_->{'selrole'} = $_->{'backupselrole'};
    }

    # ������������
    $vil->setsaycountall();

    # �P���ڊJ�n�A�i�E���X
    $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $textrs->{'ANNOUNCE_FIRST'}->[1] );

    # ��E���蓖�ăA�i�E���X
    my $rolename = $textrs->{'ROLENAME'};
    my $i;

    my $rolematrix = &SWSetRole::GetSetRoleTable( $sow, $vil, $vil->{'roletable'}, scalar(@$pllist) );
    my @rolelist;
    my $ar = $textrs->{'ANNOUNCE_ROLE'};
    for ( $i = 0 ; $i < @{ $sow->{'ROLEID'} } ; $i++ ) {
        my $roleplcnt = $rolematrix->[$i];
        $roleplcnt++ if ( $i == $sow->{'ROLEID_VILLAGER'} );    # �_�~�[�L�����̕��P���₷
        push( @rolelist, "$rolename->[$i]$ar->[1]$roleplcnt$ar->[2]" )
          if ( $roleplcnt > 0 );
    }
    my $rolelist = join( $ar->[3], @rolelist );
    my $roleinfo = $ar->[0];
    $roleinfo =~ s/_ROLE_/$rolelist/;
    $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $roleinfo );

    # �_�~�[�L��������
    $plsingle = $vil->getpl( $sow->{'cfg'}->{'USERID_NPC'} );
    my $charset = $sow->{'charsets'}->{'csid'}->{ $plsingle->{'csid'} };
    %say = (
        mestype    => $sow->{'MESTYPE_SAY'},
        logsubid   => $sow->{'LOGSUBID_SAY'},
        uid        => $sow->{'cfg'}->{'USERID_NPC'},
        csid       => $plsingle->{'csid'},
        cid        => $plsingle->{'cid'},
        chrname    => $plsingle->getchrname(),
        expression => 0,
        mes        => $charset->{'NPCSAY'}->[1],
        undef      => 0,
        monospace  => 0,
        loud       => 0,
    );
    $plsingle->{'lastwritepos'} = $logfile->executesay( \%say );
    my $saypoint = &SWBase::GetSayPoint( $sow, $vil, $say{'mes'} );
    $plsingle->{'say'} -= $saypoint;    # ����������
    $plsingle->{'saidcount'}++;
    $plsingle->{'saidpoint'} += $saypoint;

    # �_�~�[�L�����̃R�~�b�g
    $plsingle->{'commit'} = 1;
    my $mes          = $textrs->{'ANNOUNCE_COMMIT'}->[ $plsingle->{'commit'} ];
    my $curplchrname = $plsingle->getchrname();
    $mes =~ s/_NAME_/$curplchrname/g;
    $logfile->writeinfo( $plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $mes );

    # �l�T���̏o��
    if ( $sow->{'cfg'}->{'ENABLED_SCORE'} > 0 ) {
        require "$sow->{'cfg'}->{'DIR_LIB'}/score.pl";
        my $score = SWScore->new( $sow, $vil, 0 );
        $score->writestart() if ( defined( $score->{'file'} ) );
        $score->close();
    }

    # �������[��̐ݒ�
    &SetInitVoteTarget( $sow, $vil, $logfile );

    $logfile->close();
    $memofile->close();
    $vil->writevil();

    # ���ꗗ�̍X�V
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
    my $vindex = SWFileVIndex->new($sow);
    $vindex->openvindex();
    $vindex->updatevindex( $vil, $sow->{'VSTATUSID_PLAY'} );
    $vindex->closevindex();

    $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Start Session. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]" );

    return;
}

#----------------------------------------
# ���X�V����
#----------------------------------------
sub UpdateSession {
    my ( $sow, $vil, $commit, $scrapvil ) = @_;
    my $pllist = $vil->getpllist();
    my $textrs = $sow->{'textrs'};

    return if ( $vil->{'epilogue'} < $vil->{'turn'} );    # �I���ς�

    # �m��҂������̋����m��
    &FixQueUpdateSession( $sow, $vil );

    # ���Ԃ�i�߂�
    &UpdateTurn( $sow, $vil, $commit );

    if ( $vil->{'epilogue'} < $vil->{'turn'} ) {

        # �I��
        require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
        my $vindex = SWFileVIndex->new($sow);
        $vindex->openvindex();
        my $vi        = $vindex->getvindex( $vil->{'vid'} );
        my $vstatusid = $sow->{'VSTATUSID_END'};
        $vstatusid = $sow->{'VSTATUSID_SCRAPEND'}
          if ( $vi->{'vstatus'} eq $sow->{'VSTATUSID_SCRAP'} );
        $vindex->updatevindex( $vil, $vstatusid );
        $vindex->closevindex();

        # �u�Q�����̑��v�f�[�^�̍X�V
        $vil->updateentriedvil(-1);
    }
    else {
        # ���O�E�����f�[�^�t�@�C���̍쐬
        $pos = 0;
        my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 1 );
        require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
        my $memofile = SWSnake->new( $sow, $vil, $vil->{'turn'}, 1 );

        my $winner = 0;
        if ( $scrapvil == 0 ) {

            # �ˑR��
            my ( $history, $suddendeathpl ) = &SuddenDeath( $sow, $vil, $logfile )
              if ( $sow->{'cfg'}->{'ENABLED_SUDDENDEATH'} > 0 );

            # �ˑR���҂̗�\����ǋL
            &AddMediumHistory( $sow, $vil, $history );

            # �\�͑Ώۃ����_���w�莞����
            &SetRandomTarget( $sow, $vil, $logfile );

            # �s�N�V�[�^�L���[�s�b�h����
            &SetBondsTarget( $sow, $vil, $logfile ) if ( $vil->{'turn'} == 2 );

            # ���Y���[
            my $executepl;
            if ( $vil->{'turn'} > 2 ) {
                ( $history, $executepl ) = &Execution( $sow, $vil, $logfile );

                # ���Y�҂̗�\����ǋL
                &AddMediumHistory( $sow, $vil, $history );
            }

            # �肢�E��E
            my ( $hampl, $seertargetpl ) = &Seer( $sow, $vil, $logfile );

            # �P���挈��
            my $targetpl;
            $targetpl = &SelectKill( $sow, $vil, $logfile );

            # ��q�Ώە\��
            my $guardtargetpl;
            if ( $vil->{'turn'} > 2 ) {
                $guardtargetpl = &WriteGuardTarget( $sow, $vil, $logfile );
            }

            # �P��
            &Kill( $sow, $vil, $logfile, $targetpl, $hampl );

            my $livepllist = $vil->getlivepllist();

            # �l�T���o��
            if ( $sow->{'cfg'}->{'ENABLED_SCORE'} > 0 ) {
                require "$sow->{'cfg'}->{'DIR_LIB'}/score.pl";
                my $score = SWScore->new( $sow, $vil, 0 );
                if ( defined( $score->{'file'} ) ) {
                    my @killtargetpl;
                    push( @killtargetpl, $targetpl ) if ( defined($targetpl) );
                    $score->writeupdate( $vil->{'turn'}, $suddendeathpl, $executepl,
                        $seertargetpl, $guardtargetpl, \@killtargetpl );
                }
                $score->close();
            }

            # ��������
            my ( $humen, $wolves ) = &GetCountHumenWolves( $sow, $vil );
            if ( $wolves == 0 ) {

                # ���l������
                $winner = 1;
            }
            elsif ( $humen <= $wolves ) {

                # �l�T������
                $winner = 2;
            }

            # �n���X�^�[�l��/�R�E�����l�ԏ�������
            if ( $winner != 0 ) {
                foreach (@$livepllist) {
                    if ( $_->ishamster() > 0 ) {
                        $winner += 2;
                        last;
                    }
                }
            }
        }

        if ( ( $winner > 0 ) || ( $scrapvil > 0 ) ) {    # �Q�[���I��
                                                         # �I�����b�Z�[�W
            my $epinfo = $sow->{'textrs'}->{'ANNOUNCE_WINNER'}->[$winner];
            $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $epinfo );

            # �z���ꗗ
            $logfile->writeinfo( '', $sow->{'MESTYPE_CAST'}, '*CAST*' );

            # ���ꗗ���̍X�V
            my $vstatusid = $sow->{'VSTATUSID_EP'};
            $vstatusid = $sow->{'VSTATUSID_SCRAP'} if ( $winner == 0 );
            require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
            my $vindex = SWFileVIndex->new($sow);
            $vindex->openvindex();
            $vindex->updatevindex( $vil, $vstatusid );
            $vindex->closevindex();

            $vil->{'winner'}   = $winner;
            $vil->{'epilogue'} = $vil->{'turn'};

            # �u�Q�����̑��v�f�[�^�̍X�V
            $vil->updateentriedvil(0);

            # ��т̍X�V
            $vil->addappend();
        }
        else {
            if ( $vil->{'turn'} == 2 ) {

                # �Q���ڊJ�n�A�i�E���X
                $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $textrs->{'ANNOUNCE_FIRST'}->[2] );
            }

            # �����ҕ\��
            my @livesnamelist;
            my $livepllist = $vil->getlivepllist();
            my $livescnt   = @$livepllist;
            foreach (@$livepllist) {
                push( @livesnamelist, $_->getchrname() );
            }
            my $livesnametext =
              join( $sow->{'textrs'}->{'ANNOUNCE_LIVES'}->[1], @livesnamelist );
            my $livesnametextend = $sow->{'textrs'}->{'ANNOUNCE_LIVES'}->[2];
            $livesnametextend =~ s/_LIVES_/$livescnt/g;
            $livesnametext = $sow->{'textrs'}->{'ANNOUNCE_LIVES'}->[0] . $livesnametext . $livesnametextend;
            $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $livesnametext );

            # �蔲���B���̂����������B
            require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
            my $vindex = SWFileVIndex->new($sow);
            $vindex->openvindex();
            $vindex->updatevindex( $vil, $sow->{'VSTATUSID_PLAY'} );
            $vindex->closevindex();
        }

        # ������������
        $vil->setsaycountall();

        # �������[��̐ݒ�
        &SetInitVoteTarget( $sow, $vil, $logfile );

        $logfile->close();
        $memofile->close();
    }
    $vil->writevil();

    my $nextupdatedt = $sow->{'dt'}->cvtdt( $vil->{'nextupdatedt'} );
    $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'},
        "Update Session. [uid=$sow->{'uid'}, vid=$vil->{'vid'}, next=$nextupdatedt]" );

    return;
}

#----------------------------------------
# �肢�E��\����̎擾
#----------------------------------------
sub GetResultSeer {
    my ( $sow, $targetpl ) = @_;
    my $result = $sow->{'textrs'}->{'RESULT_SEER'}->[1];
    $result = $sow->{'textrs'}->{'RESULT_SEER'}->[2]
      if ( $targetpl->iswolf() > 0 );    # �l�T/���T/�q�T
    my $chrname     = $targetpl->getchrname();
    my $result_seer = $sow->{'textrs'}->{'RESULT_SEER'}->[0];
    $result_seer =~ s/_NAME_/$chrname/g;
    $result_seer =~ s/_RESULT_/$result/g;

    return "$result_seer<br>";
}

#----------------------------------------
# �ˑR������
#----------------------------------------
sub SuddenDeath {
    my ( $sow, $vil, $logfile ) = @_;
    my $saycnt = $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} };

    my $history;
    my $livepllist = $vil->getlivepllist();
    my @suddendeathpl;
    foreach (@$livepllist) {
        next if ( $_->{'saidcount'} > 0 );    # �������Ă���Ώ��O

        $_->{'live'}     = 'suddendead';      # ���S
        $_->{'deathday'} = $vil->{'turn'};    # ���S��
        push( @suddendeathpl, $_ );
        my $user = SWUser->new($sow);
        $user->writeentriedvil( $_->{'uid'}, $vil->{'vid'}, $_->getchrname(), 0, 1 );
        $user->addsdpenalty();
        $user->writeuser();
        $user->closeuser();

        # �ˑR�����b�Z�[�W�o��
        my $chrname = $_->getchrname();
        my $mes     = $sow->{'textrs'}->{'SUDDENDEATH'};
        $mes =~ s/_NAME_/$chrname/;
        $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $mes );

        # �ˑR���ʒm�i�������j
        if ( $sow->{'cfg'}->{'ENABLED_NOTICE_SD'} > 0 ) {
        }

        # ��\����
        my $mediumresult = &GetResultSeer( $sow, $_ );
        $history = $history . $mediumresult;

        &Suicide( $sow, $vil, $_, $logfile );    # ��ǂ�
    }

    return ( $history, \@suddendeathpl );
}

#----------------------------------------
# ��\���茋�ʂ̒ǋL
#----------------------------------------
sub AddMediumHistory {
    my ( $sow, $vil, $history ) = @_;

    return if ( !defined($history) );
    return if ( $history eq '' );

    my $livepllist = $vil->getlivepllist();
    foreach (@$livepllist) {
        if ( $_->{'role'} == $sow->{'ROLEID_MEDIUM'} ) {
            $_->{'history'} .= $history;
        }
    }

    return;
}

#----------------------------------------
# �\�͑Ώۃ����_���w�莞����
#----------------------------------------
sub SetRandomTarget {
    my ( $sow, $vil, $logfile ) = @_;
    my $abirole    = $sow->{'textrs'}->{'ABI_ROLE'};
    my $livepllist = $vil->getlivepllist();

    my $srcpl;
    foreach $srcpl (@$livepllist) {
        my $ability = $abirole->[ $srcpl->{'role'} ];
        if ( $ability ne '' ) {
            if ( $srcpl->{'target'} == $sow->{'TARGETID_RANDOM'} ) {

                # �����_���Ώ�
                my $chrname = $srcpl->getchrname();
                my $srctargetpno;
                if ( $srcpl->{'role'} == $sow->{'ROLEID_TRICKSTER'} ) {
                    $srctargetpno = $srcpl->{'target2'}
                      if ( ( $srcpl->{'target2'} >= 0 )
                        && ( $srcpl->{'live'} eq 'live' ) );
                }
                &SetRandomTargetSingle( $sow, $vil, $srcpl, 'target', $logfile, $srctargetpno );
            }

            if (   ( $srcpl->{'role'} == $sow->{'ROLEID_TRICKSTER'} )
                && ( $srcpl->{'target2'} == $sow->{'TARGETID_RANDOM'} ) )
            {
                &SetRandomTargetSingle( $sow, $vil, $srcpl, 'target2', $logfile, $srcpl->{'target'} );
            }
        }
    }
}

#----------------------------------------
# �\�͑Ώۃ����_�������i�P�Ɓj
#----------------------------------------
sub SetRandomTargetSingle {
    my ( $sow, $vil, $plsingle, $targetid, $logfile, $srctargetpno ) = @_;

    # �����_������
    my $targetlist = $plsingle->gettargetlist( $targetid, $srctargetpno );
    if ( @$targetlist == 0 ) {

        # �Ώی�₪���݂��Ȃ�
        $plsingle->{$targetid} = -1;
        $logfile->writeinfo(
            $plsingle->{'uid'},
            $sow->{'MESTYPE_INFOSP'},
            $plsingle->getchrname() . "�̑Ώ�($targetid)��₪����܂���B"
        );
        return;
    }

    $plsingle->{$targetid} =
      $targetlist->[ int( rand(@$targetlist) ) ]->{'pno'};
    $targetpl = $vil->getplbypno( $plsingle->{$targetid} );

    #	my $listtext = "��" . $plsingle->getchrname() . "�̑����⁚<br>";
    #	foreach(@$targetlist) {
    #		$listtext .= "$_->{'chrname'}<br>";
    #	}
    #	$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $listtext);

    # ���O��������
    my $chrname    = $plsingle->getchrname();
    my $ability    = $sow->{'textrs'}->{'ABI_ROLE'}->[ $plsingle->{'role'} ];
    my $targetname = $targetpl->getchrname();
    my $randomtext = $sow->{'textrs'}->{'SETRANDOMTARGET'};
    $randomtext =~ s/_NAME_/$chrname/g;
    $randomtext =~ s/_ABILITY_/$ability/g;
    $randomtext =~ s/_TARGET_/$targetname/g;
    $logfile->writeinfo( $plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $randomtext );

    return $targetpl;
}

#----------------------------------------
# �s�N�V�[�^�L���[�s�b�h����
#----------------------------------------
sub SetBondsTarget {
    my ( $sow, $vil, $logfile ) = @_;
    my $abirole = $sow->{'textrs'}->{'ABI_ROLE'};

    my $livepllist = $vil->getlivepllist();
    foreach $plsingle (@$livepllist) {
        next if ( $plsingle->{'role'} != $sow->{'ROLEID_TRICKSTER'} );

        my $chrname = $plsingle->getchrname();

        # �J�̒ǉ�
        my $targetpl  = $vil->getplbypno( $plsingle->{'target'} );
        my $target2pl = $vil->getplbypno( $plsingle->{'target2'} );

        if ( $targetpl->{'live'} ne 'live' ) {

            # �ݒ�ΏۂP���ˑR�����Ă��鎞
            my $srctargetpno;
            $srctargetpno = $plsingle->{'target2'}
              if ( ( $plsingle->{'target2'} >= 0 )
                && ( $target2pl->{'live'} eq 'live' ) );
            $targetpl = &SetRandomTargetSingle( $sow, $vil, $plsingle, 'target', $logfile, $srctargetpno );
        }

        if ( $target2pl->{'live'} ne 'live' ) {

            # �ݒ�ΏۂQ���ˑR�����Ă��鎞
            $target2pl = &SetRandomTargetSingle( $sow, $vil, $plsingle, 'target2', $logfile, $plsingle->{'target'} );
        }

        if ( ( $plsingle->{'target'} < 0 ) || ( $plsingle->{'target2'} < 0 ) ) {

            # �Ώی�₪���݂��Ȃ�
            my $ability =
              $sow->{'textrs'}->{'ABI_ROLE'}->[ $plsingle->{'role'} ];
            my $canceltarget = $sow->{'textrs'}->{'CANCELTARGET'};
            $canceltarget =~ s/_NAME_/$chrname/g;
            $canceltarget =~ s/_ABILITY_/$ability/g;
            $logfile->writeinfo( $plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $canceltarget );
            return;
        }

        $targetpl->addbond( $plsingle->{'target2'} );
        $target2pl->addbond( $plsingle->{'target'} );

        my $result_trickster = $sow->{'textrs'}->{'EXECUTETRICKSTER'};
        my $targetname       = $targetpl->getchrname();
        my $target2name      = $target2pl->getchrname();
        $result_trickster =~ s/_NAME_/$chrname/g;
        $result_trickster =~ s/_TARGET1_/$targetname/g;
        $result_trickster =~ s/_TARGET2_/$target2name/g;
        $logfile->writeinfo( $plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result_trickster );
    }
}

#----------------------------------------
# ���Y����
#----------------------------------------
sub Execution {
    my ( $sow, $vil, $logfile ) = @_;
    my $history;
    my $pllist     = $vil->getpllist();
    my $livepllist = $vil->getlivepllist();

    # ���[���̏�����
    my @votes;
    my $i;
    for ( $i = 0 ; $i < @$pllist ; $i++ ) {
        $votes[$i] = 0;
    }

    # �ˑR���D�擊�[�����i�������j

    # �����_���ϔC
    foreach (@$livepllist) {
        $_->{'randomentrust'} = '';
        if (   ( $_->{'entrust'} > 0 )
            && ( $_->{'vote'} == $sow->{'TARGETID_RANDOM'} ) )
        {
            $_->{'vote'} = $livepllist->[ rand( @$livepllist - 1 ) ]->{'pno'};
            $_->{'vote'} = $livepllist->[$#$livepllist]->{'pno'}
              if ( $_->{'vote'} == $_->{'pno'} );
            $_->{'randomentrust'} = $sow->{'textrs'}->{'RANDOMENTRUST'};
        }
    }

    # �ϔC���[����
    my $curpl;
    foreach $curpl (@$livepllist) {
        my @entrusts;
        my $srcpl = $curpl;
        $i = 0;

        while ( $srcpl->{'entrust'} > 0 ) {

            # ���[�𑼐l�ɈϔC���Ă���l��z��ɒǉ�
            push( @entrusts, $srcpl );
            $i++;
            $srcpl = $vil->getplbypno( $srcpl->{'vote'} );
            if ( ( $i > @$livepllist ) || ( $srcpl->{'live'} ne 'live' ) ) {

                # �ϔC���[�v�ɓ����Ă��鎞
                # �i���͈ϔC�悪���҂̎��j
                foreach (@entrusts) {
                    next if ( $_->{'entrust'} <= 0 );

                    # ���[��������_���ɐݒ�
                    my $entrusttext =
                      $sow->{'textrs'}->{'ANNOUNCE_ENTRUST'}->[1];
                    my $chrname    = $_->getchrname();
                    my $targetpl   = $vil->getplbypno( $_->{'vote'} );
                    my $targetname = $targetpl->getchrname();
                    $entrusttext =~ s/_NAME_/$chrname/g;
                    $entrusttext =~ s/_TARGET_/$targetname/g;
                    $entrusttext =~ s/_RANDOM_/$_->{'randomentrust'}/g;
                    $logfile->writeinfo( $_->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $entrusttext );
                    $_->{'vote'}    = -1;
                    $_->{'entrust'} = -1;
                }
                @entrusts = ();
                last;
            }
        }

        if ( @entrusts > 0 ) {

            # �ϔC���Ă��鎞
            my $entrust;
            my $targetname = $srcpl->getchrname();
            for ( $i = 0 ; $i < @entrusts ; $i++ ) {
                $entrusts[$i]->{'vote'}    = $srcpl->{'vote'};
                $entrusts[$i]->{'entrust'} = 0;

                my $randomvote = 0;
                if (   ( $entrusts[$i]->{'vote'} == $entrusts[$i]->{'pno'} )
                    || ( $srcpl->{'entrust'} < 0 ) )
                {
                    # �����_�����[
                    $randomvote = 1;
                    $entrusts[$i]->{'vote'} = -1;
                }

                # �ϔC���b�Z�[�W�\��
                my $entrusttext =
                  $sow->{'textrs'}->{'ANNOUNCE_ENTRUST'}->[$randomvote];
                my $chrname = $entrusts[$i]->getchrname();
                $entrusttext =~ s/_NAME_/$chrname/g;
                $entrusttext =~ s/_TARGET_/$targetname/g;
                $entrusttext =~ s/_RANDOM_/$entrusts[$i]->{'randomentrust'}/g;
                $logfile->writeinfo( $entrusts[$i]->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $entrusttext );
            }
            next;
        }

    }

    # ���[���ʏW�v���\��
    my $votestext;
    foreach (@$livepllist) {
        my $randomvote = '';
        if ( $_->{'vote'} < 0 ) {
            $_->{'vote'} = $livepllist->[ rand( @$livepllist - 1 ) ]->{'pno'};
            if ( $_->{'vote'} == $_->{'pno'} ) {
                $_->{'vote'} = $livepllist->[$#$livepllist]->{'pno'};
            }
            $randomvote = $sow->{'textrs'}->{'ANNOUNCE_RANDOMVOTE'};
        }
        $votes[ $_->{'vote'} ]++;

        # �e���[����
        my $chrname  = $_->getchrname();
        my $votepl   = $vil->getplbypno( $_->{'vote'} );
        my $votename = $votepl->getchrname();

        my $votetext = $sow->{'textrs'}->{'ANNOUNCE_VOTE'}->[0];
        $votetext =~ s/_NAME_/$chrname/g;
        $votetext =~ s/_TARGET_/$votename/g;
        $votetext =~ s/_RANDOM_/$randomvote/g;
        $votestext = $votestext . "$votetext<br>"
          if ( $vil->{'votetype'} eq 'sign' );

        $logfile->writeinfo( $_->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $votetext )
          if ( $vil->{'votetype'} ne 'sign' );
    }

    # ���L�����[�̓��[���ʕ\��
    for ( $i = 0 ; $i < @votes ; $i++ ) {
        next if ( $votes[$i] == 0 );

        my $targetpl = $vil->getplbypno($i);
        my $chrname  = $targetpl->getchrname();
        my $votetext = $sow->{'textrs'}->{'ANNOUNCE_VOTE'}->[1];
        $votetext =~ s/_NAME_/$chrname/g;
        $votetext =~ s/_COUNT_/$votes[$i]/g;

        $votestext = $votestext . "$votetext<br>"
          if ( $vil->{'votetype'} ne 'sign' );
    }

    # �ő哾�[���̃`�F�b�N
    my $maxvote = 0;
    for ( $i = 0 ; $i < @votes ; $i++ ) {
        $maxvote = $votes[$i] if ( $maxvote < $votes[$i] );
    }

    return if ( $maxvote == 0 );    # ���Y��₪���Ȃ��i�S���ˑR���H�j

    # �ő哾�[�҂̎擾
    my @lastvote;
    for ( $i = 0 ; $i < @votes ; $i++ ) {
        push( @lastvote, $i ) if ( $votes[$i] == $maxvote );
    }

    return if ( @lastvote == 0 );    # ���Y��₪���Ȃ��i�S���ˑR���H�j

    # ���Y�Ώۂ̌���
    my $execution = $lastvote[ int( rand(@lastvote) ) ];
    my $executepl = $vil->getplbypno($execution);
    my @executedpl;
    if ( $executepl->{'live'} eq 'live' ) {

        # ���Y
        my $chrname  = $executepl->getchrname();
        my $votetext = $sow->{'textrs'}->{'ANNOUNCE_VOTE'}->[2];
        $votetext =~ s/_NAME_/$chrname/g;
        $votestext               = $votestext . "<br>$votetext";
        $executepl->{'live'}     = 'executed';
        $executepl->{'deathday'} = $vil->{'turn'};
        my $user = SWUser->new($sow);
        $user->writeentriedvil( $executepl->{'uid'}, $vil->{'vid'}, $executepl->getchrname(), 0 );

        # ��\����
        my $mediumresult = &GetResultSeer( $sow, $executepl );
        $history .= $mediumresult;
        push( @executedpl, $executepl );
    }

    # ���[���ʂ̏o��
    $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $votestext );

    &Suicide( $sow, $vil, $executepl, $logfile );    # ��ǂ�

    return ( $history, \@executedpl );
}

#----------------------------------------
# ��ǂ�����
#----------------------------------------
sub Suicide {
    my ( $sow, $vil, $deadpl, $logfile ) = @_;

    my @bonds = split( '/', $deadpl->{'bonds'} . '/' );
    my $chrname = $deadpl->getchrname();
    foreach (@bonds) {
        my $targetpl = $vil->getplbypno($_);
        if ( $targetpl->{'live'} eq 'live' ) {
            $targetpl->{'live'}     = 'suicide';
            $targetpl->{'deathday'} = $vil->{'turn'};
            my $user = SWUser->new($sow);
            $user->writeentriedvil( $targetpl->{'uid'}, $vil->{'vid'}, $targetpl->getchrname(), 0 );

            my $suicidetext = $sow->{'textrs'}->{'SUICIDEBONDS'};
            my $targetname  = $targetpl->getchrname();
            $suicidetext =~ s/_TARGET_/$chrname/g;
            $suicidetext =~ s/_NAME_/$targetname/g;
            $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $suicidetext );
            &Suicide( $sow, $vil, $targetpl, $logfile );    # ��ǂ��A��
        }
    }
}

#----------------------------------------
# �肢����
#----------------------------------------
sub Seer {
    my ( $sow, $vil, $logfile ) = @_;
    my @seertargetpl;
    my @hampl;

    my $livepllist = $vil->getlivepllist();
    foreach (@$livepllist) {
        if ( $_->{'role'} eq $sow->{'ROLEID_SEER'} ) {

            # �肢����
            my $seername   = $_->getchrname();
            my $targetpl   = $vil->getplbypno( $_->{'target'} );
            my $targetname = $targetpl->getchrname();
            my $seerresult = GetResultSeer( $sow, $targetpl );
            $_->{'history'} .= $seerresult;

            # �n���E�R�E�����E�s�N�V�[��E
            if (   ( $targetpl->{'live'} eq 'live' )
                && ( $targetpl->ishamster() > 0 ) )
            {
                push( @hampl, $targetpl );
                $targetpl->{'live'}     = 'cursed';
                $targetpl->{'deathday'} = $vil->{'turn'};
                my $user = SWUser->new($sow);
                $user->writeentriedvil( $targetpl->{'uid'}, $vil->{'vid'}, $targetpl->getchrname(), 0 );
            }

            # ���T
            if (   ( $targetpl->{'live'} eq 'live' )
                && ( $targetpl->{'role'} == $sow->{'ROLEID_CWOLF'} ) )
            {
                push( @hampl, $_ );
                $_->{'live'}     = 'cursed';
                $_->{'deathday'} = $vil->{'turn'};
                my $user = SWUser->new($sow);
                $user->writeentriedvil( $_->{'uid'}, $vil->{'vid'}, $_->getchrname(), 0 );
            }

            # �肢��񏑂�����
            my $seertext = $sow->{'textrs'}->{'EXECUTESEER'};
            $seertext =~ s/_NAME_/$seername/g;
            $seertext =~ s/_TARGET_/$targetname/g;
            $logfile->writeinfo( $_->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $seertext );

            push( @seertargetpl, $targetpl );
        }
    }

    return ( \@hampl, \@seertargetpl );
}

#----------------------------------------
# �P���挈��
#----------------------------------------
sub SelectKill {
    my ( $sow, $vil, $logfile ) = @_;

    my $pllist     = $vil->getpllist();
    my $livepllist = $vil->getlivepllist();
    my $targetpl;    # �P���Ώ�

    # ���[���̏�����
    my @votes;
    my $i;
    for ( $i = 0 ; $i < @$pllist ; $i++ ) {
        $votes[$i] = 0;
    }

    # �P����W�v
    my $killtext = '';
    foreach (@$livepllist) {
        next if ( $_->iswolf() == 0 );    # �l�T/���T/�q�T�ȊO�͏��O
        $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'}, "KillTarget: $_->{'uid'}($_->{'pno'})=$_->{'target'}" );
        next if ( $_->{'target'} < 0 );    # ���܂����͏��O

        my $targetpl = $vil->getplbypno( $_->{'target'} );
        if ( $targetpl->iswolf() > 0 ) {

            # �Ώۂ��l�T/���T/�q�T�̏ꍇ�͏��O�i���肦�Ȃ��͂��j
            # �l�T/���T/�q�T���P���ΏۂƂ���̂Ȃ炱���̏�����ς���
            $sow->{'debug'}->writeaplog( $sow->{'APLOG_WARNING'},
                "target is a wolf.[wolfid=$_->{'uid'}, target=$targetpl->{'uid'}]" );
            next;
        }

        $votes[ $_->{'target'} ] += 1;
    }

    # �ő哾�[���̃`�F�b�N
    my $maxvote = 0;
    for ( $i = 0 ; $i < @votes ; $i++ ) {
        $maxvote = $votes[$i] if ( $maxvote < $votes[$i] );
    }

    if ( $maxvote > 0 ) {    # �S�����C���łȂ��ꍇ
                             # �P������̎擾
        my @lastvote;
        for ( $i = 0 ; $i < @votes ; $i++ ) {
            push( @lastvote, $i ) if ( $votes[$i] > 0 );
        }
        $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'}, "KillTarget(All): @lastvote" );

        # �P���Ώۂ̌���
        my $killtarget = $lastvote[ int( rand(@lastvote) ) ];
        $targetpl = $vil->getplbypno($killtarget);
        $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'}, "Final KillTarget: $killtarget" );

        # �P�����b�Z�[�W����
        if ( ( $vil->{'turn'} > 2 ) && ( $targetpl->{'live'} eq 'live' ) ) {

            # �_�~�[�L�����P�����͏��O����

            # �P�����b�Z�[�W
            my $chrname = $targetpl->getchrname();
            $killtext = $sow->{'textrs'}->{'EXECUTEKILL'};
            $killtext =~ s/_TARGET_/$chrname/g;

            # �P���Ҍ���
            my @murders;
            foreach (@$livepllist) {
                next if ( $_->iswolf() == 0 );                # �l�T/���T/�q�T�ȊO�͏��O
                next if ( $_->{'target'} != $killtarget );    # �P������҂ɓ��[���Ă��Ȃ��҂͏��O
                push( @murders, $_ );
            }
            my $murderpl = $murders[ int( rand(@murders) ) ];
            if ( !defined( $murderpl->{'uid'} ) ) {

                # �P���҂�����`�i���肦�Ȃ��͂��j
                $sow->{'debug'}->writeaplog( $sow->{'APLOG_WARNING'}, "murderpl is undef." );
            }
            else {
                # �P�����b�Z�[�W��������
                my %say = (
                    mestype    => $sow->{'MESTYPE_WSAY'},
                    logsubid   => $sow->{'LOGSUBID_SAY'},
                    uid        => $murderpl->{'uid'},
                    csid       => $murderpl->{'csid'},
                    cid        => $murderpl->{'cid'},
                    chrname    => $murderpl->getchrname(),
                    mes        => $killtext,
                    undef      => 1,                         # �����Ƃ��Ĉ���Ȃ�
                    expression => 0,
                    monospace  => 0,
                    loud       => 0,
                );
                $logfile->executesay( \%say );
            }
        }
    }

    return $targetpl;
}

#----------------------------------------
# ��q�Ώە\��
#----------------------------------------
sub WriteGuardTarget {
    my ( $sow, $vil, $logfile ) = @_;

    my $livepllist = $vil->getlivepllist();
    my @guardtargetpl;
    foreach (@$livepllist) {
        next if ( $_->{'role'} ne $sow->{'ROLEID_GUARD'} );    # ��l�ȊO�͏��O

        my $guardname  = $_->getchrname();
        my $targetpl   = $vil->getplbypno( $_->{'target'} );
        my $targetname = $targetpl->getchrname();
        my $guardtext  = $sow->{'textrs'}->{'EXECUTEGUARD'};
        $guardtext =~ s/_NAME_/$guardname/g;
        $guardtext =~ s/_TARGET_/$targetname/g;
        $logfile->writeinfo( $_->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $guardtext );

        push( @guardtargetpl, $targetpl );
    }

    return \@guardtargetpl;
}

#----------------------------------------
# �P��
#----------------------------------------
sub Kill {
    my ( $sow, $vil, $logfile, $targetpl, $deadpl ) = @_;
    my $livepllist = $vil->getlivepllist();

    my $deadtext = $sow->{'textrs'}->{'ANNOUNCE_KILL'}->[0];

    if (   ( defined( $targetpl->{'cid'} ) )
        && ( $targetpl->{'live'} eq 'live' ) )
    {
        my $targetname = $targetpl->getchrname();
        my $deadflag   = 'victim';
        if ( $vil->{'turn'} > 2 ) {

            # ��q����
            foreach (@$livepllist) {
                next if ( $_->{'role'} ne $sow->{'ROLEID_GUARD'} );    # ��l�ȊO�͏��O
                if ( $_->{'target'} == $targetpl->{'pno'} ) {
                    my $result_guard = $sow->{'textrs'}->{'RESULT_GUARD'};
                    $result_guard =~ s/_TARGET_/$targetname/g;
                    $_->{'history'} .= "$result_guard<br>"
                      if ( defined( $targetpl->{'uid'} ) );
                    $deadflag = 'live';
                }
            }
        }
        if (   ( $targetpl->{'live'} eq 'live' )
            && ( $targetpl->ishamster() > 0 ) )
        {
            # �n���X�^�[�l�Ԃ͏P���Ŏ��ȂȂ��B
            $deadflag = 'live';
        }

        $targetpl->{'live'} = $deadflag;
        if ( $deadflag ne 'live' ) {
            push( @$deadpl, $targetpl );
            $targetpl->{'deathday'} = $vil->{'turn'};
            my $user = SWUser->new($sow);
            $user->writeentriedvil( $targetpl->{'uid'}, $vil->{'vid'}, $targetpl->getchrname(), 0 );

            # �P�����ʒǋL
            foreach (@$livepllist) {
                if ( $_->iswolf() > 0 ) {
                    my $result_kill = $sow->{'textrs'}->{'RESULT_KILL'};
                    $result_kill = $sow->{'textrs'}->{'RESULT_KILLIW'}
                      if ( $_->{'role'} == $sow->{'ROLEID_INTWOLF'} );
                    $result_kill =~ s/_TARGET_/$targetname/g;
                    $result_kill =~ s/_ROLE_/$sow->{'textrs'}->{'ROLENAME'}->[$targetpl->{'role'}]/g;
                    $_->{'history'} .= "$result_kill<br>";
                }
            }
        }
    }

    # ���S�ҕ\��
    my $i;
    my $deadplcnt = @$deadpl;
    if ( $deadplcnt == 0 ) {

        # ���S�Җ���
        $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $deadtext );
    }
    else {
        # ���S�ҕ\��
        for ( $i = 0 ; $i < $deadplcnt ; $i++ ) {
            my $deadtextpl = splice( @$deadpl, int( rand(@$deadpl) ), 1 );
            my $deadchrname = $deadtextpl->getchrname();
            $deadtext = $sow->{'textrs'}->{'ANNOUNCE_KILL'}->[1];
            $deadtext =~ s/_TARGET_/$deadchrname/g;
            $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $deadtext );
            &Suicide( $sow, $vil, $deadtextpl, $logfile );    # ��ǂ�
        }
    }

    return;
}

#----------------------------------------
# �l�ԁE�l�T�̐l�����擾�i��������p�j
#----------------------------------------
sub GetCountHumenWolves {
    my ( $sow, $vil ) = @_;
    my $livepllist = $vil->getlivepllist();

    my $humen      = 0;
    my $wolves     = 0;
    my $cpossesses = 0;
    my $hamsters   = 0;
    foreach (@$livepllist) {
        if ( $_->iswolf() > 0 ) {
            $wolves++;
        }
        elsif ( $_->{'role'} == $sow->{'ROLEID_CPOSSESS'} ) {
            $cpossesses++;
        }
        elsif ( $_->ishamster() > 0 ) {
            $hamsters++;
        }
        else {
            $humen++;
        }
    }
    $humen += $cpossesses if ( ( $hamsters > 0 ) && ( $cpossesses > 0 ) );

    return ( $humen, $wolves );
}

#----------------------------------------
# �������[��̐ݒ�
#----------------------------------------
sub SetInitVoteTarget {
    my ( $sow, $vil, $logfile ) = @_;
    my $livepllist = $vil->getlivepllist();

    $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'}, "Start: SetInitVoteTarget." );
    my $liveplcnt = @$livepllist;
    $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'}, "LivePL: @$livepllist" );
    foreach (@$livepllist) {
        &SetInitVoteTargetSingle( $sow, $vil, $_, 'vote',   $logfile );
        &SetInitVoteTargetSingle( $sow, $vil, $_, 'target', $logfile );
        &SetInitVoteTargetSingle( $sow, $vil, $_, 'target2', $logfile, $_->{'target'} )
          if ( $_->{'role'} == $sow->{'ROLEID_TRICKSTER'} );

        if ( $_->iswolf() > 0 ) {
            if ( $vil->{'turn'} != 1 ) {
                $_->{'target'} = $sow->{'TARGETID_TRUST'};    # �l�T�͂��܂���
                $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'},
                    "ChangeTarget UNDEF (Wolf): $_->{'uid'}($_->{'pno'})=$_->{'target'}" );
            }
        }
    }
    $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'}, "End: SetInitVoteTarget." );

    return;
}

#----------------------------------------
# �������[��^�\�͑Ώۂ̐ݒ�
#----------------------------------------
sub SetInitVoteTargetSingle {
    my ( $sow, $vil, $plsingle, $targetid, $logfile, $srctargetpno ) = @_;

    my $targetlist = $plsingle->gettargetlist( $targetid, $srctargetpno );

    #	my $listtext = "��" . $plsingle->getchrname() . "�̏����Ώ�($targetid)��⁚<br>";
    if ( @$targetlist > 0 ) {
        $plsingle->{$targetid} =
          $targetlist->[ int( rand(@$targetlist) ) ]->{'pno'};
        $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'},
            "SetInitVote/Target[$targetid]: $plsingle->{'uid'}($plsingle->{'pno'})=randtarget" );

        #		foreach(@$targetlist) {
        #			$listtext .= "$_->{'chrname'}<br>";
        #		}
        #		my $targetname = $vil->getplbypno($plsingle->{$targetid})->getchrname();
        #		$listtext .= "<br>�����F$targetname";
    }
    else {
        #		$listtext .= '�Ώۂ�����܂���B';
    }

    #	$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $listtext);

    return;
}

#----------------------------------------
# �m��҂������̋����m��
#----------------------------------------
sub FixQueUpdateSession {
    my ( $sow, $vil ) = @_;

    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
    my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );
    $logfile->fixque(1);
    $logfile->close();
}

#----------------------------------------
# ���Ԃ�i�߂�
#----------------------------------------
sub UpdateTurn {
    my ( $sow, $vil, $commit ) = @_;

    $vil->{'turn'} += 1;
    $vil->{'cntmemo'} = 0;
    $vil->{'nextupdatedt'} = $sow->{'dt'}->getnextupdatedt( $vil, $sow->{'time'}, $vil->{'updinterval'}, $commit );

    #	$vil->{'nextchargedt'} = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, 1, $commit);
    $vil->{'nextchargedt'} = $sow->{'time'} + 24 * 60 * 60;
    $sow->{'turn'} += 1;
}

1;
