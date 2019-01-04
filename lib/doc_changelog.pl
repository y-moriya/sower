package SWDocChangeLog;

#----------------------------------------
# 更新情報
#----------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
		title => "更新情報", # タイトル
	};

	return bless($self, $class);
}

#----------------------------------------
# 最新の更新情報の表示
#
# 以下テンプレ
#
#<h3>Version 2.1EU (2007/10/01)</h3>
#<ul>
#  <li></li>
#</ul>
#
#
#
#
#
#
#----------------------------------------


sub outhtmlnew {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};

	print <<"_HTML_";
<h3>Sower Version 1.0.3 (2019/01/04)</h3>
<ul>
  <li>未確定発言の削除時間を過ぎると、自動的に確定発言に表\示を変更するようにしました。</li>
  <li>鍵付き村での傍観者発言に入村時のパスワードが必要になりました。</li>
</ul>
_HTML_

}

#----------------------------------------
# 更新情報の表示
#----------------------------------------
sub outhtml {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};

	print <<"_HTML_";
<h2><a $atr_id="changelog">更新情報</a></h2>

_HTML_

	$self->outhtmlnew();

	print <<"_HTML_";
<hr class="invisible_hr"$net>
<h3>Sower Version 1.0.2 (2018/12/28)</h3>
<ul>
  <li>発言番号をクリックするとアンカーがフォームに記入されるようにしました。</li>
  <li>その他細かな不具合、挙動を修正。</li>
</ul>
<hr class="invisible_hr"$net>
<h3>Sower Version 1.0.1 (2018/12/21)</h3>
<ul>
  <li>もっと読むボタンの挙動がおかしかったのを修正。</li>
  <li>新着発言取得ボタンの挙動がおかしかったのを修正。</li>
</ul>
<hr class="invisible_hr"$net>
<h3>Sower Version 1.0 (2014/04/23)</h3>
<ul>
  <li>発言数回復機能\をオミット。</li>
  <li>バージョン表\記を変更。</li>
</ul>
<hr class="invisible_hr"$net>
<h3>Version 2.3.3EU (2011/01/18)</h3>
<ul>
  <li>新着発言取得を洗練。おそらくIE対応。JS、CSSのみ変更。</li>
  <li>エピローグの発言を無制限にした。</li>
</ul>
<hr class="invisible_hr"$net>
<h3>Version 2.3.2EU (2010/02/18)</h3>
<ul>
  <li>エピローグ後は時刻を詳細表\示にするようにした。</li>
  <li>携帯のアクセスキーを追加した。1でその日の頭から、9でその日の最後、3で村の情報に飛びます。</li>
</ul>
<hr class="invisible_hr"$net>
<h3>Version 2.3.1EU (2010/01/12)</h3>
<ul>
  <li>ポップアップしたアンカーをドラッグ出来るようにした。</li>
  <li>発言者の画像をクリックすることで、各発言もドラッグ出来るようにした。</li>
  <li>過去発言の取得、新着発言の取得をajaxで実装。</li>
</ul>

<hr class="invisible_hr"$net>

<h3>Version 2.3EU (2010/01/05)</h3>
<ul>
  <li>村を自動生成する機能\を搭載。</li>
  <li>囁き職にのみ村視点モード、囁き専用モードを搭載。</li>
  <li>プロローグ中は村を出なくても希望を変更できるようにした。</li>
</ul>

<hr class="invisible_hr"$net>

<h3>Version 2.2.1EU (2009/12/31)</h3>
<ul>
  <li>委任不可設定でも携帯版だと委任できてしまうバグを修正。</li>
  <li>墓下公開仕様変更というか追加。役職も見えるように。</li>
  <li>携帯版から村建て、管理人発言を可能\にした。</li>
  <li>独り言をボタンとして独立させた。</li>
  <li>村の設定を変更した場合、ログに残るようにした。</li>
</ul>

<hr class="invisible_hr"$net>

<h3>Version 2.2EU (2009/11/29 - 2009/12/某日)</h3>
<ul>
  <li>トップページの横幅を瓜科サイズに。</li>
  <li>物語(2)キャラセットの名前をSWBBS-Rに。</li>
  <li>物語(2) CSSの名前ををStyle-Rに。</li>
  <li>携帯から顔画像を参照できるように。</li>
  <li>議事風（というかパクり）多段ポップアップを実装。</li>
  <li>発言時間の簡略表\示に対応。</li>
  <li>促し無しオプションを実装。</li>
  <li>自由文アクション無しオプションを実装。</li>
  <li>メモ/アクション ありなし選択オプションを実装。</li>
  <li>村建てオプション追加：進行中の村建て人発言欄の無効化</li>
  <li>村建てオプション追加：委任禁止モード</li>
  <li>墓下公開（ささやき、共鳴、念話）モード追加。</li>
  <li>携帯のログ表\示にも顔画像を表\示できるように。</li>
  <li>CSS関係のお手入れ。（未完）</li>
