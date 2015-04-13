unit CalcPart;

interface

uses
  Classes, Math3D, TypeDefinitions, Windows;

type
  TCalcPartThread = class(TThread)  //todo: use normal calcthread+hscalcthread with calcrect+psilight+FSI modifications
  private
    { Private-Deklarationen }
    Iteration3Dext: TIteration3Dext;
  public
    { Public-Deklarationen }
    CalcOnlyNearerOnes: LongBool;
    CalcHardShadows: LongBool;
    DontTouchAmbShadow: LongBool;
    RSmulti: Single;
    MCTparas: TMCTparameter;
  protected
    procedure Execute; override;
  end;
function CalcPartT(CalcR: TRect; CalcHS, CalcOnlyNearer, CalcDEAO, DontTouchAS: LongBool; RSdiv: Integer): Boolean;

implementation

uses Mand, Math, DivUtils, formulas, CustomFormulas, HeaderTrafos, LightAdjust,
     Forms, PaintThread, CalcAmbShadowDE, Calc, PostProcessForm;

function CalcPartT(CalcR: TRect; CalcHS, CalcOnlyNearer, CalcDEAO, DontTouchAS: LongBool; RSdiv: Integer): Boolean;
var x, y, ThreadCount, ymin: Integer;
    MCTparas: TMCTparameter;
    CalcPartThread: array of TCalcPartThread;
begin
    Result := False;
    with Mand3DForm do
    try
      MakeHeader;
      if not SizeOK(True) then Exit;
      MHeader.bCalc3D := 1;
      MakeLightValsFromHeaderLight(@MHeader, @HeaderLightVals, 1, MHeader.bStereoMode);
      MCalcThreadStats.pLBcalcStop := @MCalcStop;
      MCalcThreadStats.pMessageHwnd := Handle;

      ThreadCount := Min(Mand3DForm.UpDown3.Position, CalcR.Bottom - CalcR.Top + 1);
      MCTparas    := getMCTparasFromHeader(MHeader, True);
      Result      := MCTparas.bMCTisValid;
      if Result then
      begin
        MCTparas.pSiLight := @siLight5[CalcR.Top * GetTileSize(@MHeader).X + CalcR.Left];
        MCTparas.PLVals   := @HeaderLightVals;
        MCTparas.PCalcThreadStats := @MCalcThreadStats;
        with MCTparas do
          CalcRect := Rect(CalcR.Left + CalcRect.Left, CalcR.Top + CalcRect.Top,
                           CalcR.Right + CalcRect.Left, CalcR.Bottom + CalcRect.Top);
        CalcHSVecsFromLights(@HeaderLightVals, @MCTparas);
        SetLength(CalcPartThread, ThreadCount);
      end;
    finally
    end;
    if Result then
    with Mand3DForm do
    begin
      ProgressBar1.Max := CalcR.Bottom - CalcR.Top + 1;
      ProgressBar1.Position := 0;
      ProgressBar1.Visible := True;
      MCalcThreadStats.ctCalcRect := CalcR;
      for x := 1 to ThreadCount do
      begin
        MCalcThreadStats.CTrecords[x].iActualYpos := CalcR.Top - 1;
        MCalcThreadStats.CTrecords[x].iActualXpos := CalcR.Left;
        MCTparas.iThreadId   := x;
        try
          CalcPartThread[x - 1] := TCalcPartThread.Create(True);
          CalcPartThread[x - 1].FreeOnTerminate := True;
          CalcPartThread[x - 1].MCTparas        := MCTparas;
          CalcPartThread[x - 1].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
          CalcPartThread[x - 1].CalcHardShadows := CalcHS;
          CalcPartThread[x - 1].DontTouchAmbShadow := DontTouchAS;
          CalcPartThread[x - 1].CalcOnlyNearerOnes := CalcOnlyNearer;
          CalcPartThread[x - 1].RSmulti         := 1 / RSdiv;
          MCalcThreadStats.CTrecords[x].isActive := 1;
        except
          ThreadCount := x - 1;
          Break;
        end;
      end;
      MCalcThreadStats.HandleType := 0;
      for x := 0 to ThreadCount - 1 do CalcPartThread[x].MCTparas.iThreadCount := ThreadCount;
      MCalcThreadStats.iTotalThreadCount := ThreadCount;
      for x := 0 to ThreadCount - 1 do CalcPartThread[x].Start;
      Label6.Caption := 'calc part';
      //wait for threads to finish
      repeat
        DelayCalcPart(ThreadCount, @MCalcThreadStats);
        x := 0;
        ymin := 999999;
        for y := 1 to ThreadCount do
        begin
          if MCalcThreadStats.CTrecords[y].isActive > 0 then Inc(x);
          ymin := Min(ymin, MCalcThreadStats.CTrecords[y].iActualYpos);
        end;
        ProgressBar1.Position := ymin - CalcR.Top;
      until (x = 0) or MCalcThreadStats.pLBcalcStop^;

      if CalcDEAO and not DontTouchAS then //why not in calcp thread? (slower?)
      begin
        Label6.Caption := 'ambient';
        if CalcAmbShadowDET(@MHeader, @MCalcThreadStats, @siLight5[CalcR.Top *
             GetTileSize(@MHeader).X + CalcR.Left], mSLoffset, MCTparas.CalcRect) then
        repeat
          DelayCalcPart(ThreadCount, @MCalcThreadStats);
          x := 0;
          ymin := 999999;
          for y := 1 to ThreadCount do 
          begin
            if MCalcThreadStats.CTrecords[y].isActive > 0 then Inc(x);
            ymin := Min(ymin, MCalcThreadStats.CTrecords[x].iActualYpos);
          end;
          ProgressBar1.Position := ymin - CalcR.Top;
        until (x = 0) or MCalcThreadStats.pLBcalcStop^;
      end;
      ProgressBar1.Visible := False;
      Label6.Caption := '';
      PaintRows(CalcR.Top, CalcR.Bottom);
    end;
