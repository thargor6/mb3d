unit ImageProcess;

interface

uses Windows, Graphics, TypeDefinitions, AmbShadowCalcThreadN, Math3D, ExtCtrls;

type
LPresetRec = packed record
    Zpos, LXangle, LYangle: Integer;
end;
PLPresetRec = ^LPresetRec;

//TGetLightMapPixel = function(const x, y: Single; LM: TPLightMap; bSqr: LongBool; WrapAround: Integer): TSVec;
//TGetLightMapPixelSphere = function(const svec: TSVec; SM: TPSMatrix3; LM: TPLightMap; bSqr: LongBool): TSVec;
TCol2SVec = procedure(c: T4Cardinal; sv, svout: TPSVec);
TCol2SVecX87 = function(c: T4Cardinal): T4SVec;

function MakeColPresetGlyph(PresetNr: Integer): TBitmap;
function SetImageSize: LongBool;
procedure UpdateScaledImage(StartYh, EndYh: Integer);
procedure doAA(StartSLfullBMP, StartSLhalfBMP, OffsetFullBMP, OffsetHalfBMP,
               Hwidth, Hheight, Scale, Sharpen: Integer);
function CalcAmbShadowT(Header: TPMandHeader11; PsiLight: TPsiLight5; aSLoffset: Integer;
                        PCTS: TPCalcThreadStats; PATlevel: TPATlevel; cRect: TRect): Boolean;
procedure MakeZbufBMP(var BMP: TBitmap);
procedure CalcLightStrokes(Seed: Integer);
procedure NormalsOnZbuf(Header: TPMandHeader11; PLight: TPsiLight5);
function GetLightMapPixel(const x, y: Single; LM: TPLightMap; bSqr: LongBool; WrapAround: Integer): TSVec;
function GetLightMapPixelSphere(const svec: TSVec; SM: TPSMatrix3; LM: TPLightMap; bSqr: LongBool): TSVec;
function GetLightMapPixelNN(const x, y: Single; LM: TPLightMap; bSqr: LongBool; WrapAround: Integer): TSVec;
function GetLightMapPixelSphereNN(const svec: TSVec; SM: TPSMatrix3; LM: TPLightMap; bSqr: LongBool): TSVec;
function ColToSVecFlipRBc4(c: T4Cardinal): T4SVec;
procedure ColToSVecSSE2(c: T4Cardinal; sv, svout: TPSVec);
procedure MakeLMPreviewImage(image: TImage; LM: TPLightMap);
function ColToSVecFlipRBc416(c: T4Cardinal): T4SVec;
procedure ColToSVecSSE2_16(c: T4Cardinal; sv, svout: TPSVec);

var
    ATrousWL: TATlevel;
    ATrousWLprevAni: TATlevel;
    ATrousWLAni: TATlevel;
    LPresetArr: array of LPresetRec;
const
    sva1: array[0..3] of Integer = ($FF, $FF, $FF, $FF);
    sva16: array[0..3] of Integer = ($FFFF, $FFFF, $FFFF, $FFFF);

implementation

uses Mand, Math, Forms, Controls, Types, LightAdjust, CalcThread, SysUtils,
     DivUtils, FileHandling, Interpolation, CalcAmbShadowDE, Tiling, Calc,
     HeaderTrafos;

procedure CalcPixel(SL: PCardinal; Zpos: Integer; var P: TLpreset20;
                    colIndex, dAmbShad: Single; LXangle, LYangle: Integer; dY: Single);   //for preview images on buttons
var dTmp, dCtmp, dCtmp4, dTmp3: Single;
    ir, iL1, iL2, iL3: Integer;
    iAmb, iDif, iSpe, sLiDif, sLiSpe, DepC: TSVec;
    dAmb2: Single;
const SpecF: array[0..7] of Single = (1, 1.4142, 2, 2.8284, 4, 5.6568, 8, 11.313);
begin
    with P do
    begin
      SL^ := SwapColor(InterpolateColor(DepthCol, DepthCol2, 1 - dY, dY));
      if Zpos < 32768 then
      begin
        iL2 := 5;
        while (iL2 < 10) and (LCols[iL2].Position < colIndex) do Inc(iL2);
        while (iL2 > 1) and (LCols[iL2 - 1].Position >= colIndex) do Dec(iL2);
        iL1 := iL2 - 1;
        ir := LCols[iL2].Position;
        if iL2 > 9 then
        begin
          iL2 := 0;
          ir := 32767;
        end;
        if Lights[3].FreeByte <> 0 then
        begin
          iSpe := ScaleSVector(ColToSVecNoScale(LCols[iL1].ColorSpe), s1d255);
          iDif := ScaleSVector(ColToSVecNoScale(LCols[iL1].ColorDif), s1d255);
        end
        else
        begin
          dTmp3 := (colIndex - LCols[iL1].Position) * s1d255 / Max(1, ir - LCols[iL1].Position);
          dTmp  := s1d255 - dTmp3;
          iSpe := AddSVectors(ScaleSVector(ColToSVecNoScale(LCols[iL1].ColorSpe), dTmp),
                              ScaleSVector(ColToSVecNoScale(LCols[iL2].ColorSpe), dTmp3));
          iDif := AddSVectors(ScaleSVector(ColToSVecNoScale(LCols[iL1].ColorDif), dTmp),
                              ScaleSVector(ColToSVecNoScale(LCols[iL2].ColorDif), dTmp3));
        end;
        ClearSVec(sLiDif);
        ClearSVec(sLiSpe);
        dTmp3 := Max0S((Zpos - 20000) * 0.0001 + 1);
        dTmp  := Max0S(1 - dTmp3);
        DepC  := ScaleSVector(ColToSVecNoScale(SL^), dTmp);
        dTmp3 := dTmp3 * dAmbShad;
        dAmb2 := TB578pos[2] * 0.005;    //di,Sp,Am
        dCtmp4 := TB578pos[0] * 0.005;
        dCtmp := TB578pos[1] * 0.005;
        ir := 0;
        while ir < 4 do
        begin
          if Lights[ir].Loption = 0 then
          begin
            iL2 := Lights[ir].LFunction shr 4;  //Diff function
            dTmp := SpecF[Lights[ir].LFunction and 7];
            iL1 := (Round(D7BtoDouble(Lights[ir].LXpos) * M16384dPi * s05) + LXangle) and $7FFF;   //if PosLight change LXpos before
            iL3 := (Round(D7BtoDouble(Lights[ir].LYpos) * M16384dPi * s05) + LYangle) and $7FFF;
            if iL1 > 16383 then iL1 := 32767 - iL1;
            if iL3 > 16383 then iL3 := 32767 - iL3;
            iL1 := Round(dTmp * iL1);
            iL3 := Round(dTmp * iL3);
            if (iL1 or iL3) < 16384 then
              sLiSpe := AddSVectors(sLiSpe, RGBtoSVecScale(Lights[ir].Lcolor, GetGaussFuncNavi(iL1, iL3) * dCtmp4));
            dTmp := GetCosTabValNavi(iL2, Round(D7BtoDouble(Lights[ir].LXpos) * M16384dPi) + LXangle,
                                          Round(D7BtoDouble(Lights[ir].LYpos) * M16384dPi) + LYangle) * dCtmp;
            sLiDif := AddSVectors(sLiDif, RGBtoSVecScale(Lights[ir].Lcolor, dTmp));
          end;
          Inc(ir);
        end;
        dTmp := 1 - dY;
        if dAmbShad > 1 then dAmbShad := 1;
        iAmb := AddSVectors(MultiplySVectors(iDif, AddSVectors(sLiDif, ScaleSVector(
                AddSVectors(ScaleSVector(ColToSVecNoScale(AmbCol), dTmp),
                            ScaleSVector(ColToSVecNoScale(AmbCol2), dY)), dAmb2))),
                            MultiplySVectors(iSpe, sLiSpe));
        SL^ := SVecToColNoScale(FlipXZsvec(AddSVectors(ScaleSVector(
               MultiplySVectors(iAmb, AddSVecS(ScaleSVector(AddSVectors(iDif,
               ScaleSVector(iSpe, s05)), 1 - dAmbShad), dAmbShad)), dTmp3), DepC)));
      end;
    end;
end;

procedure HybridQuat(var x, y, z, w: Double; PIteration3D: TPIteration3D);
var xt, yt, zt: Double;
begin
    with PIteration3D^ do
    begin
      xt := x;
      yt := y;
      zt := z;
      x  := x * x - y * y - z * z - w * w + C1;
      y  := 2 * (y * xt + z * w) + C2;
      z  := 2 * (z * xt - yt * w) + C3;
      w  := 2 * (w * xt + yt * zt);
    end;
end;

procedure isMemberQuat(PIteration3D: TPIteration3D);
var X1, X2, X3, X4, Rold: Double;
begin
  if SupportSSE2 then   
  asm
    push esi
    push edi
    push ecx
    mov  esi, PIteration3D
    xor  ecx, ecx
    mov  edi, [esi + 48]
@u: movupd   xmm0, [esi]        // C1, C2   = X1, X2
    movsd    xmm1, [esi + 16]   // C3, 0    = X3, X4
    movapd   xmm2, xmm0
    movapd   xmm3, xmm1
    mulpd    xmm2, xmm0         // X1*X1, X2*X2
    mulpd    xmm3, xmm1         // X3*X3, X4*X4
    movapd   xmm4, xmm2
    addpd    xmm4, xmm3         // X1*X1 + X3*X3, X2*X2 + X4*X4
    pshufd   xmm5, xmm4, $4E    // X2*X2 + X4*X4, X1*X1 + X3*X3
    addsd    xmm4, xmm5         // Rout
@a: addsd    xmm3, xmm5         // X3*X3 + X2*X2 + X4*X4
    movlpd   Rold, xmm4
    pshufd   xmm7, xmm0, $4E    // X2, X1
    subsd    xmm2, xmm3         // X1*X1 - X2*X2 - X3*X3 - X4*X4
    movapd   xmm5, xmm0         // X1, X2
    mulsd    xmm7, xmm0         // X2*X1
    pshufd   xmm6, xmm1, $4E    // X4, X3
    addsd    xmm2, [esi]
    movapd   xmm3, xmm6         // X4, X3
    movapd   xmm0, xmm2         // X1 = X1*X1 - X2*X2 - X3*X3 - X4*X4 + C1;
    mulpd    xmm3, xmm5         // X4*X1, X3*X2
    mulsd    xmm6, xmm1         // X4*X3
    mulpd    xmm5, xmm1         // X1*X3, X2*X4
    addsd    xmm7, xmm6         // X2*X1 + X4*X3
    pshufd   xmm1, xmm5, $4E    // X2*X4, X1*X3
    addsd    xmm7, xmm7         // 2 * (X2*X1 + X4*X3)
    addsd    xmm7, [esi + 8]    // X2 = 2 * (X2*X1 + X3*X4) + C2
    subsd    xmm5, xmm1         // X2*X4*O1 + X1*X3   sub
    shufpd   xmm0, xmm7, 0      // X1, X2
    addsd    xmm5, xmm5         // 2 * (X2*X4*O1 + X1*X3)
    pshufd   xmm6, xmm3, $4E    // X3*X2, X4*X1
    addsd    xmm5, [esi + 16]   // X3 = 2 * (X2*X4*O1 + X1*X3) + C3
    addsd    xmm6, xmm3         // X3*X2 + X4*X1
    movsd    xmm1, xmm5
    addsd    xmm6, xmm6         // X4 = 2 * (X4*X1 + X3*X2)
    shufpd   xmm1, xmm6, 0      // X3, X4
    movapd   xmm2, xmm0
    movapd   xmm3, xmm1
    mulpd    xmm2, xmm0         // X1*X1, X2*X2
    mulpd    xmm3, xmm1         // X3*X3, X4*X4
    movapd   xmm4, xmm2
    addpd    xmm4, xmm3         // X1*X1 + X3*X3, X2*X2 + X4*X4
    pshufd   xmm5, xmm4, $4E    //
    addsd    xmm4, xmm5         // Rout
    inc  ecx
    cmp  ecx, [esi + 68]
    jge  @c
    ucomisd  xmm4, [edi + 160]  //>8?
    jb   @a
