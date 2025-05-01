// -----------------------------------------------------------------------------
//  【ファイル操作クラス】
//       Date: 2006/02   Mod: New   Name: S.Matsumoto
// -----------------------------------------------------------------------------
//------------------------------------------------------------------------------
// ユニット定義
//------------------------------------------------------------------------------
unit Unit_TreatFile;

//------------------------------------------------------------------------------
interface
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// インクルード
//------------------------------------------------------------------------------
uses
  SysUtils, classes, DateUtils,
  Unit_Log,
  Unit_DirectoryComposite,
  Unit_FileOperation;

//------------------------------------------------------------------------------
// 各公開型定義
//------------------------------------------------------------------------------
type T_TreatFile = class
  private
    MvLog:      T_Log;
    MvOperation: T_FileOperation;     //ファイル操作用オブジェクト
    function ChkDirectory(const IpDir: String): boolean;
  public
    constructor Create(IpLog: T_Log);
    destructor Destroy(); override;
    //各ファイル・ディレクトリ操作
    function Move(const IpFile, IpDst: String): boolean;
    function Copy(const IpFile, IpDst: String): boolean;
    function ReName(const IpFile, IpDst: String): boolean;
    function Delete(const IpSrc: String): boolean;
  end;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// T_TreatFile 各メソッド実装
//------------------------------------------------------------------------------

//******************************************************************************
//* function name       : T_TreatFile.Create(IpLog: T_Log);
//* description         : コンストラクター
//*   <function>
//*       コンストラクター
//*   <include file>
//*   <calling sequence>
//*     Create((IpLog: T_Log);
//*       IpLog:      T_Log    (IN)  Log出力クラスのインスタンス
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
//* description         : デストラクター
//*   <function>
//*       デストラクター
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
//* description         : ディレクト存在確認
//*   <function>
//*     ディレクト存在確認(なければ作る)
//*   <include file>
//*   <calling sequence>
//*     ChkDirectory(const IpDir: String): boolean;
//*   <remarks>
//******************************************************************************
function T_TreatFile.ChkDirectory(const IpDir: String): boolean;
begin
  result:= true;
  try
    //ディレクトリチェック(なければ作る)
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
//* description         : ファイルコピー
//*   <function>
//*     ファイルをコピーする
//*   <include file>
//*   <calling sequence>
//*     Copy(const IpFile, IpDst: String): boolean;
//*         IpFile: String    (IN)    コピー元ファイル
//*         IpDst:  String    (IN)    コピー先のディレクトリ
//*         result: boolean   (RET)   処理結果(T:成功 F:失敗)
//*   <remarks>
//******************************************************************************
function T_TreatFile.Copy(const IpFile, IpDst: String): boolean;
begin
  //ディレクトリチェック(なければ作る)
  result:= ChkDirectory( ExtractFileDir(IpDst) );
  if (result = false) then begin
    MvLog.LOGOUT( Format( 'ディレクトリ %s の作成に失敗しました。', [IpDst]) );
    exit;
  end;

  //ファイル存在チェック
  result:= FileExists(IpFile);
  if (result = false) then begin
    MvLog.LOGOUT( Format( 'ファイル %s が見つかりません。', [IpFile]) );
    exit;
  end;

  result:= MvOperation.Execute(IpFile, IpDst, shkCopy);
  if (result = false) then begin
    MvLog.LOGOUT( Format( 'ファイルのコピーに失敗しました: %s → %s', [IpFile, IpDst]) );
    MvLog.LOGOUT( Format( 'エラー: %s', [MvOperation.Err]) );
  end;
end;

