unit URH_SDSvc;
(**
■機能説明
  Hisへの情報送信サービスの制御

■履歴
　新規作成：2004.10.12：担当 増田 友
*)
interface //*****************************************************************
//使用ユニット---------------------------------------------------------------
uses
//システム－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr,
  IniFiles, Dialogs, ExtCtrls,ScktComp,WinSvc,Forms, //Db, DBTables,QForms,
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Gval,
  HisMsgDef,
  HisMsgDef02_JISSI,
  TcpSocket,
  UDb_RisSD,
  Unit_Log, Unit_DB
  ;

////型クラス宣言-------------------------------------------------------------
type
  TRisHisSDSvc_Jissi = class(TService)
    ClientSocket1: TClientSocket;
    procedure ServiceExecute(Sender: TService);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceCreate(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Write(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServiceAfterInstall(Sender: TService);
    procedure ServiceAfterUninstall(Sender: TService);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
  private
    { Private 宣言 }
    w_SendMsgStream : TStringStream;
    w_RecvMsgStream : TStringStream;
    //wb_ConnectFlg: Boolean;
    wgs_IPPort: String;
    wgi_Pos: Integer;
    //wgs_Host: String;
    wg_RetryCount: Integer;
    procedure proc_C_StatusList(arg_Status: string;arg_string: string);
    function func_SendStream(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_RecvStream: TStringStream
                    ): string;
    function func_SendMsgBase(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_RecvStream: TStringStream
                    ): string;
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
var
  RisHisSDSvc_Jissi: TRisHisSDSvc_Jissi;
//関数手続き宣言-------------------------------------------------------------

implementation //**************************************************************

//使用ユニット---------------------------------------------------------------
//uses UDb_Ris;
{$R *.DFM}

//定数宣言       -------------------------------------------------------------
//const

//変数宣言     ---------------------------------------------------------------
//var

//関数手続き宣言--------------------------------------------------------------
//=============================================================================
//サービス関連処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  RisHisSDSvc_Jissi.Controller(CtrlCode);
end;

function TRisHisSDSvc_Jissi.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

//サービス作成
procedure TRisHisSDSvc_Jissi.ServiceCreate(Sender: TObject);
begin
  //DBクラス作成
  DB_RisSD := TDB_RisSD.Create();
  //電文格納域確保
  w_SendMsgStream := TStringStream.Create('');
  w_RecvMsgStream := TStringStream.Create('');
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
procedure TRisHisSDSvc_Jissi.ServiceDestroy(Sender: TObject);
begin
  //DBクラス作成
  if Assigned(DB_RisSD) then FreeAndNil(DB_RisSD);
  //電文域の解放
  w_SendMsgStream.Free;
  w_RecvMsgStream.Free;
  //サービス消去
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVC_NUM,
              '*****サービスを破棄しました*****');
end;
//
procedure TRisHisSDSvc_Jissi.ServiceStart(Sender: TService;
  var Started: Boolean);
begin
//
end;
//サービス停止
procedure TRisHisSDSvc_Jissi.ServiceStop(Sender: TService;
  var Stopped: Boolean);
begin
  //ログ出力
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVCDEF_NUM,
              '*****サービスを停止しました*****');
end;
//サービスインストール
procedure TRisHisSDSvc_Jissi.ServiceAfterInstall(Sender: TService);
begin
  //ログ出力
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVCDEF_NUM,
              '*****サービスをインストールしました*****');
end;
//サービスアンインストール
procedure TRisHisSDSvc_Jissi.ServiceAfterUninstall(Sender: TService);
begin
  //ログ出力
  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVCDEF_NUM,
              '*****サービスをアンインストールしました*****');
end;

