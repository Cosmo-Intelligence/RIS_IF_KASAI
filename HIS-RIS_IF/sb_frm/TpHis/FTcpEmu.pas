unit FTcpEmu;
interface //*****************************************************************
(**
���@�\����
      ISO�w����̪�
���J�@�\
���ׂĂ̋@�\�́A�t�H�[�����쐬���鏉����������I��������ł̂݋@�\����
�@�G�~�����[�^�������@�\(�֐�)
-----------------------------------------------------------------------------
  ���O : func_TcpEmuOpen
  ���� :
         arg_OwnForm:TForm;        �e�t�H�[�� �K�{
         arg_Visible:boolean;      �\�����[�h �K�{
                    gi_Rig_EmuVisible=g_RIG_EMUVISIBLE_FALSE FALSE  �ʏ�
                    gi_Rig_EmuVisible=g_RIG_EMUVISIBLE_TRUE  TRUE
         arg_Enable:boolean;       �Θb���[�h �K�{
                    gi_Rig_EmuVisible=g_RIG_EMUENABLED_FALSE FALSE  �ʏ�
                    gi_Rig_EmuVisible=g_RIG_EMUENABLED_TRUE  TRUE
         arg_RcvCmdArea:TStrigList �R�}���h��M�� �K�{
  �@�\ : �t�H�[���쐬�ƃT�[�o�������ȂǒʐM�ɕK�v�ȏ���������
  ���A�l�F�G�~�����[�^�t�H�[�� Nil���s ��O�L��
-----------------------------------------------------------------------------

�A��M����ݒ�@�\�iTFrm_TcpEmu�̃��\�b�h�j���g�p�\��
 -------------------------------------------------------------------
 * @outline  proc_SetSSockInfo
 * @param arg_Socket:TCustomWinSocket   ���M�Ɏg�p����\�P�b�g
 * @param arg_port:string; �|�[�g
 * ��O����
 * ��M���̃|�[�g�����Z�b�g����B
 *
 -------------------------------------------------------------------

�B���M����ݒ�@�\�iTFrm_TcpEmu�̃��\�b�h�j
 -------------------------------------------------------------------
 * @outline  proc_SetCSockInfo
 * @param arg_Socket:TCustomWinSocket   ���M�Ɏg�p����\�P�b�g
 * @param arg_ip:string;
 * @param arg_port:string;
 * ���M��̏����Z�b�g����Bfunc_SendMsg�̑O�ɍs���ƗL���ɂȂ�
 *
 -------------------------------------------------------------------

�C�d�����M��M�@�\�iTFrm_TcpEmu�̃��\�b�h�j
-----------------------------------------------------------------------------
  ���O : func_SendMsg;
  ���� : �Ȃ�
       arg_Msg: TStream;       ���M�d��������
       arg_Res: TStream;       ��M�d��������
       arg_Socket:TCustomWinSocket   ���M�Ɏg�p����\�P�b�g
                                     nil:�G�~�����[�^�ɗL��f�t�H���g


  �@�\ : ����ޱ��ײ���M�@�\
  ���A�l�F��O�Ȃ�
  �װ����(4�� XXYY
              XX�F�����ʒu01�`07�菇
              00�F����                   G_TCPSND_PRTCL00
              01�F�����m�F               G_TCPSND_PRTCL01
              02�F�����m�F�����i���g�p�j G_TCPSND_PRTCL02
              03�F�R�}���h���M           G_TCPSND_PRTCL03
              04�F�R�}���hACK �i���g�p�j G_TCPSND_PRTCL04
              05�F�f�[�^�����M           G_TCPSND_PRTCL05
              06�F�f�[�^��ACK �i���g�p�j G_TCPSND_PRTCL06
              07�F�f�[�^���M             G_TCPSND_PRTCL07
              08�F�f�[�^ACK   �i���g�p�j G_TCPSND_PRTCL08
              YY�F�ڍ�
              00�F�����^����             G_TCPSND_PRTCL_ERR00
              01�F���M���s               G_TCPSND_PRTCL_ERR01
              02�F������                 G_TCPSND_PRTCL_ERR02
              03�F�ԓ����s�^����         G_TCPSND_PRTCL_ERR03
              )
�����ӁF�e�R�[�h�iXX��YY�j�͉��L��`����Ă��܂�
-----------------------------------------------------------------------------

�D�G�~�����[�^�I�����@�\�iTFrm_TcpEmu�̃��\�b�h�j
  �@�쐬�̃t�H�[�����N���[�Y����B
  .close; ��O�L��


�E���O�o�͋@�\�i�֐��j
-----------------------------------------------------------------------------
  ���O : proc_LogOperate(Operate);
  ���� :
   Operate: string : ������e
  �@�\ : ���O�ɋL�^����B
  ��O�͂��ׂĖ�������̂łȂ�
-----------------------------------------------------------------------------
���p���`
���b�Z�[�W�F�R�}���h �A�v���C
�v���g�R���i�菇�j�F��L�𑗂邽�߂̏��Ԃ̌��܂����d���̏W�܂�
�d���F�\�P�b�g��TCPIP�]���d��


������
�V�K�쐬�F01.09.17�F�S��iwai

*)

//�g�p���j�b�g---------------------------------------------------------------
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ScktComp, IniFiles, ExtCtrls, Buttons,math, FileCtrl,
  Gval,pdct_ini,pdct_com ,HisMsgDef
  ;

////�^�N���X�錾-------------------------------------------------------------
// �\���^
type   //�\�P�b�g�ʐM�T�[�o�ێ����
  TServer_Info = record
    Port1         : string[4]; //�ڑ��҂��|�[�g�A�h���X1
    Port1_CrntMsg : string[1]; //�J�����g����Msg���   1
    Port2         : string[4]; //�ڑ��҂��|�[�g�A�h���X2
    Port2_CrntMsg : string[1]; //�J�����g����Msg���   2
    Port3         : string[4]; //�ڑ��҂��|�[�g�A�h���X2
    Port3_CrntMsg : string[1]; //�J�����g����Msg���   2
    FPTimeOut     : Longint;   //�^�C���A�E�g
    FATimeOut     : Longint;   //
    FLogActive    : string;    //���O�擾���
    FLogPath      : string;    //���O�o�͐�
    FLogSize      : Integer;   //���O�o�̓T�C�Y
  end;
type   //�\�P�b�g�ʐM�N���C�A���g�ێ����
  TClint_Info = record
    IPAdrr1       : string[15]; //�T�[�o�A�h���X1
    Port1         : string[4];  //�T�[�o�|�[�g1
    STimeOut1     : Longint;    //�^�C���A�E�g
    Port1_CrntMsg : string[1];  //�J�����g����Msg���1

    IPAdrr2       : string[15]; //�T�[�o�A�h���X2
    Port2         : string[4];  //�T�[�o�|�[�g2
    STimeOut2     : Longint;    //�^�C���A�E�g2
    Port2_CrntMsg : string[1];  //�J�����g����Msg���2

    IPAdrr3       : string[15]; //�T�[�o�A�h���X3
    Port3         : string[4];  //�T�[�o�|�[�g3
    STimeOut3     : Longint;    //�^�C���A�E�g3
    Port3_CrntMsg : string[1];  //�J�����g����Msg���3

    FLogActive    : string;     //���O�擾���
    FLogPath      : string;     //���O�o�͐�
    FLogSize      : Integer;    //���O�o�̓T�C�Y
  end;

//�t�H�[��
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
    { Private �錾 }
    //INI��� proc_SetInitialInfo�Ŏg���B
    w_Clint_Info : TClint_Info;
    FVersion     : string;
    w_ServerInfo : TServer_Info;

    //����t���O
    w_ClintWaitFlag:boolean;  //�N���C�A���g��u���b�L���O�ڑ��p ���g�p
    w_MsgKind_Flag:string;    //���b�Z�[�W���
    //�T�[�o��M�d����
    ServerRecieveBuf     : TBuffur; //�d����M��
    ServerRecieveBuf_Len : Longint;      //���d����
    ServerRecieveBuf_LenPlan : Longint;  //�\��d����
    w_Stream_Ack         : TBuffur;           //�����̈�


    //��͌��ʊi�[��
    F_PlanMsg_Len        : Longint;      //�\���M�R�}���h�A�v���C��
    F_RealMsg_Len        : Longint;      //��  ��M�R�}���h�A�v���C��
    F_sMsg               : String;  //�R�}���h�A�v���C�ۑ���

  public
    { Public �錾 }
    w_RcvCmdArea:TStringList;    //�R�}���h��M�̈�
    w_RcvApplyArea:TStringList;  //�R�}���h�ɑ΂��錋�ʃA�v���C�̎�M�̈�
    //���������ݒ�
    procedure proc_SetInitialInfo;
    //����������
    procedure proc_Start;
    //�I��������
    procedure proc_End;
    //
    procedure proc_SetCSockInfo(arg_ip:string;arg_port:string);
    //
    procedure proc_SetSSockInfo(arg_port:string);
    //����ޱ��ײ���M�@�\
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

//�萔�錾-------------------------------------------------------------------
const
  G_PKT_PTH_DEF='RIS_RIG.log'; //LOG�t�@�C��
const
  //�v���g�R�� �R�}���h�R�[�h
  G_PRTCL_STRM_01 =  $1001;
  G_PRTCL_STRM_02 =  $9001;
  G_PRTCL_STRM_03 =  $1002;
  G_PRTCL_STRM_04 =  $9002;
  G_PRTCL_STRM_05 =  $1003;
  G_PRTCL_STRM_06 =  $9003;
  G_PRTCL_STRM_07 =  $1004;
  G_PRTCL_STRM_08 =  $9004;
  //�v���g�R�� �d�����A�R�[�h
  G_PRTCL_STRM_RTOK= $0000; //����
  G_PRTCL_STRM_RTNG= $ffff; //�G���[
  //�v���g�R���i�菇�j�ԍ�
  G_TCPSND_PRTCL00='00';
  G_TCPSND_PRTCL01='01';//�����m�F
  G_TCPSND_PRTCL02='02';//�����m�F����
  G_TCPSND_PRTCL03='03';//�R�}���h���M
  G_TCPSND_PRTCL04='04';//�R�}���h���M����
  G_TCPSND_PRTCL05='05';//�f�[�^�����M
  G_TCPSND_PRTCL06='06';//�f�[�^�����M����
  G_TCPSND_PRTCL07='07';//�f�[�^���M
  G_TCPSND_PRTCL08='08';//�f�[�^���M����
  //�^�C���A�E�g�ŏ��l
  G_MINIMUN_TIMEOUT=10; //�P�Oms

// �ڍ�***** �v���g�R�� �G���[���
const
  G_TCPSND_PRTCL_ERR00='00';//����
  G_TCPSND_PRTCL_ERR01='01';//���M���s
  G_TCPSND_PRTCL_ERR02='02';//������
  G_TCPSND_PRTCL_ERR03='03';//�ԓ����s�^����
  G_TCPSND_PRTCL_OK   = G_TCPSND_PRTCL00+G_TCPSND_PRTCL_ERR00;//����
//�ϐ��錾-------------------------------------------------------------------
var
  Frm_TcpEmu: TFrm_TcpEmu;

//�֐��葱���錾-------------------------------------------------------------
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

//�g�p���j�b�g---------------------------------------------------------------
//uses
//�萔�錾       -------------------------------------------------------------
//const
//�ϐ��錾     ---------------------------------------------------------------
//var
//�֐��葱���錾--------------------------------------------------------------

//======================�C�x���g����===========================================

//=============================================================================
//�t�H�[��������������������������������������������������������������������
//=============================================================================
procedure TFrm_TcpEmu.FormCreate(Sender: TObject);
begin
 //��O�͔��������Ȃ�
 //�ݽ�ݽ�����������è�����N���A
  w_RcvCmdArea   := nil;
  w_RcvApplyArea := nil;
  w_ClintWaitFlag:= False;
  w_MsgKind_Flag := G_MSGKIND_NONE;
 //�d����M��N���A
  ServerRecieveBuf_Len:=0;
  ServerRecieveBuf_LenPlan:=0;
  FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);
 //������N���A
//  FillChar(w_Stream_Ack,sizeof(w_Stream_Ack), #0);
 //���b�Z�[�W�i�[��N���A
  F_sMsg:='';
  F_PlanMsg_Len:=-1;
  F_RealMsg_Len:=-1;
  FileListBox1.Directory:=G_RunPath ;
 // �C�j�V�����t�@�C�������[�h����B
  proc_SetInitialInfo;
  REdt_RcvAppData.Lines.Clear;
  REdt_RcvAppData.Clear;
  REdt_RcvCmdData.Lines.Clear;
  REdt_RcvCmdData.Clear;



end;
procedure TFrm_TcpEmu.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //���b�Z�[�W�i�[����
  F_sMsg:='';
  //�I��������B
  proc_End;
  //�̈�͉������
  Action:=caFree;

end;
procedure TFrm_TcpEmu.FormDestroy(Sender: TObject);
begin
  //
end;
//[�R�}���h���M]�{�^��
procedure TFrm_TcpEmu.btn_SendCmdClick(Sender: TObject);
var
  w_RtCod:string;
  w_TstringList:TStringList;
begin
  //��ԕ\���ύX �ڑ�
  //�\�P�b�g�̍ŏ�����
  lbl_CsokStat.Font.Color:= clRed;//�ڑ��\��
  lbl_CsokStat.Caption :='�ڑ���';
  lbl_CsokStat.Refresh;
  ClientSocket1.Address:= Edt_SrvIp.Text;
  ClientSocket1.Port:=StrToInt(Edt_SrvPort1.text);
  //�d���擾
  w_TstringList:= TStringList.Create;
  try
  w_TstringList.AddStrings(REdt_SndCmdData.Lines);
  //�d�����M
  if 
  w_RtCod:=func_SendMsg(TStringList(w_TstringList),
                        G_MSGKIND_IRAI,
                        nil,
                        (ClientSocket1));
  finally
  w_TstringList.Free;
  end;
  //��ԕ\���ύX �ؒf
  lbl_CsokStat.Font.Color:= clWindowText;//�ڑ��\��
  lbl_CsokStat.Caption   := '�ؒf = '+ w_RtCod;
  lbl_CsokStat.Refresh;
end;
//[�A�v���C���M]�{�^��
procedure TFrm_TcpEmu.btn_SendApplyClick(Sender: TObject);
begin

end;

//[����]�{�^��
procedure TFrm_TcpEmu.Button2Click(Sender: TObject);
begin
  ClientSocket1.Active:=False;
  ClientSocket1.Close;
  Close;
end;

//[������]�{�^�� �T�[�o�@�\�������˗�
procedure TFrm_TcpEmu.btn_InitClick(Sender: TObject);
begin
      proc_Start;
end;
//�R�}���h��M��
procedure TFrm_TcpEmu.REdt_RcvCmdData1Change(Sender: TObject);
begin
end;

//���ײ��M��
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
//�t�H�[����������������������������������������������������������������������
//=============================================================================

//=============================================================================
//�N���C�A���g�\�P�b�g������������������������������������������������������������������
//=============================================================================
//�N���C�A���g�\�P�b�g�ڑ��ʒm
procedure TFrm_TcpEmu.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_C_StatusList('Connected to: ' + Socket.RemoteAddress);
end;
//�N���C�A���g�\�P�b�g�ؒf�ʒm
procedure TFrm_TcpEmu.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_C_StatusList('DisConnected to: ' + Socket.RemoteAddress);
end;
//�N���C�A���g�\�P�b�g�G���[�ʒm
procedure TFrm_TcpEmu.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  proc_C_StatusList('Error...'+IntToStr(ErrorCode));
  ErrorCode:=0; //��O�͔��������Ȃ�
end;
//�N���C�A���g�\�P�b�g������M�ʒm
procedure TFrm_TcpEmu.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//��u���b�L���O�̏���
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
//�X�e�[�^�X�\��
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
  //LOG�ɂ��o�͂���B
    proc_LogOperate('�N���C�A���g�����i' + arg_string + '�j');
  except
    exit;
  end;
end;
//=============================================================================
//�N���C�A���g�\�P�b�g��������������������������������������������������������������������
//=============================================================================

//=============================================================================
//�T�[�o�\�P�b�g������������������������������������������������������������������
//=============================================================================
procedure TFrm_TcpEmu.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_S_StatusList('�N���C�A���g���ڑ�����܂���...');
  //�d�����M�@�\�̏����� �P�ڑ��P�v���g�R��
  //�d���̃N���A
    ServerRecieveBuf_LenPlan:=0;
    ServerRecieveBuf_Len:=0;
    FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);
  //������N���A
    FillChar(w_Stream_Ack,sizeof(w_Stream_Ack), #0);

  //���b�Z�[�W�̃N���A
    F_PlanMsg_Len:= 0;
    F_RealMsg_Len:= 0;
    F_sMsg       := '';

end;

procedure TFrm_TcpEmu.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_S_StatusList('�N���C�A���g���ؒf����܂���...');

end;

procedure TFrm_TcpEmu.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  proc_S_StatusList('Error...code='+IntTostr(ErrorCode));
  ErrorCode:=0;  //��O�͔��������Ȃ�

end;
//�d���f�[�^�u���b�N�̎�M
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
  //�d���͈�P�ʓd������������Ă���̂Œ���
  //�Ώ��Ƃ��Ă�
  //�@��Ԏn�߂ɂ��ׂċ����I�ɓǂݎ���Ă��܂��B�傫�����̓X���b�h��L���Ă��܂�
  //�A�������ČĂ�ň�P�ʓd�����ɉ�͏������Ăяo��(�̗p)
  //��M�i�[
  //���݂̗\��d�������O�ȉ��Ȃ�擪��ǂݎ�蒆�Ȃ̂ŗ\��d������ǂݍ���
  if ServerRecieveBuf_LenPlan <=0 then  //��P�ʓd���Ǎ��ݏI������0�ɂ��邱��
  begin  //�\�蒷�܂ł̓Ǎ��݂����݂�
    //�P�o�C�g�܂ł̕����Ǎ��݂ɑΏ�����
    res := Socket.ReceiveBuf(w_TBuffur1,sizeof(w_TBuffur1));
    CopyMemory(@w_TBuffur2,@ServerRecieveBuf,ServerRecieveBuf_Len);
    CopyMemory(Addr(w_TBuffur2.data[ServerRecieveBuf_Len+1]),@w_TBuffur1,res);
    ServerRecieveBuf_Len := ServerRecieveBuf_Len + res;
    CopyMemory(@ServerRecieveBuf,@w_TBuffur2,ServerRecieveBuf_Len);

    if ServerRecieveBuf_Len >= sizeof(TStrm_ComnHeader01) then
    begin  //�\�蒷�܂ł͓ǂ߂�
      proc_S_StatusList('�d����M�J�n...< '+ ' >');
      proc_S_StatusList('��M�T�C�Y = '+ IntToStr(ServerRecieveBuf_Len) + 'Byte');
      CopyMemory(@TStrm_ComnHeader01((@ServerRecieveBuf)^). DenbunChou_15[1],@w_b[1],5);
      ServerRecieveBuf_LenPlan:=StrToint(w_b);
      if  ServerRecieveBuf_LenPlan > ServerRecieveBuf_Len then
      begin  //�S���͓ǂ߂Ă��Ȃ��̂ōēǍ��݂�҂�
            exit;
//�����|�|�ēǍ��ݑ҂��F
      end;
    end
    else
    begin //�\�蒷�܂ł͓ǂ߂Ȃ������̂ł�����x�ǂޕK�v������
      exit;  //�����ēd������Ă���̂�҂�
//�����|�|�ēǍ��ݑ҂��F
    end;
  end;
//�ēx�r���̓d���ǂݍ���
  if  ServerRecieveBuf_LenPlan > ServerRecieveBuf_Len then
  begin  //�ēx�ǂޕK�v������
    res := Socket.ReceiveBuf(w_TBuffur1,sizeof(w_TBuffur1));
    //�P�o�C�g�܂ł̕����Ǎ��݂ɑΏ�����
    CopyMemory(@w_TBuffur2,@ServerRecieveBuf,ServerRecieveBuf_Len);
    CopyMemory(Addr(w_TBuffur2.data[ServerRecieveBuf_Len+1]),@w_TBuffur1,res);
    ServerRecieveBuf_Len := ServerRecieveBuf_Len + res;
    CopyMemory(@ServerRecieveBuf,@w_TBuffur2,ServerRecieveBuf_Len);
  end;//�܂��r���Ȃ̂�������ׂ�
  if  ServerRecieveBuf_LenPlan > ServerRecieveBuf_Len then
  begin
    proc_S_StatusList('��M�T�C�Y = '+ IntToStr(ServerRecieveBuf_Len) + 'Byte');
    exit;
//�����|�|�ēǍ��ݑ҂��F
  end;
  //ServerRecieveBuf�Ɉ�P�ʓd�����ǂݍ��܂ꂽ�B
  proc_S_StatusList('��M�T�C�YE= '+ IntToStr(ServerRecieveBuf_Len) + 'Byte');
  proc_S_StatusList('�d����M����...');
  //�d����͈˗�
  proc_AnalizeStream(Sender,Socket);
  proc_SendAckStream(Sender,Socket);
  //��P�ʓd���N���A�A�����d���͎c�� �����Ǎ��݂̂���
  ServerRecieveBuf_LenPlan:=0;//��P�ʓd���̎�M�I�����Ӗ�����
  ServerRecieveBuf_Len:=0;

{�Ώ��@�̏���
  //�d�������N���A
  ServerRecieveBuf_Len := 0;
  //
  res := Socket.ReceiveBuf(ServerRecieveBuf,sizeof(TStream_Header));
  ServerRecieveBuf_Len := ServerRecieveBuf_Len + res;

  proc_S_StatusList('�d����M�J�n...< '+ IntToHex(ServerRecieveBuf.commad,0) + ' >');
  pos := 0;
  w_DataSize:= ServerRecieveBuf.length;
  while (w_DataSize) > pos do
  begin
    w_size := sizeof(ServerRecieveBuf.data) - pos;
    res := Socket.ReceiveBuf(ServerRecieveBuf.data[pos+1], w_size);
    ServerRecieveBuf_Len := ServerRecieveBuf_Len+res;
    pos := pos+res;
  end;

  proc_S_StatusList('��M�T�C�Y = '+ IntToStr(w_DataSize) + 'Byte');
  proc_S_StatusList('�d����M����...');

  proc_AnalizeStream(Sender,Socket);
}
end;
procedure TFrm_TcpEmu.ServerSocket1ClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//ServerRecieveBuf ��M�����͂��ĉ����𑗐M���邱�Ƃ��˗�����B�i������j
//  proc_SendAckStream(Sender,Socket);

end;
//��P�ʓd���̉�͂ƑΏ�
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
//out:w_Stream_Ack���M  F_Msg �� REdt_RcvCmdData / REdt_RcvAppData
//ServerRecieveBuf����̎�M�d�������
//��M�d�����Ȃ����͑������A
//�T�[�o���͎�M�d���ɑ΂��鉞���͏�ɌŒ肳��Ă���B�i�y�A�[�ɂȂ��Ă���j
  proc_S_StatusList('�d����͊J�n...');
  //������N���A
//  FillChar(w_Stream_Ack,sizeof(w_Stream_Ack), #0);
  if ServerRecieveBuf_Len=-1 then
  begin
    proc_S_StatusList('�d����͊���...�d������-1');
    exit;
  end;
  if ServerRecieveBuf_Len=0 then
  begin
    proc_S_StatusList('�d����͊���...�d������0');
    exit;
  end;
  if ServerRecieveBuf_Len<ServerRecieveBuf_LenPlan then
  begin
    proc_S_StatusList('�d����͊���...�d���s���S');
    exit;
  end;

//01�̏���02
if RadioButton1.Checked then
begin
  //CB_JUNBI_ERR02 �^�C���A�E�g
  if CB_JUNBI_ERR02.Checked then
  begin
    proc_S_StatusList('�d����͊J�n���s...�^�C���A�E�g');
    proc_S_StatusList('�d����͊���...');
    //����d���̂Ȃ���Ԃɂ��ă^�C���A�E�g�ɂ���
    ServerRecieveBuf_LenPlan:=0;
    ServerRecieveBuf_Len:=0;
    FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);
    //������N���A
//    FillChar(w_Stream_Ack,sizeof(w_Stream_Ack), #0);
    exit;
  end;
  //CB_JUNBI_ERR03 ���s
  if CB_JUNBI_ERR03.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_02;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTNG;
//    proc_S_StatusList('�d����͊J�n���s...' + IntToHex(w_Stream_Ack.commad,0));
    goto p_end;
  end;
  //CB_JUNBI_ERR03 ���s�����s��
  if CB_JUNBI_ERR03_B.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_01;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
//    proc_S_StatusList('�d����͊J�n���s...�����s��' + IntToHex(w_Stream_Ack.commad,0));
    goto p_end;
  end;
  //�Ώ�
  //�R�}���h�A�v���C��N���A
  F_PlanMsg_Len:=0;
  F_RealMsg_Len:=0;
  F_sMsg:='';
  //w_Stream_Ack�쐬
//  w_Stream_Ack.commad:=G_PRTCL_STRM_02;
//  w_Stream_Ack.length:=2;
//  w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
  goto p_end;
  //w_Stream_Ack���M
end;

//03�̏���04
//if G_PRTCL_STRM_03=ServerRecieveBuf.commad  then
begin
  //CB_COMND_ERR02 �^�C���A�E�g
  if CB_COMND_ERR02.Checked then
  begin
    proc_S_StatusList('�d����͊J�n���s...�^�C���A�E�g');
    proc_S_StatusList('�d����͊���...');
    //����d���̂Ȃ���Ԃɂ��ă^�C���A�E�g�ɂ���
    ServerRecieveBuf_LenPlan:=0;
    ServerRecieveBuf_Len:=0;
    FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);
    //������N���A
//    FillChar(w_Stream_Ack,sizeof(w_Stream_Ack), #0);
    exit;
  end;
  //CB_COMND_ERR03 ���s
  if CB_COMND_ERR03.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_04;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTNG;
  //  proc_S_StatusList('�d����͊J�n���s...' + IntToHex(w_Stream_Ack.commad,0));
    goto p_end;
  end;
  //CB_COMND_ERR03 ���s�����s��
  if CB_COMND_ERR03_B.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_03;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
//    proc_S_StatusList('�d����͊J�n���s...�����s��' + IntToHex(w_Stream_Ack.commad,0));
    goto p_end;
  end;

  //�R�}���h��M�̏���

  //w_Stream_Ack�쐬
//  w_Stream_Ack.commad:=G_PRTCL_STRM_04;
//  w_Stream_Ack.length:=2;
//  w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
  goto p_end;
  //w_Stream_Ack���M
end;

//05�̏���06
//if G_PRTCL_STRM_05=ServerRecieveBuf.commad  then
begin
  //CB_DATAL_ERR02 �^�C���A�E�g
  if CB_DATAL_ERR02.Checked then
  begin
    proc_S_StatusList('�d����͊J�n���s...�^�C���A�E�g');
    proc_S_StatusList('�d����͊���...');
    //��M�d���N���A
    //����d���̂Ȃ���Ԃɂ��ă^�C���A�E�g�ɂ���
    ServerRecieveBuf_LenPlan:=0;
    ServerRecieveBuf_Len:=0;
    FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);
    //������N���A
//    FillChar(w_Stream_Ack,sizeof(w_Stream_Ack), #0);
    exit;
  end;
  //CB_DATAL_ERR03 ���s
  if CB_DATAL_ERR03.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_06;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTNG;
//    proc_S_StatusList('�d����͊J�n���s...' + IntToHex(w_Stream_Ack.commad,0) );
    goto p_end;
  end;
  //CB_DATAL_ERR03 ���s�����s��
  if CB_DATAL_ERR03_B.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_05;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
//    proc_S_StatusList('�d����͊J�n���s...�����s��' + IntToHex(w_Stream_Ack.commad,0) );
    goto p_end;
  end;


  //F_PlanMsg_Len �ް����i�[
//  CopyMemory(@w_05,@ServerRecieveBuf,sizeof(w_05));
//  F_PlanMsg_Len := w_05.dlength;
  //F_RealMsg_Len = 0 F_Msg = nil
  F_RealMsg_Len:=0;
  F_sMsg:='';
  //w_Stream_Ack�쐬
//  w_Stream_Ack.commad:=G_PRTCL_STRM_06;
//  w_Stream_Ack.length:=2;
 // w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
  goto p_end;
  //w_Stream_Ack���M
end;

//07�̏���08
//if G_PRTCL_STRM_07=ServerRecieveBuf.commad  then
begin
  //CB_DATA_ERR02 �^�C���A�E�g
  if CB_DATA_ERR02.Checked then
  begin
    proc_S_StatusList('�d����͊J�n���s...�^�C���A�E�g');
    proc_S_StatusList('�d����͊���...');
    //����d���̂Ȃ���Ԃɂ��ă^�C���A�E�g�ɂ���
    ServerRecieveBuf_LenPlan:=0;
    ServerRecieveBuf_Len:=0;
    FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);
    //������N���A
//    FillChar(w_Stream_Ack,sizeof(w_Stream_Ack), #0);
    exit;
  end;
  //CB_DATA_ERR03 ���s
  if CB_DATA_ERR03.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_08;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTNG;
//    proc_S_StatusList('�d����͊J�n���s...' + IntToHex(w_Stream_Ack.commad,0) );
    goto p_end;
  end;
  //CB_DATA_ERR03 ���s�����s��
  if CB_DATA_ERR03_B.Checked then
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_07;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
//    proc_S_StatusList('�d����͊J�n���s...�����s��' + IntToHex(w_Stream_Ack.commad,0) );
    goto p_end;
  end;

  //w_Stream_Ack�쐬 �G���[�����s��v
//  w_DataSize:=ServerRecieveBuf.length;//���M�\��d����
  if (ServerRecieveBuf_Len-4)<>w_DataSize then  //�����M�d���Ɨ\��Ƃ̔�r
  begin
//    w_Stream_Ack.commad:=G_PRTCL_STRM_08;
//    w_Stream_Ack.length:=2;
//    w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTNG;
//    proc_S_StatusList('�d����͊J�n���s...�����s��v' + IntToHex(w_Stream_Ack.commad,0));
    goto p_end;
  end;
try
  //�������b�Z�[�W�̓ǂݎ��~�ϐݒ�
  //F_PlanMsg_Len > F_RealMsg_Len : �i�[ F_Msg F_RealMsg_Len
  if F_PlanMsg_Len > F_RealMsg_Len then
  begin
    //�������b�Z�[�W�̓ǂݎ��~��
//    w_s:=ServerRecieveBuf.data;
//    SetLength(w_s,ServerRecieveBuf.length);
    F_sMsg := F_sMsg + w_s;
//    F_RealMsg_Len:= F_RealMsg_Len+ServerRecieveBuf.length;
  end;
  //F_PlanMsg_Len = F_RealMsg_Len : F_Msg ���� REdt_RcvCmdData / REdt_RcvAppData
  if F_PlanMsg_Len  <= F_RealMsg_Len then
  begin
    //�i�[�O�ɕ������ϊ��̕K�v�ȏꍇ�͕ϊ�����
    if g_RIG_CHARCODE_JIS=gi_Rig_CharCode then
    begin
      F_sMsg:=func_SJisToJis(F_sMsg);
    end;

    //F_sMsg�̃��b�Z�[�W���i�[����
    if G_MSGKIND_IRAI = w_MsgKind_Flag then
    begin
      //
      //��Mү���ނ��G�~�����[�^�ɕ\��
      REdt_RcvAppData.Lines.BeginUpdate;
      if  func_IsNullStr(F_sMsg) then
      begin
       REdt_RcvAppData.Lines.Add('*��*');
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
      //�w��ϊ��G���A������΂����Ɋi�[����
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

      //��Mү���ނ��G�~�����[�^�ɕ\��
      REdt_RcvCmdData.Lines.BeginUpdate;
      if  func_IsNullStr(F_sMsg) then
      begin
       REdt_RcvCmdData.Lines.Add('*��*');
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
      //�w��ϊ��G���A������΂����Ɋi�[����
      if w_RcvCmdArea<>nil then
      begin
        w_RcvCmdArea.Clear;
        w_RcvCmdArea.Text := F_sMsg;
        //w_RcvCmdArea.Add(F_sMsg);
      end;
      w_MsgKind_Flag:=G_MSGKIND_NONE;
    end;

  end;
  //w_Stream_Ack�쐬 �G���[except
except
  //LOG�o��
//  w_Stream_Ack.commad:=G_PRTCL_STRM_08;
//  w_Stream_Ack.length:=2;
//  w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTNG;
//  proc_S_StatusList('�d����͊J�n���s...' + IntToHex(w_Stream_Ack.commad,0));
  exit;
end;
  //w_Stream_Ack�쐬 ����
//  w_Stream_Ack.commad:=G_PRTCL_STRM_08;
//  w_Stream_Ack.length:=2;
//  w_Stream_Ack.ResPns:=G_PRTCL_STRM_RTOK;
  goto p_end;
  //w_Stream_Ack���M
end;

  proc_S_StatusList('�d����͊���...�����Y���Ȃ�');
//  ServerRecieveBuf_Len:=0;
//  FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);
exit;


p_end:
  proc_S_StatusList('�d����͊���...');
//  ServerRecieveBuf_Len:=0;
//  FillChar(ServerRecieveBuf,sizeof(ServerRecieveBuf), #0);

end;

//��P�ʓd���̉�͂ƑΏ�
procedure TFrm_TcpEmu.proc_SendAckStream(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_S_StatusList('�����d�����M�J�n...');
//  if w_Stream_Ack.commad=0 then
  begin
    proc_S_StatusList('�����d�����M����...�����d���Ȃ�');
    exit;
  end;
//  Socket.SendBuf(w_Stream_Ack,sizeof(w_Stream_Ack));
//  proc_S_StatusList('�����d�����M...< '+ IntToHex(w_Stream_Ack.commad,0) +' > ');
end;

//�X�e�[�^�X�\��
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
  //LOG�ɂ��o�͂���B
    proc_LogOperate('�T�[�o�����i' + arg_string + '�j');
  except
    exit;
  end;
end;

//=============================================================================
//�T�[�o�\�P�b�g��������������������������������������������������������������������
//=============================================================================

//======================�C�x���g�ȊO��PUBLIC����===============================

//=============================================================================
//�����^�I����������������������������������������������������������������������
//=============================================================================
(**
 -------------------------------------------------------------------
 * @outline   proc_SetInitialInfo �C�j�V��������ݒ肷��
 * @param �Ȃ�
 * �C�j�V��������ݒ肷��B
 *
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmu.proc_SetInitialInfo;
begin
    { ���������ݒ�
    INI�t�@�C���̏�����ʂƓ����ɐݒ肷��B
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
 * @param �Ȃ�
 * �t�H�[���쐬�ȊO�̃T�[�o�������ȂǒʐM�ɕK�v�ȏ���������
 *
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmu.proc_Start;
begin
  ServerSocket1.Close;
  //���S�ɏI���������܂ő҂�
  while ServerSocket1.Active  do
  begin
     proc_delay(1000);
  end;
  // �T�[�o�[���J�n
  ServerSocket1.Port:=StrToInt(Edt_RISPort.Text);
  ServerSocket1.Open ;
  //���S�ɏ����������܂ő҂�
  while not(ServerSocket1.Socket.Connected)  do
  begin
     proc_delay(1000);
  end;

  lbl_show_status.Caption := '�T�[�o�@�\������';
  lbl_show_status.Font.Color:=clRed;
end;
(**
 -------------------------------------------------------------------
 * @outline  proc_End
 * @param �Ȃ�
 * �T�[�o�I�����ȂǒʐM�ɕK�v�ȏI��������
 *
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmu.proc_End;
begin
  ServerSocket1.close;
  //���S�ɏI���������܂ő҂�
  while ServerSocket1.Socket.Connected  do
  begin
     proc_delay(1000);
  end;
  lbl_show_status.Caption := '�T�[�o�@�\ ��������';
  lbl_show_status.Font.Color:=clWindowText;

end;
//=============================================================================
//�����^�I����������������������������������������������������������������������
//=============================================================================
//=============================================================================
//���̑����J���\�b�h������������������������������������������������������������
//=============================================================================
(**
 -------------------------------------------------------------------
 * @outline  proc_SetSSockInfo
 * @param arg_port:string; �|�[�g
 * ��O����
 * ��M���̃|�[�g�����Z�b�g����B
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
 * ��O����
 * ���M���IP���ڽ���߰ď����Z�b�g����Bfunc_SendMsg�̑O�ɍs���ƗL���ɂȂ�
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
 * @param arg_Msg:TStringList;     ����ނ܂��ͱ��ײ������
 * @param arg_MsgKind:string;      ����ނ܂��ͱ��ײ�̎��
 *                                 G_MSGKIND_CMD  �F�����
 *                                 G_MSGKIND_APPLY�F���ײ
 * @param arg_Apply: TStringList;  ����ނ̌��ʱ��ײ��M�� OR Nil�i����J�j
 * @param arg_Socket:TCustomWinSocket   ���M�Ɏg�p����\�P�b�g
 *                                 nil:�G�~�����[�^�ɗL��f�t�H���g
 * @return         ��O�Ȃ�  �װ����
  �װ����(4�� XXYY
              XX�F�����ʒu01�`07
              00�F����
              01�F�����m�F
              02�F�����m�F�����i���g�p�j
              03�F�R�}���h���M
              04�F�R�}���hACK �i���g�p�j
              05�F�f�[�^�����M
              06�F�f�[�^��ACK �i���g�p�j
              07�F�f�[�^���M
              08�F�f�[�^ACK   �i���g�p�j
              YY�F�ڍ�
              00�F�����^����
              01�F���M���s
              02�F������
              03�F�ԓ����s�^����
              )
 * �@�\ : ����ޱ��ײ���M�@�\
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
//�����̃`�F�b�N
//���b�Z�[�W
  if nil=arg_Msg then
  begin //0�o�C�g�Ƃ��Ĉ���
    result:=G_TCPSND_PRTCL_OK;
    proc_C_StatusList('Complete...func_SendMsg:Nop'+result);
  end;
//���b�Z�[�W���
  if (G_MSGKIND_IRAI<>arg_MsgKind)
     and
     (G_MSGKIND_IRAI<>arg_MsgKind)
     and
     (G_MSGKIND_IRAI<>arg_MsgKind)
  then
  begin
    arg_MsgKind:=G_MSGKIND_IRAI;
  end;
//�\�P�b�g�̃`�F�b�N
  if nil = arg_Socket then
  begin
    ClientSocket1.Address:= Edt_SrvIp.Text;
    ClientSocket1.Port:=StrToInt(Edt_SrvPort1.text);
    arg_Socket:=ClientSocket1;
  end;
  //�G���[��ݒ�
  try
    //���b�Z�[�W��ʃt���O�ݒ�
    w_MsgKind_Flag:=arg_MsgKind;
    //���ײ��̎w��
    w_RcvApplyArea:=arg_Apply;
    //�\�P�b�g�̵����

    if  (arg_Socket.Active) then
    begin
      arg_Socket.Close;
    end;
    arg_Socket.Open;
    //���S�ɏ����������܂ő҂�
    while not(arg_Socket.Socket.Connected) do
    begin
       proc_delay(1000);
    end;
    try
      //�v���g�R�����M�@�\  arg_Msg   arg_Socket
      w_RtCode:=func_SendPrtcl(arg_Msg,arg_Socket);

      //�\�P�b�g�̃N���[�Y
    finally
      arg_Socket.Close;
      Application.ProcessMessages;
      //���S�ɏI���������܂ő҂�
      repeat
        proc_delay(1000);
      until not(arg_Socket.Socket.Connected);
    end;
    result:=w_RtCode;
    proc_C_StatusList('Complete...func_SendMsg:'+result);
    exit;
//�@<<----
  except
    //���b�Z�[�W��ʃt���O�ݒ�
    w_MsgKind_Flag:=G_MSGKIND_NONE;
    result:=G_TCPSND_PRTCL01+G_TCPSND_PRTCL_ERR01;
    proc_C_StatusList('Error...func_SendMsg:(��O�ʐM��ُ�)'+result);
    exit;
//�A<<----
  end;

end;
{
-----------------------------------------------------------------------------
  ���O : func_SendPrtcl;
  ���� :
       arg_Msg: TStringList;         ����ނ܂��ͱ��ײ������
       arg_Socket:TCustomWinSocket   ���M�Ɏg�p����\�P�b�g
  �@�\ : �v���g�R�����M�@�\
  ���A�l�F��O�Ȃ�
  �װ����(4�� XXYY
              XX�F�����ʒu01�`07
              00�F����
              01�F�����m�F
              02�F�����m�F�����i���g�p�j
              03�F�R�}���h���M
              04�F�R�}���hACK �i���g�p�j
              05�F�f�[�^�����M
              06�F�f�[�^��ACK �i���g�p�j
              07�F�f�[�^���M
              08�F�f�[�^ACK   �i���g�p�j
              YY�F�ڍ�
              00�F�����^����
              01�F���M���s
              02�F������
              03�F�ԓ����s�^����
              )
-----------------------------------------------------------------------------
}
function TFrm_TcpEmu.func_SendPrtcl(
                    arg_Msg: TStringList;
                    arg_Socket:TClientSocket
                    ): string;
var
  w_RtCode    : string;       //���A�R�[�h
  w_StreamBase:TStringStream; //����ނ܂��ͱ��ײ ���d��
  w_StreamData:TStringStream; //����ނ܂��ͱ��ײ���M�����d��
  w_Pos       :Longint;       //����ނ܂��ͱ��ײ�d�� ���M�ʒu
  w_size      :Longint;       //�����d���̃T�C�Y
  w_Recv: TStringList;

begin
  // �@01/03/05/07�菇�܂ł��s���i����ޓd��9 Tstrings�j�𑗐M����
  // �@01�菇
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
//�@<<----
     end;
  // �@03�菇
     w_RtCode:=func_MakeSendStream(
                        arg_Socket,
                        G_TCPSND_PRTCL03,nil,w_Recv );
     if w_RtCode <> G_TCPSND_PRTCL_OK then
     begin
       w_MsgKind_Flag:=G_MSGKIND_NONE;
       result:=w_RtCode;
       exit;
//�A<<----
     end;

     if arg_Msg<>nil then
     begin
       try
       //���d�����o��
       w_StreamBase := func_TStrListToStrm(arg_Msg);
//       arg_Msg.SaveToFile(G_RunPath + 'testmsg1.txt');

       //SHIFTJIS�ϊ��Ăяo��
         try
           //SJIS�ϊ��Ăяo��
           if g_RIG_CHARCODE_JIS=gi_Rig_CharCode then
           begin
              proc_JisToSJis(w_StreamBase);
           end;

           if w_StreamBase=nil then
           begin //���d�����o�����s
             w_RtCode:=G_TCPSND_PRTCL05+G_TCPSND_PRTCL_ERR01;
             w_MsgKind_Flag:=G_MSGKIND_NONE;
             result:=w_RtCode;
             exit;
//�B<<----
           end;
  // �@05�菇
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
//�C<<----
           end;
  // �@07 ��  G_MAX_STREAM_SIZE�ŕ������đ��M
         //0�o�C�g���M
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
         //�����������݊J�n
             w_StreamBase.Position := 0;
             w_Pos := 0;
             while w_Pos < w_StreamBase.Size do
             begin
             //�����Ǎ��݈�쐬
               w_StreamData := TStringStream.Create('');
               try
                 w_size  :=w_StreamBase.Size - w_Pos;
                 w_size  :=min(w_size, G_MAX_STREAM_SIZE);
                 w_StreamData.WriteString(w_StreamBase.ReadString(w_size));
                 //��������
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
         //��O�̎��G���[���O���o�͂���B
         proc_C_StatusList('Error...func_SendPrtcl:'+result);
         exit;
//�D<<----
       end;
     end else
     begin
       // �@05�菇
       w_RtCode:=func_MakeSendStream(
                        arg_Socket,
                        G_TCPSND_PRTCL05,nil,w_Recv );
       if w_RtCode <> G_TCPSND_PRTCL_OK then
       begin
         w_MsgKind_Flag:=G_MSGKIND_NONE;
         result:=w_RtCode;
         exit;
//�E<<----
       end;
       // �@07 ��  G_MAX_STREAM_SIZE�ŕ������đ��M
       w_RtCode:=func_MakeSendStream(
                                arg_Socket,
                                G_TCPSND_PRTCL07,
                                nil,w_Recv );
       if w_RtCode <> G_TCPSND_PRTCL_OK then
       begin
         w_MsgKind_Flag:=G_MSGKIND_NONE;
         result:=w_RtCode;
         exit;
//�F<<----
       end;
     end;
  result:=G_TCPSND_PRTCL_OK;
  proc_C_StatusList('Complete...func_SendPrtcl:'+result);
  exit;
//�G<<----
end;
{
-----------------------------------------------------------------------------
  ���O : func_MakeSendStream;
  ���� :
    arg_Socket:TCustomWinSocket; ����M�p�\�P�b�g
    arg_Order: string;           �d�����
    arg_Data:TStringStream       �d���f�[�^
  �@�\ : �\�P�b�g�d���̍쐬���M�@�\
  ���A�l�F��O�Ȃ�
  �װ����(4�� XXYY
              XX�F�����ʒu01�`07
              00�F����
              01�F�����m�F
              02�F�����m�F�����i���g�p�j
              03�F�R�}���h���M
              04�F�R�}���hACK �i���g�p�j
              05�F�f�[�^�����M
              06�F�f�[�^��ACK �i���g�p�j
              07�F�f�[�^���M
              08�F�f�[�^ACK   �i���g�p�j
              YY�F�ڍ�
              00�F�����^����
              01�F���M���s
              02�F������
              03�F�ԓ����s�^����
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
  w_RtCode       : string; //�G���[�R�[�h
  w_TStringStream:TStringStream; //���M�f�[�^
  w_RecvStream   :TStringStream;    //��M���M�f�[�^
begin
//��O�������Ȃ�
  try
    w_TStringStream := func_StrListToStream( arg_Order, arg_Data );
  except
     w_RtCode:=G_TCPSND_PRTCL_ERR01;
     result:=arg_Order+w_RtCode;
     proc_C_StatusList('Error...func_MakeSendStream:'+result);
     exit;
//�@<<----
  end;
  if w_TStringStream=nil then
  begin //�d���w�b�_�[�쐬�ł���
     w_RtCode:=G_TCPSND_PRTCL_ERR01;
     result:=arg_Order+w_RtCode;
     exit;
//�A<<----
  end;
  //���M�� �^���G���[��������
  w_RtCode:=func_ToolVErr(arg_Order);
  if w_RtCode = G_TCPSND_PRTCL_ERR00 then
  begin
    //w_TStringStream�͐��펞�\�P�b�g���L�ɂȂ�̂ŉ�����Ȃ�����
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
//�B<<----
  end;
  arg_RecvData := func_StreamToStrList( arg_Order, w_RecvStream );
  if arg_RecvData <> nil then
  begin
     result:=arg_Order+w_RtCode;
     exit;
//�C<<----
  end;

  result:=G_TCPSND_PRTCL_OK;
  proc_C_StatusList('Complete...func_MakeSendStream:' + result);
  exit;
//�D<<----

end;
{
-----------------------------------------------------------------------------
  ���O : func_MakeStream;
  ���� : �Ȃ�
      arg_Order: string;   �菇�R�[�h
      arg_Data:TStringStream �f�[�^������
  �@�\ : �\�P�b�g�d���쐬
  ���A�l�F�\�P�b�g�d�� ��O��������
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
  //�菇�ɂ���ēd����������쐬����B
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

//���A�l�d����ݒ肷��
    result:=w_Stream;
    exit;
//�@<<----
  except
    w_Stream.free;
    raise;
//�A<<----
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
  ���O : func_SendStream;
  ���� : �Ȃ�
   arg_Socket:TCustomWinSocket;  ���M�Ǝ�M�Ɏg�p����\�P�b�g
   arg_SendStream:TStringStream; ���M�f�[�^
   arg_TimeOut: DWORD            �^�C���A�E�g����ms
   arg_RecvStream:TStringStream; ��M�f�[�^
  �@�\ : ���ēd�����M�@�\
  ���A�l�F��O�͔������Ȃ�
      �װ����(2�� YY
              YY�F�ڍ�
              00�F�����^����
              01�F���M���s
              02�F������
              03�F�ԓ����s�^����
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
//��O�͔��������Ȃ�
//�@���M �i����OBJ�j�� �i���ēd��������j�𑗐M����B
{
 �N���C�A���g�u���b�L���O�ڑ��ƃN���C�A���g��u���b�L���O�ڑ�
 �̂����u���b�L���O�ڑ����g���B
}
// �N���C�A���g�u���b�L���O�ڑ�
try
  //�������ݽ�ذт��쐬
  w_SocketStream:=TWinSocketStream.Create(arg_Socket.Socket,arg_TimeOut);
  try
    arg_SendStream.Position:=0;
//    arg_Stream.Read(w_SendStream_Buf, arg_Stream.Size);
    //��������
    proc_C_StatusList('�d�����M�J�n...< ' + ' >');
    res:=w_SocketStream.Write(arg_SendStream, arg_SendStream.Size);
    if (res < arg_SendStream.Size) then //   ���s�F01
    begin
      arg_SendStream.Free;
      result:=G_TCPSND_PRTCL_ERR01;
      proc_C_StatusList('Error...func_SendStream:�i�@�s���S���M�j'+result);
      exit;
//�@<<----
    end;
  finally
    w_SocketStream.Free;
  end;
  proc_C_StatusList('���M�T�C�Y = '+ IntToStr(res) + 'Byte');
  proc_C_StatusList('�d�����M����...');

// �N���C�A���g ��u���b�L���O�ڑ�
{
//arg_Stream�͂����ňُ펞�ɂ͉������
  Rtn:=arg_Socket.Socket.SendStream(arg_Stream);
  if Rtn = False then //   ���s�F01
  begin
    arg_Stream.Free;
    result:=G_TCPSND_PRTCL_ERR01;
    exit;
  end;
}

except
  arg_SendStream.Free;
  result:=G_TCPSND_PRTCL_ERR01;
  proc_C_StatusList('Error...func_SendStream:�i�A���M��O�j'+result);
  exit;
//�A<<----
end;

// �N���C�A���g ��u���b�L���O�ڑ�
//������҂�
{
  w_ClintWaitFlag:=True;
  w_finish:= GetTickCount +  arg_TimeOut;
  repeat
    Application.ProcessMessages
  until  (GetTickCount > w_finish) or (True<>w_ClintWaitFlag);
  if (GetTickCount > w_finish) and (w_ClintWaitFlag) then
  begin  //�^�C���A�E�g
    result:=G_TCPSND_PRTCL_ERR02;
    exit;
  end;
}

//�A������M
//  �X���b�h���쐬�i�ԓ���A�^�C���A�E�g�b��ms�j���ď�L�̕ԓ���҂i�^�C���A�E�g���Ԃ����j
// �N���C�A���g�u���b�L���O�ڑ�
try
  //�Ǎ��݃X�g���[�����쐬
  w_SocketStream:=TWinSocketStream.Create(arg_Socket.Socket,arg_TimeOut);
  try
    //��M�Ǎ��ݏ���
    if False=w_SocketStream.WaitForData(arg_TimeOut) then
    begin  //�^�C���A�E�g
      result:=G_TCPSND_PRTCL_ERR02;
      proc_C_StatusList('Error...func_SendStream:�i�B�^�C���A�E�g�j'+result);
      exit;
//�B<<----
    end else
    begin//�Ǎ���
      res:=w_SocketStream.Read(w_Recv_Buf,sizeof(w_Recv_Buf));
    end;
    if res=0 then //   ����ۂ̓^�C���A�E�g�ƂȂ�
    begin
      result:=G_TCPSND_PRTCL_ERR02;
      proc_C_StatusList('Error...func_SendStream:�i�C��^�C���A�E�g�j'+result);
      exit;
//�C<<----
    end;
    proc_C_StatusList('�����d����M...< '+ IntToStr(res) + ' >Byte');
  finally
    w_SocketStream.Free;
  end;

// �N���C�A���g ��u���b�L���O�ڑ�
{
  res:=arg_Socket.Socket.ReceiveBuf(w_Ack_Buf,sizeof(w_Ack_Buf));
  if res=0 then //   ����ہF02
  begin
    result:=G_TCPSND_PRTCL_ERR02;
    exit;
  end;
  if G_PRTCL_STRM_RTOK<>w_Ack_Buf.ResPns then //   0xffff�F03
  begin
    result:=G_TCPSND_PRTCL_ERR03;
    exit;
  end;
}

//�B�I������ ���한�A�̐ݒ�
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
//�E<<----
except
  result:=G_TCPSND_PRTCL_ERR03;
  proc_C_StatusList('Error...func_SendStream:�i�F��M��O�j'+result);
  exit;
//�F<<----
end;

end;
{
-----------------------------------------------------------------------------
  ���O : func_CheckStream;
  ���� :
         arg_Order:string  �菇
  �@�\ : �����G���[�R�[�h
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
  ���O : func_ToolVErr;
  ���� :
         arg_Order:string  �菇
  �@�\ : �����G���[�R�[�h
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
//���̑����J���\�b�h������������������������������������������������������������
//=============================================================================

//======================�C�x���g�ȊO��PRIVATE����==============================

//======================�I�u�W�F�N�g�łȂ��֐���===============================

//=============================================================================
//���J�֐���������������������������������������������������������������
//=============================================================================
{
-----------------------------------------------------------------------------
  ���O : func_TagValue;
  ���� : List  : ��M�f�[�^
        : Value : �^�O
  �@�\ : ��M�d������w��^�O�̒l���擾����B
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
  ���O : func_TcpEmuOpen
  ���� :
         arg_OwnForm:TForm;        �e�t�H�[�� �K�{
         arg_Visible:boolean;      �\�����[�h �K�{
         arg_Enable:boolean;       �Θb���[�h �K�{
         arg_RcvCmdArea:TStrigList �R�}���h��M�� �K�{
  �@�\ : �t�H�[���쐬�ȊO�̃T�[�o�������ȂǒʐM�ɕK�v�ȏ���������
  ���A�l�F�G�~�����[�^�t�H�[�� Nil���s
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
//�t�H�[���̍쐬
  w_TFrm_TcpEmu:= TFrm_TcpEmu.Create(arg_OwnForm);
  try
    w_TFrm_TcpEmu.Visible := arg_Visible;
    w_TFrm_TcpEmu.Enabled := arg_Enable;
    w_TFrm_TcpEmu.w_RcvCmdArea:=arg_RcvCmdArea;
//����������
   w_TFrm_TcpEmu.proc_Start;
   result:=w_TFrm_TcpEmu;
   exit;
//�@<<----
   except
     w_TFrm_TcpEmu.Close;
     //result:=nil;
     raise;
//�A<<----
   end;
end;
{
-----------------------------------------------------------------------------
  ���O : proc_LogOperate(Operate);
  ���� :
   Operate: string : ������e
  �@�\ : ���O�ɋL�^����B
  ��O�͂��ׂĖ�������̂łȂ�
-----------------------------------------------------------------------------
}
procedure proc_LogOperate(const Operate: string);
var
  Path, PathBak: string;
  buffer: string;
  hd, Size: Integer;
  fp: TextFile;
begin
  // ���O�������̏ꍇ�́A�������Ȃ��B
  if gi_Rig_LogActive=g_RIG_LOGDEACTIVE then Exit;
try
  Path:=gi_Rig_LogPath + G_PKT_PTH_DEF;
  PathBak:=ChangeFileExt(Path, '.bak');
  buffer:=FormatDateTime('yyyy/mm/dd hh:mm:ss', Now)+','+Operate;

  if FileExists(Path) then
  begin
    // ���O�̃T�C�Y���m�F����B
    hd:=FileOpen(Path, fmOpenRead or fmShareDenyWrite);
    Size:=GetFileSize(hd, nil);
    FileClose(hd);
    if Size>StrToIntDef(gi_Rig_LogSize,65536) then
    begin
      // ���T�C�Y�𒴂����ꍇ�́A�o�b�N�A�b�v���Ƃ�B
      if FileExists(PathBak) then DeleteFile(PathBak);
      RenameFile(Path, PathBak);
      AssignFile(fp, Path);
      Rewrite(fp);
      Writeln(fp, buffer);
      CloseFile(fp);
    end
    else
    begin
      // �����̃��O�ɒǋL����B
      AssignFile(fp, Path);
      Append(fp);
      Writeln(fp, buffer);
      CloseFile(fp);
    end;
  end
  else
  begin
    // �V�K�Ƀ��O���쐬����B
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
  ���O : func_TStrListToStrm;
  ���� :
  arg_TStringList:TStringList
  �@�\ : TStringList���X�g���[�����쐬����
  ���A�l�FTStringStream nil���s
-----------------------------------------------------------------------------
}
function func_TStrListToStrm(arg_TStringList:TStringList):TStringStream;
var
// w_i:integer;
 w_TStringStream:TStringStream;
// w_TMemoryStream:TMemoryStream;
// w_s:string;
begin
  try // �X�g���[���쐬
    w_TStringStream:=TStringStream.Create('');
//  w_TMemoryStream:=TMemoryStream.Create;
  except
    result:=nil;
    exit;
  end;
  try
//TStringList��TStringStream�ɓW�J
//    arg_TStringList.SaveToStream(w_TStringStream);
//TMemoryStream���g������
//    arg_TStringList.SaveToStream(w_TMemoryStream); ���\�ɈႢ�Ȃ�
      w_TStringStream.WriteString(arg_TStringList.Text);
//�ꃉ�C�����ǂݍ��� �x��
//    for w_i:=0 to  arg_TStringList.Count-1 do
//    begin
//      w_TStringStream.WriteString(arg_TStringList[w_i] + #13#10 );
//    end;
  except
    w_TStringStream.Free;
    result:=nil;
    exit;
//�@<<----
  end;
  result:=w_TStringStream;
//�@<<----
end;


///// JIS�R�[�h��SJIS�R�[�h�ɕϊ� - 1����
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
///// SJIS�R�[�h��JIS�R�[�h�ɕϊ� - 1����
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


// JIS�R�[�h��SJIS�R�[�h�ɕϊ� - ������
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
///// SJIS�R�[�h��JIS�R�[�h�ɕϊ�
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
        Result := Result + #27 + '$B'; //Kanji IN �ǉ�
      end;
      Result := Result + Sjis_Jis(s[i],s[i+1]);
      inc(i);
    end else
    begin
      if flg then
      begin
        flg    := false;
        Result := Result + #27 + '(B'; //Kanji OUT �ǉ�
      end;
      Result := Result + s[i];
    end;
    inc(i);
  end;
  if flg then Result := Result + #27 + '(B'; //�Ō��Ascii�ɂ���
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
///// SJIS�R�[�h��JIS�R�[�h�ɕϊ� - 1����
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
//���J�֐�����������������������������������������������������������������
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
