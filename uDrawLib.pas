unit uDrawLib;

interface

uses Forms, Math, Graphics, uMain, uMyTypes, Windows, SysUtils, Dialogs, Classes, uObjectFont;


procedure KruzPlocha(stred: TMyPoint; priemer: double; farVypln, farOkolo: TColor; hrubka: integer=1);
procedure KruzObvod(stred: TMyPoint; priemer: double; farba: TColor; hrubka: integer=1; styl: TPenStyle=psSolid);
procedure ObdlzPlocha(stred: TMyPoint; rozmerX, rozmerY, radius, priemerZapichu: double; farVypln, farOkolo: TColor; hrubka: integer=1);
procedure ObdlzObvod(stred: TMyPoint; rozmerX, rozmerY, radius: double; farba: TColor; hrubka: integer=1; styl: TPenStyle=psSolid);
procedure Ciara(zaciatok, koniec: TMyPoint; farba: TColor; sirka: double = 0; styl: TPenStyle=psSolid);
procedure Obluk(stred: TMyPoint; priemer, uholStart, uholEnd: double; farOkolo: TColor; hrubka: integer=1; uzatvorit: boolean=false; styl: TPenStyle=psSolid);
function  TextWidth(txt: string; velkost: double; qpfont: TMyFont): double;
procedure Text(txt: string; bodVlozenia: TMyPoint; velkost, celkova_sirka: double; typVelkosti, zarovnanie: string; farba: TColor; nastroj: double; FontTextu: TMyFont; rotacia: Double = 0);
procedure Text_old(txt: string; bodVlozenia: TMyPoint; velkost: double; typVelkosti, zarovnanie: string; farba: TColor);
function  ZrkadliUhol(uhol: double; OkoloOsi: char = 'y'): double;
function  CiaraOffset(zaciatok: TMyPoint; koniec: TMyPoint; strana: char; distance: double): TMyPoint2D;
procedure CiaraOffset2(var usecka: TMyPoint2D; strana: char; distance: double);
function  RotujBodOkoloBoduPX(bod, stredRotacie: TPoint; uhol: double): TPoint;
function  RotujBodOkoloBoduMM(bod, stredRotacie: TMyPoint; uhol: double): TMyPoint;


implementation

uses uDebug, uConfig;



function RotujBodOkoloBoduMM(bod, stredRotacie: TMyPoint; uhol: double): TMyPoint;
var
  s,c: Double;
begin
  // stupne na radiany
  uhol := uhol * piDelene180;

  s := Sin(uhol);
  c := Cos(uhol);

  bod.X := bod.X - stredRotacie.X;
  bod.Y := bod.Y - stredRotacie.Y;

  // pri vypocte rotacie milimetrovych hodnot su trochu inak znamienka pri Ypsilone (de facto sa rotuje do opacneho smeru) lebo v MM systeme Y smerom nahor stupa (v PX systeme je to naopak)
  Result.X := c * bod.X - s * bod.Y + stredRotacie.X;
  Result.Y := s * bod.X + c * bod.Y + stredRotacie.Y;
end;


function RotujBodOkoloBoduPX(bod, stredRotacie: TPoint; uhol: double): TPoint;
var
  s,c: Double;
begin
  // stupne na radiany
  uhol := uhol * piDelene180;

  s := Sin(uhol);
  c := Cos(uhol);

  bod.X := bod.X - stredRotacie.X;
  bod.Y := bod.Y - stredRotacie.Y;

  Result.X := Round( c * bod.X + s * bod.Y + stredRotacie.X );
  Result.Y := Round( -s * bod.X + c * bod.Y + stredRotacie.Y );
end;


procedure KruzPlocha(stred: TMyPoint; priemer: double; farVypln, farOkolo: TColor; hrubka: integer=1);
begin
  BackPlane.Canvas.Brush.Color := farVypln;
  BackPlane.Canvas.Pen.Color   := farOkolo;
  BackPlane.Canvas.Pen.Width   := hrubka;
  BackPlane.Canvas.Ellipse(
    PX(stred.X - (priemer/2), 'x'),
    PX(stred.Y - (priemer/2), 'y') + 1,
    PX(stred.X + (priemer/2), 'x') + 1,
    PX(stred.Y + (priemer/2), 'y')
  );