//サービス実行処理
procedure TRisHisSDSvc_Jissi.ServiceExecute(Sender: TService);
var
  w_StopTimestamp:  TTimeStamp;
  w_StopDateTime:   TDateTime ;
  res:              boolean;
  w_sErr:           string;

  cnt_record:       Integer;
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
      wg_RetryCount := 0;
      ClientSocket1.Active := False;

      //サービス実行時
      while not Terminated do
      begin
        //アクティブ時のみ動作する
        if g_Svc_Ex_Acvite = g_SOCKET_ACTIVE then
        begin
          //DBをオープンする 例外を発生しないように
          if DB_RisSD.RisDBOpen(w_sErr, self) then
          begin
            proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_DB_NUM, 'DB接続OK');
            //必ず初期化
            w_SendMsgStream := TStringStream.Create('');
            w_RecvMsgStream := TStringStream.Create('');
            if wgs_IPPort = '' then
            begin
              try
                  //IPアドレス・ポートの取得
                  wgs_IPPort := func_GetServiceInfo(CST_APPID_HSND02,
                                                    FQ_SEL,
                                                    DB_RisSD.wg_DBFlg,
                                                    w_sErr);
                  //";"（区切り文字）の検索
                  wgi_Pos := Pos(CST_IPPORT_SP, wgs_IPPort);
                  //ログ出力
                  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_CL_NUM,
                              'IP = ' + Copy(wgs_IPPort, 1, wgi_Pos - 1));
                  //ログ出力
                  proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_CL_NUM,
                              'ポート = ' + Copy(wgs_IPPort, wgi_Pos + 1,
                              Length(wgs_IPPort)));
                  //サービスが終了の場合
                  if Terminated then
                  begin
                    //処理を抜ける
                    Break;
                  end;
              except
                //エラー終了処理
                on E:exception do
                begin
                  //ログ出力
                  proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                              'Socket情報取得NG「'+ E.Message + '」');
                  //サービスが終了の場合
                  if Terminated then
                  begin
                    //処理を抜ける
                    Break;
                  end;
                end;
              end;
            end;
            try
              //His送信処理
              //2.送信オーダテーブルから不要レコードを削除
              res := DB_RisSD.func_DelOrder(g_RisDB_SndEXKeep,w_sErr);
              //正常終了の場合
              if res then begin
                //ログ出力
                proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_DB_IN_NUM,'HIS送信リクエストテーブル不要レコード削除OK');
              end
              //異常終了
              else begin
                //ログ出力
                proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_NG_NUM,'HIS送信リクエストテーブル不要レコード削除NG「'+w_sErr+'」');
              end;
              //送信オーダテーブルの取得
              res := DB_RisSD.func_GetOrder(cnt_record, w_sErr);
              //正常終了の場合
              if res then
              begin
                //ログ表示
                proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_DB_NUM,
                            'HIS送信リクエストテーブル取得OK「' +
                            IntToStr(cnt_record) +
                            '件」');
                //サービス起動中で
                //レコードがあって
                //取得レコードの最後で無い場合
                while (not Terminated) and
                      (cnt_record > 0) and
                      (not (FQ_SEL_ORD.Eof)) do
                begin
                  //受信領域が作成されている場合
                  if w_RecvMsgStream <> nil then
                  begin
                    //開放
                    FreeAndNil(w_RecvMsgStream);
                  end;
                  //送信領域が作成されている場合
                  if w_SendMsgStream <> nil then
                  begin
                    //開放
                    FreeAndNil(w_SendMsgStream);
                  end;
                  //送信領域作成
                  w_SendMsgStream := TStringStream.Create('');
                  //受信領域作成
                  w_RecvMsgStream := TStringStream.Create('');

                  //4-8の処理
                  proc_Main;

                  if wg_RetryCount = 0 then
                    //次のレコードに移動
                    FQ_SEL_ORD.Next;
                end;
              end
              //異常終了の場合
              else
              begin
                proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                            '送信オーダテーブル取得NG「' + w_sErr + '」');
              end;
            Except
              //DBの切断
              DB_RisSD.RisDBClose;
              proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_DB_NUM,
                          '*****RIS DB接続を終了しました*****');
            end;
          //DBオープン失敗
          end
          else
          begin
            proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                        'RIS DB接続NG「' + w_sErr + '」');
          end;

          //受信領域が作成されている場合
          if w_RecvMsgStream <> nil then
          begin
            //開放
            FreeAndNil(w_RecvMsgStream);
          end;
          //送信領域が作成されている場合
          if w_SendMsgStream <> nil then
          begin
            //開放
            FreeAndNil(w_SendMsgStream);
          end;
          //送信領域作成
          w_SendMsgStream := TStringStream.Create('');
          //受信領域作成
          w_RecvMsgStream := TStringStream.Create('');
          //タイムスタンプの取得
          w_StopTimestamp := DateTimeToTimeStamp(now);
          //終了時刻の取得
          w_StopTimestamp.Time := w_StopTimestamp.Time + g_Svc_Ex_Cycle * 1000;
          //終了時刻の設定
          w_StopDateTime := TimeStampToDateTime(w_StopTimestamp);
          //終了時刻を越えるか、サービスが終了された場合
          while (not Terminated) and (w_StopDateTime>Now) do
          begin
            sleep(1000);
            ServiceThread.ProcessRequests(false);
          end;
          //エラーメッセージ初期化
          w_sErr := '';
        end
        else
        begin
          ServiceThread.ProcessRequests(false);
        end;
      end;
      //DBの切断
      DB_RisSD.RisDBClose;
      proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SVC_NUM,
                  '*****サービスを終了します*****');
      //処理終了
      Exit;
    except
      //DBの切断
      DB_RisSD.RisDBClose;
      //処理終了
      Exit;
    end;
  finally
    //開放
    if Assigned(FQ_SEL) then FreeAndNil(FQ_SEL);
    if Assigned(FQ_SEL_ORD) then FreeAndNil(FQ_SEL_ORD);
    if Assigned(FQ_SEL_BUI) then FreeAndNil(FQ_SEL_BUI);
    if Assigned(FQ_ALT) then FreeAndNil(FQ_ALT);
    if Assigned(FLog) then FreeAndNil(FLog);
    if Assigned(FDebug) then FreeAndNil(FDebug);
  end;
