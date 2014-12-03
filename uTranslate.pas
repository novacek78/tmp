unit uTranslate;


interface

  var
    najdene_ok: boolean;

  function TransObj(rodic: TObject): string;
  function TransTxt(txt: string): string;

implementation

uses Forms, StdCtrls, ComCtrls, Buttons, Menus, ExtCtrls, Dialogs, SysUtils, uMain, Classes, uDebug;


function TransObj(rodic: TObject): string;
var
  i, j, oldItmIndx: integer;
  obj: TComponent;
begin
  obj := (rodic as TComponent); // lebo pri deklaracii f-cie TransObj je este TComponent neznamy

  // prelozi sa aj zahlavie formy
  if (obj.ClassParent = TForm) AND ((obj as TForm).Tag <> -999) then
    (obj as TForm).Caption := TransTxt((obj as TForm).Caption);

  for i := 0 to obj.ComponentCount-1 do begin
    // ak je Tag komponenty = -999 znamena to, ze sa nebude prekladat
    if (obj.Components[i].Tag <> -999) then begin

      najdene_ok := true;

      // prejdeme vsetkymi detmi a prekladame ich
      if (obj.Components[i].ClassType = TLabel) then
        (obj.Components[i] as TLabel).Caption := TransTxt((obj.Components[i] as TLabel).Caption);

      if (obj.Components[i].ClassType = TCheckBox) then
        (obj.Components[i] as TCheckBox).Caption := TransTxt((obj.Components[i] as TCheckBox).Caption);

      if (obj.Components[i].ClassType = TRadioButton) then
        (obj.Components[i] as TRadioButton).Caption := TransTxt((obj.Components[i] as TRadioButton).Caption);

      if (obj.Components[i].ClassType = TButton) then
        (obj.Components[i] as TButton).Hint := TransTxt((obj.Components[i] as TButton).Hint);

      if (obj.Components[i].ClassType = TToolButton) then
        (obj.Components[i] as TToolButton).Hint := TransTxt((obj.Components[i] as TToolButton).Hint);

      if (obj.Components[i].ClassType = TSpeedButton) then begin
        (obj.Components[i] as TSpeedButton).Caption := TransTxt((obj.Components[i] as TSpeedButton).Caption);
        (obj.Components[i] as TSpeedButton).Hint := TransTxt((obj.Components[i] as TSpeedButton).Hint);
      end;

      if (obj.Components[i].ClassType = TBitBtn) then begin
        (obj.Components[i] as TBitBtn).Caption := TransTxt((obj.Components[i] as TBitBtn).Caption);
        (obj.Components[i] as TBitBtn).Hint := TransTxt((obj.Components[i] as TBitBtn).Hint);
      end;

      if (obj.Components[i].ClassType = TPanel) then
        (obj.Components[i] as TPanel).Caption := TransTxt((obj.Components[i] as TPanel).Caption);

      if (obj.Components[i].ClassType = TMenuItem) then
        if ((obj.Components[i] as TMenuItem).Caption <> '-') then
          (obj.Components[i] as TMenuItem).Caption := TransTxt((obj.Components[i] as TMenuItem).Caption);

      if (obj.Components[i].ClassType = TLabeledEdit) then
        (obj.Components[i] as TLabeledEdit).EditLabel.Caption := TransTxt((obj.Components[i] as TLabeledEdit).EditLabel.Caption);

      if (obj.Components[i].ClassType = TGroupBox) then
        (obj.Components[i] as TGroupBox).Caption := TransTxt((obj.Components[i] as TGroupBox).Caption);

      if (obj.Components[i].ClassType = TTabSheet) then
        (obj.Components[i] as TTabSheet).Caption := TransTxt((obj.Components[i] as TTabSheet).Caption);

      if (obj.Components[i].ClassType = TComboBox) then begin
        oldItmIndx := (obj.Components[i] as TComboBox).ItemIndex;
        for j := 0 to (obj.Components[i] as TComboBox).Items.Count-1 do begin
          (obj.Components[i] as TComboBox).Items[j] := TransTxt((obj.Components[i] as TComboBox).Items[j]);
        end;
        (obj.Components[i] as TComboBox).ItemIndex := oldItmIndx;
      end;

      if (obj.Components[i].ClassType = TSaveDialog) then begin
        (obj.Components[i] as TSaveDialog).Title := TransTxt((obj.Components[i] as TSaveDialog).Title);
        (obj.Components[i] as TSaveDialog).Filter := TransTxt((obj.Components[i] as TSaveDialog).Filter);
      end;

      if (obj.Components[i].ClassType = TOpenDialog) then begin
        (obj.Components[i] as TOpenDialog).Title := TransTxt((obj.Components[i] as TOpenDialog).Title);
        (obj.Components[i] as TOpenDialog).Filter := TransTxt((obj.Components[i] as TOpenDialog).Filter);
      end;

      if (obj.Components[i].ClassType = TShape) then
        (obj.Components[i] as TShape).Hint := TransTxt((obj.Components[i] as TShape).Hint);

    if not najdene_ok then begin
      fMain.Log('     '+obj.Name+'.'+obj.Components[i].Name+' ('+obj.Components[i].ClassName+')');
      fMain.Log('');
    end;

    end; // ak nie je Tag = -999
  end; // for
end;


function TransTxt(txt: string): string;
var
  line1, line2, code: string;
  najdeny1, najdeny2: boolean;

  ReaderOriginal, ReaderPreklad: TStreamReader;
begin
  if (txt = '') then begin
    result := '';
    Exit; // napr. nie vsetky buttony maju Hint a pod. takze casto je dotaz na preklad s prazdnym textom
  end;

  ReaderOriginal := TStreamReader.Create(ExtractFilePath(Application.exename) + 'transsource.dat', TEncoding.Unicode);
  ReaderPreklad  := TStreamReader.Create(ExtractFilePath(Application.exename) + 'trans_'+Language+'.txt', TEncoding.Unicode);
  najdeny1 := false;
  najdeny2 := false;

  code := '0000';
  najdene_ok := false;

  // prechadzame zdrojovy subor a hladame dany vyraz
  while (not ReaderOriginal.EndOfStream) AND (not najdeny1) do begin
    line1 := ReaderOriginal.ReadLine;
    // ak sme nasli hladany text (v zdrojovom anglickom subore)
    if (Pos('#', line1) = 0) AND (txt = Copy(line1, 6, 9999)) then begin
      najdeny1 := true;
      code := Copy(line1, 0, 4);
      // vyhladame prelozeny ekvivalent
      while (not ReaderPreklad.EndOfStream) AND (not najdeny2) do begin
        line2 := ReaderPreklad.ReadLine;
        // ak sme preklad nasli (podla ciselneho kodu)
        if ((Pos(code, line2) > 0) AND (Copy(line2, 6, 9999) <> '')) then begin
          najdeny2 := true;
          najdene_ok := true;
          result := Copy(line2, 6, 9999);
        end;
      end;
    end;
  end;

  // ak sa preklad nenasiel, vrati povodny text aj s kodom
  if (not najdeny2) then begin
    result := code+':'+txt;
    fMain.Log(result);
  end;

  // ak prisiel na preklad prazdny string, prazdny aj vrati
  if (txt = '') then
    result := '';

  ReaderOriginal.Free;
  ReaderPreklad.Free;
end;

end.
