unit test;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, Db,
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Gval,
  HisMsgDef,
  HisMsgDef06_RCE,
  TcpSocket,
  FTcpEmuC,
  UDb_RisSD, ComCtrls, DBTables, Buttons, ExtCtrls
  ;

type
  TForm1 = class(TForm)
    lbl_err: TLabel;
    lbl_res: TLabel;
    DataSource1: TDataSource;
    DataSource2: TDataSource;
    Button11: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Button14: TButton;
    Label1: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    DBGrid1: TDBGrid;
    TabSheet2: TTabSheet;
    DBGrid2: TDBGrid;
    DataSource6: TDataSource;
    Button19: TButton;
    Button20: TButton;
    TabSheet7: TTabSheet;
    DBGrid7: TDBGrid;
    Button21: TButton;
    DataSource7: TDataSource;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    Table4: TTable;
    Table5: TTable;
    Table6: TTable;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel7: TBevel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    Bevel10: TBevel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Table7: TTable;
    DataSource8: TDataSource;
    Label15: TLabel;
    DBGrid8: TDBGrid;
    Label14: TLabel;
    Button1: TButton;
    Memo1: TMemo;
    RichEdit1: TRichEdit;
    BitBtn2: TBitBtn;
    Label2: TLabel;
    Bevel1: TBevel;
    Edit3: TEdit;
    Label4: TLabel;
    Button2: TButton;
    Edit4: TEdit;
    Edit5: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    TabSheet3: TTabSheet;
    DBGrid3: TDBGrid;
    Button3: TButton;
    BitBtn7: TBitBtn;
    Label5: TLabel;
    Bevel6: TBevel;
    BitBtn12: TBitBtn;
    Label9: TLabel;
    Bevel11: TBevel;
    TabSheet4: TTabSheet;
    Button4: TButton;
    DBGrid4: TDBGrid;
    DataSource3: TDataSource;
    Table1: TTable;
    TabSheet5: TTabSheet;
    Label18: TLabel;
    Label19: TLabel;
    DBGrid5: TDBGrid;
    Button5: TButton;
    DBGrid6: TDBGrid;
    DataSource4: TDataSource;
    DataSource5: TDataSource;
    Table2: TTable;
    Table3: TTable;
    TabSheet6: TTabSheet;
    DBGrid9: TDBGrid;
    Button6: TButton;
    DataSource9: TDataSource;
    Table8: TTable;
    TabSheet8: TTabSheet;
    DBGrid10: TDBGrid;
    Button7: TButton;
    DataSource10: TDataSource;
    Table9: TTable;
    TabSheet9: TTabSheet;
    DBGrid11: TDBGrid;
    Button8: TButton;
    DataSource11: TDataSource;
    Table10: TTable;
    TabSheet10: TTabSheet;
    DBGrid12: TDBGrid;
    Button9: TButton;
    DataSource12: TDataSource;
    Table11: TTable;
    procedure Button11Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
  private
    { Private 宣言 }
    w_Err:string;
    w_res:boolean;
    w_SendMsgStream : TStringStream;
    w_SendMsgTSList : Tstringlist;
    w_RecvMsgTSList : Tstringlist;
    w_RecvMsgStream : TStringStream;
    w_DataStream    : TStringStream;
    w_f4:TFrm_TcpEmuC;
    wgs_IPPort: String;
  public
    { Public 宣言 }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.Button11Click(Sender: TObject);
begin
  DBGrid1.Refresh;
  Table1.Refresh;
  Table2.Refresh;
  Table3.Refresh;
  Table4.Refresh;
  Table5.Refresh;
  Table6.Refresh;
  Table7.Refresh;
  Table8.Refresh;
  Table9.Refresh;
  Table10.Refresh;
  Table11.Refresh;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  func_TcpReadiniFile;
  //電文格納域確保
  w_SendMsgTSList := Tstringlist.Create;
  w_RecvMsgTSList := Tstringlist.Create;
  w_DataStream    := TStringStream.Create('');
  w_SendMsgStream := TStringStream.Create('');
  w_RecvMsgStream := TStringStream.Create('');
  //送信オーダテーブル(未送信)初期表示
  PageControl1.ActivePageIndex := 0;
  proc_FrmCenter(self);
