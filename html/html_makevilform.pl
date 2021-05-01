package SWHtmlMakeVilForm;

#----------------------------------------
# ���쐬�^�ҏW��ʂ�HTML�o��
#----------------------------------------
sub OutHTMLMakeVilForm {
    my ( $sow, $vil ) = @_;
    my $cfg = $sow->{'cfg'};

    my $vmode = '�쐬';
    my $vcmd  = 'makevilpr';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $vmode = '�ҏW';
        $vcmd  = 'editvil';
    }

    $sow->{'html'} = SWHtml->new($sow);       # HTML���[�h�̏�����
    my $net = $sow->{'html'}->{'net'};        # Null End Tag
    $sow->{'http'}->outheader();              # HTTP�w�b�_�̏o��
    $sow->{'html'}->outheader("����$vmode");    # HTML�w�b�_�̏o��
    $sow->{'html'}->outcontentheader();

    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'vid'} = '';
    my $hidden = &SWBase::GetHiddenValues( $sow, $reqvals, '    ' );
    my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
    &SWBase::LoadTextRS( $sow, $vil );

    &SWHtmlPC::OutHTMLLogin($sow);            # ���O�C���{�^��

    # ���t�ʃ��O�ւ̃����N
    &SWHtmlPC::OutHTMLTurnNavi( $sow, $vil )
      if ( $sow->{'query'}->{'cmd'} eq 'editvilform' );

    print <<"_HTML_";
<h2>����$vmode</h2>

_HTML_

    print "<p class=\"caution\">����$vmode����ɂ̓��O�C�����K�v�ł��B</p>\n\n"
      if ( $sow->{'user'}->logined() <= 0 );

    print <<"_HTML_";
<p class="paragraph">
��W�����͍쐬����������$sow->{'cfg'}->{'TIMEOUT_SCRAP'}���Ԃł��B�������ɑ����J�n���Ȃ������ꍇ�A�p���ƂȂ�܂��B
</p>

_HTML_

    my $vcomment = $vil->{'vcomment'};
    $vcomment =~ s/<br( \/)?>/\n/ig;
    my $vplcnt = 16;
    $vplcnt = $vil->{'vplcnt'} if ( $sow->{'query'}->{'cmd'} eq 'editvilform' );
    my $vplcntstart = 16;
    $vplcntstart = $vil->{'vplcntstart'}
      if ( $sow->{'query'}->{'cmd'} eq 'editvilform' );

    print <<"_HTML_";
<form action="$urlsow" method="$cfg->{'METHOD_FORM'}">
<div class="form_vmake">
  <fieldset>
    <legend>���̖��O�Ɛ���</legend>
    <label for="vname" class="multicolumn_label" >���̖��O�F</label>
    <input id="vname" class="multicolumn_left" type="text" name="vname" value="$vil->{'vname'}" size="30"$net>
    <br class="multicolumn_clear"$net>

    <label for="vcomment" class="multicolumn_label">���̐����F</label>
    <textarea id="vcomment" class="multicolumn_left" name="vcomment" cols="30" rows="3">$vcomment</textarea>
  </fieldset>

  <fieldset>
    <legend>��{�ݒ�</legend>
    <label for="vplcnt" class="multicolumn_label" >����F</label>
    <input id="vplcnt" class="multicolumn_left" type="text" name="vplcnt" value="$vplcnt" size="5"$net>
    <br class="multicolumn_clear"$net>

    <label for="vplcntstart" class="multicolumn_label" >�Œ�l���F</label>
    <input id="vplcntstart" class="multicolumn_left" type="text" name="vplcntstart" value="$vplcntstart" size="5"$net> ���J�n���@���l�TBBS�^�̎��̂�
    <br class="multicolumn_clear"$net>

    <label for="updhour" class="multicolumn_label">�X�V���ԁF</label>
    <select id="updhour" name="hour" class="multicolumn_left">
_HTML_

    my $i;
    for ( $i = 0 ; $i < 24 ; $i++ ) {
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'updhour'} == $i );
        print
          "      <option value=\"$i\"$selected>$i��$sow->{'html'}->{'option'}\n";
    }

    print <<"_HTML_";
    </select>
    <select id="updminite" name="minite" class="multicolumn_left">
