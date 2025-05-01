unit FTcpEmu;
interface //*****************************************************************
(**
■機能説明
      ISO層ｲﾝﾀｰﾌｪｽ
公開機能
すべての機能は、フォームを作成する初期化が正常終了した後でのみ機能する
①エミュレータ初期化機能(関数)
-----------------------------------------------------------------------------
  名前 : func_TcpEmuOpen
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

②受信先情報設定機能（TFrm_TcpEmuのメソッド）未使用予定
 -------------------------------------------------------------------
 * @outline  proc_SetSSockInfo
 * @param arg_Socket:TCustomWinSocket   送信に使用するソケット
 * @param arg_port:string; ポート
 * 例外あり
 * 受信側のポート情報をセットする。
 *
 -------------------------------------------------------------------

③送信先情報設定機能（TFrm_TcpEmuのメソッド）
 -------------------------------------------------------------------
 * @outline  proc_SetCSockInfo
 * @param arg_Socket:TCustomWinSocket   送信に使用するソケット
 * @param arg_ip:string;
 * @param arg_port:string;
 * 送信先の情報をセットする。func_SendMsgの前に行うと有効になる
 *
 -------------------------------------------------------------------

④電文送信受信機能（TFrm_TcpEmuのメソッド）
-----------------------------------------------------------------------------
  名前 : func_SendMsg;
  引数 : なし
       arg_Msg: TStream;       送信電文文字列
       arg_Res: TStream;       受信電文文字列
       arg_Socket:TCustomWinSocket   送信に使用するソケット
                                     nil:エミュレータに有るデフォルト


  機能 : ｺﾏﾝﾄﾞｱﾌﾟﾗｲ送信機能
  復帰値：例外ない
  ｴﾗｰｺｰﾄﾞ(4桁 XXYY
              XX：発生位置01～07手順
              00：成功                   G_TCPSND_PRTCL00
              01：準備確認               G_TCPSND_PRTCL01
              02：準備確認応答（未使用） G_TCPSND_PRTCL02
              03：コマンド送信           G_TCPSND_PRTCL03
              04：コマンドACK （未使用） G_TCPSND_PRTCL04
              05：データ長送信           G_TCPSND_PRTCL05
              06：データ長ACK （未使用） G_TCPSND_PRTCL06
              07：データ送信             G_TCPSND_PRTCL07
              08：データACK   （未使用） G_TCPSND_PRTCL08
              YY：詳細
              00：成功／許可             G_TCPSND_PRTCL_ERR00
              01：送信失敗               G_TCPSND_PRTCL_ERR01
              02：無応答                 G_TCPSND_PRTCL_ERR02
              03：返答失敗／拒否         G_TCPSND_PRTCL_ERR03
              )
※注意：各コード（XXとYY）は下記定義されています
-----------------------------------------------------------------------------

⑤エミュレータ終了化機能（TFrm_TcpEmuのメソッド）
  ①作成のフォームをクローズする。
  .close; 例外有り


⑥ログ出力機能（関数）
-----------------------------------------------------------------------------
  名前 : proc_LogOperate(Operate);
  引数 :
   Operate: string : 操作内容
  機能 : ログに記録する。
  例外はすべて無視するのでなし
-----------------------------------------------------------------------------
※用語定義
メッセージ：コマンド アプライ
プロトコル（手順）：上記を送るための順番の決まった電文の集まり
電文：ソケットのTCPIP転送電文


■履歴
新規作成：01.09.17：担当iwai

*)

//使用ユニット---------------------------------------------------------------
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ScktComp, IniFiles, ExtCtrls, Buttons,math, FileCtrl,
  Gval,pdct_ini,pdct_com ,HisMsgDef
  ;

////型クラス宣言-------------------------------------------------------------
// 構造型
type   //ソケット通信サーバ保持情報
  TServer_Info = record
    Port1         : string[4]; //接続待ちポートアドレス1
    Port1_CrntMsg : string[1]; //カレント処理Msg種別   1
    Port2         : string[4]; //接続待ちポートアドレス2
    Port2_CrntMsg : string[1]; //カレント処理Msg種別   2
    Port3         : string[4]; //接続待ちポートアドレス2
    Port3_CrntMsg : string[1]; //カレント処理Msg種別   2
    FPTimeOut     : Longint;   //タイムアウト
    FATimeOut     : Longint;   //
    FLogActive    : string;    //ログ取得状態
    FLogPath      : string;    //ログ出力先
    FLogSize      : Integer;   //ログ出力サイズ
  end;
type   //ソケット通信クライアント保持情報
  TClint_Info = record
    IPAdrr1       : string[15]; //サーバアドレス1
    Port1         : string[4];  //サーバポート1
    STimeOut1     : Longint;    //タイムアウト
    Port1_CrntMsg : string[1];  //カレント処理Msg種別1

    IPAdrr2       : string[15]; //サーバアドレス2
    Port2         : string[4];  //サーバポート2
    STimeOut2     : Longint;    //タイムアウト2
    Port2_CrntMsg : string[1];  //カレント処理Msg種別2

    IPAdrr3       : string[15]; //サーバアドレス3
    Port3         : string[4];  //サーバポート3
    STimeOut3     : Longint;    //タイムアウト3
    Port3_CrntMsg : string[1];  //カレント処理Msg種別3

    FLogActive    : string;     //ログ取得状態
    FLogPath      : string;     //ログ出力先
    FLogSize      : Integer;    //ログ出力サイズ
  end;

