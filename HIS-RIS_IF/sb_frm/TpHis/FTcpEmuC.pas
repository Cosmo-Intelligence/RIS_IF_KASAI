unit FTcpEmuC;
interface //*****************************************************************
(**
■機能説明
公開機能
すべての機能は、フォームを作成する初期化が正常終了した後でのみ機能する
●エミュレータ初期化機能(関数)
-----------------------------------------------------------------------------
  名前 : func_TcpEmuCOpen
  引数 :
         arg_OwnForm:TForm;        親フォーム 必須
         arg_Visible:boolean;      表示モード 必須
                    g_Rig_EmuVisible=g_RIG_EMUVISIBLE_FALSE FALSE  通常
                    g_Rig_EmuVisible=g_RIG_EMUVISIBLE_TRUE  TRUE
         arg_Enable:boolean;       対話モード 必須
                    g_Rig_EmuVisible=g_RIG_EMUENABLED_FALSE FALSE  通常
                    g_Rig_EmuVisible=g_RIG_EMUENABLED_TRUE  TRUE
         arg_ServerIP:Strig;       コマンド受信域 必須
         arg_ServerPort:Strig      コマンド受信域 必須
  機能 :
   フォーム作成と通信に必要な初期化処理
  復帰値：
   エミュレータフォーム Nil失敗 例外有り
-----------------------------------------------------------------------------

●送信先情報設定機能（TFrm_TcpEmuCのメソッド）
 -------------------------------------------------------------------
 * @outline  proc_SetCSockInfo
 * @param arg_ip:string;
 * @param arg_port:string;
 * 送信先の情報をセットする。func_SendMsgの前に行うと有効になる
 *
 -------------------------------------------------------------------

●電文送信受信機能（TFrm_TcpEmuCのメソッド）
-----------------------------------------------------------------------------
  名前 : func_SendMsg;
  引数 :
   arg_SendStream    : TStringStream;  送信データ
   arg_SendStream_Len: Longint;       送信データ長
   arg_TimeOut       : DWORD;         タイムアウト時間ms
   arg_MsgKind       : string;        電文種別
   arg_RecvStream: TStringStream   戻り受信電文

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
 * 機能 : 外部公開最上部
    1.送信電文をモ－ドで表示域に表示
    2.送信/受信処理の依頼
    3.受信電文をモ－ドで表示域に表示
 *
-----------------------------------------------------------------------------

●エミュレータ終了化機能（TFrm_TcpEmuCのメソッド）
  ●作成のフォームをクローズする。
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
// 構造型
//フォーム
type
  TFrm_TcpEmuC = class(TForm)
    ClientSocket1: TClientSocket;
    pnl_cmd: TPanel;
    StaticText1: TStaticText;
    pnl_clnte: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lbl_CsokStat: TLabel;
    Label7: TLabel;
    Edt_SrvIp1: TEdit;
    Edt_SrvPort1: TEdit;
    Edt_TimeOut: TEdit;
    REdt_CStatus: TRichEdit;
    REdt_SndCmdData: TRichEdit;
    btn_SendCmd: TBitBtn;
    REdt_RcvMsgData: TRichEdit;
    btn_CmdRead: TButton;
    btn_CmdClear: TButton;
    btn_RcvClear: TButton;
    Edit1: TEdit;
    btn_CmdSave: TButton;
    Edit2: TEdit;
    btn_RcvSave: TButton;
    btn_Cmd_Sjis: TButton;
    btn_Rcv_Sjis: TButton;
    btn_Cmd_Jis: TButton;
    btn_Rcv_Jis: TButton;
    GroupBox5: TGroupBox;
    RB_C1_1: TRadioButton;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    RE_setumei: TRichEdit;
    Button1: TButton;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    RB_C1_6: TRadioButton;
    GroupBox2: TGroupBox;
    CB_DATA_ERR01: TCheckBox;
    BitBtn1: TBitBtn;
    RB_C1_2: TRadioButton;
    RB_C1_7: TRadioButton;
    RB_C1_3: TRadioButton;
    RB_C1_S: TRadioButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure btn_SendCmdClick(Sender: TObject);
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocket1Write(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Edt_TimeOutChange(Sender: TObject);
    procedure btn_CmdReadClick(Sender: TObject);
    procedure btn_CmdClearClick(Sender: TObject);
    procedure btn_RcvClearClick(Sender: TObject);
    procedure btn_CmdSaveClick(Sender: TObject);
    procedure btn_RcvSaveClick(Sender: TObject);
    procedure btn_Cmd_SjisClick(Sender: TObject);
    procedure btn_Rcv_SjisClick(Sender: TObject);
    procedure btn_Cmd_JisClick(Sender: TObject);
    procedure btn_Rcv_JisClick(Sender: TObject);
    procedure Edt_SrvIp1Change(Sender: TObject);
    procedure Edt_SrvPort1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private 宣言 }
    w_TimeOut : Longint; //電文タイムアウト 数字
    w_CharCode: string;  //文字コード種別
    w_MsgKind : string;  //送信電文種別
    w_MsgKind2: String;  //受信電文種別
  public
    { Public 宣言 }
    w_SendArea : TStringStream;  //送信電文域
    w_RecvArea : TStringStream;  //受信電文域
    w_RtCod   : String;

    procedure proc_SetMsgKind(arg_MsgKind,arg_MsgKind2:string);
    function  func_GetMsgKind:string;
    function  func_GetMsgKind2:string;
    //
    procedure proc_SetCSockInfo(arg_ip:string;arg_port:string);
    //送信受信機能
    function func_SendMsg(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_MsgKind2      : string;
                    arg_RecvStream: TStringStream
                    ): string;
    function func_SendMsgBase(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_MsgKind2      : string;
                    arg_RecvStream: TStringStream
                    ): string;
    function func_SendStream(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_MsgKind2      : string;
                    arg_RecvStream: TStringStream
                    ): string;
    function func_SendStream2(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_MsgKind2      : string;
                    arg_RecvStream: TStringStream
                    ): string;
    function func_ToolVErr: string;
    procedure proc_C_StatusList(arg_Status: string;arg_string: string);
    procedure proc_RB_Click;
  end;

//定数宣言-------------------------------------------------------------------
//const
  //タイムアウト最小値
  //G_MINIMUN_TIMEOUT=10; //１０ms
//変数宣言-------------------------------------------------------------------
var
  Frm_TcpEmuC: TFrm_TcpEmuC;

//関数手続き宣言-------------------------------------------------------------
function func_TcpEmuCOpen(
       arg_OwnForm:TComponent;      //親フォーム
       arg_Visible:String;    //表示モード
       arg_Enable:String;     //対話モード
       arg_CharCode:String;    //伝送系文字コード
       arg_IP:String;          //相手IP
       arg_Por:String;         //相手ポート
       arg_TimeOut:String;     //送信時タイムアウト
       arg_MsgKind:string;      //送信電文種別1-5
       arg_MsgKind2:string      //受信電文種別1-5
                         ):TFrm_TcpEmuC;
//
function func_TagValue(const List: TStrings; Value: string): string;
//

implementation

//**************************************************************
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
procedure TFrm_TcpEmuC.FormCreate(Sender: TObject);
begin
  //例外は発生させない
  //ｲﾝｽﾀﾝｽ初期化ﾌﾟﾛﾊﾟﾃｨ等をクリア
  w_MsgKind  := G_MSGKIND_NONE;
  w_MsgKind2 := G_MSGKIND_NONE;
  //ファイルボックス初期設定
  FileListBox1.Directory := G_RunPath;
  //電文送信領域初期化
  w_SendArea := nil;
  //電文受信領域初期化
  w_RecvArea := nil;
end;
procedure TFrm_TcpEmuC.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //領域は解放する
  Action := caFree;
end;
procedure TFrm_TcpEmuC.FormDestroy(Sender: TObject);
begin
  //電文送信領域が作成されている場合
  if w_SendArea <> nil then
    //領域の開放
    w_SendArea.Free;
  //電文受信領域が作成されている場合
  if w_RecvArea <> nil then
    //領域の開放
    w_RecvArea.Free
end;
//[コマンド送信]ボタン
procedure TFrm_TcpEmuC.btn_SendCmdClick(Sender: TObject);
begin
  //ソケットの最初期化
  w_RtCod := '';
  //サーバIP設定
  ClientSocket1.Address := Edt_SrvIp1.Text;
  //サーバポート設定
  ClientSocket1.Port := StrToInt(Edt_SrvPort1.Text);
  if w_SendArea <> nil then
  begin
    FreeAndNil(w_SendArea);
    //電文送信領域初期化
    w_SendArea := TStringStream.Create('');
  end;
  if w_RecvArea <> nil then
  begin
    FreeAndNil(w_RecvArea);
    //電文送信領域初期化
    w_RecvArea := TStringStream.Create('');
  end;
  proc_RB_Click;
  //電文取得
  proc_TStrListToStrm(TStringList(REdt_SndCmdData.Lines),w_SendArea,
                      G_MSG_SYSTEM_C,w_MsgKind
                      );
  //電文送信
  w_RtCod := func_SendMsgBase(w_SendArea,w_SendArea.Size,w_TimeOut,
                              func_GetMsgKind,func_GetMsgKind2,w_RecvArea
                              );
  //LOGにも出力する。
  proc_LogOut('  ','',G_LOG_KIND_SK_CL_NUM,w_SendArea.DataString);
  //TStringStreamより解析してTStringListを作成
  proc_TStrmToStrlist(w_RecvArea,TStringList(REdt_RcvMsgData.Lines),
                      G_MSG_SYSTEM_A,w_MsgKind2
                      );
  //状態表示変更 切断
  lbl_CsokStat.Caption := '';
  //状態表示変更 切断
  lbl_CsokStat.Caption := lbl_CsokStat.Caption +' = '+ w_RtCod;
  //再表示
  lbl_CsokStat.Refresh;
end;
//プロトコルタイムアウト変更
procedure TFrm_TcpEmuC.Edt_TimeOutChange(Sender: TObject);
begin
  //タイムアウト時間を設定
  w_TimeOut := StrToIntDef(Edt_TimeOut.Text,G_MAX_STREAM_SIZE);
end;
//相手サーバIPの変更
procedure TFrm_TcpEmuC.Edt_SrvIp1Change(Sender: TObject);
begin
  //サーバIPを設定
  ClientSocket1.Address := Edt_SrvIp1.text;
end;
//相手サーバポートの変更
procedure TFrm_TcpEmuC.Edt_SrvPort1Change(Sender: TObject);
begin
  //サーバポートを設定
  ClientSocket1.Port := StrToInt(Edt_SrvPort1.text);
end;
//読み込みボタン
procedure TFrm_TcpEmuC.btn_CmdReadClick(Sender: TObject);
begin
  //ファイルボックスで選択されているファイルを表示
  REdt_SndCmdData.Lines.LoadFromFile(FileListBox1.FileName);
end;
//クリアボタン
procedure TFrm_TcpEmuC.btn_CmdClearClick(Sender: TObject);
begin
  //送信表示領域をクリア
  REdt_SndCmdData.Clear;
end;
//保存ボタン
procedure TFrm_TcpEmuC.btn_CmdSaveClick(Sender: TObject);
begin
  //ファイルボックスで選択された場所に指定のファイル名で送信領域のデータを保存する
  REdt_SndCmdData.Lines.SaveToFile(IncludeTrailingPathDelimiter(FileListBox1.Directory) + Edit1.Text);
end;
//SJISボタン？
procedure TFrm_TcpEmuC.btn_Cmd_SjisClick(Sender: TObject);
begin
  REdt_SndCmdData.Lines.BeginUpdate;
  REdt_SndCmdData.Lines.Text := func_MakeSJIS;
  REdt_SndCmdData.Lines.EndUpdate;
end;
//JISコードボタン？
procedure TFrm_TcpEmuC.btn_Cmd_JisClick(Sender: TObject);
var
  w_s:string;
begin
  REdt_SndCmdData.Lines.BeginUpdate;
  w_s := REdt_SndCmdData.Lines.Text;
  REdt_SndCmdData.Lines.Text := func_SJisToJis(w_s);
  REdt_SndCmdData.Lines.EndUpdate;
end;
//クリアボタン
procedure TFrm_TcpEmuC.btn_RcvClearClick(Sender: TObject);
begin
  //受信表示領域をクリア
  REdt_RcvMsgData.Clear;
end;
//保存ボタン
procedure TFrm_TcpEmuC.btn_RcvSaveClick(Sender: TObject);
begin
  //ファイルボックスで選択された場所に指定のファイル名で受信領域のデータを保存する
  REdt_RcvMsgData.Lines.SaveToFile(IncludeTrailingPathDelimiter(FileListBox1.Directory) +Edit2.Text);
end;
//SJISボタン？
procedure TFrm_TcpEmuC.btn_Rcv_SjisClick(Sender: TObject);
begin
  REdt_RcvMsgData.Lines.BeginUpdate;
  REdt_RcvMsgData.Lines.Text := func_MakeSJIS;
  REdt_RcvMsgData.Lines.EndUpdate;
end;
//JISボタン？
procedure TFrm_TcpEmuC.btn_Rcv_JisClick(Sender: TObject);
var
  w_s:string;
begin
  REdt_RcvMsgData.Lines.BeginUpdate;
  w_s := REdt_RcvMsgData.Lines.Text;
  REdt_RcvMsgData.Lines.Text := func_SJisToJis(w_s);
  REdt_RcvMsgData.Lines.EndUpdate;
end;

//=============================================================================
//フォーム処理↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//=============================================================================

//=============================================================================
//クライアントソケット処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
//クライアントソケット接続通知
procedure TFrm_TcpEmuC.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //ステータスの表示＆ログ出力
  proc_C_StatusList('OK','Connected to: ' + Socket.RemoteAddress);
  //接続表示
  lbl_CsokStat.Font.Color := clRed;
  //"接続中"表示
  lbl_CsokStat.Caption :='接続中';
  //再表示
  lbl_CsokStat.Refresh;
end;
//クライアントソケット切断通知
procedure TFrm_TcpEmuC.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //ステータスの表示＆ログ出力
  proc_C_StatusList('OK','DisConnected to: ' + Socket.RemoteAddress);
  //接続表示
  lbl_CsokStat.Font.Color := clWindowText;
  //"切断"表示
  lbl_CsokStat.Caption   := '切断' ;
  //再表示
  lbl_CsokStat.Refresh;
end;
//クライアントソケットエラー通知
procedure TFrm_TcpEmuC.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  //ステータスの表示＆ログ出力
  proc_C_StatusList('NG','Error...'+IntToStr(ErrorCode));
  //例外は発生させない
  ErrorCode := 0;
end;
//クライアントソケット応答受信通知
procedure TFrm_TcpEmuC.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//非ブロッキングの処理
end;
procedure TFrm_TcpEmuC.ClientSocket1Write(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//
end;
//ステータス表示
procedure TFrm_TcpEmuC.proc_C_StatusList(arg_Status: string;arg_string: string);
begin
  try
    //表示されていて使用可能の場合
    if (self.visible) and (self.Enabled) then begin
      //変更の始まり
      REdt_CStatus.Lines.BeginUpdate;
      //ステータス表示領域にステータス表示
      REdt_CStatus.Lines.Add(arg_string);
      //変更の終わり
      REdt_CStatus.Lines.EndUpdate;
      //再表示
      REdt_CStatus.Refresh;
    end;
    //LOGにも出力する。
    proc_LogOut(arg_Status,'',G_LOG_KIND_SK_CL_NUM,arg_string);
  except
    Exit;
  end;
end;
//=============================================================================
//クライアントソケット処理↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//=============================================================================

//======================イベント以外のPUBLIC処理===============================
//=============================================================================
//初期／終了化処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
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
procedure TFrm_TcpEmuC.proc_SetMsgKind(arg_MsgKind,arg_MsgKind2:string);
begin
   //無選択の状態にする
   RB_C1_1.Checked := False;
   //指示種別を選択する
   //依頼情報電文の場合
   if arg_MsgKind = G_MSGKIND_IRAI then begin
     //依頼チェック
     RB_C1_1.Checked := True;
   end;
   //患者電文の場合
   if arg_MsgKind = G_MSGKIND_KANJA then begin
     //患者チェック
     RB_C1_2.Checked := True;
   end;
   //オーダキャンセル電文の場合
   if arg_MsgKind = G_MSGKIND_CANCEL then begin
     //オーダキャンセルチェック
     RB_C1_3.Checked := True;
   end;
   //接続・切断電文の場合
   if arg_MsgKind = G_MSGKIND_START then begin
     //接続・切断チェック
     RB_C1_S.Checked := True;
   end;

   //種別設定
   w_MsgKind := arg_MsgKind;
   //無選択の状態にする
   RB_C1_6.Checked  := False;
   //指示種別を選択する
   //依頼情報電文の場合
   if arg_MsgKind = G_MSGKIND_IRAI then begin
     //応答チェック
     RB_C1_6.Checked := True;
   end;
   //患者電文の場合
   if arg_MsgKind = G_MSGKIND_KANJA then begin
     //応答チェック
     RB_C1_6.Checked := True;
   end;
   //オーダキャンセル電文の場合
   if arg_MsgKind = G_MSGKIND_CANCEL then begin
     //応答チェック
     RB_C1_6.Checked := True;
   end;
   //受付電文の場合
   if arg_MsgKind = G_MSGKIND_UKETUKE then begin
     //応答チェック
     RB_C1_6.Checked := True;
   end;
   //実施電文の場合
   if arg_MsgKind = G_MSGKIND_JISSI then begin
     //応答チェック
     RB_C1_6.Checked := True;
   end;
   //再送電文の場合
   if arg_MsgKind = G_MSGKIND_RESEND then begin
     //応答チェック
     RB_C1_6.Checked := True;
   end;
   //接続・切断電文の場合
   if arg_MsgKind = G_MSGKIND_START then begin
     //接続・切断チェック
     RB_C1_6.Checked := True;
   end;
   //種別設定
   w_MsgKind2 := arg_MsgKind2;
end;
(**
 -------------------------------------------------------------------
 * @outline  func_GetMsgKind
 * @param    arg_MsgKind:string;
 * 例外あり
 * 現画面の送信電文の種別を取得する
 -------------------------------------------------------------------
 *)
function TFrm_TcpEmuC.func_GetMsgKind:string;
begin
  //無選択の状態にする
  Result := G_MSGKIND_NONE;
  //指示種別を選択する
  //依頼がチェックされている場合
  if RB_C1_1.Checked then begin
    //電文種別設定
    Result := G_MSGKIND_IRAI;
  end;
  //患者がチェックされている場合
  if RB_C1_2.Checked then begin
    //電文種別設定
    Result := G_MSGKIND_KANJA;
  end;
  //オーダキャンセルがチェックされている場合
  if RB_C1_3.Checked then begin
    //電文種別設定
    Result := G_MSGKIND_CANCEL;
  end;
  //接続・切断がチェックされている場合
  if RB_C1_S.Checked then begin
    //電文種別設定
    Result := G_MSGKIND_START;
  end;
end;
(**
 -------------------------------------------------------------------
 * @outline  func_GetMsgKind2
 * @param    arg_MsgKind:string;
 * 例外あり
 * 現画面の受信電文の種別を取得する
 -------------------------------------------------------------------
 *)
function TFrm_TcpEmuC.func_GetMsgKind2:string;
begin
  //無選択の状態にする
  Result := G_MSGKIND_NONE;
  //指示種別を選択する
  //依頼がチェックされている場合
  if RB_C1_6.Checked then begin
    //電文種別設定
    Result := G_MSGKIND_START;
  end;
end;
(**
 -------------------------------------------------------------------
 * @outline  proc_SetCSockInfo
 * @param arg_ip:string;
 * @param arg_port:string;
 * 例外あり
 * 送信先のIPｱﾄﾞﾚｽとﾎﾟｰﾄ情報をセットする。func_SendMsgBaseの前に行うと有効になる
 *
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmuC.proc_SetCSockInfo(arg_ip:string;arg_port:string);
begin
  //サーバIP設定
  Edt_SrvIp1.text   := arg_ip;
  //サーバポート設定
  Edt_SrvPort1.text := arg_port;
end;
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
function TFrm_TcpEmuC.func_SendStream(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_MsgKind2      : string;
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
        while (w_p < g_Stream_Base[COMMON1DENLENNO + 1].offset) do
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
      if w_p {- G_MSGSIZE_START} <> StrToIntDef(w_s, 0) then
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
{
-----------------------------------------------------------------------------
  名前 : func_SendStream2;
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
function TFrm_TcpEmuC.func_SendStream2(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_MsgKind2      : string;
                    arg_RecvStream: TStringStream
                    ): string;
var
   res:Longint;
   w_SocketStream:TWinSocketStream;
   w_SendStream_Buf:TBuffur;
   w_ReadStream_Buf:TBuffur;
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
    w_SocketStream := TWinSocketStream.Create(ClientSocket1.Socket,arg_TimeOut);
    try
      //初期位置に移動
      arg_SendStream.Position := 0;
      //送信データの領域設定
      arg_SendStream.Read(w_SendStream_Buf, arg_SendStream_Len);
      //ステータスの表示＆ログ出力
      proc_C_StatusList('  ','電文送信開始...< ' + ' >');
      //送信データの書き込み
      res := w_SocketStream.Write(w_SendStream_Buf, arg_SendStream_Len);
      //送信データの書き込みが予定ﾊﾞｲﾄ書き込めない場合　失敗：01
      if (res < arg_SendStream_Len) then begin
        //エラー
        Result := G_TCPSND_PRTCL_ERR01;
        //ステータスの表示＆ログ出力
        proc_C_StatusList('NG','Error...func_SendStream:（①不完全送信）' + Result);
        //処理終了
        Exit;
  //①<<----
      end;
    finally
      //開放
      w_SocketStream.Free;
    end;
    //ステータスの表示＆ログ出力
    proc_C_StatusList('  ','送信サイズ = '+ IntToStr(res) + 'Byte');
    //ステータスの表示＆ログ出力
    proc_C_StatusList('  ','電文送信完了...');
  except
    on E: Exception do begin
      //エラー
      Result := G_TCPSND_PRTCL_ERR01;
      //ステータスの表示＆ログ出力
      proc_C_StatusList('NG','Error...func_SendStream:（②送信例外'+ E.Message +'）' + Result);
      //処理終了
      Exit;
    end;
  //②<<----
  end;
//②応答受信
//  スレッドを作成（返答域、タイムアウト秒数ms）して上記の返答を待つ（タイムアウト時間だけ）
// クライアントブロッキング接続
  try
    //読込みストリームを作成
    w_SocketStream := TWinSocketStream.Create(ClientSocket1.Socket,arg_TimeOut);
    try
      //移動情報電文以外の場合
      //if (arg_MsgKind <> G_MSGKIND_IDOU) then begin
        //受信読込み準備
        //タイムアウトチェック
        if False = w_SocketStream.WaitForData(arg_TimeOut) then begin
          //エラー
          Result := G_TCPSND_PRTCL_ERR02;
          //ステータスの表示＆ログ出力
          proc_C_StatusList('NG','Error...func_SendStream:（③タイムアウト）' + Result);
          //処理終了
          Exit;
    //③<<----
        end
        //読込み
        else begin
          //初期位置に設定
          arg_RecvStream.Position := 0;
          //現在のポジションまで読み込み
          res := w_SocketStream.Read(w_ReadStream_Buf,sizeof(w_ReadStream_Buf));
          //受信領域に書き込み
          arg_RecvStream.Write(w_ReadStream_Buf,res);
        end;
        //ステータスの表示＆ログ出力
        proc_C_StatusList('  ','応答電文受信...< '+ IntToStr(arg_RecvStream.Size) + ' >Byte');
      //end;
    finally
      //開放
      w_SocketStream.Free;
    end;
  //③終了処理 正常復帰の設定
    Result := G_TCPSND_PRTCL_ERR00;
    //ステータスの表示＆ログ出力
    proc_C_StatusList('OK','Complete...func_SendStream:' + Result);
    //処理終了
    Exit;
  //⑥<<----
  except
    on E: Exception do begin
      //エラー
      Result := G_TCPSND_PRTCL_ERR03;
      //ステータスの表示＆ログ出力
      proc_C_StatusList('NG','Error...func_SendStream:（⑦受信例外:'+ E.Message +'）' + Result);
      //処理終了
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
   arg_MsgKind       : string;        送信電文種別
   arg_MsgKind2      : string;        受信電文種別
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
function TFrm_TcpEmuC.func_SendMsgBase(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_MsgKind2      : string;
                    arg_RecvStream: TStringStream
                    ): string;
var
  w_RtCode: string;
begin
  //送信種別の取得
  proc_SetMsgKind(arg_MsgKind,arg_MsgKind2);
  //読みとり用として作成
  //送信領域に設定
  w_SendArea := arg_SendStream;
  //受信領域に設定
  w_RecvArea := arg_RecvStream;
  try
    //ソケットがつながっている場合
    if not (ClientSocket1.Active) then begin
      //ソケットのオープン
      ClientSocket1.Open;
      //完全に初期化されるまで待つ
      while not(ClientSocket1.Socket.Connected) do begin
        //待機時間
        proc_delay(1000);
      end;
    end;

    try
      //強制エラーチェック
      w_RtCode := func_ToolVErr;
      //強制エラーなしの場合
      if w_RtCode = G_TCPSND_PRTCL_ERR00 then begin
        //プロトコル送信機能
        w_RtCode := func_SendStream(arg_SendStream,arg_SendStream_Len,
                                    arg_TimeOut,arg_MsgKind,arg_MsgKind2,arg_RecvStream
                                    );
      end;
    finally
      //常時接続のため特になし
    end;
    //結果
    Result := G_TCPSND_PRTCL00 + w_RtCode;
    //ステータスの表示＆ログ出力
    proc_C_StatusList('OK','Complete...func_SendMsgBase:'+Result);
    //処理終了
    Exit;
//①<<----
  except
    on E: Exception do begin
      //エラー
      Result := G_TCPSND_PRTCL00 + G_TCPSND_PRTCL_ERR01;
      //ステータスの表示＆ログ出力
      proc_C_StatusList('NG','Error...func_SendMsgBase:(例外通信先異常:'+ E.Message +')'+Result);
      //処理終了
      Exit;
    end;
//②<<----
  end;
end;
(**
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
 * @outline       func_SendMsg
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
 * 機能 : 外部公開最上部
    1.送信電文をモ－ドで表示域に表示
    2.送信/受信処理の依頼
    3.受信電文をモ－ドで表示域に表示
 *  
-----------------------------------------------------------------------------
 *)
function TFrm_TcpEmuC.func_SendMsg(
                    arg_SendStream    : TStringStream;
                    arg_SendStream_Len: Longint;
                    arg_TimeOut       : DWORD;
                    arg_MsgKind       : string;
                    arg_MsgKind2      : string;
                    arg_RecvStream: TStringStream
                    ): string;
begin
  //表示されているときには送信情報も表示する
  if Self.Visible then begin
    //変更開始
    REdt_SndCmdData.Lines.BeginUpdate;
    //TStringStreamより解析してTStringListを作成
    proc_TStrmToStrlist(arg_SendStream,
                        TStringList(REdt_SndCmdData.Lines),
                        G_MSG_SYSTEM_C,
                        w_MsgKind
                        );
    //変更終了
    REdt_SndCmdData.Lines.EndUpdate;
  end;
  //送受信を依頼する
  Result := func_SendMsgBase(arg_SendStream,arg_SendStream_Len,
                             arg_TimeOut,arg_MsgKind,arg_MsgKind2,arg_RecvStream
                             );
  //表示されているときには受信情報も表示する
  if self.Visible then begin
    //変更開始
    REdt_RcvMsgData.Lines.BeginUpdate;
    //受信情報の表示
    REdt_RcvMsgData.Lines.Add(arg_RecvStream.DataString);
    //TStringStreamより解析してTStringListを作成
    proc_TStrmToStrlist(arg_RecvStream,TStringList(REdt_RcvMsgData.Lines),
                        G_MSG_SYSTEM_A,w_MsgKind2
                        );
    //変更終了
    REdt_RcvMsgData.Lines.EndUpdate;
  end;
end;
{
-----------------------------------------------------------------------------
  名前 : func_ToolVErr;
  引数 : なし
  機能 : 発生エラーコード
-----------------------------------------------------------------------------
}
function TFrm_TcpEmuC.func_ToolVErr:String;
begin
  //初期値
  Result := G_TCPSND_PRTCL_ERR00;
  //"データ_送信失敗"チェックボックスがチェックされている場合
  if CB_DATA_ERR01.Checked then
    //エラーで返答
    Result := G_TCPSND_PRTCL_ERR01;
  //処理終了
  Exit;
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
  n := List.IndexOfName(Value);
  if n < 0 then
    Result := ''
  else
    Result := List.Values[Value];
end;
{
-----------------------------------------------------------------------------
  名前 : func_TcpEmuCOpen
  機能 : フォーム作成など通信に必要な初期化処理
  復帰値：エミュレータフォーム Nil失敗
-----------------------------------------------------------------------------
}
function func_TcpEmuCOpen(
       arg_OwnForm:TComponent; //親フォーム
       arg_Visible:String;     //表示モード
       arg_Enable:String;      //対話モード
       arg_CharCode:String;    //伝送系文字コード
       arg_IP:String;          //相手IP
       arg_Por:String;         //相手ポート
       arg_TimeOut:String;     //送信時タイムアウト
       arg_MsgKind:string;      //送信電文種別1-5
       arg_MsgKind2:string      //受信電文種別1-5
                         ):TFrm_TcpEmuC;
var
  w_TFrm_TcpEmu :TFrm_TcpEmuC;
begin
  //フォームの作成
  w_TFrm_TcpEmu:= TFrm_TcpEmuC.Create(arg_OwnForm);
  try
    //表示の可否チェック
    if arg_Visible = g_SOCKET_EMUVISIBLE_TRUE then
      //表示
      w_TFrm_TcpEmu.Visible := True
    else
      //非表示
      w_TFrm_TcpEmu.Visible := False;
    //使用の可否チェック
    if arg_Enable = g_SOCKET_EMUENABLED_TRUE then
      //使用可
      w_TFrm_TcpEmu.Enabled := True
    else
      //使用不可
      w_TFrm_TcpEmu.Enabled := False;
    //コード体系設定
    w_TFrm_TcpEmu.w_CharCode        := arg_CharCode;
    //サーバIP設定
    w_TFrm_TcpEmu.Edt_SrvIp1.Text   := arg_IP;
    //サーバポート設定
    w_TFrm_TcpEmu.Edt_SrvPort1.Text := arg_Por;
    //ﾀｲﾑｱｳﾄ表示
    w_TFrm_TcpEmu.Edt_TimeOut.Text  := arg_TimeOut;
    //ﾀｲﾑｱｳﾄ設定
    w_TFrm_TcpEmu.w_TimeOut := StrToIntDef(arg_TimeOut,10000);
    //送信種別設定
    w_TFrm_TcpEmu.proc_SetMsgKind(arg_MsgKind,arg_MsgKind2);
    //電文受信領域初期化
    w_TFrm_TcpEmu.w_RecvArea := TStringStream.Create('');
    //電文送信領域初期化
    w_TFrm_TcpEmu.w_SendArea := TStringStream.Create('');
    //初期化処理
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
procedure TFrm_TcpEmuC.Button1Click(Sender: TObject);
begin
  //通信ステータスクリア
  REdt_CStatus.Clear;
end;

procedure TFrm_TcpEmuC.BitBtn1Click(Sender: TObject);
begin
  //ソケットの最初期化
  w_RtCod := '';
  //サーバIP設定
  ClientSocket1.Address := Edt_SrvIp1.Text;
  //サーバポート設定
  ClientSocket1.Port := StrToInt(Edt_SrvPort1.Text);
  if w_SendArea <> nil then begin
    FreeAndNil(w_SendArea);
    //電文送信領域初期化
    w_SendArea := TStringStream.Create('');
  end;
  if w_RecvArea <> nil then begin
    FreeAndNil(w_RecvArea);
    //電文送信領域初期化
    w_RecvArea := TStringStream.Create('');
  end;
  proc_RB_Click;
  w_SendArea.WriteString(REdt_SndCmdData.Text);
  //電文取得
  //proc_TStrListToStrm(TStringList(REdt_SndCmdData.Lines),w_SendArea,
  //                    G_MSG_SYSTEM_C,w_MsgKind
  //                    );


  //電文送信
  w_RtCod := func_SendMsgBase(w_SendArea,w_SendArea.Size,w_TimeOut,
                              func_GetMsgKind,func_GetMsgKind2,w_RecvArea
                              );
  //LOGにも出力する。
  proc_LogOut('  ','',G_LOG_KIND_SK_CL_NUM,w_RecvArea.DataString);
  //TStringStreamより解析してTStringListを作成
  proc_TStrmToStrlist(w_RecvArea,TStringList(REdt_RcvMsgData.Lines),
                      G_MSG_SYSTEM_A,w_MsgKind2
                      );
  //状態表示変更 切断
  lbl_CsokStat.Caption := '';
  //状態表示変更 切断
  lbl_CsokStat.Caption := lbl_CsokStat.Caption +' = '+ w_RtCod;
  //再表示
  lbl_CsokStat.Refresh;
end;

procedure TFrm_TcpEmuC.proc_RB_Click;
begin
  w_MsgKind := func_GetMsgKind;
  w_MsgKind2 := func_GetMsgKind2;
end;

procedure TFrm_TcpEmuC.Button2Click(Sender: TObject);
begin
  //ソケットを閉じる
  ClientSocket1.Close;
end;

end.
