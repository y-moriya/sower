package SWCmdChangePwd;

#----------------------------------------
# �p�X���[�h�ύX
#----------------------------------------
sub CmdChangePwd {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # �f�[�^����
    &SetDataCmdChangePwd($sow);

    # HTTP�o��
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
# �f�[�^����
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
                "�m�F�p�p�X���[�h���قȂ�܂��B",
                "newpwd and confirm are not same."
            );
        }

        my $newpwdlength = length( $query->{'newpwd'} );
        $sow->{'debug'}->raise(
            $sow->{'APLOG_NOTICE'},
"�V�����p�X���[�h�� $sow->{'cfg'}->{'NEW_MAXSIZE_PASSWD'} �o�C�g�ȓ��œ��͂��ĉ������i$newpwdlength �o�C�g�j�B",
            "newpwd too long."
        ) if ( $newpwdlength > $sow->{'cfg'}->{'NEW_MAXSIZE_PASSWD'} );
        $sow->{'debug'}->raise(
            $sow->{'APLOG_NOTICE'},
"�V�����p�X���[�h�� $sow->{'cfg'}->{'NEW_MINSIZE_PASSWD'} �o�C�g�ȏ�œ��͂��ĉ������i$newpwdlength �o�C�g�j�B",
            "newpwd too short."
        ) if ( $newpwdlength < $sow->{'cfg'}->{'NEW_MINSIZE_PASSWD'} );

        # �p�X���[�h�ƍ�����
        # �p�X���[�h�ύX����
        $user->openuser(1);
        $user->{'pwd'} = crypt( $query->{'newpwd'}, $query->{'newpwd'} );
        $user->writeuser();
        $user->closeuser();
        $user->setnewcookie( $sow->{'setcookie'} );

        $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Change Password. [$sow->{'uid'}]" );

        # HTML�o��
        require "$sow->{'cfg'}->{'DIR_HTML'}/html.pl";
        require "$sow->{'cfg'}->{'DIR_HTML'}/html_changepwd.pl";
        &SWHtmlChangePwd::OutHTMLChangePwd($sow);
    }
    elsif ( $matchpw < 0 ) {

        # �p�X���[�h�ƍ����s
        $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Change Password is failed. [$sow->{'uid'}]" );
    }
    else {
        $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Unexpected error has occured. [$sow->{'uid'}]" );
    }

    return;
}

1;