//フォーム
type
  TFrm_TcpEmu = class(TForm)
    ClientSocket1: TClientSocket;
    pnl_sever: TPanel;
    ServerSocket1: TServerSocket;
    pnl_cmd: TPanel;
    pnl_system: TPanel;
    Button2: TButton;
    pnl_err: TPanel;
    GroupBox2: TGroupBox;
    CB_JUNBI_ERR01: TCheckBox;
    CB_JUNBI_ERR02: TCheckBox;
    CB_JUNBI_ERR03: TCheckBox;
    CB_COMND_ERR01: TCheckBox;
    CB_COMND_ERR02: TCheckBox;
    CB_COMND_ERR03: TCheckBox;
    CB_DATAL_ERR01: TCheckBox;
    CB_DATAL_ERR02: TCheckBox;
    CB_DATAL_ERR03: TCheckBox;
    CB_DATA_ERR01: TCheckBox;
    CB_DATA_ERR02: TCheckBox;
    CB_DATA_ERR03: TCheckBox;
    pnl_status: TPanel;
    lbl_show_status: TLabel;
    btn_Init: TBitBtn;
    RE_setumei: TRichEdit;
    StaticText1: TStaticText;
    BitBtn1: TBitBtn;
    CB_JUNBI_ERR03_B: TCheckBox;
    CB_COMND_ERR03_B: TCheckBox;
    CB_DATAL_ERR03_B: TCheckBox;
    CB_DATA_ERR03_B: TCheckBox;
    Label11: TLabel;
    Panel1: TPanel;
    Label3: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Edt_RISPort1: TEdit;
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
    RB_S1_1: TRadioButton;
    RB_S1_5: TRadioButton;
    RB_S1_2: TRadioButton;
    RB_S1_4: TRadioButton;
    RB_S1_3: TRadioButton;
    Panel2: TPanel;
    Label4: TLabel;
    Edt_RisIp: TEdit;
    pnl_clnte: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lbl_CsokStat: TLabel;
    Label7: TLabel;
    Edt_SrvIp1: TEdit;
    Edt_SrvPort1: TEdit;
    Edt_PTimeOut1: TEdit;
    REdt_CStatus: TRichEdit;
    REdt_SndCmdData: TRichEdit;
    btn_SendCmd: TBitBtn;
    REdt_SndAppData: TRichEdit;
    Button3: TButton;
    Button1: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Button7: TButton;
    Edit2: TEdit;
    Button8: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    GroupBox5: TGroupBox;
    RB_C1_1: TRadioButton;
    RB_C1_5: TRadioButton;
    RB_C1_2: TRadioButton;
    RB_C1_4: TRadioButton;
    RB_C1_3: TRadioButton;
    DriveComboBox1: TDriveComboBox;
    DirectoryListBox1: TDirectoryListBox;
    FileListBox1: TFileListBox;
    procedure ClientSocket1Connect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocket1Read(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocket1Error(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure Button2Click(Sender: TObject);
    procedure btn_SendCmdClick(Sender: TObject);
    procedure ClientSocket1Disconnect(Sender: TObject;
      Socket: TCustomWinSocket);
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
    procedure btn_InitClick(Sender: TObject);
    procedure REdt_RcvCmdData1Change(Sender: TObject);
    procedure ServerSocket1ClientWrite(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure btn_SendApplyClick(Sender: TObject);
    procedure Edt_PTimeOut1Change(Sender: TObject);
    procedure Edt_ATimeOutChange(Sender: TObject);
    procedure ClientSocket1Write(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Btn_RcvClear1Click(Sender: TObject);
    procedure Btn_RcvDClear1Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure btn_SRsave1Click(Sender: TObject);
    procedure btn_SSsave1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Edt_SrvIp1Change(Sender: TObject);
    procedure Edt_SrvIp2Change(Sender: TObject);
    procedure Edt_SrvIp3Change(Sender: TObject);
    procedure Edt_PTimeOut2Change(Sender: TObject);
    procedure Edt_PTimeOut3Change(Sender: TObject);
    procedure Edt_SrvPort1Change(Sender: TObject);
    procedure Edt_SrvPort2Change(Sender: TObject);
    procedure Edt_SrvPort3Change(Sender: TObject);
    procedure Btn_RcvClear2Click(Sender: TObject);
    procedure Btn_RcvDClear2Click(Sender: TObject);
    procedure btn_SRsave2Click(Sender: TObject);
    procedure btn_SRsave3Click(Sender: TObject);
    procedure Btn_RcvClear3Click(Sender: TObject);
    procedure Btn_RcvDClear3Click(Sender: TObject);
    procedure btn_SSsave2Click(Sender: TObject);
    procedure btn_SSsave3Click(Sender: TObject);
  private
    { Private 宣言 }
    //INI情報 proc_SetInitialInfoで使う。
    w_Clint_Info : TClint_Info;
    FVersion     : string;
    w_ServerInfo : TServer_Info;

    //制御フラグ
    w_ClintWaitFlag:boolean;  //クライアント非ブロッキング接続用 未使用
    w_MsgKind_Flag:string;    //メッセージ種別
    //サーバ受信電文域
    ServerRecieveBuf     : TBuffur; //電文受信域
    ServerRecieveBuf_Len : Longint;      //実電文長
    ServerRecieveBuf_LenPlan : Longint;  //予定電文長
    w_Stream_Ack         : TBuffur;           //応答領域


    //解析結果格納域
    F_PlanMsg_Len        : Longint;      //予定受信コマンドアプライ長
    F_RealMsg_Len        : Longint;      //実  受信コマンドアプライ長
    F_sMsg               : String;  //コマンドアプライ保存域

  public
    { Public 宣言 }
    w_RcvCmdArea:TStringList;    //コマンド受信領域
    w_RcvApplyArea:TStringList;  //コマンドに対する結果アプライの受信領域
    //初期化情報設定
    procedure proc_SetInitialInfo;
    //初期化処理
    procedure proc_Start;
    //終了化処理
    procedure proc_End;
    //
    procedure proc_SetCSockInfo(arg_ip:string;arg_port:string);
    //
    procedure proc_SetSSockInfo(arg_port:string);
    //ｺﾏﾝﾄﾞｱﾌﾟﾗｲ送信機能
    function func_SendMsg(
                    arg_Msg: TStringList;
                    arg_MsgKind:string;
                    arg_Apply: TStringList;
                    arg_Socket:TClientSocket
                    ): string;

    function func_SendPrtcl(
                    arg_Msg: TStringList;
                    arg_Socket:TClientSocket
                    ): string;

    function func_MakeSendStream(
                    arg_Socket:TClientSocket;
                    arg_Order: string;
                    arg_Data:TStringList;
                  var  arg_RecvData:TStringList
                    ): string;
    function func_StrListToStream(
                    arg_Order: string;
                    arg_Data:TStringList
                    ): TStringStream;
    function func_StreamToStrList(
                    arg_Order: string;
                    arg_Data:TStringStream
                    ): TStringList;
    function func_SendStream(
                    arg_Socket:TClientSocket;
                    arg_SendStream:TStringStream;
                    arg_TimeOut: DWORD;
                    Var arg_RecvStream:TStringStream
                    ): string;
    procedure proc_AnalizeStream(
                    Sender: TObject;
                    Socket: TCustomWinSocket);
    procedure proc_SendAckStream(Sender: TObject;
                    Socket: TCustomWinSocket);
    function func_ToolVErr(
                    arg_Order:string
                    ): string;
    function func_CheckStream(
                    arg_Cmd:Word;
                    arg_Ack:Word
                    ): Boolean;
    procedure proc_S_StatusList(arg_string: string);
    procedure proc_C_StatusList(arg_string: string);
  end;

//定数宣言-------------------------------------------------------------------
const
  G_PKT_PTH_DEF='RIS_RIG.log'; //LOGファイル
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
  G_MINIMUN_TIMEOUT=10; //１０ms

// 詳細***** プロトコル エラー情報
const
  G_TCPSND_PRTCL_ERR00='00';//成功
  G_TCPSND_PRTCL_ERR01='01';//送信失敗
  G_TCPSND_PRTCL_ERR02='02';//無応答
  G_TCPSND_PRTCL_ERR03='03';//返答失敗／拒否
  G_TCPSND_PRTCL_OK   = G_TCPSND_PRTCL00+G_TCPSND_PRTCL_ERR00;//成功
//変数宣言-------------------------------------------------------------------
var
  Frm_TcpEmu: TFrm_TcpEmu;

//関数手続き宣言-------------------------------------------------------------
function func_TcpEmuOpen(
                         arg_OwnForm:TForm;
                         arg_Visible:boolean;
                         arg_Enable:boolean;
                         arg_RcvCmdArea:TStringList
                         ):TFrm_TcpEmu;
//
procedure proc_LogOperate(const Operate: string);
//
function func_TStrListToStrm(arg_TStringList:TStringList):TStringStream;
//
function func_TagValue(const List: TStrings; Value: string): string;
//
procedure proc_JisToSJis(arg_Stream: TStringStream);
//
function func_SJisToJis(arg_Stream: string): string;
//
function func_MakeSJIS: String;

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
procedure TFrm_TcpEmu.FormCreate(Sender: TObject);
begin
 //例外は発生させない
 //ｲﾝｽﾀﾝｽ初期化ﾌﾟﾛﾊﾟﾃｨ等をクリア
  w_RcvCmdArea   := nil;
  w_RcvApplyArea := nil;
  w_ClintWaitFlag:= False;
  w_MsgKind_Flag := G_MSGKIND_NONE;
 //電文受信域クリア
  ServerRecieveBuf_Len:=0;
  ServerRecieveBuf_LenPlan:=0;
  FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);
 //応答域クリア
//  FillChar(w_Stream_Ack,sizeof(w_Stream_Ack), #0);
 //メッセージ格納域クリア
  F_sMsg:='';
  F_PlanMsg_Len:=-1;
  F_RealMsg_Len:=-1;
  FileListBox1.Directory:=G_RunPath ;
 // イニシャルファイルをロードする。
  proc_SetInitialInfo;
  REdt_RcvAppData.Lines.Clear;
  REdt_RcvAppData.Clear;
  REdt_RcvCmdData.Lines.Clear;
  REdt_RcvCmdData.Clear;



end;
procedure TFrm_TcpEmu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //メッセージ格納域解放
  F_sMsg:='';
  //終了化する。
  proc_End;
  //領域は解放する
  Action:=caFree;

end;
procedure TFrm_TcpEmu.FormDestroy(Sender: TObject);
begin
  //
end;
//[コマンド送信]ボタン
procedure TFrm_TcpEmu.btn_SendCmdClick(Sender: TObject);
var
  w_RtCod:string;
  w_TstringList:TStringList;
begin
  //状態表示変更 接続
  //ソケットの最初期化
  lbl_CsokStat.Font.Color:= clRed;//接続表示
  lbl_CsokStat.Caption :='接続中';
  lbl_CsokStat.Refresh;
  ClientSocket1.Address:= Edt_SrvIp.Text;
  ClientSocket1.Port:=StrToInt(Edt_SrvPort1.text);
  //電文取得
  w_TstringList:= TStringList.Create;
  try
  w_TstringList.AddStrings(REdt_SndCmdData.Lines);
  //電文送信
  if 
  w_RtCod:=func_SendMsg(TStringList(w_TstringList),
                        G_MSGKIND_IRAI,
                        nil,
                        (ClientSocket1));
  finally
  w_TstringList.Free;
  end;
  //状態表示変更 切断
  lbl_CsokStat.Font.Color:= clWindowText;//接続表示
  lbl_CsokStat.Caption   := '切断 = '+ w_RtCod;
  lbl_CsokStat.Refresh;
end;
//[アプライ送信]ボタン
procedure TFrm_TcpEmu.btn_SendApplyClick(Sender: TObject);
begin

end;

//[閉じる]ボタン
procedure TFrm_TcpEmu.Button2Click(Sender: TObject);
begin
  ClientSocket1.Active:=False;
  ClientSocket1.Close;
  Close;
end;

//[初期化]ボタン サーバ機能初期化依頼
procedure TFrm_TcpEmu.btn_InitClick(Sender: TObject);
begin
      proc_Start;
end;
//コマンド受信域
procedure TFrm_TcpEmu.REdt_RcvCmdData1Change(Sender: TObject);
begin
end;

//ｱﾌﾟﾗｲ受信域
procedure TFrm_TcpEmu.Edt_PTimeOut1Change(Sender: TObject);
begin
    w_Clint_Info.STimeOut1 := StrToIntDef(Edt_PTimeOut1.Text,G_MAX_STREAM_SIZE);
end;

procedure TFrm_TcpEmu.Edt_ATimeOutChange(Sender: TObject);
begin
    FATimeOut        := StrToIntDef(Edt_ATimeOut.Text,G_MAX_STREAM_SIZE);
end;

procedure TFrm_TcpEmu.Button3Click(Sender: TObject);
begin
     REdt_SndCmdData.Lines.LoadFromFile(FileListBox1.FileName);
end;

procedure TFrm_TcpEmu.Button1Click(Sender: TObject);
begin
REdt_SndCmdData.Clear;
end;

procedure TFrm_TcpEmu.Button4Click(Sender: TObject);
begin
REdt_SndAppData.Clear;
end;

procedure TFrm_TcpEmu.Btn_RcvClear1Click(Sender: TObject);
begin
REdt_RcvCmdData1.Clear;

end;

procedure TFrm_TcpEmu.Btn_RcvDClear1Click(Sender: TObject);
begin
REdt_RcvAppData1.Clear;

end;
procedure TFrm_TcpEmu.Button7Click(Sender: TObject);
begin
   REdt_SndCmdData.Lines.SaveToFile(IncludeTrailingBackslash(FileListBox1.Directory) +Edit1.Text);
end;

procedure TFrm_TcpEmu.Button8Click(Sender: TObject);
begin
   REdt_SndAppData.Lines.SaveToFile(IncludeTrailingBackslash(FileListBox1.Directory) +Edit2.Text);
end;

procedure TFrm_TcpEmu.btn_SRsave1Click(Sender: TObject);
begin
   REdt_RcvCmdData1.Lines.SaveToFile(IncludeTrailingBackslash(FileListBox1.Directory) +Edit_SvRvSaveFl1.Text);
end;

procedure TFrm_TcpEmu.btn_SSsave1Click(Sender: TObject);
begin
   REdt_RcvAppData1.Lines.SaveToFile(IncludeTrailingBackslash(FileListBox1.Directory) +Edit_SvSdSaveFl1.Text);

end;
procedure TFrm_TcpEmu.BitBtn1Click(Sender: TObject);
begin
  proc_End;
end;
procedure TFrm_TcpEmu.Button12Click(Sender: TObject);
begin

   REdt_SndCmdData.Lines.BeginUpdate;
   REdt_SndCmdData.Lines.Text := func_MakeSJIS;
   REdt_SndCmdData.Lines.EndUpdate;

end;

procedure TFrm_TcpEmu.Button13Click(Sender: TObject);
begin

   REdt_SndAppData.Lines.BeginUpdate;
   REdt_SndAppData.Lines.Text := func_MakeSJIS;
   REdt_SndAppData.Lines.EndUpdate;

end;


procedure TFrm_TcpEmu.Button14Click(Sender: TObject);
var
  w_s:string;

begin

   REdt_SndCmdData.Lines.BeginUpdate;
   w_s := REdt_SndCmdData.Lines.Text;
   REdt_SndCmdData.Lines.Text := func_SJisToJis(w_s);
   REdt_SndCmdData.Lines.EndUpdate;


end;

procedure TFrm_TcpEmu.Button15Click(Sender: TObject);
var
  w_s:string;

begin

   REdt_SndAppData.Lines.BeginUpdate;
   w_s := REdt_SndAppData.Lines.Text;
   REdt_SndAppData.Lines.Text := func_SJisToJis(w_s);
   REdt_SndAppData.Lines.EndUpdate;

end;

//=============================================================================
//フォーム処理↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//=============================================================================

//=============================================================================
//クライアントソケット処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
//クライアントソケット接続通知
procedure TFrm_TcpEmu.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_C_StatusList('Connected to: ' + Socket.RemoteAddress);
end;
//クライアントソケット切断通知
procedure TFrm_TcpEmu.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_C_StatusList('DisConnected to: ' + Socket.RemoteAddress);
end;
//クライアントソケットエラー通知
procedure TFrm_TcpEmu.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  proc_C_StatusList('Error...'+IntToStr(ErrorCode));
  ErrorCode:=0; //例外は発生させない
end;
//クライアントソケット応答受信通知
procedure TFrm_TcpEmu.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//非ブロッキングの処理
  if w_ClintWaitFlag then
  begin
    w_ClintWaitFlag:=False;
  end;
end;
procedure TFrm_TcpEmu.ClientSocket1Write(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//
end;
//ステータス表示
procedure TFrm_TcpEmu.proc_C_StatusList(arg_string: string);
begin
  try
    if (self.visible) and (self.Enabled) then
    begin
     REdt_CStatus.Lines.BeginUpdate;
     REdt_CStatus.Lines.Add(arg_string);
     REdt_CStatus.Lines.EndUpdate;
     REdt_CStatus.Refresh;
    end;
  //LOGにも出力する。
    proc_LogOperate('クライアント処理（' + arg_string + '）');
  except
    exit;
  end;
end;
//=============================================================================
//クライアントソケット処理↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//=============================================================================

//=============================================================================
//サーバソケット処理↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
procedure TFrm_TcpEmu.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_S_StatusList('クライアントが接続されました...');
  //電文送信機能の初期化 １接続１プロトコル
  //電文のクリア
    ServerRecieveBuf_LenPlan:=0;
    ServerRecieveBuf_Len:=0;
    FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);
  //応答域クリア
    FillChar(w_Stream_Ack,sizeof(w_Stream_Ack), #0);

  //メッセージのクリア
    F_PlanMsg_Len:= 0;
    F_RealMsg_Len:= 0;
    F_sMsg       := '';

end;

procedure TFrm_TcpEmu.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_S_StatusList('クライアントが切断されました...');

end;

procedure TFrm_TcpEmu.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  proc_S_StatusList('Error...code='+IntTostr(ErrorCode));
  ErrorCode:=0;  //例外は発生させない

end;
//電文データブロックの受信
procedure TFrm_TcpEmu.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
   res       :Longint;
//   pos       :Longint;
//   w_size    :Longint;
//   w_DataSize:Longint;
   w_TBuffur1:TBuffur;
   w_TBuffur2:TBuffur;
   w_b:array[1..5] of char;

begin
  //Application.ProcessMessages;
  //電文は一単位電文が分割されてくるので注意
  //対処としては
  //①一番始めにすべて強制的に読み取ってしまう。大きい時はスレッド占有してしまう
  //②分割して呼んで一単位電文毎に解析処理を呼び出す(採用)
  //受信格納
  //現在の予定電文長が０以下なら先頭を読み取り中なので予定電文長を読み込む
  if ServerRecieveBuf_LenPlan <=0 then  //一単位電文読込み終了時に0にすること
  begin  //予定長までの読込みを試みる
    //１バイトまでの分割読込みに対処する
    res := Socket.ReceiveBuf(w_TBuffur1,sizeof(w_TBuffur1));
    CopyMemory(@w_TBuffur2,@ServerRecieveBuf,ServerRecieveBuf_Len);
    CopyMemory(Addr(w_TBuffur2.data[ServerRecieveBuf_Len+1]),@w_TBuffur1,res);
    ServerRecieveBuf_Len := ServerRecieveBuf_Len + res;
    CopyMemory(@ServerRecieveBuf,@w_TBuffur2,ServerRecieveBuf_Len);

    if ServerRecieveBuf_Len >= sizeof(TStrm_ComnHeader01) then
    begin  //予定長までは読めた
      proc_S_StatusList('電文受信開始...< '+ ' >');
      proc_S_StatusList('受信サイズ = '+ IntToStr(ServerRecieveBuf_Len) + 'Byte');
      CopyMemory(@TStrm_ComnHeader01((@ServerRecieveBuf)^). DenbunChou_15[1],@w_b[1],5);
      ServerRecieveBuf_LenPlan:=StrToint(w_b);
      if  ServerRecieveBuf_LenPlan > ServerRecieveBuf_Len then
      begin  //全部は読めていないので再読込みを待つ
            exit;
//＜＜－－再読込み待ち：
      end;
    end
    else
    begin //予定長までは読めなかったのでもう一度読む必要がある
      exit;  //抜けて電送されてくるのを待つ
//＜＜－－再読込み待ち：
    end;
  end;
//再度途中の電文読み込み
  if  ServerRecieveBuf_LenPlan > ServerRecieveBuf_Len then
  begin  //再度読む必要がある
    res := Socket.ReceiveBuf(w_TBuffur1,sizeof(w_TBuffur1));
    //１バイトまでの分割読込みに対処する
    CopyMemory(@w_TBuffur2,@ServerRecieveBuf,ServerRecieveBuf_Len);
    CopyMemory(Addr(w_TBuffur2.data[ServerRecieveBuf_Len+1]),@w_TBuffur1,res);
    ServerRecieveBuf_Len := ServerRecieveBuf_Len + res;
    CopyMemory(@ServerRecieveBuf,@w_TBuffur2,ServerRecieveBuf_Len);
  end;//まだ途中なのかをしらべる
  if  ServerRecieveBuf_LenPlan > ServerRecieveBuf_Len then
  begin
    proc_S_StatusList('受信サイズ = '+ IntToStr(ServerRecieveBuf_Len) + 'Byte');
    exit;
//＜＜－－再読込み待ち：
  end;
  //ServerRecieveBufに一単位電文が読み込まれた。
  proc_S_StatusList('受信サイズE= '+ IntToStr(ServerRecieveBuf_Len) + 'Byte');
  proc_S_StatusList('電文受信完了...');
  //電文解析依頼
  proc_AnalizeStream(Sender,Socket);
  proc_SendAckStream(Sender,Socket);
  //一単位電文クリア但し現電文は残す 強制読込みのため
  ServerRecieveBuf_LenPlan:=0;//一単位電文の受信終了を意味する
  ServerRecieveBuf_Len:=0;

{対処①の処理
  //電文長をクリア
  ServerRecieveBuf_Len := 0;
  //
  res := Socket.ReceiveBuf(ServerRecieveBuf,sizeof(TStream_Header));
  ServerRecieveBuf_Len := ServerRecieveBuf_Len + res;

  proc_S_StatusList('電文受信開始...< '+ IntToHex(ServerRecieveBuf.commad,0) + ' >');
  pos := 0;
  w_DataSize:= ServerRecieveBuf.length;
  while (w_DataSize) > pos do
  begin
    w_size := sizeof(ServerRecieveBuf.data) - pos;
    res := Socket.ReceiveBuf(ServerRecieveBuf.data[pos+1], w_size);
    ServerRecieveBuf_Len := ServerRecieveBuf_Len+res;
    pos := pos+res;
  end;

  proc_S_StatusList('受信サイズ = '+ IntToStr(w_DataSize) + 'Byte');
  proc_S_StatusList('電文受信完了...');

  proc_AnalizeStream(Sender,Socket);
}
end;
procedure TFrm_TcpEmu.ServerSocket1ClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//ServerRecieveBuf 受信域を解析して応答を送信することを依頼する。（未動作）
//  proc_SendAckStream(Sender,Socket);

end;
//一単位電文の解析と対処
procedure TFrm_TcpEmu.proc_AnalizeStream(Sender: TObject;
  Socket: TCustomWinSocket);
var
//  w_05        : TStream_Data05;
  w_s:string;
  w_DataSize:Longint;
//  w_Tstring:TStringList;
label p_end;

begin
//in:ServerRecieveBuf  ServerRecieveBuf_Len
//out:w_Stream_Ack送信  F_Msg → REdt_RcvCmdData / REdt_RcvAppData
//ServerRecieveBuf現状の受信電文より解析
//受信電文がない時は即時復帰
//サーバ側は受信電文に対する応答は常に固定されている。（ペアーになっている）
  proc_S_StatusList('電文解析開始...');
  //応答域クリア
//  FillChar(w_Stream_Ack,sizeof(w_Stream_Ack), #0);
  if ServerRecieveBuf_Len=-1 then
  begin
    proc_S_StatusList('電文解析完了...電文無し-1');
    exit;
  end;
  if ServerRecieveBuf_Len=0 then
  begin
    proc_S_StatusList('電文解析完了...電文無し0');
    exit;
  end;
  if ServerRecieveBuf_Len<ServerRecieveBuf_LenPlan then
  begin
    proc_S_StatusList('電文解析完了...電文不完全');
    exit;
  end;

//01の処理02
if RadioButton1.Checked then
begin
  //CB_JUNBI_ERR02 タイムアウト
  if CB_JUNBI_ERR02.Checked then
  begin
    proc_S_StatusList('電文解析開始失敗...タイムアウト');
    proc_S_StatusList('電文解析完了...');
    //現状電文のない状態にしてタイムアウトにする
    ServerRecieveBuf_LenPlan:=0;
    ServerRecieveBuf_Len:=0;
    FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);
    //応答域クリア
//    FillChar(w_Stream_Ack,sizeof(w_Stream_Ack), #0);
    exit;
  end;
  //CB_JUNBI_ERR03 失敗
  if CB_JUNBI_ERR03.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_02;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTNG;
//    proc_S_StatusList('電文解析開始失敗...' + IntToHex(w_Stream_Ack.commad,0));
    goto p_end;
  end;
  //CB_JUNBI_ERR03 失敗応答不正
  if CB_JUNBI_ERR03_B.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_01;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
//    proc_S_StatusList('電文解析開始失敗...応答不正' + IntToHex(w_Stream_Ack.commad,0));
    goto p_end;
  end;
  //対処
  //コマンドアプライ域クリア
  F_PlanMsg_Len:=0;
  F_RealMsg_Len:=0;
  F_sMsg:='';
  //w_Stream_Ack作成
//  w_Stream_Ack.commad:=G_PRTCL_STRM_02;
//  w_Stream_Ack.length:=2;
//  w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
  goto p_end;
  //w_Stream_Ack送信
end;

//03の処理04
//if G_PRTCL_STRM_03=ServerRecieveBuf.commad  then
begin
  //CB_COMND_ERR02 タイムアウト
  if CB_COMND_ERR02.Checked then
  begin
    proc_S_StatusList('電文解析開始失敗...タイムアウト');
    proc_S_StatusList('電文解析完了...');
    //現状電文のない状態にしてタイムアウトにする
    ServerRecieveBuf_LenPlan:=0;
    ServerRecieveBuf_Len:=0;
    FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);
    //応答域クリア
//    FillChar(w_Stream_Ack,sizeof(w_Stream_Ack), #0);
    exit;
  end;
  //CB_COMND_ERR03 失敗
  if CB_COMND_ERR03.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_04;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTNG;
  //  proc_S_StatusList('電文解析開始失敗...' + IntToHex(w_Stream_Ack.commad,0));
    goto p_end;
  end;
  //CB_COMND_ERR03 失敗応答不正
  if CB_COMND_ERR03_B.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_03;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
//    proc_S_StatusList('電文解析開始失敗...応答不正' + IntToHex(w_Stream_Ack.commad,0));
    goto p_end;
  end;

  //コマンド受信の準備

  //w_Stream_Ack作成
//  w_Stream_Ack.commad:=G_PRTCL_STRM_04;
//  w_Stream_Ack.length:=2;
//  w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
  goto p_end;
  //w_Stream_Ack送信
end;

//05の処理06
//if G_PRTCL_STRM_05=ServerRecieveBuf.commad  then
begin
  //CB_DATAL_ERR02 タイムアウト
  if CB_DATAL_ERR02.Checked then
  begin
    proc_S_StatusList('電文解析開始失敗...タイムアウト');
    proc_S_StatusList('電文解析完了...');
    //受信電文クリア
    //現状電文のない状態にしてタイムアウトにする
    ServerRecieveBuf_LenPlan:=0;
    ServerRecieveBuf_Len:=0;
    FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);
    //応答域クリア
//    FillChar(w_Stream_Ack,sizeof(w_Stream_Ack), #0);
    exit;
  end;
  //CB_DATAL_ERR03 失敗
  if CB_DATAL_ERR03.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_06;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTNG;
//    proc_S_StatusList('電文解析開始失敗...' + IntToHex(w_Stream_Ack.commad,0) );
    goto p_end;
  end;
  //CB_DATAL_ERR03 失敗応答不正
  if CB_DATAL_ERR03_B.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_05;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
//    proc_S_StatusList('電文解析開始失敗...応答不正' + IntToHex(w_Stream_Ack.commad,0) );
    goto p_end;
  end;


  //F_PlanMsg_Len ﾃﾞｰﾀ長格納
//  CopyMemory(@w_05,@ServerRecieveBuf,sizeof(w_05));
//  F_PlanMsg_Len := w_05.dlength;
  //F_RealMsg_Len = 0 F_Msg = nil
  F_RealMsg_Len:=0;
  F_sMsg:='';
  //w_Stream_Ack作成
//  w_Stream_Ack.commad:=G_PRTCL_STRM_06;
//  w_Stream_Ack.length:=2;
 // w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
  goto p_end;
  //w_Stream_Ack送信
end;

//07の処理08
//if G_PRTCL_STRM_07=ServerRecieveBuf.commad  then
begin
  //CB_DATA_ERR02 タイムアウト
  if CB_DATA_ERR02.Checked then
  begin
    proc_S_StatusList('電文解析開始失敗...タイムアウト');
    proc_S_StatusList('電文解析完了...');
    //現状電文のない状態にしてタイムアウトにする
    ServerRecieveBuf_LenPlan:=0;
    ServerRecieveBuf_Len:=0;
    FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);
    //応答域クリア