_HTML_

    for ( $i = 0 ; $i < 60 ; $i += 30 ) {
        my $min      = sprintf( '%02d��', $i );
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'updminite'} == $i );
        print
"      <option value=\"$i\"$selected>$min$sow->{'html'}->{'option'}\n";
    }

    print <<"_HTML_";
    </select>�ɍX�V
    <br class="multicolumn_clear"$net>

    <label for="updinterval" class="multicolumn_label">�X�V�Ԋu�F</label>
    <select id="updinterval" name="updinterval" class="multicolumn_left">
_HTML_

    for ( $i = 1 ; $i <= 3 ; $i++ ) {
        my $interval = sprintf( '%02d����', $i * 24 );
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'updinterval'} == $i );
        print
"      <option value=\"$i\"$selected>$interval$sow->{'html'}->{'option'}\n";
    }

    my $votetype_anonymity = " $sow->{'html'}->{'selected'}";
    my $votetype_sign      = '';
    if ( $vil->{'votetype'} eq 'sign' ) {
        $votetype_anonymity = '';
        $votetype_sign      = " $sow->{'html'}->{'selected'}";
    }

    print <<"_HTML_";
    </select>���ƂɍX�V
    <br class="multicolumn_clear"$net>

    <label for="votetype" class="multicolumn_label">���[���@�F</label>
    <select id="votetype" name="votetype" class="multicolumn_left">
      <option value="anonymity"$votetype_anonymity>���L�����[$sow->{'html'}->{'option'}
      <option value="sign"$votetype_sign>�L�����[$sow->{'html'}->{'option'}
    </select>
    <br class="multicolumn_clear"$net>

    <label for="roletable" class="multicolumn_label">��E�z���F</label>
    <select id="roletable" name="roletable" class="multicolumn_left">
_HTML_

    my $order_roletable = $sow->{'ORDER_ROLETABLE'};
    foreach (@$order_roletable) {
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'roletable'} eq $_ );
        print
"      <option value=\"$_\"$selected>$sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$_}$sow->{'html'}->{'option'}\n";
    }

    #      <option value="later">��Őݒ�$sow->{'html'}->{'option'}

    print <<"_HTML_";
    </select>
    <br class="multicolumn_clear"$net>
  </fieldset>

  <fieldset>
    <legend>��E�z�����R�ݒ�</legend>
_HTML_

    my $roleid = $sow->{'ROLEID'};
    for ( $i = 1 ; $i < @$roleid ; $i++ ) {
        print <<"_HTML_";
    <div class="multicolumn_label"><label for="cnt$roleid->[$i]">$sow->{'textrs'}->{'ROLENAME'}->[$i]�F</label></div>
    <div class="multicolumn_role"><input id="cnt$roleid->[$i]" type="text" name="cnt$roleid->[$i]" size="3" value="$vil->{"cnt$roleid->[$i]"}"$net> �l</div>
_HTML_
        print "    <br class=\"multicolumn_clear\"$net>\n\n"
          if ( ( $i + 1 ) % 2 == 1 );
    }

    my $limitfree     = " $sow->{'html'}->{'checked'}";
    my $limitpassword = '';
    if ( $vil->{'entrylimit'} eq 'password' ) {
        $limitfree     = '';
        $limitpassword = " $sow->{'html'}->{'checked'}";
    }

    print <<"_HTML_";
  </fieldset>

  <fieldset>
    <legend>�Q������</legend>
    <label><input type="radio" name="entrylimit" value="free"$limitfree$net>�����Ȃ�</label><br$net>
    <label>
      <input type="radio" name="entrylimit" value="password"$limitpassword$net>�Q���p�p�X���[�h�K�{�i���p�W�����ȓ��j
    </label>
    <input type="password" name="entrypwd" maxlength="8" size="8" value="$vil->{'entrypwd'}"$net>
    <br class="multicolumn_clear"$net>
  </fieldset>

  <fieldset>
    <legend>�g���ݒ�</legend>
    <label for="csid" class="multicolumn_label">�o��l���F</label>
    <select id="csid" name="csid" class="multicolumn_left">
_HTML_

    my $csidlist = $sow->{'cfg'}->{'CSIDLIST'};
    foreach (@$csidlist) {
        my @csids = split( '/', "$_/" );
        my @captions;
        foreach (@csids) {
            $sow->{'charsets'}->loadchrrs($_);
            push( @captions, $sow->{'charsets'}->{'csid'}->{$_}->{'CAPTION'} );
        }
        my $caption  = join( '��', @captions );
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}" if ( $vil->{'csid'} eq $_ );
        print
"      <option value=\"$_\"$selected> $caption$sow->{'html'}->{'option'}\n";
    }

    # ���ҏW�œo��l������ύX����Ɓc�c�B

    print <<"_HTML_";
    </select>
    <br class="multicolumn_clear"$net>

    <label for="saycnttype" class="multicolumn_label">���������F </label>
    <select id="saycnttype" name="saycnttype" class="multicolumn_left">
_HTML_

    my $countssay       = $sow->{'cfg'}->{'COUNTS_SAY'};
    my $countssay_order = $countssay->{'ORDER'};
    foreach (@$countssay_order) {
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'saycnttype'} eq $_ );
        print
"      <option value=\"$_\"$selected>$countssay->{$_}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
    }

    print <<"_HTML_";
    </select>
    <br class="multicolumn_clear"$net>

    <label for="starttype" class="multicolumn_label">�J�n���@�F </label>
    <select id="starttype" name="starttype" class="multicolumn_left">
