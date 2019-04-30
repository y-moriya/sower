package SWHtmlVlogSinglePC;

#----------------------------------------
# ���OHTML�̕\���i�C���t�H���[�V�����j
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

	print <<"_HTML_";
<p class="$class">
<a class=\"anchor\" $atr_id=\"$log->{'logid'}\"></a>
$entry$logmes
</p>

<hr class="invisible_hr"$net>

_HTML_

}

#----------------------------------------
# ���OHTML�̕\���i�A�N�V�����j
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

	# �������̃A���J�[���𐮌`
	&SWLog::ReplaceAnchorHTML($sow, $vil, \$log->{'log'}, $anchor);
	&SWHtml::ConvertNET($sow, \$log->{'log'});

	&OutHTMLFilterDivHeader($sow, $vil, $log, $no, $logpl, $modesingle);

	print <<"_HTML_";
<div class="message_filter">
<div class="$class_action">
  <p>$chrname<a class=\"anchor\" $atr_id="$log->{'logid'}">��</a>�A$log->{'log'}<br$net></p>
_HTML_

	print "  <div class=\"mes_date\">$date</div>\n" if ($log->{'logsubid'} ne $sow->{'LOGSUBID_BOOKMARK'});

	print <<"_HTML_";
  <hr class="invisible_hr"$net>
</div></div>
</div></div>

_HTML_

}

#----------------------------------------
# ���OHTML�̕\���i�L�����̔����j
#----------------------------------------
sub OutHTMLSingleLogSayPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor, $modesingle) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

	# �����ƃL�����N�^�[��
	my $logpl = &GetLogPL($sow, $vil, $log);
	my $date = $sow->{'dt'}->cvtdt($log->{'date'});
	if ($vil->{'timestamp'} > 0 && ($vil->isepilogue() == 0)) {
		$date = $sow->{'dt'}->cvtdtsht($log->{'date'});
	}
	$sow->{'charsets'}->loadchrrs($logpl->{'csid'});
	my $charset = $sow->{'charsets'}->{'csid'}->{$logpl->{'csid'}};
	my $chrname = $log->{'chrname'};
	$chrname = "<a $atr_id=\"newsay\">$chrname</a>" if ($newsay > 0);

	# �N���X��
	my @messtyle = ('mes_undef', 'mes_undef', 'mes_undef', 'mes_del', 'mes_deladmin', 'mes_que', 'mes_nom', 'mes_think', 'mes_wolf', 'mes_grave', 'mes_maker', 'mes_admin', 'mes_sympa', 'mes_bat', 'mes_guest');

	# �L�����摜�A�h���X�̎擾
	my $img = &SWHtmlPC::GetImgUrl($sow, $logpl, $charset->{'FACE'}, $log->{'expression'}, $log->{'mestype'});
	# �L�����摜���Ƃ��̑����̉������擾
	my $imgwhid = 'BODY';
	$imgwhid = 'FACE' if ($charset->{'BODY'} ne '');
	my ($lwidth, $rwidth) = &SWHtmlPC::GetFormBlockWidth($sow, $charset->{"IMG$imgwhid" . 'W'});

	# ���O�ԍ�
	my $loganchor = &SWLog::GetAnchorlogID($sow, $vil, $log);
	if ($loganchor ne "") {
		$loganchor = "<span class=\"mes_number\" onclick=\"add_link('$loganchor', '$sow->{'turn'}')\">($loganchor)</span>"
	}

	# �������
	my @logmestypetexts = ('', '', '', '�y�폜�z', '�y�Ǘ��l�폜�z', '�y���m�z', '', '�y�Ɓz', '�y�ԁz', '�y��z', '', '', '�y�z', '�y�O�z', '');
	my $logmestypetext = '';
	$logmestypetext = " <span class=\"mestype\">$logmestypetexts[$log->{'mestype'}]</span>" if ($logmestypetexts[$log->{'mestype'}] ne '');

	# �������̃A���J�[���𐮌`
	&SWLog::ReplaceAnchorHTML($sow, $vil, \$log->{'log'}, $anchor);
	&SWHtml::ConvertNET($sow, \$log->{'log'});

	# ��������
	my $mes_text = 'mes_text';
	$mes_text = 'mes_text_monospace' if ((defined($log->{'monospace'})) && ($log->{'monospace'} > 0));
	$mes_text = 'mes_text_loud' if ((defined($log->{'loud'})) && ($log->{'loud'} > 0));

	# ID���J
	my $showid = '';
	$showid = " ($log->{'uid'})" if (($vil->{'showid'} > 0) || ($vil->isepilogue() == 1));

	# ���O��HTML�o��
	&OutHTMLFilterDivHeader($sow, $vil, $log, $no, $logpl, $modesingle);
	print <<"_HTML_";
