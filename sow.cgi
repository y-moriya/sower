#!/usr/local/bin/perl -w
# ���T�[�o�̐ݒ�ɍ��킹�ĉ������B

#-------------------------------------------------
# �l�T���� / The Stories of Werewolves
# 2006-2007 ����/asbntby
# mail: asbntby@yahoo.co.jp
# url:  http://asbntby.sakura.ne,jp/
#-------------------------------------------------

# �C���X�g�[���`�F�b�N������Ȃ� 1 �ɂ���B
my $ENABLED_INSTALLCHECK = 0;

# ���Ԃ̌v���p�i����܂�Ӗ��͂Ȃ��j
my @t = times();
$t[0] = $t[0] + $t[1];

#use strict;
#use KCatch;

srand;    # �����l�̏�����

# %ENV�̃G�~�����[�g�i�f�o�b�O�p�j
if ( !defined( $ENV{'GATEWAY_INTERFACE'} ) ) {
    my $fname = 'env.pl';
    $fname = "env_$ARGV[0].pl" if ( defined( $ARGV[0] ) );
    require "./env/$fname";
    &EmulateENV();
}

# �C���X�g�[���`�F�b�N
&InstallCheck(0) if ( ( $ENABLED_INSTALLCHECK > 0 ) && ( $ENV{'QUERY_STRING'} eq 'check' ) );

#&InstallCheck(1) if (($ENABLED_INSTALLCHECK > 0) && ($ENV{'QUERY_STRING'} eq 'inst'));

# ������
my $sow = &Init( $t[0] );

# ���O�C�����̎擾
$sow->{'debug'}->{'checklogin'} = 1;
$sow->{'user'}->logined();
$sow->{'uid'} = $sow->{'user'}->{'uid'};
$sow->{'debug'}->{'checklogin'} = 0;

# �X�V���\��
$sow->{'debug'}->raise( $sow->{'APLOG_OTHERS'}, '�������ܐF�X�ƍX�V���ɂ��A���΂炭���҂��������B', 'swbbs is halting.' )
  if ( $sow->{'cfg'}->{'ENABLED_HALT'} > 0 );

# ���͒l���A�v���P�[�V�������O�֏o��
$sow->{'debug'}->writequerylog() if ( $sow->{'cfg'}->{'LEVEL_APLOG'} == 5 );

# �e�����̎��s
&TaskBranch($sow);

# cookie�o�͒l���A�v���P�[�V�������O�֏o��
$sow->{'debug'}->writecookielog() if ( $sow->{'cfg'}->{'LEVEL_APLOG'} == 5 );

# ���ĂȂ��t�@�C�������i����܂�Ӗ��͂Ȃ��j
my @files = keys( %{ $sow->{'file'} } );
foreach (@files) {
    $sow->{'file'}->{$_}->closefile();
}

# �t�@�C�����b�N�����i�������̏ꍇ�j
$sow->{'lock'}->gunlock();

#----------------------------------------
# ������
#----------------------------------------
sub Init {
    my $t = $_[0];

    # �J�����g�f�B���N�g���̕ύX
    $ENV{'SCRIPT_FILENAME'} =~ /\/[^\/]*\z/;

    #	chdir($`) if ($& ne '');

    # �ݒ�f�[�^�̓ǂݍ���
    require "./config.pl";
    my $cfg = &SWConfig::GetConfig();

    # ��{���C�u�����ƒ萔�f�[�^�̓ǂݍ���
    require "$cfg->{'DIR_LIB'}/base.pl";
    my $sow = &SWBase::InitSW($cfg);

    # ���Ԃ̌v���p�i����܂�Ӗ��͂Ȃ��j
    $sow->{'starttime'} = $t;

    return $sow;
}

