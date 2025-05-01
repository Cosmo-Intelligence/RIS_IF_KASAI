unit HisMsgDef07_RESEND;
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
  //SENDSYORIKBNNO   : Integer = 0;
  //SENDHOSPCODENO   : Integer = 0;
  //SENDPIDNO        : Integer = 0;
  //SENDORDERNO      : Integer = 0;
  //SENDORDERDATENO  : Integer = 0;
  //SENDYOYAKUDATENO : Integer = 0;

  SENDSYORIKBNLEN   = 1;
  SENDHOSPCODELEN   = 2;
  SENDPIDLEN        = 10;
  SENDORDERLEN      = 16;
  SENDORDERDATELEN  = 8;
  SENDYOYAKUDATELEN = 8;

  SENDSYORIKBNNAME   = '�����敪';
  SENDHOSPCODENAME   = '�a�@�R�[�h';
  SENDPIDNAME        = '���Ҕԍ�';
  SENDORDERNAME      = '�I�[�_�ԍ�';
  SENDORDERDATENAME  = '�I�[�_��';
  SENDYOYAKUDATENAME = '�\���';
//�ϐ��錾-------------------------------------------------------------------
var
//�d���t�H�[�}�b�g��`�L����
  g_Stream07_RESEND     : array[1..G_MSGFNUM_RESEND] of TStreamField;
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
  g_Stream07_RESEND[g_wi].name   := g_Stream_Base[COMMON1SDIDNO].name;
  g_Stream07_RESEND[g_wi].x9     := g_Stream_Base[COMMON1SDIDNO].x9;
  g_Stream07_RESEND[g_wi].size   := g_Stream_Base[COMMON1SDIDNO].size;
  g_Stream07_RESEND[g_wi].offset := g_Stream_Base[COMMON1SDIDNO].offset;
  //2
  inc(g_wi);
  g_Stream07_RESEND[g_wi].name   := g_Stream_Base[COMMON1RVIDNO].name;
  g_Stream07_RESEND[g_wi].x9     := g_Stream_Base[COMMON1RVIDNO].x9;
  g_Stream07_RESEND[g_wi].size   := g_Stream_Base[COMMON1RVIDNO].size;
  g_Stream07_RESEND[g_wi].offset := g_Stream_Base[COMMON1RVIDNO].offset;
  //3
  inc(g_wi);
  g_Stream07_RESEND[g_wi].name   := g_Stream_Base[COMMON1COMMANDNO].name;
  g_Stream07_RESEND[g_wi].x9     := g_Stream_Base[COMMON1COMMANDNO].x9;
  g_Stream07_RESEND[g_wi].size   := g_Stream_Base[COMMON1COMMANDNO].size;
  g_Stream07_RESEND[g_wi].offset := g_Stream_Base[COMMON1COMMANDNO].offset;
  //4
  inc(g_wi);
  g_Stream07_RESEND[g_wi].name   := g_Stream_Base[COMMON1STATUSNO].name;
  g_Stream07_RESEND[g_wi].x9     := g_Stream_Base[COMMON1STATUSNO].x9;
  g_Stream07_RESEND[g_wi].size   := g_Stream_Base[COMMON1STATUSNO].size;
  g_Stream07_RESEND[g_wi].offset := g_Stream_Base[COMMON1STATUSNO].offset;
  //5
  inc(g_wi);
  g_Stream07_RESEND[g_wi].name   := g_Stream_Base[COMMON1DENLENNO].name;
  g_Stream07_RESEND[g_wi].x9     := g_Stream_Base[COMMON1DENLENNO].x9;
  g_Stream07_RESEND[g_wi].size   := g_Stream_Base[COMMON1DENLENNO].size;
  g_Stream07_RESEND[g_wi].offset := g_Stream_Base[COMMON1DENLENNO].offset;
  //14
  inc(g_wi);
  //SENDSYORIKBNNO := g_wi;
  g_Stream07_RESEND[g_wi].name   := SENDSYORIKBNNAME;
  g_Stream07_RESEND[g_wi].x9     := G_FIELD_C;
  g_Stream07_RESEND[g_wi].size   := SENDSYORIKBNLEN;
  g_Stream07_RESEND[g_wi].offset := g_Stream07_RESEND[g_wi-1].size+g_Stream07_RESEND[g_wi-1].offset;
  //15
  inc(g_wi);
  //SENDHOSPCODENO := g_wi;
  g_Stream07_RESEND[g_wi].name   := SENDHOSPCODENAME;
  g_Stream07_RESEND[g_wi].x9     := G_FIELD_C;
  g_Stream07_RESEND[g_wi].size   := SENDHOSPCODELEN;
  g_Stream07_RESEND[g_wi].offset := g_Stream07_RESEND[g_wi-1].size+g_Stream07_RESEND[g_wi-1].offset;
  //16
  inc(g_wi);
  //SENDPIDNO := g_wi;
  g_Stream07_RESEND[g_wi].name   := SENDPIDNAME;
  g_Stream07_RESEND[g_wi].x9     := G_FIELD_C;
  g_Stream07_RESEND[g_wi].size   := SENDPIDLEN;
  g_Stream07_RESEND[g_wi].offset := g_Stream07_RESEND[g_wi-1].size+g_Stream07_RESEND[g_wi-1].offset;
  //17
  inc(g_wi);
  //SENDORDERNO := g_wi;
  g_Stream07_RESEND[g_wi].name   := SENDORDERNAME;
  g_Stream07_RESEND[g_wi].x9     := G_FIELD_C;
  g_Stream07_RESEND[g_wi].size   := SENDORDERLEN;
  g_Stream07_RESEND[g_wi].offset := g_Stream07_RESEND[g_wi-1].size+g_Stream07_RESEND[g_wi-1].offset;
  //18
  inc(g_wi);
  //SENDORDERDATENO := g_wi;
  g_Stream07_RESEND[g_wi].name   := SENDORDERDATENAME;
  g_Stream07_RESEND[g_wi].x9     := G_FIELD_C;
  g_Stream07_RESEND[g_wi].size   := SENDORDERDATELEN;
  g_Stream07_RESEND[g_wi].offset := g_Stream07_RESEND[g_wi-1].size+g_Stream07_RESEND[g_wi-1].offset;
  //19
  inc(g_wi);
  //SENDYOYAKUDATENO := g_wi;
  g_Stream07_RESEND[g_wi].name   := SENDYOYAKUDATENAME;
  g_Stream07_RESEND[g_wi].x9     := G_FIELD_C;
  g_Stream07_RESEND[g_wi].size   := SENDYOYAKUDATELEN;
  g_Stream07_RESEND[g_wi].offset := g_Stream07_RESEND[g_wi-1].size+g_Stream07_RESEND[g_wi-1].offset;
end;

finalization
begin
//
end;

end.
