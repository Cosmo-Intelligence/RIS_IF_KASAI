//******************************************************************************
//* unit name   : Unit_Log
//* author      : 
//* description : ���O��������
//******************************************************************************

//------------------------------------------------------------------------------
// ���j�b�g��`
//------------------------------------------------------------------------------
unit Unit_Log;

//------------------------------------------------------------------------------
interface
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// �C���N���[�h
//------------------------------------------------------------------------------
uses
  SysUtils, DateUtils, StdCtrls, Classes, SyncObjs
  ,Windows
  ,Unit_DirectoryComposite;

//------------------------------------------------------------------------------
// �e���J�^��`
//------------------------------------------------------------------------------
type
  {���O�������N���X}
  T_Log = class
  protected
    FMemo: TMemo;   // ���O�\���R���g���[��
  public
    procedure LOGOUT(const IpOutText: String); overload; virtual; abstract;
    procedure LOGOUT(const IpErr: Exception); overload; virtual; abstract;
    property Memo: TMemo read FMemo write FMemo;
  end;

  {���O�t�@�C�������N���X}
  T_FileLog = class(T_Log)
  private
    FLogging:           Boolean;          // ���O�o�̓t���O
    LogFilePath:        String;           // ���O�p�X
    LogPreFix:          String;           // ���O�v���t�B�b�N�X
    LogWcd:             String;           // ���C���h�J�[�h
    LogKeepDays:        Integer;          // �ۑ�����
    MvSection:          TCriticalSection; // �N���e�B�J���Z�N�V����
    FFileSize:          integer;

    {���O�e�L�X�g�o��}
    function Add(LogText: String): Boolean;
    procedure CheckFileSize(const IpFile: String);
  public
    {�R���X�g���N�^}
    constructor Create(const IpFilePath, IpPreFix: String;
                       IpLogging: boolean; IpKeepDays, IpFileSize: integer; IpMemo: TMemo);
    {�f�X�g���N�^}
    destructor Destroy; override;

    {���ւ�菈��}
    procedure DayChange();

    // ���O�o�͏���
    procedure LOGOUT(const IpOutText: String); overload; override;
    procedure LOGOUT(const IpErr: Exception); overload; override;
  end;

//------------------------------------------------------------------------------
//  �e���J�萔
//------------------------------------------------------------------------------
const
  LOG_WCD = '*.log';                //���O���C���h�J�[�h

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

uses
  Unit_TreatFile;

//------------------------------------------------------------------------------
//T_Log
//------------------------------------------------------------------------------
//******************************************************************************
//* function name       : T_FileLog.Create
//* description         : �R���X�g���N�^
//*   <function>
//*     �N���X������������B
//*   <include file>
//*   <calling sequence>
//*   <remarks>
//******************************************************************************
constructor T_FileLog.Create(const IpFilePath, IpPreFix: String;
                                   IpLogging: boolean; IpKeepDays, IpFileSize: integer; IpMemo: TMemo);
var
  boRslt:   Boolean;
begin
  inherited Create();

  // �f�B���N�g�����Ȃ���΍��
  boRslt:= DirectoryExists(IpFilePath);
  if (boRslt = false) then begin
    ForceDirectories(IpFilePath);
  end;

  MvSection:= TCriticalSection.Create();

  // ������
  FLogging    := IpLogging;
  LogFilePath := IpFilePath;
  LogPreFix   := IpPreFix;
  LogKeepDays := IpKeepDays;
  LogWcd      := LOG_WCD;
  FMemo       := IpMemo;
  FFileSize   := IpFileSize;

  //�Â��t�@�C��������
  DayChange;
end;

//******************************************************************************
//* function name       : T_FileLog.Destroy
//* description         : �f�X�g���N�^
//*   <function>
//*     �N���X��j������B
//*   <include file>
//*   <calling sequence>
//*   <remarks>
//******************************************************************************
destructor T_FileLog.Destroy;
begin
  MvSection.Free();
  inherited Destroy();
end;

//******************************************************************************
//* function name       : T_FileLog.Add
//* description         : ���O�e�L�X�g�o��
//*   <function>
//*     �e�L�X�g�����O�t�@�C���ɏo��
//*   <include file>
//*   <calling sequence>
//*     T_FileLog.DayChange;
//*   <remarks>
//******************************************************************************
function T_FileLog.Add(LogText: String): Boolean;
var
  RetCode:    Boolean;
  W_F:        TextFile;  //���O�t�@�C��
  FileName:   String;    //�t�@�C����
  messtr:     String;    //���O���b�Z�[�W
  logDate:    String;
