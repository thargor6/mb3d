unit AmbShadowCalcThreadN;

interface

uses
  Classes, TypeDefinitions, Windows;

type
  TAmbShadowCalc = class(TThread)
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;
  TAmbShadowCalcT0 = class(TThread)
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;
 { TAmbShadowCalcPano = class(TThread)
  private
  public
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;
  TAmbShadowCalcT0Pano = class(TThread)
  private
  public
    ASCpar: TASCparameter;
  protected
    procedure Execute; override;
  end;  }
function BuildATlevels(PsiLight, MWidth, MHeight: Integer; PATlevel: TPATlevel; var CorrMul: Single; var Zsub: Integer): Integer;
//function BuildATlevelsT0(PsiLight, MWidth, MHeight: Integer; PATlevel: TPATlevel; sZRT: Single): Integer;

//var RoughStat: array[0..255] of Integer;

implementation

uses Math, Mand, DivUtils, ImageProcess, SysUtils, Forms;


function BuildATlevels(PsiLight, MWidth, MHeight: Integer; PATlevel: TPATlevel; var CorrMul: Single; var Zsub: Integer): Integer;
var x, y, x2, zp, za: Integer;
    PATL, PATL2: PWord;
    ATl, iStep, iStep2, MWidth2step: Integer;
    W4tmp, W4tmp2: array[0..3] of Word;
    s1: Single;
begin
  try
    Result := 1;
    x := MWidth div 16;
    repeat
      Inc(Result);
      x := x shr 1;
    until (Result = 8) or (x < 4);
    za := Result;
    for x := 1 to Result + 1 do
    try
      SetLength(PATlevel[x], MWidth * MHeight);
    except
      Result := x - 2;
      Break;
    end;
    if Result < 1 then Exit;
    if Result < za then Mand3DForm.OutMessage('Only using ' + IntToStr(Result) +
        ' out of ' + IntToStr(za) + ' wavelet levels due to memory limitation.');

    PATL := PWord(PsiLight + 8);  //Zpos=+8  ZposfineByte=+7
    za := 32767;
    zp := 0;
    for x := 1 to MWidth * MHeight do
    begin
      if PATL^ < 32768 then
      begin
        if PATL^ > zp then zp := PATL^;
        if PATL^ < za then za := PATL^;
      end;
      Inc(PATL, 9);
    end;
    if zp < za then
    begin
      zp := 32768;
      za := 0;
    end
    else Inc(zp);
    s1 := 128 / (zp - za);
    za := za shl 8;
    Zsub := za;
    CorrMul := s1; //1 / (s1 * 256);

    PATL  := PWord(PsiLight + 8); //  Zpos=+8  ZposfineByte=+7
    PATL2 := @PATlevel[1][0];
    for x := 1 to MWidth * MHeight do
    begin
      if PATL^ < 32768 then
        PATL2^ := Round(((PInteger(Integer(PATL) - 2)^ shr 8) - za) * s1)
      else PATL2^ := 0;
      Inc(PATL, 9);
      Inc(PATL2);
    end;

    for y := 1 to MHeight - 2 do         //Median 3x3 midWeight=4 to blur out single false pixel
    begin
      PATL := @PATlevel[1][y * MWidth + 1];
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
    for ATl := 2 to Result do
    begin
      iStep2 := iStep * 2;
      MWidth2step := MWidth * iStep2;
      if SupportMMX then
      asm
        emms
      end;                                                                    //fp stack check error..  mmx used + fp in fastmove!
      FastMove(PATlevel[ATl - 1][0], PATlevel[ATl][0], MWidth * MHeight * 2); //in anipreview

      for y := 0 to MHeight - 1 do   // first smooth in x direction
      begin
        Application.ProcessMessages; //new
        x2    := y * MWidth;
        PATL  := @PATlevel[ATl + 1][x2];
        PATL2 := @PATlevel[ATl - 1][x2];
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
        PATL2 := @PATlevel[ATl + 1][x2];
        PATL  := PATL2;
        for x := 0 to 3 do
        begin
          W4tmp[x] := PATL^;
          Inc(PATL);
        end;
        PATL := @PATlevel[ATl + 1][x2 + (MHeight - 1) * MWidth];
        for x := 0 to 3 do
        begin
          W4tmp2[x] := PATL^;
          Inc(PATL);
        end;
        PATL := @PATlevel[ATl][x2];
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
      Application.ProcessMessages; //new
      for x := x2 to MWidth - 1 do   
      begin
        PATL  := @PATlevel[ATl][x];
        PATL2 := @PATlevel[ATl + 1][x];
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
        zp := PATlevel[ATl + 1][x + (MHeight - 1) * MWidth] + 1;
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
  except
    Result := 0;
  end;
