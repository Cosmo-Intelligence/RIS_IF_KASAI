unit UDb_RisSD;
(**
■機能説明
  HISへの送信サービス用のRisDBへのアクセス制御

■履歴
新規作成：2004.10.12：担当 増田 友
*)

interface

uses
//システム－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, IniFiles,
  ScktComp,SvcMgr, //Db, DBTables, 
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Gval,
  HisMsgDef,
  HisMsgDef02_JISSI,
  TcpSocket,
  Unit_Log, Unit_DB
  ;
type //薬剤情報格納構造体
  TYakuzai_Code = record
    RecKbn: String;
    KoumokuCd: String;
    Use: String;
    Bunkatu: String;
    Yobi: String;
  end;
type //コメント情報格納構造体
  TComment_Code = record
    RecKbn: String;
    KoumokuCd: String;
    Comment: String;
    Yobi: String;
  end;
type
  TGroup = record
    GroupNo: String;
    Account: String;
    ExKbn: String;
    Koumoku: String;
    TypeID: String;
    BuiCode: String;
    RoomCode: String;
    Operator: String;
    BuiCount: String;
    Portble: String;
    Meisai: String;
    Yakuzai: Array of TYakuzai_Code;
    Comment: Array of TComment_Code;
  end;

type
  TDB_RisSD = class
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
    wg_Kensa_Code:array of TGroup;
    wg_Memo: String;
    function  RisDBOpen(var arg_ErrMsg : String;
                            arg_Svc    : TService
                        ): Boolean;
    procedure RisDBClose;
    function  func_GetOrder(
                  var rec_count: Integer;
                  var arg_ErrMsg:string
                 ):boolean;
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
    function  func_SetOrderResult(
                 arg_Msg:TStringStream;
                 arg_SendDate:string;
                 arg_Result:string;
                 var arg_ErrMsg:string
                 ):boolean;
    function func_JouhouKbn(
                 var arg_ErrMsg:string;
                 var arg_NullFlg:String
                 ):String;
    function func_OrderMain(var arg_OrderNo,
                                arg_KensaDate,
                                arg_KensaTime,
                                arg_SystemKbn,
                                arg_SectionID,
                                arg_DrNo,
                                //arg_OrderSection,
                                arg_Dokuei,
                                arg_ErrMsg,
                                arg_NullFlg:string):Boolean;
    function func_KanjaMaster(
                 var arg_Code,
                 arg_SituCode,
                 arg_ErrMsg,
                 arg_NullFlg:string
                 ):Boolean;
    function func_ExMain(var arg_Patient,
                             arg_KensaType,
                             //arg_InOut,
                             arg_JisTanto,
                             arg_ErrMsg,
                             arg_NullFlg:string):Boolean;
    function func_ExtendOrderInfo(var arg_Kbn1,
                                      arg_Kbn2,
                                      arg_Sikyu,
                                      arg_ErrMsg,
                                      arg_NullFlg:string):Boolean;
    function func_ExtendExamInfo(var arg_kaikei,
                                     arg_ErrMsg,
                                     arg_NullFlg:string):Boolean;
    function func_Make_Msg_Kensa(
                     arg_kaikei: String;
                 var arg_TypeID:string;
                 var arg_ErrMsg:string
                 ):Boolean;

    function func_Get_OffSet(arg_No,arg_OffSet:Integer): Integer;
    {
    function func_ToHISInfo(var arg_Date,
                                arg_Time,
                                arg_ErrMsg,
                                arg_NullFlg:string):Boolean;
    }
    function  func_DelOrder(
                 arg_Keep:integer;
                 var arg_ErrMsg:string
                 ):boolean;
  end;

const
  CST_ORDER_RES_OK  = 'OK';  //：送信成功
  CST_ORDER_RES_NG1 = 'NG1'; //：送信失敗 通信不可
  CST_ORDER_RES_NG2 = 'NG2'; //：送信失敗 電文NG
  CST_ORDER_RES_NG3 = 'NG3'; //：送信失敗 電文NG
  CST_ORDER_RES_CL =  'CL';  //：送信キャンセル

var
  DB_RisSD: TDB_RisSD;

implementation


const
CST_PROG_ID='RisHisSD';
CST_PROG_NAME='HIS－受付・実績情報 送信処理';
//日付フォーマット文字列
CST_DATE_FORMAT='YYYY/MM/DD';
//送信済
CST_SOUSIN_FLG='01';
//未送信
CST_MISOUSIN_FLG='00';
//通信結果名称
CST_ORDER_RES_OK_NAME  = 'ＯＫ';       //：送信成功
CST_ORDER_RES_NG1_NAME = '送信不可';   //：送信失敗 通信不可
CST_ORDER_RES_NG2_NAME = '電文ＮＧ';   //：送信失敗 電文NG
CST_ORDER_RES_CL_NAME  = 'キャンセル'; //：送信キャンセル
//エラー発生場所特定メッセージ
CST_DELERR_MSG = '保存期間を過ぎたレコードの削除中にエラーが起きました。';
CST_GETORDERERR_MSG = '未送信レコード取得中にエラーが起きました。';
CST_GETTOHISERR_MSG = 'HIS送信情報取得中にエラーが起きました。';
CST_GETKBNERR_MSG = '電文作成中、処理区分取得エラーが起きました。';
CST_GETRIERR_MSG = '電文作成中、情報種別取得エラーが起きました。';
CST_GETMAINERR_MSG = '電文作成中、オーダメインテーブル情報取得エラーが起きました。';
CST_GETEXMAINERR_MSG = '電文作成中、実績メインテーブル情報取得エラーが起きました。';
CST_GETORDERSNERR_MSG = '電文作成中、オーダメインSNテーブル情報取得エラーが起きました。';
CST_GETORDERINFOERR_MSG = '電文作成中、オーダ情報テーブル情報取得エラーが起きました。';
CST_GETEXPATIENTERR_MSG = '電文作成中、実績患者テーブル情報取得エラーが起きました。';
CST_GETEXTENDORDERERR_MSG = '電文作成中、拡張オーダテーブル情報取得エラーが起きました。';
CST_GETEXTENDEXAMERR_MSG = '電文作成中、拡張実績テーブル情報取得エラーが起きました。';
CST_GETROOMERR_MSG = '電文作成中、病棟ID取得エラーが起きました。';
CST_GETCOMERR_MSG = '電文作成中、コメント情報取得エラーが起きました。';
CST_SYUGIERR_MSG = '電文作成中、処置情報設定エラーが起きました。';
CST_KENSAERR_MSG = '電文作成中、検査情報設定エラーが起きました。';
CST_TEN_HOZONERR_MSG = '送信オーダテーブル電文保存中にエラーが起きました。';
CST_KENSACHKERR_MSG = '検査進捗チェック中にエラーが起きました。';
CST_KEKKAERR_MSG = '送信オーダテーブル送信結果保存中にエラーが起きました。';
CST_JISSIHOZONERR_MSG = '実績メインテーブル送信日時保存中にエラーが起きました。';
CST_GETKANJAERR_MSG = '電文作成中、患者ID所得エラーが起きました。';
CST_INS = '01';
CST_CAN = '02';
CST_DEL = '03';
CST_UKETUKE   = '2';
CST_UKETUKE_C = '1';
CST_JISSISUMI = '3';

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
function TDB_RisSD.RisDBOpen(var arg_ErrMsg : String;
                                 arg_Svc    : TService):Boolean;
var
  RetryCnt: integer;
