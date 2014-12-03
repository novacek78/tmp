unit uObjectFeature;

interface

uses uMyTypes, Classes, Math, Graphics, Types, SysUtils, ShellAPI, Windows;

type
  TFeatureObject = class(TObject)
  private
    objID: integer;
    objComboID: integer; // -1 znamena, ze nie je clenom ziadneho comba
    objTyp: integer;
    objPoloha: TMyPoint;
    objRozmer1: Double;
    objRozmer2: Double;
    objRozmer3: Double;
    objRozmer4: Double;
    objRozmer5: Double;
    objParam1: string;
    objParam2: string;
    objParam3: string;
    objParam4: string;
    objParam5: string;  // pouzite (ako prve) u grav.textov ako nazov fontu
    objHlbka1: Double;
    objFarba: TColor;
    objNatocenie: Double;
    objNazov: string;
    objBoundingRect: TMyRect;
    objSelected: boolean;
    objHighlighted: Boolean;  // toto je ine ako SELECTED, lebo to len vyfarbi objekt inou farbou ked sa napr. vybera spomedzi viacerych aby ho odlisilo
    objStrana: byte; // na ktorej strane je prvok umiestneny (1=predna strana, 2=zadna strana)
    objLocked: boolean;
    objRodic: TObject;
    procedure setTyp(typ: integer);
    procedure setPoloha(p: TMyPoint);
    procedure setX(x: Double);
    procedure setY(y: Double);
    procedure setRozmer1(r: Double);
    procedure setRozmer2(r: Double);
    procedure setRozmer3(r: Double);
    procedure setRozmer4(r: Double);
    procedure setRozmer5(r: Double);
    procedure setParam1(p: string);
    procedure setParam2(p: string);
    procedure setParam3(p: string);
    procedure setParam4(p: string);
    procedure setParam5(p: string);
    procedure setSelected(sel: boolean);
    procedure setLocked(lock: boolean);
  published
    constructor Create(rodicPanel: TObject; stranaPanela: integer = -1; typPrvku: Integer = -1);
// === kazdu novu property zapisat aj do COPYFROM metody !!! ===  (aj do ukladania do suboru, do ukladania comba a do nahravania tychto veci tiez)
    property ID: integer read objID write objID;
    property ComboID: integer read objComboID write objComboID;
    property Typ: integer read objTyp write setTyp;
    property BoundingBox: TMyRect read objBoundingRect write objBoundingRect;
    property Poloha: TMyPoint read objPoloha write setPoloha;
// === kazdu novu property zapisat aj do COPYFROM metody !!! ===  (aj do ukladania do suboru, do ukladania comba a do nahravania tychto veci tiez)
    property X: double read objPoloha.X write setX;
    property Y: double read objPoloha.Y write setY;
    property Rozmer1: Double read objRozmer1 write setRozmer1;
    property Rozmer2: Double read objRozmer2 write setRozmer2;
    property Rozmer3: Double read objRozmer3 write setRozmer3;
    property Rozmer4: Double read objRozmer4 write setRozmer4;
    property Rozmer5: Double read objRozmer5 write setRozmer5;
// === kazdu novu property zapisat aj do COPYFROM metody !!! ===  (aj do ukladania do suboru, do ukladania comba a do nahravania tychto veci tiez)
    property Param1: string read objParam1 write setParam1;
    property Param2: string read objParam2 write setParam2;
    property Param3: string read objParam3 write setParam3;
    property Param4: string read objParam4 write setParam4;
    property Param5: string read objParam5 write setParam5;
// === kazdu novu property zapisat aj do COPYFROM metody !!! ===  (aj do ukladania do suboru, do ukladania comba a do nahravania tychto veci tiez)
    property Hlbka1: Double read objHlbka1 write objHlbka1;
    property Farba: TColor read objFarba write objFarba;
    property Natocenie: Double read objNatocenie write objNatocenie;
    property Nazov: string read objNazov write objNazov;
    property Selected: boolean read objSelected write setSelected;
    property Highlighted: boolean read objHighlighted write objHighlighted;
    property Strana: byte read objStrana write objStrana;
    property Locked: boolean read objLocked write setLocked;
// === kazdu novu property zapisat aj do COPYFROM metody !!! ===  (aj do ukladania do suboru, do ukladania comba a do nahravania tychto veci tiez)

		procedure Inicializuj;
    procedure AdjustBoundingBox;
    procedure Draw_Blind;
    procedure Draw_Cosmetic;
    procedure Draw_CosmeticLowPriority;
    procedure Draw_CosmeticHighPriority;
    procedure Draw_Through;
    procedure DrawSelected;
    procedure DrawHighlighted;
    procedure StartEditing;
    function  GetFeatureInfo(withID: boolean = false; withPosition: boolean = false; exploded: boolean = false): string;
    function  IsOnPoint(bod_MM: TMyPoint): boolean;
    procedure CopyFrom(src: TFeatureObject);
    procedure MirrorFeature(var parentPanel: TObject; smer: char = 'x');
end;

implementation

uses uMain, uConfig, uFeaHole, uFeaPocket, uFeaThread, uFeaEngrave,
  uFeaConus, uDebug, uFeaGroove, uDrawLib, uTranslate,
  uObjectFeaturePolyLine, uObjectPanel, uObjectFont, uFeaCosmetic;

constructor TFeatureObject.Create(rodicPanel: TObject; stranaPanela: integer = -1; typPrvku: Integer = -1);
begin
  inherited Create;
  objRodic     := rodicPanel;
  objComboID   := -1; // -1 znamena, ze nie je clenom ziadneho comba
  objTyp       := typPrvku;
  objPoloha.X  := 0;
  objPoloha.Y  := 0;
  objRozmer1   := -1;
  objRozmer2   := -1;
  objRozmer3   := -1;
  objRozmer4   := -1;
  objRozmer5   := -1;
  objHlbka1    := -1;
  objNatocenie :=  0;
  objFarba     := -1;

  // gravirovanemu textu dame defaultne prvy font co sa najde nahraty v paneli
  if (objTyp = ftTxtGrav) AND (objParam5 = '') then
    objParam5 := (objRodic as TPanelObject).Fonty[0];

  // gravirovanemu textu dame defaultne nulove natocenie
  if (objTyp = ftTxtGrav) then
    objRozmer2 := 0;

  if (stranaPanela = -1) then begin // ak nie je zadefinovane, na ktorej strane panela ho mam vytvorit...
  	if (Assigned(objRodic)) then // ...ak je zadefinovany rodic prvku (panel) tak podla neho...
  		objStrana := TPanelObject(objRodic).StranaVisible  // na ktorej strane je prvok umiestneny (1=predna strana, 2=zadna strana)
    else
    	objStrana := 1; // ...ak nie je rodicovsky panel definovany, standardne ho vytvorim na prednej strane...
  end else
  	objStrana := stranaPanela; // ...ak je zadefinovana strana explicitne, priradim ju.

  objSelected  := false;
  objLocked    := false;
end;

procedure TFeatureObject.Inicializuj;
var
  FontTextu: TMyFont;
  temp_vyska: double;
