unit HisMsgDef06_RCE;
{
���@�\����
  HIS�̒ʐM�d���̒�`
  �����͋L�q���Ȃ�����
  01�d����`
������
�V�K�쐬�F2004.08.27�F�S�� ���c
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
//�萔�錾-------------------------------------------------------------------
const
  //2011.06 DBExpress�Ή�
  (*
  RECSYORIKBNNO    : Integer = 0;
  RECHOSPCODENO    : Integer = 0;
  RECPIDNO         : Integer = 0;
  RECORDERNO       : Integer = 0;
  RECSTARTDATENO   : Integer = 0;
  RECSTARTTIMENO   : Integer = 0;
  RECUKETUKEDATENO : Integer = 0;
  RECUKETUKETIMENO : Integer = 0;
  RECUKETUKEUSERNO : Integer = 0;
  *)

  RECSYORIKBNLEN    = 1;
  RECHOSPCODELEN    = 2;
  RECPIDLEN         = 10;
  RECORDERLEN       = 16;
  RECSTARTDATELEN   = 8;
  RECSTARTTIMELEN   = 4;
  RECUKETUKEDATELEN = 8;
  RECUKETUKETIMELEN = 4;
  RECUKETUKEUSERLEN = 10;

  RECSYORIKBNNAME    = '�����敪';
  RECHOSPCODENAME    = '�a�@�R�[�h';
  RECPIDNAME         = '���Ҕԍ�';
  RECORDERNAME       = '�I�[�_�ԍ�';
  RECSTARTDATENAME   = '�J�n��';
  RECSTARTTIMENAME   = '�J�n����';
  RECUKETUKEDATENAME = '��t��';
  RECUKETUKETIMENAME = '��t����';
  RECUKETUKEUSERNAME = '��t�҃R�[�h';
//�ϐ��錾-------------------------------------------------------------------
var
//�d���t�H�[�}�b�g��`�L����
  g_Stream06_RCE     : array[1..G_MSGFNUM_UKETUKE] of TStreamField;

  //2011.06 DBExpress�Ή�
  RECSYORIKBNNO    : Integer = 0;
  RECHOSPCODENO    : Integer = 0;
  RECPIDNO         : Integer = 0;
  RECORDERNO       : Integer = 0;
  RECSTARTDATENO   : Integer = 0;
  RECSTARTTIMENO   : Integer = 0;
  RECUKETUKEDATENO : Integer = 0;
  RECUKETUKETIMENO : Integer = 0;
  RECUKETUKEUSERNO : Integer = 0;

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
  g_Stream06_RCE[g_wi].name   := g_Stream_Base[COMMON1SDIDNO].name;
  g_Stream06_RCE[g_wi].x9     := g_Stream_Base[COMMON1SDIDNO].x9;
  g_Stream06_RCE[g_wi].size   := g_Stream_Base[COMMON1SDIDNO].size;
  g_Stream06_RCE[g_wi].offset := g_Stream_Base[COMMON1SDIDNO].offset;
  //2
  inc(g_wi);
  g_Stream06_RCE[g_wi].name   := g_Stream_Base[COMMON1RVIDNO].name;
  g_Stream06_RCE[g_wi].x9     := g_Stream_Base[COMMON1RVIDNO].x9;
  g_Stream06_RCE[g_wi].size   := g_Stream_Base[COMMON1RVIDNO].size;
  g_Stream06_RCE[g_wi].offset := g_Stream_Base[COMMON1RVIDNO].offset;
  //3
  inc(g_wi);
  g_Stream06_RCE[g_wi].name   := g_Stream_Base[COMMON1COMMANDNO].name;
  g_Stream06_RCE[g_wi].x9     := g_Stream_Base[COMMON1COMMANDNO].x9;
  g_Stream06_RCE[g_wi].size   := g_Stream_Base[COMMON1COMMANDNO].size;
  g_Stream06_RCE[g_wi].offset := g_Stream_Base[COMMON1COMMANDNO].offset;
  //4
  inc(g_wi);
  g_Stream06_RCE[g_wi].name   := g_Stream_Base[COMMON1STATUSNO].name;
  g_Stream06_RCE[g_wi].x9     := g_Stream_Base[COMMON1STATUSNO].x9;
  g_Stream06_RCE[g_wi].size   := g_Stream_Base[COMMON1STATUSNO].size;
  g_Stream06_RCE[g_wi].offset := g_Stream_Base[COMMON1STATUSNO].offset;
  //5
  inc(g_wi);
  g_Stream06_RCE[g_wi].name   := g_Stream_Base[COMMON1DENLENNO].name;
  g_Stream06_RCE[g_wi].x9     := g_Stream_Base[COMMON1DENLENNO].x9;
  g_Stream06_RCE[g_wi].size   := g_Stream_Base[COMMON1DENLENNO].size;
  g_Stream06_RCE[g_wi].offset := g_Stream_Base[COMMON1DENLENNO].offset;
  //14
  inc(g_wi);
  RECSYORIKBNNO := g_wi;
  g_Stream06_RCE[g_wi].name   := RECSYORIKBNNAME;
  g_Stream06_RCE[g_wi].x9     := G_FIELD_C;
  g_Stream06_RCE[g_wi].size   := RECSYORIKBNLEN;
  g_Stream06_RCE[g_wi].offset := g_Stream06_RCE[g_wi-1].size+g_Stream06_RCE[g_wi-1].offset;
  //15
  inc(g_wi);
  RECHOSPCODENO := g_wi;
  g_Stream06_RCE[g_wi].name   := RECHOSPCODENAME;
  g_Stream06_RCE[g_wi].x9     := G_FIELD_C;
  g_Stream06_RCE[g_wi].size   := RECHOSPCODELEN;
  g_Stream06_RCE[g_wi].offset := g_Stream06_RCE[g_wi-1].size+g_Stream06_RCE[g_wi-1].offset;
  //16
  inc(g_wi);
  RECPIDNO := g_wi;
  g_Stream06_RCE[g_wi].name   := RECPIDNAME;
  g_Stream06_RCE[g_wi].x9     := G_FIELD_C;
  g_Stream06_RCE[g_wi].size   := RECPIDLEN;
  g_Stream06_RCE[g_wi].offset := g_Stream06_RCE[g_wi-1].size+g_Stream06_RCE[g_wi-1].offset;
  //17
  inc(g_wi);
  RECORDERNO := g_wi;
  g_Stream06_RCE[g_wi].name   := RECORDERNAME;
  g_Stream06_RCE[g_wi].x9     := G_FIELD_C;
  g_Stream06_RCE[g_wi].size   := RECORDERLEN;
  g_Stream06_RCE[g_wi].offset := g_Stream06_RCE[g_wi-1].size+g_Stream06_RCE[g_wi-1].offset;
  //18
  inc(g_wi);
  RECSTARTDATENO := g_wi;
  g_Stream06_RCE[g_wi].name   := RECSTARTDATENAME;
  g_Stream06_RCE[g_wi].x9     := G_FIELD_C;
  g_Stream06_RCE[g_wi].size   := RECSTARTDATELEN;
  g_Stream06_RCE[g_wi].offset := g_Stream06_RCE[g_wi-1].size+g_Stream06_RCE[g_wi-1].offset;
  //19
  inc(g_wi);
  RECSTARTTIMENO := g_wi;
  g_Stream06_RCE[g_wi].name   := RECSTARTTIMENAME;
  g_Stream06_RCE[g_wi].x9     := G_FIELD_C;
  g_Stream06_RCE[g_wi].size   := RECSTARTTIMELEN;
  g_Stream06_RCE[g_wi].offset := g_Stream06_RCE[g_wi-1].size+g_Stream06_RCE[g_wi-1].offset;
  //20
  inc(g_wi);
  RECUKETUKEDATENO := g_wi;
  g_Stream06_RCE[g_wi].name   := RECUKETUKEDATENAME;
  g_Stream06_RCE[g_wi].x9     := G_FIELD_C;
  g_Stream06_RCE[g_wi].size   := RECUKETUKEDATELEN;
  g_Stream06_RCE[g_wi].offset := g_Stream06_RCE[g_wi-1].size+g_Stream06_RCE[g_wi-1].offset;
  //21
  inc(g_wi);
  RECUKETUKETIMENO := g_wi;
  g_Stream06_RCE[g_wi].name   := RECUKETUKETIMENAME;
  g_Stream06_RCE[g_wi].x9     := G_FIELD_C;
  g_Stream06_RCE[g_wi].size   := RECUKETUKETIMELEN;
  g_Stream06_RCE[g_wi].offset := g_Stream06_RCE[g_wi-1].size+g_Stream06_RCE[g_wi-1].offset;
  //21
  inc(g_wi);
  RECUKETUKEUSERNO := g_wi;
  g_Stream06_RCE[g_wi].name   := RECUKETUKEUSERNAME;
  g_Stream06_RCE[g_wi].x9     := G_FIELD_C;
  g_Stream06_RCE[g_wi].size   := RECUKETUKEUSERLEN;
  g_Stream06_RCE[g_wi].offset := g_Stream06_RCE[g_wi-1].size+g_Stream06_RCE[g_wi-1].offset;
end;

finalization
begin
//
end;

end.
