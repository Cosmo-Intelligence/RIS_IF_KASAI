unit TP_Svr_IRAI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, Db,
//�v���_�N�g�J�����ʁ|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
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
  //�e�[�u���\����
  type TDB_DISP_TITLE = array[CST_DB_S_COUNT..CST_DB_E_COUNT] of String;
  const
    DB_DISP_TITLE : TDB_DISP_TITLE =
    (
     '�I�[�_���C���e�[�u��','�I�[�_���ʃe�[�u��',
     '�I�[�_�w���e�[�u��','���҃}�X�^','��M�I�[�_�e�[�u��','�g���I�[�_���e�[�u��',
     '�I�[�_�V�F�[�}���e�[�u��','���у��C���e�[�u��','�������e�[�u��',
     '���|�[�g���e�[�u��','�������҃e�[�u��','���ÃI�[�_���C���e�[�u��','���Êg���I�[�_�e�[�u��',
     '�I�[�_���C��SN�e�[�u��','���Î��у��C���e�[�u��','�g�����у��C���e�[�u��','���Ê��҃e�[�u��'
    );
  //�e�[�u����
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
    { Private �錾 }
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
    { Public �錾 }
  end;

var
  Form1: TForm1;

implementation

uses URH_SvrSvc_Irai;

{$R *.DFM}

procedure TForm1.Button2Click(Sender: TObject);
begin
  //��M�I�[�_�e�[�u������w��Ɋ��Ԃ��߂������R�[�h�̍폜
  w_res := DB_RisSvr_Irai.func_DelOrder(StrToIntDef(arg_Keep.text,10),w_Err);
  //��ԕ\��
  lbl_err.Caption := w_Err;
  //����̏ꍇ
  if w_res then
    lbl_res.Caption:= 'True'
  //�ُ�̏ꍇ
  else
    lbl_res.Caption:= 'False';
end;

procedure TForm1.Button10Click(Sender: TObject);
var
  w_Res:Boolean;
begin
  //RisDB�ؒf
  DB_RisSvr_Irai.DBClose;
  //�����F��ύX�H
  BitBtn1.Font.Color := clBlack;
  Button5.Enabled := False;
  Button7.Enabled := False;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  //�e�e�[�u���̍ēǂݍ���
  //�ؒf
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
  //�ڑ�
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
  //������
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
  //�s���b�N�J�n
  w_res := DB_RisSvr_Irai.func_LockTbl(Edit3.Text,Edit4.Text,Edit5.Text,ComboBox1.Text);
  //����
  if w_res then
    lbl_res.Caption:= 'True'
  //���s
  else
    lbl_res.Caption:= 'False';
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
  //���[���o�b�N
  DB_RisSvr_Irai.DatabaseRis.Rollback;
  //�����F�̕ύX
  BitBtn2.Font.Color := clBlack;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  w_Res:Boolean;
begin
  //RisDB�ڑ�����
  w_res := DB_RisSvr_Irai.DBOpen(w_Err,nil);
  //�G���[�󋵕\��
  lbl_err.Caption := w_Err;
  //����I���̏ꍇ
  if w_res then begin
    //�߂�l��\��
    lbl_res.Caption := 'True';
    //�����F��ύX
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

    //�e�֘A�e�[�u���I�[�v��
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
  //�ُ�I��
  else begin
    //�߂�l��\��
    lbl_res.Caption := 'False';
    //�����F�͂��̂܂�
    BitBtn1.Font.Color := clBlack;
  end; 
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  //�g�����U�N�V�����J�n
  DB_RisSvr_Irai.DatabaseRis.StartTransaction;
  //�����F�ύX
  BitBtn2.Font.Color := clRed;
end;

