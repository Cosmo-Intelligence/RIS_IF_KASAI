// -----------------------------------------------------------------------------
//  �y�t�@�C������N���X�z
//       Date: 2006/02   Mod: New   Name: S.Matsumoto
// -----------------------------------------------------------------------------
//------------------------------------------------------------------------------
// ���j�b�g��`
//------------------------------------------------------------------------------
unit Unit_TreatFile;

//------------------------------------------------------------------------------
interface
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// �C���N���[�h
//------------------------------------------------------------------------------
uses
  SysUtils, classes, DateUtils,
  Unit_Log,
  Unit_DirectoryComposite,
  Unit_FileOperation;

//------------------------------------------------------------------------------
// �e���J�^��`
//------------------------------------------------------------------------------
type T_TreatFile = class
  private
    MvLog:      T_Log;
    MvOperation: T_FileOperation;     //�t�@�C������p�I�u�W�F�N�g
    function ChkDirectory(const IpDir: String): boolean;
  public
    constructor Create(IpLog: T_Log);
    destructor Destroy(); override;
    //�e�t�@�C���E�f�B���N�g������
    function Move(const IpFile, IpDst: String): boolean;
    function Copy(const IpFile, IpDst: String): boolean;
    function ReName(const IpFile, IpDst: String): boolean;
    function Delete(const IpSrc: String): boolean;
  end;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// T_TreatFile �e���\�b�h����
//------------------------------------------------------------------------------

//******************************************************************************
//* function name       : T_TreatFile.Create(IpLog: T_Log);
//* description         : �R���X�g���N�^�[
//*   <function>
//*       �R���X�g���N�^�[
//*   <include file>
//*   <calling sequence>
//*     Create((IpLog: T_Log);
//*       IpLog:      T_Log    (IN)  Log�o�̓N���X�̃C���X�^���X
//*   <remarks>
//******************************************************************************
constructor T_TreatFile.Create(IpLog: T_Log);
begin
  inherited Create;
  MvLog:= IpLog;
  MvOperation:= T_FileOperation.Create();
end;

//******************************************************************************
//* function name       : T_TreatFile.Destroy;
//* description         : �f�X�g���N�^�[
//*   <function>
//*       �f�X�g���N�^�[
//*   <include file>
//*   <calling sequence>
//*     Destroy;
//*   <remarks>
//******************************************************************************
destructor T_TreatFile.Destroy;
begin
  MvOperation.Free();
  inherited destroy();
end;

//******************************************************************************
//* function name       : ChkDirectory(const IpDir: String): boolean;
//* description         : �f�B���N�g���݊m�F
//*   <function>
//*     �f�B���N�g���݊m�F(�Ȃ���΍��)
//*   <include file>
//*   <calling sequence>
//*     ChkDirectory(const IpDir: String): boolean;
//*   <remarks>
//******************************************************************************
function T_TreatFile.ChkDirectory(const IpDir: String): boolean;
begin
  result:= true;
  try
    //�f�B���N�g���`�F�b�N(�Ȃ���΍��)
    if (DirectoryExists( IpDir ) = false) then begin
      if ForceDirectories(IpDir) = false then begin
        result:= false;
      end;
    end;
  except
    result:= false;
  end;
end;
//******************************************************************************
//* function name       : Copy(const IpFile, IpDst: String): boolean;
//* description         : �t�@�C���R�s�[
//*   <function>
//*     �t�@�C�����R�s�[����
//*   <include file>
//*   <calling sequence>
//*     Copy(const IpFile, IpDst: String): boolean;
//*         IpFile: String    (IN)    �R�s�[���t�@�C��
//*         IpDst:  String    (IN)    �R�s�[��̃f�B���N�g��
//*         result: boolean   (RET)   ��������(T:���� F:���s)
//*   <remarks>
//******************************************************************************
function T_TreatFile.Copy(const IpFile, IpDst: String): boolean;
begin
  //�f�B���N�g���`�F�b�N(�Ȃ���΍��)
  result:= ChkDirectory( ExtractFileDir(IpDst) );
  if (result = false) then begin
    MvLog.LOGOUT( Format( '�f�B���N�g�� %s �̍쐬�Ɏ��s���܂����B', [IpDst]) );
    exit;
  end;

  //�t�@�C�����݃`�F�b�N
  result:= FileExists(IpFile);
  if (result = false) then begin
    MvLog.LOGOUT( Format( '�t�@�C�� %s ��������܂���B', [IpFile]) );
    exit;
  end;

  result:= MvOperation.Execute(IpFile, IpDst, shkCopy);
  if (result = false) then begin
    MvLog.LOGOUT( Format( '�t�@�C���̃R�s�[�Ɏ��s���܂���: %s �� %s', [IpFile, IpDst]) );
    MvLog.LOGOUT( Format( '�G���[: %s', [MvOperation.Err]) );
  end;
