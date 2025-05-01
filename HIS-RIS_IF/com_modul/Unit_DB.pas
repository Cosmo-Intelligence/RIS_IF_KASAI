// -----------------------------------------------------------------------------
//  【DB管理クラス】
// -----------------------------------------------------------------------------

//------------------------------------------------------------------------------
// ユニット定義
//------------------------------------------------------------------------------
unit Unit_DB;

//------------------------------------------------------------------------------
interface
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// インクルード
//------------------------------------------------------------------------------
uses
  DBXpress, DBTables, DB, SqlExpr, SysUtils, classes,
  Unit_Log, Unit_Convert;

//------------------------------------------------------------------------------
// 各公開型定義
//------------------------------------------------------------------------------
type

  {DB構造体}
  T_DbConnect = record
    SrvName : String;     //サーバ名（エイリアス名）
    DataBaseName : String;//データベース名（SQLサーバー用）
    UserName: String;     //ユーザ名
    Password: String;     //パスワード
  end;

  {DB接続基本クラス}
  T_DB = class(TSQLConnection)
  private
    { Private 宣言 }
    //トランザクション情報
    FTD:    TTransactionDesc;
  protected
    //DB接続先構造体
    DBC:    T_DbConnect;
    //ログ
    FLog:   T_Log;    //通常ログ用オブジェクト
    FDbg:   T_Log;    //デバックログ用オブジェクト
  public
    { Public 宣言 }
    //コンストラクタ(Create)
    constructor Create(const ConnectInfo: T_DbConnect;
                       const Log, Dbg: T_Log); reintroduce; overload; virtual;
    //DataBase接続　
    function DBConnect(): Boolean; virtual; abstract;
    //DataBase切断
    function DBDisConnect(): Boolean;
    //トランザクション開始
    procedure StartTransaction; overload;
    //コミット
    procedure Commit; overload;
    //ロールバック
    procedure Rollback; overload;
  end;

  {DB接続クラス(SQLServer用)}
  T_SQLDB = class(T_DB)
  public
    constructor Create(const ConnectInfo: T_DbConnect;
                       const Log, Dbg: T_Log); overload; override;
    constructor Create(const Srv, DB, User, Pass: String;
                       const Log, Dbg: T_Log); overload;
    function DBConnect(): boolean; override;
  end;

  {DB接続クラス(Oracle用)}
  T_ORADB = class(T_DB)
  public
    constructor Create(const ConnectInfo: T_DbConnect;
                       const Log, Dbg: T_Log); overload; override;
    constructor Create(const DB, User, Pass: String;
                       const Log, Dbg: T_Log); overload;
    function DBConnect(): boolean; override;
  end;

  {SQL実行クラス}
  T_Query = class
  private
    { Private 宣言 }
    MvQuery: TSQLQuery;
    MvCode:  integer;
    MvMsg:   String;
    MvCount: integer;
  protected
    //ログ
    FLog:   T_Log;    //通常ログ用オブジェクト
    FDbg:   T_Log;    //デバックログ用オブジェクト
  public
    { Public 宣言 }
    //コンストラクタ(Create)
    constructor Create(const DB: T_DB;
                       const Log, Dbg: T_Log); overload;
    //デストラクター
    destructor Destroy(); override;                       
    //レコード移動
    procedure Next();
    function Eof(): boolean;
    //パラメータ付SQL 実行準備
    procedure   PrepareQuery(szSQL: String);
    //DB取得(Open)
    function    OpenQuery(): Integer; overload;
    function    OpenQuery(szSQL: String): Integer; overload;
    function    OpenQuery(szSQL: String;
                            var iCode: Integer;
                            var szMsg: String): Integer; overload;
    //DB新規/更新(ExecSQL)
    function    ExecSQL(): Integer; overload;
    function    ExecSQL(szSQL: String): Integer; overload;
    function    ExecSQL(szSQL: String;
                          var iCode: Integer;
                          var szMsg: String ): Integer; overload;
    //エラー情報取得(Code指定あり)
    procedure   GetErrInfo(const Err: EDBEngineError;
                             var iCode: Integer;
                             var szErr: String); overload;

    procedure   GetErrInfo(const Err: EDatabaseError;
                                var iCode: Integer;
                                var szErr: String); overload;
    //パラメータ設定
    procedure SetParam(const IpName: String; IpVal: String); overload;
    procedure SetParam(const IpName: String; IpVal: integer); overload;
    procedure SetParam(const IpName: String; IpVal: TDateTime; const IpFrm: String); overload;

    //区切り文字列作成
    function    GetStrJoint(szJoint: String): String;
    //フィールド数値取得
    function    GetInteger(szFldName: String): Integer;
    //フィールド文字列取得
    function    GetString(szFldName: String): String; overload;
    //フィールド文字列取得
    function    GetString(szFldName: String;
                            iLen: Integer): String; overload;
    //フィールド文字列取得
    function    GetString(iFldNo: Integer): String; overload;

    //フィールド日付型取得
    function    GetDate(szFldName: String): TDateTime;

    //COUNT(*)取得
    function    GetCount(szTable, szWhere: String): Integer;
    //システム時間取得
    function    GetSysDate(): TDateTime;
    function    GetSysDateYMDHNS(): String;
    //付番
    function    GetSequence(szSeq: String): Integer;
    //
    function    Lock(szTable: String; szWhere: String = ''): Boolean;
    //DB再接続の必要性の検証
    function    NeedRetry(): boolean;

    //
    property Code:  integer read MvCode;
    property Msg:   String  read MvMsg;
    property Count: integer read MvCount;
  end;

