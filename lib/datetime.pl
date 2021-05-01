package SWDateTime;

#----------------------------------------
# ���t�֘A���C�u����
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
    my ( $class, $sow ) = @_;
    my $self = { sow => $sow, };

    return bless( $self, $class );
}

#----------------------------------------
# ������̎擾
#----------------------------------------
sub getlocaldt {
    my ( $self, $dt ) = @_;

    my $gmt = $dt + $self->{'sow'}->{'cfg'}->{'TIMEZONE'} * 60 * 60;
    return gmtime($gmt);
}

#----------------------------------------
# �����̕ϊ�
#----------------------------------------
sub cvtdt {
    my ( $self, $dt ) = @_;

    my ( $sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer ) = $self->getlocaldt($dt);
    my $result = sprintf(
        "%4d/%02d/%02d(%s) %02d:%02d:%02d",
        $year + 1900,
        ++$mon, $day, ( 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' )[$week],
        $hour, $min, $sec
    );

    return $result;
}

#----------------------------------------
# �����̕ϊ��i�ȗ��\���j
#----------------------------------------
sub cvtdtsht {
    my ( $self, $dt ) = @_;

    my ( $sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer ) = $self->getlocaldt($dt);
    $min = int( $min / 10 ) * 10;
    my $result = sprintf(
        "%4d/%02d/%02d(%s) %02d:%02d��",
        $year + 1900,
        ++$mon, $day, ( 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' )[$week],
        $hour, $min
    );

    return $result;
}

#----------------------------------------
# �����̕ϊ��i���o�C�������Z�k�`�j
#----------------------------------------
sub cvtdtmb {
    my ( $self, $dt ) = @_;

    my ( $sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer ) = $self->getlocaldt($dt);
    my $result = sprintf( "%02d/%02d %02d:%02d", ++$mon, $day, $hour, $min );

    return $result;
}

#----------------------------------------
# �����̕ϊ��i���o�C�������ȗ��\���j
#----------------------------------------
sub cvtdtmbsht {
    my ( $self, $dt ) = @_;

    my ( $sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer ) = $self->getlocaldt($dt);
    $min = int( $min / 10 ) * 10;
    my $result = sprintf( "%02d/%02d %02d:%02d��", ++$mon, $day, $hour, $min );

    return $result;
}

#----------------------------------------
# ����X�V�����̎擾
#----------------------------------------
sub getnextupdatedt {
    my ( $self, $vil, $basedt, $updinterval, $commit ) = @_;

    my $result = 0;
    if ( ( $vil->{'updhour'} < 0 ) || ( $vil->{'updminite'} < 0 ) ) {

        # nn���X�V
        $result = $basedt + $vil->{'updinterval'} * 60;
    }
    else {
        # 24h�P�ʍX�V
        my $basedt_sec;
        ( $result, $basedt_sec ) = $self->getlastupdatedt( $vil, $basedt );
        if ( $commit > 0 ) {
            $result += 60 * 60 * 24 if ( $result != $basedt_sec );
        }
        $result += $updinterval * 60 * 60 * 24;
    }

    return $result;
}

#----------------------------------------
# ���O�ɍX�V���������̎擾
#----------------------------------------
sub getlastupdatedt {
    my ( $self, $vil, $basedt ) = @_;

    my ( $sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer ) = $self->getlocaldt($basedt);
    $basedt -= $sec;
    my $result = $basedt - ( $hour * 60 + $min ) * 60;
    $result += ( $vil->{'updhour'} * 60 + $vil->{'updminite'} ) * 60;
    $result -= 60 * 60 * 24 if ( $result > $basedt );

    return ( $result, $basedt );
}

#----------------------------------------
# ����X�V�����̎擾�ivil�Ȃ�ver�j
#----------------------------------------
sub getnextupdatedtwithoutvil {
    my ( $self, $updhour, $updminite, $basedt, $updinterval, $commit ) = @_;

    my $result = 0;
    if ( ( $updhour < 0 ) || ( $updminite < 0 ) ) {

        # nn���X�V
        $result = $basedt + $updinterva * 60;
    }
    else {
        # 24h�P�ʍX�V
        my $basedt_sec;
        ( $result, $basedt_sec ) = $self->getlastupdatedtwithoutvil( $updhour, $updminite, $basedt );
        if ( $commit > 0 ) {
            $result += 60 * 60 * 24 if ( $result != $basedt_sec );
        }
        $result += $updinterval * 60 * 60 * 24;
    }

    return $result;
}

#----------------------------------------
# ���O�ɍX�V���������̎擾�ivil�Ȃ�ver�j
#----------------------------------------
sub getlastupdatedtwithoutvil {
    my ( $self, $updhour, $updminite, $basedt ) = @_;

    my ( $sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer ) = $self->getlocaldt($basedt);
    $basedt -= $sec;
    my $result = $basedt - ( $hour * 60 + $min ) * 60;
    $result += ( $updhour * 60 + $updminite ) * 60;
    $result -= 60 * 60 * 24 if ( $result > $basedt );

    return ( $result, $basedt );
}

#----------------------------------------
# ���Ԃ�i�߂�����̎擾
#----------------------------------------
sub getcommitdt {
    my ( $self, $basedt ) = @_;

    my ( $sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer ) = $self->getlocaldt($basedt);
    $basedt -= ( $sec + ( $min % 30 ) * 60 );
    my $result = $basedt + 60 * 30;

    return $result;
}

#----------------------------------------
# �N�b�L�[�̊������t�擾
#----------------------------------------
sub getcookiedt {
    my ( $self, $dt ) = @_;

    my ( $sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer ) = gmtime($dt);
    my $expire = sprintf(
        "%s, %02d-%s-%04d %02d:%02d:%02d GMT",
        ( 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' )[$week],
        $day,
        ( 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' )[$mon],
        $year + 1900,
        $hour, $min, $sec
    );

    return $expire;
}

#----------------------------------------
# HTTP-Date(RFC822/RFC1123)�`���̓��t�擾
#----------------------------------------
sub gethttpdt {
    my ( $self, $dt ) = @_;

    my ( $sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer ) = gmtime($dt);
    my $expire = sprintf(
        "%s, %02d %s %04d %02d:%02d:%02d GMT",
        ( 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat' )[$week],
        $day,
        ( 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec' )[$mon],
        $year + 1900,
        $hour, $min, $sec
    );

    return $expire;
}

#----------------------------------------
# �����̕ϊ��iW3CDTF�j
#----------------------------------------
sub cvtw3cdtf {
    my ( $self, $dt ) = @_;

    my ( $sec, $min, $hour, $day, $mon, $year, $week, $yday, $summer ) = $self->getlocaldt($dt);
    my $result = sprintf( "%4d-%02d-%02dT%02d:%02d:%02d+09:00", $year + 1900, ++$mon, $day, $hour, $min, $sec );

    return $result;
}

1;