begin
  // ******** uvodne inicializacne veci po vytvoreni prvku (ale nie len) ******************

  // pri gravirovanom texte dopocitame celkovu sirku textu / vysku textu (podla toho, co uzivatel zadal a co treba dopocitat)
  // tuto vypocitanu hodnotu ulozime do nepouziteho ObjRozmer4
  if (objTyp = ftTxtGrav) then begin
  	if (objParam1 <> '') AND (objParam5 <> '') then begin

      FontTextu := TMyFont(TPanelObject(objRodic).Fonty.Objects[ TPanelObject(objRodic).Fonty.IndexOf( objParam5 ) ]); // param5 = font name
      if objParam2 = 'HEIGHT' then begin
        objRozmer4 := FontTextu.ZistiSirkuTextu(objParam1, objRozmer1);
      end;
      if objParam2 = 'WIDTHALL' then begin
      	// hladanie zacneme od textu s nejakou minimalnou vyskou
      	temp_vyska := 0.5;
        // najprv hrubsie hladanie
        while FontTextu.ZistiSirkuTextu(objParam1, temp_vyska) < objRozmer1 do
          temp_vyska := temp_vyska + 0.1;
        // este jeden prechod jemnejsi
        temp_vyska := temp_vyska - 0.1;
        while FontTextu.ZistiSirkuTextu(objParam1, temp_vyska) < objRozmer1 do
          temp_vyska := temp_vyska + 0.02;
        // najdenu vysku textu ulozime do vlastnosti daneho ficru
				objRozmer4 := temp_vyska;
      end;

      AdjustBoundingBox;
    end;
  end;

end;


procedure TFeatureObject.CopyFrom(src: TFeatureObject);
begin
  // ID sa nekopiruje !!! //
  objComboID := src.ComboID;
  objTyp := src.Typ;
  objBoundingRect := src.BoundingBox;
  objPoloha := src.Poloha;
  objRozmer1 := src.Rozmer1;
  objRozmer2 := src.Rozmer2;
  objRozmer3 := src.Rozmer3;
  objRozmer4 := src.Rozmer4;
  objRozmer5 := src.Rozmer5;
  objParam1 := src.Param1;
  objParam2 := src.Param2;
  objParam3 := src.Param3;
  objParam4 := src.Param4;
  objParam5 := src.Param5;
  objHlbka1 := src.Hlbka1;
  objFarba := src.Farba;
  objNatocenie := src.Natocenie;
  objNazov := src.Nazov;
  objSelected := src.Selected;
  objStrana   := src.Strana;
  objLocked   := src.Locked;

  // gravirovany text MUSI mat priradeny nejaky font. Ak nema, dame mu prvy co najdeme nahraty v paneli
  if (objTyp = ftTxtGrav) AND (objParam5 = '') then
    objParam5 := (objRodic as TPanelObject).Fonty[0];
end;

procedure TFeatureObject.setTyp(typ: integer);
begin
  objTyp := typ;
  // ak pozname typ prvku, nastavime nejake jeho default vlastnosti
  case objTyp of
    ftTxtGrav, ftLine2Grav, ftCircleGrav, ftRectGrav, ftPolyLineGrav: begin
      objParam4 := 'NOFILL';
    end;
  end;
end;
procedure TFeatureObject.setRozmer1(r: Double);
begin
  objRozmer1 := r;
  AdjustBoundingBox;
  if Assigned(objRodic) then TPanelObject(objRodic).HasChanged := true;
end;
procedure TFeatureObject.setRozmer2(r: Double);
begin
  objRozmer2 := r;
  AdjustBoundingBox;
  if Assigned(objRodic) then TPanelObject(objRodic).HasChanged := true;
end;
procedure TFeatureObject.setRozmer3(r: Double);
begin
  objRozmer3 := r;
  AdjustBoundingBox;
  if Assigned(objRodic) then TPanelObject(objRodic).HasChanged := true;
end;
procedure TFeatureObject.setRozmer4(r: Double);
begin
  objRozmer4 := r;
  AdjustBoundingBox;
  if Assigned(objRodic) then TPanelObject(objRodic).HasChanged := true;
end;
procedure TFeatureObject.setRozmer5(r: Double);
begin
  objRozmer5 := r;
  AdjustBoundingBox;
  if Assigned(objRodic) then TPanelObject(objRodic).HasChanged := true;
end;
procedure TFeatureObject.setSelected(sel: boolean);
begin
  if (not objLocked) then
    objSelected := sel;
end;

procedure TFeatureObject.setLocked(lock: boolean);
begin
  if (objSelected) AND (lock) then
    objSelected := false;
  objLocked := lock;
  if Assigned(objRodic) then TPanelObject(objRodic).HasChanged := true;
end;

procedure TFeatureObject.setParam1(p: string);
begin
  objParam1 := p;
  if Assigned(objRodic) then TPanelObject(objRodic).HasChanged := true;
  AdjustBoundingBox;
end;
procedure TFeatureObject.setParam2(p: string);
begin
  objParam2 := p;
  if Assigned(objRodic) then TPanelObject(objRodic).HasChanged := true;
end;
procedure TFeatureObject.setParam3(p: string);
begin
  objParam3 := p;
  if Assigned(objRodic) then TPanelObject(objRodic).HasChanged := true;
end;
procedure TFeatureObject.setParam4(p: string);
begin
  objParam4 := p;
  case objTyp of
    ftTxtGrav, ftLine2Grav, ftCircleGrav, ftRectGrav, ftPolyLineGrav: begin
      if (objParam4 = '') then objParam4 := 'NOFILL';
    end;
  end;
  if Assigned(objRodic) then TPanelObject(objRodic).HasChanged := true;
end;

procedure TFeatureObject.setParam5(p: string);
begin
  objParam5 := p;
  if Assigned(objRodic) then TPanelObject(objRodic).HasChanged := true;
end;

procedure TFeatureObject.setPoloha(p: TMyPoint);
begin
  objPoloha := p;
  AdjustBoundingBox;
  if Assigned(objRodic) then TPanelObject(objRodic).HasChanged := true;
end;
procedure TFeatureObject.setX(x: double);
begin
  objPoloha.X := x;
  AdjustBoundingBox;
  if Assigned(objRodic) then TPanelObject(objRodic).HasChanged := true;
end;
procedure TFeatureObject.setY(y: double);
begin
  objPoloha.Y := y;
  AdjustBoundingBox;
  if Assigned(objRodic) then TPanelObject(objRodic).HasChanged := true;
end;

procedure TFeatureObject.AdjustBoundingBox;
var
  i: integer;
  txt_off_x, txt_off_y: double;
  ang1, ang2: double;
  bodyLave, bodyPrave: TMyPoint2D;
