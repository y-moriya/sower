package SWCommit;

#----------------------------------------
# 村開始処理
#----------------------------------------
sub StartSession {
    my ( $sow, $vil, $commit ) = @_;
    my $textrs = $sow->{'textrs'};
    my $pllist = $vil->getpllist();

    # 開始済みの場合、何もしない
    return unless ( $vil->isprologue() > 0 );

    # 確定待ち発言の強制確定
    &FixQueUpdateSession( $sow, $vil );

    # 時間を進める
    &UpdateTurn( $sow, $vil, $commit );

    # ログ・メモデータファイルの作成
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
    my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 1 );
    my $memofile = SWSnake->new( $sow, $vil, $vil->{'turn'}, 1 );

    # 役職配分を取得
    require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
    my $roletable = &SWSetRole::GetSetRoleTable( $sow, $vil, $vil->{'roletable'}, scalar(@$pllist) );
    my @randomroletable;
    my $roleid;
    for ( $roleid = 0 ; $roleid < @$roletable ; $roleid++ ) {
        my $rolecount = $roletable->[$roleid];
        while ( $rolecount > 0 ) {
            push( @randomroletable, $roleid );
            $rolecount--;
        }
    }

    $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $sow->{'textrs'}->{'NOSELROLE'} )
      if ( $vil->{'noselrole'} > 0 );

    # 役職希望を保存
    foreach (@$pllist) {
        $_->{'backupselrole'} = $_->{'selrole'};
    }

    # ランダム希望の処理
    foreach (@$pllist) {
        next if ( $_->{'selrole'} >= 0 );

        if ( $vil->{'noselrole'} > 0 ) {
            $_->{'selrole'} = 0;    # 役職希望無視の時はおまかせに
        }
        else {
            $_->{'selrole'} = $randomroletable[ int( rand(@randomroletable) ) ];

            my $randomroletext = $textrs->{'SETRANDOMROLE'};
            my $chrname        = $_->getchrname();
            $randomroletext =~ s/_NAME_/$chrname/g;
            $randomroletext =~ s/_SELROLE_/$textrs->{'ROLENAME'}->[$_->{'selrole'}]/g;
            $logfile->writeinfo( $_->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $randomroletext );
        }
    }

    # 役職配分割り当て
    &SWSetRole::SetRole( $sow, $vil );
    foreach (@$pllist) {
        $_->{'selrole'} = $_->{'backupselrole'};
    }

    # 発言数初期化
    $vil->setsaycountall();

    # １日目開始アナウンス
    $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $textrs->{'ANNOUNCE_FIRST'}->[1] );

    # 役職割り当てアナウンス
    my $rolename = $textrs->{'ROLENAME'};
    my $i;

    my $rolematrix = &SWSetRole::GetSetRoleTable( $sow, $vil, $vil->{'roletable'}, scalar(@$pllist) );
    my @rolelist;
    my $ar = $textrs->{'ANNOUNCE_ROLE'};
    for ( $i = 0 ; $i < @{ $sow->{'ROLEID'} } ; $i++ ) {
        my $roleplcnt = $rolematrix->[$i];
        $roleplcnt++ if ( $i == $sow->{'ROLEID_VILLAGER'} );    # ダミーキャラの分１増やす
        push( @rolelist, "$rolename->[$i]$ar->[1]$roleplcnt$ar->[2]" )
          if ( $roleplcnt > 0 );
    }
    my $rolelist = join( $ar->[3], @rolelist );
    my $roleinfo = $ar->[0];
    $roleinfo =~ s/_ROLE_/$rolelist/;
    $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $roleinfo );

    # ダミーキャラ発言
    $plsingle = $vil->getpl( $sow->{'cfg'}->{'USERID_NPC'} );
    my $charset = $sow->{'charsets'}->{'csid'}->{ $plsingle->{'csid'} };
    %say = (
        mestype    => $sow->{'MESTYPE_SAY'},
        logsubid   => $sow->{'LOGSUBID_SAY'},
        uid        => $sow->{'cfg'}->{'USERID_NPC'},
        csid       => $plsingle->{'csid'},
        cid        => $plsingle->{'cid'},
        chrname    => $plsingle->getchrname(),
        expression => 0,
        mes        => $charset->{'NPCSAY'}->[1],
        undef      => 0,
        monospace  => 0,
        loud       => 0,
    );
    $plsingle->{'lastwritepos'} = $logfile->executesay( \%say );
    my $saypoint = &SWBase::GetSayPoint( $sow, $vil, $say{'mes'} );
    $plsingle->{'say'} -= $saypoint;    # 発言数消費
    $plsingle->{'saidcount'}++;
    $plsingle->{'saidpoint'} += $saypoint;

    # ダミーキャラのコミット
    $plsingle->{'commit'} = 1;
    my $mes          = $textrs->{'ANNOUNCE_COMMIT'}->[ $plsingle->{'commit'} ];
    my $curplchrname = $plsingle->getchrname();
    $mes =~ s/_NAME_/$curplchrname/g;
    $logfile->writeinfo( $plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $mes );

    # 人狼譜の出力
    if ( $sow->{'cfg'}->{'ENABLED_SCORE'} > 0 ) {
        require "$sow->{'cfg'}->{'DIR_LIB'}/score.pl";
        my $score = SWScore->new( $sow, $vil, 0 );
        $score->writestart() if ( defined( $score->{'file'} ) );
        $score->close();
    }

    # 初期投票先の設定
    &SetInitVoteTarget( $sow, $vil, $logfile );

    $logfile->close();
    $memofile->close();
    $vil->writevil();

    # 村一覧の更新
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
    my $vindex = SWFileVIndex->new($sow);
    $vindex->openvindex();
    $vindex->updatevindex( $vil, $sow->{'VSTATUSID_PLAY'} );
    $vindex->closevindex();

    $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Start Session. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]" );

    return;
}