begin
  //戻り値
  Result := True;

  //ログ作成
  if not Assigned(FLog) then begin
    FLog := T_FileLog.Create(g_DBLOG03_PATH,
                             g_DBLOG03_PREFIX,
                             g_DBLOG03_LOGGING,
                             g_DBLOG03_KEEPDAYS,
                             g_LogFileSize, //2018/08/30 ログファイル変更
                             nil);
  end;
  if not Assigned(FDebug) then begin
    FDebug := T_FileLog.Create(g_DBLOGDBG03_PATH,
                               g_DBLOGDBG03_PREFIX,
                               g_DBLOGDBG03_LOGGING,
                               g_DBLOGDBG03_KEEPDAYS,
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
  if not Assigned(FQ_SEL_BUI) then begin
    FQ_SEL_BUI := T_Query.Create(FDB, FLog, FDebug);
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
  //DB接続がされていない場合
  if (not wg_DBFlg) or (not DatabaseRis.Connected) then
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
            wg_DBFlg := True;
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
        if DatabaseRis.Connected then begin
          //支配下のQeryに設定
          {
          TQ_Order.Close;
          if TQ_Order.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_Order.DatabaseName := DatabaseRis.DatabaseName;
          TQ_ExMainTable.Close;
          if TQ_ExMainTable.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_ExMainTable.DatabaseName := DatabaseRis.DatabaseName;
          }

          TQ_Etc.Close;
          if TQ_Etc.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_Etc.DatabaseName := DatabaseRis.DatabaseName;

          TQ_ExBui.Close;
          if TQ_ExBui.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_ExBui.DatabaseName := DatabaseRis.DatabaseName;

          TQ_ExSyugi.Close;
          if TQ_ExSyugi.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_ExSyugi.DatabaseName := DatabaseRis.DatabaseName;

          {
          TQ_ExFilm.Close;
          if TQ_ExFilm.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_ExFilm.DatabaseName := DatabaseRis.DatabaseName;

          TQ_ExMain.Close;
          if TQ_ExMain.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_ExMain.DatabaseName := DatabaseRis.DatabaseName;

          TQ_Kbn.Close;
          if TQ_Kbn.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_Kbn.DatabaseName := DatabaseRis.DatabaseName;
          TQ_DateTime.Close;
          if TQ_DateTime.DatabaseName <> DatabaseRis.DatabaseName then
            TQ_DateTime.DatabaseName := DatabaseRis.DatabaseName;
          }
          //エラーなし
          arg_ErrMsg := '';
        end;
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
          wg_DBFlg := False;
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
        wg_DBFlg := False;
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
procedure TDB_RisSD.RisDBClose;
begin
  wg_DBFlg := False;
  try
    FDB.DBDisConnect();
  except
  end;
  (*
  try
    //TQ_Order.Close;
    //TQ_ExMainTable.Close;
    //TQ_Etc.Close;
    //TQ_ExBui.Close;
    //TQ_ExSyugi.Close;
    //TQ_ExFilm.Close;
    //TQ_ExMain.Close;
    //TQ_Kbn.Close;
    //TQ_DateTime.Close;
    if DatabaseRis <> nil then begin
      FreeAndNil(DatabaseRis);
      wg_DBFlg := False;
    end;
  except
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
function  TDB_RisSD.func_GetOrder(
    var rec_count: Integer;
    var arg_ErrMsg:string
    ):boolean;
var
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //戻り値
  Result := True;
  rec_count := 0;
  try
    with FQ_SEL_ORD do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT';
      sqlSelect := sqlSelect + ' HIS.ROWID';
      sqlSelect := sqlSelect + ',HIS.REQUESTID';
      sqlSelect := sqlSelect + ',TO_CHAR(HIS.REQUESTDATE, ''YYYY/MM/DD HH24:MI:SS'') AS REQUESTDATE';
      sqlSelect := sqlSelect + ',HIS.RIS_ID';
      sqlSelect := sqlSelect + ',HIS.REQUESTUSER';
      sqlSelect := sqlSelect + ',HIS.REQUESTTERMINALID';
      sqlSelect := sqlSelect + ',HIS.REQUESTTYPE';
      sqlSelect := sqlSelect + ',HIS.MESSAGEID1';
      sqlSelect := sqlSelect + ',HIS.MESSAGEID2';
      sqlSelect := sqlSelect + ',HIS.TRANSFERSTATUS';
      sqlSelect := sqlSelect + ',HIS.TRANSFERDATE';
      sqlSelect := sqlSelect + ',HIS.TRANSFERRESULT';
      sqlSelect := sqlSelect + ',TO_CHAR(EX.EXAMENDDATE, ''YYYY/MM/DD HH24:MI:SS'') AS EXAMENDDATE';
      sqlSelect := sqlSelect + ' FROM TOHISINFO HIS, EXMAINTABLE EX';
      sqlSelect := sqlSelect + ' WHERE HIS.TRANSFERSTATUS = ''00''';
      sqlSelect := sqlSelect + ' AND (HIS.REQUESTTYPE = ''' + CST_APPTYPE_OP01 + ''' OR HIS.REQUESTTYPE = ''' + CST_APPTYPE_OP99 + ''' OR HIS.REQUESTTYPE = ''' + CST_APPTYPE_OP02 + ''')';
      sqlSelect := sqlSelect + ' AND HIS.RIS_ID = EX.RIS_ID(+)';
      sqlSelect := sqlSelect + ' ORDER BY REQUESTDATE';
      (*
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT';
      sqlSelect := sqlSelect + ' ROWID';
      sqlSelect := sqlSelect + ',REQUESTID';
      sqlSelect := sqlSelect + ',TO_CHAR(REQUESTDATE, ''YYYY/MM/DD HH24:MI:SS'') AS REQUESTDATE';
      sqlSelect := sqlSelect + ',RIS_ID';
      sqlSelect := sqlSelect + ',REQUESTUSER';
      sqlSelect := sqlSelect + ',REQUESTTERMINALID';
      sqlSelect := sqlSelect + ',REQUESTTYPE';
      sqlSelect := sqlSelect + ',MESSAGEID1';
      sqlSelect := sqlSelect + ',MESSAGEID2';
      sqlSelect := sqlSelect + ',TRANSFERSTATUS';
      sqlSelect := sqlSelect + ',TRANSFERDATE';
      sqlSelect := sqlSelect + ',TRANSFERRESULT';
      sqlSelect := sqlSelect + ' FROM TOHISINFO';
      sqlSelect := sqlSelect + ' WHERE TRANSFERSTATUS = ''00''';
      sqlSelect := sqlSelect + ' AND (REQUESTTYPE = ''' + CST_APPTYPE_OP01 + ''' OR REQUESTTYPE = ''' + CST_APPTYPE_OP99 + ''' OR REQUESTTYPE = ''' + CST_APPTYPE_OP02 + ''')';
      sqlSelect := sqlSelect + ' ORDER BY REQUESTDATE';
      *)
      PrepareQuery(sqlSelect);
      //SQL実行
      iRslt := OpenQuery();
      if iRslt < 0 then begin
        //例外エラー
        Result := False;
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
      rec_count := iRslt;
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
function  TDB_RisSD.func_MakeMsg(
    var arg_Msg:TStringStream;
    var arg_ErrMsg:string;
    var arg_NullFlg:String
    ):boolean;
var
  w_SysD:TDateTime;
  w_sysdate,w_systime:String;
  w_offset:integer;
  w_size  :integer;
  w_StremField : TStreamField;

  ws_MachineName: String;
  ws_OrderNo: String;
  ws_StartDate: String;
  ws_StartTime: String;
  ws_OrderKbn: String;
  ws_Section: String;
  ws_DrNo: String;
  ws_OrderSection: String;
  ws_PatientID: String;
  ws_Kensatype: String;
  ws_InOut: String;
  ws_ExTanto: String;
  wd_ExDate: TDateTime;
  ws_ExDate: String;
  ws_ExTime: String;
  ws_Byouto: String;
  ws_Byousitu: String;
  ws_Kbn1: String;
  ws_Kbn2: String;
  ws_Sikyu: String;
  ws_Kbn4: String;
  ws_Kbn5: String;
  ws_Hoken1: String;
  ws_Hoken2: String;
  ws_Hoken3: String;
  ws_IraiDate: String;
  ws_Kaikei: String;
  wi_BuiLoop: Integer;
  wi_YLoop: Integer;
  wi_FLoop: Integer;
  wi_SLoop: Integer;
  wi_CLoop: Integer;
  WILoop: Integer;

  wkREQUESTTYPE:  String;
begin
  //戻り値
  Result:=True;
  wg_KensaType := '';
  try
    //実施電文の場合
    wkREQUESTTYPE := FQ_SEL_ORD.GetString('REQUESTTYPE');
    if (wkREQUESTTYPE = CST_APPTYPE_OP01) or
       (wkREQUESTTYPE = CST_APPTYPE_OP02) or
       (wkREQUESTTYPE = CST_APPTYPE_OP99) then
    begin
      //種別により電文に初期文字列を設定する
      proc_ClearStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg);
      //電文のヘッダに種別ごとの固定文字列を設定
      proc_SetStreamHDDef(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg);
      //システム日時を取得し電文に設定する
      //システム日付取得
      w_SysD := FQ_SEL.GetSysDate;
      //日付変換(MMDD)
      w_sysdate := FormatDateTime('mmdd', w_SysD);
      //オーダーメイン情報取得
      if not func_OrderMain(ws_OrderNo,ws_StartDate,ws_StartTime,
                            ws_OrderKbn,ws_Section,ws_DrNo,ws_Kbn5,
                                              arg_ErrMsg,arg_NullFlg) then begin
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
      //実績情報取得
      if not func_ExMain(ws_PatientID,ws_Kensatype,ws_ExTanto,arg_ErrMsg,arg_NullFlg) then begin
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
      //実績患者情報取得
      if not func_ExKanja(ws_Byouto,ws_Byousitu,arg_ErrMsg,arg_NullFlg) then begin
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
      }
      //拡張オーダ情報取得
      if not func_ExtendOrderInfo(ws_Kbn1,ws_Kbn2,ws_Sikyu,
                                              arg_ErrMsg,arg_NullFlg) then begin
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
      //拡張実績情報取得
      if not func_ExtendExamInfo(ws_Kaikei,arg_ErrMsg,arg_NullFlg) then begin
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
      //拡張実績情報取得
      if not func_ToHISInfo(ws_ExDate,ws_ExTime,arg_ErrMsg,arg_NullFlg) then begin
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
      }
      //入院の場合
      if ws_InOut = CST_HIS_NYUGAIKBN_N then begin
        //病棟または病室ＩＤがない場合
        if (ws_Byouto = '') or (ws_Byousitu = '') then begin
          //エラー状態メッセージ取得
          arg_ErrMsg := CST_GETROOMERR_MSG + '「病棟ID、病室IDがありません。」';
          //エラー終了処理
          Result := False;
          //処理終了
          Exit;
        end;
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
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIPIDNO,
                           ws_PatientID);
      //オーダ番号設定(16バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIORDERNO,
                           ws_OrderNo);
      //開始日設定(8バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSISTARTDATENO,
                           ws_StartDate);
      //開始時刻設定(4バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSISTARTTIMENO,
                           ws_StartTime);
      //実施日時
      wd_ExDate := StrToDateTime(FQ_SEL_ORD.GetString('EXAMENDDATE'));
      //wd_ExDate := StrToDateTime(FQ_SEL_ORD.GetString('REQUESTDATE'));
      //実施日
      ws_ExDate := FormatDateTime('YYYYMMDD', wd_ExDate);
      //実施時刻
      ws_ExTime := FormatDateTime('HHMM', wd_ExDate);

      //実施日設定(8バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_JISSI, arg_Msg,
                           JISSIOPERATIONDATENO, ws_ExDate);
      //実施時刻設定(4バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_JISSI, arg_Msg,
                           JISSIOPERATIONTIMENO, ws_ExTime);
      //実施者コード設定(10バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_JISSI, arg_Msg,
                           JISSIJISSICODENO, ws_ExTanto);
      //オーダ区分設定(1バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIORDERKBNNO,
                           ws_OrderKbn);
      //依頼科設定(2バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSISECTIONCODENO,
                           ws_Section);
      //依頼医コード設定(10バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIDRNO,
                           ws_DrNo);
      //区分1設定(1バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIKINKYUKBNNO,
                           ws_Sikyu);
      //区分2設定(1バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSISIKYUKBNNO,
                           ws_Kbn1);
      //区分3設定(1バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIGENZOKBNNO,
                           ws_Kbn2);
      //区分4設定(1バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIYOYAKUKBNNO,
                           ws_Kbn5);
      //読影済フラグ設定(1バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIDOKUEIKBNNO,
                           '0');

      //検査部位情報設定
      if not func_Make_Msg_Kensa(ws_Kaikei,ws_Kensatype,arg_ErrMsg) then begin
        //エラー終了処理
        Result := False;
        //処理終了
        Exit;
      end;

      //グループ数設定(2バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIGROUPCOUNTNO,
           func_LeftZero(JISSIGROUPCOUNTLEN,IntToStr(Length(wg_Kensa_Code))));


      for wi_BuiLoop := 0 to Length(wg_Kensa_Code) - 1 do
      begin
        if wi_BuiLoop = 0 then
        begin
          //指定電文項目の情報取得
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIGROUPCOUNTNO);
          //オフセット
          w_offset := w_StremField.offset;
          //サイズ
          w_size   := w_StremField.size;
          //現在のオフセット位置取得
          wg_OffSet := w_offset + w_size;
        end
        else
        begin
          //指定電文項目の情報取得
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIGROUPCOUNTNO);
          //サイズ
          w_size   := w_StremField.size;
          //現在のオフセット位置取得
          wg_OffSet := wg_OffSet + w_size;
        end;

        //グループ番号設定(3バイト)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIGROUPNO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].GroupNo);
        //指定電文項目の情報取得
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIGROUPNO);
        //サイズ
        w_size   := w_StremField.size;
        //現在のオフセット位置取得
        wg_OffSet := wg_OffSet + w_size;
        //会計区分設定(1バイト)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIKAIKEIKBNNO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Account);
        //指定電文項目の情報取得
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIKAIKEIKBNNO);
        //サイズ
        w_size   := w_StremField.size;
        //現在のオフセット位置取得
        wg_OffSet := wg_OffSet + w_size;
        //実施区分設定(1バイト)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIJISSIKBNNO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].ExKbn);
        //指定電文項目の情報取得
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIJISSIKBNNO);
        //サイズ
        w_size   := w_StremField.size;
        //現在のオフセット位置取得
        wg_OffSet := wg_OffSet + w_size;
        //項目コード設定(6バイト)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIKMKCODENO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Koumoku);
        //指定電文項目の情報取得
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIKMKCODENO);
        //サイズ
        w_size   := w_StremField.size;
        //現在のオフセット位置取得
        wg_OffSet := wg_OffSet + w_size;
        //検査回数設定(4バイト)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIKENSACOUNTNO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].BuiCount);
        //指定電文項目の情報取得
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIKENSACOUNTNO);
        //サイズ
        w_size   := w_StremField.size;
        //現在のオフセット位置取得
        wg_OffSet := wg_OffSet + w_size;
        //撮影種コード設定(6バイト)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIBUISATUEICODENO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].TypeID);
        //指定電文項目の情報取得
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIBUISATUEICODENO);
        //サイズ
        w_size   := w_StremField.size;
        //現在のオフセット位置取得
        wg_OffSet := wg_OffSet + w_size;
        //部位コード設定(6バイト)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIBUICODENO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].BuiCode);
        //指定電文項目の情報取得
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIBUICODENO);
        //サイズ
        w_size   := w_StremField.size;
        //現在のオフセット位置取得
        wg_OffSet := wg_OffSet + w_size;
        //検査室コード設定(6バイト)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIKENSAROOMCODENO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].RoomCode);
        //指定電文項目の情報取得
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIKENSAROOMCODENO);
        //サイズ
        w_size   := w_StremField.size;
        //現在のオフセット位置取得
        wg_OffSet := wg_OffSet + w_size;
        //ポータブル設定(1バイト)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIPORTABLENO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Portble);
        //指定電文項目の情報取得
        w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIPORTABLENO);
        //サイズ
        w_size   := w_StremField.size;
        //現在のオフセット位置取得
        wg_OffSet := wg_OffSet + w_size;
        //明細数設定(2バイト)
        proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIMEISAICOUNTNO,
                                   wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Meisai);
        //明細数が最大を超えた場合
        if StrToIntDef(Trim(wg_Kensa_Code[wi_BuiLoop].Meisai),0) > CST_MEISAI_MAX then begin
          //エラー状態メッセージ取得
          arg_ErrMsg := CST_KENSAERR_MSG + '「明細数が最大値を超えています。」';
          //エラー終了処理
          Result := False;
          //処理終了
          Exit;
        end;
        //薬剤設定
        for wi_YLoop := 0 to Length(wg_Kensa_Code[wi_BuiLoop].Yakuzai) - 1 do
        begin
          //指定電文項目の情報取得
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIMEISAICOUNTNO);
          //サイズ
          w_size   := w_StremField.size;
          //現在のオフセット位置取得
          wg_OffSet := wg_OffSet + w_size;
          //レコード区分設定(2バイト)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIYRECORDKBNNO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Yakuzai[wi_YLoop].RecKbn);
          //指定電文項目の情報取得
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIYRECORDKBNNO);
          //サイズ
          w_size   := w_StremField.size;
          //現在のオフセット位置取得
          wg_OffSet := wg_OffSet + w_size;
          //項目コード設定(6バイト)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIYKMKCODENO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Yakuzai[wi_YLoop].KoumokuCd);
          //指定電文項目の情報取得
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIYKMKCODENO);
          //サイズ
          w_size   := w_StremField.size;
          //現在のオフセット位置取得
          wg_OffSet := wg_OffSet + w_size;
          //オーダ使用量設定(9バイト)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIYORDERUSENO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Yakuzai[wi_YLoop].Use);
          //指定電文項目の情報取得
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIYORDERUSENO);
          //サイズ
          w_size   := w_StremField.size;
          //現在のオフセット位置取得
          wg_OffSet := wg_OffSet + w_size;
          //分割数設定(2バイト)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIYBUNKATUNO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Yakuzai[wi_YLoop].Bunkatu);
          //指定電文項目の情報取得
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIYBUNKATUNO);
          //サイズ
          w_size   := w_StremField.size;
          //現在のオフセット位置取得
          wg_OffSet := wg_OffSet + w_size;
          //予備設定(45バイト)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSIYYOBINO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Yakuzai[wi_YLoop].Yobi);
          //指定電文項目の情報取得
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIYYOBINO);
          //サイズ
          w_size   := w_StremField.size;
          //現在のオフセット位置取得
          wg_OffSet := wg_OffSet + w_size;
        end;
        //コメント設定
        for wi_CLoop := 0 to Length(wg_Kensa_Code[wi_BuiLoop].Comment) - 1 do
        begin
          //指定電文項目の情報取得
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSIMEISAICOUNTNO);
          //サイズ
          w_size   := w_StremField.size;
          //現在のオフセット位置取得
          wg_OffSet := wg_OffSet + w_size;
          //レコード区分設定(2バイト)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSICRECORDKBNNO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Comment[wi_CLoop].RecKbn);
          //指定電文項目の情報取得
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSICRECORDKBNNO);
          //サイズ
          w_size   := w_StremField.size;
          //現在のオフセット位置取得
          wg_OffSet := wg_OffSet + w_size;
          //項目コード設定(6バイト)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSICKMKCODENO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Comment[wi_CLoop].KoumokuCd);
          //指定電文項目の情報取得
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSICKMKCODENO);
          //サイズ
          w_size   := w_StremField.size;
          //現在のオフセット位置取得
          wg_OffSet := wg_OffSet + w_size;
          //コメント設定(60バイト)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSICCOMNO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Comment[wi_CLoop].Comment);
          //指定電文項目の情報取得
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSICCOMNO);
          //サイズ
          w_size   := w_StremField.size;
          //現在のオフセット位置取得
          wg_OffSet := wg_OffSet + w_size;
          //予備設定(11バイト)
          proc_SetStringStream2(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,JISSICYOBINO,
                                     wg_OffSet,wg_Kensa_Code[wi_BuiLoop].Comment[wi_CLoop].Yobi);
          //指定電文項目の情報取得
          w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,JISSICYOBINO);
          //サイズ
          w_size   := w_StremField.size;
          //現在のオフセット位置取得
          wg_OffSet := wg_OffSet + w_size;
        end;
      end;
      //電文長設定(6バイト)
      proc_SetStringStream(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_Msg,COMMON1DENLENNO,
                           func_LeftZero(COMMON1DENLENLEN, IntToStr(Length(arg_Msg.DataString) - G_MSGSIZE_START)));
      //構造体初期化
      SetLength(wg_Kensa_Code,0);
    end
    else begin
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
function  TDB_RisSD.func_SaveMsg(
    arg_Msg:TStringStream;
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
      //正常終了処理
      arg_ErrMsg := '';
      //処理終了
      Exit;
    end;
    //成功
    Result := True;
  except
    on E: Exception do begin
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
function  TDB_RisSD.func_CheckOrder(
    var arg_ErrMsg,
        arg_Flg,
        arg_NullFlg:string
    ):boolean;
var
  w_iCount:       Integer;
  wkREQUESTTYPE:  String;
  sqlSelect:      String;
  iRslt:          Integer;
begin
  //戻り値
  Result := False;
  arg_Flg := '0';
  try
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
        //例外エラー
        Result := False;
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
      w_iCount := iRslt;
      if w_iCount <> 0 then begin
        //実施電文の場合
        wkREQUESTTYPE := FQ_SEL_ORD.GetString('REQUESTTYPE');
        if (wkREQUESTTYPE = CST_APPTYPE_OP01) or
           (wkREQUESTTYPE = CST_APPTYPE_OP02) then
        begin
          //検査済の場合
          if (StrToIntDef(GetString('STATUS'), 0) = 90) then begin
            //戻り値
            Result := True;
            //正常終了処理
            arg_ErrMsg := '';
            //処理終了
            Exit;
          end
          //検査済以外の場合
          else begin
            //戻り値
            Result := False;
            arg_Flg := '1';
            //異常終了処理
            arg_ErrMsg := CST_KENSACHKERR_MSG + '検査進捗が検査済以外です。';
            //処理終了
            Exit;
          end;
        end
        //検査中止の場合
        else if (wkREQUESTTYPE = CST_APPTYPE_OP99) then
        begin
          //検査中止の場合
          if (StrToIntDef(GetString('STATUS'), 0) = 91) then begin
            //戻り値
            Result := True;
            //正常終了処理
            arg_ErrMsg := '';
            //処理終了
            Exit;
          end
          //検査済以外の場合
          else begin
            //戻り値
            Result := False;
            arg_Flg := '1';
            //異常終了処理
            arg_ErrMsg := CST_KENSACHKERR_MSG + '検査進捗が中止以外です。';
            //処理終了
            Exit;
          end;
        end;
      end
      else begin
        //データなしフラグ設定
        arg_NullFlg := '1';
        //異常終了処理
        arg_ErrMsg := '検査進捗チェック{実績データがないので送信をキャンセルします。}';
        //戻り値
        Result := False;
      end;
    end;
  except
    on E: Exception do begin
      //エラー終了処理
      Result := False;
      arg_Flg := '1';
      //切断
      wg_DBFlg := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_KENSACHKERR_MSG + E.Message;
      //処理終了
      Exit;
    end;
  end;
end;
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
function  TDB_RisSD.func_SetOrderResult(
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
        SetParam('PTRANSFERSTATUS', CST_MISOUSIN_FLG);
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
      //通信結果'電文NG'の場合
      else if arg_Result = CST_ORDER_RES_NG3 then
      begin
        //送信フラグ
        SetParam('PTRANSFERSTATUS', CST_MISOUSIN_FLG);
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
  名前 :func_JouhouKbn
  引数 :
    var arg_ErrMsg:string  エラー時：詳細原因 正常時：''
    var arg_NullFlg:String データなし：'1' 正常時：''
  復帰値：例外ない '01','02' 正常 '' 異常
  機能 :
    1. 送信レコードの情報区分を取得します。
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_JouhouKbn(var arg_ErrMsg:string;var arg_NullFlg:String):String;
var
  w_Kbn:String;
  w_Kaikei:String;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  w_Kbn := '02';
  try
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT JISSEKIKAIKEI_FLG';
      sqlSelect := sqlSelect + ' FROM EXMAINTABLE';
      sqlSelect := sqlSelect + ' WHERE RIS_ID = :PRIS_ID';
      PrepareQuery(sqlSelect);
      //パラメータ
      //RIS_ID
      SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
      //SQL実行
      iRslt:= OpenQuery();
      if iRslt < 0 then begin
        //例外エラー
        Result := '';
        //切断
        wg_DBFlg := False;
        //処理終了
        Exit;
      end;
      if Eof = False then begin
        //会計フラグ取得
        w_Kaikei := GetString('JISSEKIKAIKEI_FLG');
        //会計フラグが''以外の場合
        if w_Kaikei <> '' then begin
          //会計送信なしの場合
          if w_Kaikei = GPCST_KAIKEI_0 then begin
            //実施通知
            w_Kbn := '02';
          end
          //会計送信ありの場合
          else if w_Kaikei = GPCST_KAIKEI_1 then begin
            //会計送信
            w_Kbn := '01';
          end;
        end;
      end;
      //正常終了処理
      arg_ErrMsg := '';
      //エラー終了処理
      Result := w_Kbn;
      //処理終了
      Exit;
    end;
  except
    on E: Exception do begin
      //エラー終了処理
      Result := '';
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_GETRIERR_MSG + E.Message;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 :func_OrderMain
  引数 :
    var arg_OrderNo:string       オーダ番号
        arg_KensaDate:string     検査開始日
        arg_KensaTime:string     検査開始時間
        arg_SystemKbn:string     発生源区分
        arg_SectionID:string     依頼科
        arg_DrNo:string          依頼医利用者番号
        arg_OrderSection:string  依頼部署ID
        arg_Dokuei:string        読影フラグ
        arg_ErrMsg:string        エラー時：詳細原因 正常時：''
        arg_NullFlg:String       データなし：'1' 正常時：''
  復帰値：例外ない True 正常 False 異常
  機能 :
    1. 送信レコードのオーダメイン情報を取得します。
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_OrderMain(var arg_OrderNo,
                                      arg_KensaDate,
                                      arg_KensaTime,
                                      arg_SystemKbn,
                                      arg_SectionID,
                                      arg_DrNo,
                                      //arg_OrderSection,
                                      arg_Dokuei,
                                      arg_ErrMsg,
                                      arg_NullFlg:string):Boolean;
var
  w_iCount:Integer;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //戻り値
  Result := True;
  try
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT ORDERNO, KENSA_DATE, KENSA_STARTTIME, SYSTEMKBN,';
      sqlSelect := sqlSelect + '       IRAI_SECTION_ID, IRAI_DOCTOR_NO, ORDER_SECTION_ID, DOKUEI_FLG';
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
      if w_iCount <> 0 then begin
        //オーダ番号必須チェック
        if Trim(GetString('ORDERNO')) = '' then begin
          //エラー終了処理
          Result := False;
          //エラー終了処理
          arg_ErrMsg := CST_GETMAINERR_MSG + 'オーダ番号がありません。';
          //処理終了
          Exit;
        end
        else
          //オーダーNo取得
          arg_OrderNo := func_RigthSpace(JISSIORDERLEN,Trim(GetString('ORDERNO')));
        //予定検査日必須チェック
        if GetString('KENSA_DATE') = '' then begin
          //エラー終了処理
          Result := False;
          //エラー終了処理
          arg_ErrMsg := CST_GETMAINERR_MSG + '予定検査日がありません。';
          //処理終了
          Exit;
        end
        else
          //予定検査日取得
          arg_KensaDate := func_RigthSpace(JISSISTARTDATELEN,GetString('KENSA_DATE'));
        //予定検査時刻必須チェック
        if GetString('KENSA_STARTTIME') = '' then begin
          //エラー終了処理
          Result := False;
          //エラー終了処理
          arg_ErrMsg := CST_GETMAINERR_MSG + '予定検査時刻がありません。';
          //処理終了
          Exit;
        end
        else begin
          if (GetString('KENSA_STARTTIME') = CST_JISSITIME_NULL2) or
             (GetString('KENSA_STARTTIME') = CST_JISSITIME_NULL3) then
            //予定検査時刻取得
            arg_KensaTime := CST_JISSITIME_NULL
          else
            //予定検査時刻取得
            arg_KensaTime := func_LeftZero(JISSISTARTTIMELEN,func_LeftZero(6, GetString('KENSA_STARTTIME')));
        end;
        //発生源区分必須チェック
        if GetString('SYSTEMKBN') = '' then begin
          //エラー終了処理
          Result := False;
          //エラー終了処理
          arg_ErrMsg := CST_GETMAINERR_MSG + '発生源区分がありません。';
          //処理終了
          Exit;
        end
        else
          //発生源区分取得
          arg_SystemKbn := func_RigthSpace(JISSIORDERKBNLEN,GetString('SYSTEMKBN'));
          //依頼科取得
          arg_SectionID := func_RigthSpace(JISSISECTIONCODELEN,GetString('IRAI_SECTION_ID'));
          //依頼医利用者番号取得
          arg_DrNo := func_RigthSpace(JISSIDRLEN,GetString('IRAI_DOCTOR_NO'));
        //読影取得
        arg_Dokuei := func_RigthSpace(JISSIDOKUEIKBNLEN,GetString('DOKUEI_FLG'));
      end
      //データなしの場合
      else begin
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
    on E: Exception do begin
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
  名前 :func_KanjaMaster
  引数 :
    var arg_Code:string     病棟コード
        arg_SituCode:string 病室コード
        arg_ErrMsg:string   エラー時：詳細原因 正常時：''
        arg_NullFlg:String  データなし：'1' 正常時：''
  復帰値：例外ない True 正常 False 異常
  機能 :
    1. 送信レコードの病棟コードを取得します。
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_KanjaMaster(var arg_Code,
                                        arg_SituCode,
                                        arg_ErrMsg,
                                        arg_NullFlg:string):Boolean;
var
  w_iCount:Integer;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //戻り値
  Result := True;
  try
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT BYOUTOU_ID,BYOUSITU_ID';
      sqlSelect := sqlSelect + ' FROM KANJAMASTER';
      sqlSelect := sqlSelect + ' WHERE KANJAID = :PKANJAID';
      PrepareQuery(sqlSelect);
      //パラメータ
      //患者ID
      SetParam('PKANJAID', FQ_SEL_ORD.GetString('KANJAID'));
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
      if w_iCount <> 0 then begin
        if GetString('BYOUTOU_ID') <> '' then
          //病棟ID取得
          arg_Code := func_RigthSpace(3,Trim(GetString('BYOUTOU_ID')));
        if GetString('BYOUSITU_ID') <> '' then
          //病室ID取得
          arg_SituCode := func_RigthSpace(5,Trim(GetString('BYOUSITU_ID')));
      end
      else begin
        //データなしフラグ設定
        arg_NullFlg := '1';
      end;
    end;
  except
    on E: Exception do begin
      //エラー終了処理
      Result := False;
      //切断
      wg_DBFlg := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_GETROOMERR_MSG + E.Message;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 :func_ExMain
  引数 :
    var arg_Patient:string    患者ID
        arg_KensaType:string  撮影種別
        arg_InOut:string      伝票入外区分
        arg_JisTanto:string   実績担当者
        arg_ErrMsg:string     エラー時：詳細原因 正常時：''
        arg_NullFlg:String    データなし：'1' 正常時：''
  復帰値：例外ない True 正常 False 異常
  機能 :
    1. 送信レコードの実績メイン情報を取得します。
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_ExMain(var arg_Patient,
                                   arg_KensaType,
                                   //arg_InOut,
                                   arg_JisTanto,
                                   arg_ErrMsg,
                                   arg_NullFlg:string):Boolean;
var
  w_iCount:Integer;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //戻り値
  Result := True;
  try
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT KANJA_ID, KENSATYPE_ID, DENPYO_NYUGAIKBN, KENSA_GISI_ID, BIKOU, JISISYA_ID';
      sqlSelect := sqlSelect + ' FROM EXMAINTABLE';
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
      if w_iCount <> 0 then begin
        //患者番号がない場合
        if Trim(GetString('KANJA_ID')) = '' then
        begin
          //エラー終了処理
          Result := False;
          //エラー終了処理
          arg_ErrMsg := CST_GETEXMAINERR_MSG + '患者番号がありません。';
          //処理終了
          Exit;
        end
        else
          //患者ID取得
          arg_Patient := func_RigthSpace(JISSIPIDLEN,Trim(GetString('KANJA_ID')));
        //検査種別がない場合
        if Trim(GetString('KENSATYPE_ID')) = '' then
        begin
          //エラー終了処理
          Result := False;
          //エラー終了処理
          arg_ErrMsg := CST_GETEXMAINERR_MSG + '検査種別がありません。';
          //処理終了
          Exit;
        end
        else
          //検査種別取得
          arg_KensaType := func_RigthSpace(JISSIBUISATUEICODELEN,Trim(GetString('KENSATYPE_ID')));

        wg_KensaType := GetString('KENSATYPE_ID');
        //実施担当者ID取得
        arg_JisTanto := func_RigthSpace(JISSIJISSICODELEN,
                                        Trim(GetString('JISISYA_ID')));
(*
        if Pos(',',Trim(GetString('KENSA_GISI_ID'))) <> 0 then
        begin
          //実施担当者ID取得
          arg_JisTanto := func_RigthSpace(JISSIJISSICODELEN,
                                          Copy(Trim(GetString('KENSA_GISI_ID')), 1,
                                          Pos(',',Trim(GetString('KENSA_GISI_ID'))) - 1));
        end
        else begin
          //実施担当者ID取得
          arg_JisTanto := func_RigthSpace(JISSIJISSICODELEN,
                                          Trim(GetString('KENSA_GISI_ID')));
        end;
*)
        wg_Memo := func_RigthSpace(JISSICCOMLEN,Trim(GetString('BIKOU')));
      end
      else begin
        //レコードなしフラグ設定
        arg_NullFlg := '1';
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
      //切断
      wg_DBFlg := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_GETEXMAINERR_MSG + E.Message;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 :func_ExtendOrderInfo
  引数 :
    var arg_Kbn1:string      区分1
        arg_Kbn2:string      区分2
        arg_Sikyu:string     至急区分
        arg_ErrMsg:string    エラー時：詳細原因 正常時：''
        arg_NullFlg:String   データなし：'1' 正常時：''
  復帰値：例外ない True 正常 False 異常
  機能 :
    1. 送信レコードの拡張オーダ情報を取得します。
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_ExtendOrderInfo(var arg_Kbn1,
                                            arg_Kbn2,
                                            arg_Sikyu,
                                            arg_ErrMsg,
                                            arg_NullFlg:string):Boolean;
var
  w_iCount:Integer;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //戻り値
  Result := True;
  try
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT ADDENDUM01, ADDENDUM02,SIKYU_FLG';
      sqlSelect := sqlSelect + ' FROM EXTENDORDERINFO';
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
      if w_iCount <> 0 then begin
        //区分1取得
        arg_Kbn1 := func_RigthSpace(JISSIKINKYUKBNLEN,
                                    Trim(GetString('ADDENDUM01')));
        //区分2取得
        arg_Sikyu := func_RigthSpace(JISSISIKYUKBNLEN,
                                    Trim(GetString('SIKYU_FLG')));
        //区分2取得
        arg_Kbn2 := func_RigthSpace(JISSIGENZOKBNLEN,
                                    Trim(GetString('ADDENDUM02')));
      end
      else begin
        //レコードなしフラグ設定
        arg_NullFlg := '1';
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
      //切断
      wg_DBFlg := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_GETEXTENDORDERERR_MSG + E.Message;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 :func_ExtendExamInfo
  引数 :
    var arg_kaikei:string    会計フラグ
        arg_ErrMsg:string    エラー時：詳細原因 正常時：''
        arg_NullFlg:String   データなし：'1' 正常時：''
  復帰値：例外ない True 正常 False 異常
  機能 :
    1. 送信レコードの拡張実績情報を取得します。
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_ExtendExamInfo(var arg_kaikei,
                                           arg_ErrMsg,
                                           arg_NullFlg:string):Boolean;
var
  w_iCount:Integer;
  sqlSelect:  String;
  iRslt:      Integer;
begin
  //戻り値
  Result := True;
  try
    with FQ_SEL do begin
      //SQL設定
      sqlSelect := '';
      sqlSelect := sqlSelect + 'SELECT JISSEKIKAIKEI_FLG';
      sqlSelect := sqlSelect + ' FROM EXTENDEXAMINFO';
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
      if w_iCount <> 0 then begin
        if Trim(GetString('JISSEKIKAIKEI_FLG')) = CST_RISKAIKEI_Z then
          //会計フラグ取得
          arg_kaikei := func_RigthSpace(JISSIKAIKEIKBNLEN,CST_HISKAIKEI_Z)
        else if Trim(GetString('JISSEKIKAIKEI_FLG')) = CST_RISKAIKEI_Y then
          //会計フラグ取得
          arg_kaikei := func_RigthSpace(JISSIKAIKEIKBNLEN,CST_HISKAIKEI_Y);
      end
      else begin
        //レコードなしフラグ設定
        arg_NullFlg := '1';
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
      //切断
      wg_DBFlg := False;
      //エラー状態メッセージ取得
      arg_ErrMsg := CST_GETEXTENDEXAMERR_MSG + E.Message;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 :func_Make_Msg_Kensa
  引数 :
        arg_Type: String;      検査種別
        arg_Gisi: String;      実施担当技師
        var arg_ErrMsg:string  エラー時：詳細原因 正常時：''
  復帰値：例外ない True 正常 False 異常
  機能 :
    1. 送信電文の検査コード、検査コード枝番、左右区分、検査指示項目コード
    　 コメントコード、フィルムコード、フィルム写損枚数、フィルム枚数
    　 フィルム分割数を設定します。
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_Make_Msg_Kensa(arg_kaikei: String;var arg_TypeID:string;var arg_ErrMsg:string):Boolean;
var
  rec_count_bui:  Integer;

  w_i,w_i2,w_NoCount,w_iKensa_Count,w_iFilm_Count:Integer;
  w_Count,w_iSiji,w_iFCount,w_iLoss,w_iAdju,w_iKCount:Integer;
  w_KensaType,w_Flg,w_KensaCode,w_Kensahouhou:String;
  w_i_Count,w_i_Count2:integer;
  w_Kaisu:String;
  w_RCode,w_JTime,w_SGisi:String;
  wi_Bui_Loop,wi_Bui_Loop2:integer;
  w_Bui_Flg : Boolean;
  wi_Loop_Yakuzai: Integer;
  wi_Yakuzai_Count: Integer;
  wi_Same_Loop: Integer;
  wi_Same_Code: Integer;
  wb_Same_Flg: Boolean;
  wi_Loop_Film: Integer;
  wi_Film_Count: Integer;
  wi_Film_Index: Integer;
  wi_Zairyo_Count: Integer;
  wi_Loop_Inf: Integer;
  wi_Inf_Count: Integer;
  wi_Loop_Com: Integer;
  wi_Com_Count: Integer;
  wb_Yoyaku_Flg: Boolean;
  wi_Index: Integer;
  w_Kensa_Code_Save:array of TGroup;
  wi_Same_Count: Integer;
  WB_Flg,WB_Flg2:Boolean;

  rec_count:  Integer;
  sqlSelect:  String;
  iRslt:      Integer;
  wkBuiID:    String;
begin
  //戻り値
  Result := True;
  //初期化
  w_iKensa_Count := 0;
  w_NoCount := 0;
  WB_Flg  := False;
  WB_Flg2 := False;
  try
    //実績部位テーブル情報取得SQL文作成
    with FQ_SEL_BUI do begin
      wb_Yoyaku_Flg := False;
      //SQL設定
      sqlSelect := '';
      //2018/08/30 部位情報　変更 Ex.BUISET_ID 使用しない
      //2018/09/03 中止部位送信 HIS_ORIGINAL_FLG不要
      sqlSelect := sqlSelect + 'SELECT Ex.BUIORDER_NO, Ex.SATUEISTATUS, Ex.NO,';
      //sqlSelect := sqlSelect + ' Ex.KENSASITU_ID, Ex.HIS_ORIGINAL_FLG, Ex.BUI_ID';
      sqlSelect := sqlSelect + ' Ex.KENSASITU_ID, Ex.BUI_ID';
      sqlSelect := sqlSelect + '  FROM EXBUITABLE Ex ';
      sqlSelect := sqlSelect + ' WHERE Ex.RIS_ID = :PRIS_ID';
      sqlSelect := sqlSelect + '   AND (Ex.SATUEISTATUS = :PSATUEISTATUS';
      sqlSelect := sqlSelect + '    OR Ex.SATUEISTATUS = :PSATUEISTATUS2)';
      sqlSelect := sqlSelect + ' ORDER BY Ex.NO';
      PrepareQuery(sqlSelect);
      //Where句
      //パラメータ
      //RIS_ID
      SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
      //撮影進捗(撮影済)
      SetParam('PSATUEISTATUS', GPCST_CODE_SATUEIS_1);
      //撮影進捗(中止)
      SetParam('PSATUEISTATUS2', GPCST_CODE_SATUEIS_2);
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
      rec_count := iRslt;
      //レコードが最大数以下の場合
      if rec_count <= CST_KENSA_LOOP then begin
        w_i_Count := rec_count;
      end
      //レコードが最大数以上の場合
      else begin
        w_i_Count := CST_KENSA_LOOP;
      end;
      SetLength(wg_Kensa_Code,0);
      //レコードがある場合
      if w_i_Count <> 0 then begin
        //レコード分Loop
        for w_i := 0 to w_i_Count - 1 do begin
          //初期化
          wi_Same_Count := 0;
          wi_Yakuzai_Count := 0;
          wi_Zairyo_Count := 0;
          wi_Film_Count := 0;
          wi_Inf_Count := 0;
          wi_Com_Count := 0;
          //予約なしの場合
          if not wb_Yoyaku_Flg then
          begin
            //2018/09/03 中止部位送信 --->
            {
            //RIS作成オーダで”中止”の場合
            if (GetString('HIS_ORIGINAL_FLG') <> CST_ORDER_KBN_1) and
               (GetString('SATUEISTATUS') = GPCST_CODE_SATUEIS_2) then
            begin
              //次のレコードに移動
              Next;
              //処理せず
              Continue;
            end;
            }
            //2018/09/03 中止部位送信 <---
          end
          //予約ありの場合
          else
          begin
            //すでに部位が登録されている場合
            if Length(wg_Kensa_Code) > 0 then
            begin
              //次のレコードに移動
              Next;
              //処理せず
              Continue;
            end;
            //”中止”の場合
            if GetString('SATUEISTATUS') = GPCST_CODE_SATUEIS_2 then
            begin
              //中止のデータのセーブを作成
              if Length(wg_Kensa_Code) = 0 then
              begin
                //構造体作成
                SetLength(w_Kensa_Code_Save,Length(w_Kensa_Code_Save) + 1);
                //インデックス
                wi_Index := Length(w_Kensa_Code_Save) - 1;
                //グループ番号
                //w_Kensa_Code_Save[wi_Index].GroupNo := func_LeftZero(JISSIGROUPLEN,Trim(GetString('NO')));
                w_Kensa_Code_Save[wi_Index].GroupNo := func_LeftZero(JISSIGROUPLEN,'001');
                //会計区分
                w_Kensa_Code_Save[wi_Index].Account := arg_kaikei;
                //実施の場合
                if Trim(GetString('SATUEISTATUS')) = CST_RISJISSI_Y then
                  //実施区分
                  w_Kensa_Code_Save[wi_Index].ExKbn := CST_HISJISSI_Y
                //中止の場合
                else if Trim(GetString('SATUEISTATUS')) = CST_RISJISSI_Z then
                  //実施区分
                  w_Kensa_Code_Save[wi_Index].ExKbn := CST_HISJISSI_Z;

                //項目コード
                //2018/08/30 部位情報　変更
                //部位ID 先頭6桁
                //w_Kensa_Code_Save[wi_Index].Koumoku := func_RigthSpace(JISSIKMKCODELEN,Trim(GetString('BUISET_ID')));
                wkBuiID:= Trim(GetString('BUI_ID'));
                w_Kensa_Code_Save[wi_Index].Koumoku := func_RigthSpace(JISSIKMKCODELEN, Copy(wkBuiID, 1, 6));

                //撮影種コード
                w_Kensa_Code_Save[wi_Index].TypeID := func_RigthSpace(JISSIBUISATUEICODELEN,Trim(arg_TypeID));
                //部位コード
                wkBuiID := '70' + Copy(wkBuiID, 7, 4);
                w_Kensa_Code_Save[wi_Index].BuiCode := func_RigthSpace(JISSIBUICODELEN, wkBuiID);
                //検査室コード
                w_Kensa_Code_Save[wi_Index].RoomCode := func_RigthSpace(JISSIKENSAROOMCODELEN,Trim(GetString('KENSASITU_ID')));

                //ポータブル（固定）
                w_Kensa_Code_Save[wi_Index].Portble := ' ';
                //検査回数（固定）
                w_Kensa_Code_Save[wi_Index].BuiCount := '0000';
                //初期化
                wi_Same_Code := 0;
                //--- 薬剤 ---
                with FQ_SEL do begin
                  //SQL設定
                  sqlSelect := '';
                  sqlSelect := sqlSelect + 'SELECT Pm.ZOUEIZAIIJITANNI_ID, Ez.PARTS_ID, Ez.SUURYOU_IJI, Ez.SUURYOU';
                  sqlSelect := sqlSelect + ' FROM EXZOUEIZAITABLE Ez, PARTSMASTER Pm';
                  sqlSelect := sqlSelect + ' WHERE Ez.RIS_ID = :PRIS_ID';
                  sqlSelect := sqlSelect + ' AND Ez.BUI_NO = :PBUI_NO';
                  sqlSelect := sqlSelect + ' AND Ez.PARTS_ID = Pm.ZOUEIZAI_ID(+)';
                  sqlSelect := sqlSelect + ' AND Pm.ZOUEIZAIKBN = :PZOUEIZAIKBN';
                  sqlSelect := sqlSelect + ' ORDER BY Ez.NO';
                  PrepareQuery(sqlSelect);
                  //パラメータ
                  //RIS_ID
                  SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
                  //BUI_NO
                  SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
                  //造影剤区分（20：薬剤）
                  SetParam('PZOUEIZAIKBN', CST_RECORD_KBN_20);
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
                  //レコードがある場合
                  rec_count := iRslt;
                  if rec_count > 0 then begin
                    //件数
                    wi_Yakuzai_Count := rec_count;
                    for wi_Loop_Yakuzai := 0 to wi_Yakuzai_Count - 1 do
                    begin
                      //初期化
                      wb_Same_Flg := False;
                      //構造体の中から同一IDを探す
                      for wi_Same_Loop := 0 to Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1 do
                      begin
                        //同一IDの場合
                        if w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID')) then
                        begin
                          //フラグ設定
                          wb_Same_Flg := True;
                          //同一IDインデックス
                          wi_Same_Code := wi_Same_Loop;
                          inc(wi_Same_Count);
                          Break;
                        end;
                      end;
                      //同一IDがない場合
                      if not wb_Same_Flg then
                      begin
                        //構造体作成
                        SetLength(w_Kensa_Code_Save[wi_Index].Yakuzai, Length(w_Kensa_Code_Save[wi_Index].Yakuzai) + 1);
                        //レコード区分
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_20);
                        //項目コード
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'));
                        //使用量
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000));
                        //分割数
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Bunkatu := func_RigthSpace(JISSIYBUNKATULEN,'');
                        //予備
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                      end
                      //同一IDあり
                      else
                      begin
                        //実施使用量
                        w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use :=
                                     func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                                                   StrToIntDef(w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                                                   (StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000)));
                      end;
                      Next;
                    end;
                  end;
                end;
                //初期化
                wi_Same_Code := 0;
                with FQ_SEL do begin
                  //SQL設定
                  sqlSelect := '';
                  sqlSelect := sqlSelect + 'SELECT Pm.ZOUEIZAIIJITANNI_ID, Ez.PARTS_ID, Ez.SUURYOU_IJI';
                  sqlSelect := sqlSelect + ' FROM EXZOUEIZAITABLE Ez, PARTSMASTER Pm';
                  sqlSelect := sqlSelect + ' WHERE Ez.RIS_ID = :PRIS_ID';
                  sqlSelect := sqlSelect + ' AND Ez.BUI_NO = :PBUI_NO';
                  sqlSelect := sqlSelect + ' AND Ez.PARTS_ID = Pm.ZOUEIZAI_ID(+)';
                  sqlSelect := sqlSelect + ' AND Pm.ZOUEIZAIKBN = :PZOUEIZAIKBN';
                  sqlSelect := sqlSelect + ' ORDER BY Ez.NO';
                  PrepareQuery(sqlSelect);
                  //パラメータ
                  //RIS_ID
                  SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
                  //BUI_NO
                  SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
                  //造影剤区分（50：材料）
                  SetParam('PZOUEIZAIKBN', CST_RECORD_KBN_50);
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
                  rec_count := iRslt;
                  //レコードがある場合
                  if rec_count <> 0 then
                  begin
                    //件数
                    wi_Zairyo_Count := rec_count;
                    for wi_Loop_Film := 0 to wi_Zairyo_Count - 1 do
                    begin
                      //初期化
                      wb_Same_Flg := False;
                      //構造体の中から同一IDを探す
                      for wi_Same_Loop := 0 to Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1 do
                      begin
                        //同一IDの場合
                        if (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'))) and
                           (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].RecKbn = CST_RECORD_KBN_50) then
                        begin
                          //フラグ設定
                          wb_Same_Flg := True;
                          //同一IDインデックス
                          wi_Same_Code := wi_Same_Loop;
                          inc(wi_Same_Count);
                          Break;
                        end;
                      end;
                      //同一IDがない場合
                      if not wb_Same_Flg then
                      begin
                        //構造体作成
                        SetLength(w_Kensa_Code_Save[wi_Index].Yakuzai, Length(w_Kensa_Code_Save[wi_Index].Yakuzai) + 1);
                        //レコード区分
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_50);
                        //項目コード
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'));
                        //使用量
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000));
                        //分割数
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Bunkatu := func_LeftZero(JISSIYBUNKATULEN,'');
                        //予備
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                      end
                      //同一IDあり
                      else
                      begin
                        //使用量
                        w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use :=
                                     func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                                     StrToIntDef(w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                                     (StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000)));
                      end;
                      Next;
                    end;
                  end;
                end;
                //初期化
                wi_Same_Code := 0;
                with FQ_SEL do begin
                  //SQL設定
                  sqlSelect := '';
                  sqlSelect := sqlSelect + 'SELECT Pm.ZOUEIZAIIJITANNI_ID, Ez.PARTS_ID, Ez.SUURYOU_IJI';
                  sqlSelect := sqlSelect + ' FROM EXZOUEIZAITABLE Ez, PARTSMASTER Pm';
                  sqlSelect := sqlSelect + ' WHERE Ez.RIS_ID = :PRIS_ID';
                  sqlSelect := sqlSelect + ' AND Ez.BUI_NO = :PBUI_NO';
                  sqlSelect := sqlSelect + ' AND Ez.PARTS_ID = Pm.ZOUEIZAI_ID(+)';
                  sqlSelect := sqlSelect + ' AND Pm.ZOUEIZAIKBN = :PZOUEIZAIKBN';
                  sqlSelect := sqlSelect + ' ORDER BY Ez.NO';
                  PrepareQuery(sqlSelect);
                  //パラメータ
                  //RIS_ID
                  SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
                  //BUI_NO
                  SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
                  //造影剤区分（50：材料）
                  SetParam('PZOUEIZAIKBN', CST_RECORD_KBN_50);
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
                  rec_count := iRslt;
                  //レコードがある場合
                  if rec_count <> 0 then
                  begin
                    //件数
                    wi_Zairyo_Count := rec_count;
                    for wi_Loop_Film := 0 to wi_Zairyo_Count - 1 do
                    begin
                      //初期化
                      wb_Same_Flg := False;
                      //構造体の中から同一IDを探す
                      for wi_Same_Loop := 0 to Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1 do
                      begin
                        //同一IDの場合
                        if (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'))) and
                           (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].RecKbn = CST_RECORD_KBN_50) then
                        begin
                          //フラグ設定
                          wb_Same_Flg := True;
                          //同一IDインデックス
                          wi_Same_Code := wi_Same_Loop;
                          inc(wi_Same_Count);
                          Break;
                        end;
                      end;
                      //同一IDがない場合
                      if not wb_Same_Flg then
                      begin
                        //構造体作成
                        SetLength(w_Kensa_Code_Save[wi_Index].Yakuzai, Length(w_Kensa_Code_Save[wi_Index].Yakuzai) + 1);
                        //レコード区分
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_50);
                        //項目コード
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'));
                        //使用量
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000));
                        //分割数
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Bunkatu := func_LeftZero(JISSIYBUNKATULEN,'');
                        //予備
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                      end
                      //同一IDあり
                      else
                      begin
                        //使用量
                        w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use :=
                                     func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                                     StrToIntDef(w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                                     (StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000)));
                      end;
                      Next;
                    end;
                  end;
                  //初期化
                  wi_Same_Code := 0;
                  //--- フィルム ---
                  //SQL設定
                  sqlSelect := '';
                  sqlSelect := sqlSelect + 'SELECT Fm.ZOUEIZAITANNI_ID, Ef.FILM_ID, Ef.PARTITION, Ef.USED, Ef.LOSS';
                  sqlSelect := sqlSelect + ' FROM EXFILMTABLE Ef, FILMMASTER Fm';
                  sqlSelect := sqlSelect + ' WHERE Ef.RIS_ID = :PRIS_ID';
                  sqlSelect := sqlSelect + ' AND Ef.BUI_NO = :PBUI_NO';
                  sqlSelect := sqlSelect + ' AND Ef.FILM_ID = Fm.FILM_ID(+)';
                  sqlSelect := sqlSelect + ' ORDER BY Ef.NO';
                  PrepareQuery(sqlSelect);
                  //パラメータ
                  //RIS_ID
                  SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
                  //BUI_NO
                  SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
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
                  rec_count := iRslt;
                  //レコードがある場合
                  if rec_count <> 0 then
                  begin
                    //件数
                    wi_Film_Count := rec_count;
                    for wi_Loop_Film := 0 to wi_Film_Count - 1 do
                    begin
                      //初期化
                      wb_Same_Flg := False;
                      //構造体の中から同一IDを探す
                      for wi_Same_Loop := 0 to Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1 do
                      begin
                        //同一IDの場合
                        if (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('FILM_ID'))) and
                           (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].Bunkatu = func_LeftZero(JISSIYBUNKATULEN,GetString('PARTITION'))) and
                           (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].RecKbn = CST_RECORD_KBN_57) then
                        begin
                          //フラグ設定
                          wb_Same_Flg := True;
                          //同一IDインデックス
                          wi_Same_Code := wi_Same_Loop;
                          inc(wi_Same_Count);
                          Break;
                        end;
                      end;
                      //同一IDがない場合
                      if not wb_Same_Flg then
                      begin
                        //構造体作成
                        SetLength(w_Kensa_Code_Save[wi_Index].Yakuzai, Length(w_Kensa_Code_Save[wi_Index].Yakuzai) + 1);
                        //レコード区分
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_57);
                        //項目コード
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('FILM_ID'));
                        //使用量
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('USED'), 0) * 10000));
                        //分割数
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Bunkatu := func_LeftZero(JISSIYBUNKATULEN,GetString('PARTITION'));
                        //予備
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                      end
                      //同一IDあり
                      else
                      begin
                        //使用量
                        w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use :=
                                     func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                                     StrToIntDef(w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                                     (StrToFloatDef(GetString('USED'), 0) * 10000)));
                      end;
                      Next;
                    end;
                  end;
                end;
                //初期化
                wi_Same_Code := 0;
                with FQ_SEL do begin
                  //SQL設定
                  sqlSelect := '';
                  sqlSelect := sqlSelect + 'SELECT Ei.INFUSE_ID,Ei.SUURYOU_IJI,Im.INFUSEKBN';
                  sqlSelect := sqlSelect + ' FROM EXINFUSETABLE Ei, INFUSEMASTER Im';
                  sqlSelect := sqlSelect + ' WHERE Ei.RIS_ID = :PRIS_ID';
                  sqlSelect := sqlSelect + ' AND Ei.BUI_NO = :PBUI_NO';
                  sqlSelect := sqlSelect + ' AND Ei.INFUSE_ID = Im.INFUSE_ID(+)';
                  sqlSelect := sqlSelect + ' AND Im.INFUSEKBN = :PINFUSEKBN1';
                  sqlSelect := sqlSelect + ' ORDER BY Im.INFUSEKBN,Ei.NO';
                  PrepareQuery(sqlSelect);
                  //パラメータ
                  //RIS_ID
                  SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
                  //BUI_NO
                  SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
                  //BUI_NO
                  SetParam('PINFUSEKBN1', '30');
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
                  rec_count := iRslt;
                  //レコードがある場合
                  if rec_count <> 0 then
                  begin
                    //件数
                    wi_Inf_Count := rec_count;
                    for wi_Loop_Inf := 0 to wi_Inf_Count - 1 do
                    begin
                      //初期化
                      wb_Same_Flg := False;
                      //構造体の中から同一IDを探す
                      for wi_Same_Loop := 0 to Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1 do
                      begin
                        //同一IDの場合
                        if (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('INFUSE_ID'))) and
                           (w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Loop].RecKbn = CST_RECORD_KBN_30) then
                        begin
                          //フラグ設定
                          wb_Same_Flg := True;
                          //同一IDインデックス
                          wi_Same_Code := wi_Same_Loop;
                          inc(wi_Same_Count);
                          Break;
                        end;
                      end;
                      //同一IDがない場合
                      if not wb_Same_Flg then
                      begin
                        //構造体作成
                        SetLength(w_Kensa_Code_Save[wi_Index].Yakuzai, Length(w_Kensa_Code_Save[wi_Index].Yakuzai) + 1);
                        //レコード区分
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_30);
                        //項目コード
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('INFUSE_ID'));
                        //回数
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000));
                        //処方手技
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Bunkatu := func_RigthSpace(JISSIYBUNKATULEN,'');
                        //予備
                        w_Kensa_Code_Save[wi_Index].Yakuzai[Length(w_Kensa_Code_Save[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                      end
                      //同一IDあり
                      else
                      begin
                        //回数
                        //w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use := func_LeftZero(JISSIYORDERUSELEN,IntToStr(StrToIntDef(w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use,0) + StrToIntDef(GetString('SUURYOU_IJI'), 0)));
                        w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use :=
                                     func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                                     StrToIntDef(w_Kensa_Code_Save[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                                     (StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000)));
                      end;
                      Next;
                    end;
                  end;
                end;
                //--- コメント ---
                with FQ_SEL do begin
                  //SQL設定
                  sqlSelect := '';
                  sqlSelect := sqlSelect + 'SELECT KUBUN,ID,COM';
                  sqlSelect := sqlSelect + ' FROM ORDERDETAILTABLE_MMH';
                  sqlSelect := sqlSelect + ' WHERE RIS_ID = :PRIS_ID';
                  sqlSelect := sqlSelect + ' AND NO = :PBUI_NO';
                  sqlSelect := sqlSelect + ' ORDER BY COMNO';
                  PrepareQuery(sqlSelect);
                  //パラメータ
                  //RIS_ID
                  SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
                  //BUI_NO
                  SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
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
                  rec_count := iRslt;
                  //レコードがある場合
                  if rec_count <> 0 then
                  begin
                    //件数
                    wi_Inf_Count := rec_count;
                    for wi_Loop_Inf := 0 to wi_Inf_Count - 1 do
                    begin
                      //構造体作成
                      SetLength(w_Kensa_Code_Save[wi_Index].Comment, Length(w_Kensa_Code_Save[wi_Index].Comment) + 1);
                      //レコード区分
                      w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].RecKbn := func_RigthSpace(JISSICRECORDKBNLEN,GetString('KUBUN'));
                      //項目コード
                      w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].KoumokuCd := func_RigthSpace(JISSICKMKCODELEN,GetString('ID'));
                      //項目区分
                      w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].Comment := func_RigthSpace(JISSICCOMLEN,GetString('COM'));
                      //予備
                      w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].Yobi := func_RigthSpace(JISSICYOBILEN,'');
                      Next;
                    end;
                  end;
                end;

                if not WB_Flg then
                begin
                  if Trim(wg_Memo) <> '' then
                  begin
                    //構造体作成
                    SetLength(w_Kensa_Code_Save[wi_Index].Comment, Length(w_Kensa_Code_Save[wi_Index].Comment) + 1);
                    //レコード区分
                    w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].RecKbn := func_RigthSpace(JISSICRECORDKBNLEN,'98');
                    //項目コード
                    w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].KoumokuCd := func_RigthSpace(JISSICKMKCODELEN,'');
                    //項目区分
                    w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].Comment := func_RigthSpace(JISSICCOMLEN,wg_Memo);
                    //予備
                    w_Kensa_Code_Save[wi_Index].Comment[Length(w_Kensa_Code_Save[wi_Index].Comment) - 1].Yobi := func_RigthSpace(JISSICYOBILEN,'');
                  end;
                  WB_Flg := True;
                end;
                //明細数
                w_Kensa_Code_Save[wi_Index].Meisai := func_LeftZero(JISSIMEISAICOUNTLEN,
                                             IntToStr(Length(w_Kensa_Code_Save[wi_Index].Yakuzai) + Length(w_Kensa_Code_Save[wi_Index].Comment)));
              end;
              //次のレコードに移動
              Next;
              //処理せず
              Continue;
              wi_Yakuzai_Count := 0;
              wi_Zairyo_Count := 0;
              wi_Film_Count := 0;
              wi_Inf_Count := 0;
              wi_Com_Count := 0;
            end;
          end;
          //構造体作成
          SetLength(wg_Kensa_Code,Length(wg_Kensa_Code) + 1);
          //部位インデックス
          wi_Index := Length(wg_Kensa_Code) - 1;
          //グループ番号
          //wg_Kensa_Code[wi_Index].GroupNo := func_LeftZero(JISSIGROUPLEN,Trim(GetString('NO')));
          wg_Kensa_Code[wi_Index].GroupNo := func_LeftZero(JISSIGROUPLEN,IntToStr(wi_Index + 1));
          //会計区分
          wg_Kensa_Code[wi_Index].Account := arg_kaikei;
          //実施の場合
          if Trim(GetString('SATUEISTATUS')) = CST_RISJISSI_Y then
            //実施区分
            wg_Kensa_Code[wi_Index].ExKbn := CST_HISJISSI_Y
          //中止の場合
          else if Trim(GetString('SATUEISTATUS')) = CST_RISJISSI_Z then
            //実施区分
            wg_Kensa_Code[wi_Index].ExKbn := CST_HISJISSI_Z;

          //項目コード
          //2018/08/30 部位情報　変更
          //wg_Kensa_Code[wi_Index].Koumoku := func_RigthSpace(JISSIKMKCODELEN,Trim(GetString('BUISET_ID')));
          wkBuiID:= Trim(GetString('BUI_ID'));
          wg_Kensa_Code[wi_Index].Koumoku := func_RigthSpace(JISSIKMKCODELEN, Copy(wkBuiID, 1, 6));

          //撮影種コード
          wg_Kensa_Code[wi_Index].TypeID := func_RigthSpace(JISSIBUISATUEICODELEN,Trim(arg_TypeID));
          //部位コード
          wkBuiID := '70' + Copy(wkBuiID, 7, 4);
          wg_Kensa_Code[wi_Index].BuiCode := func_RigthSpace(JISSIBUICODELEN, wkBuiID);
          //検査室コード
          wg_Kensa_Code[wi_Index].RoomCode := func_RigthSpace(JISSIKENSAROOMCODELEN,Trim(GetString('KENSASITU_ID')));
          //ポータブル（固定）
          wg_Kensa_Code[wi_Index].Portble := ' ';
          //検査回数（固定）
          wg_Kensa_Code[wi_Index].BuiCount := '0000';
          //初期化
          wi_Same_Code := 0;

          //--- 薬剤 ---
          with FQ_SEL do begin
            //SQL設定
            sqlSelect := '';
            sqlSelect := sqlSelect + 'SELECT Pm.ZOUEIZAIIJITANNI_ID, Ez.PARTS_ID, Ez.SUURYOU_IJI';
            sqlSelect := sqlSelect + ' FROM EXZOUEIZAITABLE Ez, PARTSMASTER Pm';
            sqlSelect := sqlSelect + ' WHERE Ez.RIS_ID = :PRIS_ID';
            sqlSelect := sqlSelect + ' AND Ez.BUI_NO = :PBUI_NO';
            sqlSelect := sqlSelect + ' AND Ez.PARTS_ID = Pm.ZOUEIZAI_ID(+)';
            sqlSelect := sqlSelect + ' AND Pm.ZOUEIZAIKBN = :PZOUEIZAIKBN';
            sqlSelect := sqlSelect + ' ORDER BY Ez.NO';
            PrepareQuery(sqlSelect);
            //パラメータ
            //RIS_ID
            SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
            //BUI_NO
            SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
            //造影剤区分（20：薬剤）
            SetParam('PZOUEIZAIKBN', CST_RECORD_KBN_20);
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
            rec_count := iRslt;
            //構造体作成
            SetLength(wg_Kensa_Code[wi_Index].Yakuzai, 0);
            //レコードがある場合
            if rec_count <> 0 then
            begin
              //件数
              wi_Yakuzai_Count := rec_count;
              for wi_Loop_Yakuzai := 0 to wi_Yakuzai_Count - 1 do
              begin
                //初期化
                wb_Same_Flg := False;
                //構造体の中から同一IDを探す
                for wi_Same_Loop := 0 to Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1 do
                begin
                  //同一IDの場合
                  if wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID')) then
                  begin
                    //フラグ設定
                    wb_Same_Flg := True;
                    //同一IDインデックス
                    wi_Same_Code := wi_Same_Loop;
                    inc(wi_Same_Count);
                    Break;
                  end;
                end;
                //同一IDがない場合
                if not wb_Same_Flg then
                begin
                  //構造体作成
                  SetLength(wg_Kensa_Code[wi_Index].Yakuzai, Length(wg_Kensa_Code[wi_Index].Yakuzai) + 1);
                  //レコード区分
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_20);
                  //項目コード
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'));
                  //オーダ使用量
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000));
                  //単位コード
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Bunkatu := func_RigthSpace(JISSIYBUNKATULEN,'');
                  //予備
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                end
                //同一IDあり
                else
                begin
                  //実施使用量
                  wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use :=
                               func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                                             StrToIntDef(wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                                             (StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000)));
                end;
                Next;
              end;
            end;
          end;
          //初期化
          wi_Same_Code := 0;
          //--- 材料 ---

          with FQ_SEL do begin
            //SQL設定
            sqlSelect := '';
            sqlSelect := sqlSelect + 'SELECT Pm.ZOUEIZAIIJITANNI_ID, Ez.PARTS_ID, Ez.SUURYOU_IJI';
            sqlSelect := sqlSelect + ' FROM EXZOUEIZAITABLE Ez, PARTSMASTER Pm';
            sqlSelect := sqlSelect + ' WHERE Ez.RIS_ID = :PRIS_ID';
            sqlSelect := sqlSelect + ' AND Ez.BUI_NO = :PBUI_NO';
            sqlSelect := sqlSelect + ' AND Ez.PARTS_ID = Pm.ZOUEIZAI_ID(+)';
            sqlSelect := sqlSelect + ' AND Pm.ZOUEIZAIKBN = :PZOUEIZAIKBN';
            sqlSelect := sqlSelect + ' ORDER BY Ez.NO';
            PrepareQuery(sqlSelect);
            //パラメータ
            //RIS_ID
            SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
            //BUI_NO
            SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
            //造影剤区分（50：材料）
            SetParam('PZOUEIZAIKBN', CST_RECORD_KBN_50);
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
            rec_count := iRslt;
            //レコードがある場合
            if rec_count <> 0 then
            begin
              //件数
              wi_Zairyo_Count := rec_count;
              for wi_Loop_Film := 0 to wi_Zairyo_Count - 1 do
              begin
                //初期化
                wb_Same_Flg := False;
                //構造体の中から同一IDを探す
                for wi_Same_Loop := 0 to Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1 do
                begin
                  //同一IDの場合
                  if (wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'))) and
                     (wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].RecKbn = CST_RECORD_KBN_50) then
                  begin
                    //フラグ設定
                    wb_Same_Flg := True;
                    //同一IDインデックス
                    wi_Same_Code := wi_Same_Loop;
                    inc(wi_Same_Count);
                    Break;
                  end;
                end;
                //同一IDがない場合
                if not wb_Same_Flg then
                begin
                  //構造体作成
                  SetLength(wg_Kensa_Code[wi_Index].Yakuzai, Length(wg_Kensa_Code[wi_Index].Yakuzai) + 1);
                  //レコード区分
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_50);
                  //項目コード
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('PARTS_ID'));
                  //使用量
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000));
                  //分割数
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Bunkatu := func_LeftZero(JISSIYBUNKATULEN,'');
                  //予備
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                end
                //同一IDあり
                else
                begin
                  //使用量
                  wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use :=
                               func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                               StrToIntDef(wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                               (StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000)));
                end;
                Next;
              end;
            end;
            //初期化
            wi_Same_Code := 0;
            //--- フィルム ---
            //SQL設定
            sqlSelect := '';
            sqlSelect := sqlSelect + 'SELECT Fm.ZOUEIZAITANNI_ID, Ef.FILM_ID, Ef.PARTITION, Ef.USED, Ef.LOSS';
            sqlSelect := sqlSelect + ' FROM EXFILMTABLE Ef, FILMMASTER Fm';
            sqlSelect := sqlSelect + ' WHERE Ef.RIS_ID = :PRIS_ID';
            sqlSelect := sqlSelect + ' AND Ef.BUI_NO = :PBUI_NO';
            sqlSelect := sqlSelect + ' AND Ef.FILM_ID = Fm.FILM_ID(+)';
            sqlSelect := sqlSelect + ' ORDER BY Ef.NO';
            PrepareQuery(sqlSelect);
            //パラメータ
            //RIS_ID
            SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
            //BUI_NO
            SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
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
            rec_count := iRslt;
            //レコードがある場合
            if rec_count <> 0 then
            begin
              //件数
              wi_Film_Count := rec_count;
              for wi_Loop_Film := 0 to wi_Film_Count - 1 do
              begin
                //初期化
                wb_Same_Flg := False;
                //構造体の中から同一IDを探す
                for wi_Same_Loop := 0 to Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1 do
                begin
                  //同一IDの場合
                  if (wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('FILM_ID'))) and
                     (wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].Bunkatu = func_LeftZero(JISSIYBUNKATULEN,GetString('PARTITION'))) and
                     (wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].RecKbn = CST_RECORD_KBN_57) then
                  begin
                    //フラグ設定
                    wb_Same_Flg := True;
                    //同一IDインデックス
                    wi_Same_Code := wi_Same_Loop;
                    inc(wi_Same_Count);
                    Break;
                  end;
                end;
                //同一IDがない場合
                if not wb_Same_Flg then
                begin
                  //構造体作成
                  SetLength(wg_Kensa_Code[wi_Index].Yakuzai, Length(wg_Kensa_Code[wi_Index].Yakuzai) + 1);
                  //レコード区分
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_57);
                  //項目コード
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('FILM_ID'));
                  //使用量
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('USED'), 0) * 10000));
                  //分割数
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Bunkatu := func_LeftZero(JISSIYBUNKATULEN,GetString('PARTITION'));
                  //予備
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                end
                //同一IDあり
                else
                begin
                  //使用量
                  wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use :=
                               func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                               StrToIntDef(wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                               (StrToFloatDef(GetString('USED'), 0) * 10000)));
                end;
                Next;
              end;
            end;
          end;
          //初期化
          wi_Same_Code := 0;
          //--- 手技 ---
          with FQ_SEL do begin
            //SQL設定
            sqlSelect := '';
            sqlSelect := sqlSelect + 'SELECT Ei.INFUSE_ID,Ei.SUURYOU_IJI,Im.INFUSEKBN';
            sqlSelect := sqlSelect + ' FROM EXINFUSETABLE Ei, INFUSEMASTER Im';
            sqlSelect := sqlSelect + ' WHERE Ei.RIS_ID = :PRIS_ID';
            sqlSelect := sqlSelect + ' AND Ei.BUI_NO = :PBUI_NO';
            sqlSelect := sqlSelect + ' AND Ei.INFUSE_ID = Im.INFUSE_ID(+)';
            sqlSelect := sqlSelect + ' AND Im.INFUSEKBN = :PINFUSEKBN1';
            sqlSelect := sqlSelect + ' ORDER BY Im.INFUSEKBN,Ei.NO';
            PrepareQuery(sqlSelect);
            //パラメータ
            //RIS_ID
            SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
            //BUI_NO
            SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
            //BUI_NO
            SetParam('PINFUSEKBN1', CST_RECORD_KBN_30);
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
            rec_count := iRslt;
            //レコードがある場合
            if rec_count <> 0 then
            begin
              //件数
              wi_Inf_Count := rec_count;
              for wi_Loop_Inf := 0 to wi_Inf_Count - 1 do
              begin
                //初期化
                wb_Same_Flg := False;
                //構造体の中から同一IDを探す
                for wi_Same_Loop := 0 to Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1 do
                begin
                  //同一IDの場合
                  if (wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].KoumokuCd = func_RigthSpace(JISSIYKMKCODELEN,GetString('INFUSE_ID'))) and
                     (wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Loop].RecKbn = CST_RECORD_KBN_30) then
                  begin
                    //フラグ設定
                    wb_Same_Flg := True;
                    //同一IDインデックス
                    wi_Same_Code := wi_Same_Loop;
                    inc(wi_Same_Count);
                    Break;
                  end;
                end;
                //同一IDがない場合
                if not wb_Same_Flg then
                begin
                  //構造体作成
                  SetLength(wg_Kensa_Code[wi_Index].Yakuzai, Length(wg_Kensa_Code[wi_Index].Yakuzai) + 1);
                  //レコード区分
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].RecKbn := func_RigthSpace(JISSIYRECORDKBNLEN,CST_RECORD_KBN_30);
                  //項目コード
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].KoumokuCd := func_RigthSpace(JISSIYKMKCODELEN,GetString('INFUSE_ID'));
                  //回数
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Use := func_LeftZero(JISSIYORDERUSELEN,FloatToStr(StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000));

                  //処方手技
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Bunkatu := func_RigthSpace(JISSIYBUNKATULEN,'');
                  //予備
                  wg_Kensa_Code[wi_Index].Yakuzai[Length(wg_Kensa_Code[wi_Index].Yakuzai) - 1].Yobi := func_RigthSpace(JISSIYYOBILEN,'');
                end
                //同一IDあり
                else
                begin
                  //回数
                  //wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use := func_LeftZero(JISSIYORDERUSELEN,IntToStr(StrToIntDef(wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use,0) + StrToIntDef(GetString('SUURYOU_IJI'),0)));
                  wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use :=
                               func_LeftZero(JISSIYORDERUSELEN,FloatToStr(
                               StrToIntDef(wg_Kensa_Code[wi_Index].Yakuzai[wi_Same_Code].Use,0) +
                               (StrToFloatDef(GetString('SUURYOU_IJI'), 0) * 10000)));
                end;
                Next;
              end;
            end;
          end;
          //--- コメント ---
          with FQ_SEL do begin
            //SQL設定
            sqlSelect := '';
            sqlSelect := sqlSelect + 'SELECT KUBUN,ID,COM';
            sqlSelect := sqlSelect + ' FROM ORDERDETAILTABLE_MMH';
            sqlSelect := sqlSelect + ' WHERE RIS_ID = :PRIS_ID';
            sqlSelect := sqlSelect + ' AND NO = :PBUI_NO';
            sqlSelect := sqlSelect + ' ORDER BY COMNO';
            PrepareQuery(sqlSelect);
            //パラメータ
            //RIS_ID
            SetParam('PRIS_ID', FQ_SEL_ORD.GetString('RIS_ID'));
            //BUI_NO
            SetParam('PBUI_NO', FQ_SEL_BUI.GetString('NO'));
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
            rec_count := iRslt;
            //レコードがある場合
            if rec_count <> 0 then
            begin
              //件数
              wi_Inf_Count := rec_count;
              for wi_Loop_Inf := 0 to wi_Inf_Count - 1 do
              begin
                //構造体作成
                SetLength(wg_Kensa_Code[wi_Index].Comment, Length(wg_Kensa_Code[wi_Index].Comment) + 1);
                //レコード区分
                wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].RecKbn := func_RigthSpace(JISSICRECORDKBNLEN,GetString('KUBUN'));
                //項目コード
                wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].KoumokuCd := func_RigthSpace(JISSICKMKCODELEN,GetString('ID'));
                //項目区分
                wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].Comment := func_RigthSpace(JISSICCOMLEN,GetString('COM'));
                //予備
                wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].Yobi := func_RigthSpace(JISSICYOBILEN,'');
                Next;
              end;
            end;
          end;
          if not WB_Flg2 then
          begin
            if Trim(wg_Memo) <> '' then
            begin
              //構造体作成
              SetLength(wg_Kensa_Code[wi_Index].Comment, Length(wg_Kensa_Code[wi_Index].Comment) + 1);
              //レコード区分
              wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].RecKbn := func_RigthSpace(JISSICRECORDKBNLEN,'99');
              //項目コード
              wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].KoumokuCd := func_RigthSpace(JISSICKMKCODELEN,'');
              //項目区分
              wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].Comment := func_RigthSpace(JISSICCOMLEN,wg_Memo);
              //予備
              wg_Kensa_Code[wi_Index].Comment[Length(wg_Kensa_Code[wi_Index].Comment) - 1].Yobi := func_RigthSpace(JISSICYOBILEN,'');
            end;
            WB_Flg2 := True;
          end;
          //明細数
          wg_Kensa_Code[wi_Index].Meisai := func_LeftZero(JISSIMEISAICOUNTLEN,
                                             IntToStr(Length(wg_Kensa_Code[wi_Index].Yakuzai) + Length(wg_Kensa_Code[wi_Index].Comment)));
          //次のレコードに移動
          Next;
          wi_Same_Count := 0;
          wi_Yakuzai_Count := 0;
          wi_Zairyo_Count := 0;
          wi_Film_Count := 0;
          wi_Inf_Count := 0;
          wi_Com_Count := 0;
        end;
      end;
    end;

    //予約ありで
    //部位情報なしで
    //中止情報がある場合
    if (wb_Yoyaku_Flg) and
       (Length(wg_Kensa_Code) = 0) and
       (Length(w_Kensa_Code_Save) <> 0) then
    begin
      //構造体作成
      SetLength(wg_Kensa_Code,1);
      wg_Kensa_Code[0].GroupNo  :=  w_Kensa_Code_Save[0].GroupNo;
      wg_Kensa_Code[0].Account  :=  w_Kensa_Code_Save[0].Account;
      wg_Kensa_Code[0].ExKbn    :=  w_Kensa_Code_Save[0].ExKbn;
      wg_Kensa_Code[0].Koumoku  :=  w_Kensa_Code_Save[0].Koumoku;
      wg_Kensa_Code[0].TypeID   :=  w_Kensa_Code_Save[0].TypeID;
      wg_Kensa_Code[0].BuiCode  :=  w_Kensa_Code_Save[0].BuiCode;
      wg_Kensa_Code[0].RoomCode :=  w_Kensa_Code_Save[0].RoomCode;
      wg_Kensa_Code[0].Operator :=  w_Kensa_Code_Save[0].Operator;
      wg_Kensa_Code[0].BuiCount :=  w_Kensa_Code_Save[0].BuiCount;
      wg_Kensa_Code[0].Portble  :=  w_Kensa_Code_Save[0].Portble;
      wg_Kensa_Code[0].Meisai   :=  w_Kensa_Code_Save[0].Meisai;
      SetLength(wg_Kensa_Code[0].Yakuzai,Length(w_Kensa_Code_Save[0].Yakuzai));
      if Length(wg_Kensa_Code[0].Yakuzai) > 0 then
      begin
        wg_Kensa_Code[0].Yakuzai[0].RecKbn    := w_Kensa_Code_Save[0].Yakuzai[0].RecKbn;
        wg_Kensa_Code[0].Yakuzai[0].KoumokuCd := w_Kensa_Code_Save[0].Yakuzai[0].KoumokuCd;
        wg_Kensa_Code[0].Yakuzai[0].Use       := w_Kensa_Code_Save[0].Yakuzai[0].Use;
        wg_Kensa_Code[0].Yakuzai[0].Bunkatu   := w_Kensa_Code_Save[0].Yakuzai[0].Bunkatu;
        wg_Kensa_Code[0].Yakuzai[0].Yobi      := w_Kensa_Code_Save[0].Yakuzai[0].Yobi;
      end;
      SetLength(wg_Kensa_Code[0].Comment,Length(w_Kensa_Code_Save[0].Comment));
      if Length(wg_Kensa_Code[0].Comment) > 0 then
      begin
        wg_Kensa_Code[0].Comment[0].RecKbn    := w_Kensa_Code_Save[0].Comment[0].RecKbn;
        wg_Kensa_Code[0].Comment[0].KoumokuCd := w_Kensa_Code_Save[0].Comment[0].KoumokuCd;
        wg_Kensa_Code[0].Comment[0].Comment   := w_Kensa_Code_Save[0].Comment[0].Comment;
        wg_Kensa_Code[0].Comment[0].Yobi      := w_Kensa_Code_Save[0].Comment[0].Yobi;
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
      arg_ErrMsg := CST_KENSAERR_MSG + E.Message;
      wg_DBFlg := False;
      //処理終了
      Exit;
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 :func_Get_OffSet
  引数 :
    arg_No:Integer     項目No
    arg_OffSet:Integer オフセット位置
  復帰値：例外ない
  機能 :
    1. オフセット位置に、指定の項目サイズを追加したものを変換
 *
-----------------------------------------------------------------------------
}
function TDB_RisSD.func_Get_OffSet(arg_No,arg_OffSet:Integer): Integer;
var
  w_size  :integer;
  w_StremField : TStreamField;
begin
  inherited;
  //指定電文項目の情報取得
  w_StremField := func_FindMsgField(G_MSG_SYSTEM_C,G_MSGKIND_JISSI,arg_No);
  //サイズ
  w_size   := w_StremField.size;
  //サイズ分進める
  Result := arg_Offset + w_size;
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
function  TDB_RisSD.func_DelOrder(
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
        sqlExec := sqlExec + ' AND (REQUESTTYPE = ''' + CST_APPTYPE_OP01 + ''' OR REQUESTTYPE = ''' + CST_APPTYPE_OP02 + ''' OR REQUESTTYPE = ''' + CST_APPTYPE_OP99 + ''')';
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
{
-----------------------------------------------------------------------------
  名前 :func_ExtendExamInfo
  引数 :
    var arg_kaikei:string    会計フラグ
        arg_ErrMsg:string    エラー時：詳細原因 正常時：''
        arg_NullFlg:String   データなし：'1' 正常時：''
  復帰値：例外ない True 正常 False 異常
  機能 :
    1. 送信レコードの拡張実績情報を取得します。
 *
-----------------------------------------------------------------------------
}
{
function TDB_RisSD.func_ToHISInfo(var arg_Date,
                                      arg_Time,
                                      arg_ErrMsg,
                                      arg_NullFlg:string):Boolean;
var
  w_iCount:Integer;
begin
  //戻り値
  Result := True;
  try
    try
      //拡張実績情報取得SQL文作成
      with TQ_Etc do begin
        //閉じる
        Close;
        //SQL文をクリア
        SQL.Clear;
        //SQL文作成
        SQL.Add('SELECT REQUESTDATE');
        SQL.Add('FROM TOHISINFO');
        SQL.Add('WHERE RIS_ID = :PRIS_ID');
        SQL.Add('  AND REQUESTTYPE = :PREQUESTTYPE');
        SQL.Add('ORDER BY REQUESTDATE');

        //Where句
        //RIS_ID
        ParamByName('PRIS_ID').AsString := TQ_Order.FieldByName('RIS_ID').AsString;
        ParamByName('PREQUESTTYPE').AsString := CST_APPTYPE_OP01;

        //開く
        Open;
        //最後のレコードに移動
        Last;
        //最初のレコードに移動
        First;
        //2001.12.13
        w_iCount := RecordCount;
        if w_iCount <> 0 then begin
          arg_Date := FormatDateTime('YYYYMMDD', FieldByName('REQUESTDATE').AsDateTime);
          arg_Time := FormatDateTime('HHMM', FieldByName('REQUESTDATE').AsDateTime);
        end
        else begin
          //閉じる
          Close;
          //SQL文をクリア
          SQL.Clear;
          //SQL文作成
          SQL.Add('SELECT REQUESTDATE');
          SQL.Add('FROM TOHISINFO');
          SQL.Add('WHERE RIS_ID = :PRIS_ID');
          SQL.Add('  AND REQUESTTYPE = :PREQUESTTYPE');
          SQL.Add('ORDER BY REQUESTDATE');

          //Where句
          //RIS_ID
          ParamByName('PRIS_ID').AsString := TQ_Order.FieldByName('RIS_ID').AsString;
          ParamByName('PREQUESTTYPE').AsString := CST_APPTYPE_OP02;

          //開く
          Open;
          //最後のレコードに移動
          Last;
          //最初のレコードに移動
          First;
          //2001.12.13
          w_iCount := RecordCount;
          if w_iCount <> 0 then begin
            arg_Date := FormatDateTime('YYYYMMDD', FieldByName('REQUESTDATE').AsDateTime);
            arg_Time := FormatDateTime('HHMM', FieldByName('REQUESTDATE').AsDateTime);
          end
          else
          begin
            //閉じる
            Close;
            //SQL文をクリア
            SQL.Clear;
            //SQL文作成
            SQL.Add('SELECT REQUESTDATE');
            SQL.Add('FROM TOHISINFO');
            SQL.Add('WHERE RIS_ID = :PRIS_ID');
            SQL.Add('  AND REQUESTTYPE = :PREQUESTTYPE');
            SQL.Add('ORDER BY REQUESTDATE');

            //Where句
            //RIS_ID
            ParamByName('PRIS_ID').AsString := TQ_Order.FieldByName('RIS_ID').AsString;
            ParamByName('PREQUESTTYPE').AsString := CST_APPTYPE_OP99;

            //開く
            Open;
            //最後のレコードに移動
            Last;
            //最初のレコードに移動
            First;
            //2001.12.13
            w_iCount := RecordCount;
            if w_iCount <> 0 then begin
              arg_Date := FormatDateTime('YYYYMMDD', FieldByName('REQUESTDATE').AsDateTime);
              arg_Time := FormatDateTime('HHMM', FieldByName('REQUESTDATE').AsDateTime);
            end
            else
            begin
              arg_NullFlg := '1';
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
        //切断
        wg_DBFlg := False;
        //エラー状態メッセージ取得
        arg_ErrMsg := CST_GETTOHISERR_MSG + E.Message;
        //処理終了
        Exit;
      end;
    end;
  finally
    TQ_Etc.Close;
  end;
end;
}
end.
