(**
 * @project Tcpエミュレータ
 * @author  電翔
 *)

program TcpEmu;

uses
  Forms,
  Gval in '..\..\com_modul\Gval.pas',
  HisMsgDef in '..\..\com_modul\HisMsgDef.pas',
  jis2sjis in '..\..\com_modul\Jis2sjis.pas',
  FTcpEmuS in 'FTcpEmuS.pas' {Frm_TcpEmuS},
  main in 'main.pas' {frm_Main},
  HisMsgDef02_JISSI in '..\..\com_modul\HisMsgDef02_JISSI.pas',
  HisMsgDef01_IRAI in '..\..\com_modul\HisMsgDef01_IRAI.pas',
  TcpSocket in '..\..\com_modul\TcpSocket.pas',
  FTcpEmuC in 'FTcpEmuC.pas' {Frm_TcpEmuC};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'ソケット通信ツール';
  Application.CreateForm(Tfrm_Main, frm_Main);
  Application.CreateForm(TFrm_TcpEmuS, Frm_TcpEmuS);
  Application.CreateForm(TFrm_TcpEmuC, Frm_TcpEmuC);
  Application.Run;
end.
