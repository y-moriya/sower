package SWCmdVLog;

#----------------------------------------
# 村ログ表示
#----------------------------------------
sub CmdVLog {
    my $sow = $_[0];

    # データ処理
    my $vil = &SetDataCmdVLog($sow);

    # HTML出力
    &OutHTMLCmdVLog( $sow, $vil );
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdVLog {
    my $sow   = shift;
    my $query = $sow->{'query'};

    # 村データの読み込み
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # リソースの読み込み
    &SWBase::LoadVilRS( $sow, $vil );

    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";

    # 発言確定処理
    if ( $vil->{'epilogue'} >= $vil->{'turn'} ) {
        my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );
        $logfile->fixque(0);    # 通常確定
        $logfile->close();
    }

    # 更新処理
    &CheckUpdateSession( $sow, $vil );

    my $curpl = $sow->{'curpl'};
    $sow->{'savedraft'}    = '';
    $sow->{'draftmestype'} = 0;
    $sow->{'draftmspace'}  = 0;
    $sow->{'draftloud'}    = 0;
    if (   ( defined( $curpl->{'savedraft'} ) )
        && ( $curpl->{'savedraft'} ne '' ) )
    {
        $sow->{'savedraft'}    = $curpl->{'savedraft'};
        $sow->{'draftmestype'} = $curpl->{'draftmestype'};
        $sow->{'draftmspace'}  = $curpl->{'draftmspace'};
        $sow->{'draftloud'}    = $curpl->{'draftloud'};
        $curpl->{'savedraft'}  = '';
        $curpl->{'modified'}   = $sow->{'time'};
        $vil->writevil();
    }
    return $vil;
}

#----------------------------------------
# HTML出力
#----------------------------------------
sub OutHTMLCmdVLog {
    my ( $sow, $vil ) = @_;
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};
    my $ua    = $sow->{'outmode'};

    # HTML出力用ライブラリの読み込み
    require "$cfg->{'DIR_HTML'}/html.pl";
    require "$cfg->{'DIR_HTML'}/html_vlog.pl";

    my $turn = $sow->{'turn'};
    $turn = $vil->{'epilogue'}
      if ( $sow->{'turn'} > $vil->{'epilogue'} );    # 終了している時は終了日

    # 村ログファイルを開く
    my $logfile = SWBoa->new( $sow, $vil, $turn, 0 );

    $sow->{'cookie'}->{'modified'} = 'js'
      if ( !defined( $sow->{'cookie'}->{'modified'} ) );

    # 更新情報の生成
    my $updcookiedt = &SetHTTPUpdateVLog( $sow, $vil, $logfile );
    if (   ( !defined( $sow->{'cookie'}->{'modified'} ) )
        || ( $sow->{'cookie'}->{'modified'} ne 'js' ) )
    {
        $sow->{'http'}->setnotmodified();
    }

    # 発言フィルタ用クッキーデータ処理
    my $pllist    = $vil->getpllist();
    my $setcookie = $sow->{'setcookie'};
    my $cookie    = $sow->{'cookie'};
    $setcookie->{'lastmodified'} = sprintf( "%x", $sow->{'time'} )
      if ( ( $updcookiedt > 0 )
        || ( $cookie->{'modified'} ne 'cgi' )
        || ( !defined( $cookie->{'lastmodified'} ) ) );
    $setcookie->{'modified'}     = 'cgi';
    $setcookie->{'layoutfilter'} = 0
      if ( !defined( $cookie->{'layoutfilter'} ) );
    $setcookie->{'fixedfilter'} = 0 if ( !defined( $cookie->{'fixedfilter'} ) );

    foreach (@$pllist) {
        $sow->{'filter'}->{'pnofilter'}->[ $_->{'pno'} ] = 0
          if ( !defined( $sow->{'filter'}->{'pnofilter'}->[ $_->{'pno'} ] ) );
    }

    # タイトルの取得
    my $title = &SWHtmlVlog::GetHTMLVlogTitle( $sow, $vil );

    # HTMLモードの初期化
    $sow->{'html'} = SWHtml->new($sow);
    my $net = $sow->{'html'}->{'net'};    # Null End Tag
    my $amp = $sow->{'html'}->{'amp'};

    # link要素出力関連
    &SetLinkElements( $sow, $vil );

    # JavaScriptの設定
    my $bodyjs = $sow->{'html'}->{'bodyjs'};
    $bodyjs->{'onload'}   = 'initFilter();';
    $bodyjs->{'onresize'} = 'eventResize();';
    my $file_js = $sow->{'html'}->{'file_js'};
    push( @$file_js, $sow->{'cfg'}->{'FILE_JS_FILTER'} );

    # HTTPヘッダ・HTMLヘッダの出力
    my $outhttp = $sow->{'http'}->outheader();
    return if ( $outhttp == 0 );    # ヘッダ出力のみ
    $sow->{'html'}->outheader($title);

    # 表示行数の設定
    my $maxrow = $sow->{'cfg'}->{'MAX_ROW'};                             # 標準行数
    $maxrow = $query->{'row'}
      if ( defined( $query->{'row'} ) && ( $query->{'row'} ne '' ) );    # 引数による行数指定

    $maxrow = -1
      if ( ( $maxrow eq 'all' ) || ( $query->{'rowall'} ne '' ) );       # 引数による全表示指定

    # ログの取得
    my ( $logs, $logkeys, $rows );
    if (   ( $sow->{'turn'} != $vil->{'turn'} )
        || ( $vil->{'epilogue'} >= $vil->{'turn'} ) )
    {
        ( $logs, $logkeys, $rows ) = $logfile->getvlogs($maxrow);
    }
    $sow->{'lock'}->gunlock();

    # HTMLの出力
    require "$cfg->{'DIR_HTML'}/html_vlog_pc.pl";
    require "$cfg->{'DIR_HTML'}/html_sayfilter.pl";
    &SWHtmlVlogPC::OutHTMLVlogPC( $sow, $vil, $logfile, $maxrow, $logs, $logkeys, $rows );
    $logfile->close();

    $sow->{'html'}->outfooter();    # HTMLフッタの出力
    $sow->{'http'}->outfooter();
}

