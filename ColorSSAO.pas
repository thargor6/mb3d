unit ColorSSAO;

interface

uses
  Classes, TypeDefinitions, Windows;

type
  TColorSSAOcalc = class(TThread)
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;
  TColorSSAOcalcPano = class(TThread)
  private
  public
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;
  TCalcAmbLightT = class(TThread)
  private
  public
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;

procedure FirstATlevelCAO(PIA: TPCardinalArray; PsiLight: TPsiLight5; Leng: Integer);
procedure NextATlevelCAO(PIA: TPCardinalArray; Wid, Hei, Step: Integer);
function CalcCSSAOT(Header: TPMandHeader11; PsiLight: TPsiLight5;
         PCTS: TPCalcThreadStats; PATlevel: TPATlevel): Boolean;

var ATlevelCAO: array of Cardinal;      //of record Cardinal (Z);  TWordRGB = 10 Bytes total for the whole level!?
    ATmaxArrCAO: array of array[0..31] of Smallint;
    ATdirSteps: array[0..31] of array[0..1] of Single;
const d00002441406: Double = 0.0002441406;

implementation

uses Math, Mand, Math3D, DivUtils, ImageProcess, SysUtils, Forms;

procedure DelayATRet(ThreadCount: Integer; PCTS: TPCalcThreadStats);
var Tick: Double;
    x, y, Milliseconds: Integer;
begin
    Milliseconds := 300;
    Tick  := getHiQmillis + Milliseconds;
    while (Milliseconds > 0) and
          (MsgWaitForMultipleObjects(0, Pointer(nil)^, False, Milliseconds, QS_ALLINPUT)
           <> WAIT_TIMEOUT) do
    begin
      Application.ProcessMessages;
      if Application.Terminated or PCTS.pLBcalcStop^ then Exit;
      x := 0;
      for y := 1 to ThreadCount do if PCTS.CTrecords[y].isActive > 0 then Inc(x);
      if x = 0 then Milliseconds := 0 else Milliseconds := Round(Tick - getHiQmillis);
      if Milliseconds > 500 then Exit;
    end;
end;

function CalcAmbLightT(Header: TPMandHeader11; PsiLight: TPsiLight5;
        PCTS: TPCalcThreadStats; PATlevel: TPATlevel): Boolean;
var x, y, ymin, MWidth, MHeight, ThreadCount, RowCount: Integer;
    ASCparameter: TASCparameter;
    Zcorr, ZcMul, ZZstmitDif: Double;
 //   pc: PCardinal;
    ascThread: array of TCalcAmbLightT;
