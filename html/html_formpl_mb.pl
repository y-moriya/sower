package SWHtmlPlayerFormMb;

#----------------------------------------
# �v���C���[�����^�s����HTML�o��
#----------------------------------------
sub OutHTMLPlayerFormMb {
    my ( $sow, $vil ) = @_;
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};
    my $curpl = $sow->{'curpl'};

    $sow->{'html'} = SWHtml->new($sow);    # HTML���[�h�̏�����
    my $outhttp = $sow->{'http'}->outheader();    # HTTP�w�b�_�̏o��
    return if ( $outhttp == 0 );                  # �w�b�_�o�͂̂�
    $sow->{'html'}->outheader("$sow->{'query'}->{'vid'} $vil->{'vname'}");    # HTML�w�b�_�̏o��

    my $net    = $sow->{'html'}->{'net'};                                     # Null End Tag
    my $option = $sow->{'html'}->{'option'};

    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

    print <<"_HTML_";
<a name="say">$sow->{'query'}->{'vid'} $vil->{'vname'}</a><br$net>
<a href="$link" accesskey="4">�߂�</a>/<a href="#action" accesskey="6">ACT</a>/<a href="#role" accesskey="8">�\\��</a><br$net>
<hr$net>
_HTML_

    # ������HTML�o��
    &OutHTMLSayMb( $sow, $vil );

    # �\�͎җ�HTML�o��
    my %role;
    if ( $curpl->{'role'} < 0 ) {
        $role{'role'} = $curpl->{'selrole'};
    }
    else {
        $role{'role'} = $curpl->{'role'};
    }
    my $textrs = $sow->{'textrs'};
    if ( $curpl->{'role'} < 0 ) {
        $role{'explain'} = $textrs->{'EXPLAIN_ROLES'}->{'prologue'};
        if ( $vil->{'noselrole'} > 0 ) {
            $role{'explain'} = $textrs->{'EXPLAIN_ROLES'}->{'noselrole'};
        }
    }
    elsif ( $vil->isepilogue() != 0 ) {
        $role{'explain'} = $textrs->{'EXPLAIN_ROLES'}->{'epilogue'};
    }
    else {
        $role{'explain'} = $textrs->{'EXPLAIN_ROLES'}->{'dead'};
    }
    my $selrolename = $textrs->{'ROLENAME'}->[ $curpl->{'selrole'} ];
    $selrolename = $textrs->{'RANDOMROLE'} if ( $curpl->{'selrole'} < 0 );
    $role{'explain'} =~ s/_SELROLE_/$selrolename/;
    $role{'explain'} =~ s/_ROLE_/$textrs->{'ROLENAME'}->[$curpl->{'role'}]/;
    $role{'explain_role'} = $textrs->{'EXPLAIN_ROLES'}->{'explain'};

    &OutHTMLRoleMb( $sow, $vil, \%role );

    # �����Đl�t�H�[���^�Ǘ��l�t�H�[���^�T�ώ҃t�H�[���\��
    if ( $vil->{'makeruid'} eq $sow->{'uid'} ) {
        &OutHTMLVilMakerMb( $sow, $vil, 'maker' )
          if ( ( $vil->{'turn'} == 0 )
            || ( $vil->isepilogue() != 0 )
            || ( $vil->{'makersaymenu'} == 0 ) );

        # �J�n�A�ҏW�ƃL�b�N�{�^���͌�񂵁B
        #&OutHTMLUpdateSessionButtonPC($sow, $vil) if ($vil->{'turn'} == 0);
        #&OutHTMLKickFormPC($sow, $vil) if ($vil->{'turn'} == 0);
    }
    if ( $sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'} ) {
        &OutHTMLVilMakerMb( $sow, $vil, 'admin' );

        # �J�n�A�ҏW�ƃL�b�N�{�^���͌�񂵁B
        #&OutHTMLUpdateSessionButtonPC($sow, $vil);
        #&OutHTMLKickFormPC($sow, $vil) if ($vil->{'turn'} == 0);
        #&OutHTMLScrapVilButtonPC($sow, $vil) if ($vil->{'turn'} < $vil->{'epilogue'});
    }
    if ( $vil->{'guestmenu'} == 0 ) {
        &OutHTMLGuestMb( $sow, $vil );
    }

    print <<"_HTML_";
