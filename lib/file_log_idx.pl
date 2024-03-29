package SWBoaLogIndex;

#----------------------------------------
# SW-Boa Log Index Driver
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
    my ( $class, $sow, $vil, $turn, $mode ) = @_;
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_hashlist.pl";

    my $self = {
        sow      => $sow,
        vil      => $vil,
        turn     => $turn,
        version  => ' 2.1',
        startpos => 0,
    };
    bless( $self, $class );

    # ログインデックスファイルの新規作成／開く
    my $fnamelogindex     = $self->getfnamelogindex();
    my @logindexdatalabel = $self->getlogindexdatalabel();
    $self->{'file'} = SWHashList->new(
        $sow, $fnamelogindex, \*LOGINDEX, 'logindex', \@logindexdatalabel,
        'ログインデックスデータ',
        "[vid=$self->{'vil'}->{'vid'}/turn=$self->{'turn'}]",
        $mode, $self->{'version'},
    );
    $self->{'file'}->read() if ( $mode == 0 );

    return $self;
}

#----------------------------------------
# ログインデックスデータをセットする
#----------------------------------------
sub set {
    my ( $self, $log ) = @_;

    my %logidx = (
        logid    => $log->{'logid'},
        mestype  => $log->{'mestype'},
        logsubid => $log->{'logsubid'},
        maskedid => $log->{'maskedid'},
        date     => $log->{'date'},
        uid      => $log->{'uid'},
        pos      => $log->{'pos'},
    );
    return \%logidx;
}

#----------------------------------------
# ログインデックスデータファイル名の取得
#----------------------------------------
sub getfnamelogindex {
    my $self = shift;

    my $datafile;
    if ( $self->{'vil'}->{'dir'} == 0 ) {
        $datafile = sprintf( "%s/%04d_%02d%s",
            $self->{'sow'}->{'cfg'}->{'DIR_VIL'},
            $self->{'vil'}->{'vid'},
            $self->{'turn'}, $self->{'sow'}->{'cfg'}->{'FILE_LOGINDEX'},
        );
    }
    else {
        $datafile = sprintf(
            "%s/%04d/%04d_%02d%s",
            $self->{'sow'}->{'cfg'}->{'DIR_VIL'},
            $self->{'vil'}->{'vid'},
            $self->{'vil'}->{'vid'},
            $self->{'turn'}, $self->{'sow'}->{'cfg'}->{'FILE_LOGINDEX'},
        );
    }

    return $datafile;
}

#----------------------------------------
# ログインデックスデータラベル
#----------------------------------------
sub getlogindexdatalabel {
    my $self = shift;
    my @datalabel;

    # Version 2.0
    @datalabel = ( 'logid', 'mestype', 'logsubid', 'maskedid', 'date', 'uid', 'pos', );

    return @datalabel;
}

1;