begin
  if Assigned(objRodic) then
    TPanelObject(objRodic).CurrentSide := objStrana
  else
    Exit;

  case objTyp of
    ftHoleCirc, ftPocketCirc, ftCosmeticCircle: begin
      objBoundingRect.TopL.X := objPoloha.X - (objRozmer1/2) - objRozmer5 - rozsirenieBoxu;
      objBoundingRect.TopL.Y := objPoloha.Y + (objRozmer1/2) + objRozmer5 + rozsirenieBoxu;
      objBoundingRect.BtmR.X := objPoloha.X + (objRozmer1/2) + objRozmer5 + rozsirenieBoxu;
      objBoundingRect.BtmR.Y := objPoloha.Y - (objRozmer1/2) - objRozmer5 - rozsirenieBoxu;
    end;

    ftThread, ftCircleGrav, ftSink, ftSinkSpecial, ftSinkCyl: begin
      objBoundingRect.TopL.X := objPoloha.X - (objRozmer1/2) - rozsirenieBoxu;
      objBoundingRect.TopL.Y := objPoloha.Y + (objRozmer1/2) + rozsirenieBoxu;
      objBoundingRect.BtmR.X := objPoloha.X + (objRozmer1/2) + rozsirenieBoxu;
      objBoundingRect.BtmR.Y := objPoloha.Y - (objRozmer1/2) - rozsirenieBoxu;
    end;

    ftHoleRect, ftPocketRect, ftCosmeticRect: begin
      objBoundingRect.TopL.X := objPoloha.X - (objRozmer1/2) - objRozmer5 - rozsirenieBoxu;
      objBoundingRect.TopL.Y := objPoloha.Y + (objRozmer2/2) + objRozmer5 + rozsirenieBoxu;
      objBoundingRect.BtmR.X := objPoloha.X + (objRozmer1/2) + objRozmer5 + rozsirenieBoxu;
      objBoundingRect.BtmR.Y := objPoloha.Y - (objRozmer2/2) - objRozmer5 - rozsirenieBoxu;
    end;

    ftRectGrav: begin
      objBoundingRect.TopL.X := objPoloha.X - (objRozmer1/2) - rozsirenieBoxu;
      objBoundingRect.TopL.Y := objPoloha.Y + (objRozmer2/2) + rozsirenieBoxu;
      objBoundingRect.BtmR.X := objPoloha.X + (objRozmer1/2) + rozsirenieBoxu;
      objBoundingRect.BtmR.Y := objPoloha.Y - (objRozmer2/2) - rozsirenieBoxu;
    end;

    ftTxtGrav: begin
      if objParam2 = 'HEIGHT' then begin
        if objParam3 = taCenter then   // zarovnaj na stred
          txt_off_x := objRozmer4 / 2;
        if objParam3 = taRight then    // zarovnaj doprava
          txt_off_x := 0;
        if objParam3 = taLeft then     // zarovnaj dolava
          txt_off_x := objRozmer4;

        txt_off_y := objRozmer1 / 2;

        objBoundingRect.TopL.X := objPoloha.X - txt_off_x - rozsirenieBoxu;
        objBoundingRect.TopL.Y := objPoloha.Y + txt_off_y + rozsirenieBoxu;
        objBoundingRect.BtmR.X := objPoloha.X + objRozmer4 - txt_off_x + rozsirenieBoxu;
        objBoundingRect.BtmR.Y := objPoloha.Y - objRozmer1 + txt_off_y - rozsirenieBoxu;
      end;
      if objParam2 = 'WIDTHALL' then begin
        if objParam3 = taCenter then   // zarovnaj na stred
          txt_off_x := objRozmer1 / 2;
        if objParam3 = taRight then    // zarovnaj doprava
          txt_off_x := 0;
        if objParam3 = taLeft then     // zarovnaj dolava
          txt_off_x := objRozmer1;

        txt_off_y := objRozmer4 / 2;

        objBoundingRect.TopL.X := objPoloha.X - txt_off_x - rozsirenieBoxu;
        objBoundingRect.TopL.Y := objPoloha.Y + txt_off_y + rozsirenieBoxu;
        objBoundingRect.BtmR.X := objPoloha.X + objRozmer1 - txt_off_x + rozsirenieBoxu;
        objBoundingRect.BtmR.Y := objPoloha.Y - objRozmer4 + txt_off_y - rozsirenieBoxu;
      end;

      // este prepocet boxu ak je text rotovany
      if (objRozmer2 <> 0) then begin
        // potrebujem vediet vsetky 4 ohranicovacie body textu - z nich budem skladat vysledny box
        // TopLeft a BottomRight su uz vypocitane...
        bodyLave.first := objBoundingRect.TopL;
        bodyPrave.second := objBoundingRect.BtmR;
        // no a dalsie dva si odvodim z nich:
        bodyLave.second.X := bodyLave.first.X;
        bodyLave.second.Y := objBoundingRect.BtmR.Y;
        bodyPrave.first.X := bodyPrave.second.X;
        bodyPrave.first.Y := objBoundingRect.TopL.Y;
        // teraz ich zrotujeme na dany uhol
        bodyLave.first   := uDrawLib.RotujBodOkoloBoduMM( bodyLave.first, objPoloha, objRozmer2);
        bodyLave.second  := uDrawLib.RotujBodOkoloBoduMM( bodyLave.second, objPoloha, objRozmer2);
        bodyPrave.first  := uDrawLib.RotujBodOkoloBoduMM( bodyPrave.first, objPoloha, objRozmer2);
        bodyPrave.second := uDrawLib.RotujBodOkoloBoduMM( bodyPrave.second, objPoloha, objRozmer2);
        // a teraz z nich vyskladam vysledny bounding box
        if objRozmer2 <= 90 then begin
          objBoundingRect.TopL.X := bodyLave.first.X;
          objBoundingRect.TopL.Y := bodyPrave.first.Y;
          objBoundingRect.BtmR.X := bodyPrave.second.X;
          objBoundingRect.BtmR.Y := bodyLave.second.Y;
        end else if objRozmer2 <= 180 then begin
          objBoundingRect.TopL.X := bodyPrave.first.X;
          objBoundingRect.TopL.Y := bodyPrave.second.Y;
          objBoundingRect.BtmR.X := bodyLave.second.X;
          objBoundingRect.BtmR.Y := bodyLave.first.Y;
        end else if objRozmer2 <= 270 then begin
          objBoundingRect.TopL.X := bodyPrave.second.X;
          objBoundingRect.TopL.Y := bodyLave.second.Y;
          objBoundingRect.BtmR.X := bodyLave.first.X;
          objBoundingRect.BtmR.Y := bodyPrave.first.Y;
        end else if objRozmer2 <= 360 then begin
          objBoundingRect.TopL.X := bodyLave.second.X;
          objBoundingRect.TopL.Y := bodyLave.first.Y;
          objBoundingRect.BtmR.X := bodyPrave.first.X;
          objBoundingRect.BtmR.Y := bodyPrave.second.Y;
        end;
      end;

    end;

    ftLine2Grav: begin
      objBoundingRect.TopL.X := Min(objPoloha.X, (objPoloha.X+objRozmer1)) - rozsirenieBoxu;
      objBoundingRect.TopL.Y := Max(objPoloha.Y, (objPoloha.Y+objRozmer2)) + rozsirenieBoxu;
      objBoundingRect.BtmR.X := Max(objPoloha.X, (objPoloha.X+objRozmer1)) + rozsirenieBoxu;
      objBoundingRect.BtmR.Y := Min(objPoloha.Y, (objPoloha.Y+objRozmer2)) - rozsirenieBoxu;
    end;

    ftGrooveLin: begin
      objBoundingRect.TopL.X := Min(objPoloha.X, (objPoloha.X+objRozmer1)) - (objRozmer3/2) - rozsirenieBoxu;
      objBoundingRect.TopL.Y := Max(objPoloha.Y, (objPoloha.Y+objRozmer2)) + (objRozmer3/2) + rozsirenieBoxu;
      objBoundingRect.BtmR.X := Max(objPoloha.X, (objPoloha.X+objRozmer1)) + (objRozmer3/2) + rozsirenieBoxu;
      objBoundingRect.BtmR.Y := Min(objPoloha.Y, (objPoloha.Y+objRozmer2)) - (objRozmer3/2) - rozsirenieBoxu;
    end;

    ftGrooveArc: begin
      objBoundingRect.TopL := MyPoint(9999 , -9999);
      objBoundingRect.BtmR := MyPoint(-9999 , 9999);
      // najjednoduchsi sposob - prejst po celej drahe obluka a najst max/minima
      ang1 := objRozmer2;
      ang2 := objRozmer3;
      if ang2 < ang1 then ang2 := ang2+360;
      for i:=Round(ang1) to Round(ang2) do begin
        objBoundingRect.TopL.X := Min(
          objBoundingRect.TopL.X,
          objPoloha.X + ( (objRozmer1/2) * cos(DegToRad(i)) )
        );
        objBoundingRect.TopL.Y := Max(
          objBoundingRect.TopL.Y,
          objPoloha.Y + ( (objRozmer1/2) * sin(DegToRad(i)) )
        );
        objBoundingRect.BtmR.X := Max(
          objBoundingRect.BtmR.X,
          objPoloha.X + ( (objRozmer1/2) * cos(DegToRad(i)) )
        );
        objBoundingRect.BtmR.Y := Min(
          objBoundingRect.BtmR.Y,
          objPoloha.Y + ( (objRozmer1/2) * sin(DegToRad(i)) )
        );
      end; // for
      objBoundingRect.TopL.X := objBoundingRect.TopL.X - (objRozmer4/2) - rozsirenieBoxu;
      objBoundingRect.TopL.Y := objBoundingRect.TopL.Y + (objRozmer4/2) + rozsirenieBoxu;
      objBoundingRect.BtmR.X := objBoundingRect.BtmR.X + (objRozmer4/2) + rozsirenieBoxu;
      objBoundingRect.BtmR.Y := objBoundingRect.BtmR.Y - (objRozmer4/2) - rozsirenieBoxu;
    end;

  end;
