package SWTextRS_wbbs10;

sub GetTextRS {
	# �v�����[�O�`�Q���ڂ̊J�n�����b�Z�[�W
	my @announce_first = (
		'���Ԃ͐l�Ԃ̂ӂ�����āA��ɐ��̂������Ƃ����l�T�B<br>���̐l�T���A���̑��ɕ��ꍞ��ł���Ƃ����\���L�������B<br><br>���l�B�͔��M���^�Ȃ�����A���͂���̏h�ɏW�߂��邱�ƂɂȂ����B',
		'�����A����̎p�����ɉf���Ă݂悤�B<br>�����ɉf��̂͂����̑��l���A����Ƃ����ɋQ�����l�T���B<br><br>�Ⴆ�l�T�ł��A���l���ŗ����������Ε|���͂Ȃ��B<br>���́A���ꂪ�l�T�Ȃ̂��Ƃ��������B<br>�肢�t�̔\�͂����l�ԂȂ�΁A��������j��邾�낤�B',
		'���ɋ]���҂��o���B�l�T�͂��̑��l�B�̂Ȃ��ɂ���B<br>�������A��������������i�͂Ȃ��B<br><br>���l�B�́A�^�킵���҂�r�����邽�߁A���[���s�����ɂ����B<br>�����̋]���҂��o��̂���ނ����Ȃ��B�����S�ł�����́c�c�B<br><br>�Ō�܂Ŏc��̂͑��l���A����Ƃ��l�T���B',
	);

	# ��E�z���̂��m�点
	my @announce_role = (
		'�ǂ���炱�̒��ɂ́A_ROLE_����悤���B',
		'��',
		'��',
		'�A',
	);

	# �����҂̂��m�点
	my @announce_lives = (
		'���݂̐����҂́A',
		'�A',
		' �� _LIVES_ ���B',
	);

	# ���Y���̂��m�点
	my @announce_vote =(
		'_NAME_ �� _TARGET_ �ɓ��[�����B_RANDOM_',
		'_NAME_ �� _COUNT_�l�����[�����B',
		'_NAME_ �͑��l�B�̎�ɂ�菈�Y���ꂽ�B'
	);

	# �ϔC���[�̂��m�点
	my @announce_entrust = (
		'_NAME_��_TARGET_�ɓ��[���ϔC���Ă��܂��B_RANDOM_',
		'_NAME_��_TARGET_�ɓ��[���ϔC���悤�Ƃ��܂������A�����s�\�ł����B_RANDOM_',
	);

	# �R�~�b�g
	my @announce_commit = (
		'_NAME_���u���Ԃ�i�߂�v���������܂����B',
		'_NAME_���u���Ԃ�i�߂�v��I�����܂����B',
	);

	# �R�~�b�g��
	my @announce_totalcommit = (
		'�u���Ԃ�i�߂�v��I�����Ă���l�͂��Ȃ����A�܂����Ȃ��悤�ł��B', # 0�`1/3�̎�
		'�u���Ԃ�i�߂�v��I�����Ă���l�͑S�̂�1/3����2/3�̊Ԃ̂悤�ł��B', # 1/3�`2/3�̎�
		'�����̐l���u���Ԃ�i�߂�v��I�����Ă��܂����A�S���ł͂Ȃ��悤�ł��B', # 2/3�`n-1�̎�
		'�S�����u���Ԃ�i�߂�v��I�����Ă��܂��B', # �S���R�~�b�g�ς�
	);

	# �P�����ʃ��b�Z�[�W
	my @announce_kill = (
		'�����͋]���҂����Ȃ��悤���B�l�T�͏P���Ɏ��s�����̂��낤���B',
		'���̓��̒��A_TARGET_ �����c�Ȏp�Ŕ������ꂽ�B',
	);

	# ���s���b�Z�[�W
	my @announce_winner = (
		'���̓��̒��A�Z�l�S�Ă����R�Ǝp���������B',
		'�S�Ă̐l�T��ގ������c�c�B�l�T�ɋ�������X�͋������̂��I',
		'�����l�T�ɒ�R�ł���قǑ��l�͎c���Ă��Ȃ��c�c�B<br>�l�T�͎c�������l��S�ĐH�炢�A�ʂ̊l�������߂Ă��̑��������Ă������B',
		'�S�Ă͏I��������̂悤�Ɍ������B<br>�����A�z�������c���Ă����c�c�B',
		'�S�Ă͏I��������̂悤�Ɍ������B<br>�����A�z�������c���Ă����c�c�B',
	);

	# ������
	my @caption_winner = (
		'',
		'���l',
		'�l�T',
		'������',
		'������',
	);

	# ��E��
	my @rolename = (
		'���܂���',
		'���l',
		'�l�T',
		'�肢�t',
		'��\��',
		'���l',
		'��l',
		'���L��',
		'�n���X�^�[�l��',
		'�b�����l',
		'������',
		'���M��',
		'����',
		'�R�E�����l��',
		'���T',
		'�q�T',
		'�s�N�V�[',
	);

	# ��E���i�ȗ����j
	my @roleshortname = (
		'��',
		'��',
		'�T',
		'��',
		'��',
		'��',
		'��',
		'��',
		'�n',
		'�b',
		'��',
		'�M',
		'��',
		'�P',
		'��',
		'�q',
		'�s',
	);

	# ��E�̐���
	my @explain_role = (
		'<p>���Ȃ��́A����`�̖�E�ł��B</p>',
		'<p>���Ȃ��́A�����̑��l�ł��B���������Ȃ��̐����͂┭�����A���l���̏����̌��ƂȂ�Ƃ�������܂���B</p>',
		'<p>���Ȃ��͐l�T�ł��B���l��l�T�Ɠ����܂Ō��点�Ώ����ł��B���l�Ɍ���Ȃ��悤�ɐT�d�Ɏז��҂�r�����Ă����܂��傤�B</p><p>�u�l�T�̂����₫�v�͐l�T�i�Ƃb�����l�j�ɂ����������܂���B���ԂƂ̘A���ɂ����p���������B</p>',
		'<p>���Ȃ��͐肢�t�ł��B����A�N���ЂƂ��肤���Ƃ��ł��܂��B����ɂ��A���肪�l�T���l�Ԃ���m�邱�Ƃ��ł��܂��B</p>',
		'<p>���Ȃ��͗�\�҂ł��B���Y�ɂ���Ė������������̂��A�l�Ԃł��������l�T�ł���������m�邱�Ƃ��ł��܂��B</p>',
		'<p>���Ȃ��͋��l�ł��B�l�T���̏�����]��ł��܂��B����āA�l�T���̏��������Ȃ��̏����ƂȂ�܂��B</p><p>�l�T���̏����̂��߁A�����ɋc�_�������܂킵�ĉ������B</p>',
	'<p>���Ȃ��͎�l�ł��B����A�ЂƂ肾�����A�l�T�̏P�������鎖���ł��܂��B�l�T�̍s����ǂ݁A���l�B��l�T�������ĉ������B</p>',
		'<p>���Ȃ��͋��L�҂ł��B���̋��L�҂��N�ł��邩��m�鎖���ł��܂��B</p>',
		'<p>���Ȃ��̓n���X�^�[�l�Ԃł��B���l���ɂ��l�T���ɂ������Ȃ��Ǎ��̑��݂ł��B���l�����l�T�������������𖞂��������ɂ��Ȃ����������тĂ���΁A���Ȃ��̏����ƂȂ�܂��B<br>�N�ɂ����̂�m���Ȃ��悤�A���ςɍs�����ĉ������B</p><p>�n���X�^�[�l�Ԃ͐l�T�ɏP������܂���B�n���X�^�[�l�Ԃ͐����Ǝ��S���܂��B</p>',
		'<p>���Ȃ��͂b�����l�ł��B�l�T���̏�����]��ł��܂��B����āA�l�T���̏��������Ȃ��̏����ƂȂ�܂��B</p><p>�l�T���̏����̂��߁A�����ɋc�_�������܂킵�ĉ������B</p><p>�u�l�T�̂����₫�v�͐l�T�Ƃb�����l�ɂ����������܂���B���ԂƂ̘A���ɂ����p���������B</p>',
		'<p>���Ȃ���_ROLESUBID_�����҂ł��B</p>',
		'<p>���Ȃ��͋��M�҂ł��B�l�T���̏�����]��ł��܂��B����āA�l�T���̏��������Ȃ��̏����ƂȂ�܂��B</p><p>�l�T���̏����̂��߁A�����ɋc�_�������܂킵�ĉ������B</p><p>���M�҂ɂ͐l�T���N���킩��܂��B</p>',
		'<p>���Ȃ��͋��҂ł��B���̋��҂��N�ł��邩��m�鎖���ł��܂��B</p><p>�u���v�͋��҂ɂ����������܂���B���ԂƂ̘A���ɂ����p���������B</p>',
		'<p>���Ȃ��̓R�E�����l�Ԃł��B���l���ɂ��l�T���ɂ��������A�n���X�^�[�l�ԂƓ��w�c�ɂȂ�܂��B���l�����l�T�������������𖞂��������Ƀn���X�^�[�l�Ԃ��R�E�����l�Ԃ��������тĂ���΁A���Ȃ��̏����ƂȂ�܂��B</p><p>�n���X�^�[�l�Ԃ͐l�T�ɏP������܂���B�n���X�^�[�l�Ԃ͐����Ǝ��S���܂��B</p><p>�u�O�b�v�̓R�E�����l�Ԃɂ����������܂���B���ԂƂ̘A���ɂ����p���������B</p>',
		'<p>���Ȃ��͎��T�ł��B���l��l�T�Ɠ����܂Ō��点�Ώ����ł��B���l�Ɍ���Ȃ��悤�ɐT�d�Ɏז��҂�r�����Ă����܂��傤�B���Ȃ��������肢�t�͎��S���܂��B</p><p>�u�l�T�̂����₫�v�͐l�T�i�Ƃb�����l�j�ɂ����������܂���B���ԂƂ̘A���ɂ����p���������B</p>',
		'<p>���Ȃ��͒q�T�ł��B���l��l�T�Ɠ����܂Ō��点�Ώ����ł��B���l�Ɍ���Ȃ��悤�ɐT�d�Ɏז��҂�r�����Ă����܂��傤�B���Ȃ��͎E�Q��������̖�E���킩��܂��B</p><p>�u�l�T�̂����₫�v�͐l�T�i�Ƃb�����l�j�ɂ����������܂���B���ԂƂ̘A���ɂ����p���������B</p>',
		'<p>���Ȃ��̓s�N�V�[�ł��B���l���ɂ��l�T���ɂ��������A�n���X�^�[�l�ԂƓ��w�c�ɂȂ�܂��B���l�����l�T�������������𖞂��������Ƀn���X�^�[�l�Ԃ��R�E�����l�Ԃ��s�N�V�[���������тĂ���΁A���Ȃ��̏����ƂȂ�܂��B</p><p>�s�N�V�[�͐l�T�ɏP������Ă����ɂ܂���B�s�N�V�[�͐����Ǝ��S���܂��B</p><p>�s�N�V�[�͂P���ځA�D���ȓ�l�Ɂg�^�����J�h�����т��鎖���ł��܂��B�g�^�����J�h�����񂾐l�́A�Е������S����ƌ��ǂ��悤�Ɏ��S���܂��B</p>',
	);

	# ��E��]
	my %explain_roles = (
		prologue  => '���Ȃ���_SELROLE_����]���Ă��܂��B�������A��]�����ʂ�̔\�͎҂ɂȂ��Ƃ͌���܂���B',
		noselrole => '���Ȃ���_SELROLE_����]���Ă��܂����A��]�͖����ł��B',
		dead      => '���Ȃ���_ROLE_�ł������A���S���Ă��܂��B',
		epilogue  => '���Ȃ���_ROLE_�ł����i_SELROLE_����]�j�B',
		explain   => \@explain_role,
	);

	# ���[���\��
	my @votelabels = (
		'���[',
		'�ϔC',
	);

	# �\�͎җp���ꔭ�����̃��x��
	my @caption_rolesay = (
		'',       # ����`
		'',       # ���l
		'����',   # �l�T
		'',       # �肢�t
		'',       # ��\��/��}�t
		'',       # ���l
		'',       # ��l/����
		'',       # ���L��/���Ј�
		'',       # �n���X�^�[�l��/�d��/�d��
		'����',   # �b�����l
		'',       # ������
		'',       # ���M��
		'����',   # ����
		'�O�b',   # �R�E�����l��
		'����',   # ���T
		'����',   # �q�T
		'',       # �s�N�V�[
	);

	# �\�͖�
	my @abi_role = (
		'',     # ����`
		'',     # ���l
		'�P��', # �l�T
		'�肤', # �肢�t
		'',     # ��\��/��}�t
		'',     # ���l
		'���', # ��l/����
		'',     # ���L��/���Ј�
		'',     # �n���X�^�[�l��/�d��/�d��
		'',     # �b�����l
		'',     # ������
		'',     # ���M��
		'',     # ����
		'',     # �R�E�����l��
		'�P��', # ���T
		'�P��', # �q�T
		'����', # �s�N�V�[
	);

	# �����҂̐F
	# �ܐl�����Ă��鏊�����Ă݂����i����
	# �l����ς��鎞�́A�ݒ�t�@�C���� MAXCOUNT_STIGMA ��ς��鎖�B
	my @stigma_subid = (
		'�Ԃ�',
		'��',
		'����',
		'�΂�',
		'����',
	);

	# �肢����
	my @result_seer = (
		'_NAME_ �� _RESULT_ �̂悤���B',
		'�l��',
		'�y�l�T�z',
	);

	# �z���\����
	my %caption_roletable = (
		default => '�W��',
		hamster => '�n������',
		wbbs_c  => '�b��',
		test1st => '������^',
		test2nd => '������^',
		wbbs_g  => '�f��',
		custom  => '���R�ݒ�',
	);

	# �A�N�V����
	my @actions = (
		'�ɑ��Â���ł����B',
		'���������B',
		'�Ɏ���X�����B',
		'�������ƌ��߂��B',
		'��M���̖ڂŌ����B',
		'�����b�����Ɍ����B',
		'��s�M�̖ڂŌ����B',
		'���w�������B',
		'���������B',
		'�ɋ������B',
		'�ɍ��f�����B',
		'�ɂ��낽�����B',
		'�ɋ������B',
		'�ɏƂꂽ�B',
		'�ɂ����V�������B',
		'�Ɏ��U�����B',
		'�ɔ��΂񂾁B',
		'�ɔ��肵���B',
		'���x�������B',
		'���Ԃ߂��B',
		'�ɕʂ���������B',
		'��������߂��B',
		'�����ꎞ�Ԗ₢�߂��B',
		'���n���Z���ŉ������B',
		'�ւ̑O����P�񂵂��B',
		'�Ɋ��ӂ����B',
	);

	my %textrs = (
		CAPTION => '�l�TBBS',

		# �_�~�[�L�����̎Q���\���i����������Ă��܂����j�̗L��
		NPCENTRYMES => 1,

		# ���J�A�i�E���X
		ANNOUNCE_EXTENSION  => '����ɒB���Ȃ��������߁A���̍X�V������24���ԉ�������܂����B',
		ENTRYMES            => '_NO_�l�ځA_NAME_ ������Ă��܂����B',
		EXITMES             => '_NAME_�������o�čs���܂����B',
		SUDDENDEATH         => '_NAME_ �́A�ˑR�������B',
		SUICIDEBONDS        => '_NAME_ ���J�Ɉ���������悤�� _TARGET_ �̌��ǂ����B',
		SUICIDELOVERS       => '_NAME_ �͈����݂ɕ��� _TARGET_ �̌��ǂ����B',
		ANNOUNCE_RANDOMVOTE => '(�����_�����[)',
		ANNOUNCE_VICTORY    => '_VICTORY_���̏����ł��I<br>',
		ANNOUNCE_EPILOGUE   => '_AVICTORY_�S�Ẵ��O�ƃ��[�U�[�������J���܂��B_DATE_ �܂Ŏ��R�ɏ������߂܂��̂ŁA����̊��z�Ȃǂ��ǂ����B',

		RANDOMENTRUST => '(�����_���ϔC)',

		# �\�͊֘A
		UNDEFTARGET     => '���܂���',
		RANDOMTARGET    => '�����_��',
		RANDOMROLE      => '�����_��', # ��E�����_����]
		NOSELROLE       => '���̐ݒ肪�u��E��]�����v�̂��߁A�S�Ă̖�E��]����������܂��B',
		SETRANDOMROLE   => '_NAME_ �̖�E��]�� _SELROLE_ �Ɏ������肳��܂����B',
		SETRANDOMTARGET => '_NAME_ �̔\�́i_ABILITY_�j�̑Ώۂ� _TARGET_ �Ɏ������肳��܂����B',
		CANCELTARGET    => '_NAME_ �̔\�́i_ABILITY_�j�ɗL���ȑΏۂ�����܂���ł����B',
		EXECUTESEER     => '_NAME_ �́A_TARGET_ �������B',
		EXECUTEKILL     => '_TARGET_�I ���������O�̖������I',
		EXECUTEGUARD    => '_NAME_ �́A_TARGET_ ������Ă���B',
		EXECUTETRICKSTER => '_NAME_ �́A_TARGET1_ �� _TARGET2_ �Ƃ̊Ԃɉ^�����J�����񂾁B',
		RESULT_GUARD    => '_TARGET_ ��l�T�̏P�����������B',
		RESULT_KILL     => '_TARGET_ ���E�Q�����B',
		RESULT_KILLIW   => '_TARGET_ ���E�Q�����i_TARGET_ �� _ROLE_ �������悤���j�B',
		RESULT_FM       => '������l��_ROLE_�́A_TARGET_ �ł��B',
		RESULT_FANATIC  => '_NAME_ �� �l�T �̂悤���B',
		MARK_BONDS       => '�J',
		RESULT_BONDS    => '���Ȃ��� _TARGET_ �Ɖ^�����J������ł��܂��B',
		MARK_LOVERS      => '���l',
		RESULT_LOVERS   => '���Ȃ��� _TARGET_ �ƈ��������Ă��܂��B',

		# �A�N�V�����֘A
		ACTIONS_ADDPT     => '�ɘb�̑����𑣂����B_REST_',
		ACTIONS_RESTADDPT => '(�c_POINT_��)',
		ACTIONS_BOOKMARK  => '�����܂œǂ񂾁B',

		# ���샍�O�֘A
		ANNOUNCE_SELROLE    => '_NAME_�́A_SELROLE_ ����]���܂����i���̐l�ɂ͌����܂���j�B',
		ANNOUNCE_CHANGESELROLE    => '_NAME_�́A��]�� _SELROLE_ �ɕύX���܂����i���̐l�ɂ͌����܂���j�B',
		ANNOUNCE_SETVOTE    => '_NAME_�́A_TARGET_ �𓊕[��ɑI�т܂����B',
		ANNOUNCE_SETENTRUST => '���[���ϔC���܂��B<br><br>_NAME_�́A_TARGET_ �ɓ��[���ϔC���܂����B',
		ANNOUNCE_SETTARGET  => '_NAME_�́A_TARGET_ ��\�́i_ABILITY_�j�̑ΏۂɑI�т܂����B',

		BUTTONLABEL_PC  => '_BUTTON_ / �X�V',
		BUTTONLABEL_MB  => '_BUTTON_',
		CAPTION_SAY_PC  => '����',
		CAPTION_SAY_MB  => '����',
		CAPTION_TSAY_PC => '�Ƃ茾',
		CAPTION_TSAY_MB => '�Ƃ茾',
		CAPTION_GSAY_PC => '���҂̂��߂�',
		CAPTION_GSAY_MB => '���߂�',
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
	return \%textrs,
}

1;