//    FillChar(w_Stream_Ack,sizeof(w_Stream_Ack), #0);
    exit;
  end;
  //CB_DATA_ERR03 失敗
  if CB_DATA_ERR03.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_08;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTNG;
//    proc_S_StatusList('電文解析開始失敗...' + IntToHex(w_Stream_Ack.commad,0) );
    goto p_end;
  end;
  //CB_DATA_ERR03 失敗応答不正
  if CB_DATA_ERR03_B.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_07;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
//    proc_S_StatusList('電文解析開始失敗...応答不正' + IntToHex(w_Stream_Ack.commad,0) );
    goto p_end;
  end;

  //w_Stream_Ack作成 エラー長さ不一致
//  w_DataSize:=ServerRecieveBuf.length;//送信予定電文長
  if (ServerRecieveBuf_Len-4)<>w_DataSize then  //実送信電文と予定との比較
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_08;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTNG;
//    proc_S_StatusList('電文解析開始失敗...長さ不一致' + IntToHex(w_Stream_Ack.commad,0));
    goto p_end;
  end;
try
  //分割メッセージの読み取り蓄積設定
  //F_PlanMsg_Len > F_RealMsg_Len : 格納 F_Msg F_RealMsg_Len
  if F_PlanMsg_Len > F_RealMsg_Len then
  begin
    //分割メッセージの読み取り蓄積