//------------------------------------------------------------------------------
implementation
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// 各定数
//------------------------------------------------------------------------------
const
  DATABASE    = 'Database';     //データベース名
  USER_NAME   = 'User_Name';    //ユーザ名
  PASSWORD    = 'Password';     //パスワード

  { エラー定義 }
  DB_ERR_ORA_12545 = '12545';     // ターゲットホストなし
  DB_ERR_ORA_12571 = '12571';     // TNS: パケット・ライター障害
  DB_ERR_ORA_01034 = '1034';      // Oracle未起動
  DB_ERR_ORA_03113 = '3113';      // Oracle未接続
  DB_ERR_ORA_03114 = '3114';      // Oracle未接続
  DB_ERR_ORA_12560 = '12560';     // プロトコルアダプタエラー
  DB_ERR_ORA_12535 = '12535';     // TNS Time Out

//******************************************************************************
//* T_DBクラス
//******************************************************************************
//******************************************************************************
//* description   : コンストラクタ(Create)
//******************************************************************************
constructor T_DB.Create(const ConnectInfo: T_DbConnect;
                        const Log, Dbg: T_Log);
begin
  inherited Create( nil );
  //接続情報
  DBC:= ConnectInfo;
  //Log
  FLog:= Log;
  FDbg:= Dbg;
end;

//******************************************************************************
//* description   : Oracle DB切断
//*   Result:   Boolean     (RET) True    : 成功
//*                               False   : 失敗
//*
//******************************************************************************
function T_DB.DBDisConnect(): Boolean;
begin
  try
    // 各情報設定
    Connected := False;
    // DB切断
    Close;
    Result := True;
  except
    Result := False;
  end;
end;

//******************************************************************************
//* description   : トランザクション開始
//******************************************************************************
procedure T_DB.StartTransaction;
begin
  if not InTransaction then
  begin
    FTD.TransactionID := 1;
    FTD.IsolationLevel := xilREADCOMMITTED;
    StartTransaction(FTD);
    FDbg.LOGOUT('トランザクション 開始 →');
  end;
end;

//******************************************************************************
//* description   : コミット
//******************************************************************************
procedure T_DB.Commit;
begin
  if InTransaction then
  begin
    Commit(FTD);
    FDbg.LOGOUT('コミット ←');
  end;
end;

//******************************************************************************
//* description   : ロールバック
//******************************************************************************
procedure T_DB.Rollback;
begin
  if InTransaction then
  begin
    Rollback(FTD);
    FDbg.LOGOUT('ロールバック ←');
  end;
end;


//******************************************************************************
//* T_ORADBクラス
//******************************************************************************
//******************************************************************************
//* description   : コンストラクタ(Create)
//* Result:
//*
//* ConnectInfo: T_DbConnect      (IN)  接続情報構造体
//******************************************************************************
constructor T_ORADB.Create(const ConnectInfo: T_DbConnect;
                           const Log, Dbg: T_Log);
begin
  inherited Create(ConnectInfo, Log, Dbg);
end;

//******************************************************************************
//* description   : コンストラクタ(Create)
//* Result:
//*
//* ConnectInfo: 
//******************************************************************************
constructor T_ORADB.Create(const DB, User, Pass: String;
                           const Log, Dbg: T_Log);
var
  ConnectInfo: T_DbConnect;
begin
  ConnectInfo.SrvName:=   DB;
  ConnectInfo.DataBaseName:= '';    //使用せず
  ConnectInfo.UserName:=  User;
  ConnectInfo.Password:=  Pass;

  inherited Create(ConnectInfo, Log, Dbg);
end;

//******************************************************************************
//* description   : Oracle DB接続
//*   Result:   Boolean     (RET) True    : 成功
//*                               False   : Connect失敗
//*
//******************************************************************************
function T_ORADB.DBConnect: boolean;
begin

  if Connected then
  begin
    try
      ExecuteDirect( 'SELECT SYSDATE FROM DUAL' );
    except
      Connected := False;
      Result := False;
      Exit;
    end;
  end;
  try
    // サーバ名（エイリアス名）がなければ接続しない。
    if Length(DBC.SrvName) = 0 then begin
      Result := false;
      Exit;
    end;
    // パラメータ情報設定
    Params.Values['BlobSize'] := '-1';
    Params.Values['DriverName'] := 'Oracle';
    Params.Values['Oracle TransIsolation'] := 'ReadCommited';
    Params.Values[DATABASE]   := DBC.SrvName;
    Params.Values[USER_NAME]  := DBC.UserName;
    Params.Values[PASSWORD]   := DBC.PassWord;
    // 各情報設定
    ConnectionName := 'Oracle';
    DriverName := 'Oracle';
    GetDriverFunc := 'getSQLDriverORACLE';
    LibraryName := 'dbexpora.dll';
    LoginPrompt    := False;
    VendorLib := 'oci.dll';
    KeepConnection := True;
    // 接続
    Connected      := True;
    Result := True;
  except
    on Err : Exception do begin
      Result := False;
      FDbg.LOGOUT(Err.Message);
      FLog.LOGOUT(Err.Message);
      Exit;
    end;
  end;

