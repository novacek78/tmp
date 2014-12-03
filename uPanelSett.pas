unit uPanelSett;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, Vcl.Imaging.pngimage, Math;

type
  TfPanelSett = class(TForm)
    Panel5: TPanel;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    btnSadOther: TSpeedButton;
    Panel1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label3: TLabel;
    btnSadThickness: TSpeedButton;
    lbCustomThick: TLabel;
    comHrubkaValue: TComboBox;
    comHrubka: TComboBox;
    edRadius: TLabeledEdit;
    cbCustomMaterial: TCheckBox;
    edCustomThick: TEdit;
    Panel3: TPanel;
    Panel2: TPanel;
    lbPovrch: TLabel;
    btnSadSurface: TSpeedButton;
    comPovrch: TComboBox;
    comPovrchValue: TComboBox;
    Panel4: TPanel;
    Label7: TLabel;
    lbEdgeSize: TLabel;
    comEdgeStyle: TComboBox;
    edEdgeSize: TEdit;
    comEdgeStyleValue: TComboBox;
    cbEdgeLeft: TCheckBox;
    cbEdgeRight: TCheckBox;
    cbEdgeTop: TCheckBox;
    cbEdgeBottom: TCheckBox;
    lbEdgeRight: TLabel;
    lbEdgeLeft: TLabel;
    lbEdgeTop: TLabel;
    lbEdgeBottom: TLabel;
    edSirka: TEdit;
    edVyska: TEdit;
    rbBottomLeftB: TRadioButton;
    rbBottomRightB: TRadioButton;
    rbCenterB: TRadioButton;
    rbTopLeftB: TRadioButton;
    rbTopRightB: TRadioButton;
    shp1: TShape;
    lb2: TLabel;
    lb3: TLabel;
    pnlSideA: TPanel;
    lb1: TLabel;
    Label4: TLabel;
    rbTopLeft: TRadioButton;
    rbTopRight: TRadioButton;
    rbBottomRight: TRadioButton;
    rbBottomLeft: TRadioButton;
    rbCenter: TRadioButton;
    Shape1: TShape;
    function  CheckMinMax: boolean;
    procedure NastavPoliaPodlaPanela;
    procedure DecimalPoint(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure comHrubkaChange(Sender: TObject);
    procedure comPovrchChange(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSadOtherClick(Sender: TObject);
    procedure btnSadThicknessClick(Sender: TObject);
    procedure btnSadSurfaceClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbCustomMaterialClick(Sender: TObject);
    procedure comEdgeStyleChange(Sender: TObject);
    procedure lbEdgeTopClick(Sender: TObject);
    procedure lbEdgeBottomClick(Sender: TObject);
    procedure lbEdgeRightClick(Sender: TObject);
    procedure lbEdgeLeftClick(Sender: TObject);
    function  AsponJednaHrana: boolean;
    procedure EdgeToggle(Sender: TObject);
    procedure edRadiusExit(Sender: TObject);
    procedure MathExp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fPanelSett: TfPanelSett;

implementation

uses uMain, uMyTypes, uDebug, uGuides, uOtherObjects, uTranslate, uConfig, uObjectFeaturePolyLine, uLib;

{$R *.dfm}

procedure TfPanelSett.NastavPoliaPodlaPanela;
var
  dummyByte: byte;
begin
  edSirka.Text  := FloatToStr(_PNL.Sirka);
  edVyska.Text  := FloatToStr(_PNL.Vyska);
  edRadius.Text := FloatToStr(_PNL.Radius);
  cbCustomMaterial.Checked := _PNL.MaterialVlastny;
  cbCustomMaterial.OnClick(cbCustomMaterial); // nech prepne viditelnost prvkov okolo hrubky
  if cbCustomMaterial.Checked then begin
    edCustomThick.Text := FloatToStr(_PNL.Hrubka);
  end else begin
    comHrubka.ItemIndex := comHrubkaValue.Items.IndexOf( FloatToStr(_PNL.Hrubka) );
    comHrubkaChange(comHrubka);
  end;
  comPovrch.ItemIndex := comPovrchValue.Items.IndexOf(_PNL.Povrch); comPovrchChange(comPovrch);

  dummyByte := _PNL.GetCenterPosByNum(1);
  if dummyByte = cpLT then rbTopLeft.Checked := true;
  if dummyByte = cpLB then rbBottomLeft.Checked := true;
  if dummyByte = cpRT then rbTopRight.Checked := true;
  if dummyByte = cpRB then rbBottomRight.Checked := true;
  if dummyByte = cpCEN then rbCenter.Checked := true;

  dummyByte := _PNL.GetCenterPosByNum(2);
  if dummyByte = cpLT then rbTopLeftB.Checked := true;
  if dummyByte = cpLB then rbBottomLeftB.Checked := true;
  if dummyByte = cpRT then rbTopRightB.Checked := true;
  if dummyByte = cpRB then rbBottomRightB.Checked := true;
  if dummyByte = cpCEN then rbCenterB.Checked := true;

  comEdgeStyle.ItemIndex := comEdgeStyleValue.Items.IndexOf(_PNL.HranaStyl); comEdgeStyleChange(comEdgeStyle);
  if comEdgeStyle.ItemIndex > 0 then begin
    edEdgeSize.Text := FloatToStr(_PNL.HranaRozmer);
    cbEdgeBottom.Checked := _PNL.HranaObrobenaBottom;
    cbEdgeRight.Checked := _PNL.HranaObrobenaRight;
    cbEdgeTop.Checked := _PNL.HranaObrobenaTop;
    cbEdgeLeft.Checked := _PNL.HranaObrobenaLeft;
  end;
end;

function TfPanelSett.CheckMinMax: boolean;
begin
  result := true;

  try

    if (edSirka.Text = '') OR (StrToFLoat(edSirka.Text) < 30) then begin
      MessageBox(handle, PChar(TransTxt('Width not set, or too small')), PChar(TransTxt('Error')), MB_ICONERROR);
      edSirka.Text := '30';
      edSirka.SetFocus;
      result := false;
    end;

    if (edVyska.Text = '') OR (StrToFLoat(edVyska.Text) < 30) then begin
      MessageBox(handle, PChar(TransTxt('Height not set, or too small')), PChar(TransTxt('Error')), MB_ICONERROR);
      edVyska.Text := '30';
      edVyska.SetFocus;
      result := false;
    end;

    if (StrToFLoat(edSirka.Text) > 1000) then begin
      MessageBox(handle, PChar(TransTxt('Width too big, maximum:')+' 1000mm'), PChar(TransTxt('Error')), MB_ICONERROR);
      edSirka.Text := '1000';
      edSirka.SetFocus;
      result := false;
    end;

    if (StrToFLoat(edVyska.Text) > 750) then begin
      MessageBox(handle, PChar(TransTxt('Height too big, maximum:')+' 750mm'), PChar(TransTxt('Error')), MB_ICONERROR);
      edVyska.Text := '750';
      edVyska.SetFocus;
      result := false;
    end;

    if (cbCustomMaterial.Checked) then
      if (edCustomThick.Text = '') OR (StrToFLoat(edCustomThick.Text) < 1) OR (StrToFLoat(edCustomThick.Text) > 20) then begin
        MessageBox(handle, PChar(TransTxt('Incorrect thickness of the panel')), PChar(TransTxt('Error')), MB_ICONERROR);
        edCustomThick.SetFocus;
        result := false;
      end;

    if (comEdgeStyleValue.Text = 'cham45') then
      if ((cbCustomMaterial.Checked = false) AND (StrToFLoat(edEdgeSize.Text) > StrToFloat(comHrubkaValue.Text))) OR
      (cbCustomMaterial.Checked AND (StrToFLoat(edEdgeSize.Text) > StrToFloat(edCustomThick.Text))) then begin
        MessageBox(handle, PChar(TransTxt('Chamfer too big.')), PChar(TransTxt('Error')), MB_ICONERROR);
        edEdgeSize.SetFocus;
        result := false;
      end;

  except
    MessageBox(handle, PChar(TransTxt('Incorrect numerical value')), PChar(TransTxt('Error')), MB_ICONERROR);
    result := false;
  end;

end;




procedure TfPanelSett.FormCreate(Sender: TObject);
begin
  fMain.imgList_common.GetBitmap(0, btnSadOther.Glyph);
  fMain.imgList_common.GetBitmap(0, btnSadSurface.Glyph);
  fMain.imgList_common.GetBitmap(0, btnSadThickness.Glyph);
  fMain.imgList_common.GetBitmap(1, btnSave.Glyph );
  fMain.imgList_common.GetBitmap(2, btnCancel.Glyph );
end;

procedure TfPanelSett.FormShow(Sender: TObject);
begin
  // nastavi vsetky polia na hodnoty ako ma nastavene panel
  NastavPoliaPodlaPanela;
  edSirka.SetFocus;
end;

procedure TfPanelSett.lbEdgeBottomClick(Sender: TObject);
begin
  cbEdgeBottom.Checked := not cbEdgeBottom.Checked;
  EdgeToggle(cbEdgeBottom);
end;

procedure TfPanelSett.lbEdgeLeftClick(Sender: TObject);
begin
  cbEdgeLeft.Checked := not cbEdgeLeft.Checked;
  EdgeToggle(cbEdgeLeft);
end;

procedure TfPanelSett.lbEdgeRightClick(Sender: TObject);
begin
  cbEdgeRight.Checked := not cbEdgeRight.Checked;
  EdgeToggle(cbEdgeRight);
end;

procedure TfPanelSett.lbEdgeTopClick(Sender: TObject);
begin
  cbEdgeTop.Checked := not cbEdgeTop.Checked;
  EdgeToggle(cbEdgeTop);
end;

procedure TfPanelSett.MathExp(Sender: TObject);
begin
  uLib.SolveMathExpression(Sender);
end;

procedure TfPanelSett.FormActivate(Sender: TObject);
begin
  NastavPoliaPodlaPanela;
  edSirka.SelectAll;
  edSirka.SetFocus;
end;

procedure TfPanelSett.FormClose(Sender: TObject; var Action: TCloseAction);
var
  new_center_pos1: byte;
  new_center_pos2: byte;
begin

  if rbTopLeft.Checked     then new_center_pos1 := cpLT;
  if rbBottomLeft.Checked  then new_center_pos1 := cpLB;
  if rbTopRight.Checked    then new_center_pos1 := cpRT;
  if rbBottomRight.Checked then new_center_pos1 := cpRB;
  if rbCenter.Checked      then new_center_pos1 := cpCEN;

  if rbTopLeftB.Checked     then new_center_pos2 := cpLT;
  if rbBottomLeftB.Checked  then new_center_pos2 := cpLB;
  if rbTopRightB.Checked    then new_center_pos2 := cpRT;
  if rbBottomRightB.Checked then new_center_pos2 := cpRB;
  if rbCenterB.Checked      then new_center_pos2 := cpCEN;

  _PNL.CurrentSide := _PNL.StranaVisible;

  if ModalResult = mrOK then begin
    // ak sa cokolvek zmenilo, vytvorime aj undo krok
    if (_PNL.Sirka  <> StrToFloat(edSirka.Text))
    OR (_PNL.Vyska  <> StrToFloat(edVyska.Text))
    OR (_PNL.Radius <> StrToFloat(edRadius.Text))
    OR (_PNL.Povrch <> comPovrchValue.Text)
    OR (_PNL.GetCenterPosByNum(1) <> new_center_pos1)
    OR (_PNL.GetCenterPosByNum(2) <> new_center_pos2)
    OR (_PNL.MaterialVlastny <> cbCustomMaterial.Checked)
    OR ((_PNL.MaterialVlastny) AND (_PNL.Hrubka <> StrToFloat(edCustomThick.Text)))
    OR ((not _PNL.MaterialVlastny) AND (_PNL.Hrubka <> StrToFloat(comHrubkaValue.Text)))
    then begin
      _PNL.PrepareUndoStep;
      _PNL.CreateUndoStep('MOD','PNL',0);
    end;

    _PNL.Sirka  := StrToFloat(edSirka.Text);
    _PNL.Vyska  := StrToFloat(edVyska.Text);
    _PNL.Radius := StrToFloat(edRadius.Text);
    _PNL.MaterialVlastny := cbCustomMaterial.Checked;

    if _PNL.MaterialVlastny then
      _PNL.Hrubka := StrToFloat(edCustomThick.Text)
    else
      _PNL.Hrubka := StrToFloat(comHrubkaValue.Text);

    _PNL.Povrch := comPovrchValue.Text;
    _PNL.SetCenterPosByNum(new_center_pos1, 1);
    _PNL.SetCenterPosByNum(new_center_pos2, 2);

    _PNL.HranaStyl := comEdgeStyleValue.Text;
    if comEdgeStyleValue.ItemIndex > 0 then begin
      _PNL.HranaObrobenaBottom := cbEdgeBottom.Checked;
      _PNL.HranaObrobenaRight  := cbEdgeRight.Checked;
      _PNL.HranaObrobenaTop    := cbEdgeTop.Checked;
      _PNL.HranaObrobenaLeft   := cbEdgeLeft.Checked;
    end else begin
      _PNL.HranaObrobenaBottom := false;
      _PNL.HranaObrobenaRight  := false;
      _PNL.HranaObrobenaTop    := false;
      _PNL.HranaObrobenaLeft   := false;
    end;

    if (edEdgeSize.Text = '') then
      _PNL.HranaRozmer := 0
    else
      _PNL.HranaRozmer := StrToFloat(edEdgeSize.Text);

    _PNL.Draw;

  end else
    // ak user nestlaci OK, nastavi povodne hodnoty
    NastavPoliaPodlaPanela;
end;

procedure TfPanelSett.btnSaveClick(Sender: TObject);
begin
  // ak niekto zada zrazenie hrany 0x45' tak automaticky sa zrazenie hrany vypne
  try
    if StrToFloat(edEdgeSize.Text)=0 then begin
      comEdgeStyle.ItemIndex := 0;
      comEdgeStyleValue.ItemIndex := 0;
      edEdgeSize.Text := '';
    end;
  except
  end;

  if not CheckMinMax then begin
    ModalResult := mrNone;
    Exit;
  end;
end;

procedure TfPanelSett.cbCustomMaterialClick(Sender: TObject);
var
  vlastny: boolean;
begin
  vlastny := cbCustomMaterial.Checked;
  edCustomThick.Visible := vlastny; edCustomThick.Top := comHrubka.Top;
  lbCustomThick.Visible := vlastny; lbCustomThick.Top := Label1.Top;
  comHrubka.Visible := not vlastny;
  if vlastny then begin
    edCustomThick.Text := comHrubkaValue.Text;
    edCustomThick.SetFocus;
  end;

  comPovrch.ItemIndex := 0;
  comPovrchValue.ItemIndex := 0;
  lbPovrch.Visible := not vlastny;
  comPovrch.Visible := not vlastny;
  btnSadSurface.Visible := not vlastny;
end;

procedure TfPanelSett.DecimalPoint(Sender: TObject; var Key: Char);
begin
  fMain.CheckDecimalPoint(sender, key, btnSave);
end;

procedure TfPanelSett.EdgeToggle(Sender: TObject);
begin
  if not AsponJednaHrana then (Sender as TCheckBox).Checked := true;
end;

procedure TfPanelSett.edRadiusExit(Sender: TObject);
begin
  try
    if (StrToFloat(edRadius.Text) > Min( StrToFloat(edSirka.Text),StrToFloat(edVyska.Text) )/2 )  then
      edRadius.Text := FormatFloat( '0.##',  Min( StrToFloat(edSirka.Text),StrToFloat(edVyska.Text) )/2);
  except
  end;
end;

function TfPanelSett.AsponJednaHrana: boolean;
var
  counter: byte;
begin
  counter := 0;
  if cbEdgeLeft.Checked then Inc(counter);
  if cbEdgeRight.Checked then Inc(counter);
  if cbEdgeTop.Checked then Inc(counter);
  if cbEdgeBottom.Checked then Inc(counter);

  if counter > 0 then result := true
  else result := false;
end;

procedure TfPanelSett.comEdgeStyleChange(Sender: TObject);
begin
  comEdgeStyleValue.ItemIndex := comEdgeStyle.ItemIndex;
  edEdgeSize.Enabled := (comEdgeStyle.ItemIndex = 1);
  lbEdgeSize.Enabled := edEdgeSize.Enabled;
  if edEdgeSize.Enabled then edEdgeSize.SetFocus;

  cbEdgeLeft.Enabled := edEdgeSize.Enabled;
  cbEdgeRight.Enabled := edEdgeSize.Enabled;
  cbEdgeTop.Enabled := edEdgeSize.Enabled;
  cbEdgeBottom.Enabled := edEdgeSize.Enabled;
  lbEdgeTop.Enabled := edEdgeSize.Enabled;
  lbEdgeBottom.Enabled := edEdgeSize.Enabled;
  lbEdgeRight.Enabled := edEdgeSize.Enabled;
  lbEdgeLeft.Enabled := edEdgeSize.Enabled;
end;

procedure TfPanelSett.comHrubkaChange(Sender: TObject);
begin
  comHrubkaValue.ItemIndex := comHrubka.ItemIndex;
end;

procedure TfPanelSett.comPovrchChange(Sender: TObject);
begin
  comPovrchValue.ItemIndex := comPovrch.ItemIndex;
end;

procedure TfPanelSett.btnSadThicknessClick(Sender: TObject);
begin
  fMain.ShowWish('Panel-thickness');
end;

procedure TfPanelSett.btnSadSurfaceClick(Sender: TObject);
begin
  fMain.ShowWish('Panel-surface');
end;

procedure TfPanelSett.btnSadOtherClick(Sender: TObject);
begin
  fMain.ShowWish('Panel-options');
end;

end.
