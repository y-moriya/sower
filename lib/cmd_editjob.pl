package SWCmdEditJobName;

#----------------------------------------
# 肩書き変更
#----------------------------------------
sub CmdEditJobName {
    my $sow   = $_[0];
    my $query = $sow->{'query'};
    my $cfg   = $sow->{'cfg'};

    # データ処理
    my $vil = &SetDataCmdExtend($sow);

    # HTTP/HTML出力
    my $reqvals = &SWBase::GetRequestValues($sow);
    my $link    = &SWBase::GetLinkValues( $sow, $reqvals );
    $link = "$cfg->{'URL_SW'}/$cfg->{'FILE_SOW'}?$link#newsay";

    $sow->{'http'}->{'location'} = "$link";
    $sow->{'http'}->outheader();    # HTTPヘッダの出力
    $sow->{'http'}->outfooter();
}

#----------------------------------------
# データ処理
#----------------------------------------
sub SetDataCmdExtend {
    my $sow     = $_[0];
    my $query   = $sow->{'query'};
    my $debug   = $sow->{'debug'};
    my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

    # 村データの読み込み
    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
    my $vil = SWFileVil->new( $sow, $query->{'vid'} );
    $vil->readvil();

    # リソースの読み込み
    &SWBase::LoadVilRS( $sow, $vil );

    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, '進行中は肩書を変更できません。', "jobname can not change.[$sow->{'uid'}]" )
      if ( $vil->{'turn'} > 0 );

    $sow->{'debug'}->raise( $sow->{'APLOG_NOTICE'}, '肩書が同じです。', "jobname not change.[$sow->{'uid'}]" )
      if ( $sow->{'curpl'}->{'jobname'} eq $query->{'jobname'} );

    # 変更前のキャラ名を保存
    my $oldchrname = $sow->{'curpl'}->getchrname();

    # 変更処理
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
