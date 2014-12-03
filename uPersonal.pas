unit uPersonal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, IniFiles;

type
  TfPersonal = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    edUlica: TLabeledEdit;
    edMesto: TLabeledEdit;
    edPSC: TLabeledEdit;
    comDelivery: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    comPriority: TComboBox;
    btnSadPersonal: TSpeedButton;
    Label1: TLabel;
    comPaymentMethod: TComboBox;
    comPaymentMethodValue: TComboBox;
    comDeliveryValue: TComboBox;
    btnOK: TBitBtn;
    lbKrajina: TLabel;
    comKrajina: TComboBox;
    lbStat: TLabel;
    comStat: TComboBox;
    comKrajinaValue: TComboBox;
    comStatValue: TComboBox;
    edMeno: TLabeledEdit;
    edPriezvisko: TLabeledEdit;
    edFirma: TLabeledEdit;
    comDeliveryAddress: TRadioButton;
    comBillingAddress: TRadioButton;
    comOtherAddress: TRadioButton;
    function  CheckData: boolean;
    procedure FormCreate(Sender: TObject);
    procedure comboAddressesClick(Sender: TObject);
    procedure btnSadPersonalClick(Sender: TObject);
    procedure UpdateData(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPersonal: TfPersonal;

implementation

uses uDebug, uMain, uPanelSett, uTranslate;

{$R *.dfm}


procedure TfPersonal.FormCreate(Sender: TObject);
begin
  fMain.imgList_common.GetBitmap(0, btnSadPersonal.Glyph);
  btnOK.Glyph    := fPanelSett.btnSave.Glyph;
  if CheckData then
    ModalResult := mrOK
  else
    ModalResult := mrCancel;
end;

procedure TfPersonal.UpdateData(Sender: TObject);
begin
  comKrajinaValue.ItemIndex := comKrajina.ItemIndex;
  comStatValue.ItemIndex := comStat.ItemIndex;

  comStat.Visible := (comKrajinaValue.Text = 'US');
  lbStat.Visible := comStat.Visible;
end;

procedure TfPersonal.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if not comOtherAddress.Checked then
    CanClose := true
  else if CheckData then
    CanClose := true
  else begin
    MessageBox(handle, Pchar(TransTxt('Some fields are empty')),Pchar(TransTxt('Error')), MB_ICONERROR);
    CanClose := false;
  end;

end;

function TfPersonal.CheckData: boolean;
begin
  // ak chce pouzit data z registracie, je to OK a nekontroluje uz polia
  if not comOtherAddress.Checked then
    result := true
  else
    result :=
      (edMeno.Text <> '') AND
      (edPriezvisko.Text <> '') AND
      (edUlica.Text <> '') AND
      (edMesto.Text <> '') AND
      (comKrajinaValue.Text   <> '') AND
      (edPSC.Text   <> '');
end;

procedure TfPersonal.comboAddressesClick(Sender: TObject);
var
  ena: boolean;
begin
  ena := comOtherAddress.Checked;

  edFirma.Enabled := ena;
  edMeno.Enabled := ena;
  edPriezvisko.Enabled := ena;
  edUlica.Enabled := ena;
  edMesto.Enabled := ena;
  edPSC.Enabled := ena;
  lbKrajina.Enabled := ena;
  comKrajina.Enabled := ena;

  if ena then edMeno.SetFocus;
end;

procedure TfPersonal.btnSadPersonalClick(Sender: TObject);
begin
  fMain.ShowWish('Shipping details');
end;

end.
