unit Interpolation;

interface

uses TypeDefinitions, Math3D;

type
   TIPOLRotMatrices = record
     LightPicRotM: array[0..5] of TSMatrix3;
     BGPicRotM: TSMatrix3;
     DiffColRotM: TSMatrix3;
   end;
   TPIPOLRotMatrices = ^TIPOLRotMatrices;

function HeaderIdentic(H1, H2: TMandHeader11): Boolean;
procedure IniInterpolHeader;
function InterpolateColorB(C1, C2, C3: Cardinal; W1, W2, W3: Double): Cardinal;
function InterpolateColor(C1, C2: Cardinal; W1, W2: Double): Cardinal;
function InterpolateColorToSVec(C1, C2: Cardinal; w: Single): TSVec;
function InterpolateRGBColor(rgb1, rgb2: TRGB; W1, W2: Double): Cardinal;
procedure Interpolate2frames(H1, H2: TPMandHeader11; L1, L2: TPLightVals; t: Double);
procedure Interpolate3framesBezier(Hi1, Hi2, Hi3, Hi4: TPMandHeader11; Li1, Li2, Li3, Li4: TPLightVals; t: Double);
function Interpolate2Scols(sv1, sv2: TPSVec; W1, W2: Double): TSVec;
//procedure Interpolate4framesCubic(H1, H2, H3, H4: TPMandHeader10; L1, L2, L3, L4: TPLightVals; t: Double);
procedure CopyRotMatices(Rsource, Rdest: TPIPOLRotMatrices);
procedure CopyRotMfromLightVals(Rsource: TPLightVals; Rdest: TPIPOLRotMatrices);
function bInterpolateFormula(PA1, PA2: PTHeaderCustomAddon; AltNr: Integer): Boolean;

var
  InterpolHeader: TMandHeader11;
  InterpolHAddon: THeaderCustomAddon;
  InterpolLightVals: TLightVals;
  IPOLHybridCustoms: array[0..MAX_FORMULA_COUNT - 1] of TCustomFormula;
  IPOLM0: TIPOLRotMatrices;
  IPOLM1: TIPOLRotMatrices;
  IPOLM2: TIPOLRotMatrices;
  IPOLM3: TIPOLRotMatrices;
 { InterPolLightPicRotMs0: array[0..5] of TSMatrix3;
  InterPolLightPicRotMs1: array[0..5] of TSMatrix3;
  InterPolLightPicRotMs2: array[0..5] of TSMatrix3;
  InterPolLightPicRotMs3: array[0..5] of TSMatrix3; }

const
  IntParsToInterpolate: array[0..1] of Integer = (12, 135);  //Its, minIts, lightvals will be seperately interpolated!
  DoubleParsToInterpolate: array[0..12] of Integer = (20, 28, 36, 44, 52, 108, 191, 199, 207, 215, 346, 354, 362);  //...cuts
  DoubleAnglesToInterpolate: array[0..2] of Integer = (60, 68, 76);  //4d rotation in formula
  SingleParsToInterpolate: array[0..18] of Integer = (116, 120, 164, 168, 172, 177, 182, 226, 230, 234, 238, 242,
    319, 332, 338, 370, 374, 378, 410); //mZstepDiv: Single; #182  maxHSlen #226 #410  ->2nd focuspoint
  DoubleToInterpolateLog: array[0..1] of Integer = (84, 92); //Zoom, Rstop
//  ShortFloatToInterpolate: array[0..0] of Integer = (224); //MCSoftShadowRadius
{  ColorToInterpolate: array[0..37] of Integer = (484, 488, 492, 496, 500, 504,     //#432 is Light start pos
    508, 512, 516, 520, 526, 540, 554, 568, 582, 586, 592, 596, 602, 606, 612,
    616, 622, 626, 632, 636, 642, 646, 652, 656, 662, 666, 672, 676, 682, 688,
    694, 700);
  IntAnglesToInterpolate: array[0..7] of Integer = (530, 534, 544, 548, 558, 562,
    570, 574);
  WordPosToInterpolate: array[0..13] of Integer = (580, 590, 600, 610, 620, 630,
    640, 650, 660, 670, 680, 686, 692, 698);   }


implementation

uses DivUtils, SysUtils, Math, HeaderTrafos, CustomFormulas;

procedure CopyRotMatices(Rsource, Rdest: TPIPOLRotMatrices);
var i: Integer;
begin
    for i := 0 to 5 do Rdest^.LightPicRotM[i] := Rsource^.LightPicRotM[i];
    Rdest^.BGPicRotM := Rsource^.BGPicRotM;
    Rdest^.DiffColRotM := Rsource^.DiffColRotM;
end;

procedure CopyRotMfromLightVals(Rsource: TPLightVals; Rdest: TPIPOLRotMatrices);
var i: Integer;
begin
    for i := 0 to 5 do Rdest.LightPicRotM[i] := Rsource.LLightMaps[i].PicRotMatrix;  // access vio
    Rdest.BGPicRotM := Rsource.BGLightMap.PicRotMatrix;
    Rdest.DiffColRotM := Rsource.DiffColLightMap.PicRotMatrix;
end;

procedure IniInterpolHeader;
var i: Integer;
begin
    InterpolHeader.PCFAddon := @InterpolHAddon;
    for i := 0 to MAX_FORMULA_COUNT - 1 do InterpolHeader.PHCustomF[i] := @IPOLHybridCustoms[i];

end;

function bInterpolateFormula(PA1, PA2: PTHeaderCustomAddon; AltNr: Integer): Boolean;
begin
    Result := PA1.bOptions1 = PA2.bOptions1;
    if Result then
    begin
      if (PA1.bOptions1 and 3) = 1 then Result := SameCustomFNames(PA1, PA2, AltNr)
      else Result := (PA1.Formulas[AltNr].iItCount > 0) and (PA2.Formulas[AltNr].iItCount > 0) and
                     SameCustomFNames(PA1, PA2, AltNr);
    end;
end;

function HeaderIdentic(H1, H2: TMandHeader11): Boolean;   // todo: Integer with status: 0: ident, 1: update Light 2: calc HS + light
var i, j, k: Integer;                                                                // 2: calc complete (if DoF then calc it also)
    PF1, PF2: PTHAformula;
begin
    Result := CompareMem(@H1.Width, @H2.Width, 112)      //true if identical
          and CompareMem(@H1.bNormalsOnDE, @H2.bNormalsOnDE, 7)
          and CompareMem(@H1.bPlanarOptic, @H2.bPlanarOptic, 2)    //(H1.bCalcAmbShadowAutomatic = H2.bCalcAmbShadowAutomatic)
          and CompareMem(@H1.bVaryDEstopOnFOV, @H2.bVaryDEstopOnFOV, 24)
          and CompareMem(@H1.bIsJulia, @H2.bIsJulia, 34)
          and CompareMem(@H1.HSmaxLengthMultiplier, @H2.HSmaxLengthMultiplier, 92)
          and CompareMem(@H1.byCalcNsOnZBufAuto, @H2.byCalcNsOnZBufAuto, 14)
          and (H1.sAmbShadowThreshold = H2.sAmbShadowThreshold)
          and CompareMem(@H1.sDEAOmaxL, @H2.sDEAOmaxL, 8)
          and (H1.sDOFZsharp2 = H2.sDOFZsharp2)
          and CompareMem(@H1.iMaxItsF2, @H2.iMaxItsF2, 5);
    if Result then
    begin
      i := 0;
      Result := PTHeaderCustomAddon(H1.PCFAddon).bOptions1 = PTHeaderCustomAddon(H2.PCFAddon).bOptions1;
      if (PTHeaderCustomAddon(H1.PCFAddon).bOptions1 and 3) = 1 then k := 1 else k := 5;
      while (i <= k) and Result do
      begin
        PF1 := @PTHeaderCustomAddon(H1.PCFAddon).Formulas[i];
        PF2 := @PTHeaderCustomAddon(H2.PCFAddon).Formulas[i];
        if ((PF1.iItCount = 0) <> (PF2.iItCount = 0)) or
           ((PF1.iItCount > 0) and (PF1.iItCount <> PF2.iItCount)) then
          Result := False
        else
        begin
          for j := 0 to Min(16, PF1.iOptionCount) - 1 do
            if not SameValue(PF1.dOptionValue[j], PF2.dOptionValue[j]) then
              Result := False;
        end;
        Inc(I);
      end;
      if H1.bCutOption > 0 then
        Result := Result and CompareMem(@H1.dCutX, @H2.dCutX, 24);
    end;
end;   

function InterpolateColor(C1, C2: Cardinal; W1, W2: Double): Cardinal;
begin
    Result := Round((C1 and $FF) * W1 + (C2 and $FF) * W2) or                      //range check
              (Round((C1 and $FF00) * W1 + (C2 and $FF00) * W2) and $FF00) or
              (Round((C1 and $FF0000) * W1 + (C2 and $FF0000) * W2) and $FF0000);
end;

function InterpolateColorToSVec(C1, C2: Cardinal; w: Single): TSVec;
begin
    Result[0] := Round((C1 and $FF) * (1 - w) + (C2 and $FF) * w);
    Result[1] := Round(((C1 and $FF00) * (1 - w) + (C2 and $FF00) * w) * d1d256);
    Result[2] := Round(((C1 and $FF0000) * (1 - w) + (C2 and $FF0000) * w) * d1d65535);
    Result[3] := 0;
end;

function InterpolateRGBColor(rgb1, rgb2: TRGB; W1, W2: Double): Cardinal;
begin
    Result := Round(rgb1[0] * W1 + rgb2[0] * W2) or
              (Round(rgb1[1] * W1 + rgb2[1] * W2) shl 8) or
              (Round(rgb1[2] * W1 + rgb2[2] * W2) shl 16);
