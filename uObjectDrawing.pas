unit uObjectDrawing;

interface

uses
  System.Math,
  System.SysUtils,
  System.Types,
  Vcl.Graphics,
  Vcl.Forms,
  uMyTypes;

type
  TDrawingObject = class(TObject)
  private
    _zoom: Double;
    _backPlane: TBitmap;
    _canvasFrontEnd: TCanvas;
    _canvasFrontEnd_Height: Integer; // potrebujeme koli prevrateniu Y osi pri kresleni
    _drawOffset: TPoint;
    _zoomOffset: TPoint;
    function PX(valueMM: Double; axis: String = ''): integer;
    function MM(valuePX: integer; axis: String = ''): Double;

  published
    constructor Create(frontCanvas: TCanvas);
    property  CanvasHeight: Integer read _canvasFrontEnd_Height write _canvasFrontEnd_Height;
    procedure Init(farba: TColor);
    procedure Line(zaciatok, koniec: TMyPoint; farba: TColor = clWhite; hrubka: Double = 0);
    procedure Text(X, Y: Integer; text: string; farba: TColor = clWhite; velkost: Byte = 10);
    procedure FlipToFront;
    procedure ZoomAll(maxPlocha: TMyRect; canvasSizeX, canvasSizeY, canvasOffsetX, canvasOffsetY: integer; okraj: Double = 3);

  public
    procedure SetZoom(factor: Double; bod: TPoint); overload;
    procedure SetZoom(factor: Double; X, Y: integer); overload;

  end;


implementation

{ TDrawingObject }

uses uDebug;

constructor TDrawingObject.Create(frontCanvas: TCanvas);
begin
  inherited Create;
  _canvasFrontEnd := frontCanvas;
  _backPlane := TBitmap.Create;
  _backPlane.Width := Screen.Width;
  _backPlane.Height := Screen.Height;
end;


procedure TDrawingObject.SetZoom(factor: Double; bod: TPoint);
begin
  SetZoom(factor, bod.X, bod.Y);
end;

procedure TDrawingObject.FlipToFront;
var
  rect: TRect;
begin
  rect := _canvasFrontEnd.ClipRect;
  _canvasFrontEnd.CopyRect(rect, _backPlane.Canvas, rect);
end;

procedure TDrawingObject.Init(farba: TColor);
begin
  // inicializacia vykresu (napr. vykreslenie pozadia farbou)
  with _backPlane.Canvas do begin
    Brush.Color := farba;
    Brush.Style := bsSolid;
    Rectangle(_canvasFrontEnd.ClipRect);
  end;
end;

procedure TDrawingObject.Line(zaciatok, koniec: TMyPoint; farba: TColor = clWhite; hrubka: Double = 0);
begin
  with _backPlane.Canvas do begin

    Pen.Style := psSolid;
    Pen.Color := farba;
    if (hrubka = 0) then
      Pen.Width := 1
    else
      Pen.Width := PX(hrubka);

  fDebug.LogMessage('FROM:'+MyPointToStr(zaciatok)+' TO:'+MyPointToStr(koniec));
    MoveTo(
      PX(zaciatok.X, 'x'),
      PX(zaciatok.Y, 'y')
      );
    LineTo(
      PX(koniec.X, 'x'),
      PX(koniec.Y, 'y')
      );
  end;

  fDebug.LogMessage('FROM:'+inttostr(PX(zaciatok.X, 'x'))+','+inttostr(PX(zaciatok.Y, 'y'))+' TO:'+inttostr(PX(koniec.X, 'x') + 1)+','+inttostr(PX(koniec.Y, 'y') + 1));
end;

function TDrawingObject.MM(valuePX: integer; axis: String): Double;
begin

  if axis = '' then begin

    result := valuePX / _zoom;
  end else begin

    if axis = 'x' then
      result := (valuePX  - _drawOffset.X - _zoomOffset.X) / _zoom
    else if axis = 'y' then
      result := (valuePX - _drawOffset.Y - _zoomOffset.Y) / _zoom;
  end;
end;

function TDrawingObject.PX(valueMM: Double; axis: String = ''): integer;
begin

  if axis = '' then begin

    result := Round(valueMM * _zoom);
  end else begin

    if axis = 'x' then
      result := Round( valueMM * _zoom ) + _drawOffset.X + _zoomOffset.X
    else if axis = 'y' then
      result := _canvasFrontEnd_Height - (Round( valueMM * _zoom) + _drawOffset.Y + _zoomOffset.Y);
  end;
