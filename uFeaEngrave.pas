unit uFeaEngrave;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Math, uObjectFeature,
  Buttons, ShellApi, Vcl.Imaging.pngimage;

type
  TfFeaEngraving = class(TForm)
    Panel1: TPanel;
    PgCtrl: TPageControl;
    tabText: TTabSheet;
    edTextX: TLabeledEdit;
    Label2: TLabel;
    edTextY: TLabeledEdit;
    comTextAlign: TComboBox;
    Label3: TLabel;
    comTextAlignValue: TComboBox;
    comTextSizeType: TComboBox;
    Label5: TLabel;
    comTextSizeTypeValue: TComboBox;
    Label1: TLabel;
    lbTest: TLabel;
    shRedPoint: TShape;
    edTextText: TEdit;
    Label4: TLabel;
    edTextSize: TEdit;
    tabShapes: TTabSheet;
    comEngraveShapeType: TComboBox;
    comEngraveShapeTypeValue: TComboBox;
    Label6: TLabel;
    pnlLine: TPanel;
    edLine2_x1: TLabeledEdit;
    edLine2_y1: TLabeledEdit;
    Label7: TLabel;
    edLine2_dx: TLabeledEdit;
    edLine2_dy: TLabeledEdit;
    pnlRect: TPanel;
    Label9: TLabel;
    edRect_x: TLabeledEdit;
    edRect_y: TLabeledEdit;
    edRectWidth: TLabeledEdit;
    edRectHeight: TLabeledEdit;
    pnlCircle: TPanel;
    Label11: TLabel;
    edCirc_x: TLabeledEdit;
    edCirc_y: TLabeledEdit;
    edCircDiam: TLabeledEdit;
    tabTTF: TTabSheet;
    dlgFont: TFontDialog;
    btnOpenFont: TButton;
    img: TImage;
    SpeedButton1: TSpeedButton;
    Panel2: TPanel;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    btnSadEngrave: TSpeedButton;
    lbFillColor: TLabel;
    comFillColor: TComboBox;
    comFillColorValue: TComboBox;
    Label10: TLabel;
    comEngravingTool: TComboBox;
    comEngravingToolValue: TComboBox;
    Label13: TLabel;
    tabImport: TTabSheet;
    edImportFile: TEdit;
    Label12: TLabel;
    btnOpenFile: TButton;
    ImportDialog: TOpenDialog;
    edLine2_x2: TLabeledEdit;
    edLine2_y2: TLabeledEdit;
    rbLine2_inc: TRadioButton;
    rbLine2_abs: TRadioButton;
    edRectRadius: TLabeledEdit;
    Image1: TImage;
    rbVector4: TRadioButton;
    rbVector3: TRadioButton;
    rbVector1: TRadioButton;
    rbVector2: TRadioButton;
    rbVector5: TRadioButton;
    edVectorX: TLabeledEdit;
    edVectorY: TLabeledEdit;
    Label8: TLabel;
    edVectorSize: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    comTextFont: TComboBox;
    comTextFontValue: TComboBox;
    lbRotation: TLabel;
    edRotation: TEdit;
    lbDegrees: TLabel;
    procedure btnSaveClick(Sender: TObject);
    procedure EditFeature(fea: integer);
    procedure DecimalPoint(Sender: TObject; var Key: Char);
    procedure comTextAlignChange(Sender: TObject);
    procedure comTextSizeTypeChange(Sender: TObject);
    procedure edTextTextKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure comEngraveShapeTypeChange(Sender: TObject);
    procedure btnSadEngraveClick(Sender: TObject);
    procedure btnOpenFontClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure comEngravingToolChange(Sender: TObject);
    procedure LinkLabelClick(Sender: TObject);
    procedure comFillColorChange(Sender: TObject);
    procedure btnOpenFileClick(Sender: TObject);
    procedure rbLine2Click(Sender: TObject);
    procedure Label16Click(Sender: TObject);
    procedure MathExp(Sender: TObject);
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

