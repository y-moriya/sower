package SWDocProhibit;

#---------------------------------------------
# �֎~�s��
#---------------------------------------------

#----------------------------------------
# �R���X�g���N�^
#----------------------------------------
sub new {
    my ( $class, $sow ) = @_;
    my $self = {
        sow   => $sow,
        title => '�֎~�s��',    # �^�C�g��
    };

    return bless( $self, $class );
}

#---------------------------------------------
# �֎~�s�ׁi�ȗ��j
# �^�c�҂��K�����������ĉ������B
#---------------------------------------------
sub outhtmlsimple {
    my $self   = shift;
    my $sow    = $self->{'sow'};
    my $cfg    = $sow->{'cfg'};
    my $net    = $sow->{'html'}->{'net'};      # Null End Tag
    my $atr_id = $sow->{'html'}->{'atr_id'};

    $reqvals->{'cmd'} = 'prohibit';
    $reqvals->{'css'} = $sow->{'query'}->{'css'} if ( $sow->{'query'}->{'css'} ne '' );
    my $url_prohibit = &SWBase::GetLinkValues( $sow, $reqvals );
    $url_prohibit = "$cfg->{'BASEDIR_CGI'}/$cfg->{'FILE_SOW'}?$url_prohibit";

    print <<"_HTML_";
<h2><a $atr_id="prohibit">�֎~�s��</a> (<a href="$url_prohibit">�ڍ�</a>)</h2>
<p class="paragraph">
�ȉ��̍s�ׂ͋֎~���Ă��܂��B
</p>

<ul>
  <li>�ˑR���Ⓤ���ȂǁA�Q�[���̓r�������i��ނ𓾂Ȃ��ꍇ�������j�B</li>
  <li>���ݎQ�����̑��̓��e�𑺂̊O�Řb���B</li>
  <li>�v���C���[���g�̎���A��]�\\�͂Ɋւ��锭��������B</li>
  <li>�����l���������ɕ����̃L�����ŎQ������B</li>
  <li>�����_�����ŗV�ԁB</li>
</ul>
<hr class="invisible_hr"$net>

_HTML_

}

#---------------------------------------------
# �֎~�s�ׁi�ڍׁj
# �^�c�҂��K�����������ĉ������B
#---------------------------------------------
sub outhtml {
    my $self   = shift;
    my $sow    = $self->{'sow'};
    my $cfg    = $sow->{'cfg'};
    my $net    = $sow->{'html'}->{'net'};      # Null End Tag
    my $atr_id = $sow->{'html'}->{'atr_id'};

    print <<"_HTML_";
<h2>�֎~�s��</h2>
<p class="paragraph">
�ȉ��̍s�ׂ͋֎~���Ă��܂��B<br$net>
</p>

<p class="paragraph">
�������A�Q���p�p�X���[�h�ɂ��Q��������݂��Ă��鑺�i�ʏ̌����j�ɂ��Ă͂��̌���ł͂���܂���B�����ɂ����ẮA�ȉ��̏����𖞂�������֎~�s�ׂ��s���Ă��\\���܂���B
</p>

<ul>
  <li>�S�������ӂ��Ă��鎖�B</li>
  <li>���̑��̊O�ɉe�����y�ڂ��Ȃ����B</li>
</ul>
<hr class="invisible_hr"$net>

<h3>�ˑR���Ⓤ���ȂǁA�Q�[���̓r������</h3>
<p class="paragraph">
�}�a���A��قǂ̎���Ȃ�����ˑR�������Ă͂����܂���B�헪��̗��R����̓ˑR���Ȃǂ́u��قǂ̎���v�ɂ͊܂܂�܂���B<br$net>
�������ˑR���ɏ����܂��B
</p>
<hr class="invisible_hr"$net>

<h3>���ݎQ�����̑��̓��e�𑺂̊O�Řb��</h3>
<p class="paragraph">
���̃Q�[���ɂ����āu���v�͕���ł��B�Q�[���O�ő��̓��e�����Ƃ肷��ƁA�s���ɏ��s���䂪�߂Ă��܂��댯������܂��B�ł��̂ŁA���̑����I�����ăG�s���[�O���}����܂ŁA���̑��ȊO�̏ꏊ�ŃQ�[�����e��b���Ȃ��ŉ������B
</p>

<p class="paragraph">
�Ȃ��A���L�E�u���O�Ȃǂցu���������ɎQ�����Ă��܂��v�̂悤�Ȏ����������ގ��������ĉ������B<br$net>
������񑼂̐l�T�N���[���Řb���������l�ł��B
</p>
<hr class="invisible_hr"$net>

<h3>�v���C���[���g�̎���A��]�\\�͂Ɋւ��锭��������</h3>
<p class="paragraph">
������s���ɏ��s���䂪�߂Ă��܂��댯������܂��̂ŁA��΂ɂ��Ȃ��ŉ������B
</p>
<hr class="invisible_hr"$net>

<h3>�����l���������ɕ����̃L�����ŎQ������</h3>
<p class="paragraph">
������O�ł�����l�œ��������΃Q�[���o�����X������܂��B��΂ɍs��Ȃ��ŉ������B
</p>
<hr class="invisible_hr"$net>

<h3>�{�C�Ō��܂�����</h3>
<p class="paragraph">
��{�I�Ɍ��܂͋֎~�ł��B���܂����邽�߂ɂ��̃Q�[���ŗV�Ԃ킯�ł͂���܂���B������Ɨ��Ă�����I�ɂȂ�Ȃ��悤�ɂ��ĉ������B
</p>

<p class="paragraph">
�܂��A���̎Q���҂�����I�ɂ����Ȃ��悤�A�������s���ɂ�����悤�Ȕ������T��ŉ������B���܂�U�������鎖�ɂȂ�܂��B
</p>
<hr class="invisible_hr"$net>

<h3>�\\�͂Ɋւ���\\�����V�X�e���̏o�͒ʂ�ɏ����i�肢���ʂȂǁj</h3>
<p class="paragraph">
�Ⴆ�ΐ肢���ʂ����̂܂܃R�s�[���y�[�X�g����Ƃ������s�ׂ͕s���ɋ����Ǝv����̂ŁA�s��Ȃ��ŉ������B<br$net>
���l�ɁA�u�肢���ʂ��V�X�e���̏o�͒ʂ�A���m�ɏ����ĂȂ�����U�҂��v�̂悤�Ȏw�E���s��Ȃ��ŉ������B
</p>
<hr class="invisible_hr"$net>

<h3>�����_�����ŗV��</h3>
<p class="paragraph">
����܂�D������Ȃ��̂ŋ֎~�ł��B
</p>
<hr class="invisible_hr"$net>
_HTML_

}

1;