</ul>

<hr class="invisible_hr"$net>

<h3>Version 2.1EU (2007/10/01) ←うろ覚え</h3>
<ul>
  <li>傍観者発言を実装。</li>
  <li>物語(2)キャラセット、CSSを実装。</li>
  <li>ポップアップ周りをいじったような。</li>
  <li>個別フィルタを実装。</li>
  <li>あとどっかも手を加えているかもいないかも。</li>
</ul>

<hr class="invisible_hr"$net>

<h3>Version 2.00 Beta 8 (2007/02/06)</h3>
<ul>
  <li>終了済み村一覧にページ移動を追加しました（もちろん手抜き）。</li>
  <li>村のRSSが表\示されなくなるバグを修正しました。</li>
  <li>携帯モードの村一覧へのリンクに引数 turn が受け継がれるバグを（とりあえず）修正しました。でもまだきちんとは直していません。</li>
  <li>全員が死亡するとエピローグが一瞬で終わってしまうバグを修正しました。</li>
  <li>新役職<del>「トリックスター」</del>ピクシーを追加しました。</li>
  <li>村建て人や管理人が参加していた際、携帯モードの個人絞り込み機能\で村建て人や管理人のキャラを絞り込むと村建て人や管理人発言が表\示されてしまうバグを修正しました。</li>
  <li>一部の携帯で改行コードがうまく処理されないようなので、改行コードの扱い方を変更しました。この変更により、[[br]]と書くと改行コードに変換されるようになります。</li>
  <li>一部のSoftBank携帯で自動認識がうまくいかない問題を修正しました（たぶん）。</li>
  <li>投票・能\力の対象に「ランダム」を含めた状態で、人狼が襲撃先に「おまかせ」を選ぶとランダムとして処理されるバグを修正しました。</li>
  <li>村作成／編集の際、開始方法が人狼BBS型で役職配分自由設定の時に最低人数と定員を異なる人数に設定できてしまうバグを修正しました（エラーを出します）。</li>
  <li>行数計算にアクションを含む設定の際に、携帯モードで次ページ移動（＞）をするとログが正常に表\示されないバグを修正しました。</li>
  <li>現在参加中のプレイヤーが選択していないキャラセットを使用したキャラの発言が、表\示する村ログに含まれていた場合にキャラ画像が表\示されなくなるバグを修正しました。</li>
  <li>役職希望に「ランダム」を追加しました。</li>
  <li>村作成／編集に「役職希望を無視する」という項目を追加しました。</li>
  <li>村作成／編集に「閲覧制限」という項目を追加しました。</li>
  <li>RSS を UTF-8 で出力できるようにしました（要Jcode.pm）。</li>
  <li>RSSへのリンクを張るかどうかを設定ファイルで切り替えられるようにしました。</li>
  <li>更新履歴に書き忘れていましたが、プロローグでの発言数補給は開始方法に関わらず補給されないように変更しています。</li>
  <li>また「役職」と「役割」という用語が混在していたので（苦笑）、「役職」に統一しました。</li>
</ul>

<hr class="invisible_hr"$net>

<h3>Version 2.00 Beta 7 (2007/01/21)</h3>
<ul>
  <li>村作成／編集に「ID公開」のオプションを追加しました。きちんとテストしていませんが。</li>
  <li>発言プレビュー時のpt計算がいろいろ間違っていたので修正しました（たぶん）。</li>
  <li>発言プレビュー時に余計な改行を削るようにしました。</li>
  <li>プロローグかつ開始方法が人狼BBS型以外の時、村名の横に更新予\定時間ではなく更新時間を表\示するようにしました。</li>
  <li>上記修正が発言プレビューに適用されていなかったので、適用しました。</li>
  <li>ランダム表\示機能\を追加しました。</li>
  <li>ユーザー情報ページを追加しました。戦績などはまだ記録していません。</li>
  <li>ユーザー情報の URL 欄に httpスキームまたはhttpsスキーム以外のアドレスを入力した際にリンクを張らないように修正しました。</li>
  <li>PCモードでの、エピローグの配役一覧表\示を変更しました（すでに決着／終了している村の表\示は更新されません。</li>
  <li>自動廃村機能\を追加しました。</li>
  <li>管理者権限による強制廃村機能\を追加しました。</li>
  <li>携帯モード送信時コマンドの標準設定を get から post に変更しました。</li>
  <li>最低人数以上の人間が集まっている状態で、村の開始方法を人狼BBS方式以外にした状態で更新時間を過ぎ、その後に人狼BBS方式へ変更すると突然村が開始してしまうバグを修正しました。</li>
  <li>携帯モードがまだ不穏な動きをするので一応修正しました（あくまで一応）。</li>
  <li>エントリー発言プレビューから修正ボタンを消しました。</li>
  <li>プロローグでの自動追い出し機能\を追加しました（追加前に村へ参加した人は対象外です）。</li>
  <li>携帯モードの村の情報ページに各プレイヤーの残り発言数を表\示するようにしました。</li>
  <li>役職とインターフェイスのページを追加しました（まだ手抜きですが）。</li>
  <li>能\力結果表\示をちょっと手直ししました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Beta 6 (2007/01/06)</h3>
