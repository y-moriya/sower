package SWCmdVote;

#----------------------------------------
# 投票／能力対象設定
#----------------------------------------
sub CmdVote {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg    = $sow->{'cfg'};

	# データ処理
	my $vil = &SetDataCmdVote($sow);

	# HTTP/HTML出力
	if ($sow->{'outmode'} eq 'mb') {
		require "$sow->{'cfg'}->{'DIR_LIB'}/cmd_wrformmb.pl";
		&SWCmdWriteFormMb::CmbWriteFormMb($sow);
	} else {
		my $reqvals = &SWBase::GetRequestValues($sow);
		my $link = &SWBase::GetLinkValues($sow, $reqvals);
		$link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

		$sow->{'http'}->{'location'} = "$link";
		$sow->{'http'}->outheader(); # HTTPヘッダの出力
		$sow->{'http'}->outfooter();
	}
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdVote {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};

	# 村データの読み込み
	require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
	my $vil = SWFileVil->new($sow, $query->{'vid'});
	$vil->readvil();

	# リソースの読み込み
	&SWBase::LoadVilRS($sow, $vil);

	# 投票／能力対象設定
	my $targetid = 'target';
	$targetid = 'vote' if ($query->{'cmd'} eq 'vote');
	my $curpl = $sow->{'curpl'};

#	my $targetpl;
#	$targetpl = $vil->getplbypno($query->{'target'}) if ($query->{'target'} >= 0);

	# 村ログ関連基本入力値チェック
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_vil.pl";
	&SWValidityVil::CheckValidityVil($sow, $vil);

	$debug->raise($sow->{'APLOG_CAUTION'}, "あなたは既に死んでいます。", "you're dead.") if ($curpl->{'live'} ne 'live'); # 通常起きない
	&CheckValidityTarget($sow, $vil, 'target');
	if (($curpl->{'role'} == $sow->{'ROLEID_TRICKSTER'}) && ($targetid ne 'vote')) {
		&CheckValidityTarget($sow, $vil, 'target2');
		$debug->raise($sow->{'APLOG_CAUTION'}, "対象１と対象２が同じ人です。", "same both target.") if (($query->{'target'} == $query->{'target2'}) && ($query->{'target'} >= 0));
	}

	if ($targetid eq 'vote') {
		$debug->raise($sow->{'APLOG_CAUTION'}, "今日は投票できる日ではありません。", "cannot vote.") if (($vil->{'turn'} < 2) || ($vil->isepilogue() > 0)); # 通常起きない
	} else {
		$debug->raise($sow->{'APLOG_CAUTION'}, "今日は能\力対象を設定できる日ではありません。", "cannot set target.") if (($vil->{'turn'} == 0) || ($vil->isepilogue() > 0)); # 通常起きない
		$debug->raise($sow->{'APLOG_CAUTION'}, "今日は能\力対象を設定できる日ではありません。", "cannot set target.[roleid=guard]") if (($curpl->{'role'} eq $sow->{'ROLEID_GUARD'}) && ($vil->{'turn'} == 1)); # 通常起きない
		$debug->raise($sow->{'APLOG_CAUTION'}, "今日は能\力対象を設定できる日ではありません。", "cannot set target.[roleid=trickster]") if (($curpl->{'role'} eq $sow->{'ROLEID_TRICKSTER'}) && ($vil->{'turn'} != 1)); # 通常起きない
	}

	my $savepno = $curpl->{$targetid};
	my $saveentrust = $curpl->{'entrust'};
	$curpl->{$targetid} = $query->{'target'};
	my $modifiedtarget2 = 0;
	if (($curpl->{'role'} == $sow->{'ROLEID_TRICKSTER'}) && ($query->{'cmd'} ne 'vote')) {
		if ($curpl->{'target2'} != $query->{'target2'}) {
			$curpl->{'target2'} = $query->{'target2'};
			$modifiedtarget2 = 1;
		}
	}
	if ($query->{'cmd'} eq 'vote') {
		# 委任
		$curpl->{'entrust'} = 0;
		$curpl->{'entrust'} = 1 if ($query->{'entrust'} ne '');
	}
	$curpl->{'modified'} = $sow->{'time'} if (($savepno != $curpl->{$targetid}) || ($modifiedtarget2 > 0) || ($saveentrust != $curpl->{'entrust'}));
	$vil->writevil();

	# 投票／能力対象変更操作を村ログへ書き込み
	if (($sow->{'cfg'}->{'ENABLED_PLLOG'} > 0) && (($savepno != $curpl->{$targetid}) || ($modifiedtarget2 > 0) || ($saveentrust != $curpl->{'entrust'}))) {
		require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
		require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";

		# ログデータファイルを開く
		my $logfile = SWBoa->new($sow, $vil, $vil->{'turn'}, 0);

		# 書き込み文の生成
		my $textrs = $sow->{'textrs'};
		my $mes;
		if ($query->{'cmd'} eq 'vote') {
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
		if (($curpl->{'role'} == $sow->{'ROLEID_TRICKSTER'}) && ($query->{'cmd'} ne 'vote')) {
			if ($curpl->{'target2'} == $sow->{'TARGETID_RANDOM'}) {
				$targetname .= ' と ' . $textrs->{'RANDOMTARGET'};
			} else {
				my $target2pl = $vil->getplbypno($curpl->{'target2'});
				$targetname .= ' と ' . $target2pl->getchrname();
			}
		}
		$mes =~ s/_TARGET_/$targetname/g;

		# 書き込み
		$logfile->writeinfo($curpl->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $mes);
		$logfile->close();
	}
	$vil->closevil();

	$sow->{'debug'}->writeaplog($sow->{'APLOG_POSTED'}, "Set Vote/Skill. [uid=$sow->{'uid'}, vid=$vil->{'vid'}, action=$targetid]");

	return $vil;
}

#----------------------------------------
# 投票／能力対象チェック
#----------------------------------------
sub CheckValidityTarget {
	my ($sow, $vil, $targetid) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	my $debug = $sow->{'debug'};
	my $curpl = $sow->{'curpl'};

	$debug->raise($sow->{'APLOG_CAUTION'}, "対象が不正です。", "no target.") if (!defined($query->{$targetid}));

	my $targetpl;
	$targetpl = $vil->getplbypno($query->{$targetid}) if ($query->{$targetid} >= 0);

	$debug->raise($sow->{'APLOG_CAUTION'}, "対象が不正です。", "invalid target.") if ($query->{$targetid} < $sow->{'TARGETID_RANDOM'});
	$debug->raise($sow->{'APLOG_CAUTION'}, "対象が不正です。", "invalid target.[cannot random]") if (($query->{$targetid} == $sow->{'TARGETID_RANDOM'}) && ($vil->{'randomtarget'} == 0)); # ランダム対象

	if (($targetid ne 'target') || ($curpl->iswolf() == 0)) {
		if (($query->{$targetid} != $sow->{'TARGETID_RANDOM'}) || ($vil->{'randomtarget'} == 0)) {
			# 存在しないプレイヤー番号／ランダム禁止時のランダム対象／襲撃先以外のおまかせ
			# 通常起きない
			$debug->raise($sow->{'APLOG_CAUTION'}, "対象が不正です。", "invalid target.") if (!defined($targetpl->{'uid'}));
		}
	}

	$debug->raise($sow->{'APLOG_CAUTION'}, "対象に自分は選べません。","target is you.") if ((defined($targetpl->{'pno'})) && ($sow->{'curpl'}->{'pno'} == $targetpl->{'pno'})); # 通常起きない
	$debug->raise($sow->{'APLOG_CAUTION'}, "対象にダミーキャラは選べません。","target is dummy.") if (($curpl->{'role'} == $sow->{'ROLEID_TRICKSTER'}) &&(defined($targetpl->{'pno'})) && ($targetpl->{'pno'} == 0)); # 通常起きない
	$debug->raise($sow->{'APLOG_CAUTION'}, "対象は既に死んでいます。", "target is dead.") if ((defined($targetpl->{'live'})) && ($targetpl->{'live'} ne 'live')); # 通常起きない

}

1;