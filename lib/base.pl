package SWBase;

#----------------------------------------
# SWBBS Base
#----------------------------------------

#----------------------------------------
# SWBBSの初期化
#----------------------------------------
sub InitSW {
    my $cfg = $_[0];

    require "$cfg->{'DIR_LIB'}/const.pl";
    my $sow = &SWConst::InitConst();    # 定数の定義

    $sow->{'cfg'} = $cfg;

    require "$cfg->{'DIR_LIB'}/datetime.pl";
    require "$cfg->{'DIR_LIB'}/string.pl";
    require "$cfg->{'DIR_LIB'}/http.pl";
    require "$cfg->{'DIR_LIB'}/file.pl";
    require "$cfg->{'DIR_LIB'}/lock.pl";
    require "$cfg->{'DIR_LIB'}/debug.pl";
    require "$cfg->{'DIR_LIB'}/user.pl";
    require "$cfg->{'DIR_LIB'}/charsets.pl";

    $sow->{'dt'}    = SWDateTime->new($sow);    # 日付変換用
    $sow->{'debug'} = SWDebug->new($sow);
    $sow->{'lock'}  = SWLock->new($sow);
    $sow->{'lock'}->glock();                    # ファイルロック

    &LoadJcode($sow);                           # jcode.pl/JCode.pm の読み込み

    $sow->{'http'}   = SWHttp->new($sow);              # HTTP制御の初期化
    $sow->{'query'}  = $sow->{'http'}->getquery();     # 入力値
    $sow->{'cookie'} = $sow->{'http'}->getcookie();    # クッキー
    $sow->{'filter'} = &GetCookieFilter($sow);         # フィルタ用クッキー
    $sow->{'user'}   = SWUser->new($sow);
    my %setcookie;
    $sow->{'setcookie'} = \%setcookie;

    ( $sow->{'ua'}, $sow->{'outmode'} ) = &CheckUA($sow);

    $sow->{'charsets'} = SWCharsets->new($sow);
    &LoadBasicTextRS($sow);

    return $sow;
}

#----------------------------------------
# 発言フィルタ用Cookieデータの取得
#----------------------------------------
sub GetCookieFilter {
    my $sow    = $_[0];
    my $cookie = $sow->{'cookie'};
    my $i;

    my $pnofilters  = &GetCookieValueStr( $sow, 'pnofilter' );
    my @pnofilter   = split( /,/, $pnofilters . ',' );
    my $livetypeses = &GetCookieValueStr( $sow, 'livetypes' );
    my @livetypes   = split( /,/, $livetypeses . ',' );
    for ( $i = 0 ; $i < 4 ; $i++ ) {
        $livetypes[$i] = 0 if ( !defined( $livetypes[$i] ) );
    }
    my $typefilters = &GetCookieValueStr( $sow, 'typefilter' );
    my @typefilter  = split( /,/, $typefilters . ',' );
    for ( $i = 0 ; $i < 4 ; $i++ ) {
        $typefilter[$i] = 0 if ( !defined( $typefilter[$i] ) );
    }

    my %filter = (
        pnofilter    => \@pnofilter,
        livetypes    => \@livetypes,
        typefilter   => \@typefilter,
        layoutfilter => &GetCookieValueStr( $sow, 'layoutfilter' ),
        fixfilter    => &GetCookieValueStr( $sow, 'fixfilter' ),
        mestypes     => &GetCookieValueStr( $sow, 'mestypes' ),
        lumpfilter   => &GetCookieValueStr( $sow, 'lumpfilter' ),
    );
    return \%filter;
}

#----------------------------------------
# 文字列型クッキーの値を得る
#----------------------------------------
sub GetCookieValueStr {
    my $data = '';
    $data = $_[0]->{'cookie'}->{ $_[1] }
      if ( defined( $_[0]->{'cookie'}->{ $_[1] } ) );
    return $data;
}