<ul>
  <li>ユーザーIDに空白のみのIDを使えないようにしました。</li>
  <li>発言数（pt）補充のタイミングを変えました。手抜きですが。</li>
  <li>超×３ぐらい手抜きですが携帯モードに村一覧画面を追加しました。</li>
  <li>手抜きですが携帯モードに個人絞り込み機能\を付けました。ただしプロローグでは効きません（中途半端）。</li>
  <li>アクションにしおり機能\を追加しました（「ここまで読んだ」）。</li>
  <li>ダミーキャラ用ID・管理人用IDが登録されていないと、警告を出すようにしました。</li>
  <li>発言プレビューに「修正」ボタンを付けました（村建て人・管理人発言は除く）。</li>
  <li>発言プレビューではみ出した文字をぶった切らずに灰色表\示するよう変更しました。</li>
  <li>PCモードでエピローグ中にメモ入力欄が表\示されないバグを修正しました。</li>
  <li>同時稼働村数の制限設定値を新規追加しました。いい加減な実装ですが（またか</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Beta 5 (2006/12/26)</h3>
<ul>
  <li>新役職「呪狼」「智狼」を追加しました。</li>
  <li>定員に達しているのに参加できてしまうバグを修正しました。</li>
  <li>携帯モードで終了日に無効なページリンクが表\示されるバグを修正しました。</li>
  <li>護衛成功時、護衛成功メッセージに護った相手の名前が表\示されないバグを修正しました。</li>
  <li>村作成／編集時に最低人数のチェックをしていないバグを修正しました。</li>
  <li>一発言中に３つ以上の &amp; が含まれていると、３つ目以降の &amp; が文字参照にエスケープされないバグを修正しました。</li>
  <li>最新の発言を RSS などからログID指定表\示した時に、発言内のアンカーがおかしくなるバグを修正しました。たぶん。</li>
  <li>促しの回数設定が無視されるバグを修正しました。</li>
  <li>手抜きですが役職配分一覧表\を追加しました</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Beta 4 (2006/12/17)</h3>
<ul>
  <li>村ログで当日以外の日から「トップページへ戻る」のリンクをクリックすると、進行中の村の一覧に終了済みの村が表\示されてしまうバグを（暫定ながら）修正しました。</li>
  <li>秘密会話（ささやき・共鳴・念話）用発言入力欄に等幅チェック欄が抜けていたのを修正しました。</li>
  <li>スタイルシートを一部修正しました（発言日付のフォントサイズ他）。</li>
  <li>携帯モードでの不可視系システム発言（投票設定など）の表\示色を灰色に変更しました。</li>
  <li>Beta 3 で直したと思っていた携帯モードのマスク処理がきちんと直ってなかったので、再修正しました（苦笑）。</li>
  <li>文字数計算の際に「&lt;」「&gt;」「&amp;」「&quot;」の文字を文字参照の形で数えていたバグを修正しました。</li>
  <li>上記修正の際にポイント計算式の修正をするのを忘れていたので、修正しました（苦笑）。</li>
  <li>「&lt;」を含む発言をすると、「&lt;」以降の文章がなくなってしまうバグを修正しました。</li>
  <li>文字参照を含む発言があると、RSSのdescription要素が正常に出力されない事があるバグを修正しました。</li>
  <li>PCモードにページ分割表\示機能\を暫定的に追加しました。が、予\想通り動きが不穏です（こら</li>
  <li>終了した村の情報ページが表\示できないバグを修正しました。</li>
  <li>最新日に最新ページ以外でも発言入力欄が表\示されてしまうバグを修正しました。</li>
  <li>襲撃先を一旦誰かに合わせると、「おまかせ」に戻せなくなるバグを修正しました。</li>
  <li>実験的に数値文字参照が使えるようにしてみました。</li>
  <li>携帯モードで表\示順序を「上から下」にした時に、アンカーから飛ぶとアンカー先が一番下になってしまうバグを修正しました。</li>
  <li>村の情報ページに「開始方法」を表\示するようにしました。</li>
  <li>フィルタに死亡日を表\示するようにしました。</li>
  <li>フィルタの死亡者表\示が死亡日の順に並ぶように変更しました。</li>
  <li>ハムスター人間やコウモリ人間が占いで死亡した時に死亡日が正しく記録されないバグを修正しました。</li>
  <li>通常発言から秘密会話（ささやき、共鳴、念話）へのアンカーが打てないようにしました。</li>
  <li>墓下独り言から墓下発言へのアンカーが打てないバグを修正しました。</li>
  <li>設定値 NAME_SW を追加しました。国名を記述する際に利用して下さい。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Beta 3 (2006/12/10)</h3>