end;

//#################  TCalcPartThread  ###################

procedure TCalcPartThread.Execute;
var itmp, x, y, seed: Integer;
    DElimited, bFirstStep, bCancel, bInsideTmp: LongBool;
    RStepFactorDiff, sTmp, StepCount: Single;
    RLastStepWidth, RLastDE, dTmp, dT1: Double;
begin
    with MCTparas do   
    try
      IniIt3D(@MCTparas, @Iteration3Dext);
{$IFDEF DEBUG} {$Q-} {$R-} {$ENDIF}
      seed := Round(Random * (iThreadId + 1) * $324594A1 + $24563487);
{$IFDEF DEBUG} {$Q+} {$R+} {$ENDIF}
      sZstepDiv := sZstepDiv * RSmulti;
      bInsideTmp := bInsideRendering;
      y := CalcRect.Top + iThreadId - 1;
      while y <= CalcRect.Bottom do
      begin
        x := CalcRect.Left;
        mPsiLight := TPsiLight5(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset);
        CAFY := (y / iMandHeight - 0.5) * FOVy;
        while x <= CalcRect.Right do
        begin
          RMCalculateVgradsFOV(@MCTparas, x + 1);
          RMCalculateStartPos(@MCTparas, x, y);
          Iteration3Dext.CalcSIT := False;
          bInsideRendering := bInsideTmp;
          bCalcInside := bInsideTmp;
          bCancel    := False;
          itmp       := 0;
          StepCount  := 0;
          mZZ        := 0;
          if not CalcOnlyNearerOnes then
          begin
            if not DontTouchAmbShadow then
            begin
              PCardinal(@mPsiLight.Zpos)^ := 32768;
              mPsiLight.AmbShadow := 5000;
            end
            else mPsiLight.Zpos := 32768;
          end;
          msDEstop   := DEStop;
          bFirstStep := bMCTFirstStepRandom;
          if iCutOptions > 0 then   // move to begin of cutting planes
          begin
            RMmaxLengthToCutPlane(@MCTparas, dT1, itmp, @Iteration3Dext.C1);
            if dT1 > (Zend - mZZ) then
            begin
              Iteration3Dext.ItResultI := 0;
              MaxItsResult := iMaxIt;
              dTmp := msDEstop + 5;
              mZZ  := Zend + 1;
            end else begin
              mZZ := dT1;
              mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, dT1);
              msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
              dTmp := CalcDE(@Iteration3Dext, @MCTparas);
            end;
          end
          else dTmp := CalcDE(@Iteration3Dext, @MCTparas);

          if bInAndOutside and (dTmp < msDEstop) then 
          begin
            bInsideRendering := False;
            bCalcInside := False;
            dTmp := CalcDE(@Iteration3Dext, @MCTparas);
          end;

          if (Iteration3Dext.ItResultI >= MaxItsResult) or (dTmp < msDEstop) then   // already in the set
          begin
            if ColorOnIt <> 0 then RMdoColorOnIt(@MCTparas);
            RMdoColor(@MCTparas);
            RMcalcNanglesForCut(@MCTparas, itmp);
            if ColorOption > 4 then
            begin
              mPsiLight.SIgradient := 32768 or mPsiLight.SIgradient;
            end
            else if bInsideRendering then
            begin
              Iteration3Dext.CalcSIT := True;
              CalcDE(@Iteration3Dext, @MCTparas);
              mPsiLight.SIgradient := 32768 + Round(MinCD(Iteration3Dext.SmoothItD * mctsM, 32767));
            end
            else
              mPsiLight.SIgradient := 32768 + Round(MinCD(32767, 32767 * Iteration3Dext.Rout / dRStop));
          end
          else
          begin
            RStepFactorDiff := 1;
            RLastStepWidth := dTmp * sZstepDiv;
            repeat
              if Iteration3Dext.ItResultI >= MaxItsResult then
              begin
                dT1 := sm05 * RLastStepWidth;
                mZZ := mZZ + dT1;
                mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, dT1);
                msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
                dTmp := CalcDE(@Iteration3Dext, @MCTparas);
                RLastStepWidth := - dT1;
              end;
              if (Iteration3Dext.ItResultI < iMinIt) or
                ((Iteration3Dext.ItResultI < MaxItsResult) and (dTmp >= msDEstop)) then    //##### next step ######
              begin
                RLastDE := dTmp;

           {     dTmp := dTmp * ZstepDiv * RStepFactorDiff;
                dT1 := MaxCS(msDEstop, 0.4) * mctMH04ZSD;
                if dT1 < dTmp then
                begin
                  if not bFirstStep then StepCount := StepCount + dT1 / dTmp else StepCount := StepCount + Random;
                  dTmp := dT1;
                end
                else StepCount := StepCount + 1; }
                dTmp := MaxCS(s011, (dTmp - msDEsub * msDEstop) * sZstepDiv * RStepFactorDiff);
          //      dTmp := dTmp * sZstepDiv * RStepFactorDiff;
                dT1 := MaxCS(msDEstop, 0.4) * mctMH04ZSD;
                if dT1 < dTmp then
                begin
                  if DFogOnIt = 0 then StepCount := StepCount + dT1 / dTmp else
                  if Iteration3Dext.ItResultI = DFogOnIt then StepCount := StepCount + dT1 / dTmp; 
                  dTmp := dT1;
                end
                else if DFogOnIt = 0 then StepCount := StepCount + 1 else
                  if Iteration3Dext.ItResultI = DFogOnIt then StepCount := StepCount + 1;

                if bFirstStep then
                begin
{$IFDEF DEBUG} {$Q-} {$R-} {$ENDIF}
                  seed := 214013 * seed + 2531011;
{$IFDEF DEBUG} {$Q+} {$R+} {$ENDIF}
                  bFirstStep := False;
                  dTmp := (seed and $7FFFFFFF) * dSeedMul * dTmp;
                end;
                RLastStepWidth := dTmp;
                mZZ := mZZ + dTmp;
                mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, dTmp);
                msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
                dTmp := CalcDE(@Iteration3Dext, @MCTparas);
                if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;
                if RLastDE > dTmp + s1em30 then
                begin
                  dT1 := RLastStepWidth / (RLastDE - dTmp);
                  if dT1 < 1 then
                    RStepFactorDiff := maxCS(s05, dT1)
                  else
                    RStepFactorDiff := 1;
                end
                else RStepFactorDiff := 1;
              end
              else     // ##### set found #####
              begin
                DElimited := (Iteration3Dext.ItResultI < MaxItsResult) or (dTmp < msDEstop);
                if iDEAddSteps > 0 then
                begin
                  if DElimited then RMdoBinSearch(@MCTparas, dTmp, RLastStepWidth)
                  else
                  begin
                    RMdoBinSearchIt(@MCTparas, mZZ);
                    CalcDE(@Iteration3Dext, @MCTparas);
                  end;
                end;
                if CalcOnlyNearerOnes then
                begin
                  if bInsideRendering then StepCount := StepCount * 200 * DEstop / iMandWidth;
                  if not DontTouchAmbShadow then
                  begin
                    if DFogOnIt = 65535 then mPsiLight.Shadow := (mPsiLight.Shadow and $FC00) or RMcalcVLight(StepCount) else
                    mPsiLight.Shadow := (mPsiLight.Shadow and $FC00) or Round(Min0MaxCS((StepCount - 1) * RSmulti + 1, 1023));
                  end;
                  if mPsiLight.Zpos < 32768 then
                  begin
                    dT1 := (Sqr((8388352 - (PInteger(@mPsiLight.RoughZposFine)^ shr 8)) / ZcMul + 1) - 1) / Zcorr;
                    if dT1 <= mZZ then
                    begin
                      bCancel := True;
                      Break;
                    end;  
                  end;  
                end;
                TCalculateNormalsFunc(pCalcNormals)(@MCTparas, sTmp);
                if DElimited then sTmp := 32767 - (sTmp + dColPlus + mctColVarDEstopMul * ln(MaxCS(DEstop, msDEstop) * StepWidth)) * mctsM
                             else sTmp := 32767 - sTmp * mctsM;
                MinMaxClip15bit(sTmp, mPsiLight.SIgradient);
                if ColorOnIt <> 0 then RMdoColorOnIt(@MCTparas);
                RMdoColor(@MCTparas);
                CalcZposAndRough(mPsiLight, @MCTparas, mZZ);
                if bInAndOutside and not bInsideRendering then
                  mPsiLight.OTrap := mPsiLight.OTrap or $8000;
                Break;
              end;
            until (mZZ > Zend) or PCalcThreadStats.pLBcalcStop^;
            if bInsideRendering then StepCount := StepCount * 200 * DEstop / iMandWidth;
            if not (DontTouchAmbShadow or CalcOnlyNearerOnes) then
              mPsiLight.Shadow := mPsiLight.Shadow or Round(Min0MaxCS((StepCount - 1) * RSmulti + 1, 1023));
          end;
          if not bCancel then
          begin
            if not DontTouchAmbShadow then mPsiLight.AmbShadow := 5000;
            mPsiLight.Shadow := mPsiLight.Shadow and (((calcHardShadow and $FC) shl 8) xor $FFFF);   //Reset all selected HS to 0
            if CalcHardShadows and (mPsiLight.Zpos < 32768) and (mPsiLight.SIgradient < 32768) then
            begin
              mZZ := mZZ - 0.1;                                     // step forward an amount
              mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, -0.1);
              CalcHS(@MCTparas, mPsiLight, y);
            end;
          end;
          Inc(mPsiLight);
          if PCalcThreadStats.pLBcalcStop^ then Break;
          Inc(x);
        end;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        PCalcThreadStats.CTrecords[iThreadId].iActualYpos := y;
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

