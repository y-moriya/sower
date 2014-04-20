package SWSetRole;

#----------------------------------------
# 役職配分割り当て
#----------------------------------------
sub SetRole {
	my ($sow, $vil) = @_;
	my $textrs = $sow->{'textrs'};
	my $rolename = $textrs->{'ROLENAME'};

	my $pllist = $vil->getpllist();
	my $roletable = &GetSetRoleTable($sow, $vil, $vil->{'roletable'}, scalar(@$pllist));

	my ($i, @roles);

	# 各役職用の配列を用意
	for ($i = 0; $i < $sow->{'COUNT_ROLE'}; $i++) {
		my @rolepllist;
		$roles[$i] = \@rolepllist;
#		print "[$i] $rolename->[$i]\n";
	}

	# 役職希望者IDを希望した役職の配列に格納
	for (@$pllist) {
		next if ($_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'});
		my $rolepllist = $roles[$_->{'selrole'}];
		$rolepllist = $roles[0] if ($vil->{'noselrole'} > 0); # 役職希望を無視して、全員をおまかせに
		push(@$rolepllist, $_);
	}

	for ($i = 1; $i < $sow->{'COUNT_ROLE'}; $i++) {
		my $rolepllist  = $roles[$i];
#		print "[matrix] $roletable->[$i]\n";

		# あぶれた人をおまかせ配列に移動
		while ($roletable->[$i] < @$rolepllist) {
			my $freepllist = $roles[0]; # おまかせ配列
			my $pno = int(rand(@$rolepllist));

			# おまかせ配列へ移動
			my $movepl = splice(@$rolepllist, $pno, 1);
			push(@$freepllist, $movepl);
		}
	}

	# 割り当て一覧表示（テスト用）
#	for ($i = 0; $i < @$rolename; $i++) {
#		my $pid = $roles[$i];
#		my $n = @$pid;
#		print "[$rolename->[$i]] $n\n";
#	}

	# おまかせの人を空いている役職へ割り当て
	for ($i = 1; $i < $sow->{'COUNT_ROLE'}; $i++) {
		my $rolepllist  = $roles[$i];

		while ($roletable->[$i] > @$rolepllist) {
			my $freepllist = $roles[0];
			my $pno = int(rand(@$freepllist));
			my $movepl = splice(@$freepllist, $pno, 1);
			push(@$rolepllist, $movepl);
		}
	}

	# テスト用
#	for ($i = 0; $i < @$rolename; $i++) {
#		my $pid = $roles[$i];
#		my $n = @$pid;
#		print "[$rolename->[$i]] $n\n";
#	}

	# 役職を決定
	my $dummypl = $vil->getpl($sow->{'cfg'}->{'USERID_NPC'});
	$dummypl->{'role'} = $sow->{'ROLEID_VILLAGER'}; # ダミーキャラ
	for ($i = 1; $i < $sow->{'COUNT_ROLE'}; $i++) {
		my $rolepllist = $roles[$i];
		foreach (@$rolepllist) {
			if (!defined($_->{'role'})) {
				# $_が未定義（ありえないはず）
				$sow->{'debug'}->writeaplog($sow->{'APLOG_WARNING'}, 'invalid pl. [setrole.]');
			}
			$_->{'role'} = $i;
			$_->{'rolesubid'} = -1;
		}
	}

	# 割り当て一覧表示（テスト用）
#	foreach (@$pllist) {
#		print "[$_->{'uid'}] $rolename->[$_->{'selrole'}] → $rolename->[$_->{'role'}]\n";
#	}

	# 共有者処理
	&SetFreeMasonHistory($sow, $vil, $sow->{'ROLEID_FM'});

	# 共鳴者処理
	&SetFreeMasonHistory($sow, $vil, $sow->{'ROLEID_SYMPATHY'});

	# 聖痕者処理
	my $stigma = &GetPlRole($sow, $vil, $sow->{'ROLEID_STIGMA'});
	if (@$stigma > 1) {
		my $i;
		my $loopcount = @$stigma;
		for ($i = 0; $i < $loopcount; $i++) {
			my $stigmano = int(rand(@$stigma));
			my $stigmapl = splice(@$stigma, $stigmano, 1);
			$stigmapl->{'rolesubid'} = $i;
		}
	}

	# 狂信者処理
	my $fanatic = &GetPlRole($sow, $vil, $sow->{'ROLEID_FANATIC'});
	my $wolves = &GetPlRole($sow, $vil, $sow->{'ROLEID_WOLF'});;
	my $cwolves = &GetPlRole($sow, $vil, $sow->{'ROLEID_CWOLF'});;
	push(@$wolves, @$cwolves);
	my $intwolves = &GetPlRole($sow, $vil, $sow->{'ROLEID_INTWOLF'});;
	push(@$wolves, @$intwolves);

	my $history = '';
	my $wolfpl;
	foreach $wolfpl (@$wolves) {
		my $chrname = $wolfpl->getchrname();
		my $result_fanatic = $textrs->{'RESULT_FANATIC'};
		$result_fanatic =~ s/_NAME_/$chrname/g;
		$history .= "$result_fanatic<br>";
	}
	foreach (@$fanatic) {
		$_->{'history'} = $history;
	}

	# 能力履歴表示（テスト用）
#	foreach (@$pllist) {
#		print "[$_->{'uid'}] $_->{'history'}\n";
#	}

}

#----------------------------------------
# 指定した能力者の配列を取得
#----------------------------------------
sub GetPlRole {
	my ($sow, $vil, $role) = @_;
	my $pllist = $vil->getpllist();

	my @rolepl;
	foreach (@$pllist) {
		push(@rolepl, $_) if ($_->{'role'} == $role);
	}

	return \@rolepl;
}

#----------------------------------------
# 配分表の取得
#----------------------------------------
sub GetSetRoleTable {
	my ($sow, $vil, $roletable, $plcnt) = @_;

	my @roles;
	my $i;
	for ($i = 0; $i < $sow->{'COUNT_ROLE'}; $i++) {
		$roles[$i] = 0;
	}

	if ($roletable eq 'hamster') {
		# ハム入り配分表の取得
		&GetSetRoleTableHamster($sow, $plcnt, \@roles);

	} elsif ($roletable eq 'wbbs_c') {
		# Ｃ国配分表の取得
		&GetSetRoleTableWBBS_C($sow, $plcnt, \@roles);

	} elsif ($roletable eq 'test1st') {
		# 試験壱型配分表の取得
		&GetSetRoleTableTest1st($sow, $plcnt, \@roles);

	} elsif ($roletable eq 'test2nd') {
		# 試験弐型配分表の取得
		&GetSetRoleTableTest2nd($sow, $plcnt, \@roles);

	} elsif ($roletable eq 'custom') {
		# カスタム配分表の取得
		&GetSetRoleTableCustom($sow, $vil, \@roles);

	} elsif ($roletable eq 'wbbs_g') {
		# G国配分表の取得
		&GetSetRoleTableWBBS_G($sow, $plcnt, \@roles);

	} else {
		# 標準配分表の取得
		&GetSetRoleTableDefault($sow, $plcnt, \@roles);
	}

	return \@roles;
}

#----------------------------------------
# 標準配分表の取得
#----------------------------------------
sub GetSetRoleTableDefault {
	my ($sow, $plcnt, $roles) = @_;

	# 人狼
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 15);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 24);

	# 占い師
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# 霊能者
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 9);

	# 狂人
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if ($plcnt >= 10);

	# 狩人
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# 共有者
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

	# 村人
	my $total = 0;
	my $i;
	for ($i = 0; $i < $sow->{'COUNT_ROLE'}; $i++) {
		$total += $roles->[$i];
	}
	$roles->[$sow->{'ROLEID_VILLAGER'}] = $plcnt - $total - 1;

	return;
}