<div class="message_filter">
<div class="$messtyle[$log->{'mestype'}]">
_HTML_

	# ���O�\���i��z�u�j
	print "  <h3 class=\"mesname\">$logmestypetext <a class=\"anchor\" $atr_id=\"$log->{'logid'}\">$chrname</a>$showid</h3>\n\n" if ($charset->{'LAYOUT_NAME'} eq 'top');

	# ��摜�̕\��
	print <<"_HTML_";
  <div style="float: left; width: $lwidth;">
    <div class="mes_chrimg"><img src="$img" width="$charset->{"IMG$imgwhid" . 'W'}" height="$charset->{"IMG$imgwhid" . 'H'}" alt=""$net></div>
  </div>

  <div style="float: right; width: $rwidth;">
_HTML_

	# ���O�\���i�E�z�u�j
	print "    <h3 class=\"mesname\">$logmestypetext <a class=\"anchor\" $atr_id=\"$log->{'logid'}\">$chrname</a>$showid</h3>\n" if ($charset->{'LAYOUT_NAME'} ne 'top');

	# �����̕\��
	print <<"_HTML_";
    <p class="$mes_text">$log->{'log'}</p>
  </div>

_HTML_

	# �����̍폜�{�^��
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
      <input type="submit" value="���̔������폜" class="saycancelbutton"$net>
	  (<span class="mes_fix_time">$sow->{'cfg'}->{'MESFIXTIME'}</span>�b�ȓ�)
    </p>
    </form>
    <div class="mes_date">$date</div>
  </div>

  <div>
_HTML_
	} else {

		# ���t�Ƀp�[�}�����N�t�^
		if (CanAddPermalink($sow, $vil, $log) eq 1) {
			my $reqvals = &SWBase::GetRequestValues($sow);
			my $link = &SWBase::GetLinkValues($sow, $reqvals);
			my $amp   = $sow->{'html'}->{'amp'};
			$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";
			$date = "<a href=\"$link$amp" . "logid=$log->{'logid'}\">$date</a>";
		}

		print "  <div class=\"clearboth\">\n";
		print "    <div class=\"mes_date\">$loganchor $date</div>\n";
	}

	# ��荞�݂̉���
	print <<"_HTML_";
    <hr class="invisible_hr"$net>
  </div>
</div></div>
</div></div>

_HTML_

}

