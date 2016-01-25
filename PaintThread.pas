unit PaintThread;

interface

uses
  Windows, Classes, TypeDefinitions, Math3D;

type          

  TPaintThreadMC = class(TThread)
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    PaintParameter: TMCPaintParameter;
  protected
    procedure Execute; override;
  end;
  TPaintThread = class(TThread)
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    PaintParameter: TPaintParameter;
  protected
    procedure Execute; override;
  end;
  TPaintRowsThread = class(TThread)
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    iThreadID, iStartRow, iEndRow: Integer;
    PaintParameter: TPaintParameter;
  protected
    procedure Execute; override;
  end;
  TPaintRectThread = class(TThread)
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    iThreadID: Integer;
    PaintRect: TRect;
    PaintParameter: TPaintParameter;
  protected
    procedure Execute; override;
  end;
procedure GetStartSPosAndAddVecs(var PLV: TPaintLightVals; var PP: TPaintParameter; var StartPos, SPosYadd, SPosXadd: TSVec);
procedure CalcObjPos(var PLV: TPaintLightVals; var PP: TPaintParameter; PsiLight: TPsiLight5; const SPosX: TPSVec);
procedure AddSPos(var SPos, SPosPlus: TSVec);
procedure AddSPosY(var SPos, SPosPlus: TSVec; const Step: Integer);
procedure CalcViewVec(PLV: TPPaintLightVals; const sAspect: Single);
procedure PaintRows(StartRow, EndRow: Integer);
procedure PaintRowsNoThread(StartRow, EndRow: Integer);
function ActivePRThreads: Integer;
procedure PaintRowsNoThreadBlocky(StartRow, EndRow: Integer);
procedure PreCalcDepthCol(Dfunc: Integer; PLV: TPPaintLightVals; PLValigned: TPLValigned);
procedure CalcPixelColor2(SL: PCardinal; PsiLight: TPsiLight5; PLVals: Pointer; PLV: TPPaintLightVals);
procedure CalcPixelColorSqr(SL: PCardinal; PsiLight: TPsiLight5; PLVals: Pointer; PLV: TPPaintLightVals);
function CalcPixelColorSvec(SVcol: TPSVec; var InSD: TLightSD; PsiLight: TPsiLight5; PLVals: Pointer; PLV: TPPaintLightVals): TSVec;
function CalcPixelColorSvecTrans(SVcol: TPSVec; var InSD: TLightSD; PsiLight: TPsiLight5; PLVals: Pointer; PLV: TPPaintLightVals): TSVec;  //get back the diffuse color
procedure PaintMC(MCparas: TPMandHeader10);
procedure CalcPosLightShape(var flux, transp: Single; LightNr: Integer; PLVals: TPLightVals);
procedure CalcColors(iDif, iSpe: TPSVec; PsiLight: TPsiLight5; PLVals: TPLightVals);
procedure CalcColorsInside(iDif, iSpe: TPSVec; PsiLight: TPsiLight5; PLVals: TPLightVals);
procedure PaintRect(R: TRect);
function ConvertVLight(Win: Integer): Integer;
var
  parothi: Integer;
  RepaintCounts: array[0..15] of Integer;
  RepYact: array[0..15] of Integer;
  RepaintCounter: Integer = 0;
  MCRepaintCounter: Integer = 0;
  RepYThreads: Integer = 0;
  MCYact: Integer = 0;
  MCThreadActive: Integer = 0;
  PaintRowsTActive: array[0..15] of Integer;
//  MCPTtime: Double;

implementation

uses LightAdjust, Mand, HeaderTrafos, DivUtils, Math, ImageProcess, Tiling,
     Interpolation, MonteCarloForm, Graphics, SysUtils;


{function Nz(Nx, Ny: Single): Single;
var dTmp: Double;
begin
    dTmp := 1 - Sqr(Nx) - Sqr(Ny);
    if dTmp < 0 then Result := -Sqrt(-dTmp) else Result := Sqrt(dTmp);
end; }

{function fastPowX(s, pow: Single): Single;
var i, j: Integer;
begin
    if s < 0 then Result := 0 else
    if s > 1 then Result := 1 else
    begin
      i := Round(pow - 0.5);
      j := i;
      Result := s;
      while i > 1 do
      begin
        i := i shr 1;
        Result := Result * Result;
      end;
      Result := Result + (pow - j) * (Result * Result - Result);
    end;
end;

function fastPowX2(var s, pow: Single): Single;
var i: Integer;
begin
    if s < 0 then Result := 0 else
    if s > 1 then Result := 1 else
    begin
      i := Round(16384 * Sqrt(pow * 0.125) * (1 - s));
      if i > 16383 then Result := 0 else
      Result := sPowTab[i];
    end;
end;  }

   // DotOf2VecNormalize(normals, LiVec, ViewVec);   //specular calc
