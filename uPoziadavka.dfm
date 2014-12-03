object fPoziadavka: TfPoziadavka
  Left = 248
  Top = 206
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Your request'
  ClientHeight = 471
  ClientWidth = 652
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 106
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 652
    Height = 130
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 11
      Top = 11
      Width = 397
      Height = 22
      Caption = 'Haven'#39't you found what you'#39've been looking for ?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -18
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label2: TLabel
      Left = 11
      Top = 38
      Width = 467
      Height = 14
      Caption = 
        'Regardless of it'#39's about material type and size, hole shapes or ' +
        'ordering and shipment,'
    end
    object Label3: TLabel
      Left = 11
      Top = 54
      Width = 415
      Height = 14
      Caption = 
        'please give us a short message about what you are missing in our' +
        ' software.'
    end
    object Label4: TLabel
      Left = 11
      Top = 81
      Width = 251
      Height = 14
      Caption = 'It'#39's your ideas we build our software on.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 11
      Top = 97
      Width = 573
      Height = 14
      Caption = 
        'Your requests and ideas are the best source of information for o' +
        'ur future development of this software.'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 416
    Width = 652
    Height = 55
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    DesignSize = (
      652
      55)
    object lbGiveEmail: TLabel
      Left = 11
      Top = 22
      Width = 390
      Height = 14
      Caption = 
        'You are not registered. You should include your e-mail in the me' +
        'ssage.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object btnCancel: TBitBtn
      Left = 495
      Top = 5
      Width = 65
      Height = 43
      Hint = 'Cancel and don'#39't send'
      Anchors = [akTop, akRight]
      Cancel = True
      ModalResult = 2
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TabStop = False
    end
    object btnSend: TBitBtn
      Left = 565
      Top = 5
      Width = 65
      Height = 43
      Hint = 'Send'
      Anchors = [akTop, akRight]
      ModalResult = 1
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnSendClick
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 130
    Width = 652
    Height = 286
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 2
    object Label7: TLabel
      Left = 32
      Top = 65
      Width = 204
      Height = 14
      Caption = 'Your request / proposal / information'
    end
    object edTopic: TLabeledEdit
      Left = 32
      Top = 32
      Width = 281
      Height = 22
      Color = clBtnFace
      EditLabel.Width = 119
      EditLabel.Height = 14
      EditLabel.Caption = 'Topic of your request'
      MaxLength = 50
      ReadOnly = True
      TabOrder = 0
    end
    object memMessage: TMemo
      Left = 32
      Top = 83
      Width = 594
      Height = 114
      MaxLength = 500
      ScrollBars = ssVertical
      TabOrder = 1
      OnKeyDown = memMessageKeyDown
    end
    object rbNotifyThis: TRadioButton
      Left = 32
      Top = 210
      Width = 524
      Height = 18
      Caption = 'Please notify me, after adding my request into the software'
      Checked = True
      TabOrder = 2
      TabStop = True
      OnClick = rbNotifyClick
    end
    object rbNotifyAlways: TRadioButton
      Left = 32
      Top = 232
      Width = 524
      Height = 18
      Caption = 
        'Notify me on every improvement of the software (once a week max.' +
        ')'
      TabOrder = 3
      OnClick = rbNotifyClick
    end
    object rbNotifyNever: TRadioButton
      Left = 32
      Top = 253
      Width = 319
      Height = 18
      Caption = 'Don'#39't send me any notifications'
      TabOrder = 4
      OnClick = rbNotifyClick
    end
  end
end