end;

function InterpolateColorB(C1, C2, C3: Cardinal; W1, W2, W3: Double): Cardinal;
begin
    Result := Round((C1 and $FF) * W1 + (C2 and $FF) * W2 + (C3 and $FF) * W3) or
     (Round((C1 and $FF00) * W1 + (C2 and $FF00) * W2 + (C3 and $FF00) * W3) and $FF00) or
     (Round((C1 and $FF0000) * W1 + (C2 and $FF0000) * W2 + (C3 and $FF0000) * W3) and $FF0000);
end;

function Interpolate3Scols(sv1, sv2, sv3: TPSVec; W1, W2, W3: Double): TSVec;
begin
    Result[0] := sv1[0] * W1 + sv2[0] * W2 + sv3[0] * W3;
    Result[1] := sv1[1] * W1 + sv2[1] * W2 + sv3[1] * W3;
    Result[2] := sv1[2] * W1 + sv2[2] * W2 + sv3[2] * W3;
    Result[3] := 0;
end;

function Interpolate2Scols(sv1, sv2: TPSVec; W1, W2: Double): TSVec;
begin
    Result[0] := sv1[0] * W1 + sv2[0] * W2;
    Result[1] := sv1[1] * W1 + sv2[1] * W2;
    Result[2] := sv1[2] * W1 + sv2[2] * W2;
    Result[3] := 0;
end;

