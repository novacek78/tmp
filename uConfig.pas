unit uConfig;

interface

uses
  SysUtils, Windows, Variants, Classes, Controls, Forms, Dialogs, StdCtrls, IniFiles;

procedure LoadConfigToMemory;
function Config_ReadCombo(_combo: TComboBox; valueName: string; readwhat: string): boolean;
function Config_ReadValue(valueName: string): string;
function GetToolMaxDepth(tooldia: double): double; overload;
function GetToolMaxDepth(tooldia: string): double; overload;

var
  cfg_PartnerName:   string;
  cfg_PartnerWWW:    string;
  cfg_PartnerEmail:  string;
  cfg_PartnerCode:   string;
  cfg_PartnerNick:   string;
  cfg_baseAddr:      string = 'http://www.quickpanel.eu/';
  cfg_clientappAddr: string = 'http://www.quickpanel.eu/clientapp_scripts/';
  cfg_ShowGuides:  boolean = true;
  cfg_SnapToGuides:  boolean = true;
  cfg_UrlCodes: array[0..400] of integer; // su zadefinovane na konci tohoto suboru (begin .. end.)


  cfgValues, cfgCombos, cfgToolMaxDepth: TStringList;

  {************* VERZIA *******************************************************}
  // hodnota tychto premennych sa naplna v fSplash.onCreate
  cfg_swVersion1: integer;  // hlavna verzia - max nie je obmedzene
  cfg_swVersion2: integer;  // subverzia - max=99
  cfg_swVersion3: integer;  // release - max=99

const

  {************* PANEL ********************************************************}
  maxFeaNum      = 4000; // maximalny pocet featurov na paneli
  maxComboFeaNum = 1000;  // maximalny pocet featurov v combo otvore
  cpLB  = 1;  // mozne polohy nuloveho bodu
  cpRB  = 2;
  cpRT  = 3;
  cpLT  = 4;
  cpCEN = 5;

  {************* TYPY OBJEKTOV ************************************************}
  ftHoleCirc    = 10; // diera okruhla
  ftHoleRect    = 20;
  ftTxtGrav     = 30; // gravirovany text
  ftLine2Grav   = 31; // gravirovana ciara
  ftCircleGrav  = 32; // gravirovana kruznica
  ftRectGrav    = 33; // gravirovany obdlznik
  ftPolyLineGrav= 34; // gravirovana lomena ciara
  ftThread      = 40;
  ftPocketCirc  = 50; // zahlbenie okruhle
  ftPocketRect  = 60;
  ftPocketSpec  = 65; // zahlbenie specialne (s ostrovcekom)
  ftSink        = 70; // diera a kuzelove zahlbenie
  ftSinkSpecial = 71; // diera a kuzelove zahlbenie detailne specifikovane
  ftSinkCyl     = 72; // diera a valcove zahlbenie
  ftChamfer     = 80; // zrazenie hrany
  ftGrooveLin   = 90; // drazka linearna
  ftGrooveArc   = 91; // drazka oblukova
  ftCosmeticCircle = 310; // pomocny objekt - kruznica
  ftCosmeticRect   = 320; // pomocny objekt - obdlznik

  {****************** ZAROVNANIE TEXTOV ***************************************}
  taCenter = '0'; // zarovnanie na stred
  taRight  = '1'; // zarovnanie do prava
  taLeft   = '2'; // zarovnanie do lava

  {************* OBJEDNAVKY ***************************************************}
  colName = 0; // cisla stlpcov pre StringGrid na formulari OrderForm
  colNote = 1;
  colPrice = 2;
  colPieces = 3;
  colPriceSum = 4;

  separChar = '|';  // pouziva sa na separovanie hodnot pri komunikacii s webom
  maxFeaInUrl = 20; // maximalny pocet feature-ov posielanych naraz v jednom dotaze (obsolete)
  urlDelayMs  = 0;  // kolko ms cakat medzi posielanim dvoch HTTP dopytov na server

  {***************** PRISTUP **************************************************}
  ftpHost = 'quickpanel.sk';
  ftpUser = 'clientapp.quickpanel.sk';
  ftpPwd  = 'raptor';

  {******************** EXPRESSION PARSER *************************************}
  // operation types:
  otPlus = '+';
  otMinus = '-';
  otKrat = '*';
  otDelene = '/';

  {******************** SNAP GRID *************************************}
  // grid display modes
  gridNone  = 0;
  gridDots  = 1;
  gridLines = 2;

  {******************** COLORS ****************************************}
  // panel
  farbaBgndSvetly = $009e8f80;
  farbaBgndTmavy  = $00332515;
  farbaPovrchEloxNatural = $00BBBBBB;
  farbaPovrchEloxBlack = $00000000;
  farbaPovrchSurovy = $00B0B0B0;
  // features
  farbaObvod = $00909090;
  farbaObvodZrazenaHrana = $00008080;
  farbaKapsaPlocha = $00CCCCCC;
  farbaSelectedObvod = $00FFFFFF;
  farbaSelectedBoundingBox = $000000FF;
  farbaSelectedBoundingBoxCombo = $00FF00FF;
  farbaHighlightObvod  = $00FF22FF;
  farbaGravirSurovy = farbaKapsaPlocha;//$00D0D0D0;
  farbaOtherSideContours = $00008000;
  farbaZavity = $000000FF;

  farbaMultiselectBoxBgnd = $00E0E0E0;
  farbaMultiselectBoxBgndHighlighted = $00FFFFFF;
  farbaMultiselectBoxText = $00000000;
  farbaMultiselectBoxTextHighlight = $00AA2211;

          farbaHighlightPlocha = $00000000;

  {********************** INE *************************************************}
  konfiguracnySubor = 'qpconfig.dat';
  sirkaNeznamehoZnaku = 10;  // pre gravirovany text - ak sa taky znak nenasiel ako zadal user, tak na jeho mieste urobime takto siroku medzeru (tato hodnota plati pre text vysoky 10mm)
  pocetPosledneOtvorenych = 5;  // musi byt minimalne 2
  rozsirenieGravira = 0.1;
  rozsirenieGraviraHighlight = 0.3;
  rozsirenieBoxu = 0.5;
  piDelene180 = 0.017453292519943295769236907684886; // pouzite pre 2D rotaciu bodu pri rotovanych textoch
  snapDistanceMm = 2; // snapovanie na voditka v mm
  multiselectButtonFontHeight = 14;
  multiselectButtonPadding = 4;



