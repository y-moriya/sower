package SWValidityMakeVil;

#----------------------------------------
# ���쐬�E�ҏW���l�`�F�b�N
#----------------------------------------
sub CheckValidityMakeVil {
    my $sow     = shift;
    my $query   = $sow->{'query'};
    my $debug   = $sow->{'debug'};
    my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

    require "$sow->{'cfg'}->{'DIR_LIB'}/vld_text.pl";

    $sow->{'debug'}
      ->raise( $sow->{'APLOG_NOTICE'}, "���O�C�����ĉ������B", "no login.$errfrom" )
      if ( $sow->{'user'}->logined() <= 0 );
    $sow->{'debug'}
      ->raise( $sow->{'APLOG_CAUTION'}, "���̍쐬�͂ł��܂���B", "cannot vmake.$errfrom" )
      if ( $sow->{'cfg'}->{'ENABLED_VMAKE'} == 0 );

    &SWValidityText::CheckValidityText( $sow, $errfrom, $query->{'vname'},
        'VNAME', 'vname', '���̖��O', 1 );
    $query->{'vcomment'} = ''
      if ( $query->{'vcomment'} eq $sow->{'basictrs'}->{'NONE_TEXT'} );
    &SWValidityText::CheckValidityText( $sow, $errfrom, $query->{'vcomment'},
        'VCOMMENT', 'vcomment', '���̐���', 0 );

    $sow->{'debug'}
      ->raise( $sow->{'APLOG_NOTICE'}, '�����񃊃\�[�X�����I���ł��B', "no trsid.$errfrom" )
      if ( $query->{'trsid'} eq '' );
    $sow->{'debug'}
      ->raise( $sow->{'APLOG_CAUTION'}, '�o��l�������I���ł��B', "no csid.$errfrom" )
      if ( $query->{'csid'} eq '' );    # �ʏ�N���Ȃ�
    $sow->{'debug'}
      ->raise( $sow->{'APLOG_CAUTION'}, '��E�z�������I���ł��B', "no roletable.$errfrom" )
      if ( $query->{'roletable'} eq '' );    # �ʏ�N���Ȃ�
    $sow->{'debug'}
      ->raise( $sow->{'APLOG_CAUTION'}, '���[���@�����I���ł��B', "no votetype.$errfrom" )
      if ( $query->{'votetype'} eq '' );     # �ʏ�N���Ȃ�
    $sow->{'debug'}
      ->raise( $sow->{'APLOG_CAUTION'}, '�X�V���ԁi���j�����I���ł��B', "no hour.$errfrom" )
      if ( !defined( $query->{'hour'} ) );    # �ʏ�N���Ȃ�
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '�X�V���ԁi���j��0�`23�͈̔͂őI��ŉ������B', "invalid hour.$errfrom" )
      if ( ( $query->{'hour'} < 0 ) || ( $query->{'hour'} > 23 ) );    # �ʏ�N���Ȃ�
    $sow->{'debug'}
      ->raise( $sow->{'APLOG_CAUTION'}, '�X�V���ԁi���j�����I���ł��B', "no minite.$errfrom" )
      if ( !defined( $query->{'minite'} ) );                           # �ʏ�N���Ȃ�
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '�X�V���ԁi���j��0�`59�͈̔͂őI��ŉ������B', "invalid minite.$errfrom" )
      if ( ( $query->{'minite'} < 0 ) || ( $query->{'minite'} > 59 ) ); # �ʏ�N���Ȃ�
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '�X�V�Ԋu�����I���ł��B', "no updinterval.$errfrom" )
      if ( !defined( $query->{'updinterval'} ) );                       # �ʏ�N���Ȃ�
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '�X�V�Ԋu��1�`3�͈̔͂őI��ŉ������B', "invalid updinterval.$errfrom" )
      if ( ( $query->{'updinterval'} < 1 ) || ( $query->{'updinterval'} > 3 ) )
      ;                                                                 # �ʏ�N���Ȃ�
    $sow->{'debug'}
      ->raise( $sow->{'APLOG_NOTICE'}, '����������͂ł��B', "no vplcnt.$errfrom" )
      if ( !defined( $query->{'vplcnt'} ) );
    $sow->{'debug'}->raise(
        $sow->{'APLOG_NOTICE'},
"�����$sow->{'cfg'}->{'MINSIZE_VPLCNT'}�`$sow->{'cfg'}->{'MAXSIZE_VPLCNT'}�͈̔͂œ��͂��ĉ������B",
        "invalid vplcnt.$errfrom"
      )
      if ( ( $query->{'vplcnt'} < $sow->{'cfg'}->{'MINSIZE_VPLCNT'} )
        || ( $query->{'vplcnt'} > $sow->{'cfg'}->{'MAXSIZE_VPLCNT'} ) );

    if ( $query->{'starttype'} eq 'wbbs' ) {
        $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'},
            '�Œ�l���������͂ł��B', "no vplcntstart.$errfrom" )
          if ( !defined( $query->{'vplcntstart'} ) );
        $sow->{'debug'}->raise(
            $sow->{'APLOG_NOTICE'},
"�Œ�l����$sow->{'cfg'}->{'MINSIZE_VPLCNT'}�`$sow->{'cfg'}->{'MAXSIZE_VPLCNT'}�͈̔͂œ��͂��ĉ������B",
            "invalid vplcntstart.$errfrom"
          )
          if ( ( $query->{'vplcntstart'} < $sow->{'cfg'}->{'MINSIZE_VPLCNT'} )
            || ( $query->{'vplcntstart'} > $sow->{'cfg'}->{'MAXSIZE_VPLCNT'} )
          );
        $sow->{'debug'}->raise(
            $sow->{'APLOG_NOTICE'},
            '�J�n���@���l�TBBS�^�Ŗ�E�z�����R�ݒ�̏ꍇ�A�Œ�l���ƒ���𓯂��l���ɂ��Ă��������B',
            "vplcnt != vplcntstart.$errfrom"
          )
          if ( ( $query->{'vplcntstart'} != $query->{'vplcnt'} )
            && ( $query->{'roletable'} eq 'custom' ) );
        $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'},
            '�Œ�l���͒���ȉ��̐l���œ��͂��ĉ������B', "too many vplcntstart.$errfrom" )
          if ( $query->{'vplcntstart'} > $query->{'vplcnt'} );
    }

    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '�������������I���ł��B', "no saycnttype.$errfrom" )
      if ( $query->{'saycnttype'} eq '' );    # �ʏ�N���Ȃ�
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '��Ή��̎Q��������I�����Ă��܂��B', "invalid entrylimit.$errfrom" )
      if ( ( $query->{'entrylimit'} ne 'free' )
        && ( $query->{'entrylimit'} ne 'password' ) );    # �ʏ�N���Ȃ�
    &SWValidityText::CheckValidityText( $sow, $errfrom, $query->{'entrypwd'},
        'PASSWD', 'entrypwd', '�Q���p�X���[�h', 1 )
      if ( $query->{'entrylimit'} eq 'password' );

    # �l�T�̐�
    my $wolves = 0;
    $wolves += $query->{'cntwolf'}    if ( defined( $query->{'cntwolf'} ) );
    $wolves += $query->{'cntcwolf'}   if ( defined( $query->{'cntcwolf'} ) );
    $wolves += $query->{'cntintwolf'} if ( defined( $query->{'cntintwolf'} ) );

    if ( $query->{'roletable'} eq 'custom' ) {
        $sow->{'debug'}
          ->raise( $sow->{'APLOG_NOTICE'}, '�l�T�����܂���B', "no wolves. $errfrom" )
          if ( $wolves <= 0 );

        my $roleid = $sow->{'ROLEID'};
        my $total  = 0;
        my $i;
        for ( $i = 1 ; $i < @$roleid ; $i++ ) {
            my $count = 0;
            $count = $query->{"cnt$roleid->[$i]"}
              if ( defined( $query->{"cnt$roleid->[$i]"} ) );
            $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'},
                '��E�z���̐l����0�ȏ����͂��ĉ������B',
                "invalid role count.[$roleid->[$i] = $count] $errfrom" )
              if ( $count < 0 );
            $total += $count;
        }

        my $total_cpossess = 0;
        my $total_hamster  = 0;
        $total_cpossess = $query->{"cnt$roleid->[$sow->{'ROLEID_CPOSSESS'}]"}
          if ( defined( $query->{"cnt$roleid->[$sow->{'ROLEID_CPOSSESS'}]"} ) );
        $total_hamster = $query->{"cnt$roleid->[$sow->{'ROLEID_HAMSTER'}]"}
          if ( defined( $query->{"cnt$roleid->[$sow->{'ROLEID_HAMSTER'}]"} ) );
        $total_hamster += $query->{"cnt$roleid->[$sow->{'ROLEID_WEREBAT'}]"}
          if ( defined( $query->{"cnt$roleid->[$sow->{'ROLEID_WEREBAT'}]"} ) );
        $total_hamster += $query->{"cnt$roleid->[$sow->{'ROLEID_TRICKSTER'}]"}
          if (
            defined( $query->{"cnt$roleid->[$sow->{'ROLEID_TRICKSTER'}]"} ) );

        $total_cpossess = 0
          if ( ( $total_cpossess > 0 ) && ( $total_hamster > 0 ) );

        $sow->{'debug'}->raise(
            $sow->{'APLOG_NOTICE'},
            '��E�z���̍��v�l���ƒ��������������܂���B',
"invalid vplcnt or total plcnt.[$query->{'vplcnt'} != $total] $errfrom"
        ) if ( $query->{'vplcnt'} != $total );
        if ( $wolves >= ( $total - $total_cpossess - $total_hamster - 1 ) / 2 )
        {
            if ( $total_cpossess > 0 ) {
                $sow->{'debug'}->raise(
                    $sow->{'APLOG_NOTICE'},
                    '�l�T���������܂��i�b�����l�͐l�Ԃɂ��l�T�ɂ��J�E���g����܂���j�B',
                    "too many wolves and cpossesses. $errfrom"
                );
            }
            elsif ( $total_hamster > 0 ) {
                $sow->{'debug'}->raise(
                    $sow->{'APLOG_NOTICE'},
                    '�l�T���������܂��i�n���X�^�[�l�ԂƃR�E�����l�Ԃ͐l�Ԃɂ��l�T�ɂ��J�E���g����܂���j�B',
                    "too many wolves and hamsters. $errfrom"
                );
            }
            else {
                $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'},
                    '�l�T���������܂��B', "too many wolves. $errfrom" );
            }
        }
        $sow->{'debug'}->raise(
            $sow->{'APLOG_NOTICE'},
            '�_�~�[�L�����̕��A���l�͍Œ� 1 �l����Ă��������B',
            "no villagers. $errfrom"
        ) if ( $query->{'cntvillager'} <= 0 );
        $sow->{'debug'}->raise(
            $sow->{'APLOG_NOTICE'},
            "�����҂� $sow->{'cfg'}->{'MAXCOUNT_STIGMA'} �l�܂łł��B",
            "too many stigma. $errfrom"
        ) if ( $query->{'cntstigma'} > $sow->{'cfg'}->{'MAXCOUNT_STIGMA'} );
    }

    return;
}

1;
