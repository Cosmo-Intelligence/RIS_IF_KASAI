unit myInitInf;
{
���@�\�����i�g�p�\��F����j
  �@��ۼު�āiEXE�j�̒[���ŗL��
    �C�j�V�����C�Y���iINI���j�ɃA�N�Z�X����@�\��񋟂���B
    ����̓��W�X�g���͖��T�|�[�gINI�t�@�C���̂݁B
    Gval���ڐ݁B
  �A���ʂ̃C�j�V�����C�Y���iINI���j�̒�`(�ŗL����pdct_ini.pas)
  �B�C�j�V�����C�Y���̈ꊇ�ǂݍ���

//�� ���C��INI�t�@�C���̎w��Z�N�V�����^�L�[�̒l��ǂށB
function func_ReadIniKeyVale(arg_SecName:string;
                              arg_KeyName:string;
                              arg_Vale:string
                                   ):String;
//�� ���C��INI�t�@�C���̎w��Z�N�V�����^�L�[�̒l�������B
procedure func_WriteIniKeyVale(arg_SecName:string;
                              arg_KeyName:string;
                              arg_Vale:string
                                  ):boolean;
�� ���߽��INI�t�@�C���̃Z�N�V������Ǎ����Key�̈ꗗ��TStrings�Ɏ��o���B
function func_ReadIniSecKeyToTStrings(
   arg_IniFname:string;���߽��INI̧�ٖ�
   arg_SecName:string  ����ݖ�������
   ):TStrings;         ��������̈ꗗ

�����߽��Ini̧�ق̾���݂�Key�ꗗ����A�eKey�́i��ϋ�؂�j�l�̈ꗗ��
  TStrings�z��ō쐬����B
function func_ReadIniSecToATStrings(
   arg_IniFname:string;         ���߽��INI̧�ٖ�
   arg_SecName:string;          ����ݖ�������
   arg_KeyList:TStrings;        ReadIniSecKeyToTStrings�ō��
   var arg_Res: TAarrayTStrings ����
    ):boolean;                  ���A�l
�� INI�t�@�C���̃Z�N�V������Ǎ����Key�̈ꗗ��TStrings�Ɏ��o���B
function func_ReadIniSecKeyToTStrings2(
   arg_IniFname:string;INI̧�ٖ� �������ݽ��WIN�̎d�l�Ɠ���
   arg_SecName:string  ����ݖ�������
   ):TStrings;         ��������̈ꗗ
��Ini̧�ق̾���݂�Key�ꗗ����A�eKey�̒l�ꗗ��TStrings�z����쐬����B
function func_ReadIniSecToATStrings2(
   arg_IniFname:string;       ���߽��INI̧�ٖ� �������ݽ��WIN�̎d�l�Ɠ���
   arg_SecName:string;        ����ݖ�������
   arg_KeyList:TStrings;      ReadIniSecKeyToTStrings�ō��
   var arg_Res: TAarrayTStrings ����
    ):boolean;                ���A�l
//�� �L�[�̒l�̊��ϐ�������u��������B
function func_ChngVal(
                      arg_Vale:string        //�ǎ��l
                                   ):String; //�ϊ�����

��ReadIniSecToATStrings��ReadIniSecKeyToTStrings�̌��ʂ�跰�l�����o��
function func_IniKeyValue(
   arg_KeyList:TStrings;         ReadIniSecKeyToTStrings�ō��
   arg_KeyVlist:TAarrayTStrings; ReadIniSecToATStrings�ō��
   arg_Key:string;               ��������
   arg_Index:Integer;            arg_KeyVlist�̈ʒu0����
   arg_defoult:string            ���o���Ȃ�������̫�Ēl
   ):string;                     ���ʂ̎���

������
�V�K�쐬�F00.04.10�F�S�����킢

�C��00�F05�F11 : iwai
ini���A�N�Z�X�֐���ǉ�
function func_ReadIniKeyVale():String;
procedure func_WriteIniKeyVale();
function func_ChngVal();
�e��ʂ��ʂ�INI���ɃA�N�Z�X����\��������
����INI���烌�W�X�g���ɂȂ鎞�ɂ��̊֐�������������΂��ނ̂ŁB

�C��00�F10�F27 : iwai
ini���ւ̏������A�N�Z�X�@�\�݂̂ɕ���
���̒�`��pdct_com.pas�Ɉڐ�

�C��01�F02�F21 : iwai
RIG�ڑ�����ǉ�
�C��01�F03�F13 : iwai
������������ǉ�

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
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
  Gval,
  pdct_ini
  ;
////�^�N���X�錾-------------------------------------------------------------
//type
//�萔�錾-------------------------------------------------------------------
const
//INI�t�@�C�����
g_DOCSYS_INI_NAME = 'RIS_SYS.INI';      //���s�P�ʂ�INI�t�@�C�����i���p�X�j
g_LGSYS_INI_NAME = 'RIS_LG.INI';      //���s�P�ʂ�INI�t�@�C�����i���p�X�j
G_PRODUCT_INI_NAME=g_DOCSYS_INI_NAME;
//INI���̖������̃f�t�H���g�l������������������������������������������������
CST_COREP_DIR_NAME='co_rep\';
CST_COREPORT_DIR_NAME='co_reptemp\';
CST_COREPVIEWER_DIR_NAME='CrViewer.exe';
CST_COREPCID_DIR_NAME='co_rep\cid\';
CST_COLUMN_DIR_NAME='Columns\';
CST_SHEMA_DIR_NAME='she-ma\';
CST_WAVE_FILE_NAME='wave\otokokuti.wav';
//���������������������������������������������������������������� ������������
//����INI�t�@�C������`��������������������������������������������������������
 //�Z�N�V�����F���ϐ�
  g_COMMON_SECSION = 'COMMON';
    g_HOMEDIR_KEY = 'HOMEDIR';//�z�[���f�B���N�g��
 //�Z�N�V�����F�E�B���h�E���
  g_WINDOW_SECSION = 'WINDOW';
    g_MENU_WIN_MAX_H_KEY      = 'MENU_WIN_MAX_H';//�L�[
     G_CONST_MAX_MENUWINDOW_H='735'; //����޳�c
    g_MENU_WIN_MAX_W_KEY      = 'MENU_WIN_MAX_W';//�L�[
     G_CONST_MAX_MENUWINDOW_W='300'; //����޳��
    g_SUB_WIN_MAX_H_KEY       = 'SUB_WIN_MAX_H' ;//�L�[
     G_CONST_MAX_SUBWINDOW_H ='735'; //��޳���޳�c
    g_SUB_WIN_MAX_W_KEY       = 'SUB_WIN_MAX_W' ;//�L�[
     G_CONST_MAX_SUBWINDOW_W ='980'; //��޳���޳��
    g_MENU_WIN_ALIMENT_KEY   = 'MENU_WIN_ALIMENT';//�L�[
    g_SUB_WIN_ALIMENT_KEY    = 'SUB_WIN_ALIMENT' ;//�L�[
 //�Z�N�V�����F�a����
  g_WAREKI_SECSION = 'WAREKI';
 //�Z�N�V�����F�g���[�X����
  g_TRACE_SECSION  = 'TRACE';
    g_MODE_KEY     = 'mode';    //�L�[�g���[�X���[�h
    g_PATH_KEY     = 'path';    //�L�[�g���[�XPATH
    g_FILESIZE_KEY = 'filesize';//�L�[�t�@�C���T�C�Y
    G_FILESIZE     = '1048576';
 //�Z�N�V�����F���[�U�[�����
  g_USRINF_SECSION = 'USRINF';
    g_CTNAME_KEY      = 'ctname'    ;//�L�[�[������
    g_USERID_KEY      = 'userid'    ;//�L�[���[�U�h�c
 //�Z�N�V�����F���C��DB�V�X�e�����
  g_DBINF_SECSION = 'DBINF';
    g_SYSNAME_KEY     = 'dbuid'     ;//�L�[DB�ڑ����[�UID
        g_DB_ACCOUNT  = 'ris'   ;//�f�t�H���g INI�Őݒ�ςƂȂ邽�ߎg�p�s��
    g_USERPSS_KEY     = 'dbpss'     ;//�L�[���[�U�p�X���[�h
        g_DB_PASS     = 'huris'   ;//�f�t�H���g INI�Őݒ�ςƂȂ邽�ߎg�p�s��
    g_DBNAME_KEY      = 'dbname'    ;//�L�[DBname
        g_DB_NAME     = 'ris_sv';//�f�t�H���g INI�Őݒ�ςƂȂ邽�ߎg�p�s��
    g_DB_CONECT_KEY   = 'dbcntmax'  ;//�L�[DB�����ڑ��ő吔
        g_DB_CONECT_N = '4'         ;//�f�t�H���gDB�����ڑ��ő吔
 //�Z�N�V�����F�f�B���N�g�����
  g_DIRINF_SECSION = 'DIRINF';
    g_COREP_DIR_KEY   = 'corepdir'  ;//�L�[CoReport�̃t�H�[���f�B���N�g��
        g_COREP_DIR   = ''          ;//�f�t�H���gCoReport�̃t�H�[���f�B���N�g��
    g_COREPVIEWER_DIR_KEY = 'corepviewerdir';//�L�[CoReportsViewer�̃t�H�[���f�B���N�g��
        g_COREPVIEWER_DIR = ''              ;//�f�t�H���gCoReportsViewer�̃t�H�[���f�B���N�g��
    g_COREPVIEWER_FLG_KEY = 'corepviewerflg';//�L�[CoReportsViewer��ON,OFF
        g_COREPVIEWER_FLG = ''              ;//CoReportsViewer��ON,OFF
    g_COREPCID_DIR_KEY = 'corepciddir';//�L�[CoReportsViewer�pcid�t�@�C���쐬�̃t�H�[���f�B���N�g��
        g_COREPCID_DIR = ''           ;//�f�t�H���gCoReportsViewer�pcid�t�@�C���쐬�̃t�H�[���f�B���N�g��

    g_columndir_DIR_KEY = 'columndir';//�L�[�J�������t�@�C���쐬�̃t�H�[���f�B���N�g��
        g_columndir_DIR = ''           ;//�f�t�H���g�J�������p�t�@�C���쐬�̃t�H�[���f�B���N�g��
    g_shemadir_DIR_KEY = 'shemadir';  //�L�[�V�F�[�}�I���W�i���t�@�C���A�ҏWHTML�i�[��f�B���N�g��
        g_shemadir_DIR = ''           ;//�V�F�[�}�I���W�i���t�@�C���A�ҏWHTML�i�[��f�B���N�g��

    g_wavedir_DIR_KEY = 'wavedir';  //�L�[�V�F�[�}�I���W�i���t�@�C���A�ҏWHTML�i�[��f�B���N�g��
        g_wavedir_DIR = ''           ;//�V�F�[�}�I���W�i���t�@�C���A�ҏWHTML�i�[��f�B���N�g��

 //�Z�N�V�����F���j���[��ʉ摜 2003.10.15
  g_IMAGE_SECSION = 'IMAGE';
    g_IMAGE_DIR_KEY   = 'imagedir' ;    //�L�[�w�i�摜�̊i�[��f�B���N�g��
        g_IMAGE_DIR   = ''         ;    //�f�t�H���g
    g_IMAGE_FILE_KEY  = 'imagefile';    //�w�i�摜�̊i�[��t�@�C����
        g_IMAGE_FILE  = ''         ;    //�f�t�H���g

  g_REPORTINF_SECSION = 'REPORTINF';
    g_REPORTINF_ID_KEY = 'id';
    gi_REPORTINF_DEF   = '';

//����INI�t�@�C������`����������������������������������������������������������������
//�ϐ��錾-------------------------------------------------------------------
var
//�ȉ�����ۼު�Ă�ini�̏��
   gini_ProjectIni: TIniFile;
   g_product_inifile_name:string;
//ini���Ǎ��� ��������������������������������������������������������������
//���ϐ��i�[��
   gini_Common_Key  : TStrings;
   gini_Common: TAarrayTStrings;
   { ��             [0]       [1]
      gini_Common[0] HOMEDIR   C:\
      gini_Common[1] XXXXXXX   C:\

      gini_Common[0][0] 'HOMEDIR'
   }
//main�pDB
   gi_DB_Name       : string ; //BDE�Őݒ肳�ꂽ�ر���
   gi_DB_Account    : string ;//ORACL�̃A�J�E���g
   gi_DB_Pass       : string ;   //ORACL��PASSWORD
   gi_ctname        : string ;       //
   gi_UserID        : string ;       //UID
   gi_UserPassWord  : string ; //PASSWORD
   g_DB_CONECT_MAX  : integer;   //DB�����ڑ��ő吔
//CoReport�d���`�̊i�[��
   gi_COREP_DIR     : string ;
   gi_COREPORT_TEMPDIR:String;
//CoReportsViewer�d���`�̊i�[��
   gi_COREPVIEWER_EXE : string ;
//CoReportsViewer�d���`�̊i�[��
   gi_COREPVIEWER_FLG : string ;
//CoReportsViewer�pcid�t�@�C�����d���`�̊i�[��
   gi_COREPCID_DIR    : string ;
//column�t�@�C�����d���`�̊i�[��
   gi_columndir_DIR    : string ;
//�V�F�[�}�d���`�̊i�[��
   gi_SHEMADIR_DIR  : string;
//�����m�pWave�t�@�C���d���`�̊i�[��
   gi_WAVEDIR_DIR  : string;
//�w�i�摜�̊i�[��f�B���N�g����`�̊i�[��   2003.10.15
   gi_image_dir  : string;
//�w�i�摜�̊i�[��t�@�C������`�̊i�[��     2003.10.15
   gi_image_file : string;
//��t�[�R�����g�h�c     2004.04.09
   gi_Disp_CommentID : string;

//�a����i�[��
   gini_Wareki_Key  : TStrings;
   gini_Wareki: TAarrayTStrings;
   { ��             [0] [1] [2]   [3]
      gini_Wareki[0] 1   M  ����  1867/01/01
      gini_Wareki[1] 2   T  �吳  1912/01/01
      gini_Wareki[2] 3   S  ���a  1927/01/01
      gini_Wareki[3] 4   H  ����  1989/01/01

      gini_Wareki[0][0] '1'
   }
//����޳�̃T�C�Y�Ɣz�u
   gi_MenuWinMax_H:string;
   gi_MenuWinMax_W:string;
   gi_SubWinMax_H:string;
   gi_SubWinMax_W:string;
   gi_MenuWinAlin:string;
   gi_SubWinAlin:string;

   g_MenuWinMax_H:integer;
   g_MenuWinMax_W:integer;
   g_SubWinMax_H:integer;
   g_SubWinMax_W:integer;

//ini���Ǎ��� ����������������������������������������������������������������

//�֐��葱���錾-------------------------------------------------------------
function func_ChngVal(
                      arg_Vale:string        //�ǎ��l
                                   ):String; //�ϊ�����
function func_ReadIniKeyVale(arg_SecName:string;
                              arg_KeyName:string;
                              arg_Vale:string
                                   ):String;
procedure func_WriteIniKeyVale(arg_SecName:string;
                              arg_KeyName:string;
                              arg_Vale:string
                                  );
function func_ReadIniSecKeyToTStrings(arg_IniFname:string;
                                   arg_SecName:string
                                   ):TStrings;
function func_ReadIniSecToATStrings(arg_IniFname:string;
                                   arg_SecName:string;
                                   arg_KeyList:TStrings;
                                   var arg_Res: TAarrayTStrings ):boolean;
function func_ReadIniSecKeyToTStrings2(arg_IniFname:string;
                                   arg_SecName:string
                                   ):TStrings;
function func_ReadIniSecToATStrings2(arg_IniFname:string;
                                   arg_SecName:string;
                                   arg_KeyList:TStrings;
                                   var arg_Res: TAarrayTStrings ):boolean;

function func_IniKeyValue(arg_KeyList:TStrings;
                          arg_KeyVlist:TAarrayTStrings;
                          arg_Key:string;
                          arg_Index:Integer;
                          arg_defoult:string
                          ):string;
//�|�C���^���s����Ȃ̂Ŏg��Ȃ�����
function func_ReadIniSecToTStrings(arg_IniFname:string;
                                   arg_SecName:string;
                                   arg_Res: Pointer):boolean;


implementation //**************************************************************

//�g�p���j�b�g---------------------------------------------------------------
//uses
//�萔�錾       -------------------------------------------------------------
//const
//�ϐ��錾     ---------------------------------------------------------------
var
  w_wfini: integer;
  w_string:string;
//�֐��葱���錾--------------------------------------------------------------
//�� �L�[�̒l�̊��ϐ�������u��������B
function func_ChngVal(
                      arg_Vale:string        //�ǎ��l
                                   ):String; //�ϊ�����
var
  w_PrChr:string;
  w_CVal :string;
  w_Res  :string;
  w_i:integer;
begin
  w_Res := arg_Vale;
try
  if nil<>gini_Common_Key then
  begin
    for w_i:=0 to gini_Common_Key.Count-1 do
    begin
      w_PrChr:=gini_Common_Key[w_i];
      if  0 < Length(Trim(w_PrChr)) then
      begin
        w_CVal := func_IniKeyValue(
                            gini_Common_Key,
                            gini_Common,
                            w_PrChr,
                            0,
                            ''
                            );
        if w_PrChr=g_HOMEDIR_KEY then
        begin
          if func_IsNullStr(w_CVal)
             or
             not(DirectoryExists(w_CVal))
          then
          begin
             w_CVal:=G_EnvPath;
          end;
        end;
        if  0 < Length(Trim(w_CVal)) then
        begin
          w_Res := StringReplace(
                           w_Res,
                           '%' + w_PrChr + '%',
                           w_CVal,
                           [rfReplaceAll, rfIgnoreCase]
                           );
        end;
      end;
    end;
  end;
  result := w_Res;
except
  result := w_Res;
  exit;
end;
end;

//�� ���C��INI�t�@�C���̎w��Z�N�V�����^�L�[�̒l��ǂށB
function func_ReadIniKeyVale(arg_SecName:string;
                             arg_KeyName:string;
                             arg_Vale:string
                                   ):String;
var
  w_s:string;
begin
     w_s := gini_ProjectIni.ReadString(
                    arg_SecName,
                    arg_KeyName,
                    arg_Vale);
     result := func_ChngVal(w_s);

end;
//�� ���C��INI�t�@�C���̎w��Z�N�V�����^�L�[�̒l�������B
procedure func_WriteIniKeyVale(arg_SecName:string;
                              arg_KeyName:string;
                              arg_Vale:string
                                  );
begin
     gini_ProjectIni.WriteString(
                    arg_SecName,
                    arg_KeyName,
                    arg_Vale);

end;
//��Ini�̃Z�N�V������Ǎ����Key�̈ꗗ��TStrings�ɂ���
//arg_IniFname�̓t���p�X�w�� �܂��� �t�@�C�����̂�
//Error:bottom up �e�폈����O
function func_ReadIniSecKeyToTStrings2(arg_IniFname:string;
                                   arg_SecName:string
                                   ):TStrings;
var
    wo_SysIni: TIniFile;
    wo_KeyNames: TStringList;
begin
  Result:=nil;
  // DOCSYS ��Ǎ��݃��j�����\������B
  wo_SysIni := TIniFile.Create(arg_IniFname);
  if wo_SysIni = nil then Exit;
  try
    //key�̓ǂݎ�� �B
    wo_KeyNames := TStringList.Create;
    try
      wo_SysIni.ReadSection(arg_SecName, wo_KeyNames);
    except
      wo_KeyNames.free;
      raise;
    end;
  // �I������
  finally
    wo_SysIni.Free;
  end;
  Result := wo_KeyNames;
end;
//��Ini�̃Z�N�V������Ǎ����Key�̈ꗗ��TStrings�ɂ���
//arg_IniFname�͊��p�XG_EnvPath�ɑ��݂���
//Error:bottom up
function func_ReadIniSecKeyToTStrings(arg_IniFname:string;
                                   arg_SecName:string
                                   ):TStrings;
begin
  Result :=
     func_ReadIniSecKeyToTStrings2(
               (G_EnvPath + arg_IniFname),
               arg_SecName
               );
end;

//��Ini�̃Z�N�V������Ǎ����Key�̒l�̈ꗗ��TStrings�z��ɂ���
//arg_IniFname�̓t���p�X�w�� �܂��� �t�@�C�����̂�
//Error:bottom up �e�폈����O
function func_ReadIniSecToATStrings2(
                                   arg_IniFname:string;
                                   arg_SecName:string;
                                   arg_KeyList:TStrings;
                                   var arg_Res: TAarrayTStrings ):boolean;
var
    wo_SysIni: TIniFile;
    wi_Max_Key: integer;//
    wi_init: integer;//
    wo_KeyValue : TStringList;
begin
  Result:=false;
  // SYSini ��Ǎ��݃��j�����\������B
  wo_SysIni := TIniFile.Create( arg_IniFname);
  if wo_SysIni = nil then Exit;
  try
    wo_KeyValue := TStringList.Create;
    try
      wo_SysIni.ReadSectionValues(arg_SecName, wo_KeyValue);
      wi_Max_Key := arg_KeyList.Count;
      try
        wi_init:=0 ;
        while  wi_init <= ( wi_Max_Key - 1 ) do
        begin
          arg_Res[wi_init] :=
            func_StrToTStrList(wo_KeyValue.Values[arg_KeyList[wi_init]]);
          wi_init := wi_init + 1;
        end;
      except
        wi_init:=0 ;
        while  wi_init <= ( wi_Max_Key - 1 ) do
        begin
          if arg_Res[wi_init] <> nil then
          begin
            arg_Res[wi_init].Free;
            arg_Res[wi_init]:=nil;
          end;
          wi_init := wi_init + 1;
        end;
        raise;
      end;
  // �I������
      finally
        wo_KeyValue.Free;
      end;
  finally
    wo_SysIni.Free;
  end;
  Result := true;
end;

//��Ini�̃Z�N�V������Ǎ����Key�̒l�̈ꗗ��TStrings�z��ɂ���
//arg_IniFname�͊��p�XG_EnvPath�ɑ��݂���
//Error:bottom up
function func_ReadIniSecToATStrings(arg_IniFname:string;
                                   arg_SecName:string;
                                   arg_KeyList:TStrings;
                                   var arg_Res: TAarrayTStrings ):boolean;
begin
  Result := func_ReadIniSecToATStrings2(
                                        ( G_EnvPath + arg_IniFname),
                                        arg_SecName,
                                        arg_KeyList,
                                        arg_Res
                                       );
end;

//��Ini�̃Z�N�V������Ǎ����TStrings�ɂ���
//�|�C���^���s����Ȃ̂Ŏg��Ȃ�
function func_ReadIniSecToTStrings(arg_IniFname:string;
                                   arg_SecName:string;
                                   arg_Res: Pointer):boolean;
var
    wo_SysIni: TIniFile;
    wo_KeyNames: TStringList;
    wi_Max_Key: integer;//
    wi_init: integer;//
    wo_KeyValue : TStringList;
    wa_KeyValues: ^TAarrayTStrings;
begin
  Result := false;
  // SYSini ��Ǎ��݃��j�����\������B
  wo_SysIni := TIniFile.Create( G_EnvPath + arg_IniFname);
  if wo_SysIni=nil then exit;
  try
    //key�̓ǂݎ�� �B
    wo_KeyNames := TStringList.Create;
    try
      wo_KeyValue := TStringList.Create;
      try
        wo_SysIni.ReadSection(arg_SecName, wo_KeyNames);
        wo_SysIni.ReadSectionValues(arg_SecName, wo_KeyValue);
        wi_Max_Key := wo_KeyNames.Count;
        //���i�[��z��̑傫���ݒ�   gini_Wareki  wa_KeyValues
        wa_KeyValues:= arg_Res;
        SetLength ( wa_KeyValues^ ,wi_Max_Key);
        try
          wi_init:=0 ;
          while  wi_init <= ( wi_Max_Key - 1 ) do
          begin
            wa_KeyValues^[wi_init] :=
              func_StrToTStrList(wo_KeyValue.Values[wo_KeyNames[wi_init]]);
            wi_init := wi_init + 1;
          end;
        except
          wi_init:=0 ;
          while  wi_init <= ( wi_Max_Key - 1 ) do
          begin
            if wa_KeyValues^[wi_init] <> nil then
            begin
              wa_KeyValues^[wi_init].Free;
              wa_KeyValues^[wi_init]:=nil;
            end;
            wi_init := wi_init + 1;
          end;
          raise;
        end;
  // �I������
      finally
        wo_KeyValue.Free;
      end;
    finally
      wo_KeyNames.Free;
    end;
  finally
    wo_SysIni.Free;
  end;
  Result := true;
end;

//��INI�t�@�C����Key�̒l��List������o���i�j
//Error:No
(**
 -------------------------------------------------------------------
 * @outline        ���̧�ٖ��擾            <-- ���\�b�h�T�v
 * @param Index ���̧�ٲ��ޯ��          <-- �����T�v�i@param�̂��ƂɁA���������K�v�j
 * @return         ���̧�ٖ�                  <-- �߂�l�T�v(function�̂�)

 * �������P                                           <-- ���\�b�h�������i�����s�n�j�j
 * �������Q                                           <-- ���\�b�h�������i�����s�n�j�j
 -------------------------------------------------------------------
 *)
function func_IniKeyValue(arg_KeyList:TStrings;
                          arg_KeyVlist:TAarrayTStrings;
                          arg_Key:string;
                          arg_Index:Integer;
                          arg_defoult:string
                          ):string;
var
  w_index:integer;
begin
try
  result:= arg_defoult;
  if (arg_KeyList=nil) or
     (high(arg_KeyVlist)<0) or
     (Length(arg_Key)=0) then exit;
  w_index:=arg_KeyList.IndexOf(arg_Key);
  if (w_index >= 0) and
     (high(arg_KeyVlist) >= w_index) and
     (arg_KeyVlist[w_index].Count>arg_Index)
     then

         result:=arg_KeyVlist[w_index][arg_Index];
except
  result:= '';
  exit;
end;
end;

initialization
begin
//1)�f�t�H���g�l�̐ݒ�
      g_product_inifile_name := G_PRODUCT_INI_NAME;
   //1)-1)��񏉊���()
      gi_MenuWinMax_H := G_CONST_MAX_MENUWINDOW_H;
      g_MenuWinMax_H := StrToInt(gi_MenuWinMax_H);

      gi_MenuWinMax_W := G_CONST_MAX_MENUWINDOW_W;
      g_MenuWinMax_W := StrToInt(gi_MenuWinMax_W);

      gi_SubWinMax_H  := G_CONST_MAX_SUBWINDOW_H;
      g_SubWinMax_H := StrToInt(gi_SubWinMax_H);

      gi_SubWinMax_W  := G_CONST_MAX_SUBWINDOW_W;
      g_SubWinMax_W := StrToInt(gi_SubWinMax_W);

      gi_MenuWinAlin  := '';
      gi_SubWinAlin   := '';
   //1)-2)���[�U��񏉊���
      gi_ctname       := 'Clint('+ func_GetMachineName + ')';
      gi_UserID       := '';
      gi_UserPassWord := '';
   //1)-3)DB��񏉊���
      gi_DB_Name      := g_DB_NAME;
      gi_DB_Account   := g_DB_ACCOUNT;
      gi_DB_Pass      := g_DB_PASS;
      g_DB_CONECT_MAX := StrToInt(g_DB_CONECT_N);
   //1)-4)�f�B���N�g����񏉊���
      gi_COREP_DIR    := g_COREP_DIR;
//2)read ini file.
     gini_ProjectIni := TIniFile.Create( G_EnvPath + g_product_inifile_name);
   //2)-0)���ϐ��ǂݍ���
     gini_Common_Key :=
            func_ReadIniSecKeyToTStrings(g_product_inifile_name,
                                         g_COMMON_SECSION);
     if (gini_Common_Key<> nil) and
        (gini_Common_Key.Count>0)then
     begin
     //���i�[��z��̑傫���ݒ�   gini_Wareki  wa_KeyValues
       SetLength ( gini_Common ,gini_Common_Key.Count);
       func_ReadIniSecToATStrings(g_product_inifile_name,
                                  g_COMMON_SECSION,
                                  gini_Common_Key,
                                  gini_Common);
     end;
   //2)-1)�E�B���h�E���ǂݍ���
     w_string:=func_ReadIniKeyVale(g_WINDOW_SECSION,
                                          g_MENU_WIN_MAX_H_KEY,
                                          gi_MenuWinMax_H);
     if not(func_IsNullStr(w_string)) then gi_MenuWinMax_H :=w_string;
     g_MenuWinMax_H := StrToInt(gi_MenuWinMax_H);

     w_string:=func_ReadIniKeyVale(g_WINDOW_SECSION,
                                          g_MENU_WIN_MAX_W_KEY,
                                          gi_MenuWinMax_W);
     if not(func_IsNullStr(w_string)) then gi_MenuWinMax_W :=w_string;
     g_MenuWinMax_W := StrToInt(gi_MenuWinMax_W);

     w_string :=func_ReadIniKeyVale(g_WINDOW_SECSION,
                                          g_SUB_WIN_MAX_H_KEY,
                                          gi_SubWinMax_H);
     if not(func_IsNullStr(w_string)) then gi_SubWinMax_H :=w_string;
     g_SubWinMax_H := StrToInt(gi_SubWinMax_H);

     w_string :=func_ReadIniKeyVale(g_WINDOW_SECSION,
                                          g_SUB_WIN_MAX_W_KEY,
                                          gi_SubWinMax_W);
     if not(func_IsNullStr(w_string)) then gi_SubWinMax_W :=w_string;
     g_SubWinMax_W := StrToInt(gi_SubWinMax_W);

     gi_MenuWinAlin :=func_ReadIniKeyVale(g_WINDOW_SECSION,
                                          g_MENU_WIN_ALIMENT_KEY,
                                          gi_MenuWinAlin);

     gi_SubWinAlin :=func_ReadIniKeyVale(g_WINDOW_SECSION,
                                          g_SUB_WIN_ALIMENT_KEY,
                                          gi_SubWinAlin);

   //2)-2)�a��ǂݍ���
     gini_Wareki_Key :=
            func_ReadIniSecKeyToTStrings(g_product_inifile_name,
                                         g_WAREKI_SECSION);
     if (gini_Wareki_Key<> nil) and
        (gini_Wareki_Key.Count>0)then
     begin
     //���i�[��z��̑傫���ݒ�   gini_Wareki  wa_KeyValues
       SetLength ( gini_Wareki ,gini_Wareki_Key.Count);
       func_ReadIniSecToATStrings(g_product_inifile_name,
                                  g_WAREKI_SECSION,
                                  gini_Wareki_Key,
                                  gini_Wareki);
     end
     else
     begin
       //�f�t�H���g
       if (gini_Wareki_Key<> nil) then gini_Wareki_Key:=TStringList.Create;
       SetLength ( gini_Wareki ,4);
       gini_Wareki[0]:=TStringList.Create;
       gini_Wareki[1]:=TStringList.Create;
       gini_Wareki[2]:=TStringList.Create;
       gini_Wareki[3]:=TStringList.Create;
       gini_Wareki[0].CommaText:= '1,M,����,1868/01/01';
       gini_Wareki[1].CommaText:= '2,T,�吳,1912/07/31';
       gini_Wareki[2].CommaText:= '3,S,���a,1926/12/26';
       gini_Wareki[3].CommaText:= '4,H,����,1989/01/08';
     end;
   //2)-3)���[�U�[�����ǂݍ���
     w_string:=func_ReadIniKeyVale(g_USRINF_SECSION,
                                    g_CTNAME_KEY,
                                    gi_ctname);
     if not(func_IsNullStr(w_string)) then gi_ctname :=w_string;
     gi_UserID:=gini_ProjectIni.ReadString(g_USRINF_SECSION,
                                           g_USERID_KEY,
                                           gi_UserID);
   //2)-4)DB���ǂݍ���
     w_string:=func_ReadIniKeyVale(g_DBINF_SECSION,
                                     g_DBNAME_KEY,
                                     gi_DB_Name);
     if not(func_IsNullStr(w_string)) then gi_DB_Name :=w_string;
     w_string:=func_ReadIniKeyVale(g_DBINF_SECSION,
                                        g_SYSNAME_KEY,
                                        gi_DB_Account);
     if not(func_IsNullStr(w_string)) then gi_DB_Account :=w_string;
     gi_DB_Pass:=gi_DB_Account;
     w_string:=func_ReadIniKeyVale(g_DBINF_SECSION,
                                     g_USERPSS_KEY,
                                     gi_DB_Pass);
     if not(func_IsNullStr(w_string)) then gi_DB_Pass :=w_string;
     g_DB_CONECT_MAX:=strtointdef(func_ReadIniKeyVale(g_DBINF_SECSION,
                                                      g_DB_CONECT_KEY,
                                                      g_DB_CONECT_N),
                                  g_DB_CONECT_MAX);
   //2)-5)�f�B���N�g�����ǂݍ���
     gi_COREP_DIR:=func_ReadIniKeyVale(g_DIRINF_SECSION,
                                       g_COREP_DIR_KEY,
                                       gi_COREP_DIR);
     if ( gi_COREP_DIR = '' )
        or
        not(DirectoryExists(gi_COREP_DIR))
     then
       gi_COREP_DIR :=G_EnvPath + CST_COREP_DIR_NAME;
   //2)-6)�f�B���N�g��(CoreportsViewer)���ǂݍ���
     gi_COREPVIEWER_EXE:=func_ReadIniKeyVale(g_DIRINF_SECSION,
                                             g_COREPVIEWER_DIR_KEY,
                                             g_COREPVIEWER_DIR);
     gi_COREPVIEWER_EXE := gi_COREPVIEWER_EXE + CST_COREPVIEWER_DIR_NAME;
   //2)-6)-1)CoreportsViewer�N�����ǂݍ���
     gi_COREPVIEWER_FLG:=func_ReadIniKeyVale(g_DIRINF_SECSION,
                                             g_COREPVIEWER_FLG_KEY,
                                             g_COREPVIEWER_FLG);
   //2)-7)�f�B���N�g�����ǂݍ���
     gi_COREPCID_DIR:=func_ReadIniKeyVale(g_DIRINF_SECSION,
                                          g_COREPCID_DIR_KEY,
                                          gi_COREPCID_DIR);
     if ( gi_COREPCID_DIR = '' )
        or
        not(DirectoryExists(gi_COREPCID_DIR))
     then
       gi_COREPCID_DIR :=G_EnvPath + CST_COREPCID_DIR_NAME;

   //2)-8)�T�uDB���ǂݍ���
      gi_Pls1DB_Name      := g_PLS1_DB_NAME;
      gi_Pls1DB_Account   := g_PLS1_DB_ACCOUNT;
      gi_Pls1DB_Pass      := g_PLS1_DB_PASS;
      g_Pls1DB_CONECT_MAX := StrToInt(g_PLS1_DB_CONECT_N);
     w_string:=func_ReadIniKeyVale(g_PLS1_DB_SECSION,
                                     g_PLS1_DBNAME_KEY,
                                     gi_Pls1DB_Name);
     if not(func_IsNullStr(w_string)) then gi_Pls1DB_Name :=w_string;
     w_string:=func_ReadIniKeyVale(g_PLS1_DB_SECSION,
                                        g_PLS1_UID_KEY,
                                        gi_Pls1DB_Account);
     if not(func_IsNullStr(w_string)) then gi_Pls1DB_Account :=w_string;
     gi_Pls1DB_Pass:=gi_Pls1DB_Account;
     w_string:=func_ReadIniKeyVale(g_PLS1_DB_SECSION,
                                     g_PLS1_USERPSS_KEY,
                                     gi_Pls1DB_Pass);
     if not(func_IsNullStr(w_string)) then gi_Pls1DB_Pass :=w_string;
     g_Pls1DB_CONECT_MAX:=strtointdef(func_ReadIniKeyVale(g_PLS1_DB_SECSION,
                                                      g_PLS1_DB_CONECT_KEY,
                                                      g_PLS1_DB_CONECT_N),
                                  g_Pls1DB_CONECT_MAX);
   //2)-9)�f�t�H���g�J�������p�t�@�C���쐬�̃t�H�[���f�B���N�g�����ǂݍ���
     gi_columndir_DIR:=func_ReadIniKeyVale(g_DIRINF_SECSION,
                                          g_columndir_DIR_KEY,
                                          g_columndir_DIR);
     if ( gi_columndir_DIR = '' )
        or
        not(DirectoryExists(gi_columndir_DIR))
     then
       gi_columndir_DIR :=G_EnvPath + CST_COLUMN_DIR_NAME;

   //2)-10)�V�F�[�}�I���W�i���t�@�C���A�ҏWHTML�i�[��f�B���N�g�����ǂݍ���
     gi_SHEMADIR_DIR:=func_ReadIniKeyVale(g_DIRINF_SECSION,
                                          g_shemadir_DIR_KEY,
                                          g_shemadir_DIR);
     if ( gi_SHEMADIR_DIR = '' )
        or
        not(DirectoryExists(gi_SHEMADIR_DIR))
     then
       gi_SHEMADIR_DIR :=G_EnvPath + CST_SHEMA_DIR_NAME;

   //2)-11)�V�F�[�}�I���W�i���t�@�C���A�ҏWHTML�i�[��f�B���N�g�����ǂݍ���
     gi_WAVEDIR_DIR:=func_ReadIniKeyVale(g_DIRINF_SECSION,
                                          g_wavedir_DIR_KEY,
                                          g_wavedir_DIR);
     if ( gi_WAVEDIR_DIR = '' )
        or
        not(DirectoryExists(gi_WAVEDIR_DIR))
     then
       gi_WAVEDIR_DIR :=G_EnvPath + CST_WAVE_FILE_NAME;

   //2)-12)���j���[��ʉ摜�f�B���N�g�����ǂݍ���
     gi_image_dir:=func_ReadIniKeyVale(g_IMAGE_SECSION,
                                       g_IMAGE_DIR_KEY,
                                       g_IMAGE_DIR);
   //2)-13)-1)�w�i�摜�̊i�[��t�@�C�����ǂݍ���
     gi_image_file:=func_ReadIniKeyVale(g_IMAGE_SECSION,
                                        g_IMAGE_FILE_KEY,
                                        g_IMAGE_FILE);
   //3)-1)��t�[�R�����g�h�c���ǂݍ���
     gi_Disp_CommentID:=func_ReadIniKeyVale(g_REPORTINF_SECSION,
                                       g_REPORTINF_ID_KEY,
                                       gi_REPORTINF_DEF);

end;

finalization
begin
    if gini_ProjectIni<> nil then
    begin
      gini_ProjectIni.Free;
      gini_ProjectIni:=nil;
    end;
    if gini_Wareki_Key<> nil then
    begin
      gini_Wareki_Key.Free;
      gini_Wareki_Key:=nil;
    end;
    w_wfini:=0 ;
    while  w_wfini <= ( high(gini_Wareki) ) do
    begin
      if gini_Wareki[w_wfini] <> nil then
      begin
        gini_Wareki[w_wfini].Free;
        gini_Wareki[w_wfini]:=nil;
      end;
      w_wfini := w_wfini + 1;
    end;
//
end;

end.
