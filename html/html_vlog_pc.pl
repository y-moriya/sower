package SWHtmlVlogPC;

#----------------------------------------
# 村ログ表示（PCモード）のHTML出力
#----------------------------------------
sub OutHTMLVlogPC {
    my ( $sow, $vil, $logfile, $maxrow, $logs, $logkeys, $rows ) = @_;
    my $pllist = $vil->getpllist();

    my $net   = $sow->{'html'}->{'net'};    # Null End Tag
    my $amp   = $sow->{'html'}->{'amp'};
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};

    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

    # TODO: parmalinkの場合は該当の発言に飛ぶようにする？
    my $titlelink = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?vid=$query->{'vid'}";

    my $logfilelist = $logfile->getlist();

    # ログID指定表示スイッチ
    my $modesingle = 0;
    $modesingle = 1
      if ( $query->{'logid'} ne '' );

    # ログインHTML
    $sow->{'html'}->outcontentheader();
    &SWHtmlPC::OutHTMLLogin($sow) if ( $modesingle == 0 );

    # 見出し（村名とRSS）
    my $titleupdate = &SWHtmlPC::GetTitleNextUpdate( $sow, $vil );
    my $linkrss     = " <a href=\"$link$amp" . "cmd=rss\">RSS</a>";
    my $twitter =
