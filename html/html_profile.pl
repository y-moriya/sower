package SWHtmlProfile;

#----------------------------------------
# ���[�U�[����HTML�o��
#----------------------------------------
sub OutHTMLProfile {
    my ( $sow, $recordlist, $totalrecord, $camps, $roles ) = @_;
    my $cfg    = $sow->{'cfg'};
    my $query  = $sow->{'query'};
    my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";

    undef( $query->{'vid'} );

    my $user = SWUser->new($sow);
    $user->{'uid'} = $query->{'prof'};
    $user->openuser(1);
    $user->closeuser();

    my $nospaceprof = $query->{'prof'};
    $nospaceprof =~ s/^ *//;
    $nospaceprof =~ s/ *$//;
    $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "���[�U�[ID���w�肵�ĉ������B", "no prof." )
      if ( length($nospaceprof) == 0 );

    # �e�L�X�g���\�[�X�̓Ǎ�
    my %vil = ( trsid => $sow->{'cfg'}->{'DEFAULT_TEXTRS'}, );
    &SWBase::LoadTextRS( $sow, \%vil );

    # HTML�̏o��
    $sow->{'html'} = SWHtml->new($sow);                        # HTML���[�h�̏�����
    my $net = $sow->{'html'}->{'net'};                         # Null End Tag
    $sow->{'http'}->outheader();                               # HTTP�w�b�_�̏o��
    $sow->{'html'}->outheader("$query->{'prof'}����̃��[�U�[���");    # HTML�w�b�_�̏o��
    $sow->{'html'}->outcontentheader();

    &SWHtmlPC::OutHTMLLogin($sow);                             # ���O�C�����̏o��

    my $reqvals = &SWBase::GetRequestValues($sow);
    $reqvals->{'cmd'} = 'editprofform';
    my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
    my $linkedit  = '';
    $linkedit = " <a href=\"$urlsow?$linkvalue\">�ҏW</a>"
      if ( $sow->{'uid'} eq $query->{'prof'} );

    my $handlename = '���o�^';
    $handlename = $user->{'handlename'} if ( $user->{'handlename'} ne '' );

    my $url = '���o�^';
    $url = $user->{'url'} if ( $user->{'url'} ne '' );
    $url = "<a href=\"$user->{'url'}\">$user->{'url'}</a>"
      if ( ( index( $user->{'url'}, 'http://' ) == 0 )
        || ( index( $user->{'url'}, 'https://' ) == 0 ) );

    my $introduction = '�Ȃ�';
    $introduction = $user->{'introduction'}
      if ( $user->{'introduction'} ne '' );

    my $parmalink = '��\\��';
    $parmalink = '�\\��' if ( $user->{'parmalink'} == 1 );

    print <<"_HTML_";
<h2>$query->{'prof'}����̏��$linkedit</h2>

