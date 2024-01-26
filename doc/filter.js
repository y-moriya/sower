var fixedfilter; //フィルタの固定モード
var layoutfilter; // フィルタの配置
var pnofilter; // 個人ごとの表示／非表示
var typefilter; // 発言種別ごとの表示／非表示
var livetypes; //人物欄の表示／非表示
var mestypefilter; //発言種別欄の表示／非表示
var lumpfilter; //一括処理欄の表示／非表示
var mestypes = [
	'X',
	'I',
	'i',
	'D',
	'd',
	'Q',
	'S',
	'T',
	'W',
	'G',
	'M',
	'A',
	'P',
	'B',
	'U',
	'C',
	'L',
];

//---------------------------------------------
//発言の表示／非表示
//---------------------------------------------

//指定したキャラの発言の表示／非表示を切り替える
function changeFilterByPlList(pno) {
	//フィルタ位置を一旦リセット
	moveFilterTopZeroIE();

	if (!pnofilter[pno]) pnofilter[pno] = 0;
	pnofilter[pno] = 1 - pnofilter[pno];
	changeFilterByPno(pno);

	eventFixFilter(); //フィルタの再配置
	writeCookieFilter();
}

function applyFilterByPlList(pno) {
	//フィルタ位置を一旦リセット
	moveFilterTopZeroIE();

	changeFilterByPno(pno);

	eventFixFilter(); //フィルタの再配置
	writeCookieFilter();
}

function hideMessageByPlList(pno) {
	//フィルタ位置を一旦リセット
	moveFilterTopZeroIE();

	hideMessageByPno(pno);

	eventFixFilter(); //フィルタの再配置
	writeCookieFilter();
}

//指定したキャラの発言の表示／非表示を切り替える（内部用）
function hideMessageByPno(pno) {
	var display = 'none';
	var enable = 'disenable';
	var obj = getDocumentObject('checkpnofilter_' + pno);
	if (!obj) return;
	obj.checked = false;

	changeSayDisplayByPNo(pno, display); //発言の表示／非表示
	changeClass('pnofilter_' + pno, 'sayfilter_content_' + enable); // フィルタ欄の表示切り替え
}

//指定した発言種別の発言の表示／非表示を切り替える
function changeFilterByCheckBoxMesType(mestype) {
	var i = mestypes.indexOf(mestype);
	console.log(i);
	var display;
	var enable;
	var checked;

	//フィルタ位置を一旦リセット
	moveFilterTopZeroIE();
	if (!typefilter[i]) typefilter[i] = 0;
	typefilter[i] = 1 - typefilter[i];
	if (typefilter[i] == 0) {
		display = 'block';
		enable = 'enable';
		checked = true;
	} else {
		display = 'none';
		enable = 'disenable';
		checked = false;
	}

	changeSayDisplayByMesType(mestype, display);
	changeClass('typefilter_' + mestype, 'sayfilter_content_' + enable);

	var obj = getDocumentObject('checktypefilter_' + mestype);
	if (obj) obj.checked = checked;

	eventFixFilter(); //フィルタの再配置
	writeCookieFilter();
}

function applyFilterByCheckBoxMesType(mestype) {
	var i = mestypes.indexOf(mestype);
	var display;
	var enable;
	var checked;

	//フィルタ位置を一旦リセット
	moveFilterTopZeroIE();
	if (typefilter[i] == 0) {
		display = 'block';
		enable = 'enable';
		checked = true;
	} else {
		display = 'none';
		enable = 'disenable';
		checked = false;
	}

	changeSayDisplayByMesType(mestype, display);
	changeClass('typefilter_' + mestype, 'sayfilter_content_' + enable);

	var obj = getDocumentObject('checktypefilter_' + mestype);
	if (obj) obj.checked = checked;

	eventFixFilter(); //フィルタの再配置
	writeCookieFilter();
}

//全員表示／非表示／反転表示
//  0: 全員表示
//  1: 全員非表示
//  2: 反転表示
function changePlListAll(enabled) {
	var i;
	var elems = document.getElementsByTagName("div");

	//フィルタ位置を一旦リセット
	moveFilterTopZeroIE();

	for (i = 0; i < elems.length; i++) {
		var id = elems[i].id;
		if (id.indexOf('pnofilter_') < 0) continue;
		var pno = id.substring(id.indexOf('_') + 1);

		var data = enabled;
		if (enabled == 0) {
			pnofilter[pno] = data;
			showFilterByPno(pno); //表示／非表示切り替え
		} else if (enabled == 1) {
			pnofilter[pno] = data;
			hideFilterByPno(pno); //表示／非表示切り替え
		} else if (enabled == 2) {
			//反転
			if (!pnofilter[pno]) pnofilter[pno] = 0;
			data = 1 - pnofilter[pno];
			pnofilter[pno] = data;
			changeFilterByPno(pno); //表示／非表示切り替え
		}
	}

	eventFixFilter(); //フィルタの再配置
	writeCookieFilter();
}

