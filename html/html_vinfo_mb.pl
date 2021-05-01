package SWHtmlVilInfoMb;

#----------------------------------------
# 村情報画面のHTML出力（モバイル）
#----------------------------------------
sub OutHTMLVilInfoMb {
    my $sow   = $_[0];
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};
    my $i;

    require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";

    # 村データの読み込み
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();
    $vil->closevil();

    # リソースの読み込み
    &SWBase::LoadVilRS( $sow, $vil );

    $sow->{'html'} = SWHtml->new($sow);                                                      # HTMLモードの初期化
    $sow->{'http'}->outheader();                                                             # HTTPヘッダの出力
    $sow->{'html'}->outheader("村の情報 / $sow->{'query'}->{'vid'} $vil->{'vname'}");    # HTMLヘッダの出力
    $sow->{'html'}->outcontentheader();

    my $vplcntstart = '';
    $vplcntstart = $vil->{'vplcntstart'} if ( $vil->{'vplcntstart'} > 0 );

    my $net    = $sow->{'html'}->{'net'};                                                    # Null End Tag
    my $amp    = $sow->{'html'}->{'amp'};
    my $atr_id = $sow->{'html'}->{'atr_id'};

    # 村名及びリンク表示
    print "<a $atr_id=\"top\">$sow->{'query'}->{'vid'} $vil->{'vname'}</a><br$net>\n";

    # キャラ名表示
    if ( defined( $sow->{'curpl'}->{'uid'} ) ) {
        my $chrname  = $sow->{'curpl'}->getchrname();
        my $rolename = '';
        $rolename = "($sow->{'textrs'}->{'ROLENAME'}->[$sow->{'curpl'}->{'role'}])"
          if ( $sow->{'curpl'}->{'role'} > 0 );
        print "$chrname$rolename<br$net>\n";
    }

    # 日付別ログへのリンク
    &SWHtmlMb::OutHTMLTurnNaviMb( $sow, $vil, 0 );

    my $pllist  = $vil->getpllist();
    my $lastcnt = $vil->{'vplcnt'} - @$pllist;
    if ( ( $vil->{'turn'} == 0 ) && ( $lastcnt > 0 ) ) {
        print <<"_HTML_";
あと $lastcnt 人参加できます。
<hr$net>
_HTML_
    }

    print <<"_HTML_";
■村の名前<br$net>$vil->{'vname'}
<hr$net>
■村の説明<br$net>$vil->{'vcomment'}
<hr$net>
_HTML_

    if ( $vil->isepilogue() == 1 ) {
        print <<"_HTML_";
■作成者<br$net>$vil->{'makeruid'}
<hr$net>
_HTML_
    }

    print <<"_HTML_";
■絞り込み：<br$net>
_HTML_

    #print "(プロローグは対象外)<br$net>\n"; if ($vil->{'turn'} == 0);

    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'pno'} = '';
    my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
    my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

    print "□生存者<br$net>\n";
    &OutHTMLSayFilterPlayersMb( $sow, $vil, 'live' );
    print "□犠牲者<br$net>\n";
    &OutHTMLSayFilterPlayersMb( $sow, $vil, 'victim' );
    print "□処刑者<br$net>\n";
    &OutHTMLSayFilterPlayersMb( $sow, $vil, 'executed' );
    print "□突然死者<br$net>\n";
    &OutHTMLSayFilterPlayersMb( $sow, $vil, 'suddendead' );

    print "<a href=\"$urlsow?$linkvalue\">解除</a><br$net>\n";    #if ($vil->{'turn'} != 0);

    print <<"_HTML_";
<hr$net>

_HTML_

    if ( ( $vil->{'turn'} > 0 ) && ( $vil->isepilogue() == 0 ) ) {

        # コミット状況
        my $textrs       = $sow->{'textrs'};
        my $totalcommit  = &SWBase::GetTotalCommitID( $sow, $vil );
        my $nextcommitdt = '';
        if ( $totalcommit == 3 ) {
            $nextcommitdt = $sow->{'dt'}->cvtdtmb( $vil->{'nextcommitdt'} );
            $nextcommitdt = "<br$net>(" . $nextcommitdt . '更新予定)' . "<br$net>";
        }

        print <<"_HTML_";
■コミット状況：<br$net>$textrs->{'ANNOUNCE_TOTALCOMMIT'}->[$totalcommit]
$nextcommitdt<hr$net>

_HTML_
    }

    if ( $vil->{'turn'} == 0 ) {
        print <<"_HTML_";
■定員（ダミー込み）<br$net>$vil->{'vplcnt'}人
<hr$net>
_HTML_
    }
    else {
        my $plcnt = @$pllist;
        print <<"_HTML_";
■人数（ダミー込み）<br$net>$plcnt人
<hr$net>
_HTML_
    }

    if ( ( $vil->{'starttype'} eq 'wbbs' ) && ( $vil->{'turn'} == 0 ) ) {
        print <<"_HTML_";
■最低人数<br$net>$vplcntstart人
<hr$net>
_HTML_
    }

    my $updatedt =
      sprintf( "%02d時%02d分", $vil->{'updhour'}, $vil->{'updminite'} );
    print <<"_HTML_";