uses uMain, uMyTypes, uPanelSett, uConfig, uFeaPocket, uFeaThread,
  uObjectPanel, uTranslate, uObjectDXFDrawing, uDebug, uObjectDXFEntity,
  uObjectFeaturePolyLine, uObjectHPGLDrawing, uObjectCombo, uLib;

{$R *.dfm}

procedure TfFeaEngraving.FormCreate(Sender: TObject);
begin
  fMain.imgList_common.GetBitmap(0, btnSadEngrave.Glyph);
  btnCancel.Glyph     := fPanelSett.btnCancel.Glyph;
  btnSave.Glyph       := fPanelSett.btnSave.Glyph;
  PgCtrl.ActivePageIndex := 0;
  pnlLine.BringToFront;
  comTextSizeType.ItemIndex := 0;
  comTextAlign.ItemIndex := 1;
  comEngraveShapeType.ItemIndex := 0;

{$IFDEF DEBUG}
  tabTTF.TabVisible := false;
{$ELSE}
  tabTTF.TabVisible := false;
{$ENDIF}

end;

procedure TfFeaEngraving.Label16Click(Sender: TObject);
begin
  fMain.BrowseWiki('engraving-user-graphics-logo-hpgl-plt-file');
end;

procedure TfFeaEngraving.LinkLabelClick(Sender: TObject);
begin
  fMain.BrowseWiki('engraving-samples-examples');
end;

procedure TfFeaEngraving.MathExp(Sender: TObject);
begin
  uLib.SolveMathExpression(Sender);
end;

procedure TfFeaEngraving.rbLine2Click(Sender: TObject);
var
  Incremental: Boolean;
begin
  Incremental := rbLine2_inc.Checked;

  edLine2_dx.Enabled := Incremental;
  edLine2_dy.Enabled := Incremental;
  edLine2_x2.Enabled := not Incremental;
  edLine2_y2.Enabled := not Incremental;

(*
    // nemozem toto pouzit, lebo Delphi ma bug a ostava focus (oramikovanie) na radiobuttonoch
    if (Sender as TRadioButton).Name = 'rbLine2_inc' then edLine2_dx.SetFocus
    else edLine2_x2.SetFocus;
*)
end;

procedure TfFeaEngraving.FormActivate(Sender: TObject);
begin
  if PgCtrl.ActivePageIndex = 0 then begin
    edTextText.SelectAll;
    edTextText.SetFocus;
  end;

  if PgCtrl.ActivePageIndex = 1 then begin
    if comEngraveShapeType.ItemIndex = 0 then edLine2_x1.SetFocus;
    if comEngraveShapeType.ItemIndex = 1 then edRect_x.SetFocus;
    if comEngraveShapeType.ItemIndex = 2 then edCirc_x.SetFocus;
  end;

  if PgCtrl.ActivePageIndex = 2 then begin
    edImportFile.SetFocus;
  end;

  comEngraveShapeType.Enabled := not is_editing;
end;

function CheckMinMax: boolean;
var
  dummyInt: integer;
  dummyFloat: Double;
