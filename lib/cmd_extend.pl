package SWCmdExtend;

#----------------------------------------
# ���������i�b��j
#----------------------------------------
sub CmdExtend {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # �f�[�^����
    my $vil = &SetDataCmdExtend($sow);

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
sub SetDataCmdExtend {
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
    if ( $vil->{'turn'} == 0 ) {

        # �J�n�O�͔p����������������B
        $vil->{'scraplimitdt'} = $vil->{'scraplimitdt'} + 24 * 60 * 60 * $query->{'extenddate'};
    }
    else {

        # �i�s���͎��̍X�V���Ԃ���������B����A������Ăׂ�C���^�[�t�F�[�X�͂Ȃ��B
        $vil->{'nextupdatedt'} = $vil->{'nextupdatedt'} + 24 * 60 * 60 * $query->{'extenddate'};
    }
    $vil->writevil();
    $vil->closevil();

    return $vil;
}

1;
