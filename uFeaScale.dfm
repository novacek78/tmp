object fFeaScale: TfFeaScale
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Scale'
  ClientHeight = 513
  ClientWidth = 363
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
  object pgCtrl: TPageControl
    Left = 0
    Top = 0
    Width = 363
    Height = 451
    ActivePage = tabArc
    Align = alClient
    TabOrder = 0
    object tabArc: TTabSheet
      Caption = 'Circular scale'
      ImageIndex = 1
      object Label5: TLabel
        Left = 24
        Top = 374
        Width = 103
        Height = 13
        Caption = 'Position of the center'
      end
      object Label7: TLabel
        Left = 25
        Top = 30
        Width = 182
        Height = 13
        Caption = 'Starting and ending angle of the scale'
      end
      object Label8: TLabel
        Left = 192
        Top = 50
        Width = 39
        Height = 13
        Caption = 'degrees'
      end
      object Label9: TLabel
        Tag = -999
        Left = 109
        Top = 50
        Width = 12
        Height = 13
        Caption = '...'
      end
      object Image1: TImage
        Left = 255
        Top = 10
        Width = 72
        Height = 70
        AutoSize = True
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000480000
          0046080600000118E0E2A1000000097048597300000EC300000EC301C76FA864
          000002C54944415478DAED5B6D6EC3200C6D0E32693BCE26ED2239502F32693B
          CE26ED205DF9C1445330C6F81993E6FD216988793C13301F5D7EBE7F4F352CBA
          993EBF3E2E6FAFEF4BFA20FD4DB938DD4C29D16D4540C5ADEB7A3A9FCFA7AD66
          37969E5F9E2ED7FBE5CED2F5CD7F9269A6A2E2454B0EDDC2818DA1926A7E0DC5
          E721D5D528F78153C8E59FCCFDDD86526FA4A998915A3BEAAE1AD5658E61B413
          4369D7CE457440DA3C9A0D8597C3881446A6B48D8919DD19F227B6BA21CEA740
          E5715C352E423B0A69747DEE9EDB87751392F4C08F45C8025542A54FA2A44E6B
          30C222C431CA7197849CD86588F67343A8B536AD84E0C103542189AF25847223
          FCD6969890847C89908A421270CA11376A04991B425E7047485BA9567BFE15A2
          6A1AD25C6DA9673042EE140A40478B2C42B942A89E161EC2B612EAC53E0849F2
          A811B2C6BC84A8214073B8210951338E909ACD3A6A862942BDA4E66D43430821
          A246713C840C615B6CFB769907984D835CCF3AA8C06EA8CB72811D9C10D5ABE7
          C296C7235423EB8A500EC7673F2F219783ABABF0C30BE621D4E33E58902F310C
          9B06B5146436511C017784BC0126506D9DABE5396AE3C94C20CEA25FAB40F13E
          A4A3C4E9122892CF61BB881D7F6B15C803602DA896EFA104A20489D7A529597A
          EF4D9C806314AB002A50DC624C110F9D6F61B13F2F818A40A9105AC77BB8F6DC
          0A243DB712AFA5E7575C0BD4B32BAF75AE4FF364809A409ADED31CCA2D5A95F8
          ECA2078110FCD802A10A46058328BEE2C3A6DE0442F1861F3AB31408C11FBE0C
          6C2D90763D0E81B8025905625633F66D7DA40B74D30BC4FDAB8474816E8840E8
          32226AC7189BFEB8396AAED30BCD16B44B814AC8D547B240673E8A8D12478A43
          A00ACC236934A09134AA102B98CCC5908521613A9BB728D8BB3011E62B8A9A70
          B1A2B82514D29162B95C932E11B5146A8A5D0D8A7CBCD6A8C42EF6C55A2B5AC3
          68214A38F6E62BF803D716D1A6032214B90000000049454E44AE426082}
      end
      object Label1: TLabel
        Left = 25
        Top = 100
        Width = 48
        Height = 13
        Caption = 'Tick count'
      end
      object Label2: TLabel
        Left = 115
        Top = 100
        Width = 177
        Height = 13
        Caption = 'Inner and outer diameter of tick lines'
      end
      object Label3: TLabel
        Tag = -999
        Left = 199
        Top = 120
        Width = 12
        Height = 13
        Caption = '...'
      end
      object Bevel1: TBevel
        Left = 52
        Top = 90
        Width = 250
        Height = 2
      end
      object Bevel2: TBevel
        Left = 52
        Top = 190
        Width = 250
        Height = 2
      end
      object Label4: TLabel
        Left = 25
        Top = 200
        Width = 43
        Height = 13
        Caption = 'Text size'
      end
      object Label6: TLabel
        Left = 115
        Top = 200
        Width = 167
        Height = 13
        Caption = 'Diameter of the text-position-circle'
      end
      object Label10: TLabel
        Left = 25
        Top = 240
        Width = 143
        Height = 13
        Caption = 'Texts separated by semicolon'
      end
      object Bevel3: TBevel
        Left = 51
        Top = 364
        Width = 250
        Height = 2
      end
      object Label11: TLabel
        Left = 25
        Top = 140
        Width = 80
        Height = 13
        Caption = 'Engraving cutter'
      end
      object Label13: TLabel
        Left = 117
        Top = 158
        Width = 104
        Height = 13
        Cursor = crHandPoint
        Caption = '(engraving examples)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = LinkLabelClick
      end
      object Label12: TLabel
        Left = 25
        Top = 311
        Width = 80
        Height = 13
        Caption = 'Engraving cutter'
      end
      object Label14: TLabel
        Left = 117
        Top = 329
        Width = 104
        Height = 13
        Cursor = crHandPoint
        Caption = '(engraving examples)'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsUnderline]
        ParentFont = False
        OnClick = LinkLabelClick
      end
      object edCenterX: TLabeledEdit
        Tag = -999
        Left = 39
        Top = 389
        Width = 80
        Height = 21
        EditLabel.Width = 6
        EditLabel.Height = 13
        EditLabel.Caption = 'X'
        LabelPosition = lpLeft
        TabOrder = 13
        Text = '20'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edCenterY: TLabeledEdit
        Tag = -999
        Left = 141
        Top = 389
        Width = 80
        Height = 21
        EditLabel.Width = 6
        EditLabel.Height = 13
        EditLabel.Caption = 'Y'
        LabelPosition = lpLeft
        TabOrder = 14
        Text = '20'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edStartAngle: TEdit
        Left = 40
        Top = 45
        Width = 65
        Height = 21
        TabOrder = 0
        Text = '230'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edEndAngle: TEdit
        Left = 124
        Top = 45
        Width = 65
        Height = 21
        TabOrder = 1
        Text = '-50'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edTickCount: TEdit
        Left = 40
        Top = 115
        Width = 65
        Height = 21
        TabOrder = 2
        Text = '10'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edTickInner: TEdit
        Left = 125
        Top = 115
        Width = 70
        Height = 21
        TabOrder = 3
        Text = '20'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edTickOuter: TEdit
        Left = 213
        Top = 115
        Width = 70
        Height = 21
        TabOrder = 4
        Text = '25'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edTextSize: TEdit
        Left = 40
        Top = 215
        Width = 65
        Height = 21
        TabOrder = 7
        Text = '2.5'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edTextDiameter: TEdit
        Left = 130
        Top = 215
        Width = 65
        Height = 21
        TabOrder = 8
        Text = '30'
        OnExit = MathExp
        OnKeyPress = DecimalPoint
      end
      object edTexts: TEdit
        Left = 40
        Top = 255
        Width = 271
        Height = 21
        TabOrder = 9
        Text = '1;2;3;4;5;6;7;8;9;10'
        OnKeyPress = edTextsKeyPress
      end
      object comEngravingToolTick: TComboBox
        Tag = -999
        Left = 40
        Top = 155
        Width = 71
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 5
        Text = '0.2 mm'
        OnChange = comEngravingToolTickChange
        OnKeyPress = DecimalPoint
        Items.Strings = (
          '0.2 mm'
          '0.4 mm')
      end
      object comEngravingToolTickValue: TComboBox
        Tag = -999
        Left = 229
        Top = 155
        Width = 41
        Height = 21
        Style = csDropDownList
        Color = clYellow
        ItemIndex = 0
        TabOrder = 6
        Text = '0.2'
        Visible = False
        Items.Strings = (
          '0.2'
          '0.4')
      end
      object comEngravingToolText: TComboBox
        Tag = -999
        Left = 40
        Top = 326
        Width = 71
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 11
        Text = '0.2 mm'
        OnChange = comEngravingToolTextChange
        OnKeyPress = DecimalPoint
        Items.Strings = (
          '0.2 mm'
          '0.4 mm')
      end
      object comEngravingToolTextValue: TComboBox
        Tag = -999
        Left = 229
        Top = 326
        Width = 41
        Height = 21
        Style = csDropDownList
        Color = clYellow
        ItemIndex = 0
        TabOrder = 12
        Text = '0.2'
        Visible = False
        Items.Strings = (
          '0.2'
          '0.4')
      end
      object cbRotateTexts: TCheckBox
        Left = 25
        Top = 285
        Width = 286
        Height = 17
        Caption = 'Rotate texts'
        TabOrder = 10
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 451
    Width = 363
    Height = 62
    Align = alBottom
    BevelWidth = 2
    TabOrder = 1
    DesignSize = (
      363
      62)
    object btnSad: TSpeedButton
      Left = 177
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
      Left = 217
      Top = 10
      Width = 60
      Height = 40
      Anchors = [akTop, akRight]
      Cancel = True
      ModalResult = 2
      TabOrder = 1
    end
    object btnSave: TBitBtn
      Left = 283
      Top = 10
      Width = 60
      Height = 40
      Anchors = [akTop, akRight]
      ModalResult = 1
      NumGlyphs = 2
      TabOrder = 0
      OnClick = btnSaveClick
    end
  end
end
