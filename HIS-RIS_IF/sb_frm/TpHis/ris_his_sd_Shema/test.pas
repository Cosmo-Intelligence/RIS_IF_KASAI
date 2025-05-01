unit test;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, Db,
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
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
    { Private �錾 }
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
    { Public �錾 }
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
   //�d���i�[��m��
    w_SendMsgTSList := Tstringlist.Create;
    w_RecvMsgTSList := Tstringlist.Create;
    w_DataStream    := TStringStream.Create('');
    w_SendMsgStream := TStringStream.Create('');
    w_RecvMsgStream := TStringStream.Create('');
    //���M�I�[�_�e�[�u��(�����M)�����\��
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
  //���у��C��ð��ٍĕ\��
  Button19.OnClick(self);
  //�]���I�[�_ð���(���M��)�ĕ\��
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
  //�G���[�\��
  lbl_err.Caption := '';
  //DB�̐ڑ�
  w_res := Db_RisFTP.RisDBOpen(Db_RisFTP.wg_DBFlg,w_Err,nil);
  //�G���[�\��
  lbl_err.Caption := w_Err;
  //����
  if w_res then begin
    Table6.DatabaseName := DB_RisFTP.DatabaseRis.DatabaseName;
    Table7.DatabaseName := DB_RisFTP.DatabaseRis.DatabaseName;
    Table1.DatabaseName := DB_RisFTP.DatabaseRis.DatabaseName;
    Table6.Open;
    Table7.Open;
    //���A�l�\��
    lbl_res.Caption:= '���A�l�FTrue';
    //����\��
    BitBtn1.Font.Color := clBlue;
    BitBtn9.Font.Color := clWindowText;
  end
  //�ُ�
  else begin
    //���A�l�\��
    lbl_res.Caption:= '���A�l�FFalse';
    //�G���[�\��
    BitBtn1.Font.Color := clRed;
    BitBtn9.Font.Color := clWindowText;
  end;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  w_Err := '';
  //�G���[�\��
  lbl_err.Caption := '';
  w_res := Db_RisFTP.func_GetOrder(w_Err);
  //�G���[�\��
  lbl_err.Caption := w_Err;
  //����
  if w_res then begin
    //���A�l�\��
    lbl_res.Caption:= '���A�l�FTrue';
    //����\��
    BitBtn3.Font.Color := clWindowText;
  end
  //�ُ�
  else begin
    //���A�l�\��
    lbl_res.Caption:= '���A�l�FFalse';
    //�G���[�\��
    BitBtn3.Font.Color := clRed;
  end;
  //���C��ð��ٍĕ\��
  Button19.OnClick(self);
  //�]���I�[�_ð���(���M��)�ĕ\��
  Button21.OnClick(self);
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
var
  w_NullFlg:String;
begin
  w_Err := '';
  //�G���[�\��
  lbl_err.Caption := '';

  w_NullFlg := '';
  wg_OrderNo := '';
  wg_Schema_Main := '';
  wg_Schema_Sub := '';

  w_res := DB_RisFTP.func_SelectOrder(DB_RisFTP.TQ_Order.FieldByName('RIS_ID').AsString,
                                       wg_OrderNo,wg_Schema_Main,wg_Schema_Sub,wg_KanjyaID,wg_OrderDate,w_Err,w_NullFlg);

  if w_NullFlg <> '' then
    //�G���[�\��
    lbl_err.Caption := w_Err + '�f�[�^������܂���B'
  else
    //�G���[�\��
    lbl_err.Caption := w_Err;
  //����
  if w_res then begin
    //���A�l�\��
    lbl_res.Caption:= '���A�l�FTrue';
    //����\��
    BitBtn4.Font.Color := clWindowText;
  end
  //�ُ�
  else begin
    //���A�l�\��
    lbl_res.Caption:= '���A�l�FFalse';
    //�G���[�\��
    BitBtn4.Font.Color := clRed;
  end;
  //���у��C��ð��ٍĕ\��
  Button19.OnClick(self);
  //�]���I�[�_ð���(���M��)�ĕ\��
  Button21.OnClick(self);
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
  w_Err := '';
  //�G���[�\��
  lbl_err.Caption := '';

  w_res := DB_RisFTP.func_Del_Schema(wg_Schema_Main + wg_Schema_Sub,wg_OrderNo,w_Err);

  //�G���[�\��
  lbl_err.Caption := w_Err;
  //����
  if w_res then begin
    //���A�l�\��
    lbl_res.Caption:= '���A�l�FTrue';
    //����\��
    BitBtn5.Font.Color := clWindowText;
  end
  //�ُ�
  else begin
    //���A�l�\��
    lbl_res.Caption:= '���A�l�FFalse';
    //�G���[�\��
    BitBtn5.Font.Color := clRed;
  end;
end;

procedure TForm1.BitBtn6Click(Sender: TObject);
var
  w_Flg:String;
  w_NullFlg:String;
