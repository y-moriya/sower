package SWCmdEntry;

#----------------------------------------
# �G���g���[
#----------------------------------------
sub CmdEntry {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # ���f�[�^�̓ǂݍ���
    require "$cfg->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # ���\�[�X�̓ǂݍ���
    &SWBase::LoadVilRS( $sow, $vil );

    # �f�[�^����(����)
    &SetDataCmdEntry( $sow, $vil );

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
sub SetDataCmdEntry {
    my ( $sow, $vil ) = @_;
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};
    my $debug = $sow->{'debug'};

    require "$cfg->{'DIR_LIB'}/string.pl";

    my $pllist = $vil->getpllist();

    my ( $q_csid, $q_cid ) = split( '/', $query->{'csid_cid'} );

    # �v���C���[�Q���ς݃`�F�b�N
    if ( defined( $sow->{'curpl'} ) ) {
        $debug->raise( $sow->{'APLOG_NOTICE'},
            '���Ȃ��͊��ɂ��̑��֎Q�����Ă��܂��B', "user found.[$sow->{'uid'}]" );
    }

    my $user = SWUser->new($sow);
    $user->{'uid'} = $sow->{'uid'};
    $user->openuser(1);
    if ( $cfg->{'ENABLED_MULTIENTRY'} == 0 ) {
        my $entriedvils = $user->getentriedvils();
        foreach (@$entriedvils) {
            $debug->rraise( $sow->{'APLOG_NOTICE'},
                '���Ȃ��͊��ɑ��̑��֎Q�����Ă��܂��B',
                "entriedvil found.[$sow->{'uid'}, $_->{'vid'}]" )
              if ( ( $_->{'vid'} > 0 ) && ( $_->{'playing'} > 0 ) );
        }
    }
    $debug->rraise( $sow->{'APLOG_NOTICE'},
        '���Ȃ��̓y�i���e�B���̂��ߌ��ݎQ���ł��܂���B', "cannot entry.[$sow->{'uid'}]" )
      if ( ( $user->{'ptype'} > $sow->{'PTYPE_PROBATION'} )
        && ( $user->{'penaltydt'} >= $sow->{'time'} ) );
    $user->closeuser();

    # ���J�n�O�`�F�b�N
    $debug->raise( $sow->{'APLOG_NOTICE'}, "���ɊJ�n���Ă��܂��B", 'village started.' )
      unless ( $vil->isprologue() > 0 );

    # ����`�F�b�N
    $debug->raise( $sow->{'APLOG_NOTICE'}, "���ɒ���ɒB���Ă��܂��B", 'too many plcnt.' )
      if ( @$pllist >= $vil->{'vplcnt'} );

    # �L�����N�^�Q���ς݃`�F�b�N
    foreach (@$pllist) {
        next if ( $_->{'csid'} ne $q_csid );
        my $chrname = $sow->{'charsets'}->getchrname( $q_csid, $q_cid );
        $debug->raise(
            $sow->{'APLOG_NOTICE'},
            "$chrname �͊��ɎQ�����Ă��܂��B",
            'cid found.'
        ) if ( $_->{'cid'} eq $q_cid );
    }

    $debug->raise( $sow->{'APLOG_NOTICE'},
        '�Q���p�X���[�h���Ⴂ�܂��B', "invalid entrypwd." )
      if ( ( $vil->{'entrylimit'} eq 'password' )
        && ( $query->{'entrypwd'} ne $vil->{'entrypwd'} ) );

    # �Q���҃f�[�^���R�[�h�̐V�K�쐬
    my $plsingle = SWPlayer->new($sow);
    $plsingle->createpl( $sow->{'uid'} );
    $plsingle->{'cid'}          = $q_cid;
    $plsingle->{'csid'}         = $q_csid;
    $plsingle->{'selrole'}      = $query->{'role'};
    $plsingle->{'role'}         = -1;
    $plsingle->{'limitentrydt'} = $writepl->{'limitentrydt'} =
      $sow->{'time'} + $sow->{'cfg'}->{'TIMEOUT_ENTRY'} * 24 * 60 * 60;
    $vil->addpl($plsingle);      # ���֒ǉ�
    $plsingle->setsaycount();    # ������������

    # �G���g���[���b�Z�[�W��������
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );

    my $expression = 0;
    $expression = $query->{'expression'}
      if ( defined( $query->{'expression'} ) );
    my $monospace = 0;
    $monospace = 1 if ( $query->{'monospace'} ne '' );
    my $loud = 0;
    $loud = 1 if ( $query->{'loud'} ne '' );
    my $mes   = &SWString::GetTrimString( $sow, $vil, $query->{'mes'} );
    my %entry = (
        pl         => $plsingle,
        mes        => &SWLog::CvtRandomText( $sow, $vil, $mes ),
        expression => $expression,
        npc        => 0,
        monospace  => $monospace,
        loud       => $loud,
    );
    $logfile->entrychara( \%entry );
    $logfile->close();
    $vil->writevil();

    # ���[�U�[�f�[�^�̍X�V
    $user->writeentriedvil( $sow->{'uid'}, $vil->{'vid'},
        $plsingle->getchrname(), 1 );

    # ���O�o��
    $debug->writeaplog( $sow->{'APLOG_POSTED'}, "Entry. [$sow->{'uid'}]" );

    # ���J�n�`�F�b�N�i�l�T�R��^�j
    $pllist = $vil->getpllist;
    if ( ( $vil->{'starttype'} eq 'juna' ) && ( @$pllist >= $vil->{'vplcnt'} ) )
    {
        # ���J�n
        require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
        &SWCommit::StartSession( $sow, $vil, 1 );
    }
    else {
        # ���ꗗ�f�[�^�̍X�V
        require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
        my $vindex = SWFileVIndex->new($sow);
        $vindex->openvindex();
        $vindex->updatevindex( $vil, $sow->{'VSTATUSID_PRO'} );
        $vindex->closevindex();
    }
    $vil->closevil();

    return;
}

1;