<hr$net>
<a href="$link">�߂�</a>/<a href="#say" accesskey="2">����</a>/<a href="#action">ACT</a>
_HTML_

    $sow->{'html'}->outfooter();    # HTML�t�b�^�̏o��
    $sow->{'http'}->outfooter();

    return;
}

#----------------------------------------
# �����Đl�������o��
#----------------------------------------
sub OutHTMLVilMakerMb {
    my ( $sow, $vil, $writemode ) = @_;
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};
    my $net   = $sow->{'html'}->{'net'};

    my $curpl    = $sow->{'curpl'};
    my $csidlist = $sow->{'csidlist'};
    my @keys     = keys(%$csidlist);
    my %imgpl    = (
        cid      => $writemode,
        csid     => $keys[0],
        deathday => -1,
    );
    my $chrname =
      $sow->{'charsets'}->getchrname( $imgpl{'csid'}, $imgpl{'cid'} );

    print "<hr$net>��$chrname<br$net>\n";

    my $reqvals    = &SWBase::GetRequestValues($sow);
    my $hidden     = &SWBase::GetHiddenValues( $sow, $reqvals, '' );
    my $linkvalues = &SWBase::GetLinkValues( $sow, $reqvals );

    print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
_HTML_

    # �e�L�X�g�{�b�N�X�Ɣ����{�^��
    my $caption_say = $sow->{'textrs'}->{'CAPTION_SAY_MB'};
    my $buttonlabel = $sow->{'textrs'}->{'BUTTONLABEL_MB'};
    $buttonlabel =~ s/_BUTTON_/$caption_say/g;

    my $mes = '';
    $mes = $query->{'mes'} if ( $query->{'guest'} ne '' );
    $mes =~ s/<br( \/)?>/\n/ig;
    print <<"_HTML_";
<textarea name="mes" rows="3" istyle="1">$mes</textarea><br$net>
<input type="hidden" name="cmd" value="writepr"$net>
<input type="hidden" name="$writemode" value="on"$net>$hidden
<input type="submit" value="$buttonlabel"$net>
</form>
_HTML_

}

