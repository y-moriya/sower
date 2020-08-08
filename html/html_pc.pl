package SWHtmlPC;

#----------------------------------------
# PCモード用のHTML出力
#----------------------------------------

#----------------------------------------
# HTMLヘッダの出力
#----------------------------------------
sub OutHTMLHeaderPC {
	my ($sow, $title_r) = @_;
	my $net = $sow->{'html'}->{'net'};
	my $cfg = $sow->{'cfg'};
	$title = $title_r . ' - ' if ($title_r ne '');

	print "<head>\n";

	# Content-Type / Content-Style-Type の出力
	# 通常はHTTPに出力するので不要
	if ($sow->{'cfg'}->{'OUTPUT_HTTP_EQUIV'} > 0) {
		print "  <meta http-equiv=\"Content-Type\" content=\"text/html; charset=Shift_JIS\"$net>\n" if ($sow->{'http'}->{'contenttype'} eq 'html');
		print "  <meta http-equiv=\"Content-Style-Type\" content=\"$sow->{'http'}->{'styletype'}\"$net>\n" if ($sow->{'http'}->{'styletype'} ne '');
		print "  <meta http-equiv=\"Content-Script-Type\" content=\"$sow->{'http'}->{'scripttype'}\"$net>\n" if ($sow->{'http'}->{'scripttype'} ne '');
	}

	my $robots = $sow->{'cfg'}->{'ROBOTS'};
	foreach (@$robots) {
		print "  <meta name=\"robots\" content=\"$_\"$net>\n";
	}

	print <<"_HTML_";
  <meta name="Author" content="$sow->{'NAME_AUTHOR'}"$net>
  <meta name="viewport" content="width=device-width,user-scalable=yes">
  <link rel="shortcut icon" href="$cfg->{'BASEDIR_DOC'}/$cfg->{'FILE_FAVICON'}"$net>
_HTML_

	# スタイルシートの出力
	my $css = $sow->{'cfg'}->{'CSS'};
	my @csskey = keys(%$css);
	my $alternate = '';
	my $cssid = 'default';
	$cssid = $sow->{'query'}->{'css'} if ($sow->{'query'}->{'css'} ne '');
	$cssid = 'default' if (!defined($css->{$cssid}));
	foreach (@csskey) {
		next if ($_ ne $cssid); # alternateは取りあえず停止中
		$alternate = 'alternate ';
		$alternate = '' if ($_ eq $cssid);
		print "  <link rel=\"" . $alternate . "stylesheet\" type=\"text/css\" href=\"$cfg->{'BASEDIR_DOC'}/$css->{$_}->{'FILE'}\" title=\"$css->{$_}->{'TITLE'}\"$net>\n";
	}

	# RSSの出力
	if (($sow->{'html'}->{'rss'} ne '') && ($cfg->{'ENABLED_RSS'} > 0)) {
		print "  <link rel=\"Alternate\" type=\"application/rss+xml\" title=\"RSS\" href=\"$sow->{'html'}->{'rss'}\"$net>\n";
	}

	# ナビゲーションの出力
	print <<"_HTML_";
  <link rev="Made" href="mailto:$sow->{'MAIL_AUTHOR'}"$net>
  <link rel="Start" href="$cfg->{'URL_HOME'}" title="$cfg->{'NAME_HOME'}"$net>
_HTML_

	# link要素の出力
	foreach (@{$sow->{'html'}->{'links'}}) {
		print "  <link rel=\"$_->{'rel'}\" href=\"$_->{'url'}\" title=\"$_->{'title'}\"$net>\n";
	}

	# JavaScriptの出力
	if (defined($sow->{'html'}->{'file_js'})) {
		my $file_js = $sow->{'html'}->{'file_js'};
		foreach (@$file_js) {
			print "  <script type=\"text/javascript\" src=\"$cfg->{'BASEDIR_DOC'}/$_\"></script>\n";
		}
	}

	# タイトルの出力
	print <<"_HTML_";
  <title>$title$cfg->{'NAME_SW'}</title>
</head>

_HTML_

	# body要素開始タグの出力
	print "<body";
	my $bodyjs = $sow->{'html'}->{'bodyjs'};
	my @bodyjskeys = keys(%$bodyjs);
	foreach (@bodyjskeys) {
		#print " $_=\"$bodyjs->{$_}\"";
	}
	print ">\n";

	# 外枠
	my $classoutframe = 'outframe';
	if (($sow->{'query'}->{'cmd'} eq '') && (defined($sow->{'query'}->{'vid'})) && ($sow->{'query'}->{'logid'} eq '') && ($sow->{'filter'}->{'layoutfilter'} eq '1')) {
		$classoutframe = 'outframe_navimode';
	}
	if ($title_r eq $cfg->{'NAME_TOP'}) {
		$classoutframe = 'outframetop';
	}
	print <<"_HTML_";

<div id="outframe" class="$classoutframe">
_HTML_

}

