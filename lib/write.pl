package SWWrite;

#----------------------------------------
# �����������ݏ���
#----------------------------------------
sub ExecuteCmdWrite {
    my ( $sow, $vil, $writepl, $memoid ) = @_;
    my $query = $sow->{'query'};
    require "$sow->{'cfg'}->{'DIR_LIB'}/string.pl";

    my ( $mestype, $saytype ) = &GetMesType( $sow, $vil, $writepl );

    my $act = 0;
    $act = 1 if ( index( $saytype, '_act' ) >= 0 );
    $sow->{'saytype'} = $saytype;

    # �����������邩�ǂ���
    my $isrestrict =
         ( $mestype ne $sow->{'MESTYPE_ADMIN'} )
      && ( $mestype ne $sow->{'MESTYPE_GUEST'} )
      && ( $mestype ne $sow->{'MESTYPE_MAKER'} )
      && ( $mestype ne $sow->{'MESTYPE_TSAY'} )
      && ( $mestype ne $sow->{'MESTYPE_GSAY'} );

    my $mes = $query->{'mes'};
    if ($isrestrict) {
        $mes = &SWString::GetTrimString( $sow, $vil, $query->{'mes'} );
    }

    my $saypoint;
    if ( $writepl->{'emulated'} == 0 ) {

        # �����������
        if ( $act > 0 ) {
            $saypoint = 1;
        }
        else {
            $saypoint = &SWBase::GetSayPoint( $sow, $vil, $mes );
        }

        # ���������Ȃ��i���j
        $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'},
            "������������܂���B", "not enough saypoint.[$saytype: $writepl->{$saytype} / $saypoint]" )
          if ( ( !defined( $writepl->{$saytype} ) )
            || ( ( $writepl->{$saytype} - $saypoint ) < 0 ) );
    }

    # ����
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );

    if ( $writepl->{'emulated'} == 0 ) {
        if ( ( $act == 0 ) && ( $writepl->{'lastwritepos'} >= 0 ) ) {

            # ��d�����h�~
            my $log    = $logfile->read( $writepl->{'lastwritepos'} );
            my $logmes = $log->{'log'};
            $logmes = &SWLog::ReplaceAnchorHTMLRSS( $sow, $vil, $logmes );
            my $checkmestype = $mestype;
            $checkmestype = $sow->{'MESTYPE_SAY'}
              if ( $mestype == $sow->{'MESTYPE_QUE'} );
            my $checklogmestype = $log->{'mestype'};
            $checklogmestype = $sow->{'MESTYPE_SAY'}
              if ( $log->{'mestype'} == $sow->{'MESTYPE_QUE'} );
            $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, "���O�̔����Ɠ������e�̔��������悤�Ƃ��Ă��܂��B", "same last mes." )
              if ( ( $logmes eq $mes )
                && ( $checklogmestype == $checkmestype ) );
        }
    }

    my $logsubid = $sow->{'LOGSUBID_SAY'};
    $logsubid = $sow->{'LOGSUBID_ACTION'} if ( $act > 0 );
    $logsubid = $sow->{'LOGSUBID_BOOKMARK'}
      if ( ( defined( $query->{'actionno'} ) )
        && ( $query->{'actionno'} == -2 ) );

    my $monospace = 0;
    $monospace = 1 if ( $query->{'monospace'} ne '' );    # �A�N�V�����̓����͉B���@�\�Ƃ������Łi��
    my $loud = 0;
    $loud = 1 if ( $query->{'loud'} ne '' );
    my $expression = 0;
    $expression = $query->{'expression'}
      if ( defined( $query->{'expression'} ) );

    my %say = (
        mestype    => $mestype,
        logsubid   => $logsubid,
        uid        => $writepl->{'uid'},
        csid       => $writepl->{'csid'},
        cid        => $writepl->{'cid'},
        chrname    => $writepl->getchrname(),
        expression => $expression,
        mes        => &SWLog::CvtRandomText( $sow, $vil, $mes ),
        memoid     => $memoid,
        undef      => 0,
        monospace  => $monospace,
        loud       => $loud,
    );
    my $lastwritepos = $logfile->executesay( \%say );
    $logfile->close();

    if ( $writepl->{'emulated'} == 0 ) {

        # ����������
        $writepl->{$saytype} -= $saypoint
          if ( $vil->isepilogue() == 0 && $vil->isprologue() == 0 );
        if ( $vil->isepilogue() > 0 ) {
            if (
                ( $act == 0 )
                && (   ( $mestype == $sow->{'MESTYPE_SAY'} )
                    || ( $mestype == $sow->{'MESTYPE_TSAY'} ) )
              )
            {
                # �����ς݉񐔁^pt
                $writepl->{'saidcount'}++;
                $writepl->{'saidpoint'} += $saypoint;
            }
        }
        else {
            if (
                ( $act == 0 )
                && (   ( $mestype == $sow->{'MESTYPE_QUE'} )
                    || ( $mestype == $sow->{'MESTYPE_GSAY'} ) )
              )
            {
                # �����ς݉񐔁^pt
                $writepl->{'saidcount'}++
                  if ( $mestype == $sow->{'MESTYPE_GSAY'} );
                $writepl->{'saidpoint'} += $saypoint;
            }
        }
        $writepl->{'limitentrydt'} = $sow->{'time'} + $sow->{'cfg'}->{'TIMEOUT_ENTRY'} * 24 * 60 * 60
          if ( $writepl->{'limitentrydt'} > 0 );
        $writepl->{'lastwritepos'} = $lastwritepos;

        $vil->writevil();
    }
}

