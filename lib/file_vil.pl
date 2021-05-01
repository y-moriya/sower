package SWFileVil;

#----------------------------------------
# ���f�[�^�t�@�C������
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
    my ( $class, $sow, $vid ) = @_;
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_player.pl";

    my %pl;
    my @pllist;
    my $self = {
        sow    => $sow,
        vid    => $vid,
        pl     => \%pl,
        pllist => \@pllist,
        dir    => $sow->{'cfg'}->{'ENABLED_DIRVIL'},
    };
    my %csidlist = ();
    $sow->{'csidlist'} = \%csidlist;

    return bless( $self, $class );
}

#----------------------------------------
# ���f�[�^�̍쐬
#----------------------------------------
sub createvil {
    my $self = shift;
    my $sow  = $self->{'sow'};

    my $filename;
    if ( $self->{'dir'} == 0 ) {
        $filename = &GetFNameVil( $self->{'sow'}, $self->{'vid'} );
    }
    else {
        my $dirname = &GetFNameDirVid( $sow, $self->{'vid'} );
        umask(0);
        mkdir( $dirname, $sow->{'cfg'}->{'PERMITION_MKDIR'} );
        open( INDEXHTML, ">$dirname/index.html" );
        close(INDEXHTML);
        $filename = &GetFNameVilDirVid( $self->{'sow'}, $self->{'vid'} );
    }

    my $fh   = \*VIL;
    my $file = SWFile->new( $self->{'sow'}, 'vil', $fh, $filename, $self );
    $file->openfile( '>', '���f�[�^', "[vid=$self->{'vid'}]", );
    $self->{'file'} = $file;
    $self->closevil();

    $self->{'turn'}          = 0;
    $self->{'updateddt'}     = $sow->{'time'};
    $self->{'nextupdatedt'}  = $sow->{'time'};
    $self->{'nextchargedt'}  = $sow->{'time'};
    $self->{'nextcommitdt'}  = $sow->{'time'};
    $self->{'epilogue'}      = 9999;
    $self->{'winner'}        = 0;
    $self->{'useless'}       = 0;
    $self->{'modifiedsay'}   = 0;
    $self->{'modifiedwsay'}  = 0;
    $self->{'modifiedgsay'}  = 0;
    $self->{'modifiedspsay'} = 0;
    $self->{'modifiedbsay'}  = 0;
    $self->{'cntmemo'}       = 0;
    $self->{'emulated'}      = 0;
    %{ $self->{'pl'} }      = ();
    @{ $self->{'pllist'} }  = ();
    %{ $sow->{'csidlist'} } = ();
    $sow->{'turn'} = 0;

    return;
}

#----------------------------------------
# �_�~�[�̑��f�[�^�̍쐬
#----------------------------------------
sub createdummyvil {
    my $self = shift;
    my $sow  = $self->{'sow'};

    $self->{'turn'}         = 0;
    $self->{'updateddt'}    = $sow->{'time'};
    $self->{'nextupdatedt'} = $sow->{'time'};
    $self->{'nextchargedt'} = $sow->{'time'};
    $self->{'nextcommitdt'} = $sow->{'time'};
    $self->{'epilogue'}     = 9999;
    $self->{'winner'}       = 0;
    $self->{'randomtarget'} = 0;
    $self->{'showid'}       = 0;
    $self->{'emulated'}     = 1;
    %{ $self->{'pl'} }      = ();
    @{ $self->{'pllist'} }  = ();
    %{ $sow->{'csidlist'} } = ();
    $sow->{'turn'} = 0;

    return;
}

