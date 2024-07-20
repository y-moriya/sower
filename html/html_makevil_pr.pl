package SWHtmlMakeVilPreview;

#----------------------------------------
# 村作成プレビューHTMLの表示
#----------------------------------------
sub OutHTMLMakeVilPreview {
    my $sow   = shift;
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};

    # 村作成時値チェック
    require "$sow->{'cfg'}->{'DIR_LIB'}/vld_makevil.pl";
    &SWValidityMakeVil::CheckValidityMakeVil($sow);

    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
    my $vindex = SWFileVIndex->new($sow);
    $vindex->openvindex();
    my $vcnt = $vindex->getactivevcnt();
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "現在稼働中の村の数が上限に達しているので、村を作成できません。", "too many villages." )
      if ( $vcnt >= $sow->{'cfg'}->{'MAX_VILLAGES'} );
    $vindex->closevindex();

    require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";

    $sow->{'html'} = SWHtml->new($sow);           # HTMLモードの初期化
    my $net     = $sow->{'html'}->{'net'};        # Null End Tag
    my $outhttp = $sow->{'http'}->outheader();    # HTTPヘッダの出力
    return if ( $outhttp == 0 );                  # ヘッダ出力のみ
    $sow->{'html'}->outheader('村作成のプレビュー');       # HTMLヘッダの出力
    $sow->{'html'}->outcontentheader();

    print <<"_HTML_";
<h2>村作成のプレビュー</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
_HTML_

    # キャラセットの読み込み
    &SWBase::LoadTextRSWithoutVil( $sow, $query->{'trsid'} );

    # 作成設定部分の表示

    print <<"_HTML_";
<div class="paragraph">
<p class="multicolumn_label">村の名前：</p>
<p class="multicolumn_left">$query->{'vname'}</p>
<br class="multicolumn_clear"$net>

_HTML_

    &SWHtml::ConvertNET( $sow, \$query->{'vcomment'} );

    print <<"_HTML_";
<p class="multicolumn_label">村の説明：</p>
<p class="multicolumn_right">$query->{'vcomment'}</p>
<br class="multicolumn_clear"$net>
</div>

<div class="paragraph">
_HTML_

    my $vplcnt = getinfocap_vplcnt( $query->{'vplcnt'} );
    print <<"_HTML_";
<p class="multicolumn_label">定員：</p>
<p class="multicolumn_left">$vplcnt</p>
<br class="multicolumn_clear"$net>
_HTML_

    if ( $query->{'starttype'} eq 'wbbs' ) {
        my $vplcntstart = getinfocap_vplcntstart( $query->{'vplcntstart'} );
        print <<"_HTML_";
<p class="multicolumn_label">最低人数：</p>
<p class="multicolumn_left">$vplcntstart</p>
<br class="multicolumn_clear"$net>
_HTML_
    }

    my $updatedt = getinfocap_updatedt( $query->{'hour'}, $query->{'minite'} );
    print <<"_HTML_";
<p class="multicolumn_label">更新時間：</p>
<p class="multicolumn_role">$updatedt</p>

_HTML_

    my $interval = getinfocap_updinterval( $query->{'updinterval'} );
    print <<"_HTML_";
<p class="multicolumn_label">更新間隔：</p>
<p class="multicolumn_left">$interval</p>
<br class="multicolumn_clear"$net>

_HTML_

    my $roletable  = getinfocap_roletable( $sow, $query->{'roletable'} );
    my $roletable2 = '';
    if ( $query->{'roletable'} eq 'custom' ) {
        $roletable2 = getinfocap_custom( $sow, $query );
    }
    print <<"_HTML_";
<p class="multicolumn_label">役職配分：</p>
<p class="multicolumn_right">
$roletable<br$net>
$roletable2
</p>
<br class="multicolumn_clear"$net>

_HTML_

    my $votetype = getinfocap_votetype( $query->{'votetype'} );
    print <<"_HTML_";
<p class="multicolumn_label">投票方法：</p>
<p class="multicolumn_left">$votetype</p>
<br class="multicolumn_clear"$net>

_HTML_

    my $scraplimit =
      getinfocap_scraplimit( $sow, $query->{'hour'}, $query->{'minite'} );
    print <<"_HTML_";