end;

//******************************************************************************
//* function name       : Move(const IpFile, IpDst: String): boolean;
//* description         : �t�@�C���ړ�
//*   <function>
//*     �t�@�C�����ړ�������
//*   <include file>
//*   <calling sequence>
//*     Move(const IpFile, IpDst: String): boolean;
//*         IpFile: String    (IN)    �ړ����t�@�C��
//*         IpDst:  String    (IN)    �ړ���̃f�B���N�g��
//*         result: boolean   (RET)   ��������(T:���� F:���s)
//*   <remarks>
//*     (��)IpDst �ɂ͕K���f�B���N�g�����w�肷�邱��
//******************************************************************************
function T_TreatFile.Move(const IpFile, IpDst: String): boolean;
begin
  //�f�B���N�g���`�F�b�N(�Ȃ���΍��)
  result:= ChkDirectory( IpDst );
  if (result = false) then begin
    MvLog.LOGOUT( Format( '�f�B���N�g�� %s �̍쐬�Ɏ��s���܂����B', [IpDst]) );
    exit;
  end;

  //�t�@�C�����݃`�F�b�N
  result:= FileExists(IpFile);
  if (result = false) then begin
    MvLog.LOGOUT( Format( '�t�@�C�� %s ��������܂���B', [IpFile]) );
    exit;
  end;

  result:= MvOperation.Execute(IpFile, IpDst, shkMove);
  if (result = false) then begin
    MvLog.LOGOUT( Format( '�t�@�C���̈ړ��Ɏ��s���܂���: %s �� %s', [IpFile, IpDst]) );
    MvLog.LOGOUT( Format( '�G���[: %s', [MvOperation.Err]) );
  end;
end;

//******************************************************************************
//* function name       : Rename(const IpFile, IpDst: String): boolean;
//* description         : �t�@�C�����̕ύX
//*   <function>
//*     �t�@�C���̖��̂�ύX����(�ύX���͕ۑ�����Ȃ�)
//*   <include file>
//*   <calling sequence>
//*     Rename(const IpFile, IpDst: String): boolean;
//*         IpFile: String    (IN)    �ύX�O�̃t�@�C��
//*         IpDst:  String    (IN)    �ύX��̃t�@�C��
//*         result: boolean   (RET)   ��������(T:���� F:���s)
//*   <remarks>
//******************************************************************************
function T_TreatFile.Rename(const IpFile, IpDst: String): boolean;
begin
  //�f�B���N�g���`�F�b�N(�Ȃ���΍��)
  result:= ChkDirectory( ExtractFileDir(IpDst) );
  if (result = false) then begin
    MvLog.LOGOUT( Format( '�f�B���N�g�� %s �̍쐬�Ɏ��s���܂����B', [IpDst]) );
    exit;
  end;

  //�t�@�C�����݃`�F�b�N
  result:= FileExists(IpFile);
  if (result = false) then begin
    MvLog.LOGOUT( Format( '�t�@�C�� %s ��������܂���B', [IpFile]) );
    exit;
  end;

  result:= RenameFile(IpFile, IpDst);
  if (result = false) then begin
    MvLog.LOGOUT( Format( '�t�@�C����ReName�Ɏ��s���܂���: %s �� %s', [IpFile, IpDst]) );
  end;
end;

//******************************************************************************
//* function name       : Delete(const IpSrc: String): boolean;
//* description         : �t�@�C���E�f�B���N�g���폜
//*   <function>
//*     �t�@�C���E�f�B���N�g�����폜����
//*   <include file>
//*   <calling sequence>
//*     Delete(const IpSrc: String): boolean;
//*         IpSrc: String     (IN)    �폜����t�@�C���E�f�B���N�g��
//*         result: boolean   (RET)   ��������(T:���� F:���s)
//*   <remarks>
//*     (��)IpSrc�Ƀf�B���g�����w�肷�鎞�� �Ō�� '\' �����Ȃ�����
//******************************************************************************
function T_TreatFile.Delete(const IpSrc: String): boolean;
begin
  //�t�@�C���E�f�B���N�g�����݃`�F�b�N
  result:= ( FileExists(IpSrc) or DirectoryExists(IpSrc) );
  if (result = false) then begin
    MvLog.LOGOUT( Format( '�t�@�C���E�f�B���N�g�� %s ��������܂���B', [IpSrc]) );
    exit;
  end;

  result:= MvOperation.Execute( IpSrc, '', shkDelete);
  if (result = false) then begin
    MvLog.LOGOUT( Format( '�t�@�C���E�f�B���N�g���̍폜�Ɏ��s���܂���: %s ', [IpSrc]) );
    MvLog.LOGOUT( Format( '�G���[: %s', [MvOperation.Err]) );
  end;
end;


end.
