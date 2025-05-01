unit UDb_RisShema;
(**
■機能説明
  シェーマ情報取得サービスのRisDBへのアクセス制御
■履歴
新規作成：2004.10.18：担当増田
*)

interface

uses
//システム－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, IniFiles,
  ScktComp,SvcMgr, //Db, DBTables,
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Gval,
  HisMsgDef,
  pdct_shema,
  TcpSocket,
  Unit_Log, Unit_DB
  ;
type  //シェーマ情報格納構造体
  TOrderSchema_List = record
    RIS_ID       : String;  //RIS_ID
    NO           : String;  //シェーマ部位連番
    SHEMANO      : String;  //シェーマ連番
    SHEMAPASS    : String;  //シェーマパス
    SHEMANM      : String;  //シェーマファイル名
    STATUS       : String;  //ステータス
    ERRMSG       : String;  //エラーメッセージ
    RISSHEMAPASS : String;  //RISシェーマファイル名
    RISHTMLPASS  : String;  //RISHTMLファイル名
    RISBUINAME   : String;  //RIS部位名
  end;
type  //シェーマ情報格納構造体
  TSchema_List = record
    PASS : array [1..10] of String;  //シェーマパス情報
    DATA : array [1..10] of String;  //シェーマ情報
    NO   : array [1..10] of String;  //連番
  end;
type
  TDB_RisShema = class    //RIS DB
    (*
    TQ_Order: TQuery;  //ExMainTable_実績メインテーブル
    TQ_Etc: TQuery;       //実績ﾌｨﾙﾑ
    TQ_ExMain: TQuery;          //区分
    TQ_DateTime: TQuery;     //時間
    *)
  private
    { Private 宣言 }
  public
    { Public 宣言 }
    (*
    DatabaseRis: TDatabase;    //RIS DB
    *)
    wg_DBFlg:Boolean;
    wg_Shema_Ret_Count : Integer;
    wg_Shema_Ret_Code  : String;
    wg_Shema_Ret_Message : String;
    wg_Log_Flg:String;
    wg_OrderSchame_List: Array of TOrderSchema_List;
    function  RisDBOpen(var arg_Flg    : Boolean;
                        var arg_ErrMsg : String;
                            arg_Svc    : TService
                        ): Boolean;
    procedure RisDBClose;
    function  func_GetOrder(
                  var rec_count: Integer;
                  var arg_ErrMsg:string
                 ):boolean;
    function  func_SelectOrder(    arg_Ris_ID:String;
                               var arg_ErrMsg,arg_NullFlg:string
                              ):Boolean;
    (*
    function  func_GetSysDate:string;
    *)
    function  func_SetOrderResult(
                 var arg_ErrMsg:string
                 ):boolean;
    function func_Del_Schema(arg_path,arg_RIS_ID,arg_Html:String;var arg_ErrMsg:String):Boolean;
    function func_GET_Shema(var arg_flg,arg_Err:String):Boolean;
    function func_Chack_HIS(arg_path:String;var arg_ErrMsg:String):Boolean;
    function  func_SetOrderResult_Up(
                 arg_RIS_ID,arg_Result,arg_Err:string;
                 var arg_ErrMsg:string
                 ):boolean;
    function func_Make_HTML(
                            var arg_ErrMsg:string
                           ):boolean;
    function func_UpDate_ExtendOrderMain(var arg_ErrMsg:string):boolean;
    function func_LogonExecute(Host, UserName, Passwd: string): DWord;
    function func_LogoffExecute(Host: string): DWord;
    function func_Logon(argDrive: String; var argErrmsg: String):Boolean;
    function func_Logout(argDrive: String; var argErrmsg: String):Boolean;
  end;

var
  DB_RisShema: TDB_RisShema;

implementation


const
//日付フォーマット文字列
CST_DATE_FORMAT='YYYY/MM/DD';
//エラー発生場所特定メッセージ
CST_GETORDERERR_MSG = '未取得レコード取得中にエラーが起きました。';
CST_GETORDERMAINERR_MSG = 'オーダシェーマレコード取得中にエラーが起きました。';
CST_KENSACHKERR_MSG = 'シェーマ情報取得中にエラーが起きました。';
CST_KEKKAERR_MSG = 'オーダシェーマテーブル結果保存中にエラーが起きました。';
CST_INS = '01';
CST_UP  = '02';
CST_DEL = '03';
//未取得
CST_GETNO_FLG='00';
//取得
CST_GETOK_FLG='01';
//失敗
CST_GETNG_FLG='02';
//再取得
CST_GETRE_FLG='03';

//成功
CST_FTPOK_FLG='0';
//接続失敗
CST_FTPERR_FLG='1';
//失敗
CST_FTPNG_FLG='2';
//失敗
CST_FTPOTHER_FLG='3';

{
-----------------------------------------------------------------------------
  名前 :RisDBOpen
  引数 :
    var arg_ErrMsg:string エラー時：詳細原因 正常時：''
  復帰値：例外ない  True 正常 False 異常
  機能 :
    1. アプリケーション固有のローカルBDEエリアスを作成して、Oracleに接続します。
 *
-----------------------------------------------------------------------------
}
function TDB_RisShema.RisDBOpen(var arg_Flg    : Boolean;
                              var arg_ErrMsg : String;
                                  arg_Svc    : TService):Boolean;
var
  RetryCnt: integer;
