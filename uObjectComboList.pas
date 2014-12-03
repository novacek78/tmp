unit uObjectComboList;

interface

uses SysUtils, Types, Contnrs, uObjectCombo;

type
  TComboList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TComboObject;
    procedure SetItem(Index: Integer; FeaObj: TComboObject);
  public
    property Objects[Index: Integer]: TComboObject read GetItem write SetItem; default;
end;


implementation

{ TFeaList }

function TComboList.GetItem(Index: Integer): TComboObject;
begin
  result := (Items[Index] as TComboObject);
end;

procedure TComboList.SetItem(Index: Integer; FeaObj: TComboObject);
begin
  Items[Index] := FeaObj;
end;

end.
