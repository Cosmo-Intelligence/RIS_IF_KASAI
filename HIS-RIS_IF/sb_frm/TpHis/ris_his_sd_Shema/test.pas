unit test;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, Db,
//プロダクト開発共通－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
  Gval,
  HisMsgDef,
  TcpSocket,
  pdct_shema,
  risftp,
  UDb_RisFTP, ComCtrls, DBTables, Buttons, ExtCtrls
  ;

type
  TForm1 = class(TForm)
    lbl_err: TLabel;
    lbl_res: TLabel;
    DataSource1: TDataSource;
    Button11: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    DBGrid1: TDBGrid;
    TabSheet2: TTabSheet;
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
    BitBtn9: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    Table6: TTable;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Bevel8: TBevel;
    Bevel9: TBevel;
    Bevel10: TBevel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Table7: TTable;
    DataSource8: TDataSource;
    DBGrid8: TDBGrid;
    Button1: TButton;
    Memo1: TMemo;
    Table1: TTable;
    DataSource2: TDataSource;
    BitBtn2: TBitBtn;
    Label2: TLabel;
    Bevel1: TBevel;
    procedure Button11Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private 宣言 }
    w_Err:string;
    w_res:boolean;
    w_SendMsgStream : TStringStream;
    w_SendMsgTSList : Tstringlist;
    w_RecvMsgTSList : Tstringlist;
    w_RecvMsgStream : TStringStream;
    w_DataStream    : TStringStream;
    wg_OrderNo:String;
    wg_Schema_Main:String;
    wg_Schema_Sub:String;
    wg_KanjyaID:String;
    wg_OrderDate:String;
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
  Table6.Refresh;
  Table7.Refresh;
  Table1.Refresh;
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

end;

procedure TForm1.Button19Click(Sender: TObject);
begin
  with Table7 do begin
    Close;
    Filtered := True;
    Filter := 'RIS_ID = ' + '''' + Db_RisFTP.TQ_Order.FieldByName('RIS_ID').AsString + '''';
    Open;
  end;
end;

procedure TForm1.Button20Click(Sender: TObject);
begin
  //実績メインﾃｰﾌﾞﾙ再表示
  Button19.OnClick(self);
  //転送オーダﾃｰﾌﾞﾙ(送信済)再表示
  Button21.OnClick(self);
end;

procedure TForm1.Button21Click(Sender: TObject);
begin
  with Table6 do begin
    Close;
    Filtered := True;
    Filter := 'SHEMAGETSTATUS IS NOT NULL AND (SHEMAGETSTATUS = ' + '''' + '10' + ''' OR SHEMAGETSTATUS = ' + '''' + '09' + ''')';
    IndexFieldNames := 'REQUESTID;REQUESTDATE';
    Open;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';
  //DBの接続
  w_res := Db_RisFTP.RisDBOpen(Db_RisFTP.wg_DBFlg,w_Err,nil);
  //エラー表示
  lbl_err.Caption := w_Err;
  //正常
  if w_res then begin
    Table6.DatabaseName := DB_RisFTP.DatabaseRis.DatabaseName;
    Table7.DatabaseName := DB_RisFTP.DatabaseRis.DatabaseName;
    Table1.DatabaseName := DB_RisFTP.DatabaseRis.DatabaseName;
    Table6.Open;
    Table7.Open;
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
  w_res := Db_RisFTP.func_GetOrder(w_Err);
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
  //メインﾃｰﾌﾞﾙ再表示
  Button19.OnClick(self);
  //転送オーダﾃｰﾌﾞﾙ(送信済)再表示
  Button21.OnClick(self);
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
var
  w_NullFlg:String;
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';

  w_NullFlg := '';
  wg_OrderNo := '';
  wg_Schema_Main := '';
  wg_Schema_Sub := '';

  w_res := DB_RisFTP.func_SelectOrder(DB_RisFTP.TQ_Order.FieldByName('RIS_ID').AsString,
                                       wg_OrderNo,wg_Schema_Main,wg_Schema_Sub,wg_KanjyaID,wg_OrderDate,w_Err,w_NullFlg);

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
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';

  w_res := DB_RisFTP.func_Del_Schema(wg_Schema_Main + wg_Schema_Sub,wg_OrderNo,w_Err);

  //エラー表示
  lbl_err.Caption := w_Err;
  //正常
  if w_res then begin
    //復帰値表示
    lbl_res.Caption:= '復帰値：True';
    //正常表示
    BitBtn5.Font.Color := clWindowText;
  end
  //異常
  else begin
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
   w_res := DB_RisFTP.func_GET_FTP(DB_RisFTP.TQ_Order.FieldByName('RIS_ID').AsString,w_Flg,w_Err);

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
  Edit2.Text := w_Flg;
