unit uBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, Buttons, ExtCtrls;

type
  TfBrowser = class(TForm)
    WebBrowser1: TWebBrowser;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fBrowser: TfBrowser;

implementation

{$R *.dfm}

procedure TfBrowser.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WebBrowser1.Navigate('about:blank');
end;

end.