@c: movlpd   [esi + 56], xmm4   // Rout = double
    mov  [esi + 64], ecx        // ItResultI
    pop  ecx
    pop  edi
    pop  esi
  end
  else with PIteration3D^ do
  begin
    X1 := C1;
    X2 := C2;
    X3 := C3;
    X4 := 0;
    ItResultI := 0;
    Rout := X1 * X1 + X2 * X2 + X3 * X3;
    repeat
      Rold := Rout;
      HybridQuat(X1, X2, X3, X4, PIteration3D);
      Rout := X1 * X1 + X2 * X2 + X3 * X3 + X4 * X4;
      Inc(ItResultI);
    until
      (ItResultI >= maxIt) or (Rout > 8);
  end;
  with PIteration3D^ do
  begin
    if Rout <= 1 then SmoothItD := ItResultI
                 else SmoothItD := ItResultI - Ln(s05 * Ln(Rout)) * 1.4427;
  end;
end;

procedure RenderPresetQuat;
var x, y: Integer;
    DE, N1, N2, N3: Single;
    Iteration3D: TIteration3D;
    PRec: PLPresetRec;
begin
    SetLength(LPresetArr, 34 * 34);
    PRec := @LPresetArr[0];
    for y := 0 to 33 do
    with Iteration3D do
    begin
      PVar  := PAligned16;
      Rstop := 8;
      MaxIt := 10;
      for x := 1 to 34 do
      begin
        C1 := x * 0.07 - 1.75;
        C2 := y * 0.07 - 1.156;
        C3 := -1.5;
        DE := 0.055;
        repeat
          C3 := C3 + DE * s03;
          isMemberQuat(@Iteration3D);
          DE := Abs(1 / (1 + Exp(SmoothItD - 3))) + 0.02;
        until (C3 > s05) or (DE < 0.04);
        if C3 > 0.499 then
        begin
          PRec.Zpos := 32768;
          PRec.LYangle := 0;
          PRec.LXangle := 0;
        end else begin
          PRec.Zpos := 32767 - Round((1 - C3) * 9000);
          DE   := SmoothItD;
          C3   := C3 - s0001;
          isMemberQuat(@Iteration3D);
          N3 := DE - SmoothItD;
          C3 := C3 + s0001;
          C2 := C2 + s0001;
          isMemberQuat(@Iteration3D);
          N2 := DE - SmoothItD;
          C2 := C2 - s0001;
          C1 := C1 - s0001;
          isMemberQuat(@Iteration3D);
          N1 := SmoothItD - DE;
          DE := 1 / Sqrt(N1 * N1 + N2 * N2 + N3 * N3 + s001);
          PRec.LYangle := Round(ArcSinSafe(N2 * DE) * 5215.1891752352) and $7FFF;
          PRec.LXangle := Round(ArcSinSafe(N1 * DE) * 5215.1891752352) and $7FFF;
        end;
        Inc(PRec);
      end;
    end;
end;

procedure RenderLittleImage(var BMP: TBitmap; var P: TLpreset20);
var x, y: Integer;
    sl: pCardinal;
    amb: Single;
    PRec: PLPresetRec;
begin
    if Length(LPresetArr) <> 34 * 34 then RenderPresetQuat;
    PRec := @LPresetArr[0];
    for y := 0 to 33 do
    begin
      sl := BMP.ScanLine[y];
      for x := 1 to 34 do
      begin
        if PRec.Zpos = 32768 then amb := 0.5 else
        amb := 0.6 - (3.3 - ((32767 - PRec.Zpos) * 3.6666e-4));
        CalcPixel(sl, PRec.Zpos, P, x * 1058 - 7800, amb, PRec.LXangle,
                  PRec.LYangle, y * 0.03);
        Inc(sl);
        Inc(PRec);
      end;
    end;
end;

function MakeColPresetGlyph(PresetNr: Integer): TBitmap;
var x, y: Integer;
    BMP2: TBitmap;
    sl1, sl2, sl3: PByte;
    P: TLpreset20;
begin
    Result             := TBitmap.Create;
    Result.PixelFormat := pf32bit;
    Result.Width       := 19;
    Result.Height      := 17;
    Result.Transparent := False;
    Result.Canvas.Brush.Color := $FEFDFF;
    Result.Canvas.FillRect(Result.Canvas.ClipRect);
    BMP2 := TBitmap.Create;
    try
      BMP2.PixelFormat := pf32bit;
      BMP2.Width       := 34;
      BMP2.Height      := 34;
      BMP2.Transparent := False;
      with BMP2.Canvas do
      begin
        if Presetnr > 5 then P := CustomPresets[Presetnr]
                        else P := ConvertColPreset164To20(Presets[Presetnr]);
        Brush.Color := 0;
        FillRect(ClipRect);
        RenderLittleImage(BMP2, P);
        for y := 0 to 16 do
        begin
          sl1 := Result.ScanLine[y];
          sl2 := BMP2.ScanLine[y * 2];
          sl3 := BMP2.ScanLine[y * 2 + 1];
          Inc(sl1, 4);
          for x := 1 to 17 do
          begin
            sl1^ := (sl2^ + PByte(Integer(sl2) + 4)^ + sl3^ + PByte(Integer(sl3) + 4)^) shr 2;
            Inc(sl1);
            Inc(sl2);
            Inc(sl3);
            sl1^ := (sl2^ + PByte(Integer(sl2) + 4)^ + sl3^ + PByte(Integer(sl3) + 4)^) shr 2;
            Inc(sl1);
            Inc(sl2);
            Inc(sl3);
            sl1^ := (sl2^ + PByte(Integer(sl2) + 4)^ + sl3^ + PByte(Integer(sl3) + 4)^) shr 2;
            Inc(sl1, 2);
            Inc(sl2, 6);
            Inc(sl3, 6);
          end;
        end;
      end;
    finally
      BMP2.Free;
    end;
end;

procedure doAA(StartSLfullBMP, StartSLhalfBMP, OffsetFullBMP, OffsetHalfBMP,
               Hwidth, Hheight, Scale, Sharpen: Integer);
var x, y, c, x2, iThr, n: Integer;
    sVal, sWei, sSh: Single;
    PB1, PB2, PBh: PByte;
    Buf: array of Byte;
    aLP: array[0..24] of Single;
const cLP2: array[0..16] of Single = (129.447, 80.065, -1.5584, -24.16,
    0.793, 12.267, -0.1375, -7.096, -0.2744, 4.324, 0.472, -2.69, -0.526, 1.68,
    0.5, -1, -0.4);
  cLP3: array[0..24] of Single = (86.299, 70.497, 33.722, -1.0383, -16.482,
    -11.906, 0.529, 8.0127, 6.317, -0.091, -4.458, -3.818, -0.183, 2.585, 2.446,
    0.3147, -1.512, -1.609, -0.35, 0.875, 1.068, 0.332, -0.493, -0.708, -0.28);
  //sharpen filter:
  cSP2: array[0..16] of Single = (0.74581218, 0.307845, -0.135913, -0.12739,
    0.03, 0.07615, 0.00947, -0.0345, -0.0174, 0.0131, 0.0135, -0.00189, -0.0084, -0.00164,
    0.00383, 0.00252, -0.00142);
  cSP3: array[0..24] of Single = (0.508389, 0.338648, 0.07211, -0.08756, -0.1117,
    -0.04961, 0.0207, 0.05232, 0.0394, -0.0184, -0.0229, -0.0114, 0.0035, 0.0111, 0.0092,
    0.0021, -0.0039, -0.0055, -0.003, 0.0005, 0.0026, 0.0024, 0.0007, 0, 0);
begin
  Screen.Cursor := crHourGlass;
  try
    n := Scale * 8;
    if Scale = 2 then sSh := Sharpen * 200 / 3 else sSh := Sharpen * 180 / 3;
    if Scale = 2 then for y := 0 to 16 do aLP[y] := cLP2[y] + sSh * cSP2[y]
    else for y := 0 to 24 do aLP[y] := cLP3[y] + sSh * cSP3[y];
    
    SetLength(Buf, Hwidth * Hheight * 3 * Scale);
    for y := 0 to Hheight * Scale - 1 do  //first horizontal lowpass
    begin
      PB1 := PByte(StartSLfullBMP + OffsetFullBMP * y);
      PBh := @Buf[y * Hwidth * 3];
      for x := 1 to Hwidth do
      begin
        for c := 0 to 2 do
        begin
          iThr := Abs(PB1^ - PByte(Integer(PB1) + 4)^);  //todo: if scale=3 then take from 1 pixel to the right
          if x < Hwidth then
          begin
            x2 := Abs(PB1^ - PByte(Integer(PB1) + 8)^);
            if x2 > iThr then iThr := x2;
            if (Scale = 3) and (x < Hwidth - 1) then
            begin
              x2 := Abs(PB1^ - PByte(Integer(PB1) + 12)^);
              if x2 > iThr then iThr := x2;
            end;
          end;
          if x > 1 then
          begin
            x2 := Abs(PB1^ - PByte(Integer(PB1) - 4)^);
            if x2 > iThr then iThr := x2;
            x2 := Abs(PB1^ - PByte(Integer(PB1) - 8)^);
            if x2 > iThr then iThr := x2;
            if (Scale = 3) and (x > 2) then
            begin
              x2 := Abs(PB1^ - PByte(Integer(PB1) - 12)^);
              if x2 > iThr then iThr := x2;
            end;
          end;
          iThr := iThr * 10;
          sVal := 0;
          sWei := 0;
          PB2 := PB1;
          for x2 := 0 to Min(n, (Hwidth - x) * Scale) do
          begin
            if Abs(PB2^ - PB1^) > iThr then Break;   //read of adr...    imagescale=2
            sVal := sVal + aLP[x2] * Integer(PB2^); //(PB2^ * 255.0 + Sqr(Integer(PB2^))); //sqr because of gamma? not really better?
            sWei := sWei + aLP[x2];
            Inc(PB2, 4);
          end;
          PB2 := PB1;
          for x2 := 1 to Min(n, (x - 1) * Scale) do
          begin
            Dec(PB2, 4);
            if Abs(PB2^ - PB1^) > iThr then Break;
            sVal := sVal + aLP[x2] * Integer(PB2^); //(PB2^ * 255.0 + Sqr(Integer(PB2^))); //
            sWei := sWei + aLP[x2];
          end;
          if sWei > 0 then
          begin
            x2 := Round(sVal / sWei); //Sqrt(sVal / sWei + 16256.25) - 127.5); //
            if x2 < 0 then x2 := 0 else if x2 > 255 then x2 := 255;
            PBh^ := x2;
          end;
          Inc(PB1);
          Inc(PBh);
        end;
        Inc(PB1, 4 * Scale - 3);
      end;
    end;
    for x := 0 to Hwidth - 1 do       // vertical lowpass
    begin
      PB1 := @Buf[x * 3];
      PBh := PByte(StartSLhalfBMP + x * 4);
      for y := 1 to Hheight do
      begin
        for c := 0 to 2 do
        begin
          iThr := Abs(PB1^ - PByte(Integer(PB1) + 3 * Hwidth)^);
          if y < Hheight then
          begin
            x2 := Abs(PB1^ - PByte(Integer(PB1) + 6 * Hwidth)^);
            if x2 > iThr then iThr := x2;
            if (Scale = 3) and (y < Hheight - 1) then
            begin
              x2 := Abs(PB1^ - PByte(Integer(PB1) + 9 * Hwidth)^);
              if x2 > iThr then iThr := x2;
            end;
          end;
          if y > 1 then
          begin
            x2 := Abs(PB1^ - PByte(Integer(PB1) - 3 * Hwidth)^);
            if x2 > iThr then iThr := x2;
            x2 := Abs(PB1^ - PByte(Integer(PB1) - 6 * Hwidth)^);
            if x2 > iThr then iThr := x2;
            if (Scale = 3) and (y > 2) then
            begin
              x2 := Abs(PB1^ - PByte(Integer(PB1) - 9 * Hwidth)^);
              if x2 > iThr then iThr := x2;
            end;
          end;
          iThr := iThr * 10;
          sVal := 0;
          sWei := 0;
          PB2 := PB1;
          for x2 := 0 to Min(n, (Hheight - y) * Scale) do
          begin
            if Abs(PB2^ - PB1^) > iThr then Break;
            sVal := sVal + aLP[x2] * Integer(PB2^); //(PB2^ * 255.0 + Sqr(Integer(PB2^))); //
            sWei := sWei + aLP[x2];
            Inc(PB2, 3 * Hwidth);
          end;
          PB2 := PB1;
          for x2 := 1 to Min(n, (y - 1) * Scale) do
          begin
            Dec(PB2, 3 * Hwidth);
            if Abs(PB2^ - PB1^) > iThr then Break;
            sVal := sVal + aLP[x2] * Integer(PB2^); //(PB2^ * 255.0 + Sqr(Integer(PB2^))); //
            sWei := sWei + aLP[x2];
          end;
          if sWei > 0 then
          begin
            x2 := Round(sVal / sWei); //Sqrt(sVal / sWei + 16256.25) - 127.5); //
            if x2 < 0 then x2 := 0 else if x2 > 255 then x2 := 255;
            PBh^ := x2;
          end;
          Inc(PB1);
          Inc(PBh);
        end;
        Inc(PB1, Hwidth * 3 * Scale - 3);
        Inc(PBh, OffsetHalfBMP - 3);
      end;
    end;
    SetLength(Buf, 0);
    Mand3DForm.Image1.Picture.Bitmap.Modified := True;
    Mand3DForm.Image1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure UpdateScaledImage(StartYh, EndYh: Integer);
