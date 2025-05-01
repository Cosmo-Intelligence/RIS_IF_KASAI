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
  //2003.06.06
  �V���ȃT�[�r�X�쐬����Ƃ�����
�C���F2003.07.04�F���c
�@�@�@�@�@�@�@�@�@���҃v���t�@�C���Ɋ����Ǎ��ڒǉ�
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
  IdWinsock2,
  IdGlobal,
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Gval,
  jis2sjis,
  HisMsgDef,
  HisMsgDef01_IRAI,
  HisMsgDef02_JISSI,
  HisMsgDef03_CANCEL,
  HisMsgDef04_KANJA_Kekka,
  HisMsgDef05_KAIKEI,
  HisMsgDef06_RCE,
  Unit_DB
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
    f_Retry         : Integer;    //�^�C�}�[
  end;
//HIS������ʕϊ�
type
  THIS_Type = record
    f_HIS_ID : String; //HIS�`�[�R�[�h
    f_RIS_ID : String; //RIS�������
  end;
type TKensa_Type = array of THIS_Type;

//���O��ʒ�`���
const
  G_LOGGMSG_LEN = 22;
type
  TLog_Type = record
    f_LogMsg   : string[G_LOGGMSG_LEN];
    f_LogLevel : integer; //
  end;
//�萔�錾-------------------------------------------------------------------
//INI�t�@�C������`---------------------------------------------------------
const
 G_TCPINI_FNAME = 'ris_tcp.ini';
 G_RTTCPINI_FNAME = 'rtris_tcp.ini';
 //�Z�N�V�����FSERVICE���
 g_C_SVC_SECSION        = 'SERVICE' ;
   g_SVC_RESDACTIVE_KEY = 'resdactive';//�L�[
   g_SVC_ORRVACTIVE_KEY = 'orrvactive';//�L�[
   g_SVC_EXSDACTIVE_KEY = 'exsdactive';//�L�[
   g_SVC_SHEMAACTIVE_KEY = 'Shemaactive';//�L�[
     g_SVC_ACTIVE       = '1';//
     g_SVC_DEACTIVE     = '0';//
   (*
   g_SVC_KARVACTIVE_KEY = 'karvactive';//�L�[
   g_SVC_RSSDACTIVE_KEY = 'rssdactive';//�L�[
   *)
   g_SVC_RESDCYCLE_KEY  = 'resdcycle';//�L�[
   g_SVC_EXSDCYCLE_KEY  = 'exsdcycle';//�L�[
     g_SVC_SDCYCLE      = '10';//
   g_SVC_ORRVCYCLE_KEY  = 'orrvcycle';//�L�[
   (*
   g_SVC_RSSDCYCLE_KEY  = 'rssdcycle';//�L�[
   g_SVC_KARVCYCLE_KEY  = 'karvcycle';//�L�[
   *)
   g_SVC_SHEMACYCLE_KEY  = 'Shemacycle';//�L�[
     g_SVC_RVCYCLE      = '10';//
 //�Z�N�V�����FRIS DB�ڑ����
 g_C_DB_SECSION     = 'DBINF';
   //�f�f
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
   g_DB_SNDKEEP_KEY = 'resndkeep';//�L�[
   g_DB_SNDEXKEEP_KEY = 'exsndkeep';//�L�[
   g_DB_SNDRSKEEP_KEY = 'rssndkeep';//�L�[
   g_DB_SNDREKEEP_KEY = 'resndkeep';//�L�[
     g_DB_SNDKEEP   = '30';//
   g_DB_RCVKEEP_KEY = 'orrcvkeep';//�L�[
   g_DB_RCVKAKEEP_KEY = 'karcvkeep';//�L�[
   g_DB_SHEMAKEEP_KEY = 'Shemakeep';//�L�[
     g_DB_RCVKEEP   = '30';//
   //����
   g_REDB_NAME_KEY    = 'Redbname';//�L�[
     g_REDB_NAME      = 'ris_sv';//
   g_REDB_UID_KEY     = 'Redbuid';//�L�[
     g_REDB_UID       = 'ris';//
   g_REDB_PAS_KEY     = 'Redbpss';//�L�[
     g_REDB_PAS       = 'ris';//
(*
   //����
   g_RTDB_NAME_KEY    = 'RTdbname';//�L�[
     g_RTDB_NAME      = 'ris_sv';//
   g_RTDB_UID_KEY     = 'RTdbuid';//�L�[
     g_RTDB_UID       = 'ris';//
   g_RTDB_PAS_KEY     = 'RTdbpss';//�L�[
     g_RTDB_PAS       = 'ris';//
*)
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
   g_SOCKET_RetryCount_KEY     = 'RetryCount'     ;//�L�[ Timer
     g_SOCKET_RetryCount     = '3'   ;//�f�t�H���g

   g_SOCKET_SIP_KEY       = 'ServerIP'     ;//�L�[IP Address
     g_SOCKET_SIP       = '000.000.000.000'   ;//�f�t�H���g
   g_SOCKET_SPORT_KEY     = 'ServerPort'     ;//�L�[ IP port
     g_SOCKET_SPORT     = ''   ;//�f�t�H���g

   g_SOCKET_PORT_KEY      = 'Port'     ;//�L�[RIS IP port
     g_SOCKET_PORT        = '0000'   ;//�f�t�H���g

  //�Z�N�V�����F���O���
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

  //�Z�N�V�����FDB���O���(�I�[�_��M)
  g_DBLOG01_SECTION             = 'DB_LOG01';
  //�Z�N�V�����FDB���O���(��t���M)
  g_DBLOG02_SECTION             = 'DB_LOG02';
  //�Z�N�V�����FDB���O���(���{���M)
  g_DBLOG03_SECTION             = 'DB_LOG03';
  //�Z�N�V�����FDB���O���(�V�F�[�}�A�g)
  g_DBLOG04_SECTION             = 'DB_LOG04';
  //�Z�N�V�����FDB���O���
    g_DBLOG_LOGGING_KEY       = 'LOGGING';
      g_DBLOG_LOGGING_DEF     = '1';
    g_DBLOG_PATH_KEY          = 'PATH';
      g_DBLOG_PATH_DEF        = '.\Log\Log\';
    g_DBLOG_PREFIX_KEY        = 'PREFIX';
      g_DBLOG_PREFIX_DEF      = 'LOG';
    g_DBLOG_KEEPDAYS_KEY      = 'KEEPDAYS';
      g_DBLOG_KEEPDAYS_DEF    = '7';

  //�Z�N�V�����FDB�f�o�b�O���(�I�[�_��M)
  g_DBLOGDBG01_SECTION          = 'DB_DEBUG01';
  //�Z�N�V�����FDB�f�o�b�O���(��t���M)
  g_DBLOGDBG02_SECTION          = 'DB_DEBUG02';
  //�Z�N�V�����FDB�f�o�b�O���(���{���M)
  g_DBLOGDBG03_SECTION          = 'DB_DEBUG03';
  //�Z�N�V�����FDB�f�o�b�O���(�V�F�[�}�A�g)
  g_DBLOGDBG04_SECTION          = 'DB_DEBUG04';
  //�Z�N�V�����FDB�f�o�b�O���
    g_DBLOGDBG_LOGGING_KEY    = 'LOGGING';
      g_DBLOGDBG_LOGGING_DEF  = '1';
    g_DBLOGDBG_PATH_KEY       = 'PATH';
      g_DBLOGDBG_PATH_DEF     = '.\Log\Log\';
    g_DBLOGDBG_PREFIX_KEY     = 'PREFIX';
      g_DBLOGDBG_PREFIX_DEF   = 'LOG';
    g_DBLOGDBG_KEEPDAYS_KEY   = 'KEEPDAYS';
      g_DBLOGDBG_KEEPDAYS_DEF = '7';

  g_ROMA_SECSION  = 'ROMA';
    g_ROMA_1_KEY = 'ROMA1';//�L�[
        g_ROMA_1_DEF = '0';//
    g_ROMA_2_KEY = 'ROMA2';//�L�[
        g_ROMA_2_DEF = '0';//
    g_ROMA_3_KEY = 'ROMA3';//�L�[
        g_ROMA_3_DEF = '0';//
    g_ROMA_4_KEY = 'ROMA4';//�L�[
        g_ROMA_4_DEF = '0';//

  g_RIORDER_SECSION  = 'RIORDER';
    g_RIORDER_KEY = 'KAIKEI';//�L�[
        g_RIORDER_DEF = '0';//

  //�u�����N���ڃf�[�^�L�[
  CSTNULLDATAKEY = 'NULL';

  // �Ō�敪
  //HIS�R�[�h
  //�`�|�T
  DEF_HIS_KANGO_1 = '1';
  //�`�|�U
  DEF_HIS_KANGO_2 = '2';
  //�`�|�V
  DEF_HIS_KANGO_3 = '3';
  //�`�|�W
  DEF_HIS_KANGO_4 = '4';
  //�a�|�T
  DEF_HIS_KANGO_5 = '5';
  //�a�|�U
  DEF_HIS_KANGO_6 = '6';
  //�a�|�V
  DEF_HIS_KANGO_7 = '7';
  //�a�|�W
  DEF_HIS_KANGO_8 = '8';
  //�b�|�T
  DEF_HIS_KANGO_9 = '9';
  //�b�|�U
  DEF_HIS_KANGO_10 = '10';
  //�b�|�V
  DEF_HIS_KANGO_11 = '11';
  //�b�|�W
  DEF_HIS_KANGO_12 = '12';
  //RIS�R�[�h
  //�`�|�T
  DEF_RIS_KANGO_1 = '1';
  //�`�|�U
  DEF_RIS_KANGO_2 = '2';
  //�`�|�V
  DEF_RIS_KANGO_3 = '3';
  //�`�|�W
  DEF_RIS_KANGO_4 = '4';
  //�a�|�T
  DEF_RIS_KANGO_5 = '5';
  //�a�|�U
  DEF_RIS_KANGO_6 = '6';
  //�a�|�V
  DEF_RIS_KANGO_7 = '7';
  //�a�|�W
  DEF_RIS_KANGO_8 = '8';
  //�b�|�T
  DEF_RIS_KANGO_9 = '9';
  //�b�|�U
  DEF_RIS_KANGO_10 = '10';
  //�b�|�V
  DEF_RIS_KANGO_11 = '11';
  //�b�|�W
  DEF_RIS_KANGO_12 = '12';
  //����
  DEF_KANGO_1_NAME = '�`�|�T';
  DEF_KANGO_2_NAME = '�`�|�U';
  DEF_KANGO_3_NAME = '�`�|�V';
  DEF_KANGO_4_NAME = '�`�|�W';
  DEF_KANGO_5_NAME = '�a�|�T';
  DEF_KANGO_6_NAME = '�a�|�U';
  DEF_KANGO_7_NAME = '�a�|�V';
  DEF_KANGO_8_NAME = '�a�|�W';
  DEF_KANGO_9_NAME = '�b�|�T';
  DEF_KANGO_10_NAME = '�b�|�U';
  DEF_KANGO_11_NAME = '�b�|�V';
  DEF_KANGO_12_NAME = '�b�|�W';
  DEF_KANGO_99_NAME = '�s��';
  //ini�t�@�C�����e
  g_KANGO_SECSION = 'KANGO';

  // ���ҋ敪
  //HIS�R�[�h
  //�������
  DEF_HIS_KANJA_1 = '1';
  //������ᇂ̋^��
  DEF_HIS_KANJA_2 = '2';
  //�ǐ����
  DEF_HIS_KANJA_3 = '3';
  //��V����
  DEF_HIS_KANJA_4 = '4';
  //���̑�
  DEF_HIS_KANJA_5 = '5';
  //RIS�R�[�h
  //�������
  DEF_RIS_KANJA_1 = '1';
  //������ᇂ̋^��
  DEF_RIS_KANJA_2 = '2';
  //�ǐ����
  DEF_RIS_KANJA_3 = '3';
  //��V����
  DEF_RIS_KANJA_4 = '4';
  //���̑�
  DEF_RIS_KANJA_5 = '5';
  //����
  DEF_KANJA_1_NAME = '�������';
  DEF_KANJA_2_NAME = '������ᇂ̋^��';
  DEF_KANJA_3_NAME = '�ǐ����';
  DEF_KANJA_4_NAME = '��V����';
  DEF_KANJA_5_NAME = '���̑�';
  DEF_KANJA_9_NAME = '�s��';
  //ini�t�@�C�����e
  g_KANJA_SECSION = 'KANJA';

  // �~��敪
  //HIS�R�[�h
  //�S��
  DEF_HIS_KYUGO_1 = '1';
  //�쑗
  DEF_HIS_KYUGO_2 = '2';
  //�ƕ�
  DEF_HIS_KYUGO_3 = '3';
  //RIS�R�[�h
  //�S��
  DEF_RIS_KYUGO_1 = '1';
  //�쑗
  DEF_RIS_KYUGO_2 = '2';
  //�ƕ�
  DEF_RIS_KYUGO_3 = '3';
  //����
  DEF_KYUGO_1_NAME = '�S��';
  DEF_KYUGO_2_NAME = '�쑗';
  DEF_KYUGO_3_NAME = '�ƕ�';
  DEF_KYUGO_9_NAME = '�s��';
  //ini�t�@�C�����e
  g_KYUGO_SECSION = 'KYUGO';

  // ���t�^ABO
  //HIS�R�[�h
  //A
  DEF_HIS_BLOODABO_1 = '1';
  //B
  DEF_HIS_BLOODABO_2 = '2';
  //O
  DEF_HIS_BLOODABO_3 = '3';
  //AB
  DEF_HIS_BLOODABO_4 = '4';
  //RIS�R�[�h
  //A
  DEF_RIS_BLOODABO_1 = '1';
  //B
  DEF_RIS_BLOODABO_2 = '2';
  //O
  DEF_RIS_BLOODABO_3 = '3';
  //AB
  DEF_RIS_BLOODABO_4 = '4';
  //����
  DEF_BLOODABO_1_NAME = 'A';
  DEF_BLOODABO_2_NAME = 'B';
  DEF_BLOODABO_3_NAME = 'O';
  DEF_BLOODABO_4_NAME = 'AB';
  DEF_BLOODABO_9_NAME = '?';
  //ini�t�@�C�����e
  g_BLOODABO_SECSION = 'BLOODABO';

  // ���t�^RH
  //HIS�R�[�h
  //-
  DEF_HIS_BLOODRH_1 = '-';
  //+
  DEF_HIS_BLOODRH_2 = '+';
  //RIS�R�[�h
  //-
  DEF_RIS_BLOODRH_1 = '-';
  //+
  DEF_RIS_BLOODRH_2 = '+';
  //����
  DEF_BLOODRH_1_NAME = 'RH-';
  DEF_BLOODRH_2_NAME = 'RH+';
  DEF_BLOODRH_9_NAME = '?';
  //ini�t�@�C�����e
  g_BLOODRH_SECSION = 'BLOODRH';

  // ��Q���
  //HIS�R�[�h
  //��
  DEF_SYOUGAI_0 = '0';
  //�L
  DEF_SYOUGAI_1 = '1';
  //����
  DEF_SYOUGAI_0_NAME = '��';
  DEF_SYOUGAI_1_NAME = '�L';

  //ini�t�@�C�����e
  g_SYOUGAINAME_SECSION = 'SYOUGAINAME';
    g_SYOUGAINAMEO1_KEY = 'NAME';      //�f�[�^�L�[
      g_DEFSYOUGAINAMEO1 = '���o��Q,���o��Q,�����Q,�ӎ���Q,���_��Q,' +
                           '�^����Q,������Q,�y�[�X���[�J�[';  //����

  // �������
  //HIS�R�[�h
  //�z��
  DEF_KANSEN_0 = '+';
  //�A��
  DEF_KANSEN_1 = '-';
  //�s��
  DEF_KANSEN_2 = '?';
  //RIS�R�[�h
  //�����Ȃ�
  DEF_RIS_KANSEN_0 = '0';
  //��������
  DEF_RIS_KANSEN_1 = '1';
  //����
  DEF_KANSEN_0_NAME = '�z��';
  DEF_KANSEN_1_NAME = '�A��';
  DEF_KANSEN_2_NAME = '�s��';
  DEF_KANSEN_9_NAME = '������';

  //ini�t�@�C�����e
  g_KANSEN_SECSION  = 'KANSEN';

  g_KANSENNAME_SECSION  = 'KANSENNAME';
    g_KANSENNAMEO1_KEY  = 'NAME';      //�f�[�^�L�[
      g_DEFKANSENNAMEO1 = '�g�a���R��,�g�a���R��,�g�u�b�R��,�g�h�u,' +
                          '�g�s�k�u�|�h,�~�łq�o�q,�~�łs�o�k�`,�l�q�r�`,���̑�';  //����
  g_KANSENON_SECSION    = 'KANSENON';
    g_KANSENONO1_KEY    = 'ON';      //�f�[�^�L�[
      g_DEFKANSENONO1   = DEF_KANSEN_0 + ',' + DEF_KANSEN_2;  //����

  // �֊����
  //HIS�R�[�h
  //��
  DEF_KINKI_0 = '0';
  //�L
  DEF_KINKI_1 = '1';
  //����
  DEF_KINKI_0_NAME = '��';
  DEF_KINKI_1_NAME = '�L';

  //ini�t�@�C�����e
  g_KINKINAME_SECSION  = 'KINKINAME';
    g_KINKINAMEO1_KEY  = 'NAME';      //�f�[�^�L�[
      g_DEFKINKINAMEO1 = '�s����,�y�j�V����,���[�h,���̑�';  //����


  // �ً}�敪
  //HIS�R�[�h
  //�Ȃ�
  DEF_HIS_KINKYU_0 = '0';
  //�ً}
  DEF_HIS_KINKYU_1 = '1';
  //RIS�R�[�h
  //�Ȃ�
  DEF_RIS_KINKYU_0 = '0';
  //�ً}
  DEF_RIS_KINKYU_1 = '1';
  //����
  DEF_KINKYU_0_NAME = '�Ȃ�';
  DEF_KINKYU_1_NAME = '�ً}';
  //ini�t�@�C�����e
  g_KINKYU_SECSION = 'KINKYU';

  // ���}�敪
  //HIS�R�[�h
  //�Ȃ�
  DEF_HIS_SIKYU_0 = '0';
  //���}
  DEF_HIS_SIKYU_1 = '1';
  //RIS�R�[�h
  //�Ȃ�
  DEF_RIS_SIKYU_0 = '0';
  //���}
  DEF_RIS_SIKYU_1 = '1';
  //����
  DEF_SIKYU_0_NAME = '�Ȃ�';
  DEF_SIKYU_1_NAME = '���}';
  //ini�t�@�C�����e
  g_SIKYU_SECSION = 'SIKYU';

  // ���}�����敪
  //HIS�R�[�h
  //�Ȃ�
  DEF_HIS_GENZO_0 = '0';
  //���}����
  DEF_HIS_GENZO_1 = '1';
  //RIS�R�[�h
  //�Ȃ�
  DEF_RIS_GENZO_0 = '0';
  //���}����
  DEF_RIS_GENZO_1 = '1';
  //����
  DEF_GENZO_0_NAME = '�Ȃ�';
  DEF_GENZO_1_NAME = '���}����';
  //ini�t�@�C�����e
  g_GENZO_SECSION = 'GENZO';

  // �\��敪
  //HIS�R�[�h
  //�����
  DEF_HIS_YOYAKU_O = 'O';
  //�۰�ޗ\��
  DEF_HIS_YOYAKU_C = 'C';
  //�\��Ȃ�
  DEF_HIS_YOYAKU_N = 'N';
  //RIS�R�[�h
  //�����
  DEF_RIS_YOYAKU_O = 'O';
  //�۰�ޗ\��
  DEF_RIS_YOYAKU_C = 'C';
  //�\��Ȃ�
  DEF_RIS_YOYAKU_N = 'N';
  //����
  DEF_YOYAKU_O_NAME = '�����';
  DEF_YOYAKU_C_NAME = '�۰�ޗ\��';
  DEF_YOYAKU_N_NAME = '�\��Ȃ�';
  //ini�t�@�C�����e
  g_YOYAKU_SECSION = 'YOYAKU';

  // �ǉe�敪
  //HIS�R�[�h
  //�s�v
  DEF_HIS_DOKUEI_0 = '0';
  //�v�ǉe
  DEF_HIS_DOKUEI_1 = '1';
  //RIS�R�[�h
  //�s�v
  DEF_RIS_DOKUEI_0 = '0';
  //�v�ǉe
  DEF_RIS_DOKUEI_1 = '1';
  //����
  DEF_DOKUEI_0_NAME = '�s�v';
  DEF_DOKUEI_1_NAME = '�v�ǉe';
  //ini�t�@�C�����e
  g_DOKUEI_SECSION = 'DOKUEI';
  //ini�t�@�C�����e
  g_TYPE_SECSION = 'TYPE';
    g_TYPEO1_KEY = 'RIS';      //�f�[�^�L�[
    g_TYPEO2_KEY = 'THERARIS';      //�f�[�^�L�[
    g_TYPEO3_KEY = 'REPORT';      //�f�[�^�L�[
      g_DEFTYPE = '';  //�R�[�h
  //ini�t�@�C�����e
  g_REPORTTYPE_SECSION = 'REPORTTYPE';
  (*
  // �f�f�ڑ����
  g_RRIS_SECSION  = 'RRISUSER';
    g_RRIS_KEY = 'USER';//�L�[
        g_RRIS_DEF = 'RRIS';//
  // ���Ðڑ����
  g_RTRIS_SECSION  = 'RTRISUSER';
    g_RTRIS_KEY = 'USER';//�L�[
        g_RTRIS_DEF = 'RTRIS';//
  CST_RT_TYPEID_31 = '31';
  *)

  // �ޗ����
  //ini�t�@�C�����e
  g_ZAI_CODE_SECSION = 'ZAI_CODE';
    g_ZAI_CODE_KEY = 'CODE';      //�f�[�^�L�[
      g_DEFZAI_CODE = '';  //�R�[�h
  //2007.07.04
  // �O���[�v���ڃR�[�h���
  //ini�t�@�C�����e
  g_KOUMOKU_CODE_SECSION = 'KOUMOKU_CODE';
    g_KOUMOKUCODE_KEY = 'CODE';      //�f�[�^�L�[
      g_DEFKOUMOKUCODE = '';  //�R�[�h
    g_NOT_ACCOUNT_KEY = 'NOT_ACCOUNT';      //�f�[�^�L�[
      g_DEFNOT_ACCOUNT = '';  //�R�[�h
  //2007.07.04
  // ���׍��ڃR�[�h���
  //ini�t�@�C�����e
  g_MEISAI_CODE_SECSION = 'MEISAI_CODE';
    g_MEISAICODE_KEY = 'CODE';      //�f�[�^�L�[
      g_DEFMEISAICODE = '';  //�R�[�h
    g_MEISAINOT_ACCOUNT_KEY = 'NOT_ACCOUNT';      //�f�[�^�L�[
      g_DEFMEISAINOT_ACCOUNT = '';  //�R�[�h

  // NOTESMARK���
  g_NOTESMARK_SECSION  = 'NOTESMARK';
    g_KANGOKBN_KEY = 'KANGOKBN';//�L�[
    g_KANJAKBN_KEY = 'KANJAKBN';//
  // HIS���M�Ȃ����
  g_HIS_SECSION  = 'HIS';
    g_HIS_ID_KEY = 'ID';//�L�[
  // �V�F�[�}���
  g_SHEMA_SECSION  = 'SHEMA';
    g_SHEMA_HIS_KEY = 'HIS_PASS';//�L�[
    g_SHEMA_LOCAL_KEY = 'LOCAL_PASS';//�L�[
    g_SHEMA_HTML_KEY = 'HTML_PASS';//�L�[
    //2008.09.12
    g_LOGONPASS_KEY = 'LOGONPASS';//�L�[
    g_LOGONUSER_KEY = 'LOGONUSER';//�L�[
    g_LOGONRETRY_KEY = 'LOGONRETRY';//�L�[

(*
  //ini�t�@�C�����e
  g_ENTRY_SECSION = 'ENTRY';
    g_ENTRY_USER_KEY = 'USER';      //�f�[�^�L�[
    g_ENTRY_USERNAME_KEY = 'SERNAME';      //�f�[�^�L�[
      g_ENTRY_USER_DEF = 'SYSTEM';      //�f�[�^�L�[
      g_ENTRY_USERNAME_DEF = '�V�X�e��';      //�f�[�^�L�[
*)

  //ini�t�@�C�����e
  g_RTRISTYPE_SECSION = 'RTRISTYPE';

  // HIS���M��ʏ��
  g_HIS_TYPE_SECSION  = 'HISTYPE';
    g_HIS_TYPE_KEY = 'TYPEID';      //�f�[�^�L�[
      g_HIS_TYPE_DEF = '';      //�f�[�^�L�[
  // HIS���M���ڃR�[�h���
  g_HIS_KOUMOKU_SECSION  = 'HISKOUMOKU';
    g_HIS_KOUMOKU_KEY = 'KOUMOKUID';      //�f�[�^�L�[
      g_HIS_KOUMOKU_DEF = '';      //�f�[�^�L�[
  // HIS���M���ʃR�[�h���
  g_HIS_BUI_SECSION  = 'HISBUI';
    g_HIS_BUI_KEY = 'BUIID';      //�f�[�^�L�[
      g_HIS_BUI_DEF = '';      //�f�[�^�L�[

  // �I���R�[�����
  g_ONCALL_SECSION  = 'ONCALL';
    g_ONCALL_AM_KEY = 'AM';      //�f�[�^�L�[
    g_ONCALL_PM_KEY = 'PM';      //�f�[�^�L�[
      g_ONCALL_AM_DEF = '0000';      //�f�[�^�L�[
      g_ONCALL_PM_DEF = '2359';      //�f�[�^�L�[

  // HIS���M�ȃR�[�h���
  g_HIS_EXSECTION_SECSION  = 'EXSEND';
    g_HIS_EXSECTION_KEY = 'SECTIONID';      //�f�[�^�L�[
      g_HIS_EXSECTION_DEF = '';      //�f�[�^�L�[
    g_HIS_EXDR_KEY = 'DRID';      //�f�[�^�L�[
      g_HIS_EXDR_DEF = '';      //�f�[�^�L�[
  // HIS�R�����g�^�C�g�����
  g_HIS_EXCOMTITLE_SECSION  = 'EXCOMTITLE';
    g_HIS_TITLE1_KEY = 'TITLE1';      //�f�[�^�L�[
      g_HIS_TITLE1_DEF = '';      //�f�[�^�L�[
    g_HIS_TITLE2_KEY = 'TITLE2';      //�f�[�^�L�[
      g_HIS_TITLE2_DEF = '';      //�f�[�^�L�[
//�Q�ƒ萔-----------------------------------------------------------------
//LOG�t�@�C������`�i���e�j
const
 G_LOG_LINE_HEAD_OK  = 'OK'; //�ړ��q ����
 G_LOG_LINE_HEAD_NG  = 'NG'; //�ړ��q �ُ�
 G_LOG_LINE_HEAD_NG1 = 'N1'; //�ړ��q �đ�
 G_LOG_LINE_HEAD_NG2 = 'N2'; //�ړ��q �X�L�b�v
 G_LOG_LINE_HEAD_NG3 = 'N3'; //�ړ��q �X�g�b�v
 G_LOG_LINE_HEAD_NP  = '  '; //�ړ��q �R�����g
//LOG�t�@�C������`(���O�̎�ʔԍ��ƃ��x���ƃ��O�̎�ʕ�����)
//���s���O���w����l������Initial�ő����������
const
 G_LOG_PKT_PTH_DEF             = '.LOG';//LOG�t�@�C���g���q
 G_MAX_LOG_TYPE                = 10; //���O�̎�ʂ̌��ő�l
 //�T�[�r�X����
 G_LOG_KIND_SVC_NUM            = 1;
 G_LOG_KIND_SVC                = 'Servic            ����';//�g�p
 G_LOG_KIND_SVC_LEVEL          = 1;
 //�\�P�b�g�T�[�o
 G_LOG_KIND_SK_SV_NUM          = 2;
 G_LOG_KIND_SK_SV              = 'Socket�T�[�o      ����';//�g�p
 G_LOG_KIND_SK_SV_LEVEL        = 3;
 //�\�P�b�g�N���C�A���g
 G_LOG_KIND_SK_CL_NUM          = 3;
 G_LOG_KIND_SK_CL              = 'Socket�N���C�A���g����';//�g�p
 G_LOG_KIND_SK_CL_LEVEL        = 3;
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
 G_LOG_KIND_DB_OUT_LEVEL       = 4;
 //DB �d����͏���
 G_LOG_KIND_MS_ANLZ_NUM        = 7;
 G_LOG_KIND_MS_ANLZ            = 'MSG   ���        ����';//
 G_LOG_KIND_MS_ANLZ_LEVEL      = 4;
 //�T�[�r�X��{����
 G_LOG_KIND_SVCDEF_NUM         = 8;
 G_LOG_KIND_SVCDEF             = 'Servic ��{       ����';//
 G_LOG_KIND_SVCDEF_LEVEL       = 5;
 //�f�o�b�N���[�h
 G_LOG_KIND_DEBUG_NUM          = 9;
 G_LOG_KIND_DEBUG              = '�J���җp          ����';//
 G_LOG_KIND_DEBUG_LEVEL        = 6;
 //�G���[����
 G_LOG_KIND_NG_NUM             = 10;
 G_LOG_KIND_NG                 = '�G���[            ����';//
 G_LOG_KIND_NG_LEVEL           = 1;

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

  G_FIELD_NAME_DERI = '�f���~�^';

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
                                // 8:�T�[�r�X��{����
                                (f_LogMsg : G_LOG_KIND_SVCDEF;
                                 f_LogLevel:G_LOG_KIND_SVCDEF_LEVEL),
                                // 9:�J���җp
                                (f_LogMsg : G_LOG_KIND_DEBUG;
                                 f_LogLevel:G_LOG_KIND_DEBUG_LEVEL),
                                // 10:�G���[����
                                (f_LogMsg : G_LOG_KIND_NG;
                                 f_LogLevel:G_LOG_KIND_NG_LEVEL)
                                );
