unit Math3D;

interface

uses math;

type
  TSMatrix2 = array[0..1, 0..1] of Single;
  TMatrix3 = array[0..2, 0..2] of Double;
  TSMatrix3 = array[0..2, 0..3] of Single;
  TSMatrix4 = array[0..3, 0..3] of Single;
  TPSMatrix2 = ^TSMatrix2;
  TPMatrix3 = ^TMatrix3;
  TPSMatrix3 = ^TSMatrix3;
  TPSMatrix4 = ^TSMatrix4;
  TPos3D = array[0..2] of Double;
  TVec3D = array[0..2] of Double;
  TVec4D = array[0..3] of Double;
  TSVec = array[0..3] of Single;
  TPPos3D = ^TPos3D;
  TPVec3D = ^TVec3D;
  TPVec4D = ^TVec4D;
  TPSVec = ^TSVec;
  TSPoint = array[0..1] of Single;
  TPSPoint = ^TSPoint;
  TCAVWproc = procedure(V1, V2, V3: TPVec3D; const W: Double);
  TAVWproc = procedure(V1, V2: TPVec3D; const W: Double);
  T2Vproc = procedure(V1, V2: TPVec3D);
  T2Vproc4 = procedure(V1, V2: TPVec4D);
  TSVfunc = function(const V1: TSVec): TSVec;
  TSVfunc2 = function(const smin, smax: Single; const V1: TSVec): TSVec;
  TSVfunc3 = procedure(sv1: TPSVec);
  Double7B = array[0..6] of Byte;
  PDouble7B = ^Double7B;

  TQuaternion = array[0..3] of Double;
  TPQuaternion = ^TQuaternion;
  ShortFloat = array[0..1] of Shortint;
  PShortFloat = ^ShortFloat;
  TComplex = array[0..1] of Double;
  TPComplex = ^TComplex;
  T4Cardinal = array[0..3] of Cardinal;
  T4SVec = array[0..3] of TSVec;
  TP4SVec = ^T4SVec;
  T3SVec = array[0..2] of TSVec;
  TLNormals = array[0..2] of Smallint;
  TPLNormals = ^TLNormals;

function LengthOfSVec(const V: TSVec): Single;
function SVectorCross(const V1, V2: TSVec): TSVec;
function AddSVectors(const V1, V2: TSVec): TSVec;  overload;
procedure AddSVectors(V1: TPSVec; const V2: TSVec);  overload;
function AddSVectorsToDVec(const V1, V2: TSVec): TVec3D;
procedure AddVec(V1, V2: TPVec3D);  overload;
procedure AddVec(V1: TPVec3D; const V2: TVec3D);  overload;
function AddVecF(const V1, V2: TVec3D): TVec3D;
function AddSVec2Vec3(V1: TPSVec; V2: TPVec3D): TVec3D;
procedure AddSVec2Vec3d(const V1: TSVec; V2: TPVec3D);
procedure mAddVecWeight(V1, V2: TPVec3D; const W: Double);
procedure AddSVecWeight(V1, V2: TPSVec; W: Double);
procedure ChangeMathFuncsToSSE2;
procedure mCopyVec(Vd, Vs: TPVec3D);
procedure CopyVec4(V1, V2: TPVec4D);
procedure mCopyAddVecWeight(V1, V2, V3: TPVec3D; const W: Double);
procedure CopyAddSVecWeight(V1, V2: TPVec3D; V3: TPSVec; const W: Double);
procedure AddSubVecWeight(V1, V2, V3: TPVec3D; const W: Double);
procedure BuildRotMatrix(const xa, ya, za: Double; M: TPMatrix3);
procedure BuildRotMatrixS(const xa, ya, za: Double; M: TPSMatrix3);
procedure InvertSMatrix(M: TPSMatrix3);
procedure RotateVector(V: TPVec3D; M: TPMatrix3);
procedure ScaleMatrix(const s: Double; M: TPMatrix3);
procedure ScaleSMatrix(const s: Double; M: TPSMatrix3);
procedure Multiply2Matrix(M1, M2: TPMatrix3);
procedure Multiply2SMatrix(M1, M2: TPSMatrix3);
//procedure BuildRotMatrixFOV(var xa, ya: Double; M: TPMatrix3);
//function InvertMatrix(m: TPMatrix3): TMatrix3;
procedure MatrixToQuat(M1: TMatrix3; var Q: TQuaternion);
procedure SMatrixToQuat(M1: TSMatrix3; var Q: TQuaternion);
procedure QuatToAxisAngle(var xAxes, yAxes, zAxes, angle: Double; Quat: TQuaternion);
function AxisAngleToQuat(var x, y, z, angle: Double): TQuaternion;
procedure CreateMatrixFromQuat(var M: TMatrix3; var Q: TQuaternion);
procedure CreateSMatrixFromQuat(var M: TSMatrix3; var Q: TQuaternion);
function SlerpQuat(Q1, Q2: TQuaternion; const w2: Double): TQuaternion;
//function LerpQuat(Q1, Q2: TQuaternion; w2: Double): TQuaternion;
function InvertQuat(const Q: TQuaternion): TQuaternion;
//procedure BuildRotMatrixX(var xa: Double; M: TPMatrix3);
//procedure BuildRotMatrixY(var ya: Double; M: TPMatrix3);
function NormaliseMatrixTo(const n: Double; M: TPMatrix3): TMatrix3;
function NormaliseSMatrixTo(const n: Double; M: TPSMatrix3): TSMatrix3;
function NormaliseMatrixToS(const n: Double; M: TPMatrix3): TSMatrix3;
function GetQuatFromEuler(const A: TVec3D): TQuaternion;
function GetEulerFromQuat(const Q: TQuaternion): TVec3D;
function DotOfQuats(const Q1, Q2: TQuaternion): Double;
function DotOfVectors(V1, V2: TPVec3D): Double;
function DotOfVectorsNormalize(V1, V2: TPVec3D): Double;
function DotOfSVectors(const V1, V2: TSVec): Single;
function SubtractVectors2s(const V1, V2: TVec3D): TSVec;
function SubtractVectors(const V1, V2: TVec3D): TVec3D;  overload;
function SubtractVectors(V1: TPVec3D; const V2: TVec3D): TVec3D;  overload;
function SubtractVectors(const V1: TVec3D; V2: TPVec3D): TVec3D;  overload;
function SubtractSVectors(V1: TPSVec; const V2: TSVec): TSVec;
function ScaleVector(const V1: TVec3D; const s: Double): TVec3D;
function ScaleSVector(const V1: TSVec; const s: Single): TSVec;
function ScaleSVector4(const V1: TSVec; const s: Single): TSVec;
function ScaleSVectorD(V1: TPSVec; const d: Double): TSVec;
procedure ScaleVectorV(V1: TPVec3D; const s: Double);
procedure ScaleSVectorV(V1: TPSVec; const s: Single);
function NormaliseVector(V: TPVec3D): TVec3D;
function NormaliseVectorF(const V: TVec3D): TVec3D;
procedure NormaliseVectorVar(var V: TVec3D);
function NormaliseSVectorTo(const n: Double; const V: TSVec): TVec3D;
function NormaliseSVectorToS2(const n: Double; const V: TSVec): TSVec;
//procedure NormaliseSVectorToS(n: Double; var V: TSVec);
function NormaliseVectorTo(const n: Double; const V: TVec3D): TVec3D;  overload;
procedure NormaliseVectorTo(const n: Double; V: TPVec3D);  overload;
function NormaliseSVector(const V: TSVec): TSVec;
procedure NormaliseSVectorVar(var V: TSVec);
procedure BuildViewVectorDFOV(var xa, ya: Double; v: TPVec3D);
procedure BuildViewVectorFOV(var xa, ya: Double; v: TPSVec);
procedure BuildViewVectorDSphereFOV(var xa, ya: Double; v: TPVec3D);
procedure BuildViewVectorSphereFOV(var xa, ya: Double; v: TPSVec);
procedure TranslatePos(V, VT: TPVec3D; M: TPMatrix3);
procedure RotateSVector(V: TPSVec; M: TPMatrix3);
procedure RotateSVectorReverse(V: TPSVec; M: TPMatrix3);
procedure RotateVectorReverse(V: TPVec3D; M: TPMatrix3);
procedure RotateSVectorS(V: TPSVec; M: TPSMatrix3);
procedure RotateVectorS(V: TPVec3D; M: TPSMatrix3);
procedure RotateVectorReverseS(V: TPVec3D; M: TPSMatrix3);
procedure RotateSVectorReverseS(V: TPSVec; M: TPSMatrix3);
function SingleToShortFloat(s: Single): ShortFloat;
function ShortFloatToSingle(sf: PShortFloat): Single;
function SlerpSVec(V1, V2: TPSVec; const t: Single): TSVec;
//procedure BuildRotMatrixXY(var xa, ya: Double; M: TPMatrix3);
function LengthOfVec(const V: TVec3D): Double;
function SqrLengthOfVec(const V: TVec3D): Double;
function SqrLengthOfSVec(const V: TSVec): Single;
function QBezier(const Q0, Q1, Q2: TQuaternion; const t: Double): TQuaternion;
//function QCubic(Q0, Q1, Q2, Q3: TQuaternion; t: Double): TQuaternion;
function CubicIpol4SVecs(SV1, SV2, SV3, SV4: TPSVec; const t: Double): TSVec;
function BezierIpol3SVecs(SV1, SV2, SV3: TPSVec; const t: Double): TSVec;
function DistanceOf2Vecs(V1, V2: TPVec3D): Double;
//procedure BuildViewVectorFOVprecalc(var ya: Double; Ysincos: TPVec3D; v: TPSVec);
function aMedian(const Count: Integer; var List: array of Double;
                 const select: Single): Double;
function RotAxisSVecToQuat(const SVec: TSVec; const angle: Single): TQuaternion;
function ArcCosSafe(const d: Double): Double;
function ArcSinSafe(const d: Double): Double;
function MakeRotQuatFromSNormals(const NVec: TSVec): TQuaternion;
procedure AddSVecWeightS(V1, V2: TPSVec; const W: Single);  overload;
procedure AddSVecWeightS(var V1: TSVec; const V2: TSVec; const W: Single);  overload;
function MultiplySVectors(const V1, V2: TSVec): TSVec;
procedure MultiplySVectorsV(V1, V2: TPSVec);  overload;
procedure MultiplySVectorsV(V1: TPSVec; const V2: TSVec);  overload;
function AddSVecS(const V1: TSVec; const s: Single): TSVec;
procedure NormaliseQuat(var Quat: TQuaternion);
function MaxCS(s1, s2: Single): Single;
function MinCS(const s1, s2: Single): Single;
function MinMaxCS(const smin, s, smax: Single): Single;
function Min0MaxCS(const s, smax: Single): Single;
function Min0MaxCD(const d, dmax: Double): Double;
function MinMaxCD(const dmin, d, dmax: Double): Double;
function MinCD(const s1, s2: Double): Double;
function MaxCD(const s1, s2: Double): Double;
function Clamp0D(const d: Double): Double;
procedure CreateXYVecsFromNormals(N, VX, VY: TPVec3D);
function MaxAbsCD(const s1, s2: Double): Double;
function MinAbsCD(const s1, s2: Double): Double;
procedure BuildSMatrix4(const dXWrot, dYWrot, dZWrot: Double; var Smatrix4: TSMatrix4);
procedure Rotate4Dex(Vin: TPVec3D; Vout: TPVec4D; SM4: TPSMatrix4);
//procedure Rotate4D(V4: TPVec4D; SM4: TPSMatrix4);
procedure BuildRotMatrix4d(angles: array of Double; var ms4: TSMatrix4);
//function q_pow(const qa, qb: TQuaternion): TQuaternion;
function VectorCross(const V1, V2: TVec3D): TVec3D;
function SVecToDVec(const V1: TSVec): TVec3D;
function DVecToSVec(const V1: TVec3D): TSVec;
procedure SVectorChangeSign(V1: TPSVec);
function mSqrtSVec(const V1: TSVec): TSVec;
function SqrtPosSVec(const V1: TSVec): TSVec;
procedure ChangeMathFuncsToSSE;
function MinMaxSVecPas(const smin, smax: Single; const V1: TSVec): TSVec;
function MinMaxSVecSSE(const smin, smax: Single; const V1: TSVec): TSVec;
function MakeSVecMultiplierFromDynFogCol(sv: TSVec): TSVec;
function MakeSVecFromNormals(PsiLight: Pointer): TSVec;
function MakeDVecFromNormals(PsiLight: Pointer): TVec3D;
function FastPow(const x, y: Single): Single;
function MaxSVec(const V1, V2: TSVec): TSVec;
function MinMaxSVecMC(const V1: TSVec): TSVec;
procedure ClearSVec(var sv: TSVec);
function SqrSVec(const V1: TSVec): TSVec;
procedure ClearDVec(var dv: TVec3D);
function DistanceOf2lines(const P1, P2, V1, V2: TVec3D): Double;
procedure SinCosD(const a: Double; var Sin, Cos: Double);
procedure SinCosS(const a: Double; var Sin, Cos: Single);
procedure SVecToNormals(const sv: TSVec; pn: Pointer);
function LinInterpolate2SVecs(const sv1, sv2: TSVec; const w1: Single): TSVec;
function Add2SVecsWeight(const sv1, sv2: TSVec; const w1, w2: Single): TSVec;
function Add2SVecsWeight2(const sv1, sv2: TSVec; const w2: Single): TSVec;
function MakeSVecFromNormalsD(PsiLight: Pointer): TSVec;
function Add3SVectors(const V1, V2, V3: TSVec): TSVec;
function MakeSplineCoeff(const xs: Double): TSVec;
function SqrDistSV(const sv1, sv2: TSVec): Single;
function FastIntPow(const base: Single; const expo: Integer): Single;  //powers with expo in 2^x
procedure MinMaxSvar(const smin, smax: Single; var s: Single);
function Clamp01S(const sv: Single): Single;
function Clamp01D(const dv: Double): Double;
procedure Clamp01Svar(var sv: Single);
function Max0S(s: Single): Single;
procedure MakeWNormalsFromDVec(PsiLight: TPLNormals; PDVec: TPVec3D);
function D7BtoDouble(const D7B: Double7B): Double;
function DoubleToD7B(const D: Double): Double7B;
//procedure CopyD(PDsrc, PDdest: Pointer);
procedure MaxCDvar(var ds, ddest: Double);
procedure Clamp1Svar(var s: Single);
function D7Bequal(d1, d2: Double7B): LongBool;
function AbsSVec(sv: TSVec): TSVec;
procedure AbsSVecVar(var sv: TSVec);
function YofSVec(sv: TPSVec): Single;
function MaxOfSVec(sv: TPSVec): Single;
function SVecPow(const sv: TSVec; const sExp: Single): TSVec;
procedure FlipVecs(V1, V2: TPVec3D);
function sNotZero(s: Single): Single;
//function EulerToQuat(x, y, z: Double): TQuaternion;
function MatrixToAngles(var v3: TVec3D; M: TPMatrix3): LongBool;
procedure MakeOrthoVecs(Vin: TPVec3D; Vortho: TPSVec);  //Vortho = TPLightSD !!!
procedure MakeOrthoVecsD(Vin, Vx, Vy: TPVec3D);
function NotZero(d: Double): Double;
procedure Clamp0SvecPas(sv1: TPSVec);
//procedure Clamp08SvecPas(sv1: TPSVec);
{procedure RGB2YUV(sv1: TPSVec);
procedure YUV2RGB(sv1: TPSVec);    }
procedure YUV2RGBd(vec: TPVec3D);
function SignedSqr(d: Double): Double;
function SignedSqrt(d: Double): Double;
function NotZeroSVec(sv: TPSVec): LongBool;
function FracSingle(const s: Single): Single;
function SingleToPosShortF(s: Single): Word;
function PosShortFToSingle(psf: Word): Single;
procedure mClampSqrtSVecV(v: TPSVec);
procedure mClampSqrSVecV(v: TPSVec);
function MakeVec(d1, d2, d3: Double): TVec3D;
//{$ALIGN 16}

var
 // mAddVecWeight:     TAVWproc = AddVecWeight;
//  mCopyVec:          T2Vproc = CopyVec;
//  mCopyAddVecWeight: TCAVWproc = CopyAddVecWeight;
  mAddSubVecWeight:  TCAVWproc = AddSubVecWeight;
  mCopyVec4:         T2Vproc4 = CopyVec4;
//  mSqrtSVec:         TSVfunc = SqrtSVecPas;
  mMinMaxSVec:       TSVfunc2 = MinMaxSVecPas;
  mClamp0SVec:       TSVfunc3 = Clamp0SVecPas;
//  mClamp08SVec:      TSVfunc3 = Clamp08SVecPas;

implementation

uses DivUtils, TypeDefinitions;

{$CODEALIGN 16}

function MakeVec(d1, d2, d3: Double): TVec3D;
begin
    Result[0] := d1;
    Result[1] := d2;
    Result[2] := d3;
end;

function NotZeroSVec(sv: TPSVec): LongBool;  //eax  0, $FFFFFFFF
//begin               //eax
  //  Result := (sv[0] <> 0) or (sv[1] <> 0) or (sv[2] <> 0);
asm
    mov edx, [eax]
    or  edx, [eax + 4]
    or  edx, [eax + 8]
    xor eax, eax
    test edx, edx
    jz  @@1
    mov eax, $FFFFFFFF
@@1:
end;

function SignedSqr(d: Double): Double;
begin
    if d < 0 then Result := - Sqr(d) else Result := Sqr(d);
end;

function SignedSqrt(d: Double): Double;
begin
    if d < 0 then Result := - Sqrt(- d) else Result := Sqrt(d);
end;

function sNotZero(s: Single): Single;
begin
    if Abs(s) > 0.01 then Result := s else
    if s < 0 then Result := -0.01 else Result := 0.01;
end;

function NotZero(d: Double): Double;
begin
    if Abs(d) > 1e-16 then Result := d else
    if d < 0 then Result := d * 0.5 - 0.5e-16
             else Result := d * 0.5 + 0.5e-16;
end;

procedure Clamp0SvecPas(sv1: TPSVec);
begin
    if sv1[0] < 0 then sv1[0] := 0;
    if sv1[1] < 0 then sv1[1] := 0;
    if sv1[2] < 0 then sv1[2] := 0;
end;

procedure Clamp0SvecSSE(sv1: TPSVec);
asm
    movups  xmm0, [eax]
    xorps   xmm1, xmm1
    maxps   xmm0, xmm1
    movups  [eax], xmm0
end;

