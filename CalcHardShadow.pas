unit CalcHardShadow;

interface

uses
  Classes, Math3D, TypeDefinitions, Windows;

type
  THardShadowCalcThread = class(TThread)
  private
    { Private-Deklarationen }
    Iteration3Dext: TIteration3Dext;
    procedure HSminLengthToCutPlane(HVec: TPVec3D; var dLength: Double; vPos: TPPos3D);
    procedure calcHSsoft;
  public
    { Public-Deklarationen }
    MCTparas: TMCTparameter;
  protected
    procedure Execute; override;
  end;
function CalcHardShadowT(Header: TPMandHeader11; PCTS: TPCalcThreadStats; PsiLight5: TPsiLight5;
                         hSLoffset: Integer; HeaderLightVals: TPLightVals; bMain: LongBool; hRect: TRect): Boolean;
var
  HScalcHeaderLightVals: TLightVals;

implementation

uses Mand, Math, DivUtils, formulas, Forms, ImageProcess, CustomFormulas,
     HeaderTrafos, LightAdjust, Calc;

function CalcHardShadowT(Header: TPMandHeader11; PCTS: TPCalcThreadStats; PsiLight5: TPsiLight5;
                         hSLoffset: Integer; HeaderLightVals: TPLightVals; bMain: LongBool; hRect: TRect): Boolean;
var x, y, ThreadCount, bhs: Integer;
    MCTparas: TMCTparameter;
    HardShadowCalcThread: array of THardShadowCalcThread;
begin
  Result := False;
  try
    bhs := Header.bHScalculated;
    if (Header.bCalc1HSsoft and 1) <> 0 then
      Header.bHScalculated := (bhs and 1) or Header.bCalculateHardShadow
    else Header.bHScalculated := (bhs and $FD) or Header.bCalculateHardShadow;
    for x := 0 to 5 do
    begin
      y := HeaderLightVals.SortTab[x];
      HeaderLightVals.iHScalced[y] := (Header.bHScalculated shr (x + 2)) and 1;
      HeaderLightVals.iHSmask[y] := $400 shl x;
      if ((Header.bCalc1HSsoft and 1) <> 0) and (HeaderLightVals.iHScalced[y] <> 0) then HeaderLightVals.iHSmask[y] := -1;

      if ((Header.bHScalculated and 2) <> 0) and (((Header.bCalculateHardShadow shr (x + 2)) and 1) <>  0) then //set light diff function to cos
      begin
        Header.Light.Lights[x].LFunction := Header.Light.Lights[x].LFunction and $CF;
        HeaderLightVals.iLightFuncDiff[y] := 0;  //use tab for sorted lights!
        if bMain then
        begin
          Mand3DForm.HeaderLightVals.iHScalced[y] := HeaderLightVals.iHScalced[y]; //new
          Mand3DForm.HeaderLightVals.iHSmask[y] := HeaderLightVals.iHSmask[y];//new
          Mand3DForm.HeaderLightVals.iLightFuncDiff[y] := 0;  //new because calcHS has now its own lightvals!
          LightAdjustForm.LAtmpLight.Lights[x].LFunction := Header.Light.Lights[x].LFunction;
          if LightAdjustForm.TabControl1.TabIndex = x then
            LightAdjustForm.ComboBox1.ItemIndex := 0;
        end;
      end;
    end;
    ThreadCount := Min(Mand3DForm.UpDown3.Position, Header.Height);
    MCTparas := getMCTparasFromHeader(Header^, True);
    Result   := MCTparas.bMCTisValid;
    if Result then
    begin
      MCTparas.pSiLight := PsiLight5;
      MCTparas.SLoffset := hSLoffset;
      MCTparas.PLVals   := HeaderLightVals;
      MCTparas.PCalcThreadStats := PCTS;
      MCTparas.CalcRect := hRect;
      CalcHSVecsFromLights(HeaderLightVals, @MCTparas); //should be made in getmctparasfromheader and interpolated direct for ani
      SetLength(HardShadowCalcThread, ThreadCount);
    end;
  finally
  end;
  if Result then
  begin
    PCTS.ctCalcRect := hRect;
    for x := 1 to ThreadCount do
    begin
      PCTS.CTrecords[x].iActualYpos := -1;
      PCTS.CTrecords[x].iActualXpos := 0;
      MCTparas.iThreadId  := x;
      try
        HardShadowCalcThread[x - 1] := THardShadowCalcThread.Create(True);
        HardShadowCalcThread[x - 1].FreeOnTerminate := True;
        HardShadowCalcThread[x - 1].MCTparas        := MCTparas;
        HardShadowCalcThread[x - 1].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
        PCTS.CTrecords[x].isActive := 1;
        PCTS.CThandles[x] := HardShadowCalcThread[x - 1];
      except
        ThreadCount := x - 1;
        Break;
      end;
    end;
    for x := 0 to ThreadCount - 1 do HardShadowCalcThread[x].MCTparas.iThreadCount := ThreadCount;
    PCTS.HandleType := 1;
    PCTS.iTotalThreadCount := ThreadCount;
    PCTS.cCalcTime         := GetTickCount;
    for x := 0 to ThreadCount - 1 do HardShadowCalcThread[x].Start;
  end
  else Header.bHScalculated := bhs;