#----------------------------------------
# 村更新処理
#----------------------------------------
sub UpdateSession {
    my ( $sow, $vil, $commit, $scrapvil ) = @_;
    my $pllist = $vil->getpllist();
    my $textrs = $sow->{'textrs'};

    return if ( $vil->{'epilogue'} < $vil->{'turn'} );    # 終了済み

    # 確定待ち発言の強制確定
    &FixQueUpdateSession( $sow, $vil );

    # 時間を進める
    &UpdateTurn( $sow, $vil, $commit );

    if ( $vil->{'epilogue'} < $vil->{'turn'} ) {

        # 終了
        require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
        my $vindex = SWFileVIndex->new($sow);
        $vindex->openvindex();
        my $vi        = $vindex->getvindex( $vil->{'vid'} );
        my $vstatusid = $sow->{'VSTATUSID_END'};
        $vstatusid = $sow->{'VSTATUSID_SCRAPEND'}
          if ( $vi->{'vstatus'} eq $sow->{'VSTATUSID_SCRAP'} );
        $vindex->updatevindex( $vil, $vstatusid );
        $vindex->closevindex();

        # 「参加中の村」データの更新
        $vil->updateentriedvil(-1);
    }
    else {
        # ログ・メモデータファイルの作成
        $pos = 0;
        my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 1 );
        require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo.pl";
        my $memofile = SWSnake->new( $sow, $vil, $vil->{'turn'}, 1 );

        my $winner = 0;
        if ( $scrapvil == 0 ) {

            # 突然死
            my ( $history, $suddendeathpl ) = &SuddenDeath( $sow, $vil, $logfile )
              if ( $sow->{'cfg'}->{'ENABLED_SUDDENDEATH'} > 0 );

            # 突然死者の霊能判定追記
            &AddMediumHistory( $sow, $vil, $history );

            # 能力対象ランダム指定時処理
            &SetRandomTarget( $sow, $vil, $logfile );

            # ピクシー／キューピッド処理
            &SetBondsTarget( $sow, $vil, $logfile ) if ( $vil->{'turn'} == 2 );

            # 処刑投票
            my $executepl;
            if ( $vil->{'turn'} > 2 ) {
                ( $history, $executepl ) = &Execution( $sow, $vil, $logfile );

                # 処刑者の霊能判定追記
                &AddMediumHistory( $sow, $vil, $history );
            }

            # 占い・呪殺
            my ( $hampl, $seertargetpl ) = &Seer( $sow, $vil, $logfile );

            # 襲撃先決定
            my $targetpl;
            $targetpl = &SelectKill( $sow, $vil, $logfile );

            # 護衛対象表示
            my $guardtargetpl;
            if ( $vil->{'turn'} > 2 ) {
                $guardtargetpl = &WriteGuardTarget( $sow, $vil, $logfile );
            }

            # 襲撃
            &Kill( $sow, $vil, $logfile, $targetpl, $hampl );

            my $livepllist = $vil->getlivepllist();

            # 人狼譜出力
            if ( $sow->{'cfg'}->{'ENABLED_SCORE'} > 0 ) {
                require "$sow->{'cfg'}->{'DIR_LIB'}/score.pl";
                my $score = SWScore->new( $sow, $vil, 0 );
                if ( defined( $score->{'file'} ) ) {
                    my @killtargetpl;
                    push( @killtargetpl, $targetpl ) if ( defined($targetpl) );
                    $score->writeupdate( $vil->{'turn'}, $suddendeathpl, $executepl,
                        $seertargetpl, $guardtargetpl, \@killtargetpl );
                }
                $score->close();
            }

            # 勝利判定
            my ( $humen, $wolves ) = &GetCountHumenWolves( $sow, $vil );
            if ( $wolves == 0 ) {

                # 村人側勝利
                $winner = 1;
            }
            elsif ( $humen <= $wolves ) {

                # 人狼側勝利
                $winner = 2;
            }

            # ハムスター人間/コウモリ人間勝利判定
            if ( $winner != 0 ) {
                foreach (@$livepllist) {
                    if ( $_->ishamster() > 0 ) {
                        $winner += 2;
                        last;
                    }
                }
            }
        }

        if ( ( $winner > 0 ) || ( $scrapvil > 0 ) ) {    # ゲーム終了
                                                         # 終了メッセージ
            my $epinfo = $sow->{'textrs'}->{'ANNOUNCE_WINNER'}->[$winner];
            $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $epinfo );

            # 配役一覧
            $logfile->writeinfo( '', $sow->{'MESTYPE_CAST'}, '*CAST*' );

            # 村一覧情報の更新
            my $vstatusid = $sow->{'VSTATUSID_EP'};
            $vstatusid = $sow->{'VSTATUSID_SCRAP'} if ( $winner == 0 );
            require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
            my $vindex = SWFileVIndex->new($sow);
            $vindex->openvindex();
            $vindex->updatevindex( $vil, $vstatusid );
            $vindex->closevindex();

            $vil->{'winner'}   = $winner;
            $vil->{'epilogue'} = $vil->{'turn'};

            # 「参加中の村」データの更新
            $vil->updateentriedvil(0);

            # 戦績の更新
            $vil->addappend();
        }
        else {
            if ( $vil->{'turn'} == 2 ) {

                # ２日目開始アナウンス
                $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $textrs->{'ANNOUNCE_FIRST'}->[2] );
            }

            # 生存者表示
            my @livesnamelist;
            my $livepllist = $vil->getlivepllist();
            my $livescnt   = @$livepllist;
            foreach (@$livepllist) {
                push( @livesnamelist, $_->getchrname() );
            }
            my $livesnametext =
              join( $sow->{'textrs'}->{'ANNOUNCE_LIVES'}->[1], @livesnamelist );
            my $livesnametextend = $sow->{'textrs'}->{'ANNOUNCE_LIVES'}->[2];
            $livesnametextend =~ s/_LIVES_/$livescnt/g;
            $livesnametext = $sow->{'textrs'}->{'ANNOUNCE_LIVES'}->[0] . $livesnametext . $livesnametextend;
            $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $livesnametext );

            # 手抜き。そのうち直そう。
            require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
            my $vindex = SWFileVIndex->new($sow);
            $vindex->openvindex();
            $vindex->updatevindex( $vil, $sow->{'VSTATUSID_PLAY'} );
            $vindex->closevindex();
        }

        # 発言数初期化
        $vil->setsaycountall();

        # 初期投票先の設定
        &SetInitVoteTarget( $sow, $vil, $logfile );

        $logfile->close();
        $memofile->close();
    }
    $vil->writevil();

    my $nextupdatedt = $sow->{'dt'}->cvtdt( $vil->{'nextupdatedt'} );
    $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'},
        "Update Session. [uid=$sow->{'uid'}, vid=$vil->{'vid'}, next=$nextupdatedt]" );

    return;
}

