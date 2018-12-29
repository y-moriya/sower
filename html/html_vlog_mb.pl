package SWHtmlVlogMb;

#----------------------------------------
# 村ログ表示（携帯モード）のHTML出力
#----------------------------------------
sub OutHTMLVlogMb {
	my ($sow, $vil, $logfile, $maxrow, $logs, $logkeys, $rows) = @_;

	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $cfg = $sow->{'cfg'};

	# 二重書き込み注意
	if ($sow->{'query'}->{'cmd'} ne '') {
		print <<"_HTML_";
<font color="red">★二重書き込み注意★</font><br$net>
リロードする場合は「新」を使って下さい。
<hr$net>
_HTML_
	}

	# 村名及びリンク表示
	print "<a $atr_id=\"top\">$sow->{'query'}->{'vid'} $vil->{'vname'}</a><br$net>\n";

	# キャラ名表示
	if (defined($sow->{'curpl'}->{'uid'})) {
		my $chrname = $sow->{'curpl'}->getchrname();
		my $rolename = '';
		$rolename = "($sow->{'textrs'}->{'ROLENAME'}->[$sow->{'curpl'}->{'role'}])" if ($sow->{'curpl'}->{'role'} >= 0);
		my $markbonds = '';
		$markbonds = " ★$sow->{'textrs'}->{'MARK_BONDS'}" if ($sow->{'curpl'}->{'bonds'} ne '');
		print "$chrname$rolename$markbonds<br$net>\n";
	}

#	my $list = $logfile->{'logindex'}->{'file'}->getlist();
	my $list = $logfile->getlist();
	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 0, $logs, $list, $rows);

	if (defined($sow->{'curpl'}->{'uid'})) {
		if (($vil->{'turn'} == 0) && ($sow->{'curpl'}->{'limitentrydt'} > 0)) {
			my $limitdate = $sow->{'dt'}->cvtdt($sow->{'curpl'}->{'limitentrydt'});
			print <<"_HTML_";
<font color="red">$limitdateまでに一度も発言せず村も開始されなかった場合、あなたは自動的に村から追い出されます。</font>
<hr$net>
_HTML_
		}
	}

	if (($sow->{'turn'} == $vil->{'turn'}) && ($vil->{'epilogue'} < $vil->{'turn'})) {
		# 終了表示
		print "<p>終了しました。</p>\n\n";

	} else {
		# 村ログ表示
		my $order = $sow->{'query'}->{'order'};
		my %anchor = (
			logfile => $logfile,
			logkeys => $logkeys,
			rowover => $rows->{'rowover'},
		);

		if (($order eq 'desc') || ($order eq 'd')){
			# 降順
			my $i;
			for ($i = $#$logs; $i >= 0; $i--) {
				next if (!defined($logs->[$i]->{'pos'}));
				my $log = $logfile->{'logfile'}->{'file'}->read($logs->[$i]->{'pos'});
				&OutHTMLSingleLogMb($sow, $vil, $log, \%anchor);
			}
		} else {
			# 昇順
			foreach (@$logs) {
				next if (!defined($_->{'pos'}));
				my $log = $logfile->{'logfile'}->{'file'}->read($_->{'pos'});
				&OutHTMLSingleLogMb($sow, $vil, $log, \%anchor);
			}
		}

		if ($sow->{'turn'} == $vil->{'turn'}) {
			# 最新日表示時

			# 未参加／未ログイン時アナウンス
			if (($vil->{'turn'} == 0) && ($sow->{'user'}->logined() <= 0)){
				print <<"_HTML_";
<p>
演じたいキャラクターを選び、発言してください。<br$net>
</p>

<p>
ルールをよく理解した上でご参加下さい。<br$net>
※希望能\力についての発言は控えてください。
</p>

_HTML_
			}

			my $nosaytext = &SWHtmlVlog::GetNoSayListText($sow, $vil, $pl, $plid);
			if (($vil->{'turn'} != 0) && ($vil->isepilogue() == 0) && ($nosaytext ne '')) {
				# 未発言者リストの表示
				print "<p>$nosaytext</p>\n<hr$net>\n\n";
			}
		}
	}

	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 1, $logs, $list, $rows);

	return;
}

