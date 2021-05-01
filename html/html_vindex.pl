package SWHtmlVIndex;

#----------------------------------------
# ���̈ꗗHTML�o��
#----------------------------------------
sub OutHTMLVIndex {
    my ( $sow, $vindex, $vmode ) = @_;
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};
    my $net   = $sow->{'html'}->{'net'};    # Null End Tag
    my $amp   = $sow->{'html'}->{'amp'};

    require "$cfg->{'DIR_LIB'}/log.pl";

    my $maxrow = $sow->{'cfg'}->{'MAX_ROW'};    # �W���s��
    $maxrow = $query->{'row'}
      if ( defined( $query->{'row'} ) && ( $query->{'row'} ne '' ) );    # �����ɂ��s���w��
    $maxrow = -1
      if ( ( $maxrow eq 'all' ) || ( $query->{'rowall'} ne '' ) );       # �����ɂ��S�\���w��

    my $pageno = 0;
    $pageno = $query->{'pageno'} if ( defined( $query->{'pageno'} ) );

    print <<"_HTML_";
<table border="1" class="vindex" summary="���̈ꗗ">
<thead>
  <tr>
    <th scope="col">���̖��O</th>
    <th scope="col">�l��</th>
_HTML_

    if ( $vmode eq 'oldlog' ) {
        print "    <th id=\"days_$vmode\">����</th>\n";
    }
    else {
        print "    <th id=\"vstatus_$vmode\">�i�s</th>\n";
    }

    print <<"_HTML_";
    <th scope="col">�X�V</th>
    <th scope="col">��E�z��</th>
    <th scope="col">��������</th>
  </tr>
</thead>

