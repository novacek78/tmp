unit uObjectFeaturePolyLine;

interface

uses SysUtils, Types, Math, Graphics, Contnrs, uMyTypes, uObjectFeature;

type
  TFeaturePolyLineObject = class(TFeatureObject)
  private
    objVertices: array of TMyPoint;
    procedure objCalcBoundingBox;
  public
    constructor Create(rodicPanel: TObject; stranaPanela: integer = -1);
    destructor  Destroy;
    function  VertexCount: integer;
    function  GetVertex(i: integer): TMyPoint;
    function  GetVertexCount(): integer;
    procedure SetVertex(i: integer; x,y: double);
    procedure AddVertex(x,y: double); overload;
    procedure AddVertex(p: TMyPoint); overload;
    procedure MoveVertexBy(i: integer; x,y: double);
    procedure MovePolylineBy(x,y: double);
  published
    procedure Draw;
    procedure DrawHighlighted;
    procedure CopyFrom(src: TFeaturePolyLineObject);
  end;


implementation

uses uMain, uDrawLib, uDebug, uConfig;

{ TFeaturePolyLineObject }

procedure TFeaturePolyLineObject.CopyFrom(src: TFeaturePolyLineObject);
var
  i: integer;
begin
  // ID sa nekopiruje !!! //
  inherited CopyFrom(src);
  SetLength(objVertices, 0);
  for i := 0 to src.VertexCount-1 do begin
    AddVertex(src.GetVertex(i));
  end;
end;

constructor TFeaturePolyLineObject.Create(rodicPanel: TObject; stranaPanela: integer = -1);
begin
  inherited Create(rodicPanel, stranaPanela, ftPolyLineGrav);
end;

destructor TFeaturePolyLineObject.Destroy;
begin
  SetLength(objVertices, 0);
  inherited Destroy;
end;



procedure TFeaturePolyLineObject.Draw;
var
  farVypln: TColor;
  i: integer;
begin
  BackPlane.Canvas.Brush.Style := bsSolid;
  BackPlane.Canvas.Pen.Style := psSolid;

  if Strana <> _PNL.StranaVisible then EXIT;  // ak je vzadu, nevykreslujeme ho, lebo toto je len gravirovanie

  // ak je prvok na zadnej strane, musi sa vykreslovat podla zadneho nul.bodu
  _PNL.CurrentSide := Strana;

  if Param4 = 'NOFILL' then farVypln := farbaGravirSurovy;
  if Param4 = 'BLACK'  then farVypln := clBlack;
  if Param4 = 'WHITE'  then farVypln := clWhite;
  if Param4 = 'RED'    then farVypln := clRed;
  if Param4 = 'GREEN'  then farVypln := clGreen;
  if Param4 = 'BLUE'   then farVypln := clBlue;

  for i := 0 to Length(objVertices) - 2 do begin
    Ciara( objVertices[i], objVertices[i+1], farVypln, Rozmer3 + rozsirenieGravira );
  end;
end;

procedure TFeaturePolyLineObject.DrawHighlighted;
var
  i: integer;
begin
  BackPlane.Canvas.Brush.Style := bsSolid;
  BackPlane.Canvas.Pen.Style := psSolid;

  if Strana <> _PNL.StranaVisible then EXIT;  // ak je vzadu, nevykreslujeme ho, lebo toto je len gravirovanie

  // ak je prvok na zadnej strane, musi sa vykreslovat podla zadneho nul.bodu
  _PNL.CurrentSide := Strana;

  for i := 0 to Length(objVertices) - 2 do begin
    Ciara( objVertices[i], objVertices[i+1], farbaHighlightObvod, Rozmer3 + rozsirenieGravira );
  end;
end;

function TFeaturePolyLineObject.VertexCount: integer;
begin
  result := Length(objVertices);
end;

procedure TFeaturePolyLineObject.AddVertex(x, y: double);
begin
  AddVertex( MyPoint(x,y) );
end;

procedure TFeaturePolyLineObject.AddVertex(p: TMyPoint);
var
  count: integer;
begin
  count := Length(objVertices);
  SetLength(objVertices , count+1);
  objVertices[count] := p;
  objCalcBoundingBox;
end;

function TFeaturePolyLineObject.GetVertex(i: integer): TMyPoint;
begin
  result := objVertices[i];
end;

function TFeaturePolyLineObject.GetVertexCount: integer;
begin
  result := Length(objVertices);
end;

procedure TFeaturePolyLineObject.MovePolylineBy(x, y: double);
var
  i: integer;
begin
  for i:=0 to Length(objVertices)-1 do begin
    MoveVertexBy(i, x, y);
  end;
  objCalcBoundingBox;
end;

procedure TFeaturePolyLineObject.MoveVertexBy(i: integer; x, y: double);
begin
  objVertices[i].X := objVertices[i].X + x;
  objVertices[i].Y := objVertices[i].Y + y;
end;

procedure TFeaturePolyLineObject.SetVertex(i: integer; x, y: double);
begin
  if i < Length(objVertices) then begin
    objVertices[i].X := x;
    objVertices[i].Y := y;
  end;
  objCalcBoundingBox;
end;

procedure TFeaturePolyLineObject.objCalcBoundingBox;
var
  i: integer;
  myrect: TMyRect;
begin
  if Length(objVertices) < 2 then EXIT; // az ked ma polyline aspon 2 pody, budeme ratat Box

  myrect.TopL.X := Min( objVertices[0].X , objVertices[1].X );
  myrect.TopL.Y := Max( objVertices[0].Y , objVertices[1].Y );
  myrect.BtmR.X := Max( objVertices[0].X , objVertices[1].X );
  myrect.BtmR.Y := Min( objVertices[0].Y , objVertices[1].Y );

  for i:=2 to Length(objVertices)-1 do begin
    if objVertices[i].X < myrect.TopL.X then myrect.TopL.X := objVertices[i].X;
    if objVertices[i].X > myrect.BtmR.X then myrect.BtmR.X := objVertices[i].X;
    if objVertices[i].Y > myrect.TopL.Y then myrect.TopL.Y := objVertices[i].Y;
    if objVertices[i].Y < myrect.BtmR.Y then myrect.BtmR.Y := objVertices[i].Y;
  end;

  // ak ma nastavenu hrubku gravirovania, zvacsime boundingbox este o to
  if Rozmer3 > 0 then begin
    myrect.TopL.X := myrect.TopL.X - (Rozmer3/2);
    myrect.TopL.Y := myrect.TopL.Y + (Rozmer3/2);
    myrect.BtmR.X := myrect.BtmR.X + (Rozmer3/2);
    myrect.BtmR.Y := myrect.BtmR.Y - (Rozmer3/2);
  end;


  BoundingBox := myrect;
end;

end.
