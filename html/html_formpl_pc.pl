package SWHtmlPlayerFormPC;

#----------------------------------------
# プレイヤー発言／行動欄HTML出力
#----------------------------------------
sub OutHTMLPlayerFormPC {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};
	my $curpl = $sow->{'curpl'};

	print "<div class=\"formpl_frame\">\n";

	if ((($curpl->iswhisper() == 0) || ($query->{'mode'} ne 'whisper')) || ($vil->isepilogue() != 0)) {
		# 発言欄HTML出力
		&OutHTMLSayPC($sow, $vil, \%htmlsay);

		# コミットボタン
		&OutHTMLCommitFormPC($sow, $vil) if (($vil->{'turn'} > 0) && ($vil->isepilogue() == 0) && ($sow->{'curpl'}->{'live'} eq 'live'));
	}

	# 能力者欄HTML出力
	my %role;
	if ($curpl->{'role'} < 0) {
		$role{'role'} = $curpl->{'selrole'};
	} else {
		$role{'role'} = $curpl->{'role'};
	}
	my $textrs = $sow->{'textrs'};
	if ($curpl->{'role'} < 0) {
		$role{'explain'} = $textrs->{'EXPLAIN_ROLES'}->{'prologue'};
		if ($vil->{'noselrole'} > 0) {
			$role{'explain'} = $textrs->{'EXPLAIN_ROLES'}->{'noselrole'};
		}
	} elsif ($vil->isepilogue() != 0) {
		$role{'explain'} = $textrs->{'EXPLAIN_ROLES'}->{'epilogue'};
	} else {
		$role{'explain'} = $textrs->{'EXPLAIN_ROLES'}->{'dead'};
	}
	my $selrolename = $textrs->{'ROLENAME'}->[$curpl->{'selrole'}];
	$selrolename = $textrs->{'RANDOMROLE'} if ($curpl->{'selrole'} < 0);
	$role{'explain'} =~ s/_SELROLE_/$selrolename/;
	$role{'explain'} =~ s/_ROLE_/$textrs->{'ROLENAME'}->[$curpl->{'role'}]/;
	$role{'explain_role'} = $textrs->{'EXPLAIN_ROLES'}->{'explain'};

	&OutHTMLRolePC($sow, $vil, \%role) if (($curpl->iswhisper() == 0) || ($query->{'mode'} ne 'human'));
	&OutHTMLRoleFormPC($sow, $vil) if ($curpl->iswhisper() > 0 && $vil->{'emulated'} < 1);
	&OutHTMLExitButtonPC($sow, $vil) if ($vil->{'turn'} == 0);
	&OutHTMLSelRoleButtonPC($sow, $vil) if ($vil->{'turn'} == 0);

	# 村建て人フォーム／管理人フォーム／傍観者フォーム表示
	if ($sow->{'user'}->logined() > 0) {
		if ($sow->{'uid'} eq $vil->{'makeruid'}) {
			&OutHTMLVilMakerPC($sow, $vil, 'maker') if (($vil->{'turn'} == 0) || ($vil->isepilogue() != 0) || ($vil->{'makersaymenu'} == 0));
			&OutHTMLUpdateSessionButtonPC($sow, $vil) if ($vil->{'turn'} == 0);
			&OutHTMLKickFormPC($sow, $vil) if ($vil->{'turn'} == 0);
		}
		if ($sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'}) {
			&OutHTMLVilMakerPC($sow, $vil, 'admin');
			&OutHTMLUpdateSessionButtonPC($sow, $vil);
			&OutHTMLKickFormPC($sow, $vil) if ($vil->{'turn'} == 0);
			&OutHTMLScrapVilButtonPC($sow, $vil) if ($vil->{'turn'} < $vil->{'epilogue'});
		}
    &OutHTMLVilGuestPC($sow, $vil, 'guest') if (($vil->{'turn'} == 0) || ($vil->isepilogue() != 0));
	}

	print "</div>\n\n";

	return;
}

#----------------------------------------
# 囁きフォーム変更HTML出力
#----------------------------------------
sub OutHTMLRoleFormPC {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};

	return if ($vil->isepilogue() > 0);

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'mode'} = 'human';
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">（村視点）</a> ";
	$reqvals->{'mode'} = 'whisper';
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">（囁きのみ）</a> ";
	$reqvals->{'mode'} = '';
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	print "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">（解除）</a> ";
}