#----------------------------------------
# ���[�^�\�͑Ώۃv���_�E�����X�g�o��
#----------------------------------------
sub OutHTMLVoteMb {
    my ( $sow, $vil, $cmd ) = @_;
    my $cfg    = $sow->{'cfg'};
    my $query  = $sow->{'query'};
    my $net    = $sow->{'html'}->{'net'};
    my $curpl  = $sow->{'curpl'};
    my $option = $sow->{'html'}->{'option'};

    # �����l�̎擾
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $hidden = &SWBase::GetHiddenValues( $sow, $reqvals, '' );

    print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
<input type="hidden" name="cmd" value="$cmd">$hidden
_HTML_

    if ( $cmd eq 'vote' ) {
        my $votelabels         = $sow->{'textrs'}->{'VOTELABELS'};
        my $selected_vote      = " $sow->{'html'}->{'selected'}";
        my $selectstar_vote    = ' *';
        my $selected_entrust   = '';
        my $selectstar_entrust = '';
        if ( $curpl->{'entrust'} > 0 ) {
            $selected_vote      = '';
            $selectstar_vote    = '';
            $selected_entrust   = " $sow->{'html'}->{'selected'}";
            $selectstar_entrust = ' *';
        }
        my $option = $sow->{'html'}->{'option'};

        if ( $vil->{'entrustmode'} == 0 ) {
            print <<"_HTML_";
	      <select name="entrust">
	        <option value=""$selected_vote>$votelabels->[0]$selectstar_vote$option
	        <option value="on"$selected_entrust>$votelabels->[1]$selectstar_entrust$option
	      </select>
_HTML_
        }
        else {
            print "$votelabels->[0]: ";
        }
    }
    else {

        my $votelabel = $sow->{'textrs'}->{'ABI_ROLE'}->[ $curpl->{'role'} ];
        print "$votelabel�F\n";
    }

    print <<"_HTML_";
<select name="target">
_HTML_

    # �Ώۂ̕\��
    $targetlist = $curpl->gettargetlistwithrandom($cmd);
    foreach (@$targetlist) {
        my $selected = '';
        my $selstar  = '';
        my $targetid = 'vote';
        $targetid = 'target' if ( $cmd ne 'vote' );
        if ( $curpl->{$targetid} == $_->{'pno'} ) {
            $selected = " $sow->{'html'}->{'selected'}";
            $selstar  = ' *';
        }
        print "<option value=\"$_->{'pno'}\"$selected>$_->{'chrname'}$selstar$option\n";
    }
    print "</select>";

    if (   ( $curpl->{'role'} == $sow->{'ROLEID_TRICKSTER'} )
        && ( $cmd ne 'vote' ) )
    {
        print " �ƁA<br$net>\n";
        print <<"_HTML_";
<select name="target2">
_HTML_

        # �Ώۂ̕\��
        $targetlist = $curpl->gettargetlistwithrandom($cmd);
        foreach (@$targetlist) {
            my $selected = '';
            my $selstar  = '';
            if ( $curpl->{'target2'} == $_->{'pno'} ) {
                $selected = " $sow->{'html'}->{'selected'}";
                $selstar  = ' *';
            }
            print "<option value=\"$_->{'pno'}\"$selected>$_->{'chrname'}$selstar$option\n";
        }
        print "</select>";
    }
    print "\n";

    print <<"_HTML_";
<input type="submit" value="�ύX\"><br$net>
</form>

_HTML_

    return;
}

#----------------------------------------
# ������HTML�o��
#----------------------------------------
sub OutHTMLSayMb {
    my ( $sow, $vil ) = @_;
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};
    my $net   = $sow->{'html'}->{'net'};

    my $curpl     = $sow->{'curpl'};
    my $chrname   = $curpl->getchrname();
    my $markbonds = '';
    $markbonds = " ��$sow->{'textrs'}->{'MARK_BONDS'}"
      if ( $curpl->{'bonds'} ne '' );
    print "��$chrname$markbonds<br$net>\n";

    my $reqvals    = &SWBase::GetRequestValues($sow);
    my $hidden     = &SWBase::GetHiddenValues( $sow, $reqvals, '' );
    my $linkvalues = &SWBase::GetLinkValues( $sow, $reqvals );

    # ���[��ύX�v���_�E��
    if (   ( $curpl->{'live'} eq 'live' )
        && ( $vil->{'turn'} > 1 )
        && ( $vil->isepilogue() == 0 ) )
    {
        &OutHTMLVoteMb( $sow, $vil, 'vote' );
    }

    print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
_HTML_

    # �\��I��
    &OutHTMLExpressionFormMb( $sow, $vil );

    # �e�L�X�g�{�b�N�X�Ɣ����{�^��
    my $caption_say = $sow->{'textrs'}->{'CAPTION_SAY_MB'};
    $caption_say = $sow->{'textrs'}->{'CAPTION_GSAY_MB'}
      if ( ( $curpl->{'live'} ne 'live' ) && ( $vil->isepilogue() == 0 ) );
    my $buttonlabel = $sow->{'textrs'}->{'BUTTONLABEL_MB'};
    $buttonlabel =~ s/_BUTTON_/$caption_say/g;

    $saycnttext = &SWBase::GetSayCountText( $sow, $vil );

    my $mes = '';
    $mes = $query->{'mes'}
      if ( ( $query->{'wolf'} eq '' )
        && ( $query->{'maker'} eq '' )
        && ( $query->{'admin'} eq '' )
        && ( $query->{'guest'} eq '' ) );
    $mes =~ s/<br( \/)?>/\n/ig;
    print <<"_HTML_";
