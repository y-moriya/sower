package SWTextRS_fool;

sub GetTextRS {
    my @announce_first = ( '�Ȃ񂩐l�T�o������W�܂���Ă�B', '�Ƃ肠�����n�܂����炵�����H', '���[�A�N���Ȃ񂩎��񂾂��ۂ��ˁB', );

    my @announce_role = ( '�Ȃ񂩂��񒆂ɁA_ROLE_����炵���ŁB', '��', '�l', '�A', );

    my @announce_lives = ( '���ԂƂ��z��', '�A', ' �� _LIVES_ �l���Ǝv���Ă������B', );

    my @announce_vote =
      ( '_NAME_ �� _TARGET_ ��_RANDOM_���[���Ă݂��B', '_NAME_ �� _COUNT_�l�����[�����i�炵���j�B', '_NAME_ �͑��l�B�ɂ���Ă������ĂԂ��E���ꂽ�B' );

    my @announce_entrust = ( '_NAME_��_TARGET_��_RANDOM_���[��C���ĐQ���B', '_NAME_��_TARGET_��_RANDOM_���[��C���ĐQ�����A���[�悪�ς��������ۂ��B', );

    # �R�~�b�g
    my @announce_commit = ( '_NAME_�����Ԃ�i�߂�̂��~�߂��B', '_NAME_�͎��Ԃ�i�߂����炵���B', );

    my @announce_totalcommit = (
        '�u���Ԃ�i�߂�v��I��ł�l�͂܂����Ȃ����ۂ��B',    # 0�`1/3�̎�
        '�u���Ԃ�i�߂�v��I��ł�l�͂�����Ƒ������B',     # 1/3�`2/3�̎�
        '�u���Ԃ�i�߂�v��I��ł�l�͌��\�������B',       # 2/3�`n-1�̎�
        '�݂�Ȃ��u���Ԃ�i�߂�v��I�񂾁i�炵���j�B',      # �S���R�~�b�g�ς�
    );

    my @announce_kill = ( '�l�T�͐H�����˂Ă������󂢂Ă���悤���B', '�N�����Q���܂܋N���Ȃ������݂����B', );

    my @announce_winner = (
        '�����ĒN�����Ȃ��Ȃ����B',               '���l�B�������₪��܂����B',
        '�l�T�͂����Ղ�H�ׂĖ��������悤���B���߂łƂ��B',   '�������Ǝv�������ɂ́A�����Ă������Ă���i�炵���j�B',
        '�n�n�b�A���̓n�W�L�ɂ͏��Ăˁ[�񂾂�I�i�Ӗ��s���j�B', '���̗��������r���c�c�B<br>�l�́A���̑O�ɂ͂���Ȃɂ����͂Ȃ̂��c�c�B',
    );

    my @caption_winner = ( '', '�j���Q��', '��[�����', '�l�Ԃł��l�T�ł��Ȃ��A��', '�l�Ԃł��l�T�ł��Ȃ��A��', '���l' );

    my @rolename = (
        '�]�蕨', '�����̐l',  '��������',   '�G�X�p�[', '�C�^�R',  '�l�T�X�L�[', '�X�g�[�J�[',  '�v�w', '�n��', '�l�T���_��',
        '�{����', '�l�T���M��', '�����ǂ�v�w', '�R�E����', '�t���ݘT', '�O����',   '�C�^�Y�����q', '����`�҂���'
    );

    my @roleshortname = ( '��', '��', '�T', '��', '��', '��', '��', '��', '�n', '�b', '��', '�M', '��', '�t', '�t', '�O', '�C', '��' );

    my @explain_role = (
        '<p>���ꂪ���������Ȃ��͎���Ă��܂��B</p>',
        '<p>�\�́H�@�Ȃ���H�@���[���[�́[�Ё[�Ɓ[�B</p>',
        '<p>���Ȃ��͈����ł��B�ȏ�B<br>�i�������݁j</p>',
        '<p>���Ȃ��̓G�X�p�[�ł��B�n���h�p���[����g���ĉ������B</p>',
        '<p>���Ȃ��̓C�^�R�ł��B�ق�A�N���̐�����������c�c�B</p>',
        '<p>���Ȃ��͐l�T�X�L�[�ł��B�D���Ȑl�T�̂��߂ɂ���΂�܂��傤�B</p>',
        '<p>�D���Ȑl������ĉ������B�ł��X�g�[�L���O�͕߂܂�Ȃ����x�ɁB</p>',
        '<p>���Ȃ��̓��u���u�ł��B����v�w�ł��B���u���u�Ȑl���N���킩��܂��B</p>',
        '<p>���Ȃ��̓n���ł��B�{�����X�H�@�Ƃ��Ƃ��A�Ƃ��Ƃ��H</p>',
        '<p>�p�b�V�����I�@�p�b�V�����I�@�c�c�����������邺���������I<br>�i�l�T���_���j</p>',
        '<p>_ROLESUBID_�{�͂������ƌ�����悤�ɁB<br>�i�{�����B����������Ȃ���H�j</p>',
        '<p>�D���Ȑl�T�̂��߂ɂ���΂�܂����傢�I<br>�i�l�T���M�ҁj</p>',
        '<p>���Ȃ��͂����ǂ�v�w�ł��B���u���u�߂��Ăނӂӂɉ�b�ł���̂ŁA���u���u���Ƃ��Ă��������B</p>',
        '<p>�R�E��������I�@�R�E��������I�@�����g�ŉ�b���܂����B</p>',
        '<p>���Ȃ��͂낭�ł��Ȃ������ł��B�]��ɂ낭�ł��Ȃ��̂ł��Ȃ���`�����G�X�p�[�͋t���݂Ŏ��ɂ܂��B<br>�i�t���ݘT�j</p>',
        '<p>���Ȃ��̓O�����Ȉ����ł��B�オ�삦�Ă���̂ŁA���炰�����肪���҂Ȃ̂��킩��܂��B<br>�i�O�����j</p>',
        '<p>���Ȃ��͑��������ׂւƒ@�����ގ����O�x�̔т�����D���Ƃ����A�ƂĂ��f���炵�����i�̎�����ł��B���S���ӂ������āA���̂��߂ɍ����������܂��傤�B���ււււց�<br>�i�C�^�Y�����q�j</p>',
        '<p>���Ȃ��͂���`�҂��ǂł��B�撣���ĂˁB'
    );

    my %explain_roles = (
        prologue  => '_SELROLE_�ɂȂ肽���炵�����A��]���ʂ�Ȃ��Ă����͎󂯕t���Ȃ��B',
        noselrole => '_SELROLE_�ɂȂ肽���炵�����A����Ȃ��͖̂�������B',
        dead      => '���񂽂�_ROLE_������炵�����A������܂�����݂�ȓ�����B',
        epilogue  => '_SELROLE_����]����_ROLE_�������B��]�ʂ�łȂ��Ă��\��Ă͂����Ȃ��B',
        explain   => \@explain_role,
    );

    my @votelabels = ( '���E', '�ϑ�', );

    my @caption_rolesay = (
        '',          # ����`
        '',          # ���l
        '忂�',        # �l�T
        '',          # �肢�t
        '',          # ��\��/��}�t
        '',          # ���l
        '',          # ��l/����
        '',          # ���L��/���Ј�
        '',          # �n���X�^�[�l��/�d��/�d��
        '忂�',        # �b�����l
        '',          # ������
        '',          # ���M��
        '�d�b',        # ����
        '�d�g',        # �R�E�����l��
        '忂�',        # �t���ݘT
        '忂�',        # �O����
        '',          # �C�^�Y�����q
        '���̂����₫',    # �L���[�s�b�h�A���������l���m�̚����Ƃ��Ďg����
    );

    my @abi_role = (
        '',          # ����`
        '',          # ���l
        '�H��',        # �l�T
        '����',        # �肢�t
        '',          # ��\��/��}�t
        '',          # ���l
        '����t��',      # ��l/����
        '',          # ���L��/���Ј�
        '',          # �n���X�^�[�l��/�d��/�d��
        '',          # �b�����l
        '',          # ������
        '',          # ���M��
        '',          # ����
        '',          # �R�E�����l��
        '�H��',        # �t���ݘT
        '�i�]',        # �O����
        '�M��',        # �C�^�Y�����q
        '����',        # ����`�҂���
    );

    # �����҂̐F
    # �ܐl�����Ă��鏊�����Ă݂����i����
    my @stigma_subid = ( '�Ԃ�', '��', '����', '�΂�', '����', );

    my @result_seer = ( '_NAME_ ��_RESULT_�������c�c�悤�ȋC������B', '��', '�y���z', );

    # �z���\����
    my %caption_roletable = (
        default => '�ӂ[',
        hamster => '�n���n��',
        wbbs_c  => '�����܂�',
        test1st => '��^�H',
        test2nd => '������^',
        wbbs_g  => '���[����',
        custom  => '��������',
    );

    my @actions = (
        '���n���Z���ŉ������B',       '���p�\�R���ŉ������B',      '���|�S���n���Z���ŉ������B', '���Z���~�b�N�n���Z���ŉ������B',
        '���I���n���R���n���Z���ŉ������B', '���Ԃ���΂����B',        '�ɂ�������ׁ[�������B',   '�Ɏ��U�����B',
        '�̓��𕏂ł��B',          '���P���Ă݂��B',         '���Ԃ߂�U��������B',    '�ɋ��������B',
        '�ɂނ��イ�����B',         '�Ɉ��ʂ��Ԃ񓊂���U��������B', '�ɂ����������B',
    );

    my %textrs = (
        CAPTION => '�K���n',

        # �_�~�[�L�����̎Q���\���i����������Ă��܂����j�̗L��
        NPCENTRYMES => 1,

        # ���J�A�i�E���X
        ANNOUNCE_EXTENSION  => '�l����˂����牄�΂��Ă�������B�[�����U���Ă�����B',
        ENTRYMES            => '_NAME_ �������炵����i_NO_�l�ځc�c���������Ȃ��H�j�B',
        EXITMES             => '_NAME_ ���o�čs�����炵����B',
        SUDDENDEATH         => '_NAME_ �́A�Ԃ��|�ꂽ�B',
        SUICIDEBONDS        => '_NAME_ �� _TARGET_ �̊����Y����H�����B',
        SUICIDELOVERS       => '_NAME_ �� _TARGET_ �Ƃ̐Ԃ����̐ؒf�Ɏ��s�����悤���B',
        ANNOUNCE_RANDOMVOTE => '�����K����',
        ANNOUNCE_VICTORY    => '_VICTORY_���̏����ł��I<br>',
        ANNOUNCE_EPILOGUE   => '_AVICTORY_�S�Ẵ��O�ƃ��[�U�[�������J���܂��B_DATE_ �܂Ŏ��R�ɏ������߂܂��̂ŁA����̊��z�Ȃǂ��ǂ����B',

        # �\�͊֘A
        UNDEFTARGET      => '���l�C��',
        RANDOMTARGET     => '�N�ł�����',
        RANDOMROLE       => '�Ă��Ɓ[',                                                      # ��E�����_����]
        NOSELROLE        => '��E��]�H�@����Ȃ��̂͒m���ȁB',
        SETRANDOMROLE    => '�^���̐_�͂߂�ǂ��������� _NAME_ �̖�E��]�� _SELROLE_ �Ɍ��߂��B',
        SETRANDOMTARGET  => '_NAME_ �͔\�́i_ABILITY_�j�̑Ώی����V�ɔC�����B�V�͂��������� _TARGET_ �Ɍ��߂��B',
        CANCELTARGET     => '_NAME_ �� _ABILITY_�A�N�����������[�˂�B�N��������񂯁B',
        EXECUTESEER      => '_NAME_ �́A_TARGET_ ��`�����񂾁B',
        EXECUTEKILL      => '���� _TARGET_�I',
        EXECUTEGUARD     => '_NAME_ �́A_TARGET_ �ɒ���t���Ă���B',
        EXECUTETRICKSTER => '_NAME_ �́A_TARGET1_ �� _TARGET2_ ���ǂ����悤���Ȃ��􂢂ɂ������B���ւււցB',
        EXECUTECUPID     => '_NAME_ �́A_TARGET1_ �� _TARGET2_ �������J�Ō��񂾁B',
        RESULT_GUARD     => '_TARGET_ �����C�o���̏P�������蔲�����B',
        RESULT_KILL      => '_TARGET_ ��@���E�����B',
        RESULT_KILLIW    => '_TARGET_ �����������������i������ _ROLE_ �������炵���j�B',
        RESULT_FM        => '_ROLE_ �̂�����́A_TARGET_ �����I',
        RESULT_FANATIC   => '_NAME_ �������̐l�T�l�Ȃ̂ł��ˁI',
        MARK_BONDS       => '�J',
        RESULT_BONDS     => '���Ȃ��� _TARGET_ �Ƃ̎􂢂ɂ�����ꂽ�i�炵���j�B�i�^�����J�j',
        MARK_LOVERS      => '���l',
        RESULT_LOVERS    => '���Ȃ��� _TARGET_ �ƕs�ς̊֌W�ł��i�R�j�B�i���l�j',

        RANDOMENTRUST => '�����K����',

        # �A�N�V�����֘A
        ACTIONS_ADDPT     => '�Ɉ��ʂ��Ԃ񓊂����B_REST_',
        ACTIONS_RESTADDPT => '(�c_POINT_��)',
        ACTIONS_BOOKMARK  => '�����܂œǂ񂾂���ɂȂ����B',

        # ���샍�O�֘A
        ANNOUNCE_SELROLE       => '_NAME_ �� _SELROLE_ �ɂȂ��悤�A�V�ɋF�����B',
        ANNOUNCE_CHANGESELROLE => '_NAME_�́A��]�� _SELROLE_ �ɕύX���܂����i���̐l�ɂ͌����܂���j�B',
        ANNOUNCE_SETVOTE       => '��������������A_NAME_ �� _TARGET_ �ɓ��[���邺�I',
        ANNOUNCE_SETENTRUST    => '�߂�ǂ������B<br><br>�߂�ǂ���������A_NAME_ �� _TARGET_ �ɓ��[�C�����I',
        ANNOUNCE_SETTARGET     => '_NAME_ �́A�Ȃ�ƂȂ� _TARGET_ ��\�́i_ABILITY_�j�̑ΏۂɑI��ł݂��B',

        BUTTONLABEL_PC  => '_BUTTON_ / �X�V',
        BUTTONLABEL_MB  => '_BUTTON_',
        CAPTION_SAY_PC  => '����',
        CAPTION_SAY_MB  => '����',
        CAPTION_TSAY_PC => '�Q��',
        CAPTION_TSAY_MB => '�Q��',
        CAPTION_GSAY_PC => '����',
        CAPTION_GSAY_MB => '����',
        CAPTION_ROLESAY => \@caption_rolesay,

        ANNOUNCE_FIRST       => \@announce_first,
        ANNOUNCE_ROLE        => \@announce_role,
        ANNOUNCE_WINNER      => \@announce_winner,
        ANNOUNCE_LIVES       => \@announce_lives,
        ANNOUNCE_VOTE        => \@announce_vote,
        ANNOUNCE_COMMIT      => \@announce_commit,
        ANNOUNCE_TOTALCOMMIT => \@announce_totalcommit,
        ANNOUNCE_ENTRUST     => \@announce_entrust,
        ANNOUNCE_KILL        => \@announce_kill,
        CAPTION_WINNER       => \@caption_winner,
        ROLENAME             => \@rolename,
        ROLESHORTNAME        => \@roleshortname,
        EXPLAIN_ROLES        => \%explain_roles,
        ABI_ROLE             => \@abi_role,
        STIGMA_SUBID         => \@stigma_subid,
        RESULT_SEER          => \@result_seer,
        CAPTION_ROLETABLE    => \%caption_roletable,
        VOTELABELS           => \@votelabels,
        ACTIONS              => \@actions,
    );
    return \%textrs,;
}

1;