end;

//******************************************************************************
//* T_SQLDBクラス
//******************************************************************************
//******************************************************************************
//* description   : コンストラクタ(Create)
//* Result:
//*
//* ConnectInfo: T_DbConnect      (IN)  接続情報構造体
//******************************************************************************
constructor T_SQLDB.Create(const ConnectInfo: T_DbConnect;
                           const Log, Dbg: T_Log);
begin
  inherited Create(ConnectInfo, Log, Dbg);
end;

//******************************************************************************
//* description   : コンストラクタ(Create)
//* Result:
//*
//* Srv:    String   (IN) 接続先サーバー
//* DB:     String   (IN) 接続先DB名
//* User:   String   (IN) ユーザー名
//* Pass:   String   (IN) パスワード　
//******************************************************************************
constructor T_SQLDB.Create(const Srv, DB, User, Pass: String;
                           const Log, Dbg: T_Log);
var
  ConnectInfo: T_DbConnect;
begin
  ConnectInfo.SrvName   :=    Srv;
  ConnectInfo.DataBaseName:=  DB;
  ConnectInfo.UserName  :=    User;
  ConnectInfo.Password  :=    Pass;

  inherited Create(ConnectInfo, Log, Dbg);
end;

//******************************************************************************
//* description   : SQLServer DB接続
//*   Result:   Boolean     (RET) True    : 成功
//*                               False   : Connect失敗
//*
//******************************************************************************
function T_SQLDB.DBConnect: boolean;
begin
  Result := True;
  if Connected then
  begin
    try
      ExecuteDirect( 'SELECT GETDATE()' );
    except
      Connected := False;
      Result := False;
      Exit;
    end;
  end;
  try
    // サーバ名・データベース名がなければ接続しない。
    if ( (Length(DBC.SrvName) = 0) or (Length(DBC.DataBaseName) = 0) ) then begin
      Result := false;
      Exit;
    end;
    // パラメータ情報設定
    Params.Values['DriverName']:= 'MSSQL';
    Params.Values['DataBase']:=  DBC.DataBaseName;
    Params.Values['HostName']:=  DBC.SrvName;
    Params.Values['User_Name']:= DBC.UserName;
    Params.Values['Password']:=  DBC.Password;
    Params.Values['BlobSize']:=  '-1';
//    Params.Values['ErrorResourceFile']:=
    Params.Values['LocaleCode']:= '0000';
    Params.Values['MSSQL TransIsolation']:= 'ReadCommited';
    Params.Values['OS Authentication']:= 'False';
    // 各情報設定
    ConnectionName := 'MSSQLConnection';
    DriverName := 'MSSQL';
    GetDriverFunc := 'getSQLDriverMSSQL';
    LibraryName := 'dbexpmss.dll';
    LoginPrompt    := False;
    VendorLib := 'oledb';
    KeepConnection := True;
    // 接続
    Connected      := True;
  except
    on Err : Exception do begin
      Result := False;
      FDbg.LOGOUT(Err.Message);
      FLog.LOGOUT(Err.Message);
      Exit;
    end;
  end;

end;


//******************************************************************************
//* T_Queryクラス
//******************************************************************************
//******************************************************************************
//* description   : コンストラクタ(Create)
//* Result:
//*
//******************************************************************************
constructor T_Query.Create(const DB: T_DB;
                           const Log, Dbg: T_Log);
begin
  inherited Create();
  //Query作成
  MvQuery:= TSQLQuery.Create(nil);
  MvQuery.MaxBlobSize := -1;
  MvQuery.SQLConnection:= DB;

  //ログ出力オブジェクト設定
  FLog:= Log;
  FDbg:= Dbg;
end;

//******************************************************************************
//* description   : デストラクター
//* Result:
//*
//******************************************************************************
destructor T_Query.Destroy;
begin
  MvQuery.Free();
  inherited Destroy;
end;

//******************************************************************************
//* function name : Next;
//*
//* description   : レコード移動
//*
//*  < function >
//*
//*  < calling sequence>
//*     Next;
//*
//*  < Remarks >
//*
//******************************************************************************
procedure T_Query.Next;
begin
  MvQuery.Next();
end;

//******************************************************************************
//* function name : Eof
//*
//* description   :
//*
//*  < function >
//*
//*  < calling sequence>
//*     Eof: boolean;
//*
//*  < Remarks >
//*
//******************************************************************************
function T_Query.Eof: boolean;
begin
  result:= MvQuery.Eof;
end;

