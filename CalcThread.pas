unit CalcThread;

interface

uses
  Classes, Math3D, TypeDefinitions, Windows, FormulaClass;

type
  TMandCalcThread = class(TThread)
  private
    { Private-Deklarationen }
    Iteration3Dext: TIteration3Dext;
  //  Seed: Integer;
  //  function GetRand: Double;
    procedure doColorOnIt;
    procedure DoDynFog(var actDE: Double; var StepCount: Single; const RSFmul, LastStepWidth: Single);
    function VLMinStepSize(LightPos, LastPos, ActPos: TPVec3D): Single;
  public
    { Public-Deklarationen }
    MCTparas: TMCTparameter;
  protected
    procedure Execute; override;
  end;

//var DEreduce1, DEreduce2: array[0..511] of Single;

//var RoughStat: array[0..255] of Integer;
{var
  DEColStat: array[0..16383] of Single;
  DEColStatCount: array[0..16383] of Integer; }

implementation

uses Mand, Math, DivUtils, formulas, CustomFormulas, LightAdjust, Calc, Maps;

//{$CODEALIGN 8}

function TMandCalcThread.VLMinStepSize(LightPos, LastPos, ActPos: TPVec3D): Single;
var stmp, stmp2, stmp3, d2, d3: Double;
    sv, sv2, sv3: TVec3D;
begin
    sv := SubtractVectors(ActPos^, LastPos);
    sv2 := SubtractVectors(LightPos^, LastPos);
    sv3 := SubtractVectors(LightPos^, ActPos);
    stmp3 := Sqr(MCTparas.StepWidth);
    d2 := SqrLengthOfVec(sv2) + stmp3;
    d3 := SqrLengthOfVec(sv3) + stmp3;
    stmp := DotOfVectors(@sv2, @sv);
    if stmp <= 0 then
      stmp := s0001 / ((1.01 + stmp / LengthOfVec(sv)) * Sqrt(d2))   // LastPos is nearest to light
    else  //~1.7/mapwidth
    begin
      stmp2 := SqrLengthOfVec(sv);
      if stmp2 <= stmp then           // ActPos is nearest to light
        stmp := s0001 / ((1.01 - DotOfVectors(@sv3, @sv) / LengthOfVec(sv)) *  Sqrt(d3))
      else
        stmp := s0001 / Sqrt((SqrLengthOfVec(SubtractVectors(LightPos,   //mindist is inbetween both positions
                   AddVecF(LastPos^, ScaleVector(sv, stmp / stmp2)))) + stmp3));
    end;
    Result := stmp;
end;

procedure TMandCalcThread.DoDynFog(var actDE: Double; var StepCount: Single; const RSFmul, LastStepWidth: Single);
var s1, st: Single;
    d1, d2: Double;
    v: TVec3D;
    vs: TSVec;
begin
    actDE := MaxCS(s011, (actDE - MCTparas.msDEsub * MCTparas.msDEstop) * MCTparas.sZstepDiv * RSFmul);
    s1 := MaxCS(MCTparas.msDEstop, 0.4) * MCTparas.mctMH04ZSD;
    if MCTparas.DFogOnIt < 65535 then
    begin
      if s1 < actDE then
      begin
        if MCTparas.DFogOnIt = 0 then StepCount := StepCount + s1 / actDE else
        if Iteration3Dext.ItResultI = MCTparas.DFogOnIt then StepCount := StepCount + s1 / actDE;
        actDE := s1;
      end
      else if MCTparas.DFogOnIt = 0 then StepCount := StepCount + 1 else
      if Iteration3Dext.ItResultI = MCTparas.DFogOnIt then StepCount := StepCount + 1;
    end
    else
    begin
      d2 := Sqr(MCTparas.StepWidth);
      if s1 < actDE then actDE := s1;
      mCopyAddVecWeight(@v, @Iteration3Dext.C1, @MCTparas.mVgradsFOV, -LastStepWidth);
      s1 := (1 + MCTparas.mZZ * MCTparas.mctDEstopFactor) * MCTparas.VLstepmul;
//    s1 := MaxCS(1, VLMinStepSize(@VolumeLightMap.LightPos, @v, @Iteration3Dext.C1) / MCTparas.StepWidth);
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
      until st < s001;
    end;
end;


procedure MandCalc(MCTparas: PMCTparameter);
var itmp, x, y, seed: Integer;
    pCTR: TPCTrecord;
    DElimited, bFirstStep, bInsideTmp: LongBool;
    RSFmul, StepCount: Single;
    RLastStepWidth, dTmp, dT1, RLastDE: Double;
label label1;
begin
    with MCTparas^ do    // MainProcedure CalcMand
    begin
      pCTR := @PCalcThreadStats.CTrecords[iThreadID];
{$IFDEF DEBUG} {$Q-} {$R-} {$ENDIF}
      seed := Round(Random * (iThreadId + 1) * $324594A1 + $24563487);
{$IFDEF DEBUG} {$Q+} {$R+} {$ENDIF}
      bInsideTmp := bInsideRendering;
      y := CalcRect.Top + iThreadId - 1;
      while y <= CalcRect.Bottom do
      begin
        pCTR.iActualYpos := y;
        mPsiLight := TPsiLight5(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset);
        CAFY := (y / iMandHeight - s05) * FOVy;
        for x := CalcRect.Left to CalcRect.Right do
        begin
          bInsideRendering := bInsideTmp;
          bCalcInside := bInsideTmp;
          pCTR.iActualXpos := x;
          RMCalculateVgradsFOV(MCTparas, x + 1);
          RMCalculateStartPos(MCTparas, x, y);
          PCardinal(@mPsiLight.Zpos)^ := 32768;
          mPsiLight.AmbShadow := 5000;
          pIt3Dext.CalcSIT := False;
          itmp       := 0;
          StepCount  := 0;
          mZZ        := 0;
          msDEstop   := DEstop;
          bFirstStep := bMCTFirstStepRandom;
          if iCutOptions > 0 then   // move to begin of cutting planes todo: check on which side, modify zend if step towards cutplane
          begin
            RMmaxLengthToCutPlane(MCTparas, dT1, itmp, @pIt3Dext.C1);
            if dT1 > (Zend - mZZ) then
            begin   //go to end, no dynfog??
              pIt3Dext.ItResultI := 0;
              MaxItsResult := iMaxIt;
              dTmp := msDEstop + 5;
              mZZ := Zend + 1;
            end else begin
              mZZ := dT1;
              mAddVecWeight(@pIt3Dext.C1, @mVgradsFOV, dT1);
              msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
              dTmp := CalcDE(pIt3Dext, MCTparas);
            end;
          end
          else