#----------------------------------------
# ���f�[�^�̓ǂݍ���
#----------------------------------------
sub readvil {
    my $self = shift;
    my $sow  = $self->{'sow'};
    my $filename;
    my $dirname = &GetFNameDirVid( $sow, $self->{'vid'} );
    if ( -e $dirname ) {
        $self->{'dir'} = 1;
        $filename = &GetFNameVilDirVid( $self->{'sow'}, $self->{'vid'} );
    }
    else {
        $self->{'dir'} = 0;
        $filename = &GetFNameVil( $sow, $self->{'vid'} );
    }

    # �t�@�C�����J��
    my $fh   = \*VIL;
    my $file = SWFile->new( $self->{'sow'}, 'vil', $fh, $filename, $self );
    $file->openfile( '+<', '���f�[�^', "[vid=$self->{'vid'}]", );
    $self->{'file'} = $file;

    seek( $fh, 0, 0 );
    my @data = <$fh>;

    # ���f�[�^�̓ǂݍ���
    my $villabel = shift(@data);
    my @villabel = split( /<>/, $villabel );
    @villabel = &GetVilDataLabel() if ( $villabel[0] eq '' );
    @$self{@villabel} = split( /<>/, shift(@data) );

    my @villabelnew = &GetVilDataLabel();

    # �ڍs�p�R�[�h
    foreach (@villabelnew) {
        $self->{$_} = 0 if ( !defined( $self->{$_} ) );
    }
    $self{'useless'} = 0;

    $self->{'entrypwd'} = '' if ( !defined( $self->{'entrypwd'} ) );
    $self->{'entrypwd'} = ''
      if ( $self->{'entrypwd'} eq $self->{'sow'}->{'DATATEXT_NONE'} );

    my $pllabel = shift(@data);
    chomp($pllabel);
    my @pllabel = split( /<>/, $pllabel );
    %{ $self->{'pl'} }      = ();
    @{ $self->{'pllist'} }  = ();
    %{ $sow->{'csidlist'} } = ();

    my $i       = 0;
    my $datacnt = @data;
    while ( $i < $datacnt ) {
        chomp( $data[$i] );
        if ( $data[$i] ne '' ) {
            my $plsingle = SWPlayer->new($sow);
            $plsingle->readpl( \@pllabel, $data[$i] );
            $self->addpl($plsingle);
        }
        $i++;
    }

    # �Q�ƒ��̑��ԍ��ƃ��O���t�ԍ����Z�b�g
    if ( defined( $sow->{'query'}->{'turn'} ) ) {
        $sow->{'turn'} = $sow->{'query'}->{'turn'};
    }
    else {
        $sow->{'turn'} = $self->{'turn'};

#		$sow->{'turn'} = $self->{'epilogue'} if ($self->{'epilogue'} < $self->{'turn'});
    }

    # �J�����g�v���C���[�i���O�C�����̃v���C���[�j
    $sow->{'curpl'} = $self->getpl( $sow->{'uid'} )
      if ( $self->checkentried() >= 0 );

    $self->{'emulated'} = 0;

    $self->closevil();

    return;
}

#----------------------------------------
# ���f�[�^�̏�������
#----------------------------------------
sub writevil {
    my $self   = shift;
    my $sow    = $self->{'sow'};
    my $pl     = $self->{'pl'};
    my $pllist = $self->{'pllist'};

    #	my $fh = $self->{'file'}->{'filehandle'};
    #	truncate($fh, 0);
    #	seek($fh, 0, 0);

    my $fh        = \*TMP;
    my $tempfname = sprintf( "%s/%04d%s_%s_%s",
        $sow->{'cfg'}->{'DIR_VIL'},
        $self->{'vid'}, $ENV{'REMOTE_PORT'}, $$, $sow->{'cfg'}->{'FILE_VIL'},
    );
    open( $fh, ">$tempfname" )
      || $sow->{'debug'}->raise( $sow->{'APLOG_WARNING'},
        "���f�[�^�̏������݂Ɏ��s���܂����B", "cannot write vil data." );

    $self->{'entrypwd'} = $self->{'sow'}->{'DATATEXT_NONE'}
      if ( $self->{'entrypwd'} eq '' );
    my @villabel = &GetVilDataLabel();
    print $fh join( "<>", @villabel ) . "<>\n";
    print $fh join( "<>", map { $self->{$_} } @villabel ) . "<>\n";

    if ( @$pllist > 0 ) {
        my @pllabel = $pllist->[0]->getdatalabel();
        print $fh join( "<>", @pllabel ) . "<>\n";
        foreach (@$pllist) {
            next if ( $_->{'delete'} > 0 );    # �폜
            $_->writepl($fh);
        }
    }
    close($fh);

    my $filename;
    my $dirname = &GetFNameDirVid( $sow, $self->{'vid'} );
    if ( -e $dirname ) {
        $self->{'dir'} = 1;
        $filename = &GetFNameVilDirVid( $self->{'sow'}, $self->{'vid'} );
    }
    else {
        $self->{'dir'} = 0;
        $filename = &GetFNameVil( $sow, $self->{'vid'} );
    }
    rename( $tempfname, $filename );

    $self->{'entrypwd'} = ''
      if ( $self->{'entrypwd'} eq $self->{'sow'}->{'DATATEXT_NONE'} );
}

