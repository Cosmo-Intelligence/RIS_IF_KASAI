unit HisMsgDef05_KAIKEI;
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
  KAIKEICOMMANDNO    : Integer = 0;
  KAIKEIHOSPCODENO   : Integer = 0;
  KAIKEIPIDNO        : Integer = 0;
  KAIKEIORDERNO      : Integer = 0;
  KAIKEIKAIKEIDATENO : Integer = 0;
  KAIKEIKAIKEITIMENO : Integer = 0;
  *)

  KAIKEICOMMANDLEN    = 8;
  KAIKEIHOSPCODELEN   = 2;
  KAIKEIPIDLEN        = 10;
  KAIKEIORDERLEN      = 16;
  KAIKEIKAIKEIDATELEN = 8;
  KAIKEIKAIKEITIMELEN = 6;

  KAIKEICOMMANDNAME    = '�R�}���h��';
  KAIKEIHOSPCODENAME   = '�a�@�R�[�h';
  KAIKEIPIDNAME        = '���Ҕԍ�';
  KAIKEIORDERNAME      = '�I�[�_�ԍ�';
  KAIKEIKAIKEIDATENAME = '��v���{��';
  KAIKEIKAIKEITIMENAME = '��v���{����';
  
  CST_RISTYPE = '1';
  CST_THERARISTYPE = '2';
  CST_REPORTTYPE = '3';
