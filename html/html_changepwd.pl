package SWHtmlChangePwd;

#----------------------------------------
# ���쐬������ʂ�HTML�o��
#----------------------------------------
sub OutHTMLChangePwd {
    my $sow   = $_[0];
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};

    $sow->{'html'} = SWHtml->new($sow);    # HTML���[�h�̏�����
    my $net = $sow->{'html'}->{'net'};     # Null End Tag
    $sow->{'http'}->outheader();                  # HTTP�w�b�_�̏o��
    $sow->{'html'}->outheader("$vmode����");    # HTML�w�b�_�̏o��
    $sow->{'html'}->outcontentheader();

    &SWHtmlPC::OutHTMLLogin($sow);                # ���O�C���{�^���\��

    print <<"_HTML_";
<h2>�p�X���[�h�ύX����</h2>

<p class="info">�p�X���[�h��ύX���܂����B</p>

_HTML_

    &SWHtmlPC::OutHTMLReturnPC($sow);             # �g�b�v�y�[�W�֖߂�

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();                  # HTML�t�b�^�̏o��
    $sow->{'http'}->outfooter();

    return;
}

1;