//���R�[�h�y�і��̒�`
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
//2001.09.06
GPCST_SYOKUSHU_1='1';
GPCST_SYOKUSHU_2='2';
GPCST_SYOKUSHU_3='3';
GPCST_SYOKUSHU_4='4';
GPCST_SYOKUSHU_1_NAME='��t';
GPCST_SYOKUSHU_2_NAME='������';
GPCST_SYOKUSHU_3_NAME='�Z�t';
GPCST_SYOKUSHU_4_NAME='�Ō�t';
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
//���ǉe�v��
GPCST_DOKUEI_0 = '0';
GPCST_DOKUEI_1 = '1';
GPCST_DOKUEI_2 = '2';
GPCST_DOKUEI_0_NAME = '�s�v';
GPCST_DOKUEI_1_NAME = '�K�v';
GPCST_DOKUEI_2_NAME = '�ً}';
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
//����Z�敪��
//GPCST_SHG_1_NAME = '��{';
GPCST_SHG_1_NAME = '���Z'; //2004.02.01 koba
GPCST_SHG_2_NAME = '���u';
//����v���M���
GPCST_KAIKEI_0 = '0';
GPCST_KAIKEI_1 = '1'  ;
GPCST_KAIKEI_0_NAME = '��v�Ȃ�';
GPCST_KAIKEI_1_NAME = '��v����';

//��RI�I�[�_�敪
GPCST_RI_ORDER_0 = '0';
GPCST_RI_ORDER_1 = '1'  ;
GPCST_RI_ORDER_2 = '2'  ;
GPCST_RI_ORDER_0_NAME = '���̑�����';
GPCST_RI_ORDER_1_NAME = 'RI����';
GPCST_RI_ORDER_2_NAME = 'RI����';
//�����Z�敪
GPCST_SEISAN_0 = '0';
GPCST_SEISAN_1 = '1';
GPCST_SEISAN_0_NAME = '�����Z';
GPCST_SEISAN_1_NAME = '���Z��';

//2002.11.20
//���t��Format
CST_FORMATDATE_0='YYYYMMDD';
CST_FORMATDATE_1='YYYY/MM/DD';
CST_FORMATDATE_2='YYYY/MM/DD HH:NN';
CST_FORMATDATE_3='YYYY/MM/DD HH:MM:SS';
CST_FORMATDATE_4='HHMMSS';
CST_FORMATDATE_5='HH:MM:SS';


GPCST_INFKBN_FU='FU';   //��t
GPCST_INFKBN_FC='FC';   //��t�L�����Z�� {2002.12.17]
GPCST_INFKBN_FO='F0';   //���{
GPCST_INFKBN_F1='F1';   //���~           {2002.12.17]
GPCST_INFKBN_FY='FY';   //�\��           {2003.01.07]
GPCST_INFKBN_FH='FH';   //�ۗ�
GPCST_SYORIKBN_01='01'; //�V�K
GPCST_SYORIKBN_02='02'; //�X�V
GPCST_SYORIKBN_03='03'; //�폜
GPCST_JOUTAIKBN_3='3';  //���{
GPCST_JOUTAIKBN_7='7';  //���~

//���Z�t���O 2003.12.12
GSPCST_SEISAN_FLG_0 = '0';
GSPCST_SEISAN_FLG_0_NAME = '�����Z';
GSPCST_SEISAN_FLG_1 = '1';
GSPCST_SEISAN_FLG_1_NAME = '���Z��';
//�|�[�^�u���t���O
GPCST_PORTABLE_FLG_0 = '0';
GPCST_PORTABLE_FLG_0_NAME = '�ʏ�';
GPCST_PORTABLE_FLG_1 = '1';
GPCST_PORTABLE_FLG_1_NAME = '�|�[�^�u��';
GPCST_PORTABLE_FLG_2 = '2';
GPCST_PORTABLE_FLG_2_NAME = '��p��';
GPCST_PORTABLE_FLG_3 = '3';           //2004.06.15
GPCST_PORTABLE_FLG_3_NAME = '���̑�'; //2004.06.15


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
   g_Svc_Ex_Acvite:string;
   g_Svc_Shema_Acvite:string;
   (*
   g_Svc_Rs_Acvite:string;
   g_Svc_Ka_Acvite:string;
   *)
   g_Svc_Sd_Cycle :integer;
   g_Svc_Rv_Cycle :integer;
   g_Svc_Ex_Cycle :integer;
   g_Svc_Shema_Cycle :integer;
   (*
   g_Svc_Rs_Cycle :integer;
   g_Svc_Ka_Cycle :integer;
   *)

   g_RTSvc_Ex_Acvite:string;
   g_RTSvc_Ex_Cycle :integer;
   g_RTSvc_Re_Acvite:string;
   g_RTSvc_Re_Cycle :integer;

//DB�ڑ����
   g_RisDB_Name : string;
   g_RisDB_Uid  : string;
   g_RisDB_Pas  : string;
   g_ReRisDB_Name : string;
   g_ReRisDB_Uid  : string;
   g_ReRisDB_Pas  : string;
   (*
   g_RTRisDB_Name : string;
   g_RTRisDB_Uid  : string;
   g_RTRisDB_Pas  : string;
   *)
   g_RisDB_DpendSrvName :string;
   g_RisDB_Retry: integer;
   g_RisDB_SndKeep: integer;
   g_RisDB_RcvKeep: integer;
   g_RisDB_SndEXKeep: integer;
   g_RisDB_RcvKaKeep: integer;
   g_RisDB_ShemaKeep: integer;
   g_RisDB_SndRsKeep: integer;
   g_RTRisDB_ReKeep: integer;
   g_RTRisDB_SndEXKeep: integer;
//Socket�ڑ��p���S
   //�N���C�A���g
   g_C_Socket_Info_01      :  TClint_Info;
   g_C_Socket_Info_02      :  TClint_Info;
   g_C_Socket_Info_03      :  TClint_Info;
   g_C_Socket_Info_04      :  TClint_Info;
   g_C_Socket_Info_05      :  TClint_Info;
   //�T�[�o
   g_S_Socket_Info_01      :  TServer_Info;
   g_S_Socket_Info_02      :  TServer_Info;
   g_S_Socket_Info_03      :  TServer_Info;
   g_S_Socket_Info_04      :  TServer_Info;
   g_S_Socket_Info_05      :  TServer_Info;
   //�N���C�A���g
   g_C_RTSocket_Info_01      :  TClint_Info;
   g_C_RTSocket_Info_02      :  TClint_Info;
   //�T�[�o
   g_S_RTSocket_Info_01      :  TServer_Info;
   g_S_RTSocket_Info_02      :  TServer_Info;
//LOG���
   g_Rig_LogActive         :  string;
   g_Rig_LogPath           :  string;
   g_Rig_LogSize           :  string;
   g_Rig_LogKeep           :  integer;
   g_Rig_LogIncMsg         :  string;
   g_Rig_LogLevel          :  string;

   //2018/08/30 ���O�t�@�C���ύX
   g_LogFileSize: integer;

//�Z�N�V�����FDB���O���
  g_DBLOG01_LOGGING         : Boolean;
  g_DBLOG01_PATH            : String;
  g_DBLOG01_PREFIX          : String;
  g_DBLOG01_KEEPDAYS        : Integer;
//�Z�N�V�����FDB���O���
  g_DBLOG02_LOGGING         : Boolean;
  g_DBLOG02_PATH            : String;
  g_DBLOG02_PREFIX          : String;
  g_DBLOG02_KEEPDAYS        : Integer;
//�Z�N�V�����FDB���O���
  g_DBLOG03_LOGGING         : Boolean;
  g_DBLOG03_PATH            : String;
  g_DBLOG03_PREFIX          : String;
  g_DBLOG03_KEEPDAYS        : Integer;
//�Z�N�V�����FDB���O���
  g_DBLOG04_LOGGING         : Boolean;
  g_DBLOG04_PATH            : String;
  g_DBLOG04_PREFIX          : String;
  g_DBLOG04_KEEPDAYS        : Integer;

//�Z�N�V�����FDB�f�o�b�O���
  g_DBLOGDBG01_LOGGING      : Boolean;
  g_DBLOGDBG01_PATH         : String;
  g_DBLOGDBG01_PREFIX       : String;
  g_DBLOGDBG01_KEEPDAYS     : Integer;
//�Z�N�V�����FDB�f�o�b�O���
  g_DBLOGDBG02_LOGGING      : Boolean;
  g_DBLOGDBG02_PATH         : String;
  g_DBLOGDBG02_PREFIX       : String;
  g_DBLOGDBG02_KEEPDAYS     : Integer;
//�Z�N�V�����FDB�f�o�b�O���
  g_DBLOGDBG03_LOGGING      : Boolean;
  g_DBLOGDBG03_PATH         : String;
  g_DBLOGDBG03_PREFIX       : String;
  g_DBLOGDBG03_KEEPDAYS     : Integer;
//�Z�N�V�����FDB�f�o�b�O���
  g_DBLOGDBG04_LOGGING      : Boolean;
  g_DBLOGDBG04_PATH         : String;
  g_DBLOGDBG04_PREFIX       : String;
  g_DBLOGDBG04_KEEPDAYS     : Integer;

//LOG��ʒ�`��i�O����`�̏ꍇ�j
   g_Log_Type     : array[1..G_MAX_LOG_TYPE] of TLog_Type;
//�v���t�@�C������
   g_Prof01 : string;
   g_Prof02 : string;
   g_Prof03 : string;
   g_Prof04 : string;
   g_Prof05 : string;
   g_Prof06 : string;
   g_Prof07 : string;
   g_Prof08 : string;
   //2003.07.04
   g_Prof09 : string;
   g_Prof10 : string;
   g_Prof11 : string;
   g_Prof12 : string;
//�V�F�[�}���
   g_Schema_Main : string;
   g_Schema_Sub  : string;
   g_Schema_Del  : string;
   g_Schema_MainSVR : string;
   g_Schema_SubSVR  : string;
   g_Schema_Sel  : string;
//HIS_ID,RIS_ID�Ή��\
   g_Kensa_ID : TKensa_Type;
//���ҏ�ԃR�����gID
   g_KanjaJyoutai : TStrings;
//�v���t�@�C��ID
   g_Prof_List : TStrings;
//�Ō�敪
  g_KangoKbn_List : TStrings;
  g_KangoName_List : TStrings;
//���ҋ敪
  g_KanjaKbn_List : TStrings;
  g_KanjaName_List : TStrings;
//�~��敪
  g_KyuugoKbn_List : TStrings;
  g_KyuugoName_List : TStrings;
//��Q��񖼏�
  g_Syougai_List : TStrings;
//���t�^ABO
  g_ABOCode_List : TStrings;
  g_ABOName_List : TStrings;
//���t�^RH
  g_RHCode_List : TStrings;
  g_RHName_List : TStrings;
//�������
  g_KansenCode_List : TStrings;
  g_KansenName_List : TStrings;
//������񂠂荀��
  g_KansenON_List : TStrings;
//������񖼏�
  g_Kansen_List : TStrings;
//�֊���񖼏�
  g_Kinki_List : TStrings;
//�ً}�敪
  g_KinkyuKbn_List : TStrings;
  g_KinkyuName_List : TStrings;
//���}�敪
  g_SikyuKbn_List : TStrings;
  g_SikyuName_List : TStrings;
//���}�����敪
  g_GenzoKbn_List : TStrings;
  g_GenzoName_List : TStrings;
//�\��敪
  g_YoyakuKbn_List : TStrings;
  g_YoyakuName_List : TStrings;
//�ǉe�敪
  g_DokueiKbn_List : TStrings;
  g_DokueiName_List : TStrings;
  g_RomaFlg_1 : Integer;
  g_RomaFlg_2 : Integer;
  g_RomaFlg_3 : Integer;
  g_RomaFlg_4 : Integer;

  g_RIOrder : String;
  (*
//�ۑ���ʌ������
  g_RISType_List : TStrings;
  g_TheraRisType_List : TStrings;
  g_Report_List : TStrings;
  *)
//HIS_ID,Report_ID�Ή��\
   g_ReportType_ID : TKensa_Type;
  (*
  // �f�f�ڑ����
  g_RRISUser : string;
  // ���Ðڑ����
  g_RTRISUser : string;
  *)
//�ޗ���񖼏�
  g_Zairyo_List : TStrings;
  //2007.07.04
  // �O���[�v���ڃR�[�h���
  // ��v�������ڃR�[�h���
  g_KOUMOKU_CODE : string;
  // ��v�����R�[�h���
  g_NOT_ACCOUNT : string;
  // ���׍��ڃR�[�h���
  // ��v�������ڃR�[�h���
  g_MESAI_KOUMOKU_CODE : string;
  // ��v�����R�[�h���
  g_MESAI_NOT_ACCOUNT : string;

  // NOTESMARK���
  g_NotesMake_Kangokbn_List : TStrings;
  g_NotesMake_Kanjakbn_List : TStrings;
  // HIS���M�Ȃ����
  g_HIS_List : TStrings;
  // �V�F�[�}���
  g_SHEMA_HIS_PASS : string;
  g_SHEMA_LOCAL_PASS : string;
  g_SHEMA_HTML_PASS : string;

  g_Shema_HTML_Original_File : string;
  g_LOGONPASS : string;
  g_LOGONUSER : string;
  g_LOGONRETRY : Integer;
(*
  g_ENTRY_USER  : string;
  g_ENTRY_USERNAME : string;
*)

  g_HIS_TYPE: string;

  g_HIS_KOUMOKU: string;
  g_HIS_BUI: string;

  g_ONCALL_AM: string;
  g_ONCALL_PM: string;

  g_HIS_EXSECTION: string;
  g_HIS_EXDR: string;

  g_COM_TITLE1: string;
  g_COM_TITLE2: string;
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
function func_RTTcpReadiniFile: Boolean;
procedure proc_ReadiniKenzo(
                           arg_Ini : TIniFile;
                           var arg_Kanja:TStrings
                           );
procedure proc_ReadiniFlg(
                          arg_Ini : TIniFile
                          );
procedure proc_ReadiniType(
                          arg_Ini : TIniFile
                          );
//4.�o�b�t�@�n--------------------------------------------------------------------
//�o�b�t�@���I�t�Z�b�g�ƃT�C�Y�ŕ�����Ƃ��Ď�o��
//�o�b�t�@���當��������o��
function func_ByteToStr(
           arg_Buffer        : array of byte ; //�o�t�@
           arg_offset        : LongInt;        //�I�t�Z�b�g
           arg_size          : LongInt         //�T�C�Y
           ):string;
//�o�b�t�@�ɕ������ݒ�
procedure proc_StrToByte(
           var arg_Buffer      : array of byte ;//�o�t�@
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
           arg_TStringStream : TStringStream;
           arg_System        : string; //�����V�X�e��
           arg_MsgKind       : string  //���
           );
//TStringList���TStringStream���쐬����(���ː��˗��d���p)
Procedure  proc_TStrListToStrm_Irai(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream;
           arg_System        : string;
           arg_MsgKind       : string
           );
//���{�p
Procedure  proc_TStrListToStrm_Jissi(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream;
           arg_System        : string;
           arg_MsgKind       : string
           );
//TStringList���TStringStream���쐬����
Procedure  proc_TStrListToStrm2(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream;
           arg_System        : string; //�����V�X�e��
           arg_MsgKind       : string  //���
           );
//TStringStream����͂���TStringList���쐬����
procedure proc_TStrmToStrlist(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string; //�����V�X�e��
           arg_MsgKind       : string  //���
           );
//TStringStream����͂���TStringList���쐬����(���ː��˗��d���p)
procedure proc_TStrmToStrlist_H_Irai(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string;
           arg_MsgKind       : string
           );
//TStringStream����͂���TStringList���쐬����(���ː��˗��d���p)
procedure proc_TStrmToStrlist_H_Jissi(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string;
           arg_MsgKind       : string
           );
//TStringStream����͂���TStringList���쐬����
procedure proc_TStrmToStrlist2(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string; //�����V�X�e��
           arg_MsgKind       : string  //���
           );
//TStringStream����͂���TStringList���쐬����
procedure proc_TStrmToStrlist3(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string; //�����V�X�e��
           arg_MsgKind       : string  //���
           );
//�d���o�C�g���擾
function func_MsgLen(
           arg_System        : string;  //�����V�X�e��
           arg_MsgKind       : string   //���
           ):integer;
//�d����`�̂̒����擾
function func_MsgDefLen(
           arg_System        : string;
           arg_MsgKind       : string
           ):integer;
//�d����`�̂̎擾
function func_FindMsgField(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_index         : integer //�ꏊ1-��
           ):TStreamField;
//�d������������o��
function func_GetStringStream(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_TStringStream : TStringStream;  //�d��
           arg_index         : integer         //�ꏊ1-��
           ):string;
//�d����`�������ƂɃX�g���[�����當��������o���i�ϒ��̓d���p�j
function func_GetStringStream2(arg_System        : String;
                              arg_MsgKind       : String;
                              arg_TStringStream : TStringStream;
                              arg_index         : integer;
                              arg_Offset        : integer
                              ):string;
//�d����`�������ƂɃX�g���[�����當��������o���i�ϒ��̃R�����g�p�j
function func_GetStringStream3(arg_System        : String;
                               arg_MsgKind       : String;
                               arg_TStringStream : TStringStream;
                               arg_Offset        : integer;
                               arg_Size          : integer
                               ):string;
//�d���ɏ���ݒu
procedure  proc_SetStringStream(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_TStringStream : TStringStream; //�d��
           arg_index         : integer;       //�ꏊ1-��
           arg_string        : string         //�ݒ蕶����
           );
//�d���ɏ���ݒu�i�ϒ��̓d���p�j
procedure proc_SetStringStream2(arg_System        : String;
                                arg_MsgKind       : String;
                                arg_TStringStream : TStringStream;
                                arg_index         : integer;
                                arg_Offset        : integer;
                                arg_string        : String
                                );
//�d�����N���A�ݒ肷��
procedure  proc_ClearStream(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_TStringStream : TStringStream
           );
//�d�����N���A�ݒ肷��(�˗��d����p)
procedure  proc_ClearStream2(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_TStringStream : TStringStream
           );
//�d���̋��ʕ��Ƀf�t�H���g�l��ݒ肷��
procedure  proc_SetStreamHDDef(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_TStringStream : TStringStream
           );