end;

procedure THardShadowCalcThread.HSminLengthToCutPlane(HVec: TPVec3D; var dLength: Double; vPos: TPPos3D);
var dTmp: Double;
begin
    with MCTparas do
    begin
      if ((iCutOptions and 1) <> 0) and (Abs(HVec^[0]) > 1e-20) then
      begin
        dTmp := (vPos^[0] - dCOX) / HVec^[0];
        if (dTmp > 0) and (dTmp < dLength) then dLength := dTmp;
      end;
      if ((iCutOptions and 2) <> 0) and (Abs(HVec^[1]) > 1e-20) then
      begin
        dTmp := (vPos^[1] - dCOY) / HVec^[1];
        if (dTmp > 0) and (dTmp < dLength) then dLength := dTmp;
      end;
      if ((iCutOptions and 4) <> 0) and (Abs(HVec^[2]) > 1e-20) then
      begin
        dTmp := (vPos^[2] - dCOZ) / HVec^[2];
        if (dTmp > 0) and (dTmp < dLength) then dLength := dTmp;
      end;
    end;
end;

procedure THardShadowCalcThread.calcHSsoft;
var itmp, iHSnr, x, y: Integer;
    DElimited, bInsideTmp, bisPosLight: LongBool;
    RLastStepWidth, RStepFactorDiff, MaxLHS, sT2, ZRsoft, ZRSmul: Single;
    dTmp, dT1, RLastDE, ZZ2mul, dMaxL, ZZ2: Double;
    HSVec, NVec: TVec3D;
