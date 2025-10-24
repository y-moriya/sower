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
    my $body    = defined $charset->{'BODY'}  ? $charset->{'BODY'}  : '';                      # �S�g�摜�̗L��
    my $grave   = defined $charset->{'GRAVE'} ? $charset->{'GRAVE'} : '';
    my $wolf    = defined $charset->{'WOLF'}  ? $charset->{'WOLF'}  : '';
    my $tsay    = defined $charset->{'TSAY'}  ? $charset->{'TSAY'}  : '';
    my $lsay    = defined $charset->{'LSAY'}  ? $charset->{'LSAY'}  : '';

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

    if ( $tsay ne '' ) {
        print <<"_HTML_";
  <th>�Ƃ茾�摜</th>
_HTML_
    }

    if ( $lsay ne '' ) {
        print <<"_HTML_";
  <th>���̚����摜</th>
_HTML_
    }

    print <<"_HTML_";
  <th>���O</th>
</tr>
</thead>

<tbody>
_HTML_

    sub create_img_html {
        my ( $charset, $img_name, $expression, $chrname, $net ) = @_;
        return
"  <td style=\"text-align: center;\"><img src=\"$charset->{'DIR'}/$img_name$expression$charset->{'EXT'}\" width=\"$charset->{'IMGBODYW'}\" height=\"$charset->{'IMGBODYH'}\" alt=\"$chrname�̉摜\"$net></td>\n";
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
        $dummychr = "���_�~�[�L����<br$net>" if ( $charset->{'NPCID'} eq $_ );
        my $romanname = '';
        $romanname = "<br$net>$charset->{'CHRROMANNAME'}->{$_}"
          if ( defined( $charset->{'CHRROMANNAME'} ) );
        print "  <td>$dummychr$chrname$romanname</td>\n";
        print "</tr>\n";
    }

    print "\n<tr>\n";
    print create_img_html( $charset, $sow->{'cfg'}->{'CID_GUEST'}, '', '�T�ώ�', $net );
    print "<td></td>\n" if ( $body ne '' );
    print "<td></td>\n" if ( $grave ne '' );
    print "<td></td>\n" if ( $wolf ne '' );
    print "<td></td>\n" if ( $tsay ne '' );
    print "<td></td>\n" if ( $lsay ne '' );
    print "<td>�T�ώ�</td>\n";
    print "</tr>\n";
    print <<"_HTML_";
</tbody>
</table>

_HTML_

    return;
}

1;