<ul>
  <li>メモを貼\っていない状態で、メモ入力欄にスペースや改行を入力して「メモを貼\る」を押すと、メモをはがせてしまうバグを修正しました。</li>
  <li>複数のキャラセットを使用している際に、ダミーキャラ指定設定のキャラを（そのキャラが未参加であるのにもかかわらず）参加画面で選べないバグを修正しました。</li>
  <li>携帯モードで、ページリンクと前移動リンクの引数 logid に対するマスク処理が行われないバグを修正しました。</li>
  <li>携帯モードでメモ履歴を表\示した時に、村を出た人の名前欄に「村を出ました」と表\示されないバグを修正しました。</li>
  <li>携帯モードで全角IDを使用した時にリンク先がおかしくなるバグを修正しました。</li>
  <li>ログイン／ログアウトボタンの送信先アドレスにCGIベースアドレスが抜けているバグを修正しました。</li>
  <li>携帯モードのアクセスキー設定を一部修正しました。</li>
  <li>役職配分自由設定時に、定員に満たない状態で村を開始できてしまうバグを修正しました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Beta 2 (2006/12/06)</h3>
<ul>
  <li>バージョンの表\記が「Alpha Beta 1」になっていました。orz</li>
  <li>終了後もメモ入力欄が表\示されるバグを修正しました。</li>
  <li>削除発言を見えるようにするかどうかの設定値を追加しました。</li>
  <li>村編集時に拡張設定の「文章」欄が反映されないバグを修正しました。</li>
  <li>メモの最大／最小サイズ、最大行数設定を追加しました。</li>
  <li>IEで審問風スタイルを選択している時に、墓下発言の枠が左に少しはみ出す事があるバグを暫定的に修正しました。場当たり修正なのでそのうち見直します。</li>
  <li>終了した村ログのRSSが出力されないバグを修正しました。</li>
  <li>村ログRSSの表\示行数処理が盛大に間違っていました（苦笑）。</li>
  <li>info.pl がないとエラーになるバグを修正しました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Beta 1 (2006/12/05)</h3>
<ul>
  <li>遊び方（操作方法）を追加しました。まだ全然足りませんが、おいおい追加していくという事で。</li>
  <li>未来アンカーを打つと最新の発言が（独り言など、本来見えない発言であっても）ポップアップしてしまうバグを修正しました。</li>
  <li>メモまたはメモ履歴を表\示している時のログへのリンクから #newsay を外しました。</li>
  <li>人狼役で発言プレビューを表\示した時に、誤爆チェックを付けずに書き込みを押して再度発言プレビューを表\示させると発言番号（99999）が表\示されてしまうバグを修正しました。</li>
  <li>村の一覧の村へのリンクに #newsay を入れました。</li>
  <li>村ログのRSSで前日の発言へのリンクに引数turn が含まれていないバグを修正しました。</li>
  <li>携帯モードの時に墓下発言を青文字で表\示するようにしました。</li>
  <li>死者がメモページを開くとメモ入力欄が表\示されてしまうバグを修正しました。</li>
  <li>エピローグでアクションの対象が死者を選べないバグを修正しました。</li>
  <li>当日行数オーバーのため表\示されていない発言へのアンカーで、ポップアップ表\示がされないバグを修正しました。</li>
  <li>アンカーから別窓表\示した発言にあるアンカーが効かないバグを修正しました。</li>
  <li>進行中村ログのRSSで、独り言などの発言がマスクIDではなく本来見えないはずの本ログIDで出力されるバグを修正しました。</li>
  <li>ダミーキャラが村を出る事ができてしまうバグを修正しました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 39 (2006/12/02)</h3>
