unit uMyTypes;

interface

uses SysUtils, StrUtils, Types, Classes;

type
  TMyPoint = record
    X: Double;
    Y: Double;
end;

type
  TMyRect = record
    TopL: TMyPoint;
    BtmR: TMyPoint;
end;

type
  TMyPoint2D = record
    first: TMyPoint;
    second: TMyPoint;
end;

type
  TPoleIntegerov = array of integer;

type
  TMyInt2x = record
    i1: integer;
    i2: integer;
end;

type
  TMyUndoStep_v2 = record
    step_ID:       integer;
    step_type:     string;
    step_subject:  string;
    step_side:     byte;
    obj:           TObject;
end;

type
  TMyUndoList_v2 = array of TMyUndoStep_v2;

type
  TDXFPair = record
    code: integer;
    val: string;
end;

type
  TPoleTextov = array of string;

type
  THPGLCiara = record
    kresli: boolean; // true = frezovat resp. kreslit ciaru , false = nekreslit (pre lahke pouzitie LineTo resp. MoveTo)
    bod: TMyPoint; // presun do bodu BOD
end;

type
  TPoleHPGLCiar = array of THPGLCiara;




function PX(mm: Double; axis: string = ''):integer;
function PX2(mm: Double; axis: string):integer;
function MM(pix: integer; axis: string = ''): Double;
function MyPoint(x,y: Double): TMyPoint;
function MyPointToStr(p: TMyPoint): string;
function MyRect(TopLeft, BottomRight: TMyPoint): TMYRect;
function MyRectToStr(r: TMyRect): string;
function RectToStr(r: TRect): string;
function TranslateToCenterPos(var pnl:TObject; bod: TMyPoint; fromCP, toCP: byte): TMyPoint;
function FloatToStrRoundTo(cislo: double; miesta: byte): string;

function SubStrCount(str, substr: string): integer;
procedure ExplodeString(text, separator: string; var arr: TPoleTextov);
procedure ExplodeStringSL(text, separator: string; sl: TStringList);
function FileSize(const aFilename: String): integer;
function OdstranDiakritiku(const txt: AnsiString): AnsiString;





implementation

uses Windows, uMain, uDebug, uObjectPanel, uConfig;

function PX(mm: Double; axis: string = ''): integer;
var
  x_off, y_off: Double;
begin
  if axis = '' then begin

    result := Round(mm * _PNL.Zoom);
  end else begin

    case _PNL.CenterPos of
      cpLB: begin
        x_off := 0;
        y_off := 0;
      end;

      cpCEN: begin
        x_off := _PNL.Sirka / 2;
        y_off := - _PNL.Vyska / 2;
      end;

      cpLT: begin
        x_off := 0;
        y_off := - _PNL.Vyska;
      end;

      cpRB: begin
        x_off := _PNL.Sirka;
        y_off := 0;
      end;

      cpRT: begin
        x_off := _PNL.Sirka;
        y_off := - _PNL.Vyska;
      end;
    end;

    if axis = 'x' then
      result := Round( (mm + x_off) * _PNL.Zoom ) + _PNL.DrwOffX + _PNL.ZoomOffX
    else if axis = 'y' then
      result := Round((_PNL.Vyska-mm + y_off) * _PNL.Zoom) + _PNL.DrwOffY + _PNL.ZoomOffY;
  end;
end;


function PX2(mm: Double; axis: string): integer;
begin
  // funkcia PX2 na rozdiel od PX prevedie mm na px NEZAVISLE na prave zvolenom nul.bode
  // co sa tyka osi Y, tak PX2 vracia hodnoty tak, ako keby Y=0 bolo v lavom dolnom rohu panela
  if axis = 'x' then
    result := _PNL.DrwOffX + _PNL.ZoomOffX + PX(mm);
  if axis = 'y' then
    result := _PNL.DrwOffY + _PNL.ZoomOffY + PX(_PNL.Vyska-mm);
end;


function MM(pix: integer; axis: string = ''): Double;
var
  x_off, y_off: Double;
begin

  if axis = '' then begin

    result := pix / _PNL.Zoom;
  end else begin

    case _PNL.CenterPos of
      cpLB: begin
        x_off := 0;
        y_off := 0;
      end;

      cpCEN: begin
        x_off := _PNL.Sirka / 2;
        y_off := - _PNL.Vyska / 2;
      end;

      cpLT: begin
        x_off := 0;
        y_off := - _PNL.Vyska;
      end;

      cpRB: begin
        x_off := _PNL.Sirka;
        y_off := 0;
      end;

      cpRT: begin
        x_off := _PNL.Sirka;
        y_off := - _PNL.Vyska;
      end;
    end;

    if (axis = 'x') then
      result := ((pix - _PNL.DrwOffX - _PNL.ZoomOffX) / _PNL.Zoom) - x_off
    else if (axis = 'y') then
      result := _PNL.Vyska - ((pix - _PNL.DrwOffY - _PNL.ZoomOffY) / _PNL.Zoom) + y_off
  end;
