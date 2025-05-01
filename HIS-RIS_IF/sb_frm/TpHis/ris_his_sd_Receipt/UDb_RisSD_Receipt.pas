unit UDb_RisSD_Receipt;
(**
■機能説明
  HISへの送信サービス用のRisDBへのアクセス制御

■履歴
新規作成：2004.09.27：担当 増田 友
*)

interface

uses
//システム－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, IniFiles,
  ScktComp,SvcMgr, //Db, DBTables,
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Gval,
  HisMsgDef,
  HisMsgDef06_RCE,
  TcpSocket,
  Unit_Log, Unit_DB
  ;
type
  TDB_RisSD_Receipt = class    //RIS DB
    (*
    TQ_Order: TQuery;        //TensouOrderTable_転送オーダテーブル
    TQ_ExMainTable: TQuery;  //ExMainTable_実績メインテーブル
    TQ_Etc: TQuery;          //区分
    TQ_DateTime: TQuery;     //時間
    *)
  private
    { Private 宣言 }
  public
    { Public 宣言 }
    wg_SyoriKbn:String;  //処理区分格納
    wg_OffSet:Integer;   //オフセット
    (*
    DatabaseRis: TDatabase;    //RIS DB
    *)
    wg_DBFlg:Boolean;
    wg_KensaType :String; //検査種別
    wg_DataCount: Extended; //データカウンタ
    wg_Seq: String;       //データSEQ
    function  RisDBOpen(var arg_Flg    : Boolean;
                        var arg_ErrMsg : String;
                            arg_Svc    : TService
                        ): Boolean;
    procedure RisDBClose;
    function  func_GetOrder(var rec_count: Integer;var arg_ErrMsg: String): Boolean;
    function  func_MakeMsg(
                 var arg_Msg:TStringStream;
                 var arg_ErrMsg:string;
                 var arg_NullFlg:String
                 ):boolean;
    function  func_SaveMsg(
                 arg_Msg:TStringStream;
                 var arg_ErrMsg:string
                 ):boolean;
    function  func_CheckOrder(
                 var arg_ErrMsg,
                 arg_Flg,
                 arg_NullFlg:string
                 ):boolean;
    (*
    function  func_GetSysDate:string;
    *)
    function  func_SetOrderResult(
                 arg_Msg:TStringStream;
                 arg_SendDate:string;
                 arg_Result:string;
                 var arg_ErrMsg:string
                 ):boolean;
    function func_OrderMain(
                            var arg_PatientID,
                                arg_OrderNo,
                                arg_StartDate,
                                arg_StartTime,
                                arg_ErrMsg,
                                arg_NullFlg: String
                            ):Boolean;
    function func_ExMain(var arg_Tantou,
                             arg_ErrMsg,
                             arg_NullFlg:string):Boolean;
    function  func_DelOrder(
                 arg_Keep:integer;
                 var arg_ErrMsg:string
                 ):boolean;

  end;

const
  CST_ORDER_RES_OK  = 'OK';  //：送信成功
  CST_ORDER_RES_NG1 = 'NG1'; //：送信失敗 通信不可
  CST_ORDER_RES_NG2 = 'NG2'; //：送信失敗 電文NG
  CST_ORDER_RES_NG3 = 'NG3'; //：送信失敗 電文NG(リトライ中)
  CST_ORDER_RES_CL =  'CL';  //：送信キャンセル

var
  DB_RisSD_Receipt: TDB_RisSD_Receipt;

implementation


const
//エラー発生場所特定メッセージ
CST_DELERR_MSG = '保存期間を過ぎたレコードの削除中にエラーが起きました。';
CST_GETORDERERR_MSG = '未送信レコード取得中にエラーが起きました。';
CST_GETMAINERR_MSG = '電文作成中、オーダメインテーブル情報取得エラーが起きました。';
CST_TEN_HOZONERR_MSG = '電文保存中にエラーが起きました。';
CST_KENSACHKERR_MSG = '検査進捗チェック中にエラーが起きました。';
CST_KEKKAERR_MSG = '送信結果保存中にエラーが起きました。';
CST_JISSIHOZONERR_MSG = '実績操作履歴情報テーブル保存中にエラーが起きました。';
CST_GETEXMAINERR_MSG = '電文作成中、実績メインテーブル情報取得エラーが起きました。';

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
function TDB_RisSD_Receipt.RisDBOpen(var arg_Flg    : Boolean;
                                     var arg_ErrMsg : String;
                                         arg_Svc    : TService):Boolean;