_HTML_

    my $starttype      = $sow->{'basictrs'}->{'STARTTYPE'};
    my $starttypeorder = $sow->{'basictrs'}->{'ORDER_STARTTYPE'};

    foreach (@$starttypeorder) {
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'starttype'} eq $_ );
        print
"      <option value=\"$_\"$selected>$starttype->{$_}$sow->{'html'}->{'option'}\n";
    }

    # �V�X�e���̕���
    print <<"_HTML_";
    </select>
    <br class="multicolumn_clear"$net>

    <label for="trsid" class="multicolumn_label">���́F </label>
    <select id="trsid" name="trsid" class="multicolumn_left">
_HTML_

    my $defaulttrsid  = $sow->{'trsid'};
    my $defaulttextrs = $sow->{'textrs'};
    my $trsidlist     = $sow->{'cfg'}->{'TRSIDLIST'};
    foreach (@$trsidlist) {
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'trsid'} eq $_ );

        my %dummyvil = ( trsid => $_, );
        &SWBase::LoadTextRS( $sow, \%dummyvil );
        print
"      <option value=\"$_\"$selected>$sow->{'textrs'}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
    }
    $sow->{'trsid'}  = $defaulttrsid;
    $sow->{'textrs'} = $defaulttextrs;

    print <<"_HTML_";
    </select>
    <br class="multicolumn_clear"$net>

_HTML_

    # �����_���Ώ�
    if ( $sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0 ) {
        my $checkedrndtarget = '';
        $checkedrndtarget = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'randomtarget'} > 0 );

        print <<"_HTML_";
    <label for="randomtarget" class="multicolumn_label">�����_���F </label>
    <input type="checkbox" id="randomtarget" class="multicolumn_left" name="randomtarget" value="on"$checkedrndtarget$net><div class="multicolumn_notes"><label for="randomtarget">���[�E�\\�͂̑ΏۂɁu�����_���v���܂߂�</label></div>

_HTML_
    }

    # ��E��]����
    my $checkednoselrole = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkednoselrole = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'noselrole'} > 0 );
    }
    else {
        $checkednoselrole = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_NOSELROLE'} > 0 );
    }

    print <<"_HTML_";
    <label for="noselrole" class="multicolumn_label">��E��]�F </label>
    <input type="checkbox" id="noselrole" class="multicolumn_left" name="noselrole" value="on"$checkednoselrole$net><div class="multicolumn_notes"><label for="noselrole">��E��]�𖳎�����</label></div>
