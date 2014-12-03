object fOrder: TfOrder
  Left = 137
  Top = 175
  ActiveControl = sg
  Caption = 'Order form'
  ClientHeight = 330
  ClientWidth = 705
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 720
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sg: TStringGrid
    Left = 0
    Top = 52
    Width = 705
    Height = 175
    Align = alClient
    DefaultRowHeight = 21
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowMoving, goRowSelect]
    TabOrder = 0
    OnDblClick = sgDblClick
    OnMouseUp = sgMouseUp
    OnSelectCell = sgSelectCell
    OnTopLeftChanged = sgTopLeftChanged
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 705
    Height = 52
    Align = alTop
    BevelOuter = bvNone
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    DesignSize = (
      705
      52)
    object btnSadOrder: TSpeedButton
      Left = 660
      Top = 12
      Width = 25
      Height = 25
      Hint = 'I haven'#39't found what I needed...'
      Anchors = [akTop, akRight]
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSadOrderClick
    end
    object btnPanelAdd: TSpeedButton
      Left = 5
      Top = 5
      Width = 40
      Height = 40
      Hint = 'Add panel...'
      NumGlyphs = 2
      OnClick = btnPanelAddClick
    end
    object btnGetPrice: TSpeedButton
      Left = 98
      Top = 5
      Width = 39
      Height = 40
      Hint = 'Get the prices'
      Enabled = False
      NumGlyphs = 2
      OnClick = btnGetPriceClick
    end
    object btnDetails: TSpeedButton
      Left = 139
      Top = 5
      Width = 40
      Height = 40
      Hint = 'Detailed price of selected panel...'
      Enabled = False
      NumGlyphs = 2
      OnClick = btnDetailsClick
    end
    object btnOpen: TSpeedButton
      Left = 190
      Top = 5
      Width = 40
      Height = 40
      Hint = 'Open panel in editor'
      Enabled = False
      NumGlyphs = 2
      OnClick = btnOpenClick
    end
    object btnPersonal: TSpeedButton
      Left = 232
      Top = 5
      Width = 40
      Height = 40
      Hint = 'Address and the way of delivery'
      NumGlyphs = 2
      OnClick = btnPersonalClick
    end
    object btnPanelDel: TSpeedButton
      Left = 46
      Top = 5
      Width = 40
      Height = 40
      Hint = 'Remove panel from the list'
      Enabled = False
      NumGlyphs = 2
      OnClick = btnPanelDelClick
    end
    object pnlWait: TPanel
      Left = 375
      Top = 7
      Width = 225
      Height = 37
      BevelOuter = bvNone
      TabOrder = 0
      Visible = False
      DesignSize = (
        225
        37)
      object lbWait: TLabel
        Left = 0
        Top = 0
        Width = 225
        Height = 13
        Alignment = taCenter
        Anchors = [akLeft, akTop, akRight]
        AutoSize = False
        Caption = 'wait please...'
      end
      object barWeb: TProgressBar
        Left = 0
        Top = 19
        Width = 224
        Height = 11
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 227
    Width = 705
    Height = 103
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    DesignSize = (
      705
      103)
    object Label1: TLabel
      Left = 15
      Top = 15
      Width = 93
      Height = 17
      Caption = 'manufacturing'
    end
    object lbVyroba: TLabel
      Tag = -999
      Left = 305
      Top = 15
      Width = 8
      Height = 17
      Alignment = taRightJustify
      Caption = '?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbRezia: TLabel
      Tag = -999
      Left = 305
      Top = 35
      Width = 8
      Height = 17
      Alignment = taRightJustify
      Caption = '?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label4: TLabel
      Left = 15
      Top = 35
      Width = 162
      Height = 17
      Caption = 'packing and freight costs'
    end
    object Label5: TLabel
      Left = 15
      Top = 55
      Width = 27
      Height = 17
      Caption = 'total'
    end
    object lbSpolu: TLabel
      Tag = -999
      Left = 305
      Top = 55
      Width = 8
      Height = 17
      Alignment = taRightJustify
      Caption = '?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 15
      Top = 75
      Width = 86
      Height = 17
      Caption = 'total with VAT'
    end
    object lbSpolusDPH: TLabel
      Tag = -999
      Left = 305
      Top = 75
      Width = 8
      Height = 17
      Alignment = taRightJustify
      Caption = '?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lbFAQ: TLabel
      Left = 482
      Top = 17
      Width = 213
      Height = 14
      Cursor = crHandPoint
      Alignment = taRightJustify
      Anchors = [akTop, akRight]
      Caption = 'Important! Read before sending order!'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsUnderline]
      ParentFont = False
      Visible = False
      OnClick = lbFAQClick
    end
    object btnAttach: TSpeedButton
      Left = 411
      Top = 42
      Width = 51
      Height = 50
      Hint = 'Add comments and files to your order...'
      Anchors = [akTop, akRight]
      Enabled = False
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnAttachClick
    end
    object btnSend: TSpeedButton
      Left = 467
      Top = 42
      Width = 228
      Height = 50
      Hint = 'Order panels'
      Anchors = [akTop, akRight]
      Caption = 'Send the order'
      Enabled = False
      Layout = blGlyphRight
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSendClick
    end
  end
  object ftp: TIdFTP
    OnStatus = ftpStatus
    IPVersion = Id_IPv4
    Passive = True
    TransferType = ftBinary
    NATKeepAlive.UseKeepAlive = False
    NATKeepAlive.IdleTimeMS = 0
    NATKeepAlive.IntervalMS = 0
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 170
    Top = 120
  end
end