{function IpolCubicSpline2(s1, s2, s3, s4, c1, c2, c3, t: Single): Single;
var A, B, t2: Single;
begin
    A := s2 + (s3 - s1) * c2 / (3 * (c1 + c2));
    B := s3 - (s4 - s2) * c2 / (3 * (c2 + c3));
//    A := (A +  (s2 + ((s2 - s1) * c2 / c1 + s3 - s2) / 6)) * 0.5;
//    B := (B +  (s3 - (s3 - s2 + (s4 - s3) * c2 / c3) / 6)) * 0.5;
    t2 := 1 - t;
    Result := s2 * t2*t2*t2 + A * 3*t*t2*t2 + B * 3*t*t*t2 + s3 * t*t*t;
end;

function IpolBezier3(s1, s2, s3, s4, c1, c2, c3, t: Single): Single;
var A, B, t1, t2: Single;
begin
    if t > 0.5 then
    begin
      t1 := t - 0.5;
      t2 := 1 - t1;
      A := (s2 + s3) * 0.5;
      B := (s3 + s4) * 0.5;
      Result := A * t2*t2 + s3 * 2*t1*t2 + B * t1*t1;
    end
    else
    begin
      t1 := t + 0.5;
      t2 := 1 - t1;
      A := (s1 + s2) * 0.5;
      B := (s2 + s3) * 0.5;
      Result := A * t2*t2 + s2 * 2*t1*t2 + B * t1*t1;
    end;
end;}
{procedure Interpolate4framesCubic(H1, H2, H3, H4: TPMandHeader10; L1, L2, L3, L4: TPLightVals; t: Double);
var i, j, IHS, HS1, HS2, HS3, HS4: Integer;
    ps0, ps1, ps2, ps3, ps4: TPSingleArray;
    w1, w2, w3, w4, D1, D2, D3, D4, DX1, DX2, DY1, DY2: Double;
    Q1, Q2, Q3, Q4: TQuaternion;
    sv1, sv2, sv3, sv4: TSVec;
    MS: TSMatrix3;
begin
 {   t1 := t;                     //cubic splines without overshoot!
    t2 := 1 - t1;
    w1 := (s2 - s1) / c1;         //calc spline1 for values
    w2 := (s3 - s2) / c2;
    if w1 < 0 then i := 1 else i := 0;
    if w2 < 0 then i := i + 2;
    case i of
      0:  sa := s2 + Min(w1, w2) * c2 / 3;
      1:  sa := s2;
      2:  sa := s2;
      3:  sa := s2 + Max(w1, w2) * c2 / 3;
    end;
    i  := i shr 1;
    w1 := w2;                     //calc spline2 for values
    w2 := (s4 - s3) / c3;
    if w2 < 0 then i := i + 2;
    case i of
      0:  sb := s3 - Min(w1, w2) * c2 / 3;
      1:  sb := s3;
      2:  sb := s3;
      3:  sb := s3 - Max(w1, w2) * c2 / 3;
    end;
    w1 := s2 * t2 + sa * t;
    w2 := sa * t2 + sb * t;
    w3 := sb * t2 + s3 * t;
    w1 := w1 * t2 + w2 * t;
    w2 := w2 * t2 + w3 * t;
    Result := w1 * t2 + w2 * t1; }

 {   D2 := 1 - t;
    DX1 := L2.iKFcount / Max(1, (L1.iKFcount + L2.iKFcount));
    DX2 := L2.iKFcount / Max(1, (L2.iKFcount + L3.iKFcount));

    w1 := -DX1 * t * D2 * D2;
    w2 := D2 * (D2 * D2  +  DX2 * t * t  +  3 * t * D2);
//    w3 := t * (DX1 * D2 * D2  +  3 * t * D2  +  t * t);
    w4 := -DX2 * t * t * D2;
 //   D1 := w1 + w2 + w3 + w4;
    w3 := 1 - w1 - w2 - w4;

    if (H1.bCalcDOFtype and 1) = 0 then H1.sDOFaperture := 0; //  sDOFclipR, sDOFaperture
    if (H2.bCalcDOFtype and 1) = 0 then H2.sDOFaperture := 0;
    if (H3.bCalcDOFtype and 1) = 0 then H3.sDOFaperture := 0;
    if (H4.bCalcDOFtype and 1) = 0 then H4.sDOFaperture := 0;

    IHS := Integer(@InterpolHeader.MandId);
    HS1 := Integer(H1);
    HS2 := Integer(H2);
    HS3 := Integer(H3);
    HS4 := Integer(H4);
    for i := 0 to High(IntParsToInterpolate) do
      PInteger(IHS + IntParsToInterpolate[i])^ :=
        Round(PInteger(HS1 + IntParsToInterpolate[i])^ * w1 +
              PInteger(HS2 + IntParsToInterpolate[i])^ * w2 +
              PInteger(HS3 + IntParsToInterpolate[i])^ * w3 +
              PInteger(HS4 + IntParsToInterpolate[i])^ * w4) ;
    for i := 0 to High(DoubleParsToInterpolate) do
      PDouble(IHS + DoubleParsToInterpolate[i])^ :=
              PDouble(HS1 + DoubleParsToInterpolate[i])^ * w1 +
              PDouble(HS2 + DoubleParsToInterpolate[i])^ * w2 +
              PDouble(HS3 + DoubleParsToInterpolate[i])^ * w3 +
              PDouble(HS4 + DoubleParsToInterpolate[i])^ * w4;
    for i := 0 to High(SingleParsToInterpolate) do
      PSingle(IHS + SingleParsToInterpolate[i])^ :=
              PSingle(HS1 + SingleParsToInterpolate[i])^ * w1 +
              PSingle(HS2 + SingleParsToInterpolate[i])^ * w2 +
              PSingle(HS3 + SingleParsToInterpolate[i])^ * w3 +
              PSingle(HS4 + SingleParsToInterpolate[i])^ * w4;
    for i := 0 to High(DoubleToInterpolateLog) do
    begin
      D1 := Max(1e-10, PDouble(HS1 + DoubleToInterpolateLog[i])^);
      D2 := Max(1e-10, PDouble(HS2 + DoubleToInterpolateLog[i])^);
      D3 := Max(1e-10, PDouble(HS3 + DoubleToInterpolateLog[i])^);
      D4 := Max(1e-10, PDouble(HS4 + DoubleToInterpolateLog[i])^);
      PDouble(IHS + DoubleToInterpolateLog[i])^ :=
        Power(10, Log10(D1) * w1 + Log10(D2) * w2 + Log10(D3) * w3 + Log10(D4) * w4);
    end;
    for i := 0 to High(DoubleAnglesToInterpolate) do
    begin
      D1 := PDouble(HS1 + DoubleAnglesToInterpolate[i])^;
      D2 := PDouble(HS2 + DoubleAnglesToInterpolate[i])^;
      D3 := PDouble(HS3 + DoubleAnglesToInterpolate[i])^;
      D4 := PDouble(HS4 + DoubleAnglesToInterpolate[i])^;
      if Abs(D1) > 1000 then D1 := 0;
      if Abs(D2) > 1000 then D2 := 0;
      if Abs(D3) > 1000 then D3 := 0;
      if Abs(D4) > 1000 then D4 := 0;
      while Abs(D2 - D3) - 1e-8 > Pi do
      begin
        if D3 < D2 then D3 := D3 + piM2 else D3 := D3 - piM2;
      end;
      while Abs(D1 - D2) - 1e-8 > Pi do
      begin
        if D1 < D2 then D1 := D1 + piM2 else D1 := D1 - piM2;
      end;
      while Abs(D4 - D3) - 1e-8 > Pi do
      begin
        if D4 < D3 then D4 := D4 + piM2 else D4 := D4 - piM2;
      end;
      PDouble(IHS + DoubleAnglesToInterpolate[i])^ := D1 * W1 + D2 * W2 + D3 * W3 + D4 * W4;
    end;

    if InterpolHeader.dZoom < 1e-4 then InterpolHeader.dZoom := 1e-4;

      // with respect for zoom -> sum(Pmid_i * zoom_i * w_i) / zoom_interpolated  -> additional tpos for positions + zoom?!

{    D1 := DistanceOf2Vecs(@H1.dXmid, @H2.dXmid) / (H2.dZoom * L1.iKFcount); //uncorrected velocity before KF2
    D2 := DistanceOf2Vecs(@H2.dXmid, @H3.dXmid) / (H2.dZoom * L2.iKFcount); //..velocity behind KF2
    D3 := DistanceOf2Vecs(@H2.dXmid, @H3.dXmid) / (H3.dZoom * L2.iKFcount); //..velocity before KF3
    D4 := DistanceOf2Vecs(@H3.dXmid, @H4.dXmid) / (H3.dZoom * L3.iKFcount); //..velocity behind KF3
    D1 := D1 * D2 * 0.5 / Max(1e-10, D1 + D2); //ipol D1,D2
    D4 := D3 * D4 * 0.5 / Max(1e-10, D3 + D4);
    D1 := 0.5 * D1 / Max(1e-10, D2);            //corr. factor t0
    D4 := 0.5 * D4 / Max(1e-10, D3);            //corr. factor t1
    D2 := 0.5;                  //midponts of splines
    D3 := 0.5;
    if D1 > 1 then
    begin
      D2 := 0.5 / D1;
      D1 := 1;
    end;
    if D4 > 1 then
    begin
      D3 := 1 - 0.5 / D4;
      D4 := 0;
    end
    else D4 := 1 - D4;
                        //0,d2,d3,1 are the x points (t), 0,d1,d4,1 are the y points ... do cubic bezier ipol for tpos
    DX1 := t * D2;
    DX2 := (1 - t) * D3 + t;
    DY1 := t * D1;
    DY2 := (1 - t) * D4 + t;
    DX1 := (1 - t) * DX1 + t * DX2;  //no need for Xpos????
    DY1 := (1 - t) * DY1 + t * DY2;  //=tpos
    if DY1 < 0 then
      DY1 := 0 else
    if DY1 > 1 then
      DY1 := 1;  
    D4 := (1.0 / 6.0) * DY1 * DY1 * DY1;             //Spline degree 3
    D1 := (1.0 / 6.0) + 0.5 * DY1 * (DY1 - 1.0) - D4;
    D3 := DY1 + D1 - 2.0 * D4;
    D2 := 1.0 - D1 - D3 - D4;  

    InterpolHeader.dXmid := H1.dXmid * D1 + H2.dXmid * D2 +
                            H3.dXmid * D3 + H4.dXmid * D4;
    InterpolHeader.dYmid := H1.dYmid * D1 + H2.dYmid * D2 +
                            H3.dYmid * D3 + H4.dYmid * D4;
    InterpolHeader.dZmid := H1.dZmid * D1 + H2.dZmid * D2 +
                            H3.dZmid * D3 + H4.dZmid * D4;
    InterpolHeader.dZstart := H1.dZstart * D1 + H2.dZstart * D2 +
                              H3.dZstart * D3 + H4.dZstart * D4;
    InterpolHeader.dZend := H1.dZend * D1 + H2.dZend * D2 +
                            H3.dZend * D3 + H4.dZend * D4;   }


 {   D1 := Log10(Max(1e-4, H1.dZoom)) * w1;
    D2 := Log10(Max(1e-4, H2.dZoom)) * w2;
    D3 := Log10(Max(1e-4, H3.dZoom)) * w3;
    D4 := Log10(Max(1e-4, H4.dZoom)) * w4;
    DD := 1 / Power(10, InterpolHeader.dZoom);
    InterpolHeader.dXmid := (H1.dXmid * D1 + H2.dXmid * D2 +
                             H3.dXmid * D3 + H4.dXmid * D4) * DD;
    InterpolHeader.dYmid := (H1.dYmid * D1 + H2.dYmid * D2 +
                             H3.dYmid * D3 + H4.dYmid * D4) * DD;
    InterpolHeader.dZmid := (H1.dZmid * D1 + H2.dZmid * D2 +
                             H3.dZmid * D3 + H4.dZmid * D4) * DD;   }
      // with respect for Pmid and zoom:
 {   D1 := H1.dZoom * w1;
    D2 := H2.dZoom * w2;
    D3 := H3.dZoom * w3;
    D4 := H4.dZoom * w4;
    InterpolHeader.dZstart := InterpolHeader.dZmid + ((H1.dZstart - H1.dZmid) * D1 +
       (H2.dZstart - H2.dZmid) * D2 + (H3.dZstart - H3.dZmid) * D3 + (H4.dZstart - H4.dZmid) * D4) / InterpolHeader.dZoom;
    InterpolHeader.dZend := InterpolHeader.dZmid + ((H1.dZend - H1.dZmid) * D1 +
       (H2.dZend - H2.dZmid) * D2 + (H3.dZend - H3.dZmid) * D3 + (H4.dZend - H4.dZmid) * D4) / InterpolHeader.dZoom;
    if InterpolHeader.dZstart > InterpolHeader.dZmid then InterpolHeader.dZstart := InterpolHeader.dZmid;
    if InterpolHeader.dZend < InterpolHeader.dZmid then InterpolHeader.dZend := InterpolHeader.dZmid;   }

{    MatrixToQuat(NormaliseMatrixTo(1, @H1.hVGrads), Q1);
    MatrixToQuat(NormaliseMatrixTo(1, @H2.hVGrads), Q2);
    MatrixToQuat(NormaliseMatrixTo(1, @H3.hVGrads), Q3);
    MatrixToQuat(NormaliseMatrixTo(1, @H4.hVGrads), Q4);
    Q1 := QCubic(Q1, Q2, Q3, Q4, t);
    Q1 := InvertQuat(Q1);
    CreateMatrixFromQuat(InterpolHeader.hVGrads, Q1);

                  // Interpolate Light values

    InterpolLightVals.bBackBMP := L2.bBackBMP and L3.bBackBMP;

    ps0 := @InterpolLightVals.sGamma;
    ps1 := @L1.sGamma;
    ps2 := @L2.sGamma;
    ps3 := @L3.sGamma;
    ps4 := @L4.sGamma;
    for i := 0 to 11 do ps0[i] := ps1[i] * w1 + ps2[i] * w2 + ps3[i] * w3 + ps4[i] * w4;
    InterpolLightVals.sDiff := Max(0, L1.sDiff * w1 + L2.sDiff * w2 + L3.sDiff * w3 + L4.sDiff * w4);
    InterpolLightVals.sSpec := Max(0, L1.sSpec * w1 + L2.sSpec * w2 + L3.sSpec * w3 + L4.sSpec * w4);
    for i := 0 to 5 do
    begin
      if L1.iLightOption[i] = 1 then ClearSVec(L1.PLValigned.sLCols[i]);// := cSVec0;    //light off
      if L2.iLightOption[i] = 1 then ClearSVec(L2.PLValigned.sLCols[i]);// := cSVec0;
      if L3.iLightOption[i] = 1 then ClearSVec(L3.PLValigned.sLCols[i]);// := cSVec0;
      if L4.iLightOption[i] = 1 then ClearSVec(L4.PLValigned.sLCols[i]);// := cSVec0;
      InterpolLightVals.iLightOption[i] := L2.iLightOption[i] and L3.iLightOption[i];
      InterpolLightVals.sLightPowFunc[i] := L1.sLightPowFunc[i] * W1 + L2.sLightPowFunc[i] * W2 +
                                            L3.sLightPowFunc[i] * W3 + L4.sLightPowFunc[i] * W4;
      InterpolLightVals.sLmaxL[i] := L1.sLmaxL[i] * W1 + L2.sLmaxL[i] * W2 +
                                     L3.sLmaxL[i] * W3 + L4.sLmaxL[i] * W4;
    end;
    ps0 := TPSingleArray(InterpolLightVals.PLValigned);
    ps1 := TPSingleArray(L1.PLValigned);
    ps2 := TPSingleArray(L2.PLValigned);
    ps3 := TPSingleArray(L3.PLValigned);
    ps4 := TPSingleArray(L4.PLValigned);
    for i := 0 to 167 do ps0[i] := ps1[i] * w1 + ps2[i] * w2 + ps3[i] * w3 + ps4[i] * w4;
    for i := 0 to 5 do
    begin
      if ((L1.iLightPos[i] or L2.iLightPos[i] or L3.iLightPos[i] or L4.iLightPos[i]) and 1) = 0 then
      begin
        if (L1.iLightAbs[i] = 0) or (L2.iLightAbs[i] = 0) or (L3.iLightAbs[i] = 0) or (L4.iLightAbs[i] = 0) then
          InterpolLightVals.PLValigned.LN[i] := CubicIpol4SVecs(@L1.PLValigned.LN[i], @L2.PLValigned.LN[i],
                                                              @L3.PLValigned.LN[i], @L4.PLValigned.LN[i], t)
        else
        begin        //cubicSV not working right, if rel to object, rotate back first... (workaround)
          MS := NormaliseMatrixToS(1, @H1.hVGrads);
          sv1 := L1.PLValigned.LN[i];
          RotateSVectorS(@sv1, @MS);
          MS := NormaliseMatrixToS(1, @H2.hVGrads);
          sv2 := L2.PLValigned.LN[i];
          RotateSVectorS(@sv2, @MS);
          MS := NormaliseMatrixToS(1, @H3.hVGrads);
          sv3 := L3.PLValigned.LN[i];
          RotateSVectorS(@sv3, @MS);
          MS := NormaliseMatrixToS(1, @H4.hVGrads);
          sv4 := L4.PLValigned.LN[i];
          RotateSVectorS(@sv4, @MS);
          InterpolLightVals.PLValigned.LN[i] := CubicIpol4SVecs(@sv1, @sv2, @sv3, @sv4, t);
          MS := NormaliseMatrixToS(1, @InterpolHeader.hVGrads);
          RotateSVectorReverseS(@InterpolLightVals.PLValigned.LN[i], @MS);
        end;  
      end;
    end;
    for i := 0 to 3 do
    begin
      InterpolLightVals.IColPos[i] := Max(0, Min(32767, Round(L1.IColPos[i] * W1 + L2.IColPos[i] * W2 +
                                                              L3.IColPos[i] * W3 + L4.IColPos[i] * W4)));
      InterpolLightVals.sICDiv[i] := Max(0, Min(1, L1.sICDiv[i] * W1 + L2.sICDiv[i] * W2 +
                                                   L3.sICDiv[i] * W3 + L4.sICDiv[i] * W4));
    end;
    for i := 0 to 9 do
    begin
      InterpolLightVals.ColPos[i] := Max(0, Min(32767, Round(L1.ColPos[i] * W1 + L2.ColPos[i] * W2 +
                                            L3.ColPos[i] * W3 + L4.ColPos[i] * W4)));
      InterpolLightVals.sCDiv[i] := Max(0, Min(1, L1.sCDiv[i] * W1 + L2.sCDiv[i] * W2 +
                                                  L3.sCDiv[i] * W3 + L4.sCDiv[i] * W4));
    end;
    d1 := L1.sGamma * W1 * L1.iGammaH + L2.sGamma * W2 * L2.iGammaH +
          L3.sGamma * W3 * L3.iGammaH + L4.sGamma * W4 * L4.iGammaH;
    InterpolLightVals.sGamma := Min(1, Abs(d1));
    if Abs(d1) < 0.005 then InterpolLightVals.iGammaH := 0 else
    if d1 < 0 then InterpolLightVals.iGammaH := -1 else InterpolLightVals.iGammaH := 1;

    InterpolLightVals.sDynFogMul := L1.sDynFogMul * W1 + L2.sDynFogMul * W2 + L3.sDynFogMul * W3 + L4.sDynFogMul * W4;
    InterpolLightVals.sRoughnessFactor := L1.sRoughnessFactor * W1 + L2.sRoughnessFactor * W2 + L3.sRoughnessFactor * W3 + L4.sRoughnessFactor * W4;
    if InterpolLightVals.bBackBMP then
    begin
      SMatrixToQuat(NormaliseSMatrixTo(1, @L2.BGLightMap.PicRotMatrix), Q2);
      SMatrixToQuat(NormaliseSMatrixTo(1, @L3.BGLightMap.PicRotMatrix), Q3);
      if L1.bBackBMP then SMatrixToQuat(NormaliseSMatrixTo(1, @L1.BGLightMap.PicRotMatrix), Q1) else Q1 := Q2;
      if L4.bBackBMP then SMatrixToQuat(NormaliseSMatrixTo(1, @L4.BGLightMap.PicRotMatrix), Q4) else Q4 := Q3;
      Q1 := InvertQuat(QCubic(Q1, Q2, Q3, Q4, t));
      CreateSMatrixFromQuat(InterpolLightVals.BGLightMap.PicRotMatrix, Q1);
    end;


   // Lightval.LPos[i] = TSVec Single rel pos to header. midPos -> add midPos, interpol in double, sub interpol midpos

    //HAddon

    if (InterpolHAddon.bOptions1 and 3) = 1 then j := 1 else j := 5;
    for i := 0 to j do if
      bInterpolateFormula(PTHeaderCustomAddon(H1.PCFAddon), PTHeaderCustomAddon(H2.PCFAddon), i) and
      bInterpolateFormula(PTHeaderCustomAddon(H1.PCFAddon), PTHeaderCustomAddon(H3.PCFAddon), i) and
      bInterpolateFormula(PTHeaderCustomAddon(H1.PCFAddon), PTHeaderCustomAddon(H4.PCFAddon), i) then
    begin
      Ini1CFfromHAddon(H1.PCFAddon, H1.PHCustomF[i], i, False);
      for IHS := 0 to Min(16, PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].iOptionCount) - 1 do
      if PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].byOptionType[IHS] in [3..6] then   //CF.iOptionTYpes(3..6) = Angles ->  ipol 360°
      begin
        D1 := PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].dOptionValue[IHS];
        D2 := PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].dOptionValue[IHS];
        D3 := PTHeaderCustomAddon(H3.PCFAddon).Formulas[i].dOptionValue[IHS];
        D4 := PTHeaderCustomAddon(H4.PCFAddon).Formulas[i].dOptionValue[IHS];
        if Abs(D1) > 10000 then D1 := 0;
        if Abs(D2) > 10000 then D2 := 0;
        if Abs(D3) > 10000 then D3 := 0; 
        if Abs(D4) > 10000 then D4 := 0;
        while Abs(D1 - D2) > 180.1 do
        begin
          if D2 < D1 then D2 := D2 + 360 else D2 := D2 - 360;
        end;
        while Abs(D2 - D3) > 180.1 do
        begin
          if D3 < D2 then D3 := D3 + 360 else D3 := D3 - 360;
        end;
        while Abs(D3 - D4) > 180.1 do
        begin
          if D4 < D3 then D4 := D4 + 360 else D4 := D4 - 360;
        end;
        InterpolHAddon.Formulas[i].dOptionValue[IHS] := D1 * W1 + D2 * W2 + D3 * W3 + D4 * W4;
      end
      else
      InterpolHAddon.Formulas[i].dOptionValue[IHS] :=
        PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].dOptionValue[IHS] * W1 +
        PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].dOptionValue[IHS] * W2 +
        PTHeaderCustomAddon(H3.PCFAddon).Formulas[i].dOptionValue[IHS] * W3 +
        PTHeaderCustomAddon(H4.PCFAddon).Formulas[i].dOptionValue[IHS] * W4;
      if j = 1 then
      begin
        PSingle(@InterpolHAddon.Formulas[i].iItCount)^ :=
          PSingle(@PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].iItCount)^ * W1 +
          PSingle(@PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].iItCount)^ * W2 +
          PSingle(@PTHeaderCustomAddon(H3.PCFAddon).Formulas[i].iItCount)^ * W3 +
          PSingle(@PTHeaderCustomAddon(H4.PCFAddon).Formulas[i].iItCount)^ * W4;
      end else begin
        InterpolHAddon.Formulas[i].iItCount := Round(
          PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].iItCount * W1 +
          PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].iItCount * W2 +
          PTHeaderCustomAddon(H3.PCFAddon).Formulas[i].iItCount * W3 +
          PTHeaderCustomAddon(H4.PCFAddon).Formulas[i].iItCount * W4);
      end;
    end;
