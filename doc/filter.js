var fixedfilter; //�t�B���^�̌Œ胂�[�h
var layoutfilter; // �t�B���^�̔z�u
var pnofilter; // �l���Ƃ̕\���^��\��
var typefilter; // ������ʂ��Ƃ̕\���^��\��
var livetypes; //�l�����̕\���^��\��
var mestypes; //������ʗ��̕\���^��\��
var lumpfilter; //�ꊇ�������̕\���^��\��

//---------------------------------------------
//�����̕\���^��\��
//---------------------------------------------

//�w�肵���L�����̔����̕\���^��\����؂�ւ���
function changeFilterByPlList(pno) {
	//�t�B���^�ʒu����U���Z�b�g
	moveFilterTopZeroIE();

	if (!pnofilter[pno]) pnofilter[pno] = 0;
	pnofilter[pno] = 1 - pnofilter[pno];
	changeFilterByPno(pno);

	eventFixFilter(); //�t�B���^�̍Ĕz�u
	writeCookieFilter();
}

//�w�肵��������ʂ̔����̕\���^��\����؂�ւ���
function changeFilterByCheckBoxMesType(mestype) {
	var display;
	var enable;
	var checked;

	//�t�B���^�ʒu����U���Z�b�g
	moveFilterTopZeroIE();
	if (!typefilter[mestype]) typefilter[mestype] = 0;
	typefilter[mestype] = 1 - typefilter[mestype];
	if (typefilter[mestype] == 0) {
		display = 'block';
		enable  = 'enable';
		checked = true;
	} else {
		display = 'none';
		enable  = 'disenable';
		checked = false;
	}

	changeSayDisplayByMesType(mestype, display);
	changeClass('typefilter_' + mestype, 'sayfilter_content_' + enable);

	var obj = getDocumentObject('checktypefilter_' + mestype);
	if (obj) obj.checked = checked;

	eventFixFilter(); //�t�B���^�̍Ĕz�u
	writeCookieFilter();
}

//�S���\���^��\���^���]�\��
//  0: �S���\��
//  1: �S����\��
//  2: ���]�\��
function changePlListAll(enabled) {
	var i;
	var elems = document.getElementsByTagName("div");

	//�t�B���^�ʒu����U���Z�b�g
	moveFilterTopZeroIE();

	for (i = 0; i < elems.length; i++) {
		var id = elems[i].id;
		if (id.indexOf('pnofilter_') < 0) continue;
		var pno = id.substring(id.indexOf('_') + 1);

		var data = enabled;
		if (enabled == 2) {
			//���]
			if (!pnofilter[pno]) pnofilter[pno] = 0;
			data = 1 - pnofilter[pno];
		}
		pnofilter[pno] = data;
		changeFilterByPno(pno); //�\���^��\���؂�ւ�
	}

	eventFixFilter(); //�t�B���^�̍Ĕz�u
	writeCookieFilter();
}

//�w�肵���L�����̔����̕\���^��\����؂�ւ���i�����p�j
function changeFilterByPno(pno) {
	var display;
	var enable;
	var checked;

	if (pnofilter[pno] == 0) {
		display = 'block';
		enable  = 'enable';
		checked = true;
	} else {
		display = 'none';
		enable  = 'disenable';
		checked = false;
	}

	changeSayDisplayByPNo(pno, display); //�����̕\���^��\��
	changeClass('pnofilter_' + pno, 'sayfilter_content_' + enable); // �t�B���^���̕\���؂�ւ�
	var obj = getDocumentObject('checkpnofilter_' + pno);
	if (obj) obj.checked = checked; //�`�F�b�N���̐؂�ւ�
}

//---------------------------------------------
//�t�B���^���엓�̓W�J�^���
//---------------------------------------------