end;

//=============================================================================
//クライアントソケット処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
//クライアントソケット接続通知
procedure TRisHisSDSvc_Jissi.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_C_StatusList('OK','Connected to: ' + Socket.RemoteAddress);
end;
//クライアントソケット切断通知
procedure TRisHisSDSvc_Jissi.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_C_StatusList('OK','DisConnected to: ' + Socket.RemoteAddress);

end;
//クライアントソケットエラー通知
procedure TRisHisSDSvc_Jissi.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
              'Error...'+IntToStr(ErrorCode));
  ErrorCode:=0; //例外は発生させない
end;
//クライアントソケット応答受信通知
procedure TRisHisSDSvc_Jissi.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//非ブロッキングの処理
end;
procedure TRisHisSDSvc_Jissi.ClientSocket1Write(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//
end;
//ステータス表示
procedure TRisHisSDSvc_Jissi.proc_C_StatusList(arg_Status: string;arg_string: string);
begin
  try
    proc_LogOut(arg_Status,'',G_LOG_KIND_SK_CL_NUM,arg_string);
  except
    exit;
  end;
end;
//=============================================================================
//クライアントソケット処理↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//=============================================================================
//=============================================================================
//クライアントソケット電文送信処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
{
-----------------------------------------------------------------------------
  名前 : func_SendStream;
  引数 : なし
   arg_SendStream:TStringStream; 送信データ
   arg_SendStream_Len: Longint;  送信データ長
   arg_TimeOut   : DWORD         タイムアウト時間ms
   arg_MsgKind   : string;       電文種別
   arg_RecvStream: TStringStream 戻り受信電文
  機能 : ｿｹｯﾄ電文送信機能
  復帰値：例外は発生しない
      ｴﾗｰｺｰﾄﾞ(2桁 YY
              YY：詳細
              00：成功
              01：送信失敗
              02：無応答
              03：受信失敗
              )
-----------------------------------------------------------------------------
}
function TRisHisSDSvc_Jissi.func_SendStream(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_RecvStream: TStringStream
                    ): string;
var
   res:Longint;
   w_SocketStream:TWinSocketStream;
   w_SendStream_Buf:TBuffur;
   w_ReadStream_Buf:TBuffur;
   w_s:string;
   w_p:Longint;
begin
//例外は発生させない
//①送信 （ｿｹｯﾄOBJ）に （ｿｹｯﾄ電文文字列）を送信する。
{
 クライアントブロッキング接続とクライアント非ブロッキング接続
 のうちブロッキング接続を使う。
}
  // クライアントブロッキング接続
  try
    //書き込みｽﾄﾘｰﾑを作成
    w_SocketStream := TWinSocketStream.Create(ClientSocket1.Socket, arg_TimeOut);
    try
      arg_SendStream.Position := 0;
      arg_SendStream.Read(w_SendStream_Buf, arg_SendStream_Len);
      //書き込み
      proc_C_StatusList(G_LOG_LINE_HEAD_NP,'電文送信開始...< ' + ' >');
      res := w_SocketStream.Write(w_SendStream_Buf, arg_SendStream_Len);
      //失敗：01
      if (res < arg_SendStream_Len) then
      begin
        Result := G_TCPSND_PRTCL_ERR01;
        proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                    'Error...func_SendStream:（①不完全送信）' + Result);
        Exit;
  //①<<----
      end;
    finally
      FreeAndNil(w_SocketStream);
    end;
    proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_DEBUG_NUM,
                '送信電文 = ' + arg_SendStream.DataString);
    proc_C_StatusList(G_LOG_LINE_HEAD_NP, '送信サイズ = ' + IntToStr(res) +
                      'Byte');
    proc_C_StatusList(G_LOG_LINE_HEAD_NP, '電文送信完了...');
  except
    on E: Exception do
    begin
      Result := G_TCPSND_PRTCL_ERR01;

      proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                  'Error...func_SendStream:（②送信例外' + E.Message + '）' + Result);
      Exit;
    end;
  //②<<----
  end;
  //②応答受信
  //  スレッドを作成（返答域、タイムアウト秒数ms）して上記の返答を待つ（タイムアウト時間だけ）
  // クライアントブロッキング接続
  try
    //読込みストリームを作成
    w_SocketStream := TWinSocketStream.Create(ClientSocket1.Socket, arg_TimeOut);
    try
      //受信読込み準備
      if False = w_SocketStream.WaitForData(arg_TimeOut) then
      begin
        //タイムアウト
        Result := G_TCPSND_PRTCL_ERR02;

        proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                    'Error...func_SendStream:（③タイムアウト）' + Result);
        Exit;
  //③<<----
      end
      else
      begin//読込み
        //分割読込み必要か
        w_p := 0;
        arg_RecvStream.Position := 0;
        while (w_p < g_Stream_Base[COMMON1DENLENNO].offset) do
        begin
          res := w_SocketStream.Read(w_ReadStream_Buf, sizeof(w_ReadStream_Buf));
          if res=0 then
          begin
            Result := G_TCPSND_PRTCL_ERR02;

            proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                        'Error...func_SendStream:（④空タイムアウト）' + Result);
            Exit;
  //④<<----
          end;
          arg_RecvStream.Write(w_ReadStream_Buf, res);
          w_p := w_p + res;
        end;
        //サイズのある最小まで読めた
        arg_RecvStream.Position := g_Stream_Base[COMMON1DENLENNO].offset;

        w_s := arg_RecvStream.ReadString(g_Stream_Base[COMMON1DENLENNO].size);

        arg_RecvStream.Position := w_p;

        while (w_p - G_MSGSIZE_START < StrToIntDef(w_s, 0)) do
        begin
          res := w_SocketStream.Read(w_ReadStream_Buf,sizeof(w_ReadStream_Buf));
          arg_RecvStream.Write(w_ReadStream_Buf, res);
          w_p := w_p + res;
          if res = 0 then
            Break;
        end;

      end;
      //受信電文の長さチェック
      if w_p - G_MSGSIZE_START <> StrToIntDef(w_s, 0) then
      begin
        Result := G_TCPSND_PRTCL_ERR03;
        proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                    'Error...func_SendStream:（⑤受信電文の長）' + Result);
        Exit;
  //⑤<<----
      end;
      proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_DEBUG_NUM,
                  '受信電文 = ' + arg_RecvStream.DataString);
      proc_C_StatusList(G_LOG_LINE_HEAD_NP,
                '応答電文受信...< ' + IntToStr(arg_RecvStream.Size) + ' >Byte');
    finally
      FreeAndNil(w_SocketStream);
    end;
  //③終了処理 正常復帰の設定
    Result := G_TCPSND_PRTCL_ERR00;
    proc_C_StatusList(G_LOG_LINE_HEAD_OK, 'Complete...func_SendStream:' +
                      Result);
    Exit;
  //⑥<<----
  except
    on E: Exception do
    begin
      Result := G_TCPSND_PRTCL_ERR03;
      proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                  'Error...func_SendStream:（⑦受信例外:' + E.Message +'）' + Result);
      Exit;
  //⑦<<----
    end;
  end;
