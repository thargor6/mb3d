unit CalcMissed;

interface

uses
  Classes, Math3D, TypeDefinitions;

type
  TCalcMissed = class
  private
    { Private-Deklarationen }
    Iteration3D: TIteration3D;
    VgradsFOV: TMatrix3;
    procedure CalculateVgradsFOV(ix: Integer);
    procedure CalculateNormals(DEstop: Double; var NN, R: Double; mPsiLight: TPsiLight5);
    procedure maxLengthToCutPlane(var dLength: Double; var itmp: Integer; vPos: TPPos3D);
  //  procedure HSminLengthToCutPlane(var dLength: Double; vPos: TPPos3D);
    procedure CalculateNormalsOnDE(DEstop: Double; var NN, R: Double; mPsiLight: TPsiLight5);
  public
    { Public-Deklarationen }
    MCTparas: TMCTparameter;
    CMXpos, CMYpos: Integer;
    procedure CalcMissed(n: Integer);
  end;

var
  cCalcMissed: TCalcMissed;

implementation

uses Mand, Math, LightAdjust, DivUtils, formulas, Forms, ImageProcess, CustomFormulas;


procedure TCalcMissed.maxLengthToCutPlane(var dLength: Double; var itmp: Integer; vPos: TPPos3D);
var dTmp: Double;
begin
    with MCTparas do
    begin
      if iCutOptions > 0 then
      begin
        dLength := 0;
        if ((iCutOptions and 1) > 0) and (Abs(VgradsFOV[2, 0]) > 1e-20) then
        begin
          dTmp := (dCOX - vPos^[0]) / VgradsFOV[2, 0];
          if dTmp > dLength then
          begin
            dLength := dTmp;
            itmp := 1;
          end;
        end;
        if ((iCutOptions and 2) > 0) and (Abs(VgradsFOV[2, 1]) > 1e-20) then
        begin
          dTmp := (dCOY - vPos^[1]) / VgradsFOV[2, 1];
          if dTmp > dLength then
          begin
            dLength := dTmp;
            itmp := 2;
          end;
        end;
        if ((iCutOptions and 4) > 0) and (Abs(VgradsFOV[2, 2]) > 1e-20) then
        begin
          dTmp := (dCOZ - vPos^[2]) / VgradsFOV[2, 2];
          if dTmp > dLength then
          begin
            dLength := dTmp;
            itmp := 3;
          end;
        end;
      end;
    end;
end;

{procedure TCalcMissed.HSminLengthToCutPlane(var dLength: Double; vPos: TPPos3D);
var dTmp: Double;
begin
    with MCTparas do
    begin
      if iCutOptions > 0 then
      begin
        dLength := 1e40;
        if ((iCutOptions and 1) > 0) and (Abs(HSvecs[0][0]) > 1e-20) then
        begin
          dTmp := (vPos^[0] - dCOX) / HSvecs[0][0];
          if (dTmp > 0) and (dTmp < dLength) then dLength := dTmp;
        end;
        if ((iCutOptions and 2) > 0) and (Abs(HSvecs[0][1]) > 1e-20) then
        begin
          dTmp := (vPos^[1] - dCOY) / HSvecs[0][1];
          if (dTmp > 0) and (dTmp < dLength) then dLength := dTmp;
        end;
        if ((iCutOptions and 4) > 0) and (Abs(HSvecs[0][2]) > 1e-20) then
        begin
          dTmp := (vPos^[2] - dCOZ) / HSvecs[0][2];
          if (dTmp > 0) and (dTmp < dLength) then dLength := dTmp;
        end;
      end;
    end;
end;  }

procedure TCalcMissed.CalculateNormals(DEstop: Double; var NN, R: Double; mPsiLight: TPsiLight5);
var CT1: TVec3D;
    dT2, StepSNorm, dM, dS, dSG, N3, N2, N1, NN2, NN1, Noffset: Double;
    itmp, SmoothN: Integer;
    V: TVec3D;
    M{, MAFOV}: TMatrix3;
    bN3neg: LongBool;
