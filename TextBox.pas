unit TextBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TFTextBox = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FTextBox: TFTextBox;

implementation

uses Mand, FileHandling, LightAdjust, Math;

{$R *.dfm}

procedure TFTextBox.Button1Click(Sender: TObject);
begin
    Visible := False;
end;

function ValidLastChar(s: String): LongBool;
var i: Integer;
begin
    Result := False;
    for i := Length(s) downto 1 do
    begin
      if Ord(s[i]) > 32 then
      begin
        if s[i] = '}' then Result := True;
        Break;
      end;
    end;
end;

procedure TFTextBox.Memo1Change(Sender: TObject);
var s: String;
begin
    if (Memo1.Lines.Count > 5) and ValidLastChar(Memo1.Lines.Text) and
      GetHeaderFromText(Memo1.Lines.Text, Mand3DForm.MHeader, s) then
    begin
      Mand3DForm.TextParsLoadSuccess;
      Mand3DForm.Caption := s;
      FTextBox.Visible := False;
    end
end;

end.