label1:     dTmp := CalcDE(pIt3Dext, MCTparas);
          if (pIt3Dext.ItResultI >= MaxItsResult) or (dTmp < msDEstop) then   // already in the set
          begin
            if bInAndOutside and (bCalcInside = bInsideTmp) then
            begin
              bCalcInside := not bInsideTmp;
              bInsideRendering := not bInsideTmp;
              goto label1;
            end;
            RMdoColor(MCTparas); //here for otrap
            RMcalcNanglesForCut(MCTparas, itmp);
            if ColorOption > 4 then mPsiLight.SIgradient := 32768 or mPsiLight.SIgradient else
            if bInsideRendering then
            begin
              pIt3Dext.CalcSIT := True;
              CalcDE(pIt3Dext, MCTparas);
              RSFmul := pIt3Dext.SmoothItD * mctsM;
              MinMaxClip15bit(RSFmul, mPsiLight.SIgradient);
              mPsiLight.SIgradient := 32768 or mPsiLight.SIgradient;
            end
            else mPsiLight.SIgradient := 32768 + Round(32767 * Clamp01S(pIt3Dext.Rout / dRStop));
          end
          else
          begin
            RSFmul := 1;
            RLastStepWidth := dTmp * sZstepDiv;
            repeat
              if pIt3Dext.ItResultI >= MaxItsResult then
              begin
                dT1 := -0.5 * RLastStepWidth;
                mZZ := mZZ + dT1;
                mAddVecWeight(@pIt3Dext.C1, @mVgradsFOV, dT1);
                msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
                dTmp := CalcDE(pIt3Dext, MCTparas);
                RLastStepWidth := -dT1;
              end;
              if (pIt3Dext.ItResultI < iMinIt) or
                ((pIt3Dext.ItResultI < MaxItsResult) and (dTmp >= msDEstop)) then    //##### next step ######
              begin
                RLastDE := dTmp;
                dTmp := MaxCS(s011, (dTmp - msDEsub * msDEstop) * sZstepDiv * RSFmul);
                dT1 := MaxCS(msDEstop, 0.4) * mctMH04ZSD;
                if dT1 < dTmp then
                begin
                  if DFogOnIt = 0 then StepCount := StepCount + dT1 / dTmp else
                  if pIt3Dext.ItResultI = DFogOnIt then StepCount := StepCount + dT1 / dTmp;
                  dTmp := dT1;
                end
                else if DFogOnIt = 0 then StepCount := StepCount + 1 else
                  if pIt3Dext.ItResultI = DFogOnIt then StepCount := StepCount + 1;
                if bFirstStep then
                begin
                  bFirstStep := False;
{$IFDEF DEBUG} {$Q-} {$R-} {$ENDIF}
                  seed := 214013 * seed + 2531011;
{$IFDEF DEBUG} {$Q+} {$R+} {$ENDIF}
                  dTmp := (seed and $7FFFFFFF) * dSeedMul * dTmp;
                end;
                RLastStepWidth := dTmp;
                mZZ := mZZ + dTmp;
                mAddVecWeight(@pIt3Dext.C1, @mVgradsFOV, dTmp);
                msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
                dTmp := CalcDE(pIt3Dext, MCTparas);
                if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;
                if RLastDE > dTmp + s1em30 then
                begin
                  dT1 := RLastStepWidth / (RLastDE - dTmp);
                  if dT1 < 1 then RSFmul := maxCS(s05 , dT1)
                             else RSFmul := 1;
                end
                else RSFmul := 1;
              end
              else     // ##### set found #####
              begin
                DElimited := (pIt3Dext.ItResultI < MaxItsResult) or (dTmp < msDEstop);
                if iDEAddSteps <> 0 then   //binary search
                begin
                  if DElimited then RMdoBinSearch(MCTparas, dTmp, RLastStepWidth)
                               else RMdoBinSearchIt(MCTparas, mZZ);
                end;
                Inc(pCTR.i64Its, pIt3Dext.ItResultI);
                Inc(pCTR.iItAvrCount);
                if pIt3Dext.ItResultI > pCTR.MaxIts then pCTR.MaxIts := pIt3Dext.ItResultI;
                TCalculateNormalsFunc(pCalcNormals)(MCTparas, RSFmul);
                if DElimited then RSFmul := 32767 - (RSFmul + dColPlus + mctColVarDEstopMul * ln(MaxCS(DEstop, msDEstop) * StepWidth)) * mctsM
                             else RSFmul := 32767 - RSFmul * mctsM; //in DEcomb mctsM for min or max result!!!  mctsM := 32767 / (iMaxIt2 + 1);
                MinMaxClip15bit(RSFmul, mPsiLight.SIgradient);                                                             //->   MaxItsResult
                RMdoColor(MCTparas);
                CalcZposAndRough(mPsiLight, MCTparas, mZZ);   //roughness after normals calc
                if bInAndOutside and not bInsideRendering then
                  mPsiLight.OTrap := mPsiLight.OTrap or $8000;
                Break;
              end;
            until (mZZ > Zend) or PCalcThreadStats.pLBcalcStop^;
            Inc(pCTR.i64DEsteps, Round(StepCount));
            Inc(pCTR.iDEAvrCount); //and not vollight
            if bInsideRendering then StepCount := StepCount * 200 * DEstop / iMandWidth;
            mPsiLight.Shadow := mPsiLight.Shadow or Round(Min0MaxCS(StepCount, 1023));
          end;
          Inc(mPsiLight);
          if PCalcThreadStats.pLBcalcStop^ then Break;
        end;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        Inc(y, iThreadCount);
      end;
    end;
