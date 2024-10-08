package SWCmdEpilogueEditVil;

#----------------------------------------
# {§ÀÏXibèj
#----------------------------------------
sub CmdEpilogueEditVil {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # f[^
    my $vil = &SetDataCmdEpilogueEditVil($sow);

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
sub SetDataCmdEpilogueEditVil {
    my $sow     = $_[0];
    my $query   = $sow->{'query'};
    my $debug   = $sow->{'debug'};
    my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

    # ºf[^ÌÇÝÝ
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # \[XÌÇÝÝ
    &SWBase::LoadVilRS( $sow, $vil );

    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, "Çl ÀªKvÅ·B", "no permition.$errfrom" )
      if ( $sow->{'uid'} ne $sow->{'cfg'}->{'USERID_ADMIN'} );
    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, "{ ÀIDªs³Å·B", "no rating.$errfrom" )
      if ( !defined( $sow->{'cfg'}->{'RATING'}->{ $query->{'rating'} }->{'CAPTION'} ) );
    $vil->{'rating'} = $query->{'rating'};
    $vil->writevil();
    $vil->closevil();

    return $vil;
}

1;