#----------------------------------------
# 発言欄HTML出力
#----------------------------------------
sub OutHTMLSayPC {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $curpl = $sow->{'curpl'};
	my $charset = $sow->{'charsets'}->{'csid'}->{$curpl->{'csid'}};

	# キャラ画像アドレスの取得
	my $img = &SWHtmlPC::GetImgUrl($sow, $curpl, $charset->{'BODY'});

	# キャラ画像部とその他部の横幅を取得
	my ($lwidth, $rwidth) = &SWHtmlPC::GetFormBlockWidth($sow, $charset->{'IMGBODYW'});

	my $rolename = '';
	$rolename = " [$sow->{'textrs'}->{'ROLENAME'}->[$sow->{'curpl'}->{'role'}]]" if ($sow->{'curpl'}->{'role'} > 0);

	my $markbonds = '';
	$markbonds = " ★$sow->{'textrs'}->{'MARK_BONDS'}" if ($curpl->{'bonds'} ne '');

	# キャラ画像
	print <<"_HTML_";
<div class="formpl_common">
  <div style="float: left; width: $lwidth;">
    <div class="formpl_chrimg"><img src="$img" width="$charset->{'IMGBODYW'}" height="$charset->{'IMGBODYH'}" alt=""$net></div>
  </div>

_HTML_

	# 名前とID
	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'prof'} = $sow->{'uid'};
	my $link = &SWBase::GetLinkValues($sow, $reqvals);
	my $uidtext = $sow->{'uid'};
	$uidtext =~ s/ /&nbsp\;/g;
	$uidtext = "<a href=\"$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link\">$uidtext</a>";

	my $chrname = $curpl->getchrname();

	my $checkedmspace = '';
	$checkedmspace = " $sow->{'html'}->{'checked'}" if (($draft > 0) && ($sow->{'draftmspace'} > 0));

	my $checkedloud = '';
	$checkedloud = " $sow->{'html'}->{'checked'}" if (($draft > 0) && ($sow->{'draftloud'} > 0));

	my $countname = "point";
	my $countstr = "pt消費";
	if ($cfg->{'COUNTS_SAY'}->{$vil->{'saycnttype'}}->{'COUNT_TYPE'} eq 'count') {
	  $countstr = "文字";
	  $countname = "count";
	}
	print <<"_HTML_";
  <div style="float: right; width: $rwidth;">
    <div class="formpl_content">
        $chrname ($uidtext)$rolename$markbonds
		<label><input type=\"checkbox\" name=\"monospace\" value=\"on\"$checkedmspace$net>等幅</label>
		<label><input type=\"checkbox\" name=\"loud\" value=\"on\"$checkedloud$net>大声</label>
        <div style="float: right;">
            <span name="$countname">0</span>$countstr
        </div>
    </div>

_HTML_

	# 投票先変更プルダウン
	if (($curpl->{'live'} eq 'live') && ($vil->{'turn'} > 1) && ($vil->isepilogue() == 0)) {
		&OutHTMLVotePC($sow, $vil, 'vote');
	}

	# テキストボックスと発言ボタン初め
	print <<"_HTML_";
    <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
_HTML_

	# 表情選択欄
	&OutHTMLExpressionFormPC($sow, $vil);

	print "    <div class=\"formpl_content\">\n";

	# 発言欄textarea要素の出力
	my %htmlsay;
	$htmlsay{'saycnttext'} = &SWBase::GetSayCountText($sow, $vil);
	my $caption_say = $sow->{'textrs'}->{'CAPTION_SAY_PC'};
	$caption_say = $sow->{'textrs'}->{'CAPTION_GSAY_PC'} if (($curpl->{'live'} ne 'live') && ($vil->isepilogue() == 0));
	$htmlsay{'buttonlabel'} = $sow->{'textrs'}->{'BUTTONLABEL_PC'};
	$htmlsay{'buttonlabel'} =~ s/_BUTTON_/$caption_say/g;
	$htmlsay{'disabled'} = 0;
	$htmlsay{'disabled'} = 1 if ($vil->{'emulated'} > 0);
	my $draft = 0;
	$draft = 1 if (($sow->{'savedraft'} ne '') && (($sow->{'draftmestype'} == $sow->{'MESTYPE_SAY'}) || ($sow->{'draftmestype'} == $sow->{'MESTYPE_TSAY'})));
	if (($query->{'mes'} ne '') && (($query->{'cmdfrom'} eq 'write') || ($query->{'cmdfrom'} eq 'writepr'))) {
		my $mes = $query->{'mes'};
		$mes =~ s/<br( \/)?>/\n/ig;
		$htmlsay{'text'} = $mes;
	} elsif ($draft > 0) {
		my $mes = $sow->{'savedraft'};
		$mes =~ s/<br( \/)?>/\n/ig;
		$htmlsay{'text'} = $mes;
	}

	&SWHtmlPC::OutHTMLSayTextAreaPC($sow, 'writepr', \%htmlsay);

	# 独り言チェックボックス
	my $saycnt = $cfg->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	if (($curpl->{'live'} eq 'live') || ($cfg->{'ENABLED_TSAY_GRAVE'} > 0)) { # 生きている／墓下独り言有効
		if (($vil->isepilogue() == 0) || ($cfg->{'ENABLED_TSAY_EP'} > 0)) { # エピではない／エピ独り言有効
			if (($vil->{'turn'} != 0) || ($cfg->{'ENABLED_TSAY_PRO'} > 0)) { # プロローグ独り言設定チェック
				my $unit = $sow->{'basictrs'}->{'SAYTEXT'}->{$sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}}->{'COUNT_TYPE'}}->{'UNIT_SAY'};
				my $checked = '';
				$checked = " $sow->{'html'}->{'checked'}" if (($draft > 0) && ($sow->{'draftmestype'} == $sow->{'MESTYPE_TSAY'}));
				print "<div style=\"float: right\">\n";
				print "　<input type=\"submit\" name=\"submit_type\" value=\"$sow->{'textrs'}->{'CAPTION_TSAY_PC'}\"$disabled$net> あと$curpl->{'tsay'}$unit\n";
				print "</div>\n";
			}
		}
	}

	print "<div class=\"clearboth\"><hr class=\"invisible_hr\"></div> ";
	print <<"_HTML_";
    </div>
    </form>

