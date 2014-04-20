package SWHtmlVlogSinglePC;

#----------------------------------------
# ログHTMLの表示（インフォメーション）
#----------------------------------------
sub OutHTMLSingleLogInfoPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor) = @_;
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

	my $logmes = $log->{'log'};
	$logmes = "<a $atr_id=\"newsay\">$logmes</a>" if ($newsay > 0);
	&SWHtml::ConvertNET($sow, \$logmes);

	my $class = "info";
	$class = "infosp" if ($log->{'mestype'} == $sow->{'MESTYPE_INFOSP'});

	my $entry = "";
	#$entry = "($log->{'uid'}) " if (($vil->{'idrecord'} > 0) && ($query->{'turn'} == 0) && ($log->{'mestype'} == $sow->{'MESTYPE_INFOSP'}));

	print <<"_HTML_";
<p class="$class">
$entry$logmes
</p>
<hr class="invisible_hr"$net>

_HTML_
}

#----------------------------------------
# ログHTMLの表示（アクション）
#----------------------------------------
sub OutHTMLSingleLogActionPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor, $modesingle) = @_;
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

	my $logpl = &GetLogPL($sow, $vil, $log);
	my $date = $sow->{'dt'}->cvtdt($log->{'date'});
	if ($vil->{'timestamp'} > 0 && ($vil->isepilogue() == 0)) {
		$date = $sow->{'dt'}->cvtdtsht($log->{'date'});
	}

	my $chrname = $log->{'chrname'};
	$chrname = "<a $atr_id=\"newsay\">$chrname</a>" if ($newsay > 0);

	my $class_action = "action_nom";
	$class_action = "action_bm" if ($log->{'logsubid'} eq $sow->{'LOGSUBID_BOOKMARK'});

	# 発言中のアンカー等を整形
	&SWLog::ReplaceAnchorHTML($sow, $vil, \$log->{'log'}, $anchor);
	&SWHtml::ConvertNET($sow, \$log->{'log'});

	&OutHTMLFilterDivHeader($sow, $vil, $log, $no, $logpl, $modesingle);

	print <<"_HTML_";
<div class="message_filter">
<div class="$class_action">
  <p>$chrname<a $atr_id="$log->{'logid'}">は</a>、$log->{'log'}<br$net></p>
_HTML_

	print "  <div class=\"mes_date\">$date</div>\n" if ($log->{'logsubid'} ne $sow->{'LOGSUBID_BOOKMARK'});

	print <<"_HTML_";
  <hr class="invisible_hr"$net>
</div></div>
</div></div>

_HTML_

}

