# 引数の読み込み
if [ "$1" = "--prod" ]; then
    CREDS_FILE="ftp_info.prod.txt"
elif [ "$1" = "--stg" ]; then
    CREDS_FILE="ftp_info.stg.txt"
else
    echo "Usage: deploy.sh [--prod | --stg]"
    exit 1
fi

# Git の現在のブランチ名を取得
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# 引数が --prod のとき、ブランチが production でない場合はエラー
if [ "$1" = "--prod" -a "$BRANCH" != "production" ]; then
    echo "Error: Branch name must be 'production' in --prod mode"
    exit 1
fi

# 引数が --stg のとき、ブランチが staging でない場合はエラー
if [ "$1" = "--stg" -a "$BRANCH" != "staging" ]; then
    echo "Error: Branch name must be 'staging' in --stg mode"
    exit 1
fi

# 認証情報の読み込み
FTP_USER=$(head -n 1 $CREDS_FILE)
FTP_PASS=$(head -n 2 $CREDS_FILE | tail -n 1)
FTP_HOST=$(head -n 3 $CREDS_FILE | tail -n 1)
FTP_DIR=$(head -n 4 $CREDS_FILE | tail -n 1)
CONFIG_FILE=$(tail -n 1 $CREDS_FILE)

# 念のためsow.cgiに実行権限を付与
chmod 755 sow.cgi

# 第2引数がない場合は --dry-run を指定
if [ -z $2 ]; then
    echo "Dry run mode"
    DRYRUN="--dry-run"
fi

# アップロード除外ファイル
EXCLUDES="_config_local.*.pl .git/ .devcontainer/ .vscode/ data/ doc/ docs/"
EX_ARGS=""
for EX in $EXCLUDES; do
    EX_ARGS="$EX_ARGS -x $EX"
done

# 第2引数がある場合
if [ ! -z $2 ]; then
# _config_local.plをリネーム
mv _config_local.pl _config_local.pl.bak
# _config_local.$2.plを_config_local.plにリネーム
mv $CONFIG_FILE _config_local.pl

# 停止ファイルを作成・アップロード
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

# 第2引数がある場合
if [ ! -z $2 ]; then
# _config_local.plをリネーム
mv _config_local.pl $CONFIG_FILE
# _config_local.pl.bakを_config_local.plにリネーム
mv _config_local.pl.bak _config_local.pl

# 停止ファイルを削除
lftp -u $FTP_USER,$FTP_PASS $FTP_HOST <<EOF
rm $FTP_DIR/halt
bye
EOF
rm halt
fi