_HTML_

	# アクション
	&OutHTMLActionFormPC($sow, $vil) if ((($curpl->{'live'} eq 'live') || ($vil->isepilogue() != 0)) && (($vil->{'noactmode'} == 0) || ($vil->{'noactmode'} == 2)));

	print <<"_HTML_";
  </div>
  <div class="clearboth">
    <hr class="invisible_hr"$net>
  </div>
</div>

_HTML_

	return;
}

#----------------------------------------
# アクションフォームの出力
#----------------------------------------
sub OutHTMLActionFormPC {
	my ($sow, $vil) = @_;
	my $cfg   = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net   = $sow->{'html'}->{'net'};

	my $curpl = $sow->{'curpl'};
	my $charset = $sow->{'charsets'}->{'csid'}->{$curpl->{'csid'}};
	my $saycnt = $cfg->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
	my $pllist = $vil->getpllist();

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '      ');

	my $chrname = $curpl->getchrname();
	print <<"_HTML_";
    <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
    <div class="formpl_action">
      $chrnameは、
      <select name="target">
        <option value="-1">（選択しない）$sow->{'html'}->{'option'}
_HTML_

	# アクションの対象者
	foreach (@$pllist) {
		next if ($_->{'uid'} eq $sow->{'uid'}); # 自分自身は除外
		next if (($_->{'live'} ne 'live') && ($vil->isepilogue() == 0)); # 死者は除外

		my $targetname = $_->getchrname();
		print "        <option value=\"$_->{'pno'}\">$targetname$sow->{'html'}->{'option'}\n";
	}

	print <<"_HTML_";
      </select><br$net>

      <fieldset class="action_type">
      <legend>アクション内容</legend>
      <input type="radio" name="selectact" value="template" $sow->{'html'}->{'checked'}$net>
      <select name="actionno">
_HTML_

	# 組み込み済みアクション
	my $actions = $sow->{'textrs'}->{'ACTIONS'};
	my $i;
	for ($i = 0; $i < @$actions; $i++) {
		print "        <option value=\"$i\">$actions->[$i]$sow->{'html'}->{'option'}\n";
	}

	# しおり
	my $actions_bookmark = $sow->{'textrs'}->{'ACTIONS_BOOKMARK'};
	print "        <option value=\"-2\">$actions_bookmark$sow->{'html'}->{'option'}\n";

	# 促し
	if ((defined($curpl->{'actaddpt'})) && ($curpl->{'actaddpt'} > 0) && ($vil->{'nocandy'} == 0)) {
		my $restaddpt = $sow->{'textrs'}->{'ACTIONS_RESTADDPT'};
		my $actions_addpt = $sow->{'textrs'}->{'ACTIONS_ADDPT'};
		$restaddpt =~ s/_POINT_/$curpl->{'actaddpt'}/g;
		$actions_addpt =~ s/_REST_/$restaddpt/g;
		print "        <option value=\"-1\">$actions_addpt$sow->{'html'}->{'option'}\n";
	}

	# アクション入力欄とアクションボタン
	my $unitaction = $sow->{'basictrs'}->{'SAYTEXT'}->{$sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}}->{'COUNT_TYPE'}}->{'UNIT_ACTION'};
	my $actdisabled = '';
	$actdisabled = " $sow->{'html'}->{'disabled'}" if ($vil->{'emulated'} > 0);
	my $freeactform = '
      <input type="radio" name="selectact" value="freetext"$net>
      <input class="formpl_actiontext" type="text" name="actiontext" value="" size="30"$net><br$net>';
    $freeactform = '' if ($vil->{'nofreeact'} > 0);


	print <<"_HTML_";
      </select><br$net>
      <input type="hidden" name="cmd" value="action"$net>$hidden
      $freeactform
      </fieldset>
      <input type="submit" value="アクション"$actdisabled$net> あと$curpl->{'say_act'}$unitaction
    </div>
    </form>

_HTML_

	return;
}

