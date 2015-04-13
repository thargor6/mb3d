unit CalcMonteCarlo;

interface

uses
  Classes, Math3D, TypeDefinitions, Windows, ImageProcess;

type
  HaltonRec = packed record
    HRx, HRy: Word;        //     0..65535    rect distribution
    HDx, HDy: Word;        //     0..65535         -32767..32767    disc distribution -> after shifting
  end;
  PHaltonRec = ^HaltonRec;
  TMCCalcThread = class(TThread)
  private
    { Private-Deklarationen }
    seed: Integer;
    TransDiConst: Single;
    sAbsorption: Single;
    bCalcReflects: LongBool;
    bCalcTrans: LongBool;
    bCalcTransR: LongBool;
    bTransFlipInside: LongBool;
    bOnlyDIFS: LongBool;
    bDoDOF: LongBool;
    bSkipNonZeroC: LongBool;
    bRit1: LongBool;
    bSecantSearch: LongBool;
    bDiffReflectsBigEnough: LongBool;
    bNormSDamount: LongBool;
    bGaussAA: LongBool;
    sDOFaperture: Single;
    sDOFZsharp: Single;
    SRLightAmount: Single;
    sDynFog: Single;
    sLightScatteringMul: Single;
    HSmaxLmul: Single;
    AMBmaxL: Single;
    FOVy1d: Single;
    iDiffReflects: Integer;
    iBokehNr: Integer;
    iActRayNr: Integer;
    HaltonX, HaltonY: Single;
    HaltonDiscX, HaltonDiscY: Single;
    HaltonShiftX, HaltonShiftY: Single;
    pStartPos: TPVec3D;
    PMCrecord: TPMCrecord;
    TotalLight: TSVec;
//    BGMapFuncDirect: TGetLightMapPixel;
  //  BGMapFuncSphere: TGetLightMapPixelSphere;
    smatrix: TSMatrix3;
    Normals, VPosStart: TVec3D;
    HS6: array[0..5] of TSVec; //Single; //smooth HS amount 0..1  as color for transp
    tmpObjCol: TLightSD;
    Iteration3Dext: TIteration3Dext;
    procedure CalculateVgradsFOV(x, y: Single);
    procedure CalculateNormals(var NN: Single; raydir: TPVec3D);
    procedure CalculateNormalsOnSmoothIt(var NN: Single; raydir: TPVec3D);
    procedure doBinSearchIt(var ZZ: Double; VgradsFOVit: TPVec3D);
    procedure minLengthToCutPlane(var dLength: Double; dLimit: Double; vPos: TPPos3D; Vec: TPVec3D);
    function CalcColor(PsiLight: TPsiLight5; zPos: Single): TLightSD;
    procedure CalcRay(ZZ: Double; VgradsFOVit: TVec3D; tAbsorb: TSVec; Rit: Integer);
    function CalcBGLight(Vec: TPVec3D; const UseAmbLight, bNNipolBG: LongBool): TSVec;
    function CalcVisLights(VPos: TSVec; ViewVec: TPVec3D; PsiLight: TPsiLight5; var BGdecrease, DepthDec: Single{; bIsBG: LongBool}): TSVec;
    function GetRand: Double;
    function GenSphereSVecOm: TSVec;
    function CalcN(x, y: Integer; pmc: TPMCrecord): Integer;
    function AddLight(camPos, vPos: TSVec): TSVec;
  //  procedure CalcPosLightShapeMC(var flux, transp: Single; LightNr: Integer);
    procedure DoDOF;
    function CalcPhongLight(siLight: TPsiLight5;  ReflectVec: TPVec3D): TLightSD;
    function CalcPhongLightNoHS(siLight: TPsiLight5; ReflectVec: TPVec3D): TLightSD;
    procedure DoDynFog(var actDE: Double; var StepCount: Single; const RSFmul, LastStepWidth: Single);
    procedure CalcHSMC;
  //  function Calc1HSMC(const nr: Integer): Single;
    procedure CalcNormalsOnCutMC(CutPlane: Integer);
    procedure VaryVecSphere(Vec: TPVec3D);
    procedure CalcBokehMC(var xx, yy: Single);
    procedure GetSubPixelShift(var xx, yy: Single);
  public
    { Public-Deklarationen }
    MaxAmbDepth: Integer;
    MaxSpecDepth: Integer;
    AvrgRCount: Single;
    AvrgVari: Double;         //for estimating the current raycount to calculate for each pixel
    LVals: TLightVals;
    MCTparas: TMCTparameter;
  protected
    procedure Execute; override;
  end;
function CalcBokeh(const xx, yy: Single; BokehNr: Integer): Single;
function CalcMCT(Header: TPMandHeader10; PLightVals: TPLightVals;
                 PsiLight5: TPsiLight5; PCTS: TPCalcThreadStats;
                 AvrgSqrNoise: Double; sAvrgRCount: Single;
                 bSkipNonZeroCounts: LongBool): Boolean;
procedure PreComputeHaltonSequence;
var
  HaltonSequence: array[0..65535] of HaltonRec;
  SinCosP5: array[0..5] of TSPoint;
  SinCosP7: array[0..7] of TSPoint;
  MCVMapcalculated: LongBool;

implementation

uses Mand, Math, DivUtils, formulas, CustomFormulas, LightAdjust, Calc,
  HeaderTrafos, PaintThread, Maps, MonteCarloForm;

procedure PreComputeSinCos;
var i: Integer;
begin
    for i := 0 to 5 do SinCosS(i * PiM2 * 0.2, SinCosP5[i][0], SinCosP5[i][1]);
    for i := 0 to 7 do SinCosS(i * PiM2 / 7, SinCosP7[i][0], SinCosP7[i][1]);
end;

function halton(index, base: Integer): Double;
var f, d: Double;
    i: Integer;
begin
    Result := 0;
    f := 1 / base;
    d := f;
    i := index;
    while i > 0 do
    begin
      Result := Result + f * (i mod base);
      i := Trunc(i * d);
      f := f * d;
    end;
end;

procedure PreComputeHaltonSequence;
var xx, yy: Double;
    i: Integer;
begin
    for i := 0 to 65535 do
    begin
      xx := halton(i + 1, 2);
      yy := halton(i + 1, 3);
      HaltonSequence[i].HRx := Round(xx * 65535);
      HaltonSequence[i].HRy := Round(yy * 65535);
      xx := halton(i + 1, 5); //4   disc distri done after shifting
      yy := halton(i + 1, 7); //9   5,7 because of correlations between 3,9 and 2,4!
      HaltonSequence[i].HDx := Round(xx * 65535);   //[7,11] if every 5th value, [5,11] if every 7th value
      HaltonSequence[i].HDy := Round(yy * 65535);
    end;
end;

function CalcMCT(Header: TPMandHeader10; PLightVals: TPLightVals;
                 PsiLight5: TPsiLight5; PCTS: TPCalcThreadStats;
                 AvrgSqrNoise: Double; sAvrgRCount: Single;
                 bSkipNonZeroCounts: LongBool): Boolean;
var x, ThreadCount: Integer;
    sRI, sAMBmaxL: Single;
    CalcReflects, bDiffReflectsBigEnough: LongBool;
    MCTparas: TMCTparameter;
    MCThread: array of TMCCalcThread;
begin
  Result := False;
  try
    ThreadCount := Min(Mand3DForm.UpDown3.Position, Header.Height);
    bGetMCTPverbose := False;
    Header.dZend := MaxCD(Header.dZend - Header.dZstart, LengthOfSize(Header) * 0.1 * Header.dStepWidth) + Header.dZstart;
    x := Header.TilingOptions; //used in mc for other things
    Header.TilingOptions := 0;
    MCTparas := getMCTparasFromHeader(Header^, True);  //calcHybridFormulas -> usage of own calcformulas! ->formulaclass
    Header.TilingOptions := x;
    Result := MCTparas.bMCTisValid;
    if Result then
    begin
      PLightVals.SRLightAmount := Min0MaxCS(Header.SRamount, 100);
      CalcHSVecsFromLights(PLightVals, @MCTparas);
      MCTparas.pSiLight := PsiLight5;
      MCTparas.CalcRect.Top := Header.MClastY;
      MCTparas.PLVals := PLightVals;
      MCTparas.PCalcThreadStats := PCTS;
      MCTparas.iSmNormals := 0;
      MCTparas.sRoughness := 0;
      MCTparas.calcHardShadow := 0;
      for x := 0 to 5 do if (Header.Light.Lights[x].Loption and 3) = 0 then
        MCTparas.calcHardShadow := MCTparas.calcHardShadow or (4 shl x);  //no softHS, noLightmapHS  }
      SetLength(MCThread, ThreadCount);
    end;
  finally
  end;
  if Result then
  begin
    if (not MCVMapcalculated) and ((Header.bVolLightNr and 7) > 0) then
    begin
      MCForm.Label15.Caption := 'calculating volumetric map...';
      CalcVolLightMap(Header, PLightVals);
      MCForm.Label15.Caption := '';
      MCVMapcalculated := True;
    end;
    bDiffReflectsBigEnough := PLightVals.bBackBMP and (M3DBackGroundPic.LMWidth * Header.MCdiffReflects > 5000);
    sRI := Header.sTRIndex;
    sAMBmaxL := MinCS(MCTparas.DEAOmaxL * LengthOfSize(Header) * 3, MCTparas.Zend * 255 / 1.75);
    PCTS.ctCalcRect := Rect(0, Header.MClastY, Header.Width - 1, Header.Height - 1);
    MCTparas.CalcRect := PCTS.ctCalcRect;
    CalcReflects := (Header.bCalcSRautomatic and 1) <> 0;
    for x := 1 to ThreadCount do
    begin
      PCTS.CTrecords[x].iActualYpos := 0;
      PCTS.CTrecords[x].iActualXpos := 0;
      PCTS.CTrecords[x].i64DEsteps  := 0;
      PCTS.CTrecords[x].iDEAvrCount := 0;
      PCTS.CTrecords[x].i64Its      := 0;
      PCTS.CTrecords[x].iItAvrCount := 0;
      MCTparas.iThreadId := x;
      try
        MCThread[x - 1] := TMCCalcThread.Create(True);
        AssignLightVal(@MCThread[x - 1].LVals, PLightVals);
        MCTparas.PLVals := @MCThread[x - 1].LVals;
        MCThread[x - 1].FreeOnTerminate := True;
        MCThread[x - 1].MCTparas        := MCTparas;
        MCThread[x - 1].AvrgVari        := MaxCD(0.001, AvrgSqrNoise); //calc before from whole image
        MCThread[x - 1].AvrgRCount      := sAvrgRCount;
        MCThread[x - 1].bSkipNonZeroC   := bSkipNonZeroCounts;
        MCThread[x - 1].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
        MCThread[x - 1].smatrix         := NormaliseMatrixToS(1, @Header.hVGrads);
        MCThread[x - 1].maxAmbDepth     := Header.MCDepth;
        MCThread[x - 1].maxSpecDepth    := Header.SRreflectioncount;
        MCThread[x - 1].bCalcReflects   := CalcReflects;
        MCThread[x - 1].bCalcTrans      := CalcReflects and ((Header.bCalcSRautomatic and 2) <> 0);
        MCThread[x - 1].bOnlyDIFS       := (Header.bCalcSRautomatic and 4) <> 0;
        MCThread[x - 1].bSecantSearch   := (Header.MCoptions and 2) <> 0;
        MCThread[x - 1].bNormSDamount   := CalcReflects and ((Header.MCoptions and 4) <> 0);
        MCThread[x - 1].iDiffReflects   := Header.MCdiffReflects;
        MCThread[x - 1].TransDiConst    := sRI;
        MCThread[x - 1].sAbsorption     := Header.sTransmissionAbsorption * Header.dStepWidth;
        MCThread[x - 1].sLightScatteringMul := Header.sTRscattering / 330;
        MCThread[x - 1].SRLightAmount   := PLightVals.SRLightAmount;
        MCThread[x - 1].AMBmaxL         := sAMBmaxL;
        MCThread[x - 1].bDoDOF          := (Header.bCalcDOFtype and 1) <> 0;
        MCThread[x - 1].sDOFaperture    := MaxCS(0.0000001, Header.sDOFaperture * s05);
        MCThread[x - 1].sDOFZsharp      := MaxCS(0.01, Header.sDOFZsharp * Header.Width);
        MCThread[x - 1].FOVy1d          := 1 / NonZero(MCTparas.FOVy);
        MCThread[x - 1].bDiffReflectsBigEnough := bDiffReflectsBigEnough; //to interpolate map nearest neighbour
        MCThread[x - 1].iBokehNr        := (Header.MCoptions shr 4) and 7;
        MCThread[x - 1].bGaussAA        := (Header.MCoptions and 8) <> 0;
   //     MCThread[x - 1].BGMapFuncSphere := BGMapFuncSphere;
        PCTS.CTrecords[x].isActive := 1;
    //    PCTS.CTprios[x]   := Header.iThreadPriority;
        PCTS.CThandles[x] := MCThread[x - 1];
      except
        ThreadCount := x - 1;
        Break;
      end;
    end;
    PCTS.HandleType := 1;
    for x := 0 to ThreadCount - 1 do MCThread[x].MCTparas.iThreadCount := ThreadCount;
    PCTS.iTotalThreadCount := ThreadCount;
    PCTS.cCalcTime := GetTickCount;
    if bSkipNonZeroCounts then Dec(PCTS.cCalcTime, Header.iCalcTime * 100);
    for x := 0 to ThreadCount - 1 do MCThread[x].Start;
  end;
