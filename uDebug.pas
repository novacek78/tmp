unit uDebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, uMyTypes, Winapi.ShellAPI, Vcl.ExtCtrls;

type
  TfDebug = class(TForm)
    memo: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    img1: TImage;
    btnPolygon: TButton;
    procedure LogMessage(s: string; showform: boolean = false); overload;
    procedure memoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPolygonClick(Sender: TObject);
  private
    { Private declarations }
  public
  end;

const
 SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
 SECURITY_BUILTIN_DOMAIN_RID = $00000020;
 DOMAIN_ALIAS_RID_ADMINS     = $00000220;
 DOMAIN_ALIAS_RID_USERS      = $00000221;
 DOMAIN_ALIAS_RID_GUESTS     = $00000222;
 DOMAIN_ALIAS_RID_POWER_USERS= $00000223;

 function CheckTokenMembership(TokenHandle: THandle; SidToCheck: PSID; var IsMember: BOOL): BOOL; stdcall; external advapi32;

var
  fDebug: TfDebug;

implementation

uses uMain, uFeaCombo, uObjectFeature, uObjectPanel, uObjectDXFEntity,
  uObjectDXFDrawing, uConfig, uObjectFeaturePolyLine, polygonclipper;

{$R *.dfm}

procedure DrawPolygons(polys: TPolygons; c1,c2: TColor);
var
  i, j: Integer;
begin
  with fDebug.img1.Canvas do begin
    Pen.Color := c1;

    for j := 0 to High(polys) do begin
      MoveTo(polys[j][0].X, polys[j][0].Y);
      for i := 1 to Length(polys[j])-1 do begin
        LineTo(polys[j][i].X, polys[j][i].Y);
      end;
      LineTo(polys[j][0].X, polys[j][0].Y);
    end;
  end;
end;

function  UserInGroup(Group: DWORD): Boolean; // aby sme zistili ake ma user prava
var
  pIdentifierAuthority :TSIDIdentifierAuthority;
  pSid : Windows.PSID;
  IsMember    : BOOL;
begin
  pIdentifierAuthority := SECURITY_NT_AUTHORITY;
  Result := AllocateAndInitializeSid(pIdentifierAuthority,2, SECURITY_BUILTIN_DOMAIN_RID, Group, 0, 0, 0, 0, 0, 0, pSid);
  try
    if Result then
      if not CheckTokenMembership(0, pSid, IsMember) then //passing 0 means which the function will be use the token of the calling thread.
         Result:= False
      else
         Result:=IsMember;
  finally
     FreeSid(pSid);
  end;
end;




procedure TfDebug.FormCreate(Sender: TObject);
begin
  Left := 0;
  Top  := 0;

  fMain.Log(Format('QuickPanel v%d.%d.%d started at ', [cfg_swVersion1, cfg_swVersion2, cfg_swVersion3]) + DateTimeToStr( Now() ));
  fMain.Log( '-----------------------------------------------------------------------' );
  fMain.Log( TOSVersion.ToString );
  fMain.Log(Format('Current user is Admin        %s',[BoolToStr(UserInGroup(DOMAIN_ALIAS_RID_ADMINS),True)]));
  fMain.Log(Format('Current user is Guest        %s',[BoolToStr(UserInGroup(DOMAIN_ALIAS_RID_GUESTS),True)]));
  fMain.Log(Format('Current user is Power User   %s',[BoolToStr(UserInGroup(DOMAIN_ALIAS_RID_POWER_USERS),True)]));
  fMain.Log( '-----------------------------------------------------------------------' );
end;

procedure TfDebug.LogMessage(s: string; showform: boolean = false);
begin
  memo.Lines.Add(s);
  if showform then Show;
end;

procedure TfDebug.memoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=27 then Close;
end;

procedure TfDebug.btnPolygonClick(Sender: TObject);
var
  i: Integer;
  polys, solu: TPolygons;
begin
  SetLength(polys, 2);
  SetLength(solu, 2);

  SetLength(polys[0], 5);
  SetLength(polys[1], 4);

  polys[0][0] := IntPoint(20,20);
  polys[0][1] := IntPoint(50,30);
  polys[0][2] := IntPoint(50,190);
  polys[0][3] := IntPoint(30,150);
  polys[0][4] := IntPoint(10,190);

  polys[1][0] := IntPoint(28,65);
  polys[1][1] := IntPoint(40,65);
  polys[1][2] := IntPoint(40,35);
  polys[1][3] := IntPoint(8,35);

  DrawPolygons(polys, clBlack, clBlue);

  i := -3;

  solu := OffsetPolygons(polys, i, jtRound);
  DrawPolygons(solu, clRed, clRed);
  solu := OffsetPolygons(polys, 2*i, jtRound);
  DrawPolygons(solu, clRed, clRed);
  solu := OffsetPolygons(polys, 3*i, jtRound);
  DrawPolygons(solu, clRed, clRed);

  for i := 0 to Length(solu[0])-1 do
    memo.Lines.Add( IntToStr(solu[0][i].X) + ',' + IntToStr(solu[0][i].Y) );
end;

procedure TfDebug.Button1Click(Sender: TObject);
begin
  _PNL.GetFullInfo;
end;

procedure TfDebug.Button2Click(Sender: TObject);
begin
  fFeaCombo.GetRAMComboInfo;
end;

procedure TfDebug.Button3Click(Sender: TObject);
begin
  memo.Lines.Clear;
end;

procedure TfDebug.Button4Click(Sender: TObject);
var
  i: integer;
begin
  fMain.Log('========== UNDO LIST ==============');
  for i := 0 to High(_PNL.undolist2) do begin
    if _pnl.UndoList2[i].step_type <> '' then begin
      fMain.log('#' +
          inttostr(_pnl.undolist2[i].step_ID) +' '+
          _PNL.undolist2[i].step_type + ' : stepID=' +
          inttostr(_pnl.undolist2[i].step_ID) + ', objClass=' +
          _pnl.undolist2[i].obj.ClassName
      );
      if (_pnl.undolist2[i].step_subject='FEA') then
        fMain.log('         pos:'+mypointtostr((_pnl.undolist2[i].obj as tfeatureobject).Poloha) +
            ' ID:'+inttostr( (_pnl.undolist2[i].obj as TFeatureObject).ID )
        );
      if (_pnl.undolist2[i].step_subject='PNL') then
        fMain.log('         size:'+floattostr((_pnl.undolist2[i].obj as tpanelobject).Sirka) +
            ' x '+floattostr( (_pnl.undolist2[i].obj as TpanelObject).Vyska )
        );
    end;
  end;

  fMain.log('');

end;

procedure TfDebug.Button5Click(Sender: TObject);
begin
  ShellExecute( Handle, 'Open', 'c:\xampp\htdocs\qp\www\QP_binary-Translator\Win32\Debug\qp_translator.exe', '', '', sw_ShowNormal );
end;

end.
