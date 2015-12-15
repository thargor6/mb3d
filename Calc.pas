unit Calc;

interface

uses Windows, TypeDefinitions, Math3D, FormulaClass;

function CalcMandT(Header: TPMandHeader11; PLightVals: TPLightVals; PCTS: TPCalcThreadStats;
                   PsiLight5: TPsiLight5; hSLoffset, FSIstart, FSIoffset: Integer; hRect: TRect): Boolean;
function CalcDEfull(It3Dex: TPIteration3Dext; mctp: Pointer{PMCTparameter}): Double;
function CalcDEanalytic(It3Dex: TPIteration3Dext; mctp: Pointer{PMCTparameter}): Double;
//function CalcDE4point(It3Dex: TPIteration3Dext; mctp: Pointer): Double;
procedure CalcHS(PMCT: PMCTparameter; hsPsiLight: TPsiLight5; y: Integer);
procedure IniIt3D(PMCT: PMCTparameter; It3Dex: TPIteration3Dext);
//procedure RegulationUpdate(const ActDE, LastDE, LastStep: Double; var DEmul: Single);
procedure CalcZposAndRough(siLight: TPsiLight5; mct: PMCTparameter; const ZZ: Double);
procedure DelayCalcPart(ThreadCount: Integer; PCTS: TPCalcThreadStats);
//procedure FreeCalcMaps;
procedure IniCalcMaps({MCTparas: PMCTparameter;} Header: TPMandHeader11);
procedure CopyFormulas(const OldFormulas: array of TCustomFormula;
                    MCTparas: PMCTparameter; var CFormulas: array of TFormulaClass);
procedure RayMarch(RMrec: TPRaymarchRec);
function SplineIpolMap(x, y: Double; PCalcMap: TPLightMap): TVec3D;
procedure RMdoBinSearch(pMCTparas: PMCTparameter; var DE, RLastStepWidth{, LastDE}: Double);
procedure RMCalculateVgradsFOV(pMCTparas: PMCTparameter; ix: Integer);
procedure RMmaxLengthToCutPlane(pMCTparas: PMCTparameter; var dLength: Double; var itmp: Integer; vPos: TPPos3D);
procedure RMdoColorOnIt(pMCTparas: PMCTparameter);
procedure RMdoColor(pMCTparas: PMCTparameter);
procedure RMcalcNanglesForCut(pMCTparas: PMCTparameter; CutPlane: Integer);
procedure RMdoBinSearchIt(pMCTparas: PMCTparameter; var ZZ: Double);
procedure RMdoSecantSearch(pMCTparas: PMCTparameter; var DE, RLastStepWidth, RLastDE: Double);
procedure RMCalculateNormals(pMCTparas: PMCTparameter; var NN: Single);
procedure RMCalculateNormalsOnSmoothIt(pMCTparas: PMCTparameter; var NN: Single);
procedure RMCalculateStartPos(pMCTparas: PMCTparameter; ix, iy: Integer);
procedure RMCalcRoughness(N: TPVec3D; var sRough: Single; dt2, dsG: PDouble);
function CalcDEnoADE(It3Dex: TPIteration3Dext; mctp: Pointer): Double;
function RMcalcVLight(StepCount: Single): Integer;
//function CalcDEfullNoCol(It3Dex: TPIteration3Dext; mctp: Pointer): Double;

var CalcMaps: array[0..2] of TLightMap; //max 3 lightmaps?   todo: Global Map Handler with depencies + exclusive free+load
    MapIsMissing: LongBool;
  //  CalcDE: TCaldDEfunction = CalcDEfull;

implementation

uses Mand, LightAdjust, CalcThread, CalcThread2D, HeaderTrafos, Math, Maps,
     Navigator, SysUtils, Types, DivUtils, Forms, ImageProcess, FileHandling,
     MapSequences;

//{$CODEALIGN 8}

{procedure FreeCalcMaps;
begin
    if Mand3DForm.Button2.Caption <> 'Stop' then
    begin
      FreeLightMap(CalcMaps[0]);
      FreeLightMap(CalcMaps[1]);
      FreeLightMap(CalcMaps[2]);
    end;
end;   }

function RMcalcVLight(StepCount: Single): Integer;
asm
    push ecx
    fld  dword [ebp + 8]
    fistp dword [esp]
    mov  eax, [esp]
    cmp  eax, 16383
    jle  @1
    mov  eax, 16383
@1: bsr  ecx, eax
    jz   @2
    sub  ecx, 6
    jle  @2
    shr  eax, cl
    shl  ecx, 7
    or   eax, ecx
@2: pop  ecx
end;
{var i, i2: Integer;   //ebp+8
begin
    if StepCount > 16383 then i := 16383 else i := Round(StepCount);
    i2 := 0;
    while i > 127 do
    begin
      i := i shr 1;
      Inc(i2);
    end;
    Result := i or (i2 shl 7);
end;  }

procedure IniCalcMaps(Header: TPMandHeader11); //todo: scan Formulas for 'MAP' + integer and get value from varpointer
var i, i2, j, n, c, Mcount: Integer;
    bIsIpol: LongBool;
    MA: array[0..2] of Integer;
begin
    Mcount := 0;
    bIsIpol := (PTHeaderCustomAddon(Header.PCFAddon).bOptions1 and 3) = 1;
    if bIsIpol then i2 := 2 else i2 := MAX_FORMULA_COUNT - 1;
    for i := 0 to i2 do if bIsIpol or (PTHeaderCustomAddon(Header.PCFAddon).Formulas[i].iItCount <> 0) then
      for j := 0 to Min(16, PTHeaderCustomAddon(Header.PCFAddon).Formulas[i].iOptionCount) - 1 do
      begin
        if PTCustomFormula(Header.PHCustomF[i]).byOptionTypes[j] = 2 then  //RangeCheck
        if Pos('MAP', UpperCase(PTCustomFormula(Header.PHCustomF[i]).sOptionStrings[j])) > 0 then
        begin
          n := Round(MinMaxCS(0, PTHeaderCustomAddon(Header.PCFAddon).Formulas[i].dOptionValue[j], 33000));
          if (n > 0) and (n < 32001) and (Mcount < 3) then
          begin
            for c := 0 to Mcount - 1 do if MA[c] = n then n := 0;  //already in list
            if n > 0 then begin
              MA[Mcount] := n;
              Inc(Mcount);
            end;  
          end;
        end;
      end;
    for i := 0 to 2 do
    begin
      j := 0;
      c := 0;
      while j < Mcount do // delete already loaded maps from list
      begin
        if (CalcMaps[i].LMnumber = MA[j]) and
          ((TMapSequenceListProvider.GetInstance.GetSequence(MA[j]) = nil) or
          (CalcMaps[i].LMframe = TMapSequenceFrameNumberHolder.GetCurrFrameNumber)) then begin
          Dec(Mcount);
          for n := j to Mcount - 1 do MA[n] := MA[n + 1];
          Inc(c);
        end;
        Inc(j);
      end;
      if c = 0 then FreeLightMap(@CalcMaps[i]);
    end;
    for i := 0 to Mcount - 1 do
    begin
      for j := 0 to 2 do if CalcMaps[j].LMnumber = 0 then
      begin
        LoadLightMapNr(MA[i], @CalcMaps[j]);
        Break;
      end;
    end;
  {  FreeLightMap(CalcMaps[0]); //no, mark maps as notused, afterwards free only ehich are still notused!
    FreeLightMap(CalcMaps[1]);
    FreeLightMap(CalcMaps[2]);   }
end;

procedure CopyFormulas(const OldFormulas: array of TCustomFormula;
                MCTparas: PMCTparameter; var CFormulas: array of TFormulaClass);
var i: Integer;
begin
    for i := 0 to MAX_FORMULA_COUNT - 1 do
    begin
      CFormulas[i] := TFormulaClass.Create;
      CFormulas[i].AssignOld(@OldFormulas[i]);
      MCTparas.fHPVar[i] := CFormulas[i].pConstPointer16;
      MCTparas.fHybrid[i] := ThybridIteration2(CFormulas[i].pCodePointer);
    end;
end;

function CalcMandT(Header: TPMandHeader11; PLightVals: TPLightVals; PCTS: TPCalcThreadStats;
                   PsiLight5: TPsiLight5; hSLoffset, FSIstart, FSIoffset: Integer; hRect: TRect): Boolean;
var x, ThreadCount: Integer;
    MCTparas: TMCTparameter;
    MandCalcThread: array of TMandCalcThread;
    MandCalcThread2D: array of T2DcalcThread;