#----------------------------------------
# 更新処理
#----------------------------------------
sub CheckUpdateSession {
    my ( $sow, $vil ) = @_;
    my $pllist = $vil->getpllist();

    return if ( $vil->{'epilogue'} < $vil->{'turn'} );    #終了済み

    # コミット人数のチェック
    my $getlivepllist = $vil->getlivepllist();
    my $cntlivepl     = @$getlivepllist;
    my $commitedpl    = $vil->getcommitedpl();

    my $isupdate = 0;
    $isupdate = 1 if ( $vil->{'nextupdatedt'} <= $sow->{'time'} );    # 更新時間が来ている
    $isupdate = 2
      if ( ( $sow->{'time'} >= $vil->{'nextcommitdt'} )
        && ( $cntlivepl == $commitedpl )
        && ( $cntlivepl > 0 ) );                                      # 全員が時間を進めている

    my $scrap = 0;
    $scrap = 1
      if ( ( $vil->{'scraplimitdt'} != 0 )
        && ( $sow->{'time'} >= $vil->{'scraplimitdt'} )
        && ( $vil->{'turn'} == 0 ) );                                 # 廃村期限を過ぎている

    if ( $vil->{'turn'} == 0 ) {

        # 自動村抜け処理
        my @exitpl;
        my $pllist = $vil->getpllist();
        foreach (@$pllist) {
            next if ( $_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'} );
            next if ( $_->{'limitentrydt'} <= 0 );
            next if ( $sow->{'time'} <= $_->{'limitentrydt'} );
            push( @exitpl, $_ );

            #			&SWBase::ExitVillage($sow, $vil, $_, $logfile);
        }

        if ( @exitpl > 0 ) {
            require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
            require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
            my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );
            foreach (@exitpl) {
                &SWBase::ExitVillage( $sow, $vil, $_, $logfile );
            }
            $logfile->close();
            $vil->writevil();
            $vil->readvil();
        }
    }

    if ( $isupdate == 0 ) {    # 未更新
        if ( $vil->{'nextchargedt'} < $sow->{'time'} ) {

            # 発言数回復
            $vil->chargesaycountall() if ( $vil->{'turn'} > 0 );

            #			$vil->{'nextchargedt'} = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, 1, 0);
            $vil->{'nextchargedt'} += 24 * 60 * 60;
            $vil->writevil();
        }
        return;
    }

    if ( $vil->{'turn'} == 0 ) {
        if (   ( $vil->{'starttype'} eq 'wbbs' )
            && ( @$pllist >= $vil->{'vplcntstart'} ) )
        {
            # 村開始（人狼BBS型）
            my ( $lastupdtime, $basedt ) =
              $sow->{'dt'}->getlastupdatedt( $vil, $sow->{'time'} );
            my $savetime = $sow->{'time'};
            $sow->{'time'} = $lastupdtime;
            require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
            &SWCommit::StartSession( $sow, $vil, 0 );
            $sow->{'time'} = $savetime;
            $started = 1;
        }
        else {
            if ( $scrap > 0 ) {

                # 廃村
                my ( $lastupdtime, $basedt ) =
                  $sow->{'dt'}->getlastupdatedt( $vil, $sow->{'time'} );
                my $savetime = $sow->{'time'};
                $sow->{'time'} = $lastupdtime;
                require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
                &SWCommit::UpdateSession( $sow, $vil, 0, 1 );
                $sow->{'time'} = $savetime;
            }
            else {
                # 更新予定時間の延長
                $vil->{'nextupdatedt'} =
                  $sow->{'dt'}->getnextupdatedt( $vil, $sow->{'time'}, 1, 0 );
                $vil->writevil();

                # 定員割れ延長表示
                if ( $vil->{'starttype'} eq 'wbbs' ) {
                    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
                    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
                    my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );
                    $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $sow->{'textrs'}->{'ANNOUNCE_EXTENSION'} );
                    $logfile->close();
                }
            }
        }
    }
    else {
        # 村更新
        my $savetime = $sow->{'time'};
        if ( $isupdate == 1 ) {
            my ( $lastupdtime, $basedt ) =
              $sow->{'dt'}->getlastupdatedt( $vil, $sow->{'time'} );
            $sow->{'time'} = $lastupdtime;
        }

        require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
        &SWCommit::UpdateSession( $sow, $vil, $isupdate - 1, 0 );
        $sow->{'time'} = $savetime;
    }

    return;
}

