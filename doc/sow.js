var ajaxitems;
var waittime = new Array(3, 3, 3, 5, 5, 10);
var newDateInt = 0;
var maxDateInt = 0;
var sowFeedTimer;
var newLogFlag = false;
var logNumbers = 0;

function closeWindow() {
	$(".close").toggle(
	function(){
		var ank  = $(this);
		var base = ank.parents(".ajax");
		base.fadeOut("nomal", function(){
			base.remove();
		});
		return false;
	},function(){
		var ank  = $(this);
		var base = ank.parents(".ajax");
		base.fadeOut("nomal", function(){
			base.remove();
		});
		return false;
	});
}

// --------------------------------------------------------------
// 発言ポイント数自動カウント
// Thanks to http://managarmr.sakura.ne.jp/
function strLength(strSrc){
	len = -1;
	strSrc = escape(strSrc);
	for(i = 0; i < strSrc.length; i++, len++){
		if(strSrc.charAt(i) == "%"){
			if(strSrc.charAt(++i) == "u"){
				i += 3;
				len++;
			}
			i++;
		}
	}
	return len;
}
function showCount(str, elm) {
	// 本当は囁きとか共鳴もカウントしたくて element からたどっているけど、面倒だったので表発言のみ。。
	var obj = $(elm).parent().parent().prev().find('span');
	
	if (obj.attr('name') == 'point') {
		// ポイント制
		var strCount = Math.ceil(strLength(str).toString() / 2);
		var ptcnt = 0;
		if(strCount > 0 ){
			ptcnt = 20;
		}
		if(strCount > 31 ){
			ptcnt = 20+ Math.ceil((strCount - 31) / 7);
		}
	} else if (obj.attr('name') == 'count') {
		// 回数制
		ptcnt = str.length;
	}
	obj.text(ptcnt);
}

// --------------------------------------------------------------

function setAjaxEvent(target){
	// 記号類修飾
	// 日時、発言プレビュー内部、を対象外にしておく。そうしないとヤバイ。
	target.find("p:not(.multicolumn_label):not(.mes_date)").each(function(){
		html = $(this).html();
		$(this).html(
			html
			.replace(/(\/\*)(.*?)(\*\/|$)/g,'$1<em>$2</em>$3')
//			.replace(/(\*\*+)/g,'<strong>$&</strong>')
//			.replace(/(\[)(.+?)(\])/g,'<b>$&</b>')
		);
	});

	// ドラッグ機能付与
	target.find("img").toggle(function(){
		var ank  = $(this);
		var base = ank.parents(".message_filter");
		if ($(base).hasClass("ajax")) {
			return false;
		}
		var handlerId = "handler"+(new Date().getTime());
		var handler = $("<div id=\""+handlerId+"\"></div>").addClass("handler");
		base.clone(true).css('display', 'none').addClass("origin").insertAfter(base);
		base.addClass("drag");
		base.prepend(handler);
		base.easydrag();
		base.setHandler(handlerId);
		return false;
	},function(){
		var ank  = $(this);
		var base = ank.parents(".message_filter");
		if ($(base).hasClass("ajax")) {
			return false;
		}
		base.nextAll(".origin").fadeIn();
		base.fadeOut("nomal", function(){
			base.remove();
		});
		return false;
	});

	// アンカーポップアップ機能付与
	target.find(".res_anchor").toggle(
	function(mouse){
		var ank  = $(this);
		var base = ank.parents(".message_filter");//.parents(".message_filter").children();
		var text = ank.text();
		var title = ank.attr("title");
		if( 0 == text.indexOf(">>") ){
			if( "" == title ){
				var href = this.href.replace("#","&logid=").replace("&move=page","");
				$.get(href,{},function(data){
					var mes = $(data).find(".message_filter");//.parents(".message_filter").children();
					var handlerId = "handler"+(new Date().getTime());
					var handler = $("<div id=\""+handlerId+"\"></div>").addClass("handler");
					var close = $("<span class=\"close\">×</span>");
					var name = $(mes).find(".mesname");
					mes.addClass("ajax").css('display', 'none');
					setAjaxEvent(mes);
					name.append(close);
					base.after(mes);
					$(mes).prepend(handler);
					ajaxitems.push(mes);
					var topm    = mouse.pageY +  16;
					var leftm   = mouse.pageX; // 決めうち、本当はよくない。
					var leftend = $("body").width() - mes.width() - 8;
					if( leftend < leftm ) {
						leftm   = leftend;
					}
					mes.css({top:topm,left:leftm,zIndex:(parseInt( new Date().getTime()/1000 ))});
					$(mes).fadeIn();
					$(mes).easydrag();
					$(mes).setHandler(handlerId);
					closeWindow();
				});
			}else{
				window.open(this.href, '_blank');
				return false;
			}
		}else{
			window.open(this.href, '_blank');
			return false;
		}
		return false;
	},function(mouse){
		var ank  = $(this);
		var base = ank.parents(".message_filter");//.parents(".message_filter").children();
		base.nextAll(".ajax").fadeOut("nomal", function(){
			base.nextAll(".ajax").remove();
		});
		return false;
	});
}