//    w_s:=ServerRecieveBuf.data;
//    SetLength(w_s,ServerRecieveBuf.length);
    F_sMsg := F_sMsg + w_s;
//    F_RealMsg_Len:= F_RealMsg_Len+ServerRecieveBuf.length;
  end;
  //F_PlanMsg_Len = F_RealMsg_Len : F_Msg を→ REdt_RcvCmdData / REdt_RcvAppData
  if F_PlanMsg_Len  <= F_RealMsg_Len then
  begin
    //格納前に符号化変換の必要な場合は変換する
    if g_RIG_CHARCODE_JIS=gi_Rig_CharCode then
    begin
      F_sMsg:=func_SJisToJis(F_sMsg);
    end;

    //F_sMsgのメッセージを格納する
    if G_MSGKIND_IRAI = w_MsgKind_Flag then
    begin
      //
      //受信ﾒｯｾｰｼﾞをエミュレータに表示
      REdt_RcvAppData.Lines.BeginUpdate;
      if  func_IsNullStr(F_sMsg) then
      begin
       REdt_RcvAppData.Lines.Add('*空*');
      end else
      begin
      REdt_RcvAppData.Lines.Add(F_sMsg);
      end;
      REdt_RcvAppData.Lines.EndUpdate;
      REdt_RcvAppData.Refresh;
{
      w_Tstring:=TStringList.Create;
      w_Tstring.Text:= F_sMsg;
      w_Tstring.SaveToFile(G_RunPath + 'testmsg2.txt');
      w_Tstring.Free;
}
      //指定変換エリアがあればそこに格納する
      if w_RcvApplyArea<>nil then
      begin
        w_RcvApplyArea.Clear;
        w_RcvApplyArea.Text:= F_sMsg;
        //w_RcvApplyArea.Add(F_sMsg);
      end;
      w_MsgKind_Flag:=G_MSGKIND_NONE;
    end
    else
    begin

      //受信ﾒｯｾｰｼﾞをエミュレータに表示
      REdt_RcvCmdData.Lines.BeginUpdate;
      if  func_IsNullStr(F_sMsg) then
      begin
       REdt_RcvCmdData.Lines.Add('*空*');
      end else
      begin
      REdt_RcvCmdData.Lines.Add(F_sMsg);
      end;
      REdt_RcvCmdData.Lines.EndUpdate;
      REdt_RcvCmdData.Refresh;
{
      w_Tstring:=TStringList.Create;
      w_Tstring.Text:= F_sMsg;
      w_Tstring.SaveToFile(G_RunPath + 'testmsg3.txt');
      w_Tstring.Free;
}
      //指定変換エリアがあればそこに格納する
      if w_RcvCmdArea<>nil then
      begin
        w_RcvCmdArea.Clear;
        w_RcvCmdArea.Text := F_sMsg;
        //w_RcvCmdArea.Add(F_sMsg);
      end;
      w_MsgKind_Flag:=G_MSGKIND_NONE;
    end;

  end;
  //w_Stream_Ack作成 エラーexcept
except
  //LOG出力
//  w_Stream_Ack.commad:=G_PRTCL_STRM_08;
//  w_Stream_Ack.length:=2;
//  w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTNG;
//  proc_S_StatusList('電文解析開始失敗...' + IntToHex(w_Stream_Ack.commad,0));
  exit;
end;
  //w_Stream_Ack作成 正常
//  w_Stream_Ack.commad:=G_PRTCL_STRM_08;
//  w_Stream_Ack.length:=2;
//  w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
  goto p_end;
  //w_Stream_Ack送信
end;

  proc_S_StatusList('電文解析完了...応答該当なし');
//  ServerRecieveBuf_Len:=0;
//  FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);
exit;


p_end:
  proc_S_StatusList('電文解析完了...');
//  ServerRecieveBuf_Len:=0;
//  FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);

end;

