package SWHtmlEntryFormPC;

#----------------------------------------
# �G���g���[�t�H�[���̏o��
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

    # �L�����Z�b�g�̓ǂݍ���
    my @csidkey = split( '/', "$vil->{'csid'}/" );
    foreach (@csidkey) {
        $sow->{'charsets'}->loadchrrs($_);
    }

    # �L�����摜�A�h���X�̎擾
    my $charset = $sow->{'charsets'}->{'csid'}->{ $csidkey[0] };    # ��
    my $body    = '';
    $body = '_body' if ( $charset->{'BODY'} ne '' );
    my $img = "$charset->{'DIR'}/undef$body$charset->{'EXT'}";

    # �L�����摜���Ƃ��̑����̉������擾
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
      <label for="selectcid">��]����z���F</label>
      <select id="selectcid" name="csid_cid" onFocus="icoChange()" onChange="icoChange()">
_HTML_

    # �Q���ς݂̃L�������`�F�b�N
    my %csid_cid;
    foreach (@$pllist) {
        $csid_cid{"$_->{'csid'}/$_->{'cid'}"} = 1;
    }

    # ��]����z���̕\��
    my $csid_val;
    foreach $csid_val (@csidkey) {
        my $charset  = $sow->{'charsets'}->{'csid'}->{$csid_val};
        my $chrorder = $charset->{'ORDER'};
        foreach (@$chrorder) {
            next if ( defined( $csid_cid{"$csid_val/$_"} ) );    # �Q���ς݂̃L�����͏��O
            my $chrname = $sow->{'charsets'}->getchrname( $csid_val, $_ );
            print "      <option value=\"$csid_val/$_\">$chrname$sow->{'html'}->{'option'}\n";
        }
    }

    print "      </select>";

    # �z���ꗗ�̕\��
    $reqvals->{'cmd'}  = 'chrlist';
    $reqvals->{'csid'} = $vil->{'csid'};
    $reqvals->{'vid'}  = '';
    $linkvalue         = &SWBase::GetLinkValues( $sow, $reqvals );
    print " <a href=\"$urlsow?$linkvalue\" target=\"_blank\">�z���ꗗ</a>\n";
    my $noselrole = '';
    if ( $vil->{'noselrole'} > 0 ) {
        $noselrole = '�i��E��]�͖����ł��j';
    }

    print <<"_HTML_";
    </div>

    <div class="formpl_content">
      <label for="selectrole">��]����\\�́F</label>
      <select id="selectrole" name="role">
        <option value="-1">$sow->{'textrs'}->{'RANDOMROLE'}$sow->{'html'}->{'option'}
_HTML_

    # ��]����\�͂̕\��
    my $rolename   = $sow->{'textrs'}->{'ROLENAME'};
    my $rolematrix = &SWSetRole::GetSetRoleTable( $sow, $vil, $vil->{'roletable'}, $vil->{'vplcnt'} );

    my $i;
    foreach ( $i = 0 ; $i < @{ $sow->{'ROLEID'} } ; $i++ ) {
        my $output = $rolematrix->[$i];
        $output = 1 if ( $i == 0 );    # ���܂����͕K���\��
        print "        <option value=\"$i\">$rolename->[$i]$sow->{'html'}->{'option'}\n"
          if ( $output > 0 );
    }

    print <<"_HTML_";
      </select>
      $noselrole
    </div>

    <div class="formpl_content">
      �Q�����鎞�̃Z���t�F
_HTML_

    # ������textarea�v�f�̏o��
    my %htmlsay;
    $htmlsay{'buttonlabel'} = '���̑��ɎQ��';
    $htmlsay{'saycnttext'}  = '';
    $htmlsay{'disabled'}    = 0;
    $htmlsay{'disabled'}    = 1 if ( $vil->{'emulated'} > 0 );
    # draft �t���O�����������Ă����i����`���� numeric ��r�Ōx�����o��j
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
    print "      <label><input type=\"checkbox\" name=\"monospace\" value=\"on\"$checkedmspace$net>����</label>\n";

    my $checkedloud = '';
    $checkedloud = " $sow->{'html'}->{'checked'}"
      if ( ( $draft > 0 ) && ( defined $sow->{'draftloud'} && $sow->{'draftloud'} > 0 ) );
    print "      <label><input type=\"checkbox\" name=\"loud\" value=\"on\"$checkedloud$net>�吺</label>\n";
    print <<"_HTML_";
    </div>
_HTML_

    # �Q���p�X���[�h���͗��̕\��
    if ( $vil->{'entrylimit'} eq 'password' ) {
        print <<"_HTML_";

    <div class="formpl_content">
      <label for="entrypwd">�Q���p�X���[�h�F</label>
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