begin
    with MCTparas do
    begin
  {    N1 := -CAFY;          //antiFOV is not working, use absolute values + FOV on calcpixelcol, spec = Normals * (LightVec + ViewVecFOV)
      N2 := -CAFX;
      BuildRotMatrixFOV(N1, N2, @MAFOV);
      Multiply2Matrix(@MAFOV, @Vgrads); }
      Noffset := Min(DEstop * 0.5 / msDEStop, DEstop * 0.15);
      Iteration3D.CalcSIT := True;
      mCopyVec(@CT1, @Iteration3D.C1);
      mMandFunction(@Iteration3D);
      NN := Iteration3D.SmoothItD;
  //    Iteration3D.C3 := Iteration3D.C3 + StepWidth * 0.1;   Absolute normals
      mAddVecWeight(@Iteration3D.C1, @Vgrads[2, 0], -Noffset);
      mMandFunction(@Iteration3D);
      N3 := NN - Iteration3D.SmoothItD;// - NN;     //Zgradient
   //   mCopyVec(@Iteration3D.C1, @CT1);
     // Iteration3D.C1 := Iteration3D.C1 + StepWidth * 0.1;
      mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[0, 0], Noffset);
      mMandFunction(@Iteration3D);
      N1 := NN - Iteration3D.SmoothItD;     //Xgradient
 //     mCopyVec(@Iteration3D.C1, @CT1);
   //   Iteration3D.C2 := Iteration3D.C2 + StepWidth * 0.1;
      mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[1, 0], Noffset);
      mMandFunction(@Iteration3D);
      N2 := NN - Iteration3D.SmoothItD;     //Ygradient

      if iSmNormals > 0 then     //smoothed with estimation of roughness, eg deviation from mid val
      begin                               //  -> only 3 directions is not very good, more deviation if direct in DE direction to bulb
        Iteration3D.maxIt := Iteration3D.ItResultI + 2;

        Noffset := Noffset * 2;
        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[0, 0], -Noffset);     //smooth mid point
        mMandFunction(@Iteration3D);
        NN := NN + Iteration3D.SmoothItD;
        mAddVecWeight(@Iteration3D.C1, @Vgrads[0, 0], 2 * Noffset);
        mMandFunction(@Iteration3D);
        NN := NN + Iteration3D.SmoothItD;
        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[1, 0], -Noffset);
        mMandFunction(@Iteration3D);
        NN := NN + Iteration3D.SmoothItD;
        mAddVecWeight(@Iteration3D.C1, @Vgrads[1, 0], 2 * Noffset);
        mMandFunction(@Iteration3D);
        NN := (NN + Iteration3D.SmoothItD) * 0.2;

        SmoothN := iSmNormals;
        StepSNorm := DEstop / ((SmoothN + 0.5) * msDEStop);
        dM := SmoothN * 2;

        bN3neg := N3 < 0;
        if bN3neg then dS := -ArcTan2(N1, N3 - 1e-15) else dS := -ArcTan2(N1, N3 + 1e-15);
    //    dS := -ArcSin(N1 / Sqrt(N1 * N1 + N3 * N3 + 1e-15));
        CopyVec(@V, @Vgrads[0]);
        BuildRotMatrixY(dS, @M);  //rotate dX on yaxis
        RotateVector(@V, @M);

        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @V, -SmoothN * StepSNorm);

        NN1 := 0;
        dS := 0;
        for itmp := -SmoothN to SmoothN do
        begin
          if itmp <> 0 then
          begin
            mMandFunction(@Iteration3D);
            dT2 := (NN - Iteration3D.SmoothItD) / itmp;
            NN1 := NN1 + dT2;
            dS := dS + Sqr(dT2);
          end;
          mAddVecWeight(@Iteration3D.C1, @V, StepSNorm);
        end;
        dSG := dS * dM - Sqr(NN1);

        if bN3neg then dS := ArcTan2(N2, N3 - 1e-15) else dS := ArcTan2(N2, N3 + 1e-15);
    //    dS := ArcSin(N2 / Sqrt(N2 * N2 + N3 * N3 + 1e-15));
        CopyVec(@V, @Vgrads[1]);
        BuildRotMatrixX(dS, @M);
        RotateVector(@V, @M);

        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @V, -SmoothN * StepSNorm);
        NN2 := 0;
        dS := 0;
        for itmp := -SmoothN to SmoothN do
        begin
          if itmp <> 0 then
          begin
            mMandFunction(@Iteration3D);
            dT2 := (NN - Iteration3D.SmoothItD) / itmp;
            NN2 := NN2 + dT2;
            dS := dS + Sqr(dT2);
          end;
          mAddVecWeight(@Iteration3D.C1, @V, StepSNorm);
        end;
        dT2 := Noffset * 0.5 / (dM * StepSNorm); 
        dSG := (dSG + dS * dM - Sqr(NN2)) * 5 / Max(1e-10, Sqr(NN1) + Sqr(NN2) + Sqr(N3 / dT2));
        sRoughness := Max(0, Min(1, Sqrt(dSG) - 0.05));

        N1 := N1 + NN1 * dT2;  
        N2 := N2 + NN2 * dT2;

        Iteration3D.maxIt := iMaxIt;
      end;
      R := 32767 / Sqrt(N1 * N1 + N2 * N2 + N3 * N3);
      mPsiLight^.NormalX := Round(N1 * R);              //3 normals a 16bit
      mPsiLight^.NormalY := Round(N2 * R);
      mPsiLight^.NormalZ := Round(N3 * R);
      mCopyVec(@Iteration3D.C1, @CT1);
    end;
end;