var a, x, y, y2, wid, w2, itmp: Integer;
    PBh, PB1: PByte;
    PC1, PC2: PCardinal;
    b: Byte;
    Buf: array of Cardinal;
begin
    if (ImageScale < 1) or (ImageScale > 10) then Exit;
    b := Sqr(ImageScale);
    a := b div 2;
    if EndYh >= Mand3DForm.Image1.Picture.Bitmap.Height then
       EndYh := Mand3DForm.Image1.Picture.Bitmap.Height - 1;
  {  if Mand3DForm.bCalcTile then
      wid := TilingForm.brTileW div ImageScale
    else  }
    wid := Mand3DForm.Image1.Picture.Bitmap.Width;
    if (wid < 1) or (wid * Mand3DForm.Image1.Picture.Bitmap.Height * b > Length(fullSizeImage)) then Exit;
    if ImageScale > 3 then SetLength(Buf, wid * ImageScale * 3);

    for y := StartYh to EndYh do
    begin
      PB1 := PByte(mFSIstart + mFSIoffset * y * ImageScale);
      PBh := PByte(I1BMPstartSL + I1BMPoffset * y);
      if ImageScale = 2 then
      asm
        push eax
        push ebx
        push ecx
        push edx
        push edi
        push esi
        mov  ecx, wid
        mov  esi, PB1
        mov  edi, PBh
        mov  ebx, mFSIoffset
   @ll: movzx eax, byte ptr [esi]
        movzx edx, byte ptr [esi + 4]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx]    
        add   eax, edx
        movzx edx, byte ptr [esi + ebx + 4]
        lea   eax, [eax + edx + 2]
        shr   eax, 2
        mov   [edi], al
        movzx eax, byte ptr [esi + 1]
        movzx edx, byte ptr [esi + 5]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx + 1]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx + 5]
        lea   eax, [eax + edx + 2]
        shr   eax, 2
        mov   [edi + 1], al
        movzx eax, byte ptr [esi + 2]
        movzx edx, byte ptr [esi + 6]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx + 2]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx + 6]
        lea   eax, [eax + edx + 2]
        shr   eax, 2
        mov   [edi + 2], al
        add   esi, 8
        add   edi, 4
        dec   ecx
        jnz   @ll
        pop  esi
        pop  edi
        pop  edx
        pop  ecx
        pop  ebx
        pop  eax
      end
      else if ImageScale = 1 then
      begin
        PC1 := PCardinal(PB1);
        PC2 := PCardinal(PBh);
        for x := 1 to wid do
        begin
          PC2^ := PC1^;
          Inc(PC2);
          Inc(PC1);
        end;
      end
      else if ImageScale = 3 then
      asm
        push eax
        push ebx
        push ecx
        push edx
        push edi
        push esi
        mov  ecx, wid
        mov  esi, PB1
        mov  edi, PBh
        mov  ebx, mFSIoffset
   @ll: movzx eax, byte ptr [esi]
        movzx edx, byte ptr [esi + 4]
        add   eax, edx
        movzx edx, byte ptr [esi + 8]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx + 4]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx + 8]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx * 2]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx * 2 + 4]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx * 2 + 8]
        lea   eax, [eax + edx + 4]
        div   b
        mov   [edi], al                                        
        movzx eax, byte ptr [esi + 1]
        movzx edx, byte ptr [esi + 5]
        add   eax, edx
        movzx edx, byte ptr [esi + 9]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx + 1]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx + 5]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx + 9]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx * 2 + 1]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx * 2 + 5]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx * 2 + 9]
        lea   eax, [eax + edx + 4]
        div   b
        mov   [edi + 1], al
        movzx eax, byte ptr [esi + 2]
        movzx edx, byte ptr [esi + 6]
        add   eax, edx
        movzx edx, byte ptr [esi + 10]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx + 2]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx + 6]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx + 10]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx * 2 + 2]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx * 2 + 6]
        add   eax, edx
        movzx edx, byte ptr [esi + ebx * 2 + 10]
        lea   eax, [eax + edx + 4]
        div   b
        mov   [edi + 2], al
        add   esi, 12
        add   edi, 4
        dec   ecx
        jnz   @ll
        pop  esi
        pop  edi
        pop  edx
        pop  ecx
        pop  ebx
        pop  eax
      end
      else   //ImageScale > 3
      begin
        PC1 := @Buf[0];
        asm    //sum rows to buf
          push eax
          push ebx
          push ecx
          push edx
          push edi
          push esi
          mov   ebx, ImageScale
          dec   ebx
          mov   y2, ebx
          mov   edi, PC1
          lea   eax, ebx * 4 - 1
          mov   itmp, eax
   @@0:   mov   ecx, wid
          mov   w2, ecx
          mov   esi, PB1
          mov   eax, mFSIoffset
          mul   y2
          add   esi, eax
   @ll:   mov   ecx, ebx
          movzx eax, byte ptr [esi]
   @@1:   add   esi, 4
          movzx edx, byte ptr [esi]
          add   eax, edx
          dec   ecx
          jnz   @@1
          mov   [edi], eax
          sub   esi, itmp
          mov   ecx, ebx
          movzx eax, byte ptr [esi]
   @@2:   add   esi, 4
          movzx edx, byte ptr [esi]
          add   eax, edx
          dec   ecx
          jnz   @@2
          mov   [edi + 4], eax
          sub   esi, itmp
          mov   ecx, ebx
          movzx eax, byte ptr [esi]
   @@3:   add   esi, 4
          movzx edx, byte ptr [esi]
          add   eax, edx
          dec   ecx
          jnz   @@3
          mov   [edi + 8], eax
          add   edi, 12
          add   esi, 2
          dec   w2
          jnz   @ll
          dec   y2
          jns   @@0
          pop  esi
          pop  edi
          pop  edx
          pop  ecx
          pop  ebx
          pop  eax
        end;
        PBh := PByte(I1BMPstartSL + I1BMPoffset * y);
        asm         //sum columns
          push eax
          push ebx
          push ecx
          push edx
          push edi
          push esi
          mov   eax, ImageScale
          dec   eax
          mov   y2, eax
          mov   edx, PC1
          mov   ebx, wid
          mov   w2, ebx
          shl   ebx, 2
          lea   ebx, ebx * 2 + ebx
          mov   edi, PBh
   @ll:   mov   ecx, y2
          mov   esi, edx
          mov   eax, [esi]
   @@1:   add   esi, ebx
          add   eax, [esi]
          dec   ecx
          jnz   @@1
          add   eax, a
          div   b
          mov   [edi], al
          add   edx, 4
          mov   ecx, y2
          mov   esi, edx
          mov   eax, [esi]
   @@2:   add   esi, ebx
          add   eax, [esi]
          dec   ecx
          jnz   @@2
          add   eax, a
          div   b
          mov   [edi + 1], al
          add   edx, 4
          mov   ecx, y2
          mov   esi, edx
          mov   eax, [esi]
   @@3:   add   esi, ebx
          add   eax, [esi]
          dec   ecx
          jnz   @@3
          add   eax, a
          div   b
          mov   [edi + 2], al
          add   edx, 4
          add   edi, 4
          dec   w2
          jnz   @ll
          pop  esi
          pop  edi
          pop  edx
          pop  ecx
          pop  ebx
          pop  eax
        end;
      end;
    end;
    Mand3DForm.Image1.Picture.Bitmap.Modified := True;
    SetLength(Buf, 0);
end;

procedure MakeZbufBMP(var BMP: TBitmap);
var x, y, xx, yy, wid, i, scale, add, add2, ww, ystart, xstart: Integer;
    PB: PByte;
    PW, PW2, PW3: PWord;
    TileRect: TRect;
    Crop: Integer;
begin
    scale := Max(2, Min(10, ImageScale));
    add := 16 * Sqr(scale);
    if Mand3DForm.MHeader.TilingOptions <> 0 then
    begin
      GetTilingInfosFromHeader(@Mand3DForm.MHeader, TileRect, Crop);
      ystart := Crop div ImageScale;
      xstart := Crop;
      add2 := (TileRect.Right - TileRect.Left + 1) * 9; 
      ww := (TileRect.Right - TileRect.Left + 1) * ImageScale; //ok?
    end else begin
      ystart := 0;
      xstart := 0;
      add2 := Mand3DForm.MHeader.Width * 9;
      ww := Mand3DForm.MHeader.Width * ImageScale;
    end;
    wid := BMP.Width;
    for y := 0 to BMP.Height - 1 do
    begin
      PB := BMP.ScanLine[y];
      PW := @Mand3DForm.siLight5[(y + ystart) * ww + xstart];
      Inc(PW, 4); //Zpos word
      if ImageScale = 1 then
      begin
        for x := 1 to wid do
        begin
          if PW^ > 32767 then PB^ := 0 else PB^ := PW^ div 137 + 16;
          Inc(PB);
          Inc(PW, 9);
        end;
      end else
      begin
        for x := 1 to wid do
        begin
          PW2 := PW;
          i := 0;
          for yy := 1 to scale do
          begin
            PW3 := PW2;
            for xx := 1 to scale do
            begin
              if PW3^ < 32768 then i := i + PW3^ + add;
              Inc(PW3, 9);
            end;
            Inc(PW2, add2);
          end;
          Inc(PW, 9 * scale);
          PB^ := i div (Sqr(scale) * 137);
          Inc(PB);
        end;
      end
    end;
end;

function SetImageSize: LongBool;
var w, h, OrigScale: Integer;
    success: LongBool;
    TileSize: TPoint;
begin
    with Mand3DForm do
    begin
      Result := False;
      OrigScale := ImageScale;
      Image1.Picture.Bitmap.PixelFormat := pf32bit;
      repeat
        ImageScale := Max(1, Min(10, ImageScale));
        if MHeader.TilingOptions <> 0 then
        begin
          TileSize := GetTileSize(@MHeader);
          w := TileSize.X; //TilingForm.brTileW;
          h := TileSize.Y; //TilingForm.brTileH;
        end else begin
          w := MHeader.Width;
          h := MHeader.Height;
        end;
        success := True;
        try
          Image1.Picture.Bitmap.Width  := w div ImageScale;
          Image1.Picture.Bitmap.Height := h div ImageScale;
          getI1BMPSLs;
          if Length(fullSizeImage) <> w * h then
          begin
            SetLength(fullSizeImage, w * h);
            mFSIstart := Integer(@fullSizeImage[0]);
          end;
          Result := OrigScale = ImageScale;
        except
          success := ImageScale < 10;
          ImageScale := Min(10, ImageScale + 1);
        end;
      until success;
      SpeedButton35.Caption := '1:' + IntToStr(ImageScale);
      UpDown1.Position := 11 - ImageScale;
      mFSIoffset := w * 4;
      DrawRect := Rect(MHeader.Width, MHeader.Height, 0, 0);
    end;
end;

