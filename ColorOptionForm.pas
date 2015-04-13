unit ColorOptionForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFColorOptions = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    iOption: Integer;
  end;

var
  FColorOptions: TFColorOptions;

implementation

{$R *.dfm}

procedure TFColorOptions.Button1Click(Sender: TObject);
begin
    ModalResult := (Sender as TButton).Tag;
end;

procedure TFColorOptions.FormCreate(Sender: TObject);
var i: Integer;
    can: TCanvas;
begin
    for i := 1 to 6 do
    begin
      can := (FindComponent('Image' + IntToStr(i)) as TImage).Canvas;
      can.Brush.Color := clBtnFace;
      can.FillRect(can.ClipRect);
      can.Brush.Color := 0;
      can.FillRect(Rect(1, 0, 63, 13));
    end;
end;

end.
