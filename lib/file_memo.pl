package SWSnake;

#----------------------------------------
# SWBBS Memo Driver Library 'SW-Snake'
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
    my ( $class, $sow, $vil, $turn, $mode ) = @_;
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo_data.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_memo_idx.pl";

    my $self = {
        sow      => $sow,
        vil      => $vil,
        turn     => $turn,
        version  => ' 1.0',
        startpos => 0,
    };
    bless( $self, $class );

    # メモファイルの新規作成／開く
    $self->{'memo'} = SWSnakeMemo->new( $sow, $vil, $turn, $mode );
    if ( $sow->{'query'}->{'cmd'} eq 'restmemo' ) {

        # メモインデックスファイルの新規作成／開く
        $self->{'memoindex'} = SWSnakeMemoIndex->new( $sow, $vil, $turn, 1 );
    }

    # メモインデックスファイルの新規作成／開く
    $self->{'memoindex'} = SWSnakeMemoIndex->new( $sow, $vil, $turn, $mode );

    return $self;
}

#----------------------------------------
# ファイルを閉じる
#----------------------------------------
sub close {
    my $self = shift;

    $self->{'memo'}->{'file'}->close();
    $self->{'memoindex'}->{'file'}->close();
}

#----------------------------------------
# メモデータの読み込み
#----------------------------------------
sub read {
    my ( $self, $pos ) = @_;
    my $data = $self->{'memo'}->{'file'}->read($pos);

    $data->{'log'} = ''
      if ( $data->{'log'} eq $self->{'sow'}->{'DATATEXT_NONE'} );

    return $data;
}

#----------------------------------------
# メモデータの追加
#----------------------------------------
sub add {
    my ( $self, $memo ) = @_;
    my $sow = $self->{'sow'};
    $memo->{'log'} = $sow->{'DATATEXT_NONE'} if ( $memo->{'log'} eq '' );

    $self->setip($memo);
    $self->{'memo'}->{'file'}->add($memo);
    $self->addmemoidx($memo);

    $memo->{'log'} = '' if ( $memo->{'log'} eq $sow->{'DATATEXT_NONE'} );
}

#----------------------------------------
# メモデータの更新
#----------------------------------------
sub update {
    my ( $self, $memo, $indexno ) = @_;
    my $sow = $self->{'sow'};
    $memo->{'log'} = $sow->{'DATATEXT_NONE'} if ( $memo->{'log'} eq '' );

    $self->{'memo'}->{'file'}->update($memo);
    my $memoidx = $self->{'memoindex'}->set($memo);
    $self->{'memoindex'}->{'file'}->update( $memoidx, $indexno );
    $memo->{'log'} = '' if ( $memo->{'log'} eq $sow->{'DATATEXT_NONE'} );
}

#----------------------------------------
# インデックスデータの追加
#----------------------------------------
sub addmemoidx {
    my ( $self, $memo ) = @_;
    my $memoidx = $self->{'memoindex'}->set($memo);
    $self->{'memoindex'}->{'file'}->add($memoidx);
    return;
}

#----------------------------------------
# IPアドレスのセット
#----------------------------------------
sub setip {
    my ( $self, $data ) = @_;
    my $sow = $self->{'sow'};

    $data->{'remoteaddr'}  = '';
    $data->{'fowardedfor'} = '';
    $data->{'agent'}       = '';

    $data->{'remoteaddr'} = $ENV{'REMOTE_ADDR'}
      if ( defined( $ENV{'REMOTE_ADDR'} ) );
    $data->{'fowardedfor'} = $ENV{'HTTP_X_FORWARDED_FOR'}
      if ( defined( $ENV{'HTTP_X_FORWARDED_FOR'} ) );
    $data->{'agent'} = $ENV{'HTTP_USER_AGENT'}
      if ( defined( $ENV{'HTTP_USER_AGENT'} ) );

    $data->{'remoteaddr'} = $sow->{'DATATEXT_NONE'}
      if ( $data->{'remoteaddr'} eq '' );
    $data->{'fowardedfor'} = $sow->{'DATATEXT_NONE'}
      if ( $data->{'fowardedfor'} eq '' );
    $data->{'agent'} = $sow->{'DATATEXT_NONE'} if ( $data->{'agent'} eq '' );

    return;
}

