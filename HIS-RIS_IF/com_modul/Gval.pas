unit Gval;
{
���@�\����
�|�O���[�o���ϐ��Ƌ��ʊ֐��̃��j�b�g
  ���̊J���t�����������USES����(��ԍŏ���USES)
�|�O���[�o���ϐ�
  �|�N��PATH��
�|���ʊ֐�
  �ǉ�����͎̂��R�ł��B�݂�ȂŎg�������Ȃ̂̓h���h���ǉ����ĉ������B
  �������A
  �����ʊ֐��̋@�\�d�l
  ������
  �ɁA�K���ǉ��L�q���ĉ������B
  �ǉ�����O�ɑ�����ς��āA�ǉ���Ɍ��ɖ߂��Ă������� 

�����ʊ֐��̋@�\�d�l�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
���@�\:��������󔻒肷��i '' or '  '�j
function func_IsNullStr(arg_Str: string):Boolean;
�� DB����V�X�e�����t�������擾����(LOWLEVEL)HILEVEL��DB_ACC��func_DBSysDate
function  func_GetDBSysDate(
   arg_Q_Pass:TQuery //DB�ڑ��ς݂�TQuery
   ):TDateTime;
�� �o���A���gNULL���󕶎���ɕϊ��B
function func_VarToString(
   arg_VarString: Variant //�������variant
           ):string;
�� �v���O�����̋N���B
function func_WinExec(
   arg_ExeFile: string; //EXE�t�@�C���� �t���p�X�w��
   arg_CmdLine: string; //�R�}���h���C��
           );
�� �v���O�����̋N���B�I����҂�
function func_WinExecWait(
    arg_ExeFile: string;
    arg_CmdLine: string
    ):Boolean;
�� �w�莞�ԑ҂��B
procedure proc_delay(
   arg_timer: DWORD MSEC�P�ʂ̑҂�����
           );
�� ��������E������o���B
function Right(
   const s:String;��������
   l:integer      ���o������
   ):string;      ���ʕ�����
�� ���������������o���B
function Left(
   const s:String;��������
   l:integer      ���o������
   ):string;      ���ʕ�����
�� STRING����TStringList���쐬����B
function func_StrToTStrList(
   arg_Value: string ������
   ):TStrings;
�� TStringList����STRING�����o���B
function func_TStrListToStr(
   Value: TStrings ���l
   ):string;
//�����[�ɋ󔒂�������������쐬����B�i���̕�����폜����j
function func_UnTrim(
   arg_Str: string; ���̕�����
   arg_BLen:integer �޲ĒP�ʂ̑S�̂̕�����
   ):string;
//�����[�ɋ󔒂�������������쐬����B
function func_UnTrim2(
   arg_Str: string;  //���̕�����
   arg_BLen:integer  //���[�̋󔒂̒���
   ):String;         //
//�����[�ɋ󔒂�������������쐬����B�i���̕�����폜�Ȃ��j
function func_UnTrim3(
   arg_Str: string;  //���̕�����
   arg_BLen:integer  //�޲ĒP�ʂ̑S�̂̕�����
   ):String;         //

����������޲ĒP�ʂŕ��ʂ��邽�������������͏���
function func_BCopy(
   arg_Str: string;�Ώۂ̕�����
   arg_BLen:integer����
   );String;       ���ʕ�����

function func_LeftSpace(
                 intCapa : Integer;
                 EditStr : String
                 ): String;
function func_RigthSpace(
                 intCapa : Integer;
                 EditStr : String
                 ): String;
�������߭�����̂��擾����i�P�T�޲āj
function func_GetMachineName:string;

�����N�����Ɠ��t�����ɔN����v�Z����
function func_GetAge(
   arg_BirthDay:date; //�a����
   arg_Day:date       //���t
  ):integer;          //���N��
�����t��ϊ�����
function func_ChngDate(
   arg_Day:Tdate;  //�ϊ��O�l
   arg_Case:integer//�
   0:JUSIN_D      ���̂܂�
   1:JUSIN_D0401  �N�x�n��
   2:JUSIN_DN0331 �N�x��
   3:JUSIN_D1231  �N��
   4:JUSIN_D0101  �N�n
   5:JUSIN_DN0101 ���N�n
   6:JUSIN_D01    ����
   7:JUSIN_DME    ����
   ):TDate; �ϊ���l

�������4/1�N�x���t�ɕϊ�
function func_ChngDate41(
   arg_Day:Tdate �ϊ��O�l
     ):Tdate;    �ϊ���l

�����N�����Ɠ��t�Ɗ�����ɔN����v�Z����
function func_GetAgeofCase(
   arg_BirthDay:date; //�a����
   arg_Day:date;      //���t
   arg_Case:integer   //�
   0:JUSIN_D      ���̂܂�
   1:JUSIN_D0401  �N�x�n��
   2:JUSIN_DN0331 �N�x��
   3:JUSIN_D1231  �N��
   4:JUSIN_D0101  �N�n
   5:JUSIN_DN0101 ���N�n
   6:JUSIN_D01    ����
   7:JUSIN_DME    ����
  ):integer;          //���N��

//�����t���������t�ɂ���
function func_StrToDate(
   arg_Str: string; ���̕�����
  ):TDate;          //���t

//�����t���������t�����ɂ���
function func_StrToDateTime(
   arg_Str: string; ���t�̕�����
  ):TDateTime;          //���t

//�����t����t������ɂ���
function func_DateToStr(
   arg_Date: TDate; ���t�̕�����
  ):string;          //���t

//�����t��������t������ɂ���
function func_DateTimeToStr(
   arg_Date: TDateTime; ���t�̕�����
  ):string;          //���t

//�����t���ŏI�����ɂ���
function func_DateToLastTime(
   arg_Date: TDate;     //���t
  ):TDateTime;          //���t����

//�����t���ŏ������ɂ���
function func_DateToFirstTime(
   arg_Date: TDate;     //���t
  ):TDateTime;          //���t����

//�����t����YYYY/MM/DD����t����YYYYMMDD�ɂ���
function func_Date10ToDate8(
   arg_Date10: string// ���t�̕����� YYYY/MM/DD �ȊO�̓G���[
  ):string;          //���t �G���[�� ''����

//�����t����YYYYMMDD����t����YYYY/MM/DD�ɂ���
function func_Date8ToDate10(
   arg_Date8: string// ���t�̕�����  YYYYMMDD �ȊO�̓G���[
  ):string;          //���t  �G���[�� ''����

//����������HHMMSS����������HH:MM:SS�ɂ���
function func_Time6To8(
   arg_Data: string// ���t�̕�����  HHMMSS �ȊO�̓G���[
  ):string;          //���t  �G���[�� ''����

//����������HH:MM:SS����������HHMMSS�ɂ���
function func_Time8To6(
   arg_Data: string// ���t�̕�����  HH:MM:SS �ȊO�̓G���[
  ):string;          //���t  �G���[�� ''����

//���t�H���_���쐬����
function func_MakeDirectories(
   arg_Directory: string;   //�쐬�t�H���_
   arg_FileDelete: integer; //�t�@�C���폜�t���O(�O�F�Ȃ��A�P�F����)
  ):Boolean;                //���A�l
//���t�H���_�̑S�t�@�C�����폜����
function func_DeleteFileAt(
   arg_Directory: string;   //�Ώۃt�H���_
  ):Boolean;                //���A�l

//�����^�t�@�C��-->JPEG�t�@�C��
function func_MetafileToJpeg(
   arg_MetaFile: string;    //�R�s�[���̃��^�t�@�C����
   arg_JpegFile: string;    //�R�s�[���JPEG�t�@�C����
  ): Boolean;

//��JPEG�t�@�C��-->BMP�t�@�C��
function func_JpegfileToBmp(
   arg_JpegFile: string;    //�R�s�[����JPEG�t�@�C����
   arg_BmpFile: string;     //�R�s�[���BMP�t�@�C����
  ): Boolean;

//������޳�̾���ݸ�
procedure func_FromCenter(
   arg_Form: TForm; �t�H�[��
  );
//���t�@�C���R�s�[
procedure proc_CopyFile( arg_SrcName: string; arg_DesName: string );
//���ިڸ�؃t�@�C���R�s�[
procedure proc_CopyFileEx(
  arg_SrcName: string;
  arg_DesName: string);

//�������_�ȉ��P�ʎl�̌ܓ� ������  �͈͗L��
function Roundoff(X: Extended): Longint;
//�������_�ȉ��P�ʎl�̌ܓ� ����    �͈͗L��
function RoundoffE(X: Extended): Extended;
//�������_�ȉ��P�ʎl�̌ܓ� ����    �͈͖���
function Roundoff2(X: Extended): Extended;
//�������_�ȉ��P�ʎl�̌ܓ� ������  �͈͗L��
function StrRoundoff(X: Extended): string;
//��������������ɕϊ�  �J���}�O����؂�Ή�
function MyStrToFload(X: string): Extended;
//�������𕶎���ɕϊ�  �J���}�O����؂�Ή�
function MyFloadToStr(X: Extended): string;
//���J���}������
function delcomm(X: string): string;
//��arg_str1��arg_str2�̍\�������񂾂��ō\������邩
function func_IsInstr(arg_str1:string;arg_str2: string): BOOlean;
//��������������Ƃ��ĕϊ��\��
function func_IsFloat(arg_str1:string): BOOlean;
//������޳�̃A�������g�ݒ�
procedure proc_FrmAlign(arg_Form: TForm; arg_Align:string   );
//���t�@�C���̃T�C�Y�擾
function func_FileSize(arg_FilePath: string): Longint;
//���t�@�C���̈ꗗ�擾
function func_FileList(arg_FilePath: string): TstringList;
//���R���s���[�^������IP�A�h���X�擾
function func_MachineNameToIP(arg_MName:string):string;
//��IP�A�h���X�擾
function func_GetThisMachineIPAdrr:string;
//���R���s���[�^���擾
function func_GetThisMachineName:string;
//�������񂪐��l�݂̂��`�F�b�N
function func_IsNumber(arg_str1:string): Boolean;
//�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
������
�V�K�쐬�F99.06.17�F�S�� iwai
�C��    �F99.06.24�F�S�� iwai �װ�̒ǉ�
�C��    �F99.07.07�F�S�� iwai �֐��ǉ�
�C��    �F99.08.05�F�S�� iwai �N��v�Z�֐���ǉ�
�C��    �F99.09.14�F�S�� ���c TGridRect�̖��O�ύX(TGridRect1)
�C��    �F99.09.16�F�S�� ��� TGridRect TGridCoord�̺��ı��
�C��    �F99.11.19�F�S�� ��� TDynamicStringArray�̒ǉ�
�C��    �F99.11.26�F�S�� ��� ������󔻒�̊֐���ǉ�
�C��    �F2000.01.6�F�S�� ���
 function func_GetAge�ŔN����o���֐����Q���p����S���p�ɕύX
  StrToDate/StrToDateTime/DateToStr/DateTimeToStr
 �͂Q���݂̂Ɣ���
  DateTimeToString�^FormatDateTime�^func_StrToDate
 �͂S����
  func_StrToDate��ǉ�
�C��    �F2000.01.20�F�S�� ���
���t�ϊ��֐�func_ChngDate��func_ChngDate41��ǉ�

�C��    �F2000.01.31�F�S�� ���
GetMachinName2��ǉ��iDB�̒�`10�޲ĂƂ��킹�邽�߁j
�C��    �F2000.04.03�F�S�� ���
func_StrToDate�����Ԃ܂őΉ�������
���C��    �F2000.04.11�F�S�� ���
�V�K�J������
ini����INITINF.PAS�Ɉڐ�
�C��    �F2000.05.01�F�S�� ���
function func_StrToDateTime( arg_Str: string  ):TDateTime;
function func_DateTimeToStr(arg_Date: TDateTime  ):string;
function func_DateToStr( arg_Date: TDate  ):string;
��ǉ�
�C��    �F2000.05.09�F�S�� ���
function func_DateToFirstTime ( arg_Date: TDate ):TDateTime;
function func_DateToLastTime  ( arg_Date: TDate ):TDateTime;
��ǉ�
�C��    �F2000.05.11�F�S�� ���
function func_UnTrim2(arg_Str: string;arg_BLen:integer):String;
function func_UnTrim3(arg_Str: string;arg_BLen:integer):String;
�C��    �F2000.05.24�F�S�� ���R
function func_MakeDirectories(arg_Directory: string; arg_FileDelete: integer):Boolean;
function func_DeleteFileAt(arg_Directory: string):Boolean;
��ǉ�
�C��    �F2000.05.25�F�S�� �R��
function func_JpegfileToBmp(arg_JpegFile: string; arg_BmpFile: string;): Boolean;
��ǉ�
�C��    �F2000.08.15�F�S�� ���
proc_CopyFile proc_CopyFileEx ��ǉ�
�C��    �F2000.09.01�F�S�� ���
function Roundoff(X: Extended): Longint;
function StrRoundoff(X: Extended): string;
function MyStrToFload(X: string): Extended;
function delcomm(X: string): string;
function func_IsInstr(arg_str1:string;arg_str2: string): BOOlean;
function func_IsFloat(arg_str1:string): BOOlean;
 ��ǉ�
�C��    �F2000.10.10�F�S�� ���
function RoundoffE(X: Extended): Extended;
function MyFloadToStr(X: Extended): string;
 ��ǉ�
�C��    �F2000.11.01�F�S�� ���
procedure proc_FrmAlign(arg_Form: TForm; arg_Align:string   );
function func_FileSize(arg_FilePath: string): Longint;
function func_FileList(arg_FilePath: string): TstringList;
�ǉ�
�C��    �F2000.11.13�F�S�� ���
function func_MachineNameToIP(arg_MName:string):string;
function func_GetThisMachineIPAdrr:string;
function func_GetThisMachineName:string;
function func_WinExecWait(arg_ExeFile: string; arg_CmdLine: string):Boolean;
func_Date8To10
func_Date10To8
func_Time6To8
func_Time8To6
�C��    �F2001.03.19�F�S�� ���R
function func_IsNumber(arg_str1:string): Boolean;
�ǉ�
�C��    �F2001.10.24�F�S�� iwai
func_BCopy�̃o�O�C��
�ǉ��F2003.03.11���v���Z�X�����S��~�����ɑ҂��󂯂��s��
function WaitTime(const t: integer): Boolean;
}

interface  //*****************************************************************
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
  WinSock,
  Jpeg,
  Variants,
  Unit_Log, Unit_DB;

//�^�N���X�錾-----------------------------------------------------------
 //��Ƀp�����^���A�l�Ȃǒl�̎󂯓n���Ŏg�p����D
 type
    TAarrayTStrings = array of TStrings;
    TDynamicStringArray = array of String;
    T_ErrSysExcep  = class(Exception);

//�萔�錾-----------------------------------------------------------
 const
 //�E�B���h�E�ʒu
 g_WIN_ALIMENT_TOP    = 'T' ; //
 g_WIN_ALIMENT_BOTTOM = 'B' ; //
 g_WIN_ALIMENT_RIGTH  = 'R' ; //
 g_WIN_ALIMENT_LEFT   = 'L' ; //
 g_WIN_ALIMENT_TR     = g_WIN_ALIMENT_TOP   + g_WIN_ALIMENT_RIGTH; //TopRight/
 g_WIN_ALIMENT_TL     = g_WIN_ALIMENT_TOP   + g_WIN_ALIMENT_LEFT ; //TopLeft
 g_WIN_ALIMENT_BR     = g_WIN_ALIMENT_BOTTOM+ g_WIN_ALIMENT_RIGTH; //BottomRight
 g_WIN_ALIMENT_BL     = g_WIN_ALIMENT_BOTTOM+ g_WIN_ALIMENT_LEFT ; //BottomLeft
 //����
 g_PROCIDLEN = 8;//�v���O����ID�̒���
 g_PrgID_BASE =3;//�v���O����ID�̈ʒu
 //�N��v�Z��^�C�v
 JUSIN_D      = 0;
 JUSIN_D0401  = 1;
 JUSIN_DN0331 = 2;
 JUSIN_D1231  = 3;
 JUSIN_D0101  = 4;
 JUSIN_DN0101 = 5;
 JUSIN_D01    = 6;
 JUSIN_DME    = 7;
 gval_datefmtYY  = 'yyyy';           //���t��̫�ϯČ`��
 gval_datefmtMM  = 'mm';             //���t��̫�ϯČ`��
 gval_datefmtDD  = 'dd';             //���t��̫�ϯČ`��
 gval_timefmtHH  = 'hh';             //���t��̫�ϯČ`��
 gval_timefmtNN  = 'nn';             //���t��̫�ϯČ`��
 gval_timefmtSS  = 'ss';             //���t��̫�ϯČ`��
 //MRDraw�̖߂�l(00.05.24 ���R)
 WM_SCHEMAEDITOREXIT = WM_USER + 1000;

//�ϐ��錾-----------------------------------------------------------
 var
//���� �ȉ��̃O�[�o���ϐ��̓A�v���P�[�V�������s���̂ݗL������
   gval_datefmt: string ;
   gval_datetimefmt: string ;
   G_RunPath: string ; //�N��PASS �A�v���P�[�V�����̎��s�p�X
   G_EnvPath: string ; //���p�X �R�}���h���C���w���PASS �܂���
                       //         �N��PASS
   g_DB_CONECT_MAX:integer;   //DB�����ڑ��ő吔
   g_PC_Name:string;        //�[����
   g_CrntUserID:string ;       //UID
   g_CrntUserPassWord:string ; //PASSWORD
   g_Save_Cursor:TCursor;
//2001.02.09
   g_CrntUserCLS:string ;      //����
//2002.12.09
   g_CrntUserCode:string ;     //���O�C���E��ID

  //���O
  FLog:         T_FileLog;
  FDebug:       T_FileLog;

  //DB
  FDB:          T_DB;
  FQ_SEL:       T_Query;
  FQ_SEL_ORD:   T_Query;
  FQ_SEL_BUI:   T_Query;
  FQ_ALT:       T_Query;

//�֐��葱���錾--------------------------------------------------------------
function func_IsNullStr(arg_Str: string):Boolean;
function func_GetDBSysDate(arg_Q_Pass:TQuery):TDateTime;
function func_VarToString( arg_VarString: Variant ):string;
function func_WinExec(arg_ExeFile: string; arg_CmdLine: string):Boolean;
function func_WinExecWait(arg_ExeFile: string; arg_CmdLine: string):Boolean;
function Right(const s:String; l:integer):string;
function Left(const s:String; l:integer):string;
function func_StrToTStrList(arg_Value: string):TStrings;
function func_TStrListToStr(Value: TStrings):string;
function func_UnTrim(arg_Str: string;arg_BLen:integer):string;
function func_UnTrim2(arg_Str: string;arg_BLen:integer):String;
function func_UnTrim3(arg_Str: string;arg_BLen:integer):String;
function func_BCopy(arg_Str: string;arg_BLen:integer):string;
function func_LeftSpace(
                 intCapa : Integer;
                 EditStr : String
                 ): String;
function func_RigthSpace(
                 intCapa : Integer;
                 EditStr : String
                 ): String;
function func_GetMachineName:string;
function func_GetMachineName2:string;

function func_GetAge(arg_BirthDay:Tdate; arg_Day:Tdate):integer;
function func_ChngDate(arg_Day:Tdate; arg_Case:integer  ):TDate;
function func_GetAgeofCase(arg_BirthDay:Tdate; arg_Day:Tdate; arg_Case:integer ):integer;
function func_ChngDate41(arg_Day:Tdate  ):Tdate;
function func_StrToDate( arg_Str: string  ):TDate;
function func_StrToDateTime( arg_Str: string  ):TDateTime;
function func_DateTimeToStr(arg_Date: TDateTime  ):string;
function func_DateToStr( arg_Date: TDate  ):string;
function func_DateToFirstTime ( arg_Date: TDate ):TDateTime;
function func_DateToLastTime  ( arg_Date: TDate ):TDateTime;
procedure proc_delay(arg_timer: DWORD);
procedure proc_FrmCenter(arg_Form: TForm   );
procedure proc_FrmAlign(arg_Form: TForm; arg_Align:string   );


function func_MakeDirectories(arg_Directory: string; arg_FileDelete: integer):Boolean;
function func_DeleteFileAt(arg_Directory: string):Boolean;

function func_MetafileToJpeg(arg_MetaFile: string;arg_JpegFile: string): Boolean;
function func_JpegfileToBmp(arg_JpegFile: string;arg_BmpFile: string): Boolean;

procedure proc_CopyFile( arg_SrcName: string; arg_DesName: string );
procedure proc_CopyFileEx(
  arg_SrcName: string;
  arg_DesName: string);
function Roundoff(X: Extended): Longint;
function RoundoffE(X: Extended): Extended;
{00.09.09}
function Roundoff2(X: Extended): Extended;
function StrRoundoff(X: Extended): string;
function MyStrToFload(X: string): Extended;
function MyFloadToStr(X: Extended): string;
function delcomm(X: string): string;
function func_IsInstr(arg_str1:string;arg_str2: string): BOOlean;
function func_IsFloat(arg_str1:string): BOOlean;
function func_FileSize(arg_FilePath: string): Longint;
function func_FileList(arg_FilePath: string): TstringList;
function func_MachineNameToIP(arg_MName:string):string;
function func_GetThisMachineIPAdrr:string;
function func_GetThisMachineName:string;

function func_Date10To8(arg_Date10: string ):string;
function func_Date8To10(arg_Date8: string ):string;
function func_Time6To8(arg_Data: string ):string;
function func_Time8To6(arg_Data: string ):string;

//���v���Z�X�����S��~�����ɑ҂��󂯂��s��
function WaitTime(const t,s: integer): Boolean;

//�ꉞ���삷�邪�s���S
function func_ComponentToString(Component: TComponent): string;
function func_StringToComponent(Value: string): TComponent;

function func_IsNumber(arg_str1:string): Boolean;
function func_LeftZero( intCapa : Integer ; EditStr : String  ): String;

implementation //**************************************************************

//�ϐ��錾-----------------------------------------------------------
//var
//�萔�錾       -------------------------------------------------------------
// const
{
}

//�֐��葱���錾--------------------------------------------------------------
//����������HHMMSS����������HH:MM:SS�ɂ���
function func_Time6To8(
   arg_Data: string// ���t�̕�����
  ):string;          //���t
var
  w_s:string;
begin
  if length(arg_Data)<>6 then
  begin
    result:='';
    exit;
  end;
  w_s:=copy(arg_Data,1,2) + TimeSeparator + copy(arg_Data,3,2) + TimeSeparator + copy(arg_Data,5,2);
  result:=w_s;
end;
//����������HH:MM:SS����������HHMMSS�ɂ���
function func_Time8To6(
   arg_Data: string// ���t�̕�����
  ):string;          //���t
var
  w_s:string;
begin
  if length(arg_Data)<>8 then
  begin
    result:='';
    exit;
  end;
  w_s:=copy(arg_Data,1,2) + copy(arg_Data,4,2) + copy(arg_Data,7,2);
  result:=w_s;
end;

//�����t����YYYYMMDD����t����YYYY/MM/DD�ɂ���
function func_Date8To10(
   arg_Date8: string// ���t�̕�����
  ):string;          //���t
var
  w_s:string;
begin
  if length(arg_Date8)<>8 then
  begin
    result:='';
    exit;
  end;
  w_s:=copy(arg_Date8,1,4) + DateSeparator + copy(arg_Date8,5,2) + DateSeparator + copy(arg_Date8,7,2);
  result:=w_s;
end;
//�����t����YYYY/MM/DD����t����YYYYMMDD�ɂ���
function func_Date10To8(
   arg_Date10: string// ���t�̕�����
  ):string;          //���t
var
  w_s:string;
begin
  if length(arg_Date10)<>10 then
  begin
    result:='';
    exit;
  end;
  w_s:=copy(arg_Date10,1,4) + copy(arg_Date10,6,2) +  copy(arg_Date10,9,2);
  result:=w_s;
end;

//���t�@�C���̈ꗗ�擾
{$HINTS OFF}
function func_FileList(arg_FilePath: string): TstringList;
var
  w_FileName:string;
  w_Sr:TSearchRec;
  w_FileAttrs: Integer;
begin
  Result := TStringList.Create;
  w_FileAttrs:=faReadOnly+faHidden+faSysFile+faVolumeID+faArchive;
  if FindFirst(arg_FilePath, w_FileAttrs, w_Sr) = 0 then
  begin
    repeat
      w_FileName:=w_Sr.Name;
      Result.Add(w_FileName);
    until FindNext(w_Sr) <> 0;
    FindClose(w_Sr);
  end;
end;
{$HINTS ON}

//���t�@�C���̃T�C�Y�擾
{$HINTS OFF}
function func_FileSize(arg_FilePath: string): Longint;
var
  w_f: file of Byte;
  size : Longint;
begin
  result:=0;
  {$I-}
    AssignFile(w_f, arg_FilePath);
    Reset(w_f);
    size := FileSize(w_f);
    CloseFile(w_f);
  {$I+}
  result:=size;
end;
{$HINTS ON}

//��arg_str1��arg_str2�̍\�������񂾂��ō\������邩
function func_IsInstr(arg_str1:string;arg_str2: string): BOOlean;
var
 w_s:string;
 w_i:integer;
begin
  result:=true;
  for w_i:=1 to length(arg_str1) do
  begin
     w_s:=Copy(arg_str1,w_i,1) ;
     if 0=Pos(w_s,arg_str2) then
     begin
       result:=false;
       exit
     end;
  end;
end;

//��������������Ƃ��ĕϊ��\��
function func_IsFloat(arg_str1:string): BOOlean;
begin
  result:=func_IsInstr(arg_str1,'+-0123456789E,.');
end;

{$HINTS OFF}
//�������񂪐��l�݂̂��`�F�b�N
function func_IsNumber(arg_str1:string): Boolean;
var
  I,Code: integer;
begin
  Val(arg_str1, I, Code);
  if Code<>0 then
    result:=false
  else
    result:=true;
end;
{$HINTS ON}

//���J���}������
function delcomm(X: string): string;
begin
  while  AnsiPos(',',X)> 0 do
  begin
     delete(X,AnsiPos(',',X),1);
  end;
  result:=x;
end;

//�������𕶎���ɕϊ�  �J���}�O����؂�Ή�
function MyFloadToStr(X: Extended): string;
begin
  Result := FormatFloat('###,###,###,###,###,##0',X);
end;

//��������������ɕϊ�  �J���}�O����؂�Ή�
function MyStrToFload(X: string): Extended;
begin
  try
    x:=delcomm(x);
    if length(Trim(x)) > 0 then
    begin
      result:=StrToFloat(x);
    end else
    begin
      result:=0;
    end;
  except
    result:=0;
    exit;
  end;
end;

//�������_�ȉ��P�ʎl�̌ܓ�
function Roundoff(X: Extended): Longint;
var
   w_Maxinteger:Extended;
   w_Mininteger:Extended;
begin
  w_Maxinteger:= 2147483646;
  w_Mininteger:=-2147483647;
  x:=min(max(x,w_Mininteger),w_Maxinteger);

  if x >= 0 then
  begin
    Result := Trunc(min(max((x + 0.5),w_Mininteger),w_Maxinteger));
  end
  else
  begin
    Result := Trunc(min(max((x - 0.5),w_Mininteger),w_Maxinteger));
  end;
end;

//�������_�ȉ��P�ʎl�̌ܓ�
function RoundoffE(X: Extended): Extended;
var
   w_Maxinteger:Extended;
   w_Mininteger:Extended;
begin
  w_Maxinteger:=  9223372036854775;
  w_Mininteger:= -9223372036854775;
  x:=min(max(x,w_Mininteger),w_Maxinteger);

  if x >= 0 then
  begin
    Result := Trunc(min(max((x + 0.5),w_Mininteger),w_Maxinteger));
  end
  else
  begin
    Result := Trunc(min(max((x - 0.5),w_Mininteger),w_Maxinteger));
  end;
end;

function StrRoundoff(X: Extended): string;
var
  y: Extended;
   w_MaxExtended:Extended;
   w_MinExtended:Extended;
begin
  w_MaxExtended := 9223372036854775;//1.7 * Power(10,308) ;
  w_MinExtended :=-9223372036854775;//5.0 * Power(10,-324);
  if x >= 0 then
  begin
    y := Trunc(min(max((x + 0.5),w_MinExtended),w_MaxExtended) );
  end
  else
  begin
    y := Trunc(min(max((x - 0.5),w_MinExtended),w_MaxExtended) );
  end;
  Result := FormatFloat('###,###,###,###,###,##0',y);
end;

//�������_�ȉ��P�ʎl�̌ܓ�
function Roundoff2(X: Extended): Extended;
begin
  if x >= 0 then Result := Trunc(x + 0.5)
  else Result := Trunc(x - 0.5);
end;
//�����t���ŏ������ɂ���
function func_DateToFirstTime(
   arg_Date: TDate     //���t
  ):TDateTime;          //���t����
var
  w_s:string;
begin
   w_s := func_DateToStr(arg_Date) + ' ' ;
   w_s := w_s + '00' + TimeSeparator;
   w_s := w_s + '00' + TimeSeparator;
   w_s := w_s + '00' ;
   result:=func_StrToDateTime( w_s );
end;

//�����t���ŏI�����ɂ���
function func_DateToLastTime(
   arg_Date: TDate     //���t
  ):TDateTime;          //���t����
var
  w_s:string;
begin
   w_s := func_DateToStr(arg_Date) + ' ' ;
   w_s := w_s + '23' + TimeSeparator;
   w_s := w_s + '59' + TimeSeparator;
   w_s := w_s + '59' ;
   result:=func_StrToDateTime( w_s );
end;

//�����t��������t������ɂ���
function func_DateTimeToStr(
   arg_Date: TDateTime// ���t�̕�����
  ):string;          //���t
begin
  result:=FormatDateTime(gval_datetimefmt,arg_Date);
end;
//�����t����t������ɂ���
function func_DateToStr(
   arg_Date: TDate //���t
  ):string;          //
begin
  result:=FormatDateTime(gval_datefmt,arg_Date);
end;
//�����t���������t�����ɂ���
function func_StrToDateTime(
   arg_Str: string //���t�̕�����
  ):TDateTime;          //���t
var
  rtDateTime:TDateTime;
  w_Str:string;
begin
     w_Str:=arg_Str;
     rtDateTime:=func_StrToDate(w_Str);
     Delete(w_Str,1,11);
     rtDateTime:= rtDateTime + StrToTime(w_Str);
     result:=rtDateTime;
end;
//�����t���������t�ɂ���
function func_StrToDate(
   arg_Str: string //���̕�����
  ):TDate;          //���N��
var
  w_Date:TDate;
  w_Str:string;

  wi_yy:integer;
  wi_mm:integer;
  ws_yy:string;
  ws_mm:string;
  ws_dd:string;
  w_yy:word;
  w_mm:word;
  w_dd:word;
begin
  w_yy:=0;
  w_mm:=0;
  w_dd:=0;
  w_Str := arg_Str;
  wi_yy:=Pos(DateSeparator,w_Str) ;
  if wi_yy > 0 then
  begin
    ws_yy:=Copy(arg_Str,1,wi_yy - 1);
    w_yy:=StrToIntDef(ws_yy,0);
    Delete(w_Str,1,wi_yy);
    wi_mm:=Pos(DateSeparator,w_Str) ;
    if wi_mm > 0 then
    begin
      ws_mm:=Copy(w_Str,1,wi_mm - 1);
      w_mm:=StrToIntDef(ws_mm,0);
      Delete(w_Str,1,wi_mm);
      ws_dd := Copy(w_Str,1,2); //���ԑΉ��̂��ߒǉ�
      w_dd:=StrToIntDef(ws_dd,0);
    end;
  end;
  w_Date:=EncodeDate(w_yy,w_mm,w_dd);
  result := w_Date; //
end;

//���@�\:��������󔻒肷��i '' or '  '�j
function func_IsNullStr(arg_Str: string):Boolean;
begin
result:=false;
if length(trim(arg_Str)) = 0 then result:=true;
end;

//���@�\:DB�̃V�X�e������
function  func_GetDBSysDate(arg_Q_Pass:TQuery):TDateTime;
//res:string
begin
   arg_Q_Pass.close;
   arg_Q_Pass.SQL.Clear;
   arg_Q_Pass.SQL.Add('SELECT SYSDATE FROM DUAL');
   arg_Q_Pass.Prepare;
   arg_Q_Pass.Open;
   result := arg_Q_Pass.FieldValues['SYSDATE']
end;

//�� �o���A���gNULL���󕶎���ɕϊ��B
function func_VarToString( arg_VarString: Variant ):string;
begin
  if VarIsNull(arg_VarString) then
    result := ''
  else if VarType(arg_VarString) and varTypeMask = varString then
    result := VarAsType(arg_VarString,varString)
  else
    result := '';
end;

//���@�\�v���Z�X�̎��s(�I����҂�)
//Error:�Ȃ� ��O
{$HINTS OFF}
function func_WinExecWait(arg_ExeFile: string; arg_CmdLine: string):Boolean;
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  w_Param:string;
begin
  result:=false;

 //�\���̂̏�����

  FillChar(StartInfo, SizeOf(TStartupInfo), 0);
  FillChar(ProcInfo, SizeOf(TProcessInformation), 0);
  w_Param:=arg_ExeFile + ' ' + arg_CmdLine;
 //�����o�̐ݒ�

  StartInfo.dwFlags:= STARTF_USESHOWWINDOW;
  StartInfo.wShowWindow:= SW_SHOWNORMAL;

 //�v���Z�X�̐���
  result:=CreateProcess(nil,
                        PChar(w_Param),
                        nil,
                        nil,
                        false,
                        NORMAL_PRIORITY_CLASS,
                        nil,
                        nil,
                        StartINfo,
                        ProcINfo);


  //�v���Z�X�̏I����҂�
  if result then
  begin
    while WaitForSingleObject(ProcINfo.hProcess,0) = WAIT_TIMEOUT Do
       Application.ProcessMessages;
    CloseHandle(ProcINfo.hProcess);
  end;



end;
{$HINTS ON}
//���@�\�v���Z�X�̎��s
//Error:�Ȃ� ��O
{$HINTS OFF}
function func_WinExec(arg_ExeFile: string; arg_CmdLine: string):Boolean;
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  w_Param:string;
begin
  result:=false;

 //�\���̂̏�����

  FillChar(StartInfo, SizeOf(TStartupInfo), 0);
  FillChar(ProcInfo, SizeOf(TProcessInformation), 0);
  w_Param:=arg_ExeFile + ' ' + arg_CmdLine;
 //�����o�̐ݒ�

  StartInfo.dwFlags:= STARTF_USESHOWWINDOW;
  StartInfo.wShowWindow:= SW_SHOWNORMAL;

 //�v���Z�X�̐���
  result:=CreateProcess(nil,
                        PChar(w_Param),
                        nil,
                        nil,
                        false,
                        NORMAL_PRIORITY_CLASS,
                        nil,
                        nil,
                        StartINfo,
                        ProcINfo);

end;
{$HINTS ON}

procedure proc_FrmCenter(   arg_Form: TForm   );
begin
  arg_Form.left := (screen.Width  - arg_Form.Width  ) div 2;
  arg_Form.top  := (screen.Height - arg_Form.Height ) div 2;

end;
procedure proc_FrmAlign(arg_Form: TForm; arg_Align:string   );
begin
  if func_IsNullStr(arg_Align)
     and (not(arg_Align = g_WIN_ALIMENT_TR))
     and (not(arg_Align = g_WIN_ALIMENT_TL))
     and (not(arg_Align = g_WIN_ALIMENT_BR))
     and (not(arg_Align = g_WIN_ALIMENT_BL))
  then
  begin
  //���w��͂Ȃɂ����Ȃ�
//    arg_Form.left := (screen.Width  - arg_Form.Width  ) div 2;
//    arg_Form.top  := (screen.Height - arg_Form.Height ) div 2;
    exit;
  end;
  if  arg_Align[1]=g_WIN_ALIMENT_TOP then
  begin
     arg_Form.top  := 0;
  end;
  if  arg_Align[1]=g_WIN_ALIMENT_BOTTOM then
  begin
     arg_Form.top  := screen.Height - arg_Form.Height;
  end;
  if  arg_Align[2]=g_WIN_ALIMENT_LEFT then
  begin
     arg_Form.left  := 0;
  end;
  if  arg_Align[2]=g_WIN_ALIMENT_RIGTH then
  begin
     arg_Form.left  := screen.Width - arg_Form.Width;
  end;

end;


//���@�\���ԑ҂�
//Error:�Ȃ� ��O
procedure proc_delay( arg_timer: DWORD);
var w_finish:DWORD;
begin
  w_finish:= GetTickCount +  arg_timer;
  repeat
    Application.ProcessMessages
  until GetTickCount > w_finish
end;
//���@�\VB��Right()�̃G���n���X
//Error:bottom up �e�폈����O
function Right(const s:String; l:integer):string;
begin
  if  l>0 then
    if  Length(s) <l then Result := S
    else Result:=Copy(s,Length(s)-l+1,l)
  else Result:=''
end;
//���@�\VB��Left()�̃G���n���X
//Error:bottom up �e�폈����O
function Left(const s:String; l:integer):string;
begin
  Result:=Copy(s,1,l)
end;
//���@�\�R���|�[�l���g�𕶎���ɕϊ�
//Error:bottom up �e�폈����O
function func_ComponentToString(Component: TComponent): string;

var
  BinStream:TMemoryStream;
  StrStream: TStringStream;
  s: string;
begin
  BinStream := TMemoryStream.Create;
  try
    StrStream := TStringStream.Create(s);
    try
      BinStream.WriteComponent(Component);
      BinStream.Seek(0, soFromBeginning);
      ObjectBinaryToText(BinStream, StrStream);
      StrStream.Seek(0, soFromBeginning);
      Result:= StrStream.DataString;
    finally
      StrStream.Free;
    end;

  finally
    BinStream.Free
  end;
end;
//���@�\��������R���|�[�l���g�ɕϊ�
//Error:bottom up �e�폈����O
function func_StringToComponent(Value: string): TComponent;
var
  StrStream:TStringStream;
  BinStream: TMemoryStream;
begin
  StrStream := TStringStream.Create(Value);
  try
    BinStream := TMemoryStream.Create;
    try
      ObjectTextToBinary(StrStream, BinStream);
      BinStream.Seek(0, soFromBeginning);
      Result := BinStream.ReadComponent(nil);

    finally
      BinStream.Free;
    end;
  finally
    StrStream.Free;
  end;
end;

//��String��TStringList�ɕϊ�
//Error:bottom up �e�폈����O
function func_StrToTStrList(arg_Value: string):TStrings;
begin
  Result := TStringList.Create;
  Result.CommaText := arg_Value;
end;

//��TStringList��String�ɕϊ�
//Error:bottom up �e�폈����O
function func_TStrListToStr(Value: TStrings):string;
begin
  Result := Value.CommaText;
end;


//��arg_Str����r�؂�邱�Ƃ̖����悤��arg_BLen�o�C�g�ȉ��̕������Ԃ�
//Error:No
function func_BCopy(arg_Str: string;arg_BLen:integer):String;
Var
w_i:integer;
w_R:string;
w_Rl:integer;
w_X:string;
w_Xl:integer;

begin
  Result:='';
  w_R:='';

  for w_i := 1 to length(WideString(arg_Str)) do
  begin
    w_X:=copy(WideString(arg_Str),w_i,1);
    w_Rl:=Length(AnsiString(w_R));
    w_Xl:=Length(AnsiString(w_X));
    if (w_Rl+w_Xl)>arg_BLen then break;
    w_R:=w_R + w_X;
  end;
   result:=w_R;
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
    wkBuf := TrimRight(func_BCopy(EditStr,intCapa));
    if Length(wkBuf) < intCapa then
    begin
      wkBuf := wkBuf + chr(32);
    end;
  end;
  //�߂�l
  Result := wkBuf;
end;
//��TRIM�̔���
//Error:No
function func_UnTrim(arg_Str: string;arg_BLen:integer):String;
Var
w_i,w_l:integer;
w_R:string;
begin
  Result:='';
  w_l:=Length(AnsiString(arg_Str));
  if w_l>= arg_BLen then
    w_R:= func_BCopy(arg_Str,arg_BLen)
  else
  begin
    w_i:=(arg_BLen - w_l) div 2;
    w_R:=StringOfChar(' ',w_i) + arg_Str + StringOfChar(' ',w_i +1);
    w_R:= func_BCopy(w_R,arg_BLen);
  end;
  Result:=w_R;
end;

function func_UnTrim2(arg_Str: string;arg_BLen:integer):String;
begin
  Result:=StringOfChar(' ',arg_BLen)
          + arg_Str
          + StringOfChar(' ',arg_BLen);
end;

function func_UnTrim3(arg_Str: string;arg_BLen:integer):String;
Var
w_i:integer;
begin
  w_i:= arg_BLen - length( AnsiString(arg_Str));
  if w_i<0 then w_i:=0;
  w_i:=w_i div 2;
  Result:=StringOfChar(' ',w_i)
          + arg_Str
          + StringOfChar(' ',w_i);
end;


//���R���s���[�^IP�̎擾
//���A�l�F�R���s���[�^��
//Error:��O
function func_MachineNameToIP(arg_MName:string):string;
var
    wVersionReqested : WORD;
    wsaData : TWSAData;
    Status: Integer;
    s:array[0..255] of Char;
    p:PHostEnt;
    ip:PChar;
    w_s:string;
begin
  result :='';
  wVersionReqested := MAKEWORD(1,1);
  Status:=WSAStartup(wVersionReqested,wsaData);
  if Status<>0 then
  begin
    raise T_ErrSysExcep.Create(arg_MName + '��IP�A�h���X�͎擾�ł��܂���D');
    exit;
  end;
  try
     StrPCopy(s,arg_MName);
     p := GetHostByName(@s);
     if p<> nil then
     begin
       ip:= p^.h_addr_list^;
       w_s:=
            IntToStr(Integer(ip[0]))
           +'.'+IntToStr(Integer(ip[1]))
           +'.'+IntToStr(Integer(ip[2]))
           +'.'+IntToStr(Integer(ip[3]));
       result :=w_s;
     end;
  finally
  WSACleanup;
  end;
end;
//���R���s���[�^IP�̎擾
//���A�l�F�R���s���[�^��
//Error:��O
function func_GetThisMachineIPAdrr:string;
var
    wVersionReqested : WORD;
    wsaData : TWSAData;
    Status: Integer;
    s:array[1..128] of char;
    p:PHostEnt;
    p2:PChar;

begin
  result :='';
  wVersionReqested := MAKEWORD(1,1);
  Status:=WSAStartup(wVersionReqested,wsaData);
  if Status<>0 then
  begin
    raise T_ErrSysExcep.Create('���̃}�V����IP�A�h���X�͎擾�ł��܂���D');
    exit;
  end;
  try
     GetHostname(@s,128);
     p:=GetHostByName(@s);
     p2:= iNet_ntoa(PinAddr(p^.h_addr_list^)^);
     result:=p2;
  finally
  WSACleanup;
  end;
end;
//���R���s���[�^���̎擾
//���A�l�F�R���s���[�^��
//Error:��O
function func_GetThisMachineName:string;
var
    wVersionReqested : WORD;
    wsaData : TWSAData;
    Status: Integer;
    s:array[1..128] of char;
    p:PHostEnt;

begin
  result :='';
  wVersionReqested := MAKEWORD(1,1);
  Status:=WSAStartup(wVersionReqested,wsaData);
  if Status<>0 then
  begin
    raise T_ErrSysExcep.Create('���̃}�V���̖��O�͎擾�ł��܂���D');
    exit;
  end;
  try
     GetHostname(@s,128);
     p:=GetHostByName(@s);
     result:=p^.h_name;
  finally
  WSACleanup;
  end;
end;
//���R���s���[�^���̎擾
//���A�l�F�R���s���[�^��
//Error:��O
function func_ReadMachineName:string;
var reg:TRegistry;
begin
  result :='';
  reg:=TRegistry.Create;
  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKeyReadOnly('SYSTEM\CurrentControlSet\'+
                           'Control\ComputerName\ComputerName')
    then
    begin
      result := reg.ReadString('ComputerName');
    end
    else
    begin
      result :=''; //
    end;
  finally
    reg.Free;
  end;
end;

//���R���s���[�^���̎擾�J���n
//���A�l�F�R���s���[�^��
//Error:��O
function func_GetMachineName:string;
begin
  result := ''; //
  if g_PC_Name = '' then
  begin
      g_PC_Name := func_ReadMachineName;
  end;
  result :=g_PC_Name; //
end;
function func_GetMachineName2:string;
begin
  result := ''; //
  if g_PC_Name = '' then
  begin
      g_PC_Name := func_ReadMachineName;
  end;
  result :=Left(g_PC_Name,10); //
end;

//���N��v�Z
//���A�l�F�R���s���[�^��
//Error:��O
{$HINTS OFF}
function func_GetAge(arg_BirthDay:TDate; arg_Day:TDate):integer;
var
  w_Date:TDate;
  w_i:integer;
  w_yy_B:word;
  w_mm_B:word;
  w_dd_B:word;
  w_yy_D:word;
  w_mm_D:word;
  w_dd_D:word;
  w_Flg:String;
  w_Flg2:String;
begin
  //�߂�l
  result := 0;
  //���Ԃ�؂�̂āi�a�����j
  DecodeDate(arg_BirthDay,w_yy_B,w_mm_B,w_dd_B);
  arg_BirthDay:=EncodeDate(w_yy_B,w_mm_B,w_dd_B);
  //arg_BirthDay:= StrToDate(DateToStr(arg_BirthDay));
  //���Ԃ�؂�̂āi���t�j
  DecodeDate(arg_Day,w_yy_D,w_mm_D,w_dd_D);
  arg_Day:=EncodeDate(w_yy_D,w_mm_D,w_dd_D);
  //arg_Day:= StrToDate(DateToStr(arg_Day));
  //�a�������i�[
  w_Date:=arg_BirthDay;
  //�a���� >= ���t�̏ꍇ'0'�˕\��
  if w_Date >= arg_Day then
    //�����I��
    Exit;
  //������
  w_i := 0;
  //�t���O�iwhile�������t���O�j
  w_Flg := '';
  //�t���O�i�[���t���O�j
  w_Flg2 := '';
  //��r���t
  w_Date := w_Date + 1;
  //���t���傫���Ȃ�܂�
  while w_Date <= arg_Day do
  begin
    //���t����
    DecodeDate(w_Date,w_yy_D,w_mm_D,w_dd_D);
    //�a�������[���̏ꍇ
    if (w_mm_B = 2) and (w_dd_B = 29) then begin
      //2��29��������ꍇ
      if (w_mm_D = w_mm_B) and (w_dd_D = w_dd_B) then begin
        //1�΃v���X
        w_i:= w_i + 1;
        //�t���O�ݒ�
        w_Flg2 := '1';
      end
      //3��1���̏ꍇ
      else if (w_mm_D = 3) and (w_dd_D = 1) then begin
        //�t���O�m�F
        if (w_Flg <> '') and (w_Flg2 = '')  then
          //1�΃v���X
          w_i:= w_i + 1;
        //�t���O�ݒ�
        w_Flg2 := '';
      end;
    end
    //�a�������[���ȊO�Œa�����Ɠ������������ꍇ
    else if (w_mm_D = w_mm_B) and (w_dd_D = w_dd_B) then begin
      //1�΃v���X
      w_i:= w_i + 1;
    end;
    //���̓��Ɉړ�
    w_Date := w_Date + 1;
    //�t���O�ݒ�
    w_Flg := '1';
  end;
  //�߂�l
  result := w_i;

end;
{$HINTS ON}

//���������t�v�Z
//���A�l�F
//Error:��O
{$HINTS OFF}
function func_ChngDate(
   arg_Day:Tdate; arg_Case:integer  ):TDate;
var
  w_Date:TDate;
  w_yy:word;
  w_mm:word;
  w_dd:word;
begin
  result := arg_Day; //
  case  arg_Case of
    JUSIN_D: w_Date:=arg_Day;
    JUSIN_D0401:
    begin
       DecodeDate(arg_Day, w_yy ,w_mm,w_dd);
       if w_mm < 4 then  w_yy := w_yy - 1;
       w_mm:=4;
       w_dd:=1;
       w_Date:=EncodeDate( w_yy ,w_mm,w_dd);
    end;
    JUSIN_DN0331:
    begin
       DecodeDate(arg_Day, w_yy ,w_mm,w_dd);
       if w_mm > 3 then  w_yy := w_yy+1;
       w_mm:=3;
       w_dd:=31;
       w_Date:=EncodeDate( w_yy ,w_mm,w_dd);
    end;
    JUSIN_D1231:
    begin
       DecodeDate(arg_Day, w_yy ,w_mm,w_dd);
       w_yy:=w_yy;
       w_mm:=12;
       w_dd:=31;
       w_Date:=EncodeDate( w_yy ,w_mm,w_dd);
    end;
    JUSIN_D0101:
    begin
       DecodeDate(arg_Day, w_yy ,w_mm,w_dd);
       w_yy:=w_yy;
       w_mm:=1;
       w_dd:=1;
       w_Date:=EncodeDate( w_yy ,w_mm,w_dd);
    end;
    JUSIN_DN0101:
    begin
       DecodeDate(arg_Day, w_yy ,w_mm,w_dd);
       w_yy:=w_yy+1;
       w_mm:=1;
       w_dd:=1;
       w_Date:=EncodeDate( w_yy ,w_mm,w_dd);
    end;
    JUSIN_D01:
    begin
       DecodeDate(arg_Day, w_yy ,w_mm,w_dd);
       w_yy:=w_yy;
       w_mm:=w_mm;
       w_dd:=1;
       w_Date:=EncodeDate( w_yy ,w_mm,w_dd);
       //w_Date:= arg_Day + 1;
    end;
    JUSIN_DME:
    begin
       w_Date:=IncMonth(arg_Day,1);
       DecodeDate(w_Date, w_yy ,w_mm,w_dd);
       w_yy:=w_yy;
       w_mm:=w_mm;
       w_dd:=1;
       w_Date:= EncodeDate( w_yy ,w_mm,w_dd);
       w_Date:= w_Date -1 ;
    end;

    else
      w_Date:=arg_Day;
  end;

  result :=w_Date; //

end;
{$HINTS ON}

//�������N��v�Z
//���A�l�F
//Error:��O
{$HINTS OFF}
function func_GetAgeofCase(
   arg_BirthDay:Tdate; arg_Day:Tdate; arg_Case:integer  ):integer;
var
  w_Date:TDate;
begin
  result := 0; //
  w_Date:=func_ChngDate(arg_Day, arg_Case);
  result :=func_GetAge(arg_BirthDay,w_Date); //
end;
{$HINTS ON}

//�������4/1�N�x���t�ɕϊ�
//���A�l�F
//Error:��O
function func_ChngDate41(
   arg_Day:Tdate  ):Tdate;
begin
  result:=func_ChngDate(arg_Day, JUSIN_D0401);
end;

//���t�H���_���쐬����
//  �t�@�C���폜�t���O���P�̎��A���̃t�H���_���S�Ẵt�@�C�����폜����
//���A�l�F
//Error:��O
function func_MakeDirectories(
   arg_Directory: string;   //�쐬�t�H���_
   arg_FileDelete: integer  //�t�@�C���폜�t���O(�O�F�Ȃ��A�P�F����)
  ):Boolean;                //���A�l
begin
  result:=True;
  if not DirectoryExists(arg_Directory) then
    ForceDirectories(arg_Directory);
  if arg_FileDelete = 1 then
    func_DeleteFileAt(arg_Directory);
end;
//���t�H���_�̑S�t�@�C�����폜����
//���A�l�F
//Error:��O
function func_DeleteFileAt(
   arg_Directory: string    //�Ώۃt�H���_
  ):Boolean;                //���A�l
var
  SearchRec: TSearchRec;
  PathName: string;
begin
  result:=True;
  if not DirectoryExists(arg_Directory) then
  begin
    result:=False;
    Exit;
  end;
  // �w�肳�ꂽ�t�H���_�ɂ���t�@�C�������擾����B
  SysUtils.FindFirst(arg_Directory+'*.*', faAnyFile, SearchRec);
  try
    if SearchRec.Name='' then Exit;
    // �t�H���_����ɂȂ�܂ŁA�t�@�C����1���폜����B
    repeat
      PathName:=arg_Directory+SearchRec.Name;
      if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then
        SysUtils.DeleteFile(PathName);
    until SysUtils.FindNext(SearchRec)<>0;
  finally
    SysUtils.FindClose(SearchRec);
  end;
end;

//�����^�t�@�C������JPEG�t�@�C�����쐬����
//���A�l�F
//Error:��O
function func_MetafileToJpeg(
    arg_MetaFile:string;
    arg_JpegFile: string
   ): Boolean;
var
  LMetafile: TMetafile;
  LBitmap: TBitmap;
  LJpegImage: TJPEGImage;
  FileExt: string;
begin
  result:=True;

  if (arg_MetaFile = '') or
     (arg_JpegFile = '') then
  begin
    result:=False;
    Exit;
  end;
  // ���^�t�@�C���̃`�F�b�N
  FileExt := AnsiUpperCase(ExtractFileExt(arg_MetaFile));
  if (FileExt <> '.WMF') then
  begin
    Result:=False;
    Exit;
  end;
  if not FileExists(arg_MetaFile) then
  begin
    result:=False;
    Exit;
  end;
  // JPEG�t�@�C���̃`�F�b�N
  FileExt := AnsiUpperCase(ExtractFileExt(arg_JpegFile));
  if (FileExt <> '.JPG') and
     (FileExt <> '.JPEG') then
  begin
    Result:=False;
    Exit;
  end;
  if FileExists(arg_JpegFile) then
    SysUtils.DeleteFile(arg_JpegFile);
  // �R�s�[
  LMetafile := TMetafile.Create;
  LBitmap := TBitmap.Create;
  LJpegImage := TJPEGImage.Create;
  try
    LMetafile.LoadFromFile(arg_MetaFile);
    //
    LBitmap.PixelFormat := pf24bit; {24bit Color}
    LBitmap.Width := LMetafile.Width;
    LBitmap.Height := LMetafile.Height;
    LBitmap.Canvas.Draw(0, 0, LMetafile);
    //
    LJpegImage.Grayscale := False; {24bit Color}
    LJpegImage.Assign(LBitmap);
    LJpegImage.SaveToFile(arg_JpegFile);
    //
    LBitmap.Dormant;
    LBitmap.FreeImage;
    LBitmap.ReleaseHandle;
  finally
    LMetafile.Free;
    LBitmap.Free;
    LJpegImage.Free;
  end;
end;

//��JPEG�t�@�C������BMP�t�@�C�����쐬����
//���A�l�F
//Error:��O
function func_JpegfileToBmp(
    arg_JpegFile:string;
    arg_BmpFile: string
   ): Boolean;
var
  LBitmap: TBitmap;
  LJpegImage: TJPEGImage;
  FileExt: string;
begin
  result:=True;

  if (arg_BmpFile = '') or
     (arg_JpegFile = '') then
  begin
    result:=False;
    Exit;
  end;
  // JPEG�t�@�C���̃`�F�b�N
  FileExt := AnsiUpperCase(ExtractFileExt(arg_JpegFile));
  if (FileExt <> '.JPG') and
     (FileExt <> '.JPEG') then
  begin
    Result:=False;
    Exit;
  end;
  if not FileExists(arg_JpegFile) then
  begin
    result:=False;
    Exit;
  end;
  // BMP�t�@�C���̃`�F�b�N
  FileExt := AnsiUpperCase(ExtractFileExt(arg_BmpFile));
  if (FileExt <> '.BMP') then
  begin
    Result:=False;
    Exit;
  end;
  if FileExists(arg_BmpFile) then
    SysUtils.DeleteFile(arg_BmpFile);
  // �R�s�[
  LBitmap := TBitmap.Create;
  LJpegImage := TJPEGImage.Create;
  try
    LJpegImage.LoadFromFile(arg_JpegFile);
    LBitmap.Assign(LJpegImage);
    LBitmap.SaveToFile(arg_BmpFile);
  finally
    LJpegImage.free;
    LBitmap.free;
  end;
end;

//���t�@�C���R�s�[
procedure proc_CopyFile( arg_SrcName: string; arg_DesName: string );
var
  w_StreamSrc: TFileStream;
  w_StreamDes: TFileStream;
begin
  if not (FileExists(arg_SrcName)) then exit;
  w_StreamSrc:=TFileStream.Create(arg_SrcName,fmShareDenyNone or fmOpenRead );
  try
    w_StreamDes:=TFileStream.Create(arg_DesName,
                                    fmOpenWrite or fmCreate or fmShareDenyNone  );
    try
      w_StreamDes.CopyFrom(w_StreamSrc,w_StreamSrc.Size);
    finally
      w_StreamDes.Free;
    end;
  finally
    w_StreamSrc.Free;
  end;
end;

//���t�@�C���R�s�[
procedure proc_CopyFileEx(
  arg_SrcName: string;
  arg_DesName: string
  );
var
  w_FileName:string;
  w_Sr:TSearchRec;
  w_FileAttrs: Integer;

begin
  if not(DirectoryExists(arg_SrcName)) then
  begin
    raise T_ErrSysExcep.Create(arg_SrcName + '�͑��݂��܂���D');
    exit;
  end;
  if not(DirectoryExists(arg_DesName)) then
  begin
    raise T_ErrSysExcep.Create(arg_DesName + '�͑��݂��܂���D');
    exit;
  end;
  w_FileAttrs:=faReadOnly+faHidden+faSysFile+faVolumeID+faArchive;
  if FindFirst(arg_SrcName+'*.*', w_FileAttrs, w_Sr) = 0 then
  begin
    repeat
      w_FileName:=w_Sr.Name;
      proc_CopyFile(arg_SrcName + w_FileName,
                    arg_DesName + w_FileName);
    until FindNext(w_Sr) <> 0;
    FindClose(w_Sr);
  end;
    //�f�B���N�g�����ƃR�s�[
{
    w_TFileList:= TFileListBox.Create(w_Form);
    w_TFileList.Visible := False;
    w_TFileList.Directory := arg_SrcName;
    w_TFileList.Mask      := arg_Mask;
    w_TFileList.Update ;
    for w_i:=0 to w_TFileList.Items.Count-1 do
    begin
      w_FileName:=w_TFileList.Items[w_i];
      proc_CopyFile(arg_SrcName + w_FileName,
                    arg_DesName + w_FileName);
    end;
  finally
    w_TFileList.Free;
  end;
}
end;
//2003.10.27
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
  //'0'�o�C�g��
  len := intCapa - Length(EditStr);
  //������
  wkBuf := '';
  //�͈͓���
  if len > 0 then begin
    //�o�C�g������'0'�̍쐬
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

//���v���Z�X�����S��~�����ɑ҂��󂯂��s��
function WaitTime(const t,s: integer): Boolean;
var
    Timeout: TDateTime;
    w_i: integer;
begin
    w_i := 10;
    if s < t then w_i := s;
    Timeout := Now + t/24/3600/1000;  // �I������

    while (Now < Timeout) do begin
        Application.ProcessMessages;
        Sleep(w_i);                //���x�� 10ms �ȉ��ŗǂ��ꍇ
    end;

    Result := True;
end;
//������������
initialization
begin
//1)�N��PASS���m��
     G_RunPath := ExtractFilePath( ParamStr(0) );
     //��PASS���m��
     //�f�t�H���g�Ƃ��ċN��PASS
     G_EnvPath := G_RunPath;
     if ParamCount>0 then
      //�R�}���h���C�����擾
     if DirectoryExists(ParamStr(1)) then
          G_EnvPath := ParamStr(1);
//���̑����擾
     g_PC_Name:=func_ReadMachineName;
     DateSeparator:='/';
     TimeSeparator:=':';
     gval_datefmt:= gval_datefmtYY +DateSeparator+ gval_datefmtMM+DateSeparator+ gval_datefmtDD;
     gval_datetimefmt:= gval_datefmt+' '+gval_timefmtHH +TimeSeparator+ gval_timefmtNN+TimeSeparator+ gval_timefmtSS;
end;

//���I��������
finalization
begin

end;

end.
