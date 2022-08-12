package SWHtmlChangePwd;

#----------------------------------------
# 村作成完了画面のHTML出力
#----------------------------------------
sub OutHTMLChangePwd {
    my $sow   = $_[0];
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};

    $sow->{'html'} = SWHtml->new($sow);    # HTMLモードの初期化
    my $net = $sow->{'html'}->{'net'};     # Null End Tag
    $sow->{'http'}->outheader();                  # HTTPヘッダの出力
    $sow->{'html'}->outheader("$vmode完了");    # HTMLヘッダの出力
    $sow->{'html'}->outcontentheader();

    &SWHtmlPC::OutHTMLLogin($sow);                # ログインボタン表示

    print <<"_HTML_";
<h2>パスワード変更完了</h2>

<p class="info">パスワードを変更しました。</p>

_HTML_

    &SWHtmlPC::OutHTMLReturnPC($sow);             # トップページへ戻る

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();                  # HTMLフッタの出力
    $sow->{'http'}->outfooter();

    return;
}

1;
