package SWHtmlVlog;

#----------------------------------------
# 村ログ表示のタイトル
#----------------------------------------
sub GetHTMLVlogTitle {
	my ($sow, $vil) = @_;
	my $daytitle = "$sow->{'turn'}日目";
	$daytitle = 'プロローグ' if ($sow->{'turn'} == 0);
	$daytitle = 'エピローグ' if ($sow->{'turn'} == $vil->{'epilogue'});
	$daytitle = '終了' if ($sow->{'turn'} > $vil->{'epilogue'});
	return "$daytitle / $sow->{'query'}->{'vid'} $vil->{'vname'}";
}

#----------------------------------------
# 未発言者リストの取得
#----------------------------------------
sub GetNoSayListText {
	my ($sow, $vil) = @_;
	my $saycnt = $sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	my $pllist = $vil->getpllist();

	my @nosay;
	foreach (@$pllist) {
		if (($_->{'live'} eq 'live') && ($_->{'saidcount'} == 0)) {
			push(@nosay, $_);
		}
	}

	my $result = '';
	my $nosaycnt = @nosay;
	$result .= "本日まだ発言していない者は、";
	foreach (@nosay) {
		my $chrname = $_->getchrname();
		$result .= "$chrname、";
	}
	$result .= "以上 $nosaycnt 名。";

	$result = '' if ($nosaycnt == 0);
	return $result;
}

1;
