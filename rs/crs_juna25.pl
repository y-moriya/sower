package SWResource_juna25;

#----------------------------------------
# 人狼審問キャラセット（α１～α2.5）
# http://briefcase.yahoo.co.jp/jsfun2
#----------------------------------------

sub GetRSChr {
	my $sow = $_[0];

	my $maker = $sow->{'cfg'}->{'CID_MAKER'};
	my $admin = $sow->{'cfg'}->{'CID_ADMIN'};

	my @order = (
		'char00', 'char01', 'char02', 'char03',
		'char04', 'char05', 'char06', 'char07',
		'char08', 'char09', 'char10', 'char11',
		'char12', 'char13', 'char14', 'char15',
		'char16', 'char17', 'char18', 'char19',
		'char20', 'char21', 'char22', 'char23',
		'char24', 'char25',
	);

	# キャラの肩書き
	my %chrjob = (
		char00 => '自警団長',
		char01 => '長老',
		char02 => '宿の主人',
		char03 => '農夫',
		char04 => '職人',

		char05 => '料理人',
		char06 => '肉屋',
		char07 => '医師',
		char08 => 'こそ泥',
		char09 => '神父',

		char10 => '道化',
		char11 => '流れ者',
		char12 => '実業家',
		char13 => '行商人',
		char14 => '道楽者',

		char15 => '職人の弟子',
		char16 => '実業家の子',
		char17 => '修道女',
		char18 => '老婆',
		char19 => '医師の妻',

		char20 => '医師の娘',
		char21 => '長老の孫',
		char22 => '教師',
		char23 => '新聞記者',
		char24 => '孤児',

		char25 => '教師の妹',

		$maker => '',
		$admin => '',
	);

	# キャラの名前
	my %chrname = (
		char00 => 'アーヴァイン',
		char01 => 'ウォーレス',
		char02 => 'ヘクター',
		char03 => 'ロブ',
		char04 => 'オーウェン',

		char05 => 'イアン',
		char06 => 'ラルフ',
		char07 => 'オズワルド',
		char08 => 'ルーク',
		char09 => 'サイモン',

		char10 => 'チェスター',
		char11 => 'クラーク',
		char12 => 'オリバー',
		char13 => 'マーティン',
		char14 => 'スコット',

		char15 => 'ジョナサン',
		char16 => 'テッド',
		char17 => 'ヘレン',
		char18 => 'ドーラ',
		char19 => 'ルイーズ',

		char20 => 'テレサ',
		char21 => 'マーガレット',
		char22 => 'メアリー',
		char23 => 'アイリーン',
		char24 => 'アニタ',

		char25 => 'リサ',
		$maker => '天のお告げ（村建て人）',
		$admin => '闇の呟き（管理人）',
	);

	# キャラのラテンアルファベット名（オプション）
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
		$maker => '天のお告げ（村建て人）',
		$admin => '闇の呟き（管理人）',
	);

	# キャラ名頭文字（人狼譜出力用）
	my %chrnameinitial = (
		char00 => '警',
		char01 => '老',
		char02 => '宿',
		char03 => '農',
		char04 => '職',

		char05 => '料',
		char06 => '肉',
		char07 => '医',
		char08 => '泥',
		char09 => '神',

		char10 => '化',
		char11 => '流',
		char12 => '実',
		char13 => '商',
		char14 => '楽',

		char15 => '弟',
		char16 => '子',
		char17 => '修',
		char18 => '婆',
		char19 => '妻',

		char20 => '娘',
		char21 => '孫',
		char22 => '教',
		char23 => '記',
		char24 => '孤',

		char25 => '妹',
	);

	my @npcsay =(
		'　ふむ……まだ集まっていないようだな。　今のうちに、もう一度見回りに行ってくるとしよう。',
		'　あー、諸君、聞いてくれ。もう噂になっているようだが、まずいことになった。<br>　この間の旅人が殺された件、やはり人狼の仕業のようだ。<br><br>　当日、現場に出入り出来たのは今ここにいる者で全部だ。<br>　とにかく十分に注意してくれ。',
	);

	my @expression = ();

	my %charset = (
	      CAPTION        => '人狼審問α2.5',
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