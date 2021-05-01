package SWHtmlVilInfoMb;

#----------------------------------------
# ������ʂ�HTML�o�́i���o�C���j
#----------------------------------------
sub OutHTMLVilInfoMb {
    my $sow   = $_[0];
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};
    my $i;

    require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";

    # ���f�[�^�̓ǂݍ���
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();
    $vil->closevil();

    # ���\�[�X�̓ǂݍ���
    &SWBase::LoadVilRS( $sow, $vil );

    $sow->{'html'} = SWHtml->new($sow);                                                      # HTML���[�h�̏�����
    $sow->{'http'}->outheader();                                                             # HTTP�w�b�_�̏o��
    $sow->{'html'}->outheader("���̏�� / $sow->{'query'}->{'vid'} $vil->{'vname'}");    # HTML�w�b�_�̏o��
    $sow->{'html'}->outcontentheader();

    my $vplcntstart = '';
    $vplcntstart = $vil->{'vplcntstart'} if ( $vil->{'vplcntstart'} > 0 );

    my $net    = $sow->{'html'}->{'net'};                                                    # Null End Tag
    my $amp    = $sow->{'html'}->{'amp'};
    my $atr_id = $sow->{'html'}->{'atr_id'};

    # �����y�у����N�\��
    print "<a $atr_id=\"top\">$sow->{'query'}->{'vid'} $vil->{'vname'}</a><br$net>\n";

    # �L�������\��
    if ( defined( $sow->{'curpl'}->{'uid'} ) ) {
        my $chrname  = $sow->{'curpl'}->getchrname();
        my $rolename = '';
        $rolename = "($sow->{'textrs'}->{'ROLENAME'}->[$sow->{'curpl'}->{'role'}])"
          if ( $sow->{'curpl'}->{'role'} > 0 );
        print "$chrname$rolename<br$net>\n";
    }

    # ���t�ʃ��O�ւ̃����N
    &SWHtmlMb::OutHTMLTurnNaviMb( $sow, $vil, 0 );

    my $pllist  = $vil->getpllist();
    my $lastcnt = $vil->{'vplcnt'} - @$pllist;
    if ( ( $vil->{'turn'} == 0 ) && ( $lastcnt > 0 ) ) {
        print <<"_HTML_";
���� $lastcnt �l�Q���ł��܂��B
<hr$net>
_HTML_
    }

    print <<"_HTML_";
�����̖��O<br$net>$vil->{'vname'}
<hr$net>
�����̐���<br$net>$vil->{'vcomment'}
<hr$net>
_HTML_

    if ( $vil->isepilogue() == 1 ) {
        print <<"_HTML_";
���쐬��<br$net>$vil->{'makeruid'}
<hr$net>
_HTML_
    }

    print <<"_HTML_";
���i�荞�݁F<br$net>
_HTML_

    #print "(�v�����[�O�͑ΏۊO)<br$net>\n"; if ($vil->{'turn'} == 0);

    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'pno'} = '';
    my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
    my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

    print "��������<br$net>\n";
    &OutHTMLSayFilterPlayersMb( $sow, $vil, 'live' );
    print "���]����<br$net>\n";
    &OutHTMLSayFilterPlayersMb( $sow, $vil, 'victim' );
    print "�����Y��<br$net>\n";
    &OutHTMLSayFilterPlayersMb( $sow, $vil, 'executed' );
    print "���ˑR����<br$net>\n";
    &OutHTMLSayFilterPlayersMb( $sow, $vil, 'suddendead' );

    print "<a href=\"$urlsow?$linkvalue\">����</a><br$net>\n";    #if ($vil->{'turn'} != 0);

    print <<"_HTML_";
<hr$net>

