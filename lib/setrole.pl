package SWSetRole;

#----------------------------------------
# ��E�z�����蓖��
#----------------------------------------
sub SetRole {
    my ( $sow, $vil ) = @_;
    my $textrs   = $sow->{'textrs'};
    my $rolename = $textrs->{'ROLENAME'};

    my $pllist = $vil->getpllist();
    my $roletable =
      &GetSetRoleTable( $sow, $vil, $vil->{'roletable'}, scalar(@$pllist) );

    my ( $i, @roles );

    # �e��E�p�̔z���p��
    for ( $i = 0 ; $i < $sow->{'COUNT_ROLE'} ; $i++ ) {
        my @rolepllist;
        $roles[$i] = \@rolepllist;

        #		print "[$i] $rolename->[$i]\n";
    }

    # ��E��]��ID����]������E�̔z��Ɋi�[
    for (@$pllist) {
        next if ( $_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'} );
        my $rolepllist = $roles[ $_->{'selrole'} ];
        $rolepllist = $roles[0]
          if ( $vil->{'noselrole'} > 0 );    # ��E��]�𖳎����āA�S�������܂�����
        push( @$rolepllist, $_ );
    }

    for ( $i = 1 ; $i < $sow->{'COUNT_ROLE'} ; $i++ ) {
        my $rolepllist = $roles[$i];

        #		print "[matrix] $roletable->[$i]\n";

        # ���Ԃꂽ�l�����܂����z��Ɉړ�
        while ( $roletable->[$i] < @$rolepllist ) {
            my $freepllist = $roles[0];                   # ���܂����z��
            my $pno        = int( rand(@$rolepllist) );

            # ���܂����z��ֈړ�
            my $movepl = splice( @$rolepllist, $pno, 1 );
            push( @$freepllist, $movepl );
        }
    }

    # ���蓖�Ĉꗗ�\���i�e�X�g�p�j
    #	for ($i = 0; $i < @$rolename; $i++) {
    #		my $pid = $roles[$i];
    #		my $n = @$pid;
    #		print "[$rolename->[$i]] $n\n";
    #	}

    # ���܂����̐l���󂢂Ă����E�֊��蓖��
    for ( $i = 1 ; $i < $sow->{'COUNT_ROLE'} ; $i++ ) {
        my $rolepllist = $roles[$i];

        while ( $roletable->[$i] > @$rolepllist ) {
            my $freepllist = $roles[0];
            my $pno        = int( rand(@$freepllist) );
            my $movepl     = splice( @$freepllist, $pno, 1 );
            push( @$rolepllist, $movepl );
        }
    }

    # �e�X�g�p
    #	for ($i = 0; $i < @$rolename; $i++) {
    #		my $pid = $roles[$i];
    #		my $n = @$pid;
    #		print "[$rolename->[$i]] $n\n";
    #	}

    # ��E������
    my $dummypl = $vil->getpl( $sow->{'cfg'}->{'USERID_NPC'} );
    $dummypl->{'role'} = $sow->{'ROLEID_VILLAGER'};    # �_�~�[�L����
    for ( $i = 1 ; $i < $sow->{'COUNT_ROLE'} ; $i++ ) {
        my $rolepllist = $roles[$i];
        foreach (@$rolepllist) {
            if ( !defined( $_->{'role'} ) ) {

                # $_������`�i���肦�Ȃ��͂��j
                $sow->{'debug'}->writeaplog( $sow->{'APLOG_WARNING'}, 'invalid pl. [setrole.]' );
            }
            $_->{'role'}      = $i;
            $_->{'rolesubid'} = -1;
        }
    }

    # ���蓖�Ĉꗗ�\���i�e�X�g�p�j
    #	foreach (@$pllist) {
    #		print "[$_->{'uid'}] $rolename->[$_->{'selrole'}] �� $rolename->[$_->{'role'}]\n";
    #	}

    # ���L�ҏ���
    &SetFreeMasonHistory( $sow, $vil, $sow->{'ROLEID_FM'} );

    # ���ҏ���
    &SetFreeMasonHistory( $sow, $vil, $sow->{'ROLEID_SYMPATHY'} );

    # �����ҏ���
    my $stigma = &GetPlRole( $sow, $vil, $sow->{'ROLEID_STIGMA'} );
    if ( @$stigma > 1 ) {
        my $i;
        my $loopcount = @$stigma;
        for ( $i = 0 ; $i < $loopcount ; $i++ ) {
            my $stigmano = int( rand(@$stigma) );
            my $stigmapl = splice( @$stigma, $stigmano, 1 );
            $stigmapl->{'rolesubid'} = $i;
        }
    }

    # ���M�ҏ���
    my $fanatic = &GetPlRole( $sow, $vil, $sow->{'ROLEID_FANATIC'} );
    my $wolves  = &GetPlRole( $sow, $vil, $sow->{'ROLEID_WOLF'} );
    my $cwolves = &GetPlRole( $sow, $vil, $sow->{'ROLEID_CWOLF'} );
    push( @$wolves, @$cwolves );
    my $intwolves = &GetPlRole( $sow, $vil, $sow->{'ROLEID_INTWOLF'} );
    push( @$wolves, @$intwolves );

    my $history = '';
    my $wolfpl;
    foreach $wolfpl (@$wolves) {
        my $chrname        = $wolfpl->getchrname();
        my $result_fanatic = $textrs->{'RESULT_FANATIC'};
        $result_fanatic =~ s/_NAME_/$chrname/g;
        $history .= "$result_fanatic<br>";
    }
    foreach (@$fanatic) {
        $_->{'history'} = $history;
    }

    # �\�͗���\���i�e�X�g�p�j
    #	foreach (@$pllist) {
    #		print "[$_->{'uid'}] $_->{'history'}\n";
    #	}

}

#----------------------------------------
# �w�肵���\�͎҂̔z����擾
#----------------------------------------
sub GetPlRole {
    my ( $sow, $vil, $role ) = @_;
    my $pllist = $vil->getpllist();

    my @rolepl;
    foreach (@$pllist) {
        push( @rolepl, $_ ) if ( $_->{'role'} == $role );
    }

    return \@rolepl;
}

#----------------------------------------
# �z���\�̎擾
#----------------------------------------
sub GetSetRoleTable {
    my ( $sow, $vil, $roletable, $plcnt ) = @_;

    my @roles;
    my $i;
    for ( $i = 0 ; $i < $sow->{'COUNT_ROLE'} ; $i++ ) {
        $roles[$i] = 0;
    }

    if ( $roletable eq 'hamster' ) {

        # �n������z���\�̎擾
        &GetSetRoleTableHamster( $sow, $plcnt, \@roles );

    }
    elsif ( $roletable eq 'wbbs_c' ) {

        # �b���z���\�̎擾
        &GetSetRoleTableWBBS_C( $sow, $plcnt, \@roles );

    }
    elsif ( $roletable eq 'test1st' ) {

        # ������^�z���\�̎擾
        &GetSetRoleTableTest1st( $sow, $plcnt, \@roles );

    }
    elsif ( $roletable eq 'test2nd' ) {

        # ������^�z���\�̎擾
        &GetSetRoleTableTest2nd( $sow, $plcnt, \@roles );

    }
    elsif ( $roletable eq 'custom' ) {

        # �J�X�^���z���\�̎擾
        &GetSetRoleTableCustom( $sow, $vil, \@roles );

    }
    elsif ( $roletable eq 'wbbs_g' ) {

        # G���z���\�̎擾
        &GetSetRoleTableWBBS_G( $sow, $plcnt, \@roles );

    }
    else {
        # �W���z���\�̎擾
        &GetSetRoleTableDefault( $sow, $plcnt, \@roles );
    }

    return \@roles;
}

#----------------------------------------
# �W���z���\�̎擾
#----------------------------------------
sub GetSetRoleTableDefault {
    my ( $sow, $plcnt, $roles ) = @_;

    # �l�T
    $roles->[ $sow->{'ROLEID_WOLF'} ]++;
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 8 );
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 15 );
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 24 );

    # �肢�t
    $roles->[ $sow->{'ROLEID_SEER'} ]++;

    # ��\��
    $roles->[ $sow->{'ROLEID_MEDIUM'} ]++ if ( $plcnt >= 9 );

    # ���l
    $roles->[ $sow->{'ROLEID_POSSESS'} ]++ if ( $plcnt >= 10 );

    # ��l
    $roles->[ $sow->{'ROLEID_GUARD'} ]++ if ( $plcnt >= 11 );

    # ���L��
    $roles->[ $sow->{'ROLEID_FM'} ] += 2 if ( $plcnt >= 16 );

    # ���l
    my $total = 0;
    my $i;
    for ( $i = 0 ; $i < $sow->{'COUNT_ROLE'} ; $i++ ) {
        $total += $roles->[$i];
    }
    $roles->[ $sow->{'ROLEID_VILLAGER'} ] = $plcnt - $total - 1;

    return;
}

