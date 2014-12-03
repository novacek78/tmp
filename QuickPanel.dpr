program QuickPanel;



uses
  Forms,
  Windows,
  SysUtils,
  uConfig in 'uConfig.pas',
  uMain in 'uMain.pas' {fMain},
  uSplash in 'uSplash.pas' {fSplash},
  uPanelSett in 'uPanelSett.pas' {fPanelSett},
  uObjectPanel in 'uObjectPanel.pas',
  uObjectFeature in 'uObjectFeature.pas',
  uMyTypes in 'uMyTypes.pas',
  uDebug in 'uDebug.pas' {fDebug},
  uOrderForm in 'uOrderForm.pas' {fOrder},
  uBrowser in 'uBrowser.pas' {fBrowser},
  uPersonal in 'uPersonal.pas' {fPersonal},
  uFeaPocket in 'uFeaPocket.pas' {fFeaPocket},
  uFeaThread in 'uFeaThread.pas' {fFeaThread},
  uFeaConus in 'uFeaConus.pas' {fFeaConus},
  uOtherObjects in 'uOtherObjects.pas',
  uFeaEngrave in 'uFeaEngrave.pas' {fFeaEngraving},
  uRegisterUser in 'uRegisterUser.pas' {fRegisterUser},
  uRegisteredCode in 'uRegisteredCode.pas' {fRegisteredCode},
  uPoziadavka in 'uPoziadavka.pas' {fPoziadavka},
  uFeaCombo in 'uFeaCombo.pas' {fFeaCombo},
  uFeaGroove in 'uFeaGroove.pas' {fFeaGroove},
  uGuides in 'uGuides.pas' {fGuides},
  uToolClone in 'uToolClone.pas' {fToolClone},
  uObjectFeatureList in 'uObjectFeatureList.pas',
  uDrawLib in 'uDrawLib.pas',
  uObjectCombo in 'uObjectCombo.pas',
  uObjectComboList in 'uObjectComboList.pas',
  uTranslate in 'uTranslate.pas',
  uPrinting in 'uPrinting.pas',
  uFeaScale in 'uFeaScale.pas' {fFeaScale},
  uObjectDXFEntity in 'uObjectDXFEntity.pas',
  uObjectFeaturePolyLine in 'uObjectFeaturePolyLine.pas',
  Vcl.Themes,
  Vcl.Styles,
  uObjectHPGLDrawing in 'uObjectHPGLDrawing.pas',
  uObjectDXFDrawing in 'uObjectDXFDrawing.pas',
  uOrderComment in 'uOrderComment.pas' {fOrderComment},
  uObjectFont in 'uObjectFont.pas',
  uObjectFontZnak in 'uObjectFontZnak.pas',
  uObjectUrlDotaz in 'uObjectUrlDotaz.pas',
  polygonclipper in 'polygonclipper.pas',
  uLib in 'uLib.pas',
  uObjectGuideList in 'uObjectGuideList.pas',
  uToolMirror in 'uToolMirror.pas' {fToolMirror},
  uUpdateNotification in 'uUpdateNotification.pas' {fUpdateNotification},
  FastGEO in 'FastGEO.pas',
  uFeaCosmetic in 'uFeaCosmetic.pas' {fFeaCosmetic},
  uFeaHole in 'uFeaHole.pas' {fFeaHole},
  uDXFImport in 'uDXFImport.pas' {fDxfImport},
  uObjectDrawing in 'uObjectDrawing.pas';

{$R *.res}

begin
//  ReportMemoryLeaksOnShutdown := DebugHook <> 0; // pri ukonceni app (ak je pustena z delphi v debug rezime) ukaze, ktore obj ostali visiet v pamati

  { VYTVORENIE SPLASH OBRAZKU
  obrazok, resp. forma, ktora sa zobrazi pri spusteni programu.
  nizsie je mozne nadefinovat dobu zobrazenia splash-u }
  fSplash := TfSplash.Create(Application);
{$IFNDEF DEBUG}
  fSplash.Show;
  Application.Initialize;
  TStyleManager.TrySetStyle('Slate Classico');
  Application.Title := 'QuickPanel';
  fSplash.Update;
  Sleep(50);
{$ENDIF}
  Application.CreateForm(TfMain, fMain);
  fMain.LogToTextFile('creating TfDebug...');
  Application.CreateForm(TfDebug, fDebug);
	fMain.LogToTextFile('creating TfPanelSett...');
  Application.CreateForm(TfPanelSett, fPanelSett);
  fMain.LogToTextFile('creating TfUpdateNotification...');
  Application.CreateForm(TfUpdateNotification, fUpdateNotification);
	fMain.LogToTextFile('creating TfFeaHole...');
  Application.CreateForm(TfFeaHole, fFeaHole);
	fMain.LogToTextFile('creating TfFeaCosmetic...');
  Application.CreateForm(TfFeaCosmetic, fFeaCosmetic);
	fMain.LogToTextFile('creating TfOrder...');
  Application.CreateForm(TfOrder, fOrder);
	fMain.LogToTextFile('creating TfBrowser...');
  Application.CreateForm(TfBrowser, fBrowser);
	fMain.LogToTextFile('creating TfPersonal...');
  Application.CreateForm(TfPersonal, fPersonal);
	fMain.LogToTextFile('creating TfFeaPocket...');
  Application.CreateForm(TfFeaPocket, fFeaPocket);
	fMain.LogToTextFile('creating TfFeaThread...');
  Application.CreateForm(TfFeaThread, fFeaThread);
	fMain.LogToTextFile('creating TfFeaConus...');
  Application.CreateForm(TfFeaConus, fFeaConus);
	fMain.LogToTextFile('creating TfFeaEngraving...');
  Application.CreateForm(TfFeaEngraving, fFeaEngraving);
	fMain.LogToTextFile('creating TfRegisterUser...');
  Application.CreateForm(TfRegisterUser, fRegisterUser);
	fMain.LogToTextFile('creating TfRegisteredCode...');
  Application.CreateForm(TfRegisteredCode, fRegisteredCode);
	fMain.LogToTextFile('creating TfPoziadavka...');
  Application.CreateForm(TfPoziadavka, fPoziadavka);
	fMain.LogToTextFile('creating TfFeaCombo...');
  Application.CreateForm(TfFeaCombo, fFeaCombo);
	fMain.LogToTextFile('creating TfFeaGroove...');
  Application.CreateForm(TfFeaGroove, fFeaGroove);
	fMain.LogToTextFile('creating TfGuides...');
  Application.CreateForm(TfGuides, fGuides);
	fMain.LogToTextFile('creating TfToolClone...');
  Application.CreateForm(TfToolClone, fToolClone);
	fMain.LogToTextFile('creating TfToolMirror...');
  Application.CreateForm(TfToolMirror, fToolMirror);
	fMain.LogToTextFile('creating TfFeaScale...');
  Application.CreateForm(TfFeaScale, fFeaScale);
	fMain.LogToTextFile('creating TfOrderComment...');
  Application.CreateForm(TfOrderComment, fOrderComment);
  fSplash.Hide;
  Application.Run;
end.
