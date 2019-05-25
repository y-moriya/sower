package SWConst;

#----------------------------------------
# SWBBS�̒萔
#----------------------------------------
sub InitConst {
	# �������X�g�iNaN/Inf�`�F�b�N�p�j
	# ���l�f�[�^��0�A�������1�A���s�������������2
	my %queryinvalid = (
		ua      => 1, # ���[�U�G�[�W�F���g
		css     => 1, # CSS�w��i�I�v�V�����j
		uid     => 1, # ���[�UID
		u       => 1, # ���[�UID�i�Z�k�`�j
		pwd     => 1, # �p�X���[�h
		p       => 1, # �p�X���[�h�i�Z�k�`�j
		cmd     => 1, # �������e
		c       => 1, # �������e�i�Z�k�`�j
		move    => 1, # �y�[�W�ړ�����
#		mv      => 1, # �y�[�W�ړ������i�Z�k�`�j
		pageno  => 0, # �y�[�W�ԍ�
		cmdfrom => 1, # �Ăяo�����������e
		br      => 1, # ���s�����̃e�X�g�p����

		vid      => 0, # ���ԍ�
		v        => 0, # ���ԍ��i�Z�k�`�j
		turn     => 0, # ������
		t        => 0, # �����ځi�Z�k�`�j
		mode     => 1, # �I����̎��_�؂�ւ�
		m        => 1, # �I����̎��_�؂�ւ��i�Z�k�`�j
		order    => 1, # �����O�̕\�����i�����^�~���j
		o        => 1, # �����O�̕\�����Z�k�`�i�����^�~���j
		mbsayimg => 1, # �g�тł̊�O���\��
		i        => 1, # �g�тł̊�O���\���i�Z�k�`�j
		row      => 0, # �����O�̕\���s��
		r        => 0, # �����O�̕\���s���i�Z�k�`�j
		rowall   => 1, # �S�\���X�C�b�`
		logid    => 1, # �����O�\�����̊���OID
		l        => 1, # �����O�\�����̊���OID�i�Z�k�`�j
		pno      => 0, # �v���C���[�ԍ��i�i�荞�ݗp�j

		vname        => 1, # ���̖��O
		vcomment     => 2, # ���̐���
		hour         => 0, # �X�V���ԁi���j
		minite       => 0, # �X�V���ԁi���j
		vplcnt       => 0, # ���
		vplcntstart  => 0, # �Œ�l���i�J�n�ɕK�v�Ȑl���j
		updinterval  => 0, # �X�V�Ԋu
		csid         => 1, # �L�����N�^�Z�b�g
		saycnttype   => 1, # �����������
		entrylimit   => 1, # �Q������
		entrypwd     => 1, # �Q���p�X���[�h
		writepwd	 => 1, # �T�ώҔ����p�X���[�h
		rating       => 1, # �{������
		roletable    => 1, # ��E�z��
		votetype     => 1, # ���[���@
		starttype    => 1, # �J�n���@
		trsid        => 1, # �����񃊃\�[�X�Z�b�g
		randomtarget => 1, # �����_���Ώ�
		makersaymenu => 1, # �����Ĕ����s��
		entrustmode  => 1, # �ϔC�@�\�Ȃ�
		showall      => 1, # �扺���J
		noactmode    => 1, # �A�N�V����/���� 0:ok/ok 1:ng/ok 2:ok/ng 3:ng/ng
		nocandy      => 1, # �����Ȃ�
		nofreeact    => 1, # ���R���A�N�V�����Ȃ�
		showid       => 1, # ID���J
		timestamp    => 1, # �����ȈՕ\��
		noselrole    => 1, # ��E��]����
		guestmenu    => 1, # �T�ώҔ����s��
		makeruid     => 1, # �����lID

		cntvillager  => 0, # ���l
		cntwolf      => 0, # �l�T
		cntseer      => 0, # �肢�t
		cntmedium    => 0, # ��\��
		cntpossess   => 0, # ���l
		cntguard     => 0, # ��l
		cntfm        => 0, # ���L��
		cnthamster   => 0, # �n���X�^�[�l��
		cntcpossess  => 0, # �b�����l
		cntstigma    => 0, # ������
		cntfanatic   => 0, # ���M��
		cntsympathy  => 0, # ����
		cntwerebat   => 0, # �R�E�����l��
		cntcwolf     => 0, # ���T
		cntintwolf   => 0, # �q�T
		cnttrickster => 0, # �s�N�V�[

		cid        => 1, # �L�����N�^ID
		csid_cid   => 1, # �L�����N�^�Z�b�g/�L�����N�^ID
		role       => 0, # ��E��]
		queid      => 1, # �L���[ID�i�����폜�p�j
		mes        => 2, # �������e
		think      => 1, # �Ƃ茾�X�C�b�`
		wolf       => 1, # �����X�C�b�`
		maker      => 1, # �����Đl�����X�C�b�`
		admin      => 1, # �Ǘ��l�����X�C�b�`
		guest      => 1, # �T�ώҔ����X�C�b�`
		sympathy   => 1, # ���X�C�b�`
		werebat    => 1, # �O�b�X�C�b�`
		monospace  => 1, # �����X�C�b�`
		loud       => 1, # �吺�X�C�b�`
		safety     => 1, # �딚�h�~�`�F�b�N
		entrust    => 1, # �ϔC�X�C�b�`
		expression => 0, # �\��ID
		commit     => 0, # �R�~�b�g
		jobname    => 1, # ������
		submit_type=> 1, # ����{�^����ʔ���

		target     => 0, # ���[�^�\�͑ΏێҔԍ�
		target2    => 0, # �\�͑ΏێҔԍ��Q
		selectact  => 1, # �A�N�V�������
		actiontext => 1, # �A�N�V��������
		actionno   => 0, # �A�N�V�����ԍ�

		prof       => 1, # �v���t�B�[����\�����郆�[�U�[��ID
		handlename => 1, # ���[�U�[�̃n���h����
		url        => 1, # ���[�U�[��URL
		intro      => 2, # ���[�U�[�̎��ȏЉ�
		parmalink  => 0, # ���[�U�[�̃p�[�}�����N�I���I�t�t���O

		vidstart   => 0, # ���ԍ��͈͎w��i�J�n�j
		vidend     => 0, # ���ԍ��͈͎w��i�I���j
		vidmove    => 1, # ���f�[�^�̈ړ���

		# TypeKey
		email => 1,
		name  => 1,
		nick  => 1,
		ts    => 1,
		sig   => 1,
	);

	# �����Z�k�`
	my %query_short2full = (
		c => 'cmd',
		l => 'logid',
		m => 'mode',
		o => 'order',
		p => 'pwd',
		r => 'row',
		t => 'turn',
		u => 'uid',
		v => 'vid',
		i => 'mbsayimg',
	);

	# ���OID�������
	my @logmestype = (
		'X', # MESTYPE_UNDEF
		'I', # MESTYPE_INFONOM
		'i', # MESTYPE_INFOSP
		'D', # MESTYPE_DELETED
		'd', # MESTYPE_DELETEDADMIN
		'Q', # MESTYPE_QUE
		'S', # MESTYPE_SAY
		'T', # MESTYPE_TSAY
		'W', # MESTYPE_WSAY
		'G', # MESTYPE_GSAY
		'M', # MESTYPE_MAKER
		'A', # MESTYPE_ADMIN
		'P', # MESTYPE_SPSAY
		'B', # MESTYPE_BSAY
		'U', # MESTYPE_GUEST
		'C', # MESTYPE_CAST
	);

	# ���O�ԍ��Ǘ��p
	my @logcountmestype = (
		'countundef',    # MESTYPE_UNDEF
		'countinfo',     # MESTYPE_INFONOM
		'countinfosp',   # MESTYPE_INFOSP
		'countundef',    # MESTYPE_DELETED
		'countundef',    # MESTYPE_DELETEDADMIN
		'countque',      # MESTYPE_QUE
		'countsay',      # MESTYPE_SAY
		'countthink',    # MESTYPE_TSAY
		'countwolf',     # MESTYPE_WSAY
		'countgrave',    # MESTYPE_GSAY
		'countmaker',    # MESTYPE_MAKER
		'countadmin',    # MESTYPE_ADMIN
		'countsympathy', # MESTYPE_SPSAY
		'countwerebat',  # MESTYPE_BSAY
		'countguest',    # MESTYPE_GUEST
		'countundef',    # MESTYPE_CAST
	);

	# �X�V���Ǘ��p
	my @modifiedmestype = (
		'',              # MESTYPE_UNDEF
		'modifiedsay',   # MESTYPE_INFONOM
		'',              # MESTYPE_INFOSP
		'',              # MESTYPE_DELETED
		'',              # MESTYPE_DELETEDADMIN
		'',              # MESTYPE_QUE
		'modifiedsay',   # MESTYPE_SAY
		'',              # MESTYPE_TSAY
		'modifiedwsay',  # MESTYPE_WSAY
		'modifiedgsay',  # MESTYPE_GSAY
		'modifiedsay',   # MESTYPE_MAKER
		'modifiedsay',   # MESTYPE_ADMIN
		'modifiedspsay', # MESTYPE_SPSAY
		'modifiedbsay',  # MESTYPE_BSAY
		'modifiedsay',   # MESTYPE_GUEST
		'modifiedsay',   # MESTYPE_CAST
	);

	# ������ʃt�B���^�ϊ��p�z��
	my @mestype2typeid = (
		-1, # MESTYPE_UNDEF
		-1, # MESTYPE_INFONOM
		-1, # MESTYPE_INFOSP
		-1, # MESTYPE_DELETED
		-1, # MESTYPE_DELETEDADMIN
		 0, # MESTYPE_QUE
		 0, # MESTYPE_SAY
		 1, # MESTYPE_TSAY
		 2, # MESTYPE_WSAY
		 3, # MESTYPE_GSAY
		 4, # MESTYPE_MAKER
		 4, # MESTYPE_ADMIN
		 2, # MESTYPE_SPSAY
		 2, # MESTYPE_BSAY
	);

	# �����X�C�b�`
	my @sayswitch = (
		'',         # ����`
		'',         # ���l
		'wolf',     # �l�T
		'',         # �肢�t
		'',         # ��\��
		'',         # ���l
		'',         # ��l
		'',         # ���L��
		'',         # �n���X�^�[�l��
		'wolf',     # �b�����l
		'',         # ������
		'',         # ���M��
		'sympathy', # ����
		'werebat',  # �R�E�����l��
		'wolf',     # ���T
		'wolf',     # �q�T
		'',         # �s�N�V�[
	);

	# ������ID
	my @saycountid = (
		'',      # ����`
		'',      # ���l
		'wsay',  # �l�T
		'',      # �肢�t
		'',      # ��\��
		'',      # ���l
		'',      # ��l
		'',      # ���L��
		'',      # �n���X�^�[�l��
		'wsay',  # �b�����l
		'',      # ������
		'',      # ���M��
		'spsay', # ����
		'bsay',  # �R�E�����l��
		'wsay',  # ���T
		'wsay',  # �q�T
		'',      # �s�N�V�[
	);

	my %logcountsubid = (
		X => '',    # LOGSUBID_UNDEF
		S => '',    # LOGSUBID_SAY
		A => 'act', # LOGSUBID_ACTION
		B => 'act', # LOGSUBID_BOOKMARK
	);

	# �A���J�[�w��p�̋L��
	# �����󂢂Ăˁ[YO!!
	my %loganchormark = (
		S => '',  # MESTYPE_SAY
		T => '-', # MESTYPE_TSAY
		W => '*', # MESTYPE_WSAY
		G => '+', # MESTYPE_GSAY
		M => '#', # MESTYPE_MAKER
		A => '%', # MESTYPE_ADMIN
		P => '=', # MESTYPE_SPSAY
		B => '!', # MESTYPE_BSAY
		U => 'g', # MESTYPE_GUEST
	);

	# ��E�z���\���X�g
	my @order_roletable = (
		'default', # �W��
		'hamster', # �n������
		'wbbs_c',  # �b��
		'test1st', # ������^
		'test2nd', # ������^
		'wbbs_g',  # G��
		'custom',  # ���R�ݒ�
	);

	# ��EID���X�g
	my @roleid = (
		'undef',     # ����`
		'villager',  # ���l
		'wolf',      # �l�T
		'seer',      # �肢�t
		'medium',    # ��\��

		'possess',   # ���l
		'guard',     # ��l
		'fm',        # ���L��
		'hamster',   # �n���X�^�[�l��
		'cpossess',  # �b�����l

		'stigma',    # ������
		'fanatic',   # ���M��
		'sympathy',  # ����
		'werebat',   # �R�E�����l��
		'cwolf',     # ���T
		'intwolf',   # �q�T
		'trickster', # �s�N�V�[
	);

	# ��E�ʐw�c
	my @rolecamp = (
		0, # ����`
		1, # ���l
		2, # �l�T
		1, # �肢�t
		1, # ��\��

		2, # ���l
		1, # ��l
		1, # ���L��
		3, # �n���X�^�[�l��
		2, # �b�����l

		1, # ������
		2, # ���M��
		1, # ����
		3, # �R�E�����l��
		2, # ���T
		2, # �q�T
		3, # �s�N�V�[
	);

	my %sow = (
		NAME_AUTHOR => '��[��/@euro_s',
		MAIL_AUTHOR => 'wolf@euros.sakura.ne.jp',
		COPY_AUTHOR => '��[��',
		URL_AUTHOR  => 'https://github.com/y-moriya/sower/',
		SITE_AUTHOR => 'github/sower',
		VERSION_SW  => 'sower ver. 1.1.4',

		QUERY_INVALID    => \%queryinvalid,
		QUERY_SHORT2FULL => \%query_short2full,

		# MESTYPE�i���O��ʁj
		MESTYPE_UNDEF        =>  0,
		MESTYPE_INFONOM      =>  1,
		MESTYPE_INFOSP       =>  2,
		MESTYPE_DELETED      =>  3,
		MESTYPE_DELETEDADMIN =>  4,

		MESTYPE_QUE          =>  5,
		MESTYPE_SAY          =>  6,
		MESTYPE_TSAY         =>  7,
		MESTYPE_WSAY         =>  8,
		MESTYPE_GSAY         =>  9,
		MESTYPE_MAKER        => 10,
		MESTYPE_ADMIN        => 11,
		MESTYPE_SPSAY        => 12,
		MESTYPE_BSAY         => 13,
		MESTYPE_GUEST        => 14,
		MESTYPE_CAST         => 15,

		LOGSUBID_UNDEF    => 'X',
		LOGSUBID_SAY      => 'S',
		LOGSUBID_ACTION   => 'A',
		LOGSUBID_BOOKMARK => 'B',

		MEMOTYPE_UNDEF   => 0,
		MEMOTYPE_DELETED => 1,
		MEMOTYPE_MEMO    => 2,

		LOGCOUNT_UNDEF    => 99999,
		PREVIEW_LOGID	  => 'SS99999',
		MAXWIDTH_TURN     => 3,     # ���t�̌���
		MAXWIDTH_LOGCOUNT => 5,     # ���O�ԍ��̌���
		LOGMESTYPE        => \@logmestype,
		MESTYPE2TYPEID    => \@mestype2typeid,
		MARK_LOGANCHOR    => \%loganchormark,
		MODIFIED_MESTYPE  => \@modifiedmestype,

		LOGCOUNT_MESTYPE => \@logcountmestype,
		LOGCOUNT_SUBID   => \%logcountsubid,
		SAYSWITCH        => \@sayswitch,
		SAYCOUNTID       => \@saycountid,

		# ��E�ԍ�
		ROLEID_UNDEF     =>  0, # ����`�^���܂���
		ROLEID_VILLAGER  =>  1, # ���l
		ROLEID_WOLF      =>  2, # �l�T
		ROLEID_SEER      =>  3, # �肢�t
		ROLEID_MEDIUM    =>  4, # ��\��
		ROLEID_POSSESS   =>  5, # ���l
		ROLEID_GUARD     =>  6, # ��l
		ROLEID_FM        =>  7, # ���L��
		ROLEID_HAMSTER   =>  8, # �n���X�^�[�l��
		ROLEID_CPOSSESS  =>  9, # �b�����l
		ROLEID_STIGMA    => 10, # ������
		ROLEID_FANATIC   => 11, # ���M��
		ROLEID_SYMPATHY  => 12, # ����
		ROLEID_WEREBAT   => 13, # �R�E�����l��
		ROLEID_CWOLF     => 14, # ���T
		ROLEID_INTWOLF   => 15, # �q�T
		ROLEID_TRICKSTER => 16, # �s�N�V�[
		ROLEID           => \@roleid,
		ROLECAMP         => \@rolecamp,
		COUNT_CAMP       => 3, # �w�c��
		COUNT_ROLE       => scalar(@roleid),
#		MAXCOUNT_STIGMA  => 5, # �����҂̍ő吔
		ORDER_ROLETABLE  => \@order_roletable,

		VSTATUSID_PRO      => 0, # �Q���ҕ�W���^�J�n�O
		VSTATUSID_PLAY     => 1, # �i�s��
		VSTATUSID_EP       => 2, # ���s�������܂���
		VSTATUSID_END      => 3, # �I��
		VSTATUSID_SCRAP    => 4, # �p���i�G�s���j
		VSTATUSID_SCRAPEND => 5, # �p���I��

		PTYPE_NONE      => 0, # �y�i���e�B�Ȃ�
		PTYPE_PROBATION => 1, # �ی�ώ@����
		PTYPE_NOENTRY   => 2, # �Q����~
		PTYPE_STOPID    => 3, # ID��~

		TARGETID_TRUST  => -1, # ���܂���
		TARGETID_RANDOM => -2, # �����_��

		DATATEXT_NONE => '_none_',
		CHRNAME_INFO  => '[���]',
#		MIKUJI        => \@mikuji,

		# �A�v���P�[�V�������O�o�͗p
		APLOG_WARNING => 'W',
		APLOG_CAUTION => 'C',
		APLOG_NOTICE  => 'n',
		APLOG_POSTED  => 'p',
		APLOG_OTHERS  => 'o',

		time => time(),
		lock => '',
	);

	return \%sow;
}

1;
