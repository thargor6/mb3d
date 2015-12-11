unit Maps;

//map loading, access, managing, freeing

interface

uses Windows, LightAdjust, SysUtils, Graphics, jpeg, TypeDefinitions, pngimage,
     SyncObjs, Classes, Math3D;

type
  TVLMP = function(vd: TPVec3D): LongBool;
  TVLMV = function(vd: TPSVec): Single;
  TVolumetricLightMap = packed record   //cube map with rotation matrix and gimmicks
    CubeSize:     Integer;
    HalfSize:     Integer;
    SizeFactor:   Single;     //(CubeSize - 1) / 2 in Single
    CsizeS:       Single;     //CubeSize - 1  in Single
    HSizeS:       Single;
    SideCount:    Integer;    //in case not all sides are needed
    StretchSide1: Single;     //if one sided and frustrum is below 90 degrees
    HeightS2to5:  Integer;    //height of surrounding sides in case frustrum is 90 to 270 degrees
    MinDistance:  Single;     //minimum distance from light to frustrum, for poslights
    IsPosLight:   LongBool;
    Rotate:       LongBool;
    sFree:        Single;
    LightPos:     TVec3D;     //Poslight position or global light offsets
    RotMatrix:    TSMatrix3;  //rotation matrix to center side1 towards frustrum
    CubeSides:    array[0..5] of array of Single;
  end;
  TCalcVolumetricLightMapThread = class(TThread)
  private
    { Private-Deklarationen }
    It3Dext: TIteration3Dext;
  public
    { Public-Deklarationen }
    MCTparas: TMCTparameter;
  protected
    procedure Execute; override;
  end;

function LoadLightMap(var LM: TLightMap; FileName: String; Smooth, Convert2Spherical, SetHGCursor: LongBool; fitBorder: Integer): LongBool;
function LoadLightMapNr(nr: Integer; LMap: TPLightMap): LongBool;
procedure LoadEmptyLightMap(var LM: TLightMap; Smooth, Convert2Spherical, SetHGCursor: LongBool; fitBorder: Integer);
procedure FreeLightMap(LM: TPLightMap);
procedure FreeLightMapsInLValsWithRestriction(LVal, LValRestricted: TPLightVals);
procedure FreeLightMapsInLVals(LVal: TPLightVals);
procedure MakeSmallLMimage(smallLM, bigLM: TPLightMap);
function MakeVolumicLightMapThreads(Header: TPMandHeader11; LVals: TPLightVals; PCTS: TPCalcThreadStats): LongBool;
function VolLightMapPosPas(vd: TPVec3D): LongBool;
function VolLightMapPosSSE(vd: TPVec3D): LongBool;
function GetVolLightMapVecPas(vd: TPSVec): Single;
function GetVolLightMapVecSSE(vd: TPSVec): Single;
procedure CalcVolLightMap(Header: TPMandHeader11; LVals: TPLightVals);

var
    MapCriticalSection: TCriticalSection;
    LMapNrBadLA: array[0..7] of Integer = (0,0,0,0,0,0,0,0);
    LMapBadLAtime: array[0..7] of Cardinal;
    VolumeLightMap: TVolumetricLightMap;
    CVLMThread: array of TCalcVolumetricLightMapThread;
    CVLMThreadStats: TCalcThreadStats;
    VolLightMapPos: TVLMP = VolLightMapPosPas;
    GetVolLightMapVec: TVLMV = GetVolLightMapVecPas;

implementation

uses FileHandling, DivUtils, Mand, Math, UITypes, Forms, HeaderTrafos, Calc,
  MapSequences;

function VolLightMapPosPas(vd: TPVec3D): LongBool;
var x, y: Integer;
    v: TSVec;
begin
    with VolumeLightMap do
    begin
      v[0] := vd[0] - LightPos[0];
      v[1] := vd[1] - LightPos[1];
      v[2] := vd[2] - LightPos[2];
      RotateSVectorS(@v, @RotMatrix);
      x := Round(v[0] * StretchSide1) + HalfSize;
      y := Round(v[1] * StretchSide1) + HalfSize;
      if x < 0 then x := 0 else if x >= CubeSize then x := CubeSize - 1;
      if y < 0 then y := 0 else if y >= CubeSize then y := CubeSize - 1;
      Result := CubeSides[0, x + y * CubeSize] > v[2];
    end;
end;

function VolLightMapPosSSE(vd: TPVec3D): LongBool;
asm
    push esi
    push edx  //to get esp buf
    lea  esi, VolumeLightMap
    fld  qword [eax]
    fsub qword [esi + TVolumetricLightMap.LightPos]
    fstp dword [esp]
    fld  qword [eax + 8]
    movss  xmm0, [esp]
    fsub qword [esi + TVolumetricLightMap.LightPos + 8]
    fstp dword [esp]
    fld  qword [eax + 16]
    movss  xmm1, [esp]
    fsub qword [esi + TVolumetricLightMap.LightPos + 16]
    fstp dword [esp]
    shufps xmm0, xmm0, 0
    movss  xmm2, [esp]
    shufps xmm1, xmm1, 0
    shufps xmm2, xmm2, 0
    movups xmm4, [esi + TVolumetricLightMap.RotMatrix]
    movups xmm5, [esi + TVolumetricLightMap.RotMatrix + 16]
    movups xmm6, [esi + TVolumetricLightMap.RotMatrix + 32]
    mulps  xmm4, xmm0
    mulps  xmm5, xmm1
    mulps  xmm6, xmm2
    addps  xmm4, xmm5
    addps  xmm4, xmm6
    xorps  xmm2, xmm2
    movhlps xmm5, xmm4
    movss  xmm1, [esi + TVolumetricLightMap.StretchSide1]
    movss  xmm3, [esi + TVolumetricLightMap.HSizeS]
    movss  xmm0, [esi + TVolumetricLightMap.CSizeS]
    shufps xmm1, xmm1, 0
    shufps xmm3, xmm3, 0
    shufps xmm0, xmm0, 0
    mulps  xmm4, xmm1
    addps  xmm4, xmm3
    maxps  xmm4, xmm2
    minps  xmm4, xmm0
    cvtss2si eax, xmm4
    shufps xmm4, xmm4, 1
    cvtss2si edx, xmm4
    imul edx, dword [esi + TVolumetricLightMap.CubeSize]
    mov  esi, [esi + TVolumetricLightMap.CubeSides]
    add  edx, eax
    xor  eax, eax
    comiss xmm5, [esi + edx * 4]
    jnc  @e
    mov  eax, -1
