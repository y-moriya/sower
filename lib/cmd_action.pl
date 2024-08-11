package SWCmdAction;

#----------------------------------------
# �A�N�V����
#----------------------------------------
sub CmdAction {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # �f�[�^����
    my ( $vil, $checknosay ) = &SetDataCmdAction($sow);

    # HTTP/HTML�o��
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newinfo";

    $sow->{'http'}->{'location'} = "$link";
    $sow->{'http'}->outheader();    # HTTP�w�b�_�̏o��
    $sow->{'http'}->outfooter();
}

#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdAction {
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

    # �A�N�V�����Ώێ҂ƁA���̖��O���擾
    my $mes = '';
    my $targetpl;
    if ( defined( $query->{'target'} ) && ( $query->{'target'} >= 0 ) ) {
        if (   ( !defined( $query->{'actionno'} ) )
            || ( $query->{'actionno'} != -2 ) )
        {
            $targetpl = $vil->getplbypno( $query->{'target'} );
            $debug->raise( $sow->{'APLOG_CAUTION'}, "�Ώ۔ԍ����s���ł��B", "invalid target." )
              if ( !defined( $targetpl->{'pno'} ) );
            $debug->raise( $sow->{'APLOG_CAUTION'}, "�ΏۂɎ����͑I�ׂ܂���B", "target is you." )
              if ( $sow->{'curpl'}->{'pno'} == $targetpl->{'pno'} );
            $debug->raise( $sow->{'APLOG_CAUTION'}, "�A�N�V�����Ώۂ̐l�͎���ł��܂��B", "target is dead." )
              if ( ( $targetpl->{'live'} ne 'live' )
                && ( $vil->isepilogue() == 0 ) );
            $mes = $targetpl->getchrname();
        }
    }

    # �����O�֘A��{���͒l�`�F�b�N
    require "$sow->{'cfg'}->{'DIR_LIB'}/vld_vil.pl";
    &SWValidityVil::CheckValidityVil( $sow, $vil );

    my $selectact = 'template';
    $selectact = 'freetext'
      if (
        ( $query->{'actionno'} == -3 )
        || (   ( defined( $query->{'selectact'} ) )
            && ( $query->{'selectact'} eq 'freetext' ) )
      );

    my $actions = $sow->{'textrs'}->{'ACTIONS'};
    if ( $selectact eq 'template' ) {

        # ��^�A�N�V����
        if ( $query->{'actionno'} != -2 ) {
            if ( !defined( $actions->[ $query->{'actionno'} ] ) ) {
                $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�A�N�V�����ԍ����s���ł��B", "invalid action no.$errfrom" );
            }
            elsif (( !defined( $targetpl->{'pno'} ) )
                && ( $actions->[ $query->{'actionno'} ] =~ /^[���ɂ��̂�]/ ) )
            {    # �������i�����Ŏn�܂���̂͑Ώۂ��K�v�B
                $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, "�A�N�V�����̑Ώۂ����I���ł��B", "no target.$errfrom" );
            }
            elsif ( defined( $targetpl->{'pno'} )
                && !( $actions->[ $query->{'actionno'} ] =~ /^[���ɂ��̂�]/ ) )
            {
                $mes = '';
            }
        }

        if ( $query->{'actionno'} == -1 ) {

            # �b�̑����𑣂�
            $debug->raise( $sow->{'APLOG_CAUTION'}, "�����͂����g���؂��Ă��܂��B", "not enough actaddpt." )
              if ( $sow->{'curpl'}->{'actaddpt'} <= 0 );
            $debug->raise( $sow->{'APLOG_CAUTION'}, "���������I�v�V�������L���ł��B", "nocandy option." )
              if ( $vil->{'nocandy'} > 0 );
            my $actions_addpt = $sow->{'textrs'}->{'ACTIONS_ADDPT'};
            $actions_addpt =~ s/_REST_//g;
            $mes .= $actions_addpt;
            $targetpl->addsaycount();
            $sow->{'curpl'}->{'actaddpt'}--;
        }
        elsif ( $query->{'actionno'} == -2 ) {

            # ������
            $mes .= $sow->{'textrs'}->{'ACTIONS_BOOKMARK'};
        }
        else {
            # �b�̑����𑣂��ȊO�̒�^�A�N�V����
            $mes .= $actions->[ $query->{'actionno'} ];
        }
    }
    elsif ( $selectact eq 'freetext' ) {

        # ���R���̓A�N�V����
        $debug->raise( $sow->{'APLOG_CAUTION'}, "���R���̓A�N�V���������I�v�V�������L���ł��B", "nofreeact option." )
          if ( $vil->{'nofreeact'} > 0 );
        require "$sow->{'cfg'}->{'DIR_LIB'}/vld_text.pl";
        &SWValidityText::CheckValidityText( $sow, $errfrom, $query->{'actiontext'},
            'ACTION', 'actiontext', '�A�N�V�����̓��e', 1 );
        $mes .= $query->{'actiontext'};
    }
    else {
        $mes = '';
    }

    require "$sow->{'cfg'}->{'DIR_LIB'}/write.pl";
    my $checknosay = &SWString::CheckNoSay( $sow, $mes );
    if ( $checknosay > 0 ) {

        # �A�N�V�����̏�������
        $query->{'mes'} = $mes;
        my $writepl = &SWBase::GetCurrentPl( $sow, $vil );
        &SWWrite::ExecuteCmdWrite( $sow, $vil, $writepl );

        $debug->writeaplog( $sow->{'APLOG_POSTED'}, "WriteAction. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]" );
    }
    $vil->closevil();

    return ( $vil, $checknosay );
}

1;
