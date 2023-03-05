unit HeaderTrafos;

// All kind of transformations between Header and Light values
// + calc Thread parameters

interface

uses TypeDefinitions, Math3D, Windows;

type
THybridPars = record
  start1, end1, repeat1: Integer;
  start2, end2, repeat2: Integer;
end;

procedure MakeLightValsFromHeaderLight(Header: TPMandHeader10; Lvals: TPLightVals; ImScale: Double; StereoMode: Integer);
procedure MakeLightValsFromHeaderLightNavi(Header: TPMandHeader10; Lvals: TPLightValsNavi; ImScale: Double);
function GetMCTparasFromHeader(var Header: TMandHeader10; bIniCalcMaps: LongBool): TMCTparameter;
//procedure MakeLightVals(H1, H2: TMandHeader10; var L1, L2: TLightVals);
procedure AssignLightVal(Ldest, Lsource: TPLightVals);
procedure AssignHeader(H1, H2: TPMandHeader10);
function isSingleF(HA: PTHeaderCustomAddon; var FirstIndex: Integer): LongBool;
procedure IniCFsFromHAddon(PHaddon: PTHeaderCustomAddon; PHCustomF: array of Pointer);
procedure Ini1CFfromHAddon(PHaddon: PTHeaderCustomAddon; PHCustomF: PTCustomFormula; i: Integer);
procedure CalcVGradsFromHeader8rots(Header: TPMandHeader10);
procedure GetHAddOnFromInternFormula(PMHeader: TPMandHeader10; f, t: Integer);
procedure NormVGrads(Header: TPMandHeader10);
function LengthOfSize(Header: TPMandHeader10): Double;
procedure CalcHSVecsFromLights(Lvals: TPLightVals; MCTpars: PMCTparameter);
function GetDEstopFactor(Header: TPMandHeader10): Double;
function CalcCamPos(Header: TPMandHeader10): TVec3D;
procedure StereoChange(Header: TPMandHeader10; Mode: Integer; var midPos: TVec3D; pMatrix: TPMatrix3);
function CalcXoff(Header: TPMandHeader10): Single;
procedure CalcPosLightsRelPos(Header: TPMandHeader10; Lvals: TPLightVals);
procedure CalcSCstartAndSCmul(Header: TPMandHeader10; var sCStart, sCmul: Single; bIsInside: LongBool);
function GetRealMidPos(Header: TPMandHeader10): TVec3D;
function CalcViewVecH(x, y: Single; header: TPMandHeader10): TVec3D;
procedure CheckDEoption(const startNr, endNr: Integer; pHCA: PTHeaderCustomAddon;
                        const PHCustomF: array of Pointer; var DEoption: Integer);
//procedure GetHybridPars(var HybridPars: THybridPars; pHCA: PTHeaderCustomAddon);
//procedure CalcPosLightsRelPosAni(Header: TPMandHeader10; Lvals: TPLightVals);

var calcHybridCustoms: array[0..5] of TCustomFormula;
    bGetMCTPverbose: LongBool = True;

const
  InternFormulaNames: array[0..9] of AnsiString = ('Integer Power', 'Real Power',
    'Quaternion', 'Tricorn', 'Amazing Box', 'Bulbox', 'Folding Int Pow','test',
    'testIFS', 'Aexion C');
  InternFormulaMax: Integer = 9;

implementation

uses Math, DivUtils, formulas, CustomFormulas, Mand, SysUtils, LightAdjust,
     Navigator, Animation, Interpolation, PaintThread, Types, DOF, Tiling,
     FileHandling, Calc, Maps{, OTrapDEcalc};

function GetDEstopFactor(Header: TPMandHeader10): Double;
var x1, x2, ze: Double;
begin
    with Header^ do
    begin
      CalcStepWidth(Header);
      ze := MaxCD(1e-16, (dZend - dZstart) / dStepWidth);
      if bPlanarOptic = 2 then
        x1 := s001 * Height / (Sin(s001) * Pi)
      else
        x1 := s001 * Height / (Sin(s001) * MaxCD(d1d65535, dFOVy * Pid180)); //relative camdistance, fixed sin
      x2 := dStepWidth * (x1 + ze) / x1;                                   // stepwidth at Zend
      Result := (x2 - dStepWidth) / (dStepWidth * MaxCD(d1d6, ze));
    end;
end;
                    //0..1
function CalcViewVecH(x, y: Single; header: TPMandHeader10): TVec3D;
var CAFX, CAFY, FOVXmul, FOVy, d: Double;
    VGrads: TMatrix3;
begin
    with header^ do
    begin
      CalcStepWidth(Header);
      VGrads := NormaliseMatrixTo(dStepWidth, @hVGrads);
      if bPlanarOptic = 2 then
      begin
        FOVy := Pi;
        FOVXmul := PiM2;
      end
      else
      begin
        FOVy := dFOVy * Pid180;
        FOVXmul := FOVy * Width / Height;
      end;
      CAFX := (CalcXoff(Header) - x) * FOVXmul;
      CAFY := (y - s05) * FOVy;
      if bPlanarOptic = 1 then
      begin
        Result[0] := -CAFX;
        Result[1] := CAFY;
        d := MinCS(1.5, MaxCS(s001, FOVy * s05));
        Result[2] := Cos(d) * d / Sin(d);
        NormaliseVectorVar(Result);
      end
      else if bPlanarOptic = 2 then
        BuildViewVectorDSphereFOV(CAFY, CAFX, @Result)
      else BuildViewVectorDFOV(CAFY, CAFX, @Result);
      RotateVectorReverse(@Result, @VGrads);
    end;
end;

function CalcCamPos(Header: TPMandHeader10): TVec3D;
var VPoff, startoff, s, c: Double;
    v: TVec3D;
begin
    with Header^ do
    begin
      CalcStepWidth(Header);
      if bStereoMode = 2 then VPoff := 0 else
      begin
        SinCosD(MinCD(Abs(dFOVy), 180) * Pid180 * s05, s, c);
        VPoff := dStepWidth * Height * s05 * c / MaxCD(0.01, s);  //offset viewplane to campos  ..here mindist add?
      end;
      startoff := dZstart - dZmid - VPoff;      //Zoffset campos to Zmid
      Result := GetRealMidPos(Header);
      v := CalcViewVecH(s05, s05, Header); //normed to dStepWidth!
      mAddVecWeight(@Result, @v, startoff / dStepWidth);
    end;
end;

function CalcXoff(Header: TPMandHeader10): Single;
var Xoff: Double;
begin
    with Header^ do
    begin
      Xoff := -0.065 / MaxCD(d1em100, StereoScreenWidth);
      Result := s05;
      case Header.bStereoMode of
        1: Result := s05 + Xoff;
        3: Result := s05 * (1 - Xoff);
        4: Result := s05 * (1 + Xoff);
      end;
    end;
end;

function GetRealMidPos(Header: TPMandHeader10): TVec3D;
var eyedist, Xadd: Double;
    v: TVec3D;
begin
    with Header^ do
    begin
      CalcStepWidth(Header);
      v := NormaliseVectorTo(dStepWidth, TPVec3D(@hVGrads)^);
      eyedist := -0.065 * Width * StereoScreenDistance / (StereoMinDistance * StereoScreenWidth);
      Xadd := 0;
      case Header.bStereoMode of
        1: Xadd := eyedist * (StereoScreenDistance - StereoMinDistance) / StereoScreenDistance;         //very left from midpos
        3: Xadd := -0.5 * eyedist * (StereoScreenDistance - StereoMinDistance) / StereoScreenDistance;  //right
        4: Xadd := s05 * eyedist * (StereoScreenDistance - StereoMinDistance) / StereoScreenDistance;   //left
      end;              //dest,      src,        add
      mCopyAddVecWeight(@Result, TPVec3D(@dXmid), @v, Xadd);
    end;
end;

procedure StereoChange(Header: TPMandHeader10; Mode: Integer; var midPos: TVec3D; pMatrix: TPMatrix3);
var eyedist, Xadd: Double;
    v: TVec3D;
begin
    with Header^ do
    begin
      CalcStepWidth(Header);
      v := NormaliseVectorTo(dStepWidth, TPVec3D(pMatrix)^);
      eyedist := 0.065 * Width * StereoScreenDistance / MaxCD(d1em100, (StereoMinDistance * StereoScreenWidth));
      Xadd := 0;
      case Mode of
        1: Xadd := -eyedist * (StereoScreenDistance - StereoMinDistance) / StereoScreenDistance;        //very left from midpos
        3: Xadd := s05 * eyedist * (StereoScreenDistance - StereoMinDistance) / StereoScreenDistance;   //right
        4: Xadd := -0.5 * eyedist * (StereoScreenDistance - StereoMinDistance) / StereoScreenDistance;  //left
      end;              //dest,      src,        add
      mCopyAddVecWeight(@midPos, TPVec3D(@dXmid), @v, Xadd);
    end;
end;

procedure Ini1CFfromHAddon(PHaddon: PTHeaderCustomAddon; PHCustomF: PTCustomFormula; i: Integer);
var dOptionVtmp: array[0..15] of Double;
    j: Integer;
begin
    with PHaddon.Formulas[i] do
    begin
      if (iFnr <= InternFormulaMax) and (iFnr >= 0) then
      begin
        SetCFoptionsFromOldF(iFnr, PHCustomF);
        PutStringInCustomF(CustomFname, InternFormulaNames[iFnr]);
      end
      else if (iFnr > 0) and (CustomFname[0] > 0) and LoadCustomFormulaFromHeader(CustomFname, PHCustomF^, dOptionVtmp) then
      begin
        iFnr := 20;
        if iOptionCount < PHCustomF.iCFOptionCount then
        begin  //fill all above loadedcount with defaults when loading formula
          if AnsiCompareText(CustomFtoStr(CustomFname), 'CylinderIFS') = 0 then
          begin
            if iOptionCount < 9 then
            begin
              dOptionValue[8] := dOptionValue[7];
              dOptionValue[7] := 0;
              if iOptionCount < 8 then dOptionValue[6] := 0;
              iOptionCount := 9;
            end;
          end
          else if AnsiCompareText(CustomFtoStr(CustomFname), 'SphereHeightMap') = 0 then
          begin
            for j := PHCustomF.iCFOptionCount - 1 downto 9 do
            begin
              dOptionValue[j] := dOptionValue[j - 1];
            end;
            dOptionValue[8] := 1;
            dOptionValue[2] := dOptionValue[2] / NotZero(dOptionValue[5]);
            dOptionValue[3] := dOptionValue[3] / NotZero(dOptionValue[6]);
            iOptionCount := PHCustomF.iCFOptionCount;
          end;
          for j := iOptionCount to PHCustomF.iCFOptionCount - 1 do //ini rest of values with defaults (Vtmp)
            dOptionValue[j] := dOptionVtmp[j];
          iOptionCount := PHCustomF.iCFOptionCount;
        end;
      end
      else
      begin
        iItCount := 0;
        iOptionCount := 0;
        iFnr := -1;
        CustomFname[0] := 0;
        Exit;
      end;
      CopyTypeAndOptionFromCFtoHAddon(PHCustomF, PHaddon, i);
    end;
