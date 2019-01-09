package SWHtmlMakeVilPreview;

#----------------------------------------
# 村作成プレビューHTMLの表示
#----------------------------------------
sub OutHTMLMakeVilPreview {
	my ($sow, $vil, $log, $preview) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $curpl = &SWBase::GetCurrentPl($sow, $vil);

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader('村作成のプレビュー'); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力

	my $titleupdate = &SWHtmlPC::GetTitleNextUpdate($sow, $vil);
	print <<"_HTML_";
<h2>$query->{'vid'} $vil->{'vname'}$titleupdate</h2>

<h3>村作成のプレビュー</h3>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
_HTML_

	# 属性値生成
    # 村作成に使用する属性値をすべて取得する
	my @reqkeys = ( 'vname', 'vcomment', 'makeruid', 'roletable', 'hour',
		'minite', 'updinterval', 'vplcnt', 'entrylimit', 'entrypwd', 'rating',
		'vplcntstart', 'saycnttype', 'starttype', 'votetype', 'noselrole',
		'entrustmode', 'showall', 'noactmode', 'nocandy', 'nofreeact', 'commitstate',
		'showid', 'idrecord', 'timestamp', 'randomtarget', 'makersaymenu');
	my $reqvals = &SWBase::GetRequestValues($sow, \@reqkeys);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');

	# 作成設定部分の表示
	# TODO: リクエストをもとに情報欄のようなプレビューを組み立てる

	# 作成・修正ボタンの表示
	print <<"_HTML_";
<p class="paragraph">この設定で村を作成しますか？</p>

<p class="multicolumn_label">
  <input type="hidden" name="cmd" value="$preview->{'cmd'}"$net>
  <input type="hidden" name="cmdfrom" value="$query->{'cmd'}"$net>$hidden
  <input type="submit" value="作成"$net>
</p>
</form>
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="multicolumn_left">
  <input type="hidden" name="cmd" value="editmv"$net>$hidden
  <input type="submit" value="修正する"$net>
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
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;
