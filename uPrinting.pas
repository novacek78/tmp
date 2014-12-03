unit uPrinting;

interface

uses Windows, Printers, SysUtils, Dialogs, Forms, Graphics, Math;

procedure PrintPanel;

implementation

uses uMain, uConfig, uMyTypes, uDrawLib;

var
  DPI, area_X, area_Y, feaoff_X, feaoff_Y: integer;
  off_X, off_Y: double;
  area_Xmm, area_Ymm: double;
  multiPageShiftX, multiPageShiftY: double;
  currPageShiftX, currPageShiftY: double;


function MmToPoints(mm: double; axis: char = #0; itIsFeature: boolean = true): integer;
begin
  if axis = #0 then
    result := round((mm/25.4)*DPI)
  else begin
    if axis = 'x' then
      if itIsFeature then
        result := round((mm/25.4)*DPI) + round((off_X/25.4)*DPI) + feaoff_X
      else
        result := round((mm/25.4)*DPI) + round((off_X/25.4)*DPI)
    else
      if itIsFeature then
        result := area_Y - (round((mm/25.4)*DPI) + round((off_Y/25.4)*DPI) + feaoff_Y)
      else
        result := area_Y - (round((mm/25.4)*DPI) + round((off_Y/25.4)*DPI));
  end;

  if axis <> #0 then
    if axis = 'x' then
      result := result - MmToPoints(currPageShiftX)
    else
      result := result + MmToPoints(currPageShiftY);
end;


procedure PrintPanel;
var
  i, currPageX, currPageY, pagesX, pagesY: integer;
  dUhol, dX, dY, dX2, dY2, dX3, dY3: double;
  bod1, bod2: TMyPoint;
  usecka: TMyPoint2D;
begin
  // Use the Printer function to get access to the global TPrinter object.
  // Set to landscape orientation
  if (_PNL.Sirka > _PNL.Vyska) then
    Printer.Orientation := poLandscape
  else
    Printer.Orientation := poPortrait;

  // odsadenie tlace od okraja TLACITELNEJ plochy [mm]
  off_X := 10;
  off_Y := 10;
  // DPI predpokladame rovnake v oboch smeroch a berieme len v X
  DPI := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
  // zistime tlacitelnu plochu (v bodoch)
  area_X := GetDeviceCaps(Printer.Handle, PHYSICALWIDTH);
  area_Y := GetDeviceCaps(Printer.Handle, PHYSICALHEIGHT);
  // vyratame tlacitelnu plochu v mm
  area_Xmm := ((area_X/DPI)*25.4)-off_X;
  area_Ymm := ((area_Y/DPI)*25.4)-off_Y;
  // ak nul.bod nie je v rohu c.1, nastavime posunutie featurov
  feaoff_X := 0;
  feaoff_Y := 0;
  case _PNL.CenterPos of
    2: begin feaoff_X := Round((_PNL.Sirka/25.4)*DPI); end;
    3: begin feaoff_X := Round((_PNL.Sirka/25.4)*DPI); feaoff_Y := Round((_PNL.Vyska/25.4)*DPI); end;
    4: begin feaoff_Y := Round((_PNL.Vyska/25.4)*DPI); end;
    5: begin feaoff_X := Round(((_PNL.Sirka/2)/25.4)*DPI); feaoff_Y := Round(((_PNL.Vyska/2)/25.4)*DPI); end;
  end;

  // zistime, ci sa panel zmesti na jednu stranu a ak nie, tak ho rozdelime na viac stran
  if (_PNL.Sirka > area_Xmm) OR (_PNL.Vyska > area_Ymm)then begin
    // kedze sa panel nezmesti na 1 stranu, vypocitame na kolko stran sa zmesti
    pagesX := ceil(_PNL.Sirka/area_Xmm);
    pagesY := ceil(_PNL.Vyska/area_Ymm);
    multiPageShiftX := _PNL.Sirka / pagesX;
    multiPageShiftY := _PNL.Vyska / pagesY;
  end else begin
    pagesX := 1;
    pagesY := 1;
    multiPageShiftX := 0;
    multiPageShiftY := 0;
  end;

  // Set the printjob title - as it it appears in the print job manager
  if (_PNL.FileName = '') then
    Printer.Title := 'QuickPanel - new panel'
  else
    Printer.Title := 'QuickPanel - '+ExtractFileName(_PNL.FileName);

  // Set the number of copies to print each page
  // This is crude - it does not take Collation into account
  Printer.Copies := fMain.printDialog.Copies;

  // Start printing
  Printer.BeginDoc;

  // samotna tlac
  for currPageX := 1 to pagesX do begin
    for currPageY := 1 to pagesY do begin
      if (not Printer.Aborted) AND Printer.Printing then begin

        // Allow Windows to keep processing messages
        Application.ProcessMessages;

        // ak sa tlaci viac stran, postupne nastavujeme posunutie panela v X a Y
        currPageShiftX := multiPageShiftX * (currPageX-1);
        currPageShiftY := multiPageShiftY * (currPageY-1);

        // panel bude hrubou ciarou
        Printer.Canvas.Pen.Width := 4;
        Printer.Canvas.RoundRect(
          MmToPoints(0, 'x', false), MmToPoints(0, 'y', false),
          MmToPoints(_PNL.Sirka, 'x', false), MmToPoints(_PNL.Vyska, 'y', false),
          MmToPoints(_PNL.Radius*2), MmToPoints(_PNL.Radius*2)
        );

        for i := 0 to _PNL.Features.Count - 1 do begin
          // reset kresliacich stylov
          Printer.Canvas.Font.Size   := 10;
          Printer.Canvas.Brush.Style := bsClear;
          Printer.Canvas.Pen.Width   := 4;
          Printer.Canvas.Pen.Style   := psSolid;
          // nastavenie pre prvky na opacnej strane panela
          if _PNL.Features[i].Strana <> _PNL.CurrentSide then begin
            Printer.Canvas.Pen.Width   := 1;
            Printer.Canvas.Pen.Style   := psDot;
          end;

          { gravirovane veci sa nateraz netlacia
          if
            (_PNL.Features[i].Typ = ftCircleGrav) OR
            (_PNL.Features[i].Typ = ftRectGrav) OR
            (_PNL.Features[i].Typ = ftLine2Grav)
          then
            Printer.Canvas.Pen.Width := MmToPoints(_PNL.Features[i].Rozmer3);
          }


          case _PNL.Features[i].Typ of

          ftHoleCirc, ftPocketCirc{, ftCircleGrav}:
            printer.Canvas.Ellipse(
              MmToPoints(_PNL.Features[i].Poloha.X - _PNL.Features[i].Rozmer1/2 , 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y - _PNL.Features[i].Rozmer1/2 , 'y'),
              MmToPoints(_PNL.Features[i].Poloha.X + _PNL.Features[i].Rozmer1/2 , 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y + _PNL.Features[i].Rozmer1/2 , 'y')
            );

          ftHoleRect, ftPocketRect{, ftRectGrav}:
            printer.Canvas.RoundRect(
              MmToPoints(_PNL.Features[i].Poloha.X - _PNL.Features[i].Rozmer1/2 , 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y - _PNL.Features[i].Rozmer2/2 , 'y'),
              MmToPoints(_PNL.Features[i].Poloha.X + _PNL.Features[i].Rozmer1/2 , 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y + _PNL.Features[i].Rozmer2/2 , 'y'),
              MmToPoints(_PNL.Features[i].Rozmer3*2),
              MmToPoints(_PNL.Features[i].Rozmer3*2)
            );

          ftThread:
            begin
            printer.Canvas.Ellipse(
              MmToPoints(_PNL.Features[i].Poloha.X - (_PNL.Features[i].Rozmer1*0.83)/2 , 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y - (_PNL.Features[i].Rozmer1*0.83)/2 , 'y'),
              MmToPoints(_PNL.Features[i].Poloha.X + (_PNL.Features[i].Rozmer1*0.83)/2 , 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y + (_PNL.Features[i].Rozmer1*0.83)/2 , 'y')
            );
            printer.Canvas.Pen.Width := 1;
            printer.Canvas.Arc(
              MmToPoints(_PNL.Features[i].Poloha.X - _PNL.Features[i].Rozmer1/2,'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y - _PNL.Features[i].Rozmer1/2,'y'),
              MmToPoints(_PNL.Features[i].Poloha.X + _PNL.Features[i].Rozmer1/2,'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y + _PNL.Features[i].Rozmer1/2,'y'),
              MmToPoints(999, 'x'), MmToPoints(_PNL.Features[i].Poloha.Y, 'y'),
              MmToPoints(_PNL.Features[i].Poloha.X, 'x'), MmToPoints(-999, 'y')
            );
            end;

          ftSink, ftSinkCyl:
          begin
            printer.Canvas.Ellipse(
              MmToPoints(_PNL.Features[i].Poloha.X - _PNL.Features[i].Rozmer1/2 , 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y - _PNL.Features[i].Rozmer1/2 , 'y'),
              MmToPoints(_PNL.Features[i].Poloha.X + _PNL.Features[i].Rozmer1/2 , 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y + _PNL.Features[i].Rozmer1/2 , 'y')
            );
            printer.Canvas.Ellipse(
              MmToPoints(_PNL.Features[i].Poloha.X - _PNL.Features[i].Rozmer2/2 , 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y - _PNL.Features[i].Rozmer2/2 , 'y'),
              MmToPoints(_PNL.Features[i].Poloha.X + _PNL.Features[i].Rozmer2/2 , 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y + _PNL.Features[i].Rozmer2/2 , 'y')
            );
          end;

          ftGrooveLin:
          begin
            dUhol := ArcTan(_PNL.Features[i].Rozmer2 / _PNL.Features[i].Rozmer1);
            dX := sin( dUhol ) * _PNL.Features[i].Rozmer3/2;
            dY := cos( dUhol ) * _PNL.Features[i].Rozmer3/2;
            printer.Canvas.MoveTo(
              MmToPoints(_PNL.Features[i].Poloha.X+dX, 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y-dY, 'y')
            );
            printer.Canvas.LineTo(
              MmToPoints(_PNL.Features[i].Poloha.X+_PNL.Features[i].Rozmer1+dX, 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y+_PNL.Features[i].Rozmer2-dY, 'y')
            );
            printer.Canvas.MoveTo(
              MmToPoints(_PNL.Features[i].Poloha.X-dX, 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y+dY, 'y')
            );
            printer.Canvas.LineTo(
              MmToPoints(_PNL.Features[i].Poloha.X+_PNL.Features[i].Rozmer1-dX, 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y+_PNL.Features[i].Rozmer2+dY, 'y')
            );
            printer.Canvas.Arc(
              MmToPoints(_PNL.Features[i].Poloha.X - _PNL.Features[i].Rozmer3/2 , 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y - _PNL.Features[i].Rozmer3/2 , 'y'),
              MmToPoints(_PNL.Features[i].Poloha.X + _PNL.Features[i].Rozmer3/2 , 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y + _PNL.Features[i].Rozmer3/2 , 'y'),
              MmToPoints(_PNL.Features[i].Poloha.X-dX, 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y+dY, 'y'),
              MmToPoints(_PNL.Features[i].Poloha.X+dX, 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y-dY, 'y')
            );
            printer.Canvas.Arc(
              MmToPoints((_PNL.Features[i].Poloha.X+_PNL.Features[i].Rozmer1) - _PNL.Features[i].Rozmer3/2 , 'x'),
              MmToPoints((_PNL.Features[i].Poloha.Y+_PNL.Features[i].Rozmer2) - _PNL.Features[i].Rozmer3/2 , 'y'),
              MmToPoints((_PNL.Features[i].Poloha.X+_PNL.Features[i].Rozmer1) + _PNL.Features[i].Rozmer3/2 , 'x'),
              MmToPoints((_PNL.Features[i].Poloha.Y+_PNL.Features[i].Rozmer2) + _PNL.Features[i].Rozmer3/2 , 'y'),
              MmToPoints(_PNL.Features[i].Poloha.X+_PNL.Features[i].Rozmer1+dX, 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y+_PNL.Features[i].Rozmer2-dY, 'y'),
              MmToPoints(_PNL.Features[i].Poloha.X+_PNL.Features[i].Rozmer1-dX, 'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y+_PNL.Features[i].Rozmer2+dY, 'y')
            );
          end;

          ftGrooveArc:
          begin
            dX  := cos( DegToRad(_PNL.Features[i].Rozmer2)) * (_PNL.Features[i].Rozmer1/2);
            dY  := sin( DegToRad(_PNL.Features[i].Rozmer2)) * (_PNL.Features[i].Rozmer1/2);
            dX2 := cos( DegToRad(_PNL.Features[i].Rozmer3)) * (_PNL.Features[i].Rozmer1/2);
            dY2 := sin( DegToRad(_PNL.Features[i].Rozmer3)) * (_PNL.Features[i].Rozmer1/2);
            // ak je spojeny zaciatok obluku s koncom
            if _PNL.Features[i].Param1 = 'S' then begin
              bod1.X := _PNL.Features[i].Poloha.X + dX;
              bod1.Y := _PNL.Features[i].Poloha.Y + dY;
              bod2.X := _PNL.Features[i].Poloha.X + dX2;
              bod2.Y := _PNL.Features[i].Poloha.Y + dY2;

              usecka := CiaraOffset(bod1, bod2, 'P', _PNL.Features[i].Rozmer4/2);
              printer.Canvas.MoveTo(
                MmToPoints(usecka.first.X, 'x'),
                MmToPoints(usecka.first.Y, 'y')
              );
              printer.Canvas.LineTo(
                MmToPoints(usecka.second.X, 'x'),
                MmToPoints(usecka.second.Y, 'y')
              );

              usecka := CiaraOffset(bod1, bod2, 'L', _PNL.Features[i].Rozmer4/2);
              printer.Canvas.MoveTo(
                MmToPoints(usecka.first.X, 'x'),
                MmToPoints(usecka.first.Y, 'y')
              );
              printer.Canvas.LineTo(
                MmToPoints(usecka.second.X, 'x'),
                MmToPoints(usecka.second.Y, 'y')
              );
            end;
            // vonkajsi obluk
            printer.Canvas.Arc(
              MmToPoints(_PNL.Features[i].Poloha.X - (_PNL.Features[i].Rozmer1/2+_PNL.Features[i].Rozmer4/2),'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y - (_PNL.Features[i].Rozmer1/2+_PNL.Features[i].Rozmer4/2),'y'),
              MmToPoints(_PNL.Features[i].Poloha.X + (_PNL.Features[i].Rozmer1/2+_PNL.Features[i].Rozmer4/2),'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y + (_PNL.Features[i].Rozmer1/2+_PNL.Features[i].Rozmer4/2),'y'),
              MmToPoints(_PNL.Features[i].Poloha.X + dX, 'x'), MmToPoints(_PNL.Features[i].Poloha.Y+dY, 'y'),
              MmToPoints(_PNL.Features[i].Poloha.X + dX2, 'x'), MmToPoints(_PNL.Features[i].Poloha.Y+dY2, 'y')
            );
            // vnutorny obluk
            printer.Canvas.Arc(
              MmToPoints(_PNL.Features[i].Poloha.X - (_PNL.Features[i].Rozmer1/2-_PNL.Features[i].Rozmer4/2),'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y - (_PNL.Features[i].Rozmer1/2-_PNL.Features[i].Rozmer4/2),'y'),
              MmToPoints(_PNL.Features[i].Poloha.X + (_PNL.Features[i].Rozmer1/2-_PNL.Features[i].Rozmer4/2),'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y + (_PNL.Features[i].Rozmer1/2-_PNL.Features[i].Rozmer4/2),'y'),
              MmToPoints(_PNL.Features[i].Poloha.X + dX, 'x'), MmToPoints(_PNL.Features[i].Poloha.Y+dY, 'y'),
              MmToPoints(_PNL.Features[i].Poloha.X + dX2, 'x'), MmToPoints(_PNL.Features[i].Poloha.Y+dY2, 'y')
            );
            // obluk uzatvaraci drazku na pociatocnom bode
            dX3 := cos( DegToRad(_PNL.Features[i].Rozmer2)) * (_PNL.Features[i].Rozmer4/2);
            dY3 := sin( DegToRad(_PNL.Features[i].Rozmer2)) * (_PNL.Features[i].Rozmer4/2);
            printer.Canvas.Arc(
              MmToPoints(_PNL.Features[i].Poloha.X+dX - (_PNL.Features[i].Rozmer4/2),'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y+dY - (_PNL.Features[i].Rozmer4/2),'y'),
              MmToPoints(_PNL.Features[i].Poloha.X+dX + (_PNL.Features[i].Rozmer4/2),'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y+dY + (_PNL.Features[i].Rozmer4/2),'y'),
              MmToPoints(_PNL.Features[i].Poloha.X, 'x'), MmToPoints(_PNL.Features[i].Poloha.Y, 'y'),
              MmToPoints(_PNL.Features[i].Poloha.X+dX+dX3, 'x'), MmToPoints(_PNL.Features[i].Poloha.Y+dY+dY3, 'y')
            );
            // obluk uzatvaraci drazku na koncovom bode
            dX3 := cos( DegToRad(_PNL.Features[i].Rozmer3)) * (_PNL.Features[i].Rozmer4/2);
            dY3 := sin( DegToRad(_PNL.Features[i].Rozmer3)) * (_PNL.Features[i].Rozmer4/2);
            printer.Canvas.Arc(
              MmToPoints(_PNL.Features[i].Poloha.X+dX2 - (_PNL.Features[i].Rozmer4/2),'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y+dY2 - (_PNL.Features[i].Rozmer4/2),'y'),
              MmToPoints(_PNL.Features[i].Poloha.X+dX2 + (_PNL.Features[i].Rozmer4/2),'x'),
              MmToPoints(_PNL.Features[i].Poloha.Y+dY2 + (_PNL.Features[i].Rozmer4/2),'y'),
              MmToPoints(_PNL.Features[i].Poloha.X+dX2+dX3, 'x'), MmToPoints(_PNL.Features[i].Poloha.Y+dY2+dY3, 'y'),
              MmToPoints(_PNL.Features[i].Poloha.X, 'x'), MmToPoints(_PNL.Features[i].Poloha.Y, 'y')
            );
          end;

          end; // case
        end; // for i := 0 to _PNL.Features.Count - 1 do begin

        // Now start a new page
        if (Printer.PageNumber < (pagesX*pagesY)) then
          Printer.NewPage;
      end; // if all OK
    end; // for pages in Y
  end; // for pages in X
  // Finish printing
  Printer.EndDoc;
end;


end.