■更新時間<br$net>$updatedt
<hr$net>
_HTML_

    my $interval = sprintf( '%02d時間', $vil->{'updinterval'} * 24 );
    print <<"_HTML_";
■更新間隔<br$net>$interval
<hr$net>
_HTML_

    my $roleid = $sow->{'ROLEID'};
    my $roletabletext;

    print <<"_HTML_";
■役職配分：<br$net>$sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$vil->{'roletable'}}
_HTML_

    if ( $vil->{'turn'} > 0 ) {

        # 役職配分表示
        require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
        my $rolematrix = &SWSetRole::GetSetRoleTable( $sow, $vil, $vil->{'roletable'}, scalar(@$pllist) );
        $roletabletext = '';
        for ( $i = 1 ; $i < @$roleid ; $i++ ) {
            my $roleplcnt = $rolematrix->[$i];
            $roleplcnt++ if ( $i == $sow->{'ROLEID_VILLAGER'} );    # ダミーキャラの分１増やす
            if ( $roleplcnt > 0 ) {
                $roletabletext .= "$sow->{'textrs'}->{'ROLENAME'}->[$i]: $roleplcnt人 ";
            }
        }
        print "（$roletabletext）<br$net>\n";
    }
    elsif ( $vil->{'roletable'} eq 'custom' ) {

        # 役職配分設定表示（自由設定時）
        $roletabletext = '';
        for ( $i = 1 ; $i < @$roleid ; $i++ ) {
            if ( $vil->{"cnt$roleid->[$i]"} > 0 ) {
                $roletabletext .= "$sow->{'textrs'}->{'ROLENAME'}->[$i]: $vil->{'cnt' . $roleid->[$i]}人 ";
            }
        }
        print "（$roletabletext）<br$net>\n";
    }
    print "<hr$net>\n";

    my %votecaption = (
        anonymity => '無記名投票',
        sign      => '記名投票',
    );
    my $votetype = '----';
    if ( defined( $vil->{'votetype'} ) ) {
        $votetype = $votecaption{ $vil->{'votetype'} }
          if ( defined( $votecaption{ $vil->{'votetype'} } ) );
    }
    print <<"_HTML_";
■投票方法<br$net>$votetype
<hr$net>
_HTML_

    if ( $vil->{'turn'} == 0 ) {
        my $scraplimit = $sow->{'dt'}->cvtdtmb( $vil->{'scraplimitdt'} );
        $scraplimit = '自動廃村なし' if ( $vil->{'scraplimitdt'} == 0 );
        print <<"_HTML_";
■廃村期限：<br$net>$scraplimit
<hr$net>

_HTML_
    }

    my @csidlist = split( '/', "$vil->{'csid'}/" );
    chomp(@csidlist);
    my $csidcaptions;
    foreach (@csidlist) {
        $sow->{'charsets'}->loadchrrs($_);
        $csidcaptions .= "$sow->{'charsets'}->{'csid'}->{$_}->{'CAPTION'} ";
    }

    print <<"_HTML_";
■登場人物<br$net>$csidcaptions
<hr$net>
■発言制限：<br$net>$sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}}->{'CAPTION'}
<hr$net>
■開始方法：<br$net>$sow->{'basictrs'}->{'STARTTYPE'}->{$vil->{'starttype'}}
<hr$net>
■文章系：<br$net>$sow->{'textrs'}->{'CAPTION'}
<hr$net>
_HTML_

    if ( $sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0 ) {
        my $randomtarget = '投票・能力の対象に「ランダム」を含めない';
        $randomtarget = '投票・能力の対象に「ランダム」を含める' if ( $vil->{'randomtarget'} > 0 );
        print <<"_HTML_";
■ランダム：<br$net>$randomtarget
<hr$net>
_HTML_
    }

    my $noselrole = '役職希望有効';
    $noselrole = '役職希望無効' if ( $vil->{'noselrole'} > 0 );
    print <<"_HTML_";
■役職希望：<br$net>$noselrole
<hr$net>

_HTML_

    my $makersaymenu = '許可';
    $makersaymenu = '不可' if ( $vil->{'makersaymenu'} > 0 );
    print <<"_HTML_";
■村建て発言：<br$net>$makersaymenu
<hr$net>
_HTML_

    my $guestmenu = 'あり';
    $guestmenu = 'なし' if ( $vil->{'guestmenu'} > 0 );
    print <<"_HTML_";
■傍観者発言：<br$net>$guestmenu
<hr$net>
_HTML_

    my $entrustmode = '許可';
    $entrustmode = '不可' if ( $vil->{'entrustmode'} > 0 );
    print <<"_HTML_";
■委任：<br$net>$entrustmode
<hr$net>
_HTML_

    my $showall = '非公開';
    $showall = '公開' if ( $vil->{'showall'} > 0 );
    print <<"_HTML_";
