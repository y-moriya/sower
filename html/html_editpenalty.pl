package SWHtmlEditPenalty;

#----------------------------------------
# ペナルティ編集画面のHTML出力
#----------------------------------------
sub OutHTMLEditPenalty {
	my $sow = shift;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'}; # Null End Tag

	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'cmd'} = 'editpenalty';
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');

	if ($query->{'cmd'} eq 'editpenalty') {
		print "<p class=\"info\">\nペナルティの設定・解除を行いました。\n</p>\n\n";
	}

	print <<"_HTML_";
<h2>ペナルティの設定・解除</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$hidden
  <input type="submit" value="再構\築"$net>
</p>
</form>
<hr class="invisible_hr"$net>

<p class="paragraph">
ペナルティ
</p>
<hr class="invisible_hr"$net>

_HTML_

	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	return;
}

1;
