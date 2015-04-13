unit uMapCalcWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, TypeDefinitions,
  Vcl.ExtCtrls, Math3D;

type
  TMapCalcWindow = class(TForm)
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    VLMThreadStats: TCalcThreadStats;
    bStopDone: LongBool;
    LastUpdate, GTC: Cardinal;
  public
    { Public declarations }
    pHeader: TPMandHeader11;
    PLightVals: TPLightVals;
    pMap: TPLightMap;
  end;

var
  MapCalcWindow: TMapCalcWindow;

implementation

uses DivUtils, HeaderTrafos, Math, Calc, Maps, Mand;

{$R *.dfm}

procedure TMapCalcWindow.Button1Click(Sender: TObject);
begin
    MCalcStop := True;
end;

procedure TMapCalcWindow.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    if not bStopDone then MCalcStop := True;
end;

procedure TMapCalcWindow.FormShow(Sender: TObject);
begin
    bStopDone := False;
    ProgressBar1.Position := 0;
    MCalcStop := not MakeVolumicLightMapThreads(pHeader, PLightVals, @VLMThreadStats);
    ProgressBar1.Max := VolumeLightMap.CubeSize;
    Timer1.Enabled := True;
    LastUpdate := GetTickCount;
end;

procedure TMapCalcWindow.Timer1Timer(Sender: TObject);
var i, ym, ia: Integer;
begin
    ym := 9999999;
    ia := 0;
    for i := 1 to VLMThreadStats.iTotalThreadCount do
    begin
      if VLMThreadStats.CTrecords[i].isActive <> 0 then Inc(ia);
      ym := Min(ym, VLMThreadStats.CTrecords[i].iActualYpos);
    end;
    if ia = 0 then
    begin
      Timer1.Enabled := False;
      bStopDone := True;
      Close;
    end
    else
    begin
      ProgressBar1.Position := ym;
      GTC := GetTickCount;
      if ym < 5 then Label1.Caption :=  'togo: ...' else
      if GTC > LastUpdate + 3000 then
      begin
        LastUpdate := GTC;
        Label1.Caption :=  'togo: ' +
          dDateTimeToStr((ProgressBar1.Max - ym) * (GTC - VLMThreadStats.cCalcTime)
                         / MSecsPerDay / ym);
      end;
    end;
end;

end.
