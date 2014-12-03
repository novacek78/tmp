unit uOtherObjects;

interface

uses Buttons, Classes, SysUtils, Graphics, Types, Math, uMyTypes;


type
  TMultiselectButton = class(TObject)
  private
    objID: integer;  // ID feature
    objCaption: string;
    objTop: integer;
    objLeft: Integer;
    objWidth: Integer;
    objHeight: Integer;
    objPadding: Integer;
    objBox: TRect;
    objFontColor: TColor;
    objHighlighted: Boolean;
    procedure UpdateBoundingBox;
    procedure SetTop(value: Integer);
    procedure SetLeft(value: Integer);
    procedure SetWidth(value: Integer);
    procedure SetHeight(value: Integer);
  published
    property Caption: string read objCaption write objCaption;
    constructor Create(parent: TObject); virtual;
    procedure Draw;
    property FontColor: TColor read objFontColor write objFontColor;
    property Height: Integer read objHeight write SetHeight;
    property Highlighted: Boolean read objHighlighted write objHighlighted;
    property ID: integer read objID write objID;
    property Left: Integer read objLeft write SetLeft;
    function PointIsOnButton(X, Y: Integer): Boolean;
    property Top: Integer read objTop write SetTop;
    property Width: Integer read objWidth write SetWidth;
end;

type
  TMultiselectButtonsContainer = class(TObject)
    private
      _boundingBox: TRect;
      _buttons: array of TMultiselectButton;
      _doubleClickWaiting: Boolean;
      procedure SetDoubleClickWaiting(value: Boolean);
    published
      procedure Clear;
      property  DoubleClickWaiting: Boolean read _doubleClickWaiting write SetDoubleClickWaiting;
      procedure Draw(copyCanvas: Boolean = True);
      procedure Fill(objekty: TPoleIntegerov; X, Y: Integer);
      function  GetFeatureIdUnderMouse(X, Y: Integer): integer;
  end;

type
  TGuideObject = class(TObject)
  private
    objID: integer;  // ID feature
    objType: string; // vertical / horizontal / slanted = V / H / S
    objParam1: double;
    objParam2: double;
    objParam3: double;
    objSide: byte;
    objSelected: Boolean;
  published
    constructor Create(typ: string); virtual;
    property ID: integer read objID write objID;
    property Typ: string read objType write objType;
    property Param1: double read objParam1 write objParam1;
    property Param2: double read objParam2 write objParam2;
    property Param3: double read objParam3 write objParam3;
    property Strana: byte read objSide write objSide;
    property Selected: Boolean read objSelected write objSelected;
    procedure Draw;
end;

// pre pouzitie v expression parseri
type
  TMathOperationObject = class(TObject)
  private
    objTyp: string;
    objOperand1: Byte;
    objOperand2: Byte;
  published
    property Typ: string read objTyp write objTyp;
    property Op1: byte read objOperand1 write objOperand1;
    property Op2: byte read objOperand2 write objOperand2;
  end;





implementation

uses Controls, uMain, uDebug, uConfig;





{ ============================= TMultiselectButton ================================= }

constructor TMultiselectButton.Create(parent: TObject);
begin
  inherited Create;
  objID := -1;
  objTop := 0;
  objLeft := 0;
  objWidth := 200;
  objHeight := 25;
  objPadding := multiselectButtonPadding;
  objCaption := 'Multiselect';
  objFontColor := farbaMultiselectBoxText;
  objHighlighted := False;
  UpdateBoundingBox;
end;

procedure TMultiselectButton.Draw;
begin

  with BackPlane.Canvas do begin
    // najprv podkladovy obdlznik
    Pen.Width := 0;
    Brush.Style := bsSolid;
    if objHighlighted then
      Brush.Color := farbaMultiselectBoxBgndHighlighted
    else
      Brush.Color := farbaMultiselectBoxBgnd;
    Pen.Color := Brush.Color;
    Rectangle(objBox);

    // teraz oddelovacia ciarka
    Pen.Width := 1;
    Pen.Color := $00999999;
    Pen.Style := psSolid;
    MoveTo(objLeft, objTop+objHeight-1);
    LineTo(objLeft+objWidth, objTop+objHeight-1);

    // na zaver text
    Font.Height := multiselectButtonFontHeight;
    Font.Color := objFontColor;
    Brush.Style := bsClear;
    TextRect(objBox, objLeft+objPadding, objTop+objPadding, objCaption);
  end;
end;

function TMultiselectButton.PointIsOnButton(X, Y: Integer): Boolean;
begin
  Result := ( (X >= objLeft) AND (X < objLeft+objWidth) ) AND ( (Y >= objTop) AND (Y < objTop+objHeight) );
end;

procedure TMultiselectButton.SetHeight(value: Integer);
begin
  objHeight := value;
  UpdateBoundingBox;
end;

procedure TMultiselectButton.SetLeft(value: Integer);
begin
  objLeft := value;
  UpdateBoundingBox;
end;

procedure TMultiselectButton.SetTop(value: Integer);
begin
  objTop := value;
  UpdateBoundingBox;
end;

procedure TMultiselectButton.SetWidth(value: Integer);
begin
  objWidth := value;
  UpdateBoundingBox;
end;

procedure TMultiselectButton.UpdateBoundingBox;
begin
  objBox.Left := objLeft;
  objBox.Top := objTop;
  objBox.Width := objWidth;
  objBox.Height := objHeight;
end;



{ ============================= TGuideObject ================================= }

constructor TGuideObject.Create(typ: string);
begin
  inherited Create;
  objType := typ;
  objID := -1;
  objParam1 := -1;
  objParam2 := -1;
  objParam3 := 0;
  objSelected := False;
end;

