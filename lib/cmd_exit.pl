package SWCmdExit;

#----------------------------------------
# 村を出る
#----------------------------------------
sub CmdExit {
    my $sow = $_[0];
    my $cfg = $sow->{'cfg'};

    # データ処理
    &SetDataCmdExit($sow);

    # HTTP/HTML出力
    if ( $sow->{'outmode'} eq 'mb' ) {
        require "$cfg->{'DIR_LIB'}/file_log.pl";
        require "$cfg->{'DIR_LIB'}/log.pl";
        require "$cfg->{'DIR_LIB'}/cmd_vlog.pl";
        my $vil = SWFileVil->new( $sow, $sow->{'query'}->{'vid'} );
        $vil->readvil();
        &SWCmdVLog::OutHTMLCmdVLog( $sow, $vil );
        $vil->closevil();
    }
    else {
        my $reqvals = &SWBase::GetRequestValues($sow);
        my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
        $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

        $sow->{'http'}->{'location'} = "$link";
        $sow->{'http'}->outheader();    # HTTPヘッダの出力
        $sow->{'http'}->outfooter();
    }
}

#----------------------------------------
# 村から出す
#----------------------------------------
sub CmdKick {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # 村データの読み込み
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();
    my $delpl = $vil->getplbypno( $query->{'cid'} );

    # リソースの読み込み
    &SWBase::LoadVilRS( $sow, $vil );
    my ( $q_csid, $q_cid ) = split( '/', $query->{'csid_cid'} );

    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'},
        'キャラクターが見つかりません。', "user not found.[$sow->{'uid'}]" )
      if ( !defined($delpl) );
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        'ダミーキャラは村を出る事ができません。', "npc cannot exit.[$sow->{'uid'}]" )
      if ( $delpl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'} );
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '村が開始してから村を出る事はできません。', "already started.[$sow->{'uid'}]" )
      if ( $vil->{'turn'} != 0 );

    # 村抜け処理
    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
    my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );
    &SWBase::ExitVillage( $sow, $vil, $delpl, $logfile );
    $logfile->close();
    $vil->writevil();

    # 村一覧データの更新
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
    my $vindex = SWFileVIndex->new($sow);
    $vindex->openvindex();
    $vindex->updatevindex( $vil, $sow->{'VSTATUSID_PRO'} );
    $vindex->closevindex();

    # HTTP/HTML出力
    if ( $sow->{'outmode'} eq 'mb' ) {
        require "$cfg->{'DIR_LIB'}/file_log.pl";
        require "$cfg->{'DIR_LIB'}/log.pl";
        require "$cfg->{'DIR_LIB'}/cmd_vlog.pl";
        my $vil = SWFileVil->new( $sow, $sow->{'query'}->{'vid'} );
        $vil->readvil();
        &SWCmdVLog::OutHTMLCmdVLog( $sow, $vil );
        $vil->closevil();
    }
    else {
        my $reqvals = &SWBase::GetRequestValues($sow);
        my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
        $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

        $sow->{'http'}->{'location'} = "$link";
        $sow->{'http'}->outheader();    # HTTPヘッダの出力
        $sow->{'http'}->outfooter();
    }

}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdExit {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # 村データの読み込み
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();
    my $pllist = $vil->getpllist();

    # リソースの読み込み
    &SWBase::LoadVilRS( $sow, $vil );
    my ( $q_csid, $q_cid ) = split( '/', $query->{'csid_cid'} );

    my $curpl = $sow->{'curpl'};
    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'},
        'あなたはこの村へ参加していません。', "user not found.[$sow->{'uid'}]" )
      if ( !defined($curpl) );
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        'ダミーキャラは村を出る事ができません。', "npc cannot exit.[$sow->{'uid'}]" )
      if ( $sow->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'} );
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'},
        '村が開始してから村を出る事はできません。', "already started.[$sow->{'uid'}]" )
      if ( $vil->{'turn'} != 0 );

    # 村抜け処理
    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
    my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );
    &SWBase::ExitVillage( $sow, $vil, $curpl, $logfile );
    $logfile->close();
    $vil->writevil();

    # 村一覧データの更新
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
    my $vindex = SWFileVIndex->new($sow);
    $vindex->openvindex();
    $vindex->updatevindex( $vil, $sow->{'VSTATUSID_PRO'} );
    $vindex->closevindex();

    return;
}

1;
