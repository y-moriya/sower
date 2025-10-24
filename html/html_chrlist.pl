package SWHtmlChrList;

#----------------------------------------
# キャラ一覧画面のタイトル
#----------------------------------------
sub GetHTMLChrListTitle {
    return 'キャラ一覧';
}

#----------------------------------------
# キャラ一覧HTML出力
#----------------------------------------
sub OutHTMLChrList {
    my $sow = $_[0];
    my $net = $sow->{'html'}->{'net'};    # Null End Tag
    my $cfg = $sow->{'cfg'};

    # キャラセットの取得
    my $csid = '';
    if ( $sow->{'query'}->{'csid'} ne '' ) {
        $csid = $sow->{'query'}->{'csid'};
    }
    else {
        $csid = $cfg->{'CSIDLIST'}->[0];
    }

    # リソースの読み込み
    $sow->{'charsets'}->loadchrrs($csid);
    my $charset = $sow->{'charsets'}->{'csid'}->{$csid};
    my $body    = defined $charset->{'BODY'}  ? $charset->{'BODY'}  : '';                      # 全身画像の有無
    my $grave   = defined $charset->{'GRAVE'} ? $charset->{'GRAVE'} : '';
    my $wolf    = defined $charset->{'WOLF'}  ? $charset->{'WOLF'}  : '';
    my $tsay    = defined $charset->{'TSAY'}  ? $charset->{'TSAY'}  : '';
    my $lsay    = defined $charset->{'LSAY'}  ? $charset->{'LSAY'}  : '';

    print <<"_HTML_";
<h2>キャラクター一覧 [$charset->{'CAPTION'}セット]</h2>

<table border="1" class="vindex">
<thead>
<tr>
_HTML_

    if ( $body eq '' ) {
        print <<"_HTML_";
  <th>画像</th>
_HTML_
    }
    else {
        print <<"_HTML_";
  <th>全身画像</th>
  <th>顔画像</th>
_HTML_
    }

    if ( $grave ne '' ) {
        print <<"_HTML_";
  <th>墓下画像</th>
_HTML_
    }

    if ( $wolf ne '' ) {
        print <<"_HTML_";
  <th>囁き画像</th>
_HTML_
    }

    if ( $tsay ne '' ) {
        print <<"_HTML_";
  <th>独り言画像</th>
_HTML_
    }

    if ( $lsay ne '' ) {
        print <<"_HTML_";
  <th>恋の囁き画像</th>
_HTML_
    }

    print <<"_HTML_";
  <th>名前</th>
</tr>
</thead>

<tbody>
_HTML_

    sub create_img_html {
        my ( $charset, $img_name, $expression, $chrname, $net ) = @_;
        return
"  <td style=\"text-align: center;\"><img src=\"$charset->{'DIR'}/$img_name$expression$charset->{'EXT'}\" width=\"$charset->{'IMGBODYW'}\" height=\"$charset->{'IMGBODYH'}\" alt=\"$chrnameの画像\"$net></td>\n";
    }

    my $order = $charset->{'ORDER'};
    foreach (@$order) {
        my $chrname    = $sow->{'charsets'}->getchrname( $csid, $_ );
        my $expression = '';
        $expression = '_0' if ( @{ $charset->{'EXPRESSION'} } > 0 );
        print "\n<tr>\n";
        print create_img_html( $charset, $_ . $body,   $expression, $chrname, $net );
        print create_img_html( $charset, $_ . "_face", $expression, $chrname, $net ) if ( $body ne '' );
        print create_img_html( $charset, $_ . $grave,  $expression, $chrname, $net ) if ( $grave ne '' );
        print create_img_html( $charset, $_ . $wolf,   $expression, $chrname, $net ) if ( $wolf ne '' );
        print create_img_html( $charset, $_ . $tsay,   $expression, $chrname, $net ) if ( $tsay ne '' );
        print create_img_html( $charset, $_ . $lsay,   $expression, $chrname, $net ) if ( $lsay ne '' );
        my $dummychr = '';
        $dummychr = "★ダミーキャラ<br$net>" if ( $charset->{'NPCID'} eq $_ );
        my $romanname = '';
        $romanname = "<br$net>$charset->{'CHRROMANNAME'}->{$_}"
          if ( defined( $charset->{'CHRROMANNAME'} ) );
        print "  <td>$dummychr$chrname$romanname</td>\n";
        print "</tr>\n";
    }

    print "\n<tr>\n";
    print create_img_html( $charset, $sow->{'cfg'}->{'CID_GUEST'}, '', '傍観者', $net );
    print "<td></td>\n" if ( $body ne '' );
    print "<td></td>\n" if ( $grave ne '' );
    print "<td></td>\n" if ( $wolf ne '' );
    print "<td></td>\n" if ( $tsay ne '' );
    print "<td></td>\n" if ( $lsay ne '' );
    print "<td>傍観者</td>\n";
    print "</tr>\n";
    print <<"_HTML_";
</tbody>
</table>

_HTML_

    return;
}

1;
