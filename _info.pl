package SWAdminInfo;

#----------------------------------------
# �Ǘ��l����̂��m�点
#----------------------------------------
sub OutHTMLAdminInfo {
	my $sow = shift;
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};

	print <<"_HTML_";
<h2>�Ǘ��l����̂��m�点</h2>
2018/12/xx
<ul>
<li>��������ꂵ�܂����B
</ul>
_HTML_

}

#----------------------------------------
# �͂��߂�
#----------------------------------------
sub OutHTMLAbout {
	my ($sow, $reqvals) = @_;
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	$reqvals->{'cmd'} = 'about';
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);

	print <<"_HTML_";
<h2>�͂��߂�</h2>
<p class="paragraph">
���A�[�����̐l�T�T�[�o������܂����B<br$net>
�o�O���c���Ă��邩������܂���̂ŁA�����O���ɂ����Ă��Q�����������B<br$net>
���[��������Ă���������Ȃ�΁A�N�ł����R�ɑ������ĂĒ����Č��\\�ł��B<br$net>
�����ݒ�ɏ]���K�v������܂���B<br$net>
�܂��A��摺�ȂǂŎQ���ґS���̍��ӂ�����΁A���[���𖳎����Ă��\\���܂���B
</p>
<h3>$sow->{'cfg'}->{'NAME_SW'}�Ƃ́H</h3>
<p class="paragraph">
�w���A�����[�������Ȃ���l�T�ŗV�ԁx���Ƃ�ړI�Ƃ������ł��B
�u�Z�����đ��ɓ���Ȃ��v�u���T�̓e�X�g������l�T�͒��߂悤�v�Ƃ��������A�����[�����Ă���l�ł��A�󂢂����ԂɌy���`�F�b�N���邾���ŗV�ׂ�l�T�𗝑z�Ƃ��Ă��܂��B
�]���̍��Ƃ̓��[���⑺�̐����ݒ�Ȃǂ��Ⴄ���߁A�Œ�ł��������ɂ���u���[���v�Ɓu�������Ă��鑺�̐ݒ�v��ǂ񂾏�ŎQ�����Ă��������B
</p>

<h3>���[��</h3>
<ul>
<li>�����̃��A����厖�ɂ��邱�ƁB</li>
<li>��ʂ̌������ɂ��鑊��̃��A����厖�ɂ��邱�ƁB</li>
<li><b>�܂Ƃߖ𐧓x�͋֎~</b>�i������l��ł��j�B���̍��ɂ�����<a href="$urlsow?$linkvalue">�l��̒�`</a>�ɂ��Ă���ǂ��������B</li>
</ul>

<h3>�������Ă��鑺�̐ݒ�i�f�t�H���g�̐ݒ�j</h3>
<p class="paragraph">
���̐ݒ�̑S�Ă������ɏ����Ă���킯�ł͂���܂���B<br$net>
�����炭�]���̃X�^���_�[�h�ƂȂ��Ă�����̂���O��Ă���Ƃ��낾���𔲂��o���Ă��܂��B
</p>
<ul>
<li>��E��]����</li>
<li>�ϔC�s��</li>
<li>�扺���J�i���j</li>
<li>�����s��</li>
<li>���R���A�N�V�����s�i�A�N�V�����͒�^���̂݁j</li>
<li>�����Ȃ�</li>
<li>�����̊ȗ��\\��</li>
</ul>
<p class="paragraph">
���R�Ȃ��琄�����Ă��邾���ŋ����ł͂���܂���̂ŁA�����Ƃɐݒ肪�Ⴄ�ꍇ������܂��B<br$net>
���ɎQ������ꍇ�͂��̑��̏�񗓂��悭�ǂ񂾏�ŎQ�����Ă��������B
</p>

<p class="paragraph">
���扺���J�Ƃ́c�c���̃I�v�V�������I���̏ꍇ�A�l�T�̚����A���҂̋��A�R�E�����l�Ԃ̔O�b���E�Ɋ֌W�Ȃ��扺���猩�邱�Ƃ��o���܂��B<br$net>
�܂��A�����t�B���^�[�����ɎQ���ґS���̖�E���\\������܂��B
</p>

<!--

<p class="paragraph">

<a href="$urlsow?$linkvalue">$sow->{'cfg'}->{'NAME_SW'}�Ƃ́H</a>
</p>
-->
<hr class="invisible_hr"$net>
_HTML_

}

#----------------------------------------
# �V�ѕ��Ǝd�lFAQ
#----------------------------------------
sub OutHTMLHowto {
	my ($sow, $reqvals) = @_;
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	$reqvals->{'cmd'} = 'howto';
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'operate';
	my $linkoperate = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'spec';
	my $linkspec = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'rolematrix';
	my $linkrolematrix = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'rolelist';
	my $linkrolelist = &SWBase::GetLinkValues($sow, $reqvals);

	print <<"_HTML_";
<h2>�V�ѕ�</h2>
<p class="paragraph">
���߂Ă̕��́A�܂�<a href="$urlsow?$linkvalue">�V�ѕ�</a>�A<a href="$urlsow?$linkoperate">������@</a>�A<a href="#prohibit">�֎~�s��</a>���悭�ǂ�ł���Q�����܂��傤�B<br$net>
���̐l�T�N���[����V�񂾎��̂�����́A�܂�<a href="$urlsow?$linkspec">���̐l�T�N���[���Ƃ̈Ⴂ�i�d�lFAQ�j</a>��ǂނƂ悢�ł��傤�B<br$net>
</p>

<p class="paragraph">
��E�z���̓����m�肽���ꍇ��<a href="$urlsow?$linkrolematrix">��E�z���ꗗ�\\</a>�����ĉ������B<br$net>
�\\�͎҂̔\\�͗��⌋�ʕ\\����m�肽���ꍇ��<a href="$urlsow?$linkrolelist">��E�ƃC���^�[�t�F�C�X\</a>�����ĉ������B
</p>
<hr class="invisible_hr"$net>

_HTML_

}

1;