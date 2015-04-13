unit DOF;

interface

uses TypeDefinitions;

type
     TSortItem = packed record
       iZ: Integer;
       wX, wY: Word;
     end;
     TPSortItem = ^TSortItem;
     TDoFrec = record
       SL: TPSiLight5;
       colSL: PCardinal;
       MHeader: TPMandHeader10;
       pass, SLoffset: Integer;
       Verbose: LongBool;
     end;

procedure doDOF(DoFrec: TDoFrec);
procedure doDOFsort(DoFrec: TDoFrec);
procedure QuickSortInt(count: Integer; var List: array of TSortItem);

implementation

uses Forms, Controls, DivUtils, Mand, ImageProcess, Math, Math3D, Windows;

{procedure doDOF(DoFrec: TDoFrec);  //New test: simulate many lightrays from cam to object/backgound on Zbuf, 1pass without buf..
var x, y, xx, yy, r, r2, RayCount, RRowCount, RRays: Integer;                                        //-> color buf only
    SL2: TPSiLight5;
    ColSL, ColSL2: PCardinal;
    ColBuf: array of Cardinal;
    Zcorr, ZcMul, ZZstmitDif: Double;
    sR, sG, sB, sRadius, SM, SRowMul: Single;
begin
    try
      CalcPPZvals(DoFrec.MHeader^, Zcorr, ZcMul, ZZstmitDif);
      with DoFrec.MHeader^ do
      begin
        sDOFradius := MinMaxCS(0, sDOFradius, 4000);
        case (bCalcDOFtype shr 1) and 3 of
          0:  sRadius := sDOFradius;
          1:  sRadius := sDOFradius *  0.3 * (DoFrec.pass * 1.5 + 1);
        else  sRadius := sDOFradius / 6 * (1 shl DoFrec.pass);
        end;
        RRowCount := Round(sRadius + 0.51);
        SRowMul := sRadius / RRowCount;
        SetLength(ColBuf, Width * Height);

        ZcMul := 1 / ZcMul;
        Zcorr := 32767 * dStepWidth / (Zcorr * (dZend - dZstart));
        SM    := sDOFZsharp * dStepWidth * Width / (dZend - dZstart);

      {  SL2 := DoFrec.SL;
        xx := 0;
        for x := 1 to Width * Height do     //find nearest pixel
        begin
          if SL2.Zpos < 32768 then if SL2.Zpos > xx then xx := SL2.Zpos;
          Inc(SL2);
        end; }

    {    for y := 0 to Height - 1 do
        begin
          ColSL2 := PCardinal(Integer(DoFrec.colSL) + DoFrec.SLoffset * y);
          ColSL := @ColBuf[y * Width];
          if DoFrec.Verbose then Mand3DForm.ProgressBar1.Position := y;
          Application.ProcessMessages;
          if MCalcStop then Exit;
          for x := 1 to Width do
          begin
            sR := 0;
            sG := 0;
            sB := 0;
            RayCount := 0;
            for r := 0 to RRowCount do
            begin

              for r2 := 1 to RRays do
              begin


              end;
            end;
            if RayCount > 0 then SM := 1 / RayCount else SM := 0;
            ColSL^ := Round(sR * SM) + Round(sG * SM) shl 8 + Round(sB * SM) shl 16;
            Inc(ColSL2);
            Inc(ColSL);
          end;
        end;
        ColSL := DoFrec.colSL;
        for x := 0 to Width * Height - 1 do
        begin
          ColSL^ := ColBuf[x];
          Inc(ColSL);
        end;
        if DoFrec.Verbose then UpdateScaledImage(0, (Height - 1) div ImageScale);
      end;
    finally
      if Length(ColBuf) < DoFrec.MHeader.Width * DoFrec.MHeader.Height then
        Mand3DForm.OutMessage('Not enough memory, DoF aborted.');
      SetLength(ColBuf, 0);
    end;
end;  }

                                     //forward trafo, add spreaded pixel to buf, to nearer pixel downweighted with respect to nearer focus or not at all?
procedure doDOF(DoFrec: TDoFrec);
var x, y, r, xa, ya, xe, ye, yy, xx, lp: Integer;
    SL2: TPSiLight5;
    colSL2: PCardinal;
    Zcorr, ZcMul, ZZstmitDif: Double;
    rgbSV: TSVec;
    RBuf, TranspBuf, ColBuf: array of Single;
    pS1, pS2, pS3, pS4, pS5, pS6: PSingle;
    SM, w, sw, sMs, sRadius, sMaxR, Ap, DEstopFactor, Zsharp, Rsub: Single;
begin
    try
      CalcPPZvals(DoFrec.MHeader^, Zcorr, ZcMul, ZZstmitDif);
      with DoFrec.MHeader^ do
      begin
        sDOFaperture := MinMaxCS(0.0001, sDOFaperture, 2);
        sDOFclipR := MinMaxCS(0.1, sDOFclipR, 1000);
        lp := (bCalcDOFtype shr 1) and 3;
        case lp of
          0:  Ap := sDOFaperture * 0.5;
          1:  Ap := sDOFaperture * (0.3 + DoFrec.pass * 0.55) * 0.5;      //was: 0.3 + 0.65, now 0.25 + 0.83
        else  Ap := sDOFaperture / 12 * (1 shl DoFrec.pass);    // 3pass: 1/11 + 3/11 + 9/11    was: 1/6 + 2/6 + 4/6 radius
        end;
        DEstopFactor := MaxCD(0, dFOVy * Pid180) / Height;
        ZcMul := 1 / ZcMul;
        Zcorr := 1 / Zcorr;

        sw := MinCS(sDOFZsharp, sDOFZsharp2) * Width;
        sMs := MaxCS(sDOFZsharp, sDOFZsharp2) * Width;
        w := (1 + sw * DEstopFactor) / (1 + sMs * DEstopFactor);
        Zsharp := (w * sMs + sw) / (1 + w);
        Rsub := Abs((sw - Zsharp) / (1 + sw * DEstopFactor) * Ap);  //calc r at sDOFZsharp

        SetLength(RBuf, Width * Height);         //4bytes
        SetLength(TranspBuf, Width * Height);    //4bytes
        SetLength(ColBuf, Width * Height * 3);   //12bytes
        if Length(ColBuf) < Width * Height * 3 then
        begin
          Mand3DForm.OutMessage('Not enough memory, DoF aborted.');
          Exit;
        end;
        pS1 := @RBuf[0];
        pS2 := @TranspBuf[0];
        pS3 := @ColBuf[0];
        SL2 := DoFrec.SL;
        sMaxR := 0;
        sMs := (Sqr(8388353 * ZcMul + 1) - 1) * Zcorr;
        for x := 1 to Width * Height do     //calc blur radius
        begin
          if SL2.Zpos > 32767 then w := sMs else
          w := (Sqr((8388352 - (PInteger(@SL2.RoughZposFine)^ shr 8)) * ZcMul + 1) - 1) * Zcorr;
          pS1^ := (w - Zsharp) / (1 + w * DEstopFactor) * Ap;
          pS1^ :=  Max0S(Abs(pS1^) - Rsub) * Sign(pS1^);  //new
          if Abs(pS1^) > sDOFclipR then pS1^ := sDOFclipR * Sign(pS1^);
          if Abs(pS1^) > sMaxR then sMaxR := Abs(pS1^); 
          pS2^ := 0;
          pS3^ := 0;
          Inc(pS3);
          pS3^ := 0;
          Inc(pS3);
          pS3^ := 0;
          Inc(pS3);
          Inc(pS1);
          Inc(pS2);
          Inc(SL2);
        end;
        SM  := 1 / (1 + sMaxR);
        pS1 := @RBuf[0];
        pS2 := @TranspBuf[0];
        pS3 := @ColBuf[0];
        for y := 0 to Height - 1 do
        begin
          colSL2 := PCardinal(Integer(DoFrec.colSL) + DoFrec.SLoffset * y);
          if DoFrec.Verbose then Mand3DForm.ProgressBar1.Position := y;
          Application.ProcessMessages;
          if MCalcStop then Exit;
          for x := 1 to Width do
          begin
            sMs := Sqr(Abs(pS1^) + 1);
            rgbSV := ColToSVecNoScale(colSL2^);
            sw := 0.5 / sMs;
            r := Round(Abs(pS1^) + 0.5);
            if r >= x then xa := 1 - x else xa := -r;
            if r + x > Width then xe := Width - x else xe := r;
            if r > y then ya := -y else ya := -r;
            if r + y >= Height then ye := Height - y - 1 else ye := r;
            lp  := Width - xe + xa - 1;
            yy  := (ya * Width + xa) * 4;
            pS4 := PSingle(Integer(pS2) + yy);
            pS5 := PSingle(Integer(pS3) + yy * 3);
            pS6 := PSingle(Integer(pS1) + yy);
            for yy := ya to ye do
            begin
              for xx := xa to xe do
              begin
                w := sMs - Sqr(xx) - Sqr(yy);
                if w > 0 then
                begin
                  if w > 1 then w := 1;
                  if pS6^ >= pS1^ then w := w * sw
                                  else w := w * sw * Abs(pS6^) * SM;
                  pS4^ := pS4^ + w;
                  AddSVecWeightS(TPSVec(pS5), @rgbSV, w);
                end;
                Inc(pS4);
                Inc(pS6);
                Inc(pS5, 3);
              end;
              Inc(pS4, lp);
              Inc(pS6, lp);
              Inc(pS5, lp * 3);
            end;
            Inc(pS1);
            Inc(pS2);
            Inc(pS3, 3);
            Inc(colSL2);
          end;
        end;
        pS2 := @TranspBuf[0];
        pS3 := @ColBuf[0];
        for y := 0 to Height -1 do
        begin
          colSL2 := PCardinal(Integer(DoFrec.colSL) + DoFrec.SLoffset * y);
          for x := 1 to Width do
          begin
            if pS2^ < 1e-10 then SM := 1e10 else SM := 1 / pS2^;
            colSL2^ := SVecToColNoScale(ScaleSVector(TPSVec(pS3)^, SM));
            Inc(pS2);
            Inc(pS3, 3);
            Inc(colSL2);
          end;
        end;
        if DoFrec.Verbose then UpdateScaledImage(0, (Height - 1) div ImageScale);
      end;
    finally
  //    if Length(ColBuf) < DoFrec.MHeader.Width * DoFrec.MHeader.Height * 3 then
    //    Mand3DForm.OutMessage('Not enough memory, DoF aborted.');
      SetLength(RBuf, 0);
      SetLength(TranspBuf, 0);
      if Length(ColBuf) < DoFrec.MHeader.Width * DoFrec.MHeader.Height * 3 then
        PostMessage(Mand3DForm.Handle, WM_ThreadReady, 0, 66);
      SetLength(ColBuf, 0);
    end;
end;

{procedure Qsort(const anzahl: integer; var List: array of single);
procedure QuickSort(const L, R: Integer);
var LPos, RPos: Integer;
    ListR, Tmp: single;
begin
    LPos  := L - 1;
    RPos  := R;
    ListR := List[R];
    repeat
      repeat Inc(LPos) until (List[LPos] >= ListR);
      repeat Dec(RPos) until (RPos <= LPos) or (List[RPos] <= ListR);
      if LPos >= RPos then Break;
      Tmp := List[LPos];  List[LPos] := List[RPos];  List[RPos] := Tmp;
    until False;
    Tmp := List[LPos];  List[LPos] := List[R];  List[R] := Tmp;
    if LPos - 1 > L then QuickSort(L, LPos - 1);
    if R > LPos + 1 then QuickSort(LPos + 1, R);
end;
begin
    QuickSort(0, anzahl - 1);
end; }

procedure QuickSortInt(count: Integer; var List: array of TSortItem);
procedure QuickSort(const L, R: Integer; List: TPSortItem);  //L:eax  R:edx  List:ecx
asm
   push ebx
   push esi
   push edi
   mov  ebx, eax     //Lpos := L
   mov  esi, edx     //Rpos := R
   dec  ebx
   mov  edi, [ecx + edx * 8]  //ListR := List[R].iZ;    
@@1:
   inc  ebx
   cmp  edi, [ecx + ebx * 8]
   jg   @@1
@@2:
   dec  esi
   cmp  esi, ebx
   jle  @@4          //break
   cmp  edi, [ecx + esi * 8]
   jl   @@2
   push eax
   push edx
   mov  eax, [ecx + ebx * 8]
   mov  edx, [ecx + esi * 8]
   mov  [ecx + esi * 8], eax
   mov  [ecx + ebx * 8], edx
   mov  eax, [ecx + ebx * 8 + 4]
   mov  edx, [ecx + esi * 8 + 4]
   mov  [ecx + esi * 8 + 4], eax
   mov  [ecx + ebx * 8 + 4], edx
   pop  edx
   pop  eax
   jmp  @@1
@@4:  
   mov  esi, [ecx + ebx * 8]
  // mov  edi, [ecx + edx * 8]
   mov  [ecx + edx * 8], esi
   mov  [ecx + ebx * 8], edi
   mov  esi, [ecx + ebx * 8 + 4]
   mov  edi, [ecx + edx * 8 + 4]
   mov  [ecx + edx * 8 + 4], esi
   mov  [ecx + ebx * 8 + 4], edi
   dec  ebx
   cmp  ebx, eax
   jle  @@5
   mov  esi, edx
   mov  edx, ebx
   call QuickSort
   mov  edx, esi
@@5:
   add  ebx, 2
   cmp  ebx, edx
   jge  @@6
   mov  esi, eax
   mov  eax, ebx
   call QuickSort
   mov  eax, esi
@@6:
   pop  edi
   pop  esi
   pop  ebx
end;

{var LPos, RPos, ListR: Integer;
    Tmp: TSortItem;
begin
    LPos  := L - 1;
    RPos  := R;
    ListR := List[R].iZ;
    repeat
      repeat Inc(LPos) until (List[LPos].iZ >= ListR);
      repeat Dec(RPos) until (RPos <= LPos) or (List[RPos].iZ <= ListR);
      if LPos >= RPos then Break;
      Tmp := List[LPos];  List[LPos] := List[RPos];  List[RPos] := Tmp;
    until False;
    Tmp := List[LPos];  List[LPos] := List[R];  List[R] := Tmp;
    if LPos - 1 > L then QuickSort(L, LPos - 1, List);
    if R > LPos + 1 then QuickSort(LPos + 1, R, List);
end;    }
begin
   QuickSort(0, count - 1, @List[0]);
{asm
   mov  edx, eax
   xor  eax, eax
   mov  ecx, edx
   dec  edx
   call QuickSort  } 
end;

procedure doDOFsortT(DoFrec: TDoFrec);
begin
    if DoFrec.MHeader.Width < DoFrec.MHeader.sDOFclipR * 4 then
      doDOFsort(DoFrec)
    else
    begin  //2 threads, if not enough mem only 1 thread 2 times + wait for thread(s) to finish
          //todo for record: threadID, array pointers, pointer for var for progress

    end;  
end;

                              //todo: xstart, xend, maxR width borders with 2 threads
procedure doDOFsort(DoFrec: TDoFrec); //sorted from back to front with normalized transp
var x, y, r, xa, ya, xe, ye, yy, xx, i, ii, lp, ims, iys: Integer;
    Rsub, Zsharp, w, sw, maxR, sMs, sRadius, Ap, st, DEstopFactor, dw: Single;
    Zcorr, ZcMul, ZZstmitDif: Double;
    ColBuf: array of Single;
    List: array of TSortItem;
    TranspBuf: array of Single;
    pS2, pS3, pST: PSingle;
    colSL2, colSL3: PCardinal;
    SL2: TPSiLight5;
    pSI: TPSortItem;
    bBG, bDescale: LongBool;
    sRGB: TSVec;
begin
    try
      CalcPPZvals(DoFrec.MHeader^, Zcorr, ZcMul, ZZstmitDif);
      with DoFrec.MHeader^ do
      begin
        sDOFaperture := MinMaxCS(0.0001, sDOFaperture, 2);
        sDOFclipR := MinMaxCS(0.1, sDOFclipR, 1000);
        lp := (bCalcDOFtype shr 1) and 3;
        case lp of
          0:  Ap := sDOFaperture * 0.5;
          1:  Ap := sDOFaperture * (0.25 + DoFrec.pass * 0.58) * 0.5;  
        else  Ap := sDOFaperture / 22 * Power(3, DoFrec.pass);    // 3pass: 1/11 + 3/11 + 9/11    was: 1/6 + 2/6 + 4/6 radius
        end;
        DEstopFactor := MaxCD(0, dFOVy * Pid180) / Height;
        ZcMul := 1 / ZcMul;
        Zcorr := 1 / Zcorr; 

        dw := MinCS(sDOFZsharp, sDOFZsharp2) * Width;
        st := MaxCS(sDOFZsharp, sDOFZsharp2) * Width;
        w := (1 + dw * DEstopFactor) / (1 + st * DEstopFactor);

        Zsharp := (w * st + dw) / (1 + w);  
        Rsub := Abs((dw - Zsharp) / (1 + dw * DEstopFactor) * Ap);  //calc r at sDOFZsharp

     //   Abs(w1 - Zsharp) * Ap / (1 + w1 * DEstopFactor) = Abs(w2 - Zsharp) * Ap / (1 + w2 * DEstopFactor);
     // -> Abs(w1 - Zsharp) * (1 + w2 * DEstopFactor) = Abs(w2 - Zsharp) * (1 + w1 * DEstopFactor);
     // sort w1,w2 -> w1<w2!
     // -> (Zsharp - w1) / (w2 - Zsharp) = (1 + w1 * DEstopFactor) / (1 + w2 * DEstopFactor);
     // -> (Zsharp - w1) / (w2 - Zsharp) = const
     // -> Zsharp - w1 = const * (w2 - Zsharp)
     // -> Zsharp - w1 = const * w2 - const * Zsharp
     // -> Zsharp + const * Zsharp = const * w2 + w1
     // -> Zsharp * (1 + const) = const * w2 + w1
     // -> Zsharp = (const * w2 + w1) / (1 + const)   !!!!
     

        SetLength(List, Width * Height);           //8bytes TSortItem
        SetLength(TranspBuf, Width * Height);      //1byte->4bytes Single
        SetLength(ColBuf, Width * Height * 3 + 1);   //12bytes           ->additional 24bytes per pixel!
        FillChar(TranspBuf[0], Width * Height * 4, 0);

        SL2 := DoFrec.SL;
        xx := 32768;
        yy := 0;
        for x := 1 to Width * Height do     //find nearest + farest pixel for clip maxR?
        begin
          if SL2.Zpos < 32768 then
          begin
            if SL2.Zpos < xx then xx := SL2.Zpos;
            if SL2.Zpos > yy then yy := SL2.Zpos;
          end;
          Inc(SL2);
        end;
        w := (Sqr((32768 - xx) * 256 * ZcMul + 1) - 1) * Zcorr;  //Zpos, multiplied with StepWidth would be absolute val
        sRadius := Abs((w - Zsharp) * Ap / (1 + w * DEstopFactor));
        w := (Sqr((32768 - yy) * 256 * ZcMul + 1) - 1) * Zcorr;
        maxR := MinCS(sDOFclipR, MaxCS(sRadius, Abs((w - Zsharp) / (1 + w * DEstopFactor) * Ap)) * 1.5);

        pS3 := @ColBuf[0];
        SL2 := DoFrec.SL;
        pSI := @List[0];
        for y := 0 to Height - 1 do     //make List to be sorted    (hiQ DOF: use Col[3] for radius and calc bDescale with respect to it!)
        for x := 0 to Width - 1 do
        begin
          pSI^.iZ := PInteger(@SL2.RoughZposFine)^ shr 8;
          if pSI^.iZ > 8388352 then pSI^.iZ := -1;
          pSI^.wX := x;
          pSI^.wY := y;
          ClearSVec(TPSVec(pS3)^);
          Inc(pS3, 3);
          Inc(SL2);
          Inc(pSI);
        end;
        QuickSortInt(Width * Height, List);
        sRGB[2] := 0;
        pSI := @List[0];
        for i := 1 to Width * Height do
        begin
          if (i and 63) = 63 then
          begin
            if DoFrec.Verbose then
              PostMessage(Mand3DForm.Handle, WM_ThreadReady, i div Width, 67);
            Application.ProcessMessages;
            if MCalcStop then Exit;
          end;
          x := pSI^.wX;
          y := pSI^.wY;
          ii := x + y * Width;

          colSL2 := PCardinal(Integer(DoFrec.colSL) + y * DoFrec.SLoffset + x * 4);
          sRGB := ColToSVecNoScale(colSL2^);

          w := (Sqr((8388352 - pSI^.iZ) * ZcMul + 1) - 1) * Zcorr;
          sRadius := (w - Zsharp) * Ap / (1 + w * DEstopFactor);
          bDescale := (sRadius < 0);
          sRadius := Min0MaxCS(Abs(sRadius) - Rsub, maxR);    // if sRadius > 3 then use coarse grid..?

          sMs := sRadius + 1;
          ims := Trunc(sMs * sMs);
          sw := 1 / (2.5 * sRadius * sRadius + 1);     //A=Pi*r*r -> alpha = 1 / (Pi*sMs)

          bBG := (pSI^.iZ = -1);
          r := Round(Abs(sRadius) + 0.5);
          if r > x then xa := -x else xa := -r;
          if r + x >= Width then xe := Width - x - 1 else xe := r;
          if r > y then ya := -y else ya := -r;
          if r + y >= Height then ye := Height - y - 1 else ye := r;
          lp  := Width - xe + xa - 1;
          ii  := ii + ya * Width + xa;
          pS3 := @ColBuf[ii * 3];
          pST := @TranspBuf[ii];
          for yy := ya to ye do
          begin
            iys := Sqr(yy);
            for xx := xa to xe do
            begin
              ii := Sqr(xx) + iys;
              if ii <= ims then
              begin
                w := sMs - Sqrt(ii); 
                if bDescale then dw := 1 - Sqr(0.8 * w / sMs);
                if w > 1 then w := sw
                         else w := w * sw;
                if bDescale and (pST^ > dw) then
                begin
                  dw := dw / pST^;
                  ScaleSVectorV(TPSVec(pS3), dw);
                  pST^ := pST^ * dw;
                end;
                if (not bBG) and ((w + pST^) > 1.01) then
                begin
                  st := (1.01 - w) / pST^;
                  pS3^ := pS3^ * st + sRGB[0] * w;
                  Inc(pS3);
                  pS3^ := pS3^ * st + sRGB[1] * w;
                  Inc(pS3);
                  pS3^ := pS3^ * st + sRGB[2] * w;
                  Inc(pS3);
                  pST^ := 1.01;
                end else begin
                  pS3^ := pS3^ + sRGB[0] * w;
                  Inc(pS3);
                  pS3^ := pS3^ + sRGB[1] * w;
                  Inc(pS3);
                  pS3^ := pS3^ + sRGB[2] * w;   
                  Inc(pS3);
                  pST^ := pST^ + w;
                end;
              end
              else Inc(pS3, 3);
              Inc(pST);
            end;
            Inc(pST, lp);
            Inc(pS3, lp * 3);
          end;
          Inc(pSI);
        end;

        pST := @TranspBuf[0];    //normalize
        pS3 := @ColBuf[0];
        for y := 0 to Height -1 do
        begin
          colSL2 := PCardinal(Integer(DoFrec.colSL) + DoFrec.SLoffset * y);
          for x := 1 to Width do
          begin
            if pST^ < 1e-10 then Rsub := 1e10 else Rsub := 1 / pST^;
            colSL2^ := SVecToColNoScale(ScaleSVector(TPSVec(pS3)^, Rsub));
            Inc(pST);
            Inc(pS3, 3);
            Inc(colSL2);
          end;
        end;
        if DoFrec.Verbose then UpdateScaledImage(0, (Height - 1) div ImageScale);
      end;
    finally
      SetLength(List, 0);
      SetLength(TranspBuf, 0);
      if Length(ColBuf) < DoFrec.MHeader.Width * DoFrec.MHeader.Height * 3 then
        PostMessage(Mand3DForm.Handle, WM_ThreadReady, 0, 66);
      SetLength(ColBuf, 0);
    end;
end;


end.
