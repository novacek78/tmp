unit uObjectDXFEntity;

interface

uses Classes, SysUtils, Contnrs, uMyTypes;

type
  TDXFEntity = class(TObject)
  private
    objVlastnosti: TStringList;
    objSubEntities: TObjectList;
    function objGetPair(index: integer): TDXFPair;
    function  objGetSubEntity(Index: Integer): TDXFEntity;
    procedure objSetSubEntity(Index: Integer; EntityObj: TDXFEntity);
  public
    property  Pairs[Index: integer]: TDXFPair read objGetPair; // musi byt public, lebo je typu ARRAY
    property  SubEntities[Index: Integer]: TDXFEntity read objGetSubEntity write objSetSubEntity;
    procedure SetValue(code: integer; value: string); Overload; // viac overload verzii sa da len v publicu
    procedure SetValue(code,value: string); Overload;
  published
    constructor Create;
    destructor  Destroy;
    function  SubEntityAddVertex(v: TMyPoint; layer: string): integer;
    function  GetValueS(code: integer): string;
    function  GetValueF(code: integer): double;
    function  GetValueI(code: integer): integer;
    function  PairsCount: integer;
    function  SubEntitiesCount: integer;
    function  GetAllValues: string;
end;

implementation


constructor TDXFEntity.Create;
begin
  inherited Create;
  objVlastnosti := TStringList.Create;
  objSubEntities := TObjectList.Create;
end;

destructor TDXFEntity.Destroy;
begin
  FreeAndNil(objVlastnosti);
  FreeAndNil(objSubEntities);
  inherited Destroy;
end;

// 2 verzie metody SETVALUE :
procedure TDXFEntity.SetValue(code: integer; value: string);
begin
  objVlastnosti.Values[ Format('%3d', [code]) ] := value; // format identifikatora je 3-miestny retazec (napr. '  8')
end;

procedure TDXFEntity.SetValue(code,value: string);
begin
  objVlastnosti.Values[ code ] := value; // format identifikatora je 3-miestny retazec (napr. '  8')
end;




function TDXFEntity.SubEntitiesCount: integer;
begin
  result := objSubEntities.Count;
end;

function TDXFEntity.SubEntityAddVertex(v: TMyPoint; layer: string): integer;
var
  i: integer;
begin
  // vytvori entitu typu LINE v DXF drawingu a vrati jej novo-prideleny index
  i := objSubEntities.Add(TDXFEntity.Create);
  SubEntities[i].SetValue(0, 'VERTEX');
  SubEntities[i].SetValue(8, layer);
  SubEntities[i].SetValue(10, FloatToStr(v.X));
  SubEntities[i].SetValue(20, FloatToStr(v.Y));
  result := i;
end;

function TDXFEntity.PairsCount: integer;
begin
  result := objVlastnosti.Count;
end;



function TDXFEntity.GetValueS(code: integer): string;
begin
  result := objVlastnosti.Values[ Format('%3d',[code]) ]; // format identifikatora je 3-miestny retazec (napr. '  8')
end;

function TDXFEntity.GetValueF(code: integer): double;
begin
  result := StrToFloat( objVlastnosti.Values[ Format('%3d',[code]) ] );
end;

function TDXFEntity.GetValueI(code: integer): integer;
begin
  result := StrToInt( objVlastnosti.Values[ Format('%3d',[code]) ] );
end;


function TDXFEntity.objGetPair(index: integer): TDXFPair;
begin
  result.code := StrToInt(objVlastnosti.Names[index]);
  result.val  := objVlastnosti.Values[objVlastnosti.Names[index]];
end;

function TDXFEntity.objGetSubEntity(Index: Integer): TDXFEntity;
begin
  result := (objSubEntities.Items[Index] as TDXFEntity);
end;

procedure TDXFEntity.objSetSubEntity(Index: Integer; EntityObj: TDXFEntity);
begin
//
end;

function TDXFEntity.GetAllValues: string;
var
  i: integer;
begin
  // f-cia uzitocna len pre debug
  result := '';
  for i := 0 to objVlastnosti.Count - 1 do
    result := result + '['+IntToStr(i)+']'+ objVlastnosti.Names[i] + '=' + objVlastnosti.Values[objVlastnosti.Names[i]] + ',';
end;


end.