//******************************************************************************
//* function name       : Move(const IpFile, IpDst: String): boolean;
//* description         : ファイル移動
//*   <function>
//*     ファイルを移動させる
//*   <include file>
//*   <calling sequence>
//*     Move(const IpFile, IpDst: String): boolean;
//*         IpFile: String    (IN)    移動元ファイル
//*         IpDst:  String    (IN)    移動先のディレクトリ
//*         result: boolean   (RET)   処理結果(T:成功 F:失敗)
//*   <remarks>
//*     (※)IpDst には必ずディレクトリを指定すること
//******************************************************************************
function T_TreatFile.Move(const IpFile, IpDst: String): boolean;
begin
  //ディレクトリチェック(なければ作る)
  result:= ChkDirectory( IpDst );
  if (result = false) then begin
    MvLog.LOGOUT( Format( 'ディレクトリ %s の作成に失敗しました。', [IpDst]) );
    exit;
  end;

  //ファイル存在チェック
  result:= FileExists(IpFile);
  if (result = false) then begin
    MvLog.LOGOUT( Format( 'ファイル %s が見つかりません。', [IpFile]) );
    exit;
  end;

  result:= MvOperation.Execute(IpFile, IpDst, shkMove);
  if (result = false) then begin
    MvLog.LOGOUT( Format( 'ファイルの移動に失敗しました: %s → %s', [IpFile, IpDst]) );
    MvLog.LOGOUT( Format( 'エラー: %s', [MvOperation.Err]) );
  end;
end;

//******************************************************************************
//* function name       : Rename(const IpFile, IpDst: String): boolean;
//* description         : ファイル名称変更
//*   <function>
//*     ファイルの名称を変更する(変更元は保存されない)
//*   <include file>
//*   <calling sequence>
//*     Rename(const IpFile, IpDst: String): boolean;
//*         IpFile: String    (IN)    変更前のファイル
//*         IpDst:  String    (IN)    変更後のファイル
//*         result: boolean   (RET)   処理結果(T:成功 F:失敗)
//*   <remarks>
//******************************************************************************
function T_TreatFile.Rename(const IpFile, IpDst: String): boolean;
begin
  //ディレクトリチェック(なければ作る)
  result:= ChkDirectory( ExtractFileDir(IpDst) );
  if (result = false) then begin
    MvLog.LOGOUT( Format( 'ディレクトリ %s の作成に失敗しました。', [IpDst]) );
    exit;
  end;

  //ファイル存在チェック
  result:= FileExists(IpFile);
  if (result = false) then begin
    MvLog.LOGOUT( Format( 'ファイル %s が見つかりません。', [IpFile]) );
    exit;
  end;

  result:= RenameFile(IpFile, IpDst);
  if (result = false) then begin
    MvLog.LOGOUT( Format( 'ファイルのReNameに失敗しました: %s → %s', [IpFile, IpDst]) );
  end;
end;

//******************************************************************************
//* function name       : Delete(const IpSrc: String): boolean;
//* description         : ファイル・ディレクトリ削除
//*   <function>
//*     ファイル・ディレクトリを削除する
//*   <include file>
//*   <calling sequence>
//*     Delete(const IpSrc: String): boolean;
//*         IpSrc: String     (IN)    削除するファイル・ディレクトリ
//*         result: boolean   (RET)   処理結果(T:成功 F:失敗)
//*   <remarks>
//*     (※)IpSrcにディレトリを指定する時は 最後に '\' をつけないこと
//******************************************************************************
function T_TreatFile.Delete(const IpSrc: String): boolean;
begin
  //ファイル・ディレクトリ存在チェック
  result:= ( FileExists(IpSrc) or DirectoryExists(IpSrc) );
  if (result = false) then begin
    MvLog.LOGOUT( Format( 'ファイル・ディレクトリ %s が見つかりません。', [IpSrc]) );
    exit;
  end;

  result:= MvOperation.Execute( IpSrc, '', shkDelete);
  if (result = false) then begin
    MvLog.LOGOUT( Format( 'ファイル・ディレクトリの削除に失敗しました: %s ', [IpSrc]) );
    MvLog.LOGOUT( Format( 'エラー: %s', [MvOperation.Err]) );
  end;
end;


end.
