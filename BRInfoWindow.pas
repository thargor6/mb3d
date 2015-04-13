unit BRInfoWindow;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  TBRInfoForm = class(TForm)
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  BRInfoForm: TBRInfoForm;

implementation

{$R *.dfm}

procedure TBRInfoForm.FormShow(Sender: TObject);
begin
    ProgressBar1.Position := 0;
end;

end.