end;

function fastIntArcTan2(y, x: Integer): Integer;  // intAngle 0..31
begin
    if x = 0 then
      Result := Integer(y >= 0) * 16 + 8
    else
    if y = 0 then
      Result := Integer(x >= 0) * 16
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

procedure TAmbShadowCalc.Execute;
var x, y, x2, y2, ya, xa, xe, ye, xa2, xa2t, iRad: Integer;
    zp4: array[0..3] of Integer;
    PATL, PATL2: PWord;
    PS, PS2: PSingle;
    iMaxRad, iMinRad, iStep, iStep2, xt, ya2, id4c, x3, id4L: Integer;
    MultiC, do4, do4Lev: Boolean;
    ATl, iMinRadS, iMaxRadS, iAngC, MWidth, RadS, iC, ii, iLevNo: Integer;
    st, st2, R1d, RM, sZRT, sMul, sZRTLev: Single;
    PsiLight, PL2: TPsiLight5;
    AngMaxArr4: array[0..35, 0..3] of Single;
begin
  try
    x := 8064;
    if supportSSE then
    asm
      stmxcsr x        //set roundingmode sse
    end; // if i<>$1f80 then i:=0;   //=8064 }
  //test
 // for x := 0 to 255 do RoughStat[x] := 0;
    if ASCpar.aZRThreshold < 0.01 then ASCpar.aZRThreshold := 0.01;
    MWidth := ASCpar.aWidth;
    st2    := ASCpar.aZScaleFactor / (ASCpar.aCorrMul * 256);
    y      := ASCpar.aYStart;
    sZRT   := ASCpar.aZRThreshold / st2;
  //  sMul   := 1.25 * 32767 / (Pi * 32 * Sqrt(ArcTan(ASCpar.aZRThreshold * Sqrt(ASCpar.aATlevelCount))));   //pi->16383..   ArcTan(ASCpar.aZRThreshold * Sqrt(ASCpar.aATlevelCount)) = max angle
    sMul   := 1.35 * 32767 / (Pi * 32 * Power(ArcTan(ASCpar.aZRThreshold * Sqrt(Sqrt(ASCpar.aATlevelCount))), 0.8));
    while y < ASCpar.aHeight do
    begin
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos := y;
      PsiLight := ASCpar.aPsiLight;
      x        := 0;
      Inc(PsiLight, y * MWidth);
      while x < MWidth do
      begin
        ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualXpos := x;
        if PsiLight.Zpos < 32768 then zp4[0] := Round(((PInteger(@PsiLight.RoughZposFine)^ shr 8) - ASCpar.aZsub) * ASCpar.aCorrMul)
                                 else zp4[0] := 32768;
        do4    := (x < MWidth - 3);
        if do4 then
        begin
          PL2 := PsiLight;
          for x2 := 1 to 3 do
          begin
            Inc(PL2);
            if PL2.Zpos < 32768 then zp4[x2] := Round(((PInteger(@PL2.RoughZposFine)^ shr 8) - ASCpar.aZsub) * ASCpar.aCorrMul)
                                else zp4[x2] := 32768;
          end;
          id4c := 3;
        end
        else id4c := 0;
        if (zp4[0] < 32768) or (do4 and (Integer(zp4[1]) + zp4[2] + zp4[3] < 98304)) then
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

            sZRTLev  := sZRT * Sqrt(Sqrt(ASCpar.aATlevelCount / ATl));  //new: THreshold depends on level -> less threshold in nearer parts

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

                PATL := @ASCpar.PATlevel[ATl][x + xa + iLevNo + (y + y2) * MWidth];
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
                      if (id4L = 3) and supportSSE then
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
                        movss    xmm5, sZRTLev //sZRT
                        rsqrtss  xmm4, xmm4
                        movzx eax, word [esi]
                        movzx ebx, word [esi + 2]
                        mulss    xmm7, xmm4
                        sub   eax, [edi]
                        sub   ebx, [edi + 4]
                        cvtss2si ecx, xmm7        //iC
                        shufps   xmm4, xmm4, 0    //R1d
                        cvtsi2ss xmm0, eax
                        cvtsi2ss xmm1, ebx
                        movzx eax, word [esi + 4]
                        movzx ebx, word [esi + 6]
                        sub   eax, [edi + 8]
                        sub   ebx, [edi + 12]
                        cvtsi2ss xmm2, eax
                        cvtsi2ss xmm3, ebx
                        shufps   xmm0, xmm1, 0
                        shufps   xmm2, xmm3, 0
                        shufps   xmm5, xmm5, 0
                        shufps   xmm0, xmm2, $88
                        mov   eax, iAngC
                        mov   ebx, ecx
                        shr   ebx, 1
                        sub   eax, ebx
                        and   eax, 31
                        add   eax, eax
                        mulps    xmm0, xmm4
                        lea   esi, [AngMaxArr4 + eax * 8]
                        minps    xmm0, xmm5
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
                      begin
                        R1d   := 1 / Sqrt(RadS);
                        iC    := Round(RM * R1d);
                        PATL2 := PATL;
                        PS2   := @AngMaxArr4[(iAngC - (iC shr 1)) and 31, iLevNo];
                        for x3 := 0 to id4L do
                        begin
                          PS := PS2;
                          st := (PATL2^ - zp4[x3 + iLevNo]) * R1d;
                          if st > sZRTLev then st := sZRTLev;
                          for ii := 0 to iC do
                          begin
                            if PS^ < st then PS^ := st;
                            Inc(PS, 4);
                          end;
                          Inc(PATL2);
                          Inc(PS2);
                        end;
                      end;
                    end
                    else
                    begin
                      if (id4L = 3) and supportSSE then
                      asm
                        push  eax
                        push  ebx
                        push  esi
                        push  edi
                        mov   esi, PATL
                        lea   edi, zp4
                        cvtsi2ss xmm4, RadS
                        movzx eax, word [esi]
                        movzx ebx, word [esi + 2]
                        sub   eax, [edi]
                        sub   ebx, [edi + 4]
                        shufps   xmm4, xmm4, 0
                        movss    xmm5, sZRTLev
                        cvtsi2ss xmm0, eax
                        cvtsi2ss xmm1, ebx
                        rsqrtps  xmm4, xmm4       //only 4..6 clocks, not slower than scalar
                        movzx eax, word [esi + 4]
                        movzx ebx, word [esi + 6]
                        sub   eax, [edi + 8]
                        sub   ebx, [edi + 12]
                        cvtsi2ss xmm2, eax
                        cvtsi2ss xmm3, ebx
                        shufps   xmm5, xmm5, 0
                        shufps   xmm0, xmm1, 0
                        shufps   xmm2, xmm3, 0
                        mov   eax, iAngC
                        shufps   xmm0, xmm2, $88
                        add   eax, eax
                        mulps    xmm0, xmm4
                        movups   xmm1, dqword [AngMaxArr4 + eax * 8]
                        minps    xmm0, xmm5
                        maxps    xmm1, xmm0
                        movups   dqword [AngMaxArr4 + eax * 8], xmm1
                        pop   edi
                        pop   esi
                        pop   ebx
                        pop   eax
                      end
                      else
                      begin
                        PATL2 := PATL;
                        R1d   := 1 / Sqrt(RadS);
                        for x3 := iLevNo to iLevNo + id4L do
                        begin
                          st := (PATL2^ - zp4[x3]) * R1d;
                          if st > sZRTLev then st := sZRTLev;
                          if AngMaxArr4[iAngC, x3] < st then
                            AngMaxArr4[iAngC, x3] := st;
                          Inc(PATL2);
                        end;
                      end;
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
            PL2^.AmbShadow := Max(0, Min(16383{32767}, Round(st * sMul) {+ 16383})); //10000?
          //Test
        //  Inc(RoughStat[PL2^.AmbShadow shr 8]);
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
  {
procedure TAmbShadowCalcPano.Execute;
var x, y, x2, y2, ya, xa, xe, ye, xa2, xa2t, iRad: Integer;
    zp4: array[0..3] of Integer;
    PATL, PATL2: PWord;
    PS, PS2: PSingle;
    iMaxRad, iMinRad, iStep, iStep2, xt, ya2, id4c, x3, id4L: Integer;
    MultiC, do4, do4Lev: Boolean;
    ATl, iMinRadS, iMaxRadS, iAngC, MWidth, RadS, iC, ii, iLevNo: Integer;
    st, st2, R1d, RM, sZRT, sMul, sZRTLev: Single;
    PsiLight, PL2: TPsiLight5;
    AngMaxArr4: array[0..35, 0..3] of Single;
begin
  try
    x := 8064;
    if supportSSE then
    asm
      stmxcsr x    //set roundingmode sse
    end;
    if ASCpar.aZRThreshold < 0.01 then ASCpar.aZRThreshold := 0.01;
    MWidth := ASCpar.aWidth;
    st2    := ASCpar.aZScaleFactor / (ASCpar.aCorrMul * 256);
    y      := ASCpar.aYStart;
    sZRT   := ASCpar.aZRThreshold / st2;
    sMul   := 1.35 * 32767 / (Pi * 32 * Power(ArcTan(ASCpar.aZRThreshold * Sqrt(Sqrt(ASCpar.aATlevelCount))), 0.8));
    while y < ASCpar.aHeight do
    begin
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos := y;
      PsiLight := ASCpar.aPsiLight;
      x        := 0;
      Inc(PsiLight, y * MWidth);
      while x < MWidth do
      begin
        ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualXpos := x;
        if PsiLight.Zpos < 32768 then zp4[0] := Round(((PInteger(@PsiLight.RoughZposFine)^ shr 8) - ASCpar.aZsub) * ASCpar.aCorrMul)
                                 else zp4[0] := 32768;
        do4    := (x < MWidth - 3);
        if do4 then
        begin
          PL2 := PsiLight;
          for x2 := 1 to 3 do
          begin
            Inc(PL2);
            if PL2.Zpos < 32768 then zp4[x2] := Round(((PInteger(@PL2.RoughZposFine)^ shr 8) - ASCpar.aZsub) * ASCpar.aCorrMul)
                                else zp4[x2] := 32768;
          end;
          id4c := 3;
        end
        else id4c := 0;
        if (zp4[0] < 32768) or (do4 and (Integer(zp4[1]) + zp4[2] + zp4[3] < 98304)) then
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

            sZRTLev  := sZRT * Sqrt(Sqrt(ASCpar.aATlevelCount / ATl));  //new: THreshold depends on level -> less threshold in nearer parts

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

                PATL := @ASCpar.PATlevel[ATl][x + xa + iLevNo + (y + y2) * MWidth];
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
                      if (id4L = 3) and supportSSE then
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
                        movss    xmm5, sZRTLev //sZRT
                        rsqrtss  xmm4, xmm4
                        movzx eax, word [esi]
                        movzx ebx, word [esi + 2]
                        mulss    xmm7, xmm4
                        sub   eax, [edi]
                        sub   ebx, [edi + 4]
                        cvtss2si ecx, xmm7        //iC
                        shufps   xmm4, xmm4, 0    //R1d
                        cvtsi2ss xmm0, eax
                        cvtsi2ss xmm1, ebx
                        movzx eax, word [esi + 4]
                        movzx ebx, word [esi + 6]
                        sub   eax, [edi + 8]
                        sub   ebx, [edi + 12]
                        cvtsi2ss xmm2, eax
                        cvtsi2ss xmm3, ebx
                        shufps   xmm0, xmm1, 0
                        shufps   xmm2, xmm3, 0
                        shufps   xmm5, xmm5, 0
                        shufps   xmm0, xmm2, $88
                        mov   eax, iAngC
                        mov   ebx, ecx
                        shr   ebx, 1
                        sub   eax, ebx
                        and   eax, 31
                        add   eax, eax
                        mulps    xmm0, xmm4
                        lea   esi, [AngMaxArr4 + eax * 8]
                        minps    xmm0, xmm5
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
                      begin
                        R1d   := 1 / Sqrt(RadS);
                        iC    := Round(RM * R1d);
                        PATL2 := PATL;
                        PS2   := @AngMaxArr4[(iAngC - (iC shr 1)) and 31, iLevNo];
                        for x3 := 0 to id4L do
                        begin
                          PS := PS2;
                          st := (PATL2^ - zp4[x3 + iLevNo]) * R1d;
                          if st > sZRTLev then st := sZRTLev;
                          for ii := 0 to iC do
                          begin
                            if PS^ < st then PS^ := st;
                            Inc(PS, 4);
                          end;
                          Inc(PATL2);
                          Inc(PS2);
                        end;
                      end;
                    end
                    else
                    begin
                      if (id4L = 3) and supportSSE then
                      asm
                        push  eax
                        push  ebx
                        push  esi
                        push  edi
                        mov   esi, PATL
                        lea   edi, zp4
                        cvtsi2ss xmm4, RadS
                        movzx eax, word [esi]
                        movzx ebx, word [esi + 2]
                        sub   eax, [edi]
                        sub   ebx, [edi + 4]
                        shufps   xmm4, xmm4, 0
                        movss    xmm5, sZRTLev
                        cvtsi2ss xmm0, eax
                        cvtsi2ss xmm1, ebx
                        rsqrtps  xmm4, xmm4       //only 4..6 clocks, not slower than scalar
                        movzx eax, word [esi + 4]
                        movzx ebx, word [esi + 6]
                        sub   eax, [edi + 8]
                        sub   ebx, [edi + 12]
                        cvtsi2ss xmm2, eax
                        cvtsi2ss xmm3, ebx
                        shufps   xmm5, xmm5, 0
                        shufps   xmm0, xmm1, 0
                        shufps   xmm2, xmm3, 0
                        mov   eax, iAngC
                        shufps   xmm0, xmm2, $88
                        add   eax, eax
                        mulps    xmm0, xmm4
                        movups   xmm1, dqword [AngMaxArr4 + eax * 8]
                        minps    xmm0, xmm5
                        maxps    xmm1, xmm0
                        movups   dqword [AngMaxArr4 + eax * 8], xmm1
                        pop   edi
                        pop   esi
                        pop   ebx
                        pop   eax
                      end
                      else
                      begin
                        PATL2 := PATL;
                        R1d   := 1 / Sqrt(RadS);
                        for x3 := iLevNo to iLevNo + id4L do
                        begin
                          st := (PATL2^ - zp4[x3]) * R1d;
                          if st > sZRTLev then st := sZRTLev;
                          if AngMaxArr4[iAngC, x3] < st then
                            AngMaxArr4[iAngC, x3] := st;
                          Inc(PATL2);
                        end;
                      end;
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
            PL2^.AmbShadow := Max(0, Min(16383, Round(st * sMul))); //10000?
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
end;  }
                 //not used:
