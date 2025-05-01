program RisHisSD_Receipt;

uses
  SvcMgr,
  SysUtils,
  Gval in '..\..\..\com_modul\Gval.pas',
  jis2sjis in '..\..\..\com_modul\Jis2sjis.pas',
  TcpSocket in '..\..\..\com_modul\TcpSocket.pas',
  URH_SDSvc_Receipt in 'URH_SDSvc_Receipt.pas' {RisHisSDSvc_Receipt: TService},
  UDb_RisSD_Receipt in 'UDb_RisSD_Receipt.pas' {DB_RisSD_Receipt: TDataModule},
  pdct_ini in '..\..\..\com_modul\pdct_ini.pas',
  HisMsgDef06_RCE in '..\..\..\com_modul\HisMsgDef06_RCE.pas',
  Unit_Convert in '..\..\..\com_modul\Unit_Convert.pas',
  Unit_DB in '..\..\..\com_modul\Unit_DB.pas',
  Unit_Log in '..\..\..\com_modul\Unit_Log.pas',
  Unit_TreatFile in '..\..\..\com_modul\Unit_TreatFile.pas',
  Unit_DirectoryComposite in '..\..\..\com_modul\Unit_DirectoryComposite.pas',
  Unit_FileOperation in '..\..\..\com_modul\Unit_FileOperation.pas',
  HisMsgDef in '..\..\..\com_modul\HisMsgDef.pas',
  HisMsgDef01_IRAI in '..\..\..\com_modul\HisMsgDef01_IRAI.pas',
  HisMsgDef02_JISSI in '..\..\..\com_modul\HisMsgDef02_JISSI.pas',
  HisMsgDef03_CANCEL in '..\..\..\com_modul\HisMsgDef03_CANCEL.pas',
  HisMsgDef04_KANJA_Kekka in '..\..\..\com_modul\HisMsgDef04_KANJA_Kekka.pas',
  HisMsgDef05_KAIKEI in '..\..\..\com_modul\HisMsgDef05_KAIKEI.pas',
  HisMsgDef07_RESEND in '..\..\..\com_modul\HisMsgDef07_RESEND.pas';

{$R *.RES}

begin
  try
    Application.Initialize;
    Application.Title := 'RISHIS受付情報送信サービス';
    Application.CreateForm(TRisHisSDSvc_Receipt, RisHisSDSvc_Receipt);
  Application.Run;
  except
    on E: Exception do begin
      if nil <> RisHisSDSvc_Receipt then begin
        RisHisSDSvc_Receipt.LogMessage('予想外エラー'+E.Message +' (ErrCode=' +IntToStr(RisHisSDSvc_Receipt.ErrCode) +')');
      end;
      Exit;
    end;
  end;
end.