#----------------------------------------
# G���z���\�̎擾
#----------------------------------------
sub GetSetRoleTableWBBS_G {
    my ( $sow, $plcnt, $roles ) = @_;

    # �l�T
    $roles->[ $sow->{'ROLEID_WOLF'} ]++;
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 8 );
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 13 );
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 21 );

    # �肢�t
    $roles->[ $sow->{'ROLEID_SEER'} ]++;

    # ��\��
    $roles->[ $sow->{'ROLEID_MEDIUM'} ]++ if ( $plcnt >= 9 );

    # ���l
    $roles->[ $sow->{'ROLEID_POSSESS'} ]++ if ( $plcnt >= 11 );

    # ��l
    $roles->[ $sow->{'ROLEID_GUARD'} ]++ if ( $plcnt >= 11 );

    # ���L�҂��Ȃ�
    # $roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

    # ���l
    my $total = 0;
    my $i;
    for ( $i = 0 ; $i < $sow->{'COUNT_ROLE'} ; $i++ ) {
        $total += $roles->[$i];
    }
    $roles->[ $sow->{'ROLEID_VILLAGER'} ] = $plcnt - $total - 1;

    return;
}

#----------------------------------------
# �n������z���\�̎擾
#----------------------------------------
sub GetSetRoleTableHamster {
    my ( $sow, $plcnt, $roles ) = @_;

    # �l�T
    $roles->[ $sow->{'ROLEID_WOLF'} ]++;
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 8 );
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 15 );
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 24 );

    # �肢�t
    $roles->[ $sow->{'ROLEID_SEER'} ]++;

    # ��\��
    $roles->[ $sow->{'ROLEID_MEDIUM'} ]++ if ( $plcnt >= 9 );

    # ���l
    $roles->[ $sow->{'ROLEID_POSSESS'} ]++ if ( $plcnt >= 10 );

    # ��l
    $roles->[ $sow->{'ROLEID_GUARD'} ]++ if ( $plcnt >= 11 );

    # ���L��
    $roles->[ $sow->{'ROLEID_FM'} ] += 2 if ( $plcnt >= 16 );

    # �n���X�^�[�l��
    $roles->[ $sow->{'ROLEID_HAMSTER'} ]++ if ( $plcnt >= 16 );

    # ���l
    my $total = 0;
    my $i;
    for ( $i = 0 ; $i < $sow->{'COUNT_ROLE'} ; $i++ ) {
        $total += $roles->[$i];
    }
    $roles->[ $sow->{'ROLEID_VILLAGER'} ] = $plcnt - $total - 1;

    return;
}

