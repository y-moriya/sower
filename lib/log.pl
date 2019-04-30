package SWLog;

#----------------------------------------
# �����֘A���C�u����
#----------------------------------------

#----------------------------------------
# ���OID�̐���
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
# ���OID��z��ɕ������ĕԂ�
#----------------------------------------
sub GetLogIDArray {
	my $logmestype = substr($_[0]->{'logid'}, 0, 1);
	my $logsubid = substr($_[0]->{'logid'}, 1, 1);
	my $logcnt = substr($_[0]->{'logid'}, 2);

	return ($logmestype, $logsubid, $logcnt);
}

#----------------------------------------
# �A���J�[�p�̃��O�ԍ����擾
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
# �A���J�[������f�[�^�`���ɕϊ�(�v���r���[��p)
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

		# ���OID�̐���
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

		# �����N�̕�����p�f�[�^
		my $linktext = $anchortext;
		$linktext =~ s/&gt;&gt;//;

		my $mwtag = "<mw $logid,$turn,$linktext>";
		my $skipmwtag = $anchortext;
		$skipmwtag =~ s/&gt;&gt;/<mw>/;

		# ���K�\���ł̌�F����h��
		&BackQuoteAnchorMark(\$anchortext);

		# �ϊ�
		$mes =~ s/$anchortext/$mwtag/;
	}
	$mes =~ s/<mw>/&gt;&gt;/g;

	return $mes;
}

#----------------------------------------
# �A���J�[������f�[�^�`���ɕϊ�
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

		# ���OID�̐���
		$mestypestr = '' if (!defined($mestypestr));
		my $mestype = $sow->{'MESTYPE_SAY'};
		my $logmestype = $sow->{'LOGMESTYPE'};
		my $loganchormark = $sow->{'MARK_LOGANCHOR'};
		my $i;
		for ($i = $sow->{'MESTYPE_SAY'}; $i <= $sow->{'MESTYPE_GUEST'}; $i++) {
			$mestype = $i if ($mestypestr eq $loganchormark->{$logmestype->[$i]});
		}

		my $logsubid = $sow->{'LOGSUBID_SAY'};
