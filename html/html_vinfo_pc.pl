package SWHtmlVilInfo;

#----------------------------------------
# 村情報画面のHTML出力
#----------------------------------------
sub OutHTMLVilInfo {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $i;

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";

	# 村データの読み込み
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();
	$vil->closevil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	my $vid = $vil->{'turn'};
	$vid = $vil->{'epilogue'} if ($vid > $vil->{'epilogue'});
	my $logfile = SWBoa->new($sow, $vil, $vid, 0);
	$logfile->close();

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};
	$sow->{'http'}->outheader(); # HTTPヘッダの出力
	$sow->{'html'}->outheader("村の情報 / $sow->{'query'}->{'vid'} $vil->{'vname'}"); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'vid'} = $query->{'vid'};
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	&SWHtmlPC::OutHTMLLogin($sow); # ログインボタン表示

	# 日付別ログへのリンク
	my $list = $logfile->getlist();
	&SWHtmlPC::OutHTMLTurnNavi($sow, $vil, $logs, $list);

	my $score = '';
	$score =" (<a href=\"$urlsow?$linkvalue$amp" . "cmd=score\">人狼譜</a>)" if ($vil->{'turn'} >= $vil->{'epilogue'});
	print <<"_HTML_";
<h2>村の情報$score</h2>

_HTML_

	my $lastcnt = $vil->getinfocap('lastcnt');
	if (($vil->{'turn'} == 0) && ($lastcnt ne '')) {
		print <<"_HTML_";
<p class="caution">
$lastcnt
</p>
<hr class="invisible_hr"$net>

_HTML_
	}

	print <<"_HTML_";
<div class="paragraph">
<p class="multicolumn_label">村の名前：</p>
<p class="multicolumn_left">$vil->{'vname'}</p>
<br class="multicolumn_clear"$net>

_HTML_

	&SWHtml::ConvertNET($sow, \$vil->{'vcomment'});

	print <<"_HTML_";
<p class="multicolumn_label">村の説明：</p>
<p class="multicolumn_right">$vil->{'vcomment'}</p>
<br class="multicolumn_clear"$net>
</div>

<div class="paragraph">
_HTML_

	if ($vil->{'epilogue'} <= $vil->{'turn'}) {
		print <<"_HTML_";
<p class="multicolumn_label">作成者：</p>
<p class="multicolumn_left">$vil->{'makeruid'}</p>
<br class="multicolumn_clear"$net>
_HTML_
	}

	if ($vil->{'turn'} == 0) {
		my $vplcnt = $vil->getinfocap('vplcnt');
		print <<"_HTML_";
<p class="multicolumn_label">定員：</p>
<p class="multicolumn_left">$vplcnt</p>
<br class="multicolumn_clear"$net>
_HTML_
	} else {
		my $plcnt = $vil->getinfocap('plcnt');
		print <<"_HTML_";
<p class="multicolumn_label">人数：</p>
<p class="multicolumn_left">$plcnt</p>
<br class="multicolumn_clear"$net>
_HTML_
	}

	if (($vil->{'starttype'} eq 'wbbs') && ($vil->{'turn'} == 0)) {
		my $vplcntstart = $vil->getinfocap('vplcntstart');
		print <<"_HTML_";
<p class="multicolumn_label">最低人数：</p>
<p class="multicolumn_left">$vplcntstart</p>
<br class="multicolumn_clear"$net>
_HTML_
	}

	my $updatedt = $vil->getinfocap('updatedt');
	print <<"_HTML_";
<p class="multicolumn_label">更新時間：</p>
<p class="multicolumn_role">$updatedt</p>

_HTML_

	my $interval = $vil->getinfocap('updinterval');
	print <<"_HTML_";
<p class="multicolumn_label">更新間隔：</p>
<p class="multicolumn_left">$interval</p>
<br class="multicolumn_clear"$net>

_HTML_

	my $roletable = $vil->getinfocap('roletable');
	my $roletable2 = $vil->getinfocap('roletable2');
	print <<"_HTML_";
<p class="multicolumn_label">役職配分：</p>
<p class="multicolumn_right">
$roletable<br$net>
$roletable2
</p>
<br class="multicolumn_clear"$net>

_HTML_

	my $votetype = $vil->getinfocap('votetype');
	print <<"_HTML_";
<p class="multicolumn_label">投票方法：</p>
<p class="multicolumn_left">$votetype</p>
<br class="multicolumn_clear"$net>

_HTML_

	if ($vil->{'turn'} == 0) {
		my $scraplimit = $vil->getinfocap('scraplimit');
		print <<"_HTML_";
<p class="multicolumn_label">廃村期限：</p>
<p class="multicolumn_left">$scraplimit</p>
<br class="multicolumn_clear"$net>

_HTML_
	}

	my $csidcaptions = $vil->getinfocap('csidcaptions');

	print <<"_HTML_";
</div>

<div class="paragraph">
<p class="multicolumn_label">登場人物：</p>
<p class="multicolumn_left">$csidcaptions</p>
<br class="multicolumn_clear"$net>

_HTML_

	$saycnttype = $vil->getinfocap('saycnttype');
	$starttype = $vil->getinfocap('starttype');
	$trsid = $vil->getinfocap('trsid');

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

	if ($sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0) {
		$randomtarget = $vil->getinfocap('randomtarget');
		print <<"_HTML_";

<p class="multicolumn_label">ランダム：</p>
<p class="multicolumn_left">$randomtarget</p>
<br class="multicolumn_clear"$net>
_HTML_
	}
	my $noselrole = $vil->getinfocap('noselrole');
	print <<"_HTML_";

