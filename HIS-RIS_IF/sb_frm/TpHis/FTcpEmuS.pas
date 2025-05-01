unit FTcpEmuS;
interface //*****************************************************************
(**
■機能説明
公開機能
すべての機能は、フォームを作成する初期化が正常終了した後でのみ機能する
●エミュレータ初期化機能(関数)
-----------------------------------------------------------------------------
  名前 : func_TcpEmuSOpen
  引数 :
         arg_OwnForm:TForm;        親フォーム 必須
         arg_Visible:boolean;      表示モード 必須
                    gi_Rig_EmuVisible=g_RIG_EMUVISIBLE_FALSE FALSE  通常
                    gi_Rig_EmuVisible=g_RIG_EMUVISIBLE_TRUE  TRUE
         arg_Enable:boolean;       対話モード 必須
                    gi_Rig_EmuVisible=g_RIG_EMUENABLED_FALSE FALSE  通常
                    gi_Rig_EmuVisible=g_RIG_EMUENABLED_TRUE  TRUE
         arg_RcvCmdArea:TStrigList コマンド受信域 必須
  機能 : フォーム作成とサーバ初期化など通信に必要な初期化処理
  復帰値：エミュレータフォーム Nil失敗 例外有り
-----------------------------------------------------------------------------

●受信先情報設定機能（TFrm_TcpEmuのメソッド）未使用予定
 -------------------------------------------------------------------
 * @outline  proc_SetSSockInfo
 * @param arg_port:string; ポート
 * 例外あり
 * 受信側のポート情報をセットする。
 *
 -------------------------------------------------------------------

●エミュレータ終了化機能（TFrm_TcpEmuのメソッド）
  ①作成のフォームをクローズする。
  .close; 例外有り


※用語定義
電文：ソケットのTCPIP転送電文


■履歴
新規作成：2003.05.30：担当 増田
*)

//使用ユニット---------------------------------------------------------------
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ScktComp, IniFiles, ExtCtrls, Buttons,math, //FileCtrl,
  Gval,
  HisMsgDef,
  HisMsgDef01_IRAI,
  HisMsgDef02_JISSI,
  TcpSocket, FileCtrl
  ;

////型クラス宣言-------------------------------------------------------------
//フォーム
type
  TFrm_TcpEmuS = class(TForm)
    pnl_sever: TPanel;
    ServerSocket1: TServerSocket;
    pnl_cmd: TPanel;
    pnl_system: TPanel;
    pnl_err: TPanel;
    GroupBox2: TGroupBox;
    CB_DATA_ERR03: TCheckBox;
    pnl_status: TPanel;
    lbl_show_status: TLabel;
    btn_Init: TBitBtn;
    RE_setumei: TRichEdit;
    StaticText1: TStaticText;
    btn_finish: TBitBtn;
    Label11: TLabel;
    Panel1: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    REdt_RcvCmdData1: TRichEdit;
    REdt_RcvAppData1: TRichEdit;
    REdt_SStatus1: TRichEdit;
    Btn_RcvClear1: TButton;
    Btn_RcvDClear1: TButton;
    Edit_SvRvSaveFl1: TEdit;
    btn_SRsave1: TButton;
    Edit_SvSdSaveFl1: TEdit;
    btn_SSsave1: TButton;
    GroupBox1: TGroupBox;
    Panel2: TPanel;
    Label4: TLabel;
    Edt_RisIp: TEdit;
    pnl_clnte: TPanel;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    CB_DATA_ERR02: TCheckBox;
    Label3: TLabel;
    Edt_RISPort1: TEdit;
    Edt_TimOut: TEdit;
    Label5: TLabel;
    Button1: TButton;
    Chk_Auto: TCheckBox;
    Button2: TButton;
    GroupBox3: TGroupBox;
    RB_S1_6: TRadioButton;
    CheckBox1: TCheckBox;
    RB_S1_2: TRadioButton;
    RB_S1_9: TRadioButton;
    RB_S1_4: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Btn_RcvClear1Click(Sender: TObject);
    procedure Btn_RcvDClear1Click(Sender: TObject);
    procedure btn_SRsave1Click(Sender: TObject);
    procedure btn_SSsave1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_finishClick(Sender: TObject);
    procedure btn_InitClick(Sender: TObject);
    procedure Edt_TimOutChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private 宣言 }
    //制御フラグ
    w_TimeOut : Longint; //電文タイムアウト 数字
    w_CharCode: string;  //文字コード種別
    w_MsgKind : string;  //受信電文種別
    w_MsgKind2 : string;  //送信電文種別
    //サーバ受信電文域
    ServerRecieveBuf_Len : Longint;      //実電文長
    ServerRecieveBuf_LenPlan : Longint;  //予定電文長
    wg_Continue : Boolean;
    ServerRecieveBuf_Len_Work : Longint;      //実電文長（一時退避）
    ServerRecieveBuf_LenPlan_Work : Longint;  //予定電文長（一時退避）
    wg_Seq : String;
    wg_MachineName: String;
    wg_MaxDataSize: Integer;
    wg_Keizoku : String;
    //解析結果格納域
    F_PlanMsg_Len        : Longint;      //予定受信コマンドアプライ長
    F_RealMsg_Len        : Longint;      //実  受信コマンドアプライ長
    F_sMsg               : String;
    w_RecvMsgTime   : TDateTime;  // YYYY/MM/DD hh:mi:ss
    w_RecvMsgTimeS  : String;
    //function func_GetMsgKind2: string;  //コマンドアプライ保存域

  public
    { Public 宣言 }
    w_RecvArea : TStringStream;  //受信電文域
    w_SendArea : TStringStream;  //送信電文域
    wg_StringStream : TStringStream;
    //サーバ機能初期化処理
    procedure proc_Start;
    //サーバ機能終了化処理
    procedure proc_End;
    procedure proc_SetMsgKind(arg_MsgKind,arg_MsgKind2:string);
    function  func_GetMsgKind:string;
    function  func_GetMsgKind2:string;
    //
    procedure proc_SetSSockInfo(arg_port:string);
    procedure proc_AnalizeStream(
                    Sender: TObject;
                    Socket: TCustomWinSocket);
    procedure proc_SendAckStream(Sender: TObject;
                    Socket: TCustomWinSocket);
    procedure proc_S_StatusList(arg_Status:string;arg_string: string);
    procedure proc_TxtOut;
  end;