//�����ҁ^���Y�ҁ^�]���ҁ^�ˑR���җ���W�J����^���
function changeFilterPlList(livetype) {
	var display = 'block';
	var enable = 'enable';

	if (!livetypes[livetype]) livetypes[livetype] = 0;
	if (livetypes[livetype] == 0) {
		display = 'none';
		enable = 'disenable';
	}

	//�l�����̏���
	var obj = getDocumentObject('livetype' + livetype);
	if (obj) obj.style.display = display;

	//�l���̌��o�����̏���
	changeClass('livetypecaption_' + livetype, 'sayfilter_caption_' + enable);

	livetypes[livetype] = 1 - livetypes[livetype];
	writeCookieFilter();
}

//������ʗ���W�J����^���
function changeFilterMesType() {
	var display = 'block';
	var enable = 'enable';

	if (!mestypes) mestypes = 0;
	if (mestypes == 0) {
		display = 'none';
		enable = 'disenable';
	}

	//������ʗ��̏���
	var obj = getDocumentObject('mestypefilter');
	if (obj) obj.style.display = display;

	//������ʂ̌��o�����̏���
	changeClass('mestypefiltercaption', 'sayfilter_caption_' + enable);

	mestypes = 1 - mestypes;
	writeCookieFilter();
}

//�ꊇ��������W�J����^���
function changeFilterLump() {
	var display = 'block';
	var enable = 'enable';

	if (!lumpfilter) lumpfilter = 0;
	if (lumpfilter == 0) {
		display = 'none';
		enable = 'disenable';
	}

	//�ꊇ�������̏���
	var obj = getDocumentObject('lumpfilter');
	if (obj) obj.style.display = display;

	//�ꊇ�����̌��o�����̏���
	changeClass('lumpfiltercaption', 'sayfilter_caption_' + enable);

	lumpfilter = 1 - lumpfilter;
	writeCookieFilter();
}

//---------------------------------------------
//�t�B���^�ʒu����{�^������
//---------------------------------------------

//�����t�B���^�������֔z�u
function moveFilterLeft() {
	if (layoutfilter > 0) return; //�����ɔz�u�ς�

	//�t�B���^�������ֈړ�
	changeClass('outframe', 'outframe_navimode');
	changeClass('contentframe', 'contentframe_navileft');
	changeClass('sayfilter', 'sayfilterleft');

	//�摜�{�^���̐؂�ւ�
	var obj = getDocumentObject('button_mvfilterleft');
	if (obj) obj.style.display = 'none';
	var obj = getDocumentObject('button_mvfilterbottom');
	if (obj) obj.style.display = 'inline';

	//�`�F�b�N�{�b�N�X���\��
	changeFilterCheckBoxPlList(0);
	changeFilterCheckBoxTypes(0);

	layoutfilter = 1;
	writeCookieFilter();
}

//�����t�B���^���ŉ��i�֔z�u
function moveFilterBottom() {
	if (layoutfilter == 0) return; //�ŉ��i�ɔz�u�ς�

	//�t�B���^���ŉ��i�ֈړ�
	changeClass('outframe', 'outframe');
	changeClass('contentframe', 'contentframe');
	changeClass('sayfilter', 'sayfilter');

	//�摜�{�^���̐؂�ւ�
	var obj = getDocumentObject('button_mvfilterleft');
	if (obj) obj.style.display = 'inline';
	var obj = getDocumentObject('button_mvfilterbottom');
	if (obj) obj.style.display = 'none';

	//�`�F�b�N�{�b�N�X��\��
	changeFilterCheckBoxPlList(1);
	changeFilterCheckBoxTypes(1);

	layoutfilter = 0;
	unfixFilter(); //�Œ肳��Ă���Ή���
	writeCookieFilter();
}

//�����t�B���^���Œ�
function fixFilter() {
	fixFilterNoWriteCookie();

	//�N�b�L�[�֏�������
	fixedfilter = 1;
	writeCookieFilter();
}