begin
  Result := False;

  //2018/08/30 ���O�t�@�C���ύX
  //���t�t�H���_�쐬
  logDate:= FormatDateTime( 'yyyymmdd', Date );
  FileName:= LogFilePath + IncludeTrailingBackslash(logDate);

  try
    // �f�B���N�g�����Ȃ���΍��
    if (DirectoryExists(FileName) = false) then begin
      ForceDirectories(FileName);
    end;
    FileName:= FileName + LogPreFix + logDate + '.log';

    //2018/08/30 ���O�t�@�C���ύX
    CheckFileSize(FileName);

    //���b�Z�[�W����
    messtr := FormatDateTime( 'yyyy/mm/dd hh:nn:ss ',Now );
    messtr := messtr + LogText;

    //���b�Z�[�W�o��
    AssignFile( W_F, FileName );

    RetCode := FileExists( FileName );
    if RetCode = True then begin
      Append( W_F );
    end
    else begin
      Rewrite( W_F );
      //�Â��t�@�C��������
      DayChange;
    end;

    Writeln( W_F, messtr );
    CloseFile( W_F );
    if Assigned( FMemo ) then FMemo.Lines.Add( messtr );
    Result := True;
  except
  end;

end;

//******************************************************************************
//* function name       : CheckFileSize
//* description         : �t�@�C���T�C�Y�m�F
//*   <function>
//*     �t�@�C���T�C�Y���߁��o�b�N�A�b�v�t�@�C�����쐬
//*   <include file>
//*   <calling sequence>
//*
//*   <remarks>
//******************************************************************************
procedure T_FileLog.CheckFileSize(const IpFile: String);
var
  handle: integer;
  fileSize: integer;
  bkFile: String;
  fileStamp: String;
begin
  if FileExists(IpFile) = false then begin
    exit;
  end;

  try
    //�T�C�Y�擾
    handle:=  FileOpen(IpFile, fmOpenRead);
    fileSize:= GetFileSize(handle, nil);
  finally
    FileClose(handle);  
  end;

  if (fileSize > FFileSize) then begin
    //�t�@�C�����ύX
    DateTimeToString(fileStamp, 'hhnnss',Now); 
    bkFile:= ChangeFileExt(IpFile, '.' + fileStamp);
    RenameFile(IpFile, bkFile);
  end;
end;

//******************************************************************************
//* function name       : T_FileLog.DayChange
//* description         : ���O�t�@�C�����ւ�菈��
//*   <function>
//*     �ۑ������ȊO�̃��O���폜����B
//*   <include file>
//*   <calling sequence>
//*     T_FileLog.DayChange;
//*   <remarks>
//******************************************************************************
procedure T_FileLog.DayChange;
var
  LvDirNM:      String;         //�f�B���N�g���� yyyymmdd
  LvDateStr:    String;         //�f�B���N�g���� yyyy/mm/dd
  LvDirDate:    TDateTime;      //�f�B���N�g���̓��t
  LvDiff:       integer;        //���t�̍�
  LvCnt:        integer;
  LvSrcDir:     T_Entry;        //�����f�B���N�g��
  LvTreat:      T_TreatFile;
begin
  //������
  LvSrcDir:= T_Directory.Create(LogFilePath);
  LvTreat:=  T_TreatFile.Create(Self);

  try
    //�T�u�f�B���N�g������
    LvSrcDir.Search(entryDir);

    //�ۑ��������߂��Ă���f�B���N�g�����폜
    for LvCnt:= 0 to LvSrcDir.Count -1 do begin
      //�f�B���N�g�����擾
      LvDirNM:= ExtractFileName( LvSrcDir.SubEntries[LvCnt] );
      //�f�B���N�g���[��������t���擾
      LvDateStr:= Copy(LvDirNM, 1, 4) + '/'
                + Copy(LvDirNM, 5, 2) + '/'
                + Copy(LvDirNM, 7, 2);
      LvDirDate:= StrToDateTimeDef( LvDateStr, -1 );
      //�f�B���N�g���[���� YYYYMMDD�`�� �̂ݏ����Ώ�
      if LvDirDate < 0 then begin
        continue;
      end;

      //���t�̍������߂�
      LvDiff:= DaysBetween(Now(), LvDirDate);
      //�ۑ��������߂��Ă���΍폜
      if (LvDiff > LogKeepDays) then begin
        LvDirNM:= LogFilePath + LvDirNM;
        if (LvTreat.Delete( LvDirNM ) = true) then begin
          LOGOUT( Format('�ۑ������𒴉߂����f�B���N�g��: %s ���폜���܂����B', [LvDirNM]) );
        end;
      end;
    end;

  finally
    LvSrcDir.Free;
    LvTreat.Free;
  end;
end;

//******************************************************************************
//* function name       : T_FileLog.LOGOUT
//* description         : �������O�o�͏���
//*   <function>
//*     �������O������̃��O�o�͂��s���B
//*   <include file>
//*   <calling sequence>
//*     TA001.proc_LOGOUT
//*   <remarks>
//******************************************************************************
procedure T_FileLog.LOGOUT(const IpOutText: String);
begin
  // ���O�o�͔��f
  if (FLogging = False) then exit;

  MvSection.Enter();
  try
    // ���O�ǉ�
    Add(IpOutText);
  finally
    MvSection.Release();
  end;
end;

procedure T_FileLog.LOGOUT(const IpErr: Exception);
begin
  LOGOUT( Format('%s: %s', [IpErr.ClassName, IpErr.Message]) );
end;

end.

