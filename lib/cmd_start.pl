package SWCmdStartSession;

#----------------------------------------
# ºJn
#----------------------------------------
sub CmdStartSession {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # f[^
    my $vil = &SetDataCmdStartSession($sow);

    # HTTP/HTMLoÍ
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newinfo";

    $sow->{'http'}->{'location'} = $link;
    $sow->{'http'}->outheader();    # HTTPwb_ÌoÍ
    $sow->{'http'}->outfooter();
    $vil->closevil();
}

#----------------------------------------
# f[^
#----------------------------------------
sub SetDataCmdStartSession {
    my $sow   = $_[0];
    my $query = $sow->{'query'};

    # ºf[^ÌÇÝÝ
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # \[XÌÇÝÝ
    &SWBase::LoadVilRS( $sow, $vil );

    # ºJn
    require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
    &SWCommit::StartSession( $sow, $vil, 1 );

    return $vil;
}

1;