#----------------------------------------
# G国配分表の取得
#----------------------------------------
sub GetSetRoleTableWBBS_G {
	my ($sow, $plcnt, $roles) = @_;

	# 人狼
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 10);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 13);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 20);

	# 占い師
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# 霊能者
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 10);

	# 狂人
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if ($plcnt >= 11);

	# 狩人
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# 共有者いない
	# $roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

	# 村人
	my $total = 0;
	my $i;
	for ($i = 0; $i < $sow->{'COUNT_ROLE'}; $i++) {
		$total += $roles->[$i];
	}
	$roles->[$sow->{'ROLEID_VILLAGER'}] = $plcnt - $total - 1;

	return;
}


#----------------------------------------
# ハム入り配分表の取得
#----------------------------------------
sub GetSetRoleTableHamster {
	my ($sow, $plcnt, $roles) = @_;

	# 人狼
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 15);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 24);

	# 占い師
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# 霊能者
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 9);

	# 狂人
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if ($plcnt >= 10);

	# 狩人
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# 共有者
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

	# ハムスター人間
	$roles->[$sow->{'ROLEID_HAMSTER'}]++ if ($plcnt >= 16);

	# 村人
	my $total = 0;
	my $i;
	for ($i = 0; $i < $sow->{'COUNT_ROLE'}; $i++) {
		$total += $roles->[$i];
	}
	$roles->[$sow->{'ROLEID_VILLAGER'}] = $plcnt - $total - 1;

	return;
}