end;

procedure KruzObvod(stred: TMyPoint; priemer: double; farba: TColor; hrubka: integer=1; styl: TPenStyle=psSolid);
begin
  BackPlane.Canvas.Brush.Style := bsClear;
  BackPlane.Canvas.Pen.Color   := farba;
  BackPlane.Canvas.Pen.Width   := hrubka;
  BackPlane.Canvas.Pen.Style   := styl;
  BackPlane.Canvas.Ellipse(
    PX(stred.X - (priemer/2), 'x'),
    PX(stred.Y - (priemer/2), 'y') + 1,
    PX(stred.X + (priemer/2), 'x') + 1,
    PX(stred.Y + (priemer/2), 'y')
  );
end;



procedure ObdlzPlocha(stred: TMyPoint; rozmerX, rozmerY, radius, priemerZapichu: double; farVypln, farOkolo: TColor; hrubka: integer=1);
var
  tmp_x_MM, tmp_y_MM: double;
begin
  BackPlane.Canvas.Brush.Color := farVypln;
  BackPlane.Canvas.Pen.Color   := farOkolo;
  BackPlane.Canvas.Pen.Width   := hrubka;
  BackPlane.Canvas.RoundRect(
    Px(stred.X-(rozmerX/2),'x'),
    Px(stred.Y-(rozmerY/2),'y')+1,
    Px(stred.X+(rozmerX/2),'x')+1,
    Px(stred.Y+(rozmerY/2),'y'),
    Px(radius*2),
    Px(radius*2)
  );
  if radius = 0 then begin // ak ma v rohoch R0, vykreslime zapichy
    BackPlane.Canvas.Pen.Color   := BackPlane.Canvas.Brush.Color;
    // tmp_x(resp.y)_MM je posunutie kruznice zapichu od rohu
    tmp_x_MM := (priemerZapichu/2)*(1-cos( PI/4 ));  // tmp_x_MM = R-(R*cos45') = R*(1-cos45')
    tmp_y_MM := (priemerZapichu/2)*(1-sin( PI/4 ));  // tmp_y_MM = R-(R*sin45') = R*(1-sin45')
    BackPlane.Canvas.Ellipse(
      Px(stred.X-(rozmerX/2)-tmp_x_MM,'x'),
      Px(stred.Y-(rozmerY/2)-tmp_y_MM,'y'),
      Px(stred.X-(rozmerX/2)+(priemerZapichu-tmp_x_MM),'x'),
      Px(stred.Y-(rozmerY/2)+(priemerZapichu-tmp_y_MM),'y')
    );
    BackPlane.Canvas.Ellipse(
      Px(stred.X+(rozmerX/2)+tmp_x_MM,'x')+1,
      Px(stred.Y-(rozmerY/2)-tmp_y_MM,'y'),
      Px(stred.X+(rozmerX/2)-(priemerZapichu-tmp_x_MM),'x')+1,
      Px(stred.Y-(rozmerY/2)+(priemerZapichu-tmp_y_MM),'y')
    );
    BackPlane.Canvas.Ellipse(
      Px(stred.X+(rozmerX/2)+tmp_x_MM,'x')+1,
      Px(stred.Y+(rozmerY/2)+tmp_y_MM,'y'),
      Px(stred.X+(rozmerX/2)-(priemerZapichu-tmp_x_MM),'x')+1,
      Px(stred.Y+(rozmerY/2)-(priemerZapichu-tmp_y_MM),'y')
    );
    BackPlane.Canvas.Ellipse(
      Px(stred.X-(rozmerX/2)-tmp_x_MM,'x'),
      Px(stred.Y+(rozmerY/2)+tmp_y_MM,'y'),
      Px(stred.X-(rozmerX/2)+(priemerZapichu-tmp_x_MM),'x'),
      Px(stred.Y+(rozmerY/2)-(priemerZapichu-tmp_y_MM),'y')
    );
  end; // ak ma v rohoch R=0
end;