//******************************************************************************
//* function name       : PrepareQuery(szSQL: String): boolean;
//* description         : クエリ実行準備　パラメータを含むSQL用
//*   <function>
//*     SQL(パレメータ含む)の実行準備をする
//*   <include file>
//*   <calling sequence>
//*     PrepareQuery(szSQL: String): boolean;
//*       return: Integer       (RET)   結果セット数（負数ならエラー）
//*       szSQL: String         (IN)    実行するクエリ
//*   <remarks>
//******************************************************************************
procedure T_Query.PrepareQuery(szSQL: String);
var
  sFunc:      String;
  sERRMsg:    String;
  iCode:      integer;
  szMsg:      String;
begin
  sFunc := 'PrepareQuery';
  // ログ出力
  sERRMsg := Format('[%s]: Start', [sFunc]);
  FDbg.LOGOUT(sERRMsg);
  sERRMsg := Format('[%s]: SQL = %s', [sFunc, szSQL]);
  FDbg.LOGOUT(sERRMsg);

  try
    with MvQuery do begin
      SQL.Clear;
      SQL.Add(szSQL);
      Close;          //念のためクローズ
    end;
  except
    on Err : EDBEngineError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ログ出力
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
    end;
    on Err : EDatabaseError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ログ出力
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
    end;
  end;

  // ログ出力
  sERRMsg := Format('[%s]: End', [sFunc]);
  FDbg.LOGOUT(sERRMsg);
end;

//******************************************************************************
//* function name       : OpenQuery
//* description         : クエリ実行(Open)
//*   <function>
//*     SQL文を実行し、結果セットを取得する。
//*   <include file>
//*   <calling sequence>
//*     OpenQuery(szSQL: String): Integer;
//*       return: Integer       (RET)   結果セット数（負数ならエラー）
//*       strSQL: String        (IN)    実行するクエリ
//*   <remarks>
//******************************************************************************
function T_Query.OpenQuery(szSQL: String): Integer;
var
  iCode:    Integer;
  szMsg:    String;
begin
  Result := OpenQuery(szSQL, iCode, szMsg);

  // エラー情報設定
  MvCode := iCode;
  MvMsg  := szMsg;
end;

//******************************************************************************
//* function name       : DBOpenQuery
//* description         : クエリ実行(Open)
//*   <function>
//*     SQL文を実行し、結果セットを取得する。
//*   <include file>
//*   <calling sequence>
//*     OpenQuery(szSQL: String;
//*               var iCode: Integer;
//*               var szMsg: String ): Integer;
//*       return: Integer       (RET)   結果セット数（負数ならエラー）
//*       strSQL: String        (IN)    実行するクエリ
//*       intCode: String       (OUT)   エラーコード
//*       strMsg: String        (OUT)   エラーメッセージ
//*   <remarks>
//******************************************************************************
function T_Query.OpenQuery(szSQL: String;
                            var iCode: Integer;
                            var szMsg: String): Integer;
var
  sFunc:      String;
  sERRMsg:    String;
begin
  Result  := -1;
  iCode   := 0;
  szMsg   := '';
  MvCount := 0;

  sFunc := 'OpenQuery';
  // ログ出力
  sERRMsg := Format('[%s]: Start', [sFunc]);
  FDbg.LOGOUT(sERRMsg);
  sERRMsg := Format('[%s]: SQL = %s', [sFunc, szSQL]);
  FDbg.LOGOUT(sERRMsg);

  try
    with MvQuery do begin
      SQL.Clear;
      SQL.Add(szSQL);
      Close;          //念のためクローズ
      Open;
      First;
      while not Eof do begin
        Fields.Fields[0].AsString;
        Next;
        Inc( MvCount );
      end;
      First;
      Result := MvCount;
    end
  except
    on Err : EDBEngineError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ログ出力
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
    end;
    on Err : EDatabaseError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ログ出力
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
    end;
  end;

  // ログ出力
  sERRMsg := Format('[%s]: End', [sFunc]);
  FDbg.LOGOUT(sERRMsg);

end;

//******************************************************************************
//* function name       : OpenQuery
//* description         : クエリ実行　パラメータを含むSQL用
//*   <function>
//*     SQL文を実行し、結果セットを取得する。
//*   <include file>
//*   <calling sequence>
//*     OpenQuery: Integer;
//*       result: integer (RET) 検索件数
//*   <remarks>
//*     先に DBPrepareQuery を呼び、パラメータに値を設定した後で呼び出す必要あり
//******************************************************************************
function T_Query.OpenQuery: Integer;
var
  sFunc:      String;
  sERRMsg:    String;
  iCode:      integer;
  szMsg:      String;
  LvCnt:      integer;
begin
  Result  := -1;
  iCode   := 0;
  szMsg   := '';
  MvCount := 0;

  sFunc := 'OpenQuery';
  // ログ出力
  sERRMsg := Format('[%s]: Start', [sFunc]);
  FDbg.LOGOUT(sERRMsg);
  try
    with MvQuery do begin
      //パラメータ　Log出力
      for LvCnt:= 0 to Params.Count -1 do begin
        FDbg.LOGOUT( Format('パラメータ 名称: %s, 値: %s', [Params[LvCnt].Name, Params[LvCnt].AsString]) );
      end;
      //オープン
      Open;
      First;
      //件数取得
      while not Eof do begin
        Fields.Fields[0].AsString;
        Next;
        Inc( MvCount );
      end;
      First;
      result := MvCount;
    end;
  except
    on Err : EDBEngineError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ログ出力
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
      MvMsg:= szMsg;
    end;
    on Err : EDatabaseError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ログ出力
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
      MvMsg:= szMsg;
    end;
  end;

  // ログ出力
  sERRMsg := Format('[%s]: End', [sFunc]);
  FDbg.LOGOUT(sERRMsg);
