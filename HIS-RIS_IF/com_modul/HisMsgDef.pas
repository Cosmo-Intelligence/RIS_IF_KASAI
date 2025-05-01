unit HisMsgDef;
{
���@�\����
  HIS�̒ʐM�d���̋��ʒ�`
  �����͋L�q���Ȃ�����
������
�V�K�쐬�F2004.08.26�F�S�� ���c
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
  //FileCtrl,                     
  Registry,
  ExtCtrls
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  ;
//�Q�ƒ萔-----------------------------------------------------------------
const
  G_MAX_STREAM_SIZE = 65000; //�d�����M�ő�T�C�Y �{����ȯ�ܰ��̐��\�Ō��߂�
  G_ONCE_STREAM_SIZE = 15936; //��x�ɒx���d����
  G_MSG_SYSTEM_C    = 'C';   //�R�}���h
  G_MSG_SYSTEM_A    = 'A';   //�ԓ�

  G_MSGKIND_NONE    = '0'; //���M���b�Z�[�W��� ���� NOP
  G_MSGKIND_IRAI    = '1'; //���M���b�Z�[�W��� �˗�
  G_MSGKIND_JISSI   = '2'; //���M���b�Z�[�W��� ���{
  G_MSGKIND_CANCEL  = '3'; //���M���b�Z�[�W��� �I�[�_�L�����Z��
  G_MSGKIND_KANJA   = '4'; //���M���b�Z�[�W��� ���ҏ��
  G_MSGKIND_KAIKEI  = '5'; //���M���b�Z�[�W��� ��v���
  G_MSGKIND_UKETUKE = '6'; //���M���b�Z�[�W��� ��t
  G_MSGKIND_RESEND  = '7'; //���M���b�Z�[�W��� �đ��v��
  G_MSGKIND_START   = '8'; //���M���b�Z�[�W��� �Z�b�V�����J�n�E�I��

  //�\�P�b�g�d���o�C�i���T�C�Y
  G_MSGSIZE_IRAI    = 65000; // �˗�
  G_MSGSIZE_JISSI   = 65000; // ���{
  G_MSGSIZE_CANCEL  = 110;   // �I�[�_�L�����Z��
  G_MSGSIZE_KANJA   = 567;   // ���ҏ��
  G_MSGSIZE_KAIKEI  = 82;    // ��v���
  G_MSGSIZE_UKETUKE = 93;    // ��t
  G_MSGSIZE_RESEND  = 109;   // �đ��v��
  G_MSGSIZE_START   = 32;    // �Z�b�V�����J�n�E�I��

  G_MSGFNUM_B1     = 5;    //�d����` 1 �` 7 �̃w�b�_����

  G_MSGFNUM_IRAI    = G_MSGFNUM_B1 + 59871; //�d����` �˗�
  G_MSGFNUM_JISSI   = G_MSGFNUM_B1 + 79; //�d����` ���{
  G_MSGFNUM_CANCEL  = G_MSGFNUM_B1 + 8;  //�d����` �I�[�_�L�����Z��
  G_MSGFNUM_KANJA   = G_MSGFNUM_B1 + 31; //�d����` ���ҏ��
  G_MSGFNUM_KAIKEI  = G_MSGFNUM_B1 + 6;  //�d����` ��v���
  G_MSGFNUM_UKETUKE = G_MSGFNUM_B1 + 9;  //�d����` ��t
  G_MSGFNUM_RESEND  = G_MSGFNUM_B1 + 6;  //�d����` �đ��v��
  G_MSGFNUM_START   = G_MSGFNUM_B1;      //�d����` �Z�b�V�����J�n�E�I��
  {
  //���ː��˗����d��
  //���ڃ��[�v�J�n�ʒu
  G_MSG_IRAI_KMK_START  = 48;
  //���ڃ��[�v�I���ʒu
  G_MSG_IRAI_KMK_END    = 52;
  //���ڌ��ʒu
  G_MSG_IRAI_KMK_NO     = 28;
  //���ڌ��ő�l
  G_MSG_IRAI_KMK_MAX    = 300;
  //���ڃ��[�v���ڐ�
  G_MSG_IRAI_KMK_COU    = 5;
  //���ڈꍀ�ڒ�
  G_MSG_IRAI_KMK_LEN    = 69;

  //�v���t�@�C�����[�v�J�n�ʒu
  G_MSG_IRAI_PROF_START = 54;
  //�v���t�@�C�����[�v�I���ʒu
  G_MSG_IRAI_PROF_END   = 58;
  //�v���t�@�C�����ʒu
  G_MSG_IRAI_PROF_NO    = 29;
  //�v���t�@�C�����ő�l
  G_MSG_IRAI_PROF_MAX   = 30;
  //�v���t�@�C�����[�v���ڐ�
  G_MSG_IRAI_PROF_COU   = 5;
  //�v���t�@�C���ꍀ�ڒ�
  G_MSG_IRAI_PROF_LEN   = 91;
  //�f���~�^�ʒu
  G_MSG_IRAI_DERI       = 59;

  //���{�d���p�f���~�^�ʒu
  G_MSG_JISSI_DERI      = 1274;
  }
const
  G_MSG_OUTOU_ED        = 'ED'; //�d���̉������ �Ȃ�
  G_MSG_RESULT_OK       = 'OK'; //�d���̉������ OK
  G_MSG_RESULT_NG       = 'NG'; //�d���̉������ NG
  G_MSG_RESULT_NP       = '  '; //�d���̉������ �m�b�v
  G_MSG_RESULT_NP0      = 'ER'; //�d���̉������ �m�b�v
  G_MSG_KEISIKI_IRAI    = 'F';  //�d��01�̌`����� �˗�
  G_MSG_KEISIKI_KANJA   = 'C';  //�d��01�̌`����� ����
  G_MSG_SHORIKBN_NEW    = '01'; //�d��01 �����敪 �V�K
  G_MSG_SHORIKBN_UP     = '02'; //�d��01 �����敪 �X�V
  G_MSG_SHORIKBN_DEL    = '03'; //�d��01 �����敪 �폜
  G_MSG_DENBUN_SEQ      = '01'; //�d��SEQ
  OFFSETF_SYORI         = 11;
  OFFSETF_OKNG          = 12;
  //OFFSETF_DenbunChou    = 10;
  OFFSET_DenbunChou_13  = 45;
  OFFSETF_DenbunSEQ     = 15;
  CST_RIS_NYUGAI_NYUIN  = '1';  //RIS���@
  CST_RIS_NYUGAI_GAIRAI = '2';  //RIS�O��
  CST_HIS_NYUGAI_NYUIN  = '2';  //HIS���@
  CST_HIS_NYUGAI_GAIRAI = '1';  //HIS�O��
  CST_JISSIDATE_NULL    = '20991231';
  CST_JISSITIME_NULL    = '0000';
  CST_JISSITIME_NULL2   = '9999';
  CST_JISSITIME_NULL3   = '999999';
  //�N��v�Z�s�\�̏ꍇ
  CST_AGE_ERR           = 999;
  //�p���t���O�i�p���L��j
  CST_KEIZOKU           = '1';
  //�p���t���O�i�p�������j
  CST_KEIZOKU_END       = '0';
  //�d��ID
  //AP�f�[�^���M�d��
  CST_DENBUNID_SD       = 'SD';
  //���b�Z�[�W�d��
  CST_DENBUNID_SM       = 'SM';
  //���e�R�[�h
  //�N���C�A���g�˃T�[�o
  CST_DETAILS_C_SS      = 'SS';
  CST_DETAILS_C_SE      = 'SE';
  //�T�[�o�˃N���C�A���g
  CST_DETAILS_S_SS      = 'SS';
  CST_DETAILS_S_ES      = 'ES';
  CST_DETAILS_S_CS      = 'CS';
  CST_DETAILS_S_EC      = 'EC';
  CST_DETAILS_S_RE      = 'RE';
  //OK
  CST_DENBUNID_OK       = '000000';
  //NG
  CST_DENBUNID_NG       = '999999';
  //NG
  CST_DENBUNID_RE       = '??????';
  //�d���R�}���h
  //�I�[�_���
  CST_COMMAND_ORDER       = 'D-ORDDAT';
  //���ҏ��X�V
  CST_COMMAND_KANJAUP     = 'C-KNJUPD';
  //���Ҏ��S�މ@���
  CST_COMMAND_KANJADEL    = 'C-KNJDEL';
  //�I�[�_�L�����Z��
  CST_COMMAND_ORDERCANCEL = 'C-ORDCNL';
  //��v�ʒm
  CST_COMMAND_KAIKEI      = 'C-ORDACC';
  //���Ҏ�t
  CST_COMMAND_UKETUKE     = 'D-PATAPT';
  //�B�e���{�ʒm
  CST_COMMAND_JISSI       = 'D-RETDAT';
  //�I�[�_�đ��v��
  CST_COMMAND_RESEND      = 'D-ORDSND';
  //APP_ID
  //�I�[�_��M�T�[�r�X
  CST_APPID_HRCV01        = 'HRCV01';
  //���ҏ���M�T�[�r�X
	CST_APPID_HRCV02        = 'HRCV02';
  //��v�ʒm��M�T�[�r�X
	CST_APPID_HRCV03        = 'HRCV03';
  //��t�ʒm���M�T�[�r�X
  CST_APPID_HSND01        = 'HSND01';
  //���ё��M�T�[�r�X
	CST_APPID_HSND02        = 'HSND02';
  //�đ��v���T�[�r�X
	CST_APPID_HSND03        = 'HSND03';
  //�\�񑗐M�T�[�r�X�i���Áj
  CST_APPRTID_HSND01        = 'HSND01';
  //���ё��M�T�[�r�X�i���Áj
	CST_APPRTID_HSND02        = 'HSND02';
  //�I�[�_���
  CST_APPTYPE_OI01      = 'OI01';
  //�I�[�_���
  CST_APPTYPE_OI02      = 'OI02';
  //�I�[�_�L�����Z��
  CST_APPTYPE_OI99      = 'OI99';
  //���ҏ��
  CST_APPTYPE_PI01      = 'PI01';
  //���S�މ@���
  CST_APPTYPE_PI99      = 'PI99';
  //��v�ʒm
  CST_APPTYPE_AC01      = 'AC01';
  //��t�ʒm
  CST_APPTYPE_RC01      = 'RC01';
  //��t���
  CST_APPTYPE_RC99      = 'RC99';
  //���{�ʒm
  CST_APPTYPE_OP01      = 'OP01';
  //���{�ʒm�i�đ��j
  CST_APPTYPE_OP02      = 'OP02';
  //���{�ʒm�i���~�j
  CST_APPTYPE_OP99      = 'OP99';
  //�I�[�_�擾
  CST_APPTYPE_OR01      = 'OR01';
  //�V�K�\��
  CST_APPTYPE_OC01      = 'OC01';
  //�\��X�V
  CST_APPTYPE_OC02      = 'OC02';
  //�\��폜
  CST_APPTYPE_OC99      = 'OC99';
  //���ÓK�p�ʒm
  CST_APPTYPE_TQ01      = 'TQ01';
  //���ÓK�p�ʒm�i�đ��j
  CST_APPTYPE_TQ02      = 'TQ02';
  //���ÓK�p�ʒm�i���~�j
  CST_APPTYPE_TQ99      = 'TQ99';

  //�����ʁFHIS��t���M
  CST_OPETYPE_13      = '13';
  //�����ʁFHIS���ё��M
  CST_OPETYPE_24      = '24';
  //���M��
  CST_SOUSIN_FLG      = '01';
  //�ʐM���ʖ���
  CST_ORDER_RES_OK_NAME  = '�n�j';       //�F���M����
  CST_ORDER_RES_NG1_NAME = '���M�s��';   //�F���M���s �ʐM�s��
  CST_ORDER_RES_NG2_NAME = '�d���m�f';   //�F���M���s �d��NG
  CST_ORDER_RES_NG3_NAME = '���g���C';   //�F���M���s �d��NG
  CST_ORDER_RES_CL_NAME  = '�L�����Z��'; //�F���M�L�����Z��
  //�đ��i�I�[�_�ԍ��g�p�j
  CST_RESEND_ORDER = '1';

  //���
  CST_RECORD_KBN_20     = '20';
  //��Z
  CST_RECORD_KBN_30     = '30';
  //��Z
  CST_RECORD_KBN_41     = '41';
  //��Z
  CST_RECORD_KBN_42     = '42';
  //��Z
  CST_RECORD_KBN_45     = '45';
  //��Z
  CST_RECORD_KBN_60     = '60';
  //�ޗ�
  CST_RECORD_KBN_50     = '50';
  //�t�B����
  CST_RECORD_KBN_57     = '57';
  //�V�F�[�}
  CST_RECORD_KBN_95     = '95';
  //��������
  CST_RECORD_KBN_88     = '88';
  //�ǉe�R�����g
  CST_RECORD_KBN_90     = '90';
  //�a��
  CST_RECORD_KBN_91     = '91';
  //�����ړI
  CST_RECORD_KBN_92     = '92';
  //���ʎw��
  CST_RECORD_KBN_93     = '93';
  //���̑��ڍ�
  CST_RECORD_KBN_94     = '94';
  //�I���R�����g
  CST_RECORD_KBN_97     = '97';
  //�K�{�R�����g
  CST_RECORD_KBN_98     = '98';
  //�t���[�R�����g
  CST_RECORD_KBN_99     = '99';
  //��������
  CST_RECORD_KBN_88_TITLE = '�y�������ʁz';
  //�ǉe�R�����g
  CST_RECORD_KBN_90_TITLE = '�y�ǉe�R�����g�z';

  //�V�F�[�}�X�e�[�^�X
  //���擾
  CST_SHEMAFLG_00       = '00';
  //���s
  CST_SHEMAFLG_09       = '09';
  //��
  CST_SHEMAFLG_10       = '10';

  //RIS�I�[�_
  CST_ORDER_KBN_0     = '0';
  //HIS�I�[�_
  CST_ORDER_KBN_1     = '1';

  //�����敪�F��t
  CST_ORDER_RECEIPT_0 = '0';
  //�����敪�F�L�����Z��
  CST_ORDER_RECEIPT_1 = '1';

  //���Z�敪�F��
  CST_SEISAN_0 = '0';
  //���Z�敪�F��
  CST_SEISAN_1 = '1';

  //��v�敪�F�I�����C��
  CST_HISKAIKEI_Y = 'Y';
  //��v�敪�F�I�t���C��
  CST_HISKAIKEI_Z = 'Z';
  //��v�敪�F�I�����C��
  CST_RISKAIKEI_Y = '1';
  //��v�敪�F�I�t���C��
  CST_RISKAIKEI_Z = '0';

  //���{�敪�F���{
  CST_HISJISSI_Y = 'Y';
  //���{�敪�F���~
  CST_HISJISSI_Z = 'Z';
  //���{�敪�F���{
  CST_RISJISSI_Y = '1';
  //���{�敪�F���~
  CST_RISJISSI_Z = '2';

  //�a�@�R�[�h
  CST_HOSPCODE = '01';
  //IP�A�h���X�E�|�[�g��؂蕶��
  CST_IPPORT_SP = ';';

  // ����
  //HIS�R�[�h
  //��
  CST_SEX_0 = '0';
  //�j
  CST_SEX_1 = '1';
  //�s��
  CST_SEX_2 = '';
  //RIS�R�[�h
  //��
  CST_SEX_0_NAME = 'F';
  //�j
  CST_SEX_1_NAME = 'M';
  //�s���i�\���p�j
  CST_SEX_9_NAME = '�s��';
  //�s���i�R�[�h�j
  CST_SEX_9P_NAME = 'O';
  //�j
  CST_SEX_1_THERA = '1';
  //��
  CST_SEX_2_THERA = '2';
  //�s��
  CST_SEX_3_THERA = '3';

  // ���O�敪
  //HIS�R�[�h
  //���@
  CST_HIS_NYUGAIKBN_N = 'N';
  //�O��
  CST_HIS_NYUGAIKBN_G = 'G';
  //���@���O��
  CST_HIS_NYUGAIKBN_C = 'C';
  //RIS�R�[�h
  //���@
  CST_RIS_NYUGAIKBN_N = '2';
  //�O��
  CST_RIS_NYUGAIKBN_G = '1';
  //���@���O��
  CST_RIS_NYUGAIKBN_C = '3';
  //����
  CST_NYUGAIKBN_N_NAME = '���@';
  CST_NYUGAIKBN_G_NAME = '�O��';
  CST_NYUGAIKBN_C_NAME = '���@���O��';
  //���ʃR�����g�̍ő�i�[��
  CST_BUICOM_MAX = 5;
  //�g��Null�l
  CST_HEIGTH_NULL = '00000';
  //�̏dNull�l
  CST_WEIGTH_NULL = '00000';
  // �D�P���
  //�Ȃ�
  CST_NINSIN_0 = '0';
  //�L��
  CST_NINSIN_1 = '1';

  //�X�^�f�B�[�C���X�^���XUID
  CST_STUDYINSTANCEUID_FIXED = '1.2.392.200045.6960.4.7.';

  //���ҏZ���Ή�
  CST_POSTCODE_1 = '��';
  CST_POSTCODE_2 = '-';
  CST_TEL = '�d�b�ԍ��F';
  // �Ō�敪�E���ҋ敪
  //�Ȃ�
  CST_NOTES_0 = '0';
  //�L��
  CST_NOTES_1 = '1';

  //�J��Ԃ��J�n�ʒu
  CST_IRAI_LOOPSTART = 55;
  //�J��Ԃ��J�n�ʒu
  CST_JISSI_LOOPSTART = 22;

  CST_SENDTO = 'SVIF12';
  CST_FROMTO = 'RIS   ';

  //2011.06 DBExpress�Ή�
  (*
  COMMON1SDIDNO    : Integer = 0;
  COMMON1RVIDNO    : Integer = 0;
  COMMON1COMMANDNO : Integer = 0;
  COMMON1STATUSNO  : Integer = 0;
  COMMON1DENLENNO  : Integer = 0;
  *)

  COMMON1SDIDLEN    = 6;
  COMMON1RVIDLEN    = 6;
  COMMON1COMMANDLEN = 8;
  COMMON1STATUSLEN  = 6;
  COMMON1DENLENLEN  = 6;

  COMMON1SDIDNAME    = '���M��ID';
  COMMON1RVIDNAME    = '���M��ID';
  COMMON1COMMANDNAME = '�����R�}���h';
  COMMON1STATUSNAME  = '��M����';
  COMMON1DENLENNAME  = '�d����';

const
  G_FIELD_C  = 'X';  //�d����` �t�B�[���h��� ����
  G_FIELD_N  = '9';  //�d����` �t�B�[���h��� ����
////�^�N���X�錾-------------------------------------------------------------
type //�d����`��
  TStreamField = record
     name   : String[50]; //����
     x9     : String[1];  //��� X 9
     size   : Integer;    //�T�C�Y
     offset : Integer;    //�I�t�Z�b�g
  End;

type
  TBuffur = record
    data  : array[1..G_MAX_STREAM_SIZE] of byte
  End;
type TBuf = array of byte;
//�S�d���o�C�i���n
type
  TStream_Data = TStringStream;
//�萔�錾-------------------------------------------------------------------
//�ϐ��錾-------------------------------------------------------------------
var
//�d���t�H�[�}�b�g��`�L���� ���g�p
  g_Stream_Base : array[1..G_MSGFNUM_B1] of TStreamField;

  //2011.06 DBExpress�Ή�
  COMMON1SDIDNO    : Integer = 0;
  COMMON1RVIDNO    : Integer = 0;
  COMMON1COMMANDNO : Integer = 0;
  COMMON1STATUSNO  : Integer = 0;
  COMMON1DENLENNO  : Integer = 0;
//�֐��葱���錾-------------------------------------------------------------

implementation //**************************************************************

//�g�p���j�b�g---------------------------------------------------------------
//uses

//�萔�錾       -------------------------------------------------------------
//const

//�ϐ��錾     ---------------------------------------------------------------
var
  g_wi  : INTEGER;
//�֐��葱���錾--------------------------------------------------------------

initialization
begin
  //
  g_wi := 1;
  COMMON1SDIDNO := g_wi;
  g_Stream_Base[g_wi].name   := COMMON1SDIDNAME;
  g_Stream_Base[g_wi].x9     := G_FIELD_C;
  g_Stream_Base[g_wi].size   := COMMON1SDIDLEN;
  g_Stream_Base[g_wi].offset := 0;
  //
  inc(g_wi);
  COMMON1RVIDNO := g_wi;
  g_Stream_Base[g_wi].name   := COMMON1RVIDNAME;
  g_Stream_Base[g_wi].x9     := G_FIELD_C;
  g_Stream_Base[g_wi].size   := COMMON1RVIDLEN;
  g_Stream_Base[g_wi].offset := g_Stream_Base[g_wi - 1].size + g_Stream_Base[g_wi - 1].offset;
  //
  inc(g_wi);
  COMMON1COMMANDNO := g_wi;
  g_Stream_Base[g_wi].name   := COMMON1COMMANDNAME;
  g_Stream_Base[g_wi].x9     := G_FIELD_C;
  g_Stream_Base[g_wi].size   := COMMON1COMMANDLEN;
  g_Stream_Base[g_wi].offset := g_Stream_Base[g_wi - 1].size + g_Stream_Base[g_wi - 1].offset;
  //
  inc(g_wi);
  COMMON1STATUSNO := g_wi;
  g_Stream_Base[g_wi].name   := COMMON1STATUSNAME;
  g_Stream_Base[g_wi].x9     := G_FIELD_C;
  g_Stream_Base[g_wi].size   := COMMON1STATUSLEN;
  g_Stream_Base[g_wi].offset := g_Stream_Base[g_wi - 1].size + g_Stream_Base[g_wi - 1].offset;
  //
  inc(g_wi);
  COMMON1DENLENNO := g_wi;
  g_Stream_Base[g_wi].name   := COMMON1DENLENNAME;
  g_Stream_Base[g_wi].x9     := G_FIELD_C;
  g_Stream_Base[g_wi].size   := COMMON1DENLENLEN;
  g_Stream_Base[g_wi].offset := g_Stream_Base[g_wi - 1].size + g_Stream_Base[g_wi - 1].offset;
end;

finalization
begin
//
end;

end.
