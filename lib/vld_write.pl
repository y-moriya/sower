package SWValidityWrite;

#----------------------------------------
# 発言時値チェック
#----------------------------------------
sub CheckValidityWrite {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	# 村ログ関連基本入力値チェック
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_vil.pl";
	&SWValidityVil::CheckValidityVil($sow, $vil);

	my $lenmes = length($query->{'mes'});
	$debug->raise($sow->{'APLOG_NOTICE'}, "発言が短すぎます（$lenmes バイト）。$sow->{'cfg'}->{'MINSIZE_MES'} バイト以上必要です。", "mes too short.$errfrom") if (($lenmes < $sow->{'cfg'}->{'MINSIZE_MES'}) && ($lenmes != 0));

	my @messwitch = ('think', 'wolf', 'maker', 'admin');
	my $cntenabled = 0;
	foreach (@messwitch) {
		$cntenabled++ if ($query->{$_} ne '');
	}
	$debug->raise($sow->{'APLOG_CAUTION'}, "発言種別が不正です。", "invalid mestype.$errfrom") if ($cntenabled > 1); # 通常起きない

	if ($query->{'cmd'} eq 'writepr') {
		if ($vil->{'entrylimit'} eq 'password') {
			if ($query->{'guest'} ne '') {
				if ($query->{'writepwd'} ne $vil->{'entrypwd'}) {
					$debug->raise($sow->{'APLOG_NOTICE'}, 'パスワードが違います。', "invalid writepwd.$errfrom") ;
				}
			}
		}
	}

	if (($vil->{'guestmenu'} > 0) && ($query->{'guest'} ne '')) {
		$debug->raise($sow->{'APLOG_CAUTION'}, "傍観者発言は無効です。", "invalid guest.$errfrom");
	}

	return;
}

1;