//�d�����N���A�ݒ肷��(�˗��d����p)
procedure  proc_ClearStream3(
           arg_MaxLen        : Integer;
           arg_TStringStream : TStringStream
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
function bswap(src : integer) : integer; assembler;
function bswapf(src : single) : single;
procedure ByteOrderSwap(var Src: Double); overload;
function EndianShort_Short(Value: Short): Short;
procedure proc_Change_Byte(var arg_Length: String);
function func_HisToRis(arg_HisID:String):String;
function func_RisToHis(arg_RisID:String):String;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ��o�^ ��Z�敪
function func_Change_Command(
       arg_Code:string    //����
       ):string;          //����
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ� �R�}���h���i��M�n�T�[�r�X�̂݁j
function func_Change_RVRISCommand(
                                  arg_Code: String    //����
                                  ): String;          //����
//���@�\�i��O���j�F�V�F�[�}�i�[�t�@�C�����쐬
function func_Make_ShemaName(arg_OrderNO,               //�I�[�_NO
                             arg_MotoFileName: string;  //HIS���ϖ�
                             arg_Index: integer         //����NO
                             ):string;                  //�i�[̧�ٖ�

//���@�\�i��O���j�FHIS���t�^ABO��RH����RIS�p�ɕϊ�
function func_Make_BloodType(
                             arg_ABO: String;
                             arg_RH: String
                             ): String;
//���@�\�i��O���j�FRIS��Q���A�֊����̍쐬
procedure proc_Make_RISInfo(
                                arg_Syougai: String;
                                arg_Kinki: String;
                            var arg_SyougaiInfo: String;
                            var arg_KinkiInfo: String
                           );
//���@�\�i��O���j�FRIS�������̍쐬
procedure proc_Make_RISKansen(
                                arg_Kansen: String;
                                arg_KansenCom: String;
                            var arg_KansenFlg: String;
                            var arg_KansenInfo: String
                           );
//���@�\�i��O���j�FRIS�D�P���̍쐬
procedure proc_Make_RISNinsinDate(
                                     arg_Ninsin: String;
                                 var arg_NinsinDate: String
                                 );
//���@�\�i��O���j�FHIS�Ō�敪�E���ҋ敪��RIS�p�ɕϊ�
function func_Make_ExtraProfile(
                                arg_Kango: String;
                                arg_Kanja: String
                                ): String;
function func_GetServiceInfo(    arg_AppID  : String;
                                 arg_Qry    : T_Query;
                             var arg_Flg    : Boolean;
                             var arg_ErrMsg : String
                             ): String;
function func_GetSeq(    arg_AppID  : String;
                         arg_Qry    : TQuery;
                     var arg_Flg    : Boolean;
                     var arg_ErrMsg : String
                     ): String;
function func_GetDBMachineName(    arg_AppID  : String;
                                   arg_Qry    : TQuery;
                               var arg_Flg    : Boolean;
                               var arg_ErrMsg : String
                               ): String;
function func_SetHISRISControlInfo(    arg_APPID : String;
                                       arg_DataSeq : String;
                                       arg_Qry    : TQuery;
                                   var arg_Flg    : Boolean;
                                   var arg_LogBuffer : String
                                   ):Boolean;
function func_GetRISHost(    arg_HostID : String;
                             arg_Qry    : TQuery;
                         var arg_Flg    : Boolean;
                         var arg_ErrMsg : String
                         ): String;
(*
function func_GetRTRISHost(    arg_HostID : String;
                               arg_Qry    : TQuery;
                           var arg_Flg    : Boolean;
                           var arg_ErrMsg : String
                           ): String;
*)
function func_HisToReport(arg_HisID:String):String;
function func_ReportToHis(arg_ReportID:String):String;
(*
function func_GetRTServiceInfo(    arg_AppID  : String;
                                   arg_Qry    : TQuery;
                               var arg_Flg    : Boolean;
                               var arg_ErrMsg : String
                               ): String;
*)
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
//���d����`�����擾����
function func_FindMsgField(arg_System  : String;
                           arg_MsgKind : String;
                           arg_index   : Integer
                           ):TStreamField;
begin
  //�˗����d���̏ꍇ
  if arg_MsgKind = G_MSGKIND_START then begin
    //�w�荀�ړ��e�ݒ�
    Result := g_Stream_Base[arg_index];
  end
  //�I�[�_�˗����d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_IRAI then begin
    //�w�荀�ړ��e�ݒ�
    Result := g_Stream01_IRAI[arg_index];
  end
  //�I�[�_�L�����Z�����d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_CANCEL then begin
    //�w�荀�ړ��e�ݒ�
    Result := g_Stream03_CANCEL[arg_index];
  end
  //���ҏ��d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_KANJA then begin
    //�w�荀�ړ��e�ݒ�
    Result := g_Stream04_KANJA[arg_index];
  end
  //��t�d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_UKETUKE then begin
    //�w�荀�ړ��e�ݒ�
    Result := g_Stream06_RCE[arg_index];
  end
  //���{�d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_JISSI then begin
    //�w�荀�ړ��e�ݒ�
    Result := g_Stream02_JISSI[arg_index];
  end
  //��v�d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_KAIKEI then begin
    //�w�荀�ړ��e�ݒ�
    Result := g_Stream05_KAIKEI[arg_index];
  end;
end;
//���d���̒����o�C�g�P�ʂ��擾����
function func_MsgLen(arg_System  : string;
                     arg_MsgKind : string
                     ):integer;
begin
  //�Z�b�V�����J�n�E�I���̏ꍇ
  if arg_MsgKind = G_MSGKIND_START then begin
    //�ő�d�����擾
    Result := G_MSGSIZE_START;
  end
  //�I�[�_�˗����d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_IRAI then begin
    //�ő�d�����擾
    Result := G_MSGSIZE_IRAI;
  end
  //�I�[�_�L�����Z�����d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_CANCEL then begin
    //�ő�d�����擾
    Result := G_MSGSIZE_CANCEL;
  end
  //���ҏ��d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_KANJA then begin
    //�ő�d�����擾
    Result := G_MSGSIZE_KANJA;
  end
  //��t�d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_UKETUKE then begin
    //�ő�d�����擾
    Result := G_MSGSIZE_UKETUKE;
  end
  //���{�d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_JISSI then begin
    //�ő�d�����擾
    Result := G_MSGSIZE_JISSI;
  end
  //��v�d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_KAIKEI then begin
    //�ő�d�����擾
    Result := G_MSGSIZE_KAIKEI;
  end
  //�đ��d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_RESEND then begin
    //�ő�d�����擾
    Result := G_MSGSIZE_RESEND;
  end
  //����ȊO�̏ꍇ
  else begin
    //�ő�d�����擾
    Result := 0;
  end;
end;
//���d����`��� ��`�t�B�[���h��
function func_MsgDefLen(arg_System  : String;
                        arg_MsgKind : String
                        ):integer;
begin
  //�Z�b�V�����J�n�E�I���̏ꍇ
  if arg_MsgKind = G_MSGKIND_START then begin
    //���ڐ��ݒ�
    Result := G_MSGFNUM_START;
  end
  //�I�[�_�˗����d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_IRAI then begin
    //���ڐ��ݒ�
    Result := G_MSGFNUM_IRAI;
  end
  //�I�[�_�L�����Z�����d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_CANCEL then begin
    //���ڐ��ݒ�
    Result := G_MSGFNUM_CANCEL;
  end
  //���ҏ��d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_KANJA then begin
    //���ڐ��ݒ�
    Result := G_MSGFNUM_KANJA;
  end
  //��t�d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_UKETUKE then begin
    //���ڐ��ݒ�
    Result := G_MSGFNUM_UKETUKE;
  end
  //���{�d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_JISSI then begin
    //�ő�d�����擾
    Result := G_MSGFNUM_JISSI;
  end
  //��v�d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_KAIKEI then begin
    //���ڐ��ݒ�
    Result := G_MSGFNUM_KAIKEI;
  end
  //�đ��d���̏ꍇ
  else if arg_MsgKind = G_MSGKIND_RESEND then begin
    //���ڐ��ݒ�
    Result := G_MSGFNUM_RESEND;
  end
  //����ȊO�̏ꍇ
  else begin
    //���ڐ��ݒ�
    Result := 0;
  end;
end;
//���d����`�������ƂɃX�g���[�����當��������o��
function func_GetStringStream(arg_System        : String;
                              arg_MsgKind       : String;
                              arg_TStringStream : TStringStream;
                              arg_index         : integer
                              ):string;
var
  w_offset:integer;
  w_size  :integer;
  w_StremField : TStreamField;
begin
   //�����l
   arg_TStringStream.Position := 0;
   //�w��d�����ڂ̏��擾
   w_StremField := func_FindMsgField(arg_System,arg_MsgKind,arg_index);
   //�I�t�Z�b�g
   w_offset := w_StremField.offset;
   //�T�C�Y
   w_size   := w_StremField.size;
   //�X�g���[�����I�t�Z�b�g�ʒu�Ɉړ�
   arg_TStringStream.Position := w_offset;
   //�����̓ǂݍ���
   Result   := arg_TStringStream.ReadString(w_size);
   //�����I��
   Exit;
end;
//���d����`�������ƂɃX�g���[�����當��������o���i�ϒ��̓d���p�j
function func_GetStringStream2(arg_System        : String;
                              arg_MsgKind       : String;
                              arg_TStringStream : TStringStream;
                              arg_index         : integer;
                              arg_Offset        : integer
                              ):string;
var
  w_offset:integer;
  w_size  :integer;
  w_StremField : TStreamField;
begin
   //�����l
   arg_TStringStream.Position := 0;
   //�w��d�����ڂ̏��擾
   w_StremField := func_FindMsgField(arg_System,arg_MsgKind,arg_index);
   //�I�t�Z�b�g
   w_offset := arg_Offset;
   //�T�C�Y
   w_size   := w_StremField.size;
   //�X�g���[�����I�t�Z�b�g�ʒu�Ɉړ�
   arg_TStringStream.Position := w_offset;
   //�����̓ǂݍ���
   Result   := arg_TStringStream.ReadString(w_size);
   //�����I��
   Exit;
end;
//���d����`�������ƂɃX�g���[�����當��������o���i�ϒ��̃R�����g�p�j
function func_GetStringStream3(arg_System        : String;
                               arg_MsgKind       : String;
                               arg_TStringStream : TStringStream;
                               arg_Offset        : integer;
                               arg_Size          : integer
                              ):string;
var
  w_offset:integer;
  w_size  :integer;
begin
   //�����l
   arg_TStringStream.Position := 0;
   //�I�t�Z�b�g
   w_offset := arg_Offset;
   //�T�C�Y
   w_size   := arg_Size;
   //�X�g���[�����I�t�Z�b�g�ʒu�Ɉړ�
   arg_TStringStream.Position := w_offset;
   //�����̓ǂݍ���
   Result   := arg_TStringStream.ReadString(w_size);
   //�����I��
   Exit;
end;
//���d����`�������ƂɃX�g���[���ɕ������ݒ肷��
procedure proc_SetStringStream(arg_System        : String;
                               arg_MsgKind       : String;
                               arg_TStringStream : TStringStream;
                               arg_index         : integer;
                               arg_string        : String
                               );
var
  w_offset:integer;
  w_size  :integer;
  w_len   :integer;
  w_StremField : TStreamField;
  w_s:String;
begin
   //�����l
   arg_TStringStream.Position := 0;
   //�w��d�����ڂ̏��擾
   w_StremField := func_FindMsgField(arg_System,arg_MsgKind,arg_index);
   //�I�t�Z�b�g
   w_offset := w_StremField.offset;
   //�T�C�Y
   w_size   := w_StremField.size;
   //�X�g���[�����I�t�Z�b�g�ʒu�Ɉړ�
   arg_TStringStream.Position := w_offset;
   //������̒������擾
   w_len      := length( arg_string );
   //�����񒷂��T�C�Y���傫���ꍇ
   if w_len >= w_size then begin
     //�؂�̂Ă�
     arg_string := copy(arg_string, 1,w_size);
   end
   //�����񒷂��T�C�Y��菬�����ꍇ
   else begin
      //�⊮����
      //���ڑ�����"������"�̏ꍇ
      if (Byte(w_StremField.x9[1]) = Byte(G_FIELD_C)) then begin
        //�󔒂�⊮
        arg_string := arg_string + StringOfChar(' ',w_size);
      end
      //���ڑ�����"���l"�̏ꍇ
      else begin
        //"0"��⊮
        arg_string := StringOfChar('0',w_size) + arg_string;
      end;
      //�⊮����������̐ݒ�
      arg_string := copy(arg_string, 1,w_size);
   end;
   //�I�t�Z�b�g + �T�C�Y�ƃX�g���[���̃T�C�Y�̏��Ȃ��ق��Ɉʒu�ړ�
   arg_TStringStream.Position := min((w_offset + w_size),arg_TStringStream.Size);
   //�X�g���[���̃T�C�Y - �I�t�Z�b�g + �T�C�Y��"0"�̑傫���ق��̕������ǂݍ���
   w_s := arg_TStringStream.ReadString(max((arg_TStringStream.Size - (w_offset + w_size)),0));
   //�I�t�Z�b�g�̈ʒu�Ɉړ�
   arg_TStringStream.Position := w_offset;
   //�w��̈ʒu�Ɏw�蕶����ƑO�ɂ������������ǉ�
   arg_TStringStream.WriteString(arg_string+w_s);

   Exit;
end;
//���d����`�������ƂɃX�g���[���ɕ������ݒ肷��(�ϒ��p)
procedure proc_SetStringStream2(arg_System        : String;
                                arg_MsgKind       : String;
                                arg_TStringStream : TStringStream;
                                arg_index         : integer;
                                arg_Offset        : integer;
                                arg_string        : String
                                );
var
  w_offset:integer;
  w_size  :integer;
  w_len   :integer;
  w_StremField : TStreamField;
  w_s:String;
begin
   //�����l
   arg_TStringStream.Position := 0;
   //�w��d�����ڂ̏��擾
   w_StremField := func_FindMsgField(arg_System,arg_MsgKind,arg_index);
   //�I�t�Z�b�g
   w_offset := arg_Offset;
   //�T�C�Y
   w_size   := w_StremField.size;
   //�X�g���[�����I�t�Z�b�g�ʒu�Ɉړ�
   arg_TStringStream.Position := w_offset;
   //������̒������擾
   w_len      := length( arg_string );
   //�����񒷂��T�C�Y���傫���ꍇ
   if w_len >= w_size then begin
     //�؂�̂Ă�
     arg_string := copy(arg_string, 1,w_size);
   end
   //�����񒷂��T�C�Y��菬�����ꍇ
   else begin
      //�⊮����
      //���ڑ�����"������"�̏ꍇ
      if (Byte(w_StremField.x9[1]) = Byte(G_FIELD_C)) then begin
        //�󔒂�⊮
        arg_string := arg_string + StringOfChar(' ',w_size);
      end
      //���ڑ�����"���l"�̏ꍇ
      else begin
        //"0"��⊮
        arg_string := StringOfChar('0',w_size) + arg_string;
      end;
      //�⊮����������̐ݒ�
      arg_string := copy(arg_string, 1,w_size);
   end;
   //�I�t�Z�b�g + �T�C�Y�ƃX�g���[���̃T�C�Y�̏��Ȃ��ق��Ɉʒu�ړ�
   arg_TStringStream.Position := min((w_offset + w_size),arg_TStringStream.Size);
   //�X�g���[���̃T�C�Y - �I�t�Z�b�g + �T�C�Y��"0"�̑傫���ق��̕������ǂݍ���
   w_s := arg_TStringStream.ReadString(max((arg_TStringStream.Size - (w_offset + w_size)),0));
   //�I�t�Z�b�g�̈ʒu�Ɉړ�
   arg_TStringStream.Position := w_offset;
   //�w��̈ʒu�Ɏw�蕶����ƑO�ɂ������������ǉ�
   arg_TStringStream.WriteString(arg_string+w_s);

   Exit;
end;
//���d����`�������ƂɃX�g���[���ɃN���A�ݒ肷��
procedure  proc_ClearStream(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_TStringStream : TStringStream
           );
var
 w_i:integer;
 w_len:integer;
 w_s:string;
 w_MsgDeflen:integer;
 w_Msglen:integer;
 w_StremField : TStreamField;
begin
  try
    //�d����ʂ̍��ڐ������߂�
    w_MsgDeflen := func_MsgDefLen( arg_System, arg_MsgKind );
    //���ڐ����Ȃ��ꍇ
    if w_MsgDeflen=0 then begin
      //�����I��
      Exit;
    end;
    //�d�����𒲂ׂ�
    w_Msglen := func_MsgLen( arg_System, arg_MsgKind );
    //�d�������擾
    if w_Msglen=0 then begin
      //�����I��
      Exit;
    end;
    //�ꃉ�C�����W�J
    arg_TStringStream.Position := 0;
    //���ڐ������[�v
    for w_i := 1 to w_MsgDeflen do begin
      //�d�������ڂ̏ꍇ
      if w_i = COMMON1DENLENNO then begin
        //�T�C�Y�ݒ�
        w_s := FormatFloat('000000', w_Msglen);
      end
      //����ȊO�̍��ڂ̏ꍇ
      else begin
        //���ڏ��擾
        w_StremField := func_FindMsgField(arg_System,arg_MsgKind,w_i);
        //���ڃT�C�Y�擾
        w_len := w_StremField.size;
        //�����񍀖ڂ̏ꍇ
        if (Byte(w_StremField.x9[1]) = Byte(G_FIELD_C)) then begin
          //�X�y�[�X����
          w_s := StringOfChar(' ',w_len);
        end
        //���l���ڂ̏ꍇ
        else begin
          //�[������
          w_s := StringOfChar('0',w_len) ;
        end;
      end;
      //�f�[�^�̏�������
      arg_TStringStream.WriteString(w_s);
    end;
    //�����I��
    Exit;
//�@<<----
  except
    //������
    arg_TStringStream.Position := 0;
    //�����I��
    Exit;
//�@<<----
  end;

end;
//���d����`�������ƂɃX�g���[���ɃN���A�ݒ肷��
procedure  proc_ClearStream2(
           arg_System        : string;
           arg_MsgKind       : string;
           arg_TStringStream : TStringStream
           );
var
 w_i:integer;
 w_len:integer;
 w_s:string;
 w_MsgDeflen:integer;
 w_Msglen:integer;
 w_StremField : TStreamField;
begin
  try
    //�d����ʂ̍��ڐ������߂�
    w_MsgDeflen := func_MsgDefLen( arg_System, arg_MsgKind );
    //���ڐ����Ȃ��ꍇ
    if w_MsgDeflen=0 then begin
      //�����I��
      Exit;
    end;
    //�d�����𒲂ׂ�
    w_Msglen := func_MsgLen( arg_System, arg_MsgKind );
    //�d�������擾
    if w_Msglen=0 then begin
      //�����I��
      Exit;
    end;
    //�ꃉ�C�����W�J
    arg_TStringStream.Position := 0;
    //���ڐ������[�v
    for w_i := 1 to w_MsgDeflen do begin
      if w_i > JISSIMEISAICOUNTNO then
        Break;
      //�d�������ڂ̏ꍇ
      if w_i = COMMON1DENLENNO then begin
        //�T�C�Y�ݒ�
        w_s := FormatFloat('000000', w_Msglen);
      end
      //����ȊO�̍��ڂ̏ꍇ
      else begin
        //���ڏ��擾
        w_StremField := func_FindMsgField(arg_System,arg_MsgKind,w_i);
        //���ڃT�C�Y�擾
        w_len := w_StremField.size;
        //�����񍀖ڂ̏ꍇ
        if (Byte(w_StremField.x9[1]) = Byte(G_FIELD_C)) then begin
          //�X�y�[�X����
          w_s := StringOfChar(' ',w_len);
        end
        //���l���ڂ̏ꍇ
        else begin
          //�[������
          w_s := StringOfChar('0',w_len) ;
        end;
      end;
      //�f�[�^�̏�������
      arg_TStringStream.WriteString(w_s);
    end;
    //�����I��
    Exit;
//�@<<----
  except
    //������
    arg_TStringStream.Position := 0;
    //�����I��
    Exit;
//�@<<----
  end;

end;
//���X�g���[�����N���A
procedure  proc_ClearStream3(
           arg_MaxLen        : Integer;
           arg_TStringStream : TStringStream
           );
var
 w_s:string;
begin
  try
    w_s := func_LeftSpace(arg_MaxLen,w_s);
    //�f�[�^�̏�������
    arg_TStringStream.WriteString(w_s);
    //�����I��
    Exit;
//�@<<----
  except
    //������
    arg_TStringStream.Position := 0;
    //�����I��
    Exit;
//�@<<----
  end;

end;
//���d����`�������ƂɃX�g���[���ɌŒ�f�t�H���g�������ݒ肷��
procedure proc_SetStreamHDDef(arg_System        : string;
                              arg_MsgKind       : string;
                              arg_TStringStream : TStringStream
                              );
begin
  //�ԐM�d���̏ꍇ
  if arg_MsgKind = G_MSGKIND_START then
  begin
    //���M�捀��"RIS"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1SDIDNO, CST_SENDTO);
    //���M������"HIS"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1RVIDNO, CST_FROMTO);
  end;
  //��t�E�L�����Z���d���̏ꍇ
  if arg_MsgKind = G_MSGKIND_UKETUKE then
  begin
    //���M�捀��"RIS"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1SDIDNO, CST_SENDTO);
    //���M������"HIS"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1RVIDNO, CST_FROMTO);
    //�R�}���h������
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1COMMANDNO, CST_COMMAND_UKETUKE);
    //���ʍ���
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1STATUSNO, CST_DENBUNID_OK);
    //�a�@�R�[�h����
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         RECHOSPCODENO, '01');
  end;
  //���{�d���̏ꍇ
  if arg_MsgKind = G_MSGKIND_JISSI then
  begin
    //���M�捀��"RIS"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1SDIDNO, CST_SENDTO);
    //���M������"HIS"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1RVIDNO, CST_FROMTO);
    //�R�}���h������
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1COMMANDNO, CST_COMMAND_JISSI);
    //���ʍ���
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1STATUSNO, CST_DENBUNID_OK);
    //�a�@�R�[�h����
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         JISSIHOSPCODENO, '01');
  end;
  //�ԐM�d���̏ꍇ
  if arg_MsgKind = G_MSGKIND_RESEND then
  begin
    //���M�捀��"RIS"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1SDIDNO, CST_SENDTO);
    //���M������"HIS"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1RVIDNO, CST_FROMTO);
  end;
{
  //�Z�b�V�����J�n�E�I���̏ꍇ
  if arg_MsgKind = G_MSGKIND_START then
  begin
    //���O���[�h����"0"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1LOGMODENO, '0');
    //����AP_ID����"      "�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1RVIDNO, '      ');
    //����AP_ID����"      "�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1SDIDNO, '      ');
    //�d��������"000064"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1DENLENNO, func_LeftZero(6,
                         IntToStr(G_MSGSIZE_START)));
    //�p���t���O����"0"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1CONTINUENO,'0');
  end;
  //���{�d���̏ꍇ
  if arg_MsgKind = G_MSGKIND_JISSI then
  begin
    //�d��ID����"SM"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1DENBUNIDNO, CST_DENBUNID_SD);
    //���O���[�h����"0"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1LOGMODENO, '0');
    //���e�R�[�h����"0"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1NAIYONO, '00');
    //����AP_ID����"      "�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1RVIDNO, '      ');
    //����AP_ID����"      "�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1SDIDNO, '      ');
    //�a�@�R�[�h����"01"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         JISSIHOSPCODENO, CST_HOSPCODE);
  end;
  //��v�d���̏ꍇ
  if arg_MsgKind = G_MSGKIND_KAIKEI then
  begin
    //�d��ID����"SM"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1DENBUNIDNO, CST_DENBUNID_SD);
    //���O���[�h����"0"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1LOGMODENO, '0');
    //���e�R�[�h����"0"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1NAIYONO, '00');
    //����AP_ID����"      "�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1RVIDNO, '      ');
    //����AP_ID����"      "�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1SDIDNO, '      ');
    //�p���t���O����"0"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         COMMON1CONTINUENO, '0');
    //�a�@�R�[�h����"01"�Œ�
    proc_SetStringStream(arg_System, arg_MsgKind, arg_TStringStream,
                         RECHOSPCODENO, CST_HOSPCODE);
  end;
  }
end;
{
-----------------------------------------------------------------------------
  ���O : proc_TStrmToStrlist;
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
           arg_TStringList   : TStringList  ;
           arg_System        : string;
           arg_MsgKind       : string
           );
begin
  //���ː��n�d���̏ꍇ
  if arg_MsgKind <> G_MSGKIND_JISSI then
    //�X�g���[������X�g�����O���X�g��
    proc_TStrmToStrlist_H_Irai(arg_TStringStream,arg_TStringList,arg_System,arg_MsgKind)
  else
    proc_TStrmToStrlist_H_Jissi(arg_TStringStream,arg_TStringList,arg_System,arg_MsgKind);
  //�����I��
  Exit;
end;
{
-----------------------------------------------------------------------------
  ���O : proc_TStrmToStrlist_H_Irai;
  ���� :
  arg_TStringList:TStringList      ��
  arg_TStringList   : TStringList  ��
  arg_System        : string;      ���
  arg_MsgKind       : string       ���

  �@�\ : TStringStream����͂���TStringList���쐬����
  ���A�l�F
-----------------------------------------------------------------------------
}
procedure proc_TStrmToStrlist_H_Irai(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string;
           arg_MsgKind       : string
           );
var
  w_i:integer;
  w_MaxDefLen:integer;
  w_offset:integer;
  w_size  :integer;
  w_s:string;
  w_FieldName:string;
  w_StremField : TStreamField;
  w_Kmk:integer;
  w_Kmk_Count:integer;
  w_Kind:String;
  wm_Offset:Integer;
  wm_DataMokutekiComLen:String;
  wm_DataSijiComLen:String;
  wm_DataSonotaComLen:String;
  wm_DataByoumeiComLen:String;
//  wm_DataDokueiComLen:String;
  wm_ComOffset:Integer;
  wi_MeisaiCount:Integer;
  w_Loop_Meisai:Integer;
  ws_RecKbn:String;
  w_Kmk_SyoriCount:Integer;
