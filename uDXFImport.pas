unit uDXFImport;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, uObjectDXFDrawing,
  uObjectPanel, uObjectDrawing;

type
  TfDxfImport = class(TForm)
    pnlTop: TPanel;
    btnPanelShape: TBitBtn;
    btnHoles: TBitBtn;
    btnPockets: TBitBtn;
    shpSeparator: TShape;
    btnBrowse: TBitBtn;
    shp1: TShape;
    lbThickness: TLabel;
    comHrubka: TComboBox;
    comHrubkaValue: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure comHrubkaChange(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
    _dxfFileName: string;
    _dxf: TDXFDrawing;
    _drawing: TDrawingObject;
  public
    { Public declarations }
    property dxfFileName: string read _dxfFileName write _dxfFileName;
    property DXF: TDXFDrawing read _dxf write _dxf;
    procedure DrawStatic;
    procedure DrawDynamic;
    procedure LoadDXF;
  end;

var
  fDxfImport: TfDxfImport;

implementation

{$R *.dfm}

uses uConfig, uMain, uPanelSett, uTranslate, uDebug, uMyTypes;


procedure TfDxfImport.FormCreate(Sender: TObject);
var
  tmp: string;
begin
	try
    tmp := 'creating drawing';
    _drawing := TDrawingObject.Create(Self.Canvas);
  except
		messagebox(0, PChar('DXF import OnCreate error in operation: ' + tmp), 'Error', MB_OK);
    ModalResult := mrAbort;
  end;
  fMain.Log('DXF import: Drawing canvas created');

  comHrubka.Items := fPanelSett.comHrubka.Items;
  comHrubkaValue.Items := fPanelSett.comHrubkaValue.Items;

  TransObj(Self);
end;

procedure TfDxfImport.FormMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if fMain.ViewReverseWheel.Checked then
    _drawing.SetZoom(1.1, ScreenToClient(mouse.CursorPos).X, ScreenToClient(mouse.CursorPos).Y)
  else
    _drawing.SetZoom(0.9, ScreenToClient(mouse.CursorPos).X, ScreenToClient(mouse.CursorPos).Y);

  _dxf.Draw(_drawing);
end;

procedure TfDxfImport.FormMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if fMain.ViewReverseWheel.Checked then
    _drawing.SetZoom(0.9, ScreenToClient(mouse.CursorPos).X, ScreenToClient(mouse.CursorPos).Y)
  else
    _drawing.SetZoom(1.1, ScreenToClient(mouse.CursorPos).X, ScreenToClient(mouse.CursorPos).Y);

    _dxf.Draw(_drawing);
end;

procedure TfDxfImport.FormActivate(Sender: TObject);
begin
  fMain.Log('DXF import: FormActivate');
  LoadDXF;
end;

procedure TfDxfImport.FormPaint(Sender: TObject);
var
  i: Integer;
begin
//fDebug.LogMessage('FORM PAINT()');
  _drawing.Init(farbaBgndTmavy);

  _drawing.Text(8, pnlTop.Height+8, _dxfFileName, farbaBgndSvetly, 13);

  _drawing.CanvasHeight := ClientHeight - pnlTop.Height;

  _dxf.Draw(_drawing);

  _drawing.FlipToFront;
end;

procedure TfDxfImport.FormShow(Sender: TObject);
begin
  fMain.Log('DXF import: FormShow');
end;





procedure TfDxfImport.btnBrowseClick(Sender: TObject);
begin
  fMain.OpenDialog.InitialDir := ExtractFilePath(Self.dxfFileName);

  if fMain.OpenDialog.Execute then begin
    _dxfFileName := fMain.OpenDialog.FileName;
    Self.LoadDXF;
    Self.Paint;
  end;
end;

procedure TfDxfImport.comHrubkaChange(Sender: TObject);
begin
  comHrubkaValue.ItemIndex := comHrubka.ItemIndex;
end;

procedure TfDxfImport.DrawDynamic;
begin
end;

procedure TfDxfImport.DrawStatic;
begin
end;

procedure TfDxfImport.LoadDXF;
begin
  if Assigned(_dxf) then _dxf.Free;
  _dxf := TDXFDrawing.Create;

  _dxf.LoadFromFile(_dxfFileName);

  _drawing.CanvasHeight := ClientHeight - pnlTop.Height;
  _drawing.ZoomAll( _dxf.BoundingBox, ClientWidth, (ClientHeight - pnlTop.Height), 0, pnlTop.Height );
  fMain.Log('BOUNDING RECT: ' + MyRectToStr(_dxf.BoundingBox));
end;

end.
