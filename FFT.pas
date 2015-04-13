unit FFT;

interface

uses TypeDefinitions;

var
  FFTlength: Integer = 0;
  pFFTcos, pFFTsin, pFFTreal, pFFTimag, pFFTresult: array of Double;
  pFFTbitrev: array of Cardinal;
  FFTMap: TLightMap;

implementation

uses Maps, DivUtils;

procedure fill0bytes(const p: Pointer; const anz: Integer; const useSSE: Boolean);
var x, offs, x4: Integer;
    p1: PByte;
    pc: PCardinal;
begin
    p1 := p;
    if useSSE then
    begin
      offs := 16 - (Cardinal(p1) and $0000000F);
      if offs = 16 then offs := 0;
      if offs <= anz then
      begin
        for x := 1 to offs do
        begin
          p1^ := 0;
          Inc(p1);
        end;
        x4 := (anz - offs) shr 4;
        if x4 > 0 then
        begin
          asm
            push eax
            push ecx
            mov  ecx, x4
            mov  eax, p1
            xorps xmm0, xmm0
    @loop:  movaps [eax], xmm0
            add  eax, 16
            sub  ecx, 1
            jnz  @loop
            mov  p1, eax
            pop  ecx
            pop  eax
          end;
          offs := offs + (x4 shl 4);
        end;
      end
      else offs := 0;
    end
    else
    begin
      offs := anz shr 2;
      pc := PCardinal(p1);
      for x := 1 to offs do
      begin
        pc^ := 0;
        Inc(pc);
      end;
      p1 := PByte(pc);
      offs := offs shl 2;
    end;
    for x := offs to anz - 1 do
    begin
      p1^ := 0;
      Inc(p1);
    end;
end;

function fftlaenge(const xx: Integer): Integer;
begin
  Result := 1;
  while Result < xx do Result := Result shl 1;
end;

function fftzlaenge(const anfang, ende: Integer): Integer;
var
  xx: Integer;
begin
  xx := ende - anfang + 1;
  if xx < 1 then xx := 1;
  Result := 1;
  while Result < xx do Result := Result shl 1;
end;

procedure FFTini(Bleng: Integer);
var
  x, fp1, adrbrev, adrnorm, l, Flength: Integer;
  wif: Double;
begin
    Flength := fftlaenge(Bleng);
    if Flength <> FFTlength then
    begin
      fp1 := Flength + 1;
      if Length(pFFTbitrev) < fp1 then
      begin
        SetLength(pFFTcos, fp1);
        SetLength(pFFTsin, fp1);
        SetLength(pFFTreal, fp1);
        SetLength(pFFTimag, fp1);
        SetLength(pFFTresult, fp1);
        SetLength(pFFTbitrev, fp1);
      end;
      FFTlength := Flength;
    end;
    wif := 2 * Pi / FFTlength;
    for x := 0 to FFTlength do
    begin
      pFFTsin[x] := -Sin(wif * x);
      pFFTcos[x] := Cos(wif * x);
    end;
    pFFTbitrev[0] := 0;
    adrbrev := 0;
    for adrnorm := 1 to FFTlength - 1 do
    begin
      l := FFTlength div 2;
      while adrbrev + l > FFTlength - 1 do
        l := l shr 1;
      adrbrev := adrbrev mod l + l;
      if adrbrev >= adrnorm then
      begin
        pFFTbitrev[adrnorm] := adrbrev;
        pFFTbitrev[adrbrev] := adrnorm;
      end;
    end;
end;

procedure loeschfftr;
begin
  Fill0Bytes(@pFFTreal[0], (FFTlength + 1) shl 3, SupportSSE);
end;

procedure loeschffti;
begin
  Fill0Bytes(@pFFTimag[0], (FFTlength + 1) shl 3, SupportSSE);
end;

procedure verdopplefftzeile;
var
  x: Integer;
  pdr1, pdr2, pdi1, pdi2: PDouble;
begin
  pdr1 := @pfftreal[1];
  pdr2 := pdouble(Cardinal(pdr1) + (FFTlength - 2) * 8);
  pdi1 := @pfftimag[1];
  pdi2 := pdouble(Cardinal(pdi1) + (FFTlength - 2) * 8);
  for x := 1 to FFTlength div 2 do
  begin
    pdr2^ := pdr1^;
    pdi2^ := -pdi1^;
    Inc(pdr1);
    Dec(pdr2);
    Inc(pdi1);
    Dec(pdi2);
  end;
end;

