package SWHtmlSayFilter;

#----------------------------------------
# �����t�B���^�̕\��
#----------------------------------------
sub OutHTMLSayFilter {
    my ( $sow, $vil ) = @_;
    my $cfg    = $sow->{'cfg'};
    my $net    = $sow->{'html'}->{'net'};
    my $atr_id = $sow->{'html'}->{'atr_id'};
    my $pllist = $vil->getpllist();

    my $i;

    my $style_inline                = ' style="display: inline;"';
    my $class_sayfilter             = 'sayfilter';
    my $style_button_mvfilterleft   = $style_inline;
    my $style_button_mvfilterbottom = '';
    my $style_button_fixfilter      = '';
    my $style_button_unfixfilter    = '';
    if ( $sow->{'filter'}->{'layoutfilter'} eq '1' ) {
        $class_sayfilter             = 'sayfilterleft';
        $style_button_mvfilterleft   = '';
        $style_button_mvfilterbottom = $style_inline;

        if ( $sow->{'filter'}->{'fixfilter'} eq '1' ) {
            $style_button_unfixfilter = $style_inline;
        }
        else {
            $style_button_fixfilter = $style_inline;
        }
    }

    print <<"_HTML_";
<div id="sayfilter" class="$class_sayfilter">
<div id="insayfilter" class="insayfilter">

<h3 id="filter_header" class="sayfilter_heading">
  <img id="button_mvfilterleft" class="sayfilter_button"$style_button_mvfilterleft src="$cfg->{'DIR_IMG'}/mvfilter_left.png" width="16" height="16" alt="��" title="�t�B���^�����ɔz�u" onclick="moveFilterLeft(); fixFilter();" onkeypress="moveFilterLeft(); fixFilter();"$net>
  <img id="button_mvfilterbottom" class="sayfilter_button"$style_button_mvfilterbottom src="$cfg->{'DIR_IMG'}/mvfilter_bottom.png" width="16" height="16" alt="��" title="�t�B���^�����ɔz�u" onclick="moveFilterBottom();" onkeypress="moveFilterBottom();"$net>
  <img id="button_fixfilter" class="sayfilter_button"$style_button_fixfilter src="$cfg->{'DIR_IMG'}/mvfilter_fix.png" width="16" height="16" alt="��" title="�t�B���^���Œ�" onclick="fixFilter();" onkeypress="fixFilter();"$net>
  <img id="button_unfixfilter" class="sayfilter_button"$style_button_unfixfilter src="$cfg->{'DIR_IMG'}/mvfilter_unfix.png" width="16" height="16" alt="��" title="�t�B���^�̌Œ������" onclick="unfixFilter();" onkeypress="unfixFilter();"$net>
�t�B���^</h3>

<div class="paragraph">

_HTML_

    &OutHTMLSayFilterPlayers( $sow, $vil, 'live' );
    &OutHTMLSayFilterPlayers( $sow, $vil, 'victim' );
    &OutHTMLSayFilterPlayers( $sow, $vil, 'executed' );
    &OutHTMLSayFilterPlayers( $sow, $vil, 'suddendead' );

    print "</div>\n\n";

    print "<div class=\"paragraph\">\n";

    my $display = '';
    my $enable  = 'enable';
    if ( $sow->{'filter'}->{'mestypes'} eq '1' ) {
        $display = ' style="display: none;"';
        $enable  = 'disenable';
    }

    print "<h4 id=\"mestypefiltercaption\" ";
    print "class=\"sayfilter_caption_$enable\" ";
    print "title=\"������ʗ���" . '�\���^��\��" ';
    print "onclick=\"changeFilterMesType();\" ";
    print ">�������";
    print "</h4>\n";

    print <<"_HTML_";
<div id="mestypefilter" class="sayfilter_content"$display>
_HTML_

    my @logmestypearray = (
        { type => 'S', text => '�ʏ픭��' },
        { type => 'T', text => '�Ƃ茾' },
        { type => 'W', text => '�T�̚���' },
        { type => 'G', text => '���҂̂��߂�' },
        { type => 'P', text => '����' },
        { type => 'B', text => '�O�b' },
        { type => 'U', text => '�T�ώҔ���' },
        { type => 'L', text => '���̚���' },
        { type => 'M', text => '�����Đl����' },
        { type => 'A', text => '�Ǘ��Ҕ���' },
        { type => 'I', text => '�V�X�e��(���J)' },
        { type => 'i', text => '�V�X�e��(����J)' },
        { type => 'D', text => '�폜����' },
        { type => 'd', text => '�폜����(�Ǘ���)' },
    );

    for my $elem (@logmestypearray) {
        my $enable = 'enable';
        $enable = 'disenable'
          if ( $sow->{'filter'}->{'typefilter'}->[$i] eq '1' );
        print "  <div id=\"typefilter_$elem->{'type'}\"";
        print " class=\"sayfilter_content_$enable\"";
        print " onclick=\"changeFilterByCheckBoxMesType('$elem->{'type'}');\"";

        print "><div class=\"sayfilter_incontent\">";
        print "<input id=\"checktypefilter_$elem->{'type'}\"";
        print " $atr_id=\"checktypefilter_$elem->{'type'}\""
          if ( $atr_id ne 'id' );
        print " style=\"display: none;\"";
        print " type=\"checkbox\"";
        print " $sow->{'html'}->{'checked'}"
          if ( $sow->{'filter'}->{'typefilter'}->[$i] ne '1' );
        print "$net>$elem->{'text'}";
        print "</div></div>\n";
    }

    $display = '';
    $enable  = 'enable';
    if ( $sow->{'filter'}->{'lumpfilter'} eq '1' ) {
        $display = ' style="display: none;"';
        $enable  = 'disenable';
    }

    print <<"_HTML_";
</div>
</div>

<div class="paragraph">
<h4 id="lumpfiltercaption" class="sayfilter_caption_$enable" title="�ꊇ���엓�̕\\���^��\\��" onclick="changeFilterLump();">�ꊇ����</h4>
<div id="lumpfilter"$display>
  <button class="sayfilter_button_lump" onclick="changePlListAll(0);" value="0">�S���\\��</button><br$net>
  <button class="sayfilter_button_lump" onclick="changePlListAll(1);" value="1">�S����\\��</button><br$net>
  <button class="sayfilter_button_lump" onclick="changePlListAll(2);" value="2">���]�\\��</button><br$net>