#----------------------------------------
# 本コンテンツ部（非発言フィルタ）ヘッダの表示
#----------------------------------------
sub OutHTMLContentFrameHeader {
	my $sow = shift;
	my $net    = $sow->{'html'}->{'net'};
	my $cfg    = $sow->{'cfg'};
	my $query  = $sow->{'query'};
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	my $classcontentframe = 'contentframe';
	if (($sow->{'query'}->{'cmd'} eq '') && (defined($sow->{'query'}->{'vid'})) && ($sow->{'query'}->{'logid'} eq '') && ($sow->{'filter'}->{'layoutfilter'} eq '1')) {
		$classcontentframe = 'contentframe_navileft';
	}
	if (($sow->{'query'}->{'cmd'} eq '') && ($sow->{'query'}->{'vid'} eq '') && ($sow->{'query'}->{'logid'} eq '') && ($sow->{'query'}->{'prof'} eq '')) {
		$classcontentframe = 'contentframetop';
	}

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'vid'} = '';
	$reqvals->{'turn'} = '';
	my $link = &SWBase::GetLinkValues($sow, $reqvals);

	my $titlestart = "<a href=\"$urlsow?$link\">";
	my $titleend = '</a>';
	if (($query->{'cmd'} eq 'entrypr') || ($query->{'cmd'} eq 'writepr')) {
		$titlestart = '';
		$titleend = '';
	}

	my $cssid = 'default';
	$cssid = $sow->{'query'}->{'css'} if ($sow->{'query'}->{'css'} ne '');
	$cssid = 'default' if (!defined($cfg->{'CSS'}->{$cssid}));
	my $css = $cfg->{'CSS'}->{$cssid};
	my %topbanner = (
		file   => $cfg->{'FILE_TOPBANNER'},
		width  => $cfg->{'TOPBANNER_WIDTH'},
		height => $cfg->{'TOPBANNER_HEIGHT'},
	);
	$topbanner{'file'}   = $css->{'FILE_TOPBANNER'} if (defined($css->{'FILE_TOPBANNER'}));
	$topbanner{'width'}  = $css->{'WIDTH_TOPBANNER'} if (defined($css->{'WIDTH_TOPBANNER'}));
	$topbanner{'height'} = $css->{'HEIGHT_TOPBANNER'} if (defined($css->{'HEIGHT_TOPBANNER'}));

	print <<"_HTML_";
<div id="contentframe" class="$classcontentframe">

<h1>$titlestart<img src="$cfg->{'DIR_IMG'}/$topbanner{'file'}" width="$topbanner{'width'}" height="$topbanner{'height'}" alt="$cfg->{'NAME_SW'}"$net>$titleend</h1>

<div class="inframe">

_HTML_

}

#----------------------------------------
# 本コンテンツ部（非発言フィルタ）フッタの表示
#----------------------------------------
sub OutHTMLContentFrameFooter {
	my $sow = $_[0];

	print <<"_HTML_";
</div><!-- inframe footer -->
</div><!-- contentframe footer -->

_HTML_

}

#----------------------------------------
# HTMLフッタの出力
#----------------------------------------
sub OutHTMLFooterPC {
	my $sow = $_[0];
	my $cput = int($_[1] * 1000) / 1000;

	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

	print <<"_HTML_";
<div class="inframe">
<p id="popupmsg"></p>
<p class="popup"></p>
<address>
($cput CPUs)<br$net>
$sow->{'VERSION_SW'} <a href="$sow->{'URL_AUTHOR'}">$sow->{'COPY_AUTHOR'}</a><br$net>
forked from SWBBS V2.00 Beta8 <a href="http://asbntby.sakura.ne.jp/">あず/asbntby</a><br$net>
_HTML_

	my $copyrights = $sow->{'cfg'}->{'COPYRIGHTS'};
	foreach (@$copyrights) {
		print "$_<br$net>\n";
	}

	print <<"_HTML_";
</address>
</div>

</div>
</body>
</html>
_HTML_
}

