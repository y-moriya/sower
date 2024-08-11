package SWCmdStartSession;

#----------------------------------------
# ‘ºŠJŽn
#----------------------------------------
sub CmdStartSession {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # ƒf[ƒ^ˆ—
    my $vil = &SetDataCmdStartSession($sow);

    # HTTP/HTMLo—Í
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newinfo";

    $sow->{'http'}->{'location'} = $link;
    $sow->{'http'}->outheader();    # HTTPƒwƒbƒ_‚Ìo—Í
    $sow->{'http'}->outfooter();
    $vil->closevil();
}

#----------------------------------------
# ƒf[ƒ^ˆ—
#----------------------------------------
sub SetDataCmdStartSession {
    my $sow   = $_[0];
    my $query = $sow->{'query'};

    # ‘ºƒf[ƒ^‚Ì“Ç‚Ýž‚Ý
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # ƒŠƒ\[ƒX‚Ì“Ç‚Ýž‚Ý
    &SWBase::LoadVilRS( $sow, $vil );

    # ‘ºŠJŽnˆ—
    require "$sow->{'cfg'}->{'DIR_LIB'}/commit.pl";
    &SWCommit::StartSession( $sow, $vil, 1 );

    return $vil;
}

1;
