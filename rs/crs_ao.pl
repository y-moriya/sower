package SWResource_ao;

#----------------------------------------
# 仰げば狼
#----------------------------------------

sub GetRSChr {
    my $sow = $_[0];

    my $maker = $sow->{'cfg'}->{'CID_MAKER'};
    my $admin = $sow->{'cfg'}->{'CID_ADMIN'};
    my $guest = $sow->{'cfg'}->{'CID_GUEST'};

    # キャラの表示順
    my @order = (
        '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16',
        '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30',
    );

    # キャラの肩書き
    my %chrjob = (
        '01'   => '学生探偵',
        '02'   => '理事長の娘',
        '03'   => '校長',
        '04'   => '教頭',
        '05'   => '女生徒',
        '06'   => '生徒会長',
        '07'   => '生徒会副会長',
        '08'   => '生徒会書記',
        '09'   => '転校生',
        '10'   => '番長',
        '11'   => 'スケ番',
        '12'   => '保健室の先生',
        '13'   => '給食調理員',
        '14'   => '理事長',
        '15'   => '留学生',
        '16'   => '迷い犬',
        '17'   => '機動学生',
        '18'   => '鳥小屋の主',
        '19'   => '用務員',
        '20'   => '教育実習生',
        '21'   => '陰陽道部',
        '22'   => '体育教師',
        '23'   => 'トイレ在住',
        '24'   => 'きぐるみ部',
        '25'   => 'さまよう少女',
        '26'   => '骨格標本',
        '27'   => '水棲生徒',
        '28'   => '学生執事',
        '29'   => '飛び級',
        '30'   => '指圧部',
        $maker => '',
        $admin => '',
    );

    # キャラの名前
    my %chrname = (
        '01'   => 'イチジク',
        '02'   => 'クィーン',
        '03'   => 'イワオ',
        '04'   => 'ズラタン',
        '05'   => 'ウメコ',
        '06'   => 'スマイル',
        '07'   => 'ユリッペ',
        '08'   => 'サイゴー',
        '09'   => 'マタタビ',
        '10'   => 'バンチョー',
        '11'   => 'キョーコ',
        '12'   => 'マリリン',
        '13'   => 'タラチネ',
        '14'   => 'サッチャー',
        '15'   => 'アニー',
        '16'   => 'ケルベロス',
        '17'   => 'メカタロー',
        '18'   => 'ピースケ',
        '19'   => 'シゲサン',
        '20'   => 'ワカバ',
        '21'   => 'ドーマン',
        '22'   => 'ムッキー',
        '23'   => 'ハナコ・Ｄ',
        '24'   => 'ウサミ',
        '25'   => 'レッドフード',
        '26'   => 'ホネホネ',
        '27'   => 'ウオタ',
        '28'   => 'セバスチャン',
        '29'   => 'ハル',
        '30'   => 'ナミコシ',
        $maker => '天のお告げ（村建て人）',
        $admin => 'ゆーろ（管理人）',
        $guest => &SWUser::GetHandle,
    );

    # キャラ名頭文字（人狼譜出力用）
    my %chrnameinitial = (
        '01' => 'イ',
        '02' => 'ク',
        '03' => 'イ',
        '04' => 'ズ',
        '05' => 'ウ',
        '06' => 'ス',
        '07' => 'ユ',
        '08' => 'サ',
        '09' => 'マ',
        '10' => 'バ',
        '11' => 'キ',
        '12' => 'マ',
        '13' => 'タ',
        '14' => 'サ',
        '15' => 'ア',
        '16' => 'ケ',
        '17' => 'メ',
        '18' => 'ピ',
        '19' => 'シ',
        '20' => 'ワ',
        '21' => 'ド',
        '22' => 'ム',
        '23' => 'ハ',
        '24' => 'ウ',
        '25' => 'レ',
        '26' => 'ホ',
        '27' => 'ウ',
        '28' => 'セ',
        '29' => 'ハ',
        '30' => 'ナ',
    );

    # ダミーキャラの発言
    my @npcsay = ( 'ねぇねぇ、知ってる？', 'ねぇねぇ、本当らしいよ。' );

    my @expression = ();

    my %charset = (
        CAPTION        => '仰げば狼',
        NPCID          => '05',
        CHRNAME        => \%chrname,
        CHRJOB         => \%chrjob,
        CHRNAMEINITIAL => \%chrnameinitial,
        ORDER          => \@order,
        NPCSAY         => \@npcsay,

        #		IMGFACEW       => 74,
        #		IMGFACEH       => 110,
        IMGBODYW => 74,
        IMGBODYH => 110,

        #		IMGMOBILEW     => 16,
        #		IMGMOBILEH     => 16,
        DIR         => "$sow->{'cfg'}->{'DIR_IMG'}/ao",
        EXT         => '.png',
        BODY        => '',
        FACE        => '',
        GRAVE       => '',
        WOLF        => '_n',
        EXPRESSION  => \@expression,
        LAYOUT_NAME => 'right',
    );

    return \%charset;
}

1;
