package SWCmdWriteMemo;

#----------------------------------------
# メモ書き込み
#----------------------------------------
sub CmdWriteMemo {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # データ処理
    my ( $vil, $checknosay ) = &SetDataCmdWriteMemo($sow);

    # HTTP/HTML出力
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
        $sow->{'http'}->outheader();    # HTTPヘッダの出力
        $sow->{'http'}->outfooter();
    }
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdWriteMemo {
    my $sow     = $_[0];
    my $cfg     = $sow->{'cfg'};
    my $query   = $sow->{'query'};
    my $debug   = $sow->{'debug'};
    my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

    # 村データの読み込み
    require "$cfg->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # リソースの読み込み
    &SWBase::LoadVilRS( $sow, $vil );

    # 村ログ関連基本入力値チェック
    require "$cfg->{'DIR_LIB'}/vld_vil.pl";
    &SWValidityVil::CheckValidityVil( $sow, $vil );

    my $writepl = &SWBase::GetCurrentPl( $sow, $vil );
    $debug->raise( $sow->{'APLOG_NOTICE'}, "あなたは死んでいます。", "you dead.[$errfrom]" )
      if ( ( $writepl->{'live'} ne 'live' ) && ( $vil->isepilogue() == 0 ) );

    # 残りアクションがゼロの時
    require "$sow->{'cfg'}->{'DIR_LIB'}/write.pl";
    my ( $dummy, $saytype ) = &SWWrite::GetMesType( $sow, $vil, $writepl );
    $debug->raise(
        $sow->{'APLOG_NOTICE'},
        "アクションが足りません。",
        "not enough saypoint.[$saytype: $writepl->{$saytype} / 1]"
    ) if ( $writepl->{$saytype} <= 0 );

    # 行数・文字数の取得の取得
    my $mes           = $query->{'mes'};
    my @lineslog      = split( '<br>', $mes );
    my $lineslogcount = @lineslog;
    my $countmes      = &SWString::GetCountStr( $sow, $vil, $mes );

    # 行数／文字数制限警告
    $debug->raise(
        $sow->{'APLOG_NOTICE'},
"行数が多すぎます（$lineslogcount行）。$cfg->{'MAXSIZE_MEMOLINE'}行以内に収めないと書き込めません。",
        "too many mes lines.$errfrom"
    ) if ( $lineslogcount > $cfg->{'MAXSIZE_MEMOLINE'} );
    my $unitcaution =
      $sow->{'basictrs'}->{'SAYTEXT'}->{ $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} }->{'COUNT_TYPE'} }
      ->{'UNIT_CAUTION'};
    $debug->raise(
        $sow->{'APLOG_NOTICE'},
"文字が多すぎます（$countmes$unitcaution）。$cfg->{'MAXSIZE_MEMOCNT'}$unitcaution以内に収めないと書き込めません。",
        "too many mes.$errfrom"
    ) if ( $countmes > $cfg->{'MAXSIZE_MEMOCNT'} );
    my $lenmes = length( $query->{'mes'} );
    $debug->raise(
        $sow->{'APLOG_NOTICE'},
        "メモが短すぎます（$lenmes バイト）。$cfg->{'MINSIZE_MEMOCNT'} バイト以上必要です。",
        "memo too short.$errfrom"
    ) if ( ( $lenmes < $cfg->{'MINSIZE_MEMOCNT'} ) && ( $lenmes != 0 ) );

    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
    my $checknosay = &SWString::CheckNoSay( $sow, $query->{'mes'} );

    my $memofile = SWSnake->new( $sow, $vil, $vil->{'turn'}, 0 );
    my $newmemo = $memofile->getnewmemo($writepl);
    $debug->raise( $sow->{'APLOG_NOTICE'}, 'メモを貼っていません。', "memo not found.$errfrom" )
      if ( ( $checknosay == 0 ) && ( $newmemo->{'log'} eq '' ) );

    # メモデータファイルへの書き込み
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

    # ログデータファイルへの書き込み
    if ( $checknosay > 0 ) {

        # メモを貼る
        $query->{'mes'} = 'メモを貼った。';
        &SWWrite::ExecuteCmdWrite( $sow, $vil, $writepl, $memo{'logid'} );

        $debug->writeaplog( $sow->{'APLOG_POSTED'}, "WriteMemo. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]" );
    }
    else {
        # メモをはがす
        $query->{'mes'} = 'メモをはがした。';
        &SWWrite::ExecuteCmdWrite( $sow, $vil, $writepl, $memo{'logid'} );

        $debug->writeaplog( $sow->{'APLOG_POSTED'}, "DeleteMemo. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]" );
    }
    $vil->closevil();

    return ( $vil, $checknosay );
}

1;
