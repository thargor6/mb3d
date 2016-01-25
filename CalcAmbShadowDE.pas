unit CalcAmbShadowDE;

interface

uses
  Classes, Math3D, TypeDefinitions, Windows;

type
  TCalcAmbShadowDEThreadGeneral = class(TThread)
  private
    Iteration3Dext: TIteration3Dext;
  //  VgradsFOV: TVec3D;
    Quality: Integer;   //0..3 = 3,6,16,32 rays
    Dither: Integer;    //0,1,2: 0:no  1: 2x2  2: 3x3
    seed: Integer;
 //   procedure CalculateVgradsFOV(ix: Integer);
  //  procedure doBinSearchIt(var ZZ: Double; RLastStepWidth: Double);
    function GetRand: Double;
  public
  //  CalcRect: TRect;
    MCTparas: TMCTparameter;
  protected
    procedure Execute; override;
  end;

  TCalcAmbShadowDEThreadGeneral2 = class(TThread) //only for test
  private
    Iteration3Dext: TIteration3Dext;
  //  VgradsFOV: TVec3D;
    Quality: Integer;
//    Dither: Integer;    //0,1,2: 0:no  1: 2x2  2: 3x3
    seed: Integer;
  //  procedure CalculateVgradsFOV(ix: Integer);
 //   procedure doBinSearchIt(var ZZ: Double; RLastStepWidth: Double);
    function GetRand: Double;
  public
  //  CalcRect: TRect;
    MCTparas: TMCTparameter;
  protected
    procedure Execute; override;
  end;

function CalcAmbShadowDET(Header: TPMandHeader10; PCTS: TPCalcThreadStats;
                          PsiLight5: TPsiLight5; aSLoffset: Integer; iRect: TRect): Boolean;

procedure CalcAmbShadowDEfor1pos(PMCT: PMCTparameter; It3Dex: TPIteration3Dext;
          mPsiLight: TPsiLight5; Quality, xx, yy: Integer);

implementation

uses Mand, Math, DivUtils, formulas, Forms, ImageProcess, CustomFormulas,
     HeaderTrafos, LightAdjust, Calc;


function CalcAmbShadowDET(Header: TPMandHeader10; PCTS: TPCalcThreadStats;
                          PsiLight5: TPsiLight5; aSLoffset: Integer; iRect: TRect): Boolean;
var x, ThreadCount, Quali: Integer;
    MCTparas: TMCTparameter;
    CalcAmbShadowDEThread: array of TCalcAmbShadowDEThreadGeneral;
begin
  Result := False;
  try
    Quali := (Header.bCalcAmbShadowAutomatic shr 4) and 3; //and 7
    ThreadCount := Min(Mand3DForm.UpDown3.Position, Header.Height);
    MCTparas := getMCTparasFromHeader(Header^, True);
    Result := MCTparas.bMCTisValid;
    if Result then
    begin
      MCTparas.bMCTFirstStepRandom := (Header.bCalcAmbShadowAutomatic and 128) <> 0; //FSR 0..7: SSAORcount?
      MCTparas.pSiLight := PsiLight5;
      MCTparas.SLoffset := aSLoffset;
      MCTparas.PCalcThreadStats := PCTS;
      MCTparas.CalcRect := iRect;
      SetLength(CalcAmbShadowDEThread, ThreadCount);
    end;
  finally
  end;
  if Result then
  begin
    PCTS.ctCalcRect := iRect;
    for x := 0 to ThreadCount - 1 do
    begin
      PCTS.CTrecords[x + 1].iActualYpos := iRect.Top - 1;
      PCTS.CTrecords[x + 1].iActualXpos := iRect.Left;
      MCTparas.iThreadId := x + 1;
      try
        CalcAmbShadowDEThread[x] := TCalcAmbShadowDEThreadGeneral.Create(True);
        CalcAmbShadowDEThread[x].FreeOnTerminate := True;
        CalcAmbShadowDEThread[x].MCTparas := MCTparas;
        CalcAmbShadowDEThread[x].Priority := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
        CalcAmbShadowDEThread[x].Quality := Quali;
     //   CalcAmbShadowDEThread[x].CalcRect := iRect;
        CalcAmbShadowDEThread[x].Dither := Header.AODEdithering;
      //  PCTS.CTprios[x + 1]   := Header.iThreadPriority;
        PCTS.CThandles[x + 1] := CalcAmbShadowDEThread[x];
        PCTS.CTrecords[x + 1].isActive := 1;
      except
        ThreadCount := x;
        Break;
      end;
    end;
    for x := 0 to ThreadCount - 1 do CalcAmbShadowDEThread[x].MCTparas.iThreadCount := ThreadCount;
    PCTS.HandleType := 1;
    PCTS.iTotalThreadCount := ThreadCount;
    PCTS.cCalcTime := GetTickCount;
    for x := 0 to ThreadCount - 1 do CalcAmbShadowDEThread[x].Start;
    Result := ThreadCount > 0;
  end;
end;

//### for all: if cutplanes>0 .. max DE,Lengthtocutplane

{function MaxLengthToCutPlane(MCTparas: PMCTparameter; Vec: TPSVec; vPos: TPPos3D): Double;
var dTmp: Double;
begin
    with MCTparas^ do
    begin
      Result := 0;
      if ((iCutOptions and 1) > 0) and (Abs(Vec[0]) > 1e-20) then
      begin
        dTmp := -(dCOX - vPos^[0]) / Vec[0];
        if dTmp > Result then Result := dTmp;
      end;
      if ((iCutOptions and 2) > 0) and (Abs(Vec[1]) > 1e-20) then
      begin
        dTmp := -(dCOY - vPos^[1]) / Vec[1];
        if dTmp > Result then Result := dTmp;
      end;
      if ((iCutOptions and 4) > 0) and (Abs(Vec[2]) > 1e-20) then
      begin
        dTmp := -(dCOZ - vPos^[2]) / Vec[2];
        if dTmp > Result then Result := dTmp;
      end;
    end;
end;  }

