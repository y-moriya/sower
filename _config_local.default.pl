package SWLocalConfig;

#----------------------------------------
# �ݒ�t�@�C��
#----------------------------------------
sub GetLocalConfig {

    # �ݒ��ύX����ꍇ�͂����� config.pl ����
    # �ݒ���R�s�[���ď���������B

    my %csslist = (
        sow      => \%css_default,
        text     => \%css_text,
        junawide => \%css_junawide,
        default  => \%css_rem,
    );

    my %cfglocal = (

        # 1:�����~�i�A�b�v�f�[�g�p�j
        ENABLED_HALT => 0,

        # 0:���̍쐬���ł��Ȃ��i���쐬�I���p�j
        # 1:�����쐬�\
        ENABLED_VMAKE => 1,

        # 1:�������������쐬����
        ENABLED_AUTOVMAKE => 0,

        NAME_SW       => '�l�T����',                      # ���O
        URL_SW        => 'http://localhost/sower',    # �ݒu����URL�i�Ō�́g/�h�͕K�v����܂���j
        \MAX_VILLAGES => 5,                           # �ő哯���ғ�����
        TIMEOUT_SCRAP => 14,                          # �p������
    );

    my $cfg  = shift;
    my @keys = keys(%cfglocal);
    foreach (@keys) {
        $cfg->{$_} = $cfglocal{$_};
    }
    return $cfg;
}

#----------------------------------------
# �ݒ�t�@�C���i��{�f�B���N�g���j
#----------------------------------------
sub GetLocalBaseDirConfig {
    my %cfglocal = (

        # �T�[�o�ɂ���ẮA���̉ӏ��̕ύX���K�v
        # �f�B���N�g�����w�肷��ꍇ�A�Ō�́g/�h�͕K�v����܂���B
        #BASEDIR_CGI => '.',
        BASEDIR_DOC => '../doc',

        #BASEDIR_DAT => './data',
    );

    my $cfg  = shift;
    my @keys = keys(%cfglocal);
    foreach (@keys) {
        $cfg->{$_} = $cfglocal{$_};
    }
    return $cfg;
}

1;
