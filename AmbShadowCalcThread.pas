unit AmbShadowCalcThread;

interface

uses
  Classes, LightAdjust;

type
  TASCparameter = record
    aWidth, aHeight: Integer;
    aXStart, aXEnd: Integer;
    aATlevelCount: Integer;
    aZScaleFactor: Single;
    aPsiLight: TPsiLight3;
    aThreadID: Integer;
  end;
  TAmbShadowCalc = class(TThread)
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;
procedure BuildATlevels(MWidth, MHeight: Integer);

var
  AmbCalcThreadCount: Integer = 0;
  ATlevelCount: Integer = 0;
  ATrousWL: array[1..9] of array of Word;
  ASCprogress: array of Integer;
  ASCstop: Boolean = False;

implementation

uses Math, Mand, DivUtils;

procedure BuildATlevels(MWidth, MHeight: Integer);
var x, y, x2, zp, za: Integer;
    PATL, PATL2: PWord;
    ATl, iStep, iStep2, MWidth2step: Integer;
    ASCparameter: TASCparameter;
    W4tmp, W4tmp2: array[0..3] of Word;
begin
    ATlevelCount := 1;
    x := MWidth div 16;
    repeat
      Inc(ATlevelCount);
      x := x shr 1;
    until (ATlevelCount = 8) or (x < 4);
    for x := 1 to ATlevelCount + 1 do SetLength(ATrousWL[x], MWidth * MHeight);
           //1 additional level as tmpbuf for seperate x,y smoothing
    with Mand3DForm do for x := 0 to High(siLight3) do
      if siLight3[x].Zpos < 32768 then ATrousWL[1][x] := siLight3[x].Zpos
                                  else ATrousWL[1][x] := 0;
    //NEW: Median 3x3 midWeight=4 to blur out single false pixel
    for y := 1 to MHeight - 2 do
    begin
      PATL := @ATrousWL[1][y * MWidth + 1];
      for x := 1 to MWidth - 2 do
      begin
        za := 0;
        zp := PATL^;
        PATL2 := PWord(Integer(PATL) - MWidth * 2 - 2);
        for x2 := 0 to 7 do
        begin
          if PATL2^ >= zp then
          begin
            za := 0;
            Break;
          end
          else if PATL2^ > za then za := PATL2^;
          if (x2 = 2) or (x2 = 4) then Inc(PATL2, MWidth - 2) else
          if x2 = 3 then Inc(PATL2, 2) else Inc(PATL2);
        end;
        if za > 0 then PATL^ := za + 1;
        Inc(PATL);
      end;
    end;

    iStep  := 1;
    for ATl := 2 to ATlevelCount do
    begin
      iStep2      := iStep * 2;
      MWidth2step := MWidth * iStep2;
      Move(ATrousWL[ATl - 1][0], ATrousWL[ATl][0], MWidth * MHeight * 2);  

      for y := 0 to MHeight - 1 do   // first smooth in x direction
      begin
        x2    := y * MWidth;
        PATL  := @ATrousWL[ATl + 1][x2];
        PATL2 := @ATrousWL[ATl - 1][x2];
        zp    := PATL2^ + 1;
        for x := 1 to iStep do
        begin
          PATL^ := (PATL2^ + 1 + (zp + PWord(Integer(PATL2) + iStep2)^) shr 1) shr 1;
          Inc(PATL);
          Inc(PATL2);
        end;
        x2 := iStep2 + 1;
        if SupportMMX and (MWidth - iStep2 > 3) then
        asm
          push eax
          push ebx
          push ecx
          push esi
          push edi
          mov  ebx, iStep2
          mov  ecx, MWidth
          mov  esi, PATL2
          sub  ecx, ebx
          mov  edi, PATL
          shr  ecx, 2
          sub  esi, ebx
          mov  eax, ecx
          sub  edi, esi
          shl  eax, 2
          add  x2, eax
     @ll: movq  mm0, [esi]            // calculate 4 words at once
          pavgw mm0, [esi + ebx * 2]
          pavgw mm0, [esi + ebx]
          movq  [edi + esi], mm0
          add  esi, 8
          dec  ecx
          jnz  @ll
          add  edi, esi
          mov  PATL, edi
          add  esi, ebx
          mov  PATL2, esi
          pop  edi
          pop  esi
          pop  ecx
          pop  ebx
          pop  eax
        end;
        for x := x2 to MWidth do
        begin
          PATL^ := (PATL2^ + 1 + (PWord(Integer(PATL2) - iStep2)^ +
                              PWord(Integer(PATL2) + iStep2)^ + 1) shr 1) shr 1;
          Inc(PATL);
          Inc(PATL2);
        end;
        zp := PWord(Integer(PATL2) + (iStep - 1) * 2)^;
        for x := 1 to iStep do
        begin
          PATL^ := (PATL2^ + 1 + (PWord(Integer(PATL2) - iStep2)^ + zp) shr 1) shr 1;
          Inc(PATL);
          Inc(PATL2);
        end;
      end;
                                   // then smooth in y direction
      x2 := 0;
      while SupportMMX and (x2 < MWidth - 3) do
      begin
        PATL2 := @ATrousWL[ATl + 1][x2];
        PATL  := PATL2;
        for x := 0 to 3 do
        begin
          W4tmp[x] := PATL^;
          Inc(PATL);
        end;
        PATL := @ATrousWL[ATl + 1][x2 + (MHeight - 1) * MWidth];
        for x := 0 to 3 do
        begin
          W4tmp2[x] := PATL^;
          Inc(PATL);
        end;
        PATL := @ATrousWL[ATl][x2];
        asm
          push eax
          push ebx
          push ecx
          push edx
          push esi
          push edi
          movq mm1, W4tmp
          mov  ebx, MWidth2step
          mov  esi, PATL2
          mov  edi, PATL
          mov  ecx, iStep
          mov  edx, MWidth
          sub  esi, ebx
          add  edx, edx
          sub  edi, esi
          dec  ecx
     @l1: movq  mm0, [esi + ebx * 2]
          pavgw mm0, mm1
          pavgw mm0, [esi + ebx]
          movq  [edi + esi], mm0
          add  esi, edx
          dec  ecx
          jns  @l1
          mov  ecx, MHeight
          sub  ecx, iStep2
          dec  ecx
          js   @u2
     @l2: movq  mm0, [esi]
          pavgw mm0, [esi + ebx * 2]
          pavgw mm0, [esi + ebx]
          movq  [edi + esi], mm0
          add  esi, edx
          dec  ecx
          jns  @l2
     @u2:
          movq mm1, W4tmp2
          mov  ecx, iStep
          dec  ecx
     @l3: movq  mm0, [esi]
          pavgw mm0, mm1
          pavgw mm0, [esi + ebx]
          movq  [edi + esi], mm0
          add  esi, edx
          dec  ecx
          jns  @l3
          pop  edi
          pop  esi
          pop  edx
          pop  ecx
          pop  ebx
          pop  eax
        end;
        Inc(x2, 4);
      end;
      for x := x2 to MWidth - 1 do   
      begin
        PATL  := @ATrousWL[ATl][x];
        PATL2 := @ATrousWL[ATl + 1][x];
        zp    := PATL2^ + 1;
        for y := 1 to iStep do
        begin
          PATL^ := (PATL2^ + (zp + PWord(Integer(PATL2) + MWidth2step + 1)^) shr 1) shr 1;
          Inc(PATL, MWidth);
          Inc(PATL2, MWidth);
        end;
        for y := 1 to MHeight - iStep2 do
        begin
          PATL^ := (PATL2^ + 1 + (PWord(Integer(PATL2) - MWidth2step)^ +
                         PWord(Integer(PATL2) + MWidth2step)^ + 1) shr 1) shr 1;
          Inc(PATL, MWidth);
          Inc(PATL2, MWidth);
        end;
        zp := ATrousWL[ATl + 1][x + (MHeight - 1) * MWidth] + 1;
        for y := 1 to iStep do
        begin
          PATL^ := (PATL2^ + 1 + (PWord(Integer(PATL2) - MWidth2step)^ + zp) shr 1) shr 1;
          Inc(PATL, MWidth);
          Inc(PATL2, MWidth);
        end;
      end;
      iStep := iStep * 2;
    end;
    if SupportMMX then
    asm
      emms
    end;
