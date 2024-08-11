package SWCmdUpdateSession;

#----------------------------------------
# XViŽè“®j
#----------------------------------------
sub CmdUpdateSession {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # ƒf[ƒ^ˆ—
    my $vil = &SetDataCmdUpdateSession($sow);

    # HTTP/HTMLo—Í
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newinfo";

    $sow->{'http'}->{'location'} = "$link";
    $sow->{'http'}->outheader();    # HTTPƒwƒbƒ_‚Ìo—Í
    $sow->{'http'}->outfooter();
}

#----------------------------------------
# ƒf[ƒ^ˆ—
#----------------------------------------
sub SetDataCmdUpdateSession {
    my $sow   = $_[0];
    my $query = $sow->{'query'};

    # ‘ºƒf[ƒ^‚Ì“Ç‚Ýž‚Ý
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # ƒŠƒ\[ƒX‚Ì“Ç‚Ýž‚Ý
    &SWBase::LoadVilRS( $sow, $vil );

    # XVˆ—
    require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
    my $scrapvil = 0;
    $scrapvil = 1 if ( $sow->{'query'}->{'cmd'} eq 'scrapvil' );
    &SWCommit::UpdateSession( $sow, $vil, 1, $scrapvil );

    $vil->closevil();

    return $vil;
}

1;
