unit uObjectUrlDotaz;

interface

uses SysUtils, Types, Classes, IdUri, IdGlobal;

type
  TUrlDotaz = class(TObject)
  private
  	function EncodeString(s: string): string;
  protected
  public
  	adresa: string;
    params: TStringList;

    constructor Create; overload;
    constructor Create(adr: string); overload;
    function GetEncodedUrl: string;
end;



implementation

{ TUrlDotaz }

constructor TUrlDotaz.Create;
begin
	inherited Create;
  params := TStringList.Create;
end;

constructor TUrlDotaz.Create(adr: string);
begin
  inherited Create;
	Create;
  adresa := adr;
end;

function TUrlDotaz.EncodeString(s: string): string;
begin
	s := TIdURI.ParamsEncode(s, IndyUTF8Encoding); // tato f-cia musi dostat aj typ protokolu a host. Preto to 'http://' aj to www.qp.sk
  s := StringReplace(s, 'http://www.qp.sk/', '', [rfReplaceAll] ); // teraz to dame prec
  result := StringReplace(s, '&', '%26', [rfReplaceAll] );
end;

function TUrlDotaz.GetEncodedUrl: string;
var
  i: Integer;
begin
	result := adresa;
  if params.Count > 0 then begin
    result := result + '?';
    for i := 0 to params.Count-1 do
      result := result + params.Names[i] + '=' + EncodeString(params.ValueFromIndex[i]) + '&';
  end;
end;

end.