begin
    with MCTparas do
    begin
      bInsideTmp := bInsideRendering;
      iHSnr := 0;
      for itmp := 0 to 5 do if (calcHardShadow and (4 shl itmp)) <> 0 then iHSnr := PLVals.SortTab[itmp];
      mCopyVec(@HSVec, @HSvecs[iHSnr]);
      bisPosLight := (PLVals.iLightPos[iHSnr] and 1) <> 0;
      if bisPosLight then
      begin                        //poslight scale with distance...    use also MCSoftShadowRadius?!    0.5deg ~118
        if (PLVals.iLightPos[iHSnr] and 6) = 2 then ZRSmul := 70 / SoftShadowRadius
                                               else ZRSmul := 40 / SoftShadowRadius;
      end
      else ZRSmul := 80 / SoftShadowRadius; //+ scale with y amount

      y := CalcRect.Top + iThreadId - 1;
      while y <= CalcRect.Bottom do
      begin
        PCalcThreadStats.CTrecords[iThreadId].iActualYpos := y;
        mPsiLight := TPsiLight5(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset);
        CAFY := (y / iMandHeight - 0.5) * FOVy;
        for x := CalcRect.Left to CalcRect.Right do
        begin
          PCalcThreadStats.CTrecords[iThreadId].iActualXpos := x;
          mPsiLight.Shadow := mPsiLight.Shadow or $FC00;
          if (mPsiLight.Zpos < 32768) and (mPsiLight.SIgradient < 32768) then
          begin                                            //why not on cuts?->dotprod only
            bInsideRendering := bInsideTmp;
            bCalcInside := bInsideTmp;
            RMCalculateVgradsFOV(@MCTparas, x + 1);
            RMCalculateStartPos(@MCTparas, x, y);
            mZZ := (Sqr((8388351.5 - (PInteger(@mPsiLight.RoughZposFine)^ shr 8)) / ZcMul + 1) - 1) / Zcorr;
            mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, mZZ);
            msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
            dTmp := CalcDE(@Iteration3Dext, @MCTparas);
            if bInAndOutside and ((mPsiLight.OTrap and $8000) <> 0) then
            begin
              bInsideRendering := False;
              bCalcInside := False;
              dTmp := CalcDE(@Iteration3Dext, @MCTparas);
            end;
            DElimited := (Iteration3Dext.ItResultI < MaxItsResult) or (dTmp < msDEstop);
            if DElimited then
            begin
              dT1 := (Sqr((8388351.9 - (PInteger(@mPsiLight.RoughZposFine)^ shr 8)) / ZcMul + 1) - 1) / Zcorr - mZZ;
              RMdoBinSearch(@MCTparas, dTmp, dT1);
            end
            else RMdoBinSearchIt(@MCTparas, mZZ);

            mZZ := mZZ - 0.1;                                     // step forward an amount
            mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, -0.1);
            msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);

            MaxLHS := (iMandWidth + y) * 0.6 * (1 + 0.5 * Min(mZZ, Zend * 0.4) * Max(0, FOVy) / iMandHeight) * sHSmaxLengthMultiplier;
            ZZ2 := mZZ;
            msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
            dMaxL := MaxLHS;
            if bisPosLight then  //calculate LightVec from position
            begin
              HSVec := SubtractVectors(AddSVec2Vec3(@PLVals.PLValigned.LN[iHSnr], @Xmit), @Iteration3Dext.C1);
              dTmp := SqrLengthOfVec(HSVec);
              if dTmp > PLVals.sLmaxL[iHSnr] * sHSmaxLengthMultiplier then
              begin
                Inc(mPsiLight);
                Continue;
              end;
              if dTmp < Sqr(dMaxL * StepWidth) then dMaxL := Sqrt(dTmp) / StepWidth;
              NormaliseVectorTo(-StepWidth, @HSVec);
            end;
            ZZ2mul := -DotOfVectorsNormalize(@HSVec, @mVgradsFOV);
            if iCutOptions <> 0 then HSminLengthToCutPlane(@HSVec, dMaxL, @Iteration3Dext.C1);

            NVec := MakeDVecFromNormals(mPsiLight);    //proof dotprod. of normals and Lightvec if is already hidden by object
            RotateVectorReverse(@NVec, @VGrads);
            if DotOfVectors(@NVec, @HSVec) > 0 then
            begin
              mPsiLight.Shadow := mPsiLight.Shadow and $3FF;
              Inc(mPsiLight);
              Continue;
            end;
            ZRsoft := 1;
            dT1 := dMaxL;
            if dT1 > 0 then
            begin
              msDEstop := DEstop * (1 + Abs(ZZ2) * mctDEstopFactor);
              RStepFactorDiff := 2; //1
              dTmp := CalcDE(@Iteration3Dext, @MCTparas);
              repeat
                RLastDE := dTmp;
                RLastStepWidth := MinCS(MaxCS(s011, (dTmp - msDEsub * msDEstop) * sZstepDiv * RStepFactorDiff),
                                  MaxCS(msDEstop, 0.4) * mctMH04ZSD);
                dT1 := dT1 - RLastStepWidth;
                mAddVecWeight(@Iteration3Dext.C1, @HSVec, -RLastStepWidth);
                ZZ2 := ZZ2 + RLastStepWidth * ZZ2mul;
                msDEstop := DEstop * (1 + Abs(ZZ2) * mctDEstopFactor);
                dTmp := CalcDE(@Iteration3Dext, @MCTparas);
                ZRsoft := MinCS(ZRsoft, (dTmp - msDEStop) * ZRSmul / (dMaxL - dT1 + s011)
                                       + Sqr(Sqr(Sqr((dMaxl - dT1) / MaxLHS))));    //.. + threshold based on lastDE, cant decrease more than...?
                if (Iteration3Dext.ItResultI >= MaxItsResult) or (dTmp <= msDEStop) then Break;
                if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;
                if RLastDE > dTmp + 1e-30 then
                begin
                  sT2 := RLastStepWidth / (RLastDE - dTmp);
                  if sT2 < 1 then RStepFactorDiff := maxCS(s05, sT2)
                             else RStepFactorDiff := 1;
                end
                else RStepFactorDiff := 1;
              until dT1 < 0;
            end;
            mPsiLight.Shadow := (mPsiLight.Shadow and $3FF) or (Round(Clamp01S(ZRsoft) * 63.4) shl 10);
          end;
          Inc(mPsiLight);
          if PCalcThreadStats.pLBcalcStop^ then Break;
        end;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        Inc(y, iThreadCount);
      end;
      bInsideRendering := bInsideTmp;
      bCalcInside := bInsideTmp;
    end;