_HTML_

    # �i�s�������Ĕ����Ȃ�
    my $checkedmakersaymenu = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkedmakersaymenu = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'makersaymenu'} > 0 );
    }
    else {
        $checkedmakersaymenu = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_MAKERSAYMENU'} > 0 );
    }

    print <<"_HTML_";
	<label for="makersaymenu" class="multicolumn_label">�����Ĕ����F </label>
	<input type="checkbox" id="makersaymenu" class="multicolumn_left" name="makersaymenu" value="on"$checkedmakersaymenu$net><div class="multicolumn_notes"><label for="makersaymenu">���i�s���ɑ����Đl�������ł��Ȃ��Ȃ�</label></div>
_HTML_

    # �T�ώҔ����Ȃ�
    my $checkedguestmenu = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkedguestmenu = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'guestmenu'} > 0 );
    }
    else {
        $checkedguestmenu = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_GUESTMENU'} > 0 );
    }

    print <<"_HTML_";
	<label for="guestmenu" class="multicolumn_label">�T�ώҔ����F </label>
	<input type="checkbox" id="guestmenu" class="multicolumn_left" name="guestmenu" value="on"$checkedguestmenu$net><div class="multicolumn_notes"><label for="guestmenu">�T�ώҔ�����s�ɂ���</label></div>
  </fieldset>
_HTML_

    # �ϔC�Ȃ�
    my $checkedentrustmode = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkedentrustmode = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'entrustmode'} > 0 );
    }
    else {
        $checkedentrustmode = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_ENTRUSTMODE'} > 0 );
    }

    print <<"_HTML_";
	<label for="entrustmode" class="multicolumn_label">�ϔC�F </label>
	<input type="checkbox" id="entrustmode" class="multicolumn_left" name="entrustmode" value="on"$checkedentrustmode$net><div class="multicolumn_notes"><label for="entrustmode">�ϔC�@�\\���g��Ȃ��悤�ɂ���</label></div>
_HTML_

    # �扺���J
    my $checkedshowall = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkedshowall = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'showall'} > 0 );
    }
    else {
        $checkedshowall = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_SHOWALL'} > 0 );
    }

    print <<"_HTML_";
	<label for="showall" class="multicolumn_label">�扺���J�F </label>
	<input type="checkbox" id="showall" class="multicolumn_left" name="showall" value="on"$checkedshowall$net><div class="multicolumn_notes"><label for="showall">�扺����͑S��E�ƚ�����������悤�ɂ���</label></div>
_HTML_

    print <<"_HTML_";
    <label for="rating" class="multicolumn_label">�{�������F </label>
    <select id="rating" name="rating" class="multicolumn_left">
_HTML_

    # ���C�e�B���O
    my $rating = $sow->{'cfg'}->{'RATING'};
    foreach ( @{ $rating->{'ORDER'} } ) {
        my $selected = '';
        $selected = " $sow->{'html'}->{'selected'}"
          if ( $vil->{'rating'} eq $_ );
        print
"      <option value=\"$_\"$selected>$rating->{$_}->{'CAPTION'}$sow->{'html'}->{'option'}\n";
    }

    print <<"_HTML_";
    </select>
    <br class="multicolumn_clear"$net>
  </fieldset>
_HTML_

    # �A�N�V����/�����֌W
    print <<"_HTML_";
  <fieldset>
    <legend>�A�N�V����/�����֌W</legend>
    <label for="noactmode" class="multicolumn_label">act/memo�F </label>
    <select id="noactmode" name="noactmode" class="multicolumn_left">
_HTML_

    my $noactlist = $sow->{'cfg'}->{'NOACTLIST'};
    my $i         = 0;
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        foreach (@$noactlist) {
            my $selected = '';
            $selected = " $sow->{'html'}->{'selected'}"
              if ( $vil->{'noactmode'} eq $i );
            print
"      <option value=\"$i\"$selected>$_$sow->{'html'}->{'option'}\n";
            $i++;
        }
    }
    else {
        foreach (@$noactlist) {
            my $selected = '';
            $selected = " $sow->{'html'}->{'selected'}"
              if ( $cfg->{'DEFAULT_NOACTMODE'} eq $i );
            print
"      <option value=\"$i\"$selected>$_$sow->{'html'}->{'option'}\n";
            $i++;
        }
    }
    print <<"_HTML_";
    </select>
    <br class="multicolumn_clear"$net>

