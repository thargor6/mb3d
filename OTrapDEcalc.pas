unit OTrapDEcalc;

// de directly derived from min of vec(its) calculations

interface

uses CustomFormulas, TypeDefinitions;

function CalcOTrapDE(It3Dex: TPIteration3Dext; mctp: Pointer): Double;   //always kind of analytic
function CalcOTrapDEfull(It3Dex: TPIteration3Dext; mctp: Pointer): Double;
function CalcOTrapDEnoADE(It3Dex: TPIteration3Dext; mctp: Pointer): Double;
procedure do3DalternateOTrap(PIteration3D: TPIteration3D);

implementation

uses Math, Math3D, formulas;

procedure OTrapRestoreF1DEcomb(DEcombRec: TPBufDEcomb; mctp: PMCTparameter);
begin         //   restore first hybrid vals
    with mctp^ do
    begin
      pIt3Dext.MaxIt := iMaxIt;
      PInteger(@pIt3Dext.iRepeatFrom)^ := PInteger(@RepeatFrom1)^;
      pIt3Dext.EndTo := wEndTo;
      dDEscale       := DEcombRec.bufMCTdDEscale;
      bCalcInside    := bInsideRendering;
      mMandFunctionDE := DEcombRec.bufMCTMandFunctionDE;
    end;
end;

procedure OTrapPrepareF1DEcomb(DEcombRec: TPBufDEcomb; mctp: PMCTparameter);
begin             //load second hybrid part
    with mctp^ do
    begin
      PInteger(@pIt3Dext.iRepeatFrom)^ := PInteger(@RepeatFrom2)^;
      pIt3Dext.EndTo := iEnd2;
      DEcombRec.bufMCTMandFunctionDE := mMandFunctionDE;
      mMandFunctionDE := mMandFunctionDE2;
      DEcombRec.bufIt3DItResultI := pIt3Dext.ItResultI;
      DEcombRec.bufIt3DOtrap     := pIt3Dext.Otrap;
      DEcombRec.bufIt3DSmoothItD := pIt3Dext.SmoothItD;
      DEcombRec.bufMCTdDEscale   := dDEscale;
      dDEscale       := dDEscale2;
      bCalcInside    := False;
      pIt3Dext.MaxIt := iMaxitF2;
    end;
end;

function CalcOTrapMode3D(PIteration3D: TPIteration3D): Double;
begin
    with TPIteration3Dext(Integer(PIteration3D) - 56)^ do
    begin
      case OTrapMode of
       1: Result := MinCD(MinCD(x * x + y * y, x * x + z * z), y * y + z * z);
       2: Result := x * x;
       3: Result := y * y;
       4: Result := z * z;
      else
        Result := Rout;
      end;
    end;
end;

procedure do3DalternateOTrap(PIteration3D: TPIteration3D);
var n: Integer;
 //   d: Double;
begin
    with TPIteration3Dext(Integer(PIteration3D) - 56)^ do
    begin
      OTrapMode := 1;

      if DoJulia then mCopyVec(@J1, @JU1) else mCopyVec(@J1, @C1);
      mCopyVec(@x, @C1);
      w     := 0;
      Rout  := x * x + y * y + z * z;
   //   d     := Rout;
      OTrap := Rout;
      OTrapDE := CalcOTrapMode3D(PIteration3D);
      n     := iStartFrom;
      bTmp  := nHybrid[n] and $7FFFFFFF;
      PVar  := fHPVar[n];
      bFirstIt  := 0;
      ItResultI := 0;
      repeat
        Rold := Rout;
        while bTmp <= 0 do
        begin
          Inc(n);
          if n > EndTo then n := iRepeatFrom;
          bTmp := nHybrid[n] and $7FFFFFFF;
          if bTmp > 0 then PVar := fHPVar[n];
        end;
        fHybrid[n](x, y, z, w, PIteration3D);
        Dec(bTmp);
        if nHybrid[n] < 0 then Continue else
        begin
          Inc(ItResultI);
          Rout := x * x + y * y + z * z;
          if Rout < OTrap then OTrap := Rout;
          Rout := CalcOTrapMode3D(PIteration3D);
       //   OTrapDE := MinCD(OTrapDE, Rout);
          OTrapDE := MinCD(OTrapDE, Rout);
        end;
      until (ItResultI >= maxIt) or (Rout > RStop); //or: actOTrapDE > RStop!!

      if CalcSIT then CalcSmoothIterations(PIteration3D, n);
    end;
