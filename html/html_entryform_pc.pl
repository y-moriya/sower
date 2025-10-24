package SWHtmlEntryFormPC;

#----------------------------------------
# エントリーフォームの出力
#----------------------------------------
sub OutHTMLEntryFormPC {
    my ( $sow, $vil ) = @_;
    my $cfg    = $sow->{'cfg'};
    my $query  = $sow->{'query'};
    my $net    = $sow->{'html'}->{'net'};
    my $pllist = $vil->getpllist();
    require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";

    my $linkvalue;
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $urlsow  = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

    # キャラセットの読み込み
    my @csidkey = split( '/', "$vil->{'csid'}/" );
    foreach (@csidkey) {
        $sow->{'charsets'}->loadchrrs($_);
    }

    # キャラ画像アドレスの取得
    my $charset = $sow->{'charsets'}->{'csid'}->{ $csidkey[0] };    # 仮
    my $body    = '';
    $body = '_body' if ( $charset->{'BODY'} ne '' );
    my $img = "$charset->{'DIR'}/undef$body$charset->{'EXT'}";

    # キャラ画像部とその他部の横幅を取得
    my ( $lwidth, $rwidth ) =
      &SWHtmlPC::GetFormBlockWidth( $sow, $charset->{'IMGBODYW'} );

    print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" name="entryForm" method="$sow->{'cfg'}->{'METHOD_FORM'}">
<div class="formpl_frame">
<div class="formpl_common">

  <div style="float: left; width: $lwidth;">
    <div class="formpl_chrimg"><img src="$img" width="$charset->{'IMGBODYW'}" height="$charset->{'IMGBODYH'}" name="charaImg"$net></div>
  </div>

  <div style="float: right; width: $rwidth;">
    <div class="formpl_content">
      <label for="selectcid">希望する配役：</label>
      <select id="selectcid" name="csid_cid" onFocus="icoChange()" onChange="icoChange()">
_HTML_

    # 参加済みのキャラをチェック
    my %csid_cid;
    foreach (@$pllist) {
        $csid_cid{"$_->{'csid'}/$_->{'cid'}"} = 1;
    }

    # 希望する配役の表示
    my $csid_val;
    foreach $csid_val (@csidkey) {
        my $charset  = $sow->{'charsets'}->{'csid'}->{$csid_val};
        my $chrorder = $charset->{'ORDER'};
        foreach (@$chrorder) {
            next if ( defined( $csid_cid{"$csid_val/$_"} ) );    # 参加済みのキャラは除外
            my $chrname = $sow->{'charsets'}->getchrname( $csid_val, $_ );
            print "      <option value=\"$csid_val/$_\">$chrname$sow->{'html'}->{'option'}\n";
        }
    }

    print "      </select>";

    # 配役一覧の表示
    $reqvals->{'cmd'}  = 'chrlist';
    $reqvals->{'csid'} = $vil->{'csid'};
    $reqvals->{'vid'}  = '';
    $linkvalue         = &SWBase::GetLinkValues( $sow, $reqvals );
    print " <a href=\"$urlsow?$linkvalue\" target=\"_blank\">配役一覧</a>\n";
    my $noselrole = '';
    if ( $vil->{'noselrole'} > 0 ) {
        $noselrole = '（役職希望は無効です）';
    }

    print <<"_HTML_";
    </div>

    <div class="formpl_content">
      <label for="selectrole">希望する能\力：</label>
      <select id="selectrole" name="role">
        <option value="-1">$sow->{'textrs'}->{'RANDOMROLE'}$sow->{'html'}->{'option'}
_HTML_

    # 希望する能力の表示
    my $rolename   = $sow->{'textrs'}->{'ROLENAME'};
    my $rolematrix = &SWSetRole::GetSetRoleTable( $sow, $vil, $vil->{'roletable'}, $vil->{'vplcnt'} );

    my $i;
    foreach ( $i = 0 ; $i < @{ $sow->{'ROLEID'} } ; $i++ ) {
        my $output = $rolematrix->[$i];
        $output = 1 if ( $i == 0 );    # おまかせは必ず表示
        print "        <option value=\"$i\">$rolename->[$i]$sow->{'html'}->{'option'}\n"
          if ( $output > 0 );
    }

    print <<"_HTML_";
      </select>
      $noselrole
    </div>

    <div class="formpl_content">
      参加する時のセリフ：
_HTML_

    # 発言欄textarea要素の出力
    my %htmlsay;
    $htmlsay{'buttonlabel'} = 'この村に参加';
    $htmlsay{'saycnttext'}  = '';
    $htmlsay{'disabled'}    = 0;
    $htmlsay{'disabled'}    = 1 if ( $vil->{'emulated'} > 0 );
    # draft フラグを初期化しておく（未定義だと numeric 比較で警告が出る）
    my $draft = 0;
    $draft = 1 if ( defined $sow->{'savedraft'} && $sow->{'savedraft'} ne '' );
    if ( ( $query->{'mes'} ne '' ) && ( $query->{'cmdfrom'} eq 'entrypr' ) ) {
        my $mes = $query->{'mes'};
        $mes =~ s/<br( \/)?>/\n/ig;

        #		&SWBase::ExtractChrRef(\$mes);
        $htmlsay{'text'} = $mes;
    }
    &SWHtmlPC::OutHTMLSayTextAreaPC( $sow, $vil, 'entrypr', \%htmlsay, 'entry' );

    my $checkedmspace = '';
    $checkedmspace = " $sow->{'html'}->{'checked'}"
      if ( ( $draft > 0 ) && ( defined $sow->{'draftmspace'} && $sow->{'draftmspace'} > 0 ) );
    print "      <label><input type=\"checkbox\" name=\"monospace\" value=\"on\"$checkedmspace$net>等幅</label>\n";

    my $checkedloud = '';
    $checkedloud = " $sow->{'html'}->{'checked'}"
      if ( ( $draft > 0 ) && ( defined $sow->{'draftloud'} && $sow->{'draftloud'} > 0 ) );
    print "      <label><input type=\"checkbox\" name=\"loud\" value=\"on\"$checkedloud$net>大声</label>\n";
    print <<"_HTML_";
    </div>
_HTML_

    # 参加パスワード入力欄の表示
    if ( $vil->{'entrylimit'} eq 'password' ) {
        print <<"_HTML_";

    <div class="formpl_content">
      <label for="entrypwd">参加パスワード：</label>
      <input id="entrypwd" type="password" name="entrypwd" maxlength="8" size="8" value=""$net>
    </div>
_HTML_
    }

    print <<"_HTML_";
  </div>

  <div class="clearboth">
    <hr class="invisible_hr"$net>
  </div>
</div>
</div>
</form>

_HTML_

}

1;
