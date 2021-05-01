package SWHtmlEntryFormMb;

#----------------------------------------
# エントリー欄／傍観者発言欄HTML出力
#----------------------------------------
sub OutHTMLEntryFormMb {
    my ( $sow, $vil ) = @_;
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};

    $sow->{'html'} = SWHtml->new($sow);           # HTMLモードの初期化
    my $outhttp = $sow->{'http'}->outheader();    # HTTPヘッダの出力
    return if ( $outhttp == 0 );                  # ヘッダ出力のみ
    $sow->{'html'}->outheader("$sow->{'query'}->{'vid'} $vil->{'vname'}")
      ;                                           # HTMLヘッダの出力

    my $net = $sow->{'html'}->{'net'};            # Null End Tag

    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";
    my $hidden = &SWBase::GetHiddenValues( $sow, $reqvals, '' );

    print <<"_HTML_";
<a name="say">$sow->{'query'}->{'vid'} $vil->{'vname'}</a><br$net>
<a href="$link" accesskey="4">戻る</a><br$net>
<hr$net>
_HTML_

    &OutHTMLEntrySayMb( $sow, $vil )
      if ( ( $vil->{'turn'} == 0 )
        && ( $vil->checkentried() < 0 )
        && ( $vil->{'vplcnt'} > @$pllist ) );
    require "$sow->{'cfg'}->{'DIR_HTML'}/html_entryform_mb.pl";
    &SWHtmlPlayerFormMb::OutHTMLGuestMb( $sow, $vil );

    print "<a href=\"$link\">戻る</a>";

    $sow->{'html'}->outfooter();    # HTMLフッタの出力
    $sow->{'http'}->outfooter();

    return;
}

#----------------------------------------
# エントリーフォームの出力
#----------------------------------------
sub OutHTMLEntrySayMb {
    my ( $sow, $vil ) = @_;
    my $cfg    = $sow->{'cfg'};
    my $query  = $sow->{'query'};
    my $pllist = $vil->getpllist();
    require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";

    # キャラセットの読み込み
    my @csidkey = split( '/', "$vil->{'csid'}/" );
    foreach (@csidkey) {
        $sow->{'charsets'}->loadchrrs($_);
    }

    my $net    = $sow->{'html'}->{'net'};      # Null End Tag
    my $option = $sow->{'html'}->{'option'};

    my $reqvals = &SWBase::GetRequestValues($sow);
    my $hidden  = &SWBase::GetHiddenValues( $sow, $reqvals, '' );

    print <<"_HTML_";
<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM_MB'}">
希望配役<br$net>
<select name="csid_cid">
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
            my $chrname  = $sow->{'charsets'}->getchrname( $csid_val, $_ );
            my $selected = '';
            $selected = " $sow->{'html'}->{'selected'}"
              if ( "$csid_val/$_" eq $query->{'csid_cid'} );
            print "<option value=\"$csid_val/$_\"$selected>$chrname$option\n";
        }
    }

    my $roleselected = '';
    $roleselected = " $sow->{'html'}->{'selected'}"
      if ( ( defined( $query->{'role'} ) ) && ( $query->{'role'} < 0 ) );
    my $noselrole = '';
    if ( $vil->{'noselrole'} > 0 ) {
        $noselrole = '（役職希望は無効です）';
    }

    print <<"_HTML_";
</select><br$net>

希望能\力$noselrole<br$net>
<select name="role">
<option value="-1"$roleselected>$sow->{'textrs'}->{'RANDOMROLE'}$sow->{'html'}->{'option'}
_HTML_

    # 希望する能力の表示
    my $rolename = $sow->{'textrs'}->{'ROLENAME'};
    my $rolematrix =
      &SWSetRole::GetSetRoleTable( $sow, $vil, $vil->{'roletable'},
        $vil->{'vplcnt'} );

    my $i;
    foreach ( $i = 0 ; $i < @{ $sow->{'ROLEID'} } ; $i++ ) {
        my $output = $rolematrix->[$i];
        $output       = 1 if ( $i == 0 );                 # おまかせは必ず表示
        $roleselected = '';
        $roleselected = " $sow->{'html'}->{'selected'}"
          if ( ( defined( $query->{'role'} ) ) && ( $query->{'role'} == $i ) );
        print "<option value=\"$i\"$roleselected>$rolename->[$i]$option\n"
          if ( $output > 0 );
    }

    # テキストボックスと発言ボタン
    my $buttonlabel = '参加';

    print <<"_HTML_";
</select><br$net>

_HTML_

    # 参加パスワード入力欄の表示
    if ( $vil->{'entrylimit'} eq 'password' ) {
        my $entrypwd = '';
        $entrypwd = $query->{'entrypwd'} if ( $query->{'entrypwd'} ne '' );
        print <<"_HTML_";
パスワード<br$net>
<input type="text" name="entrypwd" size="8" istyle="3" value="$entrypwd"$net><br$net>
_HTML_
    }

    my $mes = '';
    $mes = $query->{'mes'}
      if ( ( $query->{'wolf'} eq '' )
        && ( $query->{'maker'} eq '' )
        && ( $query->{'admin'} eq '' )
        && ( $query->{'guest'} eq '' ) );
    $mes =~ s/<br( \/)?>/\n/ig;

    print <<"_HTML_";
セリフ<br$net>
<textarea name="mes" rows="3" istyle="1">$mes</textarea><br$net>
<input type="hidden" name="cmd" value="entrypr"$net>$hidden
<input type="submit" value="$buttonlabel"$net>
_HTML_

    my $checked = '';
    $checked = " $sow->{'html'}->{'checked'}"
      if ( ( $query->{'monospace'} ne '' ) && ( $query->{'guest'} eq '' ) );
    print
"<input type=\"checkbox\" name=\"monospace\" value=\"on\"$checked$net>等幅\n";
    my $checked = '';
    $checked = " $sow->{'html'}->{'checked'}"
      if ( ( $query->{'loud'} ne '' ) && ( $query->{'guest'} eq '' ) );
    print
      "<input type=\"checkbox\" name=\"loud\" value=\"on\"$checked$net>大声\n";

    print <<"_HTML_";
</form>
<hr$net>
_HTML_

}

1;
