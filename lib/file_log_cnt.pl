package SWBoaLogCount;

#----------------------------------------
# SW-Boa Log Count Driver
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
    my ( $class, $sow, $vil, $turn, $mode ) = @_;
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_hash.pl";

    my $self = {
        sow      => $sow,
        vil      => $vil,
        turn     => $turn,
        version  => ' 2.0',
        startpos => 0,
    };
    bless( $self, $class );

    # ログカウントファイルの新規作成／開く
    my $fnamelogcnt     = $self->getfnamelogcnt();
    my @logcntdatalabel = $self->getlogcntdatalabel();
    $self->{'file'} = SWFileHash->new(
        $sow,              $fnamelogcnt, \*LOGCNT,                        'logcnt',
        \@logcntdatalabel, 'ログカウントデータ',  "[vid=$self->{'vil'}->{'vid'}]", $mode,
        $self->{'version'},
    );
    $self->{'file'}->read() if ( $mode == 0 );

    return $self;
}

#----------------------------------------
# ログインデックスデータファイル名の取得
#----------------------------------------
sub getfnamelogcnt {
    my $self = shift;
    if ( $self->{'vil'}->{'dir'} == 0 ) {
        $datafile = sprintf( "%s/%04d_%s",
            $self->{'sow'}->{'cfg'}->{'DIR_VIL'},
            $self->{'vil'}->{'vid'},
            $self->{'sow'}->{'cfg'}->{'FILE_LOGCNT'},
        );
    }
    else {
        $datafile = sprintf( "%s/%04d/%04d_%s",
            $self->{'sow'}->{'cfg'}->{'DIR_VIL'},
            $self->{'vil'}->{'vid'},
            $self->{'vil'}->{'vid'},
            $self->{'sow'}->{'cfg'}->{'FILE_LOGCNT'},
        );
    }
    return $datafile;
}

#----------------------------------------
# ログカウントデータラベル
#----------------------------------------
sub getlogcntdatalabel {
    my $self = shift;
    my @datalabel;

    # Version 2.0
    @datalabel = (
        'countundef',  'countinfo',  'countinfosp', 'countque',   'countsay',      'countthink',
        'countwolf',   'countgrave', 'countmaker',  'countadmin', 'countsympathy', 'countwerebat',
        'countsayact', 'countguest', 'countlover'
    );

    return @datalabel;
}

1;
