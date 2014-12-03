object fToolClone: TfToolClone
  Left = 189
  Top = 179
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Clone tool'
  ClientHeight = 180
  ClientWidth = 335
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 335
    Height = 128
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 305
    object lbOffsetX: TLabel
      Left = 302
      Top = 21
      Width = 16
      Height = 13
      Caption = 'mm'
      Enabled = False
    end
    object lbOffsetY: TLabel
      Left = 302
      Top = 51
      Width = 16
      Height = 13
      Caption = 'mm'
      Enabled = False
    end
    object cbCloneInX: TCheckBox
      Left = 10
      Top = 20
      Width = 121
      Height = 17
      Caption = 'Clone in X axis'
      TabOrder = 0
      OnClick = cbCloneInXClick
    end
    object cbCloneInY: TCheckBox
      Left = 10
      Top = 50
      Width = 121
      Height = 17
      Caption = 'Clone in Y axis'
      TabOrder = 2
      OnClick = cbCloneInYClick
    end
    object edOffsetX: TLabeledEdit
      Left = 229
      Top = 17
      Width = 70
      Height = 21
      EditLabel.Width = 57
      EditLabel.Height = 13
      EditLabel.Caption = 'clone offset'
      Enabled = False
      LabelPosition = lpLeft
      LabelSpacing = 10
      TabOrder = 1
      OnExit = MathExp
      OnKeyPress = DecimalPoint
      OnKeyUp = EditKeyUp
    end
    object edOffsetY: TLabeledEdit
      Left = 229
      Top = 47
      Width = 70
      Height = 21
      EditLabel.Width = 57
      EditLabel.Height = 13
      EditLabel.Caption = 'clone offset'
      Enabled = False
      LabelPosition = lpLeft
      LabelSpacing = 10
      TabOrder = 3
      OnExit = MathExp
      OnKeyPress = DecimalPoint
      OnKeyUp = EditKeyUp
    end
    object btnClone: TBitBtn
      Left = 259
      Top = 75
      Width = 40
      Height = 40
      Enabled = False
      NumGlyphs = 2
      TabOrder = 4
      TabStop = False
      OnClick = btnCloneClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 128
    Width = 335
    Height = 52
    Align = alBottom
    TabOrder = 1
    ExplicitWidth = 305
    DesignSize = (
      335
      52)
    object btnOK: TSpeedButton
      Left = 254
      Top = 5
      Width = 60
      Height = 40
      Anchors = [akTop, akRight]
      Layout = blGlyphRight
      OnClick = btnOKClick
    end
    object btnSad: TSpeedButton
      Left = 215
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
end
