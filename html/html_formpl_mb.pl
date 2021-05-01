package SWHtmlPlayerFormMb;

#----------------------------------------
# プレイヤー発言／行動欄HTML出力
#----------------------------------------
sub OutHTMLPlayerFormMb {
    my ( $sow, $vil ) = @_;
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};
    my $curpl = $sow->{'curpl'};

    $sow->{'html'} = SWHtml->new($sow);    # HTMLモードの初期化
    my $outhttp = $sow->{'http'}->outheader();    # HTTPヘッダの出力
    return if ( $outhttp == 0 );                  # ヘッダ出力のみ
    $sow->{'html'}->outheader("$sow->{'query'}->{'vid'} $vil->{'vname'}");    # HTMLヘッダの出力

    my $net    = $sow->{'html'}->{'net'};                                     # Null End Tag
    my $option = $sow->{'html'}->{'option'};

    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

    print <<"_HTML_";
<a name="say">$sow->{'query'}->{'vid'} $vil->{'vname'}</a><br$net>
<a href="$link" accesskey="4">戻る</a>/<a href="#action" accesskey="6">ACT</a>/<a href="#role" accesskey="8">能\力</a><br$net>
<hr$net>
_HTML_

    # 発言欄HTML出力
    &OutHTMLSayMb( $sow, $vil );

    # 能力者欄HTML出力
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

    # 村建て人フォーム／管理人フォーム／傍観者フォーム表示
    if ( $vil->{'makeruid'} eq $sow->{'uid'} ) {
        &OutHTMLVilMakerMb( $sow, $vil, 'maker' )
          if ( ( $vil->{'turn'} == 0 )
            || ( $vil->isepilogue() != 0 )
            || ( $vil->{'makersaymenu'} == 0 ) );

        # 開始、編集とキックボタンは後回し。
        #&OutHTMLUpdateSessionButtonPC($sow, $vil) if ($vil->{'turn'} == 0);
        #&OutHTMLKickFormPC($sow, $vil) if ($vil->{'turn'} == 0);
    }
    if ( $sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'} ) {
        &OutHTMLVilMakerMb( $sow, $vil, 'admin' );

        # 開始、編集とキックボタンは後回し。
        #&OutHTMLUpdateSessionButtonPC($sow, $vil);
        #&OutHTMLKickFormPC($sow, $vil) if ($vil->{'turn'} == 0);
        #&OutHTMLScrapVilButtonPC($sow, $vil) if ($vil->{'turn'} < $vil->{'epilogue'});
    }
    if ( $vil->{'guestmenu'} == 0 ) {
        &OutHTMLGuestMb( $sow, $vil );
    }

    print <<"_HTML_";
<hr$net>
<a href="$link">戻る</a>/<a href="#say" accesskey="2">発言</a>/<a href="#action">ACT</a>
_HTML_

    $sow->{'html'}->outfooter();    # HTMLフッタの出力
    $sow->{'http'}->outfooter();

    return;
}

#----------------------------------------
# 村建て人発言欄出力
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

    print "<hr$net>■$chrname<br$net>\n";

    my $reqvals    = &SWBase::GetRequestValues($sow);
    my $hidden     = &SWBase::GetHiddenValues( $sow, $reqvals, '' );
    my $linkvalues = &SWBase::GetLinkValues( $sow, $reqvals );

    print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
_HTML_

    # テキストボックスと発言ボタン
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
# 投票／能力対象プルダウンリスト出力
#----------------------------------------
sub OutHTMLVoteMb {
    my ( $sow, $vil, $cmd ) = @_;
    my $cfg    = $sow->{'cfg'};
    my $query  = $sow->{'query'};
    my $net    = $sow->{'html'}->{'net'};
    my $curpl  = $sow->{'curpl'};
    my $option = $sow->{'html'}->{'option'};

    # 属性値の取得
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
        print "$votelabel：\n";
    }

    print <<"_HTML_";
<select name="target">
_HTML_

    # 対象の表示
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
        print " と、<br$net>\n";
        print <<"_HTML_";
<select name="target2">
_HTML_

        # 対象の表示
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
<input type="submit" value="変更\"><br$net>
</form>

_HTML_

    return;
}

#----------------------------------------
# 発言欄HTML出力
#----------------------------------------
sub OutHTMLSayMb {
    my ( $sow, $vil ) = @_;
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};
    my $net   = $sow->{'html'}->{'net'};

    my $curpl     = $sow->{'curpl'};
    my $chrname   = $curpl->getchrname();
    my $markbonds = '';
    $markbonds = " ★$sow->{'textrs'}->{'MARK_BONDS'}"
      if ( $curpl->{'bonds'} ne '' );
    print "■$chrname$markbonds<br$net>\n";

    my $reqvals    = &SWBase::GetRequestValues($sow);
    my $hidden     = &SWBase::GetHiddenValues( $sow, $reqvals, '' );
    my $linkvalues = &SWBase::GetLinkValues( $sow, $reqvals );

    # 投票先変更プルダウン
    if (   ( $curpl->{'live'} eq 'live' )
        && ( $vil->{'turn'} > 1 )
        && ( $vil->isepilogue() == 0 ) )
    {
        &OutHTMLVoteMb( $sow, $vil, 'vote' );
    }

    print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