procedure TForm1.Button18Click(Sender: TObject);
begin
  //�`�F�b�N�����ׂĐ���̏ꍇ
  if w_res1 and w_res2 and w_res3 then begin
    //���O�o��
    proc_LogOut(G_LOG_LINE_HEAD_OK,w_RecvMsgTimeS,G_LOG_KIND_DB_NUM,w_LogBuffer) ;
  end
  //����ȊO�̏ꍇ
  else begin
    //���O�o��
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
  //�e�[�u�����ڑ�����Ă��āA���R�[�h������ꍇ
  if Tbl_JUSINORDERTABLE.Active and (Tbl_JUSINORDERTABLE.RecordCount > 0) then begin
    //�d�����擾
    w_s := Tbl_JUSINORDERTABLE.FieldByName('RECIEVETEXT').AsString;
    //������
    w_DataStream.Position := 0;
    //������
    w_DataStream.WriteString(w_s);
    //�N���A
    mem_msg.Lines.clear;
    //mem_msg.Text := Tbl_JUSINORDERTABLE.FieldByName('RECIEVETEXT').AsString;
    if Tbl_JUSINORDERTABLE.FieldByName('MESSAGETYPE').AsString = CST_APPTYPE_OI01 then
    begin
      //�\��
      proc_TStrmToStrlist(w_DataStream,TStringList(mem_msg.lines),G_MSG_SYSTEM_A,G_MSGKIND_IRAI);
    end
    else if (Tbl_JUSINORDERTABLE.FieldByName('MESSAGETYPE').AsString = CST_APPTYPE_PI01) or
            (Tbl_JUSINORDERTABLE.FieldByName('MESSAGETYPE').AsString = CST_APPTYPE_PI99) then
    begin
      //�\��
      proc_TStrmToStrlist(w_DataStream,TStringList(mem_msg.lines),G_MSG_SYSTEM_A,G_MSGKIND_KANJA);
    end
    else if (Tbl_JUSINORDERTABLE.FieldByName('MESSAGETYPE').AsString = CST_APPTYPE_OI99) then
    begin
      //�\��
      proc_TStrmToStrlist(w_DataStream,TStringList(mem_msg.lines),G_MSG_SYSTEM_A,G_MSGKIND_CANCEL);
    end;
  end
  //����ȊO�̏ꍇ
  else begin
    //�N���A
    mem_msg.Lines.clear;
    mem_msg.Text := '�d���\��';
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
    lbl_err.Caption := 'INI�t�@�C�����ǂݍ��܂�Ă��܂���B';
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  w_Ini_Flg := False;
  //�d�����̃`�F�b�N
  if func_TcpReadiniFile then begin
    w_Ini_Flg := True;
    //���O������쐬
    lbl_res.Caption:= 'True';
    lbl_err.Caption := 'INI�t�@�C���ǂݍ��ݐ���';
    Edit2.Text := Trim(g_S_Socket_Info_01.f_Port);
  end
  else begin
    lbl_res.Caption:= 'False';
    lbl_err.Caption := 'INI�t�@�C���ǂݍ��ݎ��s';
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
  //�e�[�u�����ڑ�����Ă��āA���R�[�h������ꍇ
  if Tbl_ORDERINDICATETABLE.Active and (Tbl_ORDERINDICATETABLE.RecordCount > 0) then begin
    //�����ړI���擾
    w_s := Tbl_ORDERINDICATETABLE.FieldByName('KENSA_SIJI').AsString;
    //�N���A
    Memo1.Clear;
    //�\��
    Memo1.Text := w_s;
  end
  //����ȊO�̏ꍇ
  else begin
    //�N���A
    Memo1.Clear;
  end;
end;

procedure TForm1.BitBtn8Click(Sender: TObject);
var
  w_s:string;