end;

procedure MandCalcWithoutRand(MCTparas: PMCTparameter);
var itmp, x, y: Integer;
    pCTR: TPCTrecord;
    DElimited, bInsideTmp: LongBool;
    RSFmul, StepCount: Single;
    RLastStepWidth, dTmp, dT1, RLastDE: Double;
label label1;
begin
    with MCTparas^ do    // MainProcedure CalcMand
    begin
      pCTR := @PCalcThreadStats.CTrecords[iThreadID];
      bInsideTmp := bInsideRendering;
      y := CalcRect.Top + iThreadId - 1;
      while y <= CalcRect.Bottom do
      begin
        pCTR.iActualYpos := y;
        mPsiLight := TPsiLight5(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset);
        CAFY := (y / iMandHeight - s05) * FOVy;
        for x := CalcRect.Left to CalcRect.Right do
        begin
          bInsideRendering := bInsideTmp;
          bCalcInside := bInsideTmp;
          pCTR.iActualXpos := x;
          RMCalculateVgradsFOV(MCTparas, x + 1);
          RMCalculateStartPos(MCTparas, x, y);
          PCardinal(@mPsiLight.Zpos)^ := 32768;
          mPsiLight.AmbShadow := 5000;
          pIt3Dext.CalcSIT := False;
          itmp       := 0;
          StepCount  := 0;
          mZZ        := 0;
          msDEstop   := DEstop;
          if iCutOptions > 0 then   // move to begin of cutting planes todo: check on which side, modify zend if step towards cutplane
          begin
            RMmaxLengthToCutPlane(MCTparas, dT1, itmp, @pIt3Dext.C1);
            if dT1 > (Zend - mZZ) then
            begin   //go to end, no dynfog??
              pIt3Dext.ItResultI := 0;
              MaxItsResult := iMaxIt;
              dTmp := msDEstop + 5;
              mZZ := Zend + 1;
            end else begin
              mZZ := dT1;
              mAddVecWeight(@pIt3Dext.C1, @mVgradsFOV, dT1);
              msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
              dTmp := CalcDE(pIt3Dext, MCTparas);
            end;
          end
          else
label1:     dTmp := CalcDE(pIt3Dext, MCTparas);
          if (pIt3Dext.ItResultI >= MaxItsResult) or (dTmp < msDEstop) then   // already in the set
          begin
            if bInAndOutside and (bCalcInside = bInsideTmp) then
            begin
              bCalcInside := not bInsideTmp;
              bInsideRendering := not bInsideTmp;
              goto label1;
            end;
            RMdoColor(MCTparas); //here for otrap
            RMcalcNanglesForCut(MCTparas, itmp);
            if ColorOption > 4 then mPsiLight.SIgradient := 32768 or mPsiLight.SIgradient else
            if bInsideRendering then
            begin
              pIt3Dext.CalcSIT := True;
              CalcDE(pIt3Dext, MCTparas);
              RSFmul := pIt3Dext.SmoothItD * mctsM;
              MinMaxClip15bit(RSFmul, mPsiLight.SIgradient);
              mPsiLight.SIgradient := 32768 or mPsiLight.SIgradient;
            end
            else mPsiLight.SIgradient := 32768 + Round(32767 * Clamp01S(pIt3Dext.Rout / dRStop));
          end
          else
          begin
            RSFmul := 1;
            RLastStepWidth := dTmp * sZstepDiv;
            repeat
              if pIt3Dext.ItResultI >= MaxItsResult then
              begin
                dT1 := -0.5 * RLastStepWidth;
                mZZ := mZZ + dT1;
                mAddVecWeight(@pIt3Dext.C1, @mVgradsFOV, dT1);
                msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
                dTmp := CalcDE(pIt3Dext, MCTparas);
                RLastStepWidth := -dT1;
              end;
              if (pIt3Dext.ItResultI < iMinIt) or
                ((pIt3Dext.ItResultI < MaxItsResult) and (dTmp >= msDEstop)) then    //##### next step ######
              begin
                RLastDE := dTmp;
                dTmp := MaxCS(s011, (dTmp - msDEsub * msDEstop) * sZstepDiv * RSFmul);
                dT1 := MaxCS(msDEstop, 0.4) * mctMH04ZSD;
                if dT1 < dTmp then
                begin
                  if DFogOnIt = 0 then StepCount := StepCount + dT1 / dTmp else
                  if pIt3Dext.ItResultI = DFogOnIt then StepCount := StepCount + dT1 / dTmp;
                  dTmp := dT1;
                end
                else if DFogOnIt = 0 then StepCount := StepCount + 1 else
                  if pIt3Dext.ItResultI = DFogOnIt then StepCount := StepCount + 1;
                RLastStepWidth := dTmp;
                mZZ := mZZ + dTmp;
                mAddVecWeight(@pIt3Dext.C1, @mVgradsFOV, dTmp);
                msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
                dTmp := CalcDE(pIt3Dext, MCTparas);
                if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;
                if RLastDE > dTmp + s1em30 then
                begin
                  dT1 := RLastStepWidth / (RLastDE - dTmp);
                  if dT1 < 1 then RSFmul := maxCS(s05 , dT1)
                             else RSFmul := 1;
                end
                else RSFmul := 1;
              end
              else     // ##### set found #####
              begin
                DElimited := (pIt3Dext.ItResultI < MaxItsResult) or (dTmp < msDEstop);
                if iDEAddSteps <> 0 then   //binary search
                begin
                  if DElimited then RMdoBinSearch(MCTparas, dTmp, RLastStepWidth)
                               else RMdoBinSearchIt(MCTparas, mZZ);
                end;
                Inc(pCTR.i64Its, pIt3Dext.ItResultI);
                Inc(pCTR.iItAvrCount);
                if pIt3Dext.ItResultI > pCTR.MaxIts then pCTR.MaxIts := pIt3Dext.ItResultI;
                TCalculateNormalsFunc(pCalcNormals)(MCTparas, RSFmul);
                if DElimited then RSFmul := 32767 - (RSFmul + dColPlus + mctColVarDEstopMul * ln(MaxCS(DEstop, msDEstop) * StepWidth)) * mctsM
                             else RSFmul := 32767 - RSFmul * mctsM; //in DEcomb mctsM for min or max result!!!  mctsM := 32767 / (iMaxIt2 + 1);
                MinMaxClip15bit(RSFmul, mPsiLight.SIgradient);                                                             //->   MaxItsResult
                RMdoColor(MCTparas);
                CalcZposAndRough(mPsiLight, MCTparas, mZZ);   //roughness after normals calc
                if bInAndOutside and not bInsideRendering then
                  mPsiLight.OTrap := mPsiLight.OTrap or $8000;
                Break;
              end;
            until (mZZ > Zend) or PCalcThreadStats.pLBcalcStop^;
            Inc(pCTR.i64DEsteps, Round(StepCount));
            Inc(pCTR.iDEAvrCount);
            if bInsideRendering then StepCount := StepCount * 200 * DEstop / iMandWidth;
            mPsiLight.Shadow := mPsiLight.Shadow or Round(Min0MaxCS(StepCount, 1023));
          end;
          Inc(mPsiLight);
          if PCalcThreadStats.pLBcalcStop^ then Break;
        end;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        Inc(y, iThreadCount);
      end;
    end;