#----------------------------------------
# ログHTMLの表示（キャラの発言）
#----------------------------------------
sub OutHTMLSingleLogSayPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor, $modesingle) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

	# 日時とキャラクター名
	my $logpl = &GetLogPL($sow, $vil, $log);
	my $date = $sow->{'dt'}->cvtdt($log->{'date'});
	if ($vil->{'timestamp'} > 0 && ($vil->isepilogue() == 0)) {
		$date = $sow->{'dt'}->cvtdtsht($log->{'date'});
	}
	$sow->{'charsets'}->loadchrrs($logpl->{'csid'});
	my $charset = $sow->{'charsets'}->{'csid'}->{$logpl->{'csid'}};
	my $chrname = $log->{'chrname'};
	$chrname = "<a $atr_id=\"newsay\">$chrname</a>" if ($newsay > 0);


	# クラス名
	my @messtyle = ('mes_undef', 'mes_undef', 'mes_undef', 'mes_del', 'mes_deladmin', 'mes_que', 'mes_nom', 'mes_think', 'mes_wolf', 'mes_grave', 'mes_maker', 'mes_admin', 'mes_sympa', 'mes_bat', 'mes_guest');

	# キャラ画像アドレスの取得
	my $img = &SWHtmlPC::GetImgUrl($sow, $logpl, $charset->{'FACE'}, $log->{'expression'}, $log->{'mestype'});
	# キャラ画像部とその他部の横幅を取得
	my $imgwhid = 'BODY';
	$imgwhid = 'FACE' if ($charset->{'BODY'} ne '');
	my ($lwidth, $rwidth) = &SWHtmlPC::GetFormBlockWidth($sow, $charset->{"IMG$imgwhid" . 'W'});

	# ログ番号
	my $loganchor = &SWLog::GetAnchorlogID($sow, $vil, $log);

	# 発言種別
	my @logmestypetexts = ('', '', '', '【削除】', '【管理人削除】', '【未確】', '', '【独】', '【赤】', '【墓】', '', '', '【鳴】', '【念】', '');
	my $logmestypetext = '';
	$logmestypetext = " <span class=\"mestype\">$logmestypetexts[$log->{'mestype'}]</span>" if ($logmestypetexts[$log->{'mestype'}] ne '');

	# 発言中のアンカー等を整形
	&SWLog::ReplaceAnchorHTML($sow, $vil, \$log->{'log'}, $anchor);
	&SWHtml::ConvertNET($sow, \$log->{'log'});

	# 等幅処理
	my $mes_text = 'mes_text';
	$mes_text = 'mes_text_monospace' if ((defined($log->{'monospace'})) && ($log->{'monospace'} > 0));
	$mes_text = 'mes_text_loud' if ((defined($log->{'loud'})) && ($log->{'loud'} > 0));

	# ID公開
	my $showid = '';
	$showid = " ($log->{'uid'})" if (($vil->{'showid'} > 0) || ($vil->isepilogue() == 1));

	# ログのHTML出力
	&OutHTMLFilterDivHeader($sow, $vil, $log, $no, $logpl, $modesingle);
	print <<"_HTML_";
<div class="message_filter">
<div class="$messtyle[$log->{'mestype'}]">
_HTML_

	# 名前表示（上配置）
	print "  <h3 class=\"mesname\">$logmestypetext <a $atr_id=\"$log->{'logid'}\">$chrname</a>$showid</h3>\n\n" if ($charset->{'LAYOUT_NAME'} eq 'top');

	# 顔画像の表示
	print <<"_HTML_";
  <div style="float: left; width: $lwidth;">
    <div class="mes_chrimg"><img src="$img" width="$charset->{"IMG$imgwhid" . 'W'}" height="$charset->{"IMG$imgwhid" . 'H'}" alt=""$net></div>
  </div>

  <div style="float: right; width: $rwidth;">
_HTML_

	# 名前表示（右配置）
	print "    <h3 class=\"mesname\">$logmestypetext <a $atr_id=\"$log->{'logid'}\">$chrname</a>$showid</h3>\n" if ($charset->{'LAYOUT_NAME'} ne 'top');

	# 発言の表示
	print <<"_HTML_";
    <p class="$mes_text">$log->{'log'}</p>
  </div>

_HTML_

	# 発言の削除ボタン
	if ($log->{'mestype'} == $sow->{'MESTYPE_QUE'}) {
		my $reqvals = &SWBase::GetRequestValues($sow);
		my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '      ');
		my ($logmestype, $logsubid, $logcnt) = &SWLog::GetLogIDArray($log);

		print <<"_HTML_";
  <div class="clearboth">
    <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
    <p class="saycancelframe">
      <input type="hidden" name="cmd" value="cancel"$net>
      <input type="hidden" name="queid" value="$logcnt"$net>$hidden
      <input type="submit" value="この発言を削除($sow->{'cfg'}->{'MESFIXTIME'}秒以内)" class="saycancelbutton"$net>
    </p>
    </form>
    <div class="mes_date">$date</div>
  </div>

  <div>
_HTML_
	} else {
		print "  <div class=\"clearboth\">\n";
		print "    <div class=\"mes_date\">$loganchor $date</div>\n";
	}

	# 回り込みの解除
	print <<"_HTML_";
    <hr class="invisible_hr"$net>
  </div>
</div></div>
</div></div>

_HTML_

}