#----------------------------------------
# 占い・霊能判定の取得
#----------------------------------------
sub GetResultSeer {
    my ( $sow, $targetpl ) = @_;
    my $result = $sow->{'textrs'}->{'RESULT_SEER'}->[1];
    $result = $sow->{'textrs'}->{'RESULT_SEER'}->[2]
      if ( $targetpl->iswolf() > 0 );    # 人狼/呪狼/智狼
    my $chrname     = $targetpl->getchrname();
    my $result_seer = $sow->{'textrs'}->{'RESULT_SEER'}->[0];
    $result_seer =~ s/_NAME_/$chrname/g;
    $result_seer =~ s/_RESULT_/$result/g;

    return "$result_seer<br>";
}

#----------------------------------------
# 突然死処理
#----------------------------------------
sub SuddenDeath {
    my ( $sow, $vil, $logfile ) = @_;
    my $saycnt = $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} };

    my $history;
    my $livepllist = $vil->getlivepllist();
    my @suddendeathpl;
    foreach (@$livepllist) {
        next if ( $_->{'saidcount'} > 0 );    # 発言していれば除外

        $_->{'live'}     = 'suddendead';      # 死亡
        $_->{'deathday'} = $vil->{'turn'};    # 死亡日
        push( @suddendeathpl, $_ );
        my $user = SWUser->new($sow);
        $user->writeentriedvil( $_->{'uid'}, $vil->{'vid'}, $_->getchrname(), 0, 1 );
        $user->addsdpenalty();
        $user->writeuser();
        $user->closeuser();

        # 突然死メッセージ出力
        my $chrname = $_->getchrname();
        my $mes     = $sow->{'textrs'}->{'SUDDENDEATH'};
        $mes =~ s/_NAME_/$chrname/;
        $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $mes );

        # 突然死通知（未実装）
        if ( $sow->{'cfg'}->{'ENABLED_NOTICE_SD'} > 0 ) {
        }

        # 霊能判定
        my $mediumresult = &GetResultSeer( $sow, $_ );
        $history = $history . $mediumresult;

        &Suicide( $sow, $vil, $_, $logfile );    # 後追い
    }

    return ( $history, \@suddendeathpl );
}

#----------------------------------------
# 霊能判定結果の追記
#----------------------------------------
sub AddMediumHistory {
    my ( $sow, $vil, $history ) = @_;

    return if ( !defined($history) );
    return if ( $history eq '' );

    my $livepllist = $vil->getlivepllist();
    foreach (@$livepllist) {
        if ( $_->{'role'} == $sow->{'ROLEID_MEDIUM'} ) {
            $_->{'history'} .= $history;
        }
    }

    return;
}

#----------------------------------------
# 能力対象ランダム指定時処理
#----------------------------------------
sub SetRandomTarget {
    my ( $sow, $vil, $logfile ) = @_;
    my $abirole    = $sow->{'textrs'}->{'ABI_ROLE'};
    my $livepllist = $vil->getlivepllist();

    my $srcpl;
    foreach $srcpl (@$livepllist) {
        my $ability = $abirole->[ $srcpl->{'role'} ];
        if ( $ability ne '' ) {
            if ( $srcpl->{'target'} == $sow->{'TARGETID_RANDOM'} ) {

                # ランダム対象
                my $chrname = $srcpl->getchrname();
                my $srctargetpno;
                if ( $srcpl->{'role'} == $sow->{'ROLEID_TRICKSTER'} ) {
                    $srctargetpno = $srcpl->{'target2'}
                      if ( ( $srcpl->{'target2'} >= 0 )
                        && ( $srcpl->{'live'} eq 'live' ) );
                }
                &SetRandomTargetSingle( $sow, $vil, $srcpl, 'target', $logfile, $srctargetpno );
            }

            if (   ( $srcpl->{'role'} == $sow->{'ROLEID_TRICKSTER'} )
                && ( $srcpl->{'target2'} == $sow->{'TARGETID_RANDOM'} ) )
            {
                &SetRandomTargetSingle( $sow, $vil, $srcpl, 'target2', $logfile, $srcpl->{'target'} );
            }
        }
    }
}

