unit uObjectPanel;

interface

uses Forms, Graphics, Math, Windows, SysUtils, Types, uObjectFeature, uObjectFeatureList, uFeaCombo, uMyTypes,
      uConfig, Classes, uOtherObjects, uObjectCombo, uObjectComboList, IniFiles, StrUtils, uObjectGuideList;

type
  TPanelObject = class(TObject)
  private
    objID: integer;  // ID pridelene po nahrati na web
    objVersion: integer;  // ked nahravam panely zo suborov zo starsich verzii, tak aby som mal prehlad, akou verziou bol vytvoreny
    objSirka: Double;
    objVyska: Double;
    objHrubka: Double;
    objRadius: Double;
    objGrid: Double;
    objPovrch: string;
    objHranaStyl: string;
    objHranaRozmer: Double;
    objHranaObrobenaBottom: boolean;
    objHranaObrobenaRight: boolean;
    objHranaObrobenaTop: boolean;
    objHranaObrobenaLeft: boolean;
    objMaterialVlastny: boolean;
    objFeatures: TFeaList;     // tu budu ulozene vsetky features
    objCombos: TComboList;     // tu budu ulozene vsetky comba
    objGuides: TGuideList;     // tu budu ulozene vsetky guide-liney
    objFonty: TStringList;     // zoznam nahratych fontov
    objNewFeatureId: integer;  // number of next created feature
    objNextComboId  : integer; // number of next created combo
    objBgndCol: TColor;
    objSurfCol: TColor;
    objBordCol: TColor;
    objZoom: Double;           // pomer mm/px (uz zahrna aj objZoomFactor)
    objZoomFactor: double;     // udava zoom nastaveny uzivatelom
    objSideZeroes: array[1..9] of byte;  // pole nul.bodov (na poz.1 je nul.bod strany 1...)
    objCurrentSide: byte;      // cislo aktivneho nuloveho bodu (v poli nulovych bodov)
    objDrawOffsetX: integer;
    objDrawOffsetY: integer;
    objZoomOffsetX: integer;
    objZoomOffsetY: integer;
    objFileName: string;
    objHasChanged: boolean;
    objRoh_c1: TMyPoint;
    objSelCombosDrawn: string;  // kym nenajdem lepsie riesenie: na oznacenie, ci vyselectovanemu combu uz bol vykresleny vyberovy obdlznik
    objStranaVisible: byte;
    objUndoList2: TMyUndoList_v2;
    objNextUndoStepID: integer;
    objIndexOfNextUndoStep: integer;
    objGridPointsX: array of Integer; // spocitame px suradnice gridu, sem sa to ulozi a potom sa uz len podla tohto pola vykresluje grid
    objGridPointsY: array of Integer; // --- " ---
    procedure SetSirka(val: Double);
    procedure SetVyska(val: Double);
    function  GetCenterPos: byte;
    procedure SetCenterPos(newVal: byte);
    procedure SetCurrentSide(newVal: Byte);
    procedure SetRoh_c1;
    procedure KresliZrazenyRoh(c_rohu: byte; x_zrazeneho_rohu_mm, y_zrazeneho_rohu_mm: double; horizontal, vertikal: boolean);
    procedure SetHasChanged(val: Boolean);
    procedure RedrawSurrounding;
  published
    constructor Create;
    destructor  Destroy;
    property ID: integer read objID write objID;
    property Version: integer read objVersion;
    property Features: TFeaList read objFeatures;
    property Combos: TComboList read objCombos;
    property Guides: TGuideList read objGuides;
    property Sirka: Double read objSirka write SetSirka;
    property Vyska: Double read objVyska write SetVyska;
    property Hrubka: Double read objHrubka write objHrubka;
    property Radius: Double read objRadius write objRadius;
    property Grid: Double read objGrid write objGrid;
    property Povrch: string read objPovrch write objPovrch;
    property HranaStyl: string read objHranaStyl write objHranaStyl;
    property HranaRozmer: Double read objHranaRozmer write objHranaRozmer;
    property HranaObrobenaBottom: boolean read objHranaObrobenaBottom write objHranaObrobenaBottom;
    property HranaObrobenaRight: boolean read objHranaObrobenaRight write objHranaObrobenaRight;
    property HranaObrobenaTop: boolean read objHranaObrobenaTop write objHranaObrobenaTop;
    property HranaObrobenaLeft: boolean read objHranaObrobenaLeft write objHranaObrobenaLeft;
    property MaterialVlastny: boolean read objMaterialVlastny write objMaterialVlastny;
    property CenterPos: byte read GetCenterPos write SetCenterPos;
    property CurrentSide: byte read objCurrentSide write SetCurrentSide;
    property HasChanged: boolean read objHasChanged write SetHasChanged;
    property BgndCol: TColor read objBgndCol write objBgndCol;
    property SurfCol: TColor read objSurfCol write objSurfCol;
    property BordCol: TColor read objBordCol write objBordCol;
    property DrwOffX: integer read objDrawOffsetX write objDrawOffsetX;
    property DrwOffY: integer read objDrawOffsetY write objDrawOffsetY;
    property Zoom: Double read objZoom write objZoom;
    property ZoomOffX: integer read objZoomOffsetX write objZoomOffsetX;
    property ZoomOffY: integer read objZoomOffsetY write objZoomOffsetY;
    property StranaVisible: byte read objStranaVisible write objStranaVisible;
    property FileName: string read objFileName write objFileName;
    property Roh_c1: TMyPoint read objRoh_c1;
    property SelCombosDrawn: string read objSelCombosDrawn write objSelCombosDrawn;
    property UndoList2: TMyUndoList_v2 read objUndoList2 write objUndoList2;
    property Fonty: TStringList read objFonty write objFonty;

    procedure LoadFromFile_old(panelfile: string);
    procedure LoadFromFile(panelfile: string);
    procedure SaveToFile(panelfile: string);
    function  GetFeatureByID(fid: integer): TFeatureObject;
    function  GetFeaturesAt(var poleNajdenych: TPoleIntegerov; bod_x, bod_y: integer): boolean;
    function  GetGuidelinesAt(bod_x, bod_y: integer): TMyInt2x;
    function  GetSelectedFeaturesNum: TMyInt2x;
    function  GetFeatureIndex(fid: integer):integer;
    procedure MoveSelected(byXmm, byYmm: double);
    procedure SelectAll;
    procedure SelectAllInRect(obdlz: TRect; ciastocne: boolean = false);
    procedure DeselectAll;
    procedure DelSelected;
    procedure DelFeatureByID(fid: integer);
    procedure Draw(copyCanvas: Boolean = True);
    procedure DrawHighlightedOnly(copyCanvas: Boolean = True);
    procedure GetFullInfo(target: string = 'debug');
    procedure SetZoom(zoomVal: Double = 1; curX: integer = 0; curY: integer = 0);
    function  GetCenterPosBack: byte;
    function  GetCenterPosByNum(num: Byte): Byte;
    procedure SetCenterPosByNum(newVal: Byte; cenPosNumber: byte = 0);
    procedure LoadFont(fontfilename: string);
    // combo veci
    function  AddCombo(id: integer = -1): integer;
    function  MakeCombo: integer;
    function  ComboExists(comboId: integer): boolean;
    procedure GetComboFeatures(var poleObjektov: TPoleIntegerov; comboID: integer);
    function  GetComboBoundingBox(comboID: integer): TMyRect;
    function  GetComboByID(cid: integer): TComboObject;
    procedure SelectCombo(comboID: integer; sel_state: boolean = true);
    procedure ExplodeCombo(comboID: integer);
    // GuideLine-y
    function  AddGuideLine(typ: string; param_1: double; param_2: double = 0; param_3: double = 0; side: byte = 1): TGuideObject;
    function  GetGuideLineById(gid: integer): TGuideObject;
    procedure DelGuideLineById(gid: integer);
    procedure DeselectAllGuidelines;
    // undo
    procedure PrepareUndoStep;
    procedure CreateUndoStep(undoType: string; subjectType: string; subjectID: integer);
    procedure Undo;
    function  GetNumberOfUndoSteps: integer;
  public
    function  AddFeature(ftype: integer): integer; overload;
    function  AddFeature(ftype: string): integer; overload;

end;

implementation

uses uMain, uPanelSett, uDebug, uTranslate, uDrawLib, uObjectFeaturePolyLine,
  uObjectFont, uObjectFontZnak, uFeaEngrave, uGuides;

constructor TPanelObject.Create;
begin
  inherited Create;
  objFeatures := TFeaList.Create;
  objCombos   := TComboList.Create;
  objGuides   := TGuideList.Create;
  objFonty    := TStringList.Create;
  LoadFont('din17i_cp1250.font');
  objID := -1;
  objNewFeatureId := 1;
  objNextComboId   := 1;
  objSideZeroes[1] := cpLB;
  objSideZeroes[2] := cpLB;
  objRoh_c1 := MyPoint(0,0);
  objDrawOffsetX := 5;
  objDrawOffsetY := fMain.ToolBar1.Height + 5;
  objZoomOffsetX := 0;
  objZoomOffsetY := 0;
  objGrid := 0.5;
  objZoom := 9999;
  objZoomFactor := 1;
  objStranaVisible := 1; // ktora strana je prave viditelna (1=predna strana, 2=zadna strana)
  objCurrentSide := objStranaVisible;
  objHasChanged := false;
  SetLength(objUndoList2, 100);
  objNextUndoStepID := 0;
  objIndexOfNextUndoStep := 0;
  objMaterialVlastny := false;
  objHranaStyl := '0';
  objHranaRozmer := 0;
  objHranaObrobenaBottom := false;
  objHranaObrobenaRight := false;
  objHranaObrobenaTop := false;
  objHranaObrobenaLeft := false;
end;

destructor TPanelObject.Destroy;
begin
  FreeAndNil(objFeatures);
  inherited Destroy;
end;

procedure TPanelObject.SetSirka(val: Double);
begin
  objSirka := val;
  SetRoh_c1;
  fPanelSett.edSirka.Text := FloatToStr(val);
  SetZoom;
  objHasChanged := true;
end;

procedure TPanelObject.SetVyska(val: Double);
begin
  objVyska := val;
  SetRoh_c1;
  fPanelSett.edVyska.Text := FloatToStr(val);
  SetZoom;
  objHasChanged := true;
end;

function TPanelObject.GetCenterPos: byte;
begin
  result := objSideZeroes[objCurrentSide];
end;

procedure TPanelObject.SetCenterPos(newVal: byte);
begin
  SetCenterPosByNum(newVal);
end;

procedure TPanelObject.SetCenterPosByNum(newVal: Byte; cenPosNumber: byte = 0);
var
  oldC, newC, diff: TMyPoint;
  i: integer;
  guide: TGuideObject;
begin
  if cenPosNumber = 0 then cenPosNumber := objCurrentSide;

  // ked sa zmeni poloha pociatku sur.sys., prekotuje vsetky features
  // najprv si absolutne zakotujeme stary aj novy center (pevna nula je vlavo dole)
  if objSideZeroes[cenPosNumber] = cpLT  then begin oldC.X := 0; oldC.Y := objVyska; end;
  if objSideZeroes[cenPosNumber] = cpLB  then begin oldC.X := 0; oldC.Y := 0; end;
  if objSideZeroes[cenPosNumber] = cpRT  then begin oldC.X := objSirka; oldC.Y := objVyska; end;
  if objSideZeroes[cenPosNumber] = cpRB  then begin oldC.X := objSirka; oldC.Y := 0; end;
  if objSideZeroes[cenPosNumber] = cpCEN then begin oldC.X := objSirka/2; oldC.Y := objVyska/2; end;

  if newVal = cpLT  then begin newC.X := 0; newC.Y := objVyska; end;
  if newVal = cpLB  then begin newC.X := 0; newC.Y := 0; end;
  if newVal = cpRT  then begin newC.X := objSirka; newC.Y := objVyska; end;
  if newVal = cpRB  then begin newC.X := objSirka; newC.Y := 0; end;
  if newVal = cpCEN then begin newC.X := objSirka/2; newC.Y := objVyska/2; end;

  // teraz si vycislime rozdiel medzi starym a novym centrom
  diff.X := newC.X - oldC.X;
  diff.Y := newC.Y - oldC.Y;

  // a teraz "posunieme" vsetky feature
  for i:=0 to objFeatures.Count-1 do
    if Assigned( objFeatures[i] ) AND (objFeatures[i].Strana = cenPosNumber) then begin
      objFeatures[i].X := objFeatures[i].X - diff.X;
      objFeatures[i].Y := objFeatures[i].Y - diff.Y;
      // ak je to polyline, musime prekotovat kazdy vertex
      if objFeatures[i].Typ = ftPolyLineGrav then begin
        (objFeatures[i] as TFeaturePolyLineObject).MovePolylineBy(-diff.X, -diff.Y);
      end;
    end;

  // aj vsetky combo objekty
  for i:=0 to objCombos.Count-1 do
    if Assigned( objCombos[i] ) AND (objFeatures[i].Strana = cenPosNumber) then begin
      objCombos[i].X := objCombos[i].X - diff.X;
      objCombos[i].Y := objCombos[i].Y - diff.Y;
    end;

  // aj vsetky guide lines treba prekotovat
  for i:=0 to objGuides.Count-1 do begin
    guide := objGuides[i];
    if Assigned(guide) then begin
      if guide.Typ = 'V' then guide.Param1 := guide.Param1 - diff.X;
      if guide.Typ = 'H' then guide.Param1 := guide.Param1 - diff.Y;
    end;
  end;

  objSideZeroes[cenPosNumber] := newVal;
  SetRoh_c1;
end;

procedure TPanelObject.SetCurrentSide(newVal: Byte);
begin
  objCurrentSide := newVal;
  SetRoh_c1;
end;

procedure TPanelObject.SetHasChanged(val: Boolean);
var
  sZnacka: string;
begin
  if (objHasChanged <> val) then begin // len ak sa prave teraz meni hodnota, tak to vyznacime v title bare

    sZnacka := ' (*)';

    if not objHasChanged then begin
      fMain.Caption := fMain.Caption + sZnacka;
    end else begin
      fMain.Caption := Copy( fMain.Caption, 1, Length(fMain.Caption) - Length(sZnacka));
    end;

    objHasChanged := val;
  end;
end;

procedure TPanelObject.SetRoh_c1;
begin
  if objSideZeroes[objCurrentSide] = cpLB   then objRoh_c1 := MyPoint(0,0);
  if objSideZeroes[objCurrentSide] = cpRB   then objRoh_c1 := MyPoint(-objSirka, 0);
  if objSideZeroes[objCurrentSide] = cpRT   then objRoh_c1 := MyPoint(-objSirka, -objVyska);
  if objSideZeroes[objCurrentSide] = cpLT   then objRoh_c1 := MyPoint(0, -objVyska);
  if objSideZeroes[objCurrentSide] = cpCEN  then objRoh_c1 := MyPoint((-objSirka/2), (-objVyska/2));
