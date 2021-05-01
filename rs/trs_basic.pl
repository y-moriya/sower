package SWBasicTextRS;

sub SWBasicTextRS {
    my $sow = $_[0];

    my @starttypeorder = ( 'manual', 'wbbs', 'juna' );
    my %starttypetext = (
        manual => '�蓮�J�n',
        wbbs   => '�l�TBBS�^�i�X�V���Ԃ�������J�n�j',
        juna   => '�l�T�R��^�i�������������J�n�j',
    );

    my %saytext_count = (
        UNIT_SAY     => '��',
        UNIT_CAUTION => '����',
        UNIT_ACTION  => '��',
    );

    my %saytext_point = (
        UNIT_SAY     => 'pt',
        UNIT_CAUTION => '�o�C�g',
        UNIT_ACTION  => '��',
    );

    my %saytext_point25 = (
        UNIT_SAY     => 'pt',
        UNIT_CAUTION => '�o�C�g',
        UNIT_ACTION  => '��',
    );

    my %saytext = (
        count   => \%saytext_count,
        point   => \%saytext_point,
        point25 => \%saytext_point25,
    );

    my %basictrs = (
        NONE_TEXT       => '�Ȃ�',
        SAYTEXT         => \%saytext,
        ORDER_STARTTYPE => \@starttypeorder,
        STARTTYPE       => \%starttypetext,
        BUTTONLABEL_PC  => '_BUTTON_ / �X�V',
        BUTTONLABEL_MB  => '_BUTTON_',
    );

    return \%basictrs;
}

1;