begin
  result := true;

  with fFeaEngraving do begin

  try
    // text engraving
    if (PgCtrl.ActivePageIndex = 0) then begin
      if (edTextText.Text = '') then begin
        MessageBox(handle, PChar(TransTxt('Please enter text to engrave')), PChar(TransTxt('Error')), MB_ICONERROR);
        edTextText.SetFocus;
        result := false;
      end;

      if (StrToFloat(edTextSize.Text) < 1) then begin
        MessageBox(handle, PChar(TransTxt('Size too small')), PChar(TransTxt('Error')), MB_ICONERROR);
        edTextSize.Text := '1';
        edTextSize.SetFocus;
        result := false;
      end;

      if (StrToFloat(edTextSize.Text) < 2) AND (StrToFloat(comEngravingToolValue.Text) > 0.2) then begin
        MessageBox(handle, PChar(TransTxt('Tool diameter is too big, risk of difficult-to-read text')), PChar(TransTxt('Warning')), MB_ICONWARNING);
      end;

      dummyFloat := StrToFloat(edRotation.Text);
      while (dummyFloat < 0) do dummyFloat := dummyFloat + 360;
      while (dummyFloat > 360) do dummyFloat := dummyFloat - 360;
      edRotation.Text := FloatToStr(dummyFloat);
      
    end;

    // shape engraving
    if (PgCtrl.ActivePageIndex = 1) then begin
      if (comEngraveShapeTypeValue.Text = 'LINE2') then begin
        if (rbLine2_inc.Checked) AND ((StrToFloat(edLine2_dx.Text)=0) AND (StrToFloat(edLine2_dy.Text)=0)) then begin
          MessageBox(handle, PChar(TransTxt('Zero length object')), PChar(TransTxt('Error')), MB_ICONERROR);
          edLine2_dx.SetFocus;
          result := false;
        end;

        if (rbLine2_abs.Checked) AND
          ((StrToFloat(edLine2_x2.Text)-StrToFloat(edLine2_x1.Text)=0) AND (StrToFloat(edLine2_y2.Text)-StrToFloat(edLine2_y1.Text)=0)) then begin
          MessageBox(handle, PChar(TransTxt('Zero length object')), PChar(TransTxt('Error')), MB_ICONERROR);
          edLine2_x2.SetFocus;
          result := false;
        end;
      end; // 'LINE2'

      if (comEngraveShapeTypeValue.Text = 'RECT') then begin
        if (StrToFloat(edRectRadius.Text) > StrToFloat(edRectWidth.Text)/2) OR (StrToFloat(edRectRadius.Text) > StrToFloat(edRectHeight.Text)/2) then begin
          MessageBox(handle, PChar(TransTxt('Radius too big')), PChar(TransTxt('Error')), MB_ICONERROR);
          edRectRadius.Text := FormatFloat('##0.###', Min( StrToFloat(edRectWidth.Text)/2  , StrToFloat(edRectHeight.Text)/2 ) );
          edRectRadius.SetFocus;
          result := false;
        end;
      end; // 'RECT'
    end;

    // imported vectors engraving
    if (PgCtrl.ActivePageIndex = 2) then begin
      if (edImportFile.Text = '') then begin
        edImportFile.SetFocus;
        result := false;
      end;
    end;

  except
    MessageBox(handle, PChar(TransTxt('Incorrect numerical value')), PChar(TransTxt('Error')), MB_ICONERROR);
    result := false;
  end;


  end; // with
end;

procedure TfFeaEngraving.btnSaveClick(Sender: TObject);
var
  i, vrtx, feaID, cmbID: integer;
  newFea: TFeatureObject;
  newCombo: TComboObject;
  minX, minY, dX, dY: double;
  b: TMyPoint;
  hpgl: THPGLDrawing;
  hpglPosunutie: TMyPoint;
  hpglPoly: TFeaturePolyLineObject;
  hpglVelkostMm: TMyPoint;
