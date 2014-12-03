object fUpdateNotification: TfUpdateNotification
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Update available!'
  ClientHeight = 244
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lb01: TLabel
    Left = 24
    Top = 16
    Width = 301
    Height = 19
    Caption = 'There is an update available for download!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lb02: TLabel
    Left = 40
    Top = 64
    Width = 121
    Height = 16
    Caption = 'Your current version:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lb03: TLabel
    Left = 40
    Top = 96
    Width = 181
    Height = 16
    Caption = 'Version available for download:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lb04: TLabel
    Tag = -999
    Left = 240
    Top = 62
    Width = 40
    Height = 18
    Caption = '0.0.1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lb05: TLabel
    Tag = -999
    Left = 240
    Top = 94
    Width = 40
    Height = 18
    Caption = '1.0.0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lb06: TLabel
    Left = 24
    Top = 152
    Width = 128
    Height = 19
    Caption = 'Download it now?'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btnNo: TSpeedButton
    Left = 40
    Top = 184
    Width = 150
    Height = 40
    Caption = 'No, thanks'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = btnNoClick
  end
  object btnYes: TSpeedButton
    Left = 196
    Top = 184
    Width = 150
    Height = 40
    Caption = 'Yes, download it'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = btnYesClick
  end
  object lbLink: TLabel
    Left = 223
    Top = 155
    Width = 123
    Height = 16
    Cursor = crHandPoint
    Alignment = taRightJustify
    Caption = 'Show me what'#39's new'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
    ParentFont = False
    OnClick = lbLinkClick
  end
end
