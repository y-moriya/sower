package SWFileATVIndex;

#----------------------------------------
# ���������p�f�[�^�t�@�C������
#----------------------------------------

#----------------------------------------
# ���������p�f�[�^���x��
#----------------------------------------
sub GetATVIndexDataLabel {
    my @datalabel = ( 'vid', 'autoid', 'autonum', );
    return @datalabel;
}

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
    my ( $class, $sow ) = @_;
    my $self = { sow => $sow, };

    return bless( $self, $class );
}

#----------------------------------------
# ���������p�f�[�^�t�@�C�����J��
#----------------------------------------
sub openatvindex {
    my $self     = shift;
    my $sow      = $self->{'sow'};
    my $fh       = \*ATVINDEX;
    my $filename = "$sow->{'cfg'}->{'FILE_ATVINDEX'}";

    # �t�@�C�����J��
    my $file = SWFile->new( $self->{'sow'}, 'atvindex', $fh, $filename, $self );
    if ( !( -e $filename ) ) {
        $file->openfile( '>', '���ꗗ', '' );    # �V�K�쐬
    }
    $file->openfile( '+<', '���ꗗ', '', );
    $self->{'file'} = $file;

    seek( $fh, 0, 0 );
    my @data = <$fh>;

    # �f�[�^���x���̓ǂݍ���
    @data = ('<>') if ( @data == 0 );
    my $datalabel = shift(@data);
    my @datalabel = split( /<>/, $datalabel );
    @datalabel = $self->GetATVIndexDataLabel() if ( !defined( $datalabel[0] ) );

    # �f�[�^�̓ǂݍ���
    my $i       = 0;
    my $datacnt = @data;
    my @atvilist;
    my %atvi;
    while ( $i < $datacnt ) {
        my %atvindexsingle;
        chomp( $data[$i] );
        @atvindexsingle{@datalabel} = split( /<>/, $data[$i] );

        # �z��ɃZ�b�g
        $atvilist[$i] = \%atvindexsingle;
        $atvi{ $atvindexsingle{'autoid'} } = \%atvindexsingle;
        $i++;
    }
    $self->{'atvilist'} = \@atvilist;
    $self->{'atvi'}     = \%atvi;

    return \%atvindex;
}

#----------------------------------------
# ���������p�f�[�^�̔z��𓾂�
#----------------------------------------
sub getatvilist {
    my $self = shift;
    return $self->{'atvilist'};
}

#----------------------------------------
# autoid�Ŏw�肵�����������p�f�[�^�𓾂�
#----------------------------------------
sub getatvindex {
    my ( $self, $autoid ) = @_;
    return $self->{'atvi'}->{$autoid};
}

#----------------------------------------
# ���������p�f�[�^�֒ǉ��^��������
#----------------------------------------
sub addatvindex {
    my ( $self, $vid, $autoid ) = @_;
    my %atvindexsingle;

    if ( exists $self->{'atvi'}->{$autoid} ) {
        $atvindexsingle = $self->getatvindex($autoid);
        $atvindexsingle->{'vid'} = $vid;
        $atvindexsingle->{'autonum'}++;
    }
    else {
        %atvindexsingle = (
            vid     => $vid,
            autoid  => $autoid,
            autonum => 1,
        );

        my $atvilist = $self->{'atvilist'};
        unshift( @$atvilist, \%atvindexsingle );
    }

    return;
}

#----------------------------------------
# ���������p�f�[�^�̏�������
#----------------------------------------
sub writeatvindex {
    my $self = shift;

    my $fh = $self->{'file'}->{'filehandle'};
    truncate( $fh, 0 );
    seek( $fh, 0, 0 );

    my @datalabel = $self->GetATVIndexDataLabel();

    print $fh join( "<>", @datalabel ) . "<>\n";

    my $atvilist       = $self->{'atvilist'};
    my $atvindexsingle = '';
    foreach $atvindexsingle (@$atvilist) {
        print $fh join( "<>", map { $atvindexsingle->{$_} } @datalabel ) . "<>\n";
    }
}

#----------------------------------------
# ���������p�f�[�^�t�@�C�������
#----------------------------------------
sub closeatvindex {
    my $self = shift;
    $self->{'file'}->closefile();
    return;
}

1;
