package SWHtmlMakeVilPreview;

#----------------------------------------
# ���쐬�v���r���[HTML�̕\��
#----------------------------------------
sub OutHTMLMakeVilPreview {
    my $sow   = shift;
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};

    # ���쐬���l�`�F�b�N
    require "$sow->{'cfg'}->{'DIR_LIB'}/vld_makevil.pl";
    &SWValidityMakeVil::CheckValidityMakeVil($sow);

    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vindex.pl";
    my $vindex = SWFileVIndex->new($sow);
    $vindex->openvindex();
    my $vcnt = $vindex->getactivevcnt();
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "���݉ғ����̑��̐�������ɒB���Ă���̂ŁA�����쐬�ł��܂���B", "too many villages." )
      if ( $vcnt >= $sow->{'cfg'}->{'MAX_VILLAGES'} );
    $vindex->closevindex();

    require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";

    $sow->{'html'} = SWHtml->new($sow);           # HTML���[�h�̏�����
    my $net     = $sow->{'html'}->{'net'};        # Null End Tag
    my $outhttp = $sow->{'http'}->outheader();    # HTTP�w�b�_�̏o��
    return if ( $outhttp == 0 );                  # �w�b�_�o�͂̂�
    $sow->{'html'}->outheader('���쐬�̃v���r���[');       # HTML�w�b�_�̏o��
    $sow->{'html'}->outcontentheader();

    print <<"_HTML_";