end;

procedure GetHAddOnFromInternFormula(PMHeader: TPMandHeader10; f, t: Integer);
var i: Integer;
    pCF: PTCustomFormula;
const
    oa: array[0..9, 0..1] of Double = ((8,-1),(8,-1),(-1,0),(-2,1),(2,0.5),(2,0.5),(2,-1),(-1,0),(0,0),(8,1));
begin
    if f <= InternFormulaMax then
    with PTHeaderCustomAddon(PMHeader.PCFAddon).Formulas[t] do
    begin
      iFnr := f;
      pCF := PTCustomFormula(PMHeader.PHCustomF[t]);
      SetCFoptionsFromOldF(f, pCF);
      for i := 0 to 1 do dOptionValue[i] := oa[f][i];
      for i := 2 to 15 do dOptionValue[i] := 0;
      for i := 0 to 15 do byOptionType[i] := pCF.byOptionTypes[i];
      iOptionCount := pCF.iCFOptionCount;
      if f = 4 then dOptionValue[2] := 1  //Box
      else if f = 5 then   //BulBox
      begin
        dOptionValue[2] := 1;
        dOptionValue[3] := 1;
        dOptionValue[4] := 2;
        dOptionValue[5] := 2;
      end
      else if f = 6 then dOptionValue[2] := 2
      else if f = 7 then
      begin
        for i := 0 to testhybridOptionCount - 1 do dOptionValue[i] := testhybridOptionVals[i];
      end
      else if f = 8 then
      begin
        for i := 0 to testIFSOptionCount - 1 do dOptionValue[i] := testIFSOptionVals[i];
      end
      else if f = 9 then   //Aexion C  [Power, Z mul, Enable RotC (0,1), Cond Phi (0,1), Power C, Cz mul, PowC on dist Z-C, Mod (0,1)]
      begin
        dOptionValue[2] := 1;
        dOptionValue[3] := 1;
        dOptionValue[4] := 8;
        dOptionValue[5] := 1;
      end;
      PutStringInCustomF(CustomFname, InternFormulaNames[f]);
      CFdescription := CFdescriptionIntern[f];
    end;
end;

procedure IniCFsFromHAddon(PHaddon: PTHeaderCustomAddon; PHCustomF: array of Pointer);
var i, i2: Integer;
begin
    if (PHaddon.bOptions1 and 3) = 1 then i2 := 1 else i2 := 5;
    for i := 0 to i2 do Ini1CFfromHAddon(PHaddon, PHCustomF[i], i);
end;

procedure AssignHeader(H1, H2: TPMandHeader10);
var p6: TP6;
begin
    SaveHeaderPointers(H1, p6);
    H1^ := H2^;
    InsertHeaderPointers(H1, p6);
    PTHeaderCustomAddon(H1.PCFAddon)^ := PTHeaderCustomAddon(H2.PCFAddon)^;
end;

procedure NormVGrads(Header: TPMandHeader10);
begin
    CalcStepWidth(Header);
    with Header^ do hVGrads := NormaliseMatrixTo(dStepWidth, @hVGrads);
end;

function LengthOfSize(Header: TPMandHeader10): Double;
begin
    with Header^ do Result := Sqrt(Sqr(Width) + Sqr(Height));
end;

procedure AssignLightVal(Ldest, Lsource: TPLightVals);
begin
    Ldest^ := Lsource^;
    Ldest.PLValigned := TPLValigned((Integer(@Ldest.LColSbuf[0]) + 15) and $FFFFFFF0);
    Ldest.PLValigned^ := Lsource.PLValigned^;
end;

procedure CalcVGradsFromHeader8rots(Header: TPMandHeader10);
var Esin1, Esin2, Esin3, Ecos1, Ecos2, Ecos3: Double;
    step, x1, x2, y1, y2, z1, z2: Double;
    i: Integer;
begin
    with Header^ do       //calculate Vectors from Rotation settings
    begin
      SinCosD(dXWrot, Esin1, Ecos1);    // Y-Z rotation (X axis)
      SinCosD(dYWrot, Esin2, Ecos2);    // X-Z rotation (Y axis)
      SinCosD(dZWrot, Esin3, Ecos3);    // X-Y rotation (Z axis)
      step := 2.1345 / (dZoom * Width);
      if bCalc3D > 0 then
        step := step * (s001 + Abs(Cos(Max(-1.25, Min(1.25, dFOVy)) * s05)));
      for i := 0 to 2 do
      begin
        x1 := 0;
        y1 := 0;
        z1 := 0;
        case i of
          0:  x1 := step;    // calculate gradients in X direction
          1:  y1 := step;    // calculate gradients in Y direction
          2:  z1 := step;    // calculate gradients in Z direction
        end;
        x2 := x1;                       // rotate X axis
        y2 := Ecos1 * y1 + Esin1 * z1;
        z2 := Ecos1 * z1 - Esin1 * y1;
        x1 := Ecos2 * x2 + Esin2 * z2;  // rotate Y axis
        y1 := y2;
        z1 := Ecos2 * z2 - Esin2 * x2;
        PDouble(Integer(@hVGrads[0,0]) + i * 24)^ := Ecos3 * x1 + Esin3 * y1;  // rotate Z axis
        PDouble(Integer(@hVGrads[0,1]) + i * 24)^ := Ecos3 * y1 - Esin3 * x1;
        PDouble(Integer(@hVGrads[0,2]) + i * 24)^ := z1;
      end;
    end;
end;

function isSingleF(HA: PTHeaderCustomAddon; var FirstIndex: Integer): LongBool;
var i, j: Integer;
begin
    i := 0;
    FirstIndex := -1;
    for j := 0 to 5 do if HA.Formulas[j].iItCount > 0 then
    begin
      Inc(i);
      if FirstIndex = -1 then FirstIndex := j;
    end;
    Result := (i < 2);
    if Result and (HA.bOptions1 = 2) then FirstIndex := -1;  //not a valid formula option, need 2nd formula
end;

{procedure GetHybridPars(var HybridPars: THybridPars; pHCA: PTHeaderCustomAddon);
var x: Integer;
begin
    with HybridPars do
    begin
      start1 := 0;
      if (pHCA.bOptions1 and 3) = 1 then
      begin   //ipol hybrid
        end1 := 0;
        repeat1 := 0;
        start2 := 1;
        end2 := 1;
        repeat2 := 1;
        Exit;
      end;
   //   else
      begin
        x := 5;
        while (x > 0) and (pHCA.Formulas[x].iItCount = 0) do Dec(x);
        end1 := Min(x, pHCA.bHybOpt1 and 7);
        start2 := Max(end1 + 1, Min(x, pHCA.bHybOpt2 and 7));
        end2 := Max(start2, Min(x, (pHCA.bHybOpt2 shr 4) and 7));
        repeat2 := Max(start2, Min(end2, (pHCA.bHybOpt2 shr 8) and 7));  //start2, end2, repeat2    3x 4bit
        if (pHCA.bOptions1 and 3) = 0 then end1 := x;
        x := end1;
        while (x > 0) and (pHCA.Formulas[x].iItCount <= 0) do Dec(x);
        repeat1 := Min(x, pHCA.bHybOpt1 shr 4);
        if (pHCA.bOptions1 and 3) = 2 then
        begin
          x := 5;
          while (x > start2) and (pHCA.Formulas[x].iItCount <= 0) do Dec(x);
          repeat2 := Min(x, repeat2);
        end;
      end;
      pHCA.bHybOpt1 := end1 or (repeat1 shl 4);
      pHCA.bHybOpt2 := start2 or (end2 shl 4) or (repeat2 shl 8);
    end;
end;  }

procedure CheckDEoption(const startNr, endNr: Integer; pHCA: PTHeaderCustomAddon;
                        const PHCustomF: array of Pointer; var DEoption: Integer);
var i, de, difsShapes: Integer;
begin
    DEoption := -1;
    for i := startNr to endNr do if pHCA.Formulas[i].iItCount > 0 then
    begin
      de := PTCustomFormula(PHCustomF[i]).iDEoption;
      if (de < 0) or (de > 20) or (DEoption = de) then Continue;
      if de = 20 then Inc(difsShapes);
      if ((DEoption in [0..19]) and (de > 19)) or ((DEoption > 19) and (de in [0..19])) then
      begin
        DEoption := -1;
        Break;
      end
      else
      case DEoption of
      -1: DEoption := de;
       2: if not (de in [2,5,6,11]) then DEoption := 0;
       4: if not (de in [5,6]) then DEoption := 0;
       5: if de = 4 then DEoption := 4 else if de in [2,11] then DEoption := 2 else if de <> 6 then DEoption := 0;
       6: if de in [2,4,5,11] then DEoption := de else DEoption := 0;
      11: if de in [2,5] then DEoption := 2 else if de <> 6 then DEoption := 0;
      end;
    end;
    if DEoption > 19 then
      if difsShapes = 0 then DEoption := -1 else DEoption := 20;
end;

procedure CheckFormulaOptions(const startNr, endNr: Integer; pHCA: PTHeaderCustomAddon;
                              const PHCustomF: array of Pointer; var DEoption: Integer;
                              var MandFunctionDE: TMandFunctionDE; var MandFunction: TMandFunction;
                              var nHybrid: array of Integer; const bDisableADE: LongBool);
var i, de, difsShapes, LastValidF, LastF: Integer;
begin
    DEoption := -1;
    difsShapes := 0;
    LastValidF := startNr;
    LastF := startNr;
    for i := startNr to endNr do if nHybrid[i] <> 0 then
    begin
      LastF := i;
      de := PTCustomFormula(PHCustomF[i]).iDEoption;
      if (de < 0) or (de > 20) then nHybrid[i] := -Abs(nHybrid[i])
                               else LastValidF := i;
      if (de < 0) or (DEoption = de) then Continue;
      if de = 20 then Inc(difsShapes);
      if ((DEoption in [0..19]) and (de > 19)) or ((DEoption > 19) and (de in [0..19])) then
      begin
        DEoption := -1;
        Mand3DForm.OutMessage('Error, mixing of dIFS with other formulas will not work!');
        Break;
      end
      else
      case DEoption of