//定数宣言-------------------------------------------------------------------
//const
//  G_PKT_PTH_DEF='RIS_RIG.log'; //LOGファイル
const
  //プロトコル コマンドコード
  G_PRTCL_STRM_01 =  $1001;
  G_PRTCL_STRM_02 =  $9001;
  G_PRTCL_STRM_03 =  $1002;
  G_PRTCL_STRM_04 =  $9002;
  G_PRTCL_STRM_05 =  $1003;
  G_PRTCL_STRM_06 =  $9003;
  G_PRTCL_STRM_07 =  $1004;
  G_PRTCL_STRM_08 =  $9004;
  //プロトコル 電文復帰コード
  G_PRTCL_STRM_RTOK= $0000; //正常
  G_PRTCL_STRM_RTNG= $ffff; //エラー
  //プロトコル（手順）番号
  G_TCPSND_PRTCL00='00';
  G_TCPSND_PRTCL01='01';//準備確認
  G_TCPSND_PRTCL02='02';//準備確認応答
  G_TCPSND_PRTCL03='03';//コマンド送信
  G_TCPSND_PRTCL04='04';//コマンド送信応答
  G_TCPSND_PRTCL05='05';//データ長送信
  G_TCPSND_PRTCL06='06';//データ長送信応答
  G_TCPSND_PRTCL07='07';//データ送信
  G_TCPSND_PRTCL08='08';//データ送信応答
  //タイムアウト最小値
//  G_MINIMUN_TIMEOUT=10; //１０ms

//変数宣言-------------------------------------------------------------------
var
  Frm_TcpEmuS: TFrm_TcpEmuS;

//関数手続き宣言-------------------------------------------------------------
function func_TcpEmuSOpen(
       arg_OwnForm:TForm;      //親フォーム
       arg_Visible:String;     //表示モード
       arg_Enable:String;      //対話モード
       arg_CharCode:String;    //伝送系文字コード
       arg_Por:String;         //ポート
       arg_TimeOut:String;     //送信時タイムアウト
       arg_MsgKind:string;     //電文種別1-5
       arg_MsgKind2:string     //電文種別1-5
                         ):TFrm_TcpEmuS;
//
//
function func_TagValue(const List: TStrings; Value: string): string;

implementation //**************************************************************
{$R *.DFM}

//使用ユニット---------------------------------------------------------------
//uses
//定数宣言       -------------------------------------------------------------
//const
//変数宣言     ---------------------------------------------------------------
//var
//関数手続き宣言--------------------------------------------------------------

//======================イベント処理===========================================