end;  }

procedure Slerp3SMatrices(SM1, SM2, SM3, FinSM: TPSmatrix3; t: Double);
var Q1, Q2, Q3: TQuaternion;
begin
    SMatrixToQuat(NormaliseSMatrixTo(1, SM1), Q1);
    SMatrixToQuat(NormaliseSMatrixTo(1, SM2), Q2);
    SMatrixToQuat(NormaliseSMatrixTo(1, SM3), Q3);
    Q1 := InvertQuat(SlerpQuat(SlerpQuat(SlerpQuat(Q1, Q2, 0.5), Q2, t),
                     SlerpQuat(Q2, SlerpQuat(Q2, Q3, 0.5), t), t));
    CreateSMatrixFromQuat(FinSM^, Q1);
end;

function GetInvLightSort(i: Integer; Li: TPLightVals): Integer;
var j: Integer;
begin
    Result := 0;
    with Li^ do for j := 0 to 5 do if SortTab[j] = i then
    begin
      Result := j;
      Break;
    end;
end;

procedure Interpolate3framesBezier(Hi1, Hi2, Hi3, Hi4: TPMandHeader11; Li1, Li2, Li3, Li4: TPLightVals; t: Double);
var i, j, IHS, HS1, HS2, HS3, ii, i1, i2, i3: Integer;
    H1, H2, H3, MH: TPMandHeader11;
    L1, L2, L3: TPLightVals;
    ps0, ps1, ps2, ps3: TPSingleArray;
    D1, D2, D3, Z1, Z2, Z3, w1, w2, w3, tslerp, vpoff: Double;
    Q1, Q2, Q3, QA, QB: TQuaternion;
    M: TMatrix3;
    SV1,SV2,SV3: TSVec;
    V1: TVec3D;
//    v3: TVec3D;
begin
    if t >= 0.5 then
    begin
      H1 := Hi2;
      H2 := Hi3;
      H3 := Hi4;
      L1 := Li2;
      CopyRotMatices(@IPOLM1, @IPOLM0);
      L2 := Li3;
      CopyRotMatices(@IPOLM2, @IPOLM1);
      L3 := Li4;
      CopyRotMatices(@IPOLM3, @IPOLM2);
      w1 := L1.iKFcount * 0.5;
      w2 := L1.iKFcount;
      w3 := w2 + L2.iKFcount * 0.5;
    end else begin
      H1 := Hi1;
      H2 := Hi2;
      H3 := Hi3;
      L1 := Li1;
      L2 := Li2;
      L3 := Li3;
      w1 := L1.iKFcount * -0.5;
      w2 := 0;
      w3 := L2.iKFcount * 0.5;
    end;
    D1 := w1 - 2 * w2 + w3;
    D3 := Li2.iKFcount * t - w1;
    if Abs(D1) < 0.0001 then tslerp := D3 / (w3 - w1) else
    begin
      D2 := w1 - w2;
      D3 := Sqrt(Abs(Sqr(D2) + D1 * D3));
      tslerp := (D2 + D3) / D1;
      if (tslerp < 0) or (tslerp > 1) then tslerp := (D2 - D3) / D1;
    end;
    w1 := 0.5 * Sqr(1 - tslerp);
    w2 := 0.5 * Sqr(1 - tslerp) + 2 * tslerp * (1 - tslerp) + 0.5 * tslerp * tslerp;
    w3 := 1 - w1 - w2;