-1,21,22: DEoption := de;
       2: if not (de in [2,5,6,11]) then DEoption := 0;
       4: if not (de in [5,6]) then DEoption := 0;
       5: if de = 4 then DEoption := 4 else if de in [2,11] then DEoption := 2 else if de <> 6 then DEoption := 0;
       6: if de in [2,4,5,11] then DEoption := de else DEoption := 0;
      11: if de in [2,5] then DEoption := 2 else if de <> 6 then DEoption := 0;
      end;
      if bDisableADE then
      case DEoption of
    2,11: DEoption := 0;
     5,6: DEoption := 4;
      end;
    end;
    if startNr < (pHCA.bHybOpt2 and 7) then
    begin
      if LastValidF < (pHCA.bHybOpt1 shr 4) then pHCA.bHybOpt1 := (pHCA.bHybOpt1 and 7) or (LastValidF shl 4);
      if (pHCA.bOptions1 = 2) and (pHCA.bOptions3 = 5) and ((DEoption < 0) or (DEoption > 20)) then
      for i := startNr to endNr do if nHybrid[i] <> 0 then
      begin
        nHybrid[i] := Abs(nHybrid[i]);
        DEoption := Max(0, PTCustomFormula(PHCustomF[i]).iDEoption);
        Inc(difsShapes);
        Break;
      end;
    end                                    //mix
    else
    begin
      if LastValidF < (pHCA.bHybOpt2 shr 8) then pHCA.bHybOpt2 := (pHCA.bHybOpt2 and $77) or (LastValidF shl 8);
      pHCA.bHybOpt2 := (pHCA.bHybOpt2 and $707) or (LastF shl 4);
    end;
    if DEoption > 19 then
    begin
      if difsShapes = 0 then
      begin
        DEoption := -1;
        Mand3DForm.OutMessage('Error, no dIFS shape formula selected.');
      end
      else DEoption := 20;
    end;
    MandFunction := fIsMemberAlternating;
    MandFunctionDE := fIsMemberAlternatingDE;
    case DEoption of
    4..6: begin
            MandFunctionDE := doHybrid4DDEPas;
            MandFunction := fIsMemberAlternating4D;
          end;
      20: MandFunctionDE := doHybridIFS3D;// MandFunction := doHybridIFS3D; end;
    end;
end;
      {DEoption: [0,1]:   3D
                 [2,11] = 3D ADE  [11] ABox
                 [4]:     4D
                 [5,6]:   4D ADE  [6] ABox
                 [20..22]: dIFS   [20] dIFS shapes}

function GetMCTparasFromHeader(var Header: TMandHeader10; bIniCalcMaps: LongBool): TMCTparameter;
var x1, x2, y1, z1, z2: Double;
    n, x, i, j, ia, i52, itmp: Integer;
    bIsInterpolHybrid, bDisableADE, bIsDEcomb, bTmp, bSecondPart: LongBool;
    TileRect: TRect;
    Crop: Integer;
    PCFA: PTHeaderCustomAddon;
