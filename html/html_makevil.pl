package SWHtmlMakeVil;

#----------------------------------------
# 村作成完了画面のHTML出力
#----------------------------------------
sub OutHTMLMakeVil {
    my ( $sow, $vil ) = @_;
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};

    my $vmode    = '作成';
    my $infotext = 'を作成';
    if ( $sow->{'query'}->{'cmd'} eq 'editvil' ) {
        $vmode    = '編集';
        $infotext = 'の設定を変更';
    }

    $sow->{'html'} = SWHtml->new($sow);    # HTMLモードの初期化
    my $net = $sow->{'html'}->{'net'};            # Null End Tag
    $sow->{'http'}->outheader();                  # HTTPヘッダの出力
    $sow->{'html'}->outheader("$vmode完了");    # HTMLヘッダの出力
    $sow->{'html'}->outcontentheader();

    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'vid'} = $query->{'vid'};
    my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
    my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

    &SWHtmlPC::OutHTMLLogin($sow);                # ログインボタン表示

    print <<"_HTML_";
<h2>$vmode完了</h2>

<p class="info"><a href="$urlsow?$linkvalue">$query->{'vid'} $query->{'vname'}</a>$infotextしました。</p>

_HTML_

    &SWHtmlPC::OutHTMLReturnPC($sow);             # トップページへ戻る

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();                  # HTMLフッタの出力
    $sow->{'http'}->outfooter();

    return;
}

1;
