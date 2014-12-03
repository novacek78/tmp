unit uLib;

interface
  procedure SolveMathExpression(Sender: TObject);
  function ExpressionParser_Level1(expression: string): Double;
  function ExpressionParser_Level2(expression: string): Double;
  function ExpressionParser_Level3(expression: string): Double;




implementation

uses
  StdCtrls, System.SysUtils, uOtherObjects, uConfig, System.Math, Windows, uTranslate, uMain, System.StrUtils;


procedure SolveMathExpression(Sender: TObject);
var
  text: string;
begin
  try
    text := (Sender as TCustomEdit).Text;
    if text = '' then Exit;
    
    (Sender as TCustomEdit).Text := FloatToStr( ExpressionParser_Level2(text) );
  except
    on E:Exception do begin
      if Pos('not a valid floating point value', E.Message) > 1 then begin
        MessageBox(0, PChar(TransTxt('Incorrect numerical value')), PChar(TransTxt('Error')), MB_ICONERROR);
        (Sender as TCustomEdit).SetFocus;
      end else
        fMain.Log('ERROR IN uLib.SolveMathExpression() : ' + E.Message); // Log() vo fMain umoznuje aj remotelog na server
    end;
  end;
end;


function ExpressionParser_Level1(expression: string): Double;
var
  i,j: Integer;
  tmp1: string;
  tmp2: TMathOperationObject;
  op1, op2: Byte;
  arrCisla: array of Double;
  arrZnamienka: array of TMathOperationObject;
  vysledok: Double;
begin
  // parsuje matematicky vyraz
  // Level 1 = parsuje len zakladne operacie (+ - * /) cize napriklad vyrazy "3+8/2-2"

  // osetreny pripad, ak sa vyraz zacina zapornym cislom
  if (expression[1] = '-') then begin
    tmp1 := '-';
  end;

  // ideme znak po znaku vo vyraze a parsujeme ho
  for i := Length(tmp1)+1 to Length(expression) do begin
    if ((expression[i] = otPlus) OR (expression[i] = otMinus) OR (expression[i] = otKrat) OR (expression[i] = otDelene)) then begin

      SetLength(arrCisla, Length(arrCisla)+1 );
      SetLength(arrZnamienka, Length(arrZnamienka)+1 );

      arrCisla[ Length(arrCisla)-1 ] := StrToFloat(tmp1);
      tmp1 := '';

      tmp2 := TMathOperationObject.Create;
      tmp2.Typ := expression[i];
      tmp2.Op1 := Length(arrCisla);
      tmp2.Op2 := tmp2.Op1 + 1;
      arrZnamienka[ Length(arrZnamienka)-1 ] := tmp2;

    end else begin

      SetLength(tmp1, Length(tmp1)+1 );
      tmp1[ Length(tmp1) ] := expression[i];
    end;
  end;

  // este pridame do pola posledne cislo z retazca
  if tmp1 <> '' then begin
    SetLength(arrCisla, Length(arrCisla)+1 );
    arrCisla[ Length(arrCisla)-1 ] := StrToFloat(tmp1);
  end;

  if Length(arrZnamienka) = 0 then
    // ak sa nenasla ziadna operacia (+ - / *) tak jednoducho vratime to co prislo
    vysledok := StrToFloat(expression)

  else if ((Length(arrZnamienka) = 1) AND (Length(arrCisla) = 1)) then

    vysledok := arrCisla[0]

  else begin

    for i := 0 to High(arrZnamienka) do begin // prvy prechod vyhodnocuje KRAT a DELENE (tie maju vyssiu prioritu)
      op1 := arrZnamienka[i].Op1;
      op2 := arrZnamienka[i].Op2;

      if arrZnamienka[i].Typ = otKrat   then begin
        arrCisla[ op1-1 ] := arrCisla[op1-1] * arrCisla[op2-1];
        if i < High(arrZnamienka) then
          arrZnamienka[i+1].Op1 := op1; // kedze operand c.2 je uz neaktualny, prepiseme odkaz nanho v nasledujucom "znamienku"
      end;
      if arrZnamienka[i].Typ = otDelene then begin
        arrCisla[ op1-1 ] := arrCisla[op1-1] / arrCisla[op2-1];
        if i < High(arrZnamienka) then
          arrZnamienka[i+1].Op1 := op1; // kedze operand c.2 je uz neaktualny, prepiseme odkaz nanho v nasledujucom "znamienku"
      end;
    end;

    for i := 0 to High(arrZnamienka) do begin // druhy prechod vyhodnocuje PLUS a MINUS
      op1 := arrZnamienka[i].Op1;
      op2 := arrZnamienka[i].Op2;

      if arrZnamienka[i].Typ = otPlus  then begin
        arrCisla[ op1-1 ] := arrCisla[op1-1] + arrCisla[op2-1];
        if i < High(arrZnamienka) then
          for j := 0 to High(arrZnamienka) do
            arrZnamienka[j].Op1 := op1; // kedze operand c.2 je uz neaktualny, prepiseme odkaz nanho v nasledujucom "znamienku"
      end;
      if arrZnamienka[i].Typ = otMinus then begin
        arrCisla[ op1-1 ] := arrCisla[op1-1] - arrCisla[op2-1];
        if i < High(arrZnamienka) then
          for j := 0 to High(arrZnamienka) do
            arrZnamienka[j].Op1 := op1; // kedze operand c.2 je uz neaktualny, prepiseme odkaz nanho v nasledujucom "znamienku"
      end;
    end;

    vysledok := arrCisla[0];
  end;

  Result := System.Math.RoundTo(vysledok, -3);
end;

function ExpressionParser_Level2(expression: string): Double;
var
  i: Integer;
  vyrazZatvorky: string;
  zapisujSi: Boolean;
  vysledokZatvorky: string;
begin
  // parsuje matematicky vyraz
  // Level 2 = parsuje zatvorky a vyhodnocuje ich

  // kym sa vo vyraze nachadza otvaracia zatvorka, odstranuj ich postupne po jednej
  while Pos('(' ,expression) > 0 do begin
    zapisujSi := false;
    // odstranenie jednej zatvorky (ide sa od najvnutornejsich)
    for i := 1 to Length(expression) do begin

      // nasli sme zaciatok, zresetujeme buffer na '(' a nastavime priznak, ze zapisujeme odteraz vsetko co najdeme
      if expression[i] = '(' then begin
        vyrazZatvorky := '';
        zapisujSi := True;
        Continue;
      end;

      if expression[i] = ')' then begin
        vysledokZatvorky := '';
        if vyrazZatvorky <> '' then // kontrola prazdenj zatvorky
          vysledokZatvorky := FloatToStr( ExpressionParser_Level1( vyrazZatvorky )); // poslem do riesitela vyraz na vyriesenie
        expression := ReplaceStr(expression, '('+vyrazZatvorky+')', vysledokZatvorky);
        Break;
      end;

      if zapisujSi then
        vyrazZatvorky := vyrazZatvorky + expression[i];

    end;
  end;

  Result := ExpressionParser_Level1(expression);
end;

function ExpressionParser_Level3(expression: string): Double;
begin
  // parsuje matematicky vyraz
  // Level 3 = parsuje matematicke funkcie a vyhodnocuje ich (napr. sin() , cos() )
end;





end.
