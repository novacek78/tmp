unit uToolMirror;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfToolMirror = class(TForm)
    pnl1: TPanel;
    btnOK: TSpeedButton;
    btnSad: TSpeedButton;
    pnl2: TPanel;
    cbKeepOriginals: TCheckBox;
    lbNotice: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GuideLineSelected;
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSadClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fToolMirror: TfToolMirror;
  closestGuideline, selectedGuideline: Integer;

implementation

{$R *.dfm}

uses uMain, uPanelSett, uDebug, uObjectFeature, uOtherObjects, uConfig;


procedure TfToolMirror.FormCreate(Sender: TObject);
begin
  fMain.imgList_common.GetBitmap(0, btnSad.Glyph);
  btnOK.Glyph := fPanelSett.btnSave.Glyph;
end;

procedure TfToolMirror.FormActivate(Sender: TObject);
begin
  uMain.stavTahania := dsVyberaSaGuideline;
  closestGuideline  := -1;
  selectedGuideline := -1;
end;

procedure TfToolMirror.FormShow(Sender: TObject);
begin
  btnOK.Enabled := false;
end;

procedure TfToolMirror.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  uMain.stavTahania := dsNetahaSa;
  _PNL.DeselectAllGuidelines;
  _PNL.Draw;
end;



procedure TfToolMirror.btnSadClick(Sender: TObject);
begin
  fMain.ShowWish('Tools-Mirror');
end;

procedure TfToolMirror.GuideLineSelected;
var
  i: Integer;
  feaOrig, feaNew: TFeatureObject;
  guide: TGuideObject;
  distance: Double;
begin
  if (closestGuideline > -1) then begin
    btnOK.Enabled := True;
    selectedGuideline := closestGuideline;

    _PNL.PrepareUndoStep;

    for i := 0 to _PNL.Features.Count-1 do begin
      if _PNL.Features[i].Selected then begin

        feaOrig := _PNL.Features[i];
        feaNew  := _PNL.GetFeatureByID( _PNL.AddFeature(feaOrig.Typ) );
        feaNew.CopyFrom(feaOrig);

        guide := _PNL.GetGuideLineById(selectedGuideline);

        if (guide.Typ = 'V') then begin
          distance := guide.Param1 - feaOrig.X;
          feaNew.X := feaNew.X + (2*distance);
          // pri grav ciarach a drazkach treba zrkadlit aj ich koncovy bod
          if (feaOrig.Typ = ftLine2Grav) or (feaOrig.Typ = ftGrooveLin) then
            feaNew.Rozmer1 := -feaNew.Rozmer1;
        end;

        if (guide.Typ = 'H') then begin
          distance := guide.Param1 - feaOrig.Y;
          feaNew.Y := feaNew.Y + (2*distance);
          // pri grav ciarach a drazkach treba zrkadlit aj ich koncovy bod
          if (feaOrig.Typ = ftLine2Grav) OR (feaOrig.Typ = ftGrooveLin) then
            feaNew.Rozmer2 := -feaNew.Rozmer2;
        end;

        feaNew.Selected := false;

        _PNL.CreateUndoStep('CRT','FEA', feaNew.ID);

      end;
    end;

    if not cbKeepOriginals.Checked then begin
      _PNL.DelSelected;
    end;
    
    _PNL.Draw;

    btnOK.Click;
  end;
end;

procedure TfToolMirror.btnOKClick(Sender: TObject);
begin
  Close;
end;

end.
