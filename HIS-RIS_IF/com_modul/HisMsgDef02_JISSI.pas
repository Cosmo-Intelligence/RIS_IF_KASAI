unit HisMsgDef02_JISSI;
{
���@�\����
  HIS�̒ʐM�d���̒�`
  �����͋L�q���Ȃ�����
  02�d����`
������
�V�K�쐬�F2004.08.30�F���c
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
  ExtCtrls,
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  HisMsgDef;
////�^�N���X�錾-------------------------------------------------------------
//const
//�萔�錾-------------------------------------------------------------------
const
  CST_RI = '02';
  CST_RI_TUI = '10';
  //�e���ڌJ��Ԃ��ő吔
  CST_SYOTI_LOOP = 50;
  CST_KENSA_LOOP = 99;
  //�ő喾�א�
  CST_MEISAI_MAX = 99;
  CST_KENSASIJI_LOOP = 5;
  CST_BUICOM_LOOP = 3;
  CST_FILM_LOOP = 10;
  //�t�B�������L��
  CST_FILM_USED = '1';
  //�t�B������񖳂�
  CST_FILM_NOT_USED = '0';

  //2011.06 DBExpress�Ή�
  (*
  JISSIHOSPCODENO      : Integer = 0;
  JISSIPIDNO           : Integer = 0;
  JISSIORDERNO         : Integer = 0;
  JISSISTARTDATENO     : Integer = 0;
  JISSISTARTTIMENO     : Integer = 0;
  JISSIOPERATIONDATENO : Integer = 0;
  JISSIOPERATIONTIMENO : Integer = 0;
  JISSIJISSICODENO     : Integer = 0;
  JISSIORDERKBNNO      : Integer = 0;
  JISSISECTIONCODENO   : Integer = 0;
  JISSIDRNO            : Integer = 0;
  JISSIKINKYUKBNNO     : Integer = 0;
  JISSISIKYUKBNNO      : Integer = 0;
  JISSIGENZOKBNNO      : Integer = 0;
  JISSIYOYAKUKBNNO     : Integer = 0;
  JISSIDOKUEIKBNNO     : Integer = 0;
  JISSIGROUPCOUNTNO    : Integer = 0;
  JISSIGROUPNO         : Integer = 0;
  JISSIKAIKEIKBNNO     : Integer = 0;
  JISSIJISSIKBNNO      : Integer = 0;
  JISSIKMKCODENO       : Integer = 0;
  JISSIKENSACOUNTNO    : Integer = 0;
  JISSIBUISATUEICODENO : Integer = 0;
  JISSIBUICODENO       : Integer = 0;
  JISSIKENSAROOMCODENO : Integer = 0;
  JISSIPORTABLENO      : Integer = 0;
  JISSIMEISAICOUNTNO   : Integer = 0;
  JISSIYRECORDKBNNO    : Integer = 0;
  JISSIYKMKCODENO      : Integer = 0;
  JISSIYORDERUSENO     : Integer = 0;
  JISSIYBUNKATUNO      : Integer = 0;
  JISSIYYOBINO         : Integer = 0;
  JISSICRECORDKBNNO    : Integer = 0;
  JISSICKMKCODENO      : Integer = 0;
  JISSICCOMNO          : Integer = 0;
  JISSICYOBINO         : Integer = 0;
  *)

  JISSIHOSPCODELEN      = 2;
  JISSIPIDLEN           = 10;
  JISSIORDERLEN         = 16;
  JISSISTARTDATELEN     = 8;
  JISSISTARTTIMELEN     = 4;
  JISSIOPERATIONDATELEN = 8;
  JISSIOPERATIONTIMELEN = 4;
  JISSIJISSICODELEN     = 10;
  JISSIORDERKBNLEN      = 1;
  JISSISECTIONCODELEN   = 2;
  JISSIDRLEN            = 10;
  JISSIKINKYUKBNLEN     = 1;
  JISSISIKYUKBNLEN      = 1;
  JISSIGENZOKBNLEN      = 1;
  JISSIYOYAKUKBNLEN     = 1;
  JISSIDOKUEIKBNLEN     = 1;   
  JISSIGROUPCOUNTLEN    = 2;
  JISSIGROUPLEN         = 3;
  JISSIKAIKEIKBNLEN     = 1;
  JISSIJISSIKBNLEN      = 1;
  JISSIKMKCODELEN       = 6;
  JISSIKENSACOUNTLEN    = 4;
  JISSIBUISATUEICODELEN = 6;
  JISSIBUICODELEN       = 6;
  JISSIKENSAROOMCODELEN = 6;
  JISSIPORTABLELEN      = 1;
  JISSIMEISAICOUNTLEN   = 2;
  JISSIYRECORDKBNLEN    = 2;
  JISSIYKMKCODELEN      = 6;
  JISSIYORDERUSELEN     = 9;
  JISSIYBUNKATULEN      = 2;   
  JISSIYYOBILEN         = 45;
  JISSICRECORDKBNLEN    = 2;
  JISSICKMKCODELEN      = 6;
  JISSICCOMLEN          = 40;
  JISSICYOBILEN         = 16;

  JISSIHOSPCODENAME      = '�a�@�R�[�h';
  JISSIPIDNAME           = '���Ҕԍ�';
  JISSIORDERNAME         = '�I�[�_�ԍ�';
  JISSISTARTDATENAME     = '�J�n��';
  JISSISTARTTIMENAME     = '�J�n����';
  JISSIOPERATIONDATENAME = '���{��';
  JISSIOPERATIONTIMENAME = '���{����';
  JISSIJISSICODENAME     = '���{�҃R�[�h';
  JISSIORDERKBNNAME      = '�I�[�_�敪';
  JISSISECTIONCODENAME   = '�˗��ȃR�[�h';
  JISSIDRNAME            = '�˗���R�[�h';
  JISSIKINKYUKBNNAME     = '�ً}�敪';
  JISSISIKYUKBNNAME      = '���}�敪';
  JISSIGENZOKBNNAME      = '���}�����敪';
  JISSIYOYAKUKBNNAME     = '�ǉe�˗���';
  JISSIDOKUEIKBNNAME     = '�ǉe�σt���O';
  JISSIGROUPCOUNTNAME    = '�O���[�v��';
  JISSIGROUPNAME         = '�O���[�v�ԍ�';
  JISSIKAIKEIKBNNAME     = '��v�敪';
  JISSIJISSIKBNNAME      = '���{�敪';
  JISSIKMKCODENAME       = '���ڃR�[�h';
  JISSIKENSACOUNTNAME    = '������';
  JISSIBUISATUEICODENAME = '�B�e��R�[�h';
  JISSIBUICODENAME       = '���ʃR�[�h';
  JISSIKENSAROOMCODENAME = '�������R�[�h';
  JISSIPORTABLENAME      = '�|�[�^�u��';
  JISSIMEISAICOUNTNAME   = '���א�';
  JISSIYRECORDKBNNAME    = '���R�[�h�敪';
  JISSIYKMKCODENAME      = '��܍��ڃR�[�h';
  JISSIYORDERUSENAME     = '��܃I�[�_�g�p��';
  JISSIYBUNKATUNAME      = '��ܕ�����';
  JISSIYYOBINAME         = '��ܗ\��';
  JISSICRECORDKBNNAME    = '���R�[�h�敪';
  JISSICKMKCODENAME      = '�R�����g���ڃR�[�h';
  JISSICCOMNAME          = '�R�����g�R�����g';
  JISSICYOBINAME         = '�R�����g�\��';

//�ϐ��錾-------------------------------------------------------------------
var
//�d���t�H�[�}�b�g��`�L����
  g_Stream02_JISSI : array[1..G_MSGFNUM_JISSI] of TStreamField;

  //2011.06 DBExpress�Ή�
  JISSIHOSPCODENO      : Integer = 0;
  JISSIPIDNO           : Integer = 0;
  JISSIORDERNO         : Integer = 0;
  JISSISTARTDATENO     : Integer = 0;
  JISSISTARTTIMENO     : Integer = 0;
  JISSIOPERATIONDATENO : Integer = 0;
  JISSIOPERATIONTIMENO : Integer = 0;
  JISSIJISSICODENO     : Integer = 0;
  JISSIORDERKBNNO      : Integer = 0;
  JISSISECTIONCODENO   : Integer = 0;
  JISSIDRNO            : Integer = 0;
  JISSIKINKYUKBNNO     : Integer = 0;
  JISSISIKYUKBNNO      : Integer = 0;
  JISSIGENZOKBNNO      : Integer = 0;
  JISSIYOYAKUKBNNO     : Integer = 0;
  JISSIDOKUEIKBNNO     : Integer = 0;
  JISSIGROUPCOUNTNO    : Integer = 0;
  JISSIGROUPNO         : Integer = 0;
  JISSIKAIKEIKBNNO     : Integer = 0;
  JISSIJISSIKBNNO      : Integer = 0;
  JISSIKMKCODENO       : Integer = 0;
  JISSIKENSACOUNTNO    : Integer = 0;
  JISSIBUISATUEICODENO : Integer = 0;
  JISSIBUICODENO       : Integer = 0;
  JISSIKENSAROOMCODENO : Integer = 0;
  JISSIPORTABLENO      : Integer = 0;
  JISSIMEISAICOUNTNO   : Integer = 0;
  JISSIYRECORDKBNNO    : Integer = 0;
  JISSIYKMKCODENO      : Integer = 0;
  JISSIYORDERUSENO     : Integer = 0;
  JISSIYBUNKATUNO      : Integer = 0;
  JISSIYYOBINO         : Integer = 0;
  JISSICRECORDKBNNO    : Integer = 0;
  JISSICKMKCODENO      : Integer = 0;
  JISSICCOMNO          : Integer = 0;
  JISSICYOBINO         : Integer = 0;

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
  //1
  g_wi := 1;
  g_Stream02_JISSI[g_wi].name   := g_Stream_Base[COMMON1SDIDNO].name;
  g_Stream02_JISSI[g_wi].x9     := g_Stream_Base[COMMON1SDIDNO].x9;
  g_Stream02_JISSI[g_wi].size   := g_Stream_Base[COMMON1SDIDNO].size;
  g_Stream02_JISSI[g_wi].offset := g_Stream_Base[COMMON1SDIDNO].offset;
  //2
  inc(g_wi);
  g_Stream02_JISSI[g_wi].name   := g_Stream_Base[COMMON1RVIDNO].name;
  g_Stream02_JISSI[g_wi].x9     := g_Stream_Base[COMMON1RVIDNO].x9;
  g_Stream02_JISSI[g_wi].size   := g_Stream_Base[COMMON1RVIDNO].size;
  g_Stream02_JISSI[g_wi].offset := g_Stream_Base[COMMON1RVIDNO].offset;
  //3
  inc(g_wi);
  g_Stream02_JISSI[g_wi].name   := g_Stream_Base[COMMON1COMMANDNO].name;
  g_Stream02_JISSI[g_wi].x9     := g_Stream_Base[COMMON1COMMANDNO].x9;
  g_Stream02_JISSI[g_wi].size   := g_Stream_Base[COMMON1COMMANDNO].size;
  g_Stream02_JISSI[g_wi].offset := g_Stream_Base[COMMON1COMMANDNO].offset;
  //4
  inc(g_wi);
  g_Stream02_JISSI[g_wi].name   := g_Stream_Base[COMMON1STATUSNO].name;
  g_Stream02_JISSI[g_wi].x9     := g_Stream_Base[COMMON1STATUSNO].x9;
  g_Stream02_JISSI[g_wi].size   := g_Stream_Base[COMMON1STATUSNO].size;
  g_Stream02_JISSI[g_wi].offset := g_Stream_Base[COMMON1STATUSNO].offset;
  //5
  inc(g_wi);
  g_Stream02_JISSI[g_wi].name   := g_Stream_Base[COMMON1DENLENNO].name;
  g_Stream02_JISSI[g_wi].x9     := g_Stream_Base[COMMON1DENLENNO].x9;
  g_Stream02_JISSI[g_wi].size   := g_Stream_Base[COMMON1DENLENNO].size;
  g_Stream02_JISSI[g_wi].offset := g_Stream_Base[COMMON1DENLENNO].offset;
  //6
  inc(g_wi);
  JISSIHOSPCODENO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIHOSPCODENAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIHOSPCODELEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //7
  inc(g_wi);
  JISSIPIDNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIPIDNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIPIDLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //8
  inc(g_wi);
  JISSIORDERNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIORDERNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIORDERLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //9
  inc(g_wi);
  JISSISTARTDATENO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSISTARTDATENAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSISTARTDATELEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //10
  inc(g_wi);
  JISSISTARTTIMENO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSISTARTTIMENAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSISTARTTIMELEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //11
  inc(g_wi);
  JISSIOPERATIONDATENO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIOPERATIONDATENAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIOPERATIONDATELEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //12
  inc(g_wi);
  JISSIOPERATIONTIMENO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIOPERATIONTIMENAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIOPERATIONTIMELEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //13
  inc(g_wi);
  JISSIJISSICODENO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIJISSICODENAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIJISSICODELEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //14
  inc(g_wi);
  JISSIORDERKBNNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIORDERKBNNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIORDERKBNLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //15
  inc(g_wi);
  JISSISECTIONCODENO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSISECTIONCODENAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSISECTIONCODELEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //16
  inc(g_wi);
  JISSIDRNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIDRNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIDRLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //17
  inc(g_wi);
  JISSIKINKYUKBNNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIKINKYUKBNNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIKINKYUKBNLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //18
  inc(g_wi);
  JISSISIKYUKBNNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSISIKYUKBNNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSISIKYUKBNLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //19
  inc(g_wi);
  JISSIGENZOKBNNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIGENZOKBNNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIGENZOKBNLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //20
  inc(g_wi);
  JISSIYOYAKUKBNNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIYOYAKUKBNNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIYOYAKUKBNLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //21
  inc(g_wi);
  JISSIDOKUEIKBNNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIDOKUEIKBNNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIDOKUEIKBNLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //22
  inc(g_wi);
  JISSIGROUPCOUNTNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIGROUPCOUNTNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIGROUPCOUNTLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //23
  inc(g_wi);
  JISSIGROUPNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIGROUPNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIGROUPLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //24
  inc(g_wi);
  JISSIKAIKEIKBNNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIKAIKEIKBNNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIKAIKEIKBNLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //25
  inc(g_wi);
  JISSIJISSIKBNNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIJISSIKBNNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIJISSIKBNLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //26
  inc(g_wi);
  JISSIKMKCODENO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIKMKCODENAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIKMKCODELEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //27
  inc(g_wi);
  JISSIKENSACOUNTNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIKENSACOUNTNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIKENSACOUNTLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //28
  inc(g_wi);
  JISSIBUISATUEICODENO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIBUISATUEICODENAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIBUISATUEICODELEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //29
  inc(g_wi);
  JISSIBUICODENO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIBUICODENAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIBUICODELEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //30
  inc(g_wi);
  JISSIKENSAROOMCODENO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIKENSAROOMCODENAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIKENSAROOMCODELEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //31
  inc(g_wi);
  JISSIPORTABLENO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIPORTABLENAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIPORTABLELEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //32
  inc(g_wi);
  JISSIMEISAICOUNTNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIMEISAICOUNTNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIMEISAICOUNTLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //33
  inc(g_wi);
  JISSIYRECORDKBNNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIYRECORDKBNNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIYRECORDKBNLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //34
  inc(g_wi);
  JISSIYKMKCODENO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIYKMKCODENAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIYKMKCODELEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //35
  inc(g_wi);
  JISSIYORDERUSENO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIYORDERUSENAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIYORDERUSELEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //36
  inc(g_wi);
  JISSIYBUNKATUNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIYBUNKATUNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIYBUNKATULEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //37
  inc(g_wi);
  JISSIYYOBINO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSIYYOBINAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSIYYOBILEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //38
  inc(g_wi);
  JISSICRECORDKBNNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSICRECORDKBNNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSICRECORDKBNLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //39
  inc(g_wi);
  JISSICKMKCODENO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSICKMKCODENAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSICKMKCODELEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //40
  inc(g_wi);
  JISSICCOMNO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSICCOMNAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSICCOMLEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
  //41
  inc(g_wi);
  JISSICYOBINO := g_wi;
  g_Stream02_JISSI[g_wi].name   := JISSICYOBINAME;
  g_Stream02_JISSI[g_wi].x9     := G_FIELD_C;
  g_Stream02_JISSI[g_wi].size   := JISSICYOBILEN;
  g_Stream02_JISSI[g_wi].offset := g_Stream02_JISSI[g_wi-1].size + g_Stream02_JISSI[g_wi-1].offset;
end;

finalization
begin
//
end;

end.
