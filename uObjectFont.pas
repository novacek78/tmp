unit uObjectFont;

interface

uses SysUtils, Types, Classes, Contnrs, uObjectFontZnak;

type
  TMyFont = class(TObjectList)
  private
  protected
    function GetItem(Index: Integer): TMyZnak;
    procedure SetItem(Index: Integer; Obj: TMyZnak);
  public
    property Znaky[Index: Integer]: TMyZnak read GetItem write SetItem; default;
    function PridajZnak(pozicia: integer): TMyZnak;
    function ZistiSirkuTextu(text: string; vyska_textu: double): double;
end;


implementation


function TMyFont.GetItem(Index: Integer): TMyZnak;
begin
	try
		result := (Items[Index] as TMyZnak);
  except
    raise Exception.Create('Unknown character ('+IntToStr(Index)+') in current font.');
  end;
end;

function TMyFont.PridajZnak(pozicia: integer): TMyZnak;
begin
	// ak vo fonte este nie je zaalokovany priestor na znak s danym 'indexom' (Ord(znak))
  // tak to zaalokujeme a inicializujem na NIL
  while Capacity < (pozicia+1) do begin
    Capacity := Capacity + 1;
    Add(nil);
  end;

  Items[pozicia] := TMyZnak.Create;
  if OwnsObjects then ;

  result := TMyZnak(Items[pozicia]);
end;

procedure TMyFont.SetItem(Index: Integer; Obj: TMyZnak);
begin
  Items[Index] := Obj;
end;

function TMyFont.ZistiSirkuTextu(text: string; vyska_textu: double): double;
var
	i, indexZnaku: integer;
  sizeFaktor: Double;
begin
	result := 0;
  sizeFaktor := vyska_textu / 10;

  for i := 1 to Length(text) do begin
    indexZnaku := Ord(Char(text[i]));

    if (indexZnaku > Capacity) OR (not Assigned(Self.Items[indexZnaku])) then
    	indexZnaku := Ord(Char('?')); // ak taky znak nepozna, vykresli '?'

    result := result + ((Self.Znaky[indexZnaku].sirkaZnaku  + Self.Znaky[indexZnaku].sirkaMedzery) * sizeFaktor);
  end;

  // este musime odpocitat sirku medzery za poslednym znakom (v premennej INDEXZNAKU nam ostal index posledneho znaku)
  if Assigned(Self.Items[indexZnaku]) then // ak taky znak pozna
    result := result - (Self.Znaky[indexZnaku].sirkaMedzery * sizeFaktor)
end;

end.