#----------------------------------------
# 能力者欄HTML出力
#----------------------------------------
sub OutHTMLRolePC {
	my ($sow, $vil, $role) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};
	my $curpl = $sow->{'curpl'};

	# 能力者欄のスタイルシートのクラス名
	my @rolestyles = ('random', 'undef', 'vil', 'wolf', 'seer', 'medium', 'possess', 'guard', 'fm', 'hamster', 'cpossess', 'stigma', 'fanatic', 'sympathy', 'werebat', 'cwolf', 'intwolf', 'trickster');
	$rolestyle = "formpl_$rolestyles[$role->{'role'} + 1]";

	if ($vil->{'turn'} == 0) {
		# 能力希望表示
		&SWHtml::ConvertNET($sow, \$role->{'explain'});
		print <<"_HTML_";
<div class="$rolestyle">
$role->{'explain'}
</div>

_HTML_
	} elsif (($vil->isepilogue() != 0) || ($curpl->{'live'} ne 'live')) {
		# 能力欄表示（墓下／エピローグ）
		my $mes = $role->{'explain'};
		if ($curpl->{'role'} == $sow->{'ROLEID_STIGMA'}) {
			# 聖痕者処理
			my $stigma_subid = $sow->{'textrs'}->{'STIGMA_SUBID'};
			if ($curpl->{'rolesubid'} >= 0) {
				$mes =~ s/_ROLESUBID_/$stigma_subid->[$sow->{'curpl'}->{'rolesubid'}]/g;
			} else {
				$mes =~ s/_ROLESUBID_//g;
			}
		}
		&SWHtml::ConvertNET($sow, \$mes);

		print <<"_HTML_";
<div class="$rolestyle">
$mes
</div>

_HTML_
	} else {
		# 能力欄表示
		my $charset = $sow->{'charsets'}->{'csid'}->{$curpl->{'csid'}};

		# キャラ画像アドレスの取得
		my $img = &SWHtmlPC::GetImgUrl($sow, $curpl, $charset->{'BODY'});
		if ($curpl->iswhisper > 0) {
			$img = &SWHtmlPC::GetImgUrl($sow, $curpl, $charset->{'BODY'}, 0, $sow->{'MESTYPE_WSAY'});
		}

		# キャラ画像部とその他部の横幅を取得
		my ($rwidth, $lwidth) = &SWHtmlPC::GetFormBlockWidth($sow, $charset->{'IMGBODYW'});

		print <<"_HTML_";
<div class="$rolestyle">
  <div style="float: right; width: $rwidth;">
    <div class="formpl_chrimg"><img src="$img" width="$charset->{'IMGBODYW'}" height="$charset->{'IMGBODYH'}" alt=""$net></div>
  </div>

  <div style="float: left; width: $lwidth;">
_HTML_

		# 能力対象先変更プルダウン
		my $abi_role = $sow->{'textrs'}->{'ABI_ROLE'};
		if ($abi_role->[$curpl->{'role'}] ne '') {
			my $enabled_abi = 1;
			$enabled_abi = 0 if (($curpl->{'role'} == $sow->{'ROLEID_GUARD'}) && ($vil->{'turn'} == 1));
			$enabled_abi = 0 if (($curpl->{'role'} == $sow->{'ROLEID_TRICKSTER'}) && ($vil->{'turn'} > 1));
			&OutHTMLVotePC($sow, $vil, 'skill') if ($enabled_abi > 0);
		}

		# 囁き/共鳴/念話
		my $sayswitch = $sow->{'SAYSWITCH'}->[$curpl->{'role'}];
		if ($sayswitch ne '') {
			print <<"_HTML_";
    <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
_HTML_

			# 表情選択欄
			&OutHTMLExpressionFormPC($sow, $vil);

			print <<"_HTML_";
    <div class="formpl_content">
_HTML_

			# 発言欄textarea要素の出力
			my $saycnt = $cfg->{'COUNTS_SAY'}->{$vil->{'saycnttype'}};
			my $unit = $sow->{'basictrs'}->{'SAYTEXT'}->{$sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}}->{'COUNT_TYPE'}}->{'UNIT_SAY'};
			my %htmlsay;
			$htmlsay{'buttonlabel'} = $sow->{'textrs'}->{'BUTTONLABEL_PC'};
			my $caption_rolesay = $sow->{'textrs'}->{'CAPTION_ROLESAY'}->[$curpl->{'role'}];
			$htmlsay{'buttonlabel'} =~ s/_BUTTON_/$caption_rolesay/g;
			$htmlsay{'saycnttext'} = " あと$curpl->{$sow->{'SAYCOUNTID'}->[$curpl->{'role'}]}$unit";
			$htmlsay{'disabled'} = 0;
			$htmlsay{'disabled'} = 1 if ($vil->{'emulated'} > 0);

			my $draft = 0;
			$draft = 1 if (($sow->{'savedraft'} ne '') && (($sow->{'draftmestype'} == $sow->{'MESTYPE_WSAY'}) || ($sow->{'draftmestype'} == $sow->{'MESTYPE_SPSAY'}) || ($sow->{'draftmestype'} == $sow->{'MESTYPE_BSAY'})));
			if ($draft > 0) {
				my $mes = $sow->{'savedraft'};
				$mes =~ s/<br( \/)?>/\n/ig;
				$htmlsay{'text'} = $mes;
			}
			&SWHtmlPC::OutHTMLSayTextAreaPC($sow, 'writepr', \%htmlsay);
			my $checkedmspace = '';
			$checkedmspace = " $sow->{'html'}->{'checked'}" if (($draft > 0) && ($sow->{'draftmspace'} > 0));
			print "      <label><input type=\"checkbox\" name=\"monospace\" value=\"on\"$checkedmspace$net>等幅</label>\n";
			my $checkedloud = '';
			$checkedloud = " $sow->{'html'}->{'checked'}" if (($draft > 0) && ($sow->{'draftloud'} > 0));
			print "      <label><input type=\"checkbox\" name=\"loud\" value=\"on\"$checkedloud$net>大声</label>\n";

			print <<"_HTML_";
      <input type="hidden" name="$sayswitch" value="on"$net>
    </div>
    </form>
_HTML_
		}

		# 囁き等の場合は能力者説明の前で画像回り込みを禁止
		if ($sayswitch ne '') {
			print "  </div>\n\n";
			print "  <div class=\"clearboth\">\n";
		}

		# 能力者説明の表示
		my $mes = $role->{'explain_role'}->[$role->{'role'}];
		if ($curpl->{'role'} == $sow->{'ROLEID_STIGMA'}) {
			# 聖痕者処理
			my $stigma_subid = $sow->{'textrs'}->{'STIGMA_SUBID'};
			if ($curpl->{'rolesubid'} >= 0) {
				$mes =~ s/_ROLESUBID_/$stigma_subid->[$sow->{'curpl'}->{'rolesubid'}]/g;
			} else {
				$mes =~ s/_ROLESUBID_//g;
			}
		}
		&SWHtml::ConvertNET($sow, \$mes);

		print <<"_HTML_";
    <div class="formpl_content">$mes</div>
