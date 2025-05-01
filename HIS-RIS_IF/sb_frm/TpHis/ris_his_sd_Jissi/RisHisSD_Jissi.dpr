program RisHisSD_Jissi;

uses
  SvcMgr,
  SysUtils,
  Gval in '..\..\..\com_modul\Gval.pas',
  jis2sjis in '..\..\..\com_modul\Jis2sjis.pas',
  TcpSocket in '..\..\..\com_modul\TcpSocket.pas',
  URH_SDSvc in 'URH_SDSvc.pas' {RisHisSDSvc_Jissi: TService},
  UDb_RisSD in 'UDb_RisSD.pas' {DB_RisSD: TDataModule},
  HisMsgDef02_JISSI in '..\..\..\com_modul\HisMsgDef02_JISSI.pas',
  Unit_DB in '..\..\..\com_modul\Unit_DB.pas',
  Unit_Log in '..\..\..\com_modul\Unit_Log.pas',
  Unit_Convert in '..\..\..\com_modul\Unit_Convert.pas',
  Unit_DirectoryComposite in '..\..\..\com_modul\Unit_DirectoryComposite.pas',
  Unit_TreatFile in '..\..\..\com_modul\Unit_TreatFile.pas',
  Unit_FileOperation in '..\..\..\com_modul\Unit_FileOperation.pas',
  HisMsgDef in '..\..\..\com_modul\HisMsgDef.pas',
  HisMsgDef01_IRAI in '..\..\..\com_modul\HisMsgDef01_IRAI.pas',
  HisMsgDef03_CANCEL in '..\..\..\com_modul\HisMsgDef03_CANCEL.pas',
  HisMsgDef04_KANJA_Kekka in '..\..\..\com_modul\HisMsgDef04_KANJA_Kekka.pas',
  HisMsgDef05_KAIKEI in '..\..\..\com_modul\HisMsgDef05_KAIKEI.pas',
  HisMsgDef06_RCE in '..\..\..\com_modul\HisMsgDef06_RCE.pas',
  HisMsgDef07_RESEND in '..\..\..\com_modul\HisMsgDef07_RESEND.pas';

{$R *.RES}

begin
  try
    Application.Initialize;
    Application.Title := 'RISHIS実施情報送信通信サービス';
    Application.CreateForm(TRisHisSDSvc_Jissi, RisHisSDSvc_Jissi);
  Application.Run;
  except
    on E: Exception do begin
      if nil <> RisHisSDSvc_Jissi then begin
        RisHisSDSvc_Jissi.LogMessage('予想外エラー'+E.Message +' (ErrCode=' +IntToStr(RisHisSDSvc_Jissi.ErrCode) +')');
      end;
      Exit;
    end;
  end;
end.