begin                                //calcHybridFormulas -> usage of own calcformulas! ->formulaclass
    with Header do
    begin
      PCFA := PTHeaderCustomAddon(PCFAddon);
      CheckHybridOptions(PCFA);
      //GetHybridPars(HybridPars, PCFAddon);
      Result.StartFrom1  := 0;
      Result.wEndTo      := PCFA.bHybOpt1 and 7;
      Result.RepeatFrom1 := PCFA.bHybOpt1 shr 4;
      Result.StartFrom2  := PCFA.bHybOpt2 and 7;
      Result.iEnd2       := (PCFA.bHybOpt2 shr 4) and 7;
      Result.RepeatFrom2 := (PCFA.bHybOpt2 shr 8) and 7;

      Result.CalcDE      := CalcDEfull;
      Result.iSmNormals  := (iOptions shr 6) and 15;
      Result.msDEstop    := MaxCS(s0001, sDEstop);
      Result.DEstop      := Result.msDEstop;
      Result.sZstepDiv   := MaxCS(0.0001, mZstepDiv);
      Result.iDEAddSteps := bStepsafterDEStop;
      Result.iMandHeight := Height;
      Result.iMandWidth  := Width;
      if Header.TilingOptions <> 0 then
        GetTilingInfosFromHeader(@Header, Result.CalcRect, Crop)
      else Result.CalcRect := Rect(0, 0, Width - 1, Height - 1);
      Result.SLoffset := GetTileSize(@Header).X * SizeOf(TsiLight5);
      Result.SLoffsetExt := GetTileSize(@Header).X * SizeOf(TMCrecordExt);
      StereoChange(@Header, bStereoMode, TPVec3D(@Result.Xmit)^, @hVgrads);
      Result.bInsideRendering := (PCFA.bOptions2 and 6) <> 0;
      Result.bInAndOutside := (PCFA.bOptions2 and 4) <> 0;
      Result.bCalcInside := Result.bInsideRendering;
      if bPlanarOptic = 2 then Result.FOVy := Pi else Result.FOVy := dFOVy * Pid180;
      Result.iMaxIt      := Iterations;
      Result.iMinIt      := Min(Iterations, MinimumIterations);
      Result.iMaxitF2    := iMaxItsF2;
      Result.calc3D      := bCalc3D <> 0;
      Result.ColorOption := Min(5, byColor2Option); //(Light.TBoptions and $20000) shr 17;  // for navigator  + new color choices 0..6
      Result.ColorOnIt   := bColorOnIt;
      Result.calcHardShadow := bCalculateHardShadow or (bCalc1HSsoft shl 8);
      Result.dRstop      := Sqr(RStop);
      Result.Rstop3D     := Sqr(Result.dRstop) * 64;
      Result.iCutOptions := bCutOption;
      FastMove(dCutX, Result.dCOX, 24);
      Result.bDoJulia    := bIsJulia <> 0;
      FastMove(dJx, Result.dJUx, 24);
      Result.dJUw        := dJw;
      Result.dDEscale    := 1;
      Result.pAl16vars   := PAligned16;
      Result.bVaryDEstop := (bVaryDEstopOnFOV <> 0);
      Result.Vgrads      := hVGrads;
      Result.DEAOmaxL    := sDEAOmaxL;
      Result.DEmixCol    := DEmixColorOption;
      Result.FmixPow     := sFmixPow;
      Result.SoftShadowRadius := ShortFloatToSingle(@MCSoftShadowRadius);
      Result.iSliceCalc  := bSliceCalc;  // default=mid,  must set properly by procedure after getMCT
      Result.MCTCameraOptic := Min(2, bPlanarOptic and 3);
  //    Result.bDoubleCheck := (iOptions and 2) > 0;
      Result.sHSmaxLengthMultiplier := HSmaxLengthMultiplier;
      Result.AOdither := AODEdithering;
      Result.bCalcAmbShadow := (bCalcAmbShadowAutomatic and 1) <> 0;
      x1 := Min(1.5, Max(s001, Result.FOVy * s05));
      Result.mctPlOpticZ := Cos(x1) * x1 / Sin(x1);
      Result.DFogOnIt := bDFogIt;
      if (bVolLightNr and 7) > 0 then Result.DFogOnIt := 65535;
      n := Min(5, Max(0, (bVolLightNr and 7) - 1));
      if (Light.Lights[n].Loption and 4) <> 0 then //poslight
      Result.VLmul := 1000 * ShortFloatToSingle(@Light.Lights[n].Lamp) / Width else
      Result.VLmul := 300 * ShortFloatToSingle(@Light.Lights[n].Lamp) / Width;
      Result.VLstepmul := Sqrt(1 / (1 + 0.1 * ((bVolLightNr shr 4) - 2)));

      Result.FOVXoff := CalcXoff(@Header) * Width;
      if bPlanarOptic = 2 then Result.FOVXmul := PiM2 / Width else Result.FOVXmul := Result.FOVy / Height;
      MakeCustomFsFromHeader(Header);

      bIsInterpolHybrid := (PCFA.bOptions1 and 3) = 1;
      if bIsInterpolHybrid then i52 := 1 else i52 := 5;
      bIsDEcomb := (PCFA.bOptions1 and 3) = 2;
      if bIsDEcomb then Result.FormulaType := Min(6 , Max(1, PCFA.bOptions3 + 1))
                   else Result.FormulaType := 0;
      bDisableADE := (PCFA.bOptions2 and 1) <> 0;
      if not bIsDEcomb then Result.iMaxitF2 := Result.iMaxIt;

      if bIsInterpolHybrid then
      begin
        Result.wEndTo := 1;
        CheckDEoption(0, 1, PCFA, PHCustomF, Result.DEoption);
        Result.DEoption2 := Result.DEoption;
        if Result.DEoption in [4..6] then
        begin
          Result.mMandFunction := doInterpolHybridPas4D;
          Result.mMandFunctionDE := doInterpolHybridPas4DDE;
        end
        else
        begin
          Result.mMandFunction := fIsMemberIpol;
          Result.mMandFunctionDE := fIsMemberIpolDE;
        end;
        Result.mMandFunction2 := Result.mMandFunction;
        Result.mMandFunctionDE2 := Result.mMandFunctionDE;
        Result.IsCustomDE := Result.DEoption in [2,5,6,11];
        Result.IsCustomDE2 := Result.IsCustomDE;
        if Result.isCustomDE then Result.CalcDE := CalcDEanalytic
                             else Result.CalcDE := CalcDEnoADE;
        n := -2;
        if Result.DEoption in [20..22] then
          Mand3DForm.OutMessage('Error, dIFS do not work in interpolation hybrid.')
        else for x := 0 to 1 do
          if PTHeaderCustomAddon(PCFAddon).Formulas[x].iFnr >= 0 then Inc(n);
        x1 := PSingle(@PCFA.Formulas[0].iItCount)^;
        x2 := PSingle(@PCFA.Formulas[1].iItCount)^;
        y1 := x1 + x2;
        if y1 < 1e-10 then
        begin
          y1 := 1;
          x1 := 1;
          x2 := 0;
        end
        else y1 := 1 / y1;
        PSingle(@Result.nHybrid[0])^ := x1 * y1;
        PSingle(@Result.nHybrid[1])^ := x2 * y1;
      end
      else
      begin
        isSingleF(PCFA, n);
        for x := 0 to 5 do Result.nHybrid[x] := PCFA.Formulas[x].iItCount;

        CheckFormulaOptions(0, Result.wEndTo, PCFA, PHCustomF, Result.DEoption,
          Result.mMandFunctionDE, Result.mMandFunction, Result.nHybrid, bDisableADE);
        if (PCFA.bHybOpt1 shr 4) < Result.RepeatFrom1 then
          Result.RepeatFrom1 := Min(Result.RepeatFrom1, PCFA.bHybOpt1 shr 4);
        Result.IsCustomDE := Result.DEoption in [2,5,6,11,20];
     //   if (Result.DEoption <> 20) and bDisableADE then Result.IsCustomDE := False;

        if not bIsDEcomb then Result.DEoption2 := 0 else
        begin
          CheckFormulaOptions(Result.StartFrom2, 5{Result.iEnd2}, PCFA,
                              PHCustomF, Result.DEoption2, Result.mMandFunctionDE2,
                              Result.mMandFunction2, Result.nHybrid, bDisableADE);
          Result.IsCustomDE2 := Result.DEoption2 in [2,5,6,11,20];
       //   if (Result.DEoption2 <> 20) and bDisableADE then Result.IsCustomDE2 := False;
          if Result.FormulaType > 5 then
          begin
            if Result.DEoption2 <> 20 then
            begin
              Mand3DForm.OutMessage('Error, second hybrid type must be dIFS.');
              Result.bMCTisValid := False;
            end
            else Result.mMandFunctionDE2 := doHybridIFS3DnoVecIni;
          end;
        end;
        if bIsDEcomb then Result.CalcDE := CalcDEfull else
        if Result.isCustomDE then Result.CalcDE := CalcDEanalytic
                             else Result.CalcDE := CalcDEnoADE;
      end;

      with Result do
      begin
        bMCTisValid := (n >= 0) and (DEoption >= 0) and ((DEoption2 >= 0) or not bIsDEcomb);
        if ((DEoption = 20) or (DEoption2 = 20)) and not SupportSSE2 then
        begin
          bMCTisValid := False;
          Mand3DForm.OutMessage('Error, CPU must support SSE2 for dIFS.');
          Exit;
        end;
        if bMCTisValid then
        begin
          dColPlus := 0;  //for am.box color vary on scale
          dDEscale := 1;
          dDEscale2 := 1;
          n  := 0;    //calc DEscale
          x1 := 0;
          y1 := 0;
          i  := 0;    //for both hybrid parts..
          ia := 0;
          itmp := 0;
          for x := 0 to i52 do
          begin
            if bIsInterpolHybrid or (nHybrid[x] <> 0) then
            begin
              fHPVar[x] := PTCustomFormula(PHCustomF[x]).pConstPointer16;
              if bIsInterpolHybrid or (nHybrid[x] > 0) then
              begin
                if PTCustomFormula(PHCustomF[x]).dSIpow > 1 then
                  z1 := PTCustomFormula(PHCustomF[x]).dSIpow
                else //if PTHeaderCustomAddon(PCFAddon).Formulas[x].byOptionType[0] in [0, 14] then
                  z1 := PCFA.Formulas[x].dOptionValue[0]; //must be smarter , check name (pow, scale)
                Result.fHln[x] := 1 / Ln(MaxCD(2, Abs(z1)));
              end
              else Result.fHln[x] := 1 / Ln(2);
              bSecondPart := x > wEndTo;
              if bSecondPart then bTmp := IsCustomDE2 else bTmp := IsCustomDE;
              if bSecondPart and (itmp = 0) then
              begin
                Inc(itmp);
                if (n > 0) and (DEoption <> 20) then
                begin
                  dDEscale := x1 / n;
                  if i > 0 then dColPlus := Power(Abs(y1 / i), 0.25) * 40 - 49;
                  ia := i;
                end;
                n  := 0;
                x1 := 0;
                y1 := 0;
                i  := 0;
              end;
              AssignCustomFormula(@calcHybridCustoms[x], PTCustomFormula(PHCustomF[x]));
              fHybrid[x] := ThybridIteration2(calcHybridCustoms[x].pCodePointer);
              if bIsInterpolHybrid then z1 := PSingle(@nHybrid[x])^
                                   else z1 := Abs(nHybrid[x]);
              j := PTCustomFormula(PHCustomF[x]).iDEoption;
              if bTmp and (bIsInterpolHybrid or (nHybrid[x] > 0)) and (j in [5,11]) then
              begin
                if bIsInterpolHybrid then Inc(n) else n := n + Abs(nHybrid[x]);
                if bIsInterpolHybrid then Inc(i) else i := i + Abs(nHybrid[x]);
                x2 := NotZero(PDouble(Integer(calcHybridCustoms[x].pConstPointer16) - 16)^);
                if x2 < 0 then x1 := x1 + 0.65 * z1
                          else x1 := x1 + (x2 * 1.2 + 1) / x2 * z1;
                y1 := y1 + Abs(x2) * z1;
              end
              else if bIsInterpolHybrid or (PTCustomFormula(PHCustomF[x]).iDEoption >= 0) then
              begin
                if bIsInterpolHybrid then Inc(n) else n := n + Abs(nHybrid[x]);
                if bTmp then x1 := x1 + PTCustomFormula(PHCustomF[x]).dADEscale * z1
                        else x1 := x1 + PTCustomFormula(PHCustomF[x]).dDEscale * z1;
                if (PCFA.Formulas[x].iFnr = 4) and not bTmp then
                begin
                  ThybridIteration(calcHybridCustoms[x].pCodePointer) := fHybridCube;
                  fHybrid[x] := ThybridIteration2(calcHybridCustoms[x].pCodePointer);
                end;
              end;
              if (not bIsInterpolHybrid) and (nHybrid[x] < 0) then
              nHybrid[x] := Abs(nHybrid[x]) or -2147483648; //-> $80000000; set high bit only, not negative!
            end
            else
            begin
              if calcHybridCustoms[x].bCPmemReserved then
                VirtualFree(calcHybridCustoms[x].pCodePointer, 4096, MEM_DECOMMIT);
              ThybridIteration(calcHybridCustoms[x].pCodePointer) := EmptyFormula;
              calcHybridCustoms[x].bCPmemReserved := False;
            end;
          end;
          for x := i52 + 1 to 5 do
          begin
            if calcHybridCustoms[x].bCPmemReserved then
              VirtualFree(calcHybridCustoms[x].pCodePointer, 4096, MEM_DECOMMIT);
            ThybridIteration(calcHybridCustoms[x].pCodePointer) := EmptyFormula;
            calcHybridCustoms[x].bCPmemReserved := False;
          end;
          if (bIsDEcomb or (itmp = 0)) and (n > 0) and (DEoption2 <> 20) then
          begin
            if bIsInterpolHybrid then n := 1;
            dDEscale2 := x1 / n;
            if (i > ia) then dColPlus := Power(Abs(y1 / i), 0.25) * 40 - 49;
            if itmp = 0 then result.dDEscale := result.dDEscale2;
          end;

          mctColorMul := sColorMul * 512;  //LLI multiplier
          CalcPPZvals(Header, Zcorr, ZcMul, Zend);
          sZZstmitDif := Zend;
          StepWidth := dStepWidth;
          Zend := MaxCD(1e-10, (dZend - dZstart) / StepWidth);
          mctColVarDEstopMul := 0.6;  // calc parameter for keeping the colortabindex constant on zooming in (more or less)
    {      if bIsInterpolHybrid then
          begin
            x2 := 0;
            for x := 0 to 1 do if PSingle(@nHybrid[x])^ > 0 then
            begin
              y1 := PSingle(@nHybrid[x])^;
              x2 := x2 + y1;                               //?? plenty
              if PTCustomFormula(PHCustomF[x]).iDEoption in [1..3, 5..40] then
              if PCFA.Formulas[x].byOptionType[0] in [0, 14] then
              begin
                x1 := PDouble(Integer(calcHybridCustoms[x].pConstPointer16) - 16)^;
                if x1 > 1 then mctColVarDEstopMul := mctColVarDEstopMul + y1 * s05 / (ln(x1) + 0.03)
                else if x1 < -1 then mctColVarDEstopMul := mctColVarDEstopMul + y1 * s05 / (ln(-x1) + 0.03)
                else x2 := x2 - y1;
              end
              else if PTCustomFormula(PHCustomF[x]).iDEoption in [0, 4] then
                mctColVarDEstopMul := mctColVarDEstopMul + y1 * 0.6
              else x2 := x2 - y1;
            end;
            if x2 > 0 then mctColVarDEstopMul := mctColVarDEstopMul / x2
            else mctColVarDEstopMul := 0.6;
          end
          else  }
          begin
            ia := 0;
            itmp := 0;
            y1 := 0;
            z1 := 0;
            z2 := 0;
            bSecondPart := False;
            for x := 0 to i52 do if bIsInterpolHybrid or (nHybrid[x] > 0) then
            begin
              if (x > wEndTo) and not bSecondPart then
              begin
                bSecondPart := True;
                if z1 > 0 then mctColVarDEstopMul := y1 / z1 else mctColVarDEstopMul := 0.6;
                z2 := z1;
                z1 := 0;
                y1 := 0;
                if (DEoption2 = 20) or not bIsDEcomb then Break;
              end;
              if bIsInterpolHybrid then x2 := PSingle(@nHybrid[x])^ else x2 := nHybrid[x];
              if PTCustomFormula(PHCustomF[x]).iDEoption in [0, 4] then
              begin
                y1 := y1 + x2 * 0.6;
                z1 := z1 + x2;
              end
              else if PTCustomFormula(PHCustomF[x]).iDEoption in [1..3, 5..40] then
              begin   //check type
                if PCFA.Formulas[x].byOptionType[0] in [0, 14] then //and scale or power
                begin
                  x1 := PDouble(Integer(calcHybridCustoms[x].pConstPointer16) - 16)^;
                  if x1 > 1 then
                  begin
                    if x1 < 1.2 then x1 := 1.1 + Sqr(x1 - 1) * 2.5;
                    y1 := y1 + x2 * s05 / (ln(x1) + 0.03);
                    z1 := z1 + x2;
                  end
                  else if x1 < -1 then
                  begin
                    if x1 > -1.2 then x1 := -1.1 - Sqr(x1 + 1) * 2.5;//ln(3)   1/1.1
                    y1 := y1 + x2 * s05 / (ln(-x1) + 0.03);  //ln(2)=0.693147  1/1.4427
                    z1 := z1 + x2;                           //ln(1.3)=0.26236 1/3.8115
                  end;                                       //ln(1.1)=0.09531
              {  end
                else  //test
                begin
                  y1 := y1 + x2 * 0.6;
                  z1 := z1 + x2;  }
                end;                                                                                                                                //ln(1.3)=0.26236 1/ 3.8115
              end;
            end
            else if (not bIsInterpolHybrid) and (nHybrid[x] < 0) then if x > wEndTo then Inc(ia) else Inc(itmp);
            if ((z1 >= z2) and (z1 > 1e-3)) or ((ia > itmp) and (Abs(z1 - z2) < 1e-3) and (z1 > 1e-3)) then
              mctColVarDEstopMul := y1 / z1
            else if z2 < 1e-3 then mctColVarDEstopMul := 0.6;
          end;

          bMCTFirstStepRandom := (iOptions and 1) <> 0;
          mctMH04ZSD := Max(iMandWidth, iMandHeight) * s05 * Sqrt(sZstepDiv + s0001) * MaxCS(s001, sRaystepLimiter);  //* DEstop  in calculation
          if bVaryDEstop then mctDEstopFactor := GetDEstopFactor(@Header)
                         else mctDEstopFactor := 0;
          dLNRStop := Ln(Ln(RStop));
          NormalsOnDE := (bNormalsOnDE > 0) or IsCustomDE;

          if bIsInterpolHybrid then result.fHln[0] := fHln[0] * PSingle(@nHybrid[0])^ + fHln[1] * PSingle(@nHybrid[1])^;

          if bPlanarOptic = 2 then //pano
          begin
            x1 := 0;
            y1 := 0;
          end else begin
            x1 := iMandWidth * s05;
            y1 := iMandHeight * s05;
          end;
          x2 := StepWidth;
          if calc3D or (iSliceCalc = 1) then z1 := (dZstart - dZmid) / StepWidth
          else if iSliceCalc = 3 then
          begin
            x2 := x2 * (1 + Sin(FOVy) * Zend / iMandHeight);
            z1 := (dZend - dZmid) / x2;
          end else begin
            iSliceCalc := 2;
            z1 := 0;
            x2 := x2 * (1 + Sin(FOVy) * (dZmid - dZstart) / (StepWidth * iMandHeight));
          end;
          VGrads := NormaliseMatrixTo(x2, @hVGrads);
          Ystart[0] := Xmit + z1 * Vgrads[2, 0] - y1 * Vgrads[1, 0] - x1 * Vgrads[0, 0];
          Ystart[1] := Ymit + z1 * Vgrads[2, 1] - y1 * Vgrads[1, 1] - x1 * Vgrads[0, 1];
          Ystart[2] := Zmit + z1 * Vgrads[2, 2] - y1 * Vgrads[1, 2] - x1 * Vgrads[0, 2];
          mctDEoffset := Min(msDEstop * 0.1, 0.004); //for 4point DE calculation

          for x := 0 to 5 do pInitialization[x] := nil;

          if DEoption = 20 then dDEscale := 1;
          if DEoption2 = 20 then dDEscale2 := 1;
          if (DEoption = 20) or (DEoption2 = 20) then  //dIFS
          begin
            iDEAddSteps := Max(iDEAddSteps, Round(MinCS(1, sZstepDiv) * 2) + 2);
            if (not bIsDEcomb) or (FormulaType < 5) then iMinIt := 1;
            bIsIFS := True;
            NormalsOnDE := True;
          end
          else bIsIFS := False;

          if (DEoption = 20) and ((not bIsDEcomb) or (DEoption2 = 20)) then
          begin
            mctMH04ZSD := Max(iMandWidth, iMandHeight);    //raystep limiter
            mctColVarDEstopMul := 0;
          end;

          if FormulaType > 5 then i := iMaxIt + iMaxitF2
                             else i := Max(iMaxIt, iMaxitF2);
          mctsM := 32767 / Max(1, i + 1);
          dColPlus := dColPlus + i * 0.1;
          //new:
       //   dColPlus := i * 0.1 - ln(msDEstop * StepWidth);  //- -12
          sStepWm103 := StepWidth * 1.03;
          BuildSMatrix4(dXWrot, dYWrot, dZWrot, Smatrix4d);
          if iCutOptions > 0 then iCutOptions := iCutOptions or
            ((Ord(Vgrads[2,0] > 0) and 1) shl 4) or
            ((Ord(Vgrads[2,1] > 0) and 1) shl 5) or
            ((Ord(Vgrads[2,2] > 0) and 1) shl 6);
          FSIstart  := mFSIstart;   //for montecarlo etc   //tiling?
          FSIoffset := mFSIoffset;

   {    //   if OTrapMode then
          begin
            NormalsOnDE := True;
            if bIsDEcomb then CalcDE := CalcOTrapDEfull
                         else CalcDE := CalcOTrapDE;
            IsCustomDE := True;
            IsCustomDE2 := True;
            dDEscale := 1;
            dDEscale2 := 1;

            mMandFunction := do3DalternateOTrap;
            if bIsDEcomb then CalcDE := CalcOTrapDEfull
                         else CalcDE := CalcOTrapDEnoADE;
            IsCustomDE := False;
            IsCustomDE2 := False;

          end;  }
          IsCustomDE1 := IsCustomDE;
          if IsCustomDE then dDEscale := dDEscale / dStepWidth
                        else dDEscale := dDEscale * mctDEoffset;
          if bIsDEcomb then
          begin
            NormalsOnDE := True;
            sDEcombSmooth := MaxCS(1e-30, sDEcombS) / dStepWidth;
            if IsCustomDE2 then dDEscale2 := dDEscale2 / dStepWidth
                           else dDEscale2 := dDEscale2 * mctDEoffset;
            if DEoption2 <> 20 then bIsIFS := False;  //just taken from previous version
          end;

          mctDEoffset006 := mctDEoffset * s006;
          mctDEoffset := mctDEoffset * StepWidth; //new

          if NormalsOnDE then TCalculateNormalsFunc(pCalcNormals) := RMCalculateNormals
                         else TCalculateNormalsFunc(pCalcNormals) := RMCalculateNormalsOnSmoothIt;
          if (iOptions and 4) = 0 then msDEsub := 0 else
          begin
            sZstepDiv := sZstepDiv * sZstepDiv + (1.2 * sZstepDiv) * (1 - sZstepDiv);
            msDEsub := MinCS(0.9, Sqrt(sZstepDiv));
          end;
          if bMCTisValid then
          begin
            if bIniCalcMaps then
            try
              IniCalcMaps(@Header);
            except
              if bGetMCTPverbose then Mand3DForm.OutMessage('Error in calcmap init.');
            end;
            if bGetMCTPverbose then Mand3DForm.OutMessage('Parameters ok.');
          end;
        end;
        if not bMCTisValid then Mand3DForm.OutMessage('Error, formula option is not valid.');
      end;
    end;
