package SWHtmlMakeVil;

#----------------------------------------
# ���쐬������ʂ�HTML�o��
#----------------------------------------
sub OutHTMLMakeVil {
    my ( $sow, $vil ) = @_;
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};

    my $vmode    = '�쐬';
    my $infotext = '���쐬';
    if ( $sow->{'query'}->{'cmd'} eq 'editvil' ) {
        $vmode    = '�ҏW';
        $infotext = '�̐ݒ��ύX';
    }

    $sow->{'html'} = SWHtml->new($sow);       # HTML���[�h�̏�����
    my $net = $sow->{'html'}->{'net'};        # Null End Tag
    $sow->{'http'}->outheader();              # HTTP�w�b�_�̏o��
    $sow->{'html'}->outheader("$vmode����");    # HTML�w�b�_�̏o��
    $sow->{'html'}->outcontentheader();

    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'vid'} = $query->{'vid'};
    my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
    my $urlsow    = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

    &SWHtmlPC::OutHTMLLogin($sow);            # ���O�C���{�^���\��

    print <<"_HTML_";
<h2>$vmode����</h2>

<p class="info"><a href="$urlsow?$linkvalue">$query->{'vid'} $query->{'vname'}</a>$infotext���܂����B</p>

_HTML_

    &SWHtmlPC::OutHTMLReturnPC($sow);         # �g�b�v�y�[�W�֖߂�

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();              # HTML�t�b�^�̏o��
    $sow->{'http'}->outfooter();

    return;
}

1;