end;


{
Zabezpecuje vykreslenie samotneho objektu - konkretne tych casti objektov, ktore su slepe - nejdu skrz panel
}
procedure TFeatureObject.Draw_Blind;
var
  farVypln, farOkolo: TColor;
  isOnBackSide: boolean;
  QPFont: TMyFont;
begin
//  if objHlbka1 = 9999 then Exit; // nemoze to tu byt, lebo by sa nevykreslili kuzelove a valcove zahlbenia okolo dier


  BackPlane.Canvas.Brush.Style := bsSolid;
  BackPlane.Canvas.Pen.Style := psSolid;

  isOnBackSide := objStrana <> _PNL.StranaVisible;
  // ak je prvok na zadnej strane, musi sa vykreslovat podla zadneho nul.bodu
  _PNL.CurrentSide := objStrana;


  case objTyp of

    ////////////////// kruhova kapsa
    ftPocketCirc: begin
      if isOnBackSide then begin
        KruzObvod(objPoloha, ObjRozmer1, farbaOtherSideContours, 1, psDash);
      end else begin
        KruzPlocha(objPoloha, objRozmer1, farbaKapsaPlocha, farbaObvod);
      end;
    end;

    /////////////////// obdlznikova kapsa
    ftPocketRect: begin
      if isOnBackSide then begin
        ObdlzObvod(objPoloha, ObjRozmer1, objRozmer2, objRozmer3, farbaOtherSideContours, 1, psDash);
      end else begin
        ObdlzPlocha(objPoloha, objRozmer1, objRozmer2, objRozmer3, objRozmer4, farbaKapsaPlocha, farbaObvod);
      end;
    end;

    /////////////////// zavit
    ftThread: begin
      if isOnBackSide then begin
        KruzObvod(objPoloha, objRozmer1*0.83, farbaOtherSideContours, 1, psDash);
      end else begin
        KruzPlocha(objPoloha, objRozmer1*0.83, farbaKapsaPlocha, farbaObvod);
      end;
    end;

    /////////////////// text
    ftTxtGrav: begin
      if (not isOnBackSide) then begin
        if objParam4 = 'NOFILL' then farVypln := farbaGravirSurovy;
        if objParam4 = 'BLACK'  then farVypln := clBlack;
        if objParam4 = 'WHITE'  then farVypln := clWhite;
        if objParam4 = 'RED'    then farVypln := clRed;
        if objParam4 = 'GREEN'  then farVypln := farbaOtherSideContours;
        if objParam4 = 'BLUE'   then farVypln := clBlue;
        //Text_old(objParam1, objPoloha, objRozmer1, objParam2, objParam3, farVypln);

        QPFont := TMyFont(TPanelObject(objRodic).Fonty.Objects[ TPanelObject(objRodic).Fonty.IndexOf( objParam5 ) ]); // param5 = font name

        if objParam2 = 'HEIGHT' then begin
          if (objRozmer3 < 1) then
            Text(objParam1, objPoloha, objRozmer1, objRozmer4, objParam2, objParam3, farVypln, objRozmer3+rozsirenieGravira, QPFont, objRozmer2) // pri gravirovani grav.hrotmi (predpokladam, ze pod 1mm su vsetko len grav.hroty) rozsirim trosku stopu aby sa to priblizilo realu
          else
            Text(objParam1, objPoloha, objRozmer1, objRozmer4, objParam2, objParam3, farVypln, objRozmer3, QPFont, objRozmer2);
        end else if objParam2 = 'WIDTHALL' then begin
          if (objRozmer3 < 1) then
            Text(objParam1, objPoloha, objRozmer4, objRozmer1, objParam2, objParam3, farVypln, objRozmer3+rozsirenieGravira, QPFont, objRozmer2) // pri gravirovani grav.hrotmi (predpokladam, ze pod 1mm su vsetko len grav.hroty) rozsirim trosku stopu aby sa to priblizilo realu
          else
            Text(objParam1, objPoloha, objRozmer4, objRozmer1, objParam2, objParam3, farVypln, objRozmer3, QPFont, objRozmer2);
        end;

      end;
    end;

    /////////////////// gravirovana ciara
    ftLine2Grav: begin
      if (not isOnBackSide) then begin
        if objParam4 = 'NOFILL' then farVypln := farbaGravirSurovy;
        if objParam4 = 'BLACK'  then farVypln := clBlack;
        if objParam4 = 'WHITE'  then farVypln := clWhite;
        if objParam4 = 'RED'    then farVypln := clRed;
        if objParam4 = 'GREEN'  then farVypln := farbaOtherSideContours;
        if objParam4 = 'BLUE'   then farVypln := clBlue;
        // pri gravirovani grav.hrotmi (predpokladam, ze pod 1mm su vsetko len grav.hroty) rozsirim trosuk stopu aby sa to priblizilo realu
        if (objRozmer3 < 1) then
	        Ciara( objPoloha, MyPoint(objPoloha.X+objRozmer1, objPoloha.Y+objRozmer2), farVypln, objRozmer3+rozsirenieGravira )
        else
	        Ciara( objPoloha, MyPoint(objPoloha.X+objRozmer1, objPoloha.Y+objRozmer2), farVypln, objRozmer3 );
      end;
    end;

    /////////////////// gravirovany obdlznik
    ftRectGrav: begin
      if (not isOnBackSide) then begin
        if objParam4 = 'NOFILL' then farVypln := farbaGravirSurovy;
        if objParam4 = 'BLACK'  then farVypln := clBlack;
        if objParam4 = 'WHITE'  then farVypln := clWhite;
        if objParam4 = 'RED'    then farVypln := clRed;
        if objParam4 = 'GREEN'  then farVypln := farbaOtherSideContours;
        if objParam4 = 'BLUE'   then farVypln := clBlue;
        // pri gravirovani grav.hrotmi (predpokladam, ze pod 1mm su vsetko len grav.hroty) rozsirim trosuk stopu aby sa to priblizilo realu
        if (objRozmer3 < 1) then
          ObdlzObvod( objPoloha, objRozmer1, objRozmer2, objRozmer4, farVypln, PX(objRozmer3+rozsirenieGravira) )
        else
        	ObdlzObvod( objPoloha, objRozmer1, objRozmer2, objRozmer4, farVypln, PX(objRozmer3) );
      end;
    end;

    /////////////////// gravirovana kruznica
    ftCircleGrav: begin   // engraved shapes
      if (not isOnBackSide) then begin
        if objParam4 = 'NOFILL' then farVypln := farbaGravirSurovy;
        if objParam4 = 'BLACK'  then farVypln := clBlack;
        if objParam4 = 'WHITE'  then farVypln := clWhite;
        if objParam4 = 'RED'    then farVypln := clRed;
        if objParam4 = 'GREEN'  then farVypln := farbaOtherSideContours;
        if objParam4 = 'BLUE'   then farVypln := clBlue;
        // pri gravirovani grav.hrotmi (predpokladam, ze pod 1mm su vsetko len grav.hroty) rozsirim trosuk stopu aby sa to priblizilo realu
        if (objRozmer3 < 1) then
          KruzObvod( objPoloha, objRozmer1, farVypln, PX(objRozmer3+rozsirenieGravira) )
        else
          KruzObvod( objPoloha, objRozmer1, farVypln, PX(objRozmer3) );
      end;
    end;

    /////////////////// zahlbenie kuzelove
    ftSink: begin
      // tu len kruh zahlbenia
      if isOnBackSide then begin
        KruzObvod(objPoloha, objRozmer1, farbaOtherSideContours, 1, psDash);
      end else begin
        KruzPlocha( objPoloha, objRozmer1, farbaKapsaPlocha, farbaObvodZrazenaHrana );
      end;
    end;

    /////////////////// zahlbenie kuzelove specialne
    ftSinkSpecial: begin
    end;

    /////////////////// zahlbenie valcove
    ftSinkCyl: begin
      // tu len kruh zahlbenia
      if isOnBackSide then begin
        KruzObvod(objPoloha, objRozmer1, farbaOtherSideContours, 1, psDash);
      end else begin
        KruzPlocha( objPoloha, objRozmer1, farbaKapsaPlocha, farbaObvod );
      end;
    end;

    /////////////////// drazka rovna
    ftGrooveLin: begin
      if isOnBackSide then begin
        Ciara( objPoloha, MyPoint(objPoloha.X+objRozmer1, objPoloha.Y+objRozmer2), farbaOtherSideContours, MM(1), psDash);
      end else begin
        Ciara( objPoloha, MyPoint(objPoloha.X+objRozmer1, objPoloha.Y+objRozmer2), farbaKapsaPlocha, objRozmer3 );
      end;
    end;

    /////////////////// drazka obluk
    ftGrooveArc: begin
      if isOnBackSide then begin
        // pri kresleni obluka na opacnej strane ho musim ozrkadlit
        Obluk( objPoloha, objRozmer1, objRozmer2, objRozmer3, farbaOtherSideContours, 1, (objParam1 = 'S'), psDash );
      end else begin
        Obluk( objPoloha, objRozmer1, objRozmer2, objRozmer3, farbaKapsaPlocha, PX(objRozmer4), (objParam1 = 'S') );
      end;
    end;

  end; // case