//    result := w1 * P1 + w2 * P2 + w3 * P3;
//           =
 // = lin combis of...
 //      A := Slerp(P1, P2, 0.5);
 //      B := Slerp(P2, P3, 0.5);
 //    Result := Slerp(Slerp(A, P2, tslerp), Slerp(P2, B, tlerp));

//new: step midpos back to camera! ... direct header H1..H3 manipulation is not allowed!
 {   for i := 0 to 2 do
    begin
      Case i of
        0: MH := H1;
        1: MH := H2;
        2: MH := H3;
      end;
      with MH^ do
      begin
        d1 := LengthOfVec(TPVec3D(@hVGrads[2])^);
        vpoff := d1 * Height * 0.5 / MaxCD(0.01, Sin(dFOVy * Pid180 * 0.5)); wrong //offset viewplane to campos. must be added after rotation!
        mAddVecWeight(@dXmid, @hVGrads[2], (dZstart - dZmid - vpoff) / d1);   //step back so that midpoint becomes campos
        dZend := dZend - dZstart + dZmid + vpoff;
        dZstart := dZmid;
      end;
    end; }

    InterpolHeader.bDFogIt := Round(H1.bDFogIt * W1 + H2.bDFogIt * W2 + H3.bDFogIt * W3);

    if (H1.bCalcDOFtype and 1) = 0 then H1.sDOFaperture := 0;    //sDOFZsharp, sDOFclipR, sDOFaperture
    if (H2.bCalcDOFtype and 1) = 0 then H2.sDOFaperture := 0;
    if (H3.bCalcDOFtype and 1) = 0 then H3.sDOFaperture := 0;

    IHS := Integer(@InterpolHeader.MandId);
    HS1 := Integer(@H1.MandId);
    HS2 := Integer(@H2.MandId);
    HS3 := Integer(@H3.MandId);
    for i := 0 to High(IntParsToInterpolate) do
      PInteger(IHS + IntParsToInterpolate[i])^ :=
        Round(PInteger(HS1 + IntParsToInterpolate[i])^ * W1 +
              PInteger(HS2 + IntParsToInterpolate[i])^ * W2 +
              PInteger(HS3 + IntParsToInterpolate[i])^ * W3);
    for i := 0 to High(DoubleParsToInterpolate) do
      PDouble(IHS + DoubleParsToInterpolate[i])^ :=
              PDouble(HS1 + DoubleParsToInterpolate[i])^ * W1 +
              PDouble(HS2 + DoubleParsToInterpolate[i])^ * W2 +
              PDouble(HS3 + DoubleParsToInterpolate[i])^ * W3;
    for i := 0 to High(SingleParsToInterpolate) do
      PSingle(IHS + SingleParsToInterpolate[i])^ :=
              PSingle(HS1 + SingleParsToInterpolate[i])^ * W1 +
              PSingle(HS2 + SingleParsToInterpolate[i])^ * W2 +
              PSingle(HS3 + SingleParsToInterpolate[i])^ * W3;
    for i := 0 to High(DoubleToInterpolateLog) do
    begin
      D1 := Max(1e-10, PDouble(HS1 + DoubleToInterpolateLog[i])^);
      D2 := Max(1e-10, PDouble(HS2 + DoubleToInterpolateLog[i])^);
      D3 := Max(1e-10, PDouble(HS3 + DoubleToInterpolateLog[i])^);
      PDouble(IHS + DoubleToInterpolateLog[i])^ :=
        Power(10, Log10(D1) * W1 + Log10(D2) * W2 + Log10(D3) * W3);
    end;
    for i := 0 to High(DoubleAnglesToInterpolate) do
    begin
      D1 := PDouble(HS1 + DoubleAnglesToInterpolate[i])^;
      D2 := PDouble(HS2 + DoubleAnglesToInterpolate[i])^;
      D3 := PDouble(HS3 + DoubleAnglesToInterpolate[i])^;
      if Abs(D1) > 1000 then D1 := 0;
      if Abs(D2) > 1000 then D2 := 0;
      if Abs(D3) > 1000 then D3 := 0;
      while Abs(D2 - D1) - 1e-8 > Pi do
      begin
        if D1 < D2 then D1 := D1 + piM2 else D1 := D1 - piM2;
      end;
      while Abs(D3 - D2) - 1e-8 > Pi do
      begin
        if D3 < D2 then D3 := D3 + piM2 else D3 := D3 - piM2;
      end;
      PDouble(IHS + DoubleAnglesToInterpolate[i])^ := D1 * W1 + D2 * W2 + D3 * W3;
    end;

    MatrixToQuat(NormaliseMatrixTo(1, @H1.hVGrads), Q1);
    MatrixToQuat(NormaliseMatrixTo(1, @H2.hVGrads), Q2);
    MatrixToQuat(NormaliseMatrixTo(1, @H3.hVGrads), Q3);
    Q1 := InvertQuat(SlerpQuat(SlerpQuat(SlerpQuat(Q1, Q2, 0.5), Q2, tslerp),
                      SlerpQuat(Q2, SlerpQuat(Q2, Q3, 0.5), tslerp), tslerp));
    CreateMatrixFromQuat(InterpolHeader.hVGrads, Q1);

    InterpolHeader.MCSoftShadowRadius := SingleToShortFloat(
      ShortFloatToSingle(@H1.MCSoftShadowRadius) * W1 +
      ShortFloatToSingle(@H2.MCSoftShadowRadius) * W2 +
      ShortFloatToSingle(@H3.MCSoftShadowRadius) * W3);
  {  with InterpolHeader do
    begin
      d1 := 2.1345 / (dZoom * Width);
      hVGrads := NormaliseMatrixTo(d1, @hVGrads);
      vpoff := Height * 0.5 / MaxCD(0.01, Sin(dFOVy * Pid180 * 0.5));   wrong
      mAddVecWeight(@dXmid, @hVGrads[2], vpoff);
      dZend := dZend - vpoff * d1;
      dZstart := dZmid;
    end;  }


    //try to interpolate positions with respect to zoom
{        r := w0;
         w0 := w1 * w1 * xx;
         w1 := ((w1 * w1 + r * r) * (1 - xx) + 2 * r * w1);
         w2 := r * r * xx;
         r := Max(1.1, yw[x2 - 1]) * w0;
         u := Max(1.1, yw[x2]) * w1;
         v := Max(1.1, yw[x2 + 1]) * w2;
         w := r + u + v;
         sum := (r * yw[x2 - 1] +
                 u * yw[x2]     +
                 v * yw[x2 + 1]) / w;
    D1 := Sqrt(W1/XX) * Max(1e-10, H2.dZoom) / Max(1e-10, H1.dZoom) +
          Sqrt(W3/XX) * Max(1e-10, H3.dZoom) / Max(1e-10, H2.dZoom);
    if D1 > 1 then
    begin
      D1 := Power(W1, 1 + Log10(D1));
      D3 := Sqr(1 - Sqrt(D1/XX))*XX;
    end else begin
      D3 := Power(W3, 1 + Log10(1/D1));
      D1 := Sqr(1 - Sqrt(D3/XX))*XX;
    end;
    D2 := 1 - D1 - D3;
    for i := 0 to 4 do //  20, 28, 36, 44, 52,
      PDouble(IHS + i * 8 + 20)^ :=
              PDouble(HS1 + i * 8 + 20)^ * D1 +
              PDouble(HS2 + i * 8 + 20)^ * D2 +
              PDouble(HS3 + i * 8 + 20)^ * D3;  }

                             // Interpolate Light values
    InterpolHeader.bStereoMode := H2.bStereoMode;

    InterpolLightVals.bBackBMP := L1.bBackBMP and L2.bBackBMP and L3.bBackBMP;

    ps0 := @InterpolLightVals.sGamma;
    ps1 := @L1.sGamma;
    ps2 := @L2.sGamma;
    ps3 := @L3.sGamma;
    for i := 0 to 11 do ps0[i] := ps1[i] * w1 + ps2[i] * w2 + ps3[i] * w3;
    InterpolLightVals.sDiff := L1.sDiff * w1 + L2.sDiff * w2 + L3.sDiff * w3;
    InterpolLightVals.sSpec := L1.sSpec * w1 + L2.sSpec * w2 + L3.sSpec * w3;
    InterpolLightVals.sIndLightReflect := L1.sIndLightReflect * w1 + L2.sIndLightReflect * w2 + L3.sIndLightReflect * w3;
    for i := 0 to 5 do
    begin     //use sorttab in case lightpos changes!
     { i1 := GetInvLightSort(i, L1);
      i2 := GetInvLightSort(i, L2);
      i3 := GetInvLightSort(i, L3);
      j := GetInvLightSort(i, @InterpolLightVals);  }
      i1 := L1.SortTab[i];
      i2 := L2.SortTab[i];
      i3 := L3.SortTab[i];
      j := InterpolLightVals.SortTab[i];
      if L1.iLightOption[i1] = 1 then ClearSVec(L1.PLValigned.sLCols[i1]);   //light off
      if L2.iLightOption[i2] = 1 then ClearSVec(L2.PLValigned.sLCols[i2]);
      if L3.iLightOption[i3] = 1 then ClearSVec(L3.PLValigned.sLCols[i3]);
      InterpolLightVals.iLightOption[j] := L1.iLightOption[i1] and L2.iLightOption[i2] and L3.iLightOption[i3];
      InterpolLightVals.iLightPowFunc[j] := Round(L1.iLightPowFunc[i1] * W1 + L2.iLightPowFunc[i2] * W2 + L3.iLightPowFunc[i3] * W3);
      InterpolLightVals.sLmaxL[j] := L1.sLmaxL[i1] * W1 + L2.sLmaxL[i2] * W2 + L3.sLmaxL[i3] * W3;
      if InterpolLightVals.iLightOption[j] = 2 then
      begin
        Slerp3SMatrices(@IPOLM0.LightPicRotM[i1], @IPOLM1.LightPicRotM[i2],
         @IPOLM2.LightPicRotM[i3], @InterpolLightVals.LLightMaps[j].PicRotMatrix, tslerp);
       { SMatrixToQuat(NormaliseSMatrixTo(1, @InterPolLightPicRotMs0[i]), Q1);
        SMatrixToQuat(NormaliseSMatrixTo(1, @InterPolLightPicRotMs1[i]), Q2);
        SMatrixToQuat(NormaliseSMatrixTo(1, @InterPolLightPicRotMs2[i]), Q3);
        Q1 := InvertQuat(SlerpQuat(SlerpQuat(SlerpQuat(Q1, Q2, 0.5), Q2, tslerp),
                          SlerpQuat(Q2, SlerpQuat(Q2, Q3, 0.5), tslerp), tslerp));
        CreateSMatrixFromQuat(InterpolLightVals.LLightMaps[i].PicRotMatrix, Q1); }
      end;
    end;
    ps0 := TPSingleArray(InterpolLightVals.PLValigned);
    ps1 := TPSingleArray(L1.PLValigned);
    ps2 := TPSingleArray(L2.PLValigned);
    ps3 := TPSingleArray(L3.PLValigned);
    for i := 0 to 167 do ps0[i] := ps1[i] * w1 + ps2[i] * w2 + ps3[i] * w3;

    InterpolLightVals.lvMidPos := AddVecF(AddVecF(ScaleVector(L1.lvMidPos, w1),
      ScaleVector(L2.lvMidPos, w2)), ScaleVector(L3.lvMidPos, w3));

 //   StereoChange(@InterpolHeader, InterpolHeader.bStereoMode, InterpolLightVals.lvMidPos, @InterpolHeader.hVGrads);
    for i := 0 to 5 do
    begin
      i1 := L1.SortTab[i];
      i2 := L2.SortTab[i];
      i3 := L3.SortTab[i];
      j := InterpolLightVals.SortTab[i];
      if ((L1.iLightPos[i1] or L2.iLightPos[i2] or L3.iLightPos[i3]) and 1) = 0 then
      begin
        if InterpolLightVals.iLightAbs[j] <> 0 then  //rotate rel vectors back before interpolation
        begin
          M := NormaliseMatrixTo(1, @H1.hVGrads);
          SV1 := L1.PLValigned.LN[i1];
          RotateSVector(@SV1, @M);
          M := NormaliseMatrixTo(1, @H2.hVGrads);
          SV2 := L2.PLValigned.LN[i2];
          RotateSVector(@SV2, @M);
          M := NormaliseMatrixTo(1, @H3.hVGrads);
          SV3 := L3.PLValigned.LN[i3];
          RotateSVector(@SV3, @M);
          InterpolLightVals.PLValigned.LN[j] := BezierIpol3SVecs(@SV1, @SV2, @SV3, tslerp);
          RotateSVectorReverse(@InterpolLightVals.PLValigned.LN[j], @InterpolHeader.hVGrads);
          NormaliseSVectorVar(InterpolLightVals.PLValigned.LN[j]);
        end else
        InterpolLightVals.PLValigned.LN[j] := BezierIpol3SVecs(@L1.PLValigned.LN[i1],
          @L2.PLValigned.LN[i2], @L3.PLValigned.LN[i3], tslerp);
      end
      else if (L1.iLightPos[i1] and L2.iLightPos[i2] and L3.iLightPos[i3] and 1) = 1 then
      begin
        InterpolLightVals.PLValigned.LN[j] := DVecToSVec(SubtractVectors(AddVecF(
          AddVecF(ScaleVector(AddSVec2Vec3(@L1.PLValigned.LN[i1], @L1.lvMidPos), w1),
          ScaleVector(AddSVec2Vec3(@L2.PLValigned.LN[i2], @L2.lvMidPos), w2)),
          ScaleVector(AddSVec2Vec3(@L3.PLValigned.LN[i3], @L3.lvMidPos), w3)), @InterpolLightVals.lvMidPos));
     {   if (InterpolHeader.bVolLightNr and 7) > 0 then
        begin
          V1 := TPVec3D(@InterpolLightVals.lvMidPos)^;
          AddSVec2Vec3d(InterpolLightVals.PLValigned.LN[j], @V1);
          SetLightPosFromDVec(InterpolHeader.Light.Lights[i], V1);
        end; }
      end;

