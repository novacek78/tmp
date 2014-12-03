unit uOrderForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, IniFiles, ComCtrls, Menus, Buttons, Math, ShellAPI,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdExplicitTLSClientServerBase, IdFTP, IdGlobal, IdURI;

type
  TfOrder = class(TForm)
    sg: TStringGrid;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    lbVyroba: TLabel;
    lbRezia: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbSpolu: TLabel;
    Label2: TLabel;
    lbSpolusDPH: TLabel;
    pnlWait: TPanel;
    lbWait: TLabel;
    barWeb: TProgressBar;
    btnSadOrder: TSpeedButton;
    lbFAQ: TLabel;
    ftp: TIdFTP;
    btnPanelAdd: TSpeedButton;
    btnGetPrice: TSpeedButton;
    btnDetails: TSpeedButton;
    btnOpen: TSpeedButton;
    btnPersonal: TSpeedButton;
    btnPanelDel: TSpeedButton;
    btnAttach: TSpeedButton;
    btnSend: TSpeedButton;
    procedure PosunProgressBar(o_kolko: byte = 1);
    procedure ZrusEdit(schovajObjekt: boolean = true);
    procedure PridajPanel(panelfile: string);
    procedure ZiskajCeny_v2;

    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sgSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgTopLeftChanged(Sender: TObject);
    procedure btnPanelAddClick(Sender: TObject);
    procedure btnGetPriceClick(Sender: TObject);
    procedure sgDblClick(Sender: TObject);
    procedure sgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnPanelDelClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnDetailsClick(Sender: TObject);
    procedure GridEditKeyPress(Sender: TObject; var Key: Char);
    procedure btnSendClick(Sender: TObject);
    procedure btnPersonalClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure btnSadOrderClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure lbFAQClick(Sender: TObject);
    procedure ftpStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: string);
    procedure btnAttachClick(Sender: TObject);
    procedure GridEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fOrder: TfOrder;
  ed: TEdit;
  xcol,xrow: integer;
  userID: string; // je to tu ako globalna lebo ked je neregistrovany a pridelime mu pocas nacenovania nahodne cislo, tak ho este budeme potrebovat ked si chce pozriet detaily ceny panela


implementation

uses uMain, uObjectPanel, uObjectFeature, uObjectFeaturePolyline, uMyTypes, uDebug, uBrowser,
  uConfig, uPersonal, uRegisteredCode, uPanelSett, uTranslate, uOrderComment,
  uObjectUrlDotaz;

{$R *.dfm}

procedure TfOrder.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(key) = 27 then  // ESC
    if (Assigned(ed)) AND (ed.Focused) then
      ZrusEdit
    else
      Close;
end;



procedure TfOrder.ZrusEdit(schovajObjekt: boolean = true);
begin
  // ak je niekde zobrazeny TEdit a zadava sa pocet kusov,
  // tak vpisany pocet kusov aplikujeme a TEdit skryjeme
  if Assigned(ed) then begin
    try
      if (StrToInt(ed.Text) = 0) then
        ed.Text := sg.Cells[xcol,xrow];    // ak zadal nulu, dame tam povodnu hodnotu
    except
      ed.Text := sg.Cells[xcol,xrow];      // ak zadava somariny, dame tam povodnu hodnotu
    end;
    if (sg.Cells[xcol,xrow] <> ed.Text) then begin // ak zadal novy pocet, zmaze vypocitane ceny
      sg.Cells[colPrice, xrow] := '?';
      sg.Cells[colPriceSum, xrow] := '?';
      lbVyroba.Caption := '?';
      lbRezia.Caption := '?';
      lbSpolu.Caption := '?';
      lbSpolusDPH.Caption := '?';
      btnDetails.Enabled := false;
      sg.Cells[xcol,xrow] := ed.Text;
    end;
    if schovajObjekt then begin
      ed.Visible := false;
      sg.SetFocus;
    end;
  end;
end;

procedure TfOrder.PosunProgressBar(o_kolko: byte = 1);
begin
  barWeb.Position := barWeb.Position + o_kolko;
  Application.ProcessMessages;
end;


procedure TfOrder.PridajPanel(panelfile: string);
var
  r: integer; // r = cislo riadku, do ktoreho sa pridava novy panel
  pnl: TPanelObject;
