unit uRegisterUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Registry;

type
  TfRegisterUser = class(TForm)
    gb2: TGroupBox;
    gb3: TGroupBox;
    Panel1: TPanel;
    edPSC2: TLabeledEdit;
    edMesto2: TLabeledEdit;
    edUlica2: TLabeledEdit;
    cbDeliverToBillingAddress: TCheckBox;
    Memo1: TMemo;
    cbPersonalAgree: TCheckBox;
    btnSend: TBitBtn;
    btnCancel: TBitBtn;
    edUlica: TLabeledEdit;
    edMesto: TLabeledEdit;
    edPSC: TLabeledEdit;
    Label1: TLabel;
    Label2: TLabel;
    btnSad: TSpeedButton;
    comKrajina: TComboBox;
    Label3: TLabel;
    comKrajinaValue: TComboBox;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    lbStat: TLabel;
    comStat: TComboBox;
    shapeStat: TShape;
    comStatValue: TComboBox;
    lbKrajina2: TLabel;
    comKrajina2: TComboBox;
    lbStat2: TLabel;
    comStat2: TComboBox;
    edMeno2: TLabeledEdit;
    edPriezvisko2: TLabeledEdit;
    edFirma2: TLabeledEdit;
    edMeno: TLabeledEdit;
    edPriezvisko: TLabeledEdit;
    edFirma: TLabeledEdit;
    edICO: TLabeledEdit;
    edDIC: TLabeledEdit;
    Shape9: TShape;
    Shape10: TShape;
    edEmail: TLabeledEdit;
    edTel: TLabeledEdit;
    Shape3: TShape;
    edICDPH: TLabeledEdit;
    procedure CheckData(Sender: TObject);
    procedure cbDeliverToBillingAddressClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnSadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fRegisterUser: TfRegisterUser;

implementation

uses uMain, uConfig, uPersonal, uPanelSett, uTranslate, uObjectUrlDotaz;

{$R *.dfm}

procedure TfRegisterUser.FormCreate(Sender: TObject);
begin
  fMain.imgList_common.GetBitmap(0, btnSad.Glyph);
  btnCancel.Glyph := fPanelSett.btnCancel.Glyph;
  btnSend.Glyph := fPanelSett.btnSave.Glyph;
end;

procedure TfRegisterUser.cbDeliverToBillingAddressClick(Sender: TObject);
var
	b: boolean;
begin
	b := not cbDeliverToBillingAddress.Checked;

  if (b) then begin
  	comKrajina2.ItemIndex := comKrajina.ItemIndex;
    comStat2.ItemIndex := comStat.ItemIndex;
    comKrajina2.OnChange(comKrajina2);
  end;

	edMeno2.Enabled := b;
  edPriezvisko2.Enabled := b;
  edFirma2.Enabled := b;
  edUlica2.Enabled := b;
  edMesto2.Enabled := b;
  edPSC2.Enabled   := b;
  lbKrajina2.Enabled := b;
  comKrajina2.Enabled := b;
  lbStat2.Enabled := b;
  comStat2.Enabled := b;

  if edMeno2.Enabled then edMeno2.SetFocus;
end;

procedure TfRegisterUser.CheckData(Sender: TObject);
begin
  comStat.Visible := (comKrajinaValue.Items[comKrajina.ItemIndex] = 'US');
  comStat2.Visible := (comKrajinaValue.Items[comKrajina2.ItemIndex] = 'US');
  lbStat.Visible := comStat.Visible;
  lbStat2.Visible := comStat2.Visible;
  shapeStat.Visible := comStat.Visible;
  edICDPH.Visible := (comKrajinaValue.Items[comKrajina.ItemIndex] = 'SK');

  btnSend.Enabled :=
    (edMeno.Text       <> '') AND
    (edPriezvisko.Text <> '') AND
    (edEmail.Text      <> '') AND
    (edUlica.Text      <> '') AND
    (edMesto.Text      <> '') AND
    (edPSC.Text        <> '') AND
    (comKrajina.ItemIndex > -1 ) AND
    (comKrajinaValue.Items[comKrajina.ItemIndex] <> '') AND
    (cbPersonalAgree.Checked) AND
    ((comStat.Visible = false) OR (comStat.ItemIndex > -1));
end;

procedure TfRegisterUser.btnSendClick(Sender: TObject);
var
  urlparams: string;
  dotaz: TUrlDotaz;
begin
  dotaz := TUrlDotaz.Create('registeruser.php');
  dotaz.params.Add('prtid='+cfg_PartnerCode);
  dotaz.params.Add('meno='+edMeno.Text);
  dotaz.params.Add('priezvisko='+edPriezvisko.Text);
  dotaz.params.Add('email='+edEmail.Text);
  dotaz.params.Add('telefon='+edTel.Text);
  dotaz.params.Add('ulica='+edUlica.Text);
  dotaz.params.Add('mesto='+edMesto.Text);
  dotaz.params.Add('psc='+edPSC.Text);
  dotaz.params.Add('krajina='+comKrajinaValue.Items.Strings[ comKrajina.ItemIndex ]);
  dotaz.params.Add('stat='+comStatValue.Items.Strings[ comStat.ItemIndex ]);
  dotaz.params.Add('firma='+edFirma.Text);
  dotaz.params.Add('ico='+edICO.Text);
  dotaz.params.Add('dic='+edDIC.Text);
  dotaz.params.Add('icdph='+edICDPH.Text);

  // ak je fakturacna adresa ina, tak ju tiez posle
  if not cbDeliverToBillingAddress.Checked then begin
    dotaz.params.Add('meno2='+edMeno2.Text);
    dotaz.params.Add('priezvisko2='+edPriezvisko2.Text);
	  dotaz.params.Add('firma2='+edFirma2.Text);
    dotaz.params.Add('ulica2='+edUlica2.Text);
    dotaz.params.Add('mesto2='+edMesto2.Text);
    dotaz.params.Add('psc2='+edPSC2.Text);
    dotaz.params.Add('krajina2='+comKrajinaValue.Items.Strings[ comKrajina2.ItemIndex ]);
    dotaz.params.Add('stat2='+comStatValue.Items.Strings[ comStat2.ItemIndex ]);
  end;

  // odosleme registraciu
  if fMain.RunPhpScript(dotaz ,handle) then begin

    if UrlAnswer = 'OK' then begin
      // ak je vsetko OK
      MessageBox(handle, PChar(TransTxt('You are now succesfully registered user.')+#13+
                         TransTxt('Please wait for an e-mail with the registration code and further instructions.')),
                         PChar(TransTxt('Information')), MB_ICONINFORMATION);

      fMain.WriteRegistry_string('User', 'UserName', edMeno.Text +' '+ edPriezvisko.Text);
      fMain.WriteRegistry_string('User', 'UserCompany', edFirma.Text);
      fMain.WriteRegistry_string('User', 'UserEmail', edEmail.Text);
      fMain.WriteRegistry_string('User', 'UserCode', '');
      Close;
    end else begin
      // ak je chyba, zobrazi pricinu
      MessageBox(handle, PChar(TransTxt('Registration failed.')+' '+TransTxt('Reason:')+#13+UrlAnswer),
                               PChar(TransTxt('Error')), MB_ICONERROR);
    end;
  end else
    MessageBox(handle, PChar(TransTxt('Registration failed. Please try again later.')),
                       PChar(TransTxt('Error')), MB_ICONERROR);

  dotaz.Free;
end;

procedure TfRegisterUser.btnSadClick(Sender: TObject);
begin
  fMain.ShowWish('User registration');
end;

end.
