package SWHtmlIndex;

#----------------------------------------
# �g�b�v�y�[�W��HTML�o��
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

	# ���ꗗ�f�[�^�ǂݍ���
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

	$sow->{'http'}->setnotmodified(); # �ŏI�X�V����

	# HTTP/HTML�̏o��
	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $outhttp = $sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->{'rss'} = "$urlsow?cmd=rss"; # ���̈ꗗ��RSS
	$sow->{'html'}->outheader($cfg->{'NAME_TOP'}); # HTML�w�b�_�̏o��
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
  $urlhome<a href="$urlsow?$linkmb">�g�є�</a>/$supportbbs
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
  <input type="submit" value="�ύX"$net>
</div>
</form>

_HTML_
	}

	&SWHtmlPC::OutHTMLLogin($sow); # ���O�C�����̏o��

	# �Ǘ��l����̂��m�点
	require "./_info.pl";
	&SWAdminInfo::OutHTMLAdminInfo($sow);
	# �T��
	&SWAdminInfo::OutHTMLAbout($sow, $reqvals);


	# �V�ѕ��Ǝd�lFAQ
	&SWAdminInfo::OutHTMLHowto($sow, $reqvals);


	$reqvals->{'cmd'} = 'makevilform';
	$linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	my $linkvmake = "<a href=\"$urlsow?$linkvalue\">���̍쐬</a>";
	my $caution_vmake = '';

	$caution_vmake = ' <span class="infotext">�����쐬����ꍇ�̓��O�C�����ĉ������B</span>' if ($sow->{'user'}->logined() <= 0);
	my $vcnt = $vindex->getactivevcnt();
	if ($vcnt >= $sow->{'cfg'}->{'MAX_VILLAGES'}) {
		$linkvmake = "";
		$caution_vmake = ' <span class="infotext">���݉ғ����̑��̐�������ɒB���Ă���̂ŁA�����쐬�ł��܂���B</span>';
	}

	if ($sow->{'cfg'}->{'ENABLED_VMAKE'} > 0) {
		print <<"_HTML_";
<h2>���̍쐬</h2>
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
<h2>���̈ꗗ</h2>

<p class="paragraph">
���O����<img src="$cfg->{'DIR_IMG'}/key.png" width="16" height="16" alt="[��]"$net>�}�[�N�̕t�������͎Q�����ɎQ���p�X���[�h���K�v�ł��B<br$net>
$imgrating�}�[�N�̕t�������͉{���������t���Ă��邩�A�{�����ɒ��ӂ��K�v�Ƃ���Ă��鑺�ł��B�܂����̏�񗓂��J���ē��e���m�F���܂��傤�B
</p>

<h3>��W���^�J�n�҂�$linkrss</h3>

_HTML_

	# ��W���^�J�n�҂����̕\��
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'prologue');

	print <<"_HTML_";
<h3>�i�s��</h3>

_HTML_

	# �i�s���̑��̕\��
	&SWHtmlVIndex::OutHTMLVIndex($sow, $vindex, 'playing');

	$reqvals->{'cmd'} = 'oldlog';
	$linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	print <<"_HTML_";
<h3>�I���ς�</h3>

<p class="paragraph">
<a href="$urlsow?$linkvalue">�I���ς݂̑�</a>
</p>
<hr class="invisible_hr"$net>

_HTML_

	# �֎~�s�ׁi�ȗ��j�̕\��
	require "$cfg->{'DIR_RS'}/doc_prohibit.pl";
	my $docprohibit = SWDocProhibit->new($sow);
	$docprohibit->outhtmlsimple();

	print <<"_HTML_";
<h2>�L�����N�^�[�摜�ꗗ</h2>

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

<h2>�X�V���</h2>

_HTML_

	# �X�V���
	require "$cfg->{'DIR_LIB'}/doc_changelog.pl";
	my $docchangelog = SWDocChangeLog->new($sow);
	$docchangelog->outhtmlnew();

	$reqvals->{'cmd'} = 'changelog';
	$reqvals->{'csid'} = '';
	$linkvalue = &SWBase::GetLinkValues($sow, $reqvals);

	print <<"_HTML_";
<hr class="invisible_hr"$net>

<p class="paragraph">
<a href="$urlsow?$linkvalue">�X�V����S�ĕ\\��</a>
</p>
<hr class="invisible_hr"$net>

<h2>�ӎ�</h2>
<p class="paragraph">
����CGI���쐬����ɕӂ�A�ȉ��̃T�C�g���Q�l�ɂ����Ē����܂����B���肪�Ƃ��������܂��B
</p>

<ul>
  <li><a href="http://www.wolfg.x0.com/">�l�TBBS</a></li>
  <li><a href="http://wolfbbs.jp/">�l�TBBS �܂Ƃ߃T�C�g</a></li>
  <li><!--a href="http://www.juna.net/game/wolf/" -->�l�T�R�� - Neighbour Wolves -<!-- /a --> (�I��)</li>
  <li><a href="http://mshe.skr.jp/">�l�TBBQ �l��</a></li>
  <li><!-- a href="http://shadow.s63.xrea.com/jinro2/index.cgi" -->���͐l�T�Ȃ��HShadow Gallery Ver 2.0<!-- /a -->�i�I���j</li>
  <li><!-- a href="http://nekorin.minidns.net/headless/" -->The Village of Headless Knight<!-- /a --> (�ꎞ�x�~��)</li>
  <li><!-- a href="http://www.bonstato.com/werewolves/" -->�l�T(oikos�o�[�W����)<!--/a-->�i�I���j</li>
  <li><!-- a href="http://werewolves.jp/" -->�l�T�̈��� (��)<!-- /a --></li>
  <li>���Ƃ��̍��̐l�T�i���B�j�i���j</li>
</ul>
<hr class="invisible_hr"$net>

_HTML_

	$vindex->closevindex();
	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();

	return;
}

#----------------------------------------
# �G���e�B�e�B�^�O�̐���
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
