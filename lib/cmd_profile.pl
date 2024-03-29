package SWCmdProfile;

#----------------------------------------
# [U[îñ\¦
#----------------------------------------
sub CmdProfile {
    my $sow = $_[0];
    my $cfg = $sow->{'cfg'};

    # íÑWv
    my ( $recordlist, $totalrecord, $camps, $roles ) = &SumUserRecord($sow);

    # [U[îñÌHTMLoÍ
    require "$cfg->{'DIR_HTML'}/html.pl";
    require "$cfg->{'DIR_HTML'}/html_profile.pl";
    &SWHtmlProfile::OutHTMLProfile( $sow, $recordlist, $totalrecord, $camps, $roles );
}

#----------------------------------------
# íÑWv
#----------------------------------------
sub SumUserRecord {
    my $sow   = shift;
    my $query = $sow->{'query'};
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_record.pl";

    my @camps;
    my $campcount;
    for ( $campcount = 0 ; $campcount <= $sow->{'COUNT_CAMP'} ; $campcount++ ) {
        push( @camps, &NewRecordHash() );
    }

    my @roles;
    my $rolecount;
    for ( $rolecount = 0 ; $rolecount < $sow->{'COUNT_ROLE'} ; $rolecount++ ) {
        push( @roles, &NewRecordHash() );
    }

    my $record;
    my @recordlist;
    my $recordlist  = \@recordlist;
    my $totalrecord = &NewRecordHash();

    if ( -w $sow->{'cfg'}->{'DIR_RECORD'} ) {
        $record = SWUserRecord->new( $sow, $query->{'prof'} );
        $record->close();

        $recordlist = $record->{'file'}->getlist();
        foreach (@$recordlist) {
            next if ( $_->{'win'} <= 0 );
            next if ( $_->{'live'} eq 'suddendead' );    # ËRÍWvÎÛO

            # íÑWv
            &AddRecordSingle( $totalrecord, $_ );

            # wcÊíÑWv
            if ( $_->{'lovers'} ne '/' ) {
                &AddRecordSingle( $camps[ $sow->{'ROLECAMP'}[ $_->{'sow'}->{'ROLEID_CUPID'} ] - 1 ], $_ );
            }
            else {
                &AddRecordSingle( $camps[ $sow->{'ROLECAMP'}[ $_->{'role'} ] ], $_ );
            }

            # ðEÊíÑWv
            &AddRecordSingle( $roles[ $_->{'role'} ], $_ );
        }
    }

    return ( $recordlist, $totalrecord, \@camps, \@roles );
}

#----------------------------------------
# íÑWvpnbVÌæ¾
#----------------------------------------
sub NewRecordHash {
    my %recordhash = (
        win       => 0,
        lose      => 0,
        draw      => 0,
        total     => 0,
        livecount => 0,
        liveday   => 0,
    );
    return \%recordhash;
}

#----------------------------------------
# íÑWviwcÊ^ðEÊj
#----------------------------------------
sub AddRecordSingle {
    my ( $data, $record ) = @_;

    $data->{'total'}++;
    $data->{'win'}++       if ( $record->{'win'} == 1 );
    $data->{'lose'}++      if ( $record->{'win'} == 2 );
    $data->{'draw'}++      if ( $record->{'win'} == 0 );
    $data->{'livecount'}++ if ( $record->{'live'} eq 'live' );
    $data->{'liveday'} += $record->{'liveday'};
}

1;
