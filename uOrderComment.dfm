object fOrderComment: TfOrderComment
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Order comments'
  ClientHeight = 376
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 505
    Height = 316
    Align = alClient
    TabOrder = 0
    DesignSize = (
      505
      316)
    object Label1: TLabel
      Left = 8
      Top = 15
      Width = 127
      Height = 13
      Caption = 'Write your comments here'
    end
    object Label2: TLabel
      Left = 8
      Top = 191
      Width = 91
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = 'Add your files here'
    end
    object btnFileAdd: TSpeedButton
      Left = 456
      Top = 236
      Width = 40
      Height = 40
      Hint = 'Add file...'
      Anchors = [akRight, akBottom]
      NumGlyphs = 2
      ParentShowHint = False
      ShowHint = True
      OnClick = btnFileAddClick
    end
    object lbFiles: TListBox
      Left = 8
      Top = 210
      Width = 441
      Height = 93
      Anchors = [akLeft, akRight, akBottom]
      ItemHeight = 13
      PopupMenu = PopupMenu
      TabOrder = 0
      OnKeyDown = lbFilesKeyDown
    end
    object MemoComment: TMemo
      Left = 8
      Top = 34
      Width = 488
      Height = 139
      Anchors = [akLeft, akTop, akRight, akBottom]
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 316
    Width = 505
    Height = 60
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      505
      60)
    object btnSad: TSpeedButton
      Left = 385
      Top = 19
      Width = 25
      Height = 25
      Hint = 'I haven'#39't found what I needed...'
      Anchors = [akTop, akRight]
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = btnSadClick
    end
    object btnOK: TSpeedButton
      Left = 436
      Top = 10
      Width = 60
      Height = 41
      Anchors = [akTop, akRight]
      Layout = blGlyphRight
      OnClick = btnOKClick
    end
  end
  object OpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofFileMustExist, ofEnableSizing]
    Left = 55
    Top = 235
  end
  object PopupMenu: TPopupMenu
    OnPopup = PopupMenuPopup
    Left = 160
    Top = 235
    object Addfile1: TMenuItem
      Caption = 'Add file...'
      ShortCut = 45
      OnClick = btnFileAddClick
    end
    object Removefromlist1: TMenuItem
      Caption = 'Remove from list'
      ShortCut = 46
      OnClick = Removefromlist1Click
    end
  end
end
