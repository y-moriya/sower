package SWCmdWritePreview;

#----------------------------------------
# �����v���r���[�\��
#----------------------------------------
sub CmdWritePreview {
    my $sow = $_[0];

    # ���f�[�^�̓ǂݍ���
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $sow->{'query'}->{'vid'} );
    $vil->readvil();

    # ���\�[�X�̓ǂݍ���
    &SWBase::LoadVilRS( $sow, $vil );

    # ���͒l�̃`�F�b�N
    if ( $sow->{'query'}->{'submit_type'} eq $sow->{'textrs'}->{'CAPTION_TSAY_PC'} ) {
        $sow->{'query'}->{'think'} = 'on';
    }
    require "$sow->{'cfg'}->{'DIR_LIB'}/vld_write.pl";
    &SWValidityWrite::CheckValidityWrite( $sow, $vil );

    # HTML�o��
    require "$sow->{'cfg'}->{'DIR_LIB'}/write.pl";
    if ( &SWString::CheckNoSay( $sow, $sow->{'query'}->{'mes'} ) > 0 ) {

        # �v���r���[�\��
        &OutHTMLCmdWritePreview( $sow, $vil );
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
sub OutHTMLCmdWritePreview {
    my ( $sow, $vil ) = @_;
    my $query = $sow->{'query'};

    # HTML�\���p�t�@�C���ǂݍ���
    require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";

    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    my $logid = &SWLog::CreateLogID( $sow, $sow->{'MESTYPE_SAY'}, $sow->{'LOGSUBID_SAY'}, $sow->{'LOGCOUNT_UNDEF'} );
    my $curpl = &SWBase::GetCurrentPl( $sow, $vil );
    my ( $mestype, $saytype ) = &SWWrite::GetMesType( $sow, $vil, $curpl );
    $mestype = $sow->{'MESTYPE_SAY'} if ( $mestype eq $sow->{'MESTYPE_QUE'} );

    my $monospace = 0;
    $monospace = 1 if ( $query->{'monospace'} ne '' );

    my $loud = 0;
    $loud = 1 if ( $query->{'loud'} ne '' );

    my $expression = 0;
    $expression = $query->{'expression'}
      if ( defined( $query->{'expression'} ) );

    my %say = (
        uid     => $sow->{'uid'},
        mes     => $query->{'mes'},
        mestype => $mestype,
    );
    &SWLog::ReplaceAnchor( $sow, $vil, \%say );    # �Ƃ肠�����Ó����`�F�b�N����

    my %log = (
        logid      => $logid,
        mestype    => $mestype,
        logsubid   => $sow->{'LOGSUBID_SAY'},
        log        => $query->{'mes'},
        date       => $sow->{'time'},
        uid        => $sow->{'uid'},
        cid        => $curpl->{'cid'},
        csid       => $curpl->{'csid'},
        chrname    => $curpl->getchrname(),
        expression => $expression,
        monospace  => $monospace,
        loud       => $loud,
    );
    my %preview = ( cmd => 'write', );

    # HTML�\��
    if ( $sow->{'outmode'} eq 'mb' ) {
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