#----------------------------------------
# 能力対象ランダム処理（単独）
#----------------------------------------
sub SetRandomTargetSingle {
    my ( $sow, $vil, $plsingle, $targetid, $logfile, $srctargetpno ) = @_;

    # ランダム決定
    my $targetlist = $plsingle->gettargetlist( $targetid, $srctargetpno );
    if ( @$targetlist == 0 ) {

        # 対象候補が存在しない
        $plsingle->{$targetid} = -1;
        $logfile->writeinfo(
            $plsingle->{'uid'},
            $sow->{'MESTYPE_INFOSP'},
            $plsingle->getchrname() . "の対象($targetid)候補がありません。"
        );
        return;
    }

    $plsingle->{$targetid} =
      $targetlist->[ int( rand(@$targetlist) ) ]->{'pno'};
    $targetpl = $vil->getplbypno( $plsingle->{$targetid} );

    #	my $listtext = "★" . $plsingle->getchrname() . "の相手候補★<br>";
    #	foreach(@$targetlist) {
    #		$listtext .= "$_->{'chrname'}<br>";
    #	}
    #	$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $listtext);

    # ログ書き込み
    my $chrname    = $plsingle->getchrname();
    my $ability    = $sow->{'textrs'}->{'ABI_ROLE'}->[ $plsingle->{'role'} ];
    my $targetname = $targetpl->getchrname();
    my $randomtext = $sow->{'textrs'}->{'SETRANDOMTARGET'};
    $randomtext =~ s/_NAME_/$chrname/g;
    $randomtext =~ s/_ABILITY_/$ability/g;
    $randomtext =~ s/_TARGET_/$targetname/g;
    $logfile->writeinfo( $plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $randomtext );

    return $targetpl;
}

#----------------------------------------
# ピクシー／キューピッド処理
#----------------------------------------
sub SetBondsTarget {
    my ( $sow, $vil, $logfile ) = @_;
    my $abirole = $sow->{'textrs'}->{'ABI_ROLE'};

    my $livepllist = $vil->getlivepllist();
    foreach $plsingle (@$livepllist) {
        next if ( $plsingle->{'role'} != $sow->{'ROLEID_TRICKSTER'} );

        my $chrname = $plsingle->getchrname();

        # 絆の追加
        my $targetpl  = $vil->getplbypno( $plsingle->{'target'} );
        my $target2pl = $vil->getplbypno( $plsingle->{'target2'} );

        if ( $targetpl->{'live'} ne 'live' ) {

            # 設定対象１が突然死している時
            my $srctargetpno;
            $srctargetpno = $plsingle->{'target2'}
              if ( ( $plsingle->{'target2'} >= 0 )
                && ( $target2pl->{'live'} eq 'live' ) );
            $targetpl = &SetRandomTargetSingle( $sow, $vil, $plsingle, 'target', $logfile, $srctargetpno );
        }

        if ( $target2pl->{'live'} ne 'live' ) {

            # 設定対象２が突然死している時
            $target2pl = &SetRandomTargetSingle( $sow, $vil, $plsingle, 'target2', $logfile, $plsingle->{'target'} );
        }

        if ( ( $plsingle->{'target'} < 0 ) || ( $plsingle->{'target2'} < 0 ) ) {

            # 対象候補が存在しない
            my $ability =
              $sow->{'textrs'}->{'ABI_ROLE'}->[ $plsingle->{'role'} ];
            my $canceltarget = $sow->{'textrs'}->{'CANCELTARGET'};
            $canceltarget =~ s/_NAME_/$chrname/g;
            $canceltarget =~ s/_ABILITY_/$ability/g;
            $logfile->writeinfo( $plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $canceltarget );
            return;
        }

        $targetpl->addbond( $plsingle->{'target2'} );
        $target2pl->addbond( $plsingle->{'target'} );

        my $result_trickster = $sow->{'textrs'}->{'EXECUTETRICKSTER'};
        my $targetname       = $targetpl->getchrname();
        my $target2name      = $target2pl->getchrname();
        $result_trickster =~ s/_NAME_/$chrname/g;
        $result_trickster =~ s/_TARGET1_/$targetname/g;
        $result_trickster =~ s/_TARGET2_/$target2name/g;
        $logfile->writeinfo( $plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $result_trickster );
    }
}

