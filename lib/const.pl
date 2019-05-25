package SWConst;

#----------------------------------------
# SWBBSの定数
#----------------------------------------
sub InitConst {
	# 引数リスト（NaN/Infチェック用）
	# 数値データは0、文字列は1、改行を許す文字列は2
	my %queryinvalid = (
		ua      => 1, # ユーザエージェント
		css     => 1, # CSS指定（オプション）
		uid     => 1, # ユーザID
		u       => 1, # ユーザID（短縮形）
		pwd     => 1, # パスワード
		p       => 1, # パスワード（短縮形）
		cmd     => 1, # 処理内容
		c       => 1, # 処理内容（短縮形）
		move    => 1, # ページ移動方向
#		mv      => 1, # ページ移動方向（短縮形）
		pageno  => 0, # ページ番号
		cmdfrom => 1, # 呼び出し元処理内容
		br      => 1, # 改行文字のテスト用引数

		vid      => 0, # 村番号
		v        => 0, # 村番号（短縮形）
		turn     => 0, # ｎ日目
		t        => 0, # ｎ日目（短縮形）
		mode     => 1, # 終了後の視点切り替え
		m        => 1, # 終了後の視点切り替え（短縮形）
		order    => 1, # 村ログの表示順（昇順／降順）
		o        => 1, # 村ログの表示順短縮形（昇順／降順）
		mbsayimg => 1, # 携帯での顔グラ表示
		i        => 1, # 携帯での顔グラ表示（短縮形）
		row      => 0, # 村ログの表示行数
		r        => 0, # 村ログの表示行数（短縮形）
		rowall   => 1, # 全表示スイッチ
		logid    => 1, # 村ログ表示時の基準ログID
		l        => 1, # 村ログ表示時の基準ログID（短縮形）
		pno      => 0, # プレイヤー番号（絞り込み用）

		vname        => 1, # 村の名前
		vcomment     => 2, # 村の説明
		hour         => 0, # 更新時間（時）
		minite       => 0, # 更新時間（分）
		vplcnt       => 0, # 定員
		vplcntstart  => 0, # 最低人数（開始に必要な人数）
		updinterval  => 0, # 更新間隔
		csid         => 1, # キャラクタセット
		saycnttype   => 1, # 発言制限種別
		entrylimit   => 1, # 参加制限
		entrypwd     => 1, # 参加パスワード
		writepwd	 => 1, # 傍観者発言パスワード
		rating       => 1, # 閲覧制限
		roletable    => 1, # 役職配分
		votetype     => 1, # 投票方法
		starttype    => 1, # 開始方法
		trsid        => 1, # 文字列リソースセット
		randomtarget => 1, # ランダム対象
		makersaymenu => 1, # 村建て発言不可
		entrustmode  => 1, # 委任機能なし
		showall      => 1, # 墓下公開
		noactmode    => 1, # アクション/メモ 0:ok/ok 1:ng/ok 2:ok/ng 3:ng/ng
		nocandy      => 1, # 促しなし
		nofreeact    => 1, # 自由文アクションなし
		showid       => 1, # ID公開
		timestamp    => 1, # 時刻簡易表示
		noselrole    => 1, # 役職希望無視
		guestmenu    => 1, # 傍観者発言不可
		makeruid     => 1, # 村建人ID

		cntvillager  => 0, # 村人
		cntwolf      => 0, # 人狼
		cntseer      => 0, # 占い師
		cntmedium    => 0, # 霊能者
		cntpossess   => 0, # 狂人
		cntguard     => 0, # 狩人
		cntfm        => 0, # 共有者
		cnthamster   => 0, # ハムスター人間
		cntcpossess  => 0, # Ｃ国狂人
		cntstigma    => 0, # 聖痕者
		cntfanatic   => 0, # 狂信者
		cntsympathy  => 0, # 共鳴者
		cntwerebat   => 0, # コウモリ人間
		cntcwolf     => 0, # 呪狼
		cntintwolf   => 0, # 智狼
		cnttrickster => 0, # ピクシー

		cid        => 1, # キャラクタID
		csid_cid   => 1, # キャラクタセット/キャラクタID
		role       => 0, # 役職希望
		queid      => 1, # キューID（発言削除用）
		mes        => 2, # 発言内容
		think      => 1, # 独り言スイッチ
		wolf       => 1, # 囁きスイッチ
		maker      => 1, # 村建て人発言スイッチ
		admin      => 1, # 管理人発言スイッチ
		guest      => 1, # 傍観者発言スイッチ
		sympathy   => 1, # 共鳴スイッチ
		werebat    => 1, # 念話スイッチ
		monospace  => 1, # 等幅スイッチ
		loud       => 1, # 大声スイッチ
		safety     => 1, # 誤爆防止チェック
		entrust    => 1, # 委任スイッチ
		expression => 0, # 表情ID
		commit     => 0, # コミット
		jobname    => 1, # 肩書き
		submit_type=> 1, # 決定ボタン種別判別

		target     => 0, # 投票／能力対象者番号
		target2    => 0, # 能力対象者番号２
		selectact  => 1, # アクション種別
		actiontext => 1, # アクション文章
		actionno   => 0, # アクション番号

		prof       => 1, # プロフィールを表示するユーザーのID
		handlename => 1, # ユーザーのハンドル名
		url        => 1, # ユーザーのURL
		intro      => 2, # ユーザーの自己紹介
		parmalink  => 0, # ユーザーのパーマリンクオンオフフラグ

		vidstart   => 0, # 村番号範囲指定（開始）
		vidend     => 0, # 村番号範囲指定（終了）
		vidmove    => 1, # 村データの移動先

		# TypeKey
		email => 1,
		name  => 1,
		nick  => 1,
		ts    => 1,
		sig   => 1,
	);

	# 引数短縮形
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

	# ログID発言種別
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

	# ログ番号管理用
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

	# 更新情報管理用
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

	# 発言種別フィルタ変換用配列
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

	# 発言スイッチ
	my @sayswitch = (
		'',         # 未定義
		'',         # 村人
		'wolf',     # 人狼
		'',         # 占い師
		'',         # 霊能者
		'',         # 狂人
		'',         # 狩人
		'',         # 共有者
		'',         # ハムスター人間
		'wolf',     # Ｃ国狂人
		'',         # 聖痕者
		'',         # 狂信者
		'sympathy', # 共鳴者
		'werebat',  # コウモリ人間
		'wolf',     # 呪狼
		'wolf',     # 智狼
		'',         # ピクシー
	);

	# 発言数ID
	my @saycountid = (
		'',      # 未定義
		'',      # 村人
		'wsay',  # 人狼
		'',      # 占い師
		'',      # 霊能者
		'',      # 狂人
		'',      # 狩人
		'',      # 共有者
		'',      # ハムスター人間
		'wsay',  # Ｃ国狂人
		'',      # 聖痕者
		'',      # 狂信者
		'spsay', # 共鳴者
		'bsay',  # コウモリ人間
		'wsay',  # 呪狼
		'wsay',  # 智狼
		'',      # ピクシー
	);

	my %logcountsubid = (
		X => '',    # LOGSUBID_UNDEF
		S => '',    # LOGSUBID_SAY
		A => 'act', # LOGSUBID_ACTION
		B => 'act', # LOGSUBID_BOOKMARK
	);

	# アンカー指定用の記号
	# もう空いてねーYO!!
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

	# 役職配分表リスト
	my @order_roletable = (
		'default', # 標準
		'hamster', # ハム入り
		'wbbs_c',  # Ｃ国
		'test1st', # 試験壱型
		'test2nd', # 試験弐型
		'wbbs_g',  # G国
		'custom',  # 自由設定
	);

	# 役職IDリスト
	my @roleid = (
		'undef',     # 未定義
		'villager',  # 村人
		'wolf',      # 人狼
		'seer',      # 占い師
		'medium',    # 霊能者

		'possess',   # 狂人
		'guard',     # 狩人
		'fm',        # 共有者
		'hamster',   # ハムスター人間
		'cpossess',  # Ｃ国狂人

		'stigma',    # 聖痕者
		'fanatic',   # 狂信者
		'sympathy',  # 共鳴者
		'werebat',   # コウモリ人間
		'cwolf',     # 呪狼
		'intwolf',   # 智狼
		'trickster', # ピクシー
	);

	# 役職別陣営
	my @rolecamp = (
		0, # 未定義
		1, # 村人
		2, # 人狼
		1, # 占い師
		1, # 霊能者

		2, # 狂人
		1, # 狩人
		1, # 共有者
		3, # ハムスター人間
		2, # Ｃ国狂人

		1, # 聖痕者
		2, # 狂信者
		1, # 共鳴者
		3, # コウモリ人間
		2, # 呪狼
		2, # 智狼
		3, # ピクシー
	);

	my %sow = (
		NAME_AUTHOR => 'ゆーろ/@euro_s',
		MAIL_AUTHOR => 'wolf@euros.sakura.ne.jp',
		COPY_AUTHOR => 'ゆーろ',
		URL_AUTHOR  => 'https://github.com/y-moriya/sower/',
		SITE_AUTHOR => 'github/sower',
		VERSION_SW  => 'sower ver. 1.1.4',

		QUERY_INVALID    => \%queryinvalid,
		QUERY_SHORT2FULL => \%query_short2full,

		# MESTYPE（ログ種別）
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
		MAXWIDTH_TURN     => 3,     # 日付の桁数
		MAXWIDTH_LOGCOUNT => 5,     # ログ番号の桁数
		LOGMESTYPE        => \@logmestype,
		MESTYPE2TYPEID    => \@mestype2typeid,
		MARK_LOGANCHOR    => \%loganchormark,
		MODIFIED_MESTYPE  => \@modifiedmestype,

		LOGCOUNT_MESTYPE => \@logcountmestype,
		LOGCOUNT_SUBID   => \%logcountsubid,
		SAYSWITCH        => \@sayswitch,
		SAYCOUNTID       => \@saycountid,

		# 役職番号
		ROLEID_UNDEF     =>  0, # 未定義／おまかせ
		ROLEID_VILLAGER  =>  1, # 村人
		ROLEID_WOLF      =>  2, # 人狼
		ROLEID_SEER      =>  3, # 占い師
		ROLEID_MEDIUM    =>  4, # 霊能者
		ROLEID_POSSESS   =>  5, # 狂人
		ROLEID_GUARD     =>  6, # 狩人
		ROLEID_FM        =>  7, # 共有者
		ROLEID_HAMSTER   =>  8, # ハムスター人間
		ROLEID_CPOSSESS  =>  9, # Ｃ国狂人
		ROLEID_STIGMA    => 10, # 聖痕者
		ROLEID_FANATIC   => 11, # 狂信者
		ROLEID_SYMPATHY  => 12, # 共鳴者
		ROLEID_WEREBAT   => 13, # コウモリ人間
		ROLEID_CWOLF     => 14, # 呪狼
		ROLEID_INTWOLF   => 15, # 智狼
		ROLEID_TRICKSTER => 16, # ピクシー
		ROLEID           => \@roleid,
		ROLECAMP         => \@rolecamp,
		COUNT_CAMP       => 3, # 陣営数
		COUNT_ROLE       => scalar(@roleid),
#		MAXCOUNT_STIGMA  => 5, # 聖痕者の最大数
		ORDER_ROLETABLE  => \@order_roletable,

		VSTATUSID_PRO      => 0, # 参加者募集中／開始前
		VSTATUSID_PLAY     => 1, # 進行中
		VSTATUSID_EP       => 2, # 勝敗が決しました
		VSTATUSID_END      => 3, # 終了
		VSTATUSID_SCRAP    => 4, # 廃村（エピ中）
		VSTATUSID_SCRAPEND => 5, # 廃村終了

		PTYPE_NONE      => 0, # ペナルティなし
		PTYPE_PROBATION => 1, # 保護観察期間
		PTYPE_NOENTRY   => 2, # 参加停止
		PTYPE_STOPID    => 3, # ID停止

		TARGETID_TRUST  => -1, # おまかせ
		TARGETID_RANDOM => -2, # ランダム

		DATATEXT_NONE => '_none_',
		CHRNAME_INFO  => '[情報]',
#		MIKUJI        => \@mikuji,

		# アプリケーションログ出力用
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