procedure doFFT(const d: Double);
var
  pe1, pe2, pe3, pe4: PDouble;
  tabnr, l, fl2, fl3, i, j, m, ischritt: Integer;
  tmpreal, tmpimag, wichreal, wichimag: Double;
begin
  fl2 := FFTlength shr 1;
  fl3 := fl2;
  l := 1; 
  if SupportSSE2 then
  begin
    asm
       push edx
       push ecx
       push ebx
       push eax
       push esi
       push edi
       mov  ebx, pFFTreal
       mov  ecx, pFFTimag
       movsd  xmm7, d
       shufpd xmm7, xmm7, 0
       mov  eax, l
@loo0: shl  eax, 1                         // while l<=fl2
       mov  edi, eax                       // war: ischritt, eax
       xor  eax, eax                       // eax=m
       mov  tabnr, eax
@loo1: mov  edx, tabnr                     // for m:=0 to l-1
       mov  esi, pFFTcos
       movlpd xmm3, [esi + edx * 8]
       mov  esi, pFFTsin
       movlpd xmm4, [esi + edx * 8]        
       shufpd xmm3, xmm3, 0                // xmm3 = [wichreal, wichreal]
       shufpd xmm4, xmm4, 0                // xmm4 = [wichimag, wichimag]
       mulpd  xmm4, xmm7                   // xorpd xmm4, [sign]
       mov  edx, eax                       // edx=i=m
@loo2: mov  esi, edx
       add  esi, l                         // j=i+l
       movlpd xmm0, [ebx + esi * 8]        //          hi    lo
       movhpd xmm0, [ecx + esi * 8]        // xmm0 = [imag, real]
       movapd xmm1, xmm0
       shufpd xmm1, xmm1, 1                // xmm1 = [real, imag]  (,1=swap)
       mulpd  xmm0, xmm3                   // xmm0 = [imag*wichreal, real*wichreal]
       mulpd  xmm1, xmm4                   // xmm1 = [real*wichimag, imag*wichimag]
       movapd xmm2, xmm0
       addpd  xmm0, xmm1                   // xmm0 = [i*wr+r*wi, r*wr+i*wi]
       subpd  xmm2, xmm1                   // xmm2 = [i*wr-r*wi, r*wr-i*wi]
       shufpd xmm2, xmm0, 2                // xmm2 = [i*wr+r*wi, r*wr-i*wi]?
                                           //          tmpimag    tmpreal
       movlpd xmm0, [ebx + edx * 8]
       movhpd xmm0, [ecx + edx * 8]        // xmm0 = [imag_i, real_i]
       movapd xmm1, xmm0
       subpd  xmm0, xmm2
       addpd  xmm1, xmm2
       movlpd [ebx + esi * 8], xmm0
       movhpd [ecx + esi * 8], xmm0
       movlpd [ebx + edx * 8], xmm1
       movhpd [ecx + edx * 8], xmm1
       add  edx, edi
       cmp  edx, fftlength
       jl   @loo2
       mov  esi, fl3
       add  tabnr, esi
       add  eax, 1
       cmp  eax, l           // for m:=0 to l-1
       jl   @loo1
       shr  fl3, 1
       mov  eax, edi         // ischritt
       mov  l, eax
       cmp  eax, fl2         // while l<=fl2
       jle  @loo0
       pop  edi
       pop  esi
       pop  eax
       pop  ebx
       pop  ecx
       pop  edx
    end;
  end
  else
    while l <= fl2 do
    begin
      ischritt := l shl 1;
      tabnr := 0;
      for m := 0 to l - 1 do
      begin
        i := m;
        wichreal := pFFTcos[tabnr];
        wichimag := pFFTsin[tabnr] * d;
        repeat
          j := i + l;
          pe1 := @pFFTreal[j];
          pe2 := @pFFTimag[j];
          tmpreal := wichreal * pe1^ - wichimag * pe2^;
          tmpimag := wichreal * pe2^ + wichimag * pe1^;
          pe3 := @pFFTreal[i];
          pe4 := @pFFTimag[i];
          pe1^ := pe3^ - tmpreal;
          pe2^ := pe4^ - tmpimag;
          pe3^ := pe3^ + tmpreal;
          pe4^ := pe4^ + tmpimag;
          inc(i, ischritt);
        until i >= FFTlength;
        Inc(tabnr, fl3);
      end;
      l := ischritt;
      fl3 := fl3 shr 1;
    end;
end;