_HTML_

    # 表情選択欄
    &OutHTMLExpressionFormMb( $sow, $vil );

    # テキストボックスと発言ボタン
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

    # 独り言チェックボックス
    if (   ( $curpl->{'live'} eq 'live' )
        || ( $cfg->{'ENABLED_TSAY_GRAVE'} > 0 ) )
    {    # 生きている／墓下独り言有効
        if ( ( $vil->isepilogue() == 0 ) || ( $cfg->{'ENABLED_TSAY_EP'} > 0 ) )
        {    # エピではない／エピ独り言有効
            if ( ( $vil->{'turn'} != 0 ) || ( $cfg->{'ENABLED_TSAY_PRO'} > 0 ) ) {
                my $unit =
                  $sow->{'basictrs'}->{'SAYTEXT'}
                  ->{ $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} }->{'COUNT_TYPE'} }->{'UNIT_SAY'};
                my $checked = '';
                $checked = " $sow->{'html'}->{'checked'}"
                  if ( ( $query->{'think'} ne '' )
                    && ( $query->{'guest'} eq '' ) );
                print
"<input type=\"checkbox\" name=\"think\" value=\"on\"$checked$net>$sow->{'textrs'}->{'CAPTION_TSAY_MB'} あと$curpl->{'tsay'}$unit\n";
            }
        }
    }

    my $checked = '';
    $checked = " $sow->{'html'}->{'checked'}"
      if ( ( $query->{'monospace'} ne '' ) && ( $query->{'guest'} eq '' ) );
    print "<input type=\"checkbox\" name=\"monospace\" value=\"on\"$checked$net>等幅\n";
    my $checked = '';
    $checked = " $sow->{'html'}->{'checked'}"
      if ( ( $query->{'loud'} ne '' ) && ( $query->{'guest'} eq '' ) );
    print "<input type=\"checkbox\" name=\"loud\" value=\"on\"$checked$net>大声\n";

    print <<"_HTML_";
</form>
<hr$net>

_HTML_

    # コミットボタン
    &OutHTMLCommitFormMb( $sow, $vil )
      if ( ( $vil->{'turn'} > 0 )
        && ( $vil->isepilogue() == 0 )
        && ( $sow->{'curpl'}->{'live'} eq 'live' ) );

    # 村を出る（暫定）
    OutHTMLExitVilButtonMb( $sow, $vil ) if ( $vil->{'turn'} == 0 );

    # アクション
    &OutHTMLActionFormMb( $sow, $vil )
      if ( ( ( $curpl->{'live'} eq 'live' ) || ( $vil->isepilogue() != 0 ) )
        && ( ( $vil->{'noactmode'} == 0 ) || ( $vil->{'noactmode'} == 2 ) ) );

    return;
}

#----------------------------------------
# 傍観者発言欄HTML出力
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

    print "■$chrname<br$net>\n";

    my $reqvals    = &SWBase::GetRequestValues($sow);
    my $hidden     = &SWBase::GetHiddenValues( $sow, $reqvals, '' );
    my $linkvalues = &SWBase::GetLinkValues( $sow, $reqvals );

    print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
