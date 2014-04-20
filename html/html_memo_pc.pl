package SWHtmlMemoPC;

#----------------------------------------
# メモ表示（PCモード）のHTML出力
#----------------------------------------
sub OutHTMLMemoPC {
	my ($sow, $vil, $logfile, $memofile, $maxrow, $logs, $logkeys, $rows) = @_;

	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";

	my $net   = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp   = $sow->{'html'}->{'amp'};
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

	# ログインHTML
	$sow->{'html'}->outcontentheader();
	&SWHtmlPC::OutHTMLLogin($sow);

	# 村名
	my $date = $sow->{'dt'}->cvtdt($vil->{'nextupdatedt'});
	my $titleupdate = " ($date に更新)";

	# 見出し（村名とRSS）
	print "<h2>$query->{'vid'} $vil->{'vname'}";
	print "$titleupdate <a href=\"$link$amp". "cmd=rss\">RSS</a>" if ($vil->{'epilogue'} >= $vil->{'turn'});
	print "</h2>\n\n";

	# 日付別ログへのリンク
	my $list = $logfile->getlist();
	my @dummy;
	&SWHtmlPC::OutHTMLTurnNavi($sow, $vil, \@dummy, $list);

	# メモ表示
	my $title = '';
	$title = '履歴' if ($query->{'cmd'} eq 'hist');
	print <<"_HTML_";
<h3>メモ$title</h3>

_HTML_

	if (@$logs > 0) {
		print <<"_HTML_";
<table border="1" class="memo" summary="メモ$title">
<tbody>
_HTML_
	} else {
		print <<"_HTML_";
<p class="paragraph">
メモはありません。
</p>
_HTML_
	}

	my %logkeys;
	my %anchor = (
		logfile => $logfile,
		logkeys => \%logkeys,
		rowover => 1,
		reqvals => $reqvals,
	);

	my $order = 'desc';
	$order = 'asc' if ($query->{'cmd'} eq 'hist');
	$order = $query->{'order'} if ($query->{'order'} ne '');
	if (($order eq 'desc') || ($order eq 'd')) {
		my $i;
		for ($i = $#$logs; $i >= 0; $i--) {
			&OutHTMLMemoSinglePC($sow, $vil, $memofile, $logs->[$i], \%anchor);
		}
	} else {
		foreach (@$logs) {
			&OutHTMLMemoSinglePC($sow, $vil, $memofile, $_, \%anchor);
		}
	}

	if (@$logs > 0) {
		print <<"_HTML_";
</tbody>
</table>
_HTML_
	}

	print <<"_HTML_";
<hr class="invisible_hr" />

_HTML_

	my $writepl = &SWBase::GetCurrentPl($sow, $vil);
	if (($query->{'cmd'} eq 'memo') && ($vil->checkentried() >= 0) && ($sow->{'turn'} == $vil->{'turn'}) && ($vil->{'turn'} <= $vil->{'epilogue'})) {
		if (($writepl->{'live'} eq 'live') || ($vil->isepilogue() != 0)) {
			&OutHTMLMemoFormPC($sow, $vil, $memofile, $logs, \%anchor);
		}
	}
	# 日付別ログへのリンク
	&SWHtmlPC::OutHTMLTurnNavi($sow, $vil, \@dummy, $list) if ($query->{'cmd'} eq 'hist');

	&SWHtmlPC::OutHTMLReturnPC($sow);

	$sow->{'html'}->outcontentfooter();

	return;
}

