unit URH_ShemaSvc;
(**
■機能説明
 シェーマ情報取得サービスの制御

■履歴
新規作成：2004.10.18：担当 増田
*)
interface //*****************************************************************
//使用ユニット---------------------------------------------------------------
uses
//システム－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr,
  IniFiles, Dialogs, ExtCtrls,ScktComp, //Db, DBTables, 
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Gval,
  HisMsgDef,
  TcpSocket,
  pdct_shema,
  UDb_RisShema,
  Unit_Log, Unit_DB
  ;

////型クラス宣言-------------------------------------------------------------
type
  TRisHisSvc_Shema = class(TService)
    procedure ServiceExecute(Sender: TService);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceAfterUninstall(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
  private
    { Private 宣言 }
    wg_ErrMSG:String;
    wg_RIS_ID:String;
    wg_Order_NO:String;
    wg_MainDIR:String;
    wg_SubDIR:String;
    procedure proc_Main;

  public
    StopMode: integer;
    function GetServiceController: TServiceController; override;
    { Public 宣言 }
  end;
//定数宣言-------------------------------------------------------------------
//変数宣言-------------------------------------------------------------------
var
//ini情報
   g_TcpIniPath:string;
    ini: TIniFile;
    LogFlag : Integer;      // ログ出力有無 1: On 0: Off
    LogFile : string;       // ログファイル名
    LogSize : Integer;      // ログサイズ
    TestMode: Integer;      // テストモード 1: Test 0: 稼動
    TestSyori: string;
    SleepTime:Integer;
    RDatabaseName:String;
    RDriverName:String;
    RServerName:String;
    RNetProtocol:String;
    RLangDriver:String;
    RUserName:String;
    RPassword:String;
    HServerName:String;
    HUserID:string;
    HPassword:String;
    HSleepTime:Integer;
    HRetry_Cnt:Integer;
var
  RisHisSvc_Shema: TRisHisSvc_Shema;
//関数手続き宣言-------------------------------------------------------------

implementation //**************************************************************

//使用ユニット---------------------------------------------------------------
//uses UDb_Ris;
{$R *.DFM}

//定数宣言       -------------------------------------------------------------
const
  CST_FTP_NON = '00';
  CST_FTP_GET = '01';
  CST_FTP_ERR = '02';
  CST_FTP_ERR2 = '03';
//変数宣言     ---------------------------------------------------------------
//var

//関数手続き宣言--------------------------------------------------------------
//=============================================================================
//サービス関連処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  RisHisSvc_Shema.Controller(CtrlCode);
end;

function TRisHisSvc_Shema.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

//サービス作成
procedure TRisHisSvc_Shema.ServiceCreate(Sender: TObject);
begin
  //DBクラス作成
  DB_RisShema := TDB_RisShema.Create();
  //INIファイルを読み込む
  if not func_TcpReadiniFile then
  begin
    //ログ出力
    proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                'iniファイル読み込みNG');
  end;

  //サービス作成完了ログ
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVCDEF_NUM,
              '*****サービスを作成しました*****');
end;
//サービス破棄
procedure TRisHisSvc_Shema.ServiceDestroy(Sender: TObject);
begin
  //DBクラス作成
  if Assigned(DB_RisShema) then FreeAndNil(DB_RisShema);
  //サービス消去
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVC_NUM,
              '*****サービスを破棄しました*****');
end;
//
procedure TRisHisSvc_Shema.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
//
end;
//サービス停止
procedure TRisHisSvc_Shema.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin
  //ログ出力
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVCDEF_NUM,
              '*****サービスを停止しました*****');
end;
//サービスインストール
procedure TRisHisSvc_Shema.ServiceAfterInstall(Sender: TService);
begin
  //ログ出力
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVCDEF_NUM,
              '*****サービスをインストールしました*****');
end;
//サービスアンインストール
procedure TRisHisSvc_Shema.ServiceAfterUninstall(Sender: TService);
begin
  //ログ出力
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVCDEF_NUM,
              '*****サービスをアンインストールしました*****');
end;

