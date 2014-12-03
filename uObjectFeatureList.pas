unit uObjectFeatureList;

interface

uses SysUtils, Types, Contnrs, uObjectFeature;

type
  TFeaList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TFeatureObject;
    procedure SetItem(Index: Integer; FeaObj: TFeatureObject);
  public
    property Objects[Index: Integer]: TFeatureObject read GetItem write SetItem; default;

    function _ToString: string;
end;


implementation

{ TFeaList }

function TFeaList.GetItem(Index: Integer): TFeatureObject;
begin
  result := (Items[Index] as TFeatureObject);
end;

procedure TFeaList.SetItem(Index: Integer; FeaObj: TFeatureObject);
begin
  Items[Index] := FeaObj;
end;

function TFeaList._ToString: string;
var
  s: string;
  i: Integer;
begin
  s := '--- TFeaList DUMP ---' + #13+#10;
  for i := 0 to Count-1 do
    s := s + '#:' + IntToStr(i) + ', ID:' +inttostr(GetItem(i).ID) + ', Typ:' + IntToStr(GetItem(i).Typ) + #13+#10;

  Result := s;
end;

end.
