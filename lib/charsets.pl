package SWCharsets;

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
    my ( $class, $sow ) = @_;
    my $self = { sow => $sow, };

    return bless( $self, $class );
}

#----------------------------------------
# キャラセットの読み込み
#----------------------------------------
sub loadchrrs {
    my ( $self, $csid ) = @_;
    my $sow = $self->{'sow'};

    # 読み込み済みなら何もしない
    return if ( defined( $self->{'csid'}->{$csid}->{'CAPTION'} ) );

    my $fname = "$sow->{'cfg'}->{'DIR_RS'}/crs_$csid.pl";
    $sow->{'debug'}->raise(
        $sow->{'APLOG_WARNING'},
        "キャラクタセット $csid が見つかりません。",
        "csid not found.[$csid]"
    ) if ( !( -e $fname ) );

    require "$fname";
    my $sub     = '::SWResource_' . $csid . '::GetRSChr';
    my $charset = &$sub($sow);

    $self->{'csid'}->{$csid} = $charset;
    return;
}

#----------------------------------------
# キャラ名の取得
# getchrname($csid, $cid)
#----------------------------------------
sub getchrname {
    my ( $self, $csid, $cid, $newjobname ) = @_;

    $self->loadchrrs($csid)
      if ( !defined( $self->{'csid'}->{$csid}->{'CHRNAME'} ) );
    my $jobname = $self->{'csid'}->{$csid}->{'CHRJOB'}->{$cid};
    $jobname = $newjobname
      if ( ( defined($newjobname) ) && ( $newjobname ne '' ) );
    return "$jobname $self->{'csid'}->{$csid}->{'CHRNAME'}->{$cid}";
}

#----------------------------------------
# 短縮キャラ名の取得
# getshortchrname($csid, $cid)
#----------------------------------------
sub getshortchrname {
    my ( $self, $csid, $cid ) = @_;

    $self->loadchrrs($csid)
      if ( !defined( $self->{'csid'}->{$csid}->{'CHRNAME'} ) );
    return $self->{'csid'}->{$csid}->{'CHRNAME'}->{$cid};
}

#----------------------------------------
# キャラ名の頭文字の取得
# getchrnameinitial($csid, $cid)
#----------------------------------------
sub getchrnameinitial {
    my ( $self, $csid, $cid ) = @_;

    $self->loadchrrs($csid)
      if ( !defined( $self->{'csid'}->{$csid}->{'CHRNAMEINITIAL'} ) );
    return $self->{'csid'}->{$csid}->{'CHRNAMEINITIAL'}->{$cid};
}

1;
