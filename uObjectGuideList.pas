unit uObjectGuideList;

interface

uses SysUtils, Types, Contnrs, uOtherObjects;

type
  TGuideList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TGuideObject;
    procedure SetItem(Index: Integer; FeaObj: TGuideObject);
  public
    property Objects[Index: Integer]: TGuideObject read GetItem write SetItem; default;
end;


implementation

{ TFeaList }

function TGuideList.GetItem(Index: Integer): TGuideObject;
begin
  result := (Items[Index] as TGuideObject);
end;

procedure TGuideList.SetItem(Index: Integer; FeaObj: TGuideObject);
begin
  Items[Index] := FeaObj;
end;

end.