//指定したキャラの発言の表示／非表示を切り替える（内部用）
function changeFilterByPno(pno) {
	var display;
	var enable;
	var obj = getDocumentObject('checkpnofilter_' + pno);
	if (!obj) return;
	var visible = obj.checked;
	obj.checked = !visible; //チェック欄の切り替え
	if (visible) {
		display = 'none';
		enable = 'disenable';
	} else {
		display = 'block';
		enable = 'enable';
	}

	changeSayDisplayByPNo(pno, display); //発言の表示／非表示
	changeClass('pnofilter_' + pno, 'sayfilter_content_' + enable); // フィルタ欄の表示切り替え
}

function showFilterByPno(pno) {
	var display;
	var enable;

	var obj = getDocumentObject('checkpnofilter_' + pno);
	if (!obj) return;
	obj.checked = true; //チェック欄の切り替え
	display = 'block';
	enable = 'enable';

	changeSayDisplayByPNo(pno, display); //発言の表示／非表示
	changeClass('pnofilter_' + pno, 'sayfilter_content_' + enable); // フィルタ欄の表示切り替え
}

function hideFilterByPno(pno) {
	var display;
	var enable;

	var obj = getDocumentObject('checkpnofilter_' + pno);
	if (!obj) return;
	obj.checked = false; //チェック欄の切り替え
	display = 'none';
	enable = 'disenable';

	changeSayDisplayByPNo(pno, display); //発言の表示／非表示
	changeClass('pnofilter_' + pno, 'sayfilter_content_' + enable); // フィルタ欄の表示切り替え
}

//---------------------------------------------
//フィルタ操作欄の展開／畳む
//---------------------------------------------

//生存者／処刑者／犠牲者／突然死者欄を展開する／畳む
function changeFilterPlList(livetype) {
	var display = 'block';
	var enable = 'enable';

	if (!livetypes[livetype]) livetypes[livetype] = 0;
	if (livetypes[livetype] == 0) {
		display = 'none';
		enable = 'disenable';
	}

	//人物欄の処理
	var obj = getDocumentObject('livetype' + livetype);
	if (obj) obj.style.display = display;

	//人物の見出し欄の処理
	changeClass('livetypecaption_' + livetype, 'sayfilter_caption_' + enable);

	livetypes[livetype] = 1 - livetypes[livetype];
	writeCookieFilter();
}

//発言種別欄を展開する／畳む
function changeFilterMesType() {
	var display = 'block';
	var enable = 'enable';

	if (!mestypefilter) mestypefilter = 0;
	if (mestypefilter == 0) {
		display = 'none';
		enable = 'disenable';
	}

	//発言種別欄の処理
	var obj = getDocumentObject('mestypefilter');
	if (obj) obj.style.display = display;

	//発言種別の見出し欄の処理
	changeClass('mestypefiltercaption', 'sayfilter_caption_' + enable);

	mestypefilter = 1 - mestypefilter;
	writeCookieFilter();
}

//一括処理欄を展開する／畳む
function changeFilterLump() {
	var display = 'block';
	var enable = 'enable';

	if (!lumpfilter) lumpfilter = 0;
	if (lumpfilter == 0) {
		display = 'none';
		enable = 'disenable';
	}

	//一括処理欄の処理
	var obj = getDocumentObject('lumpfilter');
	if (obj) obj.style.display = display;

	//一括処理の見出し欄の処理
	changeClass('lumpfiltercaption', 'sayfilter_caption_' + enable);

	lumpfilter = 1 - lumpfilter;
	writeCookieFilter();
}

//---------------------------------------------
//フィルタ位置制御ボタン処理
//---------------------------------------------

//発言フィルタを左側へ配置
function moveFilterLeft() {
	if (layoutfilter > 0) return; //左側に配置済み

	//フィルタを左側へ移動
	changeClass('outframe', 'outframe_navimode');
	changeClass('contentframe', 'contentframe_navileft');
	changeClass('sayfilter', 'sayfilterleft');

	//画像ボタンの切り替え
	var obj = getDocumentObject('button_mvfilterleft');
	if (obj) obj.style.display = 'none';
	var obj = getDocumentObject('button_mvfilterbottom');
	if (obj) obj.style.display = 'inline';

	//チェックボックスを非表示
	changeFilterCheckBoxPlList(0);
	changeFilterCheckBoxTypes(0);

	layoutfilter = 1;
	writeCookieFilter();
}