end;

function CalcBokeh(const xx, yy: Single; BokehNr: Integer): Single;
var u, r, s: Single;
begin
    r := Sqrt(xx * xx + yy * yy);
    if (BokehNr and 1) = 0 then Result := 1 else Result := 1.5 - r * s05;
    if BokehNr = 0 then
    begin
      if r < 0.94 then Result := 1.03 else
      if r < 1 then Result := 0.9682 + (r - 0.94) * s05;
    end
    else if BokehNr > 1 then
    begin
  {    if BokehNr < 4 then u := 0.92 + Sqr(Cos(ArcTan2(xx, yy) * 5) * s05 + s05) * 0.17
                     else u := 0.95 + Sqr(Cos(ArcTan2(xx, yy) * 7) * s05 + s05) * 0.09;
      if r < u then u := u * 0.3 + 0.7 else u := (r - u) / (1 - u) * 0.05 + u;  }
      if BokehNr < 4 then u := 0.92 + Sqr(Cos(ArcTan2(xx, yy) * 5) * s05 + s05) * 0.12
                     else u := 0.94 + Sqr(Cos(ArcTan2(xx, yy) * 7) * s05 + s05) * 0.08;
      s := u - 0.04;
      if r < s then u := 1 else u := (r - s) / (1 - s) * 0.05 + s;
      Result := Result * u;
    end;
end;

{TMCCalcThread}

function TMCCalcThread.CalcN(x, y: Integer; pmc: TPMCrecord): Integer;
var i, wid, n, n2, avgRC: Integer;
    maxYdiff, maxYdiff2, dT2, dT, dT3, maxNoise, dm: Double;
function GetMulti(Raycount: PWord): Double;
begin
    if RayCount^ < 2 then Result := 1
                     else Result := 1 / RayCount^;
end;
begin
    wid := MCTparas.iMandWidth;
    maxYdiff := 0;
    maxYdiff2 := 0;
    maxNoise := 0;
    avgRC := 0;
    n := 0;
    n2 := 0;
    dT2 := MCRGBtoDouble(@pmc.Ysum);
    if y > 1 then
    begin
      i := Integer(@pmc.Ysum) - wid * SizeOf(TMCrecord);
      dT := MCRGBtoDouble(TPRGB(i)); //Ysum
      maxYdiff := Sqr(dT - dT2);
      maxNoise := (MCRGBtoDouble(TPRGB(i + 3)) - Sqr(dT)) {* GetMulti(PWord(i + 6))};
      avgRC := TPMCrecord(i).RayCount;
      Inc(n);
      if x > 1 then
      begin
        i := i - SizeOf(TMCrecord);
        dT3 := MCRGBtoDouble(TPRGB(i)); //Ysum
        maxYdiff := maxYdiff + Sqr(dT2 - dT3);  //use Ydiffs from neighbour to neighbour, single noise pixels get so less weight
        maxYdiff2 := Sqr(dT - dT3);
        maxNoise := MaxCD(maxNoise, (MCRGBtoDouble(TPRGB(i + 3)) - Sqr(dT3)) {* GetMulti(PWord(i + 6))});
        avgRC := avgRC + TPMCrecord(i).RayCount;
        Inc(n);
        Inc(n2);
      end;
      if x < wid then
      begin
        i := Integer(@pmc.Ysum) + SizeOf(TMCrecord) - wid * SizeOf(TMCrecord);
        dT3 := MCRGBtoDouble(TPRGB(i)); //Ysum
        maxYdiff := maxYdiff + Sqr(dT2 - dT3);
        maxYdiff2 := maxYdiff2 + Sqr(dT - dT3);
        maxNoise := MaxCD(maxNoise, (MCRGBtoDouble(TPRGB(i + 3)) - Sqr(dT3)) {* GetMulti(PWord(i + 6))});
        avgRC := avgRC + TPMCrecord(i).RayCount;
        Inc(n);
        Inc(n2);
      end;
    end;
    if x > 1 then
    begin
      i := Integer(@pmc.Ysum) - SizeOf(TMCrecord);
      dT := MCRGBtoDouble(TPRGB(i)); //Ysum
      maxYdiff := maxYdiff + Sqr(dT - dT2);
      maxNoise := MaxCD(maxNoise, (MCRGBtoDouble(TPRGB(i + 3)) - Sqr(dT)) {* GetMulti(PWord(i + 6))});
      avgRC := avgRC + TPMCrecord(i).RayCount;
      Inc(n);
    end;
    if x < wid then
    begin
      i := Integer(@pmc.Ysum) + SizeOf(TMCrecord);
      dT3 := MCRGBtoDouble(TPRGB(i)); //Ysum
      maxYdiff := maxYdiff + Sqr(dT3 - dT2);
      if x > 1 then
      begin
        maxYdiff2 := maxYdiff2 + Sqr(dT - dT3);
        Inc(n2);
      end;
      maxNoise := MaxCD(maxNoise, (MCRGBtoDouble(TPRGB(i + 3)) - Sqr(dT3)) {* GetMulti(PWord(i + 6))});
      avgRC := avgRC + TPMCrecord(i).RayCount;
      Inc(n);
    end;
    if y < MCTparas.iMandHeight then
    begin
      i := Integer(@pmc.Ysum) + wid * SizeOf(TMCrecord);
      dT := MCRGBtoDouble(TPRGB(i)); //Ysum
      maxYdiff := maxYdiff + Sqr(dT - dT2);
      maxNoise := MaxCD(maxNoise, (MCRGBtoDouble(TPRGB(i + 3)) - Sqr(dT)) {* GetMulti(PWord(i + 6))});
      avgRC := avgRC + TPMCrecord(i).RayCount;
      Inc(n);
      if x > 1 then
      begin
        i := i - SizeOf(TMCrecord);
        dT3 := MCRGBtoDouble(TPRGB(i)); //Ysum
        maxYdiff := maxYdiff + Sqr(dT2 - dT3);
        maxYdiff2 := maxYdiff2 + Sqr(dT - dT3);
        maxNoise := MaxCD(maxNoise, (MCRGBtoDouble(TPRGB(i + 3)) - Sqr(dT3)) {* GetMulti(PWord(i + 6))});
        avgRC := avgRC + TPMCrecord(i).RayCount;
        Inc(n);
        Inc(n2);
      end;
      if x < wid then
      begin
        i := Integer(@pmc.Ysum) + SizeOf(TMCrecord) + wid * SizeOf(TMCrecord);
        dT3 := MCRGBtoDouble(TPRGB(i)); //Ysum
        maxYdiff := maxYdiff + Sqr(dT2 - dT3);
        maxYdiff2 := maxYdiff2 + Sqr(dT - dT3);
        maxNoise := MaxCD(maxNoise, (MCRGBtoDouble(TPRGB(i + 3)) - Sqr(dT3)) {* GetMulti(PWord(i + 6))});
        avgRC := avgRC + TPMCrecord(i).RayCount;
        Inc(n);
        Inc(n2);
      end;
    end;
    if n < 1 then n := 1;
    if n2 < 1 then n2 := 1;
    maxYdiff := maxYdiff / n;      //contrast to neighbours
    maxYdiff2 := maxYdiff2 / n2;   //contrast of neighbours

    dT3 := (MCRGBtoDouble(@pmc.Ysqr) - Sqr(dT2)) / ((Clamp0D(dT2) + 0.01) {* pmc.RayCount}); //vari

    if (PMCrecord.Zbyte and 128) = 0 then dm := 0 else
    dm := Clamp0D(MaxCD(maxYdiff, maxYdiff2) - 20 * AvrgVari) * MinMaxCD(-4, pmc.RayCount - avgRC / n, 4);// - Clamp0D(maxYdiff - maxYdiff2) * 0.5;// * MinMaxCD(-4, (pmc.RayCount - avgRC / n), 4);
                                                          //hdr scale Y
    dT := Clamp0D(MaxCD(dT3, maxNoise) / MaxCD(0.3, (dT2 / Sqrt(1 + Sqr(dT2 * 0.9))) * pmc.RayCount) - dm);
    dT2 := dT * 4 / AvrgVari;

    if dT2 >= 1 then
      Result := Round(MinCD(AvrgRCount * s05 + 8, dT2))
    else
      if GetRand * 1.1 - 0.1 > Clamp0D(dT2) then Result := 0 else Result := 1;
end;

procedure TMCCalcThread.CalcNormalsOnCutMC(CutPlane: Integer);
var NN: Double;
begin
    with MCTparas do
    begin
      if CutPlane <> 0 then
      begin
        Dec(CutPlane);
        if Abs(Vgrads[2, CutPlane]) < 1e-40 then NN := -1e40 else NN := -1 / Vgrads[2, CutPlane];
        Normals[0] := Vgrads[0, CutPlane] * NN;
        Normals[1] := Vgrads[1, CutPlane] * NN;
        Normals[2] := -1;
      end else begin
        Normals[0] := 0;
        Normals[1] := 0;
        Normals[2] := -1;
      end;
      RotateVectorReverse(@Normals, @Vgrads);
      NormaliseVectorVar(Normals);
    end;
end;

procedure TMCCalcThread.CalcHSMC;
var itmp2, itmp: Integer;
    RLastDE, RLastStepWidth, RStepFactorDiff, sTmp, ZZ2mul, ZZ: Single;
    dTmp, dT1, MaxLHS, ZZ2, dMaxL: Double;
    IC, HSVec, NVec: TVec3D;
    ObjColor: TLightSD;
    hsiLight: TsiLight5;
label label2;
procedure HSminLengthToCutPlane(HVec: TPVec3D; var dLength: Double);
var dT: Double;
begin
    with MCTparas do
    begin
      if ((iCutOptions and 1) <> 0) and (Abs(HVec[0]) > 1e-20) then
      begin
        dT := (dCOX - pIt3Dext.C1) / HVec[0];
        if (dT > 0) and (dT < dLength) then dLength := dT;
      end;
      if ((iCutOptions and 2) <> 0) and (Abs(HVec[1]) > 1e-20) then
      begin
        dT := (dCOY - pIt3Dext.C2) / HVec[1];
        if (dT > 0) and (dT < dLength) then dLength := dT;
      end;
      if ((iCutOptions and 4) <> 0) and (Abs(HVec[2]) > 1e-20) then
      begin
        dT := (dCOZ - pIt3Dext.C3) / HVec[2];
        if (dT > 0) and (dT < dLength) then dLength := dT;
      end;
    end;