function MinLengthToCutPlane(MCTparas: PMCTparameter; Vec: TPSVec; vPos: TPPos3D): Double;
var dTmp: Double;
begin
    with MCTparas^ do
    begin
      Result := 1e31;
      if ((iCutOptions and 1) > 0) and (Abs(Vec[0]) > 1e-20) then
      begin
        dTmp := (dCOX - vPos^[0]) / Vec[0];
        if (dTmp > 0) and (dTmp < Result) then Result := dTmp;
      end;
      if ((iCutOptions and 2) > 0) and (Abs(Vec[1]) > 1e-20) then
      begin
        dTmp := (dCOY - vPos^[1]) / Vec[1];
        if (dTmp > 0) and (dTmp < Result) then Result := dTmp;
      end;
      if ((iCutOptions and 4) > 0) and (Abs(Vec[2]) > 1e-20) then
      begin
        dTmp := (dCOZ - vPos^[2]) / Vec[2];
        if (dTmp > 0) and (dTmp < Result) then Result := dTmp;
      end;
     // if Result > 1e30 then Result := 0;
    end;
end;

{function AtCutPlane(MCTparas: PMCTparameter; Vec: TPSVec; vPos: TPPos3D; const plusD: Double): LongBool;
var dTmp: Double;
begin
    with MCTparas^ do
    begin
      Result := False;
      if ((iCutOptions and 1) > 0) and (Abs(Vec[0]) > 1e-20) then
      begin
        dTmp := (dCOX - vPos^[0]) / Vec[0];
        Result := (dTmp > 0) and (dTmp < plusD);
      end;
      if not Result and ((iCutOptions and 2) > 0) and (Abs(Vec[1]) > 1e-20) then
      begin
        dTmp := (dCOY - vPos^[1]) / Vec[1];
        Result := (dTmp > 0) and (dTmp < plusD);
      end;
      if not Result and ((iCutOptions and 4) > 0) and (Abs(Vec[2]) > 1e-20) then
      begin
        dTmp := (dCOZ - vPos^[2]) / Vec[2];
        Result := (dTmp > 0) and (dTmp < plusD);
      end;
    end;
end;  }

function AtCutPlane2(MCTparas: PMCTparameter; vPos: TPPos3D; const plusD: Double): LongBool;
begin
    with MCTparas^ do
    begin
      Result := False;
      if (iCutOptions and 1) > 0 then
        Result := (Abs(vPos^[0] - dCOX) - plusD) < 0;
      if not Result and ((iCutOptions and 2) > 0) then
        Result := (Abs(vPos^[1] - dCOY) - plusD) < 0;
      if not Result and ((iCutOptions and 4) > 0) then
        Result := (Abs(vPos^[2] - dCOZ) - plusD) < 0;
    end;
  //(A (xa - xb) + B (ya - yb) + C (za - zb)) / sqrt(A*A + B*B + C*C)  :mindist point to plane  Point = Pa:(xa,ya,za)  Pb=point on plane
  //for x cutplane: A=1 B=0 C=0 D=-XCut
end;

//############## general method up to 32 rays #####################

{procedure TCalcAmbShadowDEThreadGeneral.doBinSearchIt(var ZZ: Double; RLastStepWidth: Double);
var dT1, dmul: Double;
    itmp, MItmp: Integer;
    LastSI, R, LastDif, YP: Single;
    firstIt: LongBool;
begin
    with Iteration3Dext do
    begin
      MItmp   := maxIt;
      YP      := maxIt - 0.99;
      Inc(maxIt, 1);
      itmp    := MCTparas.iDEAddSteps;
      CalcSIT := True;
      dT1     := 0;
      dmul    := 1;
      firstIt := True;
      repeat
        ZZ := ZZ + dT1;
        mAddVecWeight(@C1, @MCTparas.mVgradsFOV, dT1);
      //  MCTparas.mMandFunction(@C1);
        CalcDE(@Iteration3Dext, @MCTparas);
        if not firstIt then
        begin
          if LastDif < Abs(YP - SmoothItD) then
          begin
            ZZ := ZZ - dT1;
            mAddVecWeight(@C1, @MCTparas.mVgradsFOV, -dT1);
            SmoothItD := LastSI;
            if dT1 > 0 then dmul := dmul * 0.5
                       else dmul := dmul * 0.7;
          end;
        end;
        LastDif := Abs(YP - SmoothItD);
        LastSI  := SmoothItD;
        if SmoothItD > maxIt - 0.1 then dT1 := -0.6 else
        begin
          ZZ := ZZ - 0.001;
          mAddVecWeight(@C1, @MCTparas.mVgradsFOV, -0.001);
       //   MCTparas.mMandFunction(@C1);
          CalcDE(@Iteration3Dext, @MCTparas);
          R := LastSI - SmoothItD;
          if Abs(R) < 1e-30 then
            dT1 := Integer(LastSI < SmoothItD) - 0.5
          else if R < 0 then dT1 := (YP - SmoothItD) / (R * 500)
                        else dT1 := (YP - SmoothItD) / (R * 1000);

          if dT1 >  4 then dT1 := Sqrt(dT1) * 2 else
          if dT1 < -9 then dT1 := Sqrt(-dT1) * -3;
          dT1 := dT1 * dmul + 0.0005;
        end;
        firstIt := False;
        Dec(itmp);
      until
        (itmp < 0);
      maxIt := MItmp;
    end;
end;     }

{procedure TCalcAmbShadowDEThreadGeneral.CalculateVgradsFOV(ix: Integer);
begin
    with MCTparas do
    begin
      CAFX := (0.5 * iMandWidth - ix) * FOVy / iMandHeight;
      if bMCTPlanarOptic then
      begin
        VgradsFOV[0] := -CAFX;
        VgradsFOV[1] := CAFY;
        VgradsFOV[2] := mctPlOpticZ;
        NormaliseVectorVar(VgradsFOV);
      end else begin
        BuildViewVectorDFOV(CAFY, CAFX, @VgradsFOV);
      end;
      RotateVectorReverse(@VgradsFOV, @VGrads);
    end;
end;  }

function TCalcAmbShadowDEThreadGeneral.GetRand: Double;
const dm: Double = 1 / $7FFFFF;
{begin
    seed := 214013 * seed + 2531011;
    Result := ((seed shr 16) and $7FFF) * 0.000030517578125; }