end;

procedure TForm1.Button14Click(Sender: TObject);
var
  w_i:Integer;
begin
  w_f4 := func_TcpEmuCOpen(self,
               g_C_Socket_Info_02.f_Socket_Info.f_EmuVisible,
               g_C_Socket_Info_02.f_Socket_Info.f_EmuEnabled,
               g_C_Socket_Info_02.f_Socket_Info.f_CharCode,
               g_C_Socket_Info_02.f_IPAdrr,
               g_C_Socket_Info_02.f_Port,
               IntToStr(g_C_Socket_Info_02.f_TimeOut),
               G_MSGKIND_JISSI,
               G_MSGKIND_START
               );
  w_f4.Show;
  w_f4.REdt_SndCmdData.Lines.Clear;
  //電文送信用表示
  for w_i := 0 to RichEdit1.Lines.Count - 1 do begin
    w_f4.REdt_SndCmdData.Lines.Add(RichEdit1.Lines[w_i]);
  end;
end;

procedure TForm1.Button18Click(Sender: TObject);
begin
  with Table4 do begin
    Close;
    Filtered := True;
    Filter := 'RIS_ID = ' + '''' + DB_RisSD.TQ_Order.FieldByName('RIS_ID').AsString + '''';
    IndexFieldNames := 'NO';
    Open;
  end;
end;

procedure TForm1.Button19Click(Sender: TObject);
begin
  with Table5 do begin
    Close;
    Filtered := True;
    Filter := 'RIS_ID = ' + '''' + DB_RisSD.TQ_Order.FieldByName('RIS_ID').AsString + '''';
    Open;
  end;
  with Table7 do begin
    Close;
    Filtered := True;
    Filter := 'RIS_ID = ' + '''' + DB_RisSD.TQ_Order.FieldByName('RIS_ID').AsString + '''';
    Open;
  end;
end;

procedure TForm1.Button20Click(Sender: TObject);
begin
  //実績メインﾃｰﾌﾞﾙ再表示
  Button19.OnClick(self);
  //転送オーダﾃｰﾌﾞﾙ(送信済)再表示
  Button21.OnClick(self);
  //実績操作履歴再表示
  Button3.OnClick(self);
  Button4.OnClick(self);
  Button5.OnClick(self);
  Button6.OnClick(self);
  Button7.OnClick(self);
  Button8.OnClick(self);
  Button9.OnClick(self);
end;

