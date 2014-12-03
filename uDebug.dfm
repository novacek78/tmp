object fDebug: TfDebug
  Tag = -999
  Left = 0
  Top = 530
  Caption = 'fDebug'
  ClientHeight = 291
  ClientWidth = 898
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    898
    291)
  PixelsPerInch = 96
  TextHeight = 13
  object img1: TImage
    Left = 609
    Top = 0
    Width = 289
    Height = 291
    Align = alRight
    ExplicitLeft = 810
    ExplicitTop = 119
    ExplicitWidth = 76
    ExplicitHeight = 153
  end
  object memo: TMemo
    Left = 0
    Top = 0
    Width = 609
    Height = 291
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
    OnKeyUp = memoKeyUp
  end
  object Button1: TButton
    Left = 810
    Top = 38
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '_PNL info'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 810
    Top = 63
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'COMBO info'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 810
    Top = 8
    Width = 75
    Height = 21
    Anchors = [akTop, akRight]
    Caption = 'clear'
    TabOrder = 1
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 811
    Top = 88
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'UNDO list'
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 810
    Top = 165
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Translator'
    TabOrder = 5
    OnClick = Button5Click
  end
  object btnPolygon: TButton
    Left = 810
    Top = 192
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'btnPolygon'
    TabOrder = 6
    OnClick = btnPolygonClick
  end
end