//    LN:     array[0..5] of TSVec;    //64      light vectors for global light, or  light positions for pos light
 //   sLCols: array[0..5] of TSVec;    //160
      for ii := 0 to 2 do
        InterpolLightVals.PLValigned.sLCols[j][ii] := L1.PLValigned.sLCols[i1][ii] * w1 +
          L2.PLValigned.sLCols[i2][ii] * w2 + L3.PLValigned.sLCols[i3][ii] * w3;
    end;
    for i := 0 to 3 do
    begin
      InterpolLightVals.IColPos[i] := Max(0, Min(32767, Round(L1.IColPos[i] * W1 + L2.IColPos[i] * W2 + L3.IColPos[i] * W3)));
      InterpolLightVals.sICDiv[i] := Max(0, Min(1, L1.sICDiv[i] * W1 + L2.sICDiv[i] * W2 + L3.sICDiv[i] * W3));
    end;
    for i := 0 to 9 do
    begin
      InterpolLightVals.ColPos[i] := Max(0, Min(32767, Round(L1.ColPos[i] * W1 + L2.ColPos[i] * W2 + L3.ColPos[i] * W3)));
      InterpolLightVals.sCDiv[i] := Max(0, Min(1, L1.sCDiv[i] * W1 + L2.sCDiv[i] * W2 + L3.sCDiv[i] * W3));
    end;
    d1 := L1.sGamma * W1 * L1.iGammaH + L2.sGamma * W2 * L2.iGammaH + L3.sGamma * W3 * L3.iGammaH;
    InterpolLightVals.sGamma := Min(1, Abs(d1));
    if Abs(d1) < 0.005 then InterpolLightVals.iGammaH := 0 else
    if d1 < 0 then InterpolLightVals.iGammaH := -1 else InterpolLightVals.iGammaH := 1;

    InterpolLightVals.sDynFogMul := L1.sDynFogMul * W1 + L2.sDynFogMul * W2 + L3.sDynFogMul * W3;
    InterpolLightVals.sRoughnessFactor := L1.sRoughnessFactor * W1 + L2.sRoughnessFactor * W2 + L3.sRoughnessFactor * W3;

    if InterpolLightVals.bBackBMP then
      Slerp3SMatrices(@IPOLM0.BGPicRotM, @IPOLM1.BGPicRotM, @IPOLM2.BGPicRotM,
                      @InterpolLightVals.BGLightMap.PicRotMatrix, tslerp);
    d1 := L1.DCLMapOffX;
    d2 := L2.DCLMapOffX;
    d3 := L3.DCLMapOffX;
    if Abs(d1 - d2) > 0.5 then
    begin
      if d1 < d2 then d1 := d1 + 1 else d1 := d1 - 1;
    end;
    if Abs(d2 - d3) > 0.5 then
    begin
      if d3 < d2 then d3 := d3 + 1 else d3 := d3 - 1;
    end;
    InterpolLightVals.DCLMapOffX := D1 * W1 + D2 * W2 + D3 * W3;
    d1 := L1.DCLMapOffY;
    d2 := L2.DCLMapOffY;
    d3 := L3.DCLMapOffY;
    if Abs(d1 - d2) > 0.5 then
    begin
      if d1 < d2 then d1 := d1 + 1 else d1 := d1 - 1;
    end;
    if Abs(d2 - d3) > 0.5 then
    begin
      if d3 < d2 then d3 := d3 + 1 else d3 := d3 - 1;
    end;
    InterpolLightVals.DCLMapOffY := D1 * W1 + D2 * W2 + D3 * W3;

    Slerp3SMatrices(@IPOLM0.DiffColRotM, @IPOLM1.DiffColRotM, @IPOLM2.DiffColRotM,
                    @InterpolLightVals.DiffColLightMap.PicRotMatrix, tslerp);
    if L1.DCLMapRotCos = 0 then D1 := Pi else D1 := ArcTan2(L1.DCLMapRotSin, L1.DCLMapRotCos);
    if L2.DCLMapRotCos = 0 then D2 := Pi else D2 := ArcTan2(L2.DCLMapRotSin, L2.DCLMapRotCos);
    if L3.DCLMapRotCos = 0 then D3 := Pi else D3 := ArcTan2(L3.DCLMapRotSin, L3.DCLMapRotCos);
    while Abs(D2 - D1) - 1e-8 > Pi do
    begin
      if D1 < D2 then D1 := D1 + piM2 else D1 := D1 - piM2;
    end;
    while Abs(D3 - D2) - 1e-8 > Pi do
    begin
      if D3 < D2 then D3 := D3 + piM2 else D3 := D3 - piM2;
    end;
    D3 := D1 * W1 + D2 * W2 + D3 * W3;
    InterpolLightVals.DCLMapRotSin := Sin(D3);
    InterpolLightVals.DCLMapRotCos := Cos(D3);
    CalcStepWidth(@InterpolHeader);
    InterpolLightVals.sStepWidth := InterpolHeader.dStepWidth;
    InterpolLightVals.sZZstmitDif := InterpolHeader.dZstart - InterpolHeader.dZmid;
    InterpolLightVals.lvMapScale := L1.lvMapScale * W1 + L2.lvMapScale * W2 + L3.lvMapScale * W3;
    InterpolLightVals.sDiffuseShadowing := L1.sDiffuseShadowing * W1 + L2.sDiffuseShadowing * W2 + L3.sDiffuseShadowing * W3;
    d1 := ArcTan2(L1.DCLMapRotSin, NonZero(L1.DCLMapRotCos));
    d2 := ArcTan2(L2.DCLMapRotSin, NonZero(L2.DCLMapRotCos));
    d3 := ArcTan2(L3.DCLMapRotSin, NonZero(L3.DCLMapRotCos));
    if Abs(d1 - d2) > Pi then d1 := d1 + Sign(d2 - d1) * 2 * Pi;
    if Abs(d3 - d2) > Pi then d3 := d3 + Sign(d2 - d3) * 2 * Pi;
    d1 := d1 * W1 + d2 * W2 + d3 * W3;
    InterpolLightVals.DCLMapRotSin := Sin(d1);
    InterpolLightVals.DCLMapRotCos := Cos(d1);

    //HAddon

    if (InterpolHAddon.bOptions1 and 3) = 1 then j := 1 else j := MAX_FORMULA_COUNT - 1;
    for i := 0 to j do if bInterpolateFormula(PTHeaderCustomAddon(H1.PCFAddon),
                            PTHeaderCustomAddon(H2.PCFAddon), i) and
                          bInterpolateFormula(PTHeaderCustomAddon(H1.PCFAddon),
                            PTHeaderCustomAddon(H3.PCFAddon), i) then
    begin
      Ini1CFfromHAddon(H1.PCFAddon, H1.PHCustomF[i], i);
      for IHS := 0 to Min(16, PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].iOptionCount) - 1 do
      if isAngleType(PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].byOptionType[IHS]) then   //CF.iOptionTYpes(3..6) = Angles ->  ipol 360°
      begin
        D1 := PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].dOptionValue[IHS];
        D2 := PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].dOptionValue[IHS];
        D3 := PTHeaderCustomAddon(H3.PCFAddon).Formulas[i].dOptionValue[IHS];
        if Abs(D1) > 10000 then D1 := 0;
        if Abs(D2) > 10000 then D2 := 0;
        if Abs(D3) > 10000 then D3 := 0;
        while Abs(D1 - D2) > 180.1 do
        begin
          if D2 < D1 then D2 := D2 + 360 else D2 := D2 - 360;
        end;
        while Abs(D2 - D3) > 180.1 do
        begin
          if D3 < D2 then D3 := D3 + 360 else D3 := D3 - 360;
        end;
        InterpolHAddon.Formulas[i].dOptionValue[IHS] := D1 * W1 + D2 * W2 + D3 * W3;
      end
      else  
      InterpolHAddon.Formulas[i].dOptionValue[IHS] :=
        PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].dOptionValue[IHS] * W1 +
        PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].dOptionValue[IHS] * W2 +
        PTHeaderCustomAddon(H3.PCFAddon).Formulas[i].dOptionValue[IHS] * W3;
      if j = 1 then
      begin
        PSingle(@InterpolHAddon.Formulas[i].iItCount)^ :=
          PSingle(@PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].iItCount)^ * W1 +
          PSingle(@PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].iItCount)^ * W2 +
          PSingle(@PTHeaderCustomAddon(H3.PCFAddon).Formulas[i].iItCount)^ * W3;
      end else begin
        InterpolHAddon.Formulas[i].iItCount := Round(
          PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].iItCount * W1 +
          PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].iItCount * W2 +
          PTHeaderCustomAddon(H3.PCFAddon).Formulas[i].iItCount * W3);
      end;
    end;
