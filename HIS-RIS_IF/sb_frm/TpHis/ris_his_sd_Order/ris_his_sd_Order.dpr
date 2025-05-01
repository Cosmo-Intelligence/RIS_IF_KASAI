(**
 * @project Tcpエミュレータ
 * @author  電翔
 *)

program ris_his_sd_Order;

uses
  Forms,
  Gval in '..\..\..\com_modul\Gval.pas',
  HisMsgDef in '..\..\..\com_modul\HisMsgDef.pas',
  jis2sjis in '..\..\..\com_modul\Jis2sjis.pas',
  main in 'main.pas' {frm_Main},
  HisMsgDef02_JISSI in '..\..\..\com_modul\HisMsgDef02_JISSI.pas',
  HisMsgDef01_IRAI in '..\..\..\com_modul\HisMsgDef01_IRAI.pas',
  TcpSocket in '..\..\..\com_modul\TcpSocket.pas',
  FTcpEmuOrd in 'FTcpEmuOrd.pas' {Frm_TcpEmuOrd},
  Unit_Log in '..\..\..\com_modul\Unit_Log.pas',
  Unit_DB in '..\..\..\com_modul\Unit_DB.pas',
  Unit_Convert in '..\..\..\com_modul\Unit_Convert.pas',
  HisMsgDef03_CANCEL in '..\..\..\com_modul\HisMsgDef03_CANCEL.pas',
  HisMsgDef04_KANJA_Kekka in '..\..\..\com_modul\HisMsgDef04_KANJA_Kekka.pas',
  HisMsgDef05_KAIKEI in '..\..\..\com_modul\HisMsgDef05_KAIKEI.pas',
  HisMsgDef06_RCE in '..\..\..\com_modul\HisMsgDef06_RCE.pas',
  HisMsgDef07_RESEND in '..\..\..\com_modul\HisMsgDef07_RESEND.pas',
  Unit_TreatFile in '..\..\..\com_modul\Unit_TreatFile.pas',
  Unit_DirectoryComposite in '..\..\..\com_modul\Unit_DirectoryComposite.pas',
  Unit_FileOperation in '..\..\..\com_modul\Unit_FileOperation.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'ソケット通信ツール';
  Application.CreateForm(Tfrm_Main, frm_Main);
  Application.CreateForm(TFrm_TcpEmuOrd, Frm_TcpEmuOrd);
  Application.Run;
end.
