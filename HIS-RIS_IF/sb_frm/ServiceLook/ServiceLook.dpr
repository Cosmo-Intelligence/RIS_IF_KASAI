program ServiceLook;

uses
  Forms,
  Windows,
  UServiceLook in 'UServiceLook.pas' {frm_ServiceLook},
  TcpSocket in '..\..\com_modul\TcpSocket.pas';

{$R *.RES}

const
  MutexName = 'EX_MutexRisSvcLook';
var
  hMutex: THANDLE;
begin
{$HINTS OFF}
  //ﾐｭｰﾃｯｸｽ作成
  hMutex := OpenMutex(MUTEX_ALL_ACCESS, False, MutexName);
  if hMutex <> 0 then
  begin
    CloseHandle(hMutex);
    Exit;
  end;
  hMutex := CreateMutex(nil, False, MutexName);
  try
    Application.Initialize;
    Application.Title := 'サービス監視';
    Application.HelpFile := '';
    Application.CreateForm(Tfrm_ServiceLook, frm_ServiceLook);
  Application.Run;
  finally
    ReleaseMutex(hMutex);
  end;
{$HINTS ON}
end.