begin
//TStringStream��TStringList�ɓW�J
  //�����l
  arg_TStringList.Text := '';
  //������
  arg_TStringList.Clear;
  //�����ʒu�Ɉړ�
  arg_TStringStream.Position := 0;
  //���ڐ����擾
  w_MaxDefLen := func_MsgDefLen(arg_System,arg_MsgKind);

  //������
  w_Kmk         := 0;
  w_Kmk_Count   := 0;
  w_offset      := 0;
  w_Kind        := arg_MsgKind;
  w_Kmk_SyoriCount := 0;
  wm_ComOffset := 0;
  //���ڐ����쐬
  for w_i := 1 to w_MaxDefLen do begin
    //�˗����d���̏ꍇ
    if w_Kind = G_MSGKIND_IRAI then begin
      case w_i of
        //�O���[�v������
        CST_IRAI_LOOPSTART:
        begin
          //�O���[�v�����ڎ擾
          w_s := func_GetStringStream(arg_System,w_Kind,arg_TStringStream,CST_IRAI_LOOPSTART);
          //��M���ڂ̏��擾
          w_StremField := func_FindMsgField(arg_System,w_Kind,CST_IRAI_LOOPSTART);
          //�O���[�v�����ڂ����l�̏ꍇ
          if func_IsNumber(w_s) then
            //�O���[�v�����ڎ擾
            w_Kmk := StrToInt(w_s)
          else
            //�O���[�v�����ڂȂ�
            w_Kmk := 0;
          //���ڂ̍ő吔�ȏ�̏ꍇ
          if w_Kmk > CST_GROUP_LOOP_MAX then
            //���ڂ̍ő吔�ɐݒ�
            w_Kmk := CST_GROUP_LOOP_MAX;
        end;
      end;
      if (IRAIMOKUTEKILENNO <= w_i) and
         (IRAIBYOUMEINO >= w_i)   then
      begin
        //�����ړI��
        if IRAIMOKUTEKILENNO = w_i then begin
          //�����ړI���܂ł̃I�t�Z�b�g���擾
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAIMOKUTEKILENNO);
          if wm_ComOffset = 0 then
          begin
            //�I�t�Z�b�g��ݒ�
            wm_Offset := w_StremField.offset;
            //���ڃR�[�h�J�n�I�t�Z�b�g�ʒu
            wm_ComOffset := wm_Offset;
          end;
          //�d���F�����ړI���̎擾
          wm_DataMokutekiComLen := '';
          wm_DataMokutekiComLen := func_GetStringStream3(arg_System, w_Kind,
                                                         arg_TStringStream,
                                                         wm_ComOffset,
                                                         IRAIMOKUTEKILENLEN);
          w_s := wm_DataMokutekiComLen;
          //���p�u�����N�̍폜
          wm_DataMokutekiComLen := TrimRight(wm_DataMokutekiComLen);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + IRAIMOKUTEKILENLEN;
          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);
          Continue;
        end
        else
        //�����ړI
        if IRAIMOKUTEKINO = w_i then begin
          //�����ړI���܂ł̃I�t�Z�b�g���擾
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAIMOKUTEKINO);
          if wm_ComOffset = 0 then
          begin
            //�I�t�Z�b�g��ݒ�
            wm_Offset := w_StremField.offset;
            //���ڃR�[�h�J�n�I�t�Z�b�g�ʒu
            wm_ComOffset := wm_Offset;
          end;
          //�d���F�����ړI�̎擾
          w_s := '';
          w_s := func_GetStringStream3(arg_System, w_Kind,
                                                arg_TStringStream,
                                                wm_ComOffset,
                                       StrToIntDef(wm_DataMokutekiComLen, 0));
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + StrToIntDef(wm_DataMokutekiComLen, 0);
          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);
          Continue;
        end
        else
        //���ʎw����
        if IRAISIJILENNO = w_i then begin
          //���ʎw�����̖��̂��擾
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAISIJILENNO);
          if wm_ComOffset = 0 then
          begin
            //�I�t�Z�b�g��ݒ�
            wm_Offset := w_StremField.offset;
            //���ڃR�[�h�J�n�I�t�Z�b�g�ʒu
            wm_ComOffset := wm_Offset;
          end;
          //�d���F���ʎw�����̎擾
          wm_DataSijiComLen := '';
          wm_DataSijiComLen := func_GetStringStream3(arg_System, w_Kind,
                                                     arg_TStringStream,
                                                     wm_ComOffset, IRAISIJILENLEN);
          w_s := wm_DataSijiComLen;
          //���p�u�����N�̍폜
          wm_DataSijiComLen := TrimRight(wm_DataSijiComLen);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + IRAISIJILENLEN;
          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);
          Continue;
        end
        else
        //���ʎw��
        if IRAISIJINO = w_i then begin
          //���ʎw���̖��̂��擾
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAISIJINO);
          if wm_ComOffset = 0 then
          begin
            //�I�t�Z�b�g��ݒ�
            wm_Offset := w_StremField.offset;
            //���ڃR�[�h�J�n�I�t�Z�b�g�ʒu
            wm_ComOffset := wm_Offset;
          end;
          //�d���F���ʎw���̎擾
          w_s := '';
          w_s := func_GetStringStream3(arg_System, w_Kind,
                                                  arg_TStringStream, wm_ComOffset,
                                                 StrToIntDef(wm_DataSijiComLen, 0));
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + StrToIntDef(wm_DataSijiComLen, 0);
          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);
          Continue;
        end
        else
        //���̑��ڍג�
        if IRAISONOTALENNO = w_i then begin
          //���̑��ڍג��̖��̂��擾
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAISONOTALENNO);
          if wm_ComOffset = 0 then
          begin
            //�I�t�Z�b�g��ݒ�
            wm_Offset := w_StremField.offset;
            //���ڃR�[�h�J�n�I�t�Z�b�g�ʒu
            wm_ComOffset := wm_Offset;
          end;
          //�d���F���̑��ڍג��̎擾
          wm_DataSonotaComLen := '';
          wm_DataSonotaComLen := func_GetStringStream3(arg_System, w_Kind,
                                                       arg_TStringStream,
                                                       wm_ComOffset,
                                                       IRAISONOTALENLEN);
          w_s := wm_DataSonotaComLen;
          //���p�u�����N�̍폜
          wm_DataSonotaComLen := TrimRight(wm_DataSonotaComLen);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + IRAISONOTALENLEN;
          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);
          Continue;
        end
        else
        //���̑��ڍ�
        if IRAISONOTANO = w_i then begin
          //���̑��ڍׂ̖��̂��擾
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAISONOTANO);
          if wm_ComOffset = 0 then
          begin
            //�I�t�Z�b�g��ݒ�
            wm_Offset := w_StremField.offset;
            //���ڃR�[�h�J�n�I�t�Z�b�g�ʒu
            wm_ComOffset := wm_Offset;
          end;
          //�d���F���̑��ڍׂ̎擾
          w_s := '';
          w_s := func_GetStringStream3(arg_System, w_Kind,
                                                    arg_TStringStream, wm_ComOffset,
                                               StrToIntDef(wm_DataSonotaComLen, 0));
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + StrToIntDef(wm_DataSonotaComLen, 0);
          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);
          Continue;
        end
        else
        //�˗����a����
        if IRAIBYOUMEILENNO = w_i then begin
          //�˗����a�����̖��̂��擾
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAIBYOUMEILENNO);
          if wm_ComOffset = 0 then
          begin
            //�I�t�Z�b�g��ݒ�
            wm_Offset := w_StremField.offset;
            //���ڃR�[�h�J�n�I�t�Z�b�g�ʒu
            wm_ComOffset := wm_Offset;
          end;
          //�d���F�˗����a�����̎擾
          wm_DataByoumeiComLen := '';
          wm_DataByoumeiComLen := func_GetStringStream3(arg_System, w_Kind,
                                                        arg_TStringStream,
                                                        wm_ComOffset,
                                                        IRAIBYOUMEILENLEN);
          w_s := wm_DataByoumeiComLen;
          //���p�u�����N�̍폜
          wm_DataByoumeiComLen := TrimRight(wm_DataByoumeiComLen);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + IRAIBYOUMEILENLEN;
          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);
          Continue;
        end
        else
        //�˗����a��
        if IRAIBYOUMEINO = w_i then begin
          //�˗����a���̖��̂��擾
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAIBYOUMEINO);
          if wm_ComOffset = 0 then
          begin
            //�I�t�Z�b�g��ݒ�
            wm_Offset := w_StremField.offset;
            //���ڃR�[�h�J�n�I�t�Z�b�g�ʒu
            wm_ComOffset := wm_Offset;
          end;
          //�d���F�˗����a���̎擾
          w_s := '';
          w_s := func_GetStringStream3(arg_System, w_Kind,
                                                     arg_TStringStream,
                                                     wm_ComOffset,
                                              StrToIntDef(wm_DataByoumeiComLen, 0));
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + StrToIntDef(wm_DataByoumeiComLen, 0);
          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);
          Continue;
        end;
      end;
      //���[�v�J�n�ɂȂ����ꍇ
      if IRAIGROUPNO <= w_i then begin
        //���ڌ�������ꍇ
        if w_Kmk > 0 then begin
          //�����̏ꍇ
          if w_Kmk_Count = 0 then begin
            //�O���[�v�ԍ��ʒu
            w_Kmk_Count := IRAIGROUPNO;
          end;

          inc(w_Kmk_SyoriCount);

          //�d���F�O���[�v�ԍ��̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIGROUPNO,wm_ComOffset);
          //�O���[�v�ԍ��̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAIGROUPNO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F�I�[�_�i���̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIORDERSTATUSNO,wm_ComOffset);
          //�I�[�_�i���̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIORDERSTATUSNO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F��v�i���̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIACCOUNTSTATUSNO,wm_ComOffset);
          //��v�i���̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIACCOUNTSTATUSNO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F���{���̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIORDEREXDATENO,wm_ComOffset);
          //���{���̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIORDEREXDATENO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F���{���Ԃ̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIORDEREXTIMENO,wm_ComOffset);
          //���{���Ԃ̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIORDEREXTIMENO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F���ڃR�[�h�̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIKOUMOKUCODENO,wm_ComOffset);
          //���ڃR�[�h�̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIKOUMOKUCODENO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F���ږ��̂̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIKOUMOKUNAMENO,wm_ComOffset);
          //���ږ��̂̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIKOUMOKUNAMENO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F�B�e��R�[�h�̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIORDERSYUCODENO,wm_ComOffset);
          //�B�e��R�[�h�̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIORDERSYUCODENO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F�B�e�햼�̂̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIORDERSYUNAMENO,wm_ComOffset);
          //�B�e�햼�̂̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIORDERSYUNAMENO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F���ʃR�[�h�̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIBUICODENO,wm_ComOffset);
          //���ʃR�[�h�̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAIBUICODENO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F���ʖ��̂̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIBUINAMENO,wm_ComOffset);
          //���ʖ��̂̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind, IRAIBUINAMENO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F�������R�[�h�̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIKENSAROOMCODENO,wm_ComOffset);
          //�������R�[�h�̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIKENSAROOMCODENO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F���������̂̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIKENSAROOMNAMENO,wm_ComOffset);
          //���������̂̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIKENSAROOMNAMENO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F���א��̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       IRAIMEISAICOUNTNO,wm_ComOffset);
          //���א��̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            IRAIMEISAICOUNTNO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;
          //���א����l��
          wi_MeisaiCount := StrToIntDef(Trim(w_s),0);

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          for w_Loop_Meisai := 0 to wi_MeisaiCount - 1 do
          begin
            //�d���F���R�[�h�敪�̎擾
            w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                         IRAIYRECKBNNO, wm_ComOffset);
            //���p�u�����N�̍폜
            ws_RecKbn := TrimRight(w_s);
            //���R�[�h�敪�̒������擾
            w_StremField := func_FindMsgField(arg_System, w_Kind,
                                              IRAIYRECKBNNO);
            //�I�t�Z�b�g�ʒu�̈ړ�
            wm_ComOffset := wm_ComOffset + w_StremField.size;

            //��܁E��Z�E�ޗ��E�t�B����
            if (ws_RecKbn = CST_RECORD_KBN_20) or
               (ws_RecKbn = CST_RECORD_KBN_30) or
               (ws_RecKbn = CST_RECORD_KBN_50) or
               (ws_RecKbn = CST_RECORD_KBN_57) then
            begin
              //���R�[�h�敪�̃^�C�g�����擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAIYRECKBNNO);
              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              w_Kmk_Count := IRAIYKMKCODENO;
            end
            //�I���R�����g�E�K�{�R�����g�E�t���[�R�����g
            else if (ws_RecKbn = CST_RECORD_KBN_97) or
                    (ws_RecKbn = CST_RECORD_KBN_98) or
                    (ws_RecKbn = CST_RECORD_KBN_99) then
            begin
              //���R�[�h�敪�̃^�C�g�����擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAICRECKBNNO);
              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              w_Kmk_Count := IRAICKMKCODENO;
            end
            //�V�F�[�}
            else if ws_RecKbn = CST_RECORD_KBN_95 then
            begin
              //���R�[�h�敪�̃^�C�g�����擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAISRECKBNNO);
              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              w_Kmk_Count := IRAISINFONO;
            end;
            //��܁E��Z�E�ޗ��E�t�B����
            if (ws_RecKbn = CST_RECORD_KBN_20) or
               (ws_RecKbn = CST_RECORD_KBN_30) or
               (ws_RecKbn = CST_RECORD_KBN_50) or
               (ws_RecKbn = CST_RECORD_KBN_57) then
            begin
              //�d���F���ڃR�[�h�̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           IRAIYKMKCODENO, wm_ComOffset);
              //���ڃR�[�h�̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAIYKMKCODENO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              //�d���F���ږ��̂̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAIYKMKNAMENO, wm_ComOffset);
              //���ږ��̂̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAIYKMKNAMENO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              //�d���F�g�p�ʂ̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAIYUSENO, wm_ComOffset);
              //�g�p�ʂ̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAIYUSENO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              //�d���F�������̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAIYBUNKATUNO, wm_ComOffset);
              //�������̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAIYBUNKATUNO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              //�d���F�\���̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAIYYOBINO, wm_ComOffset);
              //�\���̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAIYYOBINO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              w_Kmk_Count := IRAIYKMKCODENO;

            end
            //�I���R�����g�E�K�{�R�����g�E�t���[�R�����g
            else if (ws_RecKbn = CST_RECORD_KBN_88) or
                    (ws_RecKbn = CST_RECORD_KBN_90) or
                    (ws_RecKbn = CST_RECORD_KBN_91) or
                    (ws_RecKbn = CST_RECORD_KBN_92) or
                    (ws_RecKbn = CST_RECORD_KBN_93) or
                    (ws_RecKbn = CST_RECORD_KBN_94) or
                    (ws_RecKbn = CST_RECORD_KBN_97) or
                    (ws_RecKbn = CST_RECORD_KBN_98) or
                    (ws_RecKbn = CST_RECORD_KBN_99) then
            begin
              //�d���F���ڃR�[�h�̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAICKMKCODENO, wm_ComOffset);
              //���ڃR�[�h�̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAICKMKCODENO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              //�d���F���ږ��̂̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           IRAICKMKNAMENO, wm_ComOffset);
              //���ږ��̂̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                IRAICKMKNAMENO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              //�d���F�\���̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           IRAICYOBINO, wm_ComOffset);
              //�\���̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind, IRAICYOBINO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              w_Kmk_Count := IRAICKMKCODENO;

            end
            //�V�F�[�}
            else if ws_RecKbn = CST_RECORD_KBN_95 then
            begin
              //�d���F�V�F�[�}���̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAISNAMENO, wm_ComOffset);
              //�V�F�[�}���̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind, IRAISNAMENO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              //�d���F�V�F�[�}���̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAISINFONO, wm_ComOffset);
              //�V�F�[�}���̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind, IRAISINFONO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              //�d���F�V�F�[�}�\���̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      IRAISYOBINO, wm_ComOffset);
              //�V�F�[�}�\���̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind, IRAISYOBINO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              w_Kmk_Count := IRAICKMKCODENO;

            end;
            if w_Loop_Meisai = wi_MeisaiCount then begin
              w_Kmk_Count := IRAIGROUPNO;
              if w_Kmk_SyoriCount = w_Kmk then
                Exit;
            end;
          end;
          if w_Kmk_SyoriCount = w_Kmk then
            Exit;
        end;
      end
      else
        //��M���ڂ̏��擾
        w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
    end
    //����ȊO�̓d��
    else
      //��M���ڂ̏��擾
      w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
    if ((w_Kind = G_MSGKIND_IRAI) and
       (IRAIMOKUTEKILENNO > w_i)) or
       (w_Kind <> G_MSGKIND_IRAI) then
    begin
      //�͂��߂̏ꍇ
      if w_i = 1 then
        //�ʒu�ݒ�
        w_offset := 0;
      //�T�C�Y�ݒ�
      w_size   := w_StremField.size;
      //�|�W�V�����ړ�
      arg_TStringStream.Position := w_offset;
      //�f�[�^�̓ǂݍ���
      w_s      := arg_TStringStream.ReadString(w_size);
      //���ږ��̂̐ݒ�
      w_FieldName  := w_StremField.name;
      //�f���~�^�̏ꍇ
      if G_FIELD_NAME_DERI = w_FieldName then begin
        if (w_s = Chr($0D)) or
           (w_s = '') then begin
          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>�f���~�^')
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);
          //�����I��
          Exit;
        end;
      end;
      if arg_System <> CST_NON_TITLE then
        //�ݒ� �l�Ɩ��O
        arg_TStringList.Add( w_s + '<:>' + w_FieldName)
      else
        //�ݒ� �l�Ɩ��O
        arg_TStringList.Add(w_s);
      //�ʒu�ݒ�
      w_offset := w_offset + w_StremField.size;
    end;
  end;
  //�����I��
  Exit;
end;
{
-----------------------------------------------------------------------------
  ���O : proc_TStrmToStrlist_H_Jissi;
  ���� :
  arg_TStringList:TStringList      ��
  arg_TStringList   : TStringList  ��
  arg_System        : string;      ���
  arg_MsgKind       : string       ���

  �@�\ : TStringStream����͂���TStringList���쐬����
  ���A�l�F
-----------------------------------------------------------------------------
}
procedure proc_TStrmToStrlist_H_Jissi(
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string;
           arg_MsgKind       : string
           );
var
  w_i:integer;
  w_MaxDefLen:integer;
  w_offset:integer;
  w_size  :integer;
  w_s:string;
  w_FieldName:string;
  w_StremField : TStreamField;
  w_Kmk:integer;
  w_Kmk_Count:integer;
  w_Kind:String;
  wm_Offset:Integer;
  wm_ComOffset:Integer;
  wi_MeisaiCount:Integer;
  w_Loop_Meisai:Integer;
  ws_RecKbn:String;
  w_Kmk_SyoriCount:Integer;
begin
//TStringStream��TStringList�ɓW�J
  //�����l
  arg_TStringList.Text := '';
  //������
  arg_TStringList.Clear;
  //�����ʒu�Ɉړ�
  arg_TStringStream.Position := 0;
  //���ڐ����擾
  w_MaxDefLen := func_MsgDefLen(arg_System,arg_MsgKind);

  //������
  w_Kmk         := 0;
  w_Kmk_Count   := 0;
  w_offset      := 0;
  w_Kind        := arg_MsgKind;
  w_Kmk_SyoriCount := 0;
  wm_ComOffset := 0;
  //���ڐ����쐬
  for w_i := 1 to w_MaxDefLen do begin
    //���{���d���̏ꍇ
    if w_Kind = G_MSGKIND_JISSI then begin
      case w_i of
        //�O���[�v������
        CST_JISSI_LOOPSTART:
        begin
          //�O���[�v�����ڎ擾
          w_s := func_GetStringStream(arg_System,w_Kind,arg_TStringStream,CST_JISSI_LOOPSTART);
          //��M���ڂ̏��擾
          w_StremField := func_FindMsgField(arg_System,w_Kind,CST_JISSI_LOOPSTART);
          //�O���[�v�����ڂ����l�̏ꍇ
          if func_IsNumber(w_s) then
            //�O���[�v�����ڎ擾
            w_Kmk := StrToInt(w_s)
          else
            //�O���[�v�����ڂȂ�
            w_Kmk := 0;
          //���ڂ̍ő吔�ȏ�̏ꍇ
          if w_Kmk > CST_GROUP_LOOP_MAX then
            //���ڂ̍ő吔�ɐݒ�
            w_Kmk := CST_GROUP_LOOP_MAX;
        end;
      end;
      //���[�v�J�n�ɂȂ����ꍇ
      if JISSIGROUPNO <= w_i then begin
        //���ڌ�������ꍇ
        if w_Kmk > 0 then begin
          //�����̏ꍇ
          if w_Kmk_Count = 0 then begin
            //�O���[�v�ԍ��ʒu
            w_Kmk_Count := JISSIGROUPNO;
          end;

          inc(w_Kmk_SyoriCount);
          if wm_ComOffset = 0 then begin
            //�����ړI���܂ł̃I�t�Z�b�g���擾
            w_StremField := func_FindMsgField(arg_System, w_Kind, JISSIGROUPNO);
            //�I�t�Z�b�g��ݒ�
            wm_Offset := w_StremField.offset;
            //���ڃR�[�h�J�n�I�t�Z�b�g�ʒu
            wm_ComOffset := wm_Offset;
          end;

          //�d���F�O���[�v�ԍ��̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIGROUPNO,wm_ComOffset);
          //�O���[�v�ԍ��̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind, JISSIGROUPNO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F��v�敪�̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIKAIKEIKBNNO,wm_ComOffset);
          //��v�敪�̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            JISSIKAIKEIKBNNO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F���{�敪�̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIJISSIKBNNO,wm_ComOffset);
          //���{�敪�̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            JISSIJISSIKBNNO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F���ڃR�[�h�̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIKMKCODENO,wm_ComOffset);
          //���ڃR�[�h�̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            JISSIKMKCODENO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F�����񐔂̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIKENSACOUNTNO,wm_ComOffset);
          //�����񐔂̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            JISSIKENSACOUNTNO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F�B�e��R�[�h�̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIBUISATUEICODENO,wm_ComOffset);
          //�B�e��R�[�h�̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            JISSIBUISATUEICODENO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F���ʃR�[�h�̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIBUICODENO,wm_ComOffset);
          //���ʃR�[�h�̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind, JISSIBUICODENO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F�������R�[�h�̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIKENSAROOMCODENO,wm_ComOffset);
          //�������̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind, JISSIKENSAROOMCODENO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F�|�[�^�u���̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIPORTABLENO,wm_ComOffset);
          //�|�[�^�u���̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            JISSIPORTABLENO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          //�d���F���א��̎擾
          w_s := func_GetStringStream2(arg_System,w_Kind,arg_TStringStream,
                                       JISSIMEISAICOUNTNO,wm_ComOffset);
          //���א��̒������擾
          w_StremField := func_FindMsgField(arg_System, w_Kind,
                                            JISSIMEISAICOUNTNO);
          //�I�t�Z�b�g�ʒu�̈ړ�
          wm_ComOffset := wm_ComOffset + w_StremField.size;
          //���א����l��
          wi_MeisaiCount := StrToIntDef(Trim(w_s),0);

          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);

          for w_Loop_Meisai := 0 to wi_MeisaiCount - 1 do
          begin
            //�d���F�Ǘ��敪�̎擾
            w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                         JISSIYRECORDKBNNO, wm_ComOffset);
            //���p�u�����N�̍폜
            ws_RecKbn := TrimRight(w_s);
            //���R�[�h�敪�̒������擾
            w_StremField := func_FindMsgField(arg_System, w_Kind,
                                              JISSIYRECORDKBNNO);
            {
            if arg_System <> CST_NON_TITLE then
              //�ݒ� �l�Ɩ��O
              arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
            else
              //�ݒ� �l�Ɩ��O
              arg_TStringList.Add(w_s);
            }
            //�I�t�Z�b�g�ʒu�̈ړ�
            wm_ComOffset := wm_ComOffset + w_StremField.size;

            //���
            if (ws_RecKbn = CST_RECORD_KBN_20) or
               (ws_RecKbn = CST_RECORD_KBN_30) or
               (ws_RecKbn = CST_RECORD_KBN_50) or
               (ws_RecKbn = CST_RECORD_KBN_57) then
            begin
              //���R�[�h�敪�̃^�C�g�����擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSIYRECORDKBNNO);
              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              w_Kmk_Count := JISSIYKMKCODENO;
            end
            //�I���R�����g�E�K�{�R�����g�E�t���[�R�����g
            else if (ws_RecKbn = CST_RECORD_KBN_88) or
                    (ws_RecKbn = CST_RECORD_KBN_90) or
                    (ws_RecKbn = CST_RECORD_KBN_91) or
                    (ws_RecKbn = CST_RECORD_KBN_92) or
                    (ws_RecKbn = CST_RECORD_KBN_93) or
                    (ws_RecKbn = CST_RECORD_KBN_94) or
                    (ws_RecKbn = CST_RECORD_KBN_97) or
                    (ws_RecKbn = CST_RECORD_KBN_98) or
                    (ws_RecKbn = CST_RECORD_KBN_99) then
            begin
              //���R�[�h�敪�̃^�C�g�����擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSICRECORDKBNNO);
              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              w_Kmk_Count := JISSICKMKCODENO;
            end;
            //���
            if (ws_RecKbn = CST_RECORD_KBN_20) or
               (ws_RecKbn = CST_RECORD_KBN_30) or
               (ws_RecKbn = CST_RECORD_KBN_50) or
               (ws_RecKbn = CST_RECORD_KBN_57) then
            begin
              //�d���F���ڃR�[�h�̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      JISSIYKMKCODENO, wm_ComOffset);
              //���ڃR�[�h�̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSIYKMKCODENO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              //�d���F�I�[�_�g�p�ʂ̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           JISSIYORDERUSENO, wm_ComOffset);
              //�I�[�_�g�p�ʂ̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSIYORDERUSENO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              //�d���F�������̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           JISSIYBUNKATUNO, wm_ComOffset);
              //�������̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSIYBUNKATUNO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              //�d���F�\���̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                      JISSIYYOBINO, wm_ComOffset);
              //�\���̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSIYYOBINO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              w_Kmk_Count := JISSIYRECORDKBNNO;

            end
            //�I���R�����g�E�K�{�R�����g�E�t���[�R�����g
            else if (ws_RecKbn = CST_RECORD_KBN_88) or
                    (ws_RecKbn = CST_RECORD_KBN_90) or
                    (ws_RecKbn = CST_RECORD_KBN_91) or
                    (ws_RecKbn = CST_RECORD_KBN_92) or
                    (ws_RecKbn = CST_RECORD_KBN_93) or
                    (ws_RecKbn = CST_RECORD_KBN_94) or
                    (ws_RecKbn = CST_RECORD_KBN_97) or
                    (ws_RecKbn = CST_RECORD_KBN_98) or
                    (ws_RecKbn = CST_RECORD_KBN_99) then
            begin
              //�d���F���ڃR�[�h�̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           JISSICKMKCODENO, wm_ComOffset);
              //���ڃR�[�h�̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSICKMKCODENO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              //�d���F�R�����g�̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           JISSICCOMNO, wm_ComOffset);
              //�R�����g�̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind,
                                                JISSICCOMNO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              //�d���F�\���̎擾
              w_s := func_GetStringStream2(arg_System, w_Kind, arg_TStringStream,
                                           JISSICYOBINO, wm_ComOffset);
              //�\���̒������擾
              w_StremField := func_FindMsgField(arg_System, w_Kind, JISSICYOBINO);
              //�I�t�Z�b�g�ʒu�̈ړ�
              wm_ComOffset := wm_ComOffset + w_StremField.size;

              if arg_System <> CST_NON_TITLE then
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add( w_s + '<:>' + w_StremField.name)
              else
                //�ݒ� �l�Ɩ��O
                arg_TStringList.Add(w_s);

              w_Kmk_Count := JISSICRECORDKBNNO;

            end;
            if w_Loop_Meisai = wi_MeisaiCount then begin
              w_Kmk_Count := JISSIGROUPNO;
              if w_Kmk_SyoriCount = w_Kmk then
                Exit;
            end;
          end;
          if w_Kmk_SyoriCount = w_Kmk then
            Exit;
        end;
      end
      else
        //��M���ڂ̏��擾
        w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
    end
    //����ȊO�̓d��
    else
      //��M���ڂ̏��擾
      w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
    if ((w_Kind = G_MSGKIND_JISSI) and
       (JISSIGROUPNO > w_i)) then
    begin
      //�͂��߂̏ꍇ
      if w_i = 1 then
        //�ʒu�ݒ�
        w_offset := 0;
      //�T�C�Y�ݒ�
      w_size   := w_StremField.size;
      //�|�W�V�����ړ�
      arg_TStringStream.Position := w_offset;
      //�f�[�^�̓ǂݍ���
      w_s      := arg_TStringStream.ReadString(w_size);
      //���ږ��̂̐ݒ�
      w_FieldName  := w_StremField.name;
      //�f���~�^�̏ꍇ
      if G_FIELD_NAME_DERI = w_FieldName then begin
        if (w_s = Chr($0D)) or
           (w_s = '') then begin
          if arg_System <> CST_NON_TITLE then
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add( w_s + '<:>�f���~�^')
          else
            //�ݒ� �l�Ɩ��O
            arg_TStringList.Add(w_s);
          //�����I��
          Exit;
        end;
      end;
      if arg_System <> CST_NON_TITLE then
        //�ݒ� �l�Ɩ��O
        arg_TStringList.Add( w_s + '<:>' + w_FieldName)
      else
        //�ݒ� �l�Ɩ��O
        arg_TStringList.Add(w_s);
      //�ʒu�ݒ�
      w_offset := w_offset + w_StremField.size;
    end;
  end;
  //�����I��
  Exit;