begin
  ThreadCount := Min(Mand3DForm.UpDown3.Position, Header.Height);
  try
    MCTparas := getMCTparasFromHeader(Header^, True);
    Result   := MCTparas.bMCTisValid;
    if Result then begin
      MCTparas.pSiLight  := PsiLight5;
      MCTparas.SLoffset  := hSLoffset;
      MCTparas.FSIstart  := FSIstart;
      MCTparas.FSIoffset := FSIoffset;
      MCTparas.PLVals    := PLightVals;
      MCTparas.PCalcThreadStats := PCTS;
      MCTparas.CalcRect := hRect;
      if MCTparas.calc3D then SetLength(MandCalcThread, ThreadCount)
                         else SetLength(MandCalcThread2D, ThreadCount);
    end;
   // for x := 0 to 511 do DEreduce1[x] := 1;
   // for x := 0 to 511 do DEreduce2[x] := 1;
      {    for x := 0 to 16383 do begin
            DEColStat[x] := 0;
            DEColStatCount[x] := 0;
          end;
  //          for x := 0 to 255 do RoughStat[x] := 0;  //histo test  }
  except
    Mand3DForm.OutMessage('There was an error, please report bug and send the current parameters!');
    Result := False;
  end;
  if Result then
  begin
    PCTS.ctCalcRect := hRect;
    for x := 1 to ThreadCount do
    begin
      PCTS.CTrecords[x].iActualYpos := -1;
      PCTS.CTrecords[x].iActualXpos := 0;
      PCTS.CTrecords[x].i64DEsteps  := 0;
      PCTS.CTrecords[x].iDEAvrCount := 0;
      PCTS.CTrecords[x].i64Its      := 0;
      PCTS.CTrecords[x].iItAvrCount := 0;
      PCTS.CTrecords[x].MaxIts      := 0;
      MCTparas.iThreadId := x;
      if MCTparas.calc3D then
      begin
        try
          MandCalcThread[x - 1] := TMandCalcThread.Create(True);
          MandCalcThread[x - 1].FreeOnTerminate := True;
          {$ifdef PARAMS_PER_THREAD}
          MCTparas := getMCTparasFromHeader(Header^, True);
          MCTparas.pSiLight  := PsiLight5;
          MCTparas.SLoffset  := hSLoffset;
          MCTparas.FSIstart  := FSIstart;
          MCTparas.FSIoffset := FSIoffset;
          MCTparas.PLVals    := PLightVals;
          MCTparas.PCalcThreadStats := PCTS;
          MCTparas.CalcRect := hRect;
          {$endif PARAMS_PER_THREAD}
          MandCalcThread[x - 1].MCTparas        := MCTparas;
          MandCalcThread[x - 1].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
          PCTS.CTrecords[x].isActive := 1;
          PCTS.CThandles[x] := MandCalcThread[x - 1];
        //  CopyFormulas(calcHybridCustoms, @MandCalcThread[x - 1].MCTparas, MandCalcThread[x - 1].Formulas);
        except
          ThreadCount := x - 1;
          Break;
        end;
      end else begin
        try
          MandCalcThread2D[x - 1] := T2DcalcThread.Create(True);
          MandCalcThread2D[x - 1].FreeOnTerminate := True;
          {$ifdef PARAMS_PER_THREAD}
          MCTparas := getMCTparasFromHeader(Header^, True);
          MCTparas.pSiLight  := PsiLight5;
          MCTparas.SLoffset  := hSLoffset;
          MCTparas.FSIstart  := FSIstart;
          MCTparas.FSIoffset := FSIoffset;
          MCTparas.PLVals    := PLightVals;
          MCTparas.PCalcThreadStats := PCTS;
          MCTparas.CalcRect := hRect;
          {$endif PARAMS_PER_THREAD}
          MandCalcThread2D[x - 1].MCTparas        := MCTparas;
          MandCalcThread2D[x - 1].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
          PCTS.CTrecords[x].isActive := 1;
          PCTS.CThandles[x] := MandCalcThread2D[x - 1];
        except
          ThreadCount := x - 1;
          Break;
        end;
      end;
    end;
    PCTS.HandleType := 1;
    if MCTparas.calc3D then
    begin
      for x := 0 to ThreadCount - 1 do MandCalcThread[x].MCTparas.iThreadCount := ThreadCount;
    end else begin
      for x := 0 to ThreadCount - 1 do MandCalcThread2D[x].MCTparas.iThreadCount := ThreadCount;
    end;
    PCTS.iTotalThreadCount := ThreadCount;
    PCTS.cCalcTime         := GetTickCount;
    Header.bHScalculated   := 0;
    if MCTparas.calc3D then
    begin
      for x := 0 to ThreadCount - 1 do MandCalcThread[x].Start;
    end else
      for x := 0 to ThreadCount - 1 do MandCalcThread2D[x].Start;
  end;
end;

{function CR(de, R: Double): Double;
var rR: Double;
begin
    rR := Min0MaxCD(de/R, 1);
    Result := 2*rR*rR*rR - 3*rR*rR + 1;
end;  }

function CalcDEanalytic(It3Dex: TPIteration3Dext; mctp: Pointer): Double;
begin
    with PMCTparameter(mctp)^ do
    begin
      if It3Dex.DEoption = 20 then //dIFS
      begin
        It3Dex.Rold := msDEstop * sStepWm103;    //for heightmap formulas speedup, absolute DEstop
        It3Dex.RStopD := It3Dex.Rold;            //if already closer then stop iterating...
        It3Dex.bIsInsideRender := bInsideRendering;
      end;
      Result := mMandFunctionDE(@It3Dex.C1) * dDEscale;
      MaxItsResult := It3Dex.MaxIt;
      if It3Dex.DEoption = 20 then Inc(MaxItsResult) else
      if Result < msDEstop * s025 then Result := msDEstop * s025; //MaxCDvar(var ds, ddest: Double);
      DEoptionResult := It3Dex.DEoption;
      if bCalcInside then
      begin
        if DEoptionResult = 20 then //DEoptionResult.. in DEcomb the one who rules the raystep (for faster insides in decomb)
          Result := msDEstop * 2 - Result
        else
        begin
          Result := msDEstop * 4 - Result * 3;
          if Result >= msDEstop then Dec(It3Dex.ItResultI);
        end;
      end;
    end;
end;

{function CalcDEanalytic(It3Dex: TPIteration3Dext; mctp: Pointer): Double;
asm                      //eax                     edx
    push esi                          //ecx can be changed in functions!
    push ebx                          //the whale2 testpars were bad
    lea  esi, eax + 136
    lea  ebx, edx + 180
    cmp  dword [esi + TIteration3Dext.DEoption - 136], 20   //TMCTparameter
    jnz  @1
    fld  dword [ebx + TMCTparameter.msDEstop - 180]
    fmul dword [ebx + TMCTparameter.sStepWm103 - 180]
    fst  qword [esi + TIteration3Dext.Rold - 136]
    fstp qword [esi + TIteration3Dext.RStopD - 136]
    mov  eax, [ebx + TMCTparameter.bInsideRendering - 180]
    mov  [esi + TIteration3Dext.bIsInsideRender - 136], eax
@1: lea  eax, esi + TIteration3Dext.C1 - 136
    call dword [ebx + TMCTparameter.mMandFunctionDE - 180]
    fmul dword [ebx + TMCTparameter.dDEscale - 180]
    mov  eax, [esi + TIteration3Dext.MaxIt - 136]
    mov  [ebx + TMCTparameter.MaxItsResult - 180], eax
    cmp  dword [esi + TIteration3Dext.DEoption - 136], 20
    jnz  @2
    inc  dword [ebx + TMCTparameter.MaxItsResult - 180]
    jmp  @4
@2: fld  dword [ebx + TMCTparameter.msDEstop - 180]
    fmul s025       //msDEstop*0.25, Result
    fcom
    fwait
    fnstsw ax
    shr  ah, 1
    jc   @3
    fxch
@3: fstp st         //result
@4: mov  eax, [esi + TIteration3Dext.DEoption - 136]
    mov  [ebx + TMCTparameter.DEoptionResult - 180], eax
    cmp  dword [ebx + TMCTparameter.bCalcInside - 180], 0
    jz   @5
    fld  dword [ebx + TMCTparameter.msDEstop - 180]
    fadd st, st
    cmp  eax, 20
    jnz  @6
    fsubrp          //result:=msDEstop*2-result
    jmp  @5
@6: fadd st, st
    fxch            //result, msDEstop*4
    fmul s3
    fsubp           //result:=msDEstop*4-result*3
    fcom dword [ebx + TMCTparameter.msDEstop - 180]
    fstsw ax
    sahf
    jb   @5
    dec  dword [esi + TIteration3Dext.ItResultI - 136]
@5: pop  ebx
    pop  esi
end;  }

procedure RestoreF1DEcomb(DEcombRec: TPBufDEcomb; mctp: PMCTparameter);
begin         //   restore first hybrid vals
    with mctp^ do
    begin
      pIt3Dext.MaxIt  := iMaxIt;
      pIt3Dext.DEoption := DEoption;
      PInteger(@pIt3Dext.iRepeatFrom)^ := PInteger(@RepeatFrom1)^;
      pIt3Dext.EndTo  := wEndTo;
      bCalcInside     := bInsideRendering;
      IsCustomDE      := IsCustomDE1;
      dDEscale        := DEcombRec.bufMCTdDEscale;
      mMandFunction   := DEcombRec.bufMCTMandFunction;
      mMandFunctionDE := DEcombRec.bufMCTMandFunctionDE;
    end;
end;

procedure PrepareF1DEcomb(DEcombRec: TPBufDEcomb; mctp: PMCTparameter);
begin             //load second hybrid part
    with mctp^ do
    begin
      PInteger(@pIt3Dext.iRepeatFrom)^ := PInteger(@RepeatFrom2)^;
      pIt3Dext.EndTo := iEnd2;
      DEcombRec.bufMCTMandFunction := mMandFunction;
      DEcombRec.bufMCTMandFunctionDE := mMandFunctionDE;
      mMandFunction := mMandFunction2;
      mMandFunctionDE := mMandFunctionDE2;
      DEcombRec.bufIt3DItResultI := pIt3Dext.ItResultI;
      DEcombRec.bufIt3DOtrap     := pIt3Dext.Otrap;
      DEcombRec.bufIt3DSmoothItD := pIt3Dext.SmoothItD;
      DEcombRec.bufMCTdDEscale   := dDEscale;
      DEcombRec.bufMCTmaxItsResult := MaxItsResult;
      dDEscale       := dDEscale2;
      IsCustomDE     := IsCustomDE2;
      bCalcInside    := False;
      pIt3Dext.MaxIt := iMaxitF2;
      pIt3Dext.DEoption := DEoption2;
    end;
end;

{procedure Prepare3Dgrad(DEcombRec: TPBufDEcomb; It3Dex: TPIteration3Dext);
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

procedure Restore3Dgrad(DEcombRec: TPBufDEcomb; It3Dex: TPIteration3Dext);
begin
    It3Dex.ItResultI := It3Dex.MaxIt; //new, restore ItResult
    It3Dex.Rout      := DEcombRec.bufIt3DOtrap;
    It3Dex.MaxIt     := DEcombRec.bufIt3DItResultI;
    It3Dex.SmoothItD := DEcombRec.bufIt3DSmoothItD;
    It3Dex.CalcSIT   := DEcombRec.bufMCTCalcSIT;
    mCopyVec(@It3Dex.C1, @DEcombRec.bufVec3D);
end;  }
 {
procedure NotVar(var b: LongBool);
asm
  cmp dword [eax], 0
  je @@1
  mov dword [eax], 0
  ret
@@1:
  mov dword [eax], -1
end; }

function CalcDEnoADE(It3Dex: TPIteration3Dext; mctp: Pointer): Double;
var bufMCTCalcSIT, bufMaxIt: Integer;
 //   bufIt3DSmoothItD: Single;
    bufD, bufRout, Rst, wt, dt: Double;
begin
    with PMCTparameter(mctp)^ do
    begin
      mMandFunction(@It3Dex.C1);
      if bInsideRendering and (It3Dex.ItResultI = It3Dex.MaxIt) then Result := 0 else
      begin
        if It3Dex.Rout < d1em200 then Result := 0 else
        begin
      {    Prepare3Dgrad(@DEcombRec, It3Dex);
          mAddVecWeight(@It3Dex.C1, @Vgrads[2], mctDEoffset);
          mMandFunction(@It3Dex.C1);
          dt := Sqr(DEcombRec.bufIt3DOtrap - It3Dex.Rout);
          mCopyAddVecWeight(@It3Dex.C1, @DEcombRec.bufVec3D, @Vgrads[1], mctDEoffset);
          mMandFunction(@It3Dex.C1);
          wt := Sqr(DEcombRec.bufIt3DOtrap - It3Dex.Rout);
          mCopyAddVecWeight(@It3Dex.C1, @DEcombRec.bufVec3D, @Vgrads[0], mctDEoffset);
          mMandFunction(@It3Dex.C1);
          Rst := Sqr(DEcombRec.bufIt3DOtrap - It3Dex.Rout);  }
     //     bufIt3DSmoothItD := It3Dex.SmoothItD;
          bufMCTCalcSIT  := PInteger(@It3Dex.CalcSIT)^;   //bytebool
          bufMaxIt       := It3Dex.MaxIt;
          bufRout        := It3Dex.Rout;
          bufD           := It3Dex.C1;
          It3Dex.CalcSIT := False;
          It3Dex.MaxIt   := It3Dex.ItResultI;
          It3Dex.RStop   := Rstop3D;
          It3Dex.C1 := It3Dex.C1 + mctDEoffset;
          mMandFunction(@It3Dex.C1);
          dt        := Sqr(bufRout - It3Dex.Rout);
          It3Dex.C1 := bufD;
          bufD      := It3Dex.C2;
          It3Dex.C2 := It3Dex.C2 + mctDEoffset;
          mMandFunction(@It3Dex.C1);
          wt        := Sqr(bufRout - It3Dex.Rout);
          It3Dex.C2 := bufD;
          bufD      := It3Dex.C3;
          It3Dex.C3 := It3Dex.C3 + mctDEoffset;
          mMandFunction(@It3Dex.C1);
          Rst       := Sqr(bufRout - It3Dex.Rout);
          It3Dex.C3 := bufD;
       {   v := AddVecF(AddVecF(ScaleVector(TPVec3D(@Vgrads[0])^, Rst),
                               ScaleVector(TPVec3D(@Vgrads[1])^, wt)),
                       ScaleVector(TPVec3D(@Vgrads[2])^, dt));
          dd := DotOfVectorsNormalize(@v, @mVGradsFOV);    }
        {  if Rst > wt then
          begin
            if Rst > dt then dd := DotOfVectorsNormalize(@Vgrads[0], @mVGradsFOV)
                        else dd := DotOfVectorsNormalize(@Vgrads[2], @mVGradsFOV);
          end
          else if wt > dt then
            dd := DotOfVectorsNormalize(@Vgrads[1], @mVGradsFOV)
          else dd := DotOfVectorsNormalize(@Vgrads[2], @mVGradsFOV);
          sZstepDiv2 := sZstepDiv + (1 - sZstepDiv) * (0.5 - Abs(dd) * 0.5);}

          Result := bufRout * Ln(bufRout) * dDEscale / (Sqrt(Rst + wt + dt) + mctDEoffset006);

          It3Dex.Rout := bufRout;
          It3Dex.ItResultI := It3Dex.MaxIt;
          It3Dex.MaxIt := bufMaxIt;
        //  It3Dex.SmoothItD := bufIt3DSmoothItD;
          PInteger(@It3Dex.CalcSIT)^ := bufMCTCalcSIT;
          It3Dex.RStop := dRStop;
    //      mCopyVec(@It3Dex.C1, @DEcombRec.bufVec3D);
        end;
      end;
      MaxItsResult := It3Dex.MaxIt;
      if Result < msDEstop * 0.25 then Result := msDEstop * 0.25;  //MaxCDvar(DS025, Rst);
      DEoptionResult := It3Dex.DEoption;
      if bCalcInside then
      begin
        Result := msDEstop * 4 - Result * 3;
        if (Result >= msDEstop) then Dec(It3Dex.ItResultI);
      end;
    end;
end;

function CalcDEfull(It3Dex: TPIteration3Dext; mctp: Pointer{PMCTparameter}): Double;
var DEcombRec: TBufDEcomb;
    DS025, RD1, Rst, wt, dt: Double;
label go1;
begin
    with PMCTparameter(mctp)^ do
    begin
    DS025 := msDEstop * 0.25;
    if IsCustomDE then
    begin
      if It3Dex.DEoption = 20 then //dIFS
      begin
        It3Dex.Rold := msDEstop * sStepWm103; //for heightmap formulas speedup, absolute DEstop
        It3Dex.bIsInsideRender := bInsideRendering;
        It3Dex.RStopD := msDEstop * sStepWm103;
      end;
      Result := mMandFunctionDE(@It3Dex.C1) * dDEscale;
      wt := Abs(It3Dex.w);
      dt := Abs(It3Dex.Deriv1);
    end
    else
    begin                     //3d gradient
      mMandFunction(@It3Dex.C1);
      if bInsideRendering and (It3Dex.ItResultI = It3Dex.MaxIt) then Result := 0 else
      begin
        if It3Dex.Rout < d1em200 then Result := 0 else
        begin
          DEcombRec.bufMCTCalcSIT := PLongBool(@It3Dex.CalcSIT)^;   //bytebool
          DEcombRec.bufIt3DItResultI := It3Dex.MaxIt;
          DEcombRec.bufIt3DOtrap := It3Dex.Rout;
          DEcombRec.bufVec3D[0] := It3Dex.C1;
          It3Dex.CalcSIT := False;
          It3Dex.MaxIt   := It3Dex.ItResultI;
          It3Dex.RStop   := Rstop3D;
          It3Dex.C1 := It3Dex.C1 + mctDEoffset;
          mMandFunction(@It3Dex.C1);
          dt        := Sqr(DEcombRec.bufIt3DOtrap - It3Dex.Rout);
          It3Dex.C1 := DEcombRec.bufVec3D[0];
          DEcombRec.bufVec3D[0] := It3Dex.C2;
          It3Dex.C2 := It3Dex.C2 + mctDEoffset;
          mMandFunction(@It3Dex.C1);
          wt        := Sqr(DEcombRec.bufIt3DOtrap - It3Dex.Rout);
          It3Dex.C2 := DEcombRec.bufVec3D[0];
          DEcombRec.bufVec3D[0] := It3Dex.C3;
          It3Dex.C3 := It3Dex.C3 + mctDEoffset;
          mMandFunction(@It3Dex.C1);
          Rst       := Sqr(DEcombRec.bufIt3DOtrap - It3Dex.Rout);
          It3Dex.C3 := DEcombRec.bufVec3D[0];
          Result := DEcombRec.bufIt3DOtrap * Ln(DEcombRec.bufIt3DOtrap) * dDEscale /
                    (Sqrt(Rst + wt + dt) + mctDEoffset006);
          It3Dex.Rout := DEcombRec.bufIt3DOtrap;
          It3Dex.ItResultI := It3Dex.MaxIt;
          It3Dex.MaxIt := DEcombRec.bufIt3DItResultI;
          PLongBool(@It3Dex.CalcSIT)^ := DEcombRec.bufMCTCalcSIT;
          It3Dex.RStop := dRStop;
       //   It3Dex.SmoothItD := DEcombRec.bufIt3DSmoothItD;
{          Prepare3Dgrad(@DEcombRec, It3Dex);
     //     try //test
          mAddVecWeight(@It3Dex.C1, @Vgrads[2], mctDEoffset);
          mMandFunction(@It3Dex.C1);
          dt := Sqr(DEcombRec.bufIt3DOtrap - It3Dex.Rout);
          mCopyAddVecWeight(@It3Dex.C1, @DEcombRec.bufVec3D, @Vgrads[1], mctDEoffset);
          mMandFunction(@It3Dex.C1);
          wt := Sqr(DEcombRec.bufIt3DOtrap - It3Dex.Rout);
          mCopyAddVecWeight(@It3Dex.C1, @DEcombRec.bufVec3D, @Vgrads[0], mctDEoffset);
          mMandFunction(@It3Dex.C1);
          Rst := Sqr(DEcombRec.bufIt3DOtrap - It3Dex.Rout);
          Result := DEcombRec.bufIt3DOtrap * Ln(DEcombRec.bufIt3DOtrap) * dDEscale /     //div0  in ln if Rout=0
                    (Sqrt(Rst + wt + dt) + (mctDEoffset * s006));
       //   except end;
          It3Dex.Rout := DEcombRec.bufIt3DOtrap;
          It3Dex.ItResultI := It3Dex.MaxIt;
          It3Dex.MaxIt := DEcombRec.bufIt3DItResultI;
          It3Dex.SmoothItD := DEcombRec.bufIt3DSmoothItD;
          It3Dex.CalcSIT := DEcombRec.bufMCTCalcSIT;
          It3Dex.RStop := dRStop;
          mCopyVec(@It3Dex.C1, @DEcombRec.bufVec3D);   }
        end;
      end;
    end;
    MaxItsResult := iMaxIt;
    if It3Dex.DEoption = 20 then Inc(MaxItsResult) else MaxCDvar(DS025, Result);
    DEoptionResult := It3Dex.DEoption;

    if FormulaType > 0 then  //DEcomb type 1:min 2:max 3:maxInv 4:miS1 5:miS2 6: mix f1 first 7: mix f2-6 first
    begin
      PrepareF1DEcomb(@DEcombRec, mctp); //bCalcInside disabled here, is done at end for whole hybrid (bInsideRendering still set for dIFS)
 //    try//test
      if FormulaType = 3 then bCalcInside := not bCalcInside;//NotVar(bCalcInside);
      if IsCustomDE then Rst := CalcDEanalytic(It3Dex, mctp)
                    else Rst := CalcDEnoADE(It3Dex, mctp);

      case FormulaType of
        1:  if Rst >= Result then goto go1 else Result := Rst; //minDE comb
     2..3:  if Rst > Result then Result := Rst else    //..3: MaxInv: Invert the DE of one formula and combine "max" to cut off parts
            begin
go1:          It3Dex.ItResultI := DEcombRec.bufIt3DItResultI;
              It3Dex.SmoothItD := DEcombRec.bufIt3DSmoothItD;
              It3Dex.Otrap := DEcombRec.bufIt3DOtrap;
              MaxItsResult := DEcombRec.bufMCTmaxItsResult;
              DEoptionResult := DEoption;
            end;
     4..5:  begin
              if Rst >= Result then //< PMCTparameter(mctp).MaxItsResult := PMCTparameter(mctp).iMaxitF2 else
              begin
                It3Dex.ItResultI := DEcombRec.bufIt3DItResultI;
                MaxItsResult := DEcombRec.bufMCTmaxItsResult;
                DEoptionResult := DEoption;
              end;
              if FormulaType = 4 then   //linear
                Result := MinCD(Rst - Clamp0D(sDEcombSmooth - Result),
                                Result - Clamp0D(sDEcombSmooth - Rst))
              else
              begin     //smooth
                RD1 := Clamp0D(sDEcombSmooth - Result - msDEstop);
                dt := Clamp0D(sDEcombSmooth - Rst - msDEstop);
                Result := MinCD(Rst - RD1 * (sDEcombSmooth - dt) / sDEcombSmooth,
                             Result - dt * (sDEcombSmooth - RD1) / sDEcombSmooth);
              end;
              Rst := Abs(Rst);
              wt := Abs(Result);
              dt := 1 / (wt + Rst + s1em10);
              It3Dex.SmoothItD := (It3Dex.SmoothItD * wt + DEcombRec.bufIt3DSmoothItD * Rst) * dt;
              It3Dex.Otrap := (It3Dex.Otrap * wt + DEcombRec.bufIt3DOtrap * Rst) * dt;
            end;
        else
        begin  //6..7  dIFS mix: first common fractal until bailout or maxits, then dIFS for distance..  6: Mix, first f1..fendh1
          case DEmixCol of     //only in calcDEcol function, not on every step (no calcsit etc)!?
            0: begin
                 It3Dex.SmoothItD := It3Dex.SmoothItD + DEcombRec.bufIt3DSmoothItD;
                 It3Dex.Otrap := (It3Dex.Otrap + DEcombRec.bufIt3DOtrap) * 0.5;
               end;
            1: begin
                 It3Dex.SmoothItD := DEcombRec.bufIt3DSmoothItD;
                 It3Dex.Otrap := DEcombRec.bufIt3DOtrap;
               end;
           //2: color of second formula, is already
          end;
          case DEoption of
            5, 6:  Result := Rst / dt; //It3Dex.Deriv1;  
            2,11:  Result := Rst / wt; //It3Dex.w;
            else
            begin
              Result := Rst * Power(Abs(FmixPow), -1 - DEcombRec.bufIt3DItResultI);  // other method with additional value
            end;
          end;
        end;
      end;
   //  finally //test
      RestoreF1DEcomb(@DEcombRec, mctp);
   {   pIt3Dext.MaxIt  := iMaxIt;
      pIt3Dext.DEoption := DEoption;
      PInteger(@pIt3Dext.iRepeatFrom)^ := PInteger(@RepeatFrom1)^;
      pIt3Dext.EndTo  := wEndTo;
      bCalcInside     := bInsideRendering;
      IsCustomDE      := IsCustomDE1;
      dDEscale        := DEcombRec.bufMCTdDEscale;
      mMandFunction   := DEcombRec.bufMCTMandFunction;
      mMandFunctionDE := DEcombRec.bufMCTMandFunctionDE;  }
    // end;
    end;
      if bCalcInside then
      begin
        if DEoptionResult = 20 then Result := msDEstop * 2 - Result else
        begin
          Result := msDEstop * 4 - Result * 3;
          if (Result >= msDEstop) then Dec(It3Dex.ItResultI); //else probs with decomb and rpow3-> no stop...
        end;                     //after bin search this can produce noise because of both sides possible?
      end;
    end;
end;
                                                            //dsG negative?
procedure RMCalcRoughness(N: TPVec3D; var sRough: Single; dt2, dsG: PDouble);
{begin                  //  eax          edx               ecx  [ebp+8]
  //     dT2 := Noffset * 0.5 / (dM * StepSNorm);
    sRough := Clamp01D(Sqrt(d1em100 + dSG^ * 7 * Sqr(dt2^) /    //was: fp overflow  vals about 1e-100 ?
                         (d1em100 + Sqr(N[0]) + Sqr(N[1]) + Sqr(N[2]))) - 0.05);  //}
asm
    cmp  SupportSSE2, 0
    jz   @@1
    movupd xmm0, [eax]
    movsd  xmm1, [eax + 16]
    movsd  xmm2, [ecx]
    mulpd  xmm0, xmm0
    mulsd  xmm1, xmm1
    mulsd  xmm2, xmm2
    addsd  xmm1, xmm0
    mov  eax, [ebp + 8]
    unpckhpd xmm0, xmm0
    mulsd  xmm2, [eax]
    addsd  xmm1, xmm0
    mulsd  xmm2, d7
    addsd  xmm1, d1em40
    addsd  xmm2, d1em40
    xorpd  xmm3, xmm3
    divsd  xmm2, xmm1
    maxsd  xmm2, xmm3
    sqrtsd xmm2, xmm2
    subsd  xmm2, d005
    maxsd  xmm2, xmm3
    minsd  xmm2, d1p0
    cvtsd2ss xmm4, xmm2
    movss  [edx], xmm4
    jmp  @end
@@1:
    fld  qword [eax]
    fmul st, st
    fld  qword [eax + 8]
    fmul st, st
    faddp
    fld  qword [eax + 16]
    fmul st, st
    faddp
    fadd d1em100
    mov  eax, [ebp + 8]
    fld  qword [ecx]
    fmul st, st
    fmul qword [eax]
    fmul s7
    fadd d1em100
    fdivrp
    ftst
    fnstsw ax
    shr  ah, 1
    jnc  @1
    fstp st
    fldz
@1: fsqrt
    fld  s005       //0.05, sR'
    fcom st(1)
    fnstsw ax
    shr  ah, 1
    jc   @up
    fcompp
    xor  eax, eax
    mov  [edx], eax
    jmp  @end
@up:
    fsubp
    fld1
    fcomp st(1)
    fnstsw ax
    and  ah, 41H
    jz   @up2
    fstp st
    fld1
@up2:
    fstp dword [edx]
@end:
end;

procedure RMCalculateNormals(pMCTparas: PMCTparameter; var NN: Single);
var itmp, iy, ix, SmoothN: Integer;
 //   bIR: LongBool;
    Noffset, NN2, NN1, dNN, dT2, dM, dS, dSG, StepSNorm: Double;
    N, Vx, Vy, CT1: TVec3D;
    sd: TLightSD;
begin
    with pMCTparas^ do
    begin
     // bIR := bInsideRendering;
    {  if bInsideRendering then
      begin
      //  bCalcInside := True;
        bInsideRendering := False;  //to calc 4point DE also if ItResult=Maxit, does not help
      //  msDEstop := msDEstop * 2;  //to avoid decreasing ItResultI, does not help
    //  end;   }
 //     if not IsCustomDE then Inc(pIt3Dext.maxIt, 4);   //test
      pIt3Dext.CalcSIT := True;
      Noffset := MinCS(1, DEstop) * (1 + mZZ * mctDEstopFactor) * 0.15;
      mCopyVec(@CT1, @pIt3Dext.C1);
      dNN := CalcDE(pIt3Dext, pMCTparas);
      NN := pIt3Dext.SmoothItD;   //for coloring
      pIt3Dext.CalcSIT := False;
      if iSmNormals = 8 then
      begin
        ClearDVec(N);
        StepSNorm := Noffset * 1.3333;
        for itmp := -2 to 2 do
          for iy := -2 to 2 do
            for ix := -2 to 2 do
            if (itmp or iy or ix) <> 0 then
            begin
              mCopyAddVecWeight(@pIt3Dext.C1, @CT1, @Vgrads[2], itmp * StepSNorm);
              mAddVecWeight(@pIt3Dext.C1, @Vgrads[1], iy * StepSNorm);
              mAddVecWeight(@pIt3Dext.C1, @Vgrads[0], ix * StepSNorm);
              dT2 := CalcDE(pIt3Dext, pMCTparas);
              if itmp <> 0 then N[2] := N[2] + dT2 / itmp;
              if iy <> 0 then N[1] := N[1] + dT2 / iy;
              if ix <> 0 then N[0] := N[0] + dT2 / ix;
            end;
        ScaleVectorV(@N, 0.0075);
      end
      else
      begin
        mAddVecWeight(@pIt3Dext.C1, @Vgrads[2], Noffset);
        N[2] := CalcDE(pIt3Dext, pMCTparas);                //Zgradient
        mAddVecWeight(@pIt3Dext.C1, @Vgrads[2], -2 * Noffset);
        N[2] := (N[2] - CalcDE(pIt3Dext, pMCTparas)) * s05;
        mCopyAddVecWeight(@pIt3Dext.C1, @CT1, @Vgrads[0], Noffset);
        N[0] := CalcDE(pIt3Dext, pMCTparas);                //Xgradient
        mAddVecWeight(@pIt3Dext.C1, @Vgrads[0], -2 * Noffset);
        N[0] := (N[0] - CalcDE(pIt3Dext, pMCTparas)) * s05;
        mCopyAddVecWeight(@pIt3Dext.C1, @CT1, @Vgrads[1], Noffset);
        N[1] := CalcDE(pIt3Dext, pMCTparas);                //Ygradient
        mAddVecWeight(@pIt3Dext.C1, @Vgrads[1], -2 * Noffset);
        N[1] := (N[1] - CalcDE(pIt3Dext, pMCTparas)) * s05;
      end;
      if iSmNormals > 0 then     //smoothed with estimation of roughness, eg deviation from mid val
      begin
        Noffset := Noffset * 2;
        if iSmNormals < 8 then 
        begin
          mCopyAddVecWeight(@pIt3Dext.C1, @CT1, @Vgrads[0], -Noffset);     //smooth mid point
          dNN := dNN + CalcDE(pIt3Dext, pMCTparas);
          mAddVecWeight(@pIt3Dext.C1, @Vgrads[0], 2 * Noffset);
          dNN := dNN + CalcDE(pIt3Dext, pMCTparas);
          mCopyAddVecWeight(@pIt3Dext.C1, @CT1, @Vgrads[1], -Noffset);
          dNN := dNN + CalcDE(pIt3Dext, pMCTparas);
          mAddVecWeight(@pIt3Dext.C1, @Vgrads[1], 2 * Noffset);
          dNN := (dNN + CalcDE(pIt3Dext, pMCTparas)) * 0.2;
        end;
        SmoothN := iSmNormals;
        StepSNorm := Noffset * 3 / (SmoothN + s05);
        dM := SmoothN * 2;

        CreateXYVecsFromNormals(@N, @Vx, @Vy);   //make ortho vector x,y related to normals
        RotateVectorReverse(@Vx, @Vgrads);
        RotateVectorReverse(@Vy, @Vgrads);
        mCopyAddVecWeight(@pIt3Dext.C1, @CT1, @Vx, -SmoothN * StepSNorm);
        NN1 := 0;
        dS := 0;
        for itmp := -SmoothN to SmoothN do
        begin
          if itmp <> 0 then
          begin
            dT2 := (CalcDE(pIt3Dext, pMCTparas) - dNN) / itmp;
            NN1 := NN1 + dT2;
            dS := dS + Sqr(dT2);
          end;
          mAddVecWeight(@pIt3Dext.C1, @Vx, StepSNorm);
        end;
        dSG := dS * dM - Sqr(NN1);
        mCopyAddVecWeight(@pIt3Dext.C1, @CT1, @Vy, -SmoothN * StepSNorm);
        NN2 := 0;
        dS := 0;
        for itmp := -SmoothN to SmoothN do
        begin
          if itmp <> 0 then
          begin
            dT2 := (CalcDE(pIt3Dext, pMCTparas) - dNN) / itmp;
            NN2 := NN2 + dT2;
            dS := dS + Sqr(dT2);
          end;
          mAddVecWeight(@pIt3Dext.C1, @Vy, StepSNorm);
        end;
        dT2 := Noffset * 0.5 / (dM * StepSNorm);
        dSG := dSG + dS * dM - Sqr(NN2);
        RMCalcRoughness(@N, sRoughness, @dT2, @dSG);
   //     sRoughness := Clamp01D(Sqrt(d1em100 + dSG * 7 * Sqr(dT2) /    //was: fp overflow  vals about 1e-100 ?
     //                   (d1em100 + Sqr(N[0]) + Sqr(N[1]) + Sqr(N[2]))) - 0.05);   //also called sqrt invalid! neg number?
        if iSmNormals < 8 then
        begin
          N[0] := N[0] + NN1 * dT2;
          N[1] := N[1] + NN2 * dT2;
        end;
      end;
      mCopyVec(@pIt3Dext.C1, @CT1);
      MakeWNormalsFromDVec(TPLNormals(mPsiLight), @N);
      if PInteger(@mPsiLight.NormalX)^ = 0 then
        if mPsiLight.NormalZ > 0 then mPsiLight.NormalZ := 32767
                                 else mPsiLight.NormalZ := -32767;

   //   if not IsCustomDE then Dec(pIt3Dext.maxIt, 4);  //test
     //   msDEstop := msDEstop * 0.5;
     //  bInsideRendering := bIR;
    end;
end;

procedure RMCalculateNormalsOnSmoothIt(pMCTparas: PMCTparameter; var NN: Single);
var itmp, SmoothN, iy, ix: Integer;
    Noffset, NN2, NN1, StepSNorm: Double;
    dT2, dM, dS, dSG: Double;
    N, CT1, Vx, Vy : TVec3D;
begin
    with pMCTparas^ do
    begin
      Noffset :=  MinCS(1, DEstop) * (1 + mZZ * mctDEstopFactor) * 0.15;
      pIt3Dext.CalcSIT := True;
      mCopyVec(@CT1, @pIt3Dext.C1);
      mMandFunction(@pIt3Dext.C1);
      NN := pIt3Dext.SmoothItD;
      if iSmNormals = 8 then
      begin
        ClearDVec(N);
        StepSNorm := Noffset * 1.3333;
        for itmp := -2 to 2 do
          for iy := -2 to 2 do
            for ix := -2 to 2 do
            if (itmp or iy or ix) <> 0 then
            begin
              mCopyAddVecWeight(@pIt3Dext.C1, @CT1, @Vgrads[2], itmp * StepSNorm);
              mAddVecWeight(@pIt3Dext.C1, @Vgrads[1], iy * StepSNorm);
              mAddVecWeight(@pIt3Dext.C1, @Vgrads[0], ix * StepSNorm);
              mMandFunction(@pIt3Dext.C1);
              dT2 := pIt3Dext.SmoothItD;
              if itmp <> 0 then N[2] := N[2] - dT2 / itmp;
              if iy <> 0 then N[1] := N[1] - dT2 / iy;
              if ix <> 0 then N[0] := N[0] - dT2 / ix;
            end;
        ScaleVectorV(@N, 0.0075);
      end
      else
      begin
        mAddVecWeight(@pIt3Dext.C1, @Vgrads[2], Noffset);
        mMandFunction(@pIt3Dext.C1);
        N[2] := pIt3Dext.SmoothItD;     //Zgradient
        mAddVecWeight(@pIt3Dext.C1, @Vgrads[2], -2 * Noffset);
        mMandFunction(@pIt3Dext.C1);
        N[2] := (pIt3Dext.SmoothItD - N[2]) * s05;
        mCopyAddVecWeight(@pIt3Dext.C1, @CT1, @Vgrads[0], Noffset);
        mMandFunction(@pIt3Dext.C1);
        N[0] := pIt3Dext.SmoothItD;     //Xgradient
        mAddVecWeight(@pIt3Dext.C1, @Vgrads[0], -2 * Noffset);
        mMandFunction(@pIt3Dext.C1);
        N[0] := (pIt3Dext.SmoothItD - N[0]) * s05;
        mCopyAddVecWeight(@pIt3Dext.C1, @CT1, @Vgrads[1], Noffset);
        mMandFunction(@pIt3Dext.C1);
        N[1] := pIt3Dext.SmoothItD;     //Ygradient
        mAddVecWeight(@pIt3Dext.C1, @Vgrads[1], -2 * Noffset);
        mMandFunction(@pIt3Dext.C1);
        N[1] := (pIt3Dext.SmoothItD - N[1]) * s05;
      end;
      if iSmNormals > 0 then     //smoothed with estimation of roughness, eg deviation from mid val
      begin
        Noffset := Noffset * 2;
        mCopyAddVecWeight(@pIt3Dext.C1, @CT1, @Vgrads[0], -Noffset);     //smooth mid point
        mMandFunction(@pIt3Dext.C1);
        NN := NN + pIt3Dext.SmoothItD;
        mAddVecWeight(@pIt3Dext.C1, @Vgrads[0], 2 * Noffset);
        mMandFunction(@pIt3Dext.C1);
        NN := NN + pIt3Dext.SmoothItD;
        mCopyAddVecWeight(@pIt3Dext.C1, @CT1, @Vgrads[1], -Noffset);
        mMandFunction(@pIt3Dext.C1);
        NN := NN + pIt3Dext.SmoothItD;
        mAddVecWeight(@pIt3Dext.C1, @Vgrads[1], 2 * Noffset);
        mMandFunction(@pIt3Dext.C1);
        NN := (NN + pIt3Dext.SmoothItD) * 0.2;

        SmoothN := iSmNormals;
        StepSNorm := Noffset * 3 / (SmoothN + s05);
        dM := SmoothN * 2;

        //make ortho vector x,y related to normals
        CreateXYVecsFromNormals(@N, @Vx, @Vy);
        RotateVectorReverse(@Vx, @Vgrads);
        RotateVectorReverse(@Vy, @Vgrads);

        mCopyAddVecWeight(@pIt3Dext.C1, @CT1, @Vx, -SmoothN * StepSNorm);
        NN1 := 0;
        dS := 0;
        for itmp := -SmoothN to SmoothN do
        begin
          if itmp <> 0 then
          begin
            mMandFunction(@pIt3Dext.C1);
            dT2 := (NN - pIt3Dext.SmoothItD) / itmp;
            NN1 := NN1 + dT2;
            dS := dS + Sqr(dT2);
          end;
          mAddVecWeight(@pIt3Dext.C1, @Vx, StepSNorm);
        end;
        dSG := dS * dM - Sqr(NN1);

        mCopyAddVecWeight(@pIt3Dext.C1, @CT1, @Vy, -SmoothN * StepSNorm);
        NN2 := 0;
        dS := 0;
        for itmp := -SmoothN to SmoothN do
        begin
          if itmp <> 0 then
          begin
            mMandFunction(@pIt3Dext.C1);
            dT2 := (NN - pIt3Dext.SmoothItD) / itmp;  //smoothit + inf!
            NN2 := NN2 + dT2;
            dS := dS + Sqr(dT2);
          end;
          mAddVecWeight(@pIt3Dext.C1, @Vy, StepSNorm);
        end;
        dT2 := Noffset * s05 / (dM * StepSNorm);
        dSG := dSG + dS * dM - Sqr(NN2);
        RMCalcRoughness(@N, sRoughness, @dT2, @dSG);
  //      sRoughness := Clamp01D(Sqrt(d1em100 + (dSG + dS * dM - Sqr(NN2)) * 7 * Sqr(dT2) /    //was: fp overflow  vals about 1e-100 ?
    //                     (d1em100 + Sqr(N[0]) + Sqr(N[1]) + Sqr(N[2]))) - 0.05);
        if iSmNormals < 8 then
        begin
          N[0] := N[0] + NN1 * dT2;
          N[1] := N[1] + NN2 * dT2;
        end;
      end;
      mCopyVec(@pIt3Dext.C1, @CT1);
      if bInsideRendering then ScaleVectorV(@N, -1);
      MakeWNormalsFromDVec(TPLNormals(mPsiLight), @N);
      if PInteger(@mPsiLight.NormalX)^ = 0 then
        if mPsiLight.NormalZ > 0 then mPsiLight.NormalZ := 32767
                                 else mPsiLight.NormalZ := -32767;
{      if PInteger(@mPsiLight.NormalX)^ = 0 then
        mPsiLight.NormalZ := -32767
      else
      begin
        RotateVectorReverse(@N, @Vgrads);  //N=-NAN,-NAN,-NAN if smoothit fails
        if mVGradsFOV[0] * N[0] + mVGradsFOV[1] * N[1] + mVGradsFOV[2] * N[2] > 0 then   // proof if vec is behind slice, pointing in wrong direction
          mPsiLight.NormalZ := -mPsiLight.NormalZ;
      end;}
    end;
end;

procedure RMdoBinSearchIt(pMCTparas: PMCTparameter; var ZZ: Double);
var dT1, dmul: Double;
    itmp, MItmp, MItmp2: Integer;
    LastSI, R, LastDif, YP{, dTmul}: Single;
    firstIt: LongBool;
begin
    with TPIteration3Dext(pMCTparas.pIt3Dext)^ do
    begin
      YP    := maxIt - 0.99;
      MItmp := pMCTparas.iMaxIt;
      MItmp2 := pMCTparas.iMaxItF2;
      if DEoption <> 20 then Inc(pMCTparas.iMaxIt);
      MaxIt := pMCTparas.iMaxIt;
      if pMCTparas.DEoption2 <> 20 then Inc(pMCTparas.iMaxItF2);
      itmp    := pMCTparas.iDEAddSteps;
      CalcSIT := True;
      dT1     := 0;
      dmul    := 1;
      firstIt := True;
      repeat
        ZZ := ZZ + dT1;
        mAddVecWeight(@C1, @pMCTparas.mVgradsFOV, dT1);
        pMCTparas.CalcDE(pMCTparas.pIt3Dext, pMCTparas);
        if not firstIt then
        begin
          if LastDif < Abs(YP - SmoothItD) then
          begin
            ZZ := ZZ - dT1;
            mAddVecWeight(@C1, @pMCTparas.mVgradsFOV, -dT1);
            SmoothItD := LastSI;
            if dT1 > 0 then dmul := dmul * s05
                       else dmul := dmul * 0.7;
          end;
        end;
        LastDif := Abs(YP - SmoothItD);
        LastSI  := SmoothItD;
        if SmoothItD > maxIt - 0.1 then dT1 := -3 else
        begin
          ZZ := ZZ - 0.001;
          mAddVecWeight(@C1, @pMCTparas.mVgradsFOV, -0.001);
          pMCTparas.CalcDE(pMCTparas.pIt3Dext, pMCTparas);
          R := LastSI - SmoothItD;
          if Abs(R) < 1e-30 then
            dT1 := Integer(LastSI < SmoothItD) - s05
          else if R < 0 then dT1 := (YP - SmoothItD) / (R * 500)
                        else dT1 := (YP - SmoothItD) / (R * 1000);

          if dT1 >  4 then dT1 := Sqrt(dT1) * 2 else
          if dT1 < -9 then dT1 := Sqrt(-dT1) * -3;
          dT1 := dT1 * dmul + 0.0005;
        end;
        firstIt := False;
        Dec(itmp);
      until itmp < 0;
      maxIt := MItmp;
      pMCTparas.iMaxIt := MItmp;
      pMCTparas.iMaxItF2 := MItmp2;
    end;
end;

procedure RMCalculateStartPos(pMCTparas: PMCTparameter; ix, iy: Integer);
                                //eax                   edx  ecx
{begin
    with pMCTparas^ do
    begin
      pIt3Dext.C1 := Ystart[0] + Vgrads[0,0] * ix + Vgrads[1,0] * iy;
      pIt3Dext.C2 := Ystart[1] + Vgrads[0,1] * ix + Vgrads[1,1] * iy;
      pIt3Dext.C3 := Ystart[2] + Vgrads[0,2] * ix + Vgrads[1,2] * iy;
    end; }
asm
    add  eax, $78
    cmp  dword [eax + TMCTparameter.MCTCameraOptic - $78], 2
    jne  @@2
    mov  ecx, dword [eax + TMCTparameter.pIt3Dext - $78]
    fld  qword [eax + TMCTparameter.Ystart - $78]
    fld  qword [eax + TMCTparameter.Ystart - $78 + 8]
    fld  qword [eax + TMCTparameter.Ystart - $78 + 16]
    fstp qword [ecx + TIteration3Dext.C3]
    fstp qword [ecx + TIteration3Dext.C2]
    fstp qword [ecx + TIteration3Dext.C1]
    ret
@@2:
    cmp  SupportSSE2, 0
    jz @@1
    push ecx
    push edx
    cvtpi2pd xmm7, [esp]  //xx,yy
    mov  ecx, dword [eax + TMCTparameter.pIt3Dext - $78]  //+68
    lea  edx, eax + $78   //TMCTparameter.Ystart
    movapd   xmm6, xmm7
    unpckhpd xmm7, xmm7   //yy,yy
    unpcklpd xmm6, xmm6   //xx,xx
    movupd xmm0, [eax + TMCTparameter.Vgrads - $78]
    movupd xmm2, [eax + TMCTparameter.Vgrads - $60]
    movupd xmm4, [edx + TMCTparameter.Ystart - $78 - $78]
    mulpd  xmm0, xmm6
    mulsd  xmm6, [eax + TMCTparameter.Vgrads - $68]
    mulpd  xmm2, xmm7
    mulsd  xmm7, [eax + TMCTparameter.Vgrads - $50]
    addpd  xmm0, xmm2
    addsd  xmm6, xmm7
    addpd  xmm0, xmm4
    addsd  xmm6, [edx + TMCTparameter.Ystart - $78 - $68]
    movupd [ecx + TIteration3Dext.C1], xmm0
    movsd  [ecx + TIteration3Dext.C3], xmm6
    pop  edx
    pop  ecx
    ret
@@1:
    push ecx
    fild dword [esp]
    push edx
    fild dword [esp]  //xx,yy
    mov  ecx, dword [eax + TMCTparameter.pIt3Dext - $78]  //+68
    lea  edx, eax + $78 //TMCTparameter.Ystart
    fld  qword [eax + TMCTparameter.Vgrads - $78]
    fmul st, st(1)
    fld  qword [eax + TMCTparameter.Vgrads - $78 + 24]
    fmul st, st(3)
    faddp
    fadd qword [edx + TMCTparameter.Ystart - $78 - $78]
    fstp qword [ecx + TIteration3Dext.C1]
    fld  qword [eax + TMCTparameter.Vgrads - $78 + 8]
    fmul st, st(1)
    fld  qword [eax + TMCTparameter.Vgrads - $78 + 32]
    fmul st, st(3)
    faddp
    fadd qword [edx + TMCTparameter.Ystart - $70 - $78]
    fstp qword [ecx + TIteration3Dext.C2]           //xx,yy
    fmul qword [eax + TMCTparameter.Vgrads - $78 + 16]
    fxch
    fmul qword [eax + TMCTparameter.Vgrads - $78 + 40]
    faddp
    fadd qword [edx + TMCTparameter.Ystart - $68 - $78]
    fstp qword [ecx + TIteration3Dext.C3]
    pop  edx
    pop  ecx
end;

procedure CalculateVgradsFOVCommon(MCTparas: PMCTparameter; ix: Integer);
begin
    MCTparas.CAFX := (MCTparas.FOVXoff - ix) * MCTparas.FOVXmul;
    BuildViewVectorDFOV(MCTparas.CAFY, MCTparas.CAFX, @MCTparas.mVgradsFOV);
    RotateVectorReverse(@MCTparas.mVgradsFOV, @MCTparas.VGrads);
end;

procedure CalculateVgradsFOVRect(MCTparas: PMCTparameter; ix: Integer);
begin
    MCTparas.CAFX := (MCTparas.FOVXoff - ix) * MCTparas.FOVXmul;
    MCTparas.mVgradsFOV[0] := -MCTparas.CAFX;
    MCTparas.mVgradsFOV[1] := MCTparas.CAFY;
    MCTparas.mVgradsFOV[2] := MCTparas.mctPlOpticZ;
    NormaliseVectorVar(MCTparas.mVgradsFOV);
    RotateVectorReverse(@MCTparas.mVgradsFOV, @MCTparas.VGrads);
end;

procedure CalculateVgradsFOVPanorama(MCTparas: PMCTparameter; ix: Integer);
begin
    MCTparas.CAFX := (MCTparas.FOVXoff - ix) * MCTparas.FOVXmul;
    BuildViewVectorDSphereFOV(MCTparas.CAFY, MCTparas.CAFX, @MCTparas.mVgradsFOV);
    RotateVectorReverse(@MCTparas.mVgradsFOV, @MCTparas.VGrads);
end;

                                   //eax               edx
procedure RMCalculateVgradsFOV(pMCTparas: PMCTparameter; ix: Integer);
{begin
    with MCTparas do
    begin
      CAFX := (FOVXoff - ix) * FOVXmul;
      if bMCTPlanarOptic = 1 then   //iMCTCamOption: Integer = 0:def 1:rect 2:spherepano
      begin
        VgradsFOV[0] := -CAFX;
        VgradsFOV[1] := CAFY;
        VgradsFOV[2] := mctPlOpticZ;
        NormaliseVectorVar(VgradsFOV);
      end
      else if bMCTPlanarOptic = 2 then
        BuildViewVectorDSphereFOV(CAFY, CAFX, @VgradsFOV)
      else BuildViewVectorDFOV(CAFY, CAFX, @VgradsFOV);
      RotateVectorReverse(@VgradsFOV, @VGrads);
    end; }
asm
    push ebx
    push esi
    push edx  //to store ix in [esp] and fiload  (esp := esp-4)
    lea  ebx, eax + $1a0
    fild dword [esp]  //ix
    fsubr dword [ebx + TMCTparameter.FOVXoff - $1a0]
    fmul dword [ebx + TMCTparameter.FOVXmul - $1a0]
    fst  qword [ebx + TMCTparameter.CAFX - $1a0]         // $1a0
    cmp  dword [ebx + TMCTparameter.MCTCameraOptic - $1a0], 1  // $1fc
    je   @@3
    fstp st
    lea  ecx, [ebx + TMCTparameter.mVgradsFOV - $1a0]
    lea  edx, [ebx + TMCTparameter.CAFX - $1a0]         // $1a0
    lea  eax, [ebx + TMCTparameter.CAFY - $1a0]         // $1a8
    cmp  dword [ebx + TMCTparameter.MCTCameraOptic - $1a0], 0  // $1fc
    je   @@1
    call BuildViewVectorDSphereFOV
    jmp @@2
@@3:
    fchs
    fstp qword [ebx + TMCTparameter.mVgradsFOV - $1a0]
    fld  qword [ebx + TMCTparameter.CAFY - $1a0]         // $1a8
    fstp qword [ebx + TMCTparameter.mVgradsFOV - $1a0 + 8]
    fld  dword [ebx + TMCTparameter.mctPlOpticZ - $1a0]  // $204
    fstp qword [ebx + TMCTparameter.mVgradsFOV - $1a0 + 16]
    lea  eax, [ebx + TMCTparameter.mVgradsFOV - $1a0]
    call NormaliseVectorVar
    jmp  @@2
@@1:
    call BuildViewVectorDFOV
@@2:
    lea  edx, [ebx + TMCTparameter.VGrads - $1a0]       // $80
    lea  eax, [ebx + TMCTparameter.mVgradsFOV - $1a0]
    call RotateVectorReverse
    pop  edx    //to Inc(esp, 4)
    pop  esi
    pop  ebx
end;

procedure RMdoColorOnIt(pMCTparas: PMCTparameter);
var i: Integer;
begin
    with pMCTparas^do
    begin
      if ColorOnIt = 1 then mCopyVec(@pIt3Dext.x, @pIt3Dext.C1) else
      begin
        i := pIt3Dext.maxIt;
        pIt3Dext.maxIt := ColorOnIt - 1;
        pIt3Dext.RStop := Sqr(pIt3Dext.RStop) * 64;
        CalcDE(pIt3Dext, pMCTparas);
        pIt3Dext.maxIt := i;
        pIt3Dext.RStop := dRStop;
      end;
    end;
end;
                         //eax
procedure RMdoColor(pMCTparas: PMCTparameter);
{var s, s2: Single;
    dv: TVec3D;
begin
    with pMCTparas.pIt3Dext^ do
    begin
      case pMCTparas.ColorOption of
        1:  s := Ln(Rout / (Rold + 1)) * pMCTparas.mctColorMul;
        2:  s := (ArcTan2(y - C2, x - C1) + Pi) * 5200;
        3:  s := (ArcTan2(z - C3, x - C1) + Pi) * 5200;
        4:  s := (ArcTan2(z - C3, y - C2) + Pi) * 5200;
     5, 6:  begin
              s := (ArcTan2(x, y) + Pi) * 5215;    //output vec
              dv := NormaliseVector(@x);
              s2 := (Pi + ArcSinSafe(dv[2]) * 2) * 5215;
              MinMaxClip15bit(s2, pMCTparas.mPsiLight.SIgradient);
            end;
        else s := OTrap * 4096;
      end;
      MinMaxClip15bit(s, pMCTparas.mPsiLight.OTrap);
    end;   }
const
    cd5200: Single = 5200;
    cd4096: Single = 4096;
    cd5215: Single = 5215;
asm
    push  ebx
    push  edi
    push  edx //just to get dword [esp]
    mov   edi, [eax + TMCTparameter.mPsiLight]
    mov   ebx, [eax + TMCTparameter.pIt3Dext]
    movzx edx, byte [eax + TMCTparameter.ColorOption]  //coloroption
    cmp   edx, 6
    jnb   @@COelse
    jmp   dword [edx * 4 + @@jmptable]
@@jmptable:
dd  @@COelse, @@CO1, @@CO2, @@CO3, @@CO4, @@CO5
@@CO1:
    fld   qword [ebx + 8]     //Rold
    fld1
    faddp
    fdivr qword [ebx + $70] //Rout
    fldln2
    fxch
    fyl2x
    fmul  dword [eax + TMCTparameter.mctColorMul] //mctColorMul
    jmp   @@up
    nop
@@CO2:
    fld   qword [ebx+$20]
    fsub  qword [ebx+$40]
    jmp @1
@@CO3:
    fld   qword [ebx+$28]
    fsub  qword [ebx+$48]
@1: fld   qword [ebx+$18]
    fsub  qword [ebx+$38]
@2: fpatan
    fldpi
    faddp
    fmul  cd5200
    jmp   @@up
@@CO4:
    fld   qword [ebx+$28]
    fsub  qword [ebx+$48]
    fld   qword [ebx+$20]
    fsub  qword [ebx+$40]
    jmp   @2
@@CO5:
    fld   qword [ebx+$20]
    fld   st
    fmul  st, st          //yy,y
    fld   qword [ebx+$18]  //x,yy,y
    fld   st
    fmul  st, st          //xx,x,yy,y
    fxch  st(3)           //y,x,yy,xx
    fpatan
    fldpi
    faddp
    fmul  cd5215          //s,yy,xx
    fxch  st(2)           //xx,yy,s
    faddp
    fadd  d1em100
    fld   qword [ebx+$28] //z,yy+xx,s      norm vec[2] for arcsin
    fld   st
    fmul  st, st        //zz,z,yy+xx,s
    faddp st(2), st     //z,rr,s
    fxch                //rr,z,s
    fsqrt           //r,z,s
    fdivp           //z/r,s
@@s2:
    fld1                //arcsin(x) = arctan2(x, sqrt(1-x*x))
    fld   st(1)
    fmul  st(0), st(0)
    fsubp
    fsqrt
    fpatan
    fadd  st, st
    fldpi
    faddp
    fmul  cd5215
    fstp  dword [esp]
    lea   edx, [edi + TsiLight5.SIgradient]
    mov   eax, esp
    call  MinMaxClip15bit
    jmp   @@up
@@COelse:
    fld   qword [ebx + TIteration3Dext.OTrap]
    fmul  cd4096
@@up:
    fstp  dword [esp]
    lea   edx, [edi + TsiLight5.Otrap]
    mov   eax, esp
    call  MinMaxClip15bit
    pop   edx
    pop   edi
    pop   ebx
end;

{procedure RMdoBinSearch(var dTmp, RLastStepWidth, mZZ: Double; RMrec: TPRaymarchRec);
var dT1: Double;
    itmp, itst: Integer;
begin
    with RMrec^ do
    begin
      itst := PMCTparas.iMaxit;
      PMCTparas.iMaxit := PIt3Dex.ItResultI;  //for dIFS necessary
      itmp := PMCTparas.iDEAddSteps;
      dT1 := RLastStepWidth * -0.5;
      while (itmp > 0) and (Abs(dTmp - PMCTparas.msDEstop) > 0.001) do
      begin
        mZZ := mZZ + dT1;
        mAddVecWeight(@PIt3Dex.C1, @MarchVec, dT1);
    //    PMCTparas.msDEstop := StartDEstop * (1 + mZZ * PMCTparas.mctDEstopFactor);
        PMCTparas.msDEstop := StartDEstop * (1 + Clamp0D(ActZpos + mZZ * ZZposMul) * PMCTparas.mctDEstopFactor);
        dTmp := CalcDE(PIt3Dex, PMCTparas);
        if PIt3Dex.ItResultI >= PMCTparas.MaxItsResult then
          dT1 := Abs(dT1) * -1 else
        begin
          if dTmp < PMCTparas.msDEstop then dT1 := Abs(dT1) * -0.55
                                       else dT1 := Abs(dT1) * 0.55;
          Dec(itmp);
        end;
      end;
      PMCTparas.iMaxit := itst;
    end;
end;   }

procedure RMmaxLengthToCutPlane(pMCTparas: PMCTparameter; var dLength: Double; var itmp: Integer; vPos: TPPos3D);
var dTmp: Double;
begin
    dLength := 0;
    if pMCTparas.iCutOptions <> 0 then
    with pMCTparas^ do
    begin
      if ((iCutOptions and 1) <> 0) and (Abs(mVgradsFOV[0]) > 1e-20) then
      begin
        if (((iCutOptions shl 3) xor PByte(Integer(@mVgradsFOV[0]) + 7)^) and $80) = 0 then dLength := 1e20 else
        begin
          dTmp := (dCOX - vPos^[0]) / mVgradsFOV[0];
          if dTmp > dLength then
          begin
            dLength := dTmp;
            itmp := 1;
          end;
        end;
      end;
      if ((iCutOptions and 2) <> 0) and (Abs(mVgradsFOV[1]) > 1e-20) then
      begin                             
        if (((iCutOptions shl 2) xor PByte(Integer(@mVgradsFOV[1]) + 7)^) and $80) = 0 then dLength := 1e20 else
        begin
          dTmp := (dCOY - vPos^[1]) / mVgradsFOV[1];
          if dTmp > dLength then
          begin
            dLength := dTmp;
            itmp := 2;
          end;
        end;
      end;
      if ((iCutOptions and 4) <> 0) and (Abs(mVgradsFOV[2]) > 1e-20) then
      begin                            
        if (((iCutOptions shl 1) xor PByte(Integer(@mVgradsFOV[2]) + 7)^) and $80) = 0 then dLength := 1e20 else
        begin
          dTmp := (dCOZ - vPos^[2]) / mVgradsFOV[2];
          if dTmp > dLength then
          begin
            dLength := dTmp;
            itmp := 3;
          end;
        end;
      end;
    end;
{asm           // pMCTparas: PMCTparameter; var dLength: Double; var itmp: Integer; vPos: TPPos3D)
    push ebx  //   eax                        edx                 ecx
    push esi
    push edi
    xor  esi, esi
    mov  [edx], esi
    mov  [edx+4], esi
    lea  ebx, eax+TMCTparameter.iCutOptions
    cmp  ebx, 0
    jle  @@1
    mov  esi, eax
    test ebx, 1
    jle  @@2
    fld  qword [esi+TMCTparameter.mVgradsFOV]
    fabs
    fcomp s1em20
    fnstsw ax
    shr  ah, 1
    jc   @@2

    

@@2:


@@1:
    pop  edi
    pop  esi
    pop  ebx   }
end;

procedure RMcalcNanglesForCut(pMCTparas: PMCTparameter; CutPlane: Integer);//; PSL: TPsiLight5);
{var NN: Double;
    N: TVec3D;
    itmp: Integer;
begin
    with pMCTparas^ do
    begin
      if CutPlane > 0 then
      begin
        NN := 8388352 - ZcMul * (Sqrt(mZZ * Zcorr + 1) - 1);
        if NN < 0 then itmp := 0 else itmp := Round(NN);
        PCardinal(@mPsiLight.RoughZposFine)^ := itmp shl 8;
        Dec(CutPlane);
        if Abs(Vgrads[2, CutPlane]) < 1e-40 then NN := -1e40 else NN := -1 / Vgrads[2, CutPlane]; //rel Normals to view
        N[0] := Vgrads[0, CutPlane] * NN;
        N[1] := Vgrads[1, CutPlane] * NN;
        N[2] := -1;
        MakeWNormalsFromDVec(TPLNormals(mPsiLight), @N);
      end else begin
        PCardinal(@mPsiLight.RoughZposFine)^ := $7FFF0000;
        mPsiLight.NormalX := 0;
        mPsiLight.NormalY := 0;
        mPsiLight.NormalZ := -32767;
      end;
    end;       }
const CS8388352: Single = 8388352;
asm
    push ebx
    push esi
    push edi
    add esp, -24
    mov edi, [eax+TMCTparameter.mPsiLight] //PSL
    mov esi, edx   //cutplane
    lea ebx, eax + 128   //MCTparas
    test esi, esi  //if cutplane>0
    jle @@1
    fld1
    fld qword [ebx+TMCTparameter.mZZ-128]    //+104 mZZ^,1  NN := 8388352 - ZcMul * (Sqrt(mZZ * Zcorr + 1) - 1);
    fmul qword [ebx+TMCTparameter.Zcorr-128] //$274
    fadd st, st(1)
    fsqrt
    fsubrp
    fmul qword [ebx+TMCTparameter.ZcMul-128] //$26c
    fsubr CS8388352          //NN
    
  {  ftst                     // if NN < 0 then iTmp := 0 else itmp := Round(NN);
    fnstsw ax
    shr ah, 1
    jnc @@2
    xor eax, eax
    fstp st
    jmp @@3
@@2:
    fistp dword [esp]
    mov eax, [esp]
    shl eax, 8               // PCardinal(@PSL.RoughZposFine)^ := iTmp shl 8;
@@3:
    mov [edi+6], eax }

    fistp dword [esp]
    mov eax, [esp]
    test eax, eax
    jns @@3
    xor eax, eax
@@3:
    shl eax, 8               // PCardinal(@PSL.RoughZposFine)^ := iTmp shl 8;
    mov [edi+6], eax

    dec esi                  //VGrads: +128
    fld qword [ebx+esi*8+TMCTparameter.VGrads+$30-128] // if Abs(Vgrads[2, CutPlane]) < 1e-40
    fabs
    fcomp d1em40
    fnstsw ax
    shr ah, 1
    jnc  @@4
    fld  dm1e40             // NN := -1e40
    jmp @@5
@@4:
    fld1                    // NN := -1 / Vgrads[2, CutPlane];
    fchs
    fdiv qword [ebx+esi*8+TMCTparameter.VGrads+$30-128]
@@5:
    fld qword [ebx+esi*8+TMCTparameter.VGrads-128]     // N[0] := Vgrads[0, CutPlane] * NN;
    fmul st, st(1)
    fstp qword [esp]
    fld qword [ebx+esi*8+TMCTparameter.VGrads+$18-128] // N[1] := Vgrads[1, CutPlane] * NN;
    fmulp
    fstp qword [esp+8]
    fld1
    fchs                           // N[2] := -1;
    fstp qword [esp+16]
    mov edx, esp                   // MakeWNormalsFromDVec(TPLNormals(PSL), @N);
    mov eax, edi
    call MakeWNormalsFromDVec
    jmp @@6
@@1:
    xor eax, eax
    mov [edi+6], $7fff0000
    mov dword [edi], eax
    mov word [edi+4], $8001
@@6:
    add esp, 24
    pop edi
    pop esi
    pop ebx   //}
end;
                                     //eax             edx      ecx          ebp+8
procedure RMdoSecantSearch(pMCTparas: PMCTparameter; var DE, RLastStepWidth, RLastDE: Double);
var RSFmul, LastDE: Double;
    itmp: Integer;
begin
    with pMCTparas^ do
    begin             //Secant
      itmp := (iDEAddSteps shr 1) + 1;
      while Abs(DE - msDEstop) > 0.001 do
      begin
        RLastDE := NotZero(RLastDE - DE);
        RSFmul := RLastStepWidth * (DE - msDEstop) / RLastDE;
        if DE < msDEstop then
        begin
          if (RSFmul >= 0) or (RSFmul < Abs(RLastStepWidth) * -0.94) then
            RLastStepWidth := Abs(RLastStepWidth) * -0.5
          else RLastStepWidth := RSFmul;
        end else begin
          if (RSFmul <= 0) or (RSFmul > Abs(RLastStepWidth) * 0.94) then
            RLastStepWidth := Abs(RLastStepWidth) * s05
          else RLastStepWidth := RSFmul;
        end;
        RLastDE := DE;
        mZZ := mZZ + RLastStepWidth;
        mAddVecWeight(@pIt3Dext.C1, @mVgradsFOV, RLastStepWidth);
        msDEstop := DEstop * (1 + Abs(mZZ) * mctDEstopFactor);
        Dec(itmp);
        if itmp <= 0 then Break;
        DE := CalcDE(pIt3Dext, pMCTparas);
      end;
    end;
end;
                                   //eax             edx      ecx          ebp+8
procedure RMdoBinSearch(pMCTparas: PMCTparameter; var DE, RLastStepWidth{, RLastDE}: Double);
{var RSFmul, LastDE: Double;
    itmp: Integer;
begin
    with pMCTparas^ do
    begin             //Secant
      itmp := iDEAddSteps shr 1;
      while Abs(DE - msDEstop) > 0.001 do
      begin
        RLastDE := NotZero(RLastDE - DE);
        RSFmul := RLastStepWidth * (DE - msDEstop) / RLastDE;
        if DE < msDEstop then
        begin
          if (RSFmul >= 0) or (RSFmul < Abs(RLastStepWidth) * -0.94) then
            RLastStepWidth := Abs(RLastStepWidth) * -0.5
          else RLastStepWidth := RSFmul;
        end else begin
          if (RSFmul <= 0) or (RSFmul > Abs(RLastStepWidth) * 0.94) then
            RLastStepWidth := Abs(RLastStepWidth) * s05
          else RLastStepWidth := RSFmul;
        end;
        RLastDE := DE;
        ZZ := ZZ + RLastStepWidth;
        mAddVecWeight(@Iteration3Dext.C1, @VgradsFOVit, RLastStepWidth);
        Dec(itmp);
        if itmp <= 0 then Break;
        msDEstop := DEstop * (1 + Abs(ZZ) * mctDEstopFactor);
        if itmp > 0 then DE := CalcDE(@Iteration3Dext, @MCTparas);
      end;
    end;
end;  }
{var dT1: Double;
    itmp, itst: Integer;
begin
    with pMCTparas^ do
    begin
      itst := iMaxit;      //if DEoption = 20 ?
      if FormulaType = 0 then iMaxIt := pIt3Dext.ItResultI;  //for dIFS  ..in inside rendering wrong result in DEcomb on 2nd alt. formula
      itmp := iDEAddSteps;
      dT1 := RLastStepWidth * -0.5;
      while Abs(dTmp - msDEstop) > 0.001 do
      begin
        mZZ := mZZ + dT1;
        mAddVecWeight(@pIt3Dext.C1, @mVgradsFOV, dT1);
        msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
        Dec(itmp);
        if itmp <= 0 then Break;
        dTmp := CalcDE(pIt3Dext, pMCTparas);
        if pIt3Dext.ItResultI >= MaxItsResult then
          dT1 := -Abs(dT1) else
        begin
          if dTmp < msDEstop then dT1 := Abs(dT1) * -0.55
                             else dT1 := Abs(dT1) * 0.55;
        end;
      end;
      iMaxIt := itst;
    end;
end; }
asm
  push ebx
  push esi
  push edi
  push ebp
  add  esp, -8
  mov  edi, edx  //@dTmp
  lea  esi, eax+$38 //@MCTParas (was:qTMandCalcThread)
  mov  ebx, [esi+TMCTparameter.pIt3Dext-$38]
{  mov  eax, [esi+TMCTparameter.iMaxit-$38]
  mov  [esp+8], eax
  mov  eax, [esi+TMCTparameter.iMaxitF2-$38]
  mov  [esp+12], eax
  mov  eax, [ebx+TIteration3Dext.ItResultI]     //+$a8
  cmp  dword [ebx+TIteration3Dext.DEoption], 20
  jne  @@0
//  cmp  dword [esi+TMCTparameter.FormulaType-$38],0  //+$78
//  jnz  @@1
  mov  [esi+TMCTparameter.iMaxit-$38], eax
  mov  [ebx+TIteration3Dext.maxIt], eax
@@0:
  cmp  dword [esi+TMCTparameter.DEoption2-$38], 20
  jne  @@1
  mov  [esi+TMCTparameter.iMaxitF2-$38], eax
@@1:  }
  mov  ebp, [esi+TMCTparameter.iDEAddSteps-$38] //+$40
  fld  qword [ecx]  // RLastStepWidth
  fmul sm05
  jmp  @@2
@@4:
  fld  qword [esi+TMCTparameter.mZZ-$38] //+$68
  fadd qword [esp]
  fstp qword [esi+TMCTparameter.mZZ-$38] //+$68
 { push dword [esp+4]
  push dword [esp+4]
  lea  edx, esi+TMCTparameter.mVgradsFOV-$38
  lea  eax, ebx+TIteration3Dext.C1       //+$68
  call mAddVecWeight  }
    fld  qword [esi+TMCTparameter.mVgradsFOV-$38]
    fld  qword [esi+TMCTparameter.mVgradsFOV-$38 + 8]
    fld  qword [esi+TMCTparameter.mVgradsFOV-$38 + 16]
    fld  qword [esp]
    fmul st(3), st
    fmul st(2), st
    fmulp
    fadd qword [ebx+TIteration3Dext.C1 + 16]
    fstp qword [ebx+TIteration3Dext.C1 + 16]
    fadd qword [ebx+TIteration3Dext.C1 + 8]
    fstp qword [ebx+TIteration3Dext.C1 + 8]
    fadd qword [ebx+TIteration3Dext.C1]
    fstp qword [ebx+TIteration3Dext.C1]

  fld  qword [esi+TMCTparameter.mZZ-$38]     //+$68
  fmul dword [esi+TMCTparameter.mctDEstopFactor-$38] //+$54
  fld1
  faddp
  fmul dword [esi+TMCTparameter.DEstop-$38]    //+$60
  fstp dword [esi+TMCTparameter.msDEstop-$38]  //+$38  msDEstop := DEstop * (1 + mZZ * mctDEstopFactor);
  dec  ebp
  test ebp, ebp
  jle  @@3
  lea  edx, esi-$38
  mov  eax, ebx
  call esi+TMCTparameter.CalcDE-$38
  fstp qword [edi]  //dTmp
 { mov  eax, [ebx+TIteration3Dext.ItResultI]
  cmp  eax, [esi+TMCTparameter.MaxItsResult-$38]
  jl   @@5
  fld  qword [esp]
  fabs
  fchs               // dT1 := -Abs(dT1)
  jmp  @@2
@@5:     }
  fld  qword [edi]
  fcomp dword [esi+TMCTparameter.msDEstop-$38]  //+$38
  fnstsw ax
  fld  qword [esp]
  fabs
  fmul s055
  shr  ah, 1
  jnc  @@8
  fchs
@@8:
//  dec  ebp //
@@2:
  fstp qword [esp]
//  test ebp, ebp  //
 // jle  @@3 //
  fld  qword [edi]
  fsub dword [esi+TMCTparameter.msDEstop-$38]  //+$38
  fabs
  fcomp s0001
  fnstsw ax
  shr  ah, 1
  jnc  @@4
@@3:
{  mov  eax, [esp+8]
  mov  [esi+TMCTparameter.iMaxit-$38], eax
  mov  [ebx+TIteration3Dext.maxIt], eax
  mov  eax, [esp + 12]
  mov  [esi + TMCTparameter.iMaxitF2-$38], eax }
  add  esp, 8
  pop  ebp
  pop  edi
  pop  esi
  pop  ebx
end;         //}

{  TRaymarchRec = record
    PMCTparas: PMCTparameter;
    PIt3Dex: TPIteration3Dext;
    ActPos, MarchVec, VievVec: TVec3D;
    ActZpos, StartDEstop, ZZposMul, DEmulVary, DEmulConst, MaxRayLength: Double;
    BinSteps, seed, RMresult: Integer;      //result: 0: no object  1: object on DE 2: object on Itcount  3: Outside again?
    StepCount, StepForward, Zstepped: Single;         //on start: 0/1/2 = outside/insideConstStep/insideDIFSDE?
  end;                                        }
procedure RayMarch(RMrec: TPRaymarchRec);
var itmp: Integer;
    DElimited, bFirstStep: LongBool;
    RSFmul: Single;
    RLastStepWidth, dTmp, dT1, RLastDE: Double;
begin
    with RMrec^ do
    begin
      PIt3Dex.CalcSIT := False;
      itmp := 0;
      StepCount := 0;
      Zstepped := 0;
      ZZposMul := DotOfVectorsNormalize(@MarchVec , @VievVec);
      PMCTparas.msDEstop := StartDEstop;
      bFirstStep := PMCTparas.bMCTFirstStepRandom;
      mCopyVec(@ActPos, @PIt3Dex.C1);

      Zstepped := Zstepped + StepForward;
      mAddVecWeight(@PIt3Dex.C1, @MarchVec, StepForward);

      if PMCTparas.iCutOptions > 0 then   // move to begin of cutting planes todo: check on which side, modify MaxRayLength if step towards cutplane
      begin
        RMmaxLengthToCutPlane(PMCTparas, dT1, itmp, @ActPos);
        if dT1 > MaxRayLength then
        begin
          RMresult := 0;
          Exit;
        end else begin
          Zstepped := dT1;
          mAddVecWeight(@PIt3Dex.C1, @MarchVec, dT1);
          PMCTparas.msDEstop := StartDEstop * (1 + Clamp0D(ActZpos + Zstepped * ZZposMul) * PMCTparas.mctDEstopFactor);
          dTmp := PMCTparas.CalcDE(PIt3Dex, PMCTparas);
        end;
      end
      else dTmp := PMCTparas.CalcDE(PIt3Dex, PMCTparas);

      if (PIt3Dex.ItResultI >= PMCTparas.MaxItsResult) or (dTmp < PMCTparas.msDEstop) then   // already in the set, todo: proof if same formula (DEcomb)?
      begin
        if dTmp < PMCTparas.msDEstop then RMresult := 1 else RMresult := 2;
        mCopyVec(@PIt3Dex.C1, @ActPos);
        Exit;
      end
      else
      begin
        RSFmul := 1;
        RLastStepWidth := dTmp * PMCTparas.sZstepDiv;
     //   RLastDE := dTmp + RLastStepWidth;
        repeat
          if PIt3Dex.ItResultI >= PMCTparas.MaxItsResult then //inside while stepping
          begin
            dT1 := -0.5 * RLastStepWidth;
            Zstepped := Zstepped + dT1;
            mAddVecWeight(@PIt3Dex.C1, @MarchVec, dT1);
            PMCTparas.msDEstop := StartDEstop * (1 + Clamp0D(ActZpos + Zstepped * ZZposMul) * PMCTparas.mctDEstopFactor);
            dTmp := PMCTparas.CalcDE(PIt3Dex, PMCTparas);
            RLastStepWidth := -dT1;
          end;

          if (PIt3Dex.ItResultI < PMCTparas.iMinIt) or
             ((PIt3Dex.ItResultI < PMCTparas.MaxItsResult) and (dTmp >= PMCTparas.msDEstop)) then    //##### next step ######
          begin
            RLastDE := dTmp;

            dTmp := dTmp * PMCTparas.sZstepDiv * RSFmul;
            dT1 := MaxCS(PMCTparas.msDEstop, 0.4) * PMCTparas.mctMH04ZSD;
            if dT1 < dTmp then
            begin
              if not bFirstStep then StepCount := StepCount + dT1 / dTmp else StepCount := StepCount + Random;
              dTmp := dT1;
            end
            else StepCount := StepCount + 1;

            if bFirstStep then   {..$Q-  integer overflow check}
            begin
              bFirstStep := False;
              seed := 214013 * seed + 2531011;
              dTmp := ((seed shr 16) and $7FFF) * 0.000030517578125 * dTmp;
            end;

              {  if DEoption = 20 then    //test for dIFS, do not overstep with high DEstop vals, on high fov you have to diff new destop
                begin
                  dT1 := DEstop * (1 + (ZZ + dTmp) * mctDEstopFactor) * 0.9;
                  dTmp := MinCD(dTmp, (RLastDE - dT1) * sZstepDiv);
                end; }

            RLastStepWidth := dTmp;
            Zstepped := Zstepped + dTmp;
            mAddVecWeight(@PIt3Dex.C1, @MarchVec, dTmp);
            PMCTparas.msDEstop := StartDEstop * (1 + Clamp0D(ActZpos + Zstepped * ZZposMul) * PMCTparas.mctDEstopFactor);
                                                   //todo: pointcam.. actZpos := distance of actPos to CamPos!
            dTmp := PMCTparas.CalcDE(PIt3Dex, PMCTparas);

            if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;

            if RLastDE > dTmp + s1em30 then
            begin
              dT1 := RLastStepWidth / (RLastDE - dTmp);
              if dT1 < 1 then
                RSFmul := maxCS(s05, dT1)
              else
                RSFmul := 1;
            end
            else RSFmul := 1;
          end
          else     // ##### set found #####
          begin
            DElimited := PIt3Dex.ItResultI < PMCTparas.MaxItsResult;

            if PMCTparas.iDEAddSteps > 0 then
            begin
              if DElimited then
                RMdoBinSearch(PMCTparas, dTmp, RLastStepWidth{, RLastDE})
              else
              begin
                RMdoBinSearchIt(PMCTparas, Zstepped);
              end;
            end;
            ActZpos := Clamp0D(ActZpos + Zstepped * ZZposMul);
            if DElimited then RMresult := 1 else RMresult := 2;
            mCopyVec(@PIt3Dex.C1, @ActPos);
            Exit;
          end;
        until (Zstepped > MaxRayLength) or PMCTparas.PCalcThreadStats.pLBcalcStop^;  //or ActZpos' < 0? (frontclipping)
        RMresult := 0;
        ActZpos := Clamp0D(ActZpos + Zstepped * ZZposMul);
      end;
    end;
end;

procedure RayMarchVV(RMrec: TPRaymarchRec);  //raymarch in viewvec, extra because a bit simpler? (or: do it in asm)
var itmp: Integer;
    DElimited, bFirstStep: LongBool;
    RSFmul: Single;
    RLastStepWidth, dTmp, dT1, RLastDE, ZZ: Double;
begin
    with RMrec^ do
    begin
      PIt3Dex.CalcSIT := False;
      itmp := 0;
      StepCount := 0;
      ZZ := 0;
      PMCTparas.msDEstop := StartDEstop;
      bFirstStep := PMCTparas.bMCTFirstStepRandom;
      mCopyVec(@ActPos, @PIt3Dex.C1);
      if PMCTparas.iCutOptions > 0 then   // move to begin of cutting planes todo: check on which side, modify MaxRayLength if step towards cutplane
      begin
        RMmaxLengthToCutPlane(PMCTparas, dT1, itmp, @ActPos);
        if dT1 > MaxRayLength then
        begin
          RMresult := 0;
          Exit;
        end else begin
          ZZ := dT1;
          mAddVecWeight(@PIt3Dex.C1, @MarchVec, dT1);
          PMCTparas.msDEstop := StartDEstop * (1 + ZZ * PMCTparas.mctDEstopFactor);
          dTmp := PMCTparas.CalcDE(PIt3Dex, PMCTparas);
        end;
      end
      else dTmp := PMCTparas.CalcDE(PIt3Dex, PMCTparas);

      if (PIt3Dex.ItResultI >= PMCTparas.MaxItsResult) or (dTmp < PMCTparas.msDEstop) then   // already in the set, todo: proof if same formula (DEcomb)?
      begin
        if dTmp < PMCTparas.msDEstop then RMresult := 1 else RMresult := 2;
        mCopyVec(@PIt3Dex.C1, @ActPos);
        Exit;
      end
      else
      begin
        RSFmul := 1;
        RLastStepWidth := dTmp * PMCTparas.sZstepDiv;
  //      RLastDE := dTmp + RLastStepWidth;
        repeat
          if PIt3Dex.ItResultI >= PMCTparas.MaxItsResult then //inside while stepping
          begin
            dT1 := -0.5 * RLastStepWidth;
            ZZ := ZZ + dT1;
            mAddVecWeight(@PIt3Dex.C1, @MarchVec, dT1);
            PMCTparas.msDEstop := StartDEstop * (1 + ZZ * PMCTparas.mctDEstopFactor);
            dTmp := PMCTparas.CalcDE(PIt3Dex, PMCTparas);
            RLastStepWidth := - dT1;
          end;

          if (PIt3Dex.ItResultI < PMCTparas.iMinIt) or
             ((PIt3Dex.ItResultI < PMCTparas.MaxItsResult) and (dTmp >= PMCTparas.msDEstop)) then    //##### next step ######
          begin
            RLastDE := dTmp;

            dTmp := dTmp * PMCTparas.sZstepDiv * RSFmul;
            dT1 := MaxCS(PMCTparas.msDEstop, 0.4) * PMCTparas.mctMH04ZSD;
            if dT1 < dTmp then
            begin
              if not bFirstStep then StepCount := StepCount + dT1 / dTmp else StepCount := StepCount + Random;
              dTmp := dT1;
            end
            else StepCount := StepCount + 1;

            if bFirstStep then   {..$Q-  integer overflow check}
            begin
              bFirstStep := False;
              seed := 214013 * seed + 2531011;
              dTmp := ((seed shr 16) and $7FFF) * 0.000030517578125 * dTmp;
            end;

              {  if DEoption = 20 then    //test for dIFS, do not overstep with high DEstop vals, on high fov you have to diff new destop
                begin
                  dT1 := DEstop * (1 + (ZZ + dTmp) * mctDEstopFactor) * 0.9;
                  dTmp := MinCD(dTmp, (RLastDE - dT1) * sZstepDiv);
                end; }

            RLastStepWidth := dTmp;
            ZZ := ZZ + dTmp;
            mAddVecWeight(@PIt3Dex.C1, @MarchVec, dTmp);
            PMCTparas.msDEstop := StartDEstop * (1 + ZZ * PMCTparas.mctDEstopFactor);
                                                 
            dTmp := PMCTparas.CalcDE(PIt3Dex, PMCTparas);

            if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;

            if RLastDE > dTmp + s1em30 then
            begin
              dT1 := RLastStepWidth / (RLastDE - dTmp);
              if dT1 < 1 then
                RSFmul := maxCS(s05, dT1)
              else
                RSFmul := 1;
            end
            else RSFmul := 1;
          end
          else     // ##### set found #####
          begin
            DElimited := PIt3Dex.ItResultI < PMCTparas.MaxItsResult;
            if PMCTparas.iDEAddSteps > 0 then
            begin
              if DElimited then
                RMdoBinSearch(PMCTparas, dTmp, RLastStepWidth{, RLastDE})
              else
                RMdoBinSearchIt(PMCTparas, ZZ);
            end;
            if DElimited then RMresult := 1 else RMresult := 2;
            mCopyVec(@PIt3Dex.C1, @ActPos);
            Exit;
          end;
        until (ZZ > MaxRayLength) or PMCTparas.PCalcThreadStats.pLBcalcStop^;  //or ActZpos' < 0? (frontclipping)
        RMresult := 0;
      end;
    end;
end;

procedure CalcHSsoft(PMCT: PMCTparameter; hsPsiLight: TPsiLight5; y: Integer);
var itmp, iHSnr: Integer;
    bisPosLight: LongBool;
    RLastDE, RLastStepWidth, RStepFactorDiff, sTmp, ZZ2mul, ZZ, ZRsoft, ZRSmul: Single;
    dTmp, dT1, dMaxL, MaxLHS, ZZ2: Double;
    HSVec, NVec, IC: TVec3D;
procedure HSminLengthToCutPlane(HVec: TPVec3D; var dLength: Double);
var dT: Double;
begin
    with PMCT^ do
    begin
      if ((iCutOptions and 1) <> 0) and (Abs(HVec[0]) > 1e-20) then
      begin
        dT := (pIt3Dext.C1 - dCOX) / HVec[0];
        if (dT > 0) and (dT < dLength) then dLength := dT;
      end;
      if ((iCutOptions and 2) <> 0) and (Abs(HVec[1]) > 1e-20) then
      begin
        dT := (pIt3Dext.C2 - dCOY) / HVec[1];
        if (dT > 0) and (dT < dLength) then dLength := dT;
      end;
      if ((iCutOptions and 4) <> 0) and (Abs(HVec[2]) > 1e-20) then
      begin
        dT := (pIt3Dext.C3 - dCOZ) / HVec[2];
        if (dT > 0) and (dT < dLength) then dLength := dT;
      end;
    end;
end;
begin
    with PMCT^ do
    begin
      ZZ := Abs(mZZ);
      iHSnr := 0;
      for itmp := 0 to 5 do if (calcHardShadow and (4 shl itmp)) <> 0 then
        iHSnr := PLVals.SortTab[itmp];
      mCopyVec(@HSVec, @HSvecs[iHSnr]);
      bisPosLight := (PLVals.iLightPos[iHSnr] and 1) <> 0;
      if bisPosLight then
      begin                        //poslight scale with distance...
        if (PLVals.iLightPos[iHSnr] and 6) = 2 then ZRSmul := 70 / SoftShadowRadius
                                               else ZRSmul := 40 / SoftShadowRadius;
      end
      else ZRSmul := 80 / SoftShadowRadius; //+ scale with y amount
      hsPsiLight.Shadow := hsPsiLight.Shadow or $FC00;
      MaxLHS := (iMandWidth + y) * 0.6 * (1 + s05 * MinCD(ZZ, Zend * 0.4) * Clamp0D(FOVy) / iMandHeight) * sHSmaxLengthMultiplier;
      ZZ2 := mZZ;
      msDEstop := DEstop * (1 + ZZ * mctDEstopFactor);
      dMaxL := MaxLHS;
      if bisPosLight then  //calculate LightVec from position
      begin
        HSVec := SubtractVectors(AddSVec2Vec3(@PLVals.PLValigned.LN[iHSnr], @Xmit), @pIt3Dext.C1);
        dTmp := SqrLengthOfVec(HSVec);
        if dTmp > PLVals.sLmaxL[iHSnr] * sHSmaxLengthMultiplier then Exit;
        if dTmp < Sqr(dMaxL * StepWidth) then dMaxL := Sqrt(dTmp) / StepWidth;
        NormaliseVectorTo(-StepWidth, @HSVec);
      end;
      ZZ2mul := -DotOfVectorsNormalize(@HSVec, @mVgradsFOV);
      if iCutOptions <> 0 then HSminLengthToCutPlane(@HSVec, dMaxL);
      if dMaxL > 0 then
      begin
        NVec := MakeDVecFromNormals(hsPsiLight);
        RotateVectorReverse(@NVec, @VGrads);
        if DotOfVectors(@NVec, @HSVec) > 0 then
        begin
          hsPsiLight.Shadow := hsPsiLight.Shadow and $3FF;
          Exit;
        end;
        mCopyVec(@IC, @pIt3Dext.C1);
        dT1 := dMaxL;
        ZRsoft := 1;
        RStepFactorDiff := 1;
        dTmp := CalcDE(pIt3Dext, PMCT);
        repeat
          RLastDE := dTmp;
          RLastStepWidth := MinCS(dTmp * sZstepDiv * RStepFactorDiff, MaxCS(msDEstop, 0.4) * mctMH04ZSD);
          dT1 := dT1 - RLastStepWidth;
          mAddVecWeight(@pIt3Dext.C1, @HSVec, -RLastStepWidth);
          ZZ2 := ZZ2 + RLastStepWidth * ZZ2mul;
          msDEstop := DEstop * (1 + Abs(ZZ2) * mctDEstopFactor);
          dTmp := CalcDE(pIt3Dext, PMCT);
          ZRsoft := MinCS(ZRsoft, (dTmp - msDEStop) * ZRSmul / (dMaxL - dT1 + s011)
                                       + Sqr(Sqr(Sqr((dMaxL - dT1) / MaxLHS))));    //.. + threshold based on lastDE, cant decrease more than...?
          if (pIt3Dext.ItResultI >= MaxItsResult) or (dTmp < msDEstop) then Break;
          if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;
          if RLastDE > dTmp + 1e-30 then
          begin
            sTmp := RLastStepWidth / (RLastDE - dTmp);
            if sTmp < 1 then
              RStepFactorDiff := maxCS(s05, sTmp)
            else
              RStepFactorDiff := 1;
          end
          else RStepFactorDiff := 1;
        until dT1 < 0;
        hsPsiLight.Shadow := (hsPsiLight.Shadow and $3FF) or (Round(Clamp01S(ZRsoft) * 63.4) shl 10);
        mCopyVec(@pIt3Dext.C1, @IC);
      end;
    end;
end;

procedure CalcHS(PMCT: PMCTparameter; hsPsiLight: TPsiLight5; y: Integer);
var itmp, itmp2: Integer;
    RLastDE, RLastStepWidth, RStepFactorDiff, sTmp, ZZ2mul, ZZ: Single;
    dTmp, dT1, MaxLHS, ZZ2: Double;
    IC, HSVec: TVec3D;
procedure HSminLengthToCutPlane(HVec: TPVec3D; var dLength: Double);
var dT: Double;
begin
    with PMCT^ do
    begin
      if ((iCutOptions and 1) <> 0) and (Abs(HVec[0]) > 1e-20) then
      begin
        dT := (pIt3Dext.C1 - dCOX) / HVec[0];
        if (dT > 0) and (dT < dLength) then dLength := dT;
      end;
      if ((iCutOptions and 2) <> 0) and (Abs(HVec[1]) > 1e-20) then
      begin
        dT := (pIt3Dext.C2 - dCOY) / HVec[1];
        if (dT > 0) and (dT < dLength) then dLength := dT;
      end;
      if ((iCutOptions and 4) <> 0) and (Abs(HVec[2]) > 1e-20) then
      begin
        dT := (pIt3Dext.C3 - dCOZ) / HVec[2];
        if (dT > 0) and (dT < dLength) then dLength := dT;
      end;
    end;
end;
begin
    with PMCT^ do
    begin
      if (CalcHardShadow and 256) <> 0 then
      begin
        CalcHSsoft(PMCT, hsPsiLight, y);
        Exit;
      end;
      ZZ := Abs(mZZ);
      mCopyVec(@IC, @pIt3Dext.C1);
      hsPsiLight.Shadow := hsPsiLight.Shadow and (((calcHardShadow and $FC) shl 8) xor $FFFF);   //Reset all selected HS to 0
      MaxLHS := (iMandWidth + y) * 0.6 * (1 + s05 * MinCD(ZZ, Zend * 0.4) * Clamp0D(FOVy) / iMandHeight) * sHSmaxLengthMultiplier;
      for itmp := 0 to 5 do if (calcHardShadow and (4 shl itmp)) > 0 then
      begin
        itmp2 := PLVals.SortTab[itmp];
        mCopyVec(@pIt3Dext.C1, @IC);
        ZZ2 := mZZ;
        msDEstop := DEstop * (1 + ZZ * mctDEstopFactor);
        dT1 := MaxLHS;
        if (PLVals.iLightPos[itmp2] and 1) <> 0 then  //calculate LightVec from position
        begin
          HSVec := SubtractVectors(AddSVec2Vec3(@PLVals.PLValigned.LN[itmp2], @Xmit), @pIt3Dext.C1);
          dTmp := SqrLengthOfVec(HSVec);
          if dTmp > PLVals.sLmaxL[itmp2] * sHSmaxLengthMultiplier then
          begin
            hsPsiLight.Shadow := hsPsiLight.Shadow or ($400 shl itmp);
            Continue;
          end;
          if dTmp < Sqr(dT1 * StepWidth) then dT1 := Sqrt(dTmp) / StepWidth;
          HSvecs[itmp2] := NormaliseVectorTo(-StepWidth, HSVec);
        end;
        ZZ2mul := -DotOfVectorsNormalize(@HSvecs[itmp2], @mVgradsFOV);
        if iCutOptions <> 0 then HSminLengthToCutPlane(@HSvecs[itmp2], dT1);
        if dT1 > 0 then
        begin
          HSVec := MakeDVecFromNormals(hsPsiLight);
          RotateVectorReverse(@HSVec, @VGrads);
          if DotOfVectors(@HSVec, @HSvecs[itmp2]) > 0 then
          begin
            hsPsiLight.Shadow := hsPsiLight.Shadow or ($400 shl itmp);
            Continue;
          end;
          RStepFactorDiff := 1;
          dTmp := CalcDE(pIt3Dext, PMCT);
          repeat
            RLastDE := dTmp;
            dTmp := MinCS(dTmp * sZstepDiv * RStepFactorDiff, MaxCS(msDEstop, 0.4) * mctMH04ZSD);
            RLastStepWidth := dTmp;
            dT1 := dT1 - dTmp;
            mAddVecWeight(@pIt3Dext.C1, @HSvecs[itmp2], -dTmp);
            ZZ2 := ZZ2 + dTmp * ZZ2mul;
            msDEstop := DEstop * (1 + Abs(ZZ2) * mctDEstopFactor);
            dTmp := CalcDE(pIt3Dext, PMCT);
            if (pIt3Dext.ItResultI >= MaxItsResult) or (dTmp < msDEstop) then Break;
            if dTmp > RLastDE + RLastStepWidth then dTmp := RLastDE + RLastStepWidth;
            if RLastDE > dTmp + 1e-30 then
            begin
              sTmp := RLastStepWidth / (RLastDE - dTmp);
              if sTmp < 1 then
                RStepFactorDiff := maxCS(s05, sTmp)
              else
                RStepFactorDiff := 1;
            end
            else RStepFactorDiff := 1;
          until dT1 < 0;
          if dT1 > 0 then hsPsiLight.Shadow := hsPsiLight.Shadow or ($400 shl itmp);
        end;
      end;
      mCopyVec(@pIt3Dext.C1, @IC);
    end;
end;
                     //0..1
{function GetMapPixelSV(x, y: Single; LMap: TPLightMap): TSVec;
var xf, yf, ipos: Integer;
    xs, ys, xx, yy: Double;
    cv: T4Cardinal;
    sv: T4SVec;
begin
    with LMap^ do
    if LMWidth > 0 then
    begin
      xx := MinMaxCS(0, x * sLMXfactor, sLMXfactor);
      yy := MinMaxCS(0, y * sLMYfactor, sLMYfactor);
      xf := Min(LMWidth - 1, Trunc(xx));
      yf := Min(LMHeight - 1, Trunc(yy));
      xs := xx - xf;    //lin
      ys := (yy - yf) * s1d255;
      yy := s1d255 - ys;
//      xs := xx - xf;      //cos approx:
  //    if xs > 0.5 then xs := 1 - Sqr(1 - xs) * 2 else xs := Sqr(xs) * 2;
   //   ys := yy - yf;
    //  if ys > 0.5 then ys := (1 - Sqr(1 - ys) * 2) * s1d255
      //            else ys := Sqr(ys) * 2 * s1d255;
     // yy := s1d255 - ys;  
      ipos := iLMstart + iLMYinc * yf + xf * 4;
      cv[0] := PCardinal(ipos)^;
      cv[1] := PCardinal(ipos + 4)^;
      cv[2] := PCardinal(ipos + iLMYinc)^;
      cv[3] := PCardinal(ipos + iLMYinc + 4)^;
      sv := ColToSVecFlipRBc4(cv);
      Result[0] := (sv[0][0] + (sv[1][0] - sv[0][0]) * xs) * yy + (sv[2][0] + (sv[3][0] - sv[2][0]) * xs) * ys;
      Result[1] := (sv[0][1] + (sv[1][1] - sv[0][1]) * xs) * yy + (sv[2][1] + (sv[3][1] - sv[2][1]) * xs) * ys;
      Result[2] := (sv[0][2] + (sv[1][2] - sv[0][2]) * xs) * yy + (sv[2][2] + (sv[3][2] - sv[2][2]) * xs) * ys;
    end;
end;  }

{                           // eax             edx             ecx
function GetMapPixelSphere(PVec3D: TPVec3D; MapNr: Integer): TVec3D; //linear ipol
var n: Integer;
    dv: TVec3D;
    xf, yf, ipos: Integer;
    x, y, xs, ys, xx, yy: Double;//Single;
    cv: T4Cardinal;
    sv: T4SVec;
begin
    n := 0;
    repeat
      if CalcMaps[n].LMnumber = MapNr then Break else
      if CalcMaps[n].LMnumber = 0 then
      if LoadLightMapNr(MapNr, @CalcMaps[n]) then Break;
      Inc(n);
    until n > 2;
    if n > 2 then
    begin
      ClearDVec(Result);
      Exit;
    end;
    dv := NormaliseVector(PVec3D);
    x := ArcTan2(dv[0], dv[1]) * MPi05d + s05;
    y := s05 - ArcSin(dv[2]) * Pi1d;
    with CalcMaps[n] do
    if LMWidth > 0 then
    begin
      xx := MinMaxCS(0, x * sLMXfactor, sLMXfactor);
      yy := MinMaxCS(0, y * sLMYfactor, sLMYfactor);
      xf := Trunc(xx);
      xs := xx - xf;
      if xf = LMWidth then xf := 0;
      yf := Trunc(yy);
      if yf >= LMHeight - 1 then begin yf := LMHeight - 1; ys := 0; end else
        ys := yy - yf;
    {  xs := xx - xf;    //lin
      ys := (yy - yf) * s1d255;
      yy := s1d255 - ys;

  {    xs := 0.5 - 0.5 * Cos(Pi * (xx - xf));    //test cos interpol:
      ys := (0.5 - 0.5 * Cos(Pi * (yy - yf))) * s1d255;
      yy := s1d255 - ys;   }

       //cos approx:
{      if xs > 0.5 then xs := 1 - Sqr(1 - xs) * 2 else xs := Sqr(xs) * 2;
      if ys > 0.5 then ys := (1 - Sqr(1 - ys) * 2) * s1d255
                  else ys := Sqr(ys) * 2 * s1d255;
      yy := s1d255 - ys;  

      ipos := iLMstart + iLMYinc * yf + xf * 4;
      cv[0] := PCardinal(ipos)^;
      cv[1] := PCardinal(ipos + 4)^;
      cv[2] := PCardinal(ipos + iLMYinc)^;
      cv[3] := PCardinal(ipos + iLMYinc + 4)^;
      sv := ColToSVecFlipRBc4(cv);
      Result[0] := (sv[0][0] + (sv[1][0] - sv[0][0]) * xs) * yy + (sv[2][0] + (sv[3][0] - sv[2][0]) * xs) * ys;
      Result[1] := (sv[0][1] + (sv[1][1] - sv[0][1]) * xs) * yy + (sv[2][1] + (sv[3][1] - sv[2][1]) * xs) * ys;
      Result[2] := (sv[0][2] + (sv[1][2] - sv[0][2]) * xs) * yy + (sv[2][2] + (sv[3][2] - sv[2][2]) * xs) * ys;
    end
    else ClearDVec(Result);
end;  }

{                                 // eax             edx             ecx
function GetMapPixelSphereBicubic(PVec3D: TPVec3D; MapNr: Integer): TVec3D;
var n: Integer;
    nx1, nx2, nx3: Integer;
    dv: TVec3D;
    xf, yf, ipos: Integer;
    x, y, xs, ys, xx, yy: Double;
    x0, x1, x2, x3, y0, y1, y2, y3: Single;
    cv: T4Cardinal;
    sv, svy: T4SVec;
begin
    n := 0;
    repeat
      if CalcMaps[n].LMnumber = MapNr then Break else
      if CalcMaps[n].LMnumber = 0 then
      if LoadLightMapNr(MapNr, @CalcMaps[n]) then Break;
      Inc(n);
    until n > 2;
    if n > 2 then
    begin
      ClearDVec(Result);
      Exit;
    end;
    dv := NormaliseVector(PVec3D);
    x := ArcTan2(dv[0], dv[1]) * MPi05d + s05;
    y := s05 - ArcSin(dv[2]) * Pi1d;
    with CalcMaps[n] do
    if LMWidth > 0 then
    begin
      xx := MinMaxCS(0, x * sLMXfactor, sLMXfactor);
      yy := MinMaxCS(0, y * sLMYfactor, sLMYfactor);
      xf := Trunc(xx);
      xs := xx - xf;
      yf := Trunc(yy);
      ys := yy - yf;

      x0 := ((-0.8 * xs + 3.2) * (xs + 1) - 6.4) * (xs + 1) + 3.2;
      x1 := (1.2 * xs - 2.2) * Sqr(xs) + 1;
      x2 := (-1.2 * xs - 1) * Sqr(1 - xs) + 1;
      x3 := ((0.8 * xs + 2.4) * (2 - xs) - 6.4) * (2 - xs) + 3.2;
      y0 := ((-0.8 * ys + 3.2) * (ys + 1) - 6.4) * (ys + 1) + 3.2;
      y1 := (1.2 * ys - 2.2) * Sqr(ys) + 1;
      y2 := (-1.2 * ys - 1) * Sqr(1 - ys) + 1;
      y3 := ((0.8 * ys + 2.4) * (2 - ys) - 6.4) * (2 - ys) + 3.2;

      if xf > 0 then nx1 := -4 else nx1 := (LMWidth - 1) * 4;
      if xf < LMWidth - 1 then nx2 := 8 else nx2 := (2 - LMWidth) * 4;
      if xf < LMWidth     then nx3 := 4 else nx3 := (1 - LMWidth) * 4;
      if yf > 0 then Dec(yf) else Inc(yf, LMHeight - 1);
      xf    := iLMstart + xf * 4;
      ipos  := xf + iLMYinc * yf;

      cv[0] := PCardinal(ipos + nx1)^;
      cv[1] := PCardinal(ipos)^;
      cv[2] := PCardinal(ipos + nx3)^;
      cv[3] := PCardinal(ipos + nx2)^;
      sv := ColToSVecFlipRBc4(cv);
      svy[0][0] := sv[0][0] * x0 + sv[1][0] * x1 + sv[2][0] * x2 + sv[3][0] * x3;
      svy[0][1] := sv[0][1] * x0 + sv[1][1] * x1 + sv[2][1] * x2 + sv[3][1] * x3;
      svy[0][2] := sv[0][2] * x0 + sv[1][2] * x1 + sv[2][2] * x2 + sv[3][2] * x3;
      if yf < LMHeight - 1 then
      begin
        Inc(yf);
        Inc(ipos, iLMYinc);
      end else begin
        yf := 0;
        ipos := xf;
      end;
      cv[0] := PCardinal(ipos + nx1)^;
      cv[1] := PCardinal(ipos)^;
      cv[2] := PCardinal(ipos + nx3)^;
      cv[3] := PCardinal(ipos + nx2)^;
      sv := ColToSVecFlipRBc4(cv);
      svy[1][0] := sv[0][0] * x0 + sv[1][0] * x1 + sv[2][0] * x2 + sv[3][0] * x3;
      svy[1][1] := sv[0][1] * x0 + sv[1][1] * x1 + sv[2][1] * x2 + sv[3][1] * x3;
      svy[1][2] := sv[0][2] * x0 + sv[1][2] * x1 + sv[2][2] * x2 + sv[3][2] * x3;
      if yf < LMHeight - 1 then
      begin
        Inc(yf);
        Inc(ipos, iLMYinc);
      end else begin
        yf := 0;
        ipos := xf;
      end;
      cv[0] := PCardinal(ipos + nx1)^;
      cv[1] := PCardinal(ipos)^;
      cv[2] := PCardinal(ipos + nx3)^;
      cv[3] := PCardinal(ipos + nx2)^;
      sv := ColToSVecFlipRBc4(cv);
      svy[2][0] := sv[0][0] * x0 + sv[1][0] * x1 + sv[2][0] * x2 + sv[3][0] * x3;
      svy[2][1] := sv[0][1] * x0 + sv[1][1] * x1 + sv[2][1] * x2 + sv[3][1] * x3;
      svy[2][2] := sv[0][2] * x0 + sv[1][2] * x1 + sv[2][2] * x2 + sv[3][2] * x3;
      if yf < LMHeight - 1 then Inc(ipos, iLMYinc) else ipos := xf;
      cv[0] := PCardinal(ipos + nx1)^;
      cv[1] := PCardinal(ipos)^;
      cv[2] := PCardinal(ipos + nx3)^;
      cv[3] := PCardinal(ipos + nx2)^;
      sv := ColToSVecFlipRBc4(cv);
      svy[3][0] := sv[0][0] * x0 + sv[1][0] * x1 + sv[2][0] * x2 + sv[3][0] * x3;
      svy[3][1] := sv[0][1] * x0 + sv[1][1] * x1 + sv[2][1] * x2 + sv[3][1] * x3;
      svy[3][2] := sv[0][2] * x0 + sv[1][2] * x1 + sv[2][2] * x2 + sv[3][2] * x3;

      Result[0] := (svy[0][0] * y0 + svy[1][0] * y1 + svy[2][0] * y2 + svy[3][0] * y3) * s1d255;
      Result[1] := (svy[0][1] * y0 + svy[1][1] * y1 + svy[2][1] * y2 + svy[3][1] * y3) * s1d255;
      Result[2] := (svy[0][2] * y0 + svy[1][2] * y1 + svy[2][2] * y2 + svy[3][2] * y3) * s1d255;

    end
    else ClearDVec(Result);
end;  }
//function GetLightMapPixel(const x, y: Single; LM: TPLightMap; bSqr: LongBool; WrapAround: Integer): TSVec;

function SplineIpolMap(x, y: Double; PCalcMap: TPLightMap): TVec3D;  //x,y direct map coords
var nx1, nx2, nx3, xf, yf, ipos, il, im: Integer;
    cv: T4Cardinal;
    xv, yv: TSVec;
    sv: T4SVec;
    svy: T3SVec;
    fCol2SVec: TCol2SVec;
    fCol2SVecPas: TCol2SVecX87;
begin
  //  Result := SVecToDVec(GetLightMapPixel(x / PCalcMap.sLMXfactor, y / PCalcMap.sLMYfactor, PCalcMap, False, 1));
  //  Exit;
    with PCalcMap^ do
    begin
      xf := Trunc(x);
      yf := Trunc(y);
      xv := MakeSplineCoeff(x - xf);
      yv := MakeSplineCoeff(y - yf);

      if iMapType = 1 then im := 6 else im := 4;

      il := (LMWidth + 1) * im;
      if yf > 0 then Dec(yf) else Inc(yf, LMHeight - 1);

      if xf > 0           then nx1 := -im    else nx1 := (LMWidth - 1) * im;
      if xf < LMWidth - 1 then nx2 := im * 2 else nx2 := (2 - LMWidth) * im;
      if xf < LMWidth     then nx3 := im     else nx3 := (1 - LMWidth) * im;

      xf   := iLMstart + xf * im;
      ipos := xf + il * yf;

      cv[0] := ipos + nx1;
      cv[1] := ipos;
      cv[2] := ipos + nx3;
      cv[3] := ipos + nx2;
      if SupportSSE2 then
      begin
        if im = 6 then fCol2SVec := ColToSVecSSE2_16 else fCol2SVec := ColToSVecSSE2;
        fCol2SVec(cv, @xv, @svy[0]);
        if yf < 0 then Inc(yf) else if yf < LMHeight - 1 then
        begin
          Inc(yf);
          Inc(ipos, il);
        end
        else
        begin
          yf := 0;
          ipos := xf;
        end;
        cv[0] := ipos + nx1;
        cv[1] := ipos;
        cv[2] := ipos + nx3;
        cv[3] := ipos + nx2;
        fCol2SVec(cv, @xv, @svy[1]);
        if yf < LMHeight - 1 then
        begin
          Inc(yf);
          Inc(ipos, il);
        end
        else
        begin
          yf := 0;
          ipos := xf;
        end;
        cv[0] := ipos + nx1;
        cv[1] := ipos;
        cv[2] := ipos + nx3;
        cv[3] := ipos + nx2;
        fCol2SVec(cv, @xv, @svy[2]);
        if yf < LMHeight - 1 then Inc(ipos, il) else ipos := xf;
        cv[0] := ipos + nx1;
        cv[1] := ipos;
        cv[2] := ipos + nx3;
        cv[3] := ipos + nx2;
        fCol2SVec(cv, @xv, @sv[0]);
        Result[0] := svy[0][0] * yv[0] + svy[1][0] * yv[1] + svy[2][0] * yv[2] + sv[0][0] * yv[3];
        Result[1] := svy[0][1] * yv[0] + svy[1][1] * yv[1] + svy[2][1] * yv[2] + sv[0][1] * yv[3];
        Result[2] := svy[0][2] * yv[0] + svy[1][2] * yv[1] + svy[2][2] * yv[2] + sv[0][2] * yv[3];
      end            //png alpha on 4?
      else
      begin
        if im = 6 then fCol2SVecPas := ColToSVecFlipRBc416 else fCol2SVecPas := ColToSVecFlipRBc4;
        sv := fCol2SVecPas(cv);
        svy[0][0] := sv[0][0] * xv[0] + sv[1][0] * xv[1] + sv[2][0] * xv[2] + sv[3][0] * xv[3];
        svy[0][1] := sv[0][1] * xv[0] + sv[1][1] * xv[1] + sv[2][1] * xv[2] + sv[3][1] * xv[3];
        svy[0][2] := sv[0][2] * xv[0] + sv[1][2] * xv[1] + sv[2][2] * xv[2] + sv[3][2] * xv[3];
        if yf < 0 then Inc(yf) else if yf < LMHeight - 1 then
        begin
          Inc(yf);
          Inc(ipos, il);
        end
        else
        begin
          yf := 0;
          ipos := xf;
        end;
        cv[0] := ipos + nx1;
        cv[1] := ipos;
        cv[2] := ipos + nx3;
        cv[3] := ipos + nx2;
        sv := fCol2SVecPas(cv);
        svy[1][0] := sv[0][0] * xv[0] + sv[1][0] * xv[1] + sv[2][0] * xv[2] + sv[3][0] * xv[3];
        svy[1][1] := sv[0][1] * xv[0] + sv[1][1] * xv[1] + sv[2][1] * xv[2] + sv[3][1] * xv[3];
        svy[1][2] := sv[0][2] * xv[0] + sv[1][2] * xv[1] + sv[2][2] * xv[2] + sv[3][2] * xv[3];
        if yf < LMHeight - 1 then
        begin
          Inc(yf);
          Inc(ipos, il);
        end
        else
        begin
          yf := 0;
          ipos := xf;
        end;
        cv[0] := ipos + nx1;
        cv[1] := ipos;
        cv[2] := ipos + nx3;
        cv[3] := ipos + nx2;
        sv := fCol2SVecPas(cv);
        svy[2][0] := sv[0][0] * xv[0] + sv[1][0] * xv[1] + sv[2][0] * xv[2] + sv[3][0] * xv[3];
        svy[2][1] := sv[0][1] * xv[0] + sv[1][1] * xv[1] + sv[2][1] * xv[2] + sv[3][1] * xv[3];
        svy[2][2] := sv[0][2] * xv[0] + sv[1][2] * xv[1] + sv[2][2] * xv[2] + sv[3][2] * xv[3];
        if yf < LMHeight - 1 then Inc(ipos, il) else ipos := xf;
        cv[0] := ipos + nx1;
        cv[1] := ipos;
        cv[2] := ipos + nx3;
        cv[3] := ipos + nx2;
        sv := fCol2SVecPas(cv);
        Result[0] := (svy[0][0] * yv[0] + svy[1][0] * yv[1] + svy[2][0] * yv[2] +
                     (sv[0][0] * xv[0] + sv[1][0] * xv[1] + sv[2][0] * xv[2] + sv[3][0] * xv[3]) * yv[3]) * s1d255;
        Result[1] := (svy[0][1] * yv[0] + svy[1][1] * yv[1] + svy[2][1] * yv[2] +
                     (sv[0][1] * xv[0] + sv[1][1] * xv[1] + sv[2][1] * xv[2] + sv[3][1] * xv[3]) * yv[3]) * s1d255;
        Result[2] := (svy[0][2] * yv[0] + svy[1][2] * yv[1] + svy[2][2] * yv[2] +
                     (sv[0][2] * xv[0] + sv[1][2] * xv[1] + sv[2][2] * xv[2] + sv[3][2] * xv[3]) * yv[3]) * s1d255;
      end;
    end;
end;
                                 // eax             edx             ecx
function GetMapPixelSphereSpline(PVec3D: TPVec3D; MapNr: Integer): TVec3D;
var n: Integer;
    dv: TVec3D;
    x, y: Double;
begin                  //4 st slots might be already used by calling formula!!!
    n := 0;
    repeat
      if CalcMaps[n].LMnumber = MapNr then Break else
      if CalcMaps[n].LMnumber = 0 then
      if LoadLightMapNr(MapNr, @CalcMaps[n]) then Break;
      Inc(n);
    until n > 2;
    if n > 2 then
    begin
      MapIsMissing := True;
      ClearDVec(Result);
      Exit;
    end;
    dv := NormaliseVector(PVec3D);  
    x := ArcTan2(dv[0], dv[1]) * MPi05d + s05;
    y := s05 - ArcSinSafe(dv[2]) * Pi1d;
    with CalcMaps[n] do
    begin
      if LMWidth > 0 then
        Result := SplineIpolMap(Min0MaxCD(x * sLMXfactor, sLMXfactor),
                            Min0MaxCD(y * sLMYfactor, sLMYfactor), @CalcMaps[n])
      else ClearDVec(Result);
    end;
end;

function FracA(d: Double): Double;
begin
    if d < 0 then Result := 1 + Frac(d)
             else Result := Frac(d);
end;

{                           // eax             edx             ecx
function GetMapPixelDirectXY(PVec3D: TPVec3D; MapNr: Integer): TVec3D; //Direct pixel coords 0..1 with tiling
var n: Integer;
    xf, yf, ipos: Integer;
    xs, ys, xx, yy: Double;
    cv: T4Cardinal;
    sv: T4SVec;
begin
    n := 0;
    repeat
      if CalcMaps[n].LMnumber = MapNr then Break else
      if CalcMaps[n].LMnumber = 0 then
      if LoadLightMapNr(MapNr, @CalcMaps[n]) then Break;
      Inc(n);
    until n > 2;
    if n > 2 then
    begin
      ClearDVec(Result);
      Exit;
    end;
    with CalcMaps[n] do
    if LMWidth > 0 then
    begin
      xx := FracA(PVec3D^[0]) * sLMXfactor;
      yy := FracA(PVec3D^[1]) * sLMYfactor;
      xf := Trunc(xx);
      xs := xx - xf;
      if xf = LMWidth then xf := 0;
      yf := Trunc(yy);
      ys := yy - yf;
      if yf = LMHeight then yf := 0;
           //cos approx:
      if xs > 0.5 then xs := 1 - Sqr(1 - xs) * 2 else xs := Sqr(xs) * 2;
      if ys > 0.5 then ys := (1 - Sqr(1 - ys) * 2) * s1d255
                  else ys := Sqr(ys) * 2 * s1d255;
      yy := s1d255 - ys;
      ipos := iLMstart + iLMYinc * yf + xf * 4;
      cv[0] := PCardinal(ipos)^;
      cv[1] := PCardinal(ipos + 4)^;
      cv[2] := PCardinal(ipos + iLMYinc)^;
      cv[3] := PCardinal(ipos + iLMYinc + 4)^;
      sv := ColToSVecFlipRBc4(cv);
      Result[0] := (sv[0][0] + (sv[1][0] - sv[0][0]) * xs) * yy + (sv[2][0] + (sv[3][0] - sv[2][0]) * xs) * ys;
      Result[1] := (sv[0][1] + (sv[1][1] - sv[0][1]) * xs) * yy + (sv[2][1] + (sv[3][1] - sv[2][1]) * xs) * ys;
      Result[2] := (sv[0][2] + (sv[1][2] - sv[0][2]) * xs) * yy + (sv[2][2] + (sv[3][2] - sv[2][2]) * xs) * ys;
    end
    else ClearDVec(Result);
end;   }

                                 // eax             edx             ecx
function GetMapPixelDirectXYspline(PVec3D: TPVec3D; MapNr: Integer): TVec3D; //Direct pixel coords 0..1 with tiling
var n: Integer;
    x, y: Double;
begin
    n := 0;
    repeat
      if CalcMaps[n].LMnumber = MapNr then Break else
      if CalcMaps[n].LMnumber = 0 then
      if LoadLightMapNr(MapNr, @CalcMaps[n]) then Break;
      Inc(n);
    until n > 2;
    if n > 2 then
    begin
      MapIsMissing := True;
      ClearDVec(Result);
      Exit;
    end;
    with CalcMaps[n] do
    if LMWidth > 0 then
    begin
      x := FracA(PVec3D^[0]) * sLMXfactor;
      y := FracA(PVec3D^[1]) * sLMYfactor;
      Result := SplineIpolMap(x, y, @CalcMaps[n]);
    end
    else ClearDVec(Result);
end;

procedure IniIt3D(PMCT: PMCTparameter; It3Dex: TPIteration3Dext);
begin
    with PMCT^ do
    begin
      It3Dex.J4 := dJUw;
      It3Dex.Ju4 := dJUw;
      // UGLY
      FastMove(dJUx, It3Dex.J1, 168 {+ SizeOf(Integer) * (MAX_FORMULA_COUNT- 6)
                                    + SizeOf(Integer) * (MAX_FORMULA_COUNT-6)
                                    + SizeOf(ThybridIteration2) * (MAX_FORMULA_COUNT - 6)
                                    + SizeOf(Single) * (MAX_FORMULA_COUNT - 6)});

     It3Dex.CalcSIT := bCalcSIT;
     It3Dex.bFree := bFree;
     It3Dex.EndTo := wEndTo;
     It3Dex.DoJulia := bDoJulia;
     It3Dex.LNRStop :=dLNRStop;
     It3Dex.DEoption := DEoption;
     It3Dex.iRepeatFrom := RepeatFrom1;
     It3Dex.iStartFrom := StartFrom1;

      FastMove(dJUx, It3Dex.Ju1, 24);
      FastMove(Smatrix4d, It3Dex.Smatrix4, 64);
      FastMove(nHybrid, It3Dex.nHybrid, SizeOf(Integer) * MAX_FORMULA_COUNT);
      FastMove(fHPVar, It3Dex.fHPVar, SizeOf(Pointer) * MAX_FORMULA_COUNT);
      FastMove(fHybrid, It3Dex.fHybrid, SizeOf(ThybridIteration2) * MAX_FORMULA_COUNT);
      FastMove(fHln, It3Dex.fHln, SizeOf(Single) * MAX_FORMULA_COUNT);
      FastMove(pInitialization, It3Dex.pInitialization, SizeOf(TFormulaInitialization) * MAX_FORMULA_COUNT);
      if DEoption = 20 then It3Dex.RStopD := -1e10;
      It3Dex.PMapFunc := GetMapPixelSphereSpline;
      It3Dex.PMapFunc2 := GetMapPixelDirectXYspline;
      It3Dex.Deriv1 := 1;
      pIt3Dext := It3Dex;
    end;
end;
{  it3dext:
    CalcSIT:    ByteBool;   //+148   Bool + more options
    RepeatFrom1:Byte;       //+149
    EndTo:      Word;       //+150
    ..
    iRepeatFrom: Word;      //+188
    iStartFrom: Word;       //+190
    OTrap:      Double;     //+192    calced by m3d, minimum vector length in dIFS
    VaryScale:  Double;     //+200    to use in vary by its or in dIFS as absScale
    bFirstIt:   Integer;    //+208    used also as iteration count, is set to 0 on it-start
    bTmp:       Integer;    //+212    (used for formula count), dIFS: minDE iteration
    Dfree1:     Double;     //+216    OTrap coloring in dIFS: formula can store a value 0..8 (*4096=15bit)
  mct:
    bRepeatFrom1:     Byte;       //+149
    wEndTo:           Word;       //+150
    bDoJulia:         LongBool;   //+152
    dLNRStop:         Single;     //+156
    DEoption:         Integer;    //+160    RepeatFrom2, EndTo
    fHln:             array[0..5] of Single;  //esi+164
    RepeatFrom:       Word;       //+188
    StartFrom:        Word;
    Smatrix4d:        TSmatrix4;
    pInitialization:  array[0..5] of TFormulaInitialization;

{procedure RegulationUpdate(const ActDE, LastDE, LastStep: Double; var DEmul: Single);
var dTmp: Double;
begin
    if LastDE > ActDE + s1em30 then
    begin
      dTmp := LastStep / (LastDE - ActDE);
      if dTmp < 1 then
        DEmul := MaxCS(0.5, dTmp)
      else
        DEmul := 1;
    end
    else DEmul := 1;
end; }

                        //   eax                 edx                 ebp+8
procedure CalcZposAndRough(siLight: TPsiLight5; mct: PMCTparameter; const ZZ: Double);
{var  itmp: Integer;
begin
    with mct^ do
    begin
      itmp := Round(8388352 - ZcMul * (Sqrt(ZZ * Zcorr + 1) - 1));
      if itmp < 0 then itmp := 0 else
      if itmp > 8388352 then itmp := 8388352;
      PCardinal(@siLight.RoughZposFine)^ := iTmp shl 8;
      if iSmNormals > 0 then
        siLight.RoughZposFine := siLight.RoughZposFine or Round(sRoughness * 255);
    end; }
asm
    push  ebx
    sub   esp, 4
    fld1
    test  byte [ebp + 15], 128  //negative zz clip
    jns   @1
    fldz
    jmp   @2
@1: fld   qword [ebp + 8]
@2: fmul  qword [edx + TMCTparameter.Zcorr]
    fadd  st(0), st(1)
    fsqrt                                      //at fsqrt?   ZZ * Zcorr > 1??    zz=-642!!
    fsubrp                                     //invalid fp operation in critical ipol hybrid
    fmul  qword [edx + TMCTparameter.ZcMul]
    fistp dword [esp]
    mov   ebx, 8388352
    sub   ebx, dword [esp]
    test  ebx, ebx
    jnl   @up1
    xor   ebx, ebx
@up1:
    cmp   ebx, 8388352
    jle   @up2
    mov   ebx, 8388352
@up2:
    shl   ebx, 8
    cmp   byte [edx + TMCTparameter.iSmNormals], 0
    jle   @up3
    fld   dword [edx + TMCTparameter.sRoughness]     
    fmul  s255
    fistp dword [esp]
    or    ebx, [esp]
@up3:
    mov   [eax + 6], ebx
    add   esp, 4
    pop   ebx
end;

procedure DelayCalcPart(ThreadCount: Integer; PCTS: TPCalcThreadStats);
var Tick: Double;
    Event: THandle;
    x, y, Milliseconds: Integer;
begin
    Milliseconds := 300;
    Tick  := getHiQmillis + Milliseconds;
    Event := CreateEvent(nil, False, False, nil);
    try
      while (Milliseconds > 0) and
            (MsgWaitForMultipleObjects(1, Event, False, Milliseconds, QS_ALLINPUT)
             <> WAIT_TIMEOUT) do
      begin
        Application.ProcessMessages;
        if Application.Terminated or PCTS.pLBcalcStop^ then Exit;
        x := 0;
        for y := 1 to ThreadCount do if PCTS.CTrecords[y].isActive > 0 then Inc(x);
        if x = 0 then Milliseconds := 0 else Milliseconds := Round(Tick - getHiQmillis);
        if Milliseconds > 500 then Exit;
     end;
    finally
      CloseHandle(Event);
    end;
end;

initialization

  CalcMaps[0].LMnumber := 0;
  CalcMaps[1].LMnumber := 0;
  CalcMaps[2].LMnumber := 0;

end.