#----------------------------------------
# �e�����̎��s
#----------------------------------------
sub TaskBranch {
    my $sow      = $_[0];
    my $dirlib   = $sow->{'cfg'}->{'DIR_LIB'};
    my $dirhtml  = $sow->{'cfg'}->{'DIR_HTML'};
    my $cmd      = $sow->{'query'}->{'cmd'};
    my $noregist = &AdminIDCheck($sow);
    if ( $cmd eq 'login' ) {

        # ���O�C��
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_login.pl";
        &SWCmdLogin::CmdLogin($sow);
    }
    elsif ( $cmd eq 'logout' ) {

        # ���O�A�E�g
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_logout.pl";
        &SWCmdLogout::CmdLogout($sow);
    }
    elsif ( $cmd eq 'changepwd' ) {

        # �p�X���[�h�ύX
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_changepwd.pl";
        &SWCmdChangePwd::CmdChangePwd($sow);

    }
    elsif ( $noregist > 0 ) {

        # ID���o�^
        require "$dirhtml/html_noready.pl";
        &SWHtmlNoReady::OutHTMLNoReady( $sow, $noregist );
    }
    elsif ( ( $sow->{'uid'} ne '' ) && ( $sow->{'user'}->{'ptype'} == $sow->{'PTYPE_STOPID'} ) ) {

        # ID��~��
        require "$dirhtml/html_stopid.pl";
        &SWHtmlStopID::OutHTMLStopID( $sow, $noregist );
    }
    elsif ( $cmd eq 'editprofform' ) {

        # ���[�U�[���ҏW���
        require "$dirhtml/html_editprofform.pl";
        &SWHtmlEditProfileForm::OutHTMLEditProfileForm($sow);
    }
    elsif ( $cmd eq 'editprof' ) {

        # ���[�U�[���ҏW
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_editprof.pl";
        &SWCmdEditProfile::CmdEditProfile($sow);
    }
    elsif ( $sow->{'query'}->{'prof'} ne '' ) {

        # ���[�U�[���\��
        require "$dirlib/cmd_profile.pl";
        &SWCmdProfile::CmdProfile($sow);
    }
    elsif ( $cmd eq 'makevilpr' ) {

        # ���쐬�̃v���r���[
        require "$dirhtml/html_makevil_pr.pl";
        &SWHtmlMakeVilPreview::OutHTMLMakeVilPreview($sow);
    }
    elsif ( $cmd eq 'makevil' ) {

        # ���쐬
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_makevil.pl";
        &SWCmdMakeVil::CmdMakeVil($sow);
    }
    elsif ( $cmd eq 'editvil' ) {

        # ���ҏW
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_editvil.pl";
        &SWCmdEditVil::CmdEditVil($sow);
    }
    elsif ( $cmd eq 'editepivil' ) {

        # �{�������ύX
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_editepivil.pl";
        &SWCmdEpilogueEditVil::CmdEpilogueEditVil($sow);
    }
    elsif ( $cmd eq 'makevilform' ) {

        # ���쐬��ʕ\��
        require "$dirlib/cmd_makevilform.pl";
        &SWCmdMakeVilForm::CmdMakeVilForm($sow);
    }
    elsif ( $cmd eq 'editvilform' ) {

        # ���ҏW��ʕ\��
        require "$dirlib/cmd_editvilform.pl";
        &SWCmdEditVilForm::CmdEditVilForm($sow);
    }
    elsif ( ( $cmd eq 'vinfo' ) && ( $sow->{'outmode'} eq 'mb' ) ) {

        # ������ʕ\���i���o�C���j
        require "$dirhtml/html_vinfo_mb.pl";
        &SWHtmlVilInfoMb::OutHTMLVilInfoMb($sow);
    }
    elsif ( $cmd eq 'vinfo' ) {

        # ������ʕ\��
        require "$dirhtml/html_vinfo_pc.pl";
        &SWHtmlVilInfo::OutHTMLVilInfo($sow);
    }
    elsif ( ( ( $cmd eq 'vindex' ) || ( $cmd eq 'oldlog' ) ) && ( $sow->{'outmode'} eq 'mb' ) ) {

        # ���ꗗ�\���i���o�C���j
        require "$dirhtml/html_vindex_mb.pl";
        &SWHtmlVIndexMb::OutHTMLVIndexMb($sow);
    }
    elsif ( $cmd eq 'enformmb' ) {

        # �G���g���[��ʁi���o�C���j
        require "$dirlib/cmd_enformmb.pl";
        &SWCmdEntryFormMb::CmbEntryFormMb($sow);
    }
    elsif ( $cmd eq 'entrypr' ) {

        # �G���g���[�����v���r���[�\��
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_entrypr.pl";
        &SWCmdEntryPreview::CmdEntryPreview($sow);
    }
    elsif ( $cmd eq 'entry' ) {

        # �G���g���[
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_entry.pl";
        &SWCmdEntry::CmdEntry($sow);
    }
    elsif ( $cmd eq 'cfg' ) {

        # ���o�C���p�ݒ���
        require "$dirhtml/html_loginform_mb.pl";
        &SWHtmlLoginFormMb::OutHTMLLoginMb($sow);
    }
    elsif ( $cmd eq 'exitpr' ) {

        # �m�F��ʁi������o��j
        require "$dirhtml/html_dialog.pl";
        &SWHtmlDialog::OutHTMLDialog($sow);
    }
    elsif ( $cmd eq 'exit' ) {

        # ������o��
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_exit.pl";
        &SWCmdExit::CmdExit($sow);
    }
    elsif ( $cmd eq 'selrolepr' ) {

        # �m�F��ʁi��]��E�ύX�j
        require "$dirhtml/html_dialog.pl";
        &SWHtmlDialog::OutHTMLDialog($sow);
    }
    elsif ( $cmd eq 'selrole' ) {

        # ��]��E�ύX
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_selrole.pl";
        &SWCmdSelRole::CmdSelRole($sow);
    }
    elsif ( $cmd eq 'kick' ) {

        # ������o��
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_exit.pl";
        &SWCmdExit::CmdKick($sow);
    }
    elsif ( $cmd eq 'writepr' ) {

        # �����v���r���[�\��
        require "$dirlib/cmd_writepr.pl";
        &SWCmdWritePreview::CmdWritePreview($sow);
    }
    elsif ( $cmd eq 'wrformmb' ) {

        # �����t�H�[���\���i���o�C���j
        require "$dirlib/cmd_wrformmb.pl";
        &SWCmdWriteFormMb::CmbWriteFormMb($sow);
    }
    elsif ( $cmd eq 'wrmemoformmb' ) {

        # �����������݃t�H�[���i���o�C���j
        require "$dirlib/cmd_memoformmb.pl";
        &SWCmdWriteMemoFormMb::CmbWriteMemoFormMb($sow);
    }
    elsif ( $cmd eq 'write' ) {

        # ����
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_write.pl";
        &SWCmdWrite::CmdWrite($sow);
    }
    elsif ( $cmd eq 'editmes' ) {

        # �����C��
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_editmes.pl";
        &SWCmdEditMes::CmdEditMes($sow);
    }
    elsif ( $cmd eq 'cancel' ) {

        # �����P��
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_cancel.pl";
        &SWCmdCancel::CmdCancel($sow);
    }
    elsif ( $cmd eq 'action' ) {

        # �A�N�V����
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_action.pl";
        &SWCmdAction::CmdAction($sow);
    }
    elsif ( $cmd eq 'wrmemo' ) {

        # ������������
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_wrmemo.pl";
        &SWCmdWriteMemo::CmdWriteMemo($sow);
    }
    elsif ( $cmd eq 'editjob' ) {

        # �������ύX
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_editjob.pl";
        &SWCmdEditJobName::CmdEditJobName($sow);
    }
    elsif ( $cmd eq 'startpr' ) {

        # �m�F��ʁi���J�n�j
        require "$dirlib/vld_start.pl";
        &SWValidityStart::CheckValidityStart($sow);
        require "$dirhtml/html_dialog.pl";
        &SWHtmlDialog::OutHTMLDialog($sow);
    }
    elsif ( $cmd eq 'start' ) {

        # ���J�n
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/vld_start.pl";
        &SWValidityStart::CheckValidityStart($sow);
        require "$dirlib/cmd_start.pl";
        &SWCmdStartSession::CmdStartSession($sow);
    }
    elsif ( ( $cmd eq 'vote' ) || ( $cmd eq 'skill' ) ) {

        # ���[�^�\�͑Ώېݒ�
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_vote.pl";
        &SWCmdVote::CmdVote($sow);
    }
    elsif ( $cmd eq 'updatepr' ) {

        # �m�F��ʁi�X�V�j
        require "$dirlib/vld_start.pl";
        &SWValidityStart::CheckValidityUpdate($sow);
        require "$dirhtml/html_dialog.pl";
        &SWHtmlDialog::OutHTMLDialog($sow);
    }
    elsif ( $cmd eq 'scrapvilpr' ) {

        # �m�F��ʁi�p���j
        require "$dirlib/vld_start.pl";
        &SWValidityStart::CheckValidityUpdate($sow);
        require "$dirhtml/html_dialog.pl";
        &SWHtmlDialog::OutHTMLDialog($sow);
    }
    elsif ( $cmd eq 'commit' ) {

        # ���Ԃ�i�߂�
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_commit.pl";
        &SWCmdCommit::CmdCommit($sow);
    }
    elsif ( $cmd eq 'update' ) {

        # �X�V�i�蓮�A�f�o�b�O�p�j
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/vld_start.pl";
        &SWValidityStart::CheckValidityUpdate($sow);
        require "$dirlib/cmd_update.pl";
        &SWCmdUpdateSession::CmdUpdateSession($sow);
    }
    elsif ( $cmd eq 'debugvil' ) {

        # ���f�[�^�̕\���i�f�o�b�O�p�j
        require "$dirhtml/html_debugvil.pl";
        &SWHtmlDebugVillage::OutHTMLDebugVillage($sow);
    }
    elsif ( $cmd eq 'scrapvil' ) {

        # �p���i�蓮�A�f�o�b�O�p�j
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/vld_start.pl";
        &SWValidityStart::CheckValidityUpdate($sow);
        require "$dirlib/cmd_update.pl";
        &SWCmdUpdateSession::CmdUpdateSession($sow);
    }
    elsif ( $cmd eq 'rolematrix' ) {

        # ��E�z���\�̕\��
        require "$dirhtml/html_rolematrix.pl";
        &SWHtmlRoleMatrix::OutHTMLRoleMatrix($sow);
    }
    elsif ( $cmd eq 'extend' ) {

        # �����i�b��j
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_extend.pl";
        &SWCmdExtend::CmdExtend($sow);
    }
    elsif ( $cmd eq 'admin' ) {

        # �Ǘ����
        require "$dirhtml/html_admin.pl";
        &SWHtmlAdminManager::OutHTMLAdminManager($sow);
    }
    elsif ( $cmd eq 'restrec' ) {

        # ��эč\�z
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_restrec.pl";
        &SWCmdRestRecord::CmdRestRecord($sow);
    }
    elsif ( ( $cmd eq 'restviform' ) || ( $cmd eq 'restvi' ) ) {

        # ���ꗗ�č\�z
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_restvi.pl";
        &SWCmdRestVIndex::CmdRestVIndex($sow);
    }
    elsif ( ( $cmd eq 'restplayingvil' ) || ( $cmd eq 'restpvil' ) ) {

        # �Q�����̑��ꗗ�N���A
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_restpvil.pl";
        &SWCmdRestPlayingVil::CmdRestPlayingVil($sow);
    }
    elsif ( $cmd eq 'deletevil' ) {

        # ���f�[�^�폜
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_deletevil.pl";
        &SWCmdDeleteVil::CmdDeleteVil($sow);
    }
    elsif ( $cmd eq 'movevil' ) {

        # ���f�[�^�ړ�
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_movevil.pl";
        &SWCmdMoveVil::CmdMoveVil($sow);
    }
    elsif ( ( $cmd eq 'editpform' ) || ( $cmd eq 'editpenalty' ) ) {

        # �y�i���e�B�ݒ�E����
        if ( $ENV{'REQUEST_METHOD'} ne 'POST' ) {
            $sow->{'debug'}->raise( $sow->{'APLOG_CAUTION'}, "�s���ȃ��N�G�X�g�ł��B", "invalid request method." );
            return;
        }
        require "$dirlib/cmd_editpenalty.pl";
        &SWCmdEditPenalty::CmdEditPenalty($sow);
    }
    elsif ( $cmd eq 'rss' ) {

        # RSS�o��
        require "$dirlib/cmd_rss.pl";
        &SWCmdRSS::CmdRSS($sow);
    }
    elsif ( $cmd eq 'summary' ) {

        # ���ꗗ���o��
        require "$dirlib/cmd_rss.pl";
        &SWCmdRSS::CmdRSS($sow);
    }
    elsif ( $cmd eq 'rolelist' ) {

        # ��E�ƃC���^�[�t�F�C�X�̕\���i�������j
        require "$dirlib/cmd_rolelist.pl";
        &SWCmdRoleList::CmdRoleList($sow);
    }
    elsif ( $cmd eq 'chrlist' ) {

        # �L�����ꗗ�̕\��
        require "$dirlib/cmd_chrlist.pl";
        &SWCmdChrList::CmdChrList($sow);
    }
    elsif (( $cmd eq 'spec' )
        || ( $cmd eq 'changelog' )
        || ( $cmd eq 'howto' )
        || ( $cmd eq 'operate' )
        || ( $cmd eq 'prohibit' )
        || ( $cmd eq 'about' ) )
    {
        # �V�ѕ��^�֎~�s�ׁ^�T���̕\��
        require "$dirhtml/html_doc.pl";
        &SWHtmlDocument::OutHTMLDocument($sow);
    }
    elsif ( $cmd eq 'score' ) {

        # �l�T���̏o�́i�b��j
        require "$dirhtml/html_score.pl";
        &SWHtmlScore::OutHTMLScore($sow);
    }
    elsif ( $cmd eq 'oldlog' ) {

        # �I���ς݂̑��\��
        require "$dirhtml/html_oldlog.pl";
        &SWHtmlOldLog::OutHTMLOldLog($sow);
    }
    elsif ( ( $cmd eq 'memo' ) || ( $cmd eq 'hist' ) ) {

        # �����\��
        require "$dirlib/cmd_memo.pl";
        &SWCmdMemo::CmdMemo($sow);
    }
    elsif ( $cmd eq 'restmemo' ) {

        # �����C���f�b�N�X�č\�z
        require "$dirlib/cmd_restmemo.pl";
        &SWCmdRestMemoIndex::CmdRestMemoIndex($sow);
    }
    elsif ( $cmd eq 'mbimg' ) {

        # �g�їp��O���t�B�b�N�\��
        require "$dirlib/cmd_vlog.pl";
        &SWCmdVLog::CmdMbImg($sow);
    }
    elsif ( defined( $sow->{'query'}->{'vid'} ) ) {

        # �����O�\��
        require "$dirlib/cmd_vlog.pl";
        &SWCmdVLog::CmdVLog($sow);
    }
    else {
        # TODO: ���o�C���p���폜����
        if ( $sow->{'outmode'} eq 'mb' ) {

            # ���o�C���p���O�C�����
            require "$dirhtml/html_loginform_mb.pl";
            &SWHtmlLoginFormMb::OutHTMLLoginMb($sow);
        }
        else {
            # �g�b�v�y�[�W�\��
            require "$dirhtml/html_index.pl";
            &SWHtmlIndex::OutHTMLIndex($sow);
        }
    }

    return;
}

