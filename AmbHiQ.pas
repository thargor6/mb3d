unit AmbHiQ;     //24bit SSAO

interface

uses
  Classes, TypeDefinitions, Windows;

type
  TAmbHiQCalc = class(TThread)
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;
  TAmbHiQCalcPano = class(TThread)
  private
  public
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;
  TAmbHiQCalcT0 = class(TThread)
  private
  public
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;
  TAmbHiQCalcT0pano = class(TThread)
  private
  public
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;
  TAmbHiQCalcR = class(TThread)
  private
  public
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;
  TAmbHiQCalcRpano = class(TThread)
  private
  public
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;
  TAmbHiQCalcRT0 = class(TThread)
  private
  public
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;
  TAmbHiQCalcRT0pano = class(TThread)
  private
  public
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;
  TAmbVideo = class(TThread)
  private
  public
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;


procedure FirstATlevelHiQ(PIA: TPCardinalArray; PsiLight: TPsiLight5; Leng: Integer);
procedure NextATlevelHiQ(PIA: TPCardinalArray; Wid, Hei, Step: Integer);
function CalcAmbShadowTHiQ(Header: TPMandHeader10; PsiLight: TPsiLight5;
        PCTS: TPCalcThreadStats; PATlevel: TPATlevel): Boolean;

var ATlevelHiQ: array of Cardinal;
    ATmaxArrHiQ: TAngMaxArrSI;  // = array of array[0..31] of Smallint;
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

{procedure Delay(Milliseconds: Integer);
var
  Tick: Double;
begin
  Tick  := getHiQmillis + Milliseconds;
  try
    while (Milliseconds > 0) and
          (MsgWaitForMultipleObjects(0, Pointer(nil)^, False, Milliseconds, QS_ALLINPUT)
           <> WAIT_TIMEOUT) do
    begin
      Application.ProcessMessages;
      if Application.Terminated then Exit;
      Milliseconds := Round(Tick - getHiQmillis); //timeGetTime
      if Milliseconds > 5000 then Exit;
    end;
  finally
  end;
end;
}

function CalcAmbShadowTHiQ(Header: TPMandHeader10; PsiLight: TPsiLight5;
        PCTS: TPCalcThreadStats; PATlevel: TPATlevel): Boolean;
var x, y, MWidth, MHeight, ThreadCount, ymin, RowCount, ATi: Integer;
    IsPano: LongBool;
    ASCparameter: TASCparameter;
    Zcorr, ZcMul, ZZstmitDif: Double;
    pc: PCardinal;
    ascThread: array of TAmbHiQCalc;
    ascThreadT0: array of TAmbHiQCalcT0;
    ascThreadR: array of TAmbHiQCalcR;
    ascThreadRT0: array of TAmbHiQCalcRT0;
    ascThreadPano: array of TAmbHiQCalcPano;
    ascThreadT0Pano: array of TAmbHiQCalcT0Pano;
    ascThreadRPano: array of TAmbHiQCalcRPano;
    ascThreadRT0Pano: array of TAmbHiQCalcRT0Pano;
    ascThreadVideo: array of TAmbVideo;
