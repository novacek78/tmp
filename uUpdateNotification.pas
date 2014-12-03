unit uUpdateNotification;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.StdCtrls, Math;

type
  TfUpdateNotification = class(TForm)
    lb01: TLabel;
    lb02: TLabel;
    lb03: TLabel;
    lb04: TLabel;
    lb05: TLabel;
    lb06: TLabel;
    btnNo: TSpeedButton;
    btnYes: TSpeedButton;
    lbLink: TLabel;
    procedure btnYesClick(Sender: TObject);
    procedure btnNoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    function  ShowModal(version: string): integer;
    procedure FormCreate(Sender: TObject);
    procedure lbLinkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fUpdateNotification: TfUpdateNotification;

implementation

{$R *.dfm}

uses uConfig, uMain, uPanelSett;

var
  updateVersion: string;

procedure TfUpdateNotification.FormCreate(Sender: TObject);
begin
  btnNo.Glyph  := fPanelSett.btnCancel.Glyph;
  btnYes.Glyph := fPanelSett.btnSave.Glyph;
end;

procedure TfUpdateNotification.lbLinkClick(Sender: TObject);
begin
  fMain.BrowseUrl('changelog-changes-whats-new');
end;

procedure TfUpdateNotification.FormActivate(Sender: TObject);
begin
  // zapolohujeme labely s verziami hned za PRELOZENE texty, ktore neviem ake mozu byt dlhe
  lb04.Left := lb02.Left + Max(lb02.Width, lb03.Width) + 20;
  lb05.Left := lb04.Left;

  lb04.Caption := IntToStr(cfg_swVersion1) + '.' + IntToStr(cfg_swVersion2) + '.' + IntToStr(cfg_swVersion3);
  lb05.Caption := updateVersion;
end;

function TfUpdateNotification.ShowModal(version: string): integer;
begin
  updateVersion := IntToStr(StrToInt(Copy(version, 1, 1))) + '.' + IntToStr(StrToInt(Copy(version, 2, 2))) + '.' + IntToStr(StrToInt(Copy(version, 4, 2)));
  inherited ShowModal;
end;



procedure TfUpdateNotification.btnNoClick(Sender: TObject);
begin
  ModalResult := mrNo;
end;

procedure TfUpdateNotification.btnYesClick(Sender: TObject);
begin
  ModalResult := mrYes;
end;

end.
