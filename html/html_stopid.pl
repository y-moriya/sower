package SWHtmlStopID;

#----------------------------------------
# ID��~����HTML�o��
#----------------------------------------
sub OutHTMLStopID {
    my ( $sow, $noregist ) = @_;
    my $cfg = $sow->{'cfg'};
    require "$cfg->{'DIR_HTML'}/html.pl";

    undef( $sow->{'query'}->{'vid'} );

    # HTTP/HTML�̏o��
    $sow->{'html'} = SWHtml->new($sow);           # HTML���[�h�̏�����
    $sow->{'http'}->outheader();                  # HTTP�w�b�_�̏o��
    $sow->{'html'}->outheader('���Ȃ���ID�͒�~���ł�');    # HTML�w�b�_�̏o��
    $sow->{'html'}->outcontentheader();

    &SWHtmlPC::OutHTMLLogin($sow);                # ���O�C�����̏o��
    my $net = $sow->{'html'}->{'net'};            # Null End Tag

    my $penaltydt =
      int( ( $sow->{'user'}->{'penaltydt'} - $sow->{'time'} ) / 60 / 60 / 24 +
          0.5 );

    print <<"_HTML_";
<h2>���Ȃ���ID�͒�~���ł�</h2>

<p class="paragraph">
���Ȃ���ID�͂Ȃ�炩�̃y�i���e�B�ɂ���~����Ă��܂��BID��~��������͖̂�$penaltydt����ł��B<br$net>
ID��~���̓��O�C���E���O�A�E�g������<strong class="cautiontext">�قڂ�����s�����ł��Ȃ��Ȃ�܂�</strong>�B
</p>
<hr class="invisible_hr"$net>

_HTML_

    $sow->{'html'}->outcontentfooter();
    $sow->{'html'}->outfooter();    # HTML�t�b�^�̏o��
    $sow->{'http'}->outfooter();

    return;
}

1;