//=============================================================================
//フォーム処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
procedure TFrm_TcpEmuS.FormCreate(Sender: TObject);
begin
  //例外は発生させない
  //ｲﾝｽﾀﾝｽ初期化ﾌﾟﾛﾊﾟﾃｨ等をクリア
  //送信領域初期化
  w_SendArea := nil;
  //受信領域初期化
  w_RecvArea := nil;
  //電文種別初期化
  w_MsgKind := G_MSGKIND_NONE;
  w_MsgKind2 := G_MSGKIND_NONE;
  //電文受信電文長クリア
  ServerRecieveBuf_Len := 0;
  ServerRecieveBuf_LenPlan := 0;
  //メッセージ格納域クリア
  F_sMsg := '';
  F_PlanMsg_Len := -1;
  F_RealMsg_Len := -1;
  //ファイルディレクトリを起動ディレクトリに
  FileListBox1.Directory := G_RunPath ;
  // IPアドレスを取得設定する。
  Edt_RisIp.Text := func_GetThisMachineIPAdrr;
  //送信領域クリア
  REdt_RcvAppData1.Lines.Clear;
  REdt_RcvAppData1.Clear;
  //受信領域クリア
  REdt_RcvCmdData1.Lines.Clear;
  REdt_RcvCmdData1.Clear;
end;

procedure TFrm_TcpEmuS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //メッセージ格納域解放
  F_sMsg := '';
  //終了化する。
  proc_End;
  //領域は解放する
  Action := caFree;
end;

procedure TFrm_TcpEmuS.FormDestroy(Sender: TObject);
begin
  //送信領域が作成されている場合
  if w_SendArea <> nil then
    //開放
    w_SendArea.Free;
  //受信領域が作成されている場合
  if w_RecvArea <> nil then
    //開放
    w_RecvArea.Free
end;
//[初期化]ボタン サーバ機能初期化依頼
procedure TFrm_TcpEmuS.btn_InitClick(Sender: TObject);
begin
  //初期化依頼
  proc_Start;
end;

//クリアボタン
procedure TFrm_TcpEmuS.Btn_RcvClear1Click(Sender: TObject);
begin
  //受信表示領域クリア
  REdt_RcvCmdData1.Clear;
end;
//クリアボタン
procedure TFrm_TcpEmuS.Btn_RcvDClear1Click(Sender: TObject);
begin
  //送信表示領域クリア
  REdt_RcvAppData1.Clear;
end;
//保存ボタン
procedure TFrm_TcpEmuS.btn_SRsave1Click(Sender: TObject);
begin
  //受信表示領域のデータを保存
  REdt_RcvCmdData1.Lines.SaveToFile(IncludeTrailingPathDelimiter(FileListBox1.Directory) +Edit_SvRvSaveFl1.Text);
end;
//保存ボタン
procedure TFrm_TcpEmuS.btn_SSsave1Click(Sender: TObject);
begin
  //送信表示領域のデータを保存
  REdt_RcvAppData1.Lines.SaveToFile(IncludeTrailingPathDelimiter(FileListBox1.Directory) +Edit_SvSdSaveFl1.Text);
end;
//サーバ機能停止ボタン
procedure TFrm_TcpEmuS.btn_finishClick(Sender: TObject);
begin
  //サーバ機能停止
  proc_End;
end;
//プロトコルタイムアウト変更
procedure TFrm_TcpEmuS.Edt_TimOutChange(Sender: TObject);
begin
  //変更した時間を設定
  w_TimeOut := StrToIntDef(Edt_TimOut.Text,G_MAX_STREAM_SIZE);
end;
//=============================================================================
//フォーム処理↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//=============================================================================
//=============================================================================
//サーバソケット処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
procedure TFrm_TcpEmuS.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_S_StatusList('OK','クライアントが接続されました...');
  //電文送信機能の初期化 １接続１プロトコル
  //電文のクリア
  ServerRecieveBuf_LenPlan := 0;
  ServerRecieveBuf_Len := 0;
  w_RecvArea.size := 0;
  //応答域クリア
  w_SendArea.size := 0;

  //メッセージのクリア
  F_PlanMsg_Len := 0;
  F_RealMsg_Len := 0;
  F_sMsg        := '';
end;

procedure TFrm_TcpEmuS.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //ステータス表示＆ログ出力
  proc_S_StatusList('OK','クライアントが切断されました...');
end;

procedure TFrm_TcpEmuS.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  //ステータス表示＆ログ出力
  proc_S_StatusList('NG','Error...code='+IntTostr(ErrorCode));
  //例外は発生させない
  ErrorCode := 0;
end;
//電文データブロックの受信
procedure TFrm_TcpEmuS.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  res       :Longint;
  w_TBuffur1:TBuffur;
  w_b:string;
  w_Res:Boolean;
  ws_Command:String;
  ws_OrderNo:String;
