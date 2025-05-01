program RisHisSvr_Irai;

uses
  SvcMgr,
  SysUtils,
  Gval in '..\..\..\com_modul\Gval.pas',
  KanaRoma in '..\..\..\com_modul\KanaRoma.pas',
  jis2sjis in '..\..\..\com_modul\Jis2sjis.pas',
  TcpSocket in '..\..\..\com_modul\TcpSocket.pas',
  URH_SvrSvc_Irai in 'URH_SvrSvc_Irai.pas' {RisHisSvrSvc_Irai: TService},
  HisMsgDef01_IRAI in '..\..\..\com_modul\HisMsgDef01_IRAI.pas',
  pdct_ini in '..\..\..\com_modul\pdct_ini.pas',
  HisMsgDef04_KANJA_Kekka in '..\..\..\com_modul\HisMsgDef04_KANJA_Kekka.pas',
  HisMsgDef03_CANCEL in '..\..\..\com_modul\HisMsgDef03_CANCEL.pas',
  UDb_RisSvr_Irai in 'UDb_RisSvr_Irai.pas',
  Unit_Convert in '..\..\..\com_modul\Unit_Convert.pas',
  Unit_DB in '..\..\..\com_modul\Unit_DB.pas',
  Unit_Log in '..\..\..\com_modul\Unit_Log.pas',
  HisMsgDef in '..\..\..\com_modul\HisMsgDef.pas',
  HisMsgDef07_RESEND in '..\..\..\com_modul\HisMsgDef07_RESEND.pas',
  HisMsgDef02_JISSI in '..\..\..\com_modul\HisMsgDef02_JISSI.pas',
  HisMsgDef05_KAIKEI in '..\..\..\com_modul\HisMsgDef05_KAIKEI.pas',
  HisMsgDef06_RCE in '..\..\..\com_modul\HisMsgDef06_RCE.pas',
  Unit_DirectoryComposite in '..\..\..\com_modul\Unit_DirectoryComposite.pas',
  Unit_TreatFile in '..\..\..\com_modul\Unit_TreatFile.pas',
  Unit_FileOperation in '..\..\..\com_modul\Unit_FileOperation.pas';

{$R *.RES}

begin
  try
    Application.Initialize;
    Application.Title := 'RISHIS依頼情報受信サービス';
    Application.CreateForm(TRisHisSvrSvc_Irai, RisHisSvrSvc_Irai);
  Application.Run;
  except
    on E: Exception do begin
      if nil <> RisHisSvrSvc_Irai then begin
        RisHisSvrSvc_Irai.LogMessage(
         '予想外エラー'+
         E.Message +
         ' (ErrCode=' +IntToStr(RisHisSvrSvc_Irai.ErrCode) +')'
         );
      end;
      Exit;
    end;
  end;
end.