//一単位電文の解析と対処
procedure TFrm_TcpEmu.proc_SendAckStream(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_S_StatusList('応答電文送信開始...');
//  if w_Stream_Ack.commad=0 then
  begin
    proc_S_StatusList('応答電文送信完了...応答電文なし');
    exit;
  end;
//  Socket.SendBuf(w_Stream_Ack,sizeof(w_Stream_Ack));
//  proc_S_StatusList('応答電文送信...< '+ IntToHex(w_Stream_Ack.commad,0) +' > ');
end;

//ステータス表示
procedure TFrm_TcpEmu.proc_S_StatusList(arg_string: string);
begin
  try
    if (self.visible) and (self.Enabled) then
    begin
     REdt_SStatus.Lines.BeginUpdate;
     REdt_SStatus.Lines.Add(arg_string);
     REdt_SStatus.Lines.EndUpdate;
     REdt_SStatus.Refresh;
    end;
  //LOGにも出力する。
    proc_LogOperate('サーバ処理（' + arg_string + '）');
  except
    exit;
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
 * @outline   proc_SetInitialInfo イニシャル情報を設定する
 * @param なし
 * イニシャル情報を設定する。
 *
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmu.proc_SetInitialInfo;
begin
    { 初期化情報設定
    INIファイルの情報を画面と内部に設定する。
     }
    w_Clint_Info.Port1 := StrToIntDef(gi_Ris_Port,0);
    w_Clint_Info.Port2 := StrToIntDef(gi_Ris_Port,0);
    Edt_RISPort1.Text := gi_Ris_Port;

    FServerIP        := gi_Rig_Ip;
    Edt_SrvIp.Text   := gi_Rig_Ip;
    FServerPort      := StrToIntDef(gi_Rig_Port,0);
    Edt_SrvPort1.text := gi_Rig_Port;
    FVersion         := gi_Rig_Version;
    Edt_PTimeOut.Text:= gi_Rig_PTimeOut;
    FPTimeOut        := StrToIntDef(gi_Rig_PTimeOut,G_MINIMUN_TIMEOUT);
    Edt_ATimeOut.Text:= gi_Rig_ATimeOut;
    FATimeOut        := StrToIntDef(gi_Rig_ATimeOut,G_MINIMUN_TIMEOUT);
    FLogActive       := gi_Rig_LogActive;
    FLogPath         := gi_Rig_LogPath+G_PKT_PTH_DEF;
    FLogSize         := StrToIntDef(gi_Rig_LogSize,65536);
    Edt_RisIp.Text   := func_GetThisMachineIPAdrr;

end;
(**
 -------------------------------------------------------------------
 * @outline  proc_Start
 * @param なし
 * フォーム作成以外のサーバ初期化など通信に必要な初期化処理
 *
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmu.proc_Start;
begin
  ServerSocket1.Close;
  //完全に終了化されるまで待つ
  while ServerSocket1.Active  do
  begin
     proc_delay(1000);
  end;
  // サーバーを開始
  ServerSocket1.Port:=StrToInt(Edt_RISPort.Text);
  ServerSocket1.Open ;
  //完全に初期化されるまで待つ
  while not(ServerSocket1.Socket.Connected)  do
  begin
     proc_delay(1000);
  end;

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
procedure TFrm_TcpEmu.proc_End;
begin
  ServerSocket1.close;
  //完全に終了化されるまで待つ
  while ServerSocket1.Socket.Connected  do
  begin
     proc_delay(1000);
  end;
  lbl_show_status.Caption := 'サーバ機能 未初期化';
  lbl_show_status.Font.Color:=clWindowText;

end;
//=============================================================================
//初期／終了化処理↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//=============================================================================
//=============================================================================
//その他公開メソッド↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
//=============================================================================
(**
 -------------------------------------------------------------------
 * @outline  proc_SetSSockInfo
 * @param arg_port:string; ポート
 * 例外あり
 * 受信側のポート情報をセットする。
 *
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmu.proc_SetSSockInfo(arg_port:string);
begin
  self.proc_End;
  Edt_RISPort.text:=arg_port;
  self.proc_Start;
end;
(**
 -------------------------------------------------------------------
 * @outline  proc_SetCSockInfo
 * @param arg_ip:string;
 * @param arg_port:string;
 * 例外あり
 * 送信先のIPｱﾄﾞﾚｽとﾎﾟｰﾄ情報をセットする。func_SendMsgの前に行うと有効になる
 *
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmu.proc_SetCSockInfo(arg_ip:string;arg_port:string);
begin
  Edt_SrvIp.text:=arg_ip;
  Edt_SrvPort1.text:=arg_port;

end;
(**
-----------------------------------------------------------------------------
 * @outline       func_SendMsg
 * @param arg_Msg:TStringList;     ｺﾏﾝﾄﾞまたはｱﾌﾟﾗｲ文字列
 * @param arg_MsgKind:string;      ｺﾏﾝﾄﾞまたはｱﾌﾟﾗｲの種別
 *                                 G_MSGKIND_CMD  ：ｺﾏﾝﾄﾞ
 *                                 G_MSGKIND_APPLY：ｱﾌﾟﾗｲ
 * @param arg_Apply: TStringList;  ｺﾏﾝﾄﾞの結果ｱﾌﾟﾗｲ受信域 OR Nil（非公開）
 * @param arg_Socket:TCustomWinSocket   送信に使用するソケット
 *                                 nil:エミュレータに有るデフォルト
 * @return         例外ない  ｴﾗｰｺｰﾄﾞ
  ｴﾗｰｺｰﾄﾞ(4桁 XXYY
              XX：発生位置01～07
              00：成功
              01：準備確認
              02：準備確認応答（未使用）
              03：コマンド送信
              04：コマンドACK （未使用）
              05：データ長送信
              06：データ長ACK （未使用）
              07：データ送信
              08：データACK   （未使用）
              YY：詳細
              00：成功／許可
              01：送信失敗
              02：無応答
              03：返答失敗／拒否
              )
 * 機能 : ｺﾏﾝﾄﾞｱﾌﾟﾗｲ送信機能
 *
-----------------------------------------------------------------------------
 *)
function TFrm_TcpEmu.func_SendMsg(
                    arg_Msg: TStringList;
                    arg_MsgKind:string;
                    arg_Apply: TStringList;
                    arg_Socket:TClientSocket
                    ): string;
var
  w_RtCode: string;
begin
//引数のチェック
//メッセージ
  if nil=arg_Msg then
  begin //0バイトとして扱う
    result:=G_TCPSND_PRTCL_OK;
    proc_C_StatusList('Complete...func_SendMsg:Nop'+result);
  end;
//メッセージ種別
  if (G_MSGKIND_IRAI<>arg_MsgKind)
     and
     (G_MSGKIND_IRAI<>arg_MsgKind)
     and
     (G_MSGKIND_IRAI<>arg_MsgKind)
  then
  begin
    arg_MsgKind:=G_MSGKIND_IRAI;
  end;
//ソケットのチェック
  if nil = arg_Socket then
  begin
    ClientSocket1.Address:= Edt_SrvIp.Text;
    ClientSocket1.Port:=StrToInt(Edt_SrvPort1.text);
    arg_Socket:=ClientSocket1;
  end;
  //エラーを設定
  try
    //メッセージ種別フラグ設定
    w_MsgKind_Flag:=arg_MsgKind;
    //ｱﾌﾟﾗｲ域の指定
    w_RcvApplyArea:=arg_Apply;
    //ソケットのｵｰﾌﾟﾝ

    if  (arg_Socket.Active) then
    begin
      arg_Socket.Close;
    end;
    arg_Socket.Open;
    //完全に初期化されるまで待つ
    while not(arg_Socket.Socket.Connected) do
    begin
       proc_delay(1000);
    end;
    try
      //プロトコル送信機能  arg_Msg   arg_Socket
      w_RtCode:=func_SendPrtcl(arg_Msg,arg_Socket);

      //ソケットのクローズ
    finally
      arg_Socket.Close;
      Application.ProcessMessages;
      //完全に終了化されるまで待つ
      repeat
        proc_delay(1000);
      until not(arg_Socket.Socket.Connected);
    end;
    result:=w_RtCode;
    proc_C_StatusList('Complete...func_SendMsg:'+result);
    exit;
//①<<----
  except
    //メッセージ種別フラグ設定
    w_MsgKind_Flag:=G_MSGKIND_NONE;
    result:=G_TCPSND_PRTCL01+G_TCPSND_PRTCL_ERR01;
    proc_C_StatusList('Error...func_SendMsg:(例外通信先異常)'+result);
    exit;
//②<<----
  end;

end;
{
-----------------------------------------------------------------------------
  名前 : func_SendPrtcl;
  引数 :
       arg_Msg: TStringList;         ｺﾏﾝﾄﾞまたはｱﾌﾟﾗｲ文字列
       arg_Socket:TCustomWinSocket   送信に使用するソケット
  機能 : プロトコル送信機能
  復帰値：例外ない
  ｴﾗｰｺｰﾄﾞ(4桁 XXYY
              XX：発生位置01～07
              00：成功
              01：準備確認
              02：準備確認応答（未使用）
              03：コマンド送信
              04：コマンドACK （未使用）
              05：データ長送信
              06：データ長ACK （未使用）
              07：データ送信
              08：データACK   （未使用）
              YY：詳細
              00：成功／許可
              01：送信失敗
              02：無応答
              03：返答失敗／拒否
              )
-----------------------------------------------------------------------------
}
function TFrm_TcpEmu.func_SendPrtcl(
                    arg_Msg: TStringList;
                    arg_Socket:TClientSocket
                    ): string;
var
  w_RtCode    : string;       //復帰コード
  w_StreamBase:TStringStream; //ｺﾏﾝﾄﾞまたはｱﾌﾟﾗｲ 元電文
  w_StreamData:TStringStream; //ｺﾏﾝﾄﾞまたはｱﾌﾟﾗｲ送信分割電文
  w_Pos       :Longint;       //ｺﾏﾝﾄﾞまたはｱﾌﾟﾗｲ電文 送信位置
  w_size      :Longint;       //分割電文のサイズ
  w_Recv: TStringList;

begin
  // ①01/03/05/07手順までを行い（ｺﾏﾝﾄﾞ電文9 Tstrings）を送信する
  // ①01手順
     w_RtCode:=func_MakeSendStream(
                        arg_Socket,
                        G_TCPSND_PRTCL01,
                        nil,
                        w_Recv
                         );
     if w_RtCode <> G_TCPSND_PRTCL_OK then
     begin
       w_MsgKind_Flag:=G_MSGKIND_NONE;
       result:=w_RtCode;
       exit;
//①<<----
     end;
  // ①03手順
     w_RtCode:=func_MakeSendStream(
                        arg_Socket,
                        G_TCPSND_PRTCL03,nil,w_Recv );
     if w_RtCode <> G_TCPSND_PRTCL_OK then
     begin
       w_MsgKind_Flag:=G_MSGKIND_NONE;
       result:=w_RtCode;
       exit;
//②<<----
     end;

     if arg_Msg<>nil then
     begin
       try
       //元電文取り出し
       w_StreamBase := func_TStrListToStrm(arg_Msg);
//       arg_Msg.SaveToFile(G_RunPath + 'testmsg1.txt');

       //SHIFTJIS変換呼び出し
         try
           //SJIS変換呼び出し
           if g_RIG_CHARCODE_JIS=gi_Rig_CharCode then
           begin
              proc_JisToSJis(w_StreamBase);
           end;

           if w_StreamBase=nil then
           begin //元電文取り出し失敗
             w_RtCode:=G_TCPSND_PRTCL05+G_TCPSND_PRTCL_ERR01;
             w_MsgKind_Flag:=G_MSGKIND_NONE;
             result:=w_RtCode;
             exit;
//③<<----
           end;
  // ①05手順
           w_RtCode:=func_MakeSendStream(
                        arg_Socket,
                        G_TCPSND_PRTCL05,
                        arg_Msg,
                        w_Recv );
           if w_RtCode <> G_TCPSND_PRTCL_OK then
           begin
             w_MsgKind_Flag:=G_MSGKIND_NONE;
             result:=w_RtCode;
             exit;
//④<<----
           end;
  // ①07 順  G_MAX_STREAM_SIZEで分割して送信
         //0バイト送信
           if 0 = w_StreamBase.Size then
           begin
             w_RtCode:=func_MakeSendStream(
                                         arg_Socket,
                                         G_TCPSND_PRTCL07,
                                         arg_Msg,w_Recv );
             if w_RtCode <> G_TCPSND_PRTCL_OK then
             begin
               w_MsgKind_Flag:=G_MSGKIND_NONE;
               result:=w_RtCode;
               exit;
             end;
           end
           else
           begin
         //分割書き込み開始
             w_StreamBase.Position := 0;
             w_Pos := 0;
             while w_Pos < w_StreamBase.Size do
             begin
             //分割読込み域作成
               w_StreamData := TStringStream.Create('');
               try
                 w_size  :=w_StreamBase.Size - w_Pos;
                 w_size  :=min(w_size, G_MAX_STREAM_SIZE);
                 w_StreamData.WriteString(w_StreamBase.ReadString(w_size));
                 //書き込み
                 w_RtCode:=func_MakeSendStream(
                                         arg_Socket,
                                         G_TCPSND_PRTCL07,
                                         arg_Msg,
                                         w_Recv );
                 if w_RtCode <> G_TCPSND_PRTCL_OK then
                 begin
                   w_MsgKind_Flag:=G_MSGKIND_NONE;
                   result:=w_RtCode;
                   exit;
                 end;
                 w_Pos:=w_Pos+w_size;
               finally
                 w_StreamData.Free;
               end;
             end;
           end;
         finally
           w_StreamBase.Free;
         end;
       except
         w_RtCode:=G_TCPSND_PRTCL07+G_TCPSND_PRTCL_ERR01;
         w_MsgKind_Flag:=G_MSGKIND_NONE;
         result:=w_RtCode;
         //例外の時エラーログを出力する。
         proc_C_StatusList('Error...func_SendPrtcl:'+result);
         exit;
//⑤<<----
       end;
     end else
     begin
       // ①05手順
       w_RtCode:=func_MakeSendStream(
                        arg_Socket,
                        G_TCPSND_PRTCL05,nil,w_Recv );
       if w_RtCode <> G_TCPSND_PRTCL_OK then
       begin
         w_MsgKind_Flag:=G_MSGKIND_NONE;
         result:=w_RtCode;
         exit;
//⑥<<----
       end;
       // ①07 順  G_MAX_STREAM_SIZEで分割して送信
       w_RtCode:=func_MakeSendStream(
                                arg_Socket,
                                G_TCPSND_PRTCL07,
                                nil,w_Recv );
       if w_RtCode <> G_TCPSND_PRTCL_OK then
       begin
         w_MsgKind_Flag:=G_MSGKIND_NONE;
         result:=w_RtCode;
         exit;
//⑦<<----
       end;
     end;
  result:=G_TCPSND_PRTCL_OK;
  proc_C_StatusList('Complete...func_SendPrtcl:'+result);
  exit;
//⑧<<----
end;
{
-----------------------------------------------------------------------------
  名前 : func_MakeSendStream;
  引数 :
    arg_Socket:TCustomWinSocket; 送受信用ソケット
    arg_Order: string;           電文種別
    arg_Data:TStringStream       電文データ
  機能 : ソケット電文の作成送信機能
  復帰値：例外なし
  ｴﾗｰｺｰﾄﾞ(4桁 XXYY
              XX：発生位置01～07
              00：成功
              01：準備確認
              02：準備確認応答（未使用）
              03：コマンド送信
              04：コマンドACK （未使用）
              05：データ長送信
              06：データ長ACK （未使用）
              07：データ送信
              08：データACK   （未使用）
              YY：詳細
              00：成功／許可
              01：送信失敗
              02：無応答
              03：返答失敗／拒否
              )
-----------------------------------------------------------------------------
}
function TFrm_TcpEmu.func_MakeSendStream(
                    arg_Socket:TClientSocket;
                    arg_Order: string;
                    arg_Data:TStringList;
                  var  arg_RecvData:TStringList
                    ): string;
var
  w_RtCode       : string; //エラーコード
  w_TStringStream:TStringStream; //送信データ
  w_RecvStream   :TStringStream;    //受信送信データ
begin
//例外発生しない
  try
    w_TStringStream := func_StrListToStream( arg_Order, arg_Data );
  except
     w_RtCode:=G_TCPSND_PRTCL_ERR01;
     result:=arg_Order+w_RtCode;
     proc_C_StatusList('Error...func_MakeSendStream:'+result);
     exit;
//①<<----
  end;
  if w_TStringStream=nil then
  begin //電文ヘッダー作成できず
     w_RtCode:=G_TCPSND_PRTCL_ERR01;
     result:=arg_Order+w_RtCode;
     exit;
//②<<----
  end;
  //送信時 疑似エラー発生処理
  w_RtCode:=func_ToolVErr(arg_Order);
  if w_RtCode = G_TCPSND_PRTCL_ERR00 then
  begin
    //w_TStringStreamは正常時ソケット所有になるので解放しないこと
    w_RtCode:=func_SendStream(
                     arg_Socket,
                     w_TStringStream,
                     FPTimeOut,
                     w_RecvStream
                     );
  end;
  if w_RtCode <> G_TCPSND_PRTCL_ERR00 then
  begin
     result:=arg_Order+w_RtCode;
     exit;
//③<<----
  end;
  arg_RecvData := func_StreamToStrList( arg_Order, w_RecvStream );
  if arg_RecvData <> nil then
  begin
     result:=arg_Order+w_RtCode;
     exit;
//④<<----
  end;

  result:=G_TCPSND_PRTCL_OK;
  proc_C_StatusList('Complete...func_MakeSendStream:' + result);
  exit;
//⑤<<----

end;
{
-----------------------------------------------------------------------------
  名前 : func_MakeStream;
  引数 : なし
      arg_Order: string;   手順コード
      arg_Data:TStringStream データ文字列
  機能 : ソケット電文作成
  復帰値：ソケット電文 例外発生あり
-----------------------------------------------------------------------------
}
function TFrm_TcpEmu.func_StrListToStream(
                    arg_Order: string;
                    arg_Data:TStringList
                    ): TStringStream;
var
  w_Stream:TStringStream;
//  w_StreamHeader:TStream_Header;
//  w_StreamData05:TStream_Data05;

begin
  //手順によって電文文字列を作成する。
  w_Stream:=TStringStream.Create('');
  try
    if  arg_Order=G_TCPSND_PRTCL01 then
    begin
//       w_StreamHeader.commad:= G_PRTCL_STRM_01;
//       w_StreamHeader.length:= 0;
//       w_Stream.Write(w_StreamHeader,sizeof(w_StreamHeader));
    end;

    if  arg_Order=G_TCPSND_PRTCL02 then
    begin
//       w_StreamHeader.commad:= G_PRTCL_STRM_02;
//       w_StreamHeader.length:= 2;
//       w_Stream.Write(w_StreamHeader,sizeof(w_StreamHeader));
    end;

    if  arg_Order=G_TCPSND_PRTCL03 then
    begin
//       w_StreamHeader.commad:= G_PRTCL_STRM_03;
//       w_StreamHeader.length:= 0;
//       w_Stream.Write(w_StreamHeader,sizeof(w_StreamHeader));
    end;

    if  arg_Order=G_TCPSND_PRTCL04 then
    begin
//       w_StreamHeader.commad:= G_PRTCL_STRM_04;
//       w_StreamHeader.length:= 2;
//       w_Stream.Write(w_StreamHeader,sizeof(w_StreamHeader));
    end;

    if  arg_Order=G_TCPSND_PRTCL05 then
    begin
//       w_StreamData05.commad := G_PRTCL_STRM_05;
//       w_StreamData05.length := 4;
//       w_StreamData05.dlength:= 0;
       if arg_Data<>nil then
       begin
//         w_StreamData05.dlength:= arg_Data.Size;
       end;
//       w_Stream.Write(w_StreamData05,sizeof(w_StreamData05));

    end;

    if  arg_Order=G_TCPSND_PRTCL06 then
    begin
//       w_StreamHeader.commad:= G_PRTCL_STRM_06;
//       w_StreamHeader.length:= 2;
//       w_Stream.Write(w_StreamHeader,sizeof(w_StreamHeader));
    end;

    if  arg_Order=G_TCPSND_PRTCL07 then
    begin
//       w_StreamHeader.commad:= G_PRTCL_STRM_07;
//       w_StreamHeader.length:= 0;
       if arg_Data<>nil then
       begin
//         w_StreamHeader.length:= arg_Data.Size;
       end;
//       w_Stream.Write(w_StreamHeader,sizeof(w_StreamHeader));
       if arg_Data<>nil then
       begin
//         w_Stream.WriteString(arg_Data.DataString);
       end;
    end;

    if  arg_Order=G_TCPSND_PRTCL08 then
    begin
//       w_StreamHeader.commad:= G_PRTCL_STRM_08;
//       w_StreamHeader.length:= 2;
//       w_Stream.Write(w_StreamHeader,sizeof(w_StreamHeader));
    end;

//復帰値電文を設定する
    result:=w_Stream;
    exit;
//①<<----
  except
    w_Stream.free;
    raise;
//②<<----
  end;
end;
function TFrm_TcpEmu.func_StreamToStrList(
                    arg_Order: string;
                    arg_Data:TStringStream
                    ): TStringList;
begin
end;
{
-----------------------------------------------------------------------------
  名前 : func_SendStream;
  引数 : なし
   arg_Socket:TCustomWinSocket;  送信と受信に使用するソケット
   arg_SendStream:TStringStream; 送信データ
   arg_TimeOut: DWORD            タイムアウト時間ms
   arg_RecvStream:TStringStream; 受信データ
  機能 : ｿｹｯﾄ電文送信機能
  復帰値：例外は発生しない
      ｴﾗｰｺｰﾄﾞ(2桁 YY
              YY：詳細
              00：成功／許可
              01：送信失敗
              02：無応答
              03：返答失敗／拒否
              )
-----------------------------------------------------------------------------
}
function TFrm_TcpEmu.func_SendStream(
                    arg_Socket:TClientSocket;
                    arg_SendStream:TStringStream;
                    arg_TimeOut: DWORD;
                    Var arg_RecvStream:TStringStream
                    ): string;
var
   res:Longint;
   w_SendStream_Buf : TStream_Data;
   w_Recv_Buf       : TBuffur;
   w_SocketStream:TWinSocketStream;
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
  w_SocketStream:=TWinSocketStream.Create(arg_Socket.Socket,arg_TimeOut);
  try
    arg_SendStream.Position:=0;
//    arg_Stream.Read(w_SendStream_Buf, arg_Stream.Size);
    //書き込み
    proc_C_StatusList('電文送信開始...< ' + ' >');
    res:=w_SocketStream.Write(arg_SendStream, arg_SendStream.Size);
    if (res < arg_SendStream.Size) then //   失敗：01
    begin
      arg_SendStream.Free;
      result:=G_TCPSND_PRTCL_ERR01;
      proc_C_StatusList('Error...func_SendStream:（①不完全送信）'+result);
      exit;
//①<<----
    end;
  finally
    w_SocketStream.Free;
  end;
  proc_C_StatusList('送信サイズ = '+ IntToStr(res) + 'Byte');
  proc_C_StatusList('電文送信完了...');

// クライアント 非ブロッキング接続
{
//arg_Streamはここで異常時には解放する
  Rtn:=arg_Socket.Socket.SendStream(arg_Stream);
  if Rtn = False then //   失敗：01
  begin
    arg_Stream.Free;
    result:=G_TCPSND_PRTCL_ERR01;
    exit;
  end;
}

except
  arg_SendStream.Free;
  result:=G_TCPSND_PRTCL_ERR01;
  proc_C_StatusList('Error...func_SendStream:（②送信例外）'+result);
  exit;
//②<<----
end;

// クライアント 非ブロッキング接続
//応答を待つ
{
  w_ClintWaitFlag:=True;
  w_finish:= GetTickCount +  arg_TimeOut;
  repeat
    Application.ProcessMessages
  until  (GetTickCount > w_finish) or (True<>w_ClintWaitFlag);
  if (GetTickCount > w_finish) and (w_ClintWaitFlag) then
  begin  //タイムアウト
    result:=G_TCPSND_PRTCL_ERR02;
    exit;
  end;
}

//②応答受信
//  スレッドを作成（返答域、タイムアウト秒数ms）して上記の返答を待つ（タイムアウト時間だけ）
// クライアントブロッキング接続
try
  //読込みストリームを作成
  w_SocketStream:=TWinSocketStream.Create(arg_Socket.Socket,arg_TimeOut);
  try
    //受信読込み準備
    if False=w_SocketStream.WaitForData(arg_TimeOut) then
    begin  //タイムアウト
      result:=G_TCPSND_PRTCL_ERR02;
      proc_C_StatusList('Error...func_SendStream:（③タイムアウト）'+result);
      exit;
//③<<----
    end else
    begin//読込み
      res:=w_SocketStream.Read(w_Recv_Buf,sizeof(w_Recv_Buf));
    end;
    if res=0 then //   空っぽはタイムアウトとなる
    begin
      result:=G_TCPSND_PRTCL_ERR02;
      proc_C_StatusList('Error...func_SendStream:（④空タイムアウト）'+result);
      exit;
//④<<----
    end;
    proc_C_StatusList('応答電文受信...< '+ IntToStr(res) + ' >Byte');
  finally
    w_SocketStream.Free;
  end;

// クライアント 非ブロッキング接続
{
  res:=arg_Socket.Socket.ReceiveBuf(w_Ack_Buf,sizeof(w_Ack_Buf));
  if res=0 then //   空っぽ：02
  begin
    result:=G_TCPSND_PRTCL_ERR02;
    exit;
  end;
  if G_PRTCL_STRM_RTOK<>w_Ack_Buf.ResPns then //   0xffff：03
  begin
    result:=G_TCPSND_PRTCL_ERR03;
    exit;
  end;
}

//③終了処理 正常復帰の設定
  arg_RecvStream:=TStringStream.Create('');
  try
    arg_RecvStream.ReadBuffer(w_Recv_Buf, res);
  except
    arg_RecvStream.Free;
    raise;
  end;
  result:=G_TCPSND_PRTCL_ERR00;
  proc_C_StatusList('Complete...func_SendStream:'+result);
  exit;
//⑥<<----
except
  result:=G_TCPSND_PRTCL_ERR03;
  proc_C_StatusList('Error...func_SendStream:（⑦受信例外）'+result);
  exit;
//⑦<<----
end;

end;
{
-----------------------------------------------------------------------------
  名前 : func_CheckStream;
  引数 :
         arg_Order:string  手順
  機能 : 発生エラーコード
-----------------------------------------------------------------------------
}
function TFrm_TcpEmu.func_CheckStream(
                    arg_Cmd:Word;
                    arg_Ack:Word
                    ): Boolean;
begin
    result := False;
    if  arg_Cmd=G_PRTCL_STRM_01 then
    begin
      if arg_Ack=G_PRTCL_STRM_02 then result:=True;
    end;
    if  arg_Cmd=G_PRTCL_STRM_03 then
    begin
      if arg_Ack=G_PRTCL_STRM_04 then result:=True;
    end;
    if  arg_Cmd=G_PRTCL_STRM_05 then
    begin
      if arg_Ack=G_PRTCL_STRM_06 then result:=True;
    end;
    if  arg_Cmd=G_PRTCL_STRM_07 then
    begin
      if arg_Ack=G_PRTCL_STRM_08 then result:=True;
    end;
    exit;

end;

{
-----------------------------------------------------------------------------
  名前 : func_ToolVErr;
  引数 :
         arg_Order:string  手順
  機能 : 発生エラーコード
-----------------------------------------------------------------------------
}
function TFrm_TcpEmu.func_ToolVErr(
                    arg_Order:string
                    ): string;
begin
    result := G_TCPSND_PRTCL_ERR00;
    if  arg_Order=G_TCPSND_PRTCL01 then
    begin
      if CB_JUNBI_ERR01.Checked then result:=G_TCPSND_PRTCL_ERR01;
    end;

    if  arg_Order=G_TCPSND_PRTCL03 then
    begin
      if CB_COMND_ERR01.Checked then result:=G_TCPSND_PRTCL_ERR01;
    end;

    if  arg_Order=G_TCPSND_PRTCL05 then
    begin
      if CB_DATAL_ERR01.Checked then result:=G_TCPSND_PRTCL_ERR01;
    end;

    if  arg_Order=G_TCPSND_PRTCL07 then
    begin
      if CB_DATA_ERR01.Checked then result:=G_TCPSND_PRTCL_ERR01;
    end;
    exit;

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
function func_TcpEmuOpen(
                         arg_OwnForm:TForm;
                         arg_Visible:boolean;
                         arg_Enable:boolean;
                         arg_RcvCmdArea:TStringList
                         ):TFrm_TcpEmu;
var
  w_TFrm_TcpEmu :TFrm_TcpEmu;
begin
//フォームの作成
  w_TFrm_TcpEmu:= TFrm_TcpEmu.Create(arg_OwnForm);
  try
    w_TFrm_TcpEmu.Visible := arg_Visible;
    w_TFrm_TcpEmu.Enabled := arg_Enable;
    w_TFrm_TcpEmu.w_RcvCmdArea:=arg_RcvCmdArea;
//初期化処理
   w_TFrm_TcpEmu.proc_Start;
   result:=w_TFrm_TcpEmu;
   exit;
//①<<----
   except
     w_TFrm_TcpEmu.Close;
     //result:=nil;
     raise;
//②<<----
   end;
end;
{
-----------------------------------------------------------------------------
  名前 : proc_LogOperate(Operate);
  引数 :
   Operate: string : 操作内容
  機能 : ログに記録する。
  例外はすべて無視するのでなし
-----------------------------------------------------------------------------
}
procedure proc_LogOperate(const Operate: string);
var
  Path, PathBak: string;
  buffer: string;
  hd, Size: Integer;
  fp: TextFile;
begin
  // ログが無効の場合は、何もしない。
  if gi_Rig_LogActive=g_RIG_LOGDEACTIVE then Exit;
try
  Path:=gi_Rig_LogPath + G_PKT_PTH_DEF;
  PathBak:=ChangeFileExt(Path, '.bak');
  buffer:=FormatDateTime('yyyy/mm/dd hh:mm:ss', Now)+','+Operate;

  if FileExists(Path) then
  begin
    // ログのサイズを確認する。
    hd:=FileOpen(Path, fmOpenRead or fmShareDenyWrite);
    Size:=GetFileSize(hd, nil);
    FileClose(hd);
    if Size>StrToIntDef(gi_Rig_LogSize,65536) then
    begin
      // 一定サイズを超えた場合は、バックアップをとる。
      if FileExists(PathBak) then DeleteFile(PathBak);
      RenameFile(Path, PathBak);
      AssignFile(fp, Path);
      Rewrite(fp);
      Writeln(fp, buffer);
      CloseFile(fp);
    end
    else
    begin
      // 既存のログに追記する。
      AssignFile(fp, Path);
      Append(fp);
      Writeln(fp, buffer);
      CloseFile(fp);
    end;
  end
  else
  begin
    // 新規にログを作成する。
    AssignFile(fp, Path);
    Rewrite(fp);
    Writeln(fp, buffer);
    CloseFile(fp);
  end;
except
  exit;
end;
end;

{
-----------------------------------------------------------------------------
  名前 : func_TStrListToStrm;
  引数 :
  arg_TStringList:TStringList
  機能 : TStringListよりストリームを作成する
  復帰値：TStringStream nil失敗
-----------------------------------------------------------------------------
}
function func_TStrListToStrm(arg_TStringList:TStringList):TStringStream;
var
// w_i:integer;
 w_TStringStream:TStringStream;
// w_TMemoryStream:TMemoryStream;
// w_s:string;
begin
  try // ストリーム作成
    w_TStringStream:=TStringStream.Create('');
//  w_TMemoryStream:=TMemoryStream.Create;
  except
    result:=nil;
    exit;
  end;
  try
//TStringList→TStringStreamに展開
//    arg_TStringList.SaveToStream(w_TStringStream);
//TMemoryStreamを使った時
//    arg_TStringList.SaveToStream(w_TMemoryStream); 性能に違いなし
      w_TStringStream.WriteString(arg_TStringList.Text);
//一ラインずつ読み込む 遅い
//    for w_i:=0 to  arg_TStringList.Count-1 do
//    begin
//      w_TStringStream.WriteString(arg_TStringList[w_i] + #13#10 );
//    end;
  except
    w_TStringStream.Free;
    result:=nil;
    exit;
//①<<----
  end;
  result:=w_TStringStream;
//①<<----
end;


///// JISコードをSJISコードに変換 - 1文字
function Jis_SJis(c0,c1: AnsiChar): AnsiString;
var
  b0,b1,off: byte;
begin
  b0 := Byte(c0);
  b1 := Byte(c1);
  Result := '';
  if (b0 < 33) or (b0 > 126) then exit;  //0x21-  0x7E only
  off := 126;
  if b0 mod 2 = 1 then
    if b1 < 96 then off := 31 else off := 32;  //60  1F  20
  b1 := b1 + off;
  if b0 < 95 then off := 112 else off := 176;
  b0 := ((b0 + 1) shr 1) + off;
  Result := AnsiChar(b0) + AnsiChar(b1);
end;
///// SJISコードをJISコードに変換 - 1文字
function SJis_Jis(c0,c1: AnsiChar): AnsiString;
var
  b0,b1,adj,off: byte;
begin
  b0 := Byte(c0);
  b1 := Byte(c1);
  Result := '';
  if b0 <= 159 then off := 112 else off := 176;
  if b1 < 159  then adj := 1   else adj := 0;
  b0 := ((b0 - off) shl 1) - adj;
  off := 126;
  if b1 < 127 then off := 31 else if b1 < 159 then off := 32;
  b1 := b1 - off;
  Result := AnsiChar(b0) + AnsiChar(b1);
end;


// JISコードをSJISコードに変換 - 文字列
function JisToSJis(const s: AnsiString): AnsiString;
var
i: integer;
flg: boolean;
begin
  flg := false;
  Result := '';
  i := 1;
  while (i <= Length(s)) do
  begin
    if Copy(s,i,3) = #27 + '$B' then   //jis1983 only jis1978 $@ not support
    begin
      flg := true;
      i   := i + 3;
    end;
    if Copy(s,i,3) = #27 + '(B' then   //ascii only    jis8 (j not support
    begin
      flg := false;
      i   := i + 3;
    end;

    if flg then
    begin
      Result := Result + Jis_Sjis(s[i],s[i+1]);
      inc(i);
    end else
      Result := Result + s[i];

    inc(i);
  end;
end;
///// SJISコードをJISコードに変換
function SJisToJis(const s: AnsiString): AnsiString;
var
i: integer;
flg: boolean;
begin
  flg := false;
  Result := '';
  i := 1;
  while (i <= Length(s)) do
  begin
    if ByteType(s,i) = mbLeadByte then
    begin
      if not flg then //New Kanji
      begin
        flg    := true;
        Result := Result + #27 + '$B'; //Kanji IN 追加
      end;
      Result := Result + Sjis_Jis(s[i],s[i+1]);
      inc(i);
    end else
    begin
      if flg then
      begin
        flg    := false;
        Result := Result + #27 + '(B'; //Kanji OUT 追加
      end;
      Result := Result + s[i];
    end;
    inc(i);
  end;
  if flg then Result := Result + #27 + '(B'; //最後にAsciiにする
end;


procedure proc_JisToSJis(arg_Stream: TStringStream);
var
 w_s:string;
begin
    w_s:=JisToSJis(arg_Stream.DataString);
    arg_Stream.Position:=0;
    arg_Stream.WriteString(w_s);

end;
function func_SJisToJis(arg_Stream: string): string;
begin
    result:=SJisToJis(arg_Stream);
end;
///// SJISコードをJISコードに変換 - 1文字
function func_MakeSJIS: String;
var
  b0,b1: byte;
  w_s:string;
//  w_i:integer;
//  w_l:integer;
//  c0,c1: AnsiChar
begin
  w_s := '';

  for b0:=byte(#$20) to byte(#$7E) do
  begin
    w_s := w_s+AnsiChar(b0) ;
  end;
  w_s := w_s + #13#10;
  for b0:=byte(#$81) to byte(#$9F) do
  begin
    for b1:=byte(#$40) to byte(#$7E) do
    begin
     w_s := w_s+AnsiChar(b0) + AnsiChar(b1);
    end;
    w_s := w_s + #13#10;
  end;
  for b0:=byte(#$81) to byte(#$9F) do
  begin
    for b1:=byte(#$80) to byte(#$FC) do
    begin
     w_s := w_s+AnsiChar(b0) + AnsiChar(b1);
    end;
    w_s := w_s + #13#10;
  end;
  for b0:=byte(#$E0) to byte(#$EF) do
  begin
    for b1:=byte(#$40) to byte(#$7E) do
    begin
     w_s := w_s+AnsiChar(b0) + AnsiChar(b1);
    end;
    w_s := w_s + #13#10;
  end;
  for b0:=byte(#$E0) to byte(#$EF) do
  begin
    for b1:=byte(#$80) to byte(#$FC) do
    begin
     w_s := w_s+AnsiChar(b0) + AnsiChar(b1);
    end;
    w_s := w_s + #13#10;
  end;

  Result := w_s;
end;

//=============================================================================
//公開関数↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
//=============================================================================


procedure TFrm_TcpEmu.Button19Click(Sender: TObject);
begin
REdt_RcvCmdData2.Clear;

end;

procedure TFrm_TcpEmu.Button16Click(Sender: TObject);
begin
   REdt_RcvCmdData2.Lines.SaveToFile(IncludeTrailingBackslash(FileListBox1.Directory) +Edit_SvRvSaveFl2.Text);

end;

procedure TFrm_TcpEmu.Button17Click(Sender: TObject);
begin
REdt_RcvAppData2.Clear;

end;

procedure TFrm_TcpEmu.Button18Click(Sender: TObject);
begin
   REdt_RcvAppData2.Lines.SaveToFile(IncludeTrailingBackslash(FileListBox1.Directory) +Edit_SvSdSaveFl2.Text);

end;

procedure TFrm_TcpEmu.Edt_SrvIp1Change(Sender: TObject);
begin
    w_Clint_Info.IPAdrr1 := Edt_SrvIp1.text;

end;

procedure TFrm_TcpEmu.Edt_SrvIp2Change(Sender: TObject);
begin
    w_Clint_Info.IPAdrr2 := Edt_SrvIp2.text;

end;

procedure TFrm_TcpEmu.Edt_SrvIp3Change(Sender: TObject);
begin
    w_Clint_Info.IPAdrr3 := Edt_SrvIp3.text;

end;

procedure TFrm_TcpEmu.Edt_PTimeOut2Change(Sender: TObject);
begin
    w_Clint_Info.STimeOut2 := StrToIntDef(Edt_PTimeOut2.Text,G_MAX_STREAM_SIZE);

end;

procedure TFrm_TcpEmu.Edt_PTimeOut3Change(Sender: TObject);
begin
    w_Clint_Info.STimeOut3 := StrToIntDef(Edt_PTimeOut3.Text,G_MAX_STREAM_SIZE);

end;

procedure TFrm_TcpEmu.Edt_SrvPort1Change(Sender: TObject);
begin
    w_Clint_Info.Port1 := Edt_SrvPort1.text;

end;

procedure TFrm_TcpEmu.Edt_SrvPort2Change(Sender: TObject);
begin
    w_Clint_Info.Port2 := Edt_SrvPort2.text;

end;

procedure TFrm_TcpEmu.Edt_SrvPort3Change(Sender: TObject);
begin
    w_Clint_Info.Port3 := Edt_SrvPort3.text;

end;

procedure TFrm_TcpEmu.Btn_RcvClear2Click(Sender: TObject);
begin
REdt_RcvCmdData2.Clear;

end;

procedure TFrm_TcpEmu.Btn_RcvDClear2Click(Sender: TObject);
begin
REdt_RcvAppData2.Clear;

end;

procedure TFrm_TcpEmu.btn_SRsave2Click(Sender: TObject);
begin
   REdt_RcvCmdData2.Lines.SaveToFile(IncludeTrailingBackslash(FileListBox1.Directory) +Edit_SvRvSaveFl2.Text);

end;

procedure TFrm_TcpEmu.btn_SRsave3Click(Sender: TObject);
begin
   REdt_RcvCmdData3.Lines.SaveToFile(IncludeTrailingBackslash(FileListBox1.Directory) +Edit_SvRvSaveFl3.Text);

end;

procedure TFrm_TcpEmu.Btn_RcvClear3Click(Sender: TObject);
begin
REdt_RcvCmdData3.Clear;

end;

procedure TFrm_TcpEmu.Btn_RcvDClear3Click(Sender: TObject);
begin
REdt_RcvAppData3.Clear;

end;

procedure TFrm_TcpEmu.btn_SSsave2Click(Sender: TObject);
begin
   REdt_RcvAppData2.Lines.SaveToFile(IncludeTrailingBackslash(FileListBox1.Directory) +Edit_SvSdSaveFl2.Text);

end;

procedure TFrm_TcpEmu.btn_SSsave3Click(Sender: TObject);
begin
   REdt_RcvAppData3.Lines.SaveToFile(IncludeTrailingBackslash(FileListBox1.Directory) +Edit_SvSdSaveFl3.Text);

end;

end.