begin
  //初期化
  w_Res := True;
  //電文は一単位電文が分割されてくるので注意
  //対処としては
  //①一番始めにすべて強制的に読み取ってしまう。大きい時はスレッド占有してしまう
  //②分割して呼んで一単位電文毎に解析処理を呼び出す(採用)
  //1.受信格納
  //現在の予定電文長が０以下なら先頭を読み取り中なので予定電文長を読み込む
  //一単位電文読込み終了時に0にすること
  if ServerRecieveBuf_LenPlan <= 0 then
  begin
    //予定長までの読込みを試みる
    //１バイトまでの分割読込みに対処する
    res := Socket.ReceiveBuf(w_TBuffur1,sizeof(w_TBuffur1));
    //電文サイズまで移動
    w_RecvArea.Position := w_RecvArea.size;
    //受信領域に書き込み
    w_RecvArea.Write(w_TBuffur1,res);
    //読み込まれたﾊﾞｲﾄ長を設定
    ServerRecieveBuf_Len := ServerRecieveBuf_Len + res;
    //予定長までは読めた
    if (ServerRecieveBuf_Len >= g_Stream_Base[COMMON1DENLENNO + 1].offset) then
    begin
      //ステータス表示＆ログ出力
      proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_SV_NUM,
                  '電文受信開始...<  >');
      //ステータス表示＆ログ出力
      proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_SV_NUM,
                  '受信サイズ = ' + IntToStr(ServerRecieveBuf_Len) + 'Byte');
      //電文長まで移動
      w_RecvArea.Position := g_Stream_Base[COMMON1DENLENNO].offset;
      //電文長を取得
      w_b := w_RecvArea.ReadString(g_Stream_Base[COMMON1DENLENNO].size);
      //予定電文長取得
      ServerRecieveBuf_LenPlan := StrToInt(w_b);
      //全部は読めていないので再読込みを待つ
      if ServerRecieveBuf_LenPlan > ServerRecieveBuf_Len - G_MSGSIZE_START then
      begin
        //処理終了
        Exit;
//＜＜－－再読込み待ち：
      end;
    end
    //予定長までは読めなかったのでもう一度読む必要がある
    else
    begin
      //抜けて電送されてくるのを待つ
      Exit;
//＜＜－－再読込み待ち：
    end;
  end;
//再度途中の電文読み込み
  if ServerRecieveBuf_LenPlan > ServerRecieveBuf_Len  - G_MSGSIZE_START then
  begin
    //再度読む必要がある
    res := Socket.ReceiveBuf(w_TBuffur1,sizeof(w_TBuffur1));
    //１バイトまでの分割読込みに対処する
    w_RecvArea.Position := w_RecvArea.size;
    //受信領域に書き込み
    w_RecvArea.Write(w_TBuffur1,res);
    //読み込まれたﾊﾞｲﾄ長を設定
    ServerRecieveBuf_Len := ServerRecieveBuf_Len + res;
  end;

  //まだ途中なのかをしらべる
  if (ServerRecieveBuf_LenPlan > ServerRecieveBuf_Len - G_MSGSIZE_START) then
  begin
    //ステータス表示＆ログ出力
    proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_SV_NUM,
                '受信サイズ = ' + IntToStr(ServerRecieveBuf_Len - G_MSGSIZE_START) + 'Byte');
    //処理終了
    Exit;
//＜＜－－再読込み待ち：
  end;


  //実送信電文と予定との比較
  if (ServerRecieveBuf_Len - G_MSGSIZE_START) <> ServerRecieveBuf_LenPlan then
  begin
    //ログ文字列作成
    proc_StrConcat(F_sMsg,'「電文長異常NG（電文長＝' +
                   IntToStr(ServerRecieveBuf_Len - G_MSGSIZE_START) + '：電文長項目＝' +
                   IntToStr(ServerRecieveBuf_LenPlan) + '）」');
  end
  else
  begin
    wg_StringStream := TStringStream.Create('');
    //w_RecvAreaに一単位電文が読み込まれた。
    //ステータス表示＆ログ出力
    proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_SV_NUM, '受信サイズE = ' +
                IntToStr(Length(w_RecvArea.DataString)) + 'Byte');
    //ステータス表示＆ログ出力
    proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_SV_NUM,
                '電文受信完了...');
  end;
  //電文解析依頼
  proc_AnalizeStream(Sender,Socket);
  proc_SendAckStream(Sender,Socket);
  //一単位電文クリア但し現電文は残す 強制読込みのため
  //一単位電文の受信終了を意味する
  ServerRecieveBuf_LenPlan := 0;
  ServerRecieveBuf_Len := 0;
  wg_MaxDataSize := 0;
  //受信領域の初期化
  w_RecvArea.size := 0;
  //送信領域の初期化
  w_SendArea.size := 0;
  //受信電文一時退避初期化
  wg_StringStream.size := 0;
  //継続終了
  wg_Continue := False;
  //実電文長（一時退避）初期化
  ServerRecieveBuf_Len_Work := 0;
  //予定電文長（一時退避）初期化
  ServerRecieveBuf_LenPlan_Work := 0;
  //エラーログ文字列初期化
  F_sMsg := '';
  //処理終了
  Exit;