end;

procedure TForm1.BitBtn7Click(Sender: TObject);
begin
  w_Err := '';
   //エラー表示
   lbl_err.Caption := '';
{   lbl_res.Caption := '復帰値：' + DB_RisSD.func_GetOrderKind;

  //正常
  if DB_RisSD.func_GetOrderKind <> '' then begin
    //正常表示
    BitBtn7.Font.Color := clWindowText;
  end
  //異常
  else begin
    //エラー表示
    BitBtn7.Font.Color := clRed;
  end; }
end;

procedure TForm1.BitBtn9Click(Sender: TObject);
begin
  w_Err := '';
  //エラー表示

  lbl_err.Caption := '';
  try
    Db_RisFTP.RisDBClose;
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
  lbl_res.Caption := DB_RisFTP.func_GetSysDate;
  Edit1.Text      := lbl_res.Caption;
  lbl_err.Caption := w_Err;
  //正常
  if w_Err = '' then begin
    //正常表示
    BitBtn10.Font.Color := clWindowText;
  end
  //異常
  else begin
    //エラー表示
    BitBtn10.Font.Color := clRed;
  end;
end;

procedure TForm1.BitBtn11Click(Sender: TObject);
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';
  DB_RisFTP.DatabaseRis.StartTransaction;
   w_res := DB_RisFTP.func_SetOrderResult(Edit2.Text,w_Err);

  //エラー表示
  lbl_err.Caption := w_Err;
  //正常
  if w_res then begin
    DB_RisFTP.DatabaseRis.Commit;
    //復帰値表示
    lbl_res.Caption:= '復帰値：True';
    //正常表示
    BitBtn11.Font.Color := clWindowText;
  end
  //異常
  else begin
    DB_RisFTP.DatabaseRis.Rollback;
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
    w_s := Table6.FieldByName('Denbun').AsString;
    //初期化
    w_DataStream.Position := 0;
    //文字列化
    w_DataStream.WriteString(w_s);
    //クリア
    Memo1.Lines.clear;
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

procedure TForm1.Button2Click(Sender: TObject);
begin
  with Table1 do begin

    Close;
    Filtered := True;
    Filter := 'RIS_ID = ' + '''' + DBGrid7.Columns.Items[3].Field.AsString + '''';
    Open;
  end;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  wi_Count:Integer;
  ws_ECode:String;
begin
  w_Err := '';
  //エラー表示
  lbl_err.Caption := '';
  DB_RisFTP.DatabaseRis.StartTransaction;
  //オーダシェーマ情報更新
  w_res := func_FTP_Update(DB_RisFTP.DatabaseRis,DB_RisFTP.TQ_Etc,DB_RisFTP.TQ_Order.FieldByName('RIS_ID').AsString,g_Schema_Main,g_Schema_Sub,wi_Count,ws_ECode,w_Err);
  //エラー表示
  lbl_err.Caption := w_Err;
  //正常
  if w_res then begin
    DB_RisFTP.DatabaseRis.Commit;
    //復帰値表示
    lbl_res.Caption:= '復帰値：True';
    //正常表示
    BitBtn2.Font.Color := clWindowText;
  end
  //異常
  else begin
    DB_RisFTP.DatabaseRis.Rollback;
    //復帰値表示
    lbl_res.Caption:= '復帰値：False';
    //エラー表示
    BitBtn2.Font.Color := clRed;
  end;
end;

end.
