package SWHtmlMakeVilForm;

#----------------------------------------
# 村作成／編集画面のHTML出力
#----------------------------------------
sub OutHTMLMakeVilForm {
    my ( $sow, $vil ) = @_;
    my $cfg = $sow->{'cfg'};

    my $vmode = '作成';
    my $vcmd  = 'makevilpr';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $vmode = '編集';
        $vcmd  = 'editvil';
    }

    $sow->{'html'} = SWHtml->new($sow);       # HTMLモードの初期化
    my $net = $sow->{'html'}->{'net'};        # Null End Tag
    $sow->{'http'}->outheader();              # HTTPヘッダの出力
    $sow->{'html'}->outheader("村の$vmode");    # HTMLヘッダの出力
    $sow->{'html'}->outcontentheader();

    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'vid'} = '';
    my $hidden = &SWBase::GetHiddenValues( $sow, $reqvals, '    ' );
    my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
    &SWBase::LoadTextRS( $sow, $vil );

    &SWHtmlPC::OutHTMLLogin($sow);            # ログインボタン

    # 日付別ログへのリンク
    &SWHtmlPC::OutHTMLTurnNavi( $sow, $vil )
      if ( $sow->{'query'}->{'cmd'} eq 'editvilform' );

    print <<"_HTML_";
<h2>村の$vmode</h2>

_HTML_

    print "<p class=\"caution\">村を$vmodeするにはログインが必要です。</p>\n\n"
      if ( $sow->{'user'}->logined() <= 0 );

    print <<"_HTML_";
<p class="paragraph">
募集期限は作成した日から$sow->{'cfg'}->{'TIMEOUT_SCRAP'}日間です。期限内に村が開始しなかった場合、廃村となります。
</p>

_HTML_

    my $vcomment = $vil->{'vcomment'};
    $vcomment =~ s/<br( \/)?>/\n/ig;
    my $vplcnt = 16;
    $vplcnt = $vil->{'vplcnt'} if ( $sow->{'query'}->{'cmd'} eq 'editvilform' );
    my $vplcntstart = 16;
    $vplcntstart = $vil->{'vplcntstart'}
      if ( $sow->{'query'}->{'cmd'} eq 'editvilform' );

    print <<"_HTML_";
<form action="$urlsow" method="$cfg->{'METHOD_FORM'}">
<div class="form_vmake">
  <fieldset>
    <legend>村の名前と説明</legend>
    <label for="vname" class="multicolumn_label" >村の名前：</label>
    <input id="vname" class="multicolumn_left" type="text" name="vname" value="$vil->{'vname'}" size="30"$net>
    <br class="multicolumn_clear"$net>

    <label for="vcomment" class="multicolumn_label">村の説明：</label>
    <textarea id="vcomment" class="multicolumn_left" name="vcomment" cols="30" rows="3">$vcomment</textarea>
  </fieldset>

  <fieldset>
    <legend>基本設定</legend>
    <label for="vplcnt" class="multicolumn_label" >定員：</label>
    <input id="vplcnt" class="multicolumn_left" type="text" name="vplcnt" value="$vplcnt" size="5"$net>
    <br class="multicolumn_clear"$net>

    <label for="vplcntstart" class="multicolumn_label" >最低人数：</label>
    <input id="vplcntstart" class="multicolumn_left" type="text" name="vplcntstart" value="$vplcntstart" size="5"$net> ※開始方法が人狼BBS型の時のみ
    <br class="multicolumn_clear"$net>

    <label for="updhour" class="multicolumn_label">更新時間：</label>
    <select id="updhour" name="hour" class="multicolumn_left">
_HTML_

    my $i;
    for ( $i = 0 ; $i < 24 ; $i++ ) {
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'updhour'} == $i );
        print
          "      <option value=\"$i\"$selected>$i時$sow->{'html'}->{'option'}\n";
    }

    print <<"_HTML_";
    </select>
    <select id="updminite" name="minite" class="multicolumn_left">
_HTML_

    for ( $i = 0 ; $i < 60 ; $i += 30 ) {
        my $min      = sprintf( '%02d分', $i );
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'updminite'} == $i );
        print
"      <option value=\"$i\"$selected>$min$sow->{'html'}->{'option'}\n";
    }

    print <<"_HTML_";
    </select>に更新
    <br class="multicolumn_clear"$net>

    <label for="updinterval" class="multicolumn_label">更新間隔：</label>
    <select id="updinterval" name="updinterval" class="multicolumn_left">
_HTML_

    for ( $i = 1 ; $i <= 3 ; $i++ ) {
        my $interval = sprintf( '%02d時間', $i * 24 );
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'updinterval'} == $i );
        print
