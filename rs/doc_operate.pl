package SWDocOperate;

#----------------------------------------
# 遊び方（操作方法）
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
    my ( $class, $sow ) = @_;
    my $self = {
        sow   => $sow,
        title => '遊び方（操作方法）',    # タイトル
    };

    return bless( $self, $class );
}

#---------------------------------------------
# 遊び方（操作方法）の表示
#---------------------------------------------
sub outhtml {
    my $self   = shift;
    my $sow    = $self->{'sow'};
    my $cfg    = $sow->{'cfg'};
    my $net    = $sow->{'html'}->{'net'};      # Null End Tag
    my $atr_id = $sow->{'html'}->{'atr_id'};

    print <<"_HTML_";
<h2>遊び方（操作方法）</h2>

<ul>
  <li><a href="#say">発言・更新ボタン</a></li>
  <li><a href="#delete">発言の削除</a></li>
  <li><a href="#saycnt">発言数制限と発言数補給</a></li>
  <li><a href="#tsay">独り言</a></li>
  <li><a href="#monospace">等幅</a></li>
  <li><a href="#vote">投票</a></li>
  <li><a href="#entrust">投票先の委任</a></li>
  <li><a href="#action">アクション</a></li>
  <li><a href="#addact">話の続きを促す</a></li>
  <li><a href="#anchor">アンカー</a></li>
  <li><a href="#memo">メモ</a></li>
  <li><a href="#bookmark">しおり</a></li>
  <li><a href="#commit">時間を進める</a></li>
  <li><a href="#randomtext">ランダム表\示機能\</a></li>
  <li><a href="#filter">発言フィルタ</a></li>
  <li><a href="#makeviloption">村作成オプションの説明</a></li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="say">発言・更新ボタン</a></h3>
<p class="paragraph">
発言ボタンは発言とリロード（画面更新）を兼ねています。発言欄に何も文字が書き込まれていない時に押すとリロードとして働きます。
</p>

<p class="paragraph">
発言欄に文字を書き込んでから発言ボタンを押しても、いきなり書き込まれたりはしません。発言プレビュー画面が表\示されて、本当にその内容で書き込んで良いのか尋ねてきます。文章に間違いがないと感じたら、「書き込む」ボタンを押せば書き込まれます。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="delete">発言の削除</a></h3>
<p class="paragraph">
誤ってまずい事を発言してしまった場合でも、発言して間もない時なら発言を削除するチャンスがあります。書き込んだ直後の発言には「未確」の文字と「この発言を削除($sow->{'cfg'}->{'MESFIXTIME'}秒以内)」というボタンが表\示されていますので、$sow->{'cfg'}->{'MESFIXTIME'}秒以内にこのボタンを押せば発言を削除できます。<br$net>
</p>

<p class="paragraph">
発言が削除できるのは通常発言だけです。<a href="#tsay">独り言</a>、人狼のささやき、墓下発言などは削除できません。<br$net>
<a href="#action">アクション</a>は通常発言の一種ですが、やはり削除できません。
</p>

<p class="paragraph">
※発言が未確定の間は、その発言は自分にしか見えません。発言してから$sow->{'cfg'}->{'MESFIXTIME'}秒が経過して発言が削除できなくなってから、初めて他人にその発言が見えるようになります。<br$net>
なので、発言削除が間に合ったなら、自分以外誰もその発言を見ていません。見ていたらバグです。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="saycnt">発言数制限と発言数補給</a></h3>
<p class="paragraph">
発言は無限にできるわけではありません。村作成時に設定された「発言制限」に従って、１日にｎ回まで、またはｎポイント（pt）分までと定められています。残り発言数／ptがなくなると、発言したくても発言できなくなります。後々のことも考えながら計画的に発言するようにしましょう。
</p>

<p class="paragraph">
　★この機能\は削除されました★
　<s>村の更新間隔が48時間以上の設定だった時などで、その日が開始してから（更新されないまま）24時間が経過した場合、新たに１日分の発言数／ptが追加支給されます。更新されないまま更に24時間が経過すると更に追加支給されます。<br$net>
　例えば、23:00更新の村で２日目が2/07の18:00に始まった場合、02/08の18:00になると発言数／ptが増えます。</s>
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="tsay">独り言</a></h3>
<p class="paragraph">
発言欄には「独り言」というチェック項目があります。「独り言」にチェックを入れて発言すると、自分にだけ見える発言を書き込む事ができます。独り言は勝敗が決定してエピローグに入るまで、他の誰にも見えません。<br$net>
その時点での推理を書き留めるなり、RPのネタばらしをするなり、人狼とは全然関係ない話を書き込むなり、自由に使って下さい。
</p>
<p class="paragraph">
ただし、エピローグに入ると独り言は公開されてしまいます。あまりむやみやたらに<strong class="cautiontext">見られてはまずい事を書き込まない</strong>ようにしましょう。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="monospace">等幅</a></h3>
<p class="paragraph">
発言欄には「等幅」というチェック項目があります。「等幅」にチェックを入れて発言すると、文字の幅が等しくなるように表\示されます。<br$net>
占い・吊り先希望の集計表\を作る時などに活用して下さい。
</p>

<p class="paragraph">
※この機能\は環境依存です。チェックを付けても文字の幅がバラバラに表\示されるかもしれませんし、チェックを付けなくても文字の幅が等しくなるように表\示されるかもしれません。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="vote">投票</a></h3>
<p class="paragraph">
２日目以降では処刑先を決めるために処刑先投票を行います。<br$net>
投票先を設定するには発言欄の上部にある投票欄で行います。誰に投票をするかを選び、変更ボタンを押して下さい。<strong class="cautiontext">変更ボタンを押さなければ投票先の設定はできません</strong>。設定すると、投票先に選んだ人の名前の右に「*」印が表\示されます。
</p>

<p class="paragraph">
ちなみに、日が変わるたびに最初の投票先設定がランダムで設定されます。人狼審問などと違い、投票先未設定という状態はありません。<br$net>
また、短期系クローンと違って投票先は何度でも変更できます。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="entrust">投票先の委任</a></h3>
<p class="paragraph">
時間的都合などから、投票先の設定ができない事もあるかもしれません。そういう時、あなたは信頼できる人間に投票先を委任する事もできます。投票先を委任すると、あなたの投票先は委任した人が選んだ投票先と同じ人になります。
</p>

<p class="paragraph">
投票を委任するには、投票欄の「投票」と書かれている欄を「委任」に変え、委任したい人を選んで変更ボタンを押して下さい。「委任」の右と投票先に選んだ人の名前の右に「*」印が表\示されます。<br$net>
委任を解除したい時は、通常の投票操作を行って下さい。その際、「委任」と書かれている欄を「投票」に変えるのを忘れないように。
</p>

<p class="paragraph">
委任した相手が別の人に投票を委任していた場合、あなたとあなたが委任した相手の投票先は、委任した相手が更に委任していた人の投票先と同じになります。<br$net>
委任先が堂々巡りになっていた場合や、投票先があなた自身になっていた場合は、あなたの投票先はランダムに決定されます。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="action">アクション</a></h3>
<p class="paragraph">
ちょっとした仕草や感謝といった事を表\すために、「アクション」という簡易発言機能\が用意されています。<br$net>アクションには以下の特徴があります。
</p>
<ul>
  <li>ごく短い発言しかできない。</li>
  <li>アクション発言には、顔画像が表\示されない。</li>
  <li>アクションには<a href="#anchor">アンカー</a>を張れない。</li>
  <li>アクションは削除できない。</li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="addact">話の続きを促す</a></h3>
<p class="paragraph">
発言数には限りがあるため、聞きたい事を聞けないうちに、その人が発言できなくなってしまう事があります。そんな時、特殊なアクションである「話の続きを促した」を使う事によって、その人の発言数を少しだけ増やす事ができます。<br$net>
※この機能\を一般に「促し」と呼びます。俗に「飴」と呼ぶ事もあります。
</p>

<p class="paragraph">
促しには回数制限があり、アクションの選択肢の所で「話の続きを促した(残1回)」のように表\示されています。使い切ると促しの選択肢そのものが表\示されなくなります。<br$net>
自分に対して促す事はできません。またよく勘違いされますが、促しても自分の発言数（非アクション）が減ったりするような事はありません。この機能\は自分の発言数を分け与える機能\ではないのです。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="anchor">アンカー</a></h3>
<p class="paragraph">
発言の引用をしたい時、&gt;&gt;40 のように書く事で引用元の発言へのリンクを張る事ができます。これをアンカーと呼んでいます。<br$net>
アンカーの書式は以下の通りです（基本的に人狼BBQ四国上位互換です）。
</p>

<p class="paragraph">
「&gt;&gt;」＋「発言種別」＋「日付:」（＋「発言種別」）＋「発言番号」
</p>

<p class="paragraph">
発言番号はその発言の発言日付の前に (20) のような形で表\示されています。<strong class="cautiontext">発言番号のない発言に対してアンカーを打つ事はできません</strong>。<br$net>
発言種別は独り言、死者のうめき、人狼のささやきなどに対してアンカーを打ちたい時に使います。発言種別は発言番号の左に併記されています（例：(*30)）。<br$net>
発言種別は日付の右に書いても構\いません。
</p>

<p class="paragraph">
アンカーの例は以下の通りです。
</p>
<ul>
  <li>&gt;&gt;40 → その日の発言番号40の発言へリンクを張る。</li>
  <li>&gt;&gt;*30 → その日の発言番号30のささやき発言へリンクを張る。</li>
  <li>&gt;&gt;0:3 → プロローグの発言番号３の発言へリンクを張る。</li>
  <li>&gt;&gt;*1:13 → １日目の発言番号13のささやき発言へリンクを張る。</li>
  <li>&gt;&gt;2:+34 → ２日目の発言番号34の死者のうめき発言へリンクを張る。</li>
</ul>

<p class="paragraph">
アンカーはどの発言に対しても打てるというわけではありません。様々な制限が付いています。<br$net>
例えば、通常発言から人狼のささやきに対してアンカーを打つ事はできません。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="memo">メモ</a></h3>
<p class="paragraph">
メモは通常のログとは別に用意された伝言板のようなものです。
</p>

<p class="paragraph">
メモはメモのページにある「メモを貼\る」ボタンで貼\り付ける事ができます。<br$net>
通常のログとは違い、メモは常に（その人が貼\り付けた）最新のメモだけが表\示されます。なので、例えばここに意見のまとめ（処刑先希望など）を書いておけば、長いログからいちいち探す手間が省けます。<br$net>
以前に貼\り付けたメモは「メモ履歴」で見る事ができます。
</p>

<p class="paragraph">
メモははがす事もできます。「メモを貼\る」ボタンを押す時に、メモの入力欄を空欄にしておけばメモがはがれます。
</p>

<p class="paragraph">
メモを貼\るとアクションを一回分消費します。アクションが残っていない時はメモを貼\ったりはがしたりする事ができません。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="bookmark">しおり</a></h3>
<p class="paragraph">
特殊なアクションである「ここまで読んだ」を使うと、（標準では）太字で「〜は、ここまで読んだ」と書き込まれ、しおりとして利用できます。<br$net>
しおりは使うたびにアクションを一回分消費し、アクションを使い切ると使用できなくなります。
</p>
<p class="paragraph">
しおりは独り言などと同じで、進行中は自分にしか見えません。勝敗が決してエピローグを迎えると、全体に公開されて誰でもしおりを見る事ができるようになります。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="commit">時間を進める</a></h3>
<p class="paragraph">
事情によっては、本来の更新時間よりも前に前倒しで更新して日付を進めたい時があります。そういう場合、生存者が全員「時間を進める」事で、前倒しで更新処理が行われます。
</p>

<p class="paragraph">
時間を進めるには、発言欄の下の方に「時間を進める」欄があるので、「時間を進める」を選んで変更ボタンを押して下さい。<br$net>
通常の発言を最低一発言しないと時間を進める事はできません。独り言やアクションなどをいくら発言しても時間を進める事はできないので注意して下さい。<br$net>
また、削除された発言は一発言として含めません。
</p>

<p class="paragraph">
なお、大ざっぱにどのぐらいの人が「時間を進める」を選んでいるかは「村の情報」ページに表\示されますが、具体的に誰が時間を進めているか（いないか）は直接的にはわかりません。
</p>

<p class="paragraph">
ちなみに時間を進める事を、俗に「コミット」と呼んでいます。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="randomtext">ランダム表\示機能\</a></h3>
<p class="paragraph">
サーバ設定でランダム表\示機能\が有効になっている場合、発言に以下のキーワードが含まれていると乱数によって毎回違った内容がキーワードの代わりに表\示されます。<br$net>
ランダム表\示の内容は標準では太字になります。また、fortune 以外のキーワードには前後に特定の文字が付きます。
</p>

<div class="paragraph">
<table border="1" summary="ランダム表\示機能\一覧">
<tr>
  <th>キーワード</th>
  <th>説明</th>
  <th>例</th>
</tr>

<tr>
  <td>[[fortune]]</td>
  <td>0〜100の数値</td>
  <td>私が勝つ確率は[[fortune]]％だ！<br$net>→ 私が勝つ確率は<strong>58</strong>％だ！</td>
</tr>

<tr>
  <td>[[who]]</td>
  <td>生存中の人名</td>
  <td>占い先は[[who]]にしようぜ！<br$net>→ 占い先は<strong>&lt;&lt;少女 アニー&gt;&gt;</strong>にしようぜ！</td>
</tr>

<tr>
  <td>[[omikuji]]</td>
  <td>おみくじ</td>
  <td>今日の運勢は[[omikuji]]。<br$net>→ 今日の運勢は<strong>*大吉*</strong>。</td>
</tr>

<tr>
  <td>[[role]]</td>
  <td>役職</td>
  <td>きっと[[role]]になるだろう。<br$net>→ きっと<strong>((村人))</strong>になるだろう。</td>
</tr>

<tr>
  <td>[[1d6]]</td>
  <td>六面体サイコロを一つ振った値</td>
  <td>１ゾロ出ろ！ [[1d6]][[1d6]]<br$net>→ １ゾロ出ろ！ <strong>{6}{6}</strong></td>
</tr>

<tr>
  <td>[[1d10]]</td>
  <td>十\面体サイコロを一つ振った値</td>
  <td>一粒[[1d10]]メートル<br$net>→ 一粒<strong>(07)</strong>メートル</td>
</tr>

<tr>
  <td>[[1d20]]</td>
  <td>二十\面体サイコロを一つ振った値</td>
  <td>アニーの泳げる距離は[[1d20]]メートルに違いない。<br$net>→ アニーの泳げる距離は<strong>[03]</strong>メートルに違いない。</td>
</tr>
</table>
</div>
<hr class="invisible_hr"$net>

<h3><a $atr_id="filter">発言フィルタ</a></h3>
<p class="paragraph">
ある特定の人の発言だけを読みたい場合、発言フィルタを使えば必要のない人の発言を非表\示にすることができます。<br$net>
</p>

<p class="paragraph">
標準では村ログの一番下に「フィルタ」という欄が配置されています。<br$net>ある人の発言の表\示／非表\示を切り替えたい時は、そのフィルタの参加者の名前が表\示されている部分をクリックして下さい。クリックするたびに、その人の発言が表\示されたり非表\示になったりします。<br$net>
一気に全員分を表\示したり非表\示にしたりしたい場合は、一括操作欄のボタン（全員表\示、全員非表\示）を利用してください。
</p>
<hr class="invisible_hr"$net>

<p class="paragraph">
あなたが人狼など、秘密会話を交わせる役職になっていた場合に、秘密会話を非表\示にして通常発言のみで村ログを読みたくなることもあるでしょう。その場合には、「発言種別」欄にある「囁き／共鳴／念話」をクリックしてください。クリックするたびに秘密会話発言の表\示／非表\示を切り替えることができます。<br$net>
秘密会話発言以外でも発言種別欄でいろいろ表\示を切り替えることができます。
</p>
<hr class="invisible_hr"$net>

<p class="paragraph">
フィルタは標準では一番下に配置されていますが、「フィルタ」と書かれている部分の右にある「←」アイコンをクリックすると、フィルタを左側に配置することができます。下配置に戻すときは「↓」アイコンをクリックしてください。
</p>

<p class="paragraph">
フィルタを左に配置した場合フィルタが左側に固定され、右側の発言ログ部分をスクロールさせてもフィルタ部分は連動しないようになります。
フィルタをログ部分のスクロールに連動するようにしたい場合は、灰色の丸ピンのようなアイコンが「↓」アイコンの左にあるので、このアイコンをクリックしてください。
</p>
<hr class="invisible_hr"$net>

<p class="paragraph">
フィルタの小見出し部分（「生存者」「犠牲者」「処刑者」「突然死者」「発言種別」「一括操作」）をクリックすると、それぞれの欄を畳んだり開いたりできます。
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="makeviloption">村作成オプションの説明</a></h3>
<dl>
  <dt>定員</dt>
  <dd><p class="paragraph">村に参加できる人数の上限を指定します。定員に達すると、参加入力欄が表\示されなくなります。</p></dd>

  <dt>最低人数</dt>
  <dd><p class="paragraph">開始方法が「人狼BBS型」の場合、参加した人がこの人数未満だと自動開始しなくなります。</p></dd>

  <dt>更新時間</dt>
  <dd><p class="paragraph">更新する時間を30分単位で指定できます。</p></dd>

  <dt>更新間隔</dt>
  <dd><p class="paragraph">通常は24時間経つと更新処理が行われゲーム内の日付が進みますが、「更新間隔」を変更することで48時間ごと（または72時間ごと）にゲーム内の日付が進むようになります。</p></dd>

  <dt>投票方法</dt>
  <dd><p class="paragraph">処刑投票を行う際に、誰が投票したのかを表\示するかどうかを選択できます。無記名投票にすると表\示されなくなります。<br$net>無記名投票の場合、投票COができなくなります。</p></dd>

  <dt>役職配分</dt>
  <dd><p class="paragraph">占い師・人狼などの役職の編成をどうするかを設定します。</p></dd>

  <dt>役職配分自由設定</dt>
  <dd><p class="paragraph">「役職配分」欄で自由設定を選んだ場合に、具体的にどの役職を何人に設定するかを入力します。</p></dd>

  <dt>参加制限</dt>
  <dd><p class="paragraph">知り合い同士のみで遊びたい場合、参加用パスワードを設定するとパスワードを入力しなければ参加できないようになります。</p></dd>

  <dt>登場人物</dt>
  <dd><p class="paragraph">参加時の配役のセット（キャラセット）が複数用意されている場合、使いたいセットを選択する事ができます。</p></dd>

  <dt>発言制限</dt>
  <dd><p class="paragraph">発言数の制限の仕方を選択する事できます。</p></dd>

  <dt>開始方法</dt>
  <dd><p class="paragraph">$sow->{'cfg'}->{'NAME_SW'}は原則として村建て人が「開始」ボタンを押すことで村を開始しますが、人狼BBSのように更新時間を迎えた時に自動開始したり、人狼審問のように定員が揃い次第自動開始したりすることができます。</p></dd>

  <dt>文章</dt>
  <dd><p class="paragraph">ゲーム内で使用される様々な文章を人狼BBS風にしたり人狼審問風にしたりすることができます。</p></dd>

  <dt>ランダム</dt>
  <dd><p class="paragraph">処刑投票や能\力対象に「ランダム」という選択肢を含めることができます。ランダムに設定すると、更新時に対象が乱数によって自動決定されます。</p></dd>

  <dt>ID公開</dt>
  <dd><p class="paragraph">発言するたびに発言したプレイヤーのIDが発言欄に表\示されるようになります。</p></dd>

  <dt>閲覧制限</dt>
  <dd><p class="paragraph">年齢制限が必要な内容の企画村を行いたいときなどに、年齢制限をしめすアイコンを村一覧に表\示することができるようになります。</p></dd>
</dl>
<hr class="invisible_hr"$net>

_HTML_

}

1;
