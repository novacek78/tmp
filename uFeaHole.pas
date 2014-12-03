unit uFeaHole;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Math, jpeg, uObjectFeature,
  Buttons, Vcl.Imaging.pngimage;

type
  TfFeaHole = class(TForm)
    Panel1: TPanel;
    PgCtrl: TPageControl;
    tabHoleCirc: TTabSheet;
    tabHoleRect: TTabSheet;
    Image2: TImage;
    comRectRadius: TComboBox;
    Label1: TLabel;
    edRectRadius: TLabeledEdit;
    lbRectRadius: TLabel;
    Image3: TImage;
    Label4: TLabel;
    Label5: TLabel;
    edX: TLabeledEdit;
    edY: TLabeledEdit;
    Label2: TLabel;
    Panel2: TPanel;
    btnSadHole: TSpeedButton;
    btnCancel: TBitBtn;
    btnSave: TBitBtn;
    Label3: TLabel;
    comEdgeStyle: TComboBox;
    lbEdgeSize: TLabel;
    edEdgeSize: TEdit;
    comEdgeStyleValue: TComboBox;
    Label13: TLabel;
    edVyska: TEdit;
    edSirka: TEdit;
    edPriemer: TEdit;
    procedure comRectRadiusChange(Sender: TObject);
    function  CalculateRadius: Double;
    procedure CheckRadius(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure EditFeature(fea: integer);
    procedure DecimalPoint(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSadHoleClick(Sender: TObject);
    procedure comEdgeStyleChange(Sender: TObject);
    procedure LinkLabelClick(Sender: TObject);
    procedure MathExp(Sender: TObject);
  private
    { Private declarations }
  public
    is_editing: boolean; // udava, ci je okno otvorene pre vytvorenie alebo editovanie prvku
    edited_feature_ID: integer; // cislo upravovanej feature
    
    { Public declarations }
  end;

var
  fFeaHole: TfFeaHole;

implementation

uses uMain, uMyTypes, uPanelSett, uConfig, uObjectPanel, uTranslate, uLib;

{$R *.dfm}

procedure TfFeaHole.FormCreate(Sender: TObject);
begin
  fMain.imgList_common.GetBitmap(0, btnSadHole.Glyph);
  btnCancel.Glyph  := fPanelSett.btnCancel.Glyph;
  btnSave.Glyph    := fPanelSett.btnSave.Glyph;
  PgCtrl.ActivePageIndex := 0;
  PgCtrl.OnDrawTab := fmain.DrawTabs;
end;

procedure TfFeaHole.LinkLabelClick(Sender: TObject);
begin
  fMain.BrowseWiki('tools-maximum-depths');
end;

procedure TfFeaHole.FormActivate(Sender: TObject);
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

procedure TfFeaHole.comEdgeStyleChange(Sender: TObject);
begin
  comEdgeStyleValue.ItemIndex := comEdgeStyle.ItemIndex;
  edEdgeSize.Enabled := (comEdgeStyle.ItemIndex = 1);
  lbEdgeSize.Enabled := edEdgeSize.Enabled;
  if edEdgeSize.Enabled then edEdgeSize.SetFocus;
end;

procedure TfFeaHole.comRectRadiusChange(Sender: TObject);
begin
  edRectRadius.Enabled := (comRectRadius.ItemIndex = 1);
  lbRectRadius.Enabled := edRectRadius.Enabled;
  if edRectRadius.Enabled then edRectRadius.SetFocus;
  if not edRectRadius.Enabled then CheckRadius(sender);
end;

procedure TfFeaHole.CheckRadius(Sender: TObject);
begin
  if comRectRadius.ItemIndex = 0 then
    edRectRadius.Text := FormatFloat('0.##', CalculateRadius );
  if comRectRadius.ItemIndex = 2 then
    edRectRadius.Text := '0';
end;

function TfFeaHole.CalculateRadius: Double;
var
  x, y: Double;
begin
  try
    x := StrToFloat(edSirka.Text);
    y := StrToFloat(edVyska.Text);

    result := 0.5; // default 1mm freza
    if (x > 2) AND (y > 2) then result := 0.75;  // freza 1.5 mm
    if (x > 4) AND (y > 4) then result := 1;     // freza 2 mm
    if (x > 6) AND (y > 6) then result := 1.5;   // freza 3 mm
    if (x > 15) AND (y > 15) then result := 3;   // freza 6 mm
  except
    result := 0;
  end;
end;

function CheckMinMax: boolean;
var
  dummyInt, i: integer;
  nastroj: string;
begin
  result := true;

  with fFeaHole do begin

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

        if (StrToFloat(edRectRadius.Text) < 0.5) AND (comRectRadius.ItemIndex <> 2) then begin
          MessageBox(handle, PChar(TransTxt('Radius too small')), PChar(TransTxt('Error')), MB_ICONERROR);
          edRectRadius.Text := '0.5';
          edRectRadius.SetFocus;
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
        // v pripade zapichov sa vhodny nastroj vyberie inak
        if StrToFloat(edRectRadius.Text) = 0 then begin
          if CalculateRadius <= 0.75 then
            nastroj := '1'          // zapich v rohoch 1mm frezou (len u ozaj malych objektov)
          else
            nastroj := '1.5';       // zapich v rohoch u ostatnych - natvrdo 1.5mm frezou
        end;

        if GetToolMaxDepth(nastroj) < _PNL.Hrubka then begin
          MessageBox(handle, PChar(TransTxt('Depth too big for required tool (increase corner radius).')+#13+TransTxt('Maximum = ')+cfgToolMaxDepth.Values[nastroj]), PChar(TransTxt('Error')), MB_ICONERROR);
          comRectRadius.SetFocus;
          result := false;
        end;
      end;// kontrola obdlznikovej diery

      if (comEdgeStyleValue.Text = 'cham45') then
        if (StrToFLoat(edEdgeSize.Text) > _PNL.Hrubka) then begin
          MessageBox(handle, PChar(TransTxt('Chamfer too big.')), PChar(TransTxt('Error')), MB_ICONERROR);
          edEdgeSize.SetFocus;
          result := false;
        end;

      StrToFloat(edX.Text);
      StrToFloat(edY.Text);

    except
      MessageBox(handle, PChar(TransTxt('Incorrect numerical value')), PChar(TransTxt('Error')), MB_ICONERROR);
      result := false;
    end;

  end; // with
end;

procedure TfFeaHole.btnSaveClick(Sender: TObject);
var
  feaID: integer;
  newFea: TFeatureObject;
begin
  if not CheckMinMax then begin
    ModalResult := mrNone;
    Exit;
  end;

  _PNL.PrepareUndoStep;

  // ak niekto zada zrazenie hrany 0x45' tak automaticky sa zrazenie hrany vypne
  try
    if StrToFloat(edEdgeSize.Text)=0 then begin
      comEdgeStyle.ItemIndex := 0;
      comEdgeStyleValue.ItemIndex := 0;
      edEdgeSize.Text := '';
    end;
  except
  end;

  if PgCtrl.ActivePageIndex = 0 then begin
    if is_editing then feaID := edited_feature_ID
    else feaID := _PNL.AddFeature(ftHoleCirc);

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
    else feaID := _PNL.AddFeature(ftHoleRect);

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
    if newFea.Rozmer3 = 0 then begin // ak maju byt zapichy v rohoch, do Rozmer4 ulozi nastroj, ktory to bude robit (koli kresleniu)
      if CalculateRadius <= 0.75 then
        newFea.Rozmer4 := 1          // zapich v rohoch 1mm frezou (len u ozaj malych objektov)
      else
        newFea.Rozmer4 := 1.5;       // zapich v rohoch u ostatnych - natvrdo 1.5mm frezou
    end; // begin a end len koli 2 vnorenym if (aby nepomiesal ELSE)
  end;

  // ========== spolocne vlastnosti ===================
  newFea.Poloha := MyPoint( StrToFloat(edX.Text), StrToFloat(edY.Text) );
  newFea.Hlbka1   := 9999;
  // styl opracovania hrany
  newFea.Param2 := comEdgeStyleValue.Text;
  if (comEdgeStyle.ItemIndex > 0) AND (StrToFloat(edEdgeSize.Text) > 0) then
    newFea.Rozmer5 := StrToFloat(edEdgeSize.Text)
  else
    newFea.Rozmer5 := 0;


  ModalResult := mrOK;
  _PNL.Draw;
end;

procedure TfFeaHole.EditFeature(fea: integer);
var
  feature: TFeatureObject;
begin
  is_editing := true;
  edited_feature_ID := fea;
  feature := _PNL.GetFeatureByID(fea);

  edX.Text := FormatFloat('0.###', feature.X);
  edY.Text := FormatFloat('0.###', feature.Y);

  if feature.Param2 = '' then feature.Param2 := '0'; // ak nie je zadefinovana hrana, zadefinujeme ju na 'ziadnu'
  comEdgeStyleValue.ItemIndex := comEdgeStyleValue.Items.IndexOf(feature.Param2);
  comEdgeStyle.ItemIndex := comEdgeStyleValue.ItemIndex;
  if comEdgeStyle.ItemIndex > 0 then begin
    edEdgeSize.Enabled := true;
    edEdgeSize.Text := FloatToStr(feature.Rozmer5);
  end else begin
    edEdgeSize.Enabled := false;
  end;
  lbEdgeSize.Enabled := edEdgeSize.Enabled;

  case feature.Typ of
    ftHoleCirc: begin
      tabHoleCirc.TabVisible := true;
      tabHoleRect.TabVisible := false;
      edPriemer.Text := FormatFloat('0.###', feature.Rozmer1);
    end;
    ftHoleRect: begin
      tabHoleRect.TabVisible := true;
      tabHoleCirc.TabVisible := false;
      edSirka.Text := FormatFloat('0.###', feature.Rozmer1);
      edVyska.Text := FormatFloat('0.###', feature.Rozmer2);
      edRectRadius.Text := FormatFloat('0.###', feature.Rozmer3);
      // este nastavime combo (podla toho ci hodnota radiusu = vypocitanej hodnote podla frezy)
      if (feature.Rozmer3 = CalculateRadius) then
        comRectRadius.ItemIndex := 0
      else if (feature.Rozmer3 = 0) then
        comRectRadius.ItemIndex := 2
      else
        comRectRadius.ItemIndex := 1;
      edRectRadius.Enabled := (comRectRadius.ItemIndex = 1);
      lbRectRadius.Enabled := edRectRadius.Enabled;
    end;
  end; //case
end;


procedure TfFeaHole.MathExp(Sender: TObject);
begin
  uLib.SolveMathExpression(Sender);
end;

procedure TfFeaHole.DecimalPoint(Sender: TObject; var Key: Char);
begin
  fMain.CheckDecimalPoint(sender, key, btnSave);
end;

procedure TfFeaHole.btnSadHoleClick(Sender: TObject);
begin
  fMain.ShowWish('Hole');
end;

end.