end;
procedure TFrm_TcpEmuS.ServerSocket1ClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//w_RecvArea 受信域を解析して応答を送信することを依頼する。（未動作）
//  proc_SendAckStream(Sender,Socket);

end;
//一単位電文の解析と対処
procedure TFrm_TcpEmuS.proc_AnalizeStream(Sender: TObject;
  Socket: TCustomWinSocket);
var
  w_s:string;
  w_DataSize:Longint;
label p_end;

begin
//in:w_RecvArea  ServerRecieveBuf_Len
//out:w_Stream_Ack送信  F_Msg → REdt_RcvCmdData / REdt_RcvAppData
//w_RecvArea現状の受信電文より解析
//受信電文がない時は即時復帰
//サーバ側は受信電文に対する応答は常に固定されている。（ペアーになっている）
  //ステータス表示＆ログ出力
  proc_S_StatusList('  ','電文解析開始...');
  //電文読み込みがない場合(電文長-1)
  if ServerRecieveBuf_Len = -1 then begin
    //ステータス表示＆ログ出力
    proc_S_StatusList('NG','電文解析完了...電文無し-1');
    //処理終了
    Exit;
  end;
  //電文読み込みがない場合(電文長0)
  if ServerRecieveBuf_Len = 0 then begin
    //ステータス表示＆ログ出力
    proc_S_StatusList('NG','電文解析完了...電文無し0');
    //処理終了
    Exit;
  end;
  //予定電文長まで読み込めない場合
  if ServerRecieveBuf_Len - G_MSGSIZE_START < ServerRecieveBuf_LenPlan then begin
    //ステータス表示＆ログ出力
    proc_S_StatusList('NG','電文解析完了...電文不完全');
    //処理終了
    Exit;
  end;
  //CB_DATA_ERR02 タイムアウト
  if CB_DATA_ERR02.Checked then begin
    //ステータス表示＆ログ出力
    proc_S_StatusList('NG','電文解析開始失敗...タイムアウト');
    //ステータス表示＆ログ出力
    proc_S_StatusList('  ','電文解析完了...');
    //現状電文のない状態にしてタイムアウトにする
    ServerRecieveBuf_LenPlan := 0;
    ServerRecieveBuf_Len := 0;
    //受信領域クリア
    w_RecvArea.size := 0;
    //応答域クリア
    w_SendArea.Size := 0;
    //処理終了
    Exit;
  end;

  //w_RecvArea作成 エラー長さ不一致
  //電文長項目に移動
  w_RecvArea.Position := g_Stream_Base[COMMON1DENLENNO].offset;
  //電文長項目分読み込み
  w_s := w_RecvArea.ReadString(g_Stream_Base[COMMON1DENLENNO].size);
  //送信予定電文長
  w_DataSize := StrToIntDef(w_s,0);
  //実送信電文と予定との比較
  if (ServerRecieveBuf_Len- G_MSGSIZE_START) <> w_DataSize then begin
    //ステータス表示＆ログ出力
    proc_S_StatusList('NG','電文解析開始失敗...長さ不一致 size:' + w_s);
    //p_end処理
    goto p_end;
  end;
