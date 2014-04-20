package SWHtmlDocument;

#----------------------------------------
# ドキュメント画面のHTML出力
#----------------------------------------
sub OutHTMLDocument {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};

	require "$cfg->{'DIR_HTML'}/html.pl";
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	my $cmd = $sow->{'query'}->{'cmd'};
	my $doc;

	if ($cmd eq 'howto') {
		require "$cfg->{'DIR_RS'}/doc_howto.pl";
		$doc = SWDocHowTo->new($sow);
	} elsif ($cmd eq 'prohibit') {
		require "$cfg->{'DIR_RS'}/doc_prohibit.pl";
		$doc = SWDocProhibit->new($sow);
	} elsif ($cmd eq 'about') {
		require "$cfg->{'DIR_RS'}/doc_about.pl";
		$doc = SWDocAbout->new($sow);
	} elsif ($cmd eq 'operate') {
		require "$cfg->{'DIR_RS'}/doc_operate.pl";
		$doc = SWDocOperate->new($sow);
	} elsif ($cmd eq 'spec') {
		require "$cfg->{'DIR_LIB'}/doc_spec.pl";
		$doc = SWDocSpec->new($sow);
	} else {
		require "$cfg->{'DIR_LIB'}/doc_changelog.pl";
		$doc = SWDocChangeLog->new($sow);
	}

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader($doc->{'title'}); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力
	$doc->outhtml(); # 本文出力
	&SWHtmlPC::OutHTMLReturnPC($sow); # トップページへ戻る

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

1;