end;


{
Zabezpecuje vykreslenie samotneho objektu - cosmetic prvky ale take, co budu prekryte inymi prvkami (zrazenia hran napr.)
}
procedure TFeatureObject.Draw_CosmeticLowPriority;
var
  farVypln, farOkolo: TColor;
  isOnBackSide: boolean;
  QPFont: TMyFont;
begin
  BackPlane.Canvas.Brush.Style := bsSolid;
  BackPlane.Canvas.Pen.Style := psSolid;

  isOnBackSide := objStrana <> _PNL.StranaVisible;
  // ak je prvok na zadnej strane, musi sa vykreslovat podla zadneho nul.bodu
  _PNL.CurrentSide := objStrana;


  case objTyp of

    ///////////////////// kruhova diera
    ftHoleCirc: begin
      if objRozmer5 > 0 then
        if isOnBackSide then
          KruzObvod(objPoloha, objRozmer1+(2*objRozmer5), clGreen, 1, psDash)
        else
          KruzObvod(objPoloha, objRozmer1+(2*objRozmer5), farbaObvodZrazenaHrana)
      else ;
    end;

    /////////////////// obdlznikova diera
    ftHoleRect: begin
      if objRozmer5 > 0 then
        if isOnBackSide then
          ObdlzObvod(objPoloha, objRozmer1+(2*objRozmer5), objRozmer2+(2*objRozmer5), objRozmer3+objRozmer5, clGreen, 1, psDash)
        else
          ObdlzObvod(objPoloha, objRozmer1+(2*objRozmer5), objRozmer2+(2*objRozmer5), objRozmer3+objRozmer5, farbaObvodZrazenaHrana)
      else
    end;

    ////////////////// kruhova kapsa
    ftPocketCirc: begin
      if isOnBackSide then begin
        if objRozmer5 > 0 then
          KruzObvod(objPoloha, objRozmer1+(2*objRozmer5), clGreen, 1, psDash);
      end else begin
        if objRozmer5 > 0 then
          KruzObvod(objPoloha, objRozmer1+(2*objRozmer5), farbaObvodZrazenaHrana);
      end;
    end;

    /////////////////// obdlznikova kapsa
    ftPocketRect: begin
      if isOnBackSide then begin
        if objRozmer5 > 0 then
          ObdlzObvod(objPoloha, objRozmer1+(2*objRozmer5), objRozmer2+(2*objRozmer5), objRozmer3+objRozmer5, clGreen, 1, psDash)
      end else begin
        if objRozmer5 > 0 then
          ObdlzObvod(objPoloha, objRozmer1+(2*objRozmer5), objRozmer2+(2*objRozmer5), objRozmer3+objRozmer5, farbaObvodZrazenaHrana);
      end;
    end;

  end; // case

end;


{
Zabezpecuje vykreslenie samotneho objektu - konkretne tych casti objektov, ktore idu durch cez cely panel
}
procedure TFeatureObject.Draw_Through;
var
  farVypln, farOkolo: TColor;
  isOnBackSide: boolean;
  QPFont: TMyFont;
begin
  if objHlbka1 < 9999 then Exit;

  BackPlane.Canvas.Brush.Style := bsSolid;
  BackPlane.Canvas.Pen.Style := psSolid;

  isOnBackSide := objStrana <> _PNL.StranaVisible;
  // ak je prvok na zadnej strane, musi sa vykreslovat podla zadneho nul.bodu
  _PNL.CurrentSide := objStrana;


  case objTyp of

    ///////////////////// kruhova diera
    ftHoleCirc: begin
      KruzPlocha(objPoloha, objRozmer1, _PNL.BgndCol, _PNL.BgndCol);
    end;

    /////////////////// obdlznikova diera
    ftHoleRect: begin
      ObdlzPlocha(objPoloha, objRozmer1, objRozmer2, objRozmer3, objRozmer4, _PNL.BgndCol, _PNL.BgndCol);
    end;

    /////////////////// zavit
    ftThread: begin
      KruzPlocha(objPoloha, objRozmer1*0.83, _PNL.BgndCol, _PNL.BgndCol);
      Obluk(objPoloha, objRozmer1, 80, 10, farbaZavity);
    end;

    /////////////////// zahlbenie kuzelove
    ftSink: begin
      KruzPlocha( objPoloha, objRozmer2, _PNL.BgndCol, _PNL.BgndCol );
    end;

    /////////////////// zahlbenie kuzelove specialne
    ftSinkSpecial: begin
    end;

    /////////////////// zahlbenie valcove
    ftSinkCyl: begin
      KruzPlocha( objPoloha, objRozmer2, _PNL.BgndCol, _PNL.BgndCol );
    end;

    /////////////////// drazka rovna
    ftGrooveLin: begin
      Ciara( objPoloha, MyPoint(objPoloha.X+objRozmer1, objPoloha.Y+objRozmer2), _PNL.BgndCol, objRozmer3 );
    end;

    /////////////////// drazka obluk
    ftGrooveArc: begin
      Obluk( objPoloha, objRozmer1, objRozmer2, objRozmer3, _PNL.BgndCol, PX(objRozmer4), (objParam1 = 'S') );
    end;

  end; // case

