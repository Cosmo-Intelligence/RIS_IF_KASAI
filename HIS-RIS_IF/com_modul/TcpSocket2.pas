unit TcpSocket;
{
���@�\����
 FTcpEmuC��FTcpEmuS����g�����ʕ�
  1.���O�o�͊֐��n
  2.�����R�[�h�n
  3.INI�t�@�C���n
  4.�o�b�t�@�n
  5.�d���X�g���[���n
  6.���̑��n
������
�V�K�쐬�F2001.09.28�F�S�� iwai
�C���F2001.12.27�F�S�� iwai
�S�p��Trim�֐��̒ǉ�
�C���F2002.01.09�F�S�� ���c
�o�[�W�������̏C��
�C���F2002.01.30�F�S�� iwai
���\1162 �̕ύX
�C���F2004.03.24�F���c
�@�@�@�@�@�@�@�@�@�d�l�ύX�ɂ��C��
�C���F2004.04.06�F���c
�@�@�@�@�@�@�@�@�@�`���[�W��񑗐M�Z�N�V�����ǉ�

}
interface //*****************************************************************
//�g�p���j�b�g---------------------------------------------------------------
uses
//�V�X�e���|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Windows,
  Messages,
  SysUtils,
  Classes,
  DBTables,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  IniFiles,
  FileCtrl,
  Registry,
  ExtCtrls,
  Math,
  IdWinsock,
  IdGlobal,
  KanaRoma,
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Gval,
  jis2sjis,
  HisMsgDef
  ;

////�^�N���X�錾-------------------------------------------------------------
type   //�\�P�b�g�ʐM����
  TSocket_Info = record
    f_Active        : string[1];  //�L�� ����
    f_EmuVisible    : string[1];  //�\�� ��\��
    f_EmuEnabled    : string[1];  //�Θb ��Θb
    f_CharCode      : string[1];  //�`�������R�[�h
  end;
type   //�\�P�b�g�ʐM  �T�[�o�ێ����
  TServer_Info = record
    f_Socket_Info   : TSocket_Info;
    f_Port          : string[5]; //�ڑ��҂��|�[�g�A�h���X
    f_TimeOut       : Longint;    //�^�C���A�E�g
  end;
type   //�\�P�b�g�ʐM  �N���C�A���g�ێ����
  TClint_Info = record
    f_Socket_Info   : TSocket_Info;
    f_IPAdrr        : string[15]; //�T�[�o�A�h���X
    f_Port          : string[5];  //�T�[�o�|�[�g
    f_TimeOut       : Longint;    //�^�C���A�E�g
    f_Timer         : Longint;    //�^�C�}�[
  end;
type   //�\��g�R�[�h�A�����@��ID�Ή��\
  TKensakiki_Def = record
    Yoyakuwaku : String; //�\��g�R�[�h
    Kensakiki  : String; //�����@��ID
  end;
type Tkensakiki = array of TKensakiki_Def;

type
  TOrderIndicate = record
    DATAKEY : String; //�f�[�^�L�[��
    DATA    : TStrings; //�R�[�h
  end;
type ASC2 = array [0..15] of String;
const
  ASC2_CODE : ASC2 =
  ('0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F');

//���O��ʒ�`���
const
  G_LOGGMSG_LEN = 22;
type
  TLog_Type = record
    f_LogMsg   : string[G_LOGGMSG_LEN];
    f_LogLevel : integer; //
  end;
type
  TXML = record
    XML_CHR : String; //XML�g�p�s����
    RIS_CHR : String; //�ϊ�����
  end;
type
  TDUMMY = record
    KENSA_TYPE : String; //�������
    DUMMY_CODE : String; //�R�[�h
  end;
//�萔�錾-------------------------------------------------------------------
//����`
const
 G_VERSION_IRAI_STR = 'Ver1.0.0';
 G_VERSION_KANJA_STR = 'Ver1.0.0';
 G_VERSION_UKETUKE_STR = 'Ver1.0.0';
 G_VERSION_JISSI_STR = 'Ver1.0.0';
 G_VERSION_SEVER_STR = 'Ver1.0.0';
 G_VERSION_SCHEMA_STR = 'Ver1.0.0';
 G_VERSION_REPORT_STR = 'Ver1.0.0';
 G_VERSION_PACS_STR = 'Ver1.0.0';
//INI�t�@�C������`---------------------------------------------------------
const
 G_TCPINI_FNAME = 'ris_tcp.ini';
 G_BACKINI_FNAME = 'ris_BackUp.ini';
 //�Z�N�V�����FSERVICE���
 g_C_SVC_SECSION      = 'SERVICE' ;
   g_SVC_SDACTIVE_KEY = 'sdactive';//�L�[
   g_SVC_RVACTIVE_KEY = 'rvactive';//�L�[
     g_SVC_ACTIVE     = '1';//
     g_SVC_DEACTIVE   = '0';//
   g_SVC_SDCYCLE_KEY  = 'sdcycle';//�L�[
     g_SVC_SDCYCLE    = '10';//
   g_SVC_RVCYCLE_KEY  = 'rvcycle';//�L�[
     g_SVC_RVCYCLE    = '10';//
 //�Z�N�V�����FRIS DB�ڑ����
 g_C_DB_SECSION     = 'DBINF';
   g_DB_NAME_KEY    = 'dbname';//�L�[
     g_DB_NAME      = 'ris_sv';//
   g_DB_UID_KEY     = 'dbuid';//�L�[
     g_DB_UID       = 'ris';//
   g_DB_PAS_KEY     = 'dbpss';//�L�[
     g_DB_PAS       = 'ris';//
   g_DB_SERVICE_KEY = 'dbservice';//�L�[
     g_DB_SERVICE   = '';//
   g_DB_RETRY_KEY   = 'openretry';//�L�[
     g_DB_RETRY     = '5';//
   g_DB_SNDKEEP_KEY = 'sndkeep';//�L�[
     g_DB_SNDKEEP   = '30';//
   g_DB_RCVKEEP_KEY = 'rcvkeep';//�L�[
     g_DB_RCVKEEP   = '30';//
 //�Z�N�V�����FRIG�ڑ����
 g_C_SOCKET_SECSION            = 'C_SOCKET';  //
 g_S_SOCKET_SECSION            = 'S_SOCKET';
   g_SOCKET_ACTIVE_KEY         = 'Active';//�L�[Active
     g_SOCKET_ACTIVE           = '1';//
     g_SOCKET_DEACTIVE         = '0';//�f�t�H���g
   g_SOCKET_EMUVISIBLE_KEY     = 'EmuVisible';//�L�[Visible
     g_SOCKET_EMUVISIBLE_TRUE  = '1';//
     g_SOCKET_EMUVISIBLE_FALSE = '0';//�f�t�H���g
   g_SOCKET_EMUENABLED_KEY     = 'EmuEnabled';//�L�[Enabled
     g_SOCKET_EMUENABLED_TRUE  = '1';//
     g_SOCKET_EMUENABLED_FALSE = '0';//�f�t�H���g
   g_SOCKET_CHARCODE_KEY       = 'CharCode';//�L�[CharCode
     g_SOCKET_CHARCODE_JIS     = '1';//
     g_SOCKET_CHARCODE_SJIS    = '0';//�f�t�H���g
   g_SOCKET_TOUT_KEY     = 'TimeOut'     ;//�L�[ ���ĺك^�C���A�E�g
     g_SOCKET_TOUT     = '10000'   ;//�f�t�H���g
   g_SOCKET_TIMER_KEY     = 'Timer'     ;//�L�[ Timer
     g_SOCKET_TIMER     = '10000'   ;//�f�t�H���g

   g_SOCKET_SIP_KEY       = 'ServerIP'     ;//�L�[IP Address
     g_SOCKET_SIP       = '000.000.000.000'   ;//�f�t�H���g
   g_SOCKET_SPORT_KEY     = 'ServerPort'     ;//�L�[ IP port
     g_SOCKET_SPORT     = ''   ;//�f�t�H���g

   g_SOCKET_PORT_KEY      = 'Port'     ;//�L�[RIS IP port
     g_SOCKET_PORT        = '0000'   ;//�f�t�H���g

 g_LOG_SECSION = 'LOG';
    g_SOCKET_LOGACTIVE_KEY  = 'LogActive'     ;//�L�[Version
        g_SOCKET_LOGACTIVE2     = '2'   ;//NG�̂ݏo��
        g_SOCKET_LOGACTIVE     =  '1'   ;//NGOK�S�ďo��
        g_SOCKET_LOGDEACTIVE   =  '0' ;//�f�t�H���g
    g_SOCKET_LOGPATH_KEY       = 'LogPath'     ;//�L�[Version
        g_SOCKET_LOGPATH       =  ''   ;//�f�t�H���g
    g_SOCKET_LOGSIZE_KEY       = 'LogSize'     ;//�L�[Version
        g_SOCKET_LOGSIZE       =  '65536'   ;//�f�t�H���g
    g_SOCKET_LOGKEEP_KEY       = 'LogKeep'     ;//�L�[Version
        g_SOCKET_LOGKEEP       =  '3'   ;//�f�t�H���g
    g_SOCKET_LOGINCMSG_KEY     = 'LogIncMsg'     ;//�L�[Version
        g_SOCKET_LOGINCMSG     =  '1'   ;//�f�t�H���g
    g_SOCKET_LOGLEVEL_KEY      = 'LogLevel'     ;//�L�[Version
        g_SOCKET_LOGLEVEL      =  '5'   ;//�f�t�H���g

 g_NAME_SECSION                = 'NAME';
    g_KANSEN_NAME01_KEY        = 'Yusen01'     ;//�L�[
        g_KANSEN_NAME01        =  ''   ;//

 g_PROF_SECSION  = 'PROF';
    g_PROF01_KEY = 'Prof01';//�L�[
        g_DEFPROF01 = '';//
    g_PROF02_KEY = 'Prof02';//�L�[
        g_DEFPROF02 = '';//

 g_SCHE_SECSION  = 'SCHEMA';
    g_SCHEMAIN_KEY = 'SchemaMaimDIR';//�L�[
        g_DEFMAIN = '';//
    g_SCHESUB_KEY = 'SchemaSubDIR';//�L�[
        g_DEFSUB = '';//
    g_SCHEDEL_KEY = 'SchemaDelDate';//�L�[
        g_DEFDELSUB = '';//

 g_PATH_SECSION  = 'PATH';
    g_PATHMAIN_KEY = 'TCP_MAINSVR_PATH';//�L�[
        g_DEFMAINPATH = '';//
    g_PATHSUB_KEY = 'TCP_BACKUPSVR_PATH';//�L�[
        g_DEFSUBPATH = '';//
 g_ACTIVE_SECSION  = 'ACTIVE';
    g_PATHACTIVE_KEY = 'TCP_ACTIVE_TXTOUT';//�L�[
        g_DEFACTIVE = '1';//

 g_RI_SECSION  = 'RI';
    g_RI01_KEY = 'RI01';//�L�[
        g_DEFRI01 = '';//
    g_RI02_KEY = 'RI02';//�L�[
        g_DEFRI02 = '';//
    g_RI03_KEY = 'RI03';//�L�[
        g_DEFRI03 = '';//
    g_RI04_KEY = 'RI04';//�L�[
        g_DEFRI04 = '';//
    g_RI05_KEY = 'RI05';//�L�[
        g_DEFRI05 = '';//
    g_RI06_KEY = 'RI06';//�L�[
        g_DEFRI06 = '';//
    g_RI07_KEY = 'RI07';//�L�[
        g_DEFRI07 = '';//

 g_KIKI_SECSION  = 'KIKI';
 g_KENZO_SECSION  = 'KENZO';
 g_SATUEI_SECSION  = 'SATUEI';
 g_KANJA_SECSION  = 'KANJA';
 //�I�[�_�w�����Z�N�V����
 g_ORDERINDICATE_SECSION  = 'ORDERINDICATE';
    g_ORDERINDICATE_KEY = 'Comment_Rep';//�L�[
        g_DEFORDERINDICATE = '';//
 //���҃v���t�@�C�����Z�N�V����
 g_KANJAPROF_SECSION  = 'PROFILE';
 g_KANJAPROFCODE_SECSION  = 'PROFILECODE';
 //XML���Z�N�V����
 g_XML_SECSION  = 'XML';
 //�������Z�N�V����
 g_HOUKOU_SECSION  = 'HOUKOU';
 //���@���Z�N�V����
 g_HOUHOU_SECSION  = 'HOUHOU';
 //2004.03.24
 //�I���N���G���[���Z�N�V����
 g_ORAERR_SECSION  = 'ORAERR';
    g_ORAERR_KEY = 'ORAERRNO';//�L�[
        g_DEFORAERR = '';//
 //2004.04.06
 //�`���[�W��񑗐M�L���Z�N�V����
 //g_CHARGE_SECSION  = '';
 //   g_CHARGE_KEY = '';//�L�[
        g_DEFZOECHARGE = '';//
        g_DEFSHGCHARGE = '';//

//�Q�ƒ萔-----------------------------------------------------------------
//LOG�t�@�C������`�i���e�j
const
 G_LOG_LINE_HEAD_OK = 'OK'; //�ړ��q ����
 G_LOG_LINE_HEAD_NG = 'NG'; //�ړ��q �ُ�
 G_LOG_LINE_HEAD_NP = '  '; //�ړ��q �R�����g
//LOG�t�@�C������`(���O�̎�ʔԍ��ƃ��x���ƃ��O�̎�ʕ�����)
//���s���O���w����l������Initial�ő����������
const
 G_LOG_PKT_PTH_DEF             = '.LOG';//LOG�t�@�C���g���q
 G_MAX_LOG_TYPE                = 10; //���O�̎�ʂ̌��ő�l
 //�T�[�r�X���� URH_SDSvc
 G_LOG_KIND_SVC_NUM            = 1;
 G_LOG_KIND_SVC                = 'Servic            ����';//�g�p
 G_LOG_KIND_SVC_LEVEL          = 1;
 //�\�P�b�g�T�[�o  FTcpEmuS
 G_LOG_KIND_SK_SV_NUM          = 2;
 G_LOG_KIND_SK_SV              = 'Socket�T�[�o      ����';//�g�p
 G_LOG_KIND_SK_SV_LEVEL        = 4;
 //�\�P�b�g�N���C�A���g URH_SDSvc  FTcpEmuC
 G_LOG_KIND_SK_CL_NUM          = 3;
 G_LOG_KIND_SK_CL              = 'Socket�N���C�A���g����';//�g�p
 G_LOG_KIND_SK_CL_LEVEL        = 4;
 //DB��{����
 G_LOG_KIND_DB_NUM             = 4;
 G_LOG_KIND_DB                 = 'DBase             ����';//�g�p
 G_LOG_KIND_DB_LEVEL           = 2;
 //DB ���擾����
 G_LOG_KIND_DB_IN_NUM          = 5;
 G_LOG_KIND_DB_IN              = '���ʒm          ����';//
 G_LOG_KIND_DB_IN_LEVEL        = 5;
 //DB ���ݒ菈��
 G_LOG_KIND_DB_OUT_NUM         = 6;
 G_LOG_KIND_DB_OUT             = 'DBase ���ݒ�    ����';//
 G_LOG_KIND_DB_OUT_LEVEL       = 3;
 //DB �d����͏���
 G_LOG_KIND_MS_ANLZ_NUM        = 7;
 G_LOG_KIND_MS_ANLZ            = 'MSG   ���        ����';//
 G_LOG_KIND_MS_ANLZ_LEVEL      = 6;
 //����`
 G_LOG_KIND_NG_NUM             = 8;
 G_LOG_KIND_NG                 = '����`            ����';//
 G_LOG_KIND_NG_LEVEL           = 6;

//------------------------------------------------------------------------------
// �ڍ�***** �\�P�b�g�ʐM �G���[���
const
  G_TCPSND_PRTCL00='00';
  G_TCPSND_PRTCL_ERR00='00';//����
  G_TCPSND_PRTCL_ERR01='01';//���M���s
  G_TCPSND_PRTCL_ERR02='02';//������
  G_TCPSND_PRTCL_ERR03='03';//�ԓ����s�^����
  G_TCPSND_PRTCL_OK   = G_TCPSND_PRTCL00+G_TCPSND_PRTCL_ERR00;//����

const
  //���ʃ��b�Z�[�W
  CST_INI_OK_MSG = 'ini�t�@�C���̓ǂݍ��݂ɐ������܂����B';
  CST_INI_NG_MSG = 'ini�t�@�C���̓ǂݍ��݂Ɏ��s���܂����B';
  CST_SRV_ERR_MSG = 'ini�t�@�C���ŃT�[�r�X���L���ɂȂ��Ă��܂���B';
  CST_DB_ERR_MSG = '�f�[�^�x�[�X�ւ̐ڑ��Ɏ��s���܂����B';
  CST_DB_OK_MSG  = '�f�[�^�x�[�X�ւ̐ڑ��ɐ������܂����B';
  CST_DB_END_MSG = '*****RIS DB�ڑ����I�����܂���*****';
  //��M�p
  CST_JYUSINTBLDEL_OK_MSG  = '��M�I�[�_�e�[�u���s�v���R�[�h�̍폜�ɐ������܂����B';
  CST_JYUSINTBLDEL_NG_MSG  = '��M�I�[�_�e�[�u���s�v���R�[�h�̍폜�Ɏ��s���܂����B';

  CST_SAVE_ON  = '1';
  CST_SAVE_OFF = '0';
  CST_IRAI_BACK  = 'R';
  CST_KANJA_BACK = 'P';
  CST_IDO_BACK   = 'M';

  CST_NON_TITLE = 'N';

  CST_ORDERINDICATE_NON_REP = '0';

//���̑��萔-----------------------------------------------------------------
const
  CST_SEX = 'SEX';
  CST_SISETU = 'SIS';
//�������ߍ��ݒ�`�̏ꍇ
type
   TLog_Type_Info     = array[1..G_MAX_LOG_TYPE] of TLog_Type;
const
  g_Log_Type_Info : TLog_Type_Info = (
                                // 1:�T�[�r�X����
                                (f_LogMsg : G_LOG_KIND_SVC;
                                 f_LogLevel:G_LOG_KIND_SVC_LEVEL),
                                // 2:�\�P�b�g�T�[�o
                                (f_LogMsg : G_LOG_KIND_SK_SV;
                                 f_LogLevel:G_LOG_KIND_SK_SV_LEVEL),
                                // 3:�\�P�b�g�N���C�A���g
                                (f_LogMsg : G_LOG_KIND_SK_CL;
                                 f_LogLevel:G_LOG_KIND_SK_CL_LEVEL),
                                // 4:DB��{����
                                (f_LogMsg : G_LOG_KIND_DB;
                                 f_LogLevel:G_LOG_KIND_DB_LEVEL),
                                // 5:DB ���擾����
                                (f_LogMsg : G_LOG_KIND_DB_IN;
                                 f_LogLevel:G_LOG_KIND_DB_IN_LEVEL),
                                // 6:DB ���ݒ菈��
                                (f_LogMsg : G_LOG_KIND_DB_OUT;
                                 f_LogLevel:G_LOG_KIND_DB_OUT_LEVEL),
                                // 7:DB �d����͏���
                                (f_LogMsg : G_LOG_KIND_MS_ANLZ;
                                 f_LogLevel:G_LOG_KIND_MS_ANLZ_LEVEL),
                                // 8:����`
                                (f_LogMsg : G_LOG_KIND_NG;
                                 f_LogLevel:G_LOG_KIND_NG_LEVEL),
                                // 9:
                                (f_LogMsg : G_LOG_KIND_NG;
                                 f_LogLevel:G_LOG_KIND_NG_LEVEL),
                                // 10:
                                (f_LogMsg : G_LOG_KIND_NG;
                                 f_LogLevel:G_LOG_KIND_NG_LEVEL)
                                );

//���R�[�h�y�і��̒�`
//2001.09.07
// ����
GPCST_SEX_1='1';
GPCST_SEX_2='2';
GPCST_SEX_3='3';
GPCST_SEX_1_NAME='M';
GPCST_SEX_2_NAME='F';
GPCST_SEX_3_NAME='�s��';
GPCST_SEX_3P_NAME='O';
// ���O�敪
{2004.01.08
GPCST_NYUGAIKBN_1='1';
GPCST_NYUGAIKBN_2='2';
2004.01.08}
GPCST_NYUGAIKBN_1='2';
GPCST_NYUGAIKBN_2='1';
{2002.10.30
GPCST_NYUGAIKBN_1_NAME='���@';
GPCST_NYUGAIKBN_2_NAME='�O��';
2002.10.30}
GPCST_NYUGAIKBN_1_NAME='�O��';
GPCST_NYUGAIKBN_2_NAME='���@';
// ��v���
GPCST_KAIKEITYPE_0='0';
GPCST_KAIKEITYPE_1='1';
GPCST_KAIKEITYPE_2='2';
GPCST_KAIKEITYPE_3='3';
GPCST_KAIKEITYPE_0_NAME='�㎖';
GPCST_KAIKEITYPE_1_NAME='����';
GPCST_KAIKEITYPE_2_NAME='�Z��';
GPCST_KAIKEITYPE_3_NAME='����';
// �o�^�V�X�e���敪  _SYSK
GPCST_CODE_SYSK_RIS = 'R';
GPCST_CODE_SYSK_HIS = 'H';
GPCST_NAME_SYSK_RIS = 'RIS';
GPCST_NAME_SYSK_HIS = 'HIS';
// �����i�� _KENSIN
GPCST_CODE_KENSIN_0 = '0';
GPCST_CODE_KENSIN_1 = '1';
GPCST_CODE_KENSIN_2 = '2';
GPCST_CODE_KENSIN_3 = '3';
GPCST_CODE_KENSIN_4 = '4';
GPCST_NAME_KENSIN_0 = '����';
GPCST_NAME_KENSIN_1 = '���';
GPCST_NAME_KENSIN_2 = '����';
GPCST_NAME_KENSIN_3 = '����';
GPCST_NAME_KENSIN_4 = '���~';
GPCST_RYAKU_NAME_KENSIN_0 = '��';
GPCST_RYAKU_NAME_KENSIN_1 = '��';
GPCST_RYAKU_NAME_KENSIN_2 = '��';
GPCST_RYAKU_NAME_KENSIN_3 = '��';
GPCST_RYAKU_NAME_KENSIN_4 = '�~';
// �����i�� _KENSIN_SUB
GPCST_CODE_KENSIN_SUB_5 = '5';
GPCST_CODE_KENSIN_SUB_6 = '6';
GPCST_CODE_KENSIN_SUB_7 = '7';
GPCST_CODE_KENSIN_SUB_8 = '8';
GPCST_CODE_KENSIN_SUB_9 = '9';
GPCST_CODE_KENSIN_SUB_10= '10';
GPCST_NAME_KENSIN_SUB_5 = '�ďo';
GPCST_NAME_KENSIN_SUB_6 = '�x��';
GPCST_NAME_KENSIN_SUB_7 = '�m��';
GPCST_NAME_KENSIN_SUB_8 = '�ۗ�';
GPCST_NAME_KENSIN_SUB_9 = '�Č�';
GPCST_NAME_KENSIN_SUB_10= '�Ď�';
GPCST_RYAKU_NAME_KENSIN_SUB_5 = '��';
GPCST_RYAKU_NAME_KENSIN_SUB_6 = '�x';
GPCST_RYAKU_NAME_KENSIN_SUB_7 = '�m';
GPCST_RYAKU_NAME_KENSIN_SUB_8 = '��';
GPCST_RYAKU_NAME_KENSIN_SUB_9 = '��';
GPCST_RYAKU_NAME_KENSIN_SUB_10= '��';

// �����˗��t���O _SYOKEN
GPCST_CODE_SYOKEN_0 = '0';
GPCST_CODE_SYOKEN_1 = '1';
GPCST_NAME_SYOKEN_0 = '�s�v';
GPCST_NAME_SYOKEN_1 = '�v';
// RI���{�t���O _RI
GPCST_CODE_RI_0 = '0';
GPCST_CODE_RI_1 = '1';
GPCST_NAME_RI_0 = '���ׂȂ�';
GPCST_NAME_RI_1 = '���ׂ���';
// ���ԊO�敪  _JIKAN
GPCST_CODE_JIKAN_0 = '0';
GPCST_CODE_JIKAN_1 = '1';
GPCST_CODE_JIKAN_2 = '2';
GPCST_CODE_JIKAN_3 = '3';
GPCST_NAME_JIKAN_0 = '�莞';
GPCST_NAME_JIKAN_1 = '�\��O';
GPCST_NAME_JIKAN_2 = '�x��';
GPCST_NAME_JIKAN_3 = '����';
// �B�e�i�� _SATUEI
GPCST_CODE_SATUEI_0 = '0';
GPCST_CODE_SATUEI_1 = '1';
GPCST_CODE_SATUEI_2 = '2';
GPCST_NAME_SATUEI_0 = '���B�e';
GPCST_NAME_SATUEI_1 = '�B�e��';
GPCST_NAME_SATUEI_2 = '�B�e�L�����Z��';
// ���e�܋敪 _ZOUEI
GPCST_CODE_ZOUEI_0 = '0';
GPCST_CODE_ZOUEI_1 = '1';
GPCST_CODE_ZOUEI_2 = '2';
GPCST_CODE_ZOUEI_3 = '3';
GPCST_CODE_ZOUEI_4 = '4';
GPCST_NAME_ZOUEI_0 = '';
GPCST_NAME_ZOUEI_1 = '���e��';
GPCST_NAME_ZOUEI_2 = '���';
GPCST_NAME_ZOUEI_3 = '�J�e';
GPCST_NAME_ZOUEI_4 = '����';
// ��Z�敪 SYUGI
GPCST_CODE_SYUGI_0 = '0';
GPCST_CODE_SYUGI_1 = '1';
GPCST_CODE_SYUGI_2 = '2';
//GPCST_CODE_SYUGI_3 = '3';
GPCST_NAME_SYUGI_0 = '';
GPCST_NAME_SYUGI_1 = '��{';
GPCST_NAME_SYUGI_2 = '���u';
//GPCST_NAME_SYUGI_3 = '�ȊO�͎�Z';
// �E��敪
{GPCST_SYOKUSHU_1='1';
GPCST_SYOKUSHU_2='2';
GPCST_SYOKUSHU_3='3';
GPCST_SYOKUSHU_4='4';
GPCST_SYOKUSHU_1_NAME='��t';
GPCST_SYOKUSHU_2_NAME='�Z�t';
GPCST_SYOKUSHU_3_NAME='�Ō�w';
GPCST_SYOKUSHU_4_NAME='�E��';}
//2001.09.06
GPCST_SYOKUSHU_1='1';
GPCST_SYOKUSHU_2='2';
GPCST_SYOKUSHU_3='3';
GPCST_SYOKUSHU_4='4';
GPCST_SYOKUSHU_1_NAME='��t';
GPCST_SYOKUSHU_2_NAME='������';
GPCST_SYOKUSHU_3_NAME='�Z�t';
GPCST_SYOKUSHU_4_NAME='�Ō�t';
//�����[�ԍ�
GPCST_CHUHYO_BASE  = '00';
GPCST_CHUHYO_CH010 = '01';
GPCST_CHUHYO_CH020 = '02';
GPCST_CHUHYO_CH030 = '03';
GPCST_CHUHYO_CH040 = '04';
GPCST_CHUHYO_CH050 = '05';
GPCST_CHUHYO_CH060 = '06';
GPCST_CHUHYO_CH070 = '04';
//�������ĕ\���^�C�g��
GPCST_AUTO_DISP_TITLE  = '�����ĕ\�����|';
//2001.09.10
//���A��w��
GPCST_KITAKU_0 = '0';
GPCST_KITAKU_1 = '1';
GPCST_KITAKU_0_NAME = '���A��';
GPCST_KITAKU_1_NAME = '�A���';
//2001.09.10
//���a���A��TEL
GPCST_TEL_0 = '0';
GPCST_TEL_1 = '1';
GPCST_TEL_0_NAME = '��';
GPCST_TEL_1_NAME = '�v';
//2001.09.11
//�������v��
GPCST_SYOKEN_YOUHI_0 = '0';
GPCST_SYOKEN_YOUHI_1 = '1';
GPCST_SYOKEN_YOUHI_0_NAME = '�s�v';
GPCST_SYOKEN_YOUHI_1_NAME = '�K�v';
// �B�e�i��
GPCST_CODE_SATUEIS_0 = '0';
GPCST_CODE_SATUEIS_1 = '1';
GPCST_CODE_SATUEIS_2 = '2';
GPCST_NAME_SATUEIS_0 = '��';
GPCST_NAME_SATUEIS_1 = '��';
GPCST_NAME_SATUEIS_2 = '���~';
GPCST_NAME_SATUEIS2_0 = '������';
GPCST_NAME_SATUEIS2_1 = '���͍�';
GPCST_NAME_SATUEIS2_2 = '���~';
//���摜�m�F
GPCST_GAZOU_KAKUNIN_0 = '0';
GPCST_GAZOU_KAKUNIN_1 = '1';
GPCST_GAZOU_KAKUNIN_0_NAME = '��';
GPCST_GAZOU_KAKUNIN_1_NAME = '��';
//2001.09.20
//���A��w��
GPCST_KITAKU_0_G = '0';
GPCST_KITAKU_1_G = '1';
GPCST_KITAKU_0_NAME_G = '��';
GPCST_KITAKU_1_NAME_G = '�A';
//���a���A��TEL
GPCST_TEL_0_G = '0';
GPCST_TEL_1_G = '1';
GPCST_TEL_0_NAME_G = '';
GPCST_TEL_1_NAME_G = 'TEL';
//���摜�m�F
GPCST_GAZOU_KAKUNIN_0_G = '0';
GPCST_GAZOU_KAKUNIN_1_G = '1';
GPCST_GAZOU_KAKUNIN_0_NAME_G = '��';
GPCST_GAZOU_KAKUNIN_1_NAME_G = '��';
//����������������������������������������������������������������
//�֐������̒萔//
//�Ǘ��e�[�u��
G_KANRI_TBL_RMODE = '0';//�Q�ƃ��[�h
G_KANRI_TBL_WMODE = '1';//�X�V���[�h

//���˗��敪 2001.03.15
GPCST_KBN_10 = '10'; //�P���B�e
GPCST_KBN_15 = '15'; //�߰���َB�e
GPCST_KBN_20 = '20'; //�f�w�B�e
GPCST_KBN_30 = '30'; //X�����e
GPCST_KBN_50 = '50'; //CT
GPCST_KBN_60 = '60'; //MR
GPCST_KBN_70 = '70'; //RI
GPCST_KBN_80 = '80'; //���Ǒ��e
GPCST_KBN_90 = '90'; //�������
{2001.09.01 Start}
//����w���v�ʐ^����
CST_DSB = 'DSB';
//����w���v��������
CST_DTB = 'DTB';
//����Z�敪
CST_SYUGI = 'SHG';
{2001.09.01 End}
//2001.09.03
//�����e�܋敪
CST_ZOUEI = 'ZOE';
//2001.09.04
CST_SAYUU_DEF = '�Ȃ�';
//2001.09.03
//���E���敪
CST_SYOKUIN = 'SHK';
{2001.09.05 Start}
//���������
{2003.11.26 �ύX
GPCST_SYUBETU_01 = '01'; //��ʎB�e
GPCST_SYUBETU_02 = '02'; //DIP�DIC
GPCST_SYUBETU_03 = '03'; //Portable
GPCST_SYUBETU_04 = '04'; //MMG
GPCST_SYUBETU_05 = '05'; //���[����
GPCST_SYUBETU_06 = '06'; //���[����
GPCST_SYUBETU_07 = '07'; //CT
GPCST_SYUBETU_08 = '08'; //MRI
GPCST_SYUBETU_09 = '09'; //XTV
GPCST_SYUBETU_10 = '10'; //���Ǒ��e
GPCST_SYUBETU_11 = '11'; //�S�J�e
GPCST_SYUBETU_12 = '12'; //Echo
GPCST_SYUBETU_13 = '13'; //RI
GPCST_SYUBETU_14 = '14'; //�Q�Ɖ摜�捞
GPCST_SYUBETU_15 = '15'; //�t�B�����o��
GPCST_SYUBETU_20 = '20'; //���Ìv��CT
GPCST_SYUBETU_21 = '21'; //���Èʒu����
}

{2003.12.06 �ύX
GPCST_SYUBETU_01 = '01'; //���     <�B�e�n>
GPCST_SYUBETU_02 = '02'; //����     <�����n>
GPCST_SYUBETU_03 = '03'; //����     <�����n>
GPCST_SYUBETU_04 = '04'; //CT       <�����n>
GPCST_SYUBETU_05 = '05'; //MRI      <�����n>
GPCST_SYUBETU_06 = '06'; //�j��w   <�����n>
GPCST_SYUBETU_07 = '07'; //����     <�����n>
GPCST_SYUBETU_08 = '08'; //�~����� <�B�e�n>
GPCST_SYUBETU_09 = '09'; //�~������ <�����n>
GPCST_SYUBETU_10 = '10'; //�~��CT   <�����n>
GPCST_SYUBETU_11 = '11'; //����     <�B�e�n>
GPCST_SYUBETU_12 = '12'; //����     <�����n>
GPCST_SYUBETU_13 = '';   //���g�p
GPCST_SYUBETU_14 = '';   //���g�p
GPCST_SYUBETU_15 = '';   //���g�p
GPCST_SYUBETU_20 = '';   //���g�p
GPCST_SYUBETU_21 = '';   //���g�p}

{2003.12.19 �ύX
GPCST_SYUBETU_11 = '11'; //���     �@�@�@<�B�e�n>
GPCST_SYUBETU_12 = '12'; //���ꌟ��     �@<�B�e�n>
GPCST_SYUBETU_13 = '13'; //����     �@�@�@<�����n>
GPCST_SYUBETU_14 = '14'; //����       �@�@<�����n>
GPCST_SYUBETU_15 = '15'; //����      �@�@ <�����n>
GPCST_SYUBETU_16 = '16'; //CT   �@�@�@�@�@<�����n>
GPCST_SYUBETU_17 = '17'; //MR    �@�@�@�@ <�����n>
GPCST_SYUBETU_18 = '18'; //�j��w�@�@�@�@ <�����n>
GPCST_SYUBETU_19 = '19'; //���� �@�@�@�@�@<�����n>
GPCST_SYUBETU_20 = '20'; //���Èʒu����   <�B�e�n>
GPCST_SYUBETU_21 = '21'; //���Èʒu����CT <�����n>
GPCST_SYUBETU_22 = '22'; //�~�����     �@<�B�e�n>
GPCST_SYUBETU_23 = '23'; //�~������       <�����n>
GPCST_SYUBETU_24 = '24'; //�~��CT         <�����n>
GPCST_SYUBETU_25 = '25';   //���g�p
GPCST_SYUBETU_26 = '26';   //���g�p
GPCST_SYUBETU_27 = '27';   //���g�p}

GPCST_SYUBETU_01 = '01'; //���     �@�@�@<�B�e�n>
GPCST_SYUBETU_12 = '12'; //���ꌟ��     �@<�B�e�n>
GPCST_SYUBETU_03 = '03'; //����     �@�@�@<�����n>
GPCST_SYUBETU_10 = '10'; //����       �@�@<�����n>
GPCST_SYUBETU_08 = '08'; //����      �@�@ <�����n>
GPCST_SYUBETU_05 = '05'; //CT   �@�@�@�@�@<�����n>
GPCST_SYUBETU_06 = '06'; //MR    �@�@�@�@ <�����n>
GPCST_SYUBETU_07 = '07'; //�j��w�@�@�@�@ <�����n>
GPCST_SYUBETU_09 = '09'; //���� �@�@�@�@�@<�����n>
GPCST_SYUBETU_14 = '14'; //���Èʒu����   <�B�e�n>
GPCST_SYUBETU_15 = '15'; //���Èʒu����CT <�����n>
GPCST_SYUBETU_31 = '31'; //�~�����     �@<�B�e�n>
GPCST_SYUBETU_38 = '38'; //�ʊٌ���       <�����n>
GPCST_SYUBETU_35 = '35'; //�ʊ�CT         <�����n>
GPCST_SYUBETU_13 = '13'; //��ߎ��߰����   <�B�e�n> 2003.12.19�ǉ�



//���v���Z�b�gID�ԍ��擾�p
CST_PRESET = 'PRE';
{2001.09.05 End}
//2001.09.07
//�����O�敪�擾�p
CST_NYUGAI = 'NYU';
//���v�����^�^�C�v
GPCST_PRI_TYPE_01 = '���[�U�[';         //���[�U�[
GPCST_PRI_TYPE_02 = '���x��';           //���x��
GPCST_PRI_TYPE_03 = '�h�b�g�C���p�N�g'; //�h�b�g�C���p�N�g
//2001.09.21
//���v�����^�^�C�v
GPCST_PRI_TYPE_NO_01 = '1';     //���[�U�[
GPCST_PRI_TYPE_NO_02 = '2';     //���x��
GPCST_PRI_TYPE_NO_03 = '3';     //�h�b�g�C���p�N�g
//2001.11.10
GPCST_SATUEISITU_KYUKYU = '�~�}'; //�B�e��=�~�}
//2002.09.20
//���F�֗v��
GPCST_COLOR_YOUHI_0 = '0';
GPCST_COLOR_YOUHI_1 = '1';
GPCST_COLOR_YOUHI_0_NAME = '�s�v';
GPCST_COLOR_YOUHI_1_NAME = '�K�v';
//2002.09.24
//�����E�g�p
GPCST_SAYUU_0 = '0';
GPCST_SAYUU_1 = '1';
GPCST_SAYUU_0_NAME = '���Ȃ�';
GPCST_SAYUU_1_NAME = '����';
//2002.09.24
//���ǉe�v��
GPCST_DOKUEI_0 = '0';
GPCST_DOKUEI_1 = '1';
GPCST_DOKUEI_2 = '2';
GPCST_DOKUEI_0_NAME = '�s�v';
GPCST_DOKUEI_1_NAME = '�K�v';
GPCST_DOKUEI_2_NAME = '�ً}';
//2002.09.24
//�����u���g�p
GPCST_SHOTI_0 = '0';
GPCST_SHOTI_1 = '1';
GPCST_SHOTI_0_NAME = '���Ȃ�';
GPCST_SHOTI_1_NAME = '����';
GPCST_SHOTI_0_RYAKU_NAME = '';
GPCST_SHOTI_1_RYAKU_NAME = '�g';
//2002.09.24
//���v���e
GPCST_YZOUEI_0 = '0';
GPCST_YZOUEI_1 = '1';
GPCST_YZOUEI_0_NAME = '';
GPCST_YZOUEI_1_NAME = '��';
//2002.09.24
//�������敪
GPCST_SYORI_1 = '01';
GPCST_SYORI_2 = '02';
GPCST_SYORI_3 = '03';
GPCST_SYORI_1_NAME = '�V�K';
GPCST_SYORI_2_NAME = '�X�V';
GPCST_SYORI_3_NAME = '�폜';
//2002.10.03
//�����Ȉ�t����敪
GPCST_ISITATIAI_0 = '0';
GPCST_ISITATIAI_1 = '1';
GPCST_ISITATIAI_0_NAME = '����Ȃ�';
GPCST_ISITATIAI_1_NAME = '�����';
GPCST_ISITATIAI_0_RyakuNAME = '���Ȃ�';
GPCST_ISITATIAI_1_RyakuNAME = '����';
GPCST_ISITATIAI_0_RYAKU = '';
GPCST_ISITATIAI_1_RYAKU = '�L';
//2002.10.03
//���f�W�^�C�Y�i��
GPCST_DEJITAI_0 = '0';
GPCST_DEJITAI_1 = '1';
GPCST_DEJITAI_0_NAME = '��';
GPCST_DEJITAI_1_NAME = '��';
//�������i��
GPCST_KENZOU_0 = '0';
GPCST_KENZOU_1 = '1';
GPCST_KENZOU_2 = '2';
GPCST_KENZOU_0_NAME = '��';
GPCST_KENZOU_1_NAME = '��';
GPCST_KENZOU_2_NAME = '��';
//2002.10.05
//��FCR�A�g
GPCST_FCR_0 = '0';
GPCST_FCR_1 = '1';
GPCST_FCR_0_NAME = '���Ȃ�';
GPCST_FCR_1_NAME = '����';
//2002.10.05
//��MPPS�Ή�
GPCST_MPPS_0 = '0';
GPCST_MPPS_1 = '1';
GPCST_MPPS_0_NAME = '���Ȃ�';
GPCST_MPPS_1_NAME = '����';

GPCST_ERR_0 = '0';
GPCST_ERR_1 = '1';
GPCST_ERR_0_NAME = '���Ȃ�';
GPCST_ERR_1_NAME = '����';
//2002.10.05
//����Z�敪��
//GPCST_SHG_1_NAME = '��{';
GPCST_SHG_1_NAME = '���Z'; //2004.02.01 koba
GPCST_SHG_2_NAME = '���u';
//����v���M���
GPCST_KAIKEI_0 = '0';
GPCST_KAIKEI_1 = '1'  ;
GPCST_KAIKEI_0_NAME = '���Ȃ�';
GPCST_KAIKEI_1_NAME = '����'  ;

//���敪Ͻ�ID
GPCST_KBN_ID_SHOKEN   = '3';
GPCST_KBN_ID_KENSAKBN = '4';
GPCST_KBN_ID_3D = '16';
GPCST_KBN_ID_Cancel = '15';

//��RI�I�[�_�敪
GPCST_RI_ORDER_0 = '0';
GPCST_RI_ORDER_1 = '1'  ;
GPCST_RI_ORDER_2 = '2'  ;
GPCST_RI_ORDER_0_NAME = '�Ȃ�';
GPCST_RI_ORDER_1_NAME = '����'  ;
GPCST_RI_ORDER_2_NAME = '����'  ;
//�����ID����
GPCST_GAMEN_0 ='B1';   //��t�����ꗗ���ID
GPCST_GAMEN_1 ='E1';   //����Dr.�w�����ID
GPCST_GAMEN_2 ='D1';   //������t�ꗗ���ID
GPCST_GAMEN_3 ='G1';   //�B�e�Ɩ����ID
GPCST_GAMEN_4 ='H1';   //�����Ɩ��ꗗ���ID
GPCST_GAMEN_5 ='J1';   //Portable�Ɩ����ID
GPCST_GAMEN_6 ='K1';   //RI�Ɩ����ID
CPCST_GAMEN_7 ='N1';   //�t�B�����Ɩ����ID
GPCST_GAMEN_8 ='F1';   //�����Ɩ����ID
GPCST_GAMEN_9 ='X3';   //�����䒠�ꗗ���ID
GPCST_GAMEN_10='P1';   //���Ҏ��шꗗ���
//���I�[�_�w���R�����g
GPCST_ORDER_COMMENT_131 = '131';//������f�@����
GPCST_ORDER_COMMENT_132 = '132';//������f�@�L��
//��������
GPCST_MRSA_SECTION_KEY = 'NAMECARDPRINT';
GPCST_MRSA_CODE_KEY = 'MRSACODE';
GPCST_MRSA_NAME_KEY = 'MRSANAME';

CST_PATH_GRID_COLUMNS   : string = 'C:\ris\columns\';//��د�޶�ѻ��ޕۑ���
//��Web�p �w������@
{2004.03.09
GPCST_WED_KANJAID = 'patientid';
GPCST_WED_KENSADAY = 'date';
GPCST_WED_ORDERNO = 'accession';
GPCST_WED_MODALITY = 'modality';
2004.03.09}
//2004.03.09
GPCST_WED_KANJAID = 'ID';
GPCST_WED_KENSADAY = 'DATE';
//2004.03.29 GPCST_WED_ORDERNO = 'ODERNO';
GPCST_WED_ORDERNO = 'ORDERNO';
GPCST_WED_MODALITY = 'MODALITY';
//���˗���w�����~���
GPCST_FUTUUDOKUEI_CODE         = '101'; //���ʓǉe
GPCST_KINKYUUDOKUEI_CODE       = '102'; //�ً}�ǉe
GPCST_DOKUHOKA_CODE            = '111'; //�ƕ���
GPCST_KURUMAISU_CODE           = '112'; //�Ԉ֎q
GPCST_SUTORECCHA_CODE          = '113'; //�X�g���b�`���[
GPCST_BED_CODE                 = '114'; //�x�b�h
GPCST_NINSINNASI_CODE          = '121'; //�D�P�Ȃ�
GPCST_NINSINARI_CODE           = '122'; //�D�P�L��
GPCST_NINSINFUMEI_CODE         = '123'; //�S�g�s��
GPCST_KESASAGOSINSATUNASI_CODE = '131'; //������f�@�Ȃ�
GPCST_KENSAGOSANSATUARI_CODE   = '132'; //������f�@����
GPCST_CALLFUYOU_CODE           = '141'; //Call�s�v
GPCST_DRCALL_CODE              = '142'; //�B�e���S����Call
GPCST_BYOUSITU_CODE            = '201'; //�a��
GPCST_SHUJUTUSITU_CODE         = '202'; //��p��
GPCST_KAIFUKUSITU_CODE         = '203'; //�񕜎�
GPCST_KINKYUDORAISITU_CODE     = '204'; //�ً}�h���C��
GPCST_KINKYUWETOSITU_CODE      = '205'; //�ً}�E�F�b�g��
GPCST_GAIRAI_CODE              = '206'; //�O��
GPCST_JINKINOUSEIJOU_CODE      = '301'; //�t�@�\����
GPCST_JINKINOUIJOU_CODE        = '302'; //�t�@�\�ُ�
GPCST_JINKINOUFUMEI_CODE       = '303'; //�t�@�\�s��
GPCST_ZENSOKUNASI_CODE         = '311'; //�b���Ȃ�
GPCST_ZENSOKUARI_CODE          = '312'; //�b������
//2003.05.30
GPCST_ZENSOKUFUMEI_CODE        = '313'; //�b���s��
//2003.05.30 end
GPCST_YODONASI_CODE            = '321'; //���[�h�A�����M�[�Ȃ�
GPCST_YODOARI_CODE             = '322'; //���[�h�A�����M�[����
GPCST_YODOFUMEI_CODE           = '323'; //���[�h�A�����M�[�s��
GPCST_TAINAIKINZOKUNASI_CODE   = '341'; //�̓������Ȃ��m�F�ς�
GPCST_TAINAIKINZOKUARI_CODE    = '342'; //�̓���������
GPCST_PESUMEKAARI_CODE         = '343'; //�y�[�X���[�J�[����
GPCST_HEISHONASI_CODE          = '351'; //�����|�ǂȂ�
GPCST_HEISHOARI_CODE           = '352'; //�����|�ǂ���
GPCST_BUSUKOPANKA_CODE         = '361'; //�u�X�R�p����
GPCST_BUSUKOPANHI_CODE         = '362'; //�u�X�R�p����
GPCST_GURUKAGONKA_CODE         = '371'; //�u�X�ց[�O���J�S����
GPCST_GURUKAGONKIN_CODE        = '372'; //�u�X�ց[�O���J�S����
GPCST_OMUTUNASI_CODE           = '381'; //���ނ��Ȃ�
GPCST_OMUTUARI_CODE            = '382'; //���ނ�����
GPCST_JUNYUNASI_CODE           = '391'; //�����Ȃ�
GPCST_JUNYUCHU_CODE            = '392'; //������

//2002.11.18
//����񍀖ڕʃ}�X�^�敪/ID
CST_KMS = 'KMS';
CST_KMS_ID_1 = '1';
CST_KMS_ID_2 = '2';
CST_KMS_ID_5 = '5';   //�A�������F���ҏ��  2002.11.29
CST_KMS_ID_6 = '6';   //�A�������F���b�Z�[�W
CST_KMS_ID_7 = '7';   //�A�������F�Z�t�Ɩ�
CST_KMS_ID_8 = '8';   //�B�e���{�F�N��
CST_KMS_ID_9 = '9';   //�B�e���{�F�ǂ�����
CST_KMS_ID_10 = '10'; //Dr�w���F���e�L��
CST_KMS_ID_11 = '11'; //Dr�w���F�^�C�~���O
CST_KMS_ID_12 = '12'; //Dr�w���F�B���͈�
CST_KMS_ID_13 = '13'; //Dr�w���F����B�e
CST_KMS_ID_14 = '14'; //�����R�����g
CST_KMS_ID_17 = '17'; //�t�B��������
//2003.12.09
CST_KMS_ID_18 = '18'; //���l
CST_KMS_ID_19 = '19'; //���×p�@�V/�p
CST_KMS_ID_20 = '20'; //���×p�@�������
CST_KMS_ID_21 = '21'; //mAs
CST_KMS_ID_22 = '22'; //���ݐ�

//2002.11.19
//����񍀖ڕʃ}�X�^�敪
GPCST_SOUSIN_FLG_0 = '0';
GPCST_SOUSIN_FLG_1 = '1';
GPCST_SOUSIN_FLG_0_NAME = '��';
GPCST_SOUSIN_FLG_1_NAME = '��';

//2002.11.20
//���t��Format
CST_FORMATDATE_0='YYYYMMDD';
CST_FORMATDATE_1='YYYY/MM/DD';
CST_FORMATDATE_2='YYYY/MM/DD HH:NN';
CST_FORMATDATE_3='YYYY/MM/DD HH:MM:SS';
CST_FORMATDATE_4='HHMMSS';
CST_FORMATDATE_5='HH:MM:SS';

//2002.11.21
//�Ɩ��ڍ׉�����ݑ���
GPCST_BUTTON_0 = '0';  //�ۑ��̂�
GPCST_BUTTON_1 = '1';  //�����ۗ�
GPCST_BUTTON_2 = '2';  //���{
GPCST_BUTTON_3 = '3';  //�����I��
GPCST_BUTTON_4 = '4';  //���Z��

CST_ENG_TUKI_1='Jan';
CST_ENG_TUKI_2='Feb';
CST_ENG_TUKI_3='Mar';
CST_ENG_TUKI_4='Apr';
CST_ENG_TUKI_5='May';
CST_ENG_TUKI_6='Jun';
CST_ENG_TUKI_7='Jul';
CST_ENG_TUKI_8='Aug';
CST_ENG_TUKI_9='Sep';
CST_ENG_TUKI_10='Oct';
CST_ENG_TUKI_11='Nov';
CST_ENG_TUKI_12='Dec';

//MWM�p���M�A��M����
GPCST_JUSIN_MOJI = 'START';
GPCST_JUSIN_MOJI_LEN = 5;
GPCST_SOUSIN_MOJI_1 = 'OK';
GPCST_SOUSIN_MOJI_2 = 'NG';
GPCST_SOUSIN_MOJI_LEN = 2;
//�D��
GPCST_YUUSEN_0='0';
GPCST_YUUSEN_1='1';
GPCST_YUUSEN_2='2';
GPCST_YUUSEN_0_RYAKUNAME='';
GPCST_YUUSEN_1_RYAKUNAME='��';
GPCST_YUUSEN_2_RYAKUNAME='�D';

GPCST_INFKBN_FU='FU';   //��t
GPCST_INFKBN_FC='FC';   //��t�L�����Z�� {2002.12.17]
GPCST_INFKBN_FO='F0';   //���{
GPCST_INFKBN_F1='F1';   //���~           {2002.12.17]
GPCST_INFKBN_FY='FY';   //�\��           {2003.01.07]
GPCST_INFKBN_FH='FH';   //�ۗ�
GPCST_SYORIKBN_01='01'; //�V�K
GPCST_SYORIKBN_02='02'; //�X�V
GPCST_SYORIKBN_03='03'; //�폜
GPCST_JOUTAIKBN_3='3'; //���{
GPCST_JOUTAIKBN_7='7'; //���~

//�_�C���N�g����t���O
GPCST_DIRECT_FLG='1';

GPCST_FCR = 'FCR';
GPCST_FPD = 'FPD';

{2003.05.07 start}
GPCST_NEW_FEILD_NAME = 'MWMCARET_FLG';
GPCST_MWM_TYPE_FLG_0 = '0';
GPCST_MWM_TYPE_FLG_0_NAME = '�s�v';
GPCST_MWM_TYPE_FLG_1 = '1';
GPCST_MWM_TYPE_FLG_1_NAME = '�K�v';
{2003.05.07 end}

//2003.12.11
//�����@��}�X�^�\��Flg�p
GPCST_HYOJI_FLG_0 = '0';
GPCST_HYOJI_FLG_0_NAME = '���Ȃ�';
GPCST_HYOJI_FLG_1 = '1';
GPCST_HYOJI_FLG_1_NAME = '����';

//�`�[����t���O  2003.12.11
GPCST_DENPYO_INSATU_FLG_1 = '1';

//���ҏЉ�t���O  2003.12.11
GPCST_KANJA_SYOKAIFLG_0 = '0';
GPCST_KANJA_SYOKAIFLG_1 = '1';

//���Z�t���O 2003.12.12
GSPCST_SEISAN_FLG_0 = '0';
GSPCST_SEISAN_FLG_0_NAME = '�����Z';
GSPCST_SEISAN_FLG_1 = '1';
GSPCST_SEISAN_FLG_1_NAME = '���Z��';

//2003.10.13--------------------------------------------------------------------
GPCST_SATUEIJISSI_NAME = '�����B�e���{�ҁ���';
//2003.10.13--------------------------------------------------------------------
GSPCST_GYOUMU_KBN_1 = '1';
GSPCST_GYOUMU_KBN_1_NAME = '����';
GSPCST_GYOUMU_KBN_2 = '2';
GSPCST_GYOUMU_KBN_2_NAME = '����';
GSPCST_GYOUMU_KBN_3 = '3';
GSPCST_GYOUMU_KBN_3_NAME = '�[��';
GSPCST_GYOUMU_KBN_4 = '4';
GSPCST_GYOUMU_KBN_4_NAME = '�ً}';

GSPCST_PORTABLE_FLG_0 = '0';
GSPCST_PORTABLE_FLG_1 = '1';
GSPCST_PORTABLE_FLG_2 = '2';
GSPCST_PORTABLE_FLG_3 = '3'; //2004.04.21

//���ӏ��敪 2003.12.15
GPCST_DOUISHO_KBN_0 = '0';
GPCST_DOUISHO_KBN_0_NAME = '�Ȃ�';
GPCST_DOUISHO_KBN_1 = '1';
GPCST_DOUISHO_KBN_1_NAME = '����';

//��M�}�X�^�e�[�u��
//���F 2003.12.16
GPCST_JOUTAI_FLG_0 = '0';
GPCST_JOUTAI_FLG_0_NAME = '�\��';
GPCST_JOUTAI_FLG_1 = '1';
GPCST_JOUTAI_FLG_1_NAME = '�m�F�ς�';
GPCST_JOUTAI_FLG_3 = '3';
GPCST_JOUTAI_FLG_3_NAME = '�폜';
//�����敪 2003.12.16
GPCST_JUSHIN_SHORI_1 = '1';
GPCST_JUSHIN_SHORI_1_NAME = '�V�K';
GPCST_JUSHIN_SHORI_2 = '2';
GPCST_JUSHIN_SHORI_2_NAME = '�ύX';
GPCST_JUSHIN_SHORI_3 = '3';
GPCST_JUSHIN_SHORI_3_NAME = '�폜';
//�}�X�^�敪 2003.12.18
GPCST_JUSHIN_MASTERTYPE_1 =  '1';
GPCST_JUSHIN_MASTERTYPE_1_NAME  = '�B�e��Z';
GPCST_JUSHIN_MASTERTYPE_11 = '11';
GPCST_JUSHIN_MASTERTYPE_11_NAME = '����';
GPCST_JUSHIN_MASTERTYPE_12 = '12';
GPCST_JUSHIN_MASTERTYPE_12_NAME = '�w��';
GPCST_JUSHIN_MASTERTYPE_13 = '13';
GPCST_JUSHIN_MASTERTYPE_13_NAME = '���';
GPCST_JUSHIN_MASTERTYPE_14 = '14';
GPCST_JUSHIN_MASTERTYPE_14_NAME = '���';
GPCST_JUSHIN_MASTERTYPE_15 = '15';
GPCST_JUSHIN_MASTERTYPE_15_NAME = '̨��';
GPCST_JUSHIN_MASTERTYPE_16 = '16';
GPCST_JUSHIN_MASTERTYPE_16_NAME = '�B�e���@';
GPCST_JUSHIN_MASTERTYPE_17 = '17';
GPCST_JUSHIN_MASTERTYPE_17_NAME = '���Z';
GPCST_JUSHIN_MASTERTYPE_18 = '18';
GPCST_JUSHIN_MASTERTYPE_18_NAME = '���e��';
GPCST_JUSHIN_MASTERTYPE_C =  'C';
GPCST_JUSHIN_MASTERTYPE_C_NAME  = '�S���҃}�X�^';
//���ʖ����MF
GPCST_MISOUSIN_FLG_1 = '1'; //�����M
GPCST_MISOUSIN_FLG_1_NAME = '�����M'; //�����M
GPCST_MISOUSIN_FLG_N = '0';  //���M
GPCST_MISOUSIN_FLG_N_NAME = '���M';  //���M
//�`���[�W���g�pF
GPCST_CHARGE_FLG_1 = '1'; //���g�p
GPCST_CHARGE_FLG_1_NAME = '�s��'; //���g�p
GPCST_CHARGE_FLG_N = '0';  //�g�p
GPCST_CHARGE_FLG_N_NAME = '��'; //�g�p
//�o�敪
GPCST_HEIKEI_KBN_1 = '1';
GPCST_HEIKEI_KBN_1_NAME = '��';
GPCST_HEIKEI_KBN_0 = '0';
GPCST_HEIKEI_KBN_0_NAME = '�O';
//���o�K��
GPCST_GEKKEI_KBN_1 = '1';
GPCST_GEKKEI_KBN_1_NAME = '�s�K��';
GPCST_GEKKEI_KBN_0 = '0';
GPCST_GEKKEI_KBN_0_NAME = '�قڋK���I';
//���o�����[�K�v
GPCST_GEKKEI_FLG_0 = '0';
GPCST_GEKKEI_FLG_0_NAME = '�s�v';
GPCST_GEKKEI_FLG_1 = '1';
GPCST_GEKKEI_FLG_1_NAME = '�K�v';
//�|�[�^�u���t���O
GPCST_PORTABLE_FLG_0 = '0';
GPCST_PORTABLE_FLG_0_NAME = '�ʏ�';
GPCST_PORTABLE_FLG_1 = '1';
GPCST_PORTABLE_FLG_1_NAME = '�|�[�^�u��';
GPCST_PORTABLE_FLG_2 = '2';
GPCST_PORTABLE_FLG_2_NAME = '��p��';
GPCST_PORTABLE_FLG_3 = '3';           //2004.06.15
GPCST_PORTABLE_FLG_3_NAME = '���̑�'; //2004.06.15
//2003.12.25
//RI�I�[�_�ԍ��ϊ��ԍ��i���ˁE�����j
GPCST_RIORDER_NO_CHUSYA = '0';
GPCST_RIORDER_NO_KENSA  = '6';

//2004.01.22
//ReportRisTable�ݒ�t���O(WinMaster�p)
GPCST_REPORT_FLG_1 = '1';
GPCST_REPORT_FLG_1_NAME = '����';
GPCST_REPORT_FLG_0 = '0';
GPCST_REPORT_FLG_0_NAME = '�Ȃ�';

GPCST_MISIYOU_FLG_1 = '1';
GPCST_MISIYOU_FLG_1_NAME = '���g�p';
GPCST_MISIYOU_FLG_0 = '0';
GPCST_MISIYOU_FLG_0_NAME = '�g�p';

//RIS�I�[�_���M�L���[�쐬�ݒ�  2004.02.05
GPCST_RISORDERSOUSIN_FLG_0 = '0';
GPCST_RISORDERSOUSIN_FLG_0_NAME = '�Ȃ�';
GPCST_RISORDERSOUSIN_FLG_1 = '1';
GPCST_RISORDERSOUSIN_FLG_1_NAME = '�ʏ�'; //'����'; //2004.04.09
//2004.04.09
GPCST_RISORDERSOUSIN_FLG_2 = '2';
GPCST_RISORDERSOUSIN_FLG_2_NAME = 'HIS�Ȃ�Rep����';

//2004.03.25--
//�]���I�[�_�[�e�[�u��
//�m�FF
GPCST_TENSOU_KAKUNIN_FLG_0 = '0';
GPCST_TENSOU_KAKUNIN_FLG_0_NAME = '�\��';
GPCST_TENSOU_KAKUNIN_FLG_1 = '1';
GPCST_TENSOU_KAKUNIN_FLG_1_NAME = '�m�F�ς�';
GPCST_TENSOU_KAKUNIN_FLG_3 = '3';
GPCST_TENSOU_KAKUNIN_FLG_3_NAME = '�폜';
//�����
GPCST_TENSOU_INFKBN_F0 = 'F0';
GPCST_TENSOU_INFKBN_FU = 'FU';
GPCST_TENSOU_INFKBN_FC = 'FC';
GPCST_TENSOU_INFKBN_F1 = 'F1';
GPCST_TENSOU_INFKBN_F0_NAME = '���{���';
GPCST_TENSOU_INFKBN_FU_NAME = '������t';
GPCST_TENSOU_INFKBN_FC_NAME = '��t�L�����Z��';
GPCST_TENSOU_INFKBN_F1_NAME = '�������~';
GPCST_TENSOU_INFKBN_JISSHI_NAME = '���{���';
GPCST_TENSOU_INFKBN_UKETUKE_NAME = '��t���';
GPCST_TENSOU_INFKBN_KANJA_NAME = '���ҏ��v��';
GPCST_TENSOU_INFKBN_JUSHIN_NAME = '��M����ð���';   //2004.05.04
//��ԃ��b�Z�[�W
GPCST_TENSOU_JOUTAI_01 = '01';
GPCST_TENSOU_JOUTAI_02 = '02';
GPCST_TENSOU_JOUTAI_03 = '03';
GPCST_TENSOU_JOUTAI_04 = '04';
//2004.03.31
GPCST_TENSOU_JOUTAI_66 = '66';
GPCST_TENSOU_JOUTAI_77 = '77';
GPCST_TENSOU_JOUTAI_88 = '88';
GPCST_TENSOU_JOUTAI_99 = '99';
GPCST_TENSOU_JOUTAI_01_NAME = '����';
GPCST_TENSOU_JOUTAI_02_NAME = '�d���G���[';
GPCST_TENSOU_JOUTAI_03_NAME = '�ʐM�G���[';
GPCST_TENSOU_JOUTAI_04_NAME = '���[�U�m�F';
//2004.03.31
GPCST_TENSOU_JOUTAI_66_NAME = '���M�ϓd���G���[';
GPCST_TENSOU_JOUTAI_77_NAME = '���M�ϗ�O�G���[';
GPCST_TENSOU_JOUTAI_88_NAME = '�i���G���[';
GPCST_TENSOU_JOUTAI_99_NAME = '�����M��O�G���[';
//���M�t���O
GPCST_TENSOU_SOUSHINFLG_0 = '0';
GPCST_TENSOU_SOUSHINFLG_1 = '1';
GPCST_TENSOU_SOUSHINFLG_0_NAME = '��';
GPCST_TENSOU_SOUSHINFLG_1_NAME = '��';
//�o�^���
GPCST_TENSOU_SYORIKBN_01 = '01';
GPCST_TENSOU_SYORIKBN_02 = '02';
GPCST_TENSOU_SYORIKBN_03 = '03';
GPCST_TENSOU_SYORIKBN_01_NAME = '�V�K';
GPCST_TENSOU_SYORIKBN_02_NAME = '�X�V';
GPCST_TENSOU_SYORIKBN_03_NAME = '�폜';
//--2004.03.25
//���t�B���������[���
GPCST_FILMLABEL_1 = '1';     //
GPCST_FILMLABEL_2 = '2';     //
GPCST_FILMLABEL_3 = '3';     //

GPCST_FILMLABEL_1_NAME = '�ۗ��E������';     //
GPCST_FILMLABEL_2_NAME = '�����ς̂�';     //
GPCST_FILMLABEL_3_NAME = '�Ȃ�';     //

//2004.05.04--
//��M�I�[�_�e�[�u��
//�V�F�[�}�擾�t���O
GPCST_JUSHIN_SHEMA_0 ='0';
GPCST_JUSHIN_SHEMA_1 ='1';
GPCST_JUSHIN_SHEMA_2 ='2';
GPCST_JUSHIN_SHEMA_0_NAME ='�V�F�[�}���擾';
GPCST_JUSHIN_SHEMA_1_NAME ='�V�F�[�}�擾�ς�';
GPCST_JUSHIN_SHEMA_2_NAME ='���s';

//2004.05.05 ->
//�B�e�ꏊ�敪�i�a���}�X�^�j
GPCST_CODE_BYK_1 = '1';   //�{��
GPCST_CODE_BYK_2 = '2';   //�ʊ�
GPCST_CODE_BYK_3 = '3';   //�~��
//<-

//�ϐ��錾-------------------------------------------------------------------
var
//���s�����---------------------
   g_Exe_Name   : string;
   g_Exe_FName  : string;
   g_LogPlefix  : string;
//INI�t�@�C���ꏊ-------------------
   g_TcpIniPath : string;
//INI�t�@�C�����-------------------
//SERVICE���
   g_Svc_Sd_Acvite:string;
   g_Svc_Rv_Acvite:string;
   g_Svc_Sd_Cycle :integer;
   g_Svc_Rv_Cycle :integer;
//DB�ڑ����
   g_RisDB_Name : string;
   g_RisDB_Uid  : string;
   g_RisDB_Pas  : string;
   g_RisDB_DpendSrvName :string;
   g_RisDB_Retry: integer;
   g_RisDB_SndKeep: integer;
   g_RisDB_RcvKeep: integer;
//Socket�ڑ��p���S
   //�N���C�A���g
   g_C_Socket_Info_01      :  TClint_Info;
   g_C_Socket_Info_02      :  TClint_Info;
   g_C_Socket_Info_03      :  TClint_Info;
   g_C_Socket_Info_04      :  TClint_Info;
   g_C_Socket_Info_05      :  TClint_Info;
   g_C_Socket_Info_06      :  TClint_Info;
   //�T�[�o
   g_S_Socket_Info_01      :  TServer_Info;
   g_S_Socket_Info_02      :  TServer_Info;
   g_S_Socket_Info_03      :  TServer_Info;
   g_S_Socket_Info_04      :  TServer_Info;
   g_S_Socket_Info_05      :  TServer_Info;
   g_S_Socket_Info_06      :  TServer_Info;
//LOG���
   g_Rig_LogActive         :  string;
   g_Rig_LogPath           :  string;
   g_Rig_LogSize           :  string;
   g_Rig_LogKeep           :  integer;
   g_Rig_LogIncMsg         :  string;
   g_Rig_LogLevel          :  string;
//LOG��ʒ�`��i�O����`�̏ꍇ�j
   g_Log_Type     : array[1..G_MAX_LOG_TYPE] of TLog_Type;
//�ǉe�D��R�[�h
   g_Name_Kansen01          :  string;
//�v���t�@�C������
   g_Prof01 : string;
   g_Prof02 : string;
//�V�F�[�}���
   g_Schema_Main : string;
   g_Schema_Sub  : string;
   g_Schema_Del  : string;
//�o�b�N�A�b�v�p�X
   g_Svr_Main : string;
   g_Svr_Back : string;
   g_Save_Active : string;
//�\��g�R�[�h�A�����@��ID�Ή��\
   g_Kikitaiou : TKensakiki;
//�����ً}�R�����gID
   g_Kenzo : TStrings;
//�B�e�ꏊ�R�����gID
   g_Satuei : TStrings;
//���ҏ�ԃR�����gID
   g_KanjaJyoutai : TStrings;
//�I�[�_�w�����HIS�ERIS�R�[�h
   g_OrderIndicate_Code : array of TOrderIndicate;
   g_OrderIndicate_Up   : String;
//���҃v���t�@�C�����R�[�h
   g_KanjaProf_Code : array of TOrderIndicate;
   g_KanjaProfCode_Code : array of TOrderIndicate;
//XML�ϊ���������R�[�h
   g_XML_Code : array of TXML;
//�����_�~�[���R�[�h
   g_HOUKOU_Code : array of TDUMMY;
//�������@�_�~�[���R�[�h
   g_HOUHOU_Code : array of TDUMMY;
//2004.03.24
//�I���N���G���[�ԍ�
   g_OraErrNo : TStrings;
//�֐��葱���錾-------------------------------------------------------------
//1.���O�o�͊֐��n----------------------------------------------------------------
procedure proc_LogOut(
     arg_Status: string; //�X�e�[�^�X�ړ��q
     arg_Time:string;    //���� ''�F�����}�V������
     arg_Kind:integer;   //���O���
     arg_Diteil:string); //�ڍ׃��O
//2.�����R�[�h�n------------------------------------------------------------------
//�����R�[�h�n�̃X�g���[���^����
procedure proc_SisToJis(arg_Stream: TStringStream);  //SJIS����JIS�ɕԊ�
procedure proc_JisToSJis(arg_Stream: TStringStream); //JIS����SJIS�ɕԊ�
function  func_SJisToJis(arg_Stream: string): string;//SJIS����JIS�ɕԊ�
function  func_MakeSJIS: String;                     //SJIS������̍쐬
//3.INI�t�@�C���n-----------------------------------------------------------------
//Ini�t�@�C�����ǂݏo��
function  func_TcpReadiniFile: Boolean;
procedure proc_ReadiniYoyaku(
                           arg_Ini : TIniFile;
                           var arg_kiki:Tkensakiki
                           );
procedure proc_ReadiniKenzo(
                           arg_Ini : TIniFile;
                           var arg_Kenzo,arg_Satuei,arg_Kanja:TStrings
                           );
procedure proc_ReadiniOrderIndicate(
                           arg_Ini : TIniFile
                           );
procedure proc_ReadiniKanjaProf(
                           arg_Ini : TIniFile
                           );
procedure proc_ReadiniXML(
                          arg_Ini : TIniFile
                          );
procedure proc_ReadiniDummy_Code(
                          arg_Ini : TIniFile
                          );
procedure proc_ReadiniOraErr(arg_Ini : TIniFile;var arg_OraErr:TStrings);
//4.�o�b�t�@�n--------------------------------------------------------------------
//�o�b�t�@���I�t�Z�b�g�ƃT�C�Y�ŕ�����Ƃ��Ď�o��
//�o�b�t�@���當��������o��
function func_ByteToStr(
           arg_Buffer        : array of byte ; //�o�b�t�@
           arg_offset        : LongInt;        //�I�t�Z�b�g
           arg_size          : LongInt         //�T�C�Y
           ):string;
//�o�b�t�@�ɕ������ݒ�
procedure proc_StrToByte(
           var arg_Buffer      : array of byte ;//�o�b�t�@
           arg_offset      : LongInt;           //�I�t�Z�b�g
           arg_str         : string             //������
           );
//�o�b�t�@���TStringStream���쐬����
function  func_BufferToStrStrm(
           arg_Buffer        : array of byte; //�o�b�t�@
           arg_Size          : Longint        //�T�C�Y
       ):TStringStream;
//5.�d���X�g���[���n------------------------------------------------------------------
//TStringList���TStringStream���쐬����
Procedure  proc_TStrListToStrm(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream
           );
Procedure  proc_TStrListToStrm2(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream
           );
//TStringStream����͂���TStringList���쐬����
procedure proc_TStrmToStrlist(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList
           );
//TStringStream����͂���TStringList���쐬����
procedure proc_TStrmToStrlist2(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList
           );
procedure proc_TStrmToStrlist3(
           arg_String      : String;
           arg_TStringList : TStringList
           );
procedure proc_TStrmToStrlist4(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList
           );
//6.���̑��n------------------------------------------------------------------
//�J���}��؂�Ō�������
procedure  proc_StrConcat(
           var arg_LogBase   : string;
           arg_Log           : string
           );
function func_IsNumberStr(arg_str1:string): Boolean;
//2001.12.27
function func_MBTrim(arg_str:string)     : string;
function func_MBTrimRight(arg_str:string): string;
function func_MBTrimLeft(arg_str:string) : string;
function func_LeftSpace(intCapa : Integer;EditStr : String): String;
function func_RigthSpace(intCapa : Integer;EditStr : String): String;
function func_LeftZero(intCapa : Integer;EditStr : String): String;
procedure proc_BUp_TxtOut(arg_path,arg_Flg,arg_Data:String;arg_DateTime:TDateTime);
function bswap(src : integer) : integer; assembler;
function bswapf(src : single) : single;
procedure ByteOrderSwap(var Src: Double); overload;
function EndianShort_Short(Value: Short): Short;
function func_Lowerc(arg_string : String):String;
function func_Change_XML(arg_string : String):String;
function func_Change_RIS(arg_string : String):String;
function func_Search_OraErr(arg_Msg : String):String;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ��Z�敪
function func_PIND_Change_SYUGI(
       arg_Code:string    //����
       ):string;          //����
//�����g�p���@�\�i��O�L�j�F���ݔԍ�+1�擾
function func_Get_NumberControl(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Kubun:string;
         arg_Date:string
         ):integer;
//�����g�p���@�\�i��O�L�j�F���ݔԍ��X�V
function func_NumberControl_Update(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Mode:integer;
         arg_Kubun:string;
         arg_UpdateDate:string;
         arg_Now_NO:integer
         ):Boolean;
//���@�\�i��O���j�F�V�F�[�}�i�[�t�@�C�����쐬
function func_Make_ShemaName(arg_OrderNO,               //�I�[�_NO
                             arg_MotoFileName: string;  //HIS���ϖ�
                             arg_Index: integer         //����NO
                             ):string;                  //�i�[̧�ٖ�

implementation //**************************************************************

//�g�p���j�b�g---------------------------------------------------------------
//uses

//�萔�錾       -------------------------------------------------------------
//const

//�ϐ��錾     ---------------------------------------------------------------
//var

//�֐��葱���錾--------------------------------------------------------------
//-----------------------------------------------------------------------------
//4.�o�b�t�@�n���䏈��
//-----------------------------------------------------------------------------
//���o�b�t�@���I�t�Z�b�g�ƃT�C�Y�ŕ�����Ƃ��Đݒ肷��
procedure proc_StrToByte(var arg_Buffer : array of Byte;
                             arg_offset : LongInt;
                             arg_str    : String
                         );
var
  w_i:LongInt;
begin
  //������̕��������[�v
  for w_i := 0 to length(AnsiString(arg_str)) - 1 do begin
    //�I�t�Z�b�g���當��������Ă����A�o�b�t�@�𒴂����ꍇ
    if (high(arg_Buffer) <= (arg_offset + w_i)) then
      //�����I��
      Break;
    //�o�b�t�@�ɕ������ݒ�
    arg_Buffer[arg_offset + w_i] := byte(arg_str[w_i+1]);
  end;
end;
//�o�b�t�@���I�t�Z�b�g�ƃT�C�Y�ŕ�����Ƃ��Ď�o��
function func_ByteToStr(arg_Buffer : array of Byte;
                        arg_offset : LongInt;
                        arg_size   : LongInt
                        ):string;
var
  w_i:LongInt;
begin
  //�����ݒ�
  Result := '';
  //�I�t�Z�b�g����w��̃T�C�Y�܂Ń��[�v
  for w_i := arg_offset to (arg_offset + arg_size - 1) do begin
    //��������擾
    Result := Result + chr(arg_Buffer[w_i]);
  end;
end;
{
-----------------------------------------------------------------------------
  ���O : func_BufferToStrStrm;
  ���� :
  arg_Buffer: �o�b�t�@
  arg_Size:   �T�C�Y
  �@�\ : �o�b�t�@���TStringStream���쐬����
  ���A�l�FTStringStream nil���s
-----------------------------------------------------------------------------
}
function func_BufferToStrStrm(arg_Buffer : array of Byte;
                              arg_Size   : Longint
                              ):TStringStream;
begin
  try
    //�����l
    Result := TStringStream.Create('');
  except
    //nil����
    Result := nil;
    //�����I��
    Exit;
  end;
  try
    //�����ʒu
    Result.Position := 0;
    //�X�g���[���ɏ�������
    Result.Write( arg_Buffer, arg_Size );
  except
    //�J��
    Result.Free;
    //nil����
    Result := nil;
    //�����I��
    Exit;
  end;
end;

//-----------------------------------------------------------------------------
//5.�d���X�g���[���n ���䏈��
//-----------------------------------------------------------------------------
{
-----------------------------------------------------------------------------
  ���O : proc_TStrmToStrlist
  ���� :
  arg_TStringList:TStringList      ��
  arg_TStringList   : TStringList  ��
  arg_System        : string;      ���
  arg_MsgKind       : string       ���

  �@�\ : TStringStream����͂���TStringList���쐬����
  ���A�l�F
-----------------------------------------------------------------------------
}
procedure proc_TStrmToStrlist(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList
           );
var
  w_S:string;
  w_S2:String;
  w_i:integer;
begin
//TStringStream��TStringList�ɓW�J
  //�����l
  arg_TStringList.Text := '';
  //������
  arg_TStringList.Clear;
  //�����ʒu�Ɉړ�
  arg_TStringStream.Position := 0;
  w_i := 1;
  w_S := arg_TStringStream.DataString;

  w_S2 := w_S2 + func_Lowerc(Copy(w_S,1,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,2,1));
  w_S2 := w_S2 + Copy(w_S,3,14);
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,17,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,18,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,19,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,20,1));

  w_S2 := w_S2 + Copy(w_S,21,Length(w_S));

  w_S := w_S2;
  while w_S <> '' do begin
    if AnsiPos('><',w_S) > 0 then begin
      w_S2 := Copy(w_S,w_i,AnsiPos('><',w_S));
      arg_TStringList.Add(w_S2);
      w_S := Copy(w_S,AnsiPos('><',w_S) + 1,Length(w_S));
      if w_S = '</risinfo>' then begin
        arg_TStringList.Add(w_S);
        Break;
      end;
    end
    else
      Break;
  end;
  if Length(arg_TStringList.Text) = 0 then
    arg_TStringList.Add(w_S);
  //�����I��
  Exit;
end;
{
-----------------------------------------------------------------------------
  ���O : proc_TStrmToStrlist2
  ���� :
  arg_TStringList:TStringList      ��
  arg_TStringList   : TStringList  ��
  arg_System        : string;      ���
  arg_MsgKind       : string       ���

  �@�\ : TStringStream����͂���TStringList���쐬����
  ���A�l�F
-----------------------------------------------------------------------------
}
procedure proc_TStrmToStrlist2(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList
           );
var
  w_S:string;
  w_S2:String;
  w_i:integer;
begin
//TStringStream��TStringList�ɓW�J
  //�����l
  arg_TStringList.Text := '';
  //������
  arg_TStringList.Clear;
  //�����ʒu�Ɉړ�
  arg_TStringStream.Position := 0;
  w_i := 1;
  w_S := arg_TStringStream.DataString;
  while w_S <> '' do begin
    if AnsiPos('><',w_S) > 0 then begin
      w_S2 := Copy(w_S,w_i,AnsiPos('><',w_S));
      arg_TStringList.Add(w_S2);
      w_S := Copy(w_S,AnsiPos('><',w_S) + 1,Length(w_S));
      if w_S = '</risinfo>' then begin
        arg_TStringList.Add(w_S);
        Break;
      end;
    end
    else
      Break;
  end;
  if Length(arg_TStringList.Text) = 0 then
    arg_TStringList.Add(w_S);
  //�����I��
  Exit;
end;
{
-----------------------------------------------------------------------------
  ���O : proc_TStrmToStrlist3
  ���� :
  arg_TStringList:TStringList      ��
  arg_TStringList   : TStringList  ��
  arg_System        : string;      ���
  arg_MsgKind       : string       ���

  �@�\ : TStringStream����͂���TStringList���쐬����
  ���A�l�F
-----------------------------------------------------------------------------
}
procedure proc_TStrmToStrlist3(
           arg_String      : String;
           arg_TStringList : TStringList
           );
var
  w_S:string;
  w_S2:String;
  w_i:integer;
begin
//TStringStream��TStringList�ɓW�J
  //�����l
  arg_TStringList.Text := '';
  //������
  arg_TStringList.Clear;
  w_i := 1;
  w_S := arg_String;
  while w_S <> '' do begin
    if AnsiPos('><',w_S) > 0 then begin
      w_S2 := Copy(w_S,w_i,AnsiPos('><',w_S));
      arg_TStringList.Add(w_S2);
      w_S := Copy(w_S,AnsiPos('><',w_S) + 1,Length(w_S));
      if w_S = '</risinfo>' then begin
        arg_TStringList.Add(w_S);
        Break;
      end;
    end
    else
      Break;
  end;
  if Length(arg_TStringList.Text) = 0 then
    arg_TStringList.Add(w_S);
  //�����I��
  Exit;
end;
{
-----------------------------------------------------------------------------
  ���O : proc_TStrmToStrlist4
  ���� :
  arg_TStringList:TStringList      ��
  arg_TStringList   : TStringList  ��
  arg_System        : string;      ���
  arg_MsgKind       : string       ���

  �@�\ : TStringStream����͂���TStringList���쐬����
  ���A�l�F
-----------------------------------------------------------------------------
}
procedure proc_TStrmToStrlist4(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList
           );
var
  w_S:string;
  w_S2:String;
  w_i:integer;
begin
//TStringStream��TStringList�ɓW�J
  //�����l
  arg_TStringList.Text := '';
  //������
  arg_TStringList.Clear;
  //�����ʒu�Ɉړ�
  arg_TStringStream.Position := 0;
  w_i := 1;
  w_S := arg_TStringStream.DataString;

  w_S2 := w_S2 + func_Lowerc(Copy(w_S,1,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,2,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,3,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,4,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,5,1));
  w_S2 := w_S2 + func_Lowerc(Copy(w_S,6,1));

  w_S2 := w_S2 + Copy(w_S,7,Length(w_S));

  w_S := w_S2;
  while w_S <> '' do begin
    if AnsiPos('><',w_S) > 0 then begin
      w_S2 := Copy(w_S,w_i,AnsiPos('><',w_S));
      arg_TStringList.Add(w_S2);
      w_S := Copy(w_S,AnsiPos('><',w_S) + 1,Length(w_S));
      if w_S = '</risinfo>' then begin
        arg_TStringList.Add(w_S);
        Break;
      end;
    end
    else
      Break;
  end;
  if Length(arg_TStringList.Text) = 0 then
    arg_TStringList.Add(w_S);
  //�����I��
  Exit;
end;
{
-----------------------------------------------------------------------------
  ���O : proc_TStrListToStrm
  ���� :
  arg_TStringList   : TStringList  ��
  arg_TStringList:TStringList      ��
  arg_System        : string;      ���
  arg_MsgKind       : string       ���
  arg_TStringList:TStringList
  �@�\ : TStringList���TStringStream���쐬����
  ���A�l�FTStringStream nil���s
-----------------------------------------------------------------------------
}
Procedure  proc_TStrListToStrm(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream
           );
var
  w_i:integer;
  w_i2:integer;
  w_len1:integer;
  w_s:string;
  w_iSize:integer;
  w_ii:Word;
  w_Hex1 :string;
  w_Hex2 :string;
  w_Hex3 :string;
  w_Hex4 :string;
begin
  //TStringList��TStringStream�ɓW�J
  try
    //������
    w_len1 := 0;
    //���X�g�������[�v
    for w_i := 0 to arg_TStringList.Count - 1 do begin
      //�ꃉ�C�����W�J
      arg_TStringStream.Position := w_len1;
      if w_i = 0 then begin
        w_s := chr(StrToInt('$' + arg_TStringList[w_i]));
      end
      else if w_i = 1 then begin
        w_s := chr(StrToInt('$' + arg_TStringList[w_i]));
      end
      else if w_i = 3 then begin
        w_s := '';
        //���X�g�������[�v
        for w_i2 := 0 to arg_TStringList.Count - 1 do begin
          w_s := w_s + arg_TStringList.Strings[w_i2];
        end;
        //�f�[�^����ݒ�
        w_s := FormatFloat('00000',Length(w_s) - 22);
        w_iSize := StrToInt(w_s);
        w_ii := w_iSize;
        w_s := IntToHex(w_ii,0);
        w_s := Copy('00000000', 1, 8 - Length(w_s)) + w_s;
        w_Hex1 := chr(StrToInt('$' + Copy(w_s,1,2)));
        w_Hex2 := chr(StrToInt('$' + Copy(w_s,3,2)));
        w_Hex3 := chr(StrToInt('$' + Copy(w_s,5,2)));
        w_Hex4 := chr(StrToInt('$' + Copy(w_s,7,2)));
        w_s    := w_Hex1 + w_Hex2 + w_Hex3 + w_Hex4;
      end
      else begin
        //�f�[�^�̎擾
        w_s := arg_TStringList[w_i];
      end;
      //���M�f�[�^�̏�������
      arg_TStringStream.WriteString(w_s);
      //�ʒu�̈ړ�
      w_len1 := w_len1 + Length(w_s);
    end;
  except
    //������
    arg_TStringStream.Position := 0;
    //�����I��
    Exit;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O : proc_TStrListToStrm2
  ���� :
  arg_TStringList   : TStringList  ��
  arg_TStringList:TStringList      ��
  arg_System        : string;      ���
  arg_MsgKind       : string       ���
  arg_TStringList:TStringList
  �@�\ : TStringList���TStringStream���쐬����
  ���A�l�FTStringStream nil���s
-----------------------------------------------------------------------------
}
Procedure  proc_TStrListToStrm2(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream
           );
var
  w_i:integer;
  w_i2:integer;
  w_len1:integer;
  w_s:string;
  w_iSize:integer;
  w_ii:Word;
  w_Hex1 :string;
  w_Hex2 :string;
  w_Hex3 :string;
  w_Hex4 :string;
begin
  //TStringList��TStringStream�ɓW�J
  try
    //������
    w_len1 := 0;
    //���X�g�������[�v
    for w_i := 0 to arg_TStringList.Count - 1 do begin
      //�ꃉ�C�����W�J
      arg_TStringStream.Position := w_len1;
      if w_i = 2 then begin
        w_s := '';
        //���X�g�������[�v
        for w_i2 := 0 to arg_TStringList.Count - 1 do begin
          w_s := w_s + arg_TStringList.Strings[w_i2];
        end;
        //�f�[�^����ݒ�
        w_s := FormatFloat('00000',Length(w_s) - 10);
        w_iSize := StrToInt(w_s);
        w_ii := w_iSize;
        w_s := IntToHex(w_ii,0);
        w_s := Copy('00000000', 1, 8 - Length(w_s)) + w_s;
        w_Hex1 := chr(StrToInt('$' + Copy(w_s,1,2)));
        w_Hex2 := chr(StrToInt('$' + Copy(w_s,3,2)));
        w_Hex3 := chr(StrToInt('$' + Copy(w_s,5,2)));
        w_Hex4 := chr(StrToInt('$' + Copy(w_s,7,2)));
        w_s    := w_Hex1 + w_Hex2 + w_Hex3 + w_Hex4;
      end
      else begin
        //�f�[�^�̎擾
        w_s := chr(StrToInt('$' + arg_TStringList[w_i]));
      end;
      //���M�f�[�^�̏�������
      arg_TStringStream.WriteString(w_s);
      //�ʒu�̈ړ�
      w_len1 := w_len1 + Length(w_s);
    end;
  except
    //������
    arg_TStringStream.Position := 0;
    //�����I��
    Exit;
  end;
end;
//-----------------------------------------------------------------------------
// 2.�����R�[�h�n���䏈��
//-----------------------------------------------------------------------------
{
-----------------------------------------------------------------------------
  ���O : proc_JisToSJis;
  ���� :
  arg_Stream:TStringStream
  �@�\ : �X�g���[����Jis����SJis�ɕϊ�����
  ���A�l�F
-----------------------------------------------------------------------------
}
procedure proc_JisToSJis(arg_Stream: TStringStream);
var
 w_s:string;
begin
    w_s := arg_Stream.DataString;
    w_s := SJis7ToSJis8(w_s);
    w_s := JisToSJis(w_s);
    arg_Stream.Position:=0;
    arg_Stream.WriteString(w_s);

end;
{
-----------------------------------------------------------------------------
  ���O : proc_SisToJis;
  ���� :
  arg_Stream:TStringStream
  �@�\ : �X�g���[����Jis����SJis�ɕϊ�����
  ���A�l�F
-----------------------------------------------------------------------------
}
procedure proc_SisToJis(arg_Stream: TStringStream);
var
 w_s:string;
begin
    w_s := arg_Stream.DataString;
    w_s := SJis8ToSJis7(w_s);
    w_s := SJisToJis(w_s);
    arg_Stream.Position:=0;
    arg_Stream.WriteString(w_s);

end;
{
-----------------------------------------------------------------------------
  ���O : func_TStrListToStrm;
  ���� :
  arg_TStringList:TStringList
  �@�\ : TStringList���X�g���[�����쐬����
  ���A�l�FTStringStream nil���s
-----------------------------------------------------------------------------
}
function func_SJisToJis(arg_Stream: string): string;
begin
    result:=SJisToJis(arg_Stream);
end;
{
-----------------------------------------------------------------------------
  ���O : func_TStrListToStrm;
  ���� :
  arg_TStringList:TStringList
  �@�\ : TStringList���X�g���[�����쐬����
  ���A�l�FTStringStream nil���s
-----------------------------------------------------------------------------
}
///// SJIS�R�[�h��JIS�R�[�h�ɕϊ� - 1����
function func_MakeSJIS: String;
var
  b0,b1: byte;
  w_s:string;
//  w_i:integer;
//  w_l:integer;
//  c0,c1: AnsiChar
begin
  w_s := '';

  for b0:=byte(#$20) to byte(#$7E) do
  begin
    w_s := w_s+AnsiChar(b0) ;
  end;
  w_s := w_s + #13#10;
  for b0:=byte(#$81) to byte(#$9F) do
  begin
    for b1:=byte(#$40) to byte(#$7E) do
    begin
     w_s := w_s+AnsiChar(b0) + AnsiChar(b1);
    end;
    w_s := w_s + #13#10;
  end;
  for b0:=byte(#$81) to byte(#$9F) do
  begin
    for b1:=byte(#$80) to byte(#$FC) do
    begin
     w_s := w_s+AnsiChar(b0) + AnsiChar(b1);
    end;
    w_s := w_s + #13#10;
  end;
  for b0:=byte(#$E0) to byte(#$EF) do
  begin
    for b1:=byte(#$40) to byte(#$7E) do
    begin
     w_s := w_s+AnsiChar(b0) + AnsiChar(b1);
    end;
    w_s := w_s + #13#10;
  end;
  for b0:=byte(#$E0) to byte(#$EF) do
  begin
    for b1:=byte(#$80) to byte(#$FC) do
    begin
     w_s := w_s+AnsiChar(b0) + AnsiChar(b1);
    end;
    w_s := w_s + #13#10;
  end;

  Result := w_s;
end;
//-----------------------------------------------------------------------------
//3.INI�t�@�C���n
//-----------------------------------------------------------------------------
(**
���@�\INI�t�@�C���Ǎ��� ����
�����F
  arg_Ini : TIniFile;
  arg_Section:string;
  arg_Key:string;
  arg_Def:string
��O�F����
���A�l�F
**)
function func_IniReadString(
                            arg_Ini : TIniFile;
                            arg_Section:string;
                            arg_Key:string;
                            arg_Def:string
                            ):string;
var
  w_string:string;
begin
   w_string:=arg_Ini.ReadString(
                           arg_Section,
                           arg_Key,
                           arg_Def);
   if not(func_IsNullStr(w_string)) then
   begin
     result := w_string;
   end
   else
   begin
     result := arg_Def;
   end;

end;
(**
���@�\INI�t�@�C���Ǎ��� ���l
�����F
  arg_Ini : TIniFile;
  arg_Section:string;
  arg_Key:string;
  arg_Def:string
��O�F����
���A�l�F
**)
function func_IniReadInt(
                            arg_Ini : TIniFile;
                            arg_Section:string;
                            arg_Key:string;
                            arg_Def:string
                            ):Longint;
var
  w_string:string;
begin
   w_string:=arg_Ini.ReadString(
                           arg_Section,
                           arg_Key,
                           arg_Def);
   if not(func_IsNullStr(w_string)) then
   begin
     result := StrToIntDef(w_string,0);
   end
   else
   begin
     result := StrToIntDef(arg_Def,0);
   end;

end;

(**
���@�\�N���C�A���g��񕔕��̓Ǎ���
�����F
  arg_Ini : TIniFile;
  arg_No:string
��O�F����
���A�l�F
**)
function func_ReadiniCInfo(
                           arg_Ini : TIniFile;
                           arg_No:string
                           ): TClint_Info;
begin
      result.f_Socket_Info.f_Active :=
            func_IniReadString(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_ACTIVE_KEY,
                               g_SOCKET_DEACTIVE);
      result.f_Socket_Info.f_EmuVisible :=
            func_IniReadString(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_EMUVISIBLE_KEY,
                               g_SOCKET_EMUVISIBLE_FALSE);
      result.f_Socket_Info.f_EmuEnabled :=
            func_IniReadString(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_EMUENABLED_KEY,
                               g_SOCKET_EMUENABLED_FALSE);
      result.f_Socket_Info.f_CharCode :=
            func_IniReadString(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_CHARCODE_KEY,
                               g_SOCKET_CHARCODE_SJIS);

      result.f_TimeOut :=
            func_IniReadInt(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_TOUT_KEY,
                               g_SOCKET_TOUT);

      result.f_Timer :=
            func_IniReadInt(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_TIMER_KEY,
                               g_SOCKET_TIMER)*1000;

      result.f_IPAdrr :=
            func_IniReadString(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_SIP_KEY,
                               g_SOCKET_SIP);
      result.f_Port :=
            func_IniReadString(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_SPORT_KEY,
                               g_SOCKET_SPORT);
end;
(**
���@�\�T�[�o��񕔕��̓Ǎ���
�����F
  arg_Ini : TIniFile;
  arg_No:string
��O�F����
���A�l�F
**)
function func_ReadiniSInfo(
                           arg_Ini : TIniFile;
                           arg_No:string
                           ): TServer_Info;
begin
      result.f_Socket_Info.f_Active :=
            func_IniReadString(
                               arg_Ini,
                               g_S_SOCKET_SECSION + arg_No,
                               g_SOCKET_ACTIVE_KEY,
                               g_SOCKET_DEACTIVE);
      result.f_Socket_Info.f_EmuVisible :=
            func_IniReadString(
                               arg_Ini,
                               g_S_SOCKET_SECSION + arg_No,
                               g_SOCKET_EMUVISIBLE_KEY,
                               g_SOCKET_EMUVISIBLE_FALSE);
      result.f_Socket_Info.f_EmuEnabled :=
            func_IniReadString(
                               arg_Ini,
                               g_S_SOCKET_SECSION + arg_No,
                               g_SOCKET_EMUENABLED_KEY,
                               g_SOCKET_EMUENABLED_FALSE);
      result.f_Socket_Info.f_CharCode :=
            func_IniReadString(
                               arg_Ini,
                               g_S_SOCKET_SECSION + arg_No,
                               g_SOCKET_CHARCODE_KEY,
                               g_SOCKET_CHARCODE_SJIS);

      result.f_TimeOut :=
            func_IniReadInt(
                               arg_Ini,
                               g_S_SOCKET_SECSION + arg_No,
                               g_SOCKET_TOUT_KEY,
                               g_SOCKET_TOUT);
      result.f_Port :=
            func_IniReadString(
                               arg_Ini,
                               g_S_SOCKET_SECSION + arg_No,
                               g_SOCKET_PORT_KEY,
                               g_SOCKET_PORT);
end;
(**
���@�\�\��g�R�[�h�A�����@��ID�Ή��\��񕔕��̓Ǎ���
�����F
  arg_Ini : TIniFile;
  var arg_kiki:Tkensakiki �\��g�R�[�h�A�����@��ID�\����
��O�F����
���A�l�F
**)
procedure proc_ReadiniYoyaku(
                           arg_Ini : TIniFile;
                           var arg_kiki:Tkensakiki
                           );
var
  w_StringList:TStrings;
  w_i:Integer;
  w_Pos,w_Pos2:Integer;
begin
  w_StringList := TStringList.Create;
  try

    arg_Ini.ReadSectionValues(g_KIKI_SECSION,w_StringList);

    SetLength(arg_kiki,w_StringList.Count);

    for w_i := 0 to w_StringList.Count - 1 do begin
      w_Pos := Pos(',',w_StringList[w_i]);
      if w_Pos <> 0 then begin
        w_Pos2 := Pos('=',w_StringList[w_i]);
        arg_kiki[w_i].Yoyakuwaku := Copy(w_StringList[w_i],w_Pos2 + 1,w_Pos - 1 - w_Pos2);
        arg_kiki[w_i].Kensakiki  := Copy(w_StringList[w_i],w_Pos + 1,Length(w_StringList[w_i]) - w_Pos);
      end;

    end;
  finally
    if w_StringList <> nil then
      w_StringList.Free;
  end;
end;
(**
�������ً}�t���O�A�B�e�ꏊ�A���ҏ���񕔕��̓Ǎ���
�����F
  arg_Ini : TIniFile;
  var arg_Kenzo:TStringList  �����R�����g�t���O
      arg_Satuei:TStringList �B�e�ꏊ
      arg_Kanja:TStringList  ���ҏ��
��O�F����
���A�l�F
**)
procedure proc_ReadiniKenzo(
                           arg_Ini : TIniFile;
                           var arg_Kenzo,arg_Satuei,arg_Kanja:TStrings
                           );
var
  w_i:Integer;
  w_Pos:Integer;
begin
  arg_Kenzo := TStringList.Create;

  arg_Satuei := TStringList.Create;

  arg_Kanja := TStringList.Create;

  arg_Ini.ReadSectionValues(g_KENZO_SECSION,arg_Kenzo);
  arg_Ini.ReadSectionValues(g_SATUEI_SECSION,arg_Satuei);
  arg_Ini.ReadSectionValues(g_KANJA_SECSION,arg_Kanja);
  for w_i := 0 to arg_Kenzo.Count - 1 do begin
    w_Pos := Pos('=',arg_Kenzo[w_i]);
    if w_Pos <> 0 then begin
      arg_Kenzo[w_i] := Copy(arg_Kenzo[w_i],w_Pos + 1,Length(arg_Kenzo[w_i]));
    end;
  end;
  for w_i := 0 to arg_Satuei.Count - 1 do begin
    w_Pos := Pos('=',arg_Satuei[w_i]);
    if w_Pos <> 0 then begin
      arg_Satuei[w_i] := Copy(arg_Satuei[w_i],w_Pos + 1,Length(arg_Satuei[w_i]));
    end;
  end;
  for w_i := 0 to arg_Kanja.Count - 1 do begin
    w_Pos := Pos('=',arg_Kanja[w_i]);
    if w_Pos <> 0 then begin
      arg_Kanja[w_i] := Copy(arg_Kanja[w_i],w_Pos + 1,Length(arg_Kanja[w_i]));
    end;
  end;
end;
(**
���I�[�_�w����񕔕��̓Ǎ���
�����F
  arg_Ini : TIniFile
��O�F����
���A�l�F
**)
procedure proc_ReadiniOrderIndicate(
                           arg_Ini : TIniFile
                           );
var
  wsl_Data : TStrings;
  w_i:Integer;
  w_Pos:Integer;
begin
  try
    wsl_Data := TStringList.Create;
    //�I�[�_�w�����Z�N�V�����ǂݍ���
    arg_Ini.ReadSectionValues(g_ORDERINDICATE_SECSION,wsl_Data);
    //������
    SetLength(g_OrderIndicate_Code,0);
    //�I�[�_�w�����f�[�^�L�[��
    for w_i := 0 to wsl_Data.Count - 1 do begin
      //�f�[�^�L�[�ƃf�[�^�𕪂���
      w_Pos := AnsiPos('=',wsl_Data[w_i]);
      //�f�[�^�L�[�ƃf�[�^������ꍇ
      if w_Pos <> 0 then begin
        //�i�[�ꏊ�쐬
        SetLength(g_OrderIndicate_Code,w_i + 1);
        //�f�[�^�L�[�擾
        g_OrderIndicate_Code[w_i].DATAKEY := Copy(wsl_Data[w_i],1,w_Pos - 1);
        //�쐬
        g_OrderIndicate_Code[w_i].DATA := TStringList.Create;
        //�f�[�^�ݒ�
        g_OrderIndicate_Code[w_i].DATA.CommaText := Copy(wsl_Data[w_i],w_Pos + 1,Length(wsl_Data[w_i]));
      end;
    end;
  finally
    if wsl_Data <> nil then
      FreeAndNil(wsl_Data);
  end;
end;
(**
��XML��񕔕��̓Ǎ���
�����F
  arg_Ini : TIniFile
��O�F����
���A�l�F
**)
procedure proc_ReadiniXML(
                          arg_Ini : TIniFile
                          );
var
  wsl_Data : TStrings;
  w_i:Integer;
  w_Pos:Integer;
begin
  try
    wsl_Data := TStringList.Create;
    //XML���Z�N�V�����ǂݍ���
    arg_Ini.ReadSectionValues(g_XML_SECSION,wsl_Data);
    //������
    SetLength(g_XML_Code,0);
    //XML���f�[�^�L�[��
    for w_i := 0 to wsl_Data.Count - 1 do begin
      //�f�[�^�L�[�ƃf�[�^�𕪂���
      w_Pos := AnsiPos('=',wsl_Data[w_i]);
      //�f�[�^�L�[�ƃf�[�^������ꍇ
      if w_Pos <> 0 then begin
        //�i�[�ꏊ�쐬
        SetLength(g_XML_Code,w_i + 1);
        //�f�[�^�L�[�擾
        g_XML_Code[w_i].XML_CHR := Copy(wsl_Data[w_i],1,w_Pos - 1);
        //�f�[�^�ݒ�
        g_XML_Code[w_i].RIS_CHR := Copy(wsl_Data[w_i],w_Pos + 1,Length(wsl_Data[w_i]));
      end;
    end;
  finally
    if wsl_Data <> nil then
      FreeAndNil(wsl_Data);
  end;
end;
(**
���_�~�[�R�[�h��񕔕��̓Ǎ���
�����F
  arg_Ini : TIniFile
��O�F����
���A�l�F
**)
procedure proc_ReadiniDummy_Code(
                          arg_Ini : TIniFile
                          );
var
  wsl_Data  : TStrings;
  wsl_Data2 : TStrings;
  w_i:Integer;
  w_Pos:Integer;
begin
  try
    wsl_Data := TStringList.Create;
    wsl_Data2 := TStringList.Create;
    //�������Z�N�V�����ǂݍ���
    arg_Ini.ReadSectionValues(g_HOUKOU_SECSION,wsl_Data);
    //���@���Z�N�V�����ǂݍ���
    arg_Ini.ReadSectionValues(g_HOUHOU_SECSION,wsl_Data2);
    //������
    SetLength(g_HOUKOU_Code,0);
    //������
    SetLength(g_HOUHOU_Code,0);
    //�������f�[�^�L�[��
    for w_i := 0 to wsl_Data.Count - 1 do begin
      //�f�[�^�L�[�ƃf�[�^�𕪂���
      w_Pos := AnsiPos('=',wsl_Data[w_i]);
      //�f�[�^�L�[�ƃf�[�^������ꍇ
      if w_Pos <> 0 then begin
        //�i�[�ꏊ�쐬
        SetLength(g_HOUKOU_Code,w_i + 1);
        //�f�[�^�L�[�擾
        g_HOUKOU_Code[w_i].KENSA_TYPE := Copy(wsl_Data[w_i],1,w_Pos - 1);
        //�f�[�^�ݒ�
        g_HOUKOU_Code[w_i].DUMMY_CODE := Copy(wsl_Data[w_i],w_Pos + 1,Length(wsl_Data[w_i]));
      end;
    end;
    //���@���f�[�^�L�[��
    for w_i := 0 to wsl_Data2.Count - 1 do begin
      //�f�[�^�L�[�ƃf�[�^�𕪂���
      w_Pos := AnsiPos('=',wsl_Data2[w_i]);
      //�f�[�^�L�[�ƃf�[�^������ꍇ
      if w_Pos <> 0 then begin
        //�i�[�ꏊ�쐬
        SetLength(g_HOUHOU_Code,w_i + 1);
        //�f�[�^�L�[�擾
        g_HOUHOU_Code[w_i].KENSA_TYPE := Copy(wsl_Data2[w_i],1,w_Pos - 1);
        //�f�[�^�ݒ�
        g_HOUHOU_Code[w_i].DUMMY_CODE := Copy(wsl_Data2[w_i],w_Pos + 1,Length(wsl_Data2[w_i]));
      end;
    end;
  finally
    if wsl_Data <> nil then
      FreeAndNil(wsl_Data);
    if wsl_Data2 <> nil then
      FreeAndNil(wsl_Data2);
  end;
end;
(**
�����҃v���t�@�C����񕔕��̓Ǎ���
�����F
  arg_Ini : TIniFile
��O�F����
���A�l�F
**)
procedure proc_ReadiniKanjaProf(
                           arg_Ini : TIniFile
                           );
var
  wsl_Data : TStrings;
  wsl_Data2 : TStrings;
  w_i:Integer;
  w_Pos:Integer;
begin
  try
    wsl_Data := TStringList.Create;
    wsl_Data2 := TStringList.Create;
    //���҃v���t�@�C�����Z�N�V�����ǂݍ���
    arg_Ini.ReadSectionValues(g_KANJAPROF_SECSION,wsl_Data);
    //���҃v���t�@�C���R�[�h���Z�N�V�����ǂݍ���
    arg_Ini.ReadSectionValues(g_KANJAPROFCODE_SECSION,wsl_Data2);
    //������
    SetLength(g_KanjaProf_Code,0);
    SetLength(g_KanjaProfCode_Code,0);
    //���҃v���t�@�C�����f�[�^�L�[��
    for w_i := 0 to wsl_Data.Count - 1 do begin
      //�f�[�^�L�[�ƃf�[�^�𕪂���
      w_Pos := AnsiPos('=',wsl_Data[w_i]);
      //�f�[�^�L�[�ƃf�[�^������ꍇ
      if w_Pos <> 0 then begin
        //�i�[�ꏊ�쐬
        SetLength(g_KanjaProf_Code,w_i + 1);
        //�f�[�^�L�[�擾
        g_KanjaProf_Code[w_i].DATAKEY := Copy(wsl_Data[w_i],1,w_Pos - 1);
        //�쐬
        g_KanjaProf_Code[w_i].DATA := TStringList.Create;
        //�f�[�^�ݒ�
        g_KanjaProf_Code[w_i].DATA.CommaText := Copy(wsl_Data[w_i],w_Pos + 1,Length(wsl_Data[w_i]));
      end;
    end;
    //���҃v���t�@�C�����f�[�^�L�[��
    for w_i := 0 to wsl_Data2.Count - 1 do begin
      //�f�[�^�L�[�ƃf�[�^�𕪂���
      w_Pos := AnsiPos('=',wsl_Data2[w_i]);
      //�f�[�^�L�[�ƃf�[�^������ꍇ
      if w_Pos <> 0 then begin
        //�i�[�ꏊ�쐬
        SetLength(g_KanjaProfCode_Code,w_i + 1);
        //�f�[�^�L�[�擾
        g_KanjaProfCode_Code[w_i].DATAKEY := Copy(wsl_Data2[w_i],1,w_Pos - 1);
        //�쐬
        g_KanjaProfCode_Code[w_i].DATA := TStringList.Create;
        //�f�[�^�ݒ�
        g_KanjaProfCode_Code[w_i].DATA.CommaText := Copy(wsl_Data2[w_i],w_Pos + 1,Length(wsl_Data2[w_i]));
      end;
    end;
  finally
    if wsl_Data <> nil then
      FreeAndNil(wsl_Data);
    if wsl_Data2 <> nil then
      FreeAndNil(wsl_Data2);
  end;
end;
(** 2004.03.24
���I���N���G���[��񕔕��̓Ǎ���
�����F
  arg_Ini : TIniFile;
  var arg_OraErr:TStringList �I���N���G���[�ԍ�
��O�F����
���A�l�F
**)
procedure proc_ReadiniOraErr(arg_Ini : TIniFile;var arg_OraErr:TStrings);
begin
  //������
  arg_OraErr := TStringList.Create;
  //�I���N���G���[�ԍ��Z�N�V�������ǂݍ���
  arg_OraErr.CommaText := func_IniReadString(
                               arg_Ini,
                               g_ORAERR_SECSION,
                               g_ORAERR_KEY,
                               g_DEFORAERR);
end;
//���@�\ INI�t�@�C���̓Ǎ���
//�����F����
//��O�F����
//���A�l�FTrue False
function func_TcpReadiniFile: Boolean;
var
  w_ini,w_ini_B: TIniFile;
begin
  Result:=True;
  try
    if not FileExists(g_TcpIniPath + G_TCPINI_FNAME) then begin
      Result := False;
      Exit;
    end;
    //�J�^�J�i�����[�}���ϊ�������
    func_Kana_To_Roma_s(0);
    w_ini:=TIniFile.Create(g_TcpIniPath + G_TCPINI_FNAME);
    w_ini_B:=TIniFile.Create(g_TcpIniPath + G_BACKINI_FNAME);
    try
      //SERVICE���
      g_Svc_Sd_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_SDACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Sd_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_SDCYCLE_KEY,
                               g_SVC_SDCYCLE);
      g_Svc_Rv_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RVACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Rv_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RVCYCLE_KEY,
                               g_SVC_RVCYCLE);

      //DB���
      g_RisDB_Name :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_NAME_KEY,
                               g_DB_NAME);
      g_RisDB_Uid :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_UID_KEY,
                               g_DB_UID);
      g_RisDB_Pas :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_PAS_KEY,
                               g_DB_PAS);
      g_RisDB_DpendSrvName :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_SERVICE_KEY,
                               g_DB_SERVICE);
      g_RisDB_Retry :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_RETRY_KEY,
                               g_DB_RETRY);
      g_RisDB_SndKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_SNDKEEP_KEY,
                               g_DB_SNDKEEP);
      g_RisDB_RcvKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_RCVKEEP_KEY,
                               g_DB_RCVKEEP);
      //�\�P�b�g���
      g_C_Socket_Info_01:=func_ReadiniCInfo(w_ini,'1');
      g_C_Socket_Info_02:=func_ReadiniCInfo(w_ini,'2');
      g_C_Socket_Info_03:=func_ReadiniCInfo(w_ini,'3');
      g_C_Socket_Info_04:=func_ReadiniCInfo(w_ini,'4');
      g_C_Socket_Info_05:=func_ReadiniCInfo(w_ini,'5');
      g_C_Socket_Info_06:=func_ReadiniCInfo(w_ini,'6');
      g_S_Socket_Info_01:=func_ReadiniSInfo(w_ini,'1');
      g_S_Socket_Info_02:=func_ReadiniSInfo(w_ini,'2');
      g_S_Socket_Info_03:=func_ReadiniSInfo(w_ini,'3');
      g_S_Socket_Info_04:=func_ReadiniSInfo(w_ini,'4');
      g_S_Socket_Info_05:=func_ReadiniSInfo(w_ini,'5');
      g_S_Socket_Info_06:=func_ReadiniSInfo(w_ini,'6');
      //LOG���
      g_Rig_LogActive :=
            func_IniReadString(
                               w_ini,
                               g_LOG_SECSION,
                               g_SOCKET_LOGACTIVE_KEY,
                               g_SOCKET_LOGDEACTIVE);
      g_Rig_LogPath :=
            func_IniReadString(
                               w_ini,
                               g_LOG_SECSION,
                               g_SOCKET_LOGPATH_KEY,
                               g_SOCKET_LOGPATH);
      //INI�t�@�C���Ɠ����ꏊ
      if not(DirectoryExists(g_Rig_LogPath)) then
         g_Rig_LogPath := g_TcpIniPath;
      g_Rig_LogSize :=
            func_IniReadString(
                               w_ini,
                               g_LOG_SECSION,
                               g_SOCKET_LOGSIZE_KEY,
                               g_SOCKET_LOGSIZE);
      g_Rig_LogKeep :=
            func_IniReadInt(
                               w_ini,
                               g_LOG_SECSION,
                               g_SOCKET_LOGKEEP_KEY,
                               g_SOCKET_LOGKEEP);
      g_Rig_LogIncMsg :=
            func_IniReadString(
                               w_ini,
                               g_LOG_SECSION,
                               g_SOCKET_LOGINCMSG_KEY,
                               g_SOCKET_LOGINCMSG);
      g_Rig_LogLevel :=
            func_IniReadString(
                               w_ini,
                               g_LOG_SECSION,
                               g_SOCKET_LOGLEVEL_KEY,
                               g_SOCKET_LOGLEVEL);
      g_Name_Kansen01 :=
            func_IniReadString(
                               w_ini,
                               g_NAME_SECSION,
                               g_KANSEN_NAME01_KEY,
                               g_KANSEN_NAME01);
      g_Prof01 :=
            func_IniReadString(
                               w_ini,
                               g_PROF_SECSION,
                               g_PROF01_KEY,
                               g_DEFPROF01);
      g_Prof02 :=
            func_IniReadString(
                               w_ini,
                               g_PROF_SECSION,
                               g_PROF02_KEY,
                               g_DEFPROF02);
      g_Schema_Main :=
            func_IniReadString(
                               w_ini,
                               g_SCHE_SECSION,
                               g_SCHEMAIN_KEY,
                               g_DEFMAIN);
      g_Schema_Sub :=
            func_IniReadString(
                               w_ini,
                               g_SCHE_SECSION,
                               g_SCHESUB_KEY,
                               g_DEFSUB);
      g_Schema_Del :=
            func_IniReadString(
                               w_ini,
                               g_SCHE_SECSION,
                               g_SCHEDEL_KEY,
                               g_DEFDELSUB);

      g_Svr_Main :=
            func_IniReadString(
                               w_ini_B,
                               g_PATH_SECSION,
                               g_PATHMAIN_KEY,
                               g_DEFMAINPATH);
      g_Svr_Back :=
            func_IniReadString(
                               w_ini_B,
                               g_PATH_SECSION,
                               g_PATHSUB_KEY,
                               g_DEFSUBPATH);
      g_Save_Active :=
            func_IniReadString(
                               w_ini_B,
                               g_ACTIVE_SECSION,
                               g_PATHACTIVE_KEY,
                               g_DEFACTIVE);
      proc_ReadiniYoyaku(w_ini,g_Kikitaiou);

      proc_ReadiniKenzo(w_ini,g_Kenzo,g_Satuei,g_KanjaJyoutai);

      proc_ReadiniOrderIndicate(w_ini);

      proc_ReadiniXML(w_ini);

      proc_ReadiniDummy_Code(w_ini);

      g_OrderIndicate_Up :=
            func_IniReadString(
                               w_ini,
                               g_ORDERINDICATE_SECSION,
                               g_ORDERINDICATE_KEY,
                               g_DEFORDERINDICATE);

      proc_ReadiniKanjaProf(w_ini);
      //2004.03.24
      proc_ReadiniOraErr(w_ini,g_OraErrNo);
    finally
      w_ini.Free;
      w_ini_B.Free;
    end;
  exit;
  except
    Result:=False;
    exit;
  end;

end;
//-----------------------------------------------------------------------------
//1.���O�o�͊֐��n
//-----------------------------------------------------------------------------

{
-----------------------------------------------------------------------------
  ���O : proc_LogOperate(Operate);
  ���� :
   arg_Status: string; 'NG'�ُ� 'OK'���� '  '���̑�
   arg_Time:string;    '2001/10/10 15:00:00' ''�}�V������
   arg_Operate:string  ���O���e

   Operate: string : ���e
  �@�\ : ���O�t�@�C���ɕ�������L�^����B���w��
  ��O�͂��ׂĖ�������̂łȂ�
-----------------------------------------------------------------------------
}
procedure proc_LogOperate(
   arg_Status: string;
   arg_Time:string;
   arg_Operate:string
   );
var
  w_LogFile :string;
  w_LogFileBak1: string;
  w_LogFileBak2: string;
  buffer: string;
  hd, Size,w_i: Integer;
  fp: TextFile;
begin
  // ���O�������̏ꍇ�́A�������Ȃ��B
  //if g_Rig_LogActive<>g_SOCKET_LOGACTIVE then Exit;
//****//2002.01.30
  if g_Rig_LogActive=g_SOCKET_LOGDEACTIVE then Exit;
  if (g_Rig_LogActive=g_SOCKET_LOGACTIVE2)
  and
     (arg_Status<>G_LOG_LINE_HEAD_NG)
  then Exit;
//****//2002.01.30
try
  w_LogFile:=g_Rig_LogPath + g_LogPlefix + '0' + G_LOG_PKT_PTH_DEF;
  //�����̕⊮
  if func_IsNullStr(arg_Time) then
    arg_Time:=FormatDateTime('yyyy/mm/dd hh:mm:ss', Now);
  //�o�̓��b�Z�[�W�\��
  buffer := arg_Status + ',' + arg_Time + ',' + arg_Operate;

  if FileExists(w_LogFile) then
  begin
    // ���O�̃T�C�Y���m�F����B
    hd:=FileOpen(w_LogFile, fmOpenRead or fmShareDenyWrite);
    Size:=GetFileSize(hd, nil);
    FileClose(hd);
    Size:= Size+ length(AnsiString(buffer));
    if Size >= StrToIntDef(g_Rig_LogSize,65536) then
    begin
      // ���T�C�Y�𒴂����ꍇ�́A�o�b�N�A�b�v���Ƃ�B
      for w_i := (g_Rig_LogKeep-2)    downto 0  do
      begin
        w_LogFileBak1:=g_Rig_LogPath + g_LogPlefix + IntToStr(w_i) + G_LOG_PKT_PTH_DEF;
        if FileExists(w_LogFileBak1) then
        begin
          w_LogFileBak2:=g_Rig_LogPath + g_LogPlefix + IntToStr(w_i+1) + G_LOG_PKT_PTH_DEF;
          if FileExists(w_LogFileBak2) then
          begin
             DeleteFile(w_LogFileBak2);
          end;
          RenameFile(w_LogFileBak1, w_LogFileBak2);
        end;
      end;
      AssignFile(fp, w_LogFile);
      try
        Rewrite(fp);
        Writeln(fp, buffer);
      finally
        CloseFile(fp);
      end;
    end
    else
    begin
      // �����̃��O�ɒǋL����B
      AssignFile(fp, w_LogFile);
      try
        Append(fp);
        Writeln(fp, buffer);
      finally
        CloseFile(fp);
      end;
    end;
  end
  else
  begin
    // �V�K�Ƀ��O���쐬����B
    AssignFile(fp, w_LogFile);
    try
     Rewrite(fp);
     Writeln(fp, buffer);
    finally
     CloseFile(fp);
    end;
  end;
except
  exit;
end;
end;
//���O������쐬
function  func_LogStr(arg_Kind:integer; arg_Diteil:string): string;
var
 w_s:string;
begin
 w_s := g_Log_Type[arg_Kind].f_LogMsg + StringOfChar(chr($20),G_LOGGMSG_LEN);
 w_s := func_BCopy(w_s,G_LOGGMSG_LEN);
 result := w_s + '�i' + arg_Diteil +'�j' ;
end;
{
-----------------------------------------------------------------------------
  ���O : proc_LogOut(arg_Kind:string; arg_Diteil:string);
  ���� :
   arg_Status  : 'NG'�ُ� 'OK'���� '  '���̑�
   arg_Time    : '2001/10/10 15:00:00' ''�}�V������
   arg_Kind    : ���O���e���
   arg_Diteil  : ���O���e�ڍ�
  �@�\ : User�Ƀ��O�o�͋@�\��񋟂���
  ��O�͂��ׂĖ�������̂łȂ�
-----------------------------------------------------------------------------
}
procedure proc_LogOut(
     arg_Status: string;
     arg_Time:string;
     arg_Kind:integer;
     arg_Diteil:string);
var
 w_s:string;
begin
 try
  w_s := func_LogStr(arg_Kind,arg_Diteil);
  if (g_Log_Type[arg_Kind].f_LogLevel <= StrToIntDef(g_Rig_LogLevel,0)) then
  begin
    proc_LogOperate(arg_Status,arg_Time,w_s);
  end;
 except
  exit;
 end;
end;
//-----------------------------------------------------------------------------
//6.���̑��n
//-----------------------------------------------------------------------------
//�J���}��؂�Ō�������
procedure  proc_StrConcat(
           var arg_LogBase   : string;
           arg_Log           : string
           );
begin
  if arg_Log='' then exit;
  if (arg_LogBase='') then
  begin
    arg_LogBase := arg_Log;
  end
  else
  begin
    arg_LogBase := arg_LogBase + ',' + arg_Log;
  end;
end;
function func_IsNumberStr(arg_str1:string): BOOlean;
begin
  result:=func_IsInstr(arg_str1,'0123456789');
end;

//2001.12.27
//�S�p�u�����N�̗����g����
function func_MBTrim(arg_str:string) : string;
var
  w_s:string;
begin
  w_s := arg_str;
  w_s:=func_MBTrimLeft(w_s);
  w_s:=func_MBTrimRight(w_s);
  result := w_s;
end;
//�S�p�u�����N�̉E���g����
function func_MBTrimRight(arg_str:string): string;
var
  w_s:string;
  w_ZBLK :string;
begin
  w_ZBLK:='�@';
  w_s := arg_str;
  w_s := TrimRight(w_s);
  while  (Length(w_s)>1)
     and (w_s[Length(w_s)] = w_ZBLK[2])
     and (w_s[Length(w_s)-1] = w_ZBLK[1]) do
  begin
    Delete(w_s, Length(w_s), 1);
    Delete(w_s, Length(w_s), 1);
    w_s := TrimRight(w_s);
  end;
  result := w_s;
end;
//�S�p�u�����N�̍����g����
function func_MBTrimLeft(arg_str:string) : string;
var
  w_s:string;
  w_ZBLK :string;
begin
  w_ZBLK:='�@';
  w_s := arg_str;
  w_s := TrimLeft(w_s);
  while (Length(w_s)>1)
   and  (w_s[1] = w_ZBLK[1])
   and  (w_s[2] = w_ZBLK[2]) do
  begin
    Delete(w_s, 1, 2);
    w_s := TrimLeft(w_s);
  end;
  result := w_s;
end;
{
-----------------------------------------------------------------------------
  ���O :func_LeftSpace
  ���� :
    intCapa:Integer �o�C�g��
    EditStr:String  �ύX������
  ���A�l�F��O�Ȃ�
  �@�\ :
    1. �X�y�[�X�������ɕK�v���쐬���܂��B
 *
-----------------------------------------------------------------------------
}
function func_LeftSpace( intCapa : Integer ; EditStr : String  ): String;
var
  lp    : Integer;
  len   : Integer;
  wkbuf : String;   //���������K�v�X�y�[�X
begin
  //�X�y�[�X�o�C�g��
  len := intCapa - Length(EditStr);
  //������
  wkBuf := '';
  //�͈͓���
  if len > 0 then begin
    //�X�y�[�X�o�C�g�����̔��p�X�y�[�X�̍쐬
    for lp := 1 to len do begin
      wkBuf := wkBuf + chr(32); //���p�X�y�[�X
    end;
    //������Ɣ��p�X�y�[�X�̌���
    wkBuf := wkBuf+EditStr;
  //�͈̓I�[�o�[��
  end else begin
    //�͈͓��ɐ؂���
    wkBuf := Copy(EditStr,1,intCapa);
  end;
  //�߂�l
  Result := wkBuf;
end;
{
-----------------------------------------------------------------------------
  ���O :func_RigthSpace
  ���� :
    intCapa:Integer �o�C�g��
    EditStr:String  �ύX������
  ���A�l�F��O�Ȃ�
  �@�\ :
    1. �X�y�[�X���E���ɕK�v���쐬���܂��B
 *
-----------------------------------------------------------------------------
}
function func_RigthSpace( intCapa : Integer ; EditStr : String  ): String;
var
  lp    : Integer;
  len   : Integer;
  wkbuf : String;   //���������K�v�X�y�[�X
begin
  //�X�y�[�X�o�C�g��
  len := intCapa - Length(EditStr);
  //������
  wkBuf := '';
  //�͈͓���
  if len > 0 then begin
    //�X�y�[�X�o�C�g�����̔��p�X�y�[�X�̍쐬
    for lp := 1 to len do begin
      wkBuf := wkBuf + chr(32); //���p�X�y�[�X
    end;
    //������Ɣ��p�X�y�[�X�̌���
    wkBuf := EditStr + wkBuf;
  //�͈̓I�[�o�[��
  end else begin
    //�͈͓��ɐ؂���
    wkBuf := Copy(EditStr,1,intCapa);
  end;
  //�߂�l
  Result := wkBuf;
end;
{
-----------------------------------------------------------------------------
  ���O :func_LeftZero
  ���� :
    intCapa:Integer �o�C�g��
    EditStr:String  �ύX������
  ���A�l�F��O�Ȃ�
  �@�\ :
    1. '0'�������ɕK�v���쐬���܂��B
 *
-----------------------------------------------------------------------------
}
function func_LeftZero( intCapa : Integer ; EditStr : String  ): String;
var
  lp    : Integer;
  len   : Integer;
  wkbuf : String;   //���������K�v�X�y�[�X
begin
  //�X�y�[�X�o�C�g��
  len := intCapa - Length(EditStr);
  //������
  wkBuf := '';
  //�͈͓���
  if len > 0 then begin
    //�X�y�[�X�o�C�g������'0'�̍쐬
    for lp := 1 to len do begin
      wkBuf := wkBuf + '0'; //'0'
    end;
    //�������'0'�̌���
    wkBuf := wkBuf+EditStr;
  //�͈̓I�[�o�[��
  end else begin
    //�͈͓��ɐ؂���
    wkBuf := Copy(EditStr,1,intCapa);
  end;
  //�߂�l
  Result := wkBuf;
end;

procedure proc_BUp_TxtOut(arg_path,arg_Flg,arg_Data:String;arg_DateTime:TDateTime);
var
  w_Qry:TQuery;
  w_LogPath,w_Log_File:String;
  SearchRec: TSearchRec;
  PathName: string;
  FileNameList:TStrings;
  w_i:Integer;
  wi_Max:Integer;
  TxtFile: TextFile;
begin
  w_Qry := TQuery.Create(nil);
  try
    //�d���쐬�̏ꍇ
    if g_Save_Active = CST_SAVE_ON then begin
      //�t�H���_��[�ۊǐ�iini�t�@�C���ɒ�`�j\YYYYMMDD]
      w_LogPath := arg_path +  '\' + FormatDateTime('YYYYMMDD',arg_DateTime);
      // �t�H���_�����݂��Ă��Ȃ��ꍇ�ɂ̓t�H���_��p�ӂ���B
      wi_Max := 0;
      if (DirectoryExists(w_LogPath)=False) then begin
        if ForceDirectories(w_LogPath) = False then begin
           proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_DB_IN_LEVEL,
                   '�ۑ���t�H���_����������Ȃ����߃o�b�N�A�b�v�p�e�L�X�g�쐬�Ɏ��s���܂����B�ۑ���t�H���_:' + w_LogPath
                   );
          Exit;
        end;
      end
      //�t�@�C�������݂���΂����ɂ͂O�O�P����A�Ԃ���
      else begin
        FileNameList:=TStringList.Create;
        FileNameList.Clear;
        try
          SysUtils.FindFirst(w_LogPath+'\*'+'.txt', faAnyFile, SearchRec);
          try
            if SearchRec.Name='' then Exit;
            repeat
              //�g���q�������������������o�ł���֐��I  EX.Test.txt�@���@Test
              PathName:= ChangeFileExt(SearchRec.Name,'');
              if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then begin
                if arg_Flg = Copy(PathName,1,1) then
                  FileNameList.Add(PathName);
              end;
              until SysUtils.FindNext(SearchRec)<>0;
          finally
            SysUtils.FindClose(SearchRec);
          end;
          //�I�[�_�ԍ����~�~�~.txt �� �~�~�~��MAX�l�����߂�
          for w_i := 0 to FileNameList.Count -1 do begin
            wi_Max := StrToInt(Right(FileNameList[w_i],3));
          end;
          wi_Max := wi_Max +1;
        finally
          FileNameList.Free;
        end;
      end;
      if wi_Max = 0 then
        wi_Max := 1;
      //���O�t�@�C����
      w_Log_File :=  '\' + arg_Flg + FormatDateTime('YYYYMMDDHHMMSS',arg_DateTime) + FormatCurr('000',StrToCurr(IntToStr(wi_Max))) + '.txt';
      if not FileExists(w_LogPath  + w_Log_File) then begin
        try
          AssignFile(TxtFile,w_LogPath + w_Log_File);
          try
            Rewrite(TxtFile);
          except
            //�X�e�[�^�X�\�������O�o��
            proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_SK_CL_LEVEL,'̧�ٍ쐬�G���[�@Rewrite');
            Exit;
          end;
        except
          //�X�e�[�^�X�\�������O�o��
          proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_SK_CL_LEVEL,'̧�ٍ쐬�G���[�@AssignFile');
          Exit;
        end;
      end;
      try
        try
          Writeln(TxtFile, arg_Data);
        except
          //�X�e�[�^�X�\�������O�o��
          proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_SK_CL_LEVEL,'̧�ٍ쐬�G���[�@Writeln');
          Exit;
        end;
      finally
        Flush(TxtFile);
        CloseFile(TxtFile);
      end;
    end;
 finally
   if w_Qry <> nil then begin
     w_Qry.Close;
     w_Qry.Free;
   end;
 end;
end;

function bswap(src : integer) : integer; assembler;
asm
  bswap eax
end;

function bswapf(src : single) : single;
var
  i : integer absolute src;
begin
  i := bswap(i);
  result := src;
end;

procedure ByteOrderSwap(var Src: Double); overload;
var
  Mdp: Array[0..4] of Byte Absolute Src;
  Byt: Byte;
  i: Integer;
begin
  for i:=0 to 1 do begin
    Byt:=Mdp[I];
    Mdp[I]:=Mdp[4-i];
    Mdp[4-i]:=Byt;
  end;
end;
function EndianShort_Short(Value: Short): Short;
begin
  Result := ((Value and $FF00)shr 8) + ((Value and $00FF)shl 8);
end;

function func_Lowerc(arg_string : String):String;
var
  w_i  : Integer;
  w_ii : Integer;
begin
  Result := '';
  for w_i := 0 to 15 do begin
    for w_ii := 0 to 15 do begin
      if arg_string = Chr(StrToInt('$' + ASC2_CODE[w_i] + ASC2_CODE[w_ii])) then begin
        Result := ASC2_CODE[w_i] + ASC2_CODE[w_ii];
        Exit;
      end;
    end;
  end;
end;

function func_Change_XML(arg_string : String):String;
var
  w_i  : Integer;
  w_String : String;
begin
  Result := '';
  w_String := arg_string;
  //�ϊ�������
  for w_i := 0 to Length(g_XML_Code) - 1 do begin
    //������ϊ�
    w_String := StringReplace(w_String,g_XML_Code[w_i].RIS_CHR,g_XML_Code[w_i].XML_CHR,[rfReplaceAll]);
  end;
  Result := w_String;
end;

function func_Change_RIS(arg_string : String):String;
var
  w_i  : Integer;
  w_String : String;
begin
  Result := '';
  w_String := arg_string;
  //�ϊ�������
  for w_i := 0 to Length(g_XML_Code) - 1 do begin
    if '&' = g_XML_Code[w_i].XML_CHR then
      //������ϊ�
      w_String := StringReplace(w_String,g_XML_Code[w_i].XML_CHR,g_XML_Code[w_i].RIS_CHR,[rfReplaceAll]);
  end;
  //�ϊ�������
  for w_i := 0 to Length(g_XML_Code) - 1 do begin
    if '&' <> g_XML_Code[w_i].XML_CHR then
      //������ϊ�
      w_String := StringReplace(w_String,g_XML_Code[w_i].XML_CHR,g_XML_Code[w_i].RIS_CHR,[rfReplaceAll]);
  end;
  Result := w_String;
end;
//2004.03.24
function func_Search_OraErr(arg_Msg : String):String;
var
  w_i  : Integer;
begin
  //�����l�i�d���G���[�j
  Result := GPCST_TENSOU_JOUTAI_02;
  //ini�t�@�C���̕�
  for w_i := 0 to g_OraErrNo.Count - 1 do begin
    //�I���N���G���[���̃R�[�h������ꍇ
    if AnsiPos(g_OraErrNo.Strings[w_i],arg_Msg) <> 0 then begin
      //Retry�v��
      Result := GPCST_TENSOU_JOUTAI_03;
      //�����I��
      Break;
    end;
  end;
end;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ��Z�敪
function func_PIND_Change_SYUGI(
       arg_Code:string    //����
       ):string;          //����
var
   w_Res:string;
begin
  IF arg_Code=GPCST_CODE_SYUGI_0 THEN w_Res:= GPCST_NAME_SYUGI_0
  ELSE
  IF arg_Code=GPCST_CODE_SYUGI_1 THEN w_Res:= GPCST_NAME_SYUGI_1
  ELSE
  IF arg_Code=GPCST_CODE_SYUGI_2 THEN w_Res:= GPCST_NAME_SYUGI_2
{  ELSE
  IF arg_Code=GPCST_CODE_SYUGI_3 THEN w_Res:= GPCST_NAME_SYUGI_3}
  ELSE
  IF arg_Code=GPCST_NAME_SYUGI_0 THEN w_Res:= GPCST_CODE_SYUGI_0
  ELSE
  IF arg_Code=GPCST_NAME_SYUGI_1 THEN w_Res:= GPCST_CODE_SYUGI_1
  ELSE
  IF arg_Code=GPCST_NAME_SYUGI_2 THEN w_Res:= GPCST_CODE_SYUGI_2
//  ELSE
//  IF arg_Code=GPCST_NAME_SYUGI_3 THEN w_Res:= GPCST_CODE_SYUGI_3
  ELSE w_Res:= '';
  result:=w_Res;
end;
//�����g�p���@�\�i��O�L�j�F���ݔԍ�+1�擾
function func_Get_NumberControl(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Kubun:string;
         arg_Date:string
         ):integer;
var
  w_NO: integer;
  w_Date: string;
  w_Sys_Date: string;
  w_Year: string;
begin
  Result := 0;
  w_NO := 0;
  //�w��敪�Ȃ��̓G���[
  if arg_Kubun = '' then
    Exit;
  //���t�Ǘ�����̓V�X�e�����t�ɂ���
  if arg_Date <> '' then
    arg_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
  //��t���͔N�x�ɂ��؂�ւ��邽�ߓ��t�Ǘ��ɂ���
  if arg_Kubun = 'UNO' then
    arg_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
{2002.11.22
  //��t����20001�`
  if arg_Kubun = 'UNO' then
    w_NO := 20000;
2002.11.22}
  //12�Ԃ�601�`
  if arg_Kubun = 'S12' then
    w_NO := 600;
  //13�Ԃ�401�`
  if arg_Kubun = 'S13' then
    w_NO := 400;
  //15�Ԃ�101�`
  if arg_Kubun = 'S15' then
    w_NO := 100;
  //16�Ԃ�501�`
  if arg_Kubun = 'S16' then
    w_NO := 500;
  //17�Ԃ�201�`
  if arg_Kubun = 'S17' then
    w_NO := 200;
  //19�Ԃ�301�`
  if arg_Kubun = 'S19' then
    w_NO := 300;
  //�~�}��901�`
  if arg_Kubun = 'S99' then
    w_NO := 900;
//�ԍ��Ǘ����w��敪�̌��ݔԍ��{�P�����߂�
  arg_Database.StartTransaction;
  try
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT ');
      SQL.Add (' nb.* ');
      SQL.Add (' FROM NUMBERCONTROLTABLE nb ');
      SQL.Add (' WHERE nb.KANRI_ID = :PKANRI_ID ');
      SQL.Add (' for update ');
      if not Prepared then Prepare;
      ParamByName('PKANRI_ID').AsString := arg_Kubun;
      //Open;
      //First;
      ExecSQL;
    end;
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT ');
      SQL.Add (' nb.* ');
      SQL.Add (' FROM NUMBERCONTROLTABLE nb ');
      SQL.Add (' WHERE nb.KANRI_ID = :PKANRI_ID ');
      if not Prepared then Prepare;
      ParamByName('PKANRI_ID').AsString := arg_Kubun;
      Open;
      First;
    end;
//...���R�[�h����
    if not(arg_Query.Eof) then begin
      //...���t�Ǘ��Ȃ�
      if arg_Date = '' then begin
        if arg_Query.FieldByName('NOW_NO').AsString <> '' then begin
          w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
          //+1����
          w_NO := w_NO + 1;
        end;
      end
    //...���t�Ǘ�����
      else begin
{2002.11.22
        //�u��t���v�͔N�x�ɂ��؂�ւ���
        if arg_Kubun = 'UNO' then begin
          if arg_Query.FieldByName('UPDATEDATE').AsString <> '' then begin
            w_Year := FormatDateTime('YYYY', arg_Query.FieldByName('UPDATEDATE').AsDateTime);
            //�N���قȂ�ꍇ�͐V���Ɏn�߂�
            if w_Year <> Copy(arg_Date,1,4) then begin
              //+1����
              w_NO := w_NO + 1;
            end
            //�N�������ꍇ�͌��Ɂ{�P����
            else begin
              w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
              //+1����
              w_NO := w_NO + 1;
            end;
          end
          else begin
            //+1����
            w_NO := w_NO + 1;
          end;
        end
        //�ʏ�
        else begin
          if arg_Query.FieldByName('UPDATEDATE').AsString <> '' then begin
            w_Date := FormatDateTime('YYYY/MM/DD', arg_Query.FieldByName('UPDATEDATE').AsDateTime);
            //���t���قȂ�ꍇ�͐V���Ɏn�߂�
            if w_Date <> arg_Date then begin
              //+1����
              w_NO := w_NO + 1;
            end
            //���t�������ꍇ�͌��Ɂ{�P����
            else begin
              w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
              //+1����
              w_NO := w_NO + 1;
            end;
          end
          else begin
            //+1����
            w_NO := w_NO + 1;
          end;
        end;
2002.11.22}
        if arg_Query.FieldByName('UPDATEDATE').AsString <> '' then begin
          w_Date := FormatDateTime('YYYY/MM/DD', arg_Query.FieldByName('UPDATEDATE').AsDateTime);
          //���t���قȂ�ꍇ�͐V���Ɏn�߂�
          if w_Date <> arg_Date then begin
            //+1����
            w_NO := w_NO + 1;
          end
          //���t�������ꍇ�͌��Ɂ{�P����
          else begin
            w_NO := arg_Query.FieldByName('NOW_NO').AsInteger;
            //+1����
            w_NO := w_NO + 1;
          end;
        end
        else begin
          //+1����
          w_NO := w_NO + 1;
        end;
      end;
      if w_NO <= 0 then begin
        arg_Database.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
        Exit;
      end;
      //�ԍ��Ǘ��e�[�u���X�V
      w_Sys_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
      if not func_NumberControl_Update(arg_Database, arg_Query, 2, arg_Kubun, w_Sys_Date, w_NO) then begin
        arg_Database.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
        Exit;
      end;
      arg_Database.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
    end
//...���R�[�h�Ȃ�
    else begin
      //���R�[�h���Ȃ��ꍇ�͐V���Ɏn�߂�
      //+1����
      w_NO := w_NO + 1;
      //�ԍ��Ǘ��e�[�u���ǉ�
      w_Sys_Date := FormatDateTime('YYYY/MM/DD', func_GetDBSysDate(arg_Query));
      if not func_NumberControl_Update(arg_Database, arg_Query, 1, arg_Kubun, w_Sys_Date, w_NO) then begin
        arg_Database.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
        Exit;
      end;
      arg_Database.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
    end;
  except
    on E: Exception do begin
      arg_Database.Rollback; // ���s�����ꍇ�C�ύX��������
      Exit;
    end;
  end;
  //
  Result := w_NO;
end;
//�����g�p���@�\�i��O�L�j�F���ݔԍ��X�V
function func_NumberControl_Update(
         arg_Database:TDatabase;
         arg_Query:TQuery;
         arg_Mode:integer;
         arg_Kubun:string;
         arg_UpdateDate:string;
         arg_Now_NO:integer
         ):Boolean;
begin
  Result := False;
  if (arg_Mode <> 1) and  //�ǉ�
     (arg_Mode <> 2) then //�C��
    Exit;
//�X�V�J�n
//  arg_Database.StartTransaction;
  try
{
    with arg_Query do begin
      Close;
      SQL.Clear;
      SQL.Add ('SELECT ');
      SQL.Add (' nb.* ');
      SQL.Add (' FROM NUMBERCONTROLTABLE nb ');
      SQL.Add (' WHERE nb.KANRI_ID = :PKANRI_ID ');
      SQL.Add (' for update ');
      if not Prepared then Prepare;
      ParamByName('PKANRI_ID').AsString := arg_Kubun;
      //Open;
      //First;
      ExecSQL;
    end;
}
    //�ǉ�����
    if arg_Mode = 1 then begin
      with arg_Query do begin
        Close;
        SQL.Clear;
        SQL.Add ('INSERT INTO NUMBERCONTROLTABLE ');
        SQL.Add ('(');
        SQL.Add (' KANRI_ID,');
        SQL.Add (' UPDATEDATE,');
        SQL.Add (' NOW_NO ');
        SQL.Add (') VALUES ( ');
        SQL.Add (' :PKANRI_ID,');
        SQL.Add (' :PUPDATEDATE,');
        SQL.Add (' :PNOW_NO ');
        SQL.Add (')');
        if not Prepared then Prepare;
        ParamByName('PKANRI_ID').AsString := arg_Kubun;
        ParamByName('PUPDATEDATE').AsDate := func_StrToDate(arg_UpdateDate);
        ParamByName('PNOW_NO').AsInteger  := arg_Now_NO;
        ExecSQL;
      end;
    end
    //�C������
    else begin
      with arg_Query do begin
        Close;
        SQL.Clear;
        SQL.Add('UPDATE NUMBERCONTROLTABLE SET ');
        SQL.Add(' UPDATEDATE = :PUPDATEDATE ');
        SQL.Add(',NOW_NO = :PNOW_NO ');
        SQL.Add('WHERE ');
        SQL.Add(' KANRI_ID = :PKEYCODE ');
        if not Prepared then Prepare;
        ParamByName('PUPDATEDATE').AsDate := func_StrToDate(arg_UpdateDate);
        ParamByName('PNOW_NO').AsInteger  := arg_Now_NO;
        //�L�[
        ParamByName('PKEYCODE').AsString  := arg_Kubun;
        ExecSQL;
      end;
    end;
{
    try
      arg_Database.Commit; // ���������ꍇ�C�ύX���R�~�b�g����
    except
      on E: Exception do begin
        arg_Database.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
        Exit;
      end;
    end;
}
  except
    on E:Exception do begin
//      arg_Database.Rollback; // �R�~�b�g�Ŏ��s�����ꍇ�C�ύX��������
      Exit;
    end;
    on E: Exception do begin
//      arg_Database.Rollback; // ���s�����ꍇ�C�ύX��������
      Exit;
    end;
  end;
//����
  Result := True;
end;
//�ԍ��Ǘ��e�[�u�����ݔԍ��ҏW������������������������������������������
//���@�\�i��O���j�F�V�F�[�}�i�[�t�@�C�����쐬
function func_Make_ShemaName(arg_OrderNO,               //�I�[�_NO
                             arg_MotoFileName: string;  //HIS���ϖ�
                             arg_Index: integer         //����NO
                             ):string;                  //�i�[̧�ٖ�
var
  w_P: integer;
  w_Kakuchosi: string;
  w_i:Integer;
begin
  Result := '';
  if arg_MotoFileName = '' then
    Exit;
  //if arg_Index = 0 then
  //  Exit;
  //2003.02.17
  w_P := 0;
  //HIS���ϖ����g���q�ʒu�擾
  for w_i := Length(arg_MotoFileName) downto 1 do begin
    if Copy(arg_MotoFileName,w_i,1) = '.' then begin
      w_P := w_i;
      Break;
    end;
  end;
  //HIS���ϖ����g���q�ʒu�擾
  //w_P := Pos('.',arg_MotoFileName);
  if w_P <= 0 then
    Exit;

  w_Kakuchosi := Copy(arg_MotoFileName,w_P,Length(arg_MotoFileName)-w_P+1);

  //�i�[̧�ٖ��쐬�i̧�ٖ�="����NO_���ϕ���NO.HIS���ϊg���q"�j
  Result := arg_OrderNO + '_' + FormatFloat('00',arg_Index) + w_Kakuchosi;
end;

//-----------------------------------------------------------------------------
initialization
begin

//1)�N��PASS���m��
     g_TcpIniPath := ExtractFilePath( ParamStr(0) );
//�R�}���hEXE�t�@�C����
     g_Exe_FName  := ExtractFileName( ParamStr(0) );
//�R�}���hEXE�t�@�C�����v���t�B�b�N�X
     g_Exe_Name   := ChangeFileExt( g_Exe_FName, '' );
//LOG�v���t�B�b�N�X�����s�t�@�C�����ɂ���
     g_LogPlefix  := g_Exe_Name + '_';
//LOG TYPE ��ݒ�
     g_Log_Type[G_LOG_KIND_SVC_NUM].f_LogMsg   := G_LOG_KIND_SVC;
     g_Log_Type[G_LOG_KIND_SVC_NUM].f_LogLevel := G_LOG_KIND_SVC_LEVEL;

     g_Log_Type[G_LOG_KIND_SK_SV_NUM].f_LogMsg   := G_LOG_KIND_SK_SV;
     g_Log_Type[G_LOG_KIND_SK_SV_NUM].f_LogLevel := G_LOG_KIND_SK_SV_LEVEL;

     g_Log_Type[G_LOG_KIND_SK_CL_NUM].f_LogMsg   := G_LOG_KIND_SK_CL;
     g_Log_Type[G_LOG_KIND_SK_CL_NUM].f_LogLevel := G_LOG_KIND_SK_CL_LEVEL;

     g_Log_Type[G_LOG_KIND_DB_NUM].f_LogMsg   := G_LOG_KIND_DB;
     g_Log_Type[G_LOG_KIND_DB_NUM].f_LogLevel := G_LOG_KIND_DB_LEVEL;

     g_Log_Type[G_LOG_KIND_DB_IN_NUM].f_LogMsg   := G_LOG_KIND_DB_IN;
     g_Log_Type[G_LOG_KIND_DB_IN_NUM].f_LogLevel := G_LOG_KIND_DB_IN_LEVEL;

     g_Log_Type[G_LOG_KIND_DB_OUT_NUM].f_LogMsg   := G_LOG_KIND_DB_OUT;
     g_Log_Type[G_LOG_KIND_DB_OUT_NUM].f_LogLevel := G_LOG_KIND_DB_OUT_LEVEL;

     g_Log_Type[G_LOG_KIND_MS_ANLZ_NUM].f_LogMsg   := G_LOG_KIND_MS_ANLZ;
     g_Log_Type[G_LOG_KIND_MS_ANLZ_NUM].f_LogLevel := G_LOG_KIND_MS_ANLZ_LEVEL;

end;

finalization
begin
//
end;

end.


