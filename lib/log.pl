package SWLog;

#----------------------------------------
# 発言関連ライブラリ
#----------------------------------------

#----------------------------------------
# ログIDの生成
#----------------------------------------
sub CreateLogID {
	my ($sow, $mestype, $logsubid, $logcnt) = @_;
	my $logid = sprintf(
		"%s%s%05d",
		$sow->{'LOGMESTYPE'}->[$mestype],
		$logsubid,
		$logcnt,
	);

	return $logid;
}

#----------------------------------------
# ログIDを配列に分割して返す
#----------------------------------------
sub GetLogIDArray {
	my $logmestype = substr($_[0]->{'logid'}, 0, 1);
	my $logsubid = substr($_[0]->{'logid'}, 1, 1);
	my $logcnt = substr($_[0]->{'logid'}, 2);

	return ($logmestype, $logsubid, $logcnt);
}

#----------------------------------------
# アンカー用のログ番号を取得
#----------------------------------------
sub GetAnchorlogID {
	my ($sow, $vil, $log) = @_;
	my ($logmestype, $logsubid, $logcnt) = &GetLogIDArray($log);

	$logcntnum = int($logcnt);
	my $loganchormark = $sow->{'MARK_LOGANCHOR'};
	my $loganchor = '';
	$loganchor = "$loganchormark->{$logmestype}$logcntnum" if (defined($loganchormark->{$logmestype}));

	$loganchor = '' if ($logcntnum == $sow->{'LOGCOUNT_UNDEF'});
	$loganchor = '' if (($log->{'mestype'} == $sow->{'MESTYPE_TSAY'}) && ($vil->isepilogue() == 0));

	return $loganchor;
}