//�����t�B���^���Œ�i�N�b�L�[�������ݖ����j
function fixFilterNoWriteCookie() {
	if (layoutfilter == 0) return; //�ŉ��i�̎��͌Œ肵�Ȃ�

	//�Œ菈��
	var obj = getDocumentObject('sayfilter');
	if (!obj) return;
	if (navigator.appName.indexOf('Microsoft Internet Explorer') >= 0) {
		obj.style.position = 'absolute';
		fixFilterLeftIE();
	} else {
		obj.style.position = 'fixed';
	}

	//�摜�{�^���̐؂�ւ�
	var obj = getDocumentObject('button_fixfilter');
	if (obj) obj.style.display = 'none';
	var obj = getDocumentObject('button_unfixfilter');
	if (obj) obj.style.display = 'inline';

	//�t�B���^�̍����𒲐�
	var obj = getDocumentObject('insayfilter');
	if (obj) obj.style.height = getClientHeight() + 'px';
}

//�����t�B���^�̌Œ������
function unfixFilter() {
	if (fixedfilter == 0) return; //�Œ肳��Ă��Ȃ�

	var obj = getDocumentObject('sayfilter');
	if (!obj) return;
	obj.style.position = 'static';

	//�摜�{�^���̐؂�ւ�
	var obj = getDocumentObject('button_fixfilter');
	if (layoutfilter == 0) {
		if (obj) obj.style.display = 'none';
	} else {
		if (obj) obj.style.display = 'inline';
	}
	var obj = getDocumentObject('button_unfixfilter');
	if (obj) obj.style.display = 'none';

	var obj = getDocumentObject('insayfilter');
	if (obj) obj.style.height   = 'auto';
	fixedfilter = 0;
	writeCookieFilter();
}

//---------------------------------------------
//�`�F�b�N�{�b�N�X�̕\���^��\��
//---------------------------------------------

//�l�`�F�b�N�{�b�N�X�̕\���^��\��
function changeFilterCheckBoxPlList(enabled) {
	changeFilterCheckBox('checkpnofilter', enabled)
}

//������ʃ`�F�b�N�{�b�N�X�̕\���^��\��
function changeFilterCheckBoxTypes(enabled) {
	changeFilterCheckBox('checktypefilter', enabled)
}

//�`�F�b�N�{�b�N�X�̕\���^��\��
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
//�C�x���g�Ăяo��
//---------------------------------------------

//�����t�B���^�̏�����
function initFilter() {
	fixedfilter = -1;
	layoutfilter = -1;
	pnofilter = new Array();
	typefilter = new Array();
	livetypes = new Array();

	//�N�b�L�[�̓ǂݍ���
	var cookie = document.cookie;
	cookie += '; ';
	var cookies = cookie.split('; ');
	for (var i = 0; i < cookies.length; i++) {
		var data = cookies[i].split('=');
		if (!data[1]) data[1] = '';

		//�����͂��̂����������c�c�B
		if (data[0] == 'fixedfilter') {
			fixedfilter = data[1];
		} else if (data[0] == 'layoutfilter') {
			layoutfilter = data[1];
		} else if (data[0] == 'mestypes') {
			mestypes = data[1];
		} else if (data[0] == 'lumpfilter') {
			lumpfilter = data[1];
		} else if (data[0] == 'pnofilter') {
			var pos = data[1].lastIndexOf('1');
			if (pos >= 0) {
				data[1] = data[1].substr(0, pos + 1);
				data[1] += ',';
				pnofilter = data[1].split(',');
			}
		} else if (data[0] == 'typefilter') {
			var pos = data[1].lastIndexOf('1');
			if (pos >= 0) {
				data[1] = data[1].substr(0, pos + 1);
				data[1] += ',';
				typefilter = data[1].split(',');
			}
		} else if (data[0] == 'livetypes') {
			var pos = data[1].lastIndexOf('1');
			if (pos >= 0) {
				data[1] = data[1].substr(0, pos + 1);
				data[1] += ',';
				livetypes = data[1].split(',');
			}
		}
	}

	if (layoutfilter < 1) layoutfilter = 0;
	if (fixedfilter < 1) fixedfilter = 0;

	if (layoutfilter == 0) {
		//�`�F�b�N�{�b�N�X�̕\��
		changeFilterCheckBoxPlList(1);
		changeFilterCheckBoxTypes(1);
	}

	if (fixedfilter == 1) fixFilterNoWriteCookie(); //�t�B���^�̌Œ�
	return;
}

