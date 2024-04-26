package SWCmdEnableChatMode;

#----------------------------------------
# �G�k���ɕύX
#----------------------------------------
sub CmdEnableChatMode {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # �f�[�^����
    my $vil = &SetDataCmdEnableChatMode($sow);

    # HTTP/HTML�o��
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

    $sow->{'http'}->{'location'} = "$link";
    $sow->{'http'}->outheader();    # HTTP�w�b�_�̏o��
    $sow->{'http'}->outfooter();
}

#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdEnableChatMode {
    my $sow     = $_[0];
    my $query   = $sow->{'query'};
    my $debug   = $sow->{'debug'};
    my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

    # ���f�[�^�̓ǂݍ���
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # ���\�[�X�̓ǂݍ���
    &SWBase::LoadVilRS( $sow, $vil );

    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, "�Ǘ��l�������K�v�ł��B", "no permition.$errfrom" )
      if ( $sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'} );

    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, '�i�s���͎G�k���ɕύX�ł��܂���B', "chatmode can not change.$errfrom" )
      if ( $vil->{'turn'} > 0 );

    # �ύX����
    $vil->{'chatmode'} = 1;

    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";

    $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Enable Chat Mode. [$sow->{'curpl'}->{'uid'}]" );
    $vil->writevil();
    $vil->closevil();

    return $vil;
}

1;
