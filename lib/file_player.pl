package SWPlayer;

#----------------------------------------
# �v���C���[�f�[�^
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
    my ( $class, $sow ) = @_;
    my $self = { sow => $sow, };

    return bless( $self, $class );
}

#----------------------------------------
# �v���C���[�f�[�^���x��
#----------------------------------------
sub getdatalabel {
    my @datalabel = (
        'uid',          'cid',          'csid',         'jobname',     'role',       'rolesubid',
        'selrole',      'live',         'deathday',     'say',         'tsay',       'wsay',
        'spsay',        'bsay',         'gsay',         'psay',        'esay',       'say_act',
        'actaddpt',     'saidcount',    'saidpoint',    'countinfosp', 'countthink', 'vote',
        'target',       'target2',      'entrust',      'bonds',       'lovers',     'commit',
        'entrieddt',    'limitentrydt', 'lastwritepos', 'history',     'modified',   'savedraft',
        'draftmestype', 'draftmspace',  'draftloud',    'lsay'
    );

    return @datalabel;
}

#----------------------------------------
# �v���C���[�f�[�^�̐V�K�쐬
#----------------------------------------
sub createpl {
    my ( $self, $uid ) = @_;

    $self->{'uid'}          = $uid;
    $self->{'live'}         = 'live';
    $self->{'deathday'}     = -1;
    $self->{'role'}         = -1;
    $self->{'rolesubid'}    = -1;
    $self->{'jobname'}      = '';
    $self->{'vote'}         = 0;
    $self->{'entrust'}      = 0;
    $self->{'target'}       = 0;
    $self->{'target2'}      = 0;
    $self->{'bonds'}        = '', $self->{'lovers'} = '', $self->{'history'} = '';
    $self->{'saidcount'}    = 0;
    $self->{'saidpoint'}    = 0;
    $self->{'countinfosp'}  = 0;
    $self->{'countthink'}   = 0;
    $self->{'delete'}       = 0;
    $self->{'entrieddt'}    = $self->{'sow'}->{'time'};
    $self->{'limitentrydt'} = 0;
    $self->{'modified'}     = 0;
    $self->{'savedraft'}    = '';
    $self->{'draftmestype'} = 0;
    $self->{'draftmspace'}  = 0;
    $self->{'draftloud'}    = 0;
    return;
}

#----------------------------------------
# �v���C���[�f�[�^�̓ǂݍ���
#----------------------------------------
sub readpl {
    my ( $self, $datalabel, $data ) = @_;
    $self->createpl('');
    @$self{@$datalabel} = split( /<>/, $data );

    my @datalabelnew = $self->getdatalabel();
    foreach (@datalabelnew) {
        if ( defined $self->{$_} && defined $self->{'sow'}->{'DATATEXT_NONE'} ) {
            $self->{$_} = '' if ( $self->{$_} eq $self->{'sow'}->{'DATATEXT_NONE'} );
        }
        else {
            $self->{$_} = '' unless defined $self->{$_};
        }
    }

    $self->{'delete'} = 0;

    return;
}

#----------------------------------------
# �v���C���[�f�[�^�̏�������
#----------------------------------------
sub writepl {
    my ( $self, $fh ) = @_;
    my $none = $self->{'sow'}->{'DATATEXT_NONE'};

    my @datalabel = $self->getdatalabel();
    foreach (@datalabel) {
        $self->{$_} = $none if ( $self->{$_} eq '' );
    }

    print $fh join( "<>", map { $self->{$_} } @datalabel ) . "<>\n";
    foreach (@datalabel) {
        $self->{$_} = '' if ( $self->{$_} eq $none );
    }
}

#----------------------------------------
# ������������
#----------------------------------------
sub setsaycount {
    my $self   = shift;
    my $saycnt = $self->{'sow'}->{'cfg'}->{'COUNTS_SAY'}->{ $self->{'vil'}->{'saycnttype'} };

    $self->{'say'}         = $saycnt->{'MAX_SAY'};
    $self->{'tsay'}        = $saycnt->{'MAX_TSAY'};
    $self->{'wsay'}        = $saycnt->{'MAX_WSAY'};
    $self->{'spsay'}       = $saycnt->{'MAX_SPSAY'};
    $self->{'bsay'}        = $saycnt->{'MAX_BSAY'};
    $self->{'gsay'}        = $saycnt->{'MAX_GSAY'};
    $self->{'lsay'}        = $saycnt->{'MAX_LSAY'};
    $self->{'psay'}        = $saycnt->{'MAX_PSAY'};
    $self->{'esay'}        = $saycnt->{'MAX_ESAY'};
    $self->{'say_act'}     = $saycnt->{'MAX_SAY_ACT'};
    $self->{'saidcount'}   = 0;
    $self->{'saidpoint'}   = 0;
    $self->{'actaddpt'}    = $saycnt->{'MAX_ADDSAY'};
    $self->{'countinfosp'} = 0, $self->{'countthink'} = 0,

      $self->{'commit'} = 0;
    $self->{'entrust'}      = 0;
    $self->{'lastwritepos'} = -1;

    return;
}

