object frm_ServiceLook: Tfrm_ServiceLook
  Left = 116
  Top = 285
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #12469#12540#12499#12473#30435#35222
  ClientHeight = 324
  ClientWidth = 885
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMinimized
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl_Service: TPageControl
    Left = 0
    Top = 0
    Width = 365
    Height = 324
    ActivePage = TabSheet_RisHisSvr_Irai
    Align = alLeft
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    HotTrack = True
    MultiLine = True
    ParentFont = False
    TabHeight = 29
    TabOrder = 0
    OnChange = PageControl_ServiceChange
    object TabSheet_RisHisSvr_Irai: TTabSheet
      Caption = #12458#12540#12480#21463#20449
    end
    object TabSheet_RisHisSD_Receipt: TTabSheet
      Caption = #21463#20184#36865#20449
      ImageIndex = 3
    end
    object TabSheet_RisHisSD_Jissi: TTabSheet
      Caption = #23455#26045#36865#20449
      ImageIndex = 1
    end
    object TabSheet_RisHis_Shema: TTabSheet
      Caption = #12471#12455#12540#12510#21462#24471
      ImageIndex = 2
    end
    object TabSheet_RisArworkSD: TTabSheet
      Caption = 'ARWORK'
      ImageIndex = 7
      TabVisible = False
    end
  end
  object Panel_color: TPanel
    Left = 120
    Top = 104
    Width = 69
    Height = 121
    BevelInner = bvLowered
    Color = clInfoBk
    TabOrder = 1
    object Shape_start: TShape
      Left = 10
      Top = 8
      Width = 49
      Height = 49
      Brush.Color = 10551200
      Shape = stCircle
    end
    object Shape_stop: TShape
      Left = 10
      Top = 64
      Width = 49
      Height = 49
      Brush.Color = 14342874
      Shape = stCircle
    end
    object Panel_start: TPanel
      Left = 64
      Top = 9
      Width = 73
      Height = 79
      BevelInner = bvLowered
      BevelOuter = bvNone
      Color = clBlue
      TabOrder = 0
      Visible = False
    end
    object Panel_stop: TPanel
      Left = 64
      Top = 97
      Width = 73
      Height = 79
      BevelInner = bvLowered
      BevelOuter = bvNone
      Color = clRed
      TabOrder = 1
      Visible = False
    end
  end
  object Button_stop: TButton
    Left = 224
    Top = 176
    Width = 105
    Height = 33
    Caption = #12469#12540#12499#12473#20572#27490
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = Button_stopClick
  end
  object Panel_Massage: TPanel
    Left = 16
    Top = 232
    Width = 337
    Height = 81
    BevelOuter = bvNone
    Enabled = False
    ParentColor = True
    TabOrder = 3
    object Memo_Message: TMemo
      Left = 8
      Top = 20
      Width = 321
      Height = 53
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object Panel5: TPanel
      Left = 8
      Top = 0
      Width = 73
      Height = 17
      BevelOuter = bvNone
      Caption = #12513#12483#12475#12540#12472
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentColor = True
      ParentFont = False
      TabOrder = 1
    end
  end
  object Button_start: TButton
    Left = 224
    Top = 120
    Width = 105
    Height = 33
    Caption = #12469#12540#12499#12473#36215#21205
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = Button_startClick
  end
  object Panel4: TPanel
    Left = 110
    Top = 84
    Width = 89
    Height = 17
    BevelOuter = bvNone
    Caption = #29694#22312#12398#29366#24907
    Enabled = False
    Font.Charset = SHIFTJIS_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
    Font.Style = []
    ParentColor = True
    ParentFont = False
    TabOrder = 5
  end
  object Panel_Syori: TPanel
    Left = 365
    Top = 0
    Width = 135
    Height = 324
    Align = alLeft
    BevelOuter = bvNone
    Color = 13619151
    TabOrder = 6
    object GroupBox1: TGroupBox
      Left = 15
      Top = 56
      Width = 106
      Height = 65
      Caption = #30435#35222#38291#38548
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      object Label1: TLabel
        Left = 80
        Top = 28
        Width = 15
        Height = 15
        Caption = #31186
      end
      object ComboBox_time: TComboBox
        Left = 24
        Top = 24
        Width = 49
        Height = 23
        Style = csDropDownList
        ImeMode = imClose
        ItemHeight = 15
        TabOrder = 0
        OnChange = ComboBox_timeChange
        OnDropDown = ComboBox_timeDropDown
        Items.Strings = (
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23'
          '24'
          '25'
          '26'
          '27'
          '28'
          '29'
          '30'
          '31'
          '32'
          '33'
          '34'
          '35'
          '36'
          '37'
          '38'
          '39'
          '40'
          '41'
          '42'
          '43'
          '44'
          '45'
          '46'
          '47'
          '48'
          '49'
          '50'
          '51'
          '52'
          '53'
          '54'
          '55'
          '56'
          '57'
          '58'
          '59'
          '60'
          '120'
          '180'
          '240'
          '300')
      end
    end
    object GroupBox2: TGroupBox
      Left = 15
      Top = 136
      Width = 106
      Height = 65
      Caption = #12525#12464
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object Button_Log: TButton
        Left = 16
        Top = 24
        Width = 73
        Height = 25
        Hint = #12525#12464#12501#12449#12452#12523#12434#35211#12427
        Caption = #34920#31034
        TabOrder = 0
        OnClick = Button_LogClick
      end
    end
    object Button_close: TButton
      Left = 16
      Top = 272
      Width = 105
      Height = 33
      Caption = #38281#12376#12427
      TabOrder = 2
      OnClick = Button_closeClick
    end
    object BT_Width: TBitBtn
      Left = 96
      Top = 224
      Width = 25
      Height = 25
      Caption = #38283
      TabOrder = 3
      Visible = False
      OnClick = BT_WidthClick
    end
  end
  object Panel2: TPanel
    Left = 370
    Top = 0
    Width = 127
    Height = 31
    BevelOuter = bvNone
    Caption = 'Panel2'
    Color = 13619151
    TabOrder = 7
    object Panel_time: TPanel
      Left = 0
      Top = 5
      Width = 125
      Height = 18
      BevelOuter = bvNone
      Caption = '9999/99/99 99:99:99'
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clActiveCaption
      Font.Height = -13
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = []
      ParentColor = True
      ParentFont = False
      TabOrder = 0
    end
  end
  object Pnl_install: TPanel
    Left = 500
    Top = 0
    Width = 385
    Height = 324
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 8
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = Timer1Timer
    Left = 16
    Top = 72
  end
end
