package SWCmdCancel;

#----------------------------------------
# ”­Œ¾“P‰ñ
#----------------------------------------
sub CmdCancel {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # ƒf[ƒ^ˆ—
    my $vil = &SetDataCmdCancel($sow);

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
sub SetDataCmdCancel {
    my $sow   = $_[0];
    my $query = $sow->{'query'};

    # ‘ºƒf[ƒ^‚Ì“Ç‚Ýž‚Ý
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # ƒŠƒ\[ƒX‚Ì“Ç‚Ýž‚Ý
    &SWBase::LoadVilRS( $sow, $vil );

    # ”­Œ¾“P‰ñ
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    my $logfile = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );
    $logfile->delete( $sow->{'query'}->{'queid'} );
    $logfile->close();

    $vil->closevil();
    return $vil;
}

1;
