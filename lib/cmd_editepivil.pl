package SWCmdEpilogueEditVil;

#----------------------------------------
# ‰{——§ŒÀ•ÏXiŽb’èj
#----------------------------------------
sub CmdEpilogueEditVil {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # ƒf[ƒ^ˆ—
    my $vil = &SetDataCmdEpilogueEditVil($sow);

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
sub SetDataCmdEpilogueEditVil {
    my $sow     = $_[0];
    my $query   = $sow->{'query'};
    my $debug   = $sow->{'debug'};
    my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

    # ‘ºƒf[ƒ^‚Ì“Ç‚Ýž‚Ý
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # ƒŠƒ\[ƒX‚Ì“Ç‚Ýž‚Ý
    &SWBase::LoadVilRS( $sow, $vil );

    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, "ŠÇ—lŒ ŒÀ‚ª•K—v‚Å‚·B", "no permition.$errfrom" )
      if ( $sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'} );
    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, "‰{——Œ ŒÀID‚ª•s³‚Å‚·B", "no rating.$errfrom" )
      if ( !defined( $sow->{'cfg'}->{'RATING'}->{ $query->{'rating'} }->{'CAPTION'} ) );
    $vil->{'rating'} = $query->{'rating'};
    $vil->writevil();
    $vil->closevil();

    return $vil;
}

1;