<p class="multicolumn_label">廃村期限：</p>
<p class="multicolumn_left">$scraplimit</p>
<br class="multicolumn_clear"$net>

_HTML_

    my $entrylimit = getinfocap_entrylimit( $query->{'entrylimit'} );
    print <<"_HTML_";
<p class="multicolumn_label">参加制限：</p>
<p class="multicolumn_left">$entrylimit</p>
<br class="multicolumn_clear"$net>

_HTML_

    my $csidcaptions = getinfocap_csidcaptions( $sow, $query->{'csid'} );
    print <<"_HTML_";
</div>

<div class="paragraph">
<p class="multicolumn_label">登場人物：</p>
<p class="multicolumn_left">$csidcaptions</p>
<br class="multicolumn_clear"$net>

_HTML_

    $saycnttype = getinfocap_saycnttype( $sow, $query->{'saycnttype'} );
    $starttype  = getinfocap_starttype( $sow, $query->{'starttype'} );
    $trsid      = getinfocap_trsid( $sow, $query->{'trsid'} );

    print <<"_HTML_";
<p class="multicolumn_label">発言制限：</p>
<p class="multicolumn_left">$saycnttype</p>
<br class="multicolumn_clear"$net>

<p class="multicolumn_label">開始方法：</p>
<p class="multicolumn_left">$starttype</p>
<br class="multicolumn_clear"$net>

<p class="multicolumn_label">文章系：</p>
<p class="multicolumn_left">$trsid</p>
<br class="multicolumn_clear"$net>
_HTML_

    if ( $sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0 ) {
        $randomtarget = getinfocap_randomtarget( $query->{'randomtarget'} );
        print <<"_HTML_";

<p class="multicolumn_label">ランダム：</p>
<p class="multicolumn_left">$randomtarget</p>
<br class="multicolumn_clear"$net>
_HTML_
    }

    my $noselrole = getinfocap_noselrole( $query->{'noselrole'} );
    print <<"_HTML_";

<p class="multicolumn_label">役職希望：</p>
<p class="multicolumn_left">$noselrole</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $makersaymenu = getinfocap_makersaymenu( $query->{'makersaymenu'} );
    print <<"_HTML_";

<p class="multicolumn_label">村建て発言：</p>
<p class="multicolumn_left">$makersaymenu</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $entrustmode = getinfocap_entrustmode( $query->{'entrustmode'} );
    print <<"_HTML_";

<p class="multicolumn_label">委任：</p>
<p class="multicolumn_left">$entrustmode</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $showall = getinfocap_showall( $query->{'showall'} );
    print <<"_HTML_";

<p class="multicolumn_label">墓下公開：</p>
<p class="multicolumn_left">$showall</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $rating = getinfocap_rating( $sow, $query->{'rating'} );
    print <<"_HTML_";

<p class="multicolumn_label">閲覧制限：</p>
<p class="multicolumn_left">$rating</p>
<br class="multicolumn_clear"$net>
<hr>
_HTML_

    $noactmode = getinfocap_noactmode( $sow, $query->{'noactmode'} );
    print <<"_HTML_";

<p class="multicolumn_label">act/memo：</p>
<p class="multicolumn_left">$noactmode</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $nocandy = getinfocap_nocandy( $query->{'nocandy'} );
    print <<"_HTML_";

<p class="multicolumn_label">促し：</p>
<p class="multicolumn_left">$nocandy</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $nofreeact = getinfocap_nofreeact( $query->{'nofreeact'} );
    print <<"_HTML_";

<p class="multicolumn_label">自由文act：</p>
<p class="multicolumn_left">$nofreeact</p>
<br class="multicolumn_clear"$net>
<hr>
_HTML_

    my $showid = getinfocap_showid( $query->{'showid'} );
    print <<"_HTML_";

<p class="multicolumn_label">ID公開：</p>
<p class="multicolumn_left">$showid</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $timestamp = getinfocap_timestamp( $query->{'timestamp'} );
    print <<"_HTML_";

<p class="multicolumn_label">時刻表\示：</p>
<p class="multicolumn_left">$timestamp</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $guestmenu = getinfocap_guestmenu( $query->{'guestmenu'} );
    print <<"_HTML_";

