package SWCmdVote;

#----------------------------------------
# ���[�^�\�͑Ώېݒ�
#----------------------------------------
sub CmdVote {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# �f�[�^����
	my $vil = &SetDataCmdVote($sow);

	# HTTP/HTML�o��
	if ($sow->{'outmode'} eq 'mb') {
		require "$sow->{'cfg'}->{'DIR_LIB'}/cmd_wrformmb.pl";
		&SWCmdWriteFormMb::CmbWriteFormMb($sow);
	} else {
		my $reqvals = &SWBase::GetRequestValues($sow);
		my $link = &SWBase::GetLinkValues($sow, $reqvals);
		$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

		$sow->{'http'}->{'location'} = "$link";
		$sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
		$sow->{'http'}->outfooter();
	}
}

#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdVote {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $cmd = $query->{'cmd'};

	# ���f�[�^�̓ǂݍ���
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# ���\�[�X�̓ǂݍ���
	&SWBase::LoadVilRS($sow, $vil);

	# ���[�^�\�͑Ώېݒ�
	my $targetid = 'target';
	$targetid = 'vote' if ($cmd eq 'vote');
	my $curpl = $sow->{'curpl'};

	# �����O�֘A��{���͒l�`�F�b�N
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_vil.pl";
	&SWValidityVil::CheckValidityVil($sow, $vil);

	$debug->raise($sow->{'APLOG_CAUTION'}, "���Ȃ��͊��Ɏ���ł��܂��B", "you're dead.") if ($curpl->{'live'} ne 'live'); # �ʏ�N���Ȃ�
	&CheckValidityTarget($sow, $vil, 'target');

	# �K��O�N�G���f�[�^�[����i���肵�Ȃ��Ə����Ƀ_�~�[�ȊO���P���ł���̂Ń`�F�b�N�j
	my $targetlist = $curpl->gettargetlistwithrandom($cmd);
	my $is_valid_target = 0;
	foreach (@$targetlist) {
		if( $query->{'target'} == $_->{'pno'}) {
			$is_valid_target = 1;
		}
	}
	$debug->raise($sow->{'APLOG_CAUTION'}, "�Ώۂ��s���ł��B", "invalid target.") if ($is_valid_target == 0);	# �i�t�H�[�������������łȂ�����j�ʏ�N���Ȃ�

	if (($curpl->{'role'} == $sow->{'ROLEID_TRICKSTER'}) && ($targetid ne 'vote')) {
		&CheckValidityTarget($sow, $vil, 'target2');
		$debug->raise($sow->{'APLOG_CAUTION'}, "�ΏۂP�ƑΏۂQ�������l�ł��B", "same both target.") if (($query->{'target'} == $query->{'target2'}) && ($query->{'target'} >= 0));
	}

	if ($targetid eq 'vote') {
		$debug->raise($sow->{'APLOG_CAUTION'}, "�����͓��[�ł�����ł͂���܂���B", "cannot vote.") if (($vil->{'turn'} < 2) || ($vil->isepilogue() > 0)); # �ʏ�N���Ȃ�
	} else {
		$debug->raise($sow->{'APLOG_CAUTION'}, "�����͔\\�͑Ώۂ�ݒ�ł�����ł͂���܂���B", "cannot set target.") if (($vil->{'turn'} == 0) || ($vil->isepilogue() > 0)); # �ʏ�N���Ȃ�
		$debug->raise($sow->{'APLOG_CAUTION'}, "�����͔\\�͑Ώۂ�ݒ�ł�����ł͂���܂���B", "cannot set target.[roleid=guard]") if (($curpl->{'role'} eq $sow->{'ROLEID_GUARD'}) && ($vil->{'turn'} == 1)); # �ʏ�N���Ȃ�
		$debug->raise($sow->{'APLOG_CAUTION'}, "�����͔\\�͑Ώۂ�ݒ�ł�����ł͂���܂���B", "cannot set target.[roleid=trickster]") if (($curpl->{'role'} eq $sow->{'ROLEID_TRICKSTER'}) && ($vil->{'turn'} != 1)); # �ʏ�N���Ȃ�
	}

	my $savepno = $curpl->{$targetid};
	my $saveentrust = $curpl->{'entrust'};
	$curpl->{$targetid} = $query->{'target'};
	my $modifiedtarget2 = 0;
	if (($curpl->{'role'} == $sow->{'ROLEID_TRICKSTER'}) && ($cmd ne 'vote')) {
		if ($curpl->{'target2'} != $query->{'target2'}) {
			$curpl->{'target2'} = $query->{'target2'};
			$modifiedtarget2 = 1;
		}
	}
	if ($cmd eq 'vote') {
		# �ϔC
		$curpl->{'entrust'} = 0;
		$curpl->{'entrust'} = 1 if ($query->{'entrust'} ne '');
	}
	$curpl->{'modified'} = $sow->{'time'} if (($savepno != $curpl->{$targetid}) || ($modifiedtarget2 > 0) || ($saveentrust != $curpl->{'entrust'}));
	$vil->writevil();

	# ���[�^�\�͑ΏەύX����𑺃��O�֏�������
	if (($sow->{'cfg'}->{'ENABLED_PLLOG'} > 0) && (($savepno != $curpl->{$targetid}) || ($modifiedtarget2 > 0) || ($saveentrust != $curpl->{'entrust'}))) {
		require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
		require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";

		# ���O�f�[�^�t�@�C�����J��
		my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);

		# �������ݕ��̐���
		my $textrs = $sow->{'textrs'};
		my $mes;
		if ($cmd eq 'vote') {
			if ($query->{'entrust'} eq '') {
				$mes = $textrs->{'ANNOUNCE_SETVOTE'};
			} else {
				$mes = $textrs->{'ANNOUNCE_SETENTRUST'};
			}
		} else {
			$mes = $textrs->{'ANNOUNCE_SETTARGET'};
		}

		my $curplchrname = $curpl->getchrname();
		$mes =~ s/_NAME_/$curplchrname/g;
		$mes =~ s/_ABILITY_/$textrs->{'ABI_ROLE'}->[$curpl->{'role'}]/g;
		my $targetpl = $vil->getplbypno($curpl->{$targetid});
		my $targetname;
		if ($curpl->{$targetid} >= 0) {
			$targetname = $targetpl->getchrname();
		} elsif ($curpl->{$targetid} == $sow->{'TARGETID_RANDOM'}) {
			$targetname = $textrs->{'RANDOMTARGET'};
		} else {
			$targetname = $textrs->{'UNDEFTARGET'};
		}
		if (($curpl->{'role'} == $sow->{'ROLEID_TRICKSTER'}) && ($cmd ne 'vote')) {
			if ($curpl->{'target2'} == $sow->{'TARGETID_RANDOM'}) {
				$targetname .= ' �� ' . $textrs->{'RANDOMTARGET'};
			} else {
				my $target2pl = $vil->getplbypno($curpl->{'target2'});
				$targetname .= ' �� ' . $target2pl->getchrname();
			}
		}
		$mes =~ s/_TARGET_/$targetname/g;

		# ��������
		$logfile->writeinfo($curpl->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $mes);
		$logfile->close();
	}
	$vil->closevil();

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Set Vote/Skill. [uid=$sow->{'uid'}, vid=$vil->{'vid'}, action=$targetid]");

	return $vil;
}

