package SWHtmlIndex;

#----------------------------------------
# トップページのHTML出力
#----------------------------------------
sub OutHTMLIndex {
	my $sow = $_[0];
	my $cfg = $sow->{'cfg'};
	require "$cfg->{'DIR_LIB'}/file_vindex.pl";
	require "$cfg->{'DIR_LIB'}/file_vil.pl";
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_vindex.pl";
	require "$cfg->{'DIR_LIB'}/cmd_automakevil.pl";
	&SWCmdATMakeVil::CmdATMakeVil($sow);

	# 村一覧データ読み込み
	my $vindex = SWFileVIndex->new($sow);
	$vindex->openvindex();

	my $linkvalue;
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

	my $infodt = 0;
	$infodt = (stat("./_info.pl"))[9] if (-e "./_info.pl");
	my $changelogdt = (stat("./$cfg->{'DIR_LIB'}/doc_changelog.pl"))[9];
	$infodt = $changelogdt if ($changelogdt > $infodt);
	&SetHTTPUpdateIndex($sow, $infodt, $vindex->getupdatedt());

	$sow->{'http'}->setnotmodified(); # 最終更新日時

	# HTTP/HTMLの出力
	$sow->{'html'} = SWHtml->new($sow); # HTMLモードの初期化
	my $outhttp = $sow->{'http'}->outheader(); # HTTPヘッダの出力
	return if ($outhttp == 0); # ヘッダ出力のみ
	$sow->{'html'}->{'rss'} = "$urlsow?cmd=rss"; # 村の一覧のRSS
	$sow->{'html'}->outheader($cfg->{'NAME_TOP'}); # HTMLヘッダの出力
	$sow->{'html'}->outcontentheader();
	my $net = $sow->{'html'}->{'net'}; # Null End Tag

	if ($cfg->{'ENABLED_MENU'} > 0) {
		my $savecss = $reqvals->{'css'};
		$reqvals->{'css'} = '';
		$reqvals->{'ua'} = 'mb';
		my $linkmb = &SWBase::GetLinkValues($sow, $reqvals);
		my $urlhome = '';
		$urlhome = "<a href=\"$cfg->{'URL_HOME'}\">$cfg->{'NAME_HOME'}</a>/" if (($cfg->{'URL_HOME'} ne '') && ($cfg->{'URL_HOME'} ne 'http://***/'));
		my $supportbbs = '';
		$supportbbs = "<a href=\"$cfg->{'URL_BBS_PC'}\">$cfg->{'NAME_BBS_PC'}</a>/" if ($cfg->{'URL_BBS_PC'} ne '');

		$reqvals->{'ua'} = '';
		my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');
		$reqvals->{'css'} = $savecss;

		print <<"_HTML_";
<form action="$urlsow" method="get" class="menu">
<div>
  $urlhome<a href="$urlsow?$linkmb">携帯版</a>/$supportbbs
  <select name="css">
_HTML_

		my $selectedcssid = 'default';
		$selectedcssid = $sow->{'query'}->{'css'} if ($sow->{'query'}->{'css'} ne '');
		$selectedcssid = 'default' if (!defined($cfg->{'CSS'}->{$selectedcssid}));
		my @csskey = keys(%{$cfg->{'CSS'}});
		my $csslist = \@csskey;
		$csslist = $cfg->{'CSS'}->{'ORDER'} if (defined($cfg->{'CSS'}->{'ORDER'}));
		foreach (@$csslist) {
			my $selected = '';
			$selected = " $sow->{'html'}->{'selected'}" if ($_ eq $selectedcssid);
			print "    <option value=\"$_\"$selected>$cfg->{'CSS'}->{$_}->{'TITLE'}$sow->{'html'}->{'option'}\n";
		}

		print <<"_HTML_";
  </select>$hidden
  <input type="submit" value="変更"$net>
</div>
</form>

_HTML_
	}

	&SWHtmlPC::OutHTMLLogin($sow); # ログイン欄の出力

	# 管理人からのお知らせ
	require "./_info.pl";
	&SWAdminInfo::OutHTMLAdminInfo($sow);
	# 概略
	&SWAdminInfo::OutHTMLAbout($sow, $reqvals);


	# 遊び方と仕様FAQ
	&SWAdminInfo::OutHTMLHowto($sow, $reqvals);


	$reqvals->{'cmd'} = 'makevilform';
	$linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	my $linkvmake = "<a href=\"$urlsow?$linkvalue\">村の作成</a>";
	my $caution_vmake = '';

	$caution_vmake = ' <span class="infotext">村を作成する場合はログインして下さい。</span>' if ($sow->{'user'}->logined() <= 0);
	my $vcnt = $vindex->getactivevcnt();
	if ($vcnt >= $sow->{'cfg'}->{'MAX_VILLAGES'}) {
		$linkvmake = "";
		$caution_vmake = ' <span class="infotext">現在稼働中の村の数が上限に達しているので、村を作成できません。</span>';
	}

	if ($sow->{'cfg'}->{'ENABLED_VMAKE'} > 0) {
		print <<"_HTML_";
<h2>村の作成</h2>
<p class="paragraph">
$linkvmake$caution_vmake
</p>
<hr class="invisible_hr"$net>

_HTML_
	}

	my $imgrating = '';
	my $rating = $cfg->{'RATING'};
	my $ratingorder = $rating->{'ORDER'};
	foreach (@$ratingorder) {
		$imgrating .= "<img src=\"$cfg->{'DIR_IMG'}/$rating->{$_}->{'FILE'}\" width=\"$rating->{$_}->{'WIDTH'}\" height=\"$rating->{$_}->{'HEIGHT'}\" alt=\"[$rating->{$_}->{'ALT'}]\" title=\"$rating->{$_}->{'CAPTION'}\"$net> " if ($rating->{$_}->{'FILE'} ne '');
	}

	my $linkrss = " <a href=\"$urlsow?cmd=rss\">RSS</a>";
	$linkrss = '' if ($cfg->{'ENABLED_RSS'} == 0);

	print <<"_HTML_";
<h2>村の一覧</h2>

<p class="paragraph">
名前欄に<img src="$cfg->{'DIR_IMG'}/key.png" width="16" height="16" alt="[鍵]"$net>マークの付いた村は参加時に参加パスワードが必要です。<br$net>
$imgratingマークの付いた村は閲覧制限が付いているか、閲覧時に注意が必要とされている村です。まず村の情報欄を開いて内容を確認しましょう。
</p>

<h3>募集中／開始待ち$linkrss</h3>

_HTML_

	# 募集中／開始待ち村の表示
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'prologue');

	print <<"_HTML_";