_HTML_

		# 能力結果履歴
		my $history = $curpl->{'history'};
		&SWHtml::ConvertNET($sow, \$history);
		print "    <div class=\"formpl_content\"><p><strong>$history</strong></p></div>\n" if ($history ne '');

		# 運命の絆
		if ($curpl->{'bonds'} ne '') {
			print <<"_HTML_";
    <div class="formpl_content">
      <p>
_HTML_

			my @bonds = split('/', $curpl->{'bonds'} . '/');
			foreach(@bonds) {
				my $targetname = $vil->getplbypno($_)->getchrname();
				my $resultbonds = $sow->{'textrs'}->{'RESULT_BONDS'};
				$resultbonds =~ s/_TARGET_/$targetname/g;
				print "        <strong>$resultbonds</strong><br$net>\n";
			}

			print <<"_HTML_";
      </p>
    </div>
_HTML_
		}

		# 画像回り込みの禁止
		if ($sayswitch eq '') {
		print <<"_HTML_";
  </div>

  <div class="clearboth">
_HTML_
		}

		print <<"_HTML_";
    <hr class="invisible_hr"$net>
  </div>
</div>
_HTML_
	}

	return;
}

#----------------------------------------
# 村開始／更新ボタンHTML出力
#----------------------------------------
sub OutHTMLUpdateSessionButtonPC {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my %button;
	if ($vil->{'turn'} == 0) {
		%button = (
			label => '村開始',
			cmd   => 'startpr',
		);
	} else {
		%button = (
			label => '更新',
			cmd   => 'updatepr',
		);
	}

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');

	print <<"_HTML_";
<div class="formpl_gm">
_HTML_

	if ($button{'cmd'} eq 'startpr') {
		print <<"_HTML_";
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <p class="commitbutton">
    <input type="hidden" name="cmd" value="editvilform"$net>$hidden
    <input type="submit" value="村の編集"$net>
  </p>
  </form>
_HTML_
	}

	print <<"_HTML_";
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <p class="commitbutton">
    <input type="hidden" name="cmd" value="$button{'cmd'}"$net>$hidden
    <input type="submit" value="$button{'label'}"$net>
  </p>
  </form>
</div>

_HTML_

	return;
}

#----------------------------------------
# 廃村ボタンHTML出力
#----------------------------------------
sub OutHTMLScrapVilButtonPC {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');

	print <<"_HTML_";
<div class="formpl_gm">
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <p class="commitbutton">
    <input type="hidden" name="cmd" value="scrapvilpr"$net>$hidden
    <input type="submit" value="廃村する"$net>
  </p>
  </form>
</div>

_HTML_

	return;
}

#----------------------------------------
# 「時間を進める」ボタンHTML出力
#----------------------------------------
sub OutHTMLCommitFormPC {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');

	my $disabled = '';
	my $nosay = '';
	if ($sow->{'curpl'}->{'saidcount'} == 0) {
		$disabled = " $sow->{'html'}->{'disabled'}";
		$nosay = "<br$net><br$net>最低一発言して確定しないと、時間を進める事ができません。";
	}

	print <<"_HTML_";
<div class="formpl_gm">
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <div class="formpl_content">
  <select name="commit"$disabled>
_HTML_

	my $star = ' *';
	my $option = $sow->{'html'}->{'option'};
	if ($sow->{'curpl'}->{'commit'} > 0) {
		print <<"_HTML_";
    <option value="0">時間を進めない$option
    <option value="1" $sow->{'html'}->{'selected'}>時間を進める$star$option
_HTML_
	} else {
		print <<"_HTML_";
    <option value="0" $sow->{'html'}->{'selected'}>時間を進めない$star$option
    <option value="1">時間を進める$option
_HTML_
	}

	print <<"_HTML_";
  </select>
  <input type="hidden" name="cmd" value="commit"$net>$hidden
  <input type="submit" value="変更"$disabled$net>
  </div>
  </form>

  <p class="formpl_content">全員が「時間を進める」を選ぶと前倒しで更新されます。$nosay</p>
</div>

_HTML_

	return;
}

#----------------------------------------
# 「村を出る」HTML出力
#----------------------------------------
sub OutHTMLExitButtonPC {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');
	my $disabled = '';
	$disabled = " $sow->{'html'}->{'disabled'}" if ($sow->{'uid'} eq $cfg->{'USERID_NPC'});

	print <<"_HTML_";
<div class="formpl_gm">
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <p class="commitbutton">
    <input type="hidden" name="cmd" value="exitpr"$net>$hidden
    <input type="submit" value="村を出る"$disabled$net>
  </p>
  </form>
</div>

_HTML_

	return;
}

#----------------------------------------
# 「希望役職変更」HTML出力
#----------------------------------------
sub OutHTMLSelRoleButtonPC {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '    ');
	my $disabled = '';
	$disabled = " $sow->{'html'}->{'disabled'}" if ($sow->{'uid'} eq $cfg->{'USERID_NPC'});

	print <<"_HTML_";
<div class="formpl_gm">
  <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
	<p class="commitbutton">
      <label for="selectrole">希望する能\力：</label>
      <select id="selectrole" name="role">
        <option value="-1">$sow->{'textrs'}->{'RANDOMROLE'}$sow->{'html'}->{'option'}