#----------------------------------------
# ������ʂ̎擾
#----------------------------------------
sub GetMesType {
    my ( $sow, $vil, $writepl ) = @_;
    my ( $mestype, $saytype );
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    if (
        ( $vil->isepilogue() > 0 )
        && (   ( $query->{'think'} ne 'on' )
            || ( $cfg->{'ENABLED_TSAY_EP'} == 0 ) )
      )
    {
        # �G�s���[�O����
        $mestype = $sow->{'MESTYPE_QUE'};
        $mestype = $sow->{'MESTYPE_SAY'} if ( $cfg->{'ENABLED_DELETED'} > 0 );
        $saytype = 'esay';
    }
    elsif (
        ( $vil->{'turn'} == 0 )
        && (   ( $cfg->{'ENABLED_TSAY_PRO'} == 0 )
            || ( $query->{'think'} ne 'on' ) )
      )
    {
        # �v�����[�O����
        $mestype = $sow->{'MESTYPE_QUE'};
        $saytype = 'psay';
    }
    elsif (
        ( $query->{'think'} eq 'on' )
        && (   ( $writepl->{'live'} eq 'live' )
            || ( $cfg->{'ENABLED_TSAY_GRAVE'} > 0 )
            || ( $cfg->{'ENABLED_TSAY_GUEST'} > 0 ) )
      )
    {
        # �Ƃ茾
        $mestype = $sow->{'MESTYPE_TSAY'};
        $saytype = 'tsay';
    }
    elsif ( $writepl->{'live'} ne 'live' ) {

        # ���҂̂��߂�
        $mestype = $sow->{'MESTYPE_GSAY'};
        $saytype = 'gsay';
    }
    elsif (( ( $writepl->iswolf() > 0 ) || ( $writepl->{'role'} == $sow->{'ROLEID_CPOSSESS'} ) )
        && ( $query->{'wolf'} eq 'on' ) )
    {
        # �����₫
        $mestype = $sow->{'MESTYPE_WSAY'};
        $saytype = 'wsay';
    }
    elsif (( $writepl->{'role'} == $sow->{'ROLEID_SYMPATHY'} )
        && ( $query->{'sympathy'} eq 'on' ) )
    {
        # ����
        $mestype = $sow->{'MESTYPE_SPSAY'};
        $saytype = 'spsay';
    }
    elsif (( $writepl->{'role'} == $sow->{'ROLEID_WEREBAT'} )
        && ( $query->{'werebat'} eq 'on' ) )
    {
        # �O�b
        $mestype = $sow->{'MESTYPE_BSAY'};
        $saytype = 'bsay';
    }
    elsif ( ( $writepl->islovers() > 0 ) && $query->{'love'} eq 'on' ) {

        # ���l
        $mestype = $sow->{'MESTYPE_LSAY'};
        $saytype = 'lsay';
    }
    else {
        # �ʏ픭��
        $mestype = $sow->{'MESTYPE_QUE'};
        $saytype = 'say';
    }

    if ( ( $query->{'cmd'} eq 'action' ) || ( $query->{'cmd'} eq 'wrmemo' ) ) {

        # �A�N�V����
        $saytype = 'say'
          if ( ( $saytype eq 'psay' ) || ( $saytype eq 'esay' ) );
        $saytype .= '_act';
        $mestype = $sow->{'MESTYPE_SAY'}
          if ( $mestype == $sow->{'MESTYPE_QUE'} );
    }

    if (   ( $query->{'admin'} ne '' )
        && ( $sow->{'uid'} eq $cfg->{'USERID_ADMIN'} ) )
    {
        # �Ǘ��l����
        $mestype = $sow->{'MESTYPE_ADMIN'};
        $saytype = 'admin';
    }
    elsif (( $query->{'maker'} ne '' )
        && ( $sow->{'uid'} eq $vil->{'makeruid'} ) )
    {
        # �����Đl����
        $mestype = $sow->{'MESTYPE_MAKER'};
        $saytype = 'maker';
    }
    elsif ( ( $query->{'guest'} ne '' ) && ( $query->{'think'} ne 'on' ) ) {

        # �T�ώҔ���
        $mestype = $sow->{'MESTYPE_GUEST'};
        $saytype = 'guest';

        # �i�s���͕扺��
        if ( ( $vil->{'turn'} > 0 ) && ( $vil->isepilogue() == 0 ) ) {
            $mestype = $sow->{'MESTYPE_GSAY'};
            $saytype = 'gsay';
        }
    }

    return ( $mestype, $saytype );
}

1;
