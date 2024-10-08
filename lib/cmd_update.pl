package SWCmdUpdateSession;

#----------------------------------------
# XViè®j
#----------------------------------------
sub CmdUpdateSession {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # f[^
    my $vil = &SetDataCmdUpdateSession($sow);

    # HTTP/HTMLoÍ
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newinfo";

    $sow->{'http'}->{'location'} = "$link";
    $sow->{'http'}->outheader();    # HTTPwb_ÌoÍ
    $sow->{'http'}->outfooter();
}

#----------------------------------------
# f[^
#----------------------------------------
sub SetDataCmdUpdateSession {
    my $sow   = $_[0];
    my $query = $sow->{'query'};

    # ºf[^ÌÇÝÝ
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # \[XÌÇÝÝ
    &SWBase::LoadVilRS( $sow, $vil );

    # XV
    require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
    my $scrapvil = 0;
    $scrapvil = 1 if ( $sow->{'query'}->{'cmd'} eq 'scrapvil' );
    &SWCommit::UpdateSession( $sow, $vil, 1, $scrapvil );

    $vil->closevil();

    return $vil;
}

1;