#----------------------------------------
# �C���X�g�[���`�F�b�N
#----------------------------------------
sub InstallCheck {
    my $inst = shift;

    print <<"_HTML_";
Content-Type: text/html; charset=Shift_JIS
Content-Style-Type: text/css

<!doctype html public "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="ja">
<head>
  <meta name="robots" content="noindex,nofollow">
  <meta name="robots" content="noarchive">
  <title>�C���X�g�[���`�F�b�N</title>
  <style type="text/css">
<!--
strong {
  color: #f00;
  background: #fff;
}
-->
  </style>
</head>

<body>

<h2>�C���X�g�[���`�F�b�N</h2>

<ul>
  <li>Perl: [OK]</li>
_HTML_

    # �ݒ�f�[�^�t�@�C���̃`�F�b�N
    &EndInstallCheck() if ( &FileCheck( '', "./config.pl", 0, 0, 0 ) == 0 );
    &FileCheck( '', "./_config_local.pl", 0, 0, 0 );

    require "./config.pl";
    my $cfg = &SWConfig::GetConfig();

    &FileCheck( $cfg, "./_info.pl", 0, 0, 0 );

    &EndInstallCheck() if ( &FileCheck( $cfg, $cfg->{'DIR_LIB'},     0, 1, 0 ) == 0 );
    &EndInstallCheck() if ( &FileCheck( $cfg, $cfg->{'DIR_RS'},      0, 1, 0 ) == 0 );
    &EndInstallCheck() if ( &FileCheck( $cfg, $cfg->{'DIR_HTML'},    0, 1, 0 ) == 0 );
    &EndInstallCheck() if ( &FileCheck( $cfg, $cfg->{'BASEDIR_DAT'}, 1, 1, 0 ) == 0 );
    &EndInstallCheck() if ( &FileCheck( $cfg, $cfg->{'FILE_LOCK'},   1, 0, $inst * 1 ) == 0 );
    &FileCheck( $cfg, $cfg->{'FILE_SOWGROBAL'}, 1, 0, $inst * 1 );
    &FileCheck( $cfg, $cfg->{'FILE_VINDEX'},    1, 0, $inst * 1 );
    &EndInstallCheck() if ( &FileCheck( $cfg, $cfg->{'DIR_USER'}, 1, 1, $inst * 2 ) == 0 );
    &EndInstallCheck() if ( &FileCheck( $cfg, $cfg->{'DIR_VIL'},  1, 1, $inst * 2 ) == 0 );
    &EndInstallCheck() if ( &FileCheck( $cfg, $cfg->{'DIR_LOG'},  1, 1, $inst * 2 ) == 0 );

    print "<li>favicon: <img src=\"$cfg->{'BASEDIR_DOC'}/$cfg->{'FILE_FAVICON'}\"></li>\n";
    print "<li>title: <img src=\"$cfg->{'DIR_IMG'}/mwtitle.jpg\"></li>\n";

    &EndInstallCheck();
    exit();
}

#----------------------------------------
# �C���X�g�[���`�F�b�N�̏I��
#----------------------------------------
sub EndInstallCheck {
    print <<"_HTML_";
</ul>

<p>
Check is completed.
</p>

</body>
</html>

_HTML_
    exit();

}

#----------------------------------------
# �t�@�C���`�F�b�N
#----------------------------------------
sub FileCheck {
    my ( $cfg, $file, $w, $x, $make ) = @_;
    my $result = 1;

    print "<li>$file: ";
    if ( -e $file ) {
        print "[OK]";
        if ( -r $file ) {
            print " / �Ǎ� [OK]";
        }
        else {
            print " / �Ǎ� <strong>[NG]</strong>";
            $result = 0;
        }
        if ( $w > 0 ) {
            if ( -w $file ) {
                print " / ���� [OK]";
            }
            else {
                print " / ���� <strong>[NG]</strong>";
                $result = 0;
            }
        }
        if ( $x > 0 ) {
            if ( -x $file ) {
                print " / ���s [OK]";
            }
            else {
                print " / ���s <strong>[NG]</strong>";
                $result = 0;
            }
        }
        print "</li>\n";
    }
    else {
        if ( $make == 1 ) {
            if ( !open( FILE, ">$file" ) ) {
                print "<strong>[NG]</strong></li>\n";
                $result = 0;
            }
            else {
                print "[Create]</li>";
                close(FILE);
            }
        }
        elsif ( $make == 2 ) {
            if ( !mkdir( "$file", $cfg->{'PERMITION_MKDIR'} ) ) {
                print "<strong>[NG]</strong></li>\n";
                $result = 0;
            }
            else {
                print "[Create]</li>";
            }
        }
        else {
            print "<strong>[NG]</strong></li>\n";
            $result = 0;
        }
    }
    return $result;
}

#----------------------------------------
# �_�~�[�L�����E�Ǘ��l�pID�̃`�F�b�N
#----------------------------------------
sub AdminIDCheck {
    my $sow  = shift;
    my $cfg  = $sow->{'cfg'};
    my $user = $sow->{'user'};

    $user->{'uid'} = $cfg->{'USERID_ADMIN'};
    my $fnameadmin = $user->GetFNameUser();
    return 1 unless ( -e $fnameadmin );

    $user->{'uid'} = $cfg->{'USERID_NPC'};
    my $fnamenpc = $user->GetFNameUser();
    return 2 unless ( -e $fnamenpc );

    return 0;
}