//受信電文の保存 表示
  try
{
    //格納前に符号化変換の必要な場合は変換する
    if g_RIG_CHARCODE_JIS=gi_Rig_CharCode then
    begin
      F_sMsg:=proc_SisToJis(w_SendArea);
    end;
}
    w_MsgKind := func_GetMsgKind;
    w_MsgKind2 := func_GetMsgKind2;
    //受信ﾒｯｾｰｼﾞをエミュレータに表示
    REdt_RcvCmdData1.Lines.BeginUpdate;
    //電文の空チェック
    if func_IsNullStr(w_RecvArea.DataString) then begin
      //空表示
      REdt_RcvCmdData1.Lines.Add('*空*');
    end
    else begin
      //TStringStreamより解析してTStringListを作成
      proc_TStrmToStrlist(w_RecvArea,TStringList(REdt_RcvCmdData1.Lines),G_MSG_SYSTEM_C,w_MsgKind);
    end;
    //変更終了
    REdt_RcvCmdData1.Lines.EndUpdate;
    //再表示
    REdt_RcvCmdData1.Refresh;
    //自動保存ありの場合
    if CheckBox1.Checked then
      proc_TxtOut;
    //ステータス表示＆ログ出力
    proc_LogOut('  ','',G_LOG_KIND_SK_CL_NUM,w_RecvArea.DataString);
  except
    //ステータス表示＆ログ出力
    proc_S_StatusList('NG','電文解析開始失敗...' );
    //処理終了
    Exit;
  end;
  //受信電文が正常なので
  //w_SendAreaに電文を作成する
  if (REdt_RcvAppData1.Lines.Count > 0) and
     (self.Visible)                     and
     (self.Enabled)                     then begin
    //対話操作時には電文を画面上にあれば画面上から設定する
    //自動返答に対応
    if (Chk_Auto.Checked)               and        //自動返信で
       (FileListBox1.Items.Count >  0 ) and        //有って
       (FileListBox1.ItemIndex   >= 0 ) then begin //選択されている
      //ファイルリストで選択されているファイルを読み込む
      REdt_RcvAppData1.Lines.LoadFromFile(FileListBox1.FileName);
      //次のファイルがある場合
      if (FileListBox1.ItemIndex < (FileListBox1.Items.Count-1)) then
        //次のファイルを選択
        FileListBox1.ItemIndex := FileListBox1.ItemIndex + 1
      else
        //最初のファイルを選択
        FileListBox1.ItemIndex := 0;
    end;
    //TStringListより解析してTStringStreamを作成
    proc_TStrListToStrm(TStringList(REdt_RcvAppData1.Lines),w_SendArea,
                        G_MSG_SYSTEM_A,w_MsgKind2);
  end
  else begin
    //画面上に設定する
    proc_TStrmToStrlist(w_SendArea,TStringList(REdt_RcvAppData1.Lines),
                        G_MSG_SYSTEM_A,w_MsgKind2
                        );
  end;

  //CB_DATA_ERR03 返答電文の長さ不一致
  if CB_DATA_ERR03.Checked then begin
    //サイズ設定
    w_SendArea.Size := 100;
    //ステータス表示＆ログ出力
    proc_S_StatusList('NG', '返答電文長さ不一致...' );
    //p_end処理
    goto p_end;
  end;
  //p_end処理
  goto p_end;
    //処理終了
    Exit;
  p_end:
    //ステータス表示＆ログ出力
    proc_S_StatusList('  ','電文解析完了...');
    //処理終了
    Exit;
end;

//一単位電文の解析と対処
procedure TFrm_TcpEmuS.proc_SendAckStream(Sender: TObject;
  Socket: TCustomWinSocket);
var
  w_Buffer:TBuffur;
  res:integer;
begin
  //ステータス表示＆ログ出力
  proc_S_StatusList('  ','応答電文送信開始...');
  //送信電文なしの場合
  if w_SendArea.size = 0 then begin
    //ステータス表示＆ログ出力
    proc_S_StatusList('  ','応答電文送信完了...応答電文なし');
    //処理終了
    Exit;
  end;
  //初期位置に移動
  w_SendArea.Position := 0;
  //データの読み出し
  w_SendArea.Read( w_Buffer,  w_SendArea.size);
  //電文書き込み
  res := Socket.SendBuf(w_Buffer,w_SendArea.size);
  //ステータス表示＆ログ出力
  proc_S_StatusList('  ','応答電文送信...< '+ intToStr(res) +' > ');
end;

//ステータス表示
procedure TFrm_TcpEmuS.proc_S_StatusList(arg_Status: string;arg_string: string);
begin
  try
    //表示可で使用可の場合
    if (self.visible) and (self.Enabled) then begin
      //変更開始
      REdt_SStatus1.Lines.BeginUpdate;
      //ステータス設定
      REdt_SStatus1.Lines.Add(arg_string);
      //変更終了
      REdt_SStatus1.Lines.EndUpdate;
      //再表示
      REdt_SStatus1.Refresh;
    end;
    //ステータス表示＆ログ出力
    proc_LogOut( arg_Status,'',G_LOG_KIND_SK_SV_NUM, arg_string );
  except
    //処理終了
    Exit;
  end;
end;

//=============================================================================
//サーバソケット処理↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//=============================================================================

//======================イベント以外のPUBLIC処理===============================