asm
  add  esp, -4
  imul edx, [eax + seed], $343FD
  add  edx, $269EC3
  mov  [eax + seed], edx
  shr  edx, 8
  and  edx, $7FFFFF
  mov  [esp], edx
  fild dword [esp]
  fmul dm
  add  esp, 4
end;

procedure TCalcAmbShadowDEThreadGeneral.Execute;
var itmp, itmp2, x, y, RayCount: Integer;
    mPsiLight: TPsiLight5;
    DElimited, bEnd, bFirstStep, bInsideTmp: LongBool;
    StepAO, DEmul, DStepMul, sMaxD, MDd10, Amul, Apow: Single;

    CorrectionWeight, MaxAdd, Overlap, ABR, sTmp, sDT1mul: Single;
    sAdd: array[0..32] of Single;
    minRA: array[0..32] of Single;

    dTmp, dT1, dT2, ZZ, dMinADif: Double;
    dAmount, dStartDE, MaxDist{, MaxDistV}: Double;
    IC: TVec3D;
    SVec: TSVec;
    Quat: TQuaternion;
    RotV, RotW: TSMatrix3;
    RotM: array[0..32] of TSVec;
    RowCount: array[1..4] of Integer;
begin
    with MCTparas do
    try
      IniIt3D(@MCTparas, @Iteration3Dext);
      DEstop := msDEstop;
      Iteration3Dext.CalcSIT := False;
{$IFDEF DEBUG}
{$Q-}
{$R-}
{$ENDIF}
      seed := Round(Random * (iThreadId + 1) * $324594A1 + $24563487);
{$IFDEF DEBUG}
{$Q+}
{$R+}
{$ENDIF}
      bInsideTmp := bInsideRendering;
      iDEAddSteps := 5;
      RotV := NormaliseMatrixToS(StepWidth, @VGrads);
      sDT1mul := StepWidth * s05;
      bIsIFS := False;  //test, to dark with inside rendering+ifs

      RayCount := 0;     //  Build ray vectors
      if Quality = 0 then
      begin
        ABR := 60 * Pid180;
        for x := 0 to 2 do
        begin
          BuildRotMatrixS(0, 0.5 * ABR, x * PiM2 * s1d3, @RotW);
          RotM[RayCount] := ScaleSVector(TSVec(RotW[2]), -1);
          Inc(RayCount);
        end;
        DStepMul := 1.8;
        dMinADif := -1;
        CorrectionWeight := 0.3;
      end
      else
      begin
        BuildRotMatrixS(0, 0, 0, @RotW);  //one straight ray in normals direction
        RotM[0] := ScaleSVector(TSVec(RotW[2]), -1);
        RayCount := 1;
        ABR := Pi * 0.5 / (Quality + 0.9);  //angle between rows
        for y := 1 to Quality do         //next rows of rays
        begin
          dT1 := y * ABR;  //angle of row relative to straight normals ray
          itmp := Round(Sin(dT1) * Pi * 2 / ABR); //RowCount90deg[Quality] - 0.05); //count of rays in this row
          RowCount[y] := itmp;
          for x := 0 to itmp - 1 do
          begin
            BuildRotMatrixS(0, dT1, x * 2 * Pi / itmp, @RotW);
            RotM[RayCount] := ScaleSVector(TSVec(RotW[2]), -1);
            Inc(RayCount);
          end;
        end;
        DStepMul := 1 + Sin(ABR);
        dMinADif := Cos(ABR * 1.2);
        if Quality = 1 then CorrectionWeight := 0.2 else CorrectionWeight := 0.1666;
      end;
      sMaxD := DEAOmaxL * s05 * Sqrt(Sqr(iMandHeight) + Sqr(iMandWidth));  //maxLengthMultiplier

      y := iThreadId - 1 + CalcRect.Top;
      while y <= CalcRect.Bottom do
      begin
        PCalcThreadStats.CTrecords[iThreadID].iActualYpos := y;
        x := CalcRect.Left;
        mPsiLight := TPsiLight5(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset);
        CAFY := (y / iMandHeight - s05) * FOVy;
        while x <= CalcRect.Right do
        begin
          PCalcThreadStats.CTrecords[iThreadID].iActualXpos := x;
          mPsiLight.AmbShadow := 0;
                 //option AO on BG             //inside, no Shadow  (if cut-option "and" other cutplanes, this has to be considered)
          if (mPsiLight.Zpos < 32768) and (mPsiLight.SIgradient < 32768) then
          begin
            RMCalculateVgradsFOV(@MCTparas, x + 1);
            RMCalculateStartPos(@MCTparas, x, y);
            Iteration3Dext.CalcSIT := False;
            ZZ := (Sqr((8388351.5 - (PInteger(@mPsiLight.RoughZposFine)^ shr 8)) / ZcMul + 1) - 1) / Zcorr;
            mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, ZZ);
            msDEstop := DEstop * (1 + ZZ * mctDEstopFactor);

            if bInAndOutside then bInsideRendering := (mPsiLight.OTrap and $8000) = 0
                             else bInsideRendering := bInsideTmp;
            bCalcInside := bInsideRendering;
         //       if bInAndOutside and not bInsideRendering then   //..in calcthread
           //       mPsiLight.OTrap := mPsiLight.OTrap or $8000;

            dTmp := CalcDE(@Iteration3Dext, @MCTparas);
            if dTmp > msDEstop * 2 then dTmp := msDEstop * 2;
          //  DElimited := Iteration3Dext.ItResultI < MaxItsResult;
            DElimited := (Iteration3Dext.ItResultI < MaxItsResult) or (dTmp < msDEstop);
            if DElimited then
            begin
              itmp := 5;      //bin search
              dT1 := (Sqr((8388351.9 - (PInteger(@mPsiLight.RoughZposFine)^ shr 8)) / ZcMul + 1) - 1) / Zcorr - ZZ;
              while (itmp > 0) and (Abs(dTmp - msDEstop) > 0.004) do
              begin
                ZZ := ZZ + dT1;
                mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, dT1);
                msDEstop := DEstop * (1 + ZZ * mctDEstopFactor);
                Dec(itmp);
                if itmp > 0 then
                begin
                  dTmp := CalcDE(@Iteration3Dext, @MCTparas);
                  if dTmp < msDEstop then dT1 := Abs(dT1) * -0.55
                                     else dT1 := Abs(dT1) * 0.55;
                end;
              end;
            end
            else
            begin
              RMdoBinSearchIt(@MCTparas, ZZ);
              msDEstop := DEstop * (1 + Abs(ZZ) * mctDEstopFactor);
            end;
            msDEstop := MinCS(msDEstop, 1e6);
            mCopyVec(@IC, @Iteration3Dext.C1);
            StepAO := msDEstop / DEstop;
            MaxDist := sMaxD * Sqrt(StepAO);
            if bVaryDEstop then
            begin
              if (not bInsideRendering) or bIsIFS then msDEstop := msDEstop / Sqr(DStepMul);
            end
            else msDEstop := DEstop / Sqr(DStepMul);

            if Dither > 0 then
            begin
              dT1 := (y mod (Dither + 1)) * s05 / Dither;
              dT2 := (x mod (Dither + 1)) * s05 / Dither;
              if Quality = 0 then
              begin
            //    ABR := (dT1 * 0.2 + 0.8) * 60 * Pid180;
          //      DEmul := 1 / Sin(ABR * 0.6);
                for itmp := 0 to 2 do
                begin
                {  seed := 214013 * seed + 2531011;
                  BuildRotMatrixS(0, (((seed shr 16) and $FF) * 0.0031372 + 0.1) * 60 * Pid180,
                                  (itmp + ((seed shr 8) and $FF) * 0.0039216 - 0.5) * 2 * Pi / 3, @RotW); }
                  BuildRotMatrixS(0, (dT1 + s05) * 50 * Pid180, (itmp + dT2) * PiM2 * s1d3, @RotW);
                  RotM[itmp] := ScaleSVector(TSVec(RotW[2]), -1);
                end;
              end
              else
              begin
                if dT1 > 0.1 then RayCount := 1 else RayCount := 0;
             //   RayCount := (y and 1); // dont use middle ray if rows shifted towards it     (rows(y and 1)=0 are more light)
             //   if Quality = 1 then CorrectionWeight := 0.15 else CorrectionWeight := 0.12;
          //      if Quality = 1 then sRg := 0.87 - RayCount * 0.3 else sRg := 0.933 - RayCount * 0.3;
          //      seed := 214013 * seed + 2531011;
                ABR := Pi * s05 / (Quality + 0.9);  //angle between rows
                BuildRotMatrixS(0, 0, 0, @RotW);
                RotM[0] := ScaleSVector(TSVec(RotW[2]), -1);
                for itmp2 := 1 to Quality do
                begin
                  for itmp := 0 to RowCount[itmp2] - 1 do
                  begin
       //             seed := 214013 * seed + 2531011;
