program SockAns;

uses
  Forms,
  U_SockAns in 'U_SockAns.pas' {F_SockAns},
  U_IFData in 'U_IFData.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := '�\�P�b�g��M�c�[��';
  Application.CreateForm(TF_SockAns, F_SockAns);
  Application.Run;
end.