//=============================================================================
//初期／終了化処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
(**
 -------------------------------------------------------------------
 * @outline  proc_Start
 * @param なし
 * フォーム作成以外のサーバ初期化など通信に必要な初期化処理
 *
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmuS.proc_Start;
begin
  //ソケットを閉じる
  ServerSocket1.Close;
  //完全に終了化されるまで待つ
  while ServerSocket1.Active do begin
    //待機時間
    proc_delay(1000);
  end;
  // サーバーを開始
  //ポートの設定
  ServerSocket1.Port := StrToInt(Edt_RISPort1.Text);
  //ソケット開始
  ServerSocket1.Open;
  //完全に初期化されるまで待つ
  while not(ServerSocket1.Socket.Connected) do begin
    //待機時間
    proc_delay(1000);
  end;
  //サーバの状態表示
  lbl_show_status.Caption := 'サーバ機能初期化';
  lbl_show_status.Font.Color:=clRed;
end;
(**
 -------------------------------------------------------------------
 * @outline  proc_End
 * @param なし
 * サーバ終了化など通信に必要な終了化処理
 *
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmuS.proc_End;
begin
  ServerSocket1.close;
  //完全に終了化されるまで待つ
  while ServerSocket1.Socket.Connected do begin
    //待機時間
    proc_delay(1000);
  end;
  //サーバの状態表示
  lbl_show_status.Caption := 'サーバ機能 未初期化';
  lbl_show_status.Font.Color := clWindowText;

end;
//=============================================================================
//初期／終了化処理↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//=============================================================================
//=============================================================================
//その他公開メソッド↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
(**
 -------------------------------------------------------------------
 * @outline  proc_SetMsgKind
 * @param    arg_MsgKind:string;
 * 例外あり
 * 送信電文の種別を設定し表示する
 * あくまで種別を表示するのみ
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmuS.proc_SetMsgKind(arg_MsgKind,arg_MsgKind2:string);
begin
   //無選択の状態にする
   RB_S1_2.Checked := False;
   //無選択の状態にする
   RB_S1_4.Checked := False;
   //無選択の状態にする
   RB_S1_9.Checked := False;
   //指示種別を選択する
   //種別が受付電文の場合
   if arg_MsgKind = G_MSGKIND_UKETUKE then begin
     //受付チェック
     RB_S1_2.Checked := True;
   end;
   //種別が実施電文の場合
   if arg_MsgKind = G_MSGKIND_JISSI then begin
     //実施チェック
     RB_S1_4.Checked := True;
   end;
   //種別が接続・切断電文の場合
   if arg_MsgKind = G_MSGKIND_START then begin
     //接続・切断チェック
     RB_S1_9.Checked := True;
   end;
   //種別設定
   w_MsgKind := arg_MsgKind;
   //無選択の状態にする
   RB_S1_6.Checked := False;
   //指示種別を選択する
   //種別が依頼情報電文の場合
   if arg_MsgKind2 = G_MSGKIND_START then begin
     //依頼チェック
     RB_S1_6.Checked := True;
   end;
   //種別が受付電文の場合
   if arg_MsgKind2 = G_MSGKIND_UKETUKE then begin
     //受付チェック
     RB_S1_6.Checked := True;
   end;
   //種別が会計電文の場合
   if arg_MsgKind2 = G_MSGKIND_KAIKEI then begin
     //会計チェック
     RB_S1_6.Checked := True;
   end;
   //種別が実施電文の場合
   if arg_MsgKind2 = G_MSGKIND_JISSI then begin
     //実施チェック
     RB_S1_6.Checked := True;
   end;
   //種別が再送電文の場合
   if arg_MsgKind2 = G_MSGKIND_RESEND then begin
     //会計チェック
     RB_S1_6.Checked := True;
   end;
   //種別設定
   w_MsgKind2 := arg_MsgKind2;
end;
(**
 -------------------------------------------------------------------
 * @outline  func_GetMsgKind
 * @param    arg_MsgKind:string;
 * 例外あり
 * 現画面の受信電文の種別を取得する
 -------------------------------------------------------------------
 *)
function TFrm_TcpEmuS.func_GetMsgKind:string;
begin
   //無選択の状態にする
   Result := G_MSGKIND_NONE;
   //指示種別を選択する
   //受付がチェックされている場合
   if RB_S1_2.Checked then begin
     //受付電文
     Result := G_MSGKIND_UKETUKE;
   end;
   //実施がチェックされている場合
   if RB_S1_4.Checked then begin
     //実施電文
     Result := G_MSGKIND_JISSI;
   end;
   //接続・切断がチェックされている場合
   if RB_S1_9.Checked then begin
     //接続・切断電文
     Result := G_MSGKIND_START;
   end;
end;
(**
 -------------------------------------------------------------------
 * @outline  func_GetMsgKind2
 * @param    arg_MsgKind:string;
 * 例外あり
 * 現画面の送信電文の種別を取得する
 -------------------------------------------------------------------
 *)
function TFrm_TcpEmuS.func_GetMsgKind2:string;
begin
   //無選択の状態にする
   Result := G_MSGKIND_NONE;
   //指示種別を選択する
   //依頼がチェックされている場合
   if RB_S1_6.Checked then begin
     //依頼情報電文
     Result := G_MSGKIND_START;
   end;
end;
(**
 -------------------------------------------------------------------
 * @outline  proc_SetSSockInfo
 * @param arg_port:string; ポート
 * 例外あり
 * 受信側のポート情報をセットする。
 *
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmuS.proc_SetSSockInfo(arg_port:string);
begin
  //サーバ機能停止
  self.proc_End;
  //ポートの再設定
  Edt_RISPort1.text := arg_port;
  //サーバ機能開始
  self.proc_Start;
end;

//=============================================================================
//その他公開メソッド↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//=============================================================================

//======================イベント以外のPRIVATE処理==============================

//======================オブジェクトでない関数等===============================

//=============================================================================
//公開関数↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
{
-----------------------------------------------------------------------------
  名前 : func_TagValue;
  引数 : List  : 受信データ
        : Value : タグ
  機能 : 受信電文から指定タグの値を取得する。
-----------------------------------------------------------------------------
}
function func_TagValue(const List: TStrings; Value: string): string;
var
  n: Integer;
begin
  n:=List.IndexOfName(Value);
  if n<0 then
    Result:=''
  else
    Result:=List.Values[Value];
end;
{
-----------------------------------------------------------------------------
  名前 : func_TcpEmuOpen
  引数 :
         arg_OwnForm:TForm;        親フォーム 必須
         arg_Visible:boolean;      表示モード 必須
         arg_Enable:boolean;       対話モード 必須
         arg_RcvCmdArea:TStrigList コマンド受信域 必須
  機能 : フォーム作成以外のサーバ初期化など通信に必要な初期化処理
  復帰値：エミュレータフォーム Nil失敗
-----------------------------------------------------------------------------
}
function func_TcpEmuSOpen(
       arg_OwnForm:TForm;      //親フォーム
       arg_Visible:String;     //表示モード
       arg_Enable:String;      //対話モード
       arg_CharCode:String;    //伝送系文字コード
       arg_Por:String;         //ポート
       arg_TimeOut:String;     //送信時タイムアウト
       arg_MsgKind:string;     //電文種別1-5
       arg_MsgKind2:string     //電文種別1-5
                         ):TFrm_TcpEmuS;
var
  w_TFrm_TcpEmu :TFrm_TcpEmuS;
begin
//フォームの作成
  w_TFrm_TcpEmu := TFrm_TcpEmuS.Create(arg_OwnForm);
  try
    //表示可能な場合
    if arg_Visible = g_SOCKET_EMUVISIBLE_TRUE then
      //表示可
      w_TFrm_TcpEmu.Visible := True
    //それ以外の場合
    else
      //表示不可
      w_TFrm_TcpEmu.Visible := False;
    //使用可能な場合
    if arg_Enable = g_SOCKET_EMUENABLED_TRUE then
      //使用可
      w_TFrm_TcpEmu.Enabled := True
    //それ以外の場合
    else
      //使用不可
      w_TFrm_TcpEmu.Enabled := False;
    //コード体系の設定
    w_TFrm_TcpEmu.w_CharCode        := arg_CharCode;
    //ポート設定
    w_TFrm_TcpEmu.Edt_RISPort1.Text := arg_Por;
    //タイムアウト設定
    w_TFrm_TcpEmu.Edt_TimOut.Text   := arg_TimeOut;
    //電文種別設定
    w_TFrm_TcpEmu.proc_SetMsgKind( arg_MsgKind,arg_MsgKind2 );
    //受信領域初期化
    w_TFrm_TcpEmu.w_RecvArea := TStringStream.Create('');
    //送信領域初期化
    w_TFrm_TcpEmu.w_SendArea := TStringStream.Create('');

//初期化処理
    w_TFrm_TcpEmu.proc_Start;
    //戻り値
    Result := w_TFrm_TcpEmu;
    //処理終了
    Exit;
//①<<----
   except
     //フォーム終了
     w_TFrm_TcpEmu.Close;
     raise;
//②<<----
   end;
end;
//=============================================================================
//公開関数↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//=============================================================================
procedure TFrm_TcpEmuS.Button1Click(Sender: TObject);
begin
  //送信領域にファイルリストで選択されているファイルのデータを読み込む
  REdt_RcvAppData1.Lines.LoadFromFile(FileListBox1.FileName);
end;

procedure TFrm_TcpEmuS.Button2Click(Sender: TObject);
begin
  //通信ステータス領域クリア
  REdt_SStatus1.Clear;
end;

procedure TFrm_TcpEmuS.proc_TxtOut;
var
  w_s:TStrings;
begin
  //受信表示領域のデータを保存
  REdt_RcvCmdData1.Lines.SaveToFile(IncludeTrailingPathDelimiter(FileListBox1.Directory) + FormatDateTime('yyyymmddhhnnsszzz',Now) + '.txt');
  w_s := TStringList.Create;
  try
    w_s.Add(w_RecvArea.DataString);
    //受信表示領域のデータを保存
    w_s.SaveToFile(IncludeTrailingPathDelimiter(FileListBox1.Directory) + 'A' + FormatDateTime('yyyymmddhhnnsszzz',Now) + '.txt');
  finally
    FreeAndNil(w_s);
  end;
end;

end.