</div>
</div>

</div><!-- insayfilter footer -->
</div><!-- sayfilter footer -->

_HTML_

    print <<"_HTML_";
<script type="text/javascript" for="window" event="onscroll">
	window.onScroll = eventFixFilter();
</script>

_HTML_

    return;
}

#----------------------------------------
# �����t�B���^�̐l�����̕\��
#----------------------------------------
sub OutHTMLSayFilterPlayers {
    my ( $sow, $vil, $livetype ) = @_;
    my $net    = $sow->{'html'}->{'net'};
    my $atr_id = $sow->{'html'}->{'atr_id'};
    my $pllist = $vil->getpllist();
    my @filterlist;
    foreach (@$pllist) {
        push( @filterlist, $_ ) if ( $_->{'live'} eq $livetype );
        if ( $livetype eq 'victim' ) {
            push( @filterlist, $_ )
              if ( ( $_->{'live'} eq 'cursed' )
                || ( $_->{'live'} eq 'rcursed' )
                || ( $_->{'live'} eq 'suicide' ) );
        }
    }

    my %livetypetext = (
        'live'       => '������',
        'victim'     => '�]����',
        'executed'   => '���Y��',
        'suddendead' => '�ˑR����',
    );
    my %livetypeno = (
        'live'       => 0,
        'victim'     => 1,
        'executed'   => 2,
        'suddendead' => 3,
    );
    my $filtercnt = @filterlist;

    my $enable  = 'enable';
    my $display = '';
    if ( $sow->{'filter'}->{'livetypes'}->[ $livetypeno{$livetype} ] eq '1' ) {
        $enable  = 'disenable';
        $display = ' style="display: none;"';
    }
    print "<h4 class=\"sayfilter_caption_$enable\" ";
    print "id=\"livetypecaption_$livetypeno{$livetype}\" ";
    print "title=\"$livetypetext{$livetype}����" . '�\���^��\��" ';
    print "onclick=\"changeFilterPlList($livetypeno{$livetype});\">";
    print "$livetypetext{$livetype} ($filtercnt)";
    print "</h4>\n";

    print "<div id=\"livetype$livetypeno{$livetype}\" class=\"sayfilter_content\"$display>\n"
      if ( @filterlist > 0 );

    my $i = 0;
    $display    = '';
    @filterlist = sort { $a->{'deathday'} <=> $b->{'deathday'} or $a->{'pno'} <=> $b->{'pno'} } @filterlist
      if ( $livetype ne 'live' );
    foreach (@filterlist) {
        my $enable  = 'enable';
        my $checked = " $sow->{'html'}->{'checked'}";
        if ( $sow->{'filter'}->{'pnofilter'}->[ $_->{'pno'} ] eq '1' ) {
            $enable  = 'disenable';
            $checked = '';
        }

        my $logined = $sow->{'user'}->logined();
        my $unit =
          $sow->{'basictrs'}->{'SAYTEXT'}->{ $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} }->{'COUNT_TYPE'} }
          ->{'UNIT_SAY'};
        my $shortchrname =
          $sow->{'charsets'}->getshortchrname( $_->{'csid'}, $_->{'cid'} );
        my $showid = "";
        $showid = " ($_->{'uid'})"
          if (
               $vil->isepilogue() != 0
            || ( $vil->{'showid'} > 0 )
            || (   ( $logined > 0 )
                && ( $sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'} ) )
          );
        my $rolename = '';
        $rolename = " [$sow->{'textrs'}->{'ROLENAME'}->[$_->{'role'}]]"
          if ( $_->{'role'} > 0 );
        my $live = 'live';
        $live = $sow->{'curpl'}->{'live'}
          if ( defined( $sow->{'curpl'}->{'live'} ) );
        my $showall = "";
        $showall = " $rolename"
          if (
               $vil->isepilogue() != 0
            || ( $vil->{'showall'} > 0 && $live ne 'live' )
            || (   ( $logined > 0 )
                && ( $sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'} ) )
          );
        print "  <div id=\"livetype$livetypeno{$livetype}_$i\"$display>";
        print "<div id=\"pnofilter_$_->{'pno'}\"";
        print " class=\"sayfilter_content_$enable\"";
        print " onclick=\"changeFilterByPlList($_->{'pno'});\"";

        #		print " onkeydown=\"changeFilterByPlList($_->{'pno'});\"";
        print "><div class=\"sayfilter_incontent\"><input";
        print " id=\"checkpnofilter_$_->{'pno'}\"";
        print " $atr_id=\"chkpnofilter_$_->{'pno'}\"" if ( $atr_id ne 'id' );
        print " style=\"display: none;\"";
        print " type=\"checkbox\"";
        print "$checked$net>$shortchrname$showid$showall";
        print " ($_->{'deathday'}d)" if ( $livetype ne 'live' );

        if (   ( $livetype eq 'live' )
            || ( $live ne 'live' )
            || $vil->isepilogue() != 0 )
        {
            my $restsay = $_->{'say'};
            $restsay = $_->{'gsay'} if ( $_->{'live'} ne 'live' );
            $restsay = $_->{'psay'} if ( $vil->{'turn'} == 0 );
            $restsay = $_->{'esay'} if ( $vil->isepilogue() != 0 );
            my $restaddpt = "";
            if (
                ( $vil->{'nocandy'} == 0 )
                && (   ( $vil->{'noactmode'} == 0 )
                    || ( $vil->{'noactmode'} == 2 ) )
              )
            {
                if ( $_->{'actaddpt'} > 4 ) {
                    $small = $_->{'actaddpt'} % $sow->{'cfg'}->{'CANDY_LS'};
                    $large = ( $_->{'actaddpt'} - $small ) / $sow->{'cfg'}->{'CANDY_LS'};
                    $restaddpt =
"<img src=\"$sow->{'cfg'}->{'DIR_IMG'}/candy_s.png\" width=\"8\" height=\"8\" alt=\"��\" title=\"��\">"
                      x $small;
                    $restaddpt .=
"<img src=\"$sow->{'cfg'}->{'DIR_IMG'}/candy_l.png\" width=\"16\" height=\"16\" alt=\"���i��j\" title=\"���i��j\">"
                      x $large;
                }
                elsif ( $_->{'actaddpt'} > 0 ) {
                    $restaddpt =
"<img src=\"$sow->{'cfg'}->{'DIR_IMG'}/candy_s.png\" width=\"8\" height=\"8\" alt=\"��\" title=\"��\">"
                      x $_->{'actaddpt'};
                }
            }
            print "<div style=\"text-align: right;\">$_->{'saidcount'}�� �c$restsay$unit $restaddpt</div>";
        }
        print "</div>";
        print "</div>";
        print "</div>\n";
        $i++;
    }

    print "</div>\n" if ( @filterlist > 0 );
    print "\n";

    return;
}

1;