end;


{
Zabezpecuje vykreslenie samotneho objektu - konkretne tych casti objektov, ktore su len kozmeticke a maju byt stale viditelne - napr. 3/4 kruh okolo zavitu
}
procedure TFeatureObject.Draw_Cosmetic;
var
  farVypln, farOkolo: TColor;
  isOnBackSide: boolean;
  QPFont: TMyFont;
begin
  BackPlane.Canvas.Brush.Style := bsSolid;
  BackPlane.Canvas.Pen.Style := psSolid;

  isOnBackSide := objStrana <> _PNL.StranaVisible;
  // ak je prvok na zadnej strane, musi sa vykreslovat podla zadneho nul.bodu
  _PNL.CurrentSide := objStrana;


  case objTyp of

    /////////////////// zavit
    ftThread: begin
      if objHlbka1 < 9999 then // ak je zavit skrz, tak aj jeho cosmetic sa kresli s priechodzou dierou, lebo ho vidno z obidvoch stran
        if (isOnBackSide) then begin
          KruzObvod(objPoloha, objRozmer1*0.83, farbaOtherSideContours, 1, psDash);
          Obluk(objPoloha, objRozmer1, 80, 10, farbaOtherSideContours, 1, false, psDash);
        end else
          Obluk(objPoloha, objRozmer1, 80, 10, farbaZavity);
    end;

  end; // case

end;


procedure TFeatureObject.Draw_CosmeticHighPriority;
var
  farVypln, farOkolo: TColor;
  isOnBackSide: boolean;
  QPFont: TMyFont;
begin
  BackPlane.Canvas.Brush.Style := bsSolid;
  BackPlane.Canvas.Pen.Style := psSolid;

  isOnBackSide := objStrana <> _PNL.StranaVisible;
  // ak je prvok na zadnej strane, musi sa vykreslovat podla zadneho nul.bodu
  _PNL.CurrentSide := objStrana;

  case objTyp of

    /////////////////// cosmetic kruznica
    ftCosmeticCircle: begin
      KruzObvod(objPoloha, objRozmer1, objFarba, 2);
      with BackPlane.Canvas do begin
        Font.Size := 11;
        Font.Color := objFarba;
        TextOut(PX(objPoloha.X, 'x') - Round((TextWidth(objNazov)/2)), PX(objPoloha.Y, 'y'), objNazov);
      end;
    end;

    /////////////////// cosmetic obdlznik
    ftCosmeticRect: begin
      ObdlzObvod(objPoloha, objRozmer1, objRozmer2, objRozmer3, objFarba, 2);
      with BackPlane.Canvas do begin
        Font.Size := 11;
        Font.Color := objFarba;
        TextOut(PX(objPoloha.X, 'x') - Round((TextWidth(objNazov)/2)), PX(objPoloha.Y, 'y'), objNazov);
      end;
    end;

  end;
end;

{
Najprv vykresli konturu vybrateho objektu
a nasledne vykresli ciarkovane oramikovanie vybraneho objektu
}
procedure TFeatureObject.DrawSelected;
var
  comboBoundingRectMM: TMyRect;
  comboBoundingRectPX: TRect;
begin
  if not objSelected then Exit;

  _PNL.CurrentSide := objStrana;

  // vykreslime konturu objektu
  BackPlane.Canvas.Brush.Style := bsClear;
  BackPlane.Canvas.Pen.Style := psSolid;
  BackPlane.Canvas.Pen.Width := 1;

  case objTyp of

    ///////////////////// kruhova diera
    ftHoleCirc: begin
      KruzObvod(objPoloha, objRozmer1, farbaSelectedObvod)
    end;

    /////////////////// obdlznikova diera
    ftHoleRect: begin
      ObdlzObvod(objPoloha, objRozmer1, objRozmer2, objRozmer3, farbaSelectedObvod);
    end;

    ////////////////// kruhova kapsa
    ftPocketCirc: begin
      KruzObvod(objPoloha, objRozmer1, farbaSelectedObvod);
    end;

    /////////////////// obdlznikova kapsa
    ftPocketRect: begin
      ObdlzObvod(objPoloha, objRozmer1, objRozmer2, objRozmer3, farbaSelectedObvod);
    end;

    /////////////////// zavit
    ftThread: begin
      KruzObvod(objPoloha, objRozmer1*0.83, farbaSelectedObvod);
    end;

    /////////////////// text
    ftTxtGrav: begin
    end;

    /////////////////// gravirovana ciara
    ftLine2Grav: begin
      Ciara( objPoloha, MyPoint(objPoloha.X+objRozmer1, objPoloha.Y+objRozmer2), farbaSelectedObvod, 0.02 );
    end;

    /////////////////// gravirovany obdlznik
    ftRectGrav: begin
      ObdlzObvod( objPoloha, objRozmer1, objRozmer2, 0, farbaSelectedObvod );
    end;

    /////////////////// gravirovana kruznica
    ftCircleGrav: begin   // engraved shapes
      KruzObvod( objPoloha, objRozmer1, farbaSelectedObvod );
    end;

    /////////////////// zahlbenie kuzelove
    ftSink: begin
      // najprv kruh zahlbenia a nasledne kruh priechodzej diery
      KruzObvod( objPoloha, objRozmer1, farbaSelectedObvod );
      KruzObvod( objPoloha, objRozmer2, farbaSelectedObvod );
    end;

    /////////////////// zahlbenie kuzelove specialne
    ftSinkSpecial: begin
    end;

    /////////////////// zahlbenie valcove
    ftSinkCyl: begin
      // najprv kruh zahlbenia a nasledne kruh priechodzej diery
      KruzObvod( objPoloha, objRozmer1, farbaSelectedObvod );
      KruzObvod( objPoloha, objRozmer2, farbaSelectedObvod );
    end;

    /////////////////// drazka rovna
    ftGrooveLin: begin
      Ciara( objPoloha, MyPoint(objPoloha.X+objRozmer1, objPoloha.Y+objRozmer2), farbaSelectedObvod, 0.02 );
    end;

    /////////////////// drazka obluk
    ftGrooveArc: begin
      Obluk( objPoloha, objRozmer1, objRozmer2, objRozmer3, farbaSelectedObvod, 1, (objParam1 = 'S') );
    end;

  end; // case


  // vykreslenie indikacie vyselectovania - cerveny obdlznik okolo
  with BackPlane.Canvas do begin
    Brush.Style := bsClear;
    Pen.Style := psDash;
    Pen.Width := 1;
    // ina farba vyselectovania pri obyc.otvoroch a ina pri combo otvoroch
    if objComboID > -1 then begin
      Pen.Color := farbaSelectedBoundingBoxCombo;
      if Pos(','+IntToStr(objComboID)+',', _PNL.SelCombosDrawn) = 0 then begin
        comboBoundingRectMM := _PNL.GetComboBoundingBox(objComboID);
        comboBoundingRectPX.Left   := PX(comboBoundingRectMM.TopL.X, 'x')-2;
        comboBoundingRectPX.Right  := PX(comboBoundingRectMM.BtmR.X, 'x')+3;
        comboBoundingRectPX.Top    := PX(comboBoundingRectMM.TopL.Y, 'y')-2;
        comboBoundingRectPX.Bottom := PX(comboBoundingRectMM.BtmR.Y, 'y')+3;
        Rectangle( comboBoundingRectPX );
        // mnohonasobne vykreslenie obdlznika celeho comba (pri kazdom jeho komponente) je velmi zdlhave, takze:
        _PNL.SelCombosDrawn := _PNL.SelCombosDrawn + ','+IntToStr(objComboID)+','; //(vysvetlenie - vid deklaracia)
      end;
    end else begin
      Pen.Color := farbaSelectedBoundingBox;
      Rectangle(
        Px(objBoundingRect.TopL.X, 'x')-2,
        Px(objBoundingRect.TopL.Y, 'y')-2,
        Px(objBoundingRect.BtmR.X, 'x')+3,
        Px(objBoundingRect.BtmR.Y, 'y')+3
      );
    end;
  end; // with

