unit calcBlocky;

interface

uses
  Classes, Math3D, TypeDefinitions, Windows;

type
  TBlockCalcThread = class(TThread)
  private
    { Private-Deklarationen }
    Iteration3Dext: TIteration3Dext;
  public
    { Public-Deklarationen }
    MCTparas: TMCTparameter;    //PMCTparameter
  protected
    procedure Execute; override;
  end;
procedure CalcMandBlocky;

implementation

uses Math, Mand, HeaderTrafos, LightAdjust, DivUtils, PaintThread, Calc;

function CalcBlockyT(Header: TPMandHeader10; PLightVals: TPLightVals; PCTS: TPCalcThreadStats;
                     PsiLight5: TPsiLight5; hSLoffset, FSIstart, FSIoffset: Integer; hRect: TRect): Boolean;
var x, ThreadCount: Integer;
    MCTparas: TMCTparameter;
    BlockCalcThread: array of TBlockCalcThread;
begin
  Result := False;
  try
    ThreadCount := Min(Mand3DForm.UpDown3.Position, Header.Height);
    MCTparas    := getMCTparasFromHeader(Header^, True);
    Result      := MCTparas.bMCTisValid;
    if Result then
    begin
      MCTparas.pSiLight  := PsiLight5;
      MCTparas.FSIstart  := FSIstart;
      MCTparas.FSIoffset := FSIoffset;
      MCTparas.SLoffset  := hSLoffset;
      MCTparas.PLVals    := PLightVals;
      MCTparas.PCalcThreadStats := PCTS;
      MCTparas.CalcRect := hRect;
      SetLength(BlockCalcThread, ThreadCount);
    end;
  finally
  end;
  if Result then
  begin
    PCTS.ctCalcRect := hRect;//Rect(0, 0, Header.Width - 1, Header.Height - 1);
    for x := 1 to ThreadCount do
    begin
      PCTS^.CTrecords[x].iActualYpos := 0;
      PCTS^.CTrecords[x].iActualXpos := 0;
      PCTS^.CTrecords[x].i64DEsteps  := 0;
      PCTS^.CTrecords[x].iDEAvrCount := 0;
      PCTS^.CTrecords[x].i64Its      := 0;
      PCTS^.CTrecords[x].iItAvrCount := 0;
      MCTparas.iThreadId := x;
      try
        BlockCalcThread[x - 1] := TBlockCalcThread.Create(True);
        BlockCalcThread[x - 1].FreeOnTerminate := True;
        BlockCalcThread[x - 1].MCTparas := MCTparas;
        BlockCalcThread[x - 1].Priority := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
        PCTS.CTrecords[x].isActive := 1;
      except
        ThreadCount := x - 1;
        Break;
      end;
    end;
    PCTS.HandleType := 0;
    for x := 0 to ThreadCount - 1 do BlockCalcThread[x].MCTparas.iThreadCount := ThreadCount;
    PCTS^.iTotalThreadCount := ThreadCount;
    for x := 0 to ThreadCount - 1 do BlockCalcThread[x].Start;
  end;
end;

procedure CalcMandBlocky;
var PCTS: TPCalcThreadStats;
    i, c, y, LastY, LYt: Integer;
    PSLstart: TPsiLight5;
    CalcRect: TRect;
begin
    PCTS := @Mand3DForm.MCalcThreadStats;
    PSLstart := @Mand3DForm.siLight5[0];
    CalcRect := Mand3DForm.GetCalcRect;
    if CalcBlockyT(@Mand3DForm.MHeader, @Mand3DForm.HeaderLightVals, PCTS,
                   PSLstart, Mand3DForm.mSLoffset, mFSIstart, mFSIoffset, CalcRect) then
    begin
      //update image, valid vals are from[3,3] in 8pixel steps
      LastY := 3;
      repeat
        Delay(250);
        c := 0;
        y := CalcRect.Bottom - CalcRect.Top;
        for i := 1 to PCTS.iTotalThreadCount do if PCTS.CTrecords[i].isActive > 0 then
        begin
           Inc(c);
           y := Min(y, PCTS.CTrecords[i].iActualYpos - CalcRect.Top);
        end;
        LYt := LastY;
        if y > LastY then
        begin
          LastY := ((y - 3) and $FFF8) + 3;
          PaintRowsNoThreadBlocky(LYt - 3, Min(LastY + 4, CalcRect.Bottom - CalcRect.Top));
        end;
      until c = 0;
    end;
end;

procedure TBlockCalcThread.Execute;
var itmp, x, y, x2, y2: Integer;
    DElimited, bInsideTmp: LongBool;
    RSFmul, StepCount: Single;
    RLastStepWidth, dTmp, dT1, RLastDE: Double;
