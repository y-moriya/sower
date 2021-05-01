package SWCmdRoleList;

#----------------------------------------
# ��E�ꗗ�\��
#----------------------------------------
sub CmdRoleList {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
    require "$sow->{'cfg'}->{'DIR_HTML'}/html_rolelist.pl";
    my $title = &SWHtmlRoleList::GetHTMLRoleListTitle();

    $sow->{'html'} = SWHtml->new($sow);    # HTML���[�h�̏�����
    my $net = $sow->{'html'}->{'net'};     # Null End Tag
    $sow->{'http'}->outheader();           # HTTP�w�b�_�̏o��
    $sow->{'html'}->outheader($title);     # HTML�w�b�_�̏o��
    $sow->{'html'}->outcontentheader('');

    &SWHtmlPC::OutHTMLLogin($sow);         # ���O�C���{�^��

    # ��E�ꗗ��ʂ�HTML�o��
    &SWHtmlRoleList::OutHTMLRoleList($sow);

    &SWHtml::OutHTMLReturn($sow);          # �g�b�v�y�[�W�֖߂�

    $sow->{'html'}->outcontentfooter('');
    $sow->{'html'}->outfooter();           # HTML�t�b�^�̏o��
    $sow->{'http'}->outfooter();

}

1;