end;

function fastIntArcTan2(y, x: Integer): Integer;  // intAngle 0..31
begin
    if y = 0 then
      Result := Integer(x >= 0) * 16
    else
    if x = 0 then
      Result := Integer(y >= 0) * 16 + 8
    else
    if y < 0 then
    begin
      if x < 0 then
      begin
        if x >= y then Result := 7 - (x * 4) div y
                  else Result := (y * 4) div x;
      end
      else
      begin
        if -y < x then Result := 15 + (y * 4) div x
                  else Result := 8 - (x * 4) div y;
      end;
    end
    else
    begin
      if x >= 0 then
      begin
        if x > y then Result := 16 + (y * 4) div x
                 else Result := 23 - (x * 4) div y;
      end
      else
      begin
        if y < -x then Result := 31 + (y * 4) div x
                  else Result := 24 - (x * 4) div y;
      end;
    end;
end;

{ TAmbShadowCalc }

procedure TAmbShadowCalc.Execute;
var x, y, x2, y2, ya, xa, xe, ye, xa2, xa2t, iRad: Integer;
    zp4: array[0..3] of Integer;
    PATL, PATL2: PWord;
    PS, PS2: PSingle;
    iMaxRad, iMinRad, iStep, iStep2, xt, ya2, id4c, x3, id4L: Integer;
    MultiC, do4, do4Lev: Boolean;
    ATl, iMinRadS, iMaxRadS, iAngC, MWidth, RadS, iC, ii, iLevNo: Integer;
    st, st2, R1d, RM: Single;
    PsiLight, PL2: TPsiLight3;
    AngMaxArr4: array[0..35, 0..3] of Single;