"      <option value=\"$i\"$selected>$interval$sow->{'html'}->{'option'}\n";
    }

    my $votetype_anonymity = " $sow->{'html'}->{'selected'}";
    my $votetype_sign      = '';
    if ( $vil->{'votetype'} eq 'sign' ) {
        $votetype_anonymity = '';
        $votetype_sign      = " $sow->{'html'}->{'selected'}";
    }

    print <<"_HTML_";
    </select>ごとに更新
    <br class="multicolumn_clear"$net>

    <label for="votetype" class="multicolumn_label">投票方法：</label>
    <select id="votetype" name="votetype" class="multicolumn_left">
      <option value="anonymity"$votetype_anonymity>無記名投票$sow->{'html'}->{'option'}
      <option value="sign"$votetype_sign>記名投票$sow->{'html'}->{'option'}
    </select>
    <br class="multicolumn_clear"$net>

    <label for="roletable" class="multicolumn_label">役職配分：</label>
    <select id="roletable" name="roletable" class="multicolumn_left">
_HTML_

    my $order_roletable = $sow->{'ORDER_ROLETABLE'};
    foreach (@$order_roletable) {
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'roletable'} eq $_ );
        print
"      <option value=\"$_\"$selected>$sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$_}$sow->{'html'}->{'option'}\n";
    }

    #      <option value="later">後で設定$sow->{'html'}->{'option'}

    print <<"_HTML_";
    </select>
    <br class="multicolumn_clear"$net>
  </fieldset>

  <fieldset>
    <legend>役職配分自由設定</legend>
_HTML_

    my $roleid = $sow->{'ROLEID'};
    for ( $i = 1 ; $i < @$roleid ; $i++ ) {
        print <<"_HTML_";
    <div class="multicolumn_label"><label for="cnt$roleid->[$i]">$sow->{'textrs'}->{'ROLENAME'}->[$i]：</label></div>
    <div class="multicolumn_role"><input id="cnt$roleid->[$i]" type="text" name="cnt$roleid->[$i]" size="3" value="$vil->{"cnt$roleid->[$i]"}"$net> 人</div>
_HTML_
        print "    <br class=\"multicolumn_clear\"$net>\n\n"
          if ( ( $i + 1 ) % 2 == 1 );
    }

    my $limitfree     = " $sow->{'html'}->{'checked'}";
    my $limitpassword = '';
    if ( $vil->{'entrylimit'} eq 'password' ) {
        $limitfree     = '';
        $limitpassword = " $sow->{'html'}->{'checked'}";
    }

    print <<"_HTML_";
  </fieldset>

  <fieldset>
    <legend>参加制限</legend>
    <label><input type="radio" name="entrylimit" value="free"$limitfree$net>制限なし</label><br$net>
    <label>
      <input type="radio" name="entrylimit" value="password"$limitpassword$net>参加用パスワード必須（半角８文字以内）
    </label>
    <input type="password" name="entrypwd" maxlength="8" size="8" value="$vil->{'entrypwd'}"$net>
    <br class="multicolumn_clear"$net>
  </fieldset>

  <fieldset>
    <legend>拡張設定</legend>
    <label for="csid" class="multicolumn_label">登場人物：</label>
    <select id="csid" name="csid" class="multicolumn_left">
_HTML_

    my $csidlist = $sow->{'cfg'}->{'CSIDLIST'};
    foreach (@$csidlist) {
        my @csids = split( '/', "$_/" );
        my @captions;
        foreach (@csids) {
            $sow->{'charsets'}->loadchrrs($_);
            push( @captions, $sow->{'charsets'}->{'csid'}->{$_}->{'CAPTION'} );
        }
        my $caption  = join( 'と', @captions );
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}" if ( $vil->{'csid'} eq $_ );
        print
"      <option value=\"$_\"$selected> $caption$sow->{'html'}->{'option'}\n";
    }

    # 村編集で登場人物欄を変更すると……。

    print <<"_HTML_";
    </select>
    <br class="multicolumn_clear"$net>

    <label for="saycnttype" class="multicolumn_label">発言制限： </label>
    <select id="saycnttype" name="saycnttype" class="multicolumn_left">
_HTML_

    my $countssay       = $sow->{'cfg'}->{'COUNTS_SAY'};
    my $countssay_order = $countssay->{'ORDER'};
    foreach (@$countssay_order) {
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'saycnttype'} eq $_ );
        print
"      <option value=\"$_\"$selected>$countssay->{$_}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
    }

    print <<"_HTML_";
    </select>
    <br class="multicolumn_clear"$net>

    <label for="starttype" class="multicolumn_label">開始方法： </label>
    <select id="starttype" name="starttype" class="multicolumn_left">
_HTML_

    my $starttype      = $sow->{'basictrs'}->{'STARTTYPE'};
    my $starttypeorder = $sow->{'basictrs'}->{'ORDER_STARTTYPE'};

    foreach (@$starttypeorder) {
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'starttype'} eq $_ );
        print
