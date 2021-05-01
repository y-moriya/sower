package SWHtmlStopID;

#----------------------------------------
# ID停止中のHTML出力
#----------------------------------------
sub OutHTMLStopID {
    my ( $sow, $noregist ) = @_;
    my $cfg = $sow->{'cfg'};
    require "$cfg->{'DIR_HTML'}/html.pl";

    undef( $sow->{'query'}->{'vid'} );

    # HTTP/HTMLの出力
    $sow->{'html'} = SWHtml->new($sow);           # HTMLモードの初期化
    $sow->{'http'}->outheader();                  # HTTPヘッダの出力
    $sow->{'html'}->outheader('あなたのIDは停止中です');    # HTMLヘッダの出力
    $sow->{'html'}->outcontentheader();

    &SWHtmlPC::OutHTMLLogin($sow);                # ログイン欄の出力
    my $net = $sow->{'html'}->{'net'};            # Null End Tag

    my $penaltydt =
      int( ( $sow->{'user'}->{'penaltydt'} - $sow->{'time'} ) / 60 / 60 / 24 +
          0.5 );

    print <<"_HTML_";
<h2>あなたのIDは停止中です</h2>

<p class="paragraph">
あなたのIDはなんらかのペナルティにより停止されています。ID停止が解けるのは約$penaltydt日後です。<br$net>
ID停止中はログイン・ログアウトを除く<strong class="cautiontext">ほぼあらゆる行動ができなくなります</strong>。
</p>
<hr class="invisible_hr"$net>

_HTML_

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();    # HTMLフッタの出力
    $sow->{'http'}->outfooter();

    return;
}

1;