#		$logsubid = $sow->{'LOGSUBID_ACTION'} if (defined($2) && ($2 eq $sow->{'LOGSUBID_ACTION'})); # �Ăւ���i����
		my $logid = &CreateLogID($sow, $mestype, $logsubid, $logno);

		# �����N�̕�����p�f�[�^
		my $linktext = $anchortext;
		$linktext =~ s/&gt;&gt;//;

		my $mwtag = "<mw $logid,$turn,$linktext>";
		my $skipmwtag = $anchortext;
		$skipmwtag =~ s/&gt;&gt;/<mw>/;

		# �Ó����`�F�b�N
		my $saymestype = $say->{'mestype'};
		$saymestype = $sow->{'MESTYPE_SAY'} if ($saymestype == $sow->{'MESTYPE_QUE'});
		my $rolesay = $sow->{'textrs'}->{'CAPTION_ROLESAY'};
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "�閧��b�ւ̃A���J�[��ʏ픭���ɑł��͂ł��܂���B","cannot anchor [$mestype].") if (($vil->isepilogue() == 0) && ($saymestype == $sow->{'MESTYPE_SAY'}) && (($mestype == $sow->{'MESTYPE_WSAY'}) || ($mestype == $sow->{'MESTYPE_SPSAY'}) || ($mestype == $sow->{'MESTYPE_BSAY'})));

		$mwtag = $skipmwtag if (($mestypemark1 ne '') && ($mestypemark2 ne '')); # ��ʎw�肪�Q����
		if (($mestype != $sow->{'MESTYPE_SAY'}) && ($mestype != $sow->{'MESTYPE_MAKER'}) && ($mestype != $sow->{'MESTYPE_ADMIN'}) && ($mestype != $sow->{'MESTYPE_GUEST'})) {
			if ($vil->isepilogue() == 0) {
				# �i�s��

				# �扺�Ƃ茾����扺�ւ̃A���J�[�`�F�b�N
				my $tsay2gsay = 1;
				$tsay2gsay = 0 if ($sow->{'cfg'}->{'ENABLED_TSAY_GRAVE'} == 0); # �扺�Ƃ茾�֎~
				$tsay2gsay = 0 if ($mestype != $sow->{'MESTYPE_GSAY'}); # �A���J�[�悪�扺�ł͂Ȃ�
				$tsay2gsay = 0 if ($saymestype != $sow->{'MESTYPE_TSAY'}); # �A���J�[�����Ƃ茾�ł͂Ȃ�
				$tsay2gsay = 0 if ($saypl->{'live'} eq 'live'); # �܂�������

				$mwtag = $skipmwtag if (($mestype ne $saymestype) && ($tsay2gsay == 0)); # �قȂ�mestype�ւ͒���Ȃ�
				$mwtag = $skipmwtag if ($mestype == $sow->{'MESTYPE_TSAY'}); # �Ƃ茾�ւ͒���Ȃ�
				$mwtag = $skipmwtag if ($turn == 0); # �v�����[�O�̚����^�Ƃ茾�^�扺�ւ͒���Ȃ�
			} else {
				# �G�s���[�O��
				# ���ꂢ��Ȃ��ˁH
				#$mwtag = $skipmwtag if ($turn == $vil->{'turn'}); # �����͒ʏ픭���ȊO�ɒ���Ȃ�
				#$mwtag = $skipmwtag if (($turn == 0) && ($mestype != $sow->{'MESTYPE_TSAY'})); # �v�����[�O�ւ͒ʏ픭���ƓƂ茾�ȊO����Ȃ�
				#$mwtag = $skipmwtag if (($turn == 0) && ($sow->{'cfg'}->{'ENABLED_TSAY_PRO'} == 0)); # �Ƃ茾���v�����[�O�ł��ݒ�ŋ֎~���Ă����璣��Ȃ�
			}
		}

		# ���K�\���ł̌�F����h��
		&BackQuoteAnchorMark(\$anchortext);

		# �ϊ�
		$mes =~ s/$anchortext/$mwtag/;
	}
	$mes =~ s/<mw>/&gt;&gt;/g;

	return $mes;
}

#----------------------------------------
# �����f�[�^�`���̃A���J�[��HTML�ɐ��`
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

		# ���K�\���ł̌�F����h��
		&BackQuoteAnchorMark(\$anchortext);

		$$mes =~ s/$anchortext/<a href=\"$link\" class=\"res_anchor\"$blank>&gt;&gt;$linktext<\/a>/;
	}

	return $mes;
}

#----------------------------------------
# �|�b�v�A�b�v�A���J�[
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
# �����f�[�^�`���̃A���J�[��HTML�ɐ��`�i���o�C���p�j
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

		# ���K�\���ł̌�F����h��
		&BackQuoteAnchorMark(\$anchortext);

		$mes =~ s/$anchortext/<a href=\"$link\">&gt;&gt;$linktext<\/a>/;
	}

	return $mes;
}

#----------------------------------------
# �����f�[�^�`���̃A���J�[���e�L�X�g�ɐ��`�iRSS�����j
# �������� $anchor �͖��g�p
#----------------------------------------
sub ReplaceAnchorHTMLRSS {
	my ($sow, $vil, $mes, $anchor) = @_;
	my $cfg = $sow->{'cfg'};

	while ($mes =~ /<mw ([a-zA-Z]+\d+),([^,]*),([^>]+)>/) {
		my $anchortext = $&;
		my $linktext = $3;

		# ���K�\���ł̌�F����h��
		&BackQuoteAnchorMark(\$anchortext);

		$mes =~ s/$anchortext/&gt;&gt;$linktext/;
	}
	$mes =~ s/<(\/)?strong>//g;
	$mes =~ s/\'/\\\'/g;

	return $mes;
}

#----------------------------------------
# ���K�\���ł̌�F����h�����ߋL����ϊ�
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
# �����_���\���@�\
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