end;

(**
-----------------------------------------------------------------------------
 * @outline       func_SendMsgBase
   arg_SendStream    : TStringStream;  送信データ
   arg_SendStream_Len: Longint;       送信データ長
   arg_TimeOut       : DWORD;         タイムアウト時間ms
   arg_MsgKind       : string;        電文種別
   arg_RecvStream: TStringStream   戻り受信電文
                    ): string;
  復帰値：例外ない  ｴﾗｰｺｰﾄﾞ
  ｴﾗｰｺｰﾄﾞ(4桁 XXYY
              XX：発生位置01～07
              00：固定
                YY：詳細
                00：成功
                01：送信失敗
                02：無応答
                03：受信失敗
              )
 * 機能 : 送受信の基本関数
    1.ソケットのオープン
    2.電文送信の依頼
    3.電文受信
    4.ソケットのクローズ
 *
-----------------------------------------------------------------------------
 *)
function TRisHisSDSvc_Jissi.func_SendMsgBase(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_RecvStream: TStringStream
                    ): string;
var
  w_RtCode: string;
begin
  try
    //IPアドレスの設定
    ClientSocket1.Address := Copy(wgs_IPPort, 1, wgi_Pos - 1);
    //ポートの設定
    ClientSocket1.Port := StrToIntDef(Copy(wgs_IPPort, wgi_Pos + 1,
                                           Length(wgs_IPPort)),0);
    ClientSocket1.Active := True;
    //ソケット接続
    ClientSocket1.Open;
    //完全に終了化されるまで待つ
    repeat
      Application.ProcessMessages;
      //待機時間
      sleep(1000);
    until (ClientSocket1.Socket.Connected);
    //ログ出力
    proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_SK_CL_NUM,'Socketの接続に成功しました。');
    //プロトコル送信機能
    w_RtCode := func_SendStream(arg_SendStream, arg_SendStream_Len,
                                arg_TimeOut, arg_MsgKind, arg_RecvStream);
    Result := G_TCPSND_PRTCL00 + w_RtCode;

    proc_C_StatusList(G_LOG_LINE_HEAD_OK,'Complete...func_SendMsgBase:'+result);

    ClientSocket1.Close;
    //完全に終了化されるまで待つ
    repeat
      Application.ProcessMessages;
      Sleep(1000);
    until not(ClientSocket1.Socket.Connected);
    //ログ出力
    proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_SK_CL_NUM,'Socketの切断に成功しました。');
    Exit;