begin
  //戻り値
  Result := True;

  //ログ作成
  if not Assigned(FLog) then begin
    FLog := T_FileLog.Create(g_DBLOG04_PATH,
                             g_DBLOG04_PREFIX,
                             g_DBLOG04_LOGGING,
                             g_DBLOG04_KEEPDAYS,
                             g_LogFileSize, //2018/08/30 ログファイル変更
                             nil);
  end;
  if not Assigned(FDebug) then begin
    FDebug := T_FileLog.Create(g_DBLOGDBG04_PATH,
                               g_DBLOGDBG04_PREFIX,
                               g_DBLOGDBG04_LOGGING,
                               g_DBLOGDBG04_KEEPDAYS,
                               g_LogFileSize, //2018/08/30 ログファイル変更
                               nil);
  end;
  //期限切れログ削除
  FLog.DayChange;
  FDebug.DayChange;

  //設定
  wg_DBFlg := True;
  if FDB = nil then begin
    //データベースを作成
    FDB := T_ORADB.Create(g_RisDB_Name,
                          g_RisDB_Uid,
                          g_RisDB_Pas,
                          FLog, FDebug);
  end;
  //クエリー作成
  if not Assigned(FQ_SEL) then begin
    FQ_SEL := T_Query.Create(FDB, FLog, FDebug);
  end;
  if not Assigned(FQ_SEL_ORD) then begin
    FQ_SEL_ORD := T_Query.Create(FDB, FLog, FDebug);
  end;
  if not Assigned(FQ_ALT) then begin
    FQ_ALT := T_Query.Create(FDB, FLog, FDebug);
  end;
  //DB接続
  if FDB.DBConnect() = false then begin
    //リトライ回数初期化
    RetryCnt := 0;
    while RetryCnt < g_RisDB_Retry do begin
      //待機時間
      Sleep(10000);
      //再接続
      if FDB.DBConnect() = True then begin
        Exit;
      end;
    end;
    if RetryCnt > g_RisDB_Retry then begin
      wg_DBFlg := False;
      Result := False;
    end;
  end;
  //成功したのでリトライ回数を設定
  if wg_DBFlg = True Then begin
    //ログ出力
    proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_NUM,'RIS DB接続OK');
  end
  else begin
    //ログ出力
    proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_NUM,'RIS DB接続NG');
  end;
  (*
  //戻り値
  Result := True;
  //DB接続がされていない場合
  if (not arg_Flg) or (not DatabaseRis.Connected) then
  begin
    if DatabaseRis = nil then
      //データベースを作成
      DatabaseRis := TDatabase.Create(self);
    try
      //データベースへの単独アクセス不可
      DatabaseRis.Exclusive := False;
      //データベースハンドルの共有
      DatabaseRis.HandleShared := True;
      //オープンされているデータセットがなくてもアプリケーションをデータベースに接続しておく
      DatabaseRis.KeepConnection := True;
      //ログインダイアログ表示なし
      DatabaseRis.LoginPrompt := False;
      //初期値設定
      Result := True;
      //リトライ回数初期化
      RetryCnt := 0;
      try
        //設定されたリトライ回数を超えるまで
        while RetryCnt < g_RisDB_Retry do
        begin
          //リトライ回数＋1
          inc(RetryCnt);
          try
            //DBの接続情報の設定
            //接続を閉じる
            DatabaseRis.Close;
            //データベース名設定
            DatabaseRis.DatabaseName               := g_RisDB_Name;
            //ユーザー名設定
            DatabaseRis.Params.Values['USER NAME'] := g_RisDB_Uid;
            //パスワード設定
            DatabaseRis.Params.Values['PASSWORD']  := g_RisDB_Pas;
            //ログインダイアログボックスを表示しない様にする
            DatabaseRis.LoginPrompt := False;
            //Oracleに接続
            DatabaseRis.Open;
            //戻り値
            Result := True;
            //接続有り
            arg_Flg := True;
            //成功したのでリトライ回数を設定
            RetryCnt := g_RisDB_Retry;
          except
            on E: Exception do
            begin
              //失敗した場合は復帰値をFalseにしてリトライ
              Result := False;
              //エラーメッセージ
              arg_ErrMsg := E.Message;
              //待機時間
              Sleep(10000);
              //サービスがある場合
              if arg_Svc <> nil then
              begin
                //サービスが起動している場合
                if not (arg_Svc.Terminated) then
                begin
                  //リトライ
                  Continue;
                end
                //サービスが起動していない場合
                else
                begin
                  //処理終了
                  Exit;
                end;
              end
              //サービスがない場合
              else
              begin
                //リトライ
                Continue;
              end;
            end;
          end;
        end;
        //OPENできたらその他設定をする（ここでなくても良い？ ）
        if DatabaseRis.Connected then
        begin
          //支配下のQeryに設定
          TQ_Order.Close;
          if TQ_Order.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_Order.DatabaseName := DatabaseRis.DatabaseName;

          TQ_Etc.Close;
          if TQ_Etc.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_Etc.DatabaseName := DatabaseRis.DatabaseName;

          TQ_ExMain.Close;
          if TQ_ExMain.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_ExMain.DatabaseName := DatabaseRis.DatabaseName;

          TQ_DateTime.Close;
          if TQ_DateTime.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_DateTime.DatabaseName := DatabaseRis.DatabaseName;
          //エラーなし
          arg_ErrMsg := '';
        end;
        //処理終了
        Exit;
      except
        on E: Exception do
        begin
          //データベースが接続されていた場合
          if DatabaseRis.Connected then
            //切断
            DatabaseRis.Close;
          //エラーメッセージ
          arg_ErrMsg := E.Message;
          //戻り値
          Result := False;
          //フラグ設定
          arg_Flg := False;
          //処理終了
          Exit;
        end;
      end;
    except
      on E: Exception do
      begin
        //データベースが作成されていた場合
        if DatabaseRis <> nil then
        begin
         //開放
         DatabaseRis.Free;
         Sleep(1000);
         //nil設定
         DatabaseRis := nil;
        end;
        //エラーメッセージ
        arg_ErrMsg := E.Message;
        //戻り値
        Result := False;
        //フラグ設定
        arg_Flg := False;
        //処理終了
        Exit;
      end;
    end;
  end;
  *)
end;
{
-----------------------------------------------------------------------------
  名前 :RisDBClose
  引数 :
  復帰値：例外ない 無し
  機能 :
    1. OracleのDB関連クローズ。
 *
-----------------------------------------------------------------------------
}
procedure TDB_RisShema.RisDBClose;
begin
  wg_DBFlg := False;
  try
    FDB.DBDisConnect();
  except
  end;
  (*
  try
    TQ_Order.Close;
    TQ_Etc.Close;
    TQ_ExMain.Close;
    TQ_DateTime.Close;
    if DatabaseRis<>nil then
    begin
      DatabaseRis.Connected := False;
      sleep(100);
      DatabaseRis.Close;
      sleep(100);
      DatabaseRis.Free;
      sleep(100);
      DatabaseRis:=nil;
      wg_DBFlg := False;
    end;
  except
    DatabaseRis.Connected := False;
    sleep(100);
    DatabaseRis.Close;
    sleep(100);
    DatabaseRis.Free;
    sleep(100);
    DatabaseRis:=nil;
    wg_DBFlg := False;
  end;
  *)
end;
{
-----------------------------------------------------------------------------
  名前 :func_GetOrder
  引数 :
    var arg_ErrMsg:string エラー時：詳細原因 正常時：''
  復帰値：例外ない  True 正常 False 異常
  機能 :
    1. 受信オーダテーブルから未取得レコードをオーダ送信日時の古い順に取得。
 *
-----------------------------------------------------------------------------
}
function  TDB_RisShema.func_GetOrder(
    var rec_count: Integer;
    var arg_ErrMsg:string
    ):boolean;
