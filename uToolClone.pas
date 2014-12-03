unit uToolClone;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls;

type
  TfToolClone = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btnOK: TSpeedButton;
    btnSad: TSpeedButton;
    cbCloneInX: TCheckBox;
    cbCloneInY: TCheckBox;
    edOffsetX: TLabeledEdit;
    lbOffsetX: TLabel;
    lbOffsetY: TLabel;
    edOffsetY: TLabeledEdit;
    btnClone: TBitBtn;
    procedure CheckParamsOK;
    procedure btnSadClick(Sender: TObject);
    procedure cbCloneInXClick(Sender: TObject);
    procedure cbCloneInYClick(Sender: TObject);
    procedure DecimalPoint(Sender: TObject; var Key: Char);
    procedure EditKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCloneClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MathExp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fToolClone: TfToolClone;

implementation

uses uMain, uMyTypes, uObjectFeature, uConfig, uObjectPanel, uPanelSett,
  uDebug, uObjectFeaturePolyLine, uLib;

{$R *.dfm}

procedure TfToolClone.FormCreate(Sender: TObject);
begin
  fMain.imgList_common.GetBitmap(3, btnClone.Glyph);
  fMain.imgList_common.GetBitmap(0, btnSad.Glyph);
  btnOK.Glyph := fPanelSett.btnSave.Glyph;
end;

procedure TfToolClone.FormShow(Sender: TObject);
begin
  cbCloneInX.Checked := false;
  cbCloneInY.Checked := false;
  cbCloneInX.SetFocus;
end;

procedure TfToolClone.MathExp(Sender: TObject);
begin
  uLib.SolveMathExpression(Sender);
end;

procedure TfToolClone.btnSadClick(Sender: TObject);
begin
  fMain.ShowWish('Tools-Clone');
end;

procedure TfToolClone.cbCloneInXClick(Sender: TObject);
begin
  edOffsetX.Enabled := cbCloneInX.Checked;
  lbOffsetX.Enabled := edOffsetX.Enabled;
  if edOffsetX.Enabled then begin
    edOffsetX.SelectAll;
    edOffsetX.SetFocus;
  end else
    edOffsetX.Text := '';

  CheckParamsOK;
end;

procedure TfToolClone.cbCloneInYClick(Sender: TObject);
begin
  edOffsetY.Enabled := cbCloneInY.Checked;
  lbOffsetY.Enabled := edOffsetY.Enabled;
  if edOffsetY.Enabled then begin
    edOffsetY.SelectAll;
    edOffsetY.SetFocus;
  end else
    edOffsetY.Text := '';

  CheckParamsOK;
end;

procedure TfToolClone.CheckParamsOK;
var
  vsetko_OK: boolean;
begin
  // ak je vsetko nastavene korektne, enabluje button
  vsetko_OK := true;

  if  (not cbCloneInX.Checked) AND
      (not cbCloneInY.Checked) then
        vsetko_OK := false;

  btnClone.Enabled := vsetko_OK;
end;

procedure TfToolClone.DecimalPoint(Sender: TObject; var Key: Char);
begin
  if (Key = ',') then Key := '.';

  // ak stlaci ENTER, berie to ako potvrdenie okna
  if (Key=#13) AND (btnClone.Enabled) then begin
    uLib.SolveMathExpression(Sender); // pre istotu este pred potvrdenim - ak by tam bol daky matem.vyraz
    btnClone.Click;
  end;

  // ak stlaci ESC, zatvorime okno
  if (Key=#27) then btnOK.Click;
end;

procedure TfToolClone.EditKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CheckParamsOK;
end;

procedure TfToolClone.btnCloneClick(Sender: TObject);
var
  i, new_i, pocet_povodny, new_fea_id: integer;
  combos: array[0..maxFeaNum-1] of integer; // ku kazdemu cislu comba ulozene cislo noveho comba
begin
  for i:=0 to maxFeaNum-1 do
    combos[i] := -1;

  _PNL.PrepareUndoStep;

  pocet_povodny := _PNL.Features.Count;
  for i:=0 to pocet_povodny-1 do
    if (Assigned( _PNL.Features[i] )) then
      if _PNL.Features[i].Selected then begin
        // vytvorime novy feature
        new_fea_id := _PNL.AddFeature( _PNL.Features[i].Typ );
        new_i      := _PNL.GetFeatureIndex(new_fea_id);
        // nakopirujeme donho vsetky data zo zdrojoveho
        if _PNL.Features[i].Typ = ftPolyLineGrav then
        	TFeaturePolyLineObject(_PNL.Features[new_i]).CopyFrom( TFeaturePolyLineObject(_PNL.Features[i]) )
        else
        	_PNL.Features[new_i].CopyFrom( _PNL.Features[i] );
        // novy posunieme o offset
        if cbCloneInX.Checked then
          if _PNL.Features[new_i].Typ = ftPolyLineGrav then
            TFeaturePolyLineObject(_PNL.Features[new_i]).MovePolylineBy( StrToFloat(edOffsetX.Text), 0)
          else
            _PNL.Features[new_i].X := _PNL.Features[i].X + StrToFloat(edOffsetX.Text);
        if cbCloneInY.Checked then
          if _PNL.Features[new_i].Typ = ftPolyLineGrav then
            TFeaturePolyLineObject(_PNL.Features[new_i]).MovePolylineBy( 0, StrToFloat(edOffsetY.Text))
          else
          	_PNL.Features[new_i].Y := _PNL.Features[i].Y + StrToFloat(edOffsetY.Text);
        // zdrojovy deselectujeme
        _PNL.Features[i].Selected := false;
        // novy ulozime do undolistu
        _PNL.CreateUndoStep('CRT','FEA',new_fea_id); 

        // ak bol povodny sucastou comba, vytvorime nove a novy feature bude v novom
        if _PNL.Features[i].ComboID > -1 then begin
          // najprv sa pozrieme, ci sme uz nevytvorili nove combo (pre toto stare combo)
          // ak ano, pouzijeme cislo noveho comba
          if combos[ _PNL.Features[i].ComboID ] > -1 then begin
            _PNL.Features[new_i].ComboID := combos[ _PNL.Features[i].ComboID ]
          end else begin
            // ak sme len teraz vytvorili nove combo, ulozime si jeho cislo do pola
            // pre dalsie klonovane objekty z rovnakeho comba
            _PNL.Features[new_i].ComboID := _PNL.AddCombo;
            combos[ _PNL.Features[i].ComboID ] := _PNL.Features[new_i].ComboID;
            _PNL.CreateUndoStep('CRT','COM', _PNL.Features[new_i].ComboID);
          end;
        end;

      end;
      
  _PNL.Draw;
end;

procedure TfToolClone.btnOKClick(Sender: TObject);
begin
  Close;
end;

end.
