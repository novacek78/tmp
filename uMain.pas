unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,ShellApi,
  Dialogs, Menus,  Buttons, ImgList, StdCtrls, Math, Registry,
  uObjectPanel, uOtherObjects, uMyTypes, ExtDlgs, ExtCtrls, IniFiles, IdBaseComponent, IdComponent,
  IdHTTP, IdTCPConnection, IdTCPClient,  WinInet, ComCtrls, ToolWin, Printers, Jpeg,
  IdExplicitTLSClientServerBase, IdFTP, ShlObj, System.Zip, IdGlobal, IdURI, RegularExpressions,
  uObjectUrlDotaz;

type
  TfMain = class(TForm)
    MainMenu: TMainMenu;
    File1: TMenuItem;
    Help1: TMenuItem;
    HelpAbout: TMenuItem;
    FileExit: TMenuItem;
    FileSaveAs: TMenuItem;
    N1: TMenuItem;
    FileOpen: TMenuItem;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    Tools1: TMenuItem;
    ToolsPanelSett: TMenuItem;
    N2: TMenuItem;
    ToolsNewHole: TMenuItem;
    ToolsNewPocket: TMenuItem;
    ToolsNewThread: TMenuItem;
    ToolsNewText: TMenuItem;
    ToolsNewConus: TMenuItem;
    N3: TMenuItem;
    FileOrder: TMenuItem;
    http1: TIdHTTP;
    Debug1: TMenuItem;
    FileSave: TMenuItem;
    N4: TMenuItem;
    ToolsRegisterFileTypes: TMenuItem;
    StatBar: TStatusBar;
    ToolsNewGroove: TMenuItem;
    ToolsNewCombo: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    HelpWhatsNew: TMenuItem;
    N7: TMenuItem;
    FileNew: TMenuItem;
    N8: TMenuItem;
    HelpRegisterUser: TMenuItem;
    HelpRegisterCode: TMenuItem;
    FileSaveCombo: TMenuItem;
    SaveComboDialog: TSaveDialog;
    HelpCheckUpdates: TMenuItem;
    Edit1: TMenuItem;
    EditClone: TMenuItem;
    EditDelete: TMenuItem;
    EditExplodeCombo: TMenuItem;
    View1: TMenuItem;
    ViewZoomAll: TMenuItem;
    EditMakeCombo: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    ViewLanguage: TMenuItem;
    ViewLanguage_sk: TMenuItem;
    ViewLanguage_cz: TMenuItem;
    ViewLanguage_pl: TMenuItem;
    ViewLanguage_hu: TMenuItem;
    ViewLanguage_en: TMenuItem;
    ViewLanguage_de: TMenuItem;
    ViewLanguage_ru: TMenuItem;
    PopupMenu: TPopupMenu;
    N11: TMenuItem;
    popPanelProperties: TMenuItem;
    popMakeCombo: TMenuItem;
    popExplodeCombo: TMenuItem;
    N12: TMenuItem;
    popDelete: TMenuItem;
    popClone: TMenuItem;
    N13: TMenuItem;
    EditUndo: TMenuItem;
    imgList_tools: TImageList;
    imgList_common: TImageList;
    Switchtotheotherside1: TMenuItem;
    N14: TMenuItem;
    Insert1: TMenuItem;
    Hole1: TMenuItem;
    Thread1: TMenuItem;
    Pocket1: TMenuItem;
    Engraving1: TMenuItem;
    Holewithcountersink1: TMenuItem;
    Groove1: TMenuItem;
    Combofeature1: TMenuItem;
    HelpOnlineForum: TMenuItem;
    N15: TMenuItem;
    HelpOnline: TMenuItem;
    HelpCancelRegistration: TMenuItem;
    HelpWebpage: TMenuItem;
    PrintDialog: TPrintDialog;
    FilePrint: TMenuItem;
    FileExport: TMenuItem;
    FileExportImage: TMenuItem;
    ExportPictureDlg: TSaveDialog;
    ToolsNewScale: TMenuItem;
    FileExportDxf: TMenuItem;
    ftp1: TIdFTP;
    ExportDxfDlg: TSaveDialog;
    imgList_commonBig: TImageList;
    popLock: TMenuItem;
    EditLock: TMenuItem;
    EditUnlockall: TMenuItem;
    Unlockall1: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    HelpSendReport: TMenuItem;
    FileOpenRecent: TMenuItem;
    ToolBar1: TToolBar;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    btnSettings: TToolButton;
    ToolButton1: TToolButton;
    ToolButton19: TToolButton;
    btnZoomAll: TToolButton;
    btnSideSwitch: TToolButton;
    ToolButton17: TToolButton;
    btnAddHole: TToolButton;
    btnAddThread: TToolButton;
    btnAddPocket: TToolButton;
    btnAddEngraving: TToolButton;
    btnAddConus: TToolButton;
    btnAddGroove: TToolButton;
    btnAddCombo: TToolButton;
    btnAddScale: TToolButton;
    ToolButton29: TToolButton;
    btnAddGuide: TToolButton;
    ToolButton27: TToolButton;
    btnSadOther: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ViewReverseWheel: TMenuItem;
    N18: TMenuItem;
    EditMirror: TMenuItem;
    popMirror: TMenuItem;
    ViewLanguage_fr: TMenuItem;
    btnAddCosmetic: TToolButton;
    NewfromDXF1: TMenuItem;
    ToolsNewCosmetic: TMenuItem;
    procedure NewFile;
    procedure OpenFile(filename: string);
    procedure SaveFile(filename: string);
    procedure SetFormTitle;
    function  EncodeURL(url: string): string;
    function  RegisterFileTypes: boolean;
    function  InstallFonts: boolean;
    procedure ShowMultiSelect(var objekty: TPoleIntegerov; X,Y: integer);
    procedure CheckUpdates(silent: boolean = true; forced: boolean = false);
    procedure RemindRegister(hwnd: HWND);
    procedure WriteRegistry_string(key, valname, val: string);
    procedure WriteRegistry_integer(key, valname:string; val: integer);
    procedure WriteRegistry_bool(key, valname:string; val: boolean);
    function  ReadRegistry_string(key, valname: string; default: string = ''): string;
    function  ReadRegistry_integer(key, valname: string; default: integer = 0): integer;
    function  ReadRegistry_bool(key, valname: string; default: Boolean = false): boolean;
    function  RegistryValueExists(key,value: string): boolean;
    procedure ShowWish(title: string = '');
    procedure CheckDecimalPoint(sender: TObject; var Key: Char; defaultButton: TCustomButton);
    procedure DrawTabs(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure LoadRecentFiles;
    procedure AddToRecentFiles(filename: string);
    procedure UpdateRecentMenu;
    procedure SaveRecentFiles;
    procedure OpenRecentFile(sender: TObject);
    procedure LogToTextFile(msg: string);
    procedure DPI_correction(obj: TObject);

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormDblClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    procedure FileExitClick(Sender: TObject);
    procedure HelpAboutClick(Sender: TObject);
    procedure btnSettingsClick(Sender: TObject);
    procedure btnAddHoleClick(Sender: TObject);
    procedure FileSaveAsClick(Sender: TObject);
    procedure FileOpenClick(Sender: TObject);
    procedure FileOrderClick(Sender: TObject);
    procedure Debug1Click(Sender: TObject);
    procedure FileSaveClick(Sender: TObject);
    procedure btnAddPocketClick(Sender: TObject);
    procedure btnAddThreadClick(Sender: TObject);
    procedure btnAddEngravingClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ToolsRegisterFileTypesClick(Sender: TObject);
    procedure btnAddConusClick(Sender: TObject);
    procedure FileNewClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HelpWhatsNewClick(Sender: TObject);
    procedure btnAddComboClick(Sender: TObject);
    procedure HelpRegisterUserClick(Sender: TObject);
    procedure HelpRegisterCodeClick(Sender: TObject);
    procedure btnAddGuideClick(Sender: TObject);
    procedure FileSaveComboClick(Sender: TObject);
    procedure btnAddGrooveClick(Sender: TObject);
    procedure btnGuidesClick(Sender: TObject);
    procedure HelpCheckUpdatesClick(Sender: TObject);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure btnZoomAllClick(Sender: TObject);
    procedure EditCloneClick(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure EditDeleteClick(Sender: TObject);
    procedure File1Click(Sender: TObject);
    procedure EditExplodeComboClick(Sender: TObject);
    procedure EditMakeComboClick(Sender: TObject);
    procedure SetLanguage(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditUndoClick(Sender: TObject);
    procedure btnSadOtherClick(Sender: TObject);
    procedure btnSideSwitchClick(Sender: TObject);
    procedure Hole1Click(Sender: TObject);
    procedure Thread1Click(Sender: TObject);
    procedure Pocket1Click(Sender: TObject);
    procedure Engraving1Click(Sender: TObject);
    procedure Holewithcountersink1Click(Sender: TObject);
    procedure Groove1Click(Sender: TObject);
    procedure Combofeature1Click(Sender: TObject);
    procedure HelpOnlineClick(Sender: TObject);
    procedure HelpOnlineForumClick(Sender: TObject);
    procedure HelpCancelRegistrationClick(Sender: TObject);
    procedure HelpWebpageClick(Sender: TObject);
    procedure FilePrintClick(Sender: TObject);
    procedure FileExportImageClick(Sender: TObject);
    procedure btnAddScaleClick(Sender: TObject);
    procedure BrowseUrl(url: string);
    procedure BrowseWiki(topic: string);
    procedure FileExportDxfClick(Sender: TObject);
    procedure EditLockClick(Sender: TObject);
    procedure EditUnlockallClick(Sender: TObject);
    procedure ftp1Status(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure HelpSendReportClick(Sender: TObject);
    procedure EditMirrorClick(Sender: TObject);
    procedure btnAddCosmeticClick(Sender: TObject);
    procedure NewfromDXF1Click(Sender: TObject);
  private
    { Private declarations }
    procedure CleanUpRegistry;
  public
    function  RunPhpScript(url: TUrlDotaz; oknoHandle: THandle; silent: boolean = false): boolean; overload;
    function  RunPhpScript(url: string; oknoHandle: THandle; silent: boolean = false): boolean; overload;
    procedure Log(s: string; showform: boolean = false); overload;
    procedure Log(p: TMyPoint; showform: boolean = false); overload;
    procedure Log(b: boolean; showform: boolean = false); overload;
    procedure Log(i: integer; showform: boolean = false); overload;
    procedure Log(f: double;  showform: boolean = false); overload;
    procedure Log(strarr: TPoleTextov; showform: boolean = false); overload;
    procedure Log(sl: TStringList; showform: boolean = false); overload;
  end;




const
  dsNetahaSa = 0;
  dsBudeSaTahat = 1;
  dsTahaSa = 2;
  dsDotahaloSa = 3;
  dsTahaSaVyberovyObdlz = 4;
  dsVyberaSaGuideline = 5;

var
  fMain: TfMain;
  _PNL: TPanelObject;
  Language: string;
  UrlAnswer: string;
  BackPlane: TBitmap;      // double buffering plane
  DragStartX, DragStartY : integer;
  PanStartPoint : TPoint;
  DragOldX,   DragOldY   : integer;
  stavTahania: byte; // 0 = netahame, 1 = budeme tahat, 2 = tahame, 3 = dotahali sme, 4 = tahame vyberovy obd.
  dragObjekt: integer; // ktory objekt tahame
  dragStartPoint: TMyPoint; // v ktorom bode (v mm) sme zacali tahat
  totalDragDistanceObjects: TMyPoint;
  totalDragDistanceMouse  : TMyPoint;
  snapGridPX: Integer; // mriezka prichytavania prepocitana na px
  snappedToGuideline_X, snappedToGuideline_Y: Boolean;
  highlightFeatureId: Integer = -2; // ID ficury, ktoru treba zvyraznit (pocas prechadzania mysou ponad multiselect buttony)
  MultiselectTlacitka: TMultiselectButtonsContainer;  // ak sa klikne na miesto s viacerymi objektami, tu budu ulozene vyberove buttony
  multiselectShowing: boolean = false; // ci su zobrazene multiselect tlacitka
  popupPoint: TPoint;
  recentFiles: TStringList;
  tmpLogStringList: tstringlist; // docasne ulozisko kam mozme logovat eventy, kym este fDebug vobec neexistuje a neda sa logovat tam (vyuzite napr. pocas fMain onCreate)
  RemoteLogEnabled: boolean; // ak je aktivny (start app so stlacenym SHIFT) tak loguje detailne resp. loguje na web
  EngravingNotBlackMessageSeen: Boolean = False;
  PanelSettingsSeen: Boolean = False;
  ignoreNextMouseDown, ignoreNextMouseUp: Boolean; // dbl-click hned za sebou odpali aj onMouseDown a onMouseUp - toto je pre odfiltrovanie
{$IFDEF DEBUG}
  CPUTimestampFrequency: Int64;
  CPUTimestamp: Int64;
  FPSsum: Double;
  FPSsumCount: Integer;
  FPSavg: Double;
{$ENDIF}


implementation

uses uSplash, uPanelSett, uFeaHole, uObjectFeature, uObjectCombo, uOrderForm,
  uDebug, uConfig, uFeaPocket, uFeaThread, uPersonal, uFeaEngrave, uFeaConus,
  uBrowser, uFeaCombo, uRegisterUser, uRegisteredCode, uPoziadavka,
  uFeaGroove, uGuides, uToolClone, uTranslate, uPrinting, uFeaScale,
  uObjectDXFDrawing, uDrawLib, uObjectComboList, uOrderComment, uLib, uToolMirror, uUpdateNotification, uFeaCosmetic, uDXFImport;

{$R *.dfm}

procedure TfMain.FormCreate(Sender: TObject);
var
  tmpdir: string;
  path: array[0..Max_Path] of Char;
begin
{$IFDEF DEBUG}
  QueryPerformanceFrequency(CPUTimestampFrequency); // treba pri merani vykonu prekreslovania v Draw() panela
  FPSsum := 0;
  FPSsumCount := 0;
  FPSavg := 0;
{$ENDIF}

	tmpLogStringList := TStringList.Create;

  MultiselectTlacitka := TMultiselectButtonsContainer.Create;

  RemoteLogEnabled := (GetKeyState(VK_SHIFT) < 0); // ak start so stlacenym SHIFT, prepne do rezimu, kedy loguje cinnost na dialku (vo funkcii Log() )

  if RemoteLogEnabled then
    Log('---- log started [REMOTE LOG ENABLED] ----')
  else
    Log('---- log started [LOCAL LOG ONLY] ----');
  Log('Entering FormCreate');

  FormatSettings.DecimalSeparator := '.';
  // nastavime vychodzi adresar pre umiestnenie panelov
  tmpdir := ReadRegistry_string('Config', 'App_PanelsDir');
  if tmpdir='' then begin
    ShGetSpecialFolderPath(0, path, CSIDL_Personal, False); // zistime si cestu k MyDocuments
    tmpdir := path + '\QuickPanel\Panels';
  end;

  Log('Panels dir set');

  OpenDialog.InitialDir := tmpdir;
  SaveDialog.InitialDir := tmpdir;
  // vytvorime zadnu rovinu pre DoubleBuffering
	try
    BackPlane := TBitmap.Create;
    BackPlane.Width := Screen.Width;
    BackPlane.Height := Screen.Height;
  except
		messagebox(0, 'BackPlane create error', 'Error', MB_OK);
  end;

  Log('Drawing canvas created');

  // nastavime jazyk interface-u
  Language := ReadRegistry_string('Config', 'App_Language');
  if (Language = '') then Language := 'en';
  if Language='sk' then ViewLanguage_sk.Checked := true;
  if Language='cz' then ViewLanguage_cz.Checked := true;
  if Language='pl' then ViewLanguage_pl.Checked := true;
  if Language='hu' then ViewLanguage_hu.Checked := true;
  if Language='de' then ViewLanguage_de.Checked := true;
  if Language='en' then ViewLanguage_en.Checked := true;
  if Language='ru' then ViewLanguage_ru.Checked := true;

  // nainstalujeme potrebne fonty
  //(uz netreba od 1.0.7 mame vlastny font)
  //InstallFonts;

  // nahrame config (v CheckUpdates to uz treba mat)
  uConfig.LoadConfigToMemory;
  Log('Config loaded');

  // nahrame zoznam posledne otvorenych
  LoadRecentFiles;
  Log('Recent files loaded');
  Log('FormCreate END');
end;

procedure TfMain.FormShow(Sender: TObject);
var
  i: integer;
begin
  // vsetko, co bolo logovane pocas startupu do temporary StringListu zalogujeme do TMemo a temporary zrusime
  Log('Entering FormShow');

{$IFNDEF DEBUG}
  // skontroluje aktualizacie na webe
  CheckUpdates;
  Log('Updates checked');
{$ENDIF}

	if Assigned(fDebug) then begin
  	fDebug.memo.Lines.AddStrings(tmpLogStringList);
    tmpLogStringList.Free;
  end;


{$IFNDEF DEBUG}
  Debug1.Visible := false;
{$ENDIF}

  CleanUpRegistry;

  Log('Config read start...');

  // nahrame konfiguracny fajl (obsahy combo boxov atd)
  uConfig.Config_ReadCombo( fPanelSett.comHrubka, 'material_thickness', 'keys');
  uConfig.Config_ReadCombo( fPanelSett.comHrubkaValue, 'material_thickness', 'values');
  uConfig.Config_ReadCombo( fPanelSett.comPovrch, 'surface_finish', 'keys');
  uConfig.Config_ReadCombo( fPanelSett.comPovrchValue, 'surface_finish', 'values');
  uConfig.Config_ReadCombo( fPanelSett.comEdgeStyle, 'edge_style', 'keys');
  uConfig.Config_ReadCombo( fPanelSett.comEdgeStyleValue, 'edge_style', 'values');

  uConfig.Config_ReadCombo( fPersonal.comPaymentMethod, 'payment_method', 'keys');
  uConfig.Config_ReadCombo( fPersonal.comPaymentMethodValue, 'payment_method', 'values');
  uConfig.Config_ReadCombo( fPersonal.comDelivery, 'delivery_way', 'keys');
  uConfig.Config_ReadCombo( fPersonal.comDeliveryValue, 'delivery_way', 'values');
  uConfig.Config_ReadCombo( fPersonal.comPriority, 'order_priority', 'keys');

  uConfig.Config_ReadCombo( fFeaThread.comThreadType, 'thread_type', 'keys');
  uConfig.Config_ReadCombo( fFeaThread.comThreadTypeValue, 'thread_type', 'values');
  uConfig.Config_ReadCombo( fFeaThread.comThreadSize, 'thread_size_M', 'keys');
  uConfig.Config_ReadCombo( fFeaThread.comThreadSizeValue, 'thread_size_M', 'values');
  uConfig.Config_ReadCombo( fFeaThread.comThreadMaxDepth, 'thread_maxdepth_M', 'values');
  fFeaThread.comThreadMaxDepth.ItemIndex := fFeaThread.comThreadSize.ItemIndex;

  uConfig.Config_ReadCombo( fFeaEngraving.comEngravingTool, 'engraving_tip_diameter', 'keys');
  uConfig.Config_ReadCombo( fFeaEngraving.comEngravingToolValue, 'engraving_tip_diameter', 'values');
  uConfig.Config_ReadCombo( fFeaEngraving.comFillColor, 'engraving_colorfill_color', 'keys');
  uConfig.Config_ReadCombo( fFeaEngraving.comFillColorValue, 'engraving_colorfill_color', 'values');

  uConfig.Config_ReadCombo( fFeaHole.comEdgeStyle, 'edge_style', 'keys');
  uConfig.Config_ReadCombo( fFeaHole.comEdgeStyleValue, 'edge_style', 'values');

  uConfig.Config_ReadCombo( fFeaPocket.comEdgeStyle, 'edge_style', 'keys');
  uConfig.Config_ReadCombo( fFeaPocket.comEdgeStyleValue, 'edge_style', 'values');

  uConfig.Config_ReadCombo( fFeaConus.comConusSize, 'conus_size_M', 'keys');
  uConfig.Config_ReadCombo( fFeaConus.comConusSizeValue, 'conus_size_M', 'values');
  uConfig.Config_ReadCombo( fFeaConus.comConusSizeDepth, 'conus_maxdepth_M', 'values');
  uConfig.Config_ReadCombo( fFeaConus.comConusSizeBigdia, 'conus_bigdia_M', 'values');
  uConfig.Config_ReadCombo( fFeaConus.comConusSizeSmalldia, 'conus_smalldia_M', 'values');

  // zobrazime dodatocne moznosti podla configu
  fPanelSett.cbCustomMaterial.Visible := StrToBool( uConfig.Config_ReadValue('material_custom_available') );
  if (not StrToBool ( uConfig.Config_ReadValue('engraving_colorinfill_available') )) then begin
    fFeaEngraving.lbFillColor.Visible := false;
    fFeaEngraving.comFillColor.Visible := false;
    fFeaEngraving.ClientHeight := fFeaEngraving.ClientHeight - 50;
  end;

  // nastavime vsetkym itemindex podla viditelneho:
  fFeaConus.ComConusChange(fFeaConus.comConusSize);

   Log('Translation start...');
	// prelozime podmienky registracie
  fRegisterUser.Memo1.Lines.Add( TransTxt('register_legalnotice_1') );
  fRegisterUser.Memo1.Lines.Add( TransTxt('register_legalnotice_2') );
  fRegisterUser.Memo1.Lines.Add( TransTxt('register_legalnotice_3') );

  // prelozime vsetke TForm-y a ich komponenty
  for i := 0 to Application.ComponentCount-1 do begin
    if Application.Components[i].ClassParent = TForm then
      if Application.Components[i].Name <> 'fSplash' then // Splash neprekladaj
        TransObj(Application.Components[i]);
  end;

  // v oknach, kde je viac Tabov nastavime defaultne taby
  fFeaHole.PgCtrl.ActivePageIndex := 0;
  fFeaPocket.PgCtrl.ActivePageIndex := 0;
  fFeaThread.PgCtrl.ActivePageIndex := 0;
  fFeaEngraving.PgCtrl.ActivePageIndex := 0;
  fFeaEngraving.pnlLine.BringToFront;

  Log('DPI of the system: '+IntToStr(Screen.PixelsPerInch));

  Log('DPI correction start...');

	DPI_correction(fPanelSett.Image1);

	DPI_correction(fFeaHole.Image2);
	DPI_correction(fFeaHole.Image3);

	DPI_correction(fFeaPocket.Image2);
	DPI_correction(fFeaPocket.Image3);

	DPI_correction(fFeaConus.Image1);
	DPI_correction(fFeaConus.imgConus);
	DPI_correction(fFeaConus.imgConusCyl);

  // vytvori novy "cisty" panel
  NewFile; // toto musi byt pred riadkom  WindowState := wsMaximized;  (ten vyvola FormActivate, ktory nahrava panel podla parametru v prikazovom riadku)

  Log('New panel created');
  Log('Loading window size + position...');

  if RegistryValueExists('Config','App_WindowMaximized') then begin
    Log('Reading window size + position from registry');
    if (ReadRegistry_bool('Config', 'App_WindowMaximized')) then begin
      with Screen.MonitorFromWindow(fMain.Handle).WorkAreaRect do
        fMain.SetBounds(Left, Top, Right - Left, Bottom - Top);
      WindowState := wsMaximized;  // pozor! tento riadok vyvola funkciu FormActivate()
    end else begin
      Left   := ReadRegistry_integer('Config', 'App_WindowLeft');
      Top    := ReadRegistry_integer('Config', 'App_WindowTop');
      Width  := ReadRegistry_integer('Config', 'App_WindowWidth');
      Height := ReadRegistry_integer('Config', 'App_WindowHeight');
    end;
  end;

  fMain.ViewReverseWheel.Checked := ReadRegistry_bool('Config', 'App_ReverseMouseWheel');

  Log('FormShow END');
end;

procedure TfMain.FormActivate(Sender: TObject);
begin
  Log('Entering FormActivate');

  // len otestujeme, ci kod partnera je platne cislo - ak nie, ma smolu
  try
    StrToInt(cfg_PartnerCode);
  except
    MessageBox(handle, PChar(TransTxt('Corrupted file')+ ' "configprt.dat".'+#13
                            +TransTxt('Retry downloading the application, or contact site administrator please.')), PChar(TransTxt('Error')), MB_ICONERROR);
    cfg_PartnerName := 'error';
    Application.Terminate;
    Exit;
  end;

  Log('Checking for start parameters...');

  // ak bola app. spustena s nejakym parametrom, skusim podla neho otvorit subor
  // subor nahram ale len vtedy, ak panel este nebol nahraty (_PNL.FileName = ''). Inak by ho otvaral pri kazdom FormActivate
  if (ParamStr(1) <> '') AND ((not Assigned(_PNL)) OR (_PNL.FileName = '')) then begin
    OpenFile(ParamStr(1));
    SetFormTitle;
  end;

  // pootravuje zivot - aby sa user zaregistroval
  //RemindRegister(Handle);  --- tu ked to zavolam, tak sa nevykresli MainMenu a potom je celkovy dojem z app na prd

  Log('Main form LEFT:'+IntToStr(fMain.Left));
  Log('Main form TOP:'+IntToStr(fMain.Top));
  Log('Main form WIDTH:'+IntToStr(fMain.Width));
  Log('Main form HEIGHT:'+IntToStr(fMain.Height));
  Log('FormActivate END');

{$IFNDEF DEBUG}
  // po starte (a vytvoreni cisteho panela) zobrazime dialog nastavenia panela pre luzrov, co si nevedia najst ikonku, kde sa to nastavuje (len ak sa otvorila app s cistym panelom)
  if (_PNL.FileName = '') AND (not PanelSettingsSeen) then begin
    fPanelSett.ShowModal;
    PanelSettingsSeen := True;
  end;
{$ENDIF}

end;

procedure TfMain.FormPaint(Sender: TObject);
begin
  if Assigned(_PNL) then
    _PNL.Draw;
end;

procedure TfMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  move_by_x, move_by_y: double;
  i: integer;
  poleNajdenychID: TPoleIntegerov;
  posunuteComba: TStringList;
begin
  // pohybovanie objektami pomocou sipok
  move_by_x := 0;
  move_by_y := 0;

  if ((Key=37) OR (Key=38) OR (Key=39) OR (Key=40))
  AND (_PNL.GetSelectedFeaturesNum.i1+_PNL.GetSelectedFeaturesNum.i2 > 0) then begin   // i1=pocet vybratych featurov, i2=pocet vybratych combo
    case Key of
      37: move_by_x := -_PNL.Grid;  // 37 = VLAVO
      38: move_by_y :=  _PNL.Grid;  // 38 = HORE
      39: move_by_x :=  _PNL.Grid;  // 39 = VPRAVO
      40: move_by_y := -_PNL.Grid;  // 40 = DOLU
    end;

    _PNL.PrepareUndoStep;

    posunuteComba := TStringList.Create; // zaznacime si ID kazdeho comba, s ktorym sa pohlo (kazde len 1 krat)
    posunuteComba.Sorted := true;        // potrebne pre nasledujuci riadok
    posunuteComba.Duplicates := dupIgnore; // zabezpecime, aby ignoroval duplicitne vlozenie jedneho ID comba (lebo to sa vklada pri kontrole kazdeho prvku comba)

    for i := 0 to _PNL.Features.Count-1 do begin
      if Assigned(_PNL.Features[i])
      AND (_PNL.Features[i].Selected) then begin
        _PNL.CreateUndoStep('MOD','FEA', _PNL.Features[i].ID);
        if (_PNL.Features[i].ComboID > -1) then
          posunuteComba.Add( IntToStr(_PNL.Features[i].ComboID) );
      end;
    end;

    for i := 0 to posunuteComba.Count - 1 do begin
      // kazdemu combu, s ktorym sa pohlo vytvorime UNDO zalohu
      _PNL.CreateUndoStep('MOD','COM', StrToInt(posunuteComba.Strings[i]));
    end;

    posunuteComba.Free;

    _PNL.MoveSelected(move_by_x, move_by_y);
    _PNL.Draw;

    // ak je mys na pohybovanom objekte, aktualizuje info v statusbare
    _PNL.GetFeaturesAt(poleNajdenychID, ScreenToClient(Mouse.CursorPos).X, ScreenToClient(Mouse.CursorPos).Y );
    if (Length(poleNajdenychID) > 1) then    // ak je tam viac objektov
      // ukaze pocet objektov
      StatBar.Panels[1].Text := IntToStr(Length(poleNajdenychID))+' '+TransTxt('objects');
    if (Length(poleNajdenychID) = 1) then    // ak je tam len 1 kus
      // ukaze, co to je za objekt (info o nom)
      StatBar.Panels[1].Text := _PNL.GetFeatureByID( poleNajdenychID[0] ).GetFeatureInfo(false, true);
    // ak odide objekt spod mysi, zmaze statusbarovy text
    if (Length(poleNajdenychID) = 0) then
      StatBar.Panels[1].Text := '';

  end; // if Key=37..40
end;

procedure TfMain.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = 'n' then btnSettings.Click;   // nastavenia
  if Key = 'o' then btnAddHole.Click;    // otvor
  if Key = 'k' then btnAddPocket.Click;  // kapsa
  if Key = 'z' then btnAddThread.Click;  // zavit
  if Key = 'u' then btnAddConus.Click;   // kuzel
  if Key = 'g' then btnAddEngraving.Click; // gravirovanie
  if Key = 'd' then btnAddGroove.Click;  // drazka
  if Key = 'c' then btnAddCombo.Click;   // combo
end;

procedure TfMain.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = 65) AND (ssCtrl in Shift) then begin   // [CTRL + A]
    _PNL.SelectAll;
    _PNL.Draw;
  end;
  if Key = 27 then begin    // [ESC]
    MultiselectTlacitka.Clear;
    _PNL.DeselectAll;
    _PNL.Draw;
    Cursor := crDefault;
  end;
end;

procedure TfMain.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  poleNajdenych: TPoleIntegerov;  // pole s IDckami objektov na danych suradniciach
  drziCtrl: boolean;
  highlightedId: Integer;
begin
  if ignoreNextMouseDown then begin
    ignoreNextMouseDown := False;
    Exit;
  end;

  if multiselectShowing then begin

    highlightedId := MultiselectTlacitka.GetFeatureIdUnderMouse(X,Y);
    if highlightedId > -1 then begin

      _PNL.GetFeatureByID(highlightedId).Selected := True;
      MultiselectTlacitka.Clear;
      _PNL.Draw;

      if MultiselectTlacitka.DoubleClickWaiting then begin
        MultiselectTlacitka.DoubleClickWaiting := False;
        _PNL.GetFeatureByID(highlightedId).StartEditing;
      end;

      Exit;
    end;
  end;

  if (stavTahania = dsVyberaSaGuideline) then begin
    stavTahania := dsNetahaSa;
    fToolMirror.GuideLineSelected;
    Exit;
  end;

  if (fGuides.cbSnapToGrid.Checked) then
    snapGridPX := PX(_PNL.Grid)
  else
    snapGridPX := 0;

  dragStartPoint.X := MM(X, 'x');
  dragStartPoint.Y := MM(Y, 'y');

  totalDragDistanceObjects.X := 0;
  totalDragDistanceObjects.Y:= 0;
  totalDragDistanceMouse.X := 0;
  totalDragDistanceMouse.Y := 0;

  snappedToGuideline_X := False;
  snappedToGuideline_Y := False;

  DragStartX := X;
  DragStartY := Y;

  // ak stlacil stredne, zaznacim si kde ho stlacil - bude sa "pannovat"
  if (Button = mbMiddle) then begin
    PanStartPoint.X := X;
    PanStartPoint.Y := Y;
    Cursor := crHandPoint;
  end;

  if (Button <> mbLeft) then Exit;

  drziCtrl := (ssCtrl in Shift);

  // ak je kurzor 4-kriz (ale nestlaceny CTRL), bude sa hybat objektom/objektami
  if (Cursor = crSizeAll) AND (not drziCtrl) then begin
    DragStartX := X;
    DragStartY := Y;
    stavTahania := dsBudeSaTahat;
  end; /// Cursor = crSizeAll

  // ak je kurzor obycajny (alebo je stlaceny CTRL), bude sa selectovat/deselectovat
  if (Cursor = crDefault) OR drziCtrl then begin
    if _PNL.GetFeaturesAt(poleNajdenych, X, Y) then begin
      // ak nasiel aspon jeden obj.
      if Length(poleNajdenych) = 1 then begin

        // ak tam nasiel prave jeden objekt, vyselectuje LEN jeho
        stavTahania := dsNetahaSa;
        MultiselectTlacitka.Clear;
        if drziCtrl then begin
          _PNL.GetFeatureByID(poleNajdenych[0]).Selected := not _PNL.GetFeatureByID(poleNajdenych[0]).Selected;
          // ak je objekt sucastou comba, tak selectuje/deselectuje cele combo
          _PNL.SelectCombo( _PNL.GetFeatureByID(poleNajdenych[0]).comboID , _PNL.GetFeatureByID(poleNajdenych[0]).selected );
        end else begin
          _PNL.DeselectAll;
          _PNL.GetFeatureByID(poleNajdenych[0]).Selected := true;
          // ak je objekt sucastou comba, vyselectuje cele combo
          _PNL.SelectCombo( _PNL.GetFeatureByID(poleNajdenych[0]).comboID );
          DragStartX := X;
          DragStartY := Y;
          stavTahania := dsBudeSaTahat;
        end;

      end else begin
        // ak je tam viac objektov, do statusu napise len ich pocet
        StatBar.Panels[1].Text := IntToStr(Length(poleNajdenych))+' '+TransTxt('objects');
        // ak tam nasiel viac objektov, da na vyber, ktory sa ma vybrat
        if not drziCtrl then _PNL.DeselectAll;
        MultiselectTlacitka.Clear;
        MultiselectTlacitka.Fill(poleNajdenych, X, Y);
        stavTahania := dsNetahaSa;
      end;
    end else begin
      if (not drziCtrl) then // ked drzim CTRL a kliknem do prazdna, tak aby mi nezrusil to co uz mam vyselektovane
        _PNL.DeselectAll; // ak nenasiel nic, deselectuje vsetky
      MultiselectTlacitka.Clear;  // skryje multivyber (ak je nahodou zobrazeny)
      // pripravime sa na tahanie (kreslenie) vyberoveho obdlznika
      DragStartX := X;
      DragStartY := Y;
      stavTahania := dsTahaSaVyberovyObdlz;
    end;
  end; /// if Cursor = crDefault
  _PNL.Draw;
end;

procedure TfMain.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  poleNajdenychID: TPoleIntegerov;
  poleNajdenychGuides: TMyInt2x;
  najdeneGuidesTxt: string;
  jeTamVybraty: boolean;
  guideline: TGuideObject;
  panelNeedsRedraw: Boolean;
  closestGuideDistance_X, closestGuideDistance_Y: Extended; // vzdialenost k najblizsiemu (zatial) najdenemu guidelineu
  closestGuide_X, closestGuide_Y: integer; // index najblizsieho (zatial) najdeneho guidelineu
  dummyFloat: Extended;
  closestGuidelineId: Integer;
  ficura_prva: TFeatureObject;
  mysPosMm: TMyPoint; // poloha mysi v mm
  closestDistanceMm: Extended;
  newHighlighted: Integer;
  tmpRect: TRect;
begin
  panelNeedsRedraw := False;

  // stava sa,ze po prebudeni PC z usporneho rezimu nastavi OS desatinny oddelovac
  // na default hodnotu "," , tak takto sa to okamzite vzdy opravi...
  FormatSettings.DecimalSeparator := '.';

  // dynamicke zobrazovanie suradnic v status bare
  StatBar.Panels[0].Text := FormatFloat('0.000', Mm(X,'x')) + ' ; ' + FormatFloat('0.000', Mm(Y,'y'));

  if multiselectShowing then begin

    // najprv len zistim, ci je mys nad nejakym tlacitkom (take treba zvyraznit)
    newHighlighted := MultiselectTlacitka.GetFeatureIdUnderMouse(X, Y);

    // ak je stale vysvieteny ten isty, nie je dovod nieco prekreslovat
    if newHighlighted = highlightFeatureId then Exit;

    _PNL.Draw(False);

    if newHighlighted > -1 then
      _PNL.GetFeatureByID(newHighlighted).Highlighted := True;

    _PNL.DrawHighlightedOnly(False);

    MultiselectTlacitka.Draw(False);

    // na zaver sa skopiruje na viditelnu canvas
    tmpRect := fMain.Canvas.ClipRect;
    fMain.Canvas.CopyRect(tmpRect, BackPlane.Canvas, tmpRect);

    if newHighlighted > -1 then
      _PNL.GetFeatureByID(newHighlighted).Highlighted := False;

    highlightFeatureId := newHighlighted;
    Exit;
  end;

  // ak vyberam guideline-u (pre mirror operaciu napr.) tak prechadzame zoznamom guidelineov a najblizsiu vyselektujeme
  if (stavTahania = dsVyberaSaGuideline) then begin

    mysPosMm.X := MM(X, 'x');
    mysPosMm.Y := MM(Y, 'y');
    closestDistanceMm := 9999;
    closestGuidelineId := -1;

    for i := 0 to _PNL.Guides.Count-1 do begin

      guideline := _PNL.Guides[i];

      if (guideline.Typ = 'V') then begin
        dummyFloat := Abs(guideline.Param1 - mysPosMm.X);
        if dummyFloat < closestDistanceMm then begin
          closestDistanceMm := dummyFloat;
          closestGuidelineId := guideline.ID;
        end;
      end;

      if (guideline.Typ = 'H') then begin
        dummyFloat := Abs(guideline.Param1 - mysPosMm.Y);
        if dummyFloat < closestDistanceMm then begin
          closestDistanceMm := dummyFloat;
          closestGuidelineId := guideline.ID;
        end;
      end;

    end;

    if (uToolMirror.closestGuideline <> closestGuidelineId) then begin
      uToolMirror.closestGuideline := closestGuidelineId;
      _PNL.DeselectAllGuidelines;
      _PNL.GetGuideLineById(closestGuidelineId).Selected := True;
      _PNL.Draw;
    end;
    Exit;
  end;

  // ak nie je stlacene ziadne tlacitko na mysi
  if not(ssLeft in Shift) AND not(ssMiddle in Shift) AND not(ssRight in Shift) then begin
    // ak sa mys pohybuje nad nejakym objektom
    _PNL.GetFeaturesAt(poleNajdenychID, X,Y);
    if ( Length(poleNajdenychID) > 0) then begin

      if Length(poleNajdenychID) = 1 then begin    // ak je tam len 1 kus
        ficura_prva := _PNL.GetFeatureByID( poleNajdenychID[0] );
        // ak hybem s mysou a som nad objektom a nie je stlacene ziadne tlacitko (netaha nejaky objekt),
        // tak ukaze, co to je za objekt (info o nom)
        StatBar.Panels[1].Text := ficura_prva.GetFeatureInfo(false, true);
        // ak je dany objekt vybraty, zmeni kurzor na 4 sipky
        if (ficura_prva.Selected) AND not(ssCtrl in Shift) then
          Cursor := crSizeAll
        else
          Cursor := crDefault;

      end else begin                             // ak je tam viac kusov
        // ak je tam viac objektov, do statusu napise len ich pocet
        StatBar.Panels[1].Text := IntToStr(Length(poleNajdenychID))+' '+TransTxt('objects');
        // zisti, ci niektory z tych X objektov je vyselectovany. A ak ano, zmeni kurzor na posuvny
        jeTamVybraty := false;
        for i := 0 to High(poleNajdenychID) do begin
          if _PNL.GetFeatureByID( poleNajdenychID[i] ).Selected then
            jeTamVybraty := true;
        end;
        if jeTamVybraty AND not(ssCtrl in Shift) then
          Cursor := crSizeAll
        else
          Cursor := crDefault;

      end;
    end else begin
      Cursor := crDefault;
      StatBar.Panels[1].Text := '';
    end;

    // otestujem este ci nie som nad dakou guideline
    poleNajdenychGuides := _PNL.GetGuidelinesAt(X, Y);

    if (poleNajdenychGuides.i1 > 0) OR (poleNajdenychGuides.i2 > 0) then begin

      if poleNajdenychGuides.i1 > 0 then begin
        najdeneGuidesTxt := TransTxt('Vertical') + ' ' + FloatToStr(_PNL.GetGuideLineById(poleNajdenychGuides.i1).Param1) + 'mm';
      end;

      if (poleNajdenychGuides.i1 > 0) AND (poleNajdenychGuides.i2 > 0) then begin
        najdeneGuidesTxt := najdeneGuidesTxt + ', ';
      end;

      if poleNajdenychGuides.i2 > 0 then begin
        najdeneGuidesTxt := najdeneGuidesTxt + TransTxt('Horizontal') + ' ' + FloatToStr(_PNL.GetGuideLineById(poleNajdenychGuides.i2).Param1) + 'mm';
      end;

      StatBar.Panels[2].Text := najdeneGuidesTxt;
    end else begin

      // ak nie som fakt nad ziadnym objektom (ani nad guideline)
      StatBar.Panels[2].Text := '';
    end;
  end;  // ak nie je stlacene ziadne tlacitko


  // ak zisti, ze je stlacene lave
  if (ssLeft in Shift) then begin

    // ak sa ma tahat objekt/y, tak ich potiahne
    if ((stavTahania = dsBudeSaTahat) OR (stavTahania = dsTahaSa)) then begin

      _PNL.GetFeaturesAt(poleNajdenychID,X,Y);

      if (stavTahania = dsBudeSaTahat) then begin
        // ihned pri prvom pohybe objektami pri tahani si ich ulozime do undolistu
        _PNL.PrepareUndoStep;
        for i:=0 to _PNL.Features.Count-1 do
          if _PNL.Features[i].Selected then
            _PNL.CreateUndoStep('MOD','FEA',_PNL.Features[i].ID);

        DragStartX := X;
        DragStartY := Y;
        stavTahania := dsTahaSa; // zapocneme tahanie
      end;

      if (stavTahania = dsTahaSa) AND (cfg_SnapToGuides) and (Length(poleNajdenychID) = 1) then begin

        ficura_prva := _PNL.GetFeatureByID( poleNajdenychID[0] );

        // snapovanie ku guidelineom
        closestGuideDistance_X := 999;
        closestGuideDistance_Y := 999;
        closestGuide_X := -1;
        closestGuide_Y := -1;
        _PNL.DeselectAllGuidelines;

        for i := 0 to _PNL.Guides.Count-1 do begin

          guideline := _PNL.Guides[i];

          if (guideline.Typ = 'V') then begin
            dummyFloat := Abs(guideline.Param1 - ficura_prva.X);
            if dummyFloat < snapDistanceMm then begin
              if dummyFloat < closestGuideDistance_X then begin
                closestGuideDistance_X := dummyFloat;
                closestGuide_X := i;
              end;
            end;
          end;

          if (guideline.Typ = 'H') then begin
            dummyFloat := Abs(guideline.Param1 - ficura_prva.Y);
            if dummyFloat < snapDistanceMm then begin
              if dummyFloat < closestGuideDistance_Y then begin
                closestGuideDistance_Y := dummyFloat;
                closestGuide_Y := i;
              end;
            end;
          end;

        end;


        // teraz uz vieme, ktory guide je najblizsie a mozeme ho tam snappnut
        if closestGuide_X > -1 then begin
          snappedToGuideline_X := True;
          guideline := _PNL.Guides[closestGuide_X];
          totalDragDistanceObjects.X := totalDragDistanceObjects.X + (guideline.Param1 - ficura_prva.X);
          ficura_prva.X := guideline.Param1;
          guideline.Selected := True;
          panelNeedsRedraw := True;
        end;

        // ak uz mys isla dalej, treba ho od guideline odtrhnut
        if snappedToGuideline_X then begin
          if Abs(totalDragDistanceObjects.X - totalDragDistanceMouse.X) > snapDistanceMm then begin
            snappedToGuideline_X := False;
            guideline.Selected := false;
          end;
        end;


        if closestGuide_Y > -1 then begin
          snappedToGuideline_Y := True;
          guideline := _PNL.Guides[closestGuide_Y];
          totalDragDistanceObjects.Y := totalDragDistanceObjects.Y + (guideline.Param1 - ficura_prva.Y);
          ficura_prva.Y := guideline.Param1;
          guideline.Selected := True;
          panelNeedsRedraw := True;
        end;

        if snappedToGuideline_Y then begin
          if Abs(totalDragDistanceObjects.Y - totalDragDistanceMouse.Y) > snapDistanceMm then begin
            snappedToGuideline_Y := False;
            guideline.Selected := False;
          end;
        end;

      end;

      totalDragDistanceMouse.X := MM(X, 'x') - dragStartPoint.X;
      totalDragDistanceMouse.Y := MM(Y, 'y') - dragStartPoint.Y;

      {******* TAHANIE V SMERE X *********}
      if (not snappedToGuideline_X) then begin  // lebo ak je prichyteny, nehybeme s nim vobec

        if (fGuides.cbSnapToGrid.Checked) then begin  // ak je aktivovane prichytavanie na grid
          if (Abs(DragStartX - X) > snapGridPX-1) then begin
            while Abs(totalDragDistanceObjects.X - totalDragDistanceMouse.X) > _PNL.Grid do begin
              if totalDragDistanceObjects.X < totalDragDistanceMouse.X then begin
                _PNL.MoveSelected( _PNL.Grid, 0 );
                totalDragDistanceObjects.X := totalDragDistanceObjects.X + _PNL.Grid;
                panelNeedsRedraw := True;
              end else begin
                _PNL.MoveSelected( -_PNL.Grid, 0 );
                totalDragDistanceObjects.X := totalDragDistanceObjects.X - _PNL.Grid;
                panelNeedsRedraw := True;
              end;

              DragStartX := X;
            end;
          end;

        end else begin  // ak nie je aktivne prichytavanie na grid

          if (DragStartX <> X) then begin

            dummyFloat := MM(X - DragStartX);
            _PNL.MoveSelected( dummyFloat , 0 );
            totalDragDistanceObjects.X := totalDragDistanceObjects.X + dummyFloat;
            panelNeedsRedraw := True;

            DragStartX := X;
          end;
        end;
      end;

      {******* TAHANIE V SMERE Y *********}
      if (not snappedToGuideline_Y) then begin  // lebo ak je prichyteny, nehybeme s nim vobec

        if (fGuides.cbSnapToGrid.Checked) then begin  // ak je aktivovane prichytavanie na grid
          if (Abs(DragStartY - Y) > snapGridPX-1) then begin
            while Abs(totalDragDistanceObjects.Y - totalDragDistanceMouse.Y) > _PNL.Grid do begin
              if totalDragDistanceObjects.Y < totalDragDistanceMouse.Y then begin
                _PNL.MoveSelected( 0, _PNL.Grid );
                totalDragDistanceObjects.Y := totalDragDistanceObjects.Y + _PNL.Grid;
                panelNeedsRedraw := True;
              end else begin
                _PNL.MoveSelected( 0, -_PNL.Grid );
                totalDragDistanceObjects.Y := totalDragDistanceObjects.Y - _PNL.Grid;
                panelNeedsRedraw := True;
              end;

              DragStartY := Y;
            end;
          end;

        end else begin  // ak nie je aktivne prichytavanie na grid

          if (DragStartY <> Y) then begin

            dummyFloat := MM(Y - DragStartY);
            _PNL.MoveSelected( 0, -dummyFloat );
            totalDragDistanceObjects.Y := totalDragDistanceObjects.Y - dummyFloat;
            panelNeedsRedraw := True;

            DragStartY := Y;
          end;
        end;
      end;

      // aj pocas tahania objektu aktualizujeme info o nom v statusbare
      // ak tahame len 1 objekt
      if (Length(poleNajdenychID) = 1) then
        StatBar.Panels[1].Text := _PNL.GetFeatureByID( poleNajdenychID[0] ).GetFeatureInfo(false, true);
      // ak ich tahame viac
      if (Length(poleNajdenychID) > 1) then
        StatBar.Panels[1].Text := IntToStr(Length(poleNajdenychID))+' '+TransTxt('objects');

    end; // if ((stavTahania = dsBudeSaTahat) OR (stavTahania = dsTahaSa))

    // ak sa ma kreslit vyberovy obdlznik...
    if (stavTahania = dsTahaSaVyberovyObdlz) then begin
      with Canvas do begin
        CopyRect(
          Rect(DragStartX, DragStartY, DragOldX, DragOldY),
          BackPlane.Canvas,
          Rect(DragStartX, DragStartY, DragOldX, DragOldY)
        );
        Pen.Color := clWhite;
        Pen.Mode := pmXor;
        // ak tahame vyberovy obdlznik dolava, je ciarkovany (vyberie aj pretinajuce objekty)
        if (DragStartX < x) then
          Pen.Style := psSolid
        else
          Pen.Style := psDot;
        Brush.Style := bsClear;
        Rectangle(DragStartX, DragStartY, x,y);
        DragOldX := x;
        DragOldY := y;
      end;
    end;  // if (stavTahania = dsTahaSaVyberovyObdlz)
  end;  // if (ssLeft in Shift)


  // ak je stlacene stredne, robime "panning" - tahanie panela po screene
  if (Shift = [ssMiddle]) then begin
    _PNL.ZoomOffX := _PNL.ZoomOffX + (X - PanStartPoint.X);
    _PNL.ZoomOffY := _PNL.ZoomOffY + (Y - PanStartPoint.Y);
    PanStartPoint.X := X;
    PanStartPoint.Y := Y;
    panelNeedsRedraw := True;
  end;  // ak je stlacene stredne, robime "panning" - tahanie panela po screene

{$IFDEF DEBUG}
  panelNeedsRedraw := True;  // testujeme rychlost prekreslovania - nech sa pri pohybe mysou aktualizuje udaj o FPS
{$ENDIF}

  if panelNeedsRedraw then _PNL.Draw;

end;

procedure TfMain.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ignoreNextMouseUp then begin
    ignoreNextMouseUp := false;
    Exit;
  end;

  Cursor := crDefault;
  if stavTahania = dsTahaSaVyberovyObdlz then begin   // ak sa netahalo, len klikol a pustil (na tom istom - prazdnom mieste), deselectuje vsetko
    if (X = DragStartX) AND (Y = DragStartY) then begin
      _PNL.DeselectAll;
      stavTahania := dsNetahaSa;
    end else begin  // ak sa tahal vyberovy obdlznik, teraz ho zrusime a tie, co su v nom oznacime za vybrate
      if (DragStartX < DragOldX) then
        _PNL.SelectAllInRect( Rect(DragStartX, DragStartY, DragOldX, DragOldY) )
      else
        _PNL.SelectAllInRect( Rect(DragStartX, DragStartY, DragOldX, DragOldY), true ); // vyberie aj ciastocne pretate
//      fMain.Canvas.CopyRect(Rect(DragStartX, DragStartY, DragOldX, DragOldY), BackPlane.Canvas, Rect(DragStartX, DragStartY, DragOldX, DragOldY));
      stavTahania := dsNetahaSa;
    end;
    _PNL.Draw;
  end;

  // ked je na sebe viac objektov a urobim na ne 2-klik tak toto by po MouseUp-e prekreslilo panel a zmizli by mi multiselect buttony
  if (stavTahania = dsTahaSa) AND (not MultiselectTlacitka.DoubleClickWaiting) then begin
    _PNL.DeselectAllGuidelines;
    _PNL.Draw;
  end;

  if stavTahania = dsBudeSaTahat then   // ak sme ani nezacali tahat, nastavime, ze sa netaha
    stavTahania := dsNetahaSa;

  if stavTahania = dsTahaSa then  // ak sa tahalo, nastavime, ze sme dotahali
    stavTahania := dsDotahaloSa;
end;

procedure TfMain.FormDblClick(Sender: TObject);
var
  poleNajdenychID: TPoleIntegerov;
  X,Y: integer;
begin
  ignoreNextMouseDown := True;
  ignoreNextMouseUp := True;

  _PNL.DeselectAll; // ak ich je vyselectovanych viac, zrusime oznacenie, aby bolo jasne, ze upravovat sa naraz da len jeden prvok

  X := ScreenToClient(Mouse.CursorPos).X;
  Y := ScreenToClient(Mouse.CursorPos).Y;

  if _PNL.GetFeaturesAt(poleNajdenychID, X, Y) then begin
    if Length(poleNajdenychID) = 1 then begin
      if ( _PNL.GetFeatureByID(poleNajdenychID[0]).ComboID > -1) then begin
        // ak je dvojkliknuty objekt combo, otvorime okno na upravu comba
        _PNL.SelectCombo( _PNL.GetFeatureByID(poleNajdenychID[0]).ComboID );
        _PNL.Draw;
        fFeaCombo.EditCombo( _PNL.GetFeatureByID(poleNajdenychID[0]).ComboID );
        fFeaCombo.ShowModal;
      end else begin
        // dvojkliknuty objekt vyselectujeme a spustime jeho EDIT rutinu
        if (not _PNL.GetFeatureByID(poleNajdenychID[0]).Locked) then begin
          _PNL.GetFeatureByID(poleNajdenychID[0]).Selected := true;
          _PNL.Draw;
          _PNL.GetFeatureByID( poleNajdenychID[0] ).StartEditing;
        end;
      end;
    end else begin
      Cursor := crDefault;
      MultiselectTlacitka.Clear;
      MultiselectTlacitka.Fill(poleNajdenychID, X, Y);
      MultiselectTlacitka.DoubleClickWaiting := True; // signalizuje, ze uzivatel dvojklikol ale najprv si musi vybrat z viacerych objektov
      _PNL.Draw;
      Exit;
    end;
  end else begin
    // ak 2x-klikol na panel (na ziadny otvor), tak otvori nastavenia panela samotneho
    btnSettings.Click;
  end;
end;

procedure TfMain.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  i: integer;
  zoomFactor: Double;
begin
  MultiselectTlacitka.Clear;

  if ViewReverseWheel.Checked then
    zoomFactor := 0.9
  else
    zoomFactor := 1.1;

  _PNL.SetZoom(zoomFactor, ScreenToClient(mouse.CursorPos).X, ScreenToClient(mouse.CursorPos).Y);
  snapGridPX := PX(_PNL.Grid);
  // pri gravirovanych textoch dochadza pri zmene zoomu k nespravnemu prepocitaniu BoundingBox-u,
  // tak ho prepocitame (neviem to urobit vo vnutri SetZoom(), lebo hlasi vynimku pri zatvarani app)
  for i:=0 to _PNL.Features.Count-1 do
    if (_PNL.Features[i].Typ = ftTxtGrav) then
      _PNL.Features[i].AdjustBoundingBox;
  _PNL.Draw;
end;

procedure TfMain.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  i: integer;
  zoomFactor: Double;
begin
  MultiselectTlacitka.Clear;

  if ViewReverseWheel.Checked then
    zoomFactor := 1.1
  else
    zoomFactor := 0.9;

  _PNL.SetZoom(zoomFactor, ScreenToClient(mouse.CursorPos).X, ScreenToClient(mouse.CursorPos).Y);
  snapGridPX := PX(_PNL.Grid);
  // pri gravirovanych textoch dochadza pri zmene zoomu k nespravnemu prepocitaniu BoundingBox-u,
  // tak ho prepocitame (neviem to urobit vo vnutri SetZoom(), lebo hlasi vynimku pri zatvarani app)
  for i:=0 to _PNL.Features.Count-1 do
    if (_PNL.Features[i].Typ = ftTxtGrav) then
      _PNL.Features[i].AdjustBoundingBox;

  _PNL.Draw;
end;

procedure TfMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: integer;
  mb: Integer;
begin
{$IFNDEF DEBUG}
  if _PNL.HasChanged then begin
    mb := MessageBox(handle, PChar(TransTxt('Panel has changed. Save the panel ?')), PChar(TransTxt('Confirmation')), MB_ICONQUESTION OR MB_YESNOCANCEL);
    if mb = IDCANCEL then begin CanClose := false; exit; end;
    if mb = IDYES then FileSaveClick(sender);
  end;
{$ENDIF}

  MultiselectTlacitka.Clear;

  if Assigned(_PNL.Features) then _PNL.Features.Free; // neviem preco, ale zlikvidovanie Features v metode Destroy samotneho panela nefunguje
  FreeAndNil(_PNL);
  FreeAndNil(BackPlane);

  SaveRecentFiles;
  recentFiles.Free;

	WriteRegistry_bool('Config', 'App_WindowMaximized', (WindowState = wsMaximized) );
  WriteRegistry_integer('Config', 'App_WindowLeft', fMain.Left);
  WriteRegistry_integer('Config', 'App_WindowTop', fMain.Top);
  WriteRegistry_integer('Config', 'App_WindowWidth', fMain.Width);
  WriteRegistry_integer('Config', 'App_WindowHeight', fMain.Height);

  WriteRegistry_bool('Config', 'App_ReverseMouseWheel', fMain.ViewReverseWheel.Checked);
end;

procedure TfMain.ftp1Status(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  Log('Main:FTP:'+AStatusText)
end;

procedure TfMain.ShowMultiSelect(var objekty: TPoleIntegerov; X,Y: integer);
begin
  { zobrazi tlacitka pre vyber jedneho z viacerych nad sebou leziacich objektov }
  MultiselectTlacitka.Clear;
  MultiselectTlacitka.Fill(objekty, X, Y);
end;

procedure TfMain.Hole1Click(Sender: TObject);
begin
  fFeaHole.edX.Text := IntToStr( Round( Mm(popupPoint.X,'x') ));
  fFeaHole.edY.Text := IntToStr( Round( Mm(popupPoint.Y,'y') ));

  btnAddHole.Click;
end;

procedure TfMain.Thread1Click(Sender: TObject);
begin
  fFeaThread.edThreadX.Text := IntToStr( Round( Mm(popupPoint.X,'x') ));
  fFeaThread.edThreadY.Text := IntToStr( Round( Mm(popupPoint.Y,'y') ));

  btnAddThread.Click;
end;

procedure TfMain.Pocket1Click(Sender: TObject);
begin
  fFeaPocket.edX.Text := IntToStr( Round( Mm(popupPoint.X,'x') ));
  fFeaPocket.edY.Text := IntToStr( Round( Mm(popupPoint.Y,'y') ));

  btnAddPocket.Click;
end;

procedure TfMain.Engraving1Click(Sender: TObject);
begin
  fFeaEngraving.edTextX.Text := IntToStr( Round( Mm(popupPoint.X,'x') ));
  fFeaEngraving.edTextY.Text := IntToStr( Round( Mm(popupPoint.Y,'y') ));
  fFeaEngraving.edLine2_x1.Text := fFeaEngraving.edTextX.Text;
  fFeaEngraving.edLine2_y1.Text := fFeaEngraving.edTextY.Text;
  fFeaEngraving.edRect_x.Text := fFeaEngraving.edTextX.Text;
  fFeaEngraving.edRect_y.Text := fFeaEngraving.edTextY.Text;
  fFeaEngraving.edCirc_x.Text := fFeaEngraving.edTextX.Text;
  fFeaEngraving.edCirc_y.Text := fFeaEngraving.edTextY.Text;

	btnAddEngraving.Click;
end;

procedure TfMain.Holewithcountersink1Click(Sender: TObject);
begin
  fFeaConus.edX.Text := IntToStr( Round( Mm(popupPoint.X,'x') ));
  fFeaConus.edY.Text := IntToStr( Round( Mm(popupPoint.Y,'y') ));

  btnAddConus.Click;
end;

procedure TfMain.Groove1Click(Sender: TObject);
begin
  fFeaGroove.edLinX1.Text := IntToStr( Round( Mm(popupPoint.X,'x') ));
  fFeaGroove.edLinY1.Text := IntToStr( Round( Mm(popupPoint.Y,'y') ));
  fFeaGroove.edArcX1.Text := fFeaGroove.edLinX1.Text;
  fFeaGroove.edArcY1.Text := fFeaGroove.edLinY1.Text;

  btnAddGroove.Click;
end;

procedure TfMain.Combofeature1Click(Sender: TObject);
begin
  fFeaCombo.edComboX.Text := IntToStr( Round( Mm(popupPoint.X,'x') ));
  fFeaCombo.edComboY.Text := IntToStr( Round( Mm(popupPoint.Y,'y') ));

  btnAddCombo.Click;
end;

procedure TfMain.NewFile;
begin
  if Assigned(_PNL) then begin
    _PNL.Features.Free;
    _PNL.Free;
  end;
  _PNL := TPanelObject.Create;
  _PNL.Sirka  := 300;
  _PNL.Vyska  := 100;
  _PNL.Radius := 0;
  _PNL.Hrubka := 3;
  _PNL.Povrch := 'surovy';
  _PNL.HasChanged := false;
  SetFormTitle;
end;

procedure TfMain.NewfromDXF1Click(Sender: TObject);
begin
  // open
  OpenDialog.Options := OpenDialog.Options - [ofAllowMultiSelect];
  OpenDialog.Filter := TransTxt('DXF files|*.dxf|All files|*.*');

  if OpenDialog.Execute then begin

    fDxfImport := TfDxfImport.Create(Application);
    fDxfImport.dxfFileName := OpenDialog.FileName;
    if fDxfImport.ShowModal = mrOk then begin

    end;

    fDxfImport.Free;
  end;
end;

procedure TfMain.OpenFile(filename: string);
var
  mb: integer;
begin
  if _PNL.HasChanged then begin
    mb := MessageBox(handle, PChar(TransTxt('Panel has changed. Save the panel ?')), PChar(TransTxt('Confirmation')), MB_ICONQUESTION OR MB_YESNOCANCEL);
    if mb = IDCANCEL then Exit;
    if mb = IDYES then FileSaveClick(nil);
  end;

  FreeAndNil( _PNL );

  _PNL := TPanelObject.Create;
  _PNL.LoadFromFile(filename);
  _PNL.Draw;

  btnSideSwitch.ImageIndex := 11 + _PNL.StranaVisible;
  SetFormTitle;

  WriteRegistry_string('Config','App_PanelsDir', ExtractFileDir(filename));
  OpenDialog.InitialDir := ExtractFileDir(filename);
  AddToRecentFiles(filename);
end;

procedure TfMain.OpenRecentFile(sender: TObject);
var
	index: integer;
begin
  index := recentFiles.IndexOfName( StringsReplace(TMenuItem(sender).Caption + '.panel', ['&'], ['']) ); // musime odstranit automaticky pridany znak & do poloziek menu
  if index > -1 then begin

  	if not FileExists( recentFiles.ValueFromIndex[index] ) then begin
    	MessageBox(handle, PChar(TransTxt('File not found: ')+#13+recentFiles.ValueFromIndex[index]), PChar(TransTxt('Error')), MB_ICONERROR OR MB_OK);
      recentFiles.Delete(index);
      UpdateRecentMenu;
      Exit;
    end;

  	OpenFile( recentFiles.ValueFromIndex[index] );
  end;
end;

procedure TfMain.SaveFile(filename: string);
begin
  _PNL.SaveToFile(filename);
  WriteRegistry_string('Config','App_PanelsDir', ExtractFileDir(filename)); // zapamata si, kde si user uklada panely
  SetFormTitle;

{

  ******************* stary format suborov (do 0.3.10) *************************

  // panel sa musi ukladat pri zapnutej strane "A"
  // (kym nie je poriadne urobene prepocitavanie suradnic)
  if _PNL.StranaVisible = 2 then
    btnSideSwitch.Click;

  try
    // najprv povodny subor zmazeme, aby sa v nom nedrzali stare vymazane objekty
    if FileExists(filename) then RenameFile(filename, filename+'.bak');

    myini := TIniFile.Create(filename);

    // informacie o paneli
    myini.WriteInteger('Panel','FileVer', (swVersion1*10000)+(swVersion2*100)+swVersion3);
    myini.WriteString('Panel','Units','mm');
    myini.WriteFloat('Panel','SizeX',RoundTo(_PNL.Sirka , -4));
    myini.WriteFloat('Panel','SizeY',RoundTo(_PNL.Vyska , -4));
    myini.WriteFloat('Panel','Radius1',RoundTo(_PNL.Radius , -4));
    myini.WriteFloat('Panel','Thickness',RoundTo(_PNL.Hrubka , -4));
    myini.WriteFloat('Panel','GridSize',RoundTo(_PNL.Grid , -4));
    myini.WriteString('Panel','SurfaceFinish',_PNL.Povrch);
    _PNL.CurrentSide := 1;
    myini.WriteInteger('Panel','ZeroPosition',_PNL.CenterPos);
    _PNL.CurrentSide := 2;
    myini.WriteInteger('Panel','ZeroPosition2',_PNL.CenterPos);
    myini.WriteBool('Panel','CustomMaterial',_PNL.MaterialVlastny);
    myini.WriteString('Panel','EdgeStyle',_PNL.HranaStyl);
    myini.WriteFloat('Panel','EdgeSize',_PNL.HranaRozmer);
    myini.WriteBool('Panel','EdgeBottom',_PNL.HranaObrobenaBottom);
    myini.WriteBool('Panel','EdgeRight',_PNL.HranaObrobenaRight);
    myini.WriteBool('Panel','EdgeTop',_PNL.HranaObrobenaTop);
    myini.WriteBool('Panel','EdgeLeft',_PNL.HranaObrobenaLeft);

    // informacie o dierach a inych featuroch
    j := 0;
    for i:=0 to _PNL.Features.Count-1 do begin
      fea := _PNL.Features[i];
      if Assigned(fea) then begin
        Inc(j);
        jass := IntToStr(j);
        myini.WriteInteger('Features','FeaType_'+jass, fea.Typ);
        myini.WriteInteger('Features','ComboID_'+jass, fea.ComboID);
        myini.WriteFloat('Features','PosX_'+jass, RoundTo(fea.X , -4));
        myini.WriteFloat('Features','PosY_'+jass, RoundTo(fea.Y , -4));
        myini.WriteFloat('Features','Size1_'+jass, RoundTo(fea.Rozmer1 , -4));
        myini.WriteFloat('Features','Size2_'+jass, RoundTo(fea.Rozmer2 , -4));
        myini.WriteFloat('Features','Size3_'+jass, RoundTo(fea.Rozmer3 , -4));
        myini.WriteFloat('Features','Size4_'+jass, RoundTo(fea.Rozmer4 , -4));
        myini.WriteFloat('Features','Size5_'+jass, RoundTo(fea.Rozmer5 , -4));
        myini.WriteFloat('Features','Depth_'+jass, RoundTo(fea.Hlbka1 , -4));
        myini.WriteString('Features','Param1_'+jass, fea.Param1);
        myini.WriteString('Features','Param2_'+jass, fea.Param2);
        myini.WriteString('Features','Param3_'+jass, fea.Param3);
        myini.WriteString('Features','Param4_'+jass, fea.Param4);
        myini.WriteInteger('Features','Side_'+jass, fea.Strana);
      end;
    end;
    myini.WriteInteger('Panel','FeaNumber', j);  // celkovy pocet featurov

    // informacie o kombach
    j := 0;
    for i:=0 to _PNL.Combos.Count-1 do begin
      cmb := _PNL.Combos[i];
      if Assigned(cmb) then begin
        Inc(j);
        jass := IntToStr(j);
        myini.WriteInteger('Combos','ComboID_'+jass, cmb.ID);
        if (cmb.PolohaObject = -1) then
          myini.WriteInteger('Combos','PosRef_'+jass, -1 )
        else
          // ak je combo polohovane na nejaky svoj komponent, zapiseme jeho INDEX nie ID (lebo ID sa po OpenFile pomenia)
          myini.WriteInteger('Combos','PosRef_'+jass, _PNL.GetFeatureIndex(cmb.PolohaObject)+1 );
        myini.WriteFloat('Combos','PosX_'+jass, RoundTo(cmb.X , -4));
        myini.WriteFloat('Combos','PosY_'+jass, RoundTo(cmb.Y , -4));
      end;
    end;
    myini.WriteInteger('Panel','ComboNumber', j);  // celkovy pocet featurov

    // ulozi este nastavenie guidelineov
    j := 0; // pocitadlo poctu guideov
    for i:=1 to maxFeaNum do begin
      if Assigned( _PNL.GetGuideLine(i) ) then begin
        Inc(j);
        jass := IntToStr(j);
        guide := _PNL.GetGuideLine(i);
        myini.WriteString ('GuideLines', 'GuideType_'+jass, guide.Typ );
        myini.WriteFloat  ('GuideLines', 'Param1_'+jass, RoundTo(guide.Param1 , -4) );
        myini.WriteFloat  ('GuideLines', 'Param2_'+jass, RoundTo(guide.Param2 , -4) );
        myini.WriteFloat  ('GuideLines', 'Param3_'+jass, RoundTo(guide.Param3 , -4) );
        myini.WriteInteger('GuideLines', 'Side_'+jass, guide.Strana);
      end;
    end;
    myini.WriteInteger    ('Panel','GuideNumber', j);  // celkovy pocet guidelineov

    // zapamata si, kde si user uklada panely
    SaveConfig('Config','App_PanelsDir', ExtractFileDir(FileName));

    // ak vsetko prebehlo OK, mozeme zmazat zalozny subor
    if FileExists(filename+'.bak') then DeleteFile(filename+'.bak');
  finally
    _PNL.FileName  := filename;
    FreeAndNil(myini);
  end;
  fMain.Caption := 'QuickPanel - '+_PNL.FileName;
  _PNL.HasChanged := false;
}
end;

procedure TfMain.SaveRecentFiles;
var
	i: byte;
begin
	try
    for i := 0 to pocetPosledneOtvorenych-1 do
      if (i > recentFiles.Count-1) then
        WriteRegistry_string('Config', 'App_Recent'+inttostr(i+1), '') // ak boli nejake subory zo zoznamu posledne otvorenych vymazane (napr. preto, lebo sa zistilo, ze uz neexistuju) tak do registrov na ich poziciu zapiseme ''. Bolo by idealnejsie uplne tento zaznam v reg. vymazat, ale nechce sa mi na to robit speci funkcia
      else
        WriteRegistry_string('Config', 'App_Recent'+inttostr(i+1), recentFiles.ValueFromIndex[i]);
  finally
    //
  end;
end;

procedure TfMain.FileNewClick(Sender: TObject);
var
  mb: integer;
begin
  // new panel
  if _PNL.HasChanged then begin
    mb := MessageBox(handle, PChar(TransTxt('Panel has changed. Save the panel ?')), PChar(TransTxt('Confirmation')), MB_ICONQUESTION OR MB_YESNOCANCEL);

    case mb of
      IDYES: begin
               FileSaveClick(sender);
               NewFile;
             end;
      IDNO: NewFile;
      IDCANCEL: Exit;
    end;

  end else begin
    NewFile;
  end;

  _PNL.Draw;

  fPanelSett.ShowModal;
end;

procedure TfMain.FileOpenClick(Sender: TObject);
begin
  // open
  OpenDialog.Options := OpenDialog.Options - [ofAllowMultiSelect];
  OpenDialog.Filter := TransTxt('Panel files|*.panel|All files|*.*');

  if OpenDialog.Execute then
    OpenFile(OpenDialog.FileName);
end;

procedure TfMain.FileSaveClick(Sender: TObject);
begin
  // save the panel
  if (_PNL.FileName <> '') then begin
    SaveFile(_PNL.FileName)
  end else
    FileSaveAs.Click;
end;

procedure TfMain.FileSaveAsClick(Sender: TObject);
begin
  // save as
  SaveDialog.InitialDir := fMain.ReadRegistry_string( 'Config', 'App_PanelsDir' );
  if (_PNL.FileName = '') then
    SaveDialog.FileName := 'Panel_1'
  else
    SaveDialog.FileName := ExtractFileName(_PNL.FileName);
  if SaveDialog.Execute then begin
    SaveFile(SaveDialog.FileName);
    AddToRecentFiles(SaveDialog.FileName);
  end;
end;

procedure TfMain.FileSaveComboClick(Sender: TObject);
var
  i, vybranych_objektov, vybranych_combo, newComboID: integer;
begin
  SaveComboDialog.InitialDir := fMain.ReadRegistry_string( 'Config', 'App_CombosDir' );

  if SaveComboDialog.Execute then begin
    _PNL.PrepareUndoStep;
    // zistime, ci su vybrate nejake comba
    vybranych_combo := _PNL.GetSelectedFeaturesNum.i2;
    // ak su vybrate nejake comba, najprv ich vsetky rozbije
    if (vybranych_combo > 0) then begin
      for i:=0 to _PNL.Features.Count-1 do
        if (_PNL.Features[i].Selected) AND (_PNL.Features[i].ComboID > -1)then begin
          _PNL.CreateUndoStep('DEL','COM',_PNL.Features[i].ComboID);
          _PNL.ExplodeCombo( _PNL.Features[i].ComboID );
        end;
    end;
    // po rozbiti combo otvorov zisti pocet vybratych 'single' featurov
    vybranych_objektov := _PNL.GetSelectedFeaturesNum.i1;
    // ak ich je velmi vela, zahlasi chybu
    if vybranych_objektov > maxComboFeaNum then begin
      MessageBox(handle, Pchar(TransTxt('Maximum number of objects per combo:')+' '+IntToStr(maxComboFeaNum)), PChar(TransTxt('Error')), MB_ICONERROR);
      Exit;
    end;
    // z vyselectovanych otvorov znovu urobime combo (zgrupneme ich)
    { toto rozbijanie a znovuvytvaranie combo otvoru je preto, ze user moze vybrat
      zmiesanu skupinu combo aj single otvorov a po ulozeni na disk do "combo" fajlu
      sa to uz bude vsetko tvarit ako jedno combo - preto treba najprv rozbit
      vsetky comba a potom z toho spravit jedno combo }
    newComboID := _PNL.MakeCombo;
    _PNL.CreateUndoStep('CRT','COM',newComboID);
    // a ulozime vsetky otvory do suboru ako combo
    _PNL.GetComboByID(newComboID).SaveToFile( SaveComboDialog.FileName );
    // ulozime adresar, kam ulozil combo
    fMain.WriteRegistry_string('Config', 'App_CombosDir', ExtractFileDir(SaveComboDialog.FileName) );
    _PNL.Draw;
  end; // if SaveComboDialog.Execute
end;

procedure TfMain.FileExportDxfClick(Sender: TObject);
var
  dxf: TDXFDrawing;
  i: integer;
  fea: TFeatureObject;
  x,y,x2,y2,uhol: double;
  line1, line2: TMyPoint2D;
  obj: TObject;
  center: byte;
begin
  if (_PNL.FileName = '') then
    ExportDxfDlg.FileName := 'Panel_1'
  else
    ExportDxfDlg.FileName := StringReplace( ExtractFileName( _PNL.FileName ), '.panel', '', [rfReplaceAll]);
  ExportDxfDlg.FilterIndex := 3;
  if not ExportDxfDlg.Execute then EXIT;

  dxf := TDXFDrawing.Create;
  try
    dxf.CurrLayer := 'Panel';
    dxf.EntityAddLine(MyPoint(_PNL.Radius,0), MyPoint(_PNL.Sirka-_PNL.Radius,0));
    dxf.EntityAddLine(MyPoint(_PNL.Sirka,_PNL.Radius), MyPoint(_PNL.Sirka, _PNL.Vyska-_PNL.Radius));
    dxf.EntityAddLine(MyPoint(_PNL.Sirka-_PNL.Radius, _PNL.Vyska), MyPoint(_PNL.Radius, _PNL.Vyska));
    dxf.EntityAddLine(MyPoint(0, _PNL.Vyska-_PNL.Radius), MyPoint(0,_PNL.Radius));
    if (_PNL.Radius > 0) then begin
      dxf.EntityAddArc(MyPoint(_PNL.Radius,_PNL.Radius), _PNL.Radius, 180, 270);
      dxf.EntityAddArc(MyPoint(_PNL.Sirka-_PNL.Radius,_PNL.Radius), _PNL.Radius, 270, 0);
      dxf.EntityAddArc(MyPoint(_PNL.Sirka-_PNL.Radius,_PNL.Vyska-_PNL.Radius), _PNL.Radius, 0, 90);
      dxf.EntityAddArc(MyPoint(_PNL.Radius,_PNL.Vyska-_PNL.Radius), _PNL.Radius, 90, 180);
    end;

    obj := _PNL;

    for i := 1 to _PNL.Features.Count do begin
      fea := _PNL.GetFeatureByID(i);
      if (Assigned(fea)) then begin

        if (fea.Strana = _PNL.CurrentSide) then center := _PNL.CenterPos
        else center := _PNL.GetCenterPosBack;

        case fea.Typ of
          ftHoleCirc, ftPocketCirc: begin
            if fea.Typ = ftHoleCirc then dxf.CurrLayer := 'ThruHoles';
            if fea.Typ = ftPocketCirc then dxf.CurrLayer := 'Pockets';
            dxf.EntityAddCircle(TranslateToCenterPos(obj, fea.Poloha, center, cpLB), fea.Rozmer1/2);
            end;
          ftHoleRect, ftPocketRect: begin
            if fea.Typ = ftHoleRect then dxf.CurrLayer := 'ThruHoles';
            if fea.Typ = ftPocketRect then dxf.CurrLayer := 'Pockets';
            x := TranslateToCenterPos(obj, fea.Poloha, center, cpLB).X - (fea.Rozmer1/2) + (fea.Rozmer3);
            y := TranslateToCenterPos(obj, fea.Poloha, center, cpLB).Y - (fea.Rozmer2/2);
            x2:= TranslateToCenterPos(obj, fea.Poloha, center, cpLB).X + (fea.Rozmer1/2) - fea.Rozmer3;
            dxf.EntityAddLine(MyPoint(x,y), MyPoint(x2,y)); // spodna
            dxf.EntityAddArc(MyPoint(x,y+fea.Rozmer3), fea.Rozmer3, 180, 270); // roh 1
            dxf.EntityAddArc(MyPoint(x2,y+fea.Rozmer3), fea.Rozmer3, 270, 0); // roh 2
            y := TranslateToCenterPos(obj, fea.Poloha, center, cpLB).Y + (fea.Rozmer2/2);
            dxf.EntityAddLine(MyPoint(x2,y), MyPoint(x,y)); // vrchna
            dxf.EntityAddArc(MyPoint(x2,y-fea.Rozmer3), fea.Rozmer3, 0, 90); // roh 3
            dxf.EntityAddArc(MyPoint(x,y-fea.Rozmer3), fea.Rozmer3, 90, 180); // roh 4
            x := TranslateToCenterPos(obj, fea.Poloha, center, cpLB).X + (fea.Rozmer1/2);
            y := TranslateToCenterPos(obj, fea.Poloha, center, cpLB).Y - (fea.Rozmer2/2) + fea.Rozmer3;
            y2:= TranslateToCenterPos(obj, fea.Poloha, center, cpLB).Y + (fea.Rozmer2/2) - fea.Rozmer3;
            dxf.EntityAddLine(MyPoint(x,y), MyPoint(x,y2)); // prava
            x := TranslateToCenterPos(obj, fea.Poloha, center, cpLB).X - (fea.Rozmer1/2);
            dxf.EntityAddLine(MyPoint(x,y2), MyPoint(x,y)); // lava
            end;
          ftSink, ftSinkCyl: begin
            dxf.CurrLayer := 'ThruHoles';
            dxf.EntityAddCircle(TranslateToCenterPos(obj, fea.Poloha, center, cpLB), fea.Rozmer2/2);
            dxf.EntityAddCircle(TranslateToCenterPos(obj, fea.Poloha, center, cpLB), fea.Rozmer1/2);
          end;
          ftGrooveLin: begin
            if fea.Hlbka1 = 9999 then dxf.CurrLayer := 'ThruHoles'
            else dxf.CurrLayer := 'Pockets';
            line1.first := TranslateToCenterPos(obj, fea.Poloha, center, cpLB);
            line1.second.X := TranslateToCenterPos(obj, fea.Poloha, center, cpLB).X + fea.Rozmer1;
            line1.second.Y := TranslateToCenterPos(obj, fea.Poloha, center, cpLB).Y + fea.Rozmer2;
            line2 := CiaraOffset(line1.first , line1.second , 'P' , fea.Rozmer3/2);
            dxf.EntityAddLine(line2.first , line2.second);
            line2 := CiaraOffset(line1.first , line1.second , 'L' , fea.Rozmer3/2);
            dxf.EntityAddLine(line2.first , line2.second);
            // vycislime si vzdialenost zaciatku/konca odsadenej ciary od zaciatku/konca osovej ciary
            if (fea.Rozmer1 = 0) then begin
              if (fea.Rozmer2 > 0) then uhol := 90
              else uhol := 270;
            end else
              uhol := RadToDeg(ArcTan(fea.Rozmer2 / fea.Rozmer1));
            if (fea.Rozmer1 < 0) then uhol := uhol + 180;
            dxf.EntityAddArc(line1.first , fea.Rozmer3/2 , uhol+90,uhol+270);
            dxf.EntityAddArc(line1.second, fea.Rozmer3/2 , uhol+270,uhol+90);
            end;
          ftGrooveArc: begin
            if fea.Hlbka1 = 9999 then dxf.CurrLayer := 'ThruHoles'
            else dxf.CurrLayer := 'Pockets';
            dxf.EntityAddArc(TranslateToCenterPos(obj, fea.Poloha, center, cpLB), (fea.Rozmer1+fea.Rozmer4)/2 , fea.Rozmer2 , fea.Rozmer3);
            dxf.EntityAddArc(TranslateToCenterPos(obj, fea.Poloha, center, cpLB), (fea.Rozmer1-fea.Rozmer4)/2 , fea.Rozmer2 , fea.Rozmer3);
            x := cos( DegToRad(fea.Rozmer2)) * (fea.Rozmer1/2);
            y := sin( DegToRad(fea.Rozmer2)) * (fea.Rozmer1/2);
            dxf.EntityAddArc(myPoint(TranslateToCenterPos(obj, fea.Poloha, center, cpLB).X+x,TranslateToCenterPos(obj, fea.Poloha, center, cpLB).Y+y), fea.Rozmer4/2 , fea.Rozmer2+180 , fea.Rozmer2);
            x := cos( DegToRad(fea.Rozmer3)) * (fea.Rozmer1/2);
            y := sin( DegToRad(fea.Rozmer3)) * (fea.Rozmer1/2);
            dxf.EntityAddArc(myPoint(TranslateToCenterPos(obj, fea.Poloha, center, cpLB).X+x,TranslateToCenterPos(obj, fea.Poloha, center, cpLB).Y+y), fea.Rozmer4/2 , fea.Rozmer3 , fea.Rozmer3+180);
            end;
          ftThread: begin
            dxf.CurrLayer := 'Threads';
            dxf.EntityAddCircle(TranslateToCenterPos(obj, fea.Poloha, center, cpLB), (fea.Rozmer1*0.83)/2);
            dxf.EntityAddArc(TranslateToCenterPos(obj, fea.Poloha, center, cpLB), fea.Rozmer1/2, 80, 10);
            end;
          ftLine2Grav: begin
            dxf.CurrLayer := 'Engraving';
            dxf.EntityAddLine(TranslateToCenterPos(obj, fea.Poloha, center, cpLB), MyPoint(TranslateToCenterPos(obj, fea.Poloha, center, cpLB).X + fea.Rozmer1 , TranslateToCenterPos(obj, fea.Poloha, center, cpLB).Y + fea.Rozmer2));
            end;
          ftCircleGrav: begin
            dxf.CurrLayer := 'Engraving';
            dxf.EntityAddCircle(TranslateToCenterPos(obj, fea.Poloha, center, cpLB), fea.Rozmer1/2);
            end;
          ftRectGrav: begin
            dxf.CurrLayer := 'Engraving';
            x := TranslateToCenterPos(obj, fea.Poloha, center, cpLB).X - (fea.Rozmer1/2);
            y := TranslateToCenterPos(obj, fea.Poloha, center, cpLB).Y - (fea.Rozmer2/2);
            x2:= TranslateToCenterPos(obj, fea.Poloha, center, cpLB).X + (fea.Rozmer1/2);
            y2:= TranslateToCenterPos(obj, fea.Poloha, center, cpLB).Y + (fea.Rozmer2/2);
            dxf.EntityAddLine(MyPoint(x,y),   MyPoint(x2,y)); // spodna
            dxf.EntityAddLine(MyPoint(x2,y),  MyPoint(x2,y2)); // prava
            dxf.EntityAddLine(MyPoint(x2,y2), MyPoint(x,y2)); // vrchna
            dxf.EntityAddLine(MyPoint(x,y2),  MyPoint(x,y)); // lava
            end;
          ftTxtGrav: begin
            dxf.CurrLayer := 'Engraving';
            dxf.EntityAddText(TranslateToCenterPos(obj, fea.Poloha, center, cpLB), fea.Param1, fea.Rozmer1, fea.Param3);
            end;
        end;
      end;
    end;
    dxf.SaveToFile(ExportDxfDlg.FileName);
  finally
    FreeAndNil(dxf);
  end;
end;

procedure TfMain.FileExportImageClick(Sender: TObject);
var
  bmp : TBitmap;
  jpg: TJPEGImage;
  myrect_src, myrect_dest: TRect;
  x,y,toolbar: integer;
begin
  if (_PNL.FileName = '') then
    ExportPictureDlg.FileName := 'Panel_1'
  else
    ExportPictureDlg.FileName := StringReplace( ExtractFileName( _PNL.FileName ), '.panel', '', [rfReplaceAll]);
  ExportPictureDlg.FilterIndex := 1;
  if ExportPictureDlg.Execute then begin
    x := fMain.ClientWidth;
    y := fMain.ClientHeight;
    toolbar := 47; // vyska toolbaru v px
    myrect_src  := Rect(0,toolbar,x,y+toolbar);
    myrect_dest := Rect(0,0,x,y);

    bmp := TBitmap.Create;
    bmp.Width := x;
    bmp.Height := y-toolbar;
    bmp.Canvas.CopyRect(myrect_dest, BackPlane.Canvas, myrect_src);

    jpg := TJPEGImage.Create;
    jpg.CompressionQuality := 90;
    jpg.Assign(bmp);

    if ExtractFileExt( ExportPictureDlg.FileName ) = '.bmp' then
      bmp.SaveToFile(ExportPictureDlg.FileName);
    if ExtractFileExt( ExportPictureDlg.FileName ) = '.jpg' then
      jpg.SaveToFile(ExportPictureDlg.FileName);

    bmp.Free;
    jpg.Free;
  end;
end;

procedure TfMain.FileOrderClick(Sender: TObject);
var
  mb: integer;
begin
  if _PNL.HasChanged then begin
    mb := MessageBox(handle, PChar(TransTxt('Panel has changed. Save the panel ?')), PChar(TransTxt('Confirmation')), MB_ICONQUESTION OR MB_YESNOCANCEL);
    if mb = IDCANCEL then Exit;
    if mb = IDYES then FileSaveClick(sender);
  end;

  RemindRegister(Handle);
  fOrder.ShowModal;
end;

procedure TfMain.FilePrintClick(Sender: TObject);
begin
  if not PrintDialog.Execute then EXIT;
  uPrinting.PrintPanel;
end;

procedure TfMain.FileExitClick(Sender: TObject);
begin
  // exit
  fMain.Close;
end;

procedure TfMain.File1Click(Sender: TObject);
var
  sel: boolean;
begin
  // nepovoli funkcie, kde musi byt vybraty nejaky objekt
  sel := ((_PNL.GetSelectedFeaturesNum.i1 > 0) OR (_PNL.GetSelectedFeaturesNum.i2 > 0));
  FileSaveCombo.Enabled := sel;
end;

procedure TfMain.Edit1Click(Sender: TObject);
var
  sel: boolean;
  numSelected: TMyInt2x;
begin
  numSelected := _PNL.GetSelectedFeaturesNum;

  // povoli funkcie, kde musi byt vybraty nejaky objekt
  sel := ((numSelected.i1 > 0) OR (numSelected.i2 > 0));
  EditDelete.Enabled := sel;
  EditClone.Enabled  := sel;
  EditMirror.Enabled := sel;
  EditLock.Enabled   := sel;

  // povoli funkcie, kde musia byt vybrate viacere objekty
  sel := ((numSelected.i1 + numSelected.i2) > 1);
  EditMakeCombo.Enabled    := sel;

  // povoli funkcie, kde musi byt vybrate aspon 1 combo
  sel := (numSelected.i2 > 0);
  EditExplodeCombo.Enabled := sel;

  // este povolovanie undo
  sel := (_PNL.GetNumberOfUndoSteps > 0);
  EditUndo.Enabled := sel;
end;



procedure TfMain.EditUndoClick(Sender: TObject);
begin
  _PNL.Undo;
end;

procedure TfMain.EditUnlockallClick(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to _PNL.Features.Count-1 do
    if Assigned(_PNL.Features[i]) then
      _PNL.Features[i].Locked := false;
end;

procedure TfMain.EditDeleteClick(Sender: TObject);
begin
  // delete object
  _PNL.DelSelected;
  _PNL.Draw;
  if Cursor = crSizeAll then Cursor := crDefault;
end;

procedure TfMain.EditCloneClick(Sender: TObject);
begin
  // clone tool
  fToolClone.Show;
end;

procedure TfMain.EditMakeComboClick(Sender: TObject);
var
  i, newComboID: integer;
begin
  _PNL.PrepareUndoStep;

  // ak su vybrate aj nejake comba, najprv ich zlikviduje
  for i:=0 to _PNL.Features.Count-1 do
    if (_PNL.Features[i].Selected) AND (_PNL.Features[i].ComboID > -1)then begin
      _PNL.CreateUndoStep('DEL','COM',_PNL.Features[i].ComboID);
      _PNL.ExplodeCombo( _PNL.Features[i].ComboID );
    end;

  // vytvori combo z objektov
  _PNL.CreateUndoStep('CRT','COM',newComboID);
  _PNL.MakeCombo;
  _PNL.Draw;
end;

procedure TfMain.EditMirrorClick(Sender: TObject);
begin
  fToolMirror.Show;
end;

procedure TfMain.EditExplodeComboClick(Sender: TObject);
var
  i: integer;
begin
  // najprv si to vsetko poznacime do undolistu
  _PNL.PrepareUndoStep;
  // ulozime si vsetky feature, ktore su sucastou cÙmb
  for i:=0 to _PNL.Features.Count-1 do
    if (_PNL.Features[i].Selected) AND (_PNL.Features[i].ComboID > -1) then begin
      _PNL.CreateUndoStep('MOD','FEA',_PNL.Features[i].ID);
    end;
  // ulozime si kazde vybrate combo, ktore ideme zlikvidovat
//  last_combo_id := -1;
//  for i:=0 to _PNL.Features.Count-1 do
//    if  (_PNL.Features[i].Selected)
//    AND (_PNL.Features[i].ComboID > -1)
//    AND (last_combo_id <> _PNL.Features[i].ComboID) then begin
//      _PNL.CreateUndoStep('DEL','COM',_PNL.Features[i].ComboID);
//      last_combo_id := _PNL.Features[i].ComboID;
//    end;

  // rozbije combo na objekty (explode)
  for i:=0 to _PNL.Features.Count-1 do
    if (_PNL.Features[i].Selected) AND (_PNL.Features[i].ComboID > -1) then begin
      _PNL.CreateUndoStep('DEL','COM', _PNL.Features[i].ComboID);
      _PNL.ExplodeCombo(_PNL.Features[i].ComboID);
    end;
  _PNL.Draw;
end;



procedure TfMain.EditLockClick(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to _PNL.Features.Count-1 do
    if Assigned(_PNL.Features[i]) then
      if _PNL.Features[i].Selected then
        _PNL.Features[i].Locked := true;
  _PNL.Draw;
end;

procedure TfMain.ToolsRegisterFileTypesClick(Sender: TObject);
begin
  if RegisterFileTypes then
    MessageBox(handle, PChar(TransTxt('Panel file type (*.panel) was succesfully associated with the application.')+#13+TransTxt('Now you can open these files by double-clicking them.')), PChar(TransTxt('Information')), MB_ICONINFORMATION)
  else
    MessageBox(handle, PChar(TransTxt('Panel file type (*.panel) could not be associated with the application.')+#13+TransTxt('You may need administrator rights.')), PChar(TransTxt('Error')), MB_ICONERROR);
end;



procedure TfMain.UpdateRecentMenu;
var
	i: byte;
  tmpMenuItem: TMenuItem;
begin
	// zosynchronizujeme obsah main menu zo stringlistom
  FileOpenRecent.Clear;

  if recentFiles.Count > 0 then
    for i := 0 to recentFiles.Count-1 do begin
  //    if recentFiles[i] <> '' then begin
        tmpMenuItem := TMenuItem.Create(FileOpenRecent);
        tmpMenuItem.Caption := StringsReplace( recentFiles.Names[i], ['.panel'], ['']);
        tmpMenuItem.OnClick := OpenRecentFile;
        FileOpenRecent.Add( tmpMenuItem );
  //    end;
    end;

  FileOpenRecent.Enabled := FileOpenRecent.Count > 0;
end;

procedure TfMain.CleanUpRegistry;
var
  myReg: TRegistry;
begin
  // tu sa bude davat upratovanie registrov - vymazanie klucov, ktore sa pouzivali v starsich verziach a teraz uz potrebne nie su
  myReg := TRegistry.Create;
  try
    myReg.RootKey := HKEY_CURRENT_USER;
    myReg.OpenKey('Software\QuickPanel\Config\', true);
    if (myReg.ValueExists('EngravingColorAlert')) then myReg.DeleteValue('EngravingColorAlert');  // 1.1.2
    if (myReg.ValueExists('App_HighlightMultiselect')) then myReg.DeleteValue('App_HighlightMultiselect'); // 1.1.2
  finally
    myReg.Free;
  end;
end;

procedure TfMain.HelpWhatsNewClick(Sender: TObject);
begin
  ShellExecute(0, 'open', 'http://www.quickpanel.sk/index.php?p=changelog' ,nil,nil, SW_SHOWNORMAL);
end;

procedure TfMain.HelpCancelRegistrationClick(Sender: TObject);
var
	dotaz: TUrlDotaz;
begin
  if (fRegisteredCode.edCode.Text = '') OR (Length(fRegisteredCode.edCode.Text) <> 32) then
    MessageBox(handle, PChar(TransTxt('Registration code is incorrect or missing.')), PChar(TransTxt('Error')), MB_ICONERROR)
  else
    if MessageBox(handle, PChar(
      TransTxt('Are you sure you want to cancel your registration?')+#13+#13+
      TransTxt('Registration will be definitely cancelled after you confirm e-mail we will send to you.')+#13+
      TransTxt('Your e-mail address will be then freed for new registration.')
    ), PChar(TransTxt('Warning')), MB_YESNO OR MB_DEFBUTTON2 OR MB_ICONWARNING) = IDYES then begin
    	dotaz.Create('registeruser_delete.php');
      dotaz.params.Add('kod='+fRegisteredCode.edCode.Text);
      RunPhpScript(dotaz, handle, true);
      dotaz.Free;
      if UrlAnswer = 'OK' then
        MessageBox(handle, PChar(TransTxt('Check your e-mail and confirm erasing of your registration please.')), PChar(TransTxt('Information')), MB_ICONINFORMATION)
      else
        MessageBox(handle, PChar(TransTxt('There was an error. Try again later or contact our office please.')+#13+'('+UrlAnswer+')'), PChar(TransTxt('Error')), MB_ICONERROR);
    end;
end;

procedure TfMain.HelpCheckUpdatesClick(Sender: TObject);
begin
  CheckUpdates(false, true);
end;

procedure TfMain.HelpOnlineClick(Sender: TObject);
begin
	BrowseWiki('');
end;

procedure TfMain.HelpOnlineForumClick(Sender: TObject);
begin
  BrowseUrl('http://forum.audioweb.cz/viewtopic.php?id=9953');
end;

procedure TfMain.HelpWebpageClick(Sender: TObject);
begin
  BrowseUrl('');
end;

procedure TfMain.HelpRegisterUserClick(Sender: TObject);
begin
  fRegisterUser.ShowModal;
end;

procedure TfMain.HelpSendReportClick(Sender: TObject);
var
  zip: TZipFile;
  dir, email: string;
  vysledok: integer;
const
  fajl = 'memolog.txt';
  zipfajl = 'quickpanel_report.zip';
begin
  dir := ReadRegistry_string('Config','App_PanelsDir') + '\';

  Log( 'User ID : ' + userID );
  Log( 'Register code : ' + fRegisteredCode.edCode.Text );
  Log( 'Panels save dir : '+dir);
  Log( '-------------------------------------------' );
  fDebug.memo.Lines.SaveToFile( dir + fajl);

  try
    zip := TZipFile.Create;
    zip.Open(dir+zipfajl, zmWrite);
    zip.Add(dir+fajl, fajl);
    zip.Close;
  finally
    zip.Free;
    DeleteFile(dir+fajl);
  end;

  if MessageBox(handle, PChar(TransTxt('Bug report has been saved here:')+#13+dir+zipfajl+#13+#13+TransTxt('Send the report now?')), PChar(TransTxt('Information')), MB_ICONINFORMATION OR MB_YESNO) = mrYes then begin
    email := 'mailto:info@quickpanel.sk'
      + '?subject=Error Report'
      + '&body=%0D%0A%0D%0A('+TransTxt('don''t forget to attach report file')+' '+dir+zipfajl+')%0D%0A%0D%0A';
    vysledok := ShellExecute(Handle, 'open', PChar(email), nil, nil, SW_SHOWNORMAL);
    if vysledok <= 32 then
      MessageBox(handle, PChar(TransTxt('Bug report has been saved here:')), PChar(TransTxt('Error')), MB_ICONERROR);
  end;
end;

procedure TfMain.HelpRegisterCodeClick(Sender: TObject);
begin
  fRegisteredCode.ShowModal;
end;

procedure TfMain.HelpAboutClick(Sender: TObject);
begin
  // about
  fSplash.Label3.Caption := 'version:';
  fSplash.lbVer.Caption := inttostr(cfg_swVersion1)+'.'+inttostr(cfg_swVersion2)+'.'+inttostr(cfg_swVersion3);
  fSplash.ShowModal;
end;





procedure TfMain.btnSadOtherClick(Sender: TObject);
begin
  fMain.ShowWish('Other request / demand');
end;

procedure TfMain.btnSettingsClick(Sender: TObject);
var
  i: Integer;
begin
  fPanelSett.ShowModal;
end;

procedure TfMain.btnSideSwitchClick(Sender: TObject);
var
  i: integer;
  obj: TObject;
begin

  // vsetky prvky panela preklopime v horizontalnom smere
  obj := _PNL;
  for i:=0 to _PNL.Features.Count-1 do
    if Assigned(_PNL.Features[i]) then
      _PNL.Features[i].MirrorFeature(obj);

  if (_PNL.StranaVisible = 1) then
    _PNL.StranaVisible := 2
  else
    _PNL.StranaVisible := 1;

  _PNL.CurrentSide := _PNL.StranaVisible;

  _PNL.DeselectAll;
  _PNL.Draw;

  btnSideSwitch.ImageIndex := 11 + _PNL.StranaVisible;
end;

procedure TfMain.btnZoomAllClick(Sender: TObject);
var
  i: integer;
begin
  _PNL.SetZoom(0, -1, -1);
  // pri gravirovanych textoch dochadza pri zmene zoomu k nespravnemu prepocitaniu BoundingBox-u,
  // tak ho prepocitame (neviem to urobit vo vnutri SetZoom(), lebo hlasi vynimku pri zatvarani app)
  for i:=0 to _PNL.Features.Count-1 do
    if (_PNL.Features[i].Typ = ftTxtGrav) then
      _PNL.Features[i].AdjustBoundingBox;
  _PNL.Draw
end;

procedure TfMain.btnGuidesClick(Sender: TObject);
begin
  fGuides.ShowModal;
end;

procedure TfMain.btnAddHoleClick(Sender: TObject);
begin
  fFeaHole.is_editing := false;
  fFeaHole.tabHoleCirc.TabVisible := true;
  fFeaHole.tabHoleRect.TabVisible := true;
  fFeaHole.ShowModal;
end;

procedure TfMain.btnAddPocketClick(Sender: TObject);
begin
  fFeaPocket.is_editing := false;
  fFeaPocket.tabPocketCirc.TabVisible := true;
  fFeaPocket.tabPocketRect.TabVisible := true;
  fFeaPocket.ShowModal;
end;

procedure TfMain.btnAddThreadClick(Sender: TObject);
begin
  fFeaThread.is_editing := false;
  fFeaThread.ShowModal;
end;

procedure TfMain.btnAddEngravingClick(Sender: TObject);
begin
  if (_PNL.StranaVisible <> 1) then begin
    MessageBox(handle, PChar(TransTxt('Side "A" only feature')), PChar(TransTxt('Error')), MB_ICONWARNING);
    Exit;
  end;

  fFeaEngraving.is_editing := false;
  fFeaEngraving.tabText.TabVisible := true;
  fFeaEngraving.tabShapes.TabVisible := true;
  fFeaEngraving.tabImport.TabVisible := true;
  fFeaEngraving.ShowModal;
end;

procedure TfMain.btnAddConusClick(Sender: TObject);
begin
  fFeaConus.is_editing := false;
  fFeaConus.tabConus.TabVisible := true;
//  fFeaConus.tabConusSpecial.TabVisible := true;
  fFeaConus.tabCylinder.TabVisible := true;
  fFeaConus.ShowModal;
end;

procedure TfMain.btnAddGrooveClick(Sender: TObject);
begin
  fFeaGroove.is_editing := false;
  fFeaGroove.tabLinear.TabVisible := true;
  fFeaGroove.tabArc.TabVisible := true;
  fFeaGroove.ShowModal;
end;

procedure TfMain.btnAddCosmeticClick(Sender: TObject);
begin
  fFeaCosmetic.is_editing := false;
  fFeaCosmetic.tabCirc.TabVisible := true;
  fFeaCosmetic.tabRect.TabVisible := true;
  fFeaCosmetic.ShowModal;
end;


procedure TfMain.AddToRecentFiles(filename: string);
var
	i: byte;
begin
	if recentFiles.IndexOfName( ExtractFileName(filename) ) > -1 then begin
  	// ak sa dany subor uz nachadza v zozname poslednych, nepridavame ho, len ho premiestnime na 1. poziciu
    recentFiles.Move(recentFiles.IndexOfName(ExtractFileName(filename)), 0);
  end else begin
  	// ak sa este v zozname poslednych nenachadza, vsetky posunieme a jeho pridame na vrch (ten z posledneho miesta vypadne)
    // ale len vtedy, ked ma uz zoznam recent fajlov maximalnu moznu dlzku (pocetPosledneOtvorenych)
    if (recentFiles.Count = pocetPosledneOtvorenych) then begin
      for i := recentFiles.Count-1 downto 1 do begin
        recentFiles[i] := recentFiles[i-1];
      end;
      recentFiles[0] := ExtractFileName(filename) + '=' + filename;
    end else begin
      recentFiles.Insert(0, ExtractFileName(filename) + '=' + filename);
      if recentFiles.Count > pocetPosledneOtvorenych then
        recentFiles.Delete( pocetPosledneOtvorenych );
    end;
  end;

  // este zaktualizujeme zoznam v MainMenu
  UpdateRecentMenu;
end;

function  TfMain.RunPhpScript(url: TUrlDotaz; oknoHandle: THandle; silent: boolean = false): boolean;
var
  s: string;
begin
  result := false;
  try
    if Pos('remotelog.php', url.adresa) = 0 then // logovat sa bude, len ak sa nevola remotelog.php, inak by vznikla deadloop
      Log('Q: '+url.GetEncodedUrl, false);
    s := cfg_clientappAddr + url.GetEncodedUrl;
    UrlAnswer := http1.Get(cfg_clientappAddr + url.GetEncodedUrl);
    if Pos('remotelog.php', url.adresa) = 0 then // logovat sa bude, len ak sa nevola remotelog.php, inak by vznikla deadloop
      Log('A: '+UrlAnswer, false);
    http1.Disconnect;
    result := true;
  except
    on e:Exception do begin
      if not silent then
        MessageBox(oknoHandle, PChar(TransTxt('Can not connect to the server.')+#13+#13+e.Message), PChar(TransTxt('Error')), MB_ICONERROR);
      if Pos('remotelog.php', url.adresa) = 0 then // len ak sa nevola remotelog.php, tak sa bude logovat, inak by vznikla deadloop
        Log('Can not connect to the server.'+#13+#13+e.Message, false);
    end;
  end;
end;

function TfMain.RunPhpScript(url: string; oknoHandle: THandle; silent: boolean): boolean;
var
	dotaz: TUrlDotaz;
begin
	dotaz := TUrlDotaz.Create(url);
  result := RunPhpScript(dotaz, oknoHandle, silent);
  dotaz.Free;
end;


procedure TfMain.BrowseUrl(url: string);
begin
	// ak zistime, ze adresa neobsahuje http:// tak to tam este  pridame
	if Pos('http://', url) = 0 then
  	url := cfg_baseAddr + url;

	Log('Opening: '+url);
  ShellExecute(0, 'open', PChar(url),nil,nil, SW_SHOWNORMAL)
end;

procedure TfMain.BrowseWiki(topic: string);
begin
	Log('Opening: '+cfg_baseAddr+'wiki/'+topic);
  ShellExecute(0, 'open', PWideChar(cfg_baseAddr+'wiki/'+topic) ,nil,nil, SW_SHOWNORMAL);
end;

function TfMain.EncodeURL(url: string): string;
const
  noEncoding = ['0'..'9','A'..'Z','a'..'z','*','@','.','_','-','|','&','?','='];
var
  pchUrl: pchar;
  urlCodes: array[0..400] of integer;
  i: integer;
begin
	// nepouziva sa - zmazat kludne

  for i := 0 to 400 do urlCodes[i] := 0;

  urlCodes[318] := $BE; //  æ
  urlCodes[353] := $9A; //  ö
  urlCodes[269] := $E8; //  Ë
  urlCodes[357] := $9D; //  ù
  urlCodes[382] := $9E; //  û
  urlCodes[253] := $FD; //  ˝
  urlCodes[225] := $E1; //  ·
  urlCodes[237] := $ED; //  Ì
  urlCodes[233] := $E9; //  È
  urlCodes[271] := $EF; //  Ô
  urlCodes[250] := $FA; //  ˙
  urlCodes[228] := $E4; //  ‰
  urlCodes[314] := $E5; //  Â
  urlCodes[328] := $F2; //  Ú
  urlCodes[243] := $F3; //  Û
  urlCodes[341] := $E0; //  ‡
  urlCodes[345] := $F8; //  ¯
  urlCodes[283] := $EC; //  Ï
  urlCodes[367] := $F9; //  ˘
  urlCodes[244] := $F4; //  Ù

  urlCodes[317] := $BC; //  º
  urlCodes[352] := $8A; //  ä
  urlCodes[268] := $C8; //  »
  urlCodes[356] := $8D; //  ç
  urlCodes[381] := $8E; //  é
  urlCodes[221] := $DD; //  ›
  urlCodes[193] := $C1; //  ¡
  urlCodes[205] := $CD; //  Õ
  urlCodes[201] := $C9; //  …
  urlCodes[270] := $CF; //  œ
  urlCodes[218] := $DA; //  ⁄
  urlCodes[196] := $C4; //  ƒ
  urlCodes[313] := $C5; //  ≈
  urlCodes[327] := $D2; //  “
  urlCodes[211] := $D3; //  ”
  urlCodes[340] := $C0; //  ¿
  urlCodes[344] := $D8; //  ÿ
  urlCodes[282] := $CC; //  Ã
  urlCodes[366] := $D9; //  Ÿ
  urlCodes[212] := $D4; //  ‘

  result := '';
  pchUrl := PChar(url);
  while pchUrl^ <> #0 do begin

    if CharInSet(pchUrl^, noEncoding) then
      result := result + pchUrl^
    else begin
      if urlCodes[Ord(pchUrl^)] > 0 then
        result := result + '%' + IntToHex( urlCodes[Ord(pchUrl^)], 2 )
      else
        result := result + '%' + IntToHex( Ord(pchUrl^), 2 );
    end;

    Inc(pchUrl);
  end; //while

end;

procedure TfMain.btnAddComboClick(Sender: TObject);
begin
  with fFeaCombo do begin
    is_editing := false;
    btnBrowse.Enabled := true;
    rbFile.Enabled    := true;
    //rbLocalLibrary.Enabled := true;
    //rbInternetLibrary.Enabled := true;
    ShowModal;
  end;
end;

procedure TfMain.btnAddScaleClick(Sender: TObject);
begin
  if (_PNL.StranaVisible <> 1) then begin
    MessageBox(handle, PChar(TransTxt('Side "A" only feature')), PChar(TransTxt('Error')), MB_ICONWARNING);
    Exit;
  end;

  fFeaScale.ShowModal;
end;

function TfMain.RegisterFileTypes: boolean;
var
  myReg: TRegistry;
begin
  result := false;
  // asociujeme pripony suborov s aplikaciou (aj ked toto sa robi uz pri instalacii aplikacie - robi to installer)
  myReg := TRegistry.Create;
  try
  	myReg.RootKey := HKEY_CLASSES_ROOT;

    if myReg.OpenKey('.panel', true) then begin
      myReg.WriteString('', 'QuickPanel.Panel');
      myReg.CloseKey;
      myReg.OpenKey('QuickPanel.Panel\DefaultIcon', true);
      myReg.WriteString('', '"'+Application.ExeName+'"');
      myReg.CloseKey;
      myReg.OpenKey('QuickPanel.Panel\shell\open\command', true);
      myReg.WriteString('', '"'+Application.ExeName+'" "%1"');
      result := true;
    end;
  finally
  	myReg.Free;
  end;
end;

function TfMain.InstallFonts: boolean;
//var fontfile: PChar;
begin
{
  fontfile := PChar( ExtractFilePath( Application.ExeName ) + 'simplex.ttf' );
  if (AddFontResource(fontfile) > 0) then begin
    PostMessage(HWND_BROADCAST, WM_FONTCHANGE, 0, 0);
    result := true;
  end;
}
end;




procedure TfMain.Debug1Click(Sender: TObject);
begin
  {$IFDEF DEBUG}
  fDebug.Show;
  {$ENDIF}
end;

procedure TfMain.DPI_correction(obj: TObject);
var
  DPI_factor: double;
begin
  if Screen.PixelsPerInch = 96 then exit; // 96 = default = netreba nic prepocitavat

  DPI_factor := Screen.PixelsPerInch / 96;
	TImage(obj).Width  := Round( DPI_factor * TImage(obj).Width);
	TImage(obj).Height := Round( DPI_factor * TImage(obj).Height);
end;

procedure TfMain.DrawTabs(Control: TCustomTabControl; TabIndex: Integer;
  const Rect: TRect; Active: Boolean);
var
  y    : Integer;
  x    : Integer;
begin
  if Active then begin
    //Fill the tab rect
    Control.Canvas.Brush.Color := clBtnFace;
    Control.Canvas.FillRect(Rect);
  end else begin
    //Fill the tab rect
    Control.Canvas.Brush.Color := clBtnFace;
    Control.Canvas.FillRect(Rect);
  end;

  y  := Rect.Top + ((Rect.Bottom - Rect.Top - Control.Canvas.TextHeight(TTabControl(Control).Tabs[TabIndex])) div 2) + 1;
  x  := Rect.Left + ((Rect.Right - Rect.Left - Control.Canvas.TextWidth (TTabControl(Control).Tabs[TabIndex])) div 2) + 1;
  //draw the tab title
  Control.Canvas.TextOut(x,y,TTabControl(Control).Tabs[TabIndex]);
end;

procedure TfMain.CheckUpdates(silent: boolean = true; forced: boolean = false);
var
  myReg: TRegistry;
  lastCheckDate: TDateTime;
  dateDiff: integer;
  configPath, configFileOrig, configFileBak: string;
  versionAvailable: string;
begin
  myReg := TRegistry.Create;
  myReg.RootKey := HKEY_CURRENT_USER;
  dateDiff := 30; // defaultne nastavime 30 dni (30 dni som sa uz neaktualizoval)
  if myReg.KeyExists('Software\QuickPanel\Config') then begin
    myReg.OpenKey('Software\QuickPanel\Config', false);
    if myReg.ValueExists('App_LastUpdateCheck') then begin
      lastCheckDate := myReg.ReadDate('App_LastUpdateCheck');
      dateDiff := Round( now() - lastCheckDate );
      Log('Last update-check: '+DateTimeToStr(lastCheckDate)+' ('+IntToStr(dateDiff)+' days)');
    end else begin
      dateDiff := 999;
      Log('Last update-check: NO RECORD IN REGISTRY');
    end;
  end;

  // na webe skontroluje aka je najnovsia verzia a v pripade potreby upozorni na to.

{$IFDEF DEBUG}
	forced := true;
{$ENDIF}

  if ((dateDiff >= StrToInt(uConfig.Config_ReadValue('config_age_max'))) OR (forced)) then begin // aktualizacie kontrolujeme maximalne raz za X dni
    // este pred kontrolou aktualizacie stiahneme aktualny konfiguracny subor
    fSplash.Label3.Caption := '';
    fSplash.lbVer.Caption := 'Downloading latest config...';
    Application.ProcessMessages;
    Log('Downloading latest config...');
    Application.ProcessMessages;
    configPath := ExtractFilePath( Application.ExeName );
    configFileOrig := configPath + konfiguracnySubor;
    configFileBak  := configPath + konfiguracnySubor + '.bak';
    try
      if (FileExists(configFileOrig)) then RenameFile(configFileOrig, configFileBak);
      try
        ftp1.Host := ftpHost;
        ftp1.Username := ftpUser;
        ftp1.Password := ftpPwd;
        ftp1.Connect;
        ftp1.Get(konfiguracnySubor, configFileOrig);
      except
        Log('FTP.Get() not successful. Reverting to config backup.');
        if (FileExists(configFileOrig) AND FileExists(configFileBak)) then begin
          DeleteFile(configFileOrig);
          RenameFile(configFileBak, configFileOrig);
        end;
      end;
    finally
      ftp1.Disconnect;
      if (FileExists(configFileBak)) then DeleteFile(configFileBak);
    end;

    fSplash.Label3.Caption := '';
    fSplash.lbVer.Caption := 'Checking for updates...';
    Application.ProcessMessages;
    Log('Checking for updates...');
    if RunPhpScript('check_currversion.php', handle, true) then begin
      versionAvailable := UrlAnswer; // ulozime si to sem, lebo ak je zapnute remote logovanie, tak Log() nam vzdy prepise UrlAnswer na "OK"
      try
        myReg.WriteDate('App_LastUpdateCheck', now());
        // cislo udavajuce verziu bude v tvare 112233 (1=hl.verzia, 2=subver., 3=release)
        Log('User has most recent version: ' + versionAvailable);
        Log('Installed version: ' + IntToStr((cfg_swVersion1 * 10000) + (cfg_swVersion2 * 100) + cfg_swVersion3));
        if StrToInt(versionAvailable) > ((cfg_swVersion1 * 10000) + (cfg_swVersion2 * 100) + cfg_swVersion3) then begin
          fUpdateNotification.ShowModal(versionAvailable);
          case fUpdateNotification.ModalResult of
            mrYes: BrowseUrl('download-quickpanel-program-software-update');
          end;
        end else
          if not silent then
            MessageBox(handle, PChar(TransTxt('You have the latest version.')), PChar(TransTxt('Information')), MB_ICONINFORMATION);
      except
        on E : Exception do
          Log('Error after current-version-check. Error: ' + e.Message);
      end;
    end else
      MessageBox(0, 'Update check failed', 'Error', MB_ICONERROR OR MB_OK);

  end; // if ((dateDiff > config_age_max) OR (forced))
  myReg.Free;
end;

procedure TfMain.RemindRegister(hwnd: HWND);
begin
  if (Length( ReadRegistry_string('User', 'UserCode') ) <> 32) then
    MessageBox(hwnd, PChar(TransTxt('You are not a registered user.')+#13+
                     TransTxt('Please register now to have access to all features of this software.')+#13+
                     TransTxt('Just go to   Help / Register user...')+#13+#13+
                     TransTxt('If you have already registered, please enter your registration code')+#13+
                     TransTxt('into   Help / Enter registration code...')), PChar(TransTxt('Information')), MB_ICONINFORMATION);
end;


procedure TfMain.WriteRegistry_bool(key, valname: string; val: boolean);
begin
  try
    WriteRegistry_string( key, valname, BoolToStr(val, true) );
  except
  end;
end;

procedure TfMain.WriteRegistry_integer(key, valname:string; val: integer);
begin
  try
    WriteRegistry_string( key, valname, IntToStr(val) );
  except
  end;
end;

procedure TfMain.WriteRegistry_string(key, valname, val: string);
var
  myReg: TRegistry;
begin
  myReg := TRegistry.Create;
  try
    myReg.RootKey := HKEY_CURRENT_USER;
    myReg.OpenKey('Software\QuickPanel\'+key, true);
    myReg.WriteString(valname, val);
  finally
    myReg.Free;
  end;
end;

function TfMain.ReadRegistry_bool(key, valname: string; default: Boolean = false): boolean;
begin
	try
		result := StrToBool( ReadRegistry_string(key, valname, BoolToStr(default, true)));
  except
  end;
end;

function TfMain.ReadRegistry_integer(key, valname: string; default: integer = 0): integer;
var
  tmp_s: string;
begin
	try
//    // ked nebol osetreny pripad navratu prazdneho stringu, vysledkom bol nahodny integer
//    tmp_s := ReadRegistry_string(key, valname);
//    if (tmp_s = '') then tmp_s := '0';
//
//		result := StrToInt( tmp_s );
		result := StrToInt( ReadRegistry_string(key, valname, IntToStr(default)));
  except
  end;
end;

function TfMain.ReadRegistry_string(key, valname: string; default: string = ''): string;
var
  myReg: TRegistry;
begin
	result := '';
  myReg := TRegistry.Create;
  try
    myReg.RootKey := HKEY_CURRENT_USER;
    myReg.OpenKey('Software\QuickPanel\'+key, true);
    if RegistryValueExists(key, valname) then
      result := myReg.ReadString(valname)
    else
      result := default;
  finally
    myReg.Free;
  end;
end;

function TfMain.RegistryValueExists(key,value: string): boolean;
var
  myReg: TRegistry;
begin
  myReg := TRegistry.Create;
  try
    myReg.RootKey := HKEY_CURRENT_USER;
    myReg.OpenKey('Software\QuickPanel\'+key, false);
    result := myReg.ValueExists(value);
  finally
    myReg.Free;
  end;
end;



procedure TfMain.LoadRecentFiles;
var
	i: byte;
  filename: string;
begin
  // naplnime zoznam posledne otvorenych suborov
  if (not Assigned(recentFiles)) then
  	recentFiles := TStringList.Create;

  for i := 1 to pocetPosledneOtvorenych do begin
  	filename := ReadRegistry_string('Config', 'App_Recent'+inttostr(i));
    if filename <> '' then
  		recentFiles.Add( ExtractFileName(filename)+'='+filename );
//    else
//  		recentFiles.Add( '' );
  end;

  UpdateRecentMenu;
end;

procedure TfMain.ShowWish(title: string = '');
begin
  fPoziadavka.edTopic.Text := title;
  fPoziadavka.ShowModal;
  fPoziadavka.memMessage.SelectAll;
end;

procedure TfMain.btnAddGuideClick(Sender: TObject);
begin
  ShowWish('Other request / demand');
end;

procedure TfMain.SetFormTitle;
begin
	if _PNL.FileName <> '' then
  	Caption := 'QuickPanel - ' + ExtractFileName(_PNL.FileName)
  else
  	Caption := 'QuickPanel';
end;

procedure TfMain.SetLanguage(Sender: TObject);
var
  tmps, transFileName: string;
begin
  tmps := copy( (sender as TMenuItem).Name, 14, 2 );
  transFileName := ExtractFilePath(Application.ExeName) + 'trans_' + tmps + '.txt';

  if FileExists( transFileName ) then begin

    WriteRegistry_string('Config', 'App_Language', tmps);
    Language := tmps;

    MessageBox(handle, PChar(TransTxt('Changes will take effect after restarting the program.')), PChar(TransTxt('Information')), MB_ICONINFORMATION);
    (Sender as TMenuItem).Checked := true;
  end else begin

    MessageBox(handle, PChar(TransTxt('Translation file is missing.') + #13 + transFileName), PChar(TransTxt('Error')), MB_ICONERROR);
  end;
end;

procedure TfMain.PopupMenuPopup(Sender: TObject);
var
  poleNajdenych: TPoleIntegerov;
begin
  popupPoint.X := ScreenToClient(Mouse.CursorPos).X;
  popupPoint.Y := ScreenToClient(Mouse.CursorPos).Y;
  _PNL.GetFeaturesAt(poleNajdenych, popupPoint.X, popupPoint.Y);
  if (Length(poleNajdenych) = 1)
  AND (_PNL.GetFeatureByID(poleNajdenych[0]).Selected = false) then begin
    _PNL.DeselectAll;
    if _PNL.GetFeatureByID(poleNajdenych[0]).ComboID = -1 then
      _PNL.GetFeatureByID(poleNajdenych[0]).Selected := true
    else
      _PNL.SelectCombo( _PNL.GetFeatureByID(poleNajdenych[0]).ComboID );
    _PNL.Draw;
  end;
  Edit1Click(sender);
  popLock.Enabled := EditLock.Enabled;
  popDelete.Enabled := EditDelete.Enabled;
  popClone.Enabled := EditClone.Enabled;
  popMirror.Enabled := EditMirror.Enabled;
  popMakeCombo.Enabled := EditMakeCombo.Enabled;
  popExplodeCombo.Enabled := EditExplodeCombo.Enabled;
end;

procedure TfMain.CheckDecimalPoint(sender: TObject; var Key: Char; defaultButton: TCustomButton);
//var
//  allSelected: boolean;
begin
  // opravuje desatinnu ciarku na desatinnu bodku v akomkolvek TEdit-e

// ak je vyselectovane vsetko, tak to najprv zmaze
//  allSelected := (sender as TCustomEdit).SelText = (sender as TCustomEdit).Text;

// ak tam este nie je '.' (alebo ak je vsetko vyselectovane) tak nahradza ',' -> '.'
//  if (Pos('.', (Sender as TCustomEdit).Text ) = 0) OR (allSelected) then
  if (Key = ',') then Key := '.';
//    else ;

  // ak stlaci ENTER, berie to ako potvrdenie okna
  if (Key=#13) then begin
    // este pred potvrdenim okna prezenieme text v edite cez expression evaluator (ak by tam bol daky matem.vyraz)
    uLib.SolveMathExpression(sender);

    if (defaultButton <> nil) then begin
      defaultButton.Click;
    end;

    Key := #0;
  end;

end;


procedure TfMain.Log(s: string; showform: boolean = false);
begin
  // zaloguje spravu 's'
  // ak uz je vytvoreny fDebug, tak donho a ak nie je tak do docasneho TStringListu TMPLOGSPACE
  // v pripade, ze je aktivovany specialny debug rezim (drzany SHIFT pocas spustania app) tak tuto spravu odosle PHP skriptu na webe
  // ak je ale nastaveny NoRemoteLog = true, tak nebude logovat na web (vznikla deadloop ked Log zavolal RunPhpScript a ten zase zavolal Log)

  if Assigned(fDebug) then
    fDebug.LogMessage(s, showform)
  else begin
    if Assigned(tmpLogStringList) then
      tmpLogStringList.Add(s);
  end;

  if RemoteLogEnabled then
    RunPhpScript('remotelog.php?msg='+ StringsReplace(s, [' '], ['%20']) , 0, true);

  // ak je uz v logu zapisanych vela riadkov, tak aby to nezacalo nejak spomalovat system, tak ich zmazem
  //(ale len ak nie sme v rezime RemoteLogEnabled, lebo vtedy zrejme nieco debugujeme a nechceme prist o ziadne info)
  if (Assigned(fDebug)) AND (fDebug.memo.Lines.Count > 777) AND (not RemoteLogEnabled) then
    fDebug.memo.Lines.Clear;
end;

procedure TfMain.Log(p: TMyPoint; showform: boolean = false);
begin
  log (MyPointToStr(p), showform);
end;

procedure TfMain.Log(b, showform: boolean);
begin
  log(BoolToStr(b,true), showform);
end;

procedure TfMain.Log(i: integer; showform: boolean);
begin
  log(IntToStr(i), showform);
end;

procedure TfMain.Log(strarr: TPoleTextov; showform: boolean);
var
  i: integer;
begin
  for i := 0 to High(strarr) do
    Log('['+IntToStr(i)+']=' + strarr[i], showform);
end;

procedure TfMain.Log(sl: TStringList; showform: boolean);
var
  i: integer;
begin
  for i := 0 to sl.Count-1 do
    Log('['+IntToStr(i)+']=' + sl.Strings[i], showform);
end;


procedure TfMain.Log(f: double; showform: boolean);
begin
  log(floatToStr(f), showform);
end;

procedure TfMain.LogToTextFile(msg: string);
var
  txtlog: TextFile;
  fajl: string;
begin
  //
	// pocas startu budeme vytvarat docasny text file na disku
  // aby som ho mohol analyzovat ak sa niekomu nepodari spustit QP
  //
  exit;
  fajl := ExtractFilePath( Application.ExeName ) + '_start_.log';
  if msg = 'delete yourself!' then begin
  	DeleteFile(fajl);
  end else begin
    AssignFile(txtlog, fajl);
    if (FileExists(fajl)) then
      Append(txtlog)
    else
      Rewrite(txtlog);
    Writeln(txtlog, msg);
    CloseFile(txtlog);
  end;
end;



end.

