package SWCmdEditVil;

#----------------------------------------
# 村編集完了表示
#----------------------------------------
sub CmdEditVil {
	my $sow = $_[0];

	# 村編集処理
	my $vil = &SetDataCmdEditVil($sow);

	# HTML出力
	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_makevil.pl";
	&SWHtmlMakeVil::OutHTMLMakeVil($sow, $vil);
}

#----------------------------------------
# 村編集処理
#----------------------------------------
sub SetDataCmdEditVil {
	my $sow  = $_[0];
	my $query  = $sow->{'query'};
	my $net = $sow->{'html'}->{'net'};

	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";

	# 村データの読み込み
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# 進行中の編集不可
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '村が開始しています。', "game started.") unless ($vil->isprologue()>0);
	
	my @villabel = &SWFileVil::GetVilDataLabel();
	my $oldinfo;
	foreach (@villabel) {
		$oldinfo{$_} = $vil->{$_};
		last if ($_ eq 'timestamp');
	}
	# 村編集時値チェック
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_makevil.pl";
	&SWValidityMakeVil::CheckValidityMakeVil($sow);

	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "村作成者以外には村の編集は行えません。", "no permition.$errfrom") if (($sow->{'uid'} ne $vil->{'makeruid'}) && ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'}));

	my $trsid = $sow->{'cfg'}->{'DEFAULT_TEXTRS'};
	$trsid = $query->{'trsid'} if (defined($query->{'trsid'}));
	$query->{'trsid'} = $trsid;

	# 村データの変更
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

	# 村データの書き込み
	$vil->writevil();

	# アナウンス
	my $mes = "村の設定が変更されました。変更された箇所は以下の通りです。<br$net>";
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
	$mes = $mes . "と言いつつ何も変更されませんでした。" if ($df == 0);
	my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);
	$logfile->writeinfo('', $sow->{'MESTYPE_INFONOM'}, $mes);
	$logfile->close();

	$vil->closevil();

	# 村一覧データの更新
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