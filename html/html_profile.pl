package SWHtmlProfile;

#----------------------------------------
# ユーザー情報のHTML出力
#----------------------------------------
sub OutHTMLProfile {
    my ( $sow, $recordlist, $totalrecord, $camps, $roles ) = @_;
    my $cfg    = $sow->{'cfg'};
    my $query  = $sow->{'query'};
    my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

    undef( $query->{'vid'} );

    my $user = SWUser->new($sow);
    $user->{'uid'} = $query->{'prof'};
    $user->openuser(1);
    $user->closeuser();

    my $nospaceprof = $query->{'prof'};
    $nospaceprof =~ s/^ *//;
    $nospaceprof =~ s/ *$//;
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "ユーザーIDを指定して下さい。", "no prof." )
      if ( length($nospaceprof) == 0 );

    # テキストリソースの読込
    my %vil = ( trsid => $sow->{'cfg'}->{'DEFAULT_TEXTRS'}, );
    &SWBase::LoadTextRS( $sow, \%vil );

    # HTMLの出力
    $sow->{'html'} = SWHtml->new($sow);    # HTMLモードの初期化
    my $net = $sow->{'html'}->{'net'};     # Null End Tag
    $sow->{'http'}->outheader();                                                 # HTTPヘッダの出力
    $sow->{'html'}->outheader("$query->{'prof'}さんのユーザー情報");    # HTMLヘッダの出力
    $sow->{'html'}->outcontentheader();

    &SWHtmlPC::OutHTMLLogin($sow);                                               # ログイン欄の出力

    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'cmd'} = 'editprofform';
    my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
    my $linkedit = '';
    $linkedit = " <a href=\"$urlsow?$linkvalue\">編集</a>"
      if ( $sow->{'uid'} eq $query->{'prof'} );

    my $handlename = '未登録';
    $handlename = $user->{'handlename'} if ( $user->{'handlename'} ne '' );

    my $url = '未登録';
    $url = $user->{'url'} if ( $user->{'url'} ne '' );
    $url = "<a href=\"$user->{'url'}\">$user->{'url'}</a>"
      if ( ( index( $user->{'url'}, 'http://' ) == 0 )
        || ( index( $user->{'url'}, 'https://' ) == 0 ) );

    my $introduction = 'なし';
    $introduction = $user->{'introduction'}
      if ( $user->{'introduction'} ne '' );

    my $parmalink = '非表\示';
    $parmalink = '表\示' if ( $user->{'parmalink'} == 1 );

    print <<"_HTML_";
<h2>$query->{'prof'}さんの情報$linkedit</h2>

<p class="paragraph">
  <span class="multicolumn_label">ユーザーID：</span><span class="multicolumn_left">$query->{'prof'}</span>
  <br class="multicolumn_clear"$net>

  <span class="multicolumn_label">ハンドル名：</span><span class="multicolumn_left">$handlename</span>
  <br class="multicolumn_clear"$net>

  <span class="multicolumn_label">URL：</span><span class="multicolumn_left">$url</span>
  <br class="multicolumn_clear"$net>

  <span class="multicolumn_label">固定リンク：</span><span class="multicolumn_left">$parmalink</span>
  <br class="multicolumn_clear"$net>