■墓下公開：<br$net>$showall
<hr$net>
_HTML_

    my $rating = 'default';
    $rating = $vil->{'rating'} if ( $vil->{'rating'} ne '' );
    print <<"_HTML_";
■閲覧制限：<br$net>$sow->{'cfg'}->{'RATING'}->{$rating}->{'CAPTION'}
<hr$net>

_HTML_

    my $noactlist = $sow->{'cfg'}->{'NOACTLIST'};
    my $noactmode = @$noactlist[ $vil->{'noactmode'} ];
    print <<"_HTML_";
■act/memo：<br$net>$noactmode
<hr$net>
_HTML_

    my $nocandy = 'あり';
    $nocandy = 'なし' if ( $vil->{'nocandy'} > 0 );
    print <<"_HTML_";
■促し：<br$net>$nocandy
<hr$net>
_HTML_

    my $nofreeact = 'あり';
    $nofreeact = 'なし' if ( $vil->{'nofreeact'} > 0 );
    print <<"_HTML_";
■自由文アクション：<br$net>$nofreeact
<hr$net>
_HTML_

    my $showid = '公開しない';
    $showid = '公開する' if ( $vil->{'showid'} > 0 );
    print <<"_HTML_";
■ID公開：<br$net>$showid
<hr$net>
_HTML_

    my $timestamp = '完全表示';
    $timestamp = '簡略表示' if ( $vil->{'timestamp'} > 0 );
    print <<"_HTML_";
■時刻表\示：<br$net>$timestamp
<hr$net>
_HTML_

    # 日付別ログへのリンク
    &SWHtmlMb::OutHTMLTurnNaviMb( $sow, $vil, 1 );

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();    # HTMLフッタの出力
    $sow->{'http'}->outfooter();

    return;
}

#----------------------------------------
# 個人フィルタの人物欄の表示
#----------------------------------------
sub OutHTMLSayFilterPlayersMb {
    my ( $sow, $vil, $livetype ) = @_;
    my $cfg = $sow->{'cfg'};
    my $net = $sow->{'html'}->{'net'};    # Null End Tag
    my $amp = $sow->{'html'}->{'amp'};

    my $pllist = $vil->getpllist();
    my @filterlist;
    foreach (@$pllist) {
        push( @filterlist, $_ ) if ( $_->{'live'} eq $livetype );
        if ( $livetype eq 'victim' ) {
            push( @filterlist, $_ )
              if ( ( $_->{'live'} eq 'cursed' )
                || ( $_->{'live'} eq 'rcursed' )
                || ( $_->{'live'} eq 'suicide' ) );
        }
    }

    @filterlist = sort {
            $a->{'deathday'} <=> $b->{'deathday'}
          ? $a->{'deathday'} <=> $b->{'deathday'}
          : $a->{'pno'} <=> $b->{'pno'}
    } @filterlist if ( $livetype ne 'live' );

    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'pno'} = '';
    my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
    my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

    foreach (@filterlist) {
        my $chrname = $_->getchrname();
        my $unit =
          $sow->{'basictrs'}->{'SAYTEXT'}->{ $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} }->{'COUNT_TYPE'} }
          ->{'UNIT_SAY'};
        my $restsay = $_->{'say'};
        $restsay = $_->{'gsay'} if ( $_->{'live'} ne 'live' );
        $restsay = $_->{'psay'} if ( $vil->{'turn'} == 0 );
        $restsay = $_->{'esay'} if ( $vil->isepilogue() != 0 );

        my $live = 'live';
        $live = $sow->{'curpl'}->{'live'}
          if ( defined( $sow->{'curpl'}->{'live'} ) );
        my $showid = "";
        $showid = " ($_->{'uid'})"
          if ( $vil->isepilogue() != 0
            || ( $vil->{'showid'} > 0 )
            || ( $sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'} ) );
        my $rolename = '';
        $rolename = " [$sow->{'textrs'}->{'ROLENAME'}->[$_->{'role'}]]"
          if ( $_->{'role'} > 0 );
        my $live = 'live';
        $live = $sow->{'curpl'}->{'live'}
          if ( defined( $sow->{'curpl'}->{'live'} ) );
        my $showall = "";
        $showall = " $rolename"
          if ( $vil->isepilogue() != 0
            || ( $vil->{'showall'} > 0 && $live ne 'live' )
            || ( $sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'} ) );

        #if ($vil->{'turn'} == 0) {
        #	print "$chrname";
        #} else {
        print "<a href=\"$urlsow?$linkvalue$amp"
          . "pno=$_->{'pno'}\">$chrname</a>$showid$showall [<a href=\"$urlsow?$linkvalue$amp"
          . "pno=$_->{'pno'}$amp"
          . "cmd=mbimg\">顔</a>]";

        #}
        print " ($_->{'deathday'}d)" if ( $livetype ne 'live' );
        if (   ( $_->{'live'} eq 'live' )
            || ( $live ne 'live' )
            || ( $vil->isepilogue() != 0 ) )
        {
            print " 残$restsay$unit<br$net>\n";
        }
        else {
            print "<br$net>\n";
        }
    }

    return;
}

1;