function DotOf2VecNormalize(norm, light, view: TPSVec): Single;
{var d0, d1, d2: Double;  // eax,  edx,  ecx,         st
begin
    d0 := V2[0] - V3[0];
    d1 := V2[1] - V3[1];
    d2 := V2[2] - V3[2];
    Result := (V1[0] * d0 + V1[1] * d1 + V1[2] * d2) / Sqrt(Sqr(d0) + Sqr(d1) + Sqr(d2) + 0.01); // }
 //  reflectedray := SubtractVectors(@ViewVec, ScaleVector(normals, 2 * DotOfVectors(@normals, @ViewVec)));
 //  DotOfVectors(reflectedray, LiVec)
{var d2: Single;
begin
//   Result := DotOfSVectors(V2^, SubtractSVectors(V3, ScaleSVector(V1^, 2 * DotOfSVectors(V1^, V3^))));
   d2 := 2 * (norm[0]* view[0] + norm[1]* view[1] + norm[2]* view[2]);
   Result := light[0] * (view[0] - norm[0] * d2) + light[1] * (view[1] - norm[1] * d2) + light[2] * (view[2] - norm[2] * d2);
end;  }
asm
  fld  dword [eax]
  fld  dword [eax + 4]
  fld  dword [eax + 8]  //norm2, norm1, norm0
  fld  dword [ecx]
  fmul st, st(3)
  fld  dword [ecx + 4]
  fmul st, st(3)
  faddp
  fld  dword [ecx + 8]
  fmul st, st(2)
  faddp
  fadd st, st           //d2, norm2, norm1, norm0
  fmul st(3), st
  fmul st(2), st
  fmulp                 //norm2', norm1', norm0'
  fsubr dword [ecx + 8]
  fmul dword [edx + 8]
  fxch
  fsubr dword [ecx + 4]
  fmul dword [edx + 4]
  faddp
  fxch
  fsubr dword [ecx]
  fmul dword [edx]
  faddp
end;
 {
asm
  fld  dword [edx]
  fsub dword [ecx]
  fld  dword [edx + 4]
  fsub dword [ecx + 4]
  fld  dword [edx + 8]
  fsub dword [ecx + 8] //d2,d1,d0
  fld  st(2)
  fmul st, st
  fld  st(2)
  fmul st, st
  faddp
  fld  st(1)
  fmul st, st
  faddp
  fadd s001    //s01
  fsqrt        //divi,d2,d1,d0
  fxch st(3)   //d0,d2,d1,divi
  fmul dword [eax]
  fxch         //d2,d0',d1,divi
  fmul dword [eax + 8]
  faddp        //d2'+d0',d1,divi
  fxch
  fmul dword [eax + 4]
  faddp
  fdivrp
end;   }
                         //  eax    edx                   ecx
procedure calcAmbshadow(var dAmbS, sAmplitude: Single; PsiLight: TPsiLight5);
const s1d16383: Single = 1/16383;
{begin
    if sAmplitude > 1 then
    begin
      dAmbS := 1 - Integer(PsiLight.AmbShadow) * s1d16383;     // <0
      dAmbS := dAmbS + (sAmplitude - 1) * (Sqr(dAmbS) - dAmbS);    //lin ipol between dAmbS and Sqr(dAmbS)
    end
    else dAmbS := 1 - sAmplitude * Integer(PsiLight.AmbShadow) * s1d16383; //}
asm
  fld1
  cmp  word [ecx + 12], 16383
  jl   @@2
  fld1
  jmp  @@3
@@2:
  fild word [ecx + 12]
  fmul s1d16383
@@3:
  fld  dword [edx]      //Ampl, Shadow, 1
  mov  edx, eax
  fcom st(2)
  fnstsw ax
  shr ah, 1
  jc  @@1
  fxch
  fsubr st, st(2)       //dAmbS, Ampl, 1
  fxch                  //Ampl,dAmbS,1
  fsubrp st(2), st      //dAmbS,Ampl-1
  fld  st
  fmul st, st
  fsub st, st(1)        //Sqr(dAmbS)-dAmbS,dAmbS,Ampl-1
  fmulp st(2), st
  faddp
  fstp dword [edx]
  ret
@@1:
  fmulp
  fsubp
  fstp dword [edx]
end;

function SqrSV255(const sv: TSVec): TSVec;
{begin                 //eax          edx
    Result[0] := Sqr(sv[0]) * s1d255;
    Result[1] := Sqr(sv[1]) * s1d255;
    Result[2] := Sqr(sv[2]) * s1d255;  }
asm
  fld  dword [eax]
  fmul st, st
  fld  dword [eax + 4]
  fmul st, st
  fld  dword [eax + 8]
  fmul st, st
  fld  s1d255
  fmul st(3), st
  fmul st(2), st
  fmulp
  fstp [edx + 8]
  fstp [edx + 4]
  fstp [edx]
end;
                              // dtmp3 idif[0]
procedure CalcPosLightShape(var flux, transp: Single; LightNr: Integer; PLVals: TPLightVals);
var PosLight: LongBool;
    tmpR, RtmpR: Single;
begin
    with PLVals^ do
    begin
      tmpR := transp;
      RtmpR := 1 / tmpR;
      PosLight := (iLightPos[LightNr] and 1) > 0;
      case iLightPos[LightNr] and 14 of
      4: //old light option with more transparency
        begin
          transp := Sqr(Sqr(flux * RtmpR));  //weight of object behind light
          flux := 7e-3 * (tmpR - flux) * Sqr(RtmpR);  // weight lamp
        end;
      2: //vislight3
        begin
          transp := 1;
          flux := 1 - Sqrt(flux * RtmpR);
          if bCalcPixColSqr then flux := 5e-2 * FastPow(flux, 80) * RtmpR
                            else flux := 5e-2 * FastPow(flux, 50) * RtmpR;
          if PosLight then flux := flux * 1.5;
        end;
      6: //vislight2
        begin
          flux := flux * 1.05 * RtmpR;
          if flux < 1 then
          begin
            if PosLight then transp := Max0S(flux - 0.95) * 10  //  weight background
                        else transp := 0.7;
            flux := 4e-3 * Sqrt(1.05 - Sqr(flux)) * RtmpR;     // weight lamp
            if not PosLight then flux := flux * 0.7;   //background, decrease light because full depth col is added
          end
          else if PosLight then
          begin
            transp := (flux - 0.95) * 10;
            flux := 17.8e-3 * (1.05 - flux) * RtmpR;
          end else begin
            transp := (flux - 1) * 6 + 0.7;
            flux := 12.5e-3 * (1.05 - flux) * RtmpR;
          end;
        end
        else
        begin
          transp := 1;
          if bCalcPixColSqr then tmpR := 40 else tmpR := 25;
          flux := (1 - flux * RtmpR) * 0.1 / Sqr((flux * RtmpR + 0.0004) * tmpR) * RtmpR;
        end;
      end;
    end;
end;

function GetDiffMapWrap3D(PLVals: Pointer; lns: TPSVec; PLV: TPPaintLightVals): TSVec;
var SV2: TSVec;
    SV1: TVec3D;
begin
    with TPLightVals(PLVals)^ do
    begin
      SV1 := ScaleVector(AddVecF(SVecToDVec(PLV.ObjPos), lvMidPos), lvMapScale);
      SV2 := lns^;
      RotateSVectorS(@SV2, PLV.PSmatrix);
      ScaleSVectorV(@SV2, 1 / (Abs(SV2[0]) + Abs(SV2[1]) + Abs(SV2[2])));   //first rotate?!  normals not scale??
      AbsSVecVar(SV2);
      if iColOnOT > 7 then
      begin
        if SV1[0] < 0 then SV1[0] := SV1[0] + 1 - Round(SV1[0]);
        if SV1[1] < 0 then SV1[1] := SV1[1] + 1 - Round(SV1[1]);
        if SV1[2] < 0 then SV1[2] := SV1[2] + 1 - Round(SV1[2]);
        Result := Add3SVectors(ScaleSVector(GetLightMapPixel(Frac(SV1[1] + DCLMapOffX), Frac(SV1[2] + DCLMapOffY), DiffColLightMap, bCalcPixColSqr, 1), SV2[0]),
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
        Result := GetLightMapPixel(Frac(SV1[0]), Frac(SV1[1]), DiffColLightMap, bCalcPixColSqr, 1);
      end;
    end;
end;

procedure CalcColorsInside(iDif, iSpe: TPSVec; PsiLight: TPsiLight5; PLVals: TPLightVals);
var stmp: Single;
    ir, iL1, iL2: Integer;
label l1;
begin
    with PLVals^ do
    begin
      ir := Round(((PsiLight.SIgradient - sCiStart) * sCimul + iDif[0]) * 16384);
      if bColCycling then ir := ir and 32767 else
      begin
        if ir < 0 then
        begin
          iDif^ := PLValigned.ColInt[0];
          goto l1;
        end
        else if ir > IColPos[3] then
        begin
          iDif^ := PLValigned.ColInt[3];
          goto l1;
        end;
      end;
      iL2 := 1;
      while (iL2 < 4) and (IColPos[iL2] < ir) do Inc(iL2);
      if bNoColIpol then iDif^ := PLValigned.ColInt[iL2 - 1] else
      begin
        iL1 := iL2 - 1;
        iL2 := iL2 and 3;
        stmp := (ir - IColPos[iL1]) * sICDiv[iL1];
        iDif^ := LinInterpolate2SVecs(PLValigned.ColInt[iL2], PLValigned.ColInt[iL1], stmp);
      end;
l1:   iSpe[0] := iDif[3];
      iSpe[1] := iDif[3];
      iSpe[2] := iDif[3];
      iSpe[3] := iDif[3];  //0; transp?
      iDif[3] := 0;
    end;
end;

procedure CalcColors(iDif, iSpe: TPSVec; PsiLight: TPsiLight5; PLVals: TPLightVals);
var stmp: Single;
    ir, iL1, iL2: Integer;
begin
    with PLVals^ do
    begin
      if (iColOnOT and 1) = 0 then ir := PsiLight.SIgradient
                              else ir := PsiLight.OTrap and $7FFF;
      ir := Round(MinMaxCS(-1e9, ((ir - sCStart) * sCmul + iDif[0]) * 16384, 1e9));
      iL2 := 5;
      if bColCycling then ir := ir and 32767 else
      begin
        if ir < 0 then
        begin
          iSpe^ := PLValigned.ColSpe[0];
          iDif^ := PLValigned.ColDif[0];
          Exit;
        end
        else if ir >= ColPos[9] then
        begin
          iSpe^ := PLValigned.ColSpe[9];
          iDif^ := PLValigned.ColDif[9];
          Exit;
        end;
      end;
      if ColPos[iL2] < ir then
      begin
        repeat Inc(iL2) until (iL2 = 10) or (ColPos[iL2] >= ir);
      end
      else while (ColPos[iL2 - 1] >= ir) and (iL2 > 1) do Dec(iL2);
      if bNoColIpol then
      begin
        iSpe^ := PLValigned.ColSpe[iL2 - 1];
        iDif^ := PLValigned.ColDif[iL2 - 1];
      end
      else
      begin
        iL1 := iL2 - 1;
        if iL2 > 9 then iL2 := 0;
        stmp := (ir - ColPos[iL1]) * sCDiv[iL1];
        iSpe^ := LinInterpolate2SVecs(PLValigned.ColSpe[iL2], PLValigned.ColSpe[iL1], stmp);
        iDif^ := LinInterpolate2SVecs(PLValigned.ColDif[iL2], PLValigned.ColDif[iL1], stmp);
      end;
    end;
end;

procedure CalcTotalLight1(LiLSDAI: TPLightLSDAIs; PLVals: TPLightVals; pAmbsh: PSingle);
var stmp, stmp2: Single;
begin
    if PLVals.bCalcPixColSqr then stmp := s011 else stmp := s03;
    LiLSDAI[3] := Add2SVecsWeight2(LiLSDAI[4], MultiplySVectors(LiLSDAI[0], LiLSDAI[3]), pAmbsh^ * stmp);
    stmp := Max0S(1 - pAmbsh^);
    stmp2 := Sqr(Sqr(stmp)); //amount of 2nd reflection    LiLSDAI[0..4] = lns, sLiDif, iDif, LiAmb, iAmb
    LiLSDAI[4] := AddSVectors(LiLSDAI[1], MultiplySVectors(LiLSDAI[3],   // 0     1      2      3      4
      MultiplySVectors(LiLSDAI[2], AddSVecS(ScaleSVector(LiLSDAI[2], stmp2 * PLVals.sIndLightReflect), stmp - stmp2))));
end;                      //simulates 2 selfreflections in ambshadow parts

procedure CalcTotalLight2(LiLSDAI: TPLightLSDAIs; PLVals: TPLightVals; pAmbsh: PSingle);  //mode2
var stmp, stmp2: Single; //LiLSDAI: [diff object col scaled, total light shadowed, diff object col, total light no shadow, amblight->output]
begin
    stmp := Sqr(Max0S(1 - pAmbSh^)) * PLVals.sIndLightReflect; //2.72 max
    stmp2 := YofSVec(@LiLSDAI[1]) + 4;
    LiLSDAI[4] := Add2SVecsWeight2(LiLSDAI[1], MultiplySVectors(LiLSDAI[1], LiLSDAI[2]), stmp);
    ScaleSVectorV(@LiLSDAI[4], (stmp2 + (stmp2 + 128) * (stmp + s011) * 0.04) / (Max0S(YofSVec(@LiLSDAI[4])) + 3));
end;

function ConvertVLight(Win: Integer): Integer;
{begin
    Result := (Win and $7F) shl ((Win shr 7) and $7);
end;     }
asm
    push ecx
    and  eax, $3FF
    mov  ecx, eax
    shr  ecx, 7
    and  eax, $7F
    shl  eax, cl
    pop  ecx
    mov  edx, eax
end;

procedure CalcPixelColor2(SL: PCardinal; PsiLight: TPsiLight5; PLVals: Pointer{TPLightVals}; PLV: TPPaintLightVals);
var bSubAmbSh, noHS, softHS: LongBool;
    ir, iL1: Integer;
    dRough, dTmp2, dAmbSh, dFog, dTmp, dTmp3: Single;
    LiLSDAI: TLightLSDAIs;  //replaces lns, sLiDif, iDif, LiAmb, iAmb, iSpe
    {lns, iDif, iAmb, sLiDif, LiAmb, iSpe,} sLiSpe, DepC: TSVec;
begin
    with TPLightVals(PLVals)^ do
    begin
      if bAmbRelObj then
        DepC := LinInterpolate2SVecs(PLValigned.sDepthCol2, PLValigned.sDepthCol, ArcSinSafe(PLV.AbsViewVec[1]) * Pi1d + s05)
      else DepC := PLV.PreDepthCol;
      if PsiLight.Zpos < 32768 then //object, not background
      begin
        dRough := (PsiLight.RoughZposFine and $FF) * sRoughnessFactor;

        calcAmbshadow(dAmbSh, sAmbShad, PsiLight);

        dFog := sDiffuseShadowing * (dAmbSh - 1) + 1;  //a bit dAmbsh always  -> vary by user option.. DiffAO * (dAmbSh - 1) + 1
        LiLSDAI[0] := MakeSVecFromNormalsD(PsiLight);
        ClearSVec(LiLSDAI[1]);
        ClearSVec(sLiSpe);
        ClearSVec(LiLSDAI[3]);   // todo: Single val for amount of 2nd reflection ?
        ir := 0;
        while ir < 6 do
        begin
          if iLightOption[ir] = 0 then //light on
          begin
            bSubAmbSh := LongBool(iHScalced[ir] xor iHSenabled[ir]);
            softHS := iHSmask[ir] = -1;
            noHS := softHS or ((PsiLight.Shadow and iHSmask[ir]) = 0) or (iHScalced[ir] = 0);
                                                                          //  iHSenabled
            LiLSDAI[5] := PLValigned.LN[ir];
            if (iLightPos[ir] and 1) <> 0 then       //positional light
            begin
              LiLSDAI[5] := SubtractSVectors(@LiLSDAI[5], PLV.ObjPos);
              dTmp2 := SqrLengthOfSVec(LiLSDAI[5]);
              if dTmp2 > sLmaxL[ir] then
              begin
                Inc(ir);
                Continue;
              end;
              ScaleSVectorV(@LiLSDAI[5], 1 / Sqrt(dTmp2));
            //  NormaliseSVectorVar(LiLSDAI[5]);
              RotateSVectorReverseS(@LiLSDAI[5], PLV.PSmatrix);
              dTmp2 := 1 / (dTmp2 + s1em30);
            end
            else dTmp2 := 1;
            dTmp := GetCosTabVal(iLightFuncDiff[ir], DotOfSVectors(LiLSDAI[0], LiLSDAI[5]), dRough) * dTmp2;

            AddSVecWeights(@LiLSDAI[3], @PLValigned.sLCols[ir], dTmp);   //also one Dif light for 2.reflection, always no dAmbSh
            if noHS then
            begin                                      //if iHScalced[ir] then..
              if bSubAmbSh then dTmp := dTmp * dAmbSh else {if iHSenabled[ir] = 0 then} dTmp := dTmp * dFog;
              if softHS then dTmp := dTmp * (PsiLight.Shadow shr 10) * s1d63;
              AddSVecWeights(@LiLSDAI[1], @PLValigned.sLCols[ir], dTmp);
            end;

            dTmp := DotOf2VecNormalize(@LiLSDAI[0], @LiLSDAI[5], @PLV.ViewVec);   //specular calc
            if dTmp > 0 then
            begin
              dTmp2 := (dTmp2 + MinCS(1, dRough * 2) * (1 / iLightPowFunc[ir] - dTmp2)) * sSpec;
              if dTmp2 > 0 then
              begin
                AddSVecWeights(@LiLSDAI[3], @PLValigned.sLCols[ir], dTmp2 / iLightPowFunc[ir]);
                if noHS then
                begin
                  dTmp2 := dTmp2 * FastIntPow(dTmp, iLightPowFunc[ir]);
                  if bSubAmbSh then dTmp2 := dTmp2 * dAmbSh else {if iHSenabled[ir] = 0 then} dTmp2 := dTmp2 * dFog;  //*NEW*
                  if softHS then dTmp2 := dTmp2 * (PsiLight.Shadow shr 10) * s1d63;
                  AddSVecWeights(@sLiSpe, @PLValigned.sLCols[ir], dTmp2);
                end;
              end;
            end;
          end
          else if iLightOption[ir] = 2 then     //lightmaps:
          begin
            LiLSDAI[4] := LinInterpolate2SVecs(LLightMaps[ir].LMavrgCol, ScaleSVector(GetLightMapPixelSphere(LiLSDAI[0], @LLightMaps[ir].PicRotMatrix, LLightMaps[ir], bCalcPixColSqr), s255), dRough);
            AddSVecWeights(@LiLSDAI[3], @LiLSDAI[4], 1);
            AddSVecWeights(@LiLSDAI[1], @LiLSDAI[4], dAmbSh);
          end;
          Inc(ir);
        end;
        bSubAmbSh := PsiLight.SIgradient > 32767;    //in bulb      obj color   is: _bIsInterior_

        LiLSDAI[2][0] := sColZmul * PLV.zPos;
        if bSubAmbSh then CalcColorsInside(@LiLSDAI[2], @LiLSDAI[5], PsiLight, PLVals)
        else CalcColors(@LiLSDAI[2], @LiLSDAI[5], PsiLight, PLVals);

        if iColOnOT > 1 then //diffmap
        begin
          if bYCcomb then LiLSDAI[4] := LiLSDAI[2];  //backup for y-c combi
          if iColOnOT > 3 then
          begin
            if iColOnOT > 5 then
              LiLSDAI[2] := GetDiffMapWrap3D(PLVals, @LiLSDAI[0], PLV)
            else
              LiLSDAI[2] := GetLightMapPixelSphere(LiLSDAI[0], @DiffColLightMap.PicRotMatrix, DiffColLightMap, False);//DiffMap on normals
            LiLSDAI[2] := Add2SVecsWeight(LiLSDAI[2], DiffColLightMap.LMavrgCol, 1 - dRough, dRough * s1d255);
          end else begin
            dTmp := (PsiLight.OTrap and $7FFF) * 3.05186851e-5 - 0.5;  //because it was calculated as arctan2:2pi * 5215
            dTmp2 := PsiLight.SIgradient * 3.05186851e-5 - 0.5;
            LiLSDAI[2] := GetLightMapPixel(Frac((DCLMapRotCos * dTmp + DCLMapRotSin * dTmp2 + DCLMapOffX) * lvMapScale),
              Frac((DCLMapRotCos * dTmp2 - DCLMapRotSin * dTmp + DCLMapOffY) * lvMapScale), DiffColLightMap, False, 1);
          end;
          if bYCcomb then
            LiLSDAI[2] := ScaleSVector(LiLSDAI[4], YofSVec(@LiLSDAI[2]) / (s001 + YofSVec(@LiLSDAI[4])));
        end;

        if bUseSmallBGpicForAmb then
        begin
          RotateSVectorS(@LiLSDAI[0], PLV.PSmatrix);
          LiLSDAI[4] := ScaleSVector(GetLightMapPixelSphere(LiLSDAI[0], @BGsmallLM.PicRotMatrix, BGsmallLM, False), s255);
          dTmp := Max0S(1 - Max0S(1 - 28000 * sDepth)); //Add depC col
          if bFarFog then dTmp := Sqr(dTmp);
          if bAddBGlight then AddSVecWeight(@LiLSDAI[4], @DepC, dTmp)
                         else LiLSDAI[4] := LinInterpolate2SVecs(LiLSDAI[4], DepC, 1 - dTmp);
          ScaleSVectorV(@LiLSDAI[4], dAmbSh);
        end
        else
        begin
          if bAmbRelObj then
            LiLSDAI[0][1] := LiLSDAI[0][0] * PLV.PSmatrix[0,1] + LiLSDAI[0][1] * PLV.PSmatrix[1,1] + LiLSDAI[0][2] * PLV.PSmatrix[2,1];  //   lns[1] = y normals
          dTmp2 := (LiLSDAI[0][1] * s05 + s05) * dAmbSh; //y of normals vec
          dTmp  := dAmbSh - dTmp2;
          LiLSDAI[4] := Add2SVecsWeight(PLValigned.sAmbCol, PLValigned.sAmbCol2, dTmp, dTmp2);
        end;
        MultiplySVectorsV(@LiLSDAI[4], @LiLSDAI[2]);  //amb light top/bot  ..todo: add depC (+dFog) before

        LiLSDAI[0] := ScaleSVector(LiLSDAI[2], sDiff);   //diff object color scaled
        LiLSDAI[1] := Add3SVectors(LiLSDAI[4], MultiplySVectors(LiLSDAI[0], LiLSDAI[1]), MultiplySVectors(LiLSDAI[5], sLiSpe));  //total obj light, already decreased by AmbSh
                                                                                                       //Spec color   spec light
        if iExModes = 0 then CalcTotalLight1(@LiLSDAI, PLVals, @dAmbSh)
                        else CalcTotalLight2(@LiLSDAI, PLVals, @dAmbSh);
     {   LiLSDAI[3] := Add2SVecsWeight2(LiLSDAI[4], MultiplySVectors(LiLSDAI[0], LiLSDAI[3]), dAmbSh * s03);
        dTmp := Max0S(1 - dAmbSh);
        dTmp2 := Sqr(Sqr(dTmp)); //amount of 2nd reflection    LiSDAI[0..3] = sLiSpe, iDif, LiAmb, iAmb
        dTmp := dTmp - dTmp2;
        dTmp2 := dTmp2 * sIndLightReflect;
        LiLSDAI[4] := AddSVectors(LiLSDAI[1], MultiplySVectors(LiLSDAI[3],
          MultiplySVectors(LiLSDAI[2], AddSVecS(ScaleSVector(LiLSDAI[2], dTmp2), dTmp))));   //simulates 2 selfreflections in ambshadow parts
             }

        //test, add sqr of light with amount of dambsh and scale back:
   {     dTmp := Sqr(Max0S(1 - dAmbSh)) * sIndLightReflect;
    //    lns := Add2SVecsWeight2(sLiDif, MultiplySVectors(LiAmb, iDif), dTmp);
        iAmb := Add2SVecsWeight2(sLiDif, MultiplySVectors(sLiDif, iDif), dTmp);
        dTmp2 := (sLiDif[0] * s03 + sLiDif[1] * s059 + sLiDif[2] * s011) /  (Max0S(lns[0] * s03 + lns[1] * s059 + lns[2] * s011) + 3);
        ScaleSVectorV(@iAmb, dTmp2 * (1 + 0.2 * dTmp));  }

{        dTmp := Sqr(MaxCS(0.1, 1.1 - dAmbSh));
        lns := Add2SVecsWeight2(sLiDif, SqrSV255(sLiDif), dTmp * sIndLightReflect);
        dTmp2 := (sLiDif[0] * 0.3 + sLiDif[1] * 0.59 + sLiDif[2] * 0.11) /  (Max0S(lns[0] * 0.3 + lns[1] * 0.59 + lns[2] * 0.11) + 3);
        iAmb := ScaleSVector(lns, dTmp2 * (1 + 0.1 * dTmp * sIndLightReflect));  }

        dTmp := Max0S((PsiLight.Zpos - 28000) * sDepth + 1);
    //    ScaleSVectorV(@LiLSDAI[4], dTmp);
      end
      else
      begin
        if bBackBMP then  //background bmp
        begin
          if bDirectImageCoord then
            LiLSDAI[4] := ScaleSVector(GetLightMapPixel(PLV.xPos, PLV.yPos, BGLightMap, False, 0), s255)
          else
            LiLSDAI[4] := ScaleSVector(GetLightMapPixelSphere(PLV.AbsViewVec, @BGLightMap.PicRotMatrix, BGLightMap, False), s255);
        end
        else LiLSDAI[4] := DepC;
        dTmp := Max0S(1 - 28000 * sDepth);  //Zpos = 0
      end;

      if bFarFog and (dTmp < 1) then  dTmp := 1 - Sqr(1 - dTmp);

      if (PsiLight.Zpos < 32768) or (not bBackBMP) or (not bAddBGlight) then
        ScaleSVectorV(@LiLSDAI[4], dTmp);

      if bVolLight then ir := ConvertVLight(PsiLight.Shadow) else ir := PsiLight.Shadow and $3FF;
      dFog := (ir - sShad - sShadZmul * PLV.zPos) * sShadGr; //amount of dfog
      if (bDFogOptions and 2) <> 0 then dFog := Max0S(dFog);
      dTmp3 := MinCS(1, ir * sDynFogMul) * dFog;  //amount of 2nd dfog col

      LiLSDAI[4] := Add2SVecsWeight2(LiLSDAI[4], DepC, Max0S(1 - dTmp));
      if (bDFogOptions and 1) <> 0 then
      begin
        Clamp01Svar(dFog);
        Clamp01Svar(dTmp3);
        ScaleSVectorV(@LiLSDAI[4], 1 - dFog);
      end;
      AddSVectors(@LiLSDAI[4], Add2SVecsWeight(PLValigned.sDynFogCol, PLValigned.sDynFogCol2, dFog - dTmp3, dTmp3));


      iL1 := PsiLight.Zpos;
      if iL1 < 32768 then iL1 := 32768 - iL1;  // zpos for dynfog descaler
      dRough := 1 / iL1;
      for ir := 0 to 5 do if (iLightPos[ir] and 14) <> 0 then // bit1: posLight  bit2..4: visLsource func (0:0,4:1,6:2:,2:3..)
      begin  //Visible lights
        noHS := (iLightPos[ir] and 1) <> 0;
        if noHS then    //poslight
      //    dTmp3 := SqrDistSV(SubtractSVectors(@PLValigned.LN[ir], PLV.ObjPos), PLV.AbsViewVec)  //ObjPos?
          dTmp3 := SqrDistSV(SubtractSVectors(@PLV.CamPos, PLValigned.LN[ir]), PLV.AbsViewVec)
        else
        begin  //global light
          if PsiLight.Zpos < 32768 then Continue else bSubAmbSh := False;
          dTmp3 := Max0S(1 - DotOfSVectors(PLValigned.LN[ir], PLV.ViewVec));
        end;
        LiLSDAI[2][0] := sLmaxL[ir] * 1e-8;
        if dTmp3 < LiLSDAI[2][0] then
        begin
          if noHS then  //poslight
          begin   //proof if light is behind viewer
            if DotOfSVectors(SubtractSVectors(@PLValigned.LN[ir], PLV.CamPos), PLV.AbsViewVec) < 0 then Continue;
            if PsiLight.Zpos > 32767 then bSubAmbSh := False else
            begin
              LiLSDAI[2][1] := -Sqrt(LiLSDAI[2][0] - dTmp3);
              if Abs(PLV.AbsViewVec[0]) > s05 then     //proof if light is behind object
                bSubAmbSh := LiLSDAI[2][1] > (PLV.ObjPos[0] - PLValigned.LN[ir][0]) / PLV.AbsViewVec[0]
              else
              if Abs(PLV.AbsViewVec[1]) > s05 then
                bSubAmbSh := LiLSDAI[2][1] > (PLV.ObjPos[1] - PLValigned.LN[ir][1]) / PLV.AbsViewVec[1]
              else
                bSubAmbSh := LiLSDAI[2][1] > (PLV.ObjPos[2] - PLValigned.LN[ir][2]) / PLV.AbsViewVec[2];
            end;
          end;
          if bSubAmbSh then Continue;    //todo: lightrays with light x,y pos

          CalcPosLightShape(dTmp3, LiLSDAI[2][0], ir, PLVals);

        //combine iAmb with actual depthfog on the fly:
          LiLSDAI[2][2] := 1 - Max0S(1 + (sPosLP[ir] - 28000) * sDepth);             //amount at lightpos for depthfog calculation
          if bFarFog and (LiLSDAI[2][2] > 0) then LiLSDAI[2][2] := Sqr(LiLSDAI[2][2]);
          dTmp3 := dTmp3 * (1 - LiLSDAI[2][2] * 0.9);  //decrease vislight with depth

          if (iLightPos[ir] and 14) in [2, 8] then //vislight3, don't decrease light behind, just descale vislight
            LiLSDAI[4] := Add2SVecsWeight2(LiLSDAI[4], PLValigned.sLCols[ir], dTmp3)
          else
          begin   //decrease dynfog with lightpos depfog + (1-bg amount)
            LiLSDAI[2][2] := Max0S(LiLSDAI[2][2]);
            if bVolLight then iL1 := ConvertVLight(PsiLight.Shadow) else iL1 := PsiLight.Shadow and $3FF;
            dFog := (iL1 * (32768 - sPosLP[ir]) * dRough - sShad -
              sShadZmul * (sPosLightZpos[ir] + sZZstmitDif)) * sShadGr * (1 - LiLSDAI[2][0]) * (1 - LiLSDAI[2][2]);
            dAmbsh := MinCS(1, iL1 * (32768 - sPosLP[ir]) * dRough * sDynFogMul) * dFog;  //dynFog @lightpos
          //todo: if blendDynFog..
            LiLSDAI[4] := Add3SVectors(Add2SVecsWeight(LiLSDAI[4], DepC, LiLSDAI[2][0], LiLSDAI[2][2] * (1 - LiLSDAI[2][0])),
                    Add2SVecsWeight(PLValigned.sDynFogCol, PLValigned.sDynFogCol2, dFog - dAmbsh, dAmbsh),
                    ScaleSVector(PLValigned.sLCols[ir], dTmp3));
          end;
        end;
      end;
      LiLSDAI[4][3] := 0;
      LiLSDAI[0] := mMinMaxSVec(0, 255, LiLSDAI[4]);
      if iGammaH <> 0 then
      begin
        if iGammaH > 0 then LiLSDAI[5] := mSqrtSVec(ScaleSVector(LiLSDAI[0], 255))
                       else LiLSDAI[5] := SqrSV255(LiLSDAI[0]);
        LiLSDAI[0] := LinInterpolate2SVecs(LiLSDAI[5], LiLSDAI[0], sGamma);
      end;
      SL^ := (Round(LiLSDAI[0][0]) shl 16) or (Round(LiLSDAI[0][1]) shl 8) or Round(LiLSDAI[0][2]);
    end;
end;

procedure CalcPixelColorSqr(SL: PCardinal; PsiLight: TPsiLight5; PLVals: Pointer; PLV: TPPaintLightVals);
var bSubAmbSh, noHS, softHS: LongBool;
    ir, iL1: Integer;
    dRough, dTmp2, dAmbSh, dFog, dTmp, dTmp3: Single;
    LiLSDAI: TLightLSDAIs;
    sLiSpe, DepC: TSVec;
begin
    with TPLightVals(PLVals)^ do
    begin
      if bAmbRelObj then
        DepC := LinInterpolate2SVecs(PLValigned.sDepthCol2, PLValigned.sDepthCol, ArcSinSafe(PLV.AbsViewVec[1]) * Pi1d + s05)
      else DepC := PLV.PreDepthCol;
      if PsiLight.Zpos < 32768 then //object, not background
      begin
        calcAmbshadow(dAmbSh, sAmbShad, PsiLight);
        dAmbSh := (Sqr(dAmbSh) + dAmbSh) * s05;
        dFog := sDiffuseShadowing * (dAmbSh - 1) + 1;
        dRough := (PsiLight.RoughZposFine and $FF) * sRoughnessFactor;
        LiLSDAI[0] := MakeSVecFromNormalsD(PsiLight);
        ClearSVec(LiLSDAI[1]);
        ClearSVec(sLiSpe);
        ClearSVec(LiLSDAI[3]);
        ir := 0;
        while ir < 6 do
        begin
          if iLightOption[ir] = 0 then //light on
          begin
            bSubAmbSh := LongBool(iHScalced[ir] xor iHSenabled[ir]);
            softHS := iHSmask[ir] = -1;
            noHS := softHS or ((PsiLight.Shadow and iHSmask[ir]) = 0) or (iHScalced[ir] = 0);

            LiLSDAI[5] := PLValigned.LN[ir];
            dTmp2 := 1;
            if (iLightPos[ir] and 1) <> 0 then       //positional light
            begin
              LiLSDAI[5] := SubtractSVectors(@LiLSDAI[5], PLV.ObjPos);
              dTmp2 := SqrLengthOfSVec(LiLSDAI[5]);
              if dTmp2 > sLmaxL[ir] then
              begin
                Inc(ir);
                Continue;
              end;
              NormaliseSVectorVar(LiLSDAI[5]);
              RotateSVectorReverseS(@LiLSDAI[5], PLV.PSmatrix);
              dTmp2 := 1 / (dTmp2 + s1em30);
            end;
            dTmp := GetCosTabValSqr(iLightFuncDiff[ir], DotOfSVectors(LiLSDAI[0], LiLSDAI[5]), dRough) * dTmp2; //new spline ipol of small tab

            AddSVecWeights(@LiLSDAI[3], @PLValigned.sLCols[ir], dTmp);      //also one Dif light for 2.reflection, always no dAmbSh
            if noHS then
            begin
              if bSubAmbSh then dTmp := dTmp * dAmbSh else dTmp := dTmp * dFog;
              if softHS then dTmp := dTmp * (PsiLight.Shadow shr 10) * s1d63;
              AddSVecWeights(@LiLSDAI[1], @PLValigned.sLCols[ir], dTmp);
            end;
            dTmp := DotOf2VecNormalize(@LiLSDAI[0], @LiLSDAI[5], @PLV.ViewVec);   //specular calc
            if dTmp > 0 then
            begin
              dTmp2 := (dTmp2 + MinCS(1, dRough * 2) * (1 / iLightPowFunc[ir] - dTmp2)) * sSpec;
              if dTmp2 > 0 then
              begin
                AddSVecWeights(@LiLSDAI[3], @PLValigned.sLCols[ir], dTmp2 / iLightPowFunc[ir]);
                if noHS then
                begin
                  dTmp2 := dTmp2 * FastIntPow(dTmp, iLightPowFunc[ir]);
                  if bSubAmbSh then dTmp2 := dTmp2 * dAmbSh else dTmp2 := dTmp2 * dFog;  //*NEW*
                  if softHS then dTmp2 := dTmp2 * (PsiLight.Shadow shr 10) * s1d63;
                  AddSVecWeights(@sLiSpe, @PLValigned.sLCols[ir], dTmp2);
                end;
              end;
            end;
          end
          else if iLightOption[ir] = 2 then     //lightmaps:
          begin
            LiLSDAI[4] := LinInterpolate2SVecs(LLightMaps[ir].LMavrgColSqr, ScaleSVector(
              GetLightMapPixelSphere(LiLSDAI[0], @LLightMaps[ir].PicRotMatrix, LLightMaps[ir], True), s255), dRough);
            AddSVecWeights(@LiLSDAI[3], @LiLSDAI[4], 1);
            AddSVecWeights(@LiLSDAI[1], @LiLSDAI[4], dAmbSh);
          end;
          Inc(ir);
        end;
        bSubAmbSh := PsiLight.SIgradient > 32767;    //in bulb      obj color   is: _bIsInterior_

        LiLSDAI[2][0] := sColZmul * PLV.zPos;
        if bSubAmbSh then CalcColorsInside(@LiLSDAI[2], @LiLSDAI[5], PsiLight, PLVals)
                     else CalcColors(@LiLSDAI[2], @LiLSDAI[5], PsiLight, PLVals);
        if iColOnOT > 1 then //diffmap
        begin
          if bYCcomb then LiLSDAI[4] := LiLSDAI[2];  //backup for y-c combi
          if iColOnOT > 3 then
          begin
            if iColOnOT > 5 then
              LiLSDAI[2] := GetDiffMapWrap3D(PLVals, @LiLSDAI[0], PLV)
            else
              LiLSDAI[2] := GetLightMapPixelSphere(LiLSDAI[0], @DiffColLightMap.PicRotMatrix, DiffColLightMap, True);//DiffMap on normals
            LiLSDAI[2] := Add2SVecsWeight(LiLSDAI[2], DiffColLightMap.LMavrgCol, 1 - dRough, dRough * s1d255);
          end else begin
            dTmp := (PsiLight.OTrap and $7FFF) * 3.05186851e-5 - 0.5;  //because it was calculated as arctan2:2pi * 5215
            dTmp2 := PsiLight.SIgradient * 3.05186851e-5 - 0.5;
            LiLSDAI[2] := GetLightMapPixel(Frac((DCLMapRotCos * dTmp + DCLMapRotSin * dTmp2 + DCLMapOffX) * lvMapScale),
              Frac((DCLMapRotCos * dTmp2 - DCLMapRotSin * dTmp + DCLMapOffY) * lvMapScale), DiffColLightMap, True, 1);
          end;
          if bYCcomb then
            LiLSDAI[2] := ScaleSVector(LiLSDAI[4], YofSVec(@LiLSDAI[2]) / (s001 + YofSVec(@LiLSDAI[4])));
        end;

        if bUseSmallBGpicForAmb then
        begin
          RotateSVectorS(@LiLSDAI[0], PLV.PSmatrix);
          LiLSDAI[4] := ScaleSVector(GetLightMapPixelSphere(LiLSDAI[0], @BGsmallLM.PicRotMatrix, BGsmallLM, True), s255);
          dTmp := Max0S(1 - Max0S(1 - 28000 * sDepth)); //Add depC col
          if bFarFog then dTmp := Sqr(dTmp);
          if bAddBGlight then AddSVecWeight(@LiLSDAI[4], @DepC, dTmp)
                         else LiLSDAI[4] := LinInterpolate2SVecs(LiLSDAI[4], DepC, 1 - dTmp);
          ScaleSVectorV(@LiLSDAI[4], dAmbSh);
        end
        else
        begin
          if bAmbRelObj then                              //rotate normals, calc only y component
            LiLSDAI[0][1] := LiLSDAI[0][0] * PLV.PSmatrix[0,1] + LiLSDAI[0][1] * PLV.PSmatrix[1,1] + LiLSDAI[0][2] * PLV.PSmatrix[2,1];  //   lns[1] = y normals
          dTmp2 := (LiLSDAI[0][1] * s05 + s05) * dAmbSh;  //Yvec of normals
          dTmp  := dAmbSh - dTmp2;
          LiLSDAI[4] := Add2SVecsWeight(PLValigned.sAmbCol, PLValigned.sAmbCol2, dTmp, dTmp2);
        end;
        MultiplySVectorsV(@LiLSDAI[4], @LiLSDAI[2]);  //amb light top/bot  ..todo: add depC (+dFog) before

        LiLSDAI[0] := ScaleSVector(LiLSDAI[2], sDiff);   //diff object color scaled
        LiLSDAI[1] := Add3SVectors(LiLSDAI[4], MultiplySVectors(LiLSDAI[0], LiLSDAI[1]), MultiplySVectors(LiLSDAI[5], sLiSpe));  //total obj light, already decreased by AmbSh

        if iExModes = 0 then CalcTotalLight1(@LiLSDAI, PLVals, @dAmbSh)
                        else CalcTotalLight2(@LiLSDAI, PLVals, @dAmbSh);

        dTmp := Max0S((Integer(PsiLight.Zpos) - 28000) * sDepth + 1);
      end
      else
      begin
        if bBackBMP then  //background bmp
        begin
          if bDirectImageCoord then
            LiLSDAI[4] := ScaleSVector(GetLightMapPixel(PLV.xPos, PLV.yPos, BGLightMap, True, 0), s255)
          else
            LiLSDAI[4] := ScaleSVector(GetLightMapPixelSphere(PLV.AbsViewVec, @BGLightMap.PicRotMatrix, BGLightMap, True), s255);
        end
        else LiLSDAI[4] := DepC;
        dTmp := Max0S(1 - 28000 * sDepth);  //Zpos = 0
      end;
      if dTmp < 1 then //for depthfog
      begin
        dTmp := Sqr(1 - dTmp);
        if bFarFog then dTmp := Sqr(dTmp);
        dTmp := 1 - dTmp;
      end;
      if (PsiLight.Zpos < 32768) or (not bBackBMP) or (not bAddBGlight) then
        ScaleSVectorV(@LiLSDAI[4], dTmp);

      if bVolLight then ir := ConvertVLight(PsiLight.Shadow) else ir := PsiLight.Shadow and $3FF;
      dFog := (ir - sShad - sShadZmul * PLV.zPos) * sShadGr;
      if (bDFogOptions and 2) <> 0 then dFog := Max0S(dFog);
      dTmp3 := MinCS(1, ir * sDynFogMul) * dFog;
      LiLSDAI[4] := Add2SVecsWeight2(LiLSDAI[4], DepC, Max0S(1 - dTmp));
      if (bDFogOptions and 1) <> 0 then
      begin
        Clamp01Svar(dFog);
        Clamp01Svar(dTmp3);
        ScaleSVectorV(@LiLSDAI[4], 1 - dFog);
      end;
      AddSVectors(@LiLSDAI[4], Add2SVecsWeight(PLValigned.sDynFogCol, PLValigned.sDynFogCol2, dFog - dTmp3, dTmp3));

      iL1 := PsiLight.Zpos;
      if iL1 < 32768 then iL1 := 32768 - iL1;  // zpos for dynfog descaler
      dRough := 1 / iL1;

      //Visible lights
      for ir := 0 to 5 do if (iLightPos[ir] and 14) <> 0 then // bit1: posLight  bit2+3: visLsource func (0:0,4:1,6:2:,2:3)
      begin
        noHS := (iLightPos[ir] and 1) <> 0;
        if noHS then  //poslight
       //   dTmp3 := SqrDistSV(SubtractSVectors(@PLValigned.LN[ir], PLV.ObjPos), PLV.AbsViewVec)
          dTmp3 := SqrDistSV(SubtractSVectors(@PLV.CamPos, PLValigned.LN[ir]), PLV.AbsViewVec)
        else
        begin    //vis global light
          if PsiLight.Zpos < 32768 then Continue else bSubAmbSh := False;
          dTmp3 := Max0S(1 - DotOfSVectors(PLValigned.LN[ir], PLV.ViewVec));
        end;
        LiLSDAI[2][0] := sLmaxL[ir] * 1e-8;
        if dTmp3 < LiLSDAI[2][0] then
        begin
          if noHS then  //poslight
          begin   //proof if light is behind viewer
            if DotOfSVectors(SubtractSVectors(@PLValigned.LN[ir], PLV.CamPos), PLV.AbsViewVec) < 0 then Continue;
            if PsiLight^.Zpos > 32767 then bSubAmbSh := False else
            begin
              LiLSDAI[2][1] := -Sqrt(LiLSDAI[2][0] - dTmp3);
              if Abs(PLV.AbsViewVec[0]) > s05 then     //proof if light is behind object
                bSubAmbSh := LiLSDAI[2][1] > (PLV.ObjPos[0] - PLValigned.LN[ir][0]) / PLV.AbsViewVec[0]
              else
              if Abs(PLV.AbsViewVec[1]) > s05 then
                bSubAmbSh := LiLSDAI[2][1] > (PLV.ObjPos[1] - PLValigned.LN[ir][1]) / PLV.AbsViewVec[1]
              else
                bSubAmbSh := LiLSDAI[2][1] > (PLV.ObjPos[2] - PLValigned.LN[ir][2]) / PLV.AbsViewVec[2];
            end;
          end;
          if bSubAmbSh then Continue;                //todo: lightrays with light x,y pos

          CalcPosLightShape(dTmp3, LiLSDAI[2][0], ir, PLVals);

          LiLSDAI[2][2] := 1 - Max0S(1 + (sPosLP[ir] - 28000) * sDepth);             //amount at lightpos for depthfog calculation
          if LiLSDAI[2][2] > 0 then
          begin
            LiLSDAI[2][2] := Sqr(LiLSDAI[2][2]);
            if bFarFog then LiLSDAI[2][2] := Sqr(LiLSDAI[2][2]);
          end;
          dTmp3 := dTmp3 * (1 - LiLSDAI[2][2] * 0.9);  //decrease vislight with depth

          if (iLightPos[ir] and 14) in [2, 8] then //vislight3, don't decrease light behind, just descale vislight
            LiLSDAI[4] := Add2SVecsWeight2(LiLSDAI[4], PLValigned.sLCols[ir], dTmp3)
          else
          begin
            LiLSDAI[2][2] := Max0S(LiLSDAI[2][2]);
            if bVolLight then iL1 := ConvertVLight(PsiLight.Shadow) else iL1 := PsiLight.Shadow and $3FF;
            dFog := (iL1 * (32768 - sPosLP[ir]) * dRough - sShad -
              sShadZmul * (sPosLightZpos[ir] + sZZstmitDif)) * sShadGr * (1 - LiLSDAI[2][0]) * (1 - LiLSDAI[2][2]);
            dAmbsh := MinCS(1, iL1 * (32768 - sPosLP[ir]) * dRough * sDynFogMul) * dFog;  //dynFog @lightpos
            LiLSDAI[4] := Add3SVectors(Add2SVecsWeight(LiLSDAI[4], DepC, LiLSDAI[2][0], LiLSDAI[2][2] * (1 - LiLSDAI[2][0])),
                    Add2SVecsWeight(PLValigned.sDynFogCol, PLValigned.sDynFogCol2, dFog - dAmbsh, dAmbsh),
                    ScaleSVector(PLValigned.sLCols[ir], dTmp3));
          end;
        end;
      end;
      LiLSDAI[4][3] := 0;
      LiLSDAI[0] := mSqrtSVec(mMinMaxSVec(0, 65025, ScaleSVector(LiLSDAI[4], s255)));
      if iGammaH <> 0 then
      begin
        if iGammaH > 0 then LiLSDAI[5] := mSqrtSVec(ScaleSVector(LiLSDAI[0], 255))
                       else LiLSDAI[5] := SqrSV255(LiLSDAI[0]);
        LiLSDAI[0] := LinInterpolate2SVecs(LiLSDAI[5], LiLSDAI[0], sGamma);
      end;
      SL^ := (Round(LiLSDAI[0][0]) shl 16) or (Round(LiLSDAI[0][1]) shl 8) or Round(LiLSDAI[0][2]);
    end;
end;

function CalcPixelColorSvec(SVcol: TPSVec; var InSD: TLightSD; PsiLight: TPsiLight5; PLVals: Pointer; PLV: TPPaintLightVals): TSVec;  //get back the spec color
var bSubAmbSh, noHS, softHS: LongBool;
    ir, iL1: Integer;
    dRough, dTmp2, dAmbSh, dFog, dTmp, dTmp3: Single;
    LiLSDAI: TLightLSDAIs;  //replaces lns, sLiDif, iDif, LiAmb, iAmb, iSpe
    DepC, sLiSpe: TSVec;
begin
    with TPLightVals(PLVals)^ do
    begin
      if bAmbRelObj then
        DepC := LinInterpolate2SVecs(PLValigned.sDepthCol2, PLValigned.sDepthCol, ArcSinSafe(PLV.AbsViewVec[1]) * Pi1d + s05)
      else DepC := PLV.PreDepthCol;
      Result := cSVec1;
      if PsiLight.Zpos < 32768 then //object, not background
      begin
        calcAmbshadow(dAmbSh, sAmbShad, PsiLight);
        if bCalcPixColSqr then dAmbSh := Sqr(dAmbSh);
        dFog := sDiffuseShadowing * (dAmbSh - 1) + 1;
        dRough := (PsiLight.RoughZposFine and $FF) * sRoughnessFactor;
        LiLSDAI[0] := MakeSVecFromNormalsD(PsiLight);
        ClearSVec(LiLSDAI[1]);
        ClearSVec(sLiSpe);
        ClearSVec(LiLSDAI[3]);
        ir := 0;
        while ir < 6 do
        begin
          if iLightOption[ir] = 0 then //light on
          begin
            bSubAmbSh := LongBool(iHScalced[ir] xor iHSenabled[ir]);
            softHS := iHSmask[ir] = -1;
            noHS := softHS or ((PsiLight.Shadow and iHSmask[ir]) = 0) or (iHScalced[ir] = 0);

            LiLSDAI[5] := PLValigned.LN[ir];
            dTmp2 := 1;
            if (iLightPos[ir] and 1) <> 0 then       //positional light
            begin
              LiLSDAI[5] := SubtractSVectors(@LiLSDAI[5], PLV.ObjPos);
              dTmp2 := SqrLengthOfSVec(LiLSDAI[5]);// + sADDdistance * 0.2); //for spec less decrease
              if dTmp2 > sLmaxL[ir] then
              begin
                Inc(ir);
                Continue;
              end;
              NormaliseSVectorVar(LiLSDAI[5]);
              RotateSVectorReverseS(@LiLSDAI[5], PLV.PSmatrix);
              dTmp2 := 1 / (dTmp2 + s1em30);
            end;
            if bCalcPixColSqr then dTmp := GetCosTabValSqr(iLightFuncDiff[ir], DotOfSVectors(LiLSDAI[0], LiLSDAI[5]), dRough) * dTmp2
            else dTmp := GetCosTabVal(iLightFuncDiff[ir], DotOfSVectors(LiLSDAI[0], LiLSDAI[5]), dRough) * dTmp2;
            AddSVecWeights(@LiLSDAI[3], @PLValigned.sLCols[ir], dTmp);      //also one Dif light for 2.reflection, always no dAmbSh
            if noHS then
            begin
              if bSubAmbSh then dTmp := dTmp * dAmbSh else dTmp := dTmp * dFog;
              if softHS then dTmp := dTmp * (PsiLight.Shadow shr 10) * s1d63;
              AddSVecWeights(@LiLSDAI[1], @PLValigned.sLCols[ir], dTmp);
            end;
            dTmp := DotOf2VecNormalize(@LiLSDAI[0], @LiLSDAI[5], @PLV.ViewVec);   //specular calc
            if dTmp > 0 then
            begin
              dTmp2 := (dTmp2 + MinCS(1, dRough * 2) * (1 / iLightPowFunc[ir] - dTmp2)) * sSpec;
              if dTmp2 > 0 then
              begin
                AddSVecWeights(@LiLSDAI[3], @PLValigned.sLCols[ir], dTmp2 / iLightPowFunc[ir]);
                if noHS then
                begin
                  dTmp2 := dTmp2 * FastIntPow(dTmp, iLightPowFunc[ir]);
                  if bSubAmbSh then dTmp2 := dTmp2 * dAmbSh else dTmp2 := dTmp2 * dFog;
                  if softHS then dTmp2 := dTmp2 * (PsiLight.Shadow shr 10) * s1d63;
                  AddSVecWeights(@sLiSpe, @PLValigned.sLCols[ir], dTmp2);
                end;
              end;
            end;
          end
          else if iLightOption[ir] = 2 then     //lightmaps:
          begin
            LiLSDAI[4] := ScaleSVector(GetLightMapPixelSphere(LiLSDAI[0], @LLightMaps[ir].PicRotMatrix, LLightMaps[ir], bCalcPixColSqr), s255);
            if bCalcPixColSqr then
              LiLSDAI[4] := LinInterpolate2SVecs(LLightMaps[ir].LMavrgColSqr, LiLSDAI[4], dRough)
            else
              LiLSDAI[4] := LinInterpolate2SVecs(LLightMaps[ir].LMavrgCol, LiLSDAI[4], dRough);
            AddSVecWeights(@LiLSDAI[3], @LiLSDAI[4], 1);
            AddSVecWeights(@LiLSDAI[1], @LiLSDAI[4], dAmbSh);
          end;
          Inc(ir);
        end;
        bSubAmbSh := PsiLight.SIgradient > 32767;    //in bulb      obj color   is: _bIsInterior_

        LiLSDAI[2][0] := sColZmul * PLV.zPos;
        if bSubAmbSh then CalcColorsInside(@LiLSDAI[2], @LiLSDAI[5], PsiLight, PLVals)
        else CalcColors(@LiLSDAI[2], @LiLSDAI[5], PsiLight, PLVals);
        if iColOnOT > 1 then //diffmap
        begin
          if bYCcomb then LiLSDAI[4] := LiLSDAI[2];  //backup for y-c combi
          if iColOnOT > 3 then
          begin
            if iColOnOT > 5 then
              LiLSDAI[2] := GetDiffMapWrap3D(PLVals, @LiLSDAI[0], PLV)
            else
              LiLSDAI[2] := GetLightMapPixelSphere(LiLSDAI[0], @DiffColLightMap.PicRotMatrix, DiffColLightMap, bCalcPixColSqr);//DiffMap on normals
            LiLSDAI[2] := Add2SVecsWeight(LiLSDAI[2], DiffColLightMap.LMavrgCol, 1 - dRough, dRough * s1d255);
          end else begin
            dTmp := (PsiLight.OTrap and $7FFF) * 3.05186851e-5 - 0.5;  //because it was calculated as arctan2:2pi * 5215
            dTmp2 := PsiLight.SIgradient * 3.05186851e-5 - 0.5;
            LiLSDAI[2] := GetLightMapPixel(Frac((DCLMapRotCos * dTmp + DCLMapRotSin * dTmp2 + DCLMapOffX) * lvMapScale),
              Frac((DCLMapRotCos * dTmp2 - DCLMapRotSin * dTmp + DCLMapOffY) * lvMapScale), DiffColLightMap, bCalcPixColSqr, 1);
          end;
          if bYCcomb then
            LiLSDAI[2] := ScaleSVector(LiLSDAI[4], YofSVec(@LiLSDAI[2]) / (s001 + YofSVec(@LiLSDAI[4])));
        end;
        InSD[0] := LiLSDAI[5];
        InSD[1] := LiLSDAI[2];

        if bScaleAmbDiffDown then
        begin
          dTmp := 1 - InSD[0][3] * SRLightAmount;
          dAmbSh := dAmbSh * dTmp;
          dTmp3 := sDiff * dTmp;
        end
        else dTmp3 := sDiff;

        if bUseSmallBGpicForAmb then
        begin
          RotateSVectorS(@LiLSDAI[0], PLV.PSmatrix);
          LiLSDAI[4] := ScaleSVector(GetLightMapPixelSphere(LiLSDAI[0], @BGsmallLM.PicRotMatrix, BGsmallLM, bCalcPixColSqr), s255);
          dTmp := Max0S(1 - Max0S(1 - 28000 * sDepth)); //Add depC col
          if bFarFog then dTmp := Sqr(dTmp);
          if bAddBGlight then AddSVecWeight(@LiLSDAI[4], @DepC, dTmp)
                         else LiLSDAI[4] := LinInterpolate2SVecs(LiLSDAI[4], DepC, 1 - dTmp);
          ScaleSVectorV(@LiLSDAI[4], dAmbSh);
        end
        else
        begin
          if bAmbRelObj then
            LiLSDAI[0][1] := LiLSDAI[0][0] * PLV.PSmatrix[0,1] + LiLSDAI[0][1] * PLV.PSmatrix[1,1] + LiLSDAI[0][2] * PLV.PSmatrix[2,1];  //   lns[1] = y normals
          dTmp2 := (LiLSDAI[0][1] * s05 + s05) * dAmbSh;
          dTmp  := dAmbSh - dTmp2;
          LiLSDAI[4] := Add2SVecsWeight(PLValigned.sAmbCol, PLValigned.sAmbCol2, dTmp, dTmp2);
        end;
        MultiplySVectorsV(@LiLSDAI[4], @LiLSDAI[2]);  //amb light top/bot  ..todo: add depC (+dFog) before
{        if bAmbRelObj then
          LiLSDAI[0][1] := LiLSDAI[0][0] * PLV.PSmatrix^[0,1] + LiLSDAI[0][1] * PLV.PSmatrix^[1,1] + LiLSDAI[0][2] * PLV.PSmatrix^[2,1];  //   lns[1] = y normals
        dTmp2 := (LiLSDAI[0][1] * s05 + s05) * dAmbSh;
        dTmp  := dAmbSh - dTmp2;
        LiLSDAI[4] := MultiplySVectors(AddSVectors(ScaleSVector(PLValigned.sAmbCol, dTmp), ScaleSVector(PLValigned.sAmbCol2, dTmp2)), LiLSDAI[2]);  //amb light top/bot
   }     LiLSDAI[0] := ScaleSVector(LiLSDAI[2], dTmp3);   //diff object color scaled
        LiLSDAI[1] := AddSVectors(LiLSDAI[4], AddSVectors(MultiplySVectors(LiLSDAI[0], LiLSDAI[1]),
          MultiplySVectors(LiLSDAI[5], sLiSpe)));  //total obj light, already decreased by AmbSh
        if iExModes = 0 then CalcTotalLight1(@LiLSDAI, PLVals, @dAmbSh)
                        else CalcTotalLight2(@LiLSDAI, PLVals, @dAmbSh);
     {   if bCalcPixColSqr then dTmp := dAmbSh * 0.1 else dTmp := dAmbSh * 0.3;
        LiAmb := Add2SVecsWeight2(LiLSDAI[4], MultiplySVectors(lns, LiAmb), dTmp);
        if dAmbSh > 1 then dAmbsh := 1;
        dTmp := 1 - dAmbSh;
        dTmp2 := Sqr(Sqr(dTmp)); //amount of 2nd reflection
        dTmp := dTmp - dTmp2;
        dTmp2 := dTmp2 * sIndLightReflect;
        LiLSDAI[4] := AddSVectors(sLiDif, MultiplySVectors(LiAmb, MultiplySVectors(LiLSDAI[2], AddSVecS(ScaleSVector(LiLSDAI[2], dTmp2), dTmp))));
           }
   {     dTmp := Sqr(Max0S(1 - dAmbSh)) * sIndLightReflect;
        lns := Add2SVecsWeight2(sLiDif, MultiplySVectors(sLiDif, iDif), dTmp);
        dTmp2 := (sLiDif[0] * 0.3 + sLiDif[1] * 0.59 + sLiDif[2] * 0.11) /  (Max0S(lns[0] * 0.3 + lns[1] * 0.59 + lns[2] * 0.11) + 3);
        iAmb := ScaleSVector(lns, dTmp2 * (1 + 0.2 * dTmp));

  {     dTmp := Sqr(MaxCS(0.1, 1.1 - dAmbSh));
        lns := Add2SVecsWeight2(sLiDif, SqrSV255(sLiDif), dTmp * sIndLightReflect);
        dTmp2 := (sLiDif[0] * 0.3 + sLiDif[1] * 0.59 + sLiDif[2] * 0.11) /  (Max0S(lns[0] * 0.3 + lns[1] * 0.59 + lns[2] * 0.11) + 3);
        iAmb := ScaleSVector(lns, dTmp2 * (1 + 0.1 * dTmp * sIndLightReflect));  }

        dTmp := Max0S(1 + (Integer(PsiLight.Zpos) - 28000) * sDepth);
      end
      else
      begin
        if bBackBMP then  //background bmp
        begin
          if bDirectImageCoord then
            LiLSDAI[4] := ScaleSVector(GetLightMapPixel(PLV.xPos, PLV.yPos, BGLightMap, bCalcPixColSqr, 0), s255)
          else
            LiLSDAI[4] := ScaleSVector(GetLightMapPixelSphere(PLV.AbsViewVec, @BGLightMap.PicRotMatrix, BGLightMap, bCalcPixColSqr), s255);
        end
        else LiLSDAI[4] := DepC;
        dTmp := Max0S(1 - (60768 - Integer(PsiLight.Zpos)) * sDepth);  //works with calcSR to add only an exact amount of depthfog towards infinity!
      end;

      if dTmp < 1 then //for depthfog
      begin
        dTmp := 1 - dTmp;
        if bCalcPixColSqr then dTmp := Sqr(dTmp);
        if bFarFog then dTmp := Sqr(dTmp);
        dTmp := 1 - dTmp;
      end;
 //     if (iBGpicAndDivOptions and 1 = 0) or (not bBackBMP) or (PsiLight.Zpos < 32768) then
   //     ScaleSVectorV(@LiLSDAI[4], dTmp);
      if (PsiLight.Zpos < 32768) or (not bBackBMP) or (not bAddBGlight) then
        ScaleSVectorV(@LiLSDAI[4], dTmp);

      if bVolLight then ir := ConvertVLight(PsiLight.Shadow) else ir := PsiLight.Shadow and $3FF;
      dFog := (ir - sShad - sShadZmul * ZposDynFog) * sShadGr;
      if (bDFogOptions and 2) <> 0 then dFog := Max0S(dFog);
      dTmp3 := MinCS(1, ir * sDynFogMul) * dFog;
      LiLSDAI[4] := Add2SVecsWeight2(LiLSDAI[4], DepC, Max0S(1 - dTmp));
      if (bDFogOptions and 1) <> 0 then
      begin
        Clamp01Svar(dFog);
        Clamp01Svar(dTmp3);
        ScaleSVectorV(@LiLSDAI[4], 1 - dFog);
        ScaleSVectorV(@Result, 1 - dFog);
      end;
      AddSVectors(@LiLSDAI[4], Add2SVecsWeight(PLValigned.sDynFogCol, PLValigned.sDynFogCol2, dFog - dTmp3, dTmp3));

      ScaleSVectorV(@Result, MinCS(1, dTmp));
      iL1 := PsiLight.Zpos;
      if iL1 < 32768 then iL1 := 32768 - iL1;  // zpos for dynfog descaler
      dRough := 1 / iL1;

      //Visible lights
      for ir := 0 to 5 do if (iLightPos[ir] and 14) <> 0 then // bit1: posLight  bit2+3: visLsource func (0:0,4:1,6:2:,2:3)
      begin
        noHS := (iLightPos[ir] and 1) <> 0;
        if noHS then  //vis poslight
       //   dTmp3 := SqrDistSV(SubtractSVectors(@PLValigned.LN[ir], PLV.ObjPos), PLV.AbsViewVec)
          dTmp3 := SqrDistSV(SubtractSVectors(@PLV.CamPos, PLValigned.LN[ir]), PLV.AbsViewVec)
        else
        begin    //vis global light
          if PsiLight.Zpos < 32768 then Continue else bSubAmbSh := False;
          dTmp3 := Max0S(1 - DotOfSVectors(PLValigned.LN[ir], PLV.ViewVec));
        end;
        LiLSDAI[2][0] := sLmaxL[ir] * 1e-8;
        if dTmp3 < LiLSDAI[2][0] then
        begin
          if noHS then  //poslight
          begin   //proof if light is behind viewer
            if DotOfSVectors(SubtractSVectors(@PLValigned.LN[ir], PLV.CamPos), PLV.AbsViewVec) < 0 then Continue;
            if PsiLight.Zpos > 32767 then bSubAmbSh := False else
            begin
              LiLSDAI[2][1] := -Sqrt(LiLSDAI[2][0] - dTmp3);
              if Abs(PLV.AbsViewVec[0]) > s05 then     //proof if light is behind object
                bSubAmbSh := LiLSDAI[2][1] > (PLV.ObjPos[0] - PLValigned.LN[ir][0]) / PLV.AbsViewVec[0]
              else
              if Abs(PLV.AbsViewVec[1]) > s05 then
                bSubAmbSh := LiLSDAI[2][1] > (PLV.ObjPos[1] - PLValigned.LN[ir][1]) / PLV.AbsViewVec[1]
              else
                bSubAmbSh := LiLSDAI[2][1] > (PLV.ObjPos[2] - PLValigned.LN[ir][2]) / PLV.AbsViewVec[2];
            end;
          end;
          if bSubAmbSh then Continue;                //todo: lightrays with light x,y pos

          CalcPosLightShape(dTmp3, LiLSDAI[2][0], ir, PLVals);

        //NEW: combine iAmb with actual depthfog on the fly:
        //..scale old light with iDif[0] and add vislight+fogs@lightpos with dTmp3...
          LiLSDAI[2][2] := 1 - Max0S(1 + (sPosLP[ir] - 28000) * sDepth);             //amount at lightpos for depthfog calculation
          if LiLSDAI[2][2] > 0 then
          begin
            if bCalcPixColSqr then LiLSDAI[2][2] := Sqr(LiLSDAI[2][2]);
            if bFarFog then LiLSDAI[2][2] := Sqr(LiLSDAI[2][2]);
          end;
          dTmp3 := dTmp3 * (1 - LiLSDAI[2][2] * 0.9);  //decrease vislight with depth

          if (iLightPos[ir] and 14) in [2, 8] then //vislight3, don't decrease light behind, just descale vislight
            LiLSDAI[4] := Add2SVecsWeight2(LiLSDAI[4], PLValigned.sLCols[ir], dTmp3)
          else
          begin
            LiLSDAI[2][2] := Max0S(LiLSDAI[2][2]);
            if bVolLight then iL1 := ConvertVLight(PsiLight.Shadow) else iL1 := PsiLight.Shadow and $3FF;
            dFog := (iL1 * (32768 - sPosLP[ir]) * dRough - sShad -
              sShadZmul * (sPosLightZpos[ir] + sZZstmitDif)) * sShadGr * (1 - LiLSDAI[2][0]) * (1 - LiLSDAI[2][2]);
            dAmbsh := MinCS(1, iL1 * (32768 - sPosLP[ir]) * dRough * sDynFogMul) * dFog;  //dynFog @lightpos
            LiLSDAI[4] := Add3SVectors(Add2SVecsWeight(LiLSDAI[4], DepC, LiLSDAI[2][0], LiLSDAI[2][2] * (1 - LiLSDAI[2][0])),
                    Add2SVecsWeight(PLValigned.sDynFogCol, PLValigned.sDynFogCol2, dFog - dAmbsh, dAmbsh),
                    ScaleSVector(PLValigned.sLCols[ir], dTmp3));
          end;
          ScaleSVectorV(@Result, MinCS(1, LiLSDAI[2][0]));  //descale with hidden by visposlights
        end;
      end;
      LiLSDAI[4][3] := 0;
      SVcol^ := mMinMaxSVec(0, 8, ScaleSVector(LiLSDAI[4], s1d255));
    end;
end;

function CalcPixelColorSvecTrans(SVcol: TPSVec; var InSD: TLightSD; PsiLight: TPsiLight5; PLVals: Pointer; PLV: TPPaintLightVals): TSVec;  //get back the diffuse color
var bSubAmbSh, noHS, softHS: LongBool;
    ir, iL1: Integer;
    dRough, dTmp2, dAmbSh, dFog, dTmp, dTmp3: Single;
    LiLSDAI: TLightLSDAIs;
    DepC, sLiSpe, DiffOut: TSVec;//  iBGpicAndDivOptions and 4                PsiLight.Zpos + sAbsorpCoeff
begin                       //needs _bTransIsInside_ to calc diffuse power of _raylength_ for absorption instead of depth
    with TPLightVals(PLVals)^ do
    begin
      if bAmbRelObj then
        DepC := LinInterpolate2SVecs(PLValigned.sDepthCol2, PLValigned.sDepthCol, ArcSinSafe(PLV.AbsViewVec[1]) * Pi1d + s05)
      else DepC := PLV.PreDepthCol;
      Result := cSVec1;
      if PsiLight.Zpos < 32768 then //object, not background
      begin
        calcAmbshadow(dAmbSh, sAmbShad, PsiLight);
        if bCalcPixColSqr then dAmbSh := Sqr(dAmbSh);
        dFog := sDiffuseShadowing * (dAmbSh - 1) + 1;
        dRough := (PsiLight.RoughZposFine and $FF) * sRoughnessFactor;
        LiLSDAI[0] := MakeSVecFromNormalsD(PsiLight);
        ClearSVec(LiLSDAI[1]);
        ClearSVec(sLiSpe);
        ClearSVec(LiLSDAI[3]);
        ir := 0;
        while ir < 6 do
        begin
          if iLightOption[ir] = 0 then //light on
          begin
            bSubAmbSh := LongBool(iHScalced[ir] xor iHSenabled[ir]);
            softHS := iHSmask[ir] = -1;
            noHS := softHS or ((PsiLight.Shadow and iHSmask[ir]) = 0) or (iHScalced[ir] = 0);
            LiLSDAI[5] := PLValigned.LN[ir];
            dTmp2 := 1;
            if (iLightPos[ir] and 1) <> 0 then       //positional light
            begin
              LiLSDAI[5] := SubtractSVectors(@LiLSDAI[5], PLV.ObjPos);
              dTmp2 := SqrLengthOfSVec(LiLSDAI[5]);// + sADDdistance * 0.2); //for spec less decrease
              if dTmp2 > sLmaxL[ir] then
              begin
                Inc(ir);
                Continue;
              end;
              NormaliseSVectorVar(LiLSDAI[5]);
              RotateSVectorReverseS(@LiLSDAI[5], PLV.PSmatrix);
              dTmp2 := 1 / (dTmp2 + s1em30);
            end;
            if bCalcPixColSqr then dTmp := GetCosTabValSqr(iLightFuncDiff[ir], DotOfSVectors(LiLSDAI[0], LiLSDAI[5]), dRough) * dTmp2
            else dTmp := GetCosTabVal(iLightFuncDiff[ir], DotOfSVectors(LiLSDAI[0], LiLSDAI[5]), dRough) * dTmp2;
            AddSVecWeights(@LiLSDAI[3], @PLValigned.sLCols[ir], dTmp);      //also one Dif light for 2.reflection, always no dAmbSh
            if noHS then
            begin
              if bSubAmbSh then dTmp := dTmp * dAmbSh else dTmp := dTmp * dFog;
              if softHS then dTmp := dTmp * (PsiLight.Shadow shr 10) * s1d63;
              AddSVecWeights(@LiLSDAI[1], @PLValigned.sLCols[ir], dTmp);
            end;
            dTmp := DotOf2VecNormalize(@LiLSDAI[0], @LiLSDAI[5], @PLV.ViewVec);   //specular calc
            if dTmp > 0 then
            begin
              dTmp2 := (dTmp2 + MinCS(1, dRough * 2) * (1 / iLightPowFunc[ir] - dTmp2)) * sSpec;
              if dTmp2 > 0 then
              begin
                AddSVecWeights(@LiLSDAI[3], @PLValigned.sLCols[ir], dTmp2 / iLightPowFunc[ir]);
                if noHS then
                begin
                  dTmp2 := dTmp2 * FastIntPow(dTmp, iLightPowFunc[ir]);
                  if bSubAmbSh then dTmp2 := dTmp2 * dAmbSh else dTmp2 := dTmp2 * dFog;
                  if softHS then dTmp2 := dTmp2 * (PsiLight.Shadow shr 10) * s1d63;
                  AddSVecWeights(@sLiSpe, @PLValigned.sLCols[ir], dTmp2);
                end;
              end;
            end;
          end
          else if iLightOption[ir] = 2 then     //lightmaps:
          begin
            LiLSDAI[4] := ScaleSVector(GetLightMapPixelSphere(LiLSDAI[0], @LLightMaps[ir].PicRotMatrix, LLightMaps[ir], bCalcPixColSqr), s255);
            if bCalcPixColSqr then
              LiLSDAI[4] := LinInterpolate2SVecs(LLightMaps[ir].LMavrgColSqr, LiLSDAI[4], dRough)
            else
              LiLSDAI[4] := LinInterpolate2SVecs(LLightMaps[ir].LMavrgCol, LiLSDAI[4], dRough);
            AddSVecWeights(@LiLSDAI[3], @LiLSDAI[4], 1);
            AddSVecWeights(@LiLSDAI[1], @LiLSDAI[4], dAmbSh);
          end;
          Inc(ir);
        end;
        bSubAmbSh := PsiLight.SIgradient > 32767;    //in bulb      obj color   is: _bIsInterior_

        LiLSDAI[2][0] := sColZmul * PLV.zPos;
        if bSubAmbSh then CalcColorsInside(@LiLSDAI[2], @LiLSDAI[5], PsiLight, PLVals)
        else CalcColors(@LiLSDAI[2], @LiLSDAI[5], PsiLight, PLVals);
        if iColOnOT > 1 then //diffmap
        begin
          if bYCcomb then LiLSDAI[4] := LiLSDAI[2];  //backup for y-c combi
          if iColOnOT > 3 then
          begin
            if iColOnOT > 5 then
              LiLSDAI[2] := GetDiffMapWrap3D(PLVals, @LiLSDAI[0], PLV)
            else
              LiLSDAI[2] := GetLightMapPixelSphere(LiLSDAI[0], @DiffColLightMap.PicRotMatrix, DiffColLightMap, bCalcPixColSqr);//DiffMap on normals
            LiLSDAI[2] := Add2SVecsWeight(LiLSDAI[2], DiffColLightMap.LMavrgCol, 1 - dRough, dRough * s1d255);
          end else begin
            dTmp := (PsiLight.OTrap and $7FFF) * 3.05186851e-5 - s05;  //because it was calculated as arctan2:2pi * 5215
            dTmp2 := PsiLight.SIgradient * 3.05186851e-5 - s05;
            LiLSDAI[2] := GetLightMapPixel(Frac((DCLMapRotCos * dTmp + DCLMapRotSin * dTmp2 + DCLMapOffX) * lvMapScale),
              Frac((DCLMapRotCos * dTmp2 - DCLMapRotSin * dTmp + DCLMapOffY) * lvMapScale), DiffColLightMap, bCalcPixColSqr, 1);
          end;
          if bYCcomb then
            LiLSDAI[2] := ScaleSVector(LiLSDAI[4], YofSVec(@LiLSDAI[2]) / (s001 + YofSVec(@LiLSDAI[4])));
        end;
        DiffOut := LiLSDAI[2]; //0..1
        InSD[0] := LiLSDAI[5]; //0..1 now

        if bScaleAmbDiffDown then
        begin
          dTmp := 1 - InSD[0][3] * SRLightAmount;
          dAmbSh := dAmbSh * dTmp;
          dTmp3 := sDiff * dTmp;
        end
        else dTmp3 := sDiff;

        if bUseSmallBGpicForAmb then
        begin
          RotateSVectorS(@LiLSDAI[0], PLV.PSmatrix);
          LiLSDAI[4] := ScaleSVector(GetLightMapPixelSphere(LiLSDAI[0], @BGsmallLM.PicRotMatrix, BGsmallLM, bCalcPixColSqr), s255);
          dTmp := Max0S(1 - Max0S(1 - 28000 * sDepth)); //Add depC col
          if bFarFog then dTmp := Sqr(dTmp);
          if bAddBGlight then AddSVecWeight(@LiLSDAI[4], @DepC, dTmp)
                         else LiLSDAI[4] := LinInterpolate2SVecs(LiLSDAI[4], DepC, 1 - dTmp);
          ScaleSVectorV(@LiLSDAI[4], dAmbSh);
        end
        else
        begin
          if bAmbRelObj then
            LiLSDAI[0][1] := LiLSDAI[0][0] * PLV.PSmatrix[0,1] + LiLSDAI[0][1] * PLV.PSmatrix[1,1] + LiLSDAI[0][2] * PLV.PSmatrix[2,1];  //   lns[1] = y normals
          dTmp2 := (LiLSDAI[0][1] * s05 + s05) * dAmbSh;
          dTmp  := dAmbSh - dTmp2;
          LiLSDAI[4] := Add2SVecsWeight(PLValigned.sAmbCol, PLValigned.sAmbCol2, dTmp, dTmp2);
        end;
        MultiplySVectorsV(@LiLSDAI[4], @LiLSDAI[2]);  //amb light top/bot  ..todo: add depC (+dFog) before
    {    if bAmbRelObj then
          LiLSDAI[0][1] := LiLSDAI[0][0] * PLV.PSmatrix^[0,1] + LiLSDAI[0][1] * PLV.PSmatrix^[1,1] + LiLSDAI[0][2] * PLV.PSmatrix^[2,1];  //   lns[1] = y normals
        dTmp2 := (LiLSDAI[0][1] * s05 + s05) * dAmbSh;
        dTmp  := dAmbSh - dTmp2;
        LiLSDAI[4] := MultiplySVectors(AddSVectors(ScaleSVector(PLValigned.sAmbCol, dTmp), ScaleSVector(PLValigned.sAmbCol2, dTmp2)), LiLSDAI[2]);  //amb light top/bot
   }     LiLSDAI[0] := ScaleSVector(LiLSDAI[2], dTmp3);   //diff object color scaled
        LiLSDAI[1] := AddSVectors(LiLSDAI[4], AddSVectors(MultiplySVectors(LiLSDAI[0], LiLSDAI[1]),
          MultiplySVectors(LiLSDAI[5], sLiSpe)));  //total obj light, already decreased by AmbSh
        if iExModes = 0 then CalcTotalLight1(@LiLSDAI, PLVals, @dAmbSh)
                        else CalcTotalLight2(@LiLSDAI, PLVals, @dAmbSh);
        dTmp := Max0S(1 + (Integer(PsiLight.Zpos) - 28000) * sDepth);
      end
      else
      begin
        if bBackBMP then  //background bmp
        begin
          if bDirectImageCoord then
            LiLSDAI[4] := ScaleSVector(GetLightMapPixel(PLV.xPos, PLV.yPos, BGLightMap, bCalcPixColSqr, 0), s255)
          else
            LiLSDAI[4] := ScaleSVector(GetLightMapPixelSphere(PLV.AbsViewVec, @BGLightMap.PicRotMatrix, BGLightMap, bCalcPixColSqr), s255);
        end
        else LiLSDAI[4] := DepC;
        dTmp := Max0S(1 - (60768 - Integer(PsiLight.Zpos)) * sDepth);  //works with calcSR to add only an exact amount of depthfog towards infinity!
      end;

      if bDivOptions = 0 then  //only if not inside transp material
      begin
        if dTmp < 1 then //for depthfog
        begin
          dTmp := 1 - dTmp;
          if bCalcPixColSqr then dTmp := Sqr(dTmp);
          if bFarFog then dTmp := Sqr(dTmp);
          dTmp := 1 - dTmp;
        end;
        if (PsiLight.Zpos < 32768) or (not bBackBMP) or (not bAddBGlight) then
          ScaleSVectorV(@LiLSDAI[4], dTmp);

        if bVolLight then ir := ConvertVLight(PsiLight.Shadow) else ir := PsiLight.Shadow and $3FF;
        dFog := (ir - sShad - sShadZmul * ZposDynFog) * sShadGr;
        if (bDFogOptions and 2) <> 0 then dFog := Max0S(dFog);
        dTmp3 := MinCS(1, ir * sDynFogMul) * dFog;
        LiLSDAI[4] := Add2SVecsWeight2(LiLSDAI[4], DepC, Max0S(1 - dTmp));
        if (bDFogOptions and 1) <> 0 then
        begin
          Clamp01Svar(dFog);
          Clamp01Svar(dTmp3);
          ScaleSVectorV(@LiLSDAI[4], 1 - dFog);
          ScaleSVectorV(@Result, 1 - dFog);
        end;
        AddSVectors(@LiLSDAI[4], Add2SVecsWeight(PLValigned.sDynFogCol, PLValigned.sDynFogCol2, dFog - dTmp3, dTmp3));
        ScaleSVectorV(@Result, MinCS(1, dTmp));
      end;

      iL1 := PsiLight.Zpos;
      if iL1 < 32768 then iL1 := 32768 - iL1;  // zpos for dynfog descaler
      dRough := 1 / iL1;

      //Visible lights
      for ir := 0 to 5 do if (iLightPos[ir] and 14) <> 0 then // bit1: posLight  bit2+3: visLsource func (0:0,4:1,6:2:,2:3)
      begin
        noHS := (iLightPos[ir] and 1) <> 0;
        if noHS then  //vis poslight
       //   dTmp3 := SqrDistSV(SubtractSVectors(@PLValigned.LN[ir], PLV.ObjPos), PLV.AbsViewVec)
          dTmp3 := SqrDistSV(SubtractSVectors(@PLV.CamPos, PLValigned.LN[ir]), PLV.AbsViewVec)
        else
        begin    //vis global light
          if PsiLight.Zpos < 32768 then Continue else bSubAmbSh := False;
          dTmp3 := Max0S(1 - DotOfSVectors(PLValigned.LN[ir], PLV.ViewVec));
        end;
        LiLSDAI[2][0] := sLmaxL[ir] * 1e-8;
        if dTmp3 < LiLSDAI[2][0] then
        begin
          if noHS then  //poslight
          begin   //proof if light is behind viewer
            if DotOfSVectors(SubtractSVectors(@PLValigned.LN[ir], PLV.CamPos), PLV.AbsViewVec) < 0 then Continue;
            if PsiLight.Zpos > 32767 then bSubAmbSh := False else
            begin
              LiLSDAI[2][1] := -Sqrt(LiLSDAI[2][0] - dTmp3);
              if Abs(PLV.AbsViewVec[0]) > s05 then     //proof if light is behind object
                bSubAmbSh := LiLSDAI[2][1] > (PLV.ObjPos[0] - PLValigned.LN[ir][0]) / PLV.AbsViewVec[0]
              else
              if Abs(PLV.AbsViewVec[1]) > s05 then
                bSubAmbSh := LiLSDAI[2][1] > (PLV.ObjPos[1] - PLValigned.LN[ir][1]) / PLV.AbsViewVec[1]
              else
                bSubAmbSh := LiLSDAI[2][1] > (PLV.ObjPos[2] - PLValigned.LN[ir][2]) / PLV.AbsViewVec[2];
            end;
          end;
          if bSubAmbSh then Continue;                //todo: lightrays with light x,y pos

          CalcPosLightShape(dTmp3, LiLSDAI[2][0], ir, PLVals);

        //NEW: combine iAmb with actual depthfog on the fly:
        //..scale old light with iDif[0] and add vislight+fogs@lightpos with dTmp3...
          if bDivOptions <> 0 then //downscale light by power of raylength of diffuse color of raystart, diffuse at raystart as input
          begin
            dTmp := 1 - Max0S(1 + (sPosLP[ir] - 28000) * sDepth);
            LiLSDAI[4] := AddSVectors(LiLSDAI[4], MultiplySVectors(SVecPow(inSD[1], dTmp * sAbsorpCoeff), ScaleSVector(PLValigned.sLCols[ir], dTmp3)));
          end
          else
          begin
            LiLSDAI[2][2] := 1 - Max0S(1 + (sPosLP[ir] - 28000) * sDepth);  //amount at lightpos for depthfog calculation
            if LiLSDAI[2][2] > 0 then
            begin
              if bCalcPixColSqr then LiLSDAI[2][2] := Sqr(LiLSDAI[2][2]);
              if bFarFog then LiLSDAI[2][2] := Sqr(LiLSDAI[2][2]);
            end;
            dTmp3 := dTmp3 * (1 - LiLSDAI[2][2] * 0.9);  //decrease vislight with depth
            if (iLightPos[ir] and 14) in [2, 8] then //vislight3, don't decrease light behind, just descale vislight
              LiLSDAI[4] := Add2SVecsWeight2(LiLSDAI[4], PLValigned.sLCols[ir], dTmp3)
            else
            begin
              LiLSDAI[2][2] := Max0S(LiLSDAI[2][2]);
              if bVolLight then iL1 := ConvertVLight(PsiLight.Shadow) else iL1 := PsiLight.Shadow and $3FF;
              dFog := (iL1 * (32768 - sPosLP[ir]) * dRough - sShad -
                sShadZmul * (sPosLightZpos[ir] + sZZstmitDif)) * sShadGr * (1 - LiLSDAI[2][0]) * (1 - LiLSDAI[2][2]);
              dAmbsh := MinCS(1, iL1 * (32768 - sPosLP[ir]) * dRough * sDynFogMul) * dFog;  //dynFog @lightpos
              LiLSDAI[4] := Add3SVectors(Add2SVecsWeight(LiLSDAI[4], DepC, LiLSDAI[2][0], LiLSDAI[2][2] * (1 - LiLSDAI[2][0])),
                      Add2SVecsWeight(PLValigned.sDynFogCol, PLValigned.sDynFogCol2, dFog - dAmbsh, dAmbsh),
                      ScaleSVector(PLValigned.sLCols[ir], dTmp3));
            end;
          end;
          ScaleSVectorV(@Result, MinCS(1, LiLSDAI[2][0]));  //descale with hidden by visposlights
        end;
      end;
      LiLSDAI[4][3] := 0;
      SVcol^ := mMinMaxSVec(0, 8, ScaleSVector(LiLSDAI[4], s1d255));
      InSD[1] := DiffOut;
    end;
end;

procedure PreCalcDepthCol(Dfunc: Integer; PLV: TPPaintLightVals; PLValigned: TPLValigned);
var s: Single;
begin
    with PLV^ do
    begin
      if Dfunc = 1 then s := Sqr(Ypos) else
      if Dfunc = 0 then s := Ypos else s := Sqrt(Ypos);
      PreDepthCol := LinInterpolate2SVecs(PLValigned.sDepthCol2, PLValigned.sDepthCol, s);
    end;
end;

function NextFreePRThread: Integer;
var i: Integer;
begin
    Result := -1;
    for i := 0 to 15 do if PaintRowsTActive[i] = 0 then
    begin
      Result := i;
      Break;
    end;
end;

function ActivePRThreads: Integer;
var i: Integer;
begin
    Result := 0;
    for i := 0 to 15 do if PaintRowsTActive[i] > 0 then Inc(Result);
end;

procedure AddSPos(var SPos, SPosPlus: TSVec);
begin
    SPos[0] := SPos[0] + SPosPlus[0];
    SPos[1] := SPos[1] + SPosPlus[1];
    SPos[2] := SPos[2] + SPosPlus[2];
end;

procedure AddSPosY(var SPos, SPosPlus: TSVec; const Step: Integer);
begin
    SPos[0] := SPos[0] + SPosPlus[0] * Step;
    SPos[1] := SPos[1] + SPosPlus[1] * Step;
    SPos[2] := SPos[2] + SPosPlus[2] * Step;
end;
                        //    eax    edx                 ecx              ebp+8
function AddSVecWeight(const SPos, SPosPlus: TSVec; const Step: Integer): TSVec; //math3d:  procedure AddSVecWeight(V1, V2: TPSVec; W: Double);
{begin
    Result[0] := Spos[0] + SPosPlus[0] * Step;
    Result[1] := Spos[1] + SPosPlus[1] * Step;
    Result[2] := Spos[2] + SPosPlus[2] * Step;  }
asm
    push ecx
    push ebx
    mov  ebx, [ebp + 8]
    mov  [ebp - 4], ecx
    fld  dword [edx]
    fld  dword [edx + 4]
    fld  dword [edx + 8]
    fild dword [ebp - 4]
    fmul st(3), st
    fmul st(2), st
    fmulp
    fadd dword [eax + 8]
    fstp dword [ebx + 8]
    fadd dword [eax + 4]
    fstp dword [ebx + 4]
    fadd dword [eax]
    fstp dword [ebx]
    pop  ebx
    pop  ecx
end;

{procedure FillPLVconstants(PLV: TPPaintLightVals);
begin
    with PLV^ do
    begin
      s1 := 1.0;
      s2 := 0.00392156862745098;
      s3 := 0.01;
      s4 := -8191.0;
      s5 := 0.5;
      s255 := 255.0;
      s1em30 := 1e-30;
      d3 := 3.0518509476e-5;
    end;
end; }

procedure PaintRowsNoThreadBlocky(StartRow, EndRow: Integer);
var x, y, x2, y2, wid, hei, Dfunc, Xplus, Yplus: Integer;
    PC, PC2: PCardinal;
    PSL: TPsiLight5;
    PLV: TPaintLightVals;
    aspect, sFOV, wid1d: Single;
    d: Double;
    SPosX, SPosY, SPosXadd, SPosYadd, SPosYstart: TSVec;
    PaintParameter: TPaintParameter;
begin
  with Mand3DForm do
  begin
    if not SizeOK(False) then Exit;
    GetPaintTileSizes(@MHeader, wid, hei, Xplus, Yplus);
    EndRow := Min(EndRow, hei - 1);
    PaintParameter.ppPaintHeight := hei;
    if MHeader.bPlanarOptic = 2 then sFOV := Pi else
      sFOV := MHeader.dFOVy * Pid180;
    if (wid > 15) and (wid < 32767) then
    begin
      Dfunc := MHeader.Light.TBoptions shr 30; // 2:dfunc=2 1:dfunc=0
      wid1d := 1 / MHeader.Width;
      CalcStepWidth(@MHeader);
      PaintVGrads := NormaliseMatrixTo(MHeader.dStepWidth, @MHeader.hVGrads);
      PaintParameter.ppWidth  := MHeader.Width;
      PaintParameter.ppHeight := MHeader.Height;
      PaintParameter.ppYinc   := 1;
      PaintParameter.PLVals   := @HeaderLightVals;
      PaintParameter.pVgrads  := @PaintVGrads;
      PaintParameter.sFOVy    := sFOV;
      PaintParameter.ppXOff   := CalcXoff(@MHeader);
      CalcPPZvals(MHeader, PaintParameter.Zcorr, PaintParameter.ZcMul, PaintParameter.ZZstmitDif);
      PaintParameter.StepWidth := MHeader.dStepWidth;
      PaintParameter.ppPlanarOptic := MHeader.bPlanarOptic and 3;
      d := MinMaxCD(s001, sFOV * s05, 1.5);
      PaintParameter.ppPlOpticZ := Cos(d) * d / Sin(d);
      if PaintParameter.ppPlanarOptic = 2 then aspect := 2 else
        aspect := wid / hei;
      GetStartSPosAndAddVecs(PLV, PaintParameter, SPosYstart, SPosYadd, SPosXadd);
      y := StartRow;
      while y <= EndRow do
      begin
        SPosY := AddSVecWeight(SPosYstart, SPosYadd, Yplus + y + 3);
        PSL := @siLight5[(y + 3) * wid + 3];
        PLV.yPos := (y + Yplus + 3) / MHeader.Height;
        PC := PCardinal(mFSIstart + mFSIoffset * (y + 3) + 12);
        PreCalcDepthCol(Dfunc, @PLV, HeaderLightVals.PLValigned);
        x := 3;
        while x < wid do
        begin
          if PLV.iPlanarOptic = 2 then SPosX := SPosYstart else
            SPosX := AddSVecWeight(SPosY, SPosXadd, Xplus + x);
          PLV.xPos := (x + Xplus) * wid1d;
          CalcViewVec(@PLV, aspect);
          CalcObjPos(PLV, PaintParameter, PSL, @SPosX);
          HeaderLightVals.lvCalcPixelcolor(PC, PSL, @HeaderLightVals, @PLV);
          for y2 := y to Min(y + 7, hei - 1) do     //copy PC from [0,0] to 8x8 block:
          begin
            PC2 := PCardinal(mFSIstart + mFSIoffset * y2 + x * 4 - 12);
            for x2 := x - 3 to Min(x + 4, wid - 1) do
            begin
              PC2^ := PC^;
              Inc(PC2);
            end;
          end;
          Inc(PSL, 8);
          Inc(PC, 8);
          Inc(x, 8);
        end;
        Inc(y, 8);
      end;
    end;
    UpdateScaledImage(StartRow div ImageScale, EndRow div ImageScale);
  end;
end;

procedure PaintRowsNoThread(StartRow, EndRow: Integer);
var x, y, wid, Dfunc: Integer;
    PC: PCardinal;
    PSL: TPsiLight5;
    PSLstart, PLoffset, Yplus, Xplus: Integer;
    PLV: TPaintLightVals;
    aspect, sFOV, wid1d: Single;
    d: Double;
    SPosX, SPosY, SPosXadd, SPosYadd, SPosYstart: TSVec;
    PaintParameter: TPaintParameter;
begin
  with Mand3DForm do
  begin
    if not SizeOK(False) then Exit;
    StartRow := Max(0, StartRow);
 {   if StartRow = 0 then
    begin
      PaintVGrads := NormaliseMatrixTo(MHeader.dStepWidth, @MHeader.hVGrads);
    end; }
    GetPaintTileSizes(@MHeader, wid, PaintParameter.ppPaintHeight, Xplus, Yplus);
    EndRow := Min(EndRow, PaintParameter.ppPaintHeight - 1);
    if MHeader.bPlanarOptic = 2 then sFOV := Pi else
      sFOV := MHeader.dFOVy * Pid180;
    if (wid > 15) and (wid < 32767) then
    begin
      Dfunc := HeaderLightVals.iDfunc; //-> $101  100:dfunc=2 1:dfunc=0
      CalcStepWidth(@MHeader);
      PaintVGrads := NormaliseMatrixTo(MHeader.dStepWidth, @MHeader.hVGrads);
      PaintParameter.ppWidth  := MHeader.Width;
      PaintParameter.ppHeight := MHeader.Height;
      PaintParameter.ppYinc   := 1;
      PaintParameter.PLVals   := @HeaderLightVals;
      PaintParameter.pVgrads  := @PaintVGrads;
      PaintParameter.sFOVy    := sFOV;
      PaintParameter.ppXOff   := CalcXoff(@MHeader);
      CalcPPZvals(MHeader, PaintParameter.Zcorr, PaintParameter.ZcMul, PaintParameter.ZZstmitDif);
      PaintParameter.StepWidth := MHeader.dStepWidth;
      PSLstart := Integer(@siLight5[0]);
      PLoffset := wid * SizeOf(TsiLight5);
      PaintParameter.ppPlanarOptic := MHeader.bPlanarOptic and 3;
      d := MinMaxCD(s001, sFOV * s05, 1.5);
      PaintParameter.ppPlOpticZ := Cos(d) * d / Sin(d);
      if PaintParameter.ppPlanarOptic = 2 then aspect := 2 else
        aspect := MHeader.Width / MHeader.Height;
      wid1d := 1 / MHeader.Width;
      GetStartSPosAndAddVecs(PLV, PaintParameter, SPosYstart, SPosYadd, SPosXadd);
      for y := StartRow to EndRow do
      begin
        SPosY := AddSVecWeight(SPosYstart, SPosYadd, Yplus + y);
        PSL := TPsiLight5(PSLstart + y * PLoffset);
        PLV.yPos := (y + Yplus) / MHeader.Height;
        PreCalcDepthCol(Dfunc, @PLV, HeaderLightVals.PLValigned);
        PC := PCardinal(mFSIstart + mFSIoffset * y);
        for x := 1 to wid do
        begin
          if PLV.iPlanarOptic = 2 then SPosX := SPosYstart else
            SPosX := AddSVecWeight(SPosY, SPosXadd, Xplus + x - 1);
          PLV.xPos := (x + Xplus) * wid1d;
          CalcViewVec(@PLV, aspect);
          CalcObjPos(PLV, PaintParameter, PSL, @SPosX);
          HeaderLightVals.lvCalcPixelcolor(PC, PSL, @HeaderLightVals, @PLV);
          Inc(PSL);
          Inc(PC);
        end;
      end;
    end;
    UpdateScaledImage(StartRow div ImageScale, EndRow div ImageScale);
  end;
end;

procedure PaintRows(StartRow, EndRow: Integer);
var PaintRowThread: TPaintRowsThread;
    i, j: Integer;
    d: Double;
begin
  with Mand3DForm do
  begin
    j := 100;
    repeat
      i := NextFreePRThread;
      if i < 0 then Delay(100);
      Dec(j);
    until (i >= 0) or (j = 0);
    if (i < 0) or not SizeOK(False) then Exit;
    StartRow := Max(0, StartRow);
    if StartRow < 1 then
    begin
      CalcStepWidth(@MHeader);
      PaintVGrads := NormaliseMatrixTo(MHeader.dStepWidth, @MHeader.hVGrads);
    end;
    PaintRowThread := TPaintRowsThread.Create(True);
    PaintRowThread.iThreadID := i;
    PaintRowThread.iStartRow := StartRow;
    with PaintRowThread.PaintParameter do
    begin
      ppMessageHwnd := Handle;
      ppYinc  := 1;
      PLVals  := @HeaderLightVals; //can change when HS calculation starts?!!
      pVgrads := @PaintVGrads;
      ppXOff  := CalcXoff(@MHeader);
      ppPlanarOptic := MHeader.bPlanarOptic and 3;
      if ppPlanarOptic = 2 then sFOVy := Pi else
        sFOVy := MHeader.dFOVy * Pid180;
      d := MinMaxCD(s001, sFOVy * s05, 1.5);
      ppPlOpticZ := Cos(d) * d / Sin(d);
      CalcPPZvals(MHeader, Zcorr, ZcMul, ZZstmitDif);
      StepWidth := MHeader.dStepWidth;
      ppLocalCounter := RepaintCounter;
      pPsiLight := @siLight5[0];
      ppWidth   := MHeader.Width;
      ppHeight  := MHeader.Height;
      GetPaintTileSizes(@MHeader, ppPaintWidth, ppPaintHeight, ppXplus, ppYplus);
      PaintRowThread.iEndRow := Min(EndRow, ppPaintHeight - 1);
      ppPLoffset := ppPaintWidth * SizeOf(TsiLight5);
    end;
    PaintRowThread.FreeOnTerminate := True;     //must be noticeable if still working..? local PRowThreadcounter?
    PaintRowsTActive[i] := 1;
    PaintRowThread.Start;
  end;
end;

procedure PaintRect(R: TRect);
var PaintRectThread: TPaintRectThread;
    i, j: Integer;
    d: Double;
begin
  with Mand3DForm do
  begin
    j := 100;
    repeat
      i := NextFreePRThread;
      if i < 0 then Delay(100);
      Dec(j);
    until (i >= 0) or (j = 0);
    if (i < 0) or not SizeOK(False) then Exit;
    CalcStepWidth(@MHeader);
    PaintVGrads := NormaliseMatrixTo(MHeader.dStepWidth, @MHeader.hVGrads);
    PaintRectThread := TPaintRectThread.Create(True);
    PaintRectThread.iThreadID := i;
    with PaintRectThread.PaintParameter do
    begin
      ppMessageHwnd := Handle;
      ppYinc  := 1;
      PLVals  := @HeaderLightVals; //can change when HS calculation starts?!!
      pVgrads := @PaintVGrads;
      ppXOff  := CalcXoff(@MHeader);
      ppPlanarOptic := MHeader.bPlanarOptic and 3;
      if ppPlanarOptic = 2 then sFOVy := Pi else
        sFOVy := MHeader.dFOVy * Pid180;
      d := MinMaxCD(s001, sFOVy * s05, 1.5);
      ppPlOpticZ := Cos(d) * d / Sin(d);
      CalcPPZvals(MHeader, Zcorr, ZcMul, ZZstmitDif);
      StepWidth := MHeader.dStepWidth;
      ppLocalCounter := RepaintCounter;
      pPsiLight := @siLight5[0];
      ppWidth   := MHeader.Width;
      ppHeight  := MHeader.Height;
      GetPaintTileSizes(@MHeader, ppPaintWidth, ppPaintHeight, ppXplus, ppYplus);
      PaintRectThread.PaintRect := Rect(Max(0, R.Left), Max(0, R.Top),
        Min(R.Right, ppPaintWidth - 1), Min(R.Bottom, ppPaintHeight - 1));
      ppPLoffset := ppPaintWidth * SizeOf(TsiLight5);
    end;
    PaintRectThread.FreeOnTerminate := True;
    PaintRowsTActive[i] := 1;
    PaintRectThread.Start;
  end;
end;

procedure PaintMC(MCparas: TPMandHeader10);
var MCPaintThread: TPaintThreadMC;
begin
  //  MCForm.Label14.Caption := IntToStr(Round(MCPTtime));  //test
    if MCThreadActive <> 0 then Exit;
    MCPaintThread := TPaintThreadMC.Create(True);
    with MCPaintThread.PaintParameter do
    begin
      pMessageHwnd := MCForm.Handle;
      pLocalCounter := MCRepaintCounter;
      pPsiLight := @MCForm.siLightMC[0];
      pSLstart := Integer(MCForm.Image1.Picture.Bitmap.ScanLine[0]);
      pSLoffset := Integer(MCForm.Image1.Picture.Bitmap.ScanLine[1]) - pSLstart;
      pWidth := MCparas.Width;
      pHeight := MCparas.Height;
      pPLoffset := pWidth * SizeOf(TMCrecord);
      pSContrast := Sqr(MCparas.MCcontrast * d1d256 + s05); //0.25..2.24
      defCol := ColorToRGB(MCForm.Image1.Canvas.Brush.Color);
      pSoftClip := (MCparas.MCoptions and 1) <> 0;  //softclip
      pSaturation := (MCparas.bMCSaturation and $7F) / 32;
      pIgamma := (MCparas.Light.TBoptions shr 21) and $FC;
      if pSoftClip then
      begin
        pIgamma := Max(0, pIgamma - 20);
        pSContrast := pSContrast * 1.1; //1.2 rgb
      end;
      pSGamma := 1;
      if pIgamma > 128 then
      begin
        pSGamma := (pIGamma - 128) / 127;
        pIgamma := 1;
      end
      else if pIGamma < 128 then
      begin
        pSGamma := 1 - pIGamma / 128;
        pIGamma := -1;
      end
      else pIGamma := 0;
    end;
    MCPaintThread.FreeOnTerminate := True;
    MCThreadActive := 1;
    MCPaintThread.Start;
end;

{ TPaintRowsThread }

procedure TPaintRowsThread.Execute;
var x, y, Dfunc: Integer;
    PsiLight: TPsiLight5;
    PSL: PCardinal;
    PLV: TPaintLightVals;
    SPosX, SPosY, SPosXadd, SPosYadd, SPosYstart: TSVec;
    aspect: Single;
    dWid: Double;
begin
    with PaintParameter do
    try
      Dfunc := PLVals.iDfunc;
      GetStartSPosAndAddVecs(PLV, PaintParameter, SPosYstart, SPosYadd, SPosXadd);
      dWid := 1 / ppWidth;
      if ppPlanarOptic = 2 then aspect := 2 else aspect := ppWidth / ppHeight;
      y := iStartRow;
      while (y <= iEndRow) and (RepaintCounter = ppLocalCounter) do
      begin
        SPosY := AddSVecWeight(SPosYstart, SPosYadd, ppYplus + y);
        PLV.yPos := (y + ppYplus) / ppHeight;
        PreCalcDepthCol(Dfunc, @PLV, PLVals.PLValigned);
        PSL      := PCardinal(mFSIstart + mFSIoffset * y);
        PsiLight := TPsiLight5(Integer(pPsiLight) + ppPLoffset * y);
        for x := 1 to ppPaintWidth do
        begin
          if ppPlanarOptic = 2 then SPosX := SPosYstart else
            SPosX := AddSVecWeight(SPosY, SPosXadd, ppXplus + x - 1);
          PLV.xPos := (x + ppXplus) * dWid;
          CalcViewVec(@PLV, aspect);
          CalcObjPos(PLV, PaintParameter, PsiLight, @SPosX);
          if RepaintCounter <> ppLocalCounter then Break;
          PLVals.lvCalcPixelcolor(PSL, PsiLight, PLVals, @PLV);
          Inc(PSL);
          Inc(PsiLight);
        end;
        Inc(y);
      end;
    finally
      PaintRowsTActive[iThreadID] := 0;
      if RepaintCounter = ppLocalCounter then
        PostMessage(ppMessageHwnd, WM_ThreadReady, iStartRow or (iEndRow shl 16), 222);
    end;
end;

procedure TPaintRectThread.Execute;
var x, y, Dfunc, StartPL: Integer;
    PsiLight: TPsiLight5;
    PSL: PCardinal;
    PLV: TPaintLightVals;
    SPosX, SPosY, SPosXadd, SPosYadd, SPosYstart: TSVec;
    aspect: Single;
    dWid: Double;
begin
    with PaintParameter do
    try
      Dfunc := PLVals.iDfunc;
      GetStartSPosAndAddVecs(PLV, PaintParameter, SPosYstart, SPosYadd, SPosXadd);
      dWid := 1 / ppWidth;
      if ppPlanarOptic = 2 then aspect := 2 else aspect := ppWidth / ppHeight;
      StartPL := Integer(pPsiLight) + PaintRect.Left * SizeOf(TsiLight5);
      y := PaintRect.Top;
      while (y <= PaintRect.Bottom) and (RepaintCounter = ppLocalCounter) do
      begin
        SPosY := AddSVecWeight(SPosYstart, SPosYadd, ppYplus + y);
        PLV.yPos := (y + ppYplus) / ppHeight;
        PreCalcDepthCol(Dfunc, @PLV, PLVals.PLValigned);
        x := PaintRect.Left;
        PSL := PCardinal(mFSIstart + mFSIoffset * y + x shl 2);
        PsiLight := TPsiLight5(StartPL + ppPLoffset * y);
        while x <= PaintRect.Right do
        begin
          if ppPlanarOptic = 2 then SPosX := SPosYstart else
            SPosX := AddSVecWeight(SPosY, SPosXadd, ppXplus + x - 1);
          PLV.xPos := (x + ppXplus) * dWid;
          CalcViewVec(@PLV, aspect);
          CalcObjPos(PLV, PaintParameter, PsiLight, @SPosX);
          if RepaintCounter <> ppLocalCounter then Break;
          PLVals.lvCalcPixelcolor(PSL, PsiLight, PLVals, @PLV);
          Inc(PSL);
          Inc(PsiLight);
          Inc(x);
        end;
        Inc(y);
      end;
    finally
      PaintRowsTActive[iThreadID] := 0;
      if RepaintCounter = ppLocalCounter then
        PostMessage(ppMessageHwnd, WM_ThreadReady, PaintRect.Top or (PaintRect.Bottom shl 16), 222);
    end;
end;

procedure CalcViewVec(PLV: TPPaintLightVals; const sAspect: Single);
var CX, CY: Double;
begin
    with PLV^ do
    begin
      CX := (xOff - xPos) * sFOVy * sAspect;    //aspect=width/height
      CY := (yPos - 0.5) * sFOVy;
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

procedure GetStartSPosAndAddVecs(var PLV: TPaintLightVals; var PP: TPaintParameter; var StartPos, SPosYadd, SPosXadd: TSVec);
begin
    with PP do             
    begin
      if ppPlanarOptic = 2 then ClearSVec(StartPos) else
      begin
        StartPos[0] := sm05 * ppWidth * StepWidth;     // PLV.ObjPos calc
        StartPos[1] := sm05 * ppHeight * StepWidth;
      end;
      StartPos[2] := ZZstmitDif;       //ZZstmitDif = dZstart - dZmid
      StartPos[3] := 0;
      m := NormaliseMatrixToS(1, pVgrads);
      PLV.PSmatrix := @m;
      PLV.iPlanarOptic := ppPlanarOptic;
      PLV.PlOpticZ := ppPlOpticZ;
      PLV.xOff := ppXOff;
      PLV.sFOVy := sFOVy;
      RotateSVectorS(@StartPos, @m);  // translation to startpos
      SPosYadd := ScaleSVectorD(@m[1], StepWidth);
      SPosYadd[3] := 0;
      SPosXadd := ScaleSVectorD(@m[0], StepWidth);
      SPosXadd[3] := 0;
      BackDist := (Sqr(8388352 / ZcMul + 1) - 1) * StepWidth / Zcorr;
    end;
end;

procedure CalcObjPos(var PLV: TPaintLightVals; var PP: TPaintParameter; PsiLight: TPsiLight5; const SPosX: TPSVec);
var z1: Double;
begin
    with PP do
    begin
      if PsiLight.Zpos > 32767 then z1 := BackDist else
        z1 := (Sqr((8388352 - (PInteger(@PsiLight.RoughZposFine)^ shr 8)) / ZcMul + 1) - 1) * StepWidth / Zcorr;
      PLV.AbsViewVec := PLV.ViewVec;
      RotateSVectorS(@PLV.AbsViewVec, @m);
      PLV.CamPos := SPosX^;
      PLV.zPos := z1 + ZZstmitDif;
      PLV.ObjPos[0] := SPosX[0] + z1 * PLV.AbsViewVec[0];
      PLV.ObjPos[1] := SPosX[1] + z1 * PLV.AbsViewVec[1];
      PLV.ObjPos[2] := SPosX[2] + z1 * PLV.AbsViewVec[2];
      PLV.ObjPos[3] := 0;
    end;
end;

{ TPaintThread }

procedure TPaintThread.Execute;
var x, y, Dfunc: Integer;
    PsiLight: TPsiLight5;
    PSL: PCardinal;
    PLV: TPaintLightVals;
    SPosX, SPosY, SPosXadd, SPosYadd, SPosYstart: TSVec;
    aspect: Single;
    dWid: Double;
begin
    with PaintParameter do
    try
      Dfunc := PLVals.iDfunc;
      GetStartSPosAndAddVecs(PLV, PaintParameter, SPosYstart, SPosYadd, SPosXadd);
      dWid   := 1 / ppWidth;
      if ppPlanarOptic = 2 then aspect := 2 else
        aspect := ppWidth / ppHeight;
      y := ppYstart;
      while (y < ppPaintHeight) and (RepaintCounter = ppLocalCounter) do
      begin
        SPosY := AddSVecWeight(SPosYstart, SPosYadd, ppYplus + y);
        PLV.yPos := (y + ppYplus) / ppHeight;
        PreCalcDepthCol(Dfunc, @PLV, PLVals.PLValigned);
        PSL      := PCardinal(mFSIstart + mFSIoffset * y);
        PsiLight := TPsiLight5(Integer(pPsiLight) + y * ppPLoffset);
        for x := 1 to ppPaintWidth do
        begin
          if ppPlanarOptic = 2 then SPosX := SPosYstart else
            SPosX := AddSVecWeight(SPosY, SPosXadd, ppXplus + x - 1);
          PLV.xPos := (x + ppXplus) * dWid;
          CalcViewVec(@PLV, aspect);
          CalcObjPos(PLV, PaintParameter, PsiLight, @SPosX);
          if RepaintCounter <> ppLocalCounter then Break;
          PLVals.lvCalcPixelcolor(PSL, PsiLight, PLVals, @PLV);
          Inc(PSL);
          Inc(PsiLight);
        end;
        RepYact[ppThreadID] := y;
        Inc(y, ppYinc);
      end;
    finally
      Dec(RepaintCounts[ppThreadID]);// := 0; //dec?
      if RepaintCounter = ppLocalCounter then RepYact[ppThreadID] := ppHeight - 1 else RepYact[ppThreadID] := 0;
      PostMessage(ppMessageHwnd, WM_ThreadReady, 0, 3);
    end;
end;

procedure ScaleSVecHDR(sv1: TPSVec);
const s09: Single = 0.9;
{begin           //eax
    sv1[0] := sv1[0] / Sqrt(1 + Sqr(sv1[0] * s09));
    sv1[1] := sv1[1] / Sqrt(1 + Sqr(sv1[1] * s09));
    sv1[2] := sv1[2] / Sqrt(1 + Sqr(sv1[2] * s09));  //}
asm
    cmp   SupportSSE, 0
    jz    @@1
    movss  xmm0, s09
    movups xmm1, cSVec1
    shufps xmm0, xmm0, 0
    movups xmm2, dqword [eax]
    movaps xmm3, xmm2
    mulps  xmm2, xmm0
    mulps  xmm2, xmm2
    addps  xmm2, xmm1
    rsqrtps xmm2, xmm2
    mulps  xmm3, xmm2
    movups dqword [eax], xmm3
    ret
@@1:
    fld1
    fld   s09
    fld   dword [eax]
    fmul  st, st(1)
    fmul  st, st
    fadd  st, st(2)
    fsqrt
    fdivr dword [eax]
    fstp  dword [eax]
    fld   dword [eax + 4]
    fmul  st, st(1)
    fmul  st, st
    fadd  st, st(2)
    fsqrt
    fdivr dword [eax + 4]
    fstp  dword [eax + 4]
    fld   dword [eax + 8]
    fmulp
    fmul  st, st
    faddp
    fsqrt
    fdivr dword [eax + 8]
    fstp  dword [eax + 8]
end;

procedure ScaleSingleHDR(var s: Single);
const s09: Single = 0.9;
      s1: Single = 1;
asm
    cmp   SupportSSE, 0
    jz    @@1
    movss  xmm0, dword [eax]
    movss  xmm1, xmm0
    mulss  xmm0, s09
    mulss  xmm0, xmm0
    addss  xmm0, s1
    rsqrtss xmm0, xmm0
    mulss  xmm1, xmm0
    movss  dword [eax], xmm1
    ret
@@1:
    fld1                     //x := x / Sqrt(Sqr(x * 0.9) + 1);
    fld   dword [eax]
    fmul  s09
    fmul  st, st
    faddp
    fsqrt
    fdivr dword [eax]
    fstp  dword [eax]
end;

procedure ScaleSingleHDRsqr(var s: Single);
const s09: Single = 0.9;
      s1: Single = 1;
asm
    cmp   SupportSSE, 0
    jz    @@1
    movss  xmm0, dword [eax]
    mulss  xmm0, xmm0
    movss  xmm1, xmm0
    mulss  xmm0, s09
    mulss  xmm0, xmm0
    addss  xmm0, s1
    rsqrtss xmm0, xmm0
    mulss  xmm1, xmm0
    sqrtss xmm1, xmm1
    movss  dword [eax], xmm1
    ret
@@1:
    fld   dword [eax]        //x := Sqrt(x*x / Sqrt(Sqr(x*x * 0.9) + 1));
    fmul  st, st
    fld   st                 //xx,xx
    fmul  s09
    fmul  st, st
    fld1
    faddp
    fsqrt
    fdivp
    fsqrt
    fstp  dword [eax]
end;

procedure SVec2ColSSE(sv1: TPSVec; pc: PCardinal);
asm                 //  eax       edx
    add   esp, -16
    movups  xmm0, dqword [eax]
    movups  xmm1, cSVec1
    movups  xmm2, cSVec255
    xorps   xmm3, xmm3
    minps   xmm0, xmm1
    maxps   xmm0, xmm3
    mulps   xmm0, xmm2
//    cvtps2pi qword [esp], xmm0  //only lower 2 values to mmx!
    movups  [esp], xmm0
    cvtss2si eax, xmm0
    fld   dword [esp + 8]
    fistp word [edx]
    fld   dword [esp + 4]
    fistp word [edx + 1]
    mov   [edx + 2], al
    add   esp, 16
end;

  //   w := 0.4275;
  //   for y := 1 to 3 do w := w * ((w*w*w + 2*r)/(2*w*w*w + r));
  // needs 3 iterations >>15bit 4its max precision!!! halley  w0.4275 start
  //  x := Power(Max(x, sftc), s1d3) + smul * (Min(x, sftc) - sftc);
procedure LabCubicRootSSE(sv: TPSVec);
const wstart: array[0..3] of Single = (0.4275, 0.4275, 0.4275, 0.4275);
    sftc: array[0..3] of Single = (216/24389, 216/24389, 216/24389, 216/24389);
    smul: array[0..3] of Single = (841/108, 841/108, 841/108, 841/108);
asm
    movups xmm0, [eax] //r
    movaps xmm4, xmm0
    movups xmm6, sftc
    movups xmm1, wstart
    maxps  xmm4, xmm6
    movups xmm7, smul
    movaps xmm5, xmm4
    minps  xmm0, xmm6
    addps  xmm5, xmm5  //2r
    mov  edx, 3
@ll: movaps xmm2, xmm1
    mulps  xmm2, xmm2
    mulps  xmm2, xmm1  //www
    movaps xmm3, xmm2
    addps  xmm3, xmm3
    addps  xmm2, xmm5
    addps  xmm3, xmm4
    mulps  xmm1, xmm2
    divps  xmm1, xmm3
    dec  edx
    jnz  @ll
    subps  xmm0, xmm6
    mulps  xmm0, xmm7
    addps  xmm0, xmm1
    movups [eax], xmm0
end;

// for y := 1 to z do w := s4d3 * Sqrt(Sqrt(w*r)) - s1d3 * w;  //needs 3 iterations  0.0000537 w0.3661
procedure LabCubicRoot2SSE(sv: TPSVec);                                         //rsqrtps less precise!
const wstart: array[0..3] of Single = (0.3661, 0.3661, 0.3661, 0.3661);
    sftc: array[0..3] of Single = (216/24389, 216/24389, 216/24389, 216/24389);
    smul: array[0..3] of Single = (841/108, 841/108, 841/108, 841/108);
    s1d3: array[0..3] of Single = (1/3, 1/3, 1/3, 1/3);
    s4d3: array[0..3] of Single = (4/3, 4/3, 4/3, 4/3);
asm
    movups xmm0, [eax] //r
    movaps xmm4, xmm0
    movups xmm6, sftc
    movups xmm1, wstart
    movups xmm5, s4d3
    movups xmm3, s1d3
    maxps  xmm4, xmm6
    movups xmm7, smul
    minps  xmm0, xmm6
    mov  edx, 3
@ll: movaps xmm2, xmm1
    mulps  xmm1, xmm4   //w*r
    rsqrtps xmm1, xmm1
    mulps  xmm2, xmm3
    rsqrtps xmm1, xmm1
    mulps  xmm1, xmm5
    subps  xmm1, xmm2
    dec  edx
    jnz  @ll
    subps  xmm0, xmm6
    mulps  xmm0, xmm7
    addps  xmm0, xmm1
    movups [eax], xmm0
end;

procedure SVecRGB2Lab(sv1: TPSVec);
var sv: TSVec;
const sftc: Single = 216/(29*29*29);
    s4d29: Single = 4/29;
    smul: Single = 29*29/108;
begin
    sv[0] := (0.412453 * sv1[0] + 0.35758  * sv1[1] + 0.180423 * sv1[2]) * 1.052111;  // rgb->xyz  D65 whitepoint
    sv[1] := 0.212671 * sv1[0] + 0.71516  * sv1[1] + 0.072169 * sv1[2];
    sv[2] := (0.019334 * sv1[0] + 0.119193 * sv1[1] + 0.950227 * sv1[2]) * 0.918417;
    sv[3] := 0;
    if SupportSSE then LabCubicRootSSE(@sv) else
    begin
      if sv[0] > sftc then sv[0] := Power(sv[0], s1d3) else sv[0] := smul * sv[0] + s4d29;  // xyz->lab
      if sv[1] > sftc then sv[1] := Power(sv[1], s1d3) else sv[1] := smul * sv[1] + s4d29;
      if sv[2] > sftc then sv[2] := Power(sv[2], s1d3) else sv[2] := smul * sv[2] + s4d29;
    end;
    sv1[0] := 1.16 * sv[1] - 0.16;  //normed to 0..1 instead of 0..100 for lightness
    sv1[1] := sv[0] - sv[1];   //*5  no need to scale
    sv1[2] := sv[1] - sv[2];   //*2
end;

{       r := Max(w, sftc2);
       r := r*r*r;
       w := r + smul2 * (Min(w, sftc2) - sftc2);   }
procedure LabPow3SSE(sv: TPSVec);
const sftc: array[0..3] of Single = (6/29, 6/29, 6/29, 6/29);
    smul: array[0..3] of Single = (108/841, 108/841, 108/841, 108/841);
asm
    movups xmm0, [eax] //r
    movaps xmm4, xmm0
    movups xmm6, sftc
    maxps  xmm4, xmm6
    movups xmm7, smul
    movaps xmm5, xmm4
    minps  xmm0, xmm6
    mulps  xmm5, xmm5
    subps  xmm0, xmm6
    mulps  xmm5, xmm4  //rrr
    mulps  xmm0, xmm7
    addps  xmm0, xmm5
    movups [eax], xmm0
end;

procedure SVecLab2RGB(sv1: TPSVec);
var sv: TSVec;
const s1d116: Single = 1/1.16;
    sftc: Single = 6/29;
    s4d29: Single = 4/29;
    smul: Single = 108/841;
begin
    sv[1] := (sv1[0] + 0.16) * s1d116; // lab->xyz
    sv[0] := sv[1] + sv1[1];   //* 0.2
    sv[2] := sv[1] - sv1[2];   //* 0.5
    sv[3] := 0;
    if SupportSSE then LabPow3SSE(@sv) else
    begin
      if sv[0] > sftc then sv[0] := sv[0] * sv[0] * sv[0] else sv[0] := (sv[0] - s4d29) * smul;
      if sv[1] > sftc then sv[1] := sv[1] * sv[1] * sv[1] else sv[1] := (sv[1] - s4d29) * smul;
      if sv[2] > sftc then sv[2] := sv[2] * sv[2] * sv[2] else sv[2] := (sv[2] - s4d29) * smul;
    end;
    sv[0] := sv[0] * 0.95047;   //D65 whitepoint
    sv[2] := sv[2] * 1.08883;
    sv1[0] :=  3.240479 * sv[0] - 1.537150 * sv[1] - 0.498535 * sv[2];  // xyz->rgb
    sv1[1] := -0.969256 * sv[0] + 1.875992 * sv[1] + 0.041556 * sv[2];
    sv1[2] :=  0.055648 * sv[0] - 0.204043 * sv[1] + 1.057311 * sv[2];
end;

procedure TPaintThreadMC.Execute;
var x, y: Integer;
    scol, s, s2: Single;
  //  d: Double;
    PsiLight: TPMCrecord;
    PSL: PCardinal;
    sv1, sv2: TSVec;
begin
//    d := getHiQmillis;
    with PaintParameter do
    try
      sv1[3] := 0;
      sv2[3] := 0;
      for y := 0 to pHeight - 1 do
      begin
        if MCRepaintCounter <> pLocalCounter then Break;
        PsiLight := TPMCrecord(Integer(pPsiLight) + y * pPLoffset);
        PSL := PCardinal(Integer(pSLstart) + y * PSLoffset);
        x := 0;
        while x < pWidth do
        begin
          if PsiLight.RayCount <> 0 then
          begin
            sv1 := ScaleSVector(MCRGBToSVec(PsiLight), pSContrast);
            mClampSqrSVecV(@sv1);
            SVecRGB2Lab(@sv1);
            scol := pSaturation;
            if sv1[0] > 0 then
            begin
              if pIgamma <> 0 then
              begin
                s2 := sv1[0];
                if pIgamma > 0 then s := Sqrt(sv1[0]) else s := sv1[0] * sv1[0];
                sv1[0] := sv1[0] + (s - sv1[0]) * pSGamma;
                if (pIgamma > 0) and (s2 > 1) then scol := scol * sv1[0] / s2;
              end;
              if pSoftClip then
              begin
                s := sv1[0];
                ScaleSingleHDRsqr(sv1[0]);
                scol := scol * sv1[0] / s;
              end;
            end;
            sv1[1] := sv1[1] * scol;
            sv1[2] := sv1[2] * scol;
            SVecLab2RGB(@sv1);
            mClampSqrtSVecV(@sv1);
            if SupportSSE then SVec2ColSSE(@sv1, PSL) else
            begin
              sv1 := mMinMaxSVec(0, 1, sv1);
              PSL^ := (Round(sv1[0] * s255) shl 16) or (Round(sv1[1] * s255) shl 8) or Round(sv1[2] * s255);
            end;
          end
          else PSL^ := defCol;
          Inc(PSL);
          Inc(PsiLight);
          Inc(x);
          if MCRepaintCounter <> pLocalCounter then Break;
        end;
      end;
  //    if MCRepaintCounter = pLocalCounter then MCPTtime := getHiQmillis - d; //test
      MCForm.Image1.Picture.Bitmap.Modified := True;
    finally
      MCThreadActive := 0;
    end;
end;


Initialization

  for parothi := 0 to 15 do PaintRowsTActive[parothi] := 0;
  for parothi := 0 to 15 do RepaintCounts[parothi] := 0;

end.