"<p class=\"return\"><a href=\"https://twitter.com/share\" class=\"twitter-share-button\" data-count=\"horizontal\" data-via=\"webwolves\" data-lang=\"ja\">Tweet</a><script type=\"text/javascript\" src=\"https://platform.twitter.com/widgets.js\"></script></p>";
    $linkrss = '' if ( $cfg->{'ENABLED_RSS'} == 0 );
    $twitter = '' if ( $vil->{'turn'} > 0 );
    print "<h2><a href=\"$titlelink\">$query->{'vid'} $vil->{'vname'}</a>";
    print "$titleupdate$linkrss$twitter"
      if ( $vil->{'epilogue'} >= $vil->{'turn'} );
    print "</h2>\n\n";

    # 個別フィルタへのリンク
    if ( $modesingle eq 0 ) {
        require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
        &SWHtmlPlayerFormPC::OutHTMLPlayerFilter( $sow, $vil );
    }

    # 日付別ログへのリンク
    if ( $modesingle == 0 ) {

        #		my $list = $logfile->getlist();
        &SWHtmlPC::OutHTMLTurnNavi( $sow, $vil, $logs, $logfilelist, $rows, 0 );
    }

    # 終了表示
    if (   ( $sow->{'turn'} == $vil->{'turn'} )
        && ( $vil->{'epilogue'} < $vil->{'turn'} ) )
    {
        print <<"_HTML_";
<p class="caution">
終了しました。
</p>
<hr class="invisible_hr"$net>
_HTML_

        &SWHtmlPC::OutHTMLReturnPC($sow);    # トップページへ戻る
        $sow->{'html'}->outcontentfooter();
        &SWHtmlSayFilter::OutHTMLSayFilter( $sow, $vil )
          if ( $modesingle == 0 );

        return;
    }

    # 全表示リンク
    #	my $rowover = 0;
    my $rowover = $rows->{'rowover'};
    if ( $modesingle == 0 ) {
        if ( ( $maxrow != 0 ) && ( $rows->{'rowover'} > 0 ) ) {
            print "<p class=\"row_all\">\n<a href=\"$link$amp" . "rowall=on\">全て表\示</a>\n</p>\n\n";
        }
    }

    # 村ログ表示
    print "<hr class=\"invisible_hr\"$net>\n\n";
    require "$cfg->{'DIR_HTML'}/html_vlogsingle_pc.pl";
    my %anchor = (
        logfile => $logfile,
        logkeys => $logkeys,
        rowover => $rowover,
        reqvals => $reqvals,
    );

    if ( ( $query->{'order'} eq 'desc' ) || ( $query->{'order'} eq 'd' ) ) {

        # 降順
        if ( $modesingle == 0 ) {
            print
"<p id=\"newinfo\" class=\"newinfo\"><span id=\"newinfomes\">新着発言はありません。</span><a href=\"#newsay\" id=\"reloadlink\" onclick=\"reloadSowFeed();return false;\">RELOAD</a><img src=\"$cfg->{'DIR_IMG'}/ajax-loader.gif\" style=\"display: none;\"><a href=\"$link&logid=$logid&move=next\" id=\"getnewloglink\" onclick=\"getNewLog(this);return false;\"></a><span class=\"new_date\" id=\"newinfotime\">最終取得時刻 --:--:--</span></p>\n";
        }
        my $i;
        for ( $i = $#$logs ; $i >= 0 ; $i-- ) {
            my $newsay = 0;
            $newsay = 1 if ( $i == 0 );
            my $log =
              $logfile->{'logfile'}->{'file'}->read( $logs->[$i]->{'pos'} );
            &SWHtmlVlogSinglePC::OutHTMLSingleLogPC( $sow, $vil, $log, $i, $newsay, \%anchor, $modesingle );
        }
    }
    else {
        # 昇順
        my $i;
        for ( $i = 0 ; $i < @$logs ; $i++ ) {
            my $newsay = 0;
            $newsay = 1 if ( ( $i == $#$logs ) && ( $modesingle == 0 ) );
            my $log =
              $logfile->{'logfile'}->{'file'}->read( $logs->[$i]->{'pos'} );
            my $logid = $log->{'logid'};
            if (   ( $modesingle == 0 )
                && ( $i == 0 )
                && ( ( $maxrow != 0 ) && ( $rows->{'rowover'} > 0 ) ) )
            {
                if (
                    (
                           ( $log->{'mestype'} eq $sow->{'MESTYPE_INFOSP'} )
                        || ( $log->{'mestype'} eq $sow->{'MESTYPE_TSAY'} )
                    )
                    && ( $vil->isepilogue() == 0 )
                  )
                {
                    $logid = $log->{'maskedid'};
                }
                print
"<p id=\"readmore\" class=\"readmore\"><a href=\"$link&logid=$logid&move=prev\" onclick=\"getMoreLog(this);return false;\">もっと読む</a><img id=\"morelog-ajax-loader\" src=\"$cfg->{'DIR_IMG'}/ajax-loader.gif\" style=\"display: none;\"></p>\n\n";
            }
            &SWHtmlVlogSinglePC::OutHTMLSingleLogPC( $sow, $vil, $log, $i, $newsay, \%anchor, $modesingle );
            if ( $i == $#$logs ) {

                # TODO: できればもっと頭のいい処理にしたい
                my $pi = $i;
                my $prevlog;
                my $mestype = $log->{'mestype'};
                while ( $mestype eq $sow->{'MESTYPE_QUE'} ) {
                    $pi      = $pi - 1;
                    $prevlog = $logfile->{'logfile'}->{'file'}->read( $logs->[$pi]->{'pos'} );
                    $mestype = $prevlog->{'mestype'};
                    $logid   = $prevlog->{'logid'};

                    if (
                        (
                               ( $prevlog->{'mestype'} eq $sow->{'MESTYPE_INFOSP'} )
                            || ( $prevlog->{'mestype'} eq $sow->{'MESTYPE_TSAY'} )
                        )
                        && ( $vil->isepilogue() == 0 )
                      )
                    {
                        $logid = $prevlog->{'maskedid'};
                    }
                    break if ( $pi == 0 );
                }

                if (
                    (
                           ( $log->{'mestype'} eq $sow->{'MESTYPE_INFOSP'} )
                        || ( $log->{'mestype'} eq $sow->{'MESTYPE_TSAY'} )
                    )
                    && ( $vil->isepilogue() == 0 )
                  )
                {
                    $logid = $log->{'maskedid'};
                }
                if ( $modesingle == 0 ) {
                    print
"<p id=\"newinfo\" class=\"newinfo\"><span id=\"newinfomes\">新着発言はありません。</span><a href=\"#newsay\" id=\"reloadlink\" onclick=\"reloadSowFeed();return false;\">RELOAD</a><img src=\"$cfg->{'DIR_IMG'}/ajax-loader.gif\" style=\"display: none;\"><a href=\"$link&logid=$logid&move=next\" id=\"getnewloglink\" onclick=\"getNewLog(this);return false;\"></a><span class=\"new_date\" id=\"newinfotime\">最終取得時刻 --:--:--</span></p>\n";
                }
            }
        }
    }

    # アナウンス／入力・参加フォーム表示
    if (   ( $modesingle == 0 )
        && ( $sow->{'turn'} == $vil->{'turn'} )
        && ( $rows->{'end'} > 0 ) )
    {
        &OutHTMLVlogFormArea( $sow, $vil );
    }

    # 個別フィルタへのリンク
    if ( $modesingle eq 0 ) {
        require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
        &SWHtmlPlayerFormPC::OutHTMLPlayerFilter( $sow, $vil );
    }

    # 日付別ログへのリンク
    if ( $modesingle == 0 ) {

        #		my $list = $logfile->getlist();
        &SWHtmlPC::OutHTMLTurnNavi( $sow, $vil, $logs, $logfilelist, $rows, 1 );
    }

    if ( $modesingle == 0 ) {
        $reqvals            = &SWBase::GetRequestValues($sow);
        $reqvals->{'order'} = '';
        $reqvals->{'row'}   = '';
        my $hidden = &SWBase::GetHiddenValues( $sow, $reqvals, '  ' );

        my $option    = $sow->{'html'}->{'option'};
        my $desc      = '';
        my $asc       = " $sow->{'html'}->{'selected'}";
        my $star_desc = '';
        my $star_asc  = ' *';
        if ( ( $query->{'order'} eq 'd' ) || ( $query->{'order'} eq 'desc' ) ) {
            $desc      = " $sow->{'html'}->{'selected'}";
            $asc       = '';
            $star_desc = ' *';
            $star_asc  = '';
        }

        print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="get" class="viewform">
<p>$hidden
  <label for="row">表\示行数</label>
  <select id="row" name="row">
_HTML_

        my $row_pc = $sow->{'cfg'}->{'ROW_PC'};
        my $row    = $sow->{'cfg'}->{'MAX_ROW'};
        $row = $query->{'row'} if ( defined( $query->{'row'} ) );
        foreach (@$row_pc) {
            my $selected = '';
            my $star     = '';
            if ( $_ == $row ) {
                $selected = " $sow->{'html'}->{'selected'}";
                $star     = ' *';
            }
            print "    <option value=\"$_\"$selected>$_$star$option\n";
        }

        print <<"_HTML_";
  </select>
  <select name="order">
    <option value="asc"$asc>上から下$star_asc$option
    <option value="desc"$desc>下から上$star_desc$option
  </select>
  <input type="submit" value="変更"$net>
</p>
</form>
<hr class="invisible_hr"$net>

_HTML_
    }

    # トップページへ戻る
    &SWHtmlPC::OutHTMLReturnPC($sow) if ( $modesingle == 0 );

    # 発言フィルタ
    $sow->{'html'}->outcontentfooter();
    &SWHtmlSayFilter::OutHTMLSayFilter( $sow, $vil ) if ( $modesingle == 0 );

    return;
}

#----------------------------------------
# アナウンス／入力・参加フォーム表示
#----------------------------------------
sub OutHTMLVlogFormArea {
    my ( $sow, $vil ) = @_;
    my $cfg    = $sow->{'cfg'};
    my $net    = $sow->{'html'}->{'net'};
    my $pllist = $vil->getpllist();
    my $date   = $sow->{'dt'}->cvtdt( $vil->{'nextupdatedt'} );
    my $scraplimit =
      "\n\n<p class=\"caution\">\n" . $sow->{'dt'}->cvtdt( $vil->{'scraplimitdt'} ) . "までに開始しなかった場合、この村は廃村となります。\n</p>";
    $scraplimit = '' if ( $vil->{'scraplimitdt'} == 0 );

    if (   ( $vil->{'turn'} == 0 )
        && ( $vil->checkentried() < 0 )
        && ( $vil->{'vplcnt'} > @$pllist ) )
    {
        # プロローグ未参加／未ログイン時アナウンス
        print <<"_HTML_";
<p class="caution">
演じたいキャラクターを選び、発言してください。<br$net>
ルールをよく理解した上でご参加下さい。<br$net>
※希望能\力についての発言は控えてください。
</p>$scraplimit
<hr class="invisible_hr"$net>
_HTML_
    }
    elsif ( $vil->{'turn'} == 0 ) {
        print $scraplimit;
    }
    elsif ( $vil->isepilogue() > 0 ) {

        # エピローグ用アナウンス
        my $caption_winner = $sow->{'textrs'}->{'CAPTION_WINNER'};
        my $victorytext    = $sow->{'textrs'}->{'ANNOUNCE_VICTORY'};
        my $caption        = $caption_winner->[ $vil->{'winner'} ];
        $victorytext =~ s/_VICTORY_/$caption/g;
        $victorytext = '' if ( $vil->{'winner'} == 0 );
        my $epiloguetext = $sow->{'textrs'}->{'ANNOUNCE_EPILOGUE'};
        $epiloguetext =~ s/_AVICTORY_/$victorytext/g;
        $epiloguetext =~ s/_DATE_/$date/g;
        &SWHtml::ConvertNET( $sow, \$epiloguetext );

        print <<"_HTML_";
<p class="caution">
$epiloguetext
</p>
<hr class="invisible_hr"$net>

_HTML_
    }

    # 未発言者リストの表示
    my $nosaytext = &SWHtmlVlog::GetNoSayListText( $sow, $vil );
    if (   ( $vil->{'turn'} != 0 )
        && ( $vil->isepilogue() == 0 )
        && ( $nosaytext ne '' ) )
    {
        print "<p class=\"caution\">$nosaytext</p>\n";
        print "<hr class=\"invisible_hr\"$net>\n\n";
    }

    # 発言欄／エントリーフォーム
    if ( $vil->{'turn'} == 0 ) {

        # プロローグ
        if ( $sow->{'user'}->logined() > 0 ) {

            # ログイン済み
            if ( $vil->checkentried() >= 0 ) {
                if ( $sow->{'curpl'}->{'limitentrydt'} > 0 ) {
                    my $limitdate =
                      $sow->{'dt'}->cvtdt( $sow->{'curpl'}->{'limitentrydt'} );
                    print <<"_HTML_";
<p class="caution">
$limitdateまでに一度も発言せず村も開始されなかった場合、あなたは自動的に村から追い出されます。<br$net>
※発言すると期限が延長されます。
</p>
_HTML_
                }

                # 発言欄の表示
                require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
                &SWHtmlPlayerFormPC::OutHTMLPlayerFormPC( $sow, $vil );
            }
            elsif ( $vil->{'vplcnt'} > @$pllist ) {

                # エントリーフォームの表示
                require "$cfg->{'DIR_HTML'}/html_entryform_pc.pl";
                &SWHtmlEntryFormPC::OutHTMLEntryFormPC( $sow, $vil );
                &OutHTMLVilMakerInFormPlPC( $sow, $vil );
            }
            else {
                print "<p class=\"caution\">\n既に定員に達しています。\n</p>\n";
                print "<hr class=\"invisible_hr\"$net>\n\n";
                &OutHTMLVilMakerInFormPlPC( $sow, $vil );
            }
        }
        else {
            # 未ログイン
            if ( $vil->{'vplcnt'} > @$pllist ) {
                print "<p class=\"infonologin\">\nゲーム参加者希望者はログインして下さい。\n</p>\n";
                print "<hr class=\"invisible_hr\"$net>\n\n";
            }
            else {
                print "<p class=\"caution\">\n既に定員に達しています。\n</p>\n";
                print "<hr class=\"invisible_hr\"$net>\n\n";
            }
        }
    }
    else {
        # 進行中
        if ( $sow->{'user'}->logined() > 0 ) {

            # ログイン済み
            if ( $vil->checkentried() >= 0 ) {

                # 発言欄の表示
                require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
                &SWHtmlPlayerFormPC::OutHTMLPlayerFormPC( $sow, $vil );
            }
            else {
                # 村建て人／管理人発言フォームの表示
                &OutHTMLVilMakerInFormPlPC( $sow, $vil );
            }
        }
        elsif ( $vil->isepilogue() == 0 ) {

            # 未ログイン
            print "<p class=\"infonologin\">\n参加者はログインして下さい。\n</p>\n";
            print "<hr class=\"invisible_hr\"$net>\n\n";
        }
    }
    return;
}

#----------------------------------------
# 村建て人フォーム／管理人フォームの表示
# （村建て人／管理人が参加していない時）
#----------------------------------------
sub OutHTMLVilMakerInFormPlPC {
    my ( $sow, $vil ) = @_;
    my $cfg = $sow->{'cfg'};

    if ( $vil->{'makeruid'} eq $sow->{'uid'} ) {
        require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
        print "<div class=\"formpl_frame\">\n";
        &SWHtmlPlayerFormPC::OutHTMLVilMakerPC( $sow, $vil, 'maker' )
          if ( ( $vil->{'turn'} == 0 )
            || ( $vil->isepilogue() != 0 )
            || ( $vil->{'makersaymenu'} == 0 ) );
        &SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC( $sow, $vil )
          if ( $vil->{'turn'} == 0 );
        &SWHtmlPlayerFormPC::OutHTMLKickFormPC( $sow, $vil )
          if ( $vil->{'turn'} == 0 );
        print "</div>\n";
    }

    if ( $sow->{'uid'} eq $cfg->{'USERID_ADMIN'} ) {
        require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
        print "<div class=\"formpl_frame\">\n";
        &SWHtmlPlayerFormPC::OutHTMLVilMakerPC( $sow, $vil, 'admin' );
        &SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC( $sow, $vil );
        &SWHtmlPlayerFormPC::OutHTMLScrapVilButtonPC( $sow, $vil )
          if ( $vil->{'turn'} < $vil->{'epilogue'} );
        &SWHtmlPlayerFormPC::OutHTMLExtendScrapVilButtonPC( $sow, $vil )
          if ( $vil->{'turn'} == 0 );
        &SWHtmlPlayerFormPC::OutHTMLKickFormPC( $sow, $vil )
          if ( $vil->{'turn'} == 0 );
        print "</div>\n";
    }

    print "<div class=\"formpl_frame\">\n";
    require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";

    if ( $vil->{'guestmenu'} == 0 ) {
        &SWHtmlPlayerFormPC::OutHTMLVilGuestPC( $sow, $vil, 'guest' );
    }
    print "</div>\n";

    return;
}

1;