procedure TForm1.Button21Click(Sender: TObject);
begin
  with Table6 do begin
    Close;
    Filtered := True;
    Filter := 'TRANSFERSTATUS = ' + '''' + '01' + '''';
    IndexFieldNames := 'REQUESTDATE;REQUESTID';
    Open;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';
  //DBの接続
  w_res := DB_RisSD.RisDBOpen(DB_RisSD.wg_DBFlg, w_Err,nil);
  //エラー表示
  lbl_err.Caption := w_Err;
  //正常
  if w_res then begin
    DataSource1.DataSet := DB_RisSD.TQ_Order;
    Table4.DatabaseName := DB_RisSD.DatabaseRis.DatabaseName;
    Table5.DatabaseName := DB_RisSD.DatabaseRis.DatabaseName;
    Table6.DatabaseName := DB_RisSD.DatabaseRis.DatabaseName;
    Table7.DatabaseName := DB_RisSD.DatabaseRis.DatabaseName;
    Table1.DatabaseName := DB_RisSD.DatabaseRis.DatabaseName;
    Table2.DatabaseName := DB_RisSD.DatabaseRis.DatabaseName;
    Table3.DatabaseName := DB_RisSD.DatabaseRis.DatabaseName;
    Table8.DatabaseName := DB_RisSD.DatabaseRis.DatabaseName;
    Table9.DatabaseName := DB_RisSD.DatabaseRis.DatabaseName;
    Table10.DatabaseName := DB_RisSD.DatabaseRis.DatabaseName;
    Table11.DatabaseName := DB_RisSD.DatabaseRis.DatabaseName;

    Table1.Open;
    Table2.Open;
    Table3.Open;
    Table4.Open;
    Table5.Open;
    Table6.Open;
    Table7.Open;
    Table8.Open;
    Table9.Open;
    Table10.Open;
    Table11.Open;
    //復帰値表示
    lbl_res.Caption:= '復帰値：True';
    //正常表示
    BitBtn1.Font.Color := clBlue;
    BitBtn9.Font.Color := clWindowText;
  end
  //異常
  else begin
    //復帰値表示
    lbl_res.Caption:= '復帰値：False';
    //エラー表示
    BitBtn1.Font.Color := clRed;
    BitBtn9.Font.Color := clWindowText;
  end;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';
  w_res := DB_RisSD.func_GetOrder(w_Err);
  //エラー表示
  lbl_err.Caption := w_Err;
  //正常
  if w_res then begin
    //復帰値表示
    lbl_res.Caption:= '復帰値：True';
    //正常表示
    BitBtn3.Font.Color := clWindowText;
  end
  //異常
  else begin
    //復帰値表示
    lbl_res.Caption:= '復帰値：False';
    //エラー表示
    BitBtn3.Font.Color := clRed;
  end;
  Edit3.Text := IntToStr(DB_RisSD.TQ_Order.RecordCount);
  //実績メインﾃｰﾌﾞﾙ再表示
  Button19.OnClick(self);
  //転送オーダﾃｰﾌﾞﾙ(送信済)再表示
  Button21.OnClick(self);
  //実績操作履歴再表示
  Button3.OnClick(self);
  Button4.OnClick(self);
  Button5.OnClick(self);
  Button6.OnClick(self);
  Button7.OnClick(self);
  Button8.OnClick(self);
  Button9.OnClick(self);
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
var
//  w_i:integer;
  w_NullFlg:String;
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';
   RichEdit1.Clear;
   DB_RisSD.wg_Seq := func_GetSeq(CST_APPID_HSND02,
                                          DB_RisSD.TQ_Etc,
                                          DB_RisSD.wg_DBFlg, w_Err);

   w_NullFlg := '';

   w_res := DB_RisSD.func_MakeMsg(w_SendMsgStream,w_Err,w_NullFlg);

   DB_RisSD.wg_DataCount := DB_RisSD.wg_DataCount + 1;

   if w_NullFlg <> '' then
    //エラー表示
    lbl_err.Caption := w_Err + 'データがありません。'
   else
    //エラー表示
    lbl_err.Caption := w_Err;

  //正常
  if w_res then begin
    //復帰値表示
    lbl_res.Caption:= '復帰値：True';
    //正常表示
    BitBtn4.Font.Color := clWindowText;
    //電文表示
    if (DB_RisSD.TQ_Order.FieldByName('REQUESTTYPE').AsString = CST_APPTYPE_OP01) or
       (DB_RisSD.TQ_Order.FieldByName('REQUESTTYPE').AsString = CST_APPTYPE_OP99) then
    begin
      //表示
      RichEdit1.Lines.BeginUpdate;
      //電文の空チェック
      if func_IsNullStr(w_SendMsgStream.DataString) then begin
        //空表示
        RichEdit1.Lines.Add('*空*');
      end
      else begin
        //TStringStreamより解析してTStringListを作成
        proc_TStrmToStrlist(w_SendMsgStream,TStringList(RichEdit1.lines),G_MSG_SYSTEM_A,G_MSGKIND_JISSI);
      end;
      //変更終了
      RichEdit1.Lines.EndUpdate;
      //再表示
      RichEdit1.Refresh;
    end;
  end
  //異常
  else begin
    //復帰値表示
    lbl_res.Caption:= '復帰値：False';
    //エラー表示
    BitBtn4.Font.Color := clRed;
  end;
  //実績メインﾃｰﾌﾞﾙ再表示
  Button19.OnClick(self);
  //転送オーダﾃｰﾌﾞﾙ(送信済)再表示
  Button21.OnClick(self);
  //実績操作履歴再表示
  Button3.OnClick(self);
  Button4.OnClick(self);
  Button5.OnClick(self);
  Button6.OnClick(self);
  Button7.OnClick(self);
  Button8.OnClick(self);
  Button9.OnClick(self);
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';
  DB_RisSD.DatabaseRis.StartTransaction;

  if g_Rig_LogIncMsg=g_SOCKET_LOGINCMSG then
    w_res := DB_RisSD.func_SaveMsg(w_SendMsgStream,w_Err);

  //エラー表示
  lbl_err.Caption := w_Err;
  //正常
  if w_res then begin
    DB_RisSD.DatabaseRis.Commit;
    //復帰値表示
    lbl_res.Caption:= '復帰値：True';
    //正常表示
    BitBtn5.Font.Color := clWindowText;
  end
  //異常
  else begin
    DB_RisSD.DatabaseRis.Rollback;
    //復帰値表示
    lbl_res.Caption:= '復帰値：False';
    //エラー表示
    BitBtn5.Font.Color := clRed;
  end;