begin
  if not CheckMinMax then begin
    ModalResult := mrNone;
    Exit;
  end;

  _PNL.PrepareUndoStep;

  if PgCtrl.ActivePageIndex = 0 then begin

  	if _PNL.Fonty.IndexOf(comTextFontValue.Text) = -1 then begin
    	MessageBox(0, PChar(TransTxt('Font file not found:')+' '+comTextFontValue.Text), PChar(TransTxt('Error')), MB_ICONERROR);
    	Exit;
    end;

    if is_editing then feaID := edited_feature_ID
    else feaID := _PNL.AddFeature(ftTxtGrav);

    if feaID = -1 then Exit;

    // este to dame do UNDO listu
    if is_editing then
      _PNL.CreateUndoStep('MOD', 'FEA', feaID)
    else
      _PNL.CreateUndoStep('CRT', 'FEA', feaID);

    newFea := _PNL.GetFeatureByID(feaID);
    newFea.Param5  := comTextFontValue.Text;
    newFea.Poloha  := MyPoint( StrToFloat(edTextX.Text), StrToFloat(edTextY.Text) );
    newFea.Param1  := edTextText.Text;
    newFea.Param2  := comTextSizeTypeValue.Text;
    newFea.Param3  := comTextAlignValue.Text;
    newFea.Param4  := comFillColorValue.Text;
    newFea.Rozmer1 := StrToFloat(edTextSize.Text);
    newFea.Rozmer2 := StrToFloat(edRotation.Text);
    newFea.Rozmer3 := StrToFloat(comEngravingToolValue.Text);
    newFea.Inicializuj;
  end;

  if PgCtrl.ActivePageIndex = 1 then begin
    if comEngraveShapeTypeValue.Text = 'LINE2' then begin
      if is_editing then feaID := edited_feature_ID
      else feaID := _PNL.AddFeature(ftLine2Grav);

      if feaID = -1 then Exit;

      // este to dame do UNDO listu
      if is_editing then
        _PNL.CreateUndoStep('MOD', 'FEA', feaID)
      else
        _PNL.CreateUndoStep('CRT', 'FEA', feaID);

      newFea := _PNL.GetFeatureByID(feaID);
      // ulozene to bude ako 1.bod (v Polohe)...
      newFea.Poloha  := MyPoint( StrToFloat(edLine2_x1.Text), StrToFloat(edLine2_y1.Text) );
      // ...a prirastok k druhemu bodu (v Rozmer1 a 2)
      if rbLine2_inc.Checked then begin
        newFea.Rozmer1 := StrToFloat(edLine2_dx.Text);
        newFea.Rozmer2 := StrToFloat(edLine2_dy.Text);
      end else begin
        newFea.Rozmer1 := StrToFloat(edLine2_x2.Text)-StrToFloat(edLine2_x1.Text);
        newFea.Rozmer2 := StrToFloat(edLine2_y2.Text)-StrToFloat(edLine2_y1.Text);
      end;
      newFea.Rozmer3 := StrToFloat(comEngravingToolValue.Text);
      newFea.Param4  := comFillColorValue.Text;
    end else
    if comEngraveShapeTypeValue.Text = 'CIRCLE' then begin
      if is_editing then feaID := edited_feature_ID
      else feaID := _PNL.AddFeature(ftCircleGrav);

      if feaID = -1 then Exit;

      // este to dame do UNDO listu
      if is_editing then
        _PNL.CreateUndoStep('MOD', 'FEA', feaID)
      else
        _PNL.CreateUndoStep('CRT', 'FEA', feaID);

      newFea := _PNL.GetFeatureByID(feaID);
      newFea.Poloha  := MyPoint( StrToFloat(edCirc_x.Text), StrToFloat(edCirc_y.Text) );
      newFea.Rozmer1 := StrToFloat(edCircDiam.Text);
      newFea.Rozmer3 := StrToFloat(comEngravingToolValue.Text);
      newFea.Param4  := comFillColorValue.Text;
    end;
    if comEngraveShapeTypeValue.Text = 'RECT' then begin
      if is_editing then feaID := edited_feature_ID
      else feaID := _PNL.AddFeature(ftRectGrav);

      if feaID = -1 then Exit;

      // este to dame do UNDO listu
      if is_editing then
        _PNL.CreateUndoStep('MOD', 'FEA', feaID)
      else
        _PNL.CreateUndoStep('CRT', 'FEA', feaID);

      newFea := _PNL.GetFeatureByID(feaID);
      newFea.Poloha  := MyPoint( StrToFloat(edRect_x.Text), StrToFloat(edRect_y.Text) );
      newFea.Rozmer1 := StrToFloat(edRectWidth.Text);
      newFea.Rozmer2 := StrToFloat(edRectHeight.Text);
      newFea.Rozmer3 := StrToFloat(comEngravingToolValue.Text);
      newFea.Rozmer4 := StrToFloat(edRectRadius.Text);
      newFea.Param4  := comFillColorValue.Text;
    end else
  end;

  if PgCtrl.ActivePageIndex = 2 then begin

    hpgl := THPGLDrawing.Create(ImportDialog.FileName, _PNL, StrToFloat(edVectorSize.Text)/100 );
    cmbID := _PNL.AddCombo;

    hpglVelkostMm.X := (hpgl.MaxX - hpgl.MinX) / 40;
    hpglVelkostMm.Y := (hpgl.MaxY - hpgl.MinY) / 40;

    // defaultne sa posunutie spocita tak, ze pozicia sa definuje podla rohu c.1
    hpglPosunutie.X := -(hpgl.MinX/40 - StrToFloat(edVectorX.Text));
    hpglPosunutie.Y := -(hpgl.MinY/40 - StrToFloat(edVectorY.Text));
    // do "b" si ulozime polohu stredu comba
    b.X := StrToFloat(edVectorX.Text) + (hpglVelkostMm.X/2);
    b.Y := StrToFloat(edVectorY.Text) + (hpglVelkostMm.Y/2);

    if rbVector2.Checked then begin
      hpglPosunutie.X := hpglPosunutie.X - hpglVelkostMm.X;
      b.X := b.X - hpglVelkostMm.X;
    end;
    if rbVector3.Checked then begin
      hpglPosunutie.X := hpglPosunutie.X - hpglVelkostMm.X;
      hpglPosunutie.Y := hpglPosunutie.Y - hpglVelkostMm.Y;
      b.X := b.X - hpglVelkostMm.X;
      b.Y := b.Y - hpglVelkostMm.Y;
    end;
    if rbVector4.Checked then begin
      hpglPosunutie.Y := hpglPosunutie.Y - hpglVelkostMm.Y;
      b.Y := b.Y - hpglVelkostMm.Y;
    end;
    if rbVector5.Checked then begin
      hpglPosunutie.X := hpglPosunutie.X - hpglVelkostMm.X/2;
      hpglPosunutie.Y := hpglPosunutie.Y - hpglVelkostMm.Y/2;
      b.X := b.X - (hpglVelkostMm.X/2);
      b.Y := b.Y - (hpglVelkostMm.Y/2);
    end;

    for I := 0 to hpgl.CountPolylines-1 do begin
      feaID := _PNL.AddFeature(ftPolyLineGrav);
      _PNL.CreateUndoStep('CRT', 'FEA', feaID);
      newFea := _PNL.GetFeatureByID(feaID);
      (newFea as TFeaturePolyLineObject).CopyFrom(hpgl.GetNextPolyline);
      newFea.Strana := _PNL.CurrentSide;
      newFea.Typ := ftPolyLineGrav;
      newFea.Rozmer3 := StrToFloat(comEngravingToolValue.Text);
      newFea.Param4 := comFillColorValue.Text;
      (newFea as TFeaturePolyLineObject).MovePolylineBy(hpglPosunutie.X, hpglPosunutie.Y);
      newFea.ComboID := cmbID;
    end;

    _PNL.GetComboByID(cmbID).Poloha := b;
    hpgl.Free;

    { ---- ak nahravame DXF subor ----:
    dxf := TDXFDrawing.Create;
    dxf.LoadFromFile(edImportFile.Text);
    try
      minX := 999999;
      minY := 999999;
      // najprv prejdeme vsetky entity a zistime najmensie X a Y - tie potom nastavime do nuly
      for i := 0 to dxf.EntityCount - 1 do begin
        ent := dxf.Entities[i];
        if ent.GetValueS(0) = 'LINE' then begin
          if ent.GetValueF(10) < minX then minX := ent.GetValueF(10);
          if ent.GetValueF(11) < minX then minX := ent.GetValueF(11);
          if ent.GetValueF(20) < minY then minY := ent.GetValueF(20);
          if ent.GetValueF(21) < minY then minY := ent.GetValueF(21);
        end; // if
        if ent.GetValueS(0) = 'POLYLINE' then
          for vrtx := 0 to ent.SubEntitiesCount - 1 do begin
            b.X := ent.SubEntities[vrtx].GetValueF(10);
            b.Y := ent.SubEntities[vrtx].GetValueF(20);
            if b.X < minX then minX := b.X;
            if b.Y < minY then minY := b.Y;
          end; // if
      end; // for
      dX := -minX;
      dY := -minY;
      cmbID := _PNL.AddCombo;
      // teraz ich prejdeme este raz a uz vytvarame featury na paneli
      for i := 0 to dxf.EntityCount - 1 do begin
        ent := dxf.Entities[i];
        if ent.GetValueS(0) = 'LINE' then begin
          feaID := _PNL.AddFeature(ftLine2Grav);
          newFea := _PNL.GetFeatureByID(feaID);
          newFea.Poloha := MyPoint( ent.GetValueF(10) + dX , ent.GetValueF(20) + dY);
          newFea.Rozmer1 := ent.GetValueF(11) - ent.GetValueF(10);
          newFea.Rozmer2 := ent.GetValueF(21) - ent.GetValueF(20);
          newFea.Rozmer3 := StrToFloat(comEngravingToolValue.Text);
          newFea.Param4  := comFillColorValue.Text;
          newFea.ComboID := cmbID;
        end; // if
        if ent.GetValueS(0) = 'POLYLINE' then begin
          feaID := _PNL.AddFeature(ftPolyLineGrav);
          newFea := _PNL.GetFeatureByID(feaID);
          for vrtx := 0 to ent.SubEntitiesCount - 1 do begin
            b.X := ent.SubEntities[vrtx].GetValueF(10);
            b.Y := ent.SubEntities[vrtx].GetValueF(20);
            (newFea as TFeaturePolyLineObject).AddVertex(b.X+dX , b.Y+dY);
            newFea.Rozmer3 := StrToFloat(comEngravingToolValue.Text);
            newFea.Param4  := comFillColorValue.Text;
            newFea.ComboID := cmbID;
          end; // for
        end; // if
        if ent.GetValueS(0) = 'CIRCLE' then begin
          feaID := _PNL.AddFeature(ftCircleGrav);
          newFea := _PNL.GetFeatureByID(feaID);
          newFea.Poloha := MyPoint( ent.GetValueF(10) + dX , ent.GetValueF(20) + dY);
          newFea.Rozmer1 := ent.GetValueF(40)*2;
          newFea.Param4  := comFillColorValue.Text;
          newFea.ComboID := cmbID;
        end; // if
      end; // for

      fMain.log( dxf.GetAllEntities );
    finally
      dxf.Free;
    end;
    ---- ak nahravame DXF subor ---- }

  end;

  ModalResult := mrOK;
  _PNL.Draw;