end;

procedure CalcHSVecsFromLights(Lvals: TPLightVals; MCTpars: PMCTparameter);
var i: Integer;
    M: TMatrix3;
begin
    M := NormaliseMatrixTo(1, @MCTpars.VGrads);
    for i := 0 to 5 do
      if (Lvals.iLightPos[i] and 1) = 0 then
      begin
        MCTpars.HSvecs[i] := NormaliseSVectorTo(-MCTpars.StepWidth, Lvals.PLValigned.LN[i]);
        RotateVectorReverse(@MCTpars.HSvecs[i], @M);
      end
      else MCTpars.HSvecs[i] := AddSVec2Vec3(@Lvals.PLValigned.LN[i], @MCTpars.Xmit); //for mc
end;

function HSumSVec(sv: TSVec): Single;
begin
    Result := (sv[0] + sv[1] + sv[3]) * s1d3;
end;

function DistanceFromViewVecToLightPos(var ViewVec, LightPos, SPos: TSVec): Double;
var V1, V2: TSVec;
begin
    V1 := SubtractSVectors(@LightPos, SPos);
    V2[0] := V1[1] * (V1[2] - ViewVec[2]) - V1[2] * (V1[1] - ViewVec[1]);  //min distance from viewvec to lightpoint
    V2[1] := V1[2] * (V1[0] - ViewVec[0]) - V1[0] * (V1[2] - ViewVec[2]);
    V2[2] := V1[0] * (V1[1] - ViewVec[1]) - V1[1] * (V1[0] - ViewVec[0]);
    Result := Sqrt(V2[0] * V2[0] + V2[1] * V2[1] + V2[2] * V2[2]);
end;

procedure CalcXYZposForLight(Header: TPMandHeader10; Lpos: TSVec; var x, y, z: Single; bPos: LongBool);
var i: Integer;
    aspect: Single;
    d, dx, dy, dmul, dd: Double;
    PLV: TPaintLightVals;
    SPosX, StartPos, SPosXadd, SPosYadd: TSVec;
    PaintParameter: TPaintParameter;
    PaintVGrads, mt: TMatrix3;
    dv: TVec3D;
procedure MakePLVforXY(mx, my: Double);
begin
    SPosX := StartPos;
    AddSVecWeight(@SPosX, @SPosYadd, my);
    AddSVecWeight(@SPosX, @SPosXadd, mx);
    PLV.yPos := my / PaintParameter.ppHeight;
    PLV.xPos := mx / PaintParameter.ppWidth;
    PLV.sFOVy := PaintParameter.sFOVy;
    CalcViewVec(@PLV, aspect);
    PLV.AbsViewVec := PLV.ViewVec;
    RotateSVectorS(@PLV.AbsViewVec, @PaintParameter.m);
end;
begin
    PaintVGrads := NormaliseMatrixTo(Header.dStepWidth, @Header.hVGrads);
    with PaintParameter do
    begin
      ppWidth  := Header.Width;
      ppHeight := Header.Height;
      ppYinc   := 1;
      pVgrads  := @PaintVGrads;
      sFOVy    := Header.dFOVy * Pid180;
      ppXOff   := CalcXoff(Header);
      CalcPPZvals(Header^, Zcorr, ZcMul, ZZstmitDif);
      StepWidth := Header.dStepWidth;
      ppPlanarOptic := Header.bPlanarOptic and 3;
      if ppPlanarOptic = 2 then sFOVy := Pi;
      d := Min(1.5, Max(s001, sFOVy * s05));
      ppPlOpticZ := Cos(d) * d / Sin(d);
      GetStartSPosAndAddVecs(PLV, PaintParameter, StartPos, SPosYadd, SPosXadd);
      aspect := ppWidth / ppHeight;
      dmul := s0001 / StepWidth;
      i := 20;
      x := ppWidth * s05;
      y := ppHeight * s05;
      z := 0;
      repeat
        MakePLVforXY(x, y);
        if bPos then    //posLight     use 3 point method for 2dvec to minimum distance
        begin
          d := DistanceFromViewVecToLightPos(PLV.AbsViewVec, Lpos, SPosX) * dmul;
          if d < 1e-4 then Break;
          MakePLVforXY(x + s001, y);
          dx := d - DistanceFromViewVecToLightPos(PLV.AbsViewVec, Lpos, SPosX) * dmul;
          MakePLVforXY(x, y + s001);
          dy := d - DistanceFromViewVecToLightPos(PLV.AbsViewVec, Lpos, SPosX) * dmul;
          dd := Sqrt(dx * dx + dy * dy) + 1e-16;
          if dd * 2 > d then Break;
          x := x + Sign(dx) * d * 4e-3 / dd;
          y := y + Sign(dy) * d * 4e-3 / dd;
        end else begin  //global light, Lpos is already lightvec
          d := ArcCosSafe(DotOfSVectors(PLV.ViewVec, Lpos));  //0..pi
          if d < 1e-4 then Break;
          MakePLVforXY(x + s001, y);
          dx := d - ArcCosSafe(DotOfSVectors(PLV.ViewVec, Lpos));
          MakePLVforXY(x, y + s001);
          dy := d - ArcCosSafe(DotOfSVectors(PLV.ViewVec, Lpos));
          dd := Sqrt(dx * dx + dy * dy) + 1e-16;
          if dd * 2 > d then Break;
          x := x + Sign(dx) * d * 5e-3 / dd;
          y := y + Sign(dy) * d * 5e-3 / dd;
        end;
        Dec(i);
      until i < 0;
      x := x / ppWidth;
      y := y / ppHeight;
    //  if bPos then //calc z
      begin                                      //lightpos - campos
        if Abs(PLV.AbsViewVec[0]) > s05 then z := (Lpos[0] - SPosX[0]) / PLV.AbsViewVec[0] else
        if Abs(PLV.AbsViewVec[1]) > s05 then z := (Lpos[1] - SPosX[1]) / PLV.AbsViewVec[1]
                                        else z := (Lpos[2] - SPosX[2]) / PLV.AbsViewVec[2];
        //New: take care of viewplane:
        mt := NormaliseMatrixTo(1, @Header.hVGrads);
        dv := ScaleVector(TPVec3D(@mt[2])^, Header.dZstart - Header.dZmid);
        dv := SubtractVectors(SVecToDVec(Lpos), @dv);             //vec from cam to light
        d := DotOfVectors(@dv, @mt[2]);                            //min distance from viewplane to lightpos... is not the distance at lightvec to poslight! (only if FOVy=0)
        if Abs(d) > Abs(z) then z := d;
        z := Max0S(z); 
      end;
    end;