#----------------------------------------
# 処刑処理
#----------------------------------------
sub Execution {
    my ( $sow, $vil, $logfile ) = @_;
    my $history;
    my $pllist     = $vil->getpllist();
    my $livepllist = $vil->getlivepllist();

    # 投票数の初期化
    my @votes;
    my $i;
    for ( $i = 0 ; $i < @$pllist ; $i++ ) {
        $votes[$i] = 0;
    }

    # 突然死優先投票処理（未実装）

    # ランダム委任
    foreach (@$livepllist) {
        $_->{'randomentrust'} = '';
        if (   ( $_->{'entrust'} > 0 )
            && ( $_->{'vote'} == $sow->{'TARGETID_RANDOM'} ) )
        {
            $_->{'vote'} = $livepllist->[ rand( @$livepllist - 1 ) ]->{'pno'};
            $_->{'vote'} = $livepllist->[$#$livepllist]->{'pno'}
              if ( $_->{'vote'} == $_->{'pno'} );
            $_->{'randomentrust'} = $sow->{'textrs'}->{'RANDOMENTRUST'};
        }
    }

    # 委任投票処理
    my $curpl;
    foreach $curpl (@$livepllist) {
        my @entrusts;
        my $srcpl = $curpl;
        $i = 0;

        while ( $srcpl->{'entrust'} > 0 ) {

            # 投票を他人に委任している人を配列に追加
            push( @entrusts, $srcpl );
            $i++;
            $srcpl = $vil->getplbypno( $srcpl->{'vote'} );
            if ( ( $i > @$livepllist ) || ( $srcpl->{'live'} ne 'live' ) ) {

                # 委任ループに入っている時
                # （又は委任先が死者の時）
                foreach (@entrusts) {
                    next if ( $_->{'entrust'} <= 0 );

                    # 投票先をランダムに設定
                    my $entrusttext =
                      $sow->{'textrs'}->{'ANNOUNCE_ENTRUST'}->[1];
                    my $chrname    = $_->getchrname();
                    my $targetpl   = $vil->getplbypno( $_->{'vote'} );
                    my $targetname = $targetpl->getchrname();
                    $entrusttext =~ s/_NAME_/$chrname/g;
                    $entrusttext =~ s/_TARGET_/$targetname/g;
                    $entrusttext =~ s/_RANDOM_/$_->{'randomentrust'}/g;
                    $logfile->writeinfo( $_->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $entrusttext );
                    $_->{'vote'}    = -1;
                    $_->{'entrust'} = -1;
                }
                @entrusts = ();
                last;
            }
        }

        if ( @entrusts > 0 ) {

            # 委任している時
            my $entrust;
            my $targetname = $srcpl->getchrname();
            for ( $i = 0 ; $i < @entrusts ; $i++ ) {
                $entrusts[$i]->{'vote'}    = $srcpl->{'vote'};
                $entrusts[$i]->{'entrust'} = 0;

                my $randomvote = 0;
                if (   ( $entrusts[$i]->{'vote'} == $entrusts[$i]->{'pno'} )
                    || ( $srcpl->{'entrust'} < 0 ) )
                {
                    # ランダム投票
                    $randomvote = 1;
                    $entrusts[$i]->{'vote'} = -1;
                }

                # 委任メッセージ表示
                my $entrusttext =
                  $sow->{'textrs'}->{'ANNOUNCE_ENTRUST'}->[$randomvote];
                my $chrname = $entrusts[$i]->getchrname();
                $entrusttext =~ s/_NAME_/$chrname/g;
                $entrusttext =~ s/_TARGET_/$targetname/g;
                $entrusttext =~ s/_RANDOM_/$entrusts[$i]->{'randomentrust'}/g;
                $logfile->writeinfo( $entrusts[$i]->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $entrusttext );
            }
            next;
        }

    }

    # 投票結果集計＆表示
    my $votestext;
    foreach (@$livepllist) {
        my $randomvote = '';
        if ( $_->{'vote'} < 0 ) {
            $_->{'vote'} = $livepllist->[ rand( @$livepllist - 1 ) ]->{'pno'};
            if ( $_->{'vote'} == $_->{'pno'} ) {
                $_->{'vote'} = $livepllist->[$#$livepllist]->{'pno'};
            }
            $randomvote = $sow->{'textrs'}->{'ANNOUNCE_RANDOMVOTE'};
        }
        $votes[ $_->{'vote'} ]++;

        # 各投票結果
        my $chrname  = $_->getchrname();
        my $votepl   = $vil->getplbypno( $_->{'vote'} );
        my $votename = $votepl->getchrname();

        my $votetext = $sow->{'textrs'}->{'ANNOUNCE_VOTE'}->[0];
        $votetext =~ s/_NAME_/$chrname/g;
        $votetext =~ s/_TARGET_/$votename/g;
        $votetext =~ s/_RANDOM_/$randomvote/g;
        $votestext = $votestext . "$votetext<br>"
          if ( $vil->{'votetype'} eq 'sign' );

        $logfile->writeinfo( $_->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $votetext )
          if ( $vil->{'votetype'} ne 'sign' );
    }

    # 無記名投票の投票結果表示
    for ( $i = 0 ; $i < @votes ; $i++ ) {
        next if ( $votes[$i] == 0 );

        my $targetpl = $vil->getplbypno($i);
        my $chrname  = $targetpl->getchrname();
        my $votetext = $sow->{'textrs'}->{'ANNOUNCE_VOTE'}->[1];
        $votetext =~ s/_NAME_/$chrname/g;
        $votetext =~ s/_COUNT_/$votes[$i]/g;

        $votestext = $votestext . "$votetext<br>"
          if ( $vil->{'votetype'} ne 'sign' );
    }

    # 最大得票数のチェック
    my $maxvote = 0;
    for ( $i = 0 ; $i < @votes ; $i++ ) {
        $maxvote = $votes[$i] if ( $maxvote < $votes[$i] );
    }

    return if ( $maxvote == 0 );    # 処刑候補がいない（全員突然死？）

    # 最大得票者の取得
    my @lastvote;
    for ( $i = 0 ; $i < @votes ; $i++ ) {
        push( @lastvote, $i ) if ( $votes[$i] == $maxvote );
    }

    return if ( @lastvote == 0 );    # 処刑候補がいない（全員突然死？）

    # 処刑対象の決定
    my $execution = $lastvote[ int( rand(@lastvote) ) ];
    my $executepl = $vil->getplbypno($execution);
    my @executedpl;
    if ( $executepl->{'live'} eq 'live' ) {

        # 処刑
        my $chrname  = $executepl->getchrname();
        my $votetext = $sow->{'textrs'}->{'ANNOUNCE_VOTE'}->[2];
        $votetext =~ s/_NAME_/$chrname/g;
        $votestext               = $votestext . "<br>$votetext";
        $executepl->{'live'}     = 'executed';
        $executepl->{'deathday'} = $vil->{'turn'};
        my $user = SWUser->new($sow);
        $user->writeentriedvil( $executepl->{'uid'}, $vil->{'vid'}, $executepl->getchrname(), 0 );

        # 霊能判定
        my $mediumresult = &GetResultSeer( $sow, $executepl );
        $history .= $mediumresult;
        push( @executedpl, $executepl );
    }

    # 投票結果の出力
    $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $votestext );

    &Suicide( $sow, $vil, $executepl, $logfile );    # 後追い

    return ( $history, \@executedpl );
}

#----------------------------------------
# 後追い処理
#----------------------------------------
sub Suicide {
    my ( $sow, $vil, $deadpl, $logfile ) = @_;

    my @bonds = split( '/', $deadpl->{'bonds'} . '/' );
    my $chrname = $deadpl->getchrname();
    foreach (@bonds) {
        my $targetpl = $vil->getplbypno($_);
        if ( $targetpl->{'live'} eq 'live' ) {
            $targetpl->{'live'}     = 'suicide';
            $targetpl->{'deathday'} = $vil->{'turn'};
            my $user = SWUser->new($sow);
            $user->writeentriedvil( $targetpl->{'uid'}, $vil->{'vid'}, $targetpl->getchrname(), 0 );

            my $suicidetext = $sow->{'textrs'}->{'SUICIDEBONDS'};
            my $targetname  = $targetpl->getchrname();
            $suicidetext =~ s/_TARGET_/$chrname/g;
            $suicidetext =~ s/_NAME_/$targetname/g;
            $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $suicidetext );
            &Suicide( $sow, $vil, $targetpl, $logfile );    # 後追い連鎖
        }
    }
}

