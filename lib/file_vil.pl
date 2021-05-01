package SWFileVil;

#----------------------------------------
# 村データファイル制御
#----------------------------------------

#----------------------------------------
# コンストラクタ
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
# 村データの作成
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
    $file->openfile( '>', '村データ', "[vid=$self->{'vid'}]", );
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
# ダミーの村データの作成
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
# 村データの読み込み
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

    # ファイルを開く
    my $fh   = \*VIL;
    my $file = SWFile->new( $self->{'sow'}, 'vil', $fh, $filename, $self );
    $file->openfile( '+<', '村データ', "[vid=$self->{'vid'}]", );
    $self->{'file'} = $file;

    seek( $fh, 0, 0 );
    my @data = <$fh>;

    # 村データの読み込み
    my $villabel = shift(@data);
    my @villabel = split( /<>/, $villabel );
    @villabel = &GetVilDataLabel() if ( $villabel[0] eq '' );
    @$self{@villabel} = split( /<>/, shift(@data) );

    my @villabelnew = &GetVilDataLabel();

    # 移行用コード
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

    # 参照中の村番号とログ日付番号をセット
    if ( defined( $sow->{'query'}->{'turn'} ) ) {
        $sow->{'turn'} = $sow->{'query'}->{'turn'};
    }
    else {
        $sow->{'turn'} = $self->{'turn'};

#		$sow->{'turn'} = $self->{'epilogue'} if ($self->{'epilogue'} < $self->{'turn'});
    }

    # カレントプレイヤー（ログイン中のプレイヤー）
    $sow->{'curpl'} = $self->getpl( $sow->{'uid'} )
      if ( $self->checkentried() >= 0 );

    $self->{'emulated'} = 0;

    $self->closevil();

    return;
}

