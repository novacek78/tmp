unit uFeaScale;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls, Math, Vcl.Imaging.pngimage;

type
  TfFeaScale = class(TForm)
    pgCtrl: TPageControl;
    tabArc: TTabSheet;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Image1: TImage;
    edCenterX: TLabeledEdit;
    edCenterY: TLabeledEdit;
    edStartAngle: TEdit;
    edEndAngle: TEdit;
    Panel1: TPanel;
    btnSad: TSpeedButton;
    btnCancel: TBitBtn;
    btnSave: TBitBtn;
    Label1: TLabel;
    edTickCount: TEdit;
    Label2: TLabel;
    edTickInner: TEdit;
    Label3: TLabel;
    edTickOuter: TEdit;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Label4: TLabel;
    edTextSize: TEdit;
    Label6: TLabel;
    edTextDiameter: TEdit;
    Label10: TLabel;
    edTexts: TEdit;
    Bevel3: TBevel;
    Label11: TLabel;
    comEngravingToolTick: TComboBox;
    Label13: TLabel;
    comEngravingToolTickValue: TComboBox;
    Label12: TLabel;
    comEngravingToolText: TComboBox;
    Label14: TLabel;
    comEngravingToolTextValue: TComboBox;
    cbRotateTexts: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure DecimalPoint(Sender: TObject; var Key: Char);
    procedure LinkLabelClick(Sender: TObject);
    procedure comEngravingToolTickChange(Sender: TObject);
    procedure comEngravingToolTextChange(Sender: TObject);
    procedure edTextsKeyPress(Sender: TObject; var Key: Char);
    procedure btnSadClick(Sender: TObject);
    procedure MathExp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fFeaScale: TfFeaScale;

implementation

uses uMain, uPanelSett, uTranslate, uMyTypes, uObjectFeature, uConfig,
  uFeaEngrave, uLib;

{$R *.dfm}

procedure TfFeaScale.comEngravingToolTextChange(Sender: TObject);
begin
  comEngravingToolTextValue.ItemIndex := comEngravingToolText.ItemIndex;
end;

procedure TfFeaScale.comEngravingToolTickChange(Sender: TObject);
begin
  comEngravingToolTickValue.ItemIndex := comEngravingToolTick.ItemIndex;
end;

procedure TfFeaScale.DecimalPoint(Sender: TObject; var Key: Char);
begin
  fMain.CheckDecimalPoint(sender, key, btnSave);
end;

procedure TfFeaScale.edTextsKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key=#13) then btnSave.Click;
end;

procedure TfFeaScale.FormCreate(Sender: TObject);
begin
  fMain.imgList_common.GetBitmap(0, btnSad.Glyph);
  btnCancel.Glyph     := fPanelSett.btnCancel.Glyph;
  btnSave.Glyph       := fPanelSett.btnSave.Glyph;
end;

procedure TfFeaScale.LinkLabelClick(Sender: TObject);
begin
  fMain.BrowseWiki('engraving-samples-examples');
end;

procedure TfFeaScale.MathExp(Sender: TObject);
begin
  uLib.SolveMathExpression(Sender);
end;

function CheckMinMax: boolean;
begin
  result := true;

  with fFeaScale do begin

  try

    if (PgCtrl.ActivePageIndex = 0) AND (StrToInt(edTickCount.Text) < 2) then begin
      MessageBox(handle, PChar(TransTxt('Tick count too small')), PChar(TransTxt('Error')), MB_ICONERROR);
      edTickCount.Text := '2';
      edTickCount.SetFocus;
      result := false;
    end;

    if (PgCtrl.ActivePageIndex = 0) AND (StrToFloat(edTickInner.Text) < 0) then begin
      MessageBox(handle, PChar(TransTxt('Size too small')), PChar(TransTxt('Error')), MB_ICONERROR);
      edTickInner.Text := '0';
      edTickInner.SetFocus;
      result := false;
    end;

    if (PgCtrl.ActivePageIndex = 0) AND (StrToFloat(edTickInner.Text) > StrToFloat(edTickOuter.Text)) then begin
      MessageBox(handle, PChar(TransTxt('Incorrect diameter value')), PChar(TransTxt('Error')), MB_ICONERROR);
      edTickInner.Text := edTickOuter.Text;
      edTickInner.SetFocus;
      result := false;
    end;

    if (PgCtrl.ActivePageIndex = 0) AND (StrToFloat(edTextSize.Text) < 1) then begin
      MessageBox(handle, PChar(TransTxt('Size too small')), PChar(TransTxt('Error')), MB_ICONERROR);
      edTextSize.Text := '1';
      edTextSize.SetFocus;
      result := false;
    end;

    if (PgCtrl.ActivePageIndex = 0) AND (StrToFloat(edTextDiameter.Text) < 0) then begin
      MessageBox(handle, PChar(TransTxt('Size too small')), PChar(TransTxt('Error')), MB_ICONERROR);
      edTextDiameter.Text := '0';
      edTextDiameter.SetFocus;
      result := false;
    end;

  except
    MessageBox(handle, PChar(TransTxt('Incorrect numerical value')), PChar(TransTxt('Error')), MB_ICONERROR);
    result := false;
  end;


  end; // with