end;
{
-----------------------------------------------------------------------------
  ���O : proc_TStrmToStrlist2;
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
           arg_TStringList   : TStringList  ;
           arg_System        : string;
           arg_MsgKind       : string
           );
var
  w_i:integer;
  w_s:string;
  w_Kind,w_S2:String;
begin
//TStringStream��TStringList�ɓW�J
  //�����l
  arg_TStringList.Text := '';
  //������
  arg_TStringList.Clear;
  //�����ʒu�Ɉړ�
  arg_TStringStream.Position := 0;
  //������
  w_Kind        := arg_MsgKind;
  w_i := 1;
  w_S := arg_TStringStream.DataString;
  w_S2 := Copy(arg_TStringStream.DataString,1,1);
  arg_TStringList.Add(w_S2);
  w_S2 := Copy(arg_TStringStream.DataString,2,1);
  arg_TStringList.Add(w_S2);
  w_S2 := Copy(arg_TStringStream.DataString,3,4);
  //w_S2 := FormatFloat('00000',bswapf(StrToInt(w_s)));
  arg_TStringList.Add(w_S2);
  w_S := Copy(w_S,7,Length(w_S));
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
  //�����I��
  Exit;
end;
{
-----------------------------------------------------------------------------
  ���O : proc_TStrmToStrlist3;
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
           arg_TStringStream : TStringStream;
           arg_TStringList   : TStringList  ;
           arg_System        : string;
           arg_MsgKind       : string
           );
var
  w_s:string;
  w_Kind,w_S2:String;
begin
//TStringStream��TStringList�ɓW�J
  //�����l
  arg_TStringList.Text := '';
  //������
  arg_TStringList.Clear;
  //�����ʒu�Ɉړ�
  arg_TStringStream.Position := 0;
  //������
  w_Kind        := arg_MsgKind;
  w_S := arg_TStringStream.DataString;
  w_S2 := Copy(arg_TStringStream.DataString,1,1);
  arg_TStringList.Add(w_S2);
  w_S2 := Copy(arg_TStringStream.DataString,2,5);
  arg_TStringList.Add(w_S2);
  w_S2 := Copy(arg_TStringStream.DataString,7,2);
  if func_IsNumber(w_S2) then begin
    proc_Change_Byte(w_S2);
  end;
  arg_TStringList.Add(w_S2);
  //�����I��
  Exit;
end;

{
-----------------------------------------------------------------------------
  ���O : proc_TStrListToStrm;
  ���� :
  arg_TStringList   : TStringList  ��
  arg_TStringList:TStringList      ��
  arg_System        : string;      ���
  arg_MsgKind       : string       ���
  arg_TStringList:TStringList
  �@�\ : TStringList���TStringStream���쐬����
  �c�[������̎蓮���͂��l������
  ��`�������ɕ⊮�Ɛ؂�̂ď����������Ȃ��B
  ���A�l�FTStringStream nil���s
-----------------------------------------------------------------------------
}
Procedure  proc_TStrListToStrm(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream;
           arg_System        : string;
           arg_MsgKind       : string
           );
begin
  //�X�g�����O���X�g����X�g���[����
  if arg_MsgKind = G_MSGKIND_JISSI then
  begin
    proc_TStrListToStrm_Jissi(arg_TStringList,arg_TStringStream,arg_System,arg_MsgKind);
  end
  else
  begin
    proc_TStrListToStrm_Irai(arg_TStringList,arg_TStringStream,arg_System,arg_MsgKind);
  end;

  //�����I��
  Exit;
end;
{
-----------------------------------------------------------------------------
  ���O : proc_TStrListToStrm_Irai;
  ���� :
  arg_TStringList   : TStringList  ��
  arg_TStringList:TStringList      ��
  arg_System        : string;      ���
  arg_MsgKind       : string       ���
  arg_TStringList:TStringList
  �@�\ : TStringList���TStringStream���쐬����
  �c�[������̎蓮���͂��l������
  ��`�������ɕ⊮�Ɛ؂�̂ď����������Ȃ��B
  ���A�l�FTStringStream nil���s
-----------------------------------------------------------------------------
}
Procedure  proc_TStrListToStrm_Irai(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream;
           arg_System        : string;
           arg_MsgKind       : string
           );
var
  w_i:integer;
  w_len1:integer;
  w_len2:integer;
  w_s:string;
  w_MsgDeflen:integer;
  w_RMsglen:integer;
  w_StremField : TStreamField;
  w_Kmk:integer;
  w_Kmk_Count:integer;
  w_Kmk_No:integer;
  w_Kind:String;
  wi_MeisaiLoop: Integer;
  wi_MeisaiCount: Integer;
  wi_RecKbn: Integer;
  wi_RecKbn_Yakuzai: Integer;
  wi_RecKbn_Comment: Integer;
  wi_RecKbn_Schema: Integer;
  wb_Mesai_Flg: Boolean;
begin
  //TStringList��TStringStream�ɓW�J
  try
    //�d����ʂ̓d���������߂�
    w_MsgDeflen := func_MsgDefLen(arg_System, arg_MsgKind);
    //�d�������Ȃ��ꍇ
    if w_MsgDeflen = 0 then
    begin
      //�����I��
      Exit;
    end;
//�d�����𒲂ׂ�
    w_RMsglen     := 0;
    //������
    w_Kmk         := 0;
    w_Kmk_Count   := 0;
    w_Kmk_No      := 0;
    wi_MeisaiCount:= 0;
    wi_MeisaiLoop := 0;
    wb_Mesai_Flg  := False;
    wi_RecKbn     := 0;
    wi_RecKbn_Yakuzai := 0;
    wi_RecKbn_Comment := 0;
    wi_RecKbn_Schema  := 0;
    w_Kind := arg_MsgKind;
    //���X�g�������[�v
    for w_i := 1 to arg_TStringList.Count do
    begin
      //���X�g������̒����擾
      w_len1       := length(arg_TStringList[w_i-1]);
      //�˗����d���̏ꍇ
      if w_Kind = G_MSGKIND_IRAI then
      begin
        case w_i of
          //�O���[�v������
          CST_IRAI_LOOPSTART:
          begin
            //�O���[�v�����ڂ����l�̏ꍇ
            if func_IsNumber(arg_TStringList[w_i-1]) then
            begin
              //�O���[�v�����ڎ擾
              w_Kmk := StrToInt(arg_TStringList[w_i-1]);
            end
            else
            begin
              //�O���[�v�����ڂȂ�
              w_Kmk := 0;
            end;
            //���ڂ̍ő吔�ȏ�̏ꍇ
            if w_Kmk > CST_GROUP_LOOP_MAX then
            begin
              //���ڂ̍ő吔�ɐݒ�
              w_Kmk := CST_GROUP_LOOP_MAX;
            end;
          end;
        end;
        //���[�v�J�n�ɂȂ����ꍇ(�O���[�v�ԍ�)
        if IRAIGROUPNO <= w_i then
        begin
          //���ڌ�������ꍇ
          if w_Kmk > 0 then
          begin
            //�J��Ԃ����O���[�v���ɒB����܂�
            if w_Kmk_Count <= w_Kmk then
            begin
              //�O���[�v�ԍ��`���א��܂�
              if IRAIMEISAICOUNTNO > w_Kmk_No then
              begin
                //��ԏ��߂̏ꍇ
                if w_Kmk_No = 0 then
                begin
                  if w_Kmk_Count = 0 then
                    //������
                    w_Kmk_Count := 1;
                  //�d�����C�A�E�g�ʒu��"�O���[�v�ԍ�"�̈ʒu�ݒ�
                  w_Kmk_No := IRAIGROUPNO;
                end
                //�ȊO�̏ꍇ
                else
                begin
                  //�O��Ɂ{�P
                  inc(w_Kmk_No);
                end;
                //���M���ڂ̏��擾
                w_StremField := func_FindMsgField(arg_System,w_Kind,w_Kmk_No);
                //���א��̏ꍇ
                if IRAIMEISAICOUNTNO = w_Kmk_No then
                begin
                  //���R�[�h�敪������
                  wi_RecKbn := 0;
                  wi_RecKbn_Yakuzai := 0;
                  wi_RecKbn_Comment := 0;
                  wi_RecKbn_Schema  := 0;
                  wi_MeisaiLoop := 0;
                  //���א��̐ݒ�
                  wi_MeisaiCount := StrToIntDef(arg_TStringList[w_i - 1],0);
                  wb_Mesai_Flg := False;
                end;
              end
              //���א��ȍ~�̏ꍇ
              else
              begin
                //���׉񐔂�����ꍇ
                if (wi_MeisaiCount > 0) and
                   (wi_MeisaiLoop < wi_MeisaiCount) then
                   begin
                  if not wb_Mesai_Flg then
                  begin
                    //���R�[�h�敪�ݒ�
                    wi_RecKbn := StrToIntDef(arg_TStringList[w_i - 1],0);
                    //���M���ڂ̏��擾
                    w_StremField := func_FindMsgField(arg_System,w_Kind,IRAIYRECKBNNO);
                    //���R�[�h�敪�擾����
                    wb_Mesai_Flg := True;
                  end
                  else
                  begin
                    case wi_RecKbn of
                      //��܁E��Z�E�ޗ��E�t�B����
                      20,30,50,57:
                        begin
                          //��ԏ��߂̏ꍇ
                          if wi_RecKbn_Yakuzai = 0 then
                          begin
                            //�d�����C�A�E�g�ʒu��"���ڃR�[�h"�̈ʒu�ݒ�
                            wi_RecKbn_Yakuzai := IRAIYKMKCODENO;
                          end
                          //����ȊO�̏ꍇ
                          else
                          begin
                            //�O��Ɂ{�P
                            inc(wi_RecKbn_Yakuzai);
                          end;
                          //���M���ڂ̏��擾
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Yakuzai);
                          //"�\��"�܂ŏI�������ꍇ
                          if wi_RecKbn_Yakuzai = IRAIYYOBINO then
                          begin
                            wi_RecKbn_Yakuzai := IRAIYRECKBNNO;
                            Inc(wi_MeisaiLoop);
                            //���R�[�h�敪���擾
                            wb_Mesai_Flg := False;
                            //���׍��ڏI���̏ꍇ
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //������
                              w_Kmk_No := 0;
                              //�񐔃A�b�v
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                      //�I���E�K�{�E�t���[�R�����g
                      88,90,91,92,93,94,97,98,99:
                        begin
                          //��ԏ��߂̏ꍇ
                          if wi_RecKbn_Comment = 0 then
                          begin
                            //�d�����C�A�E�g�ʒu��"���ڃR�[�h"�̈ʒu�ݒ�
                            wi_RecKbn_Comment := IRAICKMKCODENO;
                          end
                          //����ȊO�̏ꍇ
                          else
                          begin
                            //�O��Ɂ{�P
                            inc(wi_RecKbn_Comment);
                          end;
                          //���M���ڂ̏��擾
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Comment);
                          //"�\��"�܂ŏI�������ꍇ
                          if wi_RecKbn_Comment = IRAICYOBINO then
                          begin
                            wi_RecKbn_Comment := IRAICRECKBNNO;
                            Inc(wi_MeisaiLoop);
                            //���R�[�h�敪���擾
                            wb_Mesai_Flg := False;
                            //���׍��ڏI���̏ꍇ
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //������
                              w_Kmk_No := 0;
                              //�񐔃A�b�v
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                      //�V�F�[�}
                      95:
                        begin
                          //��ԏ��߂̏ꍇ
                          if wi_RecKbn_Schema = 0 then
                          begin
                            //�d�����C�A�E�g�ʒu��"�V�F�[�}���"�̈ʒu�ݒ�
                            wi_RecKbn_Schema := IRAISNAMENO;
                          end
                          //����ȊO�̏ꍇ
                          else
                          begin
                            //�O��Ɂ{�P
                            inc(wi_RecKbn_Schema);
                          end;
                          //���M���ڂ̏��擾
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Schema);
                          //"�V�F�[�}���"�܂ŏI�������ꍇ
                          if wi_RecKbn_Schema = IRAISYOBINO then
                          begin
                            wi_RecKbn_Schema := IRAISRECKBNNO;
                            Inc(wi_MeisaiLoop);
                            //���R�[�h�敪���擾
                            wb_Mesai_Flg := False;
                            //���׍��ڏI���̏ꍇ
                            //���׍��ڏI���̏ꍇ
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //������
                              w_Kmk_No := 0;
                              //�񐔃A�b�v
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                    end;
                  end;
                end
                else
                begin
                  //�d�����C�A�E�g�ʒu��"�O���[�v�ԍ�"�̈ʒu�ݒ�
                  w_Kmk_No := IRAIGROUPNO;
                  //���M���ڂ̏��擾
                  w_StremField := func_FindMsgField(arg_System,w_Kind,w_Kmk_No);
                end;
              end;
            end;
          end;
        end
        else
        begin
          //���M���ڂ̏��擾
          w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
        end;
      end
      else
      begin
        //���M���ڂ̏��擾
        w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
      end;
      //���[�v�J�n�ɂȂ����ꍇ
      if (IRAIMOKUTEKINO = w_i)  or
         (IRAISIJINO = w_i)      or
         (IRAISONOTANO = w_i)    or
         (IRAIBYOUMEINO = w_i)   then
         begin
        //���M���ڂ̒����擾
        w_len2 := StrToIntDef(arg_TStringList[w_i-2],0);
      end
      else
      begin
        //���M���ڂ̒����擾
        w_len2       := w_StremField.size;
      end;
      //���X�g������̂�著�M���ڂ̒������������ꍇ
      if w_len1 >= w_len2 then
      begin
        //�ݒ�
        w_RMsglen := w_RMsglen + w_len2;
      end
      //����ȊO�̏ꍇ
      else
      begin
        //�ݒ�
        w_RMsglen := w_RMsglen + w_len2;
      end;
      //�d�����C�A�E�g��̍ő�
      if w_MsgDeflen = w_i then
      begin
        //�����I��
        Break;
      end;
    end;
    //�ꃉ�C�����W�J
    arg_TStringStream.Position := 0;
    //������
    w_Kmk_Count  := 0;
    w_Kmk_No := 0;
    //���X�g�������[�v
    for w_i := 1 to arg_TStringList.Count do
    begin
      //�d�������ڂ̏ꍇ
      if w_i = COMMON1DENLENNO then
      begin
        //�T�C�Y�ݒ�
        w_s := FormatFloat('000000', w_RMsglen - 32);
        //�d�������ڏ�������
        arg_TStringStream.WriteString(w_s);
      end
      //����ȊO�̍��ڂ̏ꍇ
      else
      begin
        //������擾
        w_s          := arg_TStringList[w_i-1];
        //���M�����񒷎擾
        w_len1       := length( w_s );
        //���[�v�J�n�ɂȂ����ꍇ(�O���[�v�ԍ�)
        if IRAIGROUPNO <= w_i then
        begin
          //���ڌ�������ꍇ
          if w_Kmk > 0 then
          begin
            //�J��Ԃ����O���[�v���ɒB����܂�
            if w_Kmk_Count <= w_Kmk then
            begin
              //�O���[�v�ԍ��`���א��܂�
              if IRAIMEISAICOUNTNO > w_Kmk_No then
              begin
                //��ԏ��߂̏ꍇ
                if w_Kmk_No = 0 then
                begin
                  if w_Kmk_Count = 0 then
                    //������
                    w_Kmk_Count := 1;
                  //�d�����C�A�E�g�ʒu��"�O���[�v�ԍ�"�̈ʒu�ݒ�
                  w_Kmk_No := IRAIGROUPNO;
                end
                //�ȊO�̏ꍇ
                else
                begin
                  //�O��Ɂ{�P
                  inc(w_Kmk_No);
                end;
                //���M���ڂ̏��擾
                w_StremField := func_FindMsgField(arg_System,w_Kind,w_Kmk_No);
                //���א��̏ꍇ
                if IRAIMEISAICOUNTNO = w_Kmk_No then
                begin
                  //���R�[�h�敪������
                  wi_RecKbn := 0;
                  wi_RecKbn_Yakuzai := 0;
                  wi_RecKbn_Comment := 0;
                  wi_RecKbn_Schema  := 0;
                  wi_MeisaiLoop := 0;
                  //���א��̐ݒ�
                  wi_MeisaiCount := StrToIntDef(arg_TStringList[w_i - 1],0);
                  wb_Mesai_Flg := False;
                end;
              end
              //���א��ȍ~�̏ꍇ
              else
              begin
                //���׉񐔂�����ꍇ
                if (wi_MeisaiCount > 0) and
                   (wi_MeisaiLoop < wi_MeisaiCount) then
                   begin
                  //���R�[�h�敪�ݒ�
                  if not wb_Mesai_Flg then
                  begin
                    wi_RecKbn := StrToIntDef(arg_TStringList[w_i - 1],0);
                    //���M���ڂ̏��擾
                    w_StremField := func_FindMsgField(arg_System,w_Kind,IRAIYRECKBNNO);
                    //���R�[�h�敪�擾����
                    wb_Mesai_Flg := True;
                  end
                  else
                  begin
                    case wi_RecKbn of
                      //��܁E��Z�E�ޗ��E�t�B����
                      20,30,50,57:
                        begin
                          //��ԏ��߂̏ꍇ
                          if wi_RecKbn_Yakuzai = 0 then
                          begin
                            //�d�����C�A�E�g�ʒu��"���ڃR�[�h"�̈ʒu�ݒ�
                            wi_RecKbn_Yakuzai := IRAIYKMKCODENO;
                          end
                          //����ȊO�̏ꍇ
                          else
                          begin
                            //�O��Ɂ{�P
                            inc(wi_RecKbn_Yakuzai);
                          end;
                          //���M���ڂ̏��擾
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Yakuzai);
                          //"�\��"�܂ŏI�������ꍇ
                          if wi_RecKbn_Yakuzai = IRAIYYOBINO then
                          begin
                            wi_RecKbn_Yakuzai := IRAIYRECKBNNO;
                            Inc(wi_MeisaiLoop);
                            //���R�[�h�敪���擾
                            wb_Mesai_Flg := False;
                            //���׍��ڏI���̏ꍇ
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //������
                              w_Kmk_No := 0;
                              //�񐔃A�b�v
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                      //�I���E�K�{�E�t���[�R�����g
                      88,90,91,92,93,94,97,98,99:
                        begin
                          //��ԏ��߂̏ꍇ
                          if wi_RecKbn_Comment = 0 then
                          begin
                            //�d�����C�A�E�g�ʒu��"���ڃR�[�h"�̈ʒu�ݒ�
                            wi_RecKbn_Comment := IRAICKMKCODENO;
                          end
                          //����ȊO�̏ꍇ
                          else
                          begin
                            //�O��Ɂ{�P
                            inc(wi_RecKbn_Comment);
                          end;
                          //���M���ڂ̏��擾
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Comment);
                          //"�\��"�܂ŏI�������ꍇ
                          if wi_RecKbn_Comment = IRAICYOBINO then
                          begin
                            wi_RecKbn_Comment := IRAICRECKBNNO;
                            Inc(wi_MeisaiLoop);
                            //���R�[�h�敪���擾
                            wb_Mesai_Flg := False;
                            //���׍��ڏI���̏ꍇ
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //������
                              w_Kmk_No := 0;
                              //�񐔃A�b�v
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                      //�V�F�[�}
                      95:
                        begin
                          //��ԏ��߂̏ꍇ
                          if wi_RecKbn_Schema = 0 then
                          begin
                            //�d�����C�A�E�g�ʒu��"�V�F�[�}���"�̈ʒu�ݒ�
                            wi_RecKbn_Schema := IRAISNAMENO;
                          end
                          //����ȊO�̏ꍇ
                          else
                          begin
                            //�O��Ɂ{�P
                            inc(wi_RecKbn_Schema);
                          end;
                          //���M���ڂ̏��擾
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Schema);
                          //"�V�F�[�}���"�܂ŏI�������ꍇ
                          if wi_RecKbn_Schema = IRAISYOBINO then
                          begin
                            wi_RecKbn_Schema := IRAISRECKBNNO;
                            Inc(wi_MeisaiLoop);
                            //���R�[�h�敪���擾
                            wb_Mesai_Flg := False;
                            //���׍��ڏI���̏ꍇ
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //������
                              w_Kmk_No := 0;
                              //�񐔃A�b�v
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                    end;
                  end;
                end
                else
                begin
                  //�d�����C�A�E�g�ʒu��"�O���[�v�ԍ�"�̈ʒu�ݒ�
                  w_Kmk_No := IRAIGROUPNO;
                  //���M���ڂ̏��擾
                  w_StremField := func_FindMsgField(arg_System,w_Kind,w_Kmk_No);
                end;
              end;
            end;
          end
          //����ȊO�̓d��
          else
          begin
            //���M���ڂ̏��擾
            w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
          end;
        end
        else
        begin
          //���M���ڂ̏��擾
          w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
        end;
        //���[�v�J�n�ɂȂ����ꍇ
        if (IRAIMOKUTEKINO = w_i)  or
           (IRAISIJINO = w_i)      or
           (IRAISONOTANO = w_i)    or
           (IRAIBYOUMEINO = w_i)   then
           begin
          //���M���ڂ̒����擾
          w_len2 := StrToIntDef(arg_TStringList[w_i-2],0);
        end
        else
        begin
          //���M���ڂ̒����擾
          w_len2       := w_StremField.size;
        end;
        //���X�g�����񂪑��M���������傫���ꍇ
        if w_len1 >= w_len2 then
        begin
          //������ΐ؂�̂Ă�
          w_s := copy(w_s, 1,w_len2);
        end
        //����ȊO�̏ꍇ
        else
        begin
           //���Ȃ���Ε⊮����
           //���ڂ�������̏ꍇ
           if (Byte(w_StremField.x9[1]) = Byte(G_FIELD_C)) then
           begin
             //' '��⊮
             w_s := w_s + StringOfChar(' ',w_len2);
           end
           //����ȊO�̏ꍇ
           else
           begin
             //'0'��⊮
             w_s := StringOfChar('0',w_len2) + w_s;
           end;
           //���M��������m��
           w_s := copy(w_s, 1,w_len2);
        end;
        //���M�f�[�^�̏�������
        arg_TStringStream.WriteString(w_s);
      end;
      //�d�����C�A�E�g��̍ő�
      if w_MsgDeflen = w_i then
      begin
        //�����I��
        Break;
      end;
    end;
  except
    //������
    arg_TStringStream.Position := 0;
    //�����I��
    Exit;
  end;
end;
Procedure  proc_TStrListToStrm_Jissi(
           arg_TStringList   : TStringList;
           arg_TStringStream : TStringStream;
           arg_System        : string;
           arg_MsgKind       : string
           );
var
  w_i:integer;
  w_len1:integer;
  w_len2:integer;
  w_s:string;
  w_MsgDeflen:integer;
  w_RMsglen:integer;
  w_StremField : TStreamField;
  w_Kmk:integer;
  w_Kmk_Count:integer;
  w_Kmk_No:integer;
  w_Kind:String;
  wi_MeisaiLoop: Integer;
  wi_MeisaiCount: Integer;
  wi_RecKbn: Integer;
  wi_RecKbn_Yakuzai: Integer;
  wi_RecKbn_Comment: Integer;
  wi_RecKbn_Film: Integer;
  wi_RecKbn_Syugi: Integer;
  wb_Mesai_Flg: Boolean;
  wb_Kanri_Flg: Boolean;
begin
  //TStringList��TStringStream�ɓW�J
  try
    //�d����ʂ̓d���������߂�
    w_MsgDeflen := func_MsgDefLen(arg_System, arg_MsgKind);
    //�d�������Ȃ��ꍇ
    if w_MsgDeflen = 0 then
    begin
      //�����I��
      Exit;
    end;
