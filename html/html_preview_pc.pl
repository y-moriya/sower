package SWHtmlPreviewPC;

#----------------------------------------
# 発言プレビューHTMLの表示
#----------------------------------------
sub OutHTMLPreviewPC {
    my ( $sow, $vil, $log, $preview ) = @_;
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};
    my $curpl = &SWBase::GetCurrentPl( $sow, $vil );

    require "$sow->{'cfg'}->{'DIR_HTML'}/html_vlogsingle_pc.pl";

    # はみ出す文字の処理
    my $srcmes = $log->{'log'};    # 削除前の発言
    $srcmes =~ s/(<br( \/)?>)*$//ig;

    # 発言制限するかどうか
    my $isrestrict =
         ( $log->{'mestype'} ne $sow->{'MESTYPE_ADMIN'} )
      && ( $log->{'mestype'} ne $sow->{'MESTYPE_GUEST'} )
      && ( $log->{'mestype'} ne $sow->{'MESTYPE_MAKER'} )
      && ( $log->{'mestype'} ne $sow->{'MESTYPE_TSAY'} )
      && ( $log->{'mestype'} ne $sow->{'MESTYPE_GSAY'} );

    my $trimedlog = $srcmes;

    if ($isrestrict) {
        $trimedlog = &SWString::GetTrimString( $sow, $vil, $srcmes );
    }
    my $len = length($trimedlog);
    $log->{'log'} = substr( $srcmes, 0, $len );
    my $deletedmes = substr( $srcmes, $len );
    $log->{'log'} .= "<span class=\"infotext\">$deletedmes</span>"
      if ( $deletedmes ne '' );

    $sow->{'html'} = SWHtml->new($sow);           # HTMLモードの初期化
    my $net     = $sow->{'html'}->{'net'};        # Null End Tag
    my $outhttp = $sow->{'http'}->outheader();    # HTTPヘッダの出力
    return if ( $outhttp == 0 );                  # ヘッダ出力のみ
    $sow->{'html'}->outheader('発言のプレビュー');        # HTMLヘッダの出力
    $sow->{'html'}->outcontentheader();

    &SWHtmlPC::OutHTMLLogin($sow);                # ログイン欄の出力

    my $titleupdate = &SWHtmlPC::GetTitleNextUpdate( $sow, $vil );
    print <<"_HTML_";
<h2>$query->{'vid'} $vil->{'vname'}$titleupdate</h2>

<h3>発言のプレビュー</h3>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
_HTML_

    # 誤爆注意
    if (   ( &SWBase::CheckWriteSafetyRole( $sow, $vil ) > 0 )
        && ( $log->{'mestype'} == $sow->{'MESTYPE_SAY'} )
        && ( $vil->isepilogue() == 0 ) )
    {
        print <<"_HTML_";
<div class="previewsafety">
  <p class="cautiontext"><strong>この発言は通常発言です。発言ミスに注意！</strong></p>
  <label><input type="checkbox" name="safety" value="on"$net>通常発言で間違いなければチェック</label>
</div>

_HTML_
    }

    # 発言部分の表示
    my %logfile = ();
    my %logidx  = ();
    my %anchor  = (
        logfile => \%logfile,
        logidx  => \%logidx,
        rowover => 1,
    );
    $log->{'log'} = &SWLog::ReplacePreviewAnchor( $sow, $vil, $log );
    &SWHtmlVlogSinglePC::OutHTMLSingleLogPC( $sow, $vil, $log, -1, 0, \%anchor, 1 );

    # 属性値生成
    $query->{'mes'} =~ s/<br( \/)?>/&#13\;/ig;
    my @reqkeys = (
        'csid_cid', 'role',      'mes',        'think', 'wolf', 'maker', 'admin', 'sympathy',
        'werebat',  'monospace', 'expression', 'guest', 'loud', 'love'
    );
    push( @reqkeys, 'entrypwd' ) if ( $vil->{'entrylimit'} eq 'password' );
    my $reqvals = &SWBase::GetRequestValues( $sow, \@reqkeys );
    my $hidden  = &SWBase::GetHiddenValues( $sow, $reqvals, '  ' );

    # 行数の取得
    my @lineslog      = split( '<br>', $srcmes );
    my $lineslogcount = @lineslog;

    # 文字数の取得
    my $countsrc = &SWString::GetCountStr( $sow, $vil, $srcmes );
    my $countmes = &SWString::GetCountStr( $sow, $vil, $trimedlog );

    # 行数／文字数制限警告
    my $saycnt = $cfg->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} };
    if ( !$isrestrict ) {

        # 制限なしの発言種別の場合は何もしない
    }
    elsif ( $lineslogcount > $saycnt->{'MAX_MESLINE'} ) {
        print "<p class=\"cautiontext\">行数が多すぎます（$lineslogcount行）。$saycnt->{'MAX_MESLINE'}行以内に収めないと正しく書き込まれません。</p>\n";
    }
    elsif ( $countsrc > $saycnt->{'MAX_MESCNT'} ) {
        my $unitcaution =
          $sow->{'basictrs'}->{'SAYTEXT'}->{ $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} }->{'COUNT_TYPE'} }
          ->{'UNIT_CAUTION'};
        print
          "<p class=\"cautiontext\">文字が多すぎます（$countsrc$unitcaution）。$countmes$unitcaution以内に収めないと正しく書き込まれません。</p>\n";
    }

    # 発言によって消費されるpt数の表示
    my $point = &SWBase::GetSayPoint( $sow, $vil, $trimedlog );
    my ( $mestype, $saytype ) = &SWWrite::GetMesType( $sow, $vil, $curpl );
    my $unitsay =
      $sow->{'basictrs'}->{'SAYTEXT'}->{ $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} }->{'COUNT_TYPE'} }
      ->{'UNIT_SAY'};
    my $pointtext = '';
    if (   ( $saycnt->{'COUNT_TYPE'} ne 'count' )
        && ( $sow->{'query'}->{'cmd'} ne 'entrypr' )
        && ( defined( $sow->{'curpl'}->{$saytype} ) ) )
    {
        $pointtext = "（$point$unitsay消費 / 現在$sow->{'curpl'}->{$saytype}$unitsay）";
    }

    # 発言ボタンの表示
    print <<"_HTML_";
<p class="paragraph">これを書き込みますか？$pointtext</p>

<p class="multicolumn_label">
  <input type="hidden" name="cmd" value="$preview->{'cmd'}"$net>
  <input type="hidden" name="cmdfrom" value="$query->{'cmd'}"$net>$hidden
  <input type="submit" value="書き込む" data-submit-type="write"$net>
</p>
</form>
_HTML_

    if (   ( $preview->{'cmd'} ne 'entry' )
        && ( $query->{'admin'} eq '' )
        && ( $query->{'maker'} eq '' )
        && ( $query->{'guest'} eq '' ) )
    {
        print <<"_HTML_";

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="multicolumn_left">
  <input type="hidden" name="cmd" value="editmes"$net>$hidden
  <input type="submit" value="修正する" data-submit-type="edit"$net>
</p>
</form>
_HTML_
    }

    print <<"_HTML_";
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

1;