implementation

uses uMyTypes, uDebug, uTranslate, uMain;



procedure LoadConfigToMemory;
var
  rider: TStreamReader;
  riadok: string;
  cfgFileName, bakFileName: string;
begin
  if Assigned(cfgValues) then Exit;

  cfgFileName := ExtractFilePath(Application.ExeName) + konfiguracnySubor;

  // ak nenasiel CFG fajl alebo je zmrseny (prilis maly), skusime nacitat zalohu a ak ani to nie, tak exit.
  if (not FileExists(cfgFileName)) OR (FileSize(cfgFileName) < 10) then begin
    // pokus o nacitanie zalohy
    bakFileName := cfgFileName + '.bak';
    if (not FileExists(bakFileName)) OR (FileSize(bakFileName) < 10) then begin
      MessageBox(0, PChar(TransTxt('Can''t read config file.')), PChar(TransTxt('Error')), MB_ICONERROR);
      Application.Terminate;
    end else begin
      try
        DeleteFile(PChar(cfgFileName));
        RenameFile(bakFileName, cfgFileName);
      except
        MessageBox(0, PChar(TransTxt('Can''t read config file.')), PChar(TransTxt('Error')), MB_ICONERROR);
        Application.Terminate;
      end;
    end;
  end;


  cfgValues := TStringList.Create;
  cfgCombos := TStringList.Create;
  try
  	rider := TStreamReader.Create(cfgFileName, TEncoding.UTF8);
  except
    MessageBox(0, PChar(TransTxt('Can''t read config file.')), PChar(TransTxt('Error')), MB_ICONERROR);
    Application.Terminate;
  end;

  try
    while (riadok <> '{>name-values}') AND (not rider.EndOfStream) do  // presunieme sa na sekciu NAME-VALUES
      riadok := rider.ReadLine;
    repeat
      if Pos('=', riadok) > 0 then begin
        cfgValues.Add(riadok);
      end;
      riadok := rider.ReadLine;
    until (riadok = '{/name-values}') OR (rider.EndOfStream);

    while (riadok <> '{>combos}') AND (not rider.EndOfStream) do  // presunieme sa na sekciu COMBOS
      riadok := rider.ReadLine;
    repeat
      if Pos(':', riadok) > 0 then begin
        cfgCombos.Values[ Copy(riadok, 0, Pos(':',riadok)-1) ] := Copy(riadok, Pos(':',riadok)+1, 9999);
      end;
      riadok := rider.ReadLine;
    until (riadok = '{/combos}') OR (rider.EndOfStream);
  finally
    rider.Free;
  end;

  if cfgValues.Count = 0 then MessageBox(0, 'No CfgValues read', 'error', MB_OK);
  if cfgCombos.Count = 0 then MessageBox(0, 'No CfgCombos read', 'error', MB_OK);

  // este vytvorime string list s maximalnymi hlbkami pre dany nastroj, tieto treba na viacerych miestach v programe vediet
  cfgToolMaxDepth := TStringList.Create;
  ExplodeStringSL( cfgCombos.ValueFromIndex[ cfgCombos.IndexOfName('tool_maxdepth') ] , '|', cfgToolMaxDepth);
end;

function Config_ReadCombo(_combo: TComboBox; valueName: string; readwhat: string): boolean;
var
  tmp: string;
  i: integer;
  stringy: TStringList;
