package SWHtmlDocument;

#----------------------------------------
# �h�L�������g��ʂ�HTML�o��
#----------------------------------------
sub OutHTMLDocument {
    my $sow = $_[0];
    my $cfg = $sow->{'cfg'};

    require "$cfg->{'DIR_HTML'}/html.pl";
    my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

    my $cmd = $sow->{'query'}->{'cmd'};
    my $doc;

    if ( $cmd eq 'howto' ) {
        require "$cfg->{'DIR_RS'}/doc_howto.pl";
        $doc = SWDocHowTo->new($sow);
    }
    elsif ( $cmd eq 'prohibit' ) {
        require "$cfg->{'DIR_RS'}/doc_prohibit.pl";
        $doc = SWDocProhibit->new($sow);
    }
    elsif ( $cmd eq 'about' ) {
        require "$cfg->{'DIR_RS'}/doc_about.pl";
        $doc = SWDocAbout->new($sow);
    }
    elsif ( $cmd eq 'operate' ) {
        require "$cfg->{'DIR_RS'}/doc_operate.pl";
        $doc = SWDocOperate->new($sow);
    }
    elsif ( $cmd eq 'spec' ) {
        require "$cfg->{'DIR_LIB'}/doc_spec.pl";
        $doc = SWDocSpec->new($sow);
    }
    else {
        require "$cfg->{'DIR_LIB'}/doc_changelog.pl";
        $doc = SWDocChangeLog->new($sow);
    }

    $sow->{'html'} = SWHtml->new($sow);    # HTML���[�h�̏�����
    my $net     = $sow->{'html'}->{'net'};        # Null End Tag
    my $outhttp = $sow->{'http'}->outheader();    # HTTP�w�b�_�̏o��
    return if ( $outhttp == 0 );                  # �w�b�_�o�͂̂�
    $sow->{'html'}->outheader( $doc->{'title'} ); # HTML�w�b�_�̏o��
    $sow->{'html'}->outcontentheader();

    &SWHtmlPC::OutHTMLLogin($sow);                # ���O�C�����̏o��
    $doc->outhtml();                              # �{���o��
    &SWHtmlPC::OutHTMLReturnPC($sow);             # �g�b�v�y�[�W�֖߂�

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();                  # HTML�t�b�^�̏o��
    $sow->{'http'}->outfooter();

    return;
}

1;
