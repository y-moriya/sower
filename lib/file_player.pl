package SWPlayer;

#----------------------------------------
# プレイヤーデータ
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
    my ( $class, $sow ) = @_;
    my $self = { sow => $sow, };

    return bless( $self, $class );
}

#----------------------------------------
# プレイヤーデータラベル
#----------------------------------------
sub getdatalabel {
    my @datalabel = (
        'uid',          'cid',          'csid',         'jobname',     'role',       'rolesubid',
        'selrole',      'live',         'deathday',     'say',         'tsay',       'wsay',
        'spsay',        'bsay',         'gsay',         'psay',        'esay',       'say_act',
        'actaddpt',     'saidcount',    'saidpoint',    'countinfosp', 'countthink', 'vote',
        'target',       'target2',      'entrust',      'bonds',       'lovers',     'commit',
        'entrieddt',    'limitentrydt', 'lastwritepos', 'history',     'modified',   'savedraft',
        'draftmestype', 'draftmspace',  'draftloud',
    );

    return @datalabel;
}

#----------------------------------------
# プレイヤーデータの新規作成
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
# プレイヤーデータの読み込み
#----------------------------------------
sub readpl {
    my ( $self, $datalabel, $data ) = @_;
    $self->createpl('');
    @$self{@$datalabel} = split( /<>/, $data );

    my @datalabelnew = $self->getdatalabel();
    foreach (@datalabelnew) {
        $self->{$_} = ''
          if ( $self->{$_} eq $self->{'sow'}->{'DATATEXT_NONE'} );
    }

    $self->{'delete'} = 0;

    return;
}

#----------------------------------------
# プレイヤーデータの書き込み
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
# 発言数初期化
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
# 発言数回復
#----------------------------------------
sub chargesaycount {
    my $self   = shift;
    my $saycnt = $self->{'sow'}->{'cfg'}->{'COUNTS_SAY'}->{ $self->{'vil'}->{'saycnttype'} };

    $self->{'say'}   += $saycnt->{'MAX_SAY'};
    $self->{'tsay'}  += $saycnt->{'MAX_TSAY'};
    $self->{'wsay'}  += $saycnt->{'MAX_WSAY'};
    $self->{'spsay'} += $saycnt->{'MAX_SPSAY'};
    $self->{'bsay'}  += $saycnt->{'MAX_BSAY'};
    $self->{'gsay'}  += $saycnt->{'MAX_GSAY'};
    $self->{'psay'}  += $saycnt->{'MAX_SAY'};    # プロローグのチャージ量は進行中と同じにしてみた
    $self->{'esay'}  += $saycnt->{'MAX_ESAY'};
    $self->{'say_act'}  += $saycnt->{'MAX_SAY_ACT'};
    $self->{'actaddpt'} += $saycnt->{'MAX_ADDSAY'};

    return;
}

#----------------------------------------
# 発言数を増やす（促し）
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
# 投票／能力対象候補のリストを取得
#----------------------------------------
sub gettargetlist {
    my ( $self, $cmd, $targetpno ) = @_;
    my $sow = $self->{'sow'};
    my $vil = $self->{'vil'};
    my @targetlist;

    my @bonds = split( '/', $self->{'bonds'} . '/' );
    my $livepllist = $vil->getlivepllist();
    my $livepl;
    foreach $livepl (@$livepllist) {
        next if ( $livepl->{'uid'} eq $self->{'uid'} );    # 自分自身は除外
        next
          if ( ( $self->{'role'} == $sow->{'ROLEID_TRICKSTER'} )
            && ( $livepl->{'uid'} eq $sow->{'cfg'}->{'USERID_NPC'} ) )
          ;    # ピクシーの対象にはダミーキャラを含まない
        next
          if ( ( defined($targetpno) ) && ( $livepl->{'pno'} == $targetpno ) );   # 第一対象と同じ場合は除外

        if ( ( $cmd eq 'vote' ) || ( $self->iswolf() > 0 ) ) {

            # 投票先か襲撃先の場合
            my $bond = 0;
            my $bondpno;
            foreach $bondpno (@bonds) {
                $bond = 1 if ( $livepl->{'pno'} == $bondpno );
            }

            #			next if ($bond > 0); # 運命の絆で結ばれている相手でも除外しない
        }

        if ( ( $self->iswolf() > 0 ) && ( $cmd ne 'vote' ) ) {
            next if ( $livepl->iswolf() > 0 );    # 人狼/呪狼/智狼は襲撃対象から除外
            next
              if ( ( $vil->{'turn'} == 1 )
                && ( $livepl->{'uid'} ne $sow->{'cfg'}->{'USERID_NPC'} ) )
              ;                                   # １日目の襲撃対象はダミーキャラのみ
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
# 投票／能力対象候補のリストを取得
# （おまかせ・ランダム入り）
#----------------------------------------
sub gettargetlistwithrandom {
    my ( $self, $cmd ) = @_;
    my $sow = $self->{'sow'};
    my $vil = $self->{'vil'};
    $targetlist = $self->gettargetlist($cmd);

    # おまかせ（襲撃対象のみ）
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

    # ランダム
    my $randomtarget = 1;
    $randomtarget = 0 if ( $vil->{'randomtarget'} == 0 );    # 村設定がランダム禁止
    $randomtarget = 0
      if ( ( $cmd ne 'vote' )
        && ( $self->iswolf() > 0 )
        && ( $vil->{'turn'} == 1 ) );                        # １日目の襲撃対象にはランダムを含まない
    if ( $randomtarget > 0 ) {
        my %randomtarget = (
            chrname => 'ランダム',
            pno     => $sow->{'TARGETID_RANDOM'},
        );
        unshift( @$targetlist, \%randomtarget );
    }

    return $targetlist;
}

#----------------------------------------
# 運命の絆を追加する
#----------------------------------------
sub addbond {
    my ( $self, $target ) = @_;

    my $isbond = 0;
    my @bonds = split( '/', $self->{'bonds'} . '/' );
    foreach (@bonds) {
        $isbond = 1 if ( $_ == $target );
    }

    # 絆を追加
    if ( $isbond == 0 ) {
        $self->{'bonds'} .= '/' if ( $self->{'bonds'} ne '' );
        $self->{'bonds'} .= $target;
    }
}

#----------------------------------------
# 希望役職を変更する
#----------------------------------------
sub changeselrole {
    my ( $self, $role ) = @_;

    $self->{'selrole'} = $role;
}

#----------------------------------------
# キャラの名前を取得する
#----------------------------------------
sub getchrname {
    my $self = shift;
    return $self->{'sow'}->{'charsets'}->getchrname( $self->{'csid'}, $self->{'cid'}, $self->{'jobname'} );
}

#----------------------------------------
# キャラ名の頭文字を取得する
#----------------------------------------
sub getchrnameinitial {
    my $self = shift;
    return $self->{'sow'}->{'charsets'}->getchrnameinitial( $self->{'csid'}, $self->{'cid'} );
}

#----------------------------------------
# 囁き職かどうかを調べる
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
# 人狼かどうかを調べる
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
# ハムスター人間かどうかを調べる
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
# 勝敗の取得
#----------------------------------------
sub iswin {
    my $self = shift;
    $sow = $self->{'sow'};
    $vil = $self->{'vil'};

    my $win = 2;    # 負け
    $win = 1
      if ( $vil->{'winner'} == $sow->{'ROLECAMP'}[ $self->{'role'} ] );    # 勝ち
    $win = 0 if ( $vil->{'winner'} == 0 );                                 # 引き分け

    return $win;
}

1;
