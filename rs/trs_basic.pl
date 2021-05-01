package SWBasicTextRS;

sub SWBasicTextRS {
    my $sow = $_[0];

    my @starttypeorder = ( 'manual', 'wbbs', 'juna' );
    my %starttypetext = (
        manual => '手動開始',
        wbbs   => '人狼BBS型（更新時間が来たら開始）',
        juna   => '人狼審問型（定員が揃ったら開始）',
    );

    my %saytext_count = (
        UNIT_SAY     => '回',
        UNIT_CAUTION => '文字',
        UNIT_ACTION  => '回',
    );

    my %saytext_point = (
        UNIT_SAY     => 'pt',
        UNIT_CAUTION => 'バイト',
        UNIT_ACTION  => '回',
    );

    my %saytext_point25 = (
        UNIT_SAY     => 'pt',
        UNIT_CAUTION => 'バイト',
        UNIT_ACTION  => '回',
    );

    my %saytext = (
        count   => \%saytext_count,
        point   => \%saytext_point,
        point25 => \%saytext_point25,
    );

    my %basictrs = (
        NONE_TEXT       => 'なし',
        SAYTEXT         => \%saytext,
        ORDER_STARTTYPE => \@starttypeorder,
        STARTTYPE       => \%starttypetext,
        BUTTONLABEL_PC  => '_BUTTON_ / 更新',
        BUTTONLABEL_MB  => '_BUTTON_',
    );

    return \%basictrs;
}

1;
