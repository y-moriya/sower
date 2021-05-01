package SWLocalConfig;

#----------------------------------------
# 設定ファイル
#----------------------------------------
sub GetLocalConfig {

    # 設定を変更する場合はここに config.pl から
    # 設定をコピーして書き換える。

    my %csslist = (
        sow      => \%css_default,
        text     => \%css_text,
        junawide => \%css_junawide,
        default  => \%css_rem,
    );

    my %cfglocal = (

        # 1:動作停止（アップデート用）
        ENABLED_HALT => 0,

        # 0:村の作成ができない（村作成終了用）
        # 1:村を作成可能
        ENABLED_VMAKE => 1,

        # 1:自動生成村を作成する
        ENABLED_AUTOVMAKE => 0,

        NAME_SW       => '人狼物語',    # 名前
        URL_SW        => 'http://',         # 設置するURL（最後の“/”は必要ありません）
        \MAX_VILLAGES => 5,                 # 最大同時稼働村数
        TIMEOUT_SCRAP => 14,                # 廃村期限
    );

    my $cfg  = shift;
    my @keys = keys(%cfglocal);
    foreach (@keys) {
        $cfg->{$_} = $cfglocal{$_};
    }
    return $cfg;
}

#----------------------------------------
# 設定ファイル（基本ディレクトリ）
#----------------------------------------
sub GetLocalBaseDirConfig {
    my %cfglocal = (

        # サーバによっては、この箇所の変更が必要
        # ディレクトリを指定する場合、最後の“/”は必要ありません。
        #BASEDIR_CGI => '.',
        #BASEDIR_DOC => '.',
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
