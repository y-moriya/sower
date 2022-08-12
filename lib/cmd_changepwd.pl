package SWCmdChangePwd;

#----------------------------------------
# パスワード変更
#----------------------------------------
sub CmdChangePwd {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # データ処理
    &SetDataCmdChangePwd($sow);

    # HTTP出力
    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'uid'} = '';
    $reqvals->{'pwd'} = '';
    my $link = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = '?' . $link if ( $link ne '' );
    $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}$link";

    $sow->{'http'}->{'location'} = "$link";
    $sow->{'http'}->outheader();
    $sow->{'http'}->outfooter();

    return;
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdChangePwd {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $user  = $sow->{'user'};

    my $matchpw = $user->login();
    if ( $matchpw > 0 ) {

        $sow->{'debug'}->writeaplog( $sow->{'APLOG_OTHERS'},
            "SetDataCmdChangePwd newpwd: $query->{'newpwd'}, confirm: $query->{'confirm'}" );

        if ( $query->{'newpwd'} ne $query->{'confirm'} ) {
            $sow->{'debug'}->raise(
                $sow->{'APLOG_NOTICE'},
                "確認用パスワードが異なります。",
                "newpwd and confirm are not same."
            );
        }

        my $newpwdlength = length( $query->{'newpwd'} );
        $sow->{'debug'}->raise(
            $sow->{'APLOG_NOTICE'},
"新しいパスワードは $sow->{'cfg'}->{'NEW_MAXSIZE_PASSWD'} バイト以内で入力して下さい（$newpwdlength バイト）。",
            "newpwd too long."
        ) if ( $newpwdlength > $sow->{'cfg'}->{'NEW_MAXSIZE_PASSWD'} );
        $sow->{'debug'}->raise(
            $sow->{'APLOG_NOTICE'},
"新しいパスワードは $sow->{'cfg'}->{'NEW_MINSIZE_PASSWD'} バイト以上で入力して下さい（$newpwdlength バイト）。",
            "newpwd too short."
        ) if ( $newpwdlength < $sow->{'cfg'}->{'NEW_MINSIZE_PASSWD'} );

        # パスワード照合成功
        # パスワード変更処理
        $user->openuser(1);
        $user->{'pwd'} = crypt( $query->{'newpwd'}, $query->{'newpwd'} );
        $user->writeuser();
        $user->closeuser();
        $user->setnewcookie( $sow->{'setcookie'} );

        $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Change Password. [$sow->{'uid'}]" );

        # HTML出力
        require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
        require "$sow->{'cfg'}->{'DIR_HTML'}/html_changepwd.pl";
        &SWHtmlChangePwd::OutHTMLChangePwd($sow);
    }
    elsif ( $matchpw < 0 ) {

        # パスワード照合失敗
        $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Change Password is failed. [$sow->{'uid'}]" );
    }
    else {
        $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Unexpected error has occured. [$sow->{'uid'}]" );
    }

    return;
}

1;