end;

//******************************************************************************
//* function name       : OpenQuery
//* description         : クエリ実行(ExecSQL)
//*   <function>
//*     SQL文を実行し、結果セットを取得する。
//*   <include file>
//*   <calling sequence>
//*     ExecSQL(szSQL: String;
//*             var iCode: Integer;
//*             var szMsg: String ): Boolean;
//*       return: Integer       (RET)   True  = 成功
//*                                     False = 失敗
//*       strSQL: String        (IN)    実行するクエリ
//*   <remarks>
//******************************************************************************
function T_Query.ExecSQL(szSQL: String): Integer;
var
  iCode:  Integer;
  szMsg:  String;
begin
  Result := ExecSQL(szSQL, iCode, szMsg);

  // エラー情報設定
  MvCode := iCode;
  MvMsg := szMsg;
end;

//******************************************************************************
//* function name       : ExecSQL
//* description         : クエリ実行(ExecSQL)
//*   <function>
//*     SQL文を実行し、結果セットを取得する。
//*   <include file>
//*   <calling sequence>
//*     ExecSQL(szSQL: String;
//*             var iCode: Integer;
//*             var szMsg: String): Boolean;
//*       return: Integer       (RET)   True  = 成功
//*                                     False = 失敗
//*       strSQL: String        (IN)    実行するクエリ
//*       intCode: String       (OUT)   エラーコード
//*       strMsg: String        (OUT)   エラーメッセージ
//*   <remarks>
//******************************************************************************
function T_Query.ExecSQL(szSQL: String;
                          var iCode: Integer;
                          var szMsg: String): Integer;
var
  sFunc:      String;
  sERRMsg:    String;
begin
  Result  := -1;
  iCode   := 0;
  szMsg   := '';

  sFunc := 'ExecSQL';
  // ログ出力
  sERRMsg := Format('[%s]: Start', [sFunc]);
  FDbg.LOGOUT(sERRMsg);
  sERRMsg := Format('[%s]: SQL = %s', [sFunc, szSQL]);
  FDbg.LOGOUT(sERRMsg);

  try
    with MvQuery do begin
      Close;
      SQL.Clear;
      SQL.Add(szSQL);

      ExecSQL;
      result := RowsAffected;
    end;
  except
    on Err : EDBEngineError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ログ出力
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
    end;
    on Err : EDatabaseError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ログ出力
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
    end;
  end;

  // ログ出力
  sERRMsg := Format('[%s]: End', [sFunc]);
  FDbg.LOGOUT(sERRMsg);
end;

//******************************************************************************
//* function name       : ExecSQL
//* description         : クエリ実行　パラメータを含むSQL用
//*   <function>
//*     SQL文を実行し、結果セットを取得する。
//*   <include file>
//*   <calling sequence>
//*     ExecSQL(): Integer;
//*       return: Integer       (RET)
//*   <remarks>
//*     先に DBPrepareQuery を呼び、パラメータに値を設定した後で呼び出す必要あり
//******************************************************************************
function T_Query.ExecSQL: Integer;
var
  sFunc:      String;
  sERRMsg:    String;
  iCode:      integer;
  szMsg:      String;
  LvCnt:      integer;
begin
  result  := -1;
  MvCode  := 0;
  MvMsg   := '';

  sFunc := 'ExecSQL';
  // ログ出力
  sERRMsg := Format('[%s]: Start', [sFunc]);
  FDbg.LOGOUT(sERRMsg);

  try
    with MvQuery do begin
      //パラメータ　Log出力
      for LvCnt:= 0 to Params.Count -1 do begin
        FDbg.LOGOUT( Format('パラメータ 名称: %s, 値: %s', [Params[LvCnt].Name, Params[LvCnt].AsString]) );
      end;

      ExecSQL;
      result := RowsAffected;
    end;
  except
    on Err : EDBEngineError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ログ出力
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
      MvMsg:= szMsg;
    end;
    on Err : EDatabaseError do begin
      GetErrInfo(Err, iCode, szMsg);
      // ログ出力
      sERRMsg := Format('[%s]: ERROR = %s', [sFunc, szMsg]);
      FDbg.LOGOUT(sERRMsg);
      MvMsg:= szMsg;
    end;
  end;

  // ログ出力
  sERRMsg := Format('[%s]: End', [sFunc]);
  FDbg.LOGOUT(sERRMsg);

end;

//******************************************************************************
//* function name       : SetParam
//* description         : パラメータ設定(文字列)
//*   <function>
//*
//*   <include file>
//*   <calling sequence>
//*     SetParam(const IpName: String; IpVal: String);
//*
//*   <remarks>
//******************************************************************************
procedure T_Query.SetParam(const IpName: String; IpVal: String);
var
  LvPrm:  TParam;