end;

procedure Prepare3Dgrad(DEcombRec: TPBufDEcomb; It3Dex: TPIteration3Dext);
begin
    DEcombRec.bufMCTCalcSIT    := It3Dex.CalcSIT;
    DEcombRec.bufIt3DItResultI := It3Dex.MaxIt;
    DEcombRec.bufIt3DOtrap     := It3Dex.Rout;
    DEcombRec.bufIt3DSmoothItD := It3Dex.SmoothItD;
    It3Dex.CalcSIT := False;
    It3Dex.MaxIt   := It3Dex.ItResultI;
    It3Dex.RStop   := Sqr(It3Dex.RStop) * 64;
    mCopyVec(@DEcombRec.bufVec3D, @It3Dex.C1);
end;

function CalcOTrapDEnoADE(It3Dex: TPIteration3Dext; mctp: Pointer): Double;
var DEcombRec: TBufDEcomb;
    Rst, wt, dt: Double;
begin
    with PMCTparameter(mctp)^ do
    begin
      mMandFunction(@It3Dex.C1);
      if bInsideRendering and (It3Dex.ItResultI = It3Dex.MaxIt) then
        Result := msDEstop * 0.25 else
      begin
        if It3Dex.Rout < d1em200 then Result := 0 else
        begin
          Prepare3Dgrad(@DEcombRec, It3Dex);
          mAddVecWeight(@It3Dex.C1, @Vgrads[2], mctDEoffset);
          mMandFunction(@It3Dex.C1);
          dt := Sqr(DEcombRec.bufIt3DOtrap - It3Dex.Rout);
          mCopyAddVecWeight(@It3Dex.C1, @DEcombRec.bufVec3D, @Vgrads[1], mctDEoffset);
          mMandFunction(@It3Dex.C1);
          wt := Sqr(DEcombRec.bufIt3DOtrap - It3Dex.Rout);
          mCopyAddVecWeight(@It3Dex.C1, @DEcombRec.bufVec3D, @Vgrads[0], mctDEoffset);
          mMandFunction(@It3Dex.C1);
          Rst := Sqr(DEcombRec.bufIt3DOtrap - It3Dex.Rout);
          Result := DEcombRec.bufIt3DOtrap * Ln(DEcombRec.bufIt3DOtrap) * dDEscale /
                    (Sqrt(Rst + wt + dt) + (mctDEoffset * s006));
          It3Dex.Rout := DEcombRec.bufIt3DOtrap;
          It3Dex.ItResultI := It3Dex.MaxIt;
          It3Dex.MaxIt := DEcombRec.bufIt3DItResultI;
          It3Dex.SmoothItD := DEcombRec.bufIt3DSmoothItD;
          It3Dex.CalcSIT := DEcombRec.bufMCTCalcSIT;
          It3Dex.RStop := dRStop;
          mCopyVec(@It3Dex.C1, @DEcombRec.bufVec3D);
        end;
      end;
      MaxItsResult := It3Dex.MaxIt;
      if Result < msDEstop * 0.25 then Result := msDEstop * 0.25;  //MaxCDvar(DS025, Rst);
      DEoptionResult := It3Dex.DEoption;
      if bCalcInside then Result := msDEstop * 4 - Result * 3;
    end;
end;

function CalcOTrapDE(It3Dex: TPIteration3Dext; mctp: Pointer): Double;   //always kind of analytic
begin
    with PMCTparameter(mctp)^ do
    begin
 //     mMandFunction(@It3Dex.C1);
      do3DalternateOTrap(@It3Dex.C1);

      Result := Sqrt(It3Dex.OTrapDE) * dDEscale;
      MaxItsResult := It3Dex.MaxIt + 1;
      DEoptionResult := It3Dex.DEoption;
      if bCalcInside then Result := msDEstop * 4 - Result * 3;
    end;
