unit pdct_ini;
{
���@�\���� �i�g�p�\��F����j
 EXE�v���W�F�N�g�ɌŗL��ini����`
 ��`�݂̂ŏ����͊�{�I�ɏ����Ȃ�����
������
�V�K�쐬�F2000.10.27�F�S��  iwai
�C��    �F2000.12.19�F���c DB_ACC����"const"���ړ�
�C��    �F2001.02.21�Fiwai RIG�ڑ�����ǉ�
�C��    �F2001.02.21�F���c �V�����J���[��ǉ�
                           g_MODE_CURSOR_COLOR = 'CURSOR';
                           �\�ɃJ�[�\�����������Ă���ꍇ�̐F(�ް���)
�C��01�F03�F13 : iwai
                           ������������ǉ�
�C��    �F2001.03.15�F���c gi_RIG_Used��ǉ�
                           ���M���t���O
�C��    �F2001.03.15�F���c g_MODE_SATUEIDISPLAY��ǉ�
�C��    �F2001.09.25�Fiwai
        gi_RIG_Used���폜
�C��    �F2001.10.23�F���c
        //����/�����N��͈́i�Z�N�V�����L�[�j
        g_PARAMETER = 'PARAMETER';
        //�����N��͈́i�ް��L�[�j
        g_PARAMETER_NYUUJI = 'NYUUJI';
        //�����N��͈́i�ް��L�[�j
        g_PARAMETER_SHOUNI = 'SHOUNI';
        ��ݒ�
�C���@�@�F2003.12.11�F�J�� �`�[����t���O�p����ݷ�.�ް�����ǉ��B
�ǉ�    �F2004.01.13�F���� ���ް�޲���̪���p����ݷ�,�ް����ǉ�
�ǉ�    �F2004.01.22�F���� ��߰ĘA�g�p���Ұ�(ReportRis�o�^�t���O)�ǉ�
�ǉ�    �F2004.04.09�F���� ��а����ID�ݒ�ǉ�
�ǉ�    �F2004.04.28�F���c W9�\���R�����gID�ݒ�ǉ�
}
interface //*****************************************************************
//�g�p���j�b�g---------------------------------------------------------------
uses
//�V�X�e���̂ł���ȊO�͒ǉ����Ȃ����Ɓ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
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
  ComCtrls,
  StdCtrls,
  Grids;
////�^�N���X�錾-------------------------------------------------------------
//type
//�萔�錾-------------------------------------------------------------------
const
//�v���_�N�g�ŗL��񁫁�����������������������������������������������������������
G_SYSPID      = 'FM000W00';    //���ʕ�ID
G_SYSERROR00  = '00';          //�װ����
G_DBID        = 'FM000W99';    //DB��ID
G_DBERROR02   = '02';          //MainCONECT�װ����
G_DBERROR03   = '03';          //MainConect��
G_SYSTEM_USERID = 'yokogawa';  //�V�X�e�����[�TID
G_SYSTEM_USERPASS = 'huris';   //��L�p�X���[�h
//����������������������������������������������������������������

//INI�t�@�C����񁫁�����������������������������������������������������������
//���s�P�ʂ�INI�t�@�C�����i���p�X�j
 G_PRODUCT_INI_NAME = 'RIS_SYS.INI';
 //�Z�N�V�����F�T�uDB�V�X�e�����
  g_PLS1_DB_SECSION = 'DBPLS1';
    g_PLS1_UID_KEY         = 'dbuid'     ;//�L�[DB�ڑ����[�UID
        g_PLS1_DB_ACCOUNT  = 'pls1'   ;//�f�t�H���g INI�Őݒ�ςƂȂ邽�ߎg�p�s��
    g_PLS1_USERPSS_KEY     = 'dbpss'     ;//�L�[���[�U�p�X���[�h
        g_PLS1_DB_PASS     = 'pls1'   ;//�f�t�H���g INI�Őݒ�ςƂȂ邽�ߎg�p�s��
    g_PLS1_DBNAME_KEY      = 'dbname'    ;//�L�[DBname
        g_PLS1_DB_NAME     = 'pls1ORA';//�f�t�H���g INI�Őݒ�ςƂȂ邽�ߎg�p�s��
    g_PLS1_DB_CONECT_KEY   = 'dbcntmax'  ;//�L�[DB�����ڑ��ő吔
        g_PLS1_DB_CONECT_N = '0'         ;//�f�t�H���gDB�����ڑ��ő吔


//ini���Ǎ��� ����������������������������������������������������������������

 //WINMASTER�Ŏg�p���Ă��镶����̒�`�i�e���g�����̂���`����j����������������
 G_PASSWORD_SEC = 'PASSWORD';
   G_MSTPAS_KEY   = 'MST'  ;
   G_MSTSYSPAS_KEY   = 'MSTSYS'  ;
 G_CARD_INFO_SEC = 'CARD_INFO';
   G_CARDKIND_KEY   = 'CARDKIND'  ;
   G_CARDPORT_KEY   = 'CARDPORT'  ;
 G_IDT_INFO_SEC = 'IDT_INFO';
   G_IDTPORT1_KEY   = 'IDTPORT1'  ;
   G_IDTPORT2_KEY   = 'IDTPORT2'  ;
   G_IDTPORT3_KEY   = 'IDTPORT3'  ;
//DB_ACC����ړ�
  g_ALL_TEXT = '';
  g_SCREENCOLOR = 'SCREENCOLOR';   //����ݷ�
  g_MODE_JUNBI = 'MODE1';          //�����n��ʃJ���[Ӱ��(�ް���)
  g_MODE_UKETUKE = 'MODE2';        //��t�n��ʃJ���[Ӱ��(�ް���)
  g_MODE_JISEKI = 'MODE3';         //���ьn��ʃJ���[Ӱ��(�ް���)
  g_MODE_INSATU = 'MODE4';         //����n��ʃJ���[Ӱ��(�ް���)
  g_MODE_SANSYOU = 'MODE8';        //�Q�ƌn��ʃJ���[Ӱ��(�ް���)
  g_MODE_MENTE = 'MODE9';          //�}�X�^�����e�n��ʃJ���[Ӱ��(�ް���)
  g_MODE_INPUT = 'INPUT';          //�K�{���̓J���[Ӱ��(�ް���)
  g_MODE_KYOUTYOU = 'KYOUTYOU';    //�����J���[Ӱ��(�ް���)
  //g_MODE_ORDERSINFO = 'ORDERSINFO';//���ޏ��̕\�F(�ް���)
  //g_MODE_SATUEISINFO = 'SATUEISINFO'; //�B�e���̕\�F(�ް���)
  //g_MODE_SATUEI1_COLOR = 'SATUEI1_COLOR'; //�B�e�i��"��"�̐F(�ް���)
  //g_MODE_SATUEI2_COLOR = 'SATUEI2_COLOR'; //�B�e�i��"��"�̐F(�ް���)
  g_MODE_CURSOR_COLOR = 'CURSOR';         //�\�ɃJ�[�\�����������Ă���ꍇ�̐F(�ް���) 2001.02.21
  g_MODE_NOTCURSOR_COLOR = 'NOTCURSOR';         //�\�ɃJ�[�\�����������Ă��Ȃ��ꍇ�̐F(�ް���)
  //g_MODE_SATUEIDISPLAY = 'SATUEIDISPLAY'; //�ĎB�e�A�w���ȍ~��CR/FP���M�̎B�e�i���_�C�A���O�̐F(�ް���) 2001.04.12
  g_MODE_VISUALDISPLAY = 'VISUALDISPLAY'; //�r�W���A���\���̐F(�ް���) 2001.09.23
  g_MODE_SINCHOKU1_COLOR = 'SINCHOKU1';         //���ʐi���װ(��)
  g_MODE_SINCHOKU2_COLOR = 'SINCHOKU2';         //���ʐi���װ(���~)
  g_MODE_RIGBTN_COLOR = 'RIGBTN';         //RIG���M�{�^���װ
  g_MODE_FCRBTN_COLOR = 'FCRBTN';         //FCR���M�{�^���װ
//2002.11.19
  g_MODE_MIUKE = 'MIUKE';               //����t�X�e�[�^�X�\���w�i�F
  g_MODE_YOBIDASI = 'YOBIDASI';         //�ďo�X�e�[�^�X�\���w�i�F
  g_MODE_TIKOKU = 'TIKOKU';             //�x���X�e�[�^�X�\���w�i�F
  g_MODE_UKEZUMI = 'UKEZUMI';           //��t�σX�e�[�^�X�\���w�i�F
  g_MODE_KAKUHO = 'KAKUHO';             //�m�ۃX�e�[�^�X�\���w�i�F
  g_MODE_KENCYUU = 'KENCYUU';           //�������X�e�[�^�X�\���w�i�F
  g_MODE_TAKENCYUU = 'TAKENCYUU';       //�������������X�e�[�^�X�\���w�i�F
  g_MODE_HORYUU = 'HORYUU';             //�ۗ��X�e�[�^�X�\���w�i�F
  g_MODE_SAIYOBI = 'SAIYOBI';           //�Čďo�X�e�[�^�X�\���w�i�F
  g_MODE_SAIUKE = 'SAIUKE';             //�Ď�t�X�e�[�^�X�\���w�i�F
  g_MODE_KENZUMI = 'KENZUMI';           //�����σX�e�[�^�X�\���w�i�F
  g_MODE_CYUUSI = 'CYUUSI';             //���~�X�e�[�^�X�\���w�i�F
  g_MODE_SYUDOU = 'SYUDOU';             //�蓮�\���{�^���F
  g_MODE_JIDOU = 'JIDOU';               //�����\���{�^���F
  g_MODE_OTOKOKUTI = 'OTOKOKUTI';       //�����m�\���{�^���F
//2002.11.19
  g_GET_DATA = 'DATA';             //�擾���ږ�"�ް�"
  g_GET_BIKO = 'BIKO';             //�擾���ږ�"���l"
  g_TIMEKIND = 'TIMEKIND';         //�^�C�}�[�@�\�擾
  g_TIME = 'TIME';                 //�^�C�}�[���Ԏ擾
  g_ROWLIMIT = 'ROWLIMIT';         //�\���ő�s�擾
  g_PRINTER_INFO = 'PRINTER_INFO'; //�v�����^�[���擾
  g_PRINTERNAME = 'PRINTERNAME';   //�v�����^�[���擾
  g_DISPNAME = 'DISPNAME';         //���[�^�C�g���擾
  g_PORTNAME = 'PORTNAME';         //�|�[�g�擾
  g_DRIVERNAME = 'DRIVERNAME';     //�h���C�o�擾
  g_SYSTEM = '*';                  //���і�
  g_COPIES = 'COPIES';             //�������
  g_PRINT_INFO = 'PRINT_INFO';     //�v�����^�[���擾(�[������)
  g_PRINTERNO = 'PRINTERNO';       //�v�����^�[���擾
  g_PRINTTITLE = 'PRINTTITLE';     //���[���َ擾
  g_IRAI_PRINT_INFO = 'IRAI_PRINT_INFO';     //�v�����^�[���擾(�˗��敪����)
  //WORKLIST���
  g_HOSP = 'HOSP';                 //����ݷ�
   g_HOSP_NAME = 'NAME';            //�a�@��
   g_HOSP_NAME_ENG = 'NAMEENGLSH';  //�a�@��(�p��)
   g_HOSP_ADDRESS = 'ADDRESS';      //�a�@�Z��
   g_HOSP_ADDRESS_ENG ='ADDRESSENGLISH'; //�a�@�Z���i�p��j
   g_BUSYO_NAME = 'BUSYO';          //������
   g_BUSYO_NAME_ENG = 'BUSYOENGLISH'; //������(�p��)
   g_HOSP_ZOUEIZAI = 'ZOUEIZAI';   //���ւ�葢�e��
   g_HOSP_ZOUEIZAI_NYUIN  = 'ZOUEIZAI1'; //���ւ�葢�e�܁i���@�j //2003.12.08
   g_HOSP_ZOUEIZAI_GAIRAI = 'ZOUEIZAI2'; //���ւ�葢�e�܁i�O���j //2003.12.08
   g_HOSP_INSATU = 'INSATU';   //���Y���[���
   g_HOSP_RADIOGRAPHYID = 'RADIOGRAPHYID';   //���ː��Ȃh�c
  //2004.01.13
  //���ް�޲���̪���ݒ�
  g_KEYBORDIFKEY = 'KEYBOADIFKEY'; //����ݷ�
   g_KEYBOADIFKEY_DATAKEY = 'SYOKUIN'; //�擾���ږ�"�ް�"
   g_KEYBOADIFKEY_ADDKEYCODE = 'ADDKEYCODE'; //STX�̃L�[�R�[�h 2004.01.29
   g_KEYBOADIFKEY_ADDSTRING = 'ADDSTRING'; //�t���L�����N�^ 2004.01.29
//2003.04.03
   g_HOSP_FILM = 'FILM';   //�t�B���������v�Z�i�t�B����ID�����J���}�ҏW�j
  //2002.10.22 �ǉ�
  g_HOSP_SUID = 'SUID';            //StudyInstancdUID
  //2002.11.05 �ǉ�
  g_HOSP_IRAIDOCTORNO = 'IRAIDOCTORNO'; //�˗��㗘�p�Ҕԍ�
  g_HOSP_DENPYOHOKENPTN = 'DENPYOHOKENPTN'; //�ی��p�^�[��
  //2002.11.27 �ǉ�
  g_HOSP_RISNO  = 'RISNO';              //RIS�I�[�_��Q��
  g_WORKLIST_INFO = 'WORKLISTINFO';//����ݷ�
  g_WORKLIST_UID = 'YCH_UID';      //�R�`Job�C���X�^���XUID
  g_WORKLIST_I_ROMA = 'I_ROMA';    //�\�񂳂ꂽ���s��t��(ROMA)
  g_WORKLIST_I_KANJI = 'I_KANJI';  //�\�񂳂ꂽ���s��t��(����)
  g_WORKLIST_I_KANA = 'I_KANA';    //�\�񂳂ꂽ���s��t��(�J�i)
  //�t�H�[�}�b�g���
  g_FORMAT = 'FORMAT';             //����ݷ�
  g_FORMAT_KANJAID = 'KANJAID';    //����ID�t�H�[�}�b�g
  g_FORMAT_KUGIRI  = 'KUGIRI';     //���
  //�O�����b�Z�[�W�\�����
  g_ZERODISPLAY = 'ZERODISPLAY';   //�O�����b�Z�[�W�\��
  {2001.10.23 Start}
  //����/�����N��͈́i�Z�N�V�����L�[�j
  g_PARAMETER = 'PARAMETER';
  //�����N��͈́i�ް��L�[�j
  g_PARAMETER_NYUUJI = 'NYUUJI';
  //�����N��͈́i�ް��L�[�j
  g_PARAMETER_SHOUNI = 'SHOUNI';
  {2001.10.23 End}
  //IE���
  g_IE_INFO            = 'IE';             //����ݷ�
    g_IE_NAME            = 'NAME';           //IE����
    g_IE_MODULE          = 'MODULE';         //IE���W���[������
    g_IE_VINSTITLE       = 'VINSTITLE';      //IE�摜�A�g�p��׳�ޏI�����ٌ��
    g_IE_REPORTTITLE     = 'REPORTTITLE';    //IE��߰ėp��׳�ޏI�����ٌ��
    g_IE_SHEMA           = 'SHEMA';          //IE���ϗp��׳�ޏI������
  //HTTP���
  g_HTTP_INFO          = 'HTTP';           //����ݷ�
    g_HTTP_REPORT        = 'REPORT';         //���|�[�gHTTP
//2002.11.05 �ǉ�
  //���҃v���t�@�C�����擾���b�Z�[�W
  g_MSG          = 'MSG';           //�擾�v�����b�Z�[�W
//2002.11.08 �ǉ�
  g_FIELDCOLOR         = 'FIELDCOLOR';     //����ݷ�
//2002.11.16 �ǉ�
  //WEB�A�g�p
  g_VINS ='VINS';                  //����ݷ�
  g_VINS_IP ='IP';                 //(�A�g��IP���ڽ)(�ް���)
  g_VINS_WEBDIR ='WEBDIR';         //(�摜�Q�Ɛ� ��Ȳ�/���ډ摜)(�ް���)
  g_VINS_SHOWMODE ='SHOWMODE';     //(�摜�Q�Ɛ� 0:��Ȳ�/1:���ډ摜)(�ް���)
  g_VINS_PATIENTID ='PATIENTID';   //WEB�A�g�p���Ұ�(����ID)
  g_VINS_DATE ='DATE';             //WEB�A�g�p���Ұ�(���t)
  g_VINS_ACCESSION ='ACCESSION';   //WEB�A�g�p���Ұ�(����NO)
  g_VINS_MODALITY ='MODALITY';     //WEB�A�g�p���Ұ�(����è����)
//2002.12.03 �ǉ�
  //��߰ĘA�g�p
  g_REPORT ='REPORT';                   //����ݷ�
  g_REPORT_HTTP ='HTTP';                //��߰�HTTP
  g_REPORT_PATIENTID ='PATIENTID';      //��߰ĘA�g�p���Ұ�(����ID)
  g_REPORT_DATE ='DATE';                //��߰ĘA�g�p���Ұ�(���t)
  g_REPORT_ACCESSION ='ACCESSION';      ///��߰ĘA�g�p���Ұ�(����NO)
  g_REPORT_MODALITY ='MODALITY';        //��߰ĘA�g�p���Ұ�(����è����)
  //2004.01.22
  g_REPORT_YOYAKU = 'YOYAKU';       //��߰ĘA�g�p���Ұ�(ReportRis�o�^�t���O)
//2002.11.22
  g_RENRAKU ='RENRAKU';  //Ҳ��ƭ��p�A������(�ް���)
//2002.11.28
  //MWM�A�g�p
  g_MWM = 'MWM';                   //����ݷ�
  g_MWM_IP ='REMOTEHOST';          //(MWM�ڑ���IP���ڽ)(�ް���)
  g_MWM_PORT ='REMOTEPORT';        //(MWM�ڑ����߰�)(�ް���)
  g_MWM_TIME ='TIMEOUT';           //(MWM��ѱ��)(�ް���)
  //���ϗp
  g_SHEMA ='HTML';                 //����ݷ�
  g_SHEMA_FILE_PASS ='SHEMA';      //���ϵؼ���̧���߽

//2003.12.11 �ǉ�
//�`�[����t���O�p
  g_MARK = 'MARK';               //����ݷ�
  g_MARK_DENPYOPRINT_KEY   = 'DENPYOPRINT';
 g_NAMELABEL_SEC = 'NAMELABLE';
   g_KENSATYPEPRINT_KEY   = 'KENSATYPEPRINT';

//2004.02.05
//RIS�I�[�_�̑��M�L���[�쐬�ݒ�
  g_RISORDER = 'RISORDER';               //����ݷ�
  g_RISORDER_SOUSIN   = 'SOUSIN';        //�ް���

//2004.03.29 �ǉ�
//�I���R�[���\���ݒ�
  g_ON_CALL_SEC = 'ON_CALL';               //����ݷ�
  g_ON_CALL_CHG_KEY   = 'CHG';

//2004.04.09
//�_�~�[����ID�ݒ�
  g_DUMMYKANJA = 'DUMMYKANJA';           //����ݷ�
  g_DUMMYKANJA_KEY = 'ID_';           //�ް����i�ړ��j

//2004.04.28
//W9��ʂ��v���`�F�b�N��ʂ���Ă΂ꂽ�ꍇ�̕\��ID�ݒ�
  g_DISP_COMID = 'DISP_COMID';           //����ݷ�
  g_DISP_COMID_KEY = 'COMID';           //�ް���

  g_MODE_ZOUEIF_COLOR = 'ZOUEIF';         //����������v���e�װ

//������������������������������������������������������������������������������

//�ϐ��錾-------------------------------------------------------------------
var
//ini���Ǎ��� ��������������������������������������������������������������
//�T�u�pDB
   gi_Pls1DB_Name       : string ; //BDE�Őݒ肳�ꂽ�ر���
   gi_Pls1DB_Account    : string ;//ORACL�̃A�J�E���g
   gi_Pls1DB_Pass       : string ;   //ORACL��PASSWORD
   g_Pls1DB_CONECT_MAX  : integer;   //DB�����ڑ��ő吔

//ini���Ǎ��� ����������������������������������������������������������������



//�֐��葱���錾-------------------------------------------------------------
implementation //**************************************************************
//�g�p���j�b�g---------------------------------------------------------------
//uses
//�萔�錾       -------------------------------------------------------------
const
W_KANRI_RMODE = '0';
W_KANRI_WMODE = '1';
//�ϐ��錾     ---------------------------------------------------------------
//var
//�֐��葱���錾--------------------------------------------------------------
initialization
begin
//1)�f�t�H���g�l
(**��
//1)�l�Ǎ�
     gi_Arqs_DB_Name   :=func_ReadIniKeyVale(g_ARQS_SECSION,
                                                   g_ARQS_DB_NAME_KEY,
                                                   gi_Arqs_DB_Name);

*)
//
end;

finalization
begin
//
end;

end.
