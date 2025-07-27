package SWHtmlVlogPC;

#----------------------------------------
# �����O�\���iPC���[�h�j��HTML�o��
#----------------------------------------
sub OutHTMLVlogPC {
    my ( $sow, $vil, $logfile, $maxrow, $logs, $logkeys, $rows ) = @_;
    my $pllist = $vil->getpllist();

    my $net   = $sow->{'html'}->{'net'};    # Null End Tag
    my $amp   = $sow->{'html'}->{'amp'};
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};

    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

    # TODO: parmalink�̏ꍇ�͊Y���̔����ɔ�Ԃ悤�ɂ���H
    my $titlelink = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?vid=$query->{'vid'}";

    my $logfilelist = $logfile->getlist();

    # ���OID�w��\���X�C�b�`
    my $modesingle = 0;
    $modesingle = 1
      if ( $query->{'logid'} ne '' );

    # ���O�C��HTML
    $sow->{'html'}->outcontentheader();
    &SWHtmlPC::OutHTMLLogin($sow) if ( $modesingle == 0 );

    # ���o���i������RSS�j
    my $titleupdate = &SWHtmlPC::GetTitleNextUpdate( $sow, $vil );
    my $linkrss     = " <a href=\"$link$amp" . "cmd=rss\">RSS</a>";
    my $twitter =
