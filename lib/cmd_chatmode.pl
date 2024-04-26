package SWCmdEnableChatMode;

#----------------------------------------
# 雑談村に変更
#----------------------------------------
sub CmdEnableChatMode {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # データ処理
    my $vil = &SetDataCmdEnableChatMode($sow);

    # HTTP/HTML出力
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

    $sow->{'http'}->{'location'} = "$link";
    $sow->{'http'}->outheader();    # HTTPヘッダの出力
    $sow->{'http'}->outfooter();
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdEnableChatMode {
    my $sow     = $_[0];
    my $query   = $sow->{'query'};
    my $debug   = $sow->{'debug'};
    my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

    # 村データの読み込み
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # リソースの読み込み
    &SWBase::LoadVilRS( $sow, $vil );

    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, "管理人権限が必要です。", "no permition.$errfrom" )
      if ( $sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'} );

    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, '進行中は雑談村に変更できません。', "chatmode can not change.$errfrom" )
      if ( $vil->{'turn'} > 0 );

    # 変更処理
    $vil->{'chatmode'} = 1;

    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";

    $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Enable Chat Mode. [$sow->{'curpl'}->{'uid'}]" );
    $vil->writevil();
    $vil->closevil();

    return $vil;
}

1;