<p class="paragraph">
  <span class="multicolumn_label">���[�U�[ID�F</span><span class="multicolumn_left">$query->{'prof'}</span>
  <br class="multicolumn_clear"$net>

  <span class="multicolumn_label">�n���h�����F</span><span class="multicolumn_left">$handlename</span>
  <br class="multicolumn_clear"$net>

  <span class="multicolumn_label">URL�F</span><span class="multicolumn_left">$url</span>
  <br class="multicolumn_clear"$net>

  <span class="multicolumn_label">�Œ胊���N�F</span><span class="multicolumn_left">$parmalink</span>
  <br class="multicolumn_clear"$net>

_HTML_

    if (1) {
        my $penaltydt =
          int( ( $user->{'penaltydt'} - $sow->{'time'} ) / 60 / 60 / 24 + 0.5 );
        my @penalty = ( "�Ȃ�", "�Ȃ��i�ی�ώ@���Ԓ��F���Ɩ�$penaltydt���j", "�Q����~���i���Ɩ�$penaltydt���j", "ID��~���i���Ɩ�$penaltydt���j", );
        print <<"_HTML_";
  <span class="multicolumn_label">�y�i���e�B�F</span><span class="multicolumn_left">$penalty[$user->{'ptype'}]</span>
  <br class="multicolumn_clear"$net>
</p>
_HTML_
    }

    # �������
    if ( -w $sow->{'cfg'}->{'DIR_RECORD'} ) {
        my ( $average, $liveaverage, $livedays ) = &SetRecordText($totalrecord);
        print <<"_HTML_";

<p class="paragraph">
  <span class="multicolumn_label">��сF</span>
  <span class="multicolumn_left">$totalrecord->{'win'}�� $totalrecord->{'lose'}�s (���� $average%) ������ $liveaverage%, ���� $livedays��</span>
  <br class="multicolumn_clear"$net>
</p>

<p class="paragraph">
����тɔp���������A����ѓˑR���������͊܂܂�܂���B
</p>

_HTML_
    }

    $reqvals->{'cmd'} = '';

    if (   ( $sow->{'uid'} eq $query->{'prof'} )
        || ( $sow->{'uid'} eq $sow->{'cfg'}->{'USERID_ADMIN'} ) )
    {
        my $user = SWUser->new($sow);
        $user->{'uid'} = $query->{'prof'};
        $user->openuser(1);
        my $entriedvils = $user->getentriedvils();
        $user->closeuser();

        print <<"_HTML_";
<hr class="invisible_hr"$net>

<h3>�Q�����̑��i���̐l�ɂ͌����܂���j</h3>
<ul class="paragraph">
_HTML_

        require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";
        my @list = sort { $b->{'vid'} <=> $a->{'vid'} } @$entriedvils;
        foreach (@list) {
            $reqvals->{'vid'} = $_->{'vid'};
            my $vil = SWFileVil->new( $sow, $_->{'vid'} );
            $vil->readvil();
            my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
            print "<li><a href=\"$urlsow?$linkvalue#newsay\">$_->{'vid'}�� $vil->{'vname'}</a> $_->{'chrname'}</li>\n";
            $vil->closevil();
        }
        print "<li>���ݎQ�����̑��͂���܂���B</li>\n" if ( @$entriedvils == 0 );

        print <<"_HTML_";
</ul>
_HTML_

    }

    if ( $sow->{'uid'} eq $query->{'prof'} ) {
        print <<"_HTML_";
<hr class="invisible_hr"$net>

<h3>�p�X���[�h�ύX</h3>
<form action="$urlsow" method="$sow->{'cfg'}->{'METHOD_FORM'}">
<p>
  <input type="hidden" name="cmd" value="changepwd"$net>
  <input type="hidden" name="uid" value="$sow->{'uid'}"$net>
  <label>���݂̃p�X���[�h: <input type="password" size="20" name="pwd" value=""$net></label><br>
  <label>�V�����p�X���[�h: <input type="password" size="20" name="newpwd" value=""$net></label><br>
  <label>�m�F�p�p�X���[�h: <input type="password" size="20" name="confirm" value=""$net></label>
  <input type="submit" value="�ύX" data-submit-type="changepwd"$disabled$net>
</p>
</form>
<hr class="invisible_hr"$net>

_HTML_
    }

    print <<"_HTML_";
<hr class="invisible_hr"$net>

<h3>���ȏЉ�</h3>
<p class="paragraph">
$introduction
</p>
<hr class="invisible_hr"$net>

_HTML_

    # �ڍא�тւ̃����N
    if ( ( @$recordlist > 0 ) && ( $query->{'rowall'} eq '' ) ) {
        $reqvals->{'vid'}    = '';
        $reqvals->{'prof'}   = $query->{'prof'};
        $reqvals->{'rowall'} = 'on';
        my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
        print <<"_HTML_";
<p class="paragraph">
<a href="$urlsow?$linkvalue">�ڍא�т�\\��</a>
</p>
<hr class="invisible_hr"$net>

_HTML_
    }

    # �ڍא��
    if ( ( @$recordlist > 0 ) && ( $query->{'rowall'} ne '' ) ) {

        # �w�c��
        &OutHTMLRecordSingle( $sow, $camps, '�w�c', $sow->{'textrs'}->{'CAPTION_WINNER'} );

        # ��E��
        &OutHTMLRecordSingle( $sow, $roles, '��E', $sow->{'textrs'}->{'ROLENAME'} );

        print <<"_HTML_";
<h3>�Q�����ꗗ</h3>
<div class="paragraph">
<ul>
_HTML_

        my @winstr   = ( '�p��', '����', '����', '�s�k' );
        my $rolename = $sow->{'textrs'}->{'ROLENAME'};
        my %livetext = (
            live       => '���Ԃ𐶂����т��B',
            executed   => '���ڂɏ��Y���ꂽ�B',
            victim     => '���ڂɏP�����ꂽ�B',
            cursed     => '���ڂɎ�E���ꂽ�B',
            suicide    => '���ڂɌ�ǂ������B',
            suddendead => '���ڂɓˑR�������B',
        );

        my @list = sort { $a->{'vid'} <=> $b->{'vid'} } @$recordlist;
        foreach (@list) {
            $reqvals->{'vid'} = $_->{'vid'};
            my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
            my $liveday   = $_->{'liveday'};
            $liveday++ if ( $_->{'live'} ne 'live' );
            my $rolenametext = "($rolename->[$_->{'role'}])";
            $rolenametext = '' if ( $_->{'role'} < 0 );
            print "<li><a href=\"$urlsow?$linkvalue#newsay\">$_->{'vid'} $_->{'vname'}</a><br$net>�y"
              . $winstr[ $_->{'win'} + 1 ]
              . "�z $_->{'chrname'}$rolenametext�A$liveday$livetext{$_->{'live'}}</li>\n";
        }

        print <<"_HTML_";
</ul>
</div>
<hr class="invisible_hr"$net>

<h3>�^�����J���X�g</h3>

<div class="paragraph">
<ul>
_HTML_

        my $bondcount = 0;
        foreach (@list) {
            my @bonds = split( '/', $_->{'bonds'} . '/' );
            next if ( !defined( $bonds[0] ) );

            my @bondtext;
            $reqvals->{'vid'} = '';
            foreach (@bonds) {
                my ( $encodeduid, $chrname ) = split( ':', $_ );
                my $uid = $encodeduid;
                $uid =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("H2", $1)/eg;
                $reqvals->{'prof'} = $encodeduid;
                my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
                push( @bondtext, "$chrname(<a href=\"$urlsow?$linkvalue\">$uid</a>)" );
            }
            my $bondtext = join( '�A', @bondtext );
            $reqvals->{'prof'} = '';
            $reqvals->{'vid'}  = $_->{'vid'};
            my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
            print "<li><a href=\"$urlsow?$linkvalue#newsay\">$_->{'vid'}��</a>�F$bondtext �Ɖ^�����J������ł����B</li>\n";
            $bondcount++;
        }
        print "<li>�^�����J�����񂾑���͂܂����܂���B</li>\n" if ( $bondcount == 0 );

        print <<"_HTML_";
</ul>
</div>
<hr class="invisible_hr"$net>

<h3>�����J���X�g</h3>

<div class="paragraph">
<ul>
_HTML_

        my $bondcount = 0;
        foreach (@list) {
            my @lovers = split( '/', $_->{'lovers'} . '/' );
            next if ( !defined( $lovers[0] ) );

            my @lovertext;
            $reqvals->{'vid'} = '';
            foreach (@lovers) {
                my ( $encodeduid, $chrname ) = split( ':', $_ );
                my $uid = $encodeduid;
                $uid =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("H2", $1)/eg;
                $reqvals->{'prof'} = $encodeduid;
                my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
                push( @lovertext, "$chrname(<a href=\"$urlsow?$linkvalue\">$uid</a>)" );
            }
            my $lovertext = join( '�A', @lovertext );
            $reqvals->{'prof'} = '';
            $reqvals->{'vid'}  = $_->{'vid'};
            my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
            print "<li><a href=\"$urlsow?$linkvalue#newsay\">$_->{'vid'}��</a>�F$lovertext �ƈ����J������ł����B</li>\n";
            $lovercount++;
        }
        print "<li>�����J�����񂾑���͂܂����܂���B</li>\n" if ( $lovercount == 0 );

        my @winmark = ( '�|', '��', '��', '�~' );
        print <<"_HTML_";
</ul>
</div>
<hr class="invisible_hr"$net>

<h3>�����҈ꗗ</h3>
<p class="paragraph">
��$winmark[2]�F�����A$winmark[3]�F�����A$winmark[1]�F���������A$winmark[0]�F���̑��i�p���܂��͓ˑR���j
</p>

<div class="paragraph">
<ul>
_HTML_

        $reqvals->{'vid'} = '';
        my %vs;
        foreach (@list) {
            print "<li>$_->{'vid'}���F";
            my @otherpl    = split( '/', $_->{'otherpl'} );
            my $suddendead = 0;
            $suddendead = 1 if ( $_->{'live'} eq 'suddendead' );
            foreach (@otherpl) {
                next if ( $_ eq '' );
                my ( $encodeduid, $win ) = split( ':', "$_:" );
                my $uid = $encodeduid;
                $uid =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("H2", $1)/eg;
                if ( !defined( $vs{$encodeduid} ) ) {
                    my %vssingle = (
                        win   => 0,
                        lose  => 0,
                        draw  => 0,
                        total => 0,
                        uid   => $uid,
                    );
                    $vs{$encodeduid} = \%vssingle;
                }
                $vs{$encodeduid}->{'total'}++;
                if ( $suddendead == 0 ) {
                    $vs{$encodeduid}->{'win'}++  if ( $win == 1 );
                    $vs{$encodeduid}->{'lose'}++ if ( $win == 2 );
                    $vs{$encodeduid}->{'draw'}++ if ( $win == 0 );
                }

                $reqvals->{'prof'} = $encodeduid;
                my $linkvalue = &SWBase::GetLinkValues( $sow, $reqvals );
                $vs{$encodeduid}->{'url'} = "$urlsow?$linkvalue";
                my $marksingle = $winmark[ $win + 1 ];
                $marksingle = '�|' if ( $suddendead > 0 );
                print "$marksingle<a href=\"$vs{$encodeduid}->{'url'}\">$uid</a>�A";
            }
            print "</li>\n";
        }

        print <<"_HTML_";
</ul>
</div>
<hr class="invisible_hr"$net>

<h3>�����ґΐ��сi$sow->{'cfg'}->{'MIN_VSRECORDTOTAL'}��ȏ�j</h3>
<p class="paragraph">
�����s�W�v�ɔp���������A����ѓˑR���������͊܂܂�܂���B
</p>

<div class="paragraph">
<ul>
_HTML_

        my $vscount = 0;
        my @vskeys  = keys(%vs);
        my @vs      = sort {
                 $vs{$b}->{'total'} <=> $vs{$a}->{'total'}
              or $vs{$b}->{'win'}   <=> $vs{$a}->{'win'}
              or $vs{$b}->{'draw'}  <=> $vs{$a}->{'draw'}
              or $vs{$b}->{'lose'}  <=> $vs{$a}->{'lose'}
        } @vskeys;
        foreach (@vs) {
            next
              if ( $vs{$_}->{'total'} < $sow->{'cfg'}->{'MIN_VSRECORDTOTAL'} );
            print
"<li>vs. <a href=\"$vs{$_}->{'url'}\">$vs{$_}->{'uid'}</a> $vs{$_}->{'total'}�� $vs{$_}->{'win'}�� $vs{$_}->{'lose'}�s $vs{$_}->{'draw'}��</li>\n";
            $vscount++;
        }
        print "<li>$sow->{'cfg'}->{'MIN_VSRECORDTOTAL'}��ȏ㓯�������l�͂܂����܂���B</li>\n"
          if ( $vscount == 0 );

        print <<"_HTML_";
</ul>
</div>
<hr class="invisible_hr"$net>

_HTML_
    }

    &SWHtmlPC::OutHTMLReturnPC($sow);    # �g�b�v�y�[�W�֖߂�

    $sow->{'html'}->outcontentfooter('');
    $sow->{'html'}->outfooter();         # HTML�t�b�^�̏o��
    $sow->{'http'}->outfooter();

    return;
}

#----------------------------------------
# �����␶�����̐��`
#----------------------------------------
sub SetRecordText {
    my $data = shift;

    my $average     = 0;
    my $liveaverage = 0;
    my $livedays    = 0;
    $total = $data->{'total'};
    if ( $data->{'total'} > 0 ) {
        $average     = int( ( $data->{'win'} * 100 / $total ) + 0.5 );
        $liveaverage = int( ( $data->{'livecount'} * 100 / $total ) + 0.5 );
        $livedays    = sprintf( "%3.1f", $data->{'liveday'} / $total );
    }
    return ( $average, $liveaverage, $livedays );
}

#----------------------------------------
# ��ѕ\���i�w�c�ʁ^��E�ʁj
#----------------------------------------
sub OutHTMLRecordSingle {
    my ( $sow, $data, $title, $caption ) = @_;
    my $net = $sow->{'html'}->{'net'};    # Null End Tag

    print <<"_HTML_";
<h3>$title�ʐ��</h3>

<table border="1" class="vindex">
<thead>
<tr>
  <th scope="col">$title</th>
  <th scope="col">���s</th>
  <th scope="col">����</th>
  <th scope="col">������</th>
  <th scope="col">����</th>
</tr>
</thead>

<tbody>
_HTML_

    my $i;
    for ( $i = 1 ; $i < @$data ; $i++ ) {

        # �w�c�ʂ̏ꍇ�A�d���w�c��2��\������Ă��܂��̂�h��
        next if ( $title eq '�w�c' && $i == 4 );

        my $side = '';
        $side = '��' if ( $title eq '�w�c' );
        if ( $data->[$i]->{'total'} > 0 ) {
            my ( $average, $liveaverage, $livedays ) =
              &SetRecordText( $data->[$i] );
            print <<"_HTML_";
<tr>
  <td>$caption->[$i]$side</td>
  <td>$data->[$i]->{'win'}�� $data->[$i]->{'lose'}�s</td>
  <td>$average%</td>
  <td>$liveaverage%</td>
  <td>$livedays��</td>
</tr>

_HTML_
        }
        else {
            print <<"_HTML_";
<tr>
  <td>$caption->[$i]$side</td>
  <td colspan="4">�Ȃ�</td>
</tr>

_HTML_
        }
    }

    print <<"_HTML_";
</tbody>
</table>
<hr class="invisible_hr"$net>

_HTML_

}

1;
