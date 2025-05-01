// -----------------------------------------------------------------------------
//  【ディレクトリ構造をコンポジットで表現したクラス】
//       Date: 2005/09   Mod: New   Name: S.Matsumoto
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// ユニット定義
//------------------------------------------------------------------------------
unit Unit_DirectoryComposite;

//------------------------------------------------------------------------------
interface
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// インクルード
//------------------------------------------------------------------------------
uses
  classes, SysUtils, contnrs;

//------------------------------------------------------------------------------
// 各公開型定義
//------------------------------------------------------------------------------
type

  //ディレクト構成要素の種類
  T_EntryKind = (entryAll,      //全て
                 entryFile,     //ファイル
                 entryDir);     //ディレクトリ

  //ディレクト表現ベースクラス
  T_Entry = class
    private
      MvName: String;           //エントリーの名前(絶対パスを含む)
      MvEntries: TObjectList;
      function GetCount: integer;
      function GetSubEntry(IpIdx: integer): String;   //ディレクトリ直下のファイルとディレクトリ
    protected
      property Name: String read MvName;
      property Entries: TObjectList read MvEntries write MvEntries;
    public
      Constructor Create(const IpName: String);
      Destructor  Destroy(); override;
      //自分を削除する(ディレクトリの時は配下のエントリも削除)
      procedure Delete(); virtual; abstract;
      //直下のサブエントリーを取得
      procedure Search(IpType: T_EntryKind = entryAll); virtual; abstract;
      //サブエントリーの名前を取得
      property SubEntries[IpIdx: integer]: String read GetSubEntry;
      //直下のサブエントリーの数を取得
      property Count: integer read GetCount;
  end;

  //ファイルクラス
  T_File = class(T_Entry)
    protected
    public
      Constructor Create(const IpName: String);
      Destructor  Destroy(); override;
      procedure Delete(); override;
      procedure Search(IpType: T_EntryKind = entryAll); override;
  end;

  //ディレクトリクラス
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
// T_Entryクラス 各メソッド実装
//------------------------------------------------------------------------------

//******************************************************************************
//* function name       : T_Entry.Create(const IpName: String);
//* description         : コンストラクター
//*   <function>
//*       コンストラクター
//*   <include file>
//*   <calling sequence>
//*     Create(const IpName: String);
//*       IpName:   String   (IN)  エントリーの名前(絶対パスを含む)
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
//* description         : デストラクター
//*   <function>
//*       デストラクター
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
//* description         : サブエントリーの数を取得
//*   <function>
//*       サブエントリーの数を取得する
//*   <include file>
//*   <calling sequence>
//*     GetCount: integer;
//*       Result:   integer   (OUT)   MvEntriesのカウント
//*   <remarks>
//      必ず Search を呼び出してから使用すること
//******************************************************************************
function T_Entry.GetCount: integer;
begin
  result:= 0;
  if MvEntries <> nil then result:= MvEntries.Count;
end;

//******************************************************************************
//* function name       : T_Entry.GetSubEntry(IpIdx: integer): String;
//* description         : エントリーの名前取得
//*   <function>
//*       インデックスで指定したエントリの名前を取得する
//*   <include file>
//*   <calling sequence>
//*     GetSubEntry(IpIdx: integer): String;
//*       IpIdx: integer  (IN)  サブエントリーのインデックス番号
//*       Result:String   (OUT) サブエントリーの名前(絶対パスを含む)
//*   <remarks>
//      必ず Search を呼び出してから使用すること
//******************************************************************************
function T_Entry.GetSubEntry(IpIdx: integer): String;
begin
  result:= '';
  if (IpIdx >= Self.Count) or (IpIdx < 0) then exit;
  result:= (MvEntries[IpIdx] as T_Entry).Name;
end;


//------------------------------------------------------------------------------
// T_Fileクラス 各メソッド実装
//------------------------------------------------------------------------------