end;


function TPanelObject.AddFeature(ftype: string): integer;
begin
  result := AddFeature( StrToInt(ftype) );
end;

procedure TPanelObject.RedrawSurrounding;
var
  r: TRect;
begin
  // "osekneme" zobrazenie objektov mimo panela (napr. kapsa, co presahuje mimo panel)
  with BackPlane.Canvas do begin
    Pen.Color := objBgndCol;
    Brush.Color := objBgndCol;

    // nalavo
    r.Left := 0;
    r.Right := PX(objRoh_c1.x, 'x');
    r.Top := 0;
    r.Bottom := fMain.ClientHeight;
    Rectangle(r);

    // napravo
    r.Left := PX(objRoh_c1.X + objSirka, 'x');
    r.Right := fMain.ClientWidth;
    r.Top := 0;
    r.Bottom := fMain.ClientHeight;
    Rectangle(r);

    // hore
    r.Left := 0;
    r.Right := fMain.ClientWidth;
    r.Top := 0;
    r.Bottom := PX(objRoh_c1.Y + objVyska, 'y');
    Rectangle(r);

    // dolu
    r.Left := 0;
    r.Right := fMain.ClientWidth;
    r.Top := PX(objRoh_c1.Y, 'y');
    r.Bottom := fMain.ClientHeight;
    Rectangle(r);
  end;
end;

function TPanelObject.AddFeature(ftype: integer): integer;
var
  new_index: integer;
begin
  result := -1;
  try
    // vytvori novu feature a vrati jej ID
    if ftype <= 0 then Exit;

    if ftype = ftPolyLineGrav then
      new_index := objFeatures.Add(TFeaturePolyLineObject.Create(Self))
    else
      new_index := objFeatures.Add(TFeatureObject.Create(Self, -1, ftype));

    objFeatures[new_index].ID := objNewFeatureId;
//    objFeatures[new_index].Param5 := 'din17i_cp1250.font';  // default

    Inc(objNewFeatureId);
    objHasChanged := true;

    result := objFeatures[new_index].ID;
  except
    MessageBox(0, PChar(TransTxt('Couldn''t create new object')), PChar(TransTxt('Error')), MB_ICONERROR);
  end;
end;


function TPanelObject.AddCombo(id: integer = -1): integer;
var
  new_index: integer;
begin
  // inicializuje nove combo v poli, priradi mu spravne ID
  // samotne features na paneli donho neprida
  // combo z prvkov na paneli vytvarat cez metodu MAKECOMBO
  result := -1;

  try
    new_index := objCombos.Add(TComboObject.Create);
    // ak je zadany parameter, tak vytvori nove combo presne s takym IDckom
    // ak nie, najde najblizsi nepouzity a vytvori combo
    if (id > -1) then begin
      objCombos[new_index].ID := id;
      // ak zadane ID pre nove combo bolo vyssie, nez je automaticky zvolene ID pre nove comba, zvysi ho
      if (objNextComboId <= id) then objNextComboId := id+1;
    end else begin
      objCombos[new_index].ID := objNextComboId;
      Inc(objNextComboId);
    end;

    objHasChanged := true;
    result := objCombos[new_index].ID;

  except
    MessageBox(0, PChar(TransTxt('Couldn''t create new combo')), PChar(TransTxt('Error')), MB_ICONERROR);
  end;
end;

function TPanelObject.MakeCombo: integer;
var
  i, newComboID: integer;
  tmp_rect: TMyRect;
  tmp_bod: TMyPoint;
begin
  { z prave vyselectovanych prvkov vytvori combo otvor,
    de facto len zgrupne prvky do jedneho tym, ze im nastavi ComboID
    a vratime cislo vytvoreneho comba }

  result := -1;

  if GetSelectedFeaturesNum.i1 <= 0 then
    Exit;

  // vytvori nove combo a ulozi si jeho ID
  newComboID := _PNL.AddCombo;
  for i:=0 to objFeatures.Count-1 do
    if Assigned(objFeatures[i]) then
      if objFeatures[i].Selected then
        objFeatures[i].ComboID := newComboID;

  // standardne bude combo, ktore sa vytvori, polohovane na svoj stred
  tmp_rect := _PNL.GetComboBoundingBox(newComboID);
  tmp_bod.X := tmp_rect.TopL.X + ((tmp_rect.BtmR.X-tmp_rect.TopL.X)/2);
  tmp_bod.Y := tmp_rect.TopL.Y + ((tmp_rect.BtmR.Y-tmp_rect.TopL.Y)/2);
  _PNL.GetComboByID(newComboID).PolohaObject := -1;
  _PNL.GetComboByID(newComboID).Poloha := tmp_bod;
  _PNL.GetComboByID(newComboID).Velkost := MyPoint( Abs(tmp_rect.BtmR.X-tmp_rect.TopL.X) , Abs(tmp_rect.TopL.Y-tmp_rect.BtmR.Y));

  result := newComboID;
end;

function TPanelObject.ComboExists(comboId: integer): boolean;
var
  i: integer;
begin
  // zistuje, ci combo s danym IDckom uz existuje
  result := false;

  for i:=0 to objCombos.Count-1 do
    if Assigned(objCombos[i]) then
      if objCombos[i].ID = comboId then
        result := true;
end;

function TPanelObject.GetFeatureByID(fid: integer): TFeatureObject;
var
  i: integer;
begin
  result := nil;
  for i:=0 to objFeatures.Count-1 do
    if objFeatures[i].ID = fid then begin
      result := objFeatures[i];
      Break;
    end;
end;

function TPanelObject.GetFeaturesAt(var poleNajdenych: TPoleIntegerov; bod_x, bod_y: integer): boolean;
var
  i: integer;
  bod_mm: TMyPoint;
  najdeneComba: TStringList;
begin
  najdeneComba := TStringList.Create;

  bod_mm := MyPoint( MM(bod_x, 'x'), MM(bod_y, 'y') );
  SetLength(poleNajdenych, 0);

  for i:=0 to objFeatures.Count-1 do
    if Assigned(objFeatures[i]) then
      if (not objFeatures[i].Locked) AND (objFeatures[i].IsOnPoint(bod_mm)) AND (objFeatures[i].Strana = _PNL.StranaVisible) then begin
        if objFeatures[i].ComboID = -1 then begin
          // Ak sa objekt nachadza na bode kliknutia, zvacsi pole najdenych o jedna
          // a tento objekt do toho pola prida.
          SetLength(poleNajdenych, Length(poleNajdenych)+1 );            // zvacsime pole
          poleNajdenych[ Length(poleNajdenych)-1 ] := objFeatures[i].ID; // a pridame najdene ID do pola
        end else begin
          // Ak je objekt sucastou comba, pozrie sa do pola najdenych combo objektov
          // a ak este to combo nezapocital do najdenych, prida ho
          // ale pri dalsom objekte z toho comba ho uz nezapocita
          if najdeneComba.IndexOf(IntToStr(objFeatures[i].ComboID)) = -1 then begin
            najdeneComba.Add( IntToStr(objFeatures[i].ComboID) );
            SetLength(poleNajdenych, Length(poleNajdenych)+1 );            // zvacsime pole
            poleNajdenych[ Length(poleNajdenych)-1 ] := objFeatures[i].ID; // a pridame najdene ID do pola
          end;
        end;
      end;

  result := (Length(poleNajdenych) > 0); // este nastavime navratovu hodnotu (TRUE = nasiel sa aspon jeden)
  najdeneComba.Free;
end;

procedure TPanelObject.GetComboFeatures(var poleObjektov: TPoleIntegerov; comboID: integer);
var
  i: integer;
begin
  // naplni dodane pole ID-ckami vsetkych objektov, ktore patria do daneho comba

  SetLength(poleObjektov, 0);

  for i:=0 to objFeatures.Count-1 do
    if Assigned(objFeatures[i]) then
      if objFeatures[i].ComboID = comboID then begin
        SetLength(poleObjektov, Length(poleObjektov)+1 );                // zvacsime pole
        poleObjektov[ Length(poleObjektov)-1 ] := objFeatures[i].ID; // a pridame najdene ID do pola
      end;
end;

function TPanelObject.GetCenterPosBack: byte;
begin
  if objStranaVisible = 1 then
    result := objSideZeroes[2]
  else
    result := objSideZeroes[1];
end;

function TPanelObject.GetCenterPosByNum(num: Byte): Byte;
begin
  Result := objSideZeroes[num];
end;

function TPanelObject.GetComboBoundingBox(comboID: integer): TMyRect;
var
  poleComboObj: TPoleIntegerov;
  i: integer;
  tmp_box: TMyRect;
begin
  GetComboFeatures( poleComboObj, comboID );
  for i:=0 to High(poleComboObj) do begin
    // pri prvom prvku dame jeho box cely ako je do vysledku
    if i=0 then result := GetFeatureByID(poleComboObj[i]).BoundingBox
    else begin
      // pri kazdom dalsom budeme tento box rozsirovat (ak je treba)
      tmp_box := GetFeatureByID(poleComboObj[i]).BoundingBox;
      result.TopL.X := Min( result.TopL.X , tmp_box.TopL.X );
      result.TopL.Y := Max( result.TopL.Y , tmp_box.TopL.Y );
      result.BtmR.X := Max( result.BtmR.X , tmp_box.BtmR.X );
      result.BtmR.Y := Min( result.BtmR.Y , tmp_box.BtmR.Y );
    end;
  end;
end;

function TPanelObject.GetComboByID(cid: integer): TComboObject;
var
  i: integer;
begin
  result := nil;
  for i := 0 to objCombos.Count-1 do begin
    if (objCombos[i].ID = cid) then
      result := objCombos[i];
  end;
end;


procedure TPanelObject.DelSelected;
var
  i: integer;
  ids: TPoleIntegerov;
begin
  PrepareUndoStep;
  // skopirujeme ficre-na-zmazanie do undo pola (kym este maju pridelene comboID)
  for i := 0 to objFeatures.Count-1 do
    if objFeatures[i].Selected then begin
      CreateUndoStep('DEL', 'FEA', objFeatures[i].ID);
      // odlozime si ID vsetkych, co treba vymazat
      SetLength( ids, Length(ids)+1 );
      ids[ Length(ids)-1 ] := objFeatures[i].ID;
    end;
  // zmazeme vsetky comba (vyselectovane)
  for i := 0 to objFeatures.Count-1 do
    if (objFeatures[i].Selected) AND (objFeatures[i].ComboID > -1) then begin
      CreateUndoStep('DEL', 'COM', objFeatures[i].ComboID);
      ExplodeCombo(objFeatures[i].ComboID);
    end;
  //a zmazeme aj vsetky ficre
  for i := 0 to High(ids) do
    DelFeatureByID( ids[i] );
end;

procedure TPanelObject.ExplodeCombo(comboID: integer);
var
  i: integer;
  delIndex: integer;
begin
  if comboID < 0 then Exit;

  for i:=0 to objFeatures.Count-1 do
    if (Assigned(objFeatures[i])) AND (objFeatures[i].ComboID = comboID) then begin
      objFeatures[i].ComboID := -1;
    end;

  delIndex := -1;
  for i:=0 to objCombos.Count-1 do
    if (Assigned(objCombos[i])) AND (objCombos[i].ID = comboID) then
      delIndex := i;

  // nemozem ho odstranit priamo v slucke FOR, lebo ona by potom pokracovala az po uz neexistujuci index
  if delIndex > -1 then begin
    objCombos.Delete(delIndex);
    objCombos.Capacity := objCombos.Count;
  end;
end;

procedure TPanelObject.DelFeatureByID(fid: integer);
var
  i: integer;
begin
  for i:=0 to objFeatures.Count-1 do
    if (Assigned(objFeatures[i])) AND (objFeatures[i].id = fid) then begin
      objFeatures.Delete(i);
      objHasChanged := true;
      break;
    end;
end;


procedure TPanelObject.KresliZrazenyRoh(c_rohu: byte; x_zrazeneho_rohu_mm, y_zrazeneho_rohu_mm: double; horizontal, vertikal: boolean);
var
  roh, zraz_roh: TPoint;
  priemer_px, polomer_px: integer;
begin
  zraz_roh := Point( PX2(x_zrazeneho_rohu_mm,'x') , PX2(y_zrazeneho_rohu_mm,'y') );
  case c_rohu of
    1: roh := Point( PX2(0,'x') ,        PX2(0,'y') );
    2: roh := Point( PX2(objSirka,'x') , PX2(0,'y') );
    3: roh := Point( PX2(objSirka,'x') , PX2(objVyska,'y')        );
    4: roh := Point( PX2(0,'x') ,        PX2(objVyska,'y')        );
  end;

  with BackPlane.Canvas do begin

      priemer_px := PX((objRadius-objHranaRozmer)*2);
      polomer_px := PX((objRadius-objHranaRozmer));

      if horizontal AND vertikal then
        if (objHranaRozmer < objRadius) then begin
          case c_rohu of
            1: Arc(zraz_roh.X, zraz_roh.Y, zraz_roh.X+priemer_px+1, zraz_roh.Y-priemer_px-1, -9999, zraz_roh.Y-polomer_px, zraz_roh.X+polomer_px, 9999);
            2: Arc(zraz_roh.X, zraz_roh.Y, zraz_roh.X-priemer_px-1, zraz_roh.Y-priemer_px-1, zraz_roh.x-polomer_px, 9999, 9999, zraz_roh.Y-polomer_px);
            3: Arc(zraz_roh.X, zraz_roh.Y, zraz_roh.X-priemer_px-1, zraz_roh.Y+priemer_px+1, 9999, zraz_roh.Y+polomer_px, zraz_roh.X-polomer_px, -9999);
            4: Arc(zraz_roh.X, zraz_roh.Y, zraz_roh.X+priemer_px+1, zraz_roh.Y+priemer_px+1, zraz_roh.X+polomer_px, -9999, -9999, zraz_roh.Y+polomer_px);
          end;
        end
        else
          if (objRadius = 0) then begin // ak je roh bez radiusu, nakreslime diagonal ciaru
            MoveTo( roh.X, roh.Y );
            LineTo( zraz_roh.X, zraz_roh.Y );
          end
          else
      else begin

        if (objRadius = 0) then polomer_px := PX(objHranaRozmer);

        if horizontal then
          if (c_rohu = 1) OR (c_rohu = 4) then begin
            MoveTo( roh.X,      zraz_roh.Y );
            LineTo( zraz_roh.X+polomer_px+1, zraz_roh.Y );
          end else begin
            MoveTo( roh.X,      zraz_roh.Y );
            LineTo( zraz_roh.X-polomer_px-1, zraz_roh.Y );
          end;

        if vertikal then
          if (c_rohu = 1) OR (c_rohu = 2) then begin
            MoveTo( zraz_roh.X, roh.Y );
            LineTo( zraz_roh.X, zraz_roh.Y-polomer_px-1 );
          end else begin
            MoveTo( zraz_roh.X, roh.Y );
            LineTo( zraz_roh.X, zraz_roh.Y+polomer_px+1 );
          end;

      end;

  end;