begin
  if ExtractFileExt(panelfile) <> '.panel' then EXIT;

  if sg.Cells[colName,1] = '' then r := 1
  else begin
    sg.RowCount := sg.RowCount+1;
    r := sg.RowCount-1;
  end;

  sg.Cells[colName,r] := ChangeFileExt( ExtractFileName(panelfile), '');
  sg.Objects[0,r] := TPanelObject.Create;
  (sg.Objects[0,r] as TPanelObject).LoadFromFile(panelfile);
  pnl := (sg.Objects[0,r] as TPanelObject);

  sg.Cells[colNote,r] := FloatToStr(pnl.Sirka)+' x '+FloatToStr(pnl.Vyska)+' x '+FloatToStr(pnl.Hrubka)+' mm';
  sg.Cells[colPieces,r] := '1';
  sg.Cells[colPrice,r] := '?';
  sg.Cells[colPriceSum,r] := '?';
  lbVyroba.Caption := '?';
  lbRezia.Caption := '?';
  lbSpolu.Caption := '?';
  lbSpolusDPH.Caption := '?';

  btnGetPrice.Enabled := true;
  btnPanelDel.Enabled := true;
  btnOpen.Enabled := true;
{
  if not Vsetko_OK then begin // ak bola nejaka chyba, odstrani pridany riadok
    FreeAndNil( pnl );
    sg.RowCount := sg.RowCount-1;
  end;
}
end;

procedure TfOrder.ZiskajCeny_v2;
var
  remoteFileName, country: string;
  p, i, porcislo: integer;
  pnl: TPanelObject;
  riadky, paramsHeader, paramsData: TPoleTextov;
  paramStrings: TStringList;
  cenaZaPanel: extended;
  cenaVyroba: extended;
  cenaRezia: Extended;
  DPH: Extended;
  dotaz: TUrlDotaz;
