package SWDocSpec;

#----------------------------------------
# �d�lFAQ
#----------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
    my ( $class, $sow ) = @_;
    my $self = {
        sow   => $sow,
        title => "���̐l�T�N���[���Ƃ̈Ⴂ�i�d�lFAQ�j",    # �^�C�g��
    };

    return bless( $self, $class );
}

#----------------------------------------
# �d�lFAQ�̕\��
#----------------------------------------
sub outhtml {
    my $self   = shift;
    my $sow    = $self->{'sow'};
    my $net    = $sow->{'html'}->{'net'};      # Null End Tag
    my $atr_id = $sow->{'html'}->{'atr_id'};

    print <<"_HTML_";
<h2>���̐l�T�N���[���Ƃ̈Ⴂ�i�d�lFAQ�j</h2>
<p class="paragraph">
�������ł͐l�T�N���[���ɂ���Ė��O�̈قȂ��E�ɂ��āA�ȉ��̂悤�ɕ\\�L���܂��B
</p>
<ul>
  <li>��l�^���� �� ��l</li>
  <li>���L�ҁ^���Ј� �� ���L��</li>
  <li>�n���X�^�[�l�ԁ^�d���^�d�� �� �n���X�^�[�l��</li>
</ul>
<hr class="invisible_hr"$net>

<h3>�ڎ�</h3>
<ul>
  <li><a href="#diff_wbbs">�l�TBBS�Ƃ̑�܂��ȈႢ</a></li>
  <li><a href="#diff_juna">�l�T�R��Ƃ̑�܂��ȈႢ</a></li>
  <li><a href="#update">���Y��肢�Ȃǂ̏������͂ǂ��Ȃ��Ă��܂����H</a></li>
  <li><a href="#curseandkillseer">�肢�t���n���X�^�[�l�Ԃ�肢��ɂ�����ԂŏP�����ꂽ�ꍇ�A�n���X�^�[�l�Ԃ���E�ł��܂����H</a></li>
  <li><a href="#atkhamster">�n���X�^�[�l�Ԃ��P���ΏۂƂȂ����ꍇ�A�n���X�^�[�l�Ԃ͎������P�����ꂽ�����킩��܂����H</a></li>
  <li><a href="#killdead">�l�T�����҂��P���Ώۂɂ��Ă����ꍇ�A�l�T�ɂ͏P�����ɂ��̐l��������ł��������킩��܂����H</a></li>
  <li><a href="#guarded">��l����q���������ꍇ�A�艞���������܂����H</a></li>
  <li><a href="#actionbeforesay">�������������ƁA�m�肷��O�ɃA�N�V�����𑗐M����ƁA�A�N�V�����̕�����Ɋm�肵�܂����H</a></li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="diff_wbbs">�l�TBBS�Ƃ̑�܂��ȈႢ</a></h3>
<ul>
  <li>�A�N�V�����E�����@�\\���g���܂��B</li>
  <li>���p�ɕ֗��ȃA���J�[�i>>0:0 �Ƃ��j���g���܂��B</li>
  <li>�X�V�̑O�|���i�u���Ԃ�i�߂�v�A�R�~�b�g�Ƃ������j���g���܂��B</li>
  <li>���������Ő�������܂���B�v���C���[�������ŗV�т��������쐬���Ă��������B</li>
  <li>�l�TBBS�ɂȂ���E�Ƃ��āA���M�ҁA�����ҁA���ҁA�R�E�����l�ԁA���T�A�q�T�A�s�N�V�[������܂��B</li>
  <li>���[�����Ƃ��Ė��L�����[����������܂��i���[CO���ł��Ȃ��Ȃ�܂��j�B</li>
  <li>�N���ɓ��[����ϔC���邱�Ƃ��ł��܂��B</li>
  <li>�����t�B���^��g�у��[�h������܂��B</li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="diff_juna">�l�T�R��Ƃ̑�܂��ȈႢ</a></h3>
<ul>
  <li>���������Ő�������܂���B�J�X�^�����݂̂ł��B</li>
  <li>�l�T�R��ɂȂ���E�Ƃ��Ăb�����l�A���ҁA�R�E�����l�ԁA���T�A�q�T�A�s�N�V�[������܂��B</li>
  <li>�ˑR���ʒm�@�\\������܂���iVersion 2.00 Beta 7 ���_�j�B</li>
  <li>�ˑR���D�揈�Y�@�\\������܂���iVersion 2.00 Beta 7 ���_�j�B</li>
  <li>�Q�����@�������ɈႢ�܂��B�E��Łu���O�C���v������A���̃y�[�W��\\������ƎQ�������\\������܂��B</li>
  <li>����ɂ̓_�~�[�L�����i�l�T�R��ł����A�[���@�C���j�̐l�����܂݂܂��i�l�T�R���15�l����$sow->{'cfg'}->{'NAME_SW'}�ł�16�l���j�B</li>
  <li>�A�N�V�����̑ΏۂɃ_�~�[�L�������܂܂�܂��B</li>
  <li>�肢��Ə��Y�悪�����������ꍇ�ł��肤�����ł��܂��B</li>
  <li>�肢�E��\\�Ȃǂ̔��茋�ʂ̓��O�̏㕔�ł͂Ȃ��\\�͎җ��i�������͗��̉��j�ɕ\\������܂��B</li>
  <li>���l�̑����ӎu�ɂ��p���͂ł��܂���iVersion 2.00 Beta 7���_�j�B</li>
  <li>�u���܂����v�ɂ��Ӑ}�I�P���~�X���ł��܂��B</li>
  <li>�P���悪���ꂳ��Ă��Ȃ��ꍇ�A�P����͐ݒ肳�ꂽ�P����̒����烉���_���őI�΂�܂��i�l�T�R��͑������j�B</li>
  <li>�����24���Ԍo�߂ɂ��|�C���g���񕜂�����܂���B</li>
</ul>
<hr class="invisible_hr"$net>

<h3><a $atr_id="update">���Y��肢�Ȃǂ̏������͂ǂ��Ȃ��Ă��܂����H</a></h3>
<p class="paragraph">
���L�̒ʂ�ł��B
</p>

<ol>
  <li>�ˑR���̏���</li>
  <li>�s�N�V�[�̔\\�́i�^�����J�j�̏���</li>
  <li>�ϔC����</li>
  <li>���Y���[</li>
  <li>�肢�E��E</li>
  <li>�P���挈��</li>
  <li>��q�Ώی���</li>
  <li>�P������</li>
  <li>��������</li>
</ol>
<hr class="invisible_hr"$net>

<h3><a $atr_id="curseandkillseer">�肢�t���n���X�^�[�l�Ԃ�肢��ɂ�����ԂŏP�����ꂽ�ꍇ�A�n���X�^�[�l�Ԃ���E�ł��܂����H</a></h3>
<p class="paragraph">
�ł��܂��B
</p>
<p class="paragraph">
<a href="#update">�X�V���̏�����</a>�ɂ���ʂ�A�P������������E����̕�����ɏ��������̂ŁA�肢�t���P���Ŏ��S����O�Ƀn���X�^�[�l�Ԃ���E�ɂ�莀�S���܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="atkhamster">�n���X�^�[�l�Ԃ��P���ΏۂƂȂ����ꍇ�A�n���X�^�[�l�Ԃ͎������P�����ꂽ�����킩��܂����H</a></h3>
<p class="paragraph">
�킩��܂���B<br$net>
�n���X�^�[�l�Ԃ��P������Ă��A�n���X�^�[�l�Ԃɂ͎������P��ꂽ���͂킩��܂��񂵁A�n���X�^�[�l�ԏP���Ǝ�l�̌�q�����Ƃ̌��������t���܂���B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="killdead">�l�T�����҂��P���Ώۂɂ��Ă����ꍇ�A�l�T�ɂ͏P�����ɂ��̐l��������ł��������킩��܂����H</a></h3>
<p class="paragraph">
�킩��܂��B
</p>

<p class="paragraph">
�l�T���P������O�ɏP���Ώۂ����S���Ă����ꍇ�A�P�����L�����Z������P�����b�Z�[�W�i�u�`�I ���������O�̖������I�v�j���\\������Ȃ��Ȃ�܂��B
</p>

<p class="paragraph">
�ł��̂ŁA�Ⴆ�ΏP�����Ǝv���Ă������肪��E���ꂽ�ꍇ�A�l�T�͂��̑��肪�n���X�^�[�l�Ԃł��鎖��m�鎖���ł��܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="guarded">��l����q���������ꍇ�A�艞���������܂����H</a></h3>
<p class="paragraph">
�����܂��B
</p>
<p class="paragraph">
��l�͌�q�ɐ�������ƁA�u�`��l�T�̏P�����������v�̂悤�Ȉꕶ���\\�͗��ɒǋL����܂��B�����ǋL����Ă��Ȃ���΁A�l�T�͎�l����q���Ă����l�����P���Ă��Ȃ������Ƃ������ɂȂ�܂��B
</p>
<hr class="invisible_hr"$net>

<h3><a $atr_id="actionbeforesay">�������������ƁA�m�肷��O�ɃA�N�V�����𑗐M����ƁA�A�N�V�����̕�����Ɋm�肵�܂����H</a></h3>
<p class="paragraph">
�������A�����̕�����Ɋm�肵�܂��B
</p>

<p class="paragraph">
�l�T�R��ł̓A�N�V�����������m�肷��d�l�̂��߁A�Z���Ԋu�Ŕ������A�N�V�����ƍs���ƃA�N�V�������O�̔�����ǂ������Ƃ������ۂ��������܂����A�{�X�N���v�g�ł͂��̂܂܂̏����Ɋm�肵�܂��B<br$net>
�m�肷��܂ł̂����������͑��̐l�ɂ͌����܂��񂪁A�m�肷��ƃA�N�V�����̑O�ɔ������}�Ɋ��荞�񂾂悤�Ȍ`�ŕ\\������܂��B
</p>
<hr class="invisible_hr"$net>

_HTML_

}

1;