#----------------------------------------
# ���OHTML�̕\���i�T�ώҁj
#----------------------------------------
sub OutHTMLSingleLogGuestPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor, $modesingle) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

  # �����ƃ��[�U�[��
	my $logpl = &GetLogPL($sow, $vil, $log);
	my $date = $sow->{'dt'}->cvtdt($log->{'date'});
	if ($vil->{'timestamp'} > 0 && ($vil->isepilogue() == 0)) {
		$date = $sow->{'dt'}->cvtdtsht($log->{'date'});
	}

	# ���t�Ƀp�[�}�����N�t�^
	if (CanAddPermalink($sow, $vil, $log) eq 1) {
		my $reqvals = &SWBase::GetRequestValues($sow);
		my $link = &SWBase::GetLinkValues($sow, $reqvals);
		my $amp   = $sow->{'html'}->{'amp'};
		$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";
		$date = "<a href=\"$link$amp" . "logid=$log->{'logid'}\">$date</a>";
	}

	$sow->{'charsets'}->loadchrrs($logpl->{'csid'});
	my $charset = $sow->{'charsets'}->{'csid'}->{$logpl->{'csid'}};
	my $chrname = $log->{'chrname'};
	$chrname = "<a $atr_id=\"newsay\">$chrname</a>" if ($newsay > 0);

	# �L�����摜�A�h���X�̎擾
	$charset = $vil->{'csid'};
	$charset = $sow->{'charsets'}->{'csid'}->{$charset};
	#my $img = "$charset->{'DIR'}/guest$charset->{'EXT'}";
	my $img = &SWHtmlPC::GetImgUrl($sow, $logpl, $charset->{'FACE'}, $log->{'expression'}, $log->{'mestype'});

	# �L�����摜���Ƃ��̑����̉������擾
	my $imgwhid = 'BODY';
	$imgwhid = 'FACE' if ($charset->{'BODY'} ne '');
	my ($lwidth, $rwidth) = &SWHtmlPC::GetFormBlockWidth($sow, $charset->{"IMG$imgwhid" . 'W'});

	# ���O�ԍ�
	my $loganchor = &SWLog::GetAnchorlogID($sow, $vil, $log);
	if ($loganchor ne "") {
		$loganchor = "<span class=\"mes_number\" onclick=\"add_link('$loganchor', '$sow->{'turn'}')\">($loganchor)</span>"
	}

	# �������̃A���J�[���𐮌`
	&SWLog::ReplaceAnchorHTML($sow, $vil, \$log->{'log'}, $anchor);
	&SWHtml::ConvertNET($sow, \$log->{'log'});

	# ��������
	my $mes_text = 'mes_text';
	$mes_text = 'mes_text_monospace' if ((defined($log->{'monospace'})) && ($log->{'monospace'} > 0));
  $mes_text = 'mes_text_loud' if ((defined($log->{'loud'})) && ($log->{'loud'} > 0));

	# ID���J
	my $showid = '';
	$showid = " ($log->{'uid'})";
	
	# �t�B���^�[�pdiv FIXME: mestype�̌��ߑł�����߂�H
	my $filter = $sow->{'filter'};
	my $mestype = '4';
	my $typefilterstyle = '';
	$typefilterstyle = ' style="display: none;"' if ((defined($filter->{'typefilter'}->[$mestype])) && ($filter->{'typefilter'}->[$mestype] eq '1'));
	if ($modesingle == 0) {
		print "<div id=\"mestype_$mestype\"$typefilterstyle>\n";
	} else {
		print "<div>\n";
	}
	
	# ���O��HTML�o��
	print <<"_HTML_";
<div class="message_filter">
<div class="mes_guest">
_HTML_

	# ���O�\���i��z�u�j
	print "  <h3 class=\"mesname\"><a class=\"anchor\" $atr_id=\"$log->{'logid'}\">$chrname</a>$showid</h3>\n\n" if ($charset->{'LAYOUT_NAME'} eq 'top');

	# ��摜�̕\��
	print <<"_HTML_";
  <div style="float: left; width: $lwidth;">
    <div class="mes_chrimg"><img src="$img" width="$charset->{"IMG$imgwhid" . 'W'}" height="$charset->{"IMG$imgwhid" . 'H'}" alt=""$net></div>
  </div>

  <div style="float: right; width: $rwidth;">
_HTML_

	# ���O�\���i�E�z�u�j
	print "    <h3 class=\"mesname\"><a class=\"anchor\" $atr_id=\"$log->{'logid'}\">$chrname</a>$showid</h3>\n" if ($charset->{'LAYOUT_NAME'} ne 'top');

	# �����̕\��
	print <<"_HTML_";
    <p class="$mes_text">$log->{'log'}</p>
  </div>
  <div class="clearboth">
    <div class="mes_date">$loganchor $date</div>
    <hr class="invisible_hr"$net>
  </div>
</div></div></div>
_HTML_

}