end;


{
Vykresli objekt vo zvyraznenej farbe.
Nesluzi na oznacenie objektu, ked je vybraty, ale na zvyraznovanie napr. pocas multiselect prechadzania mysou po buttonoch
}
procedure TFeatureObject.DrawHighlighted;
var
  isOnBackSide: boolean;
  QPFont: TMyFont;
begin
  BackPlane.Canvas.Brush.Style := bsSolid;
  BackPlane.Canvas.Pen.Style := psSolid;

  isOnBackSide := objStrana <> _PNL.StranaVisible;
  // ak je prvok na zadnej strane, musi sa vykreslovat podla zadneho nul.bodu
  _PNL.CurrentSide := objStrana;

  case objTyp of

    ///////////////////// kruhova diera, kapsa
    ftHoleCirc, ftPocketCirc, ftCosmeticCircle: begin
      KruzObvod(objPoloha, objRozmer1, farbaHighlightObvod, 3);
    end;

    /////////////////// obdlznikova diera, kapsa
    ftHoleRect, ftPocketRect, ftCosmeticRect: begin
      ObdlzObvod(objPoloha, objRozmer1, objRozmer2, objRozmer3, farbaHighlightObvod, 3);
    end;

    /////////////////// zavit
    ftThread: begin
      KruzObvod(objPoloha, objRozmer1*0.83, farbaHighlightObvod, 3);
      Obluk(objPoloha, objRozmer1, 80, 10, farbaHighlightObvod, 3);
    end;

    /////////////////// text
    ftTxtGrav: begin
      QPFont := TMyFont(TPanelObject(objRodic).Fonty.Objects[ TPanelObject(objRodic).Fonty.IndexOf( objParam5 ) ]); // param5 = font name
      if objParam2 = 'HEIGHT' then begin
        Text(objParam1, objPoloha, objRozmer1, objRozmer4, objParam2, objParam3, farbaHighlightObvod, objRozmer3 + rozsirenieGraviraHighlight, QPFont, objRozmer2)
      end else if objParam2 = 'WIDTHALL' then begin
        Text(objParam1, objPoloha, objRozmer4, objRozmer1, objParam2, objParam3, farbaHighlightObvod, objRozmer3 + rozsirenieGraviraHighlight, QPFont, objRozmer2)
      end;
    end;

    /////////////////// gravirovana ciara
    ftLine2Grav: begin
      Ciara( objPoloha, MyPoint(objPoloha.X+objRozmer1, objPoloha.Y+objRozmer2), farbaHighlightObvod, objRozmer3 + rozsirenieGraviraHighlight )
    end;

    /////////////////// gravirovany obdlznik
    ftRectGrav: begin
      ObdlzObvod( objPoloha, objRozmer1, objRozmer2, objRozmer4, farbaHighlightObvod, PX(objRozmer3 + rozsirenieGraviraHighlight) )
    end;

    /////////////////// gravirovana kruznica
    ftCircleGrav: begin   // engraved shapes
      KruzObvod( objPoloha, objRozmer1, farbaHighlightObvod, PX(objRozmer3 + rozsirenieGraviraHighlight) )
    end;

    /////////////////// zahlbenie kuzelove
    ftSink: begin
      // najprv kruh zahlbenia a nasledne kruh priechodzej diery
      KruzObvod( objPoloha, objRozmer1, farbaHighlightObvod, 3);
    end;

    /////////////////// zahlbenie kuzelove specialne
    ftSinkSpecial: begin
    end;

    /////////////////// zahlbenie valcove
    ftSinkCyl: begin
      // najprv kruh zahlbenia a nasledne kruh priechodzej diery
      KruzObvod( objPoloha, objRozmer1, farbaHighlightObvod, 3 );
    end;

    /////////////////// drazka rovna
    ftGrooveLin: begin
      Ciara( objPoloha, MyPoint(objPoloha.X+objRozmer1, objPoloha.Y+objRozmer2), farbaHighlightObvod, objRozmer3 );
    end;

    /////////////////// drazka obluk
    ftGrooveArc: begin
      Obluk( objPoloha, objRozmer1, objRozmer2, objRozmer3, farbaHighlightObvod, PX(objRozmer4), (objParam1 = 'S') );
    end;

  end; // case

end;


{
Vrati string so vsetkymi moznymi info o objekte
}
function TFeatureObject.GetFeatureInfo(withID: boolean = false; withPosition: boolean = false; exploded: boolean = false): string;
var
  jeToCombo: boolean;
  strID, strName, strPosition: string;