end;

procedure TPanelObject.Draw(copyCanvas: Boolean = True);
var
  i, j: integer;
  center: TPoint;
  center_radius: integer;
  rect: TRect;
  hranaStart: double;
  gridStepPx: Integer;
  gridStepMm: Single;
  gridOffset: TMyPoint;
  rPX: Integer;
  rohC1PX: array [0..1] of integer;
  rozmeryPX: array [0..1] of Integer;
{$IFDEF DEBUG}
  CPUTimestampStart, CPUTimestampEnd: Int64;
  FPS: Double;
{$ENDIF}
begin
  if not Assigned(BackPlane) then EXIT;

{$IFDEF DEBUG}
  QueryPerformanceCounter(CPUTimestampStart);
{$ENDIF}

  SetZoom;

  if (objPovrch = 'elprirodny') then begin
    objBgndCol := farbaBgndTmavy;
    objSurfCol := farbaPovrchEloxNatural;
  end else if (objPovrch = 'elcierny') then begin
    objBgndCol := farbaBgndSvetly;
    objSurfCol := farbaPovrchEloxBlack;
  end else if (objPovrch = 'surovy') OR (objPovrch = 'bruseny') then begin
    objBgndCol := farbaBgndTmavy;
    objSurfCol := farbaPovrchSurovy;
  end;

  objBordCol := clGray;

  with BackPlane.Canvas do begin
    // zmazanie platna
    Pen.Width := 1;
    Pen.Style := psSolid;
    Pen.Mode  := pmCopy;
    Brush.Style := bsSolid;

    // pozadie uz nemusim vykreslovat osobitne, lebo sa vykresluje panel a 4 pruhy pozadia okolo neho (neskor)
    Pen.Color := objBgndCol;
    Brush.Color := objBgndCol;
//    Rectangle(0,fmain.ToolBar1.Height, fMain.ClientWidth,fMain.ClientHeight);

    // vykreslenie samotneho panela
    // najprv celu plochu panela vyplnim pozadim, aby pri paneli so zaoblenymi rohmi bola farba v zaoblenych rohoch farba pozadia
    if objRadius > 0 then begin

      rPX := PX(objRadius); // rozmer zaoblenia v PX
      rohC1PX[0] := PX(objRoh_c1.X, 'x');
      rohC1PX[1] := PX(objRoh_c1.Y, 'y');
      rozmeryPX[0] := PX(objSirka);
      rozmeryPX[1] := PX(objVyska);

      // vykreslenie pozadia rohov
      // #1
      rect.Left := rohC1PX[0];
      rect.Top  := rohC1PX[1];
      rect.Width := rPX;
      rect.Height := -rPX;
      Rectangle(rect);

      // #2
      rect.Left := rohC1PX[0] + rozmeryPX[0];
      rect.Top  := rohC1PX[1];
      rect.Width := -rPX;
      rect.Height := -rPX;
      Rectangle(rect);

      // #3
      rect.Left := rohC1PX[0] + rozmeryPX[0];
      rect.Top  := rohC1PX[1] - rozmeryPX[1];
      rect.Width := -rPX;
      rect.Height := rPX;
      Rectangle(rect);

      // #4
      rect.Left := rohC1PX[0];
      rect.Top  := rohC1PX[1] - rozmeryPX[1];
      rect.Width := rPX;
      rect.Height := rPX;
      Rectangle(rect);

    end;

    // teraz uz panel
    Pen.Color := objBordCol;
    Brush.Color := objSurfCol;
    RoundRect(  objDrawOffsetX + objZoomOffsetX,
                objDrawOffsetY + objZoomOffsetY,
                objDrawOffsetX + objZoomOffsetX + Px(objSirka) + 1,
                objDrawOffsetY + objZoomOffsetY + Px(objVyska) + 1,
                Px(objRadius*2), Px(objRadius*2)
             );


    // snapping grid
    // pre vykreslenie v 'XOR' rezime sa hodia tieto rezimy (pre bielu farbu): Not, Maskpennot, Notmask, Xor
    if fGuides.comShowGrid.ItemIndex > gridNone then begin

      // prevencia prehusteneho gridu
      gridStepPx := PX(objGrid);
      gridStepMm := objGrid;
      if gridStepPx < 1 then gridStepPx := 1;  // moze sa stat, ze je to nula ked grid je 0.5mm a Zoom je 0.998 tak 0.5 * 0.998 je po zaokruhleni nula !
      while gridStepPx < 10 do begin
        gridStepPx := gridStepPx * 2;
        gridStepMm := gridStepMm * 2;
      end;

      { TODO -oenovacek -c : upravit tak, aby sa polia nastavovali a pocitali len pre viditelnu cast panela }
      SetLength(objGridPointsX, Round(objSirka / gridStepMm));
      SetLength(objGridPointsY, Round(objVyska / gridStepMm));

      // offset vykreslovania gridu pri roznych nul.bodoch
      SetRoh_c1;
      gridOffset := objRoh_c1;

      for i := 0 to High(objGridPointsX) do
        objGridPointsX[i] := PX( (gridStepMm * i) + gridOffset.X , 'x');
      for i := 0 to High(objGridPointsY) do
        objGridPointsY[i] := PX( (gridStepMm * i) + gridOffset.Y , 'y');

      if fGuides.comShowGrid.ItemIndex = gridDots then begin
        Pen.Color := objBgndCol;
        for i := 0 to High(objGridPointsX) do begin
          if (objGridPointsX[i] > 0) AND (objGridPointsX[i] < fMain.ClientWidth) then
            for j := 0 to High(objGridPointsY) do begin
              if (objGridPointsY[j] > 20) AND (objGridPointsY[j] < fMain.ClientHeight) then begin
                MoveTo( objGridPointsX[i] , objGridPointsY[j] );
                LineTo( objGridPointsX[i]+1 , objGridPointsY[j] );
              end;
            end;
        end;
      end;

      if fGuides.comShowGrid.ItemIndex = gridLines then begin
        Pen.Color := objBordCol;
        Pen.Style := psDot;
        for i := 0 to High(objGridPointsX) do begin
          if (objGridPointsX[i] > 0) AND (objGridPointsX[i] < fMain.ClientWidth) then begin
            MoveTo( objGridPointsX[i] , PX(gridOffset.Y, 'y') );
            LineTo( objGridPointsX[i] , PX(objVyska + gridOffset.Y, 'y'));
          end;
        end;

        for j := 0 to High(objGridPointsY) do begin
          if (objGridPointsY[j] > 20) AND (objGridPointsY[j] < fMain.ClientHeight) then begin
            MoveTo( PX(gridOffset.X, 'x') , objGridPointsY[j] );
            LineTo( PX(objSirka + gridOffset.X, 'x') , objGridPointsY[j] );
          end;
        end;
      end;
    end;


    // vykreslenie pripadnej zrazenej hrany
    if (objHranaStyl = 'cham45') then begin
      if objStranaVisible = 1 then begin
        Pen.Color := clOlive;
        Pen.Style := psSolid;
      end else begin
        Pen.Color := clGreen;
        Pen.Style := psDash;
      end;
      Brush.Style := bsClear;

      hranaStart := Max(objRadius,objHranaRozmer);
      // spodna hrana
      if objHranaObrobenaBottom then begin
        MoveTo( PX2(hranaStart,'x') , PX2(objHranaRozmer,'y'));
        LineTo( PX2(objSirka - hranaStart,'x') , PX2(objHranaRozmer,'y'));
      end;
      // prava hrana
      if objHranaObrobenaRight then begin
        MoveTo( PX2(objSirka-objHranaRozmer,'x') , PX2(hranaStart,'y'));
        LineTo( PX2(objSirka-objHranaRozmer,'x') , PX2(objVyska - hranaStart,'y'));
      end;
      // vrchna hrana
      if objHranaObrobenaTop then begin
        MoveTo( PX2(objSirka-hranaStart,'x') , PX2(objVyska-objHranaRozmer,'y'));
        LineTo( PX2(hranaStart,'x') , PX2(objVyska-objHranaRozmer,'y'));
      end;
      // lava hrana
      if objHranaObrobenaLeft then begin
        MoveTo( PX2(objHranaRozmer,'x') , PX2(objVyska - hranaStart,'y'));
        LineTo( PX2(objHranaRozmer,'x') , PX2(hranaStart,'y'));
      end;

      // roh c.1
      KresliZrazenyRoh(1, objHranaRozmer, objHranaRozmer, objHranaObrobenaBottom, objHranaObrobenaLeft);
      KresliZrazenyRoh(2, objSirka-objHranaRozmer, objHranaRozmer, objHranaObrobenaBottom, objHranaObrobenaRight);
      KresliZrazenyRoh(3, objSirka-objHranaRozmer, objVyska-objHranaRozmer, objHranaObrobenaTop, objHranaObrobenaRight);
      KresliZrazenyRoh(4, objHranaRozmer, objVyska-objHranaRozmer, objHranaObrobenaTop, objHranaObrobenaLeft);

    end;
  end;

  // kresli cosmetic prvky, ktore maju byt prekryte ostatnymi (napr. zrazenie hran)
  for i:=0 to objFeatures.Count-1 do
    objFeatures[i].Draw_CosmeticLowPriority;

  // kresli prvky, ktore nie su skrz (kapsy napr.)
  for i:=0 to objFeatures.Count-1 do
    if (objFeatures[i].Typ = ftPolyLineGrav) then
      (objFeatures[i] as TFeaturePolyLineObject).Draw // mozno trochu nestandardne - ale v Class Polyline neviem volat Draw() automatizovane, tak takto rucne ju volam - gravirovane objekty
    else
      objFeatures[i].Draw_Blind;

  // najprv objekty, ktore nejdu skrz
//  for i:=0 to objFeatures.Count-1 do
//    if (objFeatures[i].Hlbka1 < 9999) then
//      if (objFeatures[i].Typ = ftPolyLineGrav) then
//        (objFeatures[i] as TFeaturePolyLineObject).Draw // mozno trochu nestandardne - ale v Class Polyline neviem volat Draw() automatizovane, tak takto rucne ju volam - gravirovane objekty
//      else
//        objFeatures[i].Draw_Through;

  // kresli objekty, ak su skrz
  for i:=0 to objFeatures.Count-1 do
    objFeatures[i].Draw_Through;

  // kresli cosmetic prvky objektov (napr. 3/4 kruh na zavite)
  for i:=0 to objFeatures.Count-1 do
    objFeatures[i].Draw_Cosmetic;

  // teraz "osekneme" zobrazenie objektov mimo panela (napr. kapsa, co presahuje mimo panel)
  RedrawSurrounding;

  // kresli cosmetic prvky - tie sa zobrazuju aj mimo panela
  for i:=0 to objFeatures.Count-1 do
    objFeatures[i].Draw_CosmeticHighPriority;

  // ten co je highlightovany - zvycajne len 1 objekt
  DrawHighlightedOnly(false);

  // a este raz - tie, co su vyselectovane - tak ich selectovaci ramik
  objSelCombosDrawn := ''; // (pre vysvetlenie pozri deklaraciu)
  for i:=0 to objFeatures.Count-1 do
    objFeatures[i].DrawSelected;

  // a nakoniec este guideliney
  if cfg_ShowGuides then
    for i:=0 to objGuides.Count-1 do
        objGuides[i].Draw;

  objCurrentSide := objStranaVisible;
  // vykreslenie pociatku suradneho systemu
  case objSideZeroes[objStranaVisible] of
    cpLT : center := Point(
        objDrawOffsetX + objZoomOffsetX,
        objDrawOffsetY + objZoomOffsetY
        );

    cpLB : center := Point(
        objDrawOffsetX + objZoomOffsetX,
        objDrawOffsetY + objZoomOffsetY + Px(objVyska)
        );

    cpRT : center := Point(
        objDrawOffsetX + objZoomOffsetX + Px(objSirka),
        objDrawOffsetY + objZoomOffsetY
        );

    cpRB : center := Point(
        objDrawOffsetX + objZoomOffsetX + Px(objSirka),
        objDrawOffsetY + objZoomOffsetY + Px(objVyska)
        );

    cpCEN : center := Point(
        objDrawOffsetX + objZoomOffsetX + Px(objSirka/2),
        objDrawOffsetY + objZoomOffsetY + Px(objVyska/2)
        );
  end;

{
************** ak sa panel zrkadli, treba to takto: *******************
    if objCenterPos = 'TL' then
      center := Point(
        objDrawOffsetX + objZoomOffsetX + Px(SirkaPolovica - objMirrorX*SirkaPolovica),
        objDrawOffsetY + objZoomOffsetY + Px(VyskaPolovica - objMirrorY*VyskaPolovica)
        );
    if objCenterPos = 'BL' then
      center := Point(
        objDrawOffsetX + objZoomOffsetX + Px(SirkaPolovica - objMirrorX*SirkaPolovica),
        objDrawOffsetY + objZoomOffsetY + Px(VyskaPolovica + objMirrorY*VyskaPolovica)
        );
    if objCenterPos = 'TR' then
      center := Point(
        objDrawOffsetX + objZoomOffsetX + Px(SirkaPolovica + objMirrorX*SirkaPolovica),
        objDrawOffsetY + objZoomOffsetY + Px(VyskaPolovica - objMirrorY*VyskaPolovica)
        );
    if objCenterPos = 'BR' then
      center := Point(
        objDrawOffsetX + objZoomOffsetX + Px(SirkaPolovica + objMirrorX*SirkaPolovica),
        objDrawOffsetY + objZoomOffsetY + Px(VyskaPolovica + objMirrorY*VyskaPolovica)
        );
    if objCenterPos = 'C'  then
      center := Point(
        objDrawOffsetX + objZoomOffsetX + Px(SirkaPolovica),
        objDrawOffsetY + objZoomOffsetY + Px(VyskaPolovica)
        );
}
  center_radius := 5;
  with BackPlane.Canvas do begin
    Pen.Width := 1;
    Pen.Color := clBlack;
    Pen.Style := psSolid;
    Pen.Mode  := pmCopy;
    Brush.Style := bsSolid;
    Brush.Color := clYellow;
    Rectangle( center.X, center.Y-1, center.X+center_radius+10, center.Y+2 );
    Rectangle( center.X-1, center.Y, center.X+2, center.Y-center_radius-10 );
{
************** ak sa panel zrkadli, treba to takto: *******************
      Rectangle( center.X, center.Y-1, center.X+(center_radius+10)*objMirrorX, center.Y+2 );
      Rectangle( center.X-1, center.Y, center.X+2, center.Y-(center_radius+10)*objMirrorY );
}
    Ellipse( center.X-center_radius, center.Y-center_radius, center.X+center_radius, center.Y+center_radius );

    Font.Size := 8;
    Font.Color := clYellow;
    Font.Name := 'Tahoma';
    Pen.Color := clYellow;
    Brush.Color := clBlack;
    TextOut( center.X + center_radius + 15 , center.Y-6 , 'X' );
    TextOut( center.X-3 , center.Y - center_radius - 24 , 'Y' );
{
************** ak sa panel zrkadli, treba to takto: *******************
    TextOut( center.X+((center_radius+15)*objMirrorX)-3, center.Y-6, 'X' );
    TextOut( center.X-3, center.Y-((center_radius+18)*objMirrorY)-6, 'Y' );
}