#----------------------------------------
# ログHTMLの表示（１ログ分）
#----------------------------------------
sub OutHTMLSingleLogMb {
	my ($sow, $vil, $log, $logkeys) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $textrs = $sow->{'textrs'};

	if ($log->{'mestype'} == $sow->{'MESTYPE_INFONOM'}) {
		# インフォメーション
		print <<"_HTML_";
<font color="maroon">$log->{'log'}</font>
<hr$net>
_HTML_
	} elsif ($log->{'mestype'} == $sow->{'MESTYPE_INFOSP'}) {
		# 注意表示
		print <<"_HTML_";
<font color="gray">$log->{'log'}</font>
<hr$net>
_HTML_
	} elsif ($log->{'mestype'} >= $sow->{'MESTYPE_DELETED'}) {
		my $date = $sow->{'dt'}->cvtdtmb($log->{'date'});
		if ($vil->{'timestamp'} > 0 && ($vil->isepilogue() == 0)) {
			$date = $sow->{'dt'}->cvtdtmbsht($log->{'date'});
		}
		if (($log->{'logsubid'} eq $sow->{'LOGSUBID_ACTION'}) || ($log->{'logsubid'} eq $sow->{'LOGSUBID_BOOKMARK'})) {
			# アクション
			# 発言中のアンカーを整形
			my $mes = &SWLog::ReplaceAnchorHTMLMb($sow, $vil, $log->{'log'}, $logkeys);
			&SWHtml::ConvertNET($sow, \$mes);
			my @logmestypetext = ('', '', '', '', '', '', '', '', '');
			my $actcolorbegin = '';
			my $actcolorend   = '';
			if ($log->{'logsubid'} eq $sow->{'LOGSUBID_BOOKMARK'}) {
				$actcolorbegin = '<font color="maroon">';
				$actcolorend = '</font>';
			}

			print <<"_HTML_";
$actcolorbegin$logmestypetext[$log->{'mestype'}]$log->{'chrname'}は、$mes$actcolorend
_HTML_
			print "$date<br$net>\n" if ($log->{'logsubid'} ne $sow->{'LOGSUBID_BOOKMARK'});
		} elsif ($log->{'mestype'} >= $sow->{'MESTYPE_CAST'}) {
			# 配役一覧
			my $rolename = $sow->{'textrs'}->{'ROLENAME'};
			my $pllist = $vil->getpllist();
			foreach (@$pllist) {
				my $chrname = $_->getchrname();
				my $livetext = '生存';
				$livetext = '死亡' if ($_->{'live'} ne 'live');
				my $selrolename = $textrs->{'RANDOMROLE'};
				$selrolename = $textrs->{'ROLENAME'}->[$_->{'selrole'}] if ($_->{'selrole'} >= 0);
				my $roletext = "$rolename->[$_->{'role'}]だった($selrolenameを希望)。";
				$roletext .= " ★$sow->{'textrs'}->{'MARK_BONDS'}" if ($_->{'bonds'} ne '');
				$roletext = "$selrolenameを希望していた。" if ($_->{'role'} < 0);
				print <<"_HTML_";
<font color="maroon">$chrname ($_->{'uid'})、$livetext。$roletext</font><br$net>
_HTML_
			}
		} else {
			# キャラクターの発言
			my @logmestypetext = ('', '', '', '【削除】', '【管理人削除】', '【未確】', '【人】', '【独】', '【赤】', '【墓】', '', '', '【鳴】', '【念】');

			# 発言色
			my @logcolor = ('', '', '', 'gray', 'gray', '', '', 'gray', 'red', 'blue', '', '', 'green', 'purple');

			# 発言中のアンカーを整形
			my $loganchor = &SWLog::GetAnchorlogID($sow, $vil, $log);
			$loganchor = "($loganchor)" if $loganchor ne "";
			my $mes = &SWLog::ReplaceAnchorHTMLMb($sow, $vil, $log->{'log'}, $logkeys);
			&SWHtml::ConvertNET($sow, \$mes);

			my $colorstart = '';
			my $colorend = '';
			if ($logcolor[$log->{'mestype'}] ne '') {
				$colorstart = "<font color=\"$logcolor[$log->{'mestype'}]\">\n";
				$colorend = "\n</font>";
			}

			# キャラ画像アドレスの取得
			my $mbsayimg = $sow->{'query'}->{'mbsayimg'};
			my $img = '';
			if ($mbsayimg ne '') {
				require "$cfg->{'DIR_HTML'}/html_vlogsingle_pc.pl";
				require "$cfg->{'DIR_HTML'}/html_pc.pl";
				my $logpl = &SWHtmlVlogSinglePC::GetLogPL($sow, $vil, $log);
				my $charset = $sow->{'charsets'}->{'csid'}->{$logpl->{'csid'}};
				$img = &SWHtmlPC::GetImgUrl($sow, $logpl, $charset->{'FACE'}, $log->{'expression'});
				$img = "<img src=\"$img\"><br$net>";
			}

			my $showid = '';
			$showid = " ($log->{'uid'})" if (($vil->{'showid'} > 0) || ($vil->isepilogue() == 1));

			my $loud = '';
			$loud = "（大声）<br$net>" if ($log->{'loud'} > 0);

			print <<"_HTML_";
$colorstart$logmestypetext[$log->{'mestype'}]<a $atr_id="$log->{'logid'}">$log->{'chrname'}</a>$showid $date$loganchor<br$net>
$img
$loud$mes<br$net>$colorend
_HTML_

			if ($log->{'mestype'} == $sow->{'MESTYPE_QUE'}) {
				# 発言撤回ボタンの表示
				my ($logmestype, $logsubid, $logcnt) = &SWLog::GetLogIDArray($log);
				$sow->{'query'}->{'cmd'} = 'cancel';
				my $reqvals = &SWBase::GetRequestValues($sow);
				my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');

				print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
<input type="hidden" name="cmd" value="cancel">
<input type="hidden" name="queid" value="$logcnt">$hidden
<input type="submit" value="削除($sow->{'cfg'}->{'MESFIXTIME'}秒以内)">
</form>
_HTML_
			}
		}
		print "<hr$net>\n";
	}
}

#----------------------------------------
# 携帯用顔グラフィックのHTML出力
#----------------------------------------
sub OutHTMLMbImg {
	my ($sow, $vil) = @_;

	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $cfg = $sow->{'cfg'};
	my $pno = $sow->{'query'}->{'pno'};

	my $pl = $vil->getplbypno($pno);
	my $charset = $sow->{'charsets'}->{'csid'}->{$pl->{'csid'}};
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_pc.pl";
	my $img = &SWHtmlPC::GetImgUrl($sow, $pl, $charset->{'FACE'}, 0);

	print <<"_HTML_";
<!--◆「キャラの名前」の顔画像<br>-->
<img src="$img"><br>
携帯の機種によっては表\示されない場合があります。<br>
携帯のキー操作で元の画面に戻ってください。
<hr>

_HTML_
}

1;