<ul>
  <li>携帯モードで村の情報ページが正常に表\示されないバグを修正しました。</li>
  <li>メモ機能\に文字数制限・行数制限がかからないバグを修正しました。</li>
  <li>発言制限がポイント制の時に、発言プレビューに消費ポイント数が表\示されないバグを修正しました。</li>
  <li>メモを貼\った場合、RSSが正常に表\示されなくなるバグを修正しました。</li>
  <li>RSSでのメモへのリンクが間違ったアドレスになっているバグを修正しました。</li>
  <li>フィルタを下配置にした時に、個人名の左のチェックボックスが表\示されないバグを修正しました。</li>
  <li>発言時の文字数制限・行数制限によるトリム機構\が無効になっていました。デグレードじゃん。orz</li>
  <li>メモ履歴が20行までしか表\示されないバグを修正しました。</li>
  <li>キャッシュ制御がまだおかしかったので応急処置を施しました。</li>
  <li>発言プレビュー時にはトップバナーのリンクとログアウトボタンが無効になるよう修正しました。</li>
  <li>メモが短すぎる時にエラーを出すようにしました。</li>
  <li>過去のメモに書き込めてしまうバグを修正しました。</li>
  <li>最新日のメモ・メモ履歴を表\示している時は、ログへのリンクに #newsay を加えるようにしました。</li>
  <li><del>「最新」リンクを追加してみました。気分でまた消すかもしれません（おい）。</del></li>
  <li>「最新」リンクを「発言欄へ」リンクに改めました。</li>
  <li>一部の携帯電話から発言すると改行コードが文字化けするバグを修正しました（たぶん</li>
  <li>村を抜けた人が貼\っていたメモを「メモ」欄に表\示しないようにしました（メモ履歴には表\示されます）。</li>
  <li>メモを貼\った人が村を抜けている場合、メモ履歴の名前欄に「(村を出ました)」と注意書きが出るようにしました。</li>
  <li>携帯モードのアンカーの挙動が色々とボロボロだったので修正しました。</li>
  <li>HTTP の Location へ &amp; を出力する時に &amp;amp; が混じっていたバグを修正しました。
  <ul>
    <li>この修正で RSS出力が正常に動かなくなるバグが出たので直しました（馬鹿</li>
  </ul>
  </li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 38 (2006/11/30)</h3>
<ul>
  <li>携帯モードにページリンクを追加しました。</li>
  <li>携帯モードで独り言を灰色、囁き・共鳴・念話を赤色で表\示するようにしました。</li>
  <li>PCモードで、その日へのアンカーにマウスポインタを載せるとポップアップ表\示する機能\を追加しました。</li>
  <li>PCモードで、アンカーをクリックすると別ウィンドウでその発言のみを開くようにしました。</li>
  <li>遊び方に文字化けがあったので直しました。</li>
  <li>キャッシュ制御を見直しました。</li>
  <li>通常発言をしても、確定しない限り未発言者リストから消えないように変更しました。
  <ul>
    <li>この変更により、発言撤回を使って実質発言なしのままの突然死回避するという事ができなくなりました。</li>
    <li>この変更により、発言が確定しない間は時間を進める事ができなくなりました。</li>
  </ul>
  </li>
  <li>メモ機能\を追加しました。</li>
  <li>人狼譜（ver/mikari 0.2ベース、夜部分のみ）を出力する機能\を暫定的に実装しました。cmd=score を引数に付加すると表\示されます。</li>
  <li>テキストベーススキンを暫定的に実装しました。アドレスに &amp;css=text と付加すれば有効になります。</li>
  <li>似非審問スキンを暫定的に実装しました。アドレスに &amp;css=juna と付加すれば有効になります。</li>
  <li>最新の発言にマウスを載せると文字の色が変わるバグを修正しました。</li>
  <li>携帯モードで時折エラーが出るバグを修正しました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 37 (2006/11/03)</h3>
<ul>
  <li>村の情報の人数欄にダミーキャラ込みの人数という注意書きを入れました。</li>
  <li>村を出た人の発言のフィルタリングがおかしな動作をするバグを修正しました（たぶん）（たぶんか）。</li>
  <li>襲撃メッセージがフィルタに連動しないバグを修正しました。</li>
  <li>共鳴と念話を囁きフィルタでフィルタリングできるようにしました。それに伴い囁きフィルタを「囁き／共鳴／念話」フィルタに変更しました。</li>
  <li>村の情報の配分表\示が自由設定の時に二重になるバグを修正しました。</li>
  <li>まだ定員に達していない場合に、村の情報へあと何人参加できるかを表\示するようにしました。</li>
  <li>ダミーキャラに対するフィルタ操作が効かないバグを修正しました。</li>
  <li>聖痕者が二人以上いる場合に、二人目以降の聖痕者の色が表\示されないバグを修正しました。</li>
  <li>共鳴者の相方が表\示されないバグを修正しました。</li>
  <li>暫定的に二重発言チェックの際に発言種別もチェックするようにしました……が、うーん、困ったなこれ（汗）。</li>
  <li>参加パスワード機能\を追加しました。</li>
  <li>募集中／開始待ちの村のRSSに開始済み／終了済みの村が出力されるバグを修正しました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 36 (2006/10/26)</h3>