//発言フィルタを最下段へ配置
function moveFilterBottom() {
	if (layoutfilter == 0) return; //最下段に配置済み

	//フィルタを最下段へ移動
	changeClass('outframe', 'outframe');
	changeClass('contentframe', 'contentframe');
	changeClass('sayfilter', 'sayfilter');

	//画像ボタンの切り替え
	var obj = getDocumentObject('button_mvfilterleft');
	if (obj) obj.style.display = 'inline';
	var obj = getDocumentObject('button_mvfilterbottom');
	if (obj) obj.style.display = 'none';

	//チェックボックスを表示
	changeFilterCheckBoxPlList(1);
	changeFilterCheckBoxTypes(1);

	layoutfilter = 0;
	unfixFilter(); //固定されていれば解除
	writeCookieFilter();
}

//発言フィルタを固定
function fixFilter() {
	fixFilterNoWriteCookie();

	//クッキーへ書き込み
	fixedfilter = 1;
	writeCookieFilter();
}

//発言フィルタを固定（クッキー書き込み無し）
function fixFilterNoWriteCookie() {
	if (layoutfilter == 0) return; //最下段の時は固定しない

	//固定処理
	var obj = getDocumentObject('sayfilter');
	if (!obj) return;
	if (navigator.appName.indexOf('Microsoft Internet Explorer') >= 0) {
		obj.style.position = 'absolute';
		fixFilterLeftIE();
	} else {
		obj.style.position = 'fixed';
	}

	//画像ボタンの切り替え
	var obj = getDocumentObject('button_fixfilter');
	if (obj) obj.style.display = 'none';
	var obj = getDocumentObject('button_unfixfilter');
	if (obj) obj.style.display = 'inline';

	//フィルタの高さを調整
	var obj = getDocumentObject('insayfilter');
	if (obj) obj.style.height = getClientHeight() + 'px';
}

//発言フィルタの固定を解除
function unfixFilter() {
	if (fixedfilter == 0) return; //固定されていない

	var obj = getDocumentObject('sayfilter');
	if (!obj) return;
	obj.style.position = 'static';

	//画像ボタンの切り替え
	var obj = getDocumentObject('button_fixfilter');
	if (layoutfilter == 0) {
		if (obj) obj.style.display = 'none';
	} else {
		if (obj) obj.style.display = 'inline';
	}
	var obj = getDocumentObject('button_unfixfilter');
	if (obj) obj.style.display = 'none';

	var obj = getDocumentObject('insayfilter');
	if (obj) obj.style.height = 'auto';
	fixedfilter = 0;
	writeCookieFilter();
}

//---------------------------------------------
//チェックボックスの表示／非表示
//---------------------------------------------

//個人チェックボックスの表示／非表示
function changeFilterCheckBoxPlList(enabled) {
	changeFilterCheckBox('checkpnofilter', enabled)
}

//発言種別チェックボックスの表示／非表示
function changeFilterCheckBoxTypes(enabled) {
	changeFilterCheckBox('checktypefilter', enabled)
}

//チェックボックスの表示／非表示
function changeFilterCheckBox(checkname, enabled) {
	var i;
	var elems = document.getElementsByTagName("input");

	var display = 'none';
	if (enabled > 0) display = 'inline';
	checkname = checkname + '_';

	for (i = 0; i < elems.length; i++) {
		var id = elems[i].id;
		if (id.indexOf(checkname) < 0) continue;
		elems[i].style.display = display;
	}

}

//---------------------------------------------
//イベント呼び出し
//---------------------------------------------

//発言フィルタの初期化
function initFilter() {
	fixedfilter = -1;
	layoutfilter = -1;
	pnofilter = new Array();
	typefilter = new Array();
	livetypes = new Array();

	const query = window.location.search;
	const urlParams = new URLSearchParams(query);
	const vid = urlParams.get('vid');
	const cookie = document.cookie;
	const cookies = cookie.split('; ');
	for (let i = 0; i < cookies.length; i++) {
		const data = cookies[i].split('=');
		if (data[0] == `filter_${vid}`) {
			const obj = JSON.parse(data[1]);
			mestypefilter = obj.mestypefilter;
			lumpfilter = obj.lumpfilter;
			pnofilter = obj.pnofilter;
			for (let i = 0; i < pnofilter.length; i++) {
				if (pnofilter[i] == 1) {
					hideMessageByPlList(i);
				}
			}
			typefilter = obj.typefilter;
			for (let i = 0; i < typefilter.length; i++) {
				if (typefilter[i] == 1) {
					applyFilterByCheckBoxMesType(mestypes[i]);
				}
			}
			livetypes = obj.livetypes;
		} else if (data[0] == 'fixedfilter') {
			fixedfilter = data[1];
		} else if (data[0] == 'layoutfilter') {
			layoutfilter = data[1];
		}
	}

	if (layoutfilter < 1) layoutfilter = 0;
	if (fixedfilter < 1) fixedfilter = 0;

	if (layoutfilter == 0) {
		//チェックボックスの表示
		changeFilterCheckBoxPlList(1);
		changeFilterCheckBoxTypes(1);
	}

	if (fixedfilter == 1) fixFilterNoWriteCookie(); //フィルタの固定
	return;
}

