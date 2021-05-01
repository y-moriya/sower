package SWHtmlPreviewPC;

#----------------------------------------
# �����v���r���[HTML�̕\��
#----------------------------------------
sub OutHTMLPreviewPC {
    my ( $sow, $vil, $log, $preview ) = @_;
    my $cfg   = $sow->{'cfg'};
    my $query = $sow->{'query'};
    my $curpl = &SWBase::GetCurrentPl( $sow, $vil );

    require "$sow->{'cfg'}->{'DIR_HTML'}/html_vlogsingle_pc.pl";

    # �͂ݏo�������̏���
    my $srcmes = $log->{'log'};    # �폜�O�̔���
    $srcmes =~ s/(<br( \/)?>)*$//ig;

    my $trimedlog = &SWString::GetTrimString( $sow, $vil, $srcmes );
    my $len       = length($trimedlog);
    $log->{'log'} = substr( $srcmes, 0, $len );
    my $deletedmes = substr( $srcmes, $len );
    $log->{'log'} .= "<span class=\"infotext\">$deletedmes</span>"
      if ( $deletedmes ne '' );

    $sow->{'html'} = SWHtml->new($sow);           # HTML���[�h�̏�����
    my $net     = $sow->{'html'}->{'net'};        # Null End Tag
    my $outhttp = $sow->{'http'}->outheader();    # HTTP�w�b�_�̏o��
    return if ( $outhttp == 0 );                  # �w�b�_�o�͂̂�
    $sow->{'html'}->outheader('�����̃v���r���[');        # HTML�w�b�_�̏o��
    $sow->{'html'}->outcontentheader();

    &SWHtmlPC::OutHTMLLogin($sow);                # ���O�C�����̏o��

    my $titleupdate = &SWHtmlPC::GetTitleNextUpdate( $sow, $vil );
    print <<"_HTML_";
<h2>$query->{'vid'} $vil->{'vname'}$titleupdate</h2>

<h3>�����̃v���r���[</h3>

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
_HTML_

    # �딚����
    if (   ( &SWBase::CheckWriteSafetyRole( $sow, $vil ) > 0 )
        && ( $log->{'mestype'} == $sow->{'MESTYPE_SAY'} )
        && ( $vil->isepilogue() == 0 ) )
    {
        print <<"_HTML_";
<div class="previewsafety">
  <p class="cautiontext"><strong>���̔����͒ʏ픭���ł��B�����~�X�ɒ��ӁI</strong></p>
  <label><input type="checkbox" name="safety" value="on"$net>�ʏ픭���ŊԈႢ�Ȃ���΃`�F�b�N</label>
</div>

_HTML_
    }

    # ���������̕\��
    my %logfile = ();
    my %logidx  = ();
    my %anchor  = (
        logfile => \%logfile,
        logidx  => \%logidx,
        rowover => 1,
    );
    $log->{'log'} = &SWLog::ReplacePreviewAnchor( $sow, $vil, $log );
    &SWHtmlVlogSinglePC::OutHTMLSingleLogPC( $sow, $vil, $log, -1, 0, \%anchor,
        1 );

    # �����l����
    $query->{'mes'} =~ s/<br( \/)?>/&#13\;/ig;
    my @reqkeys = (
        'csid_cid', 'role',      'mes',        'think',
        'wolf',     'maker',     'admin',      'sympathy',
        'werebat',  'monospace', 'expression', 'guest',
        'loud'
    );
    push( @reqkeys, 'entrypwd' ) if ( $vil->{'entrylimit'} eq 'password' );
    my $reqvals = &SWBase::GetRequestValues( $sow, \@reqkeys );
    my $hidden  = &SWBase::GetHiddenValues( $sow, $reqvals, '  ' );

    # �s���̎擾
    my @lineslog      = split( '<br>', $srcmes );
    my $lineslogcount = @lineslog;

    # �������̎擾
    my $countsrc = &SWString::GetCountStr( $sow, $vil, $srcmes );
    my $countmes = &SWString::GetCountStr( $sow, $vil, $trimedlog );

    # �s���^�����������x��
    my $saycnt = $cfg->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} };
    if ( $lineslogcount > $saycnt->{'MAX_MESLINE'} ) {
        print
"<p class=\"cautiontext\">�s�����������܂��i$lineslogcount�s�j�B$saycnt->{'MAX_MESLINE'}�s�ȓ��Ɏ��߂Ȃ��Ɛ������������܂�܂���B</p>\n";
    }
    elsif ( $countsrc > $saycnt->{'MAX_MESCNT'} ) {
        my $unitcaution =
          $sow->{'basictrs'}->{'SAYTEXT'}
          ->{ $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} }
              ->{'COUNT_TYPE'} }->{'UNIT_CAUTION'};
        print
"<p class=\"cautiontext\">�������������܂��i$countsrc$unitcaution�j�B$countmes$unitcaution�ȓ��Ɏ��߂Ȃ��Ɛ������������܂�܂���B</p>\n";
    }

    # �����ɂ���ď�����pt���̕\��
    my $point = &SWBase::GetSayPoint( $sow, $vil, $trimedlog );
    my ( $mestype, $saytype ) = &SWWrite::GetMesType( $sow, $vil, $curpl );
    my $unitsay =
      $sow->{'basictrs'}->{'SAYTEXT'}
      ->{ $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} }
          ->{'COUNT_TYPE'} }->{'UNIT_SAY'};
    my $pointtext = '';
    if (   ( $saycnt->{'COUNT_TYPE'} ne 'count' )
        && ( $sow->{'query'}->{'cmd'} ne 'entrypr' )
        && ( defined( $sow->{'curpl'}->{$saytype} ) ) )
    {
        $pointtext =
          "�i$point$unitsay���� / ����$sow->{'curpl'}->{$saytype}$unitsay�j";
    }

    # �����{�^���̕\��
    print <<"_HTML_";
<p class="paragraph">������������݂܂����H$pointtext</p>

<p class="multicolumn_label">
  <input type="hidden" name="cmd" value="$preview->{'cmd'}"$net>
  <input type="hidden" name="cmdfrom" value="$query->{'cmd'}"$net>$hidden
  <input type="submit" value="��������"$net>
</p>
</form>
_HTML_

    if (   ( $preview->{'cmd'} ne 'entry' )
        && ( $query->{'admin'} eq '' )
        && ( $query->{'maker'} eq '' )
        && ( $query->{'guest'} eq '' ) )
    {
        print <<"_HTML_";

<form action="$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}" method="$cfg->{'METHOD_FORM'}">
<p class="multicolumn_left">
  <input type="hidden" name="cmd" value="editmes"$net>$hidden
  <input type="submit" value="�C������"$net>
</p>
</form>
_HTML_
    }

    print <<"_HTML_";
<div class="multicolumn_clear">
  <hr class="invisible_hr"$net>
</div>

_HTML_

    &SWHtmlPC::OutHTMLReturnPC($sow);

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();    # HTML�t�b�^�̏o��
    $sow->{'http'}->outfooter();

    return;
}

1;
