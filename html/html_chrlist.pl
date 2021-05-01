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
    my $body    = $charset->{'BODY'};                      # 全身画像の有無
    my $grave   = $charset->{'GRAVE'};
    my $wolf    = $charset->{'WOLF'};

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

    print <<"_HTML_";
  <th>名前</th>
</tr>
</thead>

<tbody>
_HTML_

    my $order = $charset->{'ORDER'};
    foreach (@$order) {
        my $chrname    = $sow->{'charsets'}->getchrname( $csid, $_ );
        my $expression = '';
        $expression = '_0' if ( @{ $charset->{'EXPRESSION'} } > 0 );
        print "\n<tr>\n";
        print
          "  <td style=\"text-align: center;\"><img src=\"$charset->{'DIR'}/"
          . $_
          . "$body$expression$charset->{'EXT'}\" width=\"$charset->{'IMGBODYW'}\" height=\"$charset->{'IMGBODYH'}\" alt=\"$chrnameの画像\"$net></td>\n";
        print
          "  <td style=\"text-align: center;\"><img src=\"$charset->{'DIR'}/"
          . $_
          . "_face$expression$charset->{'EXT'}\" width=\"$charset->{'IMGFACEW'}\" height=\"$charset->{'IMGFACEH'}\" alt=\"$chrnameの顔画像\"$net></td>\n"
          if ( $body ne '' );
        print
          "  <td style=\"text-align: center;\"><img src=\"$charset->{'DIR'}/"
          . $_
          . "$grave$expression$charset->{'EXT'}\" width=\"$charset->{'IMGBODYW'}\" height=\"$charset->{'IMGBODYH'}\" alt=\"$chrnameの墓下画像\"$net></td>\n"
          if ( $grave ne '' );
        print
          "  <td style=\"text-align: center;\"><img src=\"$charset->{'DIR'}/"
          . $_
          . "$wolf$expression$charset->{'EXT'}\" width=\"$charset->{'IMGBODYW'}\" height=\"$charset->{'IMGBODYH'}\" alt=\"$chrnameの囁き画像\"$net></td>\n"
          if ( $wolf ne '' );
        my $dummychr = '';
        $dummychr = "★ダミーキャラ<br$net>" if ( $charset->{'NPCID'} eq $_ );
        my $romanname = '';
        $romanname = "<br$net>$charset->{'CHRROMANNAME'}->{$_}"
          if ( defined( $charset->{'CHRROMANNAME'} ) );
        print "  <td>$dummychr$chrname$romanname</td>\n";
        print "</tr>\n";
    }

    print <<"_HTML_";
</tbody>
</table>

_HTML_

    return;
}

1;