@e: pop  edx
    pop  esi
end;

function GetVolLightMapVecSSE(vd: TPSVec): Single;
asm
    push esi
    push ebx
    xorps  xmm4, xmm4
    lea  esi, VolumeLightMap
    movups xmm5, [eax]
    movups xmm7, cAbsSVec
    movaps xmm0, xmm5
    movaps xmm1, xmm5
    movhlps xmm2, xmm5
    shufps xmm1, xmm1, 1
    andps  xmm5, xmm7
    movaps xmm6, xmm5
    movhlps xmm7, xmm5
    shufps xmm6, xmm6, 1
    movss  xmm3, [esi + TVolumetricLightMap.SizeFactor]
    ucomiss xmm5, xmm6
    jc   @1
    ucomiss xmm5, xmm7
    jc   @2
    xor  edx, edx
    ucomiss xmm0, xmm4
    adc  edx, 0
@3: divss xmm3, xmm0
    mulss xmm1, xmm3
    mulss xmm2, xmm3
    cvtss2si eax, xmm1
    cvtss2si ebx, xmm2
    jmp  @e
@2: mov  edx, 4
    ucomiss xmm2, xmm4
    adc  edx, 0
@4: divss xmm3, xmm2
    mulss xmm0, xmm3
    mulss xmm1, xmm3
    cvtss2si eax, xmm0
    cvtss2si ebx, xmm1
    jmp  @e
@1: ucomiss xmm6, xmm7
    jc   @2
    mov  edx, 2
    ucomiss xmm1, xmm4
    adc  edx, 0
@5: divss xmm3, xmm1
    mulss xmm0, xmm3
    mulss xmm2, xmm3
    cvtss2si eax, xmm0
    cvtss2si ebx, xmm2
@e: add  ebx, [esi + TVolumetricLightMap.HalfSize]
    add  eax, [esi + TVolumetricLightMap.HalfSize]
    imul ebx, dword [esi + TVolumetricLightMap.CubeSize]
    mov  esi, [esi + edx * 4 + TVolumetricLightMap.CubeSides]
    add  eax, ebx
    fld  dword [esi + eax * 4]
    pop  ebx
    pop  esi
end;

function GetVolLightMapVecPas(vd: TPSVec): Single;
var x, y, cs: Integer;
label l1;
begin
    with VolumeLightMap do
    begin
   //   if Rotate then RotateVectorS(vd, @RotMatrix);  //todo: vd in Single
      if Abs(vd[0]) >= Abs(vd[1]) then
      begin
        if Abs(vd[0]) >= Abs(vd[2]) then
        begin
          if vd[0] > 0 then cs := 0 else cs := 1;
          vd[0] := SizeFactor / vd[0];
          x := Round(vd[1] * vd[0]);
          y := Round(vd[2] * vd[0]);
        end
        else
        begin
l1:       if vd[2] > 0 then cs := 4 else cs := 5;
          vd[2] := SizeFactor / vd[2];
          x := Round(vd[0] * vd[2]);
          y := Round(vd[1] * vd[2]);
        end;
      end
      else if Abs(vd[1]) < Abs(vd[2]) then goto l1 else
      begin
        if vd[1] > 0 then cs := 2 else cs := 3;
        vd[1] := SizeFactor / vd[1];
        x := Round(vd[0] * vd[1]);
        y := Round(vd[2] * vd[1]);
      end;
      Result := CubeSides[cs, x + HalfSize + (y + HalfSize) * CubeSize];
    end;
end;

procedure CalcVolLightMap(Header: TPMandHeader11; LVals: TPLightVals);
var i, ia: Integer;
begin
    i := Header.bVolLightNr and 7;
    if (i > 0) and ((Header.Light.Lights[Min(5, i - 1)].Loption and 3) = 0) then
    begin
      MCalcStop := False;
      if MakeVolumicLightMapThreads(Header, LVals, @CVLMThreadStats) then
      begin
        repeat
          delay(100);
          ia := 0;
          for i := 1 to CVLMThreadStats.iTotalThreadCount do
            if CVLMThreadStats.CTrecords[i].isActive <> 0 then Inc(ia);
        until MCalcStop or (ia = 0);
      end;
    end;
end;

function MakeVolumicLightMapThreads(Header: TPMandHeader11; LVals: TPLightVals; PCTS: TPCalcThreadStats): LongBool;
var MCTparas: TMCTparameter;
    x, ThreadCount, VLnr, VLnrLV: Integer;
    dTmp, dTmp2: Double;
    sv: TSVec;
    dv: TVec3D;
    s, sz, sft, sm: Single;
