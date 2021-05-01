package SWResource_wbbs;

#----------------------------------------
# �T���v���L�����Z�b�g
#----------------------------------------

sub GetRSChr {
    my $sow = $_[0];

    my $maker = $sow->{'cfg'}->{'CID_MAKER'};
    my $admin = $sow->{'cfg'}->{'CID_ADMIN'};
    my $guest = $sow->{'cfg'}->{'CID_GUEST'};

    # �L�����̕\����
    my @order = ( '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', );

    # �L�����̌�����
    my %chrjob = (
        '01'   => '�}����',
        '02'   => '���V',
        '03'   => '�_��',
        '04'   => '�؂���',
        '05'   => '���l',
        '06'   => '����',
        '07'   => '�N',
        '08'   => '����',
        '09'   => '�s���l',
        '10'   => '�r����',
        '11'   => '�p����',
        '12'   => '�R',
        '13'   => '�Ǝ���`��',
        '14'   => '�_�v',
        '15'   => '�h���̏���l',
        $maker => '',
        $admin => '',
    );

    # �L�����̖��O
    my %chrname = (
        '01'   => '�Q���g',
        '02'   => '���@���^�[',
        '03'   => '�W���]��',
        '04'   => '�g�[�}�X',
        '05'   => '�j�R���X',
        '06'   => '�f�B�[�^�[',
        '07'   => '�y�[�^�[',
        '08'   => '���[�U',
        '09'   => '�A���r��',
        '10'   => '�J�^���i',
        '11'   => '�I�b�g�[',
        '12'   => '���A�q��',
        '13'   => '�p����',
        '14'   => '���R�u',
        '15'   => '���W�[�i',
        $maker => '�V�̂������i�����Đl�j',
        $admin => '��[��i�Ǘ��l�j',
        $guest => &SWUser::GetHandle,
    );

    # �L�������������i�l�T���o�͗p�j
    my %chrnameinitial = (
        '01' => '�Q',
        '02' => '��',
        '03' => '�W',
        '04' => '�g',
        '05' => '�j',
        '06' => '�f',
        '07' => '�y',
        '08' => '��',
        '09' => '�A',
        '10' => '�J',
        '11' => '�I',
        '12' => '��',
        '13' => '�p',
        '14' => '��',
        '15' => '��',
    );

    # �_�~�[�L�����̔���
    my @npcsay = ( '�l�T������', '�����Q��͖̂O������', );

    my @expression = ();

    my %charset = (
        CAPTION        => '�l�TBBS10���N',
        NPCID          => '01',
        CHRNAME        => \%chrname,
        CHRJOB         => \%chrjob,
        CHRNAMEINITIAL => \%chrnameinitial,
        ORDER          => \@order,
        NPCSAY         => \@npcsay,

        #		IMGFACEW       => 80,
        #		IMGFACEH       => 100,
        IMGBODYW => 80,
        IMGBODYH => 100,

        #		IMGMOBILEW     => 16,
        #		IMGMOBILEH     => 16,
        DIR         => "$sow->{'cfg'}->{'DIR_IMG'}/wbbs",
        EXT         => '.jpg',
        BODY        => '',
        FACE        => '',
        GRAVE       => '',
        WOLF        => '',
        EXPRESSION  => \@expression,
        LAYOUT_NAME => 'right',
    );

    return \%charset;
}

1;