_HTML_

	# 希望する能力の表示
	my $rolename = $sow->{'textrs'}->{'ROLENAME'};
	require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
	my $rolematrix = &SWSetRole::GetSetRoleTable($sow, $vil, $vil->{'roletable'}, $vil->{'vplcnt'});

	my $i;
	foreach ($i = 0; $i < @{$sow->{'ROLEID'}}; $i++) {
		my $output = $rolematrix->[$i];
		$output = 1 if ($i == 0); # おまかせは必ず表示
		print "        <option value=\"$i\">$rolename->[$i]$sow->{'html'}->{'option'}\n" if ($output > 0);
	}

	print <<"_HTML_";
      </select>
	  <input type="hidden" name="cmd" value="selrolepr"$net>$hidden
	  <input type="submit" value="希望役職を変更する"$disabled$net>
	</p>
  </form>
</div>

_HTML_

	return;
}

#----------------------------------------
# 投票／能力対象プルダウンリスト出力
#----------------------------------------
sub OutHTMLVotePC {
	my ($sow, $vil, $cmd) = @_;
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net = $sow->{'html'}->{'net'};
	my $curpl = $sow->{'curpl'};

	# 属性値の取得
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '      ');

	print <<"_HTML_";
    <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
      <div class="formpl_content">$hidden
      <input type="hidden" name="cmd" value="$cmd"$net>
_HTML_

	# 投票／委任選択欄
	if ($cmd eq 'vote') {
		my $votelabels = $sow->{'textrs'}->{'VOTELABELS'};
		if ($vil->{'entrustmode'} == 0) {
			my $option = $sow->{'html'}->{'option'};
			my $star = ' *';

			print "      <select name=\"entrust\">\n";
			if ($curpl->{'entrust'} > 0) {
				# 委任中
				print <<"_HTML_";
        <option value="">$votelabels->[0]$option
        <option value="on" $sow->{'html'}->{'selected'}>$votelabels->[1]$star$option
_HTML_
			} else {
				# 非委任
				print <<"_HTML_";
        <option value="" $sow->{'html'}->{'selected'}>$votelabels->[0]$star$option
        <option value="on">$votelabels->[1]$option
_HTML_
			}
			print "      </select>\n";
		} else {
			print <<"_HTML_";
        <input type="hidden" name="entrust" value=""$net>
        <label for="select$cmd">$votelabels->[0]：</label>
_HTML_
		}
	} else {
		my $votelabel =  $sow->{'textrs'}->{'ABI_ROLE'}->[$curpl->{'role'}];
		print <<"_HTML_";
      <label for="select$cmd">$votelabel：</label>
_HTML_
	}

	print <<"_HTML_";
      <select id="select$cmd" name="target">
_HTML_

	# 対象の表示
	$targetlist = $curpl->gettargetlistwithrandom($cmd);
	foreach (@$targetlist) {
		my $selected = '';
		my $selstar = '';
		my $targetid = 'vote';
		$targetid = 'target' if ($cmd ne 'vote');
		if ($curpl->{$targetid} == $_->{'pno'}) {
			$selected = " $sow->{'html'}->{'selected'}";
			$selstar = ' *';
		}
		print "        <option value=\"$_->{'pno'}\"$selected>$_->{'chrname'}$selstar$sow->{'html'}->{'option'}\n";
	}

	my $disabled = '';
	$disabled = " $sow->{'html'}->{'disabled'}" if ($vil->{'emulated'} > 0);

	print "      </select>";

	if (($curpl->{'role'} == $sow->{'ROLEID_TRICKSTER'}) && ($cmd ne 'vote')) {
		my $votelabel =  $sow->{'textrs'}->{'ABI_ROLE'}->[$curpl->{'role'}];
		print " と、<br$net>\n";
		print <<"_HTML_";
      <label for="select2$cmd">$votelabel：</label>
      <select id="select2$cmd" name="target2">
_HTML_

		# 対象の表示
		$targetlist = $curpl->gettargetlistwithrandom($cmd);
		foreach (@$targetlist) {
			my $selected = '';
			my $selstar = '';
			if ($curpl->{'target2'} == $_->{'pno'}) {
				$selected = " $sow->{'html'}->{'selected'}";
				$selstar = ' *';
			}
			print "        <option value=\"$_->{'pno'}\"$selected>$_->{'chrname'}$selstar$sow->{'html'}->{'option'}\n";
		}
		print "      </select>";
	}
	print "\n";

	print <<"_HTML_";
      <input type="submit" value="変更"$disabled$net>
      </div>
    </form>

_HTML_

	return;
}

