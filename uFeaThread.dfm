object fFeaThread: TfFeaThread
  Left = 316
  Top = 210
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Thread hole'
  ClientHeight = 326
  ClientWidth = 305
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
  object Panel1: TPanel
    Left = 0
    Top = 266
    Width = 305
    Height = 60
    Align = alClient
    BevelWidth = 2
    TabOrder = 2
    DesignSize = (
      305
      60)
    object btnSad: TSpeedButton
      Left = 120
      Top = 20
      Width = 25
      Height = 25
      Hint = 'I haven'#39't found what I needed...'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSadClick
    end
    object btnCancel: TBitBtn
      Left = 160
      Top = 10
      Width = 60
      Height = 40
      Anchors = [akTop, akRight]
      Cancel = True
      ModalResult = 2
      TabOrder = 1
    end
    object btnSave: TBitBtn
      Left = 225
      Top = 10
      Width = 60
      Height = 40
      Anchors = [akTop, akRight]
      ModalResult = 1
      TabOrder = 0
      OnClick = btnSaveClick
    end
  end
  object PgCtrl: TPageControl
    Left = 0
    Top = 0
    Width = 305
    Height = 136
    ActivePage = tabThread
    Align = alTop
    TabOrder = 0
    TabStop = False
    object tabThread: TTabSheet
      Caption = 'Thread hole'
      object Label3: TLabel
        Left = 25
        Top = 60
        Width = 55
        Height = 13
        Caption = 'Thread size'
      end
      object Label5: TLabel
        Left = 25
        Top = 15
        Width = 59
        Height = 13
        Caption = 'Thread type'
      end
      object comThreadSize: TComboBox
        Tag = -999
        Left = 40
        Top = 75
        Width = 86
        Height = 21
        Style = csDropDownList
        DropDownCount = 10
        ItemIndex = 0
        TabOrder = 1
        Text = 'M1.6'
        OnChange = comThreadSizeChange
        OnKeyPress = DecimalPoint
        Items.Strings = (
          'M1.6'
          'M1.7'
          'M2'
          'M2.5'
          'M3'
          'M4'
          'M5'
          'M6'
          'M8'
          'M10')
      end
      object comThreadSizeValue: TComboBox
        Tag = -999
        Left = 130
        Top = 75
        Width = 46
        Height = 21
        Style = csDropDownList
        Color = clYellow
        ItemIndex = 0
        TabOrder = 2
        Text = '1.6'
        Visible = False
        Items.Strings = (
          '1.6'
          '1.7'
          '2'
          '2.5'
          '3'
          '4'
          '5'
          '6'
          '8'
          '10')
      end
      object comThreadType: TComboBox
        Left = 40
        Top = 30
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 0
        Text = 'Metric'
        OnKeyPress = DecimalPoint
        Items.Strings = (
          'Metric')
      end
      object comThreadTypeValue: TComboBox
        Tag = -999
        Left = 190
        Top = 30
        Width = 51
        Height = 21
        Style = csDropDownList
        Color = clYellow
        ItemIndex = 0
        TabOrder = 3
        Text = 'M'
        Visible = False
        Items.Strings = (
          'M')
      end
      object comThreadMaxDepth: TComboBox
        Tag = -999
        Left = 180
        Top = 75
        Width = 46
        Height = 21
        Style = csDropDownList
        Color = clYellow
        ItemIndex = 0
        TabOrder = 4
        Text = '4'
        Visible = False
        Items.Strings = (
          '4'
          '4'
          '5'
          '8'
          '10'
          '10'
          '12'
          '12'
          '12'
          '12')
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 136
    Width = 305
    Height = 130
    Align = alTop
    BevelWidth = 2
    TabOrder = 1
    object Label4: TLabel
      Left = 25
      Top = 15
      Width = 65
      Height = 13
      Caption = 'Thread depth'
    end
    object Label2: TLabel
      Left = 25
      Top = 77
      Width = 127
      Height = 13
      Caption = 'Position of the hole-center'
    end
    object cbThruAll: TCheckBox
      Left = 40
      Top = 30
      Width = 206
      Height = 17
      Caption = 'Through'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = cbThruAllClick
    end
    object edThreadZ: TEdit
      Left = 40
      Top = 47
      Width = 80
      Height = 21
      Color = clBtnFace
      Enabled = False
      TabOrder = 1
      OnExit = MathExp
      OnKeyPress = DecimalPoint
    end
    object edThreadX: TLabeledEdit
      Tag = -999
      Left = 42
      Top = 93
      Width = 80
      Height = 21
      EditLabel.Width = 6
      EditLabel.Height = 13
      EditLabel.Caption = 'X'
      EditLabel.Color = clBtnFace
      EditLabel.ParentColor = False
      LabelPosition = lpLeft
      TabOrder = 2
      Text = '15'
      OnExit = MathExp
      OnKeyPress = DecimalPoint
    end
    object edThreadY: TLabeledEdit
      Tag = -999
      Left = 140
      Top = 93
      Width = 80
      Height = 21
      EditLabel.Width = 6
      EditLabel.Height = 13
      EditLabel.Caption = 'Y'
      EditLabel.Color = clBtnFace
      EditLabel.ParentColor = False
      LabelPosition = lpLeft
      TabOrder = 3
      Text = '15'
      OnExit = MathExp
      OnKeyPress = DecimalPoint
    end
  end
end
