object Form1: TForm1
  Left = 37
  Top = 8
  Width = 958
  Height = 713
  Caption = 'RisHisRV'#12486#12473#12488#12484#12540#12523
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object lbl_err: TLabel
    Left = 0
    Top = 12
    Width = 950
    Height = 31
    Align = alTop
    AutoSize = False
    Caption = #12456#12521#12540
  end
  object lbl_res: TLabel
    Left = 0
    Top = 0
    Width = 950
    Height = 12
    Align = alTop
    Caption = #24489#24112#20516
  end
  object Button5: TButton
    Left = 994
    Top = 858
    Width = 141
    Height = 31
    Caption = 'func_SaveMsg'
    TabOrder = 0
    Visible = False
    OnClick = Button5Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 43
    Width = 950
    Height = 86
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 1
    object Button10: TButton
      Left = 112
      Top = 12
      Width = 89
      Height = 27
      Hint = 'RisDB'#12392#12398#25509#32154#12434#32066#20102#12375#12414#12377#12290
      Caption = 'DB'#20999#26029
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = Button10Click
    end
    object Button16: TButton
      Left = 112
      Top = 52
      Width = 89
      Height = 27
      Hint = #12525#12540#12523#12496#12483#12463#12434#34892#12356#12414#12377#12290
      Caption = #12525#12540#12523#12496#12483#12463
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = Button16Click
    end
    object BitBtn1: TBitBtn
      Left = 12
      Top = 12
      Width = 89
      Height = 27
      Hint = 'RisDB'#12395#25509#32154#12434#34892#12356#12414#12377#12290
      Caption = 'DB'#25509#32154
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 12
      Top = 52
      Width = 89
      Height = 27
      Hint = #12488#12521#12531#12470#12463#12471#12519#12531#12434#38283#22987#12375#12414#12377#12290
      Caption = #65412#65431#65437#65403#65438#65400#65404#65390#65437
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = BitBtn2Click
    end
    object Panel2: TPanel
      Left = 218
      Top = 52
      Width = 535
      Height = 27
      BevelOuter = bvLowered
      TabOrder = 4
      object Edit3: TEdit
        Left = 142
        Top = 3
        Width = 109
        Height = 20
        Hint = #34892#12525#12483#12463#12434#12363#12369#12427#12486#12540#12502#12523#21517#12434#25351#23450#12375#12414#12377#12290
        ImeMode = imClose
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'OrderMainTable'
      end
      object Button13: TButton
        Left = 20
        Top = 4
        Width = 101
        Height = 19
        Hint = #34892#12525#12483#12463#12434#34892#12356#12414#12377#12290
        Caption = #34892#12525#12483#12463
        Font.Charset = SHIFTJIS_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        OnClick = Button13Click
      end
      object Edit4: TEdit
        Left = 254
        Top = 3
        Width = 75
        Height = 20
        Hint = #36984#25246#38917#30446#12434#35373#23450#12375#12414#12377#12290
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = 'Ris_ID'
      end
      object Edit5: TEdit
        Left = 334
        Top = 3
        Width = 95
        Height = 20
        Hint = #26465#20214#21477#12434#35373#23450#12375#12414#12377#12290
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        Text = '1=1'
      end
      object ComboBox1: TComboBox
        Left = 432
        Top = 3
        Width = 97
        Height = 20
        Hint = 'NoWait'#25351#23450
        Style = csDropDownList
        ItemHeight = 12
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Items.Strings = (
          ''
          'NoWait'
          'Wait')
      end
    end
    object Button3: TButton
      Left = 312
      Top = 12
      Width = 89
      Height = 27
      Caption = #36890#20449#38283#22987
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 512
      Top = 12
      Width = 89
      Height = 27
      Caption = #36890#20449#32066#20102
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnClick = Button4Click
    end
    object Edit2: TEdit
      Left = 456
      Top = 15
      Width = 33
      Height = 20
      Enabled = False
      TabOrder = 7
    end
    object StaticText5: TStaticText
      Left = 416
      Top = 19
      Width = 35
      Height = 16
      Caption = #12509#12540#12488
      TabOrder = 8
    end
    object Button6: TButton
      Left = 216
      Top = 12
      Width = 89
      Height = 27
      Caption = 'INI'#12501#12449#12452#12523
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
      OnClick = Button6Click
    end
  end
  object Panel10: TPanel
    Left = 304
    Top = 432
    Width = 321
    Height = 57
    BevelInner = bvLowered
    TabOrder = 2
    object Button2: TButton
      Left = 12
      Top = 14
      Width = 117
      Height = 25
      Caption = 'func_DelOrder'
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = Button2Click
    end
    object arg_Keep: TEdit
      Left = 140
      Top = 16
      Width = 61
      Height = 20
      TabOrder = 1
      Text = '10'
    end
  end
  object mem_msg: TMemo
    Left = 632
    Top = 432
    Width = 317
    Height = 249
    Lines.Strings = (
      #38651#25991#34920#31034)
    ScrollBars = ssBoth
    TabOrder = 3
    WantReturns = False
    WordWrap = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 144
    Width = 949
    Height = 281
    ActivePage = TabSheet7
    TabIndex = 3
    TabOrder = 5
    object TabSheet1: TTabSheet
      Caption = #24739#32773#12510#12473#12479
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 941
        Height = 254
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText3: TStaticText
          Left = 4
          Top = 4
          Width = 59
          Height = 16
          Align = alTop
          Caption = #24739#32773#12510#12473#12479
          TabOrder = 0
          OnClick = StaticText3Click
        end
        object DBGrid3: TDBGrid
          Left = 4
          Top = 20
          Width = 933
          Height = 230
          Align = alClient
          DataSource = DataSource1
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #12458#12540#12480#12513#12452#12531
      ImageIndex = 1
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 941
        Height = 254
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText2: TStaticText
          Left = 4
          Top = 4
          Width = 67
          Height = 16
          Align = alTop
          Caption = #12458#12540#12480#12513#12452#12531
          TabOrder = 0
          OnClick = StaticText2Click
        end
        object DBGrid1: TDBGrid
          Left = 4
          Top = 20
          Width = 933
          Height = 230
          Align = alClient
          DataSource = DataSource2
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = #23455#32318#12513#12452#12531
      ImageIndex = 3
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 941
        Height = 254
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText4: TStaticText
          Left = 4
          Top = 4
          Width = 57
          Height = 16
          Align = alTop
          Caption = #23455#32318#12513#12452#12531
          TabOrder = 0
          OnClick = StaticText4Click
        end
        object DBGrid4: TDBGrid
          Left = 4
          Top = 20
          Width = 933
          Height = 230
          Align = alClient
          DataSource = DataSource2
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
    object TabSheet7: TTabSheet
      Caption = #31227#21205#24739#32773#24773#22577
      ImageIndex = 6
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 941
        Height = 254
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object DBGrid2: TDBGrid
          Left = 4
          Top = 20
          Width = 933
          Height = 230
          Align = alClient
          DataSource = DataSource3
          TabOrder = 0
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
        object StaticText1: TStaticText
          Left = 4
          Top = 4
          Width = 933
          Height = 16
          Align = alTop
          Caption = #21463#20449#24739#32773
          TabOrder = 1
        end
      end
    end
  end
  object Button11: TButton
    Left = 864
    Top = 138
    Width = 81
    Height = 23
    Caption = #20877#35501#12415#36796#12415
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = Button11Click
  end
  object BitBtn7: TBitBtn
    Left = 524
    Top = 493
    Width = 103
    Height = 25
    Caption = #21463#20449#24739#32773#38651#25991
    TabOrder = 6
    OnClick = BitBtn7Click
  end
  object DataSource1: TDataSource
    DataSet = Tbl_KANJAMASTER
    Left = 474
    Top = 12
  end
  object DataSource2: TDataSource
    DataSet = Tbl_ORDERMAINTABLE
    Left = 552
    Top = 12
  end
  object Tbl_KANJAMASTER: TTable
    DatabaseName = 'stlkrisOra'
    TableName = 'KANJAMASTER'
    Left = 444
    Top = 12
  end
  object Tbl_ORDERMAINTABLE: TTable
    DatabaseName = 'stlkrisOra'
    TableName = 'ORDERMAINTABLE'
    Left = 516
    Top = 14
  end
  object Tbl_JUSINKANJATABLE: TTable
    DatabaseName = 'stlkrisOra'
    TableName = 'JUSINKANJATABLE'
    Left = 586
    Top = 12
  end
  object DataSource3: TDataSource
    DataSet = Tbl_JUSINKANJATABLE
    Left = 618
    Top = 14
  end
  object Tbl_EXMAINTABLE: TTable
    DatabaseName = 'stlkrisOra'
    TableName = 'EXMAINTABLE'
    Left = 658
    Top = 12
  end
  object DataSource4: TDataSource
    DataSet = Tbl_EXMAINTABLE
    Left = 690
    Top = 14
  end
end