end;

procedure SortLights(Lvals: TPLightVals);
var i, j: Integer;
    List: array[0..5] of TSortItem;
    LVtmp: TLightVals;
const stab: array[0..3] of Integer = (0, 2, 1, 3);
begin
    AssignLightVal(@LVtmp, Lvals);
    with Lvals^ do
    begin
      for i := 0 to 5 do
      begin                
        if (iLightPos[i] and 6) > 0 then
          List[i].iZ := Round(sPosLP[i])
        else
          List[i].iZ := 40000 + stab[iLightOption[i] and 3];
        List[i].wX := i;
      end;
      QuickSortInt(6, List);
      for i := 0 to 5 do
      begin
        j :=List[i].wX;
        SortTab[j] := i;
        iLightOption[i] := LVtmp.iLightOption[j];
        iHSenabled[i] := LVtmp.iHSenabled[j];
        iHScalced[i] := LVtmp.iHScalced[j];
        iHSmask[i] := LVtmp.iHSmask[j];
        iLightPos[i] := LVtmp.iLightPos[j];
        iLightAbs[i] := LVtmp.iLightAbs[j];
        iLightPowFunc[i] := LVtmp.iLightPowFunc[j];
        iLightFuncDiff[i] := LVtmp.iLightFuncDiff[j];
        sLmaxL[i] := LVtmp.sLmaxL[j];
        sPosLightZpos[i] := LVtmp.sPosLightZpos[j];
        sPosLightXpos[i] := LVtmp.sPosLightXpos[j];
        sPosLightYpos[i] := LVtmp.sPosLightYpos[j];
        sPosLP[i] := LVtmp.sPosLP[j];
        LLightMaps[i] := LVtmp.LLightMaps[j];
        PLValigned.LN[i] := LVtmp.PLValigned.LN[j];
        PLValigned.sLCols[i] := LVtmp.PLValigned.sLCols[j];
      end;
    end;
end;

procedure CalcPosLightsRelPos(Header: TPMandHeader10; Lvals: TPLightVals);
var i: Integer;
begin
    with Lvals^ do
    begin                                   //lvmidpos mod -> poslights sub lvmidpos?!
      StereoChange(Header, Header.bStereoMode, lvMidPos, @Header.hVGrads);
      for i := 0 to 5 do if (Header.Light.Lights[i].Loption and 4) <> 0 then  //poslight
        PLValigned.LN[SortTab[i]] := DVecToSVec(SubtractVectors(DVecFromLightPos(Header.Light.Lights[i]), @lvMidPos));
    end;
end;

{procedure CalcPosLightsRelPosAni(Header: TPMandHeader10; Lvals: TPLightVals);
var i: Integer;
    ssub: TSVec;
begin
    with Lvals^ do
    begin
      StereoChange(Header, Header.bStereoMode, lvMidPos, @Header.hVGrads);
      ssub := DVecToSVec(SubtractVectors(lvMidPos, @Header.dXmid));
      for i := 0 to 5 do if iLightPos[i] <> 0 then
        AddSVecWeight(@PLValigned.LN[i], @ssub, 1);
    end;
end;    }

function ByteToSsqr(b: Byte): Single;
begin
    Result := Sqr(Integer(b)) * s1d255;
end;

procedure CalcSCstartAndSCmul(Header: TPMandHeader10; var sCStart, sCmul: Single; bIsInside: LongBool);
var dTmp: Double;
begin
    with Header.Light do
    begin
      if bIsInside then
      begin
        dTmp    := Sqr(Sqr(TBoptions and $7F));
        sCStart := dTmp * 0.000158025 + 32768;
        sCmul   := (Sqr(Sqr((TBoptions shr 7) and $7F)) - dTmp) * s05 * 0.00031605;
        if Abs(sCmul) > 1e-10 then sCmul := 1 / sCmul;
      end
      else
      begin
        sCStart := Sqr((TBpos[9] + 30) * 0.01111111111111111) * 32767 - 10900;
        sCmul   := (Sqr((TBpos[10] + 30) * 0.01111111111111111) * 32767 - 10900 - sCStart);
        if (TBoptions and $10000) > 0 then
        begin
          dTmp    := sCStart + sCmul * (Integer(FineColAdj2) - 30) * 0.0166666666666666;
          sCStart := sCStart + sCmul * (Integer(FineColAdj1) - 30) * 0.0166666666666666;
          sCmul   := dTmp - sCStart;
        end;
        if Abs(sCmul) > s0001 then sCmul := 2 / sCmul else
        if sCmul < 0 then sCmul := -2000 else sCmul := 2000;
      end;
    end;
end;

{function BuildViewVecGlovalLight(const Light: TLight8): TSVec;
var dTmp, dTmp2: Double;
begin
    dTmp := -D7BtoDouble(Light.LXpos);
    dTmp2 := D7BtoDouble(Light.LYpos);
    BuildViewVectorFOV(dTmp2, dTmp, @Result);
    SVectorChangeSign(@Result);
    if (Light.Loption and 32) <> 0 then //abs angles
    begin
      RotateSVectorReverse(@Result, @M);
      NormaliseSVectorVar(Result);
    end;
end; }

procedure MakeLightValsFromHeaderLight(Header: TPMandHeader10; Lvals: TPLightVals; ImScale: Double; StereoMode: Integer);
var sTmp, sLightScale: Single;
    dTmp, dTmp2: Double;
    i, j: Integer;
    M: TMatrix3;
    MS, MStmp: TSMatrix3;
    HLight: TPLightingParas9;
    Zcorr, ZcMul, ZZstmitDif: Double;