procedure TCalcMissed.CalculateNormalsOnDE(DEstop: Double; var NN, R: Double; mPsiLight: TPsiLight5);
var CT1: TVec3D;
    dT2, StepSNorm, dM, dS, dSG, N3, N2, N1, NN2, NN1, Noffset: Double;
    itmp, SmoothN: Integer;
    V: TVec3D;
    M: TMatrix3;
    bN3neg: LongBool;
begin
    with MCTparas do
    begin
      Noffset := Min(DEstop * 0.5 / msDEStop, DEstop * 0.15);
      Iteration3D.CalcSIT := False;
      mCopyVec(@CT1, @Iteration3D.C1);
      NN := mMandFunctionDE(@Iteration3D);
      mAddVecWeight(@Iteration3D.C1, @Vgrads[2, 0], -Noffset);
      N3 := mMandFunctionDE(@Iteration3D) - NN;     //Zgradient
      mAddVecWeight(@Iteration3D.C1, @Vgrads[2, 0], 2 * Noffset);   //Doublecheck because of steps
      N1 := NN - mMandFunctionDE(@Iteration3D);
      if Abs(N1) < Abs(N3) then N3 := N1;

      mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[0, 0], Noffset);
      N1 := mMandFunctionDE(@Iteration3D) - NN;     //Xgradient
      mAddVecWeight(@Iteration3D.C1, @Vgrads[0, 0], -2 * Noffset);
      N2 := NN - mMandFunctionDE(@Iteration3D);
      if Abs(N2) < Abs(N1) then N1 := N2;

      mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[1, 0], Noffset);
      N2 := mMandFunctionDE(@Iteration3D) - NN;     //Ygradient
      mAddVecWeight(@Iteration3D.C1, @Vgrads[1, 0], -2 * Noffset);
      NN2 := NN - mMandFunctionDE(@Iteration3D);
      if Abs(NN2) < Abs(N2) then N2 := NN2;

      if iSmNormals > 0 then
      begin
        Iteration3D.maxIt := Iteration3D.ItResultI + 2;

        Noffset := Noffset * 2;
        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[0, 0], -Noffset);     //smooth mid point
        NN := NN + mMandFunctionDE(@Iteration3D);
        mAddVecWeight(@Iteration3D.C1, @Vgrads[0, 0], 2 * Noffset);
        NN := NN + mMandFunctionDE(@Iteration3D);
        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[1, 0], -Noffset);
        NN := NN + mMandFunctionDE(@Iteration3D);
        mAddVecWeight(@Iteration3D.C1, @Vgrads[1, 0], 2 * Noffset);
        NN := (NN + mMandFunctionDE(@Iteration3D)) * 0.2;

        SmoothN := iSmNormals;
        StepSNorm := DEstop / ((SmoothN + 0.5) * msDEStop);
        dM := SmoothN * 2;

        bN3neg := N3 < 0;
        if bN3neg then dS := -ArcTan2(N1, N3 - 1e-15) else dS := -ArcTan2(N1, N3 + 1e-15);
     //   dS := -ArcSin(N1 / Sqrt(N1 * N1 + N3 * N3 + 1e-15));
        CopyVec(@V, @Vgrads[0]);
        BuildRotMatrixY(dS, @M); //rotate dX only on yaxis
        RotateVector(@V, @M);

  //      dT := StepSNorm / (0.1 + Cos(dS - CAFX));
  //      mCopyAddVecWeight(@Iteration3D.C1, @CT1, @V, -SmoothN * dT);

        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @V, -SmoothN * StepSNorm);

        NN1 := 0;
        dS := 0;
        for itmp := -SmoothN to SmoothN do
        begin
          if itmp <> 0 then
          begin
            dT2 := (mMandFunctionDE(@Iteration3D) - NN) / itmp;
            NN1 := NN1 + dT2;
            dS := dS + Sqr(dT2);
          end;
          mAddVecWeight(@Iteration3D.C1, @V, StepSNorm);
        end;
        dSG := dS * dM - Sqr(NN1);

        if bN3neg then dS := ArcTan2(N2, N3 - 1e-15) else dS := ArcTan2(N2, N3 + 1e-15);
   //     dS := ArcSin(N2 / Sqrt(N2 * N2 + N3 * N3 + 1e-15));
        CopyVec(@V, @Vgrads[1]);
        BuildRotMatrixX(dS, @M);  //rotate dY only on xaxis
        RotateVector(@V, @M);

  //      dT := StepSNorm / (0.1 + Cos(dS - CAFY));
  //      mCopyAddVecWeight(@Iteration3D.C1, @CT1, @V, -SmoothN * dT);
  
        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @V, -SmoothN * StepSNorm);
        NN2 := 0;
        dS := 0;
        for itmp := -SmoothN to SmoothN do
        begin
          if itmp <> 0 then
          begin
            dT2 := (mMandFunctionDE(@Iteration3D) - NN) / itmp;
            NN2 := NN2 + dT2;
            dS := dS + Sqr(dT2);
          end;
          mAddVecWeight(@Iteration3D.C1, @V, StepSNorm);
        end;
        dT2 := 0.5 * Noffset / (dM * StepSNorm);
        dSG := (dSG + dS * dM - Sqr(NN2)) * 5 / Max(1e-10, Sqr(NN1) + Sqr(NN2) + Sqr(N3 / dT2));
        sRoughness := Max(0, Min(1, Sqrt(dSG) - 0.05));

        N1 := N1 + NN1 * dT2;  //not accurate, only for small deltas (|NN1| << |N1|)
        N2 := N2 + NN2 * dT2;

        Iteration3D.maxIt := iMaxIt;
      end;
      R := 32767 / Sqrt(N1 * N1 + N2 * N2 + N3 * N3);
      mPsiLight^.NormalX := Round(N1 * R);             //3 normals a 16bit
      mPsiLight^.NormalY := Round(N2 * R);
      mPsiLight^.NormalZ := Round(N3 * R);

      mCopyVec(@Iteration3D.C1, @CT1);
      Iteration3D.CalcSIT := True;
      mMandFunctionDE(@Iteration3D);
      NN := Iteration3D.SmoothItD;   //for coloring
      Iteration3D.CalcSIT := False;
    end;