//�ϐ��錾-------------------------------------------------------------------
var
//�d���t�H�[�}�b�g��`�L����
  g_Stream05_KAIKEI     : array[1..G_MSGFNUM_KAIKEI] of TStreamField;

  //2011.06 DBExpress�Ή�
  KAIKEICOMMANDNO    : Integer = 0;
  KAIKEIHOSPCODENO   : Integer = 0;
  KAIKEIPIDNO        : Integer = 0;
  KAIKEIORDERNO      : Integer = 0;
  KAIKEIKAIKEIDATENO : Integer = 0;
  KAIKEIKAIKEITIMENO : Integer = 0;

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
  g_Stream05_KAIKEI[g_wi].name   := g_Stream_Base[COMMON1SDIDNO].name;
  g_Stream05_KAIKEI[g_wi].x9     := g_Stream_Base[COMMON1SDIDNO].x9;
  g_Stream05_KAIKEI[g_wi].size   := g_Stream_Base[COMMON1SDIDNO].size;
  g_Stream05_KAIKEI[g_wi].offset := g_Stream_Base[COMMON1SDIDNO].offset;
  //2
  inc(g_wi);
  g_Stream05_KAIKEI[g_wi].name   := g_Stream_Base[COMMON1RVIDNO].name;
  g_Stream05_KAIKEI[g_wi].x9     := g_Stream_Base[COMMON1RVIDNO].x9;
  g_Stream05_KAIKEI[g_wi].size   := g_Stream_Base[COMMON1RVIDNO].size;
  g_Stream05_KAIKEI[g_wi].offset := g_Stream_Base[COMMON1RVIDNO].offset;
  //3
  inc(g_wi);
  g_Stream05_KAIKEI[g_wi].name   := g_Stream_Base[COMMON1COMMANDNO].name;
  g_Stream05_KAIKEI[g_wi].x9     := g_Stream_Base[COMMON1COMMANDNO].x9;
  g_Stream05_KAIKEI[g_wi].size   := g_Stream_Base[COMMON1COMMANDNO].size;
  g_Stream05_KAIKEI[g_wi].offset := g_Stream_Base[COMMON1COMMANDNO].offset;
  //4
  inc(g_wi);
  g_Stream05_KAIKEI[g_wi].name   := g_Stream_Base[COMMON1STATUSNO].name;
  g_Stream05_KAIKEI[g_wi].x9     := g_Stream_Base[COMMON1STATUSNO].x9;
  g_Stream05_KAIKEI[g_wi].size   := g_Stream_Base[COMMON1STATUSNO].size;
  g_Stream05_KAIKEI[g_wi].offset := g_Stream_Base[COMMON1STATUSNO].offset;
  //5
  inc(g_wi);
  g_Stream05_KAIKEI[g_wi].name   := g_Stream_Base[COMMON1DENLENNO].name;
  g_Stream05_KAIKEI[g_wi].x9     := g_Stream_Base[COMMON1DENLENNO].x9;
  g_Stream05_KAIKEI[g_wi].size   := g_Stream_Base[COMMON1DENLENNO].size;
  g_Stream05_KAIKEI[g_wi].offset := g_Stream_Base[COMMON1DENLENNO].offset;
  //14
  inc(g_wi);
  KAIKEICOMMANDNO := g_wi;
  g_Stream05_KAIKEI[g_wi].name   := KAIKEICOMMANDNAME;
  g_Stream05_KAIKEI[g_wi].x9     := G_FIELD_C;
  g_Stream05_KAIKEI[g_wi].size   := KAIKEICOMMANDLEN;
  g_Stream05_KAIKEI[g_wi].offset := g_Stream05_KAIKEI[g_wi-1].size+g_Stream05_KAIKEI[g_wi-1].offset;
  //15
  inc(g_wi);
  KAIKEIHOSPCODENO := g_wi;
  g_Stream05_KAIKEI[g_wi].name   := KAIKEIHOSPCODENAME;
  g_Stream05_KAIKEI[g_wi].x9     := G_FIELD_C;
  g_Stream05_KAIKEI[g_wi].size   := KAIKEIHOSPCODELEN;
  g_Stream05_KAIKEI[g_wi].offset := g_Stream05_KAIKEI[g_wi-1].size+g_Stream05_KAIKEI[g_wi-1].offset;
  //16
  inc(g_wi);
  KAIKEIPIDNO := g_wi;
  g_Stream05_KAIKEI[g_wi].name   := KAIKEIPIDNAME;
  g_Stream05_KAIKEI[g_wi].x9     := G_FIELD_C;
  g_Stream05_KAIKEI[g_wi].size   := KAIKEIPIDLEN;
  g_Stream05_KAIKEI[g_wi].offset := g_Stream05_KAIKEI[g_wi-1].size+g_Stream05_KAIKEI[g_wi-1].offset;
  //17
  inc(g_wi);
  KAIKEIORDERNO := g_wi;
  g_Stream05_KAIKEI[g_wi].name   := KAIKEIORDERNAME;
  g_Stream05_KAIKEI[g_wi].x9     := G_FIELD_C;
  g_Stream05_KAIKEI[g_wi].size   := KAIKEIORDERLEN;
  g_Stream05_KAIKEI[g_wi].offset := g_Stream05_KAIKEI[g_wi-1].size+g_Stream05_KAIKEI[g_wi-1].offset;
  //18
  inc(g_wi);
  KAIKEIKAIKEIDATENO := g_wi;
  g_Stream05_KAIKEI[g_wi].name   := KAIKEIKAIKEIDATENAME;
  g_Stream05_KAIKEI[g_wi].x9     := G_FIELD_C;
  g_Stream05_KAIKEI[g_wi].size   := KAIKEIKAIKEIDATELEN;
  g_Stream05_KAIKEI[g_wi].offset := g_Stream05_KAIKEI[g_wi-1].size+g_Stream05_KAIKEI[g_wi-1].offset;
  //19
  inc(g_wi);
  KAIKEIKAIKEITIMENO := g_wi;
  g_Stream05_KAIKEI[g_wi].name   := KAIKEIKAIKEITIMENAME;
  g_Stream05_KAIKEI[g_wi].x9     := G_FIELD_C;
  g_Stream05_KAIKEI[g_wi].size   := KAIKEIKAIKEITIMELEN;
  g_Stream05_KAIKEI[g_wi].offset := g_Stream05_KAIKEI[g_wi-1].size+g_Stream05_KAIKEI[g_wi-1].offset;
end;

finalization
begin
//
end;

end.