begin
    MCTparas := GetMCTparasFromHeader(Header^, True);
    Result := MCTparas.bMCTisValid;
    if Result then
    begin
      if Header.bPlanarOptic <> 2 then
      begin  //shift ystart to the middle
        mAddVecWeight(@MCTparas.Ystart, @MCTparas.Vgrads[0], MCTparas.iMandWidth * s05);
        mAddVecWeight(@MCTparas.Ystart, @MCTparas.Vgrads[1], MCTparas.iMandHeight * s05);
      end;
      MCTparas.PCalcThreadStats := PCTS;
      with VolumeLightMap do
      try
        VLnr := Max(0, Min(5, (Header.bVolLightNr and 7) - 1));
        VLnrLV := LVals.SortTab[VLnr];
        IsPosLight := (Header.Light.Lights[VLnr].Loption and 4) <> 0;
        s := Max(MCTparas.iMandWidth, MCTparas.iMandHeight);
        sft := 1 + 0.2 * ((Header.bVolLightNr shr 4) - 2);
        if IsPosLight then
        begin
          MinDistance := 0;
          Rotate := False;
          LightPos := LVals.lvMidPos;
          AddSVec2Vec3d(LVals.PLValigned.LN[VLnrLV], @LightPos);
          //mindist, sidecount
          SideCount := 6;
          CubeSize := Round(s * sft * 0.25) or 1;
          StretchSide1 := 1;
        end
        else
        begin
          dTmp := MinCD(MCTparas.Zend, s * 16);
          sm := MaxCD(dTmp, s) / s;
          s := s * Power(sm, 0.36);
          dTmp := dTmp * s05; //MinCD(MCTparas.Zend, s) * s05;  todo: FOV > 90deg closer to startpos
       //   sz := (1 + dTmp * GetDEstopFactor(Header)) * Sqrt(Sqrt(MaxCS(1, sft)));
          Rotate := True;
          SideCount := 1;
          CubeSize := Round(s * sft * 0.625) or 1;
          mCopyAddVecWeight(@LightPos, @LVals.lvMidPos, @MCTparas.Vgrads[2],
                            MCTparas.sZZstmitDif / MCTparas.StepWidth + dTmp); //midpos of scene frustrum, relative to lightvec offsets are calculated

       {   dTmp := -D7BtoDouble(Header.Light.Lights[x].LXpos);
          dTmp2 := D7BtoDouble(Header.Light.Lights[x].LYpos);
          BuildViewVectorFOV(dTmp2, dTmp, @sv);
          if (Header.Light.Lights[x].Loption and 32) = 0 then //rel angles
          begin
            RotateSVector(@sv, @MCTparas.Vgrads);
            NormaliseSVectorVar(sv);
          end; }

          sv := LVals.PLValigned.LN[VLnrLV];
          RotateSVector(@sv, @MCTparas.Vgrads);
          SVectorChangeSign(@sv);
          NormaliseSVectorVar(sv);

          dv := SVecToDVec(sv);
          MakeOrthoVecs(@dv, @RotMatrix);
          TPSVec(@RotMatrix[2])^ := sv;
          InvertSMatrix(@RotMatrix);

          dTmp := MCTparas.StepWidth {* Power(sm, 0.7)} * dTmp * 2 * Sqrt(Sqrt(MaxCS(1, sft)));
          StretchSide1 := CubeSize / (dTmp * 1.75);
          MinDistance := -dTmp * MCTparas.sHSmaxLengthMultiplier;
        end;
        HalfSize := CubeSize div 2;
        SizeFactor := (CubeSize - 1) * s05;
        CsizeS := CubeSize - 1;
        HSizeS := HalfSize;
        HeightS2to5 := CubeSize;
        for x := 5 downto SideCount do SetLength(CubeSides[x], 0);
        for x := 0 to SideCount - 1 do SetLength(CubeSides[x], CubeSize * CubeSize);
      except
        Mand3DForm.OutMessage('Error, could not create volumic light map.');
        Result := False;
      end;
      if not Result then Exit;

      ThreadCount := Min(Mand3DForm.UpDown3.Position, VolumeLightMap.CubeSize);
      SetLength(CVLMThread, ThreadCount);
      for x := 1 to ThreadCount do
      begin
        PCTS.CTrecords[x].iActualYpos := 0;
        MCTparas.iThreadId := x;
        try
          CVLMThread[x - 1] := TCalcVolumetricLightMapThread.Create(True);
          CVLMThread[x - 1].FreeOnTerminate := True;
          CVLMThread[x - 1].MCTparas        := MCTparas;
          CVLMThread[x - 1].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
          PCTS.CTrecords[x].isActive := 1;
          PCTS.CThandles[x] := CVLMThread[x - 1];
        except
          ThreadCount := x - 1;
          Break;
        end;
      end;
      for x := 0 to ThreadCount - 1 do
        CVLMThread[x].MCTparas.iThreadCount := ThreadCount;
      PCTS.iTotalThreadCount := ThreadCount;
      PCTS.cCalcTime := GetTickCount;
      for x := 0 to ThreadCount - 1 do CVLMThread[x].Start;
    end;
end;

procedure TCalcVolumetricLightMapThread.Execute;
var ps: PSingle;
    bInsideTmp: LongBool;
    x, y, side, HS: Integer;
    RStepFactorDiff, RLastStepWidth, st2, maxDist, dist, sgl: Single;
    ds, zz, zzmul, RLastDE: Double;
    vec, v: TVec3D;
    ms: TSMatrix3;
