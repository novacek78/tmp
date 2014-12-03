object fGuides: TfGuides
  Left = 236
  Top = 236
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Guidelines'
  ClientHeight = 360
  ClientWidth = 455
  Color = clBtnFace
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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 308
    Width = 455
    Height = 52
    Align = alBottom
    BevelWidth = 2
    TabOrder = 0
    DesignSize = (
      455
      52)
    object btnSad: TSpeedButton
      Left = 335
      Top = 12
      Width = 25
      Height = 25
      Hint = 'I haven'#39't found what I needed...'
      Anchors = [akTop, akRight]
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSadClick
      ExplicitLeft = 285
    end
    object btnSave: TBitBtn
      Left = 375
      Top = 5
      Width = 60
      Height = 40
      Anchors = [akTop, akRight]
      ModalResult = 1
      TabOrder = 0
      OnClick = btnSaveClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 455
    Height = 216
    Align = alTop
    BevelWidth = 2
    TabOrder = 1
    DesignSize = (
      455
      216)
    object Label1: TLabel
      Left = 205
      Top = 15
      Width = 87
      Height = 13
      Caption = 'Existing guidelines'
    end
    object Label2: TLabel
      Left = 15
      Top = 15
      Width = 105
      Height = 13
      Caption = 'Type of new guideline'
    end
    object Label3: TLabel
      Left = 15
      Top = 60
      Width = 37
      Height = 13
      Caption = 'Position'
    end
    object Label4: TLabel
      Left = 15
      Top = 98
      Width = 37
      Height = 13
      Caption = 'Position'
      Visible = False
    end
    object lbGuides: TListBox
      Tag = -999
      Left = 255
      Top = 30
      Width = 180
      Height = 171
      ItemHeight = 13
      TabOrder = 4
      OnClick = lbGuidesClick
    end
    object btnAdd: TBitBtn
      Left = 209
      Top = 30
      Width = 40
      Height = 40
      Anchors = [akTop, akRight]
      NumGlyphs = 2
      TabOrder = 6
      TabStop = False
      OnClick = btnAddClick
    end
    object btnDel: TBitBtn
      Left = 209
      Top = 70
      Width = 40
      Height = 40
      Anchors = [akTop, akRight]
      Enabled = False
      NumGlyphs = 2
      TabOrder = 7
      TabStop = False
      OnClick = btnDelClick
    end
    object comTyp: TComboBox
      Left = 25
      Top = 30
      Width = 126
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'Vertical'
      OnChange = comTypChange
      Items.Strings = (
        'Vertical'
        'Horizontal'
        'Vertical + horizontal')
    end
    object edParam1: TEdit
      Left = 25
      Top = 75
      Width = 80
      Height = 21
      TabOrder = 1
      OnExit = MathExp
      OnKeyPress = edParam1KeyPress
    end
    object lbGuidesID: TListBox
      Tag = -999
      Left = 303
      Top = 98
      Width = 121
      Height = 97
      Color = clYellow
      ItemHeight = 13
      TabOrder = 8
      Visible = False
    end
    object cbShowGuides: TCheckBox
      Left = 14
      Top = 162
      Width = 186
      Height = 17
      Caption = 'Show guidelines'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = cbShowGuidesClick
    end
    object edX: TLabeledEdit
      Tag = -999
      Left = 35
      Top = 112
      Width = 75
      Height = 21
      EditLabel.Width = 6
      EditLabel.Height = 13
      EditLabel.Caption = 'X'
      EditLabel.Color = clBtnFace
      EditLabel.ParentColor = False
      LabelPosition = lpLeft
      TabOrder = 2
      Visible = False
      OnExit = MathExp
      OnKeyPress = edXYKeyPress
    end
    object edY: TLabeledEdit
      Tag = -999
      Left = 125
      Top = 112
      Width = 75
      Height = 21
      EditLabel.Width = 6
      EditLabel.Height = 13
      EditLabel.Caption = 'Y'
      EditLabel.Color = clBtnFace
      EditLabel.ParentColor = False
      LabelPosition = lpLeft
      TabOrder = 3
      Visible = False
      OnExit = MathExp
      OnKeyPress = edXYKeyPress
    end
    object cbSnapToGuides: TCheckBox
      Left = 15
      Top = 185
      Width = 186
      Height = 17
      Caption = 'Snap to guidelines'
      Checked = True
      State = cbChecked
      TabOrder = 9
      OnClick = cbSnapToGuidesClick
    end
  end
  object pnlGrid: TPanel
    Left = 0
    Top = 216
    Width = 455
    Height = 92
    Align = alClient
    BevelWidth = 2
    TabOrder = 2
    object lbLabel1: TLabel
      Left = 111
      Top = 33
      Width = 16
      Height = 13
      Caption = 'mm'
    end
    object lbGridSize: TLabel
      Left = 15
      Top = 15
      Width = 40
      Height = 13
      Caption = 'Grid size'
    end
    object lbShowGrid: TLabel
      Left = 205
      Top = 15
      Width = 73
      Height = 13
      Caption = 'Display grid as:'
    end
    object cbSnapToGrid: TCheckBox
      Left = 15
      Top = 61
      Width = 186
      Height = 17
      Caption = 'Snap to grid'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = cbSnapToGuidesClick
    end
    object edGridSize: TEdit
      Left = 25
      Top = 30
      Width = 80
      Height = 21
      TabOrder = 0
      Text = '0.5'
      OnExit = MathExp
      OnKeyPress = DecimalPoint
    end
    object comShowGrid: TComboBox
      Left = 215
      Top = 30
      Width = 145
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = 'None'
      OnChange = comTypChange
      OnKeyPress = DecimalPoint
      Items.Strings = (
        'None'
        'Dots'
        'Lines')
    end
  end
end