{procedure calccFFTrow_inv(row: Integer; vertical: Boolean);
var
  pd1, pd2: PDouble;
  x, c: Integer;
  fftl1d: Double;
  ps: PSingle;
  pcBitrev: PCardinal;
begin
  if fftlength > 0 then
  begin
    fftl1d := 1 / FFTlength;
    verdopplefftzeile;       // real gespiegelt nach oben, imag inv gespiegelt nach oben
    pd1 := @pFFTresult[0];
    pd2 := @pFFTreal[0];
    for x := 0 to FFTlength - 1 do
    begin
      pd1^ := pd2^ * fftl1d;
      Inc(pd1);
      Inc(pd2);
    end;
    pd2 := @pFFTreal[0];
    pcBitrev := @pFFTbitrev[0];
    for x := 0 to FFTlength - 1 do    // pfftreal:=bitrev[pfftergebnis]
    begin
      pd2^ := pFFTresult[pcBitrev^];
      inc(pd2);
      inc(pcBitrev);
    end;
    pd1 := @pFFTresult[0];
    pd2 := @pFFTimag[0];
    for x := 0 to FFTlength - 1 do
    begin
      pd1^ := pd2^ * FFTl1d;
      Inc(pd1);
      Inc(pd2);
    end;
    pd2 := @pFFTimag[0];
    pcBitrev := @pFFTbitrev[0];
    for x := 0 to FFTlength - 1 do
    begin
      pd2^ := pFFTresult[pcBitrev^];
      Inc(pd2);
      Inc(pcBitrev);
    end;
    doFFT(-1.0);
    with FFTMap do
    begin
      if (LMWidth <> FFTlength) or (LMHeight <> FFTlength) then
      begin //new Map
        LMWidth := FFTlength;
        LMHeight := FFTlength;
        SetLength(LMa, LMWidth * LMHeight);
      end;
      if not vertical then
      begin
        ps := @LMa[row * LMWidth];
        for x := 0 to FFTlength - 1 do
        begin
          ps^ := pFFTreal[x];
          Inc(ps);
        end;
      end
      else
      begin
        ps := @LMa[row];
        for x := 0 to FFTlength - 1 do
        begin
          ps^ := pFFTreal[x];
          Inc(ps, LMWidth);
        end;
      end;
    end;
  end;
end;   }

 //  MakeNoiseMap(var Map: TLightMap; size, seed: Integer; FalloffX, FalloffY: Single);

{procedure ddFFTtoMap(var Map: TLightMap);
var ps1, ps2: PSingle;
    x, y, z, xp, h1, wid, wid2: Integer;
    pcBitrev, pc: pcardinal;
begin
    if (Map.LMWidth <> FFTMap.LMWidth + 3) or (Map.LMHeight <> FFTMap.LMHeight + 3) then
    begin
      Map.LMWidth := FFTMap.LMWidth + 3;
      Map.LMHeight := FFTMap.LMHeight + 3;
      SetLength(Map.LMa, Map.LMWidth * Map.LMHeight);
    end;
    wid := FFTlength + 2;
    wid2 := wid div 2;
    for x := 0 to FFTMap.LMWidth - 1 do with FFTMap do
    begin
      ps1 := @LMa[x];
      ps2 := PSingle(Integer(ps1) + wid * 2);
      pcBitrev := @pFFTbitrev[0];
      for y := 1 to h1 do
      begin
        pFFTreal[pcBitrev^] := ps1^;
        pFFTimag[pcBitrev^] := ps2^;
        Inc(ps1, LMWidth);
        Inc(ps2, LMWidth);
        Inc(pcBitrev);
      end;
      doFFT(-1.0);
      ps1 := @Map.LMa[x];
      ps2 := PSingle(Cardinal(ps1) + wid * 2);
      for y := 0 to FFTMap.LMHeight - 1 do
      begin
        ps1^ := pFFTreal[xp];
        ps2^ := pFFTimag[xp];
        inc(ps1, Map.LMWidth);
        inc(ps2, Map.LMWidth);
        inc(xp);
      end;
    end;
    ps1 := @p[z][0];
    ps2 := psingle(Cardinal(ps1) + wid * 2);
    for y := 0 to pred(height) do
    begin
      loeschfftr;
      loeschffti;
      for x := 0 to breite2 - 1 do
      begin
        pFFTreal[x] := ps1^;
        pFFTimag[x] := ps2^;
        inc(ps1);
        inc(ps2);
      end;
      berechneFFTzeile_inv(result, z, horizontal, false, y, 0, pred(breite));
      inc(ps1, breite2);
      inc(ps2, breite2);
    end;
end;     }

Initialization

  FreeLightMap(@FFTMap);

end.
 