begin
  w_Err := '';
  //�G���[�\��
  lbl_err.Caption := '';
   w_NullFlg := '';
   w_res := DB_RisFTP.func_GET_FTP(DB_RisFTP.TQ_Order.FieldByName('RIS_ID').AsString,w_Flg,w_Err);

  //�G���[�\��
  lbl_err.Caption := w_Err;
  //����
  if w_res then begin
    //���A�l�\��
    lbl_res.Caption:= '���A�l�FTrue';
    //����\��
    BitBtn6.Font.Color := clWindowText;
  end
  //�ُ�
  else begin
    //���A�l�\��
    lbl_res.Caption:= '���A�l�FFalse';
    //�G���[�\��
    BitBtn6.Font.Color := clRed;
  end;
  Edit2.Text := w_Flg;
end;

procedure TForm1.BitBtn7Click(Sender: TObject);
begin
  w_Err := '';
   //�G���[�\��
   lbl_err.Caption := '';
{   lbl_res.Caption := '���A�l�F' + DB_RisSD.func_GetOrderKind;

  //����
  if DB_RisSD.func_GetOrderKind <> '' then begin
    //����\��
    BitBtn7.Font.Color := clWindowText;
  end
  //�ُ�
  else begin
    //�G���[�\��
    BitBtn7.Font.Color := clRed;
  end; }
end;

procedure TForm1.BitBtn9Click(Sender: TObject);
begin
  w_Err := '';
  //�G���[�\��

  lbl_err.Caption := '';
  try
    Db_RisFTP.RisDBClose;
    //����\��
    BitBtn1.Font.Color := clWindowText;
    BitBtn9.Font.Color := clBlue;
  except
    on E:Exception do begin
      //�G���[�\��
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
  //�G���[�\��
  lbl_err.Caption := '';
  lbl_res.Caption := DB_RisFTP.func_GetSysDate;
  Edit1.Text      := lbl_res.Caption;
  lbl_err.Caption := w_Err;
  //����
  if w_Err = '' then begin
    //����\��
    BitBtn10.Font.Color := clWindowText;
  end
  //�ُ�
  else begin
    //�G���[�\��
    BitBtn10.Font.Color := clRed;
  end;
end;

procedure TForm1.BitBtn11Click(Sender: TObject);
begin
  w_Err := '';
  //�G���[�\��
  lbl_err.Caption := '';
  DB_RisFTP.DatabaseRis.StartTransaction;
   w_res := DB_RisFTP.func_SetOrderResult(Edit2.Text,w_Err);

  //�G���[�\��
  lbl_err.Caption := w_Err;
  //����
  if w_res then begin
    DB_RisFTP.DatabaseRis.Commit;
    //���A�l�\��
    lbl_res.Caption:= '���A�l�FTrue';
    //����\��
    BitBtn11.Font.Color := clWindowText;
  end
  //�ُ�
  else begin
    DB_RisFTP.DatabaseRis.Rollback;
    //���A�l�\��
    lbl_res.Caption:= '���A�l�FFalse';
    //�G���[�\��
    BitBtn11.Font.Color := clRed;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
    //�d����̉��
    w_SendMsgTSList.Free;
    w_RecvMsgTSList.Free;
    w_SendMsgStream.Free;
    w_RecvMsgStream.Free;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  w_s:string;
begin
  //�e�[�u�����ڑ�����Ă��āA���R�[�h������ꍇ
  if Table6.Active and (Table6.RecordCount > 0) then begin
    //�d�����擾
    w_s := Table6.FieldByName('Denbun').AsString;
    //������
    w_DataStream.Position := 0;
    //������
    w_DataStream.WriteString(w_s);
    //�N���A
    Memo1.Lines.clear;
    //�\��
    proc_TStrmToStrlist(w_DataStream,TStringList(Memo1.lines),G_MSG_SYSTEM_A,G_MSGKIND_JISSI);
  end
  //����ȊO�̏ꍇ
  else begin
    //�N���A
    Memo1.Lines.clear;
    Memo1.Text := '�d���\��';
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
  //�G���[�\��
  lbl_err.Caption := '';
  DB_RisFTP.DatabaseRis.StartTransaction;
  //�I�[�_�V�F�[�}���X�V
  w_res := func_FTP_Update(DB_RisFTP.DatabaseRis,DB_RisFTP.TQ_Etc,DB_RisFTP.TQ_Order.FieldByName('RIS_ID').AsString,g_Schema_Main,g_Schema_Sub,wi_Count,ws_ECode,w_Err);
  //�G���[�\��
  lbl_err.Caption := w_Err;
  //����
  if w_res then begin
    DB_RisFTP.DatabaseRis.Commit;
    //���A�l�\��
    lbl_res.Caption:= '���A�l�FTrue';
    //����\��
    BitBtn2.Font.Color := clWindowText;
  end
  //�ُ�
  else begin
    DB_RisFTP.DatabaseRis.Rollback;
    //���A�l�\��
    lbl_res.Caption:= '���A�l�FFalse';
    //�G���[�\��
    BitBtn2.Font.Color := clRed;
  end;
end;

end.
