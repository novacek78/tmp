unit uFeaThread;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Math, uObjectFeature,
  Buttons;

type
  TfFeaThread = class(TForm)
    Panel1: TPanel;
    PgCtrl: TPageControl;
    tabThread: TTabSheet;
    btnCancel: TBitBtn;
    btnSave: TBitBtn;
    comThreadSize: TComboBox;
    Label3: TLabel;
    comThreadSizeValue: TComboBox;
    comThreadType: TComboBox;
    Label5: TLabel;
    comThreadTypeValue: TComboBox;
    btnSad: TSpeedButton;
    Panel2: TPanel;
    Label4: TLabel;
    cbThruAll: TCheckBox;
    edThreadZ: TEdit;
    Label2: TLabel;
    edThreadX: TLabeledEdit;
    edThreadY: TLabeledEdit;
    comThreadMaxDepth: TComboBox;
    procedure btnSaveClick(Sender: TObject);
    procedure EditFeature(fea: integer);
    procedure DecimalPoint(Sender: TObject; var Key: Char);
    procedure comThreadSizeChange(Sender: TObject);
    procedure cbThruAllClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSadClick(Sender: TObject);
    procedure MathExp(Sender: TObject);
  private
    { Private declarations }
  public
    is_editing: boolean; // udava, ci je okno otvorene pre vytvorenie alebo editovanie prvku
    edited_feature_ID: integer; // cislo upravovanej feature

    { Public declarations }
  end;

var
  fFeaThread: TfFeaThread;

implementation

uses uMain, uMyTypes, uPanelSett, uConfig, uFeaPocket, uTranslate, uLib;

{$R *.dfm}

procedure TfFeaThread.FormCreate(Sender: TObject);
begin
  fMain.imgList_common.GetBitmap(0, btnSad.Glyph);
  btnCancel.Glyph := fPanelSett.btnCancel.Glyph;
  btnSave.Glyph := fPanelSett.btnSave.Glyph;
  PgCtrl.ActivePageIndex := 0;
end;

procedure TfFeaThread.MathExp(Sender: TObject);
begin
  uLib.SolveMathExpression(Sender);
end;

procedure TfFeaThread.FormActivate(Sender: TObject);
begin
  comThreadType.SetFocus;
end;

function CheckMinMax: boolean;
var
  threaddepth: extended;
begin
  result := true;

  with fFeaThread do begin

  try

  if not cbThruAll.Checked then begin
    if (edThreadZ.Text = '') then edThreadZ.Text := '0';

    if (StrToFloat(edThreadZ.Text) = 0) then begin
      MessageBox(handle, PChar(TransTxt('Depth too small')), PChar(TransTxt('Error')), MB_ICONERROR);
      edThreadZ.SetFocus;
      result := false;
    end;
    if (StrToFloat(edThreadZ.Text) < 0) then begin
      MessageBox(handle, PChar(TransTxt('Please enter depth as positive value')), PChar(TransTxt('Error')), MB_ICONERROR);
      edThreadZ.SetFocus;
      result := false;
    end;
    if (StrToFloat(edThreadZ.Text) >= _PNL.Hrubka) then begin
      cbThruAll.Checked := true;
      exit;
    end;
    if (_PNL.Hrubka - StrToFloat(edThreadZ.Text) < 1 ) then begin
      MessageBox(handle, PChar(TransTxt('Consider smaller depth, possible damage.')), PChar(TransTxt('Warning')), MB_ICONWARNING);
    end;
  end; // if not cbThruAll.Checked

  if cbThruAll.Checked then threaddepth := _PNL.Hrubka
  else threaddepth := StrToFloat(edThreadZ.Text);
  if (threaddepth > StrToFloat(comThreadMaxDepth.Text)) then begin
    MessageBox(handle, PChar(TransTxt('Depth is too big.')+#13+TransTxt('Maximum = ')+comThreadMaxDepth.Text), PChar(TransTxt('Error')), MB_ICONERROR);
    comThreadSize.SetFocus;
    result := false;
  end;

  StrToFloat(edThreadX.Text);
  StrToFloat(edThreadY.Text);

  except
    MessageBox(handle, PChar(TransTxt('Incorrect numerical value')), PChar(TransTxt('Error')), MB_ICONERROR);
    result := false;
  end;

  end; // with
end;

procedure TfFeaThread.btnSaveClick(Sender: TObject);
var
  feaID: integer;
  newFea: TFeatureObject;
begin
  if not CheckMinMax then begin
    ModalResult := mrNone;
    Exit;
  end;

  _PNL.PrepareUndoStep;

  if is_editing then feaID := edited_feature_ID
  else feaID := _PNL.AddFeature(ftThread);

  if feaID = -1 then Exit;

  // este to dame do UNDO listu
  if is_editing then
    _PNL.CreateUndoStep('MOD', 'FEA', feaID)
  else
    _PNL.CreateUndoStep('CRT', 'FEA', feaID);

  newFea := _PNL.GetFeatureByID(feaID);
  newFea.Poloha  := MyPoint( StrToFloat(edThreadX.Text), StrToFloat(edThreadY.Text) );
  newFea.Param1  := comThreadTypeValue.Text;
  newFea.Rozmer1 := StrToFloat(comThreadSizeValue.Text);
  if cbThruAll.Checked then
    newFea.Hlbka1  := 9999
  else
    newFea.Hlbka1  := StrToFloat(edThreadZ.Text);

  ModalResult := mrOK;
  _PNL.Draw;
end;

procedure TfFeaThread.EditFeature(fea: integer);
var
  feature: TFeatureObject;
begin
  is_editing := true;
  edited_feature_ID := fea;
  feature := _PNL.GetFeatureByID(fea);

  edThreadX.Text := FormatFloat('0.###', feature.X);
  edThreadY.Text := FormatFloat('0.###', feature.Y);
  if (feature.Hlbka1 = 9999) then begin
    cbThruAll.Checked := true;
    edThreadZ.Text := '';
  end else begin
    cbThruAll.Checked := false;
    edThreadZ.Text := FormatFloat('0.###', feature.Hlbka1);
  end;
  // najdeme ktory v combe je typ zavitu a nasledne ho vyberieme v obidvoch
  comThreadTypeValue.ItemIndex := comThreadTypeValue.Items.IndexOf(feature.Param1);
  comThreadType.ItemIndex := comThreadTypeValue.ItemIndex;
  // najdeme ktora v combe je velkost zavitu a nasledne ju vyberieme v obidvoch
  comThreadSizeValue.ItemIndex := comThreadSizeValue.Items.IndexOf(FormatFloat('0.#', feature.Rozmer1));
  comThreadSize.ItemIndex := comThreadSizeValue.ItemIndex;
end;


procedure TfFeaThread.DecimalPoint(Sender: TObject; var Key: Char);
begin
  fMain.CheckDecimalPoint(sender, key, btnSave);
end;

procedure TfFeaThread.comThreadSizeChange(Sender: TObject);
begin
  comThreadSizeValue.ItemIndex := comThreadSize.ItemIndex;
  comThreadMaxDepth.ItemIndex  := comThreadSize.ItemIndex;
end;

procedure TfFeaThread.cbThruAllClick(Sender: TObject);
begin
  if cbThruAll.Checked then begin
    edThreadZ.Enabled := false;
    edThreadZ.Color := clBtnFace;
  end else begin
    edThreadZ.Enabled := true;
    edThreadZ.Color := clWhite;
    if fFeaThread.Visible then
      edThreadZ.SetFocus;
  end;
end;

procedure TfFeaThread.btnSadClick(Sender: TObject);
begin
  fMain.ShowWish('Thread');
end;

end.

