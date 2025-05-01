object Form1: TForm1
  Left = 44
  Top = 0
  Width = 846
  Height = 764
  Caption = 'RisHisSD'#12486#12473#12488#12484#12540#12523
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Bevel1: TBevel
    Left = 160
    Top = 296
    Width = 422
    Height = 31
    Shape = bsFrame
  end
  object Bevel8: TBevel
    Left = 160
    Top = 232
    Width = 422
    Height = 31
    Shape = bsFrame
  end
  object lbl_err: TLabel
    Left = 0
    Top = 0
    Width = 838
    Height = 31
    Align = alTop
    AutoSize = False
    Caption = #12456#12521#12540
  end
  object lbl_res: TLabel
    Left = 0
    Top = 31
    Width = 838
    Height = 12
    Align = alTop
    Caption = #24489#24112#20516
  end
  object Label1: TLabel
    Left = 407
    Top = 241
    Width = 164
    Height = 12
    AutoSize = False
    Caption = #36890#20449#32080#26524#65306'00='#26410' 10='#28168' 09='#22833#25943
  end
  object Bevel2: TBevel
    Left = 160
    Top = 104
    Width = 422
    Height = 31
    Shape = bsFrame
  end
  object Bevel3: TBevel
    Left = 160
    Top = 136
    Width = 422
    Height = 31
    Shape = bsFrame
  end
  object Bevel4: TBevel
    Left = 160
    Top = 168
    Width = 422
    Height = 31
    Shape = bsFrame
  end
  object Bevel5: TBevel
    Left = 160
    Top = 200
    Width = 422
    Height = 31
    Shape = bsFrame
  end
  object Bevel9: TBevel
    Left = 160
    Top = 264
    Width = 422
    Height = 31
    Shape = bsFrame
  end
  object Bevel10: TBevel
    Left = 160
    Top = 352
    Width = 422
    Height = 31
    Shape = bsFrame
  end
  object Label3: TLabel
    Left = 168
    Top = 113
    Width = 306
    Height = 12
    Caption = #26410#36865#20449#12398#12487#12540#12479#12434#21462#24471'('#21463#20449#12458#12540#12480#12486#12540#12502#12523'('#26410#36865#20449')'#12395#21453#26144')'
  end
  object Label6: TLabel
    Left = 168
    Top = 145
    Width = 334
    Height = 12
    Caption = #21463#20449#12458#12540#12480#12486#12540#12502#12523'('#26410#36865#20449')'#12398#12459#12524#12531#12488#12487#12540#12479#12391#12458#12540#12480#24773#22577#12434#21462#24471
  end
  object Label7: TLabel
    Left = 168
    Top = 177
    Width = 142
    Height = 12
    Caption = #26082#23384#12471#12455#12540#12510#12501#12449#12452#12523#12434#21066#38500
  end
  object Label8: TLabel
    Left = 168
    Top = 209
    Width = 133
    Height = 12
    Caption = 'FTP'#12391#12471#12455#12540#12510#30011#20687#12434#21462#24471
  end
  object Label11: TLabel
    Left = 168
    Top = 241
    Width = 84
    Height = 12
    Caption = #36890#20449#32080#26524#12398#30331#37682
  end
  object Label12: TLabel
    Left = 168
    Top = 273
    Width = 231
    Height = 12
    Caption = #12471#12455#12540#12510#12522#12463#12456#12473#12488#12486#12540#12502#12523#12395#21462#24471#26085#26178#12434#35373#23450
  end
  object Label13: TLabel
    Left = 168
    Top = 361
    Width = 396
    Height = 12
    Caption = #21508'DB'#12464#12522#12483#12489#12398#12522#12501#12524#12483#12471#12517'('#12471#12455#12540#12510#12522#12463#12456#12473#12488#12486#12540#12502#12523#12486#12540#12502#12523'('#26410#36865#20449')'#20197#22806')'
  end
  object Label2: TLabel
    Left = 168
    Top = 305
    Width = 269
    Height = 12
    Caption = #12458#12540#12480#12513#12452#12531#12486#12540#12502#12523#12395#12501#12457#12523#12480#12539#12469#12502#12501#12457#12523#12480#12434#35373#23450
  end
  object Button11: TButton
    Left = 8
    Top = 352
    Width = 141
    Height = 31
    Hint = #21508'DB'#12398#12522#12501#12524#12483#12471#12517
    Caption = 'reflesh'
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = Button11Click
  end
  object Edit1: TEdit
    Left = 256
    Top = 237
    Width = 126
    Height = 20
    ImeMode = imClose
    TabOrder = 1
    Text = 'YYYY/MM/DD hh:mi:ss'
  end
  object Edit2: TEdit
    Left = 384
    Top = 237
    Width = 23
    Height = 20
    ImeMode = imClose
    TabOrder = 2
    Text = '1'
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 392
    Width = 817
    Height = 337
    ActivePage = TabSheet7
    TabHeight = 14
    TabOrder = 3
    object TabSheet1: TTabSheet
      Caption = #12471#12455#12540#12510#12522#12463#12456#12473#12488#65438#65411#65392#65420#65438#65433'('#26410#36865#20449')'
      object DBGrid1: TDBGrid
        Left = 0
        Top = 24
        Width = 809
        Height = 289
        Align = alBottom
        DataSource = DataSource1
        Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
        TabOrder = 0
        TitleFont.Charset = SHIFTJIS_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        TitleFont.Style = []
      end
      object Button20: TButton
        Left = 694
        Top = 3
        Width = 99
        Height = 17
        Hint = #21508'DB'#12464#12522#12483#12489#12398#20869#23481#12434#12459#12524#12531#12488#12524#12467#12540#12489#12391#20877#34920#31034
        Caption = #38306#36899#65411#65392#65420#65438#65433#65397#65392#65420#65439#65437
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = Button20Click
      end
    end
    object TabSheet2: TTabSheet
      Caption = #65397#65392#65408#65438#12471#12455#12540#12510#65411#65392#65420#65438#65433
      ImageIndex = 1
      object Button19: TButton
        Left = 718
        Top = 3
        Width = 75
        Height = 17
        Hint = #36865#20449#12458#12540#12480#12486#12540#12502#12523'('#26410#36865#20449')'#12398#12459#12524#12531#12488#12487#12540#12479#12391#20877#34920#31034
        Caption = 'Open'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        OnClick = Button19Click
      end
      object DBGrid8: TDBGrid
        Left = 0
        Top = 24
        Width = 809
        Height = 289
        Align = alBottom
        DataSource = DataSource8
        TabOrder = 1
        TitleFont.Charset = SHIFTJIS_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        TitleFont.Style = []
      end
    end
    object TabSheet7: TTabSheet
      Caption = #12471#12455#12540#12510#12522#12463#12456#12473#12488#65411#65392#65420#65438#65433'('#36865#20449#28168')'
      ImageIndex = 6
      object DBGrid7: TDBGrid
        Left = 0
        Top = 24
        Width = 809
        Height = 289
        Align = alBottom
        DataSource = DataSource7
        TabOrder = 0
        TitleFont.Charset = SHIFTJIS_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
        TitleFont.Style = []
      end
      object Button21: TButton
        Left = 630
        Top = 3
        Width = 75
        Height = 17
        Hint = #20877#34920#31034
        Caption = 'Open'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = Button21Click
      end
      object Button1: TButton
        Left = 718
        Top = 3
        Width = 75
        Height = 17
        Hint = #35501#12415#36796#12415
        Caption = 'Read'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = Button1Click
      end
    end
  end
  object BitBtn1: TBitBtn
    Left = 8
    Top = 64
    Width = 101
    Height = 31
    Hint = #25104#21151#65306#38738#34920#31034#12289#22833#25943#65306#36196#34920#31034
    Caption = 'DB'#25509#32154
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = BitBtn1Click
  end
  object BitBtn3: TBitBtn
    Left = 8
    Top = 104
    Width = 141
    Height = 31
    Hint = #12456#12521#12540':'#36196#34920#31034
    Caption = #26410#36865#20449#12524#12467#12540#12489#12398#21462#24471
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = BitBtn3Click
  end
  object BitBtn4: TBitBtn
    Left = 8
    Top = 136
    Width = 141
    Height = 31
    Hint = #12456#12521#12540':'#36196#34920#31034
    Caption = #36865#20449#12524#12467#12540#12489#21462#24471
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = BitBtn4Click
  end
  object BitBtn5: TBitBtn
    Left = 8
    Top = 168
    Width = 141
    Height = 31
    Hint = #12456#12521#12540':'#36196#34920#31034
    Caption = #26082#23384#12471#12455#12540#12510#21066#38500
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
    OnClick = BitBtn5Click
  end
  object BitBtn6: TBitBtn
    Left = 8
    Top = 200
    Width = 141
    Height = 31
    Hint = #12456#12521#12540':'#36196#34920#31034
    Caption = #12471#12455#12540#12510#21462#24471
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
    OnClick = BitBtn6Click
  end
  object BitBtn9: TBitBtn
    Left = 112
    Top = 64
    Width = 101
    Height = 31
    Hint = #25104#21151#65306#38738#34920#31034#12289#22833#25943#65306#36196#34920#31034
    Caption = 'DB'#20999#26029
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
    OnClick = BitBtn9Click
  end
  object BitBtn10: TBitBtn
    Left = 8
    Top = 232
    Width = 141
    Height = 31
    Hint = #12456#12521#12540':'#36196#34920#31034
    Caption = #29694#22312#26085#26178#21462#24471
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    OnClick = BitBtn10Click
  end
  object BitBtn11: TBitBtn
    Left = 8
    Top = 264
    Width = 141
    Height = 31
    Hint = #12456#12521#12540':'#36196#34920#31034
    Caption = #36865#20449#32080#26524#21453#26144
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 11
    OnClick = BitBtn11Click
  end
  object Memo1: TMemo
    Left = 592
    Top = 56
    Width = 233
    Height = 329
    ImeMode = imClose
    Lines.Strings = (
      #38651#25991#20869#23481)
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 12
  end
  object BitBtn2: TBitBtn
    Left = 8
    Top = 296
    Width = 141
    Height = 31
    Hint = #12456#12521#12540':'#36196#34920#31034
    Caption = #12458#12540#12480#12513#12452#12531#35373#23450
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 13
    OnClick = BitBtn2Click
  end
  object DataSource1: TDataSource
    DataSet = DB_RisFTP.TQ_Order
    Left = 520
  end
  object DataSource7: TDataSource
    DataSet = Table6
    Left = 712
  end
  object Table6: TTable
    DatabaseName = 'gx2402'
    TableName = 'SHEMAREQUEST'
    Left = 712
    Top = 32
  end
  object Table7: TTable
    DatabaseName = 'gx2402'
    TableName = 'ORDERSHEMAINFO'
    Left = 744
    Top = 32
  end
  object DataSource8: TDataSource
    DataSet = Table7
    Left = 744
  end
  object Table1: TTable
    DatabaseName = 'gx2402'
    TableName = 'ORDERSHEMAINFO'
    Left = 784
    Top = 32
  end
  object DataSource2: TDataSource
    DataSet = Table1
    Left = 784
  end
end
