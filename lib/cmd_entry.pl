package SWCmdEntry;

#----------------------------------------
# エントリー
#----------------------------------------
sub CmdEntry {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # 村データの読み込み
    require "$cfg->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # リソースの読み込み
    &SWBase::LoadVilRS( $sow, $vil );

    # データ処理(入村)
    &SetDataCmdEntry( $sow, $vil );

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
sub SetDataCmdEntry {
    my ( $sow, $vil ) = @_;
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};
    my $debug = $sow->{'debug'};

    require "$cfg->{'DIR_LIB'}/string.pl";

    my $pllist = $vil->getpllist();

    my ( $q_csid, $q_cid ) = split( '/', $query->{'csid_cid'} );

    # プレイヤー参加済みチェック
    if ( defined( $sow->{'curpl'} ) ) {
        $debug->raise( $sow->{'APLOG_NOTICE'},
            'あなたは既にこの村へ参加しています。', "user found.[$sow->{'uid'}]" );
    }

    my $user = SWUser->new($sow);
    $user->{'uid'} = $sow->{'uid'};
    $user->openuser(1);
    if ( $cfg->{'ENABLED_MULTIENTRY'} == 0 ) {
        my $entriedvils = $user->getentriedvils();
        foreach (@$entriedvils) {
            $debug->rraise( $sow->{'APLOG_NOTICE'},
                'あなたは既に他の村へ参加しています。',
                "entriedvil found.[$sow->{'uid'}, $_->{'vid'}]" )
              if ( ( $_->{'vid'} > 0 ) && ( $_->{'playing'} > 0 ) );
        }
    }
    $debug->rraise( $sow->{'APLOG_NOTICE'},
        'あなたはペナルティ中のため現在参加できません。', "cannot entry.[$sow->{'uid'}]" )
      if ( ( $user->{'ptype'} > $sow->{'PTYPE_PROBATION'} )
        && ( $user->{'penaltydt'} >= $sow->{'time'} ) );
    $user->closeuser();

    # 村開始前チェック
    $debug->raise( $sow->{'APLOG_NOTICE'}, "既に開始しています。", 'village started.' )
      unless ( $vil->isprologue() > 0 );

    # 定員チェック
    $debug->raise( $sow->{'APLOG_NOTICE'}, "既に定員に達しています。", 'too many plcnt.' )
      if ( @$pllist >= $vil->{'vplcnt'} );

    # キャラクタ参加済みチェック
    foreach (@$pllist) {
        next if ( $_->{'csid'} ne $q_csid );
        my $chrname = $sow->{'charsets'}->getchrname( $q_csid, $q_cid );
        $debug->raise(
            $sow->{'APLOG_NOTICE'},
            "$chrname は既に参加しています。",
            'cid found.'
        ) if ( $_->{'cid'} eq $q_cid );
    }

    $debug->raise( $sow->{'APLOG_NOTICE'},
        '参加パスワードが違います。', "invalid entrypwd." )
      if ( ( $vil->{'entrylimit'} eq 'password' )
        && ( $query->{'entrypwd'} ne $vil->{'entrypwd'} ) );

    # 参加者データレコードの新規作成
    my $plsingle = SWPlayer->new($sow);
    $plsingle->createpl( $sow->{'uid'} );
    $plsingle->{'cid'}          = $q_cid;
    $plsingle->{'csid'}         = $q_csid;
    $plsingle->{'selrole'}      = $query->{'role'};
    $plsingle->{'role'}         = -1;
    $plsingle->{'limitentrydt'} = $writepl->{'limitentrydt'} =
      $sow->{'time'} + $sow->{'cfg'}->{'TIMEOUT_ENTRY'} * 24 * 60 * 60;
    $vil->addpl($plsingle);      # 村へ追加
    $plsingle->setsaycount();    # 発言数初期化

    # エントリーメッセージ書き込み
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );

    my $expression = 0;
    $expression = $query->{'expression'}
      if ( defined( $query->{'expression'} ) );
    my $monospace = 0;
    $monospace = 1 if ( $query->{'monospace'} ne '' );
    my $loud = 0;
    $loud = 1 if ( $query->{'loud'} ne '' );
    my $mes   = &SWString::GetTrimString( $sow, $vil, $query->{'mes'} );
    my %entry = (
        pl         => $plsingle,
        mes        => &SWLog::CvtRandomText( $sow, $vil, $mes ),
        expression => $expression,
        npc        => 0,
        monospace  => $monospace,
        loud       => $loud,
    );
    $logfile->entrychara( \%entry );
    $logfile->close();
    $vil->writevil();

    # ユーザーデータの更新
    $user->writeentriedvil( $sow->{'uid'}, $vil->{'vid'},
        $plsingle->getchrname(), 1 );

    # ログ出力
    $debug->writeaplog( $sow->{'APLOG_POSTED'}, "Entry. [$sow->{'uid'}]" );

    # 村開始チェック（人狼審問型）
    $pllist = $vil->getpllist;
    if ( ( $vil->{'starttype'} eq 'juna' ) && ( @$pllist >= $vil->{'vplcnt'} ) )
    {
        # 村開始
        require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
        &SWCommit::StartSession( $sow, $vil, 1 );
    }
    else {
        # 村一覧データの更新
        require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
        my $vindex = SWFileVIndex->new($sow);
        $vindex->openvindex();
        $vindex->updatevindex( $vil, $sow->{'VSTATUSID_PRO'} );
        $vindex->closevindex();
    }
    $vil->closevil();

    return;
}

1;
