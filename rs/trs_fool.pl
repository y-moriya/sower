package SWTextRS_fool;

sub GetTextRS {
    my @announce_first = ( 'なんか人狼出たから集まれってよ。', 'とりあえず始まったらしいぜ？', 'あー、誰かなんか死んだっぽいね。', );

    my @announce_role = ( 'なんかこん中に、_ROLE_いるらしいで。', 'が', '人', '、', );

    my @announce_lives = ( 'しぶとい奴は', '、', ' の _LIVES_ 人だと思っておこう。', );

    my @announce_vote =
      ( '_NAME_ は _TARGET_ に_RANDOM_投票してみた。', '_NAME_ に _COUNT_人が投票した（らしい）。', '_NAME_ は村人達によってたかってぶち殺された。' );

    my @announce_entrust = ( '_NAME_は_TARGET_に_RANDOM_投票を任せて寝た。', '_NAME_は_TARGET_に_RANDOM_投票を任せて寝たが、投票先が変だったっぽい。', );

    # コミット
    my @announce_commit = ( '_NAME_が時間を進めるのを止めた。', '_NAME_は時間を進めたいらしい。', );

    my @announce_totalcommit = (
        '「時間を進める」を選んでる人はまだ少ないっぽい。',    # 0～1/3の時
        '「時間を進める」を選んでる人はちょっと増えた。',     # 1/3～2/3の時
        '「時間を進める」を選んでる人は結構増えた。',       # 2/3～n-1の時
        'みんなが「時間を進める」を選んだ（らしい）。',      # 全員コミット済み
    );

    my @announce_kill = ( '人狼は食い損ねてお腹が空いているようだ。', '誰かが寝たまま起きなかったみたい。', );

    my @announce_winner = (
        'そして誰もいなくなった。',               '村人達が勝ちやがりました。',
        '人狼はたっぷり食べて満足したようだ。おめでとう。',   '勝ったと思った時には、たいてい負けている（らしい）。',
        'ハハッ、剣はハジキには勝てねーんだよ！（意味不明）。', '愛の嵐が吹き荒れる……。<br>人は、愛の前にはこんなにも無力なのだ……。',
    );

    my @caption_winner = ( '', 'ニンゲン', 'わーうるふ', '人間でも人狼でもない連中', '人間でも人狼でもない連中', '恋人' );

    my @rolename = (
        '余り物', 'ただの人',  'おおかみ',   'エスパー', 'イタコ',  '人狼スキー', 'ストーカー',  '夫婦', 'ハム', '人狼教神官',
        '痣もち', '人狼教信者', 'おしどり夫婦', 'コウモリ', '逆恨み狼', 'グルメ',   'イタズラっ子', 'きゅ～ぴっど'
    );

    my @roleshortname = ( 'お', '村', '狼', '占', '霊', '狂', '狩', '共', 'ハ', 'Ｃ', '痕', '信', '鳴', 'フ', '逆', 'グ', 'イ', 'き' );

    my @explain_role = (
        '<p>これが見えたあなたは呪われています。</p>',
        '<p>能力？　ないよ？　たーだーのーひーとー。</p>',
        '<p>あなたは悪役です。以上。<br>（おおかみ）</p>',
        '<p>あなたはエスパーです。ハンドパワーを駆使して下さい。</p>',
        '<p>あなたはイタコです。ほら、誰かの声が聞こえる……。</p>',
        '<p>あなたは人狼スキーです。好きな人狼のためにがんばりましょう。</p>',
        '<p>好きな人を守って下さい。でもストーキングは捕まらない程度に。</p>',
        '<p>あなたはラブラブです。いや夫婦です。ラブラブな人が誰かわかります。</p>',
        '<p>あなたはハムです。ボンレス？　とっとこ、とっとこ？</p>',
        '<p>パッション！　パッション！　……何か聞こえるぜええええ！<br>（人狼教神官）</p>',
        '<p>_ROLESUBID_痣はさっさと見せるように。<br>（痣持ち。痔持ちじゃないよ？）</p>',
        '<p>好きな人狼のためにがんばりまっしょい！<br>（人狼教信者）</p>',
        '<p>あなたはおしどり夫婦です。ラブラブ過ぎてむふふに会話できるので、ラブラブしといてください。</p>',
        '<p>コウモリさん！　コウモリさん！　超音波で会話しませう。</p>',
        '<p>あなたはろくでもない悪役です。余りにろくでもないのであなたを覗いたエスパーは逆恨みで死にます。<br>（逆恨み狼）</p>',
        '<p>あなたはグルメな悪役です。舌が肥えているので、平らげた相手が何者なのかわかります。<br>（グルメ）</p>',
        '<p>あなたは村中を混沌へと叩き込む事が三度の飯よりも大好きという、とても素晴らしい性格の持ち主です。誠心誠意を持って、村のために混乱を招きましょう。うへへへへへ☆<br>（イタズラっ子）</p>',
        '<p>あなたはきゅ～ぴっどです。頑張ってね。'
    );

    my %explain_roles = (
        prologue  => '_SELROLE_になりたいらしいが、希望が通らなくても苦情は受け付けない。',
        noselrole => '_SELROLE_になりたいらしいが、そんなものは無視する。',
        dead      => 'あんたは_ROLE_やったらしいが、死んぢまったらみんな同じや。',
        epilogue  => '_SELROLE_を希望して_ROLE_だった。希望通りでなくても暴れてはいけない。',
        explain   => \@explain_role,
    );

    my @votelabels = ( '抹殺', '委託', );

    my @caption_rolesay = (
        '',          # 未定義
        '',          # 村人
        '蠢き',        # 人狼
        '',          # 占い師
        '',          # 霊能者/霊媒師
        '',          # 狂人
        '',          # 狩人/守護者
        '',          # 共有者/結社員
        '',          # ハムスター人間/妖魔/妖狐
        '蠢き',        # Ｃ国狂人
        '',          # 聖痕者
        '',          # 狂信者
        '電話',        # 共鳴者
        '電波',        # コウモリ人間
        '蠢き',        # 逆恨み狼
        '蠢き',        # グルメ
        '',          # イタズラっ子
        '愛のささやき',    # キューピッド、ただし恋人同士の囁きとして使われる
    );

    my @abi_role = (
        '',          # 未定義
        '',          # 村人
        '食事',        # 人狼
        '透視',        # 占い師
        '',          # 霊能者/霊媒師
        '',          # 狂人
        '張り付く',      # 狩人/守護者
        '',          # 共有者/結社員
        '',          # ハムスター人間/妖魔/妖狐
        '',          # Ｃ国狂人
        '',          # 聖痕者
        '',          # 狂信者
        '',          # 共鳴者
        '',          # コウモリ人間
        '食事',        # 逆恨み狼
        '品評',        # グルメ
        '弄ぶ',        # イタズラっ子
        '結ぶ',        # きゅ～ぴっど
    );

    # 聖痕者の色
    # 五人揃っている所を見てみたい（おい
    my @stigma_subid = ( '赤の', '青の', '黄の', '緑の', '桃の', );

    my @result_seer = ( '_NAME_ は_RESULT_だった……ような気がする。', '白', '【黒】', );

    # 配分表名称
    my %caption_roletable = (
        default => 'ふつー',
        hamster => 'ハムハム',
        wbbs_c  => '囁けます',
        test1st => '壱型？',
        test2nd => '多分弐型',
        wbbs_g  => 'じーこく',
        custom  => 'ごった煮',
    );

    my @actions = (
        'をハリセンで殴った。',       'をパソコンで殴った。',      'を鋼鉄製ハリセンで殴った。', 'をセラミックハリセンで殴った。',
        'をオリハルコンハリセンで殴った。', 'をぶっ飛ばした。',        'にあっかんべーをした。',   'に手を振った。',
        'の頭を撫でた。',          'を襲ってみた。',         'を慰める振りをした。',    'に求愛した。',
        'にむぎゅうした。',         'に飴玉をぶん投げる振りをした。', 'におじぎした。',
    );

    my %textrs = (
        CAPTION => '適当系',

        # ダミーキャラの参加表示（○○がやってきました）の有無
        NPCENTRYMES => 1,

        # 公開アナウンス
        ANNOUNCE_EXTENSION  => '人足りねえから延ばしてやったぞ。つーか勧誘してこいよ。',
        ENTRYMES            => '_NAME_ がきたらしいよ（_NO_人目……だったかなあ？）。',
        EXITMES             => '_NAME_ が出て行ったらしいよ。',
        SUDDENDEATH         => '_NAME_ は、ぶっ倒れた。',
        SUICIDEBONDS        => '_NAME_ は _TARGET_ の巻き添えを食った。',
        SUICIDELOVERS       => '_NAME_ は _TARGET_ との赤い糸の切断に失敗したようだ。',
        ANNOUNCE_RANDOMVOTE => 'ごく適当に',
        ANNOUNCE_VICTORY    => '_VICTORY_側の勝利です！<br>',
        ANNOUNCE_EPILOGUE   => '_AVICTORY_全てのログとユーザー名を公開します。_DATE_ まで自由に書き込めますので、今回の感想などをどうぞ。',

        # 能力関連
        UNDEFTARGET      => '他人任せ',
        RANDOMTARGET     => '誰でもいい',
        RANDOMROLE       => 'てけとー',                                                      # 役職ランダム希望
        NOSELROLE        => '役職希望？　そんなものは知らんな。',
        SETRANDOMROLE    => '運命の神はめんどくさそうに _NAME_ の役職希望を _SELROLE_ に決めた。',
        SETRANDOMTARGET  => '_NAME_ は能力（_ABILITY_）の対象決定を天に任せた。天はいい加減に _TARGET_ に決めた。',
        CANCELTARGET     => '_NAME_ の _ABILITY_、誰を入れろっちゅーねん。誰もおらんやんけ。',
        EXECUTESEER      => '_NAME_ は、_TARGET_ を覗き込んだ。',
        EXECUTEKILL      => '堕ちろ _TARGET_！',
        EXECUTEGUARD     => '_NAME_ は、_TARGET_ に張り付いている。',
        EXECUTETRICKSTER => '_NAME_ は、_TARGET1_ と _TARGET2_ をどうしようもない呪いにかけた。うへへへへ。',
        EXECUTECUPID     => '_NAME_ は、_TARGET1_ と _TARGET2_ を愛の絆で結んだ。',
        RESULT_GUARD     => '_TARGET_ をライバルの襲撃から守り抜いた。',
        RESULT_KILL      => '_TARGET_ を叩き殺した。',
        RESULT_KILLIW    => '_TARGET_ をおいしく頂いた（こいつは _ROLE_ だったらしい）。',
        RESULT_FM        => '_ROLE_ のお相手は、_TARGET_ だぜ！',
        RESULT_FANATIC   => '_NAME_ が愛しの人狼様なのですね！',
        MARK_BONDS       => '絆',
        RESULT_BONDS     => 'あなたは _TARGET_ との呪いにかけられた（らしい）。（運命の絆）',
        MARK_LOVERS      => '恋人',
        RESULT_LOVERS    => 'あなたは _TARGET_ と不倫の関係です（嘘）。（恋人）',

        RANDOMENTRUST => 'ごく適当に',

        # アクション関連
        ACTIONS_ADDPT     => 'に飴玉をぶん投げた。_REST_',
        ACTIONS_RESTADDPT => '(残_POINT_回)',
        ACTIONS_BOOKMARK  => 'ここまで読んだつもりになった。',

        # 操作ログ関連
        ANNOUNCE_SELROLE       => '_NAME_ は _SELROLE_ になれるよう、天に祈った。',
        ANNOUNCE_CHANGESELROLE => '_NAME_は、希望を _SELROLE_ に変更しました（他の人には見えません）。',
        ANNOUNCE_SETVOTE       => 'せっかくだから、_NAME_ は _TARGET_ に投票するぜ！',
        ANNOUNCE_SETENTRUST    => 'めんどくさい。<br><br>めんどくさいから、_NAME_ は _TARGET_ に投票任せた！',
        ANNOUNCE_SETTARGET     => '_NAME_ は、なんとなく _TARGET_ を能力（_ABILITY_）の対象に選んでみた。',

        BUTTONLABEL_PC  => '_BUTTON_ / 更新',
        BUTTONLABEL_MB  => '_BUTTON_',
        CAPTION_SAY_PC  => '言う',
        CAPTION_SAY_MB  => '言う',
        CAPTION_TSAY_PC => '寝言',
        CAPTION_TSAY_MB => '寝言',
        CAPTION_GSAY_PC => '騒ぐ',
        CAPTION_GSAY_MB => '騒ぐ',
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