#----------------------------------------
# ��������
#----------------------------------------
sub chargesaycount {
    my $self   = shift;
    my $saycnt = $self->{'sow'}->{'cfg'}->{'COUNTS_SAY'}->{ $self->{'vil'}->{'saycnttype'} };

    $self->{'say'}      += $saycnt->{'MAX_SAY'};
    $self->{'tsay'}     += $saycnt->{'MAX_TSAY'};
    $self->{'wsay'}     += $saycnt->{'MAX_WSAY'};
    $self->{'spsay'}    += $saycnt->{'MAX_SPSAY'};
    $self->{'bsay'}     += $saycnt->{'MAX_BSAY'};
    $self->{'gsay'}     += $saycnt->{'MAX_GSAY'};
    $self->{'lsay'}     += $saycnt->{'MAX_LSAY'};
    $self->{'psay'}     += $saycnt->{'MAX_SAY'};       # �v�����[�O�̃`���[�W�ʂ͐i�s���Ɠ����ɂ��Ă݂�
    $self->{'esay'}     += $saycnt->{'MAX_ESAY'};
    $self->{'say_act'}  += $saycnt->{'MAX_SAY_ACT'};
    $self->{'actaddpt'} += $saycnt->{'MAX_ADDSAY'};

    return;
}

#----------------------------------------
# �������𑝂₷�i�����j
#----------------------------------------
sub addsaycount {
    my $self   = shift;
    my $saycnt = $self->{'sow'}->{'cfg'}->{'COUNTS_SAY'}->{ $self->{'vil'}->{'saycnttype'} };
    $self->{'say'}  += $saycnt->{'ADD_SAY'};
    $self->{'psay'} += $saycnt->{'ADD_SAY'};
    $self->{'esay'} += $saycnt->{'ADD_SAY'};
    return;
}