#----------------------------------------
# ログイン欄HTML出力
#----------------------------------------
sub OutHTMLLogin {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	my $net   = $sow->{'html'}->{'net'};

	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');
	if ($sow->{'user'}->logined() <= 0) {
		# 未ログイン
		my $disabled = '';
		$disabled = " $sow->{'html'}->{'disabled'}" if (($query->{'prof'} ne '') || ($query->{'cmd'} eq 'editprofform') || ($query->{'cmd'} eq 'editprof'));
		if ($cfg->{'ENABLED_TYPEKEY'} <= 0) {
			# 通常のログインフォーム
			print <<"_HTML_";
<form action="$urlsow" method="$sow->{'cfg'}->{'METHOD_FORM'}" class="login">
<p>
  <input type="hidden" name="cmd" value="login"$net>
  <input type="hidden" name="cmdfrom" value="$query->{'cmd'}"$net>$hidden
  <label>user id: <input type="text" size="10" name="uid" value="$sow->{'uid'}"$net></label>
  <label>password: <input type="password" size="10" name="pwd" value=""$net></label>
  <input type="submit" value="ログイン"$disabled$net>
</p>
</form>
<hr class="invisible_hr"$net>

_HTML_
		} else {
			# TypeKeyログインフォーム
			$reqvals->{'cmd'} = 'login';
			my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
			print <<"_HTML_";
<form action="https://www.typekey.com/t/typekey/login" method="$sow->{'cfg'}->{'METHOD_FORM'}" class="login">
<p>
  <input type="hidden" name="t" value="$sow->{'cfg'}->{'TOKEN_TYPEKEY'}"$net>
  <input type="hidden" name="need_email" value="0"$net>
  <input type="hidden" name="_return" value="$sow->{'cfg'}->{'URL_SW'}/$sow->{'cfg'}->{'FILE_SOW'}?$linkvalue"$net>
  <input type="hidden" name="v" value="1.1"$net>
  <input type="submit" value="ログイン"$disabled$net>
  (<a href="http://www.sixapart.jp/typekey/">TypeKey</a>)
</p>
</form>
<hr class="invisible_hr"$net>

_HTML_
		}
	} else {
		# ログイン済み
		my $uidtext = $sow->{'uid'};
		$uidtext =~ s/ /&nbsp\;/g;
		$reqvals->{'prof'} = $sow->{'uid'};
		my $link = &SWBase::GetLinkValues($sow, $reqvals);
		$uidtext = "<a href=\"$urlsow?$link\">$uidtext</a>";

		my $disabled = '';
		$disabled = " $sow->{'html'}->{'disabled'}" if (($query->{'cmd'} eq 'entrypr') || ($query->{'cmd'} eq 'writepr') || ($query->{'prof'} ne '') || ($query->{'cmd'} eq 'editprofform') || ($query->{'cmd'} eq 'editprof'));

		$reqvals->{'prof'} = '';
		$reqvals->{'cmd'} = 'admin';
		$link = &SWBase::GetLinkValues($sow, $reqvals);
		my $linkadmin = '';
		$linkadmin = "\n  [<a href=\"$urlsow?$link\">管理画面</a>] / " if ($sow->{'uid'} eq $cfg->{'USERID_ADMIN'});

		if ($sow->{'cfg'}->{'ENABLED_TYPEKEY'} <= 0) {
			# 通常のログアウトフォーム
			print <<"_HTML_";
<form action="$urlsow" method="$sow->{'cfg'}->{'METHOD_FORM'}" class="login">
<p>
  <input type="hidden" name="cmd" value="logout"$net>
  <input type="hidden" name="cmdfrom" value="$query->{'cmd'}"$net>$hidden$linkadmin
  user id: $uidtext
  <input type="submit" value="ログアウト"$disabled$net>
</p>
</form>
<hr class="invisible_hr"$net>

_HTML_
		} else {
			# TypeKeyログアウトフォーム
			$reqvals->{'cmd'} = 'logout';
			my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
			print <<"_HTML_";
<form action="https://www.typekey.com/t/typekey/logout" method="$sow->{'cfg'}->{'METHOD_FORM'}" class="login">
<p>
  <input type="hidden" name="_return" value="$sow->{'cfg'}->{'URL_SW'}/$sow->{'cfg'}->{'FILE_SOW'}?$linkvalue"$net>$linkadmin
  user id: $uidtext
  <input type="submit" value="ログアウト"$disabled$net>
  (<a href="http://www.sixapart.jp/typekey/">TypeKey</a>)
</p>
</form>
<hr class="invisible_hr"$net>

_HTML_
		}
	}
}

