package SWCmdAction;

#----------------------------------------
# アクション
#----------------------------------------
sub CmdAction {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # データ処理
    my ( $vil, $checknosay ) = &SetDataCmdAction($sow);

    # HTTP/HTML出力
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newinfo";

    $sow->{'http'}->{'location'} = "$link";
    $sow->{'http'}->outheader();    # HTTPヘッダの出力
    $sow->{'http'}->outfooter();
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdAction {
    my $sow     = $_[0];
    my $query   = $sow->{'query'};
    my $debug   = $sow->{'debug'};
    my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

    # 村データの読み込み
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # リソースの読み込み
    &SWBase::LoadVilRS( $sow, $vil );

    # アクション対象者と、その名前を取得
    my $mes = '';
    my $targetpl;
    if ( defined( $query->{'target'} ) && ( $query->{'target'} >= 0 ) ) {
        if (   ( !defined( $query->{'actionno'} ) )
            || ( $query->{'actionno'} != -2 ) )
        {
            $targetpl = $vil->getplbypno( $query->{'target'} );
            $debug->raise( $sow->{'APLOG_CAUTION'}, "対象番号が不正です。", "invalid target." )
              if ( !defined( $targetpl->{'pno'} ) );
            $debug->raise( $sow->{'APLOG_CAUTION'}, "対象に自分は選べません。", "target is you." )
              if ( $sow->{'curpl'}->{'pno'} == $targetpl->{'pno'} );
            $debug->raise( $sow->{'APLOG_CAUTION'}, "アクション対象の人は死んでいます。", "target is dead." )
              if ( ( $targetpl->{'live'} ne 'live' )
                && ( $vil->isepilogue() == 0 ) );
            $mes = $targetpl->getchrname();
        }
    }

    # 村ログ関連基本入力値チェック
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

        # 定型アクション
        if ( $query->{'actionno'} != -2 ) {
            if ( !defined( $actions->[ $query->{'actionno'} ] ) ) {
                $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "アクション番号が不正です。", "invalid action no.$errfrom" );
            }
            elsif (( !defined( $targetpl->{'pno'} ) )
                && ( $actions->[ $query->{'actionno'} ] =~ /^[をにがのへ]/ ) )
            {    # 文頭が格助詞で始まるものは対象が必要。
                $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, "アクションの対象が未選択です。", "no target.$errfrom" );
            }
            elsif ( defined( $targetpl->{'pno'} )
                && !( $actions->[ $query->{'actionno'} ] =~ /^[をにがのへ]/ ) )
            {
                $mes = '';
            }
        }

        if ( $query->{'actionno'} == -1 ) {

            # 話の続きを促す
            $debug->raise( $sow->{'APLOG_CAUTION'}, "促しはもう使い切っています。", "not enough actaddpt." )
              if ( $sow->{'curpl'}->{'actaddpt'} <= 0 );
            $debug->raise( $sow->{'APLOG_CAUTION'}, "促し無しオプションが有効です。", "nocandy option." )
              if ( $vil->{'nocandy'} > 0 );
            my $actions_addpt = $sow->{'textrs'}->{'ACTIONS_ADDPT'};
            $actions_addpt =~ s/_REST_//g;
            $mes .= $actions_addpt;
            $targetpl->addsaycount();
            $sow->{'curpl'}->{'actaddpt'}--;
        }
        elsif ( $query->{'actionno'} == -2 ) {

            # しおり
            $mes .= $sow->{'textrs'}->{'ACTIONS_BOOKMARK'};
        }
        else {
            # 話の続きを促す以外の定型アクション
            $mes .= $actions->[ $query->{'actionno'} ];
        }
    }
    elsif ( $selectact eq 'freetext' ) {

        # 自由入力アクション
        $debug->raise( $sow->{'APLOG_CAUTION'}, "自由入力アクション無しオプションが有効です。", "nofreeact option." )
          if ( $vil->{'nofreeact'} > 0 );
        require "$sow->{'cfg'}->{'DIR_LIB'}/vld_text.pl";
        &SWValidityText::CheckValidityText( $sow, $errfrom, $query->{'actiontext'},
            'ACTION', 'actiontext', 'アクションの内容', 1 );
        $mes .= $query->{'actiontext'};
    }
    else {
        $mes = '';
    }

    require "$sow->{'cfg'}->{'DIR_LIB'}/write.pl";
    my $checknosay = &SWString::CheckNoSay( $sow, $mes );
    if ( $checknosay > 0 ) {

        # アクションの書き込み
        $query->{'mes'} = $mes;
        my $writepl = &SWBase::GetCurrentPl( $sow, $vil );
        &SWWrite::ExecuteCmdWrite( $sow, $vil, $writepl );

        $debug->writeaplog( $sow->{'APLOG_POSTED'}, "WriteAction. [uid=$sow->{'uid'}, vid=$vil->{'vid'}]" );
    }
    $vil->closevil();

    return ( $vil, $checknosay );
}

1;