const SpecF: array[0..7] of Single = (1, 1.4142, 2, 2.8284, 4, 5.6568, 8, 11.313);  //= Power(2, index * 0.5)
begin
    with Lvals^ do
    begin
      HLight := @Header.Light;
      CalcStepWidth(Header);
      StereoChange(Header, StereoMode, lvMidPos, @Header.hVgrads);
      sAbsorpCoeff := Header.sTransmissionAbsorption;
      SRLightAmount := Min0MaxCS(Header.SRamount, 100);
      bScaleAmbDiffDown := False;
      bNoColIpol := (HLight.Lights[3].FreeByte and 1) <> 0;
      bCalcPixColSqr := (HLight.AdditionalOptions and 1) <> 0;
      iExModes := HLight.Lights[2].FreeByte;
      bAddBGlight := (HLight.AdditionalOptions and 8) <> 0;
      bDFogOptions := HLight.Lights[0].FreeByte and 3;
      if bDFogOptions = 3 then bDFogOptions := 1;
      bUseSmallBGpicForAmb := (HLight.AdditionalOptions and 32) <> 0;
  //    iBGpicAndDivOptions := ((HLight.AdditionalOptions and 8) shr 3) or ((HLight.Lights[0].FreeByte and 1) shl 1) or
    //                 (HLight.AdditionalOptions and 32);
      M := NormaliseMatrixTo(1, @Header.hVGrads);
      MS := NormaliseMatrixToS(1, @Header.hVGrads);
      if bCalcPixColSqr then sLightScale := 1.5 else sLightScale := 1;
      if bCalcPixColSqr then lvCalcPixelColor := CalcPixelColorSqr
                        else lvCalcPixelColor := CalcPixelColor2;
      PLValigned  := TPLValigned((Integer(@LColSbuf[0]) + 15) and $FFFFFFF0);
      bColCycling := (HLight.TBoptions and $4000) <> 0;
      DiffColLightMap := @LightAdjustForm.DiffColMap;
      DCLMapRotSin := 0;
      DCLMapRotCos := 1;
      DCLMapOffX := 0;
      DCLMapOffY := 0;
      BuildRotMatrixS(0, 0, 0, @DiffColLightMap.PicRotMatrix);
      iColOnOT := (HLight.TBoptions shr 17) and 1;
      if GetDiffMapNr(HLight) <> 0 then
      begin
        DCLMapOffX := (((HLight.TBpos[7] shr 12) and $FF) + 256) * d1d256;  //TBpos[7] = spec amount + additional values in byte!
        DCLMapOffY := (((HLight.TBpos[7] shr 20) and $FF) + 256) * d1d256;
        iColOnOT := iColOnOT or (((HLight.Lights[1].FreeByte and 3) + 1) shl 1);
        if iColOnOT > 3 then
        begin
          lvMapScale := Power(1.2, HLight.Lights[2].AdditionalByteEx - 30);  //..scale for wraparound
          BuildRotMatrixS(Pi - ((HLight.TBpos[7] shr 12) and $FF) * Pi * 0.0078125,
                          ((HLight.TBpos[7] shr 20) and $FF) * Pi * 0.0078125,
                          ((HLight.TBpos[8] shr 20) and $FF) * Pi * 0.0078125,
                          @DiffColLightMap.PicRotMatrix);
          MStmp := MS;
          Multiply2SMatrix(@MStmp, @DiffColLightMap.PicRotMatrix);
          DiffColLightMap.PicRotMatrix := MStmp;
        end else begin //its+trap
          //2Drotmatrix to rotate diffmap
          dTmp := (((HLight.TBpos[8] shr 20) and $FF) - 128) * PiM2 * d1d256;
          DCLMapRotSin := Sin(dTmp);
          DCLMapRotCos := Cos(dTmp);
          lvMapScale := Power(1.05, HLight.Lights[2].AdditionalByteEx - 30);  //..scale for its+otrap
        end;
        if not LoadLightMapNr(GetDiffMapNr(HLight), DiffColLightMap) then
          iColOnOT := iColOnOT and 1; //and?
      end;
      bFarFog := (HLight.TBoptions and $40000) <> 0;
      i := (HLight.TBoptions shr 23) and $3F;
      if i = 32 then iGammaH := 0 else if i < 32 then iGammaH := -1 else iGammaH := 1;
      case iGammaH of
       -1: sGamma := 1 - i / 32;
        0: sGamma := 0;
        1: sGamma := (i - 32) / 31;
      end;
      bYCcomb := (HLight.AdditionalOptions and 4) <> 0;
      bAmbRelObj := (HLight.TBoptions and $20000000) <> 0;
      iDfunc := HLight.TBoptions shr 30;
      bDirectImageCoord := (Cardinal(HLight.TBoptions) and $8000) <> 0;
      sDepth := HLight.TBpos[4] * 0.8e-6;
      sDiffuseShadowing := HLight.Lights[3].AdditionalByteEx * d1d256;
      bVolLight := (Header.bVolLightNr and 7) <> 0;
      sTmp := 128;
      if bVolLight then
      begin
        sDynFogMul := 0.0005;  //for 2nd dfog color
        dTmp := 50;
        sShadGr := (HLight.TBpos[6] - 53) * 0.00002;
      end
      else
      begin
        sShadGr := (HLight.TBpos[6] - 53) * ImScale * Header.mZstepDiv * 0.00065;
        dTmp := 2.2 / Header.mZstepDiv;
        sDynFogMul := Header.mZstepDiv * 0.015;
        if Header.bDFogIt > 0 then
        begin
          dTmp := dTmp * 0.25;
          sShadGr := sShadGr * 4;
          sDynFogMul := sDynFogMul * 4;
        end
        else sTmp := 137;
      end;
      sShad := (sTmp - Sqrt(HLight.TBpos[3] and $FFFF) * 11.313708) * dTmp * 0.28;   //fog offset 0, 159  TBpos3: 128 = 0
      sShadZmul := dTmp * 0.7 / (Header.dZend - Header.dZstart) * (128 - Sqrt(HLight.TBpos[3] shr 16) * 11.313708);
      sAmbShad  := (HLight.TBpos[11] and $FF) / 53;
      CalcSCstartAndSCmul(Header, sCStart, sCmul, False);
      CalcSCstartAndSCmul(Header, sCiStart, sCimul, True);
      if (Header.bCalc1HSsoft and 1) <> 0 then
        Header.bHScalculated := Header.bHScalculated and Header.bCalculateHardShadow; //new
      for i := 0 to 5 do
      begin              // 8
        iLightPowFunc[i] := 2 shl (HLight.Lights[i].LFunction and 7);
        iLightFuncDiff[i] := (HLight.Lights[i].LFunction shr 4) and 3;
        iLightOption[i] := HLight.Lights[i].Loption and 3;
        if iLightOption[i] = 3 then iLightOption[i] := 1;   //0: On  1: Off ..2: lightmap
        if (iLightOption[i] = 2) and (HLight.Lights[i].LightMapNr = 0) then iLightOption[i] := 1;
        iLightPos[i] := ((HLight.Lights[i].Loption shr 2) and 7) or
                        ((HLight.Lights[i].LFunction and 128) shr 4);  // bit1: posLight  bit2..4: visLsource func (0:0,4:1,6:2:,2:3,8:4)
        if iLightOption[i] > 0 then iLightPos[i] := 0;
        iLightAbs[i] := (HLight.Lights[i].Loption shr 5) and 1;       // Lights[i].Loption or $20
        if bCalcPixColSqr then PLValigned.sLCols[i] := RGBColToSVecNoScaleSQR(HLight.Lights[i].Lcolor)
                          else PLValigned.sLCols[i] := RGBColToSVecNoScale(HLight.Lights[i].Lcolor);
        sTmp := ShortFloatToSingle(@HLight.Lights[i].Lamp);
        ScaleSVectorV(@PLValigned.sLCols[i], sLightScale);
        iHSenabled[i] := 1 - ((HLight.Lights[i].Loption shr 6) and 1);
        iHScalced[i] := iHSenabled[i] and (Header.bHScalculated shr (i + 2));// and 1;
        iHSmask[i] := $400 shl i;
        if ((Header.bCalc1HSsoft and 1) <> 0) and (iHScalced[i] <> 0) then iHSmask[i] := -1;
        LLightMaps[i] := @LightAdjustForm.LightMaps[i];
        if iLightOption[i] = 2 then
        begin             //lightmap
          if not LoadLightMapNr(HLight.Lights[i].LightMapNr, LLightMaps[i]) then
            iLightOption[i] := 1;
          BuildRotMatrixS(Pi - HLight.Lights[i].LXpos[0] * Pi * 0.0078125,
                          HLight.Lights[i].LYpos[0] * Pi * 0.0078125,
                          HLight.Lights[i].LZpos[0] * Pi * 0.0078125,
                          @LLightMaps[i].PicRotMatrix);
          if iLightAbs[i] > 0 then  // rel to object
          begin
            MStmp := MS;
            Multiply2SMatrix(@MStmp, @LLightMaps[i].PicRotMatrix);
            LLightMaps[i].PicRotMatrix := MStmp;
          end;
          LLightMaps[i].sIntensity := sTmp;
        end
        else if (iLightPos[i] and 1) <> 0 then  //posLight
        begin
          ScaleSVectorV(@PLValigned.sLCols[i], sTmp * 1.3 * sLightScale); //test factor 1.x
          PLValigned.LN[i] := DVecToSVec(SubtractVectors(DVecFromLightPos(HLight.Lights[i]), @lvMidPos));
          sLmaxL[i] := 800 * (HSumSVec(PLValigned.sLCols[i]) + 128 * sTmp);
        end
        else          //global light
        begin
          dTmp := -D7BtoDouble(HLight.Lights[i].LXpos);
          dTmp2 := D7BtoDouble(HLight.Lights[i].LYpos);
          BuildViewVectorFOV(dTmp2, dTmp, @PLValigned.LN[i]); //rel to viewer = Zvec =  -sinY, sinX, cosX*cosY
          SVectorChangeSign(@PLValigned.LN[i]);
          if iLightAbs[i] > 0 then  // rel to object
          begin
            RotateSVectorReverse(@PLValigned.LN[i], @M);
            NormaliseSVectorVar(PLValigned.LN[i]);
          end;
          sLmaxL[i] := 800 * (HSumSVec(PLValigned.sLCols[i]) + 128) * sTmp; //max SqrDistance, where light / sqr distance < 0.2
          ScaleSVectorV(@PLValigned.sLCols[i], sTmp);
        end;
        if (iLightPos[i] and 14) = 8 then sLmaxL[i] := sLmaxL[i] * 5;
        if (iLightPos[i] and 14) <> 0 then  //visible, calc Zpos  (+x,y positions for lightrays)
        try
          CalcXYZposForLight(Header, PLValigned.LN[i], sPosLightXpos[i],
                 sPosLightYpos[i], sPosLightZpos[i], (iLightPos[i] and 1) <> 0);
          if (iLightPos[i] and 1) = 0 then //background light
          begin
            sPosLP[i] := 0;
            sPosLightZpos[i] := Header.dZend - Header.dZstart;
          end
          else
          begin
            CalcPPZvals(Header^, Zcorr, ZcMul, ZZstmitDif);
            sPosLP[i] := 8388352 - ZcMul * (Sqrt(sPosLightZpos[i] / Header.dStepWidth * Zcorr + 1) - 1);
            sPosLP[i] := Min0MaxCS(sPosLP[i] * d1d256, 32767);
          end;
        except
        end;
      end;
      SortLights(Lvals); //sort lights from back to front
      PLValigned.sDynFogCol[3] := 0;
      sTmp := (HLight.TBpos[8] and $FFF) / 90;    //TB8: 0..270 freq90  ambient color multiplier
      if bCalcPixColSqr then
      begin
        PLValigned.sDynFogCol[0] := ByteToSsqr(HLight.DynFogR);
        PLValigned.sDynFogCol[1] := ByteToSsqr(HLight.DynFogG);
        PLValigned.sDynFogCol[2] := ByteToSsqr(HLight.DynFogB);
        PLValigned.sDynFogCol2 := RGBColToSVecNoScaleSQR(HLight.DynFogCol2);
        PLValigned.sDepthCol := RGBColToSVecNoScaleSQR(HLight.DepthCol);
        PLValigned.sDepthCol2 := RGBColToSVecNoScaleSQR(HLight.DepthCol2);
        sTmp := (Sqr(sTmp) + sTmp) * s05 * sLightScale;
        PLValigned.sAmbCol := ScaleSVector(RGBColToSVecNoScaleSQR(HLight.AmbCol), sTmp);
        PLValigned.sAmbCol2 := ScaleSVector(RGBColToSVecNoScaleSQR(HLight.AmbCol2), sTmp);
      end else begin
        PLValigned.sDynFogCol[0] := HLight.DynFogR;
        PLValigned.sDynFogCol[1] := HLight.DynFogG;
        PLValigned.sDynFogCol[2] := HLight.DynFogB;
        PLValigned.sDynFogCol2 := RGBColToSVecNoScale(HLight.DynFogCol2);
        PLValigned.sDepthCol := RGBColToSVecNoScale(HLight.DepthCol);
        PLValigned.sDepthCol2 := RGBColToSVecNoScale(HLight.DepthCol2);
        PLValigned.sAmbCol := ScaleSVector(RGBColToSVecNoScale(HLight.AmbCol), sTmp);
        PLValigned.sAmbCol2 := ScaleSVector(RGBColToSVecNoScale(HLight.AmbCol2), sTmp);
      end;
      sColZmul := HLight.VarColZpos * -0.005 / (Header.dStepWidth * Header.Width);
      sDiff := HLight.TBpos[5] * 0.02;                  //TB5: 0..250 freq50  diffuse color multiplier
      sSpec := MaxCS(0.004, (HLight.TBpos[7] and $FFF) * 0.02);    //TB7: 0..350 freq50  specular color multiplier ..should depend on object? 3bit expo, 5bit transp as 4th byte in obj-color
      if bCalcPixColSqr then sSpec := (Sqr(sSpec) + sSpec) * s05;
      for i := 0 to 9 do
      begin
        PLValigned.ColDif[i] := ColToSVec(HLight.LCols[i].ColorDif, bCalcPixColSqr);
        PLValigned.ColSpe[i] := ColAToSVec(HLight.LCols[i].ColorSpe, bCalcPixColSqr);//ScaleSVector(ColToSVec(HLight.LCols[i].ColorSpe, bCalcPixColSqr), sSpec);  //dont scale in MC sim
        ColPos[i] := HLight.LCols[i].Position;
      end;
      for i := 0 to 9 do
      begin
        if i < 9 then j := ColPos[i + 1] - ColPos[i] else j := 32767 - ColPos[9];
        if j > 1 then sCDiv[i] := 1 / j else sCDiv[i] := 1;
      end;
      for i := 0 to 3 do
      begin
        PLValigned.ColInt[i] := ColAToSVec(HLight.ICols[i].Color, bCalcPixColSqr);
        IColPos[i] := HLight.ICols[i].Position;
      end;
      for i := 0 to 3 do
      begin
        if i < 3 then j := IColPos[i + 1] - IColPos[i] else j := 32767 - IColPos[3];
        if j > 1 then sICDiv[i] := 1 / j else sICDiv[i] := 1;
      end;
      bBackBMP := HLight.BGbmp[0] <> 0;
      BGLightMap := @M3DBackGroundPic;   //todo: pointers to lightvals own pics
      BGsmallLM := @M3DSmallBGpic;
      if bBackBMP then
      with M3DBackGroundPic do
      begin
        if LMWidth > 0 then
        begin
          BuildRotMatrixS(Pi - HLight.PicOffsetX * Pi * 0.0078125,
                          HLight.PicOffsetY * Pi * 0.0078125,
                          HLight.PicOffsetZ * Pi * 0.0078125, @BGLightMap.PicRotMatrix);
          BGsmallLM.PicRotMatrix := BGLightMap.PicRotMatrix;
          BGLightMap.sIntensity := Power(1.04, HLight.Lights[4].AdditionalByteEx - 40);
          BGsmallLM.sIntensity := BGLightMap.sIntensity;
       //   ScaleSMatrix(-1, @BGsmallLM.PicRotMatrix);
        end
        else bBackBMP := False;
      end;
      sIndLightReflect := Sqr((ShortInt((HLight.TBpos[11] shr 8) and $FF) + 53) * 0.022);
      if bCalcPixColSqr then
      begin
        sIndLightReflect := s05 * sIndLightReflect;
        sDiff := (Sqr(sDiff) + sDiff) * s05;
      end;
      sZZstmitDif := Header.dZstart - Header.dZmid;
      sRoughnessFactor := HLight.RoughnessFactor * Sqr(s1d255);
      sStepWidth := Header.dStepWidth;
    end;
