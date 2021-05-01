package SWHtmlVlog;

#----------------------------------------
# �����O�\���̃^�C�g��
#----------------------------------------
sub GetHTMLVlogTitle {
    my ( $sow, $vil ) = @_;
    my $daytitle = "$sow->{'turn'}����";
    $daytitle = '�v�����[�O' if ( $sow->{'turn'} == 0 );
    $daytitle = '�G�s���[�O' if ( $sow->{'turn'} == $vil->{'epilogue'} );
    $daytitle = '�I��'          if ( $sow->{'turn'} > $vil->{'epilogue'} );
    return "$daytitle / $sow->{'query'}->{'vid'} $vil->{'vname'}";
}

#----------------------------------------
# �������҃��X�g�̎擾
#----------------------------------------
sub GetNoSayListText {
    my ( $sow, $vil ) = @_;
    my $saycnt = $sow->{'cfg'}->{'COUNTS_SAY'}->{ $vil->{'saycnttype'} };
    my $pllist = $vil->getpllist();

    my @nosay;
    foreach (@$pllist) {
        if ( ( $_->{'live'} eq 'live' ) && ( $_->{'saidcount'} == 0 ) ) {
            push( @nosay, $_ );
        }
    }

    my $result   = '';
    my $nosaycnt = @nosay;
    $result .= "�{���܂��������Ă��Ȃ��҂́A";
    foreach (@nosay) {
        my $chrname = $_->getchrname();
        $result .= "$chrname�A";
    }
    $result .= "�ȏ� $nosaycnt ���B";

    $result = '' if ( $nosaycnt == 0 );
    return $result;
}

1;
