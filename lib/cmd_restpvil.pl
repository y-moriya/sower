package SWCmdRestPlayingVil;

#----------------------------------------
# �Q�����̑��ꗗ�N���A����
# ���č\�z�ɂ��悤���Ǝv�������ǁA�R�X�g������̂ŃN���A�݂̂ŁB
#   ���ݎQ�����̑��������Ă��܂����A���蒼�����肷��Ε\�������B
#----------------------------------------
sub CmdRestPlayingVil {
	my $sow = $_[0];
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	# �f�[�^����
	&SetDataCmdRestPlayingVil($sow);

	# HTTP/HTML�o��
	&OutHTMLCmdRestPlayingVil($sow);
}

#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdRestPlayingVil {
	my $sow = $_[0];
	my $query  = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	$sow->{'debug'}->raise($sow->{'APLOG_NOTICE'}, "�Ǘ��l�������K�v�ł��B", "no permition.$errfrom") if ($sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'});

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
# HTML�o��
#----------------------------------------
sub OutHTMLCmdRestPlayingVil {
	my $sow = $_[0];
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};

	# HTML�o�͗p���C�u�����̓ǂݍ���
	require "$cfg->{'DIR_HTML'}/html.pl";
	require "$cfg->{'DIR_HTML'}/html_restpvil.pl";

	$sow->{'html'} = SWHtml->new($sow); # HTML���[�h�̏�����
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $outhttp = $sow->{'http'}->outheader(); # HTTP�w�b�_�̏o��
	return if ($outhttp == 0); # �w�b�_�o�͂̂�
	$sow->{'html'}->outheader('�Q�����̑��ꗗ�č\�z'); # HTML�w�b�_�̏o��
	$sow->{'html'}->outcontentheader();

	&SWHtmlRestPlayingVil::OutHTMLRestPlayingVil($sow);

	$sow->{'html'}->outcontentfooter();
	$sow->{'html'}->outfooter(); # HTML�t�b�^�̏o��
	$sow->{'http'}->outfooter();
}

1;