function BuildATlevelsT0(PsiLight, MWidth, MHeight: Integer; PATlevel: TPATlevel; sZRT: Single): Integer;
var x, y, x2, xa, iwids: Integer;
    PATL, PATL2: PWord;
    ATl, iStep, iStep2, MWidth2step: Integer;
    it1, it2, it3, iTh: Integer;
    iTh4, sub32k: array[0..3] of Word;
begin
    sub32k[0] := 32768;
    sub32k[1] := 32768;
    sub32k[2] := 32768;
    sub32k[3] := 32768;
    Result := 1;
    x := MWidth div 16;
    repeat
      Inc(Result);
      x := x shr 1;
    until (Result = 8) or (x < 4);
    x2 := Result;
    for x := 1 to Result + 1 do
    begin
      try
        SetLength(PATlevel[x], MWidth * MHeight);
      except
        Result := x - 2;
      end;
      if Result < x2 then Break;
    end;
    if Result < 1 then Exit;
    if Result < x2 then Mand3DForm.OutMessage('Only using ' + IntToStr(Result) +
       ' out of ' + IntToStr(x2) + ' wavelet levels due to memory limitation.');

    PATL  := PWord(PsiLight + 8);  //Zpos=+8  ZposfineByte=+7
    PATL2 := @PATlevel[1][0];
    for x := 0 to MWidth * MHeight - 1 do
    begin
      if PATL^ < 32768 then PATL2^ := PATL^ else PATL2^ := 0;
      Inc(PATL, 9);
      Inc(PATL2);
    end;

    iStep  := 1;                    //with threshold = maxclip
    for ATl := 2 to Result do
    begin
      iStep2      := iStep * 2;
      MWidth2step := MWidth * iStep2;
      FastMove(PATlevel[ATl - 1][0], PATlevel[ATl][0], MWidth * MHeight * 2);    //PATlevel = array[1..9] of array of Word;

      iTh := Round(sZRT * iStep);
      iTh4[0] := Min(32768, iTh);
      iTh4[1] := iTh4[0];
      iTh4[2] := iTh4[0];
      iTh4[3] := iTh4[0];
      iwids := MWidth - iStep;
    //  iwidsm := iwids - 3;
      for y := 0 to MHeight - 1 do   // first smooth in x direction  + Threshold to dZ/dR
      begin
        x2    := y * MWidth;
        PATL  := @PATlevel[ATl + 1][x2];
        PATL2 := @PATlevel[ATl - 1][x2];
        it1   := PATL2^;
        it2   := PWord(Integer(PATL2) + MWidth - 1)^;
        for x := 1 to iStep do
        begin
          if x < iwids then it2 := PWord(Integer(PATL2) + iStep2)^;
          if it1 > PATL2^ + iTh then it1 := PATL2^ + iTh;
          if it2 > PATL2^ + iTh then it2 := PATL2^ + iTh;
          it3 := (it1 + it2 + 1) shr 1;
          PATL^ := (PATL2^ + it3) shr 1;
          Inc(PATL);
          Inc(PATL2);
        end;
        xa := iStep + 1;
        if SupportMMX then   //   doesnt work for some reasons?
        asm
          push eax
          push ebx
          push ecx
          push edx
          mov  ecx, xa
          mov  edx, PATL2
          mov  eax, iStep2
          add  ecx, 4
          mov  ebx, PATL
          sub  edx, eax
     @@1: cmp  ecx, iwids
          jg   @@3
          movq   mm4, [edx + eax]      
          movq   mm1, [edx]            //it1
          paddw  mm4, iTh4             //PATL2^ + iTh
          psubw  mm4, sub32k
          movq   mm2, [edx + eax * 2]  //it2
          psubw  mm1, sub32k
          psubw  mm2, sub32k
          pminsw mm1, mm4              //only signed word, therefore first sub, afterwards add
          pminsw mm2, mm4
          paddw  mm1, sub32k
          paddw  mm2, sub32k
          pavgw  mm1, mm2              //Average unsigned words
          pavgw  mm1, [edx + eax]
          movq   [ebx], mm1
          add  ebx, 8
          add  edx, 8
          add  ecx, 4
          jmp  @@1
     @@3: sub  ecx, 4
          add  edx, eax
          mov  xa, ecx
          mov  PATL, ebx
          mov  PATL2, edx
          pop  edx
          pop  ecx
          pop  ebx
          pop  eax
        end;  // xa
        for x := xa to MWidth do
        begin
          if x > iStep then it1 := PWord(Integer(PATL2) - iStep2)^;
          if x < iwids then it2 := PWord(Integer(PATL2) + iStep2)^;
          if it1 > PATL2^ + iTh then it1 := PATL2^ + iTh;
          if it2 > PATL2^ + iTh then it2 := PATL2^ + iTh;
          it3 := (it1 + it2 + 1) shr 1;
          PATL^ := (PATL2^ + it3) shr 1;
          Inc(PATL);
          Inc(PATL2);
        end;
      end;
      iwids := MHeight - iStep;
      for x := 0 to MWidth - 1 do   // then smooth in y direction
      begin
        PATL  := @PATlevel[ATl][x];
        PATL2 := @PATlevel[ATl + 1][x];
        it1   := PATL2^;
        it2   := PWord(Integer(PATL2) + (MHeight - 1) * MWidth * 2)^;
        for y := 1 to MHeight do
        begin
          if y > iStep then it1 := PWord(Integer(PATL2) - MWidth2step)^;
          if y < iwids then it2 := PWord(Integer(PATL2) + MWidth2step)^;
          if it1 > PATL2^ + iTh then it1 := PATL2^ + iTh;
          if it2 > PATL2^ + iTh then it2 := PATL2^ + iTh;
          it3 := (it1 + it2 + 1) shr 1;
          PATL^ := (PATL2^ + it3) shr 1;
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


