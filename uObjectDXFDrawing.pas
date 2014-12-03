unit uObjectDXFDrawing;

interface

uses
  SysUtils,
  Types,
  Vcl.Graphics,
  Contnrs,
  System.Math,
  uMyTypes,
  uObjectDXFEntity,
  uObjectDrawing;

type
  TDXFDrawing = class(TObject)
  private
    objFullPath: string;  // cesta a nazov suboru
    objCurrLayer: string;
    objEntities: TObjectList;
    objBoundingBox: TMyRect;
    objFileWriterHandle: TextFile;
    function  objGetEntity(Index: Integer): TDXFEntity;
    procedure objSetEntity(Index: Integer; EntityObj: TDXFEntity);
    procedure objReadPair(var fhandle: TextFile; var pair: TDXFPair);
    procedure objWritePair(code: integer; val: string);
    procedure objAdjustBoundingBox;
    procedure objAdjustBoundingBoxPoint(value: Double; axis: string);
  public
    constructor Create;
    destructor  Destroy;
    property Entities[Index: Integer]: TDXFEntity read objGetEntity write objSetEntity;
    property BoundingBox: TMyRect read objBoundingBox;
  published
    property CurrLayer: string read objCurrLayer write objCurrLayer;

    procedure Draw(papier: TDrawingObject);
    procedure LoadFromFile(filePath: string);
    procedure SaveToFile(filePath: string);
    function  EntityCount: integer;
    function  EntityAdd(entType:string): integer;
    function  EntityAddLine(p1,p2: TMyPoint): integer;
    function  EntityAddCircle(cen: TMyPoint; r: double): integer;
    function  EntityAddArc(cen:TMyPoint; r,a1,a2:double): integer;
    function  EntityAddText(pos:TMyPoint; txt: string; size: double; align: string): integer;
    function  GetAllEntities: string;
end;


implementation

uses uMain, uDebug;


{ TDXFDrawing }



constructor TDXFDrawing.Create;
begin
  inherited Create;
  objCurrLayer := '0';
  objEntities := TObjectList.Create;
end;

destructor TDXFDrawing.Destroy;
begin
  FreeAndNil(objEntities);
  inherited Destroy;
end;

procedure TDXFDrawing.Draw(papier: TDrawingObject);
var
  i: Integer;
  entita: TDXFEntity;
  typ: string;
  p1, p2: TMyPoint;
begin
//fDebug.LogMessage('DXFDRAWING Draw(); entities:'+inttostr(objEntities.Count));
  for i := 0 to objEntities.Count-1 do begin

    entita := (objEntities[i] as TDXFEntity);
    typ := entita.GetValueS(0);

    if typ = 'LINE' then begin
      p1.X := entita.GetValueF(10);
      p1.Y := entita.GetValueF(20);
      p2.X := entita.GetValueF(11);
      p2.Y := entita.GetValueF(21);
      papier.Line(p1, p2);
    end;

  end;
end;

procedure TDXFDrawing.objAdjustBoundingBox;
var
  i, j: Integer;
  ent: TDXFEntity;
begin
  objBoundingBox.TopL.X := 9.9E308;     // nekonecno
  objBoundingBox.BtmR.X := -9.9E308;
  objBoundingBox.TopL.Y := 9.9E308;
  objBoundingBox.BtmR.Y := -9.9E308;

  for i := 0 to objEntities.Count-1 do begin
    ent := (objEntities[i] as TDXFEntity);
    if (ent.GetValueS(0) = 'LINE') then begin
      objAdjustBoundingBoxPoint( ent.GetValueF(10), 'x' );
      objAdjustBoundingBoxPoint( ent.GetValueF(20), 'y' );
      objAdjustBoundingBoxPoint( ent.GetValueF(11), 'x' );
      objAdjustBoundingBoxPoint( ent.GetValueF(21), 'y' );
    end else if ((ent.GetValueS(0) = 'ARC') OR (ent.GetValueS(0) = 'CIRCLE'))then begin
      objAdjustBoundingBoxPoint( ent.GetValueF(10) + ent.GetValueF(40), 'x' );
      objAdjustBoundingBoxPoint( ent.GetValueF(10) - ent.GetValueF(40), 'x' );
      objAdjustBoundingBoxPoint( ent.GetValueF(20) + ent.GetValueF(40), 'y' );
      objAdjustBoundingBoxPoint( ent.GetValueF(20) - ent.GetValueF(40), 'y' );
    end else if (ent.GetValueS(0) = 'POLYLINE') then begin
      for j := 0 to ent.SubEntitiesCount-1 do begin
        objAdjustBoundingBoxPoint( ent.SubEntities[j].GetValueF(10), 'x' );
        objAdjustBoundingBoxPoint( ent.SubEntities[j].GetValueF(20), 'y' );
      end;
    end;
  end;
end;