end;
begin
    with MCTparas do
    begin
      ZZ := Abs(mZZ);
      mCopyVec(@IC, @pIt3Dext.C1);
      MaxLHS := HSmaxLmul * (1 + s05 * Min(ZZ, Zend * 0.4) * Clamp0D(FOVy) / iMandHeight);
      for itmp2 := 0 to 5 do if PLVals.iLightOption[itmp2] = 0 then
      begin
        HS6[itmp2] := cSVec1c4;  //(1,1,1,1)
        mCopyVec(@pIt3Dext.C1, @IC);
        ZZ2 := mZZ;
        msDEstop := DEstop * (1 + ZZ * mctDEstopFactor);
        dT1 := MaxLHS;
        if (PLVals.iLightPos[itmp2] and 1) <> 0 then  //calculate LightVec from position
        begin
          HSVec := SubtractVectors(HSvecs[itmp2], @pIt3Dext.C1);
          dTmp := SqrLengthOfVec(HSVec);
          if dTmp > PLVals.sLmaxL[itmp2] * sHSmaxLengthMultiplier then Continue;
          if dTmp < Sqr(dT1 * StepWidth) then dT1 := Sqrt(dTmp) / StepWidth;
          NormaliseVectorTo(StepWidth, @HSVec);
        end
        else HSVec := ScaleVector(HSvecs[itmp2], -1);
        if iCutOptions <> 0 then HSminLengthToCutPlane(@HSVec, dT1);
        if dT1 > s0001 then
        begin
          if DotOfVectors(@Normals, @HSVec) < 0 then
          begin
            ClearSVec(HS6[itmp2]);
            Continue;
          end;
          ZZ2mul := DotOfVectorsNormalize(@HSVec, @mVgradsFOV);
          RStepFactorDiff := 2;  //1
          dMaxL := dT1;
          dTmp := CalcDE(pIt3Dext, @MCTparas);
          repeat
            RLastDE := dTmp;
            dTmp := MinCS(dTmp * sZstepDiv * RStepFactorDiff, MaxCS(msDEstop, 0.4) * mctMH04ZSD);
            RLastStepWidth := dTmp;
            dT1 := dT1 - dTmp;
            mAddVecWeight(@pIt3Dext.C1, @HSVec, dTmp);
            ZZ2 := ZZ2 + dTmp * ZZ2mul;
            msDEstop := DEstop * (1 + Abs(ZZ2) * mctDEstopFactor);
            dTmp := CalcDE(pIt3Dext, @MCTparas);
            if (pIt3Dext.ItResultI >= MaxItsResult) or (dTmp < msDEstop) then Break;
            if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;
            if RLastDE > dTmp + 1e-30 then
            begin
              sTmp := RLastStepWidth / (RLastDE - dTmp);
              if sTmp < 1 then
                RStepFactorDiff := maxCS(s05, sTmp)
              else
                RStepFactorDiff := 1;
            end
            else RStepFactorDiff := 1;
          until dT1 < 0;

          if dT1 > s001 then
          begin
            if bCalcTransR then
            begin
              if Iteration3Dext.ItResultI < MaxItsResult then
              begin
              {  itmp := 8;
                RLastDE := RLastStepWidth * -0.5;
                while (itmp > 0) and (Abs(dTmp - msDEstop) > 0.01) do
                begin
                  ZZ := ZZ + RLastDE * ZZ2mul;
                  mAddVecWeight(@Iteration3Dext.C1, @HSVec, -RLastDE);
                  msDEstop := DEstop * (1 + Abs(ZZ) * mctDEstopFactor);
                  dTmp := CalcDE(@Iteration3Dext, @MCTparas);
                  if dTmp < msDEstop then RLastDE := Abs(RLastDE) * -0.55
                                     else RLastDE := Abs(RLastDE) * 0.55;
                  Dec(itmp);
                end;  }
                itmp := 3;
                while (itmp > 0) and (Abs(dTmp - msDEstop) > s001) do
                begin
                  RLastDE := NotZero(RLastDE - dTmp);
                  RStepFactorDiff := RLastStepWidth * (dTmp - msDEstop) / RLastDE;
                  if dTmp < msDEstop then
                  begin
                    if (RStepFactorDiff >= 0) or (RStepFactorDiff < Abs(RLastStepWidth) * -0.94) then
                      RLastStepWidth := Abs(RLastStepWidth) * sm05
                    else RLastStepWidth := RStepFactorDiff;
                  end else begin
                    if (RStepFactorDiff <= 0) or (RStepFactorDiff > Abs(RLastStepWidth) * 0.94) then
                      RLastStepWidth := Abs(RLastStepWidth) * s05
                    else RLastStepWidth := RStepFactorDiff;
                  end;
                  RLastDE := dTmp;
                  ZZ2 := ZZ2 + RLastStepWidth * ZZ2mul;
                  mAddVecWeight(@Iteration3Dext.C1, @HSVec, RLastStepWidth);
                  msDEstop := DEstop * (1 + Abs(ZZ2) * mctDEstopFactor);
                  dTmp := CalcDE(@Iteration3Dext, @MCTparas);
                  Dec(itmp);
                end;
              end else begin
                dTmp := ZZ2;
                doBinSearchIt(dTmp, @HSVec);
                ZZ2 := ZZ2 + (dTmp - ZZ2) * ZZ2mul;
              end;
              mZZ := Abs(ZZ2);  //backup mZZ?
              mCopyVec(@NVec, @Normals);    //backup normals...
              if NormalsOnDE then CalculateNormals(sTmp, @HSVec)
                             else CalculateNormalsOnSmoothIt(sTmp, @HSVec);
              if Iteration3Dext.ItResultI < MaxItsResult then
                sTmp := 32767 - (sTmp + dColPlus + mctColVarDEstopMul * ln(msDEstop * StepWidth)) * mctsM
              else sTmp := 32767 - sTmp * mctsM;
              MinMaxClip15bit(sTmp, hsiLight.SIgradient);
              itmp := Integer(mPsiLight);
              mPsiLight := @hsiLight;
              if ColorOnIt <> 0 then RMdoColorOnIt(@MCTparas);
              RMdoColor(@MCTparas);
              mPsiLight := TPsiLight5(itmp);
           //   sRoughness := 0;
              CalcZposAndRough(@hsiLight, @MCTparas, ZZ2);        //fp invalid op   ZZ2 = 139498078   dtmp>>>>maxhls
              ObjColor := CalcColor(@hsiLight, mZZ * StepWidth + sZZstmitDif);   //dif+spec holds colors  zPos for ColZmultiplier, must be ZZ
              itmp := DEoptionResult;
              if (ObjColor[0][3] > 0) and ((not bOnlyDIFS) or (bOnlyDIFS and (DEoptionResult = 20))) then
              begin
                if bInAndOutside then
                begin
                  MultiplySVectorsV(@HS6[itmp2], SVecPow(ObjColor[1], sAbsorption));
                  goto label2;
                end;
                HS6[itmp2][3] := Sqr(DotOfVectors(@Normals, @HSVec) / StepWidth);  //downscale by change of lightangle, spec more
                ScaleSVectorV(@HS6[itmp2], HS6[itmp2][3]);  //only first3 comps
                //check only at random position if still in?  better: calc refraction, go inside + step until boarder or maxL, calc lightabsorption
                bInsideRendering := not bInsideRendering;
                bCalcInside := not bCalcInside;

                mAddVecWeight(@Iteration3Dext.C1, @HSVec, dT1); //step towards light and step back
                dTmp := GetRand * 8 * MaxCS(msDEstop, 1);
                repeat
                  dTmp := -1 - Abs(dTmp);
                  dT1 := dT1 + dTmp;
                  mAddVecWeight(@Iteration3Dext.C1, @HSVec, dTmp);
                  dTmp := CalcDE(@Iteration3Dext, @MCTparas);
                until (dTmp > msDEstop) or (dT1 <= 0);

                bInsideRendering := not bInsideRendering;
                bCalcInside := not bCalcInside;

                if itmp <> DEoptionResult then HS6[itmp2] := cSVec0 else
                MultiplySVectorsV(@HS6[itmp2], ScaleSVector(SVecPow(ObjColor[1], Clamp0D(dT1) * sAbsorption),
                                  ObjColor[0][3] * MaxOfSVec(@ObjColor[0])));
              end
              else ScaleSVectorV(@HS6[itmp2], MinCS(1, Sqr(Sqr(Sqr((dMaxL - dT1) / MaxLHS)))));
label2:       mCopyVec(@Normals, @NVec);
            end
            else ScaleSVectorV(@HS6[itmp2], MinCS(1, Sqr(Sqr(Sqr((dMaxL - dT1) / MaxLHS)))));
          end;
        end;
      end;
      mCopyVec(@pIt3Dext.C1, @IC);
   end;
end;

procedure MakeDiscFromHalton(var xx, yy: Single);
var sd, cd: Single;
begin
    xx := xx * 2 - 1;
    yy := yy * 2 - 1;
    if xx > Abs(yy) then
    begin
      SinCosS(sPiM025 * yy / NotZero(xx), sd, cd);
      yy := xx;
    end
    else if xx > yy then
    begin
      SinCosS(sPiM025 * (6 - xx / NotZero(yy)), sd, cd);
      yy := - yy;
    end
    else if xx > - yy then
      SinCosS(sPiM025 * (2 - xx / NotZero(yy)), sd, cd)
    else begin
      SinCosS(sPiM025 * (4 + yy / NotZero(xx)), sd, cd);
      yy := - xx;
    end;
    xx := sd * yy;
    yy := cd * yy;
end;

procedure GetHalton2Dshifts(var s1, s2: Single; x, y: Integer);
var i2, i: Integer;
begin
{$IFDEF DEBUG} {$Q-} {$R-} {$ENDIF}
    i  := x * $343FD + $269EC3;
    i2 := y * $343FD + $269EC3;
    i2 := (x shl 15) xor y xor (i shl 9) xor (i2 shl 5);
    i2 := i2 * $343FD + $269EC3;
    i2 := i2 * $343FD + $269EC3;
    s1 := (i2 and $7FFFFFFF) * dSeedMul;
    i2 := i2 * $343FD + $269EC3;
    s2 := (i2 and $7FFFFFFF) * dSeedMul;
{$IFDEF DEBUG} {$Q+} {$R+} {$ENDIF}
end;

function TMCCalcThread.GetRand: Double;
asm                                      //begin result := random; end;
{$IFDEF DEBUG} {$Q-} {$R-} {$ENDIF}
    imul edx, [eax + seed], $343FD
    add  edx, $269EC3
    mov  [eax + seed], edx
    and  edx, $7FFFFFFF
    push edx
    fild dword [esp]
    fmul dSeedMul
    pop  edx
{$IFDEF DEBUG} {$Q+} {$R+} {$ENDIF}
end;

