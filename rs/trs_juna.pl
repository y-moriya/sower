package SWTextRS_juna;

sub GetTextRS {

    # プロローグ〜二日目の開始時メッセージ
    my @announce_first = (
        '　村は数十年来の大事件に騒然としていた。<br>　夜な夜な人を襲うという人狼が、人間の振りをしてこの村にも潜んでいるという噂が流れ始めたからだ。<br><br>　そして今日、村にいた全ての人々が集会場に集められた……。',
        '　集会場は不信と不安がない交ぜになった奇妙な空気に満たされていた。<br><br>　人狼なんて本当にいるのだろうか。<br>　もしいるとすれば、あの旅のよそ者か。まさか、以前からの住人であるあいつが……',
'　……そして、その日、村には新たなルールが付け加えられた。<br>　見分けの付かない人狼を排するため、1日1人ずつ疑わしい者を処刑する。誰を処刑するかは全員の投票によって決める……<br>　無辜の者も犠牲になるが、やむを得ない……<br><br>　そして、人間と人狼の暗く静かな戦いが始まった。',
    );

    # 役職配分のお知らせ
    my @announce_role = ( 'どうやらこの中には、_ROLE_含まれているようだ。', 'が', '人', '、', );

    # 生存者のお知らせ
    my @announce_lives = ( '現在の生存者は、', '、', 'の_LIVES_名。', );

    # 処刑時のお知らせ
    my @announce_vote = ( '_NAME_ は _TARGET_ に投票した_RANDOM_', '_NAME_ に _COUNT_人が投票した', '_NAME_ は村人の手により処刑された……' );

    # 委任投票のお知らせ
    my @announce_entrust =
      ( '_NAME_は_TARGET_に投票を委任しています。_RANDOM_', '_NAME_は_TARGET_に投票を委任しようとしましたが、解決不能でした。_RANDOM_', );

    # コミット
    my @announce_commit = ( '_NAME_が「時間を進める」を取り消しました', '_NAME_が「時間を進める」を選択しました', );

    # コミット状況
    my @announce_totalcommit = (
        '「時間を進める」を選択している人はいないか、まだ少ないようです。',        # 0〜1/3の時
        '「時間を進める」を選択している人は全体の1/3から2/3の間のようです。',    # 1/3〜2/3の時
        '多数の人が「時間を進める」を選択していますが、全員ではないようです。',      # 2/3〜n-1の時
        '全員が「時間を進める」を選択しています。',                    # 全員コミット済み
    );

    # 襲撃結果メッセージ
    my @announce_kill = ( '今日は犠牲者がいないようだ。人狼は襲撃に失敗したのだろうか？', '次の日の朝、_TARGET_ が無残な姿で発見された。', );

    # 勝敗メッセージ
    my @announce_winner = (
        '次の日の朝、住人全てが忽然と姿を消した。',
        '全ての人狼を退治した……。人間が人狼に勝利したのだ！',
        'もう人狼に立ち向かえるだけの人間は残っていない……<br>人狼は残った人間を全て食い尽くすと、新たな獲物を求めて去って行った……',
        '全ての人狼を退治した……。<br>だが、勝利に沸き立つ人々は、妖魔という真の勝利者に、最後まで気付くことはなかった……',
        'その時、人狼は勝利を確信し、そして初めて過ちに気づいた。<br>しかし、天敵たる妖魔を討ち漏らした人狼には、最早なすすべがなかった……',
        '愛の嵐が吹き荒れる……。<br>人は、愛の前にはこんなにも無力なのだ……。',
    );

    # 勝利者
    my @caption_winner = ( '', '村人', '人狼', '妖魔', '妖魔', '恋人' );

    # 役職名
    my @rolename = (
        'おまかせ', '村人',  '人狼',  '占い師', '霊能者', '狂人', '守護者',  '結社員', '妖魔', '囁き狂人',
        '聖痕者',  '狂信者', '共鳴者', '天魔',  '呪狼',  '智狼', '悪戯妖精', 'キューピッド'
    );

    # 役職名（省略時）
    my @roleshortname = ( 'お', '村', '狼', '占', '霊', '狂', '守', '結', '妖', '囁', '痕', '信', '鳴', '天', '呪', '智', '悪', 'キ' );

    # 役職の説明
    my @explain_role = (
        '<p>あなたは、未定義の役職です。</p>',
        '<p>あなたは村人です。<br>特殊な能力はもっていません。<br>村人の数が人狼以下になるまでに人狼と妖魔が全滅すれば勝利です。<br>ただし、人狼を全滅させた時点で妖魔が生き残っていると敗北になります。</p>',
'<p>あなたは人狼です。<br>毎夜、人狼全員で一人だけ村人を殺害することが出来ます。<br>また、人狼（と囁き狂人）同士にしか聞こえない会話が可能です。<br>村人(妖魔を除く)の数を人狼と同数以下まで減らせば勝利です。<br>ただし、最後まで妖魔が生き残っていると敗北になります。</p>',
'<p>あなたは占い師です。<br>毎夜、村人一人について占うことで、その村人が人間か人狼か判別出来ます。<br>また、妖魔を占いの対象とすることで呪殺することが出来ます。<br>村人の数が人狼以下になるまでに人狼と妖魔が全滅すれば勝利です。<br>ただし、人狼を全滅させた時点で妖魔が生き残っていると敗北になります。</p>',
'<p>あなたは霊能者です。<br>処刑などで死んだ者が、人狼であったか人間であったかを判別出来ます。<br>村人の数が人狼以下になるまでに人狼と妖魔が全滅すれば勝利です。<br>ただし、人狼を全滅させた時点で妖魔が生き残っていると敗北になります。</p>',
'<p>あなたは狂人です。<br>人狼側の人間です。人狼の勝利が狂人の勝利となります。<br>勝利条件では人間扱いで集計されるため、場合によっては狂人は敢えて死ぬ必要があります。<br>村人(妖魔を除く)の数を人狼と同数以下まで減らせば勝利です。<br>ただし、最後まで妖魔が生き残っていると敗北になります。</p>',
'<p>あなたは守護者です。<br>毎夜、一人を人狼の襲撃から守ることが出来ます。<br>自分自身を守ることは出来ません。<br>村人の数が人狼以下になるまでに人狼と妖魔が全滅すれば勝利です。<br>ただし、人狼を全滅させた時点で妖魔が生き残っていると敗北になります。</p>',
'<p>あなたは結社員です。<br>独自の人脈を持つ秘密結社の一員で、自分以外の結社員が誰か知っています。<br>村人の数が人狼以下になるまでに人狼と妖魔が全滅すれば勝利です。<br>ただし、人狼を全滅させた時点で妖魔が生き残っていると敗北になります。</p>',
'<p>あなたは妖魔です。<br>人狼に殺されることがありません。ただし、占いの対象となると死亡します。<br>霊能者には人間として判別されますが、勝利条件では村人にも人狼にも数えられません。<br>人狼が全滅するか、村人(妖魔と天魔を除く)の数が人狼と同数以下まで減るまで「生き残れば」勝利です。</p>',
'<p>あなたは囁き狂人です。<br>人狼側の人間です。人狼の勝利が狂人の勝利となります。<br>また、人狼（と囁き狂人）同士にしか聞こえない会話が可能です。<br>勝利条件では人間扱いで集計されるため、場合によっては狂人は敢えて死ぬ必要があります。<br>村人(妖魔を除く)の数を人狼と同数以下まで減らせば勝利です。<br>ただし、最後まで妖魔が生き残っていると敗北になります。</p>',
        '<p>あなたは_ROLESUBID_聖痕者です。<br>村人の数が人狼以下になるまでに人狼と妖魔が全滅すれば勝利です。<br>ただし、人狼を全滅させた時点で妖魔が生き残っていると敗北になります。</p>',
'<p>あなたは狂信者です。<br>人狼側の人間です。人狼の勝利が狂人の勝利となります。<br>人狼にはあなたの正体はわかりませんが、あなたは人狼が誰か知っています。<br>勝利条件では人間扱いで集計されるため、場合によっては狂人は敢えて死ぬ必要があります。<br>村人(妖魔を除く)の数を人狼と同数以下まで減らせば勝利です。<br>ただし、最後まで妖魔が生き残っていると敗北になります。</p>',
'<p>あなたは共鳴者です。<br>あなたは自分以外の共鳴者が誰か知っています。<br>また、共鳴者同士にしか聞こえない会話が可能です。<br>村人の数が人狼以下になるまでに人狼と妖魔が全滅すれば勝利です。<br>ただし、人狼を全滅させた時点で妖魔が生き残っていると敗北になります。</p>',
'<p>あなたは天魔です。<br>人狼に殺されることがありません。ただし、占いの対象となると死亡します。<br>また、天魔同士にしか聞こえない会話が可能です。<br>霊能者には人間として判別されますが、勝利条件では村人にも人狼にも数えられません。<br>人狼が全滅するか、村人(妖魔と天魔と悪戯妖精を除く)の数が人狼と同数以下まで減るまで「生き残れば」勝利です。</p>',
'<p>あなたは呪狼です。特殊な能力を持つ人狼です。<br>毎夜、人狼全員で一人だけ村人を殺害することが出来ます。<br>また、人狼（と囁き狂人）同士にしか聞こえない会話が可能です。<br>あなたを占った占い師は死亡します。<br>村人(妖魔を除く)の数を人狼と同数以下まで減らせば勝利です。<br>ただし、最後まで妖魔が生き残っていると敗北になります。</p>',
'<p>あなたは智狼です。特殊な能力を持つ人狼です。<br>毎夜、人狼全員で一人だけ村人を殺害することが出来ます。<br>また、人狼（と囁き狂人）同士にしか聞こえない会話が可能です。<br>あなたは殺害した相手の役職がわかります。<br>村人(妖魔を除く)の数を人狼と同数以下まで減らせば勝利です。<br>ただし、最後まで妖魔が生き残っていると敗北になります。</p>',
'<p>あなたは悪戯妖精です。<br>人狼に殺されることがありません。ただし、占いの対象となると死亡します。<br>霊能者には人間として判別されますが、勝利条件では村人にも人狼にも数えられません。<br>悪戯妖精は１日目、好きな二人に“運命の絆”を結びつける事ができます。“運命の絆”を結んだ人は、片方が死亡すると後を追って死亡します。<br>人狼が全滅するか、村人(妖魔と天魔と悪戯妖精を除く)の数が人狼と同数以下まで減るまで「生き残れば」勝利です。</p>',
'<p>あなたはキューピッドです。</p><p>キューピッドは１日目、好きな二人に“運命の絆”を結びつける事ができます。“運命の絆”を結んだ人は、片方が死亡すると後を追って死亡します。</p><p>結びつけた二人が生き延びれば、あなたの勝利となります。あなたにその絆が結ばれていない限り、あなた自身の死は勝敗には直接関係しません。</p><p>また、あなたは、勝利判定では人間として数えられます。</p><br><p><b>恋人陣営</b></p><p>恋人達だけが生き残る、もしくはいずこかの陣営が勝利を手にしたとき、絆の恋人達が生存していれば勝利です。</p>'
    );

    # 役職希望
    my %explain_roles = (
        prologue  => 'あなたは_SELROLE_を希望しています。ただし、希望した通りの能力者になれるとは限りません。',
        noselrole => 'あなたは_SELROLE_を希望していますが、希望は無効です。',
        dead      => 'あなたは_ROLE_です。',
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
        '',          # 悪戯妖精
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
        '',          # 天魔
        '襲う',        # 呪狼
        '襲う',        # 智狼
        '結ぶ',        # 悪戯妖精
        '結ぶ',        # キューピッド
    );

    # 聖痕者の色
    # 五人揃っている所を見てみたい（おい
    # 人数を変える時は、設定ファイルの MAXCOUNT_STIGMA を変える事。
    my @stigma_subid = ( '赤の', '青の', '黄の', '緑の', '桃の', );

    # 占い結果
    my @result_seer = ( '_NAME_は _RESULT_ のようだ。', '人間', '【人狼】', );

    # 配分表名称
    my %caption_roletable = (
        default => '標準',
        hamster => '妖魔有り',
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
        CAPTION => '人狼審問',

        # ダミーキャラの参加表示（○○がやってきました）の有無
        NPCENTRYMES => 0,

        # 公開アナウンス
        ANNOUNCE_EXTENSION  => '定員に達しなかったため、村の更新日時が24時間延長されました。',
        ENTRYMES            => '_NAME_ が参加しました。',
        EXITMES             => '_NAME_がいたような気がしたが、気のせいだったようだ……(_NAME_は村を出ました)',
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

        # ボタンのラベル
        BUTTONLABEL_PC  => '_BUTTON_',
        BUTTONLABEL_MB  => '_BUTTON_',
        CAPTION_SAY_PC  => '発言',
        CAPTION_SAY_MB  => '発言',
        CAPTION_TSAY_PC => '独り言',
        CAPTION_TSAY_MB => '独り言',
        CAPTION_GSAY_PC => '呻き',
        CAPTION_GSAY_MB => '呻き',
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
    return \%textrs;
}

1;
