package SWHtmlVlogMb;

#----------------------------------------
# �����O�\���i�g�у��[�h�j��HTML�o��
#----------------------------------------
sub OutHTMLVlogMb {
	my ($sow, $vil, $logfile, $maxrow, $logs, $logkeys, $rows) = @_;

	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $cfg = $sow->{'cfg'};

	# ��d�������ݒ���
	if ($sow->{'query'}->{'cmd'} ne '') {
		print <<"_HTML_";
<font color="red">����d�������ݒ��Ӂ�</font><br$net>
�����[�h����ꍇ�́u�V�v���g���ĉ������B
<hr$net>
_HTML_
	}

	# �����y�у����N�\��
	print "<a $atr_id=\"top\">$sow->{'query'}->{'vid'} $vil->{'vname'}</a><br$net>\n";

	# �L�������\��
	if (defined($sow->{'curpl'}->{'uid'})) {
		my $chrname = $sow->{'curpl'}->getchrname();
		my $rolename = '';
		$rolename = "($sow->{'textrs'}->{'ROLENAME'}->[$sow->{'curpl'}->{'role'}])" if ($sow->{'curpl'}->{'role'} >= 0);
		my $markbonds = '';
		$markbonds = " ��$sow->{'textrs'}->{'MARK_BONDS'}" if ($sow->{'curpl'}->{'bonds'} ne '');
		print "$chrname$rolename$markbonds<br$net>\n";
	}

#	my $list = $logfile->{'logindex'}->{'file'}->getlist();
	my $list = $logfile->getlist();
	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 0, $logs, $list, $rows);

	if (defined($sow->{'curpl'}->{'uid'})) {
		if (($vil->{'turn'} == 0) && ($sow->{'curpl'}->{'limitentrydt'} > 0)) {
			my $limitdate = $sow->{'dt'}->cvtdt($sow->{'curpl'}->{'limitentrydt'});
			print <<"_HTML_";
<font color="red">$limitdate�܂łɈ�x���������������J�n����Ȃ������ꍇ�A���Ȃ��͎����I�ɑ�����ǂ��o����܂��B</font>
<hr$net>
_HTML_
		}
	}

	if (($sow->{'turn'} == $vil->{'turn'}) && ($vil->{'epilogue'} < $vil->{'turn'})) {
		# �I���\��
		print "<p>�I�����܂����B</p>\n\n";

	} else {
		# �����O�\��
		my $order = $sow->{'query'}->{'order'};
		my %anchor = (
			logfile => $logfile,
			logkeys => $logkeys,
			rowover => $rows->{'rowover'},
		);

		if (($order eq 'desc') || ($order eq 'd')){
			# �~��
			my $i;
			for ($i = $#$logs; $i >= 0; $i--) {
				next if (!defined($logs->[$i]->{'pos'}));
				my $log = $logfile->{'logfile'}->{'file'}->read($logs->[$i]->{'pos'});
				&OutHTMLSingleLogMb($sow, $vil, $log, \%anchor);
			}
		} else {
			# ����
			foreach (@$logs) {
				next if (!defined($_->{'pos'}));
				my $log = $logfile->{'logfile'}->{'file'}->read($_->{'pos'});
				&OutHTMLSingleLogMb($sow, $vil, $log, \%anchor);
			}
		}

		if ($sow->{'turn'} == $vil->{'turn'}) {
			# �ŐV���\����

			# ���Q���^�����O�C�����A�i�E���X
			if (($vil->{'turn'} == 0) && ($sow->{'user'}->logined() <= 0)){
				print <<"_HTML_";
<p>
���������L�����N�^�[��I�сA�������Ă��������B<br$net>
</p>

<p>
���[�����悭����������ł��Q���������B<br$net>
����]�\\�͂ɂ��Ă̔����͍T���Ă��������B
</p>

_HTML_
			}

			my $nosaytext = &SWHtmlVlog::GetNoSayListText($sow, $vil, $pl, $plid);
			if (($vil->{'turn'} != 0) && ($vil->isepilogue() == 0) && ($nosaytext ne '')) {
				# �������҃��X�g�̕\��
				print "<p>$nosaytext</p>\n<hr$net>\n\n";
			}
		}
	}

	&SWHtmlMb::OutHTMLTurnNaviMb($sow, $vil, 1, $logs, $list, $rows);

	return;
}

#----------------------------------------
# ���OHTML�̕\���i�P���O���j
#----------------------------------------
sub OutHTMLSingleLogMb {
	my ($sow, $vil, $log, $logkeys) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $textrs = $sow->{'textrs'};

	if ($log->{'mestype'} == $sow->{'MESTYPE_INFONOM'}) {
		# �C���t�H���[�V����
		print <<"_HTML_";
<font color="maroon">$log->{'log'}</font>
<hr$net>
_HTML_
	} elsif ($log->{'mestype'} == $sow->{'MESTYPE_INFOSP'}) {
		# ���ӕ\��
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
			# �A�N�V����
			# �������̃A���J�[�𐮌`
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
$actcolorbegin$logmestypetext[$log->{'mestype'}]$log->{'chrname'}�́A$mes$actcolorend
_HTML_
			print "$date<br$net>\n" if ($log->{'logsubid'} ne $sow->{'LOGSUBID_BOOKMARK'});
		} elsif ($log->{'mestype'} >= $sow->{'MESTYPE_CAST'}) {
			# �z���ꗗ
			my $rolename = $sow->{'textrs'}->{'ROLENAME'};
			my $pllist = $vil->getpllist();
			foreach (@$pllist) {
				my $chrname = $_->getchrname();
				my $livetext = '����';
				$livetext = '���S' if ($_->{'live'} ne 'live');
				my $selrolename = $textrs->{'RANDOMROLE'};
				$selrolename = $textrs->{'ROLENAME'}->[$_->{'selrole'}] if ($_->{'selrole'} >= 0);
				my $roletext = "$rolename->[$_->{'role'}]������($selrolename����])�B";
				$roletext .= " ��$sow->{'textrs'}->{'MARK_BONDS'}" if ($_->{'bonds'} ne '');
				$roletext = "$selrolename����]���Ă����B" if ($_->{'role'} < 0);
				print <<"_HTML_";
<font color="maroon">$chrname ($_->{'uid'})�A$livetext�B$roletext</font><br$net>
_HTML_
			}
		} else {
			# �L�����N�^�[�̔���
			my @logmestypetext = ('', '', '', '�y�폜�z', '�y�Ǘ��l�폜�z', '�y���m�z', '�y�l�z', '�y�Ɓz', '�y�ԁz', '�y��z', '', '', '�y�z', '�y�O�z');

			# �����F
			my @logcolor = ('', '', '', 'gray', 'gray', '', '', 'gray', 'red', 'blue', '', '', 'green', 'purple');

			# �������̃A���J�[�𐮌`
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

			# �L�����摜�A�h���X�̎擾
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
			$loud = "�i�吺�j<br$net>" if ($log->{'loud'} > 0);

			print <<"_HTML_";
$colorstart$logmestypetext[$log->{'mestype'}]<a $atr_id="$log->{'logid'}">$log->{'chrname'}</a>$showid $date$loganchor<br$net>
$img
$loud$mes<br$net>$colorend
_HTML_

			if ($log->{'mestype'} == $sow->{'MESTYPE_QUE'}) {
				# �����P��{�^���̕\��
				my ($logmestype, $logsubid, $logcnt) = &SWLog::GetLogIDArray($log);
				$sow->{'query'}->{'cmd'} = 'cancel';
				my $reqvals = &SWBase::GetRequestValues($sow);
				my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '');

				print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
<input type="hidden" name="cmd" value="cancel">
<input type="hidden" name="queid" value="$logcnt">$hidden
<input type="submit" value="�폜($sow->{'cfg'}->{'MESFIXTIME'}�b�ȓ�)">
</form>
_HTML_
			}
		}
		print "<hr$net>\n";
	}
}

#----------------------------------------
# �g�їp��O���t�B�b�N��HTML�o��
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
<!--���u�L�����̖��O�v�̊�摜<br>-->
<img src="$img"><br>
�g�т̋@��ɂ���Ă͕\\������Ȃ��ꍇ������܂��B<br>
�g�т̃L�[����Ō��̉�ʂɖ߂��Ă��������B
<hr>

_HTML_
}

1;