//�d�����𒲂ׂ�
    w_RMsglen     := 0;
    //������
    w_Kmk         := 0;
    w_Kmk_Count   := 0;
    w_Kmk_No      := 0;
    wi_MeisaiCount:= 0;
    wi_MeisaiLoop := 0;
    wb_Kanri_Flg  := False;
    wb_Mesai_Flg  := False;
    wi_RecKbn     := 0;
    wi_RecKbn_Yakuzai := 0;
    wi_RecKbn_Comment := 0;
    wi_RecKbn_Film    := 0;
    wi_RecKbn_Syugi   := 0;
    w_Kind := arg_MsgKind;
    //���X�g�������[�v
    for w_i := 1 to arg_TStringList.Count do
    begin
      //���X�g������̒����擾
      w_len1       := length(arg_TStringList[w_i-1]);
      //���{���d���̏ꍇ
      if w_Kind = G_MSGKIND_JISSI then
      begin
        case w_i of
          //�O���[�v������
          CST_JISSI_LOOPSTART:
          begin
            //�O���[�v�����ڂ����l�̏ꍇ
            if func_IsNumber(arg_TStringList[w_i-1]) then
            begin
              //�O���[�v�����ڎ擾
              w_Kmk := StrToInt(arg_TStringList[w_i-1]);
            end
            else
            begin
              //�O���[�v�����ڂȂ�
              w_Kmk := 0;
            end;
            //���ڂ̍ő吔�ȏ�̏ꍇ
            if w_Kmk > CST_GROUP_LOOP_MAX then
            begin
              //���ڂ̍ő吔�ɐݒ�
              w_Kmk := CST_GROUP_LOOP_MAX;
            end;
          end;
        end;
        //���[�v�J�n�ɂȂ����ꍇ(�O���[�v�ԍ�)
        if JISSIGROUPNO <= w_i then
        begin
          //���ڌ�������ꍇ
          if w_Kmk > 0 then
          begin
            //�J��Ԃ����O���[�v���ɒB����܂�
            if w_Kmk_Count <= w_Kmk then
            begin
              //�O���[�v�ԍ��`���א��܂�
              if JISSIMEISAICOUNTNO > w_Kmk_No then
              begin
                //��ԏ��߂̏ꍇ
                if w_Kmk_No = 0 then
                begin
                  if w_Kmk_Count = 0 then
                    //������
                    w_Kmk_Count := 1;
                  //�d�����C�A�E�g�ʒu��"�O���[�v�ԍ�"�̈ʒu�ݒ�
                  w_Kmk_No := JISSIGROUPNO;
                end
                //�ȊO�̏ꍇ
                else
                begin
                  //�O��Ɂ{�P
                  inc(w_Kmk_No);
                end;
                //���M���ڂ̏��擾
                w_StremField := func_FindMsgField(arg_System,w_Kind,w_Kmk_No);
                //���א��̏ꍇ
                if JISSIMEISAICOUNTNO = w_Kmk_No then
                begin
                  //���R�[�h�敪������
                  wi_RecKbn := 0;
                  wi_RecKbn_Yakuzai := 0;
                  wi_RecKbn_Comment := 0;
                  wi_RecKbn_Film    := 0;
                  wi_RecKbn_Syugi   := 0;
                  wi_MeisaiLoop := 0;
                  //���א��̐ݒ�
                  wi_MeisaiCount := StrToIntDef(arg_TStringList[w_i - 1],0);
                  wb_Kanri_Flg := False;
                  wb_Mesai_Flg := False;
                end;
              end
              //���א��ȍ~�̏ꍇ
              else
              begin
                //���׉񐔂�����ꍇ
                if (wi_MeisaiCount > 0) and
                   (wi_MeisaiLoop < wi_MeisaiCount) then
                  begin
                  if not wb_Mesai_Flg then
                  begin
                    //���R�[�h�敪�ݒ�
                    wi_RecKbn := StrToIntDef(arg_TStringList[w_i - 1],0);
                    //���M���ڂ̏��擾
                    w_StremField := func_FindMsgField(arg_System,w_Kind,JISSIYRECORDKBNNO);
                    //���R�[�h�敪�擾����
                    wb_Mesai_Flg := True;
                  end
                  else
                  begin
                    case wi_RecKbn of
                      //���
                      20,30,50,57:
                        begin
                          //��ԏ��߂̏ꍇ
                          if wi_RecKbn_Yakuzai = 0 then
                          begin
                            //�d�����C�A�E�g�ʒu��"���͋敪"�̈ʒu�ݒ�
                            wi_RecKbn_Yakuzai := JISSIYKMKCODENO;
                          end
                          //����ȊO�̏ꍇ
                          else
                          begin
                            //�O��Ɂ{�P
                            inc(wi_RecKbn_Yakuzai);
                          end;
                          //���M���ڂ̏��擾
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Yakuzai);
                          //"�\��"�܂ŏI�������ꍇ
                          if wi_RecKbn_Yakuzai = JISSIYYOBINO then
                          begin
                            wi_RecKbn_Yakuzai := JISSIYRECORDKBNNO;
                            Inc(wi_MeisaiLoop);
                            //���R�[�h�敪���擾
                            wb_Mesai_Flg := False;
                            //�Ǘ��ԍ����擾
                            wb_Kanri_Flg := False;
                            //���׍��ڏI���̏ꍇ
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //������
                              w_Kmk_No := 0;
                              //�񐔃A�b�v
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                      //�I���E�K�{�E�t���[�R�����g
                      88,90,91,92,93,94,97,98,99:
                        begin
                          //��ԏ��߂̏ꍇ
                          if wi_RecKbn_Comment = 0 then
                          begin
                            //�d�����C�A�E�g�ʒu��"���͋敪"�̈ʒu�ݒ�
                            wi_RecKbn_Comment := JISSICKMKCODENO;
                          end
                          //����ȊO�̏ꍇ
                          else
                          begin
                            //�O��Ɂ{�P
                            inc(wi_RecKbn_Comment);
                          end;
                          //���M���ڂ̏��擾
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Comment);
                          //"�\��"�܂ŏI�������ꍇ
                          if wi_RecKbn_Comment = JISSICYOBINO then
                          begin
                            wi_RecKbn_Comment := JISSICRECORDKBNNO;
                            Inc(wi_MeisaiLoop);
                            //���R�[�h�敪���擾
                            wb_Mesai_Flg := False;
                            //�Ǘ��ԍ����擾
                            wb_Kanri_Flg := False;
                            //���׍��ڏI���̏ꍇ
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //������
                              w_Kmk_No := 0;
                              //�񐔃A�b�v
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                    end;
                  end;
                end
                else
                begin
                  //�d�����C�A�E�g�ʒu��"�O���[�v�ԍ�"�̈ʒu�ݒ�
                  w_Kmk_No := JISSIGROUPNO;
                end;
              end;
            end;
          end;
        end
        else
        begin
          //���M���ڂ̏��擾
          w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
        end;
      end
      else
      begin
        //���M���ڂ̏��擾
        w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
      end;
      //���M���ڂ̒����擾
      w_len2       := w_StremField.size;
      //���X�g������̂�著�M���ڂ̒������������ꍇ
      if w_len1 >= w_len2 then
      begin
        //�ݒ�
        w_RMsglen := w_RMsglen + w_len2;
      end
      //����ȊO�̏ꍇ
      else
      begin
        //�ݒ�
        w_RMsglen := w_RMsglen + w_len2;
      end;
      //�d�����C�A�E�g��̍ő�
      if w_MsgDeflen = w_i then
      begin
        //�����I��
        Break;
      end;
    end;
    //�ꃉ�C�����W�J
    arg_TStringStream.Position := 0;
    //������
    w_Kmk_Count  := 0;
    w_Kmk_No := 0;
    //���X�g�������[�v
    for w_i := 1 to arg_TStringList.Count do
    begin
      //�d�������ڂ̏ꍇ
      if w_i = COMMON1DENLENNO then
      begin
        //�T�C�Y�ݒ�
        w_s := FormatFloat('000000', w_RMsglen);
        //�d�������ڏ�������
        arg_TStringStream.WriteString(w_s);
      end
      //����ȊO�̍��ڂ̏ꍇ
      else
      begin
        //������擾
        w_s          := arg_TStringList[w_i-1];
        //���M�����񒷎擾
        w_len1       := length( w_s );
        //���[�v�J�n�ɂȂ����ꍇ(�O���[�v�ԍ�)
        if JISSIGROUPNO <= w_i then
        begin
          //���ڌ�������ꍇ
          if w_Kmk > 0 then
          begin
            //�J��Ԃ����O���[�v���ɒB����܂�
            if w_Kmk_Count <= w_Kmk then
            begin
              //�O���[�v�ԍ��`���א��܂�
              if JISSIMEISAICOUNTNO > w_Kmk_No then
              begin
                //��ԏ��߂̏ꍇ
                if w_Kmk_No = 0 then
                begin
                  if w_Kmk_Count = 0 then
                    //������
                    w_Kmk_Count := 1;
                  //�d�����C�A�E�g�ʒu��"�O���[�v�ԍ�"�̈ʒu�ݒ�
                  w_Kmk_No := JISSIGROUPNO;
                end
                //�ȊO�̏ꍇ
                else
                begin
                  //�O��Ɂ{�P
                  inc(w_Kmk_No);
                end;
                //���M���ڂ̏��擾
                w_StremField := func_FindMsgField(arg_System,w_Kind,w_Kmk_No);
                //���א��̏ꍇ
                if IRAIMEISAICOUNTNO = w_Kmk_No then
                begin
                  //���R�[�h�敪������
                  wi_RecKbn := 0;
                  wi_RecKbn_Yakuzai := 0;
                  wi_RecKbn_Comment := 0;
                  wi_RecKbn_Film    := 0;
                  wi_RecKbn_Syugi   := 0;
                  wi_MeisaiLoop := 0;
                  //���א��̐ݒ�
                  wi_MeisaiCount := StrToIntDef(arg_TStringList[w_i - 1],0);
                  wb_Kanri_Flg := False;
                  wb_Mesai_Flg := False;
                end;
              end
              //���א��ȍ~�̏ꍇ
              else
              begin
                //���׉񐔂�����ꍇ
                if (wi_MeisaiCount > 0) and
                   (wi_MeisaiLoop < wi_MeisaiCount) then
                   begin
                  if not wb_Mesai_Flg then
                  begin
                    //���R�[�h�敪�ݒ�
                    wi_RecKbn := StrToIntDef(arg_TStringList[w_i - 1],0);
                    //���M���ڂ̏��擾
                    w_StremField := func_FindMsgField(arg_System,w_Kind,JISSIYRECORDKBNNO);
                    //���R�[�h�敪�擾����
                    wb_Mesai_Flg := True;
                  end
                  else
                  begin
                    case wi_RecKbn of
                      //���
                      20,30,50,57:
                        begin
                          //��ԏ��߂̏ꍇ
                          if wi_RecKbn_Yakuzai = 0 then
                          begin
                            //�d�����C�A�E�g�ʒu��"���͋敪"�̈ʒu�ݒ�
                            wi_RecKbn_Yakuzai := JISSIYKMKCODENO;
                          end
                          //����ȊO�̏ꍇ
                          else
                          begin
                            //�O��Ɂ{�P
                            inc(wi_RecKbn_Yakuzai);
                          end;
                          //���M���ڂ̏��擾
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Yakuzai);
                          //"�\��"�܂ŏI�������ꍇ
                          if wi_RecKbn_Yakuzai = JISSIYYOBINO then
                          begin
                            wi_RecKbn_Yakuzai := JISSIYRECORDKBNNO;
                            Inc(wi_MeisaiLoop);
                            //���R�[�h�敪���擾
                            wb_Mesai_Flg := False;
                            //�Ǘ��ԍ����擾
                            wb_Kanri_Flg := False;
                            //���׍��ڏI���̏ꍇ
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //������
                              w_Kmk_No := 0;
                              //�񐔃A�b�v
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                      //�I���E�K�{�E�t���[�R�����g
                      88,90,91,92,93,94,97,98,99:
                        begin
                          //��ԏ��߂̏ꍇ
                          if wi_RecKbn_Comment = 0 then
                          begin
                            //�d�����C�A�E�g�ʒu��"���͋敪"�̈ʒu�ݒ�
                            wi_RecKbn_Comment := JISSICKMKCODENO;
                          end
                          //����ȊO�̏ꍇ
                          else
                          begin
                            //�O��Ɂ{�P
                            inc(wi_RecKbn_Comment);
                          end;
                          //���M���ڂ̏��擾
                          w_StremField := func_FindMsgField(arg_System,w_Kind,wi_RecKbn_Comment);
                          //"�\��"�܂ŏI�������ꍇ
                          if wi_RecKbn_Comment = JISSICYOBINO then
                          begin
                            wi_RecKbn_Comment := JISSICRECORDKBNNO;
                            Inc(wi_MeisaiLoop);
                            //���R�[�h�敪���擾
                            wb_Mesai_Flg := False;
                            //�Ǘ��ԍ����擾
                            wb_Kanri_Flg := False;
                            //���׍��ڏI���̏ꍇ
                            if wi_MeisaiLoop = wi_MeisaiCount then begin
                              //������
                              w_Kmk_No := 0;
                              //�񐔃A�b�v
                              inc(w_Kmk_Count);
                            end;
                          end;
                        end;
                    end;
                  end;
                end
                else
                begin
                  //�d�����C�A�E�g�ʒu��"�O���[�v�ԍ�"�̈ʒu�ݒ�
                  w_Kmk_No := IRAIGROUPNO;
                end;
              end;
            end;
          end
          //����ȊO�̓d��
          else
          begin
            //���M���ڂ̏��擾
            w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
          end;
        end
        else
        begin
          //���M���ڂ̏��擾
          w_StremField := func_FindMsgField(arg_System,w_Kind,w_i);
        end;
        //���M���ڂ̒����擾
        w_len2       := w_StremField.size;
        //���X�g�����񂪑��M���������傫���ꍇ
        if w_len1 >= w_len2 then
        begin
          //������ΐ؂�̂Ă�
          w_s := copy(w_s, 1,w_len2);
        end
        //����ȊO�̏ꍇ
        else
        begin
           //���Ȃ���Ε⊮����
           //���ڂ�������̏ꍇ
           if (Byte(w_StremField.x9[1]) = Byte(G_FIELD_C)) then
           begin
             //' '��⊮
             w_s := w_s + StringOfChar(' ',w_len2);
           end
           //����ȊO�̏ꍇ
           else
           begin
             //'0'��⊮
             w_s := StringOfChar('0',w_len2) + w_s;
           end;
           //���M��������m��
           w_s := copy(w_s, 1,w_len2);
        end;
        //���M�f�[�^�̏�������
        arg_TStringStream.WriteString(w_s);
      end;
      //�d�����C�A�E�g��̍ő�
      if w_MsgDeflen = w_i then
      begin
        //�����I��
        Break;
      end;
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
  ���O : proc_TStrListToStrm2;
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
           arg_TStringStream : TStringStream;
           arg_System        : string;
           arg_MsgKind       : string
           );
var
  w_i:integer;
  w_len1:integer;
  w_s:string;
  //w_i2:Double;
begin
  //TStringList��TStringStream�ɓW�J
  try
    //������
    w_len1 := 0;
    //���X�g�������[�v
    for w_i := 0 to arg_TStringList.Count - 1 do begin
      //�ꃉ�C�����W�J
      arg_TStringStream.Position := w_len1;
      //�f�[�^�̎擾
      w_s := arg_TStringList[w_i];
      if w_i = 2 then begin
        if w_s = '00' then begin
          w_S := Chr($00) + Chr($00);
        end
        else begin
          w_S := Chr($FF) + Chr($FF);
        end;
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
      result.f_Retry :=
            func_IniReadInt(
                               arg_Ini,
                               g_C_SOCKET_SECSION + arg_No,
                               g_SOCKET_RetryCount_KEY,
                               g_SOCKET_RetryCount);
      {

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
      }
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
      {
      result.f_Port :=
            func_IniReadString(
                               arg_Ini,
                               g_S_SOCKET_SECSION + arg_No,
                               g_SOCKET_PORT_KEY,
                               g_SOCKET_PORT);
      }
end;
//���@�\ INI�t�@�C���̓Ǎ���
//�����F����
//��O�F����
//���A�l�FTrue False
function func_TcpReadiniFile: Boolean;
var
  w_ini:      TIniFile;
  wkInteger:  Integer;
begin
  Result:=True;
  try
    w_ini:=TIniFile.Create(g_TcpIniPath + G_TCPINI_FNAME);
    try
      //SERVICE���
      g_Svc_Sd_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RESDACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Sd_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RESDCYCLE_KEY,
                               g_SVC_SDCYCLE);
      g_Svc_Rv_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_ORRVACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Rv_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_ORRVCYCLE_KEY,
                               g_SVC_RVCYCLE);
      g_Svc_Ex_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_EXSDACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Ex_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_EXSDCYCLE_KEY,
                               g_SVC_SDCYCLE);
      g_Svc_Shema_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_SHEMAACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Shema_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_SHEMACYCLE_KEY,
                               g_SVC_SDCYCLE);
(*
      g_Svc_Ka_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_KARVACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Ka_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_KARVCYCLE_KEY,
                               g_SVC_RVCYCLE);
      g_Svc_Rs_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RSSDACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_Svc_Rs_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RSSDCYCLE_KEY,
                               g_SVC_SDCYCLE);
*)
      //DB���
      //�f�f
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
      g_RisDB_SndExKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_SNDEXKEEP_KEY,
                               g_DB_SNDKEEP);
      g_RisDB_RcvKaKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_RCVKAKEEP_KEY,
                               g_DB_RCVKEEP);
      g_RisDB_SndRsKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_SNDRSKEEP_KEY,
                               g_DB_SNDKEEP);
      g_RisDB_ShemaKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_SHEMAKEEP_KEY,
                               g_DB_SNDKEEP);

(*
      g_RTRisDB_Name :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_RTDB_NAME_KEY,
                               g_DB_NAME);
      g_RTRisDB_Uid :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_RTDB_UID_KEY,
                               g_DB_UID);
      g_RTRisDB_Pas :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_RTDB_PAS_KEY,
                               g_DB_PAS);
*)

      //�\�P�b�g���
      g_C_Socket_Info_01:=func_ReadiniCInfo(w_ini,'1');
      g_C_Socket_Info_02:=func_ReadiniCInfo(w_ini,'2');
      g_C_Socket_Info_03:=func_ReadiniCInfo(w_ini,'3');
      g_C_Socket_Info_04:=func_ReadiniCInfo(w_ini,'4');
      g_C_Socket_Info_05:=func_ReadiniCInfo(w_ini,'5');
      g_S_Socket_Info_01:=func_ReadiniSInfo(w_ini,'1');
      g_S_Socket_Info_02:=func_ReadiniSInfo(w_ini,'2');
      g_S_Socket_Info_03:=func_ReadiniSInfo(w_ini,'3');
      g_S_Socket_Info_04:=func_ReadiniSInfo(w_ini,'4');
      g_S_Socket_Info_05:=func_ReadiniSInfo(w_ini,'5');
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
      //2018/08/30 ���O�t�@�C���ύX
      g_LogFileSize:= func_IniReadInt(
                               w_ini,
                               g_LOG_SECSION,
                               'FileSize',
                               '2000');
      //Kb �� 1,000�{
      g_LogFileSize:= g_LogFileSize * 1000;                               

      //�Z�N�V�����FDB���O���
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG01_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG01_LOGGING := True;
      g_DBLOG01_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG01_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG01_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);
      //�Z�N�V�����FDB���O���
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG02_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG02_LOGGING := True;
      g_DBLOG02_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG02_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG02_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);
      //�Z�N�V�����FDB���O���
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG03_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG03_LOGGING := True;
      g_DBLOG03_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG03_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG03_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);
      //�Z�N�V�����FDB���O���
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG04_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG04_LOGGING := True;
      g_DBLOG04_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG04_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG04_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);

      //�Z�N�V�����FDB�f�o�b�O���
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG01_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG01_LOGGING := True;
      g_DBLOGDBG01_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG01_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG01_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);
      //�Z�N�V�����FDB�f�o�b�O���
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG02_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG02_LOGGING := True;
      g_DBLOGDBG02_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG02_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG02_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);
      //�Z�N�V�����FDB�f�o�b�O���
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG03_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG03_LOGGING := True;
      g_DBLOGDBG03_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG03_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG03_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);
      //�Z�N�V�����FDB�f�o�b�O���
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG04_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG04_LOGGING := True;
      g_DBLOGDBG04_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG04_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG04_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);

      g_RomaFlg_1 :=
            func_IniReadInt(
                               w_ini,
                               g_ROMA_SECSION,
                               g_ROMA_1_KEY,
                               g_ROMA_1_DEF);
      g_RomaFlg_2 :=
            func_IniReadInt(
                               w_ini,
                               g_ROMA_SECSION,
                               g_ROMA_2_KEY,
                               g_ROMA_2_DEF);
      g_RomaFlg_3 :=
            func_IniReadInt(
                               w_ini,
                               g_ROMA_SECSION,
                               g_ROMA_3_KEY,
                               g_ROMA_3_DEF);
      g_RomaFlg_4 :=
            func_IniReadInt(
                               w_ini,
                               g_ROMA_SECSION,
                               g_ROMA_4_KEY,
                               g_ROMA_4_DEF);

      proc_ReadiniKenzo(w_ini,g_KanjaJyoutai);
      proc_ReadiniFlg(w_ini);
      proc_ReadiniType(w_ini);

      g_RIOrder :=
            func_IniReadString(
                               w_ini,
                               g_RIORDER_SECSION,
                               g_RIORDER_KEY,
                               g_RIORDER_DEF);

(*
      g_RISType_List := TStringList.Create;

      g_RISType_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_TYPE_SECSION,
                               g_TYPEO1_KEY,
                               '');

      g_TheraRisType_List := TStringList.Create;

      g_TheraRisType_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_TYPE_SECSION,
                               g_TYPEO2_KEY,
                               '');

      g_Report_List := TStringList.Create;

      g_Report_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_TYPE_SECSION,
                               g_TYPEO3_KEY,
                               '');

      g_RRISUser :=
            func_IniReadString(
                               w_ini,
                               g_RRIS_SECSION,
                               g_RRIS_KEY,
                               g_RRIS_DEF);
      g_RTRISUser :=
            func_IniReadString(
                               w_ini,
                               g_RTRIS_SECSION,
                               g_RTRIS_KEY,
                               g_RTRIS_DEF);
*)

      g_NotesMake_Kangokbn_List := TStringList.Create;

      g_NotesMake_Kangokbn_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_NOTESMARK_SECSION,
                               g_KANGOKBN_KEY,
                               '');

      g_NotesMake_Kanjakbn_List := TStringList.Create;

      g_NotesMake_Kanjakbn_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_NOTESMARK_SECSION,
                               g_KANJAKBN_KEY,
                               '');

      //2007.07.04
      g_KOUMOKU_CODE :=
            func_IniReadString(
                               w_ini,
                               g_KOUMOKU_CODE_SECSION,
                               g_KOUMOKUCODE_KEY,
                               g_DEFKOUMOKUCODE);
      //2007.07.04
      g_NOT_ACCOUNT :=
            func_IniReadString(
                               w_ini,
                               g_KOUMOKU_CODE_SECSION,
                               g_NOT_ACCOUNT_KEY,
                               g_DEFNOT_ACCOUNT);
      //2007.07.04
      g_MESAI_KOUMOKU_CODE :=
            func_IniReadString(
                               w_ini,
                               g_MEISAI_CODE_SECSION,
                               g_MEISAICODE_KEY,
                               g_DEFMEISAICODE);
      //2007.07.04
      g_MESAI_NOT_ACCOUNT :=
            func_IniReadString(
                               w_ini,
                               g_MEISAI_CODE_SECSION,
                               g_MEISAINOT_ACCOUNT_KEY,
                               g_DEFMEISAINOT_ACCOUNT);


      g_HIS_List := TStringList.Create;

      g_HIS_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_HIS_SECSION,
                               g_HIS_ID_KEY,
                               '');

      g_SHEMA_HIS_PASS :=
            func_IniReadString(
                               w_ini,
                               g_SHEMA_SECSION,
                               g_SHEMA_HIS_KEY,
                               '');
      g_SHEMA_HIS_PASS := IncludeTrailingPathDelimiter(g_SHEMA_HIS_PASS);

      g_SHEMA_LOCAL_PASS :=
            func_IniReadString(
                               w_ini,
                               g_SHEMA_SECSION,
                               g_SHEMA_LOCAL_KEY,
                               '');
      //INI�t�@�C���Ɠ����ꏊ
      if not(DirectoryExists(g_SHEMA_LOCAL_PASS)) then
         g_SHEMA_LOCAL_PASS := g_TcpIniPath;

      g_SHEMA_LOCAL_PASS := IncludeTrailingPathDelimiter(g_SHEMA_LOCAL_PASS);

      g_SHEMA_HTML_PASS :=
            func_IniReadString(
                               w_ini,
                               g_SHEMA_SECSION,
                               g_SHEMA_HTML_KEY,
                               '');
      //INI�t�@�C���Ɠ����ꏊ
      if not(DirectoryExists(g_SHEMA_HTML_PASS)) then
         g_SHEMA_HTML_PASS := g_TcpIniPath;

      g_SHEMA_HTML_PASS := IncludeTrailingPathDelimiter(g_SHEMA_HTML_PASS);
      //2008.09.12 ---
      g_LOGONPASS :=
            func_IniReadString(
                               w_ini,
                               g_SHEMA_SECSION,
                               g_LOGONPASS_KEY,
                               '');
      g_LOGONUSER :=
            func_IniReadString(
                               w_ini,
                               g_SHEMA_SECSION,
                               g_LOGONUSER_KEY,
                               '');
      g_LOGONRETRY :=
            func_IniReadInt(
                               w_ini,
                               g_SHEMA_SECSION,
                               g_LOGONRETRY_KEY,
                               '0');
(*
      //--- 2008.09.12
      g_ENTRY_USER :=
            func_IniReadString(
                               w_ini,
                               g_ENTRY_SECSION,
                               g_ENTRY_USER_KEY,
                               g_ENTRY_USER_DEF);
      g_ENTRY_USERNAME :=
            func_IniReadString(
                               w_ini,
                               g_ENTRY_SECSION,
                               g_ENTRY_USERNAME_KEY,
                               g_ENTRY_USERNAME_DEF);
*)
    finally
      w_ini.Free;
    end;
  exit;
  except
    Result:=False;
    exit;
  end;

end;
//���@�\ INI�t�@�C���̓Ǎ���
//�����F����
//��O�F����
//���A�l�FTrue False
function func_RTTcpReadiniFile: Boolean;
var
  w_ini:      TIniFile;
  wkInteger:  Integer;
begin
  Result:=True;
  try
    w_ini:=TIniFile.Create(g_TcpIniPath + G_RTTCPINI_FNAME);
    try
      //SERVICE���
      g_RTSvc_Ex_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_EXSDACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_RTSvc_Ex_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_EXSDCYCLE_KEY,
                               g_SVC_SDCYCLE);
      g_RTSvc_Re_Acvite :=
            func_IniReadString(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RESDACTIVE_KEY,
                               g_SVC_ACTIVE);
      g_RTSvc_Re_Cycle :=
            func_IniReadInt(
                               w_ini,
                               g_C_SVC_SECSION,
                               g_SVC_RESDCYCLE_KEY,
                               g_SVC_RVCYCLE);
      //DB���
(*
      g_RTRisDB_Name :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_RTDB_NAME_KEY,
                               g_DB_NAME);
      g_RTRisDB_Uid :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_RTDB_UID_KEY,
                               g_DB_UID);
      g_RTRisDB_Pas :=
            func_IniReadString(
                               w_ini,
                               g_C_DB_SECSION,
                               g_RTDB_PAS_KEY,
                               g_DB_PAS);