#----------------------------------------
# ���OHTML�̕\���i�����Đl�^�Ǘ��l�j
#----------------------------------------
sub OutHTMLSingleLogAdminPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};

	# �����ƃL�����N�^�[��
	my $chrname;
	my $curpl = $vil->getpl($log->{'uid'});
	$chrname = $log->{'chrname'};
	$chrname = "<a $atr_id=\"newsay\">$chrname</a>" if ($newsay > 0);
	my $date = $sow->{'dt'}->cvtdt($log->{'date'});
	if ($vil->{'timestamp'} > 0) {
		$date = $sow->{'dt'}->cvtdtsht($log->{'date'});
	}
	
	# ���t�Ƀp�[�}�����N�t�^
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	my $amp   = $sow->{'html'}->{'amp'};
	$link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";
	$date = "<a href=\"$link$amp" . "logid=$log->{'logid'}\">$date</a>";

	# �N���X��
	my @messtyle = ('mes_maker', 'mes_admin');

	# �������̃A���J�[���𐮌`
	&SWLog::ReplaceAnchorHTML($sow, $vil, \$log->{'log'}, $anchor);
	&SWHtml::ConvertNET($sow, \$log->{'log'});

	my $loganchor = &SWLog::GetAnchorlogID($sow, $vil, $log);
	if ($loganchor ne "") {
		$loganchor = "<span class=\"mes_number\" onclick=\"add_link('$loganchor', '$sow->{'turn'}')\">($loganchor)</span>"
	}

	# ��������
	my $mes_text = 'mes_text';
	$mes_text = 'mes_text_monospace' if ((defined($log->{'monospace'})) && ($log->{'monospace'} > 0));
  $mes_text = 'mes_text_loud' if ((defined($log->{'loud'})) && ($log->{'loud'} > 0));

	# ID���J
	my $showid = '';
	$showid = " ($log->{'uid'})" if (($vil->{'showid'} > 0) && ($log->{'mestype'} == $sow->{'MESTYPE_MAKER'}));

	# ���O��HTML�o��
	print <<"_HTML_";
<div class="message_filter">
<div class="$messtyle[$log->{'mestype'} - $sow->{'MESTYPE_MAKER'}]">
  <h3 class="mesname"><a class=\"anchor\" $atr_id="$log->{'logid'}">$chrname</a>$showid</h3>
  <p class="$mes_text">$log->{'log'}</p>
  <div class="mes_date">$loganchor $date</div>
  <hr class="invisible_hr"$net>
</div>
</div>
_HTML_

}

#----------------------------------------
# ���OHTML�̕\���i�G�s���[�O�̔z���ꗗ�j
#----------------------------------------
sub OutHTMLSingleLogCastPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor) = @_;
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $cfg   = $sow->{'cfg'};
	my $textrs = $sow->{'textrs'};
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	my $reqvals = &SWBase::GetRequestValues($sow);

	my $namelabel = '���O';
	$namelabel = "<a $atr_id=\"newsay\">$namelabel</a>" if ($newsay > 0);
	my $noselrole = "";
	$noselrole = "�i��]�͖����ł��j" if ($vil->{'noselrole'} > 0);

	print <<"_HTML_";
