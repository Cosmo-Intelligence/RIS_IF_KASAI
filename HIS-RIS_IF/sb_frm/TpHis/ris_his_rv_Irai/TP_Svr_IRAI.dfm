object Form1: TForm1
  Left = 212
  Top = 78
  Width = 991
  Height = 742
  Caption = #25918#23556#32218#20381#38972#24773#22577#38651#25991#12486#12473#12488#12484#12540#12523
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
    Width = 983
    Height = 31
    Align = alTop
    AutoSize = False
    Caption = #12456#12521#12540
  end
  object lbl_res: TLabel
    Left = 0
    Top = 0
    Width = 983
    Height = 12
    Align = alTop
    Caption = #24489#24112#20516
  end
  object Panel3: TPanel
    Left = 8
    Top = 464
    Width = 561
    Height = 250
    BevelInner = bvLowered
    TabOrder = 6
    object StaticText14: TStaticText
      Left = 384
      Top = 201
      Width = 52
      Height = 16
      Caption = #26465#20214#25351#23450
      TabOrder = 17
    end
    object CB_Jyouken: TComboBox
      Left = 384
      Top = 213
      Width = 57
      Height = 20
      Style = csDropDownList
      ImeMode = imClose
      ItemHeight = 12
      TabOrder = 9
    end
    object CB_Columns_Name: TComboBox
      Left = 24
      Top = 213
      Width = 145
      Height = 20
      Style = csDropDownList
      ImeMode = imClose
      ItemHeight = 12
      TabOrder = 6
      Visible = False
    end
    object CB_DBGrid_Name: TComboBox
      Left = 40
      Top = 21
      Width = 145
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 3
      Visible = False
    end
    object CB_Table_Name: TComboBox
      Left = 24
      Top = 21
      Width = 145
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 2
      Visible = False
    end
    object StaticText9: TStaticText
      Left = 8
      Top = 9
      Width = 74
      Height = 16
      Caption = #12486#12540#12502#12523#25351#23450
      TabOrder = 0
    end
    object CB_Table: TComboBox
      Left = 8
      Top = 21
      Width = 145
      Height = 20
      Style = csDropDownList
      ImeMode = imClose
      ItemHeight = 12
      TabOrder = 1
      OnChange = CB_TableChange
    end
    object StaticText10: TStaticText
      Left = 8
      Top = 201
      Width = 64
      Height = 16
      Caption = #38917#30446#21517#25351#23450
      TabOrder = 4
    end
    object CB_Columns: TComboBox
      Left = 8
      Top = 213
      Width = 145
      Height = 20
      Style = csDropDownList
      ImeMode = imClose
      ItemHeight = 12
      TabOrder = 5
      OnChange = CB_ColumnsChange
    end
    object StaticText11: TStaticText
      Left = 232
      Top = 201
      Width = 61
      Height = 16
      Caption = #12487#12540#12479#25351#23450
      TabOrder = 7
    end
    object ED_Date: TEdit
      Left = 232
      Top = 213
      Width = 145
      Height = 20
      ImeMode = imClose
      TabOrder = 8
    end
    object Button1: TButton
      Left = 448
      Top = 211
      Width = 41
      Height = 25
      Caption = #36861#21152
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
      OnClick = Button1Click
    end
    object StaticText12: TStaticText
      Left = 168
      Top = 9
      Width = 79
      Height = 16
      Caption = #12501#12451#12523#12479#12540#25351#23450
      TabOrder = 11
    end
    object Memo2: TMemo
      Left = 168
      Top = 23
      Width = 273
      Height = 170
      ImeMode = imClose
      ScrollBars = ssVertical
      TabOrder = 12
    end
    object Button5: TButton
      Left = 448
      Top = 136
      Width = 105
      Height = 25
      Caption = #12501#12451#12523#12479#12540#23455#34892
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 13
      OnClick = Button5Click
    end
    object Button7: TButton
      Left = 448
      Top = 168
      Width = 105
      Height = 25
      Caption = #12501#12451#12523#12479#12540#35299#38500
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 14
      OnClick = Button7Click
    end
    object StaticText13: TStaticText
      Left = 168
      Top = 201
      Width = 52
      Height = 16
      Caption = #26465#20214#25351#23450
      TabOrder = 15
    end
    object CB_Jyouken2: TComboBox
      Left = 168
      Top = 213
      Width = 57
      Height = 20
      Style = csDropDownList
      ImeMode = imClose
      ItemHeight = 12
      TabOrder = 16
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 129
    Width = 983
    Height = 275
    ActivePage = TabSheet2
    Align = alTop
    TabOrder = 1
    object TabSheet2: TTabSheet
      Caption = #12458#12540#12480#12513#12452#12531
      ImageIndex = 1
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText2: TStaticText
          Left = 4
          Top = 4
          Width = 967
          Height = 16
          Align = alTop
          Caption = #12458#12540#12480#12513#12452#12531
          TabOrder = 0
          OnClick = StaticText2Click
        end
        object DBGrid1: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource2
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
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
      Caption = #12458#12540#12480#37096#20301
      ImageIndex = 2
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText4: TStaticText
          Left = 4
          Top = 4
          Width = 62
          Height = 16
          Align = alTop
          Caption = #12458#12540#12480#37096#20301
          TabOrder = 0
          OnClick = StaticText4Click
        end
        object DBGrid4: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource4
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = #12458#12540#12480#25351#31034
      ImageIndex = 4
      object Panel12: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText6: TStaticText
          Left = 4
          Top = 4
          Width = 62
          Height = 16
          Align = alTop
          Caption = #12458#12540#12480#25351#31034
          TabOrder = 0
          OnClick = StaticText6Click
        end
        object DBGrid6: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 139
          Align = alTop
          DataSource = DataSource5
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
        object Memo1: TMemo
          Left = 4
          Top = 159
          Width = 967
          Height = 51
          Align = alClient
          TabOrder = 2
        end
        object Panel8: TPanel
          Left = 4
          Top = 210
          Width = 967
          Height = 34
          Align = alBottom
          BevelOuter = bvNone
          TabOrder = 3
          object BitBtn3: TBitBtn
            Left = 696
            Top = 5
            Width = 121
            Height = 25
            Caption = #26908#26619#30446#30340#35501#12415#36796#12415
            TabOrder = 0
            OnClick = BitBtn3Click
          end
          object BitBtn8: TBitBtn
            Left = 840
            Top = 5
            Width = 113
            Height = 25
            Caption = #33256#24202#35386#26029#35501#12415#36796#12415
            TabOrder = 1
            OnClick = BitBtn8Click
          end
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = #24739#32773
      ImageIndex = 5
      object Panel13: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText7: TStaticText
          Left = 4
          Top = 4
          Width = 28
          Height = 16
          Align = alTop
          Caption = #24739#32773
          TabOrder = 0
          OnClick = StaticText7Click
        end
        object DBGrid7: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource6
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
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
      Caption = #21463#20449#12525#12464
      ImageIndex = 6
      object Panel4: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object DBGrid2: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource7
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          TabOrder = 0
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
        object StaticText8: TStaticText
          Left = 4
          Top = 4
          Width = 49
          Height = 16
          Align = alTop
          Caption = #21463#20449#12525#12464
          TabOrder = 1
          OnClick = StaticText8Click
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = #25313#24373#12458#12540#12480#24773#22577
      ImageIndex = 5
      object Panel6: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText1: TStaticText
          Left = 4
          Top = 4
          Width = 86
          Height = 16
          Align = alTop
          Caption = #25313#24373#12458#12540#12480#24773#22577
          TabOrder = 0
          OnClick = StaticText1Click
        end
        object DBGrid3: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource1
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
    object TabSheet8: TTabSheet
      Caption = #12458#12540#12480#12471#12455#12540#12510#24773#22577
      ImageIndex = 7
      object Panel11: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText15: TStaticText
          Left = 4
          Top = 4
          Width = 105
          Height = 16
          Align = alTop
          Caption = #12458#12540#12480#12471#12455#12540#12510#24773#22577
          TabOrder = 0
          OnClick = StaticText15Click
        end
        object DBGrid8: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource9
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
    object TabSheet9: TTabSheet
      Caption = #23455#32318#12513#12452#12531
      ImageIndex = 8
      object Panel14: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText16: TStaticText
          Left = 4
          Top = 4
          Width = 57
          Height = 16
          Align = alTop
          Caption = #23455#32318#12513#12452#12531
          TabOrder = 0
          OnClick = StaticText16Click
        end
        object DBGrid9: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource3
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
    object TabSheet10: TTabSheet
      Caption = #25152#35211#26908#26619#24773#22577
      ImageIndex = 9
      object Panel15: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText17: TStaticText
          Left = 4
          Top = 4
          Width = 52
          Height = 16
          Align = alTop
          Caption = #26908#26619#24773#22577
          TabOrder = 0
          OnClick = StaticText17Click
        end
        object DBGrid10: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource10
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
    object TabSheet11: TTabSheet
      Caption = #12524#12509#12540#12488#24773#22577
      ImageIndex = 10
      object Panel16: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText18: TStaticText
          Left = 4
          Top = 4
          Width = 69
          Height = 16
          Align = alTop
          Caption = #12524#12509#12540#12488#24773#22577
          TabOrder = 0
          OnClick = StaticText18Click
        end
        object DBGrid11: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource11
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
    object TabSheet12: TTabSheet
      Caption = #24739#32773
      ImageIndex = 11
      object Panel17: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText19: TStaticText
          Left = 4
          Top = 4
          Width = 52
          Height = 16
          Align = alTop
          Caption = #24739#32773#24773#22577
          TabOrder = 0
          OnClick = StaticText19Click
        end
        object DBGrid12: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource12
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
    object TabSheet13: TTabSheet
      Caption = #27835#30274#12458#12540#12480#12513#12452#12531
      ImageIndex = 12
      object Panel18: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText20: TStaticText
          Left = 4
          Top = 4
          Width = 67
          Height = 16
          Align = alTop
          Caption = #12458#12540#12480#12513#12452#12531
          TabOrder = 0
          OnClick = StaticText20Click
        end
        object DBGrid13: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource13
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
    object TabSheet14: TTabSheet
      Caption = #25313#24373#12458#12540#12480#24773#22577
      ImageIndex = 13
      object Panel19: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText21: TStaticText
          Left = 4
          Top = 4
          Width = 62
          Height = 16
          Align = alTop
          Caption = #25313#24373#12458#12540#12480
          TabOrder = 0
          OnClick = StaticText21Click
        end
        object DBGrid14: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource14
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
    object TabSheet15: TTabSheet
      Caption = #12458#12540#12480#12513#12452#12531'SN'
      ImageIndex = 14
      object Panel20: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText22: TStaticText
          Left = 4
          Top = 4
          Width = 82
          Height = 16
          Align = alTop
          Caption = #12458#12540#12480#12513#12452#12531'SN'
          TabOrder = 0
          OnClick = StaticText22Click
        end
        object DBGrid15: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource15
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
    object TabSheet16: TTabSheet
      Caption = #23455#32318#12513#12452#12531
      ImageIndex = 15
      object Panel21: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText23: TStaticText
          Left = 4
          Top = 4
          Width = 57
          Height = 16
          Align = alTop
          Caption = #23455#32318#12513#12452#12531
          TabOrder = 0
          OnClick = StaticText23Click
        end
        object DBGrid16: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource16
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
    object TabSheet17: TTabSheet
      Caption = #25313#24373#23455#32318#12513#12452#12531
      ImageIndex = 16
      object Panel22: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText24: TStaticText
          Left = 4
          Top = 4
          Width = 81
          Height = 16
          Align = alTop
          Caption = #25313#24373#23455#32318#12513#12452#12531
          TabOrder = 0
          OnClick = StaticText24Click
        end
        object DBGrid17: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource17
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
    object TabSheet18: TTabSheet
      Caption = #24739#32773#24773#22577
      ImageIndex = 17
      object Panel23: TPanel
        Left = 0
        Top = 0
        Width = 975
        Height = 248
        Align = alClient
        BevelInner = bvLowered
        BevelWidth = 2
        TabOrder = 0
        object StaticText25: TStaticText
          Left = 4
          Top = 4
          Width = 52
          Height = 16
          Align = alTop
          Caption = #24739#32773#24773#22577
          TabOrder = 0
          OnClick = StaticText25Click
        end
        object DBGrid18: TDBGrid
          Left = 4
          Top = 20
          Width = 967
          Height = 224
          Align = alClient
          DataSource = DataSource18
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          TabOrder = 1
          TitleFont.Charset = SHIFTJIS_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #65325#65331' '#65328#12468#12471#12483#12463
          TitleFont.Style = []
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 43
    Width = 983
    Height = 86
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 0
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
      TabOrder = 1
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
      TabOrder = 6
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
      TabOrder = 0
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
      TabOrder = 5
      OnClick = BitBtn2Click
    end
    object Panel2: TPanel
      Left = 218
      Top = 52
      Width = 535
      Height = 27
      BevelInner = bvLowered
      TabOrder = 7
      Visible = False
      object Edit3: TEdit
        Left = 142
        Top = 3
        Width = 109
        Height = 20
        Hint = #34892#12525#12483#12463#12434#12363#12369#12427#12486#12540#12502#12523#21517#12434#25351#23450#12375#12414#12377#12290
        ImeMode = imClose
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
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
        TabOrder = 0
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
      Left = 408
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
      TabOrder = 3
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 600
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
      TabOrder = 4
      OnClick = Button4Click
    end
    object Edit2: TEdit
      Left = 544
      Top = 15
      Width = 41
      Height = 20
      Enabled = False
      TabOrder = 8
    end
    object StaticText5: TStaticText
      Left = 504
      Top = 19
      Width = 35
      Height = 16
      Caption = #12509#12540#12488
      TabOrder = 9
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
      TabOrder = 2
      OnClick = Button6Click
    end
    object Button9: TButton
      Left = 312
      Top = 12
      Width = 89
      Height = 27
      Caption = #12509#12540#12488#21462#24471
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
      OnClick = Button9Click
    end
  end
  object Panel10: TPanel
    Left = 112
    Top = 408
    Width = 169
    Height = 49
    BevelInner = bvLowered
    TabOrder = 3
    object Button2: TButton
      Left = 4
      Top = 14
      Width = 117
      Height = 25
      Caption = #12487#12540#12479#21066#38500
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
      Left = 124
      Top = 16
      Width = 37
      Height = 20
      TabOrder = 1
      Text = '10'
    end
  end
  object mem_msg: TMemo
    Left = 579
    Top = 408
    Width = 401
    Height = 305
    ScrollBars = ssBoth
    TabOrder = 5
    WantReturns = False
    WordWrap = False
  end
  object BitBtn7: TBitBtn
    Left = 466
    Top = 410
    Width = 103
    Height = 47
    Caption = #21463#20449#24739#32773#38651#25991
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
    OnClick = BitBtn7Click
  end
  object Button11: TButton
    Left = 8
    Top = 410
    Width = 97
    Height = 47
    Caption = #20877#35501#12415#36796#12415
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Button11Click
  end
  object Button8: TButton
    Left = 320
    Top = 410
    Width = 103
    Height = 47
    Caption = 'Memo'#35501#12415#36796#12415
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    OnClick = Button8Click
  end
  object DataSource1: TDataSource
    DataSet = Tbl_EXTENDORDERINFO
    Left = 352
    Top = 12
  end
  object DataSource2: TDataSource
    DataSet = Tbl_ORDERMAINTABLE
    Left = 72
    Top = 12
  end
  object Tbl_EXTENDORDERINFO: TTable
    DatabaseName = 'Gx2402'
    FieldDefs = <
      item
        Name = 'RIS_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'USER_NO'
        DataType = ftFloat
      end
      item
        Name = 'RIS_HAKKO_TERMINAL'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'RIS_HAKKO_USER'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'HIS_HAKKO_DATE'
        DataType = ftDateTime
      end
      item
        Name = 'HIS_HAKKO_TERMINAL'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'HIS_HAKKO_USER'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'HIS_UPDATE_DATE'
        DataType = ftDateTime
      end
      item
        Name = 'RI_ORDER_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'RI_ORDER_NO'
        DataType = ftString
        Size = 16
      end
      item
        Name = 'SATUEI_PLACE'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'YOTEIKAIKEI_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'ISITATIAI_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'DENPYO_INSATU_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'KENZOKINKYUU_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'PORTABLE_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'KANJA_SYOKAI_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'SIKYU_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'SEISAN_DATE'
        DataType = ftDateTime
      end
      item
        Name = 'SEISAN_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'SEISAN_KBN_DATE'
        DataType = ftDateTime
      end
      item
        Name = 'DOUISHO_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'ADDENDUM01'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM02'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM03'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM04'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM05'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM06'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM07'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM08'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM09'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM10'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM11'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM12'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM13'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM14'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM15'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM16'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM17'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM18'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM19'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'ADDENDUM20'
        DataType = ftString
        Size = 20
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009517'
        Fields = 'RIS_ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'EXTENDORDERINFO'
    Left = 324
    Top = 12
  end
  object Tbl_ORDERMAINTABLE: TTable
    DatabaseName = 'Gx2402'
    SessionName = 'Default'
    FieldDefs = <
      item
        Name = 'RIS_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'SYSTEMKBN'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'STUDYINSTANCEUID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'ORDERNO'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'ACCESSIONNO'
        DataType = ftString
        Size = 16
      end
      item
        Name = 'KENSA_DATE'
        DataType = ftFloat
      end
      item
        Name = 'KENSA_STARTTIME'
        DataType = ftFloat
      end
      item
        Name = 'KENSATYPE_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSASITU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSAKIKI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SYOTISITU_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'KANJA_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_DATE_AGE'
        DataType = ftFloat
      end
      item
        Name = 'DENPYO_NYUGAIKBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'DENPYO_BYOUTOU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'DENPYO_BYOSITU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'IRAI_SECTION_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'IRAI_DOCTOR_NAME'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'IRAI_DOCTOR_NO'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'ORDER_SECTION_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'IRAI_DOCTOR_RENRAKU'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'DOKUEI_FLG'
        DataType = ftString
        Size = 2
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009515'
        Fields = 'RIS_ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'ORDERMAINTABLE'
    Left = 44
    Top = 12
  end
  object Tbl_ORDERBUITABLE: TTable
    DatabaseName = 'Gx2402'
    FieldDefs = <
      item
        Name = 'RIS_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'NO'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'BUISET_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'BUI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'HOUKOU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SAYUU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSAHOUHOU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'BUICOMMENT_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'BUICOMMENT'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'BUIORDER_NO'
        DataType = ftString
        Size = 18
      end
      item
        Name = 'KENSASITU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSAKIKI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'ADDENDUM01'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM02'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM03'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM04'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM05'
        DataType = ftString
        Size = 60
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009524'
        Fields = 'RIS_ID;NO'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'ORDERBUITABLE'
    Left = 100
    Top = 12
  end
  object DataSource4: TDataSource
    DataSet = Tbl_ORDERBUITABLE
    Left = 128
    Top = 12
  end
  object Tbl_ORDERINDICATETABLE: TTable
    DatabaseName = 'Gx2402'
    FieldDefs = <
      item
        Name = 'RIS_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'ORDERCOMMENT_ID'
        DataType = ftMemo
        Size = 256
      end
      item
        Name = 'KENSA_SIJI'
        DataType = ftMemo
        Size = 2000
      end
      item
        Name = 'RINSYOU'
        DataType = ftMemo
        Size = 2000
      end
      item
        Name = 'REMARKS'
        DataType = ftMemo
        Size = 2000
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009519'
        Fields = 'RIS_ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'ORDERINDICATETABLE'
    Left = 156
    Top = 12
  end
  object DataSource5: TDataSource
    DataSet = Tbl_ORDERINDICATETABLE
    Left = 184
    Top = 12
  end
  object Tbl_KANJAMASTER: TTable
    DatabaseName = 'Gx2402'
    FieldDefs = <
      item
        Name = 'KANJA_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KANJISIMEI'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'ROMASIMEI'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KANASIMEI'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'BIRTHDAY'
        DataType = ftFloat
      end
      item
        Name = 'SEX'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'JUSYO1'
        DataType = ftMemo
        Size = 256
      end
      item
        Name = 'JUSYO2'
        DataType = ftMemo
        Size = 256
      end
      item
        Name = 'JUSYO3'
        DataType = ftMemo
        Size = 256
      end
      item
        Name = 'KANJA_NYUGAIKBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'SECTION_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'BYOUTOU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'BYOUSITU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'TALL'
        DataType = ftFloat
      end
      item
        Name = 'WEIGHT'
        DataType = ftFloat
      end
      item
        Name = 'BLOOD'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'TRANSPORTTYPE'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'HANDICAPPEDMARK'
        DataType = ftFloat
      end
      item
        Name = 'HANDICAPPED'
        DataType = ftMemo
        Size = 256
      end
      item
        Name = 'INFECTIONMARK'
        DataType = ftFloat
      end
      item
        Name = 'INFECTION'
        DataType = ftMemo
        Size = 256
      end
      item
        Name = 'CONTRAINDICATIONMARK'
        DataType = ftFloat
      end
      item
        Name = 'CONTRAINDICATION'
        DataType = ftMemo
        Size = 256
      end
      item
        Name = 'ALLERGYMARK'
        DataType = ftFloat
      end
      item
        Name = 'ALLERGY'
        DataType = ftMemo
        Size = 256
      end
      item
        Name = 'PREGNANCYMARK'
        DataType = ftFloat
      end
      item
        Name = 'PREGNANCY'
        DataType = ftMemo
        Size = 256
      end
      item
        Name = 'NOTESMARK'
        DataType = ftFloat
      end
      item
        Name = 'NOTES'
        DataType = ftMemo
        Size = 256
      end
      item
        Name = 'EXAMDATA'
        DataType = ftMemo
        Size = 256
      end
      item
        Name = 'EXTRAPROFILE'
        DataType = ftMemo
        Size = 2000
      end
      item
        Name = 'HIS_UPDATEDATE'
        DataType = ftDateTime
      end
      item
        Name = 'RIS_UPDATEDATE'
        DataType = ftDateTime
      end
      item
        Name = 'DEATHDATE'
        DataType = ftDateTime
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009508'
        Fields = 'KANJA_ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'PATIENTINFO'
    Left = 212
    Top = 12
  end
  object DataSource6: TDataSource
    DataSet = Tbl_KANJAMASTER
    Left = 240
    Top = 12
  end
  object Tbl_JUSINORDERTABLE: TTable
    DatabaseName = 'Gx2402'
    FieldDefs = <
      item
        Name = 'RECIEVEID'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'RECIEVEDATE'
        Attributes = [faRequired]
        DataType = ftDateTime
      end
      item
        Name = 'MESSAGETYPE'
        DataType = ftString
        Size = 4
      end
      item
        Name = 'RIS_ID'
        DataType = ftString
        Size = 16
      end
      item
        Name = 'MESSAGEID1'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'MESSAGEID2'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'RECIEVETEXT'
        DataType = ftMemo
        Size = 1
      end>
    IndexDefs = <
      item
        Name = 'IDX_FROMHISINFO1'
        Fields = 'RECIEVEDATE'
      end
      item
        Name = 'SYS_C009565'
        Fields = 'RECIEVEID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'FROMHISINFO'
    Left = 268
    Top = 12
  end
  object DataSource7: TDataSource
    DataSet = Tbl_JUSINORDERTABLE
    Left = 296
    Top = 12
  end
  object Tbl_ORDERBUIDETAILTABLE: TTable
    DatabaseName = 'Gx2402'
    FieldDefs = <
      item
        Name = 'RIS_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'BUI_NO'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'NO'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'ADDENDUM01'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM02'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM03'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM04'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM05'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM06'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM07'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM08'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM09'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM10'
        DataType = ftString
        Size = 60
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009528'
        Fields = 'RIS_ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'ORDERBUIDETAILTABLE'
    Left = 380
    Top = 12
  end
  object DataSource8: TDataSource
    DataSet = Tbl_ORDERBUIDETAILTABLE
    Left = 408
    Top = 12
  end
  object Tbl_ORDERSHEMAINFO: TTable
    DatabaseName = 'Gx2402'
    FieldDefs = <
      item
        Name = 'RIS_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'BUI_NO'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'NO'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'ADDENDUM01'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM02'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM03'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM04'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM05'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM06'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM07'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM08'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM09'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ADDENDUM10'
        DataType = ftString
        Size = 60
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009528'
        Fields = 'RIS_ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'ORDERSHEMAINFO'
    Left = 436
    Top = 12
  end
  object DataSource9: TDataSource
    DataSet = Tbl_ORDERSHEMAINFO
    Left = 464
    Top = 12
  end
  object Tbl_EXMAINTABLE: TTable
    DatabaseName = 'Gx2402'
    FieldDefs = <
      item
        Name = 'RIS_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'KENSATYPE_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSA_DATE'
        DataType = ftFloat
      end
      item
        Name = 'KENSASITU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSAKIKI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KANJA_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_DATE_AGE'
        DataType = ftFloat
      end
      item
        Name = 'DENPYO_NYUGAIKBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'UKETUKE_TANTOU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'UKETUKE_TANTOU_NAME'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RECEIPTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'RECEIPTTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'KENSA_GISI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_GISI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'EXAMSTARTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMENDDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'STARTNUMBER'
        DataType = ftFloat
      end
      item
        Name = 'KANGOSI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KANGOSI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'KENSAI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSAI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'BIKOU'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RENRAKU_MEMO'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'SIJI_ISI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SIJI_ISI_NAME'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'SIJI_ISI_COMMENT'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'TOUSITIME'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'BAKUSYASUU'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'GYOUMU_KBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'STATUS'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'RECEIPTFLAG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'YUUSEN_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'EXAMSAVEFLAG'
        DataType = ftString
        Size = 2
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009532'
        Fields = 'RIS_ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'EXMAINTABLE'
    Left = 492
    Top = 12
  end
  object DataSource3: TDataSource
    DataSet = Tbl_EXMAINTABLE
    Left = 520
    Top = 12
  end
  object Tbl_EXAMINFO: TTable
    DatabaseName = 'gx26072'
    FieldDefs = <
      item
        Name = 'ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'HSPID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'PATID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KANA'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'ROMA'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KANJI'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'SEX'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'BIRTHDAY'
        DataType = ftDateTime
      end
      item
        Name = 'AGE'
        DataType = ftFloat
      end
      item
        Name = 'EXAMDATE'
        Attributes = [faRequired]
        DataType = ftDateTime
      end
      item
        Name = 'MODALITY'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'LOCUS'
        DataType = ftMemo
        Size = 2048
      end
      item
        Name = 'DETAILLOCUS'
        DataType = ftMemo
        Size = 2048
      end
      item
        Name = 'REQUESTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'REQUESTSECTION'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'REQUESTDOCTOR'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'INOUTPATIENT'
        DataType = ftFloat
      end
      item
        Name = 'WARD'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'PURPOSE'
        DataType = ftMemo
        Size = 2000
      end
      item
        Name = 'DIAGNOSIS'
        DataType = ftMemo
        Size = 2000
      end
      item
        Name = 'BOOKMARK1'
        DataType = ftMemo
        Size = 2000
      end
      item
        Name = 'BOOKMARK2'
        DataType = ftMemo
        Size = 2000
      end
      item
        Name = 'REMARKS'
        DataType = ftMemo
        Size = 2000
      end
      item
        Name = 'SERVER'
        DataType = ftFloat
      end
      item
        Name = 'ODRID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'RPTID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'STATUS'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'EXAMROOM'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'DIRECTION'
        DataType = ftMemo
        Size = 2048
      end
      item
        Name = 'REQUIRE'
        DataType = ftMemo
        Size = 400
      end
      item
        Name = 'MEDICINE'
        DataType = ftMemo
        Size = 1000
      end
      item
        Name = 'INDICATE'
        DataType = ftMemo
        Size = 1000
      end
      item
        Name = 'REQCOMMENT'
        DataType = ftMemo
        Size = 1000
      end
      item
        Name = 'READFLG'
        DataType = ftFloat
      end
      item
        Name = 'READEMGFLG'
        DataType = ftFloat
      end
      item
        Name = 'STUDYINSTANCEUID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'REFERREDFLG'
        DataType = ftFloat
      end
      item
        Name = 'TALL'
        DataType = ftFloat
      end
      item
        Name = 'WEIGHT'
        DataType = ftFloat
      end
      item
        Name = 'INDICATEDR'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'CHARGEDR'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'CHARGENS'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'ENFORCETC'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'GROUPTYPE'
        DataType = ftFloat
      end
      item
        Name = 'KENSAHOUHOU'
        DataType = ftMemo
        Size = 2048
      end
      item
        Name = 'SAYUU'
        DataType = ftMemo
        Size = 2048
      end
      item
        Name = 'ACNO'
        DataType = ftString
        Size = 16
      end
      item
        Name = 'PATREMARKS'
        DataType = ftMemo
        Size = 2000
      end
      item
        Name = 'ORDERSECTION'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'HANDICAPPEDMARK'
        DataType = ftFloat
      end
      item
        Name = 'HANDICAPPED'
        DataType = ftMemo
        Size = 256
      end
      item
        Name = 'INFECTIONMARK'
        DataType = ftFloat
      end
      item
        Name = 'INFECTION'
        DataType = ftMemo
        Size = 256
      end
      item
        Name = 'CONTRAINDICATIONMARK'
        DataType = ftFloat
      end
      item
        Name = 'CONTRAINDICATION'
        DataType = ftMemo
        Size = 256
      end
      item
        Name = 'PREGNANCYMARK'
        DataType = ftFloat
      end
      item
        Name = 'PREGNANCY'
        DataType = ftMemo
        Size = 256
      end
      item
        Name = 'NOTES'
        DataType = ftMemo
        Size = 256
      end>
    IndexDefs = <
      item
        Name = 'IDX_EXAMINFO2'
        Fields = 'EXAMDATE'
      end
      item
        Name = 'IDX_EXAMINFO4'
        Fields = 'PATID'
      end
      item
        Name = 'IDX_EXAMINFO5'
        Fields = 'RPTID'
      end
      item
        Name = 'SYS_C0045690'
        Fields = 'ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'EXAMINFO'
    Left = 548
    Top = 12
  end
  object DataSource10: TDataSource
    DataSet = Tbl_EXAMINFO
    Left = 576
    Top = 12
  end
  object Tbl_REPORTINFO: TTable
    DatabaseName = 'gx26072'
    FieldDefs = <
      item
        Name = 'RIS_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'KENSATYPE_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSA_DATE'
        DataType = ftFloat
      end
      item
        Name = 'KENSASITU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSAKIKI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KANJA_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_DATE_AGE'
        DataType = ftFloat
      end
      item
        Name = 'DENPYO_NYUGAIKBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'UKETUKE_TANTOU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'UKETUKE_TANTOU_NAME'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RECEIPTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'RECEIPTTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'KENSA_GISI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_GISI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'EXAMSTARTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMENDDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'STARTNUMBER'
        DataType = ftFloat
      end
      item
        Name = 'KANGOSI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KANGOSI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'KENSAI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSAI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'BIKOU'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RENRAKU_MEMO'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'SIJI_ISI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SIJI_ISI_NAME'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'SIJI_ISI_COMMENT'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'TOUSITIME'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'BAKUSYASUU'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'GYOUMU_KBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'STATUS'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'RECEIPTFLAG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'YUUSEN_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'EXAMSAVEFLAG'
        DataType = ftString
        Size = 2
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009532'
        Fields = 'RIS_ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'REPORTINFO'
    Left = 604
    Top = 12
  end
  object DataSource11: TDataSource
    DataSet = Tbl_REPORTINFO
    Left = 632
    Top = 12
  end
  object Tbl_RepPATIENTINFO: TTable
    DatabaseName = 'gx26072'
    FieldDefs = <
      item
        Name = 'RIS_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'KENSATYPE_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSA_DATE'
        DataType = ftFloat
      end
      item
        Name = 'KENSASITU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSAKIKI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KANJA_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_DATE_AGE'
        DataType = ftFloat
      end
      item
        Name = 'DENPYO_NYUGAIKBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'UKETUKE_TANTOU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'UKETUKE_TANTOU_NAME'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RECEIPTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'RECEIPTTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'KENSA_GISI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_GISI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'EXAMSTARTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMENDDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'STARTNUMBER'
        DataType = ftFloat
      end
      item
        Name = 'KANGOSI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KANGOSI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'KENSAI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSAI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'BIKOU'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RENRAKU_MEMO'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'SIJI_ISI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SIJI_ISI_NAME'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'SIJI_ISI_COMMENT'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'TOUSITIME'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'BAKUSYASUU'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'GYOUMU_KBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'STATUS'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'RECEIPTFLAG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'YUUSEN_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'EXAMSAVEFLAG'
        DataType = ftString
        Size = 2
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009532'
        Fields = 'RIS_ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'PATIENTINFO'
    Left = 660
    Top = 12
  end
  object DataSource12: TDataSource
    DataSet = Tbl_RepPATIENTINFO
    Left = 688
    Top = 12
  end
  object Tbl_RTORDERMAINTABLE: TTable
    DatabaseName = 'gx26072'
    FieldDefs = <
      item
        Name = 'RIS_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'KENSATYPE_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSA_DATE'
        DataType = ftFloat
      end
      item
        Name = 'KENSASITU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSAKIKI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KANJA_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_DATE_AGE'
        DataType = ftFloat
      end
      item
        Name = 'DENPYO_NYUGAIKBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'UKETUKE_TANTOU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'UKETUKE_TANTOU_NAME'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RECEIPTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'RECEIPTTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'KENSA_GISI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_GISI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'EXAMSTARTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMENDDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'STARTNUMBER'
        DataType = ftFloat
      end
      item
        Name = 'KANGOSI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KANGOSI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'KENSAI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSAI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'BIKOU'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RENRAKU_MEMO'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'SIJI_ISI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SIJI_ISI_NAME'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'SIJI_ISI_COMMENT'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'TOUSITIME'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'BAKUSYASUU'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'GYOUMU_KBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'STATUS'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'RECEIPTFLAG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'YUUSEN_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'EXAMSAVEFLAG'
        DataType = ftString
        Size = 2
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009532'
        Fields = 'RIS_ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'MIYAZAKI_RRIS.ORDERMAINTABLE'
    Left = 716
    Top = 12
  end
  object DataSource13: TDataSource
    DataSet = Tbl_RTORDERMAINTABLE
    Left = 744
    Top = 12
  end
  object Tbl_ORDERMAIN_EXTEND_TABLE: TTable
    DatabaseName = 'gx26072'
    FieldDefs = <
      item
        Name = 'RIS_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'KENSATYPE_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSA_DATE'
        DataType = ftFloat
      end
      item
        Name = 'KENSASITU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSAKIKI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KANJA_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_DATE_AGE'
        DataType = ftFloat
      end
      item
        Name = 'DENPYO_NYUGAIKBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'UKETUKE_TANTOU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'UKETUKE_TANTOU_NAME'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RECEIPTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'RECEIPTTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'KENSA_GISI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_GISI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'EXAMSTARTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMENDDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'STARTNUMBER'
        DataType = ftFloat
      end
      item
        Name = 'KANGOSI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KANGOSI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'KENSAI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSAI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'BIKOU'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RENRAKU_MEMO'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'SIJI_ISI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SIJI_ISI_NAME'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'SIJI_ISI_COMMENT'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'TOUSITIME'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'BAKUSYASUU'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'GYOUMU_KBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'STATUS'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'RECEIPTFLAG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'YUUSEN_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'EXAMSAVEFLAG'
        DataType = ftString
        Size = 2
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009532'
        Fields = 'RIS_ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'MIYAZAKI_RTRIS.ORDERMAIN_EXTEND_TABLE'
    Left = 772
    Top = 12
  end
  object DataSource14: TDataSource
    DataSet = Tbl_ORDERMAIN_EXTEND_TABLE
    Left = 800
    Top = 12
  end
  object Tbl_ORDERMAIN_SN_TABLE: TTable
    DatabaseName = 'gx26072'
    FieldDefs = <
      item
        Name = 'RIS_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'KENSATYPE_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSA_DATE'
        DataType = ftFloat
      end
      item
        Name = 'KENSASITU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSAKIKI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KANJA_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_DATE_AGE'
        DataType = ftFloat
      end
      item
        Name = 'DENPYO_NYUGAIKBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'UKETUKE_TANTOU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'UKETUKE_TANTOU_NAME'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RECEIPTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'RECEIPTTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'KENSA_GISI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_GISI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'EXAMSTARTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMENDDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'STARTNUMBER'
        DataType = ftFloat
      end
      item
        Name = 'KANGOSI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KANGOSI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'KENSAI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSAI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'BIKOU'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RENRAKU_MEMO'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'SIJI_ISI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SIJI_ISI_NAME'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'SIJI_ISI_COMMENT'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'TOUSITIME'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'BAKUSYASUU'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'GYOUMU_KBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'STATUS'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'RECEIPTFLAG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'YUUSEN_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'EXAMSAVEFLAG'
        DataType = ftString
        Size = 2
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009532'
        Fields = 'RIS_ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'MIYAZAKI_RTRIS.ORDERMAIN_SN_TABLE'
    Left = 828
    Top = 12
  end
  object DataSource15: TDataSource
    DataSet = Tbl_ORDERMAIN_SN_TABLE
    Left = 856
    Top = 12
  end
  object Tbl_RTEXMAINTABLE: TTable
    DatabaseName = 'gx26072'
    FieldDefs = <
      item
        Name = 'RIS_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'KENSATYPE_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSA_DATE'
        DataType = ftFloat
      end
      item
        Name = 'KENSASITU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSAKIKI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KANJA_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_DATE_AGE'
        DataType = ftFloat
      end
      item
        Name = 'DENPYO_NYUGAIKBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'UKETUKE_TANTOU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'UKETUKE_TANTOU_NAME'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RECEIPTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'RECEIPTTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'KENSA_GISI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_GISI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'EXAMSTARTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMENDDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'STARTNUMBER'
        DataType = ftFloat
      end
      item
        Name = 'KANGOSI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KANGOSI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'KENSAI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSAI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'BIKOU'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RENRAKU_MEMO'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'SIJI_ISI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SIJI_ISI_NAME'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'SIJI_ISI_COMMENT'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'TOUSITIME'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'BAKUSYASUU'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'GYOUMU_KBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'STATUS'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'RECEIPTFLAG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'YUUSEN_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'EXAMSAVEFLAG'
        DataType = ftString
        Size = 2
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009532'
        Fields = 'RIS_ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'MIYAZAKI_RRIS.EXMAINTABLE'
    Left = 884
    Top = 12
  end
  object DataSource16: TDataSource
    DataSet = Tbl_RTEXMAINTABLE
    Left = 912
    Top = 12
  end
  object Tbl_EXMAIN_EXTEND_TABLE: TTable
    DatabaseName = 'gx26072'
    FieldDefs = <
      item
        Name = 'RIS_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'KENSATYPE_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSA_DATE'
        DataType = ftFloat
      end
      item
        Name = 'KENSASITU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSAKIKI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KANJA_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_DATE_AGE'
        DataType = ftFloat
      end
      item
        Name = 'DENPYO_NYUGAIKBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'UKETUKE_TANTOU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'UKETUKE_TANTOU_NAME'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RECEIPTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'RECEIPTTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'KENSA_GISI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_GISI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'EXAMSTARTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMENDDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'STARTNUMBER'
        DataType = ftFloat
      end
      item
        Name = 'KANGOSI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KANGOSI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'KENSAI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSAI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'BIKOU'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RENRAKU_MEMO'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'SIJI_ISI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SIJI_ISI_NAME'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'SIJI_ISI_COMMENT'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'TOUSITIME'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'BAKUSYASUU'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'GYOUMU_KBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'STATUS'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'RECEIPTFLAG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'YUUSEN_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'EXAMSAVEFLAG'
        DataType = ftString
        Size = 2
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009532'
        Fields = 'RIS_ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'MIYAZAKI_RTRIS.EXMAIN_EXTEND_TABLE'
    Left = 716
    Top = 40
  end
  object DataSource17: TDataSource
    DataSet = Tbl_EXMAIN_EXTEND_TABLE
    Left = 744
    Top = 40
  end
  object Tbl_RTPATIENTINFO: TTable
    DatabaseName = 'gx26072'
    FieldDefs = <
      item
        Name = 'RIS_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 16
      end
      item
        Name = 'KENSATYPE_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSA_DATE'
        DataType = ftFloat
      end
      item
        Name = 'KENSASITU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KENSAKIKI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'KANJA_ID'
        Attributes = [faRequired]
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_DATE_AGE'
        DataType = ftFloat
      end
      item
        Name = 'DENPYO_NYUGAIKBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'UKETUKE_TANTOU_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'UKETUKE_TANTOU_NAME'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RECEIPTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'RECEIPTTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'KENSA_GISI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSA_GISI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'EXAMSTARTDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMENDDATE'
        DataType = ftDateTime
      end
      item
        Name = 'EXAMTERMINALID'
        DataType = ftFloat
      end
      item
        Name = 'STARTNUMBER'
        DataType = ftFloat
      end
      item
        Name = 'KANGOSI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KANGOSI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'KENSAI_ID'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'KENSAI_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'BIKOU'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'RENRAKU_MEMO'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'SIJI_ISI_ID'
        DataType = ftString
        Size = 10
      end
      item
        Name = 'SIJI_ISI_NAME'
        DataType = ftString
        Size = 64
      end
      item
        Name = 'SIJI_ISI_COMMENT'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'TOUSITIME'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'BAKUSYASUU'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'GYOUMU_KBN'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'STATUS'
        Attributes = [faRequired]
        DataType = ftFloat
      end
      item
        Name = 'RECEIPTFLAG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'YUUSEN_FLG'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'EXAMSAVEFLAG'
        DataType = ftString
        Size = 2
      end>
    IndexDefs = <
      item
        Name = 'SYS_C009532'
        Fields = 'RIS_ID'
        Options = [ixUnique]
      end>
    StoreDefs = True
    TableName = 'MIYAZAKI_RRIS.PATIENTINFO'
    Left = 772
    Top = 40
  end
  object DataSource18: TDataSource
    DataSet = Tbl_RTPATIENTINFO
    Left = 800
    Top = 40
  end
end
