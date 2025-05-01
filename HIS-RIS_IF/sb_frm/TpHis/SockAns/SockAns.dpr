program SockAns;

uses
  Forms,
  U_SockAns in 'U_SockAns.pas' {F_SockAns},
  U_IFData in 'U_IFData.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'ソケット受信ツール';
  Application.CreateForm(TF_SockAns, F_SockAns);
  Application.Run;
end.
