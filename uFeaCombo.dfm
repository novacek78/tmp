object fFeaCombo: TfFeaCombo
  Left = 223
  Top = 37
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Insert combo feature'
  ClientHeight = 399
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 347
    Width = 405
    Height = 52
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      405
      52)
    object btnSad: TSpeedButton
      Left = 220
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
    object btnCancel: TBitBtn
      Left = 260
      Top = 5
      Width = 60
      Height = 40
      Anchors = [akTop, akRight]
      Cancel = True
      ModalResult = 2
      TabOrder = 0
    end
    object btnSave: TBitBtn
      Left = 325
      Top = 5
      Width = 60
      Height = 40
      Anchors = [akTop, akRight]
      ModalResult = 1
      TabOrder = 1
      OnClick = btnSaveClick
    end
  end
  object pgControl: TPageControl
    Left = 0
    Top = 0
    Width = 405
    Height = 347
    ActivePage = tabFileCombo
    Align = alClient
    TabOrder = 1
    object tabFileCombo: TTabSheet
      Caption = 'Combo feature'
      object Label1: TLabel
        Left = 15
        Top = 115
        Width = 27
        Height = 13
        Caption = 'Name'
      end
      object Label2: TLabel
        Left = 15
        Top = 150
        Width = 53
        Height = 13
        Caption = 'Dimensions'
      end
      object lbComboName: TLabel
        Tag = -999
        Left = 25
        Top = 130
        Width = 196
        Height = 16
        AutoSize = False
        Caption = '- - -'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbComboSize: TLabel
        Tag = -999
        Left = 25
        Top = 165
        Width = 196
        Height = 16
        AutoSize = False
        Caption = '- - -'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label13: TLabel
        Left = 15
        Top = 10
        Width = 56
        Height = 13
        Caption = 'File location'
      end
      object Bevel1: TBevel
        Left = 66
        Top = 100
        Width = 250
        Height = 2
      end
      object Label3: TLabel
        Left = 15
        Top = 250
        Width = 145
        Height = 13
        Caption = 'Position of combo is based on:'
      end
      object Label5: TLabel
        Left = 15
        Top = 200
        Width = 84
        Height = 13
        Caption = 'Position of combo'
      end
      object Panel2: TPanel
        Left = 240
        Top = 115
        Width = 127
        Height = 127
        TabOrder = 0
        object imgFileCombo: TImage
          Left = 1
          Top = 1
          Width = 125
          Height = 125
          Align = alClient
          Transparent = True
        end
      end
      object rbFile: TRadioButton
        Left = 25
        Top = 30
        Width = 160
        Height = 17
        Caption = 'From a file'
        Checked = True
        TabOrder = 1
        TabStop = True
      end
      object rbLocalLibrary: TRadioButton
        Left = 25
        Top = 50
        Width = 160
        Height = 17
        Caption = 'From local library'
        Enabled = False
        TabOrder = 2
      end
      object rbInternetLibrary: TRadioButton
        Left = 25
        Top = 70
        Width = 160
        Height = 17
        Caption = 'From internet library'
        Enabled = False
        TabOrder = 3
      end
      object edComboComponent: TEdit
        Left = 30
        Top = 268
        Width = 196
        Height = 21
        ReadOnly = True
        TabOrder = 6
        OnKeyDown = edComboComponentKeyDown
      end
      object UpDownComponent: TUpDown
        Left = 226
        Top = 268
        Width = 17
        Height = 21
        Position = 1
        TabOrder = 7
        OnChanging = UpDownComponentChanging
        OnMouseUp = UpDownComponentMouseUp
      end
      object edComboX: TLabeledEdit
        Tag = -999
        Left = 30
        Top = 217
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
      object edComboY: TLabeledEdit
        Tag = -999
        Left = 128
        Top = 217
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
      object btnBrowse: TBitBtn
        Left = 183
        Top = 39
        Width = 60
        Height = 40
        Glyph.Data = {
          F6060000424DF60600000000000036000000280000001F000000120000000100
          180000000000C0060000120B0000120B0000000000000000000000FFFF00FFFF
          00FFFF00FFFF00FFFF878484807978807A78807A78807A78807A78807A78807A
          78807A78807A78807A78807A78807A78807A78807A78807A78807A78807A7880
          7A78807A78807A78807A7880797887858500FFFF00FFFF00000000FFFF00FFFF
          00FFFF00FFFFBCBABA1523253355583152583152583152583152583152583152
          5831525831525831525831525831525831525831525831525831525831525831
          5258315258315258315258335559121D1F88878700FFFF00000000FFFF00FFFF
          00FFFF00FFFF75717145828D90FDFF8BF4FF8BF4FF8BF4FF8BF4FF8BF4FF8BF4
          FF8BF4FF8BF4FF8BF4FF8BF4FF8BF4FF8BF4FF8BF4FF8BF4FF8BF4FF8BF4FF8B
          F4FF8BF4FF8BF4FF8BF5FF8AF2FF1025296E6C6B00FFFF00000000FFFF00FFFF
          00FFFF00FFFF3B3D3D69BECD8AF2FF87EDFF87EDFF87EDFF87EDFF87EDFF87ED
          FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87
          EDFF87EDFF87EDFF8AF2FF72C8D801070859595900FFFF00000000FFFF00FFFF
          00FFFF00FFFF22343782E7F888EEFF87EDFF87EDFF87EDFF87EDFF87EDFF87ED
          FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87
          EDFF87EDFF87EDFF8CF6FF508D98214046484F4F00FFFF00000000FFFF00FFFF
          00FFFFA29E9D305A628CF6FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87ED
          FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87
          EDFF87EDFF87EDFF8BF4FF30545A50919C37414200FFFF00000000FFFF00FFFF
          00FFFF5E5C5B5298A48CF5FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87ED
          FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87
          EDFF87EDFF88EFFF7EDEEF223C4074CFE02B393B00FFFF00000000FFFF00FFFF
          00FFFF2E343574CFDF89F1FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87ED
          FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87
          EDFF87EDFF8BF4FF63AFBC2E515788F1FF263B3F00FFFF00000000FFFF00FFFF
          C9C6C5233D4188EFFE87EEFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87ED
          FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87
          EDFF87EDFF8DF7FF41727B4D87918EFBFF28464C00FFFF00000000FFFF00FFFF
          8A86853A6E778DF7FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87ED
          FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87
          EDFF87EEFF88EFFE2743496EC1D08FFBFF2F575E00FFFF00000000FFFF00FFFF
          4A49495FADBB8BF4FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87ED
          FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87
          EDFF89F1FF77D0E0223C4184E8F88DF8FF396C7598949400000000FFFF00FFFF
          2632347CDDEE88EFFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87ED
          FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87
          EDFF8CF5FF589AA63760688CF6FF8CF6FF46848F817D7D00000000FFFFB8B5B4
          294B518BF4FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87ED
          FF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87EDFF87
          EDFF8CF6FF365F66599CA88CF5FF8BF5FF549CA869666600000000FFFF787474
          4785908CF6FF87EDFF87EDFF87EDFF87EDFF88EFFF89F0FF89F0FF89F0FF89F0
          FF89F0FF89F0FF89F0FF89F0FF89F0FF89F0FF89F0FF89F0FF89F0FF89F0FF8A
          F2FF85E9FA233D4279D5E58BF4FF8CF6FF64B6C453535300000000FFFF414445
          6BC1D18AF2FF87EDFF87EDFF87EDFF89F1FF81E2F378D3E378D3E378D3E378D3
          E37AD7E778D5E576D3E376D3E376D3E376D3E376D3E376D3E376D3E376D3E378
          D8E45FAAB81E393D77D5E376D3E378D7E45FB0BE3C404100000000FFFF2D393B
          7EE0F189F0FF87EEFF87EDFF8AF2FF7CD9E8213A3E233D41233D42233D422440
          43122124232A2B333B3C333B3C333B3C333B3C333B3C333B3C333B3C333B3C33
          3C3D2F34352D3030343C3D333B3C333B3C32393A4E4F4F00000000FFFF424545
          69BECD8AF4FF87EEFF88F0FF84E8F5213D42467C8588EFFA84E8FA84EAFA7DDE
          ED1D2E31CBC7C700FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00000000FFFF7E7D7D
          2132352E47492D45492E464926393C2E2C2C28393C2F484A2E464A2E474A273C
          3F5B5B5B00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF000000}
        TabOrder = 8
        OnClick = btnBrowseClick
      end
    end
  end
  object dlgOpen: TOpenDialog
    DefaultExt = 'combo'
    Filter = 'Combo files|*.combo|All files|*.*'
    Title = 'Open combo file'
    Left = 360
    Top = 35
  end
end