<table border="1" class="vindex" summary="�z���ꗗ">
<thead>

  <tr>
    <th scope="col">$namelabel</th>
    <th scope="col">ID</th>
    <th scope="col">����</th>
    <th scope="col">��E$noselrole</th>
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
		my $livetext = '����';
		$livetext = '���S' if ($_->{'live'} ne 'live');
		my $selrolename = $textrs->{'RANDOMROLE'};
		$selrolename = $textrs->{'ROLENAME'}->[$_->{'selrole'}] if ($_->{'selrole'} >= 0);
		my $roletext = "$rolename->[$_->{'role'}] ($selrolename����])";

		if ($_->{'bonds'} ne '') {
			my @bonds = split('/', $_->{'bonds'} . '/');
			$roletext .= "<br$net>" if (@bonds > 0);
			my $target;
			foreach $target (@bonds) {
				my $targetname = $vil->getplbypno($target)->getchrname();
				$roletext .= "�^�����J��$targetname<br$net>";
			}
		}

		$roletext = "$selrolename����]" if ($_->{'role'} < 0);

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
# ���OHTML�̕\���i�P���O���j
#----------------------------------------
sub OutHTMLSingleLogPC {
	my ($sow, $vil, $log, $no, $newsay, $anchor, $modesingle) = @_;

	if (($log->{'mestype'} == $sow->{'MESTYPE_INFONOM'}) || ($log->{'mestype'} == $sow->{'MESTYPE_INFOSP'})) {
		# �C���t�H���[�V����
		&OutHTMLSingleLogInfoPC($sow, $vil, $log, $no, $newsay, $anchor, $modesingle);
	} elsif ($log->{'mestype'} >= $sow->{'MESTYPE_DELETED'}) {
		if (($log->{'logsubid'} eq $sow->{'LOGSUBID_ACTION'}) || ($log->{'logsubid'} eq $sow->{'LOGSUBID_BOOKMARK'})) {
			# �A�N�V�����^������
			&OutHTMLSingleLogActionPC($sow, $vil, $log, $no, $newsay, $anchor, $modesingle);
		} elsif (($log->{'mestype'} == $sow->{'MESTYPE_MAKER'}) || ($log->{'mestype'} == $sow->{'MESTYPE_ADMIN'})) {
			&OutHTMLSingleLogAdminPC($sow, $vil, $log, $no, $newsay, $anchor, $modesingle);
    } elsif ($log->{'mestype'} == $sow->{'MESTYPE_GUEST'}) {
			&OutHTMLSingleLogGuestPC($sow, $vil, $log, $no, $newsay, $anchor, $modesingle);
		} elsif ($log->{'mestype'} >= $sow->{'MESTYPE_CAST'}) {
			# �z���ꗗ
			&OutHTMLSingleLogCastPC($sow, $vil, $log, $no, $newsay, $anchor, $modesingle);
		} else {
			# �L�����N�^�[����
			&OutHTMLSingleLogSayPC($sow, $vil, $log, $no, $newsay, $anchor, $modesingle);
		}
	}
}

#----------------------------------------
# �t�B���^�pdiv�J�n�^�O�̏o��
#----------------------------------------
sub OutHTMLFilterDivHeader {
	my ($sow, $vil, $log, $no, $logpl, $modesingle) = @_;
	my $filter = $sow->{'filter'};
	my $pnofilterstyle = '';
	my $typefilterstyle = '';

	my $logpno = 'X';
	# �l�t�B���^����
	if (($logpl->{'pno'} >= 0) && ($logpl->{'entrieddt'} <= $log->{'date'})) {
		# ���𔲂��Ă��Ȃ��l�̓t�B���^�̑Ώ�
		$logpno = $logpl->{'pno'};
		$pnofilterstyle = ' style="display: none;"' if ((defined($filter->{'pnofilter'}->[$logpno])) && ($filter->{'pnofilter'}->[$logpno] eq '1'));
	}

	# ������ʃt�B���^����
	my $mestype = $sow->{'MESTYPE2TYPEID'}->[$log->{'mestype'}];
	if ($mestype >= 0) {
		$typefilterstyle = ' style="display: none;"' if ((defined($filter->{'typefilter'}->[$mestype])) && ($filter->{'typefilter'}->[$mestype] eq '1'));
	}

	# �v���r���[�̎��̓t�B���^�𖳌�
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
# �w�肵�����O�̔����҃f�[�^�̎擾
#----------------------------------------
sub GetLogPL {
	my ($sow, $vil, $log) = @_;
	my $logpl;
	my $pl = $vil->getpl($log->{'uid'});

	if ((!defined($pl->{'cid'})) || ($pl->{'entrieddt'} > $log->{'date'})) {
		# ���𔲂��Ă���v���C���[
		my %logplsingle = (
			cid       => $log->{'cid'},
			csid      => $log->{'csid'},
			pno       => -1,
			deathday  => -1,
			entrieddt => -1,
		);
		$logpl = \%logplsingle;
	} else {
		# ���ɂ���v���C���[
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

#----------------------------------------
# �p�[�}�����N��\�����Ă��悢���ǂ���
#----------------------------------------
sub CanAddPermalink {
	my ($sow, $vil, $log) = @_;
	my $result = 1;
	if ($vil->isepilogue() eq 1) {
		$result = 1;
	} else {
		if ($log->{'mestype'} eq $sow->{'MESTYPE_TSAY'} || 
				$log->{'mestype'} eq $sow->{'MESTYPE_QUE'} || 
				$log->{'logid'} eq $sow->{'PREVIEW_LOGID'}) {
					$result = 0;
				}
	}
	return $result;
}

1;
