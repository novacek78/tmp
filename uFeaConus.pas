unit uFeaConus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Math, jpeg, uObjectFeature,
  Buttons, Vcl.Imaging.pngimage;

type
  TfFeaConus = class(TForm)
    Panel1: TPanel;
    PgCtrl: TPageControl;
    tabConus: TTabSheet;
    tabCylinder: TTabSheet;
    imgConus: TImage;
    comConusSize: TComboBox;
    Label1: TLabel;
    comConusSizeValue: TComboBox;
    comConusType: TComboBox;
    Label5: TLabel;
    comConusTypeValue: TComboBox;
    Label6: TLabel;
    comConusShape: TComboBox;
    comConusShapeValue: TComboBox;
    imgConusCyl: TImage;
    comConusSizeDepth: TComboBox;
    Image1: TImage;
    edCylHoleDia: TEdit;
    edCylBigDepth: TEdit;
    edCylBigDia: TEdit;
    comConusSizeBigdia: TComboBox;
    comConusSizeSmalldia: TComboBox;
    edY: TLabeledEdit;
    edX: TLabeledEdit;
    Label2: TLabel;
    Panel2: TPanel;
    btnSadConus: TSpeedButton;
    btnCancel: TBitBtn;
    btnSave: TBitBtn;
    tabConusSpecial: TTabSheet;
    procedure btnSaveClick(Sender: TObject);
    procedure EditFeature(fea: integer);
    procedure DecimalPoint(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure ComConusChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSadConusClick(Sender: TObject);
    procedure MathExp(Sender: TObject);
  private
    { Private declarations }
  public
    is_editing: boolean; // udava, ci je okno otvorene pre vytvorenie alebo editovanie prvku
    edited_feature_ID: integer; // cislo upravovanej feature
    
    { Public declarations }
  end;

var
  fFeaConus: TfFeaConus;

implementation

uses uMain, uMyTypes, uPanelSett, uConfig, uTranslate, uLib;

{$R *.dfm}

procedure TfFeaConus.FormCreate(Sender: TObject);
begin
  fMain.imgList_common.GetBitmap(0, btnSadConus.Glyph);
  btnCancel.Glyph := fPanelSett.btnCancel.Glyph;
  btnSave.Glyph := fPanelSett.btnSave.Glyph;
  PgCtrl.ActivePageIndex := 0;

  tabConusSpecial.TabVisible := false;
end;

procedure TfFeaConus.MathExp(Sender: TObject);
begin
  uLib.SolveMathExpression(Sender);
end;

procedure TfFeaConus.FormActivate(Sender: TObject);
begin
  if PgCtrl.ActivePageIndex = 0 then
    comConusSize.SetFocus;
  if PgCtrl.ActivePageIndex = 2 then
    edCylBigDia.SetFocus;
end;

function CheckMinMax: boolean;
var
  dummyInt: integer;
  i: byte;
  nastroj: string;
  tempDepth: Extended;
begin

  result := true;

  with fFeaConus do begin

  try
    StrToFloat(edX.Text);
    StrToFloat(edY.Text);

    // kuzelove zhlbenie
    if (PgCtrl.ActivePageIndex = 0) then begin
      if (StrToFloat(comConusSizeDepth.Text) > _PNL.Hrubka) then begin
        MessageBox(handle, PChar(TransTxt('Countersink depth is bigger, than panel thickness.')+#13+
                                 TransTxt('Please use "Conical special" instead and set correct depth.')), PChar(TransTxt('Error')), MB_ICONERROR);
        comConusSize.SetFocus;
        result := false;
      end;

      // kontrola maximalnej hlbky pre dany nastroj - tento vyber musi korespondovat s PHP skriptom TECHNOLOGY_v2.PHP
      if (StrToFloat(comConusSizeValue.Text) < 2) then nastroj := '1.5'
      else if (StrToFloat(comConusSizeValue.Text) < 3) then nastroj := '2'
      else if (StrToFloat(comConusSizeValue.Text) < 6) then nastroj := '3'
      else nastroj := '6';

      if GetToolMaxDepth(nastroj) < _PNL.Hrubka then begin
        MessageBox(handle, PChar(TransTxt('Hole diameter too small for this panel thickness')), PChar(TransTxt('Error')), MB_ICONERROR);
        comConusSize.SetFocus;
        result := false;
      end;

    end;

    // valcove zahlbenie
    if (PgCtrl.ActivePageIndex = 2) then begin
      if (StrToFloat(edCylBigDia.Text) <= StrToFloat(edCylHoleDia.Text)) then begin
        MessageBox(handle, PChar(TransTxt('Countersink diameter has to be greater than hole diameter')), PChar(TransTxt('Error')), MB_ICONERROR);
        edCylBigDia.SetFocus;
        result := false;
      end;

      if (StrToFloat(edCylBigDepth.Text) >= _PNL.Hrubka) then begin
        MessageBox(handle, PChar(TransTxt('Depth is too big.')), PChar(TransTxt('Error')), MB_ICONERROR);
        edCylBigDepth.SetFocus;
        result := false;
      end;

      // kontrola maximalnej hlbky pre dany nastroj
      if (StrToFloat(edCylHoleDia.Text) < 2) then nastroj := '1.5'
      else if (StrToFloat(edCylHoleDia.Text) < 3) then nastroj := '2'
      else if (StrToFloat(edCylHoleDia.Text) < 6) then nastroj := '3'
      else nastroj := '6';

      // ak je horne zahlbenie aspon o 2mm vacsie ako diera, tak pri volbe nastroja berieme ako hlbku len hlbku samotnej diery
      if (StrToFloat(edCylBigDia.Text)-StrToFloat(edCylHoleDia.Text) >= 2) then
        tempDepth := _PNL.Hrubka - StrToFloat(edCylBigDepth.Text)
      else
        tempDepth := _PNL.Hrubka;

      if GetToolMaxDepth(nastroj) < tempDepth then begin
        MessageBox(handle, PChar(TransTxt('Hole diameter too small for this panel thickness')), PChar(TransTxt('Error')), MB_ICONERROR);
        comConusSize.SetFocus;
        result := false;
      end;
    end;

  except
    MessageBox(handle, PChar(TransTxt('Incorrect numerical value')), PChar(TransTxt('Error')), MB_ICONERROR);
    result := false;
  end;

  end; // with

end;

procedure TfFeaConus.btnSaveClick(Sender: TObject);
var
  feaID: integer;
  newFea: TFeatureObject;
begin

  if not CheckMinMax then begin
    ModalResult := mrNone;
    Exit;
  end;

  _PNL.PrepareUndoStep;

  // standardne kuzelove zahlbenie
  if PgCtrl.ActivePageIndex = 0 then begin
    if is_editing then feaID := edited_feature_ID
    else feaID := _PNL.AddFeature(ftSink);

    if feaID = -1 then Exit;

    // este to dame do UNDO listu
    if is_editing then
      _PNL.CreateUndoStep('MOD', 'FEA', feaID)
    else
      _PNL.CreateUndoStep('CRT', 'FEA', feaID);

    newFea := _PNL.GetFeatureByID(feaID);
    newFea.Poloha := MyPoint( StrToFloat(edX.Text), StrToFloat(edY.Text) );
    newFea.Rozmer3 := StrToFloat(comConusSizeValue.Text);  // rozmer zavitu skrutky (napr. 6 pre M6)
    newFea.Rozmer1 := StrToFloat(comConusSizeBigdia.Text);
    newFea.Rozmer2 := StrToFloat(comConusSizeSmalldia.Text);

{
    // priemer kuzela na povrchu (ulozene len koli kresleniu)
    if comConusSizeValue.Text = '1.6' then newFea.Rozmer1 := 4.5; // ak tieto 2 hodnoty neporovnavam ako text, nenajde zhodu
    if comConusSizeValue.Text = '1.7' then newFea.Rozmer1 := 4.5;
    if newFea.Rozmer3 = 2   then newFea.Rozmer1 := 4.5;
    if newFea.Rozmer3 = 2.5 then newFea.Rozmer1 := 5.3;
    if newFea.Rozmer3 = 3   then newFea.Rozmer1 := 6.3;
    if newFea.Rozmer3 = 3.5 then newFea.Rozmer1 := 7.5;
    if newFea.Rozmer3 = 4   then newFea.Rozmer1 := 8.6;
    if newFea.Rozmer3 = 5   then newFea.Rozmer1 := 10.5;
    if newFea.Rozmer3 = 6   then newFea.Rozmer1 := 12.3;
    if newFea.Rozmer3 = 8   then newFea.Rozmer1 := 16.1;
    if newFea.Rozmer3 = 10  then newFea.Rozmer1 := 20.3;
    // priemer otvoru pre skrutku (ulozene len koli kresleniu)
    if comConusSizeValue.Text = '1.6' then newFea.Rozmer2 := 2.3; // ak tieto 2 hodnoty neporovnavam ako text, nenajde zhodu
    if comConusSizeValue.Text = '1.7' then newFea.Rozmer2 := 2.3;
    if newFea.Rozmer3 = 2   then newFea.Rozmer2 := 2.3;
    if newFea.Rozmer3 = 2.5 then newFea.Rozmer2 := 2.8;
    if newFea.Rozmer3 = 3   then newFea.Rozmer2 := 3.3;
    if newFea.Rozmer3 = 3.5 then newFea.Rozmer2 := 3.8;
    if newFea.Rozmer3 = 4   then newFea.Rozmer2 := 4.4;
    if newFea.Rozmer3 = 5   then newFea.Rozmer2 := 5.4;
    if newFea.Rozmer3 = 6   then newFea.Rozmer2 := 6.5;
    if newFea.Rozmer3 = 8   then newFea.Rozmer2 := 8.6;
    if newFea.Rozmer3 = 10  then newFea.Rozmer2 := 10.7;
}
    newFea.Hlbka1 := 9999;
    newFea.Param1 := comConusTypeValue.Text;
    newFea.Param2 := comConusShapeValue.Text;
  end;

  // specialne kuzelove zahlbenie (detailne popisane)
  if PgCtrl.ActivePageIndex = 1 then begin
{
    if is_editing then feaNumber := edited_feature_ID
    else feaNumber := _PNL.AddFeature(ftSinkSpecial);

    if feaNumber = -1 then Exit;

    // este to dame do UNDO listu
    if is_editing then
      _PNL.CreateUndoStep('MOD', 'FEA', feaID)
    else
      _PNL.CreateUndoStep('CRT', 'FEA', feaID);

    newFea := _PNL.GetFeatureByNum(feaNumber);
}
  end;

  // valcove zahlbenie
  if PgCtrl.ActivePageIndex = 2 then begin
    if is_editing then feaID := edited_feature_ID
    else feaID := _PNL.AddFeature(ftSinkCyl);

    if feaID = -1 then Exit;

    // este to dame do UNDO listu
    if is_editing then
      _PNL.CreateUndoStep('MOD', 'FEA', feaID)
    else
      _PNL.CreateUndoStep('CRT', 'FEA', feaID);

    newFea := _PNL.GetFeatureByID(feaID);
    newFea.Poloha := MyPoint( StrToFloat(edX.Text), StrToFloat(edY.Text) );
    newFea.Rozmer1 := StrToFloat(edCylBigDia.Text); // velky priemer (zahlbenia)
    newFea.Rozmer2 := StrToFloat(edCylHoleDia.Text);  // maly priemer (diery)
    newFea.Rozmer3 := StrToFloat(edCylBigDepth.Text); // hlbka zahlbenia
    newFea.Hlbka1  := 9999;
  end;

  ModalResult := mrOK;
  _PNL.Draw;

end;

procedure TfFeaConus.EditFeature(fea: integer);
var
  feature: TFeatureObject;
begin

  is_editing := true;
  edited_feature_ID := fea;
  feature := _PNL.GetFeatureByID(fea);

  case feature.Typ of
    ftSink: begin
      tabConus.TabVisible := true;
      tabCylinder.TabVisible := false;
      comConusSizeValue.ItemIndex  := comConusSizeValue.Items.IndexOf( FormatFloat('0.###', feature.Rozmer3) );
      comConusSizeDepth.ItemIndex  := comConusSizeValue.ItemIndex;
      comConusSizeBigdia.ItemIndex := comConusSizeValue.ItemIndex;
      comConusSizeSmalldia.ItemIndex := comConusSizeValue.ItemIndex;
      comConusTypeValue.ItemIndex  := comConusTypeValue.Items.IndexOf(feature.Param1);
      comConusShapeValue.ItemIndex := comConusShapeValue.Items.IndexOf(feature.Param2);
      comConusSize.ItemIndex  := comConusSizeValue.ItemIndex;
      comConusType.ItemIndex  := comConusTypeValue.ItemIndex;
      comConusShape.ItemIndex := comConusShapeValue.ItemIndex;
      if comConusShape.ItemIndex = 0 then imgConus.BringToFront;
      if comConusShape.ItemIndex = 1 then imgConusCyl.BringToFront;
      edX.Text := FormatFloat('0.###', feature.X);
      edY.Text := FormatFloat('0.###', feature.Y);
    end;
    ftSinkCyl: begin
      tabConus.TabVisible := false;
      tabCylinder.TabVisible := true;
      edCylBigDia.Text   := FormatFloat('0.###', feature.Rozmer1);
      edCylHoleDia.Text  := FormatFloat('0.###', feature.Rozmer2);
      edCylBigDepth.Text := FormatFloat('0.###', feature.Rozmer3);
      edX.Text := FormatFloat('0.###', feature.X);
      edY.Text := FormatFloat('0.###', feature.Y);
    end;
  end; //case
end;


procedure TfFeaConus.DecimalPoint(Sender: TObject; var Key: Char);
begin
  fMain.CheckDecimalPoint(sender, key, btnSave);
end;

procedure TfFeaConus.ComConusChange(Sender: TObject);
var
  obj1: ^TComboBox;
begin
  obj1 := @Sender;

  if obj1.Name = 'comConusSize'  then begin
    comConusSizeValue.ItemIndex := comConusSize.ItemIndex;
    comConusSizeDepth.ItemIndex := comConusSize.ItemIndex;
    comConusSizeBigdia.ItemIndex   := comConusSize.ItemIndex;
    comConusSizeSmalldia.ItemIndex := comConusSize.ItemIndex;
  end;

  if obj1.Name = 'comConusType'  then
    comConusTypeValue.ItemIndex := comConusType.ItemIndex;

  if obj1.Name = 'comConusShape' then begin
    comConusShapeValue.ItemIndex := comConusShape.ItemIndex;
    if obj1.ItemIndex = 0 then imgConus.BringToFront;
    if obj1.ItemIndex = 1 then imgConusCyl.BringToFront;
  end;
end;

procedure TfFeaConus.btnSadConusClick(Sender: TObject);
begin
  fMain.ShowWish('Countersink hole');
end;

end.