end;

function MyPoint(x,y: Double): TMYPoint;
begin
  result.X := x;
  result.Y := y;
end;

function MyPointToStr(p: TMyPoint): string;
begin
  result := '['+FloatToStr( p.X ) + ',' + FloatToStr( p.Y )+']';
end;

function MyRect(TopLeft, BottomRight: TMyPoint): TMYRect;
begin
  result.TopL := TopLeft;
  Result.BtmR := BottomRight;
end;

function MyRectToStr(r: TMyRect): string;
begin
  result := 'Lft:'+FloatToStr( r.TopL.X ) + ', ' +
            'Rht:'+FloatToStr( r.BtmR.X ) + ', ' +
            'Top:'+floattostr( r.TopL.Y ) + ', ' +
            'Btm:'+floattostr( r.BtmR.Y );
end;

function RectToStr(r: TRect): string;
begin
  result := 'Lft:'+intToStr( r.TopLeft.X ) + ', ' +
            'Rht:'+intToStr( r.BottomRight.X ) + ', ' +
            'Top:'+inttostr( r.TopLeft.Y ) + ', ' +
            'Btm:'+inttostr( r.BottomRight.Y );
end;

function TranslateToCenterPos(var pnl:TObject; bod: TMyPoint; fromCP, toCP: byte): TMyPoint;
var
  cpArr: array[1..9] of TMyPoint;
  rozdiel: TMyPoint;
begin
  cpArr[cpLB] := MyPoint(0,0);
  cpArr[cpRB] := MyPoint((pnl as TPanelObject).Sirka,0);
  cpArr[cpRT] := MyPoint((pnl as TPanelObject).Sirka,(pnl as TPanelObject).Vyska);
  cpArr[cpLT] := MyPoint(0,(pnl as TPanelObject).Vyska);
  cpArr[cpCEN]:= MyPoint((pnl as TPanelObject).Sirka/2,(pnl as TPanelObject).Vyska/2);

  rozdiel.X := cpArr[fromCP].X - cpArr[toCP].X;
  rozdiel.Y := cpArr[fromCP].Y - cpArr[toCP].Y;

  result.X := bod.X + rozdiel.X;
  result.Y := bod.Y + rozdiel.Y;
end;

function FloatToStrRoundTo(cislo: double; miesta: byte): string;
var
  dlzka: integer;
begin
  cislo := Power10(cislo, miesta);
  cislo := Round(cislo);
  result := FloatToStr(cislo);
  dlzka := Length(result);
  result := Copy(result, 0, dlzka-miesta) + '.' + Copy(result, dlzka-miesta+1, 9999);
end;

function SubStrCount(str, substr: string): integer;
var
  offset: integer;
begin
  result := 0;
  offset := PosEx(substr, str, 1);
  while offset <> 0 do
  begin
    inc(result);
    offset := PosEx(substr, str, offset + length(substr));
  end;
end;

procedure ExplodeString(text, separator: string; var arr: TPoleTextov);
var
  count: integer;
begin
  count  := 1;

  while Pos(separator,text)>0 do begin
    SetLength( arr, count );
    arr[count-1] := Copy(text, 0, Pos(separator,text)-1 );
    text := Copy(text, Pos(separator,text)+Length(separator));
    Inc(count);
  end;
  SetLength( arr, count );
  arr[count-1] := text;
end;

procedure ExplodeStringSL(text, separator: string; sl: TStringList);
begin
  while Pos(separator,text)>0 do begin
    sl.Add( Copy(text, 0, Pos(separator,text)-1 ) );
    text := Copy(text, Pos(separator,text)+1);
  end;
  sl.Add(text);
end;

function FileSize(const aFilename: String): integer;
var
  info: TWin32FileAttributeData;
begin
  result := -1;

  if NOT GetFileAttributesEx(PWideChar(aFileName), GetFileExInfoStandard, @info) then
    EXIT;

  result := info.nFileSizeLow or (info.nFileSizeHigh shl 32);
end;

function OdstranDiakritiku(const txt: AnsiString): AnsiString;
const
  CodePage = 20127; //20127 = us-ascii
var
  WS: WideString;
begin
  WS := WideString(txt);
  SetLength(Result, WideCharToMultiByte(CodePage, 0, PWideChar(WS), Length(WS), nil, 0, nil, nil));
  WideCharToMultiByte(CodePage, 0, PWideChar(WS), Length(WS), PAnsiChar(Result), Length(Result), nil, nil);
end;


end.