begin
  jeToCombo := (objComboID > -1);

  // prinutime zobrazovat ID
  if (jeToCombo) OR (objTyp=ftPolyLineGrav) then withID := true;
  // zakaz zobrazovat polohu
  if (objTyp = ftPolyLineGrav) then withPosition := false;

  if withID then begin
    if (jeToCombo) AND (exploded = false) then
      strID := ' (id:'+IntToStr(objComboID)+')'
    else
      strID := ' (id:'+IntToStr(objID)+')';
  end;

  if (jeToCombo) AND (exploded = false) then
    strName := TransTxt('Combo feature')
  else
    case objTyp of
      ftHoleCirc: strName := TransTxt('Circular hole') + ' ' + FormatFloat('0.##', objRozmer1)+'mm';
      ftHoleRect: strName := TransTxt('Rectangular hole') + ' ' + FormatFloat('0.##', objRozmer1)+ 'x' + FormatFloat('0.##', objRozmer2)+'mm, R='+ FormatFloat('0.##', objRozmer3);
      ftPocketCirc: strName := TransTxt('Circular pocket') + ' ' + FormatFloat('0.##', objRozmer1)+'mm, H='+ FormatFloat('0.##', objHlbka1);
      ftPocketRect: strName := TransTxt('Rectangular pocket') + ' ' + FormatFloat('0.##', objRozmer1)+ 'x' + FormatFloat('0.##', objRozmer2)+'mm, H='+FormatFloat('0.##', objHlbka1)+', R='+ FormatFloat('0.##', objRozmer3);
      ftTxtGrav: strName := TransTxt('Engr.text') + ' ' + FormatFloat('0.##', objRozmer1)+'mm' + ' (' + FormatFloat('0.##', objRozmer3)+'mm)';
      ftLine2Grav: strName := TransTxt('Engr.line') + ' (' + FormatFloat('0.##', objRozmer3)+'mm)';
      ftRectGrav: strName := TransTxt('Engr.rectangle') + ' ' + FormatFloat('0.##', objRozmer1)+ 'x' + FormatFloat('0.##', objRozmer2)+'mm' + ' (' + FormatFloat('0.##', objRozmer3)+'mm)';
      ftCircleGrav: strName := TransTxt('Engr.circle') + ' ' + FormatFloat('0.##', objRozmer1)+'mm' + ' (' + FormatFloat('0.##', objRozmer3)+'mm)';
      ftPolyLineGrav: strName := TransTxt('Engr.polyline');
      ftThread:
        if (objHlbka1 = 9999) then
          strName := TransTxt('Thread')+' ' + objParam1 + FloatToStr(objRozmer1)
        else
          strName := TransTxt('Thread')+' ' + objParam1 + FloatToStr(objRozmer1) + ', H=' + FormatFloat('0.##', objHlbka1);
      ftSink: strName := TransTxt('Conical countersink') + ' M' + FormatFloat('0.##', objRozmer3);
      ftSinkSpecial: strName := TransTxt('Conical countersink special');
      ftSinkCyl: strName := TransTxt('Cylindrical countersink') + ' ' + FormatFloat('0.##', objRozmer1)+'/'+FormatFloat('0.##', objRozmer2)+', H='+FormatFloat('0.##', objRozmer3);
      ftGrooveLin:
        if (objHlbka1 = 9999) then
          strName := TransTxt('Linear groove') + ' ' + FormatFloat('0.##', objRozmer3)+'mm'
        else
          strName := TransTxt('Linear groove') + ' ' + FormatFloat('0.##', objRozmer3)+'mm' + ', H=' + FormatFloat('0.##', objHlbka1);
      ftGrooveArc:
        if (objHlbka1 = 9999) then
          strName := TransTxt('Arc groove') + ' ' + FormatFloat('0.##', objRozmer4)+'mm, D=' + FormatFloat('0.##', objRozmer1)
        else
          strName := TransTxt('Arc groove') + ' ' + FormatFloat('0.##', objRozmer4)+'mm, D=' + FormatFloat('0.##', objRozmer1) + ', H=' + FormatFloat('0.##', objHlbka1);
      ftCosmeticCircle:
        if objNazov = '' then strName := TransTxt('Cosmetic circle') + ' D=' + FormatFloat('0.##', objRozmer1)
        else strName := objNazov;
      ftCosmeticRect:
        if objNazov = '' then strName := TransTxt('Cosmetic rectangle') + ' ' + FormatFloat('0.##', objRozmer1) + 'x' + FormatFloat('0.##', objRozmer2)
        else strName := objNazov;
    end;  // case

  if withPosition then begin
    if (jeToCombo) AND (exploded = false) then
      // ak je combo polohovane na svoj stred, polohu zober zo samotneho objektu combo
      if (_PNL.GetComboByID(objComboID).PolohaObject = -1) then
        strPosition := ' ['+
                        FormatFloat('0.00#', _PNL.getComboByID(objComboID).Poloha.X )+';'+
                        FormatFloat('0.00#', _PNL.getComboByID(objComboID).Poloha.Y )+
                        ']'
      // ak je polohovane na nejaky svoj prvok, zober polohu z neho
      else
        strPosition := ' ['+
                        FormatFloat('0.00#', _PNL.GetFeatureByID( _PNL.getComboByID(objComboID).PolohaObject ).X )+';'+
                        FormatFloat('0.00#', _PNL.GetFeatureByID( _PNL.getComboByID(objComboID).PolohaObject ).Y )+
                        ']'
    else
      strPosition := ' ['+
                      FormatFloat('0.00#',objPoloha.X)+';'+
                      FormatFloat('0.00#',objPoloha.Y)+
                      ']';
  end;

  result := strName + strID + strPosition;
end;

function TFeatureObject.IsOnPoint(bod_MM: TMyPoint): boolean;
begin
  result := ( bod_MM.X > objBoundingRect.TopL.X ) AND
            ( bod_MM.X < objBoundingRect.BtmR.X ) AND
            ( bod_MM.Y < objBoundingRect.TopL.Y ) AND
            ( bod_MM.Y > objBoundingRect.BtmR.Y );
end;

procedure TFeatureObject.MirrorFeature(var parentPanel: TObject; smer: char = 'x');
var
  dist: double;
  tmp: double;
begin

  // "smer" znamena v akom smere zrkadlit (nie okolo ktorej osi)
  if (smer = 'x') then begin
    (parentPanel as TPanelObject).CurrentSide := objStrana;

    case (parentPanel as TPanelObject).CenterPos of
      cpCEN:
        objPoloha.X := -objPoloha.X;
      cpLB,
      cpLT : begin
        dist := ((parentPanel as TPanelObject).Sirka/2) - objPoloha.X;
        objPoloha.X := objPoloha.X + (2*dist);
        end;
      cpRB,
      cpRT : begin
        dist := -((parentPanel as TPanelObject).Sirka/2) - objPoloha.X;
        objPoloha.X := objPoloha.X + (2*dist);
        end;
    end; // case

    case objTyp of
      ftGrooveLin: objRozmer1 := -objRozmer1;
      ftGrooveArc: begin
        if (objRozmer2 >= 0) AND (objRozmer2 < 180) then
          objRozmer2 := objRozmer2 + 2*(90-objRozmer2)
        else if (objRozmer2 >= 180) AND (objRozmer2 < 360) then
          objRozmer2 := objRozmer2 + 2*(270-objRozmer2);

        if objRozmer2 >= 360 then
          objRozmer2 := objRozmer2 - 360;

        if (objRozmer3 >= 0) AND (objRozmer3 < 180) then
          objRozmer3 := objRozmer3 + 2*(90-objRozmer3)
        else if (objRozmer3 >= 180) AND (objRozmer3 < 360) then
          objRozmer3 := objRozmer3 + 2*(270-objRozmer3);

        if objRozmer3 >= 360 then
          objRozmer3 := objRozmer3 - 360;

        // este vymenime medzi sebou tieto dva udaje, lebo obluk sa kresli vzdy CCW
        tmp := objRozmer2;
        objRozmer2 := objRozmer3;
        objRozmer3 := tmp;
        end;
    end; // case

  end; // if (smer = 'x')

  AdjustBoundingBox;
end;

procedure TFeatureObject.StartEditing;
begin
  // ak boli zobrazene "multiselect" tlacitka, ktorymi som vybral objekt na editovanie,
  // tu ich skryjeme (znicime) 
  if MultiselectTlacitka.DoubleClickWaiting then begin
    MultiselectTlacitka.Clear;
  end;

  case objTyp of
    // podla typu objektu sa otvori okno na editovanie

    ftHoleCirc, ftHoleRect: begin
      fFeaHole.EditFeature( objID );
      fFeaHole.ShowModal;
    end;
    ftPocketCirc, ftPocketRect: begin
      fFeaPocket.EditFeature( objID );
      fFeaPocket.ShowModal;
    end;
    ftThread: begin
      fFeaThread.EditFeature( objID );
      fFeaThread.ShowModal;
    end;
    ftTxtGrav, ftLine2Grav, ftRectGrav, ftCircleGrav: begin
      fFeaEngraving.EditFeature( objID );
      fFeaEngraving.ShowModal;
    end;
    ftSink, ftSinkSpecial, ftSinkCyl: begin
      fFeaConus.EditFeature( objID );
      fFeaConus.ShowModal;
    end;
    ftGrooveLin, ftGrooveArc: begin
      fFeaGroove.EditFeature( objID );
      fFeaGroove.ShowModal;
    end;
    ftCosmeticCircle, ftCosmeticRect: begin
      fFeaCosmetic.EditFeature( objID );
      fFeaCosmetic.ShowModal;
    end;

  end; // case
end;


end.