//①<<----
  except
    on E: Exception do
    begin
      Result := G_TCPSND_PRTCL00 +G_TCPSND_PRTCL_ERR01;
      proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                  'Error...func_SendMsgBase:(例外通信先異常:' + E.Message + ')' + Result);
      Exit;
    end;
//②<<----
  end;
end;
//=============================================================================
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//=============================================================================

//=============================================================================
//電文作成及び送信処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
{-----------------------------------------------------------------------------
  名前 : proc_Main;
  引数 : なし
  機能 :
  １トランザクション処理
  電文の作成と送信
  復帰値：例外は発生しない
-----------------------------------------------------------------------------}
//HISへの１電文送信処理
procedure TRisHisSDSvc_Jissi.proc_Main;
var
  res:boolean;
  w_sErr:string;
  w_result:string;
  w_orderkinf:string;
  w_sysdate:string;
  w_Flg:String;
  w_NullFlg:String;
label
  p_err,
  p_end;
begin
  //ﾄﾗﾝｻﾞｸｼｮﾝ開始
  FDB.StartTransaction;
  try
    //初期化
    w_NullFlg := '';

    proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_MS_ANLZ_NUM,
                '送信電文連番 = ' + FQ_SEL_ORD.GetString('REQUESTID'));
    //4 カレントのオーダで電文を作成する
    res := DB_RisSD.func_MakeMsg(w_SendMsgStream, w_sErr, w_NullFlg);
    //正常終了の場合
    if res then
    begin
      //電文作成データ有り
      if w_NullFlg = '' then
      begin
        proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_MS_ANLZ_NUM,
                    '送信電文の作成OK');
      end
      //電文作成データなし
      else if w_NullFlg = '1' then
      begin
        proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_NG_NUM,
        '送信電文の作成NG「電文作成のためのデータがありません。 ' + w_sErr + '」') ;
      end;
    end
    //異常終了の場合
    else
    begin
      proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                  '送信電文の作成NG「' + w_sErr + '」');
      //エラー終了
      goto p_err;
    end;