#----------------------------------------
# �b���z���\�̎擾
#----------------------------------------
sub GetSetRoleTableWBBS_C {
    my ( $sow, $plcnt, $roles ) = @_;

    # �l�T
    $roles->[ $sow->{'ROLEID_WOLF'} ]++;
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 8 );
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 15 );
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 24 );

    # �肢�t
    $roles->[ $sow->{'ROLEID_SEER'} ]++;

    # ��\��
    $roles->[ $sow->{'ROLEID_MEDIUM'} ]++ if ( $plcnt >= 9 );

    # �b�����l
    $roles->[ $sow->{'ROLEID_CPOSSESS'} ]++ if ( $plcnt >= 10 );

    # ��l
    $roles->[ $sow->{'ROLEID_GUARD'} ]++ if ( $plcnt >= 11 );

    # ���L��
    $roles->[ $sow->{'ROLEID_FM'} ] += 2 if ( $plcnt >= 16 );

    # ���l
    my $total = 0;
    my $i;
    for ( $i = 0 ; $i < $sow->{'COUNT_ROLE'} ; $i++ ) {
        $total += $roles->[$i];
    }
    $roles->[ $sow->{'ROLEID_VILLAGER'} ] = $plcnt - $total - 1;

    return;
}

#----------------------------------------
# ������^�z���\�̎擾
#----------------------------------------
sub GetSetRoleTableTest1st {
    my ( $sow, $plcnt, $roles ) = @_;

    # �l�T
    $roles->[ $sow->{'ROLEID_WOLF'} ]++;
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 8 );
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 15 );
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 23 );

    # �肢�t
    $roles->[ $sow->{'ROLEID_SEER'} ]++;

    # ��\��
    $roles->[ $sow->{'ROLEID_MEDIUM'} ]++ if ( $plcnt >= 9 );

    # ���l
    $roles->[ $sow->{'ROLEID_POSSESS'} ]++ if ( $plcnt >= 10 );
    $roles->[ $sow->{'ROLEID_POSSESS'} ]++
      if ( ( $plcnt >= 13 ) && ( $plcnt <= 14 ) );    # 15�`18�ł͂P�l
    $roles->[ $sow->{'ROLEID_POSSESS'} ]++ if ( $plcnt >= 19 );

    # ��l
    $roles->[ $sow->{'ROLEID_GUARD'} ]++ if ( $plcnt >= 11 );

    # ���L��
    $roles->[ $sow->{'ROLEID_FM'} ] += 2 if ( $plcnt >= 19 );

    # ������
    $roles->[ $sow->{'ROLEID_STIGMA'} ]++ if ( $plcnt >= 13 );
    $roles->[ $sow->{'ROLEID_STIGMA'} ]++
      if ( ( $plcnt >= 16 ) && ( $plcnt <= 18 ) );

    # ���l
    my $total = 0;
    my $i;
    for ( $i = 0 ; $i < $sow->{'COUNT_ROLE'} ; $i++ ) {
        $total += $roles->[$i];
    }
    $roles->[ $sow->{'ROLEID_VILLAGER'} ] = $plcnt - $total - 1;

    return;
}