begin
  LvPrm:= MvQuery.ParamByName(IpName);
  LvPrm.AsString:= IpVal;
end;

//******************************************************************************
//* function name       : SetParam
//* description         : パラメータ設定(整数)
//*   <function>
//*
//*   <include file>
//*   <calling sequence>
//*     SetParam(const IpName: String; IpVal: integer);
//*
//*   <remarks>
//******************************************************************************
procedure T_Query.SetParam(const IpName: String; IpVal: integer);
var
  LvPrm:  TParam;
begin
  LvPrm:= MvQuery.ParamByName(IpName);

  if IpVal = INVALID_NUM then begin
    LvPrm.AsString:= '';  
  end
  else begin
    LvPrm.AsString:= IntToStr( IpVal );   //AsInteger ではエラーになるので文字列に変換
  end;
end;

//******************************************************************************
//* function name       : SetParam
//* description         : パラメータ設定(日付)
//*   <function>
//*
//*   <include file>
//*   <calling sequence>
//*     SetParam(const IpName: String; IpVal: TDateTime; const IpFrm: String);
//*
//*   <remarks>
//******************************************************************************
procedure T_Query.SetParam(const IpName: String; IpVal: TDateTime;
  const IpFrm: String);
var
  LvPrm:  TParam;
  LvDate: String;
begin
  LvPrm:= MvQuery.ParamByName(IpName);
  //無効日付
  if IpVal = INVALID_DATE then begin
    LvPrm.AsString:= '';
  end
  else begin
    DateTimeToString(LvDate, IpFrm, IpVal);
    LvPrm.AsString:= LvDate;  
  end;
end;

//******************************************************************************
//* function name : GetErrInfo
//*
//* description   : Oracleﾈｲﾃｨﾌﾞｴﾗｰｺｰﾄﾞ取得
//*
//*  < function >
//*
//*  < calling sequence>
//* procedure GetErr(const Err: EDBEngineError;
//*                    var Code: Integer;
//*                    var ErrMsg:String);
//*
//*   Err     : EDBEngineError  (IN)    例外
//*   Code    : Integer         (OUT)   取得したｴﾗｰｺｰﾄﾞ
//*   ErrMsg  : String          (OUT)   取得したｴﾗｰﾒｯｾｰｼﾞ
//*
//*  < Remarks >
//*
//******************************************************************************
procedure T_Query.GetErrInfo(const Err: EDBEngineError;
                                var iCode: Integer;
                                var szErr: String);
{
  EDBEngineError の場合にＤＢエラー情報を取得する。
　Err:EDBEngineError例外の識別子
　Code:OracleエラーコードまたはBDEエラーコード
  ErrMsg:取得したエラーメッセージ
}
var
  count: Integer;
