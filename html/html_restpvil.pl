package SWHtmlRestPlayingVil;

#----------------------------------------
# 参加中の村一覧クリア画面のHTML出力
#----------------------------------------
sub OutHTMLRestPlayingVil {
    my $sow   = shift;
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};
    my $net   = $sow->{'html'}->{'net'};    # Null End Tag

    &SWHtmlPC::OutHTMLLogin($sow);          # ログイン欄の出力

    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'cmd'} = 'restpvil';
    my $hidden = &SWBase::GetHiddenValues( $sow, $reqvals, '  ' );

    if ( $query->{'cmd'} eq 'restpvil' ) {
        print "<p class=\"info\">\n参加中の村一覧をクリアしました。\n</p>\n\n";
    }

    print <<"_HTML_";
<h2>参加中の村一覧のクリア</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$hidden
  <input type="submit" value="クリア" data-submit-type="restpvil"$net>
</p>
</form>
<hr class="invisible_hr"$net>

<p class="paragraph">
なんらかの理由で参加中の村一覧が破損した場合に全部削除する事ができます。
</p>

<p class="paragraph">
クリアするだけで、現在参加中の村については再取得を行わないため、消えてしまいます（再度入り直せば出る）。データ構\造が変化したり、ゴミが残った場合に使用してください。
</p>

<p class="paragraph">
多数のユーザーが存在する時に村一覧のクリアを行うと<strong class="cautiontext">それなりに負荷がかかります</strong>ので、注意して下さい。
</p>
<hr class="invisible_hr"$net>

_HTML_

    &SWHtmlPC::OutHTMLReturnPC($sow);    # トップページへ戻る

    return;
}

1;