<ul>
  <li>プロローグで定員に達した時点で村建て人（または管理人）が参加していない場合、村建て人（管理人）用の発言フォームが表\示されないバグを修正しました。</li>
  <li>コウモリ人間のハムスター人間特性（襲撃されない、占われると死亡する）の処理が抜けていたので追加しました。</li>
  <li>コミットした際に１日分以上の時間が確保されないバグを修正しました。</li>
  <li>未発言なのにコミット出来てしまうバグを修正しました。</li>
  <li>村抜けができるのに「エントリーは取り消せません」と表\示されていたバグを修正しました。</li>
  <li>Ｃ国狂人の時に紛らわしいので、囁きの省略文字を【狼】から【赤】に変更しました。</li>
  <li>村ログのタイトルに日数を入れるようにしました。</li>
  <li>墓下で独り言が呟けるように変更しました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 35 (2006/10/18)</h3>
<ul>
  <li>このスクリプトの名称を「ミニ人狼BBS（仮）」から「人狼物語」に変更しました。</li>
  <li>コミット機能\を追加しました。</li>
  <li>生存者が全員突然死すると突然死表\示の後に内容無しの枠が表\示されるバグを修正しました。</li>
  <li>村開始方法が「人狼BBS型（更新時間が来たら開始）」以外の時にも定員割れメッセージが表\示されるバグを修正しました。</li>
  <li>村名が未入力の時に村作成ができてしまうバグを修正しました。</li>
  <li>終了後の「人」「狼」「墓」「全」視点切り替えが効かないバグを修正しました。</li>
  <li>キャッシュ制御の仕様を変更しました。IEは対象外にしました（涙）。</li>
  <li>携帯モードのアクション入力における定型文と直接入力の切り替えを、ラジオボタンではなくコンボボックスで行うように変更しました。</li>
  <li>携帯モードでログイン後にエラーが出た場合、ログイン画面へ戻るリンクしか表\示されないのが不便なので、通常のナビゲータが表\示されるように修正しました。</li>
  <li>Version 8.x 以前の Opera で、発言や投票セット等をすると正常にリロードされない問題に暫定対応しました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 34 (2006/08/04)</h3>
<ul>
  <li>携帯モードに設定画面を付けました（暫定）。</li>
  <li>Ｃ国狂人の時に携帯モードで囁けないバグを修正しました。</li>
  <li>共鳴者・コウモリ人間を追加しました。</li>
  <li>更新後に他の日を見るとリロードが正しく行われない事があるバグを修正しました。</li>
  <li>携帯モードで時々引数に &amp;amp; が混じるバグを修正しました。</li>
  <li>進行中死者視点で、発言フィルタの死者の発言回数と残りpt数が正しく表\示されないバグを修正しました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 33 (2006/08/03)</h3>
<ul>
  <li>改行コードの扱いで大ボケしていました（苦笑）。</li>
  <li>携帯モードで、発言プレビューでの誤爆チェックが利かないバグを修正しました。</li>
  <li>携帯モードで最新日以外の日を表\示すると、当日内移動用のアンカーが最新日へのアンカーになってしまうバグを修正しました。</li>
  <li>携帯モードでアクションの回数の単位が「pt」になっていたバグを修正しました。</li>
  <li>ブラウザによって発言フィルタをクリックしても色が変わらないバグを修正しました。</li>
  <li>一応二重発言しようとした時にエラーを出すようにしました。アクションは対象外です。</li>
  <li>開始後も村の情報に「定員」が表\示されていたので、「人数」に変更しました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 32 (2006/08/01)</h3>
<ul>
  <li>PCモードでアンカーが利かなくなっていたのを修正しました。HAHAHAHAHAHA……。</li>
  <li>村の編集時に「村の説明」欄の改行がbr要素に化けてしまうバグを修正しました。</li>
  <li>村の編集時に、「村の開始」欄が正しく表\示されないバグを修正しました。</li>
  <li>アクションを入力した際にリロードがうまく処理されないバグを修正しました。</li>
  <li>携帯モードの下段部ナビゲータが上段部のナビゲータになっていたバグを修正しました。</li>
  <li>話の続きを促す機能\の残り回数をチェックしていなかったバグを修正しました。</li>
  <li>村抜けすると表\示がおかしくなるバグを修正しました。</li>
  <li>全て表\示にした後、そのままログイン／ログアウトしたり書き込んだりすると全行表\示になってしまうバグを修正しました。</li>
  <li>村抜けする前のキャラの発言が村へ再度入った後のキャラの発言フィルタに連動してしまうバグを修正しました。</li>
  <li>委任投票機能\を追加した……かもしれません（かも？）。</li>
  <li>等幅機能\を追加した……かもしれません（かも？）。</li>
  <li>発言フィルタで自分の発言を消した状態で発言プレビューを表\示すると発言が表\示されないバグを修正しました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 31 (2006/07/31)</h3>