begin
    with MCTparas do
    try
      IniIt3D(@MCTparas, @It3Dext);
      bInsideTmp := bInsideRendering;
      maxDist := sHSmaxLengthMultiplier * MaxCD(VolumeLightMap.CubeSize * 3, Zend * s05);
      HS := VolumeLightMap.HalfSize;
      sgl := 1 / VolumeLightMap.StretchSide1;
      if not VolumeLightMap.IsPosLight then
      begin
        ms := VolumeLightMap.RotMatrix;
        InvertSMatrix(@ms);
        vec := SVecToDVec(TPSVec(@ms[2])^);
        maxDist := Abs(VolumeLightMap.MinDistance) * 2 / StepWidth;
      end;
      for side := 0 to VolumeLightMap.SideCount - 1 do
      begin
        y := Integer(iThreadID) - HS - 1;  //poslight sides height
        while y <= HS do
        begin
          if MCalcStop then Break;
          PCalcThreadStats.CTrecords[MCTparas.iThreadId].iActualYpos :=
            (side * VolumeLightMap.CubeSize + y + HS) div VolumeLightMap.SideCount;
          ps := @VolumeLightMap.CubeSides[side, (y + HS) * VolumeLightMap.CubeSize];
          for x := -HS to HS do
          begin
            if VolumeLightMap.IsPosLight then
            begin
              case side of
              0: vec := MakeVec(HS, x, y);
              1: vec := MakeVec(-HS, -x, -y);
              2: vec := MakeVec(x, HS, y);
              3: vec := MakeVec(-x, -HS, -y);
              4: vec := MakeVec(x, y, HS);
              5: vec := MakeVec(-x, -y, -HS);
              end;
              if VolumeLightMap.Rotate then RotateVectorS(@vec, @VolumeLightMap.RotMatrix);
              NormaliseVectorVar(vec);
              mCopyVec(@It3Dext.C1, @VolumeLightMap.LightPos);
              mAddVecWeight(@It3Dext.C1, @vec, VolumeLightMap.MinDistance);
              dist := VolumeLightMap.MinDistance / StepWidth;
            end
            else
            begin
              mCopyAddVecWeight(@It3Dext.C1, @VolumeLightMap.LightPos, @vec, VolumeLightMap.MinDistance);
              AddSVec2Vec3d(ScaleSVectorD(@ms[0], x * sgl), @It3Dext.C1);
              AddSVec2Vec3d(ScaleSVectorD(@ms[1], y * sgl), @It3Dext.C1);
            end;
            RStepFactorDiff := 1;
            zz := DistanceOf2Vecs(@It3Dext.C1, @Ystart) / StepWidth;
            msDEstop := DEstop * (1 + zz * mctDEstopFactor);
            zzmul := DotOfVectorsNormalize(@Vgrads[2], @vec);
            bCalcInside := bInsideTmp;
            bInsideRendering := bInsideTmp;
            ds := CalcDE(@It3Dext, @MCTparas);
            if bInAndOutside and (ds < msDEstop) then
            begin
              bCalcInside := not bInsideTmp;
              bInsideRendering := not bInsideTmp;
              ds := CalcDE(@It3Dext, @MCTparas);
            end;
            dist := 0;
            repeat
              RLastDE := ds;
              RLastStepWidth := MinCS(MaxCS(s011, (ds - msDEsub * msDEstop) * sZstepDiv * RStepFactorDiff),
                                      MaxCS(msDEstop, 0.4) * mctMH04ZSD);
              dist := dist + RLastStepWidth;
              mAddVecWeight(@It3Dext.C1, @vec, RLastStepWidth * StepWidth);
              zz := zz + RLastStepWidth * zzmul;
              msDEstop := DEstop * (1 + Abs(zz) * mctDEstopFactor);
              ds := CalcDE(@It3Dext, @MCTparas);
              if (It3Dext.ItResultI >= MaxItsResult) or (ds <= msDEstop) then Break;
              if ds > RLastDE + RLastStepWidth then ds := RLastDE + RLastStepWidth;
              if RLastDE > ds + 1e-30 then
              begin
                st2 := RLastStepWidth / (RLastDE - ds);
                if st2 < 1 then RStepFactorDiff := maxCS(s05, st2)
                           else RStepFactorDiff := 1;
              end
              else RStepFactorDiff := 1;
              if dist >= maxDist then
              begin
                dist := maxDist * 1000;
                Break;
              end;
            until False;
            ps^ := dist * StepWidth + VolumeLightMap.MinDistance;
            Inc(ps);
          end;
          if MCalcStop then Break;
          Inc(y, iThreadCount);
        end;
      end;
    finally
      PCalcThreadStats.CTrecords[iThreadId].isActive := 0;
    end;
end;

procedure MakeSmallLMimage(smallLM, bigLM: TPLightMap);
var pca, pcb: PCardinal;
    pa: Pointer;
    x, x2, xe, y, n, bi, im: Integer;
    dy, dx: Double;
    tmpca: array of Cardinal;
    sv: TSVec;
    c: Cardinal;
begin
    with smallLM^ do
    begin
      if (bigLM.LMHeight = 0) or (bigLM.LMWidth = 0) then Exit;
      iMapType := 0;
      sIntensity := bigLM.sIntensity;
      LMavrgCol := bigLM.LMavrgCol;
      LMavrgColSqr := bigLM.LMavrgColSqr;
      LMnumber := bigLM.LMnumber;
      if (LMWidth <> 16) or (LMHeight <> 8) then
      begin
        LMWidth := 16;
        LMHeight := 8;
        SetLength(LMa, (LMWidth + 1) * (LMHeight + 1));
        iLMstart := Integer(@LMa[0]);
        sLMXfactor := LMWidth;
        sLMYfactor := LMHeight;
      end;
      if bigLM.iMapType = 1 then im := 6 else im := 4;
      SetLength(tmpca, LMWidth * Max(1, bigLM.LMHeight));
      pcb := @tmpca[0];
      dy := (bigLM.LMHeight - 1) / LMHeight;
      dx := (bigLM.LMWidth - 1) / LMWidth;
      bi := (bigLM.LMWidth + 1) * im;
      for y := 0 to bigLM.LMHeight - 1 do
      begin
        pa := Pointer(bigLM.iLMstart + y * bi);
        x2 := 1;
        for x := 1 to LMWidth do
        begin
          ClearSvec(sv);
          xe := Round(dx * x);
          n := 0;
          while x2 <= xe do
          begin
            if im = 4 then sv := AddSVectors(sv, ColToSVecNoScale(pCardinal(pa)^))
                      else sv := AddSVectors(sv, WordColToSVecDownScale(pa));
            Inc(PByte(pa), im);
            Inc(x2);
            Inc(n);
          end;
          pcb^ := SVecToColNoScale(ScaleSVector(sv, 1 / n));
          Inc(pcb);
        end;
      end;
      for x := 0 to LMWidth - 1 do
      begin
        pca := PCardinal(iLMstart + x * 4);
        pcb := @tmpca[x];
        x2 := 1;
        for y := 1 to LMHeight do
        begin
          ClearSvec(sv);
          xe := Round(dy * y);
          n := 0;
          while x2 <= xe do
          begin
            sv := AddSVectors(sv, ColToSVecNoScale(pcb^));
            Inc(pcb, LMWidth);
            Inc(x2);
            Inc(n);
          end;
          pca^ := SVecToColNoScale(ScaleSVector(sv, 1 / n));   //fp div by 0
          if y = 1 then c := pca^;
          Inc(pca, LMWidth + 1);
        end;
        pca^ := c;
      end;
      //smooth poles horizontally! -> radius = Sin(y * 2 * Pi / LMHeight) -> smoothR = 2 * LMWidth / (radius + 1) - LMWidth
      for y := 0 to LMHeight do
      begin
        if (y = 0) or (y >= LMHeight - 1) then dx := 16 else
          dx := 2 * LMWidth / (Sin(y * Pi / (LMHeight - 1)) + 1) - LMWidth;  // smooth width
        pcb := @LMa[y * (LMWidth + 1)];
        if dx > 0.5 then
        begin
          bi := Round(dx);
          n := - (bi div 2);
          bi := bi + n;
          FastMove(pcb^, tmpca[0], 64);
          for x := 0 to LMWidth do
          begin
            ClearSvec(sv);
            for x2 := n to bi do
              sv := AddSVectors(sv, ColToSVecNoScale(tmpca[(x + x2) and 15]));
            PCardinal(Integer(pcb) + 4 * x)^ := SVecToColNoScale(ScaleSVector(sv, 1 / (bi - n + 1)));
          end;
        end;
        PCardinal(Integer(pcb) + LMWidth * 4)^ := pcb^;
      end;
    end;
    SetLength(tmpca, 0);