#----------------------------------------
# アンカーを内部データ形式に変換(プレビュー専用)
#----------------------------------------
sub ReplacePreviewAnchor {
	my ($sow, $vil, $log) = @_;
	my $mes = $log->{'log'};
	$sow->{'debug'}->writeaplog($sow->{'APLOG_OTHERS'}, "Target. [$log->{'log'}]");
	while ($mes =~ /&gt;&gt;[\+\-\*\#\%\=\!g]?(\d{1,$sow->{'MAXWIDTH_TURN'}}:)?[\+\-\*\#\%\=\!g]?\d{1,$sow->{'MAXWIDTH_LOGCOUNT'}}/) {
		my $anchortext = $&;
		my ($mestypestr, $mestypestr2, $turn, $logno);
		$anchortext =~ /(&gt;&gt;)([AS]?)([\+\-\*\#\%\=\!g]?)(\d+:)?([\+\-\*\#\%\=\!g]?)(\d+)/;
		my $mestypemark1 = $3;
		my $mestypemark2 = $5;
		$mestypestr = $3;
		$turn = $4;
		$mestypestr = $5 if ($mestypestr eq '');
		$logno = $6;

		if (defined($turn)) {
			chop($turn);
		} else {
			$turn = $sow->{'turn'};
		}

		# ログIDの生成
		$mestypestr = '' if (!defined($mestypestr));
		my $mestype = $sow->{'MESTYPE_SAY'};
		my $logmestype = $sow->{'LOGMESTYPE'};
		my $loganchormark = $sow->{'MARK_LOGANCHOR'};
		my $i;
		for ($i = $sow->{'MESTYPE_SAY'}; $i <= $sow->{'MESTYPE_GUEST'}; $i++) {
			$mestype = $i if ($mestypestr eq $loganchormark->{$logmestype->[$i]});
		}

		my $logsubid = $sow->{'LOGSUBID_SAY'};
		my $logid = &CreateLogID($sow, $mestype, $logsubid, $logno);

		# リンクの文字列用データ
		my $linktext = $anchortext;
		$linktext =~ s/&gt;&gt;//;

		my $mwtag = "<mw $logid,$turn,$linktext>";
		my $skipmwtag = $anchortext;
		$skipmwtag =~ s/&gt;&gt;/<mw>/;

		# 正規表現での誤認識を防ぐ
		&BackQuoteAnchorMark(\$anchortext);

		# 変換
		$mes =~ s/$anchortext/$mwtag/;
	}
	$mes =~ s/<mw>/&gt;&gt;/g;

	return $mes;
}

#----------------------------------------
# アンカーを内部データ形式に変換
#----------------------------------------
sub ReplaceAnchor {
	my ($sow, $vil, $say) = @_;
	my $mes = $say->{'mes'};
	my $saypl = $vil->getpl($say->{'uid'});

#	while ($mes =~ /&gt;&gt;[AS]?[\+\-\*\#\%\=\!]?(\d{1,$sow->{'MAXWIDTH_TURN'}}:)?[\+\-\*\#\%\=\!]?\d{1,$sow->{'MAXWIDTH_LOGCOUNT'}}/) {
	while ($mes =~ /&gt;&gt;[\+\-\*\#\%\=\!g]?(\d{1,$sow->{'MAXWIDTH_TURN'}}:)?[\+\-\*\#\%\=\!g]?\d{1,$sow->{'MAXWIDTH_LOGCOUNT'}}/) {
		my $anchortext = $&;
		my ($mestypestr, $mestypestr2, $turn, $logno);
		$anchortext =~ /(&gt;&gt;)([AS]?)([\+\-\*\#\%\=\!g]?)(\d+:)?([\+\-\*\#\%\=\!g]?)(\d+)/;
		my $mestypemark1 = $3;
		my $mestypemark2 = $5;
		$mestypestr = $3;
		$turn = $4;
		$mestypestr = $5 if ($mestypestr eq '');
		$logno = $6;

		if (defined($turn)) {
			chop($turn);
		} else {
			$turn = $sow->{'turn'};
		}

		# ログIDの生成
		$mestypestr = '' if (!defined($mestypestr));
		my $mestype = $sow->{'MESTYPE_SAY'};
		my $logmestype = $sow->{'LOGMESTYPE'};
		my $loganchormark = $sow->{'MARK_LOGANCHOR'};
		my $i;
		for ($i = $sow->{'MESTYPE_SAY'}; $i <= $sow->{'MESTYPE_GUEST'}; $i++) {
			$mestype = $i if ($mestypestr eq $loganchormark->{$logmestype->[$i]});
		}

		my $logsubid = $sow->{'LOGSUBID_SAY'};
#		$logsubid = $sow->{'LOGSUBID_ACTION'} if (defined($2) && ($2 eq $sow->{'LOGSUBID_ACTION'})); # てへっ♪（ぉぃ
		my $logid = &CreateLogID($sow, $mestype, $logsubid, $logno);

		# リンクの文字列用データ
		my $linktext = $anchortext;
		$linktext =~ s/&gt;&gt;//;

		my $mwtag = "<mw $logid,$turn,$linktext>";
		my $skipmwtag = $anchortext;
		$skipmwtag =~ s/&gt;&gt;/<mw>/;

		# 妥当性チェック
		my $saymestype = $say->{'mestype'};
		$saymestype = $sow->{'MESTYPE_SAY'} if ($saymestype == $sow->{'MESTYPE_QUE'});
		my $rolesay = $sow->{'textrs'}->{'CAPTION_ROLESAY'};
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "秘密会話へのアンカーを通常発言に打つ事はできません。","cannot anchor [$mestype].") if (($vil->isepilogue() == 0) && ($saymestype == $sow->{'MESTYPE_SAY'}) && (($mestype == $sow->{'MESTYPE_WSAY'}) || ($mestype == $sow->{'MESTYPE_SPSAY'}) || ($mestype == $sow->{'MESTYPE_BSAY'})));

		$mwtag = $skipmwtag if (($mestypemark1 ne '') && ($mestypemark2 ne '')); # 種別指定が２つある
		if (($mestype != $sow->{'MESTYPE_SAY'}) && ($mestype != $sow->{'MESTYPE_MAKER'}) && ($mestype != $sow->{'MESTYPE_ADMIN'}) && ($mestype != $sow->{'MESTYPE_GUEST'})) {
			if ($vil->isepilogue() == 0) {
				# 進行中

				# 墓下独り言から墓下へのアンカーチェック
				my $tsay2gsay = 1;
				$tsay2gsay = 0 if ($sow->{'cfg'}->{'ENABLED_TSAY_GRAVE'} == 0); # 墓下独り言禁止
				$tsay2gsay = 0 if ($mestype != $sow->{'MESTYPE_GSAY'}); # アンカー先が墓下ではない
				$tsay2gsay = 0 if ($saymestype != $sow->{'MESTYPE_TSAY'}); # アンカー元が独り言ではない
				$tsay2gsay = 0 if ($saypl->{'live'} eq 'live'); # まだ生存中

				$mwtag = $skipmwtag if (($mestype ne $saymestype) && ($tsay2gsay == 0)); # 異なるmestypeへは張れない
				$mwtag = $skipmwtag if ($mestype == $sow->{'MESTYPE_TSAY'}); # 独り言へは張れない
				$mwtag = $skipmwtag if ($turn == 0); # プロローグの囁き／独り言／墓下へは張れない
			} else {
				# エピローグ中
				# これいらなくね？
				#$mwtag = $skipmwtag if ($turn == $vil->{'turn'}); # 当日は通常発言以外に張れない
				#$mwtag = $skipmwtag if (($turn == 0) && ($mestype != $sow->{'MESTYPE_TSAY'})); # プロローグへは通常発言と独り言以外張れない
				#$mwtag = $skipmwtag if (($turn == 0) && ($sow->{'cfg'}->{'ENABLED_TSAY_PRO'} == 0)); # 独り言＠プロローグでも設定で禁止していたら張れない
			}
		}

		# 正規表現での誤認識を防ぐ
		&BackQuoteAnchorMark(\$anchortext);

		# 変換
		$mes =~ s/$anchortext/$mwtag/;
	}
	$mes =~ s/<mw>/&gt;&gt;/g;

	return $mes;
}

#----------------------------------------
# 内部データ形式のアンカーをHTMLに整形
#----------------------------------------
sub ReplaceAnchorHTML {
	my ($sow, $vil, $mes, $anchor) = @_;
	my $cfg = $sow->{'cfg'};

#	my $reqvals = &SWBase::GetRequestValues($sow);
	my $reqvals = $anchor->{'reqvals'};

	my $blank = $sow->{'html'}->{'target'};
	$$mes =~ s/(s?https?:\/\/[^\/<>\s]+)[-_.!~*'()a-zA-Z0-9;\/?:\@&=+\$,%#]+/<a href=\"$&\" class=\"res_anchor\"$blank>&lt;$1&gt;<\/a>/g;

	while ($$mes =~ /<mw ([a-zA-Z]+\d+),([^,]*),([^>]+)>/) {
		my $anchortext = $&;
		my $logid = $1;
		my $turn = $2;
		my $linktext = $3;

		$reqvals->{'row'} = '';
		$reqvals->{'turn'} = '';
		$reqvals->{'logid'} = '';
		$reqvals->{'pno'} = '';
		my $link = '';
		my $title = '';
		my $blank = $sow->{'html'}->{'target'};

		$anchor->{'logkeys'}->{$logid} = -1 if (!defined($anchor->{'logkeys'}->{$logid}));
		if ($turn == $sow->{'turn'}) {
			if ($anchor->{'logkeys'}->{$logid} >= 0) {
				$reqvals->{'rowall'} = '';
				$link = "#$logid";
				$blank = '';
			} else {
				$reqvals->{'turn'} = $turn if ($turn != $vil->{'turn'});
				$reqvals->{'logid'} = $logid;
				$link = &SWBase::GetLinkValues($sow, $reqvals);
				$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?vid=1&$link";
			}
		} else {
			$reqvals->{'turn'} = $turn if ($turn != $vil->{'turn'});
			$reqvals->{'logid'} = $logid;
			$link = &SWBase::GetLinkValues($sow, $reqvals);
			$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";
		}

		# 正規表現での誤認識を防ぐ
		&BackQuoteAnchorMark(\$anchortext);

		$$mes =~ s/$anchortext/<a href=\"$link\" class=\"res_anchor\"$blank>&gt;&gt;$linktext<\/a>/;
	}

	return $mes;
}

#----------------------------------------
# ポップアップアンカー
#----------------------------------------
sub GetPopupAnchor {
	my ($sow, $vil, $logid, $anchor) = @_;
	my $title = '';

	my $logidxno = $anchor->{'logfile'}->{'logindex'}->{'file'}->getbyid($logid);
	if ($logidxno >= 0) {
		my $logidx = $anchor->{'logfile'}->{'logindex'}->{'file'}->getlist->[$logidxno];
		my $log = $anchor->{'logfile'}->read($logidx->{'pos'});
		my $chrname = $log->{'chrname'};
	  my $date = $sow->{'dt'}->cvtdt($log->{'date'});
	  my $showid = '';
	  $showid = " ($log->{'uid'})" if ($vil->{'showid'} > 0);
		my $targetmes = &ReplaceAnchorHTMLRSS($sow, $vil, $log->{'log'}, $anchor);
		$targetmes =~ s/<br( \/)?>/ /ig;
		$title = "$chrname$showid $date<br>$targetmes";
	}

	return $title;
}

#----------------------------------------
# 内部データ形式のアンカーをHTMLに整形（モバイル用）
#----------------------------------------
sub ReplaceAnchorHTMLMb {
	my ($sow, $vil, $mes, $anchor) = @_;
	my $cfg = $sow->{'cfg'};
	my $reqvals = &SWBase::GetRequestValues($sow);

	while ($mes =~ /<mw ([a-zA-Z]+\d+),([^,]*),([^>]+)>/) {
		my $anchortext = $&;
		my $logid = $1;
		my $turn = $2;
		my $linktext = $3;

		$reqvals->{'turn'} = '';
		$reqvals->{'pno'} = '';
		my $link = '';
		$turn = $sow->{'query'}->{'turn'} if ($turn eq '');
		$anchor->{'logkeys'}->{$logid} = -1 if (!defined($anchor->{'logkeys'}->{$logid}));
		if (($turn == $sow->{'turn'}) && (($anchor->{'rowover'} == 0) || ($anchor->{'logkeys'}->{$logid} >= 0))) {
			$link = "#$logid";
		} else {
			$reqvals->{'turn'} = $turn if ($turn != $vil->{'turn'});
			$reqvals->{'logid'} = $logid;
			$link = &SWBase::GetLinkValues($sow, $reqvals);
			$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";
		}

		# 正規表現での誤認識を防ぐ
		&BackQuoteAnchorMark(\$anchortext);

		$mes =~ s/$anchortext/<a href=\"$link\">&gt;&gt;$linktext<\/a>/;
	}

	return $mes;
}

#----------------------------------------
# 内部データ形式のアンカーをテキストに整形（RSS向け）
# ※引数の $anchor は未使用
#----------------------------------------
sub ReplaceAnchorHTMLRSS {
	my ($sow, $vil, $mes, $anchor) = @_;
	my $cfg = $sow->{'cfg'};

	while ($mes =~ /<mw ([a-zA-Z]+\d+),([^,]*),([^>]+)>/) {
		my $anchortext = $&;
		my $linktext = $3;

		# 正規表現での誤認識を防ぐ
		&BackQuoteAnchorMark(\$anchortext);

		$mes =~ s/$anchortext/&gt;&gt;$linktext/;
	}
	$mes =~ s/<(\/)?strong>//g;
	$mes =~ s/\'/\\\'/g;

	return $mes;
}

#----------------------------------------
# 正規表現での誤認識を防ぐため記号を変換
#----------------------------------------
sub BackQuoteAnchorMark {
	my $anchortext = shift;

	$$anchortext =~ s/\+/\\\+/g;
	$$anchortext =~ s/\*/\\\*/g;
	$$anchortext =~ s/\-/\\\-/g;
	$$anchortext =~ s/\#/\\\#/g;
	$$anchortext =~ s/\%/\\\%/g;
	$$anchortext =~ s/\!/\\\!/g;
	$$anchortext =~ s/\=/\\\=/g;

	return $anchortext;
}

#----------------------------------------
# ランダム表示機能
#----------------------------------------
sub CvtRandomText {
	my ($sow, $vil, $mes) = @_;
	my $cfg = $sow->{'cfg'};

	return $mes if ($cfg->{'ENABLED_RANDOMTEXT'} == 0);

	# 1d6
	$mes =~ s/\[\[$cfg->{'RANDOMTEXT_1D6'}\]\]/{my $a = int(rand(6))+1;"<strong>{$a}<\/strong>"}/eg;

	# 1d10
	$mes =~ s/\[\[$cfg->{'RANDOMTEXT_1D10'}\]\]/{my $a = int(rand(10))+1; sprintf("<strong>(%02d)<\/strong>", $a)}/eg;

	# 1d20
	$mes =~ s/\[\[$cfg->{'RANDOMTEXT_1D20'}\]\]/{my $a = int(rand(20))+1; sprintf("<strong>[%02d]<\/strong>", $a)}/eg;

	# fortune
	$mes =~ s/\[\[$cfg->{'RANDOMTEXT_FORTUNE'}\]\]/{my $a = int(rand(101)); sprintf("<strong>%s<\/strong>", $a)}/eg;

	# who
	my $livepllist = $vil->getlivepllist();
	$livepllist = $vil->getpllist() if ($vil->{'turn'} >= $vil->{'epilogue'});
	$mes =~ s/\[\[$cfg->{'RANDOMTEXT_LIVES'}\]\]/{my $a = int(rand(scalar(@$livepllist))); sprintf("<strong>&lt;&lt;%s&gt;&gt;<\/strong>", $livepllist->[$a]->getchrname())}/eg;

	# omikuji
	$mes =~ s/\[\[$cfg->{'RANDOMTEXT_MIKUJI'}\]\]/{my $a = int(rand(6))+1; my $b = int(rand(6))+1; my $c = int(rand(6))+1; sprintf("<strong>*%s*<\/strong>", $cfg->{'MIKUJI'}->[$a+$b+$c - 3])}/eg;

	# role
	my $rolename = $sow->{'textrs'}->{'ROLENAME'};
	$mes =~ s/\[\[$cfg->{'RANDOMTEXT_ROLE'}\]\]/{my $a = int(rand(scalar(@$rolename)-1))+1; sprintf("<strong>((%s))<\/strong>", $rolename->[$a])}/eg;

	return $mes;
}

1;
