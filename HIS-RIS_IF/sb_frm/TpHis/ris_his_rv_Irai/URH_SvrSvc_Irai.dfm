object RisHisSvrSvc_Irai: TRisHisSvrSvc_Irai
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  Dependencies = <
    item
      IsGroup = False
    end>
  DisplayName = 'HIS-RIS'#36890#20449#65288#12458#12540#12480#21463#20449#65289
  ErrorSeverity = esIgnore
  Password = 'sn_60'
  ServiceStartName = '.\Administrator'
  AfterInstall = ServiceAfterInstall
  AfterUninstall = ServiceAfterUninstall
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  OnStop = ServiceStop
  Left = 263
  Top = 414
  Height = 314
  Width = 216
  object ServerSocket1: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnClientConnect = ServerSocket1ClientConnect
    OnClientDisconnect = ServerSocket1ClientDisconnect
    OnClientRead = ServerSocket1ClientRead
    OnClientError = ServerSocket1ClientError
    Left = 72
    Top = 96
  end
end