#----------------------------------------
# 「トップページに戻る」HTML出力
#----------------------------------------
sub OutHTMLReturnPC {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = '';
	$reqvals->{'vid'} = '';
	$reqvals->{'turn'} = '';
	$reqvals->{'mode'} = ''; # 応急処置
	my $link = &SWBase::GetLinkValues($sow, $reqvals);

	print <<"_HTML_";
<p class="return">
<a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link">トップページに戻る</a>
</p>
<hr class="invisible_hr"$net>

_HTML_
}

#----------------------------------------
# キャラ画像アドレスの取得
#----------------------------------------
sub GetImgUrl {
	my ($sow, $vil, $imgpl, $imgparts, $expression, $mestype) = @_;

	my $charset = $sow->{'charsets'}->{'csid'}->{$imgpl->{'csid'}};

	$imgparts = '' if ($charset->{'BODY'} eq '');
	my $imgid = $imgpl->{'cid'};

	if (@{$charset->{'EXPRESSION'}} == 0) {
		$expression = '';
	} else {
		if (defined($expression)) {
			$expression = "_$expression";
		} else {
			$expression = "_0";
		}
	}

	my $imggrwl = '';
	$imggrwl = $charset->{'GRAVE'} if (isGraveImg($sow, $vil, $imgpl, $charset, $mestype) eq 1); # 墓石表示
	$imggrwl = $charset->{'WOLF'} if (($mestype eq $sow->{'MESTYPE_WSAY'}) && ($charset->{'WOLF'} ne '')); # 囁き表示
	my $img = "$charset->{'DIR'}/$imgid$imggrwl$imgparts$expression$charset->{'EXT'}";

	return $img;
}

#----------------------------------------
# キャラ画像アドレスが死者用かどうか
#----------------------------------------
sub isGraveImg {
	my ($sow, $vil, $imgpl, $charset, $mestype) = @_;

	if (!(defined $mestype)) {
		return 0;
	}

	if ($mestype eq $sow->{'MESTYPE_MAKER'} ||
		$mestype eq $sow->{'MESTYPE_ADMIN'} || 
		$mestype eq $sow->{'MESTYPE_GUEST'}) {
		return 0;
	}
	
	if ($charset->{'GRAVE'} ne '') {
		if ($sow->{'turn'} == $vil->{'epilogue'}) {
			return 0;
		}
		if (($imgpl->{'deathday'} <= $sow->{'turn'}) && ($imgpl->{'deathday'} >= 0)) {
			return 1;
		}
	}
	
	return 0;
}

#----------------------------------------
# キャラ画像部とその他部の横幅を取得
# ※スタイルシートを本格的にいじる場合は修正が必要
#----------------------------------------
sub GetFormBlockWidth {
	my ($sow, $imgwidth) = @_;

	my $css = $sow->{'cfg'}->{'CSS'};
	my $cssid = 'default';
	$cssid = $sow->{'query'}->{'css'} if ($sow->{'query'}->{'css'} ne '');

	# キャラセットごとの幅の違いに対応するためにwidthを広く取ることにした
	#$imgwidth = $imgwidth + 4 + 4 + 50;
	$imgwidth = 118;
	my $textwidth = $css->{$cssid}->{'WIDTH'} - 32 - 2 - 8 - $imgwidth - 8 - 2; # 8 を引かないと IE で何故かうまく動かない
	$imgwidth .= "px";
	$textwidth .= "px";

	return ($imgwidth, $textwidth);
}