begin
    with MCTparas do
    try
      IniIt3D(@MCTparas, @Iteration3Dext);
      bInsideTmp := bInsideRendering;
      y := CalcRect.Top + iThreadId * 8 - 5;
      while y <= CalcRect.Bottom do
      begin
        mPsiLight := TPsiLight5(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset + 3 * SizeOf(TsiLight5));
        CAFY := (y / iMandHeight - s05) * FOVy;
        x := 3 + CalcRect.Left;
        while x <= CalcRect.Right do     //xstart to xend
        begin
          bInsideRendering := bInsideTmp;
          bCalcInside := bInsideTmp;
          RMCalculateVgradsFOV(@MCTparas, x + 1);
          RMCalculateStartPos(@MCTparas, x, y);
          PCardinal(@mPsiLight.Zpos)^ := 32768;       //was: access vio when tile
          mPsiLight.AmbShadow := 5000;
          Iteration3Dext.CalcSIT := False;
          itmp      := 0;
          StepCount := 0;
          mZZ       := 0;
          msDEstop  := DEstop;
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
              mPsiLight.SIgradient := 32768 or mPsiLight.SIgradient
            else if bInsideRendering then
            begin
              Iteration3Dext.CalcSIT := True;
              CalcDE(@Iteration3Dext, @MCTparas);
              mPsiLight.SIgradient := 32768 + Round(MinCD(Iteration3Dext.SmoothItD * mctsM, 32767));
            end
            else
              mPsiLight.SIgradient := 32768 + Round(MinCD(32767, 32767 * Iteration3Dext.Rout / dRStop)); //if insiderender: dRstop / Rout!
          end
          else
          begin
            RSFmul := 1;
            RLastStepWidth := dTmp * sZstepDiv;
            repeat
              if Iteration3Dext.ItResultI >= MaxItsResult then  // in the set while stepping
              begin
                dT1 := -0.5 * RLastStepWidth;  // step back
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

                RLastStepWidth := dTmp;
                mZZ := mZZ + dTmp;
                mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, dTmp);
                msDEstop := DEStop * (1 + mZZ * mctDEstopFactor);
                dTmp := CalcDE(@Iteration3Dext, @MCTparas);
                if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;
                if RLastDE > dTmp + s1em30 then
                begin
                  dT1 := RLastStepWidth / (RLastDE - dTmp);
                  if dT1 < 1 then RSFmul := maxCS(s05, dT1)
                             else RSFmul := 1;
                end
                else RSFmul := 1;
              end
              else     // ##### set found #####
              begin
                DElimited := (Iteration3Dext.ItResultI < MaxItsResult) or (dTmp < msDEstop);
                if iDEAddSteps > 0 then
                begin
                  if DElimited then RMdoBinSearch(@MCTparas, dTmp, RLastStepWidth{, RLastDE})
                               else RMdoBinSearchIt(@MCTparas, mZZ);
                end;
                TCalculateNormalsFunc(pCalcNormals)(@MCTparas, RSFmul);
                if DElimited then RSFmul := 32767 - (RSFmul + dColPlus + mctColVarDEstopMul * ln(msDEstop * StepWidth)) * mctsM
                             else RSFmul := 32767 - RSFmul * mctsM;
                MinMaxClip15bit(RSFmul, mPsiLight.SIgradient);
                if ColorOnIt <> 0 then RMdoColorOnIt(@MCTparas);
                RMdoColor(@MCTparas);
                CalcZposAndRough(mPsiLight, @MCTparas, mZZ);
                if bInAndOutside and not bInsideRendering then
                  mPsiLight.OTrap := mPsiLight.OTrap or $8000;
                Break;
              end;
            until (mZZ > Zend) or PCalcThreadStats.pLBcalcStop^;
            if bInsideRendering then StepCount := StepCount * 200 * DEstop / iMandWidth;
            mPsiLight.Shadow := mPsiLight.Shadow or Min(1023, Round(StepCount));
          end;
          for y2 := -3 to Min(4, CalcRect.Bottom - y) do
          for x2 := -3 to Min(4, CalcRect.Right - x) do
            FastMove(mPsiLight^, TPsiLight5(Integer(mPsiLight) + x2 * SizeOf(TsiLight5) + y2 * SLoffset)^, SizeOf(TsiLight5));
          Inc(x, 8);
          Inc(mPsiLight, 8);
          if PCalcThreadStats.pLBcalcStop^ then Break;
        end;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        PCalcThreadStats.CTrecords[iThreadId].iActualYpos := y;
        Inc(y, iThreadCount * 8);
      end;
    finally
      if not PCalcThreadStats.pLBcalcStop^ then
        PCalcThreadStats.CTrecords[iThreadId].iActualYpos := iMandHeight - 1;
      PCalcThreadStats.CTrecords[iThreadId].isActive := 0;
    end;
end;

end.
