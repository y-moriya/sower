package SWHtmlDialog;

#----------------------------------------
# �m�F��ʂ�HTML�o��
#----------------------------------------
sub OutHTMLDialog {
    my $sow   = $_[0];
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};

    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";

    # ���f�[�^�̓ǂݍ���
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();
    $vil->closevil();

    # ���\�[�X�̓ǂݍ���
    &SWBase::LoadVilRS( $sow, $vil );

    my %dialog = ( cmd => 'none', );
    if ( $query->{'cmd'} eq 'exitpr' ) {
        %dialog = (
            cmd           => 'exit',
            text          => '������o�܂����H',
            buttoncaption => '������o��',
        );
    }
    elsif ( $query->{'cmd'} eq 'selrolepr' ) {
        %dialog = (
            cmd           => 'selrole',
            text          => '��]��E��ύX���܂����H',
            buttoncaption => '�ύX',
        );
    }
    elsif ( $query->{'cmd'} eq 'startpr' ) {
        %dialog = (
            cmd           => 'start',
            text          => '�����J�n���܂����H',
            buttoncaption => '�J�n',
        );
    }
    elsif ( $query->{'cmd'} eq 'updatepr' ) {
        %dialog = (
            cmd           => 'update',
            text          => '�����X�V���܂����H',
            buttoncaption => '�X�V',
        );
    }
    elsif ( $query->{'cmd'} eq 'scrapvilpr' ) {
        %dialog = (
            cmd           => 'scrapvil',
            text          => '�p�����܂����H',
            buttoncaption => '�p��',
        );
    }
    elsif ( $query->{'cmd'} eq 'extendpr' ) {
        %dialog = (
            cmd           => 'extend',
            text          => "�p����$query->{'extenddate'}���������܂����H",
            buttoncaption => '����',
        );
    }
    elsif ( $query->{'cmd'} eq 'chatmodepr' ) {
        %dialog = (
            cmd           => 'chatmode',
            text          => '�G�k����L�������܂����H',
            buttoncaption => '�ύX',
        );
    }

    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "����`�̍s���ł��B", "invalid cmd." )
      if ( $dialog{'cmd'} eq 'none' );

    require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
    $sow->{'html'} = SWHtml->new($sow);    # HTML���[�h�̏�����
    $sow->{'http'}->outheader();           # HTTP�w�b�_�̏o��
    $sow->{'html'}->outheader('���̏��');     # HTML�w�b�_�̏o��
    $sow->{'html'}->outcontentheader();
    my $net = $sow->{'html'}->{'net'};     # Null End Tag

    # ���O�C���{�^���\��
    &SWHtmlPC::OutHTMLLogin($sow);

    # ���t�ʃ��O�ւ̃����N
    &SWHtmlPC::OutHTMLTurnNavi( $sow, $vil );

    my @reqkeys = ( 'csid_cid', 'role', 'mes', 'think', 'wolf', 'maker', 'admin', 'extenddate' );
    my $reqvals = &SWBase::GetRequestValues( $sow, \@reqkeys );
    my $hidden  = &SWBase::GetHiddenValues( $sow, $reqvals, '' );

    print <<"_HTML_";
<h2>�s���m�F</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="paragraph">$dialog{'text'}</p>

<p class="paragraph">
  <input type="hidden" name="cmd" value="$dialog{'cmd'}"$net>$hidden
  <input type="submit" value="$dialog{'buttoncaption'}" data-submit-type="$query->{'cmd'}"$net>
</p>
</form>
_HTML_

    &SWHtmlPC::OutHTMLReturnPC($sow);    # �g�b�v�y�[�W�֖߂�

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();         # HTML�t�b�^�̏o��
    $sow->{'http'}->outfooter();

    return;
}

1;