#----------------------------------------
# 端末識別
#----------------------------------------
sub CheckUA {
    my $sow = $_[0];

    # 自動認識
    my $ua       = '';
    my $envagent = $ENV{'HTTP_USER_AGENT'};
    $envagent = 'J-PHONE5.0' if ( index( $envagent, 'J-EMULATOR' ) == 0 );
    my $is_upbrowser = index( $envagent, 'UP.Browser' );
    $ua = 'ihtml' if ( index( $envagent, 'DoCoMo' ) == 0 );
    if ( index( $envagent, 'SoftBank' ) == 0 ) {
        $ua = 'sb';
    }
    elsif (( index( $envagent, 'J-PHONE5.' ) == 0 )
        || ( index( $envagent, 'Vodafone' ) == 0 ) )
    {
        $ua = 'vodax';
    }
    elsif ( index( $envagent, 'J-PHONE' ) == 0 ) {
        $ua = 'voda';
    }

    # UP.Browser系
    if ( $is_upbrowser >= 0 ) {
        $envagent =~ /UP\.Browser\/(\d*)\./;
        if ( $1 > 5 ) {
            $ua = 'au';
        }
        else {
            $ua = 'hdml';
        }
    }

    # ua引数認識
    my @ualist = ( 'html401', 'rss' );
    foreach (@ualist) {
        $ua = $_ if ( $sow->{'query'}->{'ua'} eq $_ );
    }
    $ua = $sow->{'cfg'}->{'DEFAULT_UA'} if ( $ua eq '' );

    my $outmode = 'pc';
    $outmode = 'rss' if ( $ua eq 'rss' );

    return ( $ua, $outmode );
}

#----------------------------------------
# URLエンコード
#----------------------------------------
sub EncodeURL {
    my $url = $_[0];
    $url =~ s/(\W)/sprintf("%%%02X", ord($1))/eg;
    return $url;
}

#----------------------------------------
# URLデコード
#----------------------------------------
sub DecodeURL {
    my $url = $_[0];
    $url =~ s/%([0-9a-fA-F][0-9a-fA-F])/chr(hex($1))/eg;
    return $url;
}

#----------------------------------------
# 基本文字列リソースの読み込み
#----------------------------------------
sub LoadBasicTextRS {
    my $sow = $_[0];
    require "$sow->{'cfg'}->{'DIR_RS'}/trs_basic.pl";
    $sow->{'basictrs'} = &SWBasicTextRS::SWBasicTextRS($sow);

    return;
}

#----------------------------------------
# 文字列リソースの読み込み
#----------------------------------------
sub LoadTextRS {
    my ( $sow, $vil ) = @_;
    my $trsid = $vil->{'trsid'};

    my $fname = "$sow->{'cfg'}->{'DIR_RS'}/trs_$trsid.pl";
    $sow->{'debug'}->raise( $sow->{'APLOG_WARNING'}, "文字列リソ\ース $trsid が見つかりません。", "trsid not found.[$trsid]" )
      if ( !( -e $fname ) );

    require "$fname";
    my $sub    = '::SWTextRS_' . $trsid . '::GetTextRS';
    my $textrs = &$sub($sow);

    $sow->{'trsid'}  = $trsid;
    $sow->{'textrs'} = $textrs;
}

#----------------------------------------
# 文字列リソースの読み込み（vilなしver）
#----------------------------------------
sub LoadTextRSWithoutVil {
    my ( $sow, $trsid ) = @_;

    my $fname = "$sow->{'cfg'}->{'DIR_RS'}/trs_$trsid.pl";
    $sow->{'debug'}->raise( $sow->{'APLOG_WARNING'}, "文字列リソ\ース $trsid が見つかりません。", "trsid not found.[$trsid]" )
      if ( !( -e $fname ) );

    require "$fname";
    my $sub    = '::SWTextRS_' . $trsid . '::GetTextRS';
    my $textrs = &$sub($sow);

    $sow->{'trsid'}  = $trsid;
    $sow->{'textrs'} = $textrs;
}

#----------------------------------------
# リソースの読み込み
#----------------------------------------
sub LoadVilRS {
    my ( $sow, $vil ) = @_;

    # リソースの読み込み
    my $csidlist = $sow->{'csidlist'};
    my @keys     = keys(%$csidlist);
    foreach (@keys) {
        $sow->{'charsets'}->loadchrrs($_);
    }
    &LoadTextRS( $sow, $vil );
}

#----------------------------------------
# 送信用属性値の生成
#----------------------------------------
sub GetHiddenValues {
    my ( $sow, $reqvals, $tab ) = @_;
    my $net = $sow->{'html'}->{'net'};

    my $hidden = '';
    my @keys   = keys(%$reqvals);
    foreach (@keys) {
        next if ( !defined( $reqvals->{$_} ) );
        next if ( $reqvals->{$_} eq '' );
        $hidden .= "\n$tab<input type=\"hidden\" name=\"$_\" value=\"$reqvals->{$_}\"$net>";
    }
    return $hidden;
}