begin

  tmp := cfgCombos.ValueFromIndex[ cfgCombos.IndexOfName(valueName) ];

    if tmp <> '' then begin
      try
        stringy := TStringList.Create;

        if readwhat = 'keys' then begin
          ExplodeStringSL(tmp, '|', stringy);
          for i := 0 to stringy.Count-1 do
            stringy.Strings[i] := Copy( stringy.Strings[i], 0, Pos('=', stringy.Strings[i])-1 );
          _combo.Items := stringy;
          tmp := cfgValues.ValueFromIndex[ cfgValues.IndexOfName('default_'+valueName) ];
          if tmp = '' then tmp := '0';
          _combo.ItemIndex := StrToInt( tmp );
        end;

        if readwhat = 'values' then begin
          ExplodeStringSL(tmp, '|', stringy);
          for i := 0 to stringy.Count-1 do
            stringy.Strings[i] := Copy( stringy.Strings[i], Pos('=', stringy.Strings[i])+1, 9999 );
          _combo.Items := stringy;
          tmp := cfgValues.ValueFromIndex[ cfgValues.IndexOfName('default_'+valueName) ];
          if tmp = '' then tmp := '0';
          _combo.ItemIndex := StrToInt( tmp );
        end;

        if readwhat = 'pairs' then begin
          ExplodeStringSL(tmp, '|', stringy);
          _combo.Items := stringy;
          tmp := cfgValues.ValueFromIndex[ cfgValues.IndexOfName('default_'+valueName) ];
          if tmp = '' then tmp := '0';
          _combo.ItemIndex := StrToInt( tmp );
        end;

      finally
        stringy.Free;
      end;
    end else
      fMain.Log('config combo not found: '+valueName+' ('+readwhat+')');
end;


function Config_ReadValue(valueName: string): string;
var
  tmp: string;
begin
  tmp := cfgValues.ValueFromIndex[ cfgValues.IndexOfName(valueName) ];
  if tmp = '' then
    fMain.Log('config value not found: '+valueName)
  else
    result := tmp;
end;


function GetToolMaxDepth(tooldia: double): double;
begin
  result := GetToolMaxDepth( FormatFloat('0.#', tooldia) );
end;

function GetToolMaxDepth(tooldia: string): double;
begin
  result := StrToFloat(cfgToolMaxDepth.Values[ tooldia ] );
end;

begin
  cfg_UrlCodes[318] := $BE; //  æ
  cfg_UrlCodes[353] := $9A; //  ö
  cfg_UrlCodes[269] := $E8; //  Ë
  cfg_UrlCodes[357] := $9D; //  ù
  cfg_UrlCodes[382] := $9E; //  û
  cfg_UrlCodes[253] := $FD; //  ˝
  cfg_UrlCodes[225] := $E1; //  ·
  cfg_UrlCodes[237] := $ED; //  Ì
  cfg_UrlCodes[233] := $E9; //  È
  cfg_UrlCodes[271] := $EF; //  Ô
  cfg_UrlCodes[250] := $FA; //  ˙
  cfg_UrlCodes[228] := $E4; //  ‰
  cfg_UrlCodes[314] := $E5; //  Â
  cfg_UrlCodes[328] := $F2; //  Ú
  cfg_UrlCodes[243] := $F3; //  Û
  cfg_UrlCodes[341] := $E0; //  ‡
  cfg_UrlCodes[345] := $F8; //  ¯
  cfg_UrlCodes[283] := $EC; //  Ï
  cfg_UrlCodes[367] := $F9; //  ˘
  cfg_UrlCodes[244] := $F4; //  Ù

  cfg_UrlCodes[317] := $BC; //  º
  cfg_UrlCodes[352] := $8A; //  ä
  cfg_UrlCodes[268] := $C8; //  »
  cfg_UrlCodes[356] := $8D; //  ç
  cfg_UrlCodes[381] := $8E; //  é
  cfg_UrlCodes[221] := $DD; //  ›
  cfg_UrlCodes[193] := $C1; //  ¡
  cfg_UrlCodes[205] := $CD; //  Õ
  cfg_UrlCodes[201] := $C9; //  …
  cfg_UrlCodes[270] := $CF; //  œ
  cfg_UrlCodes[218] := $DA; //  ⁄
  cfg_UrlCodes[196] := $C4; //  ƒ
  cfg_UrlCodes[313] := $C5; //  ≈
  cfg_UrlCodes[327] := $D2; //  “
  cfg_UrlCodes[211] := $D3; //  ”
  cfg_UrlCodes[340] := $C0; //  ¿
  cfg_UrlCodes[344] := $D8; //  ÿ
  cfg_UrlCodes[282] := $CC; //  Ã
  cfg_UrlCodes[366] := $D9; //  Ÿ
  cfg_UrlCodes[212] := $D4; //  ‘
end.