end;

procedure CalcLMavrgCol(LMap: TPLightMap);
var x, y, il: Integer;
    scale: Single;
    dv: TVec3D;
    pc: PCardinal;
    pw: TP3word;
begin
    with LMap^ do
    begin
      ClearDVec(dv);
      if iMapType = 1 then il := (LMWidth + 1) * 6
                      else il := (LMWidth + 1) * 4;
      if iMapType = 1 then //word precision
      for y := 0 to LMHeight - 1 do
      begin
        pw := TP3word(iLMstart + y * il);
        for x := 1 to LMWidth do
        begin
          AddSVec2Vec3d(ColToSVecFlipRB_word(pw), @dv);
          Inc(pw);
        end;
      end
      else for y := 0 to LMHeight - 1 do
      begin
        pc := PCardinal(iLMstart + y * il);
        for x := 1 to LMWidth do
        begin
          AddSVec2Vec3d(ColToSVecFlipRBc(pc^), @dv);
          Inc(pc);
        end;
      end;
      if iMapType = 1 then scale := 256 else scale := 1;
      LMavrgCol := DVecToSVec(ScaleVector(dv, 1 / (LMHeight * LMWidth * scale)));
      LMavrgColSqr := ScaleSVector(SqrSVec(LMavrgCol), s1d255);
    end;
end;

function LMbanned(const nr: Integer): LongBool;
var i: Integer;
begin
    Result := False;
    if (nr < 1) or (nr > 32000) then Exit;
    for i := 0 to 7 do if LMapNrBadLA[i] = nr then
    begin
      Result := Abs(LMapBadLAtime[i] - GetTickCount) < 2000;
      if not Result then LMapNrBadLA[i] := 0;
    end;
end;

procedure BannLM(nr: Integer);
var i: Integer;
begin
    if nr < 1 then Exit;
    for i := 0 to 7 do if LMapNrBadLA[i] = 0 then
    begin
      LMapNrBadLA[i] := nr;
      LMapBadLAtime[i] := GetTickCount;
      Break;
    end;
end;
                                //var LMap, give back a pointer to the resource Map
function LoadLightMapNr(nr: Integer; LMap: TPLightMap): LongBool;
var s: String;
    SR: TSearchRec;
    bFound: LongBool;
    Sequence: TMapSequence;
begin
    Result := False;
    if LMbanned(nr) then
      Exit;
    MapCriticalSection.Enter;
    try
      Sequence := TMapSequenceListProvider.GetInstance.GetSequence(nr);
      if Sequence <> nil then begin
        s := Sequence.GetFilename(TMapSequenceFrameNumberHolder.GetCurrFrameNumber);
        if (s<>'') and FileExists(s) then begin
          FreeLightMap(LMap);
          Result := LoadLightMap(LMap^, s, False, False, False, 0);
          if Result then begin
            Mand3DForm.OutMessage('Loaded map <'+ExtractFilename(s)+'>');
          end;
        end;
        if not Result then begin
          Mand3DForm.OutMessage('Loading map <'+ExtractFilename(s)+'> failed');
          LoadEmptyLightMap(LMap^, False, False, False, 0);
          Result := True;
        end;
        LMap.LMnumber := nr;
        LMap.LMframe := TMapSequenceFrameNumberHolder.GetCurrFrameNumber;
        CalcLMavrgCol(LMap);
      end
      else begin
        if LMap.LMnumber = nr then Result := True else
        begin
          bFound := False;
          s := IncludeTrailingPathDelimiter(IniDirs[9]) + IntToStr(nr);
          if FindFirst(s + '.*', faAnyFile, SR) = 0 then
          repeat
            bFound := Pos(UpperCase(ExtractFileExt(SR.Name)), '.JPG.PNG.BMP.JPEG') > 0;
            if bFound then
              s := IncludeTrailingPathDelimiter(IniDirs[9]) + SR.Name;
          until bFound or (FindNext(SR) <> 0);
          FindClose(SR);
          if not bFound then
          begin
            if FindFirst(s + '*.*', faAnyFile, SR) = 0 then
            repeat
              bFound := (Pos(UpperCase(ExtractFileExt(SR.Name)), '.JPG.PNG.BMP.JPEG') > 0) and
                        (Length(SR.Name) > Length(IntToStr(nr))) and
                         not (SR.Name[Length(IntToStr(nr)) + 1] in ['0'..'9']);
              if bFound then
                s := IncludeTrailingPathDelimiter(IniDirs[9]) + SR.Name;
            until bFound or (FindNext(SR) <> 0);
            FindClose(SR);
          end;
          if not bFound then Result := False else
            Result := LoadLightMap(LMap^, s, False, False, False, 0);
          if Result then
          begin
            LMap.LMnumber := nr;
            LMap.LMframe := 0;
            CalcLMavrgCol(LMap);
          end
          else
          begin
            FreeLightMap(LMap);
            BannLM(nr);
          end;
        end;
      end;
    finally
      MapCriticalSection.Leave;
    end;
end;

function ClipR(s: Single): Cardinal;
begin
    if s < 0 then Result := 0 else
    if s > 255 then Result := 255
               else Result := Round(s);
end;

function ClipRw(s: Single): Word;
begin
    if s < 0 then Result := 0 else
    if s > 65535 then Result := 65535
                 else Result := Round(s);