<p class="multicolumn_label">傍観者発言：</p>
<p class="multicolumn_left">$guestmenu</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $noque = getinfocap_noque( $query->{'noque'} );
    print <<"_HTML_";

<p class="multicolumn_label">発言保留：</p>
<p class="multicolumn_left">$noque</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $nosudden = getinfocap_nosudden( $query->{'nosudden'} );
    print <<"_HTML_";

<p class="multicolumn_label">突然死：</p>
<p class="multicolumn_left">$nosudden</p>
<br class="multicolumn_clear"$net>
_HTML_

    print "</div>\n\n";

    # 属性値生成
    # 村作成に使用する属性値をすべて取得する
    $query->{'vcomment'} =~ s/<br( \/)?>/&#13\;/ig;
    my @reqkeys = (
        'vname',        'vcomment',     'makeruid',   'roletable', 'hour',        'minite',
        'updinterval',  'vplcnt',       'entrylimit', 'entrypwd',  'rating',      'vplcntstart',
        'saycnttype',   'starttype',    'votetype',   'noselrole', 'entrustmode', 'showall',
        'noactmode',    'nocandy',      'nofreeact',  'guestmenu', 'showid',      'timestamp',
        'randomtarget', 'makersaymenu', 'csid',       'trsid',     'noque',       'nosudden',
    );
    my $reqvals = &SWBase::GetRequestValues( $sow, \@reqkeys );
    my $hidden  = &SWBase::GetHiddenValues( $sow, $reqvals, '  ' );

    # 作成・修正ボタンの表示
    print <<"_HTML_";
<p class="paragraph">この設定で村を作成しますか？
※内容を修正する場合は、ブラウザの戻るボタンで戻るか、村作成完了後に村の編集を行ってください。</p>
<p class="multicolumn_label">
  <input type="hidden" name="cmd" value="makevil"$net>
  <input type="hidden" name="cmdfrom" value="$query->{'cmd'}"$net>$hidden
  <input type="submit" value="村の作成" data-submit-type="makevil"$net>
</p>
</form
<div class="multicolumn_clear">
  <hr class="invisible_hr"$net>
</div>

_HTML_

    &SWHtmlPC::OutHTMLReturnPC($sow);

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();    # HTMLフッタの出力
    $sow->{'http'}->outfooter();

    return;
}

#----------------------------------------
# 村作成時にキャプションを得る
#----------------------------------------
sub getinfocap_vplcnt {
    my $vplcnt = shift;
    return "$vplcnt人 （ダミーキャラを含む）";
}

sub getinfocap_vplcntstart {
    my $vplcntstart = shift;
    return "$vplcntstart人";
}

sub getinfocap_updatedt {
    my ( $hour, $minite ) = @_;
    return sprintf( '%02d時%02d分', $hour, $minite );
}

sub getinfocap_updinterval {
    my $updinterval = shift;
    return sprintf( '%02d時間', $updinterval * 24 );
}

sub getinfocap_roletable {
    my ( $sow, $roletable ) = @_;
    return $sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$roletable};
}

sub getinfocap_custom {
    my ( $sow, $query ) = @_;
    my $roletabletext = '';
    my $roleid        = $sow->{'ROLEID'};
    for ( $i = 1 ; $i < @$roleid ; $i++ ) {
        my $countrole = 0;
        if ( defined( $query->{"cnt$roleid->[$i]"} ) ) {
            $countrole = $query->{"cnt$roleid->[$i]"};
            if ( int($countrole) > 0 ) {
                $roletabletext .= "$sow->{'textrs'}->{'ROLENAME'}->[$i]: $countrole人 ";
            }
        }
    }
    $resultcap = "（$roletabletext）\n";
    return $resultcap;
}

sub getinfocap_votetype {
    my $votetype = shift;
    if ( $votetype eq 'anonymity' ) {
        return '無記名投票';
    }
    elsif ( $votetype eq 'sign' ) {
        return '記名投票';
    }
    else {
        return '';
    }
}

