unit uOrderComment;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons,
  Vcl.Menus;

type
  TfOrderComment = class(TForm)
    Panel1: TPanel;
    lbFiles: TListBox;
    MemoComment: TMemo;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    btnSad: TSpeedButton;
    btnOK: TSpeedButton;
    OpenDialog: TOpenDialog;
    PopupMenu: TPopupMenu;
    Removefromlist1: TMenuItem;
    btnFileAdd: TSpeedButton;
    Addfile1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure btnSadClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnFileAddClick(Sender: TObject);
    procedure lbFilesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Removefromlist1Click(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fOrderComment: TfOrderComment;

implementation

{$R *.dfm}

uses uMain, uOrderForm, uPanelSett;

procedure TfOrderComment.FormActivate(Sender: TObject);
begin
  MemoComment.SetFocus;
end;

procedure TfOrderComment.FormCreate(Sender: TObject);
begin
  fMain.imgList_common.GetBitmap(0, btnSad.Glyph);
  fMain.imgList_common.GetBitmap(3, btnFileAdd.Glyph);
  btnOK.Glyph := fPanelSett.btnSave.Glyph;
end;

procedure TfOrderComment.FormShow(Sender: TObject);
begin
  fOrderComment.Top := fOrder.Top;
  fOrderComment.Left := fOrder.Left;
  fOrderComment.Width := fOrder.Width;
  fOrderComment.Height := fOrder.Height;
end;

procedure TfOrderComment.lbFilesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 46) then
    Removefromlist1.Click;
end;

procedure TfOrderComment.PopupMenuPopup(Sender: TObject);
begin
  Removefromlist1.Enabled := (lbFiles.ItemIndex > -1);
end;

procedure TfOrderComment.Removefromlist1Click(Sender: TObject);
var
  oldIndex: integer;
begin
  if (lbFiles.ItemIndex > -1) then begin
    oldIndex := lbFiles.ItemIndex;
    lbFiles.Items.Delete(lbFiles.ItemIndex);
    try
      lbFiles.ItemIndex := oldIndex;
    except
    end;
  end;
end;

procedure TfOrderComment.btnFileAddClick(Sender: TObject);
begin
  if (OpenDialog.Execute) then begin
    lbFiles.Items.AddStrings(OpenDialog.Files);
  end;
  lbFiles.SetFocus;
end;

procedure TfOrderComment.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfOrderComment.btnSadClick(Sender: TObject);
begin
  fMain.ShowWish('Order comments');
end;

end.
