//******************************************************************************
//* unit name   : Unit_Log
//* author      : 
//* description : ログ生成処理
//******************************************************************************

//------------------------------------------------------------------------------
// ユニット定義
//------------------------------------------------------------------------------
unit Unit_Log;

//------------------------------------------------------------------------------
interface
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// インクルード
//------------------------------------------------------------------------------
uses
  SysUtils, DateUtils, StdCtrls, Classes, SyncObjs
  ,Windows
  ,Unit_DirectoryComposite;

//------------------------------------------------------------------------------
// 各公開型定義
//------------------------------------------------------------------------------
type
  {ログ生成基底クラス}
  T_Log = class
  protected
    FMemo: TMemo;   // ログ表示コントロール
  public
    procedure LOGOUT(const IpOutText: String); overload; virtual; abstract;
    procedure LOGOUT(const IpErr: Exception); overload; virtual; abstract;
    property Memo: TMemo read FMemo write FMemo;
  end;

  {ログファイル生成クラス}
  T_FileLog = class(T_Log)
  private
    FLogging:           Boolean;          // ログ出力フラグ
    LogFilePath:        String;           // ログパス
    LogPreFix:          String;           // ログプレフィックス
    LogWcd:             String;           // ワイルドカード
    LogKeepDays:        Integer;          // 保存日数
    MvSection:          TCriticalSection; // クリティカルセクション
    FFileSize:          integer;

    {ログテキスト出力}
    function Add(LogText: String): Boolean;
    procedure CheckFileSize(const IpFile: String);
  public
    {コンストラクタ}
    constructor Create(const IpFilePath, IpPreFix: String;
                       IpLogging: boolean; IpKeepDays, IpFileSize: integer; IpMemo: TMemo);
    {デストラクタ}
    destructor Destroy; override;

    {日替わり処理}
    procedure DayChange();

    // ログ出力処理
    procedure LOGOUT(const IpOutText: String); overload; override;
    procedure LOGOUT(const IpErr: Exception); overload; override;
  end;

//------------------------------------------------------------------------------
//  各公開定数
//------------------------------------------------------------------------------
const
  LOG_WCD = '*.log';                //ログワイルドカード

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
//* description         : コンストラクタ
//*   <function>
//*     クラスを初期化する。
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

  // ディレクトリがなければ作る
  boRslt:= DirectoryExists(IpFilePath);
  if (boRslt = false) then begin
    ForceDirectories(IpFilePath);
  end;

  MvSection:= TCriticalSection.Create();

  // 初期化
  FLogging    := IpLogging;
  LogFilePath := IpFilePath;
  LogPreFix   := IpPreFix;
  LogKeepDays := IpKeepDays;
  LogWcd      := LOG_WCD;
  FMemo       := IpMemo;
  FFileSize   := IpFileSize;

  //古いファイルを消去
  DayChange;
end;

//******************************************************************************
//* function name       : T_FileLog.Destroy
//* description         : デストラクタ
//*   <function>
//*     クラスを破棄する。
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
//* description         : ログテキスト出力
//*   <function>
//*     テキストをログファイルに出力
//*   <include file>
//*   <calling sequence>
//*     T_FileLog.DayChange;
//*   <remarks>
//******************************************************************************
function T_FileLog.Add(LogText: String): Boolean;
var
  RetCode:    Boolean;
  W_F:        TextFile;  //ログファイル
  FileName:   String;    //ファイル名
  messtr:     String;    //ログメッセージ
  logDate:    String;
begin
  Result := False;

  //2018/08/30 ログファイル変更
  //日付フォルダ作成
  logDate:= FormatDateTime( 'yyyymmdd', Date );
  FileName:= LogFilePath + IncludeTrailingBackslash(logDate);

  try
    // ディレクトリがなければ作る
    if (DirectoryExists(FileName) = false) then begin
      ForceDirectories(FileName);
    end;
    FileName:= FileName + LogPreFix + logDate + '.log';

    //2018/08/30 ログファイル変更
    CheckFileSize(FileName);

    //メッセージ生成
    messtr := FormatDateTime( 'yyyy/mm/dd hh:nn:ss ',Now );
    messtr := messtr + LogText;

    //メッセージ出力
    AssignFile( W_F, FileName );

    RetCode := FileExists( FileName );
    if RetCode = True then begin
      Append( W_F );
    end
    else begin
      Rewrite( W_F );
      //古いファイルを消去
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
//* description         : ファイルサイズ確認
//*   <function>
//*     ファイルサイズ超過→バックアップファイルを作成
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
    //サイズ取得
    handle:=  FileOpen(IpFile, fmOpenRead);
    fileSize:= GetFileSize(handle, nil);
  finally
    FileClose(handle);  
  end;

  if (fileSize > FFileSize) then begin
    //ファイル名変更
    DateTimeToString(fileStamp, 'hhnnss',Now); 
    bkFile:= ChangeFileExt(IpFile, '.' + fileStamp);
    RenameFile(IpFile, bkFile);
  end;
end;

//******************************************************************************
//* function name       : T_FileLog.DayChange
//* description         : ログファイル日替わり処理
//*   <function>
//*     保存日数以外のログを削除する。
//*   <include file>
//*   <calling sequence>
//*     T_FileLog.DayChange;
//*   <remarks>
//******************************************************************************
procedure T_FileLog.DayChange;
var
  LvDirNM:      String;         //ディレクトリ名 yyyymmdd
  LvDateStr:    String;         //ディレクトリ名 yyyy/mm/dd
  LvDirDate:    TDateTime;      //ディレクトリの日付
  LvDiff:       integer;        //日付の差
  LvCnt:        integer;
  LvSrcDir:     T_Entry;        //検索ディレクトリ
  LvTreat:      T_TreatFile;
begin
  //初期化
  LvSrcDir:= T_Directory.Create(LogFilePath);
  LvTreat:=  T_TreatFile.Create(Self);

  try
    //サブディレクトリ検索
    LvSrcDir.Search(entryDir);

    //保存日数を過ぎているディレクトリを削除
    for LvCnt:= 0 to LvSrcDir.Count -1 do begin
      //ディレクトリ名取得
      LvDirNM:= ExtractFileName( LvSrcDir.SubEntries[LvCnt] );
      //ディレクトリー名から日付を取得
      LvDateStr:= Copy(LvDirNM, 1, 4) + '/'
                + Copy(LvDirNM, 5, 2) + '/'
                + Copy(LvDirNM, 7, 2);
      LvDirDate:= StrToDateTimeDef( LvDateStr, -1 );
      //ディレクトリー名が YYYYMMDD形式 のみ処理対象
      if LvDirDate < 0 then begin
        continue;
      end;

      //日付の差を求める
      LvDiff:= DaysBetween(Now(), LvDirDate);
      //保存日数を過ぎていれば削除
      if (LvDiff > LogKeepDays) then begin
        LvDirNM:= LogFilePath + LvDirNM;
        if (LvTreat.Delete( LvDirNM ) = true) then begin
          LOGOUT( Format('保存日数を超過したディレクトリ: %s を削除しました。', [LvDirNM]) );
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
//* description         : 処理ログ出力処理
//*   <function>
//*     処理ログ文字列のログ出力を行う。
//*   <include file>
//*   <calling sequence>
//*     TA001.proc_LOGOUT
//*   <remarks>
//******************************************************************************
procedure T_FileLog.LOGOUT(const IpOutText: String);
begin
  // ログ出力判断
  if (FLogging = False) then exit;

  MvSection.Enter();
  try
    // ログ追加
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