#----------------------------------------
# 村建て人欄HTML出力
#----------------------------------------
sub OutHTMLVilMakerPC {
	my ($sow, $vil, $writemode) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $curpl = $sow->{'curpl'};
	my $csidlist = $sow->{'csidlist'};
	my @keys = keys(%$csidlist);
	my %imgpl = (
		cid      => $writemode,
		csid     => $keys[0],
		deathday => -1,
	);
	$imgpl{'deathday'} = $curpl->{'deathday'} if (defined($curpl->{'deathday'}));
	my $charset = $sow->{'charsets'}->{'csid'}->{$imgpl{'csid'}};

	# キャラ画像アドレスの取得
	my $img = &SWHtmlPC::GetImgUrl($sow, \%imgpl, $charset->{'BODY'});

	# キャラ画像部とその他部の横幅を取得
	my ($lwidth, $rwidth) = &SWHtmlPC::GetFormBlockWidth($sow, $charset->{'IMGBODYW'});

	# キャラ画像
	print <<"_HTML_";
<div class="formpl_common">
  <div style="float: left; width: $lwidth;">
    <div class="formpl_chrimg"><img src="$img" width="$charset->{'IMGBODYW'}" height="$charset->{'IMGBODYH'}" alt=""$net></div>
  </div>

_HTML_

	# 名前とID
	my $chrname = $sow->{'charsets'}->getchrname($imgpl{'csid'}, $imgpl{'cid'});
	print <<"_HTML_";
  <div style="float: right; width: $rwidth;">
    <div class="formpl_content">$chrname ($sow->{'uid'})</div>

_HTML_

	# テキストボックスと発言ボタン初め
	print <<"_HTML_";
    <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
    <div class="formpl_content">
_HTML_

	# 発言欄textarea要素の出力
	my %htmlsay;
	$htmlsay{'saycnttext'} = '';
	$htmlsay{'buttonlabel'} = $sow->{'textrs'}->{'BUTTONLABEL_PC'};
	my $caption_say = $sow->{'textrs'}->{'CAPTION_SAY_PC'};
	$htmlsay{'buttonlabel'} =~ s/_BUTTON_/$caption_say/g;
	$htmlsay{'disabled'} = 0;
	$htmlsay{'disabled'} = 1 if ($vil->{'emulated'} > 0);
	&SWHtmlPC::OutHTMLSayTextAreaPC($sow, 'writepr', \%htmlsay);

	print <<"_HTML_";
      <label><input type="checkbox" name="monospace" value="on"$net>等幅</label>
      <label><input type="checkbox" name="loud" value="on"$net>大声</label>
      <input type="hidden" name="$writemode" value="on"$net>
    </div>
    </form>
  </div>
  <div class="clearboth">
    <hr class="invisible_hr"$net>
  </div>
</div>

_HTML_

	return;
}

#----------------------------------------
# 傍観者発言欄HTML出力
#----------------------------------------
sub OutHTMLVilGuestPC {
	my ($sow, $vil, $writemode) = @_;
	my $query = $sow->{'query'};
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'};

	my $curpl = $sow->{'curpl'};
	my $csidlist = $sow->{'csidlist'};
	my @keys = keys(%$csidlist);
	my %imgpl = (
		cid      => $writemode,
		csid     => $keys[0],
		deathday => -1,
	);
	$imgpl{'deathday'} = $curpl->{'deathday'} if (defined($curpl->{'deathday'}));
	my $charset = $sow->{'charsets'}->{'csid'}->{$imgpl{'csid'}};

	# キャラ画像アドレスの取得
	my $img = &SWHtmlPC::GetImgUrl($sow, \%imgpl, $charset->{'BODY'});

	# キャラ画像部とその他部の横幅を取得
	my ($lwidth, $rwidth) = &SWHtmlPC::GetFormBlockWidth($sow, $charset->{'IMGBODYW'});

	# キャラ画像
	print <<"_HTML_";
<div class="formpl_common">
  <div style="float: left; width: $lwidth;">
    <div class="formpl_chrimg"><img src="$img" width="$charset->{'IMGBODYW'}" height="$charset->{'IMGBODYH'}" alt=""$net></div>
  </div>

_HTML_

	# 名前とID
	my $chrname = $sow->{'charsets'}->getchrname($imgpl{'csid'}, $imgpl{'cid'});
	print <<"_HTML_";
  <div style="float: right; width: $rwidth;">
    <div class="formpl_content">$chrname</div>

_HTML_

	# テキストボックスと発言ボタン初め
	print <<"_HTML_";
    <form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
    <div class="formpl_content">
_HTML_

	# 発言欄textarea要素の出力
	my %htmlsay;
	$htmlsay{'saycnttext'} = '';
	$htmlsay{'buttonlabel'} = $sow->{'textrs'}->{'BUTTONLABEL_PC'};
	my $caption_say = $sow->{'textrs'}->{'CAPTION_SAY_PC'};
	$htmlsay{'buttonlabel'} =~ s/_BUTTON_/$caption_say/g;
	$htmlsay{'disabled'} = 0;
	$htmlsay{'disabled'} = 1 if ($vil->{'emulated'} > 0);

	&SWHtmlPC::OutHTMLSayTextAreaPC($sow, 'writepr', \%htmlsay);

	if (($vil->isepilogue() == 0) || ($cfg->{'ENABLED_TSAY_EP'} > 0)) { # エピではない／エピ独り言有効
		print "　<input type=\"submit\" name=\"submit_type\" value=\"$sow->{'textrs'}->{'CAPTION_TSAY_PC'}\"$disabled$net>";
		#print "      <label><input type=\"checkbox\" name=\"think\" value=\"on\"$net>$sow->{'textrs'}->{'CAPTION_TSAY_PC'}</label>";
	}

	print <<"_HTML_";
      <label><input type="checkbox" name="monospace" value="on"$net>等幅</label>
      <label><input type="checkbox" name="loud" value="on"$net>大声</label>
      <input type="hidden" name="$writemode" value="on"$net>
    </div>
_HTML_

	# 傍観者発言にもパスワードが必要にする
	if ($vil->{'entrylimit'} eq 'password') {
		print <<"_HTML_";

    <div class="formpl_content">
      <label for="writepwd">パスワード：</label>
      <input id="writepwd" type="password" name="writepwd" maxlength="8" size="8" value=""$net>
    </div>
_HTML_
	}

	print <<"_HTML_";
    </form>
  </div>
  <div class="clearboth">
    <hr class="invisible_hr"$net>
  </div>
</div>

_HTML_

	return;
}