"<p class=\"return\"><a href=\"https://twitter.com/share\" class=\"twitter-share-button\" data-count=\"horizontal\" data-via=\"webwolves\" data-lang=\"ja\">Tweet</a><script type=\"text/javascript\" src=\"https://platform.twitter.com/widgets.js\"></script></p>";
    $linkrss = '' if ( $cfg->{'ENABLED_RSS'} == 0 );
    $twitter = '' if ( $vil->{'turn'} > 0 );
    print "<h2><a href=\"$titlelink\">$query->{'vid'} $vil->{'vname'}</a>";
    print "$titleupdate$linkrss$twitter"
      if ( $vil->{'epilogue'} >= $vil->{'turn'} );
    print "</h2>\n\n";

    # �ʃt�B���^�ւ̃����N
    if ( $modesingle eq 0 ) {
        require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
        &SWHtmlPlayerFormPC::OutHTMLPlayerFilter( $sow, $vil );
    }

    # ���t�ʃ��O�ւ̃����N
    if ( $modesingle == 0 ) {

        #		my $list = $logfile->getlist();
        &SWHtmlPC::OutHTMLTurnNavi( $sow, $vil, $logs, $logfilelist, $rows, 0 );
    }

    # �I���\��
    if (   ( $sow->{'turn'} == $vil->{'turn'} )
        && ( $vil->{'epilogue'} < $vil->{'turn'} ) )
    {
        print <<"_HTML_";
<p class="caution">
�I�����܂����B
</p>
<hr class="invisible_hr"$net>
_HTML_

        &SWHtmlPC::OutHTMLReturnPC($sow);    # �g�b�v�y�[�W�֖߂�
        $sow->{'html'}->outcontentfooter();
        &SWHtmlSayFilter::OutHTMLSayFilter( $sow, $vil )
          if ( $modesingle == 0 );

        return;
    }

    # �S�\�������N
    #	my $rowover = 0;
    my $rowover = $rows->{'rowover'};
    if ( $modesingle == 0 ) {
        if ( ( $maxrow != 0 ) && ( $rows->{'rowover'} > 0 ) ) {
            print "<p class=\"row_all\">\n<a href=\"$link$amp" . "rowall=on\">�S�ĕ\\��</a>\n</p>\n\n";
        }
    }

    # �����O�\��
    print "<hr class=\"invisible_hr\"$net>\n\n";
    require "$cfg->{'DIR_HTML'}/html_vlogsingle_pc.pl";
    my %anchor = (
        logfile => $logfile,
        logkeys => $logkeys,
        rowover => $rowover,
        reqvals => $reqvals,
    );

    if ( ( $query->{'order'} eq 'desc' ) || ( $query->{'order'} eq 'd' ) ) {

        # �~��
        if ( $modesingle == 0 ) {
            print
"<p id=\"newinfo\" class=\"newinfo\"><span id=\"newinfomes\">�V�������͂���܂���B</span><a href=\"#newinfo\" id=\"reloadlink\" onclick=\"reloadSowFeed();return false;\">RELOAD</a><img src=\"$cfg->{'DIR_IMG'}/ajax-loader.gif\" style=\"display: none;\"><a href=\"$link&logid=$logid&move=next\" id=\"getnewloglink\" onclick=\"getNewLog(this);return false;\"></a><span class=\"new_date\" id=\"newinfotime\">�ŏI�擾���� --:--:--</span></p>\n";
        }
        my $i;
        for ( $i = $#$logs ; $i >= 0 ; $i-- ) {
            my $log =
              $logfile->{'logfile'}->{'file'}->read( $logs->[$i]->{'pos'} );
            &SWHtmlVlogSinglePC::OutHTMLSingleLogPC( $sow, $vil, $log, $i, \%anchor, $modesingle );
        }
    }
    else {
        # ����
        my $i;
        for ( $i = 0 ; $i < @$logs ; $i++ ) {
            my $log =
              $logfile->{'logfile'}->{'file'}->read( $logs->[$i]->{'pos'} );
            my $logid = $log->{'logid'};
            if (   ( $modesingle == 0 )
                && ( $i == 0 )
                && ( ( $maxrow != 0 ) && ( $rows->{'rowover'} > 0 ) ) )
            {
                if (
                    (
                           ( $log->{'mestype'} eq $sow->{'MESTYPE_INFOSP'} )
                        || ( $log->{'mestype'} eq $sow->{'MESTYPE_TSAY'} )
                    )
                    && ( $vil->isepilogue() == 0 )
                  )
                {
                    $logid = $log->{'maskedid'};
                }
                print
"<p id=\"readmore\" class=\"readmore\"><a href=\"$link&logid=$logid&move=prev\" onclick=\"getMoreLog(this);return false;\">�����Ɠǂ�</a><img id=\"morelog-ajax-loader\" src=\"$cfg->{'DIR_IMG'}/ajax-loader.gif\" style=\"display: none;\"></p>\n\n";
            }
            &SWHtmlVlogSinglePC::OutHTMLSingleLogPC( $sow, $vil, $log, $i, \%anchor, $modesingle );
            if ( $i == $#$logs ) {

                # TODO: �ł���΂����Ɠ��̂��������ɂ�����
                my $pi = $i;
                my $prevlog;
                my $mestype = $log->{'mestype'};
                while ( $mestype eq $sow->{'MESTYPE_QUE'} ) {
                    $pi      = $pi - 1;
                    $prevlog = $logfile->{'logfile'}->{'file'}->read( $logs->[$pi]->{'pos'} );
                    $mestype = $prevlog->{'mestype'};
                    $logid   = $prevlog->{'logid'};

                    if (
                        (
                               ( $prevlog->{'mestype'} eq $sow->{'MESTYPE_INFOSP'} )
                            || ( $prevlog->{'mestype'} eq $sow->{'MESTYPE_TSAY'} )
                        )
                        && ( $vil->isepilogue() == 0 )
                      )
                    {
                        $logid = $prevlog->{'maskedid'};
                    }
                    break if ( $pi == 0 );
                }

                if (
                    (
                           ( $log->{'mestype'} eq $sow->{'MESTYPE_INFOSP'} )
                        || ( $log->{'mestype'} eq $sow->{'MESTYPE_TSAY'} )
                    )
                    && ( $vil->isepilogue() == 0 )
                  )
                {
                    $logid = $log->{'maskedid'};
                }
                if ( $modesingle == 0 ) {
                    print
"<p id=\"newinfo\" class=\"newinfo\"><span id=\"newinfomes\">�V�������͂���܂���B</span><a href=\"#newinfo\" id=\"reloadlink\" onclick=\"reloadSowFeed();return false;\">RELOAD</a><img src=\"$cfg->{'DIR_IMG'}/ajax-loader.gif\" style=\"display: none;\"><a href=\"$link&logid=$logid&move=next\" id=\"getnewloglink\" onclick=\"getNewLog(this);return false;\"></a><span class=\"new_date\" id=\"newinfotime\">�ŏI�擾���� --:--:--</span></p>\n";
                }
            }
        }
    }

    # �A�i�E���X�^���́E�Q���t�H�[���\��
    if (   ( $modesingle == 0 )
        && ( $sow->{'turn'} == $vil->{'turn'} )
        && ( $rows->{'end'} > 0 ) )
    {
        &OutHTMLVlogFormArea( $sow, $vil );
    }

    # �ʃt�B���^�ւ̃����N
    if ( $modesingle eq 0 ) {
        require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
        &SWHtmlPlayerFormPC::OutHTMLPlayerFilter( $sow, $vil );
    }

    # ���t�ʃ��O�ւ̃����N
    if ( $modesingle == 0 ) {

        #		my $list = $logfile->getlist();
        &SWHtmlPC::OutHTMLTurnNavi( $sow, $vil, $logs, $logfilelist, $rows, 1 );
    }

    if ( $modesingle == 0 ) {
        $reqvals            = &SWBase::GetRequestValues($sow);
        $reqvals->{'order'} = '';
        $reqvals->{'row'}   = '';
        my $hidden = &SWBase::GetHiddenValues( $sow, $reqvals, '  ' );

        my $option    = $sow->{'html'}->{'option'};
        my $desc      = '';
        my $asc       = " $sow->{'html'}->{'selected'}";
        my $star_desc = '';
        my $star_asc  = ' *';
        if ( ( $query->{'order'} eq 'd' ) || ( $query->{'order'} eq 'desc' ) ) {
            $desc      = " $sow->{'html'}->{'selected'}";
            $asc       = '';
            $star_desc = ' *';
            $star_asc  = '';
        }

        print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="get" class="viewform">
<p>$hidden
  <label for="row">�\\���s��</label>
  <select id="row" name="row">
_HTML_

        my $row_pc = $sow->{'cfg'}->{'ROW_PC'};
        my $row    = $sow->{'cfg'}->{'MAX_ROW'};
        $row = $query->{'row'} if ( defined( $query->{'row'} ) );
        foreach (@$row_pc) {
            my $selected = '';
            my $star     = '';
            if ( $_ == $row ) {
                $selected = " $sow->{'html'}->{'selected'}";
                $star     = ' *';
            }
            print "    <option value=\"$_\"$selected>$_$star$option\n";
        }

        print <<"_HTML_";
  </select>
  <select name="order">
    <option value="asc"$asc>�ォ�牺$star_asc$option
    <option value="desc"$desc>�������$star_desc$option
  </select>
  <input type="submit" value="�ύX" data-submit-type="order"$net>
</p>
</form>
<hr class="invisible_hr"$net>

_HTML_
    }

    # �g�b�v�y�[�W�֖߂�
    &SWHtmlPC::OutHTMLReturnPC($sow) if ( $modesingle == 0 );

    # �����t�B���^
    $sow->{'html'}->outcontentfooter();
    &SWHtmlSayFilter::OutHTMLSayFilter( $sow, $vil ) if ( $modesingle == 0 );

    return;
}

