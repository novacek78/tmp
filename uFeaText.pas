unit uFeaText;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Math, uFeatureObject,
  Buttons;

type
  TfFeaEngraving = class(TForm)
    Panel1: TPanel;
    PgCtrl: TPageControl;
    tabText: TTabSheet;
    edTextX: TLabeledEdit;
    Label2: TLabel;
    edTextY: TLabeledEdit;
    btnCancel: TBitBtn;
    btnSave: TBitBtn;
    comTextAlign: TComboBox;
    Label3: TLabel;
    comTextAlignValue: TComboBox;
    comTextSizeType: TComboBox;
    Label5: TLabel;
    comTextSizeTypeValue: TComboBox;
    Label1: TLabel;
    lbTest: TLabel;
    shRedPoint: TShape;
    Shape2: TShape;
    edTextText: TEdit;
    Label4: TLabel;
    edTextSize: TEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure EditFeature(fea: integer);
    procedure DecimalPoint(Sender: TObject; var Key: Char);
    procedure comTextAlignChange(Sender: TObject);
    procedure comTextSizeTypeChange(Sender: TObject);
    procedure edTextTextKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    is_editing: boolean; // udava, ci je okno otvorene pre vytvorenie alebo editovanie prvku
    edited_feature_ID: integer; // cislo upravovanej feature
    
    { Public declarations }
  end;

var
  fFeaEngraving: TfFeaEngraving;

implementation

uses uMain, uMyTypes, uPanelSett, uConfig, uFeaPocket, uFeaThread;

{$R *.dfm}

procedure TfFeaEngraving.FormCreate(Sender: TObject);
begin
  PgCtrl.ActivePageIndex := 0;
end;

procedure TfFeaEngraving.FormActivate(Sender: TObject);
begin
  edTextText.SetFocus;
end;

function CheckMinMax: boolean;
begin
  result := true;

  with fFeaEngraving do begin

  try

    if (edTextText.Text = '') then begin
      MessageBox(handle, 'Nezadaný text', 'Chyba', MB_ICONERROR);
      edTextText.SetFocus;
      result := false;
    end;

    if (StrToFloat(edTextSize.Text) < 1) then begin
      MessageBox(handle, 'Ve¾kos musí by viac ako 1mm', 'Chyba', MB_ICONERROR);
      edTextSize.SetFocus;
      result := false;
    end;

  except
    MessageBox(handle, 'Nesprávne zadaná èíselná hodnota', 'Chyba', MB_ICONERROR);
    result := false;
  end;


  end; // with
end;

procedure TfFeaEngraving.btnSaveClick(Sender: TObject);
var
  feaNumber: integer;
  newFea: TFeatureObject;
begin
  if not CheckMinMax then begin
    ModalResult := mrNone;
    Exit;
  end;

  if is_editing then feaNumber := edited_feature_ID
  else feaNumber := _PNL.AddFeature(ftTxtGrav);
  newFea := _PNL.GetFeatureByNum(feaNumber);
  newFea.Poloha  := MyPoint( StrToFloat(edTextX.Text), StrToFloat(edTextY.Text) );
  newFea.Param1  := edTextText.Text;
  newFea.Param2  := comTextSizeTypeValue.Text;
  newFea.Param3  := comTextAlignValue.Text;
  newFea.Rozmer1 := StrToFloat(edTextSize.Text);

  ModalResult := mrOK;
  _PNL.Draw;
end;

procedure TfFeaEngraving.EditFeature(fea: integer);
var
  feature: TFeatureObject;
begin
  is_editing := true;
  edited_feature_ID := fea;
  feature := _PNL.GetFeatureByNum(fea);

  edTextText.Text := feature.Param1;
  edTextSize.Text := FormatFloat('0.###', feature.Rozmer1);
  edTextX.Text := FormatFloat('0.###', feature.Poloha.X);
  edTextY.Text := FormatFloat('0.###', feature.Poloha.Y);
  // najdeme ktory v combe je typ zavitu a nasledne ho vyberieme v obidvoch
  comTextSizeTypeValue.ItemIndex := comTextSizeTypeValue.Items.IndexOf(feature.Param2);
  comTextSizeType.ItemIndex := comTextSizeTypeValue.ItemIndex;
  // najdeme ktora v combe je velkost zavitu a nasledne ju vyberieme v obidvoch
  comTextAlignValue.ItemIndex := comTextAlignValue.Items.IndexOf(feature.Param3);
  comTextAlign.ItemIndex := comTextAlignValue.ItemIndex;
end;


procedure TfFeaEngraving.edTextTextKeyPress(Sender: TObject; var Key: Char);
begin
  // ak stlaci ENTER, berie to ako potvrdenie okna
  if Key=#13 then btnSave.Click;
end;

procedure TfFeaEngraving.DecimalPoint(Sender: TObject; var Key: Char);
begin
  // ak tam este nie je '.' tak nahradza ',' za '.' ale ak uz je, nenapise nic
  if Pos('.', (Sender as TCustomEdit).Text ) = 0 then
    if (Key = ',') then Key := '.' else
  else
    if ((Key = ',') OR (Key = '.')) then Key := #0;

  // ak stlaci ENTER, berie to ako potvrdenie okna
  if Key=#13 then btnSave.Click;
end;

procedure TfFeaEngraving.comTextAlignChange(Sender: TObject);
begin
  comTextAlignValue.ItemIndex := comTextAlign.ItemIndex;

  if comTextAlignValue.Text = '0' then
    shRedPoint.Left := lbTest.Left+(lbTest.Width div 2) - (shRedPoint.Width div 2);
  if comTextAlignValue.Text = '1' then
    shRedPoint.Left := lbTest.Left - (shRedPoint.Width div 2);
  if comTextAlignValue.Text = '2' then
    shRedPoint.Left := lbTest.Left+lbTest.Width - (shRedPoint.Width div 2);
end;

procedure TfFeaEngraving.comTextSizeTypeChange(Sender: TObject);
begin
  comTextSizeTypeValue.ItemIndex := comTextSizeType.ItemIndex;
end;

end.
