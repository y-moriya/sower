package SWValidityStart;

#----------------------------------------
# ���蓮�J�n���l�`�F�b�N
#----------------------------------------
sub CheckValidityStart {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $debug = $sow->{'debug'};

    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();
    my $pllist = $vil->getpllist();
    $vil->closevil();

    my $errfrom = "[uid=$sow->{'uid'}, vid=$vil->{'vid'}, cmd=$query->{'cmd'}]";

    # ���\�[�X�̓ǂݍ���
    &SWBase::LoadVilRS( $sow, $vil );

    $debug->raise( $sow->{'APLOG_CAUTION'}, "���O�C���H���ĉ������B", "no login.$errfrom" )
      if ( $sow->{'user'}->logined() <= 0 );
    $debug->raise(
        $sow->{'APLOG_CAUTION'},
        "�����J�n����ɂ͑����Đl�������Ǘ��l�������K�v�ł��B",
        "no permition.$errfrom"
      )
      if ( ( $sow->{'uid'} ne $vil->{'makeruid'} )
        && ( $sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'} ) );
    $debug->raise(
        $sow->{'APLOG_CAUTION'},
        "�l��������܂���B�_�~�[�L�������܂߁A�Œ� 4 �l�K�v�ł��B",
        "need 4 persons.$errfrom"
    ) if ( @$pllist < 4 );
    $debug->raise(
        $sow->{'APLOG_CAUTION'},
        "���ݎQ�����Ă���l���ƒ��������������܂���B",
        "invalid vplcnt or total plcnt.$errfrom"
      )
      if ( ( @$pllist != $vil->{'vplcnt'} )
        && ( $vil->{'roletable'} eq 'custom' ) );
    $debug->raise( $sow->{'APLOG_CAUTION'}, "�����J�n���Ă��܂��B", "game started." )
      unless ( $vil->isprologue() > 0 );

    return;
}

#----------------------------------------
# ���蓮�X�V���l�`�F�b�N
#----------------------------------------
sub CheckValidityUpdate {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $debug = $sow->{'debug'};

    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();
    my $pllist = $vil->getpllist();
    $vil->closevil();

    my $errfrom = "[uid=$sow->{'uid'}, vid=$vil->{'vid'}, cmd=$query->{'cmd'}]";

    # ���\�[�X�̓ǂݍ���
    &SWBase::LoadVilRS( $sow, $vil );

    $debug->raise( $sow->{'APLOG_CAUTION'}, "���O�C�����ĉ������B", "no login.$errfrom" )
      if ( $sow->{'user'}->logined() <= 0 );
    if ( $sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'} ) {
        if ( $sow->{'query'}->{'cmd'} eq 'scrapvil' ) {
            $debug->raise(
                $sow->{'APLOG_CAUTION'},
                "�p������ɂ͊Ǘ��l�������K�v�ł��B",
                "no permition.$errfrom"
            );
        }
        else {
            $debug->raise(
                $sow->{'APLOG_CAUTION'},
                "�����X�V����ɂ͑����Đl�������Ǘ��l�������K�v�ł��B",
                "no permition.$errfrom"
            ) if ( $sow->{'uid'} ne $vil->{'makeruid'} );
        }
    }

    return;
}

1;
