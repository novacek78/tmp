object fRegisteredCode: TfRegisteredCode
  Left = 218
  Top = 254
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Enter your registration code'
  ClientHeight = 162
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 405
    Height = 110
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 15
      Top = 15
      Width = 361
      Height = 31
      AutoSize = False
      Caption = 
        'Enter your registration code, you have received by e-mail after ' +
        'submitting the registration.'
      WordWrap = True
    end
    object edCode: TLabeledEdit
      Left = 15
      Top = 70
      Width = 361
      Height = 21
      Color = clWhite
      Ctl3D = True
      EditLabel.Width = 84
      EditLabel.Height = 13
      EditLabel.Caption = 'Registration code'
      ParentCtl3D = False
      TabOrder = 0
      OnKeyPress = edCodeKeyPress
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 110
    Width = 405
    Height = 52
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      405
      52)
    object btnSave: TSpeedButton
      Left = 325
      Top = 5
      Width = 60
      Height = 40
      Anchors = [akTop, akRight]
      Layout = blGlyphRight
      OnClick = btnSaveClick
    end
    object btnSad: TSpeedButton
      Left = 285
      Top = 13
      Width = 25
      Height = 25
      Hint = 'I haven'#39't found what I needed...'
      Anchors = [akTop, akRight]
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSadClick
    end
  end
end
