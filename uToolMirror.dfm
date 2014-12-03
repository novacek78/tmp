object fToolMirror: TfToolMirror
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Mirror tool'
  ClientHeight = 152
  ClientWidth = 396
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 100
    Width = 396
    Height = 52
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 128
    ExplicitWidth = 335
    DesignSize = (
      396
      52)
    object btnOK: TSpeedButton
      Left = 315
      Top = 5
      Width = 60
      Height = 40
      Anchors = [akTop, akRight]
      Layout = blGlyphRight
      OnClick = btnOKClick
      ExplicitLeft = 254
    end
    object btnSad: TSpeedButton
      Left = 276
      Top = 13
      Width = 25
      Height = 25
      Hint = 'I haven'#39't found what I needed...'
      Anchors = [akTop, akRight]
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSadClick
      ExplicitLeft = 185
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 0
    Width = 396
    Height = 100
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 335
    ExplicitHeight = 128
    DesignSize = (
      396
      100)
    object lbNotice: TLabel
      Left = 10
      Top = 57
      Width = 310
      Height = 16
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Select a guideline as mirroring axis please...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 282
    end
    object cbKeepOriginals: TCheckBox
      Left = 10
      Top = 20
      Width = 223
      Height = 17
      Caption = 'Keep original objects'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
  end
end