begin
  //�e�[�u�����ڑ�����Ă��āA���R�[�h������ꍇ
  if Tbl_ORDERINDICATETABLE.Active and (Tbl_ORDERINDICATETABLE.RecordCount > 0) then begin
    //�Տ��f�f���擾
    w_s := Tbl_ORDERINDICATETABLE.FieldByName('RINSYOU').AsString;
    //�N���A
    Memo1.Clear;
    //�\��
    Memo1.Text := w_s;
  end
  //����ȊO�̏ꍇ
  else begin
    //�N���A
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
    //�e�[�u�����ڑ�����Ă��āA���R�[�h������ꍇ
    if Tbl_ORDERINDICATETABLE.Active and (Tbl_ORDERINDICATETABLE.RecordCount > 0) then begin
      //�N���A
      mem_msg.Clear;
      //�I�[�_�R�����g�^�C�g��
      w_s := '�I�[�_�R�����g';
      //�\��
      mem_msg.Lines.Add(w_s);
      //ORDERCOMMENT_ID���擾
      w_s := Tbl_ORDERINDICATETABLE.FieldByName('ORDERCOMMENT_ID').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
      //�����ړI�^�C�g��
      w_s := '�����ړI';
      //�\��
      mem_msg.Lines.Add(w_s);
      //KENSA_SIJI���擾
      w_s := Tbl_ORDERINDICATETABLE.FieldByName('KENSA_SIJI').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
      //�Տ��f�f�^�C�g��
      w_s := '�Տ��f�f';
      //�\��
      mem_msg.Lines.Add(w_s);
      //RINSYOU���擾
      w_s := Tbl_ORDERINDICATETABLE.FieldByName('RINSYOU').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
      //���l�^�C�g��
      w_s := '���l';
      //�\��
      mem_msg.Lines.Add(w_s);
      //REMARKS���擾
      w_s := Tbl_ORDERINDICATETABLE.FieldByName('REMARKS').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
    end
    //����ȊO�̏ꍇ
    else begin
      //�N���A
      mem_msg.Clear;
    end;
  end
  else if PageControl1.ActivePageIndex = 3 then begin
    //�e�[�u�����ڑ�����Ă��āA���R�[�h������ꍇ
    if Tbl_KANJAMASTER.Active and (Tbl_KANJAMASTER.RecordCount > 0) then begin
      //�N���A
      mem_msg.Clear;
      //�Z��1�^�C�g��
      w_s := '�Z��1';
      //�\��
      mem_msg.Lines.Add(w_s);
      //JUSYO1���擾
      w_s := Tbl_KANJAMASTER.FieldByName('JUSYO1').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
      //�Z��2�^�C�g��
      w_s := '�Z��2';
      //�\��
      mem_msg.Lines.Add(w_s);
      //JUSYO2���擾
      w_s := Tbl_KANJAMASTER.FieldByName('JUSYO2').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
      //�Z��3�^�C�g��
      w_s := '�Z��3';
      //�\��
      mem_msg.Lines.Add(w_s);
      //JUSYO3���擾
      w_s := Tbl_KANJAMASTER.FieldByName('JUSYO3').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
      //��Q���^�C�g��
      w_s := '��Q���';
      //�\��
      mem_msg.Lines.Add(w_s);
      //HANDICAPPED���擾
      w_s := Tbl_KANJAMASTER.FieldByName('HANDICAPPED').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
      //�������^�C�g��
      w_s := '�������';
      //�\��
      mem_msg.Lines.Add(w_s);
      //INFECTION���擾
      w_s := Tbl_KANJAMASTER.FieldByName('INFECTION').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
      //�֊����^�C�g��
      w_s := '�֊����';
      //�\��
      mem_msg.Lines.Add(w_s);
      //CONTRAINDICATION���擾
      w_s := Tbl_KANJAMASTER.FieldByName('CONTRAINDICATION').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
      //�A�����M�[���^�C�g��
      w_s := '�A�����M�[���';
      //�\��
      mem_msg.Lines.Add(w_s);
      //ALLERGY���擾
      w_s := Tbl_KANJAMASTER.FieldByName('ALLERGY').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
      //�D�P���^�C�g��
      w_s := '�D�P���';
      //�\��
      mem_msg.Lines.Add(w_s);
      //PREGNANCY���擾
      w_s := Tbl_KANJAMASTER.FieldByName('PREGNANCY').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
      //���̑����ӎ����^�C�g��
      w_s := '���̑����ӎ���';
      //�\��
      mem_msg.Lines.Add(w_s);
      //NOTES���擾
      w_s := Tbl_KANJAMASTER.FieldByName('NOTES').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
      //�����f�[�^���^�C�g��
      w_s := '�����f�[�^���';
      //�\��
      mem_msg.Lines.Add(w_s);
      //EXAMDATA���擾
      w_s := Tbl_KANJAMASTER.FieldByName('EXAMDATA').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
      //���̑������^�C�g��
      w_s := '���̑��������';
      //�\��
      mem_msg.Lines.Add(w_s);
      //EXTRAPROFILE���擾
      w_s := Tbl_KANJAMASTER.FieldByName('EXTRAPROFILE').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
    end
    //����ȊO�̏ꍇ
    else begin
      //�N���A
      mem_msg.Clear;
    end;
  end
  else if PageControl1.ActivePageIndex = 7 then begin
    //�e�[�u�����ڑ�����Ă��āA���R�[�h������ꍇ
    if Tbl_ORDERSHEMAINFO.Active and (Tbl_ORDERSHEMAINFO.RecordCount > 0) then begin
      //�N���A
      mem_msg.Clear;
      //�V�F�[�}�p�X�^�C�g��
      w_s := '�V�F�[�}�p�X';
      //�\��
      mem_msg.Lines.Add(w_s);
      //SHEMAPASS���擾
      w_s := Tbl_ORDERSHEMAINFO.FieldByName('SHEMAPASS').AsString;
      //�\��
      mem_msg.Lines.Add(w_s);
    end
    //����ȊO�̏ꍇ
    else begin
      //�N���A
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
  //�d�����̃`�F�b�N
  if g_S_Socket_Info_01.f_Port = '' then begin
    lbl_res.Caption:= 'False';
    lbl_err.Caption := '�|�[�g���ǂݍ��ݎ��s�u' + w_sErr + '�v';
    Edit2.Text := '';
  end
  else begin
    //���O������쐬
    lbl_res.Caption:= 'True';
    lbl_err.Caption := '�|�[�g���ǂݍ��ݐ���';
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