function TMCCalcThread.GenSphereSVecOm: TSVec;    //fullsphere
{var u, v, s, c, r: Single;              //edx
begin
    if not bDoDoF then    //eax + bDoDOF       for poslights
    begin
      u := HaltonDiscX;
      v := HaltonDiscY;
    end else begin
      u := GetRand;
      v := GetRand;
    end;
    r := 2 * Sqrt(v * (1 - v));
    SinCosS(PiM2 * u, s, c);
    Result[0] := r * c;
    Result[1] := r * s;
    Result[2] := 1 - 2 * v;
    Result[3] := 0;   // }
asm
    cmp  dword [eax + TMCCalcThread.bDoDOF], 0
    jnz  @@1
    fld  dword [eax + TMCCalcThread.HaltonDiscY]
    fld  dword [eax + TMCCalcThread.HaltonDiscX]
    jmp  @@2
@@1:
    push edx
    call GetRand
    call GetRand
    pop  edx
@@2:
    fmul PiM2
    fsincos          //cos,sin,v
    fld1
    fsub st, st(3)
    fmul st, st(3)
    fsqrt
    fadd st, st      //r,cos,sin,v
    fmul st(2), st
    fmulp            //c',s',v
    fstp dword [edx]
    fstp dword [edx + 4]
    fadd st, st
    fld1
    fsubrp
    fstp dword [edx + 8]
    xor  eax, eax
    mov  [edx + 12], eax    //}
end;

{function TMCCalcThread.GenSphereSVecOm: TSVec;    //hemisphere!
var a, u, v, s: Double;
begin
    if not bDoDoF then
    begin
      u := HaltonDiscX;
      v := HaltonDiscY;
      s := u * u + v * v;
    end
    else
    repeat
      u := GetRand * 2 - 1;
      v := GetRand * 2 - 1;
      s := u * u + v * v;
    until s <= 1;
    a := 2 - Sqrt(1 - s);
    Result[0] := a * u;
    Result[1] := a * v;
    Result[2] := 2 * s - 1;
    Result[3] := 0;
end;   }

procedure TMCCalcThread.VaryVecSphere(Vec: TPVec3D);
var sd: TLightSD;
    s1, s2, s3, s4: Single;
begin
    MakeOrthoVecs(Vec, @sd);
    if not MCTparas.bCalcAmbShadow then
    begin
      SinCosS(HaltonX * PiM2, s1, s2);
      s3 := HaltonY;
    end else begin
      SinCosS(GetRand * PiM2, s1, s2);
      s3 := GetRand;
    end;
    s4 := Sqrt(s3);
    Vec^ := AddVecF(AddSVectorsToDVec(ScaleSVector(sd[0], s1 * s4),
              ScaleSVector(sd[1], s2 * s4)), ScaleVector(Vec^, Sqrt(1 - s3)));
end;

function TMCCalcThread.CalcColor(PsiLight: TPsiLight5; zPos: Single): TLightSD;      //proof zpos
var dTmp2, dTmp: Single;
    SV2, st: TSVec;
    SV1: TVec3D;
begin
    with LVals do
    begin
      Result[1][0] := sColZmul * zPos;
      if PsiLight.SIgradient > 32767 then CalcColorsInside(@Result[1], @Result[0], PsiLight, @LVals)
                                     else CalcColors(@Result[1], @Result[0], PsiLight, @LVals);
      if iColOnOT > 1 then
      begin   //diff map
        if bYCcomb then st := Result[1];  //backup for y-c combi
        if iColOnOT > 3 then
        begin
          if iColOnOT > 5 then
          begin
            SV1 := ScaleVector(TPVec3D(@Iteration3Dext.C1)^, lvMapScale);   //add MidPos to ObjPos, scale, + DCLOffset, Frac in a seperate function with more precision!
            SV2 := DVecToSVec(Normals);
            ScaleSVectorV(@SV2, 1 / (Abs(SV2[0]) + Abs(SV2[1]) + Abs(SV2[2])));
            AbsSVecVar(SV2);
            if iColOnOT > 7 then
            begin
              if SV1[0] < 0 then SV1[0] := SV1[0] + 1 - Round(SV1[0]);
              if SV1[1] < 0 then SV1[1] := SV1[1] + 1 - Round(SV1[1]);
              if SV1[2] < 0 then SV1[2] := SV1[2] + 1 - Round(SV1[2]);
              Result[1] := Add3SVectors(ScaleSVector(GetLightMapPixel(Frac(SV1[1] + DCLMapOffX), Frac(SV1[2] + DCLMapOffY), DiffColLightMap, bCalcPixColSqr, 1), SV2[0]),
                ScaleSVector(GetLightMapPixel(Frac(SV1[0] + DCLMapOffX), Frac(SV1[2] + DCLMapOffY), DiffColLightMap, bCalcPixColSqr, 1), SV2[1]),
                ScaleSVector(GetLightMapPixel(Frac(SV1[0] + DCLMapOffX), Frac(SV1[1] + DCLMapOffY), DiffColLightMap, bCalcPixColSqr, 1), SV2[2]));
            end
            else
            begin
              SV1[0] := Sin(SV1[0]);
              SV1[1] := Sin(SV1[1]);
              SV1[2] := Sin(SV1[2]);
              SV1[0] := SV1[1] * SV2[0] + SV1[0] * (SV2[1] + SV2[2]) + DCLMapOffX;
              SV1[1] := SV1[2] * (SV2[0] + SV2[1]) + SV1[1] * SV2[2] + DCLMapOffY;
              if SV1[0] < 0 then SV1[0] := SV1[0] + 1 - Round(SV1[0]);
              if SV1[1] < 0 then SV1[1] := SV1[1] + 1 - Round(SV1[1]);
              Result[1] := GetLightMapPixel(Frac(SV1[0]), Frac(SV1[1]), DiffColLightMap, bCalcPixColSqr, 1);
            end;
          end
          else
          begin
            SV2 := DVecToSVec(Normals);
            RotateSVectorReverseS(@SV2, @smatrix);
            Result[1] := GetLightMapPixelSphere(SV2,//MakeSVecFromNormals(PsiLight),
              @DiffColLightMap.PicRotMatrix, DiffColLightMap, bCalcPixColSqr);
          end;
        end
        else
        begin     //rotate x,y 2d before
          dTmp := (PsiLight.OTrap and $7FFF) * 3.05186851e-5 - s05;  //because it was calculated as arctan2:2pi * 5215
          dTmp2 := PsiLight.SIgradient * 3.05186851e-5 - s05;
          Result[1] := GetLightMapPixel(Frac((DCLMapRotCos * dTmp + DCLMapRotSin * dTmp2 + DCLMapOffX) * lvMapScale),
            Frac((DCLMapRotCos * dTmp2 - DCLMapRotSin * dTmp + DCLMapOffY) * lvMapScale), DiffColLightMap, bCalcPixColSqr, 1);
        end;
        if bYCcomb then Result[1] := ScaleSVector(st, YofSVec(@Result[1]) / (s001 + YofSVec(@st)));
      end;
      if bNormSDamount then
      begin
        if bCalcTrans then dTmp2 := 1 - Result[0][3] else dTmp2 := 1;
        dTmp := MaxCS(MaxCS(Result[0][0] * SRLightAmount + Result[1][0] * dTmp2,
                            Result[0][1] * SRLightAmount + Result[1][1] * dTmp2),
                            Result[0][2] * SRLightAmount + Result[1][2] * dTmp2);
        if dTmp > 1 then
        begin
          dTmp := 1 / dTmp;
          ScaleSVectorV(@Result[0], dTmp);
          ScaleSVectorV(@Result[1], dTmp);
        end;
      end;
    end;
end;

procedure TMCCalcThread.minLengthToCutPlane(var dLength: Double; dLimit: Double; vPos: TPPos3D; Vec: TPVec3D);
var dTmp: Double;
begin
    with MCTparas do
    begin
      if ((iCutOptions and 1) <> 0) and (Abs(Vec[0]) > 1e-20) then
      begin
        dTmp := (dCOX - vPos[0]) / Vec[0];
        if (dTmp > dLimit) and (dTmp < dLength) then dLength := dTmp;
      end;
      if ((iCutOptions and 2) <> 0) and (Abs(Vec[1]) > 1e-20) then
      begin
        dTmp := (dCOY - vPos[1]) / Vec[1];
        if (dTmp > dLimit) and (dTmp < dLength) then dLength := dTmp;
      end;
      if ((iCutOptions and 4) <> 0) and (Abs(Vec[2]) > 1e-20) then
      begin
        dTmp := (dCOZ - vPos[2]) / Vec[2];
        if (dTmp > dLimit) and (dTmp < dLength) then dLength := dTmp;
      end;
    end;
end;

procedure TMCCalcThread.CalculateNormals(var NN: Single; raydir: TPVec3D);
var Noffset, No, Ntmp: Double;
    Scale: Single;
    i: Integer;
begin
    with MCTparas do   //only towards 1 side and flip sides randomly
    begin
      Iteration3Dext.CalcSIT := True;
      if (seed and 128) = 0 then Scale := 0.15 else Scale := -0.15;
      No := CalcDE(@Iteration3Dext, @MCTparas);
      NN := Iteration3Dext.SmoothItD;   //for coloring
      Iteration3Dext.CalcSIT := False;
      i := 4;
      repeat
        if i < 4 then Scale := (GetRand - s05) * s05;
        Noffset := MinCS(1, DEstop) * (1 + mZZ * mctDEstopFactor) * Scale * StepWidth;
        Ntmp := Iteration3Dext.C3;
        Iteration3Dext.C3 := Iteration3Dext.C3 + Noffset;
        Normals[2] := (CalcDE(@Iteration3Dext, @MCTparas) - No) * Scale;                 //Zgradient
        Iteration3Dext.C3 := Ntmp;
        Ntmp := Iteration3Dext.C1;
        Iteration3Dext.C1 := Iteration3Dext.C1 + Noffset;
        Normals[0] := (CalcDE(@Iteration3Dext, @MCTparas) - No) * Scale;                 //Xgradient
        Iteration3Dext.C1 := Ntmp;
        Ntmp := Iteration3Dext.C2;
        Iteration3Dext.C2 := Iteration3Dext.C2 + Noffset;
        Normals[1] := (CalcDE(@Iteration3Dext, @MCTparas) - No) * Scale;                 //Ygradient
        Iteration3Dext.C2 := Ntmp;
        Ntmp := Sqr(Normals[0]) + Sqr(Normals[1]) + Sqr(Normals[2]);
        if (Ntmp > d1em100) and (DotOfVectors(@Normals, raydir) < 0) then
        begin
          ScaleVectorV(@Normals, 1 / Sqrt(Ntmp));
          Break;
        end;
        Dec(i);
      until i = 0;
      if i = 0 then Normals := NormaliseVectorTo(-1, raydir^);
    end;
end;

procedure TMCCalcThread.CalculateNormalsOnSmoothIt(var NN: Single; raydir: TPVec3D);
var Noffset, Ntmp: Double;
    Scale: Single;
    i: Integer;
begin
    with MCTparas do
    begin    // and 1 is always the same?
      if (seed and 128) = 0 then Scale := 0.15 else Scale := -0.15;
      Iteration3Dext.CalcSIT := True;
      mMandFunction(@Iteration3Dext.C1);
      NN := Iteration3Dext.SmoothItD;
      i := 4;
      repeat
        if i < 4 then Scale := (GetRand - s05) * s05;
        Noffset := MinCS(1, DEstop) * (1 + mZZ * mctDEstopFactor) * Scale * StepWidth;
        Ntmp := Iteration3Dext.C3;
        Iteration3Dext.C3 := Iteration3Dext.C3 + Noffset;
        mMandFunction(@Iteration3Dext.C1);
        Normals[2] := (NN - Iteration3Dext.SmoothItD) * Scale;     //Zgradient
        Iteration3Dext.C3 := Ntmp;
        Ntmp := Iteration3Dext.C1;
        Iteration3Dext.C1 := Iteration3Dext.C1 + Noffset;
        mMandFunction(@Iteration3Dext.C1);
        Normals[0] := (NN - Iteration3Dext.SmoothItD) * Scale;     //Xgradient
        Iteration3Dext.C1 := Ntmp;
        Ntmp := Iteration3Dext.C2;
        Iteration3Dext.C2 := Iteration3Dext.C2 + Noffset;
        mMandFunction(@Iteration3Dext.C1);
        Normals[1] := (NN - Iteration3Dext.SmoothItD) * Scale;     //Ygradient
        Iteration3Dext.C2 := Ntmp;
        Ntmp := Sqr(Normals[0]) + Sqr(Normals[1]) + Sqr(Normals[2]);
        if (Ntmp > d1em100) and (DotOfVectors(@Normals, raydir) < 0) then
        begin
          ScaleVectorV(@Normals, 1 / Sqrt(Ntmp));
          Break;
        end;
        Dec(i);
      until i = 0;
      Iteration3Dext.CalcSIT := False;
      if i = 0 then Normals := NormaliseVectorTo(-1, raydir^);
    end;
end;

procedure TMCCalcThread.CalculateVgradsFOV(x, y: Single);
begin
    with MCTparas do
    begin
      CAFX := (s05 * iMandWidth - x - 1) * FOVXmul;
      CAFY := (y / iMandHeight - s05) * FOVy;
      if MCTCameraOptic = 1 then
      begin
        mVgradsFOV[0] := -CAFX;
        mVgradsFOV[1] := CAFY;
        mVgradsFOV[2] := mctPlOpticZ;
        NormaliseVectorVar(mVgradsFOV);
      end
      else if MCTCameraOptic = 2 then
        BuildViewVectorDSphereFOV(CAFY, CAFX, @mVgradsFOV)
      else BuildViewVectorDFOV(CAFY, CAFX, @mVgradsFOV);
      RotateVectorReverse(@mVgradsFOV, @VGrads);
    end;
end;

procedure TMCCalcThread.CalcBokehMC(var xx, yy: Single);
var s{, a, b, radd}: Single;
  //  i, i2: Integer;
  //  p1, p2: TPSPoint;
begin
  //  if iBokehNr < 2 then
    begin  //disc
      xx := FracSingle(HaltonSequence[iActRayNr].HDx * d1d65535 + HaltonShiftX);
      yy := FracSingle(HaltonSequence[iActRayNr].HDy * d1d65535 + HaltonShiftY);
      MakeDiscFromHalton(xx, yy);
      s := CalcBokeh(xx, yy, iBokehNr) * sDOFaperture * sDOFZsharp * MCTparas.StepWidth;
      xx := xx * s;
      yy := yy * s;
 {   end
    else
    begin
      if iBokehNr > 3 then i := 7 else i := 5;
      i2 := Integer(@HaltonSequence[iActRayNr div i]);
      xx := FracSingle(PHaltonRec(i2).HDx * d1d65535 + HaltonShiftX);
      yy := Sqrt(FracSingle(PHaltonRec(i2).HDy * d1d65535 + HaltonShiftY));
      if (iBokehNr and 1) = 0 then
      begin
        if yy < 0.94 then yy := yy * 1.03
                     else yy := yy * (0.9682 + (yy - 0.94) * s05);
      end
      else yy := yy * (1.5 - yy * s05);
      i := iActRayNr mod i;
      if iBokehNr > 3 then
      begin  //septagon
        p1 := @SinCosP7[i];
        p2 := @SinCosP7[i + 1];
        s := 0.3;
      end
      else
      begin  //pentagon
        p1 := @SinCosP5[i];
        p2 := @SinCosP5[i + 1];
        s := 0.4;
      end;
      radd := xx * (1 - xx) * s; //addition to border, make it more roundy
      s := 0.96 + radd;
      if yy < s then yy := yy * (1 + radd) else yy := 0.96 + (yy - s) * (radd + 0.04);
      yy := yy * sDOFaperture * sDOFZsharp * MCTparas.StepWidth;
      a := xx * yy;
      b := (1 - xx) * yy;
      xx := a * p1[0] + b * p2[0];
      yy := a * p1[1] + b * p2[1]; // }
    end;
end;

procedure TMCCalcThread.DoDOF;
var ZPos: TVec3D;
    Vortho: TLightSD;
begin
    with MCTparas do
    begin
      mCopyAddVecWeight(@ZPos, @Iteration3Dext.C1, @mVgradsFOV, sDOFZsharp); //Position of sharpness
      MakeOrthoVecs(@mVgradsFOV, @Vortho);
      CalcBokehMC(HaltonDiscX, HaltonDiscY);
      AddSVec2Vec3d(ScaleSVector(Vortho[0], HaltonDiscX), @Iteration3Dext.C1);
      AddSVec2Vec3d(ScaleSVector(Vortho[1], HaltonDiscY), @Iteration3Dext.C1);  //shift to new start position
      mVgradsFOV := NormaliseVectorTo(StepWidth, SubtractVectors(ZPos, @Iteration3Dext.C1)); //new vec to Zsharp
  //    s := StepWidth * (1 + sDOFZsharp * mctDEstopFactor);
  //    AddSVec2Vec3d(ScaleSVector(Vortho[0], (GetRand - s05) * s), @Iteration3Dext.C1);  //add some bits to position for AA
   //   AddSVec2Vec3d(ScaleSVector(Vortho[1], (GetRand - s05) * s), @Iteration3Dext.C1);  //the usual one should be enough..?
    end;
end;

procedure TMCCalcThread.doBinSearchIt(var ZZ: Double; VgradsFOVit: TPVec3D);
var dT1, dmul: Double;
    itmp, MItmp: Integer;
    LastSI, R, LastDif, YP: Single;
    firstIt: LongBool;
begin
    with Iteration3Dext do
    begin
      MItmp   := maxIt;
      YP      := maxIt - 0.99;
      Inc(maxIt, 1);        //iMaxItF2  iMaxIt
      itmp    := 10;
      CalcSIT := True;
      dT1     := 0;
      dmul    := 1;
      firstIt := True;
      repeat
        ZZ := ZZ + dT1;
        mAddVecWeight(@C1, VgradsFOVit, dT1);
        MCTparas.CalcDE(@Iteration3Dext, @MCTparas);
        if not firstIt then
        begin
          if LastDif < Abs(YP - SmoothItD) then
          begin
            ZZ := ZZ - dT1;
            mAddVecWeight(@C1, VgradsFOVit, -dT1);
            SmoothItD := LastSI;
            if dT1 > 0 then dmul := dmul * s05
                       else dmul := dmul * 0.7;
          end;
        end;
        LastDif := Abs(YP - SmoothItD);
        LastSI  := SmoothItD;
        if SmoothItD > maxIt - 0.1 then dT1 := -3 else
        begin
          ZZ := ZZ - s0001;
          mAddVecWeight(@C1, VgradsFOVit, -0.001);
          MCTparas.CalcDE(@Iteration3Dext, @MCTparas);
          R := LastSI - SmoothItD;
          if Abs(R) < s1em30 then
            dT1 := Integer(LastSI < SmoothItD) - s05
          else if R < 0 then dT1 := (YP - SmoothItD) / (R * 500)
                        else dT1 := (YP - SmoothItD) / (R * 1000);

          if dT1 >  4 then dT1 := Sqrt(dT1) * 2 else
          if dT1 < -9 then dT1 := Sqrt(-dT1) * -3;
          dT1 := dT1 * dmul + 0.0005;
        end;
        firstIt := False;
        Dec(itmp);
      until itmp < 0;
      maxIt := MItmp;
    end;
end;
                                           //distance, maxdist in
{procedure TMCCalcThread.CalcPosLightShapeMC(var flux, transp: Single; LightNr: Integer);
//var PosLight: LongBool;
 //   tmpR, d2, diam: Single;
begin
  //    d2 := Sqrt(tmpRit);
   //   tmpR := Power(flux / transp, d2) + d2 * 0.0004;
  //    tmpR := 1 - Clamp01S(tmpR * Sqrt(d2)) + d2 * 0.0004;   // smear on itdepth
   //   flux := 1 / Sqr(tmpR * 40);
      transp := 1;
end;  }

function TMCCalcThread.CalcVisLights(VPos: TSVec; ViewVec: TPVec3D; PsiLight: TPsiLight5;
                                     var BGdecrease, DepthDec: Single{; bIsBG: LongBool}): TSVec;
var ir: Integer;
    sTmp, bgztmp, dFog, bgZ, ldis{, vlInc}: Single;
    bPosLight, bBackBMPtmp: LongBool;
    viewSvec, sVBG, sZpos: TSVec;
begin
    viewSvec := DVecToSVec(NormaliseVectorF(ViewVec^));
    //test: increase vislights by reci of absorption to get always max???
 //   vlInc := s05 / maxAbsorb + s05;
    with LVals do
    begin
      if PsiLight.Zpos < 32768 then
        bgZ := Max0S(1 + (Integer(PsiLight.Zpos) - 28000) * sDepth)
      else
        bgZ := Max0S(1 - (60768 - Integer(PsiLight.Zpos)) * sDepth);  //works with calcSR to add only an exact amount of depthfog towards infinity!
    //    bgZ := Max0S(1 - 28000 * sDepth);
      if bgZ < 1 then //for depthfog                              //.. use on it1 Zend value?
      begin
        if LVals.bCalcPixColSqr then bgZ := Sqr(1 - bgZ)
                                else bgZ := 1 - bgZ;
        if bFarFog then bgZ := Sqr(bgZ);
        bgZ := 1 - bgZ;
      end;
      DepthDec := bgZ;
      BGdecrease := 1;
      bBackBMPtmp := bBackBMP;
      bBackBMP := False;  //get only depth colors to blend
      sVBG := CalcBGLight(ViewVec, False, False);
      bBackBMP := bBackBMPtmp;
      ClearSVec(Result);

      if {bGoneThroughObject or} not MCTparas.bCalcAmbShadow then
      for ir := 0 to 5 do if (iLightPos[ir] and 14) <> 0 then // bit1: posLight  bit2+3+4: visLsource func (0:0,4:1,6:2:,2:3,8:4)
      begin
        bPosLight := (iLightPos[ir] and 1) <> 0;
        if bPosLight then
          sTmp := SqrDistSV(SubtractSVectors(@VPos, PLValigned.LN[ir]), viewSvec)
        else
        begin    //vis global light
          if PsiLight.Zpos < 32768 then Continue;
          sZpos := viewSvec;
          RotateSVectorReverseS(@sZpos, @smatrix);
          sTmp := Max0S(1 - DotOfSVectors(PLValigned.LN[ir], sZpos));  //todo: makelightvalsforMC: LN as absolute vector
        end;
        ldis := sLmaxL[ir] * 1e-8;
        if sTmp < ldis then
        begin
          if bPosLight then
          begin   //proof if light is behind viewer
            sZpos := SubtractSVectors(@PLValigned.LN[ir], VPos); //Vpos := campos, mit subtracted
            if DotOfSVectors(sZpos, viewSvec) < 0 then Continue; //light behind viewer
            if PsiLight.Zpos < 32768 then
            begin
              if Abs(viewSvec[0]) > s05 then bgztmp := (Iteration3Dext.C1 - MCTparas.HSvecs[ir][0]) / viewSvec[0] else
              if Abs(viewSvec[1]) > s05 then bgztmp := (Iteration3Dext.C2 - MCTparas.HSvecs[ir][1]) / viewSvec[1]
                                        else bgztmp := (Iteration3Dext.C3 - MCTparas.HSvecs[ir][2]) / viewSvec[2];
              if -Sqrt(ldis - sTmp) > bgztmp then Continue; //poslight is behind object
            end;
            if Abs(viewSvec[0]) > s05 then bgztmp := sZpos[0] / viewSvec[0] else  //determine poslight zposition
            if Abs(viewSvec[1]) > s05 then bgztmp := sZpos[1] / viewSvec[1]
                                      else bgztmp := sZpos[2] / viewSvec[2];   //fp error
            //still negative bgztmp also dotproduct was proofed!!!
            if bgztmp < 0 then Continue;
            bgztmp := (8388352 - MCTparas.ZcMul * (Sqrt(bgztmp / MCTparas.StepWidth * MCTparas.Zcorr + 1) - 1)) * d1d256;
            bgztmp := Max0S(1 + (Min0MaxCS(bgztmp, 32767) - 28000) * sDepth);

            if bgztmp < 1 then //for depthfog
            begin
              if LVals.bCalcPixColSqr then bgztmp := Sqr(1 - bgztmp)
                                      else bgztmp := 1 - bgztmp;
              if bFarFog then bgztmp := Sqr(bgztmp);
              bgztmp := 1 - bgztmp * 0.9;
            end;
          end
          else bgztmp := bgZ * 0.9 + 0.1;

                           //flux transp
    //      CalcPosLightShapeMC(sTmp, ldis, ir);
          CalcPosLightShape(sTmp, ldis, ir, @LVals);
          //todo: dynfog if blended

          AddSVecWeight(@Result, @PLValigned.sLCols[ir], sTmp * s1d255 * bgztmp * BGdecrease);
          BGdecrease := BGdecrease * MinCS(1, ldis);
        end;
      end;
      dFog := (sDynFog - sShad - sShadZmul * ZposDynFog) * sShadGr;
      if (bDFogOptions and 2) <> 0 then dFog := Max0S(dFog);

      sTmp := MinCS(1, sDynFog * sDynFogMul) * dFog;
      AddSVecWeight(@Result, @sVBG, Max0S(1 - bgZ));
      if (bDFogOptions and 1) <> 0 then
      begin
        Clamp01Svar(dFog);
        Clamp01Svar(sTmp);
        ScaleSVectorV(@Result, 1 - dFog);
        DepthDec := DepthDec * (1 - dFog);
      end;
   //   DepthDec := MinCS(1, DepthDec);
   //   BGdecrease := BGdecrease * DepthDec;   //not if addBGpic light!!!
      AddSVectors(@Result, Add2SVecsWeight(PLValigned.sDynFogCol, PLValigned.sDynFogCol2,
                                        (dFog - sTmp) * s1d255, sTmp * s1d255));
       //todo: before pos-vislights + calc in vislights again
    end;
end;

function TMCCalcThread.CalcBGLight(Vec: TPVec3D; const UseAmbLight, bNNipolBG: LongBool): TSVec;
var dTmp, dTmp2, ypos, xpos: Single;
    tmpVec: TVec3D;
    sv: TSVec;
    ps: TPSVec;
    itmp2: Integer;
begin
    with LVals do
    begin
      mCopyVec(@tmpVec, Vec);
      if bBackBMP then  //background bmp
      begin
        if bDirectImageCoord then //not spherical
        begin
          RotateVector(@tmpVec, @MCTparas.VGrads);
          NormaliseVectorVar(tmpVec);
          dTmp2 := MCTparas.iMandHeight * FOVy1d / MCTparas.iMandWidth;
          if bRit1 then
          begin  //direct background image, x+y should be correct
            case MCTparas.MCTCameraOptic of
         1: begin
              dTmp := MCTparas.mctPlOpticZ / NonZero(tmpVec[2]); //Div0!!
              ypos := tmpVec[1] * dTmp * FOVy1d + s05;
              xpos := tmpVec[0] * dTmp2 * dTmp + s05;
            end;
         2: begin
              ypos := ArcSinSafe(tmpVec[1]) * FOVy1d + s05;
              xpos := ArcTan2(tmpVec[0], tmpVec[2]) * Pi05d + s05;
            end;
            else
            begin
              dTmp := Sqrt(s05 + Sqrt(0.25 + Sqr(tmpVec[0] * tmpVec[1])));
              ypos := ArcSinSafe(tmpVec[1] * dTmp) * FOVy1d + s05;
              xpos := ArcSinSafe(tmpVec[0] * dTmp) * dTmp2 + s05;
            end;
            end;
          end
          else
          begin
            ypos := ArcSinSafe(tmpVec[1]) * FOVy1d + s05;
            dTmp := MCTparas.FOVy / MaxCD(0.1, PiM2 - MCTparas.FOVy);
            if ypos > 1 then
            begin
              ypos := 1 + dTmp * (1 - ypos);
              if ypos < 0.75 then ypos := 1.5 - ypos;  //wrap twice to go to the top/bottom again, not to the middle like in xpos
            end
            else if ypos < 0 then
            begin
              ypos := Abs(ypos) * dTmp;
              if ypos > 0.25 then ypos := s05 - ypos;
            end;
            xpos := ArcTan2(tmpVec[0], tmpVec[2]) * dTmp2 + s05;
            dTmp := 1 / (dTmp2 * MaxCD(0.1, piM2 - 1 / dTmp2));
            if xpos > 1 then xpos := 1 + dTmp * (1 - xpos) else
            if xpos < 0 then xpos := Abs(xpos) * dTmp;
          end;
          Clamp01Svar(ypos);
          Clamp01Svar(xpos);
          if bNNipolBG then Result := GetLightMapPixelNN(xpos, ypos, BGLightMap, bCalcPixColSqr, 0)
                       else Result := GetLightMapPixel(xpos, ypos, BGLightMap, bCalcPixColSqr, 0);
        end
        else if bNNipolBG then
          Result := GetLightMapPixelSphereNN(DVecToSVec(tmpVec), @BGLightMap.PicRotMatrix, BGLightMap, bCalcPixColSqr)
        else Result := GetLightMapPixelSphere(DVecToSVec(tmpVec), @BGLightMap.PicRotMatrix, BGLightMap, bCalcPixColSqr);
      end
      else
      begin
        if not bAmbRelObj then RotateVector(@tmpVec, @MCTparas.VGrads);
        NormaliseVectorVar(tmpVec);
        if UseAmbLight then
        begin
          dTmp := {Clamp01D}(tmpVec[1] * s05 + s05);
          ps := @PLValigned.sAmbCol;
        end
        else
        begin  //depth cols
          if not bAmbRelObj then
          begin
            if bRit1 then dTmp := MCTparas.PCalcThreadStats.CTrecords[MCTparas.iThreadId].iActualYpos / MCTparas.iMandHeight
                     else dTmp := Clamp01D(ArcSinSafe(tmpVec[1]) * FOVy1d + s05);
          end
          else dTmp := Clamp01D(ArcSinSafe(tmpVec[1]) * Pi1d + s05);
          if not bAmbRelObj then
          case iDfunc of
            1: dTmp := Sqr(dTmp);
            2: dTmp := Sqrt(dTmp);
          end;
          ps := @PLValigned.sDepthCol;
        end;
    {    if bRit1 and not bAmbRelObj then
          dTmp := MCTparas.PCalcThreadStats.CTrecords[MCTparas.iThreadId].iActualYpos / MCTparas.iMandHeight
        end;   }
        Result := ScaleSVector(LinInterpolate2SVecs(TPSVec(Integer(ps) + 16)^, ps^, dTmp), d1d256);
      end;
      if UseAmbLight then for itmp2 := 0 to 5 do   //lightmaps added here
      if LVals.iLightOption[itmp2] = 2 then  //LightMap
      begin
        sv := DVecToSVec(Vec^);
        RotateSVectorReverse(@sv, @MCTparas.VGrads);
        AddSVectors(@Result, GetLightMapPixelSphereNN(sv, @LLightMaps[itmp2].PicRotMatrix, LLightMaps[itmp2], bCalcPixColSqr));
      end;
    end;
end;

function TMCCalcThread.CalcPhongLight(siLight: TPsiLight5; ReflectVec: TPVec3D): TLightSD;
var itmp2: Integer;
    s1, s2, stmp: Single;
    dTmp: Double;
    LightSD: TLightSD;
    tmpSVec: TSVec;
    tVec: TVec3D;
    tmpVecs: array[0..5] of TVec3D;
begin
    ClearSVec(Result[0]);
    ClearSVec(Result[1]);

    for itmp2 := 0 to 5 do if LVals.iLightOption[itmp2] = 0 then   //vary lightvecs to simulate lightsource radius
    begin
      mCopyVec(@tmpVecs[itmp2], @MCTparas.HSvecs[itmp2]);
      if (LVals.iLightPos[itmp2] and 1) <> 0 then
      begin
        if (LVals.iLightPos[itmp2] and 14) in [2, 8] then dTmp := Sqr(GetRand) * 1e-4 * MCTparas.SoftShadowRadius
                                                     else dTmp := Sqrt(GetRand) * 3e-4 * MCTparas.SoftShadowRadius;
        tmpSVec := NormaliseSVectorToS2(Sqrt(LVals.sLmaxL[itmp2]) * dTmp, GenSphereSVecOm);
        MCTparas.HSVecs[itmp2] := AddSVec2Vec3(@tmpSVec, @tmpVecs[itmp2]);
      end
      else   //global light
      begin
        if not bDoDOF then
        begin
          stmp := HaltonDiscX;
          s1 := HaltonDiscY;
        end else begin
          stmp := GetRand;
          s1 := GetRand;
        end;
        SinCosS(piM2 * s1, s1, s2);
        if (LVals.iLightPos[itmp2] and 14) = 8 then dTmp := 1e-5 else dTmp := 2.5e-5; //0.5
        dTmp := Sqrt(stmp) * Sqrt(LVals.sLmaxL[itmp2]) * dTmp * MCTparas.SoftShadowRadius * MCTparas.StepWidth;
        MakeOrthoVecs(@tmpVecs[itmp2], @LightSD);
        MCTparas.HSvecs[itmp2] := NormaliseVectorTo(MCTparas.StepWidth,
           AddVecF(SVecToDVec(AddSVectors(ScaleSVector(LightSD[0], s1 * dTmp),
                                          ScaleSVector(LightSD[1], s2 * dTmp))), tmpVecs[itmp2]));
      end;
    end;

    CalcHSMC;  //6 SVecs for coloring through object[1,1,1], multiplied by light amount

    for itmp2 := 0 to 5 do if LVals.iLightOption[itmp2] = 0 then
    begin
      tmpSVec := HS6[itmp2];
      if NotZeroSVec(@tmpSVec) then
      begin
        LightSD[0] := LVals.PLValigned.sLCols[itmp2];
        if (LVals.iLightPos[itmp2] and 1) <> 0 then
        begin
          tVec := SubtractVectors(@Iteration3Dext.C1, tmpVecs[itmp2]);
          ScaleSVectorV(@LightSD[0], 1 / (SqrLengthOfVec(tVec) + 1e-26));
          NormaliseVectorTo(MCTparas.StepWidth, @tVec);
        end
        else mCopyVec(@tVec, @tmpVecs[itmp2]);
        MultiplySVectorsV(@LightSD[0], @tmpSVec);          //spec light decrease more by anglechange...vec[3]!!
        AddSVecWeightS(@Result[0], @LightSD[0], FastIntPow(DotOfVectors(ReflectVec, @tVec) * tmpSVec[3] /
                       -Sqr(MCTparas.StepWidth), LVals.iLightPowFunc[itmp2]) * LVals.sSpec * s1d255);
        AddSVecWeightS(@Result[1], @LightSD[0], Sqr(MaxCD(0, DotOfVectors(@Normals, @tVec) /
                       -MCTparas.StepWidth)) * LVals.sDiff * s1d255);
      end;
      mCopyVec(@MCTparas.HSvecs[itmp2], @tmpVecs[itmp2]);
    end;
end;

function TMCCalcThread.CalcPhongLightNoHS(siLight: TPsiLight5; ReflectVec: TPVec3D): TLightSD;
var itmp2: Integer;
    SLight: TSVec;
    Vec: TVec3D;
begin
    with MCTparas do
    begin
      ClearSVec(Result[0]);
      ClearSVec(Result[1]);
      for itmp2 := 0 to 5 do
      begin
        if LVals.iLightOption[itmp2] = 0 then
        begin
          if (LVals.iLightPos[itmp2] and 1) <> 0 then
          begin
            Vec := SubtractVectors(@Iteration3Dext.C1, HSvecs[itmp2]);
            SLight := ScaleSVector(LVals.PLValigned.sLCols[itmp2], 1 / (SqrLengthOfVec(Vec) + 1e-60));
            NormaliseVectorTo(StepWidth, @Vec);
          end
          else
          begin
            SLight := LVals.PLValigned.sLCols[itmp2];
            Vec := HSvecs[itmp2];
          end;
          AddSVecWeightS(@Result[0], @SLight, FastIntPow(DotOfVectors(ReflectVec, @Vec) /
                         -Sqr(StepWidth), LVals.iLightPowFunc[itmp2]) * LVals.sSpec * s1d255);
          AddSVecWeightS(@Result[1], @SLight, Sqr(MaxCD(0, DotOfVectors(@Normals, @Vec) /
                         -StepWidth)) * LVals.sDiff * s1d255);
        end;
      end;
      mCopyVec(@Vec, @Normals);     //add BG ambient light  ... LightMaps already included
      VaryVecSphere(@Vec);
      SLight := CalcBGLight(@Vec, True, True);
      AddSVecWeightS(@Result[1], @SLight, LVals.sDiff);
    end;
end;

function TMCCalcThread.AddLight(camPos, vPos: TSVec): TSVec; //for inside light scattering
var itmp: Integer;
    stmp, stmp2, stmp3, d2, d3: Single;
    sv, sv2, sv3: TSVec;
begin
    with LVals do
    begin
      ClearSVec(Result);
      for itmp := 0 to 5 do if iLightOption[itmp] = 0 then //light on
      begin
        if (iLightPos[itmp] and 1) <> 0 then //positional light
        begin    //calculate shortest distance from line segment to position of light:
          sv := SubtractSVectors(@vPos, camPos);
          sv2 := SubtractSVectors(@PLValigned.LN[itmp], camPos);
          sv3 := SubtractSVectors(@PLValigned.LN[itmp], vPos);
          stmp3 := sStepWidth * sStepWidth;
          d2 := SqrLengthOfSVec(sv2) + stmp3;
          d3 := SqrLengthOfSVec(sv3) + stmp3;
          stmp := DotOfSVectors(sv2, sv);
          if stmp <= 0 then stmp := 0.25 / d3 + 1 / d2 else
          begin
            stmp2 := SqrLengthOfSVec(sv);
            if stmp2 <= stmp then stmp := 0.25 / d2 + 1 / d3 else
            stmp := 1 / (SqrLengthOfSVec(SubtractSVectors(@PLValigned.LN[itmp],
              AddSVectors(camPos, ScaleSVector(sv, stmp / stmp2)))) + stmp3) + 0.25 / MaxCS(d3, d2);
          end;
        end
        else stmp := 1;
        AddSVecWeights(@Result, @PLValigned.sLCols[itmp], stmp);
      end;
      MultiplySVectorsV(@Result, @tmpObjCol[1]);
    end;
end;
    {      dStep := MaxCS(s011, (dTmp - msDEsub * msDEstop) * sZstepDiv * RSFmul);
          d1 := MaxCS(msDEstop, 0.4) * mctMH04ZSD;
          if d1 < dStep then
          begin
            if DFogOnIt = 0 then sDynFog := sDynFog + d1 / dStep else
            if Iteration3Dext.ItResultI = DFogOnIt then sDynFog := sDynFog + d1 / dStep;
            dStep := d1;
          end
          else if DFogOnIt = 0 then sDynFog := sDynFog + 1 else
            if Iteration3Dext.ItResultI = DFogOnIt then sDynFog := sDynFog + 1;
        end;  }

procedure TMCCalcThread.DoDynFog(var actDE: Double; var StepCount: Single; const RSFmul, LastStepWidth: Single);
var s1, st: Single;
    d1, d2: Double;
    v: TVec3D;
    vs: TSVec;
begin
    actDE := MaxCS(s011, (actDE - MCTparas.msDEsub * MCTparas.msDEstop) * MCTparas.sZstepDiv * RSFmul);
    s1 := MaxCS(MCTparas.msDEstop, 0.4) * MCTparas.mctMH04ZSD;
    d2 := Sqr(MCTparas.StepWidth);
    if s1 < actDE then actDE := s1;
    mCopyAddVecWeight(@v, @Iteration3Dext.C1, @MCTparas.mVgradsFOV, -LastStepWidth);
    s1 := (1 + MCTparas.mZZ * MCTparas.mctDEstopFactor) * MCTparas.VLstepmul;
    st := LastStepWidth;
    repeat
      if s1 > st then s1 := st;
      mAddVecWeight(@v, @MCTparas.mVgradsFOV, s1);
      st := st - s1;
      if VolumeLightMap.IsPosLight then
      begin
        vs := SubtractVectors2s(v, VolumeLightMap.LightPos);
        d1 := SqrLengthOfSVec(vs);
        if Sqr(GetVolLightMapVec(@vs)) > d1 then
          StepCount := StepCount + MCTparas.VLmul * s1 / (d1 + d2);
      end
      else if VolLightMapPos(@v) then StepCount := StepCount + MCTparas.VLmul * s1;
{      vd := SubtractVectors(v, VolumeLightMap.LightPos);
      d1 := SqrLengthOfVec(vd);
      if Sqr(GetVolLightMapVec(@vd)) > d1 then
        StepCount := StepCount + MCTparas.VLmul * s1 / (d1 + d2);  }
    until st < s001;
end;

procedure TMCCalcThread.CalcRay(ZZ: Double; VgradsFOVit: TVec3D; tAbsorb: TSVec; Rit: Integer);  //iterative
var itmp: Integer;
    DElimited, OpenAir, bFirstStep, bCalcT: LongBool;
    RSFmul, BGdec: Single;
    crPsiLight: TPsiLight5;
    siLight: TsiLight5;
    d1, d2, d3, d4: Single;
    RLastStepWidth, dTmp, dStep, ZZplus, ZZ2, RLastDE, MaxL: Double;
    tmpVec, CC, tVec2, NVec: TVec3D;
    Vpos, SVec, SVec2: TSVec;
    LightSD, ObjColor: TLightSD;
label skip1, skip2;
begin
    with MCTparas do
    begin
      if (Abs(tAbsorb[0]) * s03 + Abs(tAbsorb[1]) * s059 + Abs(tAbsorb[2]) * s011 < 1e-4) then Exit;

      if bCalcAmbShadow then MaxL := AMBmaxL * (Sqr(GetRand) + 0.75) else MaxL := Zend;
      Inc(Rit);
      bRit1 := Rit = 1;
      if bRit1 then
      begin
        crPsiLight := mPsiLight;
        ZZ2 := ZZ;
      end
      else
      begin
        if (iCutOptions <> 0) then minLengthToCutPlane(MaxL, 0.1, @Iteration3Dext.C1, @VgradsFOVit);
        crPsiLight := @siLight;
        ZZ2 := 0;
      end;

      if not bCalcTrans then bCalcTransR := False else
      if not bOnlyDIFS then bCalcTransR := True else
      begin
        CalcDE(@Iteration3Dext, @MCTparas);  //if in air?
        bCalcTransR := DEoptionResult = 20;
      end;
      bCalcT := bCalcTransR;
      BGdec := 1;
      sDynFog := 0;
      msDEstop := DEstop * (1 + Abs(ZZ) * mctDEstopFactor);
      OpenAir := False;

      Vpos := DVecToSVec(SubtractVectors(pStartPos, TPVec3D(@Xmit)^));
      ZZplus := DotOfVectors(@VgradsFOVit, @mVgradsFOV) / (StepWidth * StepWidth);
      pStartPos := @Iteration3Dext.C1;

      DElimited := True;
      bFirstStep := True;
      RSFmul := 1;
      dTmp := CalcDE(@Iteration3Dext, @MCTparas);
      RLastStepWidth := dTmp * sZstepDiv;
      repeat
        RLastDE := dTmp;

        if DFogOnIt = 65535 then
        begin
          dStep := dTmp;
          mZZ := Abs(ZZ);
          DoDynFog(dStep, sDynFog, RSFmul, RLastStepWidth);
        end
        else
        begin
          dStep := MaxCS(s011, (dTmp - msDEsub * msDEstop) * sZstepDiv * RSFmul);
          d1 := MaxCS(msDEstop, 0.4) * mctMH04ZSD;
          if d1 < dStep then
          begin
            if DFogOnIt = 0 then sDynFog := sDynFog + d1 / dStep else
            if Iteration3Dext.ItResultI = DFogOnIt then sDynFog := sDynFog + d1 / dStep;
            dStep := d1;
          end
          else if DFogOnIt = 0 then sDynFog := sDynFog + 1 else
            if Iteration3Dext.ItResultI = DFogOnIt then sDynFog := sDynFog + 1;
        end;

        if bFirstStep then
        begin
          bFirstStep := False;
          dStep := GetRand * dStep;
        end;
        RLastStepWidth := dStep;

        ZZ2 := ZZ2 + dStep;
        if ZZ2 > MaxL then
        begin
          if DFogOnIt = 65535 then
          begin
            dStep := MaxL - ZZ2 + dStep;
            mAddVecWeight(@Iteration3Dext.C1, @VgradsFOVit, dStep);
            DoDynFog(RLastDE, sDynFog, RSFmul, dStep);
          end;
          OpenAir := True;
          Break;
        end;
        mAddVecWeight(@Iteration3Dext.C1, @VgradsFOVit, dStep);
        ZZ := ZZ + dStep * ZZplus;
        msDEstop := DEstop * (1 + Abs(ZZ) * mctDEstopFactor);
        dTmp := CalcDE(@Iteration3Dext, @MCTparas);
        if Iteration3Dext.ItResultI >= MaxItsResult then
        begin
          DElimited := False;
          Break;
        end;
        if (dTmp < msDEstop) and (Iteration3Dext.ItResultI >= iMinIt) then Break;

        if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;
        if RLastDE > dTmp + s1em30 then
        begin
          dStep := RLastStepWidth / (RLastDE - dTmp);
          if dStep < 1 then RSFmul := maxCS(s05, dStep)
                       else RSFmul := 1;
          end
        else RSFmul := 1;
      until PCalcThreadStats.pLBcalcStop^;

      if PCalcThreadStats.pLBcalcStop^ then Exit;

      if bInsideRendering and (DFogOnIt < 65535) then sDynFog := sDynFog * 200 * DEstop / iMandWidth;

      if not OpenAir then   
      begin
        PMCrecord.Zbyte := PMCrecord.Zbyte or 128;  //not background, object hit..
        if DElimited then   // secant mode
        begin
          if bSecantSearch then
          begin
            itmp := 4;
            while (itmp > 0) and (Abs(dTmp - msDEstop) > s0001) do
            begin
              RLastDE := NotZero(RLastDE - dTmp);
              RSFmul := RLastStepWidth * (dTmp - msDEstop) / RLastDE;
              if dTmp < msDEstop then
              begin
                if (RSFmul >= 0) or (RSFmul < Abs(RLastStepWidth) * -0.94) then
                  RLastStepWidth := Abs(RLastStepWidth) * sm05
                else RLastStepWidth := RSFmul;
              end else begin
                if (RSFmul <= 0) or (RSFmul > Abs(RLastStepWidth) * 0.94) then
                  RLastStepWidth := Abs(RLastStepWidth) * s05
                else RLastStepWidth := RSFmul;
              end;
              RLastDE := dTmp;
              ZZ := ZZ + RLastStepWidth * ZZplus;
              mAddVecWeight(@Iteration3Dext.C1, @VgradsFOVit, RLastStepWidth);
              msDEstop := DEstop * (1 + Abs(ZZ) * mctDEstopFactor);
              Dec(itmp);
              if itmp <= 0 then Break;
              dTmp := CalcDE(@Iteration3Dext, @MCTparas);
            end;
          end
          else    //binsearch
          begin
            itmp := 10;
            dStep := RLastStepWidth * sm05;
            while Abs(dTmp - msDEstop) > s0001 do
            begin
              ZZ := ZZ + dStep * ZZplus;
              mAddVecWeight(@Iteration3Dext.C1, @VgradsFOVit, dStep);
              msDEstop := DEstop * (1 + Abs(ZZ) * mctDEstopFactor);
              Dec(itmp);
              if itmp <= 0 then break;
              dTmp := CalcDE(@Iteration3Dext, @MCTparas);
              if dTmp < msDEstop then dStep := Abs(dStep) * -0.55
                                 else dStep := Abs(dStep) * 0.55;
            end;
          end;
        end
        else
        begin
          dStep := ZZ;
          doBinSearchIt(dStep, @VgradsFOVit);
          ZZ := ZZ + (dStep - ZZ) * ZZplus;
        end;
        mZZ := Abs(ZZ);
        if NormalsOnDE then CalculateNormals(RSFmul, @VgradsFOVit)
                       else CalculateNormalsOnSmoothIt(RSFmul, @VgradsFOVit);

        if DElimited then RSFmul := 32767 - (RSFmul + dColPlus + mctColVarDEstopMul * ln(msDEstop * StepWidth)) * mctsM
                     else RSFmul := 32767 - RSFmul * mctsM;
        MinMaxClip15bit(RSFmul, crPsiLight.SIgradient);
//LabelObject:
        mCopyVec(@CC, @Iteration3Dext.C1);
        itmp := Integer(mPsiLight);
        mPsiLight := crPsiLight;
        if ColorOnIt <> 0 then RMdoColorOnIt(@MCTparas);
        RMdoColor(@MCTparas);
        mPsiLight := TPsiLight5(itmp);
        CalcZposAndRough(crPsiLight, @MCTparas, ZZ2);
        ObjColor := CalcColor(crPsiLight, mZZ * StepWidth + sZZstmitDif);   //dif+spec holds colors  zPos for ColZmultiplier, must be ZZ
        LVals.ZposDynFog := ZZ2 * StepWidth + sZZstmitDif;
        SVec := CalcVisLights(VPos, @VgradsFOVit, crPsiLight, BGdec, d1);
    //    BGdec := BGdec * d1;
        AddSVectors(@TotalLight, MultiplySVectors(SVec, tAbsorb));
      end
      else   //OpenAir
      begin
//LabelOpenAir:
        LVals.ZposDynFog := Zend * StepWidth + sZZstmitDif;
        if (LVals.bFarFog or LVals.bCalcPixColSqr) and (Abs(LVals.sDepth) > 1e-10) then
        begin
          d1 := 1 - Max0S(1 + (Integer(mPsiLight.Zpos) - 28000) * LVals.sDepth); //first depthfog (better max depthfog?)
          if d1 > 0 then
          begin
            d1 := Sqr(d1);
            if LVals.bFarFog and LVals.bCalcPixColSqr then d1 := Sqr(d1);
          end;
          d2 := 1 - Max0S(1 - 28000 * LVals.sDepth); //depthfog@inf
          if d2 > 0 then
          begin
            d2 := Sqr(d2);
            if LVals.bFarFog and LVals.bCalcPixColSqr then d2 := Sqr(d2);
          end;
          d1 := d2 - d1; //depthFog to add...  = 1 - MaxCS(0, 1 - (60768 - Integer(PsiLight.Zpos)) * sDepth);
          if d1 > 0 then
          begin
            d1 := Sqrt(d1);
            if LVals.bFarFog and LVals.bCalcPixColSqr then d1 := Sqrt(d1);
          end;
          crPsiLight.Zpos := Round(MinMaxCS(32768, 60768 - d1 / LVals.sDepth, 65535));
        end
        else crPsiLight.Zpos := 32768;

        SVec := CalcVisLights(VPos, @VgradsFOVit, crPsiLight, BGdec, RSFmul);
        ObjColor[0] := CalcBGLight(@VgradsFOVit, bCalcAmbShadow, bDiffReflectsBigEnough and not bRit1);
        if (not LVals.bBackBMP) or (not LVals.bAddBGlight) then BGdec := BGdec * RSFmul;
        math3D.AddSVecWeight(@SVec, @ObjColor[0], BGdec);

        if bCalcT and (not bInAndOutside) and (bTransFlipInside xor bInsideRendering) then
        begin //inside  light scattering
          SVec2 := SVecPow(tmpObjCol[1], MinCD(ZZ2, MaxL) * sAbsorption);
          MultiplySVectorsV(@tAbsorb, @SVec2);
          RSFmul := (1 - YofSVec(@SVec2)) * sLightScatteringMul;
          if PInteger(@RSFmul)^ <> 0 then
          AddSVectors(@TotalLight, MultiplySVectors(ScaleSVector(MultiplySVectors(AddLight(Vpos,
            DVecToSVec(SubtractVectors(@Iteration3Dext.C1, TPVec3D(@Xmit)^))),
            tmpObjCol[1]), RSFmul), tAbsorb));
        end;
        AddSVectors(@TotalLight, MultiplySVectors(SVec, tAbsorb));
        Exit;
      end;

      if bCalcT and (not bInAndOutside) and (bTransFlipInside xor bInsideRendering) then   //absorption inside material  ..not if inandoutside! -> no transp
      begin      //from previous obj color
        SVec := SVecPow(tmpObjCol[1], MinCD(ZZ2, MaxL) * sAbsorption);
        SVec2 := tAbsorb;
        RSFmul := (1 - YofSVec(@SVec)) * sLightScatteringMul;
        MultiplySVectorsV(@tAbsorb, @SVec);
        TotalLight := Add2SVecsWeight2(TotalLight, MultiplySVectors(AddLight(Vpos,
            DVecToSVec(SubtractVectors(@Iteration3Dext.C1, TPVec3D(@Xmit)^))),
                        LinInterpolate2SVecs(tAbsorb, SVec2, s05)), RSFmul);
        d1 := 1;
      end
      else ScaleSVectorV(@tAbsorb, BGdec * d1);

      tmpVec := SubtractVectors(@VgradsFOVit, ScaleVector(Normals, 2 * DotOfVectors(@Normals, @VgradsFOVit)));  //reflected ray
      mZZ := ZZ;

    //  bCalcT := bCalcTransR;
      if not bCalcTrans then bCalcT := False else
      if not bOnlyDIFS then bCalcT := True else
      begin
      {  mCopyVec(@Iteration3Dext.C1, @CC);//test
        CalcDE(@Iteration3Dext, @MCTparas);     }
        bCalcT := DEoptionResult = 20;
      end;
      LightSD := CalcPhongLight(crPsiLight, @tmpVec);
  //    mCopyVec(@Iteration3Dext.C1, @CC);//test

      d2 := 1; //diffuse + ambient decrease if transp

      if bCalcT then
      begin
        RSFmul := MaxOfSVec(@ObjColor[0]);
        if (not bInAndOutside) and (bTransFlipInside xor bInsideRendering) then
          dStep := TransDiConst else dStep := 1 / TransDiConst;
        dTmp := LengthOfVec(VgradsFOVit);
        if dTmp < d1em100 then Exit; //test for issues
        d3 := -DotOfVectors(@VgradsFOVit, @Normals) / dTmp;       //fp    dTmp = 0???  VGrads = 0,0,0
        ZZ2 := 1 - dStep * dStep * (1 - d3 * d3);
        if ZZ2 <= 0 then
        begin  //total internal reflection
          d3 := 1 - ObjColor[0][3] + Sqr(ObjColor[0][3]) / (RSFmul + s001); //??
          bCalcT := False;
        end
        else
        begin
          tVec2 := NormaliseVectorTo(dTmp, SubtractVectors(VgradsFOVit,
            ScaleVector(Normals, dTmp / dStep * (Sqrt(ZZ2) - dStep * d3))));
          dTmp := Abs(DotOfVectors(@tVec2, @Normals)) / dTmp;
          d4 := Abs(d3);    //calc reflective amount, n1=1 n2=dStep
          if Abs(dTmp) > 1e-16 then
          d4 := (Sqr((d4 - dStep * dTmp) / (d4 + dStep * dTmp)) +         //fp   d4,dtmp=0 !!!
                 Sqr((dTmp - dStep * d4) / (dTmp + dStep * d4))) * s05;
          d3 := d4 + (1 - d4) * (1 - ObjColor[0][3]);
          if bInAndOutside then mCopyVec(@tVec2, @VgradsFOVit); //dont't change vec
        end;
        d2 := 1 - ObjColor[0][3] * SRLightAmount;
      end
      else d3 := 1;

      AddSVectors(@TotalLight, MultiplySVectors(       //not that big downscale for spec phong
        AddSVectors(MultiplySVectors(ScaleSVector(ObjColor[0], (s025 + d3) * 0.8), LightSD[0]),
        MultiplySVectors(ScaleSVector(ObjColor[1], d2), LightSD[1])), tAbsorb));

      if d1 > 1 then ScaleSVectorV(@tAbsorb, 1 / d1);

      mCopyVec(@NVec, @Normals); // save for ambient vec calc

      if Rit <= MaxSpecDepth then
      begin
        if bCalcReflects then
        begin
          tmpObjCol := ObjColor;
          bFirstStep := bCalcAmbShadow;  //backup
          if iDiffReflects > 0 then
          begin
            MakeOrthoVecs(@tmpVec, @LightSD);
            SinCosD(piM2 * GetRand, ZZ2, RLastDE);
            MaxL := GetRand * iDiffReflects * 0.00004;
            d1 := Sqrt(MaxL) * StepWidth;
            tmpVec := NormaliseVectorTo(StepWidth,
                      AddVecF(SVecToDVec(AddSVectors(ScaleSVector(LightSD[0], ZZ2 * d1),
                                                     ScaleSVector(LightSD[1], RLastDE * d1))),
                              ScaleVector(tmpVec, Sqrt(1 - MaxL))));
            if DotOfVectors(@tmpVec, @Normals) <= 0 then goto skip1;
          end;
          CalcRay(ZZ, tmpVec, MultiplySVectors(tAbsorb, ScaleSVector(ObjColor[0], d3 * SRLightAmount)), Rit);
          bCalcAmbShadow := bFirstStep;
        end;
skip1:  if bCalcT then    //transp go in
        begin
          if iDiffReflects > 0 then
          begin
            MakeOrthoVecs(@tVec2, @LightSD);
            SinCosD(piM2 * GetRand, ZZ2, RLastDE);
            MaxL := GetRand * iDiffReflects * 0.00004;
            d1 := Sqrt(MaxL) * StepWidth;
            tVec2 := NormaliseVectorTo(StepWidth,
                     AddVecF(SVecToDVec(AddSVectors(ScaleSVector(LightSD[0], ZZ2 * d1),
                                                    ScaleSVector(LightSD[1], RLastDE * d1))),
                             ScaleVector(tVec2, Sqrt(1 - MaxL))));
            if DotOfVectors(@tVec2, @NVec) >= 0 then goto skip2;
          end;         //maxofSpecCol
          d4 := (1 - d4 * RSFmul) * ObjColor[0][3];
          mCopyVec(@Iteration3Dext.C1, @CC);
          tmpObjCol := ObjColor;
          bFirstStep := bCalcAmbShadow;
          bInsideRendering := not bInsideRendering;  //step in/out
          bCalcInside := not bCalcInside;
          CalcRay(ZZ, tVec2, ScaleSVector(tAbsorb, d4 * SRLightAmount), Rit);
          bCalcAmbShadow := bFirstStep;
          bInsideRendering := not bInsideRendering;
          bCalcInside := not bCalcInside;
        end;
      end;
skip2:
      if (Rit < MaxAmbDepth) or not bCalcAmbShadow then
      begin
        if not bCalcAmbShadow then
        begin
          SinCosS(piM2 * HaltonX, d4, d3);
          MaxL := HaltonY;
        end else begin
          SinCosS(piM2 * GetRand, d4, d3);
          MaxL := GetRand;
        end;
        d1 := Sqrt(MaxL);
        MakeOrthoVecs(@NVec, @LightSD);
        NVec := NormaliseVectorTo(StepWidth,
                AddVecF(SVecToDVec(AddSVectors(ScaleSVector(LightSD[0], d3 * d1),
                                               ScaleSVector(LightSD[1], d4 * d1))),
                        ScaleVector(NVec, Sqrt(1 - MaxL))));
        mCopyVec(@Iteration3Dext.C1, @CC);
        tmpObjCol := ObjColor;
        bCalcAmbShadow := True; //do not calculate visible lights in ambient, is in phong light
        CalcRay(ZZ, NVec, MultiplySVectors(tAbsorb, ScaleSVector(ObjColor[1], d2)), Rit);    //d2 amb descaler if transp
      end;
    end;
end;

{  TMCrecord = packed record
    Red, Green, Blue: TRGB;   //Each of them 24 bit: float 0..4 (-1..7(3))? stretched to 24 bit int
    Ysum, Ysqr: TRGB;
    RayCount: Word;
    Zbyte: Byte;     //for noise filtering .. maybe sign of ambient/HS noise to calc more counts..
  end;
  TPMCrecord = ^TMCrecord;  }

procedure TMCCalcThread.GetSubPixelShift(var xx, yy: Single); // ~ -0.5..05
var r: Single;
begin
    if not bGaussAA then
    begin
      xx := GetRand - s05;
      yy := GetRand - s05;
    end
    else
    begin
      repeat
        xx := GetRand * 2 - 1;
        yy := GetRand * 2 - 1;
        r := xx * xx + yy * yy;
      until r <= 1;
      r := r * 0.99 + s001;
      r := Sqrt(-2 * ln(r) / r) * s05;   //~Normal-distribution
      xx := xx * r;
      yy := yy * r;
    end;
end;

procedure TMCCalcThread.Execute;
var itmp, x, y, itcount, TotalItCount, MaxNewCounts: Integer;
    bInsideTmp: LongBool;
    xx, yy: Single;
    dTmp, ZZ, sqrLightSum, LightSum: Double;
    Light, sv, LightSDAt: TSVec;
    tmpV: TVec3D;
    LightSD, LightSD2: TLightSD;
    SiLight: TsiLight5;
label ll0, ll1, ll2;
begin
    with MCTparas do
    try
      IniIt3D(@MCTparas, @Iteration3Dext);
      MaxNewCounts := Round((AvrgRCount + Sqr(AvrgRCount) * 0.2) * 10);
      HSmaxLmul := (iMandWidth + iMandHeight) * 0.6 * sHSmaxLengthMultiplier;
      bInsideTmp := bInsideRendering;
      bTransFlipInside := bInsideRendering;
{$IFDEF DEBUG} {$Q-} {$R-} {$ENDIF}
      seed := Round(Random * (iThreadId + 1) * $324594A1 + $24563487);
{$IFDEF DEBUG} {$Q+} {$R+} {$ENDIF}
      y := CalcRect.Top + iThreadId - 1;
      while y < iMandHeight do
      begin
        PCalcThreadStats.CTrecords[iThreadId].iActualYpos := y;
        PMCrecord := TPMCrecord(Integer(pSiLight) + y * SLoffset);
        for x := 1 to iMandWidth do
        begin
          PCalcThreadStats.CTrecords[iThreadId].iActualXpos := x - 1;
          if PMCrecord.RayCount = 0 then TotalItCount := 4 else
          if bSkipNonZeroC then
          begin
            Inc(PMCrecord);
            Continue;
          end
          else TotalItCount := CalcN(x, y + 1, PMCrecord);
ll0:   //   TotalItCount := 100; //dof rand test
          if TotalItCount + PMCrecord.RayCount > 65535 then
            TotalItCount := 65535 - PMCrecord.RayCount;
          ClearSVec(LightSDAt);
          itcount := 0;
          sqrLightSum := 0;
          LightSum := 0;
          if TotalItCount > 0 then
          repeat
            iActRayNr := PMCrecord.RayCount + itcount;
            GetHalton2Dshifts(HaltonShiftX, HaltonShiftY, x, y);
            itmp := Integer(@HaltonSequence[iActRayNr]);
            HaltonX := FracSingle(PHaltonRec(itmp).HRx * d1d65535 + HaltonShiftX);
            HaltonY := FracSingle(PHaltonRec(itmp).HRy * d1d65535 + HaltonShiftY);
            mPsiLight := @SiLight;
            bInsideRendering := bInsideTmp;
            bCalcInside := bInsideTmp;
            PCardinal(@mPsiLight.Zpos)^ := 32768;
            mPsiLight.SIgradient := 0;
            if PMCrecord.RayCount = 0 then
            begin
              xx := x - (itcount and 1) * s05 - 0.75;
              yy := y + (itcount and 2) * s025 - s025;
            end else begin
              GetSubPixelShift(xx, yy);
              xx := xx + x - 1;
              yy := yy + y;
            end;
            CalculateVgradsFOV(xx, yy);
            if MCTCameraOptic = 2 then mCopyVec(@Iteration3Dext.C1, @Ystart) else
            begin
              mCopyAddVecWeight(@Iteration3Dext.C1, @Ystart, @Vgrads[1], yy);
              mAddVecWeight(@Iteration3Dext.C1, @Vgrads[0], xx);
            end;
            if bDoDOF then DoDOF else
            begin  //for hardshadows, no disc distribution
              HaltonDiscX := FracSingle(PHaltonRec(itmp).HDx * d1d65535 + HaltonShiftX);
              HaltonDiscY := FracSingle(PHaltonRec(itmp).HDy * d1d65535 + HaltonShiftY);
            end;
            ClearSVec(TotalLight);

            Iteration3Dext.CalcSIT := False;
            bCalcAmbShadow := False;
            bRit1     := True;
            msDEstop  := DEstop;
            ZZ        := 0;
            sDynFog   := 0;
            itmp      := 0;
            pStartPos := @Iteration3Dext.C1;
            if iCutOptions <> 0 then
            begin
              RMmaxLengthToCutPlane(@MCTparas, ZZ, itmp, @Iteration3Dext.C1);
              mCopyVec(@VPosStart, @Iteration3Dext.C1);      //keep startpos for vislight calc
              pStartPos := @VPosStart;
              if ZZ >= Zend then
              begin
                bRit1 := False; //just as marker
                ZZ := Zend;
              end;
              mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, ZZ);
              msDEstop := DEstop * (1 + ZZ * mctDEstopFactor);
              if not bRit1 then goto ll1;
            end;
            dTmp := CalcDE(@Iteration3Dext, @MCTparas);

            if (Iteration3Dext.ItResultI >= MaxItsResult) or (dTmp < msDEstop) then   // already in the set
            begin
              if bInAndOutside then
              begin
                bInsideRendering := not bInsideRendering;
                bCalcInside := not bCalcInside;
                goto ll1;
              end;
              PMCrecord.Zbyte := PMCrecord.Zbyte or 128;
              LVals.ZposDynFog := ZZ * StepWidth + sZZstmitDif; //test
              if ColorOnIt <> 0 then RMdoColorOnIt(@MCTparas);
              RMdoColor(@MCTparas);
              CalcNormalsOnCutMC(itmp);
              mZZ := ZZ;
              if ColorOption > 4 then mPsiLight.SIgradient := 32768 or mPsiLight.SIgradient
              else if bInsideRendering then   // if in+outside...
              begin
                Iteration3Dext.CalcSIT := True;
                CalcDE(@Iteration3Dext, @MCTparas);
                xx := Iteration3Dext.SmoothItD * mctsM;
                MinMaxClip15bit(xx, mPsiLight.SIgradient);
                mPsiLight.SIgradient := 32768 or mPsiLight.SIgradient;
              end
              else mPsiLight.SIgradient := 32768 + Round(32767 * Clamp01S(Iteration3Dext.Rout / dRStop));
              LightSD := CalcColor(mPsiLight, ZZ);
              CalcZposAndRough(mPsiLight, @MCTparas, ZZ);

              TotalLight := CalcVisLights(DVecToSVec(SubtractVectors(pStartPos^, @Xmit)),
                                          @mVgradsFOV, mPsiLight, xx, yy);

              tmpV := SubtractVectors(@mVgradsFOV, ScaleVector(Normals, 2 * DotOfVectors(@Normals, @mVgradsFOV)));
              LightSD2 := CalcPhongLightNoHS(mPsiLight, @tmpV);
              xx := xx * yy;
              AddSVecWeightS(TotalLight, AddSVectors(MultiplySVectors(LightSD[0], LightSD2[0]),
                                         MultiplySVectors(LightSD[1], LightSD2[1])), xx);
              if bCalcReflects then   //reflects roughness...cuts are always sharp
              begin
                dTmp := xx;
                mPsiLight.Zpos := 32768;
                //move C1 vec to background?
                sv := CalcVisLights(DVecToSVec(SubtractVectors(TPVec3D(@Iteration3Dext.C1)^, @Xmit)),
                                                      @tmpV, mPsiLight, xx, yy);
                if (not LVals.bBackBMP) or (not LVals.bAddBGlight) then xx := xx * yy;
                AddSVecWeightS(TotalLight,
                  MultiplySVectors(AddSVectors(sv, ScaleSVector(CalcBGLight(@tmpV, False, False), xx)),
                                             LightSD[0]), SRLightAmount * dTmp);
              end;
              //+ transp ray...
            end
            else
            begin
ll1:          CalcRay(ZZ, mVgradsFOV, cSVec1, 0);
            end;
ll2:        sv := MinMaxSVecMC(TotalLight);
            dTmp := YofSVec(@sv);
            sqrLightSum := sqrLightSum + Sqr(dTmp);
            LightSum := LightSum + dTmp;
            AddSVectors(@LightSDAt, sv);
            Inc(itcount);
          until itcount >= TotalItCount;

          if PCalcThreadStats.pLBcalcStop^ then Break;

          if itcount <> 0 then
          begin
            dTmp := MCRGBtoDouble(@PMCrecord.Ysum);
            ZZ := MCRGBtoDouble(@PMCrecord.Ysqr);
            itmp := PMCrecord.RayCount;
            if itmp <> 0 then yy := MaxCS(0.03, (ZZ - Sqr(dTmp)) * 10); //variance * SqrSigma
            if LVals.bCalcPixColSqr then Light := ScaleSVector(SqrtPosSVec(ScaleSVector(LightSDAt, 1 / itcount)), itcount)
                                    else Light := LightSDAt;
            xx := 1 / (itmp + itcount);
            SVecToMCRGB(PMCrecord, ScaleSVector(AddSVectors(ScaleSVector(MCRGBToSVec(PMCrecord), itmp), Light), xx));
            DoubleToMCRGBv((dTmp * itmp + LightSum) * xx, @PMCrecord.Ysum);
            DoubleToMCRGBv((ZZ * itmp + sqrLightSum) * xx, @PMCrecord.Ysqr);
            PMCrecord.RayCount := itmp + itcount;

            if (itmp <> 0) and (PMCrecord.RayCount < MaxNewCounts) and (Sqr(LightSum / itcount - dTmp) > yy) then
            begin
              TotalItCount := Round(Sqrt(Sqr(LightSum / itcount - dTmp) / yy) * Max(4, Min(itmp, itcount)));
           //   TotalItCount := Max(8, TotalItCount);//itmp div 2; or CalcN(x, y + 1, PMCrecord);
              goto ll0;           //calc ydif to sourrounding pixels (or just in x dir because of other threads updtatings...)
            end;                  // and do TotalItCount := max.. (Ysum - YsumNB) / Max(0.1, YsumNB) * RayCount
          end;
          Inc(PMCrecord);
        end;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        Inc(y, iThreadCount);
      end;
    finally
      PCalcThreadStats.CTrecords[iThreadId].isActive := 0;
      PostMessage(PCalcThreadStats.pMessageHwnd, WM_ThreadReady, 0, 0);
    end;
end;

initialization

  PreComputeSinCos;

end.
