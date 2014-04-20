package SWDocProhibit;

#---------------------------------------------
# 禁止行為
#---------------------------------------------

#----------------------------------------
# コンストラクタ
#----------------------------------------
sub new {
	my ($class, $sow) = @_;
	my $self = {
		sow   => $sow,
		title => '禁止行為', # タイトル
	};

	return bless($self, $class);
}

#---------------------------------------------
# 禁止行為（簡略）
# 運営者が適時書き換えて下さい。
#---------------------------------------------
sub outhtmlsimple {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};

	$reqvals->{'cmd'} = 'prohibit';
	$reqvals->{'css'} = $sow->{'query'}->{'css'} if ($sow->{'query'}->{'css'} ne '');
	my $url_prohibit = &SWBase::GetLinkValues($sow, $reqvals);
	$url_prohibit = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$url_prohibit";

	print <<"_HTML_";
<h2><a $atr_id="prohibit">禁止行為</a> (<a href="$url_prohibit">詳細</a>)</h2>
<p class="paragraph">
以下の行為は禁止しています。
</p>

<ul>
  <li>突然死や投了など、ゲームの途中放棄（やむを得ない場合を除く）。</li>
  <li>現在参加中の村の内容を村の外で話す。</li>
  <li>プレイヤー自身の事や、希望能\力に関する発言をする。</li>
  <li>同じ人が同じ村に複数のキャラで参加する。</li>
  <li>ランダム村で遊ぶ。</li>
</ul>
<hr class="invisible_hr"$net>

_HTML_

}

#---------------------------------------------
# 禁止行為（詳細）
# 運営者が適時書き換えて下さい。
#---------------------------------------------
sub outhtml {
	my $self = shift;
	my $sow = $self->{'sow'};
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};

	print <<"_HTML_";
<h2>禁止行為</h2>
<p class="paragraph">
以下の行為は禁止しています。<br$net>
</p>

<p class="paragraph">
ただし、参加用パスワードによる参加制限を設けている村（通称鍵村）についてはこの限りではありません。鍵村においては、以下の条件を満たす限り禁止行為を行っても構\いません。
</p>

<ul>
  <li>全員が同意している事。</li>
  <li>その村の外に影響を及ぼさない事。</li>
</ul>
<hr class="invisible_hr"$net>

<h3>突然死や投了など、ゲームの途中放棄</h3>
<p class="paragraph">
急病等、よほどの事情がない限り突然死をしてはいけません。戦略上の理由からの突然死などは「よほどの事情」には含まれません。<br$net>
投了も突然死に準じます。
</p>
<hr class="invisible_hr"$net>

<h3>現在参加中の村の内容を村の外で話す</h3>
<p class="paragraph">
このゲームにおいて「情報」は武器です。ゲーム外で村の内容をやりとりすると、不当に勝敗をゆがめてしまう危険があります。ですので、その村が終了してエピローグを迎えるまで、その村以外の場所でゲーム内容を話さないで下さい。
</p>

<p class="paragraph">
なお、日記・ブログなどへ「今○○村に参加しています」のような事を書き込む事も避けて下さい。<br$net>
もちろん他の人狼クローンで話す事も同様です。
</p>
<hr class="invisible_hr"$net>

<h3>プレイヤー自身の事や、希望能\力に関する発言をする</h3>
<p class="paragraph">
これも不当に勝敗をゆがめてしまう危険がありますので、絶対にやらないで下さい。
</p>
<hr class="invisible_hr"$net>

<h3>同じ人が同じ村に複数のキャラで参加する</h3>
<p class="paragraph">
当たり前ですが一人で二役をすればゲームバランスが崩れます。絶対に行わないで下さい。
</p>
<hr class="invisible_hr"$net>

<h3>本気で喧嘩をする</h3>
<p class="paragraph">
基本的に喧嘩は禁止です。喧嘩をするためにこのゲームで遊ぶわけではありません。かちんと来ても感情的にならないようにして下さい。
</p>

<p class="paragraph">
また、他の参加者を感情的にさせないよう、著しく不快にさせるような発言も慎んで下さい。喧嘩を誘発させる事になります。
</p>
<hr class="invisible_hr"$net>

<h3>能\力に関する表\示をシステムの出力通りに書く（占い結果など）</h3>
<p class="paragraph">
例えば占い結果をそのままコピー＆ペーストするといった行為は不当に強いと思われるので、行わないで下さい。<br$net>
同様に、「占い結果をシステムの出力通り、正確に書いてないから偽者だ」のような指摘も行わないで下さい。
</p>
<hr class="invisible_hr"$net>

<h3>ランダム村で遊ぶ</h3>
<p class="paragraph">
あんまり好きじゃないので禁止です。
</p>
<hr class="invisible_hr"$net>
_HTML_

}

1;
