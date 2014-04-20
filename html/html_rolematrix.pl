package SWHtmlRoleMatrix;

#----------------------------------------
# 役職配分表のHTML出力
#----------------------------------------
sub OutHTMLRoleMatrix {
	my $sow = $_[0];

	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	require "$cfg->{'DIR_LIB'}/setrole.pl";
	require "$cfg->{'DIR_HTML'}/html.pl";

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader('役職配分表\'); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力

	my %vil = (
		trsid        => $sow->{'cfg'}->{'DEFAULT_TEXTRS'},
	);
	&SWBase::LoadTextRS($sow, \%vil);

	my $i;
	print "<h2>役職配分一覧表\</h2>\n\n";

	my $maxpno = $sow->{'cfg'}->{'MAXSIZE_VPLCNT'};
	my $order_roletable = $sow->{'ORDER_ROLETABLE'};
	foreach (@$order_roletable) {
		next if ($_ eq 'custom');
		my $maxroles = &SWSetRole::GetSetRoleTable($sow, $vil, $_, $maxpno);

		print <<"_HTML_";
<h3>$sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$_}</h3>

<div class="paragraph">
<table border="1" summary="$sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$_}配分表\">
<thead>
  <tr>
    <th scope="col">人数</th>
_HTML_

		my $roleshortname = $sow->{'textrs'}->{'ROLESHORTNAME'};
		foreach ($i = 1; $i < $sow->{'COUNT_ROLE'}; $i++) {
			print "    <th scope=\"col\">$roleshortname->[$i]</th>\n" if ($maxroles->[$i] > 0);
		}

		print <<"_HTML_";
  </tr>
</thead>

<tbody>
_HTML_

		for ($i = $sow->{'cfg'}->{'MINSIZE_VPLCNT'}; $i <= $maxpno; $i++) {
			print "  <tr>\n";
			my $roles = &SWSetRole::GetSetRoleTable($sow, $vil, $_, $i);
			print sprintf("    <td scope=\"col\">%2d</td>\n", $i);
			for ($j = 1; $j < $sow->{'COUNT_ROLE'}; $j++) {
				print sprintf("    <td>%2d</td>\n", $roles->[$j]) if ($maxroles->[$j] > 0);
			}
			print "  </tr>\n\n";
		}

		print <<"_HTML_";
</tbody>
</table>
</div>
<hr class="invisible_hr"$net>

_HTML_
	}

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;