end;

procedure SmoothLightMap(var LM: TLightMap; Smooth, ConvertToSpherical: Boolean);
var x, y, il, im: Integer;
    pc1, pc2, pc3, pc4, pc5: PCardinal;
    c1, c2, c3: Cardinal;
    d: Double;
    s, s2, sp, sw: Single;
    ba: array of Byte;
function ipolC(i1, i2, i3, i4, i5: Cardinal): Cardinal;  //todo: 16bit
begin
    Result := ClipR(((i1 and $FF) + (i5 and $FF)) * -0.05 + ((i2 and $FF) + (i4 and $FF)) * 0.25 + (i3 and $FF) * 0.6) or
             (ClipR(((i1 and $FF00) + (i5 and $FF00)) * -0.0001953125 +
                    ((i2 and $FF00) + (i4 and $FF00)) * 0.0009765625 + (i3 and $FF00) * 0.00234375) shl 8) or
             (ClipR(((i1 and $FF0000) + (i5 and $FF0000)) * -0.000000762939453125 +
                    ((i2 and $FF0000) + (i4 and $FF0000)) * 0.000003814697265625 + (i3 and $FF0000) * 0.0000091552734375) shl 16);
end;
procedure ipolF(pc1: PCardinal; f: Single; pc: PCardinal);
var w1, w2, w3, w4, ff, fff: Single;
const s6: Single = 1/6;
    s256: Single = 1/(6 * 256);
    s65536: Single = 1/(6 * 65536);
begin
    ff := f * f;
    fff := ff * f;
    w1 := 3*ff - 2*f - fff;
    w2 := 3*(fff - 2*ff - f + 2);
    w3 := 3*(ff + 2*f - fff);
    w4 := fff - f;
    if im = 6 then
    begin
      TP3Word(pc)^[0] := ClipRw((TP3Word(pc1)^[0] * w1 + TP3Word(Integer(pc1) + 6)^[0] * w2 +
           TP3Word(Integer(pc1) + 12)^[0] * w3 + TP3Word(Integer(pc1) + 18)^[0] * w4) * s6);
      TP3Word(pc)^[1] := ClipRw((TP3Word(pc1)^[1] * w1 + TP3Word(Integer(pc1) + 6)^[1] * w2 +
           TP3Word(Integer(pc1) + 12)^[1] * w3 + TP3Word(Integer(pc1) + 18)^[1] * w4) * s6);
      TP3Word(pc)^[2] := ClipRw((TP3Word(pc1)^[2] * w1 + TP3Word(Integer(pc1) + 6)^[2] * w2 +
           TP3Word(Integer(pc1) + 12)^[2] * w3 + TP3Word(Integer(pc1) + 18)^[2] * w4) * s6);
    end
    else
    pc^ := ClipR(((pc1^ and $FF) * w1 + (PCardinal(Integer(pc1) + 4)^ and $FF) * w2 +
                  (PCardinal(Integer(pc1) + 8)^ and $FF) * w3 + (PCardinal(Integer(pc1) + 12)^ and $FF) * w4) * s6) or
           (ClipR(((pc1^ and $FF00) * w1 + (PCardinal(Integer(pc1) + 4)^ and $FF00) * w2 +
                  (PCardinal(Integer(pc1) + 8)^ and $FF00) * w3 + (PCardinal(Integer(pc1) + 12)^ and $FF00) * w4) * s256) shl 8) or
           (ClipR(((pc1^ and $FF0000) * w1 + (PCardinal(Integer(pc1) + 4)^ and $FF0000) * w2 +
                  (PCardinal(Integer(pc1) + 8)^ and $FF0000) * w3 + (PCardinal(Integer(pc1) + 12)^ and $FF0000) * w4) * s65536) shl 16);
end;
begin
    if Smooth and (LM.iMapType = 0) then  //todo: 16bit
    with LM do
    begin
      il := (LMWidth + 1) * 4;
      for x := 0 to LMWidth - 1 do  //smooth in y direction
      begin
        pc1 := PCardinal(iLMstart + x * 4 + il * (LMHeight - 2));
        pc2 := PCardinal(iLMstart + x * 4 + il * (LMHeight - 1));
        pc3 := PCardinal(iLMstart + x * 4);
        pc4 := PCardinal(iLMstart + x * 4 + il);
        pc5 := PCardinal(iLMstart + x * 4 + il * 2);
        c1 := pc1^;
        c2 := pc2^;
        c3 := pc3^;
        pc1 := pc3;
        for y := 1 to LMHeight do
        begin
          pc3^ := ipolC(c1, c2, c3, pc4^, pc5^);
          c1 := c2;
          c2 := c3;
          c3 := pc4^;
          pc3 := pc4;
          pc4 := pc5;
          if y = LMHeight - 1 then pc5 := pc1 else Inc(pc5, il shr 2);
        end;
        pc3^ := pc1^;
      end;
      for y := 0 to LMHeight - 1 do  //smooth in x direction
      begin
        pc1 := PCardinal(iLMstart + il * (y + 1) - 12);
        pc2 := PCardinal(iLMstart + il * (y + 1) - 8);
        pc3 := PCardinal(iLMstart + il * y);
        pc4 := PCardinal(iLMstart + il * y + 4);
        pc5 := PCardinal(iLMstart + il * y + 8);
        c1 := pc1^;
        c2 := pc2^;
        c3 := pc3^;
        pc1 := pc3;
        for x := 1 to LMWidth do
        begin
          pc3^ := ipolC(c1, c2, c3, pc4^, pc5^);
          c1 := c2;
          c2 := c3;
          c3 := pc4^;
          pc3 := pc4;
          pc4 := pc5;
          if x = LMWidth - 1 then pc5 := pc1 else Inc(pc5);
        end;
        pc3^ := pc1^;
      end;
    end;
    if ConvertToSpherical then
    with LM do
    begin
      if LM.iMapType = 0 then im := 4 else im := 6;
      il := (LMWidth + 1) * im;
      SetLength(ba, il + im);
      c1 := Cardinal(@ba[0]);
      sp := (LMWidth - 1) * 0.5;
      sw := LMWidth - 1.99;
      for y := 0 to LMHeight - 1 do
      begin
        pc3 := PCardinal(iLMstart + il * y);
        s := Cos(ArcSinSafe(2 * (y + 0.5) / LMHeight - 1));
        FastMove(pc3^, ba[0], il);
        FastMove(ba[im], ba[il], im);
        for x := 0 to LMWidth - 1 do
        begin
          s2 := MinCS((x - sp) * s + sp, sw);  //pixelpos
          ipolF(PCardinal(c1 + Trunc(s2) * im), Frac(s2), pc3);
          Inc(PByte(pc3), im);
          if x = 0 then FastMove(pc3^, d, im);
        end;
        FastMove(d, pc3^, im);
      end;
      c1 := iLMstart + il * LMHeight;
      for x := 0 to LMWidth do FastMove(PByte(iLMstart + x * im)^, PByte(c1 + x * im)^, im);
      SetLength(ba, 0);
    end;
