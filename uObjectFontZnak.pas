unit uObjectFontZnak;

interface

uses SysUtils, Types, Contnrs, uMyTypes;

type
  TMyZnak = class(TObject)
  protected
    objSirkaZnaku: double; // sirka len samotneho znaku
    objSirkaMedzery: double; // sirka priestoru, ktory ma ostat za nim, aby nebol spojeny s dalsim znakom (treba koli poslednemu znaku v texte pri zarovnani na stred a pocitani cekovej sirky textu)
  	objPoints: TPoleHPGLCiar;
  public
    constructor Create;
    property Points: TPoleHPGLCiar read objPoints write objPoints;
    property SirkaMedzery: double read objSirkaMedzery write objSirkaMedzery;
    property SirkaZnaku: double read objSirkaZnaku write objSirkaZnaku;

  	procedure NastavPocetBodov(n: integer);
end;


implementation

{ TFeaList }

constructor TMyZnak.Create;
begin
  inherited Create;
end;

procedure TMyZnak.NastavPocetBodov(n: integer);
begin
	// nastavi velkost dynamickeho pola aby obsiahlo tolko bodov, kolko potrebujeme
  SetLength( objPoints, n);
end;

end.