end;
{
procedure TCalcMissed.CalculateNormals(DEstop: Double; var NN, R: Double; mPsiLight: TPsiLight5);
var CT1: TVec3D;
    dT2, StepSNorm, dM, dS, dSG, N3, N2, N1, NN2, NN1: Double;
    itmp, SmoothN: Integer;
    M: TMatrix3;
    V: TVec3D;
begin
    with MCTparas do
    begin
      Iteration3D.CalcSIT := True;  // Calculate Normals relativ to FOV direction
      mCopyVec(@CT1, @Iteration3D.C1);
      mMandFunction(@Iteration3D);
      NN := Iteration3D.SmoothItD;
      mAddVecWeight(@Iteration3D.C1, @Vgrads[2, 0], -0.1);
      mMandFunction(@Iteration3D);
      N3 := NN - Iteration3D.SmoothItD;     //Zgradient
      mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[0, 0], 0.1);
      mMandFunction(@Iteration3D);
      N1 := NN - Iteration3D.SmoothItD;     //Xgradient
      mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[1, 0], 0.1);
      mMandFunction(@Iteration3D);
      N2 := NN - Iteration3D.SmoothItD;     //Ygradient

      if iSmNormals > 0 then     //smoothed with estimation of roughness, eg deviation from mid val
      begin                               //  -> only 3 directions is not very good, more deviation if direct in DE direction to bulb
        Iteration3D.maxIt := Iteration3D.ItResultI + 2;

        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[0, 0], -0.2);     //smooth mid point
        mMandFunction(@Iteration3D);
        NN := NN + Iteration3D.SmoothItD;
        mAddVecWeight(@Iteration3D.C1, @Vgrads[0, 0], 0.4);
        mMandFunction(@Iteration3D);
        NN := NN + Iteration3D.SmoothItD;
        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[1, 0], -0.2);
        mMandFunction(@Iteration3D);
        NN := NN + Iteration3D.SmoothItD;
        mAddVecWeight(@Iteration3D.C1, @Vgrads[1, 0], 0.4);
        mMandFunction(@Iteration3D);
        NN := (NN + Iteration3D.SmoothItD) * 0.2;

        SmoothN := iSmNormals;
        StepSNorm := DEstop / ((SmoothN + 0.5) * sDEStop);
        dM := SmoothN * 2;

        R := 1 / Sqrt(N1 * N1 + N2 * N2 + N3 * N3);
        dS := -ArcSin(N1 * R);

        CopyVec(@V, @Vgrads[0]);
        BuildRotMatrixY(dS, @M); //rotate dX only on yaxis
        RotateVector(@V, @M);

        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @V, -SmoothN * StepSNorm);

        NN1 := 0;
        dS := 0;
        for itmp := -SmoothN to SmoothN do
        begin
          if itmp <> 0 then
          begin
            mMandFunction(@Iteration3D);
            dT2 := (NN - Iteration3D.SmoothItD) / itmp;
            NN1 := NN1 + dT2;
            dS := dS + Sqr(dT2);
          end;
          mAddVecWeight(@Iteration3D.C1, @V, StepSNorm);
        end;
        dSG := dS * dM - Sqr(NN1);

        dS := ArcSin(N2 * R);
        CopyVec(@V, @Vgrads[1]);
        BuildRotMatrixX(dS, @M); 
        RotateVector(@V, @M);

        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @V, -SmoothN * StepSNorm);
        NN2 := 0;
        dS := 0;
        for itmp := -SmoothN to SmoothN do
        begin
          if itmp <> 0 then
          begin
            mMandFunction(@Iteration3D);
            dT2 := (NN - Iteration3D.SmoothItD) / itmp;
            NN2 := NN2 + dT2;
            dS := dS + Sqr(dT2);
          end;
          mAddVecWeight(@Iteration3D.C1, @V, StepSNorm);
        end;
        dT2 := 0.1 / (dM * StepSNorm);  //StepSNorm := DEstop / (SmoothN + 0.5);
        dSG := (dSG + dS * dM - Sqr(NN2)) * 3 / Max(1e-10, Sqr(NN1) + Sqr(NN2) + Sqr(N3 / dT2));
        sRoughness := Max(0, Min(1, Sqrt(dSG) - 0.13));

        N1 := N1 + NN1 * dT2; 
        N2 := N2 + NN2 * dT2;
        Iteration3D.maxIt := iMaxIt;
      end;
      R := 32767 / Sqrt(N1 * N1 + N2 * N2 + N3 * N3);   //recip. length of 3Dgradient
      mPsiLight^.NormalX := Round(N1 * R);                //3 normals a 16bit
      mPsiLight^.NormalY := Round(N2 * R);
      mPsiLight^.NormalZ := Round(N3 * R);
      mCopyVec(@Iteration3D.C1, @CT1);
    end;