*)

      g_RisDB_Retry :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_RETRY_KEY,
                               g_DB_RETRY);
      g_RTRisDB_SndEXKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_SNDEXKEEP_KEY,
                               g_DB_SNDKEEP);
      g_RTRisDB_ReKeep :=
            func_IniReadInt(
                               w_ini,
                               g_C_DB_SECSION,
                               g_DB_SNDREKEEP_KEY,
                               g_DB_SNDKEEP);
      //�\�P�b�g���
      g_C_RTSocket_Info_01:=func_ReadiniCInfo(w_ini,'1');
      g_C_RTSocket_Info_02:=func_ReadiniCInfo(w_ini,'2');
      g_S_RTSocket_Info_01:=func_ReadiniSInfo(w_ini,'1');
      g_S_RTSocket_Info_02:=func_ReadiniSInfo(w_ini,'2');
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

      //�Z�N�V�����FDB���O���
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG01_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG01_LOGGING := True;
      g_DBLOG01_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG01_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG01_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG01_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);
      //�Z�N�V�����FDB���O���
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG02_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG02_LOGGING := True;
      g_DBLOG02_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG02_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG02_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG02_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);
      //�Z�N�V�����FDB���O���
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG03_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG03_LOGGING := True;
      g_DBLOG03_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG03_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG03_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG03_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);
      //�Z�N�V�����FDB���O���
      wkInteger   :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_LOGGING_KEY,
                               g_DBLOG_LOGGING_DEF);
      g_DBLOG04_LOGGING := False;
      if wkInteger = 1 Then g_DBLOG04_LOGGING := True;
      g_DBLOG04_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_PATH_KEY,
                               g_DBLOG_PATH_DEF);
      g_DBLOG04_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_PREFIX_KEY,
                               g_DBLOG_PREFIX_DEF);
      g_DBLOG04_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOG04_SECTION,
                               g_DBLOG_KEEPDAYS_KEY,
                               g_DBLOG_KEEPDAYS_DEF);

      //�Z�N�V�����FDB�f�o�b�O���
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG01_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG01_LOGGING := True;
      g_DBLOGDBG01_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG01_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG01_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG01_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);
      //�Z�N�V�����FDB�f�o�b�O���
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG02_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG02_LOGGING := True;
      g_DBLOGDBG02_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG02_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG02_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG02_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);
      //�Z�N�V�����FDB�f�o�b�O���
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG03_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG03_LOGGING := True;
      g_DBLOGDBG03_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG03_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG03_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG03_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);
      //�Z�N�V�����FDB�f�o�b�O���
      wkInteger :=
            func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_LOGGING_KEY,
                               g_DBLOGDBG_LOGGING_DEF);
      g_DBLOGDBG04_LOGGING := False;
      if wkInteger = 1 Then g_DBLOGDBG04_LOGGING := True;
      g_DBLOGDBG04_PATH      :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_PATH_KEY,
                               g_DBLOGDBG_PATH_DEF);
      g_DBLOGDBG04_PREFIX    :=
            func_IniReadString(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_PREFIX_KEY,
                               g_DBLOGDBG_PREFIX_DEF);
      g_DBLOGDBG04_KEEPDAYS  :=
          func_IniReadInt(
                               w_ini,
                               g_DBLOGDBG04_SECTION,
                               g_DBLOGDBG_KEEPDAYS_KEY,
                               g_DBLOGDBG_KEEPDAYS_DEF);

      {
      g_RISType_List := TStringList.Create;

      g_RISType_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_TYPE_SECSION,
                               g_TYPEO1_KEY,
                               '');

      g_TheraRisType_List := TStringList.Create;

      g_TheraRisType_List.CommaText :=
            func_IniReadString(
                               w_ini,
                               g_TYPE_SECSION,
                               g_TYPEO2_KEY,
                               '');
      }
(*
      g_RRISUser :=
            func_IniReadString(
                               w_ini,
                               g_RRIS_SECSION,
                               g_RRIS_KEY,
                               g_RRIS_DEF);
      g_RTRISUser :=
            func_IniReadString(
                               w_ini,
                               g_RTRIS_SECSION,
                               g_RTRIS_KEY,
                               g_RTRIS_DEF);
*)

      g_HIS_TYPE :=
            func_IniReadString(
                               w_ini,
                               g_HIS_TYPE_SECSION,
                               g_HIS_TYPE_KEY,
                               g_HIS_TYPE_DEF);

      g_HIS_KOUMOKU :=
            func_IniReadString(
                               w_ini,
                               g_HIS_KOUMOKU_SECSION,
                               g_HIS_KOUMOKU_KEY,
                               g_HIS_KOUMOKU_DEF);

      g_HIS_BUI :=
            func_IniReadString(
                               w_ini,
                               g_HIS_BUI_SECSION,
                               g_HIS_BUI_KEY,
                               g_HIS_BUI_DEF);

      g_ONCALL_AM :=
            func_IniReadString(
                               w_ini,
                               g_ONCALL_SECSION,
                               g_ONCALL_AM_KEY,
                               g_ONCALL_AM_DEF);
      g_ONCALL_PM :=
            func_IniReadString(
                               w_ini,
                               g_ONCALL_SECSION,
                               g_ONCALL_PM_KEY,
                               g_ONCALL_PM_DEF);

      g_HIS_EXSECTION :=
            func_IniReadString(
                               w_ini,
                               g_HIS_EXSECTION_SECSION,
                               g_HIS_EXSECTION_KEY,
                               g_HIS_EXSECTION_DEF);
      g_HIS_EXDR :=
            func_IniReadString(
                               w_ini,
                               g_HIS_EXSECTION_SECSION,
                               g_HIS_EXDR_KEY,
                               g_HIS_EXDR_DEF);

      g_COM_TITLE1 :=
            func_IniReadString(
                               w_ini,
                               g_HIS_EXCOMTITLE_SECSION,
                               g_HIS_TITLE1_KEY,
                               g_HIS_TITLE1_DEF);
      g_COM_TITLE2 :=
            func_IniReadString(
                               w_ini,
                               g_HIS_EXCOMTITLE_SECSION,
                               g_HIS_TITLE2_KEY,
                               g_HIS_TITLE2_DEF);
    finally
      w_ini.Free;
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
  buffer: string;
  fp: TextFile;
  wd_DateTime: TDateTime;
  wd_FileDateTime: TDateTime;
begin
  // ���O�������̏ꍇ�́A�������Ȃ��B
  if g_Rig_LogActive = g_SOCKET_LOGDEACTIVE then
    Exit;
  // NG�̂ݏo�͂�
  // �X�e�[�^�X��NG�ȊO�̏ꍇ�͉������Ȃ�
  if (g_Rig_LogActive = g_SOCKET_LOGACTIVE2) and
     (arg_Status <> G_LOG_LINE_HEAD_NG)      then
    Exit;
  try
    //���ݎ��Ԃ̎擾
    wd_DateTime := Now;
    //�t�@�C�����̍쐬
    w_LogFile := g_Rig_LogPath + g_LogPlefix + FormatDateTime('dd', wd_DateTime) + G_LOG_PKT_PTH_DEF;
    //�����̕⊮
    if func_IsNullStr(arg_Time) then
      arg_Time:=FormatDateTime('yyyy/mm/dd hh:mm:ss', Now);
    //�o�̓��b�Z�[�W�\��
    buffer := arg_Status + ',' + arg_Time + ',' + arg_Operate;

    //2018/08/30 ���O�t�@�C���ύX
    FLog.LOGOUT(buffer);
  except
    exit;
  end;
end;
//���O������쐬
function  func_LogStr(arg_Kind:integer; arg_Diteil:string): string;
var
  w_s:string;
begin
  //���O��ʂŎw�肳�ꂽ��������擾
  w_s := g_Log_Type[arg_Kind].f_LogMsg + StringOfChar(chr($20),G_LOGGMSG_LEN);
  //������𐮂���
  w_s := func_BCopy(w_s,G_LOGGMSG_LEN);
  //�t�ѕ�����Ƒg�ݍ��킹��
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
    //���O������{�t�ѕ�����
    w_s := func_LogStr(arg_Kind,arg_Diteil);
    //ini�t�@�C���̃��O���x�������O���e��ʈȏ�̏ꍇ
    if (g_Log_Type[arg_Kind].f_LogLevel <= StrToIntDef(g_Rig_LogLevel,0)) then begin
      //���O�o��
      proc_LogOperate(arg_Status,arg_Time,w_s);
    end;
  except
    //�����I��
    Exit;
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
    wkBuf := TrimRight(func_BCopy(EditStr,intCapa));
    if Length(wkBuf) < intCapa then
    begin
      wkBuf := wkBuf + chr(32);
    end;
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

procedure proc_Change_Byte(var arg_Length: String);
var
  Mdp: String Absolute arg_Length;
  w_s1,w_s2,w_s3,w_s4,w_s5:String;
begin
  w_s1 := '0';
  w_s2 := '0';
  w_s3 := '0';
  w_s4 := '0';
  w_s5 := '0';

  w_s1 := Copy(Mdp,1,1);
  w_s2 := Copy(Mdp,2,1);
  w_s3 := Copy(Mdp,3,1);
  w_s4 := Copy(Mdp,4,1);
  w_s5 := Copy(Mdp,5,1);

  Mdp := w_s5 + w_s4 + w_s3 + w_s2 + w_s1;
end;
(**
��HIS�`�[�R�[�h����Ή�����RIS������ʂ���������
�����F
  arg_HisID : String; HIS�`�[�R�[�h
��O�F����
���A�l�FRIS������ʁ@String
**)
function func_HisToRis(arg_HisID:String):String;
var
  w_Kensa:String;
  w_i:Integer;
begin
  //������
  w_Kensa := '';
  //�����ݒ�t�@�C���ɂ���`�[�R�[�h��
  for w_i := 0 to Length(g_Kensa_ID) - 1 do begin
    //�����`�[�R�[�h���������ꍇ
    if arg_HisID = g_Kensa_ID[w_i].f_HIS_ID then
      //RIS������ʂɕϊ�
      w_Kensa := g_Kensa_ID[w_i].f_RIS_ID;
  end;
  //������ʕϊ�
  Result := w_Kensa;
end;
(**
��RIS������ʂ���Ή�����HIS�`�[�R�[�h����������
�����F
  arg_RisID : String; RIS�������
��O�F����
���A�l�FHIS�`�[�R�[�h�@String
**)
function func_RisToHis(arg_RisID:String):String;
var
  w_Kensa:String;
  w_i:Integer;
begin
  //������
  w_Kensa := '';
  //�����ݒ�t�@�C���ɂ���`�[�R�[�h��
  for w_i := 0 to Length(g_Kensa_ID) - 1 do begin
    //����������ʂ��������ꍇ
    if arg_RisID = g_Kensa_ID[w_i].f_RIS_ID then
      //�`�[�R�[�h�ɕϊ�
      w_Kensa := g_Kensa_ID[w_i].f_HIS_ID;
  end;
  //�`�[�R�[�h�ϊ�
  Result := w_Kensa;
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
                           var arg_Kanja:TStrings
                           );
var
  w_i:Integer;
  w_Pos:Integer;
begin

  arg_Kanja := TStringList.Create;

  arg_Ini.ReadSectionValues(g_KANJA_SECSION,arg_Kanja);

  for w_i := 0 to arg_Kanja.Count - 1 do begin
    w_Pos := Pos('=',arg_Kanja[w_i]);
    if w_Pos <> 0 then begin
      arg_Kanja[w_i] := Copy(arg_Kanja[w_i],w_Pos + 1,Length(arg_Kanja[w_i]));
    end;
  end;
end;
(**
���t���O��񕔕��̓Ǎ���
�����F
  arg_Ini : TIniFile;
��O�F����
���A�l�F
**)
procedure proc_ReadiniFlg(
                          arg_Ini : TIniFile
                          );
var
  w_i   : Integer;
  w_Pos : Integer;
  wsl_List : TStrings;
  wsl_List2 : TStrings;
  w_i2   : Integer;
begin

  //�Ō�敪
  g_KangoKbn_List := TStringList.Create;
  g_KangoName_List := TStringList.Create;
  //���[�N
  wsl_List := TStringList.Create;

  arg_Ini.ReadSectionValues(g_KANGO_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_KangoKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_KangoName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_KangoKbn_List.Add(DEF_HIS_KANGO_1);
    g_KangoKbn_List.Add(DEF_HIS_KANGO_2);
    g_KangoKbn_List.Add(DEF_HIS_KANGO_3);
    g_KangoKbn_List.Add(CSTNULLDATAKEY);
    g_KangoName_List.Add(DEF_KANGO_1_NAME);
    g_KangoName_List.Add(DEF_KANGO_2_NAME);
    g_KangoName_List.Add(DEF_KANGO_3_NAME);
    g_KangoName_List.Add(DEF_KANGO_9_NAME);
  end;

  //���ҋ敪
  g_KanjaKbn_List := TStringList.Create;
  g_KanjaName_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_KANJA_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_KanjaKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_KanjaName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_KanjaKbn_List.Add(DEF_HIS_KANJA_1);
    g_KanjaKbn_List.Add(DEF_HIS_KANJA_2);
    g_KanjaKbn_List.Add(DEF_HIS_KANJA_3);
    g_KanjaKbn_List.Add(DEF_HIS_KANJA_4);
    g_KanjaKbn_List.Add(CSTNULLDATAKEY);
    g_KanjaName_List.Add(DEF_KANJA_1_NAME);
    g_KanjaName_List.Add(DEF_KANJA_2_NAME);
    g_KanjaName_List.Add(DEF_KANJA_3_NAME);
    g_KanjaName_List.Add(DEF_KANJA_4_NAME);
    g_KanjaName_List.Add(DEF_KANJA_9_NAME);
  end;

  //�~��敪
  g_KyuugoKbn_List := TStringList.Create;
  g_KyuugoName_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_KYUGO_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_KyuugoKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_KyuugoName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_KyuugoKbn_List.Add(DEF_HIS_KYUGO_1);
    g_KyuugoKbn_List.Add(DEF_HIS_KYUGO_2);
    g_KyuugoKbn_List.Add(DEF_HIS_KYUGO_3);
    g_KyuugoKbn_List.Add(CSTNULLDATAKEY);
    g_KyuugoName_List.Add(DEF_KYUGO_1_NAME);
    g_KyuugoName_List.Add(DEF_KYUGO_2_NAME);
    g_KyuugoName_List.Add(DEF_KYUGO_3_NAME);
    g_KyuugoName_List.Add(DEF_KYUGO_9_NAME);
  end;

  //���t�^ABO
  g_ABOCode_List := TStringList.Create;
  g_ABOName_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_BLOODABO_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_ABOCode_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_ABOName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_ABOCode_List.Add(DEF_HIS_BLOODABO_1);
    g_ABOCode_List.Add(DEF_HIS_BLOODABO_2);
    g_ABOCode_List.Add(DEF_HIS_BLOODABO_3);
    g_ABOCode_List.Add(DEF_HIS_BLOODABO_4);
    g_ABOCode_List.Add(CSTNULLDATAKEY);
    g_ABOName_List.Add(DEF_BLOODABO_1_NAME);
    g_ABOName_List.Add(DEF_BLOODABO_2_NAME);
    g_ABOName_List.Add(DEF_BLOODABO_3_NAME);
    g_ABOName_List.Add(DEF_BLOODABO_4_NAME);
    g_ABOName_List.Add(DEF_BLOODABO_9_NAME);
  end;

  //���t�^RH
  g_RHCode_List := TStringList.Create;
  g_RHName_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_BLOODRH_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_RHCode_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_RHName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_RHCode_List.Add(DEF_HIS_BLOODRH_1);
    g_RHCode_List.Add(DEF_HIS_BLOODRH_2);
    g_RHCode_List.Add(CSTNULLDATAKEY);
    g_RHName_List.Add(DEF_BLOODRH_1_NAME);
    g_RHName_List.Add(DEF_BLOODRH_2_NAME);
    g_RHName_List.Add(DEF_BLOODRH_9_NAME);
  end;

  //��Q��񖼏�
  g_Syougai_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_SYOUGAINAME_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_Syougai_List.CommaText := Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i]));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_Syougai_List.CommaText := g_DEFSYOUGAINAMEO1;
  end;

  //�������
  g_KansenCode_List := TStringList.Create;
  g_KansenName_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_KANSEN_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_KansenCode_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_KansenName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_KansenCode_List.Add(DEF_KANSEN_0);
    g_KansenCode_List.Add(DEF_KANSEN_1);
    g_KansenCode_List.Add(DEF_KANSEN_2);
    g_KansenCode_List.Add(CSTNULLDATAKEY);
    g_KansenName_List.Add(DEF_KANSEN_0_NAME);
    g_KansenName_List.Add(DEF_KANSEN_1_NAME);
    g_KansenName_List.Add(DEF_KANSEN_2_NAME);
    g_KansenName_List.Add(DEF_KANSEN_9_NAME);
  end;

  //������񖼏�
  g_Kansen_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_KANSENNAME_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_Kansen_List.CommaText := Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i]));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_Kansen_List.CommaText := g_DEFKANSENNAMEO1;
  end;

  //�������L�薼��
  g_KansenON_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_KANSENON_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_KansenON_List.CommaText := Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i]));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_KansenON_List.CommaText := g_DEFKANSENONO1;
  end;

  //�֊���񖼏�
  g_Kinki_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_KINKINAME_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_Kinki_List.CommaText := Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i]));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_Kinki_List.CommaText := g_DEFKINKINAMEO1;
  end;

  //�ً}�敪
  g_KinkyuKbn_List := TStringList.Create;
  g_KinkyuName_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_KINKYU_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_KinkyuKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_KinkyuName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_KinkyuKbn_List.Add(DEF_HIS_KINKYU_0);
    g_KinkyuKbn_List.Add(DEF_HIS_KINKYU_1);
    g_KinkyuName_List.Add(DEF_KINKYU_0_NAME);
    g_KinkyuName_List.Add(DEF_KINKYU_1_NAME);
  end;

  //���}�敪
  g_SikyuKbn_List := TStringList.Create;
  g_SikyuName_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_SIKYU_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_SikyuKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_SikyuName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_SikyuKbn_List.Add(DEF_HIS_SIKYU_0);
    g_SikyuKbn_List.Add(DEF_HIS_SIKYU_1);
    g_SikyuName_List.Add(DEF_SIKYU_0_NAME);
    g_SikyuName_List.Add(DEF_SIKYU_1_NAME);
  end;

  //���}�����敪
  g_GenzoKbn_List := TStringList.Create;
  g_GenzoName_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_GENZO_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_GenzoKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_GenzoName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_GenzoKbn_List.Add(DEF_HIS_GENZO_0);
    g_GenzoKbn_List.Add(DEF_HIS_GENZO_1);
    g_GenzoName_List.Add(DEF_GENZO_0_NAME);
    g_GenzoName_List.Add(DEF_GENZO_1_NAME);
  end;

  //�\��敪
  g_YoyakuKbn_List := TStringList.Create;
  g_YoyakuName_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_YOYAKU_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_YoyakuKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_YoyakuName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_YoyakuKbn_List.Add(DEF_HIS_YOYAKU_O);
    g_YoyakuKbn_List.Add(DEF_HIS_YOYAKU_C);
    g_YoyakuKbn_List.Add(DEF_HIS_YOYAKU_N);
    g_YoyakuName_List.Add(DEF_YOYAKU_O_NAME);
    g_YoyakuName_List.Add(DEF_YOYAKU_C_NAME);
    g_YoyakuName_List.Add(DEF_YOYAKU_N_NAME);
  end;

  //�ǉe�敪
  g_DokueiKbn_List := TStringList.Create;
  g_DokueiName_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_DOKUEI_SECSION,wsl_List);

  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_DokueiKbn_List.Add(Copy(wsl_List[w_i], 1, w_Pos - 1));
      g_DokueiName_List.Add(Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i])));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_DokueiKbn_List.Add(DEF_HIS_DOKUEI_0);
    g_DokueiKbn_List.Add(DEF_HIS_DOKUEI_1);
    g_DokueiName_List.Add(DEF_DOKUEI_0_NAME);
    g_DokueiName_List.Add(DEF_DOKUEI_1_NAME);
  end;
  //�����p�������
  SetLength(g_ReportType_ID,0);

  //���[�N
  wsl_List.Clear;
  wsl_List2 := TStringList.Create;

  arg_Ini.ReadSectionValues(g_REPORTTYPE_SECSION,wsl_List);

  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      wsl_List2.CommaText := Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i]));

      for w_i2 := 0 to wsl_List2.Count - 1 do
      begin
        SetLength(g_ReportType_ID,Length(g_ReportType_ID) + 1);
        g_ReportType_ID[Length(g_ReportType_ID) - 1].f_HIS_ID := wsl_List2.Strings[w_i2];
        g_ReportType_ID[Length(g_ReportType_ID) - 1].f_RIS_ID := Copy(wsl_List[w_i], 1, w_Pos - 1);
      end;
    end;
  end;


  //�ޗ���񖼏�
  g_Zairyo_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_ZAI_CODE_SECSION,wsl_List);


  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      g_Zairyo_List.CommaText := Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i]));
    end;
  end;

  if wsl_List.Count = 0 then
  begin
    //�����l�ݒ�
    g_Zairyo_List.CommaText := g_DEFZAI_CODE;
  end;

  if wsl_List <> nil then
    FreeAndNil(wsl_List);
  if wsl_List2 <> nil then
    FreeAndNil(wsl_List2);

end;
procedure proc_ReadiniType(
                          arg_Ini : TIniFile
                          );
var
  w_i   : Integer;
  w_Pos : Integer;
  wsl_List : TStrings;
begin

  //�������
  SetLength(g_Kensa_ID,0);

  if wsl_List = nil then
    wsl_List := TStringList.Create;
  //���[�N
  wsl_List.Clear;

  arg_Ini.ReadSectionValues(g_RTRISTYPE_SECSION,wsl_List);

  for w_i := 0 to wsl_List.Count - 1 do
  begin
    w_Pos := Pos('=',wsl_List[w_i]);
    if w_Pos <> 0 then
    begin
      SetLength(g_Kensa_ID,Length(g_Kensa_ID) + 1);
      g_Kensa_ID[Length(g_Kensa_ID) - 1].f_HIS_ID := Copy(wsl_List[w_i], 1, w_Pos - 1);
      g_Kensa_ID[Length(g_Kensa_ID) - 1].f_RIS_ID := Copy(wsl_List[w_i],w_Pos + 1,Length(wsl_List[w_i]));
    end;
  end;
  if wsl_List <> nil then
    FreeAndNil(wsl_List);

end;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ� �R�}���h��
function func_Change_Command(
                             arg_Code: String    //����
                             ): String;          //����
var
  w_Res: String;
begin
  //�I�[�_���
  if arg_Code = CST_COMMAND_ORDER then
    //�I�[�_��M�T�[�r�X
    w_Res := CST_APPID_HRCV01
  //���ҏ��X�V
  else if arg_Code = CST_COMMAND_KANJAUP then
    //���ҏ���M�T�[�r�X
    w_Res := CST_APPID_HRCV02
  //���Ҏ��S�މ@���
  else if arg_Code = CST_COMMAND_KANJADEL then
    //���ҏ���M�T�[�r�X
    w_Res := CST_APPID_HRCV02
  //�I�[�_�L�����Z��
  else if arg_Code = CST_COMMAND_ORDERCANCEL then
    //�I�[�_��M�T�[�r�X
    w_Res := CST_APPID_HRCV01
  //��v�ʒm
  else if arg_Code = CST_COMMAND_KAIKEI then
    //��v�ʒm��M�T�[�r�X
    w_Res := CST_APPID_HRCV03
  //���Ҏ�t
  else if arg_Code = CST_COMMAND_UKETUKE then
    //��t�ʒm���M�T�[�r�X
    w_Res := CST_APPID_HSND01
  //�B�e���{�ʒm
  else if arg_Code = CST_COMMAND_JISSI then
    //���ё��M�T�[�r�X
    w_Res := CST_APPID_HSND02
  //�I�[�_�đ��v��
  else if arg_Code = CST_COMMAND_RESEND then
    //���ё��M�T�[�r�X
    w_Res := CST_APPID_HSND02
  else
    //�R�[�h����
    w_Res := '';

  Result := w_Res;
end;
//���@�\�i��O���j�F���ނ𖼑O�ɕϊ� �R�}���h���i��M�n�T�[�r�X�̂݁j
function func_Change_RVRISCommand(
                                  arg_Code: String    //����
                                  ): String;          //����
var
  w_Res: String;
begin
  //�I�[�_���
  if arg_Code = CST_COMMAND_ORDER then
    //�I�[�_���
    w_Res := CST_APPTYPE_OI01
  //���ҏ��X�V
  else if arg_Code = CST_COMMAND_KANJAUP then
    //���ҏ��
    w_Res := CST_APPTYPE_PI01
  //���Ҏ��S�މ@���
  else if arg_Code = CST_COMMAND_KANJADEL then
    //���S�މ@���
    w_Res := CST_APPTYPE_PI99
  //�I�[�_�L�����Z��
  else if arg_Code = CST_COMMAND_ORDERCANCEL then
    //�I�[�_�L�����Z��
    w_Res := CST_APPTYPE_OI99
  //��v�ʒm
  else if arg_Code = CST_COMMAND_KAIKEI then
    //��v�ʒm
    w_Res := CST_APPTYPE_AC01
  else
    //�R�[�h����
    w_Res := '';

  Result := w_Res;
end;
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
//���@�\�i��O���j�FHIS���t�^ABO��RH����RIS�p�ɕϊ�
function func_Make_BloodType(
                             arg_ABO: String;
                             arg_RH: String
                             ): String;
var
  ws_ABO: String;
  wi_LoopABO: Integer;
  wi_LoopABO2: Integer;
  ws_RH: String;
  wi_LoopRH: Integer;
  wi_LoopRH2: Integer;
