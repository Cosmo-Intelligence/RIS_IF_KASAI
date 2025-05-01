unit FTcpEmuS;
interface //*****************************************************************
(**
���@�\����
���J�@�\
���ׂĂ̋@�\�́A�t�H�[�����쐬���鏉����������I��������ł̂݋@�\����
���G�~�����[�^�������@�\(�֐�)
-----------------------------------------------------------------------------
  ���O : func_TcpEmuSOpen
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

����M����ݒ�@�\�iTFrm_TcpEmu�̃��\�b�h�j���g�p�\��
 -------------------------------------------------------------------
 * @outline  proc_SetSSockInfo
 * @param arg_port:string; �|�[�g
 * ��O����
 * ��M���̃|�[�g�����Z�b�g����B
 *
 -------------------------------------------------------------------

���G�~�����[�^�I�����@�\�iTFrm_TcpEmu�̃��\�b�h�j
  �@�쐬�̃t�H�[�����N���[�Y����B
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
//�t�H�[��
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
    { Private �錾 }
    //����t���O
    w_TimeOut : Longint; //�d���^�C���A�E�g ����
    w_CharCode: string;  //�����R�[�h���
    w_MsgKind : string;  //��M�d�����
    w_MsgKind2 : string;  //���M�d�����
    //�T�[�o��M�d����
    ServerRecieveBuf_Len : Longint;      //���d����
    ServerRecieveBuf_LenPlan : Longint;  //�\��d����
    wg_Continue : Boolean;
    ServerRecieveBuf_Len_Work : Longint;      //���d�����i�ꎞ�ޔ��j
    ServerRecieveBuf_LenPlan_Work : Longint;  //�\��d�����i�ꎞ�ޔ��j
    wg_Seq : String;
    wg_MachineName: String;
    wg_MaxDataSize: Integer;
    wg_Keizoku : String;
    //��͌��ʊi�[��
    F_PlanMsg_Len        : Longint;      //�\���M�R�}���h�A�v���C��
    F_RealMsg_Len        : Longint;      //��  ��M�R�}���h�A�v���C��
    F_sMsg               : String;
    w_RecvMsgTime   : TDateTime;  // YYYY/MM/DD hh:mi:ss
    w_RecvMsgTimeS  : String;
    //function func_GetMsgKind2: string;  //�R�}���h�A�v���C�ۑ���

  public
    { Public �錾 }
    w_RecvArea : TStringStream;  //��M�d����
    w_SendArea : TStringStream;  //���M�d����
    wg_StringStream : TStringStream;
    //�T�[�o�@�\����������
    procedure proc_Start;
    //�T�[�o�@�\�I��������
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

//�萔�錾-------------------------------------------------------------------
//const
//  G_PKT_PTH_DEF='RIS_RIG.log'; //LOG�t�@�C��
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
//  G_MINIMUN_TIMEOUT=10; //�P�Oms

//�ϐ��錾-------------------------------------------------------------------
var
  Frm_TcpEmuS: TFrm_TcpEmuS;

//�֐��葱���錾-------------------------------------------------------------
function func_TcpEmuSOpen(
       arg_OwnForm:TForm;      //�e�t�H�[��
       arg_Visible:String;     //�\�����[�h
       arg_Enable:String;      //�Θb���[�h
       arg_CharCode:String;    //�`���n�����R�[�h
       arg_Por:String;         //�|�[�g
       arg_TimeOut:String;     //���M���^�C���A�E�g
       arg_MsgKind:string;     //�d�����1-5
       arg_MsgKind2:string     //�d�����1-5
                         ):TFrm_TcpEmuS;
//
//
function func_TagValue(const List: TStrings; Value: string): string;

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
procedure TFrm_TcpEmuS.FormCreate(Sender: TObject);
begin
  //��O�͔��������Ȃ�
  //�ݽ�ݽ�����������è�����N���A
  //���M�̈揉����
  w_SendArea := nil;
  //��M�̈揉����
  w_RecvArea := nil;
  //�d����ʏ�����
  w_MsgKind := G_MSGKIND_NONE;
  w_MsgKind2 := G_MSGKIND_NONE;
  //�d����M�d�����N���A
  ServerRecieveBuf_Len := 0;
  ServerRecieveBuf_LenPlan := 0;
  //���b�Z�[�W�i�[��N���A
  F_sMsg := '';
  F_PlanMsg_Len := -1;
  F_RealMsg_Len := -1;
  //�t�@�C���f�B���N�g�����N���f�B���N�g����
  FileListBox1.Directory := G_RunPath ;
  // IP�A�h���X���擾�ݒ肷��B
  Edt_RisIp.Text := func_GetThisMachineIPAdrr;
  //���M�̈�N���A
  REdt_RcvAppData1.Lines.Clear;
  REdt_RcvAppData1.Clear;
  //��M�̈�N���A
  REdt_RcvCmdData1.Lines.Clear;
  REdt_RcvCmdData1.Clear;
end;

procedure TFrm_TcpEmuS.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //���b�Z�[�W�i�[����
  F_sMsg := '';
  //�I��������B
  proc_End;
  //�̈�͉������
  Action := caFree;
end;

procedure TFrm_TcpEmuS.FormDestroy(Sender: TObject);
begin
  //���M�̈悪�쐬����Ă���ꍇ
  if w_SendArea <> nil then
    //�J��
    w_SendArea.Free;
  //��M�̈悪�쐬����Ă���ꍇ
  if w_RecvArea <> nil then
    //�J��
    w_RecvArea.Free
end;
//[������]�{�^�� �T�[�o�@�\�������˗�
procedure TFrm_TcpEmuS.btn_InitClick(Sender: TObject);
begin
  //�������˗�
  proc_Start;
end;

//�N���A�{�^��
procedure TFrm_TcpEmuS.Btn_RcvClear1Click(Sender: TObject);
begin
  //��M�\���̈�N���A
  REdt_RcvCmdData1.Clear;
end;
//�N���A�{�^��
procedure TFrm_TcpEmuS.Btn_RcvDClear1Click(Sender: TObject);
begin
  //���M�\���̈�N���A
  REdt_RcvAppData1.Clear;
end;
//�ۑ��{�^��
procedure TFrm_TcpEmuS.btn_SRsave1Click(Sender: TObject);
begin
  //��M�\���̈�̃f�[�^��ۑ�
  REdt_RcvCmdData1.Lines.SaveToFile(IncludeTrailingPathDelimiter(FileListBox1.Directory) +Edit_SvRvSaveFl1.Text);
end;
//�ۑ��{�^��
procedure TFrm_TcpEmuS.btn_SSsave1Click(Sender: TObject);
begin
  //���M�\���̈�̃f�[�^��ۑ�
  REdt_RcvAppData1.Lines.SaveToFile(IncludeTrailingPathDelimiter(FileListBox1.Directory) +Edit_SvSdSaveFl1.Text);
end;
//�T�[�o�@�\��~�{�^��
procedure TFrm_TcpEmuS.btn_finishClick(Sender: TObject);
begin
  //�T�[�o�@�\��~
  proc_End;
end;
//�v���g�R���^�C���A�E�g�ύX
procedure TFrm_TcpEmuS.Edt_TimOutChange(Sender: TObject);
begin
  //�ύX�������Ԃ�ݒ�
  w_TimeOut := StrToIntDef(Edt_TimOut.Text,G_MAX_STREAM_SIZE);
end;
//=============================================================================
//�t�H�[����������������������������������������������������������������������
//=============================================================================
//=============================================================================
//�T�[�o�\�P�b�g������������������������������������������������������������������
//=============================================================================
procedure TFrm_TcpEmuS.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  proc_S_StatusList('OK','�N���C�A���g���ڑ�����܂���...');
  //�d�����M�@�\�̏����� �P�ڑ��P�v���g�R��
  //�d���̃N���A
  ServerRecieveBuf_LenPlan := 0;
  ServerRecieveBuf_Len := 0;
  w_RecvArea.size := 0;
  //������N���A
  w_SendArea.size := 0;

  //���b�Z�[�W�̃N���A
  F_PlanMsg_Len := 0;
  F_RealMsg_Len := 0;
  F_sMsg        := '';
end;

procedure TFrm_TcpEmuS.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //�X�e�[�^�X�\�������O�o��
  proc_S_StatusList('OK','�N���C�A���g���ؒf����܂���...');
end;

procedure TFrm_TcpEmuS.ServerSocket1ClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  //�X�e�[�^�X�\�������O�o��
  proc_S_StatusList('NG','Error...code='+IntTostr(ErrorCode));
  //��O�͔��������Ȃ�
  ErrorCode := 0;
end;
//�d���f�[�^�u���b�N�̎�M
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
  //������
  w_Res := True;
  //�d���͈�P�ʓd������������Ă���̂Œ���
  //�Ώ��Ƃ��Ă�
  //�@��Ԏn�߂ɂ��ׂċ����I�ɓǂݎ���Ă��܂��B�傫�����̓X���b�h��L���Ă��܂�
  //�A�������ČĂ�ň�P�ʓd�����ɉ�͏������Ăяo��(�̗p)
  //1.��M�i�[
  //���݂̗\��d�������O�ȉ��Ȃ�擪��ǂݎ�蒆�Ȃ̂ŗ\��d������ǂݍ���
  //��P�ʓd���Ǎ��ݏI������0�ɂ��邱��
  if ServerRecieveBuf_LenPlan <= 0 then
  begin
    //�\�蒷�܂ł̓Ǎ��݂����݂�
    //�P�o�C�g�܂ł̕����Ǎ��݂ɑΏ�����
    res := Socket.ReceiveBuf(w_TBuffur1,sizeof(w_TBuffur1));
    //�d���T�C�Y�܂ňړ�
    w_RecvArea.Position := w_RecvArea.size;
    //��M�̈�ɏ�������
    w_RecvArea.Write(w_TBuffur1,res);
    //�ǂݍ��܂ꂽ�޲Ē���ݒ�
    ServerRecieveBuf_Len := ServerRecieveBuf_Len + res;
    //�\�蒷�܂ł͓ǂ߂�
    if (ServerRecieveBuf_Len >= g_Stream_Base[COMMON1DENLENNO + 1].offset) then
    begin
      //�X�e�[�^�X�\�������O�o��
      proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_SV_NUM,
                  '�d����M�J�n...<  >');
      //�X�e�[�^�X�\�������O�o��
      proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_SV_NUM,
                  '��M�T�C�Y = ' + IntToStr(ServerRecieveBuf_Len) + 'Byte');
      //�d�����܂ňړ�
      w_RecvArea.Position := g_Stream_Base[COMMON1DENLENNO].offset;
      //�d�������擾
      w_b := w_RecvArea.ReadString(g_Stream_Base[COMMON1DENLENNO].size);
      //�\��d�����擾
      ServerRecieveBuf_LenPlan := StrToInt(w_b);
      //�S���͓ǂ߂Ă��Ȃ��̂ōēǍ��݂�҂�
      if ServerRecieveBuf_LenPlan > ServerRecieveBuf_Len - G_MSGSIZE_START then
      begin
        //�����I��
        Exit;
//�����|�|�ēǍ��ݑ҂��F
      end;
    end
    //�\�蒷�܂ł͓ǂ߂Ȃ������̂ł�����x�ǂޕK�v������
    else
    begin
      //�����ēd������Ă���̂�҂�
      Exit;
//�����|�|�ēǍ��ݑ҂��F
    end;
  end;
//�ēx�r���̓d���ǂݍ���
  if ServerRecieveBuf_LenPlan > ServerRecieveBuf_Len  - G_MSGSIZE_START then
  begin
    //�ēx�ǂޕK�v������
    res := Socket.ReceiveBuf(w_TBuffur1,sizeof(w_TBuffur1));
    //�P�o�C�g�܂ł̕����Ǎ��݂ɑΏ�����
    w_RecvArea.Position := w_RecvArea.size;
    //��M�̈�ɏ�������
    w_RecvArea.Write(w_TBuffur1,res);
    //�ǂݍ��܂ꂽ�޲Ē���ݒ�
    ServerRecieveBuf_Len := ServerRecieveBuf_Len + res;
  end;

  //�܂��r���Ȃ̂�������ׂ�
  if (ServerRecieveBuf_LenPlan > ServerRecieveBuf_Len - G_MSGSIZE_START) then
  begin
    //�X�e�[�^�X�\�������O�o��
    proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_SV_NUM,
                '��M�T�C�Y = ' + IntToStr(ServerRecieveBuf_Len - G_MSGSIZE_START) + 'Byte');
    //�����I��
    Exit;
//�����|�|�ēǍ��ݑ҂��F
  end;


  //�����M�d���Ɨ\��Ƃ̔�r
  if (ServerRecieveBuf_Len - G_MSGSIZE_START) <> ServerRecieveBuf_LenPlan then
  begin
    //���O������쐬
    proc_StrConcat(F_sMsg,'�u�d�����ُ�NG�i�d������' +
                   IntToStr(ServerRecieveBuf_Len - G_MSGSIZE_START) + '�F�d�������ځ�' +
                   IntToStr(ServerRecieveBuf_LenPlan) + '�j�v');
  end
  else
  begin
    wg_StringStream := TStringStream.Create('');
    //w_RecvArea�Ɉ�P�ʓd�����ǂݍ��܂ꂽ�B
    //�X�e�[�^�X�\�������O�o��
    proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_SV_NUM, '��M�T�C�YE = ' +
                IntToStr(Length(w_RecvArea.DataString)) + 'Byte');
    //�X�e�[�^�X�\�������O�o��
    proc_LogOut(G_LOG_LINE_HEAD_NP, '', G_LOG_KIND_SK_SV_NUM,
                '�d����M����...');
  end;
  //�d����͈˗�
  proc_AnalizeStream(Sender,Socket);
  proc_SendAckStream(Sender,Socket);
  //��P�ʓd���N���A�A�����d���͎c�� �����Ǎ��݂̂���
  //��P�ʓd���̎�M�I�����Ӗ�����
  ServerRecieveBuf_LenPlan := 0;
  ServerRecieveBuf_Len := 0;
  wg_MaxDataSize := 0;
  //��M�̈�̏�����
  w_RecvArea.size := 0;
  //���M�̈�̏�����
  w_SendArea.size := 0;
  //��M�d���ꎞ�ޔ�������
  wg_StringStream.size := 0;
  //�p���I��
  wg_Continue := False;
  //���d�����i�ꎞ�ޔ��j������
  ServerRecieveBuf_Len_Work := 0;
  //�\��d�����i�ꎞ�ޔ��j������
  ServerRecieveBuf_LenPlan_Work := 0;
  //�G���[���O�����񏉊���
  F_sMsg := '';
  //�����I��
  Exit;
end;
procedure TFrm_TcpEmuS.ServerSocket1ClientWrite(Sender: TObject;
  Socket: TCustomWinSocket);
begin
//w_RecvArea ��M�����͂��ĉ����𑗐M���邱�Ƃ��˗�����B�i������j
//  proc_SendAckStream(Sender,Socket);

end;
//��P�ʓd���̉�͂ƑΏ�
procedure TFrm_TcpEmuS.proc_AnalizeStream(Sender: TObject;
  Socket: TCustomWinSocket);
var
  w_s:string;
  w_DataSize:Longint;
label p_end;

begin
//in:w_RecvArea  ServerRecieveBuf_Len
//out:w_Stream_Ack���M  F_Msg �� REdt_RcvCmdData / REdt_RcvAppData
//w_RecvArea����̎�M�d�������
//��M�d�����Ȃ����͑������A
//�T�[�o���͎�M�d���ɑ΂��鉞���͏�ɌŒ肳��Ă���B�i�y�A�[�ɂȂ��Ă���j
  //�X�e�[�^�X�\�������O�o��
  proc_S_StatusList('  ','�d����͊J�n...');
  //�d���ǂݍ��݂��Ȃ��ꍇ(�d����-1)
  if ServerRecieveBuf_Len = -1 then begin
    //�X�e�[�^�X�\�������O�o��
    proc_S_StatusList('NG','�d����͊���...�d������-1');
    //�����I��
    Exit;
  end;
  //�d���ǂݍ��݂��Ȃ��ꍇ(�d����0)
  if ServerRecieveBuf_Len = 0 then begin
    //�X�e�[�^�X�\�������O�o��
    proc_S_StatusList('NG','�d����͊���...�d������0');
    //�����I��
    Exit;
  end;
  //�\��d�����܂œǂݍ��߂Ȃ��ꍇ
  if ServerRecieveBuf_Len - G_MSGSIZE_START < ServerRecieveBuf_LenPlan then begin
    //�X�e�[�^�X�\�������O�o��
    proc_S_StatusList('NG','�d����͊���...�d���s���S');
    //�����I��
    Exit;
  end;
  //CB_DATA_ERR02 �^�C���A�E�g
  if CB_DATA_ERR02.Checked then begin
    //�X�e�[�^�X�\�������O�o��
    proc_S_StatusList('NG','�d����͊J�n���s...�^�C���A�E�g');
    //�X�e�[�^�X�\�������O�o��
    proc_S_StatusList('  ','�d����͊���...');
    //����d���̂Ȃ���Ԃɂ��ă^�C���A�E�g�ɂ���
    ServerRecieveBuf_LenPlan := 0;
    ServerRecieveBuf_Len := 0;
    //��M�̈�N���A
    w_RecvArea.size := 0;
    //������N���A
    w_SendArea.Size := 0;
    //�����I��
    Exit;
  end;

  //w_RecvArea�쐬 �G���[�����s��v
  //�d�������ڂɈړ�
  w_RecvArea.Position := g_Stream_Base[COMMON1DENLENNO].offset;
  //�d�������ڕ��ǂݍ���
  w_s := w_RecvArea.ReadString(g_Stream_Base[COMMON1DENLENNO].size);
  //���M�\��d����
  w_DataSize := StrToIntDef(w_s,0);
  //�����M�d���Ɨ\��Ƃ̔�r
  if (ServerRecieveBuf_Len- G_MSGSIZE_START) <> w_DataSize then begin
    //�X�e�[�^�X�\�������O�o��
    proc_S_StatusList('NG','�d����͊J�n���s...�����s��v size:' + w_s);
    //p_end����
    goto p_end;
  end;
//��M�d���̕ۑ� �\��
  try
{
    //�i�[�O�ɕ������ϊ��̕K�v�ȏꍇ�͕ϊ�����
    if g_RIG_CHARCODE_JIS=gi_Rig_CharCode then
    begin
      F_sMsg:=proc_SisToJis(w_SendArea);
    end;
}
    w_MsgKind := func_GetMsgKind;
    w_MsgKind2 := func_GetMsgKind2;
    //��Mү���ނ��G�~�����[�^�ɕ\��
    REdt_RcvCmdData1.Lines.BeginUpdate;
    //�d���̋�`�F�b�N
    if func_IsNullStr(w_RecvArea.DataString) then begin
      //��\��
      REdt_RcvCmdData1.Lines.Add('*��*');
    end
    else begin
      //TStringStream����͂���TStringList���쐬
      proc_TStrmToStrlist(w_RecvArea,TStringList(REdt_RcvCmdData1.Lines),G_MSG_SYSTEM_C,w_MsgKind);
    end;
    //�ύX�I��
    REdt_RcvCmdData1.Lines.EndUpdate;
    //�ĕ\��
    REdt_RcvCmdData1.Refresh;
    //�����ۑ�����̏ꍇ
    if CheckBox1.Checked then
      proc_TxtOut;
    //�X�e�[�^�X�\�������O�o��
    proc_LogOut('  ','',G_LOG_KIND_SK_CL_NUM,w_RecvArea.DataString);
  except
    //�X�e�[�^�X�\�������O�o��
    proc_S_StatusList('NG','�d����͊J�n���s...' );
    //�����I��
    Exit;
  end;
  //��M�d��������Ȃ̂�
  //w_SendArea�ɓd�����쐬����
  if (REdt_RcvAppData1.Lines.Count > 0) and
     (self.Visible)                     and
     (self.Enabled)                     then begin
    //�Θb���쎞�ɂ͓d������ʏ�ɂ���Ή�ʏォ��ݒ肷��
    //�����ԓ��ɑΉ�
    if (Chk_Auto.Checked)               and        //�����ԐM��
       (FileListBox1.Items.Count >  0 ) and        //�L����
       (FileListBox1.ItemIndex   >= 0 ) then begin //�I������Ă���
      //�t�@�C�����X�g�őI������Ă���t�@�C����ǂݍ���
      REdt_RcvAppData1.Lines.LoadFromFile(FileListBox1.FileName);
      //���̃t�@�C��������ꍇ
      if (FileListBox1.ItemIndex < (FileListBox1.Items.Count-1)) then
        //���̃t�@�C����I��
        FileListBox1.ItemIndex := FileListBox1.ItemIndex + 1
      else
        //�ŏ��̃t�@�C����I��
        FileListBox1.ItemIndex := 0;
    end;
    //TStringList����͂���TStringStream���쐬
    proc_TStrListToStrm(TStringList(REdt_RcvAppData1.Lines),w_SendArea,
                        G_MSG_SYSTEM_A,w_MsgKind2);
  end
  else begin
    //��ʏ�ɐݒ肷��
    proc_TStrmToStrlist(w_SendArea,TStringList(REdt_RcvAppData1.Lines),
                        G_MSG_SYSTEM_A,w_MsgKind2
                        );
  end;

  //CB_DATA_ERR03 �ԓ��d���̒����s��v
  if CB_DATA_ERR03.Checked then begin
    //�T�C�Y�ݒ�
    w_SendArea.Size := 100;
    //�X�e�[�^�X�\�������O�o��
    proc_S_StatusList('NG', '�ԓ��d�������s��v...' );
    //p_end����
    goto p_end;
  end;
  //p_end����
  goto p_end;
    //�����I��
    Exit;
  p_end:
    //�X�e�[�^�X�\�������O�o��
    proc_S_StatusList('  ','�d����͊���...');
    //�����I��
    Exit;
end;

//��P�ʓd���̉�͂ƑΏ�
procedure TFrm_TcpEmuS.proc_SendAckStream(Sender: TObject;
  Socket: TCustomWinSocket);
var
  w_Buffer:TBuffur;
  res:integer;
begin
  //�X�e�[�^�X�\�������O�o��
  proc_S_StatusList('  ','�����d�����M�J�n...');
  //���M�d���Ȃ��̏ꍇ
  if w_SendArea.size = 0 then begin
    //�X�e�[�^�X�\�������O�o��
    proc_S_StatusList('  ','�����d�����M����...�����d���Ȃ�');
    //�����I��
    Exit;
  end;
  //�����ʒu�Ɉړ�
  w_SendArea.Position := 0;
  //�f�[�^�̓ǂݏo��
  w_SendArea.Read( w_Buffer,  w_SendArea.size);
  //�d����������
  res := Socket.SendBuf(w_Buffer,w_SendArea.size);
  //�X�e�[�^�X�\�������O�o��
  proc_S_StatusList('  ','�����d�����M...< '+ intToStr(res) +' > ');
end;

//�X�e�[�^�X�\��
procedure TFrm_TcpEmuS.proc_S_StatusList(arg_Status: string;arg_string: string);
begin
  try
    //�\���Ŏg�p�̏ꍇ
    if (self.visible) and (self.Enabled) then begin
      //�ύX�J�n
      REdt_SStatus1.Lines.BeginUpdate;
      //�X�e�[�^�X�ݒ�
      REdt_SStatus1.Lines.Add(arg_string);
      //�ύX�I��
      REdt_SStatus1.Lines.EndUpdate;
      //�ĕ\��
      REdt_SStatus1.Refresh;
    end;
    //�X�e�[�^�X�\�������O�o��
    proc_LogOut( arg_Status,'',G_LOG_KIND_SK_SV_NUM, arg_string );
  except
    //�����I��
    Exit;
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
 * @outline  proc_Start
 * @param �Ȃ�
 * �t�H�[���쐬�ȊO�̃T�[�o�������ȂǒʐM�ɕK�v�ȏ���������
 *
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmuS.proc_Start;
begin
  //�\�P�b�g�����
  ServerSocket1.Close;
  //���S�ɏI���������܂ő҂�
  while ServerSocket1.Active do begin
    //�ҋ@����
    proc_delay(1000);
  end;
  // �T�[�o�[���J�n
  //�|�[�g�̐ݒ�
  ServerSocket1.Port := StrToInt(Edt_RISPort1.Text);
  //�\�P�b�g�J�n
  ServerSocket1.Open;
  //���S�ɏ����������܂ő҂�
  while not(ServerSocket1.Socket.Connected) do begin
    //�ҋ@����
    proc_delay(1000);
  end;
  //�T�[�o�̏�ԕ\��
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
procedure TFrm_TcpEmuS.proc_End;
begin
  ServerSocket1.close;
  //���S�ɏI���������܂ő҂�
  while ServerSocket1.Socket.Connected do begin
    //�ҋ@����
    proc_delay(1000);
  end;
  //�T�[�o�̏�ԕ\��
  lbl_show_status.Caption := '�T�[�o�@�\ ��������';
  lbl_show_status.Font.Color := clWindowText;

end;
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
procedure TFrm_TcpEmuS.proc_SetMsgKind(arg_MsgKind,arg_MsgKind2:string);
begin
   //���I���̏�Ԃɂ���
   RB_S1_2.Checked := False;
   //���I���̏�Ԃɂ���
   RB_S1_4.Checked := False;
   //���I���̏�Ԃɂ���
   RB_S1_9.Checked := False;
   //�w����ʂ�I������
   //��ʂ���t�d���̏ꍇ
   if arg_MsgKind = G_MSGKIND_UKETUKE then begin
     //��t�`�F�b�N
     RB_S1_2.Checked := True;
   end;
   //��ʂ����{�d���̏ꍇ
   if arg_MsgKind = G_MSGKIND_JISSI then begin
     //���{�`�F�b�N
     RB_S1_4.Checked := True;
   end;
   //��ʂ��ڑ��E�ؒf�d���̏ꍇ
   if arg_MsgKind = G_MSGKIND_START then begin
     //�ڑ��E�ؒf�`�F�b�N
     RB_S1_9.Checked := True;
   end;
   //��ʐݒ�
   w_MsgKind := arg_MsgKind;
   //���I���̏�Ԃɂ���
   RB_S1_6.Checked := False;
   //�w����ʂ�I������
   //��ʂ��˗����d���̏ꍇ
   if arg_MsgKind2 = G_MSGKIND_START then begin
     //�˗��`�F�b�N
     RB_S1_6.Checked := True;
   end;
   //��ʂ���t�d���̏ꍇ
   if arg_MsgKind2 = G_MSGKIND_UKETUKE then begin
     //��t�`�F�b�N
     RB_S1_6.Checked := True;
   end;
   //��ʂ���v�d���̏ꍇ
   if arg_MsgKind2 = G_MSGKIND_KAIKEI then begin
     //��v�`�F�b�N
     RB_S1_6.Checked := True;
   end;
   //��ʂ����{�d���̏ꍇ
   if arg_MsgKind2 = G_MSGKIND_JISSI then begin
     //���{�`�F�b�N
     RB_S1_6.Checked := True;
   end;
   //��ʂ��đ��d���̏ꍇ
   if arg_MsgKind2 = G_MSGKIND_RESEND then begin
     //��v�`�F�b�N
     RB_S1_6.Checked := True;
   end;
   //��ʐݒ�
   w_MsgKind2 := arg_MsgKind2;
end;
(**
 -------------------------------------------------------------------
 * @outline  func_GetMsgKind
 * @param    arg_MsgKind:string;
 * ��O����
 * ����ʂ̎�M�d���̎�ʂ��擾����
 -------------------------------------------------------------------
 *)
function TFrm_TcpEmuS.func_GetMsgKind:string;
begin
   //���I���̏�Ԃɂ���
   Result := G_MSGKIND_NONE;
   //�w����ʂ�I������
   //��t���`�F�b�N����Ă���ꍇ
   if RB_S1_2.Checked then begin
     //��t�d��
     Result := G_MSGKIND_UKETUKE;
   end;
   //���{���`�F�b�N����Ă���ꍇ
   if RB_S1_4.Checked then begin
     //���{�d��
     Result := G_MSGKIND_JISSI;
   end;
   //�ڑ��E�ؒf���`�F�b�N����Ă���ꍇ
   if RB_S1_9.Checked then begin
     //�ڑ��E�ؒf�d��
     Result := G_MSGKIND_START;
   end;
end;
(**
 -------------------------------------------------------------------
 * @outline  func_GetMsgKind2
 * @param    arg_MsgKind:string;
 * ��O����
 * ����ʂ̑��M�d���̎�ʂ��擾����
 -------------------------------------------------------------------
 *)
function TFrm_TcpEmuS.func_GetMsgKind2:string;
begin
   //���I���̏�Ԃɂ���
   Result := G_MSGKIND_NONE;
   //�w����ʂ�I������
   //�˗����`�F�b�N����Ă���ꍇ
   if RB_S1_6.Checked then begin
     //�˗����d��
     Result := G_MSGKIND_START;
   end;
end;
(**
 -------------------------------------------------------------------
 * @outline  proc_SetSSockInfo
 * @param arg_port:string; �|�[�g
 * ��O����
 * ��M���̃|�[�g�����Z�b�g����B
 *
 -------------------------------------------------------------------
 *)
procedure TFrm_TcpEmuS.proc_SetSSockInfo(arg_port:string);
begin
  //�T�[�o�@�\��~
  self.proc_End;
  //�|�[�g�̍Đݒ�
  Edt_RISPort1.text := arg_port;
  //�T�[�o�@�\�J�n
  self.proc_Start;
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
function func_TcpEmuSOpen(
       arg_OwnForm:TForm;      //�e�t�H�[��
       arg_Visible:String;     //�\�����[�h
       arg_Enable:String;      //�Θb���[�h
       arg_CharCode:String;    //�`���n�����R�[�h
       arg_Por:String;         //�|�[�g
       arg_TimeOut:String;     //���M���^�C���A�E�g
       arg_MsgKind:string;     //�d�����1-5
       arg_MsgKind2:string     //�d�����1-5
                         ):TFrm_TcpEmuS;
var
  w_TFrm_TcpEmu :TFrm_TcpEmuS;
begin
//�t�H�[���̍쐬
  w_TFrm_TcpEmu := TFrm_TcpEmuS.Create(arg_OwnForm);
  try
    //�\���\�ȏꍇ
    if arg_Visible = g_SOCKET_EMUVISIBLE_TRUE then
      //�\����
      w_TFrm_TcpEmu.Visible := True
    //����ȊO�̏ꍇ
    else
      //�\���s��
      w_TFrm_TcpEmu.Visible := False;
    //�g�p�\�ȏꍇ
    if arg_Enable = g_SOCKET_EMUENABLED_TRUE then
      //�g�p��
      w_TFrm_TcpEmu.Enabled := True
    //����ȊO�̏ꍇ
    else
      //�g�p�s��
      w_TFrm_TcpEmu.Enabled := False;
    //�R�[�h�̌n�̐ݒ�
    w_TFrm_TcpEmu.w_CharCode        := arg_CharCode;
    //�|�[�g�ݒ�
    w_TFrm_TcpEmu.Edt_RISPort1.Text := arg_Por;
    //�^�C���A�E�g�ݒ�
    w_TFrm_TcpEmu.Edt_TimOut.Text   := arg_TimeOut;
    //�d����ʐݒ�
    w_TFrm_TcpEmu.proc_SetMsgKind( arg_MsgKind,arg_MsgKind2 );
    //��M�̈揉����
    w_TFrm_TcpEmu.w_RecvArea := TStringStream.Create('');
    //���M�̈揉����
    w_TFrm_TcpEmu.w_SendArea := TStringStream.Create('');

//����������
    w_TFrm_TcpEmu.proc_Start;
    //�߂�l
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
procedure TFrm_TcpEmuS.Button1Click(Sender: TObject);
begin
  //���M�̈�Ƀt�@�C�����X�g�őI������Ă���t�@�C���̃f�[�^��ǂݍ���
  REdt_RcvAppData1.Lines.LoadFromFile(FileListBox1.FileName);
end;

procedure TFrm_TcpEmuS.Button2Click(Sender: TObject);
begin
  //�ʐM�X�e�[�^�X�̈�N���A
  REdt_SStatus1.Clear;
end;

procedure TFrm_TcpEmuS.proc_TxtOut;
var
  w_s:TStrings;
begin
  //��M�\���̈�̃f�[�^��ۑ�
  REdt_RcvCmdData1.Lines.SaveToFile(IncludeTrailingPathDelimiter(FileListBox1.Directory) + FormatDateTime('yyyymmddhhnnsszzz',Now) + '.txt');
  w_s := TStringList.Create;
  try
    w_s.Add(w_RecvArea.DataString);
    //��M�\���̈�̃f�[�^��ۑ�
    w_s.SaveToFile(IncludeTrailingPathDelimiter(FileListBox1.Directory) + 'A' + FormatDateTime('yyyymmddhhnnsszzz',Now) + '.txt');
  finally
    FreeAndNil(w_s);
  end;
end;

end.
