package SWTextRS_wbbs;

sub GetTextRS {

    # プロローグ〜２日目の開始時メッセージ
    my @announce_first = (
        '昼間は人間のふりをして、夜に正体を現すという人狼。<br>その人狼が、この村に紛れ込んでいるという噂が広がった。<br><br>村人達は半信半疑ながらも、村はずれの宿に集められることになった。',
'さあ、自らの姿を鏡に映してみよう。<br>そこに映るのはただの村人か、それとも血に飢えた人狼か。<br><br>例え人狼でも、多人数で立ち向かえば怖くはない。<br>問題は、だれが人狼なのかという事だ。<br>占い師の能力を持つ人間ならば、それを見破れるだろう。',
'ついに犠牲者が出た。人狼はこの村人達のなかにいる。<br>しかし、それを見分ける手段はない。<br><br>村人達は、疑わしい者を排除するため、投票を行う事にした。<br>無実の犠牲者が出るのもやむをえない。村が全滅するよりは……。<br><br>最後まで残るのは村人か、それとも人狼か。',
    );

    # 役職配分のお知らせ
    my @announce_role = ( 'どうやらこの中には、_ROLE_いるようだ。', 'が', '名', '、', );

    # 生存者のお知らせ
    my @announce_lives = ( '現在の生存者は、', '、', ' の _LIVES_ 名。', );

    # 処刑時のお知らせ
    my @announce_vote = ( '_NAME_ は _TARGET_ に投票した。_RANDOM_', '_NAME_ に _COUNT_人が投票した。', '_NAME_ は村人達の手により処刑された。' );

    # 委任投票のお知らせ
    my @announce_entrust =
      ( '_NAME_は_TARGET_に投票を委任しています。_RANDOM_', '_NAME_は_TARGET_に投票を委任しようとしましたが、解決不能でした。_RANDOM_', );

    # コミット
    my @announce_commit = ( '_NAME_が「時間を進める」を取り消しました。', '_NAME_が「時間を進める」を選択しました。', );

    # コミット状況
    my @announce_totalcommit = (
        '「時間を進める」を選択している人はいないか、まだ少ないようです。',        # 0〜1/3の時
        '「時間を進める」を選択している人は全体の1/3から2/3の間のようです。',    # 1/3〜2/3の時
        '多数の人が「時間を進める」を選択していますが、全員ではないようです。',      # 2/3〜n-1の時
        '全員が「時間を進める」を選択しています。',                    # 全員コミット済み
    );

    # 襲撃結果メッセージ
    my @announce_kill = ( '今日は犠牲者がいないようだ。人狼は襲撃に失敗したのだろうか。', '次の日の朝、_TARGET_ が無残な姿で発見された。', );

    # 勝敗メッセージ
    my @announce_winner = (
        '次の日の朝、住人全てが忽然と姿を消した。',                                           '全ての人狼を退治した……。人狼に怯える日々は去ったのだ！',
        'もう人狼に抵抗できるほど村人は残っていない……。<br>人狼は残った村人を全て食らい、別の獲物を求めてこの村を去っていった。', '全ては終わったかのように見えた。<br>だが、奴が生き残っていた……。',
        '全ては終わったかのように見えた。<br>だが、奴が生き残っていた……。',                            '愛の嵐が吹き荒れる……。<br>人は、愛の前にはこんなにも無力なのだ……。',
    );

    # 勝利者
    my @caption_winner = ( '', '村人', '人狼', '小動物', '小動物', '恋人' );

    # 役職名
    my @rolename = (
        'おまかせ', '村人',  '人狼',  '占い師',    '霊能者', '狂人', '狩人',   '共有者', 'ハムスター人間', 'Ｃ国狂人',
        '聖痕者',  '狂信者', '共鳴者', 'コウモリ人間', '呪狼',  '智狼', 'ピクシー', 'キューピッド'
    );

    # 役職名（省略時）
    my @roleshortname = ( 'お', '村', '狼', '占', '霊', '狂', '狩', '共', 'ハ', 'Ｃ', '痕', '信', '鳴', '傘', '呪', '智', 'ピ', 'キ' );

    # 役職の説明
    my @explain_role = (
        '<p>あなたは、未定義の役職です。</p>',
        '<p>あなたは、ただの村人です。しかしあなたの推理力や発言が、村人側の勝利の鍵となるとかもしれません。</p>',
'<p>あなたは人狼です。村人を人狼と同数まで減らせば勝利です。村人に悟られないように慎重に邪魔者を排除していきましょう。</p><p>「人狼のささやき」は人狼（とＣ国狂人）にしか聞こえません。仲間との連絡にご利用ください。</p>',
        '<p>あなたは占い師です。毎夜、誰かひとりを占うことができます。それにより、相手が人狼か人間かを知ることができます。</p>',
        '<p>あなたは霊能者です。処刑によって命を失ったものが、人間であったか人狼であったかを知ることができます。</p>',
        '<p>あなたは狂人です。人狼側の勝利を望んでいます。よって、人狼側の勝利があなたの勝利となります。</p><p>人狼側の勝利のため、存分に議論をかきまわして下さい。</p>',
        '<p>あなたは狩人です。毎夜、ひとりだけを、人狼の襲撃から守る事ができます。人狼の行動を読み、村人達を人狼から守って下さい。</p>',
        '<p>あなたは共有者です。他の共有者が誰であるかを知る事ができます。</p>',
'<p>あなたはハムスター人間です。村人側にも人狼側にも属さない孤高の存在です。村人側か人狼側が勝利条件を満たした時にあなたが生き延びていれば、あなたの勝ちとなります。<br>誰にも正体を知られないよう、狡猾に行動して下さい。</p><p>ハムスター人間は人狼に襲撃されません。ハムスター人間は占われると死亡します。</p>',
'<p>あなたはＣ国狂人です。人狼側の勝利を望んでいます。よって、人狼側の勝利があなたの勝利となります。</p><p>人狼側の勝利のため、存分に議論をかきまわして下さい。</p><p>「人狼のささやき」は人狼とＣ国狂人にしか聞こえません。仲間との連絡にご利用ください。</p>',
        '<p>あなたは_ROLESUBID_聖痕者です。</p>',
'<p>あなたは狂信者です。人狼側の勝利を望んでいます。よって、人狼側の勝利があなたの勝利となります。</p><p>人狼側の勝利のため、存分に議論をかきまわして下さい。</p><p>狂信者には人狼が誰かわかります。</p>',
        '<p>あなたは共鳴者です。他の共鳴者が誰であるかを知る事ができます。</p><p>「共鳴」は共鳴者にしか聞こえません。仲間との連絡にご利用ください。</p>',
'<p>あなたはコウモリ人間です。村人側にも人狼側にも属さず、ハムスター人間と同陣営になります。村人側か人狼側が勝利条件を満たした時にハムスター人間かコウモリ人間が生き延びていれば、あなたの勝ちとなります。</p><p>ハムスター人間は人狼に襲撃されません。ハムスター人間は占われると死亡します。</p><p>「念話」はコウモリ人間にしか聞こえません。仲間との連絡にご利用ください。</p>',
'<p>あなたは呪狼です。村人を人狼と同数まで減らせば勝利です。村人に悟られないように慎重に邪魔者を排除していきましょう。あなたを占った占い師は死亡します。</p><p>「人狼のささやき」は人狼（とＣ国狂人）にしか聞こえません。仲間との連絡にご利用ください。</p>',
'<p>あなたは智狼です。村人を人狼と同数まで減らせば勝利です。村人に悟られないように慎重に邪魔者を排除していきましょう。あなたは殺害した相手の役職がわかります。</p><p>「人狼のささやき」は人狼（とＣ国狂人）にしか聞こえません。仲間との連絡にご利用ください。</p>',
'<p>あなたはピクシーです。村人側にも人狼側にも属さず、ハムスター人間と同陣営になります。村人側か人狼側が勝利条件を満たした時にハムスター人間かコウモリ人間かピクシーが生き延びていれば、あなたの勝ちとなります。</p><p>ピクシーは人狼に襲撃されても死にません。ピクシーは占われると死亡します。</p><p>ピクシーは１日目、好きな二人に“運命の絆”を結びつける事ができます。“運命の絆”を結んだ人は、片方が死亡すると後を追うように死亡します。</p>',
'<p>あなたはキューピッドです。</p><p>キューピッドは１日目、好きな二人に“運命の絆”を結びつける事ができます。“運命の絆”を結んだ人は、片方が死亡すると後を追って死亡します。</p><p>結びつけた二人が生き延びれば、あなたの勝利となります。あなたにその絆が結ばれていない限り、あなた自身の死は勝敗には直接関係しません。</p><p>また、あなたは、勝利判定では人間として数えられます。</p><br><p><b>恋人陣営</b></p><p>恋人達だけが生き残る、もしくはいずこかの陣営が勝利を手にしたとき、絆の恋人達が生存していれば勝利です。</p>'
    );

    # 役職希望
    my %explain_roles = (
        prologue  => 'あなたは_SELROLE_を希望しています。ただし、希望した通りの能力者になれるとは限りません。',
        noselrole => 'あなたは_SELROLE_を希望していますが、希望は無効です。',
        dead      => 'あなたは_ROLE_でしたが、死亡しています。',
        epilogue  => 'あなたは_ROLE_でした（_SELROLE_を希望）。',
        explain   => \@explain_role,
    );

    # 投票欄表示
    my @votelabels = ( '投票', '委任', );

    # 能力者用特殊発言欄のラベル
    my @caption_rolesay = (
        '',          # 未定義
        '',          # 村人
        '囁き',        # 人狼
        '',          # 占い師
        '',          # 霊能者/霊媒師
        '',          # 狂人
        '',          # 狩人/守護者
        '',          # 共有者/結社員
        '',          # ハムスター人間/妖魔/妖狐
        '囁き',        # Ｃ国狂人
        '',          # 聖痕者
        '',          # 狂信者
        '共鳴',        # 共鳴者
        '念話',        # コウモリ人間
        '囁き',        # 呪狼
        '囁き',        # 智狼
        '',          # ピクシー
        '愛のささやき',    # キューピッド、ただし恋人同士の囁きとして使われる
    );

    # 能力名
    my @abi_role = (
        '',          # 未定義
        '',          # 村人
        '襲う',        # 人狼
        '占う',        # 占い師
        '',          # 霊能者/霊媒師
        '',          # 狂人
        '守る',        # 狩人/守護者
        '',          # 共有者/結社員
        '',          # ハムスター人間/妖魔/妖狐
        '',          # Ｃ国狂人
        '',          # 聖痕者
        '',          # 狂信者
        '',          # 共鳴者
        '',          # コウモリ人間
        '襲う',        # 呪狼
        '襲う',        # 智狼
        '結ぶ',        # ピクシー
        '結ぶ',        # キューピッド
    );

    # 聖痕者の色
    # 五人揃っている所を見てみたい（おい
    # 人数を変える時は、設定ファイルの MAXCOUNT_STIGMA を変える事。
    my @stigma_subid = ( '赤の', '青の', '黄の', '緑の', '桃の', );

    # 占い結果
    my @result_seer = ( '_NAME_ は _RESULT_ のようだ。', '人間', '【人狼】', );

    # 配分表名称
    my %caption_roletable = (
        default => '標準',
        hamster => 'ハム入り',
        wbbs_c  => 'Ｃ国',
        test1st => '試験壱型',
        test2nd => '試験弐型',
        wbbs_g  => 'Ｇ国',
        custom  => '自由設定',
    );

    # アクション
    my @actions = (
        'に相づちを打った。',  'に頷いた。',  'に首を傾げた。',    'をじっと見つめた。', 'を信頼の目で見た。',   'を怪訝そうに見た。',
        'を不信の目で見た。',  'を指さした。', 'をつんつんつついた。', 'に驚いた。',     'に困惑した。',      'にうろたえた。',
        'に怯えた。',      'に照れた。',  'にお辞儀をした。',   'に手を振った。',   'に微笑んだ。',      'に拍手した。',
        'を支持した。',     'を慰めた。',  'に別れを告げた。',   'を抱きしめた。',   'を小一時間問いつめた。', 'をハリセンで殴った。',
        'への前言を撤回した。', 'に感謝した。',
    );

    my %textrs = (
        CAPTION => '人狼BBS',

        # ダミーキャラの参加表示（○○がやってきました）の有無
        NPCENTRYMES => 1,

        # 公開アナウンス
        ANNOUNCE_EXTENSION  => '定員に達しなかったため、村の更新日時が24時間延長されました。',
        ENTRYMES            => '_NO_人目、_NAME_ がやってきました。',
        EXITMES             => '_NAME_が村を出て行きました。',
        SUDDENDEATH         => '_NAME_ は、突然死した。',
        SUICIDEBONDS        => '_NAME_ は絆に引きずられるように _TARGET_ の後を追った。',
        SUICIDELOVERS       => '_NAME_ は哀しみに暮れて _TARGET_ の後を追った。',
        ANNOUNCE_RANDOMVOTE => '(ランダム投票)',
        ANNOUNCE_VICTORY    => '_VICTORY_側の勝利です！<br>',
        ANNOUNCE_EPILOGUE   => '_AVICTORY_全てのログとユーザー名を公開します。_DATE_ まで自由に書き込めますので、今回の感想などをどうぞ。',

        RANDOMENTRUST => '(ランダム委任)',

        # 能力関連
        UNDEFTARGET      => 'おまかせ',
        RANDOMTARGET     => 'ランダム',
        RANDOMROLE       => 'ランダム',                                             # 役職ランダム希望
        NOSELROLE        => '村の設定が「役職希望無視」のため、全ての役職希望が無視されます。',
        SETRANDOMROLE    => '_NAME_ の役職希望が _SELROLE_ に自動決定されました。',
        SETRANDOMTARGET  => '_NAME_ の能力（_ABILITY_）の対象が _TARGET_ に自動決定されました。',
        CANCELTARGET     => '_NAME_ の能力（_ABILITY_）に有効な対象がありませんでした。',
        EXECUTESEER      => '_NAME_ は、_TARGET_ を占った。',
        EXECUTEKILL      => '_TARGET_！ 今日がお前の命日だ！',
        EXECUTEGUARD     => '_NAME_ は、_TARGET_ を守っている。',
        EXECUTETRICKSTER => '_NAME_ は、_TARGET1_ と _TARGET2_ との間に運命の絆を結んだ。',
        EXECUTECUPID     => '_NAME_ は、_TARGET1_ と _TARGET2_ を愛の絆で結んだ。',
        RESULT_GUARD     => '_TARGET_ を人狼の襲撃から守った。',
        RESULT_KILL      => '_TARGET_ を殺害した。',
        RESULT_KILLIW    => '_TARGET_ を殺害した（_TARGET_ は _ROLE_ だったようだ）。',
        RESULT_FM        => 'もう一人の_ROLE_は、_TARGET_ です。',
        RESULT_FANATIC   => '_NAME_ は 人狼 のようだ。',
        MARK_BONDS       => '絆',
        RESULT_BONDS     => 'あなたは _TARGET_ と運命の絆を結んでいます。',
        MARK_LOVERS      => '恋人',
        RESULT_LOVERS    => 'あなたは _TARGET_ と愛し合っています。',

        # アクション関連
        ACTIONS_ADDPT     => 'に話の続きを促した。_REST_',
        ACTIONS_RESTADDPT => '(残_POINT_回)',
        ACTIONS_BOOKMARK  => 'ここまで読んだ。',

        # 操作ログ関連
        ANNOUNCE_SELROLE       => '_NAME_は、_SELROLE_ を希望しました（他の人には見えません）。',
        ANNOUNCE_CHANGESELROLE => '_NAME_は、希望を _SELROLE_ に変更しました（他の人には見えません）。',
        ANNOUNCE_SETVOTE       => '_NAME_は、_TARGET_ を投票先に選びました。',
        ANNOUNCE_SETENTRUST    => '投票を委任します。<br><br>_NAME_は、_TARGET_ に投票を委任しました。',
        ANNOUNCE_SETTARGET     => '_NAME_は、_TARGET_ を能力（_ABILITY_）の対象に選びました。',
        ANNOUNCE_EDITJOB       => '_OLDNAME_は、名前を _NEWNAME_ に変更しました。',

        BUTTONLABEL_PC  => '_BUTTON_ / 更新',
        CAPTION_SAY_PC  => '発言',
        CAPTION_TSAY_PC => '独り言',
        CAPTION_GSAY_PC => '死者のうめき',
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
