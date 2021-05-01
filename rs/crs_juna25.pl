package SWResource_juna25;

#----------------------------------------
# �l�T�R��L�����Z�b�g�i���P�`��2.5�j
# http://briefcase.yahoo.co.jp/jsfun2
#----------------------------------------

sub GetRSChr {
    my $sow = $_[0];

    my $maker = $sow->{'cfg'}->{'CID_MAKER'};
    my $admin = $sow->{'cfg'}->{'CID_ADMIN'};

    my @order = (
        'char00', 'char01', 'char02', 'char03', 'char04', 'char05', 'char06', 'char07', 'char08', 'char09',
        'char10', 'char11', 'char12', 'char13', 'char14', 'char15', 'char16', 'char17', 'char18', 'char19',
        'char20', 'char21', 'char22', 'char23', 'char24', 'char25',
    );

    # �L�����̌�����
    my %chrjob = (
        char00 => '���x�c��',
        char01 => '���V',
        char02 => '�h�̎�l',
        char03 => '�_�v',
        char04 => '�E�l',

        char05 => '�����l',
        char06 => '����',
        char07 => '��t',
        char08 => '�����D',
        char09 => '�_��',

        char10 => '����',
        char11 => '�����',
        char12 => '���Ɖ�',
        char13 => '�s���l',
        char14 => '���y��',

        char15 => '�E�l�̒�q',
        char16 => '���ƉƂ̎q',
        char17 => '�C����',
        char18 => '�V�k',
        char19 => '��t�̍�',

        char20 => '��t�̖�',
        char21 => '���V�̑�',
        char22 => '���t',
        char23 => '�V���L��',
        char24 => '�ǎ�',

        char25 => '���t�̖�',

        $maker => '',
        $admin => '',
    );

    # �L�����̖��O
    my %chrname = (
        char00 => '�A�[���@�C��',
        char01 => '�E�H�[���X',
        char02 => '�w�N�^�[',
        char03 => '���u',
        char04 => '�I�[�E�F��',

        char05 => '�C�A��',
        char06 => '�����t',
        char07 => '�I�Y�����h',
        char08 => '���[�N',
        char09 => '�T�C����',

        char10 => '�`�F�X�^�[',
        char11 => '�N���[�N',
        char12 => '�I���o�[',
        char13 => '�}�[�e�B��',
        char14 => '�X�R�b�g',

        char15 => '�W���i�T��',
        char16 => '�e�b�h',
        char17 => '�w����',
        char18 => '�h�[��',
        char19 => '���C�[�Y',

        char20 => '�e���T',
        char21 => '�}�[�K���b�g',
        char22 => '���A���[',
        char23 => '�A�C���[��',
        char24 => '�A�j�^',

        char25 => '���T',
        $maker => '�V�̂������i�����Đl�j',
        $admin => '�ł̙ꂫ�i�Ǘ��l�j',
    );

    # �L�����̃��e���A���t�@�x�b�g���i�I�v�V�����j
    my %chrromanname = (
        char00 => 'Irvine',
        char01 => 'Warles',
        char02 => 'Hector',
        char03 => 'Rob',
        char04 => 'Owen',

        char05 => 'Ian',
        char06 => 'Ralf',
        char07 => 'Oswald',
        char08 => 'Luke',
        char09 => 'Simon',

        char10 => 'Chester',
        char11 => 'Clark',
        char12 => 'Oliver',
        char13 => 'Martin',
        char14 => 'Scott',

        char15 => 'Jonathan',
        char16 => 'Ted',
        char17 => 'Helen',
        char18 => 'Dola',
        char19 => 'Louise',

        char20 => 'Teresa',
        char21 => 'Margaret',
        char22 => 'Mary',
        char23 => 'Aileen',
        char24 => 'Anita',

        char25 => 'Risa',
        $maker => '�V�̂������i�����Đl�j',
        $admin => '�ł̙ꂫ�i�Ǘ��l�j',
    );

    # �L�������������i�l�T���o�͗p�j
    my %chrnameinitial = (
        char00 => '�x',
        char01 => '�V',
        char02 => '�h',
        char03 => '�_',
        char04 => '�E',

        char05 => '��',
        char06 => '��',
        char07 => '��',
        char08 => '�D',
        char09 => '�_',

        char10 => '��',
        char11 => '��',
        char12 => '��',
        char13 => '��',
        char14 => '�y',

        char15 => '��',
        char16 => '�q',
        char17 => '�C',
        char18 => '�k',
        char19 => '��',

        char20 => '��',
        char21 => '��',
        char22 => '��',
        char23 => '�L',
        char24 => '��',

        char25 => '��',
    );

    my @npcsay = (
'�@�ӂށc�c�܂��W�܂��Ă��Ȃ��悤���ȁB�@���̂����ɁA������x�����ɍs���Ă���Ƃ��悤�B',
'�@���[�A���N�A�����Ă���B�����\�ɂȂ��Ă���悤�����A�܂������ƂɂȂ����B<br>�@���̊Ԃ̗��l���E���ꂽ���A��͂�l�T�̎d�Ƃ̂悤���B<br><br>�@�����A����ɏo����o�����͍̂������ɂ���҂őS�����B<br>�@�Ƃɂ����\���ɒ��ӂ��Ă���B',
    );

    my @expression = ();

    my %charset = (
        CAPTION        => '�l�T�R�⃿2.5',
        NPCID          => 'char00',
        CHRNAME        => \%chrname,
        CHRJOB         => \%chrjob,
        CHRNAMEINITIAL => \%chrnameinitial,
        CHRROMANNAME   => \%chrromanname,
        ORDER          => \@order,
        NPCSAY         => \@npcsay,
        IMGBODYW       => 64,
        IMGBODYH       => 98,
        DIR            => "$sow->{'cfg'}->{'DIR_IMG'}/juna25",
        EXT            => '.png',
        BODY           => '',
        FACE           => '',
        GRAVE          => '',
        EXPRESSION     => \@expression,
        LAYOUT_NAME    => 'right',
    );

    return \%charset;
}

1;
