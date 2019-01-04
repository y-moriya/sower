package SWConfig;

#----------------------------------------
# �ݒ�t�@�C��
#----------------------------------------
sub GetConfig {
	# PC���[�h�̕\�������ꗗ
	my @row_pc = (10, 20, 30, 50, 100, 200);

	# �g�у��[�h�̕\�������ꗗ
	my @row_mb = (5, 10, 20, 30, 50, 100);

	# �L�����N�^�[�Z�b�gID
	my @csidlist = (
    	'rem',
		'sow',
		'troika',
		'ao',
		'wbbs',
	);

	# �����񃊃\�[�X�Z�b�gID
	my @trsidlist = (
		'sow',
		'wbbs',
		'juna',
		'fool',
		'ao'
	);

	# act/memo �ݒ�p
	my @noactlist = (
		'�A�N�V�����A������',		# 0
		'�A�N�V�����s�A������',	# 1
		'�A�N�V�����A�����s��',	# 2
		'�A�N�V�����s�A�����s��',	# 3
	);

	my %infocap = (
		vname          => '���̖��O',
		vcomment       => '���̐���',
		csid           => '�o��l��',
		trsid          => '���͌n',
		roletable      => '��E�z��',
		updhour        => '�X�V����',
		updminite      => '�X�V����',
		updinterval    => '�X�V�Ԋu',
		entrylimit     => '�Q������',
		entrypwd       => '�Q���p�X���[�h',
		rating         => '�{������',
		vplcnt         => '���',
		vplcntstart    => '�Œ�J�n�l��',
		saycnttype     => '��������',
		randomtarget   => '�����_��',
		noselrole      => '��E��]',
		makersaymenu   => '�i�s���̑����Đl������',
		entrustmode    => '�ϔC',
		showall        => '�扺���J',
		noactmode      => 'act/memo',
		nocandy        => '����',
		nofreeact      => '���R���A�N�V����',
		commitstate    => '�R�~�b�g��',
		showid         => 'ID���J',
		idrecord       => 'ID�L�^',
		timestamp      => '�����\��',
		votetype       => '���[���@',
		starttype      => '�J�n���@',

	);
	# ��������
	my %saycnt_real = (
		CAPTION     => '���A�[(500pt)',
		COUNT_TYPE  => 'point', # �|�C���g����
		MAX_SAY     =>  500, # �ʏ픭����
		MAX_TSAY    => 10000, # �Ƃ茾������
		MAX_WSAY    => 15000, # ����������
		MAX_SPSAY   =>  8000, # ��������
		MAX_BSAY    => 15000, # �O�b������
		MAX_GSAY    => 15000, # ���߂�������
		MAX_PSAY    => 10000, # �v�����[�O������
		MAX_ESAY    => 3000, # �G�s���[�O������
		MAX_SAY_ACT =>   24, # �A�N�V������
		ADD_SAY     =>  200, # �����ő����锭����
		MAX_ADDSAY  =>    1, # �����̉�
		MAX_MESCNT  =>  1000, # �ꔭ���̍ő�o�C�g��
		MAX_MESLINE =>   25, # �ꔭ���̍ő�s��
	);

	# ��������
	my %saycnt_sow = (
		CAPTION     => '�����ƃ��A�[(300pt)',
		COUNT_TYPE  => 'point', # �|�C���g����
		MAX_SAY     =>  300, # �ʏ픭����
		MAX_TSAY    => 10000, # �Ƃ茾������
		MAX_WSAY    => 15000, # ����������
		MAX_SPSAY   =>  8000, # ��������
		MAX_BSAY    => 15000, # �O�b������
		MAX_GSAY    => 20000, # ���߂�������
		MAX_PSAY    => 10000, # �v�����[�O������
		MAX_ESAY    => 3000, # �G�s���[�O������
		MAX_SAY_ACT =>   24, # �A�N�V������
		ADD_SAY     =>  200, # �����ő����锭����
		MAX_ADDSAY  =>    1, # �����̉�
		MAX_MESCNT  =>  1000, # �ꔭ���̍ő�o�C�g��
		MAX_MESLINE =>   25, # �ꔭ���̍ő�s��
	);

	my %saycnt_wbbs = (
		CAPTION     => 'BBS(20��)',
		COUNT_TYPE  => 'count', # �񐔊���
		MAX_SAY     =>  20, # �ʏ픭����
		MAX_TSAY    =>  10, # �Ƃ茾������
		MAX_WSAY    =>  40, # ����������
		MAX_SPSAY   =>  20, # ��������
		MAX_BSAY    =>  30, # �O�b������
		MAX_GSAY    =>  20, # ���߂�������
		MAX_PSAY    =>  20, # �v�����[�O������
		MAX_ESAY    => 600, # �G�s���[�O������
		MAX_SAY_ACT =>  15, # �A�N�V������
		ADD_SAY     =>   4, # �����ő����锭����
		MAX_ADDSAY  =>   1, # �����̉�
		MAX_MESCNT  => 200, # �ꔭ���̍ő啶����
		MAX_MESLINE =>   5, # �ꔭ���̍ő�s��
	);

	my %saycnt_juna = (
		CAPTION     => '�R��(1000pt)',
		COUNT_TYPE  => 'point', # �o�C�g����
		MAX_SAY     => 1000, # �ʏ픭��pt��
		MAX_TSAY    =>  700, # �Ƃ茾����pt��
		MAX_WSAY    => 3000, # ��������pt��
		MAX_SPSAY   => 1000, # ��������
		MAX_BSAY    => 2000, # �O�b������
		MAX_GSAY    => 2000, # ���߂�����pt��
		MAX_PSAY    => 2000, # �v�����[�O����pt��
		MAX_ESAY    => 3000, # �G�s���[�O����pt��
		ADD_SAY     =>  200, # �����ő����锭��pt��
		MAX_ADDSAY  =>    1, # �����̉�
		MAX_SAY_ACT =>   24, # �A�N�V������
		MAX_MESCNT  => 1000, # �ꔭ���̍ő啶���o�C�g��
		MAX_MESLINE =>   20, # �ꔭ���̍ő�s��
	);

	my %saycnt_vulcan = (
		CAPTION     => '����(1500pt)',
		COUNT_TYPE  => 'point', # �|�C���g����
		MAX_SAY     => 1500, # �ʏ픭��pt��
		MAX_TSAY    => 10000, # �Ƃ茾����pt��
		MAX_WSAY    => 40000, # ��������pt��
		MAX_SPSAY   => 15000, # ��������
		MAX_BSAY    => 30000, # �O�b������
		MAX_GSAY    => 30000, # ���߂�����pt��
		MAX_PSAY    => 30000, # �v�����[�O����pt��
		MAX_ESAY    => 4500, # �G�s���[�O����pt��
		ADD_SAY     =>  200, # �����ő����锭��pt��
		MAX_ADDSAY  =>    1, # �����̉�
		MAX_SAY_ACT =>   36, # �A�N�V������
		MAX_MESCNT  => 1000, # �ꔭ���̍ő啶���o�C�g��
		MAX_MESLINE =>   30, # �ꔭ���̍ő�s��
	);

	my %saycnt_saving = (
		CAPTION     => '�ߖ�(15��)',
		COUNT_TYPE  => 'count', # �񐔊���
		MAX_SAY     =>  15, # �ʏ픭����
		MAX_TSAY    =>  10, # �Ƃ茾������
		MAX_WSAY    =>  30, # ����������
		MAX_SPSAY   =>  12, # ��������
		MAX_BSAY    =>  20, # �O�b������
		MAX_GSAY    =>  20, # ���߂�������
		MAX_PSAY    =>  20, # �v�����[�O������
		MAX_ESAY    => 600, # �G�s���[�O������
		MAX_SAY_ACT =>  10, # �A�N�V������
		ADD_SAY     =>   3, # �����ő����锭����
		MAX_ADDSAY  =>   1, # �����̉�
		MAX_MESCNT  => 200, # �ꔭ���̍ő啶����
		MAX_MESLINE =>   5, # �ꔭ���̍ő�s��
	);

	my %saycnt_gachi = (
		CAPTION     => '�K�`(1800pt)',
		COUNT_TYPE  => 'point', # �|�C���g����
		MAX_SAY     => 1800, # �ʏ픭��pt��
		MAX_TSAY    => 2000, # �Ƃ茾����pt��
		MAX_WSAY    => 4000, # ��������pt��
		MAX_SPSAY   => 1500, # ��������
		MAX_BSAY    => 3000, # �O�b������
		MAX_GSAY    => 3000, # ���߂�����pt��
		MAX_PSAY    => 3000, # �v�����[�O����pt��
		MAX_ESAY    => 4500, # �G�s���[�O����pt��
		ADD_SAY     =>  300, # �����ő����锭��pt��
		MAX_ADDSAY  =>    2, # �����̉�
		MAX_SAY_ACT =>   36, # �A�N�V������
		MAX_MESCNT  => 2000, # �ꔭ���̍ő啶���o�C�g��
		MAX_MESLINE =>   40, # �ꔭ���̍ő�s��
	);

	my @saycnt_order = ('real', 'sow', 'wbbs', 'juna', 'vulcan', 'saving', 'gachi');
	my %saycnt = (
		ORDER    => \@saycnt_order,
		real     => \%saycnt_real,
		sow      => \%saycnt_sow,
		wbbs     => \%saycnt_wbbs,
		juna     => \%saycnt_juna,
		vulcan   => \%saycnt_vulcan,
		saving   => \%saycnt_saving,
		gachi    => \%saycnt_gachi,
	);

	my @real11_hours = (5, 1);
	my @real16_hours = (5, 1);

	my %automv_real11 = (
		autoid      => 'real11',
		autoflag    => 0,
		vname       => 'auto',
		vcomment    => '���̑��͎����I�Ɍ��Ă�ꂽ���ł��B<br>�g�b�v�y�[�W�ɏ�����Ă��郋�[�����悭�ǂ�ł���Q�����Ă��������B',
		trsid       => 'rem',
		csid        => 'rem',
		roletable   => 'wbbs_g',
		hour        => 5,
		hours       => \@real11_hours,
		minite      => 0,
		updinterval => 1,
		vplcnt      => 11,
		entrylimit  => 'free',
		entrypwd    => '',
		rating      => 'default',
		vplcntstart => 11,
		saycnttype  => 'real',
		votetype    => 'anonymity',
		starttype   => 'wbbs',
		randomtarget=> '',
		noselrole   => 'on',
		makersaymenu=> 'on',
		entrustmode => 'on',
		showall     => 'on',
		noactmode   => 2,
		nocandy     => 'on',
		nofreeact   => 'on',
		commitstate => '',
		showid      => '',
		idrecord    => '',
		timestamp   => 'on',

	);

	my %automv_real16 = (
		autoid      => 'real16',
		autoflag    => 1,
		vname       => 'auto',
		vcomment    => '���̑��͎����I�Ɍ��Ă�ꂽ���ł��B<br>�g�b�v�y�[�W�ɏ�����Ă��郋�[�����悭�ǂ�ł���Q�����Ă��������B',
		trsid       => 'rem',
		csid        => 'rem',
		roletable   => 'wbbs_g',
		hour        => 5,
		hours       => \@real16_hours,
		minite      => 0,
		updinterval => 1,
		vplcnt      => 16,
		entrylimit  => 'free',
		entrypwd    => '',
		rating      => 'default',
		vplcntstart => 11,
		saycnttype  => 'real',
		votetype    => 'anonymity',
		starttype   => 'wbbs',
		randomtarget=> '',
		noselrole   => 'on',
		makersaymenu=> 'on',
		entrustmode => 'on',
		showall     => 'on',
		noactmode   => 2,
		nocandy     => 'on',
		nofreeact   => 'on',
		commitstate => '',
		showid      => '',
		idrecord    => '',
		timestamp   => 'on',

	);

	my %automv = (
		real11 => \%automv_real11,
		real16 => \%automv_real16,
	);

	my @autonames = (
		'�ł̑�',
		'�F��̑�',
		'�C�ӂ̑�',
		'�i���̑�',
		'���Ԃ̑�',
		'�e�̑�',
		'�G�ߊO��̑�',
		'�v���̑�',
		'�k�J�̑�',
		'�P���̑�',
		'���J�̑�',
		'�E�l�̑�',
		'���݂�̑�',
		'�򌹂̑�',
		'�����̑�',
		'�T���̑�',
		'�����̑�',
		'����̑�',
		'�V��̑�',
		'�|���̑�',
		'��̑�',
		'�l�`�񂵂̑�',
		'�ʂ�����̑�',
		'�肢�̑�',
		'��䕂̑�',
		'�����̑�',
		'�X��̑�',
		'����̑�',
		'�Ӌ��̑�',
		'���Q�̑�',
		'�^�Ă̑�',
		'�݂���̑�',
		'�����̑�',
		'���ق̑�',
		'�ϑz�̑�',
		'�Ŗ�̑�',
		'�[���̑�',
		'�d���̑�',
		'�����̑�',
		'�ΉJ�̑�',
		'���Y�̑�',
		'�����̑�',
		'�O�t�̑�',
		'�a�̑�',
	);

	# �摜�̍�ғ��̕\���p
	my @copyrights = (
		'�l�T����摜 by Momoko Takatori',
		'SWBBS-R �摜 by rembrandt',
		'�g���C�J by <a href="http://asakp2.orsp.net/">������҂傱�҂傱�^��������</a>',
		'���ΘT by <a href="http://web1.kcn.jp/so-u-ko-u/">�d���̂����������^�����݂�</a>',
		'�l�TBBS10���N(��) �摜 by AICE',
	);

	# �L���b�V���N���A�̂��߃t�@�C�����ɓ��t����ꂽ�B�i�X�V�Y�ꂻ���j
	my %css_default = (
		TITLE => '�W���X�^�C��',
		FILE  => 'sow.css?date=20190104',
		WIDTH => 500,
	);

	my %css_text = (
		TITLE => '�ȈՕ\��',
		FILE  => 'text.css?date=20190104',
		WIDTH => 500,
	);

	my %css_junawide = (
		TITLE => '�R�╗',
		FILE  => 'junawide.css?date=20190104',
		WIDTH => 582,
#		FILE_TOPBANNER => 'mwtitle_juna.jpg',
#		WIDTH_TOPBANNER  => 500,
#		HEIGHT_TOPBANNER => 70,
	);

	my %css_rem = (
		TITLE => 'Style-R (default)',
		FILE  => 'rem.css?date=20190104',
		WIDTH => 600,
		FILE_TOPBANNER => 'remcss/remheader.png',
		WIDTH_TOPBANNER  => 600,
		HEIGHT_TOPBANNER => 70,
	);

	my %csslist = (
		sow      => \%css_default,
		text     => \%css_text,
		junawide => \%css_junawide,
		default  => \%css_rem,
	);

	# ���{�b�g�����p�̐ݒ�
	my @robots = (
	#	'noindex,nofollow',
	#	'noarchive',
	);

	# ���݂���
	# ���͌Œ�Ȃ̂ŕς��Ȃ���
	my @mikuji = (
		'���l�_',   #  3
		'�ꓙ��',   #  4
		'���g',   #  5
		'��g',     #  6
		'���g',     #  7
		'���g',     #  8
		'�g',       #  9
		'���g',     # 10
		'���g',     # 11
		'�����g',   # 12
		'��',       # 13
		'����',     # 14
		'����',     # 15
		'����',     # 16
		'�勥',     # 17
		'�񓚋���', # 18
	);

	# �{�������\��
	my %ratingnormal = (
		FILE    => '',
		CAPTION => '���',
		ALT     => '',
		WIDTH   => 0,
		HEIGHT  => 0,
	);

	my %rating15 = (
		FILE    => 'cau15.png',
		CAPTION => '15�Έȏ�',
		ALT     => 'R15',
		WIDTH   => 16,
		HEIGHT  => 16,
	);

	my %rating18 = (
		FILE    => 'cau18.png',
		CAPTION => '18�Έȏ�',
		ALT     => 'R18',
		WIDTH   => 16,
		HEIGHT  => 16,
	);

	my %ratinggro = (
		FILE    => 'caugro.png',
		CAPTION => '�O������',
		ALT     => '�O��',
		WIDTH   => 16,
		HEIGHT  => 16,
	);

	my %ratingview = (
		FILE    => 'cauview.png',
		CAPTION => '�{������',
		ALT     => '����',
		WIDTH   => 16,
		HEIGHT  => 16,
	);

	my @rating_order = ('default', 'r15', 'r18', 'gro', 'view');
	my %rating = (
		ORDER   => \@rating_order,
		default => \%ratingnormal,
		r15     => \%rating15,
		r18     => \%rating18,
		gro     => \%ratinggro,
		view    => \%ratingview,
	);

	my %cfg = (
		# 1:�����~�i�A�b�v�f�[�g�p�j
		ENABLED_HALT => 0,

		# 0:���̍쐬���ł��Ȃ��i���쐬�I���p�j
		# 1:�����쐬�\
		ENABLED_VMAKE => 1,

		NAME_SW      => '�l�T����',
		URL_SW       => 'http://***/sow', # �ݒu����URL�i�Ō�́g/�h�͕K�v����܂���j
		DESC_SW      => '�l�TBBS���̃E�F�u�Ől�T�N���[���B',
		ENABLED_MENU => 1, # 1:�g�b�v�y�[�W�̃��j���[��\������
		URL_HOME     => 'http://www.gunjobiyori.com/', # �z�[���y�[�W
		NAME_HOME    => '�Q���a(blog)',
		NAME_TOP	 => 'TOP',
		URL_BBS_PC   => 'http://www.twitter.com/euro_s', # �T�|�[�g�f����URL
		NAME_BBS_PC  => '@euro_s', # �T�|�[�g�f���̖��O
		URL_BBS_MB   => 'http://www.twitter.com/euro_s', # �T�|�[�g�f����URL�i�g�ь����j
		NAME_BBS_MB  => '@euro_s', # �T�|�[�g�f���̖��O�i�g�ь����j

		MAX_VILLAGES   =>  5, # �ő哯���ғ�����
		TIMEOUT_SCRAP  => 42, # �p������
		TIMEOUT_ENTRY  => 1.5, # �v�����[�O�ł̖������Ҏ����ǂ��o���@�\�̐�������

		MESFIXTIME        =>  20, # �ۗ�����
		MAX_ROW           =>  50, # �W���\�����̍s��
		MAX_ROW_MB        =>  10, # �W���\�����̍s���i���o�C���j
		MAX_PAGEROW_PC    => 100, # �y�[�W�\�����̍s��(���g�p)
		MAX_PAGES_MB      =>   5, # �y�[�W�����N�̕\����
		ROW_ACTION        =>   0, # �s���v�Z�ɃA�N�V�������܂ނ��ǂ���
		MIN_VSRECORDTOTAL =>   2, # ����ȏ㓯�����Ă��鑊��̂݁A�ΐ퐬�т�\��
		CANDY_LS          =>   5, # �������W�߂�Ƒ傫���Ȃ�

		ENABLED_TSAY_PRO     => 1, # �v�����[�O�ł̓Ƃ茾
		ENABLED_TSAY_GRAVE   => 1, # �扺�ł̓Ƃ茾
		ENABLED_TSAY_GUEST   => 1, # �T�ώ҂̓Ƃ茾
		ENABLED_TSAY_EP      => 1, # �G�s�ł̓Ƃ茾
		ENABLED_PERMIT_DEAD  => 1, # �扺�̐l�T/����/�R�E�����l�Ԃ������������邩�ǂ���
		ENABLED_DELETED      => 1, # �폜������\�����邩�ǂ���
		ENABLED_SUDDENDEATH  => 1, # 1:�ˑR������
		ENABLED_NOTICE_SD    => 0, # 1:�ˑR���ʒm����i�������j
		DAY_INITPENALTY      => 0, # �ˑR���Ȃǂ̃y�i���e�B�����l�i�P�ʂ͓����j
		ENABLED_MULTIENTRY   => 1, # 1:�|��������������
		ENABLED_RANDOMTARGET => 1, # 1:���[�E�\�͐�Ɂu�����_���v���܂߂�
		DEFAULT_VOTETYPE     => 'anonymity', # �W���̓��[���@(sign: �L���Aanonymity:���L��)
		DEFAULT_NOSELROLE    => 1, # 1:�f�t�H���g�Ŗ�E��]����
		DEFAULT_MAKERSAYMENU => 1, # 1:�f�t�H���g�Ői�s�����������s�\
		DEFAULT_ENTRUSTMODE  => 1, # 1:�f�t�H���g�ňϔC�s�\
		DEFAULT_SHOWALL      => 1, # 1:�f�t�H���g�ŕ扺���J
		DEFAULT_NOACTMODE    => 2, # �f�t�H���g��act/memo 0:on/on 1:off/on 2:on/off 3:off/off
		DEFAULT_NOCANDY      => 1, # 1:�f�t�H���g�ő����s�\
		DEFAULT_NOFREEACT    => 1, # 1:�f�t�H���g�Ŏ��R���A�N�V�����s�\
		DEFAULT_TIMESTAMP    => 1, # 1:�f�t�H���g�Ŏ����ȈՕ\��

		ENABLED_POPUP => 1, # �A���J�[�̃|�b�v�A�b�v

		USERID_NPC   => 'master', # �_�~�[�L�����̃��[�UID
		USERID_ADMIN => 'admin', # �Ǘ��l�̃��[�UID

		# �t�@�C�����b�N�@�\
		ENABLED_GLOCK => 1, # 0: none, 1: flock, 2: rename
		TIMEOUT_GLOCK => 5 * 60, # rename�����̎��̎��Ԑ؂�

		# �W���̃o�i�[�摜
		FILE_TOPBANNER   => 'mwtitle.jpg',
		TOPBANNER_WIDTH  => 500,
		TOPBANNER_HEIGHT => 70,

		#----------------------------------------
		# ���͒l�̐����l
		#----------------------------------------
		MAXSIZE_USERID => 32, # ���[�UID�̍ő�o�C�g��
		MINSIZE_USERID =>  2, # ���[�UID�̍ŏ��o�C�g��
		MAXSIZE_PASSWD =>  8, # �p�X���[�h�̍ő�o�C�g��
		MINSIZE_PASSWD =>  5, # �p�X���[�h�̍ŏ��o�C�g��

		MINSIZE_MES      =>   4, # �����̍ŏ��o�C�g��
		MAXSIZE_ACTION   =>  60, # �A�N�V�����̍ő�o�C�g��
		MINSIZE_ACTION   =>   4, # �A�N�V�����̍ő�o�C�g��
		MAXSIZE_MEMOCNT  => 300, # �����̍ő�o�C�g��
		MINSIZE_MEMOCNT  =>   4, # �����̍ŏ��o�C�g��
		MAXSIZE_MEMOLINE =>  15, # �����̍ő�s��

		MAXSIZE_VNAME    => 32,  # ���̖��O�̍ő�o�C�g��
		MINSIZE_VNAME    => 6,   # ���̖��O�̍ŏ��o�C�g��
		MAXSIZE_VCOMMENT => 600, # ���̐����̍ő�o�C�g��
		MINSIZE_VCOMMENT => 16,  # ���̐����̍ŏ��o�C�g��
		MAXSIZE_VPLCNT   => 25,  # ����̍ő吔
		MINSIZE_VPLCNT   =>  4,  # ����̍ŏ���

		MAXSIZE_HANDLENAME => 64,  # �n���h�����̍ő�o�C�g��
		MAXSIZE_URL        => 128, # URL�̍ő�o�C�g��
		MAXSIZE_INTRO      => 600, # ���ȏЉ�̍ő�o�C�g��

		MAXCOUNT_STIGMA => 5, # �����҂̍ő吔

		#----------------------------------------
		# �I�v�V�����@�\
		#----------------------------------------

		# ���������֌W
		AUTOMV_TIMING    => 'VSTATUSID_PLAY',
		AUTO_MAKEVILS    => \%automv,
		AUTO_NAMES       => \@autonames,

		# �Q�l
		# VSTATUSID_PRO      => 0, # �Q���ҕ�W���^�J�n�O
		# VSTATUSID_PLAY     => 1, # �i�s��
		# VSTATUSID_EP       => 2, # ���s�������܂���
		# VSTATUSID_END      => 3, # �I��
		# VSTATUSID_SCRAP    => 4, # �p���i�G�s���j
		# VSTATUSID_SCRAPEND => 5, # �p���I��

		# TypeKey�F�؁i�������j
		ENABLED_TYPEKEY => 0, # 1:TypeKey�F�؂�p����
		TOKEN_TYPEKEY => '',

		# QR�R�[�h
		# ���vQRcode Perl CGI & PHP scripts
		# http://www.swetake.com/qr/qr_cgi.html
		ENABLED_QR => 0, # 1:QR�R�[�h�o�͋@�\���g�p����
		URL_QR => '',

		# gzip�]���@�\
#		FILE_GZIP => '/bin/gzip',
		FILE_GZIP => '',

		DEFAULT_TEXTRS => 'sow', # �f�t�H���g�̕����񃊃\�[�X

		DEFAULT_UA => 'html401', # �f�t�H���g�̏o�͌`��
		ENABLED_PLLOG => 1, # 1:�v���C���[�̑��샍�O���L�^
		ENABLED_SCORE => 1, # �l�T���̏o��

		# RSS�o��
		ENABLED_RSS => 1,
		MAXSIZE_RSSDESC => 400, # RSS �� description�v�f�̍ő�o�C�g��
		RSS_ENCODING_UTF8  => 0, # 1:RSS�� UTF-8 �ŏo�͂���i�vJcode.pm�j

		# �����_���\���@�\
		ENABLED_RANDOMTEXT => 1,
		RANDOMTEXT_1D6     => '1d6',
		RANDOMTEXT_1D10    => '1d10',
		RANDOMTEXT_1D20    => '1d20',
		RANDOMTEXT_FORTUNE => 'fortune',
		RANDOMTEXT_LIVES   => 'who',
		RANDOMTEXT_MIKUJI  => 'omikuji',
		RANDOMTEXT_ROLE    => 'role',

		# �A�v���P�[�V�������O
		ENABLED_APLOG => 1,
		LEVEL_APLOG => 5,
		MAXSIZE_APLOG => 65536,
		MAXNO_APLOG => 9,
		ENABLED_HTTPLOG => 0, # HTTP���O�o��

		OUTPUT_HTTP_EQUIV => 1, # HTML�� http-equiv ���o�͂��鎞�� 1 �ɁB
		ENABLED_HTTP_CACHE => 0, # 1:�L���b�V�������L���ɂ���i�񐄏��j

		# form�v�f�� method�����l
		# ���܂����삵�Ȃ����� get �ɐݒ肵�Ă݂Ă��������B
		METHOD_FORM => 'post',

		# form�v�f�� method�����l�i�g�у��[�h�j
		# ��̂̌g�тɂ� post ���󂯕t���Ȃ���������炵���B
		# �ŋ߂̂Ȃ�܂����v���ۂ����ǁB
		METHOD_FORM_MB => 'post',

		MAXSIZE_QUERY => 65536,

		# ����
		TIMEZONE => 9, # JST

		# �N�b�L�[�̐�������
		TIMEOUT_COOKIE => 60 * 60 * 24 * 14,

		CID_MAKER   => 'maker', # �����Đl�p�̕֋X��̃L����ID
		CID_ADMIN   => 'admin', # �Ǘ��l�p�̕֋X��̃L����ID
		CID_GUEST   => 'guest', # �T�ώҗp�̕֋X��̃L����ID

		# ��{�f�B���N�g��
		BASEDIR_CGI => '.',
		BASEDIR_DOC => '.',
		BASEDIR_DAT => './data',

		ENABLED_DIRVIL => 1, # ���f�[�^�𑺔ԍ����Ƀf�B���N�g����������

		FILE_SOW       => "sow.cgi",
		FILE_VIL       => "vil.cgi",
		FILE_LOG       => "log.cgi",
		FILE_LOGINDEX  => "logidx.cgi",
		FILE_LOGCNT    => "logcnt.cgi",
		FILE_QUE       => "que.cgi",
		FILE_MEMO      => "memo.cgi",
		FILE_MEMOINDEX => "memoidx.cgi",
		FILE_SCORE     => "score.cgi",

		# �L���b�V���N���A�̂��߃t�@�C�����ɓ��t����ꂽ�B�i�X�V�Y�ꂻ���j
		FILE_JS_SOW    => "sow.js?date=20180104",
		FILE_JS_JQUERY => "jquery.js",
		FILE_JS_DRAG   => "jquery.easydrag.js",
		FILE_JS_FILTER => "filter.js",
		FILE_FAVICON   => "favicon.ico",

		PERMITION_MKDIR => 0777,

		MIKUJI           => \@mikuji,
		COPYRIGHTS       => \@copyrights,
		COUNTS_SAY       => \%saycnt,
		CSIDLIST         => \@csidlist,
		TRSIDLIST        => \@trsidlist,
		NOACTLIST        => \@noactlist,
		ROW_MB           => \@row_mb,
		ROW_PC           => \@row_pc,
		CSS              => \%csslist,
		RATING           => \%rating,
		ROBOTS           => \@robots,
		INFOCAP          => \%infocap,
	);

	my $cfglocalfile = "./_config_local.pl";
	if (-r $cfglocalfile) {
		require $cfglocalfile;
		&SWLocalConfig::GetLocalBaseDirConfig(\%cfg);
	}

	$cfg{'DIR_LIB'}        = "$cfg{'BASEDIR_CGI'}/lib";
	$cfg{'DIR_HTML'}       = "$cfg{'BASEDIR_CGI'}/html";
	$cfg{'DIR_RS'}         = "$cfg{'BASEDIR_CGI'}/rs";
	$cfg{'DIR_USER'}       = "$cfg{'BASEDIR_DAT'}/user";
	$cfg{'DIR_VIL'}        = "$cfg{'BASEDIR_DAT'}/vil";
	$cfg{'DIR_LOG'}        = "$cfg{'BASEDIR_DAT'}/log";
	$cfg{'DIR_RECORD'}     = "$cfg{'BASEDIR_DAT'}/record";
	$cfg{'DIR_IMG'}        = "$cfg{'BASEDIR_DOC'}/img";
	$cfg{'FILE_LOCK'}      = "$cfg{'BASEDIR_DAT'}/lock";
	$cfg{'FILE_JCODE'}     = "$cfg{'DIR_LIB'}/jcode.pm";
	$cfg{'FILE_SOWGROBAL'} = "$cfg{'BASEDIR_DAT'}/sowgrobal.cgi";
	$cfg{'FILE_VINDEX'}    = "$cfg{'BASEDIR_DAT'}/vindex.cgi";
	$cfg{'FILE_ATVINDEX'}  = "$cfg{'BASEDIR_DAT'}/autovindex.cgi";
	$cfg{'FILE_APLOG'}     = "$cfg{'DIR_LOG'}/aplog.cgi";
	$cfg{'FILE_ERRLOG'}    = "$cfg{'DIR_LOG'}/errlog.cgi";

	if (-r $cfglocalfile) {
		require $cfglocalfile;
		&SWLocalConfig::GetLocalConfig(\%cfg);
	}

	return \%cfg;
}

1;