#----------------------------------------
# ���[�^�\�͑Ώۃ`�F�b�N
#----------------------------------------
sub CheckValidityTarget {
	my ($sow, $vil, $targetid) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	my $debug = $sow->{'debug'};
	my $curpl = $sow->{'curpl'};

	$debug->raise($sow->{'APLOG_CAUTION'}, "�Ώۂ��s���ł��B", "no target.") if (!defined($query->{$targetid}));

	my $targetpl;
	$targetpl = $vil->getplbypno($query->{$targetid}) if ($query->{$targetid} >= 0);

	$debug->raise($sow->{'APLOG_CAUTION'}, "�Ώۂ��s���ł��B", "invalid target.") if ($query->{$targetid} < $sow->{'TARGETID_RANDOM'});
	$debug->raise($sow->{'APLOG_CAUTION'}, "�Ώۂ��s���ł��B", "invalid target.[cannot random]") if (($query->{$targetid} == $sow->{'TARGETID_RANDOM'}) && ($vil->{'randomtarget'} == 0)); # �����_���Ώ�

	if (($targetid ne 'target') || ($curpl->iswolf() == 0)) {
		if (($query->{$targetid} != $sow->{'TARGETID_RANDOM'}) || ($vil->{'randomtarget'} == 0)) {
			# ���݂��Ȃ��v���C���[�ԍ��^�����_���֎~���̃����_���Ώہ^�P����ȊO�̂��܂���
			# �ʏ�N���Ȃ�
			$debug->raise($sow->{'APLOG_CAUTION'}, "�Ώۂ��s���ł��B", "invalid target.") if (!defined($targetpl->{'uid'}));
		}
	}

	$debug->raise($sow->{'APLOG_CAUTION'}, "�ΏۂɎ����͑I�ׂ܂���B","target is you.") if ((defined($targetpl->{'pno'})) && ($sow->{'curpl'}->{'pno'} == $targetpl->{'pno'})); # �ʏ�N���Ȃ�
	$debug->raise($sow->{'APLOG_CAUTION'}, "�ΏۂɃ_�~�[�L�����͑I�ׂ܂���B","target is dummy.") if (($curpl->{'role'} == $sow->{'ROLEID_TRICKSTER'}) &&(defined($targetpl->{'pno'})) && ($targetpl->{'pno'} == 0)); # �ʏ�N���Ȃ�
	$debug->raise($sow->{'APLOG_CAUTION'}, "�Ώۂ͊��Ɏ���ł��܂��B", "target is dead.") if ((defined($targetpl->{'live'})) && ($targetpl->{'live'} ne 'live')); # �ʏ�N���Ȃ�

}

1;