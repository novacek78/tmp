unit uRegisteredCode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, IniFiles, Registry;

type
  TfRegisteredCode = class(TForm)
    GroupBox1: TGroupBox;
    edCode: TLabeledEdit;
    Panel1: TPanel;
    btnSave: TSpeedButton;
    Label1: TLabel;
    btnSad: TSpeedButton;
    procedure btnSaveClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSadClick(Sender: TObject);
    procedure edCodeKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fRegisteredCode: TfRegisteredCode;

implementation

uses uMain, uPanelSett, uTranslate;

{$R *.dfm}

procedure TfRegisteredCode.FormCreate(Sender: TObject);
begin
  fMain.imgList_common.GetBitmap(0, btnSad.Glyph);
  btnSave.Glyph:= fPanelSett.btnSave.Glyph;
  edCode.Text := fMain.ReadRegistry_string('User', 'UserCode');
end;

procedure TfRegisteredCode.FormShow(Sender: TObject);
begin
  // pri zobrazeni nacita kod vzdy znovu
  // (ak tam user nieco pisal a potom stlacil ESC, aby to tam nezostalo)
  edCode.Text := fMain.ReadRegistry_string('User', 'UserCode');
end;

procedure TfRegisteredCode.btnSaveClick(Sender: TObject);
begin
  fMain.WriteRegistry_string('User', 'UserCode', edCode.Text);
  if Length(edCode.Text) > 0 then
    MessageBox(handle, PChar(TransTxt('Thank you for your registration.')), PChar(TransTxt('Information')), MB_ICONINFORMATION);
  Close;
end;

procedure TfRegisteredCode.edCodeKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnSave.Click;
end;

procedure TfRegisteredCode.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 27 then Close;
end;

procedure TfRegisteredCode.btnSadClick(Sender: TObject);
begin
  fMain.ShowWish('Registration code');
end;

end.