procedure ObdlzObvod(stred: TMyPoint; rozmerX, rozmerY, radius: double; farba: TColor; hrubka: integer=1; styl: TPenStyle=psSolid);
begin
  BackPlane.Canvas.Brush.Style := bsClear;
  BackPlane.Canvas.Pen.Color   := farba;
  BackPlane.Canvas.Pen.Width   := hrubka;
  BackPlane.Canvas.Pen.Style   := styl;
  BackPlane.Canvas.RoundRect(
    Px(stred.X-(rozmerX/2),'x'),
    Px(stred.Y-(rozmerY/2),'y')+1,
    Px(stred.X+(rozmerX/2),'x')+1,
    Px(stred.Y+(rozmerY/2),'y'),
    Px(radius*2),
    Px(radius*2)
  );
end;



procedure Ciara(zaciatok, koniec: TMyPoint; farba: TColor; sirka: double = 0; styl: TPenStyle=psSolid);
begin
  BackPlane.Canvas.Pen.Color   := farba;
  if sirka > 0 then BackPlane.Canvas.Pen.Width := PX(sirka)
  else BackPlane.Canvas.Pen.Width := 1;

  BackPlane.Canvas.Pen.Style := styl;
  BackPlane.Canvas.MoveTo( PX(zaciatok.X, 'x'), PX(zaciatok.Y, 'y') );
  BackPlane.Canvas.LineTo( PX(koniec.X, 'x'), PX(koniec.Y, 'y') );
end;

procedure Obluk(stred: TMyPoint; priemer, uholStart, uholEnd: double; farOkolo: TColor; hrubka: integer=1; uzatvorit: boolean=false; styl: TPenStyle=psSolid);
var
  startPoint, endPoint: TMyPoint;
  polomer: Double;
  uholStartRad, uholEndRad: Double;
  uholStartCos, uholStartSin, uholEndCos, uholEndSin: Double;
begin
  BackPlane.Canvas.Brush.Style := bsClear;
  BackPlane.Canvas.Pen.Color   := farOkolo;
  BackPlane.Canvas.Pen.Width   := hrubka;
  BackPlane.Canvas.Pen.Style   := styl;

  uholStartRad := DegToRad(uholStart);
  uholEndRad   := DegToRad(uholEnd);

  uholStartCos := cos(uholStartRad);
  uholStartSin := sin(uholStartRad);
  uholEndCos   := cos(uholEndRad);
  uholEndSin   := sin(uholEndRad);

  // vypocitam body, ktore urcuju start/stop obluka (na obrovskom polomere aby to bolo presnejsie)
  // (podla rovnice kruznice X = A + r*cos ALFA ; Y = B + r*sin BETA)
  startPoint.X := stred.X + ( 999 * uholStartCos );
  startPoint.Y := stred.Y + ( 999 * uholStartSin );
  endPoint.X   := stred.X + ( 999 * uholEndCos );
  endPoint.Y   := stred.Y + ( 999 * uholEndSin );

//  SetArcDirection( GetDC(BackPlane.Canvas.Handle) , AD_COUNTERCLOCKWISE);

  polomer := priemer/2;

  BackPlane.Canvas.Arc(
    PX(stred.X - polomer, 'x'),
    PX(stred.Y - polomer, 'y') + 1,
    PX(stred.X + polomer, 'x') + 1,
    PX(stred.Y + polomer, 'y'),
    PX(startPoint.X, 'x'), PX(startPoint.Y, 'y'),
    PX(endPoint.X, 'x'), PX(endPoint.Y, 'y')
  );

  if uzatvorit then begin
    // vypocitam body (leziace na kruznici), ktore urcuju start/stop obluka
    // (podla rovnice kruznice X = A + r*cos ALFA ; Y = B + r*sin BETA)
    startPoint.X := stred.X + ( polomer * uholStartCos );
    startPoint.Y := stred.Y + ( polomer * uholStartSin );
    endPoint.X   := stred.X + ( polomer * uholEndCos );
    endPoint.Y   := stred.Y + ( polomer * uholEndSin );

    BackPlane.Canvas.MoveTo( PX(startPoint.X, 'x'), PX(startPoint.Y, 'y') );
    BackPlane.Canvas.LineTo( PX(endPoint.X, 'x'), PX(endPoint.Y, 'y') );
  end;
end;



function  TextWidth(txt: string; velkost: double; qpfont: TMyFont): double;
var
  i: Integer;
  indexZnaku: Integer;
  sizeFaktor: double;