end;

procedure MandCalcWithoutDynFogOnIts(MCTparas: PMCTparameter);
var itmp, x, y, seed: Integer;
    pCTR: TPCTrecord;
    DElimited, bFirstStep, bInsideTmp: LongBool;
    RSFmul, StepCount: Single;
    RLastStepWidth, dTmp, dT1, RLastDE: Double;
label label1;
begin
    with MCTparas^ do    // MainProcedure CalcMand
    begin
      pCTR := @PCalcThreadStats.CTrecords[iThreadID];
{$IFDEF DEBUG} {$Q-} {$R-} {$ENDIF}
      seed := Round(Random * (iThreadId + 1) * $324594A1 + $24563487);
{$IFDEF DEBUG} {$Q+} {$R+} {$ENDIF}
      bInsideTmp := bInsideRendering;
      y := CalcRect.Top + iThreadId - 1;
      while y <= CalcRect.Bottom do
      begin
        pCTR.iActualYpos := y;
        mPsiLight := TPsiLight5(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset);
        CAFY := (y / iMandHeight - s05) * FOVy;
        for x := CalcRect.Left to CalcRect.Right do
        begin
          bInsideRendering := bInsideTmp;
          bCalcInside := bInsideTmp;
          pCTR.iActualXpos := x;
          RMCalculateVgradsFOV(MCTparas, x + 1);
          RMCalculateStartPos(MCTparas, x, y);
          PCardinal(@mPsiLight.Zpos)^ := 32768;
          mPsiLight.AmbShadow := 5000;
          pIt3Dext.CalcSIT := False;
          itmp       := 0;
          StepCount  := 0;
          mZZ        := 0;
          msDEstop   := DEstop;
          bFirstStep := bMCTFirstStepRandom;
          if iCutOptions > 0 then   // move to begin of cutting planes todo: check on which side, modify zend if step towards cutplane
          begin
            RMmaxLengthToCutPlane(MCTparas, dT1, itmp, @pIt3Dext.C1);
            if dT1 > (Zend - mZZ) then
            begin   //go to end, no dynfog??
              pIt3Dext.ItResultI := 0;
              MaxItsResult := iMaxIt;
              dTmp := msDEstop + 5;
              mZZ := Zend + 1;
            end else begin
              mZZ := dT1;
              mAddVecWeight(@pIt3Dext.C1, @mVgradsFOV, dT1);
              msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
              dTmp := CalcDE(pIt3Dext, MCTparas);
            end;
          end
          else