#----------------------------------------
# ���[�^�\�͑Ώی��̃��X�g���擾
#----------------------------------------
sub gettargetlist {
    my ( $self, $cmd, $targetpno ) = @_;
    my $sow = $self->{'sow'};
    my $vil = $self->{'vil'};
    my @targetlist;

    my $livepllist = $vil->getlivepllist();
    my $livepl;
    foreach $livepl (@$livepllist) {

        # �L���[�s�b�h�̔\�͍s�g�ȊO�͎������g�͏��O
        if ( $cmd eq 'vote' ) {
            next if ( $livepl->{'uid'} eq $self->{'uid'} );
        }
        else {
            next if ( ( $livepl->{'uid'} eq $self->{'uid'} ) && ( $self->{'role'} != $sow->{'ROLEID_CUPID'} ) );
        }

        # �s�N�V�[�^�L���[�s�b�h�̑Ώۂɂ̓_�~�[�L�������܂܂Ȃ�
        next
          if ( ( ( $self->{'role'} == $sow->{'ROLEID_TRICKSTER'} ) || ( $self->{'role'} == $sow->{'ROLEID_CUPID'} ) )
            && ( $livepl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'} ) );

        # ���ΏۂƓ����ꍇ�͏��O
        next
          if ( ( defined($targetpno) ) && ( $livepl->{'pno'} == $targetpno ) );

        if ( ( $self->iswolf() > 0 ) && ( $cmd ne 'vote' ) ) {

            # �l�T/���T/�q�T�͏P���Ώۂ��珜�O
            next if ( $livepl->iswolf() > 0 );

            # �P���ڂ̏P���Ώۂ̓_�~�[�L�����̂�
            next
              if ( ( $vil->{'turn'} == 1 )
                && ( $livepl->{'uid'} ne $sow->{'cfg'}->{'USERID_NPC'} ) );
        }

        my %target = (
            chrname => $livepl->getchrname(),
            pno     => $livepl->{'pno'},
        );
        push( @targetlist, \%target );
    }

    return \@targetlist;
}

#----------------------------------------
# ���[�^�\�͑Ώی��̃��X�g���擾
# �i���܂����E�����_������j
#----------------------------------------
sub gettargetlistwithrandom {
    my ( $self, $cmd ) = @_;
    my $sow = $self->{'sow'};
    my $vil = $self->{'vil'};
    $targetlist = $self->gettargetlist($cmd);

    # ���܂����i�P���Ώۂ̂݁j
    if (   ( $cmd ne 'vote' )
        && ( $self->iswolf() > 0 )
        && ( $vil->{'turn'} > 1 ) )
    {
        my %target = (
            chrname => $sow->{'textrs'}->{'UNDEFTARGET'},
            pno     => $sow->{'TARGETID_TRUST'},
        );
        unshift( @$targetlist, \%target );
    }

    # �����_��
    my $randomtarget = 1;
    $randomtarget = 0 if ( $vil->{'randomtarget'} == 0 );    # ���ݒ肪�����_���֎~
    $randomtarget = 0
      if ( ( $cmd ne 'vote' )
        && ( $self->iswolf() > 0 )
        && ( $vil->{'turn'} == 1 ) );                        # �P���ڂ̏P���Ώۂɂ̓����_�����܂܂Ȃ�
    if ( $randomtarget > 0 ) {
        my %randomtarget = (
            chrname => '�����_��',
            pno     => $sow->{'TARGETID_RANDOM'},
        );
        unshift( @$targetlist, \%randomtarget );
    }

    return $targetlist;
}

#----------------------------------------
# �^�����J��ǉ�����
#----------------------------------------
sub addbond {
    my ( $self, $target ) = @_;

    my $isbond = 0;
    my @bonds  = split( '/', $self->{'bonds'} . '/' );
    foreach (@bonds) {
        $isbond = 1 if ( $_ == $target );
    }

    # �J��ǉ�
    if ( $isbond == 0 ) {
        $self->{'bonds'} .= '/' if ( $self->{'bonds'} ne '' );
        $self->{'bonds'} .= $target;
    }
}

#----------------------------------------
# ���l��ǉ�����
#----------------------------------------
sub addlovers {
    my ( $self, $target ) = @_;

    my $islover = 0;
    my @lovers  = split( '/', $self->{'lovers'} . '/' );
    foreach (@lovers) {
        $islover = 1 if ( $_ == $target );
    }

    # �J��ǉ�
    if ( $islover == 0 ) {
        $self->{'lovers'} .= '/' if ( $self->{'lovers'} ne '' );
        $self->{'lovers'} .= $target;
    }
}

#----------------------------------------
# ��]��E��ύX����
#----------------------------------------
sub changeselrole {
    my ( $self, $role ) = @_;

    $self->{'selrole'} = $role;
}

#----------------------------------------
# �L�����̖��O���擾����
#----------------------------------------
sub getchrname {
    my $self = shift;
    return $self->{'sow'}->{'charsets'}->getchrname( $self->{'csid'}, $self->{'cid'}, $self->{'jobname'} );
}

#----------------------------------------
# �L�������̓��������擾����
#----------------------------------------
sub getchrnameinitial {
    my $self = shift;
    return $self->{'sow'}->{'charsets'}->getchrnameinitial( $self->{'csid'}, $self->{'cid'} );
}

#----------------------------------------
# �����E���ǂ����𒲂ׂ�
#----------------------------------------
sub iswhisper {
    my $self = shift;
    $sow = $self->{'sow'};

    my $result = 0;
    $result = $self->iswolf();
    $result = 1 if ( $self->{'role'} == $sow->{'ROLEID_CPOSSESS'} );
    $result = 1 if ( $self->{'role'} == $sow->{'ROLEID_SYMPATHY'} );
    $result = 1 if ( $self->{'role'} == $sow->{'ROLEID_WEREBAT'} );
    return $result;
}

#----------------------------------------
# �l�T���ǂ����𒲂ׂ�
#----------------------------------------
sub iswolf {
    my $self = shift;
    $sow = $self->{'sow'};

    my $result = 0;
    $result = 1 if ( $self->{'role'} == $sow->{'ROLEID_WOLF'} );
    $result = 1 if ( $self->{'role'} == $sow->{'ROLEID_CWOLF'} );
    $result = 1 if ( $self->{'role'} == $sow->{'ROLEID_INTWOLF'} );
    return $result;
}

#----------------------------------------
# �n���X�^�[�l�Ԃ��ǂ����𒲂ׂ�
#----------------------------------------
sub ishamster {
    my $self = shift;
    $sow = $self->{'sow'};

    my $result = 0;
    $result = 1 if ( $self->{'role'} == $sow->{'ROLEID_HAMSTER'} );
    $result = 1 if ( $self->{'role'} == $sow->{'ROLEID_WEREBAT'} );
    $result = 1 if ( $self->{'role'} == $sow->{'ROLEID_TRICKSTER'} );
    return $result;
}

#----------------------------------------
# ���l���ǂ����𒲂ׂ�
#----------------------------------------
sub islovers {
    my $self = shift;
    $sow = $self->{'sow'};

    my $result = 0;

    # �L���[�s�b�h�͗��l�w�c�����A���l�ł͂Ȃ�
    # $result = 1 if ( $self->{'role'} == $sow->{'ROLEID_CUPID'} );

    # �L���[�s�b�h�ɂ���J�����ꍇ�͗��l
    $result = 1 if ( $self->{'lovers'} ne '' );

    return $result;
}

#----------------------------------------
# ���s�̎擾
#----------------------------------------
sub iswin {
    my $self = shift;
    $sow = $self->{'sow'};
    $vil = $self->{'vil'};

    # ����
    my $win = 2;

    # ���� ���l�ł͂Ȃ��ꍇ�A���̖�E�̏���������s��
    $win = 1
      if ( ( $self->islovers() == 0 ) && ( $vil->{'winner'} == $sow->{'ROLECAMP'}[ $self->{'role'} ] ) );

    # ���l���� ���l�̏ꍇ�A���l����������s��
    $win = 1 if ( ( $self->islovers() > 0 ) && ( $vil->{'winner'} == 5 ) );

    # ��������
    $win = 0 if ( $vil->{'winner'} == 0 );

    return $win;
}

1;
