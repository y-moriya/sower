# �����̓ǂݍ���
if [ "$1" = "--prod" ]; then
    CREDS_FILE="ftp_info.prod.txt"
elif [ "$1" = "--stg" ]; then
    CREDS_FILE="ftp_info.stg.txt"
else
    echo "Usage: deploy.sh [--prod | --stg]"
    exit 1
fi

# Git �̌��݂̃u�����`�����擾
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# ������ --prod �̂Ƃ��A�u�����`�� production �łȂ��ꍇ�̓G���[
if [ "$1" = "--prod" -a "$BRANCH" != "production" ]; then
    echo "Error: Branch name must be 'production' in --prod mode"
    exit 1
fi

# ������ --stg �̂Ƃ��A�u�����`�� staging �łȂ��ꍇ�̓G���[
if [ "$1" = "--stg" -a "$BRANCH" != "staging" ]; then
    echo "Error: Branch name must be 'staging' in --stg mode"
    exit 1
fi

# �F�؏��̓ǂݍ���
FTP_USER=$(head -n 1 $CREDS_FILE)
FTP_PASS=$(head -n 2 $CREDS_FILE | tail -n 1)
FTP_HOST=$(head -n 3 $CREDS_FILE | tail -n 1)
FTP_DIR=$(head -n 4 $CREDS_FILE | tail -n 1)
CONFIG_FILE=$(tail -n 1 $CREDS_FILE)

# �O�̂���sow.cgi�Ɏ��s������t�^
chmod 755 sow.cgi

# ��2�������Ȃ��ꍇ�� --dry-run ���w��
if [ -z $2 ]; then
    echo "Dry run mode"
    DRYRUN="--dry-run"
fi

# �A�b�v���[�h���O�t�@�C��
EXCLUDES="_config_local.*.pl .git/ .devcontainer/ .vscode/ data/ doc/ docs/"
EX_ARGS=""
for EX in $EXCLUDES; do
    EX_ARGS="$EX_ARGS -x $EX"
done

# ��2����������ꍇ
if [ ! -z $2 ]; then
# _config_local.pl�����l�[��
mv _config_local.pl _config_local.pl.bak
# _config_local.$2.pl��_config_local.pl�Ƀ��l�[��
mv $CONFIG_FILE _config_local.pl

# ��~�t�@�C�����쐬�E�A�b�v���[�h
touch halt
lftp -u $FTP_USER,$FTP_PASS $FTP_HOST <<EOF
cd $FTP_DIR
put ./halt
bye
EOF
fi

# �A�b�v���[�h
lftp -u $FTP_USER,$FTP_PASS $FTP_HOST <<EOF
mirror $DRYRUN -R -I '*.pl' -I '*.cgi' $EX_ARGS ./ $FTP_DIR
mirror $DRYRUN -R -x 'img/' ./doc/ $FTP_DIR
mirror $DRYRUN -R ./doc/img/ $FTP_DIR/img/
bye
EOF

# ��2����������ꍇ
if [ ! -z $2 ]; then
# _config_local.pl�����l�[��
mv _config_local.pl $CONFIG_FILE
# _config_local.pl.bak��_config_local.pl�Ƀ��l�[��
mv _config_local.pl.bak _config_local.pl

# ��~�t�@�C�����폜
lftp -u $FTP_USER,$FTP_PASS $FTP_HOST <<EOF
rm $FTP_DIR/halt
bye
EOF
rm halt
fi