#----------------------------------------
# リンク用属性値の生成
#----------------------------------------
sub GetLinkValues {
    my ( $sow, $reqvals ) = @_;
    my $linkvalues = '';
    my $amp        = '&';
    $amp = $sow->{'html'}->{'amp'} if ( defined( $sow->{'html'}->{'amp'} ) );

    my ( $pkg, $fname, $line ) = caller;

    my %shortquery = (
        cmd   => 'c',
        logid => 'l',
        mode  => 'm',
        order => 'o',
        pwd   => 'p',
        row   => 'r',
        turn  => 't',
        uid   => 'u',
        vid   => 'v',
    );

    my @keys = keys(%$reqvals);
    foreach (@keys) {
        next                if ( !defined( $reqvals->{$_} ) );
        next                if ( $reqvals->{$_} eq '' );
        $linkvalues .= $amp if ( $linkvalues ne '' );
        my $key  = $_;
        my $data = &EncodeURL( $reqvals->{$_} );
        $linkvalues .= "$key=$data";
    }
    return $linkvalues;
}

#----------------------------------------
# 引き継ぐ引数リストを取得
#----------------------------------------
sub GetRequestValues {
    my ( $sow, $reqkeys ) = @_;
    my $query = $sow->{'query'};

    if ( ( defined( $query->{'row'} ) ) && ( $query->{'row'} eq 'all' ) ) {
        $query->{'row'}    = '';
        $query->{'rowall'} = 'on';    # 引き継がない
    }

    my @basereqkeys;
    if ( $query->{'cmd'} eq 'rss' ) {
        @basereqkeys = ( 'cmd', 'vid', 'row' );
    }
    elsif ( defined( $query->{'vid'} ) ) {
        @basereqkeys = ( 'ua', 'uid', 'pwd', 'order', 'row', 'css', 'vid', 'turn', 'mode', 'pno', 'ghost' );
    }
    else {
        @basereqkeys = ( 'ua', 'uid', 'pwd', 'order', 'row', 'css' );
    }
    push( @$reqkeys, @basereqkeys );

    my @customreqkeys;
    if ( $query->{'cmd'} eq 'makevilpr' && $query->{'roletable'} eq 'custom' ) {
        my $roleid = $sow->{'ROLEID'};
        for ( $i = 1 ; $i < @$roleid ; $i++ ) {
            my $countrole = 0;
            if ( defined( $query->{"cnt$roleid->[$i]"} ) ) {
                push( @customreqkeys, "cnt$roleid->[$i]" );
            }
        }
        push( @$reqkeys, @customreqkeys );
    }

    my %reqvals = ();
    foreach (@$reqkeys) {
        $reqvals{$_} = $sow->{'query'}->{$_}
          if ( ( defined( $sow->{'query'}->{$_} ) )
            && ( $sow->{'query'}->{$_} ne '' ) );
    }
    return \%reqvals;
}

#----------------------------------------
# 発言数消費量の取得
#----------------------------------------
sub GetSayPoint {
    my ( $sow, $vil, $text ) = @_;
    my $saycnt = $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} };

    my $point;
    if ( $saycnt->{'COUNT_TYPE'} eq 'count' ) {
        $point = 1;
    }
    elsif ( $saycnt->{'COUNT_TYPE'} eq 'point' ) {
        $text =~ s/<br( \/)?>/\n/ig;
        &ExtractChrRef( \$text );
        $point = &GetSayPointJuna($text);
    }
    else {
        $text =~ s/<br( \/)?>/\n/ig;
        &ExtractChrRef( \$text );
        $point = &GetSayPointJunaAlpha2($text);
    }

    return $point;
}

#----------------------------------------
# 発言数消費量の取得（人狼審問）
# 50バイトまで20pt、以下14バイトごとに1pt。
# 改行は一つ当たり４バイト（<br>として計算）。
#----------------------------------------
sub GetSayPointJuna {
    my $text = $_[0];

    my $count = length($text);
    my $point = 20;
    $count -= 50;
    $count = 0 if ( $count < 0 );
    $point += int( $count / 14 );

    return $point;
}

#----------------------------------------
# 発言数消費量の取得（人狼審問α２〜β１初期）
# 60バイトまで25pt、以下4バイトごとに1pt。
# 改行は一つ当たり４バイト（<br>として計算）。
#----------------------------------------
sub GetSayPointJunaAlpha2 {
    my $text = $_[0];

    my $count = length($text);
    my $point = 25;
    $count -= 60;
    $count = 0 if ( $count < 0 );
    $point += int( $count / 4 );

    return $point;
}