procedure TDXFDrawing.objAdjustBoundingBoxPoint(value: Double; axis: string);
begin
  if (axis = 'x') then begin
    objBoundingBox.TopL.X := Min( objBoundingBox.TopL.X , value );
    objBoundingBox.BtmR.X := Max( objBoundingBox.BtmR.X , value );
  end else if (axis = 'y') then begin
    objBoundingBox.TopL.Y := Min( objBoundingBox.TopL.Y , value );
    objBoundingBox.BtmR.Y := Max( objBoundingBox.BtmR.Y , value );
  end;
end;

function TDXFDrawing.objGetEntity(Index: Integer): TDXFEntity;
begin
  result := (objEntities.Items[Index] as TDXFEntity);
end;

procedure TDXFDrawing.objSetEntity(Index: Integer; EntityObj: TDXFEntity);
begin
  objEntities.Items[Index] := EntityObj;
end;

procedure TDXFDrawing.objReadPair(var fhandle: TextFile; var pair: TDXFPair);
var
  tmp: string;
begin
  ReadLn(fhandle, tmp);
  pair.code := StrToInt(tmp);
  ReadLn(fhandle, pair.val);
end;

procedure TDXFDrawing.objWritePair(code: integer; val: string);
begin
  Writeln(objFileWriterHandle, Format('%3d', [code]));
  Writeln(objFileWriterHandle, val);
end;



function TDXFDrawing.EntityCount: integer;
begin
  result := objEntities.Count;
end;

function TDXFDrawing.EntityAdd(entType:string): integer;
var
  i: integer;
begin
  // vytvori entitu daneho typu v DXF drawingu a vrati jej novo-prideleny index
  i := objEntities.Add(TDXFEntity.Create);
  if entType <> '' then begin
    Entities[i].SetValue(0, entType);
  end;
  result := i;
end;

function TDXFDrawing.EntityAddLine(p1, p2: TMyPoint): integer;
var
  i: integer;
begin
  // vytvori entitu typu LINE v DXF drawingu a vrati jej novo-prideleny index
  i := objEntities.Add(TDXFEntity.Create);
  Entities[i].SetValue(0, 'LINE');
  Entities[i].SetValue(8, objCurrLayer);
  Entities[i].SetValue(10, FloatToStr(p1.X));
  Entities[i].SetValue(20, FloatToStr(p1.Y));
  Entities[i].SetValue(11, FloatToStr(p2.X));
  Entities[i].SetValue(21, FloatToStr(p2.Y));
  result := i;
end;

function TDXFDrawing.EntityAddCircle(cen: TMyPoint; r: double): integer;
var
  i: integer;
begin
  // vytvori entitu typu CIRCLE v DXF drawingu a vrati jej novo-prideleny index
  i := objEntities.Add(TDXFEntity.Create);
  Entities[i].SetValue(0, 'CIRCLE');
  Entities[i].SetValue(8, objCurrLayer);
  Entities[i].SetValue(10, FloatToStr(cen.X));
  Entities[i].SetValue(20, FloatToStr(cen.Y));
  Entities[i].SetValue(40, FloatToStr(r));
  result := i;
end;

function TDXFDrawing.EntityAddArc(cen: TMyPoint; r, a1, a2: double): integer;
var
  i: integer;
begin
  // vytvori entitu typu ARC v DXF drawingu a vrati jej novo-prideleny index
  i := objEntities.Add(TDXFEntity.Create);
  Entities[i].SetValue(0, 'ARC');
  Entities[i].SetValue(8, objCurrLayer);
  Entities[i].SetValue(10, FloatToStr(cen.X));
  Entities[i].SetValue(20, FloatToStr(cen.Y));
  Entities[i].SetValue(40, FloatToStr(r));
  Entities[i].SetValue(50, FloatToStr(a1));   // obluk od uhla A1 po A2 v smere CCW
  Entities[i].SetValue(51, FloatToStr(a2));
  result := i;
end;

function TDXFDrawing.EntityAddText(pos: TMyPoint; txt: string; size: double;
  align: string): integer;
var
  i: integer;
begin
// vytvori entitu typu ARC v DXF drawingu a vrati jej novo-prideleny index
  i := objEntities.Add(TDXFEntity.Create);
  Entities[i].SetValue(0, 'TEXT');
  Entities[i].SetValue(5, IntToStr(i)); // text musi mat v DXF svoje ID
  Entities[i].SetValue(8, objCurrLayer);
  Entities[i].SetValue(1, txt);
  Entities[i].SetValue(10, FloatToStr(pos.X));
  Entities[i].SetValue(20, FloatToStr(pos.Y));
  Entities[i].SetValue(11, FloatToStr(pos.X));
  Entities[i].SetValue(21, FloatToStr(pos.Y));
  Entities[i].SetValue(40, FloatToStr(size));
  if align = '0' then Entities[i].SetValue(72, '1');
  if align = '1' then Entities[i].SetValue(72, '0');
  if align = '2' then Entities[i].SetValue(72, '2');
  result := i;
end;