end;

procedure TCalcMissed.CalculateNormalsOnDE(DEstop: Double; var NN, R: Double; mPsiLight: TPsiLight5);
var CT1: TVec3D;
    dT2, StepSNorm, dM, dS, dSG, N3, N2, N1, NN2, NN1: Double;
    itmp, SmoothN: Integer;
    M: TMatrix3;
    V: TVec3D;
begin
    with MCTparas do
    begin
      Iteration3D.CalcSIT := False;  
      mCopyVec(@CT1, @Iteration3D.C1);
      NN := mMandFunctionDE(@Iteration3D);
      mAddVecWeight(@Iteration3D.C1, @Vgrads[2, 0], -0.1);
      N3 := mMandFunctionDE(@Iteration3D) - NN;     //Zgradient
      mAddVecWeight(@Iteration3D.C1, @Vgrads[2, 0], 0.2);   //Doublecheck because of steps
      N1 := NN - mMandFunctionDE(@Iteration3D);
      if Abs(N1) < Abs(N3) then N3 := N1;

      mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[0, 0], 0.1);
      N1 := mMandFunctionDE(@Iteration3D) - NN;     //Xgradient
      mAddVecWeight(@Iteration3D.C1, @Vgrads[0, 0], -0.2);
      N2 := NN - mMandFunctionDE(@Iteration3D);
      if Abs(N2) < Abs(N1) then N1 := N2;

      mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[1, 0], 0.1);
      N2 := mMandFunctionDE(@Iteration3D) - NN;     //Ygradient
      mAddVecWeight(@Iteration3D.C1, @Vgrads[1, 0], -0.2);
      NN2 := NN - mMandFunctionDE(@Iteration3D);
      if Abs(NN2) < Abs(N2) then N2 := NN2;

      if iSmNormals > 0 then
      begin
        Iteration3D.maxIt := Iteration3D.ItResultI + 2;

        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[0, 0], -0.2);     //smooth mid point
        NN := NN + mMandFunctionDE(@Iteration3D);
        mAddVecWeight(@Iteration3D.C1, @Vgrads[0, 0], 0.4);
        NN := NN + mMandFunctionDE(@Iteration3D);
        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @Vgrads[1, 0], -0.2);
        NN := NN + mMandFunctionDE(@Iteration3D);
        mAddVecWeight(@Iteration3D.C1, @Vgrads[1, 0], 0.4);
        NN := (NN + mMandFunctionDE(@Iteration3D)) * 0.2;

        SmoothN := iSmNormals;
        StepSNorm := DEstop / ((SmoothN + 0.5) * sDEStop);
        dM := SmoothN * 2;

        R := 1 / Sqrt(N1 * N1 + N2 * N2 + N3 * N3);
        dS := -ArcSin(N1 * R);

        CopyVec(@V, @Vgrads[0]);
        BuildRotMatrixY(dS, @M); //rotate dX only on yaxis
        RotateVector(@V, @M);

        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @V, -SmoothN * StepSNorm);

        NN1 := 0;
        dS := 0;
        for itmp := -SmoothN to SmoothN do
        begin
          if itmp <> 0 then
          begin
            dT2 := (mMandFunctionDE(@Iteration3D) - NN) / itmp;
            NN1 := NN1 + dT2;
            dS := dS + Sqr(dT2);
          end;
          mAddVecWeight(@Iteration3D.C1, @V, StepSNorm);
        end;
        dSG := dS * dM - Sqr(NN1);

        dS := ArcSin(N2 * R);
        CopyVec(@V, @Vgrads[1]);
        BuildRotMatrixX(dS, @M);  //rotate dY only on xaxis
        RotateVector(@V, @M);

        mCopyAddVecWeight(@Iteration3D.C1, @CT1, @V, -SmoothN * StepSNorm);
        NN2 := 0;
        dS := 0;
        for itmp := -SmoothN to SmoothN do
        begin
          if itmp <> 0 then
          begin
            dT2 := (mMandFunctionDE(@Iteration3D) - NN) / itmp;
            NN2 := NN2 + dT2;
            dS := dS + Sqr(dT2);
          end;
          mAddVecWeight(@Iteration3D.C1, @V, StepSNorm);
        end;
        dT2 := 0.1 / (dM * StepSNorm);
        dSG := (dSG + dS * dM - Sqr(NN2)) * 3 / Max(1e-10, Sqr(NN1) + Sqr(NN2) + Sqr(N3 / dT2));
        sRoughness := Max(0, Min(1, Sqrt(dSG) - 0.13));

        N1 := N1 + NN1 * dT2;  //not accurate, only for small deltas (|NN1| << |N1|)
        N2 := N2 + NN2 * dT2;

        Iteration3D.maxIt := iMaxIt;
      end;
      R := 32767 / Sqrt(N1 * N1 + N2 * N2 + N3 * N3);   //recip. length of 3Dgradient
      mPsiLight^.NormalX := Round(N1 * R);                //3 normals a 16bit
      mPsiLight^.NormalY := Round(N2 * R);
      mPsiLight^.NormalZ := Round(N3 * R);
      mCopyVec(@Iteration3D.C1, @CT1);
      Iteration3D.CalcSIT := True;
      mMandFunctionDE(@Iteration3D);
      NN := Iteration3D.SmoothItD;   //for coloring
      Iteration3D.CalcSIT := False;
    end;
