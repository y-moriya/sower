package SWHtmlEditProfileForm;

#----------------------------------------
# ユーザー情報編集画面のHTML出力
#----------------------------------------
sub OutHTMLEditProfileForm {
    my ( $sow, $vindex ) = @_;
    my $cfg    = $sow->{'cfg'};
    my $query  = $sow->{'query'};
    my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

    require "$cfg->{'DIR_HTML'}/html.pl";

    $sow->{'html'} = SWHtml->new($sow);                      # HTMLモードの初期化
    my $net = $sow->{'html'}->{'net'};                       # Null End Tag
    $sow->{'http'}->outheader();                             # HTTPヘッダの出力
    $sow->{'html'}->outheader("ユーザー情報編集($sow->{'uid'})");    # HTMLヘッダの出力
    $sow->{'html'}->outcontentheader('');

    &SWHtmlPC::OutHTMLLogin($sow);                           # ログイン欄の出力

    my $user = SWUser->new($sow);
    $user->{'uid'} = $sow->{'uid'};
    $user->openuser(1);
    $user->closeuser();

    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'cmd'} = 'editprof';
    my $hidden = &SWBase::GetHiddenValues( $sow, $reqvals, '    ' );

    my $url = 'http://';
    $url = $user->{'url'} if ( $user->{'url'} ne '' );

    my $intro = $user->{'introduction'};
    $intro =~ s/<br( \/)?>/\n/ig;

    my $parma_0selected = '';
    $parma_0selected = ' selected' if ( $user->{'parmalink'} != 1 );
    my $parma_1selected = '';
    $parma_1selected = ' selected' if ( $user->{'parmalink'} == 1 );

    my $guestform_0selected = '';
    $guestform_0selected = ' selected' if ( $user->{'guestform'} != 1 );
    my $guestform_1selected = '';
    $guestform_1selected = ' selected' if ( $user->{'guestform'} == 1 );

    print <<"_HTML_";
<form action="$urlsow" method="$cfg->{'METHOD_FORM'}">
<div class="form_vmake">
  <fieldset>
    <legend>ユーザー情報編集 ($sow->{'uid'})</legend>
    <label for="handlename" class="multicolumn_label" >ハンドル名：</label>
    <input id="handlename" class="multicolumn_left" type="text" name="handlename" value="$user->{'handlename'}" size="30"$net>
    <br class="multicolumn_clear"$net>

    <label for="url" class="multicolumn_label" >URL：</label>
    <input id="url" class="multicolumn_left" type="text" name="url" value="$url" size="30"$net>
    <br class="multicolumn_clear"$net>

    <label for="intro" class="multicolumn_label">自己紹介：</label>
    <textarea id="intro" class="multicolumn_left" name="intro" cols="30" rows="3">$intro</textarea>
    <br class="multicolumn_clear"$net>

    <label for="parmalink" class="multicolumn_label" >固定リンク：</label>
    <select id="parmalink" name="parmalink" class="multicolumn_label">
      <option value="0"$parma_0selected>非表\示</option>
      <option value="1"$parma_1selected>表\示</option>
    </select>
      <br class="multicolumn_clear"$net>

    <label for="guestform" class="multicolumn_label" >入村後の傍観者発言フォーム：</label>
    <select id="guestform" name="guestform" class="multicolumn_label">
      <option value="0"$guestform_0selected>非表\示</option>
      <option value="1"$guestform_1selected>表\示</option>
    </select>
      <br class="multicolumn_clear"$net>

  </fieldset>

  <div class="exevmake">$hidden
    <input type="submit" value="変更" data-submit-type="editprof"$net>
  </div>
</div>
</form>

<p class="paragraph">
※タグは使用できません。
</p>
_HTML_

    &SWHtmlPC::OutHTMLReturnPC($sow);    # トップページへ戻る

    $sow->{'html'}->outcontentfooter('');
    $sow->{'html'}->outfooter();         # HTMLフッタの出力
    $sow->{'http'}->outfooter();

    return;
}

1;