//******************************************************************************
//* function name       : T_File.Create(const IpName: String);
//* description         : コンストラクター
//*   <function>
//*       コンストラクター
//*   <include file>
//*   <calling sequence>
//*     Create(const IpName: String);
//*       IpName: String     (IN)  エントリーの名前(絶対パスを含む)
//*   <remarks>
//******************************************************************************
constructor T_File.Create(const IpName: String);
begin
  inherited Create(IpName);
end;

//******************************************************************************
//* function name       : T_File..Destroy;
//* description         : デストラクター
//*   <function>
//*     デストラクター
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
//* description         : ファイル削除
//*   <function>
//*     自分自身(ファイル)を削除する
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
//* description         : サブエントリー取得
//*   <function>
//*     サブエントリーを取得取得する
//*   <include file>
//*   <calling sequence>
//*     Search(IpType: T_EntryKind = entryAll);
//*       IpType: T_EntryKind   (IN) 検索するエントリーの種類(デフォルトは全て)
//*   <remarks>
//*     ファイルはサブエントリーを持たないので Entries は Nil である
//******************************************************************************
procedure T_File.Search(IpType: T_EntryKind = entryAll);
begin
  Entries:= nil;
end;


//------------------------------------------------------------------------------
// T_Directoryクラス 各メソッド実装
//------------------------------------------------------------------------------

//******************************************************************************
//* function name       : T_Directory.Create(const IpName: String);
//* description         : コンストラクター
//*   <function>
//*       コンストラクター
//*   <include file>
//*   <calling sequence>
//*     Create(const IpName: String);
//*       IpName: String     (IN)  エントリーの名前(絶対パスを含む)
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
//* description         : デストラクター
//*   <function>
//*       デストラクター
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
//* description         : ディレクトリ削除
//*   <function>
//*       自分自身(ディレクトリ)を削除する。サブエントリーも全て削除する
//*   <include file>
//*   <calling sequence>
//*     Delete;
//*   <remarks>
//******************************************************************************
procedure T_Directory.Delete;
var
  LvCnt: integer;
begin
  //ディレクトリ直下のファイルとディレクトリを取得
  Search();

  //サブディレクトリとファイルを全て削除した後、ディレクトリを削除
  with Entries do begin
    for LvCnt:= 0 to Count -1 do begin
      (Items[LvCnt] as T_Entry).Delete;
    end;
    RemoveDir(Self.Name);
  end;
end;


//******************************************************************************
//* function name       : T_Directory.Search(IpType: T_EntryKind = entryAll);
//* description         : サブエントリー取得
//*   <function>
//*       直下のサブエントリーを取得する
//*   <include file>
//*   <calling sequence>
//*     Search(IpType: T_EntryKind = entryAll);
//*       IpType: T_EntryKind (IN)  取得するエントリーの種類(デフォルトは全て)
//*   <remarks>
//******************************************************************************
procedure T_Directory.Search(IpType: T_EntryKind = entryAll);
var
  Rec: TSearchRec;  //検索レコード
  LvPath: String;   //検索パス
  iRslt: integer;
begin
  //List初期化
  Entries.Clear;
  //検索パス取得
  LvPath:= IncludeTrailingPathDelimiter(Self.Name);
  //エントリー検索
  if MvMask = '' then iRslt:= FindFirst(LvPath + '*.*',  faAnyFile, Rec)
  else                iRslt:= FindFirst(LvPath + MvMask, faAnyFile, Rec);

  try

    while (iRslt = 0) do begin
      //'.', '..'は除く
      if (Rec.Name <> '.') and (Rec.Name <> '..') then begin
        //属性変更
        FileSetAttr( LvPath + Rec.Name
                    , Rec.Attr and (not faReadOnly) and (not faHidden) );

        //Listに追加
        if ((Rec.Attr and faDirectory) <> 0)
          and ((IpType = entryAll) or (IpType = entryDir)) then
          //ディレクトリ
          Entries.Add(T_Directory.Create(LvPath + Rec.Name) )
        else if ((IpType = entryAll) or (IpType = entryFile)) then
          //ファイル
          Entries.Add(T_File.Create(LvPath + Rec.Name) );
      end;
      //次を検索
      iRslt:= FindNext(Rec);
    end;

  finally
    FindClose(Rec);
  end;

end;

end.