<textarea name="mes" rows="3" istyle="1">$mes</textarea><br$net>
<input type="hidden" name="cmd" value="writepr"$net>$hidden
<input type="submit" value="$buttonlabel"$net>$saycnttext<br$net>
_HTML_

    my $saycnt = $cfg->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} };

    # �Ƃ茾�`�F�b�N�{�b�N�X
    if (   ( $curpl->{'live'} eq 'live' )
        || ( $cfg->{'ENABLED_TSAY_GRAVE'} > 0 ) )
    {    # �����Ă���^�扺�Ƃ茾�L��
        if ( ( $vil->isepilogue() == 0 ) || ( $cfg->{'ENABLED_TSAY_EP'} > 0 ) )
        {    # �G�s�ł͂Ȃ��^�G�s�Ƃ茾�L��
            if ( ( $vil->{'turn'} != 0 ) || ( $cfg->{'ENABLED_TSAY_PRO'} > 0 ) ) {
                my $unit =
                  $sow->{'basictrs'}->{'SAYTEXT'}
                  ->{ $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} }->{'COUNT_TYPE'} }->{'UNIT_SAY'};
                my $checked = '';
                $checked = " $sow->{'html'}->{'checked'}"
                  if ( ( $query->{'think'} ne '' )
                    && ( $query->{'guest'} eq '' ) );
                print
"<input type=\"checkbox\" name=\"think\" value=\"on\"$checked$net>$sow->{'textrs'}->{'CAPTION_TSAY_MB'} ����$curpl->{'tsay'}$unit\n";
            }
        }
    }

    my $checked = '';
    $checked = " $sow->{'html'}->{'checked'}"
      if ( ( $query->{'monospace'} ne '' ) && ( $query->{'guest'} eq '' ) );
    print "<input type=\"checkbox\" name=\"monospace\" value=\"on\"$checked$net>����\n";
    my $checked = '';
    $checked = " $sow->{'html'}->{'checked'}"
      if ( ( $query->{'loud'} ne '' ) && ( $query->{'guest'} eq '' ) );
    print "<input type=\"checkbox\" name=\"loud\" value=\"on\"$checked$net>�吺\n";

    print <<"_HTML_";
</form>
<hr$net>

_HTML_

    # �R�~�b�g�{�^��
    &OutHTMLCommitFormMb( $sow, $vil )
      if ( ( $vil->{'turn'} > 0 )
        && ( $vil->isepilogue() == 0 )
        && ( $sow->{'curpl'}->{'live'} eq 'live' ) );

    # �����o��i�b��j
    OutHTMLExitVilButtonMb( $sow, $vil ) if ( $vil->{'turn'} == 0 );

    # �A�N�V����
    &OutHTMLActionFormMb( $sow, $vil )
      if ( ( ( $curpl->{'live'} eq 'live' ) || ( $vil->isepilogue() != 0 ) )
        && ( ( $vil->{'noactmode'} == 0 ) || ( $vil->{'noactmode'} == 2 ) ) );

    return;
}