begin
  sizeFaktor := velkost / 10;
	Result := 0;

	for i := 1 to Length(txt) do begin
  	indexZnaku := Ord(Char(txt[i]));
    if Assigned(qpfont.Items[indexZnaku]) then begin // ak taky znak pozna, pripocita jeho sirku
    	Result := Result + ((qpfont[indexZnaku].sirkaZnaku + qpfont[indexZnaku].sirkaMedzery) * sizeFaktor);
    end else begin
      // ak taky znak nepozna,....
      Result := Result + (sirkaNeznamehoZnaku * sizeFaktor);
    end;
  end;
	// od posledneho znaku odpocita sirku medzery za nim - tu uz nam netreba
  if Result > 0 then
  	Result := Result - (qpfont[indexZnaku].sirkaMedzery * sizeFaktor);
end;

procedure Text(txt: string; bodVlozenia: TMyPoint; velkost, celkova_sirka: double; typVelkosti, zarovnanie: string; farba: TColor; nastroj: double; FontTextu: TMyFont; rotacia: Double = 0);
var
  posunX, posunY: integer;
  i,j,x,y: integer;
  vyslednyBod: TPoint;
  stredRotacie: TPoint;
  offsetPX: integer;
  sizeFaktor: double;
  indexZnaku: integer;
begin
  offsetPX := 0;

  if zarovnanie = taCenter then   // zarovnaj na stred
    posunX := -PX(celkova_sirka / 2);
  if zarovnanie = taRight then    // zarovnaj doprava
    posunX := 0;
  if zarovnanie = taLeft then     // zarovnaj dolava
    posunX := -PX(celkova_sirka);

  posunY := PX(velkost / 2);

  //velkost := velkost - nastroj; // aby SKUTOCNA velkost textu nebola zvacsena o priemer nastroja    EDIT: vypnute, lebo sa menila tym padom aj sirka textu (podla toho aky gravir bol zvoleny) a to asi nem dobre
  sizeFaktor := velkost / 10;

  x := PX(bodVlozenia.X,'x') + posunX;
  y := PX(bodVlozenia.Y,'y') + posunY;

  if rotacia <> 0 then begin
    stredRotacie.X := PX(bodVlozenia.X,'x');
    stredRotacie.Y := PX(bodVlozenia.Y,'y');
  end;

  BackPlane.Canvas.Pen.Style   := psSolid;
  BackPlane.Canvas.Pen.Color   := farba;
  BackPlane.Canvas.Pen.Width   := PX(nastroj);

	for i := 1 to Length(txt) do begin
  	indexZnaku := Ord(Char(txt[i]));

    if (indexZnaku > FontTextu.Capacity) OR (not Assigned(FontTextu.Items[indexZnaku])) then
    	indexZnaku := Ord(Char('?')); // ak taky znak nepozna, vykresli '?'

    for j := 0 to Length(FontTextu.Znaky[indexZnaku].Points)-1 do begin

      vyslednyBod.X := x + offsetPX + PX( FontTextu.Znaky[indexZnaku].Points[j].bod.X * sizeFaktor );
      vyslednyBod.Y := y - PX( FontTextu.Znaky[indexZnaku].Points[j].bod.Y * sizeFaktor );

      if rotacia <> 0 then begin
        vyslednyBod := RotujBodOkoloBoduPX(vyslednyBod, stredRotacie, rotacia);
      end;

      if FontTextu.Znaky[indexZnaku].Points[j].kresli then
        BackPlane.Canvas.LineTo(vyslednyBod.X , vyslednyBod.Y)
      else
        BackPlane.Canvas.MoveTo(vyslednyBod.X , vyslednyBod.Y);

    end;
    offsetPX := offsetPX + PX((FontTextu.Znaky[indexZnaku].sirkaZnaku  + FontTextu.Znaky[indexZnaku].sirkaMedzery) * sizeFaktor);
  end;
{
  // nastavenie velkosti pisma
  BackPlane.Canvas.Font.Size := 1;
  if typVelkosti = 'WIDTHALL' then
    while BackPlane.Canvas.TextWidth(txt) < PX(velkost) do
      BackPlane.Canvas.Font.Size := BackPlane.Canvas.Font.Size + 1
  else
    BackPlane.Canvas.Font.Size := PX(velkost);

  // nastavenie zarovnania v X
  posunX := 0;
  if zarovnanie = '0' then   // 0 = zarovnaj na stred
    posunX := Round( BackPlane.Canvas.TextWidth(txt) / 2 );
  if zarovnanie = '2' then   // 2 = zarovnaj dolava
    posunX := BackPlane.Canvas.TextWidth(txt);
  // nastavenie zarovnania v Y
  posunY := Round( BackPlane.Canvas.TextHeight(txt) / 2 );
}
end;