function icoChange() {
  var i = document.entryForm.csid_cid.selectedIndex;
  var s = document.entryForm.csid_cid.options[i].value;
  if (s.match("rem")) {
  	s += "_body";
  } else if (s.match("sow")) {
  	s += "_body";
  } else if (s.match("troika")) {
  	//s += "_";
  }
  document.charaImg.src = "./img/"+s+".png";
}

function getDateInt(str) {
	var date = new Date();
	if (str.match(/(\d+)-(\d+)-(\d+)T(\d+):(\d+):(\d+)/)) {
		var year = parseInt(RegExp.$1, 10);
		var month = parseInt(RegExp.$2, 10) -1;
		var day = parseInt(RegExp.$3, 10);
		var hour = parseInt(RegExp.$4, 10);
		var min = parseInt(RegExp.$5, 10);
		var sec = parseInt(RegExp.$6, 10);
		date.setFullYear(year);
		date.setMonth(month);
		date.setDate(day);
		date.setHours(hour);
		date.setMinutes(min);
		date.setSeconds(sec);
		date.setMilliseconds(0);

		return date.getTime();
	} else {
		return false;
	}
}

function getSowFeedUrl() {
	var url = document.URL;
	var title = document.title;

	// もうちょっとエレガントなのがあってもいい気がするけど。
	if ((url.indexOf("vid=") < 0) || (url.indexOf("#newsay") < 0)) {
		return false;
	}
	url = url.replace(/cgi\?/, "cgi?cmd=rss&").replace(/#newsay/, "");

	getSowFeed(url, title, 0);
}

function getSowFeed(url, title, n) {
	$("#newinfomes").hide();
	$("#reloadlink").hide();
	$("#getnewloglink").hide();
	$("#newinfo").find("img").show();
	n++;
	$.ajax({
		url: url,
		dataType: 'xml',
		success: function(xml) {
			$(xml).find('item').each(function(){
				var thisTime = $(this).find('date').text();
				if (thisTime == "") {
					thisTime = this.getElementsByTagName('dc:date')[0].firstChild.nodeValue;
				}
				var thisDateInt = getDateInt(thisTime);
				// dc:dateを使うことにした。
				if (newDateInt == 0) {
					newDateInt = thisDateInt;
				}
				if (maxDateInt < thisDateInt) {
					maxDateInt = thisDateInt;
				}
				if (newDateInt < thisDateInt) {
					newLogFlag = true;
					logNumbers++;
				} else {
					newDateInt = maxDateInt;
					return false;
				}
			});
			if (newLogFlag) {
				document.title = '('+logNumbers+') ' + title;
				var infomes = logNumbers+ ' 件の新しい発言があります。';

				// 内部でnewinfoがない場合のをコメントアウトしました。
				//if ($("#newinfo").size() > 0) {
					$("#newinfo").find("img").hide();
					//$("#newinfomes").hide();
					//$("#reloadlink").hide();
					$("#getnewloglink").text(infomes).show();
				/* } else {
					// 例外が多くてたまに表示がくずれる。
					infomes = '<p class="info" id="newinfo"> ' + infomes + '</p>';
					if ($(".message_filter:has(a[name='newsay'])").size() > 0) {
						$(".message_filter:has(a[name='newsay'])").parent().parent().after(infomes);
					} else {
						$("a[name='newsay']").parent().after(infomes);
					}
				} */
				n = 0;
				newLogFlag = false;
			} else if (document.title.match(/\(\d+\)/)) {
					$("#newinfo").find("img").hide();
					$("#getnewloglink").show();

			} else {

					$("#newinfo").find("img").hide();
					$("#newinfomes").show();
					$("#reloadlink").show();
			}

		},
		error: function(xhr, status, e) {
			$("#newinfotime").text("最終取得時刻 エラー発生。手動で更新してください。");
		},
		complete: function(xhr, status) {
			var dd = new Date();
			var hh = dd.getHours();
			var mm = dd.getMinutes();
			var ss = dd.getSeconds();
			if (hh < 10) { hh = "0"+hh};
			if (mm < 10) { mm = "0"+mm};
			if (ss < 10) { ss = "0"+ss};
			$("#newinfotime").text("最終取得時刻 "+hh+":"+mm+":"+ss);
			sowFeedTimer = setTimeout("getSowFeed('"+url+"', '"+title+"', "+n+")", convertNtoWaitTime(n)*60*1000);
		}
	});

}

function convertNtoWaitTime(n) {
	if (n < waittime.length) {
		return waittime[n];
	} else {
		return waittime[waittime.length-1];
	}
}

//個別フィルタ
function cidfilter(cform) {
	if (cform.css) {
		if (cform.pno.value == -1) {
			window.open(cform.url.value + "?vid=" + cform.vid.value + "&turn=" + cform.turn.value + "&css=" + cform.css.value + "&rowall=on&mode=" + cform.mode.value, "_blank");
		} else {
			window.open(cform.url.value + "?vid=" + cform.vid.value + "&turn=" + cform.turn.value + "&pno=" + cform.pno.value + "&css=" + cform.css.value + "&rowall=on&mode=" + cform.mode.value, "_blank");
		}
	} else {
		if (cform.pno.value == -1) {
			window.open(cform.url.value + "?vid=" + cform.vid.value + "&turn=" + cform.turn.value + "&rowall=on&mode=" + cform.mode.value, "_blank");
		} else {
			window.open(cform.url.value + "?vid=" + cform.vid.value + "&turn=" + cform.turn.value + "&pno=" + cform.pno.value + "&rowall=on&mode=" + cform.mode.value, "_blank");
		}
	}
}

function getMoreLog(link) {
	var href = link.href;
	var base = $(link).parent();
	base.append($("<img src=\"../../img/ajax-loader.gif\">"));
	$(link).remove();
	$.get(href,{},function(data){
		var mes = $(data).find(".inframe:first").children(":not(h2)");
		setAjaxEvent(mes);
		base.hide();
		base.after(mes);
		$("#newinfo:first").remove();
	});
	return false;
}

function getNewLog(link) {
	var href = link.href;
	var base = $(link).parent();
	base.find("img").show();
	$("#getnewloglink").hide();
	$.get(href,{},function(data){
		var mes = $(data).find(".inframe:first").children(":not(h2,#readmore,#newinfo)");
		var atags = mes.find('a');
		var latestLogId = $(atags[atags.length-1]).attr("name");
		var oldlink = $("#getnewloglink").attr('href');
		var newlink = oldlink.replace(/logid=[^&]+/, 'logid=' + latestLogId);
		$("#getnewloglink").attr("href", newlink);
		
		setAjaxEvent(mes);
		base.before(mes);
		document.title = document.title.replace(/\(\d+\) /, '');
		base.find("img").hide();
		$("#newinfomes").show();
		$("#reloadlink").show();
		var dd = new Date();
		var hh = dd.getHours();
		var mm = dd.getMinutes();
		var ss = dd.getSeconds();
		if (hh < 10) { hh = "0"+hh};
		if (mm < 10) { mm = "0"+mm};
		if (ss < 10) { ss = "0"+ss};
		$("#newinfotime").text("最終取得時刻 "+hh+":"+mm+":"+ss);
		newDateInt = dd.getTime();
		maxDateInt = newDateInt;
		newLogFlag = false;
		logNumbers = 0;
	});

	return false;
}

function reloadSowFeed() {
	clearTimeout(sowFeedTimer);
	var url = document.URL;
	var title = document.title;
	url = url.replace(/cgi\?/, "cgi?cmd=rss&").replace(/#newsay/, "");
	newLogFlag = false;
	logNumbers = 0;
	getSowFeed(url, title, 0);
}

$(document).ready(function(){
	ajaxitems = [];
	setAjaxEvent($(".inframe"));
	getSowFeedUrl();
});

