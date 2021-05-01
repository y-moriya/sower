package SWHtmlMemoMb;

#----------------------------------------
# �����\���i���o�C�����[�h�j��HTML�o��
#----------------------------------------
sub OutHTMLMemoMb {
    my ( $sow, $vil, $logfile, $memofile, $maxrow, $logs, $logkeys, $rows ) =
      @_;

    my $net    = $sow->{'html'}->{'net'};      # Null End Tag
    my $amp    = $sow->{'html'}->{'amp'};
    my $atr_id = $sow->{'html'}->{'atr_id'};
    my $cfg    = $sow->{'cfg'};
    my $query  = $sow->{'query'};

    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$link";

    $sow->{'html'}->outcontentheader();

    # ��d�������ݒ���
    if ( $sow->{'query'}->{'cmdfrom'} eq 'wrmemo' ) {
        print <<"_HTML_";
<font color="red">����d�������ݒ��Ӂ�</font><br$net>
�����[�h����ꍇ�́u�V�v���g���ĉ������B
<hr$net>
_HTML_
    }

    # ����
    my $date        = $sow->{'dt'}->cvtdt( $vil->{'nextupdatedt'} );
    my $titleupdate = " ($date �ɍX�V)";

    # ���o���i������RSS�j
    print "<a $atr_id=\"top\">$query->{'vid'} $vil->{'vname'}<br$net>\n";

    # �L�������\��
    if ( defined( $sow->{'curpl'}->{'uid'} ) ) {
        my $chrname  = $sow->{'curpl'}->getchrname();
        my $rolename = '';
        $rolename =
          "($sow->{'textrs'}->{'ROLENAME'}->[$sow->{'curpl'}->{'role'}])"
          if ( $sow->{'curpl'}->{'role'} > 0 );
        print "$chrname$rolename<br$net>\n";
    }

    # ���t�ʃ��O�ւ̃����N
    my $list = $memofile->getmemolist();
    &SWHtmlMb::OutHTMLTurnNaviMb( $sow, $vil, 0, $logs, $list, $rows );

    if ( defined( $logs->[0]->{'pos'} ) ) {
        if ( ( $query->{'order'} eq 'desc' ) || ( $query->{'order'} eq 'd' ) ) {

            # �~��
            my $i;
            for ( $i = $#$logs ; $i >= 0 ; $i-- ) {
                &OutHTMLMemoSingleMb( $sow, $vil, $logfile, $memofile,
                    $logs->[$i] );
            }
        }
        else {
            # ����
            foreach (@$logs) {
                &OutHTMLMemoSingleMb( $sow, $vil, $logfile, $memofile, $_ );
            }
        }
    }
    else {
        print <<"_HTML_";
�����͂���܂���B
<hr$net>
_HTML_
    }

    # ���t�ʃ��O�ւ̃����N
    &SWHtmlMb::OutHTMLTurnNaviMb( $sow, $vil, 1, $logs, $list, $rows );

    $sow->{'html'}->outcontentfooter();

    return;
}

#----------------------------------------
# ������HTML�\���i�P�������j
#----------------------------------------
sub OutHTMLMemoSingleMb {
    my ( $sow, $vil, $logfile, $memofile, $log ) = @_;
    my $query = $sow->{'query'};
    my $net   = $sow->{'html'}->{'net'};

    my $memo    = $memofile->read( $log->{'pos'} );
    my $curpl   = $vil->getpl( $memo->{'uid'} );
    my $chrname = $memo->{'chrname'};
    $chrname = "$chrname (�����o�܂���)"
      if ( ( !defined( $curpl->{'entrieddt'} ) )
        || ( $curpl->{'entrieddt'} > $memo->{'date'} ) );
    my $mes = $memo->{'log'};
    $mes = '�i�������͂������j' if ( $memo->{'mestype'} == $sow->{'MEMOTYPE_DELETED'} );
    my %logkeys;
    my %anchor = (
        logfile => $logfile,
        logkeys => \%logkeys,
        rowover => 1,
    );
    $mes = &SWLog::ReplaceAnchorHTMLMb( $sow, $vil, $mes, \%anchor );
    &SWHtml::ConvertNET( $sow, \$mes );
    my $date     = $sow->{'dt'}->cvtdtmb( $memo->{'date'} );
    my $memodate = '';
    $memodate = " $date" if ( $query->{'cmd'} eq 'hist' );

    print <<"_HTML_";
$chrname$memodate<br$net>
$mes
<hr$net>
_HTML_
}

1;