_HTML_

    # テキストボックスと発言ボタン
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

    # 独り言チェックボックス
    if ( ( $vil->isepilogue() == 0 ) || ( $cfg->{'ENABLED_TSAY_EP'} > 0 ) )
    {    # エピではない／エピ独り言有効
        my $checked = '';
        $checked = " $sow->{'html'}->{'checked'}"
          if ( ( $query->{'think'} ne '' ) && ( $query->{'guest'} ne '' ) );
        print
          "<input type=\"checkbox\" name=\"think\" value=\"on\"$checked$net>$sow->{'textrs'}->{'CAPTION_TSAY_MB'}\n";
    }

    my $checked = '';
    $checked = " $sow->{'html'}->{'checked'}"
      if ( ( $query->{'monospace'} ne '' ) && ( $query->{'guest'} ne '' ) );
    print "<input type=\"checkbox\" name=\"monospace\" value=\"on\"$checked$net>等幅\n";
    my $checked = '';
    $checked = " $sow->{'html'}->{'checked'}"
      if ( ( $query->{'loud'} ne '' ) && ( $query->{'guest'} ne '' ) );
    print "<input type=\"checkbox\" name=\"loud\" value=\"on\"$checked$net>大声\n";

    # 傍観者発言にもパスワードが必要にする
    if ( $vil->{'entrylimit'} eq 'password' ) {
        my $writepwd = '';
        $writepwd = $query->{'writepwd'} if ( $query->{'writepwd'} ne '' );
        print <<"_HTML_";
<br$net>
パスワード<br$net>
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
# 能力者欄HTML出力
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
<a name="role"><a href="$link">戻る</a></a>/<a href="#say">発言</a>/<a href="#action">ACT</a><br$net>
_HTML_

    if ( $vil->{'turn'} == 0 ) {
        print <<"_HTML_";
$role->{'explain'}<br$net>

_HTML_
    }
    elsif (( $vil->isepilogue() != 0 )
        || ( $sow->{'curpl'}->{'live'} ne 'live' ) )
    {
        # 能力欄表示（墓下／エピローグ）
        my $mes = $role->{'explain'};
        if ( $curpl->{'role'} == $sow->{'ROLEID_STIGMA'} ) {

            # 聖痕者処理
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

            # 囁き/共鳴/念話
            my $reqvals = &SWBase::GetRequestValues($sow);
            my $hidden = &SWBase::GetHiddenValues( $sow, $reqvals, '' );

            my $unit =
              $sow->{'basictrs'}->{'SAYTEXT'}
              ->{ $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} }->{'COUNT_TYPE'} }->{'UNIT_SAY'};
            my $saycnt     = $cfg->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} };
            my $saycnttext = " あと$curpl->{$sow->{'SAYCOUNTID'}->[$curpl->{'role'}]}$unit";

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

            # 表情選択欄
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
            print "<input type=\"checkbox\" name=\"monospace\" value=\"on\"$checked$net>等幅\n";

            print "</form>\n\n";
        }

        my $mes = $role->{'explain_role'}->[ $role->{'role'} ];
        if ( $curpl->{'role'} == $sow->{'ROLEID_STIGMA'} ) {

            # 聖痕者処理
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
# アクションフォームの出力
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

    # アクション
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $hidden  = &SWBase::GetHiddenValues( $sow, $reqvals, '' );
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

    my $chrname = $curpl->getchrname();
    print <<"_HTML_";
<a name="action"><a href="$link">戻る</a></a>/<a href="#say">発言</a>/<a href="#role">能\力</a><br$net>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
$chrnameは、
<select name="target">
<option value="-1">（選択しない）$option
_HTML_

    foreach (@$pllist) {
        next if ( $_->{'uid'} eq $sow->{'uid'} );    # 自分自身は除外
        next
          if ( ( $_->{'live'} ne 'live' ) && ( $vil->isepilogue() == 0 ) );    # 死者は除外

        my $chrname = $_->getchrname();
        print "<option value=\"$_->{'pno'}\">$chrname$option\n";
    }

    print <<"_HTML_";
</select><br$net>

<select name="actionno">
_HTML_

    print "<option value=\"-3\">自分で入力する↓$option\n"
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
<input type="submit" value="アクション"$net> あと$curpl->{'say_act'}$unitaction
</form>
<hr$net>

_HTML_

    return;
}

#----------------------------------------
# 「時間を進める」ボタンHTML出力
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
    <option value="0"$selected_nocommit>時間を進めない$selectstar_nocommit$sow->{'html'}->{'option'}
    <option value="1"$selected_commit>時間を進める$selectstar_commit$sow->{'html'}->{'option'}
  </select>
  <input type="hidden" name="cmd" value="commit"$net>$hidden<br$net>
  <input type="submit" value="変更"$net>
</form>
_HTML_
    }
    else {
        $nosay = "<br$net><br$net>最低一発言して確定しないと、時間を進める事ができません。";
        print <<"_HTML_";
[時間を進めない *]<br$net>
_HTML_
    }

    print <<"_HTML_";
全員が「時間を進める」を選ぶと前倒しで更新されます。$nosay
<hr$net>

_HTML_

    return;
}

#----------------------------------------
# 表情選択欄HTML出力
#----------------------------------------
sub OutHTMLExpressionFormMb {
    my ( $sow, $vil ) = @_;
    my $net = $sow->{'html'}->{'net'};

    my $expression = $sow->{'charsets'}->{'csid'}->{ $sow->{'curpl'}->{'csid'} }->{'EXPRESSION'};
    if ( @$expression > 0 ) {
        print <<"_HTML_";
表\情：<select name="expression">
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
# 村を出るボタンHTML出力（暫定）
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
[村を出る]<br$net>
（ダミーキャラは村を出られません）
<hr$net>
_HTML_

    }
    else {
        print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <input type="submit" value="村を出る"$net>
  <input type="hidden" name="cmd" value="exitpr"$net>$hidden
</form>
<hr$net>
_HTML_
    }

    return;
}

1;
