unit CalcSR;

//  Calculate Reflections

interface

uses
  Classes, Math3D, TypeDefinitions, Windows;

type
  TSRCalcThread = class(TThread)
  private
    { Private-Deklarationen }
    srPsiLight: TPsiLight5;
    TransDiConst: Single;
    sAbsorption: Single;
    bCalcTrans: LongBool;
    bCalcTransR: LongBool;
    bTransFlipInside: LongBool;
    bOnlyDIFS: LongBool;
    MaxReflections: Integer;
    SRLightAmount: Single;
    LVsdiff, sLightScatteringMul: Single;
    tAmb: TSVec;
    Normal: TVec3D;
    CalcRect: TRect;
    Iteration3Dext: TIteration3Dext;
    PaintParameter: TPaintParameter;
 //   procedure doBinSearchIt(var ZZ: Double; VgradsFOVit: TVec3D);
 //   procedure CalculateNormals(var NN: Single; nPsiLight: TPsiLight5);
 //   procedure CalculateNormalsOnSmoothIt(var NN: Single; nPsiLight: TPsiLight5);
    procedure minLengthToCutPlane(var dLength: Double; var cutplane: Integer; dLimit: Double; vPos: TPPos3D; Vec: TPVec3D);
  //  procedure CalcTrans(ZZ: Double; SRVec: TVec3D; Rit: Integer);  //iterative raymarching for transmission+spec
    procedure CalcRay(ZZ: Double; SRVec: TVec3D; tAbsorb: TSVec; SDsvecs: TLightSD; Rit: Integer);
    procedure CalcLightZPos;
    procedure CalcOpenAir(var siLight: TsiLight5; var SDsvecs: TLightSD; var tAbsorb: TSVec; bCalcT: LongBool; zz: Single);
    function AddLight(svDiff: TSVec): TSVec;
    procedure DoDynFog(var actDE: Double; var StepCount: Single; const RSFmul, LastStepWidth: Single);
  public
    { Public-Deklarationen }
    MCTparas: TMCTparameter;
    LVals: TLightVals;
    PLV: TPaintLightVals;
 //   tst: LongBool;
  protected
    procedure Execute; override;
  end;
function CalcSRT(Header: TPMandHeader11; PLightVals: TPLightVals; PCTS: TPCalcThreadStats;
                 PsiLight5: TPsiLight5; FSIstart, FSIoffset: Integer; CalcR: TRect): Boolean;

implementation

uses Mand, Math, DivUtils, formulas, Forms, ImageProcess, CustomFormulas,
     HeaderTrafos, LightAdjust, PaintThread, Calc, CalcAmbShadowDE, Maps;

function CalcSRT(Header: TPMandHeader11; PLightVals: TPLightVals; PCTS: TPCalcThreadStats;
                 PsiLight5: TPsiLight5; FSIstart, FSIoffset: Integer; CalcR: TRect): Boolean;
var x, ThreadCount: Integer;
    MCTparas: TMCTparameter;
    SRCalcThread: array of TSRCalcThread;
    PaintParameter: TPaintParameter;
    d: Double;
    sXoff, sRI: Single;
begin
  Result := False;
  try
    ThreadCount := Min(Mand3DForm.UpDown3.Position, Header.Height);
    MCTparas    := getMCTparasFromHeader(Header^, True);
    Result      := MCTparas.bMCTisValid;
    if Result then
    begin
      CalcHSVecsFromLights(PLightVals, @MCTparas);
      MCTparas.pSiLight  := PsiLight5;
      MCTparas.FSIstart  := FSIstart;
      MCTparas.FSIoffset := FSIoffset;
      MCTparas.PLVals    := PLightVals;
      MCTparas.PCalcThreadStats := PCTS;
 //     if MCTparas.DEoption in [20..22] then x := 10 else x := 8;
