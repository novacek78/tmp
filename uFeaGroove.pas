unit uFeaGroove;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, Vcl.Imaging.pngimage;

type
  TfFeaGroove = class(TForm)
    pgControl: TPageControl;
    Panel1: TPanel;
    btnSad: TSpeedButton;
    btnCancel: TBitBtn;
    btnSave: TBitBtn;
    tabLinear: TTabSheet;
    tabArc: TTabSheet;
    Label2: TLabel;
    edLinX1: TLabeledEdit;
    edLinY1: TLabeledEdit;
    edLinY2: TLabeledEdit;
    edLinX2: TLabeledEdit;
    edArcX1: TLabeledEdit;
    edArcY1: TLabeledEdit;
    Label5: TLabel;
    edArcDegStart: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    edArcDiam: TEdit;
    Label11: TLabel;
    cbArcConnected: TCheckBox;
    edArcDegEnd: TEdit;
    Label9: TLabel;
    Image1: TImage;
    Panel2: TPanel;
    Label12: TLabel;
    cbThruAll: TCheckBox;
    edDepth: TEdit;
    comGrooveWidth: TComboBox;
    Label4: TLabel;
    rbLinAbs: TRadioButton;
    rbLinInc: TRadioButton;
    edLinDY: TLabeledEdit;
    edLinDX: TLabeledEdit;
    function CheckMinMax: boolean;
    procedure EditFeature(fea: integer);

    procedure btnSadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure cbThruAllClick(Sender: TObject);
    procedure DecimalPoint(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure rbLinClick(Sender: TObject);
    procedure MathExp(Sender: TObject);
  private
    { Private declarations }
  public
    is_editing: boolean; // udava, ci je okno otvorene pre vytvorenie alebo editovanie prvku
    edited_feature_ID: integer; // cislo upravovanej feature
  end;

var
  fFeaGroove: TfFeaGroove;

implementation

uses uPoziadavka, uMain, uObjectFeature, uConfig, uMyTypes, uPanelSett,
  uTranslate, uLib;

{$R *.dfm}

procedure TfFeaGroove.FormCreate(Sender: TObject);
begin
  fMain.imgList_common.GetBitmap(0, btnSad.Glyph);
  btnCancel.Glyph := fPanelSett.btnCancel.Glyph;
  btnSave.Glyph := fPanelSett.btnSave.Glyph;
  pgControl.ActivePageIndex := 0;
end;

procedure TfFeaGroove.MathExp(Sender: TObject);
begin
  uLib.SolveMathExpression(Sender);
end;

procedure TfFeaGroove.rbLinClick(Sender: TObject);
var
  incremental: boolean;
begin
  incremental := rbLinInc.Checked;

  edLinDX.Enabled := incremental;
  edLinDY.Enabled := incremental;
  edLinX2.Enabled := not incremental;
  edLinY2.Enabled := not incremental;
end;

procedure TfFeaGroove.FormActivate(Sender: TObject);
begin
  if pgControl.ActivePageIndex = 0 then
    edLinX1.SetFocus;
  if pgControl.ActivePageIndex = 1 then
    edArcDiam.SetFocus;
end;

procedure TfFeaGroove.btnSadClick(Sender: TObject);
begin
  fMain.ShowWish('Groove');
end;

procedure TfFeaGroove.cbThruAllClick(Sender: TObject);
begin
  if cbThruAll.Checked then begin
    edDepth.Enabled := false;
    edDepth.Color := clBtnFace;
  end else begin
    edDepth.Enabled := true;
    edDepth.Color := clWhite;
    if fFeaGroove.Visible then
      edDepth.SetFocus;
  end;
end;

procedure TfFeaGroove.EditFeature(fea: integer);
var
  feature: TFeatureObject;
begin

  is_editing := true;
  edited_feature_ID := fea;
  feature := _PNL.GetFeatureByID(fea);

  case feature.Typ of
    ftGrooveLin: begin
      tabLinear.TabVisible := true;
      tabArc.TabVisible := false;
      comGrooveWidth.ItemIndex := comGrooveWidth.Items.IndexOf( FloatToStr(feature.Rozmer3)+' mm' );
      edLinX1.Text := FloatToStr( feature.X );
      edLinY1.Text := FloatToStr( feature.Y );
      edLinDX.Text := FloatToStr( feature.Rozmer1 );
      edLinDY.Text := FloatToStr( feature.Rozmer2 );
      edLinX2.Text := FloatToStr( feature.X + feature.Rozmer1 );
      edLinY2.Text := FloatToStr( feature.Y + feature.Rozmer2 );
      if (feature.Hlbka1 = 9999) then begin
        cbThruAll.Checked := true;
        edDepth.Text := '';
      end else begin
        cbThruAll.Checked := false;
        edDepth.Text := FloatToStr(feature.Hlbka1);
      end;
    end;

    ftGrooveArc: begin
      tabArc.TabVisible := true;
      tabLinear.TabVisible := false;
      comGrooveWidth.ItemIndex := comGrooveWidth.Items.IndexOf( FloatToStr(feature.Rozmer4)+' mm' );
      edArcDiam.Text := FloatToStr(feature.Rozmer1);
      edArcDegStart.Text := FloatToStr(feature.Rozmer2);
      edArcDegEnd.Text := FloatToStr(feature.Rozmer3);
      cbArcConnected.Checked := (feature.Param1 = 'S');
      edArcX1.Text := FloatToStr( feature.X );
      edArcY1.Text := FloatToStr( feature.Y );
      if (feature.Hlbka1 = 9999) then begin
        cbThruAll.Checked := true;
        edDepth.Text := '';
      end else begin
        cbThruAll.Checked := false;
        edDepth.Text := FloatToStr(feature.Hlbka1);
      end;
    end;
  end; //case
end;

function TfFeaGroove.CheckMinMax: boolean;
var
  dummyInt: integer;
  spacepos: byte;
  maxToolDepth: extended;
begin
  result := true;

  if pgControl.ActivePageIndex = 0 then begin
  try
    StrToFloat(edLinX1.Text);
    StrToFloat(edLinY1.Text);
    StrToFloat(edLinX2.Text);
    StrToFloat(edLinY2.Text);
    if not cbThruAll.Checked then begin
      if (StrToFloat(edDepth.Text) < 0) then begin
        MessageBox(handle, PChar(TransTxt('Please enter depth as positive value')), PChar(TransTxt('Error')), MB_ICONERROR);
        edDepth.SetFocus;
        result := false;
      end;
      if (StrToFloat(edDepth.Text) >= _PNL.Hrubka) then begin
        cbThruAll.Checked := true;
      end;
    end;
  except
    MessageBox(handle, PChar(TransTxt('Incorrect numerical value')), PChar(TransTxt('Error')), MB_ICONERROR);
    result := false;
  end;
  end; //if pgControl.ActivePageIndex = 0


  if pgControl.ActivePageIndex = 1 then begin
  try
    StrToFloat(edArcDiam.Text);
    if StrToFloat(edArcDegStart.Text) = 360 then edArcDegStart.Text := '0';
    if StrToFloat(edArcDegEnd.Text) = 360 then edArcDegEnd.Text := '0';
    StrToFloat(edLinX1.Text);
    StrToFloat(edLinY1.Text);

    if (StrToFloat(edArcDiam.Text) <= 0) then begin
      MessageBox(handle, PChar(TransTxt('Diameter too small')), PChar(TransTxt('Error')), MB_ICONERROR);
      edArcDiam.SetFocus;
      result := false;
    end;
    if (StrToFloat(edArcDegStart.Text) > 360) then begin
      MessageBox(handle, PChar(TransTxt('Maximal angle is 360°')), PChar(TransTxt('Error')), MB_ICONERROR);
      edArcDegStart.SetFocus;
      result := false;
    end;
    if (StrToFloat(edArcDegStart.Text) < -360) then begin
      MessageBox(handle, PChar(TransTxt('Minimal angle is -360°')), PChar(TransTxt('Error')), MB_ICONERROR);
      edArcDegStart.SetFocus;
      result := false;
    end;
    if (StrToFloat(edArcDegEnd.Text) > 360) then begin
      MessageBox(handle, PChar(TransTxt('Maximal angle is 360°')), PChar(TransTxt('Error')), MB_ICONERROR);
      edArcDegEnd.SetFocus;
      result := false;
    end;
    if (StrToFloat(edArcDegEnd.Text) < -360) then begin
      MessageBox(handle, PChar(TransTxt('Minimal angle is -360°')), PChar(TransTxt('Error')), MB_ICONERROR);
      edArcDegEnd.SetFocus;
      result := false;
    end;
    if (StrToFloat(edArcDegStart.Text) = StrToFloat(edArcDegEnd.Text)) then begin
      MessageBox(handle, PChar(TransTxt('Start/end degrees must not be identical')), PChar(TransTxt('Error')), MB_ICONERROR);
      edArcDegEnd.SetFocus;
      result := false;
    end;
    if not cbThruAll.Checked then begin
      if (StrToFloat(edDepth.Text) < 0) then begin
        MessageBox(handle, PChar(TransTxt('Please enter depth as positive value')), PChar(TransTxt('Error')), MB_ICONERROR);
        edDepth.SetFocus;
        result := false;
      end;
      if (StrToFloat(edDepth.Text) >= _PNL.Hrubka) then begin
        cbThruAll.Checked := true;
      end;
    end;
  except
    MessageBox(handle, PChar(TransTxt('Incorrect numerical value')), PChar(TransTxt('Error')), MB_ICONERROR);
    result := false;
  end;
  end; // if pgControl.ActivePageIndex = 1

  // kontrola max.hlbky drazky
  try
    spacePos := Pos(' ', comGrooveWidth.Text);
    maxToolDepth := GetToolMaxDepth( Copy(comGrooveWidth.Text, 0, spacePos-1) );
    if (not cbThruAll.Checked AND (StrToFloat(edDepth.Text) > maxToolDepth)) OR (cbThruAll.Checked AND (_PNL.Hrubka > maxToolDepth)) then begin
      MessageBox(handle, PChar(TransTxt('Depth is too big.')+#13+TransTxt('Maximum = ')+FloatToStr(maxToolDepth)), PChar(TransTxt('Error')), MB_ICONERROR);
      result := false;
    end;
  except
    MessageBox(handle, PChar(TransTxt('Incorrect numerical value')), PChar(TransTxt('Error')), MB_ICONERROR);
    result := false;
  end;


end;

procedure TfFeaGroove.btnSaveClick(Sender: TObject);
var
  feaID: integer;
  newFea: TFeatureObject;
  spacePos: integer;
begin
  if not CheckMinMax then begin
    ModalResult := mrNone;
    Exit;
  end;

  _PNL.PrepareUndoStep;

  if pgControl.ActivePageIndex = 0 then begin
    if is_editing then feaID := edited_feature_ID
    else feaID := _PNL.AddFeature(ftGrooveLin);

    if feaID = -1 then Exit;

    // este to dame do UNDO listu
    if is_editing then
      _PNL.CreateUndoStep('MOD', 'FEA', feaID)
    else
      _PNL.CreateUndoStep('CRT', 'FEA', feaID);

    newFea := _PNL.GetFeatureByID(feaID);
    newFea.X := StrToFloat(edLinX1.Text);
    newFea.Y := StrToFloat(edLinY1.Text);
    if rbLinInc.Checked then begin
      newFea.Rozmer1 := StrToFloat(edLinDX.Text);
      newFea.Rozmer2 := StrToFloat(edLinDY.Text);
    end else begin
      newFea.Rozmer1 := StrToFloat(edLinX2.Text) - newFea.X;
      newFea.Rozmer2 := StrToFloat(edLinY2.Text) - newFea.Y;
    end;
    spacePos := Pos(' ', comGrooveWidth.Text);
    newFea.Rozmer3 := StrToFloat( Copy(comGrooveWidth.Text, 0, spacePos-1) );
    if cbThruAll.Checked then
      newFea.Hlbka1  := 9999
    else
      newFea.Hlbka1  := StrToFloat(edDepth.Text);
  end; // if PgCtrl.ActivePageIndex = 0

  if pgControl.ActivePageIndex = 1 then begin
    if is_editing then feaID := edited_feature_ID
    else feaID := _PNL.AddFeature(ftGrooveArc);

    if feaID = -1 then Exit;

    // este to dame do UNDO listu
    if is_editing then
      _PNL.CreateUndoStep('MOD', 'FEA', feaID)
    else
      _PNL.CreateUndoStep('CRT', 'FEA', feaID);

    newFea := _PNL.GetFeatureByID(feaID);
    newFea.X := StrToFloat(edArcX1.Text);
    newFea.Y := StrToFloat(edArcY1.Text);
    newFea.Rozmer1 := StrToFloat(edArcDiam.Text);
    newFea.Rozmer2 := StrToFloat(edArcDegStart.Text);
    newFea.Rozmer3 := StrToFloat(edArcDegEnd.Text);
    spacePos := Pos(' ', comGrooveWidth.Text);
    newFea.Rozmer4:= StrToFloat( Copy(comGrooveWidth.Text, 0, spacePos-1) );
    if cbArcConnected.Checked then newFea.Param1 := 'S'
    else                           newFea.Param1 := 'NS';
    if cbThruAll.Checked then
      newFea.Hlbka1  := 9999
    else
      newFea.Hlbka1  := StrToFloat(edDepth.Text);
  end; // if PgCtrl.ActivePageIndex = 1

  ModalResult := mrOK;
  _PNL.Draw;
end;

procedure TfFeaGroove.DecimalPoint(Sender: TObject; var Key: Char);
begin
  fMain.CheckDecimalPoint(sender, key, btnSave);
end;

end.