begin
  try
    x := 8064;
    asm  //  stmxcsr i
      stmxcsr x
    end; // if i<>$1f80 then i:=0;   //=8064

    MWidth  := ASCpar.aWidth;
    st2     := ASCpar.aZScaleFactor;
    for y := 0 to ASCpar.aHeight - 1 do
    begin
      ASCprogress[ASCpar.aThreadID] := y;
      PsiLight := ASCpar.aPsiLight;
      x        := ASCpar.aXStart;
      Inc(PsiLight, y * MWidth + x);
      while x <= ASCpar.aXEnd do
      begin
        zp4[0] := PsiLight^.Zpos;
        do4    := supportSSE and (x < ASCpar.aXEnd - 2);
        if do4 then
        begin
          PL2 := PsiLight;
          for x2 := 1 to 3 do
          begin
            Inc(PL2);
            zp4[x2] := PL2^.Zpos;
          end;
          id4c := 3;
        end
        else id4c := 0;
        if (zp4[0] < 32768) or
           (do4 and (Integer(zp4[1]) + zp4[2] + zp4[3] < 98304)) then
        begin
          for x2 := 0 to 35 do AngMaxArr4[x2, 0] := -1e10;
          if do4 then
            for x2 := 0 to 35 do
            begin
              AngMaxArr4[x2, 1] := -1e10;
              AngMaxArr4[x2, 2] := -1e10;
              AngMaxArr4[x2, 3] := -1e10;
            end;
          iMaxRad := 0;
          iMinRad := 0;
          for ATl := 1 to ASCpar.aATlevelCount do
          begin
            iStep    := 1 shl (ATl - 1);
            RM       := Sqrt(iStep) * 5;
            iMaxRad  := iMaxRad + 4 * iStep;
            iMaxRadS := iMaxRad * iMaxRad;
            iMinRadS := iMinRad * iMinRad;
            MultiC   := Round(RM / (iMinRad + 1)) > 0;

            ya := - iMaxRad;
            if ya + y < 0 then
            begin
              ya2 := ya;
              while ya2 + y < 0 do Inc(ya2, iStep);
              if ya2 + y >= ASCpar.aHeight then ya2 := ASCpar.aHeight - y - 1;
              ya := - y;
              if ya = ya2 then ya2 := $FFFFFF;
            end
            else ya2 := $FFFFFF;
            if y + iMaxRad >= ASCpar.aHeight then ye := ASCpar.aHeight - y - 1
                                             else ye := iMaxRad;

            do4Lev := do4 and (x >= iMaxRad) and (x < MWidth - iMaxRad - 3);
            if do4Lev then id4L := id4c else id4L := 0;
            xa  := - iMaxRad;
            xa2 := $FFFFFF;
            xe  := iMaxRad;

            y2   := ya;
            repeat
              if y2 > ya2 then
              begin
                y2  := ya2;
                ya2 := $FFFFFF;
              end;

              iLevNo := 0;
              repeat
                if not do4Lev then
                begin
                  x2 := x + iLevNo;
                  xa := - iMaxRad;
                  if xa + x2 < 0 then
                  begin
                    xa2 := xa;
                    while xa2 + x2 < 0 do Inc(xa2, iStep);
                    if xa2 + x2 >= MWidth then xa2 := MWidth - x2 - 1;
                    xa := - x2;
                    if xa = xa2 then xa2 := $FFFFFF;
                  end
                  else xa2 := $FFFFFF;
                  if x2 + iMaxRad >= MWidth then xe := MWidth - x2 - 1
                                            else xe := iMaxRad;
                end;

                PATL := @ATrousWL[ATl][x + xa + iLevNo + (y + y2) * MWidth];
                x2   := xa;
                xa2t := xa2;
                repeat
                  if (x2 > xa2t) then
                  begin
                    Inc(PATL, xa2t - x2);
                  x2   := xa2t;
                  xa2t := $FFFFFF;
                  end;
                  RadS := y2 * y2 + x2 * x2;
                  if (RadS > iMinRadS) and (RadS <= iMaxRadS) then
                  begin
                    iAngC := fastIntArcTan2(y2, x2);
                    if MultiC then
                    begin
                    {  if id4L = 3 then
                      asm
                        push  eax
                        push  ebx
                        push  ecx
                        push  esi
                        push  edi
                        movss    xmm7, RM
                        mov   esi, PATL
                        lea   edi, zp4
                        cvtsi2ss xmm4, RadS
                        movzx ax, [esi]
                        rsqrtss  xmm4, xmm4
                        movzx bx, [esi + 2]
                        mulss   xmm7, xmm4
                        sub   eax, [edi]
                        sub   ebx, [edi + 4]
                        cvtss2si ecx, xmm7        //iC
                        shufps   xmm4, xmm4, 0
                        cvtsi2ss xmm0, eax
                        cvtsi2ss xmm1, ebx
                        movzx ax, [esi + 4]
                        movzx bx, [esi + 6]
                        sub   eax, [edi + 8]
                        sub   ebx, [edi + 12]
                        cvtsi2ss xmm2, eax
                        cvtsi2ss xmm3, ebx
                        shufps   xmm0, xmm1, 0
                        shufps   xmm2, xmm3, 0
                        shufps   xmm0, xmm2, $88
                        mov   eax, iAngC
                        mov   ebx, ecx
                        shr   ebx, 1
                        sub   eax, ebx
                        and   eax, 31
                        add   eax, eax
                        lea   esi, [AngMaxArr4 + eax * 8]
                        mulps    xmm0, xmm4
                  @ll:  movups   xmm1, [esi]
                        maxps    xmm1, xmm0
                        movups   [esi], xmm1
                        add   esi, 16  
                        dec   ecx
                        jns   @ll
                        pop   edi
                        pop   esi
                        pop   ecx
                        pop   ebx
                        pop   eax
                      end
                      else
                      begin }
                        R1d   := 1 / Sqrt(RadS);
                        iC    := Round(RM * R1d);
                        PATL2 := PATL;
                        PS2   := @AngMaxArr4[(iAngC - (iC shr 1)) and 31, iLevNo];
                        for x3 := 0 to id4L do
                        begin
                          PS := PS2;
                          st := (PATL2^ - zp4[x3 + iLevNo]) * R1d;
                          for ii := 0 to iC do
                          begin
                            if PS^ < st then PS^ := st;
                            Inc(PS, 4);
                          end;
                          Inc(PATL2);
                          Inc(PS2);
                        end;
                   //   end;
                    end
                    else
                    begin
                    {  if id4L > 3 then
                      asm
                        push  eax
                        push  ebx
                        push  esi
                        push  edi
                        mov   esi, PATL
                        lea   edi, zp4
                        cvtsi2ss xmm4, RadS
                        movzx ax, [esi]
                        sqrtss  xmm4, xmm4
                        movzx bx, [esi + 2]
                        sub   eax, [edi]
                        sub   ebx, [edi + 4]
                        shufps   xmm4, xmm4, 0
                        cvtsi2ss xmm0, eax
                        cvtsi2ss xmm1, ebx
                        movzx ax, [esi + 4]
                        movzx bx, [esi + 6]
                        sub   eax, [edi + 8]
                        sub   ebx, [edi + 12]
                        cvtsi2ss xmm2, eax
                        cvtsi2ss xmm3, ebx
                        shufps   xmm0, xmm1, 0
                        shufps   xmm2, xmm3, 0
                        mov   eax, iAngC
                        shufps   xmm0, xmm2, $88
                        add   eax, eax
                        divps    xmm0, xmm4
                        movups   xmm1, dqword [AngMaxArr4 + eax * 8]
                        maxps    xmm1, xmm0
                        movups   dqword [AngMaxArr4 + eax * 8], xmm1
                        pop   edi
                        pop   esi
                        pop   ebx
                        pop   eax
                      end
                      else
                      begin  }
                        PATL2 := PATL;
                        R1d   := 1 / Sqrt(RadS);
                        for x3 := iLevNo to iLevNo + id4L do
                        begin
                          st := (PATL2^ - zp4[x3]) * R1d;
                          if AngMaxArr4[iAngC, x3] < st then
                            AngMaxArr4[iAngC, x3] := st;
                          Inc(PATL2);
                        end;
                    //  end;
                    end;
                  end;
                  xt := x2;
                  Inc(x2, iStep);
                  if (x2 > xe) and (xt < xe) then x2 := xe;
                  Inc(PATL, x2 - xt);
                until x2 > xe;

                Inc(iLevNo);
              until do4Lev or (iLevNo > id4c);

              Inc(y2, iStep);
              if (y2 > ye) and ((y2 - iStep) < ye) then y2 := ye;
            until y2 > ye;


            iMinRad := iMaxRad;
          end;
          PL2 := PsiLight;
          for x3 := 0 to id4c do
          begin
            for x2 := 0 to 3 do
              if AngMaxArr4[x2 + 32, x3] > AngMaxArr4[x2, x3] then
                AngMaxArr4[x2, x3] := AngMaxArr4[x2 + 32, x3];
            st := 0;
            for x2 := 0 to 31 do
              if AngMaxArr4[x2, x3] > -1e9 then
                st := st + ArcTan(AngMaxArr4[x2, x3] * st2);
            PL2^.AmbShadow := Max(0, Min(32767, Round(st * 500) + 10000));
            Inc(PL2);
          end;
        end;

        if do4 then
        begin
          Inc(PsiLight, 4);
          Inc(x, 4);
        end else begin
          Inc(PsiLight);
          Inc(x);
        end;
        if ASCstop then Break;
      end;
      if ASCstop then Break;
    end;
  finally
    Dec(AmbCalcThreadCount);
  end;
end;

end.
 