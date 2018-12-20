package SWAdminInfo;

#----------------------------------------
# 管理人からのお知らせ
#----------------------------------------
sub OutHTMLAdminInfo {
	my $sow = shift;
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};

	print <<"_HTML_";
<h2>管理人からのお知らせ</h2>
2018/12/xx
<ul>
<li>少し手入れしました。
</ul>
_HTML_

}

#----------------------------------------
# はじめに
#----------------------------------------
sub OutHTMLAbout {
	my ($sow, $reqvals) = @_;
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	$reqvals->{'cmd'} = 'about';
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);

	print <<"_HTML_";
<h2>はじめに</h2>
<p class="paragraph">
リア充向けの人狼サーバをつくりました。<br$net>
バグが残っているかもしれませんので、それを念頭においてご参加ください。<br$net>
ルールを守っていただけるならば、誰でも自由に村を建てて頂いて結構\です。<br$net>
推奨設定に従う必要もありません。<br$net>
また、企画村などで参加者全員の合意があれば、ルールを無視しても構\いません。
</p>
<h3>$sow->{'cfg'}->{'NAME_SW'}とは？</h3>
<p class="paragraph">
『リアルを充実させながら人狼で遊ぶ』ことを目的とした国です。
「忙しくて村に入れない」「来週はテストだから人狼は諦めよう」といったリアルが充実している人でも、空いた時間に軽くチェックするだけで遊べる人狼を理想としています。
従来の国とはルールや村の推奨設定などが違うため、最低でもすぐ下にある「ルール」と「推奨している村の設定」を読んだ上で参加してください。
</p>

<h3>ルール</h3>
<ul>
<li>自分のリアルを大事にすること。</li>
<li>画面の向こうにいる相手のリアルを大事にすること。</li>
<li><b>まとめ役制度は禁止</b>（いわゆる個人戦です）。この国における<a href="$urlsow?$linkvalue">個人戦の定義</a>についても一読ください。</li>
</ul>

<h3>推奨している村の設定（デフォルトの設定）</h3>
<p class="paragraph">
村の設定の全てをここに書いているわけではありません。<br$net>
おそらく従来のスタンダードとなっているものから外れているところだけを抜き出しています。
</p>
<ul>
<li>役職希望無効</li>
<li>委任不可</li>
<li>墓下公開（※）</li>
<li>メモ不可</li>
<li>自由文アクション不可（アクションは定型文のみ）</li>
<li>促しなし</li>
<li>時刻の簡略表\示</li>
</ul>
<p class="paragraph">
当然ながら推奨しているだけで強制ではありませんので、村ごとに設定が違う場合があります。<br$net>
村に参加する場合はその村の情報欄をよく読んだ上で参加してください。
</p>

<p class="paragraph">
※墓下公開とは……このオプションがオンの場合、人狼の囁き、共鳴者の共鳴、コウモリ人間の念話を役職に関係なく墓下から見ることが出来ます。<br$net>
また、発言フィルター部分に参加者全員の役職が表\示されます。
</p>

<!--

<p class="paragraph">

<a href="$urlsow?$linkvalue">$sow->{'cfg'}->{'NAME_SW'}とは？</a>
</p>
-->
<hr class="invisible_hr"$net>
_HTML_

}

#----------------------------------------
# 遊び方と仕様FAQ
#----------------------------------------
sub OutHTMLHowto {
	my ($sow, $reqvals) = @_;
	my $cfg   = $sow->{'cfg'};
	my $net = $sow->{'html'}->{'net'}; # Null End Tag
	my $atr_id = $sow->{'html'}->{'atr_id'};
	my $urlsow = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}";
	$reqvals->{'cmd'} = 'howto';
	my $linkvalue = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'operate';
	my $linkoperate = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'spec';
	my $linkspec = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'rolematrix';
	my $linkrolematrix = &SWBase::GetLinkValues($sow, $reqvals);
	$reqvals->{'cmd'} = 'rolelist';
	my $linkrolelist = &SWBase::GetLinkValues($sow, $reqvals);

	print <<"_HTML_";
<h2>遊び方</h2>
<p class="paragraph">
初めての方は、まず<a href="$urlsow?$linkvalue">遊び方</a>、<a href="$urlsow?$linkoperate">操作方法</a>、<a href="#prohibit">禁止行為</a>をよく読んでから参加しましょう。<br$net>
他の人狼クローンを遊んだ事のある方は、まず<a href="$urlsow?$linkspec">他の人狼クローンとの違い（仕様FAQ）</a>を読むとよいでしょう。<br$net>
</p>

<p class="paragraph">
役職配分の内訳を知りたい場合は<a href="$urlsow?$linkrolematrix">役職配分一覧表\</a>を見て下さい。<br$net>
能\力者の能\力欄や結果表\示を知りたい場合は<a href="$urlsow?$linkrolelist">役職とインターフェイス\</a>を見て下さい。
</p>
<hr class="invisible_hr"$net>

_HTML_

}

1;