_HTML_

    my $checkednocandy = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkednocandy = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'nocandy'} > 0 );
    }
    else {
        $checkednocandy = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_NOCANDY'} > 0 );
    }

    print <<"_HTML_";
	<label for="nocandy" class="multicolumn_label">����(��)�F </label>
	<input type="checkbox" id="nocandy" class="multicolumn_left" name="nocandy" value="on"$checkednocandy$net><div class="multicolumn_notes"><label for="nocandy">�������g���Ȃ��悤�ɂ���</label></div>
_HTML_

    my $checkednofreeact = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkednofreeact = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'nofreeact'} > 0 );
    }
    else {
        $checkednofreeact = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_NOFREEACT'} > 0 );
    }

    print <<"_HTML_";
	<label for="nofreeact" class="multicolumn_label">���R���F </label>
	<input type="checkbox" id="nofreeact" class="multicolumn_left" name="nofreeact" value="on"$checkednofreeact$net><div class="multicolumn_notes"><label for="nofreeact">���R���A�N�V�������g���Ȃ��悤�ɂ���</label></div>
  </fieldset>

  <fieldset>
	<legend>�F�X�\\���֌W</legend>
_HTML_

    my $checkedshowid = '';
    $checkedshowid = " $sow->{'html'}->{'checked'}" if ( $vil->{'showid'} > 0 );

    print <<"_HTML_";
	<label for="showid" class="multicolumn_label">�h�c���J�F </label>
	<input type="checkbox" id="showid" class="multicolumn_left" name="showid" value="on"$checkedshowid$net><div class="multicolumn_notes"><label for="showid">�ŏ�����v���C���[�h�c�����J����</label></div>
_HTML_

    my $checkedtimestamp = '';
    if ( $sow->{'query'}->{'cmd'} eq 'editvilform' ) {
        $checkedtimestamp = " $sow->{'html'}->{'checked'}"
          if ( $vil->{'timestamp'} > 0 );
    }
    else {
        $checkedtimestamp = " $sow->{'html'}->{'checked'}"
          if ( $cfg->{'DEFAULT_TIMESTAMP'} > 0 );
    }

    print <<"_HTML_";
	<label for="timestamp" class="multicolumn_label">�����\\���F </label>
	<input type="checkbox" id="timestamp" class="multicolumn_left" name="timestamp" value="on"$checkedtimestamp$net><div class="multicolumn_notes"><label for="timestamp">�i�s���A������10�����݂̊ȈՕ\\���ɂ���</label></div>
  </fieldset>
_HTML_

    print <<"_HTML_";
  <div class="exevmake">
    <input type="hidden" name="cmd" value="$vcmd"$net>$hidden
    <input type="hidden" name="makeruid" value="$sow->{'uid'}"$net>$hidden
_HTML_

    print
      "    <input type=\"hidden\" name=\"vid\" value=\"$vil->{'vid'}\"$net>\n"
      if ( $vcmd eq 'editvil' );

    my $disabled = '';
    $disabled = " $sow->{'html'}->{'disabled'}"
      if ( $sow->{'user'}->logined() <= 0 );

    print <<"_HTML_";
    <input type="submit" value="����$vmode"$disabled$net>
  </div>
</div>
</form>

_HTML_

    # ���t�ʃ��O�ւ̃����N
    &SWHtmlPC::OutHTMLTurnNavi( $sow, $vil )
      if ( $sow->{'query'}->{'cmd'} eq 'editvilform' );

    &SWHtmlPC::OutHTMLReturnPC($sow);    # �g�b�v�y�[�W�֖߂�

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();         # HTML�t�b�^�̏o��
    $sow->{'http'}->outfooter();

    return;
}

1;