#----------------------------------------
# メモ発言欄HTML表示（一行分）
#----------------------------------------
sub OutHTMLMemoSinglePC {
	my ($sow, $vil, $memofile, $memoidx, $anchor) = @_;

	my $memo = $memofile->read($memoidx->{'pos'});
	my $chrname = $memo->{'chrname'};
	my $curpl = $vil->getpl($memoidx->{'uid'});
	$chrname = "$chrname (村を出ました)" if ((!defined($curpl->{'entrieddt'})) || ($curpl->{'entrieddt'} > $memoidx->{'date'}));
	my $mes = $memo->{'log'};
	$mes = '（メモをはがした）' if ($memo->{'mestype'} == $sow->{'MEMOTYPE_DELETED'});
	&SWLog::ReplaceAnchorHTML($sow, $vil, \$mes, $anchor);
	&SWHtml::ConvertNET($sow, \$mes);
	my $mestext = "mes_text";
	$mestext = "mes_text_monospace" if ($memo->{'monospace'} != 0);
	my $date = $sow->{'dt'}->cvtdt($memo->{'date'});
	my $memodate = '';
	$memodate = "<div class=\"mes_date\">$date</div>\n" if ($sow->{'query'}->{'cmd'} eq 'hist');

	print <<"_HTML_";
<tr>
<th class="memoleft">$chrname</th>
<td class="memoright"><p class="$mestext">$mes</p>$memodate</td>
</tr>

_HTML_
}

#----------------------------------------
# メモ発言欄HTML表示
#----------------------------------------
sub OutHTMLMemoFormPC {
	my ($sow, $vil, $memofile, $logs, $anchor) = @_;
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp   = $sow->{'html'}->{'amp'};
	my $cfg   = $sow->{'cfg'};

	my $curpl = $sow->{'curpl'};
	my $charset = $sow->{'charsets'}->{'csid'}->{$curpl->{'csid'}};

	my $memo = $memofile->getnewmemo($curpl);
	my $mes = $memo->{'log'};
	$mes = &SWLog::ReplaceAnchorHTMLRSS($sow, $vil, $mes, $anchor);
	$mes =~ s/<br( \/)?>/&#13\;/ig;

	# キャラ画像アドレスの取得
	my $img = &SWHtmlPC::GetImgUrl($sow, $curpl, $charset->{'BODY'});

	# キャラ画像部とその他部の横幅を取得
	my ($lwidth, $rwidth) = &SWHtmlPC::GetFormBlockWidth($sow, $charset->{'IMGBODYW'});

	# キャラ画像
	print <<"_HTML_";
<div class="formpl_common">
  <div style="float: left; width: $lwidth;">
    <div class="formpl_chrimg"><img src="$img" width="$charset->{'IMGBODYW'}" height="$charset->{'IMGBODYH'}" alt=""$net></div>
  </div>

_HTML_

	# 名前とID
	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'prof'} = $sow->{'uid'};
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	my $uidtext = $sow->{'uid'};
	$uidtext =~ s/ /&nbsp\;/g;
	$uidtext = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">$uidtext</a>";
	my $chrname = $curpl->getchrname();
	print <<"_HTML_";
  <div style="float: right; width: $rwidth;">
    <div class="formpl_content">$chrname ($uidtext)</div>

_HTML_

	# テキストボックスと発言ボタン初め
	print <<"_HTML_";
    <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
    <div class="formpl_content">
_HTML_

	# 発言欄textarea要素の出力
	my $unitaction = $sow->{'basictrs'}->{'SAYTEXT'}->{$sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}}->{'COUNT_TYPE'}}->{'UNIT_ACTION'};
	my %htmlsay = (
		saycnttext  => " あと$curpl->{'say_act'}$unitaction",
		buttonlabel => 'メモを貼る',
		text        => $mes,
		disabled    => 0,
	);
	$htmlsay{'disabled'} = 1 if ($vil->{'emulated'} > 0);
	&SWHtmlPC::OutHTMLSayTextAreaPC($sow, 'wrmemo', \%htmlsay);

	print "      <label><input type=\"checkbox\" name=\"monospace\" value=\"on\"$net>等幅</label>\n";

	print <<"_HTML_";
      <p>※メモを使うとアクション回数を消費します。</p>
    </div>
    </form>
  </div>

  <div class="clearboth">
    <hr class="invisible_hr"$net>
  </div>
</div>

_HTML_

}

1;