_HTML_

    if ( ( $vil->{'turn'} > 0 ) && ( $vil->isepilogue() == 0 ) ) {

        # �R�~�b�g��
        my $textrs       = $sow->{'textrs'};
        my $totalcommit  = &SWBase::GetTotalCommitID( $sow, $vil );
        my $nextcommitdt = '';
        if ( $totalcommit == 3 ) {
            $nextcommitdt = $sow->{'dt'}->cvtdtmb( $vil->{'nextcommitdt'} );
            $nextcommitdt = "<br$net>(" . $nextcommitdt . '�X�V�\��)' . "<br$net>";
        }

        print <<"_HTML_";
���R�~�b�g�󋵁F<br$net>$textrs->{'ANNOUNCE_TOTALCOMMIT'}->[$totalcommit]
$nextcommitdt<hr$net>

_HTML_
    }

    if ( $vil->{'turn'} == 0 ) {
        print <<"_HTML_";
������i�_�~�[���݁j<br$net>$vil->{'vplcnt'}�l
<hr$net>
_HTML_
    }
    else {
        my $plcnt = @$pllist;
        print <<"_HTML_";
���l���i�_�~�[���݁j<br$net>$plcnt�l
<hr$net>
_HTML_
    }

    if ( ( $vil->{'starttype'} eq 'wbbs' ) && ( $vil->{'turn'} == 0 ) ) {
        print <<"_HTML_";
���Œ�l��<br$net>$vplcntstart�l
<hr$net>
_HTML_
    }

    my $updatedt =
      sprintf( "%02d��%02d��", $vil->{'updhour'}, $vil->{'updminite'} );
    print <<"_HTML_";
���X�V����<br$net>$updatedt
<hr$net>
_HTML_

    my $interval = sprintf( '%02d����', $vil->{'updinterval'} * 24 );
    print <<"_HTML_";
���X�V�Ԋu<br$net>$interval
<hr$net>
_HTML_

    my $roleid = $sow->{'ROLEID'};
    my $roletabletext;

    print <<"_HTML_";
����E�z���F<br$net>$sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{$vil->{'roletable'}}
_HTML_

    if ( $vil->{'turn'} > 0 ) {

        # ��E�z���\��
        require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
        my $rolematrix = &SWSetRole::GetSetRoleTable( $sow, $vil, $vil->{'roletable'}, scalar(@$pllist) );
        $roletabletext = '';
        for ( $i = 1 ; $i < @$roleid ; $i++ ) {
            my $roleplcnt = $rolematrix->[$i];
            $roleplcnt++ if ( $i == $sow->{'ROLEID_VILLAGER'} );    # �_�~�[�L�����̕��P���₷
            if ( $roleplcnt > 0 ) {
                $roletabletext .= "$sow->{'textrs'}->{'ROLENAME'}->[$i]: $roleplcnt�l ";
            }
        }
        print "�i$roletabletext�j<br$net>\n";
    }
    elsif ( $vil->{'roletable'} eq 'custom' ) {

        # ��E�z���ݒ�\���i���R�ݒ莞�j
        $roletabletext = '';
        for ( $i = 1 ; $i < @$roleid ; $i++ ) {
            if ( $vil->{"cnt$roleid->[$i]"} > 0 ) {
                $roletabletext .= "$sow->{'textrs'}->{'ROLENAME'}->[$i]: $vil->{'cnt' . $roleid->[$i]}�l ";
            }
        }
        print "�i$roletabletext�j<br$net>\n";
    }
    print "<hr$net>\n";

    my %votecaption = (
        anonymity => '���L�����[',
        sign      => '�L�����[',
    );
    my $votetype = '----';
    if ( defined( $vil->{'votetype'} ) ) {
        $votetype = $votecaption{ $vil->{'votetype'} }
          if ( defined( $votecaption{ $vil->{'votetype'} } ) );
    }
    print <<"_HTML_";
�����[���@<br$net>$votetype
<hr$net>
_HTML_

    if ( $vil->{'turn'} == 0 ) {
        my $scraplimit = $sow->{'dt'}->cvtdtmb( $vil->{'scraplimitdt'} );
        $scraplimit = '�����p���Ȃ�' if ( $vil->{'scraplimitdt'} == 0 );
        print <<"_HTML_";
���p�������F<br$net>$scraplimit
<hr$net>

_HTML_
    }

    my @csidlist = split( '/', "$vil->{'csid'}/" );
    chomp(@csidlist);
    my $csidcaptions;
    foreach (@csidlist) {
        $sow->{'charsets'}->loadchrrs($_);
        $csidcaptions .= "$sow->{'charsets'}->{'csid'}->{$_}->{'CAPTION'} ";
    }

    print <<"_HTML_";
���o��l��<br$net>$csidcaptions
<hr$net>
�����������F<br$net>$sow->{'cfg'}->{'COUNTS_SAY'}->{$vil->{'saycnttype'}}->{'CAPTION'}
<hr$net>
���J�n���@�F<br$net>$sow->{'basictrs'}->{'STARTTYPE'}->{$vil->{'starttype'}}
<hr$net>
�����͌n�F<br$net>$sow->{'textrs'}->{'CAPTION'}
<hr$net>
_HTML_

    if ( $sow->{'cfg'}->{'ENABLED_RANDOMTARGET'} > 0 ) {
        my $randomtarget = '���[�E�\�͂̑ΏۂɁu�����_���v���܂߂Ȃ�';
        $randomtarget = '���[�E�\�͂̑ΏۂɁu�����_���v���܂߂�' if ( $vil->{'randomtarget'} > 0 );
        print <<"_HTML_";
�������_���F<br$net>$randomtarget
<hr$net>
_HTML_
    }

    my $noselrole = '��E��]�L��';
    $noselrole = '��E��]����' if ( $vil->{'noselrole'} > 0 );
    print <<"_HTML_";
����E��]�F<br$net>$noselrole
<hr$net>

_HTML_

    my $makersaymenu = '����';
    $makersaymenu = '�s��' if ( $vil->{'makersaymenu'} > 0 );
    print <<"_HTML_";
�������Ĕ����F<br$net>$makersaymenu
<hr$net>
_HTML_

    my $guestmenu = '����';
    $guestmenu = '�Ȃ�' if ( $vil->{'guestmenu'} > 0 );
    print <<"_HTML_";
���T�ώҔ����F<br$net>$guestmenu
<hr$net>
_HTML_

    my $entrustmode = '����';
    $entrustmode = '�s��' if ( $vil->{'entrustmode'} > 0 );
    print <<"_HTML_";
���ϔC�F<br$net>$entrustmode
<hr$net>
_HTML_

    my $showall = '����J';
    $showall = '���J' if ( $vil->{'showall'} > 0 );
    print <<"_HTML_";
���扺���J�F<br$net>$showall
<hr$net>
_HTML_

    my $rating = 'default';
    $rating = $vil->{'rating'} if ( $vil->{'rating'} ne '' );
    print <<"_HTML_";
���{�������F<br$net>$sow->{'cfg'}->{'RATING'}->{$rating}->{'CAPTION'}
<hr$net>

_HTML_

    my $noactlist = $sow->{'cfg'}->{'NOACTLIST'};
    my $noactmode = @$noactlist[ $vil->{'noactmode'} ];
    print <<"_HTML_";
��act/memo�F<br$net>$noactmode
<hr$net>
_HTML_

    my $nocandy = '����';
    $nocandy = '�Ȃ�' if ( $vil->{'nocandy'} > 0 );
    print <<"_HTML_";
�������F<br$net>$nocandy
<hr$net>
_HTML_

    my $nofreeact = '����';
    $nofreeact = '�Ȃ�' if ( $vil->{'nofreeact'} > 0 );
    print <<"_HTML_";
�����R���A�N�V�����F<br$net>$nofreeact
<hr$net>
_HTML_

    my $showid = '���J���Ȃ�';
    $showid = '���J����' if ( $vil->{'showid'} > 0 );
    print <<"_HTML_";
��ID���J�F<br$net>$showid
<hr$net>
_HTML_

    my $timestamp = '���S�\��';
    $timestamp = '�ȗ��\��' if ( $vil->{'timestamp'} > 0 );
    print <<"_HTML_";
�������\\���F<br$net>$timestamp
<hr$net>
_HTML_

    # ���t�ʃ��O�ւ̃����N
    &SWHtmlMb::OutHTMLTurnNaviMb( $sow, $vil, 1 );

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();    # HTML�t�b�^�̏o��
    $sow->{'http'}->outfooter();

    return;
}

#----------------------------------------
# �l�t�B���^�̐l�����̕\��
#----------------------------------------
sub OutHTMLSayFilterPlayersMb {
    my ( $sow, $vil, $livetype ) = @_;
    my $cfg = $sow->{'cfg'};
    my $net = $sow->{'html'}->{'net'};    # Null End Tag
    my $amp = $sow->{'html'}->{'amp'};

    my $pllist = $vil->getpllist();
    my @filterlist;
    foreach (@$pllist) {
        push( @filterlist, $_ ) if ( $_->{'live'} eq $livetype );
        if ( $livetype eq 'victim' ) {
            push( @filterlist, $_ )
              if ( ( $_->{'live'} eq 'cursed' )
                || ( $_->{'live'} eq 'rcursed' )
                || ( $_->{'live'} eq 'suicide' ) );
        }
    }

    @filterlist = sort {
            $a->{'deathday'} <=> $b->{'deathday'}
          ? $a->{'deathday'} <=> $b->{'deathday'}
          : $a->{'pno'} <=> $b->{'pno'}
    } @filterlist if ( $livetype ne 'live' );

    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'pno'} = '';
    my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
    my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

    foreach (@filterlist) {
        my $chrname = $_->getchrname();
        my $unit =
          $sow->{'basictrs'}->{'SAYTEXT'}->{ $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} }->{'COUNT_TYPE'} }
          ->{'UNIT_SAY'};
        my $restsay = $_->{'say'};
        $restsay = $_->{'gsay'} if ( $_->{'live'} ne 'live' );
        $restsay = $_->{'psay'} if ( $vil->{'turn'} == 0 );
        $restsay = $_->{'esay'} if ( $vil->isepilogue() != 0 );

        my $live = 'live';
        $live = $sow->{'curpl'}->{'live'}
          if ( defined( $sow->{'curpl'}->{'live'} ) );
        my $showid = "";
        $showid = " ($_->{'uid'})"
          if ( $vil->isepilogue() != 0
            || ( $vil->{'showid'} > 0 )
            || ( $sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'} ) );
        my $rolename = '';
        $rolename = " [$sow->{'textrs'}->{'ROLENAME'}->[$_->{'role'}]]"
          if ( $_->{'role'} > 0 );
        my $live = 'live';
        $live = $sow->{'curpl'}->{'live'}
          if ( defined( $sow->{'curpl'}->{'live'} ) );
        my $showall = "";
        $showall = " $rolename"
          if ( $vil->isepilogue() != 0
            || ( $vil->{'showall'} > 0 && $live ne 'live' )
            || ( $sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'} ) );

        #if ($vil->{'turn'} == 0) {
        #	print "$chrname";
        #} else {
        print "<a href=\"$urlsow?$linkvalue$amp"
          . "pno=$_->{'pno'}\">$chrname</a>$showid$showall [<a href=\"$urlsow?$linkvalue$amp"
          . "pno=$_->{'pno'}$amp"
          . "cmd=mbimg\">��</a>]";

        #}
        print " ($_->{'deathday'}d)" if ( $livetype ne 'live' );
        if (   ( $_->{'live'} eq 'live' )
            || ( $live ne 'live' )
            || ( $vil->isepilogue() != 0 ) )
        {
            print " �c$restsay$unit<br$net>\n";
        }
        else {
            print "<br$net>\n";
        }
    }

    return;
}

1;