end;

procedure InterpolateColors(Lvals: TPLightValsNavi; PSVAdif, PSVAspec, PSVAinside: TPSVecArray; HLight: TPLightingParas9);  //spec+diff 0..9 to 0..2
var colA, colB: array[0..255] of TSVec;
    i, i2, il1, il2, ip1, ip2: Integer;
    s1: Single;
    DVec: TVec3D;
begin
    with Lvals^ do
    begin
      il2 := 1;
      i2 := 1; //current col pos
      il1 := 0;
      ip1 := 0;//HLight.LCols[0].Position;
      ip2 := HLight.LCols[1].Position;
      for i := 0 to 255 do
      begin
        if (i2 < 10) and ((i shl 7) >= HLight.LCols[i2].Position) then
        begin
          Inc(i2);
          ip1 := ip2;
          if i2 = 10 then ip2 := 32768 else ip2 := HLight.LCols[i2].Position;
          il1 := il2;
          il2 := il2 + 1;
          if il2 > 9 then il2 := 0;
        end;
        s1 := Clamp01S((i shl 7 - ip1) / Max(1, (ip2 - ip1)));
        colA[i] := InterpolateColorToSVec(HLight.LCols[il1].ColorDif, HLight.LCols[il2].ColorDif, s1);
        colB[i] := InterpolateColorToSVec(HLight.LCols[il1].ColorSpe, HLight.LCols[il2].ColorSpe, s1);
      end;
      PSVAdif^[0] := colA[0];
      PSVAspec^[0] := colB[0];
      for i := 1 to 3 do  //interpolate 10 colors to 4 for navi
      begin
        ClearDVec(DVec);
        ip1 := i * 64 - 16;
        for i2 := 0 to 32 do AddSVec2Vec3d(colA[(ip1 + i2) and $FF], @DVec);
        PSVAdif^[i] := DVecToSVec(ScaleVector(DVec, 1 / 33));
        ClearDVec(DVec);
        for i2 := 0 to 32 do AddSVec2Vec3d(colB[(ip1 + i2) and $FF], @DVec);
        PSVAspec^[i] := DVecToSVec(ScaleVector(DVec, 1 / 33));
      end;
      il1 := 0;
      ip1 := 0;
      il2 := 1;
      i2 := 1;
      ip2 := HLight.ICols[1].Position;
      for i := 0 to 255 do
      begin
        if (i2 < 4) and ((i shl 7) >= HLight.ICols[i2].Position) then
        begin
          Inc(i2);
          ip1 := ip2;
          if i2 = 4 then ip2 := 32768 else ip2 := HLight.ICols[i2].Position;
          il1 := il2;
          il2 := (il2 + 1) and 3;
        end;
        s1 := Clamp01S((i shl 7 - ip1) / Max(1, (ip2 - ip1)));
        colB[i] := InterpolateColorToSVec(HLight.ICols[il1].Color, HLight.ICols[il2].Color, s1);
      end;
      PSVAinside^[0] := colB[0];
      for i := 1 to 3 do //PSVAinside^[i] := ColToSVecNoScale(HLight.ICols[i].Color);
      begin
        ClearDVec(DVec);
        ip1 := i * 64 - 16;
        if bColCycling then
          for i2 := 0 to 32 do AddSVec2Vec3d(colB[Min(255, ip1 + i2)], @DVec)
        else
          for i2 := 0 to 32 do AddSVec2Vec3d(colB[(ip1 + i2) and $FF], @DVec);
        PSVAinside^[i] := DVecToSVec(ScaleVector(DVec, 1 / 33));
      end; 
    end;
end;

procedure MakeLightValsFromHeaderLightNavi(Header: TPMandHeader10; Lvals: TPLightValsNavi; ImScale: Double);
var dTmp: Double;
    sTmp, sTmp2: Single;
    i, i2: Integer;
    HLight: TPLightingParas9;
const SpecF: array[0..7] of Single = (1, 1.4142, 2, 2.8284, 4, 5.6568, 8, 11.313);  //= Power(2, index * 0.5)
begin
    with Lvals^ do
    begin
      HLight := @Header.Light;
      CalcStepWidth(Header);
      PLValignedNavi := TPLValignedNavi((Integer(@LColSbuf[0]) + 15) and $FFFFFFF0);
      bColCycling := (HLight.TBoptions and $4000) <> 0;
      bFarFog  := (HLight.TBoptions and $40000) <> 0;
      bGamma2  := (HLight.TBoptions and $80000) <> 0;
      bBlendDFog := HLight.Lights[0].FreeByte <> 0;
      sDepth   := HLight.TBpos[4] * 0.8e-6;
      sShadGr  := (HLight.TBpos[6] - 53) * Header.mZstepDiv * 0.00065 * ImScale;
      if Header.bDFogIt > 0 then sTmp := 128 else sTmp := 137;
      sShad    := (sTmp - Sqrt(HLight.TBpos[3] and $FFFF) * 11.313708) * 2.2 / Header.mZstepDiv * 0.28;
      sAmbShad := HLight.TBpos[11] * 8e-7;
      sDiffuse := HLight.TBpos[5] * 0.016666666666667;     // 1/60
      sCStart  := Sqr((HLight.TBpos[9] + 30) * 0.0111111111111111111) * 32767 - 10900;
      sCmul    := Sqr((HLight.TBpos[10] + 30) * 0.0111111111111111111) * 32767 - 10900 - sCStart;
      if (HLight.TBoptions and $10000) > 0 then
      begin
        dTmp    := sCStart + sCmul * (Integer(HLight.FineColAdj2) - 30) * 0.016666666666666666;
        sCStart := sCStart + sCmul * (Integer(HLight.FineColAdj1) - 30) * 0.0166666666666666;   
        sCmul   := dTmp - sCStart;
      end;                            
      if Abs(sCmul) > s001 then sCmul := 1 / sCmul else sCmul := 100 * Sign(sCmul);
      dTmp     := Sqr(Sqr(HLight.TBoptions and $7F));
      sCiStart := dTmp * 0.000158025 + 32768;
      sCimul   := (Sqr(Sqr((HLight.TBoptions shr 7) and $7F)) - dTmp) * 0.25 * 0.00031605;  //0..3 color
      if Abs(sCimul) > 1e-10 then sCimul := 1 / sCimul;
      sCmul := sCmul * 4; //coloring 0..3 instead of 0..9
      i2 := 0;  //navi lights, max 3
      for i := 0 to 5 do if (HLight.Lights[i].Loption and 1) = 0 then  //light on
      if (HLight.Lights[i].Loption and 2) = 0 then   //no lightmaps
      begin
        if (HLight.Lights[i].Loption and 4) > 0 then //posLights
        begin
          iXangle[i2] := 500;
          if (i2 and 1) = 0 then iYangle[i2] := 4000 else iYangle[i2] := -1000;
        end else begin
          iXangle[i2] := Round(D7BtoDouble(HLight.Lights[i].LXpos) * M16384dPi);
          iYangle[i2] := Round(D7BtoDouble(HLight.Lights[i].LYpos) * M16384dPi);
        end;
        sLightFuncSpec[i2] := SpecF[HLight.Lights[i].LFunction and $07];
        iLightFuncDiff[i2] := (HLight.Lights[i].LFunction shr 4) and 3;
        bLightOption[i2]   := 0;                // Loption:   Byte = bit1: 0: On  1: Off;  bit3 (+4) = bPosLight
        sTmp := ShortFloatToSingle(@HLight.Lights[i].Lamp);
        PLValignedNavi.sLCols[i2] := RGBtoSVecScale(HLight.Lights[i].Lcolor, sTmp);
        Inc(i2);
        if i2 = 3 then Break; //max 3 lights in navi
      end;
      for i := i2 to 2 do bLightOption[i] := 1;
      PLValignedNavi.sDepthCol := RGBColToSVecNoScale(HLight.DepthCol);
      PLValignedNavi.sDepthCol2 := RGBColToSVecNoScale(HLight.DepthCol2);
      PLValignedNavi.sDynFogCol[0] := HLight.DynFogR;
      PLValignedNavi.sDynFogCol[1] := HLight.DynFogG;
      PLValignedNavi.sDynFogCol[2] := HLight.DynFogB;
      PLValignedNavi.sDynFogCol := Add2SVecsWeight2(RGBtoSVecScale(HLight.DynFogCol2, 0.5), PLValignedNavi.sDynFogCol, 0.5);
      sTmp2 := FNavigator.NaviLightness;
      sTmp := (HLight.TBpos[8] and $FFF) * 6 * sTmp2;  //sAmbient
      PLValignedNavi.sAmbCol := ScaleSVector(ColToSVec(InterpolateRGBColor(HLight.AmbCol, HLight.AmbCol2, 0.5, 0.5), False), sTmp);
      sColZmul := HLight.VarColZpos * -0.02 / (Header.dStepWidth * Header.Width);
      sTmp := (HLight.TBpos[7] and $FFF) * 0.016666666666667 * sTmp2; //Spec
      InterpolateColors(Lvals, @PLValignedNavi.ColDif, @PLValignedNavi.ColSpe, @PLValignedNavi.ColInt, HLight);
      for i := 0 to 3 do
      begin
        PLValignedNavi.ColDif[i] := ScaleSVector(PLValignedNavi.ColDif[i], sTmp2 * s1d255);
        PLValignedNavi.ColSpe[i] := ScaleSVector(PLValignedNavi.ColSpe[i], sTmp * s1d255);
        PLValignedNavi.ColInt[i] := ScaleSVector(PLValignedNavi.ColInt[i], sTmp2 * s1d255);
      end;
      if HLight.BGbmp[0] <> 0 then
      begin
        iBackBMP := 1;
        if (Cardinal(HLight.TBoptions) and $8000) <> 0 then iBackBMP := iBackBMP or 2;
      end
      else iBackBMP := 0;
      BGLightMap := @M3DBackGroundPic;
      pBGRotMatrix := @FNavigator.BGpicRotMatrix;
      if iBackBMP <> 0 then
      with M3DBackGroundPic do
      begin
        if LMWidth > 0 then
        begin
          BuildRotMatrixS(Pi - HLight.PicOffsetX * Pi * 0.0078125,
                          HLight.PicOffsetY * Pi * 0.0078125,
                          HLight.PicOffsetZ * Pi * 0.0078125, pBGRotMatrix);
        //  BGLightMap.sIntensity := Power(1.04, HLight.Lights[4].AdditionalByteEx - 40);
        end
        else iBackBMP := 0;
      end;
    end;
end;

{procedure MakeLightVals(H1, H2: TMandHeader10; var L1, L2: TLightVals);
begin
    MakeLightValsFromHeaderLight(@H1, @L1, 1, H1.bStereoMode);
    MakeLightValsFromHeaderLight(@H2, @L2, 1, H2.bStereoMode);
end;   }

end.