procedure TDXFDrawing.LoadFromFile(filePath: string);
var
  fh: TextFile;
  pair: TDXFPair;
  newEnt, lastPolyLine: integer;
  b: TMyPoint;
begin
  // nacita vsetky (podporovane) entity z DXF suboru
  objFullPath := filePath;

  if FileExists(objFullPath) then begin

    AssignFile(fh, objFullPath);
    Reset(fh);
    newEnt := -1;
    try
      while not EOF(fh) do begin
        objReadPair(fh, pair);
        if (pair.code=2) AND (pair.val='ENTITIES') then begin
          objReadPair(fh, pair);
          while pair.val <> 'ENDSEC' do begin
            if (pair.code=0) AND (pair.val<>'SEQEND') then begin // specialny pripad kodu '0' je koniec Polyline-y (SEQEND)
              if pair.val = 'POLYLINE' then begin
                lastPolyLine := EntityAdd(pair.val);
                newEnt := -1;

                while not ((pair.code=0) AND (pair.val='VERTEX')) do // prejdeme az k prvemu vertexu polyline-y
                  objReadPair(fh, pair);
                while not ((pair.code=0) AND (pair.val='SEQEND')) do begin
                  if ((pair.code=0) AND (pair.val='VERTEX')) then begin
                    while not (pair.code=10) do objReadPair(fh, pair);
                    b.X := StrToFloat(pair.val);
                    while not (pair.code=20) do objReadPair(fh, pair);
                    b.Y := StrToFloat(pair.val);
                    Entities[lastPolyLine].SubEntityAddVertex( b, CurrLayer );
                  end;
                  objReadPair(fh, pair);
                end; // while

              end else // if pair.val = 'POLYLINE'
                newEnt := EntityAdd(pair.val)
            end else // if pair.code=0
              if newEnt > -1 then
                Entities[newEnt].SetValue(pair.code , pair.val);
            objReadPair(fh, pair);
          end; // while
        end; // if ENTITIES
      end;
    finally
      CloseFile(fh);
    end;

    objAdjustBoundingBox;
  end;
end;

procedure TDXFDrawing.SaveToFile(filePath: string);
var
  i,j: integer;
begin
  AssignFile(objFileWriterHandle, filePath);
  Rewrite(objFileWriterHandle);

  try
    objWritePair(0, 'SECTION');
    objWritePair(2, 'TABLES');

      objWritePair(0, 'TABLE'); // *** line types ***
      objWritePair(2, 'LTYPE');
      objWritePair(70, '1');
        objWritePair(0, 'LTYPE');
        objWritePair(2, 'CONTINUOUS');
        objWritePair(70, '0');
        objWritePair(3, 'Solid line');
        objWritePair(72, '65');
        objWritePair(73, '0');
        objWritePair(40, '0.0');
      objWritePair(0, 'ENDTAB');

      objWritePair(0, 'TABLE'); // *** layers ***
      objWritePair(2, 'LAYER');
      objWritePair(70, '5'); // pocet vrstiev

        objWritePair(0, 'LAYER');
        objWritePair(2, 'Panel');
        objWritePair(70, '0');
        objWritePair(62, '7');
        objWritePair(6, 'CONTINUOUS');

        objWritePair(0, 'LAYER');
        objWritePair(2, 'ThruHoles');
        objWritePair(70, '0');
        objWritePair(62, '7');
        objWritePair(6, 'CONTINUOUS');

        objWritePair(0, 'LAYER');
        objWritePair(2, 'Threads');
        objWritePair(70, '0');
        objWritePair(62, '90');
        objWritePair(6, 'CONTINUOUS');

        objWritePair(0, 'LAYER');
        objWritePair(2, 'Pockets');
        objWritePair(70, '0');
        objWritePair(62, '150');
        objWritePair(6, 'CONTINUOUS');

        objWritePair(0, 'LAYER');
        objWritePair(2, 'Engraving');
        objWritePair(70, '0');
        objWritePair(62, '30');
        objWritePair(6, 'CONTINUOUS');

      objWritePair(0, 'ENDTAB'); // end of TABLE - LAYERS
    objWritePair(0, 'ENDSEC'); // end of SECTION - TABLES

    objWritePair(0, 'SECTION');
    objWritePair(2, 'ENTITIES');

    for i := 0 to objEntities.Count - 1 do begin
      for j := 0 to Entities[i].PairsCount - 1 do begin
        objWritePair(Entities[i].Pairs[j].code, Entities[i].Pairs[j].val);
      end;
    end;

    objWritePair(0, 'ENDSEC'); // end of ENTITIES
    objWritePair(0, 'EOF');
  finally
    CloseFile(objFileWriterHandle);
  end;
end;

function TDXFDrawing.GetAllEntities: string;
var
  i: integer;
begin
  // len pre potreby debugu
  for i := 0 to objEntities.Count - 1 do begin
    result := result + Entities[i].GetValueS(0) + ',';
  end;
end;

end.
