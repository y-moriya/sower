package SWCmdCancel;

#----------------------------------------
# ­¾Pñ
#----------------------------------------
sub CmdCancel {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # f[^
    my $vil = &SetDataCmdCancel($sow);

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
sub SetDataCmdCancel {
    my $sow   = $_[0];
    my $query = $sow->{'query'};

    # ºf[^ÌÇÝÝ
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # \[XÌÇÝÝ
    &SWBase::LoadVilRS( $sow, $vil );

    # ­¾Pñ
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );
    $logfile->delete( $sow->{'query'}->{'queid'} );
    $logfile->close();

    $vil->closevil();
    return $vil;
}

1;