#----------------------------------------
# �T�ώҔ�����HTML�o��
#----------------------------------------
sub OutHTMLGuestMb {
    my ( $sow, $vil ) = @_;
    return
      if ( ( $vil->{'turn'} > 0 )
        && ( $vil->checkentried() > 0 )
        && ( $vil->isepilogue() == 0 ) );
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};
    my $net   = $sow->{'html'}->{'net'};

    my $curpl    = $sow->{'curpl'};
    my $csidlist = $sow->{'csidlist'};
    my @keys     = keys(%$csidlist);
    my %imgpl    = (
        cid      => 'guest',
        csid     => $keys[0],
        deathday => -1,
    );
    my $chrname =
      $sow->{'charsets'}->getchrname( $imgpl{'csid'}, $imgpl{'cid'} );

    print "��$chrname<br$net>\n";

    my $reqvals    = &SWBase::GetRequestValues($sow);
    my $hidden     = &SWBase::GetHiddenValues( $sow, $reqvals, '' );
    my $linkvalues = &SWBase::GetLinkValues( $sow, $reqvals );

    print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
_HTML_

    # �e�L�X�g�{�b�N�X�Ɣ����{�^��
    my $caption_say = $sow->{'textrs'}->{'CAPTION_SAY_MB'};
    $caption_say = $sow->{'textrs'}->{'CAPTION_GSAY_MB'}
      if ( ( $vil->{'turn'} > 0 ) && ( $vil->isepilogue() == 0 ) );
    my $buttonlabel = $sow->{'textrs'}->{'BUTTONLABEL_MB'};
    $buttonlabel =~ s/_BUTTON_/$caption_say/g;

    my $mes = '';
    $mes = $query->{'mes'} if ( $query->{'guest'} ne '' );
    $mes =~ s/<br( \/)?>/\n/ig;
    print <<"_HTML_";
<textarea name="mes" rows="3" istyle="1">$mes</textarea><br$net>
<input type="hidden" name="cmd" value="writepr"$net>
<input type="hidden" name="guest" value="on"$net>$hidden
<input type="submit" value="$buttonlabel"$net>
_HTML_

    # �Ƃ茾�`�F�b�N�{�b�N�X
    if ( ( $vil->isepilogue() == 0 ) || ( $cfg->{'ENABLED_TSAY_EP'} > 0 ) )
    {    # �G�s�ł͂Ȃ��^�G�s�Ƃ茾�L��
        my $checked = '';
        $checked = " $sow->{'html'}->{'checked'}"
          if ( ( $query->{'think'} ne '' ) && ( $query->{'guest'} ne '' ) );
        print
          "<input type=\"checkbox\" name=\"think\" value=\"on\"$checked$net>$sow->{'textrs'}->{'CAPTION_TSAY_MB'}\n";
    }

    my $checked = '';
    $checked = " $sow->{'html'}->{'checked'}"
      if ( ( $query->{'monospace'} ne '' ) && ( $query->{'guest'} ne '' ) );
    print "<input type=\"checkbox\" name=\"monospace\" value=\"on\"$checked$net>����\n";
    my $checked = '';
    $checked = " $sow->{'html'}->{'checked'}"
      if ( ( $query->{'loud'} ne '' ) && ( $query->{'guest'} ne '' ) );
    print "<input type=\"checkbox\" name=\"loud\" value=\"on\"$checked$net>�吺\n";

    # �T�ώҔ����ɂ��p�X���[�h���K�v�ɂ���
    if ( $vil->{'entrylimit'} eq 'password' ) {
        my $writepwd = '';
        $writepwd = $query->{'writepwd'} if ( $query->{'writepwd'} ne '' );
        print <<"_HTML_";
<br$net>
�p�X���[�h<br$net>
<input type="text" name="writepwd" size="8" istyle="3" value="$writepwd"$net><br$net>
_HTML_
    }

    print <<"_HTML_";
</form>
<hr$net>

_HTML_

    return;
}

#----------------------------------------
# �\�͎җ�HTML�o��
#----------------------------------------
sub OutHTMLRoleMb {
    my ( $sow, $vil, $role ) = @_;
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};
    my $net   = $sow->{'html'}->{'net'};

    my $curpl = $sow->{'curpl'};
    $selrole = $curpl->{'selrole'};

    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

    print <<"_HTML_";