#----------------------------------------
# 占い処理
#----------------------------------------
sub Seer {
    my ( $sow, $vil, $logfile ) = @_;
    my @seertargetpl;
    my @hampl;

    my $livepllist = $vil->getlivepllist();
    foreach (@$livepllist) {
        if ( $_->{'role'} eq $sow->{'ROLEID_SEER'} ) {

            # 占い発動
            my $seername   = $_->getchrname();
            my $targetpl   = $vil->getplbypno( $_->{'target'} );
            my $targetname = $targetpl->getchrname();
            my $seerresult = GetResultSeer( $sow, $targetpl );
            $_->{'history'} .= $seerresult;

            # ハム・コウモリ・ピクシー呪殺
            if (   ( $targetpl->{'live'} eq 'live' )
                && ( $targetpl->ishamster() > 0 ) )
            {
                push( @hampl, $targetpl );
                $targetpl->{'live'}     = 'cursed';
                $targetpl->{'deathday'} = $vil->{'turn'};
                my $user = SWUser->new($sow);
                $user->writeentriedvil( $targetpl->{'uid'}, $vil->{'vid'}, $targetpl->getchrname(), 0 );
            }

            # 呪狼
            if (   ( $targetpl->{'live'} eq 'live' )
                && ( $targetpl->{'role'} == $sow->{'ROLEID_CWOLF'} ) )
            {
                push( @hampl, $_ );
                $_->{'live'}     = 'cursed';
                $_->{'deathday'} = $vil->{'turn'};
                my $user = SWUser->new($sow);
                $user->writeentriedvil( $_->{'uid'}, $vil->{'vid'}, $_->getchrname(), 0 );
            }

            # 占い情報書き込み
            my $seertext = $sow->{'textrs'}->{'EXECUTESEER'};
            $seertext =~ s/_NAME_/$seername/g;
            $seertext =~ s/_TARGET_/$targetname/g;
            $logfile->writeinfo( $_->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $seertext );

            push( @seertargetpl, $targetpl );
        }
    }

    return ( \@hampl, \@seertargetpl );
}