end;

procedure TForm1.BitBtn6Click(Sender: TObject);
var
  w_Flg:String;
  w_NullFlg:String;
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';
   w_NullFlg := '';
   w_res := DB_RisSD.func_CheckOrder(w_Err,w_Flg,w_NullFlg);

  //エラー表示
  lbl_err.Caption := w_Err;
  //正常
  if w_res then begin
    //復帰値表示
    lbl_res.Caption:= '復帰値：True';
    //正常表示
    BitBtn6.Font.Color := clWindowText;
  end
  //異常
  else begin
    //復帰値表示
    lbl_res.Caption:= '復帰値：False';
    //エラー表示
    BitBtn6.Font.Color := clRed;
  end;
end;

procedure TForm1.BitBtn8Click(Sender: TObject);
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';
   lbl_res.Caption := DB_RisSD.func_GetSysDate;
   Edit1.Text      := DB_RisSD.func_GetSysDate;
   lbl_err.Caption := w_Err;
  //正常
  if w_Err = '' then begin
    //正常表示
    BitBtn8.Font.Color := clWindowText;
    //電文表示
    if (DB_RisSD.TQ_Order.FieldByName('REQUESTTYPE').AsString = CST_APPTYPE_OP01) or
       (DB_RisSD.TQ_Order.FieldByName('REQUESTTYPE').AsString = CST_APPTYPE_OP99) then
    begin
      //表示
      Memo1.Lines.BeginUpdate;
      Memo1.Text := w_f4.REdt_RcvMsgData.Text;
      //変更終了
      Memo1.Lines.EndUpdate;
      //再表示
      Memo1.Refresh;
    end;
  end
  //異常
  else begin
    //エラー表示
    BitBtn8.Font.Color := clRed;
  end;
end;

procedure TForm1.BitBtn9Click(Sender: TObject);
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';
  try
    DB_RisSD.RisDBClose;
    //正常表示
    BitBtn1.Font.Color := clWindowText;
    BitBtn9.Font.Color := clBlue;
  except
    on E:Exception do begin
      //エラー表示
      BitBtn1.Font.Color := clWindowText;
      BitBtn9.Font.Color := clRed;
      lbl_err.Caption := E.Message;
      Exit;
    end;
  end;
end;

