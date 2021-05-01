package SWCmdATMakeVil;

#----------------------------------------
# 自動村作成
#----------------------------------------
sub CmdATMakeVil {
    my $sow      = $_[0];
    my $cfg      = $sow->{'cfg'};
    my @autokey  = keys( %{ $cfg->{'AUTO_MAKEVILS'} } );
    my $autolist = \@autokey;
    require "$cfg->{'DIR_LIB'}/file_vindex.pl";
    require "$cfg->{'DIR_LIB'}/file_autovindex.pl";

    my $atvindex = SWFileATVIndex->new($sow);
    $atvindex->openatvindex();

    my $vindex = SWFileVIndex->new($sow);
    $vindex->openvindex();
    my @vilist = $vindex->getvilist();

    my $atvindexsingle;
    my $vindexsingle;
    my $hours;
    my $autonum;

    # 自動生成チェック
    return if ( $sow->{'user'}->logined() <= 0 );    # 未ログインならチェックしない。

    foreach (@$autolist) {
        $atvindexsingle =
          $atvindex->getatvindex( $cfg->{'AUTO_MAKEVILS'}->{$_}->{'autoid'} );
        $hours = $cfg->{'AUTO_MAKEVILS'}->{$_}->{'hours'};
        if ($atvindexsingle) {
            $vindexsingle = $vindex->getvindex( $atvindexsingle->{'vid'} );
            if ( $vindexsingle->{'vstatus'} < $sow->{ $cfg->{'AUTOMV_TIMING'} } ) {

                # 何もしない
            }
            else {
                if ( $cfg->{'AUTO_MAKEVILS'}->{$_}->{'autoflag'} > 0 ) {
                    if ($hours) {
                        $autonum = $atvindexsingle->{'autonum'} % @$hours;
                        $cfg->{'AUTO_MAKEVILS'}->{$_}->{'hour'} =
                          @$hours[$autonum];
                    }

                    # 村作成時値チェック
                    require "$cfg->{'DIR_LIB'}/vld_automakevil.pl";
                    &SWValidityAutoMakeVil::CheckValidityAutoMakeVil( $sow, $cfg->{'AUTO_MAKEVILS'}->{$_} );

                    # 村作成処理
                    my $vil = &SetDataCmdATMakeVil( $sow, $cfg->{'AUTO_MAKEVILS'}->{$_} );
                }
            }
        }
        else {
            if ( $cfg->{'AUTO_MAKEVILS'}->{$_}->{'autoflag'} > 0 ) {
                if ($hours) {
                    $cfg->{'AUTO_MAKEVILS'}->{$_}->{'hour'} = @$hours[0];
                }

                # 村作成時値チェック
                require "$cfg->{'DIR_LIB'}/vld_automakevil.pl";
                &SWValidityAutoMakeVil::CheckValidityAutoMakeVil( $sow, $cfg->{'AUTO_MAKEVILS'}->{$_} );

                # 村作成処理
                my $vil =
                  &SetDataCmdATMakeVil( $sow, $cfg->{'AUTO_MAKEVILS'}->{$_} );
            }
        }
    }

    return;
}

#----------------------------------------
# 自動村作成処理
#----------------------------------------
sub SetDataCmdATMakeVil {
    my ( $sow, $automv ) = @_;
    my $cfg = $sow->{'cfg'};

    require "$cfg->{'DIR_LIB'}/file_sowgrobal.pl";
    require "$cfg->{'DIR_LIB'}/file_autovindex.pl";

    # 管理データから村番号を取得
    my $sowgrobal = SWFileSWGrobal->new($sow);
    $sowgrobal->openmw();

    $automv->{'vid'} = $sowgrobal->{'vlastid'};
    $sowgrobal->closemw();
    if ( $automv->{'vname'} eq 'auto' ) {
        my $autonames = $cfg->{'AUTO_NAMES'};
        my $i         = $automv->{'vid'} % @$autonames;
        $automv->{'vname'} = $cfg->{'AUTO_NAMES'}[$i];
    }
    $automv->{'makeruid'} = $cfg->{'USERID_ADMIN'};

    # クエリに放り込む苦肉の策
    $sow->{'query'} = $automv;

    # 村データの作成
    require "$cfg->{'DIR_LIB'}/cmd_makevil.pl";
    &SWCmdMakeVil::SetDataCmdMakeVil($sow);

    # 自動生成用データの更新
    my $atvindex = SWFileATVIndex->new($sow);
    $atvindex->openatvindex();
    $atvindex->addatvindex( $automv->{'vid'}, $automv->{'autoid'} );
    $atvindex->writeatvindex();
    $atvindex->closeatvindex();

    # 人狼譜出力用ファイルの作成
    if ( $sow->{'cfg'}->{'ENABLED_SCORE'} > 0 ) {
        require "$sow->{'cfg'}->{'DIR_LIB'}/score.pl";
        my $score = SWScore->new( $sow, $vil, 1 );
        $score->close();
    }

    $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Make Vil. [uid=$sow->{'uid'}]" );

    return;
}

1;
