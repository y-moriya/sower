package SWHtmlRoleList;

#----------------------------------------
# ��E�ꗗ��ʂ̃^�C�g��
#----------------------------------------
sub GetHTMLRoleListTitle {
    return '��E�ƃC���^�[�t�F�C�X';
}

#----------------------------------------
# ��E�ꗗHTML�o��
#----------------------------------------
sub OutHTMLRoleList {
    my $sow = $_[0];
    my $net = $sow->{'html'}->{'net'};    # Null End Tag
    my $cfg = $sow->{'cfg'};

    require "$sow->{'cfg'}->{'DIR_LIB'}/file_vil.pl";

    print <<"_HTML_";
<h2>��E�ƃC���^�[�t�F�C�X</h2>

_HTML_

    # �_�~�[�f�[�^�̐���
    my $vil = SWFileVil->new( $sow, 0 );
    $vil->createdummyvil();
    $vil->{'csid'}       = 'sow';
    $vil->{'trsid'}      = $sow->{'cfg'}->{'DEFAULT_TEXTRS'};
    $vil->{'saycnttype'} = 'wbbs';
    $vil->{'turn'}       = 2;
    $vil->{'winner'}     = 0;
    $vil->{'makeruid'}   = $sow->{'cfg'}->{'USERID_ADMIN'};
    $sow->{'turn'}       = $vil->{'turn'};

    $sow->{'savedraft'} = '';

    # ���\�[�X�̓ǂݍ���
    my %csidlist = ();
    $csidlist{ $vil->{'csid'} } = 1;
    $sow->{'csidlist'} = \%csidlist;
    &SWBase::LoadVilRS( $sow, $vil );

    my $order = $sow->{'charsets'}->{'csid'}->{ $vil->{'csid'} }->{'ORDER'};

    # �_�~�[�L����
    my $dummypl = SWPlayer->new($sow);
    $dummypl->createpl( $sow->{'cfg'}->{'USERID_NPC'} );
    $dummypl->{'pno'}      = 0;
    $dummypl->{'csid'}     = $vil->{'csid'};
    $dummypl->{'cid'}      = $order->[ $dummypl->{'pno'} ];
    $dummypl->{'selrole'}  = -1;
    $dummypl->{'role'}     = $dummypl->{'pno'} + 1;
    $dummypl->{'deathday'} = -1;
    $vil->addpl($dummypl);      # ���֒ǉ�
    $dummypl->setsaycount();    # ������������

    my $rolename = $sow->{'textrs'}->{'ROLENAME'};
    for ( $i = 1 ; $i < @$rolename ; $i++ ) {
        my $plsingle = SWPlayer->new($sow);
        $plsingle->createpl("a$i");
        $plsingle->{'pno'}       = $i;
        $plsingle->{'csid'}      = $vil->{'csid'};
        $plsingle->{'cid'}       = $order->[ $plsingle->{'pno'} ];
        $plsingle->{'selrole'}   = -1;
        $plsingle->{'role'}      = $plsingle->{'pno'} + 1;
        $plsingle->{'rolesubid'} = 0;
        $plsingle->{'deathday'}  = -1;
        $vil->addpl($plsingle);      # ���֒ǉ�
        $plsingle->setsaycount();    # ������������
    }

    require "$cfg->{'DIR_HTML'}/html_formpl_pc.pl";

    my @targets = (
        [ 10, 11 ],                  # ����`
        [ 0,  0 ],                   # ���l
        [ 3,  4 ],                   # �l�T
        [ 0,  1 ],                   # �肢�t
        [ 0,  1 ],                   # ��\��
        [ 0,  0 ],                   # ���l
        [ 0,  2 ],                   # ��l
        [ 10, 11 ],                  # ���L��
        [ 0,  0 ],                   # �n���X�^�[�l��
        [ 0,  0 ],                   # �b�����l
        [ 0,  0 ],                   # ������
        [ 1,  13 ],                  # ���M��
        [ 10, 11 ],                  # ����
        [ 0,  0 ],                   # �R�E�����l��
        [ 3,  4 ],                   # ���T
        [ 3,  4 ],                   # �q�T
        [ 0,  1 ],                   # �s�N�V�[
    );

    my $pllist = $vil->getpllist();
    my $i;
    for ( $i = 1 ; $i < @$rolename ; $i++ ) {
        print "<h3>$rolename->[$i]</h3>\n";
        $sow->{'curpl'} = $pllist->[ $i - 1 ];
        $sow->{'uid'}   = $sow->{'curpl'}->{'uid'};

        my $history = '';
        my $j;
        for ( $j = 0 ; $j < 2 ; $j++ ) {
            $history .= &GetResultRole( $sow, $sow->{'curpl'}, $pllist->[ $targets[$i][$j] ] );
        }
        $sow->{'curpl'}->{'history'} = $history;

        &SWHtmlPlayerFormPC::OutHTMLPlayerFormPC( $sow, $vil );
        print <<"_HTML_";
<hr class="invisible_hr"$net>

_HTML_
    }

    return;
}

#----------------------------------------
# ����^�\�͍s�g���ʂ̎擾
#----------------------------------------
sub GetResultRole {
    my ( $sow, $curpl, $targetpl ) = @_;

    my $role    = $curpl->{'role'};
    my $textrs  = $sow->{'textrs'};
    my $chrname = $targetpl->getchrname();
    my $result  = '';

    if (   ( $role == $sow->{'ROLEID_SEER'} )
        || ( $role == $sow->{'ROLEID_MEDIUM'} ) )
    {
        $result_iswolf = $textrs->{'RESULT_SEER'}->[1];
        $result_iswolf = $textrs->{'RESULT_SEER'}->[2]
          if ( $targetpl->iswolf() > 0 );    # �l�T/���T/�q�T
        my $result_seer = $textrs->{'RESULT_SEER'}->[0];
        $result_seer =~ s/_NAME_/$chrname/g;
        $result_seer =~ s/_RESULT_/$result_iswolf/g;
        $result = "$result_seer<br>";
    }
    elsif ( $curpl->iswolf() > 0 ) {
        my $result_kill = $textrs->{'RESULT_KILL'};
        $result_kill = $textrs->{'RESULT_KILLIW'}
          if ( $curpl->{'role'} == $sow->{'ROLEID_INTWOLF'} );
        $result_kill =~ s/_TARGET_/$chrname/g;
        $result_kill =~ s/_ROLE_/$sow->{'textrs'}->{'ROLENAME'}->[$targetpl->{'role'}]/g;
        $result = "$result_kill<br>";
    }
    elsif ( $role == $sow->{'ROLEID_GUARD'} ) {
        my $result_guard = $textrs->{'RESULT_GUARD'};
        $result_guard =~ s/_TARGET_/$chrname/g;
        $result = "$result_guard<br>";
    }
    elsif (( $role == $sow->{'ROLEID_FM'} )
        || ( $role == $sow->{'ROLEID_SYMPATHY'} ) )
    {
        my $namefm    = $textrs->{'ROLENAME'}->[$role];
        my $result_fm = $textrs->{'RESULT_FM'};
        $result_fm =~ s/_ROLE_/$namefm/g;
        $result_fm =~ s/_TARGET_/$chrname/g;
        $result = "$result_fm<br>";
    }
    elsif ( $role == $sow->{'ROLEID_FANATIC'} ) {
        my $result_fanatic = $textrs->{'RESULT_FANATIC'};
        $result_fanatic =~ s/_NAME_/$chrname/g;
        $result = "$result_fanatic<br>";
    }

    return $result;
}

1;