#----------------------------------------
# ログHTMLの表示（傍観者）
#----------------------------------------
sub OutHTMLSingleLogGuestPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

  # 日時とユーザー名
	my $logpl = &GetLogPL($sow, $vil, $log);
	my $date = $sow->{'dt'}->cvtdt($log->{'date'});
	if ($vil->{'timestamp'} > 0 && ($vil->isepilogue() == 0)) {
		$date = $sow->{'dt'}->cvtdtsht($log->{'date'});
	}
	$sow->{'charsets'}->loadchrrs($logpl->{'csid'});
	my $charset = $sow->{'charsets'}->{'csid'}->{$logpl->{'csid'}};
	my $chrname = $log->{'chrname'};
	$chrname = "<a $atr_id=\"newsay\">$chrname</a>" if ($newsay > 0);

	# キャラ画像アドレスの取得
	$charset = $vil->{'csid'};
	$charset = $sow->{'charsets'}->{'csid'}->{$charset};
	my $img = "$charset->{'DIR'}/guest$charset->{'EXT'}";

	# キャラ画像部とその他部の横幅を取得
	my $imgwhid = 'BODY';
	$imgwhid = 'FACE' if ($charset->{'BODY'} ne '');
	my ($lwidth, $rwidth) = &SWHtmlPC::GetFormBlockWidth($sow, $charset->{"IMG$imgwhid" . 'W'});

	# ログ番号
	my $loganchor = &SWLog::GetAnchorlogID($sow, $vil, $log);

	# 発言中のアンカー等を整形
	&SWLog::ReplaceAnchorHTML($sow, $vil, \$log->{'log'}, $anchor);
	&SWHtml::ConvertNET($sow, \$log->{'log'});

	# 等幅処理
	my $mes_text = 'mes_text';
	$mes_text = 'mes_text_monospace' if ((defined($log->{'monospace'})) && ($log->{'monospace'} > 0));
  $mes_text = 'mes_text_loud' if ((defined($log->{'loud'})) && ($log->{'loud'} > 0));

	# ID公開
	my $showid = '';
	$showid = " ($log->{'uid'})"; # if ($vil->{'showid'} > 0);

	# ログのHTML出力
	print <<"_HTML_";
<div class="message_filter">
<div class="mes_guest">
_HTML_

	# 名前表示（上配置）
	print "  <h3 class=\"mesname\"><a $atr_id=\"$log->{'logid'}\">$chrname</a>$showid</h3>\n\n" if ($charset->{'LAYOUT_NAME'} eq 'top');

	# 顔画像の表示
	print <<"_HTML_";
  <div style="float: left; width: $lwidth;">
    <div class="mes_chrimg"><img src="$img" width="$charset->{"IMG$imgwhid" . 'W'}" height="$charset->{"IMG$imgwhid" . 'H'}" alt=""$net></div>
  </div>

  <div style="float: right; width: $rwidth;">
_HTML_

	# 名前表示（右配置）
	print "    <h3 class=\"mesname\"><a $atr_id=\"$log->{'logid'}\">$chrname</a>$showid</h3>\n" if ($charset->{'LAYOUT_NAME'} ne 'top');

	# 発言の表示
	print <<"_HTML_";
    <p class="$mes_text">$log->{'log'}</p>
  </div>
  <div class="clearboth">
    <div class="mes_date">$loganchor $date</div>
    <hr class="invisible_hr"$net>
  </div>
</div></div>
_HTML_

}

