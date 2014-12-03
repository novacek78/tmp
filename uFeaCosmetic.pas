unit uFeaCosmetic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Math, jpeg, uObjectFeature,
  Buttons, Vcl.Imaging.pngimage;

type
  TfFeaCosmetic = class(TForm)
    Panel1: TPanel;
    PgCtrl: TPageControl;
    tabCirc: TTabSheet;
    tabRect: TTabSheet;
    Image2: TImage;
    Label1: TLabel;
    edRectRadius: TLabeledEdit;
    lbRectRadius: TLabel;
    Image3: TImage;
    edX: TLabeledEdit;
    edY: TLabeledEdit;
    Label2: TLabel;
    Panel2: TPanel;
    btnSadHole: TSpeedButton;
    btnCancel: TBitBtn;
    btnSave: TBitBtn;
    edVyska: TEdit;
    edSirka: TEdit;
    edPriemer: TEdit;
    edName: TEdit;
    lbName: TLabel;
    dlgColor: TColorDialog;
    lbColor: TLabel;
    shpColor: TShape;
    lbChooseColor: TLabel;
    procedure btnSaveClick(Sender: TObject);
    procedure EditFeature(fea: integer);
    procedure DecimalPoint(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSadHoleClick(Sender: TObject);
    procedure LinkLabelClick(Sender: TObject);
    procedure MathExp(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
    procedure clrBoxCosmeticKeyPress(Sender: TObject; var Key: Char);
    procedure lbChooseColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    is_editing: boolean; // udava, ci je okno otvorene pre vytvorenie alebo editovanie prvku
    edited_feature_ID: integer; // cislo upravovanej feature
    
    { Public declarations }
  end;

var
  fFeaCosmetic: TfFeaCosmetic;

implementation

uses uMain, uMyTypes, uPanelSett, uConfig, uObjectPanel, uTranslate, uLib;

{$R *.dfm}

procedure TfFeaCosmetic.FormCreate(Sender: TObject);
begin
  fMain.imgList_common.GetBitmap(0, btnSadHole.Glyph);
  btnCancel.Glyph  := fPanelSett.btnCancel.Glyph;
  btnSave.Glyph    := fPanelSett.btnSave.Glyph;
  PgCtrl.ActivePageIndex := 0;
  PgCtrl.OnDrawTab := fmain.DrawTabs;
end;

procedure TfFeaCosmetic.lbChooseColorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if dlgColor.Execute then
    shpColor.Brush.Color := dlgColor.Color;
end;

procedure TfFeaCosmetic.LinkLabelClick(Sender: TObject);
begin
  fMain.BrowseWiki('tools-maximum-depths');
end;

procedure TfFeaCosmetic.FormActivate(Sender: TObject);
begin
  if PgCtrl.ActivePageIndex = 0 then begin
    edPriemer.SelectAll;
    edPriemer.SetFocus;
  end;
  if PgCtrl.ActivePageIndex = 1 then begin
    edSirka.SelectAll;
    edSirka.SetFocus;
  end;
end;

function CheckMinMax: boolean;
var
  dummyInt, i: integer;
  nastroj: string;
begin
  result := true;

  with fFeaCosmetic do begin

    try

      // kontrola okruhlej diery
      if (PgCtrl.ActivePageIndex = 0) then begin
        if (StrToFloat(edPriemer.Text) < 1) then begin
          MessageBox(handle, PChar(TransTxt('Diameter too small')), PChar(TransTxt('Error')), MB_ICONERROR);
          edPriemer.Text := '1';
          edPriemer.SetFocus;
          result := false;
        end;
        if (StrToFloat(edPriemer.Text) >= _PNL.Vyska) OR (StrToFloat(edPriemer.Text) >= _PNL.Sirka) then begin
          MessageBox(handle, PChar(TransTxt('Diameter too big')), PChar(TransTxt('Error')), MB_ICONERROR);
          edPriemer.Text := FormatFloat('##0.###', Min(_PNL.Vyska,_PNL.Sirka)-1 );
          edPriemer.SetFocus;
          result := false;
        end;

        // kontrola maximalnej hlbky pre dany nastroj
        for i := 0 to cfgToolMaxDepth.Count - 1 do begin
          // vyberie sa maximalne velky nastroj, ktory dokaze urobit dany radius
          if StrToFloat(cfgToolMaxDepth.Names[i]) <= StrToFloat(edPriemer.Text) then
            nastroj := cfgToolMaxDepth.Names[i];
        end;

        if GetToolMaxDepth( nastroj ) < _PNL.Hrubka then begin
          MessageBox(handle, PChar(TransTxt('Hole diameter too small for this panel thickness')), PChar(TransTxt('Error')), MB_ICONERROR);
          edPriemer.SetFocus;
          result := false;
        end;
      end;// kontrola okruhlej diery

      // kontrola obdlznikovej diery
      if (PgCtrl.ActivePageIndex = 1) then begin
        if (StrToFloat(edSirka.Text) < 1) then begin
          MessageBox(handle, PChar(TransTxt('Width too small')), PChar(TransTxt('Error')), MB_ICONERROR);
          edSirka.Text := '1';
          edSirka.SetFocus;
          result := false;
        end;
        if (StrToFloat(edSirka.Text) >= _PNL.Sirka) then begin
          MessageBox(handle, PChar(TransTxt('Width too big')), PChar(TransTxt('Error')), MB_ICONERROR);
          edSirka.Text := FormatFloat('##0.###',_PNL.Sirka-1);
          edSirka.SetFocus;
          result := false;
        end;

        if (StrToFloat(edVyska.Text) < 1) then begin
          MessageBox(handle, PChar(TransTxt('Height too small')), PChar(TransTxt('Error')), MB_ICONERROR);
          edVyska.Text := '1';
          edVyska.SetFocus;
          result := false;
        end;
        if (StrToFloat(edVyska.Text) >= _PNL.Vyska) then begin
          MessageBox(handle, PChar(TransTxt('Height too big')), PChar(TransTxt('Error')), MB_ICONERROR);
          edVyska.Text := FormatFloat('##0.###',_PNL.Vyska-1);
          edVyska.SetFocus;
          result := false;
        end;

        if (StrToFloat(edRectRadius.Text) > StrToFloat(edSirka.Text)/2) OR (StrToFloat(edRectRadius.Text) > StrToFloat(edVyska.Text)/2) then begin
          MessageBox(handle, PChar(TransTxt('Radius too big')), PChar(TransTxt('Error')), MB_ICONERROR);
          edRectRadius.Text := FormatFloat('##0.###', Min( StrToFloat(edSirka.Text)/2  , StrToFloat(edVyska.Text)/2 ) );
          edRectRadius.SetFocus;
          result := false;
        end;

        // kontrola maximalnej hlbky pre dany nastroj
        for i := 0 to cfgToolMaxDepth.Count - 1 do begin
          // vyberie sa maximalne velky nastroj, ktory dokaze urobit dany radius
          if StrToFloat(cfgToolMaxDepth.Names[i])/2 <= StrToFloat(edRectRadius.Text) then
            nastroj := cfgToolMaxDepth.Names[i];
        end;

      end;// kontrola obdlznikovej diery

      StrToFloat(edX.Text);
      StrToFloat(edY.Text);

    except
      MessageBox(handle, PChar(TransTxt('Incorrect numerical value')), PChar(TransTxt('Error')), MB_ICONERROR);
      result := false;
    end;

  end; // with
end;

procedure TfFeaCosmetic.btnSaveClick(Sender: TObject);
var
  feaID: integer;
  newFea: TFeatureObject;
begin
  if not CheckMinMax then begin
    ModalResult := mrNone;
    Exit;
  end;

  _PNL.PrepareUndoStep;


  if PgCtrl.ActivePageIndex = 0 then begin
    if is_editing then feaID := edited_feature_ID
    else feaID := _PNL.AddFeature(ftCosmeticCircle);

    if feaID = -1 then Exit;

    // este to dame do UNDO listu
    if is_editing then
      _PNL.CreateUndoStep('MOD', 'FEA', feaID)
    else
      _PNL.CreateUndoStep('CRT', 'FEA', feaID);

    newFea := _PNL.GetFeatureByID(feaID);
    newFea.Rozmer1  := StrToFloat(edPriemer.Text);
  end;


  if PgCtrl.ActivePageIndex = 1 then begin
    if is_editing then feaID := edited_feature_ID
    else feaID := _PNL.AddFeature(ftCosmeticRect);

    if feaID = -1 then Exit;

    // este to dame do UNDO listu
    if is_editing then
      _PNL.CreateUndoStep('MOD', 'FEA', feaID)
    else
      _PNL.CreateUndoStep('CRT', 'FEA', feaID);

    newFea := _PNL.GetFeatureByID(feaID);
    newFea.Rozmer1  := StrToFloat(edSirka.Text);
    newFea.Rozmer2  := StrToFloat(edVyska.Text);
    newFea.Rozmer3  := StrToFloat(edRectRadius.Text);
  end;

  // ========== spolocne vlastnosti ===================
  newFea.Poloha := MyPoint( StrToFloat(edX.Text), StrToFloat(edY.Text) );
  newFea.Nazov  := edName.Text;
  newFea.Farba  := shpColor.Brush.Color;
  newFea.Rozmer5:= 0;

  ModalResult := mrOK;
  _PNL.Draw;
end;

procedure TfFeaCosmetic.clrBoxCosmeticKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    Key := #0;
    btnSave.Click;
  end;
end;

procedure TfFeaCosmetic.EditFeature(fea: integer);
var
  feature: TFeatureObject;
begin
  is_editing := true;
  edited_feature_ID := fea;
  feature := _PNL.GetFeatureByID(fea);

  edX.Text := FormatFloat('0.###', feature.X);
  edY.Text := FormatFloat('0.###', feature.Y);
  edName.Text := feature.Nazov;
  shpColor.Brush.Color := feature.Farba;

  if feature.Param2 = '' then feature.Param2 := '0'; // ak nie je zadefinovana hrana, zadefinujeme ju na 'ziadnu'

  case feature.Typ of
    ftCosmeticCircle: begin
      tabCirc.TabVisible := true;
      tabRect.TabVisible := false;
      edPriemer.Text := FormatFloat('0.###', feature.Rozmer1);
    end;
    ftCosmeticRect: begin
      tabRect.TabVisible := true;
      tabCirc.TabVisible := false;
      edSirka.Text := FormatFloat('0.###', feature.Rozmer1);
      edVyska.Text := FormatFloat('0.###', feature.Rozmer2);
      edRectRadius.Text := FormatFloat('0.###', feature.Rozmer3);
      lbRectRadius.Enabled := edRectRadius.Enabled;
    end;
  end; //case
end;


procedure TfFeaCosmetic.edNameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    btnSave.Click;
end;

procedure TfFeaCosmetic.MathExp(Sender: TObject);
begin
  uLib.SolveMathExpression(Sender);
end;

procedure TfFeaCosmetic.DecimalPoint(Sender: TObject; var Key: Char);
begin
  fMain.CheckDecimalPoint(sender, key, btnSave);
end;

procedure TfFeaCosmetic.btnSadHoleClick(Sender: TObject);
begin
  fMain.ShowWish('Hole');
end;

end.