<a name="role"><a href="$link">�߂�</a></a>/<a href="#say">����</a>/<a href="#action">ACT</a><br$net>
_HTML_

    if ( $vil->{'turn'} == 0 ) {
        print <<"_HTML_";
$role->{'explain'}<br$net>

_HTML_
    }
    elsif (( $vil->isepilogue() != 0 )
        || ( $sow->{'curpl'}->{'live'} ne 'live' ) )
    {
        # �\�͗��\���i�扺�^�G�s���[�O�j
        my $mes = $role->{'explain'};
        if ( $curpl->{'role'} == $sow->{'ROLEID_STIGMA'} ) {

            # �����ҏ���
            my $stigma_subid = $sow->{'textrs'}->{'STIGMA_SUBID'};
            if ( $curpl->{'rolesubid'} >= 0 ) {
                $mes =~ s/_ROLESUBID_/$stigma_subid->[$sow->{'curpl'}->{'rolesubid'}]/g;
            }
            else {
                $mes =~ s/_ROLESUBID_//g;
            }
        }
        &SWHtml::ConvertNET( $sow, \$mes );

        print <<"_HTML_";
$mes<br$net>

_HTML_
    }
    else {
        my $curpl    = $sow->{'curpl'};
        my $abi_role = $sow->{'textrs'}->{'ABI_ROLE'};
        if ( $abi_role->[ $curpl->{'role'} ] ne '' ) {
            my $enabled_abi = 1;
            $enabled_abi = 0
              if ( ( $curpl->{'role'} == $sow->{'ROLEID_GUARD'} )
                && ( $vil->{'turn'} == 1 ) );
            $enabled_abi = 0
              if ( ( $curpl->{'role'} == $sow->{'ROLEID_TRICKSTER'} )
                && ( $vil->{'turn'} > 1 ) );
            &OutHTMLVoteMb( $sow, $vil, 'skill' ) if ( $enabled_abi > 0 );
        }

        my $sayswitch = $sow->{'SAYSWITCH'}->[ $curpl->{'role'} ];
        if ( $sayswitch ne '' ) {

            # ����/����/�O�b
            my $reqvals = &SWBase::GetRequestValues($sow);
            my $hidden = &SWBase::GetHiddenValues( $sow, $reqvals, '' );

            my $unit =
              $sow->{'basictrs'}->{'SAYTEXT'}
              ->{ $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} }->{'COUNT_TYPE'} }->{'UNIT_SAY'};
            my $saycnt     = $cfg->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} };
            my $saycnttext = " ����$curpl->{$sow->{'SAYCOUNTID'}->[$curpl->{'role'}]}$unit";

            my $buttonlabel = $sow->{'textrs'}->{'BUTTONLABEL_MB'};
            my $caption_rolesay =
              $sow->{'textrs'}->{'CAPTION_ROLESAY'}->[ $curpl->{'role'} ];
            $buttonlabel =~ s/_BUTTON_/$caption_rolesay/g;

            my $mes = '';
            $mes = $query->{'mes'} if ( $query->{$sayswitch} ne '' );
            $mes =~ s/<br( \/)?>/\n/ig;
            print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
_HTML_

            # �\��I��
            &OutHTMLExpressionFormMb( $sow, $vil );

            print <<"_HTML_";
<textarea name="mes" rows="3" istyle="1">$mes</textarea><br$net>
<input type="hidden" name="$sayswitch" value="on"$net>
<input type="hidden" name="cmd" value="writepr"$net>$hidden
<input type="submit" value="$buttonlabel"$net>$saycnttext
_HTML_

            my $checked = '';
            $checked = " $sow->{'html'}->{'checked'}"
              if ( $query->{'monospace'} ne '' );
            print "<input type=\"checkbox\" name=\"monospace\" value=\"on\"$checked$net>����\n";

            print "</form>\n\n";
        }

        my $mes = $role->{'explain_role'}->[ $role->{'role'} ];
        if ( $curpl->{'role'} == $sow->{'ROLEID_STIGMA'} ) {

            # �����ҏ���
            my $stigma_subid = $sow->{'textrs'}->{'STIGMA_SUBID'};
            if ( $curpl->{'rolesubid'} >= 0 ) {
                $mes =~ s/_ROLESUBID_/$stigma_subid->[$sow->{'curpl'}->{'rolesubid'}]/g;
            }
            else {
                $mes =~ s/_ROLESUBID_//g;
            }
        }
        &SWHtml::ConvertNET( $sow, \$mes );

        print <<"_HTML_";