end;

procedure Slerp2SMatrices(SM1, SM2, FinSM: TPSmatrix3; t: Double);
var Q1, Q2: TQuaternion;
begin
    SMatrixToQuat(NormaliseSMatrixTo(1, SM1), Q1);
    SMatrixToQuat(NormaliseSMatrixTo(1, SM2), Q2);
    Q1 := InvertQuat(SlerpQuat(Q1, Q2, t));
    CreateSMatrixFromQuat(FinSM^, Q1);
end;

procedure Interpolate2frames(H1, H2: TPMandHeader11; L1, L2: TPLightVals; t: Double);
var i, j, IHS, HS1, HS2, i1, i2, ii: Integer;
    ps0, ps1, ps2: TPSingleArray;
    D1, D2, w1, w2, A, Amin, tm: Double;
    Q1, Q2: TQuaternion;
    M: TMatrix3;
    SV1, SV2: TSVec;
    V1: TVec3D;
begin
    w1 := 1 - t;
    w2 := t;
    
    if (H1.bCalcDOFtype and 1) = 0 then H1.sDOFaperture := 0;
    if (H2.bCalcDOFtype and 1) = 0 then H2.sDOFaperture := 0;

    InterpolHeader.bDFogIt := Round(H1.bDFogIt * W1 + H2.bDFogIt * W2);

    IHS := Integer(@InterpolHeader.MandId);
    HS1 := Integer(H1);
    HS2 := Integer(H2);
    for i := 0 to High(IntParsToInterpolate) do
      PInteger(IHS + IntParsToInterpolate[i])^ :=
        Round(PInteger(HS1 + IntParsToInterpolate[i])^ * W1 +
              PInteger(HS2 + IntParsToInterpolate[i])^ * W2);
    for i := 0 to High(DoubleParsToInterpolate) do
      PDouble(IHS + DoubleParsToInterpolate[i])^ :=
              PDouble(HS1 + DoubleParsToInterpolate[i])^ * W1 +
              PDouble(HS2 + DoubleParsToInterpolate[i])^ * W2;
    for i := 0 to High(SingleParsToInterpolate) do
      PSingle(IHS + SingleParsToInterpolate[i])^ :=
              PSingle(HS1 + SingleParsToInterpolate[i])^ * W1 +
              PSingle(HS2 + SingleParsToInterpolate[i])^ * W2;
    for i := 0 to High(DoubleToInterpolateLog) do  //zoom + Rbailout
    begin
      D1 := Max(1e-10, PDouble(HS1 + DoubleToInterpolateLog[i])^);
      D2 := Max(1e-10, PDouble(HS2 + DoubleToInterpolateLog[i])^);
      PDouble(IHS + DoubleToInterpolateLog[i])^ :=
        Power(10, Log10(D1) * W1 + Log10(D2) * W2);
    end;
    for i := 0 to High(DoubleAnglesToInterpolate) do
    begin
      D1 := PDouble(HS1 + DoubleAnglesToInterpolate[i])^;
      D2 := PDouble(HS2 + DoubleAnglesToInterpolate[i])^;
      if Abs(D1) > 1000 then D1 := 0;
      if Abs(D2) > 1000 then D2 := 0;
      while Abs(D2 - D1) - 1e-8 > Pi do
      begin
        if D2 < D1 then D2 := D2 + piM2 else D2 := D2 - piM2;
      end;
      PDouble(IHS + DoubleAnglesToInterpolate[i])^ := D1 * W1 + D2 * W2;
    end;

    MatrixToQuat(NormaliseMatrixTo(1, @H1.hVGrads), Q1);
    MatrixToQuat(NormaliseMatrixTo(1, @H2.hVGrads), Q2);
    Q1 := InvertQuat(SlerpQuat(Q1, Q2, w2));
    CreateMatrixFromQuat(InterpolHeader.hVGrads, Q1);

    InterpolHeader.MCSoftShadowRadius := SingleToShortFloat(
      ShortFloatToSingle(@H1.MCSoftShadowRadius) * W1 +
      ShortFloatToSingle(@H2.MCSoftShadowRadius) * W2);

   { D1 := Max(1e-10, H1.dZoom);
    D2 := Max(1e-10, H2.dZoom);
    A := Sqrt(D1 / D2);
    Amin := MinCD(Sqrt(D2 / D1), A);
    tm := Power(w2, Power(A, 0.5 * (1 + Amin))) * (1 - Amin) + w2 * Amin;
    for i := 0 to 4 do 
      PDouble(IHS + i * 8 + 20)^ :=
              PDouble(HS1 + i * 8 + 20)^ * (1 - tm) +
              PDouble(HS2 + i * 8 + 20)^ * tm;     //}
 {   D1 := Max(1e-10, H1.dZoom);
    D2 := Max(1e-10, H2.dZoom);
    if Abs(1 - D1 / D2) > 1e-3 then
    begin
      A := D2 - D1;
      tm := (InterpolHeader.dZoom - D1) / A; //t'  0..1
      if tm > 1e-3 then
      begin
        tm := w2 * w2 / tm;  nope
        for i := 0 to 4 do
          PDouble(IHS + i * 8 + 20)^ :=
                  PDouble(HS1 + i * 8 + 20)^ * (1 - tm) +
                  PDouble(HS2 + i * 8 + 20)^ * tm;     
      end;
    end;                    //}

    InterpolHeader.bStereoMode := H2.bStereoMode;
                             // Interpolate Light values

    InterpolLightVals.bBackBMP := L1.bBackBMP and L2.bBackBMP;

    ps0 := @InterpolLightVals.sGamma;
    ps1 := @L1.sGamma;
    ps2 := @L2.sGamma;
    for i := 0 to 11 do ps0[i] := ps1[i] * w1 + ps2[i] * w2;
    InterpolLightVals.sDiff := L1.sDiff * w1 + L2.sDiff * w2;
    InterpolLightVals.sSpec := L1.sSpec * w1 + L2.sSpec * w2;
    InterpolLightVals.sIndLightReflect := L1.sIndLightReflect * w1 + L2.sIndLightReflect * w2;

 //   StereoChange(@InterpolHeader, InterpolHeader.bStereoMode, InterpolLightVals.lvMidPos, @InterpolHeader.hVGrads);
    for i := 0 to 5 do
    begin
      i1 := L1.SortTab[i];
      i2 := L2.SortTab[i];
      j := InterpolLightVals.SortTab[i];
      if L1.iLightOption[i1] = 1 then ClearSVec(L1.PLValigned.sLCols[i1]);
      if L2.iLightOption[i2] = 1 then ClearSVec(L2.PLValigned.sLCols[i2]);
      InterpolLightVals.iLightOption[j] := L1.iLightOption[i1] and L2.iLightOption[i2];
      InterpolLightVals.iLightPowFunc[j] := Round(L1.iLightPowFunc[i1] * W1 + L2.iLightPowFunc[i2] * W2);
      InterpolLightVals.sLmaxL[j] := L1.sLmaxL[i1] * W1 + L2.sLmaxL[i2] * W2;
      if InterpolLightVals.iLightOption[j] = 2 then
      begin
        Slerp2SMatrices(@IPOLM1.LightPicRotM[i1], @IPOLM2.LightPicRotM[i2],
                        @InterpolLightVals.LLightMaps[j].PicRotMatrix, W2);
      end;
    end;
    ps0 := TPSingleArray(InterpolLightVals.PLValigned);
    ps1 := TPSingleArray(L1.PLValigned);
    ps2 := TPSingleArray(L2.PLValigned);
    for i := 0 to 167 do ps0[i] := ps1[i] * w1 + ps2[i] * w2;
    InterpolLightVals.lvMidPos := AddVecF(ScaleVector(L1.lvMidPos, w1),
      ScaleVector(L2.lvMidPos, w2));
    for i := 0 to 5 do
    begin
      i1 := L1.SortTab[i];
      i2 := L2.SortTab[i];
      j := InterpolLightVals.SortTab[i];
      if ((L1.iLightPos[i1] or L2.iLightPos[i2]) and 1) = 0 then
      begin
        if InterpolLightVals.iLightAbs[j] <> 0 then  //rotate rel vectors back before interpolation
        begin
          M := NormaliseMatrixTo(1, @H1.hVGrads);
          SV1 := L1.PLValigned.LN[i1];
          RotateSVector(@SV1, @M);
          M := NormaliseMatrixTo(1, @H2.hVGrads);
          SV2 := L2.PLValigned.LN[i2];
          RotateSVector(@SV2, @M);
          InterpolLightVals.PLValigned.LN[j] := SlerpSVec(@SV1, @SV2, w2);
          RotateSVectorReverse(@InterpolLightVals.PLValigned.LN[j], @InterpolHeader.hVGrads);
          NormaliseSVectorVar(InterpolLightVals.PLValigned.LN[j]);
        end
        else InterpolLightVals.PLValigned.LN[j] := SlerpSVec(@L1.PLValigned.LN[i1], @L2.PLValigned.LN[i2], w2);
      end
      else if (L1.iLightPos[i1] and L2.iLightPos[i2] and 1) = 1 then
      begin
        InterpolLightVals.PLValigned.LN[j] := DVecToSVec(SubtractVectors(
          AddVecF(ScaleVector(AddSVec2Vec3(@L1.PLValigned.LN[i1], @L1.lvMidPos), w1),
          ScaleVector(AddSVec2Vec3(@L2.PLValigned.LN[i2], @L2.lvMidPos), w2)), @InterpolLightVals.lvMidPos));
      {  if (InterpolHeader.bVolLightNr and 7) > 0 then
        begin
          V1 := TPVec3D(@InterpolLightVals.lvMidPos)^;
          AddSVec2Vec3d(InterpolLightVals.PLValigned.LN[j], @V1);
          SetLightPosFromDVec(InterpolHeader.Light.Lights[i], V1);
        end;   }
{        InterpolLightVals.PLValigned.LN[j] := DVecToSVec(SubtractVectors(
          AddVecF(ScaleVector(AddSVec2Vec3(@L1.PLValigned.LN[i1], @H1.dXmid), w1),
          ScaleVector(AddSVec2Vec3(@L2.PLValigned.LN[i2], @H2.dXmid), w2)), @InterpolHeader.dXmid));  }
      end;                                        //vec[3] also init?
   //   InterpolLightVals.PLValigned.sLCols[j] := LinInterpolate2SVecs(L1.PLValigned.sLCols[i1], L2.PLValigned.sLCols[i2], w1);
      for ii := 0 to 2 do
        InterpolLightVals.PLValigned.sLCols[j][ii] :=
          L1.PLValigned.sLCols[i1][ii] * w1 + L2.PLValigned.sLCols[i2][ii] * w2;
    end;
    for i := 0 to 3 do
    begin
      InterpolLightVals.IColPos[i] := Max(0, Min(32767, Round(L1.IColPos[i] * W1 + L2.IColPos[i] * W2)));
      InterpolLightVals.sICDiv[i] := Max(0, Min(1, L1.sICDiv[i] * W1 + L2.sICDiv[i] * W2));
    end;
    for i := 0 to 9 do
    begin
      InterpolLightVals.ColPos[i] := Max(0, Min(32767, Round(L1.ColPos[i] * W1 + L2.ColPos[i] * W2)));
      InterpolLightVals.sCDiv[i] := Max(0, Min(1, L1.sCDiv[i] * W1 + L2.sCDiv[i] * W2));
    end;
    d1 := L1.sGamma * W1 * L1.iGammaH + L2.sGamma * W2 * L2.iGammaH;
    InterpolLightVals.sGamma := Min(1, Abs(d1));
    if Abs(d1) < 0.005 then InterpolLightVals.iGammaH := 0 else
    if d1 < 0 then InterpolLightVals.iGammaH := -1 else InterpolLightVals.iGammaH := 1;

    InterpolLightVals.sDynFogMul := L1.sDynFogMul * W1 + L2.sDynFogMul * W2;
    InterpolLightVals.sRoughnessFactor := L1.sRoughnessFactor * W1 + L2.sRoughnessFactor * W2;

    if InterpolLightVals.bBackBMP then
      Slerp2SMatrices(@IPOLM1.BGPicRotM, @IPOLM2.BGPicRotM,
                      @InterpolLightVals.BGLightMap.PicRotMatrix, W2);

    Slerp2SMatrices(@IPOLM1.DiffColRotM, @IPOLM2.DiffColRotM,
                    @InterpolLightVals.DiffColLightMap.PicRotMatrix, W2);
    d1 := L1.DCLMapOffX;
    d2 := L2.DCLMapOffX;
    if Abs(d1 - d2) > 0.5 then
    begin
      if d1 < d2 then d1 := d1 + 1 else d1 := d1 - 1;
    end;
    InterpolLightVals.DCLMapOffX := D1 * W1 + D2 * W2;
    d1 := L1.DCLMapOffY;
    d2 := L2.DCLMapOffY;
    if Abs(d1 - d2) > 0.5 then
    begin
      if d1 < d2 then d1 := d1 + 1 else d1 := d1 - 1;
    end;
    InterpolLightVals.DCLMapOffY := D1 * W1 + D2 * W2;

    CalcStepWidth(@InterpolHeader);
    InterpolLightVals.sStepWidth := InterpolHeader.dStepWidth;
    InterpolLightVals.sZZstmitDif := InterpolHeader.dZstart - InterpolHeader.dZmid;
    InterpolLightVals.lvMapScale := L1.lvMapScale * W1 + L2.lvMapScale * W2;
    InterpolLightVals.sDiffuseShadowing := L1.sDiffuseShadowing * W1 + L2.sDiffuseShadowing * W2;
    d1 := ArcTan2(L1.DCLMapRotSin, NonZero(L1.DCLMapRotCos));
    d2 := ArcTan2(L2.DCLMapRotSin, NonZero(L2.DCLMapRotCos));
    if Abs(d1 - d2) > Pi then d1 := d1 + Sign(d2 - d1) * 2 * Pi;
    d1 := d1 * W1 + d2 * W2;
    InterpolLightVals.DCLMapRotSin := Sin(d1);
    InterpolLightVals.DCLMapRotCos := Cos(d1);
  { iKFcount: Integer;     //for interpolation purpose!
    ZposDynFog: Single;    //for SRcalculation, is different from plv.zpos, used by ColVarOnZ
    sObjLightDecreaser: Single;  //for SR calc, only decrease Object light, no fogs  }

    //HAddon
    if (InterpolHAddon.bOptions1 and 3) = 1 then j := 1 else j := MAX_FORMULA_COUNT - 1;
    for i := 0 to j do if bInterpolateFormula(PTHeaderCustomAddon(H1.PCFAddon),
                            PTHeaderCustomAddon(H2.PCFAddon), i) then
    begin
      Ini1CFfromHAddon(H1.PCFAddon, H1.PHCustomF[i], i);
      for IHS := 0 to Min(16, PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].iOptionCount) - 1 do
        if isAngleType(PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].byOptionType[IHS]) then
        begin
          D1 := PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].dOptionValue[IHS];
          D2 := PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].dOptionValue[IHS];
          if Abs(D1) > 10000 then D1 := 0;
          if Abs(D2) > 10000 then D2 := 0;
          while Abs(D1 - D2) > 180.1 do
          begin
            if D2 < D1 then D2 := D2 + 360 else D2 := D2 - 360;
          end;
          InterpolHAddon.Formulas[i].dOptionValue[IHS] := D1 * W1 + D2 * W2;
        end
        else
        InterpolHAddon.Formulas[i].dOptionValue[IHS] :=
          PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].dOptionValue[IHS] * W1 +
          PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].dOptionValue[IHS] * W2;

      if j = 1 then
      begin
        PSingle(@InterpolHAddon.Formulas[i].iItCount)^ :=
          PSingle(@PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].iItCount)^ * W1 +
          PSingle(@PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].iItCount)^ * W2;
      end else begin
        InterpolHAddon.Formulas[i].iItCount := Round(
          PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].iItCount * W1 +
          PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].iItCount * W2);
      end;
    end;

end;


end.