{$IFDEF DEBUG}
  QueryPerformanceCounter(CPUTimestampEnd);

  FPS := CPUTimestampFrequency / (CPUTimestampEnd - CPUTimestampStart);

  Font.Size := 20;
  TextOut( 10, 70, 'FPS: ' + FloatToStr(FPS));
  TextOut( 10, 100, 'avg: ' + FloatToStr(FPSavg));

  FPSsum := FPSsum + FPS;
  Inc(FPSsumCount);

  if FPSsumCount = 100 then begin
    FPSavg := RoundTo(FPSsum / FPSsumCount, -2);
    FPSsum := 0;
    FPSsumCount := 0;
  end;


{$ENDIF}

  end;

  if multiselectShowing then MultiselectTlacitka.Draw(false);

  // na zaver sa cely vykresleny panel skopiruje na viditelnu canvas
  if (copyCanvas) then begin
    rect := fMain.Canvas.ClipRect;
    fMain.Canvas.CopyRect(rect, BackPlane.Canvas, rect);
  end;
end;

procedure TPanelObject.DrawHighlightedOnly(copyCanvas: Boolean = True);
var
  i: Integer;
  rect: TRect;
begin
  // ten co je highlightovany - zvycajne len 1 objekt
  for i:=0 to objFeatures.Count-1 do
    if objFeatures[i].Highlighted then
      if (objFeatures[i].Typ = ftPolyLineGrav) then
        (objFeatures[i] as TFeaturePolyLineObject).DrawHighlighted
      else
        objFeatures[i].DrawHighlighted;

  // na zaver sa skopiruje na viditelnu canvas
  if (copyCanvas) then begin
    rect := fMain.Canvas.ClipRect;
    fMain.Canvas.CopyRect(rect, BackPlane.Canvas, rect);
  end;
end;

procedure TPanelObject.SetZoom(zoomVal: Double = 1; curX: integer = 0; curY: integer = 0);
var
  zoomx,zoomy: Double;
  edgeDistPX_x_old: integer;
  edgeDistPX_x_new: integer;
  edgeDistMM_x_old: Double;
  edgeDistPX_y_old: integer;
  edgeDistPX_y_new: integer;
  edgeDistMM_y_old: Double;
begin
  // ochrana pred delenim nulou (pri volani procedury pocas startu)
  if (objSirka = 0) OR (objVyska = 0) then begin
    objZoom := 1;
    Exit;
  end;

  // hranice zoomovania
  if ((zoomVal > 1) AND (objZoom < 50)) OR
     ((zoomVal < 1) AND (objZoom > 1)) then
    objZoomFactor := objZoomFactor * zoomVal; // zoomuje len ak platia tieto 2 podmienky

  // ak bola funkcia zavolana s parametrom ZoomVal = 0, resetne uzivatelsky zoom
  if (zoomVal = 0) then
    objZoomFactor := 1;

  // ak bola funkcia zavolana s parametrami CurX/CurY = -1, resetne uzivatelsky offset
  if (curX = -1) AND (curY = -1) then begin
    objZoomOffsetX := 0;
    objZoomOffsetY := 0;
  end;

  // ulozime si vzdialenost k hrane este pri starom zoome
  edgeDistPX_x_old := curX - objDrawOffsetX - objZoomOffsetX;
  edgeDistPX_y_old := curY - objDrawOffsetY - objZoomOffsetY;
  edgeDistMM_x_old := MM( edgeDistPX_x_old );
  edgeDistMM_y_old := MM( edgeDistPX_y_old );

  // nastavenie zoomu (ak nie je zadany parameter zoomVal, nazoomuje cely panel)
  zoomx := (fMain.ClientWidth - 10) / objSirka;
  zoomy := (fMain.ClientHeight - fMain.ToolBar1.Height - 10 - 20 {status bar}) / objVyska;
  objZoom  := Min(zoomx, zoomy) * objZoomFactor;

  if (curX > 0) AND (curY > 0) then begin  // ochrana pred znicenim hodnoty v objZoomOffsetX(Y) ked sa procedura zavola bez pozicie kurzora
    // este nastavime posunutie celeho vykreslovania - aby mys aj po prezoomovani
    // ostavala nad tym istym miestom panela
    edgeDistPX_x_new := PX( edgeDistMM_x_old );
    edgeDistPX_y_new := PX( edgeDistMM_y_old );
    objZoomOffsetX := objZoomOffsetX + ((edgeDistPX_x_old) - (edgeDistPX_x_new));
    objZoomOffsetY := objZoomOffsetY + ((edgeDistPX_y_old) - (edgeDistPX_y_new));
  end;
end;

procedure TPanelObject.SaveToFile(panelfile: string);
var
  pisar: TStreamWriter;
  i, v: integer;
  vertex: TMyPoint;
  tempStr: string;
  fea: TFeatureObject;
  combo: TComboObject;
  guide: TGuideObject;
  minX, minY, maxX, maxY: double;
  objektMimoPanela: boolean;
  mimoPanelMazat: SmallInt;
