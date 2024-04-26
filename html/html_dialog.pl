package SWHtmlDialog;

#----------------------------------------
# 確認画面のHTML出力
#----------------------------------------
sub OutHTMLDialog {
    my $sow   = $_[0];
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};

    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";

    # 村データの読み込み
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();
    $vil->closevil();

    # リソースの読み込み
    &SWBase::LoadVilRS( $sow, $vil );

    my %dialog = ( cmd => 'none', );
    if ( $query->{'cmd'} eq 'exitpr' ) {
        %dialog = (
            cmd           => 'exit',
            text          => '村から出ますか？',
            buttoncaption => '村から出る',
        );
    }
    elsif ( $query->{'cmd'} eq 'selrolepr' ) {
        %dialog = (
            cmd           => 'selrole',
            text          => '希望役職を変更しますか？',
            buttoncaption => '変更',
        );
    }
    elsif ( $query->{'cmd'} eq 'startpr' ) {
        %dialog = (
            cmd           => 'start',
            text          => '村を開始しますか？',
            buttoncaption => '開始',
        );
    }
    elsif ( $query->{'cmd'} eq 'updatepr' ) {
        %dialog = (
            cmd           => 'update',
            text          => '村を更新しますか？',
            buttoncaption => '更新',
        );
    }
    elsif ( $query->{'cmd'} eq 'scrapvilpr' ) {
        %dialog = (
            cmd           => 'scrapvil',
            text          => '廃村しますか？',
            buttoncaption => '廃村',
        );
    }
    elsif ( $query->{'cmd'} eq 'extendpr' ) {
        %dialog = (
            cmd           => 'extend',
            text          => "廃村を$query->{'extenddate'}日延長しますか？",
            buttoncaption => '延長',
        );
    }
    elsif ( $query->{'cmd'} eq 'chatmodepr' ) {
        %dialog = (
            cmd           => 'chatmode',
            text          => '雑談村を有効化しますか？',
            buttoncaption => '変更',
        );
    }

    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "未定義の行動です。", "invalid cmd." )
      if ( $dialog{'cmd'} eq 'none' );

    require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
    $sow->{'html'} = SWHtml->new($sow);    # HTMLモードの初期化
    $sow->{'http'}->outheader();           # HTTPヘッダの出力
    $sow->{'html'}->outheader('村の情報');     # HTMLヘッダの出力
    $sow->{'html'}->outcontentheader();
    my $net = $sow->{'html'}->{'net'};     # Null End Tag

    # ログインボタン表示
    &SWHtmlPC::OutHTMLLogin($sow);

    # 日付別ログへのリンク
    &SWHtmlPC::OutHTMLTurnNavi( $sow, $vil );

    my @reqkeys = ( 'csid_cid', 'role', 'mes', 'think', 'wolf', 'maker', 'admin', 'extenddate' );
    my $reqvals = &SWBase::GetRequestValues( $sow, \@reqkeys );
    my $hidden  = &SWBase::GetHiddenValues( $sow, $reqvals, '' );

    print <<"_HTML_";
<h2>行動確認</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$dialog{'text'}</p>

<p class="paragraph">
  <input type="hidden" name="cmd" value="$dialog{'cmd'}"$net>$hidden
  <input type="submit" value="$dialog{'buttoncaption'}" data-submit-type="$query->{'cmd'}"$net>
</p>
</form>
_HTML_

    &SWHtmlPC::OutHTMLReturnPC($sow);    # トップページへ戻る

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();         # HTMLフッタの出力
    $sow->{'http'}->outfooter();

    return;
}

1;