begin
    MWidth := Header.Width;
    MHeight := Header.Height;
    Result := False;
    CalcPPZvals(Header^, Zcorr, ZcMul, ZZstmitDif);
    ASCparameter.aZScaleFactor := (Sqr(256 / ZcMul + 1) - 1) / Zcorr;
    ASCparameter.aPsiLight     := PsiLight;
    ASCparameter.aZRThreshold  := Header.sAmbShadowThreshold;
    try
      ThreadCount := Min(Mand3DForm.UpDown3.Position, MHeight);
      SetLength(ascThread, ThreadCount);
      ASCparameter.aWidth    := MWidth;
      ASCparameter.aHeight   := MHeight;
      ASCparameter.aPCTS     := PCTS;
      ASCparameter.PATlevel  := @ATlevelCAO[0];
      ASCparameter.PATmaxArr := @ATmaxArrCAO;
      ASCparameter.aYBlockStart := 0;
      ASCparameter.aRcount := Header.SSAORcount;
      Result := True;
      PCTS.cCalcTime := GetTickCount;
      for x := 0 to ThreadCount - 1 do
      begin
        ASCparameter.aYstep    := ThreadCount;
        ASCparameter.aYStart   := ASCparameter.aYBlockStart + x;
        ASCparameter.aYEnd     := Min(MHeight, ASCparameter.aYBlockStart + RowCount) - 1;
        ASCparameter.aThreadID := x + 1;
        try
          ascThread[x]                 := TCalcAmbLightT.Create(True);
          ascThread[x].FreeOnTerminate := True;
          ascThread[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
          ascThread[x].ASCpar          := ASCparameter;
          PCTS.CThandles[x + 1] := ascThread[x];
          PCTS.CTrecords[x + 1].iActualYpos := 0;
          PCTS.CTrecords[x + 1].iActualXpos := 0;
          PCTS.CTrecords[x + 1].isActive    := 1;
        except
          ThreadCount := x;
          for y := 0 to ThreadCount - 1 do
            ascThread[y].ASCpar.aYstep := ThreadCount;
        end;
      end;
      PCTS.HandleType := 1;
      PCTS.iTotalThreadCount := ThreadCount;
      for x := 0 to ThreadCount - 1 do ascThread[x].Start;
      Result := Result and (ThreadCount > 0);
      repeat
        DelayATRet(ThreadCount, PCTS);
        x := 0;
        ymin := 999999;
        for y := 1 to ThreadCount do
        begin
          if PCTS.CTrecords[y].isActive > 0 then Inc(x);
          ymin := Min(ymin, PCTS.CTrecords[y].iActualYpos);
        end;
        Mand3DForm.ProgressBar1.Position := ymin;
      until (x = 0) or PCTS.pLBcalcStop^;
    except
      Result := False;
      Mand3DForm.OutMessage('Ambient light calculation aborted.');
    end;
end;

procedure TCalcAmbLightT.Execute;
var x, y, x2, y2: Integer;
    MWidth, MHeight, iDir, sc, zp: Integer;
    PATL: PIntegerArray;
    st, sx, sy: Single;
    PsiLightW: PWord;
 //   psi2: PSmallInt;
    iMaxRad: Integer;
    pint: PInteger;
    sv: TSVec;
    ds, dc: Double;
//label lab1, lab2, lab3, lab4;
begin
    try
      pint := @ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos;
      MWidth := ASCpar.aWidth;
      MHeight := ASCpar.aHeight;
    //  sit := ASCpar.aZScaleFactor / 22000.0 * 4096;
      iMaxRad := Round(Sqrt(Sqr(MWidth) + Sqr(MHeight)) * 0.3);
      y := ASCpar.aYStart;
      while y <= ASCpar.aYend do
      begin
        pint^ := y;
        PsiLightW := PWord(Integer(ASCpar.aPsiLight) + 6); //@RoughZposfine
    //    apos := (y - ASCpar.aYBlockStart) * MWidth;
        Inc(PsiLightW, y * MWidth * 9);
        x := 0;
        while x < MWidth do
        begin
          begin
            if (PCardinal(PsiLightW)^ and $80000000) = 0 then
            begin
              PATL := PIntegerArray(ASCpar.PATlevel);
              zp := (PCardinal(PsiLightW)^ and $FFFFFF00) shr 1;
              ClearSVec(sv);
              //normal
              for iDir := 0 to 31 do
              begin
                SinCosD(iDir / 16 * Pi, ds, dc);
                sx := x + ds;
                sy := y + dc;
                sc := 0;
                repeat
                  x2 := Round(sx);   //+random
                  y2 := Round(sy);
                  if (x2 < 0) or (x2 >= MWidth) or (y2 < 0) or (y2 >= MHeight) then
                  begin
             //       st := (PATL^[y2 * MWidth + x2] - zp);
                    //dotprod of normals
              //      it := Round(st * sit / (sZRT + Abs(st)));
                 //   if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;

                    sx := x + ds;
                    sy := y + dc;
                    Inc(sc);
                  end
                  else sc := iMaxRad;
                until sc >= iMaxRad;
              end;
        //      if psi2^ > -32768 then st := st + ArcTan(psi2^ * d00002441406);
       //       Inc(psi2);
        //      PWord(Integer(PsiLightW) + 6)^ := Round(Min0MaxCS(st * sMul, 16383));
            end;
            Inc(PsiLightW, 9);
            Inc(x);
        //    Inc(apos);
          end;
          if ASCpar.aPCTS.pLBcalcStop^ then Break;
        end;
        if ASCpar.aPCTS.pLBcalcStop^ then Break;
        Inc(y, ASCpar.aYstep);
      end;
    finally
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].isActive := 0;
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos := ASCpar.aHeight - 1;
      PostMessage(ASCpar.aPCTS.pMessageHwnd, WM_ThreadReady, 0, 1);
    end;
end;

function CalcCSSAOT(Header: TPMandHeader11; PsiLight: TPsiLight5;
        PCTS: TPCalcThreadStats; PATlevel: TPATlevel): Boolean;
var x, y, MWidth, MHeight, ThreadCount, ymin, RowCount: Integer;
    IsPano: LongBool;
    ASCparameter: TASCparameter;
    Zcorr, ZcMul, ZZstmitDif: Double;
    pc: PCardinal;
    ascThread: array of TColorSSAOcalc;
    ascThreadPano: array of TColorSSAOcalcPano;
