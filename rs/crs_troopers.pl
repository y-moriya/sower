package SWResource_troopers;

#----------------------------------------
# チップ名:Troopers
# 作者：人類管理連合
#----------------------------------------

sub GetRSChr {
    my $sow = $_[0];

    my $maker = $sow->{'cfg'}->{'CID_MAKER'};
    my $admin = $sow->{'cfg'}->{'CID_ADMIN'};
    my $guest = $sow->{'cfg'}->{'CID_GUEST'};

    # キャラの表示順
    my @order = (
        '000', '001', '002', '003', '004', '005', '006', '007', '008', '009', '010', '011', '012', '013',
        '014', '015', '016', '017', '018', '019', '020', '021', '022', '023', '024', '025', '026', '027',
        '028', '029', '030', '031', '032', '033', '034', '035', '036', '037', '038', '039', '040', '041',
        '042', '043', '044', '045', '046', '047', '048', '049', '050', '051', '052', '053', '054', '055',
        '056', '057', '058', '059', '060', '061', '062', '063', '064', '065', '066', '067', '068', '069',
        '070', '071', '072', '073', '074', '075', '076', '077', '078', '079', '080', '081', '082', '083',
        '084', '085', '086', '087', '088', '089', '090', '091', '092', '093', '094', '095', '096', '097',
        '098',
    );

    # キャラの肩書き
    my %chrjob = (
        '000'  => '崩壊都市',
        '001'  => '無尽機',
        '002'  => '馬鉄骨',
        '003'  => '巡庸艦',
        '004'  => '暖房機',
        '005'  => '彷徨槽',
        '006'  => '爪轟牙',
        '007'  => '叛虐抗女',
        '008'  => '曖玩飼育',
        '009'  => '特攻採集',
        '010'  => '縫合修善',
        '011'  => '等価商売',
        '012'  => '静黙警手',
        '013'  => '師導指揮',
        '014'  => '浮浪廃徊',
        '015'  => 'A劫回帰',
        '016'  => '低唱B吟',
        '017'  => '旧神信仰',
        '018'  => '救世済民',
        '019'  => '駆逐缶',
        '020'  => '羊塔監',
        '021'  => '紫花天',
        '022'  => '月季天',
        '023'  => '盗電伝電',
        '024'  => '破情破棄',
        '025'  => '屠殺楽殺',
        '026'  => '誘蛾誘惑',
        '027'  => '触媒触手',
        '028'  => '薬理薬厄',
        '029'  => '堕落洒落',
        '030'  => '制御回路',
        '031'  => '導線確保',
        '032'  => '危険信号',
        '033'  => '論理解除',
        '034'  => '物理排除',
        '035'  => '不備監査',
        '036'  => '正常動作',
        '037'  => '基盤創造',
        '038'  => '配線整備',
        '039'  => '数字殺シ',
        '040'  => '砲抹夢現',
        '041'  => '仮晶暁闇',
        '042'  => '形代空晶',
        '043'  => '青白磁銃',
        '044'  => '石火硝煙',
        '045'  => '刀自夏暁',
        '046'  => '斬罪花時',
        '047'  => '異形陶工',
        '048'  => '鈍重戚揚',
        '049'  => '五体胴元',
        '050'  => '辰砂魔交',
        '051'  => '朧广灯',
        '052'  => '残鷺匚',
        '053'  => '碇星魄',
        '054'  => '天弓鴎',
        '055'  => '眼沙射影',
        '056'  => '焦土嗅浪',
        '057'  => '伝奏帯域',
        '058'  => '腑分吊骨',
        '059'  => '捨身飼骸',
        '060'  => '機才博士',
        '061'  => '硝子生命',
        '062'  => '彗棲槽脳',
        '063'  => '苗床環者',
        '064'  => '研究機員',
        '065'  => '化学塗料',
        '066'  => '変性樹脂',
        '067'  => '蛍光溶剤',
        '068'  => '異常染色',
        '069'  => '発火塗膜',
        '070'  => '有機触媒',
        '071'  => '添加顔料',
        '072'  => '赫色頭巾',
        '073'  => '夢幻空想',
        '074'  => '猛毒林檎',
        '075'  => '鋳薔薇姫',
        '076'  => '二ノ宮',
        '077'  => '三ノ宮',
        '078'  => '四ノ宮',
        '079'  => '言ト霊',
        '080'  => '寿ホ儀',
        '081'  => '忌ミ火',
        '082'  => '六六六',
        '083'  => '蕃神',
        '084'  => '巫凪',
        '085'  => '視線工作',
        '086'  => '悠幽自適',
        '087'  => '安全運飯',
        '088'  => '甘味一帯',
        '089'  => '嬉奇怪会',
        '090'  => '饅漢全席',
        '091'  => '某飲亡食',
        '092'  => '麻跳放翔',
        '093'  => 'OA♪姫',
        '094'  => 'C&R娘',
        '095'  => 'M!X嬢',
        '096'  => 'FM☆娘',
        '097'  => 'E♯G姉',
        '098'  => '渇仰光舞',
        $maker => '',
        $admin => '',
        $guest => '傍観者',
    );

    # キャラの名前
    my %chrname = (
        '000'  => '□□□□',
        '001'  => 'UAV100278',
        '002'  => 'K1-RIN',
        '003'  => 'PK',
        '004'  => 'REN-G',
        '005'  => 'CAN-D',
        '006'  => 'TU-SK',
        '007'  => 'オサ',
        '008'  => 'カイ',
        '009'  => 'カリ',
        '010'  => 'ハリコ',
        '011'  => 'ウルカウ',
        '012'  => 'ガァド',
        '013'  => 'シジ',
        '014'  => 'タエナシ',
        '015'  => 'コルナ',
        '016'  => 'トラッシュ',
        '017'  => 'エリヤ',
        '018'  => 'マナ',
        '019'  => 'デイジー',
        '020'  => 'ラム-16',
        '021'  => 'タリアｰ04',
        '022'  => 'ジブリール',
        '023'  => 'キャット',
        '024'  => 'ドッグ',
        '025'  => 'ラビット',
        '026'  => 'シープ',
        '027'  => 'オクト',
        '028'  => 'マウス',
        '029'  => 'スネーク',
        '030'  => 'アインス',
        '031'  => 'ツヴァイ',
        '032'  => 'ドライ',
        '033'  => 'フィア',
        '034'  => 'フュンフ',
        '035'  => 'ゼクス',
        '036'  => 'ズィー',
        '037'  => 'ノイン',
        '038'  => 'エルフ',
        '039'  => 'ヌル',
        '040'  => 'アハトアハト',
        '041'  => 'カウンテス',
        '042'  => 'メイド',
        '043'  => 'バトラー',
        '044'  => 'フットマン',
        '045'  => 'コック',
        '046'  => 'ガーデナー',
        '047'  => 'テイラー',
        '048'  => 'キーパー',
        '049'  => 'サージオン',
        '050'  => 'フィジシャン',
        '051'  => 'リヒトーヴ',
        '052'  => 'ヘロー',
        '053'  => 'インダラクス',
        '054'  => 'ヌエヌエ',
        '055'  => 'レイザ',
        '056'  => 'マズル',
        '057'  => 'Z.K',
        '058'  => 'トゥエル',
        '059'  => 'ハクカイ',
        '060'  => 'ウキクサ',
        '061'  => 'インビトロ',
        '062'  => 'ビオト',
        '063'  => 'メディウム',
        '064'  => 'フランクル',
        '065'  => 'シー',
        '066'  => 'エム',
        '067'  => 'ワイ',
        '068'  => 'ケイ',
        '069'  => 'アール',
        '070'  => 'ジー',
        '071'  => 'ビイ',
        '072'  => 'シルウァ',
        '073'  => 'アリシア',
        '074'  => 'ルミ',
        '075'  => 'ローズ',
        '076'  => '群鷺',
        '077'  => '緋雁',
        '078'  => '天蓋',
        '079'  => '羅生',
        '080'  => '直青',
        '081'  => '重陽',
        '082'  => 'ミケ',
        '083'  => '雷恩',
        '084'  => '桜花',
        '085'  => 'キショウ',
        '086'  => 'カファレ',
        '087'  => 'エティリ',
        '088'  => 'ルフェア',
        '089'  => 'グウォル',
        '090'  => 'タオズー',
        '091'  => 'フィル',
        '092'  => 'ホアジャオ',
        '093'  => 'ラナ',
        '094'  => 'ダイヤ',
        '095'  => 'ヴィーオ',
        '096'  => 'ロディア',
        '097'  => 'プルモ',
        '098'  => 'スルガ',
        $maker => '機械音声（村建て）',
        $admin => '人類管理代行（管理人）',
        $guest => &SWUser::GetHandle,
    );

    # キャラ名頭文字（人狼譜出力用）
    my %chrnameinitial = (
        '000' => '□□□□',
        '001' => 'UAV100278',
        '002' => 'K1-RIN',
        '003' => 'PK',
        '004' => 'REN-G',
        '005' => 'CAN-D',
        '006' => 'TU-SK',
        '007' => 'オサ',
        '008' => 'カイ',
        '009' => 'カリ',
        '010' => 'ハリコ',
        '011' => 'ウルカウ',
        '012' => 'ガァド',
        '013' => 'シジ',
        '014' => 'タエナシ',
        '015' => 'コルナ',
        '016' => 'トラッシュ',
        '017' => 'エリヤ',
        '018' => 'マナ',
        '019' => 'デイジー',
        '020' => 'ラム-16',
        '021' => 'タリアｰ04',
        '022' => 'ジブリール',
        '023' => 'キャット',
        '024' => 'ドッグ',
        '025' => 'ラビット',
        '026' => 'シープ',
        '027' => 'オクト',
        '028' => 'マウス',
        '029' => 'スネーク',
        '030' => 'アインス',
        '031' => 'ツヴァイ',
        '032' => 'ドライ',
        '033' => 'フィア',
        '034' => 'フュンフ',
        '035' => 'ゼクス',
        '036' => 'ズィー',
        '037' => 'ノイン',
        '038' => 'エルフ',
        '039' => 'ヌル',
        '040' => 'アハトアハト',
        '041' => 'カウンテス',
        '042' => 'メイド',
        '043' => 'バトラー',
        '044' => 'フットマン',
        '045' => 'コック',
        '046' => 'ガーデナー',
        '047' => 'テイラー',
        '048' => 'キーパー',
        '049' => 'サージオン',
        '050' => 'フィジシャン',
        '051' => 'リヒトーヴ',
        '052' => 'ヘロー',
        '053' => 'インダラクス',
        '054' => 'ヌエヌエ',
        '055' => 'レイザ',
        '056' => 'マズル',
        '057' => 'Z.K',
        '058' => 'トゥエル',
        '059' => 'ハクカイ',
        '060' => 'ウキクサ',
        '061' => 'インビトロ',
        '062' => 'ビオト',
        '063' => 'メディウム',
        '064' => 'フランクル',
        '065' => 'シー',
        '066' => 'エム',
        '067' => 'ワイ',
        '068' => 'ケイ',
        '069' => 'アール',
        '070' => 'ジー',
        '071' => 'ビイ',
        '072' => 'シルウァ',
        '073' => 'アリシア',
        '074' => 'ルミ',
        '075' => 'ローズ',
        '076' => '群鷺',
        '077' => '緋雁',
        '078' => '天蓋',
        '079' => '羅生',
        '080' => '直青',
        '081' => '重陽',
        '082' => 'ミケ',
        '083' => '雷恩',
        '084' => '桜花',
        '085' => 'キショウ',
        '086' => 'カファレ',
        '087' => 'エティリ',
        '088' => 'ルフェア',
        '089' => 'グウォル',
        '090' => 'タオズー',
        '091' => 'フィル',
        '092' => 'ホアジャオ',
        '093' => 'ラナ',
        '094' => 'ダイヤ',
        '095' => 'ヴィーオ',
        '096' => 'ロディア',
        '097' => 'プルモ',
        '098' => 'スルガ',
    );

    # ダミーキャラの発言
    my @npcsay = (
        '街は瓦礫の海に沈んでいる。<br>大きな動きを見せるものは、軒並み機械のみ ──',
        '── 集う機械達から無機質な音声が発せられる。<br><br>『正常化を開始します。<br>　繰り返します、正常化を開始します。』',
    );

    my @expression = ();

    my %charset = (
        CAPTION        => 'Troopers',
        NPCID          => '000',
        CHRNAME        => \%chrname,
        CHRJOB         => \%chrjob,
        CHRNAMEINITIAL => \%chrnameinitial,
        ORDER          => \@order,
        NPCSAY         => \@npcsay,
        IMGBODYW       => 90,
        IMGBODYH       => 130,
        DIR            => "$sow->{'cfg'}->{'DIR_IMG'}/troopers",
        EXT            => '.png',
        BODY           => '',
        FACE           => '',
        GRAVE          => '-haka',
        WOLF           => '-red',
        TSAY           => '-doku',
        LSAY           => '-momo',
        EXPRESSION     => \@expression,
        LAYOUT_NAME    => 'right',
    );

    return \%charset;
}

1;