end;

procedure FitLMborder(var LM: TLightMap; fitBorder: Integer);
var pa1, pa2: Pointer;
    c1: Cardinal;
    wc: T3word;
    s1, s2: Single;
    w, x, y, il, im: Integer;
begin
    if fitBorder <> 0 then
    with LM do
    begin
      if LM.iMapType = 0 then im := 4 else im := 6;
      w := 5;
      il := (LMWidth + 1) * im;
      for x := 0 to w do
      begin
        s2 := 0.5 - 0.5 * Sin(Pi * 0.5 * (x + 0.5) / (w + 1));
        s1 := 1 - s2;
        pa1 := Pointer(iLMstart + x * im);
        pa2 := Pointer(iLMstart + (LMWidth - x - 1) * im);
        for y := 1 to LMHeight do
        begin
          if im = 6 then
          begin
            wc := SVecToWordCol(AddSVectors(WordColToSVecScale(pa1, s1), WordColToSVecScale(pa2, s2)));
            TP3word(pa2)^ := SVecToWordCol(AddSVectors(WordColToSVecScale(pa1, s2), WordColToSVecScale(pa2, s1)));
            TP3word(pa1)^ := wc;
          end
          else
          begin
            c1 := SVecToColNoScale(AddSVectors(ColToSVecScale(PCardinal(pa1)^, s1), ColToSVecScale(PCardinal(pa2)^, s2)));
            PCardinal(pa2)^ := SVecToColNoScale(AddSVectors(ColToSVecScale(PCardinal(pa1)^, s2), ColToSVecScale(PCardinal(pa2)^, s1)));
            PCardinal(pa1)^ := c1;
          end;
          Inc(PByte(pa1), il);
          Inc(PByte(pa2), il);
        end;
      end;
      pa1 := Pointer(iLMstart);
      pa2 := Pointer(iLMstart + il - im);
      for y := 1 to LMHeight do
      begin
        if im = 6 then TP3word(pa2)^ := TP3word(pa1)^
                  else PCardinal(pa2)^ := PCardinal(pa1)^;
        Inc(PByte(pa1), il);
        Inc(PByte(pa2), il);
      end;
    end;
end;

procedure Make3Word(pBh, pBl: PByteArray; pW: TP3word);
begin
    pW[0] := (Integer(pBh[0]) shl 8) or pBl[0];
    pW[1] := (Integer(pBh[1]) shl 8) or pBl[1];
    pW[2] := (Integer(pBh[2]) shl 8) or pBl[2];
end;

function LoadLightMap(var LM: TLightMap; FileName: String; Smooth, Convert2Spherical, SetHGCursor: LongBool; fitBorder: Integer): LongBool;
var BMP: TBitmap;
    PNG: TPngObject;
    Pic: TPicture;
    x, y, xx: Integer;
    pc, pc2, pca: PCardinal;
    pw: TP3Word;
    pb1, pb2: PByte;
    c: Cardinal;
    bGrayScale: LongBool;
    tmpCursor: TCursor;
