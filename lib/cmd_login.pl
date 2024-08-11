package SWCmdLogin;

#----------------------------------------
# ƒƒOƒCƒ“
#----------------------------------------
sub CmdLogin {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # ƒf[ƒ^ˆ—
    &SetDataCmdLogin($sow);

    # HTTPo—Í
    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'uid'} = '';
    $reqvals->{'pwd'} = '';
    $reqvals->{'cmd'} = $query->{'cmdfrom'} if ( $query->{'cmdfrom'} ne '' );
    my $link = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = '?' . $link if ( $link ne '' );
    $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}$link";
    $link .= '#newinfo' if ( defined( $query->{'vid'} ) );

    $sow->{'http'}->{'location'} = "$link";
    $sow->{'http'}->outheader();
    $sow->{'http'}->outfooter();

    return;
}

#----------------------------------------
# ƒf[ƒ^ˆ—
#----------------------------------------
sub SetDataCmdLogin {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $user  = $sow->{'user'};

    my $matchpw = $user->login();
    if ( $matchpw > 0 ) {

        # ƒpƒXƒ[ƒhÆ‡¬Œ÷
        $user->setcookie( $sow->{'setcookie'} );
    }
    elsif ( ( $matchpw < 0 ) && ( $query->{'pwd'} ne '' ) ) {

        # ƒ†[ƒU[ƒf[ƒ^V‹Kì¬
        $user->createuser( $query->{'uid'}, $query->{'pwd'} );
        $user->setcookie( $sow->{'setcookie'} );
    }
    $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Login. [$query->{'uid'}]" );

    return;
}

1;