$mes<br$net>
<font color="red">$curpl->{'history'}</font>
_HTML_
    }

    return;
}

#----------------------------------------
# �A�N�V�����t�H�[���̏o��
#----------------------------------------
sub OutHTMLActionFormMb {
    my ( $sow, $vil ) = @_;
    my $cfg    = $sow->{'cfg'};
    my $query  = $sow->{'query'};
    my $net    = $sow->{'html'}->{'net'};
    my $option = $sow->{'html'}->{'option'};
    my $pllist = $vil->getpllist();
    my $curpl  = $sow->{'curpl'};
    my $saycnt = $cfg->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} };

    # �A�N�V����
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $hidden  = &SWBase::GetHiddenValues( $sow, $reqvals, '' );
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

    my $chrname = $curpl->getchrname();
    print <<"_HTML_";
<a name="action"><a href="$link">�߂�</a></a>/<a href="#say">����</a>/<a href="#role">�\\��</a><br$net>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
$chrname�́A
<select name="target">
<option value="-1">�i�I�����Ȃ��j$option
_HTML_

    foreach (@$pllist) {
        next if ( $_->{'uid'} eq $sow->{'uid'} );    # �������g�͏��O
        next
          if ( ( $_->{'live'} ne 'live' ) && ( $vil->isepilogue() == 0 ) );    # ���҂͏��O

        my $chrname = $_->getchrname();
        print "<option value=\"$_->{'pno'}\">$chrname$option\n";
    }

    print <<"_HTML_";
</select><br$net>

<select name="actionno">
_HTML_

    print "<option value=\"-3\">�����œ��͂��遫$option\n"
      if ( $vil->{'nofreeact'} == 0 );

    my $actions = $sow->{'textrs'}->{'ACTIONS'};
    my $i;
    for ( $i = 0 ; $i < @$actions ; $i++ ) {
        print "<option value=\"$i\">$actions->[$i]$option\n";
    }

    my $actions_bookmark = $sow->{'textrs'}->{'ACTIONS_BOOKMARK'};
    print "<option value=\"-2\">$actions_bookmark$option\n";

    if (   ( defined( $curpl->{'actaddpt'} ) )
        && ( $curpl->{'actaddpt'} > 0 )
        && ( $vil->{'nocandy'} == 0 ) )
    {
        my $restaddpt     = $sow->{'textrs'}->{'ACTIONS_RESTADDPT'};
        my $actions_addpt = $sow->{'textrs'}->{'ACTIONS_ADDPT'};
        $restaddpt =~ s/_POINT_/$curpl->{'actaddpt'}/g;
        $actions_addpt =~ s/_REST_/$restaddpt/g;
        print "<option value=\"-1\">$actions_addpt$option\n";
    }

    my $unitaction =
      $sow->{'basictrs'}->{'SAYTEXT'}->{ $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} }->{'COUNT_TYPE'} }
      ->{'UNIT_ACTION'};
    my $freeactform = '<input type="text" name="actiontext" value=""$net><br$net>';
    $freeactform = '' if ( $vil->{'nofreeact'} > 0 );
    print <<"_HTML_";
</select><br$net>
<input type="hidden" name="cmd" value="action"$net>$hidden
$freeactform
<input type="submit" value="�A�N�V����"$net> ����$curpl->{'say_act'}$unitaction
</form>
<hr$net>

_HTML_

    return;
}

