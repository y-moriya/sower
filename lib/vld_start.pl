package SWValidityStart;

#----------------------------------------
# 村手動開始時値チェック
#----------------------------------------
sub CheckValidityStart {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $debug = $sow->{'debug'};

    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();
    my $pllist = $vil->getpllist();
    $vil->closevil();

    my $errfrom = "[uid=$sow->{'uid'}, vid=$vil->{'vid'}, cmd=$query->{'cmd'}]";

    # リソースの読み込み
    &SWBase::LoadVilRS( $sow, $vil );

    $debug->raise( $sow->{'APLOG_CAUTION'}, "ログイン？して下さい。", "no login.$errfrom" )
      if ( $sow->{'user'}->logined() <= 0 );
    $debug->raise(
        $sow->{'APLOG_CAUTION'},
        "村を開始するには村建て人権限か管理人権限が必要です。",
        "no permition.$errfrom"
      )
      if ( ( $sow->{'uid'} ne $vil->{'makeruid'} )
        && ( $sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'} ) );
    $debug->raise(
        $sow->{'APLOG_CAUTION'},
        "人数が足りません。ダミーキャラを含め、最低 4 人必要です。",
        "need 4 persons.$errfrom"
    ) if ( @$pllist < 4 );
    $debug->raise(
        $sow->{'APLOG_CAUTION'},
        "現在参加している人数と定員が等しくありません。",
        "invalid vplcnt or total plcnt.$errfrom"
      )
      if ( ( @$pllist != $vil->{'vplcnt'} )
        && ( $vil->{'roletable'} eq 'custom' ) );
    $debug->raise( $sow->{'APLOG_CAUTION'}, "村が開始しています。", "game started." )
      unless ( $vil->isprologue() > 0 );

    return;
}

#----------------------------------------
# 村手動更新時値チェック
#----------------------------------------
sub CheckValidityUpdate {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $debug = $sow->{'debug'};

    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();
    my $pllist = $vil->getpllist();
    $vil->closevil();

    my $errfrom = "[uid=$sow->{'uid'}, vid=$vil->{'vid'}, cmd=$query->{'cmd'}]";

    # リソースの読み込み
    &SWBase::LoadVilRS( $sow, $vil );

    $debug->raise( $sow->{'APLOG_CAUTION'}, "ログインして下さい。", "no login.$errfrom" )
      if ( $sow->{'user'}->logined() <= 0 );
    if ( $sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'} ) {
        if ( $sow->{'query'}->{'cmd'} eq 'scrapvil' ) {
            $debug->raise(
                $sow->{'APLOG_CAUTION'},
                "廃村するには管理人権限が必要です。",
                "no permition.$errfrom"
            );
        }
        else {
            $debug->raise(
                $sow->{'APLOG_CAUTION'},
                "村を更新するには村建て人権限か管理人権限が必要です。",
                "no permition.$errfrom"
            ) if ( $sow->{'uid'} ne $vil->{'makeruid'} );
        }
    }

    return;
}

1;