//      MCTparas.iDEAddSteps := Max(MCTparas.iDEAddSteps, x);
      SetLength(SRCalcThread, ThreadCount);
      sXoff := CalcXoff(Header);
      PLightVals.SRLightAmount := Min0MaxCS(Header.SRamount, 100);
      with PaintParameter do
      begin
        ppWidth  := Header.Width;
        ppHeight := Header.Height;
        ppYinc   := 1;
        sFOVy    := Header.dFOVy * Pid180;
        ppXOff   := sXoff;
        ppPlanarOptic := Header.bPlanarOptic and 3;
        if ppPlanarOptic = 2 then sFOVy := Pi;
        d := MinCD(1.5, MaxCD(0.01, sFOVy * s05));
        ppPlOpticZ := Cos(d) * d / Sin(d);
        CalcPPZvals(Header^, Zcorr, ZcMul, ZZstmitDif);
        StepWidth := Header.dStepWidth;
        pPsiLight := PsiLight5;
        m := NormaliseMatrixToS(1, @MCTparas.Vgrads);
      end;
    end;
  finally
  end;
  if Result then
  begin
    if not bSRVolLightMapCalculated then CalcVolLightMap(Header, PLightVals);
    bSRVolLightMapCalculated := True;
    if (PTHeaderCustomAddon(Header.PCFAddon).bOptions2 and 6) = 4 then sRI := 1
    else sRI := Header.sTRIndex;
    PCTS.ctCalcRect := CalcR;
    PCTS.cCalcTime := GetTickCount;
    MCTparas.CalcRect := CalcR;
    for x := 0 to ThreadCount - 1 do
    begin
      PCTS.CTrecords[x + 1].iActualYpos := -1;
      PCTS.CTrecords[x + 1].iActualXpos := 0;
      MCTparas.iThreadId := x + 1;
      try
        SRCalcThread[x] := TSRCalcThread.Create(True);
        AssignLightVal(@SRCalcThread[x].LVals, PLightVals);
        PaintParameter.PLVals := @SRCalcThread[x].LVals;
        MCTparas.PLVals := PaintParameter.PLVals;
        SRCalcThread[x].FreeOnTerminate := True;
        SRCalcThread[x].MCTparas        := MCTparas;
        PaintParameter.pVgrads := @SRCalcThread[x].MCTparas.VGrads;
        SRCalcThread[x].PaintParameter  := PaintParameter;
        SRCalcThread[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
        SRCalcThread[x].MaxReflections  := Header.SRreflectioncount;
        SRCalcThread[x].SRLightAmount   := PLightVals.SRLightAmount;
        SRCalcThread[x].TransDiConst    := sRI;
        SRCalcThread[x].bCalcTrans      := (Header.bCalcSRautomatic and 2) <> 0;
        SRCalcThread[x].sAbsorption     := Header.sTransmissionAbsorption * Header.dStepWidth;
        SRCalcThread[x].LVsdiff         := PLightVals.sDiff;
        SRCalcThread[x].bOnlyDIFS       := (Header.bCalcSRautomatic and 4) <> 0;
        SRCalcThread[x].sLightScatteringMul := Header.sTRscattering / 330;
        SRCalcThread[x].CalcRect        := PCTS.ctCalcRect;
        SRCalcThread[x].PLV.xOff        := sXoff;
        PCTS.CTrecords[x + 1].isActive := 1;
        PCTS.CThandles[x + 1] := SRCalcThread[x];
      except
        ThreadCount := x;
        Break;
      end;
    end;
    PCTS.HandleType := 1;
    for x := 0 to ThreadCount - 1 do SRCalcThread[x].MCTparas.iThreadCount := ThreadCount;
    PCTS.iTotalThreadCount := ThreadCount;
    for x := 0 to ThreadCount - 1 do SRCalcThread[x].Start;
  end;
end;

{TSRCalcThread}

procedure TSRCalcThread.minLengthToCutPlane(var dLength: Double; var cutplane: Integer; dLimit: Double; vPos: TPPos3D; Vec: TPVec3D);
var dTmp: Double;
begin
    with MCTparas do
    begin
      cutplane := 0;
      if iCutOptions <> 0 then
      begin
        if ((iCutOptions and 1) <> 0) and (Abs(Vec[0]) > 1e-20) then
        begin
          dTmp := (dCOX - vPos^[0]) / Vec[0];
          if (dTmp > dLimit) and (dTmp < dLength) then
          begin
            dLength := dTmp;
            cutplane := 1;
          end;
        end;
        if ((iCutOptions and 2) <> 0) and (Abs(Vec[1]) > 1e-20) then
        begin
          dTmp := (dCOY - vPos^[1]) / Vec[1];
          if (dTmp > dLimit) and (dTmp < dLength) then
          begin
            dLength := dTmp;
            cutplane := 2;
          end;
        end;
        if ((iCutOptions and 4) <> 0) and (Abs(Vec[2]) > 1e-20) then
        begin
          dTmp := (dCOZ - vPos^[2]) / Vec[2];
          if (dTmp > dLimit) and (dTmp < dLength) then
          begin
            dLength := dTmp;
            cutplane := 3;
          end;
        end;
      end;
    end;
end;

function TSRCalcThread.AddLight(svDiff: TSVec): TSVec;
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
          sv := SubtractSVectors(@PLV.ObjPos, PLV.CamPos);
          sv2 := SubtractSVectors(@PLValigned.LN[itmp], PLV.CamPos);
          sv3 := SubtractSVectors(@PLValigned.LN[itmp], PLV.ObjPos);
          stmp3 := sStepWidth * sStepWidth;
          d2 := SqrLengthOfSVec(sv2) + stmp3;
          d3 := SqrLengthOfSVec(sv3) + stmp3;
          stmp := DotOfSVectors(sv2, sv);
          if stmp <= 0 then stmp := s025 / d3 + 1 / d2 else
          begin
            stmp2 := SqrLengthOfSVec(sv);
            if stmp2 <= stmp then stmp := s025 / d2 + 1 / d3 else
            stmp := 1 / (SqrLengthOfSVec(SubtractSVectors(@PLValigned.LN[itmp],
              AddSVectors(PLV.CamPos, ScaleSVector(sv, stmp / stmp2)))) + stmp3) + s025 / MaxCS(d3, d2);
          end;
        end
        else stmp := 1;
        AddSVecWeights(@Result, @PLValigned.sLCols[itmp], stmp);
      end;
      Result := MultiplySVectors(svDiff, Result);
    end;
end;
       {   if (iLightPos[i] and 1) = 0 then //background light
          begin
            sPosLP[i] := 0;
            sPosLightZpos[i] := Header.dZend - Header.dZstart;
          end   }

procedure TSRCalcThread.CalcLightZPos;
var itmp: Integer;
    dTmp: Double;
begin
    with LVals do for itmp := 0 to 5 do
    if (iLightPos[itmp] and 1) <> 0 then  //poslights, calc Zpos
    begin
      if Abs(PLV.AbsViewVec[0]) > s05 then dTmp := (PLValigned.LN[itmp][0] - PLV.CamPos[0]) / PLV.AbsViewVec[0] else
      if Abs(PLV.AbsViewVec[1]) > s05 then dTmp := (PLValigned.LN[itmp][1] - PLV.CamPos[1]) / PLV.AbsViewVec[1]
                                      else dTmp := (PLValigned.LN[itmp][2] - PLV.CamPos[2]) / PLV.AbsViewVec[2];
      sPosLightZpos[itmp] := Max0S(dTmp);
      dTmp := 8388352 - MCTparas.ZcMul * (Sqrt(sPosLightZpos[itmp] / sStepWidth * MCTparas.Zcorr + 1) - 1);
      sPosLP[itmp] := Min0MaxCS(dTmp * d1d256, 32767);
    end;
end;

procedure TSRCalcThread.CalcOpenAir(var siLight: TsiLight5; var SDsvecs: TLightSD; var tAbsorb: TSVec; bCalcT: LongBool; zz: Single);
var dTmp, dTmp2: Double;
    tmpAmb: TSVec;
    sTmp: Single;
begin
    if (LVals.bFarFog or LVals.bCalcPixColSqr) and (Abs(LVals.sDepth) > 1e-10) then
    begin
      dTmp := 1 - Max0S(1 + (Integer(srPsiLight.Zpos) - 28000) * LVals.sDepth); //first depthfog (better max depthfog?)
      if dTmp > 0 then
      begin
        dTmp := Sqr(dTmp);
        if LVals.bFarFog and LVals.bCalcPixColSqr then dTmp := Sqr(dTmp);
      end;
      dTmp2 := 1 - Max0S(1 - 28000 * LVals.sDepth); //depthfog@inf
      if dTmp2 > 0 then
      begin
        dTmp2 := Sqr(dTmp2);
        if LVals.bFarFog and LVals.bCalcPixColSqr then dTmp2 := Sqr(dTmp2);
      end;
      dTmp := dTmp2 - dTmp; //depthFog to add...  = 1 - MaxCS(0, 1 - (60768 - Integer(PsiLight.Zpos)) * sDepth);
      if dTmp > 0 then
      begin
        dTmp := Sqrt(dTmp);
        if LVals.bFarFog and LVals.bCalcPixColSqr then dTmp := Sqrt(dTmp);
      end;
      siLight.Zpos := Round(MinMaxCS(32768, 60768 - dTmp / LVals.sDepth, 65535));
    end
    else siLight.Zpos := 32768;
    PLV.zPos := PaintParameter.BackDist + MCTparas.sZZstmitDif;
    LVals.ZposDynFog := PLV.zPos;
    LVals.bDivOptions := 0;   // inside transp or not
    if bCalcT then
    begin
      if not bTransFlipInside xor MCTparas.bInsideRendering then
      begin
   //     LVals.iBGpicAndDivOptions := LVals.iBGpicAndDivOptions or 4;
      end
      else
      begin //inside
        tmpAmb := SVecPow(SDsvecs[1], zz * sAbsorption);
        sTmp := (1 - YofSVec(@tmpAmb)) * sLightScatteringMul;
        MultiplySVectorsV(@tAbsorb, @tmpAmb);
        tAmb := Add2SVecsWeight2(tAmb, MultiplySVectors(AddLight(SDsvecs[1]), tAbsorb), sTmp);
        LVals.bDivOptions := 1;
      end;
      CalcPixelColorSvecTrans(@tmpAmb, SDsvecs, @siLight, @LVals, @PLV);
    end
    else CalcPixelColorSvec(@tmpAmb, SDsvecs, @siLight, @LVals, @PLV);
    tAmb := AddSVectors(tAmb, MultiplySVectors(tAbsorb, tmpAmb));
end;

procedure TSRCalcThread.DoDynFog(var actDE: Double; var StepCount: Single; const RSFmul, LastStepWidth: Single);
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

procedure TSRCalcThread.CalcRay(ZZ: Double; SRVec: TVec3D; tAbsorb: TSVec; SDsvecs: TLightSD; Rit: Integer);  //iterative raymarching of specularity + transmission
var itmp: Integer;
    DElimited, OpenAir, bCalcT: LongBool;
    RSFmul, sTmp, StepCount, LastZZ: Single;
    siLight: TsiLight5;
    RLastStepWidth, dTmp, dStep, ZZplus, ZZ2, RLastDE, MaxL, ZZtmp, SpecMulT: Double;
    NewVec, tmpLoc, tmpNorm: TVec3D;
    tmpAmb, tmpSpec, tmpAbsorb: TSVec;
    tmpSDsvecs: TLightSD;
    tmpPSV: TPSVec;
label lab1, lab2, lab3;
begin
    with MCTparas do
    begin
      RotateVectorReverse(@Normal, @Vgrads); //get the absolute normal vector
      if not bCalcTrans then bCalcTransR := False else
      if not bOnlyDIFS then bCalcTransR := True else
      begin
        CalcDE(@Iteration3Dext, @MCTparas);
        bCalcTransR := DEoptionResult = 20;
      end;
      bCalcT := bCalcTransR;
lab1:   //to repeat with trans off
      if PCalcThreadStats.pLBcalcStop^ or (Abs(tAbsorb[0]) * s03 + Abs(tAbsorb[1]) * s059 + Abs(tAbsorb[2]) * s011 < 1e-4) then Exit;
lab2:
      if bCalcT then   //input diffuse color for absorption as input in calcpixelcolortransp
      begin
        sTmp := MaxOfSVec(@SDsvecs[0]);
        if bTransFlipInside xor bInsideRendering then dStep := TransDiConst
                                                 else dStep := 1 / TransDiConst;
        dTmp := LengthOfVec(SRVec);
        MaxL := LengthOfVec(Normal);
        SpecMulT := -DotOfVectors(@SRVec, @Normal) / (dTmp * MaxL);
        ZZ2 := 1 - dStep * dStep * (1 - SpecMulT * SpecMulT);
        if ZZ2 <= 0 then
        begin  //total internal reflection
          //if AR coating, increase SD[0] ???
          ScaleSVectorV(@SDsvecs[0], 1 - SDsvecs[0][3] + Sqr(SDsvecs[0][3]) / (sTmp + 0.01));
          bCalcT := False;
          goto lab2;
        end;
        mCopyVec(@tmpLoc, @Iteration3Dext.C1);    //save location + normals + restore before reflection calc
        mCopyVec(@tmpNorm, @Normal);
        tmpAbsorb := tAbsorb;
        tmpSDsvecs := SDsvecs;
        ZZtmp := ZZ;

        NewVec := SubtractVectors(SRVec, ScaleVector(Normal, dTmp / (MaxL * dStep) * (Sqrt(ZZ2) - dStep * SpecMulT)));
        ScaleVectorV(@NewVec, dTmp / LengthOfVec(NewVec));

        dTmp := Abs(DotOfVectors(@NewVec, @Normal)) / (dTmp * MaxL);
        SpecMulT := Abs(SpecMulT);
        if Abs(dTmp) > 1e-16 then        //calc reflective amount, n1=1 n2=dStep
        SpecMulT := (Sqr((SpecMulT - dStep * dTmp) / (SpecMulT + dStep * dTmp)) +
                     Sqr((dTmp - dStep * SpecMulT) / (dTmp + dStep * SpecMulT))) * s05;
        ScaleSVectorV(@tAbsorb, 1 - SpecMulT * sTmp);
        bInsideRendering := not bInsideRendering;  //step in/out
        bCalcInside := not bCalcInside;
      end
      else
      begin
        NewVec := SubtractVectors(@SRVec, ScaleVector(Normal, 2 * DotOfVectors(@Normal, @SRVec) / SqrLengthOfVec(Normal)));   //fp invalid op     div0
      end;

      ZZplus := DotOfVectors(@mVgradsFOV, @NewVec) / Sqrt(SqrLengthOfVec(mVgradsFOV) * SqrLengthOfVec(NewVec) + d1em100);
      MaxL := Zend;
      itmp := 0;
      if iCutOptions <> 0 then
        minLengthToCutPlane(MaxL, itmp, 1, @Iteration3Dext.C1, @NewVec);

      LastZZ := Abs(ZZ);

      ZZ2 := MinCD(1, DEstop * s025);      // step forward an amount , reduces banding artifacts, previous direction?
      ZZ := ZZ + ZZ2 * ZZplus;
      mAddVecWeight(@Iteration3Dext.C1, @NewVec, ZZ2);

      msDEstop := DEstop * (1 + Abs(ZZ) * mctDEstopFactor);

      PLV.CamPos := DVecToSVec(SubtractVectors(@Iteration3Dext.C1, TPVec3D(@Xmit)^)); //for verifying if poslight is behind cam/viewplane
                                                                                      //+ as startpos for lightscattering inside
      OpenAir := True;
      StepCount := 0;
      DElimited := True;

      if srPsiLight.SIgradient > 32767 then ZZ2 := Zend else
      begin
        OpenAir := False;
        RSFmul := 1;
        dTmp := CalcDE(@Iteration3Dext, @MCTparas);
        RLastStepWidth := dTmp * sZstepDiv;
        if dTmp > s1em10 then
        repeat
          RLastDE := dTmp;
          if DFogOnIt = 65535 then
          begin
            dStep := dTmp;
            mZZ := Abs(ZZ);
            DoDynFog(dStep, StepCount, RSFmul, RLastStepWidth);
          end
          else
          begin
            dStep := MaxCS(s011, (dTmp - msDEsub * msDEstop) * sZstepDiv * RSFmul);
            sTmp := MaxCS(msDEstop, 0.4) * mctMH04ZSD;
            if sTmp < dStep then
            begin
              if DFogOnIt = 0 then StepCount := StepCount + sTmp / dStep else
              if Iteration3Dext.ItResultI = DFogOnIt then StepCount := StepCount + sTmp / dStep;
              dStep := sTmp;
            end
            else if DFogOnIt = 0 then StepCount := StepCount + 1 else
              if Iteration3Dext.ItResultI = DFogOnIt then StepCount := StepCount + 1;
          end;
          RLastStepWidth := dStep;
          ZZ2 := ZZ2 + dStep;
          if ZZ2 > MaxL then
          begin
            if DFogOnIt = 65535 then
            begin
              RLastStepWidth := MaxL - ZZ2 + RLastStepWidth;
              mAddVecWeight(@Iteration3Dext.C1, @NewVec, RLastStepWidth);
              DoDynFog(RLastDE, StepCount, RSFmul, RLastStepWidth);
            end;
            OpenAir := True;
            Break;
          end;
          mAddVecWeight(@Iteration3Dext.C1, @NewVec, dStep);
          ZZ := ZZ + dStep * ZZplus;
          msDEstop := DEstop * (1 + Abs(ZZ) * mctDEstopFactor);
          dTmp := CalcDE(@Iteration3Dext, @MCTparas);
          if Iteration3Dext.ItResultI >= MaxItsResult then
          begin
            DElimited := False;
            Break;
          end;
          if (dTmp < msDEstop) and (Iteration3Dext.ItResultI >= iMinIt) then Break;
       //   if dTmp < msDEstop then Break;

          //if bProofDEopt then if DEoptionResult <> DEoStarted then calc total light + new Diffuse+Spec Color  ...+ no flip in/out
                                                                       //if transp = 0 then stop + light
          if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;
          if RLastDE > dTmp + s1em10 then
          begin
            dStep := RLastStepWidth / (RLastDE - dTmp);
            if dStep < 1 then
              RSFmul := maxCS(s05, dStep)
            else
              RSFmul := 1;
            end
          else RSFmul := 1;
        until PCalcThreadStats.pLBcalcStop^;
        if PCalcThreadStats.pLBcalcStop^ then Exit;
      end;

    //  lastZZ := MaxCS(0, ZZ2); //new test

      PLV.AbsViewVec := NormaliseSVector(DVecToSVec(NewVec));
      PLV.ViewVec := PLV.AbsViewVec;
      RotateSVectorReverseS(@PLV.ViewVec, @PaintParameter.m);
      CalcLightZPos;

      with LVals do         
      begin        
        bScaleAmbDiffDown := False;
        ZposDynFog := ZZ2 * StepWidth + sZZstmitDif;

        if bAmbRelObj then tmpPSV := @PLV.AbsViewVec else tmpPSV := @PLV.ViewVec;
        PLV.ypos := ArcSinSafe(tmpPSV[1]) / FOVy + s05;  //not if rectilinear lense (just in reflections...)
        if bBackBMP then
        begin
          dTmp := FOVy / MaxCD(0.1, PiM2 - FOVy);
          if PLV.ypos > 1 then
          begin
            PLV.ypos := 1 + dTmp * (1 - PLV.ypos);
            if PLV.ypos < 0.75 then PLV.ypos := 1.5 - PLV.ypos;  //wrap twice to go to the top/bottom again, not to the middle like in xpos
          end
          else if PLV.ypos < 0 then
          begin
            PLV.ypos := Abs(PLV.ypos) * dTmp;
            if PLV.ypos > s025 then PLV.ypos := s05 - PLV.ypos;
          end;
        end;
        Clamp01Svar(PLV.ypos);

        dStep := iMandHeight / (FOVy * iMandWidth); // 1/FOVx
        PLV.xpos := ArcTan2(tmpPSV[0], tmpPSV[2]) * dStep + s05;
        if bBackBMP then
        begin
          dTmp := 1 / (dStep * MaxCD(0.1, piM2 - 1 / dStep));
          if PLV.xpos > 1 then PLV.xpos := 1 + dTmp * (1 - PLV.xpos) else
          if PLV.xpos < 0 then PLV.xpos := Abs(PLV.xpos) * dTmp;
        end;
        Clamp01Svar(PLV.xpos);

        if not bAmbRelObj then
        begin
          sTmp := PLV.ypos;
          if iDfunc = 1 then sTmp := Sqr(sTmp) else
          if iDfunc <> 0 then sTmp := Sqrt(sTmp);
          PLV.PreDepthCol := LinInterpolate2SVecs(PLValigned.sDepthCol2, PLValigned.sDepthCol, sTmp);
        end;
      end;

      if DFogOnIt = 65535 then siLight.Shadow := RMcalcVLight(StepCount) else
      begin
        if bInsideRendering then StepCount := StepCount * 200 * DEstop / iMandWidth;
        siLight.Shadow := Round(Min0MaxCS(StepCount, 1023));
      end;

      if not OpenAir then
      begin
        if iDEAddSteps <> 0 then   // binary search, not if on cutplane!
        begin
          if DElimited then
          begin
            itmp := iDEAddSteps;
         //   itmp2 := iMaxit;
          //  iMaxit := Iteration3Dext.ItResultI;
            dStep := RLastStepWidth * sm05;
            dTmp := CalcDE(@Iteration3Dext, @MCTparas);
            while Abs(dTmp - msDEstop) > 0.001 do
            begin
              ZZ2 := ZZ2 + dStep;
              ZZ := ZZ + dStep * ZZplus;
              mAddVecWeight(@Iteration3Dext.C1, @NewVec, dStep);
              msDEstop := DEstop * (1 + Abs(ZZ) * mctDEstopFactor);
              Dec(itmp);
              if itmp <= 0 then Break;
              dTmp := CalcDE(@Iteration3Dext, @MCTparas);
              if dTmp < msDEstop then dStep := Abs(dStep) * -0.55
                                 else dStep := Abs(dStep) * 0.55;
            end;
       //     iMaxit := itmp2;
          end
          else
          begin
            dStep := ZZ2;
            FlipVecs(@NewVec, @mVgradsFOV);
            RMdoBinSearchIt(@MCTparas, ZZ2);
            ZZ := ZZ + (ZZ2 - dStep) * ZZplus;
            FlipVecs(@NewVec, @mVgradsFOV);
          end;
        end;  
        mZZ := Abs(ZZ); //negative ZZ must be considered in normals, ambienbt + hs calc has own max
   //     DEOres := DEoptionResult;
     //   if NormalsOnDE then CalculateNormals(RSFmul, @siLight)
       //                else CalculateNormalsOnSmoothIt(RSFmul, @siLight);

     {   if FormulaType > 0 then  //test: step back to be on a certain side?
        begin
          dStep := 0.01;
          ZZ2 := ZZ2 + dStep;
          ZZ := ZZ + dStep * ZZplus;
          mAddVecWeight(@Iteration3Dext.C1, @NewVec, dStep);
          msDEstop := DEstop * (1 + Abs(ZZ) * mctDEstopFactor);
        end; }

        mPsiLight := @siLight;
        TCalculateNormalsFunc(pCalcNormals)(@MCTparas, RSFmul);
//        if NormalsOnDE then RMCalculateNormals(@MCTparas, RSFmul)
  //                     else RMCalculateNormalsOnSmoothIt(@MCTparas, RSFmul);
lab3:
        Normal := MakeDVecFromNormals(@siLight);

        if DElimited then RSFmul := 32767 - (RSFmul + dColPlus + mctColVarDEstopMul * ln(msDEstop * StepWidth)) * mctsM
                     else RSFmul := 32767 - RSFmul * mctsM;
        MinMaxClip15bit(RSFmul, siLight.SIgradient);
        if ColorOnIt <> 0 then RMdoColorOnIt(@MCTparas);
        RMdoColor(@MCTparas);
                                                                //biggest lastZZ 2 ??     fp error
        if LVals.bFarFog or LVals.bCalcPixColSqr then dStep := Sqrt(Sqr(ZZ2 + lastZZ) - lastZZ + s1em30)
                                                 else dStep := ZZ2;
        CalcZposAndRough(@siLight, @MCTparas, dStep);

        RSFmul := msDEstop;

        if (calcHardShadow and 1) <> 0 then //not on cut?
        begin
     //     mAddVecWeight(@Iteration3Dext.C1, @NewVec, 0.1);   newvec??? towards normals dir
          mZZ := Abs(ZZ);// + 0.1 * ZZplus);
          CalcHS(@MCTparas, @siLight, iMandHeight);
      //    mAddVecWeight(@Iteration3Dext.C1, @NewVec, -0.1);
        end;

        //modify paintLightVals with new pos and vecs + HS
           //plv.zpos for varycolonZ->must be ZZ,  and dynFog->offsetOnZ, must be ZZ2
        PLV.zPos := Abs(ZZ) * StepWidth + sZZstmitDif;
        PLV.ObjPos := DVecToSVec(SubtractVectors(@Iteration3Dext.C1, TPVec3D(@Xmit)^));

        if bCalcAmbShadow then   //and not bInside
        begin
          AOdither := 0;
          case Rit of
            1:  itmp := 2;  //DEAO quality (2 = 17rays)
            2:  itmp := 1;
          else  itmp := 0;
          end;
          mZZ := Abs(ZZ);
          CalcAmbShadowDEfor1pos(@MCTparas, @Iteration3Dext, @siLight, itmp, 0, 0);
          siLight.AmbShadow := (siLight.AmbShadow * 8) div (8 + Rit);
        end
        else siLight.AmbShadow := 5000;
        msDEstop := RSFmul;
        LVals.bDivOptions := 0;
        LVals.bScaleAmbDiffDown := bCalcTransR and (Rit < MaxReflections);

        if bCalcT then ScaleSVectorV(@tAbsorb, SDsvecs[0][3])
                  else MultiplySVectorsV(@tAbsorb, @SDsvecs[0]);

        if bTransFlipInside xor bInsideRendering then
        begin    //absorption inside material
          tmpAmb := SVecPow(SDsvecs[1], MinCD(ZZ2, MaxL) * sAbsorption);
          tmpSpec := tAbsorb;
          sTmp := (1 - YofSVec(@tmpAmb)) * sLightScatteringMul;
          MultiplySVectorsV(@tAbsorb, @tmpAmb);
          tAmb := Add2SVecsWeight2(tAmb, MultiplySVectors(AddLight(SDsvecs[1]),
                            LinInterpolate2SVecs(tAbsorb, tmpSpec, s05)), sTmp);
          LVals.bDivOptions := 1;
        end;
      //  if bCalcT then
          tmpSpec := CalcPixelColorSvecTrans(@tmpAmb, SDsvecs, @siLight, @LVals, @PLV);
      //  else tmpSpec := CalcPixelColorSvec(@tmpAmb, SDsvecs, @siLight, @LVals, @PLV);
        tAmb := AddSVectors(tAmb, MultiplySVectors(tAbsorb, tmpAmb));
        if (not bCalcT) or (not bTransFlipInside xor bInsideRendering) then
          MultiplySVectorsV(@tAbsorb, @tmpSpec);

        if Rit < MaxReflections then  //next depth of reflection
        begin
          ScaleSVectorV(@tAbsorb, SRLightAmount);
          CalcRay(ZZ, NewVec, tAbsorb, SDsvecs, Rit + 1);
        end;
      end
      else  //Open air, calc background
      begin
        siLight.Zpos := 32768;
        if bCalcT then ScaleSVectorV(@tAbsorb, SDsvecs[0][3])
                  else MultiplySVectorsV(@tAbsorb, @SDsvecs[0]);
        CalcOpenAir(siLight, SDsvecs, tAbsorb, bCalcT, MinCD(ZZ2, MaxL));
      end;
      if bCalcT then
      begin
        mCopyVec(@Iteration3Dext.C1, @tmpLoc);
        mCopyVec(@Normal, @tmpNorm);
        ZZ := ZZtmp;
        SDsvecs := tmpSDsvecs;
        tAbsorb := ScaleSVector(tmpAbsorb, SpecMulT + (1 - SpecMulT) * (1 - SDsvecs[0][3]));
        bInsideRendering := not bInsideRendering;
        bCalcInside := not bCalcInside;
        bCalcT := False;
        goto Lab1;
      end
    end;
end;

procedure TSRCalcThread.Execute;       //todo: make mctparas VGradsFOV to actual VGradsFOVit to use the RM functions 
var x, y, itmp: Integer;
    DElimited, bInsideTmp: LongBool;
    dT1, dTmp: Double;
    SDsv: TLightSD;
    sv: TSVec;
function GetZPosFromSI(iz: Integer): Double;
begin
    with MCTparas do Result := (Sqr((8388351.5 - iz) / ZcMul + 1) - 1) / Zcorr;
end;
begin
    with MCTparas do
    try
      IniIt3D(@MCTparas, @Iteration3Dext);
      bInsideTmp := bInsideRendering;
      bTransFlipInside := bInsideRendering;
      LVals.sObjLightDecreaser := MaxCS(s05, 1 - Sqrt(SRLightAmount) * 0.17);
      //test:
   {   RMrecord.PMCTparas := @MCTparas;
      RMrecord.PIt3Dex := @Iteration3Dext;
      RMrecord.StartDEstop := MCTparas.DEstop;
      RMrecord.seed := Round(Random * $324594A1 + $24563487);   }

      with PaintParameter do   //Light
      begin
     //   m := NormaliseMatrixToS(1, @Vgrads);
        PLV.PSmatrix := @PaintParameter.m;
        PLV.iPlanarOptic := ppPlanarOptic;
        PLV.PlOpticZ := ppPlOpticZ;
        BackDist := (Sqr(8388352 / ZcMul + 1) - 1) * StepWidth / Zcorr;
      end;

      y := CalcRect.Top + iThreadId - 1;
      while y <= CalcRect.Bottom do
      begin
        PCalcThreadStats.CTrecords[iThreadId].iActualYpos := y;
        srPsiLight := TPsiLight5(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset - 18);
        CAFY := (y / iMandHeight - s05) * FOVy;
        for x := CalcRect.Left to CalcRect.Right do
        begin
          Inc(srPsiLight); //here because of continue.. would be ommitted else
          PCalcThreadStats.CTrecords[iThreadId].iActualXpos := x;
          if srPsiLight.Zpos < 32768 then
          begin
            if bInAndOutside and ((srPsiLight.OTrap and $8000) <> 0) then
            begin
              bInsideRendering := False;
              bCalcInside := False;
            end
            else
            begin
              bInsideRendering := bInsideTmp;
              bCalcInside := bInsideTmp;
            end;
            RMCalculateVgradsFOV(@MCTparas, x + 1);
            RMCalculateStartPos(@MCTparas, x, y);
   //   RMrecord.VievVec := VgradsFOV;
             //Light:
            PLV.CamPos := DVecToSVec(SubtractVectors(@Iteration3Dext.C1, TPVec3D(@Xmit)^));
            PLV.AbsViewVec := NormaliseSVector(DVecToSVec(mVgradsFOV));  //-> CalcObjPos() calcs also absviewvec
            PLV.ViewVec := PLV.AbsViewVec;                              // -> calcviewvec
            RotateSVectorReverseS(@PLV.ViewVec, @PaintParameter.m);
            PLV.yPos := y / iMandHeight;
            PLV.xPos := (x + 1) / iMandWidth;
            PreCalcDepthCol(LVals.iDfunc, @PLV, LVals.PLValigned);  //only ypos needed
            CalcLightZPos;  //campos+absviewvec needed

            Iteration3Dext.CalcSIT := False;
            mZZ := GetZPosFromSI(PInteger(@srPsiLight.RoughZposFine)^ shr 8);
            mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, mZZ);     //move to zpos
            msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);

            if srPsiLight.SIgradient < 32768 then
            begin
              dTmp := CalcDE(@Iteration3Dext, @MCTparas);
              if dTmp < msDEstop * s05 then Continue;
           //   DElimited := Iteration3Dext.ItResultI < MaxItsResult;
              DElimited := (Iteration3Dext.ItResultI < MaxItsResult) or (dTmp <= msDEstop);
              if DElimited then
              begin
                dT1 := mZZ - GetZPosFromSI((PInteger(@srPsiLight.RoughZposFine)^ shr 8) - 1);
                RMdoBinSearch(@MCTparas, dTmp, dT1);
              end
              else RMdoBinSearchIt(@MCTparas, mZZ);
            end
            else
            begin  //cut
              dT1 := Zend;
              if iCutOptions <> 0 then minLengthToCutPlane(dT1, itmp, -2, @Iteration3Dext.C1, @mVgradsFOV);
              if Abs(dT1) > 1 then Continue;
              mZZ := mZZ + dT1;
              mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, dT1);
              msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
       //       CalcDE(@Iteration3Dext, @MCTparas);
            end;

            Normal := MakeDVecFromNormals(srPsiLight);  //makedvec with zero vec checking?!

            PLV.zPos := mZZ * StepWidth + sZZstmitDif;
            PLV.ObjPos := DVecToSVec(SubtractVectors(@Iteration3Dext.C1, TPVec3D(@Xmit)^));
            LVals.ZposDynFog := PLV.zPos;
         //   LVals.sAmbientScale := 1 - YofSVec(LVals.PLValigned.);   //Scale down dependend on 1 - spec color amount
            bCalcTransR := bCalcTrans and ((not bOnlyDIFS) or (DEoptionResult = 20));
            LVals.bScaleAmbDiffDown := bCalcTransR;// and (MaxReflections > 1);
            sv := ScaleSVector(CalcPixelColorSvec(@tAmb, SDsv, srPsiLight, @LVals, @PLV), SRLightAmount);
            tAmb[3] := 0;         //sv=light absorption so far
            CalcRay(mZZ, mVgradsFOV, sv, SDsv, 1);  //recursive reflection + transmission calculation
            tAmb := mMinMaxSVec(0, 1, tAmb);
            if LVals.bCalcPixColSqr then tAmb := mSqrtSVec(tAmb);

            if LVals.iGammaH <> 0 then
            begin
              if LVals.iGammaH > 0 then
                sv := mSqrtSVec(tAmb)
              else
              begin
                sv[0] := Sqr(tAmb[0]);
                sv[1] := Sqr(tAmb[1]);
                sv[2] := Sqr(tAmb[2]);
              end;
              tAmb := AddSVectors(tAmb, ScaleSVector(SubtractSVectors(@sv, tAmb), LVals.sGamma));
            end;
            PCardinal(FSIstart + FSIoffset * (y - CalcRect.Top) + (x - CalcRect.Left) * 4)^ :=
              (Round(tAmb[0] * s255) shl 16) or (Round(tAmb[1] * s255) shl 8) or Round(tAmb[2] * s255);
          end;
          if PCalcThreadStats.pLBcalcStop^ then Break;
        end;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        Inc(y, iThreadCount);
      end;
    finally
      if not PCalcThreadStats.pLBcalcStop^ then
        PCalcThreadStats.CTrecords[iThreadId].iActualYpos := iMandHeight - 1;
      PCalcThreadStats.CTrecords[iThreadId].isActive := 0;
      PostMessage(PCalcThreadStats.pMessageHwnd, WM_ThreadReady, 0, 0);
    end;
end;

end.
