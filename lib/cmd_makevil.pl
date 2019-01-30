package SWCmdMakeVil;

#----------------------------------------
# ���쐬
#----------------------------------------
sub CmdMakeVil {
	my $sow = $_[0];

	# ���쐬���l�`�F�b�N
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_makevil.pl";
	&SWValidityMakeVil::CheckValidityMakeVil($sow);

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();
	my $vcnt = $vindex->getactivevcnt();
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "���݉ғ����̑��̐�������ɒB���Ă���̂ŁA�����쐬�ł��܂���B", "too many villages.") if ($vcnt >= $sow->{'cfg'}->{'MAX_VILLAGES'});
	$vindex->closevindex();

	# ���쐬����
	my $vil = &SetDataCmdMakeVil($sow);

	# HTML�o��
	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_makevil.pl";
	&SWHtmlMakeVil::OutHTMLMakeVil($sow, $vil);
}

#----------------------------------------
# ���쐬����
#----------------------------------------
sub SetDataCmdMakeVil {
	my $sow   = $_[0];
	my $query = $sow->{'query'};

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_sowgrobal.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";

	# �L�����Z�b�g�̐ݒ�
	my $csids = $query->{'csid'};
	my $trsid = $sow->{'cfg'}->{'DEFAULT_TEXTRS'};
	$trsid = $query->{'trsid'} if (defined($query->{'trsid'}));

	# �Ǘ��f�[�^���瑺�ԍ����擾
	my $sowgrobal = SWFileSWGrobal->new($sow);
	$sowgrobal->openmw();
	$sowgrobal->{'vlastid'}++;

	# ���f�[�^�̍쐬
	$query->{'vid'} = $sowgrobal->{'vlastid'};

	my $vil = SWFileVil->new($sow, $sowgrobal->{'vlastid'});
	$vil->createvil();

	$vil->{'vname'}        = $query->{'vname'};
	$vil->{'vcomment'}     = $query->{'vcomment'};
	$vil->{'vcomment'}     = $sow->{'basictrs'}->{'NONE_TEXT'} if ($vil->{'vcomment'} eq '');
	$vil->{'makeruid'}     = $query->{'makeruid'};
	$vil->{'trsid'}        = $trsid;
	$vil->{'csid'}         = $csids;
	$vil->{'roletable'}    = $query->{'roletable'};
	$vil->{'updhour'}      = $query->{'hour'};
	$vil->{'updminite'}    = $query->{'minite'};
	$vil->{'updinterval'}  = $query->{'updinterval'};
	$vil->{'vplcnt'}       = $query->{'vplcnt'};
	$vil->{'entrylimit'}   = $query->{'entrylimit'};
	$vil->{'entrypwd'}     = $query->{'entrypwd'};
	$vil->{'rating'}       = $query->{'rating'};

	$vil->{'vplcntstart'}  = $query->{'vplcntstart'};
	$vil->{'vplcntstart'}  = 0 if (!defined($vil->{'vplcntstart'}));
	$vil->{'saycnttype'}   = $query->{'saycnttype'};
	$vil->{'nextupdatedt'} = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, 1, 0);
	$vil->{'nextchargedt'} = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, 1, 0);
	$vil->{'scraplimitdt'} = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, $sow->{'cfg'}->{'TIMEOUT_SCRAP'}, 1);

	$vil->{'votetype'}     = $query->{'votetype'};
	$vil->{'starttype' }   = $query->{'starttype'};
	$vil->{'randomtarget'} = 0;
	$vil->{'randomtarget'} = 1 if (($sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0) && ($query->{'randomtarget'} ne ''));
	$vil->{'noselrole'}    = 0;
	$vil->{'noselrole'}    = 1 if ($query->{'noselrole'} ne '');
	$vil->{'makersaymenu'} = 0;
	$vil->{'makersaymenu'} = 1 if ($query->{'makersaymenu'} ne '');
	$vil->{'entrustmode'}  = 0;
	$vil->{'entrustmode'}  = 1 if ($query->{'entrustmode'} ne '');
	$vil->{'showall'}      = 0;
	$vil->{'showall'}      = 1 if ($query->{'showall'} ne '');
	$vil->{'noactmode'}    = $query->{'noactmode'};
	$vil->{'nocandy'}      = 0;
	$vil->{'nocandy'}      = 1 if ($query->{'nocandy'} ne '');
	$vil->{'nofreeact'}    = 0;
	$vil->{'nofreeact'}    = 1 if ($query->{'nofreeact'} ne '');
	$vil->{'showid'}       = 0;
	$vil->{'showid'}       = 1 if ($query->{'showid'} ne '');
	$vil->{'timestamp'}    = 0;
	$vil->{'timestamp'}    = 1 if ($query->{'timestamp'} ne '');
	
	my $roleid = $sow->{'ROLEID'};
	for ($i = 1; $i < @$roleid; $i++) {
		my $countrole = 0;
		$countrole = $query->{"cnt$roleid->[$i]"} if (defined($query->{"cnt$roleid->[$i]"}));
		$vil->{"cnt$roleid->[$i]"} = int($countrole);
	}

	# �L�����Z�b�g�̓ǂݍ���
	my @csids = split('/', $csids);
	my $csid = $csids[0];
	foreach (@csids) {
		$sow->{'charsets'}->loadchrrs($_);
	}
	my $charset = $sow->{'charsets'}->{'csid'}->{$csid};
	&SWBase::LoadTextRS($sow, $vil);
	my $textrs = $sow->{'textrs'};

	# �_�~�[�L�����f�[�^�쐬
	my $plsingle = SWPlayer->new($sow);
	$plsingle->createpl($sow->{'cfg'}->{'USERID_NPC'});
	$plsingle->{'cid'}      = $charset->{'NPCID'};
	$plsingle->{'csid'}     = $csid;
	$plsingle->{'role'}     = -1;
	$plsingle->{'selrole'}  = $sow->{'ROLEID_VILLAGER'};

	$vil->addpl($plsingle); # ���֒ǉ�
	$plsingle->setsaycount(); # ������������

	# �Ǘ��f�[�^�̏�������
	$sowgrobal->writemw();
	$sowgrobal->closemw();

	# ���O�f�[�^�E�����f�[�^�t�@�C���̍쐬
	my $logfile  = SWBoa->new($sow, $vil, $vil->{'turn'}, 1);
	my $memofile = SWSnake->new($sow, $vil, $vil->{'turn'}, 1);

	# �v�����[�O�A�i�E���X
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $textrs->{'ANNOUNCE_FIRST'}->[0]);

	# �_�~�[�L�����Q��
	my %entry = (
		pl         => $plsingle,
		mes        => $charset->{'NPCSAY'}->[0],
		expression => 0,
		monospace  => 0,
		loud       => 0,
		npc        => 1,
	);
	$logfile->entrychara(\%entry);
	$plsingle->{'saidcount'}++;
	$logfile->close();
	$vil->writevil(); # ���f�[�^�̏�������
	$vil->closevil();

	# ���ꗗ�f�[�^�̍X�V
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();
	$vindex->addvindex($vil);
	$vindex->writevindex();
	$vindex->closevindex();

	# �l�T���o�͗p�t�@�C���̍쐬
	if ($sow->{'cfg'}->{'ENABLED_SCORE'} > 0) {
		require "$sow->{'cfg'}->{'DIR_LIB'}/score.pl";
		my $score = SWScore->new($sow, $vil, 1);
		$score->close();
	}

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Make Vil. [uid=$sow->{'uid'}]");

	return;
}

1;