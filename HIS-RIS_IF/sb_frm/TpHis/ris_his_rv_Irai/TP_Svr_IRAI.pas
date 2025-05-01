unit TP_Svr_IRAI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, Db,
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Gval,
  HisMsgDef,
  HisMsgDef01_IRAI,
  TcpSocket,
  FTcpEmuS,
  UDb_RisSvr_Irai, Buttons, ExtCtrls, DBTables,
  ComCtrls
  ;
const
  CST_DB_S_COUNT = 0;
  CST_DB_E_COUNT = 16;
  //テーブル表示名
  type TDB_DISP_TITLE = array[CST_DB_S_COUNT..CST_DB_E_COUNT] of String;
  const
    DB_DISP_TITLE : TDB_DISP_TITLE =
    (
     'オーダメインテーブル','オーダ部位テーブル',
     'オーダ指示テーブル','患者マスタ','受信オーダテーブル','拡張オーダ情報テーブル',
     'オーダシェーマ情報テーブル','実績メインテーブル','検査情報テーブル',
     'レポート情報テーブル','所見患者テーブル','治療オーダメインテーブル','治療拡張オーダテーブル',
     'オーダメインSNテーブル','治療実績メインテーブル','拡張実績メインテーブル','治療患者テーブル'
    );
  //テーブル名
  type TDB_TITLE = array[CST_DB_S_COUNT..CST_DB_E_COUNT] of String;
  const
    DB_TITLE : TDB_TITLE =
    (
     'Tbl_ORDERMAINTABLE','Tbl_ORDERBUITABLE',
     'Tbl_ORDERINDICATETABLE','Tbl_KANJAMASTER','Tbl_JUSINORDERTABLE',
     'Tbl_EXTENDORDERINFO','Tbl_ORDERSHEMAINFO','Tbl_EXMAINTABLE','Tbl_EXAMINFO',
     'Tbl_REPORTINFO','Tbl_RepPATIENTINFO','Tbl_RTORDERMAINTABLE','Tbl_ORDERMAIN_EXTEND_TABLE','Tbl_ORDERMAIN_SN_TABLE',
     'Tbl_RTEXMAINTABLE','Tbl_EXMAIN_EXTEND_TABLE','Tbl_RTPATIENTINFO'
    );

