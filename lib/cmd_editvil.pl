package SWCmdEditVil;

#----------------------------------------
# ���ҏW�����\��
#----------------------------------------
sub CmdEditVil {
	my $sow = $_[0];

	# ���ҏW����
	my $vil = &SetDataCmdEditVil($sow);

	# HTML�o��
	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_makevil.pl";
	&SWHtmlMakeVil::OutHTMLMakeVil($sow, $vil);
}

#----------------------------------------
# ���ҏW����
#----------------------------------------
sub SetDataCmdEditVil {
	my $sow  = $_[0];
	my $query  = $sow->{'query'};
	my $net = $sow->{'html'}->{'net'};

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";

	# ���f�[�^�̓ǂݍ���
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# �i�s���̕ҏW�s��
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '�����J�n���Ă��܂��B', "game started.") unless ($vil->isprologue()>0);
	
	my @villabel = &SWFileVil::GetVilDataLabel();
	my $oldinfo;
	foreach (@villabel) {
		$oldinfo{$_} = $vil->{$_};
		last if ($_ eq 'timestamp');
	}
	# ���ҏW���l�`�F�b�N
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_makevil.pl";
	&SWValidityMakeVil::CheckValidityMakeVil($sow);

	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "���쐬�҈ȊO�ɂ͑��̕ҏW�͍s���܂���B", "no permition.$errfrom") if (($sow->{'uid'} ne $vil->{'makeruid'}) && ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'}));

	my $trsid = $sow->{'cfg'}->{'DEFAULT_TEXTRS'};
	$trsid = $query->{'trsid'} if (defined($query->{'trsid'}));
	$query->{'trsid'} = $trsid;

	# ���f�[�^�̕ύX
	$vil->{'vname'}        = $query->{'vname'};
	$vil->{'vcomment'}     = $query->{'vcomment'};
	$vil->{'vcomment'}     = $sow->{'basictrs'}->{'NONE_TEXT'} if ($vil->{'vcomment'} eq '');
	$vil->{'csid'}         = $query->{'csid'};
	$vil->{'trsid'}        = $trsid;
	$vil->{'roletable'}    = $query->{'roletable'};
	$vil->{'updhour'}      = $query->{'hour'};
	$vil->{'updminite'}    = $query->{'minite'};
	$vil->{'updinterval'}  = $query->{'updinterval'};
	$vil->{'entrylimit'}   = $query->{'entrylimit'};
	$vil->{'entrypwd'}     = $query->{'entrypwd'};
	$vil->{'rating'}       = $query->{'rating'};
	$vil->{'vplcnt'}       = $query->{'vplcnt'};
	$vil->{'vplcntstart'}  = $query->{'vplcntstart'};
	$vil->{'vplcntstart'}  = 0 if (!defined($vil->{'vplcntstart'}));
	$vil->{'saycnttype'}   = $query->{'saycnttype'};
	$vil->{'nextupdatedt'} = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, 1, 0);
	$vil->{'nextchargedt'} = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, 1, 0);
	$vil->{'votetype'}     = $query->{'votetype'};
	$vil->{'starttype'}    = $query->{'starttype'};
	$vil->{'randomtarget'} = 0;
	$vil->{'randomtarget'} = 1 if (($sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0) && ($query->{'randomtarget'} ne ''));
	$vil->{'noselrole'}    = 0;
	$vil->{'noselrole'}    = 1 if ($query->{'noselrole'} ne '');
	$vil->{'makersaymenu'} = 0;
	$vil->{'makersaymenu'} = 1 if ($query->{'makersaymenu'} ne '');
	$vil->{'guestmenu'}    = 0;
	$vil->{'guestmenu'}    = 1 if ($query->{'guestmenu'} ne '');
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

	my $nextupdate = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, 1, 0);
	$vil->{'nextupdatedt'} = $nextupdate;
	$vil->{'nextchargedt'} = $nextupdate;

	my $roleid = $sow->{'ROLEID'};
	for ($i = 1; $i < @$roleid; $i++) {
		my $countrole = 0;
		$countrole = $query->{"cnt$roleid->[$i]"} if (defined($query->{"cnt$roleid->[$i]"}));
		$vil->{"cnt$roleid->[$i]"} = int($countrole);
	}

	# ���f�[�^�̏�������
	$vil->writevil();

	# �A�i�E���X
	my $mes = "���̐ݒ肪�ύX����܂����B�ύX���ꂽ�ӏ��͈ȉ��̒ʂ�ł��B<br$net>";
	my $infocap = $sow->{'cfg'}->{'INFOCAP'};
	my $dt = 0;
	my $df = 0;
	foreach (@villabel) {
		if ($vil->{$_} ne $oldinfo{$_}) {
			$df++;
			my $diff = $infocap->{$_};
			my $difcap = $vil->getinfocap($_);
			if ($difcap ne '') {
				$diff = "$diff: $difcap";
			}
			if ($_ eq 'updhour') {
				$dt = 1;
				$diff = "$infocap->{$_}: $difcap"
			} elsif ($_ eq 'updminite') {
				next if ($dt > 0);
				$diff = "$infocap->{$_}: $difcap"
			}
			$mes = $mes . "$diff<br$net>";
		}
		last if ($_ eq 'timestamp');
	}
	$mes = $mes . "�ƌ��������ύX����܂���ł����B" if ($df == 0);
	my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $mes);
	$logfile->close();

	$vil->closevil();

	# ���ꗗ�f�[�^�̍X�V
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();
	my $vindexsingle = $vindex->{'vi'}->{$vil->{'vid'}};
	$vindexsingle->{'vname'}     = $vil->{'vname'},
	$vindexsingle->{'updhour'}   = $vil->{'updhour'},
	$vindexsingle->{'updminite'} = $vil->{'updminite'},
	$vindexsingle->{'vstatus'}   = $sow->{'VSTATUSID_PRO'},
	$vindex->writevindex();
	$vindex->closevindex();

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Edit Vil. [uid=$sow->{'uid'}]");

	return $vil;
}

1;