#----------------------------------------
# ���f�[�^�̍폜
#----------------------------------------
sub deletevil {
    my $self = shift;
    my $sow  = $self->{'sow'};

    my $dirname = &GetFNameDirVid( $sow, $self->{'vid'} );
    my @files;
    opendir( DIR, $dirname );
    foreach ( readdir(DIR) ) {
        next if ( ( $_ eq '.' ) || ( $_ eq '..' ) );
        push( @files, "$dirname/$_" );
    }
    closedir(DIR);
    unlink(@files);
    rmdir($dirname);
}

#----------------------------------------
# ���f�[�^�����
#----------------------------------------
sub closevil {
    my $self = shift;
    $self->{'file'}->closefile();
}

#----------------------------------------
# �v���C���[�ǉ�
#----------------------------------------
sub addpl {
    my ( $self, $plsingle ) = @_;

    my $pllist = $self->{'pllist'};

    $plsingle->{'vil'}                                    = $self;
    $self->{'pl'}->{ $plsingle->{'uid'} }                 = $plsingle;
    $plsingle->{'pno'}                                    = @$pllist;
    $pllist->[ $plsingle->{'pno'} ]                       = $plsingle;
    $self->{'sow'}->{'csidlist'}->{ $plsingle->{'csid'} } = 1;

    return;
}

#----------------------------------------
# �P�����̐�уf�[�^��ǉ�
#----------------------------------------
sub addrecord {
    my $self = shift;
    my $sow  = $self->{'sow'};

    return if ( !( -w $sow->{'cfg'}->{'DIR_RECORD'} ) );    # �O�̂���

    require "$sow->{'cfg'}->{'DIR_LIB'}/file_record.pl";

    my $pllist = $self->getpllist();
    foreach (@$pllist) {
        my $record     = SWUserRecord->new( $sow, $_->{'uid'} );
        my $indexno    = -1;
        my $recordlist = $record->{'file'}->getlist();
        my $i;
        for ( $i = 0 ; $i < @$recordlist ; $i++ ) {
            $indexno = $i if ( $recordlist->[$i]->{'vid'} eq $self->{'vid'} );
        }
        if ( @$recordlist == 0 ) {
            $record->add( $self, $_ );
        }
        elsif ( $indexno >= 0 ) {
            $record->update( $self, $_, $indexno );
        }
        else {
            $record->append( $self, $_ );
        }
        $record->close();
    }

    return;
}

#----------------------------------------
# �P�����̐�уf�[�^��ǉ�
#----------------------------------------
sub addappend {
    my $self = shift;
    my $sow  = $self->{'sow'};

    return if ( !( -w $sow->{'cfg'}->{'DIR_RECORD'} ) );    # �O�̂���

    require "$sow->{'cfg'}->{'DIR_LIB'}/file_record.pl";

    my $pllist = $self->getpllist();
    foreach (@$pllist) {
        my $record = SWUserRecord->new( $sow, $_->{'uid'}, 1 );
        $record->append( $self, $_ );
        $record->close();
    }

    return;
}

