unit RegisterM3Pgraphic;   // Just enough to make the OpenPictureDialog work with m3p files

interface

uses Windows, Graphics, Classes, TypeDefinitions;

type
  TM3Pgraphic = Class(TGraphic)
  private
    CalcThreadStats: TCalcThreadStats;
    HybridCustoms: array[0..MAX_FORMULA_COUNT - 1] of TCustomFormula;
    iActiveThreads: Integer;
    siLight5: array of TsiLight5;
    HeaderLightVals: TLightVals;
    aFSIstart: Integer;
    aFSIoffset: Integer;
    Converted: LongBool;
    bCalcStop: LongBool;
    procedure RenderPreviewBMP(var bmp: TBitmap; maxWidth, maxHeight: Integer);
  protected
  public
    { Public-Deklarationen }
    Header: TMandHeader11;
    HAddOn: THeaderCustomAddon;
    constructor Create; override;
    destructor Destroy; override;
    procedure LoadFromStream(Stream: TStream); override;
  end;

implementation

uses CustomFormulas, Math, Math3D, HeaderTrafos, DivUtils, Calc, Paint,
  ImageProcess, CalcHardShadow, CalcSR, DOF;

constructor TM3Pgraphic.Create;
var i: Integer;
begin
    inherited Create;
    Header.PCFAddon := @HAddOn;
    for i := 0 to MAX_FORMULA_COUNT - 1 do Header.PHCustomF[i] := @HybridCustoms[i];
    for i := 0 to MAX_FORMULA_COUNT - 1 do IniCustomF(@HybridCustoms[i]);
end;

destructor TM3Pgraphic.Destroy;
var i: Integer;
begin
    SetLength(siLight5, 0);
    for i := 0 to MAX_FORMULA_COUNT - 1 do FreeCF(@HybridCustoms[i]);
    inherited Destroy;
end;

procedure TM3Pgraphic.LoadFromStream(Stream: TStream);
begin


end;

procedure TM3Pgraphic.RenderPreviewBMP(var bmp: TBitmap; maxWidth, maxHeight: Integer); //for m3p+m3i graphics format preview
var d: Double;
    w, h, i, x: Integer;
    R: TRect;
    DoFrec: TDoFrec;
procedure WaitForThreads(maxDeciSeconds: Integer);
var i, t, n: Integer;
begin
    n := maxDeciSeconds;
    if CalcThreadStats.iTotalThreadCount > 0 then
    repeat
      Delay(100);
      t := 0;
      for i := 1 to CalcThreadStats.iTotalThreadCount do
        if CalcThreadStats.CTrecords[i].isActive <> 0 then Inc(t);
      Dec(n);
    until (t = 0) or (n <= 0) or bCalcStop;
end;    
begin
    bCalcStop := False;
    d := MinCD(maxHeight / Header.Height, maxWidth / Header.Width);
    w := Round(Header.Width * d);
    h := Max(2, Round(Header.Height * d));
    bmp.PixelFormat := pf32Bit;
    bmp.Width  := w;
    bmp.Height := h;
    aFSIstart  := Integer(bmp.Scanline[0]);
    aFSIoffset := Integer(bmp.Scanline[1]) - aFSIstart;
    IniCFsFromHAddon(@HAddOn, Header.PHCustomF);
    Header.Width  := w;
    Header.Height := h;
 //   Header.sFOVXoff := 0.5 * w;
    if not Converted then
    begin
      Header.sDEstop := Header.sDEstop * d;
      Header.sDOFclipR := Header.sDOFclipR * d;
      Converted := True;
    end;
    Header.bSliceCalc := 2;
    Header.bHScalculated := 0;
    Header.bStereoMode := 0;
    MakeLightValsFromHeaderLight(@Header, @HeaderLightVals, 1, Header.bStereoMode);

    SetLength(siLight5, w * h);
    R := Rect(0, 0, w - 1, h - 1);
    CalcThreadStats.pLBcalcStop := @bCalcStop;
    CalcThreadStats.iProcessingType := 1;
    CalcThreadStats.iAllProcessingOptions := AllAutoProcessings(@Header);
    if not CalcMandT(@Header, @HeaderLightVals, @CalcThreadStats,
                 @siLight5[0], w * 18, aFSIstart, aFSIoffset, Rect(0, 0, w - 1, h - 1)) then Exit;
    iActiveThreads := CalcThreadStats.iTotalThreadCount;
    while (not bCalcStop) and (iActiveThreads > 0)do
    begin
      WaitForThreads(50);
      x := 1 shl CalcThreadStats.iProcessingType;
      while (x < 256) and ((CalcThreadStats.iAllProcessingOptions and x) = 0) do x := x shl 1;
      if (CalcThreadStats.iAllProcessingOptions and x) > 0 then   //next processing step
      begin
        case x of        // 2: NsOnZBuf, 4: hard shadow postcalc, 8: AO, 16: free, 32: reflections, 64: DOF
          2:  begin
              CalcThreadStats.iProcessingType := 2;
              try
                NormalsOnZbuf(@Header, @siLight5[0]);
              finally
                iActiveThreads := 1; //to go on
                CalcThreadStats.iTotalThreadCount := 0;
              end;
            end;
        4:  begin
              CalcThreadStats.iProcessingType := 3;
              if CalcHardShadowT(@Header, @CalcThreadStats, @siLight5[0], 18 * w, @HeaderLightVals, False, R) then
                iActiveThreads := CalcThreadStats.iTotalThreadCount;
            end;
        8:  begin
              CalcThreadStats.iProcessingType := 4;
              if CalcAmbShadowT(@Header, @siLight5[0], 18 * w, @CalcThreadStats, @ATrousWLAni, R) then
                iActiveThreads := CalcThreadStats.iTotalThreadCount;
            end;
       32:  begin
              CalcThreadStats.iProcessingType := 6;
              PaintM(@Header, @HeaderLightVals, @siLight5[0], aFSIstart, aFSIoffset);
              if CalcSRT(@Header, @HeaderLightVals, @CalcThreadStats,
                         @siLight5[0], aFSIstart, aFSIoffset, R) then
                iActiveThreads := CalcThreadStats.iTotalThreadCount;
            end;
       64:  begin
              CalcThreadStats.iProcessingType := 7;
              try
                if (CalcThreadStats.iAllProcessingOptions and 32) = 0 then
                  PaintM(@Header, @HeaderLightVals, @siLight5[0], aFSIstart, aFSIoffset);
                DoFrec.SL := @siLight5[0];
                DoFrec.colSL := PCArdinal(aFSIstart);
                DoFrec.MHeader := @Header;
                DoFrec.SLoffset := aFSIoffset;
                DoFrec.Verbose := False;
                for i := 0 to (Header.bCalcDOFtype shr 1) and 3 do
                begin
                  DoFrec.pass := i;
                  if ((Header.bCalcDOFtype shr 3) and 1) = 1 then doDOF(DoFrec)
                                                             else doDOFsort(DoFrec);
                end;
              except end;
            end;
        end;    
      end;
    end;
    if not bCalcStop then
    begin
      if CalcThreadStats.iProcessingType < 6 then
        PaintM(@Header, @HeaderLightVals, @siLight5[0], aFSIstart, aFSIoffset);
      bmp.Modified := True;
    end;

end;

initialization
  TPicture.RegisterFileFormat('m3p', 'Mandelbulb3D parameters', TM3Pgraphic);

finalization
  TPicture.UnregisterGraphicClass(TM3Pgraphic);

end.
