package SWHtmlEditPenalty;

#----------------------------------------
# �y�i���e�B�ҏW��ʂ�HTML�o��
#----------------------------------------
sub OutHTMLEditPenalty {
    my $sow   = shift;
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};
    my $net   = $sow->{'html'}->{'net'};    # Null End Tag

    &SWHtmlPC::OutHTMLLogin($sow);          # ���O�C�����̏o��

    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'cmd'} = 'editpenalty';
    my $hidden = &SWBase::GetHiddenValues( $sow, $reqvals, '  ' );

    if ( $query->{'cmd'} eq 'editpenalty' ) {
        print "<p class=\"info\">\n�y�i���e�B�̐ݒ�E�������s���܂����B\n</p>\n\n";
    }

    print <<"_HTML_";
<h2>�y�i���e�B�̐ݒ�E����</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$hidden
  <input type="submit" value="�č\\�z"$net>
</p>
</form>
<hr class="invisible_hr"$net>

<p class="paragraph">
�y�i���e�B
</p>
<hr class="invisible_hr"$net>

_HTML_

    &SWHtmlPC::OutHTMLReturnPC($sow);    # �g�b�v�y�[�W�֖߂�

    return;
}

1;
