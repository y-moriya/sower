package SWHtmlMemoMb;

#----------------------------------------
# メモ表示（モバイルモード）のHTML出力
#----------------------------------------
sub OutHTMLMemoMb {
    my ( $sow, $vil, $logfile, $memofile, $maxrow, $logs, $logkeys, $rows ) =
      @_;

    my $net    = $sow->{'html'}->{'net'};      # Null End Tag
    my $amp    = $sow->{'html'}->{'amp'};
    my $atr_id = $sow->{'html'}->{'atr_id'};
    my $cfg    = $sow->{'cfg'};
    my $query  = $sow->{'query'};

    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

    $sow->{'html'}->outcontentheader();

    # 二重書き込み注意
    if ( $sow->{'query'}->{'cmdfrom'} eq 'wrmemo' ) {
        print <<"_HTML_";
<font color="red">★二重書き込み注意★</font><br$net>
リロードする場合は「新」を使って下さい。
<hr$net>
_HTML_
    }

    # 村名
    my $date        = $sow->{'dt'}->cvtdt( $vil->{'nextupdatedt'} );
    my $titleupdate = " ($date に更新)";

    # 見出し（村名とRSS）
    print "<a $atr_id=\"top\">$query->{'vid'} $vil->{'vname'}<br$net>\n";

    # キャラ名表示
    if ( defined( $sow->{'curpl'}->{'uid'} ) ) {
        my $chrname  = $sow->{'curpl'}->getchrname();
        my $rolename = '';
        $rolename =
          "($sow->{'textrs'}->{'ROLENAME'}->[$sow->{'curpl'}->{'role'}])"
          if ( $sow->{'curpl'}->{'role'} > 0 );
        print "$chrname$rolename<br$net>\n";
    }

    # 日付別ログへのリンク
    my $list = $memofile->getmemolist();
    &SWHtmlMb::OutHTMLTurnNaviMb( $sow, $vil, 0, $logs, $list, $rows );

    if ( defined( $logs->[0]->{'pos'} ) ) {
        if ( ( $query->{'order'} eq 'desc' ) || ( $query->{'order'} eq 'd' ) ) {

            # 降順
            my $i;
            for ( $i = $#$logs ; $i >= 0 ; $i-- ) {
                &OutHTMLMemoSingleMb( $sow, $vil, $logfile, $memofile,
                    $logs->[$i] );
            }
        }
        else {
            # 昇順
            foreach (@$logs) {
                &OutHTMLMemoSingleMb( $sow, $vil, $logfile, $memofile, $_ );
            }
        }
    }
    else {
        print <<"_HTML_";
メモはありません。
<hr$net>
_HTML_
    }

    # 日付別ログへのリンク
    &SWHtmlMb::OutHTMLTurnNaviMb( $sow, $vil, 1, $logs, $list, $rows );

    $sow->{'html'}->outcontentfooter();

    return;
}

#----------------------------------------
# メモ欄HTML表示（１メモ分）
#----------------------------------------
sub OutHTMLMemoSingleMb {
    my ( $sow, $vil, $logfile, $memofile, $log ) = @_;
    my $query = $sow->{'query'};
    my $net   = $sow->{'html'}->{'net'};

    my $memo    = $memofile->read( $log->{'pos'} );
    my $curpl   = $vil->getpl( $memo->{'uid'} );
    my $chrname = $memo->{'chrname'};
    $chrname = "$chrname (村を出ました)"
      if ( ( !defined( $curpl->{'entrieddt'} ) )
        || ( $curpl->{'entrieddt'} > $memo->{'date'} ) );
    my $mes = $memo->{'log'};
    $mes = '（メモをはがした）' if ( $memo->{'mestype'} == $sow->{'MEMOTYPE_DELETED'} );
    my %logkeys;
    my %anchor = (
        logfile => $logfile,
        logkeys => \%logkeys,
        rowover => 1,
    );
    $mes = &SWLog::ReplaceAnchorHTMLMb( $sow, $vil, $mes, \%anchor );
    &SWHtml::ConvertNET( $sow, \$mes );
    my $date     = $sow->{'dt'}->cvtdtmb( $memo->{'date'} );
    my $memodate = '';
    $memodate = " $date" if ( $query->{'cmd'} eq 'hist' );

    print <<"_HTML_";
$chrname$memodate<br$net>
$mes
<hr$net>
_HTML_
}

1;
