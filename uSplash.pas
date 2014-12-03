unit uSplash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, ShellApi, Registry, Vcl.Imaging.pngimage;

type
  TfSplash = class(TForm)
    Label3: TLabel;
    Image1: TImage;
    Shape1: TShape;
    lbVer: TLabel;
    lbPartner: TLabel;
    procedure GetPartnerInfo;
    function  GetPartnerSection(hFile: Pointer): string;
    function  GetFileVersion(const FileName: TFileName): String;

    procedure FormClick(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure lbPartnerClick(Sender: TObject);
    procedure lbPartnerMouseLeave(Sender: TObject);
    procedure lbPartnerMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSplash: TfSplash;

implementation

uses uConfig, uMain;

{$R *.dfm}

{$REGION 'formstuff'}
  procedure TfSplash.FormCreate(Sender: TObject);
  begin
    //Label3.Caption := '';
    lbVer.Caption := GetFileVersion('QuickPanel.exe');
    GetPartnerInfo;
  end;
  
  procedure TfSplash.FormClick(Sender: TObject);
  begin
    Close;
  end;
  
  procedure TfSplash.FormKeyPress(Sender: TObject; var Key: Char);
  begin
    Close;
  end;
{$ENDREGION}

{$REGION 'lbPartner'}
  procedure TfSplash.lbPartnerClick(Sender: TObject);
  begin
    if cfg_PartnerWWW <> '' then
      ShellExecute(0, 'open', PChar(cfg_PartnerWWW) ,nil,nil, SW_SHOWNORMAL);
  end;

  procedure TfSplash.lbPartnerMouseLeave(Sender: TObject);
  begin
    Cursor := crDefault;
  end;

  procedure TfSplash.lbPartnerMouseMove(Sender: TObject; Shift: TShiftState;
    X, Y: Integer);
  begin
    Cursor := crHandPoint;
  end;
{$ENDREGION}

{$REGION 'getpartnerinfo'}
  procedure TfSplash.GetPartnerInfo;
  var
    myReg: TRegistry;
    file_name: string;
    file_hnd : TextFile;
  begin
    // najprv skontroluje, ci nie je info o partnerovi v registroch.
    // ak nie, skusi ho nacitat zo suboru CONFIGPRT.DAT
    // a ak zlyha aj to, nedovoli spustit aplikaciu

    // najprv skusime nahrat partnera z registrov
    myReg := TRegistry.Create;
    myReg.RootKey := HKEY_CURRENT_USER;
    try
      if myReg.KeyExists('Software\QuickPanel\Partner') then begin
        myReg.OpenKey('Software\QuickPanel\Partner', false);
        StrToInt( myReg.ReadString('PartnerCode') );  // test, ci je to cislo
        cfg_PartnerName := myReg.ReadString('PartnerName');
        cfg_PartnerWWW  := myReg.ReadString('PartnerWWW');
        cfg_PartnerEmail:= myReg.ReadString('PartnerEmail');
        cfg_PartnerCode := myReg.ReadString('PartnerCode');
        cfg_PartnerNick := myReg.ReadString('PartnerNick');
        lbPartner.Caption := cfg_PartnerName; // zobrazime na splash-i
      end;
      myReg.Free;
    except
      cfg_PartnerName := 'error';
      myReg.Free;
    end;

    // ak sa nepodarilo nacitat z registrov, skusim to zo suboru
    if (cfg_PartnerName = 'error') OR (cfg_PartnerName = '') then begin

      file_name := ExtractFilePath(Application.ExeName)+'configprt.dat';
      if not FileExists(file_name) then begin
        cfg_PartnerName := 'error';
        Exit;
      end;

      try
      AssignFile(file_hnd, file_name);
      Reset(file_hnd);

      cfg_PartnerName := GetPartnerSection(@file_hnd);
      cfg_PartnerWWW  := GetPartnerSection(@file_hnd); // adresa aj s http://
      cfg_PartnerEmail:= GetPartnerSection(@file_hnd);
      cfg_PartnerCode := GetPartnerSection(@file_hnd);
      cfg_PartnerNick := GetPartnerSection(@file_hnd);
      try
        StrToInt(cfg_PartnerCode); // len test-ci je to cislo
      except
        cfg_PartnerName := 'error';
      end;

      // ak sa podarilo nacitat to zo suboru, ulozime to aj do registrov...
      if cfg_PartnerName <> 'error' then begin
        lbPartner.Caption := cfg_PartnerName; // zobrazime na splash-i
        myReg := TRegistry.Create;
        myReg.RootKey := HKEY_CURRENT_USER;
        try
          myReg.OpenKey('Software\QuickPanel\Partner', true);
          myReg.WriteString('PartnerName',  cfg_PartnerName);
          myReg.WriteString('PartnerWWW',   cfg_PartnerWWW);
          myReg.WriteString('PartnerEmail', cfg_PartnerEmail);
          myReg.WriteString('PartnerCode',  cfg_PartnerCode);
          myReg.WriteString('PartnerNick',  cfg_PartnerNick);
          myReg.Free;
        except
          myReg.Free;
        end;
      end; // if cfg_PartnerName <> 'error'

      finally
        CloseFile(file_hnd);
      end;
    end; //if (cfg_PartnerName = 'error') OR (cfg_PartnerName = '')
  end;

  function TfSplash.GetPartnerSection(hFile: Pointer): string;
  var
    fajl: ^TextFile;
    readLine: string;
    znak: char;
    endofsection: boolean;
  begin
    // vrati zo suboru nacitany text (1 pismenko / riadok) az po oddelovac, resp. koniec suboru
    result := '';
    fajl := hFile;

    endofsection := false;

    while (not endofsection) AND (not Eof(fajl^)) do begin
      Readln(fajl^, readLine);
      if readLine <> '' then begin
        try
          znak := Chr( StrToInt(readLine)-127 );
          if znak <> '$' then                     // oddelovac sekcii
            result := result + znak
          else
            endofsection := true;
        except
          MessageBox(handle, PChar('Error while initializing the application.'), 'Error', MB_ICONERROR);
        end;
      end;
    end;
  end;
{$ENDREGION}

procedure TfSplash.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FormClick(Sender);
end;

function TfSplash.GetFileVersion(const FileName: TFileName): String;
var
  VerInfoSize: Cardinal;
  VerValueSize: Cardinal;
  Dummy: Cardinal;
  PVerInfo: Pointer;
  PVerValue: PVSFixedFileInfo;
begin
  Result := '';
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  GetMem(PVerInfo, VerInfoSize);
  try
    if GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, PVerInfo) then
      if VerQueryValue(PVerInfo, '\', Pointer(PVerValue), VerValueSize) then
        with PVerValue^ do begin
          Result := Format('%d.%d.%d', [
            HiWord(dwFileVersionMS), //Major
            LoWord(dwFileVersionMS), //Minor
            HiWord(dwFileVersionLS), //Release
            LoWord(dwFileVersionLS)]); //Build // nevyuzite v tomto pripade
          cfg_swVersion1 := HiWord(dwFileVersionMS);
          cfg_swVersion2 := LoWord(dwFileVersionMS);
          cfg_swVersion3 := HiWord(dwFileVersionLS);
        end;
  finally
    FreeMem(PVerInfo, VerInfoSize);
  end;
end;

end.