//                    BuildRotMatrixS(0, ABR * (itmp2 + ((seed shr 16) and $FF) * 0.0039216 - 0.5),
  //                                  (itmp + ((seed shr 8) and $FF) * 0.0039216 - 0.5) * 2 * Pi / RowCount[itmp2], @RotW);
                    BuildRotMatrixS(0, ABR * (itmp2 + dT1 - 0.25), (itmp + dT2) * PiM2 / RowCount[itmp2], @RotW);
                    RotM[RayCount] := ScaleSVector(TSVec(RotW[2]), -1);
                    Inc(RayCount);
                  end;
                end;
            //    iTopA := 16383 - Round(3000 / (RayCount + 2));
              end;
          //    ABR := 1 / ABR;
            end;

            DEmul := Sqrt(RayCount * s05);
            ABR := 1.2 / ArcSinSafe(1 / DEmul);
            MDd10 := 0.1 / (MaxDist * DEmul);

            if bInsideRendering and not bIsIFS then DEmul := 1;

            SVec[0] := mPsiLight.NormalX;
            SVec[1] := mPsiLight.NormalY;
            SVec[2] := mPsiLight.NormalZ;
            NormaliseSVectorVar(SVec);
            Quat := MakeRotQuatFromSNormals(SVec);
            CreateSMatrixFromQuat(RotW, Quat);
            for itmp := 0 to RayCount - 1 do
            begin
              SVec := RotM[itmp];
              RotateSVectorReverseS(@SVec, @RotW); //rotate halfsphere vec to normal vec
              RotateSVectorS(@SVec, @RotV);     //rotate to abs vec with vgrads

           //   MaxDistV := MaxDist;
          //    if iCutOptions > 0 then MaxDistV := MaxCD(0, MinCD(MaxDistV, MinLengthToCutPlane(@MCTparas, @SVec, @IC)));

              dT1 := StepAO * DStepMul;
              sTmp := 1;
              bEnd := False;
              bFirstStep := bMCTFirstStepRandom;
              repeat
                if bFirstStep then
                begin
                  bFirstStep := False;
                  dT1 := dT1 * (GetRand * 1.5 + s05);
                end
                else if dT1 > maxDist then
                begin
                  dT1 := maxDist; //to make shure that all rays go max til the same distance to avoid artifacts from the last position.
                  bEnd := True;
                end;
                CopyAddSVecWeight(@Iteration3Dext.C1, @IC, @SVec, dT1);
                if (iCutOptions > 0) and AtCutPlane2(@MCTparas, @Iteration3Dext.C1, dT1 * sDT1mul) then Break;
                dT2 := CalcDE(@Iteration3Dext, @MCTparas);   //  @SVec{      rotv[2] = midpos viewvec?
                if bInsideRendering and not bIsIFS then      //Result := ((C1 - dCOX) / Vec[0]) - plusD < 0;
                begin                                        //MinLengthToCutPlane(MCTparas: PMCTparameter; Vec: TPSVec; vPos: TPPos3D): Double;
                  if dT2 < msDEstop then
                  begin
                    sTmp := Sqr(Sqr(dT1 / maxDist));
                    Break;
                  end;
                  dT1 := dT1 + dT1 * DStepMul * 0.1 + msDEstop;// * 2;
                end
                else
                begin
                  sTmp := MinCS(sTmp, (dT2 - msDEstop + dT1 * MDd10) / dT1);
                  if sTmp < s002 then Break;
                  dT1 := dT1 + Max(dT2, dT1 * DStepMul);
                end;
              until bEnd;
              minRA[itmp] := Max0S(sTmp) * DEmul;
            end;

            dAmount := 0;

            if bInsideRendering and not bIsIFS then
            begin
              for itmp := 0 to RayCount - 1 do dAmount := dAmount + minRA[itmp];
            end
            else
            begin
              for itmp := 0 to RayCount - 1 do   //correction
              begin
                SVec := RotM[itmp];
                sAdd[itmp] := 0;
                if minRA[itmp] < 1 then
                begin
                  MaxAdd := 1 - minRA[itmp];
                  for itmp2 := 0 to RayCount - 1 do if itmp2 <> itmp then
                  begin
                    dTmp := DotOfSVectors(SVec, RotM[itmp2]);
                    if dTmp > dMinADif then
                    begin                      //(90°) 0 -> Pi*0.5 (0°)
                    //  Overlap := minRA[itmp2] - ArcCosSafe(dTmp) * ABR; //   ABR=recip. angle between rows
                      Overlap := minRA[itmp2] - ArcCosSafe(dTmp) * ABR + 1;
                      if Overlap > 0 then sAdd[itmp] := sAdd[itmp] + MinCS(MaxAdd, Overlap) * CorrectionWeight;  //CW: recip. of raycount of neighbours
                    end;
                  end;
                end;
              end;
              for itmp := 0 to RayCount - 1 do dAmount := dAmount + MinCS(1, (sAdd[itmp] + minRA[itmp]));
            end;
            mPsiLight.AmbShadow := Max(0, Round(16383 * (1 - dAmount / RayCount)));  //todo: FSR 0..7: n times calc + average
          end;
          Inc(x);
          Inc(mPsiLight);
          if PCalcThreadStats.pLBcalcStop^ then Break;
        end;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        Inc(y, iThreadCount);
      end;
    finally
      if not PCalcThreadStats.pLBcalcStop^ then
        PCalcThreadStats.CTrecords[iThreadID].iActualYpos := iMandHeight;
      PCalcThreadStats.CTrecords[iThreadID].isActive := 0;
      PostMessage(PCalcThreadStats.pMessageHwnd, WM_ThreadReady, 0, 0);
    end;