{procedure Clamp08SvecPas(sv1: TPSVec);
begin
    if sv1[0] < 0 then sv1[0] := 0 else if sv1[0] > 8 then sv1[0] := 8;
    if sv1[1] < 0 then sv1[1] := 0 else if sv1[1] > 8 then sv1[1] := 8;
    if sv1[2] < 0 then sv1[2] := 0 else if sv1[2] > 8 then sv1[2] := 8;
end;

procedure Clamp08SvecSSE(sv1: TPSVec);
const s8: array[0..3] of Single = (8,8,8,8);
asm
    movups  xmm0, [eax]
    movups  xmm1, s8
    xorps   xmm2, xmm2
    minps   xmm0, xmm1
    maxps   xmm0, xmm2
    movups  [eax], xmm0
end;

{procedure RGB2YUV(sv1: TPSVec);
var y: Single;
begin
    y := 0.299 * sv1[0] + 0.587 * sv1[1] + 0.114 * sv1[2];
    sv1[1] := (sv1[2] - y) * 0.493;
    sv1[2] := (sv1[0] - y) * 0.877;
    sv1[0] := y;
end;

procedure YUV2RGB(sv1: TPSVec);
var y, u: Single;
begin
    y := sv1[0];
    u := sv1[1];
    sv1[0] := y + sv1[2] * 1.1402508551881414;
    sv1[1] := y - 0.58080920903 * sv1[2] - 0.39393070275 * u;
    sv1[2] := y + u * 2.0283975659229209;
end;  }

procedure YUV2RGBd(vec: TPVec3D);
var y, u: Double;
begin
    y := vec[0];
    u := vec[1];
    vec[0] := y + vec[2] * 1.1402508551881414;
    vec[1] := y - 0.58080920903 * vec[2] - 0.39393070275 * u;
    vec[2] := y + u * 2.0283975659229209;
end;

{function SVectorCross(const V1, V2: TSVec): TSVec;
    Result[0] := V1[1] * V2[2] - V1[2] * V2[1];
    Result[1] := V1[2] * V2[0] - V1[0] * V2[2];
    Result[2] := V1[0] * V2[1] - V1[1] * V2[0]; }

procedure MakeOrthoVecs(Vin: TPVec3D; Vortho: TPSVec);
var NVec: TVec3D;
    d: Double;
begin
    NVec := NormaliseVector(Vin);
    if Abs(NVec[0]) > 0.1 then
    begin
      d := 1 / Sqrt(Sqr(NVec[0]) + Sqr(NVec[2]));
      Vortho[0] := NVec[2] * d;
      Vortho[1] := 0;
      Vortho[2] := -NVec[0] * d;
    end else begin
      d := 1 / Sqrt(Sqr(NVec[1]) + Sqr(NVec[2]));
      Vortho[0] := 0;
      Vortho[1] := -NVec[2] * d;
      Vortho[2] := NVec[1] * d;
    end;
//    NormaliseSVectorVar(Vortho^);
    TPLightSD(Vortho)^[1][0] := Vortho[1] * NVec[2] - Vortho[2] * NVec[1];
    TPLightSD(Vortho)^[1][1] := Vortho[2] * NVec[0] - Vortho[0] * NVec[2];
    TPLightSD(Vortho)^[1][2] := Vortho[0] * NVec[1] - Vortho[1] * NVec[0];
  //  TPLightSD(Vortho)^[1] := SVectorCross(Vortho^, NVec);
end;

procedure MakeOrthoVecsD(Vin, Vx, Vy: TPVec3D);
var NVec: TVec3D;
begin
    NVec := NormaliseVector(Vin);
    if Abs(NVec[0]) > 0.1 then
    begin
      Vx[0] := NVec[2];
      Vx[1] := 0;
      Vx[2] := -NVec[0];
    end else begin
      Vx[0] := 0;
      Vx[1] := -NVec[2];
      Vx[2] := NVec[1];
    end;
    NormaliseVectorVar(Vx^);
    Vy^ := VectorCross(Vx^, NVec);
end;

procedure FlipVecs(V1, V2: TPVec3D);
asm
    fld  qword [eax]
    fld  qword [eax + 8]
    fld  qword [eax + 16]
    fld  qword [edx]
    fld  qword [edx + 8]
    fld  qword [edx + 16]
    fstp qword [eax + 16]
    fstp qword [eax + 8]
    fstp qword [eax]
    fstp qword [edx + 16]
    fstp qword [edx + 8]
    fstp qword [edx]
end;

function SVecPow(const sv: TSVec; const sExp: Single): TSVec;
begin
    Result[0] := Power(sv[0], sExp);
    Result[1] := Power(sv[1], sExp);
    Result[2] := Power(sv[2], sExp);
    Result[3] := 0;
end;

function YofSVec(sv: TPSVec): Single;
asm   //  Result := sv[0] * s03 + sv[1] * s059 + sv[2] * s011;
    fld  dword [eax]
    fmul s03
    fld  dword [eax + 4]
    fmul s059
    faddp
    fld  dword [eax + 8]
    fmul s011
    faddp
    ftst
    fnstsw ax
    shr  ah, 1
    jnc  @@1
    fstp st
    fldz
@@1:
end;

function MaxOfSVec(sv: TPSVec): Single;
{begin
    Result := sv[0];
    if sv[1] > Result then Result := sv[1];
    if sv[2] > Result then Result := sv[2];
end; }
asm
    cmp  SupportSSE, 0
    jz   @@1
    push edx
    movss  xmm0, [eax]
    maxss  xmm0, [eax + 4]
    maxss  xmm0, [eax + 8]
    movss  [esp], xmm0
    fld  dword [esp]
    pop  edx
    ret
@@1:
    mov  edx, eax
    fld  dword [eax]
    fcom dword [edx + 4]
    fnstsw ax
    and  ah, 41H
    jz   @@up1
    fstp st
    fld  dword [edx + 4]
@@up1:
    fcom dword [edx + 8]
    fnstsw ax
    and  ah, 41H
    jz   @@up2
    fstp st
    fld  dword [edx + 8]
@@up2:
end;

procedure AbsSVecVar(var sv: TSVec);
begin
    sv[0] := Abs(sv[0]);
    sv[1] := Abs(sv[1]);
    sv[2] := Abs(sv[2]);
end;

function AbsSVec(sv: TSVec): TSVec;
begin
    Result[0] := Abs(sv[0]);
    Result[1] := Abs(sv[1]);
    Result[2] := Abs(sv[2]);
    Result[3] := 0;
end;
               // eax, edx
function D7Bequal(d1, d2: Double7B): LongBool;
{begin
    Result := (d1[0] = d2[0]) and (d1[1] = d2[1]) ...;  }
asm
  push ecx
  mov  ecx, [eax]
  cmp  ecx, [edx]
  jne  @@1
  mov  cx, [eax + 4]
  cmp  cx, word [edx + 4]
  jne  @@1
  mov  cl, [eax + 6]
  cmp  cl, byte [edx + 6]
  jne  @@1
  mov  eax, $FFFFFFFF
  jmp  @@2
@@1:
  xor  eax, eax
@@2:
  pop  ecx
end;
                       //  eax               st
function D7BtoDouble(const D7B: Double7B): Double;
//begin
 //   Result := PDouble(Integer(@D7B) - 1)^;  //and $FFFFFFFFFFFFFF00;
asm
    add  esp, -8
    xor  edx, edx
    mov  [esp], edx
    mov  edx, [eax]
    mov  [esp + 1], edx
    mov  edx, [eax + 3]
    mov  [esp + 4], edx
    fld  qword [esp]
    add  esp, 8
end;
                     // ebp+8           eax
function DoubleToD7B(const D: Double): Double7B;
{begin
    PInteger(@Result)^ := PInteger(Integer(@D) + 1)^;
    PWord(Integer(@Result) + 4)^ := PWord(Integer(@D) + 5)^;
    PByte(Integer(@Result) + 6)^ := PByte(Integer(@D) + 7)^; }
asm
    mov  edx, [ebp + 9]
    mov  [eax], edx
    mov  edx, [ebp + 12]
    mov  [eax + 3], edx
end;

                              //  eax                 edx
procedure MakeWNormalsFromDVec(PsiLight: TPLNormals; PDVec: TPVec3D);
{var dt2: Double;
begin
    dT2 := 32767 / Sqrt(Sqr(PDVec[0]) + Sqr(PDVec[1]) + Sqr(PDVec[2]) + d1em100);
    PsiLight[0] := Round(PDVec[0] * dT2);   //3 normals a 16bit
    PsiLight[1] := Round(PDVec[1] * dT2);
    PsiLight[2] := Round(PDVec[2] * dT2);  }
asm
    fld  qword [edx]
    fld  st
    fmul st, st           //x²,x
    fld  qword [edx + 8]
    fld  st
    fmul st, st           //y²,y,x²,x
    faddp st(2), st       //y,x²+y²,x
    fld  qword [edx + 16]
    fld  st
    fmul st, st           //z²,z,y,x²+y²,x
    faddp st(3), st       //z,y,x²+y²+z²,x
    fxch  st(2)           //x²+y²+z²,y,z,x
    fadd  d1em100
    fsqrt
    fdivr d32767         
    fmul  st(3), st
    fmul  st(2), st
    fmulp                 //y',z',x'
    fistp word [eax + 2]
    fistp word [eax + 4]
    fistp word [eax]
end;

                  //     ebp+8                 eax              st
function FastIntPow(const base: Single; const expo: Integer): Single;  //powers with expo in 2^x  x in[1..much] for spec painting, if ipol, expo could be float!
{var i: Integer;
begin
    if base < 0 then Result := 0 else
    begin
      Result := base;
      i := expo shr 1;
      while i > 0 do
      begin
        Result := Result * Result;
        i := i shr 1;
      end;
    end; }
asm
    fld  dword [ebp + 8]
    mov  edx, eax
    ftst
    fnstsw ax
    shr  ah, 1
    jnc  @@1
    fstp st
    fldz
    jmp  @@end
@@1:
    shr  edx, 1
@@2:
    fmul st, st
    shr  edx, 1
    jnz  @@2
@@end:
end;
                  // ebp+8          st
function Clamp0D(const d: Double): Double;
{begin
    if d <= 0 then Result := 0
              else Result := d;  }
asm
    fld  qword [ebp + 8]
    ftst
    fnstsw ax
    shr  ah, 1
    jnc  @@end
    fstp st
    fldz
@@end:
end;
                   //ebp+8            st
function Clamp01S(const sv: Single): Single;
{begin
    if sv <= 0 then Result := 0 else
    if sv > 1 then Result := 1 else Result := sv; }
asm
    fld  dword [ebp + 8]
    ftst
    fnstsw ax
    shr  ah, 1
    jnc  @@1
    fstp st
    fldz
    jmp  @@end
@@1:
    fld1
    fcomp st(1)
    fnstsw ax
    shr  ah, 1
    jnc  @@end
    fstp st
    fld1
@@end:
end; //ret 4

function Clamp01D(const dv: Double): Double;
asm
    fld  qword [ebp + 8]
    ftst
    fnstsw ax
    shr  ah, 1
    jnc  @@1
    fstp st
    fldz
    jmp  @@end
@@1:
    fld1
    fcomp st(1)
    fnstsw ax
    shr  ah, 1
    jnc  @@end
    fstp st
    fld1
@@end:
end;

procedure Clamp01Svar(var sv: Single);
begin
    if sv <= 0 then sv := 0 else
    if sv > 1 then sv := 1;
end;

function MinDistSV(const sv1, sv2: TSVec): TSVec;
begin
    Result[0] := sv1[1] * sv2[2] - sv1[2] * sv2[1];
    Result[1] := sv1[2] * sv2[0] - sv1[0] * sv2[2];
    Result[2] := sv1[0] * sv2[1] - sv1[1] * sv2[0];
end;

function SqrDistSV(const sv1, sv2: TSVec): Single;
begin
    Result := SqrLengthOfSVec(MinDistSV(sv1, SubtractSVectors(@sv1, sv2)));
end;

                              //ebp+8        eax
function MakeSplineCoeff(const xs: Double): TSVec;
{begin
    Result[3] := d1d6 * xs * xs * xs;
    Result[0] := d1d6 + 0.5 * xs * (xs - 1.0) - Result[3];
    Result[2] := xs + Result[0] - 2.0 * Result[3];
    Result[1] := 1.0 - Result[0] - Result[2] - Result[3];  }
asm
    fld  d1d6
    fld  qword [ebp + 8]
    fld  st
    fmul st, st
    fmul st, st(1)
    fmul st, st(2)
    fst  dword [eax + 12] //Result[3],xs,d1d6
    fld1
    fsub st, st(2)        //1-xs,Result[3],xs,d1d6
    fmul st, st(2)
    fmul s05
    fsubp st(3), st       //Result[3],xs,d1d6 + 0.5 * xs * (xs - 1.0)
    fsub st(2), st        //Result[3],xs,Result[0]
    fxch                  //xs,Result[3],Result[0]
    fadd st, st(2)
    fsub st, st(1)
    fsub st, st(1)        //Result[2],Result[3],Result[0]
    fst  dword [eax + 8]
    fld1
    fsubrp                //1-Result[2],Result[3],Result[0]
    fsubrp                //1-Result[2]-Result[3],Result[0]
    fsub st, st(1)        //1-Result[2]-Result[3]-Result[0],Result[0]
    fstp dword [eax + 4]
    fstp dword [eax]
end;

                             // eax edx              ebp+8         ecx
function Add2SVecsWeight2(const sv1, sv2: TSVec; const w2: Single): TSVec;
asm
{    cmp  SupportSSE, 0
    jz  @@1
    movss  xmm2, [ebp + 8]
    movups xmm1, [edx]
    shufps xmm2, xmm2, $C0
    movups xmm0, [eax]
    mulps  xmm1, xmm2
    addps  xmm0, xmm1
    movups [ecx], xmm0
    pop ebp
    ret 4
@@1: }
    fld  dword [edx]
    fld  dword [edx + 4]
    fld  dword [edx + 8]
    fld  dword [ebp + 8]
    fmul st(3), st
    fmul st(2), st
    fmulp
    fadd dword [eax + 8]
    fstp dword [ecx + 8]
    fadd dword [eax + 4]
    fstp dword [ecx + 4]
    fadd dword [eax]
    fstp dword [ecx]
    xor  eax, eax
    mov  [ecx + 12], eax
end;
                                  // eax edx              ebp+8        ecx
function LinInterpolate2SVecs(const sv1, sv2: TSVec; const w1: Single): TSVec;
{begin
    Result[0] := sv1[0] * w1 + sv2[0] * (1 - w1);   = sv2[0] + w1 * (sv1[0] - sv2[0]);
    Result[1] := sv1[1] * w1 + sv2[1] * (1 - w1);
    Result[2] := sv1[2] * w1 + sv2[2] * (1 - w1);
    Result[3] := sv1[3] * w1 + sv2[3] * (1 - w1);  }
asm
    cmp  SupportSSE, 0
    jz  @@1
    movss  xmm2, [ebp + 8]
    movups xmm0, [eax]
    movups xmm1, [edx]
    shufps xmm2, xmm2, 0
    subps  xmm0, xmm1
    mulps  xmm0, xmm2
    addps  xmm0, xmm1
    movups [ecx], xmm0
    pop ebp
    ret 4
@@1:
    fld  dword [edx]
    fld  dword [edx + 4]
    fld  dword [edx + 8]
    fld  dword [edx + 12]
    fld  dword [ebp + 8]
    fld  dword [eax]
    fld  dword [eax + 4]
    fld  dword [eax + 8]  //s12,s11,s10,w1,s23,s22,s21,s20
    fsub st, st(5)
    fmul st, st(3)
    faddp st(5), st       //s11,s10,w1,s23,result2,s21,s20
    fsub st, st(5)
    fmul st, st(2)
    faddp st(5), st       //s10,w1,s23,result2,result1,s20
    fsub st, st(5)
    fmul st, st(1)
    faddp st(5), st       //w1,s23,result2,result1,result0
    fld  dword [eax + 12]
    fsub st, st(2)        //..,w1,s23,result2,result1,result0
    fmulp                 //..*w1,s23,result2,result1,result0
    faddp
    fstp dword [ecx + 12]
    fstp dword [ecx + 8]
    fstp dword [ecx + 4]
    fstp dword [ecx]
end;

                            // eax edx           ebp+12 ebp+8          ecx
function Add2SVecsWeight(const sv1, sv2: TSVec; const w1, w2: Single): TSVec;
{begin
    Result[0] := sv1[0] * w1 + sv2[0] * w2;
    Result[1] := sv1[1] * w1 + sv2[1] * w2;
    Result[2] := sv1[2] * w1 + sv2[2] * w2;
    Result[3] := 0; }
asm
    cmp  SupportSSE, 0
    jz  @@1
    movss  xmm2, [ebp + 12]
    movss  xmm3, [ebp + 8]
    movups xmm0, [eax]
    movups xmm1, [edx]
    shufps xmm2, xmm2, $C0
    shufps xmm3, xmm3, $C0
    mulps  xmm0, xmm2
    mulps  xmm1, xmm3
    addps  xmm0, xmm1
    movups [ecx], xmm0
    pop ebp
    ret 8
@@1:
    fld  dword [edx]
    fld  dword [edx + 4]
    fld  dword [edx + 8]
    fld  dword [ebp + 8]
    fmul st(3), st
    fmul st(2), st
    fmulp
    fld  dword [eax]
    fld  dword [eax + 4]
    fld  dword [eax + 8]
    fld  dword [ebp + 12]
    fmul st(3), st
    fmul st(2), st
    fmulp                 //s12,s11,s10,s22,s21,s20
    xor  eax, eax
    faddp st(3), st       //s11,s10,result2,s21,s20
    faddp st(3), st
    faddp st(3), st       //result2,result1,result0
    fstp dword [ecx + 8]
    fstp dword [ecx + 4]
    fstp dword [ecx]
    mov  [ecx + 12], eax
end;

function AddSVectorsToDVec(const V1, V2: TSVec): TVec3D;
begin
    Result[0] := V1[0] + V2[0];
    Result[1] := V1[1] + V2[1];
    Result[2] := V1[2] + V2[2];
end;

function DistanceOf2lines(const P1, P2, V1, V2: TVec3D): Double;  //not used
var n, p: TVec3D;
begin
    p := SubtractVectors(@P1, P2);
    n := VectorCross(V1, V2);
    Result := (p[0] * n[0] + p[1] * n[1] + p[2] * n[2]) / LengthOfVec(n);
end;

procedure ClearSVec(var sv: TSVec);
asm
    xor  edx, edx
    mov  [eax], edx
    mov  [eax + 4], edx
    mov  [eax + 8], edx
    mov  [eax + 12], edx
end;

procedure ClearDVec(var dv: TVec3D);
asm
    fldz
    fst  qword [eax]
    fst  qword [eax + 8]
    fstp qword [eax + 16]
end;

function MaxSVec(const V1, V2: TSVec): TSVec;  //not used
begin
    Result[0] := MaxCS(V1[0], V2[0]);
    Result[1] := MaxCS(V1[1], V2[1]);
    Result[2] := MaxCS(V1[2], V2[2]);
    Result[3] := 0;
end;

function SqrSVec(const V1: TSVec): TSVec;
begin
    Result[0] := Sqr(V1[0]);
    Result[1] := Sqr(V1[1]);
    Result[2] := Sqr(V1[2]);
    Result[3] := 0;
end;

procedure mClampSqrtSVecV(v: TPSVec);
asm
  xor  edx, edx
  mov  [eax + 12], edx
  cmp  SupportSSE, 0
  jz   @@1
  movups xmm0, [eax]
  xorps  xmm1, xmm1
  maxps  xmm0, xmm1
  sqrtps xmm0, xmm0
  movups [eax], xmm0
  ret
@@1:
  mov  edx, eax
  fld  dword [edx]
  ftst
  fnstsw ax
  shr  ah, 1
  jnc  @@2
  fstp st
  fldz
  jmp  @@21
@@2:
  fsqrt
@@21:
  fstp dword [edx]
  fld  dword [edx + 4]
  ftst
  fnstsw ax
  shr  ah, 1
  jnc  @@3
  fstp st
  fldz
  jmp  @@31
@@3:
  fsqrt
@@31:
  fstp dword [edx + 4]
  fld  dword [edx + 8]
  ftst
  fnstsw ax
  shr  ah, 1
  jnc  @@4
  fstp st
  fldz
  jmp  @@41
@@4:
  fsqrt
@@41:
  fstp dword [edx + 8]
end;

procedure mClampSqrSVecV(v: TPSVec);
asm
  xor  edx, edx
  mov  [eax + 12], edx
  cmp  SupportSSE, 0
  jz   @@1
  movups xmm0, [eax]
  xorps  xmm1, xmm1
  maxps  xmm0, xmm1
  mulps  xmm0, xmm0
  movups [eax], xmm0
  ret
@@1:
  mov  edx, eax
  fld  dword [edx]
  ftst
  fnstsw ax
  shr  ah, 1
  jnc  @@2
  fstp st
  fldz
@@2:
  fmul st, st
  fstp dword [edx]
  fld  dword [edx + 4]
  ftst
  fnstsw ax
  shr  ah, 1
  jnc  @@3
  fstp st
  fldz
@@3:
  fmul st, st
  fstp dword [edx + 4]
  fld  dword [edx + 8]
  ftst
  fnstsw ax
  shr  ah, 1
  jnc  @@4
  fstp st
  fldz
@@4:
  fmul st, st
  fstp dword [edx + 8]
end;

function FastPow(const x, y: Single): Single;  //used by vis light 3
asm  // Result := x / (y - x * y + x);
  fld  dword [ebp+12]
  fld  st
  fmul dword [ebp+8]
  fsubr dword [ebp+8]
  fadd st, st(1)
  fdivp
end;

function MakeSVecFromNormals(PsiLight: Pointer): TSVec;
begin
    Result[0] := TPsiLight5(PsiLight).NormalX;
    Result[1] := TPsiLight5(PsiLight).NormalY;
    Result[2] := TPsiLight5(PsiLight).NormalZ;
    Result[3] := 0;
    NormaliseSVectorVar(Result);
end;
                              //eax                edx
function MakeSVecFromNormalsD(PsiLight: Pointer): TSVec;
const d3: Double = 3.0518509476e-5;
{begin
    Result[0] := TPsiLight5(PsiLight).NormalX * d3;
    Result[1] := TPsiLight5(PsiLight).NormalY * d3;
    Result[2] := TPsiLight5(PsiLight).NormalZ * d3;
    Result[3] := 0; // }
asm
    fild word [eax]
    fild word [eax + 2]
    fild word [eax + 4]
    fld  d3
    fmul st(3), st
    fmul st(2), st
    fmulp
    xor  eax, eax
    fstp dword [edx + 8]
    fstp dword [edx + 4]
    fstp dword [edx]
    mov  [edx + 12], eax
end;

function MakeDVecFromNormals(PsiLight: Pointer): TVec3D;
begin
    if (PInteger(@TPsiLight5(PsiLight).NormalX)^ = 0) and
      (TPsiLight5(PsiLight).NormalZ = 0) then
    begin
      Result[0] := 0;
      Result[1] := 0;
      Result[2] := -1;
      Exit;
    end;
    Result[0] := TPsiLight5(PsiLight).NormalX;
    Result[1] := TPsiLight5(PsiLight).NormalY;
    Result[2] := TPsiLight5(PsiLight).NormalZ;
    NormaliseVectorVar(Result);
end;

function MinMaxSVecMC(const V1: TSVec): TSVec;
begin
    Result := v1;
    Result := mMinMaxSVec(0, 400, Result);
end;

                   //       ebp + 12   ebp + 8           eax         edx
function MinMaxSVecPas(const smin, smax: Single; const V1: TSVec): TSVec;
begin
    Result[0] := MinMaxCS(smin, V1[0], smax);
    Result[1] := MinMaxCS(smin, V1[1], smax);
    Result[2] := MinMaxCS(smin, V1[2], smax);
    Result[3] := 0;
end;
                   //       ebp + 12   ebp + 8           eax         edx
function MinMaxSVecSSE(const smin, smax: Single; const V1: TSVec): TSVec;
asm
    movss   xmm1, [ebp + 12]
    movss   xmm2, [ebp + 8]
    movups  xmm0, [eax]
    shufps  xmm1, xmm1, 0
    shufps  xmm2, xmm2, 0
    maxps   xmm0, xmm1
    minps   xmm0, xmm2
    movups  [edx], xmm0
end;
                         //eax        edx
function mSqrtSVec(const V1: TSVec): TSVec;
{begin
    Result[0] := Sqrt(V1[0]);
    Result[1] := Sqrt(V1[1]);
    Result[2] := Sqrt(V1[2]);
    Result[3] := 0;  }
asm
    cmp SupportSSE, 0
    jz @@1
    movups  xmm0, [eax];
    sqrtps  xmm0, xmm0;
    movups  [edx], xmm0;
    ret
@@1:
    fld  dword [eax]
    fld  dword [eax + 4]
    fld  dword [eax + 8]
    fsqrt
    xor  eax, eax
    fstp dword [edx + 8]
    fsqrt
    fstp dword [edx + 4]
    fsqrt
    fstp dword [edx]
    mov  [edx + 12], eax
end;

function SqrtPosSVec(const V1: TSVec): TSVec;
begin
    if V1[0] > 0 then Result[0] := Sqrt(V1[0]) else Result[0] := V1[0];
    if V1[1] > 0 then Result[1] := Sqrt(V1[1]) else Result[1] := V1[1];
    if V1[2] > 0 then Result[2] := Sqrt(V1[2]) else Result[2] := V1[2];
    Result[3] := 0;
end;

function SVecToDVec(const V1: TSVec): TVec3D;
begin
    Result[0] := V1[0];
    Result[1] := V1[1];
    Result[2] := V1[2];
end;

function DVecToSVec(const V1: TVec3D): TSVec;
begin
    Result[0] := V1[0];
    Result[1] := V1[1];
    Result[2] := V1[2];
    Result[3] := 0;
end;

function ArcCosSafe(const d: Double): Double;
begin
    if d > dNearOne then Result := 0 else
    if d < dNearMinusOne then Result := Pi else Result := ArcCos(d);
end;

function ArcSinSafe(const d: Double): Double;
begin
    if d > dNearOne then Result := Pi * 0.5 else
    if d < dNearMinusOne then Result := Pi * -0.5 else Result := ArcSin(d);
end;

function SingleToShortFloat(s: Single): ShortFloat;  // ShortFloat = mant+exp as shorts
var e: Integer;
begin
    e := 0;
    if Abs(s) < 1e-45 then
    begin
      Result[0] := 0;
      Result[1] := 0;
    end
    else if Abs(s) > 1e38 then
    begin
      Result[0] := 99;
      Result[1] := 38;
    end
    else
    begin
      while Abs(s) >= 9.95 do
      begin
        s := s * 0.1;
        Inc(e);
      end;
      while Abs(s) <= 0.995 do
      begin
        s := s * 10;
        Dec(e);
      end;
      Result[0] := Round(s * 10);
      Result[1] := e;
    end;  
end;

function ShortFloatToSingle(sf: PShortFloat): Single;
begin
    Result := sf[0] * Power(10, Min(25, Max(-25, sf[1])) - 1);
end;

function SingleToPosShortF(s: Single): Word;
var m: Integer;
begin
    if s < 0 then s := 0;
    m := 0;
    while (m < 7) and (s > 1) do
    begin
      s := s * 0.1;
      Inc(m);
    end;
    if s > 1 then s := 1;
    Result := Round(s * 8192) or (m shl 13);
end;

function PosShortFToSingle(psf: Word): Single;
begin
    Result := (psf and $1FFF) * Power(10, psf shr 13) / 8192;
end;

                       // eax            st
function LengthOfVec(const V: TVec3D): Double;
asm   // Result := Sqrt(Sqr(V[0]) + Sqr(V[1]) + Sqr(V[2]));
   fld   qword [eax]
   fmul  st, st
   fld   qword [eax+8]
   fmul  st, st
   faddp
   fld   qword [eax+16]
   fmul  st, st
   faddp
   fsqrt
end;

function SqrLengthOfVec(const V: TVec3D): Double;
//begin Result := Sqr(V[0]) + Sqr(V[1]) + Sqr(V[2]);
asm
   fld   qword [eax]
   fmul  st, st
   fld   qword [eax+8]
   fmul  st, st
   faddp
   fld   qword [eax+16]
   fmul  st, st
   faddp  
end;

function LengthOfSVec(const V: TSVec): Single;
begin
   Result := Sqrt(Sqr(V[0]) + Sqr(V[1]) + Sqr(V[2]));
end;

function SqrLengthOfSVec(const V: TSVec): Single;
asm             //eax     st       Result := Sqr(V[0]) + Sqr(V[1]) + Sqr(V[2]);
  fld   dword [eax]
  fmul  st, st     
  fld   dword [eax + 4]
  fmul  st, st
  faddp
  fld   dword [eax + 8]
  fmul  st, st
  faddp
end;

function NormaliseVector(V: TPVec3D): TVec3D; 
{var d: Double;            //eax       edx
begin
    d := 1 / Sqrt(Sqr(V[0]) + Sqr(V[1]) + Sqr(V[2]) + 1e-100);
    Result[0] := V[0] * d;
    Result[1] := V[1] * d;
    Result[2] := V[2] * d; // }
asm                          //max 4 st slots useable because of calling formula
  fld   qword [eax]
  fld   st           //v0,v0
  fmul  st, st       //v0²,v0
  fld   qword [eax + 8]
  fld   st           //v1,v1,vo²,vo
  fmul  st, st       //v1²,v1,v0²,v0
  faddp st(2), st    //v1,v0²+v1²,v0
  fld   qword [eax + 16]
  fmul  st, st       //v2²,v1,v0²+v1²,v0
  fadd  d1em100
  faddp st(2), st    //v1,v0²+v1²+v2²,v0
  fxch               //v0²+v1²+v2²,v1,v0
  fsqrt              //r,v1,v0
  fld1               //1,r,v1,v0
  fdivrp             //1/r,v1,v0
  fmul  st(2), st
  fmul  st(1), st
  fmul  qword [eax + 16]  //v2',v1',v0'
  fstp  qword [edx + 16]
  fstp  qword [edx + 8]
  fstp  qword [edx]   // 
end;

function NormaliseVectorF(const V: TVec3D): TVec3D;
var d: Double;
begin
    d := 1 / Sqrt(Sqr(V[0]) + Sqr(V[1]) + Sqr(V[2]) + 1e-100);
    Result[0] := V[0] * d;
    Result[1] := V[1] * d;
    Result[2] := V[2] * d;
end;

procedure NormaliseVectorVar(var V: TVec3D);
{var d: Double;
begin
    d := 1 / Sqrt(Sqr(V[0]) + Sqr(V[1]) + Sqr(V[2]) + 1e-100);
    V[0] := V[0] * d;
    V[1] := V[1] * d;
    V[2] := V[2] * d;  //}
asm
  fld   qword [eax]
  fld   st           //v0,v0
  fmul  st, st       //v0²,v0
  fld   qword [eax + 8]
  fld   st
  fmul  st, st       //v1²,v1,v0²,v0
  faddp st(2), st    //v1,v0²+v1²,v0
  fld   qword [eax + 16]
  fld   st           //v2,v2,v1,v0²+v1²,v0
  fmul  st, st       //v2²,v2,v1,v0²+v1²,v0
  fadd  d1em100
  faddp st(3), st    //v2,v1,v0²+v1²+v2²,v0
  fxch  st(2)        //v0²+v1²+v2²,v1,v2,v0
  fsqrt
  fld1
  fdivrp
  fmul  st(3), st
  fmul  st(2), st
  fmulp              //v1',v2',v0'
  fstp  qword [eax + 8]
  fstp  qword [eax + 16]
  fstp  qword [eax]      //}
end;

procedure NormaliseSVectorVar(var V: TSVec);
{var d: Double;                  //eax
begin
    d := 1 / Sqrt(Sqr(V[0]) + Sqr(V[1]) + Sqr(V[2]) + 1e-30); //  s1em30
    V[0] := V[0] * d;
    V[1] := V[1] * d;
    V[2] := V[2] * d; }
asm
  fld   dword [eax]
  fld   st           //v0,v0
  fmul  st, st       //v0²,v0
  fld   dword [eax + 4]
  fld   st
  fmul  st, st       //v1²,v1,v0²,v0
  faddp st(2), st    //v1,v0²+v1²,v0
  fld   dword [eax + 8]
  fld   st           //v2,v2,v1,v0²+v1²,v0
  fmul  st, st       //v2²,v2,v1,v0²+v1²,v0
  fadd  s1em30
  faddp st(3), st    //v2,v1,v0²+v1²+v2²,v0
  fxch  st(2)        //v0²+v1²+v2²,v1,v2,v0
  fsqrt
  fld1
  fdivrp
  fmul  st(3), st
  fmul  st(2), st
  fmulp              //v1',v2',v0'
  fstp  dword [eax + 4]
  fstp  dword [eax + 8]
  fstp  dword [eax]
end;

function NormaliseSVectorToS2(const n: Double; const V: TSVec): TSVec;
var d: Double;              // ebp+8            eax        edx
begin
    d := n / Sqrt(Sqr(V[0]) + Sqr(V[1]) + Sqr(V[2]) + 1e-100);
    Result[0] := V[0] * d;
    Result[1] := V[1] * d;
    Result[2] := V[2] * d;
end;

function NormaliseVectorTo(const n: Double; const V: TVec3D): TVec3D;  overload;
{var d: Double;         //   ebp+8           eax          edx
begin
    d := n / Sqrt(Sqr(V[0]) + Sqr(V[1]) + Sqr(V[2]) + 1e-100);
    Result[0] := V[0] * d;
    Result[1] := V[1] * d;
    Result[2] := V[2] * d;  }
asm
  fld   qword [eax]
  fld   st           //v0,v0
  fmul  st, st       //v0²,v0
  fld   qword [eax + 8]
  fld   st
  fmul  st, st       //v1²,v1,v0²,v0
  faddp st(2), st    //v1,v0²+v1²,v0
  fld   qword [eax + 16]
  fld   st           //v2,v2,v1,v0²+v1²,v0
  fmul  st, st       //v2²,v2,v1,v0²+v1²,v0
  fadd  d1em100
  faddp st(3), st    //v2,v1,v0²+v1²+v2²,v0
  fxch  st(2)        //v0²+v1²+v2²,v1,v2,v0
  fsqrt
  fld   qword [ebp + 8]
  fdivrp
  fmul  st(3), st
  fmul  st(2), st
  fmulp              //v1',v2',v0'
  fstp  qword [edx + 8]
  fstp  qword [edx + 16]
  fstp  qword [edx]
end;

procedure NormaliseVectorTo(const n: Double; V: TPVec3D);  overload;
{var d: Double;         //   ebp+8           eax
begin
    d := n / Sqrt(Sqr(V[0]) + Sqr(V[1]) + Sqr(V[2]) + 1e-100);
    V[0] := V[0] * d;
    V[1] := V[1] * d;
    V[2] := V[2] * d;
end;                    }
asm
  fld   qword [eax]
  fld   st           //v0,v0
  fmul  st, st       //v0²,v0
  fld   qword [eax + 8]
  fld   st
  fmul  st, st       //v1²,v1,v0²,v0
  faddp st(2), st    //v1,v0²+v1²,v0
  fld   qword [eax + 16]
  fld   st           //v2,v2,v1,v0²+v1²,v0
  fmul  st, st       //v2²,v2,v1,v0²+v1²,v0
  fadd  d1em100
  faddp st(3), st    //v2,v1,v0²+v1²+v2²,v0
  fxch  st(2)        //v0²+v1²+v2²,v1,v2,v0
  fsqrt
  fld   qword [ebp + 8]
  fdivrp
  fmul  st(3), st
  fmul  st(2), st
  fmulp              //v1',v2',v0'
  fstp  qword [eax + 8]
  fstp  qword [eax + 16]
  fstp  qword [eax]
end;

function NormaliseSVector(const V: TSVec): TSVec;  //..in SSE
{var d: Double;                  //eax      edx
begin
    d := 1 / Sqrt(Sqr(V[0]) + Sqr(V[1]) + Sqr(V[2]) + 1e-100);
    Result[0] := V[0] * d;
    Result[1] := V[1] * d;
    Result[2] := V[2] * d;
    Result[3] := 0;     }
asm
  fld   dword [eax]
  fld   st           //v0,v0
  fmul  st, st       //v0²,v0
  fld   dword [eax + 4]
  fld   st
  fmul  st, st       //v1²,v1,v0²,v0
  faddp st(2), st    //v1,v0²+v1²,v0
  fld   dword [eax + 8]
  fld   st           //v2,v2,v1,v0²+v1²,v0
  fmul  st, st       //v2²,v2,v1,v0²+v1²,v0
  fadd  d1em100
  faddp st(3), st    //v2,v1,v0²+v1²+v2²,v0
  fxch  st(2)        //v0²+v1²+v2²,v1,v2,v0
  fsqrt
  fld1
  fdivrp
  fmul  st(3), st
  fmul  st(2), st
  fmulp              //v1',v2',v0'
  fstp  dword [edx + 4]
  fstp  dword [edx + 8]
  fstp  dword [edx]
end;

procedure SVecToNormals(const sv: TSVec; pn: Pointer);
{var svt: TSVec;       //        eax         edx
begin
    svt := NormaliseSVectorToS2(32767, sv);
    PSmallInt(Integer(pn))^ := Round(svt[0]);  //NormalX
    PSmallInt(Integer(Pn) + 2)^ := Round(svt[1]);  //NormalY
    PSmallInt(Integer(Pn) + 4)^ := Round(svt[2]);  //NormalZ   }
const d32767: Double = 32767;
asm
  fld   dword [eax]
  fld   st           //v0,v0
  fmul  st, st       //v0²,v0
  fld   dword [eax + 4]
  fld   st
  fmul  st, st       //v1²,v1,v0²,v0
  faddp st(2), st    //v1,v0²+v1²,v0
  fld   dword [eax + 8]
  fld   st           //v2,v2,v1,v0²+v1²,v0
  fmul  st, st       //v2²,v2,v1,v0²+v1²,v0
  fadd  d1em100
  faddp st(3), st    //v2,v1,v0²+v1²+v2²,v0
  fxch  st(2)        //v0²+v1²+v2²,v1,v2,v0
  fsqrt
  fld   d32767
  fdivrp
  fmul  st(3), st
  fmul  st(2), st
  fmulp              //v1',v2',v0'
  fistp word [edx + 2]
  fistp word [edx + 4]
  fistp word [edx + 0]
end;

function NormaliseSVectorTo(const n: Double; const V: TSVec): TVec3D;
var d: Double;
begin
    d := n / Sqrt(Sqr(V[0]) + Sqr(V[1]) + Sqr(V[2]) + 1e-100);
    Result[0] := V[0] * d;
    Result[1] := V[1] * d;
    Result[2] := V[2] * d;
end;

{function InvertMatrix(m: TPMatrix3): TMatrix3;
var d: Double;
begin
    Result[0,0] := m[1,1] * m[2,2] - m[1,2] * m[2,1];
    Result[1,0] := m[1,2] * m[2,0] - m[1,0] * m[2,2];
    Result[2,0] := m[1,0] * m[2,1] - m[1,1] * m[2,0];
    Result[0,1] := m[0,2] * m[2,1] - m[0,1] * m[2,2];
    Result[1,1] := m[0,0] * m[2,2] - m[0,2] * m[2,0];
    Result[2,1] := m[0,1] * m[2,0] - m[0,0] * m[2,1];
    Result[0,2] := m[0,1] * m[1,2] - m[0,2] * m[1,1];
    Result[1,2] := m[0,2] * m[1,0] - m[0,0] * m[1,2];
    Result[2,2] := m[0,0] * m[1,1] - m[0,1] * m[1,0];
    d := m[0,0] * Result[0,0] + m[0,1] * Result[1,0] + m[0,2] * Result[2,0]; 
    if Abs(d) < 1e-50 then
      BuildRotMatrix(0, 0, 0, @Result)
    else
    begin
      d := 1 / d;
      Result[0,0] := Result[0,0] * d;
      Result[0,1] := Result[0,1] * d;
      Result[0,2] := Result[0,2] * d;
      Result[1,0] := Result[1,0] * d;
      Result[1,1] := Result[1,1] * d;
      Result[1,2] := Result[1,2] * d;
      Result[2,0] := Result[2,0] * d;
      Result[2,1] := Result[2,1] * d;
      Result[2,2] := Result[2,2] * d;
    end;
end; }

procedure RotateVector(V: TPVec3D; M: TPMatrix3);  //is like reversed S version
{var VT: TVec3D;         //eax       edx
begin
    VT := V^;
    V[0] := VT[0] * M[0,0] + VT[1] * M[0,1] + VT[2] * M[0,2];
    V[1] := VT[0] * M[1,0] + VT[1] * M[1,1] + VT[2] * M[1,2];
    V[2] := VT[0] * M[2,0] + VT[1] * M[2,1] + VT[2] * M[2,2]; }
asm
    fld   qword [edx]
    fld   qword [edx + 24]
    fld   qword [edx + 48]
    fld   qword [eax]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    fld   qword [edx + 8]
    fld   qword [edx + 32]
    fld   qword [edx + 56]
    fld   qword [eax + 8]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    fld   qword [edx + 16]
    fld   qword [edx + 40]
    fld   qword [edx + 64]
    fld   qword [eax + 16]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    fstp  qword [eax + 16]
    fstp  qword [eax + 8]
    fstp  qword [eax]
end;

procedure RotateVectorReverse(V: TPVec3D; M: TPMatrix3);
{var VT: TVec3D;                  //eax       edx
begin
    VT := V^;
    V[0] := VT[0] * M[0,0] + VT[1] * M[1,0] + VT[2] * M[2,0];
    V[1] := VT[0] * M[0,1] + VT[1] * M[1,1] + VT[2] * M[2,1];
    V[2] := VT[0] * M[0,2] + VT[1] * M[1,2] + VT[2] * M[2,2]; }
asm
    fld   qword [edx]
    fld   qword [edx + 8]
    fld   qword [edx + 16]
    fld   qword [eax]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    fld   qword [edx + 24]
    fld   qword [edx + 32]
    fld   qword [edx + 40]
    fld   qword [eax + 8]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    fld   qword [edx + 48]
    fld   qword [edx + 56]
    fld   qword [edx + 64]
    fld   qword [eax + 16]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    fstp  qword [eax + 16]
    fstp  qword [eax + 8]
    fstp  qword [eax]
end;

{procedure RotateSVector(V: TPSVec; M: TPMatrix3);
var VT: TSVec;
begin
    VT := V^;
    V[0] := VT[0] * M[0,0] + VT[1] * M[1,0] + VT[2] * M[2,0];
    V[1] := VT[0] * M[0,1] + VT[1] * M[1,1] + VT[2] * M[2,1];
    V[2] := VT[0] * M[0,2] + VT[1] * M[1,2] + VT[2] * M[2,2];
end; }

procedure RotateSVector(V: TPSVec; M: TPMatrix3);
asm
    fld   qword [edx]
    fld   qword [edx + 8]
    fld   qword [edx + 16]
    fld   dword [eax]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    fld   qword [edx + 24]
    fld   qword [edx + 32]
    fld   qword [edx + 40]
    fld   dword [eax + 4]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    fld   qword [edx + 48]
    fld   qword [edx + 56]
    fld   qword [edx + 64]
    fld   dword [eax + 8]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    fstp  dword [eax + 8]
    fstp  dword [eax + 4]
    fstp  dword [eax]
end;

procedure RotateSVectorReverse(V: TPSVec; M: TPMatrix3);
asm
    fld   qword [edx]
    fld   qword [edx + 24]
    fld   qword [edx + 48]
    fld   dword [eax]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    fld   qword [edx + 8]
    fld   qword [edx + 32]
    fld   qword [edx + 56]
    fld   dword [eax + 4]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    fld   qword [edx + 16]
    fld   qword [edx + 40]
    fld   qword [edx + 64]
    fld   dword [eax + 8]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    fstp  dword [eax + 8]
    fstp  dword [eax + 4]
    fstp  dword [eax]
end;

procedure RotateSVectorS(V: TPSVec; M: TPSMatrix3);   //in calcpixelcol
asm                    //  eax        edx
    cmp   SupportSSE, 0
    jz    @@1
    movss  xmm0, [eax]
    movss  xmm1, [eax + 4]
    movss  xmm2, [eax + 8]
    shufps xmm0, xmm0, 0
    shufps xmm1, xmm1, 0
    shufps xmm2, xmm2, 0
    movups xmm4, [edx]
    movups xmm5, [edx + 16]
    movups xmm6, [edx + 32]
    mulps  xmm4, xmm0     //m0*v0
    mulps  xmm5, xmm1     //m1*v1
    mulps  xmm6, xmm2     //m2*v2
    addps  xmm4, xmm5
    addps  xmm4, xmm6
    movups [eax], xmm4
    ret
@@1:
    fld   dword [edx]         //M[0,0]
    fld   dword [edx + 4]
    fld   dword [edx + 8]     //M[0,2],M[0,1],M[0,0]
    fld   dword [eax]         //V[0],M[0,2],M[0,1],M[0,0]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)        //M[0,2]*V[0],M[0,1]*V[0],M[0,0]*V[0]
    fld   dword [edx + 16]
    fld   dword [edx + 20]
    fld   dword [edx + 24]
    fld   dword [eax + 4]     //v[1],M[1,2],M[1,1],M[1,0], M[0,2]*V[0],M[0,1]*V[0],M[0,0]*V[0]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)        //M[1,2]*V[1],M[1,1]*V[1],M[1,0]*V[1], M[0,2]*V[0],M[0,1]*V[0],M[0,0]*V[0]
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)        //M[1,2]*V[1]+M[0,2]*V[0], M[1,1]*V[1]+M[0,1]*V[0], M[1,0]*V[1]+M[0,0]*V[0]
    fld   dword [edx + 32]
    fld   dword [edx + 36]
    fld   dword [edx + 40]
    fld   dword [eax + 8]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    fstp  dword [eax + 8]     //v2=m02*v0+m12*v1+m22*v2
    fstp  dword [eax + 4]     //v1=m01*v0+m11*v1+m21*v2
    fstp  dword [eax]         //v0=m00*v0+m10*v1+m20*v2
end;

procedure RotateVectorS(V: TPVec3D; M: TPSMatrix3);
asm
    fld   dword [edx]         //M[0,0]
    fld   dword [edx + 4]
    fld   dword [edx + 8]     //M[0,2],M[0,1],M[0,0]
    fld   qword [eax]         //V[0],M[0,2],M[0,1],M[0,0]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)        //M[0,2]*V[0],M[0,1]*V[0],M[0,0]*V[0]
    fld   dword [edx + 16]
    fld   dword [edx + 20]
    fld   dword [edx + 24]
    fld   qword [eax + 8]     //v[1],M[1,2],M[1,1],M[1,0], M[0,2]*V[0],M[0,1]*V[0],M[0,0]*V[0]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)        //M[1,2]*V[1],M[1,1]*V[1],M[1,0]*V[1], M[0,2]*V[0],M[0,1]*V[0],M[0,0]*V[0]
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)        //M[1,2]*V[1]+M[0,2]*V[0], M[1,1]*V[1]+M[0,1]*V[0], M[1,0]*V[1]+M[0,0]*V[0]
    fld   dword [edx + 32]
    fld   dword [edx + 36]
    fld   dword [edx + 40]
    fld   qword [eax + 16]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    fstp  qword [eax + 16]    //v2=m02*v0+m12*v1+m22*v2
    fstp  qword [eax + 8]     //v1=m01*v0+m11*v1+m21*v2
    fstp  qword [eax]         //v0=m00*v0+m10*v1+m20*v2
end;

procedure RotateVectorReverseS(V: TPVec3D; M: TPSMatrix3);
asm
    fld   dword [edx]
    fld   dword [edx + 16]
    fld   dword [edx + 32]
    fld   qword [eax]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    fld   dword [edx + 4]
    fld   dword [edx + 20]
    fld   dword [edx + 36]
    fld   qword [eax + 8]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    fld   dword [edx + 8]
    fld   dword [edx + 24]
    fld   dword [edx + 40]
    fld   qword [eax + 16]
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    fstp  qword [eax + 16]
    fstp  qword [eax + 8]
    fstp  qword [eax]
end;

{$CODEALIGN 16}
//{$ALIGN 16}
procedure RotateSVectorReverseS(V: TPSVec; M: TPSMatrix3);
asm
 {   cmp  SupportSSE3, 0
    jz   @@1
    movups xmm0, [eax]
    movups xmm4, [edx]
    movups xmm5, [edx + 16]
    movups xmm6, [edx + 32]
    andps  xmm0, dqword [@cand]
    mulps  xmm4, xmm0          //mv00,mv11,mv22
    mulps  xmm5, xmm0          //mv10,mv11,mv12
    mulps  xmm6, xmm0          //mv20,mv21,mv22
    haddps xmm4, xmm5          //mv00+mv11,mv22,mv10+mv11,mv12
    haddps xmm6, xmm6          //mv20+mv21,mv22
    haddps xmm4, xmm6          //mv00+mv11+mv22,mv10+mv11+mv12,mv20+mv21+mv22
    movups [eax], xmm4
    ret
DD  0
DD  0
DB  0
@cand:
DD  $FFFFFFFF,$FFFFFFFF,$FFFFFFFF,0
@@1:   }
    fld   dword [edx]
    fld   dword [edx + 16]
    fld   dword [edx + 32]      //M[2,0], M[1,0], M[0,0]
    fld   dword [eax]           //V[0]
    fmul  st(1), st(0)          //V[0], V[0]*M[2,0], M[1,0], M[0,0]
    fmul  st(2), st(0)          //V[0], V[0]*M[2,0], V[0]*M[1,0], M[0,0]
    fmulp st(3), st(0)          //V[0]*M[2,0], V[0]*M[1,0], V[0]*M[0,0]
    fld   dword [edx + 4]
    fld   dword [edx + 20]
    fld   dword [edx + 36]
    fld   dword [eax + 4]       
    fmul  st(1), st(0)          //+v[1]*M[x,1]
    fmul  st(2), st(0)
    fmulp st(3), st(0)          //V[1]*M[2,1], V[1]*M[1,1], V[1]*M[0,1], V[0]*M[2,0], V[0]*M[1,0], V[0]*M[0,0]
    faddp st(3), st(0)          //v0*m20+v1*m21
    faddp st(3), st(0)
    faddp st(3), st(0)
    fld   dword [edx + 8]
    fld   dword [edx + 24]
    fld   dword [edx + 40]
    fld   dword [eax + 8]
    fmul  st(1), st(0)          //+v[2]*M[x,2]
    fmul  st(2), st(0)
    fmulp st(3), st(0)          //v0*m20+v1*m21+v2*m22
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    fstp  dword [eax + 8]       //v0*m20+v1*m21+v2*m22
    fstp  dword [eax + 4]       //v0*m10+v1*m11+v2*m12
    fstp  dword [eax]           //v0*m00+v1*m01+v2*m02
end;

procedure AddSVec2Vec3d(const V1: TSVec; V2: TPVec3D);
begin                  // eax,         edx
    V2[0] := V1[0] + V2[0];
    V2[1] := V1[1] + V2[1];
    V2[2] := V1[2] + V2[2];
end;

function AddSVec2Vec3(V1: TPSVec; V2: TPVec3D): TVec3D;
begin
    Result[0] := V1[0] + V2[0];
    Result[1] := V1[1] + V2[1];
    Result[2] := V1[2] + V2[2];
end;
                        //eax, edx, ecx         ebp+8
function Add3SVectors(const V1, V2, V3: TSVec): TSVec;
begin
    Result[0] := V1[0] + V2[0] + V3[0];
    Result[1] := V1[1] + V2[1] + V3[1];
    Result[2] := V1[2] + V2[2] + V3[2];
end;
                          //eax, edx       ecx
function AddSVectors(const V1, V2: TSVec): TSVec;  overload;
{begin
    Result[0] := V1[0] + V2[0];
    Result[1] := V1[1] + V2[1];
    Result[2] := V1[2] + V2[2]; }
asm
    fld  dword [eax]
    fadd dword [edx]
    fstp dword [ecx]
    fld  dword [eax + 4]
    fadd dword [edx + 4]
    fstp dword [ecx + 4]
    fld  dword [eax + 8]
    fadd dword [edx + 8]
    fstp dword [ecx + 8]
    xor  eax, eax
    mov  [ecx + 12], eax
end;

procedure AddSVectors(V1: TPSVec; const V2: TSVec);  overload;
asm
    fld  dword [eax]
    fadd dword [edx]
    fstp dword [eax]
    fld  dword [eax + 4]
    fadd dword [edx + 4]
    fstp dword [eax + 4]
    fld  dword [eax + 8]
    fadd dword [edx + 8]
    fstp dword [eax + 8]
end;
                                           //eax      edx
function MakeSVecMultiplierFromDynFogCol(sv: TSVec): TSVec; //not used
asm
    cmp SupportSSE2, 0
    jz @@1

@@1:
{     lns := SubtractSVectors(@cSVec1, ScaleSVector(sv, s1d255));
     lns[0] := MaxCS(0, lns[0]);
     lns[1] := MaxCS(0, lns[1]);
     lns[2] := MaxCS(0, lns[2]); }
    fld   dword [eax]
    fld   dword [eax + 4]
    fld   dword [eax + 8]
    fld   s1d255
    fmul  st(3), st(0)
    fmul  st(2), st(0)
    fmulp
    fld1
    fsubr st(3), st(0)
    fsubr st(2), st(0)
    fsubr st(1), st(0)
    fxch  st(3)         //vs0,vs2,vs1,1
    ftst
    fnstsw ax
    shr   ah, 1
    jnc   @up1
    fstp  st(0)
    fldz
@up1:
    fcom  st(3)
    fnstsw ax
    shr   ah, 1
    jc    @skip1
    fstp  st(0)
    fld1
@skip1:
    fstp dword [edx]
    ftst
    fnstsw ax
    shr   ah, 1
    jnc   @up2
    fstp  st(0)
    fldz
@up2:
    fcom  st(2)
    fnstsw ax
    shr   ah, 1
    jc    @skip2
    fstp  st(0)
    fld1
@skip2:
    fstp dword [edx + 8]
    ftst
    fnstsw ax
    shr   ah, 1
    jnc   @up3
    fstp  st(0)
    fldz
@up3:
    fcom  st(1)
    fnstsw ax
    shr   ah, 1
    jc    @skip3
    fstp  st(0)
    fld1
@skip3:
    fstp dword [edx + 4]
    fstp st(0)
    xor  eax, eax
    mov  dword [edx + 12], eax
end;

procedure AddSVecWeight(V1, V2: TPSVec; W: Double);
begin
    V1[0] := V1[0] + V2[0] * W;
    V1[1] := V1[1] + V2[1] * W;
    V1[2] := V1[2] + V2[2] * W;
end;
                  //     eax, edx          ebp+8
procedure AddSVecWeightS(V1, V2: TPSVec; const W: Single);  overload;
asm
    cmp SupportSSE, 0
    jz  @@1
    movss  xmm2, [ebp + 8]
    movups xmm0, [edx]
    shufps xmm2, xmm2, 0
    movups xmm1, [eax]
    mulps  xmm0, xmm2
    addps  xmm0, xmm1
    movups [eax], xmm0
    pop ebp
    ret 4
@@1:
    fld  dword [edx]
    fld  dword [edx + 4]
    fld  dword [edx + 8]
    fld  dword [ebp + 8]
    fmul st(3), st
    fmul st(2), st
    fmulp
    fadd dword [eax + 8]
    fstp dword [eax + 8]
    fadd dword [eax + 4]
    fstp dword [eax + 4]
    fadd dword [eax]
    fstp dword [eax]
  {  V1[0] := V1[0] + V2[0] * W;
    V1[1] := V1[1] + V2[1] * W;
    V1[2] := V1[2] + V2[2] * W; }
end;     //ret 4

procedure AddSVecWeightS(var V1: TSVec; const V2: TSVec; const W: Single);  overload;
asm
    cmp SupportSSE, 0
    jz  @@1
    movss  xmm2, [ebp + 8]
    movups xmm0, [edx]
    shufps xmm2, xmm2, 0
    movups xmm1, [eax]
    mulps  xmm0, xmm2
    addps  xmm0, xmm1
    movups [eax], xmm0
    pop ebp
    ret 4
@@1:
    fld  dword [edx]
    fld  dword [edx + 4]
    fld  dword [edx + 8]
    fld  dword [ebp + 8]
    fmul st(3), st
    fmul st(2), st
    fmulp
    fadd dword [eax + 8]
    fstp dword [eax + 8]
    fadd dword [eax + 4]
    fstp dword [eax + 4]
    fadd dword [eax]
    fstp dword [eax]
end;

function SlerpSVec(V1, V2: TPSVec; const t: Single): TSVec;
var d1, d2: Double;
    sv1, sv2: TSVec;
begin
    sv1 := NormaliseSVector(V1^);
    sv2 := NormaliseSVector(V2^);
    d1 := DotOfSVectors(sv1, sv2);
    if Abs(d1) > 0.9999 then
    begin
      d1 := 1 - t;
      d2 := t;
    end else begin
      d2 := ArcCos(d1);
      d1 := Sin((1 - t) * d2);
      d2 := Sin(t * d2);
    end;
    Result[0] := sv1[0] * d1 + sv2[0] * d2;
    Result[1] := sv1[1] * d1 + sv2[1] * d2;
    Result[2] := sv1[2] * d1 + sv2[2] * d2;
    Result[3] := 0;
    Result := NormaliseSVector(Result);
end;

{function SVmultiply(SV1, SV2: TSVec): TSVec; //not good
begin
    Result[0] := SV1[1] * SV2[2] + SV1[2] * SV2[1];
    Result[1] := SV1[0] * SV2[2] + SV1[2] * SV2[0];
    Result[2] := SV1[0] * SV2[1] + SV1[1] * SV2[0];
    Result[3] := 0;
end; }

{function SplineSVec(SV1, SV2, SV3: TPSVec): TSVec;
var vi: TSVec;
begin
    vi[0] := -SV2[0];
    vi[1] := -SV2[1];
    vi[2] := -SV2[2];
  {  va := NormaliseSVector(AddSVectors(SlerpSVec(@vi, SV1, 0.5), SlerpSVec(@vi, SV3, 0.5)));
    Result := SlerpSVec(@SV2, @va, 0.5); }
 {   Result := SVmultiply(SV2^, NormaliseSVector(ScaleSVector(AddSVectors(SVmultiply(vi, SV1^),
                                                        SVmultiply(vi, SV3^)), -0.5)));
    Result := NormaliseSVector(Result);
end;  }

function CubicIpol4SVecs(SV1, SV2, SV3, SV4: TPSVec; const t: Double): TSVec;
//var va, vb, vc: TSVec;
begin
    Result := SlerpSVec(SV2, SV3, t);
{    va := SubtractSVectors(SV4, SV3^);
    va := SubtractSVectors(@va, SubtractSVectors(SV2, SV1^));
    vb := SubtractSVectors(SV2, SV1^);
    vb := SubtractSVectors(@vb, va);
    vc := SubtractSVectors(SV3, SV2^);
    Result := AddSVectors(AddSVectors(AddSVectors(ScaleSVector(va, t * t * t), //has issues
                ScaleSVector(vb, t * t)), ScaleSVector(vc, t)), SV1^);
    Result := NormaliseSVector(Result);  }
end;
    {llPow Returns a float that is base raised to the power exponent (baseexponent)
Cubic interpolation of v0, v1, v2 and v3 with fraction t.
vector vCub(vector v0,vector v1,vector v2,vector v3,float t)
    vector P = (v3-v2)-(v1-v0);
    vector Q = (v1-v0)-P;
    vector R = v2-v1;
    vector S = v0;
    return P*t^3 + Q*t^2 + R*t + S;
Input  Description  
vector v0  Start Point  
vector v1  Start Tangent  
vector v2  End Point  
vector v3  End Tangent  
float t  Fraction of interpolation  
Output  Description  
return vector vCub  Returns cubic interpolation of four vectors
}
function BezierIpol3SVecs(SV1, SV2, SV3: TPSVec; const t: Double): TSVec;
var A, B: TSVec;
begin
    A := SlerpSVec(SV1, SV2, 0.5);
    B := SlerpSVec(SV2, SV3, 0.5);
    A := SlerpSVec(@A, SV2, t);
    B := SlerpSVec(SV2, @B, t);
    Result := SlerpSVec(@A, @B, t);
end;

{procedure RotateSVectorReverse(V: TPSVec; M: TPMatrix3);
asm
    fld   qword [edx]
    fld   qword [edx + 24]
    fld   qword [edx + 48]
    fld   dword [eax]        //V0,M20,M10,M00
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)       //V0*M20,V0*M10,V0*M00
    fld   qword [edx + 8]
    fld   qword [edx + 32]
    fld   qword [edx + 56]
    fld   dword [eax + 4]    //V1,M21,M11,M01,V0*M20,V0*M10,V0*M00
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)       //V1*M21,V1*M11,V1*M01,V0*M20,V0*M10,V0*M00
    faddp st(3), st(0)       //V1*M11,V1*M01,V0*M20+V1*M21,V0*M10,V0*M00
    faddp st(3), st(0)       //V1*M11,V1*M01,V0*M20+V1*M21,V0*M10,V0*M00
    faddp st(3), st(0)       //V0*M20+V1*M21,V0*M10+V1*M11,V0*M00+V1*M01
    fld   qword [edx + 16]
    fld   qword [edx + 40]
    fld   qword [edx + 64]
    fld   dword [eax + 8]    //V2,M22,M12,M02,V0*M20+V1*M21,V0*M10+V1*M11,V0*M00+V1*M01
    fmul  st(1), st(0)
    fmul  st(2), st(0)
    fmulp st(3), st(0)       //V2*M22,V2*M12,V2*M02,V0*M20+V1*M21,V0*M10+V1*M11,V0*M00+V1*M01
    faddp st(3), st(0)
    faddp st(3), st(0)
    faddp st(3), st(0)
    fstp  dword [eax + 8]
    fstp  dword [eax + 4]
    fstp  dword [eax]
end;  }

procedure TranslatePos(V, VT: TPVec3D; M: TPMatrix3);
begin
    V[0] := V[0] + VT[0] * M[0,0] + VT[1] * M[1,0] + VT[2] * M[2,0];
    V[1] := V[1] + VT[0] * M[0,1] + VT[1] * M[1,1] + VT[2] * M[2,1];
    V[2] := V[2] + VT[0] * M[0,2] + VT[1] * M[1,2] + VT[2] * M[2,2];
end;

function DotOfVectors(V1, V2: TPVec3D): Double;
begin
    Result := V1[0] * V2[0] + V1[1] * V2[1] + V1[2] * V2[2];
end;

function DotOfVectorsNormalize(V1, V2: TPVec3D): Double;
begin
    Result := (V1[0] * V2[0] + V1[1] * V2[1] + V1[2] * V2[2]) /
              Sqrt(SqrLengthOfVec(V1^) * SqrLengthOfVec(V2^));
end;

                          //eax  edx        st(0)
function DotOfSVectors(const V1, V2: TSVec): Single;
  //  Result := V1[0] * V2[0] + V1[1] * V2[1] + V1[2] * V2[2];
asm
    fld  dword [eax]
    fmul dword [edx]
    fld  dword [eax + 4]
    fmul dword [edx + 4]
    faddp
    fld  dword [eax + 8]
    fmul dword [edx + 8]
    faddp
end;

function SubtractVectors2s(const V1, V2: TVec3D): TSVec;
asm
    fld  qword [eax]
    fsub qword [edx]
    fstp dword [ecx]
    fld  qword [eax + 8]
    fsub qword [edx + 8]
    fstp dword [ecx + 4]
    fld  qword [eax + 16]
    fsub qword [edx + 16]
    fstp dword [ecx + 8]
    xor eax, eax
    mov  [ecx + 12], eax
end;

function SubtractVectors(const V1, V2: TVec3D): TVec3D;  overload;
asm
    fld  qword [eax]
    fsub qword [edx]
    fstp qword [ecx]
    fld  qword [eax + 8]
    fsub qword [edx + 8]
    fstp qword [ecx + 8]
    fld  qword [eax + 16]
    fsub qword [edx + 16]
    fstp qword [ecx + 16]
end;
                        // eax             edx          ecx
function SubtractVectors(V1: TPVec3D; const V2: TVec3D): TVec3D;  overload;
asm
    fld  qword [eax]
    fsub qword [edx]
    fstp qword [ecx]
    fld  qword [eax + 8]
    fsub qword [edx + 8]
    fstp qword [ecx + 8]
    fld  qword [eax + 16]
    fsub qword [edx + 16]
    fstp qword [ecx + 16]
end;

function SubtractVectors(const V1: TVec3D; V2: TPVec3D): TVec3D;  overload;
asm
    fld  qword [eax]
    fsub qword [edx]
    fstp qword [ecx]
    fld  qword [eax + 8]
    fsub qword [edx + 8]
    fstp qword [ecx + 8]
    fld  qword [eax + 16]
    fsub qword [edx + 16]
    fstp qword [ecx + 16]
end;

function SubtractSVectors(V1: TPSVec; const V2: TSVec): TSVec;
asm
    fld  dword [eax]
    fsub dword [edx]
    fstp dword [ecx]
    fld  dword [eax + 4]
    fsub dword [edx + 4]
    fstp dword [ecx + 4]
    fld  dword [eax + 8]
    fsub dword [edx + 8]
    fstp dword [ecx + 8]
    xor  eax, eax
    mov  [ecx + 12], eax
end;

function ScaleVector(const V1: TVec3D; const s: Double): TVec3D;
begin
    Result[0] := V1[0] * s;
    Result[1] := V1[1] * s;
    Result[2] := V1[2] * s;
end;
                        //eax             esp+8      edx
function AddSVecS(const V1: TSVec; const s: Single): TSVec;
asm
    fld   dword [eax]
    fld   dword [eax + 4]
    fld   dword [eax + 8]
    fld   dword [esp + 8]
    fadd  st(3), st
    fadd  st(2), st
    faddp
    fstp  dword [edx + 8]
    fstp  dword [edx + 4]
    fstp  dword [edx]
    xor  eax, eax
    mov  [edx + 12], eax
end;

procedure ScaleVectorV(V1: TPVec3D; const s: Double);
begin
    V1[0] := V1[0] * s;
    V1[1] := V1[1] * s;
    V1[2] := V1[2] * s;
end;
                       //eax           esp(ebp)+8
procedure ScaleSVectorV(V1: TPSVec; const s: Single);
asm
    fld   dword [eax]
    fld   dword [eax + 4]
    fld   dword [eax + 8]
    fld   dword [esp + 8]
    fmul  st(3), st
    fmul  st(2), st
    fmulp
    fstp  dword [eax + 8]
    fstp  dword [eax + 4]
    fstp  dword [eax]
end;
                     //eax     esp(ebp)+(8 with 1 push)    edx
{function ScaleSVector(V1: TSVec; s: Single): TSVec;
begin
    Result[0] := V1[0] * s;
    Result[1] := V1[1] * s;
    Result[2] := V1[2] * s;
end; }
                              //eax, edx,      ecx
function MultiplySVectors(const V1, V2: TSVec): TSVec;
asm
    fld   dword [eax + 8]
    fld   dword [eax + 4]
    fld   dword [eax]
    fmul  dword [edx]
    fstp  dword [ecx]
    fmul  dword [edx + 4]
    fstp  dword [ecx + 4]
    fmul  dword [edx + 8]
    fstp  dword [ecx + 8]
    xor   eax, eax
    mov   [ecx + 12], eax
end;
                          //eax, edx
procedure MultiplySVectorsV(V1, V2: TPSVec);  overload;
asm
    fld   dword [eax + 8]
    fld   dword [eax + 4]
    fld   dword [eax]
    fmul  dword [edx]
    fstp  dword [eax]
    fmul  dword [edx + 4]
    fstp  dword [eax + 4]
    fmul  dword [edx + 8]
    fstp  dword [eax + 8]
end;

procedure MultiplySVectorsV(V1: TPSVec; const V2: TSVec);  overload;
asm
    fld   dword [eax + 8]
    fld   dword [eax + 4]
    fld   dword [eax]
    fmul  dword [edx]
    fstp  dword [eax]
    fmul  dword [edx + 4]
    fstp  dword [eax + 4]
    fmul  dword [edx + 8]
    fstp  dword [eax + 8]
end;

function ScaleSVector(const V1: TSVec; const s: Single): TSVec;
asm
    fld   dword [eax]
    fld   dword [eax + 4]
    fld   dword [eax + 8]
    fld   dword [esp + 8]
    fmul  st(3), st
    fmul  st(2), st
    fmulp
    fstp  dword [edx + 8]
    fstp  dword [edx + 4]
    fstp  dword [edx]
end;

function ScaleSVector4(const V1: TSVec; const s: Single): TSVec;
asm
    cmp   SupportSSE, 0
    jz    @1
    movss  xmm1, [esp + 8]
    movups xmm0, [eax]
    shufps xmm1, xmm1, 0
    mulps  xmm0, xmm1
    movups [eax], xmm0
    ret   4
@1: fld   dword [eax]
    fld   dword [eax + 4]
    fld   dword [eax + 8]
    fld   dword [eax + 12]
    fld   dword [esp + 8]
    fmul  st(4), st
    fmul  st(3), st
    fmul  st(2), st
    fmulp
    fstp  dword [edx + 12]
    fstp  dword [edx + 8]
    fstp  dword [edx + 4]
    fstp  dword [edx]
end;

function ScaleSVectorD(V1: TPSVec; const d: Double): TSVec;
asm
    fld   dword [eax]
    fld   dword [eax + 4]
    fld   dword [eax + 8]
    fld   qword [esp + 8]
    fmul  st(3), st
    fmul  st(2), st
    fmulp
    fstp  dword [edx + 8]
    fstp  dword [edx + 4]
    fstp  dword [edx]
    xor  eax, eax
    mov  [edx + 12], eax
end;

function CalcMdiff(M1, M2: TPMatrix3): Double;
var n, m: Integer;
begin
    Result := 0;
    for m := 0 to 2 do for n := 0 to 2 do Result := Result + Abs(M1[m,n] - M2[m,n]);
end;

function MatrixToAngles(var v3: TVec3D; M: TPMatrix3): LongBool;
var M1, Mt: TMatrix3;
    ay, cy, xx, yy, zz, e, minE, dt: Double;
    i: Integer;
begin
    M1 := NormaliseMatrixTo(1, M);
    ay := ArcSinSafe(M1[0,2]); //only for -90 to 90 deg valid, cos can be + or -!
    cy := Cos(ay);
    Result := Abs(cy) > 0.0001;
    if Result then         //+-v1,+-v0, +-v3 -> 8 versions minerr
    begin
      minE := 1e6;
      for i := 0 to 7 do
      begin
        dt := -cy;
        yy := ay;
        if i > 3 then
        begin
          dt := -dt;
          if yy > 0 then yy := Pi - yy else yy := -Pi - yy;
        end;
        xx := ArcSinSafe(M1[1,2] / dt);
        if (i and 3) > 1 then
        begin
          if xx > 0 then xx := Pi - xx else xx := -Pi - xx;
        end;
        zz := ArcSinSafe(M1[0,1] / dt);
        if (i and 1) > 0 then
        begin
          if zz > 0 then zz := Pi - zz else zz := -Pi - zz;
        end;
        BuildRotMatrix(xx, yy, zz, @Mt);
        e := CalcMdiff(@Mt, @M1);
        if e < minE then
        begin
          minE := e;
          v3[0] := xx;
          v3[1] := yy;
          v3[2] := zz;
        end;
      end;
    end;
end;

procedure BuildRotMatrix(const xa, ya, za: Double; M: TPMatrix3);
var sinX, cosX: Double;
    sinY, cosY: Double;
    sinZ, cosZ: Double;
begin
    SinCosD(xa, sinX, cosX);
    SinCosD(ya, sinY, cosY);
    SinCosD(za, sinZ, cosZ);
    M[0,0] := cosY * cosZ;
    M[0,1] := -cosY * sinZ;
    M[0,2] := sinY;
    M[1,0] := sinX * sinY * cosZ + cosX * sinZ;
    M[1,1] := cosX * cosZ - sinX * sinY * sinZ;
    M[1,2] := -sinX * cosY;
    M[2,0] := sinX * sinZ - cosX * sinY * cosZ;
    M[2,1] := cosX * sinY * sinZ + sinX * cosZ;
    M[2,2] := cosX * cosY;
end;

procedure BuildRotMatrixS(const xa, ya, za: Double; M: TPSMatrix3);
var sinX, cosX: Double;
    sinY, cosY: Double;
    sinZ, cosZ: Double;
begin
    SinCosD(xa, sinX, cosX);
    SinCosD(ya, sinY, cosY);
    SinCosD(za, sinZ, cosZ);
    M[0,0] := cosY * cosZ;
    M[0,1] := -cosY * sinZ;
    M[0,2] := sinY;
    M[1,0] := sinX * sinY * cosZ + cosX * sinZ;
    M[1,1] := cosX * cosZ - sinX * sinY * sinZ;
    M[1,2] := -sinX * cosY;
    M[2,0] := sinX * sinZ - cosX * sinY * cosZ;
    M[2,1] := cosX * sinY * sinZ + sinX * cosZ;
    M[2,2] := cosX * cosY;
    M[0,3] := 0;
    M[1,3] := 0;
    M[2,3] := 0;
end;

procedure Multiply2SMatrix4(M1, M2: TPSMatrix4);
var MT: TSMatrix4;
begin
    MT := M1^;
    M1[0,0] := MT[0,0] * M2[0,0] + MT[0,1] * M2[1,0] + MT[0,2] * M2[2,0] + MT[0,3] * M2[3,0];
    M1[0,1] := MT[0,0] * M2[0,1] + MT[0,1] * M2[1,1] + MT[0,2] * M2[2,1] + MT[0,3] * M2[3,1];
    M1[0,2] := MT[0,0] * M2[0,2] + MT[0,1] * M2[1,2] + MT[0,2] * M2[2,2] + MT[0,3] * M2[3,2];
    M1[0,3] := MT[0,0] * M2[0,3] + MT[0,1] * M2[1,3] + MT[0,2] * M2[2,3] + MT[0,3] * M2[3,3];
    M1[1,0] := MT[1,0] * M2[0,0] + MT[1,1] * M2[1,0] + MT[1,2] * M2[2,0] + MT[1,3] * M2[3,0];
    M1[1,1] := MT[1,0] * M2[0,1] + MT[1,1] * M2[1,1] + MT[1,2] * M2[2,1] + MT[1,3] * M2[3,1];
    M1[1,2] := MT[1,0] * M2[0,2] + MT[1,1] * M2[1,2] + MT[1,2] * M2[2,2] + MT[1,3] * M2[3,2];
    M1[1,3] := MT[1,0] * M2[0,3] + MT[1,1] * M2[1,3] + MT[1,2] * M2[2,3] + MT[1,3] * M2[3,3];
    M1[2,0] := MT[2,0] * M2[0,0] + MT[2,1] * M2[1,0] + MT[2,2] * M2[2,0] + MT[2,3] * M2[3,0];
    M1[2,1] := MT[2,0] * M2[0,1] + MT[2,1] * M2[1,1] + MT[2,2] * M2[2,1] + MT[2,3] * M2[3,1];
    M1[2,2] := MT[2,0] * M2[0,2] + MT[2,1] * M2[1,2] + MT[2,2] * M2[2,2] + MT[2,3] * M2[3,2];
    M1[2,3] := MT[2,0] * M2[0,3] + MT[2,1] * M2[1,3] + MT[2,2] * M2[2,3] + MT[2,3] * M2[3,3];
    M1[3,0] := MT[3,0] * M2[0,0] + MT[3,1] * M2[1,0] + MT[3,2] * M2[2,0] + MT[3,3] * M2[3,0];
    M1[3,1] := MT[3,0] * M2[0,1] + MT[3,1] * M2[1,1] + MT[3,2] * M2[2,1] + MT[3,3] * M2[3,1];
    M1[3,2] := MT[3,0] * M2[0,2] + MT[3,1] * M2[1,2] + MT[3,2] * M2[2,2] + MT[3,3] * M2[3,2];
    M1[3,3] := MT[3,0] * M2[0,3] + MT[3,1] * M2[1,3] + MT[3,2] * M2[2,3] + MT[3,3] * M2[3,3];
end;

procedure IniSMatrix4(var Smatrix4: TSMatrix4);
var x, y: Integer;
begin
    for y := 0 to 3 do for x := 0 to 3 do Smatrix4[y, x] := 0;
    for x := 0 to 3 do Smatrix4[x, x] := 1;
end;

procedure BuildRotMatrix4d(angles: array of Double; var ms4: TSMatrix4);
var s1, c1: Double;      //yz xz xy xw yw zw
    SM4: TSMatrix4;
    i: Integer;
const
    i1: array[0..5] of Integer = (1,0,0,0,1,2);
    i2: array[0..5] of Integer = (2,2,1,3,3,3);
begin
    IniSMatrix4(ms4);
    for i := 0 to 5 do
    begin
      SinCosD(angles[i], s1, c1);
      IniSMatrix4(SM4);
      SM4[i1[i],i1[i]] := c1;
      SM4[i2[i],i2[i]] := c1;
      SM4[i1[i],i2[i]] := -s1;
      SM4[i2[i],i1[i]] := s1;
      Multiply2SMatrix4(@SM4, @ms4);
      ms4 := SM4;
    end;
end;

procedure BuildSMatrix4(const dXWrot, dYWrot, dZWrot: Double; var Smatrix4: TSMatrix4);
var sinX, cosX: Double;
    sinY, cosY: Double;
    sinZ, cosZ: Double;
    SM4: TSMatrix4;
begin
    SinCosD(dXWrot, sinX, cosX);
    SinCosD(dYWrot, sinY, cosY);
    SinCosD(dZWrot, sinZ, cosZ);
    IniSMatrix4(Smatrix4);
    Smatrix4[0,0] := cosX;
    Smatrix4[3,3] := cosX;
    Smatrix4[0,3] := -sinX;
    Smatrix4[3,0] := sinX;
    IniSMatrix4(SM4);
    SM4[1,1] := cosY;
    SM4[3,3] := cosY;
    SM4[1,3] := -sinY;
    SM4[3,1] := sinY;
    Multiply2SMatrix4(@SM4, @Smatrix4);
    IniSMatrix4(Smatrix4);
    Smatrix4[2,2] := cosZ;
    Smatrix4[3,3] := cosZ;
    Smatrix4[2,3] := -sinZ;
    Smatrix4[3,2] := sinZ;
    Multiply2SMatrix4(@Smatrix4, @SM4);
end;

procedure Rotate4Dex(Vin: TPVec3D; Vout: TPVec4D; SM4: TPSMatrix4);
begin           //    eax           edx            ecx
    Vout[0] := Vin[0] * SM4[0,0] + Vin[1] * SM4[0,1] + Vin[2] * SM4[0,2]; //Vin[3] is 0
    Vout[1] := Vin[0] * SM4[1,0] + Vin[1] * SM4[1,1] + Vin[2] * SM4[1,2];
    Vout[2] := Vin[0] * SM4[2,0] + Vin[1] * SM4[2,1] + Vin[2] * SM4[2,2];
    Vout[3] := Vin[0] * SM4[3,0] + Vin[1] * SM4[3,1] + Vin[2] * SM4[3,2];
end;

procedure InvertSMatrix(M: TPSMatrix3);
begin
    FlipSingle(M[0,1], M[1,0]);
    FlipSingle(M[0,2], M[2,0]);
    FlipSingle(M[1,2], M[2,1]);
end;

{procedure Rotate4D(V4: TPVec4D; SM4: TPSMatrix4);
var Vin: TVec4D;
begin
    Vin := V4^;
    V4[0] := Vin[0] * SM4[0,0] + Vin[1] * SM4[0,1] + Vin[2] * SM4[0,2] + Vin[3] * SM4[0,3];
    V4[1] := Vin[0] * SM4[1,0] + Vin[1] * SM4[1,1] + Vin[2] * SM4[1,2] + Vin[3] * SM4[1,3];
    V4[2] := Vin[0] * SM4[2,0] + Vin[1] * SM4[2,1] + Vin[2] * SM4[2,2] + Vin[3] * SM4[2,3];
    V4[3] := Vin[0] * SM4[3,0] + Vin[1] * SM4[3,1] + Vin[2] * SM4[3,2] + Vin[3] * SM4[3,3];
end;

                           //eax, edx,       ecx
procedure BuildRotMatrixXY(var xa, ya: Double; M: TPMatrix3);
asm                                        //  cosY   sinX*sinY  -cosX*sinY
  fldz                                     //    0      cosX         sinX
  fstp    qword [ecx + 8]                  //  sinY  -sinX*cosY   cosX*cosY
  fld     qword [eax]
  fsincos                   //cosX,sinX
  fld     qword [edx]
  fsincos                   //cosY,sinY,cosX,sinX
  fst     qword [ecx]
  fld     st(0)             //cosY,cosY,sinY,cosX,sinX
  fmul    st(0), st(3)
  fstp    qword [ecx + 64]  //cosY,sinY,cosX,sinX
  fmul    st(0), st(3)
  fchs
  fstp    qword [ecx + 40]  //sinY,cosX,sinX
  fst     qword [ecx + 16]  //sinY,cosX,sinX
  fld     st(0)             //sinY,sinY,cosX,sinX
  fmul    st(0), st(3)
  fstp    qword [ecx + 24]  //sinY,cosX,sinX
  fmul    st(0), st(1)
  fchs
  fstp    qword [ecx + 48]  //cosX,sinX
  fstp    qword [ecx + 32]  //sinX
  fstp    qword [ecx + 56]
end;
                             //eax,       edx
procedure BuildRotMatrixX(var xa: Double; M: TPMatrix3);
asm                                        //    1       0        0
  fldz                                     //    0      cosX     sinX
  fst     qword [edx + 8]                  //    0     -sinX     cosX
  fst     qword [edx + 16]
  fst     qword [edx + 24]
  fstp    qword [edx + 48]
  fld1
  fstp    qword [edx]
  fld     qword [eax]
  fsincos                   //cosX,sinX
  fst     qword [edx + 32]
  fstp    qword [edx + 64]
  fst     qword [edx + 56]  //sinX
  fchs
  fstp    qword [edx + 40]  
end;
                             //eax,       edx
procedure BuildRotMatrixY(var ya: Double; M: TPMatrix3);
asm                                        //  cosY       0     -sinY
  fldz                                     //    0        1        0
  fst     qword [edx + 8]                  //  sinY       0      cosY
  fst     qword [edx + 24]
  fst     qword [edx + 40]
  fstp    qword [edx + 56]
  fld1
  fstp    qword [edx + 32]
  fld     qword [eax]
  fsincos                   //cosY,sinY
  fst     qword [edx]
  fstp    qword [edx + 64]
  fst     qword [edx + 16]  //sinY
  fchs
  fstp    qword [edx + 48]
end;  }
                             //eax, edx,       ecx
{procedure BuildRotMatrixFOV(var xa, ya: Double; M: TPMatrix3);   //todo: normalize, not really working: for calcangles@cut  ..not used anymore
asm                                        //  cosY       0       -sinY
  fldz                                     //    0      cosX       sinX
  fst     qword [ecx + 8]                  //  sinY    -sinX     cosX*cosY
  fstp    qword [ecx + 24]
  fld     qword [eax]
  fsincos                   //cosX,sinX
  fld     qword [edx]
  fsincos                   //cosY,sinY,cosX,sinX
  fst     qword [ecx]
  fmul    st(0), st(2)
  fstp    qword [ecx + 64]  //sinY,cosX,sinX
  fst     qword [ecx + 16]  //sinY,cosX,sinX
  fchs
  fstp    qword [ecx + 48]  //cosX,sinX
  fstp    qword [ecx + 32]  //sinX
  fst     qword [ecx + 56]
  fchs
  fstp    qword [ecx + 40]
end;    }

{procedure BuildRotMatrixFOV(var xa, ya: Double; M: TPMatrix3);   //todo: normalize, not really working
var sx,sy,cx,cy: Double;
begin
    SinCosD(xa, sx, cx);
    SinCosD(ya, sy, cy);
    M[0,0] := cy;
end;   }

                               //eax, edx,       ecx
procedure BuildViewVectorDFOV(var xa, ya: Double; v: TPVec3D);
asm                                        //  -sinY, sinX, cosX*cosY     ...pano: sinX*cosY, sinY, -cosX*cosY
  fld     qword [eax]
  fsincos                   //cosX,sinX
  fld     qword [edx]
  fsincos                   //cosY,sinY,cosX,sinX
  fmulp   st(2), st(0)      //sinY,cosX*cosY,sinX
  fchs
  fld     st(0)             //normalize
  fmul    st(0), st(1)
  fld     st(2)
  fmul    st(0), st(3)
  faddp
  fld     st(3)
  fmul    st(0), st(4)
  faddp
  fsqrt
  fld1
  fdivrp
  fmul    st(3), st(0)
  fmul    st(2), st(0)
  fmulp
  fstp    qword [ecx]       //cosX*cosY,sinX
  fstp    qword [ecx + 16]  //sinX
  fstp    qword [ecx + 8]
end;

{procedure BuildViewVectorDFOV(var xa, ya: Double; v: TPVec3D);
var sx,sy,cx,cy: Double;
begin                                        //  -sinY, sinX, norm*(cosX*cosY)
    SinCosD(xa, sx, cx);
    SinCosD(ya, sy, cy);
    v[0] := -sy;
    v[1] := sx;
    v[2] := Sqrt(1 - Sqr(sx) - Sqr(sy));
    if (cx * cy) < 0 then v[2] := -v[2];
end; }

procedure BuildViewVectorDSphereFOV(var xa, ya: Double; v: TPVec3D);
asm                                   //x<->y
  fld     qword [edx]
  fsincos                   //cosY,sinY
  fld     qword [eax]
  fsincos                   //cosX,sinX,cosY,sinY
  fmul    st(2), st(0)      //cosX,sinX,cosX*cosY,sinY    //  pano: sinX*cosY, sinY, cosX*cosY
  fmulp   st(3), st(0)      //sinX,cosX*cosY,sinY*cosX
  fstp    qword [ecx + 8]   //cosX*cosY,sinX*cosY
  fstp    qword [ecx + 16]
  fchs
  fstp    qword [ecx]
end;

procedure BuildViewVectorSphereFOV(var xa, ya: Double; v: TPSVec);
asm
  fld     qword [edx]
  fsincos                   //cosX,sinX    X<->Y
  fld     qword [eax]
  fsincos                   //cosY,sinY,cosX,sinX
  fmul    st(2), st(0)      //cosY,sinY,cosX*cosY,sinX    //  pano: sinX*cosY, sinY, cosX*cosY
  fmulp   st(3), st(0)      //sinY,cosX*cosY,sinX*cosY
  fstp    dword [ecx + 4]       //cosX*cosY,sinX*cosY
  fstp    dword [ecx + 8]
  fchs
  fstp    dword [ecx]
  fldz
  fstp    dword [ecx + 12]
end;

                              //eax, edx,       ecx
procedure BuildViewVectorFOV(var xa, ya: Double; v: TPSVec);
asm                                        //  -sinY, sinX, cosX*cosY
  fld     qword [eax]
  fsincos                   //cosX,sinX
  fld     qword [edx]
  fsincos                   //cosY,sinY,cosX,sinX
  fmulp   st(2), st(0)      //sinY,cosX*cosY,sinX
  fchs                      //x,z,y
  fld     st(0)             //normalize
  fmul    st(0), st(1)
  fld     st(2)
  fmul    st(0), st(3)
  faddp
  fld     st(3)
  fmul    st(0), st(4)
  faddp
  fsqrt
  fld1
  fdivrp
  fmul    st(1), st(0)
  fmul    st(2), st(0)
  fmulp   st(3), st(0)
  fstp    dword [ecx]       //cosX*cosY,sinX
  fstp    dword [ecx + 8]   //sinX
  fstp    dword [ecx + 4]
  fldz
  fstp    dword [ecx + 12]
end;

procedure Multiply2Matrix(M1, M2: TPMatrix3);
var MT: TMatrix3;
begin
    MT := M1^;
    M1[0,0] := MT[0,0] * M2[0,0] + MT[0,1] * M2[1,0] + MT[0,2] * M2[2,0];
    M1[0,1] := MT[0,0] * M2[0,1] + MT[0,1] * M2[1,1] + MT[0,2] * M2[2,1];
    M1[0,2] := MT[0,0] * M2[0,2] + MT[0,1] * M2[1,2] + MT[0,2] * M2[2,2];
    M1[1,0] := MT[1,0] * M2[0,0] + MT[1,1] * M2[1,0] + MT[1,2] * M2[2,0];
    M1[1,1] := MT[1,0] * M2[0,1] + MT[1,1] * M2[1,1] + MT[1,2] * M2[2,1];
    M1[1,2] := MT[1,0] * M2[0,2] + MT[1,1] * M2[1,2] + MT[1,2] * M2[2,2];
    M1[2,0] := MT[2,0] * M2[0,0] + MT[2,1] * M2[1,0] + MT[2,2] * M2[2,0];
    M1[2,1] := MT[2,0] * M2[0,1] + MT[2,1] * M2[1,1] + MT[2,2] * M2[2,1];
    M1[2,2] := MT[2,0] * M2[0,2] + MT[2,1] * M2[1,2] + MT[2,2] * M2[2,2];
end;

procedure Multiply2SMatrix(M1, M2: TPSMatrix3);
var MT: TSMatrix3;
begin
    MT := M1^;
    M1[0,0] := MT[0,0] * M2[0,0] + MT[0,1] * M2[1,0] + MT[0,2] * M2[2,0];
    M1[0,1] := MT[0,0] * M2[0,1] + MT[0,1] * M2[1,1] + MT[0,2] * M2[2,1];
    M1[0,2] := MT[0,0] * M2[0,2] + MT[0,1] * M2[1,2] + MT[0,2] * M2[2,2];
    M1[1,0] := MT[1,0] * M2[0,0] + MT[1,1] * M2[1,0] + MT[1,2] * M2[2,0];
    M1[1,1] := MT[1,0] * M2[0,1] + MT[1,1] * M2[1,1] + MT[1,2] * M2[2,1];
    M1[1,2] := MT[1,0] * M2[0,2] + MT[1,1] * M2[1,2] + MT[1,2] * M2[2,2];
    M1[2,0] := MT[2,0] * M2[0,0] + MT[2,1] * M2[1,0] + MT[2,2] * M2[2,0];
    M1[2,1] := MT[2,0] * M2[0,1] + MT[2,1] * M2[1,1] + MT[2,2] * M2[2,1];
    M1[2,2] := MT[2,0] * M2[0,2] + MT[2,1] * M2[1,2] + MT[2,2] * M2[2,2];
end;

procedure ScaleMatrix(const s: Double; M: TPMatrix3);
var i: Integer;
    pd: PDouble;
begin
    pd := PDouble(M);
    for i := 0 to 8 do
    begin
      pd^ := pd^ * s;
      Inc(pd);
    end;
end;

procedure ScaleSMatrix(const s: Double; M: TPSMatrix3); //not used
var i: Integer;
    ps: PSingle;
begin
    ps := PSingle(M);
    for i := 0 to 8 do
    begin
      ps^ := ps^ * s;
      Inc(ps);
    end;
end;

function VectorCross(const V1, V2: TVec3D): TVec3D;
begin
    Result[0] := V1[1] * V2[2] - V1[2] * V2[1];
    Result[1] := V1[2] * V2[0] - V1[0] * V2[2];
    Result[2] := V1[0] * V2[1] - V1[1] * V2[0];
end;

function SVectorCross(const V1, V2: TSVec): TSVec;
begin
    Result[0] := V1[1] * V2[2] - V1[2] * V2[1];
    Result[1] := V1[2] * V2[0] - V1[0] * V2[2];
    Result[2] := V1[0] * V2[1] - V1[1] * V2[0];
    Result[3] := 0;
end;

procedure SVectorChangeSign(V1: TPSVec);
asm
   mov edx, $80000000
   xor [eax], edx
   xor [eax + 4], edx
   xor [eax + 8], edx
{   fld dword [eax]
   fld dword [eax + 4]
   fld dword [eax + 8]
   fchs
   fstp dword [eax + 8]
   fchs
   fstp dword [eax + 4]
   fchs
   fstp dword [eax] }
end;

procedure CopyVec4(V1, V2: TPVec4D);
begin
    V1[0] := V2[0];
    V1[1] := V2[1];
    V1[2] := V2[2];
    V1[3] := V2[3];
end;

procedure AddVec(V1, V2: TPVec3D);  overload;
begin
    V1[0] := V1[0] + V2[0];
    V1[1] := V1[1] + V2[1];
    V1[2] := V1[2] + V2[2];
end;

procedure AddVec(V1: TPVec3D; const V2: TVec3D);  overload;
begin
    V1[0] := V1[0] + V2[0];
    V1[1] := V1[1] + V2[1];
    V1[2] := V1[2] + V2[2];
end;

function AddVecF(const V1, V2: TVec3D): TVec3D;
begin
    Result[0] := V1[0] + V2[0];
    Result[1] := V1[1] + V2[1];
    Result[2] := V1[2] + V2[2];
end;

{procedure mAddVecWeight(V1, V2: TPVec3D; W: Double);
begin
    V1[0] := V1[0] + W * V2[0];
    V1[1] := V1[1] + W * V2[1];
    V1[2] := V1[2] + W * V2[2];
end; }

                       //eax, edx,           ebp + 8
procedure mAddVecWeight(V1, V2: TPVec3D; const W: Double);
asm
    cmp SupportSSE2, 0
    jz  @@1
    movlpd xmm1, [ebp + 8]
    movupd xmm2, [edx]
    unpcklpd xmm1, xmm1
    movupd xmm0, [eax]
    mulpd  xmm2, xmm1
    mulsd  xmm1, [edx + 16]
    addpd  xmm0, xmm2
    addsd  xmm1, [eax + 16]
    movupd [eax], xmm0
    movsd  [eax + 16], xmm1
    pop ebp
    ret 8
@@1:
    fld  qword [edx]
    fld  qword [edx + 8]
    fld  qword [edx + 16]
    fld  qword [ebp + 8]
    fmul st(3), st
    fmul st(2), st
    fmulp
    fadd qword [eax + 16]
    fstp qword [eax + 16]
    fadd qword [eax + 8]
    fstp qword [eax + 8]
    fadd qword [eax]
    fstp qword [eax]
end;
                         //eax, edx, ecx,       ebp + 8
procedure mCopyAddVecWeight(V1, V2, V3: TPVec3D; const W: Double);
asm                     //dest,src,add           weight
  cmp SupportSSE2, 0
  jz @@1
    movlpd xmm1, [ebp + 8]   
    movupd xmm2, [ecx]
    unpcklpd xmm1, xmm1
    movupd xmm0, [edx]
    mulpd  xmm2, xmm1
    mulsd  xmm1, [ecx + 16]
    addpd  xmm0, xmm2
    addsd  xmm1, [edx + 16]
    movupd [eax], xmm0
    movsd  [eax + 16], xmm1
    pop  ebp
    ret 8
@@1:
  fld  qword [ecx]
  fld  qword [ecx + 8]
  fld  qword [ecx + 16]
  fld  qword [ebp + 8]
  fmul st(3), st(0)
  fmul st(2), st(0)
  fmulp
  fadd qword [edx + 16]
  fstp qword [eax + 16]
  fadd qword [edx + 8]
  fstp qword [eax + 8]
  fadd qword [edx]
  fstp qword [eax]
end;

procedure CopyAddSVecWeight(V1, V2: TPVec3D; V3: TPSVec; const W: Double);
begin
    V1[0] := V2[0] + W * V3[0];
    V1[1] := V2[1] + W * V3[1];
    V1[2] := V2[2] + W * V3[2];
end;

procedure AddSubVecWeight(V1, V2, V3: TPVec3D; const W: Double);
begin
    V1[0] := V1[0] + (V2[0] - V3[0]) * W;
    V1[1] := V1[1] + (V2[1] - V3[1]) * W;
    V1[2] := V1[2] + (V2[2] - V3[2]) * W;
end;

procedure mCopyVec(Vd, Vs: TPVec3D);
{begin
    V1[0] := V2[0];
    V1[1] := V2[1];
    V1[2] := V2[2];  }
asm
    fld  qword [edx + 16]
    fld  qword [edx + 8]
    fld  qword [edx]
    fstp qword [eax]
    fstp qword [eax + 8]
    fstp qword [eax + 16]
end;

procedure CopyVecSSE2(V1, V2: TPVec3D); //not used
asm
    movupd xmm0, [edx]
    movlpd xmm1, [edx + 16]
    movupd [eax], xmm0
    movlpd [eax + 16], xmm1
end;

procedure CopyVec4SSE2(V1, V2: TPVec4D);
asm
    movupd xmm0, [edx]
    movupd xmm1, [edx + 16]
    movupd [eax], xmm0
    movupd [eax + 16], xmm1
end;

procedure AddSubVecWeightSSE2(V1, V2, V3: TPVec3D; const W: Double);
asm
    movlpd xmm7, [ebp + 8]
    movhpd xmm7, [ebp + 8]
    movupd xmm2, [ecx]
    movupd xmm0, [edx]
    movlpd xmm1, [edx + 16]
    subpd  xmm0, xmm2
    subsd  xmm1, [ecx + 16]
    movupd xmm4, [eax]
    mulpd  xmm0, xmm7
    mulsd  xmm1, xmm7
    addpd  xmm0, xmm4
    addsd  xmm1, [eax + 16]
    movupd [eax], xmm0
    movlpd [eax + 16], xmm1
end;

function DotProductOf2Vec(V1, V2: TPVec3D): Double; //not used
begin
    Result := V1[0] * V2[0] + V1[1] * V2[1] + V1[2] * V2[2];
end;

function DistanceOf2Vecs(V1, V2: TPVec3D): Double;
begin
    Result := Sqrt(Sqr(V1[0] - V2[0]) + Sqr(V1[1] - V2[1]) + Sqr(V1[2] - V2[2]));
end;

function AxisAngleToQuat(var x, y, z, angle: Double): TQuaternion;
var cosA, sinA: Double;
begin
    SinCosD(angle * 0.5, sinA, cosA);
    Result[0] := x * sinA;
    Result[1] := y * sinA;
    Result[2] := z * sinA;
    Result[3] := cosA;
end;

function MakeRotQuatFromSNormals(const NVec: TSVec): TQuaternion;
var cosA, sinA, N: Double;
begin
    SinCosD(ArcCosSafe(-NVec[2]) * 0.5, sinA, cosA);
    N := Sqrt(NVec[1] * NVec[1] + NVec[0] * NVec[0]);
    if N < 1e-25 then
    begin
      Result[0] := 0;
      Result[1] := 0;
  //    cosA := 1;   is already
    end else begin
      sinA := sinA / N;
      Result[0] := -NVec[1] * sinA;
      Result[1] := NVec[0] * sinA;
    end;
    Result[2] := 0;
    Result[3] := cosA;
 //   NormaliseQuat(Result);
end;

procedure CreateXYVecsFromNormals(N, VX, VY: TPVec3D);
var cosA, sinA, d, d1: Double;
begin
 //   MakeOrthoVecsD(@Nv, VY, VX);
    d := Sqr(N[1]) + Sqr(N[0]);
    if d < 1e-50 then
    begin
      VX[0] := 1;	
      VY[1] := 1;
      VX[1] := 0;
      VX[2] := 0;
      VY[0] := 0;
      VY[2] := 0;
    end else begin
      SinCosD(ArcCosSafe(-N[2] / Sqrt(d + Sqr(N[2]) + d1em100)) * 0.5, sinA, cosA);
      sinA := sinA / Sqrt(d);
      d := -N[1] * sinA;
      d1 := N[0] * sinA;
      VX[0] := 1 - 2 * Sqr(d1);  
      VX[1] := 2 * d * d1;       	
      VX[2] := 2 * d1 * cosA;    	        
      VY[0] := VX[1];          
      VY[1] := 1 - 2 * Sqr(d);  
      VY[2] := -2 * d * cosA; 
    end;
end;

function RotAxisSVecToQuat(const SVec: TSVec; const angle: Single): TQuaternion;
var cosA, sinA: Double;
begin
    SinCosD(angle * 0.5, sinA, cosA);
    Result[0] := SVec[0] * sinA;
    Result[1] := SVec[1] * sinA;
    Result[2] := SVec[2] * sinA;
    Result[3] := cosA;
end;

procedure CreateMatrixFromQuat(var M: TMatrix3; var Q: TQuaternion);
begin
    M[0,0] := 1.0 - 2.0 * (Q[1] * Q[1] + Q[2] * Q[2]);   	//Row 1
    M[0,1] := 2.0 * (Q[0] * Q[1] + Q[2] * Q[3]);
    M[0,2] := 2.0 * (Q[0] * Q[2] - Q[1] * Q[3]);
    M[1,0] := 2.0 * (Q[0] * Q[1] - Q[2] * Q[3]);         	//Row 2
    M[1,1] := 1.0 - 2.0 * (Q[0] * Q[0] + Q[2] * Q[2]);
    M[1,2] := 2.0 * (Q[2] * Q[1] + Q[0] * Q[3]);
    M[2,0] := 2.0 * (Q[0] * Q[2] + Q[1] * Q[3]);     	        //Row 3
    M[2,1] := 2.0 * (Q[1] * Q[2] - Q[0] * Q[3]);
    M[2,2] := 1.0 - 2.0 * (Q[0] * Q[0] + Q[1] * Q[1]);
end;

procedure CreateSMatrixFromQuat(var M: TSMatrix3; var Q: TQuaternion);
begin
    M[0,0] := 1.0 - 2.0 * (Q[1] * Q[1] + Q[2] * Q[2]);   	//Row 1
    M[0,1] := 2.0 * (Q[0] * Q[1] + Q[2] * Q[3]);
    M[0,2] := 2.0 * (Q[0] * Q[2] - Q[1] * Q[3]);
    M[1,0] := 2.0 * (Q[0] * Q[1] - Q[2] * Q[3]);         	//Row 2
    M[1,1] := 1.0 - 2.0 * (Q[0] * Q[0] + Q[2] * Q[2]);
    M[1,2] := 2.0 * (Q[2] * Q[1] + Q[0] * Q[3]);
    M[2,0] := 2.0 * (Q[0] * Q[2] + Q[1] * Q[3]);     	        //Row 3
    M[2,1] := 2.0 * (Q[1] * Q[2] - Q[0] * Q[3]);
    M[2,2] := 1.0 - 2.0 * (Q[0] * Q[0] + Q[1] * Q[1]);
end;

{procedure SVecToQuat(SVec: TPSVec; var Q: TQuaternion);
begin
    Q[0] := SVec[2] - SVec[1];
    Q[1] := SVec[0] - SVec[2];
    Q[2] := SVec[1] - SVec[0];
    Q[3] := 1;
end;

procedure QuatToSVec(var SVec: TSVec; var Q: TQuaternion);
begin
    SVec[0] := 1 - 2 * (Q[1] * Q[1] + Q[2] * Q[2]);
    SVec[1] := 2 * (Q[0] * Q[1] + Q[2] * Q[3]);
    SVec[2] := 2 * (Q[0] * Q[2] - Q[1] * Q[3]);
    SVec[3] := 0;
end;
}

procedure NormaliseQuat(var Quat: TQuaternion);
var norm: Double;
begin
    norm := Sqrt(Quat[0] * Quat[0] + Quat[1] * Quat[1] + Quat[2] * Quat[2] + Quat[3] * Quat[3]);
    if norm < 1e-50 then
    begin
      Quat[3] := 1;
      Exit;
    end;
    norm := 1 / norm;
    Quat[0] := Quat[0] * norm;
    Quat[1] := Quat[1] * norm;
    Quat[2] := Quat[2] * norm;
    Quat[3] := Quat[3] * norm;
end;

procedure QuatToAxisAngle(var xAxes, yAxes, zAxes, angle: Double; Quat: TQuaternion);
var d: Double;
begin
    if (Quat[3] > 1) then NormaliseQuat(Quat);
    angle := (2 * ArcCos(Quat[3]));
    d := Sqrt(1 - Quat[3] * Quat[3]);
    if (d < 0.0001) then
    begin
      angle := 0;
      xAxes := Quat[0];
      yAxes := Quat[1];
      zAxes := Quat[2];
    end else begin
      d := 1 / d;
      xAxes := Quat[0] * d;
      yAxes := Quat[1] * d;
      zAxes := Quat[2] * d;
    end;
end;

function EulerToQuat(x, y, z: Double): TQuaternion;
var cosX, cosY, cosZ, sinX, sinY, sinZ: Double;
begin
    SinCosD(x * 0.5, sinX, cosX);
    SinCosD(y * 0.5, sinY, cosY);
    SinCosD(z * 0.5, sinZ, cosZ);
    Result[3] := cosX * cosY * cosZ + sinX * sinY * sinZ;
    Result[0] := sinX * cosY * cosZ - cosX * sinY * sinZ;
    Result[1] := cosX * sinY * cosZ + sinX * sinY * cosZ;
    Result[2] := cosX * cosY * sinZ - sinX * sinY * cosZ;
    NormaliseQuat(Result);
end;

function NormaliseMatrixTo(const n: Double; M: TPMatrix3): TMatrix3;
var d: Double;
    i: Integer;
begin
    for i := 0 to 2 do
    begin
      d := n / Sqrt(Sqr(M[i,0]) + Sqr(M[i,1]) + Sqr(M[i,2]));
      Result[i,0] := M[i,0] * d;
      Result[i,1] := M[i,1] * d;
      Result[i,2] := M[i,2] * d;
    end;
end;

function NormaliseSMatrixTo(const n: Double; M: TPSMatrix3): TSMatrix3;
var d: Double;
    i: Integer;
begin
    for i := 0 to 2 do
    begin
      d := n / Sqrt(Sqr(M[i,0]) + Sqr(M[i,1]) + Sqr(M[i,2]));
      Result[i,0] := M[i,0] * d;
      Result[i,1] := M[i,1] * d;
      Result[i,2] := M[i,2] * d;
    end;
end;

function NormaliseMatrixToS(const n: Double; M: TPMatrix3): TSMatrix3;
var d: Double;
    i: Integer;
begin
    for i := 0 to 2 do
    begin
      d := n / Sqrt(Sqr(M[i,0]) + Sqr(M[i,1]) + Sqr(M[i,2]));
      Result[i,0] := M[i,0] * d;
      Result[i,1] := M[i,1] * d;
      Result[i,2] := M[i,2] * d;
    end;
end;

procedure MatrixToQuat(M1: TMatrix3; var Q: TQuaternion);
var S, T: Double;
    M: TMatrix3;
begin
    M := NormaliseMatrixTo(1, @M1);
    T := 1 + M[0,0] + M[1,1] + M[2,2];
    if T > 1e-15 then
    begin
      S := 2 * Sqrt(T);
      Q[3] := 0.25 * S;
      S := 1 / S;
      Q[0] := (M[2,1] - M[1,2]) * S;
      Q[1] := (M[0,2] - M[2,0]) * S;
      Q[2] := (M[1,0] - M[0,1]) * S;
    end
    else
    begin
      if (M[0,0] > M[1,1]) and (M[0,0] > M[2,2]) then
      begin
        S := Sqrt(1 + M[0,0] - M[1,1] - M[2,2]) * 2;
        Q[0] := 0.25 * S;
        S := 1 / S;
        Q[1] := (M[1,0] + M[0,1]) * S;
        Q[2] := (M[0,2] + M[2,0]) * S;
        Q[3] := (M[2,1] - M[1,2]) * S;
      end
      else if M[1,1] > M[2,2] then
      begin
        S := Sqrt(1 + M[1,1] - M[0,0] - M[2,2]) * 2;
        Q[1] := 0.25 * S;
        S := 1 / S;
        Q[0] := (M[1,0] + M[0,1]) * S;
        Q[2] := (M[2,1] + M[1,2]) * S;
        Q[3] := (M[0,2] - M[2,0]) * S;
      end else begin
        S := Sqrt(1 + M[2,2] - M[0,0] - M[1,1]) * 2;
        Q[2] := 0.25 * S;
        S := 1 / S;
        Q[0] := (M[0,2] + M[2,0]) * S;
        Q[1] := (M[2,1] + M[1,2]) * S;
        Q[3] := (M[1,0] - M[0,1]) * S;
      end;
    end;
end;

procedure SMatrixToQuat(M1: TSMatrix3; var Q: TQuaternion);
var S, T: Double;
    M: TSMatrix3;
begin
    M := NormaliseSMatrixTo(1, @M1);
    T := 1 + M[0,0] + M[1,1] + M[2,2];
    if T > 1e-15 then
    begin
      S := 2 * Sqrt(T);
      Q[3] := 0.25 * S;
      S := 1 / S;
      Q[0] := (M[2,1] - M[1,2]) * S;
      Q[1] := (M[0,2] - M[2,0]) * S;
      Q[2] := (M[1,0] - M[0,1]) * S;
    end
    else
    begin
      if (M[0,0] > M[1,1]) and (M[0,0] > M[2,2]) then
      begin
        S := Sqrt(1 + M[0,0] - M[1,1] - M[2,2]) * 2;
        Q[0] := 0.25 * S;
        S := 1 / S;
        Q[1] := (M[1,0] + M[0,1]) * S;
        Q[2] := (M[0,2] + M[2,0]) * S;
        Q[3] := (M[2,1] - M[1,2]) * S;
      end
      else if M[1,1] > M[2,2] then
      begin
        S := Sqrt(1 + M[1,1] - M[0,0] - M[2,2]) * 2;
        Q[1] := 0.25 * S;
        S := 1 / S;
        Q[0] := (M[1,0] + M[0,1]) * S;
        Q[2] := (M[2,1] + M[1,2]) * S;
        Q[3] := (M[0,2] - M[2,0]) * S;
      end else begin
        S := Sqrt(1 + M[2,2] - M[0,0] - M[1,1]) * 2;
        Q[2] := 0.25 * S;
        S := 1 / S;
        Q[0] := (M[0,2] + M[2,0]) * S;
        Q[1] := (M[2,1] + M[1,2]) * S;
        Q[3] := (M[1,0] - M[0,1]) * S;
      end;
    end;
end;

{function NormOfQuat(a: TQuaternion): Double;
begin
    Result := a[0] * a[0] + a[1] * a[1] + a[2] * a[2] + a[3] * a[3];
end;

function ExpQuat(q: TQuaternion): TQuaternion;
var a, s, et: Double;
begin
    a := Sqrt(q[0] * q[0] + q[1] * q[1] + q[2] * q[2]);
    et := Exp(q[3]);
    if a > 1e-10 then s := et * Sin(a) / a else s := 0;
    Result[0] := s * q[0];
    Result[1] := s * q[1];
    Result[2] := s * q[2];
    Result[3] := et * Cos(a);
end;

function LnQuat(q: TQuaternion): TQuaternion;
var a, s: Double;
begin
    a := Sqrt(q[0] * q[0] + q[1] * q[1] + q[2] * q[2]);
    if a > 1e-10 then s := ArcTan2(a, q[3]) / a else s := 0;
    Result[0] := s * q[0];
    Result[1] := s * q[1];
    Result[2] := s * q[2];
    Result[3] := Ln(NormOfQuat(q));
end; }

function DotOfQuats(const Q1, Q2: TQuaternion): Double;
begin
    Result := Q1[0] * Q2[0] + Q1[1] * Q2[1] + Q1[2] * Q2[2] + Q1[3] * Q2[3];
end;

function ScaleQuat(const Q: TQuaternion; const s: Double): TQuaternion;
begin
    Result[0] := Q[0] * s;
    Result[1] := Q[1] * s;
    Result[2] := Q[2] * s;
    Result[3] := Q[3] * s;
end;

function LengthSquaredOfQuat(const Q: TQuaternion): Double;
begin
    Result := Q[0] * Q[0] + Q[1] * Q[1] + Q[2] * Q[2] + Q[3] * Q[3];
end;

function InvertQuat(const Q: TQuaternion): TQuaternion;
begin
    Result[0] := -Q[0];
    Result[1] := -Q[1];
    Result[2] := -Q[2];
    Result[3] := Q[3];
    ScaleQuat(Result, 1 / LengthSquaredOfQuat(Result));
end;

{function Qmultiply(Q1, Q2: TQuaternion): TQuaternion;
begin
    Result[3] := Q1[3] * Q2[3] - Q1[0] * Q2[0] - Q1[1] * Q2[1] - Q1[2] * Q2[2];
    Result[0] := Q1[3] * Q2[0] + Q1[0] * Q2[3] + Q1[1] * Q2[2] - Q1[2] * Q2[1];
    Result[1] := Q1[3] * Q2[1] - Q1[0] * Q2[2] + Q1[1] * Q2[3] + Q1[2] * Q2[0];
    Result[2] := Q1[3] * Q2[2] + Q1[0] * Q2[1] - Q1[1] * Q2[0] + Q1[2] * Q2[3];
end;

function Divide2Quats(Q1, Q2: TQuaternion): TQuaternion;
begin
    Result := Qmultiply(Q1, InvertQuat(Q2));
end;

function Add2Quats(Q1, Q2: TQuaternion): TQuaternion;
begin
    Result[0] := Q1[0] + Q2[0];
    Result[1] := Q1[1] + Q2[1];
    Result[2] := Q1[2] + Q2[2];
    Result[3] := Q1[3] + Q2[3];
end;

function LerpQuat(Q1, Q2: TQuaternion; w2: Double): TQuaternion;
begin
    Result := Add2Quats(ScaleQuat(Q1, 1 - w2), ScaleQuat(Q2, w2));
    NormaliseQuat(Result);
end;  }

{function SlerpQuat(Q1, Q2: TQuaternion; w2: Double): TQuaternion;
var dot, angle: Double;
begin
    dot := DotOfQuats(Q1, Q2);
    if dot < 0 then
    begin
      dot := -dot;
      Q2[0] := -Q2[0];
      Q2[1] := -Q2[1];
      Q2[2] := -Q2[2];
      Q2[3] := -Q2[3];
    end;
    if dot < 0.95 then
    begin
      angle := ArcCos(dot); //0..pi
      Result := Add2Quats(ScaleQuat(Q1, Sin(angle * (1 - w2))),
                  ScaleQuat(Q2, Sin(angle * w2)));
      NormaliseQuat(Result);
    end else // if the angle is small, use linear interpolation
      Result := LerpQuat(Q1, Q2, w2);
end;  }

function SlerpQuat(Q1, Q2: TQuaternion; const w2: Double): TQuaternion;
var dot, angle, a1, a2: Double;
begin
    dot := DotOfQuats(Q1, Q2);
    if dot < 0 then
    begin
      dot := -dot;
      Q2[0] := -Q2[0];
      Q2[1] := -Q2[1];
      Q2[2] := -Q2[2];
      Q2[3] := -Q2[3];
    end;
    if dot > 0.9999 then dot := 0.9999;
    angle := ArcCos(dot); //0..pi
    a1 := Sin(angle * (1 - w2));
    a2 := Sin(angle * w2);
    Result[0] := a1 * Q1[0] + a2 * Q2[0];
    Result[1] := a1 * Q1[1] + a2 * Q2[1];
    Result[2] := a1 * Q1[2] + a2 * Q2[2];
    Result[3] := a1 * Q1[3] + a2 * Q2[3];
    NormaliseQuat(Result);
end;

{function Ipol3Quats(Q1, Q2, Q3: TQuaternion; w1, w2, w3: Double): TQuaternion;
var dot, angle, a1, a2, a3: Double;
begin
    dot := DotOfQuats(Q1, Q2);    //nope, not really working
    if dot < 0 then
    begin
      dot := -dot;
      Q2[0] := -Q2[0];
      Q2[1] := -Q2[1];
      Q2[2] := -Q2[2];
      Q2[3] := -Q2[3];
    end;
    if dot > 0.99 then dot := 0.99;
    angle := ArcCos(dot);

    dot := DotOfQuats(Q2, Q3);
    if dot < 0 then
    begin
      dot := -dot;
      Q3[0] := -Q3[0];
      Q3[1] := -Q3[1];
      Q3[2] := -Q3[2];
      Q3[3] := -Q3[3];
    end;
    if dot > 0.99 then dot := 0.99;
    angle := Max(angle, ArcCos(dot));

    a1 := Sin(angle * w1);
    a2 := Sin(angle * w2);
    a3 := Sin(angle * w3);

    Result[0] := a1 * Q1[0] + a2 * Q2[0] + a3 * Q3[0];
    Result[1] := a1 * Q1[1] + a2 * Q2[1] + a3 * Q3[1];
    Result[2] := a1 * Q1[2] + a2 * Q2[2] + a3 * Q3[2];
    Result[3] := a1 * Q1[3] + a2 * Q2[3] + a3 * Q3[3];
    NormaliseQuat(Result);
end;

function Ipol3QuatsE(Q1, Q2, Q3: TQuaternion; w1, w2, w3: Double): TQuaternion;
begin
    if DotOfQuats(Q1, Q2) < 0 then
    begin
      Q2[0] := -Q2[0];
      Q2[1] := -Q2[1];
      Q2[2] := -Q2[2];
      Q2[3] := -Q2[3];
    end;
    if DotOfQuats(Q2, Q3) < 0 then
    begin
      Q3[0] := -Q3[0];
      Q3[1] := -Q3[1];
      Q3[2] := -Q3[2];
      Q3[3] := -Q3[3];
    end;
    Result := ExpQuat(Add2Quats(Add2Quats(ScaleQuat(LnQuat(Q1), w1),
                      ScaleQuat(LnQuat(Q1), w1)), ScaleQuat(LnQuat(Q1), w1)));
    NormaliseQuat(Result);
end; }

function GetQuatFromEuler(const A: TVec3D): TQuaternion;
var sx, sy, sz, cx, cy, cz: Double;
begin
    SinCosD(0.5 * A[2], sz, cz);
    SinCosD(0.5 * A[1], sy, cy);
    SinCosD(0.5 * A[0], sx, cx);
    Result[3] := cz * cy * cx + sz * sy * sx;
    Result[0] := cz * cy * sx - sz * sy * cx;
    Result[1] := cz * sy * cx + sz * cy * sx;
    Result[2] := sz * cy * cx - cz * sy * sx;
end;

function GetEulerFromQuat(const Q: TQuaternion): TVec3D;
var sqx, sqy, sqz{, sqw}: Double;
begin
    sqx := Q[0] * Q[0];
    sqy := Q[1] * Q[1];
    sqz := Q[2] * Q[2];

  {  sqw := Q[3] * Q[3];
    Result[0] := ArcTan2(2 * (Q[0] * Q[1] + Q[2] * Q[3]), sqx - sqy - sqz + sqw);
    Result[1] := ArcSin(-2 * (Q[0] * Q[2] - Q[1] * Q[3]));
    Result[2] := ArcTan2(2 * (Q[1] * Q[2] + Q[0] * Q[3]), -sqx - sqy + sqz + sqw); //}
    Result[0] := ArcTan2(2 * (Q[2] * Q[1] + Q[0] * Q[3]), 1 - 2 * (sqx  + sqy));     //all inverted???
    Result[1] := ArcSin(-2 * (Q[0] * Q[2] - Q[1] * Q[3]));
    Result[2] := ArcTan2(2 * (Q[0] * Q[1] + Q[2] * Q[3]), 1 - 2 * (sqy + sqz));
end;

{function SlerpNoInvert(Q1, Q2: TQuaternion; t: Double): TQuaternion;
var dot, angle: Double;
begin
    dot := DotOfQuats(Q1, Q2);
    if (dot > -0.99) and (dot < 0.99) then
    begin
      angle := ArcCos(dot); //0..pi
      Result := Add2Quats(ScaleQuat(Q1, Sin(angle * (1 - t))),
                  ScaleQuat(Q2, Sin(angle * t)));
      NormaliseQuat(Result);
    end else
      Result := LerpQuat(Q1, Q2, t);
end;   }

    	// returns the logarithm of a quaternion = v*a where q = [cos(a),v*sin(a)]
function Qlog(Q: TQuaternion): TQuaternion;
var a, sa: Double;
begin
    if Q[3] < 0 then
    begin
      Q[0] := - Q[0];
      Q[1] := - Q[1];
      Q[2] := - Q[2];
      Q[3] := - Q[3];
    end;
    if Q[3] > 0.999 then a := 1 else
    begin
      a := ArcCos(Q[3]);
      sa := Sin(a);
      a := a / sa;
    end;
    result[0] := a * Q[0];
    result[1] := a * Q[1];
    result[2] := a * Q[2];
    result[3] := 0;
end;

	// returns e^quaternion = exp(v*a) = [cos(a),vsin(a)]
function Qexp(Q: TQuaternion): TQuaternion;
var a, sa, ca: Double;
begin
    a := Sqrt(Sqr(Q[0]) + Sqr(Q[1]) + Sqr(Q[2]) + Sqr(Q[3]));
    SinCosD(a, sa, ca);
    if a > 1e-50 then sa := sa / a else sa := 1;
    result[0] := sa * Q[0];
    result[1] := sa * Q[1];
    result[2] := sa * Q[2];
    result[3] := ca;
end;

function q_exp(q: TQuaternion): TQuaternion;
var n, ex, s, c: Double;
begin
    n := Sqrt(q[0]*q[0] + q[1]*q[1] + q[2]*q[2]);
    ex := Exp(q[3]);
    SinCosD(n, s, c);
    if Abs(n) < 1e-200 then s := ex * s else s := ex * s / n;
    result[3] := ex * c;
    result[0] := s * q[0];
    result[1] := s * q[1];
    result[2] := s * q[2];
end;

function q_log(q: TQuaternion): TQuaternion;
var n, f: Double;
begin
    n := Sqrt(q[0]*q[0] + q[1]*q[1] + q[2]*q[2]);
    if Abs(n) > 1e-200 then
    begin
      f := ArcTan2(n, q[3]) / n;
      result[3] := 0.5 * Ln(q[3]*q[3] + n*n);
      result[0] := f * q[0];
      result[1] := f * q[1];
      result[2] := f * q[2];
      Exit;
    end
    else  //* special case: real number */
    begin
      result[3] := 0.5 * Ln(q[3]*q[3]);  //-nan if q[3] = 0
      result[0] := ArcTan2(0, q[0]);
      result[1] := 0;
      result[2] := 0;
      Exit;
     { /* comment on asymmetry in i, j and k:
         e^(i*pi)=-1 && e^(j*pi)=-1 && e^(k*pi)=-1
         [ and even linear combinations of i, j and k give:
           e^(a*i+b*j+c*k) = -1 for every a, b, c E R with:
           sqrt(a^2+b^2+c^2) = pi  ]
         the above means that there is an infinite number of solutions to ln(-1).
         Practically, one must choose one of them and thus break symmetry.
         [ Even then there still is an infinite number of solutions due to
           periodicity of sin and cos... ] */  }
    end;
end;

{function q_pow(const qa, qb: TQuaternion): TQuaternion;
var an, bnp: Double;
begin
  { /* if a == zero: exp(-inf*b) = 0, if b>0;
      exp(-inf*b) = inf, if b<0
      if b isn't real, exp(-inf*b) isn't defined, because
      lim sin(x) for x->-inf (same with cos) doesn't exists */ }
{   an := Sqrt(qa[0]*qa[0] + qa[1]*qa[1] + qa[2]*qa[2]);
    bnp := qb[0]*qb[0] + qb[1]*qb[1] + qb[2]*qb[2];
    if (Abs(an) < 1e-200) and ((qb[3] > 0) or (bnp <> 0)) then
    begin
      result[1] := 0;
      result[2] := 0;
      result[3] := 0;
      result[0] := 0;
      Exit;
    end;
    Result := q_exp(Qmultiply(q_log(qa), qb));
end;   }

	// Given 3 quaternions, qn-1,qn and qn+1, calculate a control point to be used in spline interpolation
{function spline(qnm1, qn, qnp1: TQuaternion): TQuaternion;
var qni: TQuaternion;
begin
    qni[0] := -qn[0];
    qni[1] := -qn[1];
    qni[2] := -qn[2];
    qni[3] := qn[3];
 //   qni := InvertQuat(qn);
 //   Result := Qmultiply(qn, ExpQuat(ScaleQuat(Add2Quats(LnQuat(Qmultiply(qni, qnm1)),
   //                                       LnQuat(Qmultiply(qni, qnp1))), -0.25)));
    Result := Qmultiply(qn, Qexp(ScaleQuat(Add2Quats(Qlog(Qmultiply(qni, qnm1)),
                                       Qlog(Qmultiply(qni, qnp1))), -0.25)));
end;
                                                 
	// spherical cubic interpolation
function QCubic(Q0, Q1, Q2, Q3: TQuaternion; t: Double): TQuaternion;
var A, B, C, D: TQuaternion;
begin
    A := spline(Q0, Q1, Q2);
    B := spline(Q1, Q2, Q3);
 {   C := slerpNoInvert(Q1, Q2, t);
    D := slerpNoInvert(A, B, t);
    Result := slerpNoInvert(C, D, 2 * t * (1 - t));  }
 {   C := SlerpQuat(Q1, Q2, t);
    D := SlerpQuat(A, B, t);
    Result := SlerpQuat(C, D, 2 * t * (1 - t));
end;    }

function QBezier(const Q0, Q1, Q2: TQuaternion; const t: Double): TQuaternion;    //quadratic bezier
var A, B: TQuaternion;
begin
    A := SlerpQuat(Q0, Q1, 0.5);
    B := SlerpQuat(Q1, Q2, 0.5);
    A := SlerpQuat(A, Q1, t);
    B := SlerpQuat(Q1, B, t);
    Result := SlerpQuat(A, B, t);
end;

	// Shoemake-Bezier interpolation using De Castlejau algorithm   = cubic bezier
{function CBezier(Q1, Q2, A, B: TQuaternion; t: Double): TQuaternion;
var q11, q12, q13: TQuaternion;
begin
   q11 := slerpNoInvert(Q1, A, t);
   q12 := slerpNoInvert(A, B, t);
   q13 := slerpNoInvert(B, Q2, t);
   Result := slerpNoInvert(slerpNoInvert(q11, q12, t), slerpNoInvert(q12, q13, t), t);
end;  }

	// converts from a normalized axis - angle pair rotation to a quaternion
function Quat_from_axis_angle(axis: TPVec3D; angle: Double): TQuaternion;
var d: Double;
begin
    d := Sin(angle * 0.5);
    result[0] := axis[0] * d;
    result[1] := axis[1] * d;
    result[2] := axis[2] * d;
    result[3] := Cos(angle * 0.5);
end;

	// returns the axis and angle of this unit quaternion
procedure Quat_to_axis_angle(Q: TQuaternion; axis: TPVec3D; var angle: Double);
var sinf_theta_inv: Double;
begin
    angle := ArcCos(Q[3]);
    sinf_theta_inv := 1 / Sin(angle);
    axis[0] := Q[0] * sinf_theta_inv;
    axis[1] := Q[1] * sinf_theta_inv;
    axis[2] := Q[2] * sinf_theta_inv;
    angle := angle * 2;
end;

function aMedian(const Count: Integer; var List: array of Double;
                 const select: Single): Double;
var i: Integer;
    fr, tmp: Double;
procedure QuickSort(const L, R: Integer);
var LPos, RPos: Integer;
    ListR, Tmp: Double;
begin
    LPos  := L - 1;
    RPos  := R;
    ListR := List[R];
    repeat
      repeat Inc(LPos) until (List[LPos] >= ListR);                        //acces violation
      repeat Dec(RPos) until (RPos <= LPos) or (List[RPos] <= ListR);
      if LPos >= RPos then Break;
      Tmp := List[LPos];  List[LPos] := List[RPos];  List[RPos] := Tmp;
    until False;
    Tmp := List[LPos];  List[LPos] := List[R];  List[R] := Tmp;
    if LPos - 1 > L then QuickSort(L, LPos - 1);
    if R > LPos + 1 then QuickSort(LPos + 1, R);
end;
begin
    if Count > 1 then
    begin
      QuickSort(0, Count - 1);
      tmp    := select * (Count - 1);
      fr     := frac(tmp);
      i      := trunc(tmp);
      Result := fr * (List[i + 1] - List[i]) + List[i];
    end
    else if Count = 0 then Result := 0 else Result := List[0];
end;
                 //ebp+12   ebp+8     st(0)
function MaxCS(s1, s2: Single): Single;
{begin
    if s1 < s2 then Result := s2 else Result := s1;
end;   }
asm
    fld  dword [ebp + 8]
    fcomp dword [ebp + 12]
    fnstsw ax
    shr  ah, 1
    jc   @S2isSmallerThanS1
    fld  dword [ebp + 8]
    jmp  @end
@S2isSmallerThanS1:
    fld  dword [ebp + 12]
@end:
end;    
              //ebp+8       st
function Max0S(s: Single): Single;
{begin
    if s < 0 then Result := 0 else Result := s;   }
asm
    fld  dword [ebp + 8]
    ftst
    fnstsw ax
    shr  ah, 1
    jnc  @@1
    fstp st
    fldz
@@1:
end;

{                 //ebp+12   ebp+8     st(0)
function MaxCSsse(const s1, s2: Single): Single;
begin
asm

end;  }


function MinCS(const s1, s2: Single): Single;
asm
    fld  dword [ebp + 8]
    fcomp dword [ebp + 12]
    fnstsw ax
    shr  ah, 1
    jc   @S2isSmallerThanS1
    fld  dword [ebp + 12]
    jmp  @end
@S2isSmallerThanS1:
    fld  dword [ebp + 8]
@end:  
end;
                           //ebp+12  ebp+8          eax
procedure MinMaxSvar(const smin, smax: Single; var s: Single);
{begin
    if s < smin then s := smin else
    if s > smax then s := smax;
end; }
asm
    cmp SupportSSE, 0
    jz  @@1
    movss xmm0, [eax]
    maxss xmm0, [ebp + 12]
    minss xmm0, [ebp + 8]
    movss [eax], xmm0
    pop ebp
    ret 8
@@1:
    mov  edx, eax
    fld  dword [eax]
    fcom dword [ebp + 12]
    fnstsw ax
    shr  ah, 1
    jc   @SminIsSmallerThanS
    fcom dword [ebp + 8]
    fnstsw ax
    shr  ah, 1
    jc   @end
    fstp st(0)
    fld  dword [ebp + 8]
    jmp  @end
@SminIsSmallerThanS:
    fstp st(0)
    fld  dword [ebp + 12]
@end:
    fstp dword [edx]
end;
                    //ebp+16 ebp+12 ebp+8       st(0)
function MinMaxCS(const smin, s, smax: Single): Single;
{begin
    if s < smin then Result := smin else
    if s > smax then Result := smax else Result := s;
end; }
asm
    fld  dword [ebp + 12]
    fcom dword [ebp + 16]
    fnstsw ax
    shr  ah, 1
    jc   @SminIsSmallerThanS
    fcom dword [ebp + 8]
    fnstsw ax
    shr  ah, 1
    jc   @end
    fstp st(0)
    fld  dword [ebp + 8]
    jmp  @end
@SminIsSmallerThanS:
    fstp st(0)
    fld  dword [ebp + 16]
@end:
end;
                    //ebp+12  ebp+8         st
function Min0MaxCS(const s, smax: Single): Single;
{begin
    if s <= 0 then Result := 0 else
    if s > smax then Result := smax else Result := s; }
asm
    fld  dword [ebp + 12]
    ftst
    fnstsw ax
    shr  ah, 1
    jc   @SminIsSmallerThanS
    fcom dword [ebp + 8]
    fnstsw ax
    shr  ah, 1
    jc   @end
    fstp st(0)
    fld  dword [ebp + 8]
    jmp  @end
@SminIsSmallerThanS:
    fstp st(0)
    fldz
@end:
end;
                  //  eax  edx
procedure MaxCDvar(var ds, ddest: Double);
asm
    fld  qword [eax]
    fcom qword [edx]
    fnstsw ax
    shr  ah, 1
    jc   @@1
    fstp qword [edx]
    ret
@@1:
    fstp st
end;

procedure Clamp1Svar(var s: Single);
asm
    fld1
    mov  edx, eax
    fcom dword [eax]
    fnstsw ax
    shr  ah, 1
    jnc  @@1
    fstp dword [edx]
    ret
@@1:
    fstp st
end;
                    //ebp+16  ebp+8         st
function Min0MaxCD(const d, dmax: Double): Double;
{begin
    if d <= 0 then Result := 0 else
    if d > dmax then Result := dmax else Result := d; }
asm
    fld  qword [ebp + 16]
    ftst
    fnstsw ax
    shr  ah, 1
    jc   @@1
    fcom qword [ebp + 8]
    fnstsw ax
    shr  ah, 1
    jc   @end
    fstp st(0)
    fld  qword [ebp + 8]
    jmp  @end
@@1:
    fstp st(0)
    fldz
@end:
end;
                     //ebp+24 ebp+16 ebp+8       st(0)
function MinMaxCD(const dmin, d, dmax: Double): Double;  //not used
begin
    if d < dmin then Result := dmin else
    if d > dmax then Result := dmax else Result := d;
end;
{asm
    fld  qword [ebp + 12]
    fcom dword [ebp + 16]
    fnstsw ax
    shr  ah, 1
    jc   @SminIsSmallerThanS
    fcom dword [ebp + 8]
    fnstsw ax
    shr  ah, 1
    jc   @end
    fstp st(0)
    fld  dword [ebp + 8]
    jmp  @end
@SminIsSmallerThanS:
    fstp st(0)
    fld  dword [ebp + 16]
@end: 
end;  }
                  //ebp+16   ebp+8     st(0)
function MinCD(const s1, s2: Double): Double;
//    if s1 < s2 then Result := s1 else Result := s2;
asm
    fld  qword [ebp + 8]
    fcomp qword [ebp + 16]
    fnstsw ax
    shr  ah, 1
    jc   @S2isSmallerThanS1
    fld  qword [ebp + 16]
    jmp  @end
@S2isSmallerThanS1:
    fld  qword [ebp + 8]
@end:
end;

function MaxCD(const s1, s2: Double): Double;
asm
    fld  qword [ebp + 8]
    fcomp qword [ebp + 16]
    fnstsw ax
    shr  ah, 1
    jc   @S2isSmallerThanS1
    fld  qword [ebp + 8]
    jmp  @end
@S2isSmallerThanS1:
    fld  qword [ebp + 16]
@end:
end;

//    if Abs(s1) < Abs(s2) then Result := s2 else Result := s1;
function MaxAbsCD(const s1, s2: Double): Double;
asm
    fld  qword [ebp + 16]
    fabs
    fld  qword [ebp + 8]
    fabs
    fcompp
    fnstsw ax
    shr  ah, 1
    jc   @S2isSmallerThanS1
    fld  qword [ebp + 8]
    jmp  @end
@S2isSmallerThanS1:
    fld  qword [ebp + 16]
@end:
end;

//    if Abs(s1) < Abs(s2) then Result := s1 else Result := s2;
function MinAbsCD(const s1, s2: Double): Double;
asm
    fld  qword [ebp + 16]
    fabs
    fld  qword [ebp + 8]
    fabs
    fcompp
    fnstsw ax
    shr  ah, 1
    jc   @S2isSmallerThanS1
    fld  qword [ebp + 16]
    jmp  @end
@S2isSmallerThanS1:
    fld  qword [ebp + 8]
@end:
end;

procedure SinCosD(const a: Double; var Sin, Cos: Double);
asm
    fld  a
    fsincos
    fstp qword ptr [edx]    // Cos
    fstp qword ptr [eax]    // Sin
end;

procedure SinCosS(const a: Double; var Sin, Cos: Single);
asm
    fld  a
    fsincos
    fstp dword ptr [edx]    // Cos
    fstp dword ptr [eax]    // Sin
end;

function FracSingle(const s: Single): Single;
asm
    fld  s        //ebp+8
    fld  st(0)
    sub  esp, 4
    fnstcw [esp].word      // save
    fnstcw [esp + 2].word  // scratch
    or   [esp + 2].word, $0F00  // trunc toward zero, full precision
    fldcw [esp + 2].word
    frndint
    fldcw [esp].word
    add  esp, 4
    fsubp
end;

procedure ChangeMathFuncsToSSE2;
begin
   // mAddVecWeight     := AddVecWeightSSE2;
 //   mCopyVec          := CopyVecSSE2;
    mCopyVec4         := CopyVec4SSE2;
 //   mCopyAddVecWeight := CopyAddVecWeightSSE2;
    mAddSubVecWeight  := AddSubVecWeightSSE2;
end;

procedure ChangeMathFuncsToSSE;
begin
  //  mSqrtSVec := SqrtSVecSSE;
    mMinMaxSVec := MinMaxSVecSSE;
    mClamp0SVec := Clamp0SVecSSE;
//    mClamp08SVec := Clamp08SVecSSE;
end;

end.