end;

procedure TfFeaEngraving.EditFeature(fea: integer);
var
  feature: TFeatureObject;
begin
  is_editing := true;
  edited_feature_ID := fea;
  feature := _PNL.GetFeatureByID(fea);

  case feature.Typ of
    ftTxtGrav: begin
      tabText.TabVisible := true;
      tabShapes.TabVisible := false;
      tabImport.TabVisible := false;
      edTextText.Text := feature.Param1;
      edTextSize.Text := FloatToStr(feature.Rozmer1);
      edRotation.Text := FloatToStr(feature.Rozmer2);
      edTextX.Text := FloatToStr(feature.X);
      edTextY.Text := FloatToStr(feature.Y);
      // najdeme ktory v comboxe je dany grav.nastroj a nastavime ho v oboch
      comEngravingToolValue.ItemIndex := comEngravingToolValue.Items.IndexOf(FloatToStr(feature.Rozmer3));
      comEngravingTool.ItemIndex := comEngravingToolValue.ItemIndex;
      // najdeme ktory v comboxe je typ velkosti textu a nastavime ju v oboch
      comTextSizeTypeValue.ItemIndex := comTextSizeTypeValue.Items.IndexOf(feature.Param2);
      comTextSizeType.ItemIndex := comTextSizeTypeValue.ItemIndex;
      // najdeme ktore v comboxe je zarovnanie textu a vyberieme ho v oboch
      comTextAlignValue.ItemIndex := comTextAlignValue.Items.IndexOf(feature.Param3);
      comTextAlign.ItemIndex := comTextAlignValue.ItemIndex;
      comTextAlignChange(comTextAlign); // nastavime spravne aj cervenu bodku
      // najdeme ktora v comboxe je farba a nastavime ju v oboch
      comFillColorValue.ItemIndex := comFillColorValue.Items.IndexOf(feature.Param4);
      comFillColor.ItemIndex := comFillColorValue.ItemIndex;
    end;

    ftLine2Grav: begin
      tabText.TabVisible := false;
      tabShapes.TabVisible := true;
      tabImport.TabVisible := false;
      pnlLine.BringToFront;
      // najdeme ktory v comboxe je dany grav.nastroj a nastavime ho v oboch
      comEngravingToolValue.ItemIndex := comEngravingToolValue.Items.IndexOf(FloatToStr(feature.Rozmer3));
      comEngravingTool.ItemIndex := comEngravingToolValue.ItemIndex;
      comEngraveShapeTypeValue.ItemIndex := comEngraveShapeTypeValue.Items.IndexOf('LINE2');
      comEngraveShapeType.ItemIndex := comEngraveShapeTypeValue.ItemIndex;
      edLine2_x1.Text := FloatToStr(feature.X);
      edLine2_y1.Text := FloatToStr(feature.Y);
      edLine2_dx.Text := FloatToStr(feature.Rozmer1);
      edLine2_dy.Text := FloatToStr(feature.Rozmer2);
      edLine2_x2.Text := FloatToStr(feature.X + feature.Rozmer1);
      edLine2_y2.Text := FloatToStr(feature.Y + feature.Rozmer2);
      // najdeme ktora v comboxe je farba a nastavime ju v oboch
      comFillColorValue.ItemIndex := comFillColorValue.Items.IndexOf(feature.Param4);
      comFillColor.ItemIndex := comFillColorValue.ItemIndex;
    end;

    ftCircleGrav: begin
      tabText.TabVisible := false;
      tabShapes.TabVisible := true;
      pnlCircle.BringToFront;
      // najdeme ktory v comboxe je dany grav.nastroj a nastavime ho v oboch
      comEngravingToolValue.ItemIndex := comEngravingToolValue.Items.IndexOf(FloatToStr(feature.Rozmer3));
      comEngravingTool.ItemIndex := comEngravingToolValue.ItemIndex;
      comEngraveShapeTypeValue.ItemIndex := comEngraveShapeTypeValue.Items.IndexOf('CIRCLE');
      comEngraveShapeType.ItemIndex := comEngraveShapeTypeValue.ItemIndex;
      edCirc_x.Text := FloatToStr(feature.X);
      edCirc_y.Text := FloatToStr(feature.Y);
      edCircDiam.Text := FloatToStr(feature.Rozmer1);
      // najdeme ktora v comboxe je farba a nastavime ju v oboch
      comFillColorValue.ItemIndex := comFillColorValue.Items.IndexOf(feature.Param4);
      comFillColor.ItemIndex := comFillColorValue.ItemIndex;
    end;

    ftRectGrav: begin
      tabText.TabVisible := false;
      tabShapes.TabVisible := true;
      pnlRect.BringToFront;
      // najdeme ktory v comboxe je dany grav.nastroj a nastavime ho v oboch
      comEngravingToolValue.ItemIndex := comEngravingToolValue.Items.IndexOf(FloatToStr(feature.Rozmer3));
      comEngravingTool.ItemIndex := comEngravingToolValue.ItemIndex;
      comEngraveShapeTypeValue.ItemIndex := comEngraveShapeTypeValue.Items.IndexOf('RECT');
      comEngraveShapeType.ItemIndex := comEngraveShapeTypeValue.ItemIndex;
      edRect_x.Text := FloatToStr(feature.X);
      edRect_y.Text := FloatToStr(feature.Y);
      edRectWidth.Text := FloatToStr(feature.Rozmer1);
      edRectHeight.Text := FloatToStr(feature.Rozmer2);
      edRectRadius.Text := FloatToStr(feature.Rozmer4);
      // najdeme ktora v comboxe je farba a nastavime ju v oboch
      comFillColorValue.ItemIndex := comFillColorValue.Items.IndexOf(feature.Param4);
      comFillColor.ItemIndex := comFillColorValue.ItemIndex;
    end;
  end; // case