end;

procedure CalcAmbShadowDEfor1pos(PMCT: PMCTparameter; It3Dex: TPIteration3Dext;   //used only by Reflections so far
                   mPsiLight: TPsiLight5; Quality, xx, yy: Integer);  //with dithering = 0
var itmp, ix, iy, RayCount: Integer;
    DElimited, bEnd, bFirstStep: LongBool;
    StepAO, DEmul, DStepMul, sMaxD, MDd10, Amul, Apow: Single;
    CorrectionWeight, MaxAdd, Overlap, ABR, sTmp, sDT1mul: Single;
    sAdd: array[0..32] of Single;
    minRA: array[0..32] of Single;
    dTmp, dT1, dT2, dMinADif: Double;
    dAmount, dStartDE, MaxDist: Double;
    IC, CC: TVec3D;
    SVec: TSVec;
    Quat: TQuaternion;
    RotV, RotW: TSMatrix3;
    RotM: array[0..32] of TSVec;
begin
    mPsiLight.AmbShadow := 0;

             //option AO on BG             //inside, no Shadow  (if cut-option "and" other cutplanes, this has to be considered)
    if (mPsiLight.Zpos < 32768) and (mPsiLight.SIgradient < 32768) then
    with PMCT^ do
    begin
        It3Dex.CalcSIT := False;
        RotV := NormaliseMatrixToS(StepWidth, @VGrads);
        sMaxD := DEAOmaxL * s05 * Sqrt(Sqr(iMandHeight) + Sqr(iMandWidth));  //maxLengthMultiplier
        sDT1mul := StepWidth * s05;
        bIsIFS := False;  //test, inside IFS still wrong

        msDEstop  := MinCS(DEstop * (1 + Abs(mZZ) * mctDEstopFactor), 1e6);
        mCopyVec(@IC, @It3Dex.C1);

        StepAO := msDEstop / DEstop;
        MaxDist := sMaxD * Sqrt(StepAO);

        if AOdither > 0 then
        begin
          dT1 := (yy mod (AOdither + 1)) * s05 / AOdither;
          dT2 := (xx mod (AOdither + 1)) * s05 / AOdither;
        end
        else
        begin
          dT1 := 0.25;
          dT2 := 0;
        end;
        if Quality = 0 then
        begin
          RayCount := 3;
          ABR := 60 * Pid180;
          for itmp := 0 to 2 do
          begin
            if AOdither > 0 then
              BuildRotMatrixS(0, (dT1 + s05) * 50 * Pid180, (itmp + dT2) * PiM2 * s1d3, @RotW)
            else
              BuildRotMatrixS(0, s05 * ABR, itmp * PiM2 * s1d3, @RotW);
            RotM[itmp] := ScaleSVector(TSVec(RotW[2]), -1);
          end;
          DStepMul := 1.8;
          dMinADif := -1;
          CorrectionWeight := s03;
        end
        else
        begin
          ABR := Pi * s05 / (Quality + 0.9);     //angle between rows
          if dT1 < 0.1 then RayCount := 0 else
          begin
            RayCount := 1;
            BuildRotMatrixS(0, 0, 0, @RotW);
            RotM[0] := ScaleSVector(TSVec(RotW[2]), -1);
          end;
          for iy := 1 to Quality do
          begin
            itmp := Round(Sin(dT1) * PiM2 / ABR);
            for ix := 0 to itmp - 1 do
            begin
              BuildRotMatrixS(0, ABR * (iy + dT1 - 0.25), (ix + dT2) * PiM2 / itmp, @RotW);
              RotM[RayCount] := ScaleSVector(TSVec(RotW[2]), -1);
              Inc(RayCount);
            end;
          end;
          DStepMul := 1 + Sin(ABR);
          dMinADif := Cos(ABR * 1.2);
          if Quality = 1 then CorrectionWeight := 0.2 else CorrectionWeight := 0.1666;   
        end;
        if bInsideRendering and not bIsIFS then DStepMul := DStepMul * s05;

        SVec := MakeSVecFromNormals(mPsiLight);
        Quat := MakeRotQuatFromSNormals(SVec);
        CreateSMatrixFromQuat(RotW, Quat);

        if bVaryDEstop then
        begin
          if (not bInsideRendering) or bIsIFS then msDEstop := msDEstop / Sqr(DStepMul);
        end
        else msDEstop := DEstop / Sqr(DStepMul);

        if bInsideRendering and not bIsIFS then DEmul := 1 else DEmul := Sqrt(RayCount * s05);
        ABR := 1.2 / ArcSinSafe(1 / DEmul);  //ArcSin generated bugs?
        MDd10 := 0.1 / (MaxDist * DEmul);

        for ix := 0 to RayCount - 1 do
        begin
          SVec := RotM[ix];
          RotateSVectorReverseS(@SVec, @RotW);
          RotateSVectorS(@SVec, @RotV);
          dT1 := StepAO * DStepMul;
          sTmp := 1;
          bEnd := False;
          bFirstStep := bMCTFirstStepRandom;
          repeat
            if bFirstStep then
            begin
              bFirstStep := False;
              dT1 := dT1 * (Random * 1.5 + s05);
            end
            else if dT1 > maxDist then
            begin
              dT1 := maxDist; //to make shure that all rays go max til the same distance to avoid artifacts from the last position.
              bEnd := True;
            end;
            CopyAddSVecWeight(@It3Dex.C1, @IC, @SVec, dT1);
            if (iCutOptions > 0) and AtCutPlane2(PMCT, @It3Dex.C1, dT1 * sDT1mul) then Break;
            dT2 := CalcDE(It3Dex, PMCT);           //    @RotV[2],

            if bInsideRendering and not bIsIFS then  //and not DEoption = 20! dIFS like normal...
            begin
              if dT2 < msDEstop then
              begin
                sTmp := Sqr(Sqr(dT1 / maxDist));  //maxdist=-NAN! on inout abox+ifs
                Break;
              end;
              dT1 := dT1 + dT1 * DStepMul * 0.1 + msDEstop;// * 2;   dt1=-inf! on inout abox+ifs
            end
            else
            begin
              sTmp := MinCS(sTmp, (dT2 - msDEstop + dT1 * MDd10) / dT1);
              if sTmp < s002 then Break;
              dT1 := dT1 + Max(dT2, dT1 * DStepMul);
            end;
          until bEnd;
          minRA[ix] := Max0S(sTmp) * DEmul;
        end;

        dAmount := 0;

        if bInsideRendering and not bIsIFS then
        begin
          for iy := 0 to RayCount - 1 do dAmount := dAmount + minRA[iy];
        end
        else
        begin

        for iy := 0 to RayCount - 1 do   //correction
        begin
          SVec := RotM[iy];
          sAdd[iy] := 0;
          if minRA[iy] < 1 then
          begin
            MaxAdd := 1 - minRA[iy];
            for ix := 0 to RayCount - 1 do if ix <> iy then
            begin
              dTmp := DotOfSVectors(SVec, RotM[ix]);
              if dTmp > dMinADif then
              begin                      //(90°) 0 -> Pi*0.5 (0°)
                Overlap := minRA[ix] - ArcCosSafe(dTmp) * ABR + 1;
                if Overlap > 0 then sAdd[iy] := sAdd[iy] + MinCS(MaxAdd, Overlap) * CorrectionWeight;  //CW: recip. of raycount of neighbours
              end;
            end;
          end;
        end;
        for iy := 0 to RayCount - 1 do dAmount := dAmount + MinCS(1, (sAdd[iy] + minRA[iy]));

        end;

        mPsiLight.AmbShadow := Max(0, Round(16383 * (1 - dAmount / RayCount)));
        mCopyVec(@It3Dex.C1, @IC);
    end;
