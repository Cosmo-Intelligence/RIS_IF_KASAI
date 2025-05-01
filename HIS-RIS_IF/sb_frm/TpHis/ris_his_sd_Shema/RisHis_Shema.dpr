program RisHis_Shema;

uses
  SvcMgr,
  SysUtils,
  Gval in '..\..\..\com_modul\Gval.pas',
  jis2sjis in '..\..\..\com_modul\Jis2sjis.pas',
  URH_ShemaSvc in 'URH_ShemaSvc.pas' {RisHisSvc_Shema: TService},
  UDb_RisShema in 'UDb_RisShema.pas' {DB_RisShema: TDataModule},
  TcpSocket in '..\..\..\com_modul\TcpSocket.pas',
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
  HisMsgDef06_RCE in '..\..\..\com_modul\HisMsgDef06_RCE.pas',
  HisMsgDef07_RESEND in '..\..\..\com_modul\HisMsgDef07_RESEND.pas',
  pdct_shema in '..\..\..\com_modul\pdct_shema.pas',
  risftp in '..\..\..\com_modul\risftp.pas';

{$R *.RES}

begin
try
  Application.Initialize;
  Application.Title := 'RISHISシェーマ取得サービス';
  Application.CreateForm(TRisHisSvc_Shema, RisHisSvc_Shema);
  Application.Run;
except

 on E: Exception do
 begin
   if nil<>RisHisSvc_Shema then
   begin
     RisHisSvc_Shema.LogMessage(
      '予想外エラー'+
      E.Message +
      ' (ErrCode=' +IntToStr(RisHisSvc_Shema.ErrCode) +')'
      );
   end;
   exit;

 end;

end;

end.