#----------------------------------------
# 発言欄textarea要素の出力
#----------------------------------------
sub OutHTMLSayTextAreaPC {
	my ($sow, $cmd, $htmlsay) = @_;
	my $net = $sow->{'html'}->{'net'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '      ');
	my $text = '';
	$text = $htmlsay->{'text'} if (defined($htmlsay->{'text'}));

	my $disabled = '';
	$disabled = " $sow->{'html'}->{'disabled'}" if ($htmlsay->{'disabled'} > 0);
	
	print <<"_HTML_";
      <textarea name="mes" cols="30" rows="5" onkeyup="showCount(value, this);" onmouseup="showCount(value, this);">$text</textarea><br$net>
      <input type="hidden" name="cmd" value="$cmd"$net>$hidden
      <div style="float: left;">
      <input type="submit" value="$htmlsay->{'buttonlabel'}"$disabled$net>$htmlsay->{'saycnttext'}
      </div>
_HTML_

	return;
}

#----------------------------------------
# 日付アンカーHTML出力
#----------------------------------------
sub OutHTMLTurnNavi {
	my ($sow, $vil, $logs, $list, $rows, $position) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $amp   = $sow->{'html'}->{'amp'};
	my $net   = $sow->{'html'}->{'net'};

	$position = 0 if (!defined($position));

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'turn'} = '';
	$linkvalues = &SWBase::GetLinkValues($sow, $reqvals);
	my $linknew = $linkvalues;

	$reqvals->{'turn'} = $sow->{'turn'};
	$linkvalues = &SWBase::GetLinkValues($sow, $reqvals);

	my $linklog = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvalues\">ログ</a>";
	my $linkmemo = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvalues$amp" . "cmd=memo\">メモ</a>";
	my $linkmemohist = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvalues$amp" . "cmd=hist\">メモ履歴</a>";
	$linkmemo = 'メモ' if (($query->{'cmd'} eq 'memo') || ($query->{'cmd'} eq 'vinfo') || ($sow->{'turn'} > $vil->{'epilogue'}));
	$linkmemohist = 'メモ履歴' if (($query->{'cmd'} eq 'hist') || ($query->{'cmd'} eq 'vinfo') || ($sow->{'turn'} > $vil->{'epilogue'}));
	my $memolinks = '';
	$memolinks = "[$linkmemo/$linkmemohist] / " if ($vil->{'noactmode'} <= 1);
	$linklog = 'ログ' if (($query->{'cmd'} eq '') || ($query->{'cmd'} eq 'vinfo'));
	my $linkform = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linknew#newsay\">発言欄へ</a>";
	$linkform = '発言欄へ' if ($vil->{'turn'} > $vil->{'epilogue'});

	if (($position > 0) && ($sow->{'turn'} <= $vil->{'epilogue'}) && ($query->{'cmd'} ne 'vinfo')) {
		print "<p class=\"pagenavi\">\n";
		&OutHTMLPageNaviPC($sow, $vil, $logs, $list, $rows);
		print "$memolinks$linkform\n";
		print "</p>\n\n";
	}

	# 視点切り替えモードの取得
	my ($mode, $modes, $modename) = &SWHtml::GetViewMode($sow);

	my $postmode = '';
	$postmode = $amp . "mode=$mode" if ($vil->{'epilogue'} < $vil->{'turn'});

	print "<p class=\"turnnavi\">\n";
	if ($query->{'cmd'} eq 'vinfo') {
		print "情報\n";
	} else {
		print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linknew$amp" . "cmd=vinfo\">情報</a>\n";
	}

	my $cmdlog = 0;
	$cmdlog = 1 if (($query->{'cmd'} eq '') || ($query->{'cmd'} eq 'memo') || ($query->{'cmd'} eq 'hist'));
	my $i;
	for ($i = 0; $i <= $vil->{'turn'}; $i++) {
		my $postturn = "";
		$postturn = $amp . "turn=$i" if ($i != $vil->{'turn'});
		my $turnname = "$i日目";
		$turnname = "プロローグ" if ($i == 0);
		$turnname = "エピローグ" if ($i == $vil->{'epilogue'});
		$turnname = "終了" if ($i > $vil->{'epilogue'});

		if (($i == $sow->{'turn'}) && ($cmdlog > 0) && ($query->{'logid'} eq '')) {
				print "$turnname\n";
		} else {
			print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linknew$postturn$postmode\">$turnname</a>\n";
		}
	}

	print <<"_HTML_";