{function CalcBGShadowT(Header: TPMandHeader10; PsiLight: TPsiLight5;
                       PCTS: TPCalcThreadStats; PBGlevel: TPBGlevel): Boolean;
var BGSparameter: TBGSparameter;                             // + OffsetM200
    ThreadCount, x: Integer;
    BGSThread: array[1..4] of TBGshadowThread;
const
    cTCstep: array[1..4] of Integer = (14, 7, 4, 3);
begin
    Result := False;
    PCTS.cCalcTime           := GetTickCount;
    ThreadCount              := Min(4, Mand3DForm.SpinEdit1.Value);
    BGSparameter.bgsWidth    := Header.Width;
    BGSparameter.bgsHeight   := Header.Height;
    BGSparameter.bgsZHfactor := Abs(Header.dZstart - Header.dZend) *
                                Header.dZoom * Header.Width / 3000;
    BGSparameter.bgsPsiLight := PsiLight;
    BGSparameter.bgsLEnd     := 0;
    BGSparameter.BGSoffset   := 0;//Header.BGSoffset * 200;
    BGSparameter.bgsPCTS     := PCTS;
    BGSparameter.PBGlevel    := PBGlevel;
    for x := 1 to ThreadCount do
    begin
      BGSparameter.bgsThreadID := x;
      BGSparameter.bgsLStart   := BGSparameter.bgsLEnd + 1;
      BGSparameter.bgsLEnd     := Min(15, BGSparameter.bgsLStart + cTCstep[ThreadCount]);
      try
        BGSThread[x]                 := TBGshadowThread.Create(True);
        BGSThread[x].FreeOnTerminate := True;
        BGSThread[x].BGSparameter    := BGSparameter;
        BGSThread[x].Priority        := cTPrio[Header.iThreadPriority];
        PCTS.iActualYpos[x]          := 0;
        PCTS.isActive[x]             := 1;
      except
        ThreadCount := x - 1;
        if ThreadCount > 0 then
          BGSThread[ThreadCount].BGSparameter.bgsLEnd := 15;
        Break;
      end;
    end;
    PCTS.iTotalThreadCount := ThreadCount;
    for x := 1 to ThreadCount do BGSThread[x].Resume;
    Result := ThreadCount > 0;
end; }

function CalcAmbShadowT(Header: TPMandHeader11; PsiLight: TPsiLight5; aSLoffset: Integer;
        PCTS: TPCalcThreadStats; PATlevel: TPATlevel; cRect: TRect): Boolean;
var x, y, MWidth, MHeight, ThreadCount: Integer;
    ASCparameter: TASCparameter;
    Zcorr, ZcMul, ZZstmitDif: Double;
    ascThread: array of TAmbShadowCalc;
    ascThreadT0: array of TAmbShadowCalcT0;
    bT0calc: LongBool;
