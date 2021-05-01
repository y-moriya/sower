package SWCmdEditVilForm;

#----------------------------------------
# ���ҏW�\��
#----------------------------------------
sub CmdEditVilForm {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # ���f�[�^�̓ǂݍ���
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";
    $sow->{'debug'}
      ->raise( $sow->{'APLOG_CAUTION'}, "���O�C�����ĉ������B", "no login.$errfrom" )
      if ( $sow->{'user'}->logined() <= 0 );
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        "���쐬�҈ȊO�ɂ͑��̕ҏW�͍s���܂���B", "no permition.$errfrom" )
      if ( ( $sow->{'uid'} ne $vil->{'makeruid'} )
        && ( $sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'} ) );

    require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
    require "$sow->{'cfg'}->{'DIR_HTML'}/html_makevilform.pl";

    # ���쐬��ʂ�HTML�o��
    &SWHtmlMakeVilForm::OutHTMLMakeVilForm( $sow, $vil );
}

1;
