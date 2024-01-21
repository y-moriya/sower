CREDS_FILE=$1
FTP_USER=$(head -n 1 $CREDS_FILE)
FTP_PASS=$(head -n 2 $CREDS_FILE | tail -n 1)
FTP_HOST=$(head -n 3 $CREDS_FILE | tail -n 1)
FTP_DIR=$(tail -n 1 $CREDS_FILE)

if [ -z $2 ]; then
    DRYRUN="--dry-run"
fi

EXCLUDES="_config_local.pl _config_local.default.pl .git/ .devcontainer/ .vscode/ data/ doc/ docs/"
EX_ARGS=""
for EX in $EXCLUDES; do
    EX_ARGS="$EX_ARGS -x $EX"
done

if [ ! -z $2 ]; then
touch halt
lftp -u $FTP_USER,$FTP_PASS $FTP_HOST <<EOF
cd $FTP_DIR
put ./halt
bye
EOF
fi

lftp -u $FTP_USER,$FTP_PASS $FTP_HOST <<EOF
mirror $DRYRUN -R -I '*.pl' -I '*.cgi' $EX_ARGS ./ $FTP_DIR
mirror $DRYRUN -R -x 'img/' ./doc/ $FTP_DIR
mirror $DRYRUN -R ./doc/img/ $FTP_DIR/img/
bye
EOF

if [ ! -z $2 ]; then
lftp -u $FTP_USER,$FTP_PASS $FTP_HOST <<EOF
rm $FTP_DIR/halt
bye
EOF
rm halt
fi
