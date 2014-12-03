unit uPoziadavka;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons;

type
  TfPoziadavka = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel3: TPanel;
    edTopic: TLabeledEdit;
    memMessage: TMemo;
    Label7: TLabel;
    btnCancel: TBitBtn;
    btnSend: TBitBtn;
    rbNotifyThis: TRadioButton;
    rbNotifyAlways: TRadioButton;
    rbNotifyNever: TRadioButton;
    lbGiveEmail: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure memMessageKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnSendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rbNotifyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPoziadavka: TfPoziadavka;

implementation

uses uRegisteredCode, uMain, uOrderForm, uConfig, uPanelSett, uTranslate,
  uObjectUrlDotaz;

{$R *.dfm}

procedure TfPoziadavka.FormCreate(Sender: TObject);
begin
  btnCancel.Glyph := fPanelSett.btnCancel.Glyph;
  btnSend.Glyph   := fPanelSett.btnSave.Glyph;
end;

procedure TfPoziadavka.FormActivate(Sender: TObject);
begin
  memMessage.SetFocus;

  // ak je nezaregistrovany, default bude "neposielajte mi oznamenia"
  if (Length(fRegisteredCode.edCode.Text) <> 32) then begin
    rbNotifyNever.Checked := true;
    lbGiveEmail.Visible := false;
  end;
end;

procedure TfPoziadavka.memMessageKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=27) then btnCancel.Click;  // ESC

  if (Key=65) AND (ssCtrl in Shift) then  // CTRL + A
    memMessage.SelectAll;
end;

procedure TfPoziadavka.rbNotifyClick(Sender: TObject);
begin
  if (Length(fRegisteredCode.edCode.Text) <> 32) then begin
    if (Sender as TRadioButton).Name = 'rbNotifyThis' then lbGiveEmail.Visible := true;
    if (Sender as TRadioButton).Name = 'rbNotifyAlways' then lbGiveEmail.Visible := true;
    if (Sender as TRadioButton).Name = 'rbNotifyNever' then lbGiveEmail.Visible := false;
  end;
end;

procedure TfPoziadavka.btnSendClick(Sender: TObject);
var
  msg, notify: string;
  i: integer;
  dotaz: TUrlDotaz;
begin
  // odosle poziadavku do databazy

  // ak nie je zaregistrovany, nedovoli odoslat
  // 25.6.2009 : povolime to nateraz aj nezaregistrovanym
{
  if Length(fRegisteredCode.edCode.Text) <> 32 then begin
    fMain.RemindRegister(fOrder.Handle);
    Exit;
  end;
}
  // ak nezadal ziadny text
  if memMessage.Lines.Count = 0 then begin
    MessageBox(handle, PChar(TransTxt('Please enter your request.')), PChar(TransTxt('Error')), MB_ICONERROR);
    ModalResult := mrNone;
    memMessage.SetFocus;
    Exit;
  end;

  // spoji vsetky riadky z Mema do jedneho stringu
  msg := '';
  for i:=0 to memMessage.Lines.Count-1 do
    msg := msg + memMessage.Lines.Strings[i] + '<br>';

  // podla prepnutych radio buttonov nastavi retazec 'Notify'
  if rbNotifyThis.Checked        then notify := 'this'
  else if rbNotifyAlways.Checked then notify := 'always'
  else if rbNotifyNever.Checked  then notify := 'never';

  // disabluje prvky, nech user vie, ze sa nieco riesi
  btnCancel.Enabled := false;
  btnSend.Enabled := false;
  rbNotifyThis.Enabled := false;
  rbNotifyAlways.Enabled := false;
  rbNotifyNever.Enabled := false;
  memMessage.Enabled := false;

  Application.ProcessMessages;

  // skontroluje pripojenie
  if not fMain.RunPhpScript('test_connection.php', handle, true) then begin
    MessageBox(handle, PChar(TransTxt('Can not connect to the server.')+#13+TransTxt('Check your internet connection.')), PChar(TransTxt('Error')), MB_ICONERROR);
    // enabluje prvky spat
    btnCancel.Enabled := true;
    btnSend.Enabled := true;
    rbNotifyThis.Enabled := true;
    rbNotifyAlways.Enabled := true;
    rbNotifyNever.Enabled := true;
    memMessage.Enabled := true;
    Exit;
  end;

  // odosle pripomienku do systemu
  dotaz := TUrlDotaz.Create('addnewwish.php');
  dotaz.params.Add('uid='+fRegisteredCode.edCode.Text);
  dotaz.params.Add('prtid='+cfg_PartnerCode);
  dotaz.params.Add('topic='+edTopic.Text);
  dotaz.params.Add('msg='+msg);
  dotaz.params.Add('notify='+notify);
  fMain.RunPhpScript(dotaz ,handle , true);
  dotaz.Free;

  if UrlAnswer = 'OK' then
    MessageBox(handle, PChar(TransTxt('Thank you for your request.')), PChar(TransTxt('Information')), MB_ICONINFORMATION)
  else
    MessageBox(handle, PChar(TransTxt('We were unable to record your request, please try again later.')+#13+TransTxt('Error')+': '+UrlAnswer), PChar(TransTxt('Error')), MB_ICONERROR);

  // enabluje prvky spat
  btnCancel.Enabled := true;
  btnSend.Enabled := true;
  rbNotifyThis.Enabled := true;
  rbNotifyAlways.Enabled := true;
  rbNotifyNever.Enabled := true;
  memMessage.Enabled := true;
end;

end.