label1:     dTmp := CalcDE(pIt3Dext, MCTparas);
          if (pIt3Dext.ItResultI >= MaxItsResult) or (dTmp < msDEstop) then   // already in the set
          begin
            if bInAndOutside and (bCalcInside = bInsideTmp) then
            begin
              bCalcInside := not bInsideTmp;
              bInsideRendering := not bInsideTmp;
              goto label1;
            end;
            RMdoColor(MCTparas); //here for otrap
            RMcalcNanglesForCut(MCTparas, itmp);
            if ColorOption > 4 then mPsiLight.SIgradient := 32768 or mPsiLight.SIgradient else
            if bInsideRendering then
            begin
              pIt3Dext.CalcSIT := True;
              CalcDE(pIt3Dext, MCTparas);
              RSFmul := pIt3Dext.SmoothItD * mctsM;
              MinMaxClip15bit(RSFmul, mPsiLight.SIgradient);
              mPsiLight.SIgradient := 32768 or mPsiLight.SIgradient;
            end
            else mPsiLight.SIgradient := 32768 + Round(32767 * Clamp01S(pIt3Dext.Rout / dRStop));
          end
          else
          begin
            RSFmul := 1;
            RLastStepWidth := dTmp * sZstepDiv;
            repeat
              if pIt3Dext.ItResultI >= MaxItsResult then
              begin
                dT1 := -0.5 * RLastStepWidth;
                mZZ := mZZ + dT1;
                mAddVecWeight(@pIt3Dext.C1, @mVgradsFOV, dT1);
                msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
                dTmp := CalcDE(pIt3Dext, MCTparas);
                RLastStepWidth := -dT1;
              end;
              if (pIt3Dext.ItResultI < iMinIt) or
                ((pIt3Dext.ItResultI < MaxItsResult) and (dTmp >= msDEstop)) then    //##### next step ######
              begin
                RLastDE := dTmp;
                dTmp := MaxCS(s011, (dTmp - msDEsub * msDEstop) * sZstepDiv * RSFmul);
                dT1 := MaxCS(msDEstop, 0.4) * mctMH04ZSD;
                if dT1 < dTmp then
                begin
                  StepCount := StepCount + dT1 / dTmp;
                  dTmp := dT1;
                end
                else StepCount := StepCount + 1;
                if bFirstStep then
                begin
                  bFirstStep := False;
{$IFDEF DEBUG} {$Q-} {$R-} {$ENDIF}
                  seed := 214013 * seed + 2531011;
{$IFDEF DEBUG} {$Q+} {$R+} {$ENDIF}
                  dTmp := (seed and $7FFFFFFF) * dSeedMul * dTmp;
                end;
                RLastStepWidth := dTmp;
                mZZ := mZZ + dTmp;
                mAddVecWeight(@pIt3Dext.C1, @mVgradsFOV, dTmp);
                msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
                dTmp := CalcDE(pIt3Dext, MCTparas);
                if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;
                if RLastDE > dTmp + s1em30 then
                begin
                  dT1 := RLastStepWidth / (RLastDE - dTmp);
                  if dT1 < 1 then RSFmul := maxCS(s05 , dT1)
                             else RSFmul := 1;
                end
                else RSFmul := 1;
              end
              else     // ##### set found #####
              begin
                DElimited := (pIt3Dext.ItResultI < MaxItsResult) or (dTmp < msDEstop);
                if iDEAddSteps <> 0 then   //binary search
                begin
                  if DElimited then RMdoBinSearch(MCTparas, dTmp, RLastStepWidth)
                               else RMdoBinSearchIt(MCTparas, mZZ);
                end;
                Inc(pCTR.i64Its, pIt3Dext.ItResultI);
                Inc(pCTR.iItAvrCount);
                if pIt3Dext.ItResultI > pCTR.MaxIts then pCTR.MaxIts := pIt3Dext.ItResultI;
                TCalculateNormalsFunc(pCalcNormals)(MCTparas, RSFmul);
                if DElimited then RSFmul := 32767 - (RSFmul + dColPlus + mctColVarDEstopMul * ln(MaxCS(DEstop, msDEstop) * StepWidth)) * mctsM
                             else RSFmul := 32767 - RSFmul * mctsM; //in DEcomb mctsM for min or max result!!!  mctsM := 32767 / (iMaxIt2 + 1);
                MinMaxClip15bit(RSFmul, mPsiLight.SIgradient);                                                             //->   MaxItsResult
                RMdoColor(MCTparas);
                CalcZposAndRough(mPsiLight, MCTparas, mZZ);   //roughness after normals calc
                if bInAndOutside and not bInsideRendering then
                  mPsiLight.OTrap := mPsiLight.OTrap or $8000;
                Break;
              end;
            until (mZZ > Zend) or PCalcThreadStats.pLBcalcStop^;
            Inc(pCTR.i64DEsteps, Round(StepCount));
            Inc(pCTR.iDEAvrCount);
            if bInsideRendering then StepCount := StepCount * 200 * DEstop / iMandWidth;
            mPsiLight.Shadow := mPsiLight.Shadow or Round(Min0MaxCS(StepCount, 1023));
          end;
          Inc(mPsiLight);
          if PCalcThreadStats.pLBcalcStop^ then Break;
        end;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        Inc(y, iThreadCount);
      end;
    end;
end;

procedure MandCalcWithoutRandDynFogOnIts(MCTparas: PMCTparameter);
var itmp, x, y: Integer;
    pCTR: TPCTrecord;
    DElimited, bInsideTmp: LongBool;
    RSFmul, StepCount: Single;
    RLastStepWidth, dTmp, dT1, RLastDE: Double;
label label1;
begin
    with MCTparas^ do    // MainProcedure CalcMand
    begin
      pCTR := @PCalcThreadStats.CTrecords[iThreadID];
      bInsideTmp := bInsideRendering;
      y := CalcRect.Top + iThreadId - 1;
      while y <= CalcRect.Bottom do
      begin
        pCTR.iActualYpos := y;
        mPsiLight := TPsiLight5(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset);
        CAFY := (y / iMandHeight - s05) * FOVy;
        for x := CalcRect.Left to CalcRect.Right do
        begin
          bInsideRendering := bInsideTmp;
          bCalcInside := bInsideTmp;
          pCTR.iActualXpos := x;
          RMCalculateVgradsFOV(MCTparas, x + 1);
          RMCalculateStartPos(MCTparas, x, y);
          PCardinal(@mPsiLight.Zpos)^ := 32768;
          mPsiLight.AmbShadow := 5000;
          pIt3Dext.CalcSIT := False;
          itmp       := 0;
          StepCount  := 0;
          mZZ        := 0;
          msDEstop   := DEstop;
          if iCutOptions > 0 then   // move to begin of cutting planes todo: check on which side, modify zend if step towards cutplane
          begin
            RMmaxLengthToCutPlane(MCTparas, dT1, itmp, @pIt3Dext.C1);
            if dT1 > (Zend - mZZ) then
            begin   //go to end, no dynfog??
              pIt3Dext.ItResultI := 0;
              MaxItsResult := iMaxIt;
              dTmp := msDEstop + 5;
              mZZ := Zend + 1;
            end else begin
              mZZ := dT1;
              mAddVecWeight(@pIt3Dext.C1, @mVgradsFOV, dT1);
              msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
              dTmp := CalcDE(pIt3Dext, MCTparas);
            end;
          end
          else