#----------------------------------------
# Ｃ国配分表の取得
#----------------------------------------
sub GetSetRoleTableWBBS_C {
	my ($sow, $plcnt, $roles) = @_;

	# 人狼
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 15);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 24);

	# 占い師
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# 霊能者
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 9);

	# Ｃ国狂人
	$roles->[$sow->{'ROLEID_CPOSSESS'}]++ if ($plcnt >= 10);

	# 狩人
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# 共有者
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

	# 村人
	my $total = 0;
	my $i;
	for ($i = 0; $i < $sow->{'COUNT_ROLE'}; $i++) {
		$total += $roles->[$i];
	}
	$roles->[$sow->{'ROLEID_VILLAGER'}] = $plcnt - $total - 1;

	return;
}

#----------------------------------------
# 試験壱型配分表の取得
#----------------------------------------
sub GetSetRoleTableTest1st {
	my ($sow, $plcnt, $roles) = @_;

	# 人狼
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 15);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 23);

	# 占い師
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# 霊能者
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 9);

	# 狂人
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if ($plcnt >= 10);
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if (($plcnt >= 13) && ($plcnt <= 14)); # 15～18では１人
	$roles->[$sow->{'ROLEID_POSSESS'}]++ if ($plcnt >= 19);

	# 狩人
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# 共有者
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 19);

	# 聖痕者
	$roles->[$sow->{'ROLEID_STIGMA'}]++ if ($plcnt >= 13);
	$roles->[$sow->{'ROLEID_STIGMA'}]++ if (($plcnt >= 16) && ($plcnt <= 18));

	# 村人
	my $total = 0;
	my $i;
	for ($i = 0; $i < $sow->{'COUNT_ROLE'}; $i++) {
		$total += $roles->[$i];
	}
	$roles->[$sow->{'ROLEID_VILLAGER'}] = $plcnt - $total - 1;

	return;
}

#----------------------------------------
# 試験弐型配分表の取得
#----------------------------------------
sub GetSetRoleTableTest2nd {
	my ($sow, $plcnt, $roles) = @_;

	# 人狼
	$roles->[$sow->{'ROLEID_WOLF'}]++;
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 8);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 16);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 21);
	$roles->[$sow->{'ROLEID_WOLF'}]++ if ($plcnt >= 26);

	# 占い師
	$roles->[$sow->{'ROLEID_SEER'}]++;

	# 霊能者
	$roles->[$sow->{'ROLEID_MEDIUM'}]++ if ($plcnt >= 9);

	# 狂信者
	$roles->[$sow->{'ROLEID_FANATIC'}]++ if ($plcnt >= 10);

	# 狩人
	$roles->[$sow->{'ROLEID_GUARD'}]++ if ($plcnt >= 11);

	# 共有者
	$roles->[$sow->{'ROLEID_FM'}] += 2 if ($plcnt >= 16);

	# 村人
	my $total = 0;
	my $i;
	for ($i = 0; $i < $sow->{'COUNT_ROLE'}; $i++) {
		$total += $roles->[$i];
	}
	$roles->[$sow->{'ROLEID_VILLAGER'}] = $plcnt - $total - 1;

	return;
}

#----------------------------------------
# カスタム配分表の取得
#----------------------------------------
sub GetSetRoleTableCustom {
	my ($sow, $vil, $roles) = @_;

	my $i;
	my $roleid = $sow->{'ROLEID'};
	for ($i = 1; $i < @$roleid; $i++) {
		$roles->[$i] = $vil->{"cnt$roleid->[$i]"};
	}
	$roles->[1]--; # ダミーキャラの分

	return;
}

#----------------------------------------
# 共有者／共鳴者の相方表示処理
#----------------------------------------
sub SetFreeMasonHistory {
	my ($sow, $vil, $roleid) = @_;
	my $textrs = $sow->{'textrs'};

	my $fm = &GetPlRole($sow, $vil, $roleid);
	my $namefm = $textrs->{'ROLENAME'}->[$roleid];
	my $fmplsrc;
	foreach $fmplsrc (@$fm) {
		my $fmpl;
		foreach $fmpl (@$fm) {
			my $chrname = $fmpl->getchrname();
			my $result_fm = $textrs->{'RESULT_FM'};
			$result_fm =~ s/_ROLE_/$namefm/g;
			$result_fm =~ s/_TARGET_/$chrname/g;
			$fmplsrc->{'history'} .=  "$result_fm<br>" if ($fmplsrc->{'uid'} ne $fmpl->{'uid'});
		}
	}
}

1;