#----------------------------------------
# 個別フィルタHTML出力
#----------------------------------------
sub OutHTMLPlayerFilter {
	my ($sow, $vil) = @_;
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net = $sow->{'html'}->{'net'};
	my $pno = $query->{'pno'};
	my $turn = $vil->{'turn'};
	$turn = $query->{'turn'} if defined($query->{'turn'});

	my $reqvals = &SWBase::GetRequestValues($sow);
	$reqvals->{'pno'} = '';
	$reqvals->{'turn'} = '';
	if ($reqvals->{'mode'} eq '') {
		$reqvals->{'mode'} = 'all';
	}
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '  ');

	print <<"_HTML_";
<form class="cidfilter">
  <p>$hidden
  <input type="hidden" name="url" value="$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}">
  <label for="turn">個別フィルタ</label>
  <select name="turn">
_HTML_

  # 日付選択欄
	my $i;
	for ($i = 0; $i <= $vil->{'turn'}; $i++) {
		my $turnname = "$i日目";
		$turnname = "プロローグ" if ($i == 0);
		$turnname = "エピローグ" if ($i == $vil->{'epilogue'});
    my $selected = "";
    if ($i == $turn){
      $turnname = "$turnname *";
      $selected = " selected";
    }
    print "    <option value=\"$i\"$selected>$turnname</option>\n";
    last  if ($i == $vil->{'epilogue'});
  }

  # プレイヤー選択欄
  my $selected = "";
  my $fltname = "全員表\示";
  if (!defined($pno)){
    $selected = " selected";
    $fltname = "$fltname *";
  }
	print <<"_HTML_";
  </select>
  <select name="pno">
    <option value="-1"$selected>$fltname</option>
_HTML_

  my $pllist = $vil->getpllist();
  foreach (@$pllist) {
    my $chrname = $_->getchrname();
    my $selected = "";
    if ((defined($pno)) && ($pno == $_->{'pno'})){
      $selected = " selected";
      $chrname = "$chrname *";
    }
    print "    <option value=\"$_->{'pno'}\"$selected>$chrname</option>\n";
  }
  my $i;
  for ($i = -2; $i >= -7; $i--){
    my $fltname = "";
    $fltname = "≪独り言≫" if ($i == -2);
    $fltname = "≪囁き≫" if ($i == -3);
    $fltname = "≪死者の呻き≫" if ($i == -4);
    $fltname = "≪村建て人発言≫" if ($i == -5);
    $fltname = "≪管理者発言≫" if ($i == -6);
    $fltname = "≪傍観者発言≫" if ($i == -7);
    my $selected = "";
    if ((defined($pno)) && ($pno == $i)){
      $selected = " selected";
      $fltname = "$fltname *";
    }
    print "    <option value=\"$i\"$selected>$fltname</option>\n";
  }
  print <<"_HTML_";
  </select>
  <input type="button" value="別窓表\示" onClick="cidfilter(this.form);" class="formsubmit">
  </p>
</form>
<hr class="invisible_hr"$net>
_HTML_

	return;
}

#----------------------------------------
# 表情選択欄HTML出力
#----------------------------------------
sub OutHTMLExpressionFormPC {
	my ($sow, $vil) = @_;
	my $net = $sow->{'html'}->{'net'};

	my $expression = $sow->{'charsets'}->{'csid'}->{$sow->{'curpl'}->{'csid'}}->{'EXPRESSION'};
	if (@$expression > 0) {
		print <<"_HTML_";
    <div class="formpl_content">
      <label for="expression">表\情：</label>
      <select id="expression" name="expression">
_HTML_

		my $i;
		for ($i = 0; $i < @$expression; $i++) {
			my $selected = '';
			$selected = " $sow->{'html'}->{'selected'}" if ($i == 0);
			print "        <option value=\"$i\"$selected>$expression->[$i]$sow->{'html'}->{'option'}\n";
		}
		print "      </select>\n";
		print "    </div>\n";
	}

}

#----------------------------------------
# キックHTML出力
#----------------------------------------
sub OutHTMLKickFormPC {
	my ($sow, $vil, $cmd) = @_;
	my $cfg = $sow->{'cfg'};
	my $query = $sow->{'query'};
	my $net = $sow->{'html'}->{'net'};

	# 属性値の取得
	my $reqvals = &SWBase::GetRequestValues($sow);
	my $hidden = &SWBase::GetHiddenValues($sow, $reqvals, '      ');

	print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$sow->{'cfg'}->{'METHOD_FORM'}">
  <input type="hidden" name="cmd" value="kick"$net>$hidden
  <label for="cid">キック：</label>
  <select id="cid" name="cid">
_HTML_

	# プレイヤー選択欄
	my $pllist = $vil->getpllist();
	foreach (@$pllist) {
		next if $_->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'};
		my $chrname = $_->getchrname();
		print "    <option value=\"$_->{'pno'}\">$chrname</option>\n";
	}
  print <<"_HTML_";
  </select>
  <input type="submit" value="強制退村">
</form>
_HTML_

	return;
}

1;
