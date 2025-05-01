program tpSD_Receipt;

uses
  Forms,
  SysUtils,
  Gval in '..\..\..\com_modul\Gval.pas',
  jis2sjis in '..\..\..\com_modul\Jis2sjis.pas',
  TcpSocket in '..\..\..\com_modul\TcpSocket.pas',
  FTcpEmuC in '..\FTcpEmuC.pas' {Frm_TcpEmuC},
  test in 'test.pas' {Form1},
  FTcpEmuS in '..\FTcpEmuS.pas' {Frm_TcpEmuS},
  UDb_RisSD_Receipt in 'UDb_RisSD_Receipt.pas' {DB_RisSD_Receipt: TDataModule},
  HisMsgDef06_RCE in '..\..\..\com_modul\HisMsgDef06_RCE.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := '転送オーダツール';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFrm_TcpEmuS, Frm_TcpEmuS);
  Application.CreateForm(TDB_RisSD_Receipt, DB_RisSD_Receipt);
  Application.Run;
end.