begin
  ZrusEdit;

  if not Assigned( sg.Objects[0,1] ) then Exit;  // ak hned v 1. riadku chyba objekt, ani nezacne

  pnlWait.Visible := true;
  btnGetPrice.Enabled := not pnlWait.Visible;
  btnPanelAdd.Enabled := not pnlWait.Visible;
  btnPanelDel.Enabled := not pnlWait.Visible;
  btnOpen.Enabled := not pnlWait.Visible;
  btnPersonal.Enabled := not pnlWait.Visible;
  btnSadOrder.Enabled := not pnlWait.Visible;
  btnDetails.Enabled := not pnlWait.Visible;
  btnAttach.Enabled := not pnlWait.Visible;
  btnSend.Enabled := not pnlWait.Visible;
  Application.ProcessMessages;

  // reset posuvnika
  barWeb.Position := 0;

  // nastavime maximum pre posuvnik
  i := 0;
  Inc(i);                // ziadost o inicializaciu (vycistenie od nepotrebnych suborov)
  Inc(i);                // pripajanie na FTP
  Inc(i);                // pripojene na FTP
  Inc(i, sg.RowCount-1); // panel odoslany na FTP
  Inc(i);                // prijatie odpovede zo servera
  Inc(i);                // spracovanie odpovede
  barWeb.Max := i;

  try
    // neregistrovanym userom pridelim docasne UID - pocet ms od zapnutia Win :-)
    if (fRegisteredCode.edCode.Text = '') then begin
      if (userID = '') then userID := IntToStr(GetTickCount)
    end else
      userID := fRegisteredCode.edCode.Text;

    PosunProgressBar;

    dotaz := TUrlDotaz.Create('panelprice_vycisti_v3.php');
    dotaz.params.Add('uid='+userID);
    fMain.RunPhpScript(dotaz, handle);
    // (dotaz este nenicim (free) lebo je pouzity aj nizsie)

    PosunProgressBar;

    ftp.Host := ftpHost;
    ftp.Username := ftpUser;
    ftp.Password := ftpPwd;
    ftp.Connect;

    PosunProgressBar;

    // posleme postupne vsetky panely
    for p:=1 to sg.RowCount-1 do begin
      if Assigned(sg.Objects[0,p]) then begin
        pnl := (sg.Objects[0,p] as TPanelObject);
        if pnl.Version <= 310 then pnl.SaveToFile( pnl.FileName ); // ak sa ma dopytovat stary subor, preulozime ho lebo PHP ho nezozerie
        // najprv odstranime z mena suboru diakritiku
        remoteFileName := OdstranDiakritiku( ExtractFileName(pnl.FileName) );
        remoteFileName := userID + '-' + FormatFloat('000',p) + 'x' + sg.Cells[colPieces, p] + '-' + remoteFileName;
        ftp.Put(pnl.FileName, remoteFileName);
        fMain.Log('Orders:FTP:'+pnl.FileName);
        PosunProgressBar;
      end;
    end;

    // vsetko uploadnute, poslem dopyt o nacenenie
    if (fRegisteredCode.edCode.Text <> '') then begin
      if (not fPersonal.comOtherAddress.Checked) then
        country := 'registered'
      else
        country := fPersonal.comKrajinaValue.Text;
    end else
        country := 'cz';

    dotaz.params.Clear;
    dotaz.adresa := 'panelprice_v3.php';
    dotaz.params.Add('uid='+userID);
    dotaz.params.Add('country='+country);
    dotaz.params.Add('lang='+Language);
    fMain.RunPhpScript(dotaz, handle);
    dotaz.Free;

    PosunProgressBar;

    //UrlAnswer := 'porcislo|panelid|cenaks'+#13+'002|1|17.22'+#13+'001|2|34.11'+#13+'postovnebalne|sadzbadph'+#13+'15|20'; // namodelovane koli testu
    // postupne rozparsujeme riadky s informaciami o cenach panelov
    ExplodeString(UrlAnswer, #13+#10, riadky);
    if (riadky[0] = 'ERROR') then begin
      MessageBox(handle, PChar(TransTxt('Price calculation was aborted. Reason:')+#13+riadky[1]), Pchar(TransTxt('Error')), MB_ICONERROR);
    end else begin
      ExplodeString(riadky[0], separChar, paramsHeader); // zistenie struktury riadkov
      paramStrings := TStringList.Create;
      for p:=1 to sg.RowCount-1 do begin
        ExplodeString(riadky[p], separChar, paramsData);
        for i := 0 to High(paramsHeader) do begin
          paramStrings.Values[ paramsHeader[i] ] := paramsData[i];
        end;
        porcislo := StrToInt(paramStrings.Values['porcislo']);
        (sg.Objects[0, porcislo] as TPanelObject).ID := StrToInt(paramStrings.Values['panelid']);
        if (paramStrings.Values['cenaks'] = '') then                            // v pripade nejakej chyby na serveri aspon oznamime, ze nic neprislo
          MessageBox(handle, PChar(TransTxt('Price calculation was aborted. Reason:')+#13+'empty price'), Pchar(TransTxt('Error')), MB_ICONERROR);
        cenaZaPanel := RoundTo( StrToFloat(paramStrings.Values['cenaks']), -2);
        sg.Cells[colPrice, porcislo]    := FormatFloat('##0.00 €', cenaZaPanel);
        sg.Cells[colPriceSum, porcislo] := FormatFloat('##0.00 €', cenaZaPanel * StrToInt(sg.Cells[colPieces, porcislo]) );
        cenaVyroba := cenaVyroba + (cenaZaPanel  * StrToInt(sg.Cells[colPieces, porcislo]));
      end;

      // teraz rozparsujeme riadok s cenu za postovne a balne
      paramStrings.Clear;
      ExplodeString(riadky[sg.RowCount], separChar, paramsHeader);
      ExplodeString(riadky[sg.RowCount+1], separChar, paramsData);
      for i := 0 to High(paramsHeader) do begin
        paramStrings.Values[ paramsHeader[i] ] := paramsData[i];
      end;
      cenaRezia := StrToFloat( paramStrings.Values['postovnebalne'] );  // vytiahneme cenu za reziu
      DPH := StrToFloat( paramStrings.Values['sadzbadph'] );            // vytiahneme percento DPH
      DPH := RoundTo((DPH/100) + 1, -2);

//      if cenaVyroba > 0 then begin
        lbVyroba.Caption := FormatFloat('0.00 €', cenaVyroba);
        lbRezia.Caption  := FormatFloat('0.00 €', cenaRezia);
        lbSpolu.Caption  := FormatFloat('0.00 €', cenaVyroba + cenaRezia);
        lbSpolusDPH.Caption  := FormatFloat('0.00 €', (cenaVyroba + cenaRezia)*DPH);
//      end;

      PosunProgressBar;
      Sleep(400); // trosku pockame, nech je vidno, ze progress bar dosiel az do konca
    end;
  finally
    pnlWait.Visible := false;
    btnGetPrice.Enabled := not pnlWait.Visible;
    btnPanelAdd.Enabled := not pnlWait.Visible;
    btnPanelDel.Enabled := not pnlWait.Visible;
    btnOpen.Enabled := not pnlWait.Visible;
    btnPersonal.Enabled := not pnlWait.Visible;
    btnSadOrder.Enabled := not pnlWait.Visible;
    btnDetails.Enabled  := not pnlWait.Visible;
    btnAttach.Enabled := not pnlWait.Visible;
    btnSend.Enabled := not pnlWait.Visible;
    lbFAQ.Visible   := btnSend.Enabled;
    paramStrings.Free;
    ftp.Disconnect;
  end;
  fMain.Log( '-------------------------------------------' );
end;

procedure TfOrder.FormCreate(Sender: TObject);
begin
  sg.Cells[colName,0] := TransTxt('Panel');
  sg.ColWidths[colName] := 275;
  sg.Cells[colNote,0] := TransTxt('Description');
  sg.ColWidths[colNote] := 175;
  sg.Cells[colPrice,0] := TransTxt('Price/piece');
  sg.ColWidths[colPrice] := 75;
  sg.Cells[colPieces,0] := TransTxt('Pieces');
  sg.ColWidths[colPieces] := 70;
  sg.Cells[colPriceSum,0] := TransTxt('Subtotal');
  sg.ColWidths[colPriceSum] := 100;
  fMain.imgList_common.GetBitmap(0, btnSadOrder.Glyph);
  fMain.imgList_common.GetBitmap(3, btnPanelAdd.Glyph);
  fMain.imgList_common.GetBitmap(4, btnPanelDel.Glyph);
  fMain.imgList_common.GetBitmap(5, btnGetPrice.Glyph);
  fMain.imgList_common.GetBitmap(6, btnPersonal.Glyph);
  fMain.imgList_common.GetBitmap(7, btnDetails.Glyph);
  fMain.imgList_common.GetBitmap(8, btnOpen.Glyph);
  fMain.imgList_common.GetBitmap(9, btnAttach.Glyph);
  fMain.imgList_commonBig.GetBitmap(0, btnSend.Glyph);

end;

procedure TfOrder.FormShow(Sender: TObject);
begin
  // skontroluje, ci su zadane vsetky potrebne osobne udaje
  if fPersonal.CheckData then
    fPersonal.ModalResult := mrOK;
end;

procedure TfOrder.ftpStatus(ASender: TObject; const AStatus: TIdStatus;
  const AStatusText: string);
begin
  fMain.Log('Orders:FTP:'+AStatusText);
end;

procedure TfOrder.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  // zrusim ceny aby po znovuotvoreni musel vygenerovat ceny nanovo
  // pretoze on moze panel medzitym zmenit a tak by boli ceny neaktualne
  for i:=1 to sg.RowCount-1 do
    if Assigned( sg.Objects[0, i] ) then begin
      (sg.Objects[0, i] as TPanelObject).ID := -1;
      sg.Cells[colPrice, i] := '?';
      sg.Cells[colPriceSum, i] := '?';
    end;
  lbVyroba.Caption := '?';
  lbRezia.Caption := '?';
  lbSpolu.Caption := '?';
  lbSpolusDPH.Caption := '?';
  btnDetails.Enabled := false;
end;

procedure TfOrder.FormActivate(Sender: TObject);
var
  i: integer;
begin
  // zisti si (na prvom paneli), ci boli panely uz nacenene teda ci maju pridelene ID
  // ak ano, necha ich tak, ale ak nie, znovu ich nacita z disku - asi bol medzi tym obj.formular zatvoreny a panely sa mohli zmenit
  if (Assigned(sg.Objects[0,1])) AND ((sg.Objects[0,1] as TPanelObject).ID = -1) then begin
    for i:=1 to sg.RowCount-1 do
      if Assigned(sg.Objects[0,1]) then begin // stale pracujem s 1.riadkom - postupne sa posuvaju
        // na koniec zoznamu panelov pridame este raz panel, ktory spracuvame, ten ale uz bude fresh z disku
        PridajPanel( (sg.Objects[0,1] as TPanelObject).filename );
        sg.Row := 1;  // stale pracujem s 1.riadkom - postupne sa posuvaju
        btnPanelDel.Click;
      end;
    // ceny su zmazane (nahradene "?") takze tlacitka nemaju zmysel
    btnDetails.Enabled  := false;
    btnSend.Enabled  := false;
  end else
    // ked pri otvoreni nie je v zozname ziadny panel a v editore nejaky je otvoreny, tak ten tam nahrame automaticky
    if ((sg.RowCount = 2)
    AND (NOT Assigned(sg.Objects[0,1]))
    AND (_PNL.FileName <> '') ) then begin
      PridajPanel(_PNL.FileName);
    end;

  sg.SetFocus;
end;

procedure TfOrder.GridEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  myRect: TGridRect;
begin

  if (not Assigned(ed)) OR (not ed.Focused) then exit;


  if (Key = 13) OR (Key = 40) then begin // ENTER alebo sipka dolu
    if ( xrow < sg.RowCount-1 ) then begin  // ak este nestojime na poslednom riadku, posunieme TEdit nizsie
      ZrusEdit(false);
      ed.Top := ed.Top + sg.RowHeights[xrow] + 1;
      // posunieme vyselectovanie riadka o jeden nizsie
      myRect := sg.Selection;
      myRect.Top := myRect.Top + 1;
      myRect.Bottom := myRect.Bottom + 1;
      sg.Selection := myRect;
      // do TEditu nacitame pocet ks z dalsieho riadku
      Inc(xrow);
      ed.Text := sg.Cells[xcol,xrow];
      ed.SelectAll;
    end else begin
      ZrusEdit;
      sg.Cells[xcol,xrow] := ed.Text;
    end;
  end;

  if (Key = 38) then begin // sipka hore
    if ( xrow > 1 ) then begin  // ak este nestojime na prvom riadku, posunieme TEdit vyssie
      ZrusEdit(false);
      ed.Top := ed.Top - sg.RowHeights[xrow] - 1;
      // posunieme vyselectovanie riadka o jeden nizsie
      myRect := sg.Selection;
      myRect.Top := myRect.Top - 1;
      myRect.Bottom := myRect.Bottom - 1;
      sg.Selection := myRect;
      // do TEditu nacitame pocet ks z dalsieho riadku
      Dec(xrow);
      ed.Text := sg.Cells[xcol,xrow];
      ed.SelectAll;
    end else begin
      sg.Cells[xcol,xrow] := ed.Text;
    end;
  end;

end;

procedure TfOrder.GridEditKeyPress(Sender: TObject; var Key: Char);
var
  k: integer;
begin
  k := ord(key);
  if (k < 48) OR (k > 57) then        // znaky 48..57 su cisla
    if ((k <> 8) AND (k <> 13)) then  // 8 = Backspace, 13 = enter
      key := #0;
end;

procedure TfOrder.lbFAQClick(Sender: TObject);
begin
  fMain.BrowseWiki('');
end;

procedure TfOrder.sgSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  ZrusEdit;

  if (ACol <> 3) OR (sg.Cells[colName,ARow] = '') then exit;

  if (not Assigned(ed)) then begin
    ed := TEdit.Create(sg);
    ed.Parent := sg;
    ed.Width := sg.ColWidths[acol];
    ed.Top := sg.cellrect(acol,arow).top;
    ed.Left := sg.cellrect(acol,arow).Left;
    ed.Text := sg.Cells[acol,arow];
    ed.MaxLength := 3;
    ed.OnKeyDown  := fOrder.GridEditKeyDown;
    ed.OnKeyPress := fOrder.GridEditKeyPress;
    ed.SetFocus;
    xcol := acol;
    xrow := arow;
  end else begin
    ed.Width := sg.ColWidths[acol];
    ed.Top := sg.cellrect(acol,arow).top;
    ed.Left := sg.cellrect(acol,arow).Left;
    ed.Text := sg.Cells[acol,arow];
    ed.Visible := true;
    ed.SetFocus;
    xcol := acol;
    xrow := arow;
  end;
end;

procedure TfOrder.sgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  col,row:integer;
begin
  // ak klikne niekde mimo gridu, schova TEdit (ak je nejaky prave zobrazeny)
  col := -1;
  row := -1;
  sg.MouseToCell(X, Y, col,row);
  if (col = -1) OR (row = -1) then
    ZrusEdit;
end;

procedure TfOrder.sgDblClick(Sender: TObject);
begin
  btnOpen.Click;
end;

procedure TfOrder.sgTopLeftChanged(Sender: TObject);
begin
  ZrusEdit;
end;



procedure TfOrder.btnPanelAddClick(Sender: TObject);
var
  i: integer;
  boo: boolean;
begin
  fMain.OpenDialog.Options := fMain.OpenDialog.Options + [ofAllowMultiSelect];
  fMain.OpenDialog.InitialDir := fMain.ReadRegistry_string('Config', 'App_PanelsDir');
  if (fMain.OpenDialog.Execute) then begin
    // disablujeme tlacitka kym sa nahrava
    boo := false;
    btnPanelAdd.Enabled := boo;
    btnPanelDel.Enabled := boo;
    btnGetPrice.Enabled := boo;
    btnDetails.Enabled := boo;
    btnOpen.Enabled := boo;
    btnPersonal.Enabled := boo;
    btnSadOrder.Enabled := boo;
    btnAttach.Enabled := boo;
    btnSend.Enabled := boo;
    Application.ProcessMessages;

    // nahrame panely
    with fMain.OpenDialog.Files do
      for i := 0 to Count - 1 do
        PridajPanel( Strings[i] );

    fMain.WriteRegistry_string('Config', 'App_PanelsDir', ExtractFileDir(fMain.OpenDialog.Files[0]) );
  end;

  // enablujeme tlacitka
  boo := true;
  btnPanelAdd.Enabled := boo;
  btnPersonal.Enabled := boo;
  btnSadOrder.Enabled := boo;
  if (Assigned( sg.Objects[0,1] )) then begin
    btnPanelDel.Enabled := boo;
    btnGetPrice.Enabled := boo;
    btnOpen.Enabled := boo;
  end;

  sg.SetFocus;
end;

procedure TfOrder.btnPanelDelClick(Sender: TObject);
var
  i: integer;
begin
  if not Assigned( sg.Objects[0, sg.Row] ) then Exit;

  sg.Objects[0, sg.Row].Free;

  i := sg.Row+1;
  while i < sg.RowCount do begin
    sg.Rows[i-1] := sg.Rows[i];
    Inc(i);
  end;

  if sg.RowCount > 2 then  // ak je tam riadkov viac, tak mazeme cele riadky
    sg.RowCount := sg.RowCount-1
  else begin                    // ak uz zostava len jeden datovy riadok, ten nezmazeme, len vyprazdnime
    sg.Rows[sg.Row].Clear;
    btnPanelDel.Enabled := false;
    btnGetPrice.Enabled := false;
    btnOpen.Enabled := false;
    btnDetails.Enabled  := false;
    btnAttach.Enabled := false;
    btnSend.Enabled := false;
  end;

  lbVyroba.Caption := '?';
  lbRezia.Caption := '?';
  lbSpolu.Caption := '?';
  lbSpolusDPH.Caption := '?';
end;

procedure TfOrder.btnGetPriceClick(Sender: TObject);
begin
  // stava sa,ze po prebudeni PC z usporneho rezimu nastavi OS desatinny oddelovac
  // na default hodnotu "," , tak takto sa to vzdy opravi...
  FormatSettings.DecimalSeparator := '.';

  // pootravuje zivot - aby sa user zaregistroval
  if Length(fRegisteredCode.edCode.Text) <> 32 then begin

    // ********************* nacenenie panelov spravime (docasne) aj pre neregistrovanych ***********************
    {
    fMain.RemindRegister(fOrder.Handle);
    Exit;
    }

  end;

  ZiskajCeny_v2;
end;

procedure TfOrder.btnAttachClick(Sender: TObject);
begin
  fOrderComment.ShowModal;
  sg.SetFocus;
end;

procedure TfOrder.btnOpenClick(Sender: TObject);
begin
  if not Assigned( sg.Objects[0, sg.Row] ) then Exit;

  fMain.OpenFile( (sg.Objects[0, sg.Row] as TPanelObject).FileName );
  sg.SetFocus;
end;

procedure TfOrder.btnDetailsClick(Sender: TObject);
begin
  if Assigned(sg.Objects[0, sg.Row]) then begin
    fBrowser.WebBrowser1.Navigate( 'http://www.quickpanel.sk/clientappdir/pricedetails/'+
                                    userID +'_'+IntToStr( (sg.Objects[0, sg.Row] as TPanelObject).ID )+
                                    '.html'
                                 );
    fBrowser.Show;
  end;
end;

procedure TfOrder.btnPersonalClick(Sender: TObject);
begin
  fPersonal.ShowModal;
end;

procedure TfOrder.btnSendClick(Sender: TObject);
var
  i: integer;
  strURL, strPanels, strPieces, strPrices, mailtolink: string;
  pnl: TPanelObject;
  riadky: TPoleTextov;
  pisar: TStreamWriter;
  subor, order_id: string;
  attachmentSize: integer;
  dotaz: TUrlDotaz;
begin
  ZrusEdit;

  // stava sa,ze po prebudeni PC z usporneho rezimu nastavi OS desatinny oddelovac
  // na default hodnotu "," , tak takto sa to vzdy opravi...
  FormatSettings.DecimalSeparator := '.';

  if not btnSend.Enabled then Exit;  // ak procedura ZrusEdit disablovala odosielaci button

  if fPersonal.ModalResult <> mrOK then begin
    MessageBox(handle, PChar(TransTxt('Order could not be sent.')+#13+
                       TransTxt('Please fill in the Address and way-of-shipment form.')), PChar(TransTxt('Error')), MB_ICONERROR);
    Exit;
  end;

  if Length(fRegisteredCode.edCode.Text) <> 32 then begin
    // pootravuje zivot - aby sa user zaregistroval
    fMain.RemindRegister(fOrder.Handle);
    Exit;
  end;

  if lbSpolusDPH.Caption = '?' then begin
    MessageBox(handle, PChar(TransTxt('Order could not be sent.')+#13+
                       TransTxt('There are prices missing in your order.')+#13+#13+
                       TransTxt('Please click the button')+' "'+TransTxt('Get the prices')+'".'), PChar(TransTxt('Error')), MB_ICONERROR);
    Exit;
  end;

  if not Assigned( sg.Objects[0,1] ) then Exit;  // ak hned v 1. riadku chyba objekt, ani nezacne

  barWeb.Max := 2;         // testconnection a placeorder
  if (fOrderComment.MemoComment.Lines.Count > 0) then barWeb.Max := barWeb.Max + 1;  // ak sa bude odosielat aj poznamka k objed.
  barWeb.Max := barWeb.Max + fOrderComment.lbFiles.Items.Count;                      // za kazdu jednu prilohu k objednavke

  barWeb.Position := 0;
  Application.ProcessMessages;

  pnlWait.Visible := true;
  btnGetPrice.Enabled := not pnlWait.Visible;
  btnPanelAdd.Enabled := not pnlWait.Visible;
  btnPanelDel.Enabled := not pnlWait.Visible;
  btnOpen.Enabled     := not pnlWait.Visible;
  btnDetails.Enabled  := not pnlWait.Visible;
  btnPersonal.Enabled  := not pnlWait.Visible;
  btnAttach.Enabled     := not pnlWait.Visible;
  btnSend.Enabled     := not pnlWait.Visible;
  Application.ProcessMessages;

  if not fMain.RunPhpScript('test_connection.php', handle, true) then begin
    pnlWait.Visible := false;
    btnGetPrice.Enabled := not pnlWait.Visible;
    btnPanelAdd.Enabled := not pnlWait.Visible;
    btnPanelDel.Enabled := not pnlWait.Visible;
    btnOpen.Enabled     := not pnlWait.Visible;
    btnDetails.Enabled  := not pnlWait.Visible;
    btnPersonal.Enabled  := not pnlWait.Visible;
    btnAttach.Enabled     := not pnlWait.Visible;
    btnSend.Enabled     := not pnlWait.Visible;
    MessageBox(handle, PChar(TransTxt('Can not connect to the server.')+#13+TransTxt('Check your internet connection.')), Pchar(TransTxt('Error')), MB_ICONERROR);
    Exit;
  end;
  PosunProgressBar;

  try

  // najprv do URL zakomponujeme vsetky udaje o adrese a sposobe dorucenia
  with fPersonal do begin
  	dotaz := TUrlDotaz.Create('placeorder_v3.php');
    if comDeliveryAddress.Checked then dotaz.params.Add('address=delivery');
    if comBillingAddress.Checked then  dotaz.params.Add('address=billing');
    if comOtherAddress.Checked then begin
    	dotaz.params.Add('address=other');
      dotaz.params.Add('dorucitnafirmu='+edFirma.Text);
      dotaz.params.Add('meno='+edMeno.Text);
      dotaz.params.Add('priezvisko='+edPriezvisko.Text);
      dotaz.params.Add('ulica='+edUlica.Text);
      dotaz.params.Add('mesto='+edMesto.Text);
      dotaz.params.Add('psc='+edPSC.Text);
      dotaz.params.Add('krajina='+comKrajinaValue.Text);
      dotaz.params.Add('stat='+comStatValue.Text);
    end;
    dotaz.params.Add('cenarezia='+Copy( lbRezia.Caption, 0, Length(lbRezia.Caption)-2 ));
    dotaz.params.Add('cenaspolu='+Copy( lbSpolu.Caption, 0, Length(lbSpolu.Caption)-2 ));
    dotaz.params.Add('platba='+comPaymentMethodValue.Items.Strings[ comPaymentMethod.ItemIndex ]);
    dotaz.params.Add('dodanie='+comDeliveryValue.Items.Strings[ comDelivery.ItemIndex ]);
    dotaz.params.Add('priorita='+IntToStr(comPriority.ItemIndex));
    dotaz.params.Add('prtid='+cfg_PartnerCode);
    dotaz.params.Add('lang='+Language);
    dotaz.params.Add('uid='+fRegisteredCode.edCode.text);
  end;

  strPanels:='';
  strPieces:='';
  strPrices:='';

  for i:=1 to sg.RowCount-1 do begin
    if Assigned(sg.Objects[0,i]) then begin
      pnl := (sg.Objects[0,i] as TPanelObject);

      strPanels := strPanels + IntToStr(pnl.ID) + separChar;

    end; // ak je tam ulozeny objekt TPanelObject
  end; // pre vsetky riadky v stringliste

  dotaz.params.Add('panels=' + strPanels);

  fMain.RunPhpScript(dotaz , handle);
  PosunProgressBar;
  // odpoved musime rozparsovat na riadky - podla textu v prvom vieme ci OK alebo nie a v dalsich mozu prist dodatocne informacie
  ExplodeString(UrlAnswer, #13+#10, riadky);
  if (riadky[0] = 'OK') then begin
    order_id := riadky[1]; // v druhom riadku pride ID novozalozenej objednavky

    // ak zapisal nejake poznamky k objednavke, vytvorime TXT subor s poznamkami a odosleme ho cez FTP aj s prilohami
    if (fOrderComment.MemoComment.Lines.Count > 0) then begin
      subor := ExtractFilePath((sg.Objects[0,1] as TPanelObject).FileName)+'ordercomments.txt'; // pre docasne ulozenie suboru si vyberieme adresar, kde ma prvy panel v zozname - tam zrejme ma pristup na pisanie
      pisar := TStreamWriter.Create( subor, false, TEncoding.UTF8 );
      for i := 0 to fOrderComment.MemoComment.Lines.Count-1 do
        pisar.WriteLine(fOrderComment.MemoComment.Lines[i]);
      pisar.Free;
    end;

    // odosleme prilohy aj poznamky cez FTP na server
    ftp.Host := ftpHost;
    ftp.Username := ftpUser;
    ftp.Password := ftpPwd;
    ftp.Connect;
    if subor <> '' then begin
      ftp.Put(subor, 'ordercomments/id'+order_id+'_'+ExtractFileName(subor));
      PosunProgressBar;
    end;
    // spocitame velkost suborov na poslanie
    for i := 0 to fOrderComment.lbFiles.Items.Count-1 do begin
      attachmentSize := attachmentSize + FileSize(fOrderComment.lbFiles.Items[i]);
    end;
    lbWait.Caption := TransTxt('sending attachments...') + ' ('+FormatFloat('0.0', attachmentSize/1048576)+' MB)';
    Application.ProcessMessages;
    for i := 0 to fOrderComment.lbFiles.Items.Count-1 do begin
      ftp.Put(fOrderComment.lbFiles.Items[i], 'ordercomments/id'+order_id+'-'+ExtractFileName(fOrderComment.lbFiles.Items[i]));
      PosunProgressBar;
    end;

    lbWait.Caption := TransTxt('wait please...');
    ftp.Disconnect;
    DeleteFile(subor);

    // este upozornime admina, ze prisli prilohy
    if (subor <> '') OR (fOrderComment.lbFiles.Items.Count > 0) then begin
    	dotaz.params.Clear;
      dotaz.adresa := 'attachment_notify_v3.php';
      dotaz.params.Add('orderid='+order_id);
  		fMain.RunPhpScript(dotaz , handle);
      dotaz.Free;
    end;

  end;
  finally
    if (riadky[0] = 'OK') then begin
      MessageBox(handle, PChar(TransTxt('Your order have been sent.')+#13+TransTxt('Wait for an e-mail from us and confirm your order please.')), Pchar(TransTxt('Information')), MB_ICONINFORMATION);
    end else begin
      MessageBox(handle, PChar(TransTxt('Order was not accepted. Reason:')+#13+riadky[1]), Pchar(TransTxt('Error')), MB_ICONERROR);
    end;

    pnlWait.Visible := false;
    btnGetPrice.Enabled := not pnlWait.Visible;
    btnPanelAdd.Enabled := not pnlWait.Visible;
    btnPanelDel.Enabled := not pnlWait.Visible;
    btnOpen.Enabled := not pnlWait.Visible;
    btnDetails.Enabled  := not pnlWait.Visible;
    btnPersonal.Enabled  := not pnlWait.Visible;
    btnAttach.Enabled := not pnlWait.Visible;
    btnSend.Enabled := not pnlWait.Visible;
  end;
  fMain.Log( '-------------------------------------------' );
end;




procedure TfOrder.btnSadOrderClick(Sender: TObject);
begin
  fMain.ShowWish('Order');
end;


end.
