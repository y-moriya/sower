package SWValidityWrite;

#----------------------------------------
# �������l�`�F�b�N
#----------------------------------------
sub CheckValidityWrite {
	my ($sow, $vil) = @_;
	my $query = $sow->{'query'};
	my $debug = $sow->{'debug'};
	my $errfrom = "[uid=$sow->{'uid'}, cmd=$query->{'cmd'}]";

	# �����O�֘A��{���͒l�`�F�b�N
	require "$sow->{'cfg'}->{'DIR_LIB'}/vld_vil.pl";
	&SWValidityVil::CheckValidityVil($sow, $vil);

	my $lenmes = length($query->{'mes'});
	$debug->raise($sow->{'APLOG_NOTICE'}, "�������Z�����܂��i$lenmes �o�C�g�j�B$sow->{'cfg'}->{'MINSIZE_MES'} �o�C�g�ȏ�K�v�ł��B", "mes too short.$errfrom") if (($lenmes < $sow->{'cfg'}->{'MINSIZE_MES'}) && ($lenmes != 0));

	my @messwitch = ('think', 'wolf', 'maker', 'admin');
	my $cntenabled = 0;
	foreach (@messwitch) {
		$cntenabled++ if ($query->{$_} ne '');
	}
	$debug->raise($sow->{'APLOG_CAUTION'}, "������ʂ��s���ł��B", "invalid mestype.$errfrom") if ($cntenabled > 1); # �ʏ�N���Ȃ�

	if ($query->{'cmd'} eq 'writepr') {
		if ($vil->{'entrylimit'} eq 'password') {
			if ($query->{'guest'} ne '') {
				if ($query->{'writepwd'} ne $vil->{'entrypwd'}) {
					$debug->raise($sow->{'APLOG_NOTICE'}, '�p�X���[�h���Ⴂ�܂��B', "invalid writepwd.$errfrom") ;
				}
			}
		}
	}

	if (($vil->{'guestmenu'} > 0) && ($query->{'guest'} ne '')) {
		$debug->raise($sow->{'APLOG_CAUTION'}, "�T�ώҔ����͖����ł��B", "invalid guest.$errfrom");
	}

	return;
}

1;