//サービス実行処理
procedure TRisHisSvc_Shema.ServiceExecute(Sender: TService);
var
  w_StopTimestamp:TTimeStamp;
  w_StopDateTime:TDateTime ;
  res:boolean;
  w_sErr:string;
  cnt_record:  Integer;
begin
  try
    try
      //サービス起動のたびにINIファイルを読み込む
      if not func_TcpReadiniFile then
      begin
        //ログ出力
        proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                    'iniファイル読み込みNG');
        //サービス停止
        ServiceThread.Terminate;
        //処理終了
        Exit;
      end;
      //ログ出力
      proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVC_NUM,
                  '*****サービスを開始します*****');
      //ログ出力
      proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_CL_NUM,
                  '起動パス：' + g_TcpIniPath);
      //サービス実行時
      while not Terminated do
      begin
        //アクティブ時のみ動作する
        if g_Svc_Shema_Acvite = g_SOCKET_ACTIVE then
        begin
          //DBをオープンする 例外を発生しないように
          if DB_RisShema.RisDBOpen(DB_RisShema.wg_DBFlg,w_sErr,self) then begin
            wg_ErrMSG := '';
            try
              proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_NUM,'RIS DB接続OK');
              //3.受信オーダテーブルの取得
              res := DB_RisShema.func_GetOrder(cnt_record, w_sErr);
              if res then
              begin
                if cnt_record > 0 then
                begin
                  (*
                  //最後のレコードに移動
                  DB_RisShema.TQ_Order.Last;
                  //最初のレコードに移動
                  DB_RisShema.TQ_Order.First;
                  *)
                  //ログ表示
                  proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_NUM,'オーダシェーマテーブル取得OK「' + IntToStr(cnt_record) + '件」');
                  while (not Terminated)                    and
                        (cnt_record > 0) and
                        (not (FQ_SEL_ORD.Eof))       do begin
                    wg_ErrMSG := '';
                    //RIS_ID取得
                    wg_RIS_ID := FQ_SEL_ORD.GetString('RIS_ID');
                    {
                    //シェーマ部位No取得
                    wg_ShemaBuiNo := DB_RisShema.TQ_Order.FieldByName('NO').AsString;
                    //シェーマNo取得
                    wg_ShemaNo := DB_RisShema.TQ_Order.FieldByName('SHEMANO').AsString;
                    }
                    //ログフラグ初期化
                    DB_RisShema.wg_Log_Flg := '';
                    //4-8の処理
                    proc_Main;
                    //次のレコードに移動
                    FQ_SEL_ORD.Next;
                    //ログの出力
                    proc_LogOut(DB_RisShema.wg_Log_Flg,'',G_LOG_KIND_DB_NUM,wg_ErrMSG);
                  end;
                end
                else begin
                  proc_StrConcat(wg_ErrMSG,'オーダシェーマテーブル対象レコードなし');
                  //ログの出力
                  proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_NUM,wg_ErrMSG);
                end;
              end
              //異常終了の場合
              else begin
                proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_DB_NUM,'オーダシェーマテーブル取得NG「'+w_sErr+'」');
              end;
            Except
              on e:exception do begin
                //DBの切断
                DB_RisShema.RisDBClose;
                proc_LogOut(G_LOG_LINE_HEAD_NP,'',G_LOG_KIND_DB_NUM,'*****RIS DB接続を終了しました*****' + e.Message) ;
              end;
            end;
          //DBオープン失敗
          end
          else begin
            proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_DB_NUM,'RIS DB接続NG「'+w_sErr+'」') ;
          end;
          proc_LogOut(G_LOG_LINE_HEAD_NP,'',G_LOG_KIND_DB_NUM,'*****待機開始*****') ;
          //タイマループ処理
          //タイムスタンプの取得
          w_StopTimestamp := DateTimeToTimeStamp(now);
          //終了時刻の取得
          w_StopTimestamp.Time := w_StopTimestamp.Time + g_Svc_Shema_Cycle * 1000;
          //終了時刻の設定
          w_StopDateTime := TimeStampToDateTime(w_StopTimestamp);
          //終了時刻を越えるか、サービスが終了された場合
          while (not Terminated) and (w_StopDateTime>Now) do begin
            sleep(1000);
            ServiceThread.ProcessRequests(false);
          end;
          w_sErr := '';
          proc_LogOut(G_LOG_LINE_HEAD_NP,'',G_LOG_KIND_DB_NUM,'*****待機終了*****') ;
        end
        else begin
          ServiceThread.ProcessRequests(false);
        end;
      end;
      //DBの切断
      DB_RisShema.RisDBClose;
      //処理終了
      Exit;
    except
     //DBの切断
     DB_RisShema.RisDBClose;
     //処理終了
     Exit;
    end;
  finally
    //開放
    if Assigned(FQ_SEL) then FreeAndNil(FQ_SEL);
    if Assigned(FQ_SEL_ORD) then FreeAndNil(FQ_SEL_ORD);
    if Assigned(FQ_ALT) then FreeAndNil(FQ_ALT);
    if Assigned(FLog) then FreeAndNil(FLog);
    if Assigned(FDebug) then FreeAndNil(FDebug);
  end;