end;

procedure TfFeaScale.btnSadClick(Sender: TObject);
begin
  fMain.ShowWish('Scale');
end;

procedure TfFeaScale.btnSaveClick(Sender: TObject);
var
  startAng, endAng, stepAng, currAng: extended;
  startRad, endRad, textRad: extended;
  i: integer;
  startPnt, endPnt: TMyPoint;
  newFea: TFeatureObject;
  texty: TStringList;
begin
  if not CheckMinMax then begin
    ModalResult := mrNone;
    Exit;
  end;

  _PNL.DeselectAll;
  _PNL.PrepareUndoStep;

  try
    endAng   := StrToFloat(edStartAngle.Text); // budeme postupovat naopak (CCW)
    startAng := StrToFloat(edEndAngle.Text);
    startRad := StrToFloat(edTickInner.Text)/2; // start radius = vnutorny radius ciarky
    endRad   := StrToFloat(edTickOuter.Text)/2;
    textRad  := StrToFloat(edTextDiameter.Text)/2;
    if startAng > endAng then startAng := startAng - 360;
    stepAng := (endAng - startAng) / (StrToInt(edTickCount.Text) - 1);

    // ak sa zoznam textov konci znakom ';' tak to rozmrda stupnicu - rucne ju zmazeme
    if (edTexts.Text[ Length(edTexts.Text) ] = ';') then
      edTexts.Text := Copy(edTexts.Text, 1, length(edTexts.Text)-1 );

    texty := TStringList.Create;
    texty.Delimiter := ';';
    texty.StrictDelimiter := true;
    texty.DelimitedText := edTexts.Text;
    if (texty.Count < StrToInt(edTickCount.Text)) then
      for i := 1 to (StrToInt(edTickCount.Text) - texty.Count) do
        texty.Add(''); // zoznam textov doplnime na taky pocet, kolko je ciarok

    for i := 0 to StrToInt(edTickCount.Text) - 1 do begin
      currAng := startAng+(i*stepAng);

      // ciarky stupnice
      startPnt.X := RoundTo((Cos( DegToRad(currAng) ) * startRad) + StrToFloat(edCenterX.Text) , -3);
      endPnt.X   := RoundTo((Cos( DegToRad(currAng) ) * endRad)   + StrToFloat(edCenterX.Text) , -3);
      startPnt.Y := RoundTo((Sin( DegToRad(currAng) ) * startRad) + StrToFloat(edCenterY.Text) , -3);
      endPnt.Y   := RoundTo((Sin( DegToRad(currAng) ) * endRad)   + StrToFloat(edCenterY.Text) , -3);

      newFea := _PNL.GetFeatureByID(_PNL.AddFeature(ftLine2Grav));
      newFea.Poloha  := startPnt;
      newFea.Rozmer1 := RoundTo(endPnt.X - startPnt.X , -3);
      newFea.Rozmer2 := RoundTo(endPnt.Y - startPnt.Y , -3);
      newFea.Rozmer3 := StrToFloat(comEngravingToolTickValue.Text);
      newFea.Param4  := 'NOFILL';
      newFea.Selected := true;

      // texty
      if (texty.Strings[ texty.Count - 1 - i ] <> '') then begin
        startPnt.X := RoundTo((Cos( DegToRad(currAng) ) * textRad) + StrToFloat(edCenterX.Text) , -3);
        startPnt.Y := RoundTo((Sin( DegToRad(currAng) ) * textRad) + StrToFloat(edCenterY.Text) , -3);

        newFea := _PNL.GetFeatureByID(_PNL.AddFeature(ftTxtGrav));
        newFea.Param5  := fFeaEngraving.comTextFontValue.Text;
        newFea.Poloha  := startPnt;
        newFea.Param1  := texty.Strings[ texty.Count - 1 - i ];
        newFea.Param2  := 'HEIGHT';
        newFea.Param3  := '0';
        newFea.Param4  := 'NOFILL';
        newFea.Rozmer1 := StrToFloat(edTextSize.Text);
        newFea.Rozmer3 := StrToFloat(comEngravingToolTextValue.Text);

        // ak treba texty aj natacat
        if (cbRotateTexts.Checked) then begin
          newFea.Rozmer2 := currAng - 90;
          if (newFea.Rozmer2 < 0) then newFea.Rozmer2 := newFea.Rozmer2 + 360;
        end;

        newFea.Inicializuj;
        newFea.Selected := true;
      end;
    end;
  finally
    texty.Free;
  end;
  _PNL.MakeCombo;
  _PNL.Draw;
end;

end.