procedure TForm1.BitBtn10Click(Sender: TObject);
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';
  //受信電文の内容IDの取得
  if Copy(Memo1.Lines[2],1,2) = CST_DETAILS_S_SS then
  begin
    Edit2.Text := CST_ORDER_RES_OK;
  end
  else if Copy(Memo1.Lines[2],1,2) = CST_DETAILS_S_EC then
  begin
    Edit2.Text := CST_ORDER_RES_NG1;
  end
  else
  begin
    Edit2.Text := CST_ORDER_RES_NG2;
  end;

  DB_RisSD.DatabaseRis.StartTransaction;
  w_res := DB_RisSD.func_SetOrderResult(
                                 w_SendMsgStream,
                                 Edit1.Text,
                                 Edit2.Text,
                                 w_Err);

  //エラー表示
  lbl_err.Caption := w_Err;
  //正常
  if w_res then begin
    DB_RisSD.DatabaseRis.Commit;
    //復帰値表示
    lbl_res.Caption:= '復帰値：True';
    //正常表示
    BitBtn10.Font.Color := clWindowText;
  end
  //異常
  else begin
    DB_RisSD.DatabaseRis.Rollback;
    //復帰値表示
    lbl_res.Caption:= '復帰値：False';
    //エラー表示
    BitBtn10.Font.Color := clRed;
  end;
end;

procedure TForm1.BitBtn11Click(Sender: TObject);
var
  ws_Date: String;
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';
  ws_Date := DB_RisSD.func_GetSysDate;
  DB_RisSD.DatabaseRis.StartTransaction;
   w_res := DB_RisSD.func_SetExMain(
                                 w_SendMsgStream,
                                 ws_Date,
                                 w_Err);

  //エラー表示
  lbl_err.Caption := w_Err;
  //正常
  if w_res then begin
    DB_RisSD.DatabaseRis.Commit;
    //復帰値表示
    lbl_res.Caption:= '復帰値：True';
    //正常表示
    BitBtn11.Font.Color := clWindowText;
  end
  //異常
  else begin
    DB_RisSD.DatabaseRis.Rollback;
    //復帰値表示
    lbl_res.Caption:= '復帰値：False';
    //エラー表示
    BitBtn11.Font.Color := clRed;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    //電文域の解放
    w_SendMsgTSList.Free;
    w_RecvMsgTSList.Free;
    w_SendMsgStream.Free;
    w_RecvMsgStream.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  w_s:string;
begin
  //テーブルが接続されていて、レコードがある場合
  if Table6.Active and (Table6.RecordCount > 0) then begin
    //電文を取得
    w_s := Table6.FieldByName('TRANSFERTEXT').AsString;
    //初期化
    w_DataStream.Position := 0;
    //文字列化
    w_DataStream.WriteString(w_s);
    //クリア
    Memo1.Lines.clear;
    //表示
    Memo1.Text := w_DataStream.DataString;
    //表示
    proc_TStrmToStrlist(w_DataStream,TStringList(Memo1.lines),G_MSG_SYSTEM_A,G_MSGKIND_JISSI);
  end
  //それ以外の場合
  else begin
    //クリア
    Memo1.Lines.clear;
    Memo1.Text := '電文表示';
  end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  w_Err: String;
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';
  //送信オーダテーブルから不要レコードを削除
  w_res := DB_RisSD.func_DelOrder(g_RisDB_SndKeep,w_Err);
  //エラー表示
  lbl_err.Caption := w_Err;
  //正常
  if w_res then begin
    //復帰値表示
    lbl_res.Caption:= '復帰値：True';
    //正常表示
    BitBtn2.Font.Color := clWindowText;
  end
  //異常
  else begin
    //復帰値表示
    lbl_res.Caption:= '復帰値：False';
    //エラー表示
    BitBtn2.Font.Color := clRed;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  wi_Pos: Integer;
  w_sErr: String;