"      <option value=\"$_\"$selected>$starttype->{$_}$sow->{'html'}->{'option'}\n";
    }

    # システムの文章
    print <<"_HTML_";
    </select>
    <br class="multicolumn_clear"$net>

    <label for="trsid" class="multicolumn_label">文章： </label>
    <select id="trsid" name="trsid" class="multicolumn_left">
_HTML_

    my $defaulttrsid  = $sow->{'trsid'};
    my $defaulttextrs = $sow->{'textrs'};
    my $trsidlist     = $sow->{'cfg'}->{'TRSIDLIST'};
    foreach (@$trsidlist) {
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'trsid'} eq $_ );

        my %dummyvil = ( trsid => $_, );
        &SWBase::LoadTextRS( $sow, \%dummyvil );
        print
"      <option value=\"$_\"$selected>$sow->{'textrs'}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
    }
    $sow->{'trsid'}  = $defaulttrsid;
    $sow->{'textrs'} = $defaulttextrs;

    print <<"_HTML_";
    </select>
    <br class="multicolumn_clear"$net>

_HTML_

    # ランダム対象
    if ( $sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0 ) {
        my $checkedrndtarget = '';
        $checkedrndtarget = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'randomtarget'} > 0 );

        print <<"_HTML_";
    <label for="randomtarget" class="multicolumn_label">ランダム： </label>
    <input type="checkbox" id="randomtarget" class="multicolumn_left" name="randomtarget" value="on"$checkedrndtarget$net><div class="multicolumn_notes"><label for="randomtarget">投票・能\力の対象に「ランダム」を含める</label></div>

_HTML_
    }

    # 役職希望無視
    my $checkednoselrole = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkednoselrole = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'noselrole'} > 0 );
    }
    else {
        $checkednoselrole = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_NOSELROLE'} > 0 );
    }

    print <<"_HTML_";
    <label for="noselrole" class="multicolumn_label">役職希望： </label>
    <input type="checkbox" id="noselrole" class="multicolumn_left" name="noselrole" value="on"$checkednoselrole$net><div class="multicolumn_notes"><label for="noselrole">役職希望を無視する</label></div>
_HTML_

    # 進行中村建て発言なし
    my $checkedmakersaymenu = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkedmakersaymenu = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'makersaymenu'} > 0 );
    }
    else {
        $checkedmakersaymenu = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_MAKERSAYMENU'} > 0 );
    }

    print <<"_HTML_";
	<label for="makersaymenu" class="multicolumn_label">村建て発言： </label>
	<input type="checkbox" id="makersaymenu" class="multicolumn_left" name="makersaymenu" value="on"$checkedmakersaymenu$net><div class="multicolumn_notes"><label for="makersaymenu">村進行中に村建て人発言ができなくなる</label></div>
_HTML_

    # 傍観者発言なし
    my $checkedguestmenu = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkedguestmenu = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'guestmenu'} > 0 );
    }
    else {
        $checkedguestmenu = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_GUESTMENU'} > 0 );
    }

    print <<"_HTML_";
	<label for="guestmenu" class="multicolumn_label">傍観者発言： </label>
	<input type="checkbox" id="guestmenu" class="multicolumn_left" name="guestmenu" value="on"$checkedguestmenu$net><div class="multicolumn_notes"><label for="guestmenu">傍観者発言を不可にする</label></div>
  </fieldset>
_HTML_

    # 委任なし
    my $checkedentrustmode = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkedentrustmode = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'entrustmode'} > 0 );
    }
    else {
        $checkedentrustmode = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_ENTRUSTMODE'} > 0 );
    }

    print <<"_HTML_";
	<label for="entrustmode" class="multicolumn_label">委任： </label>
	<input type="checkbox" id="entrustmode" class="multicolumn_left" name="entrustmode" value="on"$checkedentrustmode$net><div class="multicolumn_notes"><label for="entrustmode">委任機能\を使わないようにする</label></div>
_HTML_

    # 墓下公開
    my $checkedshowall = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkedshowall = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'showall'} > 0 );
    }
    else {
        $checkedshowall = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_SHOWALL'} > 0 );
    }

    print <<"_HTML_";
	<label for="showall" class="multicolumn_label">墓下公開： </label>
	<input type="checkbox" id="showall" class="multicolumn_left" name="showall" value="on"$checkedshowall$net><div class="multicolumn_notes"><label for="showall">墓下からは全役職と囁きが見えるようにする</label></div>
_HTML_

    print <<"_HTML_";
    <label for="rating" class="multicolumn_label">閲覧制限： </label>
    <select id="rating" name="rating" class="multicolumn_left">