//4 電文を登録する
    //データありの場合
    if w_NullFlg = '' then
    begin
      //電文登録フラグがONの場合
      if g_Rig_LogIncMsg <> CST_SAVE_OFF then
      begin
        //電文の登録
        res := DB_RisSD.func_SaveMsg(w_SendMsgStream,w_sErr);
        //正常終了の場合
        if res then
        begin
          proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_DB_OUT_NUM,
                      '送信電文の登録OK');
        end
        //異常終了の場合
        else
        begin
          proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                      '送信電文の登録NG「' + w_sErr + '」');
          //エラー終了
          goto p_err;
        end;
      end;
    end;
    if w_NullFlg = '' then
    begin
  //5検査進捗チェック
      res := DB_RisSD.func_CheckOrder(w_sErr,w_Flg,w_NullFlg);
      //検査進捗エラーの場合
      if (w_Flg = '1') then
      begin
        proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                    '検査進捗チェックNG「' + w_sErr + '」');
      end
      //検査進捗が正しい場合
      else
      begin
        //検査データがある場合
        if w_NullFlg = '' then
        begin
          proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_DB_OUT_NUM,
                      '検査進捗チェックOK');
        end
        //データがない場合
        else
        begin
          //強制的にフラグを変更
          res := False;
          proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                      '検査進捗チェックNG「' + w_sErr + '」');
        end;
      end;
    end
    else if w_NullFlg = '2' then
    begin
      //強制的にフラグを変更
      res := False;
      proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_NG_NUM,
                  'HIS送信チェック「' + w_sErr + '」');
    end
    else
    begin
      //強制的にフラグを変更
      res := False;
    end;
    //正常終了の場合
    if res then
    begin
    //進捗チェックOK
