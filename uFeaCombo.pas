unit uFeaCombo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls, IniFiles, Math;

type
  TfFeaCombo = class(TForm)
    Panel1: TPanel;
    pgControl: TPageControl;
    btnSad: TSpeedButton;
    btnCancel: TBitBtn;
    btnSave: TBitBtn;
    tabFileCombo: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    lbComboName: TLabel;
    lbComboSize: TLabel;
    dlgOpen: TOpenDialog;
    Panel2: TPanel;
    imgFileCombo: TImage;
    Label13: TLabel;
    rbFile: TRadioButton;
    rbLocalLibrary: TRadioButton;
    rbInternetLibrary: TRadioButton;
    Bevel1: TBevel;
    Label3: TLabel;
    edComboComponent: TEdit;
    UpDownComponent: TUpDown;
    Label5: TLabel;
    edComboX: TLabeledEdit;
    edComboY: TLabeledEdit;
    btnBrowse: TBitBtn;
    procedure LoadComboFromFile(filename: string);
    procedure LoadComboFromFile_old(filename: string);
    procedure AddComboToPanel;
    procedure GetRAMComboInfo;
    procedure PreviewCombo;
    function  PX(mm: double; axis: string = ''): integer;
    procedure EditCombo(combo_id: integer);

    procedure FormCreate(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure ShowComponentName(arr_index: integer);
    procedure btnSadClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure edComboComponentKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DecimalPoint(Sender: TObject; var Key: Char);
    procedure UpDownComponentMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UpDownComponentChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure MathExp(Sender: TObject);
  private
    { Private declarations }
  public
    is_editing: boolean; // udava, ci je okno otvorene pre vytvorenie alebo editovanie prvku
    edited_combo_ID: integer; // cislo upravovaneho comba
  end;

var
  fFeaCombo: TfFeaCombo;

implementation

uses uMain, uObjectFeature, uMyTypes, uConfig, uDebug, uObjectPanel,
  uPanelSett, uTranslate, uObjectCombo, uLib, uFeaEngrave, uObjectFeaturePolyLine;

var
  featuresArr: array[0..maxComboFeaNum] of TFeatureObject;
  comboName: string;
  comboSizeX, comboSizeY, comboScale: double;
  comboCenter_original: TMyPoint;
  comboPolohaObject_original: integer;
  comboPoloha_original: TMyPoint;

{$R *.dfm}

procedure TfFeaCombo.FormCreate(Sender: TObject);
var
  tmpdir: string;
begin
  fMain.imgList_common.GetBitmap(0, btnSad.Glyph);
  btnCancel.Glyph := fPanelSett.btnCancel.Glyph;
  btnSave.Glyph := fPanelSett.btnSave.Glyph;

  pgControl.ActivePageIndex := 0;

  // nastavime vychodzi adresar pre umiestnenie panelov
  tmpdir := fMain.ReadRegistry_string('Config', 'App_CombosDir');
  if tmpdir='' then
    tmpdir := ExtractFilePath( Application.ExeName ) + 'combos\';
  dlgOpen.InitialDir := tmpdir;

  // na mieste obrazkov combo otvorov vykreslime prekrizene ciary
  PreviewCombo;
end;

procedure TfFeaCombo.btnSadClick(Sender: TObject);
begin
  fMain.ShowWish('Combo features');
end;

procedure TfFeaCombo.btnBrowseClick(Sender: TObject);
begin
  dlgOpen.InitialDir := fMain.ReadRegistry_string( 'Config', 'App_CombosDir' );
  if dlgOpen.Execute then begin
    fMain.WriteRegistry_string('Config', 'App_CombosDir', ExtractFileDir(dlgOpen.FileName) );
    LoadComboFromFile( dlgOpen.FileName );
    lbComboName.Caption := comboName;
    lbComboSize.Caption := FloatToStr(comboSizeX) + ' x ' + FloatToStr(comboSizeY) + ' mm';
    ShowComponentName(UpDownComponent.Position);
    PreviewCombo;
    edComboX.SetFocus;
  end;
end;

procedure TfFeaCombo.LoadComboFromFile(filename: string);
var
  rider: TStreamReader;
  lajn: string;
  hlavicka, paramsList: TStringList;
  currSoftVersion, I, feaNum: integer;
  poleParams, poleVertexy: TPoleTextov;
  vertex: TMyPoint;
begin
  // detekcia stareho formatu suboru (do 0.3.10)
  rider := TStreamReader.Create(filename, TEncoding.UTF8);
  lajn := rider.ReadLine;
  rider.Free;
  if (lajn = '[Combo]') then begin
    LoadComboFromFile_old(filename);
    Exit;
  end;

  // nahravanie noveho formatu suboru
  hlavicka := TStringList.Create;
  rider := TStreamReader.Create(filename, TEncoding.UTF8);
  try
    lajn := rider.ReadLine;
    if (lajn = '{>header}') then begin // 1.riadok musi byt zaciatok hlavicky
      // najprv nacitanie hlavicky
      while (lajn <> '{/header}') do begin
        lajn := rider.ReadLine;
        if (Pos('=', lajn) > 0) then begin
          hlavicka.Add(lajn);
        end; // if (Pos('=', lajn) > 0)
      end; // while (lajn <> '{/header}')

      // kontrola, ci sa skutocne jedna o subor comba
      if hlavicka.Values['filetype'] <> 'quickpanel:combo' then begin
        MessageBox(Application.ActiveFormHandle, PChar(TransTxt('File not found: ')+filename + ' ('+hlavicka.Values['filetype']+')'), PChar(TransTxt('Error')), MB_ICONERROR);
        RaiseException(1, 0, 0, nil);
      end;

      // spracovanie hlavicky - kontrola verzie suboru
      currSoftVersion := (cfg_swVersion1*10000)+(cfg_swVersion2*100)+cfg_swVersion3;
      if (StrToInt(hlavicka.Values['filever']) > currSoftVersion) then begin
        MessageBox(Application.ActiveFormHandle, PChar(TransTxt('File was saved by newer version of the QuickPanel. It might not open correctly.')), PChar(TransTxt('Warning')), MB_ICONWARNING);
      end;
      // spracovanie hlavicky - udaje o samotnom paneli
      comboName  := hlavicka.Values['name'];
      comboSizeX := RoundTo( StrToFloat(hlavicka.Values['sizex']) , -2);
      comboSizeY := RoundTo( StrToFloat(hlavicka.Values['sizey']) , -2);
    end; // if lajn = '{>header}'

    paramsList := TStringList.Create;

    // *********************** nacitanie ficrov ********************************
    while lajn <> '{>features}' do lajn := rider.ReadLine;
    paramsList.Clear;
    SetLength(poleParams, 0);
    feaNum := 1;
    ExplodeString( hlavicka.Values['structfeatures'], ',', poleParams);         // vysvetlivky kodu - vid sekciu ObjectPanel:LoadFromFile:sekcia combos
    lajn := rider.ReadLine;
    while lajn <> '{/features}' do begin
      paramsList.Values[ poleParams[0] ] := lajn;
      for I := 1 to Length(poleParams)-1 do begin
        lajn := rider.ReadLine;
        paramsList.Values[ poleParams[I] ] := lajn;
      end;

      if (StrToInt(paramsList.Values['type']) = ftPolyLineGrav) then
        featuresArr[feaNum]       := TFeaturePolyLineObject.Create(nil)
      else
        featuresArr[feaNum]       := TFeatureObject.Create(nil);

      featuresArr[feaNum].ID      := feaNum;
      featuresArr[feaNum].Typ     := StrToInt(paramsList.Values['type']);
      featuresArr[feaNum].Rozmer1 := StrToFloat(paramsList.Values['size1']);
      featuresArr[feaNum].Rozmer2 := StrToFloat(paramsList.Values['size2']);
      featuresArr[feaNum].Rozmer3 := StrToFloat(paramsList.Values['size3']);
      featuresArr[feaNum].Rozmer4 := StrToFloat(paramsList.Values['size4']);
      featuresArr[feaNum].Rozmer5 := StrToFloat(paramsList.Values['size5']);
      featuresArr[feaNum].Param1  := paramsList.Values['param1'];
      featuresArr[feaNum].Param2  := paramsList.Values['param2'];
      featuresArr[feaNum].Param3  := paramsList.Values['param3'];
      featuresArr[feaNum].Param4  := paramsList.Values['param4'];
      featuresArr[feaNum].Param5  := paramsList.Values['param5'];
      featuresArr[feaNum].Poloha  := MyPoint( StrToFloat(paramsList.Values['posx']) ,
                                              StrToFloat(paramsList.Values['posy']) );
      featuresArr[feaNum].Hlbka1  := StrToFloat(paramsList.Values['depth']);

      if (featuresArr[feaNum].Typ = ftTxtGrav) then begin
        if (featuresArr[feaNum].Rozmer2 = -1) then featuresArr[feaNum].Rozmer2 := 0; // rozmer2 = natocenie textu. V starych verziach sa tam vzdy ukladalo -1 lebo parameter nebol vyuzity. Od verzie 1.0.16 bude ale default = 0
        if (featuresArr[feaNum].Param5 = '') then featuresArr[feaNum].Param5 := fFeaEngraving.comTextFontValue.Items[0];
        featuresArr[feaNum].AdjustBoundingBox; // ak je to text, musime prepocitat boundingbox lebo tento zavisi od Param1 .. Param4 a ked sa tie nahravaju do ficra, tak tam sa uz AdjustBoundingBox nevola (automaticky sa to vola len pri nastavovani Size1 .. Size5)
      end;

      // ak je to polyline, nacitame vertexy
      if (featuresArr[feaNum].Typ = ftPolyLineGrav) AND (paramsList.Values['vertexarray'] <> '' ) then begin
        ExplodeString(paramsList.Values['vertexarray'], separChar, poleVertexy);
        if ((Length(poleVertexy) > 0) AND (poleVertexy[0] <> '')) then   // ochrana ak riadok co ma obsahovat vertexy je prazdny (pole bude mat vtedy len jeden prvok - prazdny text)
          for I := 0 to Length(poleVertexy)-1 do begin
            vertex.X := StrToFloat( Copy(poleVertexy[I], 0, Pos(',', poleVertexy[I])-1 ) );
            vertex.Y := StrToFloat( Copy(poleVertexy[I], Pos(',', poleVertexy[I])+1 ) );
            (featuresArr[feaNum] as TFeaturePolyLineObject).AddVertex(vertex);
          end;
      end;

      // pre vsetky, kde sa uplatnuje farba vyplne zrusime vypln ak nie je v konfigu povolena
      if (featuresArr[feaNum].Typ >= ftTxtGrav) AND (featuresArr[feaNum].Typ < ftThread) then begin
        if not StrToBool( uConfig.Config_ReadValue('engraving_colorinfill_available') ) then featuresArr[feaNum].Param4 := 'NOFILL';
      end;

      featuresArr[feaNum].Inicializuj;

      Inc(feaNum);
      lajn := rider.ReadLine;
    end;
  finally
    hlavicka.Free;
    paramsList.Free;
    rider.Free;
  end;

  UpDownComponent.Position := 0;
  UpDownComponent.Max := feaNum-1;
  comboCenter_original := MyPoint(0,0);  // koli Preview comba
end;

procedure TfFeaCombo.LoadComboFromFile_old(filename: string);
var
  myini: TIniFile;
  i: integer;
  iass: string;     // i as string
begin
  // nahra combo otvor do docasneho pola featurov "FeaturesArr"

  // najprv povodne combo vycistime
  for i:=1 to High(featuresArr) do
    FreeAndNil( featuresArr[i] );

  try
    myini := TIniFile.Create(filename);

    for i:=1 to myini.ReadInteger('Combo','FeaNumber',0) do begin
      iass := IntToStr(i);
      featuresArr[i]         := TFeatureObject.Create(nil);
      featuresArr[i].ID      := i;
      featuresArr[i].Typ     := myini.ReadInteger('Features','FeaType_'+iass, 0);
      featuresArr[i].Rozmer1 := myini.ReadFloat('Features','Size1_'+iass, 0);
      featuresArr[i].Rozmer2 := myini.ReadFloat('Features','Size2_'+iass, 0);
      featuresArr[i].Rozmer3 := myini.ReadFloat('Features','Size3_'+iass, 0);
      featuresArr[i].Rozmer4 := myini.ReadFloat('Features','Size4_'+iass, 0);
      featuresArr[i].Param1  := myini.ReadString('Features','Param1_'+iass, '');
      featuresArr[i].Param2  := myini.ReadString('Features','Param2_'+iass, '');
      featuresArr[i].Param3  := myini.ReadString('Features','Param3_'+iass, '');
      featuresArr[i].Param4  := myini.ReadString('Features','Param4_'+iass, '');
      featuresArr[i].Poloha  := MyPoint( myini.ReadFloat('Features','PosX_'+iass, 0) ,
                                myini.ReadFloat('Features','PosY_'+iass, 0));
      featuresArr[i].Hlbka1  := myini.ReadFloat('Features','Depth_'+iass, 0);

      if (featuresArr[i].Typ = ftTxtGrav) then begin
        if (featuresArr[i].Rozmer2 = -1) then featuresArr[i].Rozmer2 := 0; // rozmer2 = natocenie textu. V starych verziach sa tam vzdy ukladalo -1 lebo parameter nebol vyuzity. Od verzie 1.0.16 bude ale default = 0
        if (featuresArr[i].Param5 = '') then featuresArr[i].Param5 := fFeaEngraving.comTextFontValue.Items[0];
        featuresArr[i].AdjustBoundingBox; // ak je to text, musime prepocitat boundingbox lebo tento zavisi od Param1 .. Param4 a ked sa tie nahravaju do ficra, tak tam sa uz AdjustBoundingBox nevola (automaticky sa to vola len pri nastavovani Size1 .. Size5)
      end;

      // pre vsetky, kde sa uplatnuje farba vyplne zrusime vypln ak nie je v konfigu povolena
      if (featuresArr[i].Typ >= ftTxtGrav) AND (featuresArr[i].Typ < ftThread) then begin
        if not StrToBool( uConfig.Config_ReadValue('engraving_colorinfill_available') ) then featuresArr[i].Param4 := 'NOFILL';
      end;

    end;
    comboName  := myini.ReadString('Combo','Name','');
    comboSizeX := RoundTo(myini.ReadFloat('Combo','SizeX',0) , -2);
    comboSizeY := RoundTo(myini.ReadFloat('Combo','SizeY',0) , -2);
  finally
    FreeAndNil(myini);
  end;

  UpDownComponent.Position := 0;
  UpDownComponent.Max := i-1;

  comboCenter_original := MyPoint(0,0);  // koli Preview comba
end;

procedure TfFeaCombo.MathExp(Sender: TObject);
begin
  uLib.SolveMathExpression(Sender);
end;

procedure TfFeaCombo.AddComboToPanel;
var
  i, newFeaID, newComboID: integer;
  offX, offY: extended;
begin

  // ak hned 1.prvok v poli comba je prazdny, tak asi nie je nahrate ziadne a koncime
  if not Assigned(featuresArr[1]) then Exit;

  _PNL.PrepareUndoStep;

  // da nahrate combo do panela
  newComboID := _PNL.AddCombo;
  _PNL.GetComboByID(newComboID).Name := comboName;
  // vyrata posunutie comba
  if (UpDownComponent.Position = 0) then begin
    // ak je polohovane vzhladom na svoj stred
    // (standardne su prvky comba kotovane na jeho stred)
    offX := 0;
    offY := 0;
    // ak je combo polohovane na stred (a nie vztahom na nejaky svoj prvok, jeho poloha bude ulozena vo vlastnosti samotneho comba)
    _PNL.GetComboByID(newComboID).Poloha := MyPoint(StrToFloat(edComboX.Text) , StrToFloat(edComboY.Text));
  end else begin
    // ak je polohovane vzhladom na nejaku zo svojich dier
    offX := -featuresArr[UpDownComponent.Position].X;
    offY := -featuresArr[UpDownComponent.Position].Y;
  end;
  // vsetky feature postupne vytvorime v paneli
  for i:=1 to High(featuresArr) do
    if Assigned( featuresArr[i] ) then begin

      // gravirovane prvky sa mozu pridavat len a jedine na stranu "A"
      if (_PNL.StranaVisible <> 1) AND (featuresArr[i].Typ >= ftTxtGrav) AND (featuresArr[i].Typ < ftThread) then  Continue;

      // vytvorime v paneli nove featury a skopirujeme do nich features z combo-lokalneho pola "featuresArr"
      newFeaID := _PNL.AddFeature( featuresArr[i].Typ );

      if (featuresArr[i].Typ = ftPolyLineGrav) then
        (_PNL.GetFeatureByID(newFeaID) as TFeaturePolyLineObject).CopyFrom( (featuresArr[i] as TFeaturePolyLineObject) )
      else
        _PNL.GetFeatureByID(newFeaID).CopyFrom(featuresArr[i]);

      _PNL.GetFeatureByID(newFeaID).Strana := _PNL.StranaVisible;
      _PNL.GetFeatureByID(newFeaID).ComboID := newComboID;
      // este upravime polohu jednotlivych featurov
      _PNL.GetFeatureByID(newFeaID).X := StrToFloat( edComboX.Text ) + featuresArr[i].X + offX;
      _PNL.GetFeatureByID(newFeaID).Y := StrToFloat( edComboY.Text ) + featuresArr[i].Y + offY;
      // vytvorenie featuru dame do undolistu
      _PNL.CreateUndoStep('CRT','FEA',newFeaID);
      // ak tento objekt sluzi ako referencia pri polohovani comba, ulozime to
      if ( i = UpDownComponent.Position ) then
        _PNL.GetComboByID(newComboID).PolohaObject := newFeaID;
    end;

    // nakoniec dame este aj vytvorenie comba do undolistu
    _PNL.CreateUndoStep('CRT','COM',newComboID);
end;

procedure TfFeaCombo.btnSaveClick(Sender: TObject);
var
  newPoloha: TMyPoint;
  tmp_bod: TMyPoint;
  edited_combo: TComboObject;
  co_robit: byte;
const
  bolo_nastred_bude_naobjekt = 1;
  bolo_naobjekt_bude_nastred = 2;
  bolo_naobjekt_bude_nainyobjekt = 3;
  zmena_len_suradnic = 4;
begin
  if (is_editing) then begin

    _PNL.PrepareUndoStep;

    edited_combo := _PNL.GetComboByID(edited_combo_ID);
    co_robit := 0;

    if (UpDownComponent.Position > 0) AND (comboPolohaObject_original = -1) then
      co_robit := bolo_nastred_bude_naobjekt
    else
      if (UpDownComponent.Position = 0) AND (comboPolohaObject_original > -1) then
        co_robit := bolo_naobjekt_bude_nastred
      else
        if (UpDownComponent.Position > 0) AND (comboPolohaObject_original <> featuresArr[UpDownComponent.Position].ID) then
          co_robit := bolo_naobjekt_bude_nainyobjekt
        else
          if ((UpDownComponent.Position = 0) AND (comboPolohaObject_original = -1))
          OR (Assigned(featuresArr[UpDownComponent.Position]) AND (comboPolohaObject_original = featuresArr[UpDownComponent.Position].ID)) then
            co_robit := zmena_len_suradnic;


    case co_robit of

      bolo_nastred_bude_naobjekt: begin
        // zistime o kolko je posunuty novy ref.bod (objekt) od povodneho (stred)
        // plus o kolko ho treba posunut, ak user zmenil aj suradnice
        tmp_bod.x := (comboCenter_original.X - _PNL.getFeatureByID( featuresArr[UpDownComponent.Position].ID ).X ) + (StrToFloat(edComboX.Text) - comboPoloha_original.X);
        tmp_bod.y := (comboCenter_original.Y - _PNL.getFeatureByID( featuresArr[UpDownComponent.Position].ID ).Y ) + (StrToFloat(edComboY.Text) - comboPoloha_original.Y);
        // a o tolko posunieme vsetky komponenty comba
        edited_combo.MoveFeaturesBy(tmp_bod);
        // teraz nastavime nove suradnice combu
        _PNL.CreateUndoStep('MOD','COM',edited_combo_ID);
        edited_combo.PolohaObject := featuresArr[UpDownComponent.Position].ID;
        edited_combo.Poloha := MyPoint( -1 , -1 );
      end; // bolo_nastred_bude_naobjekt

      bolo_naobjekt_bude_nastred: begin
        // zistime o kolko je posunuty novy ref.bod (stred) od povodneho (nejakeho combo-komponentu)
        // plus o kolko ho treba posunut, ak user zmenil aj suradnice
        tmp_bod.x := (comboPoloha_original.X - comboCenter_original.X) + (StrToFloat(edComboX.Text) - comboPoloha_original.X);
        tmp_bod.y := (comboPoloha_original.Y - comboCenter_original.Y) + (StrToFloat(edComboY.Text) - comboPoloha_original.Y);
        // a o tolko posunieme vsetky komponenty comba
        edited_combo.MoveFeaturesBy(tmp_bod);
        // teraz nastavime nove suradnice combu
        _PNL.CreateUndoStep('MOD','COM',edited_combo_ID);
        newPoloha.X := StrToFloat(edComboX.Text);
        newPoloha.Y := StrToFloat(edComboY.Text);
        edited_combo.PolohaObject := -1;
        edited_combo.Poloha := MyPoint( StrToFloat(edComboX.Text) , StrToFloat(edComboY.Text) );
      end; // bolo_naobjekt_bude_nastred

      bolo_naobjekt_bude_nainyobjekt: begin
        // zistime o kolko je posunuty novy ref.bod (objekt) od povodneho (objekt)
        // plus o kolko ho treba posunut, ak user zmenil aj suradnice
        tmp_bod.x := (_PNL.getFeatureByID( comboPolohaObject_original ).X - _PNL.getFeatureByID( featuresArr[UpDownComponent.Position].ID ).X ) +
                     (StrToFloat(edComboX.Text) - comboPoloha_original.X);
        tmp_bod.y := (_PNL.getFeatureByID( comboPolohaObject_original ).Y - _PNL.getFeatureByID( featuresArr[UpDownComponent.Position].ID ).Y ) +
                     (StrToFloat(edComboY.Text) - comboPoloha_original.Y);
        // a o tolko posunieme vsetky komponenty comba
        edited_combo.MoveFeaturesBy(tmp_bod);
        // teraz nastavime nove suradnice combu
        _PNL.CreateUndoStep('MOD','COM',edited_combo_ID);
        edited_combo.PolohaObject := featuresArr[UpDownComponent.Position].ID;
        edited_combo.Poloha := MyPoint( -1 , -1 );
      end; // bolo_naobjekt_bude_nainyobjekt

      zmena_len_suradnic: begin
        if (comboPolohaObject_original = -1) then begin
        // ak je polohovany od stredu
          tmp_bod.x := StrToFloat(edComboX.Text) - comboPoloha_original.X;
          tmp_bod.y := StrToFloat(edComboY.Text) - comboPoloha_original.Y;
          edited_combo.Poloha := MyPoint(
            edited_combo.Poloha.X + tmp_bod.X ,
            edited_combo.Poloha.Y + tmp_bod.Y
          );
          edited_combo.MoveFeaturesBy(tmp_bod);
        end else begin
        // ak je polohovany od nejakeho objektu
          tmp_bod.x := StrToFloat(edComboX.Text) - _PNL.getFeatureByID( comboPolohaObject_original ).X;
          tmp_bod.y := StrToFloat(edComboY.Text) - _PNL.getFeatureByID( comboPolohaObject_original ).Y;
          edited_combo.MoveFeaturesBy(tmp_bod);
        end;
        _PNL.CreateUndoStep('MOD','COM',edited_combo_ID);
      end; // zmena_len_suradnic

    end; // CASE

  end {if (is_editing)} else begin
    AddComboToPanel;
  end;

  _PNL.Draw;
end;

procedure TfFeaCombo.GetRAMComboInfo;
var
  i : integer;
  s: string;
begin
  fMain.Log('=ID=|=TYP=|==X===|==Y===|======================');
  for i:=1 to High(featuresArr) do
    if Assigned(featuresArr[i]) then begin
      s := FormatFloat('000  ',featuresArr[i].ID);
      s := s + FormatFloat('000   ', featuresArr[i].Typ );
      s := s + FormatFloat('##0.00 ', featuresArr[i].Poloha.X );
      s := s + FormatFloat('##0.00 ', featuresArr[i].Poloha.Y );
      fMain.Log(s);
    end;
  fMain.Log('');
  fMain.Log('min:'+inttostr(UpDownComponent.Min));
  fMain.Log('max:'+inttostr(UpDownComponent.Max));
  fMain.Log('pos:'+inttostr(UpDownComponent.Position));
end;

function TfFeaCombo.PX(mm: double; axis: string = ''): integer;
begin
  { premeni milimetre na pixle a ak je zadana aj os, tak na to prihliada }
  if (axis = 'x') then
    result := Round(mm * comboScale) + Round(imgFileCombo.Width / 2)
  else if (axis = 'y') then
    result := imgFileCombo.Height - Round(mm * comboScale) - Round(imgFileCombo.Width / 2)
  else
    result := Round(mm * comboScale);
end;

procedure TfFeaCombo.PreviewCombo;
var
  i, imgsize: integer;
  obj: ^TFeatureObject;
  tmp_p1, tmp_p2: TMyPoint;
  canv : TCanvas;
begin
  imgsize := imgFileCombo.Width;
  // vymazeme plochu obrazka
  canv := imgFileCombo.Canvas;
  canv.Brush.Color := clBtnFace;
  canv.Pen.Color := canv.Brush.Color;
  canv.Rectangle(0,0,imgsize,imgsize);
  // kreslime
  if not Assigned( featuresArr[1] ) then begin
    // ak nie je ziadne combo, nakreslime kriz
    canv.Pen.Color := clBlack;
    canv.MoveTo( 0,0 );
    canv.LineTo( imgsize,imgsize );
    canv.MoveTo( 0,imgsize );
    canv.LineTo( imgsize,0 );
  end else begin
    // vypocitame mierku pre vykreslovanie
    comboScale := (imgSize-2) / Max(comboSizeX, comboSizeY);
    // vykreslime kazdy
    for i:=1 to High(featuresArr) do begin

      // standardne nastavenia kreslenia
      canv.Pen.Color := clGray;
      canv.Pen.Width := 1;
      // nastavenia kreslenia, ked sa jedna o vybratu komponentu comba
      if (UpDownComponent.Position = i) then begin
        canv.Pen.Color := clRed;
        canv.Pen.Width := 2;
      end;
      // nastavenia kreslenia, ked sa jedna o stred celeho comba
      if (UpDownComponent.Position = 0) then
        canv.Pen.Color := clBlack;

      obj := @featuresArr[i];
      if Assigned(featuresArr[i]) then
        case obj.Typ of

          ftHoleCirc, ftPocketCirc: begin
            canv.Brush.Style := bsClear;
            canv.Ellipse(
              PX( obj.X - comboCenter_original.X - (obj.Rozmer1/2) , 'x'),
              PX( obj.Y - comboCenter_original.Y - (obj.Rozmer1/2) , 'y'),
              PX( obj.X - comboCenter_original.X + (obj.Rozmer1/2) , 'x'),
              PX( obj.Y - comboCenter_original.Y + (obj.Rozmer1/2) , 'y')
            );
            end;

          ftHoleRect, ftPocketRect: begin
            canv.Brush.Style := bsClear;
            canv.RoundRect(
              PX( obj.X - comboCenter_original.X - (obj.Rozmer1/2) , 'x'),
              PX( obj.Y - comboCenter_original.Y - (obj.Rozmer2/2) , 'y'),
              PX( obj.X - comboCenter_original.X + (obj.Rozmer1/2) , 'x'),
              PX( obj.Y - comboCenter_original.Y + (obj.Rozmer2/2) , 'y'),
              PX(obj.Rozmer3*2),
              PX(obj.Rozmer3*2)
            );
            end;

          ftThread: begin
            canv.Brush.Style := bsClear;
            canv.Ellipse(
              PX( obj.X - comboCenter_original.X - (obj.Rozmer1/2) , 'x'),
              PX( obj.Y - comboCenter_original.Y - (obj.Rozmer1/2) , 'y'),
              PX( obj.X - comboCenter_original.X + (obj.Rozmer1/2) , 'x'),
              PX( obj.Y - comboCenter_original.Y + (obj.Rozmer1/2) , 'y')
            );
            end;

          ftSink, ftSinkSpecial, ftSinkCyl: begin
            canv.Brush.Style := bsClear;
            canv.Ellipse(
              PX( obj.X - comboCenter_original.X - (obj.Rozmer1/2) , 'x'),
              PX( obj.Y - comboCenter_original.Y - (obj.Rozmer1/2) , 'y'),
              PX( obj.X - comboCenter_original.X + (obj.Rozmer1/2) , 'x'),
              PX( obj.Y - comboCenter_original.Y + (obj.Rozmer1/2) , 'y')
            );
            canv.Ellipse(
              PX( obj.X - comboCenter_original.X - (obj.Rozmer2/2) , 'x'),
              PX( obj.Y - comboCenter_original.Y - (obj.Rozmer2/2) , 'y'),
              PX( obj.X - comboCenter_original.X + (obj.Rozmer2/2) , 'x'),
              PX( obj.Y - comboCenter_original.Y + (obj.Rozmer2/2) , 'y')
            );
            end;

          ftGrooveLin: begin
            canv.Brush.Style := bsClear;
            canv.MoveTo( PX(obj.X - comboCenter_original.X, 'x'), PX(obj.Y - comboCenter_original.Y, 'y') );
            canv.LineTo( PX(obj.X - comboCenter_original.X + obj.Rozmer1, 'x'), PX(obj.Y - comboCenter_original.Y + obj.Rozmer2, 'y') );
            end;

          ftGrooveArc: begin
            canv.Brush.Style := bsClear;
            // vypocitam body, ktore urcuju start/stop obluka
            // (podla rovnice kruznice X = A + r*cos ALFA ; Y = B + r*sin BETA)
            tmp_p1.X := obj.X - comboCenter_original.X + ( (obj.Rozmer1/2) * cos(DegToRad(obj.Rozmer2)) );
            tmp_p1.Y := obj.Y - comboCenter_original.Y + ( (obj.Rozmer1/2) * sin(DegToRad(obj.Rozmer2)) );
            tmp_p2.X := obj.X - comboCenter_original.X + ( (obj.Rozmer1/2) * cos(DegToRad(obj.Rozmer3)) );
            tmp_p2.Y := obj.Y - comboCenter_original.Y + ( (obj.Rozmer1/2) * sin(DegToRad(obj.Rozmer3)) );
            // samotne vykreslenie
            canv.Arc(
              PX(obj.X - comboCenter_original.X - (obj.Rozmer1/2),'x'),
              PX(obj.Y - comboCenter_original.Y - (obj.Rozmer1/2),'y'),
              PX(obj.X - comboCenter_original.X + (obj.Rozmer1/2),'x')+1,
              PX(obj.Y - comboCenter_original.Y + (obj.Rozmer1/2),'y')-1,
              PX(tmp_p1.X, 'x'), PX(tmp_p1.Y, 'y'),
              PX(tmp_p2.X, 'x'), PX(tmp_p2.Y, 'y')
            );
            // ak treba spojit zaciatok s koncom
            if obj.Param1 = 'S' then begin
              canv.MoveTo( PX(tmp_p1.X, 'x'), PX(tmp_p1.Y, 'y') );
              canv.LineTo( PX(tmp_p2.X, 'x'), PX(tmp_p2.Y, 'y') );
            end;
            end;

        end;

    end;
  end;
end;



procedure TfFeaCombo.ShowComponentName(arr_index: integer);
begin
  // vypise do TEditu nazov komponentu comba podla parametra - indexu v poli FeaturesArr

  // ak je UpDown v specialnej polohe "0" a combo uz bolo nahrate, ponukne speci moznost
  if (UpDownComponent.Position = 0) AND ( Assigned(featuresArr[1]) ) then
    edComboComponent.Text := TransTxt('Center of the combo');
  // inak ponukne niektoru z komponent comba
  if (UpDownComponent.Position > 0) AND ( Assigned(featuresArr[arr_index]) ) then
    edComboComponent.Text := featuresArr[arr_index].GetFeatureInfo(true, false, true);
end;

procedure TfFeaCombo.UpDownComponentChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  // tu je to preto, aby preskakovali nazvy featurov ked drzim stlacenu mys na UpDown komponente...
  ShowComponentName( UpDownComponent.Position );
  PreviewCombo;
end;

procedure TfFeaCombo.UpDownComponentMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  // ...a tu je to preto, aby po pusteni mysi sa nahral ten feature, ktory ma index ako je pozicia UpDown-u (v evente Changing ani Click poziciu nepozname, lebo sa aktualizuje az po tomto evente)
  ShowComponentName( UpDownComponent.Position );
  PreviewCombo;
end;

procedure TfFeaCombo.edComboComponentKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  // ked stlaca sipku dole a hore, ovlada tym komponentu UpDown
  if (Key = 38) AND (UpDownComponent.Position < UpDownComponent.Max) then UpDownComponent.Position := UpDownComponent.Position+1;
  if (Key = 40) AND (UpDownComponent.Position > 0) then UpDownComponent.Position := UpDownComponent.Position-1;

  ShowComponentName( UpDownComponent.Position );
  PreviewCombo;

  if (Key = 13) then btnSave.Click;
end;

procedure TfFeaCombo.DecimalPoint(Sender: TObject; var Key: Char);
begin
  fMain.CheckDecimalPoint(sender, key, btnSave);
end;

procedure TfFeaCombo.EditCombo(combo_id: integer);
var
  features: TPoleIntegerov;
  i: integer;
  boundbox: TMyRect;
  combo: TComboObject;
begin
  is_editing := true;
  edited_combo_ID := combo_id;

  btnBrowse.Enabled := false;
  rbFile.Enabled    := false;
  rbLocalLibrary.Enabled := false;
  rbInternetLibrary.Enabled := false;
  lbComboName.Caption := '- - -';
  lbComboSize.Caption := '- - -';

  combo := _PNL.GetComboByID(combo_id);
  comboName := combo.Name;
  comboPolohaObject_original := combo.PolohaObject;

  boundbox := _PNL.GetComboBoundingBox(combo_id);
  comboSizeX := boundbox.BtmR.X - boundbox.TopL.X;
  comboSizeY := boundbox.TopL.Y - boundbox.BtmR.Y;

  if (combo.PolohaObject = -1) then begin
    // ak je polohovany vzhladom na svoj stred
    comboPoloha_original := combo.Poloha;
    comboCenter_original := comboPoloha_original;
    UpDownComponent.Position := 0;
  end else begin
    // ak je polohovane vzhladom na nejaky svoj komponent, musime jeho stred zistit (koli kresleniu v Preview)
    comboPoloha_original := _PNL.getFeatureByID( combo.PolohaObject ).Poloha;
    comboCenter_original.X := boundbox.TopL.X + (comboSizeX / 2);
    comboCenter_original.Y := boundbox.BtmR.y + (comboSizey / 2);
  end;

  edComboX.Text := FormatFloat('0.###', comboPoloha_original.X);
  edComboY.Text := FormatFloat('0.###', comboPoloha_original.Y);

  for i:=1 to High(featuresArr) do
    FreeAndNil( featuresArr[i] );

  _PNL.GetComboFeatures(features, combo_id);

  UpDownComponent.Max := Length(features);

  // prekopirovanie featurov comba z panela do lokalneho pola
  for i := 1 to Length(features) do begin
    featuresArr[i]    := TFeatureObject.Create(nil, _PNL.StranaVisible);
    featuresArr[i].ID := features[i-1];
    featuresArr[i].CopyFrom( _PNL.GetFeatureByID(features[i-1]) );
    // ak sme nasli prave ten komponent, podla ktoreho je polohovane combo,
    // nastavime nanho aj poziciu UpDown komponentu - nech ho ukazuje
    if (featuresArr[i].ID = combo.PolohaObject) then
      UpDownComponent.Position := i;
  end;

  ShowComponentName( UpDownComponent.Position );
  PreviewCombo;

end;

end.
