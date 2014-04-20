package SWCmdRoleList;

#----------------------------------------
# 役職一覧表示
#----------------------------------------
sub CmdRoleList {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg = $sow->{'cfg'};

	require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
	require "$sow->{'cfg'}->{'DIR_HTML'}/html_rolelist.pl";
	my $title = &SWHtmlRoleList::GetHTMLRoleListTitle();

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	$sow->{'http'}->outheader(); # HTTPヘッダの出力
	$sow->{'html'}->outheader($title); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader('');

	&SWHtmlPC::OutHTMLLogin($sow); # ログインボタン

	# 役職一覧画面のHTML出力
	&SWHtmlRoleList::OutHTMLRoleList($sow);

	&SWHtml::OutHTMLReturn($sow); # トップページへ戻る

	$sow->{'html'}->outcontentfooter('');
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

}

1;