begin
    if (Header.bCalcAmbShadowAutomatic and 12) = 12 then
    begin
      Result := CalcAmbShadowDET(Header, PCTS, PsiLight, aSLoffset, cRect);
      Exit;
    end;
    Result      := False;
    MWidth      := Header.Width;
    MHeight     := Header.Height;
    ThreadCount := Min(Mand3DForm.UpDown3.Position, MHeight);
    bT0calc     := (Header.bCalcAmbShadowAutomatic and 2) > 0;
    if bT0calc then SetLength(ascThreadT0, ThreadCount)
               else SetLength(ascThread, ThreadCount);
    CalcPPZvals(Header^, Zcorr, ZcMul, ZZstmitDif);
    PCTS.cCalcTime := GetTickCount;
    ASCparameter.aZScaleFactor := (Sqr(256 / ZcMul + 1) - 1) / Zcorr;
    ASCparameter.aPsiLight     := PsiLight;
    ASCparameter.aZRThreshold  := Header.sAmbShadowThreshold;
    ASCparameter.aATlevelCount := BuildATlevels(Integer(PsiLight), MWidth, MHeight, PATlevel, ASCparameter.aCorrMul, ASCparameter.aZsub);
    if ASCparameter.aATlevelCount < 1 then
    begin
      Mand3DForm.OutMessage('Could not build wavelet levels, no ambient shadow calced.');
      Exit;
    end;
    ASCparameter.aWidth   := MWidth;
    ASCparameter.aHeight  := MHeight;
    ASCparameter.aPCTS    := PCTS;
    ASCparameter.PATlevel := PATlevel;
    PCTS.ctCalcRect       := cRect;
    for x := 0 to ThreadCount - 1 do
    begin
      ASCparameter.aYstep    := ThreadCount;
      ASCparameter.aYStart   := x;
      ASCparameter.aThreadID := x + 1;
      if bT0calc then
      try
        ascThreadT0[x]                 := TAmbShadowCalcT0.Create(True);
        ascThreadT0[x].FreeOnTerminate := True;
        ascThreadT0[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
        ascThreadT0[x].ASCpar          := ASCparameter;
        PCTS.CTrecords[x + 1].iActualYpos := 0;
        PCTS.CTrecords[x + 1].iActualXpos := 0;
        PCTS.CTrecords[x + 1].isActive    := 1;
      //  PCTS.CTprios[x + 1]   := ascThreadT0[x].Priority;
        PCTS.CThandles[x + 1] := ascThreadT0[x];
      except
        ThreadCount := x;
        if ThreadCount > 0 then for y := 0 to ThreadCount - 1 do
          ascThreadT0[y].ASCpar.aYstep := ThreadCount;
        Break;
      end
      else
      try
        ascThread[x]                 := TAmbShadowCalc.Create(True);
        ascThread[x].FreeOnTerminate := True;
        ascThread[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
        ascThread[x].ASCpar          := ASCparameter;
        PCTS.CTrecords[x + 1].iActualYpos := 0;
        PCTS.CTrecords[x + 1].iActualXpos := 0;
        PCTS.CTrecords[x + 1].isActive    := 1;
     //   PCTS.CTprios[x + 1]   := Header.iThreadPriority;
        PCTS.CThandles[x + 1] := ascThread[x];
      except
        ThreadCount := x;
        if ThreadCount > 0 then for y := 0 to ThreadCount - 1 do
          ascThread[y].ASCpar.aYstep := ThreadCount;
        Break;
      end;
    end;
    PCTS.HandleType := 1;
    PCTS.iTotalThreadCount := ThreadCount;
    if bT0calc then
    begin
      for x := 0 to ThreadCount - 1 do ascThreadT0[x].Start;//.Resume;
    end else begin
      for x := 0 to ThreadCount - 1 do ascThread[x].Start;
    end;
    Result := ThreadCount > 0;
end;

{procedure CalcBGambI(BGSTcount: Integer; PsiLight: TPsiLight5; PBGlevel: TPBGlevel);
var i, l: Integer;
    PS1, PS2: PSingle;
    PL2: TPsiLight5;
begin
    for l := 2 to BGSTcount do
    begin
      PS1 := @PBGlevel[1][0];
      PS2 := @PBGlevel[l][0];
      for i := 0 to Min(High(PBGlevel[l]), High(PBGlevel[1])) do  //PBGlevel[1] could be smaller when out of memory issues!
      begin
        PS1^ := PS1^ + PS2^;
        Inc(PS1);
        Inc(PS2);
      end;
    end;
    PS1 := @PBGlevel[1][0];
    PL2 := PsiLight;
    for i := 0 to High(PBGlevel[1]) do
    begin
      if PL2^.Zpos = 32768 then
      begin
        l := Round(PS1^ * 4e6) + 5000;
        if l > 32767 then l := 32767 else if l < 0 then l := 0;
        PL2^.AmbShadow := l;
      end;
      Inc(PS1);
      Inc(PL2);
    end;
end;   }

procedure CalcLightStrokes(Seed: Integer);
var x, y, x2, y2: Integer;
begin
    {            seed := 214013 * seed + 2531011;
                x2 := Round(sx - ssub) + ((seed shr 16) and iand);
                y2 := Round(sy - ssub) + ((seed shr 10) and iand);  }


end;

procedure CalcViewVec(PLV: TPPaintLightVals; const sFOV, sAspect: Single);
var CX, CY: Double;
begin
    with PLV^ do
    begin
      CX := (0.5 - xPos) * sFOV * sAspect;
      CY := (yPos - 0.5) * sFOV;
      if iPlanarOptic = 1 then
      begin
        ViewVec[0] := -CX;
        ViewVec[1] := CY;
        ViewVec[2] := PlOpticZ;
        NormaliseSVectorVar(ViewVec);
      end
      else if iPlanarOptic = 2 then
        BuildViewVectorSphereFOV(CY, CX, @ViewVec)
      else BuildViewVectorFOV(CY, CX, @ViewVec);
    end;
end;

{function RecComb(s1, s2, n: Single): Single;
var w1, w2: Single;
begin
    w1 := 1 / (Abs(s1) + n);
    w2 := 1 / (Abs(s2) + n);
    Result := (s1 * w1 + s2 * w2) / (w1 + w2);
end; }

function RecCombSVec(s1, s2: TSVec; n: Single): TSVec;
var w1, w2, wm: Single;
begin
    n := Sqr(n);
    w1 := 1 / (SqrLengthOfSVec(s1) + n);
    w2 := 1 / (SqrLengthOfSVec(s2) + n);
    wm := 1 / (w1 + w2);
    w1 := w1 * wm;
    w2 := w2 * wm;
    Result := AddSVectors(ScaleSVector(s1, w1), ScaleSVector(s2, w2));
end;

{function MakeRotQuatFromSNormals2(const NVec: TSVec): TQuaternion;
var cosA, sinA, N: Double;
begin
    SinCosD(ArcCosSafe(NVec[2]) * 0.5, sinA, cosA);
    N := Sqrt(NVec[1] * NVec[1] + NVec[0] * NVec[0]);
    if N < 1e-20 then
    begin
      Result[0] := 0;
      Result[1] := 0;
    end else begin
      sinA := sinA / N;
      Result[0] := NVec[0] * sinA;
      Result[1] := NVec[1] * sinA;
    end;
    Result[2] := 0;
    Result[3] := cosA;
end; }

procedure NormalsOnZbuf(Header: TPMandHeader11; PLight: TPsiLight5);
var x, y, w1, w, h: Integer;
    CalcR: TRect;
    s0, sFOV, aspect, DEstopFactor, StepWidth: Single;
    PW0, PW1: PWord;
    tmpBuf: array of TSVec;
    ZcMul, Ztmp, dZ, dCorr: Double;
    Xpos, svX, svY: TSVec;
    PLV: TPaintLightVals;
begin
    if Header.TilingOptions <> 0 then
    //  GetTilingInfosFromHeader(Header, TileRect, Crop);
      CalcR := Mand3DForm.GetCalcRect
    else
      CalcR := Rect(0, 0, Header.Width - 1, Header.Height - 1);
    w := CalcR.Right - CalcR.Left + 1;
    h := CalcR.Bottom - CalcR.Top + 1;
    StepWidth := Header.dStepWidth;
    if Header.bPlanarOptic = 2 then aspect := 2 else
      aspect := Header.Width / Header.Height;
    if Header.bPlanarOptic = 2 then sFOV := Pi else
      sFOV := Header.dFOVy * Pid180;
    PLV.iPlanarOptic := Header.bPlanarOptic and 3;
    Ztmp := MinMaxCD(0.01, sFOV * s05, 1.5);
    PLV.PlOpticZ := Cos(Ztmp) * Ztmp / Sin(Ztmp);
    CalcPPZvals(Header^, dZ, ZcMul, Ztmp);
    dCorr := StepWidth / dZ;
    ZcMul := 1 / ZcMul;                              //Abs()
    DEstopFactor := GetDEstopFactor(Header); //Sin(Max0S(sFOV) / Header.Height);
    w1 := w + 1;
    SetLength(tmpBuf, w1 * 3);
    PW1 := PWord(Integer(PLight) + 6);
    PW0 := PW1;
    ClearSVec(Xpos);
    for y := 1 to 2 do  //calc first 2.+3. row
    begin
      if PLV.iPlanarOptic <> 2 then
        Xpos[1] := y * StepWidth;
      PLV.yPos := (y - 1 + CalcR.Top) / Header.Height;
      for x := 1 to w do
      begin
        if PLV.iPlanarOptic <> 2 then
          Xpos[0] := (x - 1 + CalcR.Left) * StepWidth;
        if ((PCardinal(PW1)^ and $80000000) = 0) and (PWord(Integer(PW1) + 8)^ < 32768) then
        begin
          PLV.xPos := (x + CalcR.Left) / Header.Width;
          s0 := (Sqr((8388352 - (PInteger(PW1)^ shr 8)) * ZcMul + 1) - 1) * dCorr;
          CalcViewVec(@PLV, sFOV, aspect);
          tmpBuf[x - 1 + y * w1] := AddSVectors(ScaleSVector(PLV.ViewVec, s0), Xpos);
        end
        else tmpBuf[x - 1 + y * w1][0] := -1e20;
        Inc(PW1, 9);
      end;
      tmpBuf[w + y * w1][0] := -1e20;
    end;
    for x := 0 to w do tmpBuf[x][0] := -1e20;

    for y := 1 to h do
    begin
      PLV.yPos := (y + 1 + CalcR.Top) / Header.Height;
      if PLV.iPlanarOptic <> 2 then
        Xpos[1] := (y + 2 + CalcR.Top) * StepWidth;
      for x := 0 to w - 1 do
      begin
        if tmpBuf[x + w1][0] > -1e19 then
        begin
          s0 := (Sqr((8388352 - (PInteger(PW0)^ shr 8)) * ZcMul + 1) - 1) * dCorr;
          s0 := StepWidth + s0 * DEstopFactor; // distance of 1 pixel at Z
          if tmpBuf[x][0] < -1e19 then
          begin
            if tmpBuf[x + 2 * w1][0] > -1e19 then
              svY := SubtractSVectors(@tmpBuf[x + w1], tmpBuf[x + 2 * w1])
            else svY := cSVecY;
          end
          else if tmpBuf[x + 2 * w1][0] > -1e19 then
            svY := RecCombSVec(SubtractSVectors(@tmpBuf[x], tmpBuf[x + w1]),
                               SubtractSVectors(@tmpBuf[x + w1], tmpBuf[x + 2 * w1]), s0)
          else svY := SubtractSVectors(@tmpBuf[x], tmpBuf[x + w1]);
          if tmpBuf[x + w][0] < -1e19 then
          begin
            if tmpBuf[x + 1 + w1][0] > -1e19 then
              svX := SubtractSVectors(@tmpBuf[x + w1], tmpBuf[x + 1 + w1])
            else svX := cSVecX;
          end
          else if tmpBuf[x + 1 + w1][0] > -1e19 then
            svX := RecCombSVec(SubtractSVectors(@tmpBuf[x + w], tmpBuf[x + w1]),
                               SubtractSVectors(@tmpBuf[x + w1], tmpBuf[x + 1 + w1]), s0)
          else svX := SubtractSVectors(@tmpBuf[x + w], tmpBuf[x + w1]);

        //  svX := SVectorCross(svY, svX);
          SVecToNormals(SVectorCross(svY, svX), Pointer(Integer(PW0) - 6));
       {   NormaliseSVectorToS(32767, svX);
          PSmallInt(Integer(PW0) - 6)^ := Round(svX[0]);  //NormalX
          PSmallInt(Integer(PW0) - 4)^ := Round(svX[1]);  //NormalY
          PSmallInt(Integer(PW0) - 2)^ := Round(svX[2]);  //NormalZ   }
        end;
        Inc(PW0, 9);
      end;
      for x := 0 to w - 1 do
      begin
        tmpBuf[x] := tmpBuf[x + w1];
        tmpBuf[x + w1] := tmpBuf[x + 2 * w1];
        if y < h - 1 then
        begin
          if ((PCardinal(PW1)^ and $80000000) = 0) and (PWord(Integer(PW1) + 8)^ < 32768) then
          begin
            if PLV.iPlanarOptic <> 2 then
              Xpos[0] := (x + CalcR.Left) * StepWidth;
            PLV.xPos := (x + 1 + CalcR.Left) / Header.Width;
            s0 := (Sqr((8388352 - (PInteger(PW1)^ shr 8)) * ZcMul + 1) - 1) * dCorr;
            CalcViewVec(@PLV, sFOV, aspect);
            tmpBuf[x + 2 * w1] := AddSVectors(ScaleSVector(PLV.ViewVec, s0), Xpos);
          end
          else tmpBuf[x + 2 * w1][0] := -1e20;
          Inc(PW1, 9);
        end
        else tmpBuf[x + 2 * w1][0] := -1e20;
      end;
    end;
    SetLength(tmpBuf, 0);
end;
                               //eax        edx
function ColToSVecFlipRBc4(c: T4Cardinal): T4SVec;
asm
    push ebx
    push esi
    push edi
    add  esp, -16
    mov  ebx, [eax]
    mov  ecx, [eax + 4]
    mov  esi, [eax + 8]
    mov  edi, [eax + 12]
    mov  ebx, [ebx + 2]       //dereferenz
    mov  ecx, [ecx + 2]
    mov  esi, [esi + 2]
    mov  edi, [edi + 2]
    and  ebx, $FF
    and  ecx, $FF
    and  esi, $FF
    and  edi, $FF
    mov  [esp], ebx
    mov  [esp + 4], ecx
    mov  [esp + 8], esi
    mov  [esp + 12], edi
    fild dword [esp]
    fild dword [esp + 4]
    fild dword [esp + 8]
    fild dword [esp + 12]
    fstp dword [edx + 48]
    fstp dword [edx + 32]
    fstp dword [edx + 16]
    fstp dword [edx]
    mov  ebx, [eax]
    mov  ecx, [eax + 4]
    mov  esi, [eax + 8]
    mov  edi, [eax + 12]
    mov  ebx, [ebx + 1]       //dereferenz
    mov  ecx, [ecx + 1]
    mov  esi, [esi + 1]
    mov  edi, [edi + 1]
    and  ebx, $FF
    and  ecx, $FF
    and  esi, $FF
    and  edi, $FF
    mov  [esp], ebx
    mov  [esp + 4], ecx
    mov  [esp + 8], esi
    mov  [esp + 12], edi
    fild dword [esp]
    fild dword [esp + 4]
    fild dword [esp + 8]
    fild dword [esp + 12]
    fstp dword [edx + 52]
    fstp dword [edx + 36]
    fstp dword [edx + 20]
    fstp dword [edx + 4]
    mov  ebx, [eax]
    mov  ecx, [eax + 4]
    mov  esi, [eax + 8]
    mov  edi, [eax + 12]
    mov  ebx, [ebx]       //dereferenz
    mov  ecx, [ecx]
    mov  esi, [esi]
    mov  edi, [edi]
    and  ebx, $FF
    and  ecx, $FF
    and  esi, $FF
    and  edi, $FF
    xor  eax, eax
    mov  [esp], ebx
    mov  [esp + 4], ecx
    mov  [esp + 8], esi
    mov  [esp + 12], edi
    fild dword [esp]
    fild dword [esp + 4]
    fild dword [esp + 8]
    fild dword [esp + 12]
    mov  [edx + 12], eax
    mov  [edx + 28], eax
    mov  [edx + 44], eax
    mov  [edx + 60], eax
    fstp dword [edx + 56]
    fstp dword [edx + 40]
    fstp dword [edx + 24]
    fstp dword [edx + 8]
    add  esp, 16
    pop  edi
    pop  esi
    pop  ebx
end;
                          //eax        edx   ecx
procedure ColToSVecSSE2(c: T4Cardinal; sv, svout: TPSVec);
asm                                   //CVTDQ2PS: sse2 - 4 ints to 4 singles
    MOVDQU xmm5, [edx]                //PSRLDQ: sse2 - xmm1, imm8 Shift xmm1 right by imm8 while shifting in 0s.
    add esp, -16
    mov edx, [eax]
    mov edx, [edx]
    mov [esp], edx
    mov edx, [eax + 4]
    mov edx, [edx]
    mov [esp + 4], edx
    mov edx, [eax + 8]
    mov eax, [eax + 12]
    mov edx, [edx]
    mov eax, [eax]
    mov [esp + 8], edx
    mov [esp + 12], eax
    movss  xmm0, s1d255
    MOVDQU xmm1, [esp]  //[eax]  4 cardinal colors
    MOVDQU xmm4, sva1
    MOVDQA xmm2, xmm1                   //todo: use input pointers, load vals before
    MOVDQA xmm3, xmm1
    PSRLDQ xmm2, 1          //green
    PSRLDQ xmm3, 2          //blue
    shufps xmm0, xmm0, 0
    andps  xmm1, xmm4       //red  or $FF000000FF000000FF000000FF
    andps  xmm2, xmm4
    andps  xmm3, xmm4
    mulps  xmm5, xmm0
    CVTDQ2PS xmm1, xmm1
    CVTDQ2PS xmm2, xmm2
    CVTDQ2PS xmm3, xmm3
    mulps  xmm1, xmm5
    mulps  xmm2, xmm5
    mulps  xmm3, xmm5

    MOVLHPS xmm4, xmm1   //HADDD   L1,.. (H,L)
    movhlps xmm4, xmm3   //L1,H3
    shufps  xmm3, xmm1, $E4 //H1,L3
    MOVHLPS xmm0, xmm2   //..,H2
    addps  xmm4, xmm3    //11,33
    addps  xmm0, xmm2    //..,22
    pshufd xmm5, xmm4, $B1   //can't copy 1 dw to more than 1 dest!
    pshufd xmm2, xmm0, $B1
    addps  xmm5, xmm4    //3,1
    addss  xmm2, xmm0    //.,2

    movups [ecx], xmm5              // r,.,b
    movss  [ecx + 4], xmm2          // .,g,.
    add esp, 16
end;

procedure ColToSVecSqrSSE2(c: T4Cardinal; sv, svout: TPSVec);  //svout := sumof([0..3] cardinal colors * sv[0..3])
const scmul: Single = 1 / 65025;
asm                         // eax       edx   ecx
    MOVDQU xmm5, [edx]
    add esp, -16
    mov edx, [eax]
    mov edx, [edx]
    mov [esp], edx
    mov edx, [eax + 4]
    mov edx, [edx]
    mov [esp + 4], edx
    mov edx, [eax + 8]
    mov eax, [eax + 12]
    mov edx, [edx]
    mov eax, [eax]
    mov [esp + 8], edx
    mov [esp + 12], eax
    movss  xmm0, scmul
    MOVDQU xmm1, [esp]
    MOVDQU xmm4, sva1
    MOVDQA xmm2, xmm1
    MOVDQA xmm3, xmm1
    PSRLDQ xmm2, 1
    PSRLDQ xmm3, 2
    shufps xmm0, xmm0, 0
    andps  xmm1, xmm4
    andps  xmm2, xmm4
    andps  xmm3, xmm4
    mulps  xmm5, xmm0
    CVTDQ2PS xmm1, xmm1
    CVTDQ2PS xmm2, xmm2
    CVTDQ2PS xmm3, xmm3
    mulps  xmm1, xmm1
    mulps  xmm2, xmm2
    mulps  xmm3, xmm3
    mulps  xmm1, xmm5
    mulps  xmm2, xmm5
    mulps  xmm3, xmm5

    MOVLHPS xmm4, xmm1   //HADDD   L1,.. (H,L)
    movhlps xmm4, xmm3   //L1,H3
    shufps  xmm3, xmm1, $E4 //H1,L3
    MOVHLPS xmm0, xmm2   //..,H2
    addps  xmm4, xmm3    //11,33
    addps  xmm0, xmm2    //..,22
    pshufd xmm5, xmm4, $B1   //can't copy 1 dw to more than 1 dest!
    pshufd xmm2, xmm0, $B1
    addps  xmm5, xmm4    //3,1
    addss  xmm2, xmm0    //.,2

    movups [ecx], xmm5              // r,.,b
    movss  [ecx + 4], xmm2          // .,g,.
    add esp, 16
end;

procedure ColToSVecSqrSSE2_16(c: T4Cardinal; sv, svout: TPSVec);  //svout := sumof([0..3] cardinal colors * sv[0..3])
const csmul: Single = 1 {255.0} / (65535.0 * 65535.0);
asm
    MOVDQU xmm5, [edx]
    add esp, -16
    mov edx, [eax]
    mov edx, [edx]
    mov [esp], edx
    mov edx, [eax + 4]
    mov edx, [edx]
    mov [esp + 4], edx
    mov edx, [eax + 8]
    mov edx, [edx]
    mov [esp + 8], edx
    mov edx, [eax + 12]
    mov edx, [edx]
    mov [esp + 12], edx
    movss  xmm0, csmul
    MOVDQU xmm1, [esp]
    MOVDQU xmm4, sva16
    MOVDQA xmm2, xmm1
    mov edx, [eax]
    mov edx, [edx + 4]
    mov [esp], edx
    mov edx, [eax + 4]
    mov edx, [edx + 4]
    mov [esp + 4], edx
    mov edx, [eax + 8]
    mov eax, [eax + 12]
    mov edx, [edx + 4]
    mov eax, [eax + 4]
    mov [esp + 8], edx
    mov [esp + 12], eax
    MOVDQA xmm2, xmm1
    MOVDQU xmm3, [esp]
    PSRLDQ xmm2, 2
    shufps xmm0, xmm0, 0
    andps  xmm1, xmm4
    andps  xmm2, xmm4
    andps  xmm3, xmm4
    mulps  xmm5, xmm0
    CVTDQ2PS xmm1, xmm1
    CVTDQ2PS xmm2, xmm2
    CVTDQ2PS xmm3, xmm3
    mulps  xmm1, xmm1
    mulps  xmm2, xmm2
    mulps  xmm3, xmm3
    mulps  xmm1, xmm5
    mulps  xmm2, xmm5
    mulps  xmm3, xmm5

    MOVLHPS xmm4, xmm1
    movhlps xmm4, xmm3
    shufps  xmm3, xmm1, $E4
    MOVHLPS xmm0, xmm2
    addps  xmm4, xmm3
    addps  xmm0, xmm2
    pshufd xmm5, xmm4, $B1
    pshufd xmm2, xmm0, $B1
    addps  xmm5, xmm4
    addss  xmm2, xmm0

    movups [ecx], xmm5              // r,.,b
    movss  [ecx + 4], xmm2          // .,g,.
    add esp, 16
end;

procedure ColToSVecSSE2_16(c: T4Cardinal; sv, svout: TPSVec);  //svout := sumof([0..3] cardinal colors * sv[0..3])
const csmul: Single = 1 {255.0} / 65535.0;
asm
    MOVDQU xmm5, [edx]
    add esp, -16
    mov edx, [eax]
    mov edx, [edx]
    mov [esp], edx
    mov edx, [eax + 4]
    mov edx, [edx]
    mov [esp + 4], edx
    mov edx, [eax + 8]
    mov edx, [edx]
    mov [esp + 8], edx
    mov edx, [eax + 12]
    mov edx, [edx]
    mov [esp + 12], edx
    movss  xmm0, csmul
    MOVDQU xmm1, [esp]
    MOVDQU xmm4, sva16
    MOVDQA xmm2, xmm1
    mov edx, [eax]
    mov edx, [edx + 4]
    mov [esp], edx
    mov edx, [eax + 4]
    mov edx, [edx + 4]
    mov [esp + 4], edx
    mov edx, [eax + 8]
    mov eax, [eax + 12]
    mov edx, [edx + 4]
    mov eax, [eax + 4]
    mov [esp + 8], edx
    mov [esp + 12], eax
    MOVDQA xmm2, xmm1
    MOVDQU xmm3, [esp]
    PSRLDQ xmm2, 2
    shufps xmm0, xmm0, 0
    andps  xmm1, xmm4
    andps  xmm2, xmm4
    andps  xmm3, xmm4
    mulps  xmm5, xmm0
    CVTDQ2PS xmm1, xmm1
    CVTDQ2PS xmm2, xmm2
    CVTDQ2PS xmm3, xmm3
    mulps  xmm1, xmm5
    mulps  xmm2, xmm5
    mulps  xmm3, xmm5

    MOVLHPS xmm4, xmm1
    movhlps xmm4, xmm3
    shufps  xmm3, xmm1, $E4
    MOVHLPS xmm0, xmm2
    addps  xmm4, xmm3
    addps  xmm0, xmm2
    pshufd xmm5, xmm4, $B1
    pshufd xmm2, xmm0, $B1
    addps  xmm5, xmm4
    addss  xmm2, xmm0

    movups [ecx], xmm5              // r,.,b
    movss  [ecx + 4], xmm2          // .,g,.
    add esp, 16
end;

function ColToSVecFlipRBc4sqr(c: T4Cardinal): T4SVec;
asm
    push ebx
    push esi
    push edi
    add  esp, -16
    mov  ebx, [eax]
    mov  ecx, [eax + 4]
    mov  esi, [eax + 8]
    mov  edi, [eax + 12]
    mov  ebx, [ebx + 2]       //dereferenz
    mov  ecx, [ecx + 2]
    mov  esi, [esi + 2]
    mov  edi, [edi + 2]
    and  ebx, $FF
    and  ecx, $FF
    and  esi, $FF
    and  edi, $FF
    fld  s1d255
    mov  [esp], ebx
    mov  [esp + 4], ecx
    mov  [esp + 8], esi
    mov  [esp + 12], edi
    fild dword [esp]
    fild dword [esp + 4]
    fild dword [esp + 8]
    fild dword [esp + 12]
    fmul st, st(0)
    fmul st, st(4)
    fstp dword [edx + 48]
    fmul st, st(0)
    fmul st, st(3)
    fstp dword [edx + 32]
    fmul st, st(0)
    fmul st, st(2)
    fstp dword [edx + 16]
    fmul st, st(0)
    fmul st, st(1)
    fstp dword [edx]
    mov  ebx, [eax]
    mov  ecx, [eax + 4]
    mov  esi, [eax + 8]
    mov  edi, [eax + 12]
    mov  ebx, [ebx + 1]       //dereferenz
    mov  ecx, [ecx + 1]
    mov  esi, [esi + 1]
    mov  edi, [edi + 1]
    and  ebx, $FF
    and  ecx, $FF
    and  esi, $FF
    and  edi, $FF
    mov  [esp], ebx
    mov  [esp + 4], ecx
    mov  [esp + 8], esi
    mov  [esp + 12], edi
    fild dword [esp]
    fild dword [esp + 4]
    fild dword [esp + 8]
    fild dword [esp + 12]
    fmul st, st(0)
    fmul st, st(4)
    fstp dword [edx + 52]
    fmul st, st(0)
    fmul st, st(3)
    fstp dword [edx + 36]
    fmul st, st(0)
    fmul st, st(2)
    fstp dword [edx + 20]
    fmul st, st(0)
    fmul st, st(1)
    fstp dword [edx + 4]
    mov  ebx, [eax]
    mov  ecx, [eax + 4]
    mov  esi, [eax + 8]
    mov  edi, [eax + 12]
    mov  ebx, [ebx]       //dereferenz
    mov  ecx, [ecx]
    mov  esi, [esi]
    mov  edi, [edi]
    and  ebx, $FF
    and  ecx, $FF
    and  esi, $FF
    and  edi, $FF
    xor  eax, eax
    mov  [esp], ebx
    mov  [esp + 4], ecx
    mov  [esp + 8], esi
    mov  [esp + 12], edi
    fild dword [esp]
    fild dword [esp + 4]
    fild dword [esp + 8]
    fild dword [esp + 12]
    mov  [edx + 12], eax
    fmul st, st(0)
    mov  [edx + 28], eax
    mov  [edx + 44], eax
    fmul st, st(4)
    mov  [edx + 60], eax
    fstp dword [edx + 56]
    fmul st, st(0)
    fmul st, st(3)
    fstp dword [edx + 40]
    fmul st, st(0)
    fmul st, st(2)
    fstp dword [edx + 24]
    fmul st, st(0)
    fmulp
    fstp dword [edx + 8]
    add  esp, 16
    pop  edi
    pop  esi
    pop  ebx
end;
                                   // eax         edx
function ColToSVecFlipRBc4sqr16(c: T4Cardinal): T4SVec;
const cdmul: Double = 255.0 / (65535.0 * 65535.0);
asm
    push ebx
    push esi
    push edi
    add  esp, -16
    mov  ebx, [eax]       //pointers
    mov  ecx, [eax + 4]
    mov  esi, [eax + 8]
    mov  edi, [eax + 12]
    mov  ebx, [ebx + 4]       //dereferenz
    mov  ecx, [ecx + 4]
    mov  esi, [esi + 4]
    mov  edi, [edi + 4]
    and  ebx, $FFFF
    and  ecx, $FFFF
    and  esi, $FFFF
    and  edi, $FFFF
    fld  cdmul
    mov  [esp], ebx
    mov  [esp + 4], ecx
    mov  [esp + 8], esi
    mov  [esp + 12], edi
    fild dword [esp]
    fild dword [esp + 4]
    fild dword [esp + 8]
    fild dword [esp + 12]
    fmul st, st(0)
    fmul st, st(4)
    fstp dword [edx + 48]
    fmul st, st(0)
    fmul st, st(3)
    fstp dword [edx + 32]
    fmul st, st(0)
    fmul st, st(2)
    fstp dword [edx + 16]
    fmul st, st(0)
    fmul st, st(1)
    fstp dword [edx]
    mov  ebx, [eax]
    mov  ecx, [eax + 4]
    mov  esi, [eax + 8]
    mov  edi, [eax + 12]
    mov  ebx, [ebx + 2]       //dereferenz
    mov  ecx, [ecx + 2]
    mov  esi, [esi + 2]
    mov  edi, [edi + 2]
    and  ebx, $FFFF
    and  ecx, $FFFF
    and  esi, $FFFF
    and  edi, $FFFF
    mov  [esp], ebx
    mov  [esp + 4], ecx
    mov  [esp + 8], esi
    mov  [esp + 12], edi
    fild dword [esp]        //loads signed integer, therefore 16 bit direct iload would fail
    fild dword [esp + 4]
    fild dword [esp + 8]
    fild dword [esp + 12]
    fmul st, st(0)
    fmul st, st(4)
    fstp dword [edx + 52]
    fmul st, st(0)
    fmul st, st(3)
    fstp dword [edx + 36]
    fmul st, st(0)
    fmul st, st(2)
    fstp dword [edx + 20]
    fmul st, st(0)
    fmul st, st(1)
    fstp dword [edx + 4]
    mov  ebx, [eax]
    mov  ecx, [eax + 4]
    mov  esi, [eax + 8]
    mov  edi, [eax + 12]
    mov  ebx, [ebx]       //dereferenz
    mov  ecx, [ecx]
    mov  esi, [esi]
    mov  edi, [edi]
    and  ebx, $FFFF
    and  ecx, $FFFF
    and  esi, $FFFF
    and  edi, $FFFF
    xor  eax, eax
    mov  [esp], ebx
    mov  [esp + 4], ecx
    mov  [esp + 8], esi
    mov  [esp + 12], edi
    fild dword [esp]
    fild dword [esp + 4]
    fild dword [esp + 8]
    fild dword [esp + 12]
    mov  [edx + 12], eax
    mov  [edx + 28], eax
    fmul st, st(0)
    mov  [edx + 44], eax
    fmul st, st(4)
    mov  [edx + 60], eax
    fstp dword [edx + 56]
    fmul st, st(0)
    fmul st, st(3)
    fstp dword [edx + 40]
    fmul st, st(0)
    fmul st, st(2)
    fstp dword [edx + 24]
    fmul st, st(0)
    fmulp
    fstp dword [edx + 8]
    add  esp, 16
    pop  edi
    pop  esi
    pop  ebx
end;

function ColToSVecFlipRBc416(c: T4Cardinal): T4SVec;
asm
    push ebx
    push esi
    push edi
    add  esp, -16
    mov  ebx, [eax]       //pointers
    mov  ecx, [eax + 4]
    mov  esi, [eax + 8]
    mov  edi, [eax + 12]
    mov  ebx, [ebx + 4]       //dereferenz
    mov  ecx, [ecx + 4]
    mov  esi, [esi + 4]
    mov  edi, [edi + 4]
    and  ebx, $FFFF
    and  ecx, $FFFF
    and  esi, $FFFF
    and  edi, $FFFF
    fld  d1d256
    mov  [esp], ebx
    mov  [esp + 4], ecx
    mov  [esp + 8], esi
    mov  [esp + 12], edi
    fild dword [esp]
    fild dword [esp + 4]
    fild dword [esp + 8]
    fild dword [esp + 12]
    fmul st, st(4)
    fstp dword [edx + 48]
    fmul st, st(3)
    fstp dword [edx + 32]
    fmul st, st(2)
    fstp dword [edx + 16]
    fmul st, st(1)
    fstp dword [edx]
    mov  ebx, [eax]
    mov  ecx, [eax + 4]
    mov  esi, [eax + 8]
    mov  edi, [eax + 12]
    mov  ebx, [ebx + 2]       //dereferenz
    mov  ecx, [ecx + 2]
    mov  esi, [esi + 2]
    mov  edi, [edi + 2]
    and  ebx, $FFFF
    and  ecx, $FFFF
    and  esi, $FFFF
    and  edi, $FFFF
    mov  [esp], ebx
    mov  [esp + 4], ecx
    mov  [esp + 8], esi
    mov  [esp + 12], edi
    fild dword [esp]        //loads signed integer, therefore 16 bit direct iload would fail
    fild dword [esp + 4]
    fild dword [esp + 8]
    fild dword [esp + 12]
    fmul st, st(4)
    fstp dword [edx + 52]
    fmul st, st(3)
    fstp dword [edx + 36]
    fmul st, st(2)
    fstp dword [edx + 20]
    fmul st, st(1)
    fstp dword [edx + 4]
    mov  ebx, [eax]
    mov  ecx, [eax + 4]
    mov  esi, [eax + 8]
    mov  edi, [eax + 12]
    mov  ebx, [ebx]       //dereferenz
    mov  ecx, [ecx]
    mov  esi, [esi]
    mov  edi, [edi]
    and  ebx, $FFFF
    and  ecx, $FFFF
    and  esi, $FFFF
    and  edi, $FFFF
    xor  eax, eax
    mov  [esp], ebx
    mov  [esp + 4], ecx
    mov  [esp + 8], esi
    mov  [esp + 12], edi
    fild dword [esp]
    fild dword [esp + 4]
    fild dword [esp + 8]
    fild dword [esp + 12]
    fmul st, st(4)
    mov  [edx + 12], eax
    mov  [edx + 28], eax
    mov  [edx + 44], eax
    mov  [edx + 60], eax
    fstp dword [edx + 56]
    fmul st, st(3)
    fstp dword [edx + 40]
    fmul st, st(2)
    fstp dword [edx + 24]
    fmulp
    fstp dword [edx + 8]
    add  esp, 16
    pop  edi
    pop  esi
    pop  ebx
end;

function FracA(d: Double): Double;
begin
    if d < 0 then Result := 1 + Frac(d)
             else Result := Frac(d);
end;

function GetLightMapPixelNN(const x, y: Single; LM: TPLightMap; bSqr: LongBool; WrapAround: Integer): TSVec;
var xf, yf: Integer;
begin
    with LM^ do           //nearest neighbour, no interpolation, for ambient maps in MCrendering for example
    begin
      xf := Round(Clamp01S(x) * sLMXfactor);
      yf := Round(Clamp01S(y) * sLMYfactor);
      if iMapType = 1 then
        Result := WordColToSVecFlipRBScale(TP3word(iLMstart + 6 * (xf + yf * (LMWidth + 1))), sIntensity, bSqr)
      else Result := ScaleSVector(ColToSVecFlipRBNoScale(PCardinal(iLMstart + 4 * (xf + yf * (LMWidth + 1)))^, bSqr), s1d255 * sIntensity);
    end;
end;

function GetLightMapPixelSphereNN(const svec: TSVec; SM: TPSMatrix3; LM: TPLightMap; bSqr: LongBool): TSVec;
var sv: TSVec;
begin
    sv := NormaliseSVector(svec);
    if SM <> nil then RotateSVectorS(@sv, SM);
    Result := GetLightMapPixelNN(ArcTan2(sv[0], sv[2]) * MPi05d + s05, s05 - ArcSinSafe(sv[1]) * Pi1d, LM, bSqr, 0);
end;
                        //0..1 range for x and y                            //0: no  1: hor+vert  2: horiz. only
function GetLightMapPixel(const x, y: Single; LM: TPLightMap; bSqr: LongBool; WrapAround: Integer): TSVec;
var xf, yf, ipos, nx1, nx2, nx3, il, im: Integer;
    cv: T4Cardinal;
    xv, yv: TSVec;
    sv: T4SVec;
    svy: T3SVec;
    xs, ys: Single;
    fCol2SVec: TCol2SVec;
    fCol2SVecPas: TCol2SVecX87;
begin                             //bicubic spline interpolation
    with LM^ do
    if LMWidth > 4 then
    begin
      xs := Clamp01S(x) * sLMXfactor;  //no wraparound here, just for interpolation
      ys := Clamp01S(y) * sLMYfactor;

      xf := Min(LMWidth - 1, Trunc(xs));
      yf := Min(LMHeight - 1, Trunc(ys));
      xv := MakeSplineCoeff(xs - xf);
      yv := MakeSplineCoeff(ys - yf);

      if iMapType = 1 then im := 6 else im := 4;

      if WrapAround > 0 then
      begin
        if xf > 0           then nx1 := -im    else nx1 := (LMWidth - 1) * im;
        if xf < LMWidth - 1 then nx2 := im * 2 else nx2 := (2 - LMWidth) * im;    //all * 6 div 4 for 48bit maps
        if xf < LMWidth     then nx3 := im     else nx3 := (1 - LMWidth) * im;
      end else begin
        if xf > 0           then nx1 := -im    else nx1 := 0;
        if xf < LMWidth - 1 then nx3 := im     else nx3 := 0;
        if xf < LMWidth - 2 then nx2 := im * 2 else nx2 := nx3;
      end;
      il := (LMWidth + 1) * im;
      if WrapAround = 1 then
      begin
        if yf > 0 then Dec(yf) else Inc(yf, LMHeight - 1);
        xf   := iLMstart + xf * im;
        ipos := xf + il * yf;
      end
      else
      begin
        Dec(yf);
        xf   := iLMstart + xf * im;
        ipos := xf + il * Max(0, yf);
      end;

      cv[0] := ipos + nx1;   //pointers
      cv[1] := ipos;
      cv[2] := ipos + nx3;
      cv[3] := ipos + nx2;

      if SupportSSE2 then
      begin
        if im = 6 then
        begin
          if bSqr then fCol2SVec := ColToSVecSqrSSE2_16 else fCol2SVec := ColToSVecSSE2_16;
        end
        else if bSqr then fCol2SVec := ColToSVecSqrSSE2 else fCol2SVec := ColToSVecSSE2;
        fCol2SVec(cv, @xv, @svy[0]);
        if yf < 0 then Inc(yf) else if yf < LMHeight - 1 then
        begin
          Inc(yf);
          Inc(ipos, il);
        end
        else if WrapAround = 1 then
        begin
          yf := 0;
          ipos := xf;
        end;
        cv[0] := ipos + nx1;
        cv[1] := ipos;
        cv[2] := ipos + nx3;
        cv[3] := ipos + nx2;
        fCol2SVec(cv, @xv, @svy[1]);
        if yf < LMHeight - 1 then
        begin
          Inc(yf);
          Inc(ipos, il);
        end
        else if WrapAround = 1 then
        begin
          yf := 0;
          ipos := xf;
        end;
        cv[0] := ipos + nx1;
        cv[1] := ipos;
        cv[2] := ipos + nx3;
        cv[3] := ipos + nx2;
        fCol2SVec(cv, @xv, @svy[2]);
        if yf < LMHeight - 1 then Inc(ipos, il) else
        if WrapAround = 1 then ipos := xf;
        cv[0] := ipos + nx1;
        cv[1] := ipos;
        cv[2] := ipos + nx3;
        cv[3] := ipos + nx2;
        fCol2SVec(cv, @xv, @sv[0]);
        Result[0] := svy[0][0] * yv[0] + svy[1][0] * yv[1] + svy[2][0] * yv[2] + sv[0][0] * yv[3];
        Result[1] := svy[0][1] * yv[0] + svy[1][1] * yv[1] + svy[2][1] * yv[2] + sv[0][1] * yv[3];
        Result[2] := svy[0][2] * yv[0] + svy[1][2] * yv[1] + svy[2][2] * yv[2] + sv[0][2] * yv[3];
      end
      else
      begin
        if im = 6 then
        begin
          if bSqr then fCol2SVecPas := ColToSVecFlipRBc4sqr16
                  else fCol2SVecPas := ColToSVecFlipRBc416;
        end
        else if bSqr then fCol2SVecPas := ColToSVecFlipRBc4sqr
                     else fCol2SVecPas := ColToSVecFlipRBc4;
        sv := fCol2SVecPas(cv);
        svy[0][0] := sv[0][0] * xv[0] + sv[1][0] * xv[1] + sv[2][0] * xv[2] + sv[3][0] * xv[3];
        svy[0][1] := sv[0][1] * xv[0] + sv[1][1] * xv[1] + sv[2][1] * xv[2] + sv[3][1] * xv[3];
        svy[0][2] := sv[0][2] * xv[0] + sv[1][2] * xv[1] + sv[2][2] * xv[2] + sv[3][2] * xv[3];
        if yf < 0 then Inc(yf) else if yf < LMHeight - 1 then
        begin
          Inc(yf);
          Inc(ipos, il);
        end
        else if WrapAround = 1 then
        begin
          yf := 0;
          ipos := xf;
        end;
        cv[0] := ipos + nx1;
        cv[1] := ipos;
        cv[2] := ipos + nx3;
        cv[3] := ipos + nx2;
        sv := fCol2SVecPas(cv);
        svy[1][0] := sv[0][0] * xv[0] + sv[1][0] * xv[1] + sv[2][0] * xv[2] + sv[3][0] * xv[3];
        svy[1][1] := sv[0][1] * xv[0] + sv[1][1] * xv[1] + sv[2][1] * xv[2] + sv[3][1] * xv[3];
        svy[1][2] := sv[0][2] * xv[0] + sv[1][2] * xv[1] + sv[2][2] * xv[2] + sv[3][2] * xv[3];
        if yf < LMHeight - 1 then
        begin
          Inc(yf);
          Inc(ipos, il);
        end
        else if WrapAround = 1 then
        begin
          yf := 0;
          ipos := xf;
        end;
        cv[0] := ipos + nx1;
        cv[1] := ipos;
        cv[2] := ipos + nx3;
        cv[3] := ipos + nx2;
        sv := fCol2SVecPas(cv);
        svy[2][0] := sv[0][0] * xv[0] + sv[1][0] * xv[1] + sv[2][0] * xv[2] + sv[3][0] * xv[3];
        svy[2][1] := sv[0][1] * xv[0] + sv[1][1] * xv[1] + sv[2][1] * xv[2] + sv[3][1] * xv[3];
        svy[2][2] := sv[0][2] * xv[0] + sv[1][2] * xv[1] + sv[2][2] * xv[2] + sv[3][2] * xv[3];
        if yf < LMHeight - 1 then Inc(ipos, il) else
        if WrapAround = 1 then ipos := xf;
        cv[0] := ipos + nx1;
        cv[1] := ipos;
        cv[2] := ipos + nx3;
        cv[3] := ipos + nx2;
        sv := fCol2SVecPas(cv);
        Result[0] := (svy[0][0] * yv[0] + svy[1][0] * yv[1] + svy[2][0] * yv[2] +
                     (sv[0][0] * xv[0] + sv[1][0] * xv[1] + sv[2][0] * xv[2] + sv[3][0] * xv[3]) * yv[3]) * s1d255;
        Result[1] := (svy[0][1] * yv[0] + svy[1][1] * yv[1] + svy[2][1] * yv[2] +
                     (sv[0][1] * xv[0] + sv[1][1] * xv[1] + sv[2][1] * xv[2] + sv[3][1] * xv[3]) * yv[3]) * s1d255;
        Result[2] := (svy[0][2] * yv[0] + svy[1][2] * yv[1] + svy[2][2] * yv[2] +
                     (sv[0][2] * xv[0] + sv[1][2] * xv[1] + sv[2][2] * xv[2] + sv[3][2] * xv[3]) * yv[3]) * s1d255;
      end;
      ScaleSVectorV(@Result, sIntensity);
    end;
end;

function GetLightMapPixelSphere(const svec: TSVec; SM: TPSMatrix3; LM: TPLightMap; bSqr: LongBool): TSVec;
var sv: TSVec;
begin
    sv := NormaliseSVector(svec);
    if SM <> nil then RotateSVectorS(@sv, SM);
    Result := GetLightMapPixel(ArcTan2(sv[0], sv[2]) * MPi05d + s05, s05 - ArcSinSafe(sv[1]) * Pi1d, LM, bSqr, 2);
end;

procedure MakeLMPreviewImage(image: TImage; LM: TPLightMap);
var pcb: PCardinal;
    x, y, i, it, im: Integer;
    dy, dx: Double;
begin
    if (LM.LMWidth = 0) or (LM.LMnumber = 0) then image.Visible := False else
    with image.Picture.Bitmap do
    begin
      if LM.iMapType = 1 then im := 6 else im := 4;
      if PixelFormat <> pf32bit then PixelFormat := pf32bit;
      if (Width <> image.Width) or (Height <> image.Height) then
        SetSize(image.Width, image.Height);
      dy := (LM.LMHeight - 1) / (Height - 1);
      dx := (LM.LMWidth - 1) / (Width - 1);
      for y := 0 to Height - 1 do
      begin
        pcb := ScanLine[y];
        i := LM.iLMstart + Round(dy * y) * (LM.LMWidth + 1) * im;
        if im = 6 then
        for x := 0 to Width - 1 do
        begin
          it := i + im * Round(dx * x) + 1;
          pcb^ := Integer(PByte(it)^) or (Integer(PByte(it + 2)^) shl 8) or
                 (Integer(PByte(it + 4)^) shl 16);
          Inc(pcb);
        end
        else for x := 0 to Width - 1 do
        begin
          pcb^ := PCardinal(i + im * Round(dx * x))^;
          Inc(pcb);
        end;
      end;
      Modified := True;
      image.Visible := True;
    end;
end;

{function nohalo_get(xx, yy: Single; LM: TLightMap): TSVec;
var s1p, s1r, ix, iy, ipos:  Integer;
    rX, rY, x, y, xmy, wmy: Single;
    outs: array[0..11] of Single;
begin
    xx := MinMaxCS(0, xx, LM.LMWidth - 0.1);
    yy := MinMaxCS(0, yy, LM.LMHeight - 0.1);
    ix  := round(xx);
    iy  := round(yy);
    rX := xx - ix;
    rY := yy - iy;
    ipos := LM.iLMstart + LM.iLMYinc * (iy - 1) + ix * 4 - 4;
//    ps := @Bild[Bildnr].p[layer][(iy - 1) * wid + ix - 1];
    if rX >= 0 then
    begin
      x   := 2 * rX;
      s1p := 4;
    end else begin
      x   := -2 * rX;
      s1p := -4;
      Inc(ipos, 8);
    end;
    if rY >= 0 then
    begin
      y   := 2 * rY;
      s1r := LM.iLMYinc;
    end else begin
      y   := -2 * rY;
      s1r := -LM.iLMYinc;  // is shift for 1 row for bytewise pointer inc
      Inc(ipos, LM.iLMYinc * 2);
    end;
    outs[0] := PCardinal(ipos + s1p)^ and $FF;      //R
    outs[1] := PCardinal(ipos + s1p * 2)^ and $FF;
    Inc(ipos, s1r);
    outs[2] := PCardinal(ipos + s1p * 2)^ and $FF;
    asm
      push eax
      push ebx
      push ecx
      push edx
      push esi
      push edi
      mov  eax, s1p
      mov  edx, s1r
      mov  esi, ps
      lea  ebx, eax + 2 * eax     //ebx = 3 * s1p
      lea  edi, outs
      mov  ecx, [esi + eax]
      mov  [edi], ecx             //outs[0] := ps[+1pix]^
      mov  ecx, [esi + 2 * eax]
      mov  [edi + 4], ecx         //outs[1] :=
      add  esi, edx
      mov  ecx, [esi]
      mov  [edi + 8], ecx         //outs[2]
      mov  ecx, [esi + eax]
      mov  [edi + 12], ecx
      mov  ecx, [esi + 2 * eax]
      mov  [edi + 16], ecx        //outs[4]
      mov  ecx, [esi + ebx]
      mov  [edi + 20], ecx
      add  esi, edx
      mov  ecx, [esi]
      mov  [edi + 24], ecx        //outs[6]
      mov  ecx, [esi + eax]
      mov  [edi + 28], ecx
      mov  ecx, [esi + 2 * eax]
      mov  [edi + 32], ecx        //outs[8]
      mov  ecx, [esi + ebx]
      mov  [edi + 36], ecx
      add  esi, edx
      mov  ecx, [esi + eax]
      mov  [edi + 40], ecx
      mov  ecx, [esi + 2 * eax]
      mov  [edi + 44], ecx        //outs[11]
      pop  edi
      pop  esi
      pop  edx
      pop  ecx
      pop  ebx
      pop  eax
    end;
    xmy := x * y;
    wmy := y - xmy;
    Result := nohalo_sharp_level_1(1 - x - wmy, 0.5  * (x - xmy),
                                   0.5  * wmy, 0.25 * xmy, outs);
end;

function nohalo_sharp_level_1(const wm1, wm2, wm3, wm4: single;
                              const inp: array of single): single;
var d, s, ha, hs: array[1..12] of single;
    mul2, mul3, mul4: single;
begin
   d[1]  := inp[3]  - inp[2];
   d[2]  := inp[4]  - inp[3];
   d[3]  := inp[5]  - inp[4];
   d[4]  := inp[7]  - inp[6];
   d[5]  := inp[8]  - inp[7];
   d[6]  := inp[9]  - inp[8];
   d[7]  := inp[3]  - inp[0];
   d[8]  := inp[7]  - inp[3];
   d[9]  := inp[10] - inp[7];
   d[10] := inp[4]  - inp[1];
   d[11] := inp[8]  - inp[4];
   d[12] := inp[11] - inp[8];
   if SupportSSE then
   begin
   asm
     push eax
     push ebx
     push ecx
     mov eax, SIMDaCptr   // +64 = 0.5,  -32 = -1.0
     lea ebx, d
     lea ecx, s
     xorps   xmm7, xmm7
     movups  xmm0, [ebx]
     movups  xmm1, [ebx + 16]
     movups  xmm2, [ebx + 32]
     movaps  xmm3, xmm0
     movaps  xmm4, xmm1
     movaps  xmm5, xmm2
     cmpltps xmm0, xmm7
     cmpltps xmm1, xmm7
     cmpltps xmm2, xmm7
     andps   xmm0, [eax - 32]      // -1.0
     andps   xmm1, [eax - 32]
     andps   xmm2, [eax - 32]
     addps   xmm0, [eax + 64]      // 0.5
     addps   xmm1, [eax + 64]
     addps   xmm2, [eax + 64]
     mulps   xmm3, xmm0            // ha[1..4]
     mulps   xmm4, xmm1            // ha[5..8]
     mulps   xmm5, xmm2            // ha[9..12]
     movaps  xmm6, xmm0            //vorher noch: s1=s1+s2  s2=s2+s3 ...
     movaps  xmm7, xmm1
     shufps  xmm6, xmm1, 00001001b //s[2,3,..,5]
     movss   xmm7, xmm2            //s[9,6,7,8]
     shufps  xmm7, xmm7, 00110001b //$D0 s[6,..,8,9]
     addps   xmm0, xmm6            // s[1..4]  [s1+s2,s2+s3,..]
     addps   xmm1, xmm7
     movaps  xmm7, xmm2
     shufps  xmm7, xmm7, 00111000b // $38  s[..,11,12,..]
     addps   xmm2, xmm7
     movaps  xmm6, xmm3
     movaps  xmm7, xmm4
     shufps  xmm6, xmm4, 00001001b // $09   //ha[2,3,..,5]
     movss   xmm7, xmm5            // ha[9,6,7,8]
     shufps  xmm7, xmm7, 00110001b //11010000b  //ha[6,..,8,9]
     minps   xmm3, xmm6
     minps   xmm4, xmm7
     movaps  xmm6, xmm5
     mulps   xmm3, xmm0
     shufps  xmm6, xmm6, 00111000b // $38 ($E4)   //ha[..,11,12,..]
     mulps   xmm4, xmm1
     minps   xmm5, xmm6            //  ...  s1=hs1*s1
     mulps   xmm5, xmm2
     movups  [ecx], xmm3           // s[1..4]
     movups  [ecx + 16], xmm4
     movups  [ecx + 32], xmm5      // s[9..12]
     pop ecx
     pop ebx
     pop eax
   end;
     mul2 := inp[3] + inp[4] + s[1] - s[2];
     mul3 := inp[3] + inp[7] + s[7] - s[8];
     mul4 := inp[8] - inp[3] + mul2 + mul3 + s[4] - s[5] + s[10] - s[11];
   end
   else
   begin
     if d[1]  >= 0 then s[1]  := 0.5 else s[1]  := -0.5;
     if d[2]  >= 0 then s[2]  := 0.5 else s[2]  := -0.5;
     if d[3]  >= 0 then s[3]  := 0.5 else s[3]  := -0.5;
     if d[4]  >= 0 then s[4]  := 0.5 else s[4]  := -0.5;
     if d[5]  >= 0 then s[5]  := 0.5 else s[5]  := -0.5;
     if d[6]  >= 0 then s[6]  := 0.5 else s[6]  := -0.5;
     if d[7]  >= 0 then s[7]  := 0.5 else s[7]  := -0.5;
     if d[8]  >= 0 then s[8]  := 0.5 else s[8]  := -0.5;
     if d[9]  >= 0 then s[9]  := 0.5 else s[9]  := -0.5;
     if d[10] >= 0 then s[10] := 0.5 else s[10] := -0.5;
     if d[11] >= 0 then s[11] := 0.5 else s[11] := -0.5;
     if d[12] >= 0 then s[12] := 0.5 else s[12] := -0.5;
     ha[1]  := s[1]  * d[1];
     ha[2]  := s[2]  * d[2];
     ha[3]  := s[3]  * d[3];
     ha[4]  := s[4]  * d[4];
     ha[5]  := s[5]  * d[5];
     ha[6]  := s[6]  * d[6];
     ha[7]  := s[7]  * d[7];
     ha[8]  := s[8]  * d[8];
     ha[9]  := s[9]  * d[9];
     ha[10] := s[10] * d[10];
     ha[11] := s[11] * d[11];
     ha[12] := s[12] * d[12];
     if ha[1]  < ha[2]  then hs[1]  := ha[1]  else hs[1]  := ha[2];
     if ha[2]  < ha[3]  then hs[2]  := ha[2]  else hs[2]  := ha[3];
     if ha[4]  < ha[5]  then hs[4]  := ha[4]  else hs[4]  := ha[5];
     if ha[5]  < ha[6]  then hs[5]  := ha[5]  else hs[5]  := ha[6];
     if ha[7]  < ha[8]  then hs[7]  := ha[7]  else hs[7]  := ha[8];
     if ha[8]  < ha[9]  then hs[8]  := ha[8]  else hs[8]  := ha[9];
     if ha[10] < ha[11] then hs[10] := ha[10] else hs[10] := ha[11];
     if ha[11] < ha[12] then hs[11] := ha[11] else hs[11] := ha[12];
     mul2 := inp[3] + inp[4] + (s[1] + s[2]) * hs[1] - (s[2] + s[3]) * hs[2];
     mul3 := inp[3] + inp[7] + (s[7] + s[8]) * hs[7] - (s[8] + s[9]) * hs[8];
     mul4 := inp[8] - inp[3] + mul2 + mul3 + (s[4] + s[5]) * hs[4] -
    (s[5] + s[6]) * hs[5] + (s[10] + s[11]) * hs[10] - (s[11] + s[12]) * hs[11];
   end;
   result := wm1 * inp[3] + wm2 * mul2 + wm3 * mul3 + wm4 * mul4;
end; }


end.