type
  TForm1 = class(TForm)
    lbl_err: TLabel;
    lbl_res: TLabel;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    Panel1: TPanel;
    Button10: TButton;
    Button16: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Panel2: TPanel;
    Edit3: TEdit;
    Button13: TButton;
    Edit4: TEdit;
    Edit5: TEdit;
    Tbl_EXTENDORDERINFO: TTable;
    Tbl_ORDERMAINTABLE: TTable;
    Tbl_ORDERBUITABLE: TTable;
    Panel10: TPanel;
    mem_msg: TMemo;
    ComboBox1: TComboBox;
    Button2: TButton;
    arg_Keep: TEdit;
    Button11: TButton;
    DataSource4: TDataSource;
    Button3: TButton;
    Button4: TButton;
    Edit2: TEdit;
    StaticText5: TStaticText;
    Button6: TButton;
    BitBtn7: TBitBtn;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    Panel5: TPanel;
    StaticText2: TStaticText;
    DBGrid1: TDBGrid;
    TabSheet3: TTabSheet;
    Panel7: TPanel;
    StaticText4: TStaticText;
    DBGrid4: TDBGrid;
    TabSheet5: TTabSheet;
    Panel12: TPanel;
    StaticText6: TStaticText;
    DBGrid6: TDBGrid;
    Memo1: TMemo;
    TabSheet6: TTabSheet;
    Panel13: TPanel;
    StaticText7: TStaticText;
    DBGrid7: TDBGrid;
    TabSheet7: TTabSheet;
    Panel4: TPanel;
    DBGrid2: TDBGrid;
    StaticText8: TStaticText;
    Panel8: TPanel;
    BitBtn3: TBitBtn;
    BitBtn8: TBitBtn;
    Tbl_ORDERINDICATETABLE: TTable;
    DataSource5: TDataSource;
    Tbl_KANJAMASTER: TTable;
    DataSource6: TDataSource;
    Tbl_JUSINORDERTABLE: TTable;
    DataSource7: TDataSource;
    Panel3: TPanel;
    StaticText9: TStaticText;
    CB_Table: TComboBox;
    CB_Table_Name: TComboBox;
    CB_DBGrid_Name: TComboBox;
    StaticText10: TStaticText;
    CB_Columns: TComboBox;
    CB_Columns_Name: TComboBox;
    StaticText11: TStaticText;
    ED_Date: TEdit;
    CB_Jyouken: TComboBox;
    Button1: TButton;
    StaticText12: TStaticText;
    Memo2: TMemo;
    Button5: TButton;
    Button7: TButton;
    StaticText13: TStaticText;
    CB_Jyouken2: TComboBox;
    StaticText14: TStaticText;
    Button8: TButton;
    Button9: TButton;
    TabSheet1: TTabSheet;
    Panel6: TPanel;
    StaticText1: TStaticText;
    DBGrid3: TDBGrid;
    Tbl_ORDERBUIDETAILTABLE: TTable;
    DataSource8: TDataSource;
    TabSheet8: TTabSheet;
    Panel11: TPanel;
    StaticText15: TStaticText;
    DBGrid8: TDBGrid;
    Tbl_ORDERSHEMAINFO: TTable;
    DataSource9: TDataSource;
    TabSheet9: TTabSheet;
    Panel14: TPanel;
    StaticText16: TStaticText;
    DBGrid9: TDBGrid;
    Tbl_EXMAINTABLE: TTable;
    DataSource3: TDataSource;
    TabSheet10: TTabSheet;
    Panel15: TPanel;
    StaticText17: TStaticText;
    DBGrid10: TDBGrid;
    Tbl_EXAMINFO: TTable;
    DataSource10: TDataSource;
    TabSheet11: TTabSheet;
    Panel16: TPanel;
    StaticText18: TStaticText;
    DBGrid11: TDBGrid;
    Tbl_REPORTINFO: TTable;
    DataSource11: TDataSource;
    TabSheet12: TTabSheet;
    Panel17: TPanel;
    StaticText19: TStaticText;
    DBGrid12: TDBGrid;
    Tbl_RepPATIENTINFO: TTable;
    DataSource12: TDataSource;
    TabSheet13: TTabSheet;
    Tbl_RTORDERMAINTABLE: TTable;
    DataSource13: TDataSource;
    Panel18: TPanel;
    StaticText20: TStaticText;
    DBGrid13: TDBGrid;
    TabSheet14: TTabSheet;
    Panel19: TPanel;
    StaticText21: TStaticText;
    DBGrid14: TDBGrid;
    Tbl_ORDERMAIN_EXTEND_TABLE: TTable;
    DataSource14: TDataSource;
    TabSheet15: TTabSheet;
    Panel20: TPanel;
    StaticText22: TStaticText;
    DBGrid15: TDBGrid;
    Tbl_ORDERMAIN_SN_TABLE: TTable;
    DataSource15: TDataSource;
    Tbl_RTEXMAINTABLE: TTable;
    DataSource16: TDataSource;
    TabSheet16: TTabSheet;
    Panel21: TPanel;
    StaticText23: TStaticText;
    DBGrid16: TDBGrid;
    TabSheet17: TTabSheet;
    Panel22: TPanel;
    StaticText24: TStaticText;
    DBGrid17: TDBGrid;
    Tbl_EXMAIN_EXTEND_TABLE: TTable;
    DataSource17: TDataSource;
    TabSheet18: TTabSheet;
    Panel23: TPanel;
    StaticText25: TStaticText;
    DBGrid18: TDBGrid;
    Tbl_RTPATIENTINFO: TTable;
    DataSource18: TDataSource;
    procedure Button2Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure StaticText2Click(Sender: TObject);
    procedure StaticText3Click(Sender: TObject);
    procedure StaticText7Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure StaticText4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure StaticText6Click(Sender: TObject);
    procedure StaticText8Click(Sender: TObject);
    procedure CB_TableChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CB_ColumnsChange(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure StaticText15Click(Sender: TObject);
    procedure StaticText16Click(Sender: TObject);
    procedure StaticText17Click(Sender: TObject);
    procedure StaticText18Click(Sender: TObject);
    procedure StaticText19Click(Sender: TObject);
    procedure StaticText20Click(Sender: TObject);
    procedure StaticText21Click(Sender: TObject);
    procedure StaticText22Click(Sender: TObject);
    procedure StaticText23Click(Sender: TObject);
    procedure StaticText24Click(Sender: TObject);
    procedure StaticText25Click(Sender: TObject);
  private
    { Private 宣言 }
    w_Err:string;
    w_res:boolean;
    w_res1:boolean;
    w_res2:boolean;
    w_res3:boolean;
    w_Ini_Flg:Boolean;
    w_SendMsgStream : TStringStream;
    w_RecvMsgStream : TStringStream;
    w_DataStream    : TStringStream;
    w_RecvMsgTimeS  : string;     // YYYY/MM/DD hh:mi:ss
    w_LogBuffer     : string;
    wg_DBGrid       : array [CST_DB_S_COUNT..CST_DB_E_COUNT] of TControl;
    wg_Table        : array [CST_DB_S_COUNT..CST_DB_E_COUNT] of TTable;
    procedure proc_Get_ColumnsName;
  public
    { Public 宣言 }
  end;

var
  Form1: TForm1;

implementation

uses URH_SvrSvc_Irai;

{$R *.DFM}

procedure TForm1.Button2Click(Sender: TObject);
begin
  //受信オーダテーブルから指定に期間を過ぎたレコードの削除
  w_res := DB_RisSvr_Irai.func_DelOrder(StrToIntDef(arg_Keep.text,10),w_Err);
  //状態表示
  lbl_err.Caption := w_Err;
  //正常の場合
  if w_res then
    lbl_res.Caption:= 'True'
  //異常の場合
  else
    lbl_res.Caption:= 'False';
end;

procedure TForm1.Button10Click(Sender: TObject);
var
  w_Res:Boolean;
begin
  //RisDB切断
  DB_RisSvr_Irai.DBClose;
  //文字色を変更？
  BitBtn1.Font.Color := clBlack;
  Button5.Enabled := False;
  Button7.Enabled := False;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  //各テーブルの再読み込み
  //切断
  Tbl_ORDERMAINTABLE.Close;
  Tbl_ORDERBUITABLE.Close;
  Tbl_ORDERINDICATETABLE.Close;
  Tbl_KANJAMASTER.Close;
  Tbl_JUSINORDERTABLE.Close;
  Tbl_EXTENDORDERINFO.Close;
  //Tbl_ORDERBUIDETAILTABLE.Close;
  Tbl_ORDERSHEMAINFO.Close;
  Tbl_EXMAINTABLE.Close;
  Tbl_EXAMINFO.Close;
  Tbl_REPORTINFO.Close;
  Tbl_RepPATIENTINFO.Close;
  {
  Tbl_RTORDERMAINTABLE.Close;
  Tbl_ORDERMAIN_EXTEND_TABLE.Close;
  Tbl_ORDERMAIN_SN_TABLE.Close;
  Tbl_RTEXMAINTABLE.Close;
  Tbl_EXMAIN_EXTEND_TABLE.Close;
  Tbl_RTPATIENTINFO.Close;
  }
  //接続
  Tbl_ORDERMAINTABLE.Open;
  Tbl_ORDERBUITABLE.Open;
  Tbl_ORDERINDICATETABLE.Open;
  Tbl_KANJAMASTER.Open;
  Tbl_JUSINORDERTABLE.Open;
  Tbl_EXTENDORDERINFO.Open;
  //Tbl_ORDERBUIDETAILTABLE.Open;
  Tbl_ORDERSHEMAINFO.Open;
  Tbl_EXMAINTABLE.Open;
  Tbl_EXAMINFO.Open;
  Tbl_REPORTINFO.Open;
  Tbl_RepPATIENTINFO.Open;
  {
  Tbl_RTORDERMAINTABLE.Open;
  Tbl_ORDERMAIN_EXTEND_TABLE.Open;
  Tbl_ORDERMAIN_SN_TABLE.Open;
  Tbl_RTEXMAINTABLE.Open;
  Tbl_EXMAIN_EXTEND_TABLE.Open;
  Tbl_RTPATIENTINFO.Open;
  }
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  w_i : Integer;
begin
  //初期化
  w_SendMsgStream := TStringStream.Create('');
  w_RecvMsgStream := TStringStream.Create('');
  w_DataStream    := TStringStream.Create('');
  proc_FrmCenter(self);
  PageControl1.ActivePageIndex := 0;
  for w_i := CST_DB_S_COUNT to CST_DB_E_COUNT do begin
    CB_Table.Items.Add(DB_DISP_TITLE[w_i]);
    CB_Table_Name.Items.Add(DB_TITLE[w_i]);
  end;
  wg_DBGrid[0] := DBGrid1;
  wg_DBGrid[1] := DBGrid4;
  wg_DBGrid[2] := DBGrid6;
  wg_DBGrid[3] := DBGrid7;
  wg_DBGrid[4] := DBGrid2;
  wg_DBGrid[5] := DBGrid3;
  //wg_DBGrid[6] := DBGrid5;
  wg_DBGrid[6] := DBGrid8;
  wg_DBGrid[7] := DBGrid9;
  wg_DBGrid[8] := DBGrid10;
  wg_DBGrid[9] := DBGrid11;
  wg_DBGrid[10] := DBGrid12;
  wg_DBGrid[11] := DBGrid13;
  wg_DBGrid[12] := DBGrid14;
  wg_DBGrid[13] := DBGrid15;
  wg_DBGrid[14] := DBGrid16;
  wg_DBGrid[15] := DBGrid17;
  wg_DBGrid[16] := DBGrid18;

  wg_Table[0] := Tbl_ORDERMAINTABLE;
  wg_Table[1] := Tbl_ORDERBUITABLE;
  wg_Table[2] := Tbl_ORDERINDICATETABLE;
  wg_Table[3] := Tbl_KANJAMASTER;
  wg_Table[4] := Tbl_JUSINORDERTABLE;
  wg_Table[5] := Tbl_EXTENDORDERINFO;
  //wg_Table[6] := Tbl_ORDERBUIDETAILTABLE;
  wg_Table[6] := Tbl_ORDERSHEMAINFO;
  wg_Table[7] := Tbl_EXMAINTABLE;
  wg_Table[8] := Tbl_EXAMINFO;
  wg_Table[9] := Tbl_REPORTINFO;
  wg_Table[10] := Tbl_RepPATIENTINFO;
  wg_Table[11] := Tbl_RTORDERMAINTABLE;
  wg_Table[12] := Tbl_ORDERMAIN_EXTEND_TABLE;
  wg_Table[13] := Tbl_ORDERMAIN_SN_TABLE;
  wg_Table[14] := Tbl_RTEXMAINTABLE;
  wg_Table[15] := Tbl_EXMAIN_EXTEND_TABLE;
  wg_Table[16] := Tbl_RTPATIENTINFO;

  CB_Jyouken.Items.Add('AND');
  CB_Jyouken.Items.Add('OR');
  CB_Jyouken.Items.Add('NOT');
  CB_Jyouken2.Items.Add('<');
  CB_Jyouken2.Items.Add('>');
  CB_Jyouken2.Items.Add('<=');
  CB_Jyouken2.Items.Add('>=');
  CB_Jyouken2.Items.Add('=');
  CB_Jyouken2.Items.Add('<>');

  Button5.Enabled := False;
  Button7.Enabled := False;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  //行ロック開始
  w_res := DB_RisSvr_Irai.func_LockTbl(Edit3.Text,Edit4.Text,Edit5.Text,ComboBox1.Text);
  //成功
  if w_res then
    lbl_res.Caption:= 'True'
  //失敗
  else
    lbl_res.Caption:= 'False';
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
  //ロールバック
  DB_RisSvr_Irai.DatabaseRis.Rollback;
  //文字色の変更
  BitBtn2.Font.Color := clBlack;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  w_Res:Boolean;
begin
  //RisDB接続処理
  w_res := DB_RisSvr_Irai.DBOpen(w_Err,nil);
  //エラー状況表示
  lbl_err.Caption := w_Err;
  //正常終了の場合
  if w_res then begin
    //戻り値を表示
    lbl_res.Caption := 'True';
    //文字色を変更
    BitBtn1.Font.Color := clRed;
    Tbl_ORDERMAINTABLE.DatabaseName     := DB_RisSvr_Irai.DatabaseRis.DatabaseName;
    Tbl_ORDERBUITABLE.DatabaseName      := DB_RisSvr_Irai.DatabaseRis.DatabaseName;
    Tbl_ORDERINDICATETABLE.DatabaseName := DB_RisSvr_Irai.DatabaseRis.DatabaseName;
    Tbl_KANJAMASTER.DatabaseName        := DB_RisSvr_Irai.DatabaseRis.DatabaseName;
    Tbl_JUSINORDERTABLE.DatabaseName    := DB_RisSvr_Irai.DatabaseRis.DatabaseName;
    Tbl_EXTENDORDERINFO.DatabaseName    := DB_RisSvr_Irai.DatabaseRis.DatabaseName;
    //Tbl_ORDERBUIDETAILTABLE.DatabaseName:= DB_RisSvr_Irai.DatabaseRis.DatabaseName;
    Tbl_ORDERSHEMAINFO.DatabaseName     := DB_RisSvr_Irai.DatabaseRis.DatabaseName;
    Tbl_EXMAINTABLE.DatabaseName        := DB_RisSvr_Irai.DatabaseRis.DatabaseName;
    Tbl_EXAMINFO.DatabaseName           := DB_RisSvr_Irai.DatabaseRep.DatabaseName;
    Tbl_REPORTINFO.DatabaseName         := DB_RisSvr_Irai.DatabaseRep.DatabaseName;
    Tbl_RepPATIENTINFO.DatabaseName     := DB_RisSvr_Irai.DatabaseRep.DatabaseName;
    {
    Tbl_RTORDERMAINTABLE.DatabaseName   := DB_RisSvr_Irai.DatabaseRtR.DatabaseName;
    Tbl_ORDERMAIN_EXTEND_TABLE.DatabaseName := DB_RisSvr_Irai.DatabaseRtR.DatabaseName;
    Tbl_ORDERMAIN_SN_TABLE.DatabaseName := DB_RisSvr_Irai.DatabaseRtR.DatabaseName;
    Tbl_RTEXMAINTABLE.DatabaseName      := DB_RisSvr_Irai.DatabaseRtR.DatabaseName;
    Tbl_EXMAIN_EXTEND_TABLE.DatabaseName      := DB_RisSvr_Irai.DatabaseRtR.DatabaseName;
    Tbl_RTPATIENTINFO.DatabaseName      := DB_RisSvr_Irai.DatabaseRtR.DatabaseName;
    }

    //各関連テーブルオープン
    Tbl_ORDERMAINTABLE.Open;
    Tbl_ORDERBUITABLE.Open;
    Tbl_ORDERINDICATETABLE.Open;
    Tbl_KANJAMASTER.Open;
    Tbl_JUSINORDERTABLE.Open;
    Tbl_EXTENDORDERINFO.Open;
    //Tbl_ORDERBUIDETAILTABLE.Open;
    Tbl_ORDERSHEMAINFO.Open;
    Tbl_EXMAINTABLE.Open;
    {
    Tbl_RTORDERMAINTABLE.Open;
    Tbl_ORDERMAIN_EXTEND_TABLE.Open;
    Tbl_ORDERMAIN_SN_TABLE.Open;
    Tbl_RTEXMAINTABLE.Open;
    Tbl_EXMAIN_EXTEND_TABLE.Open;
    Tbl_RTPATIENTINFO.Open;
    Tbl_EXAMINFO.Open;
    }
    Tbl_REPORTINFO.Open;
    Tbl_RepPATIENTINFO.Open;

    Button5.Enabled := True;
    Button7.Enabled := True;
  end
  //異常終了
  else begin
    //戻り値を表示
    lbl_res.Caption := 'False';
    //文字色はそのまま
    BitBtn1.Font.Color := clBlack;
  end; 
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  //トランザクション開始
  DB_RisSvr_Irai.DatabaseRis.StartTransaction;
  //文字色変更
  BitBtn2.Font.Color := clRed;
end;

procedure TForm1.Button18Click(Sender: TObject);
begin
  //チェックがすべて正常の場合
  if w_res1 and w_res2 and w_res3 then begin
    //ログ出力
    proc_LogOut(G_LOG_LINE_HEAD_OK,w_RecvMsgTimeS,G_LOG_KIND_DB_NUM,w_LogBuffer) ;
  end
  //それ以外の場合
  else begin
    //ログ出力
    proc_LogOut(G_LOG_LINE_HEAD_NG,w_RecvMsgTimeS,G_LOG_KIND_DB_NUM,w_LogBuffer) ;
  end;
end;

procedure TForm1.StaticText2Click(Sender: TObject);
begin
   Tbl_ORDERMAINTABLE.Close;
   Tbl_ORDERMAINTABLE.Open;
end;

procedure TForm1.StaticText3Click(Sender: TObject);
begin
   //Tbl_ORDERBUIDETAILTABLE.Close;
   //Tbl_ORDERBUIDETAILTABLE.Open;
end;

procedure TForm1.StaticText7Click(Sender: TObject);
begin
  Tbl_KANJAMASTER.Close;
  Tbl_KANJAMASTER.Open;
end;

procedure TForm1.BitBtn7Click(Sender: TObject);
var
  w_s:string;
begin
  //テーブルが接続されていて、レコードがある場合
  if Tbl_JUSINORDERTABLE.Active and (Tbl_JUSINORDERTABLE.RecordCount > 0) then begin
    //電文を取得
    w_s := Tbl_JUSINORDERTABLE.FieldByName('RECIEVETEXT').AsString;
    //初期化
    w_DataStream.Position := 0;
    //文字列化
    w_DataStream.WriteString(w_s);
    //クリア
    mem_msg.Lines.clear;
    //mem_msg.Text := Tbl_JUSINORDERTABLE.FieldByName('RECIEVETEXT').AsString;
    if Tbl_JUSINORDERTABLE.FieldByName('MESSAGETYPE').AsString = CST_APPTYPE_OI01 then
    begin
      //表示
      proc_TStrmToStrlist(w_DataStream,TStringList(mem_msg.lines),G_MSG_SYSTEM_A,G_MSGKIND_IRAI);
    end
    else if (Tbl_JUSINORDERTABLE.FieldByName('MESSAGETYPE').AsString = CST_APPTYPE_PI01) or
            (Tbl_JUSINORDERTABLE.FieldByName('MESSAGETYPE').AsString = CST_APPTYPE_PI99) then
    begin
      //表示
      proc_TStrmToStrlist(w_DataStream,TStringList(mem_msg.lines),G_MSG_SYSTEM_A,G_MSGKIND_KANJA);
    end
    else if (Tbl_JUSINORDERTABLE.FieldByName('MESSAGETYPE').AsString = CST_APPTYPE_OI99) then
    begin
      //表示
      proc_TStrmToStrlist(w_DataStream,TStringList(mem_msg.lines),G_MSG_SYSTEM_A,G_MSGKIND_CANCEL);
    end;
  end
  //それ以外の場合
  else begin
    //クリア
    mem_msg.Lines.clear;
    mem_msg.Text := '電文表示';
  end;
end;

procedure TForm1.StaticText4Click(Sender: TObject);
begin
  Tbl_ORDERBUITABLE.Close;
  Tbl_ORDERBUITABLE.Open;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if w_Ini_Flg then
    RisHisSvrSvc_Irai.proc_Start
  else begin
    lbl_res.Caption:= 'False';
    lbl_err.Caption := 'INIファイルが読み込まれていません。';
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  w_Ini_Flg := False;
  //電文長のチェック
  if func_TcpReadiniFile then begin
    w_Ini_Flg := True;
    //ログ文字列作成
    lbl_res.Caption:= 'True';
    lbl_err.Caption := 'INIファイル読み込み成功';
    Edit2.Text := Trim(g_S_Socket_Info_01.f_Port);
  end
  else begin
    lbl_res.Caption:= 'False';
    lbl_err.Caption := 'INIファイル読み込み失敗';
    Edit2.Text := '';
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  RisHisSvrSvc_Irai.proc_End;
  w_Ini_Flg := False;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
var
  w_s:string;
begin
  //テーブルが接続されていて、レコードがある場合
  if Tbl_ORDERINDICATETABLE.Active and (Tbl_ORDERINDICATETABLE.RecordCount > 0) then begin
    //検査目的を取得
    w_s := Tbl_ORDERINDICATETABLE.FieldByName('KENSA_SIJI').AsString;
    //クリア
    Memo1.Clear;
    //表示
    Memo1.Text := w_s;
  end
  //それ以外の場合
  else begin
    //クリア
    Memo1.Clear;
  end;
end;

procedure TForm1.BitBtn8Click(Sender: TObject);
var
  w_s:string;
begin
  //テーブルが接続されていて、レコードがある場合
  if Tbl_ORDERINDICATETABLE.Active and (Tbl_ORDERINDICATETABLE.RecordCount > 0) then begin
    //臨床診断を取得
    w_s := Tbl_ORDERINDICATETABLE.FieldByName('RINSYOU').AsString;
    //クリア
    Memo1.Clear;
    //表示
    Memo1.Text := w_s;
  end
  //それ以外の場合
  else begin
    //クリア
    Memo1.Clear;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   Tbl_EXTENDORDERINFO.Close;
   Tbl_EXTENDORDERINFO.Open;
end;

procedure TForm1.StaticText6Click(Sender: TObject);
begin
  Tbl_ORDERINDICATETABLE.Close;
  Tbl_ORDERINDICATETABLE.Open;
end;

procedure TForm1.StaticText8Click(Sender: TObject);
begin
  Tbl_JUSINORDERTABLE.Close;
  Tbl_JUSINORDERTABLE.Open;
end;

procedure TForm1.CB_TableChange(Sender: TObject);
begin
  CB_Table_Name.ItemIndex := CB_Table.ItemIndex;
  CB_DBGrid_Name.ItemIndex := CB_Table.ItemIndex;
  proc_Get_ColumnsName;
  ED_Date.Text := '';
  CB_Jyouken.ItemIndex := -1;
  Memo2.Text := '';
end;

procedure TForm1.proc_Get_ColumnsName;
var
  w_Control : TControl;
  w_iCount  : Integer;
  w_i       : Integer;
begin
  if CB_Table_Name.Text <> '' then begin
    w_Control := wg_DBGrid[CB_Table_Name.ItemIndex];
    if w_Control <> nil then begin
      w_iCount := TDBGrid(w_Control).Columns.Count;
      CB_Columns.Items.Clear;
      CB_Columns_Name.Items.Clear;
      for w_i := 0 to w_iCount - 1 do begin
        CB_Columns.Items.Add(TDBGrid(w_Control).Columns.Items[w_i].Title.Caption);
        CB_Columns_Name.Items.Add(TDBGrid(w_Control).Columns.Items[w_i].FieldName);
      end;
    end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if (CB_Columns.Text <> '') and
     (CB_Jyouken2.Text <> '') and
     (ED_Date.Text <> '')    then begin
    if Memo2.Lines.Count <> 0 then begin
      if CB_Jyouken.Text <> '' then begin
        if CB_Jyouken.ItemIndex <= 2 then
          Memo2.Lines.Add(CB_Jyouken.Text + ' ' + CB_Columns_Name.Text + CB_Jyouken2.Text + '''' + ED_Date.Text + '''');
      end;
    end
    else
      Memo2.Lines.Add(CB_Columns_Name.Text + CB_Jyouken2.Text + '''' + ED_Date.Text + '''');
  end;
end;

procedure TForm1.CB_ColumnsChange(Sender: TObject);
begin
  CB_Columns_Name.ItemIndex := CB_Columns.ItemIndex;
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  w_Table  : TTable;
begin
  if (Memo2.Text <> '') and
     (CB_Table.Text <> '') then begin
    w_Table := wg_Table[CB_Table_Name.ItemIndex];
    w_Table.Close;
    w_Table.Filtered := False;
    w_Table.Filter := Memo2.Text;
    w_Table.Filtered := True;
    w_Table.Open;
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  w_Table  : TTable;
begin
  if (Memo2.Text <> '') and
     (CB_Table.Text <> '') then begin
    w_Table := wg_Table[CB_Table_Name.ItemIndex];
    w_Table.Close;
    w_Table.Filter := '';
    w_Table.Filtered := False;
    w_Table.Open;
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  w_s:String;
begin
  if PageControl1.ActivePageIndex = 2 then begin
    //テーブルが接続されていて、レコードがある場合
    if Tbl_ORDERINDICATETABLE.Active and (Tbl_ORDERINDICATETABLE.RecordCount > 0) then begin
      //クリア
      mem_msg.Clear;
      //オーダコメントタイトル
      w_s := 'オーダコメント';
      //表示
      mem_msg.Lines.Add(w_s);
      //ORDERCOMMENT_IDを取得
      w_s := Tbl_ORDERINDICATETABLE.FieldByName('ORDERCOMMENT_ID').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
      //検査目的タイトル
      w_s := '検査目的';
      //表示
      mem_msg.Lines.Add(w_s);
      //KENSA_SIJIを取得
      w_s := Tbl_ORDERINDICATETABLE.FieldByName('KENSA_SIJI').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
      //臨床診断タイトル
      w_s := '臨床診断';
      //表示
      mem_msg.Lines.Add(w_s);
      //RINSYOUを取得
      w_s := Tbl_ORDERINDICATETABLE.FieldByName('RINSYOU').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
      //備考タイトル
      w_s := '備考';
      //表示
      mem_msg.Lines.Add(w_s);
      //REMARKSを取得
      w_s := Tbl_ORDERINDICATETABLE.FieldByName('REMARKS').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
    end
    //それ以外の場合
    else begin
      //クリア
      mem_msg.Clear;
    end;
  end
  else if PageControl1.ActivePageIndex = 3 then begin
    //テーブルが接続されていて、レコードがある場合
    if Tbl_KANJAMASTER.Active and (Tbl_KANJAMASTER.RecordCount > 0) then begin
      //クリア
      mem_msg.Clear;
      //住所1タイトル
      w_s := '住所1';
      //表示
      mem_msg.Lines.Add(w_s);
      //JUSYO1を取得
      w_s := Tbl_KANJAMASTER.FieldByName('JUSYO1').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
      //住所2タイトル
      w_s := '住所2';
      //表示
      mem_msg.Lines.Add(w_s);
      //JUSYO2を取得
      w_s := Tbl_KANJAMASTER.FieldByName('JUSYO2').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
      //住所3タイトル
      w_s := '住所3';
      //表示
      mem_msg.Lines.Add(w_s);
      //JUSYO3を取得
      w_s := Tbl_KANJAMASTER.FieldByName('JUSYO3').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
      //障害情報タイトル
      w_s := '障害情報';
      //表示
      mem_msg.Lines.Add(w_s);
      //HANDICAPPEDを取得
      w_s := Tbl_KANJAMASTER.FieldByName('HANDICAPPED').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
      //感染情報タイトル
      w_s := '感染情報';
      //表示
      mem_msg.Lines.Add(w_s);
      //INFECTIONを取得
      w_s := Tbl_KANJAMASTER.FieldByName('INFECTION').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
      //禁忌情報タイトル
      w_s := '禁忌情報';
      //表示
      mem_msg.Lines.Add(w_s);
      //CONTRAINDICATIONを取得
      w_s := Tbl_KANJAMASTER.FieldByName('CONTRAINDICATION').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
      //アレルギー情報タイトル
      w_s := 'アレルギー情報';
      //表示
      mem_msg.Lines.Add(w_s);
      //ALLERGYを取得
      w_s := Tbl_KANJAMASTER.FieldByName('ALLERGY').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
      //妊娠情報タイトル
      w_s := '妊娠情報';
      //表示
      mem_msg.Lines.Add(w_s);
      //PREGNANCYを取得
      w_s := Tbl_KANJAMASTER.FieldByName('PREGNANCY').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
      //その他注意事項タイトル
      w_s := 'その他注意事項';
      //表示
      mem_msg.Lines.Add(w_s);
      //NOTESを取得
      w_s := Tbl_KANJAMASTER.FieldByName('NOTES').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
      //検査データ情報タイトル
      w_s := '検査データ情報';
      //表示
      mem_msg.Lines.Add(w_s);
      //EXAMDATAを取得
      w_s := Tbl_KANJAMASTER.FieldByName('EXAMDATA').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
      //その他属性タイトル
      w_s := 'その他属性情報';
      //表示
      mem_msg.Lines.Add(w_s);
      //EXTRAPROFILEを取得
      w_s := Tbl_KANJAMASTER.FieldByName('EXTRAPROFILE').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
    end
    //それ以外の場合
    else begin
      //クリア
      mem_msg.Clear;
    end;
  end
  else if PageControl1.ActivePageIndex = 7 then begin
    //テーブルが接続されていて、レコードがある場合
    if Tbl_ORDERSHEMAINFO.Active and (Tbl_ORDERSHEMAINFO.RecordCount > 0) then begin
      //クリア
      mem_msg.Clear;
      //シェーマパスタイトル
      w_s := 'シェーマパス';
      //表示
      mem_msg.Lines.Add(w_s);
      //SHEMAPASSを取得
      w_s := Tbl_ORDERSHEMAINFO.FieldByName('SHEMAPASS').AsString;
      //表示
      mem_msg.Lines.Add(w_s);
    end
    //それ以外の場合
    else begin
      //クリア
      mem_msg.Clear;
    end;
  end;
end;

procedure TForm1.Button9Click(Sender: TObject);
var
  w_sErr: String;
begin
  g_S_Socket_Info_01.f_Port := func_GetServiceInfo(CST_APPID_HRCV01,
                                                   Db_RisSvr_Irai.TQ_Etc,
                                                   Db_RisSvr_Irai.wg_DBFlg,
                                                   w_sErr);
  //電文長のチェック
  if g_S_Socket_Info_01.f_Port = '' then begin
    lbl_res.Caption:= 'False';
    lbl_err.Caption := 'ポート情報読み込み失敗「' + w_sErr + '」';
    Edit2.Text := '';
  end
  else begin
    //ログ文字列作成
    lbl_res.Caption:= 'True';
    lbl_err.Caption := 'ポート情報読み込み成功';
    Edit2.Text := Trim(g_S_Socket_Info_01.f_Port);
  end;
end;

procedure TForm1.StaticText15Click(Sender: TObject);
begin
  Tbl_ORDERSHEMAINFO.Close;
  Tbl_ORDERSHEMAINFO.Open;
end;

procedure TForm1.StaticText16Click(Sender: TObject);
begin
  Tbl_EXMAINTABLE.Close;
  Tbl_EXMAINTABLE.Open;
end;

procedure TForm1.StaticText17Click(Sender: TObject);
begin
  Tbl_EXAMINFO.Close;
  Tbl_EXAMINFO.Open;
end;

procedure TForm1.StaticText18Click(Sender: TObject);
begin
  Tbl_REPORTINFO.Close;
  Tbl_REPORTINFO.Open;
end;

procedure TForm1.StaticText19Click(Sender: TObject);
begin
  Tbl_RepPATIENTINFO.Close;
  Tbl_RepPATIENTINFO.Open;
end;

procedure TForm1.StaticText20Click(Sender: TObject);
begin
  Tbl_RTORDERMAINTABLE.Close;
  Tbl_RTORDERMAINTABLE.Open;
end;

procedure TForm1.StaticText21Click(Sender: TObject);
begin
  Tbl_ORDERMAIN_EXTEND_TABLE.Close;
  Tbl_ORDERMAIN_EXTEND_TABLE.Open;
end;

procedure TForm1.StaticText22Click(Sender: TObject);
begin
  Tbl_ORDERMAIN_SN_TABLE.Close;
  Tbl_ORDERMAIN_SN_TABLE.Open;
end;

procedure TForm1.StaticText23Click(Sender: TObject);
begin
  Tbl_RTEXMAINTABLE.Close;
  Tbl_RTEXMAINTABLE.Open;
end;

procedure TForm1.StaticText24Click(Sender: TObject);
begin
  Tbl_EXMAIN_EXTEND_TABLE.Close;
  Tbl_EXMAIN_EXTEND_TABLE.Open;
end;

procedure TForm1.StaticText25Click(Sender: TObject);
begin
  Tbl_RTPATIENTINFO.Close;
  Tbl_RTPATIENTINFO.Open;
end;

end.