begin
  for count := 0 to Err.ErrorCount - 1 do
  begin
    if Err.Errors[count].NativeError <> 0 then
    {Oracleネーティブエラーだったら}
    begin
      {Oracleエラー情報の設定}
      iCode := Err.Errors[count].NativeError;
      szErr := StringReplace(Err.Errors[count].Message,#$A,'',[rfReplaceAll]);
      exit;
    end;
  end;

  {BDEエラーしかなければ}
  {一番目のエラー情報を設定}
  iCode := Err.Errors[0].ErrorCode;
  szErr := Err.Errors[0].Message;
end;

//******************************************************************************
//* function name : GetErrInfo
//*
//* description   : DBエラー取得取得(DBExpress対応)
//*
//*  < function >
//*
//*  < calling sequence>
//* procedure GetErr(const Err: EDatabaseError;
//*                    var Code: Integer;
//*                    var ErrMsg:String);
//*
//*   Err     : EDBEngineError  (IN)    例外
//*   Code    : Integer         (OUT)   取得したｴﾗｰｺｰﾄﾞ
//*   ErrMsg  : String          (OUT)   取得したｴﾗｰﾒｯｾｰｼﾞ
//*
//*  < Remarks >
//*
//******************************************************************************
procedure T_Query.GetErrInfo(const Err: EDatabaseError;
                                var iCode: Integer;
                                var szErr: String);
begin
  szErr:= Err.Message;
end;

//******************************************************************************
//* function name : GetStrJoint
//*
//* description   : 取得した項目を指定文字で結合する
//*
//*  < function >
//*
//*  < calling sequence>
//* function   GetStrJoint(szJoint: String): String;
//*
//*   Result:   String  (RET)   結合文字列
//*   szJoint:  String  (IN)    結合文字
//*
//*  < Remarks >
//*
//******************************************************************************
function   T_Query.GetStrJoint(szJoint: String): String;
var
  iCnt:   Integer;    // カウンタ
  szRet:  String;     // 結合文字列
begin
  // 初期化
  szRet := '';

  // フィールドデータ設定
  with MvQuery do begin
    for iCnt := 0 to Fields.Count - 1 do begin
      // 文字列作成
      if iCnt < Fields.Count - 1 then
        szRet := szRet + Fields[iCnt].AsString + szJoint
      else
        szRet := szRet + Fields[iCnt].AsString;
    end;
  end;
  Result := szRet;
end;

//******************************************************************************
//* function name : GetInteger
//*
//* description   : フィールド数値取得
//*
//*  < function >
//*
//*  < calling sequence>
//* function    GetInteger(szFldName: String): Integer;
//*
//*   Result:     Integer (RET)   取得数値
//*   szFldName:  String  (IN)    フィールド名称
//*
//*  < Remarks >
//*
//******************************************************************************
function    T_Query.GetInteger(szFldName: String): Integer;
var
  LvField: TField;
begin
  try
    LvField:= MvQuery.FieldByName(szFldName);
    if LvField.IsNull then result:= INVALID_NUM
    else                   result := LvField.AsInteger;
  except
    result:= INVALID_NUM;
  end;
end;

//******************************************************************************
//* function name : GetString
//*
//* description   : フィールド文字列取得
//*
//*  < function >
//*
//*  < calling sequence>
//* function    GetString(szFldName: String): String;
//*
//*   Result:     String  (RET)   取得文字列
//*   szFldName:  String  (IN)    フィールド名称
//*
//*  < Remarks >
//*
//******************************************************************************
function    T_Query.GetString(szFldName: String): String;
begin
  try
    Result := MvQuery.FieldByName(szFldName).AsString;
  except
    Result := '';
  end;
end;

//******************************************************************************
//* function name : GetString
//*
//* description   : フィールド文字列取得
//*
//*  < function >
//*
//*  < calling sequence>
//* function    GetString(szFldName: String;
//*                                iLen: Integer): String;
//*
//*   Result:     String  (RET)   取得文字列
//*   szFldName:  String  (IN)    フィールド名称
//*             iLen: Integer       (IN)    取得文字列長
//*
//*  < Remarks >
//*
//******************************************************************************
function    T_Query.GetString(szFldName: String; iLen: Integer): String;
var
  strWork:      String;
  iAllLen:      Integer;
begin

  strWork := GetString(szFldName);
  iAllLen := Length(strWork);
  if iAllLen > iLen then
  begin
    if mbLeadByte = ByteType( strWork,iLen ) then iLen := iLen-1;
    strWork := Copy( strWork,1,iLen );
  end;

  Result := strWork;
end;

//******************************************************************************
//* function name : GetString
//*
//* description   : フィールド文字列取得
//*
//*  < function >
//*
//*  < calling sequence>
//* function    GetString(szFldName: String): String;
//*
//*   Result:     String  (RET)   取得文字列
//*   szFldName:  String  (IN)    フィールド名称
//*
//*  < Remarks >
//*
//******************************************************************************
function T_Query.GetString(iFldNo: Integer): String;
begin
  try
    Result := MvQuery.Fields.FieldByNumber(iFldNo).AsString;
  except
    Result := '';
  end;
end;

//******************************************************************************
//* function name : GetDate
//*
//* description   : フィールド日付型取得
//*
//*  < function >
//*
//*  < calling sequence>
//* function    GetDate(szFldName: String): TDate;
//*
//*   Result:     String  (RET)   取得日付
//*   szFldName:  String  (IN)    フィールド名称
//*
//*  < Remarks >
//*
//******************************************************************************
function T_Query.GetDate(szFldName: String): TDateTime;
var
  LvField: TField;
begin
  try
    LvField:= MvQuery.FieldByName(szFldName);
    if LvField.IsNull then result:= INVALID_DATE
    else                   result:= LvField.AsDateTime;
  except
    Result := INVALID_DATE;
  end;
end;


//******************************************************************************
//* function name : GetCount
//*
//* description   : COUNT(*)取得
//*
//*  < function >
//*
//*  < calling sequence>
//* GetCount(szTable, szWhere: String); Integer;
//*
//*   Result:     Integer (RET)   取得カウント数
//*   szTable:    String  (IN)    テーブル名
//*                               ※ 複数テーブルの場合は「,」区切り
//*   szWhere:    String  (IN)    取得条件
//*
//*  < Remarks >
//*
//******************************************************************************
function    T_Query.GetCount(szTable, szWhere: String): Integer;
var
  iRecCnt:    Integer;    // 取得カウント
  szSQL:      String;     // SQL文字列
  iErrCode:   Integer;    // エラーコード
  szErrMsg:   String;     // エラーメッセージ
begin
  // SQL文字列作成
  szSQL := 'SELECT COUNT(*) '       + #10 +
           'FROM '                  + #10 +
             szTable                + #10 +
           'WHERE '                 + #10 +
             szWhere;

  // SQL実行
  iRecCnt := OpenQuery(szSQL, iErrCode, szErrMsg);
  if iRecCnt < 0 then begin
    Result := (-1);
    exit;
  end;

  // 取得件数設定
  Result := MvQuery.Fields.Fields[0].AsInteger;
end;

//******************************************************************************
//* function name : GetSequence
//*
//* description   : 付番
//*
//*  < function >
//*
//*  < calling sequence>
//* GetSequence(szSeq: String); Integer;
//*
//*   Result:     Integer (RET)   取得番号
//*   szSeq:      String  (IN)    シーケンス名
//*
//*  < Remarks >
//*
//******************************************************************************
function    T_Query.GetSequence(szSeq: String): Integer;
var
  szSQL:      String;     // SQL文字列
  iErrCode:   Integer;    // エラーコード
  szErrMsg:   String;     // エラーメッセージ
  sFunc:      String;
begin
  sFunc:= 'DBGetSequence';

  // SQL文字列作成
  szSQL := '';
  szSQL := szSQL + 'SELECT ' + szSeq + '.NextVal ';
  szSQL := szSQL + 'FROM DUAL';

  szErrMsg := Format('[%s]: Start', [sFunc]);
  FDbg.LOGOUT(szErrMsg);
  szErrMsg := Format('[%s]: SQL = %s', [sFunc, szSQL]);
  FDbg.LOGOUT(szErrMsg);

  result:= -1;

  try
    with MvQuery do begin
      SQL.Clear;
      SQL.Add(szSQL);
      Close;          //念のためクローズ
      Open;
      First;
      // シーケンス番号取得
      Result := Fields.Fields[0].AsInteger;
    end;
  except
    on Err : EDBEngineError do begin
      GetErrInfo(Err, iErrCode, szErrMsg);
      // ログ出力
      szErrMsg := Format('[%s]: ERROR = %s', [sFunc, szErrMsg]);
      FDbg.LOGOUT(szErrMsg);
    end;
    on Err : EDatabaseError do begin
      GetErrInfo(Err, iErrCode, szErrMsg);
      // ログ出力
      szErrMsg := Format('[%s]: ERROR = %s', [sFunc, szErrMsg]);
      FDbg.LOGOUT(szErrMsg);
    end;
  end;

  // ログ出力
  szErrMsg := Format('[%s]: End', [sFunc]);
  FDbg.LOGOUT(szErrMsg);
end;

//******************************************************************************
//* function name       : GetSysDate
//* description         : 現在日付取得
//*   <function>
//*
//*   <include file>
//*   <calling sequence>
//*     GetSysDate: TDateTime;
//*   <remarks>
//******************************************************************************
function T_Query.GetSysDate: TDateTime;
const
  SQL = 'SELECT SYSDATE FROM DUAL';
begin
  OpenQuery(SQL);
  result:= MvQuery.Fields[0].AsDateTime;
end;

//******************************************************************************
//* function name       : GetSysDate
//* description         : 現在日付取得
//*   <function>
//*
//*   <include file>
//*   <calling sequence>
//*     GetSysDate: TDateTime;
//*   <remarks>
//******************************************************************************
function T_Query.GetSysDateYMDHNS: String;
const
  SQL = 'SELECT SYSDATE FROM DUAL';
var
  wkDateTime: TDateTime;
begin
  try
    OpenQuery(SQL);
    wkDateTime := MvQuery.Fields[0].AsDateTime;
    Result := FormatDateTime('yyyy/mm/dd hh:nn:ss', wkDateTime);
  except
    Result := FormatDateTime('yyyy/mm/dd hh:nn:ss', now);
  end;
end;

//******************************************************************************
//* function name : Lock
//*
//* description   : テーブルロック
//*
//*  < function >
//*
//*  < calling sequence>
//* Lock(szTable: String; szWhere: String = ''): Boolean;
//*
//*   Result:     Boolean (RET)   True=成功,False=失敗
//*   szTable:    String  (IN)    テーブル名
//*   szWhere:    String  (IN)    ロックレコード条件
//*
//*  < Remarks >
//*
//******************************************************************************
function    T_Query.Lock(szTable: String; szWhere: String = ''): Boolean;
var
  iRecCnt:    Integer;    // 取得カウント
  szSQL:      String;     // SQL文字列
  iErrCode:   Integer;    // エラーコード
  szErrMsg:   String;     // エラーメッセージ
begin
  Result := True;

  // SQL文字列作成
  szSQL := 'SELECT * FROM ' + szTable;
  if szWhere <> '' then begin
    szSQL := szSQL + ' WHERE ' + szWhere;
  end;
  szSQL := szSQL + ' FOR UPDATE NOWAIT';

  // SQL実行
  iRecCnt := OpenQuery(szSQL, iErrCode, szErrMsg);
  if iRecCnt < 0 then Result := False;
end;

//******************************************************************************
//* function name : NeedRetry: boolean;
//*
//* description   : DB再接続の必要性の検証
//*
//*  < function >
//*     DB再接続の必要があるかどうかを判定する
//*  < calling sequence>
//*     NeedRetry: boolean;
//*
//*   Result:     Boolean (RET)   True= 必要あり False= 必要なし
//*  < Remarks >
//*
//******************************************************************************
function T_Query.NeedRetry: boolean;
const
  CHECK_SQL = 'SELECT SYSDATE FROM DUAL';
var
  iRslt: integer;
  iCode: integer;
  sMsg:  string;
begin
  result:= false;

  //SQL実行
  iRslt:= OpenQuery(CHECK_SQL, iCode, sMsg);

  if iRslt >= 0 then begin
    FLog.LOGOUT('DB 接続確認 OK');
    //エラーなし
    MvMsg:= '';
    exit;
  end;

  FLog.LOGOUT('接続確認時 DBエラー: ' + sMsg);
  MvMsg:= sMsg;

  //エラー時はとにかく再接続を試みる
  result:= true;
end;


end.