begin
  Result := False;
  tmpCursor := Screen.Cursor;
  if FileExists(FileName) then
  if CompareText(ExtractFileName(FileName), GetStringFromLightFilename(LM.LMfilename)) = 0 then
    Result := True
  else
  try
    if SetHGCursor then Screen.Cursor := crHourGlass;
    x := Length(FileName);
    if CompareText(Copy(FileName, x - 3, 4), '.png') = 0 then
    begin
      PNG := TPngObject.Create;
      PNG.LoadFromFile(FileName);
      if PNG.Header.BitDepth < 16 then x := 0 else
      begin
        bGrayScale := PNG.Header.ColorType in [0, 3];
        LM.LMWidth := PNG.Width;
        LM.LMHeight := PNG.Height;
        Result := (LM.LMWidth > 4) and (LM.LMHeight > 4);
        try
          SetLength(LM.LMa, ((LM.LMWidth + 1) * (LM.LMHeight + 1) * 6 + 6) div 4); //+xx in case of 8 Bytes access (mmx) to 3 words at the end
          LM.iMapType := 1;
          LM.sIntensity := 1;
          LM.iLMstart := Integer(@LM.LMa[0]);
          LM.sLMXfactor := LM.LMWidth;
          LM.sLMYfactor := LM.LMHeight;
          pw := TP3Word(LM.iLMstart);
          for y := 0 to LM.LMHeight do
          begin
            pb1 := PNG.ScanLine[y mod LM.LMHeight];
            pb2 := PNG.ExtraScanline[y mod LM.LMHeight];
            pc  := PCardinal(pb1);
            pc2 := PCardinal(pb2);
            for xx := 1 to LM.LMWidth do
            begin
              if bGrayScale then
              begin
                pw[0] := (Integer(pb1^) shl 8) or pb2^;
                pw[1] := pw[0];
                pw[2] := pw[0];
                Inc(pb1);
                Inc(pb2);
              end
              else
              begin
                Make3Word(PByteArray(pb1), PByteArray(pb2), pw);
                Inc(pb1, 3);
                Inc(pb2, 3);
              end;
              Inc(pw);
            end;
            if bGrayScale then
            begin
              pw[0] := (Integer(pb1^) shl 8) or pb2^;
              pw[1] := pw[0];
              pw[2] := pw[0];
            end
            else Make3Word(PByteArray(pc), PByteArray(pc2), pw);
            Inc(pw);
          end;
        except
          Result := False;
          x := 0;
        end;
      end;
      PNG.Free;
    end
    else x := 0;
    if x = 0 then
    begin
      BMP := TBitmap.Create;
      try
        Pic := TPicture.Create;
        try
          Pic.LoadFromFile(FileName);
          BMP.PixelFormat := pf32Bit;  //first assign pixelformat, else out of resources when imagesize is very great!?
          BMP.SetSize(Pic.Width, Pic.Height);
          BMP.Canvas.Draw(0, 0, Pic.Graphic);
        finally
          Pic.Free;
        end;
        LM.LMWidth := BMP.Width;
        LM.LMHeight := BMP.Height;
        Result := (LM.LMWidth > 3) and (LM.LMHeight > 3);
        if Result then
        try
          SetLength(LM.LMa, (LM.LMWidth + 1) * (LM.LMHeight + 1));
          LM.iMapType := 0;
          LM.sIntensity := 1;
          LM.iLMstart := Integer(@LM.LMa[0]);
          LM.sLMXfactor := LM.LMWidth;
          LM.sLMYfactor := LM.LMHeight;
          pca := PCardinal(LM.iLMstart);
          for y := 0 to LM.LMHeight do
          begin
            pc := BMP.ScanLine[y mod LM.LMHeight];  //div0 when height=0!
            c  := pc^;
            for x := 1 to LM.LMWidth do
            begin
              pca^ := pc^;
              Inc(pca);
              Inc(pc);
            end;
            pca^ := c;
            Inc(pca);
          end;
        except
          Result := False;
        end;
      finally
        BMP.Free;
      end;
    end;
    if Result then
    begin
      LM.sIntensity := 1;
      if Smooth or Convert2Spherical then SmoothLightMap(LM, Smooth, Convert2Spherical);
      FitLMborder(LM, fitBorder);
      PutStringInLightFilename(LM.LMfilename, ExtractFileName(FileName));
    end;
  except
    on E: Exception do
      Mand3DForm.OutMessage('Map: ' + ExtractFileName(FileName) + #13#10 + E.Message);
  end;
  if SetHGCursor then Screen.Cursor := tmpCursor;
//  if not Result then FreeLightMap(@LM);
end;

procedure LoadEmptyLightMap(var LM: TLightMap; Smooth, Convert2Spherical, SetHGCursor: LongBool; fitBorder: Integer);
var BMP: TBitmap;
    PNG: TPngObject;
    Pic: TPicture;
    x, y, xx: Integer;
    pc, pc2, pca: PCardinal;
    pw: TP3Word;
    pb1, pb2: PByte;
    c: Cardinal;
    bGrayScale: LongBool;
begin
  BMP := TBitmap.Create;
  try
    BMP.PixelFormat := pf32Bit;
    BMP.SetSize(64, 64);
    LM.LMWidth := BMP.Width;
    LM.LMHeight := BMP.Height;
    SetLength(LM.LMa, (LM.LMWidth + 1) * (LM.LMHeight + 1));
    LM.iMapType := 0;
    LM.sIntensity := 1;
    LM.iLMstart := Integer(@LM.LMa[0]);
    LM.sLMXfactor := LM.LMWidth;
    LM.sLMYfactor := LM.LMHeight;
    pca := PCardinal(LM.iLMstart);
    for y := 0 to LM.LMHeight do begin
      pc := BMP.ScanLine[y mod LM.LMHeight];
      c  := pc^;
      for x := 1 to LM.LMWidth do begin
        pca^ := pc^;
        Inc(pca);
        Inc(pc);
      end;
      pca^ := c;
      Inc(pca);
    end;
    LM.sIntensity := 1;
    if Smooth or Convert2Spherical then SmoothLightMap(LM, Smooth, Convert2Spherical);
    FitLMborder(LM, fitBorder);
    PutStringInLightFilename(LM.LMfilename, 'blank');
  finally
    BMP.Free;
  end;
end;

procedure FreeLightMap(LM: TPLightMap);
begin
    if LM <> nil then with LM^ do
    begin
      LMnumber := 0;
      LMWidth := 0;
      LMHeight := 0;
      LMfilename[0] := 0;
      SetLength(LMa, 0);
    end;
end;

procedure FreeLightMapsInLValsWithRestriction(LVal, LValRestricted: TPLightVals);
var i, Rcount: Integer;
    Restricted: array[0..15] of Integer;
function IsRestricted(nr: Integer): LongBool;
var i: Integer;
begin
    Result := False;
    for i := 0 to Rcount - 1 do if Restricted[i] = nr then
    begin
      Result := True;
      Break;
    end;
end;
procedure PutR(nr: Integer);
begin
    Restricted[Rcount] := nr;
    Inc(Rcount);
end;
procedure FreeSave(LM: TPLightMap);
begin
    if not IsRestricted(LM.LMnumber) then FreeLightMap(LM);
end;
begin
    Rcount := 0;
    if LValRestricted.iColOnOT > 1 then
      PutR(LValRestricted.DiffColLightMap.LMnumber);
    for i := 0 to 5 do if LValRestricted.iLightOption[i] = 2 then
      PutR(LValRestricted.LLightMaps[i].LMnumber);
    if LVal.iColOnOT > 1 then FreeSave(LVal.DiffColLightMap);
    for i := 0 to 5 do if LVal.iLightOption[i] = 2 then
      FreeSave(LVal.LLightMaps[i]);
end;

procedure FreeLightMapsInLVals(LVal: TPLightVals);
var i: Integer;
begin
    if LVal.iColOnOT > 1 then FreeLightMap(LVal.DiffColLightMap);
    for i := 0 to 5 do if LVal.iLightOption[i] = 2 then
      FreeLightMap(LVal.LLightMaps[i]);
end;

Initialization

  MapCriticalSection := TCriticalSection.Create;

finalization

  MapCriticalSection.Free;

end.
