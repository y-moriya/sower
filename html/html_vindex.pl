package SWHtmlVIndex;

#----------------------------------------
# 村の一覧HTML出力
#----------------------------------------
sub OutHTMLVIndex {
	my ($sow, $vindex, $vmode) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $amp = $sow->{'html'}->{'amp'};

	require "$cfg->{'DIR_LIB'}/log.pl";

	my $maxrow = $sow->{'cfg'}->{'MAX_ROW'}; # 標準行数
	$maxrow = $query->{'row'} if (defined($query->{'row'}) && ($query->{'row'} ne '')); # 引数による行数指定
	$maxrow = -1 if (($maxrow eq 'all') || ($query->{'rowall'} ne '')); # 引数による全表示指定

	my $pageno = 0;
	$pageno = $query->{'pageno'} if (defined($query->{'pageno'}));

	print <<"_HTML_";
<table border="1" class="vindex" summary="村の一覧">
<thead>
  <tr>
    <th scope="col">村の名前</th>
    <th scope="col">人数</th>
_HTML_

	if ($vmode eq 'oldlog') {
		print "    <th id=\"days_$vmode\">日数</th>\n"
	} else {
		print "    <th id=\"vstatus_$vmode\">進行</th>\n"
	}

	print <<"_HTML_";
    <th scope="col">更新</th>
    <th scope="col">役職配分</th>
    <th scope="col">発言制限</th>
  </tr>
</thead>

<tbody>
_HTML_

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = '';
	$reqvals->{'vid'} = '';

	my $vilist = $vindex->getvilist();
	my $vicount = 0;
	my $virow = -1;
	foreach (@$vilist) {
		my $date = sprintf("%02d:%02d", $_->{'updhour'}, $_->{'updminite'});
		my $vil = SWFileVil->new($sow, $_->{'vid'});
		$vil->readvil();
		my $pllist = $vil->getpllist();
		$vil->closevil();

		my $vstatusno = 'playing';
		$vstatusno = 'prologue' if ($vil->{'turn'} == 0); # プロローグ
		$vstatusno = 'oldlog' if ($vil->{'epilogue'} < $vil->{'turn'}); # 終了した村

		next if ($vstatusno ne $vmode); # 指定していない村は除外

		if (!defined($vil->{'trsid'})) {
			# 村データがぶっ飛んだ場合に一応被害を食い止める
			print <<"_HTML_";
  <tr>
    <td colspan="5"><span class="cautiontext">$_->{'vid'}村のデータが取得できません。</span></td>
  </tr>

_HTML_
			next;
		}

		$virow++;
		if ($maxrow > 0) {
			next if ($virow < $pageno * $maxrow);
			next if ($virow >= ($pageno + 1) * $maxrow);
		}

		$vicount++;
		&SWBase::LoadTextRS($sow, $vil);
		my $csname = '複数';
		if (index($vil->{'csid'}, '/') < 0) {
			$sow->{'charsets'}->loadchrrs($vil->{'csid'});
			my $charset = $sow->{'charsets'}->{'csid'}->{$vil->{'csid'}};
			$csname = $charset->{'CAPTION'};
		}

		my $plcnt = scalar(@$pllist);
		if ($vmode eq 'prologue') {
			$plcnt .= "/$vil->{'vplcnt'}人"
		} else {
			$plcnt .= '人';
		}

		my $updintervalday = $vil->{'updinterval'} * 24;
		$updintervalday .= 'h';
		my $vstatus = "$vil->{'turn'}日目";
		if ($vil->{'winner'} != 0) {
			$vstatus = '決着';
		} elsif ($vil->isepilogue() > 0) {
			$vstatus = '廃村';
		}
		if ($vmode eq 'oldlog') {
			my $numdays = $vil->{'turn'} - 2;
			if ($vstatus eq '廃村') {
				$vstatus = "$numdays日(廃村)";
			} else {
				$vstatus = "$numdays日";
			}
		}
		if ($vil->{'turn'} == 0) {
			if ($vil->{'vplcnt'} > @$pllist) {
				$vstatus = '募集中';
			} else {
				$vstatus = '開始前';
			}
		}

		my $countssay = $sow->{'cfg'}->{'COUNTS_SAY'};
		my $imgpwdkey = '';
		if (defined($vil->{'entrylimit'})) {
			$imgpwdkey = "<img src=\"$cfg->{'DIR_IMG'}/key.png\" width=\"16\" height=\"16\" alt=\"[鍵]\"$net> " if ($vil->{'entrylimit'} eq 'password');
		}

		my $imgrating = '';
		if ((defined($vil->{'rating'})) && ($vil->{'rating'} ne '')) {
			if (defined($sow->{'cfg'}->{'RATING'}->{$vil->{'rating'}}->{'FILE'})) {
				my $rating = $sow->{'cfg'}->{'RATING'}->{$vil->{'rating'}};
				$imgrating = "<img src=\"$cfg->{'DIR_IMG'}/$rating->{'FILE'}\" width=\"$rating->{'WIDTH'}\" height=\"$rating->{'HEIGHT'}\" alt=\"[$rating->{'ALT'}]\" title=\"$rating->{'CAPTION'}\"$net> " if ($rating->{'FILE'} ne '');
			}
		}

		$reqvals->{'cmd'} = '';
		$reqvals->{'vid'} = $_->{'vid'};
		my $link = &SWBase::GetLinkValues($sow, $reqvals);
		$reqvals->{'cmd'} = 'vinfo';
		my $linkvinfo = &SWBase::GetLinkValues($sow, $reqvals);
		my $vcomment = &SWLog::ReplaceAnchorHTMLRSS($sow, $vil, $vil->{'vcomment'});

		print <<"_HTML_";
  <tr>
    <td>$imgpwdkey$imgrating<a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link#newsay">$_->{'vid'} $vil->{'vname'}</a> 〈<a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvinfo#newsay" title="$vcomment">情報</a>〉</td>
    <td>$plcnt</td>
    <td>$vstatus</td>
    <td>$date/$updintervalday</td>
    <td>$sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$vil->{'roletable'}}</td>
    <td>$countssay->{$vil->{'saycnttype'}}->{'CAPTION'}</td>
  </tr>

_HTML_

	}

	if ($vicount == 0) {
		my $vmodetext;
		if ($vmode eq 'prologue') {
			$vmodetext = '募集中／開始待ち';
		} elsif ($vmode eq 'oldlog') {
			$vmodetext = '終了済み';
		} else {
			$vmodetext = '進行中';
		}

		print <<"_HTML_";
  <tr>
    <td colspan="6">現在$vmodetextの村はありません。</td>
  </tr>

_HTML_
	}

	print <<"_HTML_";
</tbody>
</table>

_HTML_

	if ($vmode eq 'oldlog') {
		print "<p class=\"pagenavi\">\n";
		$reqvals = &SWBase::GetRequestValues($sow);
		$reqvals->{'cmd'} = $query->{'cmd'};

		if (($pageno > 0) && ($maxrow > 0)) {
			$reqvals->{'pageno'} = $pageno - 1;
			my $link = &SWBase::GetLinkValues($sow, $reqvals);
			print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">前のページ</a> \n";
		} else {
			print "前のページ \n";
		}

		if ((($pageno + 1) * $maxrow <= $virow) && ($maxrow > 0)) {
			$reqvals->{'pageno'} = $pageno + 1;
			my $link = &SWBase::GetLinkValues($sow, $reqvals);
			print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">次のページ</a> \n";
		} else {
			print "次のページ \n";
		}

		if (($virow + 1) != $vicount) {
			$reqvals->{'rowall'} = 'on';
			my $link = &SWBase::GetLinkValues($sow, $reqvals);
			print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">全表\示</a>\n";
		} else {
			print "全表\示\n";
		}
		print "</p>\n";
	}
}

1;