<p class="multicolumn_label">役職希望：</p>
<p class="multicolumn_left">$noselrole</p>
<br class="multicolumn_clear"$net>
_HTML_


	my $makersaymenu = $vil->getinfocap('makersaymenu');
	print <<"_HTML_";

<p class="multicolumn_label">村建て発言：</p>
<p class="multicolumn_left">$makersaymenu</p>
<br class="multicolumn_clear"$net>
_HTML_

	my $entrustmode = $vil->getinfocap('entrustmode');
	print <<"_HTML_";

<p class="multicolumn_label">委任：</p>
<p class="multicolumn_left">$entrustmode</p>
<br class="multicolumn_clear"$net>
_HTML_

	my $showall = $vil->getinfocap('showall');
	print <<"_HTML_";

<p class="multicolumn_label">墓下公開：</p>
<p class="multicolumn_left">$showall</p>
<br class="multicolumn_clear"$net>
_HTML_

	my $rating = $vil->getinfocap('rating');
	print <<"_HTML_";

<p class="multicolumn_label">閲覧制限：</p>
<p class="multicolumn_left">$rating</p>
<br class="multicolumn_clear"$net>
<hr>
_HTML_

	$noactmode = $vil->getinfocap('noactmode');
	print <<"_HTML_";

<p class="multicolumn_label">act/memo：</p>
<p class="multicolumn_left">$noactmode</p>
<br class="multicolumn_clear"$net>
_HTML_

	my $nocandy = $vil->getinfocap('nocandy');
	print <<"_HTML_";

<p class="multicolumn_label">促し：</p>
<p class="multicolumn_left">$nocandy</p>
<br class="multicolumn_clear"$net>
_HTML_

	my $nofreeact = $vil->getinfocap('nofreeact');
	print <<"_HTML_";

<p class="multicolumn_label">自由文act：</p>
<p class="multicolumn_left">$nofreeact</p>
<br class="multicolumn_clear"$net>
<hr>
_HTML_

#	my $commitstate = 'しない';
#	$commitstate = 'する' if ($vil->{'commitstate'} > 0);
#	print <<"_HTML_";
#
#<p class="multicolumn_label">コミット表\示：</p>
#<p class="multicolumn_left">フィルタに個別表\示$commitstate</p>
#<br class="multicolumn_clear"$net>
#_HTML_

#	my $idrecord = 'なし';
#	$idrecord = 'あり' if ($vil->{'idrecord'} > 0);
#	print <<"_HTML_";
#
#<p class="multicolumn_label">ID記録：</p>
#<p class="multicolumn_left">$idrecord</p>
#<br class="multicolumn_clear"$net>
#_HTML_

	my $showid = $vil->getinfocap('showid');
	print <<"_HTML_";

<p class="multicolumn_label">ID公開：</p>
<p class="multicolumn_left">$showid</p>
<br class="multicolumn_clear"$net>
_HTML_

	my $timestamp = $vil->getinfocap('timestamp');
	print <<"_HTML_";

<p class="multicolumn_label">時刻表\示：</p>
<p class="multicolumn_left">$timestamp</p>
<br class="multicolumn_clear"$net>
_HTML_

	print "</div>\n\n";

	if (($cfg->{'ENABLED_QR'} > 0) && ($sow->{'user'}->logined() > 0)) {
		my $reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'cmd'}   = '';
		$reqvals->{'uid'}   = $sow->{'uid'};
		$reqvals->{'pwd'}   = $sow->{'cookie'}->{'pwd'}; # 暫定
		$reqvals->{'order'} = 'd'; # 暫定
		$reqvals->{'row'}   = 10; # 暫定
		my $backupamp = $sow->{'html'}->{'amp'};
		$sow->{'html'}->{'amp'} = '&';
		my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
		$sow->{'html'}->{'amp'} = $backupamp;
		my $urlsow = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}";
		my $url = &SWBase::EncodeURL("$urlsow?$linkvalue");
		my $imgurl = "$cfg->{'URL_QR'}?s=3$amp" . "d=$url";
		print <<"_HTML_";
<div class="paragraph">
<p class="multicolumn_label">QRコード：</p>
<p class="multicolumn_left">
<img src="$imgurl" alt="QRコード画像"$net><br$net>
</p>
<br class="multicolumn_clear"$net>
</div>

_HTML_
	}

	if (($vil->{'turn'} > 0) && ($vil->isepilogue() == 0)) {
		# コミット状況
		my $textrs = $sow->{'textrs'};
		my $totalcommit = &SWBase::GetTotalCommitID($sow, $vil);
		my $nextcommitdt = '';
		if ($totalcommit == 3) {
			$nextcommitdt = $sow->{'dt'}->cvtdt($vil->{'nextcommitdt'});
			$nextcommitdt = '（' . $nextcommitdt . '更新予定）';
		}
		print <<"_HTML_";
<div class="paragraph">
<p class="multicolumn_label">コミット状況：</p>
<p class="multicolumn_left">
$textrs->{'ANNOUNCE_TOTALCOMMIT'}->[$totalcommit]<br$net>
$nextcommitdt
</p>
<br class="multicolumn_clear"$net>
</div>

_HTML_
	}

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;