//�����t�B���^���Œ�i�X�N���[���C�x���g�AIE�p�j
function eventFixFilter() {
	if (fixedfilter == 0) return; //�Œ胂�[�h�łȂ��Ȃ���s���Ȃ�

	fixFilterLeftIE();
}

//�����t�B���^�̏c�T�C�Y�𒲐�
function eventResize() {
	var obj = getDocumentObject('insayfilter');
	if (obj) obj.style.height = getClientHeight() + 'px';
}

//�E�B���h�E�̓����̍����𓾂�
function getClientHeight() {
	var objheight = window.innerHeight;
	if (!objheight) objheight = document.documentElement.clientHeight;
	if (!objheight) objheight = document.body.clientHeight;

	return objheight;
}


//---------------------------------------------
//�����p
//---------------------------------------------

//�w�肵���L�����̔����̕\���^��\����؂�ւ���
function changeSayDisplayByPNo(pno, display) {
	changeSayDisplay('mespno', pno, display)
}

//�w�肵����ʂ̔����̕\���^��\����؂�ւ���
function changeSayDisplayByMesType(mestype, display) {
	changeSayDisplay('mestype', mestype, display)
}

//�w�肵�������̕\���^��\����؂�ւ���
function changeSayDisplay(key, data, display) {
	var i;
	var elems = document.getElementsByTagName("div");

	for (i = 0; i < elems.length; i++) {
		var id = elems[i].id;
		if (id.indexOf(key) < 0) continue;
		var pos = id.indexOf('_');
		if (pos < 0) continue;
		if (id.substring(pos + 1) != data) continue;

		elems[i].style.display = display;
	}
}

//---------------------------------------------
//IE�p�t�B���^����
//---------------------------------------------

//�����t�B���^����ʍ���ɌŒ�iIE�p�j
function fixFilterLeftIE() {
	var objSayFilter = getDocumentObject('sayfilter');
	var objOutFrame  = getDocumentObject('outframe');
	if (!objSayFilter) return;
	if (!objOutFrame) return;

	if (navigator.appName.indexOf('Microsoft Internet Explorer') < 0) return;
	objSayFilter.style.top  = document.body.scrollTop;
	objSayFilter.style.left = objOutFrame.offsetLeft;
}

//�����t�B���^�̏c�ʒu����U�[���ɂ���iIE�p�j
function moveFilterTopZeroIE() {
	var objSayFilter = getDocumentObject('sayfilter');
	if (!objSayFilter) return;

	if (navigator.appName.indexOf('Microsoft Internet Explorer') < 0) return;
	objSayFilter.style.top  = 0;
}

//---------------------------------------------
//���̑�
//---------------------------------------------

//�h�L�������g�I�u�W�F�N�g�̎擾
function getDocumentObject(id) {
	var obj;
	if(document.getElementById) {
		obj = document.getElementById(id)
	} else if (document.all) {
		obj = document.all(id)
	} else {
		obj = null;
	}

	return obj;
}

//�G�������g�ɓK�p����X�^�C���V�[�g�N���X��ύX
function changeClass(id, classname) {
	var obj = getDocumentObject(id);
	if (obj) obj.className = classname;
}

//�N�b�L�[�ւ̏�������
function writeCookieFilter() {
	// �]���r�N�b�L�[�����߂�ǂ������̂ŁB(^^;)
	var expires = '; expires=Thu, 1-Jan-2030 00:00:00 GMT';

	document.cookie = 'modified=' + 'js' + expires;
	document.cookie = 'fixedfilter=' + fixedfilter  + expires;
	document.cookie = 'layoutfilter=' + layoutfilter + expires;
	document.cookie = 'mestypes=' + mestypes + expires;
	document.cookie = 'lumpfilter=' + lumpfilter + expires;
	document.cookie = 'pnofilter=' + pnofilter.join(',') + expires;
	document.cookie = 'typefilter=' + typefilter.join(',') + expires;
	document.cookie = 'livetypes=' + livetypes.join(',') + expires;
}

$(document).ready(function(){
	$(window).resize(eventResize);
	initFilter();
});