//発言フィルタを固定（スクロールイベント、IE用）
function eventFixFilter() {
	if (fixedfilter == 0) return; //固定モードでないなら実行しない

	fixFilterLeftIE();
}

//発言フィルタの縦サイズを調整
function eventResize() {
	var obj = getDocumentObject('insayfilter');
	if (obj) obj.style.height = getClientHeight() + 'px';
}

//ウィンドウの内側の高さを得る
function getClientHeight() {
	var objheight = window.innerHeight;
	if (!objheight) objheight = document.documentElement.clientHeight;
	if (!objheight) objheight = document.body.clientHeight;

	return objheight;
}


//---------------------------------------------
//内部用
//---------------------------------------------

//指定したキャラの発言の表示／非表示を切り替える
function changeSayDisplayByPNo(pno, display) {
	changeSayDisplay(pno, display)
}

//指定した種別の発言の表示／非表示を切り替える
function changeSayDisplayByMesType(mestype, display) {
	var i;
	var elems = document.querySelectorAll(`div[data-mestype='${mestype}']`);

	for (i = 0; i < elems.length; i++) {
		elems[i].style.display = display;
	}
}

//指定した発言の表示／非表示を切り替える
function changeSayDisplay(data, display) {
	var i;
	var elems = document.querySelectorAll(`div[data-pno='${data}']`);

	for (i = 0; i < elems.length; i++) {
		elems[i].style.display = display;
	}
}

//---------------------------------------------
//IE用フィルタ制御
//---------------------------------------------

//発言フィルタを画面左上に固定（IE用）
function fixFilterLeftIE() {
	var objSayFilter = getDocumentObject('sayfilter');
	var objOutFrame = getDocumentObject('outframe');
	if (!objSayFilter) return;
	if (!objOutFrame) return;

	if (navigator.appName.indexOf('Microsoft Internet Explorer') < 0) return;
	objSayFilter.style.top = document.body.scrollTop;
	objSayFilter.style.left = objOutFrame.offsetLeft;
}

//発言フィルタの縦位置を一旦ゼロにする（IE用）
function moveFilterTopZeroIE() {
	var objSayFilter = getDocumentObject('sayfilter');
	if (!objSayFilter) return;

	if (navigator.appName.indexOf('Microsoft Internet Explorer') < 0) return;
	objSayFilter.style.top = 0;
}

//---------------------------------------------
//その他
//---------------------------------------------

//ドキュメントオブジェクトの取得
function getDocumentObject(id) {
	var obj;
	if (document.getElementById) {
		obj = document.getElementById(id)
	} else if (document.all) {
		obj = document.all(id)
	} else {
		obj = null;
	}

	return obj;
}

//エレメントに適用するスタイルシートクラスを変更
function changeClass(id, classname) {
	var obj = getDocumentObject(id);
	if (obj) obj.className = classname;
}

//クッキーへの書き込み
function writeCookieFilter() {
	var dt = new Date();
	const nowSec = dt.getTime();
	dt.setTime(nowSec + 14 * 24 * 60 * 60 * 1000);
	const expiresdate = dt.toUTCString().replace(/, (\d?) (\w*) (\d?) (\d?:\d?:\d?)/, ", $1-$2-$3 $4");
	const expires = '; expires=' + expiresdate;

	document.cookie = 'modified=' + 'js' + expires;

	const query = window.location.search;
	const urlParams = new URLSearchParams(query);
	const vid = urlParams.get('vid');
	const obj = { mestypefilter, lumpfilter, pnofilter, typefilter, livetypes };
	const json = JSON.stringify(obj);
	document.cookie = `filter_${vid}=${json}${expires}`;
	document.cookie = 'fixedfilter=' + fixedfilter + expires;
	document.cookie = 'layoutfilter=' + layoutfilter + expires;

}

$(document).ready(function () {
	$(window).resize(eventResize);
	initFilter();
});