begin
  //���t�^ABO�������ꍇ
  if arg_ABO = '' then
  begin
    for wi_LoopABO2 := 0 to g_ABOCode_List.Count - 1 do
    begin
      if g_ABOCode_List[wi_LoopABO2] = CSTNULLDATAKEY then
      begin
        //�s��
        ws_ABO := g_ABOName_List[wi_LoopABO2];
      end;
    end;
  end
  else
  begin
    //ini�t�@�C���̏��
    for wi_LoopABO := 0 to g_ABOCode_List.Count - 1 do
    begin
      //�R�[�h�Ɠ������̂��������ꍇ
      if arg_ABO = g_ABOCode_List[wi_LoopABO] then
      begin
        //���̃��X�g�͈͓��̏ꍇ
        if g_ABOName_List.Count - 1 >= wi_LoopABO then
        begin
          //���X�g���̐ݒ�
          ws_ABO := g_ABOName_List[wi_LoopABO];
        end;
      end
      else if arg_ABO = ' ' then
      begin
        for wi_LoopABO2 := 0 to g_ABOCode_List.Count - 1 do
        begin
          if g_ABOCode_List[wi_LoopABO2] = CSTNULLDATAKEY then
          begin
            //�s��
            ws_ABO := g_ABOName_List[wi_LoopABO2];
          end;
        end;
      end;
    end;
  end;
  //���t�^RH�������ꍇ
  if arg_RH = '' then
  begin
    for wi_LoopRH2 := 0 to g_RHCode_List.Count - 1 do
    begin
      if g_RHCode_List[wi_LoopRH2] = CSTNULLDATAKEY then
      begin
        //�s��
        ws_RH := g_RHName_List[wi_LoopRH2];
      end;
    end;
  end
  else
  begin
    //ini�t�@�C���̏��
    for wi_LoopRH := 0 to g_RHCode_List.Count - 1 do
    begin
      //�R�[�h�Ɠ������̂��������ꍇ
      if arg_RH = g_RHCode_List[wi_LoopRH] then
      begin
        //���̃��X�g�͈͓��̏ꍇ
        if g_RHName_List.Count - 1 >= wi_LoopRH then
        begin
          //���X�g���̐ݒ�
          ws_RH := g_RHName_List[wi_LoopRH];
        end;
      end
      else if arg_RH = ' ' then
      begin
        for wi_LoopRH2 := 0 to g_RHCode_List.Count - 1 do
        begin
          if g_RHCode_List[wi_LoopRH2] = CSTNULLDATAKEY then
          begin
            //�s��
            ws_RH := g_RHName_List[wi_LoopRH2];
          end;
        end;
      end;
    end;
  end;

  Result := ws_ABO + ',' + ws_RH;
end;
//���@�\�i��O���j�FRIS��Q���A�֊����̍쐬
procedure proc_Make_RISInfo(
                                arg_Syougai: String;
                                arg_Kinki: String;
                            var arg_SyougaiInfo: String;
                            var arg_KinkiInfo: String
                           );
var
  wi_Loop: Integer;
begin
  //��Q��񂪖����ꍇ
  if arg_Syougai = '' then
  begin
    //��Q���Ȃ�
    arg_SyougaiInfo := '';
  end
  else
  begin
    //ini�t�@�C���̏��
    for wi_Loop := 1 to Length(arg_Syougai) do
    begin
      //�R�[�h�Ɠ������̂��������ꍇ
      if arg_Syougai[wi_Loop] = DEF_SYOUGAI_1 then
      begin
        //���̃��X�g�͈͓��̏ꍇ
        if g_Syougai_List.Count >= wi_Loop then
        begin
          if arg_SyougaiInfo = '' then
          begin
            //���X�g���̐ݒ�
            arg_SyougaiInfo := g_Syougai_List[wi_Loop - 1];
          end
          else
          begin
            //���X�g���̐ݒ�
            arg_SyougaiInfo := arg_SyougaiInfo + ',' +
                               g_Syougai_List[wi_Loop - 1];
          end;
        end;
      end;
    end;
  end;
  //�֊���񂪖����ꍇ
  if arg_Kinki = '' then
  begin
    //�֊����Ȃ�
    arg_KinkiInfo := '';
  end
  else
  begin
    //ini�t�@�C���̏��
    for wi_Loop := 1 to Length(arg_Kinki) do
    begin
      //�R�[�h�Ɠ������̂��������ꍇ
      if arg_Kinki[wi_Loop] = DEF_KINKI_1 then
      begin
        //���̃��X�g�͈͓��̏ꍇ
        if g_Kinki_List.Count >= wi_Loop then
        begin
          if arg_KinkiInfo = '' then
          begin
            //���X�g���̐ݒ�
            arg_KinkiInfo := g_Kinki_List[wi_Loop - 1];
          end
          else
          begin
            //���X�g���̐ݒ�
            arg_KinkiInfo := arg_KinkiInfo + ',' + g_Kinki_List[wi_Loop - 1];
          end;
        end;
      end;
    end;
  end;
end;
//���@�\�i��O���j�FRIS�������̍쐬
procedure proc_Make_RISKansen(
                                arg_Kansen: String;
                                arg_KansenCom: String;
                            var arg_KansenFlg: String;
                            var arg_KansenInfo: String
                           );
var
  wi_Loop: Integer;
  wi_LoopOn: Integer;
  wi_LoopKa: Integer;
  wi_LoopKa2: Integer;
begin
  //������񂪖����ꍇ
  if arg_Kansen = '' then
  begin
    //�������t���O
    arg_KansenFlg := DEF_RIS_KANSEN_0;
  end
  else
  begin
    //ini�t�@�C���̏��
    for wi_Loop := 1 to Length(arg_Kansen) do
    begin
      for wi_LoopOn := 0 to g_KansenON_List.Count - 1 do
      begin
        //�R�[�h�Ɠ������̂��������ꍇ
        if arg_Kansen[wi_Loop] = g_KansenON_List[wi_LoopOn] then
        begin
          //���̃��X�g�͈͓��̏ꍇ
          if g_Kansen_List.Count >= wi_Loop then
          begin
            //�����L��
            arg_KansenFlg := DEF_RIS_KANSEN_1;
          end;
        end;
      end;
    end;
  end;
  //������񂪖����ꍇ
  if arg_Kansen = '' then
  begin
    //�������Ȃ�
    arg_KansenInfo := '';
  end
  else
  begin
    //ini�t�@�C���̏��
    for wi_Loop := 1 to Length(arg_Kansen) do
    begin
      for wi_LoopKa := 0 to g_KansenCode_List.Count - 1 do
      begin
        //�R�[�h�Ɠ������̂��������ꍇ
        if arg_Kansen[wi_Loop] = g_KansenCode_List[wi_LoopKa] then
        begin
          //���̃��X�g�͈͓��̏ꍇ
          if g_Kansen_List.Count >= wi_Loop then
          begin
            if arg_KansenInfo = '' then
            begin
              //���X�g���̐ݒ�
              arg_KansenInfo := g_Kansen_List[wi_Loop - 1] + '=' +
                                g_KansenName_List[wi_LoopKa];
            end
            else
            begin
              //���X�g���̐ݒ�
              arg_KansenInfo := arg_KansenInfo + ',' +
                                g_Kansen_List[wi_Loop - 1] + '=' +
                                g_KansenName_List[wi_LoopKa];
            end;
          end;
        end
        //�u�����N�̏ꍇ
        else if arg_Kansen[wi_Loop] = ' ' then
        begin
          for wi_LoopKa2 := 0 to g_KansenCode_List.Count - 1 do
          begin
            if g_Kansen_List[wi_LoopKa2] = CSTNULLDATAKEY then
            begin
              if arg_KansenInfo = '' then
              begin
                //���X�g���̐ݒ�
                arg_KansenInfo := g_Kansen_List[wi_Loop - 1] + '=' +
                                  g_KansenName_List[wi_LoopKa2];
              end
              else
              begin
                //���X�g���̐ݒ�
                arg_KansenInfo := arg_KansenInfo + ',' +
                                  g_Kansen_List[wi_Loop - 1] + '=' +
                                  g_KansenName_List[wi_LoopKa2];
              end;
            end;
          end;
        end;
      end;
    end;
  end;
  //�����R�����g������ꍇ
  if arg_KansenCom <> '' then
  begin
    //�������t���O
    arg_KansenFlg := DEF_RIS_KANSEN_1;
    //������񂪂���ꍇ
    if arg_KansenInfo = '' then
    begin
      arg_KansenInfo := arg_KansenCom;
    end
    //������񂪖����ꍇ
    else
    begin
      arg_KansenInfo := arg_KansenInfo + ',' + arg_KansenCom;
    end;
  end;
end;
//���@�\�i��O���j�FRIS�D�P���̍쐬
procedure proc_Make_RISNinsinDate(
                                      arg_Ninsin: String;
                                  var arg_NinsinDate: String
                                  );
begin
  //�D�P���������ꍇ
  if arg_Ninsin = '' then
    //�����I��
    Exit;
  //YYYY�NMM��DD���ɕϊ�
  arg_NinsinDate := Copy(arg_Ninsin,1,4) + '�N' + Copy(arg_Ninsin,5,2) + '��' +
                    Copy(arg_Ninsin,7,2) + '��';
end;
//���@�\�i��O���j�FHIS�Ō�敪�E���ҋ敪��RIS�p�ɕϊ�
function func_Make_ExtraProfile(
                                arg_Kango: String;
                                arg_Kanja: String
                                ): String;
var
  wi_LoopKango: Integer;
  wi_LoopKango2: Integer;
  wi_LoopKanja: Integer;
  wi_LoopKanja2: Integer;
begin
  //�Ō�敪�������ꍇ
  if arg_Kango = '' then
  begin
    for wi_LoopKango := 0 to g_KangoKbn_List.Count - 1 do
    begin
      if g_KangoKbn_List[wi_LoopKango] = CSTNULLDATAKEY then
      begin
        //�s��
        arg_Kango := '�Ō�敪=' + g_KangoName_List[wi_LoopKango];
      end;
    end;
  end
  else
  begin
    //ini�t�@�C���̏��
    for wi_LoopKango2 := 0 to g_KangoKbn_List.Count - 1 do
    begin
      //�R�[�h�Ɠ������̂��������ꍇ
      if arg_Kango = g_KangoKbn_List[wi_LoopKango2] then
      begin
        //���̃��X�g�͈͓��̏ꍇ
        if g_KangoKbn_List.Count - 1 >= wi_LoopKango2 then
        begin
          //���X�g���̐ݒ�
          arg_Kango := '�Ō�敪=' + g_KangoName_List[wi_LoopKango2];
        end;
      end
      else if arg_Kango = ' ' then
      begin
        for wi_LoopKango := 0 to g_KangoKbn_List.Count - 1 do
        begin
          if g_KangoKbn_List[wi_LoopKango] = CSTNULLDATAKEY then
          begin
            //�s��
            arg_Kango := '�Ō�敪=' + g_KangoName_List[wi_LoopKango];
          end;
        end;
      end;
    end;
  end;
  //���ҋ敪�������ꍇ
  if arg_Kanja = '' then
  begin
    for wi_LoopKanja := 0 to g_KanjaKbn_List.Count - 1 do
    begin
      if g_KanjaKbn_List[wi_LoopKanja] = CSTNULLDATAKEY then
      begin
        //�s��
        arg_Kanja := '���ҋ敪=' + g_KanjaName_List[wi_LoopKanja];
      end;
    end;
  end
  else
  begin
    //ini�t�@�C���̏��
    for wi_LoopKanja := 0 to g_KanjaKbn_List.Count - 1 do
    begin
      //�R�[�h�Ɠ������̂��������ꍇ
      if arg_Kanja = g_KanjaKbn_List[wi_LoopKanja] then
      begin
        //���̃��X�g�͈͓��̏ꍇ
        if g_KanjaKbn_List.Count - 1 >= wi_LoopKanja then
        begin
          //���X�g���̐ݒ�
          arg_Kanja := '���ҋ敪=' + g_KanjaName_List[wi_LoopKanja];
        end;
      end
      else if arg_Kanja = ' ' then
      begin
        for wi_LoopKanja2 := 0 to g_KanjaKbn_List.Count - 1 do
        begin
          if g_KanjaKbn_List[wi_LoopKanja2] = CSTNULLDATAKEY then
          begin
            //�s��
            arg_Kanja := '���ҋ敪=' + g_KanjaName_List[wi_LoopKanja2];
          end;
        end;
      end;
    end;
  end;

  Result := arg_Kango + ',' + arg_Kanja;
end;
{
-----------------------------------------------------------------------------
  ���O   : func_GetServiceInfo
  ����   :     arg_AppID  : String �A�v���P�[�V�������ʎq
           var arg_ErrMsg : String �G���[���F�ڍ׌��� ���펞�F''
  �@�\   : 1. HIS�ʐM�Ǘ��e�[�u������|�[�g���擾����B
  ���A�l : ��O�Ȃ�
-----------------------------------------------------------------------------
}
function func_GetServiceInfo(    arg_AppID  : String;
                                 arg_Qry    : T_Query;
                             var arg_Flg    : Boolean;
                             var arg_ErrMsg : String
                             ): String;
var
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //�߂�l
  Result := '';
  try
    with arg_Qry do begin
      //SQL�ݒ�
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT COMMUNICATORDEFINE FROM HISRISCONTROLINFO';
      sqlSelect := sqlSelect + ' WHERE APPID = :PAPPID';
      PrepareQuery(sqlSelect);
      //�p�����[�^
      //�T�[�r�X���ʎq
      SetParam('PAPPID', arg_AppID);
      //SQL���s
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //��O�G���[
        Result := '';
        //�����I��
        Exit;
      end;
      if Eof = False then begin
        // �Ώۃf�[�^�̎擾
        //�|�[�g�̐ݒ�
        Result := GetString('COMMUNICATORDEFINE');
      end
      else begin
        Result := '';
      end;
      //����I������
      arg_ErrMsg :='';
      //�����I��
      Exit;
    end;
  except
    //�G���[�I������
    on E:exception do
    begin
      //�G���[���b�Z�[�W
      arg_ErrMsg := E.Message;
      //DB�ؒf
      arg_Flg := False;
      //�߂�l
      Result := '';
      //�����I��
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O   : func_GetServiceInfo
  ����   :     arg_AppID  : String �A�v���P�[�V�������ʎq
           var arg_ErrMsg : String �G���[���F�ڍ׌��� ���펞�F''
  �@�\   : 1. HIS�ʐM�Ǘ��e�[�u������|�[�g���擾����B
  ���A�l : ��O�Ȃ�
-----------------------------------------------------------------------------
}
(*
function func_GetRTServiceInfo(    arg_AppID  : String;
                                   arg_Qry    : TQuery;
                               var arg_Flg    : Boolean;
                               var arg_ErrMsg : String
                               ): String;
begin
  //�߂�l
  Result := '';
  try
    try
      with arg_Qry do
      begin
        //SQL���N���A
        SQL.Clear;
        //SQL���쐬
        SQL.Add('SELECT COMMUNICATORDEFINE FROM ' + g_RRISUser + '.HISRISCONTROLINFO');
        SQL.Add(' WHERE APPID = :PAPPID');
        //�T�[�r�X���ʎq
        ParamByName('PAPPID').AsString := arg_AppID;
        Open;
        Last;
        First;
        //���R�[�h������ꍇ
        if arg_Qry.RecordCount > 0 then
        begin
          //�|�[�g�̐ݒ�
          Result := FieldByName('COMMUNICATORDEFINE').AsString;
        end
        else
        begin
          Result := '';
        end;
      end;
      //����I������
      arg_ErrMsg :='';
      //�����I��
      Exit;
    except
      //�G���[�I������
      on E:exception do
      begin
        //�G���[���b�Z�[�W
        arg_ErrMsg := E.Message;
        //DB�ؒf
        arg_Flg := False;
        //�߂�l
        Result := '';
        //�����I��
        Exit;
      end;
    end;
  finally
    arg_Qry.Close;
    arg_Qry.SQL.Clear;
  end;
end;
*)
{
-----------------------------------------------------------------------------
  ���O   : func_GetSeq
  ����   :     arg_AppID  : String �A�v���P�[�V�������ʎq
           var arg_ErrMsg : String  �G���[���F�ڍ׌��� ���펞�F''
  �@�\   : 1. HIS�ʐM�Ǘ��e�[�u�����瑗�M��SEQ���擾����B
  ���A�l : ��O�Ȃ�  SEQ�ԍ�
-----------------------------------------------------------------------------
}
function func_GetSeq(    arg_AppID  : String;
                         arg_Qry    : TQuery;
                     var arg_Flg    : Boolean;
                     var arg_ErrMsg : String
                     ): String;
begin
  //�߂�l
  Result := '';
  try
    try
      with arg_Qry do
      begin
        //SQL���N���A
        SQL.Clear;
        //SQL���쐬
        SQL.Add('SELECT COMINF01 FROM HISRISCONTROLINFO');
        SQL.Add(' WHERE APPID = :PAPPID');
        //�T�[�r�X���ʎq
        ParamByName('PAPPID').AsString := arg_AppID;
        Open;
        Last;
        First;
        //���R�[�h������ꍇ
        if arg_Qry.RecordCount > 0 then
        begin
          //��M��SEQ�̐ݒ�
          Result := func_LeftZero(10,FieldByName('COMINF01').AsString);
        end
        else
        begin
          Result := '0000000000';
        end;
      end;
      //����I������
      arg_ErrMsg :='';
      //�����I��
      Exit;
    except
      //�G���[�I������
      on E:exception do
      begin
        //�G���[���b�Z�[�W
        arg_ErrMsg := E.Message;
        //DB�ؒf
        arg_Flg := False;
        //�߂�l
        Result := '';
        //�����I��
        Exit;
      end;
    end;
  finally
    arg_Qry.Close;
    arg_Qry.SQL.Clear;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O   : func_GetDBMachineName
  ����   :     arg_AppID  : String �A�v���P�[�V�������ʎq
           var arg_ErrMsg : String  �G���[���F�ڍ׌��� ���펞�F''
  �@�\   : 1. HIS�ʐM�Ǘ��e�[�u������T�[�o�����擾����B
  ���A�l : ��O�Ȃ�  �T�[�o��
-----------------------------------------------------------------------------
}
function func_GetDBMachineName(    arg_AppID  : String;
                                   arg_Qry    : TQuery;
                               var arg_Flg    : Boolean;
                               var arg_ErrMsg : String
                               ): String;
begin
  //�߂�l
  Result := '';
  try
    try
      with arg_Qry do
      begin
        //SQL���N���A
        SQL.Clear;
        //SQL���쐬
        SQL.Add('SELECT COMINF05 FROM HISRISCONTROLINFO');
        SQL.Add(' WHERE APPID = :PAPPID');
        //�T�[�r�X���ʎq
        ParamByName('PAPPID').AsString := arg_AppID;
        Open;
        Last;
        First;
        //���R�[�h������ꍇ
        if arg_Qry.RecordCount > 0 then
        begin
          //�T�[�o���̐ݒ�
          Result := FieldByName('COMINF05').AsString;
        end
        else
        begin
          Result := '';
        end;
      end;
      //����I������
      arg_ErrMsg :='';
      //�����I��
      Exit;
    except
      //�G���[�I������
      on E:exception do
      begin
        //�G���[���b�Z�[�W
        arg_ErrMsg := E.Message;
        //DB�ؒf
        arg_Flg := False;
        //�߂�l
        Result := '';
        //�����I��
        Exit;
      end;
    end;
  finally
    arg_Qry.Close;
    arg_Qry.SQL.Clear;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O   : func_SetHISRISControlInfo
  ����   : arg_APPID         : String        RIS_ID
           arg_LogBuffer     : String        �t���G���[�ڍ�
  �@�\   : 1.HIS�ʐM�Ǘ��e�[�u���̍X�V
  ���A�l : True ���� False ���s ��O�͔������Ȃ�
-----------------------------------------------------------------------------
}
function func_SetHISRISControlInfo(    arg_APPID : String;
                                       arg_DataSeq : String;
                                       arg_Qry    : TQuery;
                                   var arg_Flg    : Boolean;
                                   var arg_LogBuffer : String
                                   ):Boolean;
begin
  try
    with arg_Qry do
    begin
      //����
      Close;
      //SQL���N���A
      SQL.Clear;
      //SQL���쐬
      SQL.Add('UPDATE HISRISCONTROLINFO SET');
      SQL.Add('COMINF01 = :PCOMINF01 '); //�f�[�^SEQ
      SQL.Add('WHERE APPID = :PAPPID '); //�A�v���P�[�V�������ʎq
      try
        //RIS_ID
        ParamByName('PCOMINF01').AsString := arg_DataSeq;
        //����ID
        ParamByName('PAPPID').AsString := arg_APPID;
        {$IFDEF DEBUGE}
        SQL.SaveToFile('HISRISCONTROLINFO.SQL');
        {$ENDIF}
        //���s
        ExecSQL;
        //�߂�l
        Result := True;
        //�����I��
        Exit;
      except
        on E: Exception do
        begin
          //���O������쐬
          proc_StrConcat(arg_LogBuffer, ' HIS�ʐM�Ǘ��ύX ��O�����u' +
                         E.Message + '�v');
          //�߂�l
          Result := False;
          //�ؒf
          arg_Flg := False;
          //�����I��
          Exit;
        end;
      end;
    end;
  finally
    arg_Qry.Close;
    arg_Qry.SQL.Clear;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O   : func_GetRISHost
  ����   : arg_HostID        : String        �[��ID
           arg_LogBuffer     : String        �t���G���[�ڍ�
  �@�\   : 1.�[�����̎擾
  ���A�l : True ���� False ���s ��O�͔������Ȃ�
-----------------------------------------------------------------------------
}
function func_GetRISHost(    arg_HostID : String;
                             arg_Qry    : TQuery;
                         var arg_Flg    : Boolean;
                         var arg_ErrMsg : String
                         ): String;
begin
  //�߂�l
  Result := '';
  try
    try
      with arg_Qry do
      begin
        //SQL���N���A
        SQL.Clear;
        //SQL���쐬
        SQL.Add('SELECT TERMINALNAME FROM TERMINALINFO');
        SQL.Add(' WHERE TERMINALID = :PTERMINALID');
        //�[��ID
        ParamByName('PTERMINALID').AsString := arg_HostID;
        Open;
        Last;
        First;
        //���R�[�h������ꍇ
        if arg_Qry.RecordCount > 0 then
        begin
          //�T�[�o���̐ݒ�
          Result := FieldByName('TERMINALNAME').AsString;
        end
        else
        begin
          Result := '';
        end;
      end;
      //����I������
      arg_ErrMsg :='';
      //�����I��
      Exit;
    except
      //�G���[�I������
      on E:exception do
      begin
        //�G���[���b�Z�[�W
        arg_ErrMsg := E.Message;
        //DB�ؒf
        arg_Flg := False;
        //�߂�l
        Result := '';
        //�����I��
        Exit;
      end;
    end;
  finally
    arg_Qry.Close;
    arg_Qry.SQL.Clear;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O   : func_GetRTRISHost
  ����   : arg_HostID        : String        �[��ID
           arg_LogBuffer     : String        �t���G���[�ڍ�
  �@�\   : 1.�[�����̎擾
  ���A�l : True ���� False ���s ��O�͔������Ȃ�
-----------------------------------------------------------------------------
}
(*
function func_GetRTRISHost(    arg_HostID : String;
                               arg_Qry    : TQuery;
                           var arg_Flg    : Boolean;
                           var arg_ErrMsg : String
                           ): String;
begin
  //�߂�l
  Result := '';
  try
    try
      with arg_Qry do
      begin
        //SQL���N���A
        SQL.Clear;
        //SQL���쐬
        SQL.Add('SELECT TERMINALNAME FROM ' + g_RRISUser + '.TERMINALINFO');
        SQL.Add(' WHERE TERMINALID = :PTERMINALID');
        //�[��ID
        ParamByName('PTERMINALID').AsString := arg_HostID;
        Open;
        Last;
        First;
        //���R�[�h������ꍇ
        if arg_Qry.RecordCount > 0 then
        begin
          //�T�[�o���̐ݒ�
          Result := FieldByName('TERMINALNAME').AsString;
        end
        else
        begin
          Result := '';
        end;
      end;
      //����I������
      arg_ErrMsg :='';
      //�����I��
      Exit;
    except
      //�G���[�I������
      on E:exception do
      begin
        //�G���[���b�Z�[�W
        arg_ErrMsg := E.Message;
        //DB�ؒf
        arg_Flg := False;
        //�߂�l
        Result := '';
        //�����I��
        Exit;
      end;
    end;
  finally
    arg_Qry.Close;
    arg_Qry.SQL.Clear;
  end;
end;
*)

function func_HisToReport(arg_HisID:String):String;
var
  w_Kensa:String;
  w_i:Integer;
begin
  //������
  w_Kensa := '';
  //�����ݒ�t�@�C���ɂ���`�[�R�[�h��
  for w_i := 0 to Length(g_ReportType_ID) - 1 do begin
    //�����`�[�R�[�h���������ꍇ
    if arg_HisID = g_ReportType_ID[w_i].f_HIS_ID then
      //Report������ʂɕϊ�
      w_Kensa := g_ReportType_ID[w_i].f_RIS_ID;
  end;
  //������ʕϊ�
  Result := w_Kensa;
end;

function func_ReportToHis(arg_ReportID:String):String;
var
  w_Kensa:String;
  w_i:Integer;
begin
  //������
  w_Kensa := '';
  //�����ݒ�t�@�C���ɂ���`�[�R�[�h��
  for w_i := 0 to Length(g_ReportType_ID) - 1 do begin
    //����������ʂ��������ꍇ
    if arg_ReportID = g_ReportType_ID[w_i].f_RIS_ID then
      //�`�[�R�[�h�ɕϊ�
      w_Kensa := g_ReportType_ID[w_i].f_HIS_ID;
  end;
  //�`�[�R�[�h�ϊ�
  Result := w_Kensa;
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

     g_Log_Type[G_LOG_KIND_SVCDEF_NUM].f_LogMsg   := G_LOG_KIND_SVCDEF;
     g_Log_Type[G_LOG_KIND_SVCDEF_NUM].f_LogLevel := G_LOG_KIND_SVCDEF_LEVEL;

     g_Log_Type[G_LOG_KIND_DEBUG_NUM].f_LogMsg   := G_LOG_KIND_DEBUG;
     g_Log_Type[G_LOG_KIND_DEBUG_NUM].f_LogLevel := G_LOG_KIND_DEBUG_LEVEL;

     g_Log_Type[G_LOG_KIND_NG_NUM].f_LogMsg   := G_LOG_KIND_NG;
     g_Log_Type[G_LOG_KIND_NG_NUM].f_LogLevel := G_LOG_KIND_NG_LEVEL;
end;

finalization
begin
//
end;

end.