var
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //戻り値
  Result:=True;
  rec_count := 0;
  try
    with FQ_SEL_ORD do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT DISTINCT(RIS_ID)';
      sqlSelect := sqlSelect + ' FROM ORDERSHEMATABLE';
      sqlSelect := sqlSelect + ' WHERE STATUS = :PSTATUS';
      sqlSelect := sqlSelect + ' ORDER BY RIS_ID';
      PrepareQuery(sqlSelect);
      //パラメータ
      //シェーマフラグ"未取得"
      SetParam('PSTATUS', CST_GETNO_FLG);
      //SQL実行
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //例外エラー
        Result := False;
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
    end;
    rec_count := iRslt;
    //正常終了処理
    arg_ErrMsg := '';
    //処理終了
    Exit;
  except
    on E: Exception do begin
      //エラー終了処理
      Result := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_GETORDERERR_MSG + E.Message;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 :func_SelectOrder
  引数 :
        arg_Ris_ID:String  RIS_ID
    var arg_ErrMsg:string エラー時：詳細原因 正常時：''
    var arg_NullFlg:string データの有無
  復帰値：例外ない  True 正常 False 異常
  機能 :
    1. オーダシェーマテーブルからシェーマディレクトリなどの情報を取得。
 *
-----------------------------------------------------------------------------
}
function  TDB_RisShema.func_SelectOrder(    arg_Ris_ID: String;
                                        var arg_ErrMsg,arg_NullFlg: String
                                       ):Boolean;
var
  WILoop:     Integer;
  sqlSelect:  String;
  iRslt:      Integer;
  rec_count:  Integer;
