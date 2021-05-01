package SWHtmlChrList;

#----------------------------------------
# �L�����ꗗ��ʂ̃^�C�g��
#----------------------------------------
sub GetHTMLChrListTitle {
    return '�L�����ꗗ';
}

#----------------------------------------
# �L�����ꗗHTML�o��
#----------------------------------------
sub OutHTMLChrList {
    my $sow = $_[0];
    my $net = $sow->{'html'}->{'net'};    # Null End Tag
    my $cfg = $sow->{'cfg'};

    # �L�����Z�b�g�̎擾
    my $csid = '';
    if ( $sow->{'query'}->{'csid'} ne '' ) {
        $csid = $sow->{'query'}->{'csid'};
    }
    else {
        $csid = $cfg->{'CSIDLIST'}->[0];
    }

    # ���\�[�X�̓ǂݍ���
    $sow->{'charsets'}->loadchrrs($csid);
    my $charset = $sow->{'charsets'}->{'csid'}->{$csid};
    my $body    = $charset->{'BODY'};                      # �S�g�摜�̗L��
    my $grave   = $charset->{'GRAVE'};
    my $wolf    = $charset->{'WOLF'};

    print <<"_HTML_";
<h2>�L�����N�^�[�ꗗ [$charset->{'CAPTION'}�Z�b�g]</h2>

<table border="1" class="vindex">
<thead>
<tr>
_HTML_

    if ( $body eq '' ) {
        print <<"_HTML_";
  <th>�摜</th>
_HTML_
    }
    else {
        print <<"_HTML_";
  <th>�S�g�摜</th>
  <th>��摜</th>
_HTML_
    }

    if ( $grave ne '' ) {
        print <<"_HTML_";
  <th>�扺�摜</th>
_HTML_
    }

    if ( $wolf ne '' ) {
        print <<"_HTML_";
  <th>�����摜</th>
_HTML_
    }

    print <<"_HTML_";
  <th>���O</th>
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
          . "$body$expression$charset->{'EXT'}\" width=\"$charset->{'IMGBODYW'}\" height=\"$charset->{'IMGBODYH'}\" alt=\"$chrname�̉摜\"$net></td>\n";
        print
          "  <td style=\"text-align: center;\"><img src=\"$charset->{'DIR'}/"
          . $_
          . "_face$expression$charset->{'EXT'}\" width=\"$charset->{'IMGFACEW'}\" height=\"$charset->{'IMGFACEH'}\" alt=\"$chrname�̊�摜\"$net></td>\n"
          if ( $body ne '' );
        print
          "  <td style=\"text-align: center;\"><img src=\"$charset->{'DIR'}/"
          . $_
          . "$grave$expression$charset->{'EXT'}\" width=\"$charset->{'IMGBODYW'}\" height=\"$charset->{'IMGBODYH'}\" alt=\"$chrname�̕扺�摜\"$net></td>\n"
          if ( $grave ne '' );
        print
          "  <td style=\"text-align: center;\"><img src=\"$charset->{'DIR'}/"
          . $_
          . "$wolf$expression$charset->{'EXT'}\" width=\"$charset->{'IMGBODYW'}\" height=\"$charset->{'IMGBODYH'}\" alt=\"$chrname�̚����摜\"$net></td>\n"
          if ( $wolf ne '' );
        my $dummychr = '';
        $dummychr = "���_�~�[�L����<br$net>" if ( $charset->{'NPCID'} eq $_ );
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
