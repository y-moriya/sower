package SWCmdRestPlayingVil;

#----------------------------------------
# 参加中の村一覧クリア処理
# ※再構築にしようかと思ったけど、コストかかるのでクリアのみで。
#   現在参加中の村も消えてしまうが、入り直したりすれば表示される。
#----------------------------------------
sub CmdRestPlayingVil {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# データ処理
	&SetDataCmdRestPlayingVil($sow);

	# HTTP/HTML出力
	&OutHTMLCmdRestPlayingVil($sow);
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdRestPlayingVil {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "管理人権限が必要です。", "no permition.$errfrom") if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'});

	return if ($query->{'cmd'} eq 'restplayingvil');

    opendir(DIR, "$sow->{'cfg'}->{'DIR_USER'}");
    my @users;
    foreach (readdir(DIR)) {
        my $fname = $_;
        if ($fname =~ /\.cgi$/) {
            $fname =~ s/\.cgi$//;
            $fname = &SWBase::DecodeURL($fname);
            push(@users, $fname);
        }
    }
    closedir(DIR);

    return if (@users == 0);

	foreach (@users) {
		my $user = SWUser->new($sow);
		$user->{'uid'} = $_;
		$user->openuser(1);
		$user->{'entriedvils'} = '';
		$user->writeuser();
		$user->closeuser();
	}

	return;
}

#----------------------------------------
# HTML出力
#----------------------------------------
sub OutHTMLCmdRestPlayingVil {
	my $sow = $_[0];
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	# HTML出力用ライブラリの読み込み
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_restpvil.pl";

	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->outheader('参加中の村一覧再構築'); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();

	&SWHtmlRestPlayingVil::OutHTMLRestPlayingVil($sow);

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();
}

1;