end;

function CalcOTrapDEfull(It3Dex: TPIteration3Dext; mctp: Pointer{PMCTparameter}): Double;
var DEcombRec: TBufDEcomb;
    Rst, wt, dt, RD1: Double;
begin
    with PMCTparameter(mctp)^ do
    begin
 //     mMandFunction(@It3Dex.C1);
      Rst := SqrLengthOfVec(TPVec3D(@It3Dex.C1)^);
      do3DalternateOTrap(@It3Dex.C1);

      Result := Sqrt(It3Dex.OTrapDE * Rst / (It3Dex.Rout + d1em100)) * dDEscale;
      MaxItsResult := iMaxIt + 1;
    // Dec It3Dex.ItResultI;
      DEoptionResult := It3Dex.DEoption;

      if FormulaType > 0 then  //DEcomb type 1:min 2:max 3:maxInv 4:miS1 5:miS2 6: mix f1 first 7: mix f2-6 first
      begin
        OTrapPrepareF1DEcomb(@DEcombRec, mctp); //inside rendering disabled here
        if FormulaType = 3 then bCalcInside := not bCalcInside;
        Rst := CalcOTrapDE(It3Dex, mctp);
        case FormulaType of
        1:  if Rst < Result then Result := Rst else   //minDE comb
            begin
              It3Dex.ItResultI := DEcombRec.bufIt3DItResultI;
              It3Dex.SmoothItD := DEcombRec.bufIt3DSmoothItD;
              It3Dex.Otrap := DEcombRec.bufIt3DOtrap;
              DEoptionResult := DEoption;
              MaxItsResult := iMaxIt + 1;
            end;
     2..3:  begin          //..3: MaxInv: Invert the DE of one formula and combine "max" to cut off parts
              if Rst > Result then
              begin Result := Rst; end
              else begin
                It3Dex.ItResultI := DEcombRec.bufIt3DItResultI;
                It3Dex.SmoothItD := DEcombRec.bufIt3DSmoothItD;
                It3Dex.Otrap := DEcombRec.bufIt3DOtrap;
                DEoptionResult := DEoption;
                MaxItsResult := iMaxIt + 1;
              end;
            end;
     4..5:  begin
              if Rst >= Result then //< PMCTparameter(mctp).MaxItsResult := PMCTparameter(mctp).iMaxitF2 else
              begin
                It3Dex.ItResultI := DEcombRec.bufIt3DItResultI;
                DEoptionResult := DEoption;
                MaxItsResult := iMaxIt + 1;
              end;
              wt := Abs(Result);
              if FormulaType = 4 then   //linear
              begin
                Result := MinCD(Rst - Clamp0D(sDEcombSmooth - Result),
                                Result - Clamp0D(sDEcombSmooth - Rst));
              end else begin     //smooth
                RD1 := Clamp0D(sDEcombSmooth - Result - msDEstop);
                dt := Clamp0D(sDEcombSmooth - Rst - msDEstop);
                Result := MinCD(Rst - RD1 * (sDEcombSmooth - dt) / sDEcombSmooth,
                             Result - dt * (sDEcombSmooth - RD1) / sDEcombSmooth);
              end;
              Rst := Abs(Rst);
              dt := 1 / (wt + Rst + s1em10);
              It3Dex.SmoothItD := (It3Dex.SmoothItD * wt + DEcombRec.bufIt3DSmoothItD * Rst) * dt;
              It3Dex.Otrap := (It3Dex.Otrap * wt + DEcombRec.bufIt3DOtrap * Rst) * dt;
            end;
        end;
        OTrapRestoreF1DEcomb(@DEcombRec, mctp);
      end;
      if bCalcInside then Result := msDEstop * 4 - Result * 3;
    end;
end;

end.
