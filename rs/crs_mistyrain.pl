package SWResource_mistyrain;

#----------------------------------------
# 霧雨降る街 by きりのれいん
# http://misty-rain.sakura.ne.jp/fall0rain/
# 13/07/13
#----------------------------------------

sub GetRSChr {
	my $sow = $_[0];

	my $maker = $sow->{'cfg'}->{'CID_MAKER'};
	my $admin = $sow->{'cfg'}->{'CID_ADMIN'};
	my $guest = $sow->{'cfg'}->{'CID_GUEST'};

	# キャラの表示順
	my @order = (
		'01', '02', '03', '04', '05',
		'06', '07', '08', '09', '10',
		'11', '12', '13', '14', '15',
		'16', '17', '18', '19', '20',
		'21', '22', '23', '24', '25',
		'26', '27', '28', '29', '30',
		'31', '32',	'33', '34', '35',
		'36', '37', '38', '39', '40',
		'41', '42', '43', '44', '45',
		'46', '47', '48', '49', '50',
		'51', '52', '53', '54', '55',
		'56', '57', '58', '59', '60',
		'61', '62', '63', '64', '65',
		'66', '67', '68', '69', '70',
		'71', '72', '73', '74', '75',
		'76', '77', '78', '79', '80',
	);

	# キャラの肩書き
	my %chrjob = (
		'01' => '恋多き娘',
		'02' => '双子の赤',
		'03' => '双子の青',
		'04' => '見習い',
		'05' => '訓練生',
		'06' => '教官',
		'07' => '落第生',
		'08' => '飛び級',
		'09' => '看板娘',
		'10' => '若店主',
		'11' => '領主の娘',
		'12' => '領主の末娘',
		'13' => '町娘',
		'14' => '異国の旅人',
		'15' => '女装癖',
		'16' => '隠密修行',
		'17' => '受信中',
		'18' => '自己愛者',
		'19' => '用心棒',
		'20' => '悪ガキ',
		'21' => '鍛冶屋',
		'22' => '仮面紳士',
		'23' => '童話読み',
		'24' => '中毒',
		'25' => '自称王子',
		'26' => '図書館長',
		'27' => '女中',
		'28' => '怪談好き',
		'29' => '修道女',
		'30' => '踊り子',
		'31' => '詠み手',
		'32' => '冒険家',
		'33' => '射手',
		'34' => '技師',
		'35' => '染物師',
		'36' => '商人',
		'37' => '建築家',
		'38' => '噂好き',
		'39' => '小説家',
		'40' => '観測者',
		'41' => '詐欺師',
		'42' => '彫師',
		'43' => '探究者',
		'44' => '泣き虫',
		'45' => '盲目',
		'46' => '転寝',
		'47' => '作曲家',
		'48' => '接客業',
		'49' => '毒舌家',
		'50' => '家令',
		'51' => '雪国の作家',
		'52' => '雪国の少女',
		'53' => '本屋',
		'54' => '郵便屋',
		'55' => '装飾工',
		'56' => '植物学者',
		'57' => '酒飲み',
		'58' => '調香師',
		'59' => '薬草摘み',
		'60' => '治療中',
		'61' => '昆虫博士',
		'62' => '綾取り',
		'63' => '蒐集家',
		'64' => '研究者',
		'65' => '歌い手',
		'66' => '占星術師',
		'67' => '学術士',
		'68' => '演者',
		'69' => '煙草売り',
		'70' => '火薬師',
		'71' => '花屋',
		'72' => 'パン屋',
		'73' => '庭師',
		'74' => '写真家',
		'75' => '司祭',
		'76' => '好奇心',
		'77' => '泣き女',
		'78' => '代書人',
		'79' => '掏摸',
		'80' => '煙突掃除',
		
		$maker => '',
		$admin => '',
    	$guest => '傍観者',
	);

	# キャラの名前
	my %chrname = (
		'01' => 'メイ',
		'02' => 'レディア',
		'03' => 'ヴィノール',
		'04' => 'ミレイユ',
		'05' => 'ルファ',
		'06' => 'アミル',
		'07' => 'クラット',
		'08' => 'シュカ',
		'09' => 'サリィ',
		'10' => 'エト',
		'11' => 'ロッテ',
		'12' => 'エリィゼ',
		'13' => 'コレット',
		'14' => 'イル',
		'15' => 'ノクロ',
		'16' => 'ミナオ',
		'17' => 'ギュル',
		'18' => 'チサ',
		'19' => 'アルビーネ',
		'20' => 'ジュスト',
		'21' => 'ジャン',
		'22' => 'マスケラ',
		'23' => 'モカ',
		'24' => 'カイン',
		'25' => 'アールグレイ',
		'26' => 'ジョセフ',
		'27' => 'リーリ',
		'28' => 'アーニャ',
		'29' => 'イリア',
		'30' => 'メリッサ',
		'31' => 'ポラリス',
		'32' => 'ウィル',
		'33' => 'キリク',
		'34' => 'レネ',
		'35' => 'サムファ',
		'36' => 'アルカ',
		'37' => 'フェン',
		'38' => 'トルテ',
		'39' => 'エラリー',
		'40' => 'マリーベル',
		'41' => 'ネッド',
		'42' => 'ランス',
		'43' => 'エドワーズ',
		'44' => 'ティナ',
		'45' => 'テレーズ',
		'46' => 'オデット',
		'47' => 'ケーリー',
		'48' => 'スイートピー',
		'49' => 'セルマ',
		'50' => 'ユーリ　',
		'51' => 'エレオノーラ',
		'52' => 'リディヤ',
		'53' => 'クレイグ',
		'54' => 'パーシー',
		'55' => 'メリル',
		'56' => 'シニード',
		'57' => 'ハイヴィ',
		'58' => 'チュレット',
		'59' => 'ソ\ーヤ',
		'60' => 'スー',
		'61' => 'ニコル',
		'62' => 'ツリガネ',
		'63' => 'ダァリヤ',
		'64' => 'トロイ',
		'65' => 'ナデージュ',
		'66' => 'ヘロイーズ',
		'67' => 'ヒューゴ',
		'68' => 'ヤーニカ',
		'69' => 'ヌァヴェル',
		'70' => 'ヨアン',
		'71' => 'マイダ',
		'72' => 'デボラ',
		'73' => 'アーリック',
		'74' => 'ヴィンセント',
		'75' => 'ドワイト',
		'76' => 'エメット',
		'77' => 'シーナ',
		'78' => 'クレム',
		'79' => 'セス',
		'80' => 'ミケル',

		$maker => '天のお告げ（村建て人）',
		$admin => 'ゆーろ（管理人）',
    	$guest => &SWUser::GetHandle,
	);

	# キャラ名頭文字（人狼譜出力用）
	my %chrnameinitial = (
		'01' => 'メ',
		'02' => 'レ',
		'03' => 'ヴ',
		'04' => 'ミ',
		'05' => 'ル',
		'06' => 'ア',
		'07' => 'ク',
		'08' => 'シ',
		'09' => 'サ',
		'10' => 'エ',
		'11' => 'ロ',
		'12' => 'エ',
		'13' => 'コ',
		'14' => 'イ',
		'15' => 'ノ',
		'16' => 'ミ',
		'17' => 'ギ',
		'18' => 'チ',
		'19' => 'ア',
		'20' => 'ジ',
		'21' => 'ジ',
		'22' => 'マ',
		'23' => 'モ',
		'24' => 'カ',
		'25' => 'ア',
		'26' => 'ジ',
		'27' => 'リ',
		'28' => 'ア',
		'29' => 'イ',
		'30' => 'メ',
		'31' => 'ポ',
		'32' => 'ウ',
		'33' => 'キ',
		'34' => 'レ',
		'35' => 'サ',
		'36' => 'ア',
		'37' => 'フ',
		'38' => 'ト',
		'39' => 'エ',
		'40' => 'マ',
		'41' => 'ネ',
		'42' => 'ラ',
		'43' => 'エ',
		'44' => 'テ',
		'45' => 'テ',
		'46' => 'オ',
		'47' => 'ケ',
		'48' => 'ス',
		'49' => 'セ',
		'50' => 'ユ',
		'51' => 'エ',
		'52' => 'リ',
		'53' => 'ク',
		'54' => 'パ',
		'55' => 'メ',
		'56' => 'シ',
		'57' => 'ハ',
		'58' => 'チ',
		'59' => 'ソ\',
		'60' => 'ス',
		'61' => 'ニ',
		'62' => 'ツ',
		'63' => 'ダ',
		'64' => 'ト',
		'65' => 'ナ',
		'66' => 'ヘ',
		'67' => 'ヒ',
		'68' => 'ヤ',
		'69' => 'ヌ',
		'70' => 'ヨ',
		'71' => 'マ',
		'72' => 'デ',
		'73' => 'ア',
		'74' => 'ヴ',
		'75' => 'ド',
		'76' => 'エ',
		'77' => 'シ',
		'78' => 'ク',
		'79' => 'セ',
		'80' => 'ミ',

	);

	# ダミーキャラの発言
	my @npcsay =(
		'あらまぁ。<br>そんな話、はじめて聞きましたわ。',
		'どうしましょう。<br>怖くて仕方がないのです。',
	);

	my @expression = (
	);

	my %charset = (
		CAPTION        => '霧雨降る街',
		NPCID          => '01',
		CHRNAME        => \%chrname,
		CHRJOB         => \%chrjob,
		CHRNAMEINITIAL => \%chrnameinitial,
		ORDER          => \@order,
		NPCSAY         => \@npcsay,
		IMGBODYW       => 64,
		IMGBODYH       => 98,
		DIR            => "$sow->{'cfg'}->{'DIR_IMG'}/mistyrain",
		EXT            => '.png',
		BODY           => '',
		FACE           => '',
		GRAVE          => '_b',
		WOLF           => '_r',
		EXPRESSION     => \@expression,
		LAYOUT_NAME    => 'right',
	);

	return \%charset;
}

1;