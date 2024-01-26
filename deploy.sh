# 認証情報の読み込み
CREDS_FILE=$1
FTP_USER=$(head -n 1 $CREDS_FILE)
FTP_PASS=$(head -n 2 $CREDS_FILE | tail -n 1)
FTP_HOST=$(head -n 3 $CREDS_FILE | tail -n 1)
FTP_DIR=$(tail -n 1 $CREDS_FILE)

# 念のためsow.cgiに実行権限を付与
chmod 755 sow.cgi

# 第2引数がない場合は --dry-run を指定
if [ -z $2 ]; then
    DRYRUN="--dry-run"
fi

# アップロード除外ファイル
EXCLUDES="_config_local.pl _config_local.default.pl .git/ .devcontainer/ .vscode/ data/ doc/ docs/"
EX_ARGS=""
for EX in $EXCLUDES; do
    EX_ARGS="$EX_ARGS -x $EX"
done

# 第2引数がある場合は停止ファイルをアップロード
if [ ! -z $2 ]; then
touch halt
lftp -u $FTP_USER,$FTP_PASS $FTP_HOST <<EOF
cd $FTP_DIR
put ./halt
bye
EOF
fi

# アップロード
lftp -u $FTP_USER,$FTP_PASS $FTP_HOST <<EOF
mirror $DRYRUN -R -I '*.pl' -I '*.cgi' $EX_ARGS ./ $FTP_DIR
mirror $DRYRUN -R -x 'img/' ./doc/ $FTP_DIR
mirror $DRYRUN -R ./doc/img/ $FTP_DIR/img/
bye
EOF

# 第2引数がある場合は停止ファイルを削除
if [ ! -z $2 ]; then
lftp -u $FTP_USER,$FTP_PASS $FTP_HOST <<EOF
rm $FTP_DIR/halt
bye
EOF
rm halt
fi
