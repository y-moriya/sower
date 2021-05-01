package SWCmdEntryFormMb;

#----------------------------------------
# モバイル用エントリー画面表示
#----------------------------------------
sub CmbEntryFormMb {
    my $sow   = $_[0];
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};

    require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
    require "$sow->{'cfg'}->{'DIR_HTML'}/html_formpl_mb.pl";
    require "$sow->{'cfg'}->{'DIR_HTML'}/html_entryform_mb.pl";

    # 村データの読み込み
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $sow->{'query'}->{'vid'} );
    $vil->readvil();

    # リソースの読み込み
    &SWBase::LoadVilRS( $sow, $vil );

    # 入力値チェック
    my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";
    my $debug   = $sow->{'debug'};
    $debug->raise( $sow->{'APLOG_CAUTION'}, "ログインして下さい。", "no login.$errfrom" )
      if ( $sow->{'user'}->logined() <= 0 );    # 通常起きない

    &SWHtmlEntryFormMb::OutHTMLEntryFormMb( $sow, $vil );

    $vil->closevil();

}

1;
