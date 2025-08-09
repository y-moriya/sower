#!/usr/bin/env bash

# �X�N���v�g�̂���f�B���N�g���i���[�N�X�y�[�X�z���j����Ƀ��O��ۑ�����
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ���O�o�͂̐ݒ�i���s���t����t�@�C������ ./logs �z���ɕۑ��B�������s�͒ǋL�j
_DEPLOY_TS=$(date '+%Y%m%d')
_DEPLOY_LOG_DIR="${SCRIPT_DIR}/logs"
mkdir -p "$_DEPLOY_LOG_DIR"
_DEPLOY_LOG_FILE="$_DEPLOY_LOG_DIR/deploy_${_DEPLOY_TS}.log"
# �ȍ~�̕W���o�́E�W���G���[�o�͂����O�t�@�C���� tee ���R���\�[���ɂ��\��
exec > >(tee -a "$_DEPLOY_LOG_FILE") 2>&1
echo "[INFO] deploy.sh started: $(date '+%Y-%m-%d %H:%M:%S')"
echo "[INFO] logging to: $_DEPLOY_LOG_FILE"
# ���s�R�}���h�����O�o�́i������K�؂ɃN�H�[�g���ċL�^�j
{
    printf "[INFO] command: "
    printf "%q " "$0" "$@"
    printf "\n"
}
START_EPOCH=$(date +%s)
echo "[INFO] cwd: $(pwd)"

# �����̓ǂݍ���
if [ "$1" = "--prod" ]; then
    CREDS_FILE="ftp_info.prod.txt"
elif [ "$1" = "--stg" ]; then
    CREDS_FILE="ftp_info.stg.txt"
else
    echo "Usage: deploy.sh [--prod | --stg]"
    exit 1
fi
echo "[INFO] mode: $1 (creds: $CREDS_FILE)"

# Git �̌��݂̃u�����`�����擾
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "[INFO] git branch: $BRANCH"

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

# Git�̃R�~�b�g�n�b�V��(short)���擾
COMMIT_HASH=$(git rev-parse --short HEAD)
echo "[INFO] commit: $COMMIT_HASH"

# �o�[�W�������t�@�C���ɏ�������
echo "$COMMIT_HASH" > version.txt
chmod 644 version.txt 2>/dev/null || true
echo "[INFO] wrote version.txt (644)"

# �F�؏��̓ǂݍ���
FTP_USER=$(head -n 1 "$CREDS_FILE")
FTP_PASS=$(head -n 2 "$CREDS_FILE" | tail -n 1)
FTP_HOST=$(head -n 3 "$CREDS_FILE" | tail -n 1)
FTP_DIR=$(head -n 4 "$CREDS_FILE" | tail -n 1)
CONFIG_FILE=$(tail -n 1 "$CREDS_FILE")
echo "[INFO] ftp: user=$FTP_USER host=$FTP_HOST dir=$FTP_DIR"

# �O�̂���sow.cgi�Ɏ��s������t�^
chmod 755 sow.cgi
echo "[INFO] ensured execute permission on sow.cgi"

# ��2�������Ȃ��ꍇ�� --dry-run ���w��
if [ -z "$2" ]; then
    DRYRUN="--dry-run"
fi
if [ -n "$DRYRUN" ]; then
    echo "[INFO] DRYRUN enabled"
else
    echo "[INFO] DRYRUN disabled (live mode)"
fi

# �A�b�v���[�h���O�t�@�C��
EXCLUDES="_config_local.*.pl .git/ .devcontainer/ .vscode/ data/ doc/ docs/ logs/"
EX_ARGS=""
for EX in $EXCLUDES; do
    EX_ARGS="$EX_ARGS -x $EX"
done
echo "[INFO] exclude args:$EX_ARGS"

# ��2����������ꍇ
if [ -n "$2" ]; then
# _config_local.pl�����l�[��
echo "[STEP] swap config: _config_local.pl -> _config_local.pl.bak"
mv -f _config_local.pl _config_local.pl.bak
# _config_local.$2.pl��_config_local.pl�Ƀ��l�[��
echo "[STEP] activate config: $CONFIG_FILE -> _config_local.pl"
mv -f "$CONFIG_FILE" _config_local.pl

# ��~�t�@�C�����쐬�E�A�b�v���[�h
echo "[STEP] create remote halt file"
touch halt
lftp -d -u "$FTP_USER,$FTP_PASS" "$FTP_HOST" <<EOF
set cmd:trace yes
set cmd:fail-exit yes
set net:max-retries 2
set net:timeout 30
cd "$FTP_DIR"
put ./halt
bye
EOF
RC=$?
if [ $RC -ne 0 ]; then
    echo "[ERROR] failed to upload halt (rc=$RC)"; exit $RC
else
    echo "[INFO] uploaded halt"
fi
fi

# �A�b�v���[�h
echo "[STEP] mirror upload start"
lftp -d -u "$FTP_USER,$FTP_PASS" "$FTP_HOST" <<EOF
set cmd:trace yes
set cmd:fail-exit yes
set net:max-retries 2
set net:timeout 30
mirror -v $DRYRUN -R -I '*.pl' -I '*.cgi' -I 'version.txt' $EX_ARGS ./ "$FTP_DIR"
mirror -v $DRYRUN -R -x 'img/' ./doc/ "$FTP_DIR"
mirror -v $DRYRUN -R ./doc/img/ "$FTP_DIR"/img/
bye
EOF
RC=$?
if [ $RC -ne 0 ]; then
    echo "[ERROR] mirror upload failed (rc=$RC)"; exit $RC
else
    echo "[INFO] mirror upload done"
fi

# ��2����������ꍇ
if [ -n "$2" ]; then
# _config_local.pl�����l�[��
echo "[STEP] restore config: _config_local.pl -> $CONFIG_FILE"
mv -f _config_local.pl "$CONFIG_FILE"
# _config_local.pl.bak��_config_local.pl�Ƀ��l�[��
echo "[STEP] restore config: _config_local.pl.bak -> _config_local.pl"
mv -f _config_local.pl.bak _config_local.pl

# ��~�t�@�C�����폜
echo "[STEP] remove remote halt"
lftp -d -u "$FTP_USER,$FTP_PASS" "$FTP_HOST" <<EOF
set cmd:trace yes
set cmd:fail-exit yes
set net:max-retries 2
set net:timeout 30
rm "$FTP_DIR"/halt
bye
EOF
RC=$?
if [ $RC -ne 0 ]; then
    echo "[ERROR] failed to remove halt (rc=$RC)"; exit $RC
else
    echo "[INFO] removed halt"
fi
rm halt
fi

END_EPOCH=$(date +%s)
echo "[INFO] completed in $((END_EPOCH-START_EPOCH))s"