#----------------------------------------
# �����̃L���v�V�����𓾂�
#----------------------------------------
sub getinfocap {
    my ( $self, $infocap ) = @_;
    my $sow = $self->{'sow'};
    my $resultcap;
    my $pllist = $self->getpllist();

    if ( $infocap eq 'lastcnt' ) {
        my $lastcnt = $self->{'vplcnt'} - @$pllist;
        if ( $lastcnt > 0 ) {
            $resultcap = "���� $lastcnt �l�Q���ł��܂��B";
        }
    }
    elsif ( $infocap eq 'vplcnt' ) {
        $resultcap = "$self->{'vplcnt'}�l �i�_�~�[�L�������܂ށj";
    }
    elsif ( $infocap eq 'plcnt' ) {
        my $plcnt = @$pllist;
        $resultcap = "$plcnt�l �i�_�~�[�L�������܂ށj";
    }
    elsif ( $infocap eq 'vplcntstart' ) {
        $resultcap = "$self->{'vplcntstart'}�l";
    }
    elsif ($infocap eq 'updatedt'
        || $infocap eq 'updhour'
        || $infocap eq 'updminite' )
    {
        $resultcap =
          sprintf( "%02d��%02d��", $self->{'updhour'}, $self->{'updminite'} );
    }
    elsif ( $infocap eq 'updinterval' ) {
        $resultcap = sprintf( '%02d����', $self->{'updinterval'} * 24 );
    }
    elsif ( $infocap eq 'roletable' ) {
        $resultcap =
          $sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{ $self->{'roletable'} };
    }
    elsif ( $infocap eq 'roletable2' ) {
        my $roleid = $sow->{'ROLEID'};
        my $roletabletext;
        if ( $self->{'turn'} > 0 ) {

            # ��E�z���\��
            require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
            my $rolematrix =
              &SWSetRole::GetSetRoleTable( $sow, $self, $self->{'roletable'},
                scalar(@$pllist) );
            $roletabletext = '';
            for ( $i = 1 ; $i < @$roleid ; $i++ ) {
                my $roleplcnt = $rolematrix->[$i];
                $roleplcnt++
                  if ( $i == $sow->{'ROLEID_VILLAGER'} );    # �_�~�[�L�����̕��P���₷
                if ( $roleplcnt > 0 ) {
                    $roletabletext .=
                      "$sow->{'textrs'}->{'ROLENAME'}->[$i]: $roleplcnt�l ";
                }
            }
            $resultcap = "�i$roletabletext�j\n";

        }
        elsif ( $self->{'roletable'} eq 'custom' ) {

            # ��E�z���ݒ�\���i���R�ݒ莞�j
            $roletabletext = '';
            for ( $i = 1 ; $i < @$roleid ; $i++ ) {
                if ( $self->{"cnt$roleid->[$i]"} > 0 ) {
                    $roletabletext .=
"$sow->{'textrs'}->{'ROLENAME'}->[$i]: $self->{'cnt' . $roleid->[$i]}�l ";
                }
            }
            $resultcap = "�i$roletabletext�j\n";
        }

    }
    elsif ( $infocap eq 'votetype' ) {
        my %votecaption = (
            anonymity => '���L�����[',
            sign      => '�L�����[',
        );
        $resultcap = $votecaption{ $self->{'votetype'} };

    }
    elsif ( $infocap eq 'scraplimit' ) {
        $resultcap = $sow->{'dt'}->cvtdt( $self->{'scraplimitdt'} );
        $resultcap = '�����p���Ȃ�' if ( $self->{'scraplimitdt'} == 0 );

    }
    elsif ( $infocap eq 'csidcaptions' ) {
        my @csidlist = split( '/', "$self->{'csid'}/" );
        chomp(@csidlist);
        foreach (@csidlist) {
            $sow->{'charsets'}->loadchrrs($_);
            $resultcap .= "$sow->{'charsets'}->{'csid'}->{$_}->{'CAPTION'} ";
        }

    }
    elsif ( $infocap eq 'saycnttype' ) {
        $resultcap =
          $sow->{'cfg'}->{'COUNTS_SAY'}->{ $self->{'saycnttype'} }->{'CAPTION'};

    }
    elsif ( $infocap eq 'starttype' ) {
        $resultcap =
          $sow->{'basictrs'}->{'STARTTYPE'}->{ $self->{'starttype'} };

    }
    elsif ( $infocap eq 'trsid' ) {
        $resultcap = $sow->{'textrs'}->{'CAPTION'};

    }
    elsif ( $infocap eq 'randomtarget' ) {
        $resultcap = '���[�E�\�͂̑ΏۂɁu�����_���v���܂߂Ȃ�';
        $resultcap = '���[�E�\�͂̑ΏۂɁu�����_���v���܂߂�' if ( $self->{'randomtarget'} > 0 );

    }
    elsif ( $infocap eq 'noselrole' ) {
        $resultcap = '�L��';
        $resultcap = '����' if ( $self->{'noselrole'} > 0 );

    }
    elsif ( $infocap eq 'makersaymenu' || $infocap eq 'entrustmode' ) {
        $resultcap = "����";
        $resultcap = "�s����" if ( $self->{$infocap} > 0 );

    }
    elsif ( $infocap eq 'showall' ) {
        $resultcap = "����J";
        $resultcap = "���J" if ( $self->{'showall'} > 0 );

    }
    elsif ( $infocap eq 'rating' ) {
        $resultcap =
          $sow->{'cfg'}->{'RATING'}->{ $self->{'rating'} }->{'CAPTION'};

    }
    elsif ( $infocap eq 'noactmode' ) {
        my $noactlist = $sow->{'cfg'}->{'NOACTLIST'};
        my $noactlist = $sow->{'cfg'}->{'NOACTLIST'};
        $resultcap = @$noactlist[ $self->{'noactmode'} ];

    }
    elsif ( $infocap eq 'nocandy' || $infocap eq 'nofreeact' ) {
        $resultcap = "����";
        $resultcap = "�Ȃ�" if ( $self->{$infocap} > 0 );

    }
    elsif ( $infocap eq 'showid' ) {
        $resultcap = "�Ȃ�";
        $resultcap = "����" if ( $self->{$infocap} > 0 );

    }
    elsif ( $infocap eq 'timestamp' ) {
        $resultcap = "���S�\\��";
        $resultcap = "�ȗ��\\��" if ( $self->{'timestamp'} > 0 );

    }
    elsif ( $infocap eq 'guestmenu' ) {
        $resultcap = "����";
        $resultcap = "�Ȃ�" if ( $self->{$infocap} > 0 );
    }

    return $resultcap;
}