<h2>���쐬�̃v���r���[</h2>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
_HTML_

    # �L�����Z�b�g�̓ǂݍ���
    &SWBase::LoadTextRSWithoutVil( $sow, $query->{'trsid'} );

    # �쐬�ݒ蕔���̕\��

    print <<"_HTML_";
<div class="paragraph">
<p class="multicolumn_label">���̖��O�F</p>
<p class="multicolumn_left">$query->{'vname'}</p>
<br class="multicolumn_clear"$net>

_HTML_

    &SWHtml::ConvertNET( $sow, \$query->{'vcomment'} );

    print <<"_HTML_";
<p class="multicolumn_label">���̐����F</p>
<p class="multicolumn_right">$query->{'vcomment'}</p>
<br class="multicolumn_clear"$net>
</div>

<div class="paragraph">
_HTML_

    my $vplcnt = getinfocap_vplcnt( $query->{'vplcnt'} );
    print <<"_HTML_";
<p class="multicolumn_label">����F</p>
<p class="multicolumn_left">$vplcnt</p>
<br class="multicolumn_clear"$net>
_HTML_

    if ( $query->{'starttype'} eq 'wbbs' ) {
        my $vplcntstart = getinfocap_vplcntstart( $query->{'vplcntstart'} );
        print <<"_HTML_";
<p class="multicolumn_label">�Œ�l���F</p>
<p class="multicolumn_left">$vplcntstart</p>
<br class="multicolumn_clear"$net>
_HTML_
    }

    my $updatedt = getinfocap_updatedt( $query->{'hour'}, $query->{'minite'} );
    print <<"_HTML_";
<p class="multicolumn_label">�X�V���ԁF</p>
<p class="multicolumn_role">$updatedt</p>

_HTML_

    my $interval = getinfocap_updinterval( $query->{'updinterval'} );
    print <<"_HTML_";
<p class="multicolumn_label">�X�V�Ԋu�F</p>
<p class="multicolumn_left">$interval</p>
<br class="multicolumn_clear"$net>

_HTML_

    my $roletable  = getinfocap_roletable( $sow, $query->{'roletable'} );
    my $roletable2 = '';
    if ( $query->{'roletable'} eq 'custom' ) {
        $roletable2 = getinfocap_custom( $sow, $query );
    }
    print <<"_HTML_";
<p class="multicolumn_label">��E�z���F</p>
<p class="multicolumn_right">
$roletable<br$net>
$roletable2
</p>
<br class="multicolumn_clear"$net>

_HTML_

    my $votetype = getinfocap_votetype( $query->{'votetype'} );
    print <<"_HTML_";
<p class="multicolumn_label">���[���@�F</p>
<p class="multicolumn_left">$votetype</p>
<br class="multicolumn_clear"$net>

_HTML_

    my $scraplimit =
      getinfocap_scraplimit( $sow, $query->{'hour'}, $query->{'minite'} );
    print <<"_HTML_";
<p class="multicolumn_label">�p�������F</p>
<p class="multicolumn_left">$scraplimit</p>
<br class="multicolumn_clear"$net>

_HTML_

    my $entrylimit = getinfocap_entrylimit( $query->{'entrylimit'} );
    print <<"_HTML_";
<p class="multicolumn_label">�Q�������F</p>
<p class="multicolumn_left">$entrylimit</p>
<br class="multicolumn_clear"$net>

_HTML_

    my $csidcaptions = getinfocap_csidcaptions( $sow, $query->{'csid'} );
    print <<"_HTML_";
</div>

<div class="paragraph">
<p class="multicolumn_label">�o��l���F</p>
<p class="multicolumn_left">$csidcaptions</p>
<br class="multicolumn_clear"$net>

_HTML_

    $saycnttype = getinfocap_saycnttype( $sow, $query->{'saycnttype'} );
    $starttype  = getinfocap_starttype( $sow, $query->{'starttype'} );
    $trsid      = getinfocap_trsid( $sow, $query->{'trsid'} );

    print <<"_HTML_";
<p class="multicolumn_label">���������F</p>
<p class="multicolumn_left">$saycnttype</p>
<br class="multicolumn_clear"$net>

<p class="multicolumn_label">�J�n���@�F</p>
<p class="multicolumn_left">$starttype</p>
<br class="multicolumn_clear"$net>

<p class="multicolumn_label">���͌n�F</p>
<p class="multicolumn_left">$trsid</p>
<br class="multicolumn_clear"$net>
_HTML_

    if ( $sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0 ) {
        $randomtarget = getinfocap_randomtarget( $query->{'randomtarget'} );
        print <<"_HTML_";

<p class="multicolumn_label">�����_���F</p>
<p class="multicolumn_left">$randomtarget</p>
<br class="multicolumn_clear"$net>
_HTML_
    }

    my $noselrole = getinfocap_noselrole( $query->{'noselrole'} );
    print <<"_HTML_";

<p class="multicolumn_label">��E��]�F</p>
<p class="multicolumn_left">$noselrole</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $makersaymenu = getinfocap_makersaymenu( $query->{'makersaymenu'} );
    print <<"_HTML_";

<p class="multicolumn_label">�����Ĕ����F</p>
<p class="multicolumn_left">$makersaymenu</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $entrustmode = getinfocap_entrustmode( $query->{'entrustmode'} );
    print <<"_HTML_";

<p class="multicolumn_label">�ϔC�F</p>
<p class="multicolumn_left">$entrustmode</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $showall = getinfocap_showall( $query->{'showall'} );
    print <<"_HTML_";

<p class="multicolumn_label">�扺���J�F</p>
<p class="multicolumn_left">$showall</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $rating = getinfocap_rating( $sow, $query->{'rating'} );
    print <<"_HTML_";

<p class="multicolumn_label">�{�������F</p>
<p class="multicolumn_left">$rating</p>
<br class="multicolumn_clear"$net>
<hr>
_HTML_

    $noactmode = getinfocap_noactmode( $sow, $query->{'noactmode'} );
    print <<"_HTML_";

<p class="multicolumn_label">act/memo�F</p>
<p class="multicolumn_left">$noactmode</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $nocandy = getinfocap_nocandy( $query->{'nocandy'} );
    print <<"_HTML_";

<p class="multicolumn_label">�����F</p>
<p class="multicolumn_left">$nocandy</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $nofreeact = getinfocap_nofreeact( $query->{'nofreeact'} );
    print <<"_HTML_";

<p class="multicolumn_label">���R��act�F</p>
<p class="multicolumn_left">$nofreeact</p>
<br class="multicolumn_clear"$net>
<hr>
_HTML_

    my $showid = getinfocap_showid( $query->{'showid'} );
    print <<"_HTML_";

<p class="multicolumn_label">ID���J�F</p>
<p class="multicolumn_left">$showid</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $timestamp = getinfocap_timestamp( $query->{'timestamp'} );
    print <<"_HTML_";

<p class="multicolumn_label">�����\\���F</p>
<p class="multicolumn_left">$timestamp</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $guestmenu = getinfocap_guestmenu( $query->{'guestmenu'} );
    print <<"_HTML_";

<p class="multicolumn_label">�T�ώҔ����F</p>
<p class="multicolumn_left">$guestmenu</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $noque = getinfocap_noque( $query->{'noque'} );
    print <<"_HTML_";

<p class="multicolumn_label">�����ۗ��F</p>
<p class="multicolumn_left">$noque</p>
<br class="multicolumn_clear"$net>
_HTML_

    my $nosudden = getinfocap_nosudden( $query->{'nosudden'} );
    print <<"_HTML_";

<p class="multicolumn_label">�ˑR���F</p>
<p class="multicolumn_left">$nosudden</p>
<br class="multicolumn_clear"$net>
_HTML_

    print "</div>\n\n";

    # �����l����
    # ���쐬�Ɏg�p���鑮���l�����ׂĎ擾����
    $query->{'vcomment'} =~ s/<br( \/)?>/&#13\;/ig;
    my @reqkeys = (
        'vname',        'vcomment',     'makeruid',   'roletable', 'hour',        'minite',
        'updinterval',  'vplcnt',       'entrylimit', 'entrypwd',  'rating',      'vplcntstart',
        'saycnttype',   'starttype',    'votetype',   'noselrole', 'entrustmode', 'showall',
        'noactmode',    'nocandy',      'nofreeact',  'guestmenu', 'showid',      'timestamp',
        'randomtarget', 'makersaymenu', 'csid',       'trsid',     'noque',       'nosudden',
    );
    my $reqvals = &SWBase::GetRequestValues( $sow, \@reqkeys );
    my $hidden  = &SWBase::GetHiddenValues( $sow, $reqvals, '  ' );

    # �쐬�E�C���{�^���̕\��
    print <<"_HTML_";
<p class="paragraph">���̐ݒ�ő����쐬���܂����H
�����e���C������ꍇ�́A�u���E�U�̖߂�{�^���Ŗ߂邩�A���쐬������ɑ��̕ҏW���s���Ă��������B</p>
<p class="multicolumn_label">
  <input type="hidden" name="cmd" value="makevil"$net>
  <input type="hidden" name="cmdfrom" value="$query->{'cmd'}"$net>$hidden
  <input type="submit" value="���̍쐬" data-submit-type="makevil"$net>
</p>
</form
<div class="multicolumn_clear">
  <hr class="invisible_hr"$net>
</div>

_HTML_

    &SWHtmlPC::OutHTMLReturnPC($sow);

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();    # HTML�t�b�^�̏o��
    $sow->{'http'}->outfooter();

    return;
}

#----------------------------------------
# ���쐬���ɃL���v�V�����𓾂�
#----------------------------------------
sub getinfocap_vplcnt {
    my $vplcnt = shift;
    return "$vplcnt�l �i�_�~�[�L�������܂ށj";
}

sub getinfocap_vplcntstart {
    my $vplcntstart = shift;
    return "$vplcntstart�l";
}

sub getinfocap_updatedt {
    my ( $hour, $minite ) = @_;
    return sprintf( '%02d��%02d��', $hour, $minite );
}

sub getinfocap_updinterval {
    my $updinterval = shift;
    return sprintf( '%02d����', $updinterval * 24 );
}

sub getinfocap_roletable {
    my ( $sow, $roletable ) = @_;
    return $sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$roletable};
}

sub getinfocap_custom {
    my ( $sow, $query ) = @_;
    my $roletabletext = '';
    my $roleid        = $sow->{'ROLEID'};
    for ( $i = 1 ; $i < @$roleid ; $i++ ) {
        my $countrole = 0;
        if ( defined( $query->{"cnt$roleid->[$i]"} ) ) {
            $countrole = $query->{"cnt$roleid->[$i]"};
            if ( int($countrole) > 0 ) {
                $roletabletext .= "$sow->{'textrs'}->{'ROLENAME'}->[$i]: $countrole�l ";
            }
        }
    }
    $resultcap = "�i$roletabletext�j\n";
    return $resultcap;
}

sub getinfocap_votetype {
    my $votetype = shift;
    if ( $votetype eq 'anonymity' ) {
        return '���L�����[';
    }
    elsif ( $votetype eq 'sign' ) {
        return '�L�����[';
    }
    else {
        return '';
    }
}

sub getinfocap_scraplimit {
    my ( $sow, $updhour, $updminite ) = @_;
    $scraplimitdt =
      $sow->{'dt'}
      ->getnextupdatedtwithoutvil( $updhour, $updminite, $sow->{'time'}, $sow->{'cfg'}->{'TIMEOUT_SCRAP'}, 1 );
    $resultcap = $sow->{'dt'}->cvtdt($scraplimitdt);
    $resultcap = '�����p���Ȃ�' if ( $scraplimitdt == 0 );
    return $resultcap;
}

sub getinfocap_entrylimit {
    my $entrylimit = shift;
    if ( $entrylimit eq 'password' ) {
        return '�p�X���[�h����';
    }
    else {
        return '�p�X���[�h�Ȃ�';
    }
}

sub getinfocap_csidcaptions {
    my ( $sow, $csid ) = @_;
    my $resultcap = '';
    my @pcsidlist = split( '/', $csid );
    chomp(@pcsidlist);
    foreach (@pcsidlist) {
        $sow->{'charsets'}->loadchrrs($_);
        $resultcap .= "$sow->{'charsets'}->{'csid'}->{$_}->{'CAPTION'} ";
    }
    return $resultcap;
}

sub getinfocap_saycnttype {
    my ( $sow, $saycnttype ) = @_;
    return $sow->{'cfg'}->{'COUNTS_SAY'}->{$saycnttype}->{'CAPTION'};
}

sub getinfocap_starttype {
    my ( $sow, $starttype ) = @_;
    return $sow->{'basictrs'}->{'STARTTYPE'}->{$starttype};
}

sub getinfocap_trsid {
    my ( $sow, $trsid ) = @_;
    return $sow->{'textrs'}->{'CAPTION'};
}

sub getinfocap_randomtarget {
    my $randomtarget = shift;
    if ( $randomtarget ne '' ) {
        return '���[�E�\�͂̑ΏۂɁu�����_���v���܂߂�';
    }
    else {
        return '���[�E�\�͂̑ΏۂɁu�����_���v���܂߂Ȃ�';
    }
}

sub getinfocap_noselrole {
    my $noselrole = shift;
    if ( $noselrole ne '' ) {
        return '����';
    }
    else {
        return '�L��';
    }
}

sub getinfocap_makersaymenu {
    my $makersaymenu = shift;
    if ( $makersaymenu ne '' ) {
        return '�s����';
    }
    else {
        return '����';
    }
}

sub getinfocap_entrustmode {
    my $entrustmode = shift;
    if ( $entrustmode ne '' ) {
        return '�s����';
    }
    else {
        return '����';
    }
}

sub getinfocap_showall {
    my $showall = shift;
    if ( $showall ne '' ) {
        return '���J';
    }
    else {
        return '����J';
    }
}

sub getinfocap_rating {
    my ( $sow, $rating ) = @_;
    return $sow->{'cfg'}->{'RATING'}->{$rating}->{'CAPTION'};
}

sub getinfocap_noactmode {
    my ( $sow, $noactmode ) = @_;
    my $noactlist = $sow->{'cfg'}->{'NOACTLIST'};
    return @$noactlist[$noactmode];
}

sub getinfocap_nocandy {
    my $nocandy = shift;
    if ( $nocandy ne '' ) {
        return '�Ȃ�';
    }
    else {
        return '����';
    }
}

sub getinfocap_showid {
    my $showid = shift;
    if ( $showid ne '' ) {
        return '����';
    }
    else {
        return '�Ȃ�';
    }
}

sub getinfocap_nofreeact {
    my $nocandy = shift;
    if ( $nocandy ne '' ) {
        return '�Ȃ�';
    }
    else {
        return '����';
    }
}

sub getinfocap_timestamp {
    my $timestamp = shift;
    if ( $timestamp ne '' ) {
        return '�ȗ��\\��';
    }
    else {
        return '���S�\\��';
    }
}

sub getinfocap_guestmenu {
    my $guestmenu = shift;
    if ( $guestmenu ne '' ) {
        return '�Ȃ�';
    }
    else {
        return '����';
    }
}

sub getinfocap_noque {
    my $noque = shift;
    if ( $noque ne '' ) {
        return '�Ȃ�';
    }
    else {
        return '����';
    }
}

sub getinfocap_nosudden {
    my $nosudden = shift;
    if ( $nosudden ne '' ) {
        return '�Ȃ�';
    }
    else {
        return '����';
    }
}

1;