begin
  // najprv povodny subor zazalohujeme
  if FileExists(panelfile) then begin
    DeleteFile(panelfile+'.bak');
    RenameFile(panelfile, panelfile+'.bak');
  end;

  pisar := TStreamWriter.Create(panelfile, false, TEncoding.UTF8);

  // panel sa musi ukladat pri zapnutej strane "A"
  // (kym nie je poriadne urobene prepocitavanie suradnic)
  if objStranaVisible = 2 then
    fMain.btnSideSwitch.Click;

  try
    // zapiseme hlavicku
    pisar.WriteLine('{>header}');
    pisar.WriteLine('filetype=quickpanel:panel');
    pisar.WriteLine('filever='     + IntToStr((cfg_swVersion1*10000)+(cfg_swVersion2*100)+cfg_swVersion3));
    pisar.WriteLine('units=mm');
    pisar.WriteLine('sizex='       + FloatToStr(RoundTo(objSirka , -4)));
    pisar.WriteLine('sizey='       + FloatToStr(RoundTo(objVyska , -4)));
    pisar.WriteLine('thickness='   + FloatToStr(RoundTo(objHrubka , -4)));
    pisar.WriteLine('radius1='     + FloatToStr(RoundTo(objRadius , -4)));
    pisar.WriteLine('shape=rect');
    pisar.WriteLine('gridsize='    + FloatToStr(RoundTo(objGrid, -4)));
    pisar.WriteLine('surface='     + objPovrch);
    objCurrentSide := 1;
    pisar.WriteLine('zeropos1='    + IntToStr(GetCenterPos));
    objCurrentSide := 2;
    pisar.WriteLine('zeropos2='    + IntToStr(GetCenterPos));
    pisar.WriteLine('custommater=' + BoolToStr(objMaterialVlastny, true));
    pisar.WriteLine('edgestyle='   + objHranaStyl);
    pisar.WriteLine('edgesize='    + FloatToStr(RoundTo(objHranaRozmer, -4)));
    pisar.WriteLine('edgebottom='  + BoolToStr(objHranaObrobenaBottom, true));
    pisar.WriteLine('edgeright='   + BoolToStr(objHranaObrobenaRight, true));
    pisar.WriteLine('edgetop='     + BoolToStr(objHranaObrobenaTop, true));
    pisar.WriteLine('edgeleft='    + BoolToStr(objHranaObrobenaLeft, true));
    pisar.WriteLine('structfeatures=id,type,comboid,posx,posy,size1,size2,size3,size4,size5,depth,param1,param2,param3,param4,param5,side,locked,vertexarray,name,color'); // MUSIA byt oddelene ciarkami LoadFromFile sa na nich spolieha
    pisar.WriteLine('structcombos=id,posref,posx,posy');
    pisar.WriteLine('structguides=type,param1,param2,param3,side');
    pisar.WriteLine('{/header}');

    // zapiseme combo objekty - musia byt pred ficrami lebo combo moze byt polohovane podla nejakeho svojho objektu - takze pri Loadovani suboru si tu poodkladame vsetky Feature.ID, ktore neskor musime sledovat a podla nich polohovat combo (pri Loadovani sa feature.ID generuje nove)
    pisar.WriteLine('{>combos}');
    for i:=0 to Combos.Count-1 do begin
      combo := Combos[i];
      if Assigned(combo) then begin
        pisar.WriteLine(IntToStr(combo.ID));
        if (combo.PolohaObject = -1) then
          pisar.WriteLine('-1')
        else
          // ak je combo polohovane na nejaky svoj komponent, zapiseme jeho INDEX nie ID (lebo ID sa po OpenFile pomenia)
          pisar.WriteLine(IntToStr(combo.PolohaObject));
          pisar.WriteLine(FloatToStr(RoundTo(combo.X , -4)));
          pisar.WriteLine(FloatToStr(RoundTo(combo.Y , -4)));
      end;
    end;

    pisar.WriteLine('{/combos}');
    // ficre
    pisar.WriteLine('{>features}');

    // skontrolujeme, ci bounding box nejakeho ficru nelezi mimo panela
    // a dame na vyber, ci taketo objekty zmazat
    mimoPanelMazat   := -1; // -1 = este sme sa ho nepytali , 0 = odpovedal NIE , 1 = odpovedal ANO
		i := 0;
    while i < objfeatures.Count do begin   // cez WHILE a nie FOR lebo v cykle menime pocet ficrov (tie mimo panela mozeme mazat)

      fea := objFeatures[i];

      if objSideZeroes[fea.Strana] = cpLB then begin
        minX := 0;
        minY := 0;
        maxX := objSirka;
        maxY := objVyska;
      end;
      if objSideZeroes[fea.Strana] = cpRB then begin
        minX := -objSirka;
        minY := 0;
        maxX := 0;
        maxY := objVyska;
      end;
      if objSideZeroes[fea.Strana] = cpRT then begin
        minX := -objSirka;
        minY := -objVyska;
        maxX := 0;
        maxY := 0;
      end;
      if objSideZeroes[fea.Strana] = cpLT then begin
        minX := 0;
        minY := -objVyska;
        maxX := objSirka;
        maxY := 0;
      end;
      if objSideZeroes[fea.Strana] = cpCEN then begin
        minX := -objSirka/2;
        minY := -objVyska/2;
        maxX := objSirka/2;
        maxY := objVyska/2;
      end;

      if (fea.BoundingBox.TopL.X > maxX)
      	OR (fea.BoundingBox.TopL.Y < minY)
        OR (fea.BoundingBox.BtmR.X < minX)
        OR (fea.BoundingBox.BtmR.Y > maxY)
      then begin
      	objektMimoPanela := true;
        if (mimoPanelMazat = -1) then begin
          case MessageBox(fmain.Handle, PChar(TransTxt('Feature placed out of panel surface has been found.')+#13+TransTxt('Delete such features?')), PChar(TransTxt('Warning')), MB_ICONWARNING OR MB_YESNO OR MB_DEFBUTTON2) of
            ID_YES: mimoPanelMazat := 1;
            ID_NO:  mimoPanelMazat := 0;
            else
              mimoPanelMazat := 0;
          end;
        end;
      end else
      	objektMimoPanela := false;

      if objektMimoPanela AND (mimoPanelMazat = 1) then begin
				Self.DelFeatureByID(fea.ID);
        Continue;
      end;

      if Assigned(fea) then begin
        pisar.WriteLine(IntToStr(fea.ID));  // po nahrati sa ID vygeneruju nove, toto ukladame, len pre zachovanie spojenia s combo objektami
        pisar.WriteLine(IntToStr(fea.Typ));
        pisar.WriteLine(IntToStr(fea.ComboID));
        pisar.WriteLine(FloatToStr(RoundTo(fea.X , -4)));
        pisar.WriteLine(FloatToStr(RoundTo(fea.Y , -4)));
        pisar.WriteLine(FloatToStr(RoundTo(fea.Rozmer1 , -4)));
        pisar.WriteLine(FloatToStr(RoundTo(fea.Rozmer2 , -4)));
        pisar.WriteLine(FloatToStr(RoundTo(fea.Rozmer3 , -4)));
        pisar.WriteLine(FloatToStr(RoundTo(fea.Rozmer4 , -4)));
        pisar.WriteLine(FloatToStr(RoundTo(fea.Rozmer5 , -4)));
        pisar.WriteLine(FloatToStr(RoundTo(fea.Hlbka1 , -4)));
        pisar.WriteLine(fea.Param1);
        pisar.WriteLine(fea.Param2);
        pisar.WriteLine(fea.Param3);
        pisar.WriteLine(fea.Param4);
        pisar.WriteLine(fea.Param5);
        pisar.WriteLine(IntToStr(fea.Strana));
        pisar.WriteLine(BoolToStr(fea.Locked, true));
        // polyline vertexes
        if (fea.Typ <> ftPolyLineGrav) then
          pisar.WriteLine('')
        else begin
          tempStr := '';
          for v := 0 to (fea as TFeaturePolyLineObject).VertexCount-1 do begin
            vertex := (fea as TFeaturePolyLineObject).GetVertex(v);
            tempStr := tempStr + FormatFloat('0.0###',vertex.X)+','+FormatFloat('0.0###',vertex.Y)+separChar;
          end;
          tempStr := Copy(tempStr, 0, Length(tempStr)-1 ); // odstranime posledny separchar
          pisar.WriteLine(tempStr);
        end;
        pisar.WriteLine(fea.Nazov);
        pisar.WriteLine(ColorToString(fea.Farba));
      end;
      Inc(i);
    end;
    pisar.WriteLine('{/features}');

    // ostatne - guideline-y a pod.
    pisar.WriteLine('{>guides}');
    for i:=0 to _PNL.Guides.Count-1 do begin
        guide := _PNL.Guides[i];
        pisar.WriteLine(guide.Typ);
        pisar.WriteLine(FloatToStr(RoundTo(guide.Param1 , -4)));
        pisar.WriteLine(FloatToStr(RoundTo(guide.Param2 , -4)));
        pisar.WriteLine(FloatToStr(RoundTo(guide.Param3 , -4)));
        pisar.WriteLine(IntToStr(guide.Strana));
//      end;
    end;
    pisar.WriteLine('{/guides}');

    objHasChanged := false;
    objFileName := panelfile;
  finally
    pisar.Free;
  end;

  // ak vsetko prebehlo OK, mozeme zmazat zalozny subor
  if FileExists(panelfile+'.bak') then DeleteFile(panelfile+'.bak');

  // ak sme pocas ukladania aj mazali nejake ficre mimo panela, prekreslime panel
  if objektMimoPanela then Self.Draw;
  
end;

procedure TPanelObject.SelectAll;
var
  i: integer;
begin
  for i:=0 to objFeatures.Count-1 do
    if Assigned(objFeatures[i]) then
      if (objFeatures[i].Strana = objStranaVisible) then
        objFeatures[i].Selected := true;
end;

procedure TPanelObject.SelectAllInRect(obdlz: TRect; ciastocne: boolean = false);
var
  i, tmp: integer;
  myrectMM, comboRectMM: TMyRect;
  myrectPX, comboRectPX: TRect;
begin
  for i:=0 to objFeatures.Count-1 do
    if Assigned(objFeatures[i]) then begin

      // ak je lavy viac vpravo ako pravy :) tak ich vymenime a to iste aj o hornom/spodnom
      if obdlz.Left > obdlz.Right then begin
        tmp := obdlz.Left;
        obdlz.Left := obdlz.Right;
        obdlz.Right := tmp;
      end;
      if obdlz.Bottom < obdlz.Top then begin
        tmp := obdlz.Bottom;
        obdlz.Bottom := obdlz.Top;
        obdlz.Top := tmp;
      end;

      myrectMM := objFeatures[i].BoundingBox;
      myrectPX.Left  := PX(myrectMM.TopL.X, 'x');
      myrectPX.Right := PX(myrectMM.BtmR.X, 'x');
      myrectPX.Top   := PX(myrectMM.TopL.Y, 'y');
      myrectPX.Bottom:= PX(myrectMM.BtmR.Y, 'y');

      if (myrectPX.Left > obdlz.Left) AND (myrectPX.Right < obdlz.Right) AND
         (myrectPX.Top > obdlz.Top)   AND (myrectPX.Bottom < obdlz.Bottom) AND
         (objFeatures[i].Strana = objStranaVisible) then
        if (objFeatures[i].ComboID = -1) then
          // ak objekt nie je sucastou ziadneho comba, jednoducho ho vyselectujeme
          objFeatures[i].Selected := true
        else begin
          // ak je sucastou nejakeho comba, zistime ci aj ostatne objekty
          // comba lezia vo vyberovom obdlzniku a ak ano, vyberieme cele combo
          comboRectMM := GetComboBoundingBox( objFeatures[i].ComboID );
          comboRectPX.Left  := PX(comboRectMM.TopL.X, 'x');
          comboRectPX.Right := PX(comboRectMM.BtmR.X, 'x');
          comboRectPX.Top   := PX(comboRectMM.TopL.Y, 'y');
          comboRectPX.Bottom:= PX(comboRectMM.BtmR.Y, 'y');
          if (comboRectPX.Left > obdlz.Left) AND (comboRectPX.Right < obdlz.Right) AND
             (comboRectPX.Top > obdlz.Top)   AND (comboRectPX.Bottom < obdlz.Bottom) then
            SelectCombo( objFeatures[i].ComboID );
        end;

      // ak treba vybrat aj len pretate, otestujeme aj tuto podmienku
      if (ciastocne) then begin
        if (obdlz.Right > myrectPX.Left) AND (obdlz.Left < myrectPX.Right) AND
           (obdlz.Top < myrectPX.Bottom) AND (obdlz.Bottom > myrectPX.Top) AND
           (objFeatures[i].Strana = objStranaVisible) then
          if (objFeatures[i].ComboID = -1) then begin
            // ak objekt nie je sucastou ziadneho comba, jednoducho ho vyselectujeme
            objFeatures[i].Selected := true;
          end else begin
            SelectCombo( objFeatures[i].ComboID );
          end;
      end;  // if (ciastocne) then

    end;
end;

procedure TPanelObject.SelectCombo(comboID: integer; sel_state: boolean = true);
var
  i: integer;
begin
  // ak nie je uvedeny 2. parameter, vyselectuje combo
  // ak je ale explicitne "false", tak ho deselectuje
  if comboID > -1 then
    for i:=0 to objFeatures.Count-1 do
      if Assigned(objFeatures[i]) then
        if (objFeatures[i].ComboID = comboID) AND (not objFeatures[i].Locked) then
          objFeatures[i].Selected := sel_state;
end;

procedure TPanelObject.DeselectAll;
var
  i: integer;
begin
  for i:=0 to objFeatures.Count-1 do
    if Assigned(objFeatures[i]) then
      objFeatures[i].Selected := false;
end;

function TPanelObject.GetSelectedFeaturesNum: TMyInt2x;
var
  i: integer;
  tmp_str: string; // akesi pole na ukladanie cisel vyselectovanych combo prvkov, napr: '1#3#120#9#'
begin
  result.i1 := 0; // pocet vyselectovanych featurov (kazde combo je za 1)
  result.i2 := 0; // pocet vyselectovanych LEN combo featurov
  tmp_str := '';
  for i:=0 to objFeatures.Count-1 do
    if (Assigned(objFeatures[i]) AND objFeatures[i].Selected ) then
      // ak je v combe, zistime, ci sme uz toto combo zapocitali
      if (objFeatures[i].ComboID > -1) then begin

        if ( Pos(IntToStr(objFeatures[i].ComboID)+'#',tmp_str) = 0) then begin
          // ak je v combe a toto combo sme este neriesili, ulozime jeho cislo do "pola" a zapocitame ho
          tmp_str := tmp_str + IntToStr(objFeatures[i].ComboID) + '#';
          Inc(result.i2);
        end;

      end else begin
        Inc(result.i1);
      end;
end;


procedure TPanelObject.LoadFont(fontfilename: string);
var
  rider: TStreamReader;
  lajna: string;
  i, indexZnaku, fontIndex: integer;
  strPoints, strPointData: TStringList;
  NahravanyFont: TMyFont;
  NahravanyZnak: TMyZnak;
begin
	// najprv zistime, ci dany font uz nie je nahraty vo fontoch - ak ano, tak rovno exit
  fontIndex := objFonty.IndexOf(fontfilename);
  if fontIndex > -1 then
  	Exit
  else begin
  	if not FileExists(ExtractFilePath(Application.ExeName)+'\\'+fontfilename) then begin
    	fMain.Log('Font file not found: '+ExtractFilePath(Application.ExeName)+'\\'+fontfilename);
    	MessageBox(0, PChar(TransTxt('Font file not found:')+' '+fontfilename), PChar(TransTxt('Error')), MB_ICONERROR);
    	Exit;
    end;
    fontIndex := objFonty.AddObject(fontfilename, TMyFont.Create() );
  end;

  // placeholder pre font, ktory nahravam
  NahravanyFont := TMyFont(objFonty.Objects[fontIndex]);

	// nahratie dat pre dany font zo suboru
	FormatSettings.DecimalSeparator := '.';
  strPoints := TStringList.Create;
  strPointData := TStringList.Create;
  rider := TStreamReader.Create( ExtractFilePath(Application.ExeName)+'\\'+fontfilename, TEncoding.Unicode );
  try
  	// kontrola spravneho formatu suboru
  	while (lajna <> '{/header}') do begin
    	lajna := rider.ReadLine;
      if (Pos('filetype',lajna) > 0) AND (Pos('quickpanel:font', lajna) = 0 ) then begin
        strPoints.Free;
        strPointData.Free;
      	rider.Free;
      	Exit;
      end;
    end;
    // nacitavanie samotnych pismeniek do pola
    while not rider.EndOfStream do begin
      if Pos('=', lajna) > 0 then begin
      	// nasiel sa riadok s definiciou pismenka, tak ho podme nacitat
        if Pos('=', lajna) = 7 then   // "rovnasa" znak sa neda klasickym sposobom, takze je (v subore fontu) nahradeny slovom "equals" a separator "=" je teda az na 7. pozicii
        	indexZnaku := Ord(Char('='))
        else
        	indexZnaku := Ord(Char(lajna[1]));
        NahravanyZnak := NahravanyFont.PridajZnak(indexZnaku);
        //....nacitanie samotneho znaku (rozparsovat lajnu)....
        strPoints.Clear;
        ExplodeStringSL( Copy(lajna, Pos('=', lajna)+1 ), '#', strPoints);
        NahravanyZnak.NastavPocetBodov(strPoints.Count);
				NahravanyZnak.SirkaZnaku := 0;
        for i := 0 to strPoints.Count-1 do begin
        	strPointData.Clear;
          ExplodeStringSL(strPoints[i], ',', strPointData);
          NahravanyZnak.Points[i].kresli := (strPointData[0] = '1');
          NahravanyZnak.Points[i].bod.X := StrToFloat(strPointData[1]);
          NahravanyZnak.Points[i].bod.Y := StrToFloat(strPointData[2]);
          NahravanyZnak.SirkaZnaku := Max(NahravanyZnak.SirkaZnaku , NahravanyZnak.Points[i].bod.X);
        end;
        // este nacitame sirku medzery za znakom (hned z nasledujuceho riadku v subore)
        lajna := rider.ReadLine;
				NahravanyZnak.SirkaMedzery := StrToFloat(lajna);
    	end;
    	lajna := rider.ReadLine;
    end;
  finally
    rider.Free;
    strPoints.Free;
    strPointData.Free;
  end;
  // pre vsetky znaky, ktore sa v subore fontu nenasli a su prazdne nastavime ako default velku sirku znaku,
  // aby ked user zada taky znak, tak to hned zbadal tak, ze bude mat na jeho mieste v texte velku medzeru
//  for i := 0 to High(fontDin17i_cp1250) do
//    if Length(fontDin17i_cp1250[i].body) = 0 then
//    	fontDin17i_cp1250[i].sirkaZnaku := sirkaNeznamehoZnaku;
end;

procedure TPanelObject.LoadFromFile(panelfile: string);
type
  comboMap = record
    id: integer;
    pos_ref: integer;
end;
var
  comboMapping: array of comboMap;
  rider: TStreamReader;
  lajn: string;
  hlavicka, paramsList: TStringList;
  currSoftVersion, I, J: integer;
  newfea: TFeatureObject;
  newcombo: TComboObject;
  poleParams, poleVertexy: TPoleTextov;
  vertex: TMyPoint;
  lastSucessfulOperation: string;
  lineNumber: integer;
begin
  if not FileExists(panelfile) then begin
    MessageBox(Application.ActiveFormHandle, PChar(TransTxt('File not found: ')+panelfile), PChar(TransTxt('Error')), MB_ICONERROR);
    Exit;
  end;
  objHasChanged := true;
  // detekcia stareho formatu suboru (do 0.3.10)
  rider := TStreamReader.Create(panelfile, TEncoding.UTF8);
  lajn := rider.ReadLine; Inc(lineNumber);
  rider.Free;
  if (lajn = '[Panel]') then begin
    objVersion := 310;
    LoadFromFile_old(panelfile);
    Exit;
  end;

  // nahravanie noveho formatu suboru
  hlavicka := TStringList.Create;
  rider := TStreamReader.Create(panelfile, TEncoding.UTF8);
  try
    lajn := rider.ReadLine;  Inc(lineNumber);
    if (lajn = '{>header}') then begin // 1.riadok musi byt zaciatok hlavicky
      // najprv nacitanie hlavicky
      while (lajn <> '{/header}') do begin
        lajn := rider.ReadLine;  Inc(lineNumber);
        if (Pos('=', lajn) > 0) then begin
          hlavicka.Add(lajn);
        end; // if (Pos('=', lajn) > 0)
      end; // while (lajn <> '{/header}')

      // kontrola, ci sa skutocne jedna o subor panela
      if hlavicka.Values['filetype'] <> 'quickpanel:panel' then begin
        raise Exception.Create( PChar(TransTxt('File is not a QuickPanel file.') + ' ('+hlavicka.Values['filetype']+')') );
      end;

      // spracovanie hlavicky - kontrola verzie suboru
      currSoftVersion := (cfg_swVersion1*10000)+(cfg_swVersion2*100)+cfg_swVersion3;
      objVersion := StrToInt(hlavicka.Values['filever']);
{$IFNDEF DEBUG}
      if (objVersion > currSoftVersion) then begin
        MessageBox(Application.ActiveFormHandle, PChar(TransTxt('File was saved by newer version of the QuickPanel. It might not open correctly.')), PChar(TransTxt('Warning')), MB_ICONWARNING);
      end;
{$ELSE}
// nech ma pri debugovani neotravuje (v debugu je verzia softu = 1.0.0)
{$ENDIF}
      lastSucessfulOperation := 'hlavicka nacitana do stringlistu';
      // spracovanie hlavicky - udaje o samotnom paneli
      objFileName := panelfile;
      objSirka       := StrToFloat(hlavicka.Values['sizex']);
      objVyska       := StrToFloat(hlavicka.Values['sizey']);
      objHrubka      := StrToFloat(hlavicka.Values['thickness']);
      objRadius      := StrToFloat(hlavicka.Values['radius1']);
      objPovrch      := hlavicka.Values['surface'];
      objHranaStyl   := hlavicka.Values['edgestyle']; if objHranaStyl='' then objHranaStyl := '0';
      objHranaRozmer := StrToFloat(hlavicka.Values['edgesize']);
      objHranaObrobenaBottom := StrToBool(hlavicka.Values['edgebottom']);
      objHranaObrobenaRight  := StrToBool(hlavicka.Values['edgeright']);
      objHranaObrobenaTop    := StrToBool(hlavicka.Values['edgetop']);
      objHranaObrobenaLeft   := StrToBool(hlavicka.Values['edgeleft']);
      objGrid        := StrToFloat(hlavicka.Values['gridsize']);
      SetCenterPosByNum( StrToInt(hlavicka.Values['zeropos1']), 1);
      SetCenterPosByNum( StrToInt(hlavicka.Values['zeropos2']), 2);
      CurrentSide := 1;
      MaterialVlastny := StrToBool(hlavicka.Values['custommater']);
      if not StrToBool( uConfig.Config_ReadValue('material_custom_available') ) then MaterialVlastny := false;

    	SetZoom(0, -1, -1);

    end else begin // if lajn = '{>header}'
      raise Exception.Create(PChar(TransTxt('File is corrupted.')));
    end;

    lastSucessfulOperation := 'hlavicka uspesne nacitana & spracovana';

    paramsList := TStringList.Create;

    // ********************* nacitanie combo objektov **************************
    while (lajn <> '{>combos}') AND (not rider.EndOfStream) do begin
      // presun na zaciatok sekcie COMBOS
      lajn := rider.ReadLine;
      Inc(lineNumber);
    end;

    if lajn <> '{>combos}' then raise Exception.Create(PChar(TransTxt('File is corrupted.')));
    paramsList.Clear;                                    // init
    SetLength(poleParams, 0);                            // init
    ExplodeString( hlavicka.Values['structcombos'], ',', poleParams); // do pola naplnime zaradom parametre v poradi ako su zapisane do fajlu
    lajn := rider.ReadLine;  Inc(lineNumber);                      // nacitame dalsi riadok, aby sme vedeli, ci je sekcia prazdna (riadok = uzatvaracia znacka) alebo je tam nejaky objekt
    lastSucessfulOperation := 'zacinam citat combos';
    while (lajn <> '{/combos}') do begin
      paramsList.Values[ poleParams[0] ] := lajn; // kedze sme splnili podmienku, ze (lajn <> uzatvaracia znacka), znamena to ze v "lajn" uz mame nacitany 1.parameter objektu combo takze ho tu hned ulozime do pola a zvysne parametre objektu nacitame v nasledujucej slucke
      for I := 1 to Length(poleParams)-1 do begin // tu nacitavame N-1 parametrov objektu (prvy sme nacitali uz v predchadzajucom riadku)
        lajn := rider.ReadLine;  Inc(lineNumber);
        paramsList.Values[ poleParams[I] ] := lajn; // vytvorime asociativne pole s hodnotami jednotlivych parametrov priradenymi nazvom parametrov
      end;
      newcombo := GetComboByID( AddCombo( StrToInt( paramsList.Values['id'] ) )); // vytvorime nove combo na paneli s takym ID ako malo pri ulozeni (nemusia ist po poradi a mozu byt niektore ID vynechane, lebo user pred ulozenim panela mohol nejake comba aj vymazat)
      try
        if not(newcombo = nil) then begin
          newcombo.PolohaObject := StrToInt( paramsList.Values['posref']);
          newcombo.X := StrToFloat(paramsList.Values['posx']);
          newcombo.Y := StrToFloat(paramsList.Values['posy']);
        end;
        SetLength( comboMapping, Length(comboMapping)+1 );                                      // pridame dalsiu polozku do pola mapovania comba
        comboMapping[ Length(comboMapping)-1 ].id      := newcombo.ID;                          // do posledneho prvku pola ukladame parametre aktualne vytvaraneho comba
        comboMapping[ Length(comboMapping)-1 ].pos_ref := StrToInt( paramsList.Values['posref']);// do posledneho prvku pola ukladame parametre aktualne vytvaraneho comba
        lajn := rider.ReadLine;  Inc(lineNumber);
      except
      	on E:exception do begin
          fMain.Log('Error while opening file on line:'+IntToStr(lineNumber)+', Error:'+E.Message+'. Line in combo section:'+#13+lajn);
          MessageBox(0, PChar(TransTxt('Error while opening file.')), PChar('Error'), MB_ICONERROR OR MB_OK);
        end;
      end;
    end;

    lastSucessfulOperation := 'combos uspesne nacitane & spracovane';

    // *********************** nacitanie ficrov ********************************
    while (lajn <> '{>features}') AND (not rider.EndOfStream) do begin
      lajn := rider.ReadLine;
      Inc(lineNumber);
    end;

    if lajn <> '{>features}' then raise Exception.Create(PChar(TransTxt('File is corrupted.')));
    paramsList.Clear;
    SetLength(poleParams, 0);
    ExplodeString( hlavicka.Values['structfeatures'], ',', poleParams);         // vysvetlivky kodu - vid sekciu combos
    lajn := rider.ReadLine;  Inc(lineNumber);

    lastSucessfulOperation := 'idem citat features';

    while lajn <> '{/features}' do begin
      paramsList.Values[ poleParams[0] ] := lajn;
      for I := 1 to Length(poleParams)-1 do begin   // su indexovane od 0 ale na pozicii 0 je ID ficra a to nepotrebujeme
        lajn := rider.ReadLine;  Inc(lineNumber);
        paramsList.Values[ poleParams[I] ] := lajn;
      end;
{$IFDEF DEBUG}
      lastSucessfulOperation := 'idem vytvorit feature: '+
      paramsList.Values['type'] + ';' +
      paramsList.Values['side'] + ';' +
      paramsList.Values['locked'] + ';' +
      paramsList.Values['comboid'] + ';' +
      paramsList.Values['posx'] + ';' +
      paramsList.Values['posy'] + ';' +
      paramsList.Values['size1'] + ';' +
      paramsList.Values['size2'] + ';' +
      paramsList.Values['size3'] + ';' +
      paramsList.Values['size4'] + ';' +
      paramsList.Values['size5'] + ';' +
      paramsList.Values['depth'] + ';' +
      paramsList.Values['param1'] + ';' +
      paramsList.Values['param2'] + ';' +
      paramsList.Values['param3'] + ';' +
      paramsList.Values['param4'] + ';' +
      paramsList.Values['param5'] + '; (END)'
      ;
{$ENDIF}

      newfea := GetFeatureByID( AddFeature( paramsList.Values['type'] ) );
      try
        newfea.Strana  := StrToInt(paramsList.Values['side']);
        newfea.Locked  := StrToBool(paramsList.Values['locked']);
        newfea.ComboID := StrToInt( paramsList.Values['comboid'] );
        newfea.Poloha  := MyPoint( StrToFloat(paramsList.Values['posx']) , StrToFloat(paramsList.Values['posy']) );
        newfea.Rozmer1 := StrToFloat(paramsList.Values['size1']);
        newfea.Rozmer2 := StrToFloat(paramsList.Values['size2']);
        newfea.Rozmer3 := StrToFloat(paramsList.Values['size3']);
        newfea.Rozmer4 := StrToFloat(paramsList.Values['size4']);
        newfea.Rozmer5 := StrToFloat(paramsList.Values['size5']);
        newfea.Hlbka1  := StrToFloat(paramsList.Values['depth']);
      except
      	on E:exception do begin
          fMain.Log('Error while opening file on line:'+IntToStr(lineNumber)+', Error:'+E.Message+'. Line in feature(1) section:'+#13+lajn);
          MessageBox(0, PChar(TransTxt('Error while opening file.')), PChar('Error'), MB_ICONERROR OR MB_OK);
        end;
      end;
      newfea.Param1  := paramsList.Values['param1'];
      newfea.Param2  := paramsList.Values['param2'];
      newfea.Param3  := paramsList.Values['param3'];
      newfea.Param4  := paramsList.Values['param4'];
      newFea.Param5  := paramsList.Values['param5'];
      newfea.Nazov   := paramsList.Values['name'];

      if (paramsList.Values['color'] = '') OR (paramsList.Values['color'] = '-1') then
        newfea.Farba   := -1
      else
        newfea.Farba   := StringToColor(paramsList.Values['color']);

      if (newfea.Typ = ftTxtGrav) then begin
        if (newfea.Rozmer2 = -1) then newfea.Rozmer2 := 0; // rozmer2 = natocenie textu. V starych verziach sa tam vzdy ukladalo -1 lebo parameter nebol vyuzity. Od verzie 1.0.16 bude ale default = 0
        if (newfea.Param5 = '') then newfea.Param5 := fFeaEngraving.comTextFontValue.Items[0];
      end;

      // ak v paneli nie je nahraty taky font, aky ma priradeny nacitavana ficurka, tak ju ani nevytvorime
      if (newfea.Typ = ftTxtGrav) AND (Fonty.IndexOf(newfea.Param5) = -1) then begin
    		fMain.Log('Font not loaded in panel: '+newfea.Param5);
        MessageBox(0, PChar(TransTxt('Font file not found:')+' '+newfea.Param5), PChar(TransTxt('Error')), MB_ICONERROR);
        DelFeatureByID(newfea.ID); // rovno zmazeme ficr
      end else begin
      	try

          // ak je to text, musime prepocitat boundingbox lebo tento zavisi od Param1 .. Param4 a ked sa tie nahravaju do ficra, tak tam sa uz AdjustBoundingBox nevola (automaticky sa to vola len pri nastavovani Size1 .. Size5)
          if newfea.Typ = ftTxtGrav then
            newfea.AdjustBoundingBox;

          // ak je to polyline, nacitame vertexy
          if (newfea.Typ = ftPolyLineGrav) AND (paramsList.Values['vertexarray'] <> '' ) then begin
            ExplodeString(paramsList.Values['vertexarray'], separChar, poleVertexy);
            if ((Length(poleVertexy) > 0) AND (poleVertexy[0] <> '')) then   // ochrana ak riadok co ma obsahovat vertexy je prazdny (pole bude mat vtedy len jeden prvok - prazdny text)
              for I := 0 to Length(poleVertexy)-1 do begin
                vertex.X := StrToFloat( Copy(poleVertexy[I], 0, Pos(',', poleVertexy[I])-1 ) );
                vertex.Y := StrToFloat( Copy(poleVertexy[I], Pos(',', poleVertexy[I])+1 ) );
                (newfea as TFeaturePolyLineObject).AddVertex(vertex);
              end;
          end;

          // pre vsetky, kde sa uplatnuje farba vyplne zrusime vypln ak nie je v konfigu povolena
          if (newfea.Typ >= ftTxtGrav) AND (newfea.Typ < ftThread) then begin
            if not StrToBool( uConfig.Config_ReadValue('engraving_colorinfill_available') ) then newfea.Param4 := 'NOFILL';
          end;

          // este skontrolujeme combo - ak bolo combo polohovane na FICR, tak musime v combe aktualizovat ID toho ficru,
          // pretoze pri nahravani panela zo suboru sa ficrom vygeneruju nove IDcka
          if newfea.ComboID > -1 then begin
            for I := 0 to Length(comboMapping)-1 do begin
              if (comboMapping[I].pos_ref = StrToInt(paramsList.Values['id'])) then begin
                GetComboByID(comboMapping[I].id).PolohaObject := newfea.ID;
              end;
            end;
          end;
        except
          on E:exception do begin
            fMain.Log('Error while opening file on line: '+IntToStr(lineNumber)+', Error: '+E.Message+'. Line in feature(2) section:'+#13+lajn);
            MessageBox(0, PChar(TransTxt('Error while opening file.')), PChar('Error'), MB_ICONERROR OR MB_OK);
          end;
        end;
        newfea.Inicializuj;

        // polyline s nulovym poctom vertexov ani nebudem drzat na paneli, lebo to navysuje cenovu ponuku
        if ((newfea.Typ = ftPolyLineGrav) and
          ((newfea as TFeaturePolyLineObject).GetVertexCount <= 1)) then
          DelFeatureByID(newfea.ID);
      end;

      lajn := rider.ReadLine;  Inc(lineNumber);
    end;

    lastSucessfulOperation := 'features uspesne nacitane & spracovane';

    // *********************** nacitanie guideov *******************************
    while (lajn <> '{>guides}') AND (not rider.EndOfStream) do begin
      lajn := rider.ReadLine;
      Inc(lineNumber);
    end;

    if lajn <> '{>guides}' then raise Exception.Create(PChar(TransTxt('File is corrupted.')));
    paramsList.Clear;
    SetLength(poleParams, 0);
    ExplodeString( hlavicka.Values['structguides'], ',', poleParams);         // vysvetlivky kodu - vid sekciu combos
    lajn := rider.ReadLine;  Inc(lineNumber);

    lastSucessfulOperation := 'idem citat guides';
    while lajn <> '{/guides}' do begin
      paramsList.Values[ poleParams[0] ] := lajn;
      for I := 1 to Length(poleParams)-1 do begin
        lajn := rider.ReadLine;  Inc(lineNumber);
        paramsList.Values[ poleParams[I] ] := lajn;
      end;
      try
      lastSucessfulOperation := 'idem vytvorit guide: '+paramsList.Values['type']+';'+paramsList.Values['param1']+';'+paramslist.Values['param2']+';'+paramslist.Values['param3']+';'+paramslist.Values['side']+'; (END)';

      AddGuideLine(
        paramsList.Values['type'],
        StrToFloat(paramsList.Values['param1']),
        StrToFloat(paramsList.Values['param2']),
        StrToFloat(paramsList.Values['param3']),
        StrToInt  (paramsList.Values['side'])
      );
      except
      	on E:exception do begin
          fMain.Log('Error while opening file on line: '+IntToStr(lineNumber)+', Error: '+E.Message+'. Line in guide section:'+#13+lajn);
          MessageBox(0, PChar(TransTxt('Error while opening file.')), PChar('Error'), MB_ICONERROR OR MB_OK);
        end;
      end;
      lajn := rider.ReadLine;  Inc(lineNumber);
    end;

    objHasChanged := false;

    lastSucessfulOperation := 'all done';
  finally
    hlavicka.Free;
    paramsList.Free;
    rider.Free;
    fMain.Log('Load panel from file (last successful operation): ' + lastSucessfulOperation);
  end;
end;

procedure TPanelObject.LoadFromFile_old(panelfile: string);
var
  myini: TIniFile;
  currSoftVersion: integer;
  i, newfeaID: integer;
  iass: string;     // i as string
  newfea : TFeatureObject;
  newcmb : TComboObject;
begin
  try
    myini := TIniFile.Create(panelfile);

    // kontrola, ci neotvarame subor ulozeny novsou verziou
    currSoftVersion := (cfg_swVersion1*10000)+(cfg_swVersion2*100)+cfg_swVersion3;
    if myini.ReadInteger('Panel','FileVer', 0) > currSoftVersion then begin
      MessageBox(Application.ActiveFormHandle, PChar(TransTxt('File was saved by newer version of the QuickPanel. It might not open correctly.')), PChar(TransTxt('Warning')), MB_ICONWARNING);
    end;

    objFileName    := panelfile;
    objSirka       := myini.ReadFloat('Panel','SizeX',10);
    objVyska       := myini.ReadFloat('Panel','SizeY',10);
    objRadius      := myini.ReadFloat('Panel','Radius1',0);
    objGrid        := myini.ReadFloat('Panel','GridSize',0.5);
    objHrubka      := myini.ReadFloat('Panel','Thickness',3);
    objPovrch      := myini.ReadString('Panel','SurfaceFinish','surovy');
    objHranaStyl   := myini.ReadString('Panel','EdgeStyle','0'); if objHranaStyl='' then objHranaStyl := '0';
    objHranaRozmer := myini.ReadFloat('Panel','EdgeSize',0);
    objHranaObrobenaBottom := myini.ReadBool('Panel','EdgeBottom',false);
    objHranaObrobenaRight  := myini.ReadBool('Panel','EdgeRight',false);
    objHranaObrobenaTop    := myini.ReadBool('Panel','EdgeTop',false);
    objHranaObrobenaLeft   := myini.ReadBool('Panel','EdgeLeft',false);
    CurrentSide := 1;
    CenterPos := myini.ReadInteger('Panel','ZeroPosition', cpLB);
    CurrentSide := 2;
    CenterPos := myini.ReadInteger('Panel','ZeroPosition2', cpLB);
    CurrentSide := 1;
    MaterialVlastny := myini.ReadBool('Panel','CustomMaterial', false);

    SetZoom(0, -1, -1);

    for i:=1 to myini.ReadInteger('Panel','FeaNumber',0) do begin
      iass := IntToStr(i);
      newfeaID := AddFeature( myini.ReadInteger('Features','FeaType_'+iass, 0) );
      if newfeaID > 0 then begin
        newfea := GetFeatureByID(newfeaID);
        // ako prve sa nacitaju Params, lebo pri grav.textoch to musi tak byt
        // (inak by pri nastavovani polohy a pocitani BoundingRect zahlasil vynimku)
        newfea.Param1  := myini.ReadString('Features','Param1_'+iass, '');
        newfea.Param2  := myini.ReadString('Features','Param2_'+iass, '');
        newfea.Param3  := myini.ReadString('Features','Param3_'+iass, '');
        newfea.Param4  := myini.ReadString('Features','Param4_'+iass, '');
        if newfea.Typ = ftTxtGrav then begin
        	newfea.Param5  := fFeaEngraving.comTextFontValue.Text;                  // deafaultne priradime prvy font
        end;
        newfea.Rozmer1 := myini.ReadFloat('Features','Size1_'+iass, 0);
        newfea.Rozmer2 := myini.ReadFloat('Features','Size2_'+iass, 0);
        newfea.Rozmer3 := myini.ReadFloat('Features','Size3_'+iass, 0);
        newfea.Rozmer4 := myini.ReadFloat('Features','Size4_'+iass, 0);
        newfea.Rozmer5 := myini.ReadFloat('Features','Size5_'+iass, 0);
        if newfea.Typ = ftTxtGrav then begin
          newfea.Rozmer2 := 0; // stary format suboru este rotaciu textov nepodporoval a bola tam ulozena hodnota -1, co by bolo chybne interpretovane ako uhol = -1 stupnov
        end;
        newfea.Poloha := MyPoint( myini.ReadFloat('Features','PosX_'+iass, 0) ,
                                  myini.ReadFloat('Features','PosY_'+iass, 0));
        newfea.Hlbka1  := myini.ReadFloat('Features','Depth_'+iass, 0);
        newfea.Strana  := myini.ReadInteger('Features','Side_'+iass, 1);
        if newfea.Strana = 0 then newfea.Strana := 1;

        // spatna kompatibilita pre verzie pod 0.3.3. (hrubka gravirovania)
        if (newfea.Typ >= 30) AND (newfea.Typ <= 39) AND ((newfea.Rozmer3 = 0) OR (newfea.Rozmer3 = -1)) then
          newfea.Rozmer3 := 0.2;

        // spatna kompatibilita pre verzie pod 0.3.7. (farba gravirovania)
        if (newfea.Typ >= 30) AND (newfea.Typ <= 39) AND (newfea.Param4 = '') then
          newfea.Param4 := 'NOFILL';

        // spatna kompatibilita pre verzie pod 0.3.11. (radiusy grav obdlznika)
        if (newfea.Typ = 33) AND (newfea.Rozmer4 < 0) then
          newfea.Rozmer4 := 0;

        newfea.ComboID := myini.ReadInteger('Features','ComboID_'+iass, -1);
        // ak objekt patri do nejakeho comba (a take este neexistuje), vytvori to combo aj v poli combo objektov
        if (newfea.ComboID > -1) AND (not ComboExists(newfea.ComboID)) then
          AddCombo(newfea.ComboID);

        newfea.Inicializuj;
      end;
    end;

    // nahratie combo featurov
    for i:=1 to myini.ReadInteger('Panel','ComboNumber', 0) do begin
      iass := IntToStr(i);
      newcmb := GetComboByID( myini.ReadInteger('Combos','ComboID_'+iass, -1) );
      if not(newcmb = nil) then begin
        newcmb.PolohaObject := myini.ReadInteger('Combos','PosRef_'+iass, -1);
        newcmb.X := myini.ReadFloat('Combos','PosX_'+iass, 0);
        newcmb.Y := myini.ReadFloat('Combos','PosY_'+iass, 0);
      end;
    end;

    // nahratie guidelineov
    for i:=1 to myini.ReadInteger('Panel','GuideNumber', 0) do begin
      iass := IntToStr(i);
      AddGuideLine(
        myini.ReadString('GuideLines', 'GuideType_'+iass, ''),
        myini.ReadFloat('GuideLines', 'Param1_'+iass, -1),
        myini.ReadFloat('GuideLines', 'Param2_'+iass, -1),
        myini.ReadFloat('GuideLines', 'Param3_'+iass, 0),
        myini.ReadInteger('GuideLines', 'Side_'+iass, 1)
      );
    end;
  finally
    FreeAndNil(myini);
  end;
  HasChanged := false;
end;

function TPanelObject.GetFeatureIndex(fid: integer):integer;
var
  i: integer;
begin
  result := -1;
  for i:=0 to objFeatures.Count-1 do
    if (Assigned(objFeatures[i]) AND (objFeatures[i].ID=fid) ) then
      result := i;
end;


procedure TPanelObject.MoveSelected(byXmm, byYmm: double);
var
  i, v: integer;
  tmp_str: string;
  b: TMyPoint;
begin
  tmp_str := '';
  // posunie objekty, ktore su vyselectovane o danu vzdialenost
  for i:=0 to objFeatures.Count-1 do
    if (Assigned(objFeatures[i]) AND objFeatures[i].Selected ) then begin
      if objFeatures[i].Typ = ftPolyLineGrav then begin
        for v := 0 to (objFeatures[i] as TFeaturePolyLineObject).VertexCount - 1 do begin
          b := (objFeatures[i] as TFeaturePolyLineObject).GetVertex(v);
          (objFeatures[i] as TFeaturePolyLineObject).SetVertex(v , b.X+byXmm , b.Y+byYmm);
        end;
      end else begin
        objFeatures[i].X := objFeatures[i].X + byXmm;
        objFeatures[i].Y := objFeatures[i].Y + byYmm;
      end;
      objHasChanged := true;

      // ak je objekt sucastou komba a to kombo nie je polohovane vzhladom na nejaky svoj prvok, prepise polohu v samotnom objekte combo
      if (objFeatures[i].ComboID > -1) AND (_PNL.GetComboByID(objFeatures[i].ComboID).PolohaObject = -1) then begin
        // ak sme este toto combo neposuvali
        if ( Pos(IntToStr(objFeatures[i].ComboID)+'#' , tmp_str) = 0 ) then begin
          _PNL.GetComboByID( objFeatures[i].ComboID ).X := _PNL.GetComboByID( objFeatures[i].ComboID ).X + byXmm;
          _PNL.GetComboByID( objFeatures[i].ComboID ).Y := _PNL.GetComboByID( objFeatures[i].ComboID ).Y + byYmm;
          tmp_str := tmp_str + IntToStr(objFeatures[i].ComboID) + '#';
        end;
      end; // ak je objekt sucastou komba...

    end; // if
end;

procedure TPanelObject.GetFullInfo(target: string = 'debug');
var
  i : integer;
  s: string;
begin
  if target='debug' then begin
    fMain.Log('====== FEATURES ======');
    fMain.Log('count:'+IntToStr(objFeatures.Count));
    fMain.Log('=i=|=ID=|SEL|TYP|SIDE|COMBO|===X===|==Y===|==R1==|==R2==|==R3==|==R4==|==R5==|==H==|==P1==|==P2==|==P3==|==P4==|==P5==|==BoundBox==|');
    for i:=0 to objFeatures.Count-1 do
      if Assigned(objFeatures[i]) then begin
        s := FormatFloat('000 ',i);
        s := s + FormatFloat('000  ',objFeatures[i].ID);
        if (objFeatures[i].Selected) then
          s := s + '[x]'
        else
          s := s + '[ ]';
        s := s + FormatFloat(' 000 ', objFeatures[i].Typ );
        s := s + FormatFloat(' 0   ', objFeatures[i].Strana );
        s := s + FormatFloat(' 000  ', objFeatures[i].ComboID );
        s := s + FormatFloat('000.00 ', objFeatures[i].Poloha.X );
        s := s + FormatFloat('000.00 ', objFeatures[i].Poloha.Y );
        s := s + FormatFloat('000.00 ', objFeatures[i].Rozmer1 );
        s := s + FormatFloat('000.00 ', objFeatures[i].Rozmer2 );
        s := s + FormatFloat('000.00 ', objFeatures[i].Rozmer3 );
        s := s + FormatFloat('000.00 ', objFeatures[i].Rozmer4 );
        s := s + FormatFloat('000.00 ', objFeatures[i].Rozmer5 );
        s := s + FormatFloat('000.00 ', objFeatures[i].Hlbka1 );
        s := s + objFeatures[i].Param1 + ', ' + objFeatures[i].Param2 + ', ' + objFeatures[i].Param3 + ', ' + objFeatures[i].Param4 + ', ' + objFeatures[i].Param5;
        s := s + '['+MyRectToStr(objFeatures[i].BoundingBox)+']';
        fMain.Log(s);
      end else
        fMain.Log( FormatFloat('000 ',i) + '...' );

    fMain.Log('');
    fMain.Log('====== COMBOS ======');
    fMain.Log('=i=|=ID=|=Angle=|==Position==|=Pos.object=|');
    for i:=0 to objCombos.Count-1 do
      if Assigned(objCombos[i]) then begin
        s := FormatFloat('000 ',i);
        s := s + FormatFloat('000  ',objCombos[i].ID);
        s := s + FormatFloat(' 000     ', objCombos[i].Rotation );
        s := s + MyPointToStr( objCombos[i].Poloha ) + '    ';
        s := s + IntToStr( objCombos[i].PolohaObject );
        fMain.Log(s);
      end else
        fMain.Log( FormatFloat('000 ',i) + '...' );
    fMain.Log('');

    fMain.Log('====== FONTS ======');
    for i := 0 to objFonty.Count-1 do
      fMain.Log(objFonty[i]);
    fMain.Log('');

    fMain.Log('====== PANEL ======');
    fMain.Log(FloatToStr(objSirka)+'x'+FloatToStr(objVyska)+'x'+FloatToStr(objHrubka)+'mm , '+objPovrch+' , matros vlastny:'+BoolToStr(objMaterialVlastny, true));
    objCurrentSide := 1;
    fMain.Log('CSYS1:'+inttostr(_PNL.CenterPos));
    objCurrentSide := 2;
    fMain.Log('CSYS2:'+inttostr(_PNL.CenterPos));

    fMain.Log('_____________________________________________________________');
  end;
end;




function TPanelObject.AddGuideLine(typ: string; param_1: double; param_2: double = 0; param_3: double = 0; side: byte = 1): TGuideObject;
var
  newid, newindex: integer;
begin

  newindex := objGuides.Add( TGuideObject.Create(typ) );

  // vytvorime nove ID - nemoze to byt index objektu v objektliste, lebo index sa meni ked vymazem nejaky objekt zo stredu objektlistu
  if (objGuides.Count = 1) then
    newid := 1
  else
    newid := objGuides[ objGuides.Count-2 ].ID + 1;

  with objGuides[newindex] do begin
    ID := newid;
    Param1 := param_1;
    Param2 := param_2;
    Param3 := param_3;
    Strana := side;
  end;

  result := objGuides[newindex];
  objHasChanged := true;
end;

function TPanelObject.GetGuideLineById(gid: integer): TGuideObject;
var
  i: Integer;
begin
  for i := 0 to objGuides.Count-1 do
    if objGuides[i].ID = gid then begin
      result := objGuides[i];
      Break;
    end;
end;

{
  Vrati premennu typu TMyInt2x s maximalne 2 ID-ckami najdenych guidelineov.
  Pripadne s 1 alebo ziadnym ID-ckom (ak nic nenajde, budu obidva integery nastavene na 0)
}
function TPanelObject.GetGuidelinesAt(bod_x, bod_y: integer): TMyInt2x;
var
  i: integer;
  bod_mm: TMyPoint;
  currentGuide: TGuideObject;
  distAbs: Double;
  foundDistances: record
    V: Double;
    H: Double;
    end;
begin

  foundDistances.V := MM(10);  // hladame guidey, ktore su od mysi blizsie nie X mm ale X pixlov - nech je to pri kazdom zoome rovnake
  foundDistances.H := foundDistances.V;

  Result.i1 := 0;
  Result.i2 := 0;

  bod_mm := MyPoint( MM(bod_x, 'x'), MM(bod_y, 'y') );

  for i:=0 to objGuides.Count-1 do
    if (Assigned(objGuides[i])) AND (objGuides[i].Strana = _PNL.StranaVisible) then begin

      currentGuide := objGuides[i];

      if (currentGuide.Typ = 'V') then begin
        distAbs := Abs(bod_mm.X - currentGuide.Param1);
        if (distAbs < foundDistances.V) then begin
          foundDistances.V := distAbs;
          Result.i1 := currentGuide.ID;
        end;
      end;

      if (currentGuide.Typ = 'H') then begin
        distAbs := Abs(bod_mm.Y - currentGuide.Param1);
        if (distAbs < foundDistances.H) then begin
          foundDistances.H := distAbs;
          Result.i2 := currentGuide.ID;
        end;
      end;
    end;
end;

procedure TPanelObject.DelGuideLineById(gid: integer);
var
  i: integer;
begin
  for i := 0 to objGuides.Count-1 do
    if objGuides[i].ID = gid then begin
      objGuides.Delete(i);
      Break;
    end;

  objHasChanged := true;
end;

procedure TPanelObject.DeselectAllGuidelines;
var
  i: Integer;
begin
  for i := 0 to objGuides.Count-1 do
    objGuides[i].Selected := false;
end;



procedure TPanelObject.PrepareUndoStep;
var
  i: integer;
  posledne_ID_pouzite: boolean;
begin
  // ak sa nevyuzilo predchadzajuce ID (nema ho ziadny undostep), tak ID nebudeme zvysovat
  posledne_ID_pouzite := false;
  for i := 0 to High(objUndoList2) do
    if (objUndoList2[i].step_ID = objNextUndoStepID) then
      posledne_ID_pouzite := true;

  // zvysime ID - priradime ho neskor najblizsiemu undostepu
  if (posledne_ID_pouzite) then
    Inc(objNextUndoStepID);
end;

procedure TPanelObject.CreateUndoStep(undoType: string; subjectType: string; subjectID: integer);
begin
  // Undo moze byt typu: Create, Modify, Delete               CRT, MOD, DEL
  // Subjekt moze byt typu: Panel, Feature, Combo, Guidline   PNL, FEA, COM, GUI
  objUndoList2[objIndexOfNextUndoStep].step_type := undoType;
  objUndoList2[objIndexOfNextUndoStep].step_subject := subjectType;
  objUndoList2[objIndexOfNextUndoStep].step_ID   := objNextUndoStepID;
  objUndoList2[objIndexOfNextUndoStep].step_side := objStranaVisible;

  if (subjectType = 'PNL') then begin
    objUndoList2[objIndexOfNextUndoStep].obj := TPanelObject.Create;
    if (undoType = 'MOD') then begin
      (objUndoList2[objIndexOfNextUndoStep].obj as TPanelObject).objSirka := objSirka;
      (objUndoList2[objIndexOfNextUndoStep].obj as TPanelObject).objVyska := objVyska;
      (objUndoList2[objIndexOfNextUndoStep].obj as TPanelObject).objHrubka := objHrubka;
      (objUndoList2[objIndexOfNextUndoStep].obj as TPanelObject).objMaterialVlastny := objMaterialVlastny;
      (objUndoList2[objIndexOfNextUndoStep].obj as TPanelObject).objRadius := objRadius;
      (objUndoList2[objIndexOfNextUndoStep].obj as TPanelObject).objPovrch := objPovrch;
      (objUndoList2[objIndexOfNextUndoStep].obj as TPanelObject).objSideZeroes := objSideZeroes;
      (objUndoList2[objIndexOfNextUndoStep].obj as TPanelObject).objHranaStyl := objHranaStyl;
      (objUndoList2[objIndexOfNextUndoStep].obj as TPanelObject).objHranaRozmer := objHranaRozmer;
      (objUndoList2[objIndexOfNextUndoStep].obj as TPanelObject).objHranaObrobenaBottom := objHranaObrobenaBottom;
      (objUndoList2[objIndexOfNextUndoStep].obj as TPanelObject).objHranaObrobenaRight := objHranaObrobenaRight;
      (objUndoList2[objIndexOfNextUndoStep].obj as TPanelObject).objHranaObrobenaTop := objHranaObrobenaTop;
      (objUndoList2[objIndexOfNextUndoStep].obj as TPanelObject).objHranaObrobenaLeft := objHranaObrobenaLeft;
    end;
  end;  // PNL

  if (subjectType = 'FEA') then begin
    if TFeatureObject( GetFeatureByID(subjectID)).Typ = ftPolyLineGrav then
    	objUndoList2[objIndexOfNextUndoStep].obj := TFeaturePolyLineObject.Create(Self)
    else
	    objUndoList2[objIndexOfNextUndoStep].obj := TFeatureObject.Create(Self);
    if (undoType = 'CRT') then
      (objUndoList2[objIndexOfNextUndoStep].obj as TFeatureObject).ID := subjectID;
    if (undoType = 'MOD')
    OR (undoType = 'DEL') then begin
      (objUndoList2[objIndexOfNextUndoStep].obj as TFeatureObject).ID := subjectID;
      if TFeatureObject( GetFeatureByID(subjectID)).Typ = ftPolyLineGrav then
      	(objUndoList2[objIndexOfNextUndoStep].obj as TFeaturePolyLineObject).CopyFrom( TFeaturePolyLineObject( GetFeatureByID(subjectID)) )
      else
      	(objUndoList2[objIndexOfNextUndoStep].obj as TFeatureObject).CopyFrom( GetFeatureByID(subjectID) );
    end;
  end; // FEA


  if (subjectType = 'COM') then begin
    objUndoList2[objIndexOfNextUndoStep].obj := TComboObject.Create;
    if (undoType = 'CRT') then
      (objUndoList2[objIndexOfNextUndoStep].obj as TComboObject).ID := subjectID;
    if (undoType = 'MOD') then begin
      (objUndoList2[objIndexOfNextUndoStep].obj as TComboObject).ID := subjectID;
      (objUndoList2[objIndexOfNextUndoStep].obj as TComboObject).Poloha := GetComboByID(subjectID).Poloha;
      (objUndoList2[objIndexOfNextUndoStep].obj as TComboObject).PolohaObject := GetComboByID(subjectID).PolohaObject;
      (objUndoList2[objIndexOfNextUndoStep].obj as TComboObject).Name := GetComboByID(subjectID).Name;
      (objUndoList2[objIndexOfNextUndoStep].obj as TComboObject).Rotation := GetComboByID(subjectID).Rotation;
    end;
    if (undoType = 'DEL') then begin
      (objUndoList2[objIndexOfNextUndoStep].obj as TComboObject).ID := subjectID;
      (objUndoList2[objIndexOfNextUndoStep].obj as TComboObject).Poloha := GetComboByID(subjectID).Poloha;
      (objUndoList2[objIndexOfNextUndoStep].obj as TComboObject).PolohaObject := GetComboByID(subjectID).PolohaObject;
      (objUndoList2[objIndexOfNextUndoStep].obj as TComboObject).Name := GetComboByID(subjectID).Name;
      (objUndoList2[objIndexOfNextUndoStep].obj as TComboObject).Rotation := GetComboByID(subjectID).Rotation;
    end;
  end; // COM

  if (subjectType = 'GUI') then begin
    objUndoList2[objIndexOfNextUndoStep].obj := TGuideObject.Create( GetGuideLineById(subjectID).Typ );
    if (undoType = 'CRT') then begin
      (objUndoList2[objIndexOfNextUndoStep].obj as TGuideObject).ID := subjectID;
    end;
    if (undoType = 'MOD')
    OR (undoType = 'DEL') then begin
      (objUndoList2[objIndexOfNextUndoStep].obj as TGuideObject).Param1 := GetGuideLineById(subjectID).Param1;
      (objUndoList2[objIndexOfNextUndoStep].obj as TGuideObject).Param2 := GetGuideLineById(subjectID).Param2;
      (objUndoList2[objIndexOfNextUndoStep].obj as TGuideObject).Param3 := GetGuideLineById(subjectID).Param3;
    end;
  end;  // GUI


  // pre dalsie vlozenie undostepu pripravime spravne index-cislo
  Inc(objIndexOfNextUndoStep);
  // ak sa ma najblizsi undostep davat uz na poslednu poziciu pola, pole sa navysi o dalsich 100 prvkov
  if (objIndexOfNextUndoStep >= High(objUndoList2) ) then
    SetLength(objUndoList2, Length(objUndoList2)+100 );
end;

procedure TPanelObject.Undo;
var
  i, j: integer;
  original_id, reborn_id: integer;
  currUndoStep: TMyUndoStep_v2;
begin

  for i := High(objUndoList2) downto 0 do
    // vratime spat len tie kroky, ktore maju najvyssi STEP_ID
    if (objUndoList2[i].step_ID = objNextUndoStepID) then begin
      currUndoStep := objUndoList2[i];

      // ak vraciame operacie, ktore clovek urobil na opacnej strane panela (a potom ho prevratil), najprv sa prepneme na tu stranu
      if (objStranaVisible <> currUndoStep.step_side) then
        fMain.btnSideSwitch.Click;

      if (currUndoStep.step_subject = 'PNL') then begin
        if (currUndoStep.step_type = 'MOD') then begin
          objSirka := (currUndoStep.obj as TPanelObject).Sirka;
          objVyska := (currUndoStep.obj as TPanelObject).Vyska;
          objHrubka := (currUndoStep.obj as TPanelObject).Hrubka;
          objMaterialVlastny := (currUndoStep.obj as TPanelObject).MaterialVlastny;
          objRadius := (currUndoStep.obj as TPanelObject).Radius;
          objPovrch := (currUndoStep.obj as TPanelObject).Povrch;
          SetCenterPosByNum( (currUndoStep.obj as TPanelObject).GetCenterPosByNum(1) , 1);
          SetCenterPosByNum( (currUndoStep.obj as TPanelObject).GetCenterPosByNum(2) , 2);
          objHranaStyl := (currUndoStep.obj as TPanelObject).HranaStyl;
          objHranaRozmer := (currUndoStep.obj as TPanelObject).HranaRozmer;
          objHranaObrobenaBottom := (currUndoStep.obj as TPanelObject).HranaObrobenaBottom;
          objHranaObrobenaRight := (currUndoStep.obj as TPanelObject).HranaObrobenaRight;
          objHranaObrobenaTop := (currUndoStep.obj as TPanelObject).HranaObrobenaTop;
          objHranaObrobenaLeft := (currUndoStep.obj as TPanelObject).HranaObrobenaLeft;
        end;
      end; // PNL

      if (currUndoStep.step_subject = 'FEA') then begin
        if (currUndoStep.step_type = 'CRT') then begin
          DelFeatureByID( (currUndoStep.obj as TFeatureObject).ID );
        end;
        if (currUndoStep.step_type = 'MOD') then begin
        	if GetFeatureByID( (currUndoStep.obj as TFeatureObject).ID ).Typ = ftPolyLineGrav then
          	TFeaturePolyLineObject( GetFeatureByID( (currUndoStep.obj as TFeatureObject).ID )).CopyFrom( (currUndoStep.obj as TFeaturePolyLineObject) )
          else
          	GetFeatureByID( (currUndoStep.obj as TFeatureObject).ID ).CopyFrom( (currUndoStep.obj as TFeatureObject) );
        end;
        if (currUndoStep.step_type = 'DEL') then begin
          // ulozime si aj povodne ID, aj nove ID (musime vytvorit novy objekt, ked robime undo po zmazani)
          original_id := (currUndoStep.obj as TFeatureObject).ID;
          reborn_id := AddFeature( (currUndoStep.obj as TFeatureObject).Typ );

          GetFeatureByID( reborn_id ).CopyFrom( (currUndoStep.obj as TFeatureObject) );

          // ked sme nanovo vytvorili objekt, uz nema take ID ako pred zmazanim,
          // takze aj v zaznamoch undolistu musime opravit ID objektu
          for j := 0 to High(objUndoList2) do begin
            if Assigned(objUndoList2[j].obj) then begin
              if (objUndoList2[j].step_subject = 'FEA') AND ((objUndoList2[j].obj as TFeatureObject).ID = original_id) then
                (objUndoList2[j].obj as TFeatureObject).ID := reborn_id;
            end;
          end;

        end;
      end; // FEA

      if (currUndoStep.step_subject = 'COM') then begin
        if (currUndoStep.step_type = 'CRT') then begin
          ExplodeCombo( (currUndoStep.obj as TComboObject).ID );
        end;
        if (currUndoStep.step_type = 'MOD') then begin
          GetComboByID( (currUndoStep.obj as TComboObject).ID ).Poloha := (currUndoStep.obj as TComboObject).Poloha;
          GetComboByID( (currUndoStep.obj as TComboObject).ID ).PolohaObject := (currUndoStep.obj as TComboObject).PolohaObject;
          GetComboByID( (currUndoStep.obj as TComboObject).ID ).Name := (currUndoStep.obj as TComboObject).Name;
          GetComboByID( (currUndoStep.obj as TComboObject).ID ).Rotation := (currUndoStep.obj as TComboObject).Rotation;
        end;
        if (currUndoStep.step_type = 'DEL') then begin
          // ulozime si aj povodne ID, aj nove ID (musime vytvorit novy objekt, ked robime undo po zmazani)
          original_id := (currUndoStep.obj as TComboObject).ID;
          reborn_id := AddCombo;

          GetComboByID(reborn_id).Rotation     := (currUndoStep.obj as TComboObject).Rotation;
          GetComboByID(reborn_id).Poloha       := (currUndoStep.obj as TComboObject).Poloha;
          GetComboByID(reborn_id).PolohaObject := (currUndoStep.obj as TComboObject).PolohaObject;

          // ked sme nanovo vytvorili objekt, uz nema take ID ako pred zmazanim,
          // takze aj v zaznamoch undolistu musime opravit ID objektu
          for j := 0 to High(objUndoList2) do begin
            if  Assigned(objUndoList2[j].obj) then begin
              if (objUndoList2[j].step_subject = 'FEA')
              AND ((objUndoList2[j].obj as TFeatureObject).ComboID = original_id) then
                (objUndoList2[j].obj as TFeatureObject).ComboID := reborn_id;
              if (objUndoList2[j].step_subject = 'COM')
              AND ((objUndoList2[j].obj as TComboObject).ID = original_id) then
                (objUndoList2[j].obj as TComboObject).ID := reborn_id;
            end;
          end;

        end;
      end; // COM

      if (currUndoStep.step_subject = 'GUI') then begin
        if (currUndoStep.step_type = 'CRT') then begin
          DelGuideLineById( (currUndoStep.obj as TGuideObject).ID );
        end;
        if (currUndoStep.step_type = 'DEL') then begin
          AddGuideLine(
            (currUndoStep.obj as TGuideObject).Typ,
            (currUndoStep.obj as TGuideObject).Param1,
            (currUndoStep.obj as TGuideObject).Param2,
            (currUndoStep.obj as TGuideObject).Param3
          );
        end;
      end; // GUI

      // nie je to nutne, ale vymazeme aspon zakladne data zo zaznamu
      currUndoStep.step_ID := 0;
      currUndoStep.step_type := '';
      currUndoStep.step_subject := '';
      // aj objekt, nech sa setri pamat
      if Assigned(currUndoStep.obj) then
        FreeAndNil(currUndoStep.obj);
      // nakoniec znizime aj index-cislo, nech je pripravene pre zapis noveho undostepu
      Dec(objIndexOfNextUndoStep);

    end; //if (currUndoStep.step_ID = objNextUndoStepID)

  Dec(objNextUndoStepID);

  if (GetNumberOfUndoSteps = 0) then
    SetHasChanged(false);

  Draw;
end;

function TPanelObject.GetNumberOfUndoSteps: integer;
begin
  result := objNextUndoStepID;
end;

end.
