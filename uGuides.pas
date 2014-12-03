unit uGuides;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TfGuides = class(TForm)
    Panel2: TPanel;
    btnSad: TSpeedButton;
    btnSave: TBitBtn;
    Panel1: TPanel;
    lbGuides: TListBox;
    Label1: TLabel;
    btnAdd: TBitBtn;
    btnDel: TBitBtn;
    Label2: TLabel;
    comTyp: TComboBox;
    Label3: TLabel;
    edParam1: TEdit;
    lbGuidesID: TListBox;
    cbShowGuides: TCheckBox;
    Label4: TLabel;
    edX: TLabeledEdit;
    edY: TLabeledEdit;
    cbSnapToGuides: TCheckBox;
    pnlGrid: TPanel;
    lbLabel1: TLabel;
    cbSnapToGrid: TCheckBox;
    edGridSize: TEdit;
    lbGridSize: TLabel;
    lbShowGrid: TLabel;
    comShowGrid: TComboBox;
    procedure edParam1KeyPress(Sender: TObject; var Key: Char);
    procedure btnAddClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure lbGuidesClick(Sender: TObject);
    procedure btnSadClick(Sender: TObject);
    procedure cbShowGuidesClick(Sender: TObject);
    procedure comTypChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure edXYKeyPress(Sender: TObject; var Key: Char);
    procedure MathExp(Sender: TObject);
    procedure cbSnapToGuidesClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DecimalPoint(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fGuides: TfGuides;

implementation

uses uObjectPanel, uMain, uOtherObjects, uDebug, uConfig, uPanelSett,
  uTranslate, uLib;

{$R *.dfm}

procedure TfGuides.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  _PNL.DeselectAllGuidelines;
  _PNL.Draw;
end;

procedure TfGuides.FormCreate(Sender: TObject);
begin
  fMain.imgList_common.GetBitmap(0, btnSad.Glyph);
  fMain.imgList_common.GetBitmap(3, btnAdd.Glyph);
  fMain.imgList_common.GetBitmap(4, btnDel.Glyph);
  btnSave.Glyph := fPanelSett.btnSave.Glyph;

  comShowGrid.ItemIndex  := fMain.ReadRegistry_integer('User', 'ShowGridAs', 0);
  cbSnapToGrid.Checked   := fMain.ReadRegistry_bool('User', 'SnapToGrid', true);
  cbSnapToGuides.Checked := fMain.ReadRegistry_bool('User', 'SnapToGuidelines', true);
end;

procedure TfGuides.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #27 then
    btnSave.Click;
end;

procedure TfGuides.FormActivate(Sender: TObject);
var
  i: integer;
  guide: TGuideObject;
begin
	if edParam1.Visible then edParam1.SetFocus
  else if edX.Visible then edX.SetFocus;
       
  // naplnime listbox vsetkymi guidemi, co panel ma
  lbGuides.Clear;
  lbGuidesID.Clear;
  for i:=0 to _PNL.Guides.Count-1 do begin
    guide := _PNL.Guides[i];
    if guide.Typ = 'V' then lbGuides.Items.Add(TransTxt('Vertical')+', '+FloatToStr(guide.Param1)+TransTxt('mm'));
    if guide.Typ = 'H' then lbGuides.Items.Add(TransTxt('Horizontal')+', '+FloatToStr(guide.Param1)+TransTxt('mm'));
    lbGuidesID.Items.Add( IntToStr(guide.ID) );
  end;
  btnDel.Enabled := lbGuides.Count > 0;
  cbShowGuides.Checked := cfg_ShowGuides;

  edGridSize.Text := FloatToStr(_PNL.Grid);
end;

procedure TfGuides.DecimalPoint(Sender: TObject; var Key: Char);
begin
  fMain.CheckDecimalPoint(sender, key, btnSave);
end;

procedure TfGuides.edParam1KeyPress(Sender: TObject; var Key: Char);
var
  tmpKey: Char;
begin
  tmpKey := Key; // musime takto, lebo vo fMain.CheckDecimalPoint() Key zresetujeme na #0

  fMain.CheckDecimalPoint(sender, key, btnAdd);

  if tmpKey=#13 then begin
    edParam1.SelectAll;
  end;
end;

procedure TfGuides.edXYKeyPress(Sender: TObject; var Key: Char);
var
  tmpKey: Char;
begin
  tmpKey := Key; // musime takto, lebo vo fMain.CheckDecimalPoint() Key zresetujeme na #0

  fMain.CheckDecimalPoint(Sender, key, btnAdd);

  try
  	StrToFloat(edX.Text);
  	StrToFloat(edY.Text);
    if tmpKey=#13 then begin
      edX.SelectAll;
      edX.SetFocus;
    end;
  except

  end;
end;

procedure TfGuides.lbGuidesClick(Sender: TObject);
begin
  lbGuidesID.ItemIndex := lbGuides.ItemIndex;
  btnDel.Enabled := (lbGuides.Items.Count > 0) AND (lbGuides.ItemIndex > -1);
  _PNL.DeselectAllGuidelines;
  _PNL.GetGuideLineById( StrToInt(lbGuidesID.Items[lbGuidesID.ItemIndex]) ).Selected := true;
  _PNL.Draw;
end;

procedure TfGuides.MathExp(Sender: TObject);
begin
  uLib.SolveMathExpression(Sender);
end;

procedure TfGuides.btnAddClick(Sender: TObject);
var
  new_id: integer;
begin
  _PNL.PrepareUndoStep;

  try

    if comTyp.ItemIndex = 0 then begin    // 0 = VERTICAL
      new_id := _PNL.AddGuideLine('V', StrToFLoat(edParam1.Text), 0, 0, _PNL.StranaVisible).ID;
      lbGuides.Items.Add(TransTxt('Vertical')+', '+edParam1.text+TransTxt('mm'));
      lbGuidesID.Items.Add( IntToStr(new_id) );
      edParam1.SetFocus;
      _PNL.CreateUndoStep('CRT','GUI',new_id);
    end;

    if comTyp.ItemIndex = 1 then begin    // 1 = HORIZONTAL
      new_id := _PNL.AddGuideLine('H', StrToFloat(edParam1.text), 0, 0, _PNL.StranaVisible).ID;
      lbGuides.Items.Add(TransTxt('Horizontal')+', '+edParam1.text+TransTxt('mm'));
      lbGuidesID.Items.Add( IntToStr(new_id) );
      edParam1.SetFocus;
      _PNL.CreateUndoStep('CRT','GUI',new_id);
    end;

    if comTyp.ItemIndex = 2 then begin    // 2 = VERTICAL + HORIZONTAL
      new_id := _PNL.AddGuideLine('V', StrToFloat(edX.text), 0, 0, _PNL.StranaVisible).ID;
      lbGuides.Items.Add(TransTxt('Vertical')+', '+edX.text+TransTxt('mm'));
      lbGuidesID.Items.Add( IntToStr(new_id) );
      _PNL.CreateUndoStep('CRT','GUI',new_id);

      new_id := _PNL.AddGuideLine('H', StrToFloat(edY.text), 0, 0, _PNL.StranaVisible).ID;
      lbGuides.Items.Add(TransTxt('Horizontal')+', '+edY.text+TransTxt('mm'));
      lbGuidesID.Items.Add( IntToStr(new_id) );
      _PNL.CreateUndoStep('CRT','GUI',new_id);

      edX.SetFocus;
    end;

    btnDel.Enabled := (lbGuides.Items.Count > 0) AND (lbGuides.ItemIndex > -1);
    _PNL.Draw;

  except
    MessageBox(handle, PChar(TransTxt('Incorrect numerical value')), PChar(TransTxt('Error')), MB_ICONERROR);
  end;
end;

procedure TfGuides.btnDelClick(Sender: TObject);
var
  old_itmIndx: integer;
  gid: integer;
begin
  if lbGuides.ItemIndex = -1 then Exit;

  old_itmIndx := lbGuides.ItemIndex;
  gid := StrToInt(lbGuidesID.Items[ lbGuides.ItemIndex ]);

  _PNL.PrepareUndoStep;
  _PNL.CreateUndoStep('DEL','GUI',gid);

  _PNL.DelGuideLineById( gid );
  lbGuides.DeleteSelected;
  lbGuidesID.DeleteSelected;

  lbGuides.ItemIndex := old_itmIndx;
  lbGuidesID.ItemIndex := old_itmIndx;
  
  btnDel.Enabled := (lbGuides.Items.Count > 0) AND (lbGuides.ItemIndex > -1);

  _PNL.Draw;
end;

procedure TfGuides.btnSadClick(Sender: TObject);
begin
  fMain.ShowWish('Guidelines');
end;

procedure TfGuides.btnSaveClick(Sender: TObject);
begin
  try
  if StrToFloat(edGridSize.Text) = 0 then begin
    MessageBox(handle, PChar(TransTxt('Snap-grid size not set, or too small')), PChar(TransTxt('Error')), MB_ICONERROR);
    edGridSize.SetFocus;
  end;

  if StrToFloat(edGridSize.Text) < 0.01 then edGridSize.Text := '0.01';

  _PNL.Grid := StrToFloat(edGridSize.Text);

  _PNL.DeselectAllGuidelines;
  _PNL.Draw;

  fMain.WriteRegistry_integer('User', 'ShowGridAs', comShowGrid.ItemIndex);
  fMain.WriteRegistry_bool('User', 'SnapToGrid', cbSnapToGrid.Checked);
  fMain.WriteRegistry_bool('User', 'SnapToGuidelines', cbSnapToGuides.Checked);

  except
    edGridSize.SetFocus;
    MessageBox(handle, PChar(TransTxt('Incorrect numerical value')), PChar(TransTxt('Error')), MB_ICONERROR);
  end;
end;

procedure TfGuides.cbShowGuidesClick(Sender: TObject);
begin
  cfg_ShowGuides := cbShowGuides.Checked;
  _PNL.Draw;
end;

procedure TfGuides.cbSnapToGuidesClick(Sender: TObject);
begin
  cfg_SnapToGuides := cbSnapToGuides.Checked;
end;

procedure TfGuides.comTypChange(Sender: TObject);
begin
  if comTyp.ItemIndex = 2 then begin
  	Label3.Visible := false;
    edParam1.Visible := false;

    Label4.Top := Label3.Top; // premiestnime teraz lebo pocas design-time by to bolo neprehladne
    edX.Top := edParam1.Top;
    edY.Top := edParam1.Top;

    Label4.Visible := true;
    edx.Visible := true;
    edy.Visible := true;
    edx.SetFocus;
  end else begin
  	Label3.Visible := true;
    edParam1.Visible := true;
    Label4.Visible := false;
    edx.Visible := false;
    edy.Visible := false;
  	edParam1.SetFocus;
  end;
end;

end.
