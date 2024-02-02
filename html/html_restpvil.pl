package SWHtmlRestPlayingVil;

#----------------------------------------
# �Q�����̑��ꗗ�N���A��ʂ�HTML�o��
#----------------------------------------
sub OutHTMLRestPlayingVil {
    my $sow   = shift;
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};
    my $net   = $sow->{'html'}->{'net'};    # Null End Tag

    &SWHtmlPC::OutHTMLLogin($sow);          # ���O�C�����̏o��

    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'cmd'} = 'restpvil';
    my $hidden = &SWBase::GetHiddenValues( $sow, $reqvals, '  ' );

    if ( $query->{'cmd'} eq 'restpvil' ) {
        print "<p class=\"info\">\n�Q�����̑��ꗗ���N���A���܂����B\n</p>\n\n";
    }

    print <<"_HTML_";
<h2>�Q�����̑��ꗗ�̃N���A</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$hidden
  <input type="submit" value="�N���A" data-submit-type="restpvil"$net>
</p>
</form>
<hr class="invisible_hr"$net>

<p class="paragraph">
�Ȃ�炩�̗��R�ŎQ�����̑��ꗗ���j�������ꍇ�ɑS���폜���鎖���ł��܂��B
</p>

<p class="paragraph">
�N���A���邾���ŁA���ݎQ�����̑��ɂ��Ă͍Ď擾���s��Ȃ����߁A�����Ă��܂��܂��i�ēx���蒼���Ώo��j�B�f�[�^�\\�����ω�������A�S�~���c�����ꍇ�Ɏg�p���Ă��������B
</p>

<p class="paragraph">
�����̃��[�U�[�����݂��鎞�ɑ��ꗗ�̃N���A���s����<strong class="cautiontext">����Ȃ�ɕ��ׂ�������܂�</strong>�̂ŁA���ӂ��ĉ������B
</p>
<hr class="invisible_hr"$net>

_HTML_

    &SWHtmlPC::OutHTMLReturnPC($sow);    # �g�b�v�y�[�W�֖߂�

    return;
}

1;
