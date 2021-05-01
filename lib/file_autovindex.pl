package SWFileATVIndex;

#----------------------------------------
# 自動生成用データファイル制御
#----------------------------------------

#----------------------------------------
# 自動生成用データラベル
#----------------------------------------
sub GetATVIndexDataLabel {
    my @datalabel = ( 'vid', 'autoid', 'autonum', );
    return @datalabel;
}

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
    my ( $class, $sow ) = @_;
    my $self = { sow => $sow, };

    return bless( $self, $class );
}

#----------------------------------------
# 自動生成用データファイルを開く
#----------------------------------------
sub openatvindex {
    my $self     = shift;
    my $sow      = $self->{'sow'};
    my $fh       = \*ATVINDEX;
    my $filename = "$sow->{'cfg'}->{'FILE_ATVINDEX'}";

    # ファイルを開く
    my $file = SWFile->new( $self->{'sow'}, 'atvindex', $fh, $filename, $self );
    if ( !( -e $filename ) ) {
        $file->openfile( '>', '村一覧', '' );    # 新規作成
    }
    $file->openfile( '+<', '村一覧', '', );
    $self->{'file'} = $file;

    seek( $fh, 0, 0 );
    my @data = <$fh>;

    # データラベルの読み込み
    @data = ('<>') if ( @data == 0 );
    my $datalabel = shift(@data);
    my @datalabel = split( /<>/, $datalabel );
    @datalabel = $self->GetATVIndexDataLabel() if ( !defined( $datalabel[0] ) );

    # データの読み込み
    my $i       = 0;
    my $datacnt = @data;
    my @atvilist;
    my %atvi;
    while ( $i < $datacnt ) {
        my %atvindexsingle;
        chomp( $data[$i] );
        @atvindexsingle{@datalabel} = split( /<>/, $data[$i] );

        # 配列にセット
        $atvilist[$i] = \%atvindexsingle;
        $atvi{ $atvindexsingle{'autoid'} } = \%atvindexsingle;
        $i++;
    }
    $self->{'atvilist'} = \@atvilist;
    $self->{'atvi'}     = \%atvi;

    return \%atvindex;
}

#----------------------------------------
# 自動生成用データの配列を得る
#----------------------------------------
sub getatvilist {
    my $self = shift;
    return $self->{'atvilist'};
}

#----------------------------------------
# autoidで指定した自動生成用データを得る
#----------------------------------------
sub getatvindex {
    my ( $self, $autoid ) = @_;
    return $self->{'atvi'}->{$autoid};
}

#----------------------------------------
# 自動生成用データへ追加／書き換え
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
# 自動生成用データの書き込み
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
# 自動生成用データファイルを閉じる
#----------------------------------------
sub closeatvindex {
    my $self = shift;
    $self->{'file'}->closefile();
    return;
}

1;