#----------------------------------------
# �A�i�E���X�^���́E�Q���t�H�[���\��
#----------------------------------------
sub OutHTMLVlogFormArea {
    my ( $sow, $vil ) = @_;
    my $cfg    = $sow->{'cfg'};
    my $net    = $sow->{'html'}->{'net'};
    my $pllist = $vil->getpllist();
    my $date   = $sow->{'dt'}->cvtdt( $vil->{'nextupdatedt'} );
    my $scraplimit = '';
    if ( $vil->{'scraplimitdt'} != 0 ) {
        $scraplimit = "\n\n<p class=\"caution\">\n" . $vil->getinfocap('scraplimit') . "�܂łɊJ�n���Ȃ������ꍇ�A���̑��͔p���ƂȂ�܂��B\n</p>";
    }

    if (   ( $vil->{'turn'} == 0 )
        && ( $vil->checkentried() < 0 )
        && ( $vil->{'vplcnt'} > @$pllist ) )
    {
        # �v�����[�O���Q���^�����O�C�����A�i�E���X
        print <<"_HTML_";
<p class="caution">
���������L�����N�^�[��I�сA�������Ă��������B<br$net>
���[�����悭����������ł��Q���������B<br$net>
����]�\\�͂ɂ��Ă̔����͍T���Ă��������B
</p>$scraplimit
<hr class="invisible_hr"$net>
_HTML_
    }
    elsif ( $vil->{'turn'} == 0 ) {
        print $scraplimit;
    }
    elsif ( $vil->isepilogue() > 0 ) {

        # �G�s���[�O�p�A�i�E���X
        my $caption_winner = $sow->{'textrs'}->{'CAPTION_WINNER'};
        my $victorytext    = $sow->{'textrs'}->{'ANNOUNCE_VICTORY'};
        my $caption        = $caption_winner->[ $vil->{'winner'} ];
        $victorytext =~ s/_VICTORY_/$caption/g;
        $victorytext = '' if ( $vil->{'winner'} == 0 );
        my $epiloguetext = $sow->{'textrs'}->{'ANNOUNCE_EPILOGUE'};
        $epiloguetext =~ s/_AVICTORY_/$victorytext/g;
        $epiloguetext =~ s/_DATE_/$date/g;
        &SWHtml::ConvertNET( $sow, \$epiloguetext );

        print <<"_HTML_";
<p class="caution">
$epiloguetext
</p>
<hr class="invisible_hr"$net>

_HTML_
    }

    # �������҃��X�g�̕\��
    my $nosaytext = &SWHtmlVlog::GetNoSayListText( $sow, $vil );
    if (   ( $vil->{'turn'} != 0 )
        && ( $vil->isepilogue() == 0 )
        && ( $nosaytext ne '' ) )
    {
        print "<p class=\"caution\">$nosaytext</p>\n";
        print "<hr class=\"invisible_hr\"$net>\n\n";
    }

    # �������^�G���g���[�t�H�[��
    if ( $vil->{'turn'} == 0 ) {

        # �v�����[�O
        if ( $sow->{'user'}->logined() > 0 ) {

            # ���O�C���ς�
            if ( $vil->checkentried() >= 0 ) {
                if ( $sow->{'curpl'}->{'limitentrydt'} > 0 ) {
                    my $limitdate =
                      $sow->{'dt'}->cvtdt( $sow->{'curpl'}->{'limitentrydt'} );
                    print <<"_HTML_";
<p class="caution">
$limitdate�܂łɈ�x���������������J�n����Ȃ������ꍇ�A���Ȃ��͎����I�ɑ�����ǂ��o����܂��B<br$net>
����������Ɗ�������������܂��B
</p>
_HTML_
                }

                # �������̕\��
                require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
                &SWHtmlPlayerFormPC::OutHTMLPlayerFormPC( $sow, $vil );
            }
            elsif ( $vil->{'vplcnt'} > @$pllist ) {

                # �G���g���[�t�H�[���̕\��
                require "$cfg->{'DIR_HTML'}/html_entryform_pc.pl";
                &SWHtmlEntryFormPC::OutHTMLEntryFormPC( $sow, $vil );
                &OutHTMLVilMakerInFormPlPC( $sow, $vil );
            }
            else {
                print "<p class=\"caution\">\n���ɒ���ɒB���Ă��܂��B\n</p>\n";
                print "<hr class=\"invisible_hr\"$net>\n\n";
                &OutHTMLVilMakerInFormPlPC( $sow, $vil );
            }
        }
        else {
            # �����O�C��
            if ( $vil->{'vplcnt'} > @$pllist ) {
                print "<p class=\"infonologin\">\n�Q�[���Q���Ҋ�]�҂̓��O�C�����ĉ������B\n</p>\n";
                print "<hr class=\"invisible_hr\"$net>\n\n";
            }
            else {
                print "<p class=\"caution\">\n���ɒ���ɒB���Ă��܂��B\n</p>\n";
                print "<hr class=\"invisible_hr\"$net>\n\n";
            }
        }
    }
    else {
        # �i�s��
        if ( $sow->{'user'}->logined() > 0 ) {

            # ���O�C���ς�
            if ( $vil->checkentried() >= 0 ) {

                # �������̕\��
                require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
                &SWHtmlPlayerFormPC::OutHTMLPlayerFormPC( $sow, $vil );
            }
            else {
                # �����Đl�^�Ǘ��l�����t�H�[���̕\��
                &OutHTMLVilMakerInFormPlPC( $sow, $vil );
            }
        }
        elsif ( $vil->isepilogue() == 0 ) {

            # �����O�C��
            print "<p class=\"infonologin\">\n�Q���҂̓��O�C�����ĉ������B\n</p>\n";
            print "<hr class=\"invisible_hr\"$net>\n\n";
        }
    }
    return;
}

#----------------------------------------
# �����Đl�t�H�[���^�Ǘ��l�t�H�[���̕\��
# �i�����Đl�^�Ǘ��l���Q�����Ă��Ȃ����j
#----------------------------------------
sub OutHTMLVilMakerInFormPlPC {
    my ( $sow, $vil ) = @_;
    my $cfg = $sow->{'cfg'};

    if ( $vil->{'makeruid'} eq $sow->{'uid'} ) {
        require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
        print "<div class=\"formpl_frame\">\n";
        &SWHtmlPlayerFormPC::OutHTMLVilMakerPC( $sow, $vil, 'maker' )
          if ( ( $vil->{'turn'} == 0 )
            || ( $vil->isepilogue() != 0 )
            || ( $vil->{'makersaymenu'} == 0 ) );
        &SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC( $sow, $vil )
          if ( $vil->{'turn'} == 0 );
        &SWHtmlPlayerFormPC::OutHTMLKickFormPC( $sow, $vil )
          if ( $vil->{'turn'} == 0 );
        print "</div>\n";
    }

    if ( $sow->{'uid'} eq $cfg->{'USERID_ADMIN'} ) {
        require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";
        print "<div class=\"formpl_frame\">\n";
        &SWHtmlPlayerFormPC::OutHTMLVilMakerPC( $sow, $vil, 'admin' );
        &SWHtmlPlayerFormPC::OutHTMLUpdateSessionButtonPC( $sow, $vil );
        &SWHtmlPlayerFormPC::OutHTMLScrapVilButtonPC( $sow, $vil )
          if ( $vil->{'turn'} < $vil->{'epilogue'} );
        &SWHtmlPlayerFormPC::OutHTMLExtendScrapVilButtonPC( $sow, $vil )
          if ( $vil->{'turn'} == 0 );
        &SWHtmlPlayerFormPC::OutHTMLEnableChatModeButtonPC( $sow, $vil )
          if ( $vil->{'turn'} == 0 );
        &SWHtmlPlayerFormPC::OutHTMLKickFormPC( $sow, $vil )
          if ( $vil->{'turn'} == 0 );
        print "</div>\n";
    }

    print "<div class=\"formpl_frame\">\n";
    require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";

    if ( $vil->{'guestmenu'} == 0 ) {
        &SWHtmlPlayerFormPC::OutHTMLVilGuestPC( $sow, $vil, 'guest' );
    }
    print "</div>\n";

    return;
}

1;