begin
    MWidth := Header.Width;
    MHeight := Header.Height;
    ATi := (Header.bCalcAmbShadowAutomatic shr 1) and 7; //2: Calc 3: CalcT0 4: CalcR 5: CalcRT0  6(->10): SSAOvideo
    Result := False;                                                                           //(6 would be DEAO)
    IsPano := Header.bPlanarOptic = 2;
    if not (ATi in [2,3,4,5,6]) then Exit;
    CalcPPZvals(Header^, Zcorr, ZcMul, ZZstmitDif);
    ASCparameter.aZScaleFactor := (Sqr(256 / ZcMul + 1) - 1) / Zcorr;
    ASCparameter.aPsiLight     := PsiLight;
    ASCparameter.aZRThreshold  := Header.sAmbShadowThreshold;
    ASCparameter.aBorderMirrorSize := MinCS(Header.bSSAO24BorderMirrorSize * 0.01, 0.9);
    ymin := Round(Sqrt(Sqr(MWidth) + Sqr(MHeight)) * 0.5);
   // ATi := 6; //TEST!!!!!!!!
    y := 1;
    x := 5;
    repeat
      Inc(y);
      x := x shl 1;
    until (y = 15) or (x > ymin);
    ASCparameter.aATlevelCount := y;
  try
    if ATi <> 6 then SetLength(ATlevelHiQ, MWidth * MHeight);
    RowCount := Max(1, Min(PhysikMemAvail div (MWidth * 32 * 4), MHeight));
    ymin := ((MHeight - 1) div RowCount) + 1;  //blockcount
    RowCount := Min(MHeight, (MHeight + ymin) div ymin);
    ymin := 1;
    if ATi = 6 then
    begin
      RowCount := MHeight;
      ASCparameter.aATlevelCount := 1;
    end
    else
    repeat
      try
        SetLength(ATmaxArrHiQ, MWidth * RowCount);
        ymin := 0;
      except
        RowCount := (RowCount div 2) + 1;
      end;
    until ymin = 0;
    ThreadCount := Min(Mand3DForm.UpDown3.Position, RowCount);
    if ATi = 6 then Ati := 10 else if IsPano then ATi := ATi + 4;
    case ATi of
      2:  SetLength(ascThread, ThreadCount);
      3:  SetLength(ascThreadT0, ThreadCount);
      4:  SetLength(ascThreadR, ThreadCount);
      5:  SetLength(ascThreadRT0, ThreadCount);
      6:  SetLength(ascThreadPano, ThreadCount);
      7:  SetLength(ascThreadT0Pano, ThreadCount);
      8:  SetLength(ascThreadRPano, ThreadCount);
      9:  SetLength(ascThreadRT0Pano, ThreadCount);
     10:  SetLength(ascThreadVideo, ThreadCount);
    end;
    ASCparameter.aWidth    := MWidth;
    ASCparameter.aHeight   := MHeight;
    ASCparameter.aPCTS     := PCTS;
    ASCparameter.PATlevel  := @ATlevelHiQ[0];
    ASCparameter.PATmaxArr := @ATmaxArrHiQ;
    ASCparameter.aYBlockStart := 0;
    ASCparameter.aRcount := Header.SSAORcount;
    Result := True;
    if ((Header.bCalcAmbShadowAutomatic and 12) <> 8) or (Mand3DForm.SSAORiteration = 1) then
    PCTS.cCalcTime := GetTickCount;

    while ASCparameter.aYBlockStart < MHeight do
    begin
      ASCparameter.aCurrentLevel := 1; //level of wavelet
      if ATi < 10 then
      begin
        FirstATlevelHiQ(@ATlevelHiQ[0], PsiLight, MWidth * MHeight);
        pc := @ATmaxArrHiQ[0][0];
        for x := 0 to 16 * MWidth * RowCount - 1 do
        begin
          pc^ := $80008000;  //-32767,-32767 in smallint (2 at a time)
          Inc(pc);
        end;
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
            case ATi of
            2: begin
                 ascThread[x]                 := TAmbHiQCalc.Create(True);
                 ascThread[x].FreeOnTerminate := True;
                 ascThread[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
                 ascThread[x].ASCpar          := ASCparameter;
                 PCTS.CThandles[x + 1] := ascThread[x];
               end;
            3: begin
                 ascThreadT0[x]                 := TAmbHiQCalcT0.Create(True);
                 ascThreadT0[x].FreeOnTerminate := True;
                 ascThreadT0[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
                 ascThreadT0[x].ASCpar          := ASCparameter;
                 PCTS.CThandles[x + 1] := ascThreadT0[x];
               end;
            4: begin
                 ascThreadR[x]                 := TAmbHiQCalcR.Create(True);
                 ascThreadR[x].FreeOnTerminate := True;
                 ascThreadR[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
                 ascThreadR[x].ASCpar          := ASCparameter;
                 PCTS.CThandles[x + 1] := ascThreadR[x];
               end;
            5: begin
                 ascThreadRT0[x]                 := TAmbHiQCalcRT0.Create(True);
                 ascThreadRT0[x].FreeOnTerminate := True;
                 ascThreadRT0[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
                 ascThreadRT0[x].ASCpar          := ASCparameter;
                 PCTS.CThandles[x + 1] := ascThreadRT0[x];
               end;
            6: begin
                 ascThreadPano[x]                 := TAmbHiQCalcPano.Create(True);
                 ascThreadPano[x].FreeOnTerminate := True;
                 ascThreadPano[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
                 ascThreadPano[x].ASCpar          := ASCparameter;
                 PCTS.CThandles[x + 1] := ascThreadPano[x];
               end;
            7: begin
                 ascThreadT0Pano[x]                 := TAmbHiQCalcT0Pano.Create(True);
                 ascThreadT0Pano[x].FreeOnTerminate := True;
                 ascThreadT0Pano[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
                 ascThreadT0Pano[x].ASCpar          := ASCparameter;
                 PCTS.CThandles[x + 1] := ascThreadT0Pano[x];
               end;
            8: begin
                 ascThreadRPano[x]                 := TAmbHiQCalcRPano.Create(True);
                 ascThreadRPano[x].FreeOnTerminate := True;
                 ascThreadRPano[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
                 ascThreadRPano[x].ASCpar          := ASCparameter;
                 PCTS.CThandles[x + 1] := ascThreadRPano[x];
               end;
            9: begin
                 ascThreadRT0Pano[x]                 := TAmbHiQCalcRT0Pano.Create(True);
                 ascThreadRT0Pano[x].FreeOnTerminate := True;
                 ascThreadRT0Pano[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
                 ascThreadRT0Pano[x].ASCpar          := ASCparameter;
                 PCTS.CThandles[x + 1] := ascThreadRT0Pano[x];
               end;
           10: begin
                 ascThreadVideo[x]                 := TAmbVideo.Create(True);
                 ascThreadVideo[x].FreeOnTerminate := True;
                 ascThreadVideo[x].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
                 ascThreadVideo[x].ASCpar          := ASCparameter;
                 PCTS.CThandles[x + 1] := ascThreadVideo[x];
               end;
            end;
            PCTS.CTrecords[x + 1].iActualYpos := 0;
            PCTS.CTrecords[x + 1].iActualXpos := 0;
            PCTS.CTrecords[x + 1].isActive    := 1;
        //    PCTS.CTprios[x + 1]   := Header.iThreadPriority;
          except
            ThreadCount := x;
            if ThreadCount > 0 then for y := 0 to ThreadCount - 1 do
            case ATi of
              2:  ascThread[y].ASCpar.aYstep := ThreadCount;
              3:  ascThreadT0[y].ASCpar.aYstep := ThreadCount;
              4:  ascThreadR[y].ASCpar.aYstep := ThreadCount;
              5:  ascThreadRT0[y].ASCpar.aYstep := ThreadCount;
              6:  ascThreadPano[y].ASCpar.aYstep := ThreadCount;
              7:  ascThreadT0Pano[y].ASCpar.aYstep := ThreadCount;
              8:  ascThreadRPano[y].ASCpar.aYstep := ThreadCount;
              9:  ascThreadRT0Pano[y].ASCpar.aYstep := ThreadCount;
             10:  ascThreadVideo[y].ASCpar.aYstep := ThreadCount;
            end;
            Break;
          end;
        end;
        PCTS.HandleType := 1;
        PCTS.iTotalThreadCount := ThreadCount;
        case ATi of
          2:  for x := 0 to ThreadCount - 1 do ascThread[x].Start;
          3:  for x := 0 to ThreadCount - 1 do ascThreadT0[x].Start;
          4:  for x := 0 to ThreadCount - 1 do ascThreadR[x].Start;
          5:  for x := 0 to ThreadCount - 1 do ascThreadRT0[x].Start;
          6:  for x := 0 to ThreadCount - 1 do ascThreadPano[x].Start;
          7:  for x := 0 to ThreadCount - 1 do ascThreadT0Pano[x].Start;
          8:  for x := 0 to ThreadCount - 1 do ascThreadRPano[x].Start;
          9:  for x := 0 to ThreadCount - 1 do ascThreadRT0Pano[x].Start;
         10:  for x := 0 to ThreadCount - 1 do ascThreadVideo[x].Start;
        end;
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
          NextATlevelHiQ(@ATlevelHiQ[0], MWidth, MHeight, 1 shl (ASCparameter.aCurrentLevel - 1));
      end;
      Inc(ASCparameter.aYBlockStart, RowCount);
      if PCTS.pLBcalcStop^ then Break;
    end;
    if not PCTS.pLBcalcStop^ then
      Header.iAmbCalcTime := Round(0.01 * Max(0, GetTickCount - PCTS.cCalcTime));
    SetLength(ATlevelHiQ, 0);
    SetLength(ATmaxArrHiQ, 0);
  except
    Result := False;
    SetLength(ATlevelHiQ, 0);
    SetLength(ATmaxArrHiQ, 0);
    Mand3DForm.OutMessage('Ambshadow calculation aborted.');
  end;
end;


procedure IniATdirSteps;
var x: Integer;
    s, c: Double;
begin
    for x := 0 to 31 do
    begin
      SinCosD(x * Pi / 16, s, c);
      ATdirSteps[x][0] := s;
      ATdirSteps[x][1] := c;
    end;
end;

procedure FirstATlevelHiQ(PIA: TPCardinalArray; PsiLight: TPsiLight5; Leng: Integer);
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

procedure NextATlevelHiQ(PIA: TPCardinalArray; Wid, Hei, Step: Integer);
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

procedure TAmbHiQCalc.Execute;
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

procedure TAmbHiQCalcPano.Execute;
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

procedure TAmbHiQCalcT0.Execute;
var x, y, x2, y2, apos, iStep: Integer;
    MWidth, MHeight, iDir, StepCount, sc, it, MH2, MW2, WLo, WHi, HLo, HHi: Integer;
    zp: array[0..3] of Integer;
    PATL: PIntegerArray;
    PS: TPSPoint;
    sMinRad, sx, sy, sit: Single;
    st, sZRT, sMul, sMHm1, sMWm1: Single;
    PsiLightW: PWord;
    AngMaxArr: TPAngMaxArrSI;    //Smallint
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
      MH2 := 2 * (MHeight - 1);
      MW2 := 2 * (MWidth - 1);
      sMHm1 := MHeight - 1;
      sMWm1 := MWidth - 1;
      WLo := Round(MWidth * ASCpar.aBorderMirrorSize);
      WHi := MWidth - 1 - WLo;
      HLo := Round(MHeight * ASCpar.aBorderMirrorSize);
      HHi := MHeight - 1 - HLo;
      sit     := ASCpar.aZScaleFactor / 22000.0 * 4096;
      y       := ASCpar.aYStart;
      sZRT := ASCpar.aZRThreshold {* 0.7} * 4096 / sit * Sqrt(Sqrt(ASCpar.aATlevelCount / ASCpar.aCurrentLevel));  //Threshold depends on level
      sZRT := Sqr(sZRT); 
      sMul := 1.5 * 32767 / (Pi * 32 * ArcTan(ASCpar.aZRThreshold * 0.6 * Sqrt(Sqrt(ASCpar.aATlevelCount)))); //pi->16383..   ArcTan(ASCpar.aZRThreshold * Sqrt(ASCpar.aATlevelCount)) = max angle
      iStep := 1 shl (ASCpar.aCurrentLevel - 1);
      if iStep < 2 then sMinRad := 1 else sMinRad := 3.25 * iStep;// + 1.1;
      if iStep < 2 then StepCount := 5 else StepCount := 3;
      iMaxRad := Round(sMinRad + iStep * StepCount + 0.1);
      for x := 0 to StepCount - 1 do RMA[x] := 1 / (sMinRad + x * iStep + 0.1);
      sit := sit * sZRT;
      while y <= ASCpar.aYend do
      begin
        pint^ := y;
        PsiLightW := PWord(Integer(ASCpar.aPsiLight) + 6); //@RoughZposfine
        apos     := (y - ASCpar.aYBlockStart) * MWidth;
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
                it := Round(st * sit / (st * st + sZRT));
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                st := (PATL^[y2 + 1] - zp[1]) * RMA[sc];
                it := Round(st * sit / (st * st + sZRT));
                Inc(psm, 32);
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                st := (PATL^[y2 + 2] - zp[2]) * RMA[sc];
                it := Round(st * sit / (st * st + sZRT));
                Inc(psm, 32);
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                st := (PATL^[y2 + 3] - zp[3]) * RMA[sc];
                it := Round(st * sit / (st * st + sZRT));
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
            {    st := (PATL^[y2 * MWidth + x2] - zp[0] + ) * RMA[sc];
                threshold := sit / (st * st + sZRT); //tst
                it := Round((st + 1e22) * threshold) - 16384;   }
                st := (PATL^[y2 * MWidth + x2] - zp[0]) * RMA[sc];
                it := Round(st * sit / (st * st + sZRT));  //decreases towards zero, not -32768 !?
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

procedure TAmbHiQCalcT0Pano.Execute;
var x, y, x2, y2, apos, iStep: Integer;
    MWidth, MHeight, iDir, StepCount, sc, it, MH2, MW2, WLo, WHi, HLo, HHi: Integer;
    zp: array[0..3] of Integer;
    PATL: PIntegerArray;
    PS: TPSPoint;
    sMinRad, sx, sy, sit: Single;
    st, sZRT, sMul, sMHm1, sMWm1: Single;
    PsiLightW: PWord;
    AngMaxArr: TPAngMaxArrSI;    //Smallint
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
      MH2 := 2 * (MHeight - 1);
      MW2 := 2 * (MWidth - 1);
      sMHm1 := MHeight - 1;
      sMWm1 := MWidth - 1;
      WLo := Round(MWidth * ASCpar.aBorderMirrorSize);
      WHi := MWidth - 1 - WLo;
      HLo := Round(MHeight * ASCpar.aBorderMirrorSize);
      HHi := MHeight - 1 - HLo;
      sit     := ASCpar.aZScaleFactor / 22000.0 * 4096;
      y       := ASCpar.aYStart;
      sZRT := ASCpar.aZRThreshold {* 0.7} * 4096 / sit * Sqrt(Sqrt(ASCpar.aATlevelCount / ASCpar.aCurrentLevel));  //Threshold depends on level
      sZRT := Sqr(sZRT);
      sMul := 1.5 * 32767 / (Pi * 32 * ArcTan(ASCpar.aZRThreshold * 0.6 * Sqrt(Sqrt(ASCpar.aATlevelCount)))); //pi->16383..   ArcTan(ASCpar.aZRThreshold * Sqrt(ASCpar.aATlevelCount)) = max angle
      iStep := 1 shl (ASCpar.aCurrentLevel - 1);
      if iStep < 2 then sMinRad := 1 else sMinRad := 3.25 * iStep;// + 1.1;
      if iStep < 2 then StepCount := 5 else StepCount := 3;
      iMaxRad := Round(sMinRad + iStep * StepCount + 0.1);
      for x := 0 to StepCount - 1 do RMA[x] := 1 / (sMinRad + x * iStep + 0.1);
      sit := sit * sZRT;
      while y <= ASCpar.aYend do
      begin
        pint^ := y;
        PsiLightW := PWord(Integer(ASCpar.aPsiLight) + 6); //@RoughZposfine
        apos     := (y - ASCpar.aYBlockStart) * MWidth;
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
                it := Round(st * sit / (st * st + sZRT));
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                st := (PATL^[y2 + 1] - zp[1]) * RMA[sc];
                it := Round(st * sit / (st * st + sZRT));
                Inc(psm, 32);
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                st := (PATL^[y2 + 2] - zp[2]) * RMA[sc];
                it := Round(st * sit / (st * st + sZRT));
                Inc(psm, 32);
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
                st := (PATL^[y2 + 3] - zp[3]) * RMA[sc];
                it := Round(st * sit / (st * st + sZRT));
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
                it := Round(st * sit / (st * st + sZRT));  //decreases towards zero, not -32768 !?
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

procedure TAmbHiQCalcR.Execute;
var xy: array[0..1] of Integer;
    x2, y2, apos, iStep, seed, zp, iand, acount: Integer;
    MWidth, MHeight, iDir, StepCount, sc, it, sAbs, imin, MH2, MW2, WLo, WHi, HLo, HHi: Integer;
    sMinRad, ssub, sstep: TSPoint;
    s32767, sm32768, sx, sy, sit, st, sZRT, sMul, RMA: Single;
    PATL: PIntegerArray;
    PS: TPSPoint;
    psm: PSmallInt;
    PsiLightW: PWord;
    AngMaxArr: TPAngMaxArrSI;
    bSummUp: LongBool;
  //  ATdirStepsL: array[0..31] of array[0..1] of Single;
    pint: PInteger;
label Lab1, Lab2, Lab3;
begin
    try
      pint := @ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos;
      AngMaxArr := ASCpar.PATmaxArr;
      if ASCpar.aZRThreshold < 0.01 then ASCpar.aZRThreshold := 0.01;
      bSummUp := ASCpar.aCurrentLevel = ASCpar.aATlevelCount;
      MWidth  := ASCpar.aWidth;
      MHeight := ASCpar.aHeight;
      MH2 := 2 * (MHeight - 1);
      MW2 := 2 * (MWidth - 1);
//      MHd2 := MHeight div 2;
  //    MWd2 := MWidth div 2;
      WLo := Round(MWidth * ASCpar.aBorderMirrorSize);
      WHi := MWidth - 1 - WLo;
      HLo := Round(MHeight * ASCpar.aBorderMirrorSize);
      HHi := MHeight - 1 - HLo;
      sit     := ASCpar.aZScaleFactor / 22000.0 * 4096;
      sZRT := ASCpar.aZRThreshold * 0.7 * 4096 / sit * Sqrt(Sqrt(ASCpar.aATlevelCount / ASCpar.aCurrentLevel));
      sMul := 1.5 * 32767 / (Pi * 32 * Power(ArcTan(ASCpar.aZRThreshold * 0.65 * Sqrt(Sqrt(ASCpar.aATlevelCount))), 0.9)) / ASCpar.aRcount;
      imin := 16383 div ASCpar.aRcount;
      iStep := 1 shl (ASCpar.aCurrentLevel - 1);
      if iStep < 2 then
      begin
        sMinRad[0] := 1;
        StepCount := 5;
      end else begin
        sMinRad[0] := 3.25 * iStep;
        StepCount := 3;          
      end;
      sMinRad[1] := sMinRad[0];
    {  for apos := 0 to 31 do
      begin
        ATdirStepsL[apos][0] := ATdirSteps[apos][0] * iStep;
        ATdirStepsL[apos][1] := ATdirSteps[apos][1] * iStep;
      end;  }
{$IFDEF DEBUG}
{$Q-}
{$R-}
{$ENDIF}
      seed := Round(Random * (ASCpar.aThreadId + 1) * $324594A1 + $24563487);
{$IFDEF DEBUG}
{$Q+}
{$R+}
{$ENDIF}
      iand := iStep - 1;
      ssub[0] := iand * 0.5;
      ssub[1] := ssub[0];
      sstep[0] := iStep;
      sstep[1] := sstep[0];
      s32767  := 32767;
      sm32768 := -32768;
      sAbs := $7FFFFFFF;
      xy[1] := ASCpar.aYStart;
      while xy[1] <= ASCpar.aYend do
      begin
        pint^ := xy[1];
        PsiLightW := PWord(Integer(ASCpar.aPsiLight) + 6); //@RoughZposfine
        apos := (xy[1] - ASCpar.aYBlockStart) * MWidth;
        Inc(PsiLightW, xy[1] * MWidth * 9);
        xy[0] := 0;
        while xy[0] < MWidth do
        begin
          if (PCardinal(PsiLightW)^ and $80000000) = 0 then //or bDoBGshadow
          begin
            PATL := PIntegerArray(ASCpar.PATlevel);
            zp := (PCardinal(PsiLightW)^ and $FFFFFF00) shr 1;
            PS := @ATdirSteps[0]; //L
            psm := @AngMaxArr^[apos][0];
            if SupportSSE then   //13sek ambsh artifacts testfile,  18s with border reflection   16s with BR up to half width/height
            asm                                                                               //~13s with 3 steps
                push  eax
                push  ebx
                push  ecx
                push  edx
                push  esi
                push  edi
                mov   esi, PATL
                mov   edx, psm
                mov   edi, seed
                mov   iDir, 31
                xorps   xmm2, xmm2
                xorps   xmm3, xmm3
                xorps   xmm4, xmm4
                movss   xmm5, sAbs
                xorps   xmm6, xmm6
                xorps   xmm7, xmm7
                movlps  xmm4, ssub     //xmm4 = ssub
                movlps  xmm7, sstep    //xmm7 = sstep
    @foriDir:   mov   eax, PS
                movlps  xmm6, [eax]    //xmm6 = PS[0,1]
                movlps  xmm2, sMinRad
                movaps  xmm1, xmm6
                mulps   xmm1, xmm2
                subps   xmm1, xmm4     //sxy-ssub
                mov   eax, StepCount
                mov   sc, eax
    @while:     imul  edi, $000343FD
                add   edi, $269EC3
                mov   eax, edi
                movaps  xmm0, xmm1
                shr   eax, 10
                CVTSS2SI ecx, xmm0     //x2
                mov   ebx, eax
                and   ebx, iand
                add   ecx, ebx
                shufps  xmm0, xmm0, 1
                shr   eax, 6
                CVTSS2SI ebx, xmm0     //y2
                and   eax, iand
                add   ebx, eax
                push ecx
                mov  eax, ebx
                imul ecx, ecx
                imul eax, eax
                add  eax, ecx
                pop  ecx
                test eax, eax
                jz   @skip
                CVTSI2SS xmm2, eax
                add   ecx, dword [xy]
                add   ebx, dword [xy + 4]
                test  ecx, ecx    //reflection at borders
                jns   @@1
                neg   ecx
                cmp   ecx, WLo
                jge   @endwhile
                jmp   @@2
           @@1: cmp   ecx, MWidth
                jl    @@2
                sub   ecx, MW2
                neg   ecx
                cmp   ecx, WHi
                jl    @endwhile
           @@2: test  ebx, ebx
                jns   @@3
                neg   ebx
                cmp   ebx, HLo
                jge   @endwhile
                jmp   @con
           @@3: cmp   ebx, MHeight
                jl    @con
                sub   ebx, MH2
                neg   ebx
                cmp   ebx, HHi
                jl    @endwhile
          @con: imul  ebx, MWidth
                add   ebx, ecx
                mov   eax, [esi + ebx * 4]  //PATL^[y2 * MWidth + x2]
                sub   eax, zp
                CVTSI2SS xmm0, eax
                RSQRTSS xmm2, xmm2
                mulss   xmm0, xmm2   //st
                movss   xmm3, xmm0   
                andps   xmm0, xmm5
                mulss   xmm3, sit
                addss   xmm0, sZRT
                mulss   xmm3, sZRT
                rcpss   xmm0, xmm0
                mulss   xmm3, xmm0
                minss   xmm3, s32767
                maxss   xmm3, sm32768
                CVTSS2SI eax, xmm3   //it := Round(st * sZRT * sit / (sZRT + Abs(st)) );
                mov   ecx, iDir
                cmp   ax, word [edx + ecx * 2]
                jle   @skip
                mov   word [edx + ecx * 2], ax
      @skip:    movaps xmm3, xmm7   //sstep
                mulps  xmm3, xmm6   //DirXY
                addps  xmm1, xmm3   //sx,sy
  //    @skip:    addps   xmm1, xmm6   //sx,sy
                dec   sc
                jnz   @while
  @endwhile:    add   PS, 8
                dec   iDir
                jns   @foriDir
                mov   seed, edi
                pop   edi
                pop   esi
                pop   edx
                pop   ecx
                pop   ebx
                pop   eax
            end
            else
            begin
              for iDir := 0 to 31 do     //22sek ambsh artifacts testfile    26-27sek with border reflection d2
              begin
                sx := PS[0] * sMinRad[0] - ssub[0];
                sy := PS[1] * sMinRad[0] - ssub[0];
                sc := 0;
{$IFDEF DEBUG}
{$Q-}
{$R-}
{$ENDIF}
         Lab2:  seed := 214013 * seed + 2531011;
{$IFDEF DEBUG}
{$Q+}
{$R+}
{$ENDIF}
                x2 := Round(sx) + ((seed shr 16) and iand);
                y2 := Round(sy) + ((seed shr 10) and iand);
                st := Sqr(x2) + Sqr(y2);
                if st = 0 then goto Lab3;
                x2 := x2 + xy[0];
                y2 := y2 + xy[1];
                if x2 < 0 then
                begin
                  x2 := -x2;
                  if x2 >= WLo then goto Lab1;
                end
                else if x2 >= MWidth then
                begin
                  x2 := MW2 - x2;
                  if x2 < WHi then goto Lab1;
                end;
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
                st := (PATL^[y2 * MWidth + x2] - zp) / Sqrt(st);
                it := Round(st * sZRT * sit / (sZRT + Abs(st)));
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
         Lab3:  sx := sx + PS[0] * sstep[0];
                sy := sy + PS[1] * sstep[0];
                Inc(sc);
                if sc < StepCount then goto lab2;
         Lab1:  Inc(PS);
                Inc(psm);
              end;
            end;
            if bSummUp then
            begin
              psm := @AngMaxArr^[apos][0];
              st := 0;
              for x2 := 0 to 31 do
              begin
                if psm^ > -32768 then st := st + ArcTan(psm^ * d00002441406);
                Inc(psm);
              end;
              Inc(PWord(Integer(PsiLightW) + 6)^, Max(0, Min(imin, Round(st * sMul))));
            end;
          end;
          Inc(PsiLightW, 9);
          Inc(apos);
          Inc(xy[0]);
          if ASCpar.aPCTS.pLBcalcStop^ then Break;
        end;
        if ASCpar.aPCTS.pLBcalcStop^ then Break;
        Inc(xy[1], ASCpar.aYstep);
      end;
    finally
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].isActive := 0;
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos := ASCpar.aHeight - 1;
      PostMessage(ASCpar.aPCTS.pMessageHwnd, WM_ThreadReady, 0, 1);
    end;
end;

procedure TAmbHiQCalcRpano.Execute;
var xy: array[0..1] of Integer;
    x2, y2, apos, iStep, seed, zp, iand, acount: Integer;
    MWidth, MHeight, iDir, StepCount, sc, it, sAbs, imin, MH2, MW2, WLo, WHi, HLo, HHi: Integer;
    sMinRad, ssub, sstep: TSPoint;
    s32767, sm32768, sx, sy, sit, st, sZRT, sMul, RMA: Single;
    PATL: PIntegerArray;
    PS: TPSPoint;
    psm: PSmallInt;
    PsiLightW: PWord;
    AngMaxArr: TPAngMaxArrSI;
    bSummUp: LongBool;
    pint: PInteger;
label Lab1, Lab2, Lab3;
begin
    try
      pint := @ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos;
      AngMaxArr := ASCpar.PATmaxArr;
      if ASCpar.aZRThreshold < 0.01 then ASCpar.aZRThreshold := 0.01;
      bSummUp := ASCpar.aCurrentLevel = ASCpar.aATlevelCount;
      MWidth  := ASCpar.aWidth;
      MHeight := ASCpar.aHeight;
      MH2 := 2 * (MHeight - 1);
      MW2 := 2 * (MWidth - 1);
      WLo := Round(MWidth * ASCpar.aBorderMirrorSize);
      WHi := MWidth - 1 - WLo;
      HLo := Round(MHeight * ASCpar.aBorderMirrorSize);
      HHi := MHeight - 1 - HLo;
      sit     := ASCpar.aZScaleFactor / 22000.0 * 4096;
      sZRT := ASCpar.aZRThreshold * 0.7 * 4096 / sit * Sqrt(Sqrt(ASCpar.aATlevelCount / ASCpar.aCurrentLevel));
      sMul := 1.5 * 32767 / (Pi * 32 * Power(ArcTan(ASCpar.aZRThreshold * 0.65 * Sqrt(Sqrt(ASCpar.aATlevelCount))), 0.9)) / ASCpar.aRcount;
      imin := 16383 div ASCpar.aRcount;
      iStep := 1 shl (ASCpar.aCurrentLevel - 1);
      if iStep < 2 then
      begin
        sMinRad[0] := 1;
        StepCount := 5;
      end else begin
        sMinRad[0] := 3.25 * iStep;
        StepCount := 3;
      end;
      sMinRad[1] := sMinRad[0];
      seed := Round(Random * (ASCpar.aThreadId + 1) * $324594A1 + $24563487);
      iand := iStep - 1;
      ssub[0] := iand * 0.5;
      ssub[1] := ssub[0];
      sstep[0] := iStep;
      sstep[1] := sstep[0];
      s32767  := 32767;
      sm32768 := -32768;
      sAbs := $7FFFFFFF;
      xy[1] := ASCpar.aYStart;
      while xy[1] <= ASCpar.aYend do
      begin
        pint^ := xy[1];
        PsiLightW := PWord(Integer(ASCpar.aPsiLight) + 6); //@RoughZposfine
        apos := (xy[1] - ASCpar.aYBlockStart) * MWidth;
        Inc(PsiLightW, xy[1] * MWidth * 9);
        xy[0] := 0;
        while xy[0] < MWidth do
        begin
          if (PCardinal(PsiLightW)^ and $80000000) = 0 then //or bDoBGshadow
          begin
            PATL := PIntegerArray(ASCpar.PATlevel);
            zp := (PCardinal(PsiLightW)^ and $FFFFFF00) shr 1;
            PS := @ATdirSteps[0]; //L
            psm := @AngMaxArr^[apos][0];
            if SupportSSE then   //13sek ambsh artifacts testfile,  18s with border reflection   16s with BR up to half width/height
            asm                                                                               //~13s with 3 steps
                push  eax
                push  ebx
                push  ecx
                push  edx
                push  esi
                push  edi
                mov   esi, PATL
                mov   edx, psm
                mov   edi, seed
                mov   iDir, 31
                xorps   xmm2, xmm2
                xorps   xmm3, xmm3
                xorps   xmm4, xmm4
                movss   xmm5, sAbs
                xorps   xmm6, xmm6
                xorps   xmm7, xmm7
                movlps  xmm4, ssub     //xmm4 = ssub
                movlps  xmm7, sstep    //xmm7 = sstep
    @foriDir:   mov   eax, PS
                movlps  xmm6, [eax]    //xmm6 = PS[0,1]
                movlps  xmm2, sMinRad
                movaps  xmm1, xmm6
                mulps   xmm1, xmm2
                subps   xmm1, xmm4     //sxy-ssub
                mov   eax, StepCount
                mov   sc, eax
    @while:     imul  edi, $000343FD
                add   edi, $269EC3
                mov   eax, edi
                movaps  xmm0, xmm1
                shr   eax, 10
                CVTSS2SI ecx, xmm0     //x2
                mov   ebx, eax
                and   ebx, iand
                add   ecx, ebx
                shufps  xmm0, xmm0, 1
                shr   eax, 6
                CVTSS2SI ebx, xmm0     //y2
                and   eax, iand
                add   ebx, eax
                push ecx
                mov  eax, ebx
                imul ecx, ecx
                imul eax, eax
                add  eax, ecx
                pop  ecx
                test eax, eax
                jz   @skip
                CVTSI2SS xmm2, eax
                add   ecx, dword [xy]
                add   ebx, dword [xy + 4]
                test ecx, ecx    // reflection at borders
                jns  @@1
                add  ecx, MWidth
                test ecx, ecx
                jns  @@2
                jmp  @endwhile
           @@1: cmp  ecx, MWidth
                jl   @@2
                sub  ecx, MWidth
                cmp  ecx, MWidth
                jnl  @endwhile
           @@2: test  ebx, ebx
                jns   @@3
                neg   ebx
                cmp   ebx, HLo
                jge   @endwhile
                jmp   @con
           @@3: cmp   ebx, MHeight
                jl    @con
                sub   ebx, MH2
                neg   ebx
                cmp   ebx, HHi
                jl    @endwhile
          @con: imul  ebx, MWidth
                add   ebx, ecx
                mov   eax, [esi + ebx * 4]  //PATL^[y2 * MWidth + x2]
                sub   eax, zp
                CVTSI2SS xmm0, eax
                RSQRTSS xmm2, xmm2
                mulss   xmm0, xmm2   //st
                movss   xmm3, xmm0
                andps   xmm0, xmm5
                mulss   xmm3, sit
                addss   xmm0, sZRT
                mulss   xmm3, sZRT
                rcpss   xmm0, xmm0
                mulss   xmm3, xmm0
                minss   xmm3, s32767
                maxss   xmm3, sm32768
                CVTSS2SI eax, xmm3   //it := Round(st * sZRT * sit / (sZRT + Abs(st)) );
                mov   ecx, iDir
                cmp   ax, word [edx + ecx * 2]
                jle   @skip
                mov   word [edx + ecx * 2], ax
      @skip:    movaps xmm3, xmm7   //sstep
                mulps  xmm3, xmm6   //DirXY
                addps  xmm1, xmm3   //sx,sy
                dec   sc
                jnz   @while
  @endwhile:    add   PS, 8
                dec   iDir
                jns   @foriDir
                mov   seed, edi
                pop   edi
                pop   esi
                pop   edx
                pop   ecx
                pop   ebx
                pop   eax
            end
            else
            begin
              for iDir := 0 to 31 do     //22sek ambsh artifacts testfile    26-27sek with border reflection d2
              begin
                sx := PS[0] * sMinRad[0] - ssub[0];
                sy := PS[1] * sMinRad[0] - ssub[0];
                sc := 0;
         Lab2:  seed := 214013 * seed + 2531011;
                x2 := Round(sx) + ((seed shr 16) and iand);
                y2 := Round(sy) + ((seed shr 10) and iand);
                st := Sqr(x2) + Sqr(y2);
                if st = 0 then goto Lab3;
                x2 := x2 + xy[0];
                y2 := y2 + xy[1];
                if x2 < 0 then
                begin
                  x2 := x2 + MWidth;
                  if x2 < 0 then goto Lab1;
                end
                else if x2 >= MWidth then
                begin
                  x2 := x2 - MWidth;
                  if x2 >= MWidth then goto Lab1;
                end;
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
                st := (PATL^[y2 * MWidth + x2] - zp) / Sqrt(st);
                it := Round(st * sZRT * sit / (sZRT + Abs(st)));
                if psm^ < it then if it >= 32767 then psm^ := 32767 else psm^ := it;
         Lab3:  sx := sx + PS[0] * sstep[0];
                sy := sy + PS[1] * sstep[0];
                Inc(sc);
                if sc < StepCount then goto lab2;
         Lab1:  Inc(PS);
                Inc(psm);
              end;
            end;
            if bSummUp then
            begin
              psm := @AngMaxArr^[apos][0];
              st := 0;
              for x2 := 0 to 31 do
              begin
                if psm^ > -32768 then st := st + ArcTan(psm^ * d00002441406);
                Inc(psm);
              end;
              Inc(PWord(Integer(PsiLightW) + 6)^, Max(0, Min(imin, Round(st * sMul))));
            end;
          end;
          Inc(PsiLightW, 9);
          Inc(apos);
          Inc(xy[0]);
          if ASCpar.aPCTS.pLBcalcStop^ then Break;
        end;
        if ASCpar.aPCTS.pLBcalcStop^ then Break;
        Inc(xy[1], ASCpar.aYstep);
      end;
    finally
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].isActive := 0;
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos := ASCpar.aHeight - 1;
      PostMessage(ASCpar.aPCTS.pMessageHwnd, WM_ThreadReady, 0, 1);
    end;
end;

{procedure NextATlevelHiQ(PIA: TPCardinalArray; Wid, Hei, Step: Integer);
var x, y, ya, ye: Integer;
    SA: array of Cardinal;
    PIA2: TPCardinalArray;
begin
    SetLength(SA, Max(Hei, Wid));
    ya := Wid - 1;
    for y := 0 to Hei - 1 do          //smooth horizontal
    begin
      PIA2 := @PIA[y * Wid];
      FastMove(PIA2[0], SA[0], 4 * Wid);
      for x := 0 to ya do
        PIA2[x] := (PIA2[x] + (SA[Max(0, x - Step)] + PIA2[Min(ya, x + Step)]) shr 1) shr 1;
    end;
    ye := Hei - 1;
    for x := 0 to Wid - 1 do          //smooth vertical
    begin
      PIA2 := @PIA[x];
      for y := 0 to ye do SA[y] := PIA[y * Wid + x];
      ya := 0;
      for y := 0 to ye do
      begin
        PIA2[ya] := (PIA2[ya] + (SA[Max(0, y - Step)] + SA[Min(ye, y + Step)]) shr 1) shr 1;
        Inc(ya, Wid);
      end;
    end;
end; }
procedure AmbSmooth(var ASCpar: TASCparameter);
var x, y, apos, MWidth, ya, ye: Integer;
    PSI: TPSmallintArray;
    st, {st2,} sMul: Single;
    PsiLightW: PWord;
    AngMaxArr: TPAngMaxArrSI;
begin
    try
      AngMaxArr := ASCpar.PATmaxArr;
      sMul := 1.5 * 32767 / (Pi * 32 * Power(ArcTan(ASCpar.aZRThreshold * 0.7 * Sqrt(Sqrt(ASCpar.aATlevelCount))), 0.9));
      MWidth  := ASCpar.aWidth;
      //store first column in tmpbuf
      for x := 1 to MWidth - 2 do                           //first smooth horizontal
      begin
        for y := ASCpar.aYStart to ASCpar.aYend do
        begin


        end;
      end;
      //store first row in tmpbuf
      for y := ASCpar.aYStart + 1 to ASCpar.aYend - 1 do    //smooth vertical
      begin
        for x := 0 to MWidth - 1 do
        begin


        end;
      end;
      if ASCpar.aYStart = 0 then ya := 0 else ya := ASCpar.aYStart + 1;
      if ASCpar.aYend = ASCpar.aHeight - 1 then ye := ASCpar.aYend else ye := ASCpar.aYend - 1;
      for y := ya to ye do
      begin                                                 //proof if vals are bigger then in main maxarray
        for x := 0 to MWidth - 1 do
        begin


        end;
      end;
      if ASCpar.aCurrentLevel = ASCpar.aATlevelCount then   //Summup
      begin
        for y := ASCpar.aYStart to ASCpar.aYend do
        begin
          PsiLightW := PWord(Integer(ASCpar.aPsiLight) + 6);
          apos := (y - ASCpar.aYBlockStart) * MWidth;
          Inc(PsiLightW, y * MWidth * 9);
          PSI := TPSmallintArray(@AngMaxArr^[apos][0]);
          for x := 0 to MWidth - 1 do
          begin
            st := 0;
            for apos := 0 to 31 do if PSI[apos] > -32768 then st := st + ArcTan(PSI[apos] * d00002441406);
            PWord(Integer(PsiLightW) + 6)^ := Max(0, Min(16383, Round(st * sMul)));
            Inc(PsiLightW, 9);
          end;
          if ASCpar.aPCTS.pLBcalcStop^ then Break;
        end;
      end;
    except
    end;
end;

procedure TAmbHiQCalcRT0.Execute;  
var xy: array[0..1] of Integer;
    x2, y2, apos, iStep, seed, zp, iand: Integer;
    MWidth, MHeight, iDir, StepCount, sc, it, MW2, MH2, WLo, WHi, HLo, HHi: Integer;
    PATL: PIntegerArray;
    PS: TPSPoint;
    sMinRad, ssub, sstep: TSPoint;
    sx, sy, sit, s32767, sm32768: Single;
    st, st2, sZRT, sMul, RMA, smin: Single;
    PsiLightW: PWord;
    AngMaxArr: TPAngMaxArrSI;
    bSummUp: LongBool;
    PSI: TPSmallintArray;
    pint: PInteger;
label Lab1, Lab2, Lab3;
begin
    try
      pint := @ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos;
      AngMaxArr := ASCpar.PATmaxArr;
      if ASCpar.aZRThreshold < 0.01 then ASCpar.aZRThreshold := 0.01;
      bSummUp := ASCpar.aCurrentLevel = ASCpar.aATlevelCount;
      MWidth  := ASCpar.aWidth;
      MHeight := ASCpar.aHeight;
      MH2     := 2 * (MHeight - 1);
      MW2     := 2 * (MWidth - 1);
  //    MHd2    := MHeight div 2;
    //  MWd2    := MWidth div 2;
      WLo := Round(MWidth * ASCpar.aBorderMirrorSize);
      WHi := MWidth - 1 - WLo;
      HLo := Round(MHeight * ASCpar.aBorderMirrorSize);
      HHi := MHeight - 1 - HLo;
      sit     := ASCpar.aZScaleFactor / 22000.0 * 4096;
   //   sit2    := sit / 32768;
      xy[1]   := ASCpar.aYStart;
      sZRT    := Sqr(ASCpar.aZRThreshold * 4096 / sit * Sqrt(Sqrt(ASCpar.aATlevelCount / ASCpar.aCurrentLevel)));
      sMul    := 1.5 * 32767 / (Pi * 32 * ArcTan(ASCpar.aZRThreshold * 0.64 * Sqrt(Sqrt(ASCpar.aATlevelCount)))) / ASCpar.aRcount;
      smin    := 16383 div ASCpar.aRcount;
      iStep   := 1 shl (ASCpar.aCurrentLevel - 1);
      if iStep < 2 then
      begin
        sMinRad[0] := 1;
        StepCount := 5;
      end else begin
        sMinRad[0] := 3.25 * iStep;
        StepCount := 3;
      end;
      sMinRad[1] := sMinRad[0];
      seed := Round(Random * (ASCpar.aThreadId + 1) * $324594A1 + $24563487);
      iand := iStep * 2 - 1;  //1,2,4,8,...  1,  3,  7,   15
      ssub[0] := iand * 0.5;             // .5  1.5  3.5  7.5
      ssub[1] := ssub[0];
      sstep[0] := iStep;
      sstep[1] := sstep[0];
      s32767 := 32767;
      sm32768 := -32768;
      while xy[1] <= ASCpar.aYend do
      begin
        pint^ := xy[1];
        PsiLightW := PWord(Integer(ASCpar.aPsiLight) + 6); //@RoughZposfine
        apos := (xy[1] - ASCpar.aYBlockStart) * MWidth;
        Inc(PsiLightW, xy[1] * MWidth * 9);
        xy[0] := 0;
        while xy[0] < MWidth do
        begin
          if (PCardinal(PsiLightW)^ and $80000000) = 0 then //or bDoBGshadow
          begin
            PATL := PIntegerArray(ASCpar.PATlevel);
            zp := (PCardinal(PsiLightW)^ and $FFFFFF00) shr 1;
            PS := @ATdirSteps[0];
            PSI := TPSmallintArray(@AngMaxArr^[apos][0]);
            if SupportSSE then
            asm
                push eax
                push ebx
                push ecx
                push edx
                push esi
                push edi
                mov  esi, PATL
                mov  edx, PSI
                mov  edi, seed
                mov  iDir, 31
                xorps  xmm1, xmm1
                xorps  xmm2, xmm2
                xorps  xmm3, xmm3
                xorps  xmm4, xmm4
                xorps  xmm5, xmm5
                xorps  xmm6, xmm6
                movlps xmm4, ssub     //xmm4 = ssub
                movlps xmm5, sstep    //xmm5 = sstep
            //    movss  xmm7, sm32768
    @foriDir:   mov  eax, PS
                movlps xmm1, sMinRad  //                 (1.2 at stepw1)
                movlps xmm6, [eax]    //xmm6 = PS[0,1]
                mulps  xmm1, xmm6
                subps  xmm1, xmm4     //sxy-ssub        (-0,5 at stepw1)
                mov  eax, StepCount
                mov  sc, eax
   @while:      imul edi, $000343FD
                add  edi, $269EC3
                mov  eax, edi
                movaps xmm0, xmm1     //sx, sy
                shr  eax, 10
                CVTSS2SI ecx, xmm0
                mov  ebx, eax
                and  ebx, iand
                add  ecx, ebx
                shufps xmm0, xmm0, 1
                shr  eax, 6
                CVTSS2SI ebx, xmm0
                and  eax, iand
                add  ebx, eax

                push ecx
                mov  eax, ebx
                imul ecx, ecx
                imul eax, eax
                add  eax, ecx
                pop  ecx
                test eax, eax
                jz   @skip
                CVTSI2SS xmm2, eax

                add  ecx, dword [xy]
                add  ebx, dword [xy+4]
                test ecx, ecx    // reflection at borders
                jns  @@1
                neg  ecx
                cmp  ecx, WLo
                jge  @endwhile
                jmp  @@2
           @@1: cmp  ecx, MWidth
                jl   @@2
                sub  ecx, MW2
                neg  ecx
                cmp  ecx, WHi
                jl   @endwhile
           @@2: test ebx, ebx
                jns  @@3
                neg  ebx
                cmp  ebx, HLo
                jge  @endwhile
                jmp  @con
           @@3: cmp  ebx, MHeight
                jl   @con
                sub  ebx, MH2
                neg  ebx
                cmp  ebx, HHi
                jl   @endwhile
          @con: imul ebx, MWidth
                add  ebx, ecx
                mov  eax, [esi + ebx * 4]  //PATL^[y2 * MWidth + x2]
                sub  eax, zp
                CVTSI2SS xmm0, eax     // (CVTPI2PS=sse, 2 int to single)
                RSQRTSS xmm2, xmm2
                mulss  xmm0, xmm2   //st := (PATL^[y2 * MWidth + x2] - zp) / Sqrt(st);
                movss  xmm3, xmm0
                mulss  xmm0, xmm0
                mulss  xmm3, sit
                addss  xmm0, sZRT
                mulss  xmm3, sZRT
                rcpss  xmm0, xmm0
                mulss  xmm3, xmm0
                minss  xmm3, s32767
                maxss  xmm3, sm32768
                CVTSS2SI eax, xmm3   //it := Round(st * sit * sZRT / (st * st + sZRT));
                mov  ecx, iDir
                cmp  ax, word [edx + ecx * 2]
                jle  @skip
                mov  word [edx + ecx * 2], ax
      @skip:    movaps xmm3, xmm5   //sstep
                mulps  xmm3, xmm6   //DirXY
                addps  xmm1, xmm3   //sx,sy
                dec  sc
                jnz  @while
    @endwhile:  add  PS, 8
                dec  iDir
                jns  @foriDir
                mov  seed, edi
                pop  edi
                pop  esi
                pop  edx
                pop  ecx
                pop  ebx
                pop  eax
            end
            else
            begin
              for iDir := 0 to 31 do
              begin
                sx := PS[0] * sMinRad[0] - ssub[0];
                sy := PS[1] * sMinRad[0] - ssub[0];
                sc := 0;
         lab2:  seed := 214013 * seed + 2531011;
                x2 := Round(sx) + ((seed shr 16) and iand);
                y2 := Round(sy) + ((seed shr 10) and iand);
                st := Sqr(x2) + Sqr(y2);
                if st = 0 then goto Lab3;
                x2 := x2 + xy[0];
                y2 := y2 + xy[1];
                if x2 < 0 then
                begin
                  x2 := -x2;
                  if x2 >= WLo then goto Lab1;
                end
                else if x2 >= MWidth then
                begin
                  x2 := MW2 - x2;
                  if x2 < WHi then goto Lab1;
                end;
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
            {    st := (PATL^[y2 * MWidth + x2] - zp) / Sqrt(st);
                st2 := st * sit + 32768;
                it := Round(st2 * Abs(st) * sit * 0.0002 * sZRT / (st * st + sZRT)) - 32768;  }

                st := (PATL^[y2 * MWidth + x2] - zp) / Sqrt(st);
                it := Round(st * sit * sZRT / (st * st + sZRT));
                if PSI[iDir] < it then PSI[iDir] := Min(32767, it);
          Lab3: sx := sx + PS[0] * sstep[0];
                sy := sy + PS[1] * sstep[0];
                Inc(sc);
                if sc < StepCount then goto lab2;
          Lab1: Inc(PS);
              end;
            end;
            if bSummUp then
            begin
              st := 0;
              for x2 := 0 to 31 do if PSI[x2] > -32768 then st := st + ArcTan(PSI[x2] * d00002441406);
              Inc(PWord(Integer(PsiLightW) + 6)^, Round(Min0MaxCS(st * sMul, smin)));
            end;
          end;
          Inc(PsiLightW, 9);
          Inc(xy[0]);
          Inc(apos);
          if ASCpar.aPCTS.pLBcalcStop^ then Break;
        end;
        if ASCpar.aPCTS.pLBcalcStop^ then Break;
        Inc(xy[1], ASCpar.aYstep);
      end;
    finally
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].isActive := 0;
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos := ASCpar.aHeight - 1;
      PostMessage(ASCpar.aPCTS.pMessageHwnd, WM_ThreadReady, 0, 1);
    end;
end;

procedure TAmbHiQCalcRT0pano.Execute;
var xy: array[0..1] of Integer;
    x2, y2, apos, iStep, seed, zp, iand: Integer;
    MWidth, MHeight, iDir, StepCount, sc, it, MH2, HLo, HHi: Integer;
    PATL: PIntegerArray;
    PS: TPSPoint;
    sMinRad, ssub, sstep: TSPoint;
    sx, sy, sit, s32767, sm32768: Single;
    st, st2, sZRT, sMul, RMA, smin: Single;
    PsiLightW: PWord;
    AngMaxArr: TPAngMaxArrSI;
    bSummUp: LongBool;
    PSI: TPSmallintArray;
    pint: PInteger;
label Lab1, Lab2, Lab3;
begin
    try
      pint := @ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos;
      AngMaxArr := ASCpar.PATmaxArr;
      if ASCpar.aZRThreshold < 0.01 then ASCpar.aZRThreshold := 0.01;
      bSummUp := ASCpar.aCurrentLevel = ASCpar.aATlevelCount;
      MWidth  := ASCpar.aWidth;
      MHeight := ASCpar.aHeight;
      MH2     := 2 * (MHeight - 1);
      HLo := Round(MHeight * ASCpar.aBorderMirrorSize);
      HHi := MHeight - 1 - HLo;
      sit     := ASCpar.aZScaleFactor / 22000.0 * 4096;
      xy[1]   := ASCpar.aYStart;
      sZRT    := Sqr(ASCpar.aZRThreshold * 4096 / sit * Sqrt(Sqrt(ASCpar.aATlevelCount / ASCpar.aCurrentLevel)));
      sMul    := 1.5 * 32767 / (Pi * 32 * ArcTan(ASCpar.aZRThreshold * 0.64 * Sqrt(Sqrt(ASCpar.aATlevelCount)))) / ASCpar.aRcount;
      smin    := 16383 div ASCpar.aRcount;
      iStep   := 1 shl (ASCpar.aCurrentLevel - 1);
      if iStep < 2 then
      begin
        sMinRad[0] := 1;
        StepCount := 5;
      end else begin
        sMinRad[0] := 3.25 * iStep;
        StepCount := 3;
      end;
      sMinRad[1] := sMinRad[0];
      seed := Round(Random * (ASCpar.aThreadId + 1) * $324594A1 + $24563487);
      iand := iStep * 2 - 1;  //1,2,4,8,...  1,  3,  7,   15
      ssub[0] := iand * 0.5;             // .5  1.5  3.5  7.5
      ssub[1] := ssub[0];
      sstep[0] := iStep;
      sstep[1] := sstep[0];
      s32767 := 32767;
      sm32768 := -32768;
      while xy[1] <= ASCpar.aYend do
      begin
        pint^ := xy[1];
        PsiLightW := PWord(Integer(ASCpar.aPsiLight) + 6); //@RoughZposfine
        apos := (xy[1] - ASCpar.aYBlockStart) * MWidth;
        Inc(PsiLightW, xy[1] * MWidth * 9);
        xy[0] := 0;
        while xy[0] < MWidth do
        begin
          if (PCardinal(PsiLightW)^ and $80000000) = 0 then //or bDoBGshadow
          begin
            PATL := PIntegerArray(ASCpar.PATlevel);
            zp := (PCardinal(PsiLightW)^ and $FFFFFF00) shr 1;
            PS := @ATdirSteps[0];
            PSI := TPSmallintArray(@AngMaxArr^[apos][0]);
            if SupportSSE then
            asm
                push eax
                push ebx
                push ecx
                push edx
                push esi
                push edi
                mov  esi, PATL
                mov  edx, PSI
                mov  edi, seed
                mov  iDir, 31
                xorps  xmm1, xmm1
                xorps  xmm2, xmm2
                xorps  xmm3, xmm3
                xorps  xmm4, xmm4
                xorps  xmm5, xmm5
                xorps  xmm6, xmm6
                movlps xmm4, ssub     //xmm4 = ssub
                movlps xmm5, sstep    //xmm5 = sstep
    @foriDir:   mov  eax, PS
                movlps xmm1, sMinRad  //                 (1.2 at stepw1)
                movlps xmm6, [eax]    //xmm6 = PS[0,1]
                mulps  xmm1, xmm6
                subps  xmm1, xmm4     //sxy-ssub        (-0,5 at stepw1)
                mov  eax, StepCount
                mov  sc, eax
   @while:      imul edi, $000343FD
                add  edi, $269EC3
                mov  eax, edi
                movaps xmm0, xmm1     //sx, sy
                shr  eax, 10
                CVTSS2SI ecx, xmm0
                mov  ebx, eax
                and  ebx, iand
                add  ecx, ebx
                shufps xmm0, xmm0, 1
                shr  eax, 6
                CVTSS2SI ebx, xmm0
                and  eax, iand
                add  ebx, eax

                push ecx
                mov  eax, ebx
                imul ecx, ecx
                imul eax, eax
                add  eax, ecx
                pop  ecx
                test eax, eax
                jz   @skip
                CVTSI2SS xmm2, eax

                add  ecx, dword [xy]
                add  ebx, dword [xy+4]
                test ecx, ecx    // reflection at borders
                jns  @@1
                add  ecx, MWidth
                test ecx, ecx
                jns  @@2
                jmp  @endwhile
           @@1: cmp  ecx, MWidth
                jl   @@2
                sub  ecx, MWidth
                cmp  ecx, MWidth
                jnl  @endwhile
           @@2: test ebx, ebx
                jns  @@3
                neg  ebx
                cmp  ebx, HLo
                jge  @endwhile
                jmp  @con
           @@3: cmp  ebx, MHeight
                jl   @con
                sub  ebx, MH2
                neg  ebx
                cmp  ebx, HHi
                jl   @endwhile
          @con: imul ebx, MWidth
                add  ebx, ecx
                mov  eax, [esi + ebx * 4]  //PATL^[y2 * MWidth + x2]
                sub  eax, zp
                CVTSI2SS xmm0, eax     // (CVTPI2PS=sse, 2 int to single)
                RSQRTSS xmm2, xmm2
                mulss  xmm0, xmm2   //st := (PATL^[y2 * MWidth + x2] - zp) / Sqrt(st);
                movss  xmm3, xmm0
                mulss  xmm0, xmm0
                mulss  xmm3, sit
                addss  xmm0, sZRT
                mulss  xmm3, sZRT
                rcpss  xmm0, xmm0
                mulss  xmm3, xmm0
                minss  xmm3, s32767
                maxss  xmm3, sm32768
                CVTSS2SI eax, xmm3   //it := Round(st * sit * sZRT / (st * st + sZRT));
                mov  ecx, iDir
                cmp  ax, word [edx + ecx * 2]
                jle  @skip
                mov  word [edx + ecx * 2], ax
      @skip:    movaps xmm3, xmm5   //sstep
                mulps  xmm3, xmm6   //DirXY
                addps  xmm1, xmm3   //sx,sy
                dec  sc
                jnz  @while
    @endwhile:  add  PS, 8
                dec  iDir
                jns  @foriDir
                mov  seed, edi
                pop  edi
                pop  esi
                pop  edx
                pop  ecx
                pop  ebx
                pop  eax
            end
            else
            begin
              for iDir := 0 to 31 do
              begin
                sx := PS[0] * sMinRad[0] - ssub[0];
                sy := PS[1] * sMinRad[0] - ssub[0];
                sc := 0;
         lab2:  seed := 214013 * seed + 2531011;
                x2 := Round(sx) + ((seed shr 16) and iand);
                y2 := Round(sy) + ((seed shr 10) and iand);
                st := Sqr(x2) + Sqr(y2);
                if st = 0 then goto Lab3;
                x2 := x2 + xy[0];
                y2 := y2 + xy[1];
                if x2 < 0 then
                begin
                  x2 := x2 + MWidth;
                  if x2 < 0 then goto Lab1;
                end
                else if x2 >= MWidth then
                begin
                  x2 := x2 - MWidth;
                  if x2 >= MWidth then goto Lab1;
                end;
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
            {    st := (PATL^[y2 * MWidth + x2] - zp) / Sqrt(st);
                st2 := st * sit + 32768;
                it := Round(st2 * Abs(st) * sit * 0.0002 * sZRT / (st * st + sZRT)) - 32768;  }

                st := (PATL^[y2 * MWidth + x2] - zp) / Sqrt(st);
                it := Round(st * sit * sZRT / (st * st + sZRT));
                if PSI[iDir] < it then PSI[iDir] := Min(32767, it);
          Lab3: sx := sx + PS[0] * sstep[0];
                sy := sy + PS[1] * sstep[0];
                Inc(sc);
                if sc < StepCount then goto lab2;
          Lab1: Inc(PS);
              end;
            end;
            if bSummUp then
            begin
              st := 0;
              for x2 := 0 to 31 do if PSI[x2] > -32768 then st := st + ArcTan(PSI[x2] * d00002441406);
              Inc(PWord(Integer(PsiLightW) + 6)^, Round(Min0MaxCS(st * sMul, smin)));
            end;
          end;
          Inc(PsiLightW, 9);
          Inc(xy[0]);
          Inc(apos);
          if ASCpar.aPCTS.pLBcalcStop^ then Break;
        end;
        if ASCpar.aPCTS.pLBcalcStop^ then Break;
        Inc(xy[1], ASCpar.aYstep);
      end;
    finally
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].isActive := 0;
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos := ASCpar.aHeight - 1;
      PostMessage(ASCpar.aPCTS.pMessageHwnd, WM_ThreadReady, 0, 1);
    end;
end;

procedure TAmbVideo.Execute;
var MWidth, MHeight, x, y, x2, y2: Integer;
    iDir, StepCount, sc, MH2, MW2, WLo, WHi, HLo, HHi, tA: Integer;
    zp: Integer;
    PS: TPSPoint;
    sx, sy, sit: Single;
    st, st2, sMul{, sMHm1, sMWm1}: Single;
    PsiLightW, psi2: PWord;
    seed: Integer;
    pint: PInteger;
    sv: TSVec;
label lab1, lab2, lab3;
begin
    try
      pint := @ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos;
      MWidth  := ASCpar.aWidth;
      MHeight := ASCpar.aHeight;
      MH2 := 2 * (MHeight - 1);
      MW2 := 2 * (MWidth - 1);
      WLo := Round(MWidth * ASCpar.aBorderMirrorSize);
      WHi := MWidth - 1 - WLo;
      HLo := Round(MHeight * ASCpar.aBorderMirrorSize);
      HHi := MHeight - 1 - HLo;
      sit := ASCpar.aZScaleFactor / 22000.0 * 4096; //aZScaleFactor := (Sqr(256 / ZcMul + 1) - 1) / Zcorr;
      y   := ASCpar.aYStart;
      seed := Round(Random * (ASCpar.aThreadId + 1) * $324594A1 + $24563487);
  //    sZRT := ASCpar.aZRThreshold * 0.7 * 4096 / sit * Sqrt(Sqrt(ASCpar.aATlevelCount / ASCpar.aCurrentLevel));  //Threshold depends on level
      sit := sit * 0.00001;
      StepCount := Round(Sqrt(Sqr(MWidth) + Sqr(MHeight)) * 0.1) + 1;
      smul := 16383 / (32 * StepCount);
      psi2 := PWord(Integer(ASCpar.aPsiLight) + 6);
      while y <= ASCpar.aYend do
      begin
        pint^ := y;
        PsiLightW := psi2;
        Inc(PsiLightW, y * MWidth * 9);
        x := 0;
        while x < MWidth do
        begin
            if (PCardinal(PsiLightW)^ and $80000000) = 0 then
            begin
              sv := MakeSVecFromNormals(Pointer(Integer(PsiLightW) - 6));
              zp := (PCardinal(PsiLightW)^ and $FFFFFF00) shr 1;
              tA := 0;
              PS := @ATdirSteps[0];
              for iDir := 0 to 31 do
              begin
                sx := PS[0] * 2.5;
                sy := PS[1] * 2;
                sc := 0;
         lab2:  seed := 214013 * seed + 2531011;
                x2 := Round(sx - 1.5) + ((seed shr 16) and 3);
                y2 := Round(sy - 1.5) + ((seed shr 10) and 3);
                st := Sqr(x2) + Sqr(y2);
                if st = 0 then goto Lab3;
                x2 := x2 + x;
                y2 := y2 + y;
                if x2 < 0 then
                begin
                  x2 := x2 + MWidth;
                  if x2 < 0 then goto Lab1;
                end
                else if x2 >= MWidth then
                begin
                  x2 := x2 - MWidth;
                  if x2 >= MWidth then goto Lab1;
                end;
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
                st2 := (((PCardinal(Integer(psi2) + (y2 * MWidth + x2) * 18)^ and $FFFFFF00) shr 1) - zp) * sit;
                if st2 * sv[2] + sx * sv[0] + sy * sv[1] < 0 then Inc(tA);
          Lab3: sx := sx + PS[0] * 2;
                sy := sy + PS[1] * 2;
                Inc(sc);
                if sc < StepCount then goto lab2;
          Lab1: Inc(PS);
              end;
              PWord(Integer(PsiLightW) + 6)^ := Round(tA * sMul);
            end;
            Inc(PsiLightW, 9);
            Inc(x);
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


{procedure TAmbHiQCalc2.Execute;
var x, y, x2, y2, apos, iStep: Integer;
    MWidth, MHeight, StepCount, sc, zp, iMinRadS, iMaxRad, iMaxRadS: Integer;
    PATL: PIntegerArray;
    sMinRad, st, st2, sMul: Single;
    PsiLight: TPsiLight5;
    AngSumArr: TPSingleArray;
    bSummUp: LongBool;
    PBreak: PLongBool;
 //   PSA: TPSingleArray;
 //   RMA: array[0..5] of Single;
begin
    try
      AngSumArr := TPSingleArray(ASCpar.PATmaxArr);
      if ASCpar.aZRThreshold < 0.01 then ASCpar.aZRThreshold := 0.01;
      PBreak  := ASCpar.aPCTS.pLBcalcStop;
      bSummUp := ASCpar.aCurrentLevel = ASCpar.aATlevelCount;
      MWidth  := ASCpar.aWidth;
      MHeight := ASCpar.aHeight;
      st2     := ASCpar.aZScaleFactor / 65536.0;
      y       := ASCpar.aYStart;
 //     sZRT    := ASCpar.aZRThreshold / st2;
      sMul    := 1.25 * 32767 / Pi;
      iStep   := 1 shl (ASCpar.aCurrentLevel - 1);
      if iStep < 2 then sMinRad := 1
      else sMinRad := 16 * iStep / Pi + iStep * 0.7;
      if iStep < 2 then StepCount := 5 else StepCount := 3;
      iMinRadS := Round(sMinRad * sMinRad);
      iMaxRad := Round(sMinRad + StepCount * iStep);
      iMaxRadS := iMaxRad * iMaxRad;
      while y <= ASCpar.aYend do
      begin
        ASCpar.aPCTS.iActualYpos[ASCpar.aThreadID] := y;
        PsiLight := ASCpar.aPsiLight;
        apos     := (y - ASCpar.aYBlockStart) * MWidth;
        Inc(PsiLight, y * MWidth);
        x := 0;
        while x < MWidth do
        begin
          if (PsiLight^.Zpos < 32768) then //or bDoBGshadow
          begin
            PATL := PIntegerArray(ASCpar.PATlevel);
            zp := ((PCardinal(@PsiLight.RoughZposFine)^ and $FFFFFF00) shr 1);
         //   PS := @ATdirSteps[0];
       //     PSA := TPSingleArray(@AngMaxArr^[apos][0]);

            y2 := Max(0, y - iMaxRad);
            while y2 <= Min(MHeight - 1, y + iMaxRad) do
            begin

              x2 := Max(0, x - iMaxRad);
              while x2 <= Min(MWidth - 1, x + iMaxRad) do
              begin
                sc := Sqr(y2 - y) + Sqr(x2 - x);
                if (sc <= iMaxRadS) and (sc >= iMinRadS) then
                begin
                  st := (PATL^[y2 * MWidth + x2] - zp) * st2;
                  st := st / Sqrt(sc + st * st);
              //    if st > sZRT then st := sZRT;
               //   if PSA[iDir] < st then PSA[iDir] := st;
                  AngSumArr[apos] := AngSumArr[apos] + st;
                end;
                Inc(x2, iStep);
              end;
              Inc(y2, iStep);
            end;

         {   for iDir := 0 to 31 do
            begin
              RM := sMinRad;
              sx := x + PS[0] * sMinRad;
              sy := y + PS[1] * sMinRad;
              x2 := Round(sx);
              y2 := Round(sy);
              sc := 0;
              while (sc < StepCount) and (x2 >= 0) and (x2 < MWidth) and (y2 >= 0) and (y2 < MHeight) do
              begin
                st := (PATL^[y2 * MWidth + x2] - zp) * RMA[sc]; // / RM;
                if st > sZRT then st := sZRT;
                if PSA[iDir] < st then PSA[iDir] := st;
                RM := RM + iStep;
                sx := sx + PS[0] * iStep;
                sy := sy + PS[1] * iStep;
                x2 := Round(sx);
                y2 := Round(sy);
                Inc(sc);
              end;
              Inc(PS);
            end;  }

     {       if bSummUp then
            begin
              PsiLight.AmbShadow := Max(0, Min(16383, Round(AngSumArr[apos] * sMul)));  //read of
            end;
          end;
          Inc(PsiLight);
          Inc(x);
          Inc(apos);
          if PBreak^ then Break;
        end;
        if PBreak^ then Break;
        Inc(y, ASCpar.aYstep);
      end;
    finally
      ASCpar.aPCTS.isActive[ASCpar.aThreadID] := 0;
      ASCpar.aPCTS.iActualYpos[ASCpar.aThreadID] := ASCpar.aHeight - 1;
      PostMessage(ASCpar.aPCTS.pMessageHwnd, WM_ThreadReady, 0, 1);
    end;
end;  }

Initialization

   IniATdirSteps;

end.

