package SWValidityMakeVil;

#----------------------------------------
# 村作成・編集時値チェック
#----------------------------------------
sub CheckValidityMakeVil {
	my $sow = shift;
	my $query = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_text.pl";

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "ログインして下さい。", "no login.$errfrom") if ($sow->{'user'}->logined() <= 0);
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, "村の作成はできません。", "cannot vmake.$errfrom") if ($sow->{'cfg'}->{'ENABLED_VMAKE'} == 0);

	&SWValidityText::CheckValidityText($sow, $errfrom, $query->{'vname'}, 'VNAME', 'vname', '村の名前', 1);
	$query->{'vcomment'} = '' if ($query->{'vcomment'} eq $sow->{'basictrs'}->{'NONE_TEXT'});
	&SWValidityText::CheckValidityText($sow, $errfrom, $query->{'vcomment'}, 'VCOMMENT', 'vcomment', '村の説明', 0);

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '文字列リソースが未選択です。', "no trsid.$errfrom") if ($query->{'trsid'} eq '');
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '登場人物が未選択です。', "no csid.$errfrom") if ($query->{'csid'} eq ''); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '役職配分が未選択です。', "no roletable.$errfrom") if ($query->{'roletable'} eq ''); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '投票方法が未選択です。', "no votetype.$errfrom") if ($query->{'votetype'} eq ''); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '更新時間（時）が未選択です。', "no hour.$errfrom") if (!defined($query->{'hour'})); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '更新時間（時）は0～23の範囲で選んで下さい。', "invalid hour.$errfrom") if (($query->{'hour'} < 0) || ($query->{'hour'} > 23)); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '更新時間（分）が未選択です。', "no minite.$errfrom") if (!defined($query->{'minite'})); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '更新時間（分）は0～59の範囲で選んで下さい。', "invalid minite.$errfrom") if (($query->{'minite'} < 0) || ($query->{'minite'} > 59)); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '更新間隔が未選択です。', "no updinterval.$errfrom") if (!defined($query->{'updinterval'})); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '更新間隔は1～3の範囲で選んで下さい。', "invalid updinterval.$errfrom") if (($query->{'updinterval'} < 1) || ($query->{'updinterval'} > 3)); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '定員が未入力です。', "no vplcnt.$errfrom") if (!defined($query->{'vplcnt'}));
	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "定員は$sow->{'cfg'}->{'MINSIZE_VPLCNT'}～$sow->{'cfg'}->{'MAXSIZE_VPLCNT'}の範囲で入力して下さい。", "invalid vplcnt.$errfrom") if (($query->{'vplcnt'} < $sow->{'cfg'}->{'MINSIZE_VPLCNT'}) || ($query->{'vplcnt'} > $sow->{'cfg'}->{'MAXSIZE_VPLCNT'}));
	if ($query->{'starttype'} eq 'wbbs') {
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '最低人数が未入力です。', "no vplcntstart.$errfrom") if (!defined($query->{'vplcntstart'}));
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "最低人数は$sow->{'cfg'}->{'MINSIZE_VPLCNT'}～$sow->{'cfg'}->{'MAXSIZE_VPLCNT'}の範囲で入力して下さい。", "invalid vplcntstart.$errfrom") if (($query->{'vplcntstart'} < $sow->{'cfg'}->{'MINSIZE_VPLCNT'}) || ($query->{'vplcntstart'} > $sow->{'cfg'}->{'MAXSIZE_VPLCNT'}));
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '開始方法が人狼BBS型で役職配分自由設定の場合、最低人数と定員を同じ人数にしてください。', "vplcnt != vplcntstart.$errfrom") if (($query->{'vplcntstart'} != $query->{'vplcnt'}) && ($query->{'roletable'} eq 'custom'));
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '最低人数は定員以下の人数で入力して下さい。', "too many vplcntstart.$errfrom") if ($query->{'vplcntstart'} > $query->{'vplcnt'});
	}

	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '発言制限が未選択です。', "no saycnttype.$errfrom") if ($query->{'saycnttype'} eq ''); # 通常起きない
	$sow->{'debug'}->raise($sow->{'APLOG_CAUTION'}, '非対応の参加制限を選択しています。', "invalid entrylimit.$errfrom") if (($query->{'entrylimit'} ne 'free') && ($query->{'entrylimit'} ne 'password')); # 通常起きない
	&SWValidityText::CheckValidityText($sow, $errfrom, $query->{'entrypwd'}, 'PASSWD', 'entrypwd', '参加パスワード', 1) if ($query->{'entrylimit'} eq 'password');

	# 人狼の数
	my $wolves = 0;
	$wolves += $query->{'cntwolf'} if (defined($query->{'cntwolf'}));
	$wolves += $query->{'cntcwolf'} if (defined($query->{'cntcwolf'}));
	$wolves += $query->{'cntintwolf'} if (defined($query->{'cntintwolf'}));

	if ($query->{'roletable'} eq 'custom') {
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '人狼がいません。', "no wolves. $errfrom") if ($wolves <= 0);

		my $roleid = $sow->{'ROLEID'};
		my $total = 0;
		my $i;
		for ($i = 1; $i < @$roleid; $i++) {
			my $count = 0;
			$count = $query->{"cnt$roleid->[$i]"} if (defined($query->{"cnt$roleid->[$i]"}));
			$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '役職配分の人数は0以上を入力して下さい。', "invalid role count.[$roleid->[$i] = $count] $errfrom") if ($count < 0);
			$total += $count;
		}

		my $total_cpossess = 0;
		my $total_hamster = 0;
		$total_cpossess = $query->{"cnt$roleid->[$sow->{'ROLEID_CPOSSESS'}]"} if (defined($query->{"cnt$roleid->[$sow->{'ROLEID_CPOSSESS'}]"}));
		$total_hamster = $query->{"cnt$roleid->[$sow->{'ROLEID_HAMSTER'}]"} if (defined($query->{"cnt$roleid->[$sow->{'ROLEID_HAMSTER'}]"}));
		$total_hamster += $query->{"cnt$roleid->[$sow->{'ROLEID_WEREBAT'}]"} if (defined($query->{"cnt$roleid->[$sow->{'ROLEID_WEREBAT'}]"}));
		$total_hamster += $query->{"cnt$roleid->[$sow->{'ROLEID_TRICKSTER'}]"} if (defined($query->{"cnt$roleid->[$sow->{'ROLEID_TRICKSTER'}]"}));

		$total_cpossess = 0 if (($total_cpossess > 0) && ($total_hamster > 0));

		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '役職配分の合計人数と定員が等しくありません。', "invalid vplcnt or total plcnt.[$query->{'vplcnt'} != $total] $errfrom") if ($query->{'vplcnt'} != $total);
		if ($wolves >= ($total - $total_cpossess - $total_hamster - 1) / 2) {
			if ($total_cpossess > 0) {
				$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '人狼が多すぎます（Ｃ国狂人は人間にも人狼にもカウントされません）。', "too many wolves and cpossesses. $errfrom");
			} elsif ($total_hamster > 0) {
				$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '人狼が多すぎます（ハムスター人間とコウモリ人間は人間にも人狼にもカウントされません）。', "too many wolves and hamsters. $errfrom");
			} else {
				$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, '人狼が多すぎます。', "too many wolves. $errfrom");
			}
		}
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, 'ダミーキャラの分、村人は最低 1 人入れてください。', "no villagers. $errfrom") if ($query->{'cntvillager'} <= 0);
		$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "聖痕者は $sow->{'cfg'}->{'MAXCOUNT_STIGMA'} 人までです。", "too many stigma. $errfrom") if ($query->{'cntstigma'} > $sow->{'cfg'}->{'MAXCOUNT_STIGMA'});
	}

	return;
}

1;