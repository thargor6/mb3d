unit MB3DPreviewRenderer;

interface

uses Windows, Graphics, Classes, TypeDefinitions, MB3DHeaderFacade;

type
  TMB3DPreviewRenderer = class
  private
    CalcThreadStats: TCalcThreadStats;
    iActiveThreads: Integer;
    siLight5: array of TsiLight5;
    HeaderLightVals: TLightVals;
    aFSIstart: Integer;
    aFSIoffset: Integer;
    Converted: LongBool;
    bCalcStop: LongBool;
    FMB3DHeaderFacade: TMB3DHeaderFacade;
  protected
  public
    { Public-Deklarationen }
    constructor Create(const MB3DHeaderFacade: TMB3DHeaderFacade);
    destructor Destroy; override;
    procedure RenderPreview(var bmp: TBitmap; maxWidth, maxHeight: Integer);
  end;


implementation

uses CustomFormulas, Math, Math3D, HeaderTrafos, DivUtils, Calc, Paint,
  ImageProcess, CalcHardShadow, CalcSR, DOF;

constructor TMB3DPreviewRenderer.Create(const MB3DHeaderFacade: TMB3DHeaderFacade);
begin
  FMB3DHeaderFacade := MB3DHeaderFacade;
end;

destructor TMB3DPreviewRenderer.Destroy;
begin
  SetLength(siLight5, 0);
  inherited Destroy;
end;

procedure TMB3DPreviewRenderer.RenderPreview(var bmp: TBitmap; maxWidth, maxHeight: Integer);
var
  d: Double;
  w, h, i, x, n, c: Integer;
  R: TRect;
  DoFrec: TDoFrec;
  Header: TMandHeader11;
  HAddOn: THeaderCustomAddon;

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
    // TODO
    // disable/check for volumetric light

    Header := FMB3DHeaderFacade.Header;
    Header.bCalc3D := 1;
    HAddOn := FMB3DHeaderFacade.HAddOn;
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
    while (iActiveThreads > 0) and (not bCalcStop) do begin
      WaitForThreads(50);
      n := 0;
      for i := 1 to CalcThreadStats.iTotalThreadCount do
        if CalcThreadStats.CTrecords[i].isActive > 0 then Inc(n);
      if n = 0 then begin
        iActiveThreads := 0;
        CalcStepWidth(@Header);
        c := CalcThreadStats.iProcessingType;
        if not bCalcStop then begin
          x := 1 shl c;
          while (x < 256) and ((CalcThreadStats.iAllProcessingOptions and x) = 0) do x := x shl 1;

          if (CalcThreadStats.iAllProcessingOptions and x) > 0 then begin  //next processing step
            CalcThreadStats.pLBcalcStop := @bCalcStop;
    //        CalcThreadStats.pMessageHwnd := Self.Handle;
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
      end
    end;
    if not bCalcStop then begin
      if CalcThreadStats.iProcessingType < 6 then
        PaintM(@Header, @HeaderLightVals, @siLight5[0], aFSIstart, aFSIoffset);
      bmp.Modified := True;
    end;
end;

end.
