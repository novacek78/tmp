unit uObjectCombo;

interface

uses Buttons, Classes, SysUtils, Graphics, uMyTypes, Math;

type
  TComboObject = class(TObject)
  private
    objID: integer;  // ID
    objPoloha: TMyPoint;      // pouziva sa len vtedy, ak nie je combo polohovane vzhladom na nejaky svoj komponent
    objPolohaObject: integer; // identifikator objektu, ktory urcuje polohu comba (ak je polohovane od svojho stredu, je tento parameter = -1)
    objVelkost: TMyPoint;
    objName: string;
    objRotation: double;
  published
    constructor Create;
    property ID: integer read objID write objID;
    property Poloha: TMyPoint read objPoloha write objPoloha;
    property X: double read objPoloha.X write objPoloha.X;
    property Y: double read objPoloha.Y write objPoloha.Y;
    property PolohaObject: integer read objPolohaObject write objPolohaObject;
    property Velkost: TMyPoint read objVelkost write objVelkost;
    property Name: string read objName write objName;
    property Rotation: double read objRotation write objRotation;

    procedure SaveToFile(filename: string);
    procedure MoveFeaturesBy(offset: TMyPoint);
end;



implementation

uses uMain, uObjectFeature, uConfig, uObjectFeaturePolyLine;

{ ============================= TComboObject ================================= }

constructor TComboObject.Create;
begin
  inherited Create;
  objID := -1;
  objPoloha := MyPoint(-1,-1);
  objPolohaObject := -1;
  objName := '';
  objRotation := 0;
end;


procedure TComboObject.SaveToFile(filename: string);
var
  pisar: TStreamWriter;
  i, v: integer;
  tempStr: string;
  vertex: TMyPoint;
begin
  // najprv povodny subor zmazeme, aby sa v nom nedrzali stare vymazane objekty
  if FileExists(filename) then begin
    DeleteFile(filename+'.bak');
    RenameFile(filename, filename+'.bak');
  end;

  pisar := TStreamWriter.Create(filename, false, TEncoding.UTF8);

  try
    // zapiseme hlavicku
    pisar.WriteLine('{>header}');
    pisar.WriteLine('filetype=quickpanel:combo');
    pisar.WriteLine('filever='     + IntToStr((cfg_swVersion1*10000)+(cfg_swVersion2*100)+cfg_swVersion3));
    pisar.WriteLine('name='+StringReplace( ExtractFileName(FileName), '.combo', '', [] ));
    pisar.WriteLine('units=mm');
    pisar.WriteLine('sizex='       + FloatToStr(RoundTo(objVelkost.X , -4)));
    pisar.WriteLine('sizey='       + FloatToStr(RoundTo(objVelkost.Y , -4)));
    pisar.WriteLine('insertpointx='+ FloatToStr(RoundTo(objPoloha.X , -4)));
    pisar.WriteLine('insertpointy='+ FloatToStr(RoundTo(objPoloha.Y , -4)));
    pisar.WriteLine('structfeatures=type,posx,posy,size1,size2,size3,size4,size5,depth,param1,param2,param3,param4,param5,vertexarray'); // MUSIA byt oddelene ciarkami LoadFromFile sa na nich spolieha
    pisar.WriteLine('{/header}');

    // ficre - prejdeme objekty a vyselectovane ulozime
    pisar.WriteLine('{>features}');
    for i:=0 to _PNL.Features.Count-1 do
      if (Assigned( _PNL.Features[i] )) AND (_PNL.Features[i].Selected) then begin
        pisar.WriteLine( IntToStr(_PNL.Features[i].Typ) );
        pisar.WriteLine( FloatToStr(RoundTo(_PNL.Features[i].X - objPoloha.X , -4)) ); // poloha jednotlivych featurov bude ulozena vzhladom na stred comba
        pisar.WriteLine( FloatToStr(RoundTo(_PNL.Features[i].Y - objPoloha.Y , -4)) );
        pisar.WriteLine( FloatToStr(RoundTo(_PNL.Features[i].Rozmer1 , -4)) );
        pisar.WriteLine( FloatToStr(RoundTo(_PNL.Features[i].Rozmer2 , -4)) );
        pisar.WriteLine( FloatToStr(RoundTo(_PNL.Features[i].Rozmer3 , -4)) );
        pisar.WriteLine( FloatToStr(RoundTo(_PNL.Features[i].Rozmer4 , -4)) );
        pisar.WriteLine( FloatToStr(RoundTo(_PNL.Features[i].Rozmer5 , -4)) );
        pisar.WriteLine( FloatToStr(RoundTo(_PNL.Features[i].Hlbka1 , -4)) );
        pisar.WriteLine( _PNL.Features[i].Param1 );
        pisar.WriteLine( _PNL.Features[i].Param2 );
        pisar.WriteLine( _PNL.Features[i].Param3 );
        pisar.WriteLine( _PNL.Features[i].Param4 );
        pisar.WriteLine( _PNL.Features[i].Param5 );
        // zapisanie vertexov polylineu
        if (_PNL.Features[i].Typ <> ftPolyLineGrav) then
          pisar.WriteLine('')
        else begin
          tempStr := '';
          for v := 0 to (_PNL.Features[i] as TFeaturePolyLineObject).VertexCount-1 do begin
            vertex := (_PNL.Features[i] as TFeaturePolyLineObject).GetVertex(v);
            tempStr := tempStr + FormatFloat('0.0###',vertex.X)+','+FormatFloat('0.0###',vertex.Y)+separChar;
          end;
          tempStr := Copy(tempStr, 0, Length(tempStr)-1 ); // odstranime posledny separchar
          pisar.WriteLine(tempStr);
        end;
      end;
    pisar.WriteLine('{/features}');

  finally
    pisar.Free;
  end;

  // ak vsetko prebehlo OK, mozeme zmazat zalozny subor
  if FileExists(filename+'.bak') then DeleteFile(filename+'.bak');
end;

procedure TComboObject.MoveFeaturesBy(offset: TMyPoint);
var
  poleObjektov: TPoleIntegerov;
  i: integer;
begin
  // ciselna poloha comba sa nezmeni, len sa v ramci neho posunu jeho komponenty

  _PNL.GetComboFeatures(poleObjektov, objID);

  for i := 0 to High(poleObjektov) do begin
    _PNL.CreateUndoStep('MOD','FEA',poleObjektov[i]);
    _PNL.GetFeatureByID(poleObjektov[i]).X := _PNL.GetFeatureByID(poleObjektov[i]).X + offset.X;
    _PNL.GetFeatureByID(poleObjektov[i]).Y := _PNL.GetFeatureByID(poleObjektov[i]).Y + offset.Y;
  end;
end;

end.
