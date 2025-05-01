object F_SockAns: TF_SockAns
  Left = 557
  Top = 114
  Width = 552
  Height = 415
  Caption = #12477#12465#12483#12488#21463#20449#12484#12540#12523
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    544
    381)
  PixelsPerInch = 96
  TextHeight = 12
  object Label2: TLabel
    Left = 392
    Top = 328
    Width = 21
    Height = 12
    Caption = 'Port'
  end
  object RadioGroup1: TRadioGroup
    Left = 8
    Top = 328
    Width = 369
    Height = 52
    Anchors = [akLeft, akBottom]
    Caption = #24540#31572#31278#21029
    Columns = 3
    ItemIndex = 0
    Items.Strings = (
      #27491#24120
      #24259#26820)
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 544
    Height = 321
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object Edit2: TEdit
    Left = 424
    Top = 325
    Width = 41
    Height = 20
    TabOrder = 2
    Text = '7052'
  end
  object Button1: TButton
    Left = 480
    Top = 320
    Width = 57
    Height = 25
    Caption = 'Open'
    TabOrder = 3
    OnClick = Button1Click
  end
end