#----------------------------------------
# ログHTMLの表示（村建て人／管理人）
#----------------------------------------
sub OutHTMLSingleLogAdminPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

	# 日時とキャラクター名
	my $chrname;
	my $curpl = $vil->getpl($log->{'uid'});
	$chrname = $log->{'chrname'};
	$chrname = "<a $atr_id=\"newsay\">$chrname</a>" if ($newsay > 0);
	my $date = $sow->{'dt'}->cvtdt($log->{'date'});
	if ($vil->{'timestamp'} > 0) {
		$date = $sow->{'dt'}->cvtdtsht($log->{'date'});
	}

	# クラス名
	my @messtyle = ('mes_maker', 'mes_admin');

	# 発言中のアンカー等を整形
	&SWLog::ReplaceAnchorHTML($sow, $vil, \$log->{'log'}, $anchor);
	&SWHtml::ConvertNET($sow, \$log->{'log'});

	my $loganchor = &SWLog::GetAnchorlogID($sow, $vil, $log);

	# 等幅処理
	my $mes_text = 'mes_text';
	$mes_text = 'mes_text_monospace' if ((defined($log->{'monospace'})) && ($log->{'monospace'} > 0));
  $mes_text = 'mes_text_loud' if ((defined($log->{'loud'})) && ($log->{'loud'} > 0));

	# ID公開
	my $showid = '';
	$showid = " ($log->{'uid'})" if (($vil->{'showid'} > 0) && ($log->{'mestype'} == $sow->{'MESTYPE_MAKER'}));

	# ログのHTML出力
	print <<"_HTML_";
<div class="message_filter">
<div class="$messtyle[$log->{'mestype'} - $sow->{'MESTYPE_MAKER'}]">
  <h3 class="mesname"><a $atr_id="$log->{'logid'}">$chrname</a>$showid</h3>
  <p class="$mes_text">$log->{'log'}</p>
  <div class="mes_date">$loganchor $date</div>
  <hr class="invisible_hr"$net>
</div>
</div>
_HTML_

}

#----------------------------------------
# ログHTMLの表示（エピローグの配役一覧）
#----------------------------------------
sub OutHTMLSingleLogCastPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor) = @_;
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $cfg   = $sow->{'cfg'};
	my $textrs = $sow->{'textrs'};
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	my $reqvals = &SWBase::GetRequestValues($sow);

	my $namelabel = '名前';
	$namelabel = "<a $atr_id=\"newsay\">$namelabel</a>" if ($newsay > 0);

	print <<"_HTML_";
<table border="1" class="vindex" summary="配役一覧">
<thead>

  <tr>
    <th scope="col">$namelabel</th>
    <th scope="col">ID</th>
    <th scope="col">生死</th>
    <th scope="col">役職</th>
  </tr>
</thead>

<tbody>
_HTML_

	my $rolename = $sow->{'textrs'}->{'ROLENAME'};
	my $pllist = $vil->getpllist();
	foreach (@$pllist) {
		my $chrname = $_->getchrname();
		$reqvals->{'vid'}  = '';
		$reqvals->{'prof'} = $_->{'uid'};
		my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
		my $uidtext = "<a href=\"$urlsow?$linkvalue\">$_->{'uid'}</a>";
		my $livetext = '生存';
		$livetext = '死亡' if ($_->{'live'} ne 'live');
		my $selrolename = $textrs->{'RANDOMROLE'};
		$selrolename = $textrs->{'ROLENAME'}->[$_->{'selrole'}] if ($_->{'selrole'} >= 0);
		my $roletext = "$rolename->[$_->{'role'}] ($selrolenameを希望)";

		if ($_->{'bonds'} ne '') {
			my @bonds = split('/', $_->{'bonds'} . '/');
			$roletext .= "<br$net>" if (@bonds > 0);
			my $target;
			foreach $target (@bonds) {
				my $targetname = $vil->getplbypno($target)->getchrname();
				$roletext .= "運命の絆★$targetname<br$net>";
			}
		}

		$roletext = "$selrolenameを希望" if ($_->{'role'} < 0);

		print <<"_HTML_";
  <tr>
    <td>$chrname</td>
    <td>$uidtext</td>
    <td>$livetext</td>
    <td>$roletext</td>
  </tr>

_HTML_
	}

	print <<"_HTML_";
</tbody>
</table>
<hr class="invisible_hr"$net>

_HTML_
}

