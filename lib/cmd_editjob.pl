package SWCmdEditJobName;

#----------------------------------------
# �������ύX
#----------------------------------------
sub CmdEditJobName {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # �f�[�^����
    my $vil = &SetDataCmdExtend($sow);

    # HTTP/HTML�o��
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

    $sow->{'http'}->{'location'} = "$link";
    $sow->{'http'}->outheader();    # HTTP�w�b�_�̏o��
    $sow->{'http'}->outfooter();
}

#----------------------------------------
# �f�[�^����
#----------------------------------------
sub SetDataCmdExtend {
    my $sow     = $_[0];
    my $query   = $sow->{'query'};
    my $debug   = $sow->{'debug'};
    my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

    # ���f�[�^�̓ǂݍ���
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # ���\�[�X�̓ǂݍ���
    &SWBase::LoadVilRS( $sow, $vil );

    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, '�i�s���͌�����ύX�ł��܂���B', "jobname can not change.[$sow->{'uid'}]" )
      if ( $vil->{'turn'} > 0 );

    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, '�����������ł��B', "jobname not change.[$sow->{'uid'}]" )
      if ( $sow->{'curpl'}->{'jobname'} eq $query->{'jobname'} );

    # �ύX�O�̃L��������ۑ�
    my $oldchrname = $sow->{'curpl'}->getchrname();

    # �ύX����
    $sow->{'curpl'}->{'jobname'} = $query->{'jobname'};

    require "$sow->{'cfg'}->{'DIR_LIB'}/log.pl";
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_log.pl";

    my $newchrname = $sow->{'curpl'}->getchrname();
    my $logfile    = SWBoa->new( $sow, $vil, $vil->{'turn'}, 0 );
    my $changemes  = $sow->{'textrs'}->{'ANNOUNCE_EDITJOB'};
    $changemes =~ s/_OLDNAME_/$oldchrname/g;
    $changemes =~ s/_NEWNAME_/$newchrname/g;
    $logfile->writeinfo( '', $sow->{'MESTYPE_INFONOM'}, $changemes );

    $sow->{'debug'}->writeaplog( $sow->{'APLOG_POSTED'}, "Edit jobname. [$sow->{'curpl'}->{'uid'}]" );
    $logfile->close();
    $vil->writevil();
    $vil->closevil();

    return $vil;
}

1;
