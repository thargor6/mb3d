unit M3DfractalClass;

interface

uses Windows, Classes, Forms, Messages, TypeDefinitions;

type

  TM3Dfractal = class(TScrollBox)

  protected
    procedure WmThreadReady(var Msg: TMessage); message WM_ThreadReady;
  public
    MHeader: TMandHeader10;
    HAddOn: THeaderCustomAddon;
    MCalcThreadStats: TCalcThreadStats;
    HybridCustoms: array[0..5] of TCustomFormula;  //of TFormulaClass;
  private
    iActiveThreads: Integer;
    iActivePaintThreads: Integer;
    siLight5: array of TsiLight5;
    HeaderLightVals: TLightVals;  //for painting

  end;

implementation

procedure TM3Dfractal.WmThreadReady(var Msg: TMessage);
var sr, er: Integer;
begin
    if Msg.LParam = 222 then
    begin
   //   sr := Msg.WParam and $FFFF;    //dec PRowThreads?
   //   er := Msg.WParam shr 16;
   //   if er > MHeader.Height - ImageScale then er := MHeader.Height - ImageScale;
  //    if SizeOK(False) then
   //     UpdateScaledImage(sr div ImageScale, er div ImageScale);
    end
    else if Msg.LParam = 3 then
    begin
      Dec(iActivePaintThreads);
      if iActivePaintThreads = 0 then ;//Timer8.Interval := 5;
    end else begin
      Dec(iActiveThreads);
      if iActiveThreads = 0 then ;//Timer4.Interval := 5;
    end;
end;


end.