/ <a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linknew">最新</a>
</p>

_HTML_

	if (($position == 0) && ($sow->{'turn'} <= $vil->{'epilogue'}) && ($query->{'cmd'} ne 'vinfo')) {
		print "<p class=\"pagenavi\">\n";
		&OutHTMLPageNaviPC($sow, $vil, $logs, $list, $rows);
		print "$memolinks$linkform\n";
		print "</p>\n\n";
	}

	# 視点切り替え
	if ($vil->{'epilogue'} < $vil->{'turn'}) {
		print "<p class=\"turnnavi\">\n視点：\n";
		my $postturn = $amp . "turn=$sow->{'turn'}";
		my $i;
		for ($i = 0; $i < @$modes; $i++) {
			if ($mode eq $modes->[$i]) {
				print "$modename->[$i]\n";
			} else {
				print "<a href=\"$sow->{'cfg'}->{'FILE_SOW'}?$linkvalues$postturn$amp" . "mode=$modes->[$i]\">$modename->[$i]</a>\n";
			}
		}
	print "</p>\n\n";
	}
	return;
}

#----------------------------------------
# ページリンクHTML出力
#----------------------------------------
sub OutHTMLPageNaviPC {
	my ($sow, $vil, $logs, $list, $rows) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'};
	my $amp   = $sow->{'html'}->{'amp'};

	if (!defined($logs)) {
		my @logs;
		$logs = \@logs;
	}
	if (!defined($rows)) {
		$rows = {
			start => 0,
			end   => 0,
		};
	}


	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = '';
	my $linkvalues = &SWBase::GetLinkValues($sow, $reqvals);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvalues";

	# 可視ログのカウント
	my ($pages, $indexno) = &SWHtml::GetPagesPermit($sow, $logs, $list);

	# 行数の取得
	my $row = $cfg->{'MAX_ROW'};
	$row = $query->{'row'} if (defined($query->{'row'}));
	$row = $cfg->{'MAX_ROW'} if ($row <= 0);

	my $maxpage = int((@$pages + $row - 1) / $row); # 最大ページ
	my $maxrow = $maxpage;

	# 最初に表示するページリンク番号
	my $firstpage = 0;

	my $i;
	my $endpage = int($indexno / $row);
	$endpage = $query->{'pageno'} - 1 if (defined($query->{'pageno'}));
	$endpage = $firstpage + $maxrow - 1 if (($rows->{'end'} != 0) || (!defined($logs->[$#$logs])));
	$endpage = -1 if (($query->{'cmd'} eq 'memo') || ($query->{'cmd'} eq 'hist') || ($query->{'rowall'} ne ''));
	for ($i = $firstpage; $i < $firstpage + $maxrow; $i++) {
		my $pageno = $i + 1;
		if (($i == $endpage) || ($query->{'cmd'} eq 'vinfo')) {
			print "[$pageno]";
		} else {
			my $log = $pages->[$i * $row];
			my $logid = $log->{'logid'};
			$logid = $log->{'maskedid'} if (($vil->isepilogue() == 0) && (defined($log->{'maskedid'})) && (($log->{'mestype'} == $sow->{'MESTYPE_INFOSP'}) || ($log->{'mestype'} == $sow->{'MESTYPE_TSAY'})));
			print "[<a href=\"$urlsow$amp" . "move=page$amp" . "pageno=$pageno\">$pageno</a>]";
		}
		print "\n";
	}
}

#----------------------------------------
# タイトルの開始／更新予定時間
#----------------------------------------
sub GetTitleNextUpdate {
	my ($sow, $vil) = @_;

	my $title = '';
	 if (($vil->{'starttype'} eq 'wbbs') || ($vil->{'turn'} > 0)) {
		my $date = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});
		$title = " ($date に更新)";
	} else {
		$title = ' (' . sprintf("%02d:%02d", $vil->{'updhour'}, $vil->{'updminite'}) . '更新)';
	}

	return $title;
}

1;