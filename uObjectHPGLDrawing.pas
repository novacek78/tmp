unit uObjectHPGLDrawing;

interface

uses SysUtils, Types, Contnrs, uMyTypes, uObjectFeaturePolyLine, Math;

type
  THPGLDrawing = class(TObject)
  private
    objPolylines: TObjectList;
    objMinX, objMinY, objMaxX, objMaxY: double;
    objInternalPolylinePointer: integer; // ukazatel na aktualnu polyline (pri ziskavani polylineov cez GetNextPolyline)
    function  objGetPolyline(Index: Integer): TFeaturePolyLineObject;
  public
    constructor Create(filePath: string; rodicPanel: TObject; sizeFactor: double = 1);
    destructor  Destroy;
    property    Polylines[Index: Integer]: TFeaturePolyLineObject read objGetPolyline;
    function    CountPolylines: integer;
    function    GetNextPolyline: TFeaturePolyLineObject;
    property    MinX: double read objMinX;
    property    MinY: double read objMinY;
    property    MaxX: double read objMaxX;
    property    MaxY: double read objMaxY;
  published
end;


implementation

uses uMain, uDebug;


{ THPGLDrawing }



function THPGLDrawing.CountPolylines: integer;
begin
  result := objPolylines.Count;
end;

constructor THPGLDrawing.Create(filePath: string; rodicPanel: TObject; sizeFactor: double = 1);
var
  f: TextFile;
  riadok: string;
  newFeaIndex: integer;
  x,y: double;
  separatorPos, riadokLength: byte;
begin
  inherited Create;
  objMinX := 9999999;
  objMinY := 9999999;
  objMaxX := -9999999;
  objMaxY := -9999999;
  objInternalPolylinePointer := 0;
  objPolylines := TObjectList.Create;

  if FileExists(filePath) then
  try
    newFeaIndex := -1;
    AssignFile(f, filePath);
    Reset(f);
    while not EOF(f) do begin
      Readln(f, riadok);
      if Copy(riadok, 0, 2) = 'PU' then begin
        separatorPos := Max(Pos(' ', riadok) , Pos(',', riadok)); // hladame separator X a Y suradnice - moze to byt aj ciarka a aj medzera, ak Pos nenajde, vracia nulu
        riadokLength := Length(riadok);
        x := StrToInt( Copy(riadok, 3, separatorPos-3));
        y := StrToInt( Copy(riadok, separatorPos+1, (riadokLength-separatorPos-1)));
        newFeaIndex := objPolylines.Add(TFeaturePolyLineObject.Create(rodicPanel));
        (objPolylines.Items[newFeaIndex] as TFeaturePolyLineObject).AddVertex( x/40*sizeFactor, y/40*sizeFactor );
        objMinX := Min(objMinX, x);
        objMinY := Min(objMinY, y);
        objMaxX := Max(objMaxX, x);
        objMaxY := Max(objMaxY, y);
      end;
      if Copy(riadok, 0, 2) = 'PD' then begin
        separatorPos := Max(Pos(' ', riadok) , Pos(',', riadok)); // hladame separator X a Y suradnice - moze to byt aj ciarka a aj medzera, ak Pos nenajde, vracia nulu
        riadokLength := Length(riadok);
        x := StrToInt( Copy(riadok, 3, separatorPos-3));
        y := StrToInt( Copy(riadok, separatorPos+1, (riadokLength-separatorPos-1)));
        (objPolylines.Items[newFeaIndex] as TFeaturePolyLineObject).AddVertex( x/40*sizeFactor, y/40*sizeFactor );
        objMinX := Min(objMinX, x);
        objMinY := Min(objMinY, y);
        objMaxX := Max(objMaxX, x);
        objMaxY := Max(objMaxY, y);
      end;
    end;
    // ak na zaver ostal nejaky objekt polyline len s jednym bodom (napr.vytvoreny poslednym "Pen Up") tak ho zmazeme
    if ((objPolylines.Items[newFeaIndex] as TFeaturePolyLineObject).VertexCount = 1) then
      objPolylines.Delete(newFeaIndex);
  finally
    Close(f);
  end;
  objMinX := objMinX * sizeFactor;
  objMinY := objMinY * sizeFactor;
  objMaxX := objMaxX * sizeFactor;
  objMaxY := objMaxY * sizeFactor;
end;

destructor THPGLDrawing.Destroy;
begin
  FreeAndNil(objPolylines);
  inherited Destroy;
end;

function THPGLDrawing.GetNextPolyline: TFeaturePolyLineObject;
begin
  if objInternalPolylinePointer < objPolylines.Count then begin
    result := (objPolylines.Items[objInternalPolylinePointer] as TFeaturePolyLineObject);
    Inc(objInternalPolylinePointer);
  end;
end;

function THPGLDrawing.objGetPolyline(Index: Integer): TFeaturePolyLineObject;
begin
//
end;


end.