<h3>進行中</h3>

_HTML_

	# 進行中の村の表示
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'playing');

	$reqvals->{'cmd'} = 'oldlog';
	$linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	print <<"_HTML_";
<h3>終了済み</h3>

<p class="paragraph">
<a href="$urlsow?$linkvalue">終了済みの村</a>
</p>
<hr class="invisible_hr"$net>

_HTML_

	# 禁止行為（簡略）の表示
	require "$cfg->{'DIR_RS'}/doc_prohibit.pl";
	my $docprohibit = SWDocProhibit->new($sow);
	$docprohibit->outhtmlsimple();

	print <<"_HTML_";
<h2>キャラクター画像一覧</h2>

<ul>
_HTML_

	my $csidlist = $cfg->{'CSIDLIST'};
	foreach (@$csidlist) {
		next if (index($_, '/') >= 0);
		$reqvals->{'cmd'}  = 'chrlist';
		$reqvals->{'csid'} = $_;
		$sow->{'charsets'}->loadchrrs($_);
		$linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
		print "<li><a href=\"$urlsow?$linkvalue\">$sow->{'charsets'}->{'csid'}->{$_}->{'CAPTION'}</a></li>\n";
	}

	print <<"_HTML_";
</ul>
<hr class="invisible_hr"$net>

<h2>更新情報</h2>

_HTML_

	# 更新情報
	require "$cfg->{'DIR_LIB'}/doc_changelog.pl";
	my $docchangelog = SWDocChangeLog->new($sow);
	$docchangelog->outhtmlnew();

	$reqvals->{'cmd'} = 'changelog';
	$reqvals->{'csid'} = '';
	$linkvalue = &SWBase::GetLinkValues($sow, $reqvals);

	print <<"_HTML_";
<hr class="invisible_hr"$net>

<p class="paragraph">
<a href="$urlsow?$linkvalue">更新情報を全て表\示</a>
</p>
<hr class="invisible_hr"$net>

<h2>謝辞</h2>
<p class="paragraph">
このCGIを作成するに辺り、以下のサイトを参考にさせて頂きました。ありがとうございます。
</p>

<ul>
  <li><a href="http://www.wolfg.x0.com/">人狼BBS</a></li>
  <li><a href="http://wolfbbs.jp/">人狼BBS まとめサイト</a></li>
  <li><!--a href="http://www.juna.net/game/wolf/" -->人狼審問 - Neighbour Wolves -<!-- /a --> (終了)</li>
  <li><a href="http://mshe.skr.jp/">人狼BBQ 四国</a></li>
  <li><!-- a href="http://shadow.s63.xrea.com/jinro2/index.cgi" -->汝は人狼なりや？Shadow Gallery Ver 2.0<!-- /a -->（終了）</li>
  <li><!-- a href="http://nekorin.minidns.net/headless/" -->The Village of Headless Knight<!-- /a --> (一時休止中)</li>
  <li><!-- a href="http://www.bonstato.com/werewolves/" -->人狼(oikosバージョン)<!--/a-->（終了）</li>
  <li><!-- a href="http://werewolves.jp/" -->人狼の悪夢 (閉鎖)<!-- /a --></li>
  <li>おとぎの国の人狼（欧州）（閉鎖）</li>
</ul>
<hr class="invisible_hr"$net>

_HTML_

	$vindex->closevindex();
	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTMLフッタの出力
	$sow->{'http'}->outfooter();

	return;
}

#----------------------------------------
# エンティティタグの生成
#----------------------------------------
sub SetHTTPUpdateIndex {
	my ($sow, $infodt, $vindexdt) = @_;

	my $etag = '';
	my $user = $sow->{'user'};
	if ($user->logined() > 0) {
		my $uid = &SWBase::EncodeURL($sow->{'uid'});
		$etag .= sprintf("%s-", $uid);
	}
	$etag .= sprintf("index-%x-%x", $infodt, $vindexdt);

	$sow->{'http'}->{'etag'} = $etag;
	$sow->{'http'}->{'lastmodified'} = $vindexdt;
	$sow->{'http'}->{'lastmodified'} = $infodt if ($infodt > $vindexdt);

	return;
}

1;