label1:     dTmp := CalcDE(pIt3Dext, MCTparas);
          if (pIt3Dext.ItResultI >= MaxItsResult) or (dTmp < msDEstop) then   // already in the set
          begin
            if bInAndOutside and (bCalcInside = bInsideTmp) then
            begin
              bCalcInside := not bInsideTmp;
              bInsideRendering := not bInsideTmp;
              goto label1;
            end;
            RMdoColor(MCTparas); //here for otrap
            RMcalcNanglesForCut(MCTparas, itmp);
            if ColorOption > 4 then mPsiLight.SIgradient := 32768 or mPsiLight.SIgradient else
            if bInsideRendering then
            begin
              pIt3Dext.CalcSIT := True;
              CalcDE(pIt3Dext, MCTparas);
              RSFmul := pIt3Dext.SmoothItD * mctsM;
              MinMaxClip15bit(RSFmul, mPsiLight.SIgradient);
              mPsiLight.SIgradient := 32768 or mPsiLight.SIgradient;
            end
            else mPsiLight.SIgradient := 32768 + Round(32767 * Clamp01S(pIt3Dext.Rout / dRStop));
          end
          else
          begin
            RSFmul := 1;
            RLastStepWidth := dTmp * sZstepDiv;
            repeat
              if pIt3Dext.ItResultI >= MaxItsResult then
              begin
                dT1 := -0.5 * RLastStepWidth;
                mZZ := mZZ + dT1;
                mAddVecWeight(@pIt3Dext.C1, @mVgradsFOV, dT1);
                msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
                dTmp := CalcDE(pIt3Dext, MCTparas);
                RLastStepWidth := -dT1;
              end;
              if (pIt3Dext.ItResultI < iMinIt) or
                ((pIt3Dext.ItResultI < MaxItsResult) and (dTmp >= msDEstop)) then    //##### next step ######
              begin
                RLastDE := dTmp;
                dTmp := MaxCS(s011, (dTmp - msDEsub * msDEstop) * sZstepDiv * RSFmul);
                dT1 := MaxCS(msDEstop, 0.4) * mctMH04ZSD;
                if dT1 < dTmp then
                begin
                  StepCount := StepCount + dT1 / dTmp;
                  dTmp := dT1;
                end
                else StepCount := StepCount + 1;
                RLastStepWidth := dTmp;
                mZZ := mZZ + dTmp;
                mAddVecWeight(@pIt3Dext.C1, @mVgradsFOV, dTmp);
                msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
                dTmp := CalcDE(pIt3Dext, MCTparas);
                if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;
                if RLastDE > dTmp + s1em30 then
                begin
                  dT1 := RLastStepWidth / (RLastDE - dTmp);
                  if dT1 < 1 then RSFmul := maxCS(s05 , dT1)
                             else RSFmul := 1;
                end
                else RSFmul := 1;
              end
              else     // ##### set found #####
              begin
                DElimited := (pIt3Dext.ItResultI < MaxItsResult) or (dTmp < msDEstop);
                if iDEAddSteps <> 0 then   //binary search
                begin
                  if DElimited then RMdoBinSearch(MCTparas, dTmp, RLastStepWidth)
                               else RMdoBinSearchIt(MCTparas, mZZ);
                end;
                Inc(pCTR.i64Its, pIt3Dext.ItResultI);
                Inc(pCTR.iItAvrCount);
                if pIt3Dext.ItResultI > pCTR.MaxIts then pCTR.MaxIts := pIt3Dext.ItResultI;
                TCalculateNormalsFunc(pCalcNormals)(MCTparas, RSFmul);
                if DElimited then RSFmul := 32767 - (RSFmul + dColPlus + mctColVarDEstopMul * ln(MaxCS(DEstop, msDEstop) * StepWidth)) * mctsM
                             else RSFmul := 32767 - RSFmul * mctsM; //in DEcomb mctsM for min or max result!!!  mctsM := 32767 / (iMaxIt2 + 1);
                MinMaxClip15bit(RSFmul, mPsiLight.SIgradient);                                                             //->   MaxItsResult
                RMdoColor(MCTparas);
                CalcZposAndRough(mPsiLight, MCTparas, mZZ);   //roughness after normals calc
                if bInAndOutside and not bInsideRendering then
                  mPsiLight.OTrap := mPsiLight.OTrap or $8000;
                Break;
              end;
            until (mZZ > Zend) or PCalcThreadStats.pLBcalcStop^;
            Inc(pCTR.i64DEsteps, Round(StepCount));
            Inc(pCTR.iDEAvrCount);
            if bInsideRendering then StepCount := StepCount * 200 * DEstop / iMandWidth;
            mPsiLight.Shadow := mPsiLight.Shadow or Round(Min0MaxCS(StepCount, 1023));
          end;
          Inc(mPsiLight);
          if PCalcThreadStats.pLBcalcStop^ then Break;
        end;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        Inc(y, iThreadCount);
      end;
    end;
end;

