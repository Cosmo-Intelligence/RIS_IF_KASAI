program tpGet_Schema;

uses
  Forms,
  SysUtils,
  Gval in '..\..\..\com_modul\Gval.pas',
  jis2sjis in '..\..\..\com_modul\Jis2sjis.pas',
  TcpSocket in '..\..\..\com_modul\TcpSocket.pas',
  test in 'test.pas' {Form1},
  UDb_RisFTP in 'UDb_RisFTP.pas' {DB_RisFTP: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := '転送オーダツール';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDB_RisFTP, DB_RisFTP);
  Application.Run;
end.