#----------------------------------------
# 襲撃先決定
#----------------------------------------
sub SelectKill {
    my ( $sow, $vil, $logfile ) = @_;

    my $pllist     = $vil->getpllist();
    my $livepllist = $vil->getlivepllist();
    my $targetpl;    # 襲撃対象

    # 投票数の初期化
    my @votes;
    my $i;
    for ( $i = 0 ; $i < @$pllist ; $i++ ) {
        $votes[$i] = 0;
    }

    # 襲撃先集計
    my $killtext = '';
    foreach (@$livepllist) {
        next if ( $_->iswolf() == 0 );    # 人狼/呪狼/智狼以外は除外
        $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'}, "KillTarget: $_->{'uid'}($_->{'pno'})=$_->{'target'}" );
        next if ( $_->{'target'} < 0 );    # おまかせは除外

        my $targetpl = $vil->getplbypno( $_->{'target'} );
        if ( $targetpl->iswolf() > 0 ) {

            # 対象が人狼/呪狼/智狼の場合は除外（ありえないはず）
            # 人狼/呪狼/智狼を襲撃対象とするのならここの条件を変える
            $sow->{'debug'}->writeaplog( $sow->{'APLOG_WARNING'},
                "target is a wolf.[wolfid=$_->{'uid'}, target=$targetpl->{'uid'}]" );
            next;
        }

        $votes[ $_->{'target'} ] += 1;
    }

    # 最大得票数のチェック
    my $maxvote = 0;
    for ( $i = 0 ; $i < @votes ; $i++ ) {
        $maxvote = $votes[$i] if ( $maxvote < $votes[$i] );
    }

    if ( $maxvote > 0 ) {    # 全員お任せでない場合
                             # 襲撃先候補の取得
        my @lastvote;
        for ( $i = 0 ; $i < @votes ; $i++ ) {
            push( @lastvote, $i ) if ( $votes[$i] > 0 );
        }
        $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'}, "KillTarget(All): @lastvote" );

        # 襲撃対象の決定
        my $killtarget = $lastvote[ int( rand(@lastvote) ) ];
        $targetpl = $vil->getplbypno($killtarget);
        $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'}, "Final KillTarget: $killtarget" );

        # 襲撃メッセージ生成
        if ( ( $vil->{'turn'} > 2 ) && ( $targetpl->{'live'} eq 'live' ) ) {

            # ダミーキャラ襲撃時は除外する

            # 襲撃メッセージ
            my $chrname = $targetpl->getchrname();
            $killtext = $sow->{'textrs'}->{'EXECUTEKILL'};
            $killtext =~ s/_TARGET_/$chrname/g;

            # 襲撃者決定
            my @murders;
            foreach (@$livepllist) {
                next if ( $_->iswolf() == 0 );                # 人狼/呪狼/智狼以外は除外
                next if ( $_->{'target'} != $killtarget );    # 襲撃決定者に投票していない者は除外
                push( @murders, $_ );
            }
            my $murderpl = $murders[ int( rand(@murders) ) ];
            if ( !defined( $murderpl->{'uid'} ) ) {

                # 襲撃者が未定義（ありえないはず）
                $sow->{'debug'}->writeaplog( $sow->{'APLOG_WARNING'}, "murderpl is undef." );
            }
            else {
                # 襲撃メッセージ書き込み
                my %say = (
                    mestype    => $sow->{'MESTYPE_WSAY'},
                    logsubid   => $sow->{'LOGSUBID_SAY'},
                    uid        => $murderpl->{'uid'},
                    csid       => $murderpl->{'csid'},
                    cid        => $murderpl->{'cid'},
                    chrname    => $murderpl->getchrname(),
                    mes        => $killtext,
                    undef      => 1,                         # 囁きとして扱わない
                    expression => 0,
                    monospace  => 0,
                    loud       => 0,
                );
                $logfile->executesay( \%say );
            }
        }
    }

    return $targetpl;
}

#----------------------------------------
# 護衛対象表示
#----------------------------------------
sub WriteGuardTarget {
    my ( $sow, $vil, $logfile ) = @_;

    my $livepllist = $vil->getlivepllist();
    my @guardtargetpl;
    foreach (@$livepllist) {
        next if ( $_->{'role'} ne $sow->{'ROLEID_GUARD'} );    # 狩人以外は除外

        my $guardname  = $_->getchrname();
        my $targetpl   = $vil->getplbypno( $_->{'target'} );
        my $targetname = $targetpl->getchrname();
        my $guardtext  = $sow->{'textrs'}->{'EXECUTEGUARD'};
        $guardtext =~ s/_NAME_/$guardname/g;
        $guardtext =~ s/_TARGET_/$targetname/g;
        $logfile->writeinfo( $_->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $guardtext );

        push( @guardtargetpl, $targetpl );
    }

    return \@guardtargetpl;
}

#----------------------------------------
# 襲撃
#----------------------------------------
sub Kill {
    my ( $sow, $vil, $logfile, $targetpl, $deadpl ) = @_;
    my $livepllist = $vil->getlivepllist();

    my $deadtext = $sow->{'textrs'}->{'ANNOUNCE_KILL'}->[0];

    if (   ( defined( $targetpl->{'cid'} ) )
        && ( $targetpl->{'live'} eq 'live' ) )
    {
        my $targetname = $targetpl->getchrname();
        my $deadflag   = 'victim';
        if ( $vil->{'turn'} > 2 ) {

            # 護衛判定
            foreach (@$livepllist) {
                next if ( $_->{'role'} ne $sow->{'ROLEID_GUARD'} );    # 狩人以外は除外
                if ( $_->{'target'} == $targetpl->{'pno'} ) {
                    my $result_guard = $sow->{'textrs'}->{'RESULT_GUARD'};
                    $result_guard =~ s/_TARGET_/$targetname/g;
                    $_->{'history'} .= "$result_guard<br>"
                      if ( defined( $targetpl->{'uid'} ) );
                    $deadflag = 'live';
                }
            }
        }
        if (   ( $targetpl->{'live'} eq 'live' )
            && ( $targetpl->ishamster() > 0 ) )
        {
            # ハムスター人間は襲撃で死なない。
            $deadflag = 'live';
        }

        $targetpl->{'live'} = $deadflag;
        if ( $deadflag ne 'live' ) {
            push( @$deadpl, $targetpl );
            $targetpl->{'deathday'} = $vil->{'turn'};
            my $user = SWUser->new($sow);
            $user->writeentriedvil( $targetpl->{'uid'}, $vil->{'vid'}, $targetpl->getchrname(), 0 );

            # 襲撃結果追記
            foreach (@$livepllist) {
                if ( $_->iswolf() > 0 ) {
                    my $result_kill = $sow->{'textrs'}->{'RESULT_KILL'};
                    $result_kill = $sow->{'textrs'}->{'RESULT_KILLIW'}
                      if ( $_->{'role'} == $sow->{'ROLEID_INTWOLF'} );
                    $result_kill =~ s/_TARGET_/$targetname/g;
                    $result_kill =~ s/_ROLE_/$sow->{'textrs'}->{'ROLENAME'}->[$targetpl->{'role'}]/g;
                    $_->{'history'} .= "$result_kill<br>";
                }
            }
        }
    }

    # 死亡者表示
    my $i;
    my $deadplcnt = @$deadpl;
    if ( $deadplcnt == 0 ) {

        # 死亡者無し
        $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $deadtext );
    }
    else {
        # 死亡者表示
        for ( $i = 0 ; $i < $deadplcnt ; $i++ ) {
            my $deadtextpl = splice( @$deadpl, int( rand(@$deadpl) ), 1 );
            my $deadchrname = $deadtextpl->getchrname();
            $deadtext = $sow->{'textrs'}->{'ANNOUNCE_KILL'}->[1];
            $deadtext =~ s/_TARGET_/$deadchrname/g;
            $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $deadtext );
            &Suicide( $sow, $vil, $deadtextpl, $logfile );    # 後追い
        }
    }

    return;
}