{procedure TMandCalcThread.Execute;
begin
    try
      IniIt3D(@MCTparas, @Iteration3Dext);
      if MCTparas.bMCTFirstStepRandom then
      begin
        if MCTparas.DFogOnIt = 0 then MandCalcWithoutDynFogOnIts(@MCTparas)
                                 else MandCalc(@MCTparas);
      end
      else if MCTparas.DFogOnIt = 0 then MandCalcWithoutRandDynFogOnIts(@MCTparas)
                                    else MandCalcWithoutRand(@MCTparas);
    finally
      with MCTparas do
      begin
        PCalcThreadStats.CTrecords[iThreadID].isActive := 0;
        if not PCalcThreadStats.pLBcalcStop^ then
          PCalcThreadStats.CTrecords[iThreadID].iActualYpos := CalcRect.Bottom;
        PostMessage(PCalcThreadStats.pMessageHwnd, WM_ThreadReady, 0, 0);
      end;
    end;
end; }

procedure TMandCalcThread.doColorOnIt;
var i: Integer;
begin
    if MCTparas.ColorOnIt = 1 then mCopyVec(@Iteration3Dext.x, @Iteration3Dext.C1) else
    begin
      i := Iteration3Dext.maxIt;
      Iteration3Dext.maxIt := MCTparas.ColorOnIt - 1;
      Iteration3Dext.RStop := Sqr(Iteration3Dext.RStop) * 64;
      MCTparas.CalcDE(@Iteration3Dext, @MCTparas);
      Iteration3Dext.maxIt := i;
      Iteration3Dext.RStop := MCTparas.dRStop;
    end;
end;

procedure TMandCalcThread.Execute;
var itmp, x, y, seed: Integer;
    pCTR: TPCTrecord;
    DElimited, bFirstStep, bInsideTmp: LongBool;
    RSFmul, StepCount: Single;
    RLastStepWidth, dTmp, dT1, RLastDE: Double;
label label1;
begin
    with MCTparas do    // MainProcedure CalcMand
    try
      pCTR := @PCalcThreadStats.CTrecords[iThreadID];
      IniIt3D(@MCTparas, @Iteration3Dext);
{$IFDEF DEBUG} {$Q-} {$R-} {$ENDIF}
      seed := Round(Random * (iThreadId + 1) * $324594A1 + $24563487);
{$IFDEF DEBUG} {$Q+} {$R+} {$ENDIF}
      bInsideTmp := bInsideRendering;
      y := CalcRect.Top + iThreadId - 1;
      while y <= CalcRect.Bottom do
      begin
        pCTR.iActualYpos := y;
        mPsiLight := TPsiLight5(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset);
        CAFY := (y / iMandHeight - s05) * FOVy;
        for x := CalcRect.Left to CalcRect.Right do
        begin
          bInsideRendering := bInsideTmp;
          bCalcInside := bInsideTmp;
          pCTR.iActualXpos := x;
          RMCalculateVgradsFOV(@MCTparas, x + 1);
          RMCalculateStartPos(@MCTparas, x, y);
          PCardinal(@mPsiLight.Zpos)^ := 32768;
          mPsiLight.AmbShadow := 5000;
          Iteration3Dext.CalcSIT := False;
          itmp       := 0;
          StepCount  := 0;
          mZZ        := 0;
          msDEstop   := DEstop;
          bFirstStep := bMCTFirstStepRandom;
          if iCutOptions > 0 then   // move to begin of cutting planes todo: check on which side, modify zend if step towards cutplane
          begin
            RMmaxLengthToCutPlane(@MCTparas, dT1, itmp, @Iteration3Dext.C1);
            if dT1 > (Zend - mZZ) then
            begin   //go to end, no dynfog??
              Iteration3Dext.ItResultI := 0;
              MaxItsResult := iMaxIt;
              dTmp := msDEstop + 5;
              mZZ := Zend + 1;
            end else begin
              mZZ := dT1;
              mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, dT1);
              msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
              dTmp := CalcDE(@Iteration3Dext, @MCTparas);
            end;
          end
          else