#----------------------------------------
# ������^�z���\�̎擾
#----------------------------------------
sub GetSetRoleTableTest2nd {
    my ( $sow, $plcnt, $roles ) = @_;

    # �l�T
    $roles->[ $sow->{'ROLEID_WOLF'} ]++;
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 8 );
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 16 );
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 21 );
    $roles->[ $sow->{'ROLEID_WOLF'} ]++ if ( $plcnt >= 26 );

    # �肢�t
    $roles->[ $sow->{'ROLEID_SEER'} ]++;

    # ��\��
    $roles->[ $sow->{'ROLEID_MEDIUM'} ]++ if ( $plcnt >= 9 );

    # ���M��
    $roles->[ $sow->{'ROLEID_FANATIC'} ]++ if ( $plcnt >= 10 );

    # ��l
    $roles->[ $sow->{'ROLEID_GUARD'} ]++ if ( $plcnt >= 11 );

    # ���L��
    $roles->[ $sow->{'ROLEID_FM'} ] += 2 if ( $plcnt >= 16 );

    # ���l
    my $total = 0;
    my $i;
    for ( $i = 0 ; $i < $sow->{'COUNT_ROLE'} ; $i++ ) {
        $total += $roles->[$i];
    }
    $roles->[ $sow->{'ROLEID_VILLAGER'} ] = $plcnt - $total - 1;

    return;
}

#----------------------------------------
# �J�X�^���z���\�̎擾
#----------------------------------------
sub GetSetRoleTableCustom {
    my ( $sow, $vil, $roles ) = @_;

    my $i;
    my $roleid = $sow->{'ROLEID'};
    for ( $i = 1 ; $i < @$roleid ; $i++ ) {
        $roles->[$i] = $vil->{"cnt$roleid->[$i]"};
    }
    $roles->[1]--;    # �_�~�[�L�����̕�

    return;
}

#----------------------------------------
# ���L�ҁ^���҂̑����\������
#----------------------------------------
sub SetFreeMasonHistory {
    my ( $sow, $vil, $roleid ) = @_;
    my $textrs = $sow->{'textrs'};

    my $fm     = &GetPlRole( $sow, $vil, $roleid );
    my $namefm = $textrs->{'ROLENAME'}->[$roleid];
    my $fmplsrc;
    foreach $fmplsrc (@$fm) {
        my $fmpl;
        foreach $fmpl (@$fm) {
            my $chrname   = $fmpl->getchrname();
            my $result_fm = $textrs->{'RESULT_FM'};
            $result_fm =~ s/_ROLE_/$namefm/g;
            $result_fm =~ s/_TARGET_/$chrname/g;
            $fmplsrc->{'history'} .= "$result_fm<br>"
              if ( $fmplsrc->{'uid'} ne $fmpl->{'uid'} );
        }
    }
}

1;
