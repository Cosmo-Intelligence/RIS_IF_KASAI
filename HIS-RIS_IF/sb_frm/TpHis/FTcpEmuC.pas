unit FTcpEmuC;
interface //*****************************************************************
(**
���@�\����
���J�@�\
���ׂĂ̋@�\�́A�t�H�[�����쐬���鏉����������I��������ł̂݋@�\����
���G�~�����[�^�������@�\(�֐�)
-----------------------------------------------------------------------------
  ���O : func_TcpEmuCOpen
  ���� :
         arg_OwnForm:TForm;        �e�t�H�[�� �K�{
         arg_Visible:boolean;      �\�����[�h �K�{
                    g_Rig_EmuVisible=g_RIG_EMUVISIBLE_FALSE FALSE  �ʏ�
                    g_Rig_EmuVisible=g_RIG_EMUVISIBLE_TRUE  TRUE
         arg_Enable:boolean;       �Θb���[�h �K�{
                    g_Rig_EmuVisible=g_RIG_EMUENABLED_FALSE FALSE  �ʏ�
                    g_Rig_EmuVisible=g_RIG_EMUENABLED_TRUE  TRUE
         arg_ServerIP:Strig;       �R�}���h��M�� �K�{
         arg_ServerPort:Strig      �R�}���h��M�� �K�{
  �@�\ :
   �t�H�[���쐬�ƒʐM�ɕK�v�ȏ���������
  ���A�l�F
   �G�~�����[�^�t�H�[�� Nil���s ��O�L��
-----------------------------------------------------------------------------

�����M����ݒ�@�\�iTFrm_TcpEmuC�̃��\�b�h�j
 -------------------------------------------------------------------
 * @outline  proc_SetCSockInfo
 * @param arg_ip:string;
 * @param arg_port:string;
 * ���M��̏����Z�b�g����Bfunc_SendMsg�̑O�ɍs���ƗL���ɂȂ�
 *
 -------------------------------------------------------------------

���d�����M��M�@�\�iTFrm_TcpEmuC�̃��\�b�h�j
-----------------------------------------------------------------------------
  ���O : func_SendMsg;
  ���� :
   arg_SendStream    : TStringStream;  ���M�f�[�^
   arg_SendStream_Len: Longint;       ���M�f�[�^��
   arg_TimeOut       : DWORD;         �^�C���A�E�g����ms
   arg_MsgKind       : string;        �d�����
   arg_RecvStream: TStringStream   �߂��M�d��

  ���A�l�F��O�Ȃ�  �װ����
  �װ����(4�� XXYY
              XX�F�����ʒu01�`07
              00�F�Œ�
                YY�F�ڍ�
                00�F����
                01�F���M���s
                02�F������
                03�F��M���s
              )
 * �@�\ : �O�����J�ŏ㕔
    1.���M�d�������|�h�ŕ\����ɕ\��
    2.���M/��M�����̈˗�
    3.��M�d�������|�h�ŕ\����ɕ\��
 *
-----------------------------------------------------------------------------

���G�~�����[�^�I�����@�\�iTFrm_TcpEmuC�̃��\�b�h�j
  ���쐬�̃t�H�[�����N���[�Y����B
  .close; ��O�L��


���p���`
�d���F�\�P�b�g��TCPIP�]���d��


������
�V�K�쐬�F2003.05.30�F�S�� ���c

*)

//�g�p���j�b�g---------------------------------------------------------------
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ScktComp, IniFiles, ExtCtrls, Buttons,math, //FileCtrl,
  Gval,
  HisMsgDef,
  HisMsgDef01_IRAI,
  HisMsgDef02_JISSI,
  TcpSocket, FileCtrl
  ;

////�^�N���X�錾-------------------------------------------------------------
// �\���^
//�t�H�[��
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
    { Private �錾 }
    w_TimeOut : Longint; //�d���^�C���A�E�g ����
    w_CharCode: string;  //�����R�[�h���
    w_MsgKind : string;  //���M�d�����
    w_MsgKind2: String;  //��M�d�����
  public
    { Public �錾 }
    w_SendArea : TStringStream;  //���M�d����
    w_RecvArea : TStringStream;  //��M�d����
    w_RtCod   : String;

    procedure proc_SetMsgKind(arg_MsgKind,arg_MsgKind2:string);
    function  func_GetMsgKind:string;
    function  func_GetMsgKind2:string;
    //
    procedure proc_SetCSockInfo(arg_ip:string;arg_port:string);
    //���M��M�@�\
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

//�萔�錾-------------------------------------------------------------------
//const
  //�^�C���A�E�g�ŏ��l
  //G_MINIMUN_TIMEOUT=10; //�P�Oms
//�ϐ��錾-------------------------------------------------------------------
var
  Frm_TcpEmuC: TFrm_TcpEmuC;

//�֐��葱���錾-------------------------------------------------------------
function func_TcpEmuCOpen(
       arg_OwnForm:TComponent;      //�e�t�H�[��
       arg_Visible:String;    //�\�����[�h
       arg_Enable:String;     //�Θb���[�h
       arg_CharCode:String;    //�`���n�����R�[�h
       arg_IP:String;          //����IP
       arg_Por:String;         //����|�[�g
       arg_TimeOut:String;     //���M���^�C���A�E�g
       arg_MsgKind:string;      //���M�d�����1-5
       arg_MsgKind2:string      //��M�d�����1-5
                         ):TFrm_TcpEmuC;
//
function func_TagValue(const List: TStrings; Value: string): string;
//

implementation

//**************************************************************
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
procedure TFrm_TcpEmuC.FormCreate(Sender: TObject);
begin
  //��O�͔��������Ȃ�
  //�ݽ�ݽ�����������è�����N���A
  w_MsgKind  := G_MSGKIND_NONE;
  w_MsgKind2 := G_MSGKIND_NONE;
  //�t�@�C���{�b�N�X�����ݒ�
  FileListBox1.Directory := G_RunPath;
  //�d�����M�̈揉����
  w_SendArea := nil;
  //�d����M�̈揉����
  w_RecvArea := nil;
end;
procedure TFrm_TcpEmuC.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //�̈�͉������
  Action := caFree;
end;
procedure TFrm_TcpEmuC.FormDestroy(Sender: TObject);
begin
  //�d�����M�̈悪�쐬����Ă���ꍇ
  if w_SendArea <> nil then
    //�̈�̊J��
    w_SendArea.Free;
  //�d����M�̈悪�쐬����Ă���ꍇ
  if w_RecvArea <> nil then
    //�̈�̊J��
    w_RecvArea.Free
end;
//[�R�}���h���M]�{�^��
procedure TFrm_TcpEmuC.btn_SendCmdClick(Sender: TObject);
begin
  //�\�P�b�g�̍ŏ�����
  w_RtCod := '';
  //�T�[�oIP�ݒ�
  ClientSocket1.Address := Edt_SrvIp1.Text;
  //�T�[�o�|�[�g�ݒ�
  ClientSocket1.Port := StrToInt(Edt_SrvPort1.Text);
  if w_SendArea <> nil then
  begin
    FreeAndNil(w_SendArea);
    //�d�����M�̈揉����
    w_SendArea := TStringStream.Create('');
  end;
  if w_RecvArea <> nil then
  begin
    FreeAndNil(w_RecvArea);
    //�d�����M�̈揉����
    w_RecvArea := TStringStream.Create('');
  end;
  proc_RB_Click;
  //�d���擾
  proc_TStrListToStrm(TStringList(REdt_SndCmdData.Lines),w_SendArea,
                      G_MSG_SYSTEM_C,w_MsgKind
                      );
  //�d�����M
  w_RtCod := func_SendMsgBase(w_SendArea,w_SendArea.Size,w_TimeOut,
                              func_GetMsgKind,func_GetMsgKind2,w_RecvArea
                              );
  //LOG�ɂ��o�͂���B
  proc_LogOut('  ','',G_LOG_KIND_SK_CL_NUM,w_SendArea.DataString);
  //TStringStream����͂���TStringList���쐬
  proc_TStrmToStrlist(w_RecvArea,TStringList(REdt_RcvMsgData.Lines),
                      G_MSG_SYSTEM_A,w_MsgKind2
                      );
  //��ԕ\���ύX �ؒf
  lbl_CsokStat.Caption := '';
  //��ԕ\���ύX �ؒf
  lbl_CsokStat.Caption := lbl_CsokStat.Caption +' = '+ w_RtCod;
  //�ĕ\��
  lbl_CsokStat.Refresh;
end;
//�v���g�R���^�C���A�E�g�ύX
procedure TFrm_TcpEmuC.Edt_TimeOutChange(Sender: TObject);
begin
  //�^�C���A�E�g���Ԃ�ݒ�
  w_TimeOut := StrToIntDef(Edt_TimeOut.Text,G_MAX_STREAM_SIZE);
end;
//����T�[�oIP�̕ύX
procedure TFrm_TcpEmuC.Edt_SrvIp1Change(Sender: TObject);
begin
  //�T�[�oIP��ݒ�
  ClientSocket1.Address := Edt_SrvIp1.text;
end;
//����T�[�o�|�[�g�̕ύX
procedure TFrm_TcpEmuC.Edt_SrvPort1Change(Sender: TObject);
begin
  //�T�[�o�|�[�g��ݒ�
  ClientSocket1.Port := StrToInt(Edt_SrvPort1.text);
end;
//�ǂݍ��݃{�^��
procedure TFrm_TcpEmuC.btn_CmdReadClick(Sender: TObject);
begin
  //�t�@�C���{�b�N�X�őI������Ă���t�@�C����\��
  REdt_SndCmdData.Lines.LoadFromFile(FileListBox1.FileName);
end;
//�N���A�{�^��
procedure TFrm_TcpEmuC.btn_CmdClearClick(Sender: TObject);
begin
  //���M�\���̈���N���A
  REdt_SndCmdData.Clear;
end;
//�ۑ��{�^��
procedure TFrm_TcpEmuC.btn_CmdSaveClick(Sender: TObject);
begin
  //�t�@�C���{�b�N�X�őI�����ꂽ�ꏊ�Ɏw��̃t�@�C�����ő��M�̈�̃f�[�^��ۑ�����
  REdt_SndCmdData.Lines.SaveToFile(IncludeTrailingPathDelimiter(FileListBox1.Directory) + Edit1.Text);
end;
//SJIS�{�^���H
procedure TFrm_TcpEmuC.btn_Cmd_SjisClick(Sender: TObject);
begin
  REdt_SndCmdData.Lines.BeginUpdate;
  REdt_SndCmdData.Lines.Text := func_MakeSJIS;
  REdt_SndCmdData.Lines.EndUpdate;
end;
//JIS�R�[�h�{�^���H
procedure TFrm_TcpEmuC.btn_Cmd_JisClick(Sender: TObject);
var
  w_s:string;
begin
  REdt_SndCmdData.Lines.BeginUpdate;
  w_s := REdt_SndCmdData.Lines.Text;
  REdt_SndCmdData.Lines.Text := func_SJisToJis(w_s);
  REdt_SndCmdData.Lines.EndUpdate;
end;
//�N���A�{�^��
procedure TFrm_TcpEmuC.btn_RcvClearClick(Sender: TObject);
begin
  //��M�\���̈���N���A
  REdt_RcvMsgData.Clear;
end;
//�ۑ��{�^��
procedure TFrm_TcpEmuC.btn_RcvSaveClick(Sender: TObject);
begin
  //�t�@�C���{�b�N�X�őI�����ꂽ�ꏊ�Ɏw��̃t�@�C�����Ŏ�M�̈�̃f�[�^��ۑ�����
  REdt_RcvMsgData.Lines.SaveToFile(IncludeTrailingPathDelimiter(FileListBox1.Directory) +Edit2.Text);
end;
//SJIS�{�^���H
procedure TFrm_TcpEmuC.btn_Rcv_SjisClick(Sender: TObject);
begin
  REdt_RcvMsgData.Lines.BeginUpdate;
  REdt_RcvMsgData.Lines.Text := func_MakeSJIS;
  REdt_RcvMsgData.Lines.EndUpdate;
end;
//JIS�{�^���H
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
//�t�H�[����������������������������������������������������������������������
//=============================================================================

//=============================================================================
//�N���C�A���g�\�P�b�g������������������������������������������������������������������
//=============================================================================
//�N���C�A���g�\�P�b�g�ڑ��ʒm
procedure TFrm_TcpEmuC.ClientSocket1Connect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //�X�e�[�^�X�̕\�������O�o��
  proc_C_StatusList('OK','Connected to: ' + Socket.RemoteAddress);
  //�ڑ��\��
  lbl_CsokStat.Font.Color := clRed;
  //"�ڑ���"�\��
  lbl_CsokStat.Caption :='�ڑ���';
  //�ĕ\��
  lbl_CsokStat.Refresh;
end;
//�N���C�A���g�\�P�b�g�ؒf�ʒm
procedure TFrm_TcpEmuC.ClientSocket1Disconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //�X�e�[�^�X�̕\�������O�o��
  proc_C_StatusList('OK','DisConnected to: ' + Socket.RemoteAddress);
  //�ڑ��\��
  lbl_CsokStat.Font.Color := clWindowText;
  //"�ؒf"�\��
  lbl_CsokStat.Caption   := '�ؒf' ;
  //�ĕ\��
  lbl_CsokStat.Refresh;
end;
//�N���C�A���g�\�P�b�g�G���[�ʒm
procedure TFrm_TcpEmuC.ClientSocket1Error(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  //�X�e�[�^�X�̕\�������O�o��
  proc_C_StatusList('NG','Error...'+IntToStr(ErrorCode));
  //��O�͔��������Ȃ�
  ErrorCode := 0;
end;
//�N���C�A���g�\�P�b�g������M�ʒm
procedure TFrm_TcpEmuC.ClientSocket1Read(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//��u���b�L���O�̏���
end;
procedure TFrm_TcpEmuC.ClientSocket1Write(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//
end;
//�X�e�[�^�X�\��
procedure TFrm_TcpEmuC.proc_C_StatusList(arg_Status: string;arg_string: string);
begin
  try
    //�\������Ă��Ďg�p�\�̏ꍇ
    if (self.visible) and (self.Enabled) then begin
      //�ύX�̎n�܂�
      REdt_CStatus.Lines.BeginUpdate;
      //�X�e�[�^�X�\���̈�ɃX�e�[�^�X�\��
      REdt_CStatus.Lines.Add(arg_string);
      //�ύX�̏I���
      REdt_CStatus.Lines.EndUpdate;
      //�ĕ\��
      REdt_CStatus.Refresh;
    end;
    //LOG�ɂ��o�͂���B
    proc_LogOut(arg_Status,'',G_LOG_KIND_SK_CL_NUM,arg_string);
  except
    Exit;
  end;
end;
//=============================================================================
//�N���C�A���g�\�P�b�g��������������������������������������������������������������������
//=============================================================================

//======================�C�x���g�ȊO��PUBLIC����===============================
//=============================================================================
//�����^�I����������������������������������������������������������������������
//=============================================================================
//=============================================================================
//�����^�I����������������������������������������������������������������������
//=============================================================================

//=============================================================================
//���̑����J���\�b�h������������������������������������������������������������
//=============================================================================
(**
 -------------------------------------------------------------------
 * @outline  proc_SetMsgKind
 * @param    arg_MsgKind:string;
 * ��O����
 * ���M�d���̎�ʂ�ݒ肵�\������
 * �����܂Ŏ�ʂ�\������̂�
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmuC.proc_SetMsgKind(arg_MsgKind,arg_MsgKind2:string);
begin
   //���I���̏�Ԃɂ���
   RB_C1_1.Checked := False;
   //�w����ʂ�I������
   //�˗����d���̏ꍇ
   if arg_MsgKind = G_MSGKIND_IRAI then begin
     //�˗��`�F�b�N
     RB_C1_1.Checked := True;
   end;
   //���ғd���̏ꍇ
   if arg_MsgKind = G_MSGKIND_KANJA then begin
     //���҃`�F�b�N
     RB_C1_2.Checked := True;
   end;
   //�I�[�_�L�����Z���d���̏ꍇ
   if arg_MsgKind = G_MSGKIND_CANCEL then begin
     //�I�[�_�L�����Z���`�F�b�N
     RB_C1_3.Checked := True;
   end;
   //�ڑ��E�ؒf�d���̏ꍇ
   if arg_MsgKind = G_MSGKIND_START then begin
     //�ڑ��E�ؒf�`�F�b�N
     RB_C1_S.Checked := True;
   end;

   //��ʐݒ�
   w_MsgKind := arg_MsgKind;
   //���I���̏�Ԃɂ���
   RB_C1_6.Checked  := False;
   //�w����ʂ�I������
   //�˗����d���̏ꍇ
   if arg_MsgKind = G_MSGKIND_IRAI then begin
     //�����`�F�b�N
     RB_C1_6.Checked := True;
   end;
   //���ғd���̏ꍇ
   if arg_MsgKind = G_MSGKIND_KANJA then begin
     //�����`�F�b�N
     RB_C1_6.Checked := True;
   end;
   //�I�[�_�L�����Z���d���̏ꍇ
   if arg_MsgKind = G_MSGKIND_CANCEL then begin
     //�����`�F�b�N
     RB_C1_6.Checked := True;
   end;
   //��t�d���̏ꍇ
   if arg_MsgKind = G_MSGKIND_UKETUKE then begin
     //�����`�F�b�N
     RB_C1_6.Checked := True;
   end;
   //���{�d���̏ꍇ
   if arg_MsgKind = G_MSGKIND_JISSI then begin
     //�����`�F�b�N
     RB_C1_6.Checked := True;
   end;
   //�đ��d���̏ꍇ
   if arg_MsgKind = G_MSGKIND_RESEND then begin
     //�����`�F�b�N
     RB_C1_6.Checked := True;
   end;
   //�ڑ��E�ؒf�d���̏ꍇ
   if arg_MsgKind = G_MSGKIND_START then begin
     //�ڑ��E�ؒf�`�F�b�N
     RB_C1_6.Checked := True;
   end;
   //��ʐݒ�
   w_MsgKind2 := arg_MsgKind2;
end;
(**
 -------------------------------------------------------------------
 * @outline  func_GetMsgKind
 * @param    arg_MsgKind:string;
 * ��O����
 * ����ʂ̑��M�d���̎�ʂ��擾����
 -------------------------------------------------------------------
 *)
function TFrm_TcpEmuC.func_GetMsgKind:string;
begin
  //���I���̏�Ԃɂ���
  Result := G_MSGKIND_NONE;
  //�w����ʂ�I������
  //�˗����`�F�b�N����Ă���ꍇ
  if RB_C1_1.Checked then begin
    //�d����ʐݒ�
    Result := G_MSGKIND_IRAI;
  end;
  //���҂��`�F�b�N����Ă���ꍇ
  if RB_C1_2.Checked then begin
    //�d����ʐݒ�
    Result := G_MSGKIND_KANJA;
  end;
  //�I�[�_�L�����Z�����`�F�b�N����Ă���ꍇ
  if RB_C1_3.Checked then begin
    //�d����ʐݒ�
    Result := G_MSGKIND_CANCEL;
  end;
  //�ڑ��E�ؒf���`�F�b�N����Ă���ꍇ
  if RB_C1_S.Checked then begin
    //�d����ʐݒ�
    Result := G_MSGKIND_START;
  end;
end;
(**
 -------------------------------------------------------------------
 * @outline  func_GetMsgKind2
 * @param    arg_MsgKind:string;
 * ��O����
 * ����ʂ̎�M�d���̎�ʂ��擾����
 -------------------------------------------------------------------
 *)
function TFrm_TcpEmuC.func_GetMsgKind2:string;
begin
  //���I���̏�Ԃɂ���
  Result := G_MSGKIND_NONE;
  //�w����ʂ�I������
  //�˗����`�F�b�N����Ă���ꍇ
  if RB_C1_6.Checked then begin
    //�d����ʐݒ�
    Result := G_MSGKIND_START;
  end;
end;
(**
 -------------------------------------------------------------------
 * @outline  proc_SetCSockInfo
 * @param arg_ip:string;
 * @param arg_port:string;
 * ��O����
 * ���M���IP���ڽ���߰ď����Z�b�g����Bfunc_SendMsgBase�̑O�ɍs���ƗL���ɂȂ�
 *
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmuC.proc_SetCSockInfo(arg_ip:string;arg_port:string);
begin
  //�T�[�oIP�ݒ�
  Edt_SrvIp1.text   := arg_ip;
  //�T�[�o�|�[�g�ݒ�
  Edt_SrvPort1.text := arg_port;
end;
{
-----------------------------------------------------------------------------
  ���O : func_SendStream;
  ���� : �Ȃ�
   arg_SendStream:TStringStream; ���M�f�[�^
   arg_SendStream_Len: Longint;  ���M�f�[�^��
   arg_TimeOut   : DWORD         �^�C���A�E�g����ms
   arg_MsgKind   : string;       �d�����
   arg_RecvStream: TStringStream �߂��M�d��
  �@�\ : ���ēd�����M�@�\
  ���A�l�F��O�͔������Ȃ�
      �װ����(2�� YY
              YY�F�ڍ�
              00�F����
              01�F���M���s
              02�F������
              03�F��M���s
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
//��O�͔��������Ȃ�
//�@���M �i����OBJ�j�� �i���ēd��������j�𑗐M����B
{
 �N���C�A���g�u���b�L���O�ڑ��ƃN���C�A���g��u���b�L���O�ڑ�
 �̂����u���b�L���O�ڑ����g���B
}
  // �N���C�A���g�u���b�L���O�ڑ�
  try
    //�������ݽ�ذт��쐬
    w_SocketStream := TWinSocketStream.Create(ClientSocket1.Socket, arg_TimeOut);
    try
      arg_SendStream.Position := 0;
      arg_SendStream.Read(w_SendStream_Buf, arg_SendStream_Len);
      //��������
      proc_C_StatusList(G_LOG_LINE_HEAD_NP,'�d�����M�J�n...< ' + ' >');
      res := w_SocketStream.Write(w_SendStream_Buf, arg_SendStream_Len);
      //���s�F01
      if (res < arg_SendStream_Len) then
      begin
        Result := G_TCPSND_PRTCL_ERR01;
        proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                    'Error...func_SendStream:�i�@�s���S���M�j' + Result);
        Exit;
  //�@<<----
      end;
    finally
      FreeAndNil(w_SocketStream);
    end;
    proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_DEBUG_NUM,
                '���M�d�� = ' + arg_SendStream.DataString);
    proc_C_StatusList(G_LOG_LINE_HEAD_NP, '���M�T�C�Y = ' + IntToStr(res) +
                      'Byte');
    proc_C_StatusList(G_LOG_LINE_HEAD_NP, '�d�����M����...');
  except
    on E: Exception do
    begin
      Result := G_TCPSND_PRTCL_ERR01;

      proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                  'Error...func_SendStream:�i�A���M��O' + E.Message + '�j' + Result);
      Exit;
    end;
  //�A<<----
  end;
  //�A������M
  //  �X���b�h���쐬�i�ԓ���A�^�C���A�E�g�b��ms�j���ď�L�̕ԓ���҂i�^�C���A�E�g���Ԃ����j
  // �N���C�A���g�u���b�L���O�ڑ�
  try
    //�Ǎ��݃X�g���[�����쐬
    w_SocketStream := TWinSocketStream.Create(ClientSocket1.Socket, arg_TimeOut);
    try
      //��M�Ǎ��ݏ���
      if False = w_SocketStream.WaitForData(arg_TimeOut) then
      begin
        //�^�C���A�E�g
        Result := G_TCPSND_PRTCL_ERR02;

        proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                    'Error...func_SendStream:�i�B�^�C���A�E�g�j' + Result);
        Exit;
  //�B<<----
      end
      else
      begin//�Ǎ���
        //�����Ǎ��ݕK�v��
        w_p := 0;
        arg_RecvStream.Position := 0;
        while (w_p < g_Stream_Base[COMMON1DENLENNO + 1].offset) do
        begin
          res := w_SocketStream.Read(w_ReadStream_Buf, sizeof(w_ReadStream_Buf));
          if res=0 then
          begin
            Result := G_TCPSND_PRTCL_ERR02;

            proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                        'Error...func_SendStream:�i�C��^�C���A�E�g�j' + Result);
            Exit;
  //�C<<----
          end;
          arg_RecvStream.Write(w_ReadStream_Buf, res);
          w_p := w_p + res;
        end;
        //�T�C�Y�̂���ŏ��܂œǂ߂�
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
      //��M�d���̒����`�F�b�N
      if w_p {- G_MSGSIZE_START} <> StrToIntDef(w_s, 0) then
      begin
        Result := G_TCPSND_PRTCL_ERR03;
        proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                    'Error...func_SendStream:�i�D��M�d���̒��j' + Result);
        Exit;
  //�D<<----
      end;
      proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_DEBUG_NUM,
                  '��M�d�� = ' + arg_RecvStream.DataString);
      proc_C_StatusList(G_LOG_LINE_HEAD_NP,
                '�����d����M...< ' + IntToStr(arg_RecvStream.Size) + ' >Byte');
    finally
      FreeAndNil(w_SocketStream);
    end;
  //�B�I������ ���한�A�̐ݒ�
    Result := G_TCPSND_PRTCL_ERR00;
    proc_C_StatusList(G_LOG_LINE_HEAD_OK, 'Complete...func_SendStream:' +
                      Result);
    Exit;
  //�E<<----
  except
    on E: Exception do
    begin
      Result := G_TCPSND_PRTCL_ERR03;
      proc_LogOut(G_LOG_LINE_HEAD_NG, '', G_LOG_KIND_NG_NUM,
                  'Error...func_SendStream:�i�F��M��O:' + E.Message +'�j' + Result);
      Exit;
  //�F<<----
    end;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O : func_SendStream2;
  ���� : �Ȃ�
   arg_SendStream:TStringStream; ���M�f�[�^
   arg_SendStream_Len: Longint;  ���M�f�[�^��
   arg_TimeOut   : DWORD         �^�C���A�E�g����ms
   arg_MsgKind   : string;       �d�����
   arg_RecvStream: TStringStream �߂��M�d��
  �@�\ : ���ēd�����M�@�\
  ���A�l�F��O�͔������Ȃ�
      �װ����(2�� YY
              YY�F�ڍ�
              00�F����
              01�F���M���s
              02�F������
              03�F��M���s
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
//��O�͔��������Ȃ�
//�@���M �i����OBJ�j�� �i���ēd��������j�𑗐M����B
{
 �N���C�A���g�u���b�L���O�ڑ��ƃN���C�A���g��u���b�L���O�ڑ�
 �̂����u���b�L���O�ڑ����g���B
}
// �N���C�A���g�u���b�L���O�ڑ�
  try
    //�������ݽ�ذт��쐬
    w_SocketStream := TWinSocketStream.Create(ClientSocket1.Socket,arg_TimeOut);
    try
      //�����ʒu�Ɉړ�
      arg_SendStream.Position := 0;
      //���M�f�[�^�̗̈�ݒ�
      arg_SendStream.Read(w_SendStream_Buf, arg_SendStream_Len);
      //�X�e�[�^�X�̕\�������O�o��
      proc_C_StatusList('  ','�d�����M�J�n...< ' + ' >');
      //���M�f�[�^�̏�������
      res := w_SocketStream.Write(w_SendStream_Buf, arg_SendStream_Len);
      //���M�f�[�^�̏������݂��\���޲ď������߂Ȃ��ꍇ�@���s�F01
      if (res < arg_SendStream_Len) then begin
        //�G���[
        Result := G_TCPSND_PRTCL_ERR01;
        //�X�e�[�^�X�̕\�������O�o��
        proc_C_StatusList('NG','Error...func_SendStream:�i�@�s���S���M�j' + Result);
        //�����I��
        Exit;
  //�@<<----
      end;
    finally
      //�J��
      w_SocketStream.Free;
    end;
    //�X�e�[�^�X�̕\�������O�o��
    proc_C_StatusList('  ','���M�T�C�Y = '+ IntToStr(res) + 'Byte');
    //�X�e�[�^�X�̕\�������O�o��
    proc_C_StatusList('  ','�d�����M����...');
  except
    on E: Exception do begin
      //�G���[
      Result := G_TCPSND_PRTCL_ERR01;
      //�X�e�[�^�X�̕\�������O�o��
      proc_C_StatusList('NG','Error...func_SendStream:�i�A���M��O'+ E.Message +'�j' + Result);
      //�����I��
      Exit;
    end;
  //�A<<----
  end;
//�A������M
//  �X���b�h���쐬�i�ԓ���A�^�C���A�E�g�b��ms�j���ď�L�̕ԓ���҂i�^�C���A�E�g���Ԃ����j
// �N���C�A���g�u���b�L���O�ڑ�
  try
    //�Ǎ��݃X�g���[�����쐬
    w_SocketStream := TWinSocketStream.Create(ClientSocket1.Socket,arg_TimeOut);
    try
      //�ړ����d���ȊO�̏ꍇ
      //if (arg_MsgKind <> G_MSGKIND_IDOU) then begin
        //��M�Ǎ��ݏ���
        //�^�C���A�E�g�`�F�b�N
        if False = w_SocketStream.WaitForData(arg_TimeOut) then begin
          //�G���[
          Result := G_TCPSND_PRTCL_ERR02;
          //�X�e�[�^�X�̕\�������O�o��
          proc_C_StatusList('NG','Error...func_SendStream:�i�B�^�C���A�E�g�j' + Result);
          //�����I��
          Exit;
    //�B<<----
        end
        //�Ǎ���
        else begin
          //�����ʒu�ɐݒ�
          arg_RecvStream.Position := 0;
          //���݂̃|�W�V�����܂œǂݍ���
          res := w_SocketStream.Read(w_ReadStream_Buf,sizeof(w_ReadStream_Buf));
          //��M�̈�ɏ�������
          arg_RecvStream.Write(w_ReadStream_Buf,res);
        end;
        //�X�e�[�^�X�̕\�������O�o��
        proc_C_StatusList('  ','�����d����M...< '+ IntToStr(arg_RecvStream.Size) + ' >Byte');
      //end;
    finally
      //�J��
      w_SocketStream.Free;
    end;
  //�B�I������ ���한�A�̐ݒ�
    Result := G_TCPSND_PRTCL_ERR00;
    //�X�e�[�^�X�̕\�������O�o��
    proc_C_StatusList('OK','Complete...func_SendStream:' + Result);
    //�����I��
    Exit;
  //�E<<----
  except
    on E: Exception do begin
      //�G���[
      Result := G_TCPSND_PRTCL_ERR03;
      //�X�e�[�^�X�̕\�������O�o��
      proc_C_StatusList('NG','Error...func_SendStream:�i�F��M��O:'+ E.Message +'�j' + Result);
      //�����I��
      Exit;
  //�F<<----
    end;
  end;
end;
(**
-----------------------------------------------------------------------------
 * @outline       func_SendMsgBase
   arg_SendStream    : TStringStream;  ���M�f�[�^
   arg_SendStream_Len: Longint;       ���M�f�[�^��
   arg_TimeOut       : DWORD;         �^�C���A�E�g����ms
   arg_MsgKind       : string;        ���M�d�����
   arg_MsgKind2      : string;        ��M�d�����
   arg_RecvStream: TStringStream   �߂��M�d��
                    ): string;
  ���A�l�F��O�Ȃ�  �װ����
  �װ����(4�� XXYY
              XX�F�����ʒu01�`07
              00�F�Œ�
                YY�F�ڍ�
                00�F����
                01�F���M���s
                02�F������
                03�F��M���s
              )
 * �@�\ : ����M�̊�{�֐�
    1.�\�P�b�g�̃I�[�v��
    2.�d�����M�̈˗�
    3.�d����M
    4.�\�P�b�g�̃N���[�Y
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
  //���M��ʂ̎擾
  proc_SetMsgKind(arg_MsgKind,arg_MsgKind2);
  //�ǂ݂Ƃ�p�Ƃ��č쐬
  //���M�̈�ɐݒ�
  w_SendArea := arg_SendStream;
  //��M�̈�ɐݒ�
  w_RecvArea := arg_RecvStream;
  try
    //�\�P�b�g���Ȃ����Ă���ꍇ
    if not (ClientSocket1.Active) then begin
      //�\�P�b�g�̃I�[�v��
      ClientSocket1.Open;
      //���S�ɏ����������܂ő҂�
      while not(ClientSocket1.Socket.Connected) do begin
        //�ҋ@����
        proc_delay(1000);
      end;
    end;

    try
      //�����G���[�`�F�b�N
      w_RtCode := func_ToolVErr;
      //�����G���[�Ȃ��̏ꍇ
      if w_RtCode = G_TCPSND_PRTCL_ERR00 then begin
        //�v���g�R�����M�@�\
        w_RtCode := func_SendStream(arg_SendStream,arg_SendStream_Len,
                                    arg_TimeOut,arg_MsgKind,arg_MsgKind2,arg_RecvStream
                                    );
      end;
    finally
      //�펞�ڑ��̂��ߓ��ɂȂ�
    end;
    //����
    Result := G_TCPSND_PRTCL00 + w_RtCode;
    //�X�e�[�^�X�̕\�������O�o��
    proc_C_StatusList('OK','Complete...func_SendMsgBase:'+Result);
    //�����I��
    Exit;
//�@<<----
  except
    on E: Exception do begin
      //�G���[
      Result := G_TCPSND_PRTCL00 + G_TCPSND_PRTCL_ERR01;
      //�X�e�[�^�X�̕\�������O�o��
      proc_C_StatusList('NG','Error...func_SendMsgBase:(��O�ʐM��ُ�:'+ E.Message +')'+Result);
      //�����I��
      Exit;
    end;
//�A<<----
  end;
end;
(**
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
 * @outline       func_SendMsg
   arg_SendStream    : TStringStream;  ���M�f�[�^
   arg_SendStream_Len: Longint;       ���M�f�[�^��
   arg_TimeOut       : DWORD;         �^�C���A�E�g����ms
   arg_MsgKind       : string;        �d�����
   arg_RecvStream: TStringStream   �߂��M�d��
                    ): string;
  ���A�l�F��O�Ȃ�  �װ����
  �װ����(4�� XXYY
              XX�F�����ʒu01�`07
              00�F�Œ�
                YY�F�ڍ�
                00�F����
                01�F���M���s
                02�F������
                03�F��M���s
              )
 * �@�\ : �O�����J�ŏ㕔
    1.���M�d�������|�h�ŕ\����ɕ\��
    2.���M/��M�����̈˗�
    3.��M�d�������|�h�ŕ\����ɕ\��
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
  //�\������Ă���Ƃ��ɂ͑��M�����\������
  if Self.Visible then begin
    //�ύX�J�n
    REdt_SndCmdData.Lines.BeginUpdate;
    //TStringStream����͂���TStringList���쐬
    proc_TStrmToStrlist(arg_SendStream,
                        TStringList(REdt_SndCmdData.Lines),
                        G_MSG_SYSTEM_C,
                        w_MsgKind
                        );
    //�ύX�I��
    REdt_SndCmdData.Lines.EndUpdate;
  end;
  //����M���˗�����
  Result := func_SendMsgBase(arg_SendStream,arg_SendStream_Len,
                             arg_TimeOut,arg_MsgKind,arg_MsgKind2,arg_RecvStream
                             );
  //�\������Ă���Ƃ��ɂ͎�M�����\������
  if self.Visible then begin
    //�ύX�J�n
    REdt_RcvMsgData.Lines.BeginUpdate;
    //��M���̕\��
    REdt_RcvMsgData.Lines.Add(arg_RecvStream.DataString);
    //TStringStream����͂���TStringList���쐬
    proc_TStrmToStrlist(arg_RecvStream,TStringList(REdt_RcvMsgData.Lines),
                        G_MSG_SYSTEM_A,w_MsgKind2
                        );
    //�ύX�I��
    REdt_RcvMsgData.Lines.EndUpdate;
  end;
end;
{
-----------------------------------------------------------------------------
  ���O : func_ToolVErr;
  ���� : �Ȃ�
  �@�\ : �����G���[�R�[�h
-----------------------------------------------------------------------------
}
function TFrm_TcpEmuC.func_ToolVErr:String;
begin
  //�����l
  Result := G_TCPSND_PRTCL_ERR00;
  //"�f�[�^_���M���s"�`�F�b�N�{�b�N�X���`�F�b�N����Ă���ꍇ
  if CB_DATA_ERR01.Checked then
    //�G���[�ŕԓ�
    Result := G_TCPSND_PRTCL_ERR01;
  //�����I��
  Exit;
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
  n := List.IndexOfName(Value);
  if n < 0 then
    Result := ''
  else
    Result := List.Values[Value];
end;
{
-----------------------------------------------------------------------------
  ���O : func_TcpEmuCOpen
  �@�\ : �t�H�[���쐬�ȂǒʐM�ɕK�v�ȏ���������
  ���A�l�F�G�~�����[�^�t�H�[�� Nil���s
-----------------------------------------------------------------------------
}
function func_TcpEmuCOpen(
       arg_OwnForm:TComponent; //�e�t�H�[��
       arg_Visible:String;     //�\�����[�h
       arg_Enable:String;      //�Θb���[�h
       arg_CharCode:String;    //�`���n�����R�[�h
       arg_IP:String;          //����IP
       arg_Por:String;         //����|�[�g
       arg_TimeOut:String;     //���M���^�C���A�E�g
       arg_MsgKind:string;      //���M�d�����1-5
       arg_MsgKind2:string      //��M�d�����1-5
                         ):TFrm_TcpEmuC;
var
  w_TFrm_TcpEmu :TFrm_TcpEmuC;
begin
  //�t�H�[���̍쐬
  w_TFrm_TcpEmu:= TFrm_TcpEmuC.Create(arg_OwnForm);
  try
    //�\���̉ۃ`�F�b�N
    if arg_Visible = g_SOCKET_EMUVISIBLE_TRUE then
      //�\��
      w_TFrm_TcpEmu.Visible := True
    else
      //��\��
      w_TFrm_TcpEmu.Visible := False;
    //�g�p�̉ۃ`�F�b�N
    if arg_Enable = g_SOCKET_EMUENABLED_TRUE then
      //�g�p��
      w_TFrm_TcpEmu.Enabled := True
    else
      //�g�p�s��
      w_TFrm_TcpEmu.Enabled := False;
    //�R�[�h�̌n�ݒ�
    w_TFrm_TcpEmu.w_CharCode        := arg_CharCode;
    //�T�[�oIP�ݒ�
    w_TFrm_TcpEmu.Edt_SrvIp1.Text   := arg_IP;
    //�T�[�o�|�[�g�ݒ�
    w_TFrm_TcpEmu.Edt_SrvPort1.Text := arg_Por;
    //��ѱ�ĕ\��
    w_TFrm_TcpEmu.Edt_TimeOut.Text  := arg_TimeOut;
    //��ѱ�Đݒ�
    w_TFrm_TcpEmu.w_TimeOut := StrToIntDef(arg_TimeOut,10000);
    //���M��ʐݒ�
    w_TFrm_TcpEmu.proc_SetMsgKind(arg_MsgKind,arg_MsgKind2);
    //�d����M�̈揉����
    w_TFrm_TcpEmu.w_RecvArea := TStringStream.Create('');
    //�d�����M�̈揉����
    w_TFrm_TcpEmu.w_SendArea := TStringStream.Create('');
    //����������
    Result := w_TFrm_TcpEmu;
    //�����I��
    Exit;
//�@<<----
   except
     //�t�H�[���I��
     w_TFrm_TcpEmu.Close;
     raise;
//�A<<----
   end;
end;
//=============================================================================
//���J�֐�����������������������������������������������������������������
//=============================================================================
procedure TFrm_TcpEmuC.Button1Click(Sender: TObject);
begin
  //�ʐM�X�e�[�^�X�N���A
  REdt_CStatus.Clear;
end;

procedure TFrm_TcpEmuC.BitBtn1Click(Sender: TObject);
begin
  //�\�P�b�g�̍ŏ�����
  w_RtCod := '';
  //�T�[�oIP�ݒ�
  ClientSocket1.Address := Edt_SrvIp1.Text;
  //�T�[�o�|�[�g�ݒ�
  ClientSocket1.Port := StrToInt(Edt_SrvPort1.Text);
  if w_SendArea <> nil then begin
    FreeAndNil(w_SendArea);
    //�d�����M�̈揉����
    w_SendArea := TStringStream.Create('');
  end;
  if w_RecvArea <> nil then begin
    FreeAndNil(w_RecvArea);
    //�d�����M�̈揉����
    w_RecvArea := TStringStream.Create('');
  end;
  proc_RB_Click;
  w_SendArea.WriteString(REdt_SndCmdData.Text);
  //�d���擾
  //proc_TStrListToStrm(TStringList(REdt_SndCmdData.Lines),w_SendArea,
  //                    G_MSG_SYSTEM_C,w_MsgKind
  //                    );


  //�d�����M
  w_RtCod := func_SendMsgBase(w_SendArea,w_SendArea.Size,w_TimeOut,
                              func_GetMsgKind,func_GetMsgKind2,w_RecvArea
                              );
  //LOG�ɂ��o�͂���B
  proc_LogOut('  ','',G_LOG_KIND_SK_CL_NUM,w_RecvArea.DataString);
  //TStringStream����͂���TStringList���쐬
  proc_TStrmToStrlist(w_RecvArea,TStringList(REdt_RcvMsgData.Lines),
                      G_MSG_SYSTEM_A,w_MsgKind2
                      );
  //��ԕ\���ύX �ؒf
  lbl_CsokStat.Caption := '';
  //��ԕ\���ύX �ؒf
  lbl_CsokStat.Caption := lbl_CsokStat.Caption +' = '+ w_RtCod;
  //�ĕ\��
  lbl_CsokStat.Refresh;
end;

procedure TFrm_TcpEmuC.proc_RB_Click;
begin
  w_MsgKind := func_GetMsgKind;
  w_MsgKind2 := func_GetMsgKind2;
end;

procedure TFrm_TcpEmuC.Button2Click(Sender: TObject);
begin
  //�\�P�b�g�����
  ClientSocket1.Close;
end;

end.
