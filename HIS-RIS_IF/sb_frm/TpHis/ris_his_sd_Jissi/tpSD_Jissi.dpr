program tpSD_Jissi;

uses
  Forms,
  SysUtils,
  Gval in '..\..\..\com_modul\Gval.pas',
  jis2sjis in '..\..\..\com_modul\Jis2sjis.pas',
  TcpSocket in '..\..\..\com_modul\TcpSocket.pas',
  UDb_RisSD in 'UDb_RisSD.pas' {DB_RisSD: TDataModule1},
  FTcpEmuC in '..\FTcpEmuC.pas' {Frm_TcpEmuC},
  test in 'test.pas' {Form1},
  FTcpEmuS in '..\FTcpEmuS.pas' {Frm_TcpEmuS};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := '転送オーダツール';
  Application.CreateForm(TDB_RisSD, DB_RisSD);
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFrm_TcpEmuS, Frm_TcpEmuS);
  Application.Run;
end.
