// -----------------------------------------------------------------------------
//  �y�f�B���N�g���\�����R���|�W�b�g�ŕ\�������N���X�z
//       Date: 2005/09   Mod: New   Name: S.Matsumoto
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// ���j�b�g��`
//------------------------------------------------------------------------------
unit Unit_DirectoryComposite;

//------------------------------------------------------------------------------
interface
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// �C���N���[�h
//------------------------------------------------------------------------------
uses
  classes, SysUtils, contnrs;

//------------------------------------------------------------------------------
// �e���J�^��`
//------------------------------------------------------------------------------
type

  //�f�B���N�g�\���v�f�̎��
  T_EntryKind = (entryAll,      //�S��
                 entryFile,     //�t�@�C��
                 entryDir);     //�f�B���N�g��

  //�f�B���N�g�\���x�[�X�N���X
  T_Entry = class
    private
      MvName: String;           //�G���g���[�̖��O(��΃p�X���܂�)
      MvEntries: TObjectList;
      function GetCount: integer;
      function GetSubEntry(IpIdx: integer): String;   //�f�B���N�g�������̃t�@�C���ƃf�B���N�g��
    protected
      property Name: String read MvName;
      property Entries: TObjectList read MvEntries write MvEntries;
    public
      Constructor Create(const IpName: String);
      Destructor  Destroy(); override;
      //�������폜����(�f�B���N�g���̎��͔z���̃G���g�����폜)
      procedure Delete(); virtual; abstract;
      //�����̃T�u�G���g���[���擾
      procedure Search(IpType: T_EntryKind = entryAll); virtual; abstract;
      //�T�u�G���g���[�̖��O���擾
      property SubEntries[IpIdx: integer]: String read GetSubEntry;
      //�����̃T�u�G���g���[�̐����擾
      property Count: integer read GetCount;
  end;

  //�t�@�C���N���X
  T_File = class(T_Entry)
    protected
    public
      Constructor Create(const IpName: String);
      Destructor  Destroy(); override;
      procedure Delete(); override;
      procedure Search(IpType: T_EntryKind = entryAll); override;
  end;

  //�f�B���N�g���N���X
  T_Directory = class(T_Entry)
    private
      MvMask: String;
    protected
    public
      Constructor Create(const IpName: String); overload;
      Constructor Create(const IpName: String; const IpMask: String); overload;
      Destructor  Destroy(); override;
      procedure Delete(); override;
      procedure Search(IpType: T_EntryKind = entryAll); override;
  end;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// T_Entry�N���X �e���\�b�h����
//------------------------------------------------------------------------------

//******************************************************************************
//* function name       : T_Entry.Create(const IpName: String);
//* description         : �R���X�g���N�^�[
//*   <function>
//*       �R���X�g���N�^�[
//*   <include file>
//*   <calling sequence>
//*     Create(const IpName: String);
//*       IpName:   String   (IN)  �G���g���[�̖��O(��΃p�X���܂�)
//*   <remarks>
//******************************************************************************
constructor T_Entry.Create(const IpName: String);
begin
  inherited Create();
  MvName:= IpName;
  MvEntries:= nil;
end;

//******************************************************************************
//* function name       : T_Entry.Destroy;
//* description         : �f�X�g���N�^�[
//*   <function>
//*       �f�X�g���N�^�[
//*   <include file>
//*   <calling sequence>
//*     Destroy;
//*   <remarks>
//******************************************************************************
destructor T_Entry.Destroy;
begin
  MvEntries.Free;
  inherited Destroy;
end;

//******************************************************************************
//* function name       : T_Entry.GetCount: integer;
//* description         : �T�u�G���g���[�̐����擾
//*   <function>
//*       �T�u�G���g���[�̐����擾����
//*   <include file>
//*   <calling sequence>
//*     GetCount: integer;
//*       Result:   integer   (OUT)   MvEntries�̃J�E���g
//*   <remarks>
//      �K�� Search ���Ăяo���Ă���g�p���邱��
//******************************************************************************
function T_Entry.GetCount: integer;
begin
  result:= 0;
  if MvEntries <> nil then result:= MvEntries.Count;
end;

//******************************************************************************
//* function name       : T_Entry.GetSubEntry(IpIdx: integer): String;
//* description         : �G���g���[�̖��O�擾
//*   <function>
//*       �C���f�b�N�X�Ŏw�肵���G���g���̖��O���擾����
//*   <include file>
//*   <calling sequence>
//*     GetSubEntry(IpIdx: integer): String;
//*       IpIdx: integer  (IN)  �T�u�G���g���[�̃C���f�b�N�X�ԍ�
//*       Result:String   (OUT) �T�u�G���g���[�̖��O(��΃p�X���܂�)
//*   <remarks>
//      �K�� Search ���Ăяo���Ă���g�p���邱��
//******************************************************************************
function T_Entry.GetSubEntry(IpIdx: integer): String;
begin
  result:= '';
  if (IpIdx >= Self.Count) or (IpIdx < 0) then exit;
  result:= (MvEntries[IpIdx] as T_Entry).Name;
end;


//------------------------------------------------------------------------------
// T_File�N���X �e���\�b�h����
//------------------------------------------------------------------------------

//******************************************************************************
//* function name       : T_File.Create(const IpName: String);
//* description         : �R���X�g���N�^�[
//*   <function>
//*       �R���X�g���N�^�[
//*   <include file>
//*   <calling sequence>
//*     Create(const IpName: String);
//*       IpName: String     (IN)  �G���g���[�̖��O(��΃p�X���܂�)
//*   <remarks>
//******************************************************************************
constructor T_File.Create(const IpName: String);
begin
  inherited Create(IpName);