#----------------------------------------
# エンティティタグの生成
#----------------------------------------
sub SetHTTPUpdateVLog {
    my ( $sow, $vil, $logfile ) = @_;
    my $curpl = $sow->{'curpl'};

    my $cookiedt    = '';
    my $updcookiedt = 1;
    if (   ( $sow->{'cookie'}->{'modified'} eq 'cgi' )
        && ( defined( $sow->{'cookie'}->{'lastmodified'} ) ) )
    {
        my $etagcookiedt = 0;
        if ( defined( $ENV{'HTTP_IF_NONE_MATCH'} ) ) {
            my $requestetag = $ENV{'HTTP_IF_NONE_MATCH'};
            $requestetag =~ s/^\"//;
            $requestetag =~ s/\"$//;
            my @etags = split( /-/, $requestetag . '-' );
            $etagcookiedt = $etags[2]
              if ( ( defined( $etags[2] ) ) && ( $etags[2] ne '' ) );
        }
        if ( hex( $sow->{'cookie'}->{'lastmodified'} ) >= hex($etagcookiedt) ) {
            $cookiedt    = $sow->{'cookie'}->{'lastmodified'};
            $updcookiedt = 0;
        }
    }
    $cookiedt = sprintf( "%x", $sow->{'time'} ) if ( $cookiedt eq '' );

    my $modified = $vil->{'modifiedsay'};
    if ( defined($curpl) ) {
        $modified = $vil->{'modifiedgsay'}
          if ( ( $curpl->{'live'} ne 'live' )
            && ( $modified < $vil->{'modifiedgsay'} ) );    # 死者のうめき
        if (   ( $curpl->{'live'} eq 'live' )
            || ( $sow->{'cfg'}->{'ENABLED_PERMIT_DEAD'} > 0 ) )
        {
            # ささやき
            $modified = $vil->{'modifiedwsay'}
              if ( ( ( $curpl->iswolf() > 0 ) || ( $curpl->{'role'} == $sow->{'ROLEID_CPOSSESS'} ) )
                && ( $modified < $vil->{'modifiedwsay'} ) );

            # 共鳴
            $modified = $vil->{'modifiedspsay'}
              if ( ( $curpl->{'role'} == $sow->{'ROLEID_SYMPATHY'} )
                && ( $modified < $vil->{'modifiedspsay'} ) );

            # 念話
            $modified = $vil->{'modifiedbsay'}
              if ( ( $curpl->{'role'} == $sow->{'ROLEID_WEREBAT'} )
                && ( $modified < $vil->{'modifiedbsay'} ) );
        }

        $modified = $curpl->{'modified'}
          if ( $modified < $curpl->{'modified'} );
    }

    my $etag = '-';
    my $user = $sow->{'user'};
    if ( $user->logined() > 0 ) {
        my $uid = &SWBase::EncodeURL( $sow->{'uid'} );
        $etag = sprintf( "%s-", $uid );
    }
    $etag .= sprintf( "vlog%d-%s", $vil->{'turn'}, $cookiedt );
    $sow->{'http'}->{'etag'} = $etag;

    $sow->{'http'}->{'lastmodified'} = $modified;
    return $updcookiedt;
}

#----------------------------------------
# link要素出力関連
#----------------------------------------
sub SetLinkElements {
    my ( $sow, $vil ) = @_;
    my $cfg = $sow->{'cfg'};
    my $amp = $sow->{'html'}->{'amp'};

    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";
    my @links = ();

    # 前の日への移動
    my $prevday = $sow->{'turn'} - 1;
    if ( $prevday >= 0 ) {
        my %prev = (
            rel   => 'Prev',
            title => '前の日',
            url   => "$link$amp" . "turn=$prevday",
        );
        push( @links, \%prev );
    }

    # 次の日への移動
    my $nextday = $sow->{'turn'} + 1;
    if ( $nextday <= $vil->{'turn'} ) {
        my %next = (
            rel   => 'Next',
            title => '次の日',
            url   => "$link$amp" . "turn=$nextday",
        );
        push( @links, \%next );
    }

    $sow->{'html'}->{'links'} = \@links;
    $sow->{'html'}->{'rss'}   = "$link$amp" . "cmd=rss";
}

1;