end;

//=============================================================================
//シェーマ情報取得処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
{-----------------------------------------------------------------------------
  名前 : proc_Main;
  引数 : なし
  機能 :
  １トランザクション処理
  復帰値：例外は発生しない
-----------------------------------------------------------------------------}
procedure TRisHisSvc_Shema.proc_Main;
var
  res:boolean;
  w_sErr:string;
  w_result:string;
  w_sysdate:string;
  w_NullFlg:String;
  WSWorkErr: String;
label
  p_err,
  p_end,
  p_UpDate;
begin
  try
    //初期化
    wg_Order_NO := '';
    wg_MainDIR  := '';
    wg_SubDIR   := '';
    w_NullFlg   := '';
    WSWorkErr   := '';
    DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_OK;
    SetLength(DB_RisShema.wg_OrderSchame_List,0);

    //ﾄﾗﾝｻﾞｸｼｮﾝ開始
    FDB.StartTransaction;
    {
    res := DB_RisShema.func_Chack_HIS(g_SHEMA_HIS_PASS,w_sErr);
    //正常終了の場合
    if res then
    begin
      //ログ文字列作成
      proc_StrConcat(wg_ErrMSG,'サーバーチェックOK フォルダ=' + g_SHEMA_HIS_PASS);
    end
    //異常終了の場合
    else begin
      proc_StrConcat(wg_ErrMSG,'サーバーチェックNG フォルダ=' + g_SHEMA_HIS_PASS);
      WSWorkErr := 'サーバーチェック NG';
      //途中終了
      //"未"に変更
      w_result := CST_FTP_NON;
      DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
      //電文登録修理へ
      goto p_UpDate;
    end;
    }
    //ログ文字列作成
    proc_StrConcat(wg_ErrMSG,'RIS_ID=' + wg_RIS_ID);


    //既存シェーマファイルの削除
    res := DB_RisShema.func_Del_Schema(g_SHEMA_LOCAL_PASS,wg_RIS_ID,g_SHEMA_HTML_PASS,w_sErr);
    //正常終了の場合
    if res then begin
      //削除成功
      proc_StrConcat(wg_ErrMSG,'ファイル削除OK');
    end
    //異常終了の場合
    else begin
      proc_StrConcat(wg_ErrMSG,'ファイル削除NG「'+w_sErr+'」');
      WSWorkErr := 'ファイル削除 NG';
      //途中終了
      //"未"に変更
      w_result := CST_FTP_NON;
      DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
      //電文登録修理へ
      goto p_UpDate;
    end;

    //オーダシェーマテーブルから情報の取得
    res := DB_RisShema.func_SelectOrder(wg_RIS_ID,w_sErr,w_NullFlg);
    //正常終了の場合
    if res then
    begin
      //データ有り
      if w_NullFlg = '' then begin
        proc_StrConcat(wg_ErrMSG,'RIS_ID特定 OK');
      end
      //データなし
      else begin
        proc_StrConcat(wg_ErrMSG,'RIS_ID特定 NG「' + w_sErr + '」');
        WSWorkErr := 'RIS_ID特定 NG';
        //途中終了
        //"済"に変更
        w_result := CST_FTP_ERR;
        DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
        //電文登録修理へ
        goto p_UpDate;
      end;
    end
    //異常終了の場合
    else begin
      proc_StrConcat(wg_ErrMSG,'RIS_ID特定 NG「' + w_sErr + '」');
      WSWorkErr := 'RIS_ID特定 NG';
      //途中終了
      //"済"に変更
      w_result := CST_FTP_ERR;
      DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
      //電文登録修理へ
      goto p_UpDate;
    end;

    //シェーマ情報の取得  w_result：情報取得状態
    res := DB_RisShema.func_GET_Shema(w_result,w_sErr);

    proc_StrConcat(wg_ErrMSG,w_sErr);

    if w_result = '01' then
    begin
      //HTMLファイル情報更新
      res := DB_RisShema.func_Make_HTML(w_sErr);
      //正常終了の場合
      if res then begin
        proc_StrConcat(wg_ErrMSG,'HTMLファイルの作成OK');
      end
      //異常終了の場合
      else begin
        proc_StrConcat(wg_ErrMSG,'HTMLファイルの作成NG「'+w_sErr+'」');
        DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
        WSWorkErr := 'HTML作成 NG';
        w_result := CST_FTP_ERR2;
        //エラー終了の場合
        goto p_UpDate;
      end;
      res := DB_RisShema.func_UpDate_ExtendOrderMain(w_sErr);
      //正常終了の場合
      if res then begin
        proc_StrConcat(wg_ErrMSG,'URL情報の登録OK');
      end
      //異常終了の場合
      else begin
        proc_StrConcat(wg_ErrMSG,'URL情報の登録NG「'+w_sErr+'」');
        WSWorkErr := 'URL情報登録 NG';
        DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
        w_result := CST_FTP_ERR2;
        //エラー終了の場合
        goto p_UpDate;
      end;
    end;

    //送信結果登録
    res := DB_RisShema.func_SetOrderResult(w_sErr);
    //正常終了の場合
    if res then begin
      proc_StrConcat(wg_ErrMSG,'シェーマ取得結果の登録OK');
    end
    //異常終了の場合
    else begin
      proc_StrConcat(wg_ErrMSG,'シェーマ取得結果の登録NG「'+w_sErr+'」');
      DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
      //エラー終了の場合
      goto p_err;
    end;
    //すべて正常の場合
    p_end:
      try
        //コミット
        FDB.Commit;
      except
        //ロールバック
        FDB.Rollback;
        raise;
      end;
      //処理終了
      Exit;
    //途中で失敗した場合
    p_UpDate:
      //8.受信結果を受信オーダテーブルへ登録
      w_sysdate := FQ_SEL.GetSysDateYMDHNS;
      //送信結果登録
      res := DB_RisShema.func_SetOrderResult_Up(wg_RIS_ID, w_result, WSWorkErr, w_sErr);
      //正常終了の場合
      if res then begin
        proc_StrConcat(wg_ErrMSG,'シェーマ取得結果の登録OK');
      end
      //異常終了の場合
      else begin
        proc_StrConcat(wg_ErrMSG,'シェーマ取得結果の登録NG「'+w_sErr+'」');
        DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
        //エラー終了の場合
        goto p_err;
      end;

      try
        //コミット
        FDB.Commit;
      except
        //ロールバック
        FDB.Rollback;
        raise;
      end;
      //処理終了
      Exit;
    p_err:
      try
        //コミット
        FDB.Rollback;
      except
        //ロールバック
        FDB.Rollback;
        raise;
      end;
      //処理終了
      Exit;
  except
    on E:Exception do
    begin
      DB_RisShema.wg_Log_Flg := G_LOG_LINE_HEAD_NG;
      proc_StrConcat(wg_ErrMSG,'予想外のエラーが発生しました ' + E.Message);
      //proc_LogOut('NG','',G_LOG_KIND_DB_NUM,'予想外のエラーが発生しました ' + E.Message);
      //処理終了
      Exit;
    end;
  end
end;
//=============================================================================
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//=============================================================================
initialization
begin
//1)起動PASSを確定
     g_TcpIniPath := ExtractFilePath( ParamStr(0) );
end;

finalization
begin
//
end;

end.