<ul>
  <li>村建て人または管理人が同じIDで村に参加していると、村建て人／管理人発言が参加しているキャラクターの発言フィルタに連動して動いてしまうバグを修正しました。</li>
  <li>村の一覧（募集中／開始前）のRSSを追加しました。村が新規作成されると更新されます。</li>
  <li>「役職」と「役割」が混在していたので、「役職」に統一しました。</li>
  <li>携帯モードで発言等を行うと表\示行数設定がデフォルトに戻ってしまうバグを修正しました。</li>
  <li>携帯モードに日付リンクを追加しました。</li>
  <li>携帯モードの表\示行数から all を消しました。</li>
  <li>携帯モードにも取りあえず発言プレビュー機能\を付けてみました（暫定）。</li>
  <li>携帯電話を自動認識するようにしました（未対応の機種もあるでしょうが）。</li>
  <li>更新直後などに前日分の発言がRSSに反映されないバグを修正しました。</li>
  <li>無記名投票を追加しました。</li>
  <li>村の開始方法を三種類から選べるようにしました。</li>
  <li>村の開始ボタンを押した際に確認画面が出るようにしました。</li>
  <li>アンカーの書式が間違っていたのを修正しました。</li>
  <li>村建て人発言／管理人発言へのアンカーを張れるようにしました。</li>
  <li>村を出るボタンを追加しました。</li>
  <li>発言フィルタの選択状態を（今度こそ）cookie に保存するようにしました。</li>
  <li>生存者の発言回数と残り発言数を発言フィルタに表\示するようにしました。</li>
  <li>村の情報ページを追加しました。</li>
  <li>QRcode Perl/CGI &amp; PHP scripts（Y.Swetake氏作）に対応しました（暫定）。</li>
  <li>「話の続きを促す」機能\を追加しました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 30 (2006/07/09)</h3>
<ul>
  <li>墓下の発言数表\示がおかしくなるバグを修正しました。</li>
  <li>人狼が襲撃先を「おまかせ」に設定した際に表\示される隠しメッセージが「おまかせ」にならないバグを修正しました。</li>
  <li>プロローグの特殊発言（独り言／囁き／墓下）へのアンカーを張れないように修正しました。</li>
  <li>村の編集を行っても、「村の一覧」の村の名前欄が更新されないバグを一応修正しました。暫定ですが。</li>
  <li>携帯モードの「設」（設定）を消しました。未実装なのにリンクを付けたままだったので。</li>
  <li>携帯モードで未発言者表\示が表\示されないバグを修正しました……が、これいらないかなあ？</li>
  <li>聖痕者を追加しました。それに伴い、役職配分に「試験壱型」を追加しました。</li>
  <li>狂信者を追加しました。それに伴い、役職配分に「試験弐型」を追加しました。</li>
  <li>役職配分の自由設定機能\を追加しました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 29 (2006/07/07)</h3>
<ul>
  <li><del>発言フィルタの選択状態を cookie に保存するようにしました。</del>ひどい動作だったので停止しました。</li>
  <li>村の設定を変更してもトップページの「村の一覧」に反映されないバグを修正しました。</li>
  <li>通常発言以外でも未発言ではなくなるバグを修正しました。</li>
  <li>エピローグで他人の保留中発言が見えてしまうバグを修正しました。</li>
  <li>ダブルクォーテーションが文字実体参照に変換されないバグを修正しました。</li>
  <li>村の一覧の人数欄が進行中の時に正しく表\示されないバグを修正しました。</li>
  <li>村建て人が村に参加していないと村の編集や開始ができなくなるバグを修正しました。</li>
  <li>村建て人発言／管理人発言機能\を追加しました。</li>
  <li>アクションでアンカーが表\示されないバグを修正しました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 28 (2006/07/05)</h3>