begin
    MWidth := Header.Width;
    MHeight := Header.Height;
    Result := False;
    IsPano := Header.bPlanarOptic = 2;
    CalcPPZvals(Header^, Zcorr, ZcMul, ZZstmitDif);
    ASCparameter.aZScaleFactor := (Sqr(256 / ZcMul + 1) - 1) / Zcorr;
    ASCparameter.aPsiLight     := PsiLight;
    ASCparameter.aZRThreshold  := Header.sAmbShadowThreshold;
    ASCparameter.aBorderMirrorSize := MinCS(Header.bSSAO24BorderMirrorSize * 0.01, 0.9);
    ymin := Round(Sqrt(Sqr(MWidth) + Sqr(MHeight)) * 0.5);
    y := 1;
    x := 5;
    repeat
      Inc(y);
      x := x shl 1;
    until (y = 15) or (x > ymin);
    ASCparameter.aATlevelCount := y;
  try
    SetLength(ATlevelCAO, MWidth * MHeight);
    RowCount := Max(1, Min(PhysikMemAvail div (MWidth * 32 * 4), MHeight));
    ymin := ((MHeight - 1) div RowCount) + 1;  //blockcount
    RowCount := Min(MHeight, (MHeight + ymin) div ymin);
    ymin := 1;
    repeat
      try
        SetLength(ATmaxArrCAO, MWidth * RowCount);
        ymin := 0;
      except
        RowCount := (RowCount div 2) + 1;
      end;
    until ymin = 0;
    ThreadCount := Min(Mand3DForm.UpDown3.Position, RowCount);
    if IsPano then SetLength(ascThreadPano, ThreadCount)
              else SetLength(ascThread, ThreadCount);
    ASCparameter.aWidth    := MWidth;
    ASCparameter.aHeight   := MHeight;
    ASCparameter.aPCTS     := PCTS;
    ASCparameter.PATlevel  := @ATlevelCAO[0];
    ASCparameter.PATmaxArr := @ATmaxArrCAO;
    ASCparameter.aYBlockStart := 0;
    ASCparameter.aRcount := Header.SSAORcount;
    Result := True;
    PCTS.cCalcTime := GetTickCount;
    while ASCparameter.aYBlockStart < MHeight do
    begin
      ASCparameter.aCurrentLevel := 1; //level of wavelet
      FirstATlevelCAO(@ATlevelCAO[0], PsiLight, MWidth * MHeight);
      pc := @ATmaxArrCAO[0][0];
      for x := 0 to 16 * MWidth * RowCount - 1 do
      begin
        pc^ := $80008000;  //-32767,-32767 in smallint (2 at a time)
        Inc(pc);
      end;
      while Result and (ASCparameter.aCurrentLevel <= ASCparameter.aATlevelCount) do
      begin
        for x := 0 to ThreadCount - 1 do
        begin
          ASCparameter.aYstep    := ThreadCount;
          ASCparameter.aYStart   := ASCparameter.aYBlockStart + x;
          ASCparameter.aYEnd     := Min(MHeight, ASCparameter.aYBlockStart + RowCount) - 1;
          ASCparameter.aThreadID := x + 1;
          try
            if IsPano then
            begin
              ascThreadPano[x]                 := TColorSSAOcalcPano.Create(True);
              ascThreadPano[x].FreeOnTerminate := True;
              ascThreadPano[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
              ascThreadPano[x].ASCpar          := ASCparameter;
              PCTS.CThandles[x + 1] := ascThreadPano[x];
            end
            else
            begin
              ascThread[x]                 := TColorSSAOcalc.Create(True);
              ascThread[x].FreeOnTerminate := True;
              ascThread[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
              ascThread[x].ASCpar          := ASCparameter;
              PCTS.CThandles[x + 1] := ascThread[x];
            end;
            PCTS.CTrecords[x + 1].iActualYpos := 0;
            PCTS.CTrecords[x + 1].iActualXpos := 0;
            PCTS.CTrecords[x + 1].isActive    := 1;
          except
            ThreadCount := x;
            for y := 0 to ThreadCount - 1 do
            if IsPano then ascThreadPano[y].ASCpar.aYstep := ThreadCount
                      else ascThread[y].ASCpar.aYstep := ThreadCount;
          end;
        end;
        PCTS.HandleType := 1;
        PCTS.iTotalThreadCount := ThreadCount;
        if IsPano then for x := 0 to ThreadCount - 1 do ascThreadPano[x].Start
                  else for x := 0 to ThreadCount - 1 do ascThread[x].Start;
        Result := Result and (ThreadCount > 0);
        //wait for current level to complete
        repeat
          DelayATRet(ThreadCount, PCTS);
          x := 0;
          ymin := 999999;
          for y := 1 to ThreadCount do
          begin
            if PCTS.CTrecords[y].isActive > 0 then Inc(x);
            ymin := Min(ymin, PCTS.CTrecords[y].iActualYpos);
          end;
          Mand3DForm.ProgressBar1.Position := ASCparameter.aYBlockStart +
           (((ymin + MHeight * (ASCparameter.aCurrentLevel - 1)) div ASCparameter.aATlevelCount) * RowCount) div MHeight;
        until (x = 0) or PCTS.pLBcalcStop^;
        if PCTS.pLBcalcStop^ then Break;
        Inc(ASCparameter.aCurrentLevel);
        if ASCparameter.aCurrentLevel <= ASCparameter.aATlevelCount then
          NextATlevelCAO(@ATlevelCAO[0], MWidth, MHeight, 1 shl (ASCparameter.aCurrentLevel - 1));
      end;
      Inc(ASCparameter.aYBlockStart, RowCount);
      if PCTS.pLBcalcStop^ then Break;
    end;
    SetLength(ATlevelCAO, 0);
    SetLength(ATmaxArrCAO, 0);
  except
    Result := False;
    SetLength(ATlevelCAO, 0);
    SetLength(ATmaxArrCAO, 0);
    Mand3DForm.OutMessage('Color SSAO calculation aborted.');
  end;
end;


procedure IniATdirSteps;
var x: Integer;
    s, c: Double;
begin
    for x := 0 to 15 do
    begin
      SinCosD(x * Pi / 8, s, c);
      ATdirSteps[x][0] := s;
      ATdirSteps[x][1] := c;
    end;
end;

procedure FirstATlevelCAO(PIA: TPCardinalArray; PsiLight: TPsiLight5; Leng: Integer);
{var x: Integer;             //  eax                  edx                ecx
begin
    for x := 0 to Leng - 1 do
    begin
      if PsiLight.Zpos < 32768 then   //edx+8
        PIA[x] := (PCardinal(@PsiLight.RoughZposFine)^ and $FFFFFF00) shr 1
      else PIA[x] := 0;
      Inc(PsiLight);
    end;   }
asm
  push esi
  dec  ecx
  js   @@out
  inc  ecx
  add  edx, 8
@@1:
  cmp  word [edx], $8000
  jnb  @@2
  mov  esi, [edx-2]
  and  esi, $ffffff00
  shr  esi, 1
  jmp  @@3
@@2:
  xor  esi, esi
@@3:
  mov  [eax], esi
  add  edx, 18
  add  eax, 4
  dec  ecx
  jnz  @@1
@@out:
  pop  esi
end;

procedure SmoothH(PIA, SA: TPCardinalArray; ya, Step: Integer);
{var x, a, b: Integer;// eax  edx            ecx  ebp+8
begin
    for x := 0 to ya do
    begin
      a := x - Step;
      if a < 0 then a := 0;
      b := x + Step;
      if b > ya then b := ya;
      PIA[x] := (PIA[x] + (SA[a] + PIA[b]) shr 1) shr 1;
    end;    }   //SA[x]             SA[b]
asm
  add  esp, -12
  push ebx
  push esi
  push edi
  mov  [ebp-8], ecx
  mov  ebx, edx
  mov  edi, [ebp+8]
  mov  edx, ecx
  test edx, edx
  jl   @@2
  inc  edx
  mov  [ebp-12], edx
  xor  esi, esi
@@1:
  mov  edx, esi
  sub  edx, edi
  test edx, edx
  jnl  @@3
  xor  edx, edx
@@3:
  mov  ecx, edi
  add  ecx, esi
  cmp  ecx, [ebp-8]
  jle  @@4
  mov  ecx, [ebp-8]
@@4:
  mov  ecx, [ebx+ecx*4]
  add  ecx, [ebx+edx*4]
  shr  ecx, 1
  add  ecx, [eax]
  shr  ecx, 1
  mov  [eax], ecx
  inc  esi
  add  eax, 4
  dec  dword [ebp-12]
  jnz  @@1
@@2:
  pop  edi
  pop  esi
  pop  ebx
  add  esp, 12
end;

procedure SmoothV(PIA, SA: TPCardinalArray; ye, Step, wid: Integer);
{var y, a, b, ya: Integer;// eax  edx       ecx  ebp+12 ebp+8
begin
    ya := 0;
    for y := 0 to ye do
    begin
      a := y - Step;
      if a < 0 then a := 0;
      b := y + Step;
      if b > ye then b := ye;
      PIA[ya] := (SA[y] + (SA[a] + SA[b]) shr 1) shr 1;
      Inc(ya, wid); //PIA[ya]
    end;               }
asm
  add  esp, -12
  push ebx
  push esi
  push edi
  mov  [ebp-8], ecx
  mov  ebx, edx
  mov  edi, [ebp+12]
  mov  edx, ecx
  test edx, edx
  jl   @@2
  inc  edx
  mov  [ebp-12], edx
  xor  esi, esi
@@1:
  mov  edx, esi
  sub  edx, edi
  test edx, edx
  jnl  @@3
  xor  edx, edx
@@3:
  mov  ecx, edi
  add  ecx, esi
  cmp  ecx, [ebp-8]
  jle  @@4
  mov  ecx, [ebp-8]
@@4:
  mov  ecx, [ebx+ecx*4]
  add  ecx, [ebx+edx*4]
  shr  ecx, 1
  add  ecx, [eax]
  shr  ecx, 1
  mov  [eax], ecx
  inc  esi
  add  eax, dword [ebp+8]
  dec  dword [ebp-12]
  jnz  @@1
@@2:
  pop  edi
  pop  esi
  pop  ebx
  add  esp, 12
end;

procedure NextATlevelCAO(PIA: TPCardinalArray; Wid, Hei, Step: Integer);
var x, y, y2: Integer;
    SA: array of Cardinal;
begin
    SetLength(SA, Max(Hei, Wid));
    for y := 0 to Hei - 1 do
    begin
      FastMove(PIA[y * Wid], SA[0], 4 * Wid);
      SmoothH(@PIA[y * Wid], @SA[0], Wid - 1, Step);
    end;
    for x := 0 to Wid - 1 do
    begin
      y2 := x;
      for y := 0 to Hei - 1 do
      begin
        SA[y] := PIA[y2];
        Inc(y2, Wid);
      end;
      SmoothV(@PIA[x], @SA[0], Hei - 1, Step, 4 * Wid);
    end;
end;

procedure MinSI(var SI: SmallInt; var i: Integer);
//begin             //  eax            edx
//  if SI < i then if i > 32767 then SI := 32767 else SI := i;
asm
  movsx ecx, word [eax]
  cmp  ecx, [edx]
  jnl  @@1
  cmp  dword [edx], $7FFF
  jl   @@2
  mov  word [eax], $7FFF
  ret
@@2:
  mov  edx, [edx]
  mov  word [eax], dx
@@1:
end;

function NotOnlyBackGround4(p: Pointer): Integer;
//begin                      // eax
//    Result := (PCardinal(p)^ and PCardinal(Integer(p) + 18)^ and
// PCardinal(Integer(p) + 36)^ and PCardinal(Integer(p) + 54)^) and $80000000;
asm
  mov  edx, [eax]
  and  edx, [eax + 18]
  and  edx, [eax + 36]
  and  edx, [eax + 54]
  and  edx, $80000000
  mov  eax, edx
end;

procedure MakeZP4(p: Pointer; var zp: array of Integer);
{begin             // eax                edx
    zp[0] := ((PCardinal(p)^ and $FFFFFF00) shr 1);
    zp[1] := ((PCardinal(Integer(p) + 18)^ and $FFFFFF00) shr 1);
    zp[2] := ((PCardinal(Integer(p) + 36)^ and $FFFFFF00) shr 1);
    zp[3] := ((PCardinal(Integer(p) + 54)^ and $FFFFFF00) shr 1); }
asm
  mov  ecx, [eax]
  and  ecx, $FFFFFF00
  shr  ecx, 1
  mov  [edx], ecx
  mov  ecx, [eax + 18]
  and  ecx, $FFFFFF00
  shr  ecx, 1
  mov  [edx + 4], ecx
  mov  ecx, [eax + 36]
  and  ecx, $FFFFFF00
  shr  ecx, 1
  mov  [edx + 8], ecx
  mov  ecx, [eax + 54]
  and  ecx, $FFFFFF00
  shr  ecx, 1
  mov  [edx + 12], ecx
end;

procedure TColorSSAOcalc.Execute;
var x, y, x2, y2, apos, iStep: Integer;
    MWidth, MHeight, iDir, StepCount, sc, it, MH2, MW2, WLo, WHi, HLo, HHi: Integer;
    zp: array[0..3] of Integer;
    PATL: PIntegerArray;
    PS: TPSPoint;
    sMinRad, sx, sy, sit: Single;
    st, sZRT, sMul, sMHm1, sMWm1: Single;
    PsiLightW: PWord;
    AngMaxArr: TPAngMaxArrSI;       //Smallint
    bSummUp: LongBool;
    psm, psi2: PSmallInt;
    RMA: array[0..5] of Single;
    iMaxRad: Integer;
    pint: PInteger;
label lab1, lab2, lab3, lab4;
begin
    try
      pint := @ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos;
      AngMaxArr := ASCpar.PATmaxArr;
      if ASCpar.aZRThreshold < 0.01 then ASCpar.aZRThreshold := 0.01;
      bSummUp := ASCpar.aCurrentLevel = ASCpar.aATlevelCount;
      MWidth  := ASCpar.aWidth;
      MHeight := ASCpar.aHeight;
      sMHm1   := MHeight - 1;
      sMWm1   := MWidth - 1;
      MH2 := 2 * (MHeight - 1);
      MW2 := 2 * (MWidth - 1);
      WLo := Round(MWidth * ASCpar.aBorderMirrorSize);
      WHi := MWidth - 1 - WLo;
      HLo := Round(MHeight * ASCpar.aBorderMirrorSize);
      HHi := MHeight - 1 - HLo;
      sit     := ASCpar.aZScaleFactor / 22000.0 * 4096;
      y       := ASCpar.aYStart;
      sZRT := ASCpar.aZRThreshold * 0.7 * 4096 / sit * Sqrt(Sqrt(ASCpar.aATlevelCount / ASCpar.aCurrentLevel));  //Threshold depends on level
      sMul := 1.5 * 32767 / (Pi * 32 * Power(ArcTan(ASCpar.aZRThreshold * 0.6 * Sqrt(Sqrt(ASCpar.aATlevelCount))), 0.9)); //pi->16383..   ArcTan(ASCpar.aZRThreshold * Sqrt(ASCpar.aATlevelCount)) = max angle
      iStep := 1 shl (ASCpar.aCurrentLevel - 1);
      if iStep < 2 then sMinRad := 1
      else sMinRad := 3.25 * iStep;// 3 * + 1.1;
      if iStep < 2 then StepCount := 5 else StepCount := 3;
      iMaxRad := Round(sMinRad + iStep * StepCount + 0.1);
      for x := 0 to StepCount - 1 do RMA[x] := 1 / (sMinRad + x * iStep + 0.1);
      sit := sit * sZRT;
      while y <= ASCpar.aYend do
      begin
        pint^ := y;
        PsiLightW := PWord(Integer(ASCpar.aPsiLight) + 6); //@RoughZposfine
        apos := (y - ASCpar.aYBlockStart) * MWidth;
        Inc(PsiLightW, y * MWidth * 9);
        x := 0;
        while x < MWidth do
        begin
          if (not bSummUp) and (x >= iMaxRad) and (x < MWidth - iMaxRad - 3) then  // 4 at once
          begin
            if NotOnlyBackGround4(PsiLightW) = 0 then
            begin
              PATL := PIntegerArray(ASCpar.PATlevel);
              MakeZP4(PsiLightW, zp);
              PS := @ATdirSteps[0];
              psi2 := @AngMaxArr^[apos][0];
              for iDir := 0 to 31 do
              begin
                sx := x + PS[0] * sMinRad;
                sy := y + PS[1] * sMinRad;
                sc := 0;
   Lab2:        x2 := Round(sx);
                y2 := Round(sy);
                if y2 < 0 then
                begin
                  y2 := -y2;
                  if y2 >= HLo then goto Lab1;
                end
                else if y2 >= MHeight then
                begin
                  y2 := MH2 - y2;
                  if y2 < HHi then goto Lab1;
                end;
                psm := psi2;
                y2 := y2 * MWidth + x2;
                st := (PATL^[y2] - zp[0]) * RMA[sc];
                it := Round(st * sit / (sZRT + Abs(st)));
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                st := (PATL^[y2 + 1] - zp[1]) * RMA[sc];
                it := Round(st * sit / (sZRT + Abs(st)));
                Inc(psm, 32);
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                st := (PATL^[y2 + 2] - zp[2]) * RMA[sc];
                it := Round(st * sit / (sZRT + Abs(st)));
                Inc(psm, 32);
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                st := (PATL^[y2 + 3] - zp[3]) * RMA[sc];
                it := Round(st * sit / (sZRT + Abs(st)));
                Inc(psm, 32);
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                sx := sx + PS[0] * iStep;
                sy := sy + PS[1] * iStep;
                Inc(sc);
                if sc < StepCount then goto Lab2;
    Lab1:       Inc(PS);
                Inc(psi2);
              end;
            end;
            Inc(PsiLightW, 36);
            Inc(x, 4);
            Inc(apos, 4);
          end else begin
            if (PCardinal(PsiLightW)^ and $80000000) = 0 then //or bDoBGshadow
            begin
              PATL := PIntegerArray(ASCpar.PATlevel);
              zp[0] := (PCardinal(PsiLightW)^ and $FFFFFF00) shr 1;
              PS := @ATdirSteps[0];
              psm := @AngMaxArr^[apos][0];
              psi2 := psm;
              for iDir := 0 to 31 do
              begin
                sx := x + PS[0] * sMinRad;
                sy := y + PS[1] * sMinRad;
                sc := 0;
   Lab4:        x2 := Round(sx);
                y2 := Round(sy);
                if x2 < 0 then
                begin
                  x2 := -x2;
                  if x2 >= WLo then goto Lab3;
                end
                else if x2 >= MWidth then
                begin
                  x2 := MW2 - x2;
                  if x2 < WHi then goto Lab3;
                end;
                if y2 < 0 then
                begin
                  y2 := -y2;
                  if y2 >= HLo then goto Lab3;
                end
                else if y2 >= MHeight then
                begin
                  y2 := MH2 - y2;
                  if y2 < HHi then goto Lab3;
                end;
                st := (PATL^[y2 * MWidth + x2] - zp[0]) * RMA[sc];
                it := Round(st * sit / (sZRT + Abs(st)));
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                sx := sx + PS[0] * iStep;
                sy := sy + PS[1] * iStep;
                Inc(sc);
                if sc < StepCount then goto Lab4;
    Lab3:       Inc(PS);
                Inc(psm);
              end;
              if bSummUp then
              begin
                st := 0;
                for x2 := 0 to 31 do
                begin
                  if psi2^ > -32768 then st := st + ArcTan(psi2^ * d00002441406);
                  Inc(psi2);
                end;
                PWord(Integer(PsiLightW) + 6)^ := Round(Min0MaxCS(st * sMul, 16383));
              end;
            end;
            Inc(PsiLightW, 9);
            Inc(x);
            Inc(apos);
          end;
          if ASCpar.aPCTS.pLBcalcStop^ then Break;
        end;
        if ASCpar.aPCTS.pLBcalcStop^ then Break;
        Inc(y, ASCpar.aYstep);
      end;
    finally
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].isActive := 0;
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos := ASCpar.aHeight - 1;
      PostMessage(ASCpar.aPCTS.pMessageHwnd, WM_ThreadReady, 0, 1);
    end;
end;

procedure TColorSSAOcalcPano.Execute;
var x, y, x2, y2, apos, iStep: Integer;
    MWidth, MHeight, iDir, StepCount, sc, it, MH2, MW2, WLo, WHi, HLo, HHi: Integer;
    zp: array[0..3] of Integer;
    PATL: PIntegerArray;
    PS: TPSPoint;
    sMinRad, sx, sy, sit: Single;
    st, sZRT, sMul, sMHm1, sMWm1: Single;
    PsiLightW: PWord;
    AngMaxArr: TPAngMaxArrSI;       //Smallint
    bSummUp: LongBool;
    psm, psi2: PSmallInt;
    RMA: array[0..5] of Single;
    iMaxRad: Integer;
    pint: PInteger;
label lab1, lab2, lab3, lab4;
begin
    try
      pint := @ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos;
      AngMaxArr := ASCpar.PATmaxArr;
      if ASCpar.aZRThreshold < 0.01 then ASCpar.aZRThreshold := 0.01;
      bSummUp := ASCpar.aCurrentLevel = ASCpar.aATlevelCount;
      MWidth  := ASCpar.aWidth;
      MHeight := ASCpar.aHeight;
      sMHm1   := MHeight - 1;
      sMWm1   := MWidth - 1;
      MH2 := 2 * (MHeight - 1);
      MW2 := 2 * (MWidth - 1);
      WLo := Round(MWidth * ASCpar.aBorderMirrorSize);
      WHi := MWidth - 1 - WLo;
      HLo := Round(MHeight * ASCpar.aBorderMirrorSize);
      HHi := MHeight - 1 - HLo;
      sit     := ASCpar.aZScaleFactor / 22000.0 * 4096;
      y       := ASCpar.aYStart;
      sZRT := ASCpar.aZRThreshold * 0.7 * 4096 / sit * Sqrt(Sqrt(ASCpar.aATlevelCount / ASCpar.aCurrentLevel));  //Threshold depends on level
      sMul := 1.5 * 32767 / (Pi * 32 * Power(ArcTan(ASCpar.aZRThreshold * 0.6 * Sqrt(Sqrt(ASCpar.aATlevelCount))), 0.9)); //pi->16383..   ArcTan(ASCpar.aZRThreshold * Sqrt(ASCpar.aATlevelCount)) = max angle
      iStep := 1 shl (ASCpar.aCurrentLevel - 1);
      if iStep < 2 then sMinRad := 1
      else sMinRad := 3.25 * iStep;// 3 * + 1.1;
      if iStep < 2 then StepCount := 5 else StepCount := 3;
      iMaxRad := Round(sMinRad + iStep * StepCount + 0.1);
      for x := 0 to StepCount - 1 do RMA[x] := 1 / (sMinRad + x * iStep + 0.1);
      sit := sit * sZRT;
      while y <= ASCpar.aYend do
      begin
        pint^ := y;
        PsiLightW := PWord(Integer(ASCpar.aPsiLight) + 6); //@RoughZposfine
        apos := (y - ASCpar.aYBlockStart) * MWidth;
        Inc(PsiLightW, y * MWidth * 9);
        x := 0;
        while x < MWidth do
        begin
          if (not bSummUp) and (x >= iMaxRad) and (x < MWidth - iMaxRad - 3) then  // 4 at once
          begin
            if NotOnlyBackGround4(PsiLightW) = 0 then
            begin
              PATL := PIntegerArray(ASCpar.PATlevel);
              MakeZP4(PsiLightW, zp);
              PS := @ATdirSteps[0];
              psi2 := @AngMaxArr^[apos][0];
              for iDir := 0 to 31 do
              begin
                sx := x + PS[0] * sMinRad;
                sy := y + PS[1] * sMinRad;
                sc := 0;
   Lab2:        x2 := Round(sx);
                y2 := Round(sy);
                if y2 < 0 then
                begin
                  y2 := -y2;
                  if y2 >= HLo then goto Lab1;
                end
                else if y2 >= MHeight then
                begin
                  y2 := MH2 - y2;
                  if y2 < HHi then goto Lab1;
                end;
                psm := psi2;
                y2 := y2 * MWidth + x2;
                st := (PATL^[y2] - zp[0]) * RMA[sc];
                it := Round(st * sit / (sZRT + Abs(st)));
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                st := (PATL^[y2 + 1] - zp[1]) * RMA[sc];
                it := Round(st * sit / (sZRT + Abs(st)));
                Inc(psm, 32);
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                st := (PATL^[y2 + 2] - zp[2]) * RMA[sc];
                it := Round(st * sit / (sZRT + Abs(st)));
                Inc(psm, 32);
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                st := (PATL^[y2 + 3] - zp[3]) * RMA[sc];
                it := Round(st * sit / (sZRT + Abs(st)));
                Inc(psm, 32);
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                sx := sx + PS[0] * iStep;
                sy := sy + PS[1] * iStep;
                Inc(sc);
                if sc < StepCount then goto Lab2;
    Lab1:       Inc(PS);
                Inc(psi2);
              end;
            end;
            Inc(PsiLightW, 36);
            Inc(x, 4);
            Inc(apos, 4);
          end else begin
            if (PCardinal(PsiLightW)^ and $80000000) = 0 then //or bDoBGshadow
            begin
              PATL := PIntegerArray(ASCpar.PATlevel);
              zp[0] := (PCardinal(PsiLightW)^ and $FFFFFF00) shr 1;
              PS := @ATdirSteps[0];
              psm := @AngMaxArr^[apos][0];
              psi2 := psm;
              for iDir := 0 to 31 do
              begin
                sx := x + PS[0] * sMinRad;
                sy := y + PS[1] * sMinRad;
                sc := 0;
   Lab4:        x2 := Round(sx);
                y2 := Round(sy);
                if x2 < 0 then
                begin
                  x2 := x2 + MWidth;
                  if x2 < 0 then goto Lab3;
                end
                else if x2 >= MWidth then
                begin
                  x2 := x2 - MWidth;
                  if x2 >= MWidth then goto Lab3;
                end;
                if y2 < 0 then
                begin
                  y2 := -y2;
                  if y2 >= HLo then goto Lab3;
                end
                else if y2 >= MHeight then
                begin
                  y2 := MH2 - y2;
                  if y2 < HHi then goto Lab3;
                end;
                st := (PATL^[y2 * MWidth + x2] - zp[0]) * RMA[sc];
                it := Round(st * sit / (sZRT + Abs(st)));
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                sx := sx + PS[0] * iStep;
                sy := sy + PS[1] * iStep;
                Inc(sc);
                if sc < StepCount then goto Lab4;
    Lab3:       Inc(PS);
                Inc(psm);
              end;
              if bSummUp then
              begin
                st := 0;
                for x2 := 0 to 31 do
                begin
                  if psi2^ > -32768 then st := st + ArcTan(psi2^ * d00002441406);
                  Inc(psi2);
                end;
                PWord(Integer(PsiLightW) + 6)^ := Round(Min0MaxCS(st * sMul, 16383));
              end;
            end;
            Inc(PsiLightW, 9);
            Inc(x);
            Inc(apos);
          end;
          if ASCpar.aPCTS.pLBcalcStop^ then Break;
        end;
        if ASCpar.aPCTS.pLBcalcStop^ then Break;
        Inc(y, ASCpar.aYstep);
      end;
    finally
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].isActive := 0;
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos := ASCpar.aHeight - 1;
      PostMessage(ASCpar.aPCTS.pMessageHwnd, WM_ThreadReady, 0, 1);
    end;
end;


end.
