unit PreviewRenderer;

interface

uses Windows, Graphics, Classes, TypeDefinitions, MB3DFacade;

type
  TPreviewRenderer = class
  private
    CalcThreadStats: TCalcThreadStats;
    iActiveThreads: Integer;
    siLight5: array of TsiLight5;
    HeaderLightVals: TLightVals;
    aFSIstart: Integer;
    aFSIoffset: Integer;
    Converted: LongBool;
    bCalcStop: LongBool;
    FMB3DParamsFacade: TMB3DParamsFacade;
    FProgress: Double;
  protected
  public
    { Public-Deklarationen }
    constructor Create(const MB3DParamsFacade: TMB3DParamsFacade);
    destructor Destroy; override;
    procedure RenderPreview(var bmp: TBitmap; maxWidth, maxHeight: Integer);
    property Progress: Double read FProgress;
  end;

implementation

uses CustomFormulas, Math, Math3D, HeaderTrafos, DivUtils, Calc, Paint,
  ImageProcess, CalcHardShadow, CalcSR, DOF, SysUtils;

constructor TPreviewRenderer.Create(const MB3DParamsFacade: TMB3DParamsFacade);
begin
  FMB3DParamsFacade := MB3DParamsFacade.Clone;
end;

destructor TPreviewRenderer.Destroy;
begin
  SetLength(siLight5, 0);
  inherited Destroy;
end;

procedure TPreviewRenderer.RenderPreview(var bmp: TBitmap; maxWidth, maxHeight: Integer);
var
  d: Double;
  w, h, i, x, n, c: Integer;
  R: TRect;
  DoFrec: TDoFrec;
  PHeader: TPMandHeader11;

  procedure WaitForThreads(maxDeciSeconds: Integer);
  var
    i, t, n: Integer;
    RenderedRows, TotalRows: Integer;
  begin
    RenderedRows := 0;
    TotalRows := 0;
    n := maxDeciSeconds;
    if CalcThreadStats.iTotalThreadCount > 0 then begin
      repeat
        Delay(25);
        t := 0;
        for i := 1 to CalcThreadStats.iTotalThreadCount do begin
          if CalcThreadStats.CTrecords[i].isActive <> 0 then begin
            Inc(t);
            RenderedRows := RenderedRows + CalcThreadStats.CTrecords[i].iActualYpos;
          end
          else begin
            RenderedRows := RenderedRows + h;
          end;
          TotalRows := TotalRows + h;
        end;
        Dec(n);
      until (t = 0) or (n <= 0) or bCalcStop;
    end;
    FProgress := RenderedRows / TotalRows;
  end;

begin
    // TODO
    // disable/check for volumetric light
    FProgress:=0;
    PHeader := FMB3DParamsFacade.Core.PHeader;
    PHeader^.bCalc3D := 1;
    bCalcStop := False;
    d := MinCD(maxHeight / PHeader^.Height, maxWidth / PHeader^.Width);
    w := Round(PHeader^.Width * d);
    h := Max(2, Round(PHeader^.Height * d));
    bmp.PixelFormat := pf32Bit;
    bmp.Width  := w;
    bmp.Height := h;
    aFSIstart  := Integer(bmp.Scanline[0]);
    aFSIoffset := Integer(bmp.Scanline[1]) - aFSIstart;
    IniCFsFromHAddon(FMB3DParamsFacade.Core.PHAddOn, PHeader^.PHCustomF);
    PHeader^.Width  := w;
    PHeader^.Height := h;
    if not Converted then
    begin
      PHeader^.sDEstop := PHeader^.sDEstop * d;
      PHeader^.sDOFclipR := PHeader^.sDOFclipR * d;
      Converted := True;
    end;
    PHeader^.bSliceCalc := 2;
    PHeader^.bHScalculated := 0;
    PHeader^.bStereoMode := 0;
    MakeLightValsFromHeaderLight(PHeader, @HeaderLightVals, 1, PHeader^.bStereoMode);

    SetLength(siLight5, w * h);
    R := Rect(0, 0, w - 1, h - 1);
    CalcThreadStats.pLBcalcStop := @bCalcStop;
    CalcThreadStats.iProcessingType := 1;
    CalcThreadStats.iAllProcessingOptions := AllAutoProcessings(PHeader);
    if not CalcMandT(PHeader, @HeaderLightVals, @CalcThreadStats,
                 @siLight5[0], w * 18, aFSIstart, aFSIoffset, Rect(0, 0, w - 1, h - 1)) then Exit;
    iActiveThreads := CalcThreadStats.iTotalThreadCount;
    while (iActiveThreads > 0) and (not bCalcStop) do begin
      WaitForThreads(50);
      n := 0;
      for i := 1 to CalcThreadStats.iTotalThreadCount do
        if CalcThreadStats.CTrecords[i].isActive > 0 then Inc(n);
      if n = 0 then begin
        iActiveThreads := 0;
        CalcStepWidth(PHeader);
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
                      NormalsOnZbuf(PHeader, @siLight5[0]);
                    finally
                      iActiveThreads := 1; //to go on
                      CalcThreadStats.iTotalThreadCount := 0;
                    end;
                  end;
              4:  begin
                    CalcThreadStats.iProcessingType := 3;
                    if CalcHardShadowT(PHeader, @CalcThreadStats, @siLight5[0], 18 * w, @HeaderLightVals, False, R) then
                      iActiveThreads := CalcThreadStats.iTotalThreadCount;
                  end;
              8:  begin
                    CalcThreadStats.iProcessingType := 4;
                    if CalcAmbShadowT(PHeader, @siLight5[0], 18 * w, @CalcThreadStats, @ATrousWLAni, R) then
                      iActiveThreads := CalcThreadStats.iTotalThreadCount;
                  end;
             32:  begin
                    CalcThreadStats.iProcessingType := 6;
                    PaintM(PHeader, @HeaderLightVals, @siLight5[0], aFSIstart, aFSIoffset);
                    if CalcSRT(PHeader, @HeaderLightVals, @CalcThreadStats,
                               @siLight5[0], aFSIstart, aFSIoffset, R) then
                      iActiveThreads := CalcThreadStats.iTotalThreadCount;
                  end;
             64:  begin
                    CalcThreadStats.iProcessingType := 7;
                    try
                      if (CalcThreadStats.iAllProcessingOptions and 32) = 0 then
                        PaintM(PHeader, @HeaderLightVals, @siLight5[0], aFSIstart, aFSIoffset);
                      DoFrec.SL := @siLight5[0];
                      DoFrec.colSL := PCArdinal(aFSIstart);
                      DoFrec.MHeader := PHeader;
                      DoFrec.SLoffset := aFSIoffset;
                      DoFrec.Verbose := False;
                      for i := 0 to (PHeader^.bCalcDOFtype shr 1) and 3 do
                      begin
                        DoFrec.pass := i;
                        if ((PHeader^.bCalcDOFtype shr 3) and 1) = 1 then doDOF(DoFrec)
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
        PaintM(PHeader, @HeaderLightVals, @siLight5[0], aFSIstart, aFSIoffset);
      bmp.Modified := True;
    end;
end;

end.