#----------------------------------------
# 人間・人狼の人数を取得（勝利判定用）
#----------------------------------------
sub GetCountHumenWolves {
    my ( $sow, $vil ) = @_;
    my $livepllist = $vil->getlivepllist();

    my $humen      = 0;
    my $wolves     = 0;
    my $cpossesses = 0;
    my $hamsters   = 0;
    foreach (@$livepllist) {
        if ( $_->iswolf() > 0 ) {
            $wolves++;
        }
        elsif ( $_->{'role'} == $sow->{'ROLEID_CPOSSESS'} ) {
            $cpossesses++;
        }
        elsif ( $_->ishamster() > 0 ) {
            $hamsters++;
        }
        else {
            $humen++;
        }
    }
    $humen += $cpossesses if ( ( $hamsters > 0 ) && ( $cpossesses > 0 ) );

    return ( $humen, $wolves );
}

#----------------------------------------
# 初期投票先の設定
#----------------------------------------
sub SetInitVoteTarget {
    my ( $sow, $vil, $logfile ) = @_;
    my $livepllist = $vil->getlivepllist();

    $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'}, "Start: SetInitVoteTarget." );
    my $liveplcnt = @$livepllist;
    $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'}, "LivePL: @$livepllist" );
    foreach (@$livepllist) {
        &SetInitVoteTargetSingle( $sow, $vil, $_, 'vote',   $logfile );
        &SetInitVoteTargetSingle( $sow, $vil, $_, 'target', $logfile );
        &SetInitVoteTargetSingle( $sow, $vil, $_, 'target2', $logfile, $_->{'target'} )
          if ( $_->{'role'} == $sow->{'ROLEID_TRICKSTER'} );

        if ( $_->iswolf() > 0 ) {
            if ( $vil->{'turn'} != 1 ) {
                $_->{'target'} = $sow->{'TARGETID_TRUST'};    # 人狼はおまかせ
                $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'},
                    "ChangeTarget UNDEF (Wolf): $_->{'uid'}($_->{'pno'})=$_->{'target'}" );
            }
        }
    }
    $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'}, "End: SetInitVoteTarget." );

    return;
}

#----------------------------------------
# 初期投票先／能力対象の設定
#----------------------------------------
sub SetInitVoteTargetSingle {
    my ( $sow, $vil, $plsingle, $targetid, $logfile, $srctargetpno ) = @_;

    my $targetlist = $plsingle->gettargetlist( $targetid, $srctargetpno );

    #	my $listtext = "★" . $plsingle->getchrname() . "の初期対象($targetid)候補★<br>";
    if ( @$targetlist > 0 ) {
        $plsingle->{$targetid} =
          $targetlist->[ int( rand(@$targetlist) ) ]->{'pno'};
        $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'},
            "SetInitVote/Target[$targetid]: $plsingle->{'uid'}($plsingle->{'pno'})=randtarget" );

        #		foreach(@$targetlist) {
        #			$listtext .= "$_->{'chrname'}<br>";
        #		}
        #		my $targetname = $vil->getplbypno($plsingle->{$targetid})->getchrname();
        #		$listtext .= "<br>決定先：$targetname";
    }
    else {
        #		$listtext .= '対象がありません。';
    }

    #	$logfile->writeinfo($plsingle->{'uid'}, $sow->{'MESTYPE_INFOSP'}, $listtext);

    return;
}

#----------------------------------------
# 確定待ち発言の強制確定
#----------------------------------------
sub FixQueUpdateSession {
    my ( $sow, $vil ) = @_;

    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
    my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );
    $logfile->fixque(1);
    $logfile->close();
}

#----------------------------------------
# 時間を進める
#----------------------------------------
sub UpdateTurn {
    my ( $sow, $vil, $commit ) = @_;

    $vil->{'turn'} += 1;
    $vil->{'cntmemo'} = 0;
    $vil->{'nextupdatedt'} = $sow->{'dt'}->getnextupdatedt( $vil, $sow->{'time'}, $vil->{'updinterval'}, $commit );

    #	$vil->{'nextchargedt'} = $sow->{'dt'}->getnextupdatedt($vil, $sow->{'time'}, 1, $commit);
    $vil->{'nextchargedt'} = $sow->{'time'} + 24 * 60 * 60;
    $sow->{'turn'} += 1;
}

1;