end;

procedure THardShadowCalcThread.Execute;
var itmp, itmp2, x, y: Integer;
    mPsiLight: TPsiLight5;
    DElimited, bThr, bInsideTmp: LongBool;
    RLastStepWidth, RStepFactorDiff, MaxLHS, sT2: Single;
    dTmp, dT1, OAthr, RLastDE, ZZ2mul, dMaxL, dLastZ, ZZ2: Double;
    HSVec, IC, NVec: TVec3D;
    dLastFound: array[0..5] of Double;
    bZZoathr: array[0..5] of Integer;
begin
    with MCTparas do
    try
      bInsideTmp := bInsideRendering;
      IniIt3D(@MCTparas, @Iteration3Dext);
      iDEAddSteps := 8;
      Iteration3Dext.CalcSIT := False;
      if (CalcHardShadow and 256) <> 0 then begin calcHSsoft; Exit; end;
 //     DEstop := msDEstop;
      y := CalcRect.Top + iThreadId - 1;
      while y <= CalcRect.Bottom do
      begin
        PCalcThreadStats.CTrecords[iThreadId].iActualYpos := y;
        mPsiLight := TPsiLight5(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset);
        CAFY := (y / iMandHeight - s05) * FOVy;
        for x := 0 to 5 do bZZoathr[x] := 0;
        for x := CalcRect.Left to CalcRect.Right do
        begin
          PCalcThreadStats.CTrecords[iThreadId].iActualXpos := x;
          for itmp := 0 to 5 do if bZZoathr[itmp] > 0 then Dec(bZZoathr[itmp]);
          mPsiLight.Shadow := mPsiLight.Shadow and (((calcHardShadow and $FC) shl 8) xor $FFFF);   //Reset all selected HS to 0
          if (mPsiLight.Zpos < 32768) and (mPsiLight.SIgradient < 32768) then
          begin                                            //why not on cuts?->dotprod only
            NVec := MakeDVecFromNormals(mPsiLight);
            RotateVectorReverse(@NVec, @VGrads);

            bInsideRendering := bInsideTmp;
            bCalcInside := bInsideTmp;

            RMCalculateVgradsFOV(@MCTparas, x + 1);
            RMCalculateStartPos(@MCTparas, x, y);

            mZZ := (Sqr((8388351.5 - (PInteger(@mPsiLight.RoughZposFine)^ shr 8)) / ZcMul + 1) - 1) / Zcorr;
            mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, mZZ);

            msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
            dTmp := CalcDE(@Iteration3Dext, @MCTparas);

            if bInAndOutside and ((mPsiLight.OTrap and $8000) <> 0) then
            begin
              bInsideRendering := False;
              bCalcInside := False;
              dTmp := CalcDE(@Iteration3Dext, @MCTparas);
            end;

            DElimited := (Iteration3Dext.ItResultI < MaxItsResult) or (dTmp < msDEstop);
            if DElimited then
            begin
              dT1 := (Sqr((8388351.9 - (PInteger(@mPsiLight.RoughZposFine)^ shr 8)) / ZcMul + 1) - 1) / Zcorr - mZZ;
             // RLastDE := dTmp + dT1;
              RMdoBinSearch(@MCTparas, dTmp, dT1{, RLastDE});
            end
            else RMdoBinSearchIt(@MCTparas, mZZ);

       {     mZZ := mZZ + 0.1 * DotOfVectors(@NVec, @mVgradsFOV) / StepWidth;  // step forward an amount .. in normals dir?!
            mAddVecWeight(@Iteration3Dext.C1, @NVec, 0.1); }
            mZZ := MaxCD(0, mZZ - 0.1);
            mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, -0.1);

            msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
            mCopyVec(@IC, @Iteration3Dext.C1); //startpos, ZZ=Zstart //if not bVaryDEstopOnFOV then mctDEstopFactor = 0; mctDEstopFactor := (1 + 0.3 / msDEStop) * Max(0, FOVy) / iMandHeight

            MaxLHS := (iMandWidth + y) * 0.6 * (1 + 0.5 * Min(mZZ, Zend * 0.4) * Max(0, FOVy) / iMandHeight) * sHSmaxLengthMultiplier;
      //old calc:
        //    MaxLHS := Min((iMandWidth + iMandHeight) * 1.25, (iMandWidth + iMandHeight) * 0.6 * (1 + 0.3 * mZZ * mctDEstopFactor)) * sHSmaxLengthMultiplier;

            OAthr := (1 + (mZZ + MaxLHS) * mctDEstopFactor) * 3.3 / sZstepDiv;  //msDEstop is variing on ray!!
            for itmp := 0 to 5 do if (calcHardShadow and (4 shl itmp)) > 0 then
            begin
              itmp2 := PLVals.SortTab[itmp];
              bThr := bZZoathr[itmp] > 0;
              if bThr then   //no HS on previous pixel
              begin
                Dec(bZZoathr[itmp], Round(Abs(dLastZ - mZZ) * 3.3 / OAthr));
                if bZZoathr[itmp] <= 0 then
                begin
                  bThr := False;
                  bZZoathr[itmp] := 0;
                end
                else
                begin
                  dLastFound[itmp] := dLastFound[itmp] - Abs(dLastZ - mZZ) - (1 + mZZ * mctDEstopFactor);
                  if dLastFound[itmp] <= 0 then                                            //1 pixelstep
                  begin
                    bThr := False;
                    bZZoathr[itmp] := 0;
                  end;
                end;
              end;
              mCopyVec(@Iteration3Dext.C1, @IC); // startpos
              ZZ2 := mZZ;
              msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
              dMaxL := MaxLHS;
              if (PLVals.iLightPos[itmp2] and 1) <> 0 then  //calculate LightVec from position
              begin
                HSVec := SubtractVectors(AddSVec2Vec3(@PLVals.PLValigned.LN[itmp2], @Xmit), @Iteration3Dext.C1);
                dTmp := SqrLengthOfVec(HSVec);
                if dTmp > PLVals.sLmaxL[itmp2] * sHSmaxLengthMultiplier then
                begin
                  mPsiLight.Shadow := mPsiLight.Shadow or ($400 shl itmp);
                  Continue;
                end;
                if dTmp < Sqr(dMaxL * StepWidth) then dMaxL := Sqrt(dTmp) / StepWidth;
                HSvecs[itmp2] := NormaliseVectorTo(-StepWidth, HSvec);
              end;
              ZZ2mul := -DotOfVectorsNormalize(@HSvecs[itmp2], @mVgradsFOV);
              if iCutOptions <> 0 then HSminLengthToCutPlane(@HSvecs[itmp2], dMaxL, @Iteration3Dext.C1);
              
              if DotOfVectors(@NVec, @HSvecs[itmp2]) > 0 then
              begin
                mPsiLight.Shadow := mPsiLight.Shadow or ($400 shl itmp);
                bZZoathr[itmp] := 0;
                Continue;
              end;
              dT1 := dMaxL;
              if dT1 > 0 then
              begin
                msDEstop := DEstop * (1 + Abs(ZZ2) * mctDEstopFactor);
                RStepFactorDiff := 2; //1
                dTmp := CalcDE(@Iteration3Dext, @MCTparas);
                repeat
                  if bThr and (dLastFound[itmp] > dT1) then  //open air
                  begin
                    dT1 := -1;
                    Break;
                  end;
                  RLastDE := dTmp;
              //    dTmp := MinCS(dTmp * sZstepDiv * RStepFactorDiff, MaxCS(msDEstop, 0.4) * mctMH04ZSD);
                  dTmp := MinCS(MaxCS(s011, (dTmp - msDEsub * msDEstop) * sZstepDiv * RStepFactorDiff), MaxCS(msDEstop, 0.4) * mctMH04ZSD);
                  RLastStepWidth := dTmp;
                  dT1 := dT1 - dTmp;
                  mAddVecWeight(@Iteration3Dext.C1, @HSvecs[itmp2], -dTmp);
                  ZZ2 := ZZ2 + dTmp * ZZ2mul;
                  msDEstop := DEstop * (1 + Abs(ZZ2) * mctDEstopFactor);
                  dTmp := CalcDE(@Iteration3Dext, @MCTparas);
                  if (Iteration3Dext.ItResultI >= MaxItsResult) or (dTmp <= msDEStop) then Break;
                  if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;
                  if not bThr then
                  begin
                    if dTmp > OAthr then
                    begin
                      if bZZoathr[itmp] < 3 then
                      begin
                        dLastFound[itmp] := dT1;
                        bZZoathr[itmp] := 3;
                      end;
                    end
                    else bZZoathr[itmp] := 0;
                  end;
                  if RLastDE > dTmp + 1e-30 then
                  begin
                    sT2 := RLastStepWidth / (RLastDE - dTmp);
                    if sT2 < 1 then
                      RStepFactorDiff := maxCS(s05, sT2)
                    else
                      RStepFactorDiff := 1;
                  end
                  else RStepFactorDiff := 1;
                until dT1 < 0;
              end;
              if dT1 > 0 then  //object found
              begin
                mPsiLight.Shadow := mPsiLight.Shadow or ($400 shl itmp);  //shadow on
                bZZoathr[itmp] := 0;
              end;
            end;
          //  dLastMaxHLS := MaxLHS;
            dLastZ := mZZ;
          end;
          Inc(mPsiLight);
          if PCalcThreadStats.pLBcalcStop^ then Break;
        end;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        Inc(y, iThreadCount);
      end;
    finally
      bInsideRendering := bInsideTmp;
      bCalcInside := bInsideTmp;
      if not PCalcThreadStats.pLBcalcStop^ then
        PCalcThreadStats.CTrecords[iThreadId].iActualYpos := iMandHeight - 1;
      PCalcThreadStats.CTrecords[iThreadId].isActive := 0;
      PostMessage(PCalcThreadStats.pMessageHwnd, WM_ThreadReady, 0, 0);
    end;
end;

end.