label1:     dTmp := CalcDE(@Iteration3Dext, @MCTparas);

          if (Iteration3Dext.ItResultI >= MaxItsResult) or (dTmp < msDEstop) then   // already in the set
          begin
            if bInAndOutside and (bCalcInside = bInsideTmp) then
            begin
              bCalcInside := not bInsideTmp;
              bInsideRendering := not bInsideTmp;
              goto label1;
            end;
            if ColorOnIt <> 0 then doColorOnIt;
            RMdoColor(@MCTparas); //here for otrap
            RMcalcNanglesForCut(@MCTparas, itmp);
            if ColorOption > 4 then mPsiLight.SIgradient := 32768 or mPsiLight.SIgradient else
            if bInsideRendering then
            begin
              Iteration3Dext.CalcSIT := True;
              CalcDE(@Iteration3Dext, @MCTparas);
              RSFmul := Iteration3Dext.SmoothItD * mctsM;
              MinMaxClip15bit(RSFmul, mPsiLight.SIgradient);
              mPsiLight.SIgradient := 32768 or mPsiLight.SIgradient;
            end
            else mPsiLight.SIgradient := 32768 + Round(32767 * Clamp01S(Iteration3Dext.Rout / dRStop));
          end
          else
          begin
            RSFmul := 1;
          //  if SqrLengthOfVec(TPVec3D(@Iteration3Dext.C1)^) < 1 then pInt := @DEreduce1 else pInt := @DEreduce2;
            RLastStepWidth := dTmp * sZstepDiv;
        //    RLastDE := dtmp + RLastStepWidth;
            repeat
              if Iteration3Dext.ItResultI >= MaxItsResult then
              begin
                dT1 := -0.5 * RLastStepWidth;
                mZZ := mZZ + dT1;
                mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, dT1);
                msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
                dTmp := CalcDE(@Iteration3Dext, @MCTparas);
                RLastStepWidth := -dT1;
              end;

              if (Iteration3Dext.ItResultI < iMinIt) or
                ((Iteration3Dext.ItResultI < MaxItsResult) and (dTmp >= msDEstop)) then    //##### next step ######
              begin
                RLastDE := dTmp;
                DoDynFog(dTmp, StepCount, RSFmul, RLastStepWidth);
             {   else
                begin
                  dTmp := MaxCS(s011, (dTmp - msDEsub * msDEstop) * sZstepDiv * RSFmul);
                  dT1 := MaxCS(msDEstop, 0.4) * mctMH04ZSD;
                  if dT1 < dTmp then
                  begin
                    if DFogOnIt = 0 then StepCount := StepCount + dT1 / dTmp else
                    if Iteration3Dext.ItResultI = DFogOnIt then StepCount := StepCount + dT1 / dTmp;
                    dTmp := dT1;
                  end
                  else if DFogOnIt = 0 then StepCount := StepCount + 1 else
                    if Iteration3Dext.ItResultI = DFogOnIt then StepCount := StepCount + 1;
                end;  }

                if bFirstStep then
                begin
                  bFirstStep := False;
{$IFDEF DEBUG} {$Q-} {$R-} {$ENDIF}
                  seed := 214013 * seed + 2531011;
{$IFDEF DEBUG} {$Q+} {$R+} {$ENDIF}
                  dTmp := (seed and $7FFFFFFF) * dSeedMul * dTmp;
                end;
                mZZ := mZZ + dTmp;
                if mZZ > Zend then //dont need to calcde
                begin
                  if DFogOnIt = 65535 then
                  begin
                    RLastStepWidth := Zend - mZZ + dTmp;
                    mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, RLastStepWidth);
                    DoDynFog(RLastDE, StepCount, RSFmul, RLastStepWidth);
                  end;
                  Break;
                end;
                RLastStepWidth := dTmp;
                mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, dTmp);
                msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);

                dTmp := CalcDE(@Iteration3Dext, @MCTparas);
                if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;

                if RLastDE > dTmp + s1em30 then
                begin
                  dT1 := RLastStepWidth / (RLastDE - dTmp);
                  if dT1 < 1 then
                    RSFmul := maxCS(s05 , dT1)
                  else
                    RSFmul := 1;
                end
                else RSFmul := 1;
              end
              else     // ##### set found #####
              begin
         //       RLastDE := dTmp;  //new do laststep for fog?
           //     DoDynFog(dTmp, StepCount, RSFmul, RLastStepWidth);
             //   if bInsideRendering then DElimited := Iteration3Dext.ItResultI < MaxItsResult - 1 else
           //     DElimited := Iteration3Dext.ItResultI < MaxItsResult;   //problem: MinIt limited! if DElimited and (dTmp >= DEstop) then BinSearchMinIt
                DElimited := (Iteration3Dext.ItResultI < MaxItsResult) or (dTmp < msDEstop);
                if iDEAddSteps <> 0 then   //binary search
                begin
                  if DElimited then
                  begin
             //       RMdoSecantSearch(@MCTparas, dTmp, RLastStepWidth, RLastDE); //test
                    RMdoBinSearch(@MCTparas, dTmp, RLastStepWidth);
                  end
                  else RMdoBinSearchIt(@MCTparas, mZZ);
                end;

                Inc(pCTR.i64Its, Iteration3Dext.ItResultI);
                Inc(pCTR.iItAvrCount);
                if Iteration3Dext.ItResultI > pCTR.MaxIts then pCTR.MaxIts := Iteration3Dext.ItResultI;

                TCalculateNormalsFunc(pCalcNormals)(@MCTparas, RSFmul);

                if DElimited then RSFmul := 32767 - (RSFmul + dColPlus + mctColVarDEstopMul * ln(MaxCS(DEstop, msDEstop) * StepWidth)) * mctsM
                             else RSFmul := 32767 - RSFmul * mctsM; //in DEcomb mctsM for min or max result!!!  mctsM := 32767 / (iMaxIt2 + 1);
                MinMaxClip15bit(RSFmul, mPsiLight.SIgradient);                                                             //->   MaxItsResult
                if ColorOnIt <> 0 then doColorOnIt;
                RMdoColor(@MCTparas);
                CalcZposAndRough(mPsiLight, @MCTparas, mZZ);   //roughness after normals calc

                if bInAndOutside and not bInsideRendering then
                  mPsiLight.OTrap := mPsiLight.OTrap or $8000;

                // todo: if SSAOfromOrig then mPsiLight.AmbShadow := calcSSAOforPixel(x, y, mZZ);
                Break;
              end;
            until {(mZZ > Zend) or} PCalcThreadStats.pLBcalcStop^;
            Inc(pCTR.iDEAvrCount);
            if DFogOnIt = 65535 then mPsiLight.Shadow := RMcalcVLight(StepCount) else
            begin
              Inc(pCTR.i64DEsteps, Round(StepCount));
              if bInsideRendering then StepCount := StepCount * 200 * DEstop / iMandWidth;
              mPsiLight.Shadow := Round(Min0MaxCS(StepCount, 1023));
            end;
          end;
          Inc(mPsiLight);
          if PCalcThreadStats.pLBcalcStop^ then Break;
        end;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        Inc(y, iThreadCount);
      end;
    finally
      pCTR.isActive := 0;
      if not PCalcThreadStats.pLBcalcStop^ then pCTR.iActualYpos := CalcRect.Bottom;
      PostMessage(PCalcThreadStats.pMessageHwnd, WM_ThreadReady, 0, 0);
    end;
end;

end.