end;


procedure TfFeaEngraving.edTextTextKeyPress(Sender: TObject; var Key: Char);
begin
  // ak stlaci ENTER, berie to ako potvrdenie okna
  if Key=#13 then btnSave.Click;
end;

procedure TfFeaEngraving.DecimalPoint(Sender: TObject; var Key: Char);
begin
  fMain.CheckDecimalPoint(sender, key, btnSave);
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

procedure TfFeaEngraving.comEngravingToolChange(Sender: TObject);
begin
  comEngravingToolValue.ItemIndex := comEngravingTool.ItemIndex;
end;

procedure TfFeaEngraving.comFillColorChange(Sender: TObject);
begin
  comFillColorValue.ItemIndex := comFillColor.ItemIndex;
end;

procedure TfFeaEngraving.comTextSizeTypeChange(Sender: TObject);
begin
  comTextSizeTypeValue.ItemIndex := comTextSizeType.ItemIndex;
end;

procedure TfFeaEngraving.comEngraveShapeTypeChange(Sender: TObject);
begin
  comEngraveShapeTypeValue.ItemIndex := comEngraveShapeType.ItemIndex;

  pnlLine.Visible := false;
  pnlRect.Visible := false;
  pnlCircle.Visible := false;

  if comEngraveShapeTypeValue.Text = 'LINE2'  then pnlLine.Visible := true;
  if comEngraveShapeTypeValue.Text = 'RECT'   then pnlRect.Visible := true;
  if comEngraveShapeTypeValue.Text = 'CIRCLE' then pnlCircle.Visible := true;