procedure Text_old(txt: string; bodVlozenia: TMyPoint; velkost: double; typVelkosti, zarovnanie: string; farba: TColor);
var
  posunX, posunY: integer;
begin
  BackPlane.Canvas.Brush.Style := bsClear;
  BackPlane.Canvas.Pen.Color   := farba;
  BackPlane.Canvas.Font.Name   := 'Simplex';
  BackPlane.Canvas.Font.Color  := farba;

  // nastavenie velkosti pisma
  BackPlane.Canvas.Font.Size := 1;
  if typVelkosti = 'WIDTHALL' then
    while BackPlane.Canvas.TextWidth(txt) < PX(velkost) do
      BackPlane.Canvas.Font.Size := BackPlane.Canvas.Font.Size + 1
  else
    BackPlane.Canvas.Font.Size := PX(velkost);

  // nastavenie zarovnania v X
  posunX := 0;
  if zarovnanie = '0' then   // 0 = zarovnaj na stred
    posunX := Round( BackPlane.Canvas.TextWidth(txt) / 2 );
  if zarovnanie = '2' then   // 2 = zarovnaj dolava
    posunX := BackPlane.Canvas.TextWidth(txt);
  // nastavenie zarovnania v Y
  posunY := Round( BackPlane.Canvas.TextHeight(txt) / 2 );

  // vykreslenie
  BackPlane.Canvas.TextOut( PX(bodVlozenia.X,'x')-posunX, PX(bodVlozenia.Y,'y')-posunY, txt );
end;

function  ZrkadliUhol(uhol: double; OkoloOsi: char = 'y'): double;
begin
(*
    if (OkoloOsi = 'y') then begin

      if (Uhol >= 0) AND (Uhol < 90) then
        result := 90 + (90 - Uhol);
      if (Uhol >= 90) AND (Uhol < 180) then
        result := 90 - (Uhol - 90);
      if (Uhol >= 180) AND (Uhol < 270) then
        result := 270 + (270 - Uhol);
      if (Uhol >= 270) AND (Uhol < 360) then
        result := 270 - (Uhol - 270);

    end else begin
    end;

*)
        result := uhol;
end;


function CiaraOffset(zaciatok: TMyPoint; koniec: TMyPoint; strana: char; distance: double): TMyPoint2D;
var
  uhol, dx, dy: double;
begin
  if koniec.X = zaciatok.X then begin
    if (koniec.Y > zaciatok.Y) then uhol := DegToRad(90)
    else uhol := DegToRad(270);
  end else
    uhol := ArcTan((koniec.Y-zaciatok.Y) / (koniec.X-zaciatok.X));

  dx := sin( uhol ) * distance;
  dy := cos( uhol ) * distance;
  if strana = 'L' then begin
    dx := -dx;
    dy := -dy;
  end;
//  showmessage('['+floattostr(zaciatok.X)+','+floattostr(zaciatok.Y)+']...['+floattostr(koniec.X)+','+floattostr(koniec.Y)+'] o '+ floattostr(distance)+' uhlom '+floattostr(radtodeg(uhol))+' = ' + floattostr(dx)+','+floattostr(dy));
  result.first.X  := zaciatok.X + dx;
  result.first.Y  := zaciatok.Y - dy;
  result.second.X := koniec.X + dx;
  result.second.Y := koniec.Y - dy;
end;

procedure CiaraOffset2(var usecka: TMyPoint2D; strana: char; distance: double);
begin
  // iny sposob volania funkcie na offset ciary - da sa takto volat aj s parametrom, ktorym je premenna
  usecka := CiaraOffset(usecka.first, usecka.second, strana, distance);
end;


begin


end.
