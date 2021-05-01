package SWCmdWritePreview;

#----------------------------------------
# 発言プレビュー表示
#----------------------------------------
sub CmdWritePreview {
    my $sow = $_[0];

    # 村データの読み込み
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $sow->{'query'}->{'vid'} );
    $vil->readvil();

    # リソースの読み込み
    &SWBase::LoadVilRS( $sow, $vil );

    # 入力値のチェック
    if ( $sow->{'query'}->{'submit_type'} eq $sow->{'textrs'}->{'CAPTION_TSAY_PC'} ) {
        $sow->{'query'}->{'think'} = 'on';
    }
    require "$sow->{'cfg'}->{'DIR_LIB'}/vld_write.pl";
    &SWValidityWrite::CheckValidityWrite( $sow, $vil );

    # HTML出力
    require "$sow->{'cfg'}->{'DIR_LIB'}/write.pl";
    if ( &SWString::CheckNoSay( $sow, $sow->{'query'}->{'mes'} ) > 0 ) {

        # プレビュー表示
        &OutHTMLCmdWritePreview( $sow, $vil );
    }
    else {
        # 村ログ表示
        my $cfg     = $sow->{'cfg'};
        my $reqvals = &SWBase::GetRequestValues($sow);
        my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
        $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

        $sow->{'http'}->{'location'} = "$link";

        $sow->{'http'}->outheader();    # HTTPヘッダの出力
        $sow->{'http'}->outfooter();
    }
    $vil->closevil();
}

#----------------------------------------
# HTML出力
#----------------------------------------
sub OutHTMLCmdWritePreview {
    my ( $sow, $vil ) = @_;
    my $query = $sow->{'query'};

    # HTML表示用ファイル読み込み
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
    &SWLog::ReplaceAnchor( $sow, $vil, \%say );    # とりあえず妥当性チェック代わり

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

    # HTML表示
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
