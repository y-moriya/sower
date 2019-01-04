package SWConfig;

#----------------------------------------
# 設定ファイル
#----------------------------------------
sub GetConfig {
	# PCモードの表示件数一覧
	my @row_pc = (10, 20, 30, 50, 100, 200);

	# 携帯モードの表示件数一覧
	my @row_mb = (5, 10, 20, 30, 50, 100);

	# キャラクターセットID
	my @csidlist = (
    	'rem',
		'sow',
		'troika',
		'ao',
		'wbbs',
	);

	# 文字列リソースセットID
	my @trsidlist = (
		'sow',
		'wbbs',
		'juna',
		'fool',
		'ao'
	);

	# act/memo 設定用
	my @noactlist = (
		'アクション可、メモ可',		# 0
		'アクション不可、メモ可',	# 1
		'アクション可、メモ不可',	# 2
		'アクション不可、メモ不可',	# 3
	);

	my %infocap = (
		vname          => '村の名前',
		vcomment       => '村の説明',
		csid           => '登場人物',
		trsid          => '文章系',
		roletable      => '役職配分',
		updhour        => '更新時間',
		updminite      => '更新時間',
		updinterval    => '更新間隔',
		entrylimit     => '参加制限',
		entrypwd       => '参加パスワード',
		rating         => '閲覧制限',
		vplcnt         => '定員',
		vplcntstart    => '最低開始人数',
		saycnttype     => '発言制限',
		randomtarget   => 'ランダム',
		noselrole      => '役職希望',
		makersaymenu   => '進行中の村建て人発言欄',
		entrustmode    => '委任',
		showall        => '墓下公開',
		noactmode      => 'act/memo',
		nocandy        => '促し',
		nofreeact      => '自由文アクション',
		commitstate    => 'コミット状況',
		showid         => 'ID公開',
		idrecord       => 'ID記録',
		timestamp      => '時刻表示',
		votetype       => '投票方法',
		starttype      => '開始方法',

	);
	# 発言制限
	my %saycnt_real = (
		CAPTION     => 'リア充(500pt)',
		COUNT_TYPE  => 'point', # ポイント勘定
		MAX_SAY     =>  500, # 通常発言回数
		MAX_TSAY    => 10000, # 独り言発言回数
		MAX_WSAY    => 15000, # 囁き発言回数
		MAX_SPSAY   =>  8000, # 共鳴発言回数
		MAX_BSAY    => 15000, # 念話発言回数
		MAX_GSAY    => 15000, # うめき発言回数
		MAX_PSAY    => 10000, # プロローグ発言回数
		MAX_ESAY    => 3000, # エピローグ発言回数
		MAX_SAY_ACT =>   24, # アクション回数
		ADD_SAY     =>  200, # 促しで増える発言回数
		MAX_ADDSAY  =>    1, # 促しの回数
		MAX_MESCNT  =>  1000, # 一発言の最大バイト数
		MAX_MESLINE =>   25, # 一発言の最大行数
	);

	# 発言制限
	my %saycnt_sow = (
		CAPTION     => 'もっとリア充(300pt)',
		COUNT_TYPE  => 'point', # ポイント勘定
		MAX_SAY     =>  300, # 通常発言回数
		MAX_TSAY    => 10000, # 独り言発言回数
		MAX_WSAY    => 15000, # 囁き発言回数
		MAX_SPSAY   =>  8000, # 共鳴発言回数
		MAX_BSAY    => 15000, # 念話発言回数
		MAX_GSAY    => 20000, # うめき発言回数
		MAX_PSAY    => 10000, # プロローグ発言回数
		MAX_ESAY    => 3000, # エピローグ発言回数
		MAX_SAY_ACT =>   24, # アクション回数
		ADD_SAY     =>  200, # 促しで増える発言回数
		MAX_ADDSAY  =>    1, # 促しの回数
		MAX_MESCNT  =>  1000, # 一発言の最大バイト数
		MAX_MESLINE =>   25, # 一発言の最大行数
	);

	my %saycnt_wbbs = (
		CAPTION     => 'BBS(20回)',
		COUNT_TYPE  => 'count', # 回数勘定
		MAX_SAY     =>  20, # 通常発言回数
		MAX_TSAY    =>  10, # 独り言発言回数
		MAX_WSAY    =>  40, # 囁き発言回数
		MAX_SPSAY   =>  20, # 共鳴発言回数
		MAX_BSAY    =>  30, # 念話発言回数
		MAX_GSAY    =>  20, # うめき発言回数
		MAX_PSAY    =>  20, # プロローグ発言回数
		MAX_ESAY    => 600, # エピローグ発言回数
		MAX_SAY_ACT =>  15, # アクション回数
		ADD_SAY     =>   4, # 促しで増える発言回数
		MAX_ADDSAY  =>   1, # 促しの回数
		MAX_MESCNT  => 200, # 一発言の最大文字数
		MAX_MESLINE =>   5, # 一発言の最大行数
	);

	my %saycnt_juna = (
		CAPTION     => '審問(1000pt)',
		COUNT_TYPE  => 'point', # バイト勘定
		MAX_SAY     => 1000, # 通常発言pt数
		MAX_TSAY    =>  700, # 独り言発言pt数
		MAX_WSAY    => 3000, # 囁き発言pt数
		MAX_SPSAY   => 1000, # 共鳴発言回数
		MAX_BSAY    => 2000, # 念話発言回数
		MAX_GSAY    => 2000, # うめき発言pt数
		MAX_PSAY    => 2000, # プロローグ発言pt数
		MAX_ESAY    => 3000, # エピローグ発言pt数
		ADD_SAY     =>  200, # 促しで増える発言pt数
		MAX_ADDSAY  =>    1, # 促しの回数
		MAX_SAY_ACT =>   24, # アクション回数
		MAX_MESCNT  => 1000, # 一発言の最大文字バイト数
		MAX_MESLINE =>   20, # 一発言の最大行数
	);

	my %saycnt_vulcan = (
		CAPTION     => '多弁(1500pt)',
		COUNT_TYPE  => 'point', # ポイント勘定
		MAX_SAY     => 1500, # 通常発言pt数
		MAX_TSAY    => 10000, # 独り言発言pt数
		MAX_WSAY    => 40000, # 囁き発言pt数
		MAX_SPSAY   => 15000, # 共鳴発言回数
		MAX_BSAY    => 30000, # 念話発言回数
		MAX_GSAY    => 30000, # うめき発言pt数
		MAX_PSAY    => 30000, # プロローグ発言pt数
		MAX_ESAY    => 4500, # エピローグ発言pt数
		ADD_SAY     =>  200, # 促しで増える発言pt数
		MAX_ADDSAY  =>    1, # 促しの回数
		MAX_SAY_ACT =>   36, # アクション回数
		MAX_MESCNT  => 1000, # 一発言の最大文字バイト数
		MAX_MESLINE =>   30, # 一発言の最大行数
	);

	my %saycnt_saving = (
		CAPTION     => '節約(15回)',
		COUNT_TYPE  => 'count', # 回数勘定
		MAX_SAY     =>  15, # 通常発言回数
		MAX_TSAY    =>  10, # 独り言発言回数
		MAX_WSAY    =>  30, # 囁き発言回数
		MAX_SPSAY   =>  12, # 共鳴発言回数
		MAX_BSAY    =>  20, # 念話発言回数
		MAX_GSAY    =>  20, # うめき発言回数
		MAX_PSAY    =>  20, # プロローグ発言回数
		MAX_ESAY    => 600, # エピローグ発言回数
		MAX_SAY_ACT =>  10, # アクション回数
		ADD_SAY     =>   3, # 促しで増える発言回数
		MAX_ADDSAY  =>   1, # 促しの回数
		MAX_MESCNT  => 200, # 一発言の最大文字数
		MAX_MESLINE =>   5, # 一発言の最大行数
	);

	my %saycnt_gachi = (
		CAPTION     => 'ガチ(1800pt)',
		COUNT_TYPE  => 'point', # ポイント勘定
		MAX_SAY     => 1800, # 通常発言pt数
		MAX_TSAY    => 2000, # 独り言発言pt数
		MAX_WSAY    => 4000, # 囁き発言pt数
		MAX_SPSAY   => 1500, # 共鳴発言回数
		MAX_BSAY    => 3000, # 念話発言回数
		MAX_GSAY    => 3000, # うめき発言pt数
		MAX_PSAY    => 3000, # プロローグ発言pt数
		MAX_ESAY    => 4500, # エピローグ発言pt数
		ADD_SAY     =>  300, # 促しで増える発言pt数
		MAX_ADDSAY  =>    2, # 促しの回数
		MAX_SAY_ACT =>   36, # アクション回数
		MAX_MESCNT  => 2000, # 一発言の最大文字バイト数
		MAX_MESLINE =>   40, # 一発言の最大行数
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
		vcomment    => 'この村は自動的に建てられた村です。<br>トップページに書かれているルールをよく読んでから参加してください。',
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
		vcomment    => 'この村は自動的に建てられた村です。<br>トップページに書かれているルールをよく読んでから参加してください。',
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
		'暁の村',
		'祈りの村',
		'海辺の村',
		'永寿の村',
		'桜花の村',
		'影の村',
		'季節外れの村',
		'久遠の村',
		'渓谷の村',
		'恒温の村',
		'祭祀の村',
		'職人の村',
		'すみれの村',
		'泉源の村',
		'束縛の村',
		'探究の村',
		'中世の村',
		'月夜の村',
		'天上の村',
		'倒錯の村',
		'凪の村',
		'人形回しの村',
		'ぬくもりの村',
		'願いの村',
		'野苺の村',
		'博愛の村',
		'氷雪の村',
		'吹雪の村',
		'辺境の村',
		'放浪の村',
		'真夏の村',
		'みかんの村',
		'無名の村',
		'銘菓の村',
		'妄想の村',
		'闇夜の村',
		'夕暮れの村',
		'妖艶の村',
		'雷光の村',
		'緑雨の村',
		'流刑の村',
		'煉瓦の村',
		'楼閣の村',
		'和の村',
	);

	# 画像の作者等の表示用
	my @copyrights = (
		'人狼物語画像 by Momoko Takatori',
		'SWBBS-R 画像 by rembrandt',
		'トロイカ by <a href="http://asakp2.orsp.net/">かえるぴょこぴょこ／あさくら</a>',
		'仰げば狼 by <a href="http://web1.kcn.jp/so-u-ko-u/">妖怪のたおしかた／おくみつ</a>',
		'人狼BBS10周年(仮) 画像 by AICE',
	);

	# キャッシュクリアのためファイル名に日付を入れた。（更新忘れそう）
	my %css_default = (
		TITLE => '標準スタイル',
		FILE  => 'sow.css?date=20190104',
		WIDTH => 500,
	);

	my %css_text = (
		TITLE => '簡易表示',
		FILE  => 'text.css?date=20190104',
		WIDTH => 500,
	);

	my %css_junawide = (
		TITLE => '審問風',
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

	# ロボット検索用の設定
	my @robots = (
	#	'noindex,nofollow',
	#	'noarchive',
	);

	# おみくじ
	# 個数は固定なので変えない事
	my @mikuji = (
		'現人神',   #  3
		'一等賞',   #  4
		'大大吉',   #  5
		'大吉',     #  6
		'中吉',     #  7
		'小吉',     #  8
		'吉',       #  9
		'半吉',     # 10
		'末吉',     # 11
		'末小吉',   # 12
		'凶',       # 13
		'小凶',     # 14
		'半凶',     # 15
		'末凶',     # 16
		'大凶',     # 17
		'回答拒否', # 18
	);

	# 閲覧制限表示
	my %ratingnormal = (
		FILE    => '',
		CAPTION => '一般',
		ALT     => '',
		WIDTH   => 0,
		HEIGHT  => 0,
	);

	my %rating15 = (
		FILE    => 'cau15.png',
		CAPTION => '15歳以上',
		ALT     => 'R15',
		WIDTH   => 16,
		HEIGHT  => 16,
	);

	my %rating18 = (
		FILE    => 'cau18.png',
		CAPTION => '18歳以上',
		ALT     => 'R18',
		WIDTH   => 16,
		HEIGHT  => 16,
	);

	my %ratinggro = (
		FILE    => 'caugro.png',
		CAPTION => 'グロ注意',
		ALT     => 'グロ',
		WIDTH   => 16,
		HEIGHT  => 16,
	);

	my %ratingview = (
		FILE    => 'cauview.png',
		CAPTION => '閲覧注意',
		ALT     => '注意',
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
		# 1:動作停止（アップデート用）
		ENABLED_HALT => 0,

		# 0:村の作成ができない（村作成終了用）
		# 1:村を作成可能
		ENABLED_VMAKE => 1,

		NAME_SW      => '人狼物語',
		URL_SW       => 'http://***/sow', # 設置するURL（最後の“/”は必要ありません）
		DESC_SW      => '人狼BBS似のウェブ版人狼クローン。',
		ENABLED_MENU => 1, # 1:トップページのメニューを表示する
		URL_HOME     => 'http://www.gunjobiyori.com/', # ホームページ
		NAME_HOME    => '群青日和(blog)',
		NAME_TOP	 => 'TOP',
		URL_BBS_PC   => 'http://www.twitter.com/euro_s', # サポート掲示板のURL
		NAME_BBS_PC  => '@euro_s', # サポート掲示板の名前
		URL_BBS_MB   => 'http://www.twitter.com/euro_s', # サポート掲示板のURL（携帯向け）
		NAME_BBS_MB  => '@euro_s', # サポート掲示板の名前（携帯向け）

		MAX_VILLAGES   =>  5, # 最大同時稼働村数
		TIMEOUT_SCRAP  => 42, # 廃村期限
		TIMEOUT_ENTRY  => 1.5, # プロローグでの無発言者自動追い出し機能の制限日数

		MESFIXTIME        =>  20, # 保留時間
		MAX_ROW           =>  50, # 標準表示時の行数
		MAX_ROW_MB        =>  10, # 標準表示時の行数（モバイル）
		MAX_PAGEROW_PC    => 100, # ページ表示時の行数(未使用)
		MAX_PAGES_MB      =>   5, # ページリンクの表示数
		ROW_ACTION        =>   0, # 行数計算にアクションを含むかどうか
		MIN_VSRECORDTOTAL =>   2, # ｎ戦以上同村している相手のみ、対戦成績を表示
		CANDY_LS          =>   5, # ｎ個飴を集めると大きくなる

		ENABLED_TSAY_PRO     => 1, # プロローグでの独り言
		ENABLED_TSAY_GRAVE   => 1, # 墓下での独り言
		ENABLED_TSAY_GUEST   => 1, # 傍観者の独り言
		ENABLED_TSAY_EP      => 1, # エピでの独り言
		ENABLED_PERMIT_DEAD  => 1, # 墓下の人狼/共鳴者/コウモリ人間が囁きを見られるかどうか
		ENABLED_DELETED      => 1, # 削除発言を表示するかどうか
		ENABLED_SUDDENDEATH  => 1, # 1:突然死あり
		ENABLED_NOTICE_SD    => 0, # 1:突然死通知あり（未実装）
		DAY_INITPENALTY      => 0, # 突然死などのペナルティ初期値（単位は日数）
		ENABLED_MULTIENTRY   => 1, # 1:掛け持ちを許可する
		ENABLED_RANDOMTARGET => 1, # 1:投票・能力先に「ランダム」を含める
		DEFAULT_VOTETYPE     => 'anonymity', # 標準の投票方法(sign: 記名、anonymity:無記名)
		DEFAULT_NOSELROLE    => 1, # 1:デフォルトで役職希望無効
		DEFAULT_MAKERSAYMENU => 1, # 1:デフォルトで進行中村建発言不可能
		DEFAULT_ENTRUSTMODE  => 1, # 1:デフォルトで委任不可能
		DEFAULT_SHOWALL      => 1, # 1:デフォルトで墓下公開
		DEFAULT_NOACTMODE    => 2, # デフォルトでact/memo 0:on/on 1:off/on 2:on/off 3:off/off
		DEFAULT_NOCANDY      => 1, # 1:デフォルトで促し不可能
		DEFAULT_NOFREEACT    => 1, # 1:デフォルトで自由文アクション不可能
		DEFAULT_TIMESTAMP    => 1, # 1:デフォルトで時刻簡易表示

		ENABLED_POPUP => 1, # アンカーのポップアップ

		USERID_NPC   => 'master', # ダミーキャラのユーザID
		USERID_ADMIN => 'admin', # 管理人のユーザID

		# ファイルロック機能
		ENABLED_GLOCK => 1, # 0: none, 1: flock, 2: rename
		TIMEOUT_GLOCK => 5 * 60, # rename方式の時の時間切れ

		# 標準のバナー画像
		FILE_TOPBANNER   => 'mwtitle.jpg',
		TOPBANNER_WIDTH  => 500,
		TOPBANNER_HEIGHT => 70,

		#----------------------------------------
		# 入力値の制限値
		#----------------------------------------
		MAXSIZE_USERID => 32, # ユーザIDの最大バイト数
		MINSIZE_USERID =>  2, # ユーザIDの最小バイト数
		MAXSIZE_PASSWD =>  8, # パスワードの最大バイト数
		MINSIZE_PASSWD =>  5, # パスワードの最小バイト数

		MINSIZE_MES      =>   4, # 発言の最小バイト数
		MAXSIZE_ACTION   =>  60, # アクションの最大バイト数
		MINSIZE_ACTION   =>   4, # アクションの最大バイト数
		MAXSIZE_MEMOCNT  => 300, # メモの最大バイト数
		MINSIZE_MEMOCNT  =>   4, # メモの最小バイト数
		MAXSIZE_MEMOLINE =>  15, # メモの最大行数

		MAXSIZE_VNAME    => 32,  # 村の名前の最大バイト数
		MINSIZE_VNAME    => 6,   # 村の名前の最小バイト数
		MAXSIZE_VCOMMENT => 600, # 村の説明の最大バイト数
		MINSIZE_VCOMMENT => 16,  # 村の説明の最小バイト数
		MAXSIZE_VPLCNT   => 25,  # 定員の最大数
		MINSIZE_VPLCNT   =>  4,  # 定員の最小数

		MAXSIZE_HANDLENAME => 64,  # ハンドル名の最大バイト数
		MAXSIZE_URL        => 128, # URLの最大バイト数
		MAXSIZE_INTRO      => 600, # 自己紹介の最大バイト数

		MAXCOUNT_STIGMA => 5, # 聖痕者の最大数

		#----------------------------------------
		# オプション機能
		#----------------------------------------

		# 自動生成関係
		AUTOMV_TIMING    => 'VSTATUSID_PLAY',
		AUTO_MAKEVILS    => \%automv,
		AUTO_NAMES       => \@autonames,

		# 参考
		# VSTATUSID_PRO      => 0, # 参加者募集中／開始前
		# VSTATUSID_PLAY     => 1, # 進行中
		# VSTATUSID_EP       => 2, # 勝敗が決しました
		# VSTATUSID_END      => 3, # 終了
		# VSTATUSID_SCRAP    => 4, # 廃村（エピ中）
		# VSTATUSID_SCRAPEND => 5, # 廃村終了

		# TypeKey認証（未実装）
		ENABLED_TYPEKEY => 0, # 1:TypeKey認証を用いる
		TOKEN_TYPEKEY => '',

		# QRコード
		# ※要QRcode Perl CGI & PHP scripts
		# http://www.swetake.com/qr/qr_cgi.html
		ENABLED_QR => 0, # 1:QRコード出力機能を使用する
		URL_QR => '',

		# gzip転送機能
#		FILE_GZIP => '/bin/gzip',
		FILE_GZIP => '',

		DEFAULT_TEXTRS => 'sow', # デフォルトの文字列リソース

		DEFAULT_UA => 'html401', # デフォルトの出力形式
		ENABLED_PLLOG => 1, # 1:プレイヤーの操作ログを記録
		ENABLED_SCORE => 1, # 人狼譜の出力

		# RSS出力
		ENABLED_RSS => 1,
		MAXSIZE_RSSDESC => 400, # RSS の description要素の最大バイト数
		RSS_ENCODING_UTF8  => 0, # 1:RSSを UTF-8 で出力する（要Jcode.pm）

		# ランダム表示機能
		ENABLED_RANDOMTEXT => 1,
		RANDOMTEXT_1D6     => '1d6',
		RANDOMTEXT_1D10    => '1d10',
		RANDOMTEXT_1D20    => '1d20',
		RANDOMTEXT_FORTUNE => 'fortune',
		RANDOMTEXT_LIVES   => 'who',
		RANDOMTEXT_MIKUJI  => 'omikuji',
		RANDOMTEXT_ROLE    => 'role',

		# アプリケーションログ
		ENABLED_APLOG => 1,
		LEVEL_APLOG => 5,
		MAXSIZE_APLOG => 65536,
		MAXNO_APLOG => 9,
		ENABLED_HTTPLOG => 0, # HTTPログ出力

		OUTPUT_HTTP_EQUIV => 1, # HTMLに http-equiv を出力する時は 1 に。
		ENABLED_HTTP_CACHE => 0, # 1:キャッシュ制御を有効にする（非推奨）

		# form要素の method属性値
		# うまく動作しない時は get に設定してみてください。
		METHOD_FORM => 'post',

		# form要素の method属性値（携帯モード）
		# 大昔の携帯には post を受け付けない物があるらしい。
		# 最近のならまず大丈夫っぽいけど。
		METHOD_FORM_MB => 'post',

		MAXSIZE_QUERY => 65536,

		# 時差
		TIMEZONE => 9, # JST

		# クッキーの生存期間
		TIMEOUT_COOKIE => 60 * 60 * 24 * 14,

		CID_MAKER   => 'maker', # 村建て人用の便宜上のキャラID
		CID_ADMIN   => 'admin', # 管理人用の便宜上のキャラID
		CID_GUEST   => 'guest', # 傍観者用の便宜上のキャラID

		# 基本ディレクトリ
		BASEDIR_CGI => '.',
		BASEDIR_DOC => '.',
		BASEDIR_DAT => './data',

		ENABLED_DIRVIL => 1, # 村データを村番号毎にディレクトリ分けする

		FILE_SOW       => "sow.cgi",
		FILE_VIL       => "vil.cgi",
		FILE_LOG       => "log.cgi",
		FILE_LOGINDEX  => "logidx.cgi",
		FILE_LOGCNT    => "logcnt.cgi",
		FILE_QUE       => "que.cgi",
		FILE_MEMO      => "memo.cgi",
		FILE_MEMOINDEX => "memoidx.cgi",
		FILE_SCORE     => "score.cgi",

		# キャッシュクリアのためファイル名に日付を入れた。（更新忘れそう）
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
