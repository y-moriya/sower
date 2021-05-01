package SWCmdEntryPreview;

#----------------------------------------
# �G���g���[�����v���r���[�\��
#----------------------------------------
sub CmdEntryPreview {
    my $sow   = $_[0];
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};
    my $debug = $sow->{'debug'};

    # ���f�[�^�̓ǂݍ���
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # �����񃊃\�[�X�̓ǂݍ���
    &SWBase::LoadTextRS( $sow, $vil );

    require "$sow->{'cfg'}->{'DIR_LIB'}/write.pl";
    my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";
    $debug->raise( $sow->{'APLOG_NOTICE'}, "���O�C�����ĉ������B", "no login.$errfrom" )
      if ( $sow->{'user'}->logined() <= 0 );
    my $lenmes = length( $query->{'mes'} );
    $debug->raise(
        $sow->{'APLOG_NOTICE'},
"�Q�����鎞�̃Z���t���Z�����܂��i$lenmes �o�C�g�j�B$sow->{'cfg'}->{'MINSIZE_MES'} �o�C�g�ȏ�K�v�ł��B",
        "mes too short.$errfrom"
    ) if ( ( $lenmes < $sow->{'cfg'}->{'MINSIZE_MES'} ) && ( $lenmes != 0 ) );
    $debug->raise(
        $sow->{'APLOG_NOTICE'},
        "�Q�����鎞�̃Z���t������܂���B",
        "no entry message.$errfrom"
    ) if ( &SWString::CheckNoSay( $sow, $sow->{'query'}->{'mes'} ) == 0 );
    $debug->raise( $sow->{'APLOG_NOTICE'}, '�Q���p�X���[�h���Ⴂ�܂��B', "invalid entrypwd.$errfrom" )
      if ( ( $vil->{'entrylimit'} eq 'password' )
        && ( $query->{'entrypwd'} ne $vil->{'entrypwd'} ) );

    # HTML�o��
    require "$sow->{'cfg'}->{'DIR_LIB'}/string.pl";
    if ( &SWString::CheckNoSay( $sow, $sow->{'query'}->{'mes'} ) > 0 ) {

        # �v���r���[�\��
        &OutHTMLCmdEntryPreview( $sow, $vil );
    }
    else {
        # �����O�\��
        my $cfg     = $sow->{'cfg'};
        my $reqvals = &SWBase::GetRequestValues($sow);
        my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
        $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

        $sow->{'http'}->{'location'} = "$link";
        $sow->{'http'}->outheader();    # HTTP�w�b�_�̏o��
        $sow->{'http'}->outfooter();
    }
    $vil->closevil();
}

#----------------------------------------
# HTML�o��
#----------------------------------------
sub OutHTMLCmdEntryPreview {
    my ( $sow, $vil ) = @_;
    my $query = $sow->{'query'};

    # �v���r���[�\���̏���
    require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";

    my $logid = &SWLog::CreateLogID( $sow, $sow->{'MESTYPE_SAY'}, $sow->{'LOGSUBID_SAY'}, $sow->{'LOGCOUNT_UNDEF'} );

    # �L�����N�^�Z�b�g�̓ǂݍ���
    my ( $csid, $cid ) = split( '/', $query->{'csid_cid'} );
    $sow->{'charsets'}->loadchrrs($csid);

    my $monospace = 0;
    $monospace = 1 if ( $query->{'monospace'} ne '' );
    my $loud = 0;
    $loud = 1 if ( $query->{'loud'} ne '' );

    my %log = (
        logid     => $logid,
        mestype   => $sow->{'MESTYPE_SAY'},
        logsubid  => $sow->{'LOGSUBID_SAY'},
        log       => $query->{'mes'},
        date      => $sow->{'time'},
        uid       => $sow->{'uid'},
        csid      => $csid,
        cid       => $cid,
        chrname   => $sow->{'charsets'}->getchrname( $csid, $cid ),
        monospace => $monospace,
        loud      => $loud,
    );

    my $plsingle = SWPlayer->new($sow);
    $plsingle->createpl( $log{'uid'} );

    my %preview = ( cmd => 'entry', );
    if ( $sow->{'outmode'} eq 'mb' ) {
        $preview{'cmdfrom'} = 'enformmb';
        require "$sow->{'cfg'}->{'DIR_HTML'}/html_preview_mb.pl";
        &SWHtmlPreviewMb::OutHTMLPreviewMb( $sow, $vil, \%log, \%preview );
    }
    else {
        require "$sow->{'cfg'}->{'DIR_HTML'}/html_preview_pc.pl";
        require "$sow->{'cfg'}->{'DIR_HTML'}/html_vlog_pc.pl";
        &SWHtmlPreviewPC::OutHTMLPreviewPC( $sow, $vil, \%log, \%preview );
    }
}

1;