_HTML_

    # レイティング
    my $rating = $sow->{'cfg'}->{'RATING'};
    foreach ( @{ $rating->{'ORDER'} } ) {
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'rating'} eq $_ );
        print
"      <option value=\"$_\"$selected>$rating->{$_}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
    }

    print <<"_HTML_";
    </select>
    <br class="multicolumn_clear"$net>
  </fieldset>
_HTML_

    # アクション/メモ関係
    print <<"_HTML_";
  <fieldset>
    <legend>アクション/メモ関係</legend>
    <label for="noactmode" class="multicolumn_label">act/memo： </label>
    <select id="noactmode" name="noactmode" class="multicolumn_left">
_HTML_

    my $noactlist = $sow->{'cfg'}->{'NOACTLIST'};
    my $i         = 0;
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        foreach (@$noactlist) {
            my $selected = '';
            $selected = " $sow->{'html'}->{'selected'}"
              if ( $vil->{'noactmode'} eq $i );
            print
"      <option value=\"$i\"$selected>$_$sow->{'html'}->{'option'}\n";
            $i++;
        }
    }
    else {
        foreach (@$noactlist) {
            my $selected = '';
            $selected = " $sow->{'html'}->{'selected'}"
              if ( $cfg->{'DEFAULT_NOACTMODE'} eq $i );
            print
"      <option value=\"$i\"$selected>$_$sow->{'html'}->{'option'}\n";
            $i++;
        }
    }
    print <<"_HTML_";
    </select>
    <br class="multicolumn_clear"$net>

_HTML_

    my $checkednocandy = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkednocandy = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'nocandy'} > 0 );
    }
    else {
        $checkednocandy = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_NOCANDY'} > 0 );
    }

    print <<"_HTML_";
	<label for="nocandy" class="multicolumn_label">促し(飴)： </label>
	<input type="checkbox" id="nocandy" class="multicolumn_left" name="nocandy" value="on"$checkednocandy$net><div class="multicolumn_notes"><label for="nocandy">促しを使えないようにする</label></div>
_HTML_

    my $checkednofreeact = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkednofreeact = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'nofreeact'} > 0 );
    }
    else {
        $checkednofreeact = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_NOFREEACT'} > 0 );
    }

    print <<"_HTML_";
	<label for="nofreeact" class="multicolumn_label">自由文： </label>
	<input type="checkbox" id="nofreeact" class="multicolumn_left" name="nofreeact" value="on"$checkednofreeact$net><div class="multicolumn_notes"><label for="nofreeact">自由文アクションを使えないようにする</label></div>
  </fieldset>

  <fieldset>
	<legend>色々表\示関係</legend>
_HTML_

    my $checkedshowid = '';
    $checkedshowid = " $sow->{'html'}->{'checked'}" if ( $vil->{'showid'} > 0 );

    print <<"_HTML_";
	<label for="showid" class="multicolumn_label">ＩＤ公開： </label>
	<input type="checkbox" id="showid" class="multicolumn_left" name="showid" value="on"$checkedshowid$net><div class="multicolumn_notes"><label for="showid">最初からプレイヤーＩＤを公開する</label></div>
_HTML_

    my $checkedtimestamp = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkedtimestamp = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'timestamp'} > 0 );
    }
    else {
        $checkedtimestamp = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_TIMESTAMP'} > 0 );
    }

    print <<"_HTML_";
	<label for="timestamp" class="multicolumn_label">時刻表\示： </label>
	<input type="checkbox" id="timestamp" class="multicolumn_left" name="timestamp" value="on"$checkedtimestamp$net><div class="multicolumn_notes"><label for="timestamp">進行中、時刻を10分刻みの簡易表\示にする</label></div>
  </fieldset>
_HTML_

    print <<"_HTML_";
  <div class="exevmake">
    <input type="hidden" name="cmd" value="$vcmd"$net>$hidden
    <input type="hidden" name="makeruid" value="$sow->{'uid'}"$net>$hidden
_HTML_

    print
      "    <input type=\"hidden\" name=\"vid\" value=\"$vil->{'vid'}\"$net>\n"
      if ( $vcmd eq 'editvil' );

    my $disabled = '';
    $disabled = " $sow->{'html'}->{'disabled'}"
      if ( $sow->{'user'}->logined() <= 0 );

    print <<"_HTML_";
    <input type="submit" value="村の$vmode"$disabled$net>
  </div>
</div>
</form>

_HTML_

    # 日付別ログへのリンク
    &SWHtmlPC::OutHTMLTurnNavi( $sow, $vil )
      if ( $sow->{'query'}->{'cmd'} eq 'editvilform' );

    &SWHtmlPC::OutHTMLReturnPC($sow);    # トップページへ戻る

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();         # HTMLフッタの出力
    $sow->{'http'}->outfooter();

    return;
}

1;