end;

{------------version with fixed fullsphere rays---------------}

{procedure TCalcAmbShadowDEThreadGeneral2.doBinSearchIt(var ZZ: Double; RLastStepWidth: Double);
var dT1, dmul: Double;
    itmp, MItmp: Integer;
    LastSI, R, LastDif, YP: Single;
    firstIt: LongBool;
begin
    with Iteration3Dext do
    begin
      MItmp   := maxIt;
      YP      := maxIt - 0.99;
      Inc(maxIt, 1);
      itmp    := MCTparas.iDEAddSteps;
      CalcSIT := True;
      dT1     := 0;
      dmul    := 1;
      firstIt := True;
      repeat
        ZZ := ZZ + dT1;
        mAddVecWeight(@C1, @MCTparas.mVgradsFOV, dT1);
      //  MCTparas.mMandFunction(@C1);
        CalcDE(@Iteration3Dext, @MCTparas);
        if not firstIt then
        begin
          if LastDif < Abs(YP - SmoothItD) then
          begin
            ZZ := ZZ - dT1;
            mAddVecWeight(@C1, @MCTparas.mVgradsFOV, -dT1);
            SmoothItD := LastSI;
            if dT1 > 0 then dmul := dmul * 0.5
                       else dmul := dmul * 0.7;
          end;
        end;
        LastDif := Abs(YP - SmoothItD);
        LastSI  := SmoothItD;
        if SmoothItD > maxIt - 0.1 then dT1 := -0.6 else
        begin
          ZZ := ZZ - 0.001;
          mAddVecWeight(@C1, @MCTparas.mVgradsFOV, -0.001);
       //   MCTparas.mMandFunction(@C1);
          CalcDE(@Iteration3Dext, @MCTparas);
          R := LastSI - SmoothItD;
          if Abs(R) < 1e-30 then
            dT1 := Integer(LastSI < SmoothItD) - 0.5
          else if R < 0 then dT1 := (YP - SmoothItD) / (R * 500)
                        else dT1 := (YP - SmoothItD) / (R * 1000);

          if dT1 >  4 then dT1 := Sqrt(dT1) * 2 else
          if dT1 < -9 then dT1 := Sqrt(-dT1) * -3;
          dT1 := dT1 * dmul + 0.0005;
        end;
        firstIt := False;
        Dec(itmp);
      until
        (itmp < 0);
      maxIt := MItmp;
    end;
end;

{procedure TCalcAmbShadowDEThreadGeneral2.CalculateVgradsFOV(ix: Integer);
begin
    with MCTparas do
    begin
      CAFX := (0.5 * iMandWidth - ix) * FOVy / iMandHeight;
      if bMCTPlanarOptic then
      begin
        VgradsFOV[0] := -CAFX;
        VgradsFOV[1] := CAFY;
        VgradsFOV[2] := mctPlOpticZ;
        NormaliseVectorVar(VgradsFOV);
      end else begin
        BuildViewVectorDFOV(CAFY, CAFX, @VgradsFOV);
      end;
      RotateVectorReverse(@VgradsFOV, @VGrads);
    end;
end;  }

function TCalcAmbShadowDEThreadGeneral2.GetRand: Double;
const dm: Double = 1 / $7FFFFF;
asm
  add  esp, -4
  imul edx, [eax + seed], $343FD
  add  edx, $269EC3
  mov  [eax + seed], edx
  shr  edx, 8
  and  edx, $7FFFFF
  mov  [esp], edx
  fild dword [esp]
  fmul dm
  add  esp, 4
end;

procedure TCalcAmbShadowDEThreadGeneral2.Execute;
var itmp, itmp2, x, y, RayCount: Integer;
    mPsiLight: TPsiLight5;
    DElimited, bEnd, bFirstStep: LongBool;
    StepAO, DEmul, DStepMul, sMaxD, MDd10, Amul, Apow: Single;
    CorrectionWeight, MaxAdd, Overlap, ABR, sTmp: Single;
//    sAdd: array[0..32] of Single;
//    minRA: array[0..32] of Single;
    dTmp, dT1, dT2, ZZ, dMinADif: Double;
    dAmount, dStartDE, MaxDist: Double;
    IC, CC: TVec3D;
    SVec: TSVec;
    RotSM: TSMatrix3;
    Vecs: array of TSVec;
const
    c0p02: Single = 0.02;
begin
    with MCTparas do
    try
      IniIt3D(@MCTparas, @Iteration3Dext);
      DEstop := msDEstop;
      Iteration3Dext.CalcSIT := False;
   //   seed := Round(Random * $324594A1 + $24563487);
      seed := Round(Random * (iThreadId + 1) * $324594A1 + $24563487);
      iDEAddSteps := 5;

      RayCount := (1 shl Quality) * 8;  //Build ray vectors  8, 16, 32, 64
      SetLength(Vecs, RayCount);
      for x := 0 to RayCount - 1 do
      begin
     //   BuildRotMatrixS(0, 0.5 * ABR, x * 2 * Pi / 3, @RotW);
  //      Vecs[x] := ScaleSVector(TSVec(RotW[2]), StepWidth);
      end;
      DStepMul := 1 + (3 - Quality) * 0.25;
 //     dMinADif := -1;
  //    CorrectionWeight := 0.2;

{        ABR := Pi * 0.5 / (Quality + 0.9);  //angle between rows
        for y := 1 to Quality do         //next rows of rays
        begin
          dT1 := y * ABR;  //angle of row relative to straight normals ray
          itmp := Round(Sin(dT1) * Pi * 2 / ABR); //RowCount90deg[Quality] - 0.05); //count of rays in this row
          RowCount[y] := itmp;
          for x := 0 to itmp - 1 do
          begin
            BuildRotMatrixS(0, dT1, x * 2 * Pi / itmp, @RotW);
            RotM[RayCount] := ScaleSVector(TSVec(RotW[2]), -1);
            Inc(RayCount);
          end;
        end;
        DStepMul := 1 + Sin(ABR);
        dMinADif := Cos(ABR * 1.2);
        if Quality = 1 then CorrectionWeight := 0.2 else CorrectionWeight := 0.1666;
      end;   }

      sMaxD := DEAOmaxL * Sqrt(Sqr(iMandHeight) + Sqr(iMandWidth)) * s05;

      y := iThreadId - 1 + CalcRect.Top;
      while y <= CalcRect.Bottom do
      begin
        PCalcThreadStats.CTrecords[iThreadID].iActualYpos := y;
        x := CalcRect.Left;
        mPsiLight := TPsiLight5(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset);
        CAFY := (y / iMandHeight - s05) * FOVy;
        mCopyAddVecWeight(@CC, @Ystart, @Vgrads[1], y);
        while x <= CalcRect.Right do
        begin
          PCalcThreadStats.CTrecords[iThreadID].iActualXpos := x;
          mPsiLight.AmbShadow := 0;
                 //option AO on BG             //inside, no Shadow  (if cut-option "and" other cutplanes, this has to be considered)
          if (mPsiLight.Zpos < 32768) and (mPsiLight.SIgradient < 32768) then
          begin
            RMCalculateVgradsFOV(@MCTparas, x + 1);
            mCopyAddVecWeight(@Iteration3Dext.C1, @CC, @Vgrads[0], x);
            Iteration3Dext.CalcSIT := False;
            ZZ := (Sqr((8388351.5 - (PInteger(@mPsiLight.RoughZposFine)^ shr 8)) / ZcMul + 1) - 1) / Zcorr;
            mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, ZZ);
            msDEstop := DEStop * (1 + ZZ * mctDEstopFactor);
            dTmp     := CalcDE(@Iteration3Dext, @MCTparas);  //can be +NAN? -> endless loop
            if dTmp > msDEstop * 2 then dTmp := msDEstop * 2;
          //  DElimited := Iteration3Dext.ItResultI < MaxItsResult;
            DElimited := (Iteration3Dext.ItResultI < MaxItsResult) or (dTmp < msDEstop);
            if DElimited then
            begin
              itmp := 5;      //bin search
              itmp2 := iMaxit;
              iMaxit := Iteration3Dext.ItResultI;
              dT1 := (Sqr((8388351.9 - (PInteger(@mPsiLight.RoughZposFine)^ shr 8)) / ZcMul + 1) - 1) / Zcorr - ZZ;
              while (itmp > 0) and (Abs(dTmp - msDEstop) > 0.004) do
              begin
                ZZ := ZZ + dT1;
                mAddVecWeight(@Iteration3Dext.C1, @mVgradsFOV, dT1);
                msDEstop := DEStop * (1 + ZZ * mctDEstopFactor);
                Dec(itmp);
                if itmp > 0 then
                begin
                  dTmp := CalcDE(@Iteration3Dext, @MCTparas);
                  if dTmp < msDEstop then dT1 := Abs(dT1) * -0.55
                                     else dT1 := Abs(dT1) * 0.55;
                end;
              end;
              iMaxit := itmp2;
            end
            else
            begin
              RMdoBinSearchIt(@MCTparas, ZZ);//, msDEstop * -0.3);
              msDEstop := DEStop * (1 + ZZ * mctDEstopFactor);
            end;
            if msDEstop > 1e4 then msDEstop := 1e4 else
            if msDEstop < DEstop then msDEstop := DEstop;
            mCopyVec(@IC, @Iteration3Dext.C1);
            StepAO := msDEstop / DEstop;
            MaxDist := sMaxD * Sqrt(StepAO);
            if bVaryDEstop then msDEstop := msDEstop / Sqr(DStepMul)
                           else msDEstop := DEstop / Sqr(DStepMul);
         {   if Dither > 0 then
            begin
              dT1 := (y mod (Dither + 1)) * 0.5 / Dither;
              dT2 := (x mod (Dither + 1)) * 0.5 / Dither;
              if Quality = 0 then
              begin
                for itmp := 0 to 2 do
                begin
                  BuildRotMatrixS(0, (dT1 + 0.5) * 50 * Pid180, (itmp + dT2) * 2 * Pi / 3, @RotW);
                  RotM[itmp] := ScaleSVector(TSVec(RotW[2]), -1);
                end;
              end
              else
              begin
                if dT1 > 0.1 then RayCount := 1 else RayCount := 0;
                ABR := Pi * 0.5 / (Quality + 0.9);  //angle between rows
                BuildRotMatrixS(0, 0, 0, @RotW);
                RotM[0] := ScaleSVector(TSVec(RotW[2]), -1);
                for itmp2 := 1 to Quality do
                begin
                  for itmp := 0 to RowCount[itmp2] - 1 do
                  begin
                    BuildRotMatrixS(0, ABR * (itmp2 + dT1 - 0.25), (itmp + dT2) * 2 * Pi / RowCount[itmp2], @RotW);
                    RotM[RayCount] := ScaleSVector(TSVec(RotW[2]), -1);
                    Inc(RayCount);
                  end;
                end;
              end;
            end;  }
            DEmul := Sqrt(RayCount * s05);
       //     ABR := 1.2 / ArcSin(1 / DEmul);
            MDd10 := 0.1 / (MaxDist * DEmul);

         {   SVec[0] := mPsiLight.NormalX;
            SVec[1] := mPsiLight.NormalY;
            SVec[2] := mPsiLight.NormalZ;
            NormaliseSVectorVar(SVec);
            Quat := MakeRotQuatFromSNormals(SVec);
            CreateSMatrixFromQuat(RotW, Quat);   }
            dAmount := 0;
            for itmp := 0 to RayCount - 1 do
            begin
              SVec := Vecs[itmp];
        //      RotateSVectorReverseS(@SVec, @RotW);
        //      RotateSVectorS(@SVec, @RotV);
              dT1 := StepAO * DStepMul;
              sTmp := 1;
              bEnd := False;
              bFirstStep := bMCTFirstStepRandom;
              repeat
                if bFirstStep then
                begin
                  bFirstStep := False;
                  dT1 := dT1 * (GetRand * 1.5 + s05);
                end
                else if dT1 > maxDist then
                begin
                  dT1 := maxDist; //to make shure that all rays go max til the same distance to avoid artifacts from the last position.
                  bEnd := True;
                end;
                CopyAddSVecWeight(@Iteration3Dext.C1, @IC, @SVec, dT1);
                if (iCutOptions <> 0) and AtCutPlane2(@MCTparas, @Iteration3Dext.C1, dT1 * 0.25) then Break;
                dT2 := CalcDE(@Iteration3Dext, @MCTparas);
                sTmp := MinCS(sTmp, (dT2 - msDEstop + dT1 * MDd10) / dT1);
                if sTmp < c0p02 then Break;
                dT1 := dT1 + Max(dT2, dT1 * DStepMul);
              until bEnd;
         //     minRA[itmp] := MaxCS(0, sTmp) * DEmul;
              dAmount := dAmount + MinCS(1, sTmp);
            end;

         {   for itmp := 0 to RayCount - 1 do   //correction
            begin
              SVec := RotM[itmp];
              sAdd[itmp] := 0;
              if minRA[itmp] < 1 then
              begin
                MaxAdd := 1 - minRA[itmp];
                for itmp2 := 0 to RayCount - 1 do if itmp2 <> itmp then
                begin
                  dTmp := DotOfSVectors(SVec, RotM[itmp2]);
                  if dTmp > dMinADif then
                  begin
                    Overlap := minRA[itmp2] - ArcCosSafe(dTmp) * ABR + 1;
                    if Overlap > 0 then sAdd[itmp] := sAdd[itmp] + MinCS(MaxAdd, Overlap) * CorrectionWeight;  //CW: recip. of raycount of neighbours
                  end;
                end;
              end;
            end;  }
        //    for itmp := 0 to RayCount - 1 do dAmount := dAmount + MinCS(1, (sAdd[itmp] + minRA[itmp]));

            mPsiLight.AmbShadow := Max(0, Round(16383 * (1 - dAmount / RayCount)));  //todo: FSR 0..7: n times calc + average
          end;
          Inc(x);
          Inc(mPsiLight);
          if PCalcThreadStats.pLBcalcStop^ then Break;
        end;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        Inc(y, iThreadCount);
      end;
    finally
      SetLength(Vecs, 0);
      if not PCalcThreadStats.pLBcalcStop^ then
        PCalcThreadStats.CTrecords[iThreadID].iActualYpos := iMandHeight;
      PCalcThreadStats.CTrecords[iThreadID].isActive := 0;
      PostMessage(PCalcThreadStats.pMessageHwnd, WM_ThreadReady, 0, 0);
      SetLength(Vecs, 0);
    end;
end;

end.