end;

procedure TDrawingObject.ZoomAll(maxPlocha: TMyRect; canvasSizeX, canvasSizeY, canvasOffsetX, canvasOffsetY: integer; okraj: Double);
var
  zoomX, zoomY: Double;
begin
  // vypocitame aky ma byt zoom faktor, aby sa cela plocha zmestila na obrazovku
  zoomX := canvasSizeX / ((maxPlocha.BtmR.X - maxPlocha.TopL.X) + okraj);
  zoomY := canvasSizeY / ((maxPlocha.BtmR.Y - maxPlocha.TopL.Y) + okraj);

  _zoom := Min(zoomX, zoomY);

  _drawOffset.X := -PX(maxPlocha.TopL.X) + canvasOffsetX;
  _drawOffset.Y := -PX(maxPlocha.TopL.Y) + canvasOffsetY;

fDebug.LogMessage('CANVAS SIZE y:'+inttostr(canvasSizeY));
fDebug.LogMessage('CANVAS OFFSET y:'+inttostr(canvasOffsetY));
fDebug.LogMessage('ZOOM:'+floattostr(_zoom));
fDebug.LogMessage('DRAW OFFSET y:'+inttostr(_drawOffset.Y));
end;

procedure TDrawingObject.SetZoom(factor: Double; X, Y: integer);
var
  zoomx,zoomy: Double;
  edgeDistPX_x_old: integer;
  edgeDistPX_x_new: integer;
  edgeDistMM_x_old: Double;
  edgeDistPX_y_old: integer;
  edgeDistPX_y_new: integer;
  edgeDistMM_y_old: Double;
begin
  // okrajove podmienky
  if ((factor > 1) AND (_zoom < 50)) OR
     ((factor < 1) AND (_zoom > 1)) then
    _zoom := _zoom * factor; // zoomuje len ak platia tieto 2 podmienky

  // ak bola funkcia zavolana s parametrom Factor = 0, resetne uzivatelsky zoom
  if (factor = 0) then
    _zoom := 1;

  // ak bola funkcia zavolana s parametrami X = Y = -1, resetne uzivatelsky offset
  if (X = -1) AND (Y = -1) then begin
    _zoomOffset.X := 0;
    _zoomOffset.Y := 0;
  end;

  // ulozime si vzdialenost k hrane este pri starom zoome
  edgeDistPX_x_old := X - _drawOffset.X - _zoomOffset.X;
  edgeDistPX_y_old := Y - _drawOffset.Y - _zoomOffset.Y;
  edgeDistMM_x_old := MM( edgeDistPX_x_old );
  edgeDistMM_y_old := MM( edgeDistPX_y_old );

  // nastavenie zoomu (ak nie je zadany parameter zoomVal, nazoomuje cely panel)
//  zoomx := (fMain.ClientWidth - 10) / objSirka;
//  zoomy := (fMain.ClientHeight - fMain.ToolBar1.Height - 10 - 20 {status bar}) / objVyska;
//  objZoom  := Min(zoomx, zoomy) * objZoomFactor;

  if (X > 0) AND (Y > 0) then begin  // ochrana pred znicenim hodnoty v objZoomOffsetX(Y) ked sa procedura zavola bez pozicie kurzora
    // este nastavime posunutie celeho vykreslovania - aby mys aj po prezoomovani
    // ostavala nad tym istym miestom panela
    edgeDistPX_x_new := PX( edgeDistMM_x_old );
    edgeDistPX_y_new := PX( edgeDistMM_y_old );
    _zoomOffset.X := _zoomOffset.X + ((edgeDistPX_x_old) - (edgeDistPX_x_new));
    _zoomOffset.Y := _zoomOffset.Y + ((edgeDistPX_y_old) - (edgeDistPX_y_new));
  end;
end;

procedure TDrawingObject.Text(X, Y: Integer; text: string; farba: TColor; velkost: Byte);
begin

  with _backPlane.Canvas do begin
    Font.Size := velkost;
    Font.Color := farba;
    TextOut(X, Y, text);
  end;
end;

end.
