// -----------------------------------------------------------------------------
//  【ファイル・ディレクトリ操作】
//      G.O 様より拝借
// -----------------------------------------------------------------------------
//------------------------------------------------------------------------------
// ユニット定義
//------------------------------------------------------------------------------
unit Unit_FileOperation;

//------------------------------------------------------------------------------
interface
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// インクルード
//------------------------------------------------------------------------------
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Contnrs,
  Forms, ShellApi;

//------------------------------------------------------------------------------
// 各公開型定義
//------------------------------------------------------------------------------
type

  //----------------------------------------------------------------------------
  // SHFileOperationラップクラス
  T_SHFileOprOption = (
    shoMULTIDESTFILES,
    shoCONFIRMMOUSE,
    shoSILENT,
    shoRENAMEONCOLLISION,
    shoNOCONFIRMATION,
    shoALLOWUNDO,
    shoFILESONLY,
    shoSIMPLEPROGRESS,
    shoNOCONFIRMMKDIR,
    shoNOERRORUI
  );
  T_SHFileOprOptions = set of T_SHFileOprOption;

  T_SHFileOprExecKind = (
    shkCopy,
    shkDelete,
    shkMove,
    shkRename
  );

  T_FileOperation = class
  private
    MvOptions: T_SHFileOprOptions;
    MvErr: String;
    class function OptionsToSHFlg(IpOptions: T_SHFileOprOptions): LongWord;
    class function KindToSHKind(IpKind: T_SHFileOprExecKind): LongWord;
  public
    constructor Create();
    destructor Destroy(); override;
    function Execute(const IpFromPath: String; const IpToPath: String; IpOpr: T_SHFileOprExecKind): Boolean;
    property Err: String read MvErr;
  end;

//------------------------------------------------------------------------------
// 各公開関数宣言部
//------------------------------------------------------------------------------

// テスト関数宣言
procedure Test();

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// 各定数
//------------------------------------------------------------------------------
const

  // T_SHFileOprOption変換定義
  SHFileOprOptionCovArray: array[T_SHFileOprOption]of LongWord = (
    FOF_MULTIDESTFILES,
    FOF_CONFIRMMOUSE,
    FOF_SILENT,
    FOF_RENAMEONCOLLISION,
    FOF_NOCONFIRMATION,
    FOF_ALLOWUNDO,
    FOF_FILESONLY,
    FOF_SIMPLEPROGRESS,
    FOF_NOCONFIRMMKDIR,
    FOF_NOERRORUI
  );

  // T_SHFileOprExecKind変換定義
  SHFileOprExecKindCovArray: array[T_SHFileOprExecKind]of LongWord = (
    FO_COPY,
    FO_DELETE,
    FO_MOVE,
    FO_RENAME
  );

//------------------------------------------------------------------------------
// 各関数実装
//------------------------------------------------------------------------------

//----------------------------------------------------------------------------
// テスト関数
procedure Test();
var
  LvOpr: T_FileOperation;
begin

  LvOpr := T_FileOperation.Create();
  try
    with LvOpr do begin
      Execute('C:\Temp\1.txt', 'C:\Temp\1', shkCopy);
    end;
  finally
    FreeAndNil(LvOpr);
  end;
end;


//------------------------------------------------------------------------------
// T_FileOperationクラス 各メソッド実装
//------------------------------------------------------------------------------

//----------------------------------------------------------------------------
// -構築・廃棄- コンストラクタ
constructor T_FileOperation.Create();
begin
  MvErr := '';
  MvOptions := [shoNOCONFIRMMKDIR, shoNOCONFIRMATION, shoSILENT, shoNOERRORUI];
end;

//----------------------------------------------------------------------------
// -構築・廃棄- デストラクタ
destructor T_FileOperation.Destroy();
begin
  inherited Destroy;
end;

//----------------------------------------------------------------------------
// -スタティックメソッド- SHオプション作成
class function T_FileOperation.OptionsToSHFlg(IpOptions: T_SHFileOprOptions): LongWord;
var
  LvCtr: T_SHFileOprOption;
begin
  Result := 0;
  try
    for LvCtr := Low(T_SHFileOprOption) to High(T_SHFileOprOption) do begin
      if ( T_SHFileOprOption(LvCtr) in IpOptions  ) then begin
        Result := (Result or SHFileOprOptionCovArray[LvCtr]);
      end;
    end;
  except
    Result := 0;
  end;
end;

//----------------------------------------------------------------------------
// -スタティックメソッド- SH処理種類作成
class function T_FileOperation.KindToSHKind(IpKind: T_SHFileOprExecKind): LongWord;
begin
  try
    Result := SHFileOprExecKindCovArray[IpKind];
  except
    Result := 0;
  end;
end;



//----------------------------------------------------------------------------
// 処理実行(１ファイル指定)
function T_FileOperation.Execute(const IpFromPath: String; const IpToPath: String;
                                    IpOpr: T_SHFileOprExecKind): Boolean;
    //エラーメッセージ文字列を取得する
    function GetLastErrorStr(): String;
    const
      MAX_MES = 512;
    var
      Buf: PChar;
    begin
      Buf := AllocMem(MAX_MES);
      try
        FormatMessage(Format_Message_From_System,
                      Nil,
                      GetLastError(),
                      (SubLang_Default shl 10) + Lang_Neutral,
                      Buf,
                      MAX_MES,
                      Nil);
      finally
        Result := Buf;
        FreeMem(Buf);
      end;
    end;
var
  LvFileOpr: TSHFileOpStruct;
  LvErrCode: integer;
begin
  Result := False;
  FillChar(LvFileOpr, SizeOf(LvFileOpr), 0);
  with LvFileOpr do begin
    Wnd := Application.Handle;
    wFunc := KindToSHKind(IpOpr);
    pFrom := PChar(IpFromPath + #0#0);
    pTo :=   PChar(IpToPath   + #0#0);
    fFlags := OptionsToSHFlg(MvOptions);
    fAnyOperationsAborted := False;
    hNameMappings := nil;
    lpszProgressTitle := nil;
  end;
  LvErrCode:= SHFileOperation(LvFileOpr);

  if LvErrCode = 0 then Result := True
  else MvErr:= GetLastErrorStr();

end;

//-----------------------------------------------------------------------------
end.
//-----------------------------------------------------------------------------