<ul>
  <li>独り言のアンカー用番号を非表\示にするつもりで間違えて全発言のアンカー用番号を非表\示にしてしまっていたバグを修正しました。</li>
  <li>更新処理の際に次回更新日時がおかしくなってリロードするたびに更新がかかってしまう特大バグを修正しました。</li>
  <li>突然死処理が発言数補充機能\に対応していないバグを修正しました。</li>
  <li>faviconを入れてみました（無駄な機能\追加）。</li>
  <li>アンカーの仕様変更のためにRSS出力が正常に動作しなくなっていたのを修正しました。</li>
  <li>RSS出力の順序を、最新の発言が一番上に来るようにしました。</li>
  <li>Internet Explorer で村ログの最下段を表\示したあと発言フィルタの非表\示ボタンを押すと表\示がおかしくなるバグを修正しました。</li>
  <li>襲撃先候補が複数ある時の襲撃先決定方法が多数決制だったのをランダムに修正しました。</li>
  <li>進行中（エピ突入前）、人狼役のプレイヤーが携帯モードで通常発言をしようとすると発言プレビューが表\示されてしまうバグを修正しました。</li>
  <li>ハムスター人間を追加しました。</li>
  <li>発言制限方式がバイト単位（人狼審問方式）の時に、行数の多すぎる発言を切り捨てずにそのまま書き込んでしまうバグを修正しました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 27 (2006/07/03)</h3>
<ul>
  <li>村の作成／編集画面にある「村の説明」欄のlabel要素の終了タグが開始タグになっていたので修正しました。</li>
  <li>PCモードの囁き欄のdiv要素が一つ間違っていたので修正しました。</li>
  <li>携帯モードでレスアンカーが全く表\示されなかったので、文字部分だけとりあえず表\示させました。まだリンクは張られません。</li>
  <li>というか携帯モードの動作がおかしいです。でも直す気力が今ないので（ｒｙ</li>
  <li>独り言の内部処理に問題があったので修正しました。</li>
  <li>暫定ですが発言フィルタを組み込みました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 26 (2006/07/02)</h3>
<ul>
  <li>時計に関するサブルーチンを修正。</li>
  <li>更新日時の計算にバグがあったのを修正。</li>
  <li>発言数回復（チャージ）機能\を入れました。募集期間が延長された時や、48h／72h村で更新日以外の更新時刻を迎えた時に発言数が１日分追加されます。</li>
  <li>48時間更新村／72時間更新村に対応（たぶん）。</li>
  <li>アンカー用の番号が更新されてもゼロに戻らないバグを修正しました。</li>
  <li>残りの発言数がゼロになるような発言をしようとすると発言できずにリロードしてしまうバグを修正しました。</li>
  <li>レスアンカーを張れるようになりました。</li>
  <li>プロローグでも独り言が使えるようになりました。</li>
  <li>携帯モードから発言を削除できないバグを修正しました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 25 (2006/07/01)</h3>
<ul>
  <li>エピで誤爆防止チェックが出ないようにしました。</li>
  <li>エピでの死人の発言ボタンのラベルを「死者のうめき」から「発言」に変えました。</li>
  <li>エピで死者がアクションの対象に出てこないバグを修正しました。</li>
  <li>終了済みの村で更新がかかる（または手動コミットをかける）とエラー表\示が出るバグを修正しました。</li>
  <li>MWBBSによるエラー表\示の「トップページに戻る」を「戻る」に変更。JavaScriptで前の画面に戻ります。</li>
  <li><del>エラー</del>ログ出力関係を強化しました。</li>
  <li>更新時にランダム決定される初期投票先／能\力対象に、時々自分や死人が選ばれてしまうバグを修正しました。</li>
  <li>エントリー時に村ログへ役職希望を書き込むようになりました。もちろんエピが来るまで自分にしかみえません。</li>
  <li>同じく投票／能\力対象変更時に村ログへ書き込むようになりました。もちろんエピが来るまで自分にしかみえません。</li>
  <li>エントリー周りで意味不明なコードが動いていたので剃刀でばっさりと落としました（こら）。</li>
  <li>発言・投票操作などを行った後に表\示する場所を最下段から最新発言に替えてみました。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>Version 2.00 Alpha 24 (2006/06/30)</h3>
<ul>
  <li>ファイルドライバ周りの地雷原をちょっと直しました。</li>
  <li>空アクションが出来ないようにしました。</li>
  <li>対象未選択のひな形を持つアクションが出来ないようにしました。</li>
  <li>長すぎるアクションを禁じました（$sow->{'cfg'}->{'MAXSIZE_ACTION'}バイト以内）</li>
  <li>RSS出力のitem要素のtitle要素に日時を入れました。</li>
  <li>更新情報欄を追加しました。</li>
  <li>あと細かい所直したけど忘れた！（おい）</li>
</ul>
<hr class="invisible_hr"$net>

_HTML_

	return;
}

1;
