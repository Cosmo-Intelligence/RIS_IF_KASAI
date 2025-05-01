object RisHisSvc_Shema: TRisHisSvc_Shema
  OldCreateOrder = False
  OnCreate = ServiceCreate
  OnDestroy = ServiceDestroy
  Dependencies = <
    item
      IsGroup = False
    end>
  DisplayName = 'HIS-RIS'#36890#20449#65288#12471#12455#12540#12510#36899#25658#65289
  ErrorSeverity = esIgnore
  Password = 'Administrator'
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
end