#----------------------------------------
# ログHTMLの表示（１ログ分）
#----------------------------------------
sub OutHTMLSingleLogPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor, $modesingle) = @_;

	if (($log->{'mestype'} == $sow->{'MESTYPE_INFONOM'}) || ($log->{'mestype'} == $sow->{'MESTYPE_INFOSP'})) {
		# インフォメーション
		&OutHTMLSingleLogInfoPC($sow, $vil, $log, $no, $newsay, $anchor, $modesingle);

	} elsif ($log->{'mestype'} >= $sow->{'MESTYPE_DELETED'}) {
		if (($log->{'logsubid'} eq $sow->{'LOGSUBID_ACTION'}) || ($log->{'logsubid'} eq $sow->{'LOGSUBID_BOOKMARK'})) {
			# アクション／しおり
			&OutHTMLSingleLogActionPC($sow, $vil, $log, $no, $newsay, $anchor, $modesingle);
		} elsif (($log->{'mestype'} == $sow->{'MESTYPE_MAKER'}) || ($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'})) {
			&OutHTMLSingleLogAdminPC($sow, $vil, $log, $no, $newsay, $anchor, $modesingle);
    } elsif ($log->{'mestype'} == $sow->{'MESTYPE_GUEST'}) {
			&OutHTMLSingleLogGuestPC($sow, $vil, $log, $no, $newsay, $anchor, $modesingle);
		} elsif ($log->{'mestype'} >= $sow->{'MESTYPE_CAST'}) {
			# 配役一覧
			&OutHTMLSingleLogCastPC($sow, $vil, $log, $no, $newsay, $anchor, $modesingle);
		} else {
			# キャラクター発言
			&OutHTMLSingleLogSayPC($sow, $vil, $log, $no, $newsay, $anchor, $modesingle);
		}
	}
}

#----------------------------------------
# フィルタ用div開始タグの出力
#----------------------------------------
sub OutHTMLFilterDivHeader {
	my ($sow, $vil, $log, $no, $logpl, $modesingle) = @_;
	my $filter = $sow->{'filter'};
	my $pnofilterstyle = '';
	my $typefilterstyle = '';

	my $logpno = 'X';
	# 個人フィルタ処理
	if (($logpl->{'pno'} >= 0) && ($logpl->{'entrieddt'} <= $log->{'date'})) {
		# 村を抜けていない人はフィルタの対象
		$logpno = $logpl->{'pno'};
		$pnofilterstyle = ' style="display: none;"' if ((defined($filter->{'pnofilter'}->[$logpno])) && ($filter->{'pnofilter'}->[$logpno] eq '1'));
	}

	# 発言種別フィルタ処理
	my $mestype = $sow->{'MESTYPE2TYPEID'}->[$log->{'mestype'}];
	if ($mestype >= 0) {
		$typefilterstyle = ' style="display: none;"' if ((defined($filter->{'typefilter'}->[$mestype])) && ($filter->{'typefilter'}->[$mestype] eq '1'));
	}

	# プレビューの時はフィルタを無効
	$modesingle = 1 if (($sow->{'query'}->{'cmd'} eq 'entrypr') || ($sow->{'query'}->{'cmd'} eq 'writepr'));

	if ($modesingle == 0) {
		print "<div id=\"mespno$no" . "_$logpno\"$pnofilterstyle>";
		print "<div id=\"mestype$no" . "_$mestype\"$typefilterstyle>\n";
	} else {
		print "<div><div>\n";
	}
	return;
}

#----------------------------------------
# 指定したログの発言者データの取得
#----------------------------------------
sub GetLogPL {
	my ($sow, $vil, $log) = @_;
	my $logpl;
	my $pl = $vil->getpl($log->{'uid'});

	if ((!defined($pl->{'cid'})) || ($pl->{'entrieddt'} > $log->{'date'})) {
		# 村を抜けているプレイヤー
		my %logplsingle = (
			cid       => $log->{'cid'},
			csid      => $log->{'csid'},
			pno       => -1,
			deathday  => -1,
			entrieddt => -1,
		);
		$logpl = \%logplsingle;
	} else {
		# 村にいるプレイヤー
		my %logplsingle = (
			cid       => $log->{'cid'},
			csid      => $log->{'csid'},
			pno       => $pl->{'pno'},
			deathday  => $pl->{'deathday'},
			entrieddt => $pl->{'entrieddt'},
		);
		$logpl = \%logplsingle;
	}

	return $logpl;
}

1;
