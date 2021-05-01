package SWCmdATMakeVil;

#----------------------------------------
# �������쐬
#----------------------------------------
sub CmdATMakeVil {
    my $sow      = $_[0];
    my $cfg      = $sow->{'cfg'};
    my @autokey  = keys( %{ $cfg->{'AUTO_MAKEVILS'} } );
    my $autolist = \@autokey;
    require "$cfg->{'DIR_LIB'}/file_vindex.pl";
    require "$cfg->{'DIR_LIB'}/file_autovindex.pl";

    my $atvindex = SWFileATVIndex->new($sow);
    $atvindex->openatvindex();

    my $vindex = SWFileVIndex->new($sow);
    $vindex->openvindex();
    my @vilist = $vindex->getvilist();

    my $atvindexsingle;
    my $vindexsingle;
    my $hours;
    my $autonum;

    # ���������`�F�b�N
    return if ( $sow->{'user'}->logined() <= 0 );    # �����O�C���Ȃ�`�F�b�N���Ȃ��B

    foreach (@$autolist) {
        $atvindexsingle =
          $atvindex->getatvindex( $cfg->{'AUTO_MAKEVILS'}->{$_}->{'autoid'} );
        $hours = $cfg->{'AUTO_MAKEVILS'}->{$_}->{'hours'};
        if ($atvindexsingle) {
            $vindexsingle = $vindex->getvindex( $atvindexsingle->{'vid'} );
            if ( $vindexsingle->{'vstatus'} < $sow->{ $cfg->{'AUTOMV_TIMING'} } ) {

                # �������Ȃ�
            }
            else {
                if ( $cfg->{'AUTO_MAKEVILS'}->{$_}->{'autoflag'} > 0 ) {
                    if ($hours) {
                        $autonum = $atvindexsingle->{'autonum'} % @$hours;
                        $cfg->{'AUTO_MAKEVILS'}->{$_}->{'hour'} =
                          @$hours[$autonum];
                    }

                    # ���쐬���l�`�F�b�N
                    require "$cfg->{'DIR_LIB'}/vld_automakevil.pl";
                    &SWValidityAutoMakeVil::CheckValidityAutoMakeVil( $sow, $cfg->{'AUTO_MAKEVILS'}->{$_} );

                    # ���쐬����
                    my $vil = &SetDataCmdATMakeVil( $sow, $cfg->{'AUTO_MAKEVILS'}->{$_} );
                }
            }
        }
        else {
            if ( $cfg->{'AUTO_MAKEVILS'}->{$_}->{'autoflag'} > 0 ) {
                if ($hours) {
                    $cfg->{'AUTO_MAKEVILS'}->{$_}->{'hour'} = @$hours[0];
                }

                # ���쐬���l�`�F�b�N
                require "$cfg->{'DIR_LIB'}/vld_automakevil.pl";
                &SWValidityAutoMakeVil::CheckValidityAutoMakeVil( $sow, $cfg->{'AUTO_MAKEVILS'}->{$_} );

                # ���쐬����
                my $vil =
                  &SetDataCmdATMakeVil( $sow, $cfg->{'AUTO_MAKEVILS'}->{$_} );
            }
        }
    }

    return;
}

#----------------------------------------
# �������쐬����
#----------------------------------------
sub SetDataCmdATMakeVil {
    my ( $sow, $automv ) = @_;
    my $cfg = $sow->{'cfg'};

    require "$cfg->{'DIR_LIB'}/file_sowgrobal.pl";
    require "$cfg->{'DIR_LIB'}/file_autovindex.pl";

    # �Ǘ��f�[�^���瑺�ԍ����擾
    my $sowgrobal = SWFileSWGrobal->new($sow);
    $sowgrobal->openmw();

    $automv->{'vid'} = $sowgrobal->{'vlastid'};
    $sowgrobal->closemw();
    if ( $automv->{'vname'} eq 'auto' ) {
        my $autonames = $cfg->{'AUTO_NAMES'};
        my $i         = $automv->{'vid'} % @$autonames;
        $automv->{'vname'} = $cfg->{'AUTO_NAMES'}[$i];
    }
    $automv->{'makeruid'} = $cfg->{'USERID_ADMIN'};

    # �N�G���ɕ��荞�ދ���̍�
    $sow->{'query'} = $automv;

    # ���f�[�^�̍쐬
    require "$cfg->{'DIR_LIB'}/cmd_makevil.pl";
    &SWCmdMakeVil::SetDataCmdMakeVil($sow);

    # ���������p�f�[�^�̍X�V
    my $atvindex = SWFileATVIndex->new($sow);
    $atvindex->openatvindex();
    $atvindex->addatvindex( $automv->{'vid'}, $automv->{'autoid'} );
    $atvindex->writeatvindex();
    $atvindex->closeatvindex();

    # �l�T���o�͗p�t�@�C���̍쐬
    if ( $sow->{'cfg'}->{'ENABLED_SCORE'} > 0 ) {
        require "$sow->{'cfg'}->{'DIR_LIB'}/score.pl";
        my $score = SWScore->new( $sow, $vil, 1 );
        $score->close();
    }

    $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Make Vil. [uid=$sow->{'uid'}]" );

    return;
}

1;