sub getinfocap_scraplimit {
    my ( $sow, $updhour, $updminite ) = @_;
    $scraplimitdt =
      $sow->{'dt'}
      ->getnextupdatedtwithoutvil( $updhour, $updminite, $sow->{'time'}, $sow->{'cfg'}->{'TIMEOUT_SCRAP'}, 1 );
    $resultcap = $sow->{'dt'}->cvtdt($scraplimitdt);
    $resultcap = '自動廃村なし' if ( $scraplimitdt == 0 );
    return $resultcap;
}

sub getinfocap_entrylimit {
    my $entrylimit = shift;
    if ( $entrylimit eq 'password' ) {
        return 'パスワードあり';
    }
    else {
        return 'パスワードなし';
    }
}

sub getinfocap_csidcaptions {
    my ( $sow, $csid ) = @_;
    my $resultcap = '';
    my @pcsidlist = split( '/', $csid );
    chomp(@pcsidlist);
    foreach (@pcsidlist) {
        $sow->{'charsets'}->loadchrrs($_);
        $resultcap .= "$sow->{'charsets'}->{'csid'}->{$_}->{'CAPTION'} ";
    }
    return $resultcap;
}

sub getinfocap_saycnttype {
    my ( $sow, $saycnttype ) = @_;
    return $sow->{'cfg'}->{'COUNTS_SAY'}->{$saycnttype}->{'CAPTION'};
}

sub getinfocap_starttype {
    my ( $sow, $starttype ) = @_;
    return $sow->{'basictrs'}->{'STARTTYPE'}->{$starttype};
}

sub getinfocap_trsid {
    my ( $sow, $trsid ) = @_;
    return $sow->{'textrs'}->{'CAPTION'};
}

sub getinfocap_randomtarget {
    my $randomtarget = shift;
    if ( $randomtarget ne '' ) {
        return '投票・能力の対象に「ランダム」を含める';
    }
    else {
        return '投票・能力の対象に「ランダム」を含めない';
    }
}

sub getinfocap_noselrole {
    my $noselrole = shift;
    if ( $noselrole ne '' ) {
        return '無効';
    }
    else {
        return '有効';
    }
}

sub getinfocap_makersaymenu {
    my $makersaymenu = shift;
    if ( $makersaymenu ne '' ) {
        return '不許可';
    }
    else {
        return '許可';
    }
}

sub getinfocap_entrustmode {
    my $entrustmode = shift;
    if ( $entrustmode ne '' ) {
        return '不許可';
    }
    else {
        return '許可';
    }
}

sub getinfocap_showall {
    my $showall = shift;
    if ( $showall ne '' ) {
        return '公開';
    }
    else {
        return '非公開';
    }
}

sub getinfocap_rating {
    my ( $sow, $rating ) = @_;
    return $sow->{'cfg'}->{'RATING'}->{$rating}->{'CAPTION'};
}

sub getinfocap_noactmode {
    my ( $sow, $noactmode ) = @_;
    my $noactlist = $sow->{'cfg'}->{'NOACTLIST'};
    return @$noactlist[$noactmode];
}

sub getinfocap_nocandy {
    my $nocandy = shift;
    if ( $nocandy ne '' ) {
        return 'なし';
    }
    else {
        return 'あり';
    }
}

sub getinfocap_showid {
    my $showid = shift;
    if ( $showid ne '' ) {
        return 'あり';
    }
    else {
        return 'なし';
    }
}

sub getinfocap_nofreeact {
    my $nocandy = shift;
    if ( $nocandy ne '' ) {
        return 'なし';
    }
    else {
        return 'あり';
    }
}

sub getinfocap_timestamp {
    my $timestamp = shift;
    if ( $timestamp ne '' ) {
        return '簡略表\示';
    }
    else {
        return '完全表\示';
    }
}

sub getinfocap_guestmenu {
    my $guestmenu = shift;
    if ( $guestmenu ne '' ) {
        return 'なし';
    }
    else {
        return 'あり';
    }
}

sub getinfocap_noque {
    my $noque = shift;
    if ( $noque ne '' ) {
        return 'なし';
    }
    else {
        return 'あり';
    }
}

sub getinfocap_nosudden {
    my $nosudden = shift;
    if ( $nosudden ne '' ) {
        return 'なし';
    }
    else {
        return 'あり';
    }
}

1;
