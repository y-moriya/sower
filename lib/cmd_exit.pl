package SWCmdExit;

#----------------------------------------
# �����o��
#----------------------------------------
sub CmdExit {
    my $sow = $_[0];
    my $cfg = $sow->{'cfg'};

    # �f�[�^����
    &SetDataCmdExit($sow);

    # HTTP/HTML�o��
    if ( $sow->{'outmode'} eq 'mb' ) {
        require "$cfg->{'DIR_LIB'}/file_log.pl";
        require "$cfg->{'DIR_LIB'}/log.pl";
        require "$cfg->{'DIR_LIB'}/cmd_vlog.pl";
        my $vil = SWFileVil->new( $sow, $sow->{'query'}->{'vid'} );
        $vil->readvil();
        &SWCmdVLog::OutHTMLCmdVLog( $sow, $vil );
        $vil->closevil();
    }
    else {
        my $reqvals = &SWBase::GetRequestValues($sow);
        my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
        $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

        $sow->{'http'}->{'location'} = "$link";
        $sow->{'http'}->outheader();    # HTTP�w�b�_�̏o��
        $sow->{'http'}->outfooter();
    }
}

#----------------------------------------
# ������o��
#----------------------------------------
sub CmdKick {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # ���f�[�^�̓ǂݍ���
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();
    my $delpl = $vil->getplbypno( $query->{'cid'} );

    # ���\�[�X�̓ǂݍ���
    &SWBase::LoadVilRS( $sow, $vil );
    my ( $q_csid, $q_cid ) = split( '/', $query->{'csid_cid'} );

    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'},
        '�L�����N�^�[��������܂���B', "user not found.[$sow->{'uid'}]" )
      if ( !defined($delpl) );
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '�_�~�[�L�����͑����o�鎖���ł��܂���B', "npc cannot exit.[$sow->{'uid'}]" )
      if ( $delpl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'} );
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '�����J�n���Ă��瑺���o�鎖�͂ł��܂���B', "already started.[$sow->{'uid'}]" )
      if ( $vil->{'turn'} != 0 );

    # ����������
    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
    my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );
    &SWBase::ExitVillage( $sow, $vil, $delpl, $logfile );
    $logfile->close();
    $vil->writevil();

    # ���ꗗ�f�[�^�̍X�V
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
    my $vindex = SWFileVIndex->new($sow);
    $vindex->openvindex();
    $vindex->updatevindex( $vil, $sow->{'VSTATUSID_PRO'} );
    $vindex->closevindex();

    # HTTP/HTML�o��
    if ( $sow->{'outmode'} eq 'mb' ) {
        require "$cfg->{'DIR_LIB'}/file_log.pl";
        require "$cfg->{'DIR_LIB'}/log.pl";
        require "$cfg->{'DIR_LIB'}/cmd_vlog.pl";
        my $vil = SWFileVil->new( $sow, $sow->{'query'}->{'vid'} );
        $vil->readvil();
        &SWCmdVLog::OutHTMLCmdVLog( $sow, $vil );
        $vil->closevil();
    }
    else {
        my $reqvals = &SWBase::GetRequestValues($sow);
        my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
        $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

        $sow->{'http'}->{'location'} = "$link";
        $sow->{'http'}->outheader();    # HTTP�w�b�_�̏o��
        $sow->{'http'}->outfooter();
    }

}

#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdExit {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # ���f�[�^�̓ǂݍ���
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();
    my $pllist = $vil->getpllist();

    # ���\�[�X�̓ǂݍ���
    &SWBase::LoadVilRS( $sow, $vil );
    my ( $q_csid, $q_cid ) = split( '/', $query->{'csid_cid'} );

    my $curpl = $sow->{'curpl'};
    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'},
        '���Ȃ��͂��̑��֎Q�����Ă��܂���B', "user not found.[$sow->{'uid'}]" )
      if ( !defined($curpl) );
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '�_�~�[�L�����͑����o�鎖���ł��܂���B', "npc cannot exit.[$sow->{'uid'}]" )
      if ( $sow->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'} );
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '�����J�n���Ă��瑺���o�鎖�͂ł��܂���B', "already started.[$sow->{'uid'}]" )
      if ( $vil->{'turn'} != 0 );

    # ����������
    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
    my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );
    &SWBase::ExitVillage( $sow, $vil, $curpl, $logfile );
    $logfile->close();
    $vil->writevil();

    # ���ꗗ�f�[�^�̍X�V
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
    my $vindex = SWFileVIndex->new($sow);
    $vindex->openvindex();
    $vindex->updatevindex( $vil, $sow->{'VSTATUSID_PRO'} );
    $vindex->closevindex();

    return;
}

1;