#----------------------------------------
# メモ全体の取得（インデックス配列）
#----------------------------------------
sub getmemolist {
    my $self  = shift;
    my $sow   = $self->{'sow'};
    my $query = $sow->{'query'};

    my $list = $self->{'memoindex'}->{'file'}->getlist();
    if ( $query->{'cmd'} eq 'memo' ) {

        # 最新のものだけ抽出
        my @newlogs = ();
        my %uids    = ();
        my $i;

        for ( $i = $#$list ; $i >= 0 ; $i-- ) {
            my $plsingle = $self->{'vil'}->getpl( $list->[$i]->{'uid'} );
            next if ( !defined( $plsingle->{'uid'} ) );
            if ( !defined( $uids{ $list->[$i]->{'uid'} } ) ) {
                next
                  if ( ( $plsingle->{'entrieddt'} > $list->[$i]->{'date'} )
                    && ( $plsingle->{'entrieddt'} != 0 ) );
                unshift( @newlogs, $list->[$i] );
                $uids{ $list->[$i]->{'uid'} } = 1;
            }
        }
        $list = \@newlogs;
    }

    return $list;
}

#----------------------------------------
# インデックスデータの再構築
#----------------------------------------
sub restructure {
    my $self     = shift;
    my $memofile = $self->{'memo'}->{'file'};
    $self->{'memoindex'}->{'file'}->clear();

    my $pos = $memofile->{'startpos'};
    my $log = $memofile->read($pos);
    while ( defined( $log->{'uid'} ) ) {
        $self->addmemoidx($log);
        $pos = $log->{'nextpos'};
        $log = $memofile->read($pos);
    }
}