<tbody>
_HTML_

    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'cmd'} = '';
    $reqvals->{'vid'} = '';

    my $vilist  = $vindex->getvilist();
    my $vicount = 0;
    my $virow   = -1;
    foreach (@$vilist) {
        my $date = sprintf( "%02d:%02d", $_->{'updhour'}, $_->{'updminite'} );
        my $vil = SWFileVil->new( $sow, $_->{'vid'} );
        $vil->readvil();
        my $pllist = $vil->getpllist();
        $vil->closevil();

        my $vstatusno = 'playing';
        $vstatusno = 'prologue' if ( $vil->{'turn'} == 0 );    # �v�����[�O
        $vstatusno = 'oldlog'
          if ( $vil->{'epilogue'} < $vil->{'turn'} );          # �I��������

        next if ( $vstatusno ne $vmode );                      # �w�肵�Ă��Ȃ����͏��O

        if ( !defined( $vil->{'trsid'} ) ) {

            # ���f�[�^���Ԃ���񂾏ꍇ�Ɉꉞ��Q��H���~�߂�
            print <<"_HTML_";
  <tr>
    <td colspan="5"><span class="cautiontext">$_->{'vid'}���̃f�[�^���擾�ł��܂���B</span></td>
  </tr>

_HTML_
            next;
        }

        $virow++;
        if ( $maxrow > 0 ) {
            next if ( $virow < $pageno * $maxrow );
            next if ( $virow >= ( $pageno + 1 ) * $maxrow );
        }

        $vicount++;
        &SWBase::LoadTextRS( $sow, $vil );
        my $csname = '����';
        if ( index( $vil->{'csid'}, '/' ) < 0 ) {
            $sow->{'charsets'}->loadchrrs( $vil->{'csid'} );
            my $charset = $sow->{'charsets'}->{'csid'}->{ $vil->{'csid'} };
            $csname = $charset->{'CAPTION'};
        }

        my $plcnt = scalar(@$pllist);
        if ( $vmode eq 'prologue' ) {
            $plcnt .= "/$vil->{'vplcnt'}�l";
        }
        else {
            $plcnt .= '�l';
        }

        my $updintervalday = $vil->{'updinterval'} * 24;
        $updintervalday .= 'h';
        my $vstatus = "$vil->{'turn'}����";
        if ( $vil->{'winner'} != 0 ) {
            $vstatus = '����';
        }
        elsif ( $vil->isepilogue() > 0 ) {
            $vstatus = '�p��';
        }
        if ( $vmode eq 'oldlog' ) {
            my $numdays = $vil->{'turn'} - 2;
            if ( $vstatus eq '�p��' ) {
                $vstatus = "$numdays��(�p��)";
            }
            else {
                $vstatus = "$numdays��";
            }
        }
        if ( $vil->{'turn'} == 0 ) {
            if ( $vil->{'vplcnt'} > @$pllist ) {
                $vstatus = '��W��';
            }
            else {
                $vstatus = '�J�n�O';
            }
        }

        my $countssay = $sow->{'cfg'}->{'COUNTS_SAY'};
        my $imgpwdkey = '';
        if ( defined( $vil->{'entrylimit'} ) ) {
            $imgpwdkey = "<img src=\"$cfg->{'DIR_IMG'}/key.png\" width=\"16\" height=\"16\" alt=\"[��]\"$net> "
              if ( $vil->{'entrylimit'} eq 'password' );
        }

        my $imgrating = '';
        if ( ( defined( $vil->{'rating'} ) ) && ( $vil->{'rating'} ne '' ) ) {
            if ( defined( $sow->{'cfg'}->{'RATING'}->{ $vil->{'rating'} }->{'FILE'} ) ) {
                my $rating = $sow->{'cfg'}->{'RATING'}->{ $vil->{'rating'} };
                $imgrating =
"<img src=\"$cfg->{'DIR_IMG'}/$rating->{'FILE'}\" width=\"$rating->{'WIDTH'}\" height=\"$rating->{'HEIGHT'}\" alt=\"[$rating->{'ALT'}]\" title=\"$rating->{'CAPTION'}\"$net> "
                  if ( $rating->{'FILE'} ne '' );
            }
        }

        $reqvals->{'cmd'} = '';
        $reqvals->{'vid'} = $_->{'vid'};
        my $link = &SWBase::GetLinkValues( $sow, $reqvals );
        $reqvals->{'cmd'} = 'vinfo';
        my $linkvinfo = &SWBase::GetLinkValues( $sow, $reqvals );
        my $vcomment = &SWLog::ReplaceAnchorHTMLRSS( $sow, $vil, $vil->{'vcomment'} );

        print <<"_HTML_";
  <tr>
    <td>$imgpwdkey$imgrating<a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link#newsay">$_->{'vid'} $vil->{'vname'}</a> �q<a href="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$linkvinfo#newsay" title="$vcomment">���</a>�r</td>
    <td>$plcnt</td>
    <td>$vstatus</td>
    <td>$date/$updintervalday</td>
    <td>$sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$vil->{'roletable'}}</td>
    <td>$countssay->{$vil->{'saycnttype'}}->{'CAPTION'}</td>
  </tr>

_HTML_

    }

    if ( $vicount == 0 ) {
        my $vmodetext;
        if ( $vmode eq 'prologue' ) {
            $vmodetext = '��W���^�J�n�҂�';
        }
        elsif ( $vmode eq 'oldlog' ) {
            $vmodetext = '�I���ς�';
        }
        else {
            $vmodetext = '�i�s��';
        }

        print <<"_HTML_";
  <tr>
    <td colspan="6">����$vmodetext�̑��͂���܂���B</td>
  </tr>

_HTML_
    }

    print <<"_HTML_";
</tbody>
</table>

_HTML_

    if ( $vmode eq 'oldlog' ) {
        print "<p class=\"pagenavi\">\n";
        $reqvals = &SWBase::GetRequestValues($sow);
        $reqvals->{'cmd'} = $query->{'cmd'};

        if ( ( $pageno > 0 ) && ( $maxrow > 0 ) ) {
            $reqvals->{'pageno'} = $pageno - 1;
            my $link = &SWBase::GetLinkValues( $sow, $reqvals );
            print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">�O�̃y�[�W</a> \n";
        }
        else {
            print "�O�̃y�[�W \n";
        }

        if ( ( ( $pageno + 1 ) * $maxrow <= $virow ) && ( $maxrow > 0 ) ) {
            $reqvals->{'pageno'} = $pageno + 1;
            my $link = &SWBase::GetLinkValues( $sow, $reqvals );
            print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">���̃y�[�W</a> \n";
        }
        else {
            print "���̃y�[�W \n";
        }

        if ( ( $virow + 1 ) != $vicount ) {
            $reqvals->{'rowall'} = 'on';
            my $link = &SWBase::GetLinkValues( $sow, $reqvals );
            print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">�S�\\��</a>\n";
        }
        else {
            print "�S�\\��\n";
        }
        print "</p>\n";
    }
}

1;