#----------------------------------------
# Jcode.pm/jcode.pl の読み込み
#----------------------------------------
sub LoadJcode {
    my $sow = $_[0];
    $sow->{'jcode'} = '';

    eval 'use Jcode;';
    if ( $@ eq '' ) {
        $sow->{'jcode'} = 'pm';
    }
    else {
        eval "require \"$sow->{'cfg'}->{'FILE_JCODE'}\";";
        if ( $@ eq '' ) {
            $sow->{'jcode'} = 'pl';
        }
    }

    return;
}

#----------------------------------------
# Jcode.pm/jcode.pl で文字コードセット変換
#----------------------------------------
sub JcodeConvert {
    my $sow = $_[0];
    if ( $sow->{'jcode'} eq 'pm' ) {
        &Jcode::convert( $_[1], $_[2], $_[3] );
    }
    elsif ( $sow->{'jcode'} eq 'pl' ) {
        &jcode::convert( $_[1], $_[2], $_[3] );
    }
    return;
}

#----------------------------------------
# 発言数表示用テキストの取得
#----------------------------------------
sub GetSayCountText {
    my ( $sow, $vil ) = @_;
    my $saycnt = $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} };
    my $unit =
      $sow->{'basictrs'}->{'SAYTEXT'}->{ $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} }->{'COUNT_TYPE'} }
      ->{'UNIT_SAY'};
    my $curpl = $sow->{'curpl'};

    if ( $vil->checkentried() < 0 ) {

        # エントリー時
        return '';
    }

    my $say    = $curpl->{'say'};
    my $maxsay = $saycnt->{'MAX_SAY'};
    if ( $vil->{'turn'} == 0 ) {

        # プロローグ用
        $say    = $curpl->{'psay'};
        $maxsay = $saycnt->{'MAX_PSAY'};
    }
    if ( $curpl->{'live'} ne 'live' ) {

        # 墓下
        $say    = $curpl->{'gsay'};
        $maxsay = $saycnt->{'MAX_GSAY'};
    }
    if ( $vil->isepilogue() > 0 ) {

        # エピローグ用
        $say    = $curpl->{'esay'};
        $maxsay = $saycnt->{'MAX_ESAY'};
    }

    my $saytext = " あと$say$unit";

    return $saytext;
}

