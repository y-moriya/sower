package SWWrite;

#----------------------------------------
# 発言書き込み処理
#----------------------------------------
sub ExecuteCmdWrite {
    my ( $sow, $vil, $writepl, $memoid ) = @_;
    my $query = $sow->{'query'};
    require "$sow->{'cfg'}->{'DIR_LIB'}/string.pl";

    my ( $mestype, $saytype ) = &GetMesType( $sow, $vil, $writepl );

    my $act = 0;
    $act = 1 if ( index( $saytype, '_act' ) >= 0 );
    $sow->{'saytype'} = $saytype;

    # 発言制限するかどうか
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

        # 発言数消費量
        if ( $act > 0 ) {
            $saypoint = 1;
        }
        else {
            $saypoint = &SWBase::GetSayPoint( $sow, $vil, $mes );
        }

        # 発言数がない（仮）
        $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'},
            "発言数が足りません。", "not enough saypoint.[$saytype: $writepl->{$saytype} / $saypoint]" )
          if ( ( !defined( $writepl->{$saytype} ) )
            || ( ( $writepl->{$saytype} - $saypoint ) < 0 ) );
    }

    # 発言
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );

    if ( $writepl->{'emulated'} == 0 ) {
        if ( ( $act == 0 ) && ( $writepl->{'lastwritepos'} >= 0 ) ) {

            # 二重発言防止
            my $log    = $logfile->read( $writepl->{'lastwritepos'} );
            my $logmes = $log->{'log'};
            $logmes = &SWLog::ReplaceAnchorHTMLRSS( $sow, $vil, $logmes );
            my $checkmestype = $mestype;
            $checkmestype = $sow->{'MESTYPE_SAY'}
              if ( $mestype == $sow->{'MESTYPE_QUE'} );
            my $checklogmestype = $log->{'mestype'};
            $checklogmestype = $sow->{'MESTYPE_SAY'}
              if ( $log->{'mestype'} == $sow->{'MESTYPE_QUE'} );
            $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, "直前の発言と同じ内容の発言をしようとしています。", "same last mes." )
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
    $monospace = 1 if ( $query->{'monospace'} ne '' );    # アクションの等幅は隠し機能という事で（ぉ
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

        # 発言数消費
        $writepl->{$saytype} -= $saypoint
          if ( $vil->isepilogue() == 0 && $vil->isprologue() == 0 );
        if ( $vil->isepilogue() > 0 ) {
            if (
                ( $act == 0 )
                && (   ( $mestype == $sow->{'MESTYPE_SAY'} )
                    || ( $mestype == $sow->{'MESTYPE_TSAY'} ) )
              )
            {
                # 発言済み回数／pt
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
                # 発言済み回数／pt
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
# 発言種別の取得
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
        # エピローグ発言
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
        # プロローグ発言
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
        # 独り言
        $mestype = $sow->{'MESTYPE_TSAY'};
        $saytype = 'tsay';
    }
    elsif ( $writepl->{'live'} ne 'live' ) {

        # 死者のうめき
        $mestype = $sow->{'MESTYPE_GSAY'};
        $saytype = 'gsay';
    }
    elsif (( ( $writepl->iswolf() > 0 ) || ( $writepl->{'role'} == $sow->{'ROLEID_CPOSSESS'} ) )
        && ( $query->{'wolf'} eq 'on' ) )
    {
        # ささやき
        $mestype = $sow->{'MESTYPE_WSAY'};
        $saytype = 'wsay';
    }
    elsif (( $writepl->{'role'} == $sow->{'ROLEID_SYMPATHY'} )
        && ( $query->{'sympathy'} eq 'on' ) )
    {
        # 共鳴
        $mestype = $sow->{'MESTYPE_SPSAY'};
        $saytype = 'spsay';
    }
    elsif (( $writepl->{'role'} == $sow->{'ROLEID_WEREBAT'} )
        && ( $query->{'werebat'} eq 'on' ) )
    {
        # 念話
        $mestype = $sow->{'MESTYPE_BSAY'};
        $saytype = 'bsay';
    }
    elsif ( ( $writepl->islovers() > 0 ) && $query->{'love'} eq 'on' ) {

        # 恋人
        $mestype = $sow->{'MESTYPE_LSAY'};
        $saytype = 'lsay';
    }
    else {
        # 通常発言
        $mestype = $sow->{'MESTYPE_QUE'};
        $saytype = 'say';
    }

    if ( ( $query->{'cmd'} eq 'action' ) || ( $query->{'cmd'} eq 'wrmemo' ) ) {

        # アクション
        $saytype = 'say'
          if ( ( $saytype eq 'psay' ) || ( $saytype eq 'esay' ) );
        $saytype .= '_act';
        $mestype = $sow->{'MESTYPE_SAY'}
          if ( $mestype == $sow->{'MESTYPE_QUE'} );
    }

    if (   ( $query->{'admin'} ne '' )
        && ( $sow->{'uid'} eq $cfg->{'USERID_ADMIN'} ) )
    {
        # 管理人発言
        $mestype = $sow->{'MESTYPE_ADMIN'};
        $saytype = 'admin';
    }
    elsif (( $query->{'maker'} ne '' )
        && ( $sow->{'uid'} eq $vil->{'makeruid'} ) )
    {
        # 村建て人発言
        $mestype = $sow->{'MESTYPE_MAKER'};
        $saytype = 'maker';
    }
    elsif ( ( $query->{'guest'} ne '' ) && ( $query->{'think'} ne 'on' ) ) {

        # 傍観者発言
        $mestype = $sow->{'MESTYPE_GUEST'};
        $saytype = 'guest';

        # 進行中は墓下へ
        if ( ( $vil->{'turn'} > 0 ) && ( $vil->isepilogue() == 0 ) ) {
            $mestype = $sow->{'MESTYPE_GSAY'};
            $saytype = 'gsay';
        }
    }

    return ( $mestype, $saytype );
}

1;