#----------------------------------------
# 村データの書き込み
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
        "村データの書き込みに失敗しました。", "cannot write vil data." );

    $self->{'entrypwd'} = $self->{'sow'}->{'DATATEXT_NONE'}
      if ( $self->{'entrypwd'} eq '' );
    my @villabel = &GetVilDataLabel();
    print $fh join( "<>", @villabel ) . "<>\n";
    print $fh join( "<>", map { $self->{$_} } @villabel ) . "<>\n";

    if ( @$pllist > 0 ) {
        my @pllabel = $pllist->[0]->getdatalabel();
        print $fh join( "<>", @pllabel ) . "<>\n";
        foreach (@$pllist) {
            next if ( $_->{'delete'} > 0 );    # 削除
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
# 村データの削除
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
# 村データを閉じる
#----------------------------------------
sub closevil {
    my $self = shift;
    $self->{'file'}->closefile();
}

#----------------------------------------
# プレイヤー追加
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
# １村分の戦績データを追加
#----------------------------------------
sub addrecord {
    my $self = shift;
    my $sow  = $self->{'sow'};

    return if ( !( -w $sow->{'cfg'}->{'DIR_RECORD'} ) );    # 念のため

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
# １村分の戦績データを追加
#----------------------------------------
sub addappend {
    my $self = shift;
    my $sow  = $self->{'sow'};

    return if ( !( -w $sow->{'cfg'}->{'DIR_RECORD'} ) );    # 念のため

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
# 村情報のキャプションを得る
#----------------------------------------
sub getinfocap {
    my ( $self, $infocap ) = @_;
    my $sow = $self->{'sow'};
    my $resultcap;
    my $pllist = $self->getpllist();

    if ( $infocap eq 'lastcnt' ) {
        my $lastcnt = $self->{'vplcnt'} - @$pllist;
        if ( $lastcnt > 0 ) {
            $resultcap = "あと $lastcnt 人参加できます。";
        }
    }
    elsif ( $infocap eq 'vplcnt' ) {
        $resultcap = "$self->{'vplcnt'}人 （ダミーキャラを含む）";
    }
    elsif ( $infocap eq 'plcnt' ) {
        my $plcnt = @$pllist;
        $resultcap = "$plcnt人 （ダミーキャラを含む）";
    }
    elsif ( $infocap eq 'vplcntstart' ) {
        $resultcap = "$self->{'vplcntstart'}人";
    }
    elsif ($infocap eq 'updatedt'
        || $infocap eq 'updhour'
        || $infocap eq 'updminite' )
    {
        $resultcap =
          sprintf( "%02d時%02d分", $self->{'updhour'}, $self->{'updminite'} );
    }
    elsif ( $infocap eq 'updinterval' ) {
        $resultcap = sprintf( '%02d時間', $self->{'updinterval'} * 24 );
    }
    elsif ( $infocap eq 'roletable' ) {
        $resultcap =
          $sow->{'textrs'}->{'CAPTION_ROLETABLE'}->{ $self->{'roletable'} };
    }
    elsif ( $infocap eq 'roletable2' ) {
        my $roleid = $sow->{'ROLEID'};
        my $roletabletext;
        if ( $self->{'turn'} > 0 ) {

            # 役職配分表示
            require "$sow->{'cfg'}->{'DIR_LIB'}/setrole.pl";
            my $rolematrix =
              &SWSetRole::GetSetRoleTable( $sow, $self, $self->{'roletable'},
                scalar(@$pllist) );
            $roletabletext = '';
            for ( $i = 1 ; $i < @$roleid ; $i++ ) {
                my $roleplcnt = $rolematrix->[$i];
                $roleplcnt++
                  if ( $i == $sow->{'ROLEID_VILLAGER'} );    # ダミーキャラの分１増やす
                if ( $roleplcnt > 0 ) {
                    $roletabletext .=
                      "$sow->{'textrs'}->{'ROLENAME'}->[$i]: $roleplcnt人 ";
                }
            }
            $resultcap = "（$roletabletext）\n";

        }
        elsif ( $self->{'roletable'} eq 'custom' ) {

            # 役職配分設定表示（自由設定時）
            $roletabletext = '';
            for ( $i = 1 ; $i < @$roleid ; $i++ ) {
                if ( $self->{"cnt$roleid->[$i]"} > 0 ) {
                    $roletabletext .=
"$sow->{'textrs'}->{'ROLENAME'}->[$i]: $self->{'cnt' . $roleid->[$i]}人 ";
                }
            }
            $resultcap = "（$roletabletext）\n";
        }

    }
    elsif ( $infocap eq 'votetype' ) {
        my %votecaption = (
            anonymity => '無記名投票',
            sign      => '記名投票',
        );
        $resultcap = $votecaption{ $self->{'votetype'} };

    }
    elsif ( $infocap eq 'scraplimit' ) {
        $resultcap = $sow->{'dt'}->cvtdt( $self->{'scraplimitdt'} );
        $resultcap = '自動廃村なし' if ( $self->{'scraplimitdt'} == 0 );

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
        $resultcap = '投票・能力の対象に「ランダム」を含めない';
        $resultcap = '投票・能力の対象に「ランダム」を含める' if ( $self->{'randomtarget'} > 0 );

    }
    elsif ( $infocap eq 'noselrole' ) {
        $resultcap = '有効';
        $resultcap = '無効' if ( $self->{'noselrole'} > 0 );

    }
    elsif ( $infocap eq 'makersaymenu' || $infocap eq 'entrustmode' ) {
        $resultcap = "許可";
        $resultcap = "不許可" if ( $self->{$infocap} > 0 );

    }
    elsif ( $infocap eq 'showall' ) {
        $resultcap = "非公開";
        $resultcap = "公開" if ( $self->{'showall'} > 0 );

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
        $resultcap = "あり";
        $resultcap = "なし" if ( $self->{$infocap} > 0 );

    }
    elsif ( $infocap eq 'showid' ) {
        $resultcap = "なし";
        $resultcap = "あり" if ( $self->{$infocap} > 0 );

    }
    elsif ( $infocap eq 'timestamp' ) {
        $resultcap = "完全表\示";
        $resultcap = "簡略表\示" if ( $self->{'timestamp'} > 0 );

    }
    elsif ( $infocap eq 'guestmenu' ) {
        $resultcap = "あり";
        $resultcap = "なし" if ( $self->{$infocap} > 0 );
    }

    return $resultcap;
}

#----------------------------------------
# 「参加中の村」データの更新
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
# 指定したuidのプレイヤーデータを得る
#----------------------------------------
sub getpl {
    my ( $self, $uid ) = @_;
    return $self->{'pl'}->{$uid};
}

#----------------------------------------
# 指定したuidのプレイヤーデータを更新
#----------------------------------------
sub changepl {
    my ( $self, $uid, $plsingle ) = @_;
    $self->{'pl'}->{$uid} = $plsingle;
    $self->{'pllist'} => [ $plsingle->{'pno'} ];

}

#----------------------------------------
# 指定した番号のプレイヤーデータを得る
#----------------------------------------
sub getplbypno {
    my ( $self, $pno ) = @_;
    return $self->{'pllist'}->[$pno];
}

#----------------------------------------
# プレイヤーデータの配列を得る
#----------------------------------------
sub getpllist {
    my $self = shift;
    return $self->{'pllist'};
}

#----------------------------------------
# 生存中のプレイヤーデータの配列を得る
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
# アクセスしているプレイヤーが参加済みかどうかを得る
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
# 発言数初期化
#----------------------------------------
sub setsaycountall {
    my $self = $_[0];

    foreach ( @{ $self->{'pllist'} } ) {
        $_->setsaycount();
    }

    return;
}

#----------------------------------------
# 発言数回復
#----------------------------------------
sub chargesaycountall {

    # 不要
    return;
}

#----------------------------------------
# コミット済みの人数を得る
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
# 村がエピローグに入っている／終了しているかどうか
#----------------------------------------
sub isepilogue {
    my $self   = shift;
    my $result = 0;
    $result = 1 if ( $self->{'turn'} >= $self->{'epilogue'} );

    return $result;
}

#----------------------------------------
# 村がプロローグ中であるか
#----------------------------------------
sub isprologue {
    my $self   = shift;
    my $result = 0;
    $result = 1 if ( $self->{'turn'} == 0 );
    return $result;
}

#----------------------------------------
# 村の状態を取得
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
# 村データラベル
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
        'cntvillager',     # 村人
        'cntwolf',         # 人狼
        'cntseer',         # 占い師
        'cntmedium',       # 霊能者
        'cntpossess',      # 狂人
        'cntguard',        # 狩人
        'cntfm',           # 共有者
        'cnthamster',      # ハムスター人間
        'cntcpossess',     # Ｃ国狂人
        'cntstigma',       # 聖痕者
        'cntfanatic',      # 狂信者
        'cntsympathy',     # 共鳴者
        'cntwerebat',      # コウモリ人間
        'cntcwolf',        # 呪狼
        'cntintwolf',      # 智狼
        'cnttrickster',    # ピクシー
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
# 村データファイル名の取得
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
# 村番号ディレクトリ名の取得
#----------------------------------------
sub GetFNameDirVid {
    my ( $sow, $vid ) = @_;
    $vid = 0 if ( $vid eq '' );

    my $datafile = sprintf( "%s/%04d", $sow->{'cfg'}->{'DIR_VIL'}, $vid, );
    return $datafile;
}

#----------------------------------------
# 村データファイル名の取得
# （村番号ディレクトリ式）
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