_HTML_

    if (1) {
        my $penaltydt =
          int( ( $user->{'penaltydt'} - $sow->{'time'} ) / 60 / 60 / 24 + 0.5 );
        my @penalty = (
            "なし",
            "なし（保護観察期間中：あと約$penaltydt日）",
            "参加停止中（あと約$penaltydt日）",
            "ID停止中（あと約$penaltydt日）",
        );
        print <<"_HTML_";
  <span class="multicolumn_label">ペナルティ：</span><span class="multicolumn_left">$penalty[$user->{'ptype'}]</span>
  <br class="multicolumn_clear"$net>
</p>
_HTML_
    }

    # 総合戦績
    if ( -w $sow->{'cfg'}->{'DIR_RECORD'} ) {
        my ( $average, $liveaverage, $livedays ) = &SetRecordText($totalrecord);
        print <<"_HTML_";

<p class="paragraph">
  <span class="multicolumn_label">戦績：</span>
  <span class="multicolumn_left">$totalrecord->{'win'}勝 $totalrecord->{'lose'}敗 (勝率 $average%) 生存率 $liveaverage%, 寿命 $livedays日</span>
  <br class="multicolumn_clear"$net>
</p>

<p class="paragraph">
※戦績に廃村した村、および突然死した村は含まれません。
</p>

_HTML_
    }

    $reqvals->{'cmd'} = '';

    if (   ( $sow->{'uid'} eq $query->{'prof'} )
        || ( $sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'} ) )
    {
        my $user = SWUser->new($sow);
        $user->{'uid'} = $query->{'prof'};
        $user->openuser(1);
        my $entriedvils = $user->getentriedvils();
        $user->closeuser();

        print <<"_HTML_";
<hr class="invisible_hr"$net>

<h3>参加中の村（他の人には見えません）</h3>
<ul class="paragraph">
_HTML_

        require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
        my @list = sort { $b->{'vid'} <=> $a->{'vid'} } @$entriedvils;
        foreach (@list) {
            $reqvals->{'vid'} = $_->{'vid'};
            my $vil = SWFileVil->new( $sow, $_->{'vid'} );
            $vil->readvil();
            my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
            print "<li><a href=\"$urlsow?$linkvalue#newsay\">$_->{'vid'}村 $vil->{'vname'}</a> $_->{'chrname'}</li>\n";
            $vil->closevil();
        }
        print "<li>現在参加中の村はありません。</li>\n" if ( @$entriedvils == 0 );

        print <<"_HTML_";
</ul>
_HTML_

    }

    print <<"_HTML_";
<hr class="invisible_hr"$net>

<h3>自己紹介</h3>
<p class="paragraph">
$introduction
</p>
<hr class="invisible_hr"$net>

_HTML_

    # 詳細戦績へのリンク
    if ( ( @$recordlist > 0 ) && ( $query->{'rowall'} eq '' ) ) {
        $reqvals->{'vid'}    = '';
        $reqvals->{'prof'}   = $query->{'prof'};
        $reqvals->{'rowall'} = 'on';
        my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
        print <<"_HTML_";
<p class="paragraph">
<a href="$urlsow?$linkvalue">詳細戦績を表\示</a>
</p>
<hr class="invisible_hr"$net>

_HTML_
    }

    # 詳細戦績
    if ( ( @$recordlist > 0 ) && ( $query->{'rowall'} ne '' ) ) {

        # 陣営別
        &OutHTMLRecordSingle( $sow, $camps, '陣営', $sow->{'textrs'}->{'CAPTION_WINNER'} );

        # 役職別
        &OutHTMLRecordSingle( $sow, $roles, '役職', $sow->{'textrs'}->{'ROLENAME'} );

        print <<"_HTML_";
<h3>参加村一覧</h3>
<div class="paragraph">
<ul>
_HTML_

        my @winstr   = ( '廃村', '引分', '勝利', '敗北' );
        my $rolename = $sow->{'textrs'}->{'ROLENAME'};
        my %livetext = (
            live       => '日間を生き延びた。',
            executed   => '日目に処刑された。',
            victim     => '日目に襲撃された。',
            cursed     => '日目に呪殺された。',
            suicide    => '日目に後追いした。',
            suddendead => '日目に突然死した。',
        );

        my @list = sort { $a->{'vid'} <=> $b->{'vid'} } @$recordlist;
        foreach (@list) {
            $reqvals->{'vid'} = $_->{'vid'};
            my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
            my $liveday = $_->{'liveday'};
            $liveday++ if ( $_->{'live'} ne 'live' );
            my $rolenametext = "($rolename->[$_->{'role'}])";
            $rolenametext = '' if ( $_->{'role'} < 0 );
            print "<li><a href=\"$urlsow?$linkvalue#newsay\">$_->{'vid'} $_->{'vname'}</a><br$net>【"
              . $winstr[ $_->{'win'} + 1 ]
              . "】 $_->{'chrname'}$rolenametext、$liveday$livetext{$_->{'live'}}</li>\n";
        }

        print <<"_HTML_";
</ul>
</div>
<hr class="invisible_hr"$net>

<h3>運命の絆リスト</h3>

<div class="paragraph">
<ul>
_HTML_

        my $bondcount = 0;
        foreach (@list) {
            my @bonds = split( '/', $_->{'bonds'} . '/' );
            next if ( !defined( $bonds[0] ) );

            my @bondtext;
            $reqvals->{'vid'} = '';
            foreach (@bonds) {
                my ( $encodeduid, $chrname ) = split( ':', $_ );
                my $uid = $encodeduid;
                $uid =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("H2", $1)/eg;
                $reqvals->{'prof'} = $encodeduid;
                my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
                push( @bondtext, "$chrname(<a href=\"$urlsow?$linkvalue\">$uid</a>)" );
            }
            my $bondtext = join( '、', @bondtext );
            $reqvals->{'prof'} = '';
            $reqvals->{'vid'}  = $_->{'vid'};
            my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
            print
"<li><a href=\"$urlsow?$linkvalue#newsay\">$_->{'vid'}村</a>：$bondtext と運命の絆を結んでいた。</li>\n";
            $bondcount++;
        }
        print "<li>運命の絆を結んだ相手はまだいません。</li>\n" if ( $bondcount == 0 );

        my @winmark = ( '－', '△', '○', '×' );
        print <<"_HTML_";
</ul>
</div>
<hr class="invisible_hr"$net>

<h3>同村者一覧</h3>
<p class="paragraph">
※$winmark[2]：勝ち、$winmark[3]：負け、$winmark[1]：引き分け、$winmark[0]：その他（廃村または突然死）
</p>

<div class="paragraph">
<ul>
_HTML_

        $reqvals->{'vid'} = '';
        my %vs;
        foreach (@list) {
            print "<li>$_->{'vid'}村：";
            my @otherpl = split( '/', $_->{'otherpl'} );
            my $suddendead = 0;
            $suddendead = 1 if ( $_->{'live'} eq 'suddendead' );
            foreach (@otherpl) {
                next if ( $_ eq '' );
                my ( $encodeduid, $win ) = split( ':', "$_:" );
                my $uid = $encodeduid;
                $uid =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("H2", $1)/eg;
                if ( !defined( $vs{$encodeduid} ) ) {
                    my %vssingle = (
                        win   => 0,
                        lose  => 0,
                        draw  => 0,
                        total => 0,
                        uid   => $uid,
                    );
                    $vs{$encodeduid} = \%vssingle;
                }
                $vs{$encodeduid}->{'total'}++;
                if ( $suddendead == 0 ) {
                    $vs{$encodeduid}->{'win'}++  if ( $win == 1 );
                    $vs{$encodeduid}->{'lose'}++ if ( $win == 2 );
                    $vs{$encodeduid}->{'draw'}++ if ( $win == 0 );
                }

                $reqvals->{'prof'} = $encodeduid;
                my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
                $vs{$encodeduid}->{'url'} = "$urlsow?$linkvalue";
                my $marksingle = $winmark[ $win + 1 ];
                $marksingle = '－' if ( $suddendead > 0 );
                print "$marksingle<a href=\"$vs{$encodeduid}->{'url'}\">$uid</a>、";
            }
            print "</li>\n";
        }

        print <<"_HTML_";
</ul>
</div>
<hr class="invisible_hr"$net>

<h3>同村者対戦戦績（$sow->{'cfg'}->{'MIN_VSRECORDTOTAL'}戦以上）</h3>
<p class="paragraph">
※勝敗集計に廃村した村、および突然死した村は含まれません。
</p>

<div class="paragraph">
<ul>
_HTML_

        my $vscount = 0;
        my @vskeys  = keys(%vs);
        my @vs      = sort {
                 $vs{$b}->{'total'} <=> $vs{$a}->{'total'}
              or $vs{$b}->{'win'} <=> $vs{$a}->{'win'}
              or $vs{$b}->{'draw'} <=> $vs{$a}->{'draw'}
              or $vs{$b}->{'lose'} <=> $vs{$a}->{'lose'}
        } @vskeys;
        foreach (@vs) {
            next
              if ( $vs{$_}->{'total'} < $sow->{'cfg'}->{'MIN_VSRECORDTOTAL'} );
            print
"<li>vs. <a href=\"$vs{$_}->{'url'}\">$vs{$_}->{'uid'}</a> $vs{$_}->{'total'}戦 $vs{$_}->{'win'}勝 $vs{$_}->{'lose'}敗 $vs{$_}->{'draw'}分</li>\n";
            $vscount++;
        }
        print "<li>$sow->{'cfg'}->{'MIN_VSRECORDTOTAL'}戦以上同村した人はまだいません。</li>\n"
          if ( $vscount == 0 );

        print <<"_HTML_";
</ul>
</div>
<hr class="invisible_hr"$net>

_HTML_
    }

    &SWHtmlPC::OutHTMLReturnPC($sow);    # トップページへ戻る

    $sow->{'html'}->outcontentfooter('');
    $sow->{'html'}->outfooter();         # HTMLフッタの出力
    $sow->{'http'}->outfooter();

    return;
}

#----------------------------------------
# 勝率や生存率の整形
#----------------------------------------
sub SetRecordText {
    my $data = shift;

    my $average     = 0;
    my $liveaverage = 0;
    my $livedays    = 0;
    $total = $data->{'total'};
    if ( $data->{'total'} > 0 ) {
        $average     = int( ( $data->{'win'} * 100 / $total ) + 0.5 );
        $liveaverage = int( ( $data->{'livecount'} * 100 / $total ) + 0.5 );
        $livedays    = sprintf( "%3.1f", $data->{'liveday'} / $total );
    }
    return ( $average, $liveaverage, $livedays );
}

#----------------------------------------
# 戦績表示（陣営別／役職別）
#----------------------------------------
sub OutHTMLRecordSingle {
    my ( $sow, $data, $title, $caption ) = @_;
    my $net = $sow->{'html'}->{'net'};    # Null End Tag

    print <<"_HTML_";
<h3>$title別戦績</h3>

<table border="1" class="vindex">
<thead>
<tr>
  <th scope="col">$title</th>
  <th scope="col">勝敗</th>
  <th scope="col">勝率</th>
  <th scope="col">生存率</th>
  <th scope="col">寿命</th>
</tr>
</thead>

<tbody>
_HTML_

    my $i;
    for ( $i = 1 ; $i < @$data ; $i++ ) {
        if ( $data->[$i]->{'total'} > 0 ) {
            my ( $average, $liveaverage, $livedays ) =
              &SetRecordText( $data->[$i] );
            print <<"_HTML_";
<tr>
  <td>$caption->[$i]側</td>
  <td>$data->[$i]->{'win'}勝 $data->[$i]->{'lose'}敗</td>
  <td>$average%</td>
  <td>$liveaverage%</td>
  <td>$livedays日</td>
</tr>

_HTML_
        }
        else {
            print <<"_HTML_";
<tr>
  <td>$caption->[$i]側</td>
  <td colspan="4">なし</td>
</tr>

_HTML_
        }
    }

    print <<"_HTML_";
</tbody>
</table>
<hr class="invisible_hr"$net>

_HTML_

}

1;