end;   }

procedure TCalcMissed.CalculateVgradsFOV(ix: Integer);
begin
    with MCTparas do
    begin
      CAFX := (0.5 * iMandWidth - ix) * FOVy / iMandHeight;
      BuildRotMatrixFOV(CAFY, CAFX, @VgradsFOV);
      Multiply2Matrix(@VgradsFOV, @Vgrads);
    end;
end;

procedure TCalcMissed.CalcMissed(n: Integer);
var itmp, itmp2, itmp3, itmp4, itmp5, itmp6: Integer;
    x, y, DEstepC: Integer;
    MandFunction: TMandFunction;
    MandFunctionDE: TMandFunctionDE;
 //   SL: PCardinal;
    mPsiLight, mPsiLight2: TPsiLight5;
    bIsCustomDE: LongBool;
    dTmp, dT1, zh, ZZ, YP: Double;
    CC1, CC2, CC3, R: Double;
    DEstop, DEstopFactor, minDE, ZstepDiv12d, DEstopHL: Double;
    DEscale, DEoffset{, dISW}: Double;
 //   PLV: TPaintLightVals;
function calcDE: Double;  //Distance Estimation (DE)
var Rtmp, RD1, Rst: Double;
    deCT1, deCT2, deCT3: Double;
    Mtmp: Integer;
    RStopTmp: Single;
begin
    if bIsCustomDE then
    begin
      Iteration3D.CalcSIT := False;
      Result := MandFunctionDE(@Iteration3D) * DEscale;
    end
    else with Iteration3D do
    begin
      CalcSIT  := False;          //3d gradient
      MandFunction(@Iteration3D);
      Mtmp  := MaxIt;
      MaxIt := ItResultI;
      RStopTmp := RStop;
      RStop := RStop * 8;
      Rtmp  := Rout;
      Rst   := DEoffset;
      deCT1 := C1;
      deCT2 := C2;
      deCT3 := C3;
      C1  := C1 + VgradsFOV[2, 0] * Rst;
      C2  := C2 + VgradsFOV[2, 1] * Rst;
      C3  := C3 + VgradsFOV[2, 2] * Rst;
      MandFunction(@Iteration3D);
      RD1 := Sqr(Rtmp - Rout);
      C1  := deCT1 + VgradsFOV[1, 0] * Rst;
      C2  := deCT2 + VgradsFOV[1, 1] * Rst;
      C3  := deCT3 + VgradsFOV[1, 2] * Rst;
      MandFunction(@Iteration3D);
      RD1 := RD1 + Sqr(Rout - Rtmp);
      C1  := deCT1 + VgradsFOV[0, 0] * Rst;
      C2  := deCT2 + VgradsFOV[0, 1] * Rst;
      C3  := deCT3 + VgradsFOV[0, 2] * Rst;
      MandFunction(@Iteration3D);
      RD1 := Sqrt(RD1 + Sqr(Rout - Rtmp)) + (Rst * 0.06);
      Result := Rtmp * Ln(Rtmp) * DEscale / RD1;
      MaxIt := Mtmp;
      RStop := RStopTmp;
      C1 := deCT1;
      C2 := deCT2;
      C3 := deCT3;
    end;
    if Result < minDE then Result := minDE;
