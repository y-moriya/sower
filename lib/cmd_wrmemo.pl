package SWCmdWriteMemo;

#----------------------------------------
# ������������
#----------------------------------------
sub CmdWriteMemo {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # �f�[�^����
    my ( $vil, $checknosay ) = &SetDataCmdWriteMemo($sow);

    # HTTP/HTML�o��
    if ( $sow->{'outmode'} eq 'mb' ) {
        require "$sow->{'cfg'}->{'DIR_LIB'}/cmd_memo.pl";
        $sow->{'query'}->{'cmd'}     = 'memo';
        $sow->{'query'}->{'cmdfrom'} = 'wrmemo';
        &SWCmdMemo::CmdMemo($sow);
    }
    else {
        my $reqvals = &SWBase::GetRequestValues($sow);
        $reqvals->{'cmd'}  = 'memo';
        $reqvals->{'turn'} = '';
        my $link = &SWBase::GetLinkValues( $sow, $reqvals );
        $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

        $sow->{'http'}->{'location'} = "$link";
        $sow->{'http'}->outheader();    # HTTP�w�b�_�̏o��
        $sow->{'http'}->outfooter();
    }
}

#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdWriteMemo {
    my $sow     = $_[0];
    my $cfg     = $sow->{'cfg'};
    my $query   = $sow->{'query'};
    my $debug   = $sow->{'debug'};
    my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

    # ���f�[�^�̓ǂݍ���
    require "$cfg->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # ���\�[�X�̓ǂݍ���
    &SWBase::LoadVilRS( $sow, $vil );

    # �����O�֘A��{���͒l�`�F�b�N
    require "$cfg->{'DIR_LIB'}/vld_vil.pl";
    &SWValidityVil::CheckValidityVil( $sow, $vil );

    my $writepl = &SWBase::GetCurrentPl( $sow, $vil );
    $debug->raise( $sow->{'APLOG_NOTICE'}, "���Ȃ��͎���ł��܂��B", "you dead.[$errfrom]" )
      if ( ( $writepl->{'live'} ne 'live' ) && ( $vil->isepilogue() == 0 ) );

    # �c��A�N�V�������[���̎�
    require "$sow->{'cfg'}->{'DIR_LIB'}/write.pl";
    my ( $dummy, $saytype ) = &SWWrite::GetMesType( $sow, $vil, $writepl );
    $debug->raise(
        $sow->{'APLOG_NOTICE'},
        "�A�N�V����������܂���B",
        "not enough saypoint.[$saytype: $writepl->{$saytype} / 1]"
    ) if ( $writepl->{$saytype} <= 0 );

    # �s���E�������̎擾�̎擾
    my $mes           = $query->{'mes'};
    my @lineslog      = split( '<br>', $mes );
    my $lineslogcount = @lineslog;
    my $countmes      = &SWString::GetCountStr( $sow, $vil, $mes );

    # �s���^�����������x��
    $debug->raise(
        $sow->{'APLOG_NOTICE'},
"�s�����������܂��i$lineslogcount�s�j�B$cfg->{'MAXSIZE_MEMOLINE'}�s�ȓ��Ɏ��߂Ȃ��Ə������߂܂���B",
        "too many mes lines.$errfrom"
    ) if ( $lineslogcount > $cfg->{'MAXSIZE_MEMOLINE'} );
    my $unitcaution =
      $sow->{'basictrs'}->{'SAYTEXT'}->{ $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} }->{'COUNT_TYPE'} }
      ->{'UNIT_CAUTION'};
    $debug->raise(
        $sow->{'APLOG_NOTICE'},
"�������������܂��i$countmes$unitcaution�j�B$cfg->{'MAXSIZE_MEMOCNT'}$unitcaution�ȓ��Ɏ��߂Ȃ��Ə������߂܂���B",
        "too many mes.$errfrom"
    ) if ( $countmes > $cfg->{'MAXSIZE_MEMOCNT'} );
    my $lenmes = length( $query->{'mes'} );
    $debug->raise(
        $sow->{'APLOG_NOTICE'},
        "�������Z�����܂��i$lenmes �o�C�g�j�B$cfg->{'MINSIZE_MEMOCNT'} �o�C�g�ȏ�K�v�ł��B",
        "memo too short.$errfrom"
    ) if ( ( $lenmes < $cfg->{'MINSIZE_MEMOCNT'} ) && ( $lenmes != 0 ) );

    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
    my $checknosay = &SWString::CheckNoSay( $sow, $query->{'mes'} );

    my $memofile = SWSnake->new( $sow, $vil, $vil->{'turn'}, 0 );
    my $newmemo = $memofile->getnewmemo($writepl);
    $debug->raise( $sow->{'APLOG_NOTICE'}, '������\���Ă��܂���B', "memo not found.$errfrom" )
      if ( ( $checknosay == 0 ) && ( $newmemo->{'log'} eq '' ) );

    # �����f�[�^�t�@�C���ւ̏�������
    my $mestype   = $sow->{'MEMOTYPE_MEMO'};
    my $monospace = 0;
    $monospace = 1 if ( $query->{'monospace'} ne '' );

    if ( $checknosay == 0 ) {
        $mestype = $sow->{'MEMOTYPE_DELETED'};

        #		$mes = $sow->{'DATATEXT_NONE'};
        $mes = '';
    }

    my %say = (
        uid     => $writepl->{'uid'},
        mes     => $mes,
        mestype => $sow->{'MESTYPE_SAY'},
    );
    $mes = &SWLog::ReplaceAnchor( $sow, $vil, \%say );
    my %memo = (
        logid     => sprintf( "%05d", $vil->{'cntmemo'} ),
        mestype   => $mestype,
        uid       => $writepl->{'uid'},
        cid       => $writepl->{'cid'},
        csid      => $writepl->{'csid'},
        chrname   => $writepl->getchrname(),
        date      => $sow->{'time'},
        log       => $mes,
        monospace => $monospace,
    );
    $memofile->add( \%memo );
    $vil->{'cntmemo'}++;

    # ���O�f�[�^�t�@�C���ւ̏�������
    if ( $checknosay > 0 ) {

        # ������\��
        $query->{'mes'} = '������\�����B';
        &SWWrite::ExecuteCmdWrite( $sow, $vil, $writepl, $memo{'logid'} );

        $debug->writeaplog( $sow->{'APLOG_POSTED'}, "WriteMemo. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]" );
    }
    else {
        # �������͂���
        $query->{'mes'} = '�������͂������B';
        &SWWrite::ExecuteCmdWrite( $sow, $vil, $writepl, $memo{'logid'} );

        $debug->writeaplog( $sow->{'APLOG_POSTED'}, "DeleteMemo. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]" );
    }
    $vil->closevil();

    return ( $vil, $checknosay );
}

1;
