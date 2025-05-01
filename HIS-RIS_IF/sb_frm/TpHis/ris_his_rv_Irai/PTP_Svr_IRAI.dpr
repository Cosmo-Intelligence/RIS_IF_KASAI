program PTP_Svr_IRAI;

uses
  Forms,
  SysUtils,
  Windows,
  Gval in '..\..\..\com_modul\Gval.pas',
  jis2sjis in '..\..\..\com_modul\Jis2sjis.pas',
  TcpSocket in '..\..\..\com_modul\TcpSocket.pas',
  TP_Svr_IRAI in 'TP_Svr_IRAI.pas' {Form1},
  HisMsgDef01_IRAI in '..\..\..\com_modul\HisMsgDef01_IRAI.pas',
  URH_SvrSvc_Irai in 'URH_SvrSvc_Irai.pas' {RisHisSvrSvc_Irai: TService},
  UDb_RisSvr_Irai in 'UDb_RisSvr_Irai.pas' {Db_RisSvr_Irai: TDataModule},
  myInitInf in '..\..\..\com_modul\myInitInf.pas',
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
{$IFDEF DEBUGE}
  if AllocMemCount>0 then
  begin
    Application.ProcessMessages;
    w_str:=IntToStr(AllocMemCount)
         + '回のメモリ開放忘れで '
         + IntToStr(AllocMemSize)
         +'バイトが開放されてないみたい。';
    OutputDebugString( PChar(w_str) );
  end;
{$ENDIF}
  Application.Initialize;
  Application.Title := '放射線依頼情報受信オーダツール';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TRisHisSvrSvc_Irai, RisHisSvrSvc_Irai);
  Application.CreateForm(TDb_RisSvr_Irai, Db_RisSvr_Irai);
  Application.Run;
{$IFDEF DBG}
  if AllocMemCount>0 then
  begin
    Application.ProcessMessages;
    w_str:=IntToStr(AllocMemCount)
         + '回のメモリ開放忘れで '
         + IntToStr(AllocMemSize)
         +'バイトが開放されてないみたい。';
    OutputDebugString( PChar(w_str) );
  end;
{$ENDIF}
end.
