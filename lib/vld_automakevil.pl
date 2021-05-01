package SWValidityAutoMakeVil;

#----------------------------------------
# ���쐬�E�ҏW���l�`�F�b�N
#----------------------------------------
sub CheckValidityAutoMakeVil {
    my ( $sow, $automv ) = @_;
    my $debug   = $sow->{'debug'};
    my $errfrom = "[automv]";

    require "$sow->{'cfg'}->{'DIR_LIB'}/vld_text.pl";

    $sow->{'debug'}
      ->raise( $sow->{'APLOG_NOTICE'}, "���O�C�����ĉ������B", "no login.$errfrom" )
      if ( $sow->{'user'}->logined() <= 0 );
    $sow->{'debug'}
      ->raise( $sow->{'APLOG_CAUTION'}, "���̍쐬�͂ł��܂���B", "cannot vmake.$errfrom" )
      if ( $sow->{'cfg'}->{'ENABLED_VMAKE'} == 0 );

    $automv->{'vcomment'} = ''
      if ( $automv->{'vcomment'} eq $sow->{'basictrs'}->{'NONE_TEXT'} );
    &SWValidityText::CheckValidityText( $sow, $errfrom, $automv->{'vcomment'},
        'VCOMMENT', 'vcomment', '���̐���', 0 );

    $sow->{'debug'}
      ->raise( $sow->{'APLOG_NOTICE'}, '�����񃊃\�[�X�����I���ł��B', "no trsid.$errfrom" )
      if ( $automv->{'trsid'} eq '' );
    $sow->{'debug'}
      ->raise( $sow->{'APLOG_CAUTION'}, '�o��l�������I���ł��B', "no csid.$errfrom" )
      if ( $automv->{'csid'} eq '' );    # �ʏ�N���Ȃ�
    $sow->{'debug'}
      ->raise( $sow->{'APLOG_CAUTION'}, '��E�z�������I���ł��B', "no roletable.$errfrom" )
      if ( $automv->{'roletable'} eq '' );    # �ʏ�N���Ȃ�
    $sow->{'debug'}
      ->raise( $sow->{'APLOG_CAUTION'}, '���[���@�����I���ł��B', "no votetype.$errfrom" )
      if ( $automv->{'votetype'} eq '' );     # �ʏ�N���Ȃ�
    $sow->{'debug'}
      ->raise( $sow->{'APLOG_CAUTION'}, '�X�V���ԁi���j�����I���ł��B', "no hour.$errfrom" )
      if ( !defined( $automv->{'hour'} ) );    # �ʏ�N���Ȃ�
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '�X�V���ԁi���j��0�`23�͈̔͂őI��ŉ������B', "invalid hour.$errfrom" )
      if ( ( $automv->{'hour'} < 0 ) || ( $automv->{'hour'} > 23 ) );   # �ʏ�N���Ȃ�
    $sow->{'debug'}
      ->raise( $sow->{'APLOG_CAUTION'}, '�X�V���ԁi���j�����I���ł��B', "no minite.$errfrom" )
      if ( !defined( $automv->{'minite'} ) );                           # �ʏ�N���Ȃ�
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '�X�V���ԁi���j��0�`59�͈̔͂őI��ŉ������B', "invalid minite.$errfrom" )
      if ( ( $automv->{'minite'} < 0 ) || ( $automv->{'minite'} > 59 ) )
      ;                                                                 # �ʏ�N���Ȃ�
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '�X�V�Ԋu�����I���ł��B', "no updinterval.$errfrom" )
      if ( !defined( $automv->{'updinterval'} ) );                      # �ʏ�N���Ȃ�
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '�X�V�Ԋu��1�`3�͈̔͂őI��ŉ������B', "invalid updinterval.$errfrom" )
      if ( ( $automv->{'updinterval'} < 1 )
        || ( $automv->{'updinterval'} > 3 ) );                          # �ʏ�N���Ȃ�
    $sow->{'debug'}
      ->raise( $sow->{'APLOG_NOTICE'}, '����������͂ł��B', "no vplcnt.$errfrom" )
      if ( !defined( $automv->{'vplcnt'} ) );
    $sow->{'debug'}->raise(
        $sow->{'APLOG_NOTICE'},
"�����$sow->{'cfg'}->{'MINSIZE_VPLCNT'}�`$sow->{'cfg'}->{'MAXSIZE_VPLCNT'}�͈̔͂œ��͂��ĉ������B",
        "invalid vplcnt.$errfrom"
      )
      if ( ( $automv->{'vplcnt'} < $sow->{'cfg'}->{'MINSIZE_VPLCNT'} )
        || ( $automv->{'vplcnt'} > $sow->{'cfg'}->{'MAXSIZE_VPLCNT'} ) );

    if ( $automv->{'starttype'} eq 'wbbs' ) {
        $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'},
            '�Œ�l���������͂ł��B', "no vplcntstart.$errfrom" )
          if ( !defined( $automv->{'vplcntstart'} ) );
        $sow->{'debug'}->raise(
            $sow->{'APLOG_NOTICE'},
"�Œ�l����$sow->{'cfg'}->{'MINSIZE_VPLCNT'}�`$sow->{'cfg'}->{'MAXSIZE_VPLCNT'}�͈̔͂œ��͂��ĉ������B",
            "invalid vplcntstart.$errfrom"
          )
          if ( ( $automv->{'vplcntstart'} < $sow->{'cfg'}->{'MINSIZE_VPLCNT'} )
            || ( $automv->{'vplcntstart'} > $sow->{'cfg'}->{'MAXSIZE_VPLCNT'} )
          );
        $sow->{'debug'}->raise(
            $sow->{'APLOG_NOTICE'},
            '�J�n���@���l�TBBS�^�Ŗ�E�z�����R�ݒ�̏ꍇ�A�Œ�l���ƒ���𓯂��l���ɂ��Ă��������B',
            "vplcnt != vplcntstart.$errfrom"
          )
          if ( ( $automv->{'vplcntstart'} != $automv->{'vplcnt'} )
            && ( $automv->{'roletable'} eq 'custom' ) );
        $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'},
            '�Œ�l���͒���ȉ��̐l���œ��͂��ĉ������B', "too many vplcntstart.$errfrom" )
          if ( $automv->{'vplcntstart'} > $automv->{'vplcnt'} );
    }

    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '�������������I���ł��B', "no saycnttype.$errfrom" )
      if ( $automv->{'saycnttype'} eq '' );    # �ʏ�N���Ȃ�
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '��Ή��̎Q��������I�����Ă��܂��B', "invalid entrylimit.$errfrom" )
      if ( ( $automv->{'entrylimit'} ne 'free' )
        && ( $automv->{'entrylimit'} ne 'password' ) );    # �ʏ�N���Ȃ�
    &SWValidityText::CheckValidityText( $sow, $errfrom, $automv->{'entrypwd'},
        'PASSWD', 'entrypwd', '�Q���p�X���[�h', 1 )
      if ( $automv->{'entrylimit'} eq 'password' );

    # �l�T�̐�
    my $wolves = 0;
    $wolves += $automv->{'cntwolf'}  if ( defined( $automv->{'cntwolf'} ) );
    $wolves += $automv->{'cntcwolf'} if ( defined( $automv->{'cntcwolf'} ) );
    $wolves += $automv->{'cntintwolf'}
      if ( defined( $automv->{'cntintwolf'} ) );

    if ( $automv->{'roletable'} eq 'custom' ) {
        $sow->{'debug'}
          ->raise( $sow->{'APLOG_NOTICE'}, '�l�T�����܂���B', "no wolves. $errfrom" )
          if ( $wolves <= 0 );

        my $roleid = $sow->{'ROLEID'};
        my $total  = 0;
        my $i;
        for ( $i = 1 ; $i < @$roleid ; $i++ ) {
            my $count = 0;
            $count = $automv->{"cnt$roleid->[$i]"}
              if ( defined( $automv->{"cnt$roleid->[$i]"} ) );
            $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'},
                '��E�z���̐l����0�ȏ����͂��ĉ������B',
                "invalid role count.[$roleid->[$i] = $count] $errfrom" )
              if ( $count < 0 );
            $total += $count;
        }

        my $total_cpossess = 0;
        my $total_hamster  = 0;
        $total_cpossess = $automv->{"cnt$roleid->[$sow->{'ROLEID_CPOSSESS'}]"}
          if (
            defined( $automv->{"cnt$roleid->[$sow->{'ROLEID_CPOSSESS'}]"} ) );
        $total_hamster = $automv->{"cnt$roleid->[$sow->{'ROLEID_HAMSTER'}]"}
          if ( defined( $automv->{"cnt$roleid->[$sow->{'ROLEID_HAMSTER'}]"} ) );
        $total_hamster += $automv->{"cnt$roleid->[$sow->{'ROLEID_WEREBAT'}]"}
          if ( defined( $automv->{"cnt$roleid->[$sow->{'ROLEID_WEREBAT'}]"} ) );
        $total_hamster += $automv->{"cnt$roleid->[$sow->{'ROLEID_TRICKSTER'}]"}
          if (
            defined( $automv->{"cnt$roleid->[$sow->{'ROLEID_TRICKSTER'}]"} ) );

        $total_cpossess = 0
          if ( ( $total_cpossess > 0 ) && ( $total_hamster > 0 ) );

        $sow->{'debug'}->raise(
            $sow->{'APLOG_NOTICE'},
            '��E�z���̍��v�l���ƒ��������������܂���B',
"invalid vplcnt or total plcnt.[$automv->{'vplcnt'} != $total] $errfrom"
        ) if ( $automv->{'vplcnt'} != $total );
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
        ) if ( $automv->{'cntvillager'} <= 0 );
        $sow->{'debug'}->raise(
            $sow->{'APLOG_NOTICE'},
            "�����҂� $sow->{'cfg'}->{'MAXCOUNT_STIGMA'} �l�܂łł��B",
            "too many stigma. $errfrom"
        ) if ( $automv->{'cntstigma'} > $sow->{'cfg'}->{'MAXCOUNT_STIGMA'} );
    }

    return;
}

1;