{ TAmbShadowCalcT0}

procedure TAmbShadowCalcT0.Execute;
var x, y, x2, y2, ya, xa, xe, ye, xa2, xa2t, iRad: Integer;
    zp4: array[0..3] of Integer;
    PATL, PATL2: PWord;
    PS, PS2: PSingle;
    iMaxRad, iMinRad, iStep, iStep2, xt, ya2, id4c, x3, id4L: Integer;
    MultiC, do4, do4Lev: Boolean;
    ATl, iMinRadS, iMaxRadS, iAngC, MWidth, RadS, iC, ii, iLevNo: Integer;
    st, st2, st3, R1d, RM, sZRT, sZRTLev, sMul: Single;
    PsiLight, PL2: TPsiLight5;
    AngMaxArr4: array[0..35, 0..3] of Single;
begin
  try
    x := 8064;
    if supportSSE then
    asm
      stmxcsr x
    end; // if i<>$1f80 then i:=0;   //=8064 }
  //test
//  for x := 0 to 255 do RoughStat[x] := 0;
    if ASCpar.aZRThreshold < 0.01 then ASCpar.aZRThreshold := 0.01;
    MWidth := ASCpar.aWidth;
    st2    := ASCpar.aZScaleFactor / (ASCpar.aCorrMul * 256); 
    y      := ASCpar.aYStart;
    sZRT   := Max(0.01, ASCpar.aZRThreshold * 2 / st2);
 //   sMul := 1.5 * 32767 / (Pi * 32 * ArcTan(ASCpar.aZRThreshold * Sqrt(ASCpar.aATlevelCount)));
 //   sMul := 1.25 * 32767 / (Pi * 32 * Sqrt(ArcTan(ASCpar.aZRThreshold * Sqrt(ASCpar.aATlevelCount))));
    sMul   := 1.35 * 32767 / (Pi * 32 * Power(ArcTan(ASCpar.aZRThreshold * 0.8 * Sqrt(Sqrt(ASCpar.aATlevelCount))), 0.9));
    while y < ASCpar.aHeight do
    begin
      ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualYpos := y;
      PsiLight := ASCpar.aPsiLight;
      x        := 0;
      Inc(PsiLight, y * MWidth);
      while x < MWidth do
      begin
        ASCpar.aPCTS.CTrecords[ASCpar.aThreadID].iActualXpos := x;
        if PsiLight.Zpos < 32768 then zp4[0] := Round(((PInteger(@PsiLight.RoughZposFine)^ shr 8) - ASCpar.aZsub) * ASCpar.aCorrMul)
                                 else zp4[0] := 32768;
        do4 := (x < MWidth - 3);
        if do4 then
        begin
          PL2 := PsiLight;
          for x2 := 1 to 3 do
          begin
            Inc(PL2);
            zp4[x2] := PL2^.Zpos;
            if PL2.Zpos < 32768 then zp4[x2] := Round(((PInteger(@PL2.RoughZposFine)^ shr 8) - ASCpar.aZsub) * ASCpar.aCorrMul)
                                else zp4[x2] := 32768;
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

            sZRTLev  := sZRT * Sqrt(Sqrt(ASCpar.aATlevelCount / ATl));

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

                PATL := @ASCpar.PATlevel[ATl][x + xa + iLevNo + (y + y2) * MWidth];
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
                      if (id4L = 3) and supportSSE then
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
                        movss    xmm5, sZRTLev
                        rsqrtss  xmm4, xmm4
                        movzx eax, word [esi]          
                        movzx ebx, word [esi + 2]
                        mulss    xmm7, xmm4
                        sub   eax, [edi]
                        sub   ebx, [edi + 4]
                        cvtss2si ecx, xmm7        //iC
                        shufps   xmm4, xmm4, 0    //R1d
                        cvtsi2ss xmm0, eax
                        cvtsi2ss xmm1, ebx
                        movzx eax, word [esi + 4]
                        movzx ebx, word [esi + 6]
                        sub   eax, [edi + 8]
                        sub   ebx, [edi + 12]
                        cvtsi2ss xmm2, eax
                        cvtsi2ss xmm3, ebx
                        shufps   xmm0, xmm1, 0
                        shufps   xmm2, xmm3, 0
                        shufps   xmm5, xmm5, 0
                        shufps   xmm0, xmm2, $88
                        mov   eax, iAngC
                        mov   ebx, ecx
                        shr   ebx, 1
                        sub   eax, ebx
                        and   eax, 31
                        add   eax, eax
                        mulps    xmm0, xmm4
                        minps    xmm0, xmm5
                        rcpps    xmm2, xmm5     //approx 1/x
                        lea   esi, [AngMaxArr4 + eax * 8]
                        mulps    xmm2, xmm0
                        movaps   xmm4, xmm2
                        mulps    xmm2, xmm2
                        mulps    xmm2, xmm4
                        mulps    xmm2, xmm0
                        subps    xmm0, xmm2
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
                      begin
                        R1d   := 1 / Sqrt(RadS);
                        iC    := Round(RM * R1d);
                        PATL2 := PATL;
                        PS2   := @AngMaxArr4[(iAngC - (iC shr 1)) and 31, iLevNo];
                        for x3 := 0 to id4L do
                        begin
                          PS := PS2;
                          st := (PATL2^ - zp4[x3 + iLevNo]) * R1d;
                          if st < sZRTLev then
                          begin
                            st3 := st / sZRTLev;
                            st := st * (1 - st3 * st3 * st3);
                            for ii := 0 to iC do
                            begin
                              if PS^ < st then PS^ := st;
                              Inc(PS, 4);
                            end;
                          end;
                          Inc(PATL2);
                          Inc(PS2);
                        end;
                      end;
                    end
                    else
                    begin
                      if (id4L = 3) and supportSSE then
                      asm
                        push  eax
                        push  ebx
                        push  esi
                        push  edi
                        mov   esi, PATL
                        lea   edi, zp4
                        cvtsi2ss xmm4, RadS
                        movzx eax, word [esi]
                        movzx ebx, word [esi + 2]
                        sub   eax, [edi]
                        sub   ebx, [edi + 4]
                        shufps   xmm4, xmm4, 0
                        movss    xmm5, sZRTLev
                        cvtsi2ss xmm0, eax
                        cvtsi2ss xmm1, ebx
                        rsqrtps  xmm4, xmm4       //only 4..6 clocks, not slower than scalar
                        movzx eax, word [esi + 4]
                        movzx ebx, word [esi + 6]
                        sub   eax, [edi + 8]
                        sub   ebx, [edi + 12]
                        cvtsi2ss xmm2, eax
                        cvtsi2ss xmm3, ebx
                        shufps   xmm5, xmm5, 0
                        shufps   xmm0, xmm1, 0
                        shufps   xmm2, xmm3, 0
                        mov   eax, iAngC
                        shufps   xmm0, xmm2, $88
                        add   eax, eax
                        mulps    xmm0, xmm4
                        minps    xmm0, xmm5
                        movups   xmm1, dqword [AngMaxArr4 + eax * 8]
                        rcpps    xmm2, xmm5
                        mulps    xmm2, xmm0
                        movaps   xmm4, xmm2
                        mulps    xmm2, xmm2
                        mulps    xmm2, xmm4
                        mulps    xmm2, xmm0
                        subps    xmm0, xmm2
                   @up: maxps    xmm1, xmm0
                        movups   dqword [AngMaxArr4 + eax * 8], xmm1
                        pop   edi
                        pop   esi
                        pop   ebx
                        pop   eax
                      end
                      else 
                      begin
                        PATL2 := PATL;
                        R1d   := 1 / Sqrt(RadS);
                        for x3 := iLevNo to iLevNo + id4L do
                        begin
                          st := (PATL2^ - zp4[x3]) * R1d;
                          if st < sZRTLev then
                          begin
                            st3 := st / sZRTLev;
                            st := st * (1 - st3 * st3 * st3);
                            if AngMaxArr4[iAngC, x3] < st then
                              AngMaxArr4[iAngC, x3] := st;
                          end;
                          Inc(PATL2);
                        end;
                      end;
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
       //     PL2^.AmbShadow := Max(0, Min(32767, Round(st * sMul) + 10000));
            PL2^.AmbShadow := Max(0, Min(16383, Round(st * sMul)));
          //Test
     //     Inc(RoughStat[PL2^.AmbShadow shr 8]);
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
 