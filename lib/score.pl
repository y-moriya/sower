package SWScore;

#----------------------------------------
# 人狼譜出力関連（暫定）
#----------------------------------------

# http://wolfbbs.jp/%BF%CD%CF%B5BBS%C9%E8.html 参照。
# ver/mikari 0.2（略譜機械可読形式）ベース。
# ただし夜出力のみ。
# 複数キャラセットには未対応。

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
    my ( $class, $sow, $vil, $mode ) = @_;
    my $self = {
        sow => $sow,
        vil => $vil,
        vid => $vil->{'vid'},
    };
    bless( $self, $class );

    my $filename = $self->getfnamescore();
    my $modeid   = '+<';
    $modeid = '>' if ( $mode > 0 );

    my $fh = \*SCORE;
    if ( ( $mode > 0 ) || ( -e $filename ) ) {
        my $file =
          SWFile->new( $self->{'sow'}, 'score', $fh, $filename, $self );
        $file->openfile( $modeid, '人狼譜データ', "[vid=$self->{'vid'}]", );
        $self->{'file'} = $file;
    }

    return $self;
}

#----------------------------------------
# 人狼譜の出力
#----------------------------------------
sub output {
    my $self = shift;
    my $sow  = $self->{'sow'};

    my $fh = $self->{'file'}->{'filehandle'};
    seek( $fh, 0, 0 );

    print "//jinro_bbs_score: SOW$self->{'vid'}\n";
    foreach (<$fh>) {
        print $_;
    }
    print "//jinro_bbs_score_end;\n";

    return;
}

#----------------------------------------
# 人狼譜データを閉じる
#----------------------------------------
sub close {
    my $self = shift;
    $self->{'file'}->closefile() if ( defined( $self->{'file'} ) );
}

#----------------------------------------
# 人狼譜データの書き込み（開始時）
#----------------------------------------
sub writestart {
    my $self = shift;
    my $sow  = $self->{'sow'};
    my $vil  = $self->{'vil'};
    my $fh   = $self->{'file'}->{'filehandle'};
    seek( $fh, 0, 2 );

    my @roles;
    my $i;
    my $pllist = $vil->getpllist();
    foreach (@$pllist) {
        my @rolepl;
        $roles[ $_->{'role'} ] = \@rolepl
          if ( !defined( $roles[ $_->{'role'} ] ) );
        push( @{ $roles[ $_->{'role'} ] }, $_ );
    }

    print $fh "1d: ";
    my $roleshortname = $sow->{'textrs'}->{'ROLESHORTNAME'};
    my $roleid        = $sow->{'ROLEID'};
    for ( $i = 1 ; $i < @$roleid ; $i++ ) {
        next if ( !defined( $roles[$i] ) );
        my $rolepl = $roles[$i];
        next if ( @$rolepl == 0 );
        print $fh "$roleshortname->[$i]:";
        foreach (@$rolepl) {
            print $fh $_->getchrnameinitial();
        }
        print $fh " ";
    }
    print $fh "\n";

}

#----------------------------------------
# 人狼譜データの書き込み（更新時）
#----------------------------------------
sub writeupdate {
    my ( $self, $turn, $suddendeath, $execute, $seer, $guard, $kill ) = @_;
    my $sow = $self->{'sow'};
    my $fh  = $self->{'file'}->{'filehandle'};
    seek( $fh, 0, 2 );

    print $fh $turn . "d: ";

    $self->writeability( $suddendeath, '※' );    # 突然死
    $self->writeability( $execute,     '▼' );    # 処刑
    $self->writeability( $seer,        '●' );    # 占い
    $self->writeability( $kill,        '◆' );    # 護衛
    $self->writeability( $guard,       '■' );    # 護衛

    print $fh "\n";
}

#----------------------------------------
# 人狼譜データの書き込み（役職）
#----------------------------------------
sub writeability {
    my ( $self, $abilitypl, $abilitymark ) = @_;
    my $fh = $self->{'file'}->{'filehandle'};

    if ( ( defined($abilitypl) ) && ( @$abilitypl > 0 ) ) {
        print $fh $abilitymark;
        foreach (@$abilitypl) {
            print $fh $_->getchrnameinitial();
        }
        print $fh " ";
    }
}

#----------------------------------------
# 人狼譜データファイル名の取得
#----------------------------------------
sub getfnamescore {
    my $self = shift;
    my $sow  = $self->{'sow'};
    my $vid  = $self->{'vid'};

    $vid = 0 if ( $vid eq '' );

    my $datafile;
    if ( $self->{'vil'}->{'dir'} == 0 ) {
        $datafile = sprintf( "%s/%04d_%s",
            $sow->{'cfg'}->{'DIR_VIL'},
            $vid, $sow->{'cfg'}->{'FILE_SCORE'},
        );
    }
    else {
        $datafile = sprintf( "%s/%04d/%04d_%s",
            $sow->{'cfg'}->{'DIR_VIL'},
            $vid, $vid, $sow->{'cfg'}->{'FILE_SCORE'},
        );
    }
    return $datafile;
}

1;