#----------------------------------------
# �u���Ԃ�i�߂�v�{�^��HTML�o��
#----------------------------------------
sub OutHTMLCommitFormMb {
    my ( $sow, $vil ) = @_;
    my $cfg = $sow->{'cfg'};
    my $net = $sow->{'html'}->{'net'};

    my $reqvals = &SWBase::GetRequestValues($sow);
    my $hidden = &SWBase::GetHiddenValues( $sow, $reqvals, '' );

    my $nosay = '';
    if ( $sow->{'curpl'}->{'saidcount'} > 0 ) {
        print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
<select name="commit">
_HTML_

        my $selectstar_nocommit = ' *';
        my $selectstar_commit   = '';
        my $selected_nocommit   = " $sow->{'html'}->{'selected'}";
        my $selected_commit     = '';
        if ( $sow->{'curpl'}->{'commit'} > 0 ) {
            $selectstar_nocommit = '';
            $selectstar_commit   = ' *';
            $selected_nocommit   = '';
            $selected_commit     = " $sow->{'html'}->{'selected'}";
        }
        print <<"_HTML_";
    <option value="0"$selected_nocommit>���Ԃ�i�߂Ȃ�$selectstar_nocommit$sow->{'html'}->{'option'}
    <option value="1"$selected_commit>���Ԃ�i�߂�$selectstar_commit$sow->{'html'}->{'option'}
  </select>
  <input type="hidden" name="cmd" value="commit"$net>$hidden<br$net>
  <input type="submit" value="�ύX"$net>
</form>
_HTML_
    }
    else {
        $nosay = "<br$net><br$net>�Œ�ꔭ�����Ċm�肵�Ȃ��ƁA���Ԃ�i�߂鎖���ł��܂���B";
        print <<"_HTML_";
[���Ԃ�i�߂Ȃ� *]<br$net>
_HTML_
    }

    print <<"_HTML_";
�S�����u���Ԃ�i�߂�v��I�ԂƑO�|���ōX�V����܂��B$nosay
<hr$net>

_HTML_

    return;
}

#----------------------------------------
# �\��I��HTML�o��
#----------------------------------------
sub OutHTMLExpressionFormMb {
    my ( $sow, $vil ) = @_;
    my $net = $sow->{'html'}->{'net'};

    my $expression = $sow->{'charsets'}->{'csid'}->{ $sow->{'curpl'}->{'csid'} }->{'EXPRESSION'};
    if ( @$expression > 0 ) {
        print <<"_HTML_";
�\\��F<select name="expression">
_HTML_

        my $i;
        for ( $i = 0 ; $i < @$expression ; $i++ ) {
            my $selected = '';
            $selected = " $sow->{'html'}->{'selected'}" if ( $i == 0 );
            print "<option value=\"$i\"$selected>$expression->[$i]$sow->{'html'}->{'option'}\n";
        }
        print "</select><br$net>\n\n";
    }
}

#----------------------------------------
# �����o��{�^��HTML�o�́i�b��j
#----------------------------------------
sub OutHTMLExitVilButtonMb {
    my ( $sow, $vil ) = @_;
    my $cfg = $sow->{'cfg'};
    my $net = $sow->{'html'}->{'net'};

    my $reqvals = &SWBase::GetRequestValues($sow);
    my $hidden = &SWBase::GetHiddenValues( $sow, $reqvals, '' );
    if (   ( defined( $sow->{'curpl'} ) )
        && ( $sow->{'curpl'}->{'uid'} eq $cfg->{'USERID_NPC'} ) )
    {
        print <<"_HTML_";
[�����o��]<br$net>
�i�_�~�[�L�����͑����o���܂���j
<hr$net>
_HTML_

    }
    else {
        print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <input type="submit" value="�����o��"$net>
  <input type="hidden" name="cmd" value="exitpr"$net>$hidden
</form>
<hr$net>
_HTML_
    }

    return;
}

1;