end;
begin
    with MCTparas do
    try
      Move(dJUx, Iteration3D.J1, 168);
      MandFunction   := mMandFunction;
      MandFunctionDE := mMandFunctionDE;
      zh           := StepWidth;
      bIsCustomDE  := IsCustomDE;
      ZstepDiv12d  := sZstepDiv;    //iZstepDiv=2..16 DEaccuracy
      DEstopFactor := (1 + 0.3 / msDEStop) * Max(0, FOVy) / iMandHeight;
      DEoffset := Min(msDEStop * 0.1, 0.01);
      DEscale  := dDEscale;
  //    dISW     := 1 + iZstepDiv * 0.1;

      y := Max(1, CMYpos - 2);
      YXstart := YXstart + Vgrads[1, 0] * y;
      YYstart := YYstart + Vgrads[1, 1] * y;
      YZstart := YZstart + Vgrads[1, 2] * y;
      while y < Min(CMYpos + 3, iMandHeight - 1) do
      begin
        x   := Max(1, CMXpos - 2);
        CC1 := YXstart + Vgrads[0, 0] * x;
        CC2 := YYstart + Vgrads[0, 1] * x;
        CC3 := YZstart + Vgrads[0, 2] * x;
        mPsiLight := pSiLight;
        Inc(mPsiLight, y * iMandWidth + x);
    //    SL   := PCardinal(FSIstart + FSIoffset * y + 4 * x);
        CAFY := (y - 0.5 * iMandHeight) * FOVy / iMandHeight;
        while x < Min(CMXpos + 3, iMandWidth - 1) do
        with Iteration3D do
        begin
          CalculateVgradsFOV(x + 1);
            ZZ      := Zstart;
            YP      := Zstart;
            C1      := CC1;
            C2      := CC2;
            C3      := CC3;
            CalcSIT := False;
            itmp    := 0;
            DEstop  := msDEStop;
            minDE   := DEstop * 0.5;

            if iCutOptions > 0 then
            begin
              maxLengthToCutPlane(YP, itmp, @C1);
              YP := ZZ + YP;
            end;

            //proof, if zpos of neighbourpixels are greater
            itmp3 := 0;
            for itmp := -1 to 1 do
            begin
              mPsiLight2 := mPsiLight;
              Inc(mPsiLight2, itmp * iMandWidth - 1);
              for itmp2 := -1 to 1 do
              begin
                if (mPsiLight2^.Zpos < 32768) and
                   (mPsiLight2^.Zpos > itmp3) and (random > 0.2) then itmp3 := mPsiLight2^.Zpos;
                Inc(mPsiLight2);               // to give lower Z's a chance
              end;
            end;
                   //zz to proof:
            dT1 := ZZ + (Sqr((32767 - itmp3) * 256 / ZCmul + 1) - 1) / Zcorr;

            if ((itmp3 > mPsiLight^.Zpos + 5) or (mPsiLight^.Zpos = 32768)) and (dT1 > YP) then
            begin

              //move to zpos:
              mAddVecWeight(@C1, @VgradsFOV[2, 0], dT1 - ZZ);
              ZZ := dT1;

              itmp := 30;          //bin search
              dT1  := Random + 0.5;
              dTmp := 0;
              dTmp := calcDE;
              R    := dTmp;   //LastDE
              repeat
                ZZ := ZZ + dT1;
                mAddVecWeight(@C1, @VgradsFOV[2, 0], dT1);
                if bVaryDEstop then
                begin
                  DEstop := msDEStop * (1 + (ZZ - Zstart) * DEstopFactor);
                  minDE  := DEstop * 0.5;
                end;
                dTmp   := calcDE;
                if dTmp < DEstop then dT1 := Abs(dT1) * -0.7 else
                if dTmp < R      then dT1 := dT1 * 0.8  else dT1 := -0.8 * dT1;
                R := dTmp;
                Dec(itmp);
              until
                (itmp < 1) or (Abs(dTmp - DEstop) < 0.001);
                                                              //only if DElimited
              if ((dTmp - DEstop) < 0.01) and (ZZ > Zstart) and (Iteration3D.ItResultI < MaxIt) then
              begin
                DEstopHL := DEstop;

                if bIsCustomDE then
                  CalculateNormalsOnDE(DEstop, dTmp, dT1, mPsiLight)
                else
                  CalculateNormals(DEstop, dTmp, dT1, mPsiLight);

             //   if colItCou then    // color on iteration count, fixed grad
               // begin
                dTmp := 32767  - (dTmp + dColPlus - iMinIt) *
                        32767 / (maxIt - iMinIt + 1);
               // end
               // else dTmp := 3e7 / (dT1 * maxIt * maxIt); // color on gradient
                if dTmp > 32766.5 then mPsiLight^.SIgradient := 32767 else
                if dTmp <       0 then mPsiLight^.SIgradient := 0     else
                                       mPsiLight^.SIgradient := Round(dTmp);
                dTmp := Iteration3D.OTrap * 4096;
                if dTmp > 32766.5 then mPsiLight^.OTrap := 32767
                                  else mPsiLight^.OTrap := Round(dTmp);

                dTmp := 8388352 - ZcMul * (Sqrt((ZZ - Zstart) * Zcorr + 1) - 1);
                if dTmp < 0 then iTmp := 0 else itmp := Round(dTmp);
                mPsiLight^.Zpos := iTmp shr 8;
                mPsiLight^.RoughZposFine := (iTmp and $FF) shl 8;

             {   if calcHardShadow then
                begin
                  dT1 := iMandHeight;
                  if iCutOptions > 0 then
                  begin
                    HSminLengthToCutPlane(dT1, @C1);
                    if dT1 > iMandHeight then dT1 := iMandHeight;
                  end;
                  YP   := dT1;
                  dTmp := 0.5 / ZstepDiv12d;
                  mAddVecWeight(@C1, @VgradsFOV[2, 0], -0.3);  // step 0.3 pixel(Z) forward
                  if YP > 0 then
                  repeat
                    dTmp := dTmp * ZstepDiv12d;
                    YP := YP - dTmp;
                    mAddVecWeight(@C1, @HSvecs[0], -dTmp);
                    dTmp := calcDE;
                  until
                    ((ItResultI < iMinIt) and (ItResultI >= MaxIt) or
                    (dTmp < DEStopHL)) or (YP <= 0);
                  if YP <= 0 then mPsiLight^.Shadow := 32767 else
                  begin
                    itmp := Round(32767 * (dT1 - YP) / iMandHeight);
                    if itmp > 32767 then itmp := 32767;
                    mPsiLight^.Shadow := itmp;
                  end;
                end else begin }
                  itmp4 := 100000;
                  itmp3 := mPsiLight^.Shadow;
                  itmp5 := mPsiLight^.AmbShadow;
                  itmp6 := mPsiLight^.RoughZposFine;
                  for itmp := -1 to 1 do
                  begin
                    mPsiLight2 := mPsiLight;
                    Inc(mPsiLight2, itmp * iMandWidth - 1);
                    for itmp2 := -1 to 1 do
                    begin
                      if (mPsiLight2^.Zpos < 32768) and (Abs(itmp) + Abs(itmp2) > 0) then
                      begin
                        if Abs(mPsiLight2^.Zpos - mPsiLight^.Zpos) < itmp4 then
                        begin
                          itmp4 := Abs(mPsiLight2^.Zpos - mPsiLight^.Zpos);
                          itmp3 := mPsiLight2^.Shadow;
                          itmp5 := mPsiLight2^.AmbShadow;
                          itmp6 := mPsiLight2^.RoughZposFine;
                        end;
                      end;
                      Inc(mPsiLight2);
                    end;
                  end;
                  mPsiLight^.Shadow := itmp3;
                  mPsiLight^.AmbShadow := itmp5;
                  mPsiLight^.RoughZposFine := itmp6;
             //   end;
                if iSmNormals > 0 then
                  mPsiLight^.RoughZposFine := mPsiLight^.RoughZposFine or Round(sRoughness * 255);

            {    PLV.xPos := x / iMandWidth;
                PLV.yPos := y / iMandHeight;
                dTmp := 1 / StepWidth;
                PLV.ViewVec[0] := VGradsFOV[2,0] * dTmp;
                PLV.ViewVec[1] := VGradsFOV[2,1] * dTmp;
                PLV.ViewVec[2] := VGradsFOV[2,2] * dTmp;  }
            //    BuildViewVectorFOV(CAFY, CAFX, @PLV.ViewVec);  //to be changed, paint afterwards
            //    CalcPixelcolor(SL, mPsiLight, PLVals, @PLV);
              end;
          end;
          CC1 := CC1 + Vgrads[0, 0];
          CC2 := CC2 + Vgrads[0, 1];
          CC3 := CC3 + Vgrads[0, 2];
          Inc(x);
        //  Inc(SL);
          Inc(mPsiLight);
        end;
        YXstart := YXstart + Vgrads[1, 0];
        YYstart := YYstart + Vgrads[1, 1];
        YZstart := YZstart + Vgrads[1, 2];
        Inc(y);
        UpdateScaledImage(y div ImageScale, y div ImageScale);
      end;
    finally
    end;
end;

initialization

  cCalcMissed := TCalcMissed.Create;

finalization

  cCalcMissed.Free;

end.
