unit UServiceLook;
{
���@�\����
  �T�[�r�X�Ď�
���@�\�T�v
  �T�[�r�X�̊Ď�
������
�V�K�쐬�F2002.10.27�F���R

��)�T�[�r�X���A�T�[�r�X�\�����A���O�t�@�C������const�ŌŒ�

}

interface
//�g�p���j�b�g---------------------------------------------------------------
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinSvc, ExtCtrls, ComCtrls, StdCtrls, Buttons, TcpSocket;

////�^�N���X�錾-------------------------------------------------------------
type
  Tfrm_ServiceLook = class(TForm)
    PageControl_Service: TPageControl;
    TabSheet_RisHisSvr_Irai: TTabSheet;
    Panel_color: TPanel;
    Panel_start: TPanel;
    Panel_stop: TPanel;
    TabSheet_RisHisSD_Jissi: TTabSheet;
    Button_stop: TButton;
    Panel_Massage: TPanel;
    Memo_Message: TMemo;
    Button_start: TButton;
    TabSheet_RisArworkSD: TTabSheet;
    Panel5: TPanel;
    Timer1: TTimer;
    Shape_start: TShape;
    Shape_stop: TShape;
    Panel4: TPanel;
    Panel_Syori: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ComboBox_time: TComboBox;
    GroupBox2: TGroupBox;
    Button_Log: TButton;
    Button_close: TButton;
    Panel2: TPanel;
    Panel_time: TPanel;
    TabSheet_RisHis_Shema: TTabSheet;
    TabSheet_RisHisSD_Receipt: TTabSheet;
    Pnl_install: TPanel;
    BT_Width: TBitBtn;
    procedure PageControl_ServiceChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button_startClick(Sender: TObject);
    procedure Button_stopClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ComboBox_timeChange(Sender: TObject);
    procedure ComboBox_timeDropDown(Sender: TObject);
    procedure Button_LogClick(Sender: TObject);
    procedure Button_closeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BT_WidthClick(Sender: TObject);
  private
    { Private �錾 }
  public
    { Public �錾 }
    FServiceName: String;
    FDisplayName: String;
    FStatus: TServiceStatus;
    FBuffer: DWORD;
    schService: SC_Handle;
    schSCManager: SC_Handle;

    wgMessage: string;

    function proc_rishisSvr_Irai_look:Boolean;
    function proc_rishissd_Receipt_look:Boolean;
    function proc_rishissd_Jissi_look:Boolean;
    function proc_rishissvc_Schema_look:Boolean;
    procedure proc_service_display;
    function GetLastErrorText: String;
  Published
    Property DisplayName: String Read FDisplayName Write FDisplayName;
  end;

type
  TCharArray = Array[0..29] Of PChar;

var
  frm_ServiceLook: Tfrm_ServiceLook;

implementation
{$R *.DFM}

const
//�T�[�r�X���A�T�[�r�X�\����
CST_FServiceName_RisHisSvr_Irai='RisHisSvrSvc_Irai';
CST_FDisplayName_RisHisSvr_Irai='HIS-RIS�ʐM(�I�[�_��M)';

CST_FServiceName_RisHisSD_Receipt='RisHisSDSvc_Receipt';
CST_FDisplayName_RisHisSD_Receipt='HIS-RIS�ʐM(��t���M)';

CST_FServiceName_RisHisSD_Jissi='RisHisSDSvc_Jissi';
CST_FDisplayName_RisHisSD_Jissi='HIS-RIS�ʐM(���{���M)';

CST_FServiceName_RisHisSvr_Kaikei='RisHisSvrSvc_Kaikei';
CST_FDisplayName_RisHisSvr_Kaikei='HIS-RIS�ʐM(�V�F�[�}�A�g)';

CST_FServiceName_RisHisSD_ReSend='RisHisSDSvc_ReSend';
CST_FDisplayName_RisHisSD_ReSend='RisHisSD_ReSend Service';

CST_FServiceName_RisHisSvc_Schema='RisHisSvc_Shema';
CST_FDisplayName_RisHisSvc_Schema='RisHis_Shema Service';

//���O�t�@�C����
CST_LogName_RisHisSvr_Irai='RisHisSvr_Irai_';
CST_LogName_RisHisSD_Receipt='RisHisSD_Receipt_';
CST_LogName_RisHisSD_Jissi='RisHisSD_Jissi_';
CST_LogName_RisHisSvr_Kaikei='RisHisSvr_Kaikei_';
CST_LogName_RisHisSD_ReSend='RisHisSD_ReSend_';
CST_LogName_RisHisSvc_Schema='RisHis_Shema_';
CST_LogName_LOG='.LOG';

//��ʃT�C�Y
CST_SCREEN_DEFAULT=505;
CST_SCREEN_WIDTH=900;

procedure Tfrm_ServiceLook.FormCreate(Sender: TObject);
begin
//  Application.Minimize;
  self.Width := CST_SCREEN_DEFAULT;
  func_TcpReadiniFile;
end;

procedure Tfrm_ServiceLook.FormShow(Sender: TObject);
begin
//�����y�[�W=RisHisSvr_Irai
  PageControl_Service.ActivePage := TabSheet_RisHisSvr_Irai;
//�����^�C�}�[Interval=10�b
  ComboBox_time.ItemIndex := ComboBox_time.Items.IndexOf('10');
//
  ComboBox_timeChange(self);
end;

//RisHisSvr_Irai
function Tfrm_ServiceLook.proc_rishisSvr_Irai_look:Boolean;
begin
  Result:=True;
  wgMessage:='';

  schSCManager:= OpenSCManager(Nil, Nil, SC_MANAGER_ALL_ACCESS);
  if schSCManager <> 0 then begin
    FServiceName:=CST_FServiceName_RisHisSvr_Irai;
    FDisplayName:=CST_FDisplayName_RisHisSvr_Irai;
    schService:= OpenService(schSCManager, PChar(FServiceName), SERVICE_ALL_ACCESS);
    if schService <> 0 then begin
      QueryServiceStatus(schService, FStatus);
      case FStatus.dwCurrentState of
        SERVICE_STOPPED:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͒�~���Ă��܂��B - %s', [FServiceName]);
          end;
        SERVICE_START_PENDING:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͋N�����ł��B - %s', [FServiceName]);
          end;
        SERVICE_STOP_PENDING:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͒�~���ł��B - %s', [FServiceName]);
          end;
        SERVICE_RUNNING:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͋N�����Ă��܂��B - %s', [FServiceName]);
          end;
        SERVICE_PAUSED:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͈ꎞ��~����Ă��܂��B - %s', [FServiceName]);
          end;
      else
        wgMessage := FDisplayName+Format('�T�[�r�X�̏�Ԃ��킩��܂���ł����B - %s', [FServiceName]);
      end;
      CloseServiceHandle(schService);
    end
    else begin
      wgMessage := FDisplayName+Format('�T�[�r�X�͑��݂��܂���B - %s', [GetLastErrorText]);
      Result:=False;
    end;
    //
    CloseServiceHandle(schSCManager);
  end
  else begin
    wgMessage := Format('�T�[�r�X�}�l�[�W���̎擾�Ɏ��s���܂����B - %s', [GetLastErrorText]);
    Result:=False;
  end;
end;

//RisHisSD_Receipt
function Tfrm_ServiceLook.proc_rishissd_Receipt_look:Boolean;
begin
  Result:=True;
  wgMessage:='';

  schSCManager:= OpenSCManager(Nil, Nil, SC_MANAGER_ALL_ACCESS);
  if schSCManager <> 0 then begin
    FServiceName:=CST_FServiceName_RisHisSD_Receipt;
    FDisplayName:=CST_FDisplayName_RisHisSD_Receipt;
    schService:= OpenService(schSCManager, PChar(FServiceName), SERVICE_ALL_ACCESS);
    if schService <> 0 then begin
      QueryServiceStatus(schService, FStatus);
      case FStatus.dwCurrentState of
        SERVICE_STOPPED:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͒�~���Ă��܂��B - %s', [FServiceName]);
          end;
        SERVICE_START_PENDING:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͋N�����ł��B - %s', [FServiceName]);
          end;
        SERVICE_STOP_PENDING:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͒�~���ł��B - %s', [FServiceName]);
          end;
        SERVICE_RUNNING:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͋N�����Ă��܂��B - %s', [FServiceName]);
          end;
        SERVICE_PAUSED:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͈ꎞ��~����Ă��܂��B - %s', [FServiceName]);
          end;
      else
        wgMessage := FDisplayName+Format('�T�[�r�X�̏�Ԃ��킩��܂���ł����B - %s', [FServiceName]);
      end;
      CloseServiceHandle(schService);
    end
    else begin
      wgMessage := FDisplayName+Format('�T�[�r�X�͑��݂��܂���B - %s', [GetLastErrorText]);
      Result:=False;
    end;
    //
    CloseServiceHandle(schSCManager);
  end
  else begin
    wgMessage := Format('�T�[�r�X�}�l�[�W���̎擾�Ɏ��s���܂����B - %s', [GetLastErrorText]);
    Result:=False;
  end;
end;

//RisHisSD_Jissi
function Tfrm_ServiceLook.proc_rishissd_Jissi_look:Boolean;
begin
  Result:=True;
  wgMessage:='';

  schSCManager:= OpenSCManager(Nil, Nil, SC_MANAGER_ALL_ACCESS);
  if schSCManager <> 0 then begin
    FServiceName:=CST_FServiceName_RisHisSD_Jissi;
    FDisplayName:=CST_FDisplayName_RisHisSD_Jissi;
    schService:= OpenService(schSCManager, PChar(FServiceName), SERVICE_ALL_ACCESS);
    if schService <> 0 then begin
      QueryServiceStatus(schService, FStatus);
      case FStatus.dwCurrentState of
        SERVICE_STOPPED:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͒�~���Ă��܂��B - %s', [FServiceName]);
          end;
        SERVICE_START_PENDING:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͋N�����ł��B - %s', [FServiceName]);
          end;
        SERVICE_STOP_PENDING:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͒�~���ł��B - %s', [FServiceName]);
          end;
        SERVICE_RUNNING:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͋N�����Ă��܂��B - %s', [FServiceName]);
          end;
        SERVICE_PAUSED:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͈ꎞ��~����Ă��܂��B - %s', [FServiceName]);
          end;
      else
        wgMessage := FDisplayName+Format('�T�[�r�X�̏�Ԃ��킩��܂���ł����B - %s', [FServiceName]);
      end;
      CloseServiceHandle(schService);
    end
    else begin
      wgMessage := FDisplayName+Format('�T�[�r�X�͑��݂��܂���B - %s', [GetLastErrorText]);
      Result:=False;
    end;
    //
    CloseServiceHandle(schSCManager);
  end
  else begin
    wgMessage := Format('�T�[�r�X�}�l�[�W���̎擾�Ɏ��s���܂����B - %s', [GetLastErrorText]);
    Result:=False;
  end;
end;


//RisHisSDSvc_Schema
function Tfrm_ServiceLook.proc_rishissvc_Schema_look:Boolean;
begin
  Result:=True;
  wgMessage:='';

  schSCManager:= OpenSCManager(Nil, Nil, SC_MANAGER_ALL_ACCESS);
  if schSCManager <> 0 then begin
    FServiceName:=CST_FServiceName_RisHisSvc_Schema;
    FDisplayName:=CST_FDisplayName_RisHisSvc_Schema;
    schService:= OpenService(schSCManager, PChar(FServiceName), SERVICE_ALL_ACCESS);
    if schService <> 0 then begin
      QueryServiceStatus(schService, FStatus);
      case FStatus.dwCurrentState of
        SERVICE_STOPPED:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͒�~���Ă��܂��B - %s', [FServiceName]);
          end;
        SERVICE_START_PENDING:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͋N�����ł��B - %s', [FServiceName]);
          end;
        SERVICE_STOP_PENDING:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͒�~���ł��B - %s', [FServiceName]);
          end;
        SERVICE_RUNNING:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͋N�����Ă��܂��B - %s', [FServiceName]);
          end;
        SERVICE_PAUSED:
          begin
            wgMessage := FDisplayName+Format('�T�[�r�X�͈ꎞ��~����Ă��܂��B - %s', [FServiceName]);
          end;
      else
        wgMessage := FDisplayName+Format('�T�[�r�X�̏�Ԃ��킩��܂���ł����B - %s', [FServiceName]);
      end;
      CloseServiceHandle(schService);
    end
    else begin
      wgMessage := FDisplayName+Format('�T�[�r�X�͑��݂��܂���B - %s', [GetLastErrorText]);
      Result:=False;
    end;
    //
    CloseServiceHandle(schSCManager);
  end
  else begin
    wgMessage := Format('�T�[�r�X�}�l�[�W���̎擾�Ɏ��s���܂����B - %s', [GetLastErrorText]);
    Result:=False;
  end;
end;


procedure Tfrm_ServiceLook.PageControl_ServiceChange(Sender: TObject);
var
  Return: Boolean;
begin
  Timer1.Enabled := False;
  TabSheet_RisHisSvr_Irai.Highlighted := False;
  TabSheet_RisHisSD_Receipt.Highlighted := False;
  TabSheet_RisHisSD_Jissi.Highlighted := False;
  TabSheet_RisHis_Shema.Highlighted := False;
  PageControl_Service.ActivePage.Highlighted := True;

  if PageControl_Service.ActivePage = TabSheet_RisHisSvr_Irai then begin
    Return := proc_rishisSvr_Irai_look;
    proc_service_display;
    if not(Return) then Exit;
  end
  else
  if PageControl_Service.ActivePage = TabSheet_RisHisSD_Jissi then begin
    Return := proc_rishissd_Jissi_look;
    proc_service_display;
    if not(Return) then Exit;
  end
  else
  if PageControl_Service.ActivePage = TabSheet_RisHisSD_Receipt then begin
    Return := proc_rishissd_Receipt_look;
    proc_service_display;
    if not(Return) then Exit;
  end
  else
  if PageControl_Service.ActivePage = TabSheet_RisHis_Shema then begin
    Return := proc_rishissvc_Schema_look;
    proc_service_display;
    if not(Return) then Exit;
  end;
  Timer1.Enabled := True;
end;

procedure Tfrm_ServiceLook.proc_service_display;
begin
  Memo_Message.Text := wgMessage;
//�J���[
  Panel_start.Color := clWindow;
  Panel_stop.Color := clWindow;
  Shape_start.Brush.Color := clWindow;
  Shape_stop.Brush.Color := clWindow;

  if (schSCManager <> 0) and
     (schService   <> 0) then begin
    if (FStatus.dwCurrentState = SERVICE_RUNNING) or
       (FStatus.dwCurrentState = SERVICE_START_PENDING) then begin
      Panel_start.Color := clBlue;
      Panel_stop.ParentColor := True;
      Shape_start.Brush.Color := clBlue;
      Shape_stop.Brush.Color := clBtnFace;
    end;
    if (FStatus.dwCurrentState = SERVICE_STOPPED) or
       (FStatus.dwCurrentState = SERVICE_STOP_PENDING) or
       (FStatus.dwCurrentState = SERVICE_PAUSED) then begin
      Panel_start.ParentColor := True;
      Panel_stop.Color := clRed;
      Shape_start.Brush.Color := clBtnFace;
      Shape_stop.Brush.Color := clRed;
    end;
  end;
//�{�^��
  Button_start.Enabled := False;
  Button_stop.Enabled := False;
  if Panel_start.Color = clBlue then begin
    Button_stop.Enabled := True;
  end
  else if Panel_stop.Color = clRed then begin
      Button_start.Enabled := True;
  end;
//
  Panel_time.Caption:= FormatDateTime('YYYY/MM/DD HH:NN:SS', Now);

  Panel_color.SetFocus;
end;

function Tfrm_ServiceLook.GetLastErrorText: String;
var
  szTemp: Array[0..767] Of Char;
begin
  Result:= '';
  FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM Or FORMAT_MESSAGE_ARGUMENT_ARRAY,
                        Nil, GetLastError, LANG_NEUTRAL,
                        szTemp, SizeOf(szTemp)-2, Nil);

  szTemp[StrLen(szTemp)-2]:= #0;  //remove cr and newline character
  Result:= Format('%s ($%x)', [szTemp, GetLastError])
end;

//�T�[�r�X���J�n����
procedure Tfrm_ServiceLook.Button_startClick(Sender: TObject);
var
  ServiceArgs: TCharArray;
  ServiceArgsVector: PChar Absolute ServiceArgs;
begin
  Timer1.Enabled := False;

  if PageControl_Service.ActivePage = TabSheet_RisHisSvr_Irai then begin
    FServiceName := CST_FServiceName_RisHisSvr_Irai;
    FDisplayName := CST_FDisplayName_RisHisSvr_Irai;
  end
  else
  if PageControl_Service.ActivePage = TabSheet_RisHisSD_Jissi then begin
    FServiceName := CST_FServiceName_RisHisSD_Jissi;
    FDisplayName := CST_FDisplayName_RisHisSD_Jissi;
  end
  else
  if PageControl_Service.ActivePage = TabSheet_RisHisSD_Receipt then begin
    FServiceName := CST_FServiceName_RisHisSD_Receipt;
    FDisplayName := CST_FDisplayName_RisHisSD_Receipt;
  end
  else
  if PageControl_Service.ActivePage = TabSheet_RisHis_Shema then begin
    FServiceName := CST_FServiceName_RisHisSvc_Schema;
    FDisplayName := CST_FDisplayName_RisHisSvc_Schema;
  end;

  if mrCancel = MessageDlg(FDisplayName+'���N�����܂����H', mtInformation, [mbOk, mbCancel], 0) then begin
    Timer1.Enabled := True;
    Exit;
  end;

  //�T�[�r�X�J�n
  schSCManager:= OpenSCManager(Nil, Nil, SC_MANAGER_ALL_ACCESS);
  if schSCManager <> 0 then begin
    schService:= OpenService(schSCManager, PChar(FServiceName), SERVICE_ALL_ACCESS);
    if schService <> 0 then begin
      QueryServiceStatus(schService, FStatus);
      if (FStatus.dwCurrentState = SERVICE_STOPPED) or
         (FStatus.dwCurrentState = SERVICE_PAUSED) then begin
        ServiceArgs[0]:= PChar(FServiceName);
        ServiceArgs[1]:= Nil;
        If StartService(schService, 0, ServiceArgsVector) then begin
          Memo_Message.Text := FDisplayName+'�T�[�r�X�̋N�����J�n���܂��B';
          while QueryServiceStatus(schService, FStatus) do begin
            If FStatus.dwCurrentState = SERVICE_START_PENDING then begin
              Sleep(500);
            end else begin
              Sleep(500);
              Break;
            end;
          end;
          if FStatus.dwCurrentState = SERVICE_RUNNING then begin
            ShowMessage(FDisplayName+'�T�[�r�X���N�����܂����B');
          end
          else begin
            ShowMessage(FDisplayName+Format('�T�[�r�X�̋N���Ɏ��s���܂����B%s', [GetLastErrorText]));
          end;
        end
        else begin
          ShowMessage(FDisplayName+Format('�T�[�r�X�̋N���Ɏ��s���܂����B%s', [GetLastErrorText]));
        end;
      end
      else begin
        ShowMessage(FDisplayName+'�T�[�r�X�͒�~��Ԃł���܂���B');
      end;
      //
      CloseServiceHandle(schService);
    end;
    //
    CloseServiceHandle(schSCManager);
  end;
  PageControl_ServiceChange(self);
end;

//�T�[�r�X���~����
procedure Tfrm_ServiceLook.Button_stopClick(Sender: TObject);
var
  ServiceArgs: TCharArray;
  ServiceArgsVector: PChar Absolute ServiceArgs;
begin
  Timer1.Enabled := False;

  if PageControl_Service.ActivePage = TabSheet_RisHisSvr_Irai then begin
    FServiceName := CST_FServiceName_RisHisSvr_Irai;
    FDisplayName := CST_FDisplayName_RisHisSvr_Irai;
  end
  else
  if PageControl_Service.ActivePage = TabSheet_RisHisSD_Jissi then begin
    FServiceName := CST_FServiceName_RisHisSD_Jissi;
    FDisplayName := CST_FDisplayName_RisHisSD_Jissi;
  end
  else
  if PageControl_Service.ActivePage = TabSheet_RisHisSD_Receipt then begin
    FServiceName := CST_FServiceName_RisHisSD_Receipt;
    FDisplayName := CST_FDisplayName_RisHisSD_Receipt;
  end
  else
  if PageControl_Service.ActivePage = TabSheet_RisHis_Shema then begin
    FServiceName := CST_FServiceName_RisHisSvc_Schema;
    FDisplayName := CST_FDisplayName_RisHisSvc_Schema;
  end;

  if mrCancel = MessageDlg(FDisplayName+'���~���܂����H', mtInformation, [mbOk, mbCancel], 0) then begin
    Timer1.Enabled := True;
    Exit;
  end;

  //�T�[�r�X��~
  schSCManager:= OpenSCManager(Nil, Nil, SC_MANAGER_ALL_ACCESS);
  if schSCManager <> 0 then begin
    schService:= OpenService(schSCManager, PChar(FServiceName), SERVICE_ALL_ACCESS);
    if schService <> 0 then begin
      QueryServiceStatus(schService, FStatus);
      if (FStatus.dwCurrentState = SERVICE_RUNNING) then begin
        ServiceArgs[0]:= PChar(FServiceName);
        ServiceArgs[1]:= Nil;
        if ControlService(schService, SERVICE_CONTROL_STOP, FStatus) then begin
          Memo_Message.Text := FDisplayName+'�T�[�r�X�̒�~���J�n���܂��B';
          while QueryServiceStatus(schService, FStatus) do begin
            If FStatus.dwCurrentState = SERVICE_STOP_PENDING then begin
              Sleep(1000);
            end else begin
              Sleep(1000);
              Break;
            end;
          end;
          Sleep(2000);
          QueryServiceStatus(schService, FStatus);
          if FStatus.dwCurrentState = SERVICE_STOPPED then begin
            ShowMessage(FDisplayName+'�T�[�r�X���~���܂����B');
          end
          else begin
            ShowMessage(FDisplayName+Format('�T�[�r�X�̒�~�Ɏ��s���܂����B%s', [GetLastErrorText])+#13#10+'�T�[�r�X�̒�~�܂łɐ��\�b������ꍇ������܂��B'+#13#10+'���΂炭�҂��Ă���ēx�m�F���Ă�������');
          end;
        end
        else begin
          ShowMessage(FDisplayName+Format('�T�[�r�X�̒�~�Ɏ��s���܂����B%s', [GetLastErrorText]));
        end;
      end
      else begin
        ShowMessage(FDisplayName+'�T�[�r�X�͋N�����Ă��܂���B');
      end;
      //
      CloseServiceHandle(schService);
    end;
    //
    CloseServiceHandle(schSCManager);
  end;
  PageControl_ServiceChange(self);
end;

procedure Tfrm_ServiceLook.Timer1Timer(Sender: TObject);
begin
  PageControl_ServiceChange(self);
end;

procedure Tfrm_ServiceLook.ComboBox_timeChange(Sender: TObject);
begin
  if ComboBox_time.Text <> '' then begin
    Timer1.Interval := StrToInt(ComboBox_time.Text) * 1000;
    PageControl_ServiceChange(self);
  end;
end;

procedure Tfrm_ServiceLook.ComboBox_timeDropDown(Sender: TObject);
begin
  Timer1.Enabled := False;
  Panel_time.Caption := '';
end;

procedure Tfrm_ServiceLook.Button_LogClick(Sender: TObject);
var
  ResultExe: integer;
  LogName: string;
  wd_DateTime: TDateTime;
begin
  inherited;
  //���ݓ����̎擾
  wd_DateTime := Now;

  if PageControl_Service.ActivePage = TabSheet_RisHisSvr_Irai then begin
    LogName:=IncludeTrailingPathDelimiter(g_Rig_LogPath)+CST_LogName_RisHisSvr_Irai +
             FormatDateTime('dd',wd_DateTime) + CST_LogName_LOG;
  end
  else
  if PageControl_Service.ActivePage = TabSheet_RisHisSD_Jissi then begin
    LogName:=IncludeTrailingPathDelimiter(g_Rig_LogPath)+CST_LogName_RisHisSD_Jissi + 
             FormatDateTime('dd',wd_DateTime) + CST_LogName_LOG;
  end
  else
  if PageControl_Service.ActivePage = TabSheet_RisHisSD_Receipt then begin
    LogName:=IncludeTrailingPathDelimiter(g_Rig_LogPath)+CST_LogName_RisHisSD_Receipt +
             FormatDateTime('dd',wd_DateTime) + CST_LogName_LOG;
  end
  else
  if PageControl_Service.ActivePage = TabSheet_RisHis_Shema then begin
    LogName:=IncludeTrailingPathDelimiter(g_Rig_LogPath)+CST_LogName_RisHisSvc_Schema +
             FormatDateTime('dd',wd_DateTime) + CST_LogName_LOG;
  end;

  if LogName <> '' then begin
    ResultExe := WinExec(Pchar('Notepad.exe ' + LogName),SW_SHOWNORMAL);
    if ResultExe <= 31 then begin
    end;
  end;
end;

procedure Tfrm_ServiceLook.Button_closeClick(Sender: TObject);
begin
  Timer1.Enabled := False;

  if mrCancel = MessageDlg('�T�[�r�X�Ď����I�����܂����H', mtInformation, [mbOk, mbCancel], 0) then begin
    Timer1.Enabled := True;
    Exit;
  end;

  Close;
end;

procedure Tfrm_ServiceLook.BT_WidthClick(Sender: TObject);
begin
  if not(BT_Width.Visible) then
    Exit;

  if BT_Width.Caption = '�J' then begin
    self.Width := CST_SCREEN_WIDTH;
    BT_Width.Caption := '��';
    self.Left := (Screen.Width - self.Width) div 2;
  end
  else if BT_Width.Caption = '��' then begin
    self.Width := CST_SCREEN_DEFAULT;
    BT_Width.Caption := '�J';
    self.Left := (Screen.Width - self.Width) div 2;
  end;
end;

end.
