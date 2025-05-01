object RisHisSDSvc_Receipt: TRisHisSDSvc_Receipt
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  Dependencies = <
    item
      IsGroup = False
    end>
  DisplayName = 'HIS-RIS'#36890#20449#65288#21463#20184#36865#20449#65289
  ErrorSeverity = esIgnore
  Password = 'sn_60'
  ServiceStartName = '.\Administrator'
  AfterInstall = ServiceAfterInstall
  AfterUninstall = ServiceAfterUninstall
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  OnStop = ServiceStop
  Left = 263
  Top = 457
  Height = 314
  Width = 696
  object ClientSocket1: TClientSocket
    Active = False
    ClientType = ctBlocking
    Port = 0
    OnConnect = ClientSocket1Connect
    OnDisconnect = ClientSocket1Disconnect
    OnRead = ClientSocket1Read
    OnWrite = ClientSocket1Write
    OnError = ClientSocket1Error
    Left = 42
    Top = 8
  end
end
