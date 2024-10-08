package SWCmdExtend;

#----------------------------------------
# 延長処理（暫定）
#----------------------------------------
sub CmdExtend {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # データ処理
    my $vil = &SetDataCmdExtend($sow);

    # HTTP/HTML出力
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newinfo";

    $sow->{'http'}->{'location'} = "$link";
    $sow->{'http'}->outheader();    # HTTPヘッダの出力
    $sow->{'http'}->outfooter();
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdExtend {
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
    if ( $vil->{'turn'} == 0 ) {

        # 開始前は廃村期限を延長する。
        $vil->{'scraplimitdt'} = $vil->{'scraplimitdt'} + 24 * 60 * 60 * $query->{'extenddate'};
    }
    else {

        # 進行中は次の更新時間を延長する。現状、これを呼べるインターフェースはない。
        $vil->{'nextupdatedt'} = $vil->{'nextupdatedt'} + 24 * 60 * 60 * $query->{'extenddate'};
    }
    $vil->writevil();
    $vil->closevil();

    return $vil;
}

1;