#----------------------------------------
# �u�Q�����̑��v�f�[�^�̍X�V
#----------------------------------------
sub updateentriedvil {
    my ( $self, $playing ) = @_;
    my $sow = $self->{'sow'};

    my $pllist = $self->getpllist();
    foreach (@$pllist) {
        my $user = SWUser->new($sow);
        $user->writeentriedvil( $_->{'uid'}, $self->{'vid'}, $_->getchrname(),
            $playing );
    }

    return;
}

#----------------------------------------
# �w�肵��uid�̃v���C���[�f�[�^�𓾂�
#----------------------------------------
sub getpl {
    my ( $self, $uid ) = @_;
    return $self->{'pl'}->{$uid};
}

#----------------------------------------
# �w�肵��uid�̃v���C���[�f�[�^���X�V
#----------------------------------------
sub changepl {
    my ( $self, $uid, $plsingle ) = @_;
    $self->{'pl'}->{$uid} = $plsingle;
    $self->{'pllist'} => [ $plsingle->{'pno'} ];

}

#----------------------------------------
# �w�肵���ԍ��̃v���C���[�f�[�^�𓾂�
#----------------------------------------
sub getplbypno {
    my ( $self, $pno ) = @_;
    return $self->{'pllist'}->[$pno];
}

#----------------------------------------
# �v���C���[�f�[�^�̔z��𓾂�
#----------------------------------------
sub getpllist {
    my $self = shift;
    return $self->{'pllist'};
}

#----------------------------------------
# �������̃v���C���[�f�[�^�̔z��𓾂�
#----------------------------------------
sub getlivepllist {
    my $self = shift;
    my @livepllist;
    foreach ( @{ $self->{'pllist'} } ) {
        push( @livepllist, $_ ) if ( $_->{'live'} eq 'live' );
    }
    return \@livepllist;
}

#----------------------------------------
# �A�N�Z�X���Ă���v���C���[���Q���ς݂��ǂ����𓾂�
#----------------------------------------
sub checkentried {
    my $self = shift;
    my $pno  = $self->{'pl'}->{ $self->{'sow'}->{'uid'} }->{'pno'};
    if ( defined($pno) ) {
        return $pno;
    }
    else {
        return -1;
    }
}

#----------------------------------------
# ������������
#----------------------------------------
sub setsaycountall {
    my $self = $_[0];

    foreach ( @{ $self->{'pllist'} } ) {
        $_->setsaycount();
    }

    return;
}

#----------------------------------------
# ��������
#----------------------------------------
sub chargesaycountall {

    # �s�v
    return;
}

#----------------------------------------
# �R�~�b�g�ς݂̐l���𓾂�
#----------------------------------------
sub getcommitedpl {
    my ( $self, $cmd ) = @_;
    my $sow = $self->{'sow'};

    my $getlivepllist = $self->getlivepllist();
    my $commitedpl    = 0;
    foreach (@$getlivepllist) {
        $commitedpl++ if ( $_->{'commit'} > 0 );
    }

    return $commitedpl;
}

#----------------------------------------
# �����G�s���[�O�ɓ����Ă���^�I�����Ă��邩�ǂ���
#----------------------------------------
sub isepilogue {
    my $self   = shift;
    my $result = 0;
    $result = 1 if ( $self->{'turn'} >= $self->{'epilogue'} );

    return $result;
}