end;

procedure TfFeaEngraving.btnSadEngraveClick(Sender: TObject);
begin
  fMain.ShowWish('Engraving');
end;

procedure TfFeaEngraving.btnOpenFileClick(Sender: TObject);
begin
  if ImportDialog.InitialDir = '' then
    ImportDialog.InitialDir := fMain.ReadRegistry_string('Config', 'App_ImportDir');

  if ImportDialog.Execute then begin
    edImportFile.Text := ImportDialog.FileName;
    fMain.WriteRegistry_string('Config', 'App_ImportDir', ExtractFileDir(ImportDialog.FileName));
    edVectorX.SetFocus;
  end;
end;

procedure TfFeaEngraving.btnOpenFontClick(Sender: TObject);
begin
  if dlgFont.Execute then
    btnOpenFont.Caption := dlgFont.Font.Name;
end;

procedure TfFeaEngraving.SpeedButton1Click(Sender: TObject);
var
  fontHandle: LOGFONT;
begin
  FillChar(fontHandle, SizeOf(fontHandle), Byte(0)) ;
  fontHandle.lfHeight := dlgFont.Font.Height;
  fontHandle.lfEscapement := 10 * 45;
  fontHandle.lfOrientation := 10 * 45;
  fontHandle.lfCharSet := DEFAULT_CHARSET;
  fontHandle.lfFaceName := 'Times New Roman';
  img.Canvas.Font.Handle := CreateFontIndirect( fontHandle );
  img.Canvas.TextOut(10, 100, 'Rotated text') ;
end;

end.