#----------------------------------------
# 表示するメモの取得（インデックス配列）
#----------------------------------------
sub getmemo {
    my ( $self, $maxrow ) = @_;
    my $sow   = $self->{'sow'};
    my $query = $sow->{'query'};
    my %rows  = (
        rowover => 0,
        start   => 0,
        end     => 0,
    );

    # 検索モードのセット
    my $mode = '';
    my $skip = 0;
    if ( $query->{'logid'} ne '' ) {
        if ( $query->{'move'} eq 'next' ) {
            $mode = 'next';
        }
        elsif ( $query->{'move'} eq 'prev' ) {

            # 「前」移動の場合、基準ログIDまでスキップ
            $mode = 'prev';
            $skip = 1;
        }
        else {
            # 直接指定の場合、基準ログIDまでスキップ
            $mode = 'logid';
            $skip = 1;
        }
    }

    # 検索
    my ( $logs, $rowover, $firstlog, $lastlog );
    if (   ( $sow->{'query'}->{'move'} eq 'first' )
        || ( $sow->{'query'}->{'move'} eq 'page' )
        || ( $maxrow < 0 ) )
    {
        # 順方向探索
        ( $logs, $logkeys, $rowover, $firstlog ) = $self->GetVLogsForward( $mode, $skip, $maxrow );
        if ( $firstlog >= 0 ) {
            $rows{'start'} = 1
              if ( ( defined( $logs->[0] ) )
                && ( $logs->[0]->{'indexno'} == $firstlog ) );
            $rows{'end'} = 1 if ( $rowover == 0 );
        }
    }
    else {
        # 逆方向探索
        ( $logs, $logkeys, $rowover, $lastlog ) = $self->GetVLogsReverse( $mode, $skip, $maxrow );
        if ( $lastlog >= 0 ) {
            $rows{'start'} = 1 if ( $rowover == 0 );
            $rows{'end'} = 1
              if ( ( $#$logs >= 0 )
                && ( $logs->[$#$logs]->{'indexno'} == $lastlog ) );
        }
    }
    $rows{'rowover'} = $rowover;

    return ( $logs, $logkeys, \%rows );
}

#----------------------------------------
# ログの取得（順方向探索）
#----------------------------------------
sub GetVLogsForward {
    my ( $self, $mode, $skip, $maxrow ) = @_;
    my $sow   = $self->{'sow'};
    my $query = $sow->{'query'};
    my $i;
    my @logs;
    my %logkeys;
    my $rowcount = 0;
    my $rowover  = 0;
    my $firstlog = -1;
    my $list     = $self->getmemolist();

    for ( $i = 0 ; $i < @$list ; $i++ ) {
        my $memoidx = $list->[$i];

        # 先頭のメモ番号
        $firstlog = $memoidx->{'indexno'} if ( $firstlog < 0 );
        if ( ( $rowcount >= $maxrow ) && ( $maxrow > 0 ) ) {

            # 指定行数を超えたらループから抜ける
            $rowover = 1;
            last;
        }

        last
          if ( ( $mode eq 'logid' )
            && ( $sow->{'outmode'} ne 'mb' )
            && ( $skip == 0 ) );

        if (   ( $mode eq 'logid' )
            && ( $memoidx->{'logid'} eq $query->{'logid'} ) )
        {
            $skip = 0;
        }

        if ( $skip == 0 ) {

            # ログインデックスを登録
            push( @logs, $memoidx );
            $logkeys{ $memoidx->{'logid'} } = $memoidx->{'indexno'};
            $rowcount++;    # アクションは行数に数えない
        }

        if ( ( $rowcount > $maxrow ) && ( $maxrow > 0 ) ) {

            # 行数がオーバーした場合は削る
            my $dellog = shift(@logs);
            $logkeys{ $dellog->{'logid'} } = -1;
            $rowcount = $maxrow;
        }
    }

    return ( \@logs, \%logkeys, $rowover, $firstlog );
}

#----------------------------------------
# ログの取得（逆方向探索）
#----------------------------------------
sub GetVLogsReverse {
    my ( $self, $mode, $skip, $maxrow ) = @_;
    my $sow   = $self->{'sow'};
    my $query = $sow->{'query'};
    my $i;
    my @logs;
    my %logkeys;
    my $rowcount = 0;
    my $rowover  = 0;
    my $lastlog  = -1;
    my $list     = $self->getmemolist();

    for ( $i = $#$list ; $i >= 0 ; $i-- ) {
        my $memoidx = $list->[$i];
        my $logid   = $memoidx->{'logid'};

        if ( ( $mode eq 'next' ) && ( $logid eq $query->{'logid'} ) ) {

            # 「次」移動の場合は基準ログIDに辿り着いた時点でループから抜ける
            $rowover = 1;
            last;
        }

        # 末尾のメモログ番号
        $lastlog = $memoidx->{'indexno'} if ( $lastlog < 0 );

        if (   ( $rowcount >= $maxrow )
            && ( $maxrow > 0 )
            && ( $mode ne 'next' ) )
        {
            # 指定行数を超えたらループから抜ける
            $rowover = 1;
            last;
        }

        last
          if ( ( $mode eq 'logid' )
            && ( $sow->{'outmode'} ne 'mb' )
            && ( $skip == 0 ) );

        if ( ( $mode eq 'logid' ) && ( $logid eq $query->{'logid'} ) ) {

            # ログID直接指定処理
            $skip = 0;
        }

        if ( $skip == 0 ) {

            # ログインデックスを登録
            unshift( @logs, $memoidx );
            $logkeys{ $memoidx->{'logid'} } = $memoidx->{'indexno'};
            $rowcount++;
        }

        if ( ( $rowcount > $maxrow ) && ( $maxrow > 0 ) ) {

            # 行数がオーバーした場合は削る
            my $dellog = pop(@logs);
            $logkeys{ $dellog->{'logid'} } = -1;
            $rowcount = $maxrow;
        }

        if ( ( $mode eq 'prev' ) && ( $logid eq $query->{'logid'} ) ) {

            # 「前」移動の処理
            $skip = 0;
        }
    }

    return ( \@logs, \%logkeys, $rowover, $lastlog );
}

#----------------------------------------
# 指定したプレイヤーの最新メモを取得
#----------------------------------------
sub getnewmemo {
    my ( $self, $curpl ) = @_;
    my $logs = $self->{'memoindex'}->{'file'}->getlist();
    my $i;
    my $memo = { log => '', };
    for ( $i = $#$logs ; $i >= 0 ; $i-- ) {
        next if ( $curpl->{'uid'} ne $logs->[$i]->{'uid'} );
        next if ( $curpl->{'csid'} ne $logs->[$i]->{'csid'} );
        next if ( $curpl->{'cid'} ne $logs->[$i]->{'cid'} );
        next
          if ( ( $curpl->{'entrieddt'} > $logs->[$i]->{'date'} )
            && ( $curpl->{'entrieddt'} != 0 ) );
        $memo = $self->read( $logs->[$i]->{'pos'} );
        last;
    }

    return $memo;
}

1;