#----------------------------------------
# �����v�����[�O���ł��邩
#----------------------------------------
sub isprologue {
    my $self   = shift;
    my $result = 0;
    $result = 1 if ( $self->{'turn'} == 0 );
    return $result;
}

#----------------------------------------
# ���̏�Ԃ��擾
#----------------------------------------
sub getvstatus {
    my $self = shift;
    my $sow  = $self->{'sow'};

    my $draw   = 0;
    my $pllist = $self->getpllist();
    foreach (@$pllist) {
        $draw = 1 if ( $_->{'live'} eq 'live' );
    }
    $draw = 0 if ( $self->{'winner'} != 0 );

    my $result = $sow->{'VSTATUSID_PRO'};
    $result = $sow->{'VSTATUSID_PLAY'} if ( $self->{'turn'} > 0 );
    if ( $self->{'turn'} == $self->{'epilogue'} ) {
        $result = $sow->{'VSTATUSID_EP'};
        $result = $sow->{'VSTATUSID_SCRAP'} if ( $draw > 0 );
    }
    if ( $self->{'turn'} > $self->{'epilogue'} ) {
        $result = $sow->{'VSTATUSID_END'};
        $result = $sow->{'VSTATUSID_SCRAPEND'} if ( $draw > 0 );
    }

    return $result;
}

#----------------------------------------
# ���f�[�^���x��
#----------------------------------------
sub GetVilDataLabel {
    my @datalabel = (
        'vname',
        'vcomment',
        'csid',
        'trsid',
        'roletable',
        'updhour',
        'updminite',
        'updinterval',
        'entrylimit',
        'rating',
        'vplcnt',
        'vplcntstart',
        'saycnttype',
        'votetype',
        'starttype',
        'randomtarget',
        'noselrole',
        'makersaymenu',
        'guestmenu',
        'entrustmode',
        'showall',
        'noactmode',
        'nocandy',
        'nofreeact',
        'showid',
        'timestamp',
        'entrypwd',
        'makeruid',
        'turn',
        'nextcommitdt',
        'scraplimitdt',
        'epilogue',
        'nextupdatedt',
        'nextchargedt',
        'updateddt',
        'winner',
        'useless',
        'cntvillager',     # ���l
        'cntwolf',         # �l�T
        'cntseer',         # �肢�t
        'cntmedium',       # ��\��
        'cntpossess',      # ���l
        'cntguard',        # ��l
        'cntfm',           # ���L��
        'cnthamster',      # �n���X�^�[�l��
        'cntcpossess',     # �b�����l
        'cntstigma',       # ������
        'cntfanatic',      # ���M��
        'cntsympathy',     # ����
        'cntwerebat',      # �R�E�����l��
        'cntcwolf',        # ���T
        'cntintwolf',      # �q�T
        'cnttrickster',    # �s�N�V�[
        'modifiedsay',
        'modifiedwsay',
        'modifiedgsay',
        'modifiedspsay',
        'modifiedbsay',
        'cntmemo',
    );
    return @datalabel;
}

#----------------------------------------
# ���f�[�^�t�@�C�����̎擾
#----------------------------------------
sub GetFNameVil {
    my ( $sow, $vid ) = @_;
    $vid = 0 if ( $vid eq '' );

    my $datafile = sprintf( "%s/%04d_%s",
        $sow->{'cfg'}->{'DIR_VIL'},
        $vid, $sow->{'cfg'}->{'FILE_VIL'},
    );
    return $datafile;
}

#----------------------------------------
# ���ԍ��f�B���N�g�����̎擾
#----------------------------------------
sub GetFNameDirVid {
    my ( $sow, $vid ) = @_;
    $vid = 0 if ( $vid eq '' );

    my $datafile = sprintf( "%s/%04d", $sow->{'cfg'}->{'DIR_VIL'}, $vid, );
    return $datafile;
}

#----------------------------------------
# ���f�[�^�t�@�C�����̎擾
# �i���ԍ��f�B���N�g�����j
#----------------------------------------
sub GetFNameVilDirVid {
    my ( $sow, $vid ) = @_;
    $vid = 0 if ( $vid eq '' );

    my $datafile = sprintf( "%s/%04d/%04d_%s",
        $sow->{'cfg'}->{'DIR_VIL'},
        $vid, $vid, $sow->{'cfg'}->{'FILE_VIL'},
    );
    return $datafile;
}

1;