end;

//******************************************************************************
//* function name       : T_File..Destroy;
//* description         : �f�X�g���N�^�[
//*   <function>
//*     �f�X�g���N�^�[
//*   <include file>
//*   <calling sequence>
//*     Destroy;
//*   <remarks>
//******************************************************************************
destructor T_File.Destroy;
begin
  inherited Destroy;
end;


//******************************************************************************
//* function name       : T_File.Delete;
//* description         : �t�@�C���폜
//*   <function>
//*     �������g(�t�@�C��)���폜����
//*   <include file>
//*   <calling sequence>
//*     Delete;
//*   <remarks>
//******************************************************************************
procedure T_File.Delete;
begin
  DeleteFile(Self.Name);
end;

//******************************************************************************
//* function name       : T_File.Search(IpType: T_EntryKind = entryAll);
//* description         : �T�u�G���g���[�擾
//*   <function>
//*     �T�u�G���g���[���擾�擾����
//*   <include file>
//*   <calling sequence>
//*     Search(IpType: T_EntryKind = entryAll);
//*       IpType: T_EntryKind   (IN) ��������G���g���[�̎��(�f�t�H���g�͑S��)
//*   <remarks>
//*     �t�@�C���̓T�u�G���g���[�������Ȃ��̂� Entries �� Nil �ł���
//******************************************************************************
procedure T_File.Search(IpType: T_EntryKind = entryAll);
begin
  Entries:= nil;
end;


//------------------------------------------------------------------------------
// T_Directory�N���X �e���\�b�h����
//------------------------------------------------------------------------------

//******************************************************************************
//* function name       : T_Directory.Create(const IpName: String);
//* description         : �R���X�g���N�^�[
//*   <function>
//*       �R���X�g���N�^�[
//*   <include file>
//*   <calling sequence>
//*     Create(const IpName: String);
//*       IpName: String     (IN)  �G���g���[�̖��O(��΃p�X���܂�)
//*   <remarks>
//******************************************************************************
constructor T_Directory.Create(const IpName: String);
begin
  inherited Create(IpName);
  Entries:= TObjectList.Create(true);
  MvMask:= '';
end;

constructor T_Directory.Create(const IpName: String; const IpMask: String);
begin
  inherited Create(IpName);
  Entries:= TObjectList.Create(true);
  MvMask:= IpMask;
end;

//******************************************************************************
//* function name       : T_Directory.Destroy;
//* description         : �f�X�g���N�^�[
//*   <function>
//*       �f�X�g���N�^�[
//*   <include file>
//*   <calling sequence>
//*     Destroy;
//*   <remarks>
//******************************************************************************
destructor T_Directory.Destroy;
begin
  Entries.Free;
  Entries:= nil;
  inherited Destroy;
end;


//******************************************************************************
//* function name       : T_Directory.Delete;
//* description         : �f�B���N�g���폜
//*   <function>
//*       �������g(�f�B���N�g��)���폜����B�T�u�G���g���[���S�č폜����
//*   <include file>
//*   <calling sequence>
//*     Delete;
//*   <remarks>
//******************************************************************************
procedure T_Directory.Delete;
var
  LvCnt: integer;
begin
  //�f�B���N�g�������̃t�@�C���ƃf�B���N�g�����擾
  Search();

  //�T�u�f�B���N�g���ƃt�@�C����S�č폜������A�f�B���N�g�����폜
  with Entries do begin
    for LvCnt:= 0 to Count -1 do begin
      (Items[LvCnt] as T_Entry).Delete;
    end;
    RemoveDir(Self.Name);
  end;
end;


//******************************************************************************
//* function name       : T_Directory.Search(IpType: T_EntryKind = entryAll);
//* description         : �T�u�G���g���[�擾
//*   <function>
//*       �����̃T�u�G���g���[���擾����
//*   <include file>
//*   <calling sequence>
//*     Search(IpType: T_EntryKind = entryAll);
//*       IpType: T_EntryKind (IN)  �擾����G���g���[�̎��(�f�t�H���g�͑S��)
//*   <remarks>
//******************************************************************************
procedure T_Directory.Search(IpType: T_EntryKind = entryAll);
var
  Rec: TSearchRec;  //�������R�[�h
  LvPath: String;   //�����p�X
  iRslt: integer;
begin
  //List������
  Entries.Clear;
  //�����p�X�擾
  LvPath:= IncludeTrailingPathDelimiter(Self.Name);
  //�G���g���[����
  if MvMask = '' then iRslt:= FindFirst(LvPath + '*.*',  faAnyFile, Rec)
  else                iRslt:= FindFirst(LvPath + MvMask, faAnyFile, Rec);

  try

    while (iRslt = 0) do begin
      //'.', '..'�͏���
      if (Rec.Name <> '.') and (Rec.Name <> '..') then begin
        //�����ύX
        FileSetAttr( LvPath + Rec.Name
                    , Rec.Attr and (not faReadOnly) and (not faHidden) );

        //List�ɒǉ�
        if ((Rec.Attr and faDirectory) <> 0)
          and ((IpType = entryAll) or (IpType = entryDir)) then
          //�f�B���N�g��
          Entries.Add(T_Directory.Create(LvPath + Rec.Name) )
        else if ((IpType = entryAll) or (IpType = entryFile)) then
          //�t�@�C��
          Entries.Add(T_File.Create(LvPath + Rec.Name) );
      end;
      //��������
      iRslt:= FindNext(Rec);
    end;

  finally
    FindClose(Rec);
  end;

end;

end.