#----------------------------------------
# アクセスしているプレイヤーのデータを得る
# ※村建て人＆管理人発言対応
#----------------------------------------
sub GetCurrentPl {
    my ( $sow, $vil ) = @_;
    my $query = $sow->{'query'};

    require "$sow->{'cfg'}->{'DIR_LIB'}/file_player.pl";
    my $plsingle = SWPlayer->new($sow);
    $plsingle->createpl( $sow->{'uid'} );
    $plsingle->{'jobname'}   = '';
    $plsingle->{'pno'}       = -1;
    $plsingle->{'live'}      = 'live';
    $plsingle->{'entrieddt'} = 0;
    $plsingle->{'emulated'}  = 0;

    my $curpl = $sow->{'curpl'};
    if ( defined( $curpl->{'uid'} ) ) {
        my @keys = keys(%$curpl);
        foreach (@keys) {
            $plsingle->{$_} = $curpl->{$_};
        }
    }

    my $csidlist = $sow->{'csidlist'};
    my @keys     = keys(%$csidlist);
    if ( $vil->checkentried() < 0 ) {
        $plsingle->{'csid'}     = $keys[0];
        $plsingle->{'role'}     = $sow->{'ROLEID_UNDEF'};
        $plsingle->{'emulated'} = 1;
    }

    if (   ( $query->{'admin'} ne '' )
        && ( $sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'} ) )
    {
        # 管理人発言モード
        $plsingle->{'cid'}      = $sow->{'cfg'}->{'CID_ADMIN'};
        $plsingle->{'csid'}     = $keys[0];
        $plsingle->{'emulated'} = 1;
    }
    elsif (( $query->{'maker'} ne '' )
        && ( $sow->{'uid'} eq $vil->{'makeruid'} ) )
    {
        # 村建て人発言モード
        $plsingle->{'cid'}      = $sow->{'cfg'}->{'CID_MAKER'};
        $plsingle->{'csid'}     = $keys[0];
        $plsingle->{'emulated'} = 1;
    }
    elsif ( $query->{'guest'} ne '' ) {

        # 傍観者発言モード
        $plsingle->{'cid'}      = $sow->{'cfg'}->{'CID_GUEST'};
        $plsingle->{'csid'}     = $keys[0];
        $plsingle->{'emulated'} = 1;
    }

    if ( $plsingle->{'emulated'} > 0 ) {
        return $plsingle;
    }
    else {
        return $curpl;
    }
}

#----------------------------------------
# コミット状況のID番号を得る
#----------------------------------------
sub GetTotalCommitID {
    my ( $sow, $vil ) = @_;

    my $getlivepllist = $vil->getlivepllist();
    my $cntlivepl     = @$getlivepllist;
    my $commitedpl    = $vil->getcommitedpl();
    my $totalcommit   = 0;
    $totalcommit = 1 if ( $commitedpl > $cntlivepl / 3 );
    $totalcommit = 2 if ( $commitedpl > $cntlivepl * 2 / 3 );
    $totalcommit = 3 if ( $commitedpl == $cntlivepl );

    return $totalcommit;
}

#----------------------------------------
# UAがOperaの時バージョン番号を得る
#----------------------------------------
sub GetOperaVersion {
    my $result = -1;
    if ( $ENV{'HTTP_USER_AGENT'} =~ /Opera[ \/]\d+.\d+/ ) {
        my $operaid = $&;
        $operaid =~ /\d+.\d+/;
        $result = $&;
    }

    return $result;
}

#----------------------------------------
# 誤爆注意チェックが必要な役職かどうか
#----------------------------------------
sub CheckWriteSafetyRole {
    my ( $sow, $vil ) = @_;

    my $curpl       = &SWBase::GetCurrentPl( $sow, $vil );
    my $enablecheck = 0;
    $enablecheck = 1 if ( $curpl->iswolf() > 0 );              # 人狼/呪狼/智狼
    $enablecheck = 1
      if ( $curpl->{'role'} eq $sow->{'ROLEID_CPOSSESS'} );    # Ｃ国狂人
    $enablecheck = 1 if ( $curpl->{'role'} eq $sow->{'ROLEID_SYMPATHY'} );    # 共鳴者
    $enablecheck = 1
      if ( $curpl->{'role'} eq $sow->{'ROLEID_WEREBAT'} );                    # コウモリ人間
    $enablecheck = 1 if ( $curpl->islovers() > 0 );                           # 恋人

    return $enablecheck;
}

#----------------------------------------
# 文字参照の展開
#----------------------------------------
sub ExtractChrRef {
    my $text = shift;

    $$text =~ s/&lt\;/</g;
    $$text =~ s/&gt\;/>/g;
    $$text =~ s/&quot\;/\"/g;
    $$text =~ s/&amp\;/&/g;
}

#----------------------------------------
# 文字参照へのエスケープ
#----------------------------------------
sub EscapeChrRef {
    my $text = shift;

    $$text =~ s/&/&amp\;/g;
    $$text =~ s/&amp\;(#\d{3,}\;)/&$1/ig;    # １〜２桁の文字参照は念のため蹴る（手抜き）
    $$text =~ s/&(#0*127;)/&amp\;$1/g;       # 127は制御コードなので一応蹴る

    #	$$text =~ s/&\#0*160\;/ /g;

    $$text =~ s/</&lt\;/g;
    $$text =~ s/>/&gt\;/g;
    $$text =~ s/\"/&quot\;/g;
}

#----------------------------------------
# 希望役職を変更する
#----------------------------------------
sub ChangeSelRole {
    my ( $sow, $vil, $curpl, $role, $logfile ) = @_;

    # プレイヤーデータの更新
    $curpl->{'selrole'} = $role;
    $vil->changepl($curpl);

    my $selrolename = $sow->{'textrs'}->{'ROLENAME'}->[$role];
    $selrolename = $sow->{'textrs'}->{'RANDOMROLE'} if ( $role < 0 );
    my $chrname   = $curpl->getchrname();
    my $changemes = $sow->{'textrs'}->{'ANNOUNCE_CHANGESELROLE'};
    $changemes =~ s/_NAME_/$chrname/g;
    $changemes =~ s/_SELROLE_/$selrolename/g;
    $logfile->writeinfo( '', $sow->{'MESTYPE_INFOSP'}, $changemes );

    $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Change selected role. [$curpl->{'uid'}]" );
}

#----------------------------------------
# 村を出る
#----------------------------------------
sub ExitVillage {
    my ( $sow, $vil, $exitpl, $logfile ) = @_;

    # ユーザーデータの更新
    my $user = SWUser->new($sow);
    $user->writeentriedvil( $exitpl->{'uid'}, $vil->{'vid'}, '', -1 );

    $exitpl->{'delete'} = 1;
    my $chrname = $exitpl->getchrname();
    my $exitmes = $sow->{'textrs'}->{'EXITMES'};
    $exitmes =~ s/_NAME_/$chrname/g;
    $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $exitmes );

    $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Exit. [$exitpl->{'uid'}]" );
}

1;
