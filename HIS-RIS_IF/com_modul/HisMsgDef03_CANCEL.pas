unit HisMsgDef03_CANCEL;
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
  IRAICCOMMANDNO    : Integer = 0;
  IRAICHOSPCODENO   : Integer = 0;
  IRAICPIDNO        : Integer = 0;
  IRAICORDERNO      : Integer = 0;
  IRAICSTARTDATENO  : Integer = 0;
  IRAICSTARTTIMENO  : Integer = 0;
  IRAICOPERATCODENO : Integer = 0;
  IRAICOPERATNAMENO : Integer = 0;
  *)

  IRAICCOMMANDLEN    = 8;
  IRAICHOSPCODELEN   = 2;
  IRAICPIDLEN        = 10;
  IRAICORDERLEN      = 16;
  IRAICSTARTDATELEN  = 8;
  IRAICSTARTTIMELEN  = 4;
  IRAICOPERATCODELEN = 10;
  IRAICOPERATNAMELEN = 20;

  IRAICCOMMANDNAME    = '�R�}���h��';
  IRAICHOSPCODENAME   = '�a�@�R�[�h';
  IRAICPIDNAME        = '���Ҕԍ�';
  IRAICORDERNAME      = '�I�[�_�ԍ�';
  IRAICSTARTDATENAME  = '�J�n��';
  IRAICSTARTTIMENAME  = '�J�n����';
  IRAICOPERATCODENAME = '����҃R�[�h';
  IRAICOPERATNAMENAME = '����Җ�';
//�ϐ��錾-------------------------------------------------------------------
var
//�d���t�H�[�}�b�g��`�L����
  g_Stream03_CANCEL     : array[1..G_MSGFNUM_CANCEL] of TStreamField;

  //2011.06 DBExpress�Ή�
  IRAICCOMMANDNO    : Integer = 0;
  IRAICHOSPCODENO   : Integer = 0;
  IRAICPIDNO        : Integer = 0;
  IRAICORDERNO      : Integer = 0;
  IRAICSTARTDATENO  : Integer = 0;
  IRAICSTARTTIMENO  : Integer = 0;
  IRAICOPERATCODENO : Integer = 0;
  IRAICOPERATNAMENO : Integer = 0;

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
  g_Stream03_CANCEL[g_wi].name   := g_Stream_Base[COMMON1SDIDNO].name;
  g_Stream03_CANCEL[g_wi].x9     := g_Stream_Base[COMMON1SDIDNO].x9;
  g_Stream03_CANCEL[g_wi].size   := g_Stream_Base[COMMON1SDIDNO].size;
  g_Stream03_CANCEL[g_wi].offset := g_Stream_Base[COMMON1SDIDNO].offset;
  //2
  inc(g_wi);
  g_Stream03_CANCEL[g_wi].name   := g_Stream_Base[COMMON1RVIDNO].name;
  g_Stream03_CANCEL[g_wi].x9     := g_Stream_Base[COMMON1RVIDNO].x9;
  g_Stream03_CANCEL[g_wi].size   := g_Stream_Base[COMMON1RVIDNO].size;
  g_Stream03_CANCEL[g_wi].offset := g_Stream_Base[COMMON1RVIDNO].offset;
  //3
  inc(g_wi);
  g_Stream03_CANCEL[g_wi].name   := g_Stream_Base[COMMON1COMMANDNO].name;
  g_Stream03_CANCEL[g_wi].x9     := g_Stream_Base[COMMON1COMMANDNO].x9;
  g_Stream03_CANCEL[g_wi].size   := g_Stream_Base[COMMON1COMMANDNO].size;
  g_Stream03_CANCEL[g_wi].offset := g_Stream_Base[COMMON1COMMANDNO].offset;
  //4
  inc(g_wi);
  g_Stream03_CANCEL[g_wi].name   := g_Stream_Base[COMMON1STATUSNO].name;
  g_Stream03_CANCEL[g_wi].x9     := g_Stream_Base[COMMON1STATUSNO].x9;
  g_Stream03_CANCEL[g_wi].size   := g_Stream_Base[COMMON1STATUSNO].size;
  g_Stream03_CANCEL[g_wi].offset := g_Stream_Base[COMMON1STATUSNO].offset;
  //5
  inc(g_wi);
  g_Stream03_CANCEL[g_wi].name   := g_Stream_Base[COMMON1DENLENNO].name;
  g_Stream03_CANCEL[g_wi].x9     := g_Stream_Base[COMMON1DENLENNO].x9;
  g_Stream03_CANCEL[g_wi].size   := g_Stream_Base[COMMON1DENLENNO].size;
  g_Stream03_CANCEL[g_wi].offset := g_Stream_Base[COMMON1DENLENNO].offset;
  //14
  inc(g_wi);
  IRAICCOMMANDNO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICCOMMANDNAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICCOMMANDLEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
  //15
  inc(g_wi);
  IRAICHOSPCODENO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICHOSPCODENAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICHOSPCODELEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
  //16
  inc(g_wi);
  IRAICPIDNO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICPIDNAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICPIDLEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
  //17
  inc(g_wi);
  IRAICORDERNO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICORDERNAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICORDERLEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
  //18
  inc(g_wi);
  IRAICSTARTDATENO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICSTARTDATENAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICSTARTDATELEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
  //19
  inc(g_wi);
  IRAICSTARTTIMENO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICSTARTTIMENAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICSTARTTIMELEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
  //20
  inc(g_wi);
  IRAICOPERATCODENO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICOPERATCODENAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICOPERATCODELEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
  //21
  inc(g_wi);
  IRAICOPERATNAMENO := g_wi;
  g_Stream03_CANCEL[g_wi].name   := IRAICOPERATNAMENAME;
  g_Stream03_CANCEL[g_wi].x9     := G_FIELD_C;
  g_Stream03_CANCEL[g_wi].size   := IRAICOPERATNAMELEN;
  g_Stream03_CANCEL[g_wi].offset := g_Stream03_CANCEL[g_wi-1].size+g_Stream03_CANCEL[g_wi-1].offset;
end;

finalization
begin
//
end;

end.