var
  RetryCnt: integer;
begin
  //戻り値
  Result := True;

  //ログ作成
  if not Assigned(FLog) then begin
    FLog := T_FileLog.Create(g_DBLOG02_PATH,
                             g_DBLOG02_PREFIX,
                             g_DBLOG02_LOGGING,
                             g_DBLOG02_KEEPDAYS,
                             g_LogFileSize, //2018/08/30 ログファイル変更
                             nil);
  end;
  if not Assigned(FDebug) then begin
    FDebug := T_FileLog.Create(g_DBLOGDBG02_PATH,
                               g_DBLOGDBG02_PREFIX,
                               g_DBLOGDBG02_LOGGING,
                               g_DBLOGDBG02_KEEPDAYS,
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

          TQ_ExMainTable.Close;
          if TQ_ExMainTable.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_ExMainTable.DatabaseName := DatabaseRis.DatabaseName;

          TQ_Etc.Close;
          if TQ_Etc.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_Etc.DatabaseName := DatabaseRis.DatabaseName;

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
procedure TDB_RisSD_Receipt.RisDBClose;
begin
  wg_DBFlg := False;
  try
    FDB.DBDisConnect();
  except
  end;
  (*
  try
    TQ_Order.Close;
    TQ_ExMainTable.Close;
    TQ_Etc.Close;
    TQ_DateTime.Close;
    if DatabaseRis <> nil then
    begin
      DatabaseRis.Connected := False;
      sleep(100);
      DatabaseRis.Close;
      sleep(100);
      FreeAndNil(DatabaseRis);
      wg_DBFlg := False;
    end;
  except
    DatabaseRis.Connected := False;
    sleep(100);
    DatabaseRis.Close;
    sleep(100);
    FreeAndNil(DatabaseRis);
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
    1. 送信オーダテーブルから未送信レコードをオーダ送信日時の古い順に取得。
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD_Receipt.func_GetOrder(
    var rec_count: Integer;
    var arg_ErrMsg: String): Boolean;
var
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //戻り値
  Result    := True;
  rec_count := 0;
  try
    with FQ_SEL_ORD do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT ROWID, REQUESTID, REQUESTDATE, RIS_ID, REQUESTUSER,';
      sqlSelect := sqlSelect + ' REQUESTTERMINALID, REQUESTTYPE, ';
      sqlSelect := sqlSelect + ' MESSAGEID1, MESSAGEID2, TRANSFERSTATUS, TRANSFERDATE, ';
      sqlSelect := sqlSelect + ' TRANSFERRESULT';
      sqlSelect := sqlSelect + ' FROM TOHISINFO';
      sqlSelect := sqlSelect + ' WHERE TRANSFERSTATUS = ''00''';
      sqlSelect := sqlSelect + ' AND (REQUESTTYPE = ''' + CST_APPTYPE_RC01 + ''' OR REQUESTTYPE = ''' + CST_APPTYPE_RC99 + ''')';
      sqlSelect := sqlSelect + ' ORDER BY REQUESTDATE';
      PrepareQuery(sqlSelect);
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
    on E: Exception do
    begin
      //エラー終了処理
      Result := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_GETORDERERR_MSG + E.Message;
      //切断
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 :func_MakeMsg
  引数 :
    var arg_Msg:TStringStream His送信電文
    arg_ErrMsg:string エラー時：詳細原因 正常時：''
    var arg_NullFlg:String データなし：'1' 正常時：''
  復帰値：例外ない  True 正常 False 異常
  機能 :
    1. 送信オーダテーブルのカレントレコードよりHis送信電文を作成します。。
 *
-----------------------------------------------------------------------------
}
function  TDB_RisSD_Receipt.func_MakeMsg(
    var arg_Msg:TStringStream;
    var arg_ErrMsg:string;
    var arg_NullFlg:String
    ):boolean;
var
  ws_PatientID: String;
  ws_OrderNo: String;
  ws_StartDate: String;
  ws_StartTime: String;

  wd_ReceiptDate: TDateTime;
  ws_ReceiptDate: String;
  ws_ReceiptTime: String;
  ws_Tantou: String;
  WILoop: Integer;

  wkREQUESTTYPE:  String;
begin
  //戻り値
  Result:=True;
  wg_KensaType := '';
  try
    wkREQUESTTYPE := FQ_SEL_ORD.GetString('REQUESTTYPE');
    //受付・受付キャンセル電文の場合
    if (wkREQUESTTYPE = CST_APPTYPE_RC01) or
       (wkREQUESTTYPE = CST_APPTYPE_RC99) then
    begin
      //種別により電文に初期文字列を設定する
      proc_ClearStream(G_MSG_SYSTEM_C,G_MSGKIND_UKETUKE,arg_Msg);
      //電文のヘッダに種別ごとの固定文字列を設定
      proc_SetStreamHDDef(G_MSG_SYSTEM_C,G_MSGKIND_UKETUKE,arg_Msg);
      //受付の場合
      if wkREQUESTTYPE = CST_APPTYPE_RC01 then
      begin
        //処理区分：受付
        proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                             RECSYORIKBNNO, CST_ORDER_RECEIPT_0);
      end
      //受付キャンセルの場合
      else if wkREQUESTTYPE = CST_APPTYPE_RC99 then
      begin
        //処理区分：キャンセル
        proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                             RECSYORIKBNNO, CST_ORDER_RECEIPT_1);
      end;

      //オーダーメイン情報取得
      if not func_OrderMain(ws_PatientID,ws_OrderNo,ws_StartDate,ws_StartTime,
                            arg_ErrMsg,arg_NullFlg) then
      begin
        //エラー終了処理
        Result := False;
        //処理終了
        Exit;
      end;
      //データなしのため終了（エラー終了とは違う）
      if arg_NullFlg = '1' then begin
        //処理終了
        Exit;
      end;
      //実績メイン情報取得
      if not func_ExMain(ws_Tantou,arg_ErrMsg,arg_NullFlg) then
      begin
        //エラー終了処理
        Result := False;
        //処理終了
        Exit;
      end;
      //データなしのため終了（エラー終了とは違う）
      if arg_NullFlg = '1' then begin
        //処理終了
        Exit;
      end;
      {
      for WILoop := 0 to g_HIS_List.Count - 1 do
      begin
        if g_HIS_List.Strings[WILoop] = wg_KensaType then
        begin
          arg_ErrMsg := '検査種別=' + wg_KensaType;
          arg_NullFlg := '2';
          //処理終了
          Exit;
        end;
      end;
      }
      //患者番号設定(10バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg, RECPIDNO,
                           ws_PatientID);
      //オーダ番号設定(16バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                           RECORDERNO, ws_OrderNo);
      //開始日設定(8バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                           RECSTARTDATENO, ws_StartDate);
      //開始時間設定(6バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                           RECSTARTTIMENO, ws_StartTime);
      //受付日時
      wd_ReceiptDate := StrToDateTime(FQ_SEL_ORD.GetString('REQUESTDATE'));
      //受付日
      ws_ReceiptDate := FormatDateTime('YYYYMMDD', wd_ReceiptDate);
      //受付時刻
      ws_ReceiptTime := FormatDateTime('HHMM', wd_ReceiptDate);

      //受付日設定(8バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                           RECUKETUKEDATENO, ws_ReceiptDate);
      //受付時間設定(4バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                           RECUKETUKETIMENO, ws_ReceiptTime);
      //受付担当者設定(10バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                           RECUKETUKEUSERNO, ws_Tantou);
      //電文長設定(4バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_UKETUKE, arg_Msg,
                           COMMON1DENLENNO, func_LeftZero(COMMON1DENLENLEN,IntToStr(length(arg_Msg.DataString) - G_MSGSIZE_START)));
    end
    else
    begin
      //異常終了処理
      arg_ErrMsg := '処理区分が正しくありません。';
      //エラー終了処理
      Result := False;
      //処理終了
      Exit;
    end;
    //正常終了処理
    arg_ErrMsg := '';
    //処理終了
    Exit;
  except
    //エラー終了処理
    Result := False;
    //処理終了
    Exit;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 :func_SaveMsg
  引数 :
    arg_Msg:TStringStream His送信電文
    var arg_ErrMsg:string エラー時：詳細原因 正常時：''
  復帰値：例外ない  True 正常 False 異常
  機能 :
    1. 送信オーダテーブルのカレントレコードにHis送信電文を保存します。
 *
-----------------------------------------------------------------------------
}
function  TDB_RisSD_Receipt.func_SaveMsg(
                                             arg_Msg: TStringStream;
                                         var arg_ErrMsg: String
                                         ): Boolean;
var
  sqlExec:  String;
  iRslt:    Integer;
begin
  //戻り値
  Result := True;
  try
    //HIS送信電文保存SQL作成
    with FQ_ALT do begin
      //SQL文字列作成
      sqlExec := '';
      sqlExec := sqlExec + 'UPDATE TOHISINFO';
      sqlExec := sqlExec + ' SET TRANSFERTEXT = :PTRANSFERTEXT';
      sqlExec := sqlExec + ' WHERE ROWID = :PROWID';
      //SQL設定
      PrepareQuery(sqlExec);
      //パラメータ
      //電文
      SetParam('PTRANSFERTEXT', arg_Msg.DataString);
      //ROWID
      SetParam('PROWID', FQ_SEL_ORD.GetString('ROWID'));
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
    on E: Exception do
    begin
      //エラー終了処理
      Result := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_TEN_HOZONERR_MSG + E.Message;
      //切断
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
  end;
end;

{
-----------------------------------------------------------------------------
  名前 :func_CheckOrder
  引数 :
    arg_Msg:TStringStream His送信電文
    var arg_ErrMsg:string エラー時：詳細原因 正常時：''
    arg_Flg:String エラー時：'1' 正常時：'0'
    var arg_NullFlg:String データなし：'1' 正常時：''
  復帰値：例外ない  True 正しい検査進捗 False 正しくない検査進捗
  機能 :
    1. 送信オーダテーブルのカレントレコードの検査進捗をチェックする。
 *
-----------------------------------------------------------------------------
}
function  TDB_RisSD_Receipt.func_CheckOrder(
    var arg_ErrMsg,
        arg_Flg,
        arg_NullFlg:string
    ):boolean;
var
  w_iCount:   Integer;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  arg_Flg := '0';
  try
    //HIS電文送信前チェックSQL作成
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT STATUS';
      sqlSelect := sqlSelect + ' FROM EXMAINTABLE';
      sqlSelect := sqlSelect + ' WHERE RIS_ID = :PRIS_ID';
      PrepareQuery(sqlSelect);
      //パラメータ
      //RIS_ID
      SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
      //SQL実行
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        arg_Flg := '1';
        //例外エラー
        Result := False;
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
      w_iCount := iRslt;
      if w_iCount <> 0 then
      begin
        //受付電文の場合
        if FQ_SEL_ORD.GetString('REQUESTTYPE') = CST_APPTYPE_RC01 then
        begin
          //未受付以外の場合
          if StrToIntDef(GetString('STATUS'), 0) >= 10 then
          begin
            //戻り値
            Result := True;
            //正常終了処理
            arg_ErrMsg := '';
            //処理終了
            Exit;
          end
          //未受付の場合
          else
          begin
            //戻り値
            Result := False;
            //エラーあり
            arg_Flg := '1';
            //異常終了処理
            arg_ErrMsg := CST_KENSACHKERR_MSG + '検査進捗が受付以前です。' +
                          '{ステータス = ' + GetString('STATUS') +
                          '}';
            //処理終了
            Exit;
          end;
        end
        //
        else if FQ_SEL_ORD.GetString('REQUESTTYPE') = CST_APPTYPE_RC99 then
        begin
          //未受付の場合
          if StrToIntDef(GetString('STATUS'), 0) < 10 then
          begin
            //戻り値
            Result := True;
            //正常終了処理
            arg_ErrMsg := '';
            //処理終了
            Exit;
          end
          //未受付以外の場合
          else
          begin
            //戻り値
            Result := False;
            //エラーあり
            arg_Flg := '1';
            //異常終了処理
            arg_ErrMsg := CST_KENSACHKERR_MSG + '検査進捗が未受付以降です。';
            //処理終了
            Exit;
          end;
        end
        else
        begin
          //戻り値
          Result := False;
          //異常終了処理
          arg_ErrMsg := CST_KENSACHKERR_MSG + '種別が未受付・受付以外です。';
          //処理終了
          Exit;
        end;
      end
      else begin
        //データなしフラグ設定
        arg_NullFlg := '1';
        //異常終了処理
        arg_ErrMsg := '検査進捗チェック{実績メインデータがないので送信をキャンセルします。}';
        //戻り値
        Result := False;
      end;
    end;
  except
    on E: Exception do
    begin
      //エラー終了処理
      Result := False;
      arg_Flg := '1';
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_KENSACHKERR_MSG + E.Message;
      //切断
      wg_DBFlg := False;
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
function  TDB_RisSD_Receipt.func_GetSysDate:string;
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
    arg_Msg:TStringStream His送信電文
    arg_SendDate:string;  送信日時 'YYYY/MM/DD HH:MI:SS'
    arg_Result:string     結果
                          OK：送信成功
                          NG1：送信失敗 通信不可
                          NG2：送信失敗 電文NG
                          CL：送信キャンセル
                          以外：送信成功
    var arg_ErrMsg:string エラー時：詳細原因 正常時：''
  復帰値：例外ない
          True 正常 False 異常
  機能 :
    1. 送信オーダテーブルのカレントレコードに送信結果を登録します。
 *
-----------------------------------------------------------------------------
}
function  TDB_RisSD_Receipt.func_SetOrderResult(
    arg_Msg:TStringStream;
    arg_SendDate:string;
    arg_Result:string;
    var arg_ErrMsg:string
    ):boolean;
var
  sqlExec:          String;
  iRslt:            Integer;

  wkTRANSFERDATE:   String;
begin
  //戻り値
  Result := True;
  try
    with FQ_ALT do begin
      //SQL文字列作成
      sqlExec := '';
      sqlExec := sqlExec + 'UPDATE TOHISINFO';
      sqlExec := sqlExec + ' SET TRANSFERDATE = %s,';
      //sqlExec := sqlExec + ' SET TRANSFERDATE = TO_DATE(:PTRANSFERDATE, ''YYYY/MM/DD HH24:MI:SS''),';
      sqlExec := sqlExec + ' TRANSFERSTATUS = :PTRANSFERSTATUS,';
      sqlExec := sqlExec + ' TRANSFERRESULT = :PTRANSFERRESULT';
      sqlExec := sqlExec + ' WHERE ROWID = :PROWID';
      //TO_DATE
      wkTRANSFERDATE := 'TO_DATE(''%s'', ''YYYY/MM/DD HH24:MI:SS'')';
      //送信日付
      if Length(arg_SendDate) > 0 then begin
        wkTRANSFERDATE := Format(wkTRANSFERDATE, [arg_SendDate]);
      end
      else begin
        wkTRANSFERDATE := 'NULL';
      end;
      //SQL設定
      sqlExec := Format(sqlExec, [wkTRANSFERDATE]);
      PrepareQuery(sqlExec);
      //パラメータ
      //通信結果'OK'の場合
      if arg_Result = CST_ORDER_RES_OK then
      begin
        //送信フラグ
        SetParam('PTRANSFERSTATUS', CST_SOUSIN_FLG);
        //通信結果
        SetParam('PTRANSFERRESULT', CST_ORDER_RES_OK_NAME);
      end
      //通信結果'通信不可'の場合
      else if arg_Result = CST_ORDER_RES_NG1 then
      begin
        //送信フラグ
        SetParam('PTRANSFERSTATUS', '00');
        //通信結果
        SetParam('PTRANSFERRESULT', CST_ORDER_RES_NG1_NAME);
      end
      //通信結果'電文NG'の場合
      else if arg_Result = CST_ORDER_RES_NG2 then
      begin
        //送信フラグ
        SetParam('PTRANSFERSTATUS', CST_SOUSIN_FLG);
        //通信結果
        SetParam('PTRANSFERRESULT', CST_ORDER_RES_NG2_NAME);
      end
      //通信結果'電文NG'の場合(リトライ中)
      else if arg_Result = CST_ORDER_RES_NG3 then
      begin
        //送信フラグ
        SetParam('PTRANSFERSTATUS', '00');
        //通信結果
        SetParam('PTRANSFERRESULT', CST_ORDER_RES_NG3_NAME);
      end
      //通信結果'キャンセル'の場合
      else if arg_Result = CST_ORDER_RES_CL then
      begin
        //送信フラグ
        SetParam('PTRANSFERSTATUS', CST_SOUSIN_FLG);
        //通信結果
        SetParam('PTRANSFERRESULT', CST_ORDER_RES_CL_NAME);
      end
      //通信結果上記以外の場合
      else
      begin
        //送信フラグ
        SetParam('PTRANSFERSTATUS', CST_SOUSIN_FLG);
        //通信結果
        SetParam('PTRANSFERRESULT', CST_ORDER_RES_OK_NAME);
      end;
      //Where句
      //ROWID
      SetParam('PROWID', FQ_SEL_ORD.GetString('ROWID'));
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
    on E: Exception do
    begin
      //エラー終了処理
      Result := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_KEKKAERR_MSG + E.Message;
      //切断
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 :func_OrderMain
  引数 :
    var arg_PatientID: String 患者ID
        arg_OrderNo: String   オーダーNo
        arg_StartDate: String 開始日
        arg_StartTime: String 開始時間
        arg_ErrMsg: String    エラー時：詳細原因 正常時：''
        arg_NullFlg: String   データなし：'1' 正常時：''
  復帰値：例外ない True 正常 False 異常
  機能 :
    1. 送信レコードの患者ID、オーダーNo、開始日
    　 開始時間を取得します。
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD_Receipt.func_OrderMain(
                                          var arg_PatientID,
                                              arg_OrderNo,
                                              arg_StartDate,
                                              arg_StartTime,
                                              arg_ErrMsg,
                                              arg_NullFlg: String
                                         ):Boolean;
var
  w_iCount:   Integer;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //戻り値
  Result := True;
  try
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT KANJA_ID, ORDERNO, KENSA_DATE, KENSA_STARTTIME,KENSATYPE_ID';
      sqlSelect := sqlSelect + '  FROM ORDERMAINTABLE';
      sqlSelect := sqlSelect + ' WHERE RIS_ID = :PRIS_ID';
      PrepareQuery(sqlSelect);
      //パラメータ
      //RIS_ID
      SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
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
      w_iCount := iRslt;
      //データありの場合
      if w_iCount <> 0 then
      begin
        //患者ID必須チェック
        if GetString('KANJA_ID') = '' then
        begin
          //エラー終了処理
          Result := False;
          //エラー終了処理
          arg_ErrMsg := CST_GETMAINERR_MSG + '患者IDがありません。';
          //処理終了
          Exit;
        end
        else
          //患者ID取得
          arg_PatientID :=
                         func_RigthSpace(10,GetString('KANJA_ID'));
        //オーダ番号必須チェック
        if Trim(GetString('ORDERNO')) = '' then
        begin
          //エラー終了処理
          Result := False;
          //エラー終了処理
          arg_ErrMsg := CST_GETMAINERR_MSG + 'オーダ番号がありません。';
          //処理終了
          Exit;
        end
        else
          //オーダーNo取得
          arg_OrderNo :=
                    func_RigthSpace(16,Trim(GetString('ORDERNO')));

        //開始日必須チェック
        if Trim(GetString('KENSA_DATE')) = '' then
        begin
          //エラー終了処理
          Result := False;
          //エラー終了処理
          arg_ErrMsg := CST_GETMAINERR_MSG + '開始日がありません。';
          //処理終了
          Exit;
        end
        else
          //開始日取得
          arg_StartDate :=
                  func_RigthSpace(8,Trim(GetString('KENSA_DATE')));

        //開始時間必須チェック
        if Trim(GetString('KENSA_STARTTIME')) = '' then
        begin
          //エラー終了処理
          Result := False;
          //エラー終了処理
          arg_ErrMsg := CST_GETMAINERR_MSG + '開始時間がありません。';
          //処理終了
          Exit;
        end
        else if (Trim(GetString('KENSA_STARTTIME')) = CST_JISSITIME_NULL2) or
                (Trim(GetString('KENSA_STARTTIME')) = CST_JISSITIME_NULL3) then
        begin
          //開始時間取得
          arg_StartTime := '0000';
        end
        else
          //開始時間取得
          arg_StartTime :=
               Copy(func_LeftZero(6,Trim(GetString('KENSA_STARTTIME'))),1,4);
        wg_KensaType := GetString('KENSATYPE_ID');
      end
      //データなしの場合
      else
      begin
        //正常終了処理
        arg_ErrMsg := '';
        //データなしフラグの設定
        arg_NullFlg := '1';
        //処理終了
        Exit;
      end;
      //正常終了処理
      arg_ErrMsg := '';
      //処理終了
      Exit;
    end;
  except
    on E: Exception do
    begin
      //エラー終了処理
      Result := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_GETMAINERR_MSG + E.Message;
      //切断
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 :func_DelOrder
  引数 :
    arg_Keep:integer      保存期間 日
    var arg_ErrMsg:string エラー時：詳細原因 正常時：''
  復帰値：例外ない  True 正常 False 異常
  機能 :
    1. 送信オーダテーブルから送信済みかつ保存期間の過ぎたレコードを
    削除。
    2. Commitする。
 *
-----------------------------------------------------------------------------
}
function  TDB_RisSD_Receipt.func_DelOrder(
    arg_Keep:integer;
    var arg_ErrMsg:string
    ):boolean;
var
  iRslt:    Integer;
  sqlExec:  String;
  isCommit: Boolean;
begin
  //戻り値
  Result := True;
  iRslt := 0;
  isCommit := False;
  try
    //トランザクション開始
    FDB.StartTransaction;
    try
      with FQ_ALT do begin
        //SQL文字列作成
        sqlExec := '';
        sqlExec := sqlExec + 'DELETE FROM TOHISINFO';
        sqlExec := sqlExec + ' WHERE TRANSFERSTATUS = ''' + CST_SOUSIN_FLG + '''';
        sqlExec := sqlExec + ' AND REQUESTDATE < ( SYSDATE - ' + IntToStr(arg_Keep) + ')';
        sqlExec := sqlExec + ' AND (REQUESTTYPE = ''' + CST_APPTYPE_RC01 + ''' OR REQUESTTYPE = ''' + CST_APPTYPE_RC99 + ''')';
        //SQL設定
        PrepareQuery(sqlExec);
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
      //成功
      Result := True;
      isCommit := True;
    except
      on E: Exception do
      begin
        //エラー終了処理
        Result := False;
        //エラー状態メッセージ取得
        arg_ErrMsg := CST_DELERR_MSG + E.Message;
        //DB切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
    end;
  finally
    if isCommit = True then begin
      //コミット
      FDB.Commit;
    end
    else begin
      //ロールバック
      FDB.Rollback;
    end;
  end;
end;

function TDB_RisSD_Receipt.func_ExMain(var arg_Tantou,
                                           arg_ErrMsg,
                                           arg_NullFlg:string):Boolean;
var
  w_iCount:Integer;
var
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //戻り値
  Result := True;
  try
    //実績メイン情報取得SQL文作成
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT UKETUKE_TANTOU_ID';
      sqlSelect := sqlSelect + ' FROM EXMAINTABLE';
      sqlSelect := sqlSelect + ' WHERE RIS_ID = :PRIS_ID';
      PrepareQuery(sqlSelect);
      //パラメータ
      //RIS_ID
      SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
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
      w_iCount := iRslt;
      if w_iCount <> 0 then begin
        //受付担当者取得
        arg_Tantou := func_RigthSpace(RECUKETUKEUSERLEN,Trim(GetString('UKETUKE_TANTOU_ID')));
      end
      else begin
        //レコードなしフラグ設定
        arg_NullFlg := '1';
      end;
    end;
  except
    on E: Exception do begin
      arg_NullFlg := '1';
      //エラー終了処理
      Result := False;
      //切断
      wg_DBFlg := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_GETEXMAINERR_MSG + E.Message;
      //処理終了
      Exit;
    end;
  end;
end;

end.