begin
  //戻り値
  Result:=True;
  try
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT Os.RIS_ID, Os.NO, Os.SHEMANO, Os.SHEMAPATH, Os.SHEMANM, Os.STATUS, Bm.BUI_NAME';
      sqlSelect := sqlSelect + ' FROM ORDERSHEMATABLE Os, ORDERBUITABLE Ob, BUIMASTER Bm';
      sqlSelect := sqlSelect + ' WHERE Os.RIS_ID = :PRIS_ID';
      sqlSelect := sqlSelect + ' AND (Os.RIS_ID = Ob.RIS_ID';
      sqlSelect := sqlSelect + ' AND Os.NO = Ob.NO)';
      sqlSelect := sqlSelect + ' AND Ob.BUI_ID = Bm.BUI_ID(+)';
      sqlSelect := sqlSelect + ' ORDER BY Os.RIS_ID, Os.NO, Os.SHEMANO';
      PrepareQuery(sqlSelect);
      //パラメータ
      //RIS_ID
      SetParam('PRIS_ID', arg_Ris_ID);
      //SQL実行
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        arg_NullFlg := '1';
        //例外エラー
        Result := False;
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
      rec_count := iRslt;
      //レコードがある場合
      if rec_count > 0 then
      begin
        SetLength(wg_OrderSchame_List, rec_count);
        for WILoop := 0 to rec_count - 1 do
        begin
          wg_OrderSchame_List[WILoop].RIS_ID := GetString('RIS_ID');
          wg_OrderSchame_List[WILoop].NO := GetString('NO');
          wg_OrderSchame_List[WILoop].SHEMANO := GetString('SHEMANO');
          wg_OrderSchame_List[WILoop].SHEMAPASS := IncludeTrailingPathDelimiter(ExtractFileDir(StringReplace(GetString('SHEMAPATH'),'/','\',[rfReplaceAll])));
          wg_OrderSchame_List[WILoop].SHEMANM := ExtractFileName(StringReplace(GetString('SHEMAPATH'),'/','\',[rfReplaceAll]));
          wg_OrderSchame_List[WILoop].STATUS := GetString('STATUS');
          wg_OrderSchame_List[WILoop].RISSHEMAPASS := g_SHEMA_LOCAL_PASS + GetString('RIS_ID') + '_' + FormatFloat('00',StrToIntDef(GetString('NO'), 0)) + '.jpg';
          wg_OrderSchame_List[WILoop].RISHTMLPASS := g_SHEMA_HTML_PASS + GetString('RIS_ID') + '_' + FormatFloat('00',StrToIntDef(GetString('NO'), 0)) + '.HTML';
          wg_OrderSchame_List[WILoop].RISBUINAME := GetString('BUI_NAME');
          Next;
        end;
      end
      //レコードがない場合
      else begin
        //データ無し
        arg_NullFlg := '1';
        arg_ErrMsg := 'オーダシェーマテーブルにデータがありません。';
        //処理終了
        Exit;
      end;
    end;
    //正常終了処理
    arg_ErrMsg := '';
    //処理終了
    Exit;
  except
    on E: Exception do
    begin
      arg_NullFlg := '1';
      //エラー終了処理
      Result := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_GETORDERMAINERR_MSG + E.Message;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 :func_GetSysDate
  引数 :無し
  復帰値：例外ない
          'YYYY/MM/DD HH:MI:SS'
  機能 :
    1. データベースのシステム日付日時を取得する。
    非常にまれではあるがエラーの場合はマシンの日付を返還する。
 *
-----------------------------------------------------------------------------
}
(*
function  TDB_RisShema.func_GetSysDate:string;
var
   w_TDateTime:TDateTime;
begin
  try
    TQ_DateTime.SQL.Clear;
    TQ_DateTime.SQL.Add('SELECT SYSDATE FROM DUAL ');
    TQ_DateTime.Open;
    w_TDateTime := TQ_DateTime.FieldValues['SYSDATE'];
    TQ_DateTime.close;
    Result:=FormatDateTime('yyyy/mm/dd hh:nn:ss', w_TDateTime);
    exit;
  except
    Result:=FormatDateTime('yyyy/mm/dd hh:nn:ss', Now);
    exit;
  end;
end;
*)

{
-----------------------------------------------------------------------------
  名前 :func_SetOrderResult
  引数 :
    var arg_ErrMsg:string エラー時：詳細原因 正常時：''
  復帰値：例外ない
          True 正常 False 異常
  機能 :
    1. 受信オーダテーブルのカレントレコードに受信結果を登録します。
 *
-----------------------------------------------------------------------------
}
function  TDB_RisShema.func_SetOrderResult(
    var arg_ErrMsg:string
    ):boolean;
var
  WILoop:   Integer;
  sqlExec:  String;
  iRslt:    Integer;
begin
  //戻り値
  Result := True;
  try
    //HIS送信結果保存SQL作成
    with FQ_ALT do begin
      if Length(wg_OrderSchame_List) > 0 then
      begin
        for WILoop := 0 to Length(wg_OrderSchame_List) - 1 do
        begin
          //SQL文字列作成
          sqlExec := '';
          sqlExec := sqlExec + 'UPDATE ORDERSHEMATABLE';
          sqlExec := sqlExec + ' SET STATUS = :PSTATUS,';
          sqlExec := sqlExec + ' RESULTDATE = SYSDATE,';
          sqlExec := sqlExec + ' RESULT = :PRESULT,';
          sqlExec := sqlExec + ' RESULTBIKOU = :PRESULTBIKOU';
          sqlExec := sqlExec + ' WHERE RIS_ID = :PRIS_ID';
          sqlExec := sqlExec + ' AND NO = :PNO';
          //SQL設定
          PrepareQuery(sqlExec);
          //パラメータ
          if wg_OrderSchame_List[WILoop].STATUS = CST_GETNO_FLG then
          begin
            //ステータス
            SetParam('PSTATUS', wg_OrderSchame_List[WILoop].STATUS);
            //結果
            SetParam('PRESULT', '通信不可');
          end
          else if wg_OrderSchame_List[WILoop].STATUS = CST_GETOK_FLG then
          begin
            //ステータス
            SetParam('PSTATUS', wg_OrderSchame_List[WILoop].STATUS);
            //結果
            SetParam('PRESULT', 'ＯＫ');
          end
          else if wg_OrderSchame_List[WILoop].STATUS = CST_GETNG_FLG then
          begin
            //ステータス
            SetParam('PSTATUS', CST_GETOK_FLG);
            //結果
            SetParam('PRESULT', 'ＮＧ');
          end;
          //メッセージ
          SetParam('PRESULTBIKOU', wg_OrderSchame_List[WILoop].ERRMSG);
          //RIS_ID
          SetParam('PRIS_ID', wg_OrderSchame_List[WILoop].RIS_ID);
          //NO
          SetParam('PNO', wg_OrderSchame_List[WILoop].NO);
          //SQL実行
          iRslt:= ExecSQL();
          if iRslt < 0 then begin
            //失敗
            Result := False;
            //切断
            wg_DBFlg := False;
            //
            Exit;
          end;
        end;
      end;
    end;
    //正常終了処理
    arg_ErrMsg := '';
    //処理終了
    Exit;
  except
    on E: Exception do begin
      //エラー終了処理
      Result := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_KEKKAERR_MSG + E.Message;
      //処理終了
      Exit;
    end;
  end;
end;

function  TDB_RisShema.func_SetOrderResult_Up(
    arg_RIS_ID,arg_Result,arg_Err:string;
    var arg_ErrMsg:string
    ):boolean;
var
  sqlExec:  String;
  iRslt:    Integer;
begin
  //戻り値
  Result := True;
  try
    //HIS送信結果保存SQL作成
    with FQ_ALT do begin
      //SQL文字列作成
      sqlExec := '';
      sqlExec := sqlExec + 'UPDATE ORDERSHEMATABLE';
      sqlExec := sqlExec + ' SET STATUS = :PSTATUS,';
      sqlExec := sqlExec + ' RESULTDATE = SYSDATE,';
      sqlExec := sqlExec + ' RESULT = :PRESULT,';
      sqlExec := sqlExec + ' RESULTBIKOU = :PRESULTBIKOU';
      sqlExec := sqlExec + ' WHERE RIS_ID = :PRIS_ID';
      //SQL設定
      PrepareQuery(sqlExec);
      //パラメータ
      if arg_Result = CST_GETNO_FLG then
      begin
        //ステータス
        SetParam('PSTATUS', arg_Result);
        //結果
        SetParam('PRESULT', '通信不可');
      end
      else if arg_Result = CST_GETOK_FLG then
      begin
        //ステータス
        SetParam('PSTATUS', arg_Result);
        //結果
        SetParam('PRESULT', 'ＯＫ');
      end
      else if arg_Result = CST_GETNG_FLG then
      begin
        //ステータス
        SetParam('PSTATUS', CST_GETOK_FLG);
        //結果
        SetParam('PRESULT', 'ＮＧ');
      end
      else if arg_Result = CST_GETRE_FLG then
      begin
        //ステータス
        SetParam('PSTATUS', CST_GETNO_FLG);
        //結果
        SetParam('PRESULT', 'ＮＧ');
      end;
      //メッセージ
      SetParam('PRESULTBIKOU', arg_Err);
      //RIS_ID
      SetParam('PRIS_ID', arg_RIS_ID);
      //SQL実行
      iRslt:= ExecSQL();
      if iRslt < 0 then begin
        //失敗
        Result := False;
        //切断
        wg_DBFlg := False;
        //
        Exit;
      end;
    end;
    //正常終了処理
    arg_ErrMsg := '';
    //処理終了
    Exit;
  except
    on E: Exception do begin
      //エラー終了処理
      Result := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_KEKKAERR_MSG + E.Message;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 :func_Del_Schema
  引数 :
    arg_path:String    フォルダ名
    arg_RIS_ID:String  RIS_ID
    var arg_ErrMsg:string  エラー時：詳細原因 正常時：''
  復帰値：例外ない
  機能 :
    1. 指定RIS_IDのシェーマファイルがあれば削除。
 *
-----------------------------------------------------------------------------
}
function TDB_RisShema.func_Del_Schema(arg_path,arg_RIS_ID,arg_Html:String;var arg_ErrMsg:String):Boolean;
var
  SearchRec: TSearchRec;
  PathName: string;
  FileNameList:TStrings;
  w_i:Integer;
  wi_Pos: Integer;
begin
  //初期化
  Result := False;
  //フォルダが存在していない場合には正常終了
  if (DirectoryExists(arg_path) = False) then begin
    //戻り値
    Result := True;
    //処理終了
    Exit;
  end
  //ファイルが存在するばあいには削除を行う
  else begin
    FileNameList:=TStringList.Create;
    FileNameList.Clear;
    try
      //シェーマファイル取得
      if not IsPathDelimiter(arg_path, Length(arg_path)) then
        arg_path := arg_path + '\';
      SysUtils.FindFirst(arg_path +'*.*', faAnyFile, SearchRec);
      try
        if SearchRec.Name='' then Exit;
        repeat
          //拡張子を除いた部分だけ抽出できる関数！  EX.Test.txt　→　Test
          PathName:= ChangeFileExt(SearchRec.Name,'');
          if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then
            FileNameList.Add(SearchRec.Name);
          until SysUtils.FindNext(SearchRec)<>0;
      finally
        SysUtils.FindClose(SearchRec);
      end;
      //指定のRIS_IDのシェーマファイルを検索
      for w_i := 0 to FileNameList.Count -1 do begin
        //RIS_IDの取得
        wi_Pos := Pos('_',FileNameList[w_i]);
        //指定のRIS_IDのファイルの場合
        if Copy(FileNameList[w_i],1,wi_Pos - 1) = arg_RIS_ID then begin
          //存在確認
          if FileExists(arg_path + FileNameList[w_i]) then begin
            try
              //削除
              DeleteFile(arg_path + FileNameList[w_i]);
            except
              on E:Exception do begin
                //エラーメッセージ
                arg_ErrMsg := E.Message;
                //処理終了
                Exit;
              end;
            end;
          end;
        end;
      end;
      //フォルダが存在していない場合には正常終了
      if (DirectoryExists(arg_Html) = False) then begin
        //戻り値
        Result := True;
        //処理終了
        Exit;
      end
      else
      begin
        FileNameList.Clear;
        //HTMLファイル取得
        if not IsPathDelimiter(arg_Html, Length(arg_Html)) then
          arg_Html := arg_Html + '\';
        SysUtils.FindFirst(arg_Html +'*.*', faAnyFile, SearchRec);
        try
          if SearchRec.Name='' then Exit;
          repeat
            //拡張子を除いた部分だけ抽出できる関数！  EX.Test.txt　→　Test
            PathName:= ChangeFileExt(SearchRec.Name,'');
            if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then
              FileNameList.Add(SearchRec.Name);
            until SysUtils.FindNext(SearchRec)<>0;
        finally
          SysUtils.FindClose(SearchRec);
        end;
        //指定のRIS_IDのHTMLファイルを検索
        for w_i := 0 to FileNameList.Count -1 do begin
          //RIS_IDの取得
          wi_Pos := Pos('_',FileNameList[w_i]);
          //指定のRIS_IDのファイルの場合
          if Copy(FileNameList[w_i],1,wi_Pos - 1) = arg_RIS_ID then begin
            //存在確認
            if FileExists(arg_Html + FileNameList[w_i]) then begin
              try
                //削除
                DeleteFile(arg_Html + FileNameList[w_i]);
              except
                on E:Exception do begin
                  //エラーメッセージ
                  arg_ErrMsg := E.Message;
                  //処理終了
                  Exit;
                end;
              end;
            end;
          end;
        end;
      end;
      //戻り値
      Result := True;
    finally
      //開放
      FreeAndNil(FileNameList);
    end;
  end;
end;

function TDB_RisShema.func_Chack_HIS(arg_path:String;var arg_ErrMsg:String):Boolean;
begin
  //初期化
  Result := True;

  if (DirectoryExists(arg_path) = False) then begin
    //戻り値
    Result := False;
    //処理終了
    Exit;
  end;
end;

function TDB_RisShema.func_GET_Shema(var arg_flg,arg_Err:String):Boolean;
var
  i: integer;
  w_Flg:String;
  WILoop: Integer;
  WSConnectErr: String;
begin
  //初期値
  Result := True;
  w_Flg := '';
  //初期設定
  arg_flg := CST_GETOK_FLG;

  if Length(wg_OrderSchame_List) = 0 then
  begin
    //ログ文字列作成
    proc_StrConcat(arg_Err,'シェーマ無');
    wg_Log_Flg := G_LOG_LINE_HEAD_NG;
    //取得失敗
    arg_flg := CST_GETNG_FLG;
    //処理終了
    Exit;
  end
  else
  begin
    //ログ文字列作成
    proc_StrConcat(arg_Err,'シェーマ有');
  end;

//②
  //シェーマファイル(HIS→RISｻｰﾊﾞ)ダウンロード
  wg_Shema_Ret_Count := 0;
  for i := 0 to Length(wg_OrderSchame_List) - 1 do begin
    if (wg_OrderSchame_List[i].RISSHEMAPASS <> '') and
       //(g_SHEMA_HIS_PASS + wg_OrderSchame_List[i].SHEMAPASS <> '') then begin
       (wg_OrderSchame_List[i].SHEMAPASS <> '') then begin
      //ファイルが存在していなければGETする
      if not(FileExists(wg_OrderSchame_List[i].RISSHEMAPASS)) then begin
        try

          if func_Logon(wg_OrderSchame_List[i].SHEMAPASS,WSConnectErr) then
          begin
            //ログ文字列作成
            proc_StrConcat(arg_Err,'HIS共有フォルダ接続 OK');
            //if not(DirectoryExists(g_SHEMA_HIS_PASS)) then
            if not(DirectoryExists(wg_OrderSchame_List[i].SHEMAPASS)) then
            begin
              wg_Log_Flg := G_LOG_LINE_HEAD_NG;
              wg_OrderSchame_List[i].STATUS := CST_GETNO_FLG;
              wg_OrderSchame_List[i].ERRMSG := 'HISフォルダなし';
              //ログ文字列作成
              proc_StrConcat(arg_Err,
                             FormatFloat('00',i + 1) +
                             '「' + wg_OrderSchame_List[i].SHEMAPASS + '」' +
                             '「HISフォルダなしエラー」' );
              //未取得
              arg_flg := CST_GETNO_FLG;
              //戻り値
              Result := False;
            end;

            //if not(FileExists(g_SHEMA_HIS_PASS + wg_OrderSchame_List[i].SHEMAPASS)) then
            if not(FileExists(wg_OrderSchame_List[i].SHEMAPASS + wg_OrderSchame_List[i].SHEMANM)) then
            begin
              wg_Log_Flg := G_LOG_LINE_HEAD_NG;
              wg_OrderSchame_List[i].STATUS := CST_GETNG_FLG;
              wg_OrderSchame_List[i].ERRMSG := 'ファイルなし';
              //ログ文字列作成
              proc_StrConcat(arg_Err,
                             FormatFloat('00',i + 1) +
                             '「' + wg_OrderSchame_List[i].SHEMAPASS + wg_OrderSchame_List[i].SHEMANM + '」' +
                             '「ファイルなしエラー」' );
              //取得済
              arg_flg := CST_GETNG_FLG;
              //戻り値
              Result := False;

              for WILoop := 0 to Length(wg_OrderSchame_List) - 1 do
              begin
                wg_OrderSchame_List[WILoop].STATUS := CST_GETNG_FLG;
              end;

              Exit;
            end;
            try
              //コピー処理
              //proc_CopyFile(g_SHEMA_HIS_PASS + wg_OrderSchame_List[i].SHEMAPASS,
              proc_CopyFile(wg_OrderSchame_List[i].SHEMAPASS + wg_OrderSchame_List[i].SHEMANM,
                            wg_OrderSchame_List[i].RISSHEMAPASS);
              wg_OrderSchame_List[i].STATUS := CST_GETOK_FLG;
              wg_OrderSchame_List[i].ERRMSG := '';
              //ログ文字列作成
              proc_StrConcat(arg_Err,
                             FormatFloat('00',i + 1) +
                             '「' + wg_OrderSchame_List[i].SHEMAPASS + wg_OrderSchame_List[i].SHEMANM + '」' +
                             '「' + wg_OrderSchame_List[i].RISSHEMAPASS + '」' );
            except
              on E:Exception do
              begin
                wg_Log_Flg := G_LOG_LINE_HEAD_NG;
                wg_OrderSchame_List[i].STATUS := CST_GETNO_FLG;
                wg_OrderSchame_List[i].ERRMSG := 'コピー処理例外エラー「' + E.Message + '」';
                //ログ文字列作成
                proc_StrConcat(arg_Err,
                               FormatFloat('00',i + 1) +
                               '「' + wg_OrderSchame_List[i].SHEMAPASS + wg_OrderSchame_List[i].SHEMANM + '」' +
                               '「' + E.Message + '」' );
                //取得済
                arg_flg := CST_GETNO_FLG;
                //戻り値
                Result := False;
              end;
            end;
          end
          else
          begin
            wg_Log_Flg := G_LOG_LINE_HEAD_NG;
            wg_OrderSchame_List[i].STATUS := CST_GETNO_FLG;
            wg_OrderSchame_List[i].ERRMSG := 'HIS共有フォルダ接続不可「' + WSConnectErr + '」';
            //ログ文字列作成
            proc_StrConcat(arg_Err,
                           FormatFloat('00',i + 1) +
                           '「' + wg_OrderSchame_List[i].SHEMAPASS + '」' +
                           'HIS共有フォルダ接続不可「' + WSConnectErr + '」' );
            //未取得
            arg_flg := CST_GETNO_FLG;
            //戻り値
            Result := False;
          end;
          wg_Shema_Ret_Count := wg_Shema_Ret_Count + 1;
        finally
          if func_Logon(wg_OrderSchame_List[i].SHEMAPASS,WSConnectErr) then
          begin
            //ログ文字列作成
            proc_StrConcat(arg_Err,'HIS共有フォルダ切断 OK');
          end
          else
          begin
            //ログ文字列作成
            proc_StrConcat(arg_Err,'HIS共有フォルダ切断 NG 「' + WSConnectErr + '」');
          end;
        end;
      end
      //既に存在していれば何もしない
      else begin
        wg_Shema_Ret_Count := wg_Shema_Ret_Count + 1;
        wg_Log_Flg := G_LOG_LINE_HEAD_NG;
        wg_OrderSchame_List[i].STATUS := CST_GETNG_FLG;
        wg_OrderSchame_List[i].ERRMSG := '既存ファイルあり';
        //ログ文字列作成
        proc_StrConcat(arg_Err,
                       FormatFloat('00',i + 1) +
                       '「' + wg_OrderSchame_List[i].SHEMAPASS + wg_OrderSchame_List[i].SHEMANM + '」' +
                       '「既存ファイルありエラー」' );
        //取得済
        arg_flg := CST_GETNG_FLG;
        //戻り値
        Result := False;
      end;
    end;
  end;
end;

function  TDB_RisShema.func_Make_HTML(
                                      var arg_ErrMsg:string
                                     ):boolean;
var
  WSKANJA_ID: String;
  WSKANJISIMEI: String;
  WSKENSA_DATE: String;
  WSKENSATYPE_NAME: String;
  WSORDERNO: String;
  WSSECTION_NAME: String;
  WSIRAI_DOCTOR_NAME: String;
  w_HTML_Text: String;
  TxtFile: TextFile;
  w_Record: string;
  i: Integer;
  w_No: string;
  w_Name: string;

  sqlSelect:  String;
  iRslt:      Integer;
  cnt_record: Integer;
begin
  //戻り値
  Result := True;
  try
    //HIS送信結果保存SQL作成
    with FQ_SEL do begin
      if Length(wg_OrderSchame_List) > 0 then
      begin
        //SQL設定
        sqlSelect := '';
        sqlSelect := sqlSelect + 'SELECT Om.KANJA_ID, Pa.KANJISIMEI, Em.KENSA_DATE, Km.KENSATYPE_NAME, Om.ORDERNO, Sm.SECTION_NAME,Om.IRAI_DOCTOR_NAME';
        sqlSelect := sqlSelect + ' FROM ORDERMAINTABLE Om, PATIENTINFO Pa, EXMAINTABLE Em, KENSATYPEMASTER Km, SECTIONMASTER Sm';
        sqlSelect := sqlSelect + ' WHERE Om.RIS_ID = :PRIS_ID';
        sqlSelect := sqlSelect + '  AND Om.RIS_ID = Em.RIS_ID(+)';
        sqlSelect := sqlSelect + '  AND Om.KANJA_ID = Pa.KANJA_ID(+)';
        sqlSelect := sqlSelect + '  AND Om.KENSATYPE_ID = Km.KENSATYPE_ID(+)';
        sqlSelect := sqlSelect + '  AND Om.IRAI_SECTION_ID = Sm.SECTION_ID(+)';
        PrepareQuery(sqlSelect);
        //パラメータ
        //RIS_ID
        SetParam('PRIS_ID', wg_OrderSchame_List[0].RIS_ID);
        //SQL実行
        iRslt:= OpenQuery();
        if iRslt < 0 then begin
          //例外エラー
          Result := False;
          //切断
          wg_DBFlg := False;
          //処理終了
          Exit;
        end;
        cnt_record := iRslt;
        //レコードがある場合
        if cnt_record > 0 then
        begin
          WSKANJA_ID         := GetString('KANJA_ID');
          WSKANJISIMEI       := GetString('KANJISIMEI');
          WSKENSA_DATE       := GetString('KENSA_DATE');
          WSKENSATYPE_NAME   := GetString('KENSATYPE_NAME');
          WSORDERNO          := GetString('ORDERNO');
          WSSECTION_NAME     := GetString('SECTION_NAME');
          WSIRAI_DOCTOR_NAME := GetString('IRAI_DOCTOR_NAME');
        end
        //レコードがない場合
        else
        begin
          //戻り値
          Result := False;
          //データ無し
          arg_ErrMsg := 'オーダメインテーブルにデータがありません。';
          //処理終了
          Exit;
        end;
        g_Shema_HTML_Original_File := G_RunPath + CST_SHEMA_HTML_ORIGINAL;
        if not FileExists(g_Shema_HTML_Original_File) then
        begin
          //戻り値
          Result := False;
          arg_ErrMsg := 'HTMLファイルが見つかりません：'+g_Shema_HTML_Original_File;
          Exit;
        end;
        //...格納先
        //g_Shema_HTML_File := ExtractFileDir(g_Shema_HTML_Original_File) + '\' + CST_SHEMA_HTML_ORDER;
        //HTMLオリジナルの内容をコピー
        w_HTML_Text := '';
        AssignFile(TxtFile, g_Shema_HTML_Original_File);
        Reset(TxtFile);
        try
          while not system.Eof(TxtFile) do
          begin
            try
              Readln(TxtFile, w_Record);
            except
              on E:EInOutError do
              begin
                //戻り値
                Result := False;
                arg_ErrMsg := 'HTMLファイルの読込に失敗しました：' + E.Message;
                Exit;
              end;
            end;
            //置き換え処理
            if (Pos('<!--', w_Record) > 0) or
               (Pos('-->', w_Record) > 0) then begin
            end
            else begin
              //ヘダー
              if Pos('*患者ID*', w_Record) > 0 then begin
                if WSKANJA_ID <> '' then
                  w_Record := StringReplace(w_Record,'*患者ID*',WSKANJA_ID,[rfReplaceAll])
                else
                  w_Record := StringReplace(w_Record,'*患者ID*','<span class=dmy_txt></span>',[rfReplaceAll]);
              end;
              if Pos('*氏名*', w_Record) > 0 then begin
                if WSKANJISIMEI <> '' then
                  w_Record := StringReplace(w_Record,'*氏名*',WSKANJISIMEI,[rfReplaceAll])
                else
                  w_Record := StringReplace(w_Record,'*氏名*','<span class=dmy_txt></span>',[rfReplaceAll]);
              end;
              if Pos('*実施検査日*', w_Record) > 0 then begin
                if WSKENSA_DATE <> '' then
                  w_Record := StringReplace(w_Record,'*実施検査日*',func_Date8To10(WSKENSA_DATE),[rfReplaceAll])
                else
                  w_Record := StringReplace(w_Record,'*実施検査日*','<span class=dmy_txt></span>',[rfReplaceAll]);
              end;
              if Pos('*検査種別*', w_Record) > 0 then begin
                if WSKENSATYPE_NAME <> '' then
                  w_Record := StringReplace(w_Record,'*検査種別*',WSKENSATYPE_NAME,[rfReplaceAll])
                else
                  w_Record := StringReplace(w_Record,'*検査種別*','<span class=dmy_txt></span>',[rfReplaceAll]);
              end;
              if Pos('*ｵｰﾀﾞNO*', w_Record) > 0 then begin
                if WSORDERNO <> '' then
                  w_Record := StringReplace(w_Record,'*ｵｰﾀﾞNO*',WSORDERNO,[rfReplaceAll])
                else
                  w_Record := StringReplace(w_Record,'*ｵｰﾀﾞNO*','<span class=dmy_txt></span>',[rfReplaceAll]);
              end;
              if Pos('*依頼科*', w_Record) > 0 then begin
                if WSSECTION_NAME <> '' then
                  w_Record := StringReplace(w_Record,'*依頼科*',WSSECTION_NAME,[rfReplaceAll])
                else
                  w_Record := StringReplace(w_Record,'*依頼科*','<span class=dmy_txt></span>',[rfReplaceAll]);
              end;
              if Pos('*依頼医*', w_Record) > 0 then begin
                if WSIRAI_DOCTOR_NAME <> '' then
                  w_Record := StringReplace(w_Record,'*依頼医*',WSIRAI_DOCTOR_NAME,[rfReplaceAll])
                else
                  w_Record := StringReplace(w_Record,'*依頼医*','<span class=dmy_txt></span>',[rfReplaceAll]);
              end;
              //部位、シェーマ画像、部位コメント
              for i := 0 to 9 do
              begin
                w_No := FormatFloat('00', i + 1);
                if Length(wg_OrderSchame_List) - 1 >= i then
                begin
                  //部位名
                  w_Name := '*部位'+w_No+'*';
                  if Pos(w_Name, w_Record) > 0 then begin
                    if wg_OrderSchame_List[i].RISBUINAME <> '' then
                      w_Record := StringReplace(w_Record,w_Name,wg_OrderSchame_List[i].RISBUINAME,[rfReplaceAll])
                    else
                      w_Record := '<TD><span class=dmy_gazou></span></TD>';
                  end;
                  //シェーマ画像
                  w_Name := '*ｼｪｰﾏ画像'+w_No+'*';
                  if Pos(w_Name, w_Record) > 0 then begin
                    if wg_OrderSchame_List[i].RISSHEMAPASS <> '' then
                      w_Record := StringReplace(w_Record,w_Name,wg_OrderSchame_List[i].RISSHEMAPASS,[rfReplaceAll])
                    else
                      w_Record := '<TD><span class=dmy_gazou></span></TD>';
                  end;
                  //部位コメント
                  w_Name := '*部位ｺﾒﾝﾄ'+w_No+'*';
                  if Pos(w_Name, w_Record) > 0 then begin
                    w_Record := '<TD><span class=dmy_gazou></span></TD>';
                  end;
                end
                else
                begin
                  //部位名
                  w_Name := '*部位'+w_No+'*';
                  if Pos(w_Name, w_Record) > 0 then begin
                    w_Record := '<TD><span class=dmy_gazou></span></TD>';
                  end;
                  //シェーマ画像
                  w_Name := '*ｼｪｰﾏ画像'+w_No+'*';
                  if Pos(w_Name, w_Record) > 0 then begin
                    w_Record := '<TD><span class=dmy_gazou></span></TD>';
                  end;
                  //部位コメント
                  w_Name := '*部位ｺﾒﾝﾄ'+w_No+'*';
                  if Pos(w_Name, w_Record) > 0 then begin
                    w_Record := '<TD><span class=dmy_gazou></span></TD>';
                  end;
                end;
              end;
            end;
            // 読み込んだ行にﾃﾞｰﾀが存在する場合
            if w_HTML_Text = '' then
              w_HTML_Text := w_HTML_Text + w_Record
            else
              w_HTML_Text := w_HTML_Text + #13#10 + w_Record;
          end;
        finally
          CloseFile(TxtFile);
        end;

        //HTMLファイル作成
        try
          AssignFile(TxtFile, wg_OrderSchame_List[0].RISHTMLPASS);
          Rewrite(TxtFile);
        except
          on E:EInOutError do begin
            Result := False;
            arg_ErrMsg := wg_OrderSchame_List[0].RISHTMLPASS +'のアサインに失敗しました。'+E.Message;
            Exit;
          end;
        end;
        try
          try
            Writeln(TxtFile, w_HTML_Text);
          except
            on E:EInOutError do begin
              Result := False;
              arg_ErrMsg := wg_OrderSchame_List[0].RISHTMLPASS +'の書き込みに失敗しました。'+E.Message;
              Exit;
            end;
          END;
        finally
          Flush(TxtFile);
          CloseFile(TxtFile);
        end;
        Result := True;
      end;
    end;
    //正常終了処理
    arg_ErrMsg := '';
    //処理終了
    Exit;
  except
    on E: Exception do begin
      //エラー終了処理
      Result := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := 'HTMLファイルの作成に失敗しました。' + E.Message;
      //処理終了
      Exit;
    end;
  end;
end;

function  TDB_RisShema.func_UpDate_ExtendOrderMain(
    var arg_ErrMsg:string
    ):boolean;
var
  sqlExec:  String;
  iRslt:    Integer;
begin
  //戻り値
  Result := True;
  try
    with FQ_ALT do begin
      //SQL文字列作成
      sqlExec := '';
      sqlExec := sqlExec + 'UPDATE EXTENDORDERINFO';
      sqlExec := sqlExec + ' SET SHEMAURL = :PSHEMAURL';
      sqlExec := sqlExec + ' WHERE RIS_ID = :PRIS_ID';
      //SQL設定
      PrepareQuery(sqlExec);
      //パラメータ
      //結果
      SetParam('PSHEMAURL', wg_OrderSchame_List[0].RISHTMLPASS);
      //RIS_ID
      SetParam('PRIS_ID', wg_OrderSchame_List[0].RIS_ID);
      //SQL実行
      iRslt:= ExecSQL();
      if iRslt < 0 then begin
        //失敗
        Result := False;
        //切断
        wg_DBFlg := False;
        //
        Exit;
      end;
    end;
    //正常終了処理
    arg_ErrMsg := '';
    //処理終了
    Exit;
  except
    on E: Exception do begin
      //エラー終了処理
      Result := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := '拡張オーダ情報の登録に失敗しました。' + E.Message;
      //処理終了
      Exit;
    end;
  end;
end;

function TDB_RisShema.func_LogonExecute(Host, UserName, Passwd: string): DWord;
var
  NetRes : TNetResource;
  str: string;
begin
  FillChar(NetRes, SizeOf(NetRes), 0);
  NetRes.dwType := RESOURCETYPE_DISK;

  NetRes.lpRemoteName := PChar(Host);

  Result := WNetAddConnection2(NetRes, PChar(Passwd), PChar(UserName),
                                     0);
end;

// HostにはIPアドレスも指定できます。
function TDB_RisShema.func_LogoffExecute(Host: string): DWord;
var
  str: string;
begin
  Result := WNetCancelConnection2(PChar(Host), 0, true);
end;

function TDB_RisShema.func_Logon(argDrive: String; var argErrmsg: String):Boolean;
var
  WDWord: DWord;
  WILoop: Integer;
  WICount: Integer;
begin

  Result := True;

  WICount := g_LOGONRETRY;

  for WILoop := 0 to WICount - 1 do
  begin
    try

      Sleep(500);

      WDWord := func_LogonExecute(ExtractFileDrive(argDrive),g_LOGONUSER,g_LOGONPASS);

      if WDWord = NO_ERROR then
      begin
        argErrmsg := '成功';
        Result := True;
        Break;
      end
      else if WDWord = ERROR_ACCESS_DENIED then
      begin
        argErrmsg := 'ネットワーク資源へのアクセスが拒否されました。';
        Result := False;
      end
      else if WDWord = ERROR_ALREADY_ASSIGNED then
      begin
        argErrmsg := 'lpLocalName で指定したローカルデバイスは既にネットワーク資源に接続されています。';
        Result := False;
      end
      else if WDWord = ERROR_BAD_DEV_TYPE then
      begin
        argErrmsg := 'ローカルデバイスの種類とネットワーク資源の種類が一致しません。';
        Result := False;
      end
      else if WDWord = ERROR_BAD_DEVICE then
      begin
        argErrmsg := 'lpLocalName で指定した値が無効です。';
        Result := False;
      end
      else if WDWord = ERROR_BAD_NET_NAME then
      begin
        argErrmsg := 'lpRemoteName で指定した値を、どのネットワーク資源のプロバイダも受け付けません。資源の名前が無効か、指定した資源が見つかりません。';
        Result := False;
      end
      else if WDWord = ERROR_BAD_PROFILE then
      begin
        argErrmsg := 'ユーザープロファイルの形式が正しくありません。';
        Result := False;
      end
      else if WDWord = ERROR_BAD_PROVIDER then
      begin
        argErrmsg := 'lpProvider で指定した値がどのプロバイダとも一致しません。';
        Result := False;
      end
      else if WDWord = ERROR_BUSY then
      begin
        argErrmsg := 'ルーターまたはプロバイダがビジー（ おそらく初期化中）です。この関数をもう一度呼び出してください。';
        Result := False;
      end
      else if WDWord = ERROR_CANCELLED then
      begin
        argErrmsg := 'ネットワーク資源のプロバイダのいずれかでユーザーがダイアログボックスを使って接続操作を取り消したか、接続先の資源が接続操作を取り消しました。';
        Result := False;
      end
      else if WDWord = ERROR_CANNOT_OPEN_PROFILE then
      begin
        argErrmsg := '恒久的な接続を処理するためのユーザープロファイルを開くことができません。';
        Result := False;
      end
      else if WDWord = ERROR_DEVICE_ALREADY_REMEMBERED then
      begin
        argErrmsg := 'lpLocalName で指定したデバイスのエントリは既にユーザープロファイル内に存在します。';
        Result := False;
      end
      else if WDWord = ERROR_EXTENDED_ERROR then
      begin
        argErrmsg := 'ネットワーク固有のエラーが発生しました。';
        Result := False;
      end
      else if WDWord = ERROR_NO_NET_OR_BAD_PATH then
      begin
        argErrmsg := '指定したパスワードが無効です。';
        Result := False;
      end
      else if WDWord = ERROR_NO_NET_OR_BAD_PATH then
      begin
        argErrmsg := 'ネットワークコンポーネントが開始されていないか、指定した名前が利用できないために、操作を行えませんでした。';
        Result := False;
      end
      else if WDWord = ERROR_NO_NETWORK then
      begin
        argErrmsg := 'ネットワークに接続されていません。';
        Result := False;
      end
      else
      begin
        try
          Result := False;
          RaiseLastOSError;
        except
          on E: Exception do
          begin
            argErrmsg := e.Message;
            Continue;
          end;
        end;
      end;
    except
      on E: Exception do
      begin
        argErrmsg := e.Message;
        Result := False;
      end;
    end;
  end;


end;

function TDB_RisShema.func_Logout(argDrive: String; var argErrmsg: String):Boolean;
var
  WDWord: DWord;
  WILoop: Integer;
  WICount: Integer;
begin

  Result := True;

  WICount := g_LOGONRETRY;

  for WILoop := 0 to WICount - 1 do
  begin
    try
      Sleep(500);

      WDWord := func_LogoffExecute(ExtractFileDrive(argDrive));

      if WDWord = NO_ERROR then
      begin
        argErrmsg := '成功';
        Result := True;
        Break;
      end
      else if WDWord = ERROR_BAD_PROFILE then
      begin
        argErrmsg := 'ユーザープロファイルの形式が正しくありません。';
        Result := False;
      end
      else if WDWord = ERROR_CANNOT_OPEN_PROFILE then
      begin
        argErrmsg := '恒久的な接続を処理するためのユーザープロファイルを開くことができません。';
        Result := False;
      end
      else if WDWord = ERROR_DEVICE_IN_USE then
      begin
        argErrmsg := '指定したデバイスがアクティブなプロセスによって使用中のため、切断できません。';
        Result := False;
      end
      else if WDWord = ERROR_EXTENDED_ERROR then
      begin
        argErrmsg := 'ネットワーク固有のエラーが発生しました。';
        Result := False;
      end
      else if WDWord = ERROR_NOT_CONNECTED then
      begin
        argErrmsg := 'lpName パラメータで指定した名前がリダイレクトされているデバイスを表していないか、lpName で指定したデバイスにシステムが接続していません。';
        Result := False;
      end
      else if WDWord = ERROR_OPEN_FILES then
      begin
        argErrmsg := '開いているファイルがあり、fForce が FALSE です。';
        Result := False;
      end
      else
      begin
        try
          Result := False;
          RaiseLastOSError;
        except
          on E: Exception do
          begin
            argErrmsg := e.Message;
            Continue;
          end;
        end;
      end;
    except
      on E:Exception do
      begin
        Result := False;
        argErrmsg := e.Message;
      end;

    end;
  end;

end;

end.
