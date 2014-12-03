object fFeaGroove: TfFeaGroove
  Left = 157
  Top = 107
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Groove'
  ClientHeight = 391
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
  object pgControl: TPageControl
    Left = 0
    Top = 0
    Width = 305
    Height = 201
    ActivePage = tabLinear
    Align = alTop
    TabOrder = 0
    object tabLinear: TTabSheet
      Caption = 'Linear groove'
      object Label2: TLabel
        Left = 25
        Top = 15
        Width = 65
        Height = 13
        Caption = 'Starting point'
      end
      object edLinX1: TLabeledEdit
        Tag = -999
        Left = 40
        Top = 30
        Width = 80
        Height = 21
        EditLabel.Width = 6
        EditLabel.Height = 13
        EditLabel.Caption = 'X'
        LabelPosition = lpLeft
        TabOrder = 0
        Text = '5'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edLinY1: TLabeledEdit
        Tag = -999
        Left = 137
        Top = 30
        Width = 80
        Height = 21
        EditLabel.Width = 6
        EditLabel.Height = 13
        EditLabel.Caption = 'Y'
        LabelPosition = lpLeft
        TabOrder = 1
        Text = '10'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edLinY2: TLabeledEdit
        Tag = -999
        Left = 166
        Top = 120
        Width = 80
        Height = 21
        EditLabel.Width = 6
        EditLabel.Height = 13
        EditLabel.Caption = 'Y'
        Enabled = False
        LabelPosition = lpLeft
        TabOrder = 7
        Text = '15'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edLinX2: TLabeledEdit
        Tag = -999
        Left = 69
        Top = 120
        Width = 80
        Height = 21
        EditLabel.Width = 6
        EditLabel.Height = 13
        EditLabel.Caption = 'X'
        Enabled = False
        LabelPosition = lpLeft
        TabOrder = 6
        Text = '15'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object rbLinAbs: TRadioButton
        Left = 40
        Top = 102
        Width = 151
        Height = 17
        Caption = 'Ending point'
        TabOrder = 5
        OnClick = rbLinClick
      end
      object rbLinInc: TRadioButton
        Left = 40
        Top = 62
        Width = 221
        Height = 17
        Caption = 'Length in X and Y direction'
        Checked = True
        TabOrder = 2
        TabStop = True
        OnClick = rbLinClick
      end
      object edLinDY: TLabeledEdit
        Tag = -999
        Left = 166
        Top = 80
        Width = 80
        Height = 21
        EditLabel.Width = 6
        EditLabel.Height = 13
        EditLabel.Caption = 'Y'
        LabelPosition = lpLeft
        TabOrder = 4
        Text = '30'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edLinDX: TLabeledEdit
        Tag = -999
        Left = 69
        Top = 80
        Width = 80
        Height = 21
        EditLabel.Width = 6
        EditLabel.Height = 13
        EditLabel.Caption = 'X'
        LabelPosition = lpLeft
        TabOrder = 3
        Text = '20'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
    end
    object tabArc: TTabSheet
      Caption = 'Arc groove'
      ImageIndex = 1
      object Label5: TLabel
        Left = 25
        Top = 125
        Width = 103
        Height = 13
        Caption = 'Position of the center'
      end
      object Label7: TLabel
        Left = 25
        Top = 60
        Width = 173
        Height = 13
        Caption = 'Starting and ending angle of the arc'
      end
      object Label8: TLabel
        Left = 177
        Top = 80
        Width = 39
        Height = 13
        Caption = 'degrees'
      end
      object Label10: TLabel
        Left = 25
        Top = 15
        Width = 61
        Height = 13
        Caption = 'Arc diameter'
      end
      object Label11: TLabel
        Left = 109
        Top = 35
        Width = 16
        Height = 13
        Caption = 'mm'
      end
      object Label9: TLabel
        Tag = -999
        Left = 96
        Top = 80
        Width = 12
        Height = 13
        Caption = '...'
      end
      object Image1: TImage
        Left = 225
        Top = 55
        Width = 72
        Height = 70
        AutoSize = True
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000480000
          0046080600000118E0E2A1000000097048597300000EC300000EC301C76FA864
          000002CE4944415478DAED5B6D6EC3200C4D0E32693BCE26ED223D502F32693B
          CE2AF5205DD9C444291FC6F81993E6FD216988793C1C301F5D4FDFE7A5865536
          D3E7D7C7E5EDF57D0D1F84BF0917279B29241A570454DCE170588EC7E3126B76
          63E9F9E5E972BD5FEF2C5DDFFC271966CA2A9EB564B05928D0319453CDAE21FF
          DCA5B21AA53EF01252F9276BFE6E43616B84299B91981F7557ADD4658E61B411
          4361D74E856F80D03D9A0DB997DD88E446A6D0C7D88CEE0CD9135BDC10E55328
          E5315C352A9C1FB9D4377DEA9EDA8725706A22C4E9811F8B9002EA84729F444E
          9DD6608444886294D25C0C72FC2603F8CF2DA1D6DAB41222DA37AA10C7113984
          52237C648B4F88433E474844210E08E5F09D1A40E6969011DC139256AAD1DE04
          0A956AEAD2546D4BCF6084CC29E4008E1669845285147A5A7C08DB4AA8131B21
          C4C92346481913132A0D0182C34D995069C6F1FBB6D6ACA366B844A893D4C43E
          348410226A64C743C810B6C1B6F1263300BD6990E9594721B01BDB64A9C00E4E
          A8D4ABA7C296C72354236B8A500AD63E7BA30A5982B5C175B1167E186E322B60
          05F935F4BCCB9A06A1C85409510B92FC18E6F1A11D7F8009545BE76A790EDA78
          D21388B2E8D72A90BF77E92871BA04F2E4538817B1FD6FAD025900CC836AF91E
          4AA09220FE3A37250BEFAD89E3B08F62154005F25B8C21FCA1F3181AFBF31C88
          08140A2175BC876ACFAC40DC732BFE9A7B7EC5B4403DBBF252E7FA044F06C809
          24D97A9243B98657B1CF2E5A1008C18F2C10AA60543088E2CB3E6C6A4D20146F
          F8A1334D8110FCE1CBC0DA0249D76317882A905620A635638FEBC35DA09B5E20
          EA5F25B80B7443044297E1513BC6D8F4C7CD51739D5E487AD02605CA21551FCE
          029DFA28364A1C2E76812A508FA4D18046D2A842B4A0321743168684EA6C5EA3
          60EBC278A8AF284AC2C48A624CC8A523C532B9269D23AA29D414BB1A25F2FE5A
          A2129BD8176BAD680DA385C861DF9BAFE007B453F1264F46C50E000000004945
          4E44AE426082}
      end
      object edArcX1: TLabeledEdit
        Tag = -999
        Left = 40
        Top = 140
        Width = 80
        Height = 21
        EditLabel.Width = 6
        EditLabel.Height = 13
        EditLabel.Caption = 'X'
        LabelPosition = lpLeft
        TabOrder = 4
        Text = '20'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edArcY1: TLabeledEdit
        Tag = -999
        Left = 135
        Top = 140
        Width = 80
        Height = 21
        EditLabel.Width = 6
        EditLabel.Height = 13
        EditLabel.Caption = 'Y'
        LabelPosition = lpLeft
        TabOrder = 5
        Text = '20'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edArcDegStart: TEdit
        Left = 25
        Top = 75
        Width = 65
        Height = 21
        TabOrder = 1
        Text = '0'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edArcDiam: TEdit
        Left = 25
        Top = 30
        Width = 80
        Height = 21
        TabOrder = 0
        Text = '30'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object cbArcConnected: TCheckBox
        Left = 25
        Top = 100
        Width = 176
        Height = 17
        Caption = 'Connect start with end'
        TabOrder = 3
      end
      object edArcDegEnd: TEdit
        Left = 110
        Top = 75
        Width = 65
        Height = 21
        TabOrder = 2
        Text = '90'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 331
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
      Anchors = [akTop, akRight]
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
  object Panel2: TPanel
    Left = 0
    Top = 201
    Width = 305
    Height = 130
    Align = alTop
    BevelWidth = 2
    TabOrder = 1
    object Label12: TLabel
      Left = 25
      Top = 60
      Width = 66
      Height = 13
      Caption = 'Groove depth'
    end
    object Label4: TLabel
      Left = 25
      Top = 15
      Width = 119
      Height = 13
      Caption = 'Groove width (tool used)'
    end
    object cbThruAll: TCheckBox
      Left = 40
      Top = 75
      Width = 176
      Height = 17
      Caption = 'Through'
      Checked = True
      State = cbChecked
      TabOrder = 1
      OnClick = cbThruAllClick
    end
    object edDepth: TEdit
      Left = 40
      Top = 92
      Width = 80
      Height = 21
      Color = clBtnFace
      Enabled = False
      TabOrder = 2
      OnExit = MathExp
      OnKeyPress = DecimalPoint
    end
    object comGrooveWidth: TComboBox
      Tag = -999
      Left = 40
      Top = 30
      Width = 126
      Height = 21
      Style = csDropDownList
      ItemIndex = 3
      TabOrder = 0
      Text = '3 mm'
      OnKeyPress = DecimalPoint
      Items.Strings = (
        '1 mm'
        '1.5 mm'
        '2 mm'
        '3 mm'
        '4 mm'
        '5 mm'
        '6 mm')
    end
  end
end
