package SWDocSpec;

#----------------------------------------
# 仕様FAQ
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
    my ( $class, $sow ) = @_;
    my $self = {
        sow   => $sow,
        title => "他の人狼クローンとの違い（仕様FAQ）",    # タイトル
    };

    return bless( $self, $class );
}

#----------------------------------------
# 仕様FAQの表示
#----------------------------------------
sub outhtml {
    my $self   = shift;
    my $sow    = $self->{'sow'};
    my $net    = $sow->{'html'}->{'net'};      # Null End Tag
    my $atr_id = $sow->{'html'}->{'atr_id'};

    print <<"_HTML_";
<h2>他の人狼クローンとの違い（仕様FAQ）</h2>
<p class="paragraph">
※ここでは人狼クローンによって名前の異なる役職について、以下のように表\記します。
</p>
<ul>
  <li>狩人／守護者 → 狩人</li>
  <li>共有者／結社員 → 共有者</li>
  <li>ハムスター人間／妖魔／妖狐 → ハムスター人間</li>
</ul>
<hr class="invisible_hr"$net>

<h3>目次</h3>
<ul>
  <li><a href="#diff_wbbs">人狼BBSとの大まかな違い</a></li>
  <li><a href="#diff_juna">人狼審問との大まかな違い</a></li>
  <li><a href="#update">処刑や占いなどの処理順はどうなっていますか？</a></li>
  <li><a href="#curseandkillseer">占い師がハムスター人間を占い先にした状態で襲撃された場合、ハムスター人間を呪殺できますか？</a></li>
  <li><a href="#atkhamster">ハムスター人間が襲撃対象となった場合、ハムスター人間は自分が襲撃された事がわかりますか？</a></li>
  <li><a href="#killdead">人狼が死者を襲撃対象にしていた場合、人狼には襲撃時にその人物が死んでいた事がわかりますか？</a></li>
  <li><a href="#guarded">狩人が護衛成功した場合、手応えを感じますか？</a></li>
  <li><a href="#actionbeforesay">発言をしたあと、確定する前にアクションを送信すると、アクションの方が先に確定しますか？</a></li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="diff_wbbs">人狼BBSとの大まかな違い</a></h3>
<ul>
  <li>アクション・メモ機能\が使えます。</li>
  <li>引用に便利なアンカー（>>0:0 とか）が使えます。</li>
  <li>更新の前倒し（「時間を進める」、コミットとも言う）が使えます。</li>
  <li>村が自動で生成されません。プレイヤーが自分で遊びたい村を作成してください。</li>
  <li>人狼BBSにない役職として、狂信者、聖痕者、共鳴者、コウモリ人間、呪狼、智狼、ピクシーがあります。</li>
  <li>投票方式として無記名投票方式があります（投票COができなくなります）。</li>
  <li>誰かに投票先を委任することができます。</li>
  <li>発言フィルタや携帯モードがあります。</li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="diff_juna">人狼審問との大まかな違い</a></h3>
<ul>
  <li>村が自動で生成されません。カスタム村のみです。</li>
  <li>人狼審問にない役職としてＣ国狂人、共鳴者、コウモリ人間、呪狼、智狼、ピクシーがあります。</li>
  <li>突然死通知機能\がありません（Version 2.00 Beta 7 時点）。</li>
  <li>突然死優先処刑機能\がありません（Version 2.00 Beta 7 時点）。</li>
  <li>参加方法が微妙に違います。右上で「ログイン」した後、村のページを表\示すると参加欄が表\示されます。</li>
  <li>定員にはダミーキャラ（人狼審問でいうアーヴァイン）の人数を含みます（人狼審問の15人村＝$sow->{'cfg'}->{'NAME_SW'}での16人村）。</li>
  <li>アクションの対象にダミーキャラが含まれます。</li>
  <li>占い先と処刑先が同じだった場合でも占う事ができます。</li>
  <li>占い・霊能\などの判定結果はログの上部ではなく能\力者欄（発言入力欄の下）に表\示されます。</li>
  <li>村人の多数意志による廃村はできません（Version 2.00 Beta 7時点）。</li>
  <li>「おまかせ」による意図的襲撃ミスができます。</li>
  <li>襲撃先が統一されていない場合、襲撃先は設定された襲撃先の中からランダムで選ばれます（人狼審問は多数決）。</li>
  <li>同一日24時間経過によるポイント数回復がありません。</li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="update">処刑や占いなどの処理順はどうなっていますか？</a></h3>
<p class="paragraph">
下記の通りです。
</p>

<ol>
  <li>突然死の処理</li>
  <li>ピクシー／キューピッドの能\力（運命／愛の絆）の処理</li>
  <li>委任処理</li>
  <li>処刑投票</li>
  <li>占い・呪殺</li>
  <li>襲撃先決定</li>
  <li>護衛対象決定</li>
  <li>襲撃処理</li>
  <li>勝利判定</li>
</ol>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">占い師がハムスター人間を占い先にした状態で襲撃された場合、ハムスター人間を呪殺できますか？</a></h3>
<p class="paragraph">
できます。
</p>
<p class="paragraph">
<a href="#update">更新時の処理順</a>にある通り、襲撃処理よりも呪殺判定の方が先に処理されるので、占い師が襲撃で死亡する前にハムスター人間が呪殺により死亡します。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="atkhamster">ハムスター人間が襲撃対象となった場合、ハムスター人間は自分が襲撃された事がわかりますか？</a></h3>
<p class="paragraph">
わかりません。<br$net>
ハムスター人間が襲撃されても、ハムスター人間には自分が襲われた事はわかりませんし、ハムスター人間襲撃と狩人の護衛成功との見分けも付きません。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">人狼が死者を襲撃対象にしていた場合、人狼には襲撃時にその人物が死んでいた事がわかりますか？</a></h3>
<p class="paragraph">
わかります。
</p>

<p class="paragraph">
人狼が襲撃する前に襲撃対象が死亡していた場合、襲撃がキャンセルされ襲撃メッセージ（「〜！ 今日がお前の命日だ！」）が表\示されなくなります。
</p>

<p class="paragraph">
ですので、例えば襲おうと思っていた相手が呪殺された場合、人狼はその相手がハムスター人間である事を知る事ができます。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="guarded">狩人が護衛成功した場合、手応えを感じますか？</a></h3>
<p class="paragraph">
感じます。
</p>
<p class="paragraph">
狩人は護衛に成功すると、「〜を人狼の襲撃から守った」のような一文が能\力欄に追記されます。何も追記されていなければ、人狼は狩人が護衛していた人物を襲ってこなかったという事になります。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">発言をしたあと、確定する前にアクションを送信すると、アクションの方が先に確定しますか？</a></h3>
<p class="paragraph">
いいえ、発言の方が先に確定します。
</p>

<p class="paragraph">
人狼審問ではアクションが即時確定する仕様のため、短い間隔で発言→アクションと行うとアクションが前の発言を追い抜くという現象が発生しますが、本スクリプトではそのままの順序に確定します。<br$net>
確定するまでのあいだ発言は他の人には見えませんが、確定するとアクションの前に発言が急に割り込んだような形で表\示されます。
</p>
<hr class="invisible_hr"$net>

_HTML_

}

1;