procedure TGuideObject.Draw;
begin
  if (objSide <> _PNL.StranaVisible) then Exit;
  
  // vykresli guideline
  with BackPlane.Canvas do begin
    Pen.Width := 1;
    if objSelected then
      Pen.Color := $000000ff
    else
      Pen.Color := $0066ffff;
    Pen.Style := psDot;
    Pen.Mode := pmCopy;
    Brush.Style := bsClear;

    // vertikalne
    if objType = 'V' then begin
      MoveTo( PX(objParam1, 'x'), -9 );
      LineTo( PX(objParam1, 'x'), BackPlane.Height+9 );
    end;

    // horizontalne
    if objType = 'H' then begin
      MoveTo( -9 , PX(objParam1, 'y') );
      LineTo( BackPlane.Width+9 , PX(objParam1, 'y') );
    end;

  end; // with canvas
end;



{ ============================= TMultiselectButtonsContainer ================================= }

procedure TMultiselectButtonsContainer.Clear;
var
  i: Integer;
begin
  // skryje tlacitka pre vyber jedneho z viacerych nad sebou leziacich objektov
  for i := 0 to High(_buttons) do
    if Assigned(_buttons[i]) then
      FreeAndNil(_buttons[i]);

  _boundingBox.Top := 0;
  _boundingBox.Left := 0;
  _boundingBox.Width := 0;
  _boundingBox.Height := 0;

  SetLength(_buttons, 0);
  multiselectShowing := False;
end;

procedure TMultiselectButtonsContainer.Draw(copyCanvas: Boolean = True);
var
  i: Integer;
  rect: TRect;
begin

fMain.Log('container drawing. dblclick: '+booltostr(_doubleClickWaiting, true));
  for i := 0 to High(_buttons) do
    _buttons[i].Draw;

  // na zaver sa cele vykreslene tlacitko skopiruje na fMain.Canvas
  if (copyCanvas) then begin
    fMain.Canvas.CopyRect(_boundingBox, BackPlane.Canvas, _boundingBox);
  end;
end;

procedure TMultiselectButtonsContainer.Fill(objekty: TPoleIntegerov; X, Y: Integer);
var
  i, maxTextLength: Integer;
  btn: TMultiselectButton;
  tmp_y_diff: Integer;
begin
fMain.Log('container fill...');
  _doubleClickWaiting := False;

  if Length(objekty) = 0 then begin
    multiselectShowing := false;
    Exit;
  end;

  // trochu posunieme buttony od mysi prec
  X := X + 5;
  Y := Y + 5;

  SetLength(_buttons, Length(objekty));
  for i := 0 to High(_buttons) do begin
    btn := TMultiselectButton.Create(Self);
    btn.ID := objekty[i];

    // ak klikol velmi vpravo, tlacitka zobrazime nalavo od mysi
    if (fMain.ClientWidth-X) < btn.Width then begin
      btn.Left := X-btn.Width;
    end else begin
      btn.Left := X+1;
    end;

    // ak klikol velmi dolu, tlacitka zobrazime vyssie
    tmp_y_diff := ( Y + 22 + btn.Height*Length(objekty) ) - fMain.ClientHeight; // o kolko by tlacitka presahovali dolny okraj formulara
    if tmp_y_diff > 0 then begin
      btn.Top  := Y+1 + i*btn.Height - tmp_y_diff;
    end else begin
      btn.Top  := Y+1 + i*btn.Height;
    end;

    btn.Caption := _PNL.GetFeatureByID( btn.ID ).GetFeatureInfo;

    BackPlane.Canvas.Font.Height := multiselectButtonFontHeight;
    maxTextLength := Max(maxTextLength , BackPlane.Canvas.TextWidth(btn.Caption) + 2*multiselectButtonPadding);

    // farbou pisma odlisime, kedy sa vyberom v multivybere objekt len vyberie a kedy sa caka na jeho editaciu
    if doubleClickWaiting then btn.FontColor := clRed
    else btn.Fontcolor := clBlack;

    _buttons[i] := btn;
  end;

  // vsetky nastavime na velkost aby sa tam zmestil aj najdlhsi text
  maxTextLength := Max(maxTextLength , 200); // ale urcime nejaku minimalnu hodnotu
  for i := 0 to High(_buttons) do begin
    _buttons[i].Width := maxTextLength;
  end;

  // este nastavime bounding box celeho containera
  _boundingBox.Left := _buttons[0].Left;
  _boundingBox.Top  := _buttons[0].Top;
  _boundingBox.Right  := _buttons[ High(_buttons) ].Left + _buttons[ High(_buttons) ].Width;
  _boundingBox.Bottom := _buttons[ High(_buttons) ].Top + _buttons[ High(_buttons) ].Height;

  multiselectShowing := true;
end;

function TMultiselectButtonsContainer.GetFeatureIdUnderMouse(X, Y: Integer): integer;
var
  i: Integer;
begin

  Result := -1;

  for i := 0 to High(_buttons) do begin
    _buttons[i].Highlighted := False;
  end;

  for i := 0 to High(_buttons) do begin
    if _buttons[i].PointIsOnButton(X, Y) then begin
      _buttons[i].Highlighted := True;
      Result := _buttons[i].ID;
      Break;
    end;
  end;
end;

procedure TMultiselectButtonsContainer.SetDoubleClickWaiting(value: Boolean);
var
  i: Integer;
  tmpColor: TColor;
begin
  _doubleClickWaiting := value;

  if _doubleClickWaiting then
    tmpColor := farbaMultiselectBoxTextHighlight
  else
    tmpColor := farbaMultiselectBoxText;

  for i := 0 to High(_buttons) do begin
    _buttons[i].FontColor := tmpColor;
  end;
end;

end.