begin
  //IPアドレス・ポートの取得
  wgs_IPPort := func_GetServiceInfo(CST_APPID_HSND02,
                                   DB_RisSD.TQ_Etc,
                                   DB_RisSD.wg_DBFlg,
                                   w_sErr);
  //";"（区切り文字）の検索
  wi_Pos := Pos(CST_IPPORT_SP, wgs_IPPort);
  g_C_Socket_Info_03.f_IPAdrr := Copy(wgs_IPPort, 1, wi_Pos - 1);
  g_C_Socket_Info_03.f_Port := Copy(wgs_IPPort, wi_Pos + 1, Length(wgs_IPPort));
  Edit4.Text := g_C_Socket_Info_03.f_IPAdrr;
  Edit5.Text := g_C_Socket_Info_03.f_Port;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  with Table6 do begin
    Close;
    Filtered := True;
    Filter := 'RIS_ID = ' + '''' + DB_RisSD.TQ_Order.FieldByName('RIS_ID').AsString + '''';
    Open;
  end;
end;

procedure TForm1.BitBtn7Click(Sender: TObject);
var
  w_Err: String;
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';
  //SEQインクリメント
  DB_RisSD.wg_Seq := FormatFloat('0000000000',StrToFloat(DB_RisSD.wg_Seq) + 1);
  w_res := func_SetHISRISControlInfo(CST_APPID_HSND02,DB_RisSD.wg_Seq,
                                   DB_RisSD.TQ_Etc,
                                   DB_RisSD.wg_DBFlg,
                                   w_Err);
  //エラー表示
  lbl_err.Caption := w_Err;
  //正常
  if w_res then begin
    //復帰値表示
    lbl_res.Caption:= '復帰値：True';
    //正常表示
    BitBtn2.Font.Color := clWindowText;
  end
  //異常
  else begin
    //復帰値表示
    lbl_res.Caption:= '復帰値：False';
    //エラー表示
    BitBtn2.Font.Color := clRed;
  end;
end;

procedure TForm1.BitBtn12Click(Sender: TObject);
var
  w_Err: String;
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';
  //送信済SEQ取得
  DB_RisSD.wg_Seq  := func_GetSeq(CST_APPID_HSND02,
                          DB_RisSD.TQ_Etc,
                          DB_RisSD.wg_DBFlg, w_Err);
  //エラー表示
  lbl_err.Caption := w_Err;
  //正常
  if w_res then begin
    //復帰値表示
    lbl_res.Caption:= '復帰値：True';
    //正常表示
    BitBtn12.Font.Color := clWindowText;
  end
  //異常
  else begin
    //復帰値表示
    lbl_res.Caption:= '復帰値：False';
    //エラー表示
    BitBtn12.Font.Color := clRed;
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  with Table1 do begin
    Close;
    Filtered := True;
    Filter := 'RIS_ID = ' + '''' + DB_RisSD.TQ_Order.FieldByName('RIS_ID').AsString + '''';
    Open;
  end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  with Table3 do begin
    Close;
    Filtered := True;
    Filter := 'RIS_ID = ' + '''' + DB_RisSD.TQ_Order.FieldByName('RIS_ID').AsString + '''';
    Open;
  end;
  with Table2 do begin
    Close;
    Filtered := True;
    Filter := 'RIS_ID = ' + '''' + DB_RisSD.TQ_Order.FieldByName('RIS_ID').AsString + '''';
    Open;
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  with Table8 do begin
    Close;
    Filtered := True;
    Filter := 'RIS_ID = ' + '''' + DB_RisSD.TQ_Order.FieldByName('RIS_ID').AsString + '''';
    Open;
  end;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  with Table9 do begin
    Close;
    Filtered := True;
    Filter := 'RIS_ID = ' + '''' + DB_RisSD.TQ_Order.FieldByName('RIS_ID').AsString + '''';
    Open;
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  with Table10 do begin
    Close;
    Filtered := True;
    Filter := 'RIS_ID = ' + '''' + DB_RisSD.TQ_Order.FieldByName('RIS_ID').AsString + '''';
    Open;
  end;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
  with Table11 do begin
    Close;
    Filtered := True;
    Filter := 'RIS_ID = ' + '''' + DB_RisSD.TQ_Order.FieldByName('RIS_ID').AsString + '''';
    Open;
  end;
end;

end.