//6 送信
      //処理区分の取得
      w_orderkinf := FQ_SEL_ORD.GetString('REQUESTTYPE');
      //初期化
      w_result := '';
      //実施電文の場合
      if (w_orderkinf = CST_APPTYPE_OP01) or
         (w_orderkinf = CST_APPTYPE_OP02) or
         (w_orderkinf = CST_APPTYPE_OP99) then
      begin
        //送信
        w_result := self.func_SendMsgBase(w_SendMsgStream,w_SendMsgStream.Size,
                                          g_C_Socket_Info_03.f_TimeOut,
                                          G_MSGKIND_JISSI,
                                          w_RecvMsgStream);
      end
      //それ以外の場合
      else
      begin
        //電文種別 処理区分 設定あやまり
        proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
        '送信処理NG「送信オーダテーブルに正しい処理区分が設定されていません」');
        //エラー終了
        goto p_err;
      end;
      //正常終了の場合
      if w_result = G_TCPSND_PRTCL00 + G_TCPSND_PRTCL_ERR00 then
      begin
        //実施電文の場合
        if (w_orderkinf = CST_APPTYPE_OP01) or
           (w_orderkinf = CST_APPTYPE_OP02) or
           (w_orderkinf = CST_APPTYPE_OP99) then
        begin
          //応答種別の取得
          w_result := func_GetStringStream(G_MSG_SYSTEM_C, G_MSGKIND_START,
                                           w_RecvMsgStream,
                                           COMMON1STATUSNO
                                           );
          //内容コードがSSの場合
          if w_result = CST_DENBUNID_OK then
          begin
            //正常終了
            proc_LogOut(G_LOG_LINE_HEAD_OK,'',G_LOG_KIND_MS_ANLZ_NUM,'正常終了');
            //OK
            w_result := CST_ORDER_RES_OK;

            wg_RetryCount := 0;
          end
          //応答種別がOK以外の場合
          else if w_result = CST_DENBUNID_NG then
          begin
            //異常終了
            proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_NG_NUM,'異常終了');
            inc(wg_RetryCount);

            wg_RetryCount := 0;
            //NG
            w_result := CST_ORDER_RES_NG2;
          end
          //応答種別がOK以外の場合
          else if w_result = CST_DENBUNID_RE then
          begin
            //異常終了
            proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_NG_NUM,'リトライ');
            inc(wg_RetryCount);

            if wg_RetryCount = g_C_Socket_Info_03.f_Retry then
            begin
              wg_RetryCount := 0;
              //NG
              w_result := CST_ORDER_RES_NG2;
            end
            else
            begin
              //NG
              w_result := CST_ORDER_RES_NG3;
            end;
          end;
        end
        //異常終了の場合
        else
        begin
          //電文種別 処理区分 設定あやまり
          proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_NG_NUM,'通信キャンセル');
          //通信エラー
          w_result := CST_ORDER_RES_CL;
        end;
      end
      //タイムアウト終了
      else if w_result = G_TCPSND_PRTCL00 + G_TCPSND_PRTCL_ERR02 then
      begin
        //タイムアウト
        proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_NG_NUM,'タイムアウト終了');
        inc(wg_RetryCount);

        if wg_RetryCount = g_C_Socket_Info_03.f_Retry then
        begin
          wg_RetryCount := 0;
          //NG
          w_result := CST_ORDER_RES_NG1;
        end
        else
        begin
          //NG
          w_result := CST_ORDER_RES_NG3;
        end;
      end
      else
      begin
        inc(wg_RetryCount);
        if wg_RetryCount = g_C_Socket_Info_03.f_Retry then
        begin
          wg_RetryCount := 0;
          //NG
          w_result := CST_ORDER_RES_NG1;
        end
        else
        begin
          //NG
          w_result := CST_ORDER_RES_NG3;
        end;
      end;
    end
    //検査進捗エラーの場合
    else
    begin
      //進捗チェック キャンセル
      w_result := CST_ORDER_RES_CL;
      wg_RetryCount := 0;
    end;
//7送信結果を送信オーダテーブルへ登録
    w_sysdate := FQ_SEL.GetSysDateYMDHNS;
    //送信結果登録
    res := DB_RisSD.func_SetOrderResult(
                            w_SendMsgStream,
                            w_sysdate,
                            w_result,
                            w_sErr);
    //正常終了の場合
    if res then
    begin
      proc_LogOut(G_LOG_LINE_HEAD_OK, '', G_LOG_KIND_DB_OUT_NUM, '送信結果の登録OK');
    end
    //異常終了の場合
    else
    begin
      proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                  '送信結果の登録NG「' + w_sErr + '」');
    end;
    //すべて正常の場合
    p_end:
      Sleep(100);
      try
        //コミット
        FDB.Commit;
      except
        raise;
      end;
      //処理終了
      Exit;
    p_err:
      Sleep(100);
      //ロールバック
      FDB.Rollback;
      //処理終了
      Exit;
  except
    on E:Exception do
    begin
      proc_LogOut(G_LOG_LINE_HEAD_NG,'',G_LOG_KIND_NG_NUM,
                  '予想外のエラーが発生しました。 ' + E.Message);
      //ロールバック
      FDB.Rollback;
      //処理終了
      Exit;
    end;
  end
end;
//=============================================================================
//↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//=============================================================================

//=============================================================================
//その他イベント処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================

//------------------------------------------------------------------------------

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
