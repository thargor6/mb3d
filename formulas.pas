unit formulas;

interface

uses CustomFormulas, TypeDefinitions;

procedure doHybridPas(PIteration3D: TPIteration3D);
function doHybridPasDE(PIteration3D: TPIteration3D): Double;
procedure doHybridSSE2(PIteration3D: TPIteration3D);
function doHybridDESSE2(PIteration3D: TPIteration3D): Double;
procedure doInterpolHybridPas(PIteration3D: TPIteration3D);
procedure doInterpolHybridSSE2(PIteration3D: TPIteration3D);
function doInterpolHybridPasDE(PIteration3D: TPIteration3D): Double;
function doInterpolHybridDESSE2(PIteration3D: TPIteration3D): Double;
procedure doInterpolHybridPas4D(PIteration3D: TPIteration3D);
function doInterpolHybridPas4DDE(PIteration3D: TPIteration3D): Double;
//function doInterpolHybridPasIFS(PIteration3D: TPIteration3D): Double;
procedure doHybrid4DPas(PIteration3D: TPIteration3D);
procedure doHybrid4DSSE2(PIteration3D: TPIteration3D);
function doHybrid4DDEPas(PIteration3D: TPIteration3D): Double;
function doHybridIFS3D(PIteration3D: TPIteration3D): Double;
function doHybridIFS3DnoVecIni(PIteration3D: TPIteration3D): Double; //to use behind common fractals, use the new vec for it
procedure HybridCube(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridCubeDE(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridCubeSSE2(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridCubeSSE2DE(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridItTricorn(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridQuat(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridItIntPow2(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridItIntPow3(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridItIntPow4(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridIntP5(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridIntP6(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridIntP7(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridIntP8(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridQuatSSE2(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridItIntPow2SSE2(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridCustomIFS;
procedure TestHybrid(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridCustomIFStest;
procedure HybridFloatPow(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure HybridSuperCube2(var x, y, z, w: Double; PIteration3D: TPIteration3D);   //Bulbox
procedure HybridFolding(var x, y, z, w: Double; PIteration3D: TPIteration3D);
procedure EmptyFormula(var x, y, z, w: Double; PIteration3D: TPIteration3D); //for not used formulas
procedure HybridItIntPow2scale(var x, y, z, w: Double; PIteration3D: TPIteration3D); //sine bulb with scaling
procedure CalcSmoothIterations(PIt3D: TPIteration3D; n: Integer);
procedure AexionC(var x, y, z, w: Double; PIteration3D: TPIteration3D);

var
    fIsMemberAlternating:   TMandFunction   = doHybridPas;
    fIsMemberAlternatingDE: TMandFunctionDE = doHybridPasDE;
    fIsMemberAlternating4D: TMandFunction   = doHybrid4DPas;
    fIsMemberIpol:          TMandFunction   = doInterpolHybridPas;
    fIsMemberIpolDE:        TMandFunctionDE = doInterpolHybridPasDE;
    fHybridCubeDE:    ThybridIteration = HybridCubeDE;
    fHybridCube:      ThybridIteration = HybridCube;
    fHybridQuat:      ThybridIteration = HybridQuat;
    fHybridItIntPow2: ThybridIteration = HybridItIntPow2;
    fHybridTricorn:   ThybridIteration = HybridItTricorn;
    fHIntFunctions:   array[2..8] of ThybridIteration = (HybridItIntPow2,
      HybridItIntPow3, HybridItIntPow4, HybridIntP5, HybridIntP6, HybridIntP7,
      HybridIntP8);

 {   testhybridDEoption: Integer = 2; //6;  //11=ABox  5=4dABox  6=4dIFS
    testhybridRstop: Double = 1024;    //1024
    testhybridDEscale: Double = 0.2;   //0.2;
    testhybridPow: Double = 2;            //0,7,0    21: .SRECI2 single + reciproc single
    testhybridOptionCount: Integer = 14;   //AmazingBox vars: scale=double, MinR=boxscale: Scale/Sqr(MinR), Sqr(MinR), Fold=double..
    testhybridOptionTypes: array[0..13] of Integer = (1,1,9,1,1,1,1,1,1,6,6,6,1,1);  //5:.3DoubleAngles  9:DSquare
    testhybridOptionVals: array[0..13] of Double = (2,0.25,0.5,2,2,2,1,1,1,0,0,0,2,2);
    testhybridOptionsStrings: array[0..13] of String = ('Scale','BoxFold','SphereFold','NonLin X','NonLin Y','NonLin Z','Lin X','Lin Y',
      'Lin Z','Rotate X','Rotate Y','Rotate Z', 'NonLin vary', 'Lin vary'); }
{.Double Scale = 1.5      asurf
.Boxscale Min R = 0.5
.Double Fold = 1
.3SingleAngles Rotation1 = 5
.Double Scale vary = 0
.Integer Sphere or Cylinder = 1   }
 {   testhybridDEoption: Integer = 2;  //abox platinum
    testhybridRstop: Double = 1024;
    testhybridDEscale: Double = 0.2;
    testhybridPow: Double = 2;            //0,7,0    21: .SRECI2 single + reciproc single
    testhybridOptionCount: Integer = 15;   //AmazingBox vars: scale=double, MinR=boxscale: Scale/Sqr(MinR), Sqr(MinR), Fold=double..
    testhybridOptionTypes: array[0..14] of Integer = (0,7,0,6,6,6,0,0,0,13,3,3,3,3,2);  //6:.3SingleAngles  9:DSquare
    testhybridOptionVals: array[0..14] of Double = (2,0.5,1,0,0,0,0,0,0,1,0,0,0,0,0);
    testhybridOptionsStrings: array[0..14] of String = ('Scale','Min R/IR','Fold','RotationX','RotationY','RotationZ',
      'Inv xC','Inv yC','Inv zC','Inv Radius','FoldX, XY angle','FoldX, XZ angle','FoldY, XY angle','FoldY, YZ angle',
      'Abs XYZ switches');   }
    testhybridDEoption: Integer = -1;  //X+SinY
    testhybridRstop: Double = 16;
    testhybridDEscale: Double = 0.2;
    testhybridPow: Double = 2;            //0,7,0    21: .SRECI2 single + reciproc single
    testhybridOptionCount: Integer = 6;   //AmazingBox vars: scale=double, MinR=boxscale: Scale/Sqr(MinR), Sqr(MinR), Fold=double..
    testhybridOptionTypes: array[0..5] of Integer = (2,2,1,1,1,1);  //6:.3SingleAngles  9:DSquare
    testhybridOptionVals: array[0..5] of Double = (1,2,0,1,1,0);
    testhybridOptionsStrings: array[0..5] of String = ('Index1','Index2','Offset 1','Scale 1','Scale 2','Offset 2');
{.Double Scale = 2
.Boxscale MinR/IR = 0.5
.Double Fold = 1
.3SingleAngles Rotate = 0
.Double Inv xC = 0
.Double Inv yC = 0
.Double Inv zC = 0
.DRecipro Inv Radius = 1
.DoubleAngle FoldX, XY angle = 0
.DoubleAngle FoldX, XZ angle = 0
.DoubleAngle FoldY, XY angle = 0
.DoubleAngle FoldY, YZ angle = 0
.Integer Abs XYZ switches = 0 }{   testhybridDEoption: Integer = 11;  //amazing surf
    testhybridRstop: Double = 20;
    testhybridDEscale: Double = 0.2;
    testhybridPow: Double = 2;            //0,7,0    21: .SRECI2 single + reciproc single
    testhybridOptionCount: Integer = 8;   //AmazingBox vars: scale=double, MinR=boxscale: Scale/Sqr(MinR), Sqr(MinR), Fold=double..
    testhybridOptionTypes: array[0..7] of Integer = (0,7,0,6,6,6,0,2);  //6:.3SingleAngles  9:DSquare
    testhybridOptionVals: array[0..7] of Double = (1.5,0.5,1,5,5,5,0,1);
    testhybridOptionsStrings: array[0..7] of String = ('Scale','Min R','Fold','Roatation','','','Scale vary','Sphere or Cylinder');
{    testhybridDEoption: Integer = 11;   //smoothbox
    testhybridRstop: Double = 1024;    //1024
    testhybridDEscale: Double = 0.2;   //0.2;
    testhybridPow: Double = 2;            //0,7,0    21: .SRECI2 single + reciproc single
    testhybridOptionCount: Integer = 8;   //AmazingBox vars: scale=double, MinR=boxscale: Scale/Sqr(MinR), Sqr(MinR), Fold=double..
    testhybridOptionTypes: array[0..7] of Integer = (0,7,0,0,2,0,2,0);  //5:.3DoubleAngles  9:DSquare
    testhybridOptionVals: array[0..7] of Double = (2,0.5,1,0,6,1,4,0.3);
    testhybridOptionsStrings: array[0..7] of String = ('Scale','Min R','Fold','Scale vary','Sharpness (Integer 2+)',
      'Fix (BoxFold)','Sh. of BallFold (Int 3+)','Fix (BallFold)');     }

const  cs05: Single = 0.5;
       cs099: Single = 0.99;
       testIFSDEoption: Integer = 20;
       testIFSOptionCount: Integer = 10;  //Plane with otrap map coloring
       testIFSOptionTypes: array [0..9] of Integer = (0,0,0,0,0,2,2,1,1,2);
       testIFSOptionVals: array [0..9] of Double = (0,1,0,0,1,0,0,0,1,0);
       testIFSOptionsStrings: array [0..9] of String = ('Normal Z','Normal Y','Normal X','Offset','Scale',
         'Otrap color map','Map channel','Otrap offset','Otrap scale', 'Solid (0,1)'); // }
{       testIFSDEoption: Integer = 20;
       testIFSOptionCount: Integer = 13;  //Sphere
       testIFSOptionTypes: array [0..12] of Integer = (0,14,14,0,14,13,13,13,2,2,1,1,0);   //.3SingleAngles = 6  .2Doubles = 14  .Integer = 2
       testIFSOptionVals: array [0..12] of Double = (1,2,0,0,3,1,1,1,1,0,1,1,0);  // .SINGLEANGLE = 4 (sin,cos)  .DSqrReci = 15
       testIFSOptionsStrings: array [0..12] of String = ('Radius','Scale','Z add','Y add','X add',  //.DRECIPRO = 13
         'Z size','Y size','X size','Apply add+scale','Otrap option','Otrap offset','Otrap scale',
         'Inside radius'); // }
   {    testIFSDEoption: Integer = 20;
       testIFSOptionCount: Integer = 9;  //Box rounded
       testIFSOptionTypes: array [0..8] of Integer = (0,0,0,14,14,0,0,14,2);   //.3SingleAngles = 6  .2Doubles = 14  .Integer = 2
       testIFSOptionVals: array [0..8] of Double = (1,1,1,2,0,1,1,0.1,1);  // .SINGLEANGLE = 4 (sin,cos)  .DSqrReci = 15
       testIFSOptionsStrings: array [0..8] of String = ('Z halfwidth','Y halfwidth','X halfwidth',
         'Scale','Z add','Y add','X add','Border','Apply add+scale'); // }
      { testIFSDEoption: Integer = 20;
       testIFSOptionCount: Integer =14;  //sphere map
       testIFSOptionTypes: array [0..13] of Integer = (2,2,1,1,1,1,1,1,6,6,6,2,1,1);   //4=SINGLEANGLE    1=single
       testIFSOptionVals: array [0..13] of Single = (10,0,0,0,0,1,1,0.35,0,0,0,1,0,1);
       testIFSOptionsStrings: array [0..13] of String =      //spheremap/Heightmap: col-nr position changed!
       ('Map nr', 'Col nr', 'Xoffset', 'Yoffset', 'Zoffset', 'Xscale', 'Yscale', 'Hscale',
       'Rotation', 'Rotation', 'Rotation', 'OTrap Color nr', 'Color offset', 'Color mult');  }
     {   testIFSDEoption: Integer = 20;
       testIFSOptionCount: Integer = 15;  //HeightMapSphere with OTrap
       testIFSOptionTypes: array [0..14] of Integer = (2,2,1,1,1,1,1,1,18,1,1,1,2,1,1);
       testIFSOptionVals: array [0..14] of Single = (10,0,0,0,0,1,1,0.35,1,0,0,0,1,0,1);
       testIFSOptionsStrings: array [0..14] of String = ('Map nr', 'Map channel', 'X off',
       'Y off', 'Z off', 'Length', 'Radius', 'Map height', 'Scale', 'X rot', 'Y rot', 'Z rot'
       , 'OTrap channel','OTrap offset', 'OTrap mul');    }

implementation

uses Math, DivUtils, LightAdjust, Math3D, SysUtils;

procedure HybridCustomIFStest;
asm

  {    testIFSOptionTypes: array [0..9] of Integer = (0,0,0,0,0,2,2,1,1,2);
       testIFSOptionVals: array [0..9] of Double = (0,1,0,0,1,0,0,0,1,0);
       testIFSOptionsStrings: array [0..9] of String = ('Normal Z','Normal Y','Normal X','Offset','Scale',
         'Otrap color map','Map channel','Otrap offset','Otrap scale', 'Solid (0,1)');
       testIFSOptionsStrings: array [0..7] of String = ('Normal Z','Normal Y','Normal X','Offset','Scale',
                                                          -16        -24        -32        -40     -48
         'Otrap color map','Map channel','Otrap offset','Otrap scale', 'Solid(0|1)');
              -52               -56           -60             -64        -68}
    //PlaneIFS   DotProd(Normal,P) - Offset
  movupd xmm0, [esi - 120]  //x,y
  movsd  xmm1, [esi - 104]  //z
  mulpd  xmm0, [edi - 32]
  mulsd  xmm1, [edi - 16]
  addsd  xmm1, xmm0
  unpckhpd xmm0, xmm0
  addsd  xmm1, xmm0
  subsd  xmm1, [edi - 40]
  cmp   [edi - 68], 0
  jne   @up
  andpd xmm1, [edi]
@up: movsd [esi - 32], xmm1   //Rout: Double;     //+56
  mov   edx, [edi - 52]
  test  edx, edx
  jz    @out

  push  ecx              //otrap coloring
  add   esp, -32
{    ClearSVec(Vortho^);
    NVec := DVecToSVec(NormaliseVector(Vin));
    if Abs(NVec[0]) > 0.1 then
    begin
      Vortho^[0] := NVec[2];
      Vortho^[2] := -NVec[0];
    end else begin
      Vortho^[1] := -NVec[2];
      Vortho^[2] := NVec[1];
    end;
    NormaliseSVectorVar(Vortho^);
    TPLightSD(Vortho)^[1] := SVectorCross(Vortho^, NVec);
}
  fld   qword [edi - 16]
  fld   qword [edi - 24]
  fld   qword [edi - 32]  //nx,ny,nz
  fld   st   //makeorthovecs
  fabs
  fcomp s011
  fnstsw ax
  and   ah, 41H
  jnz   @@1
  fld   st(2)
  fmul  st, st
  fld   st(1)
  fmul  st, st
  faddp
  fsqrt
  fld1
  fdivrp           //1/Sqrt(rr)
  fldz
  fld   st(4)
  fmul  st, st(2)
  fld   st(3)
  fchs
  fmulp st(2), st  //vo[0],0,vo[2],nx,ny,nz
  jmp   @@2
@@1:
  fld   st(2)
  fmul  st, st
  fld   st(2)
  fmul  st, st
  faddp
  fsqrt
  fld1
  fdivrp           //1/Sqrt(rr)
  fld   st(3)
  fchs
  fmul  st, st(1)
  fld   st(3)
  fmulp st(2), st  //0,vo[1],vo[2],nx,ny,nz
  fldz
@@2:
  fld   st
  fmul  qword [esi - 120] //x
  fld   st(2)
  fmul  qword [esi - 112] //y
  faddp
  fld   st(3)
  fmul  qword [esi - 104] //z
  faddp
  fmul  qword [edi - 48]
  fstp  qword [esp]
  fld   st(5)
  fmul  st, st(2)
  fld   st(5)
  fmul  st, st(4)
  fsubrp                //r0,vo[0],vo[1],vo[2],nx,ny,nz
  fxch
  fmul  st(6), st       //vo[0],r0,vo[1],vo[2],nx,ny,nz*vo[0]
  fxch  st(4)
  fmul  st(3), st       //nx,r0,vo[1],vo[2]*nx,vo[0],ny,nz*vo[0]
  fmulp st(2), st       //r0, vo[1]*nx, vo[2]*nx, vo[0], ny, nz*vo[0]
  fxch  st(4)           //ny, vo[1]*nx, vo[2]*nx, vo[0], r0, nz*vo[0]
  fmulp st(3), st       //vo[1]*nx, vo[2]*nx, vo[0]*ny, r0, nz*vo[0]
  fsubrp st(2), st      //vo[2]*nx, vo[1]*nx-vo[0]*ny=r2, r0, nz*vo[0]
  fsubp st(3), st       //r2, r0, nz*vo[0] - vo[2]*nx = r1
  fmul  qword [esi - 104] //z
  fxch
  fmul  qword [esi - 120] //x
  faddp
  fxch
  fmul  qword [esi - 112] //y
  faddp
  fmul  qword [edi - 48]
  fstp  qword [esp + 8]
  mov   eax, esp
  mov   ecx, esp
  call  [esi + 268]         //+356 - 88 = 268
//   PMapFunc2:  esi+356    //   eax             edx             ecx
//function GetMapPixelDirectXY(PVec3D: TPVec3D; MapNr: Integer): TVec3D; //Direct pixel coords 0..1 with tiling
  mov   ecx, [edi - 56]
  and   ecx, 3
  fld   qword [esp + ecx * 8]   //col of map
  fadd  dword [edi - 60]
  fmul  dword [edi - 64]
  fstp  qword [esi + 128]
  add   esp, 32
  pop   ecx
@out:
{
  //IFS formula, rounded Box with otrap coloring modes
  movupd xmm0, [esi - 120]  //x,y
  movsd  xmm1, [esi - 104]  //z
  mulpd  xmm0, [edi - 48]   //*Scale
  mulsd  xmm1, [edi - 48]
  addpd  xmm0, [edi - 80]   //+translate
  addsd  xmm1, [edi - 64]
  xorpd  xmm4, xmm4
  cmp    [edi - 100], 0
  je @@1
  movsd  xmm5, [esi + 112]  //accumulated scale
  mulsd  xmm5, [edi - 48]
  movupd [esi - 120], xmm0
  movsd  [esi - 104], xmm1
  movsd  [esi + 112], xmm5
@@1:
  andpd  xmm0, [edi]        // abs=and [$7FFFFFFF,$7FFFFFFF]
  andpd  xmm1, [edi]
  subpd  xmm0, [edi - 32]
  subsd  xmm1, [edi - 16]
  addpd  xmm0, [edi - 96]
  addsd  xmm1, [edi - 96]
  maxpd  xmm0, xmm4
  maxsd  xmm1, xmm4
  mulpd  xmm0, xmm0
  mulsd  xmm1, xmm1
  addsd  xmm1, xmm0
  shufpd xmm0, xmm0, 1
  addsd  xmm1, xmm0
  sqrtsd xmm1, xmm1
  subsd  xmm1, [edi - 96]
  cmp    [edi - 100], 0
  jne @@2
  divsd  xmm1, [edi - 48]
@@2:
  mov eax, [edi - 104]
  movsd  [esi - 32], xmm1   //Rout: Double;     //+56
  and eax, 3
  fld  qword [esi + eax * 8 - 128]
  fmul dword [edi - 112]
  fadd dword [edi - 108]
  fstp qword [esi + 128]


      //IFS formula, cylinder with scale + radius + barrel + tip, SSE2  +OTrap  +inside radius
{  movupd xmm0, [esi - 112]  //y,z
  movsd  xmm1, [esi - 120]  //x
  mulpd  xmm0, [edi - 48]   //*Scale
  mulsd  xmm1, [edi - 48]
  addpd  xmm0, [edi - 64]   //+translate
  addsd  xmm1, [edi - 72]
  cmp    [edi - 92], 0
  je @@1
  movsd  xmm5, [esi + 112]  //accumulated scale +200
  mulsd  xmm5, [edi - 48]
  movupd [esi - 112], xmm0
  movsd  [esi - 120], xmm1
  movsd  [esi + 112], xmm5
@@1:
  movapd xmm4, xmm1
  mulpd  xmm0, xmm0
  andpd  xmm1, [edi]        //abs(x)
  pshufd xmm2, xmm0, $4E
  movapd xmm3, xmm1
  subsd  xmm1, [edi - 32]   //-xhw
  addsd  xmm0, xmm2
  minsd  xmm3, [edi - 32]
  mulsd  xmm4, [edi - 88]   //tip
  mulsd  xmm3, xmm3
  sqrtsd xmm0, xmm0
  movsd  xmm2, [edi - 112]  //Inside radius
  mulsd  xmm3, [edi - 80]   //Barrel
  subsd  xmm2, xmm0
  subsd  xmm0, [edi - 16]   //Radius
  subsd  xmm2, xmm3
  addsd  xmm0, xmm3
  subsd  xmm2, xmm4
  addsd  xmm0, xmm4
  maxsd  xmm0, xmm2
  maxsd  xmm0, xmm1
  cmp    [edi - 92], 0
  jne @@2
  divsd  xmm0, [edi - 48]
@@2:
  mov eax, [edi - 96]
  movsd  [esi - 32], xmm0   //Rout: Double;     //+56
  and eax, 3
  fld  qword [esi + eax * 8 - 128]
  fmul dword [edi - 104]
  fadd dword [edi - 100]
  fstp qword [esi + 128]   }

 {  push  ecx                 // Cylinder heightmap
  add   esp, -32            //  'Map nr', 'Map channel', 'X off', 'Y off', 'Z off',
                            //    -12          -16        -20      -24       -28
                            //  'Length', 'Radius', 'Map height', 'Scale', 'X rot', 'Y rot', 'Z rot',
                            //     -32        -36        -40                -44      ..        -76
                            //  'OTrap channel','OTrap offset', 'OTrap mul'
  fld   qword [esi - 104]   //        -80            -84            -88
  fsub  dword [edi - 28]
  fld   qword [esi - 112]
  fsub  dword [edi - 24]
  fld   qword [esi - 120]   //x,y,z
  fsub  dword [edi - 20]
    fld   st(0)            // rotate+scale   x,y,z
    fmul  dword [edi - 36-32]
    fld   st(2)            //y,cz,x,y,z
    fmul  dword [edi - 40-32]
    faddp                  //cz+cy,x,y,z
    fld   st(3)
    fmul  dword [edi - 44-32]
    faddp                  //nz,x,y,z
    fld   st(1)            //x,nz,x,y,z
    fmul  dword [edi - 12-32]
    fld   st(3)            //y,cx,nz,x,y,z
    fmul  dword [edi - 16-32]
    faddp                  //cx+cy,nz,x,y,z
    fld   st(4)
    fmul  dword [edi - 20-32]
    faddp                  //nx,nz,x,y,z
    fxch  st(2)            //x,nz,nx,y,z
    fmul  dword [edi - 24-32]
    fxch  st(3)            //y,nz,nx,cx,z
    fmul  dword [edi - 28-32]
    faddp st(3), st(0)     //nz,nx,cx+cy,z
    fxch  st(3)            //z,nx,cx+cy,nz
    fmul  dword [edi - 32-32]
    faddp st(2), st(0)     //nx,ny,nz


    fld  st(1)
    fmul st, st
    fld  st(1)
    fmul st, st
    faddp
    fsqrt
    fst  dword [esp + 28]
    fsub dword [edi - 36]  //Rdist,x,y,z
    fld  st(3)
    fabs
    fsub dword [edi - 32]
 //   fst  dword [esp + 28]  //Zdist
    fcom
    fnstsw ax
    shr ah, 1
    jc  @@0
    fxch                   // top/bottom flat without map
@@0:
    fstp  st
           //speedup: map only if distance to surface is less than...
  fld  st                  //r,r,x,y,z
  fabs
  fld  dword [edi - 40]    //Hmul,r',Rdist,x,y,z
  fabs
  fcompp                   //Rdist,x,y,z
  fnstsw ax
  shr  ah, 1
  jnc  @@1
@@2:
    fstp  qword [esi - 32]  //Rout: Double; +56  is distance
    fcompp
    fstp  st
    add   esp, 32
    pop   ecx
    ret
@@1:
//convert x,y to angle
  fstp  dword [esp + 24]    //radius
  fld   st(1)               //y,x,y,z
  fpatan
  fmul  qword [edi]         //0.5/Pi
  fstp  qword [esp]         //y,z
  fstp  st //qword [esp + 8]
      //divide by pi*2 and radius
  fmul  qword [edi]
  fdiv  dword [edi - 36]   //radius
  fstp  qword [esp + 8]
  mov   eax, esp
  mov   edx, [edi - 12]
  mov   ecx, esp
  call  [esi + 268]         //+356 - 88 = 268
//   PMapFunc2:  esi+356    //   eax             edx             ecx
//function GetMapPixelDirectXY(PVec3D: TPVec3D; MapNr: Integer): TVec3D; //Direct pixel coords 0..1 with tiling
//    PMapFunc:   TLMSfunction;//+352   pointer to a map function: function GetMapPixelSphere(PVec3D: TPVec3D; MapNr: Integer): TVec3D;
  //  PMapFunc2:  TLMSfunction;//+356   pointer to 2nd map function, PVec3D: X,Y double used to get direct pixel in range 0..1
  mov   ecx, [edi - 16]
  and   ecx, 3
  fld   qword [esp + ecx * 8]   //col of map
  fsub  qword [edi - 8]
  fmul  dword [edi - 40]    //amplitude H scale
  fmul  dword [esp + 28]    //new, to decrease top/bottom inside
  fsubr dword [esp + 24]
  fstp  qword [esi - 32]    //Rout: Double; +56  is distance
  mov   ecx, [edi - 80]     //Otrap color mapnr
  and   ecx, 3
  fld   qword [esp + ecx * 8]   //col of map
  fadd  dword [edi - 84]
  fmul  dword [edi - 88]
  fstp  qword [esi + 128]   //dfree1 for otrap coloring
  add   esp, 32
  pop   ecx

{     push  ecx                 // sphere heightmap
  add   esp, -32            //  'Map nr', 'Map channel', 'X off', 'Y off', 'Z off',
                            //    -12          -16        -20      -24       -28
                            //  'X scale', 'Y scale', 'H scale', 'Scale', 'X rot', 'Y rot', 'Z rot',
                            //     -32        -36        -40                -44      ..        -76
                            //  'OTrap channel','OTrap offset', 'OTrap mul'
  fld   qword [esi - 104]   //        -80            -84            -88
  fsub  dword [edi - 28]
  fld   qword [esi - 112]
  fmul  dword [edi - 36]
  fsub  dword [edi - 24]
  fld   qword [esi - 120]   //x,y,z
  fmul  dword [edi - 32]
  fsub  dword [edi - 20]
    fld   st(0)            // rotate+scale   x,y,z
    fmul  dword [edi - 36-32]
    fld   st(2)            //y,cz,x,y,z
    fmul  dword [edi - 40-32]
    faddp                  //cz+cy,x,y,z
    fld   st(3)
    fmul  dword [edi - 44-32]
    faddp                  //nz,x,y,z
    fld   st(1)            //x,nz,x,y,z
    fmul  dword [edi - 12-32]
    fld   st(3)            //y,cx,nz,x,y,z
    fmul  dword [edi - 16-32]
    faddp                  //cx+cy,nz,x,y,z
    fld   st(4)
    fmul  dword [edi - 20-32]
    faddp                  //nx,nz,x,y,z
    fxch  st(2)            //x,nz,nx,y,z
    fmul  dword [edi - 24-32]
    fxch  st(3)            //y,nz,nx,cx,z
    fmul  dword [edi - 28-32]
    faddp st(3), st(0)     //nz,nx,cx+cy,z
    fxch  st(3)            //z,nx,cx+cy,nz
    fmul  dword [edi - 32-32]
    faddp st(2), st(0)     //nx,ny,nz

    fld  st(2)
    fmul st, st
    fld  st(2)
    fmul st, st
    faddp
    fld  st(1)
    fmul st, st
    faddp
    fsqrt
    fld1
    fsubp   //Rdist,x,y,z
           //speedup: map only if distance to surface is less than...
  fld  st                  //r,r,x,y,z
  fabs
  fld  dword [edi - 40]    //Hmul,r',Rdist,x,y,z
  fabs
  fcompp                   //Rdist,x,y,z
  fnstsw ax
  shr ah, 1
  jnc @@1
  fstp  qword [esi - 32]    //Rout: Double; +56  is distance
  fcompp
  fstp  st
  add   esp, 32
  pop   ecx
  ret //
@@1:
  fstp  qword [esp + 24]
  fstp  qword [esp]
  fstp  qword [esp + 8]
  fstp  qword [esp + 16]
  mov   eax, esp
  mov   edx, [edi - 12]
  mov   ecx, esp
  call  [esi + 264]         //+356 - 88 = 268
//   PMapFunc2:  esi+356    //   eax             edx             ecx
//function GetMapPixelDirectXY(PVec3D: TPVec3D; MapNr: Integer): TVec3D; //Direct pixel coords 0..1 with tiling
//    PMapFunc:   TLMSfunction;//+352   pointer to a map function: function GetMapPixelSphere(PVec3D: TPVec3D; MapNr: Integer): TVec3D;
  //  PMapFunc2:  TLMSfunction;//+356   pointer to 2nd map function, PVec3D: X,Y double used to get direct pixel in range 0..1
  mov   ecx, [edi - 16]
  and   ecx, 3
  fld   qword [esp + ecx * 8]   //col of map
  fsub  qword [edi - 8]
  fmul  dword [edi - 40]    //amplitude H scale
  fsubr qword [esp + 24]
  fstp  qword [esi - 32]    //Rout: Double; +56  is distance
  mov   ecx, [edi - 80]     //Otrap color mapnr
  and   ecx, 3
  fld   qword [esp + ecx * 8]   //col of map
  fadd  dword [edi - 84]
  fmul  dword [edi - 88]
  fstp  qword [esi + 128]   //dfree1 for otrap coloring
  add   esp, 32
  pop   ecx}

{  push  ecx                 //      added OTrap coloring  + speedup
  add   esp, -32            //      HeightMap  [nr: integer; Xoffset, Yoffset, Hoffset, Xscale, Yscale, Hscale, Rotation: SingleRotmatrix, Color nr, Color OTrap Color offset, Color mult
  fld   qword [esi - 104]   //                  -12          -16       -20      -24     -28      -32    -36       -40..-72                   -76         -80          -84          -88
  fld   qword [esi - 112]
  fld   qword [esi - 120]   //x,y,z
    fld   st(0)            // rotate+scale   x,y,z
    fmul  dword [edi - 36-28]
    fld   st(2)            //y,cz,x,y,z
    fmul  dword [edi - 40-28]
    faddp                  //cz+cy,x,y,z
    fld   st(3)
    fmul  dword [edi - 44-28]
    faddp                  //nz,x,y,z
    fld   st(1)            //x,nz,x,y,z
    fmul  dword [edi - 12-28]
    fld   st(3)            //y,cx,nz,x,y,z
    fmul  dword [edi - 16-28]
    faddp                  //cx+cy,nz,x,y,z
    fld   st(4)
    fmul  dword [edi - 20-28]
    faddp                  //nx,nz,x,y,z
    fxch  st(2)            //x,nz,nx,y,z
    fmul  dword [edi - 24-28]
    fxch  st(3)            //y,nz,nx,cx,z
    fmul  dword [edi - 28-28]
    faddp st(3), st(0)     //nz,nx,cx+cy,z
    fxch  st(3)            //z,nx,cx+cy,nz
    fmul  dword [edi - 32-28]
    faddp st(2), st(0)     //nx,ny,nz
  fld  st(2)               //speedup: map only if distance to surface is less than...
  fadd dword [edi - 24]    //z+off,x,y,z
  fld  dword [edi - 36]    //Hmul,z',x,y,z
  fmul qword [edi - 8]
  fsubp
  fabs
  fld  dword [edi - 36]
  fabs
  fadd qword [esi - 136]   //It3Dex.Rold,  absolute DEstop add!
  fcompp
  fnstsw ax
  shr ah, 1
  jnc @@1
  fcompp                    //nz
  fld   qword [edi - 8]     //0.5
  fmul  dword [edi - 36]    //amplitude H scale
  fsub  dword [edi - 24]    //H offset
  fsubrp                    //-z
  fstp  qword [esi - 32]    //Rout: Double; +56  is distance
  add   esp, 32
  pop   ecx
  ret
@@1:
  fmul  dword [edi - 28]
  fsub  dword [edi - 16]    // offsets after rot+scale!   todo: only check map if Abs(distsphere) < mapscale*2+Abs(offset)
  fstp  qword [esp]
  fmul  dword [edi - 32]
  fsub  dword [edi - 20]
  fstp  qword [esp + 8]
  fstp  qword [esp + 24]
  mov   eax, esp
  mov   edx, [edi - 12]
  mov   ecx, esp
  call  [esi + 268]         //+356 - 88 = 268
//   PMapFunc2:  esi+356    //   eax             edx             ecx
//function GetMapPixelDirectXY(PVec3D: TPVec3D; MapNr: Integer): TVec3D; //Direct pixel coords 0..1 with tiling
  mov   ecx, [edi - 76]
  and   ecx, 3
  fld   qword [esp + ecx * 8]   //col of map
  fmul  dword [edi - 36]    //amplitude H scale
  fsub  dword [edi - 24]    //H offset
  fsub  qword [esp + 24]    //-z
  fstp  qword [esi - 32]    //Rout: Double; +56  is distance
  mov   ecx, [edi - 80]     //Otrap color mapnr
  and   ecx, 3
  fld   qword [esp + ecx * 8]   //col of map
  fadd  dword [edi - 84]
  fmul  dword [edi - 88]
  fstp  qword [esi + 128]   //dfree1 for otrap coloring
  add   esp, 32
  pop   ecx     }
  
 { push  ecx                 // sphere heightmap
  add   esp, -32            // HeightMap[nr: integer; Col nr, Xoffset, Yoff, Zoff, Xscale, Yscale, Hscale, Rotn: SingleM, Col nr, Colo
  fld   qword [esi - 104]   //          -12          -16       -20      -24  -28    -32     -36     -40     -44..-76        -80    -84
  fsub  dword [edi - 28]
  fld   qword [esi - 112]
  fsub  dword [edi - 24]
  fld   qword [esi - 120]   //x,y,z
  fsub  dword [edi - 20]
    fld   st(0)            // rotate+scale   x,y,z
    fmul  dword [edi - 36-32]
    fld   st(2)            //y,cz,x,y,z
    fmul  dword [edi - 40-32]
    faddp                  //cz+cy,x,y,z
    fld   st(3)
    fmul  dword [edi - 44-32]
    faddp                  //nz,x,y,z
    fld   st(1)            //x,nz,x,y,z
    fmul  dword [edi - 12-32]
    fld   st(3)            //y,cx,nz,x,y,z
    fmul  dword [edi - 16-32]
    faddp                  //cx+cy,nz,x,y,z
    fld   st(4)
    fmul  dword [edi - 20-32]
    faddp                  //nx,nz,x,y,z

  fmul  dword [edi - 32]

    fxch  st(2)            //x,nz,nx,y,z
    fmul  dword [edi - 24-32]
    fxch  st(3)            //y,nz,nx,cx,z
    fmul  dword [edi - 28-32]
    faddp st(3), st(0)     //nz,nx,cx+cy,z
    fxch  st(3)            //z,nx,cx+cy,nz
    fmul  dword [edi - 32-32]
    faddp st(2), st(0)     //nx,ny,nz
  fxch
  fmul  dword [edi - 36]
  fxch
    fld  st(2)
    fmul st, st
    fld  st(2)
    fmul st, st
    faddp
    fld  st(1)
    fmul st, st
    faddp
    fsqrt
    fld1
    fsubp   //Rdist,x,y,z
           //speedup: map only if distance to surface is less than...
  fld  st                  //r,r,x,y,z
  fabs
  fld  dword [edi - 40]    //Hmul,r',Rdist,x,y,z
  fabs
  fadd qword [esi - 136]   //abs destop
  fcompp                   //Rdist,x,y,z
  fnstsw ax
  shr ah, 1
  jnc @@1
  fstp  qword [esi - 32]    //Rout: Double; +56  is distance
  fcompp
  fstp  st
  add   esp, 32
  pop   ecx
  ret //
@@1:
  fstp  qword [esp + 24]
  fstp  qword [esp]
  fstp  qword [esp + 8]
  fstp  qword [esp + 16]
  mov   eax, esp
  mov   edx, [edi - 12]
  mov   ecx, esp
  call  [esi + 264]         //+356 - 88 = 268
//   PMapFunc2:  esi+356    //   eax             edx             ecx
//function GetMapPixelDirectXY(PVec3D: TPVec3D; MapNr: Integer): TVec3D; //Direct pixel coords 0..1 with tiling
//    PMapFunc:   TLMSfunction;//+352   pointer to a map function: function GetMapPixelSphere(PVec3D: TPVec3D; MapNr: Integer): TVec3D;
  //  PMapFunc2:  TLMSfunction;//+356   pointer to 2nd map function, PVec3D: X,Y double used to get direct pixel in range 0..1
  mov   ecx, [edi - 16]
  and   ecx, 3
  fld   qword [esp + ecx * 8]   //col of map
  fsub  qword [edi - 8]
  fmul  dword [edi - 40]    //amplitude H scale
  fsubr qword [esp + 24]
  fstp  qword [esi - 32]    //Rout: Double; +56  is distance
  mov   ecx, [edi - 80]     //Otrap color mapnr
  and   ecx, 3
  fld   qword [esp + ecx * 8]   //col of map
  fadd  dword [edi - 84]
  fmul  dword [edi - 88]
  fstp  qword [esi + 128]   //dfree1 for otrap coloring
  add   esp, 32
  pop   ecx    //}

{  fld  st(2)               //speedup: map only if distance to surface is less than...
  fadd dword [edi - 24]    //z+off,x,y,z
  fld  dword [edi - 36]    //Hmul,z',x,y,z
  fmul qword [edi - 8]
  fsubp
  fabs
  fld  dword [edi - 36]
  fabs
  fadd qword [esi - 136]   //It3Dex.Rold,  absolute DEstop add!
  fcompp
  fnstsw ax
  shr ah, 1
  jnc @@1
  fcompp                    //nz
  fld   qword [edi - 8]     //0.5
  fmul  dword [edi - 36]    //amplitude H scale
  fsub  dword [edi - 24]    //H offset
  fsubrp                    //-z
  fstp  qword [esi - 32]    //Rout: Double; +56  is distance
  add   esp, 32
  pop   ecx
  ret
@@1:

  //IFS formula, sine-water (wave)  with Roff
  add  esp, -32
  movupd xmm0, [esi - 120]  //x,y
  movsd  xmm1, [esi - 104]  //z
  mulpd  xmm0, [edi - 32]   //*Scale
  mulsd  xmm1, [edi - 32]
  addpd  xmm0, [edi - 64]   //+translate
  addsd  xmm1, [edi - 48]
  cmp    dword [edi - 76], 0  //apply add+scale
  je @@1
  movsd  xmm5, [esi + 112]  //accumulated scale +200
  mulsd  xmm5, [edi - 32]
  movupd [esi - 120], xmm0
  movsd  [esi - 104], xmm1
  movsd  [esi + 112], xmm5
@@1:
  movupd [esp], xmm0
  movsd  [esp + 16], xmm1
  mov   edx, [edi - 84]     //flipXZ
  and   edx, 1
  fld   qword [edi - 72]    //Amplitude
  shl   edx, 4
  fstp  qword [esp + 24]
  fld   qword [esp + edx]
  cmp   dword [edi - 80], 0  //Circular
  je @@3
  fmul  st(0), st(0)
  fld   qword [esp + 8]
  fmul  st(0), st(0)
  faddp
  fsqrt
  fmul  qword [edi - 16]    //frequency
  cmp   dword [edi - 88], 0 //amplitude on r
  je @@5
  fld1
  fadd  st, st(1)
  fdivr qword [esp + 24]
  fstp  qword [esp + 24]
@@5:
  fcos
  jmp @@4
@@3:
  fmul  qword [edi - 16]    //frequency
  fcos
  fld   qword [esp + 8]
  fmul  qword [edi - 16]    //frequency
  fcos
  faddp
@@4:
  neg   edx
  fmul  qword [esp + 24]    //amplitude (/(R+1)
  fsub  qword [esp + edx + 16]
  cmp   [edi - 76], 0
  jne @@2
  fdiv  qword [edi - 32]
@@2:
  fstp  qword [esi - 32]    //Rout: Double;     //+56
  add  esp, 32       //}

   //IFS formula, Box with trapez   [Z size, Y size, X size, Scale, Add Z, Add Y, Add X, trapez, twist, apply add+scale
 { movupd xmm0, [esi - 120]  //x,y       d  ,   d   ,  d   ,2doubles, 2d,    d   ,  d   ,   d   ,   s  ,   integer
  movsd  xmm1, [esi - 104]  //z
  mulpd  xmm0, [edi - 48]   //*Scale
  mulsd  xmm1, [edi - 48]
  addpd  xmm0, [edi - 80]   //+translate
  addsd  xmm1, [edi - 64]
  cmp    [edi - 96], 0
  je @@1
  movsd  xmm5, [esi + 112]  //accumulated scale
  mulsd  xmm5, [edi - 48]
  movupd [esi - 120], xmm0
  movsd  [esi - 104], xmm1
  movsd  [esi + 112], xmm5
@@1:
  cmp    [edi - 92], 0
  je @@3
  add    esp, -24        //twist
  movupd [esp], xmm0
  movsd  [esp + 16], xmm1
  fld    dword [edi - 92]
  fmul   qword [esp + 16] //z
  fsincos                //cos, sin
  fld    qword [esp + 8]
  fld    qword [esp]     //x,y,c,s
  fld    st(3)
  fmul   st, st(1)       //s*x,x,y,c,s
  fld    st(2)
  fmul   st, st(4)
  faddp
  fstp   qword [esp]     //x,y,c,s
  fmulp  st(2), st       //y,c*x,s
  fmulp  st(2), st       //c*x, s*y
  fsubrp
  fstp   qword [esp + 8]
  movupd xmm0, [esp]
  add    esp, 24
@@3:
 // pshufd xmm3, xmm0, $4E    //y to xmm3
  movsd  xmm3, xmm1
  andpd  xmm0, [edi]        // abs=and [$7FFFFFFF,$7FFFFFFF]
  andpd  xmm1, [edi]
  mulsd  xmm3, [edi - 88]   //trapez
  subpd  xmm0, [edi - 32]   //x,y size
  subsd  xmm1, [edi - 16]   //z size
  subsd  xmm0, xmm3         //trapez    todo: downscale DE if in trapez region...
  maxsd  xmm1, xmm0
  UNPCKHPD xmm0, xmm0
  maxsd  xmm1, xmm0
  cmp    [edi - 96], 0
  jne @@2
  divsd  xmm1, [edi - 48]
@@2:
  mov eax, [edi - 100]
  movsd  [esi - 32], xmm1   //Rout: Double;     //+56
  and eax, 3
  fld  qword [esi + eax * 8 - 128]
  fmul dword [edi - 108]
  fadd dword [edi - 104]
  fstp qword [esi + 128]  }

  //IFS formula, sphere with scale + radius + xyz scale, SSE2   + new otrap option
{.Version = 6
.DEoption = 20
.SSE2
.Double Radius = 1
.2Doubles Scale = 2
.2Doubles Z add = 0
.Double Y add = 0
.2Doubles X add = 3
.DSqrReci Z size = 1
.DSqrReci Y size = 1
.DSqrReci X size = 1
.Integer apply scale+add = 1     -100
.Integer OTrap option (0..3) = 0   -104
.Single OTrap offset = 1         -108
.Single OTrap scale = 1          -112
.Double Inside radius = 0  }   //-120  new: DE = Max(DE, DEinside = Inside_radius - R)

 { movupd xmm0, [esi - 120]  //x,y
  movsd  xmm1, [esi - 104]  //z
  mulpd  xmm0, [edi - 32]   //*Scale
  mulsd  xmm1, [edi - 32]
  addpd  xmm0, [edi - 64]   //+translate
  addsd  xmm1, [edi - 48]
  cmp    [edi - 100], 0
  je @@1
  movsd  xmm5, [esi + 112]  //accumulated scale +200
  mulsd  xmm5, [edi - 32]
  movupd [esi - 120], xmm0
  movsd  [esi - 104], xmm1
  movsd  [esi + 112], xmm5
@@1:
  movapd xmm3, [edi - 96]
  movsd  xmm4, [edi - 80]
  mulpd  xmm0, xmm3         //y,x size
  mulsd  xmm1, xmm4
  mulpd  xmm0, xmm0
  mulsd  xmm1, xmm1
  addsd  xmm1, xmm0         // zz'+xx'
  unpckhpd xmm0, xmm0
  addsd  xmm1, xmm0
  sqrtsd xmm1, xmm1         // |vec*scale|
  movsd  xmm2, [edi - 120]  //inside radius
  subsd  xmm2, xmm1         //DE' insideR
  subsd  xmm1, [edi - 16]   //DE' outsideR
  maxsd  xmm1, xmm2
  andpd  xmm3, [edi]        //   / min(scales)    (here max of reciscales)
  andpd  xmm4, [edi]        //abs
  maxsd  xmm4, xmm3
  unpckhpd xmm3, xmm3
  maxsd  xmm4, xmm3
  divsd  xmm1, xmm4

{  andpd  xmm3, [edi]
  andpd  xmm4, [edi]
  movapd xmm5, xmm3
  movsd  xmm6, xmm4
  addsd  xmm6, xmm5
  shufpd xmm5, xmm5, 1
  addsd  xmm6, xmm5
  addsd  xmm6, [edi + 24]
//  mulpd  xmm3, xmm3
//  mulsd  xmm4, xmm4
  mulpd  xmm3, [edi - 96]   //old calc, DE is stretched like size
  mulsd  xmm4, [edi - 80]   //y,x size  DSqrReci !  -> D+reciD, multiply before sqr
//  mulpd  xmm3, xmm3
//  mulsd  xmm4, xmm4
  andpd  xmm3, [edi]
  andpd  xmm4, [edi]        //abs
  addsd  xmm4, xmm3
  shufpd xmm3, xmm3, 1
  addsd  xmm4, xmm3
  sqrtsd xmm4, xmm4
  divsd  xmm4, xmm1
  divsd  xmm2, xmm4  //}

 { movapd xmm3, [edi - 96]   //y,x size
  movsd  xmm4, [edi - 80]   //z size
  movsd  xmm2, [edi - 16]   //radius
  movsd  xmm7, [edi - 120]  //inside radius
  movapd xmm5, xmm3
  movsd  xmm6, xmm4
  shufpd xmm2, xmm2, 1
  shufpd xmm7, xmm7, 1
  mulpd  xmm3, xmm2
  mulsd  xmm4, xmm2
  mulpd  xmm5, xmm7
  mulsd  xmm6, xmm7

  andpd  xmm0, [edi]      //and $7FFFF.. abs()
  andpd  xmm1, [edi]
  movapd xmm2, xmm0
  movsd  xmm7, xmm1
  subpd  xmm0, xmm3
  subsd  xmm1, xmm4
  subpd  xmm2, xmm5
  subsd  xmm7, xmm6

  mulpd  xmm0, xmm0
  mulsd  xmm1, xmm1
  mulpd  xmm2, xmm2
  mulsd  xmm7, xmm7
  addsd  xmm1, xmm0
  addsd  xmm7, xmm2
  shufpd xmm0, xmm0, 1      //unpckhpd ?
  shufpd xmm2, xmm2, 1
  addsd  xmm1, xmm0
  addsd  xmm7, xmm2
  sqrtsd xmm1, xmm1         //outside DE   make sqrtpd...
  sqrtsd xmm7, xmm7         //inside DE
  xorpd  xmm0, xmm0
  subsd  xmm0, xmm7

  maxsd  xmm1, xmm0  }

{  cmp    [edi - 100], 0
  jne @@2
  divsd  xmm1, [edi - 32]
@@2:
  mov eax, [edi - 104]
  movsd  [esi - 32], xmm1   //Rout: Double;     //+56
  and eax, 3
  fld  qword [esi + eax * 8 - 128]
  fmul dword [edi - 112]
  fadd dword [edi - 108]
  fstp qword [esi + 128] // }


end;

procedure ipow2(var x, y: Double);  //x:=x*x-y*y   y:=2xy
asm
    fld  qword [eax]
    fld  qword [edx]
    fld  st(0)           //y,y,x
    fmul st(0), st(2)    //y*x,y,x
    fadd st(0), st(0)
    fstp qword [edx]
    fmul st(0), st(0)    //y*y,x
    fxch
    fmul st(0), st(0)    //x*x,y*y
    fsubrp st(1), st(0)
    fstp qword [eax]
end;

procedure ComplexSqr(var xy: TComplex);  //x:=x*x-y*y   y:=2xy
asm
    fld  qword [eax]
    fld  qword [eax + 8] //y,x
    fld  st(0)           //y,y,x
    fmul st(0), st(2)    //y*x,y,x
    fadd st(0), st(0)
    fstp qword [eax + 8]
    fmul st(0), st(0)    //y*y,x
    fxch
    fmul st(0), st(0)    //x*x,y*y
    fsubrp st(1), st(0)
    fstp qword [eax]
end;

function ComplexMul(c1, c2: TComplex): TComplex;  //r[0] := x1*x2-y1*y2   r[1]:=x1*y2+x2*y1
begin
    Result[0] := c1[0] * c2[0] - c1[1] * c2[1];
    Result[1] := c1[0] * c2[1] + c1[1] * c2[0];
end;

function ComplexSqr2(c1: TComplex): TComplex;
begin
    Result[0] := c1[0] * c1[0] - c1[1] * c1[1];
    Result[1] := 2 * c1[0] * c1[1];
end;

function CConj(c1: TComplex): TComplex;
begin
    Result[0] := c1[0];
    Result[1] := -c1[1];
end;

function ComplexPower(cB, cE: TComplex): TComplex;
var c1, c2: TComplex;
    s, c, d: Double;
begin
    c1[0] := 0.5 * Ln(Sqr(cB[0]) + Sqr(cB[1]));
    c1[1] := ArcTan2(cB[1], cB[0]);
    c2[0] := cE[0] * c1[0] - cE[1] * c1[1];
    c2[1] := cE[0] * c1[1] + cE[1] * c1[0];
    d := Exp(c2[0]);
    SinCosD(c2[1], s, c);
    Result[0] := c * d;
    Result[1] := s * d;
end;

function ComplexSub(c1, c2: TComplex): TComplex;
begin
    Result[0] := c1[0] - c2[0];
    Result[1] := c1[1] - c2[1];
end;

function ComplexAdd(c1, c2: TComplex): TComplex;
begin
    Result[0] := c1[0] + c2[0];
    Result[1] := c1[1] + c2[1];
end;

function ComplexScale(c1: TComplex; d: Double): TComplex;
begin
    Result[0] := c1[0] * d;
    Result[1] := c1[1] * d;
end;

procedure QuatRotate(v: TPVec3D; q: TQuaternion);
var //w: TVec3D;
    w, x, y, z: Double;
begin
  {  w := v;
    v[0] := w[0] * (1 - 2 * (Sqr(q[1]) - Sqr(q[2]))) + w[1] * () + w[2] * ();
    v[1] := w[0] * () + w[1] * () + w[2] * ();
    v[2] := w[0] * () + w[1] * () + w[2] * ();   }

    w := -q[0] * v[0] - q[1] * v[1] - q[2] * v[2];
    x := q[3] * v[0] + q[1] * v[2] - q[2] * v[1];
    y := q[3] * v[1] - q[0] * v[2] + q[2] * v[0];
    z := q[3] * v[2] + q[0] * v[1] - q[1] * v[0];

    v[0] := (w * -q[0] + x * q[3] - y * q[2] + z * q[1]);
    v[1] := (w * -q[1] + x * q[2] + y * q[3] - z * q[0]);
    v[2] := (w * -q[2] - x * q[1] + y * q[0] + z * q[3]);
end;

procedure QuatMultiply(q1, q2: TPQuaternion);
var qt: TQuaternion;
begin
    qt := q1^;
    q1[3] := (qt[3]*q2[3] - qt[0]*q2[0] - qt[1]*q2[1] - qt[2]*q2[2]);
    q1[0] := (qt[3]*q2[0] + qt[0]*q2[3] + qt[1]*q2[2] - qt[2]*q2[1]);
    q1[1] := (qt[3]*q2[1] - qt[0]*q2[2] + qt[1]*q2[3] + qt[2]*q2[0]);
    q1[2] := (qt[3]*q2[2] + qt[0]*q2[1] - qt[1]*q2[0] + qt[2]*q2[3]);
end;

function Heart(x, y, z: Double): Double;
var xx, yy, zz, a: Double;
begin
  xx := x*x;
  yy := y*y;
  zz := z*z;
  a := 2*xx + yy + zz - 1;
  a := a*a*a;
  zz := zz * z;
  Result := a - 0.1 * xx * zz - yy * zz;
end;

procedure TestHybrid(var x, y, z, w: Double; PIteration3D: TPIteration3D); //available if 't' pressed on intern formula
const piM05: Double = 0.5 * Pi;
      d0148: Double = 0.148148148148148;
{asm
    push esi  // SinY with index, preoffset, prescale, scale, offset
    push edi
    mov  esi, [ebp + 8]
    mov  edi, [esi + 48]
    mov  esi, [edi - 12]
    and  esi, 3
    fld  qword [eax + esi * 8]
    fsub dword [edi - 16]
    fmul dword [edi - 20]
    fsin
    fmul dword [edi - 24]
    fadd dword [edi - 28]
    fstp qword [eax + esi * 8]
    pop  edi
    pop  esi    }
asm
 {   push esi   // kalisets
    push edi
    mov  esi, [ebp + 8]
    mov  edi, [esi + 48]
    fld  qword [eax]
    fabs
    fld  qword [edx]
    fabs
    fld  qword [ecx]
    fabs
    fld  st(2)
    fmul st, st
    fld  st(2)
    fmul st, st
    faddp
    fld  st(1)
    fmul st, st
    faddp
    fadd qword [edi - 24]
    fld  qword [edi - 16]
    fdivrp
    fmul st(3), st
    fmul st(2), st
    fmul st(1), st
    fmul qword [ecx + 8]
    fstp qword [ecx + 8]
    fadd qword [esi + $28]
    fstp qword [ecx]
    fadd qword [esi + $20]
    fstp qword [edx]
    fadd qword [esi + $18]
    fstp qword [eax]
    pop  edi
    pop  esi  }

    push esi   // PlusSinApp   fast V1+Sin(V2) with index, preoffset, prescale, scale, offset
    push edi
    push eax
    push edx
    mov  esi, [ebp + 8]
    mov  edi, [esi + 48]
    mov  esi, [edi - 16]
    and  esi, 3
    fld  qword [eax + esi * 8]
    xor  edx, edx
    fsub dword [edi - 20]
    fmul dword [edi - 24]
    fmul qword [edi]    // Pi05d //
    fld  st
    fsub qword [edi - 8]
    frndint
    fsubp
    fadd  st, st
    fld1
    fcomp
    fnstsw ax
    shr  ah, 1
    jnc  @1
    fld1
    fadd st, st
    fsubrp
    xor  edx, $80000000
@1: fldpi
    fmulp
    fcom  qword [edi + 8] //piM05 //
    fnstsw ax
    shr  ah, 1
    jc   @2
    fldpi
    fsubp
    xor  edx, $80000000
@2: fld  st
    fmul st, st
    fmul st, st(1)
    fmul qword [edi + 16] //d0148 //
    fsubp
    test edx, $80000000
    jns  @3
    fchs
@3:
    pop  edx
    pop  eax
    mov  esi, [edi - 12]
    fmul dword [edi - 28]
    and  esi, 3
    fadd dword [edi - 32]
    fadd qword [eax + esi * 8]
    fstp qword [eax + esi * 8]
    pop  edi
    pop  esi

 {   testhybridOptionsStrings: array[0..14] of String = ('Scale','Min R/IR','Fold','RotationX','RotationY','RotationZ',
                                                           -$10    -$18-$20   -$28        -$2C..-4C
      'Inv xC','Inv yC','Inv zC','Inv Radius','FoldX, XY angle','FoldX, XZ angle','FoldY, XY angle','FoldY, YZ angle',
        -$54     -$5C     -$64      -$6C        -$74  -$7C         -$84 -$8C        -$94 -$9C           -$A4  -$AC
      'Abs XYZ switches');     }
         //-$B0
{  push esi
  push ebx
  mov  esi, [ebp+$08]
  mov  ebx,eax
  mov  esi, [esi+$30]
  add  esp, -$20
  add  esi, -$40
  fld  qword ptr [esi-$28+$40]       //fold
  fld  qword ptr [ebx]               //x,f   #2
  fmul qword ptr [esi-$0000008c+$40] //x',f
  fld  qword ptr [ecx]               //z,x',f  #3
  fmul qword ptr [esi-$00000084+$40] //z',x',f
  fsubp                              //zx,f
  fld  qword ptr [ebx]               //x,zx,f  #3
  fmul qword ptr [esi-$00000084+$40]
  fld  qword ptr [ecx]               //z,x',zx,f  #4
  fmul qword ptr [esi-$0000008c+$40]
  faddp                              //zx2,zx,f  #3
  fstp qword ptr [esp+$08]           //zx,f  #2    esp8=zx2
  fld  st                            //#3
  fmul qword ptr [esi-$7c+$40]       //zx',zx,f
  fld  qword ptr [edx]               //#4
  fmul qword ptr [esi-$74+$40]       //y',zx',zx,f
  fsubp                              //yzx,zx,f  #3
  fxch                               //zx,yzx,f
  fmul qword ptr [esi-$74+$40]
  fld  qword ptr [edx]               //#4
  fmul qword ptr [esi-$7c+$40]       //y',zx',yzx,f
  faddp                              //yzx2,yzx,f  #3
  fxch
  fld  st                            //yzx,yzx,yzx2,f  #4
  fsub st, st(3)                     //yzx-f,yzx,yzx2,f
  fabs
  fadd st, st(1)                     //abs(yzx-f)+yzx,yzx,yzx2,f
  fxch                               //yzx,abs(yzx-f)+yzx,yzx2,f
  fadd st, st(3)
  fabs                               //abs(yzx+f),abs(yzx-f)+yzx,yzx2,f
  fsubrp                             //abs(yzx+f)-abs(yzx-f)+yzx,yzx2,f
  fld  st                            //ayzxf,ayzxf,yzx2,f    #4
  fmul qword ptr [esi-$7c+$40]       //ayzxf',ayzxf,yzx2,f
  fld  st(2)                         //yzx2,ayzxf',ayzxf,yzx2,f   #5
  fmul qword ptr [esi-$74+$40]
  fsubp                              //ayzxf2,ayzxf,yzx2,f   #4
  fld  st                            //ayzxf2,ayzxf2,ayzxf,yzx2,f  #5
  fmul qword ptr [esi-$0000008c+$40] //ayzxf2',ayzxf2,ayzxf,yzx2,f  #5
  fld  qword ptr [esp+$08]           //zx2,ayzxf2',ayzxf2,ayzxf,yzx2,f  #6
  fmul qword ptr [esi-$00000084+$40] //zx2',ayzxf2',ayzxf2,ayzxf,yzx2,f
  fsubp                              //kk,ayzxf2,ayzxf,yzx2,f  #5
  fxch st(2)                         //ayzxf,ayzxf2,kk,yzx2,f
  fmul qword ptr [esi-$74+$40]       //ayzxf',ayzxf2,kk,yzx2,f
  fxch                               //ayzxf2,ayzxf',kk,yzx2,f
  fxch st(3)                         //yzx2,ayzxf',kk,ayzxf2,f  #5
  fmul qword ptr [esi-$7c+$40]       //yzx2',ayzxf',kk,ayzxf2,f
  faddp                              //ya3,kk,ayzxf2,f #4
  fxch st(2)                         //ayzxf2,kk,ya3,f
  fmul qword ptr [esi-$00000084+$40] //ayzxf2',kk,ya3,f
  fld  qword ptr [esp+$08]           //zx2,ayzxf2',kk,ya3,f  #5
  fmul qword ptr [esi-$0000008c+$40] //zx2',ayzxf2',kk,ya3,f
  faddp                              //za3,kk,ya3,f  #4
  fld  st(2)                         //ya3,za3,kk,ya3,f  #5
  fmul qword ptr [esi-$000000ac+$40] //ya3',za3,kk,ya3,f
  fld  st(1)                         //za3,ya3',za3,kk,ya3,f  #6
  fmul qword ptr [esi-$000000a4+$40] //za3',ya3',za3,kk,ya3,f
  fsubp                              //yz4,za3,kk,ya3,f   #5
  fxch                               //za3,yz4,kk,ya3,f
  fmul qword ptr [esi-$000000ac+$40] //za3',yz4,kk,ya3,f
  fxch st(3)                         //ya3,yz4,kk,za3',f   #5
  fmul qword ptr [esi-$000000a4+$40] //ya3',yz4,kk,za3',f
  faddp st(3), st                    //yz4,kk,jj,f   #4
//  fxch  st(2)                        //jj,kk,yz4,f
//  fstp qword ptr [esp+$08]           //kk,yz4,f   #3   esp8=jj
 // fxch                               //yz4,kk,f
  fld  st                            //yz4,yz4,kk,jj,f   #4
  fmul qword ptr [esi-$9c+$40]       //yz4',yz4,kk,jj,f
  fld  st(2)                         //kk,yz4',yz4,kk,jj,f   #5
  fmul qword ptr [esi-$94+$40]       //kk',yz4',yz4,kk,jj,f
  fsubp                              //ll,yz4,kk,jj,f   #4
  fxch  st(2)                        //kk,yz4,ll,jj,f
  fmul qword ptr [esi-$9c+$40]       //kk',yz4,ll,jj,f
  fxch                               //yz4,kk',ll,jj,f
  fmul qword ptr [esi-$94+$40]       //yz4',kk',ll,jj,f
  faddp                              //mm,ll,jj,f     #3
  fxch                               //ll,mm,jj,f
  fld  st                            //ll,ll,mm,jj,f   #4
  fsub st, st(4)                     //ll',ll,mm,jj,f
  fabs
  fadd st, st(1)                     //ll'',ll,mm,jj,f
  fxch                               //ll,ll'',mm,jj,f
  fadd st, st(4)
  fabs
  fsubrp                             //nn,mm,jj,f
  fld  st                            //nn,nn,mm,jj,f
  fmul qword ptr [esi-$0000009c+$40] //nn',nn,mm,jj,f
  fld  st(2)                         //mm,nn',nn,mm,jj,f   #5
  fmul qword ptr [esi-$00000094+$40] //mm',nn',nn,mm,jj,f
  fsubp                              //oo,nn,mm,jj,f    #4
  fld  st                            //oo,oo,nn,mm,jj,f   #5
  fmul qword ptr [esi-$000000ac+$40] //oo',oo,nn,mm,jj,f
  fld  st(4)//qword ptr [esp+$08]    //jj,oo',oo,nn,mm,jj,f   #6 #7
  fmul qword ptr [esi-$000000a4+$40] //jj',oo',oo,nn,mm,jj,f
  fsubp                              //jo,oo,nn,mm,jj,f   #5
  fld  qword ptr [esi-$00000094+$40] //cf,jo,oo,nn,mm,jj,f
  fmulp st(3), st                    //jo,oo,nn',mm,jj,f   #5      *nn
 // fxch st(2)                         //nn',oo,jo,mm,jj,f
  fxch st(3)                         //mm,oo,nn',jo,jj,f
  fmul qword ptr [esi-$0000009c+$40] //mm',oo,nn',jo,jj,f
  faddp st(2), st                    //oo,mn2,jo,jj,f   #4
  fmul qword ptr [esi-$000000a4+$40] //oo',mn2,jo,jj,f
  fld  qword ptr [esi-$000000ac+$40] //cf2,oo',mn2,jo,jj,f
  fmulp st(4), st                    //oo',mn2,jo,jj',f
  faddp st(3), st                    //mn2,jo,jo2,f
//  fxch                               //mn2,jo,jo2,f
  fxch st(2)                         //jo2,jo,mn2,f
  fld  st                            //jo2,jo2,jo,mn2,f    #5
  fsub st, st(4)                     //
  fabs                               //
  fadd st, st(1)                     //
  fxch
  fadd st, st(4)
  fabs
  fsubrp                             //jj,jo,mn2,f   #4
  mov  eax, [esi-$b0+$40]
  nop
  test eax, $04
  jz   @4e9
  fabs
@4E9:  test eax, $02
  jz   @4fa
  fxch st(1)
  fabs
  fxch st(1)
@4FA:  test eax, $01
  jz   @50b
  fxch st(2)
  fabs
  fxch st(2)
@50B:  fadd qword ptr [esi-$64+$40]
  fld  qword ptr [esi-$5c+$40]       //#5
  faddp st(2), st                    //#4
  fld  qword ptr [esi-$54+$40]       //#5
  faddp st(3), st                    //#4
  fld  st                            //#5
  fmul st, st
  fld  st(2)                         //#6
  fmul st, st
  faddp                              //#5
  fld  st(3)                         //#6
  fmul st, st
  faddp                              //#5
  fmul qword ptr [esi-$6c+$40]
  fcom qword ptr [esi-$20+$40]
  fstsw ax
  shr  ah, 1
  jnb  @547
  fstp st                            //#4
  fld  qword ptr [esi-$18+$40]       //#5
  jmp  @55d
@547:  fld1                          //#6
  fcom st(1)
  fstsw ax
  shr  ah, 1
  jb   @558
  fstp st                            //#5
  fdivr qword ptr [esi-$10+$40]
  jmp  @55d
@558:  fcompp                        //#4
  fld  qword ptr [esi-$10+$40]       //#5
@55D:  fld qword ptr [ecx+$08]       //#6
  fmul st, st(1)
  fstp qword ptr [ecx+$08]           //#5
  fmul st(3), st
  fmul st(2), st
  fmulp                              //#4
  fld  qword ptr [esi-$10+$40]       //#5
  fld  qword ptr [esi-$64+$40]       //#6
  fmul st, st(1)
  fsubp st(2), st                    //#5
  fld  qword ptr [esi-$5c+$40]       //#6
  fmul st, st(1)
  fsubp st(3), st                    //#5
  fmul qword ptr [esi-$54+$40]       //#5
  fsubp st(3), st                    //#4
  fxch st(2)
  fld  st                            //#5
  fmul dword ptr [esi-$44+$40]
  fld  st(2)                         //#6
  fmul dword ptr [esi-$48+$40]
  faddp                              //#5
  fld  st(3)                         //#6
  fmul dword ptr [esi-$4c+$40]
  faddp                              //#5
  fld  st(1)                         //#6
  fmul dword ptr [esi-$2c+$40]
  fld st(3)                          //#7
  fmul dword ptr [esi-$30+$40]
  faddp                              //#6
  fld  st(4)                         //#7
  fmul dword ptr [esi-$34+$40]
  faddp                              //#6
  fxch st(2)
  fmul dword ptr [esi-$38+$40]
  fxch st(3)
  fmul dword ptr [esi-$3c+$40]
  faddp st(3), st                    //#5
  fxch st(3)
  fmul dword ptr [esi-$40+$40]
  mov  esi, [ebp+$08]
  faddp st(2), st                    //#4
  fadd qword ptr [esi+$18]
  fstp qword ptr [ebx]      // ?    //#1
  fadd qword ptr [esi+$20]
  fstp qword ptr [edx]      //x,?   //#2
  fadd qword ptr [esi+$28]
  fstp qword ptr [ecx]      //y,x,? //#3
  fstp st
  add esp, $20
  mov eax,ebx
  pop ebx
  pop esi

  {  push esi       //amazing surf
    push edi
    push ebx
    mov  edi, [ebp+$08]
    mov  ebx, eax
    mov  esi, [edi+$30]
    add  edi, $00000080
    cmp  dword [edi+$50], 0
    jnle @4b
    inc  dword [edi+$50]
    fld  qword [esi-$10]
    fstp qword [edi+$48]
@4b: fld qword [edi+$48]
    fld1
    fld  st(1)
    fabs
    fsubrp
    fmul qword [esi-$54]
    faddp
    fstp qword [edi+$48]  //scale
    fld  qword [esi-$28]  //fold
    fld  qword [ebx]      //x,fold
    fld  st               //x,x,fold
    fsub st, st(2)        //x-fold,x,fold
    fabs
    fadd st, st(1)        //x+abs(x-fold),x,fold
    fxch
    fadd st, st(2)
    fabs
    fsubrp                //x',fold
    fld  qword ptr [edx]
    fld  st(0)
    fsub st, st(3)
    fabs
    fadd st, st(1)
    fxch
    fadd st, st(3)
    fabs
    fsubrp                //y',x',fold
    fst  qword ptr [edx]
    fmul st, st           //yy,x',fold
    fxch st(1)
    fst  qword ptr [ebx]   //x',yy,fold
    fmul st, st
    faddp                 //xx+yy,fold
    fstp st(1)            //xx+yy
    cmp  dword ptr [esi-$58], 0   //sphere / cylinder
    jnz  @9f
    fld  qword ptr [ecx]
    fmul st, st
    faddp                 //xx+yy+zz
@9F: fcom qword ptr [esi-$20]
    fstsw ax
    shr  ah, 1
    jnb  @af
    fstp st
    fld  qword ptr [esi-$18]
    jmp  @3c5
@AF: fld1
    fcom st(1)
    fstsw ax
    shr  ah, 1
    jb   @3c0
    fstp st(0)
    fdivr qword ptr [edi+$48]
    jmp  @3c5
@3C0: fcompp
    fld  qword ptr [edi+$48]
@3C5: fld qword ptr [ecx+$08]  //w,scale'
    fmul st, st(1)
    fstp qword ptr [ecx+$08]
    fld  qword ptr [ecx]       //z,scale'
    fmul st, st(1)
    fadd qword ptr [edi-$58]   //z',scale'
    fld  qword ptr [edx]       //y,z',scale'
    fmul st, st(2)
    fadd qword ptr [edi-$60]   //y',z',scale'
    fld  qword ptr [ebx]
    fmul st, st(3)
    fadd qword ptr [edi-$68]   //x',y',z',scale'
    fld  st
    fmul dword ptr [esi-$44]
    fld  st(2)
    fmul dword ptr [esi-$48]
    faddp
    fld  st(3)
    fmul dword ptr [esi-$4c]
    faddp
    fld  st(1)
    fmul dword ptr [esi-$2c]
    fld  st(3)
    fmul dword ptr [esi-$30]
    faddp
    fld  st(4)
    fmul dword ptr [esi-$34]
    faddp
    fxch st(2)
    fmul dword ptr [esi-$38]
    fxch st(3)
    fmul dword ptr [esi-$3c]
    faddp st(3), st
    fxch st(3)
    fmul dword ptr [esi-$40]
    faddp st(2), st
    fstp qword ptr [ebx]
    fstp qword ptr [edx]
    fstp qword ptr [ecx]
    fstp st
    mov eax, ebx
    pop ebx
    pop edi
    pop esi
//  pop ebp
//  ret $0008

{asm
    push  esi                   //smoothbox lucas     with options  fold  fold x2
    push  edi
    push  ebx
    mov   esi, [ebp + 8]        //PIteration3D
    mov   edi, [esi + 48]       //was:PAligned16
    mov   ebx, eax
    add   esi, $70
    jmp   @3
    nop
    nop
    nop
@intpow:               // eax = exponent
    shr   eax, 1
    jz    @a
    jnc   @0
    fld   st
    jmp   @1
@0: fld1
    fxch               // base, 1(result)
@1: fmul  st, st       // base * base
@2: shr   eax, 1
    jnc   @1
    fmul  st(1), st    //base', result*base'
    jnz   @1
    fstp  st
@a: ret
 //   nop
@sboxfold:             //address of float in eax
    fld   qword [eax]       //x (y or z)
    fabs
    push  eax
    mov   eax, [edi-$34]
    fld   st
    call  @intpow          //x^,x
    pop   eax
    fmul  qword [edi - $3C] //xp,x
    fxch                    //x,xp
    fld   qword [edi - $28] //fold,x,xp
    fadd  st, st            //2*fold,x,xp
    fsub  st, st(1)         //2*fold-x,x,xp
    fmul  st, st(2)         //(2*fold-x)*xp,x,xp
    faddp                   //(2*fold-x)*xp+x,xp
    fld1                    //1,(2*fold-x)*xp+x,xp
    faddp st(2), st         //(2*fold-x)*xp+x,xp+1
    fdivrp                  //(2*fold-x)*xp+x/(1+xp)
    test  byte [eax + 7], $80  //sign bit
    jns   @4
    fchs
@4: ret
    nop
@3: call  @sboxfold
    mov   eax, edx
    call  @sboxfold
    mov   eax, ecx
    call  @sboxfold            //z,y,x
    cmp   dword [esi + $60], 0
    jnle  @5
    inc   dword [esi + $60]
    fld   qword [edi - $10]
    fstp  qword [esi + $58]
@5: fld   qword [esi + $58]
    fld1
    fld   st(1)
    fabs
    fsubrp
    fmul  qword [edi - $30]
    faddp
    fstp  qword [esi + $58]
    fld   qword [edi - $20]
    fcomp qword [edi]   //0.99  cs099 //
    fstsw ax
    shr   ah, 1
    jb    @6
    fld1
    jmp   @7
 //   nop
@6: fld   st(2)
    fmul  st, st
    fld   st(2)
    fmul  st, st
    faddp
    fld   st(1)
    fmul  st, st
    faddp           //rr,z,y,x
    fld1
    fadd  qword [edi - $20]
    fmul  qword [edi - 8]   //0.5*(1+MinR),rr,z,y,x
    fld1
    fsub  qword [edi - $20]
    fmul  qword [edi - 8]  //0.5*(1-MinR),0.5*(1+MinR),rr,z,y,x
    fxch  st(2)            //rr,m,n,z,y,x
    fsub  st, st(1)        //rr-m,m,n,z,y,x
    ftst
    fstsw ax
    push  eax              //sign bit
    fabs
    fdiv  st, st(2)        //r1,m,n,z,y,x
    fld   st               //r1,r1,m,n,z,y,x
    mov   eax, [edi - $40]
    shr   eax, 1
    jnc   @9
    fsqrt
    rcl   eax, 1
@9: call  @intpow
    fmul  qword [edi - $48] //r1^*fixballfold=rp,r1,m,n,z,y,x
    fld1
    fadd  st, st(1)        //rp+1,rp,r1,m,n,z,y,x
    fxch  st(2)
    faddp                  //rp+r1,rp+1,m,n,z,y,x
    fdivrp                 //(rp+r1)/(rp+1),m,n,z,y,x
    pop   eax
    fmulp st(2), st        //m,(rp+r1)/(rp+1)*n,z,y,x
    fxch
    shr   ah, 1
    jnb   @8
    fchs
@8: faddp                  //m+rs*(rp+r1)/(rp+1)*n,z,y,x
@7: fld   qword [esi + $58]//scale,r',z,y,x
    fdivrp                 //scale/r',z,y,x
    fld   qword [ecx + 8]
    fmul  st, st(1)
    fstp  qword [ecx + 8]
    fmul  st(3), st
    fmul  st(2), st
    fmulp
    fadd  qword [esi - $48]
    fstp  qword [ecx]
    fadd  qword [esi - $50]
    fstp  qword [edx]
    fadd  qword [esi - $58]
    fstp  qword [ebx]
    mov   eax, ebx
    pop   ebx
    pop   edi
    pop   esi


{asm
    push  esi                   //Amazing box  x87     with options  fold  fold x2
    push  edi
    mov   esi, [ebp + 8]        //PIteration3D
    mov   edi, [esi + 48]       //was:PAligned16
    fld   qword [ecx]           //x
    fld   qword [edx]
    fld   qword [eax]           //x,y,z
    fld   st
    fmul  qword [edi - 24]
    fld   st(2)
    fmul  qword [edi - 32]
    faddp
    fld   st(3)
    fmul  qword [edi - 40]
    faddp                       //foldx,x,y,z     folding with x = abs(x+fold) - abs(x-fold) - x
    fadd  qword [edi - 16]
    fld   st(1)
    fsub  st, st(1)
    fabs
    fxch                        //foldx,abs(x-fold),x,y,z
    fadd  st, st(2)
    fabs
    fsubrp
    fsub  st, st(1)             //newx,x,y,z
    fld   st(1)
    fmul  qword [edi - 56]
    fld   st(3)
    fmul  qword [edi - 64]
    faddp
    fld   st(4)
    fmul  qword [edi - 72]
    faddp                       //foldy,newx,x,y,z
    fadd  qword [edi - 48]
    fld   st(3)
    fsub  st, st(1)
    fabs
    fxch                        //foldy,abs(y-yfold),newx,x,y,z
    fadd  st, st(4)
    fabs
    fsubrp
    fsub  st, st(3)             //newy,newx,x,y,z
    fxch  st(2)
    fmul  qword [edi - 88]      //x*az,newx,newy,y,z
    fxch  st(3)                 //y,newx,newy,z',z
    fmul  qword [edi - 96]
    faddp st(3), st             //newx,newy,z'',z
    fld   st(3)
    fmul  qword [edi - 104]
    fadd  qword [edi - 80]
    faddp st(3), st             //newx,newy,foldz,z
    fld   st(2)
    fsub  st, st(4)
    fabs                        //abs(z-foldz),newx,newy,foldz,z
    fxch  st(3)                 //foldz,newx,newy,abs(z-foldz),z
    fadd  st, st(4)
    fabs
    fsubrp st(3), st            //newx,newy,abs(z+foldz)-abs(z-foldz),z
    fxch  st(3)
    fsubp st(2), st             //newy,newz,newx
    fstp  qword [edx]
    fstp  qword [ecx]
    fstp  qword [eax]
    pop   edi
    pop   esi  }

//    var xa, ya, za, R, cosPhi, sinPhi, cosTheta, sinTheta, ph, th: Double;
//    var mul, rr: Double;
 //   dSin1, dCos1, dSin2, dCos2, pp: Double;
//    q: TQuaternion;
 //   v1: TVec3D;
//    z1, z2: TComplex;
 //   h, xx,yy,zz,aa,delta: Double;
 //   i, a: Integer;
 //   xyzIn, xyzOut: array[0..2] of Double;
 //   i, i2, i3: Integer;
  //  cxy, czw, cccs, ccsn: TComplex;
//x4,y4,z4,x2,y2,z2,uu,vv: Double;
//const c1d3 : Double = 1/3;  null: Single = 1E-10;
//const complex1dsqrt: TComplex = (-0.5, 0);
//const root2: Single = 1.4142136;
{begin
    with TPIteration3Dext(Integer(PIteration3D) - 56)^ do
    begin
{void circInvert(inout vec3 p, inout float dz, in float r) {
	float l = length(p);
	if (l<r) {
    p*=r*r/(l*l);
    dz*=r*r/(l*l);}
 {vec3 formula(in vec3 a, in vec3 p, inout float dz) {
	if (abs(p.x)<linear_a.x&&abs(p.y)<linear_a.y&&abs(p.z)<linear_a.z)
		nonlinearPull(a,dz,linear_a.x,linear_a.y,linear_a.z);
	wrapBox(a,wrap.x,wrap.y,wrap.z);
	circInvert(a,dz,radius);
	a*=scale; dz*=abs(scale.x);
	rotate(a,dz,angle/180*3.14159265358979323846264); // Ditto?
	a+=p; dz+=1;
	linearPull(a,dz,linear_b.x,linear_b.y,linear_b.z); // ?
  return a;
void linearPull(inout vec3 p, inout float dz, float h, float w, float d) {
	if (abs(p.x)>w&&abs(p.y)>h&&abs(p.z)>d) {
		h*=2; w*=2; d*=2;
		if (p.x<0) p.x+=w;
		else p.x-=w;
		if (p.y<0) p.y+=h;
		else p.y-=h;
    if (p.z<0) p.z+=d;
    else p.z-=d;
void nonlinearPull(inout vec3 p, inout float dz, float h, float w, float d) {
	if (abs(p.x)>w&&abs(p.y)>h&&abs(p.z)>d) {
		h*=2; w*=2; d*=2;
		if (p.x>0) p.x-=w*floor(p.x/w);
		else p.x-=w*ceil(p.x/w);
		if (p.y>0) p.y-=h*floor(p.y/h);
		else p.y-=h*ceil(p.y/h);
   	if (p.z>0) p.z-=d*floor(p.z/d);
   	else p.z-=d*ceil(p.z/d);
          -12     -16       -24      -28       -32        -36        -40    -44
       ('Scale','BoxFold','CFold','NonLin X','NonLin Y','NonLin Z','Lin X','Lin Y',
        'Lin Z','Rotate X','Rotate Y','Rotate Z', nonlinvary,linvary }
      // -48        -52..-84                        -88        -92
 {     if bFirstIt = 0 then
      begin
        PSingle(@Dfree1)^ := PSingle(Integer(PVar) - 28)^;
        PSingle(Integer(@Dfree1) + 4)^ := PSingle(Integer(PVar) - 32)^;
        PSingle(@Dfree2)^ := PSingle(Integer(PVar) - 36)^;
        PSingle(Integer(@Dfree2) + 4)^ := PSingle(Integer(PVar) - 40)^;
        PSingle(@Deriv3)^ := PSingle(Integer(PVar) - 44)^;
        PSingle(Integer(@Deriv3) + 4)^ := PSingle(Integer(PVar) - 48)^;
        Inc(bFirstIt);
      end;

  //    if (abs(J1) < PSingle(@Dfree1)^) and (abs(J2) < PSingle(Integer(@Dfree1) + 4)^) and    //Mandelex
    //     (abs(J3) < PSingle(@Dfree2)^) and (abs(x) > PSingle(@Dfree1)^) and
      if (abs(J1) < x) and (abs(J2) < y) and    //Mandelex
         (abs(J3) < z) and (abs(x) > PSingle(@Dfree1)^) and
         (abs(y) > PSingle(Integer(@Dfree1) + 4)^) and (abs(z) > PSingle(@Dfree2)^) then
      begin //nonlin pull
        PSingle(@Dfree1)^ := PSingle(@Dfree1)^ * PSingle(Integer(PVar) - 88)^;
        PSingle(Integer(@Dfree1) + 4)^ := PSingle(Integer(@Dfree1) + 4)^ * PSingle(Integer(PVar) - 88)^;
        PSingle(@Dfree2)^ := PSingle(@Dfree2)^ * PSingle(Integer(PVar) - 88)^;
        if x > 0 then x := MaxCD(0, x - PSingle(@Dfree1)^ * Trunc(x / PSingle(@Dfree1)^))
                 else x := MinCD(0, x - PSingle(@Dfree1)^ * (1 + Trunc(x / PSingle(@Dfree1)^)));
        if y > 0 then y := MaxCD(0, y - PSingle(Integer(@Dfree1) + 4)^ * Trunc(y / PSingle(Integer(@Dfree1) + 4)^))
                 else y := MinCD(0, y - PSingle(Integer(@Dfree1) + 4)^ * (1 + Trunc(y / PSingle(Integer(@Dfree1) + 4)^)));
        if z > 0 then z := MaxCD(0, z - PSingle(@Dfree2)^ * Trunc(z / PSingle(@Dfree2)^))
                 else z := MinCD(0, z - PSingle(@Dfree2)^ * (1 + Trunc(z / PSingle(@Dfree2)^)));
      end;
      x := abs(x+PSingle(Integer(PVar) - 16)^) - abs(x-PSingle(Integer(PVar) - 16)^) - x;
      y := abs(y+PSingle(Integer(PVar) - 16)^) - abs(y-PSingle(Integer(PVar) - 16)^) - y;
      z := abs(z+PSingle(Integer(PVar) - 16)^) - abs(z-PSingle(Integer(PVar) - 16)^) - z;
      rr := x*x + y*y + z*z;
      if (rr < PDouble(Integer(PVar) - 24)^) then
        rr := (PDouble(Integer(PVar) - 24)^ + s03) / (rr + s03) * PSingle(Integer(PVar) - 12)^ //circ invert + scale
      else rr := PSingle(Integer(PVar) - 12)^;
      x := x * rr;
      y := y * rr;
      z := z * rr;
      w := w * rr;
     //rotate

      if (abs(x) > PSingle(Integer(@Dfree2) + 4)^) and (abs(y) > PSingle(@Deriv3)^) and
         (abs(z) > PSingle(Integer(@Deriv3) + 4)^) then   //lin pull
      begin            //only one value + adjust w to w := w * NewLength(vec) / OldLength(vec);
        PSingle(Integer(@Dfree2) + 4)^ := PSingle(Integer(@Dfree2) + 4)^ * PSingle(Integer(PVar) - 92)^;
        PSingle(@Deriv3)^ := PSingle(@Deriv3)^ * PSingle(Integer(PVar) - 92)^;
        PSingle(Integer(@Deriv3) + 4)^ := PSingle(Integer(@Deriv3) + 4)^ * PSingle(Integer(PVar) - 92)^;
        if x < 0 then x := MinCD(0, x + PSingle(Integer(@Dfree2) + 4)^)
                 else x := MaxCD(0, x - PSingle(Integer(@Dfree2) + 4)^);
        if y < 0 then y := MinCD(0, y + PSingle(@Deriv3)^)
                 else y := MaxCD(0, y - PSingle(@Deriv3)^);
        if z < 0 then z := MinCD(0, z + PSingle(Integer(@Deriv3) + 4)^)
                 else z := MaxCD(0, z - PSingle(Integer(@Deriv3) + 4)^);
      end;

    end;
{      th := ArcTan2(y, x);
      ph := ArcTan2(z, Sqrt(Sqr(x) + Sqr(y)));
      R := Power(Rout, 0.5 * PDouble(Integer(PVar) - 32)^);
      SinCosD(PDouble(Integer(PVar) - 32)^ * ph, sinPhi, cosPhi);
      SinCosD(PDouble(Integer(PVar) - 32)^ * th, sinTheta, cosTheta);
      x := R * cosPhi * cosTheta + J1;
      y := R * cosPhi * sinTheta + J2;
      z := PDouble(Integer(PVar) - 24)^ * R * sinPhi + J3;
      th := ArcTan2(y, x);
      ph := ArcTan2(z, Sqrt(Sqr(x) + Sqr(y)));
      R := Power(Rout, 0.5 * PDouble(Integer(PVar) - 16)^);
      SinCosD(PDouble(Integer(PVar) - 16)^ * ph, sinPhi, cosPhi);
      SinCosD(PDouble(Integer(PVar) - 16)^ * th, sinTheta, cosTheta);
      x := x + R * cosPhi * cosTheta + J1;
      y := y + R * cosPhi * sinTheta + J2;
      z := z + PDouble(Integer(PVar) - 24)^ * R * sinPhi + J3;

    end;
       //David M
    {  R := Sqrt(Rout);
      ya := (1 - Abs(x)) / R * Power(y + z, 5) + 2 * x * z;
      xa := x * x - y * y - z * z + j1;
      y := 2 * x * y + j2;
      z := ya + j3;
      x := xa;
 {     xa := x;
      ya := y;
      za := z;
      Inc(bFirstIt);
      if (bFirstIt and 1) = 0 then
      begin
        x := x * x - y * y + J1;
        y := 2 * xa * y + J2;
    //    z := z + J3;
     end else begin
        x := x * x - z * z + J1;
//        y := y * y - z * z + J2;
    //    y := y + J2;
        z := 2 * xa * z + J3;
     end;    }
{    //other newton triplex
      xa := x;
      ya := y;
      za := z;
      x := x * x - 2 * y * z + J1;
      y := - z * z + 2 * xa * y + J2;
      z := ya * ya + 2 * xa * z + J3;

 {   //asdam slonofractal
      xa := x;
      ya := y;
      za := Abs(z);
      x := x * x - root2 * y * y + 2 * za * x + J1;
      y := 2 * xa * y + 2 * za * y + J2;
      z := z * z - root2 * ya * ya  + Abs(J3);   }
//    end;
   {   v1 := NormaliseVector(@x);
      SinCosD(ArcCos(v1[0]), SinPhi, CosPhi);
      q[0] := 0;
      q[1] := 0;
      q[2] := -v1[1] * SinPhi;
      q[3] := CosPhi;
      QuatRotate(@v1, q);
      InvertQuat(q);
      QuatRotate(@v1, q);
      x := Rout * v1[0] + J1;
      y := Rout * v1[1] + J2;
      z := Rout * v1[2] + J3;

{
      R := Power(Rout, 0.5 * PDouble(Integer(PVar) - 16)^);

      xa := R * cosPhi * cosTheta;
      ya := R * cosPhi * sinTheta;
      za := R * sinPhi * PDouble(Integer(PVar) - 48)^;

      x := xa + J1;
      y := ya + J2;
      z := za + J3;

    {  SinCosD(ph * PDouble(Integer(PVar) - 24)^, sinPhi, cosPhi);
      SinCosD(th * PDouble(Integer(PVar) - 24)^, sinTheta, cosTheta);

      R := Power(Rout, 0.5 * PDouble(Integer(PVar) - 16)^);
      x := R * cosPhi * cosTheta + J1;
      y := R * cosPhi * sinTheta + J2;
      z := R * sinPhi * PDouble(Integer(PVar) - 40)^ + J3; }

//    end;

//asm
  {   th := ArcTan2(y, x);
      ph := ArcTan2(z, Sqrt(Sqr(x) + Sqr(y)));   //  ArcSin(z / R);
      pp := Power(Rout, 0.5 * PDouble(Integer(PVar) - 16)^);
      SinCosD(PDouble(Integer(PVar) - 16)^ * ph, sinPhi, cosPhi);
      SinCosD(PDouble(Integer(PVar) - 16)^ * th, sinTheta, cosTheta);
      x := pp * cosPhi * cosTheta + J1;
      y := pp * cosPhi * sinTheta + J2;
      z := PDouble(Integer(PVar) - 24)^ * pp * sinPhi + J3;
    push esi  //TrifoxComplexAngles 'R intpow','Angle scale','Flip The-Phi (0,1)', 'Angle intpow','Norm R angle (0,1)','Norm fix','Z mul'
    push edi
//    add  esp, -8
    mov  esi, [ebp + 8]        //PIteration3D
    mov  edi, [esi + 48]

     fld1                //    Result := 1
     mov  eax, [edi - 12]  //  Int power
     fld  qword [esi + 56] //Rout
     fsqrt                 //R=base, Result
     jmp  @@2
@@1: fmul st, st            { X := Base * Base
@@2: shr  eax,1
     jnc  @@1
     fmul st(1), st    //B,R*B  { Result := Result * X
     jnz  @@1
     fstp st           //r'

    fldz
    fld1               //1,0,r
    fld  qword [edx - 8]
    fld  qword [edx]
    fld  qword [ecx]   //z,y,x,1,0,r
    fld  st(2)
    fmul st, st        //xx,z,y,x,1,0,r
    fld  st(2)
    fmul st, st        //yy,xx,z,y,x,1,0,r
    faddp
    fsqrt              //sqrt(xx+yy),z,y,x,1,0,r
    fpatan             //phi,y,x,1,0,r
    fxch st(2)         //x,y,phi,1,0,r
    fpatan             //theta,phi, 1,0,r
    fld  dword [edi - 16]
    fmul st(2), st
    fmulp
    cmp  dword [edi - 24], 0
    jz   @@3
    fxch
@@3:
    cmp  dword [edi - 32], 0
    jz   @@7           // reciprocal r angle
    fld  st(1)
    fmul st, st
    fld  st(1)
    fmul st, st
    faddp
    fadd dword [edi - 36]
  //  fsqrt
    fld1
    fdivrp
    fmul st(2), st
    fmulp
@@7:

     mov  eax, [edi - 28]  // int angle pow
     jmp  @@5
@@4: fld  st(1)        //by,bx,by,rx,ry   Base*Base:   st = st*st - st(1)*st(1);  st(1) = 2*st*st(1)
     fmul st, st(1)
     fadd st, st       //2bxby,bx,by,rx,ry
     fxch st(2)        //by,bx,2bxby,rx,ry
     fmul st, st
     fxch
     fmul st, st       //bxbx,byby,2bxby,rx,ry
     fsubrp            
@@5: shr  eax,1
     jnc  @@4
     fld  st(2)        //   R=R*Base:  st(2) = st(2)*st - st(3)*st(1);  st(3) = st(3)*st + st(2)*st(1)
     fmul st, st(1)    //rx*bx,bx,by,rx,ry
     fld  st(4)
     fmul st, st(3)    //ry*by,rx*bx,bx,by,rx,ry
     fsubp             //rx*bx-ry*by,bx,by,rx,ry
     fxch st(3)        //rx,bx,by,rx',ry
     fmul st, st(2)
     fld  st(1)        //bx,rx*by,bx,by,rx',ry
     fmulp st(5), st   //rx*by,bx,by,rx',ry*bx
     faddp st(4), st   //bx,by,rx',ry*bx+rx*by
     jnz  @@4
     fcompp            //theta',phi', r

{const s3: Single = 3;
asm                            //GenIntPower on Pixelpos: R1type on Px pos, R2type on Py pos
     push esi                  //variable int rotations 2-11    RotType: 0:x|y 1:x|z 2:y|z 3:xy|z 4:xz|y 5:yz|x
     push edi                  //Rpower,Rot1 pow,type, EnableRot2,Rot2 pow,type, EnableRot3, Rot3 pow,type,  Zmul  = 10 paras
     push ebx                  //  -12   -16      -20     -24       -28     -32       -36     -40     -44    -52(double)
     mov  esi, [ebp + 8]       //const: [edi] int64, int64 xor mask, double 1.0
     mov  edi, [esi + 48]
  //   movapd  xmm6, [edi]
     xorpd   xmm6, xmm6
     movhpd  xmm6, [edi + 80]
     add  esp, -16
     fld1
     fadd st, st
     fld  qword [esi + 16]  //Pz,2
     fabs
     fmul s3
     faddp
     fistp dword [esp]
     fld  qword [esi]      //Px
     fabs
     fadd st, st
     fistp dword [esp + 4]     //type 0..11
     fld  qword [esi + 8]      //Py
     fabs
     fadd st, st
     fistp dword [esp + 8]     //type 0..11


     movupd  xmm0, [eax]        //x,y    calc R
     movsd   xmm5, [ecx]
     mulpd   xmm0, xmm0
     mulsd   xmm5, xmm5
db   $66,$0F,$7C,$C0            //haddpd  xmm0, xmm0
     addsd   xmm5, xmm0
     movsd   xmm2, [edi + 32]   //1.0
     sqrtsd  xmm1, xmm5         //Rin, sqr(Rin)
     divsd   xmm2, xmm1         //1/Rin
     mov  edx, [esp]            //int     Rpower
     cmp  edx, 4
     jl   @2
     movsd   xmm3, xmm5
     mulsd   xmm5, xmm5         //r^4
     cmp  edx, 8
     jl   @1
     mulsd   xmm5, xmm5         //r^8
     cmp  edx, 10
     jl   @2
     jmp  @3
@1:  cmp  edx, 6
     jl   @2
@3:  mulsd   xmm5, xmm3         //*r²
@2:  shr  edx, 1
     jnc  @up
     mulsd   xmm5, xmm1
@up:
     unpcklpd xmm2, xmm2
     movupd  xmm0, [eax]
     movsd   xmm1, [ecx]
     mulpd   xmm0, xmm2
     movsd   [eax + 8], xmm5
     mulsd   xmm1, xmm2         //norm input vec
     mov  edx, [esp]            //int rot1 pow
     mov  ebx, [esp + 4]        //int rot1 type
     call @rotate
     cmp  [edi - 24], 0
     jz   @@skipr2
     mov  edx, [esp]            //int rot2 pow
     mov  ebx, [esp + 8]        //int rot2 type
     call @rotate
@@skipr2:
     cmp  [edi - 36], 0
     jz   @@fin
     mov  edx, [edi - 40]       //int rot3 pow
     mov  ebx, [edi - 44]       //int rot3 type
     call @rotate
@@fin:
     mov  esi, [ebp + 8]
     movsd   xmm5, [eax + 8]
     movupd  xmm3, [esi + 24]   //J1,J2
     unpcklpd xmm5, xmm5
     mulsd   xmm1, xmm5
     mulpd   xmm0, xmm5         //scale output vec
     mulsd   xmm1, [edi - 52]
     addpd   xmm0, xmm3
     addsd   xmm1, [esi + 40]
     movupd  [eax], xmm0
     movsd   [ecx], xmm1
     add  esp, 16
     pop  ebx
     pop  edi
     pop  esi
     pop  ebp
     ret  8

@rotate:            //ecx = type  0:x|y  1:x|z  2:y|z  3:xy|z  4:xz|y  5:yz|x      call @CINTPOW  xmm0 + edx pow
     xor  esi, esi
     cmp  ebx, 6
     jl   @@ud
     add  esi, 1
     sub  ebx, 6
@@ud:
     cmp  ebx, 3
     jl   @2dr
     sub  ebx, 4
     jns  @u4
     movapd  xmm5, xmm0  //rottype 3    xy|z       xmm0 Lo = Rxy,  xmm0 Hi = z
     mulpd   xmm0, xmm0
db   $66,$0F,$7C,$C0     //haddpd  xmm0, xmm0  $C0 + $38 + $07 first xmm reg + second xmm reg 0-7
     sqrtsd  xmm0, xmm0  //Rxy
     movsd   [ecx], xmm0
     unpcklpd xmm0, xmm1 //xmm1 Lo to xmm0 Hi -> Rxy,z
     call @CINTPOW
     movapd  xmm1, xmm0  //Rxy',z'
     divsd   xmm0, [ecx] //Rxy'/Rxy  change of x,y
     unpcklpd xmm0, xmm0
     unpckhpd xmm1, xmm1 //z back to xmm1 Lo
     mulpd   xmm0, xmm5  //scale x,y  by Rxy'/Rxy
     ret
@u4:    //rottype 4    xz|y
     sub  ebx, 1
     jns  @u5
     movhpd  [eax], xmm0 //y    rottype 4    xz|y
     unpcklpd xmm0, xmm1 //x,z
     movapd  xmm5, xmm0
     mulpd   xmm0, xmm0
db   $66,$0F,$7C,$C0     //haddpd  xmm0, xmm0  $C0 + $38 + $07 first xmm reg + second xmm reg 0-7
     sqrtsd  xmm0, xmm0  //Rxz
     movsd   [ecx], xmm0
     movhpd  xmm0, [eax] //xmm1 Lo to xmm0 Hi -> Rxz,y
     call @CINTPOW
     movapd  xmm1, xmm0  //Rxz',y'
     divsd   xmm0, [ecx] //Rxz'/Rxz
     unpcklpd xmm0, xmm0
     mulpd   xmm0, xmm5  //scale x,z
     unpckhpd xmm1, xmm0 //y,z
     unpcklpd xmm0, xmm1 //x',y'
     unpckhpd xmm1, xmm1 //z
     ret
@u5:    //rottype 5    yz|x
     movsd   [eax], xmm0 //x
     unpcklpd xmm1, xmm1
     unpckhpd xmm0, xmm1 //y,z
     movapd  xmm5, xmm0
     mulpd   xmm0, xmm0
db   $66,$0F,$7C,$C0     //haddpd  xmm0, xmm0  $C0 + $38 + $07 first xmm reg + second xmm reg 0-7
     sqrtsd  xmm0, xmm0  //Ryz
     movsd   [ecx], xmm0
     movhpd  xmm0, [eax] //xmm1 Lo to xmm0 Hi -> Ryz,x
     call @CINTPOW
     movapd  xmm1, xmm0  //Ryz',x'
     divsd   xmm1, [ecx] //Ryz'/Ryz
     unpcklpd xmm1, xmm1
     mulpd   xmm1, xmm5  //scale y,z
     unpckhpd xmm0, xmm0 //x,x
     unpcklpd xmm0, xmm1 //x,y
     unpckhpd xmm1, xmm1 //z
     ret
@2dr:   //norm 2d vec: 0:x|y 1:x|z 2:y|z  to 1 and call pow   xmm5=xmm5/(R3d*Rvec2d)  vec3d=vec3d/Rvec2d   R3d=xmm2
     sub  ebx, 1
     jns  @u1
     movapd  xmm3, xmm0   //rottype 0  x|y
     mulpd   xmm3, xmm3
db   $66,$0F,$7C,$DB      //haddpd  xmm3, xmm3  $C0 + $38 + $07 first xmm reg + second xmm reg 0-7
     sqrtsd  xmm5, xmm3   //Rxy
     movsd   xmm4, [edi + 32]    //1.0
     divsd   xmm4, xmm5   //1/Rvec2D
     unpcklpd xmm4, xmm4
     unpcklpd xmm5, xmm5
     movsd   [ecx], xmm1  //save Z
     mulpd   xmm0, xmm4   //norm xy
     call @CINTPOW
     movsd   xmm1, [ecx]
     mulpd   xmm0, xmm5   //scale back to vec3 norm
     ret
@u1: sub  ebx, 1
     jns  @u2
     movhpd  [ecx], xmm0  //y     rottype 1   x|z
     unpcklpd xmm0, xmm1  //x,z
     movapd  xmm3, xmm0
     mulpd   xmm3, xmm3
db   $66,$0F,$7C,$DB      //haddpd  xmm3, xmm3
     sqrtsd  xmm5, xmm3   //Rxz
     movsd   xmm4, [edi + 32]    //1.0
     divsd   xmm4, xmm5   //1/Rvec2D
     unpcklpd xmm4, xmm4
     unpcklpd xmm5, xmm5
     mulpd   xmm0, xmm4   //norm xz
     call @CINTPOW
     mulpd   xmm0, xmm5   //scale back x,z
     pshufd  xmm1, xmm0, $4E   //z
     movhpd  xmm0, [ecx]  //x,y
     ret
@u2:   // rottype 2   y|z
     movsd   [ecx], xmm0  //x
     unpckhpd xmm0, xmm0  //y,y
     unpcklpd xmm0, xmm1  //y,z
     movapd  xmm3, xmm0
     mulpd   xmm3, xmm3
db   $66,$0F,$7C,$DB      //haddpd  xmm3, xmm3
     sqrtsd  xmm5, xmm3   //Ryz
     movsd   xmm4, [edi + 32]    //1.0   +16 in m3f!
     divsd   xmm4, xmm5   //1/Rvec2D
     unpcklpd xmm4, xmm4
     unpcklpd xmm5, xmm5
     mulpd   xmm0, xmm4   //norm yz
     call @CINTPOW
     mulpd   xmm0, xmm5   //scale back y,z
     pshufd  xmm1, xmm0, $4E   //z
     unpcklpd xmm0, xmm0  //y,y
     movlpd  xmm0, [ecx]  //x,y
     ret

@CINTPOW:  //comlex power of xmm0, edx contains exponent   new option: flip x|y
     cmp  esi, 0
     jz  @@u1
     shufpd  xmm0, xmm0, 1
@@u1:
     movapd  xmm1, xmm0
     call @CMUL
     cmp  edx, 2
     jle  @@ex
     movapd  xmm3, xmm1          //z
     cmp  edx, 4
     jl   @@2
     movapd  xmm4, xmm0          //z²
     movapd  xmm1, xmm0
     call @CMUL                  //z^4
     cmp  edx, 8
     jl   @@1
     movapd  xmm1, xmm0
     call @CMUL                  //z^8
     cmp  edx, 10
     jl   @@2
     jmp  @@3
@@1: //<8
     cmp  edx, 6
     jl   @@2
@@3:
     movapd  xmm1, xmm4
     call @CMUL
@@2: //<4
     shr  edx, 1
     jnc  @@ex
     movapd  xmm1, xmm3
     call @CMUL
@@ex:
     cmp  esi, 0
     jz  @@u2
     shufpd  xmm0, xmm0, 1
@@u2:
     ret
@CMUL:           // xmm0 * xmm1 = xmm0 (x1,y1)*(x2,y2)=(x,y) (real=lo,imag=hi) xmm1 stays intact for further multiplications
     pshufd  xmm2, xmm0, $4E     //y1,x1
     mulpd   xmm0, xmm1          //x1*x2,y1*y2
     mulpd   xmm2, xmm1          //y1*x2,x1*y2
     xorpd   xmm0, xmm6          //x1*x2,-y1*y2
db   $66,$0F,$7C,$C2 //haddpd xmm0, xmm2 //x1*x2-y1*y2,y1*x2+x1*y2  SSE3   $C0 + $38 + $07 first xmm reg + second xmm reg 0-7
     ret


     //Aexion HeartBox
   {   x := abs(x+PDouble(Integer(PVar) - 40)^) - abs(x-PDouble(Integer(PVar) - 40)^) - x;
      y := abs(y+PDouble(Integer(PVar) - 40)^) - abs(y-PDouble(Integer(PVar) - 40)^) - y;
      z := abs(z+PDouble(Integer(PVar) - 40)^) - abs(z-PDouble(Integer(PVar) - 40)^) - z;
      xx := x*x;
      yy := y*y;
      zz := z*z;
      aa := 2*xx + yy + zz - 1;
      h := (aa*aa*aa - 0.1 * xx * zz * z - yy * zz * z) * PDouble(Integer(PVar) - 48)^; //0.0005
      r := Sqrt((xx + yy + zz) * h); //-sqrt(r*h);//reverse it
      if r < PDouble(Integer(PVar) - 32)^ then r := PDouble(Integer(PVar) - 24)^ else
      if r < 1 then r := PDouble(Integer(PVar) - 16)^ / r
               else r := PDouble(Integer(PVar) - 16)^;
      x := r * x + J1;
      y := r * y + J2;
      z := r * z + J3;
      w := r * w;

   //David new complex:
 {   //  r := x*x + y*y + z*z + w*w;
      cxy[0] := x;
      cxy[1] := y;
      czw[0] := z;
      czw[1] := w;
      cccs := ComplexPower(CConj(ComplexAdd(ComplexSqr2(cxy), ComplexSqr2(czw))), complex1dsqrt);
      ccsn := ComplexMul(czw, cccs);
      cccs := ComplexMul(cxy, cccs);
      cxy := ComplexScale(ComplexSub(Complexsqr2(cccs), ComplexSqr2(ccsn)), Rout);
      czw := ComplexScale(ComplexMul(cccs, ccsn), 2 * Rout);
      x := cxy[0] + J1;
      y := PDouble(Integer(PVar) - 16)^ * cxy[1] + J2;
      z := PDouble(Integer(PVar) - 24)^ * czw[0] + J3;
      w := czw[1] + J4;

         //knighty smoothbox
  {   x := Sqrt(PDouble(Integer(PVar) - 24)^ + Sqr(x + 1)) - Sqrt(PDouble(Integer(PVar) - 24)^ + Sqr(x - 1)) - x;
      y := Sqrt(PDouble(Integer(PVar) - 24)^ + Sqr(y + 1)) - Sqrt(PDouble(Integer(PVar) - 24)^ + Sqr(y - 1)) - y;
      z := Sqrt(PDouble(Integer(PVar) - 24)^ + Sqr(z + 1)) - Sqrt(PDouble(Integer(PVar) - 24)^ + Sqr(z - 1)) - z;
      r := Sqrt(x*x + y*y + z*z + 1e-80);
      k := 3 * r - 2;
      r := PDouble(Integer(PVar) - 16)^ * ((k*k*k - k + 6) ) / ((k*k + 1) + (r * 0.7 / (r + 1)) ) / (3 * r);
      x := r * x + J1;
      y := r * y + J2;
      z := r * z + J3;
      w := w * (Abs(r) * 0.9 + 0.2);  

    {  if bFirstIt = 0 then  //Aexion chrystalbox
      begin
        Inc(bFirstIt);
        x := abs(J3) - PDouble(Integer(PVar) - 32)^;
        y := abs(0.86602540378443864676372317075294*J1-0.5*J3) - PDouble(Integer(PVar) - 32)^;
        z := abs(-0.86602540378443864676372317075294*J1-0.5*J3) - PDouble(Integer(PVar) - 32)^;
        w := abs(J2) - PDouble(Integer(PVar) - 32)^;
        J1 := x;
        J2 := y;
        J3 := z;
        J4 := w;
        x := 0;
        y := 0;
        z := 0;
        w := 0;
      end;
      x := abs(x+PDouble(Integer(PVar) - 24)^) - abs(x-PDouble(Integer(PVar) - 24)^) - x;
      y := abs(y+PDouble(Integer(PVar) - 24)^) - abs(y-PDouble(Integer(PVar) - 24)^) - y;
      z := abs(z+PDouble(Integer(PVar) - 24)^) - abs(z-PDouble(Integer(PVar) - 24)^) - z;
      w := abs(w+PDouble(Integer(PVar) - 24)^) - abs(w-PDouble(Integer(PVar) - 24)^) - w;
      vm := abs(x) + abs(y) + abs(z) + abs(w); //sqrt(x*x+y*y+z*z+w*w);
      if (vm < 0.05) then
      begin
        x := x*4;
        y := y*4;
        z := z*4;
        w := w*4;
      end         //1.5
      else if (vm < 1) then
      begin
        vsq := 1 / vm*vm*vm;
        x := x * vsq;
        y := y * vsq;
        z := z * vsq;
        w := w * vsq;
      end;
      x := PDouble(Integer(PVar) - 16)^ * x + J1;
      y := PDouble(Integer(PVar) - 16)^ * y + J2;
      z := PDouble(Integer(PVar) - 16)^ * z + J3;
      w := PDouble(Integer(PVar) - 16)^ * w + J4;
      Deriv1 := Deriv1 * PDouble(Integer(PVar) - 16)^;  }

 {//  nHybrid:    array[0..5] of Integer;  //+76    conditional ItCounts
      if PInteger(Integer(PVar) - 56)^ = 0 then
        r := PDouble(Integer(PVar) - 16)^ * x + PDouble(Integer(PVar) - 24)^ * y +
             PDouble(Integer(PVar) - 32)^ * z + PDouble(Integer(PVar) - 40)^
      else
        r := PDouble(Integer(PVar) - 16)^ * C1 + PDouble(Integer(PVar) - 24)^ * C2 +
             PDouble(Integer(PVar) - 32)^ * C3 + PDouble(Integer(PVar) - 40)^;

      i2 := PInteger(Integer(PVar) - 52)^;
      if i2 < 0 then i2 := 0 else
      if i2 > 99999 then i2 := 99999;
      i3 := 0;
      if r < 0 then
      begin
        i3 := i2;
        i2 := 0;
      end;
      i := PInteger(Integer(PVar) - 44)^;
      if i < 1 then i := 1 else
      if i > 6 then i := 6;
      if PInteger(Integer(PIteration3D) + 72 + i shl 2)^ < 0 then
        PInteger(Integer(PIteration3D) + 72 + i shl 2)^ := i2 or $80000000
      else
        PInteger(Integer(PIteration3D) + 72 + i shl 2)^ := i2;
      i := PInteger(Integer(PVar) - 48)^;
      if i < 1 then i := 1 else
      if i > 6 then i := 6;
      if PInteger(Integer(PIteration3D) + 72 + i shl 2)^ < 0 then
        PInteger(Integer(PIteration3D) + 72 + i shl 2)^ := i3 or $80000000
      else
        PInteger(Integer(PIteration3D) + 72 + i shl 2)^ := i3;   }

//Its a 4th power lambdabulb with a seed of 1.0625 + i*0.2375 with shadows. The function is z = c*(z-z^p)
   {   if bFirstIt = 0 then
      begin
        Inc(bFirstIt);
        Dfree1 := Sqrt(J1*J1 + J2*J2 + J3*J3);
        if Dfree1 < 1e-60 then Dfree2 := 0 else
        Dfree2 := ArcSin(J3 / Dfree1);
        Deriv2 := ArcTan2(J2, J1);
      end;

      r := Sqrt(Rout);
      ph := ArcTan2(y, x) * PDouble(Integer(PVar) - 16)^;
      th := ArcSin(z / r) * PDouble(Integer(PVar) - 16)^;
      r1 := Power(r, PDouble(Integer(PVar) - 16)^);
      SinCosD(ph, Sx, Cx);
      SinCosD(th, Sy, Cy);
      xa := x - (Cx * Cy * r1);
      ya := y - (Sx * Cy * r1);
      za := z - (Sy * r1);

      r1 := Sqrt(xa*xa + ya*ya + za*za);
      ph := ArcTan2(ya, xa) + Deriv2;
      th := ArcSin(za / r1) + Dfree2;  //+
      r := r1 * Dfree1;
      SinCosD(ph, Sx, Cx);
      SinCosD(th, Sy, Cy);
      x := Cx * Cy * r;
      y := Sx * Cy * r;
      z := Sy * r;  }

{
m := 1/Sqrt(x*x + y*y);  //normalize vec(x,y)
x := x*m;
y := y*m;
z := z*m;
ipow2(x,y);     //rotate vec(x,y), radius=1 is unchanged

m := 1/Sqrt(x*x + y*y + z*z);  //normalize vec(x,y,z)
x := x*m;
y := y*m;
z := z*m;
m := Sqrt(x*x + y*y);    //length of vec(x,y)
mt := m;
ipow2(m,z);     //rotate vec(z,|vec(x,y)|)

m := m/mt*R;
x := x * m + J1;
y := y * m + J2;
z := z * R + J3;  }


 {  r := Sqrt(Rout);
   r1 := PDouble(Integer(PVar) - 16)^ * r / Sqrt(Sqr(x) + Sqr(y) + 1e-40);        //infpoles
   phi := r1 * ArcSin(z / r);
   theta := r1 * ArcTan2(y, x);
   SinCosD(phi, Sx, Cx);
   SinCosD(theta, Sz, Cz);
   r := Power(r, r1);
   x := r * Cz * Cx + J1;
   y := r * Sz * Cx + J2;
   z := r * Sx * PDouble(Integer(PVar) - 24)^ + J3;

   //Menger4d
{   x := abs(x);
   y := abs(y);
   z := abs(z);
   w := abs(w);
   if x<y then begin r:=x; x:=y; y:=r; end;
   if x<z then begin r:=x; x:=z; z:=r; end;
   if x<w then begin r:=x; x:=w; w:=r; end;
   if y<z then begin r:=y; y:=z; z:=r; end;
   if y<w then begin r:=y; y:=w; w:=r; end;
   if z<w then begin r:=z; z:=w; w:=r; end;
   //rotate4d
   Rotate4D(@x, TPSMatrix4(Integer(PVar) - 88));
   r := PDouble(Integer(PVar) - 16)^;
   Deriv1 := Deriv1 * r;
   x := x*r - (r-1);
   y := y*r - (r-1);
   w := w*r + PDouble(Integer(PVar) - 24)^;
   r1 := 0.5*(r-1)/r;
   z := (-abs(z - r1) + r1) * r;  }

   {   R  := Sqrt(Rout);        //FloatP with derivatives
      th := ArcTan2(y, x);
      ph := ArcSin(z / R);
      pp := Power(R, PDouble(Integer(PVar) - 16)^);

      if bFirstIt = 0 then
      begin
        bFirstIt := 1;        // derivatives
        thd := 0;
        phd := 0;
        ppd := 1;
      end else begin
        thd := ArcTan2(Deriv2, Deriv1);    // derivatives
        phd := ArcSin(Deriv3 / RoutDeriv);
        ppd := Power(R, PDouble(Integer(PVar) - 16)^ - 1);
      end;
      SinCosD(phd + (PDouble(Integer(PVar) - 16)^ - 1) * ph, Sx, Cx);
      SinCosD(thd + (PDouble(Integer(PVar) - 16)^ - 1) * th, Sy, Cy);
      R2 := PDouble(Integer(PVar) - 16)^ * Power(R, PDouble(Integer(PVar) - 16)^ - 1) * RoutDeriv;
      Deriv1 := R2 * Cx * Cy + 1;
      Deriv2 := R2 * Cx * Sy;
      Deriv3 := R2 * Sx;
      RoutDeriv := Sqrt(Deriv1 * Deriv1 + Deriv2 * Deriv2 + Deriv3 * Deriv3);

      SinCosD(PDouble(Integer(PVar) - 16)^ * ph, Sx, Cx);
      SinCosD(PDouble(Integer(PVar) - 16)^ * th, Sy, Cy);
      x := pp * Cx * Cy + J1;
      y := pp * Cx * Sy + J2;
      z := PDouble(Integer(PVar) - 24)^ * pp * Sx + J3;   }

end;

procedure doInterpolHybridPas(PIteration3D: TPIteration3D); //interpolate between 2 formulas. nHybrid[n] is single-weight
var X1, Y1: TVec4D;                                         //new ext version
    XX, YY: Double;  
    S1, S2: Single;
begin
    with TPIteration3Dext(Integer(PIteration3D) - 56)^ do
    begin
      if DoJulia then mCopyVec(@J1, @JU1) else mCopyVec(@J1, @C1);
      mCopyVec(@x, @C1);
      w := 0;
      Rout  := x * x + y * y + z * z;
      OTrap := Rout;
      bFirstIt  := 0;
      ItResultI := 0;
      S1 := PSingle(@nHybrid[0])^;
      S2 := PSingle(@nHybrid[1])^;
      repeat
        Rold := Rout;
        mCopyVec4(@Y1, @x);
        PVar := fHPVar[0];
        fHybrid[0](x, y, z, w, PIteration3D);
        mCopyVec4(@x1, @x);
        mCopyVec4(@x, @Y1);
        PVar := fHPVar[1];
        fHybrid[1](x, y, z, w, PIteration3D);
        XX := Sqrt(Sqr(x1[0]) + Sqr(x1[1]) + Sqr(x1[2]));
        YY := Sqrt(x * x + y * y + z * z);
        XX := XX * S1 + YY * S2;
        x := x1[0] * S1 + x * S2;
        y := x1[1] * S1 + y * S2;
        z := x1[2] * S1 + z * S2;
        w := x1[3] * S1 + w * S2;
        YY := XX / Sqrt(x * x + y * y + z * z + 1e-40);
        x := x * YY;
        y := y * YY;
        z := z * YY;
        Inc(ItResultI);
        Rout := XX * XX;
        if Rout < OTrap then OTrap := Rout;
      until
        (ItResultI >= maxIt) or (Rout > RStop);
      if CalcSIT then CalcSmoothIterations(PIteration3D, 0);
    end;
end;

procedure doInterpolHybridSSE2(PIteration3D: TPIteration3D);   // new ext version 
asm
  push  eax
  push  ebx                  
  push  ecx
  push  edx                  
  push  esi
  push  edi                   //x = edi-32  y = edi-24 ..  Rold = edi - 48, Rstop = edi - 40, (i = edi + 212 = btmp = esi - 44)
  add   esp, -72
  mov   edi, eax              //was: Rold = esp, Rstop = esp + 8, aligned16: esp + 16,  X1 = a16  X2 = a16+8..  Y1 = a16+32 ..
  lea   esi, eax + 256
  mov   eax, esp
  add   eax, 35
  and   eax, $FFFFFFF0
  mov   [esp], eax            // aligned 16 Ybuf    aligned16: esp,  X1 = a16.. = Y1 =  (aligned)
  cvtps2pd xmm7, [edi + 76]   //nHybrid[0] +76  weights in double for s1,s2 (lo,hi part)
  movupd  xmm0, [edi]
  movsd   xmm1, [edi + 16]
  movupd  [edi - 32], xmm0    //xyz=C
  movupd  [edi - 16], xmm1
  cmp   dword [esi - 104], 0  //DoJulia:+152
  jz    @sjup
  movupd  xmm2, [esi + 64]
  movsd   xmm3, [esi + 80]
  movupd  [edi + 24], xmm2    //J=Ju
  movsd   [edi + 40], xmm3
  jmp   @skipIfJulia
@sjup:
  movupd  [edi + 24], xmm0    //J=C
  movsd   [edi + 40], xmm1
@skipIfJulia:
  mulpd   xmm0, xmm0
  mulsd   xmm1, xmm1
  CVTSS2SD xmm5, [edi + 72]   //RStop in double
  addsd   xmm1, xmm0
  unpckhpd  xmm0, xmm0
  movsd   [edi - 40], xmm5
  addsd   xmm1, xmm0
  xor   ebx, ebx
  movsd   [esi - 64], xmm1    //OTrap=Rout
  movsd   [edi + 56], xmm1    //Rout
  mov   [esi - 48], ebx       //bFirstIt  := 0; +208
  mov   [edi + 64], ebx       //ItresultI :=0   +64

@Repeat:
  movsd   xmm2, [edi + 56]
  mov   ebx, [edi + 100]      //fHPVar[0] +100
  mov   eax, [esp]
  mov   [edi + 48], ebx       //PVars:    +48
  movsd   [edi - 48], xmm2    //Rold := Rout

  movupd  xmm0, [edi - 32]    //Y:=xyz
  movupd  xmm1, [edi - 16]
  movapd  [eax], xmm0
  movapd  [eax + 16], xmm1

  lea   eax, edi - 32         // x
  lea   edx, edi - 24         // y
  lea   ecx, edi - 16         // z
  lea   ebx, edi - 8          // w
  push  ebx
  push  edi
  call  [edi + 124]           //fHybrid[0] of ThybridIteration2

  mov   eax, [esp]
  movupd  xmm0, [edi - 32]        //    mCopyVec4(@x1, @x);
  movupd  xmm1, [edi - 16]        //   mCopyVec4(@x, @Y1);
  movapd  xmm2, [eax]
  movapd  xmm3, [eax + 16]
  movapd  [eax], xmm0
  movapd  [eax + 16], xmm1
  movupd  [edi - 32], xmm2    //xyz=Y1
  movupd  [edi - 16], xmm3

  mov   ebx, [edi + 104]      //fHPVar[1]
  mov   [edi + 48], ebx       //PVars:    +48
  lea   eax, edi - 32         // x
  lea   edx, edi - 24         // y
  lea   ecx, edi - 16         // z
  lea   ebx, edi - 8          // w
  push  ebx
  push  edi
  call  [edi + 128]           //fHybrid[1] of ThybridIteration2

  mov   eax, [esp]
  movupd  xmm0, [edi - 32]    //x,y   was: y1
  movapd  xmm2, [eax]         //x[0,1]
  movupd  xmm1, [edi - 16]    //z,w
  movapd  xmm3, [eax + 16]    //x[2,3]
  movapd  xmm5, xmm0          //x,y
  movapd  xmm6, xmm2          //x[0,1]
  mulpd   xmm0, xmm0          //x²,y²
  mulpd   xmm2, xmm2          //x[0]²,x[1]²
  mulsd   xmm1, xmm1          //z²,w
  mulsd   xmm3, xmm3          //x[2]²
  addsd   xmm1, xmm0          //z²+x²
  addsd   xmm3, xmm2          //x[2]²+x[0]²
  unpckhpd xmm0, xmm0         //y²
  unpckhpd xmm2, xmm2         //x[1]²
  addsd   xmm1, xmm0          //x²+y²+z²
  addsd   xmm3, xmm2          //x[0]²+x[1]²+x[2]²
  unpcklpd xmm3, xmm1         //x[0]²+x[1]²+x[2]²,x²+y²+z²
  sqrtpd  xmm0, xmm3          //xx,yy
  mulpd   xmm0, xmm7          //xx*s1,yy*s2
  pshufd  xmm2, xmm0, $4E
  addsd   xmm0, xmm2          //XX = xx*s1+yy*s2
  pshufd  xmm3, xmm7, $4E     //wy
  movsd   xmm2, xmm7          //wx
  unpcklpd xmm3, xmm3         //s2,s2
  unpcklpd xmm2, xmm2         //s1,s1
  movupd  xmm1, [edi - 16]    //z,w
  mulpd   xmm5, xmm3          //x,y *s2
  mulpd   xmm6, xmm2          //x[0,1] *s1
  mulpd   xmm3, xmm1          //z,w *s2
  mulpd   xmm2, [eax + 16]    //x[2,3] *s1
  addpd   xmm5, xmm6          //x,y
  addpd   xmm3, xmm2          //z,w

  movapd  xmm4, xmm5          //x,y
  movsd   xmm2, xmm3          //z
  mulpd   xmm4, xmm4          //x²,y²
  mulsd   xmm2, xmm2          //z²      4D:  mulpd
  addsd   xmm2, xmm4          //z²+x²   4D: addpd ...
  unpckhpd xmm4, xmm4         //y²
  addsd   xmm4, xmm2          //x²+y²+z²
  addsd   xmm4, d1em40
  sqrtsd  xmm4, xmm4

  movsd   xmm2, xmm0          //XX
  divsd   xmm2, xmm4          //YY := XX / Sqrt(x * x + y * y + z * z + 1e-40);
  unpcklpd xmm2, xmm2         //YY,YY
  mulpd   xmm5, xmm2
  mulsd   xmm3, xmm2
  movupd  [edi - 32], xmm5    //x,y
  movupd  [edi - 16], xmm3    //z,w
  mulsd   xmm0, xmm0
  movsd   [edi + 56], xmm0    //Rout := XX * XX;
  movsd   xmm1, xmm0
  inc   dword [edi + 64]      //Inc(ItResultI)
  minsd   xmm0, [esi - 64]
  movsd   [esi - 64], xmm0    //OTrap := Min(Rout, OTrap);

  mov   eax, [edi + 64]
  cmp   eax, [edi + 68]       //maxIt: +68
  jnl   @out
  comisd  xmm1, [edi - 40]    //RStop
  jc    @Repeat
@out:
  cmp   byte [esi - 108], 0  //CalcSIT: +148
  jz    @NoCalcSITout

  mov   eax, edi
  xor   edx, edx
  call  CalcSmoothIterations //(PIt3D: TPIteration3D; n: Integer);
@NoCalcSITout:
  add   esp, 72
  pop   edi
  pop   esi
  pop   edx
  pop   ecx
  pop   ebx
  pop   eax
end;

function doInterpolHybridPasDE(PIteration3D: TPIteration3D): Double;
var X1, Y1: TVec4D;                                     
    XX, YY: Double;  
    S1, S2: Single;
begin
    with TPIteration3Dext(Integer(PIteration3D) - 56)^ do
    begin
      if DoJulia then mCopyVec(@J1, @JU1) else mCopyVec(@J1, @C1);
      mCopyVec(@x, @C1);
      Rout  := x * x + y * y + z * z;
      OTrap := Rout;
      if (DEoption and $18) = 16 then w := Rout else w := 1;
      S1 := PSingle(@nHybrid[0])^;
      S2 := PSingle(@nHybrid[1])^;
      bFirstIt  := 0;
      ItResultI := 0;
      repeat
        Rold := Rout;
        mCopyVec4(@Y1, @x);
        PVar := fHPVar[0];
        fHybrid[0](x, y, z, w, PIteration3D);
        mCopyVec4(@x1, @x);
        mCopyVec4(@x, @Y1);
        PVar := fHPVar[1];
        fHybrid[1](x, y, z, w, PIteration3D);
        XX := Sqrt(Sqr(x1[0]) + Sqr(x1[1]) + Sqr(x1[2]));
        YY := Sqrt(x * x + y * y + z * z);
        XX := XX * S1 + YY * S2;
        x := x1[0] * S1 + x * S2;
        y := x1[1] * S1 + y * S2;
        z := x1[2] * S1 + z * S2;
        w := Abs(x1[3]) * S1 + Abs(w) * S2;
        YY := XX / Sqrt(x * x + y * y + z * z + 1e-40);
        x := x * YY;
        y := y * YY;
        z := z * YY;
        Inc(ItResultI);
        Rout := XX * XX;
        if Rout < OTrap then OTrap := Rout;
      until
        (ItResultI >= maxIt) or (Rout > RStop);

      case DEoption and 7 of
        4: Result := Abs(z) * Ln(Abs(z)) / w; //Julia?
        7: Result := Sqrt(Rout / RStop) * Power(PDouble(Integer(PVar) - 16)^, -ItResultI);    //Pvar does only work for single formula
      else Result := Sqrt(Rout) / Abs(w);   //AmBox + IFS
      end;     // distance = 0.5 * r * log(r) / r_dz;  for analytical powers!

      if CalcSIT then CalcSmoothIterations(PIteration3D, 0);
    end;
end;

function doInterpolHybridDESSE2(PIteration3D: TPIteration3D): Double;   // new ext version
asm
  push  eax
  push  ebx                  
  push  ecx
  push  edx                  
  push  esi
  push  edi                   //x = edi-32  y = edi-24 ..  Rold = edi - 48, Rstop = edi - 40, i = edi + 212 = btmp = esi - 44
  add   esp, -72
  mov   edi, eax              //was: Rold = esp, Rstop = esp + 8, aligned16: esp + 16,  X1 = a16  X2 = a16+8..  Y1 = a16+32 ..
  lea   esi, eax + 256
  mov   eax, esp
  add   eax, 35              
  and   eax, $FFFFFFF0
  mov   [esp], eax            // aligned 16 Ybuf    aligned16: esp,  X1 = a16.. = Y1 =  (aligned)
  cvtps2pd xmm7, [edi + 76]   //nHybrid[0] +76  weights in double for s1,s2 (lo,hi part)
  movupd  xmm0, [edi]
  movsd   xmm1, [edi + 16]
  movupd  [edi - 32], xmm0    //xyz=C
  movupd  [edi - 16], xmm1
  cmp   dword [esi - 104], 0  //DoJulia:+152
  jz    @sjup
  movupd  xmm2, [esi + 64]
  movsd   xmm3, [esi + 80]
  movupd  [edi + 24], xmm2    //J=Ju
  movsd   [edi + 40], xmm3
  jmp   @skipIfJulia
@sjup:
  movupd  [edi + 24], xmm0    //J=C
  movsd   [edi + 40], xmm1
@skipIfJulia:
  mulpd   xmm0, xmm0
  mulsd   xmm1, xmm1
  CVTSS2SD xmm5, [edi + 72]   //RStop in double
  addsd   xmm1, xmm0
  unpckhpd  xmm0, xmm0
  movsd   [edi - 40], xmm5
  addsd   xmm1, xmm0
  xor   ebx, ebx
  movsd   [esi - 64], xmm1    //OTrap=Rout
  movsd   [edi + 56], xmm1    //Rout
  mov   [esi - 48], ebx       //bFirstIt  := 0; +208
  mov   [edi + 64], ebx       //ItresultI :=0   +64

  mov   eax, [esi - 96]       //DEoption +160
  and   eax, $18
  sub   eax, 16
  jnz   @UU1
  fld   qword [edi + 56]
  jmp   @UU2
@UU1:
  fld1
@UU2:  
  fstp  qword [edi - 8]       // if (DEoption and $18) = 16 then w := Rout  else w := 1;

@Repeat:
  movsd   xmm2, [edi + 56]
  mov   ebx, [edi + 100]      //fHPVar[0] +100
  mov   eax, [esp]
  mov   [edi + 48], ebx       //PVars:    +48
  movsd   [edi - 48], xmm2    //Rold := Rout

  movupd  xmm0, [edi - 32]    //Y:=xyz
  movupd  xmm1, [edi - 16]
  movapd  [eax], xmm0
  movapd  [eax + 16], xmm1

  lea   eax, edi - 32         // x
  lea   edx, edi - 24         // y
  lea   ecx, edi - 16         // z
  lea   ebx, edi - 8          // w
  push  ebx
  push  edi
  call  [edi + 124]           //fHybrid[0] of ThybridIteration2

  mov   eax, [esp]
  movupd  xmm0, [edi - 32]        //    mCopyVec4(@x1, @x);
  movupd  xmm1, [edi - 16]        //   mCopyVec4(@x, @Y1);
  movapd  xmm2, [eax]
  movapd  xmm3, [eax + 16]
  movapd  [eax], xmm0
  movapd  [eax + 16], xmm1
  movupd  [edi - 32], xmm2    //xyz=Y1
  movupd  [edi - 16], xmm3

  mov   ebx, [edi + 104]      //fHPVar[1]
  mov   [edi + 48], ebx       //PVars:    +48
  lea   eax, edi - 32         // x
  lea   edx, edi - 24         // y
  lea   ecx, edi - 16         // z
  lea   ebx, edi - 8          // w
  push  ebx
  push  edi
  call  [edi + 128]           //fHybrid[1] of ThybridIteration2

  mov   eax, [esp]
  movupd  xmm0, [edi - 32]    //x,y   was: y1
  movapd  xmm2, [eax]         //x[0,1]
  movupd  xmm1, [edi - 16]    //z,w
  movapd  xmm3, [eax + 16]    //x[2,3]
  movapd  xmm5, xmm0          //x,y
  movapd  xmm6, xmm2          //x[0,1]
  mulpd   xmm0, xmm0          //x²,y²
  mulpd   xmm2, xmm2          //x[0]²,x[1]²
  mulsd   xmm1, xmm1          //z²,w
  mulsd   xmm3, xmm3          //x[2]²
  addsd   xmm1, xmm0          //z²+x²
  addsd   xmm3, xmm2          //x[2]²+x[0]²
  unpckhpd xmm0, xmm0         //y²
  unpckhpd xmm2, xmm2         //x[1]²
  addsd   xmm1, xmm0          //x²+y²+z²
  addsd   xmm3, xmm2          //x[0]²+x[1]²+x[2]²
  unpcklpd xmm3, xmm1         //x[0]²+x[1]²+x[2]²,x²+y²+z²
  sqrtpd  xmm0, xmm3          //xx,yy
  mulpd   xmm0, xmm7          //xx*s1,yy*s2
  pshufd  xmm2, xmm0, $4E
  addsd   xmm0, xmm2          //XX = xx*s1+yy*s2
  pshufd  xmm3, xmm7, $4E     //wy
  movsd   xmm2, xmm7          //wx
  unpcklpd xmm3, xmm3         //s2,s2
  unpcklpd xmm2, xmm2         //s1,s1
  movupd  xmm1, [edi - 16]    //z,w
  mulpd   xmm5, xmm3          //x,y *s2
  mulpd   xmm6, xmm2          //x[0,1] *s1
  mulpd   xmm3, xmm1          //z,w *s2
  mulpd   xmm2, [eax + 16]    //x[2,3] *s1
  addpd   xmm5, xmm6          //x,y
  addpd   xmm3, xmm2          //z,w

  movapd  xmm4, xmm5          //x,y
  movsd   xmm2, xmm3          //z
  mulpd   xmm4, xmm4          //x²,y²
  mulsd   xmm2, xmm2          //z²      4D:  mulpd
  addsd   xmm2, xmm4          //z²+x²   4D: addpd ...
  unpckhpd xmm4, xmm4         //y²
  addsd   xmm4, xmm2          //x²+y²+z²
  addsd   xmm4, d1em40
  sqrtsd  xmm4, xmm4

  movsd   xmm2, xmm0          //XX
  divsd   xmm2, xmm4          //YY := XX / Sqrt(x * x + y * y + z * z + 1e-40);
  unpcklpd xmm2, xmm2         //YY,YY
  mulpd   xmm5, xmm2
  mulsd   xmm3, xmm2
  movupd  [edi - 32], xmm5    //x,y
  movupd  [edi - 16], xmm3    //z,w
  mulsd   xmm0, xmm0
  movsd   [edi + 56], xmm0    //Rout := XX * XX;
  movsd   xmm1, xmm0
  inc   dword [edi + 64]      //Inc(ItResultI)
  minsd   xmm0, [esi - 64]
  movsd   [esi - 64], xmm0    //OTrap := Min(Rout, OTrap);

  mov   eax, [edi + 64]
  cmp   eax, [edi + 68]       //maxIt: +68
  jnl   @out
  comisd  xmm1, [edi - 40]    //RStop
  jc    @Repeat
@out:
  mov   eax, [esi - 96]       //DEoption +160
  and   eax, 7
  sub   eax, 4       
  jnz   @UU3     //Result := Abs(z) * Ln(Abs(z)) / w;
  fld   qword [edi - 16]
  fabs
  fldln2
  fld   st(1)
  fyl2x
  fmulp
  fdiv  qword [edi - 8]   //Result
  jmp   @UU6
@UU3:
  sub   eax, 3                           //  / intPower faster?
  jnz   @UU4   //Result := Sqrt(Rout/RStop) * Power(PDouble(Integer(PVar) - 16)^, -ItResultI);
  mov   eax,  [edi + 48]
  fild  dword [edi + 64]  //ItResultI
  fchs              //-ItresultI
  fld   qword [eax - 16]  //(Pvar-16)^ (= scale or something)
  fldln2      //power function  base,expo  -> st, st(1)
  fxch
  fyl2x
  fxch
  fmulp
  fldl2e
  fmulp
  fld   st(0)
  frndint
  fsub  st(1), st(0)
  fxch
  f2xm1
  fld1
  faddp
  fscale
  fstp  st(1) //end of power function
  fld   qword [edi + 56]
  fdiv  dword [edi + 72] //rout/rstop,pow
  fsqrt
  fmulp
  jmp   @UU6
@UU4:          // else Result := Sqrt(Rout) / Abs(w);
  fld   qword [edi + 56]
  fsqrt
  fld   qword [edi - 8]
  fabs
  fdivp
@UU6:

  cmp   byte [esi - 108], 0  //CalcSIT: +148
  jz    @NoCalcSITout

  mov   eax, edi
  xor   edx, edx
  call  CalcSmoothIterations //(PIt3D: TPIteration3D; n: Integer);

@NoCalcSITout:
  add   esp, 72
  pop   edi
  pop   esi
  pop   edx
  pop   ecx
  pop   ebx
  pop   eax
end;

procedure doInterpolHybridPas4D(PIteration3D: TPIteration3D);
var X1, Y1: TVec4D;                                     
    XX, YY: Double;  
    S1, S2: Single;
begin
    with TPIteration3Dext(Integer(PIteration3D) - 56)^ do
    begin
      Rotate4Dex(@C1, @x, @SMatrix4);
      if DoJulia then
      begin
        mCopyVec(@J1, @JU1);
        J4 := Ju4;
      end
      else
      begin
        mCopyVec(@J1, @x);
        J4 := w;
      end;
      Rout := x*x + y*y + z*z + w*w;
      OTrap := Rout;
      bFirstIt := 0;
      ItResultI := 0;
      S1 := PSingle(@nHybrid[0])^;
      S2 := PSingle(@nHybrid[1])^;
      repeat
        Rold := Rout;
        mCopyVec4(@Y1, @x);
        PVar := fHPVar[0];
        fHybrid[0](x, y, z, w, PIteration3D);
        mCopyVec4(@x1, @x);
        mCopyVec4(@x, @Y1);
        PVar := fHPVar[1];
        fHybrid[1](x, y, z, w, PIteration3D);
        XX := Sqrt(Sqr(x1[0]) + Sqr(x1[1]) + Sqr(x1[2]) + Sqr(x1[3]));
        YY := Sqrt(x*x + y*y + z*z + w*w);
        XX := XX * S1 + YY * S2;
        x := x1[0] * S1 + x * S2;
        y := x1[1] * S1 + y * S2;
        z := x1[2] * S1 + z * S2;
        w := x1[3] * S1 + w * S2;
        YY := XX / Sqrt(x*x + y*y + z*z + w*w + 1e-40);
        x := x * YY;
        y := y * YY;
        z := z * YY;
        w := w * YY;
        Inc(ItResultI);
        Rout := XX * XX;
        if Rout < OTrap then OTrap := Rout;
      until
        (ItResultI >= maxIt) or (Rout > RStop);
      if CalcSIT then CalcSmoothIterations(PIteration3D, 0);
    end;
end;

function doInterpolHybridPas4DDE(PIteration3D: TPIteration3D): Double;
var X1, Y1: TVec4D;                                     
    XX, YY, DT, DD: Double;
    S1, S2: Single;
begin
    with TPIteration3Dext(Integer(PIteration3D) - 56)^ do
    begin
      Rotate4Dex(@C1, @x, @SMatrix4);
      if DoJulia then
      begin
        mCopyVec(@J1, @JU1);
        J4 := Ju4;
      end
      else
      begin
        mCopyVec(@J1, @x);
        J4 := w;
      end;
      Rout := x*x + y*y + z*z + w*w;
      OTrap := Rout;
      bFirstIt := 0;
      ItResultI := 0;
      case (DEoption and $38) of
        16:  Deriv1 := Rout;
        32:  begin Deriv1 := 1; Deriv2 := 0; Deriv3 := 0; end;
      else Deriv1 := 1;
      end;
      S1 := PSingle(@nHybrid[0])^;
      S2 := PSingle(@nHybrid[1])^;
      repeat
        Rold := Rout;
        mCopyVec4(@Y1, @x);
        DT := Deriv1;
        PVar := fHPVar[0];
        fHybrid[0](x, y, z, w, PIteration3D);
        mCopyVec4(@x1, @x);
        mCopyVec4(@x, @Y1);
        DD := Deriv1;
        Deriv1 := DT;
        PVar := fHPVar[1];
        fHybrid[1](x, y, z, w, PIteration3D);
        XX := Sqrt(Sqr(x1[0]) + Sqr(x1[1]) + Sqr(x1[2]) + Sqr(x1[3]));
        YY := Sqrt(x*x + y*y + z*z + w*w);
        XX := XX * S1 + YY * S2;
        x := x1[0] * S1 + x * S2;
        y := x1[1] * S1 + y * S2;
        z := x1[2] * S1 + z * S2;
        w := x1[3] * S1 + w * S2;
        Deriv1 := Abs(DD) * S1 + Abs(Deriv1) * S2;
        YY := XX / Sqrt(x*x + y*y + z*z + w*w + 1e-40);
        x := x * YY;
        y := y * YY;
        z := z * YY;
        w := w * YY;
        Inc(ItResultI);
        Rout := XX * XX;
        if Rout < OTrap then OTrap := Rout;
      until
        (ItResultI >= maxIt) or (Rout > RStop);
      case DEoption and 7 of                      //and 38 = 32...
        4: Result := Abs(z) * Ln(Abs(z)) / Deriv1;
        7: Result := Sqrt(Rout / RStop) * Power(PDouble(Integer(PVar) - 16)^, -ItResultI);    //Pvar does only work for single formula
      else Result := Sqrt(Rout) / Abs(Deriv1);   //AmBox4D + IFS4D         //  / Intpower?
      end;
      if CalcSIT then CalcSmoothIterations(PIteration3D, 0);
    end;
end;

function doHybridIFS3D(PIteration3D: TPIteration3D): Double;  
asm
    push  eax
    push  ebx
    push  ecx
    push  edx
    push  esi
    push  edi                   //x = esi-128  y = esi-120 .. btmp = esi+116  (eax+212)
    lea   esi, eax + 88         
    movupd  xmm0, [eax]         
    movsd   xmm1, [eax + 16]
    movupd  [eax - 32], xmm0    //X=Cx
    movsd   [eax - 16], xmm1
    lea   edx, esi + 128
    cmp   dword [esi + 64], 0   //DoJulia:+152
    jz    @sjup
    movupd  xmm0, [edx + 104]   //J=Ju  +320  -88=+232 -128=104
    movsd   xmm1, [edx + 120]
@sjup:
    movupd  [eax + 24], xmm0    //J=C
    movsd   [eax + 40], xmm1
@skipIfJulia:
    xor   ebx, ebx              //n:=0
    mov   eax, [esi + 296]
    mov   [esi + 120], ebx      //bFirstIt  := 0; +208
    mov   [esi - 24], ebx       //ItresultI:=0   +64
    mov   [esi - 36], eax       //bIsInsideRender tmp in SmothIts
    movzx ebx, word [esi + 102]
    fldz
    fld   d65535                //minDE ini
    fld1
    fstp  qword [esi + 112]     //VaryScale: //+200  absScale, must be changed in formulas
    fstp  qword [esi + TIteration3Dext.OTrap - 144]    // 104 OTrap: Double;  //+192  min of AbsScale
    fstp  qword [edx + TIteration3Dext.Dfree1 - 144 - 128]  //+248 +56
    mov   edi, [esi + ebx * 4 + 12]       //fHPVar[0] +100
    mov   ecx, [esi + ebx * 4 - 12]       //i:=nHybrid[0] +76
    and   ecx, $7FFFFFFF      
@Repeat:
    cmp   ecx, 0
    jnle  @up2
@While:
    inc   ebx
    cmp   bx, word [esi + 62]   //5  wEndTo: Word; //+150
    jle   @up3
    movzx ebx, word [esi + 100]       //n := iRepeatFrom //+188
@up3:
    mov   ecx, [esi + ebx * 4 - 12]   //i := nHybrid[n];  +76
    and   ecx, $7FFFFFFF
    jle   @While
    mov   edi, [esi + ebx * 4 + 12]  //fHPVar:array[0..5] of Pointer; //+100
@up2:
    call  [esi + ebx * 4 + 36]  //fHybrid[0..5] of ThybridIteration2; //+124
    dec   ecx                   //Dec(i)
    cmp   [esi + ebx * 4 - 12], 0
    jl    @Repeat
    movsd xmm0, [esi - 32]      //DEout relative; Rout: Double;     //+56
    inc   dword [esi - 24]      //Inc(ItResultI)  //+64
    divsd xmm0, [esi + 112]     //abs Scale  VaryScale:  Double;  //+200
    mov   eax, [esi - 24]
    ucomisd xmm0, [esi + 104]   // memorize the smallest DE for itresult
    jnc   @skip
    lea   edx, esi + 104
    mov   [esi + 124], eax      //  bTmp:       Integer;    //+212
    fld   qword [edx + TIteration3Dext.Dfree1 - 144-104]  //+128
    movsd [edx], xmm0           //result DE output
    fstp  qword [edx + TIteration3Dext.Dfree2 - 144-104]  //+136
    cmp   dword [esi - 36], 0   //was: +384  -88=296 bIsInsideRender
    js    @skip                 //if outside, compare if DE is lower than minDE
    ucomisd xmm0, [esi - 128]   //compare with RstopD, that contains the DEstop condition. Stop if nearer.
    jc    @out
@skip:
    cmp   eax, [esi - 20]       //maxIt: +68
    jl    @Repeat
@out:
    fild  dword [esi + 124]
    mov   eax, [esi + 124]      //it on minDE
    fstp  dword [esi - 36]      //SmoothItD:  Single;     //+52
    mov   [esi - 24], eax       //ItResultI
    add   esi, 104
    fld   qword [esi]           //MinDE in OTrap
    fld   qword [esi + 32]      //Dfree2
    fstp  qword [esi]           //OTrap
    pop   edi
    pop   esi
    pop   edx
    pop   ecx
    pop   ebx
    pop   eax
end;

function doHybridIFS3DnoVecIni(PIteration3D: TPIteration3D): Double; //to use behind common fractals, use the new vec for it
asm
    push  eax
    push  ebx
    push  ecx
    push  edx
    push  esi
    push  edi                   //x = esi-128  y = esi-120 .. btmp = esi+116  (eax+212)
    lea   esi, eax + 88         //
    xor   ebx, ebx              //n:=0
    mov   eax, [esi + 296]
    mov   [esi + 120], ebx      //bFirstIt  := 0; +208
    mov   [esi + 124], ebx
    mov   [esi - 24], ebx       //ItresultI:=0   +64
    mov   [esi - 36], eax       //bIsInsideRender tmp in SmothIts
    movzx ebx, word [esi + 102]       //n := iStartFrom
    fldz
    fld   d65535                //minDE ini
    fld1
    fstp  qword [esi + 112]     //VaryScale: //+200  absScale, must be changed in formulas
    fstp  qword [esi + TIteration3Dext.OTrap - 144]    // 104 OTrap: Double;  //+192  min of AbsScale
    fstp   qword [esi + TIteration3Dext.Dfree1 - 144]   //+248 +56
  //  fstp  qword [esi + TIteration3Dext.Dfree2 - 144]   //+248 +56
    mov   edi, [esi + ebx * 4 + 12]       //fHPVar[0] +100
    mov   ecx, [esi + ebx * 4 - 12]       //i:=nHybrid[n] +76
    and   ecx, $7FFFFFFF
@Repeat:
    cmp   ecx, 0
    jnle  @up2
@While:
    inc   ebx
    cmp   bx, word [esi + 62]   //5  wEndTo: Word; //+150
    jle   @up3
    movzx ebx, word [esi + 100]       //n := iRepeatFrom //+188
@up3:
    mov   ecx, [esi + ebx * 4 - 12]   //i := nHybrid[n];  +76
    and   ecx, $7FFFFFFF
    jle   @While
    mov   edi, [esi + ebx * 4 + 12]  //fHPVar:array[0..5] of Pointer; //+100
@up2:
    call  [esi + ebx * 4 + 36]  //fHybrid[0..5] of ThybridIteration2; //+124
    dec   ecx                   //Dec(i)
    cmp   [esi + ebx * 4 - 12], 0
    jl    @Repeat
    movsd xmm0, [esi - 32]      //DEout relative; Rout: Double;     //+56
    inc   dword [esi - 24]      //Inc(ItResultI)  //+64
    divsd xmm0, [esi + 112]     //abs Scale  VaryScale:  Double;  //+200
    mov   eax, [esi - 24]
    ucomisd xmm0, [esi + 104]   // memorize the smallest DE for itresult
    jnc   @skip
    lea   edx, esi + 104
    mov   [esi + 124], eax      //  bTmp:       Integer;    //+212
    fld   qword [edx + TIteration3Dext.Dfree1 - 144-104]  //+128   otrap color option
    movsd [edx], xmm0           //result DE output
    fstp  qword [edx + TIteration3Dext.Dfree2 - 144-104]  //+136
    cmp   dword [esi - 36], 0   //was: +384  -88=296 bIsInsideRender
    jne   @skip                 //if outside, compare if DE is lower than minDE
    ucomisd xmm0, [esi - 128]   //compare with RstopD, that contains the DEstop condition. Stop if nearer.
    jc    @out
@skip:
    cmp   eax, [esi - 20]       //maxIt: +68
    jl    @Repeat
@out:
    fild  dword [esi + 124]
    mov   eax, [esi + 124]      //it on minDE
    fstp  dword [esi - 36]      //SmoothItD:  Single;     //+52
    mov   [esi - 24], eax       //ItResultI
    add   esi, 104
    fld   qword [esi]           //MinDE in OTrap
    fld   qword [esi + 32]      //Dfree2
    fstp  qword [esi]           //OTrap
    pop   edi
    pop   esi
    pop   edx
    pop   ecx
    pop   ebx
    pop   eax
end;     

procedure CalcSmoothIterations(PIt3D: TPIteration3D; n: Integer);
{var d: Double;
begin
    if PIt3D.Rout <= 1 then
      PIt3D.SmoothItD := PIt3D.ItResultI
    else if PIt3D.Rold < 1 then
      PIt3D.SmoothItD := PIt3D.ItResultI + PIt3D.LNRStop - Ln(0.5 * Ln(PIt3D.Rout)) * PIt3D.fHln[n]
    else
    begin
      d := Ln(0.5 * Ln(PIt3D.Rout));
      PIt3D.SmoothItD := PIt3D.ItResultI + (PIt3D.LNRStop - d) / (d - Ln(0.5 * Ln(PIt3D.Rold)));
    end; // }
asm
    add  eax, $34
    cmp  dword [eax + TIteration3D.Rout + 4 - $34], $3FF00000 //Rout <= 1? [Rout+4]  //+$3c    cmp with $3FF0.. does not work always!!!
    jg   @@1
    fild dword [eax + TIteration3D.ItResultI - $34]  //+$40
    fstp dword [eax + TIteration3D.SmoothItD - $34]  //+$34
    ret
@@1:
    fld  qword [eax + TIteration3D.Rout - $34]           //+$38  Rout
    cmp  dword [eax + TIteration3Dext.Rold - 56 + 4 - $34], $3FF00000 //Rold <= 1?   -$2c
    jnb  @@2
    fldln2
    fxch       //Rout,ln
    fyl2x
    fmul s05   //ln(Rout)*0.5
    fldln2
    fxch
    fyl2x
    fmul dword [eax + edx * 4 + TIteration3D.fHln - $34]  // PIt3D.fHln[n]  +$00a4
    fild dword [eax + TIteration3D.ItResultI - $34]       //+$40
    fadd dword [eax + TIteration3D.LNRStop - $34]         //+$009c
    fsubrp
    fstp dword [eax + TIteration3D.SmoothItD - $34]       //+$34
    ret
@@2:
    fldln2
    fxch
    fyl2x                  //ln(Rout)
    fmul s05
    fldln2
    fxch
    fyl2x                  //d
    fldln2                 //ln2,d
    fld  qword [eax + TIteration3Dext.Rold - 56 - $34] //Rold,ln2,d
    fyl2x
    fmul s05
    fldln2
    fxch
    fyl2x
    fsubr st, st(1)       //d - Ln(0.5 * Ln(PIt3D.Rold)), d
    fld  dword [eax + TIteration3D.LNRStop - $34]       //+$009c
    fsubrp st(2), st      //d - Ln(0.5 * Ln(PIt3D.Rold)), PIt3D.LNRStop - d
    fadd d1em100   //test
    fdivp                                                    //div0 sometimes
    fiadd dword [eax + TIteration3D.ItResultI - $34]    //+$40
    fstp dword [eax + TIteration3D.SmoothItD - $34]     //+$34
end;

procedure doHybridPas(PIteration3D: TPIteration3D);   //new ext version
var n: Integer;
begin
    with TPIteration3Dext(Integer(PIteration3D) - 56)^ do
    begin
      if DoJulia then mCopyVec(@J1, @JU1) else mCopyVec(@J1, @C1);
      mCopyVec(@x, @C1);
      w     := 0;
      Rout  := x * x + y * y + z * z;
      OTrap := Rout;
      n     := iStartFrom;
      bTmp  := nHybrid[n] and $7FFFFFFF;
      PVar  := fHPVar[n];
      bFirstIt  := 0;
      ItResultI := 0;
      repeat
        Rold := Rout;
        while bTmp <= 0 do
        begin
          Inc(n);
          if n > EndTo then n := iRepeatFrom;
          bTmp := nHybrid[n] and $7FFFFFFF;
          if bTmp > 0 then PVar := fHPVar[n];
        end;
        fHybrid[n](x, y, z, w, PIteration3D);
        Dec(bTmp);
        if nHybrid[n] < 0 then Continue else
        begin
          Inc(ItResultI);
          Rout := x * x + y * y + z * z;
          if Rout < OTrap then OTrap := Rout;
        end;
      until (ItResultI >= maxIt) or (Rout > RStop);
      if CalcSIT then CalcSmoothIterations(PIteration3D, n);
    end;
end;

function doHybrid4DDEPas(PIteration3D: TPIteration3D): Double;
var n: Integer;
begin
    with TPIteration3Dext(Integer(PIteration3D) - 56)^ do
    begin
      Rotate4Dex(@C1, @x, @SMatrix4);
      if DoJulia then
      begin
        mCopyVec(@J1, @JU1);
        J4 := Ju4;
      end
      else
      begin
        mCopyVec(@J1, @x);
        J4 := w;
      end;
      Rout := x*x + y*y + z*z + w*w;
      case (DEoption and $38) of
        16:  Deriv1 := Rout;
        32:  begin Deriv1 := 1; Deriv2 := 0; Deriv3 := 0; end;
      else Deriv1 := 1;
      end;
      OTrap := Rout;
      n     := iStartFrom;
      bTmp  := nHybrid[n] and $7FFFFFFF;
      PVar  := fHPVar[n];
      bFirstIt  := 0;
      ItResultI := 0;
      repeat
        Rold := Rout;
        while bTmp <= 0 do
        begin
          Inc(n);
          if n > EndTo then n := iRepeatFrom;
          bTmp := nHybrid[n] and $7FFFFFFF;
          if bTmp > 0 then PVar := fHPVar[n];
        end;
        fHybrid[n](x, y, z, w, PIteration3D);   //todo: parse 3d DEs deriv1 to w and back
        Dec(bTmp);
        if nHybrid[n] >= 0 then
        begin
          Inc(ItResultI);
          Rout := (x * x + y * y + z * z + w * w);
          if Rout < OTrap then OTrap := Rout;
        end;
      until
        (ItResultI >= maxIt) or (Rout > RStop);
      case DEoption and 7 of
        4: Result := Abs(z) * Ln(Abs(z)) / Deriv1;
        7: Result := Sqrt(Rout / RStop) * Power(PDouble(Integer(PVar) - 16)^, -ItResultI);    //Pvar does only work for single formula
      else Result := Sqrt(Rout) / Abs(Deriv1);   //AmBox4D + IFS4D
      end;
      if CalcSIT then CalcSmoothIterations(PIteration3D, n);
    end;
end;


procedure doHybrid4DPas(PIteration3D: TPIteration3D);    
var n: Integer;
begin
    with TPIteration3Dext(Integer(PIteration3D) - 56)^ do
    begin      //eax, edx, ecx
      Rotate4Dex(@C1, @x, @SMatrix4);
      if DoJulia then
      begin
        mCopyVec(@J1, @JU1);
        J4 := Ju4;
      end
      else
      begin
        mCopyVec(@J1, @x);
       // w := w + dWadd4dstep;  //test: 4d projection, stepping with w add parameter
        J4 := w; 
      end;
      Rout  := x*x + y*y + z*z + w*w;
      OTrap := Rout;
      n     := iStartFrom;
      bTmp  := nHybrid[n] and $7FFFFFFF;
      PVar  := fHPVar[n];
      bFirstIt  := 0;
      ItResultI := 0;
      repeat
        Rold := Rout;
        while bTmp <= 0 do
        begin
          Inc(n);
          if n > EndTo then n := iRepeatFrom;
          bTmp := nHybrid[n] and $7FFFFFFF;
          if bTmp > 0 then PVar := fHPVar[n];
        end;
        fHybrid[n](x, y, z, w, PIteration3D);
        Dec(bTmp);
        if nHybrid[n] >= 0 then
        begin
          Inc(ItResultI);              //test: abs( + + - ); minkowski
          Rout := x * x + y * y + z * z + w * w;
          if Rout < OTrap then OTrap := Rout;
        end;
      until
        (ItResultI >= maxIt) or (Rout > RStop);
      if CalcSIT then CalcSmoothIterations(PIteration3D, n);
    end;
end;

procedure doHybrid4DSSE2(PIteration3D: TPIteration3D);  //new ext version
asm
  push  eax
  push  ebx
  push  ecx
  push  edx
  push  esi
  push  edi                   //x = edi-32  y = edi-24 ..  Rold = edi - 48, Rstop = edi - 40, i = edi + 212 = btmp = esi - 44
  mov   edi, eax
  lea   esi, eax + 256

  lea   edx, edi -32
  mov   ecx, esi
  call  Rotate4Dex            //(@C1, @x, SMatrix4);   C1=It3D=eax

  movupd  xmm6, [edi - 32]
  movupd  xmm7, [edi - 16]
  cmp   dword [esi - 104], 0  //DoJulia:+152
  jz    @sjup
  movupd  xmm2, [esi + 64]
  movupd  xmm3, [esi + 80]
  movupd  [edi + 24], xmm2    //J=Ju
  movlpd  [edi + 40], xmm3
  movhpd  [edi - 56], xmm3    
  jmp   @skipIfJulia
@sjup:
  movupd  [edi + 24], xmm6    //J=C
  movlpd  [edi + 40], xmm7
  movhpd  [edi - 56], xmm7    //J4 = edi - 56
@skipIfJulia:
  mulpd   xmm6, xmm6
  mulpd   xmm7, xmm7
  CVTSS2SD xmm5, [edi + 72]   //RStop in double
  addpd   xmm7, xmm6
  pshufd  xmm6, xmm7, $4E
  movsd   [edi - 40], xmm5
  addsd   xmm7, xmm6          //xmm7=Rout
  movsd   [esi - 64], xmm7    //OTrap=Rout
  movsd   [edi + 56], xmm7    //Rout
  xor   ebx, ebx              //n:=0
  mov   [esi - 48], ebx       //bFirstIt  := 0; +208
  mov   [edi + 64], ebx       //ItresultI:=0   +64
  movzx ebx, word [esi - 66]  //n:=iStartFrom
  mov   eax, [edi + ebx * 4 + 100]      //fHPVar[0] +100
  mov   [edi + 48], eax       //PVars:    +48
  mov   eax, [edi + ebx * 4 + 76]       //i:=nHybrid[0] +76
  and   eax, $7FFFFFFF
  mov   [esi - 44], eax       //i(=It3D.btmp)

@Repeat:
  movsd   [edi - 48], xmm7    //Rold := Rout
  cmp   dword [esi - 44], 0
  jnle  @up2
@While:
  inc   ebx
  cmp   bx, word [esi - 106]   //5  wEndTo: Word; //+150
  jle   @up3
  movzx ebx, word [esi - 68]       //n := iRepeatFrom
@up3:
  mov   eax, [edi + ebx * 4 + 76]   //i := nHybrid[n];  +76
  and   eax, $7FFFFFFF
  jle   @While
  mov   [esi - 44], eax
  mov   eax, [edi + ebx * 4 + 100]  //fHPVar:array[0..5] of Pointer;
  mov   [edi + 48], eax       //PVars: +48
@up2:
  lea   eax, edi - 8          //was: esp + 24   w
  push  eax
  push  edi
  lea   edx, edi - 24         //was: esp + 16   y
  lea   ecx, edi - 16         //was: esp + 24   z
  add   eax, -24              // x
  call  [edi + ebx * 4 + 124] //fHybrid[0..5] of ThybridIteration2; //+124
  dec   [esi - 44]            //Dec(i)   write at addr... false dIFS??
  cmp   [edi + ebx * 4 + 76], 0   //nHybrid[fnr]
  jl    @Repeat  //SkipMaxItTest
  movupd  xmm6, [edi - 32]
  movupd  xmm7, [edi - 16]
  mulpd   xmm6, xmm6
  mulpd   xmm7, xmm7
  addpd   xmm7, xmm6
  pshufd  xmm6, xmm7, $4E
  addsd   xmm7, xmm6          //xmm7=Rout
  movsd   xmm5, xmm7
  minsd   xmm5, qword [esi - 64]
  movsd   [edi + 56], xmm7    //Rout
  movsd   [esi - 64], xmm5    //OTrap
  inc   dword [edi + 64]      //Inc(ItResultI)
  mov   eax, [edi + 64]
  cmp   eax, [edi + 68]       //maxIt: +68
  jnl   @out
  comisd  xmm7, [edi - 40]    //RStop
  jc    @Repeat
@out:
  cmp   byte [esi - 108], 0  //CalcSIT: +148
  jz    @NoCalcSITout

  mov   eax, edi
  mov   edx, ebx
  call  CalcSmoothIterations //(PIt3D: TPIteration3D; n: Integer);

@NoCalcSITout:
  pop   edi
  pop   esi
  pop   edx
  pop   ecx
  pop   ebx
  pop   eax
end;

function doHybridPasDE(PIteration3D: TPIteration3D): Double; //new ext version
var n: Integer;
begin
    with TPIteration3Dext(Integer(PIteration3D) - 56)^ do
    begin
      if DoJulia then mCopyVec(@J1, @JU1) else mCopyVec(@J1, @C1);
      mCopyVec(@x, @C1);
      Rout  := x * x + y * y + z * z;
      OTrap := Rout;
      n     := iStartFrom;
      btmp  := nHybrid[n] and $7FFFFFFF;
      PVar  := fHPVar[n];
      case (DEoption and $38) of
        16:  w := Rout;
        32:  begin Deriv1 := 1; Deriv2 := 0; Deriv3 := 0; end;
      else w := 1;
      end;
      bFirstIt  := 0;
      ItResultI := 0;
      repeat
        Rold := Rout;
        while btmp <= 0 do
        begin
          Inc(n);
          if n > EndTo then n := iRepeatFrom;
          btmp := nHybrid[n] and $7FFFFFFF;
          PVar := fHPVar[n];
        end;
        fHybrid[n](x, y, z, w, PIteration3D);   //access violation with new formulaclass sometimes
        Dec(btmp);
        if nHybrid[n] >= 0 then
        begin
          Inc(ItResultI);
          Rout := x * x + y * y + z * z;
          if Rout < OTrap then OTrap := Rout;
        end;
      until
        (ItResultI >= maxIt) or (Rout > RStop);

      if (DEoption and $38) = 32 then
        Result := Sqrt(Rout) * 0.5 * Ln(Rout) / Deriv1
      else
      case DEoption and 7 of
        4: Result := Abs(y) * Ln(Abs(y)) / w; //Julia?
        7: Result := Sqrt(Rout / RStop) * Power(PDouble(Integer(PVar) - 16)^, -ItResultI);  //Bulb, not really working
      else Result := Sqrt(Rout) / Abs(w);   //AmBox + IFS
      end;

      if CalcSIT then CalcSmoothIterations(PIteration3D, n);
    end;
end;

procedure doHybridSSE2(PIteration3D: TPIteration3D);  //new ext version
asm
  push  eax
  push  ebx
  push  ecx
  push  edx
  push  esi
  push  edi                   //x = edi-32  y = edi-24 ..  Rold = edi - 48, Rstop = edi - 40, (i = edi + 212 = btmp = esi - 44)
  mov   edi, eax              //  = [edi - 32]
  lea   esi, eax + 256
  movupd  xmm6, [edi]         //Iteration3D by calcMissed not aligned16?!
  movsd   xmm7, [edi + 16]
  movupd  [edi - 32], xmm6         //X=C
  movupd  [edi - 16], xmm7
  cmp   dword [esi - 104], 0  //DoJulia:+152
  jz    @sjup
  movupd  xmm2, [esi + 64]
  movsd   xmm3, [esi + 80]
  movupd  [edi + 24], xmm2    //J=Ju
  movsd   [edi + 40], xmm3
  jmp   @skipIfJulia
@sjup:
  movupd  [edi + 24], xmm6    //J=C
  movsd   [edi + 40], xmm7
@skipIfJulia:
  mulpd   xmm6, xmm6
  mulsd   xmm7, xmm7
  CVTSS2SD xmm5, [edi + 72]   //RStop in double
  addsd   xmm7, xmm6
  shufpd  xmm6, xmm6, 1
  movsd   [edi - 40], xmm5
  addsd   xmm7, xmm6          //xmm7=Rout
  movsd   [esi - 64], xmm7    //OTrap=Rout
  movsd   [edi + 56], xmm7    //Rout
  xor   ebx, ebx
  mov   [esi - 48], ebx       //bFirstIt := 0; +208
  mov   [edi + 64], ebx       //ItresultI:=0   +64
  movzx ebx, word [esi - 66]  //n := iStartFrom
  mov   eax, [edi + ebx * 4 + 100]      //fHPVar[0] +100
  mov   [edi + 48], eax       //PVars:    +48
  mov   eax, [edi + ebx * 4 + 76]       //i:=nHybrid[0] +76
  and   eax, $7FFFFFFF
  mov   [esi - 44], eax       //btmp

@Repeat:
  movsd   [edi - 48], xmm7    //Rold := Rout
  cmp   dword [esi - 44], 0
  jnle  @up2
@While:
  inc   ebx
  cmp   bx, word [esi - 106]   //5  wEndTo: Word; //+150
  jle   @up3
  movzx ebx, word [esi - 68]       //n := iRepeatFrom
@up3:
  mov   eax, [edi + ebx * 4 + 76]   //i := nHybrid[n];  +76
  and   eax, $7FFFFFFF
  jle   @While
  mov   [esi - 44], eax       //was btmp, now own var
  mov   eax, [edi + ebx * 4 + 100]  //fHPVar:array[0..5] of Pointer;
  mov   [edi + 48], eax       //PVars: +48
@up2:
  lea   eax, edi - 8          // w
  push  eax
  push  edi
  lea   edx, edi - 24
  lea   ecx, edi - 16
  add   eax, -24
  call  [edi + ebx * 4 + 124] //fHybrid[0..5] of ThybridIteration2; //+124   fp overflow: it3dex.z > 1eXXX !
  dec   [esi - 44]            //Dec(i)
  cmp   [edi + ebx * 4 + 76], 0
  jl    @Repeat  //SkipMaxItTest
  movupd  xmm6, [edi - 32]
  movupd  xmm7, [edi - 16]
  mulpd   xmm6, xmm6
  mulsd   xmm7, xmm7          //4D: mulpd
  addsd   xmm7, xmm6          //4D:  addpd
  shufpd  xmm6, xmm6, 1       //4D:  pshufd xmm6, xmm7, $4E
  addsd   xmm7, xmm6          //xmm7=Rout
  movsd   xmm5, xmm7
  minsd   xmm5, qword [esi - 64]
  movsd   [edi + 56], xmm7    //Rout
  movsd   [esi - 64], xmm5    //OTrap
  inc   dword [edi + 64]      //Inc(ItResultI)
  mov   eax, [edi + 64]
  cmp   eax, [edi + 68]       //maxIt: +68
  jnl   @out
  comisd  xmm7, [edi - 40]     //RStop
  jc    @Repeat
@out:
  cmp   byte [esi - 108], 0  //CalcSIT: +148
  jz    @NoCalcSITout

  mov   eax, edi
  mov   edx, ebx
  call  CalcSmoothIterations //(PIt3D: TPIteration3D; n: Integer);

@NoCalcSITout:
  pop   edi
  pop   esi
  pop   edx
  pop   ecx
  pop   ebx
  pop   eax
end;

function doHybridDESSE2(PIteration3D: TPIteration3D): Double; //result in st(0)  new ext version
asm
  push  eax
  push  ebx
  push  ecx
  push  edx
  push  esi
  push  edi                   //x = edi-32  y = edi-24 ..  Rold = edi - 48, Rstop = edi - 40, (i = edi + 212 = btmp = esi - 44)
  mov   edi, eax
  lea   esi, eax + 256
  movupd  xmm6, [edi]         //Iteration3D by calcMissed not aligned16?!
  movsd   xmm7, [edi + 16]
  movupd  [edi - 32], xmm6    //X=C
  movupd  [edi - 16], xmm7
  cmp   dword [esi - 104], 0  //DoJulia:+152
  jz    @sjup
  movupd  xmm2, [esi + 64]
  movsd   xmm3, [esi + 80]
  movupd  [edi + 24], xmm2    //J=Ju
  movsd   [edi + 40], xmm3
  jmp   @skipIfJulia
@sjup:
  movupd  [edi + 24], xmm6    //J=C
  movsd   [edi + 40], xmm7
@skipIfJulia:
  mulpd   xmm6, xmm6
  mulsd   xmm7, xmm7
  CVTSS2SD xmm5, [edi + 72]   //RStop in double
  addsd   xmm7, xmm6
  shufpd  xmm6, xmm6, 1
  movsd   [edi - 40], xmm5
  addsd   xmm7, xmm6          //xmm7=Rout
  movsd   [esi - 64], xmm7    //OTrap=Rout
  movsd   [edi + 56], xmm7    //Rout
  movsd   [edi - 48], xmm7    //Rold := Rout
  xor   ebx, ebx              //n:=0
  mov   [edi + 208], ebx      //mov   [esi - 48], ebx       //bFirstIt  := 0; +208
  mov   [edi + 64], ebx       //ItresultI:=0   +64
  movzx ebx, word [esi - 66]  //n := iStartFrom
  mov   eax, [edi + ebx * 4 + 100]      //fHPVar[n] +100
  mov   [edi + 48], eax       //PVars:    +48
  mov   eax, [edi + ebx * 4 + 76]       //i:=nHybrid[n] +76
  and   eax, $7FFFFFFF
  mov   [esi - 44], eax
  mov   eax, [esi - 96]       //DEoption +160
  and   eax, $38              //    case (DEoption and $38) of
  sub   eax, 16
  jnz   @UU1
  fld   qword [edi + 56]      //   16:  w := Rout;
  jmp   @UU2
@UU1:
  sub   eax, 16
  jnz   @UU
  fld1
  fstp  qword [esi - 24]     // deriv1
  fldz                       //    32:  begin Deriv1 := 1; Deriv2 := 0; Deriv3 := 0;  end;
  fst   qword [esi - 16]
  fst   qword [esi - 8]
  jmp   @UU2
@UU:
  fld1                       //  else w := 1;
@UU2:
  fstp  qword [edi - 8]      //w := Rout,1,0

@Repeat:
  movsd   [edi - 48], xmm7    //Rold := Rout
  cmp   dword [esi - 44], 0
  jnle  @up2
@While:
  inc   ebx
//  cmp   ebx, 5
  cmp   bx, word [esi - 106]   //5  wEndTo: Word; //+150
  jle   @up3
  movzx ebx, word [esi - 68]       //n := iRepeatFrom
@up3:
  mov   eax, [edi + ebx * 4 + 76]   //i := nHybrid[n];  +76
  and   eax, $7FFFFFFF
  jle   @While
  mov   [esi - 44], eax
  mov   eax, [edi + ebx * 4 + 100]  //fHPVar:array[0..5] of Pointer;
  mov   [edi + 48], eax       //PVars: +48
@up2:
  lea   eax, edi - 8          //was: esp + 24   w
  push  eax
  push  edi
  lea   edx, edi - 24         //was: esp + 16   y
  lea   ecx, edi - 16         //was: esp + 24   z
  add   eax, -24              // x
  call  [edi + ebx * 4 + 124] //fHybrid[0..5] of ThybridIteration2; //+124   error in called function sometimes!!!
  dec   [esi - 44]            //Dec(i)    //Write off...??? bug in call... of mandbox or menger??!  abox as testhybrid! esi has changed?
  cmp   [edi + ebx * 4 + 76], 0
  jl    @Repeat  //SkipMaxItTest
  movupd  xmm6, [edi - 32]
  movupd  xmm7, [edi - 16]
  mulpd   xmm6, xmm6
  mulsd   xmm7, xmm7
  addsd   xmm7, xmm6
  shufpd  xmm6, xmm6, 1
  addsd   xmm7, xmm6          //xmm7=Rout
  movsd   xmm5, xmm7
  minsd   xmm5, qword [esi - 64]
  movsd   [edi + 56], xmm7    //Rout
  movsd   [esi - 64], xmm5    //OTrap
  inc   dword [edi + 64]      //Inc(ItResultI)
  mov   eax, [edi + 64]
  cmp   eax, [edi + 68]       //maxIt: +68
  jnl   @out
  comisd  xmm7, [edi - 40]    //RStop
  jc    @Repeat
@out:
  mov   eax, [esi - 96]       //DEoption +160     if (DEoption and $38) = 32 then
  and   eax, 38
  sub   eax, 32
  jnz   @JU1
  fld   qword [edi + 56]      //rout      Result := Sqrt(Rout) * 0.5 * Ln(Rout) / RoutDeriv
  fldln2
  fld   st(1)      //rout,ln2,rout
  fyl2x            //ln(rout),rout
  fxch
  fsqrt
  fmulp
  fmul  cs05
  fdiv  qword [esi - 24]      //Deriv1
  jmp   @UU6
@JU1:
  mov   eax, [esi - 96]       //DEoption +160
  and   eax, 7
  sub   eax, 4
  jnz   @UU3   //Result := Abs(X3) * Ln(Abs(X3)) / X4;
  fld   qword [edi - 16]      //X3
  fabs
  fldln2
  fld   st(1)      //absX3,ln2,absX3
  fyl2x            //ln(absX3),absX3
  fmulp
  fdiv  qword [edi - 8]   //Result
  jmp   @UU6
@UU3:
  sub   eax, 3
  jnz   @UU4   //Result := Sqrt(Rout/RStop) * Power(PDouble(Integer(PVar) - 16)^, -ItResultI);
  mov   eax,  [edi + 48]
  fild  dword [edi + 64]  //ItResultI
  fchs              //-ItresultI
  fld   [eax - 16]  //(Pvar-16)^ (= scale or something)
  fldln2      //power function  x,pow
  fxch
  fyl2x
  fxch
  fmulp
  fldl2e
  fmulp
  fld   st(0)
  frndint
  fsub  st(1), st(0)
  fxch
  f2xm1
  fld1
  faddp
  fscale
  fstp  st(1) //end of power function
  fld   qword [edi + 56]
  fdiv  dword [edi + 72] //rout/rstop,pow
  fsqrt
  fmulp
  jmp   @UU6
@UU4:          // else Result := Sqrt(Rout) / Abs(X4);
  fld   qword [edi + 56]
  fsqrt
  fld   qword [edi - 8]
  fabs
  fdivp
@UU6:
  cmp   byte [esi - 108], 0  //CalcSIT: +148
  jz    @NoCalcSITout

  mov   eax, edi
  mov   edx, ebx
  call  CalcSmoothIterations //(PIt3D: TPIteration3D; n: Integer);

@NoCalcSITout:
  pop   edi
  pop   esi
  pop   edx
  pop   ecx
  pop   ebx
  pop   eax
end;

                      //x:eax,y:edx,z:ecx,w:esp->ebp+12, PIt:ebp+8
procedure HybridItTricorn(var x, y, z, w: Double; PIteration3D: TPIteration3D);
asm
  push  esi
  push  edi
  fld   qword [edx]
  fld   st(0)
  fmul  st(0), st(1)      // y*y, y
  fld   qword [eax]       // x, y*y, y
  mov   esi, [ebp + 8]    // PIteration3D
  fld   st(0)             // x, x, y*y, y
  fmul  st(0), st(1)      // x*x, x, y*y, y
  fld   qword [ecx]       // z, x*x, x, y*y, y
  fld   st(0)
  mov   edi, [esi + 48]
  fmul  st(0), st(1)      // z*z, z, x*x, x, y*y, y
  faddp st(4), st(0)      // z, x*x, x, y*y+z*z, y
  fmul  st(0), st(2)      // z*x, x*x, x, y*y+z*z, y
  fmul  qword [edi - 16]
  fld   qword [esi + 40]
  fmul  qword [edi - 24]
  faddp
  fstp  qword [ecx]       // x*x, x, y*y+z*z, y
  fsubrp st(2), st(0)     // x, x*x-y*y-z*z, y
  fmulp  st(2), st(0)     // x*x-y*y-z*z, y*x
  fadd  qword [esi + 24]
  fstp  qword [eax]       // y*x
  fadd  st(0), st(0)
  fadd  qword [esi + 32]
  fstp  qword [edx]
  pop   edi
  pop   esi
end;

{procedure HybridItTricorn(var x, y, z, w: Double; PIteration3D: TPIteration3D);
var xt: Double;
begin
    with PIteration3D^ do
    begin
      xt := x;
      x  := x * x - y * y - z * z + J1;
      y  := 2 * xt * y + J2;
      z  := dOption1 * xt * z + J3;    
    end;
end;}
                                             
procedure HybridQuat(var x, y, z, w: Double; PIteration3D: TPIteration3D);
var xt, yt, zt: Double;
begin
    with PIteration3D^ do
    begin
      xt := x;       //orig
      yt := y;
      zt := z;
      x  := x * x - y * y - z * z - w * w + J1;
      y  := 2 * (y * xt + z * w) + J2;
      z  := 2 * (z * xt + PDouble(Integer(PVar) - 16)^ * yt * w) + J3;
      w  := 2 * (w * xt + yt * zt) + PDouble(Integer(PVar) - 24)^
                                   + PDouble(Integer(PIteration3D) - 56)^;
    end;
end;
            //x:eax,y:edx,z:ecx,w:esp->ebp+12, PIt:ebp+8
procedure HybridQuatSSE2(var x, y, z, w: Double; PIteration3D: TPIteration3D);
asm
    push esi
    push edi
    mov  esi, [ebp + 8]
    mov  edi, [esi + 48]       //PVars
    movupd  xmm0, [eax]        //x,y
    movupd  xmm1, [ecx]        //z,w
    movapd  xmm6, xmm0         //x,y
    movapd  xmm5, xmm1         //z,w
    movapd  xmm3, xmm1         //z,w
    xorpd   xmm4, xmm4         //0,0
    mulpd   xmm6, xmm6         //xx,yy
    mulpd   xmm5, xmm5         //zz,ww
    movupd  xmm2, [edx]        //y,z
    subsd   xmm4, xmm5         //-zz
    shufpd  xmm3, xmm0, 1      //w,x
    shufpd  xmm4, xmm5, 2      //-zz, ww
    mulpd   xmm2, xmm0         //yx, zy
    addpd   xmm4, xmm6         //xx-zz, yy+ww
    mulpd   xmm0, xmm1         //xz, yw
    mulpd   xmm3, xmm1         //wz, xw
    pshufd  xmm6, xmm0, $4E    //yw, xz
    pshufd  xmm1, xmm4, $4E    //yy+ww, xx-zz
    mulsd   xmm6, [edi - 16]   //ywMul, xz
    addpd   xmm2, xmm3         //yx+wz, zy+xw    -> y, w
    addsd   xmm6, xmm0         //ywMul + xz      -> z
    subpd   xmm4, xmm1         //xx-zz-yy-ww     -> x
    addpd   xmm2, xmm2         //y,w
    addsd   xmm6, xmm6         //z
    shufpd  xmm2, xmm2, 1      //w, y
    movupd  xmm5, [esi + 24]   //J1,J2
    addsd   xmm2, [edi - 24]
    addsd   xmm2, [esi - 56]   //+J4
    shufpd  xmm6, xmm2, 0      //z, w
    shufpd  xmm4, xmm2, 2      //x, y
    addsd   xmm6, [esi + 40]   //+J3
    addpd   xmm4, xmm5         //+J1,2
    movupd  [eax], xmm4
    movupd  [ecx], xmm6
    pop  edi
    pop  esi
end;

procedure HybridItIntPow2(var x, y, z, w: Double; PIteration3D: TPIteration3D); //sine bulb
asm
  push  esi
  push  edi
  fld   qword [ecx]
  fld   qword [edx]
  fld   qword [eax]       //x,y,z
  mov   esi, [ebp + 8]    //PIteration3D
  fld   st(1)             //y,x,y,z
  fmul  st(0), st(2)      // y*y,x,y,z
  fld   st(1)             // x,y*y,x,y,z
  fmul  st(0), st(2)      // x*x, y*y,x,y,z
  fld   st(0)             // x*x, x*x, y*y,x,y,z
  fadd  st(0), st(2)      // xx+yy, xx, yy,x,y,z
  fld   st(0)             // xx+yy, xx+yy, xx, yy,x,y,z
  fsqrt
  mov   edi, [esi + 48]
  fmul  qword [edi - 16]  //*dOption1=Zmul
  fmul  st(0), st(6)      //*z
  fadd  st(0), st(0)      //*2
  fadd  qword [esi + 40]  //+cz nly for test
  fstp  qword [ecx]       //xx+yy, xx, yy,x,y,z
  fld   st(5)             //z, xx+yy, xx, yy,x,y,z
  fmulp st(6), st(0)      //xx+yy, xx, yy,x,y,z*z
  fld   st(0)             //xx+yy, xx+yy, xx, yy,x,y,z*z
  fsubrp st(6), st(0)     //xx+yy, xx, yy,x,y, a - z*z
  fdivp st(5), st(0)      //xx, yy,x,y, a - z*z / a  = a
  fsubrp                  //xx-yy,x,y, a
  fmul  st(0), st(3)      //a(xx-yy),x,y, a
  fadd  qword [esi + 24]
  fstp  qword [eax]       //x,y, a
  fmulp
  fmulp                   //x*y*a
  fadd  st(0), st(0)      //*2
  fadd  qword [esi + 32]  //+ cy only for test
  fstp  qword [edx]
  pop   edi
  pop   esi               //SineP2
end;
            //x:eax,y:edx,z:ecx,w:esp->ebp+12, PIt:ebp+8
procedure HybridItIntPow2SSE2(var x, y, z, w: Double; PIteration3D: TPIteration3D);
asm
    push esi
    push ebx
    mov  esi, [ebp + 8]
    movlpd   xmm0, [eax]        // x
    movhpd   xmm0, [edx]        // x, y
    movlpd   xmm1, [ecx]        // z
    movapd   xmm2, xmm0
    mov  ebx, [esi + 48]        //Pvars    
    movsd    xmm3, xmm1
    mulpd    xmm2, xmm2         // S1, S2
    mulsd    xmm3, xmm3         // S3
    pshufd   xmm5, xmm2, $4E    // S2, S1
    movapd   xmm4, xmm5
    addpd    xmm5, xmm2         // S1+S2
    subsd    xmm2, xmm4         // S1-S2
    movapd   xmm6, xmm5
    mulsd    xmm1, [ebx - 16]   // z*dZmul
    sqrtsd   xmm4, xmm6         // Sqrt(S2+S1)
    addsd    xmm1, xmm1         // z*dZmul*2
    subsd    xmm6, xmm3         // (S1+S2)-S3
    mulsd    xmm1, xmm4         // z*dZmul*2*Sqrt(S2+S1)
    movsd    xmm3, [edx]        // y
    addsd    xmm1, [esi + 40]   // z*dZmul*Sqrt(S2+S1)+J3 = z
    divsd    xmm6, xmm5         // (XT-S3)/XT   = XT
    addsd    xmm3, xmm3         // y*2
    movsd    [ecx], xmm1        // z
    mulsd    xmm3, xmm0         // y*2*x
    mulsd    xmm2, xmm6         // (S1-S2)*XT
    mulsd    xmm3, xmm6         // y*2*x*XT
    addsd    xmm2, [esi + 24]   // (S1-S2)*XT+J1 = x
    addsd    xmm3, [esi + 32]   // y*2*x*XT+J2 = y
    movsd    [eax], xmm2        // x
    movsd    [edx], xmm3        // y
    pop  ebx
    pop  esi
end;

procedure HybridFloatPow(var x, y, z, w: Double; PIteration3D: TPIteration3D);
{var th, ph, pp: Double;
    Esin1, Ecos1, Esin2, Ecos2: Double;
begin
    with PIteration3D^ do
    begin
  //    R  := Sqrt(Rout);
      th := ArcTan2(y, x);
      ph := ArcTan2(z, Sqrt(Sqr(x) + Sqr(y)));   //  ArcSin(z / R);
      pp := Power(Rout, 0.5 * PDouble(Integer(PVar) - 16)^);
      SinCosD(PDouble(Integer(PVar) - 16)^ * ph, Esin1, Ecos1);
      SinCosD(PDouble(Integer(PVar) - 16)^ * th, Esin2, Ecos2);
      x := pp * Ecos1 * Ecos2 + J1;
      y := pp * Ecos1 * Esin2 + J2;
      z := PDouble(Integer(PVar) - 24)^ * pp * Esin1 + J3;
    end;  }
asm
  push   esi
  push   edi
  mov    esi, [ebp + 8]     //PIteration3D
  mov    edi, [esi + 48]
  fld    qword [edi - 16]
  fld    qword [edx]
  fld    qword [eax]
  fld    st(1)
  fld    st(1)
  fpatan                    //theta, x, y, pow
  fmul   st, st(3)
  fsincos                   //Costheta, Sintheta, x, y, pow
  fld    qword [ecx]        //z,Costheta, Sintheta,x,y,pow
  fxch   st(3)              //x,Costheta, Sintheta,z,y,pow
  fmul   st, st
  fxch   st(4)              //y,Costheta, Sintheta,z,xx,pow
  fmul   st, st
  faddp  st(4), st          //Costheta,Sintheta,z,xx+yy,pow
  fxch   st(2)              //z,Sintheta,Costheta,xx+yy,pow
  fxch                      //Sintheta,z,Costheta,xx+yy,pow
  fxch   st(3)              //xx+yy,z,Costheta,Sintheta,pow
  fsqrt
  fpatan                    //phi,Costheta, Sintheta,pow
  fmul   st, st(3)
  fsincos                   //Cosphi,Sinphi,Costheta,Sintheta,pow
  fxch   st(4)              //pow,Sinphi,Costheta,Sintheta,Cosphi
  fmul   qword [edi - 8]    //*0.5 because of Rout=sqr(R)
  fld    qword [esi + 56]   //SqrRadius, pow*0.5,Sinphi,Costheta,Sintheta,Cosphi
  fldln2                    //power function  x,pow
  fxch
  fyl2x
  fxch
  fmulp
  fldl2e
  fmulp
  fld    st(0)
  frndint
  fsub   st(1), st(0)
  fxch
  f2xm1
  fld1
  faddp
  fscale
  fstp   st(1)              //NewRadius,Sinphi,Costheta,Sintheta,Cosphi
  fxch   st(2)              //Costheta,Sinphi,NewRadius,Sintheta,Cosphi
  fmul   st, st(4)
  fmul   st, st(2)
  fadd   qword [esi + 24]
  fstp   qword [eax]        //Sinphi,NewRadius,Sintheta,Cosphi
  fxch   st(3)              //Cosphi,NewRadius,Sintheta,Sinphi
  fmulp  st(2), st          //NewRadius,Sintheta*Cosphi,Sinphi
  fmul   st(1), st
  fmulp  st(2), st          //Sintheta*Cosphi*r,Sinphi*r
  fadd   qword [esi + 32]
  fstp   qword [edx]
  fmul   qword [edi - 24]
  fadd   qword [esi + 40]
  fstp   qword [ecx]
  pop    edi
  pop    esi
end;

      //x:eax,y:edx,z:ecx,w:esp->ebp+12, PIt:ebp+8
procedure HybridItIntPow3(var x, y, z, w: Double; PIteration3D: TPIteration3D);
asm
  push  esi
  push  edi
  mov   esi, [ebp + 8]    //PIteration3D
  fld   qword [edx]
  fmul  st, st            // y*y
  fld   qword [eax]       // x, y*y
  mov   edi, [esi + 48]   // PVars
  fmul  st, st            // x*x, y*y
  fld   st(0)             // x*x, x*x, y*y
  fadd  st(0), st(2)      // x*x+y*y = R, x*x = sx, y*y = sy
  fld   qword [ecx]
  fmul  st, st            // sz, R, sx, sy
  fld   qword [edi + 120] // 3, sz, R, sx, sy
  fld   st(1)             // sz, 3, sz, R, sx, sy
  fmul  st(0), st(1)      // 3*sz, 3, sz, R, sx, sy
  fld   st(3)
  fadd  qword [edi + 24]
  fdivp                   // 3*sz/R, 3, sz, R, sx, sy
  fld1
  fsubrp
//  fsubr qword [edi + 32]  // A, 3, sz, R, sx, sy       1-3*sz/R
  fld   st(1)             // 3, A, 3, sz, R, sx, sy
  fmul  st(0), st(6)      // 3*sy, ..
  fsubr st(0), st(5)      // sx-3*sy, ..
  fmul  st(0), st(1)      // A*(sx-3*sy), A, 3, sz, R, sx, sy
  fmul  qword [eax]
  fadd  qword [esi + 24]
  fstp  qword [eax]       // A, 3, sz, R, sx, sy
  fxch  st(4)             // sx, 3, sz, R, A, sy
  fmul  st(0), st(1)      // 3*sx, 3, sz, R, A, sy
  fsubrp st(5), st(0)     // 3, sz, R, A, 3*sx-sy  was: sy-3*sx!
  fmulp st(2), st(0)      // sz, 3*R, A, 3*sx-sy
  fsubrp                  // sz-3*R, A, 3*sx-sy
  fmul  qword [ecx]
  fmul  qword [edi - 16]  //*dZmul
  fsubr qword [esi + 40]
  fstp  qword [ecx]       // A, 3*sx-sy
  fmulp                   // A*(3*sx-sy)
  fmul  qword [edx]
  fadd  qword [esi + 32]
  fstp  qword [edx]
  pop   edi
  pop   esi
end;

procedure HybridItIntPow4(var x, y, z, w: Double; PIteration3D: TPIteration3D);
{var R, A, yt: Double;
begin
    with PIteration3D^ do
    begin
      R  := x * x + y * y;
      yt := y;
      A := 1 + (sz * (sz - 6 * R)) / (R * R + d1em40);
      y := 4 * x * y * A * (sx - sy) + J2;                      //4: PVars + 128
      z := PDouble(Integer(PVar) - 16)^ * 4 * Sqrt(R) * z * (R - sz) + J3;  //6: PVars + 144
      x := A * (sx * (sx - 6 * sy) + sy * sy) + J1;
    end;  }
asm
  push  esi
  push  edi
  mov   esi, [ebp + 8]    //PIteration3D
  fld   qword [edx]
  fmul  st, st            // y*y
  fld   qword [eax]       // x, y*y
  mov   edi, [esi + 48]   // PVars
  fld   st
  fmul  st, st            // x*x, x, y*y
  fld   st(0)             // x*x, x*x, x, y*y
  fadd  st(0), st(3)      // x*x+y*y = R, sx, x, sy
  fld   qword [ecx]
  fmul  st, st            // sz, R, sx, x, sy
  fld   qword [edi + 144] // 6, sz, R, sx, x, sy
  fmul  st, st(2)         // 6*R, sz, R, sx, x, sy
  fsubr st, st(1)         // sz - 6*R, sz, R, sx, x, sy
  fmul  st(0), st(1)      // sz * (sz - 6 * R), sz, R, sx, x, sy
  fld   st(2)
  fmul  st, st            // R*R, sz * (sz - 6 * R), sz, R, sx, x, sy
  fadd  qword [edi + 24]  // 24-112  +1e-40
  fdivp                   // sz * (sz - 6 * R) / R*R, sz, R, sx, x, sy
  fld1
  faddp                   // A, sz, R, sx, x, sy
  fld   st(5)             // sy, A, sz, R, sx, x, sy
  fmul  qword [edi + 144] // 6*sy, A, sz, R, sx, x, sy
  fsubr st, st(4)         // sx-6*sy, A, sz, R, sx, x, sy
  fmul  st(0), st(4)      // sx*(sx-6*sy), A, sz, R, sx, x, sy
  fld   st(6)
  fmul  st, st
  faddp                   // sy*sy + sx*(sx-6*sy), A, sz, R, sx, x, sy
  fmul  st, st(1)
  fadd  qword [esi + 24]
  fstp  qword [eax]       // A, sz, R, sx, x, sy
  fxch  st(2)             // R, sz, A, sx, x, sy
  fsubr st(1), st         // R, R-sz, A, sx, x, sy
  fsqrt
  fmulp                   // sqrt(R)*(R-sz), A, sx, x, sy
  fmul  qword [ecx]
  fmul  qword [edi + 128] //*4
  fmul  qword [edi - 16]  //*dZmul
  fadd  qword [esi + 40]
  fstp  qword [ecx]       // A, sx, x, sy
  fxch                    // sx, A, x, sy    y := 4 * x * y * A * (sx - sy) + J2;
  fsubrp st(3), st        // A, x, sx-sy
  fmulp                   // A*x, sx-sy
  fmulp
  fmul  qword [edi + 128] //*4
  fmul  qword [edx]       //*y
  fadd  qword [esi + 32]
  fstp  qword [edx]
  pop   edi
  pop   esi
end;

procedure HybridIntP5(var x, y, z, w: Double; PIteration3D: TPIteration3D);
{var sx, sy, sz, A, R: Double;
begin
  with PIteration3D^ do
  begin
    sx := x*x;
    sy := y*y;
    R  := sx + sy;
    sz := z*z;
    A  := 1 + 5*(sz*sz - 2*R*sz) / (R*R + d1em40);
    y  := A*y*(5*sx*sx - sy*(10*sx - sy)) + J2;
    z  := PDouble(Integer(PVar) - 16)^*z*(sz*(sz - 10*R) + 5*R*R) + J3;
    x  := A*x*(sx*(sx - 10*sy) + 5*sy*sy) + J1;
  end;  }
asm
  push  esi
  push  edi
  mov   esi, [ebp + 8]    //PIteration3D
  fld   qword [edx]
  fmul  st, st            // y*y
  fld   qword [eax]       // x, y*y
  mov   edi, [esi + 48]   // PVars
  fmul  st, st            // x*x, y*y
  fld   st                // x*x, x*x, y*y
  fadd  st, st(2)         // x*x+y*y = R, sx, sy
  fld   qword [ecx]
  fmul  st, st            // sz, R, sx, sy
  fld   qword [edi + 136] // 5, sz, R, sx, sy
  fld   st                // 5, 5, sz, R, sx, sy
  fld   st(2)
  fmul  st, st(4)
  fadd  st, st            // sz*R*2, 5, 5, sz, R, sx, sy
  fld   st(3)
  fmul  st, st
  fsubrp                  // sz*sz - sz*R*2, 5, 5, sz, R, sx, sy
  fmulp                   // (sz*sz - sz*R*2) * 5, 5, sz, R, sx, sy
  fld   st(3)
  fmul  st, st            // R*R, (sz*sz - sz*R*2) * 5, 5, sz, R, sx, sy
  fadd  qword [edi + 24]  // 24-112  +1e-40
  fdivp                   // (sz*sz - sz*R*2) * 5 / R*R, 5, sz, R, sx, sy
  fld1
  faddp                   // A, 5, sz, R, sx, sy
  fld   st(4)             // sx, A, 5, sz, R, sx, sy
  fmul  qword [edi + 168] // 10*sx, A, 5, sz, R, sx, sy
  fsub  st, st(6)         // 10*sx - sy, A, 5, sz, R, sx, sy
  fmul  st, st(6)         // sy*(10*sx - sy), A, 5, sz, R, sx, sy
  fld   st(5)
  fmul  st, st
  fmul  st, st(3)         // 5*sx*sx, sy*(10*sx - sy), A, 5, sz, R, sx, sy
  fsubrp                  // 5*sx*sx - sy*(10*sx - sy), A, 5, sz, R, sx, sy
  fmul  st, st(1)
  fmul  qword [edx]
  fadd  qword [esi + 32]
  fstp  qword [edx]       // A, 5, sz, R, sx, sy
  fld   st(3)
  fmul  st, st(2)
  fadd  st, st            // 10*R, A, 5, sz, R, sx, sy
  fsubr st, st(3)         // sz-10*R, A, 5, sz, R, sx, sy
  fmulp st(3), st         // A, 5, sz*(sz-10*R), R, sx, sy
  fxch  st(3)             // R, 5, sz*(sz-10*R), A, sx, sy
  fmul  st, st            //
  fmul  st, st(1)         //
  faddp st(2), st         // 5, sz*(sz-10*R)+5*R*R, A, sx, sy
  fld   st(4)
  fmul  st, st
  fmul  st, st(1)         // 5*sy*sy, 5, sz*(sz-10*R)+5*R*R, A, sx, sy
  fxch  st(5)             // sy, 5, sz*(sz-10*R)+5*R*R, A, sx, 5*sy*sy
  fmulp
  fadd  st, st            // 10*sy, sz*(sz-10*R)+5*R*R, A, sx, 5*sy*sy
  fsubr st, st(3)         // sx-10*sy, sz*(sz-10*R)+5*R*R, A, sx, 5*sy*sy
  fmulp st(3), st         // sz*(sz-10*R)+5*R*R, A, sx*(sx-10*sy), 5*sy*sy
  fmul  qword [ecx]
  fmul  qword [edi - 16]  //*dZmul
  fadd  qword [esi + 40]
  fstp  qword [ecx]       // A, sx*(sx-10*sy), 5*sy*sy
  fmul  qword [eax]
  fxch                    // sx*(sx-10*sy), A*x, 5*sy*sy
  faddp  st(2), st        // A*x, sx*(sx-10*sy)+5*sy*sy
  fmulp
  fadd  qword [esi + 24]
  fstp  qword [eax]
  pop   edi
  pop   esi
end;

procedure HybridIntP6(var x, y, z, w: Double; PIteration3D: TPIteration3D);
{var S1, S2, sz, A, R: Double;
begin
  with PIteration3D^ do
  begin
    S1 := x*x;
    S2 := y*y;
    R  := S1 + S2;
    sz := z*z;
    A  := 1 - (sz*(sz*(sz - 15*R) + 15*R*R)) / (R*R*R + d1em40);
    y  := 2*A*x*y*(S1*(3*S1 - 10*S2) + 3*S2*S2) + J2;
    z  := PDouble(Integer(PVar) - 16)^*2*z*Sqrt(R)*(sz*(3*sz - 10*R) + 3*R*R) + J3;
    x  := A*(S1*S1*(S1 - 15*S2) + S2*S2*(15*S1 - S2)) + J1;
  end; }
asm
  push  esi
  push  edi
  mov   esi, [ebp + 8]    //PIteration3D
  fld   qword [edx]
  fmul  st, st            // y*y
  fld   qword [eax]       // x, y*y
  mov   edi, [esi + 48]   // PVars
  fmul  st, st            // x*x, y*y
  fld   st                // x*x, x*x, y*y
  fadd  st, st(2)         // x*x+y*y = R, sx, sy
  fld   qword [ecx]
  add   edi, 112
  fmul  st, st            // sz, R, sx, sy
  fld   qword [edi + 176-112] // 15, sz, R, sx, sy
  fld   st                // 15, 15, sz, R, sx, sy
  fmul  st, st(3)         // 15*R,
  fsubr st, st(2)         // sz-R*15, 15, sz, R, sx, sy
  fmul  st, st(2)
  fld   st(3)
  fmul  st, st            // R*R, sz*(sz-R*15), 15, sz, R, sx, sy
  fxch
  fld   st(1)             // R*R, sz*(sz-R*15), R*R, 15, sz, R, sx, sy
  fmulp st(3), st         // sz*(sz-R*15), R*R, 15*R*R, sz, R, sx, sy
  faddp st(2), st         // R*R, 15*R*R+sz*(sz-R*15), sz, R, sx, sy
  fxch                    // 15*R*R+sz*(sz-R*15), R*R, sz, R, sx, sy
  fmul  st, st(2)         // sz*(15*R*R+sz*(sz-R*15)), R*R, sz, R, sx, sy
  fld   st(1)
  fmul  st, st(4)         // R*R*R, sz*(15*R*R+sz*(sz-R*15)), R*R, sz, R, sx, sy
  fadd  qword [edi + 24-112]  // 24-112  +1e-40
  fdivp                   // sz*(15*R*R+sz*(sz-R*15)) / R*R*R, R*R, sz, R, sx, sy
  fld1
  fsubrp                  // 1 - sz*(15*R*R+sz*(sz-R*15)) / R*R*R, R*R, sz, R, sx, sy
  fld   st(5)             // sy, A, R*R, sz, R, sx, sy
  fmul  qword [edi + 168-112] // 10*sy, A, R*R, sz, R, sx, sy
  fld   st(5)
  fmul  qword [edi + 120-112] // 3*sx, 10*sy, A, R*R, sz, R, sx, sy
  fsubrp                  // 3*sx-10*sy, A, R*R, sz, R, sx, sy
  fmul  st, st(5)         // sx*(3*sx-10*sy), A, R*R, sz, R, sx, sy
  fld   st(6)             // sy,
  fmul  st, st
  fmul  qword [edi + 120-112] // 3*sy*sy, sx*(3*sx-10*sy), A, R*R, sz, R, sx, sy
  faddp                   // 3*sy*sy+sx*(3*sx-10*sy), A, R*R, sz, R, sx, sy
  fmul  st, st(1)
  fmul  qword [edx]
  fmul  qword [eax]       //        z := PDouble(Integer(PVar) - 16)^*2*z*Sqrt(R)*(sz*(3*sz - 10*R) + 3*R*R) + J3;
  fadd  st, st            //        x := A*(S1*S1*(S1 - 15*S2) + S2*S2*(15*S1 - S2)) + J1;
  fadd  qword [esi + 32]
  fstp  qword [edx]       // A, R*R, sz, R, sx, sy
  fld   st(3)
  fmul  qword [edi + 168-112]
  fld   st(3)             // sz, 10*R, A, R*R, sz, R, sx, sy
  fmul  qword [edi + 120-112]
  fsubrp                  // 3*sz-10*R, A, R*R, sz, R, sx, sy
  fmulp st(3), st         // A, R*R, sz*(3*sz-10*R), R, sx, sy
  fxch
  fmul  qword [edi + 120-112] // 3*R*R, A, sz*(3*sz-10*R), R, sx, sy
  faddp st(2), st         // A, sz*(3*sz-10*R)+3*R*R, R, sx, sy
  fld   qword [edi + 176-112] // 15
  fld   st                // 15, 15, A, sz*(3*sz-10*R)+3*R*R, R, sx, sy
  fmul  st, st(5)
  fsub  st, st(6)
  fmul  st, st(6)
  fmul  st, st(6)         // S2*S2*(15*S1-S2), 15, A, sz*(3*sz-10*R)+3*R*R, R, sx, sy
  fxch
  fmulp st(6), st         // S2*S2*(15*S1-S2), A, sz*(3*sz-10*R)+3*R*R, R, sx, 15*sy
  fxch  st(5)             // 15*sy, A, sz*(3*sz-10*R)+3*R*R, R, sx, S2*S2*(15*S1-S2)
  fsubr st, st(4)         // sx-15*sy, A, sz*(3*sz-10*R)+3*R*R, R, sx, S2*S2*(15*S1-S2)
  fmul  st, st(4)
  fmulp st(4), st         // A, sz*(3*sz-10*R)+3*R*R, R, sx*sx*(sx-15*sy), S2*S2*(15*S1-S2)
  fxch  st(4)             // S2*S2*(15*S1-S2), sz*(3*sz-10*R)+3*R*R, R, sx*sx*(sx-15*sy), A
  faddp st(3), st         // sz*(3*sz-10*R)+3*R*R, R, S2*S2*(15*S1-S2)+sx*sx*(sx-15*sy), A
  fxch
  fsqrt
  fmulp                   // (sz*(3*sz-10*R)+3*R*R)*sqrt(R), S2*S2*(15*S1-S2)+sx*sx*(sx-15*sy), A
  fmul  qword [ecx]
  fmul  qword [edi - 16-112]  //*dZmul
  fadd  st, st
  fadd  qword [esi + 40]
  fstp  qword [ecx]       // S2*S2*(15*S1-S2)+sx*sx*(sx-15*sy), A
  fmulp
  fadd  qword [esi + 24]
  fstp  qword [eax]
  pop   edi
  pop   esi
end;

procedure HybridIntP7(var x, y, z, w: Double; PIteration3D: TPIteration3D);
{var S1, S2, S3, A, R: Double;
begin
  with PIteration3D^ do
  begin
    S1 := x*x;
    S2 := y*y;
    R  := S1 + S2;
    S3 := z*z;
    A  := 1 - 7*(S3*(S3*(S3 - 5*R) + 3*R*R)) / (R*R*R + d1em40);
    y  := A*y*(S1*(S1*(7*S1 - 35*S2) + 21*S2*S2) - S2*S2*S2) + J2;
    z  := J3 - PDouble(Integer(PVar) - 16)^* (z*S3*S3*S3 - 7*z*R*(S3*(3*S3 - 5*R) + R*R) );
    x  := A*x*(S1*(S1*(S1 - 21*S2) + 35*S2*S2) - 7*S2*S2*S2) + J1;
  end;  }
asm
  push  esi
  push  edi
  mov   esi, [ebp + 8]    //PIteration3D
  fld   qword [edx]
  fmul  st, st            // y*y
  fld   qword [eax]       // x, y*y
  mov   edi, [esi + 48]   // PVars
  fmul  st, st            // x*x, y*y
  fld   st                // x*x, x*x, y*y
  fadd  st, st(2)         // x*x+y*y = R, sx, sy
  fld   qword [ecx]
  add   edi, 112
  fmul  st, st            // sz, R, sx, sy
  fld   st(1)             // R, sz, R, sx, sy
  fmul  qword [edi + 136-112] // 5R,
  fsubr st, st(1)         // sz-5R, sz, R, sx, sy
  fmul  st, st(1)         // sz(sz-5R), sz, R, sx, sy
  fld   st(2)
  fmul  st, st            // R*R, sz(sz-5R), sz, R, sx, sy
  fxch                    // sz(sz-5R), R*R, sz, R, sx, sy
  fld   st(1)             // R*R, sz(sz-5R), R*R, sz, R, sx, sy
  fmul  qword [edi + 120-112] // 3*R*R, sz(sz-5R), R*R, sz, R, sx, sy
  faddp                   // 3RR+sz(sz-5R), R*R, sz, R, sx, sy
  fmul  st, st(2)         // sz(3RR+sz(sz-5R)), R*R, sz, R, sx, sy
  fmul  qword [edi + 152-112]
  fld   st(1)
  fmul  st, st(4)         // R*R*R, 7sz(3RR+sz(sz-5R)), R*R, sz, R, sx, sy
  fadd  qword [edi + 24-112]  // 24-112  +1e-40
  fdivp                   // 7sz(3RR+sz(sz-5R))/RRR, R*R, sz, R, sx, sy
  fld1
  fsubrp                  // A, R*R, sz, R, sx, sy
  fld   st(5)             // sy, A, R*R, sz, R, sx, sy
  fmul  qword [edi + 200-112] // 35*sy, A, R*R, sz, R, sx, sy
  fld   st(5)
  fmul  qword [edi + 152-112] // 7*sx, 35*sy, A, R*R, sz, R, sx, sy
  fsubrp                  // 7*sx-35*sy, A, R*R, sz, R, sx, sy
  fmul  st, st(5)         // sx*(7*sx-35*sy), A, R*R, sz, R, sx, sy
  fld   st(6)             // sy,
  fmul  st, st
  fmul  qword [edi + 184-112] // 21*sy*sy, sx*(7*sx-35*sy), A, R*R, sz, R, sx, sy
  faddp                   // 21sysy+sx(7sx-35sy), A, R*R, sz, R, sx, sy
  fmul  st, st(5)
  fld   st(6)
  fmul  st, st
  fmul  st, st(7)         // sysysy, sx(21sysy+sx(7sx-35sy)), A, R*R, sz, R, sx, sy
  fsubp                   // sx(21sysy+sx(7sx-35sy))-sysysy, A, R*R, sz, R, sx, sy
  fmul  st, st(1)
  fmul  qword [edx]
  fadd  qword [esi + 32]
  fstp  qword [edx]       // A, R*R, sz, R, sx, sy
  fmul  qword [eax]       //   z := J3 - PDouble(Integer(PVar) - 16)^*z*(sz*sz*sz - 7*R*(sz*(3*sz - 5*R) + R*R));
                          //   x := A*x*(sx*(sx*(sx - 21*sy) + 35*sy*sy) - 7*sy*sy*sy) + J1;
  fld   st(3)
  fmul  qword [edi + 136-112] // 5R, A*x, R*R, sz, R, sx, sy
  fld   st(3)             // sz, 5R, A*x, R*R, sz, R, sx, sy
  fmul  qword [edi + 120-112]
  fsubrp                  // 3sz-5R, A*x, R*R, sz, R, sx, sy
  fmul  st, st(3)         // sz(3sz-5R), A*x, R*R, sz, R, sx, sy
  faddp st(2), st         // A*x, RR+sz(3sz-5R), sz, R, sx, sy
  fxch
  fmul  qword [edi + 152-112] // 7(RR+sz(3sz-5R)), A*x, sz, R, sx, sy
  fmulp st(3), st         // A*x, sz, 7R(sz(3sz-5R)+RR), sx, sy
  fld   st(1)
  fmul  st, st
  fmulp st(2), st         // A*x, szszsz, 7R(RR+sz(3sz-5R)), sx, sy
  fxch                    // szszsz, A*x, 7R(RR+sz(3sz-5R)), sx, sy
  fsubrp st(2), st        // A*x, szszsz-7R(RR+sz(3sz-5R)), sx, sy
  fld   st(3)             // sy, A*x, szszsz-7R(RR+sz(3sz-5R)), sx, sy
  fmul  qword [edi + 184-112] // 21sy, A*x, szszsz-7R(RR+sz(3sz-5R)), sx, sy
  fsubr st, st(3)         // sx-21sy, A*x, szszsz-7R(RR+sz(3sz-5R)), sx, sy
  fmul  st, st(3)         // sx(sx-21sy)
  fld   st(4)             // sy, sx(sx-21sy), A*x, szszsz-7R(RR+sz(3sz-5R)), sx, sy
  fmul  st, st            // sysy, sx(sx-21sy), A*x, szszsz-7R(RR+sz(3sz-5R)), sx, sy
  fmul  qword [edi + 200-112] // 35sysy, sx(sx-21sy), A*x, szszsz-7R(RR+sz(3sz-5R)), sx, sy
  faddp                   // 35sysy+sx(sx-21sy), A*x, szszsz-7R(RR+sz(3sz-5R)), sx, sy
  fmulp st(3), st         // A*x, szszsz-7R(RR+sz(3sz-5R)), sx(35sysy+sx(sx-21sy)), sy
  fxch  st(3)             // sy, szszsz-7R(RR+sz(3sz-5R)), sx(35sysy+sx(sx-21sy)), A*x
  fld   st
  fmul  st, st
  fmulp
  fmul  qword [edi + 152-112] // 7sysysy, szszsz-7R(RR+sz(3sz-5R)), sx(35sysy+sx(sx-21sy)), A*x
  fsubp st(2), st         // szszsz-7R(RR+sz(3sz-5R)), sx(35sysy+sx(sx-21sy))-7sysysy, A*x
  fmul  qword [ecx]
  fmul  qword [edi - 16-112]  //*dZmul
  fsubr qword [esi + 40]
  fstp  qword [ecx]       // sx(35sysy+sx(sx-21sy))-7sysysy, A*x
  fmulp
  fadd  qword [esi + 24]
  fstp  qword [eax]
  pop   edi
  pop   esi
end;

                       //x:eax,y:edx,z:ecx,w:esp->ebp+12, PIt:ebp+8
procedure HybridIntP8(var x, y, z, w: Double; PIteration3D: TPIteration3D);   //P8 white's formula
asm
  push  esi
  push  edi
  mov   esi, [ebp + 8]    //PIteration3D
  fld   qword [eax]       //x
  mov   edi, [esi + 48]   //PVars
  fmul  st(0), st(0)      //xx
  fld   qword [edx]       //y
  add   edi, 88
  fmul  st(0), st(0)      //yy,xx
  fld   qword [ecx]       //z,yy,xx
  fmul  st(0), st(0)      //zz,yy,xx
  fld   st(2)             //xx,zz,yy,xx
  fadd  st(0), st(2)      //xx+yy=r,zz,yy,xx
  fld   st(0)             //r,r,zz,yy,xx
  fmul  st(0), st(1)      //rr,r,zz,yy,xx
  fld   st(2)
  fmul  st(0), st(0)      //zzzz(S3*S3),rr,r,zz,yy,xx
  fld   st(2)             //r,zzzz(S3*S3),rr,r,zz,yy,xx    z calculation
  fmul  st(0), st(4)      //r*zz
  fmul  qword [edi + 56]  //6*r*zz,zzzz(S3*S3),rr,r,zz,yy,xx   
  fsubr st(0), st(1)      //zzzz-6rzz,zzzz,rr,r,zz,yy,xx
  fadd  st(0), st(2)      //zzzz-6rzz+rr,zzzz,rr,r,zz,yy,xx
  fld   st(4)             //zz,zzzz-6rzz+rr,zzzz,rr,r,zz,yy,xx
  fsub  st(0), st(4)      //zz-r,zzzz-6rzz+rr,zzzz,rr,r,zz,yy,xx
  fmulp                   //(zz-r)*(zzzz-6rzz+rr),zzzz,rr,r,zz,yy,xx
  fld   st(3)             //r,(zz-r)*(zzzz-6rzz+rr),zzzz,rr,r,zz,yy,xx
  fsqrt
  fmulp                   //sqrt(r)*(zz-r)*(zzzz-6rzz+rr),zzzz,rr,r,zz,yy,xx
  fmul  qword [ecx]       //*z
  fmul  qword [edi + 72]  //*8
  fmul  qword [edi - 104] //*dZmul
  fchs
  fadd  qword [esi + 40]  //+J3
  fstp  qword [ecx]       //zzzz,rr,r,zz,yy,xx
  fld   st(0)             //zzzz,zzzz,rr,r,zz,yy,xx        a calculation
  fadd  st(0), st(2)      //zzzz+rr,zzzz,rr,r,zz,yy,xx
  fmulp st(3), st(0)      //zzzz,rr,r*(zzzz+rr),zz,yy,xx
  fld   st(1)             //rr,zzzz,rr,r*(zzzz+rr),zz,yy,xx
  fmul  qword [edi + 120]  //rr*70,zzzz,rr,r*(zzzz+rr),zz,yy,xx
  fadd  st(0), st(1)
  fmulp                   //(rr*70+zzzz)*zzzz,rr,r*(zzzz+rr),zz,yy,xx
  fxch  st(2)             //r*(zzzz+rr),rr,(rr*70+zzzz)*zzzz,zz,yy,xx
  fmulp st(3), st(0)      //rr,(rr*70+zzzz)*zzzz,zz*r*(zzzz+rr),yy,xx
  fxch  st(2)             //zz*r*(zzzz+rr),(rr*70+zzzz)*zzzz,rr,yy,xx
  fmul  qword [edi + 104]  //28*zz*r*(zzzz+rr),(rr*70+zzzz)*zzzz,rr,yy,xx
  fsubp                   //(rr*70+zzzz)*zzzz-28*zz*r*(zzzz+rr),rr,yy,xx
  fxch  st(1)
  fmul  st(0), st(0)      //rrrr,(rr*70+zzzz)*zzzz-28*zz*r*(zzzz+rr),yy,xx
  fadd  qword [edi - 64]  //   24-88  +1e-40
  fdivp                   //(zzzz*(rr*70+zzzz)-28*zz*r*(zzzz+rr))/rrrr,yy,xx
  fadd  qword [edi - 56]  //a,yy,xx    +1
  fld   st(1)             //yy,a,yy,xx                   y calculation
  fmul  qword [edi + 64]  //7*yy,a,yy,xx       + 152-128=24
  fld   st(3)             //xx,7*yy,a,yy,xx
  fmul  qword [edi + 64]  //7*xx,7*yy,a,yy,xx
  fsub  st(0), st(3)      //7*xx-yy,7*yy,a,yy,xx
  fld   st(4)             //xx,7*xx-yy,7*yy,a,yy,xx
  fsubr st(2), st(0)      //xx,7*xx-yy,xx-7*yy,a,yy,xx
  fmul  st(0), st(0)      //xxxx,7*xx-yy,xx-7*yy,a,yy,xx
  fmul  st(2), st(0)      //xxxx,7xx-yy,xxxx(xx-7yy),a,yy,xx
  fld   st(4)             //yy,xxxx,7xx-yy,xxxx(xx-7yy),a,yy,xx
  fmul  st(0), st(0)      //yyyy,xxxx,7xx-yy,xxxx(xx-7yy),a,yy,xx
  fmul  st(2), st(0)      //yyyy,xxxx,yyyy(7xx-yy),xxxx(xx-7yy),a,yy,xx
  fxch  st(2)             //yyyy(7xx-yy),xxxx,yyyy,xxxx(xx-7yy),a,yy,xx
  faddp st(3), st(0)      //xxxx,yyyy,yyyy(7xx-yy)+xxxx(xx-7yy),a,yy,xx
  fxch  st(2)             //yyyy(7xx-yy)+xxxx(xx-7yy),yyyy,xxxx,a,yy,xx
  fmul  qword [edi + 72]  //*8
  fmul  qword [eax]       //*x
  fmul  qword [edx]       //*y
  fmul  st(0), st(3)      //*a
  fadd  qword [esi + 32]  //+J2
  fstp  qword [edx]       //yyyy,xxxx,a,yy,xx
  fld   st(1)             //xxxx,yyyy,xxxx,a,yy,xx
  fmul  qword [edi + 120]  //70xxxx,yyyy,xxxx,a,yy,xx
  fadd  st(0), st(1)      //70xxxx+yyyy,yyyy,xxxx,a,yy,xx
  fmul  st(0), st(1)      //yyyy(70xxxx+yyyy),yyyy,xxxx,a,yy,xx
  fxch  st(1)             //yyyy,yyyy(70xxxx+yyyy),xxxx,a,yy,xx
  fadd  st(0), st(2)      //yyyy+xxxx,yyyy(70xxxx+yyyy),xxxx,a,yy,xx
  fmulp st(4), st(0)      //yyyy(70xxxx+yyyy),xxxx,a,yy(yyyy+xxxx),xx
  fxch  st(4)             //xx,xxxx,a,yy(yyyy+xxxx),yyyy(70xxxx+yyyy)
  fmulp st(3), st(0)      //xxxx,a,xxyy(yyyy+xxxx),yyyy(70xxxx+yyyy)
  fmul  st(0), st(0)      //xxxx*xxxx,a,xxyy(yyyy+xxxx),yyyy(70xxxx+yyyy)
  faddp st(3), st(0)      //a,xxyy(yyyy+xxxx),xxxx*xxxx+yyyy(70xxxx+yyyy)
  fxch  st(1)             //xxyy(yyyy+xxxx),a,xxxx*xxxx+yyyy(70xxxx+yyyy)
  fmul  qword [edi + 104]
  fsubp st(2), st(0)      //a,xxxx*xxxx+yyyy(70xxxx+yyyy)-28xxyy(yyyy+xxxx)
  fmulp
  fadd  qword [esi + 24]
  fstp  qword [eax]
  pop   edi
  pop   esi
end;

                          //x:eax,y:edx,z:ecx,w:esp->ebp+12, PIt:ebp+8
procedure HybridCubeSSE2(var x, y, z, w: Double; PIteration3D: TPIteration3D);  // is used in alt hybrid without DE on w
asm
    push esi                
    push ebx
    mov  esi, [ebp + 8]    //PIteration3D
    mov  ebx, [esi + 48]
    
    movupd   xmm2, [eax]       //[x,y]
    movsd    xmm4, [ecx]       //[z]
    movapd   xmm0, xmm2
    maxpd    xmm0, [ebx - 64]     //const:-1,-1,1,1
    maxsd    xmm4, [ebx - 64]
    minpd    xmm0, [ebx - 48]
    minsd    xmm4, [ebx - 48]
    addpd    xmm0, xmm0
    addsd    xmm4, xmm4
    subpd    xmm0, xmm2
    subsd    xmm4, [ecx]

    movapd   xmm1, xmm0        //x, y
    movsd    xmm5, xmm4
    mulpd    xmm1, xmm1        //x*x, y*y
    mulsd    xmm5, xmm5        //z*z
    pshufd   xmm6, xmm1, $4E   //y*y, x*x    copies and swaps hi<>lo
    addsd    xmm1, xmm5        //x*x + z*z
    addsd    xmm1, xmm6        // w = sqr(r)
    ucomisd  xmm1, [ebx - 32]  //<dOption2 was:dOpt3
    jnb  @u1
    movsd    xmm3, [ebx - 24]  //dOption1
    jmp  @u3
@u1:ucomisd  xmm1, [ebx + 32]  //<1 ? ucomisd slow?
    movsd    xmm3, [ebx - 16]  //dPow = scale //Was:dOpt2
    jnb  @u3
    divsd    xmm3, xmm1
@u3:shufpd   xmm3, xmm3, 0
    movupd   xmm5, [esi + 24]  //[J1,J2]
    mulpd    xmm0, xmm3
    mulsd    xmm4, xmm3
    addpd    xmm0, xmm5
    addsd    xmm4, [esi + 40]  //J3
    movlpd   [eax], xmm0
    movhpd   [edx], xmm0
    movsd    [ecx], xmm4
    pop  ebx
    pop  esi
end;

procedure HybridCube(var x, y, z, w: Double; PIteration3D: TPIteration3D);
asm
    push  esi                   //Amazing box  x87     with options  fold  fold x2
    push  ebx
    mov   esi, [ebp + 8]        //PIteration3D
    mov   esi, [esi + 48]       //was:PAligned16
    mov   ebx, eax
    fld   qword [esi - 40]      //fold
    fld   qword [eax]           //x,fold
    fld   st(0)                 //x,x,fold     folding with x = abs(x+fold) - abs(x-fold) - x
    fsub  st(0), st(2)
    fabs
    fadd  st(0), st(1)          //abs(x-fold)+x,x,fold
    fxch                        //x,abs(x-fold)+x,fold
    fadd  st(0), st(2)
    fabs
    fsubrp                      //abs(x+fold)-(abs(x-fold)+x),fold
    fld   qword [edx]           //y,fold
    fld   st(0)
    fsub  st(0), st(3)
    fabs
    fadd  st(0), st(1)
    fxch
    fadd  st(0), st(3)
    fabs
    fsubrp
    fld   qword [ecx]           //y,fold
    fld   st(0)
    fsub  st(0), st(4)
    fabs
    fadd  st(0), st(1)
    fxch
    fadd  st(0), st(4)
    fabs
    fsubrp                      //z,y,x,fold

    fld   st(0)              //7
    fmul  st(0), st(1)
    fld   st(2)              //8
    fmul  st(0), st(3)
    faddp                    //7
    fld   st(3)              //8
    fmul  st(0), st(4)
    faddp                      //r,z,y,x,-fold,fold,fold x2
    fcom  qword [esi - 32]
    fnstsw ax
    shr   ah, 1
    jnc   @@7
    fstp  st(0)
    fld   qword [esi - 24]
    jmp   @@9
@@7:                           //r,z,y,x,-fold,fold,fold x2
    fld1
    fcom  st(1)
    fnstsw ax
    shr   ah, 1
    jc    @@8
    fstp  st(0)
    fdivr qword [esi - 16]
    jmp   @@9
@@8:
    fcompp
    fld   qword [esi - 16]
@@9:
    fmul  st(3), st(0)        //mul,zr,yr,xr,-fold,fold, foldx2
    fmul  st(2), st(0)
    fmulp                     //zr,yr,xr,-fold,fold, foldx2
    mov   esi, [ebp + 8]
    fadd  qword [esi + 40]
    fstp  qword [ecx]
    fadd  qword [esi + 32]
    fstp  qword [edx]
    fadd  qword [esi + 24]
    fstp  qword [ebx]
    fstp  st(0)
    mov  eax, ebx
    pop  ebx
    pop  esi
end;

procedure HybridCubeDE(var x, y, z, w: Double; PIteration3D: TPIteration3D);
asm
    push  esi                   //Amazing box without adding c    x87     with option fold
    push  ebx
    mov   esi, [ebp + 8]        //PIteration3D
    mov   ebx, eax
    mov   esi, [esi + 48]       //was:PAligned16
    fld   qword [esi - 40]      //fold
    fld   st(0)
    fchs                        //-fold,fold
    fld   qword [ebx]           //x,-fold,fold
    fld   st(0)                 //x,x,-fold,fold     folding with x = abs(x+fold) - abs(x-fold) - x
    fadd  st(0), st(2)
    fabs
    fadd  st(0), st(1)          
    fxch                        //x,abs(x-fold)+x,-fold,fold
    fadd  st(0), st(3)
    fabs
    fsubrp                      //abs(x+fold)-(abs(x-fold)+x),-fold,fold
    fld   qword [edx]           //y,x,-fold,fold
    fld   st(0)
    fadd  st(0), st(3)
    fabs
    fadd  st(0), st(1)
    fxch
    fadd  st(0), st(4)
    fabs
    fsubrp
    fld   qword [ecx]           //z,y,x,-fold,fold
    fld   st(0)
    fadd  st(0), st(4)
    fabs
    fadd  st(0), st(1)
    fxch
    fadd  st(0), st(5)
    fabs
    fsubrp

    fld   st(0)              //7
    fmul  st(0), st(1)
    fld   st(2)              //8
    fmul  st(0), st(3)
    faddp                    //7
    fld   st(3)              //8
    fmul  st(0), st(4)
    faddp                      //r,z,y,x,-fold,fold
    fcom  qword [esi - 32]
    fnstsw ax
    shr   ah, 1
    jnc   @@7
    fstp  st(0)
    fld   qword [esi - 24]
    jmp   @@9
@@7:                           //r,z,y,x,-fold,fold
    fld1
    fcom  st(1)
    fnstsw ax
    shr   ah, 1
    jc    @@8
    fstp  st(0)
    fdivr qword [esi - 16]
    jmp   @@9
@@8:
    fcompp
    fld   qword [esi - 16]
@@9:
    fld   qword [ecx + 8]     //w,mul,zr,yr,xr,-fold,fold
    fmul  st(0), st(1)
    fstp  qword [ecx + 8]
    fmul  st(3), st(0)        //mul,zr,yr,xr,-fold,fold
    fmul  st(2), st(0)
    fmulp                     //zr,yr,xr,-fold,fold
    mov   esi, [ebp + 8]
    fadd  qword [esi + 40]
    fstp  qword [ecx]
    fadd  qword [esi + 32]
    fstp  qword [edx]
    fadd  qword [esi + 24]
    fstp  qword [ebx]
    fcompp
    mov  eax, ebx
    pop  ebx
    pop  esi
end;

procedure HybridCubeSSE2DE(var x, y, z, w: Double; PIteration3D: TPIteration3D);
asm
    push esi
    push ebx
    mov  esi, [ebp + 8]        //PIteration3D
    mov  ebx, [esi + 48]       //was:PAligned16

    movupd   xmm2, [eax]       //[x,y]
    movsd    xmm4, [ecx]       //[z]
    movapd   xmm0, xmm2
    maxpd    xmm0, [ebx - 64]     //const:-R,-R,R,R
    maxsd    xmm4, [ebx - 64]
    minpd    xmm0, [ebx - 48]
    minsd    xmm4, [ebx - 48]
    addpd    xmm0, xmm0
    addsd    xmm4, xmm4
    subpd    xmm0, xmm2
    subsd    xmm4, [ecx]

    movapd   xmm1, xmm0        //x, y
    movsd    xmm5, xmm4
    mulpd    xmm1, xmm1        //x*x, y*y
    mulsd    xmm5, xmm5        //z*z
    pshufd   xmm2, xmm1, $4E   //y*y, x*x    copies and swaps hi<>lo
    addsd    xmm1, xmm5
    addsd    xmm1, xmm2        // w = sqr(r)
    ucomisd  xmm1, [ebx - 32]  //<dOption2   //7/6 clocks ucomisd latency :-(

    movsd    xmm3, [ebx - 24]  //dOption1
    jb   @u3
    ucomisd  xmm1, [ebx + 32]  //<1 ?
    movsd    xmm3, [ebx - 16]  //dPow = scale
    jnb  @u3
    divsd    xmm3, xmm1
@u3:
    movhpd   xmm4, [ecx + 8]
    shufpd   xmm3, xmm3, 0     //r, r
    movupd   xmm5, [esi + 24]  //[J1,J2]
    mulpd    xmm0, xmm3
    mulpd    xmm4, xmm3
    addpd    xmm0, xmm5
    addsd    xmm4, [esi + 40]  //J3
    movupd   [eax], xmm0
    movupd   [ecx], xmm4
    pop  ebx
    pop  esi
end;

procedure HybridItIntPow2scale(var x, y, z, w: Double; PIteration3D: TPIteration3D); //sine bulb with scaling
asm
  push  esi
  push  edi
  mov   edi, [ebp + 8]
  mov   esi, [edi + 48]
  fld   qword [ecx]
  fld   qword [edx]
  fld   qword [eax]       //x,y,z
  fld   qword [esi - 72]  // scaling
  fld1
  fdivrp
  fmul  st(3), st(0)
  fmul  st(2), st(0)
  fmulp
  fld   st(1)             //y,x,y,z
  fmul  st(0), st(2)      // y*y,x,y,z
  fld   st(1)             // x,y*y,x,y,z
  fmul  st(0), st(2)      // x*x, y*y,x,y,z
  fld   st(0)             // x*x, x*x, y*y,x,y,z
  fadd  st(0), st(2)      // xx+yy, xx, yy,x,y,z
  fld   st(0)             // xx+yy, xx+yy, xx, yy,x,y,z
  fsqrt
  fmul  st(0), st(6)      //*z
  fadd  st(0), st(0)      //*2
  fchs
  fmul  qword [esi - 72]
  fadd  qword [edi + 40]
  fstp  qword [ecx]       //xx+yy, xx, yy,x,y,z
  fld   st(5)             //z, xx+yy, xx, yy,x,y,z
  fmulp st(6), st(0)      //xx+yy, xx, yy,x,y,z*z
  fld   st(0)             //xx+yy, xx+yy, xx, yy,x,y,z*z
  fsubrp st(6), st(0)     //xx+yy, xx, yy,x,y, a - z*z
  fdivp st(5), st(0)      //xx, yy,x,y, a - z*z / a  = a
  fsubrp                  //xx-yy,x,y, a
  fmul  st(0), st(3)      //a(xx-yy),x,y, a
  fmul  qword [esi - 72]
  fadd  qword [edi + 24]
  fstp  qword [eax]       //x,y, a
  fmulp
  fmulp                   //x*y*a
  fadd  st(0), st(0)      //*2
  fmul  qword [esi - 72]
  fadd  qword [edi + 32]
  fstp  qword [edx]
  pop   edi
  pop   esi
end;

procedure HybridSuperCube2(var x, y, z, w: Double; PIteration3D: TPIteration3D);
var R1, R2, m, m2: Double;
    xyzIn, xyzOut: TVec3D;
begin
//    testhybridOptionVals: array[0..5] of Double = (2, 0.5, 1, 1, 2, 1.9);
    if PIteration3D.Rout < PDouble(Integer(PIteration3D.PVar) - 80)^ then     //smooth Bulbox
    with PIteration3D^ do
    begin
      if Rout < PDouble(Integer(PVar) - 88)^ then
        HybridItIntPow2scale(x, y, z, w, PIteration3D)   //ThybridIteration(pCodePointer) := fHIntFunctions[Round(dSIpow)];
      else
      begin
        R1 := PDouble(Integer(PVar) - 88)^;
        m := (Rout - R1) / (PDouble(Integer(PVar) - 80)^ - R1);
        FastMove(x, xyzIn, 24);
        HybridItIntPow2scale(x, y, z, w, PIteration3D);
        FastMove(x, xyzOut, 24);
        FastMove(xyzIn, x, 24);
        fHybridCube(x, y, z, w, PIteration3D);
        R1 := Sqrt(Sqr(x) + Sqr(y) + Sqr(z));
        m2 := 1 - m;
        R2 := R1 * m + m2 * Sqrt(Sqr(xyzOut[0]) + Sqr(xyzOut[1]) + Sqr(xyzOut[2]));
        x := x * m + m2 * xyzOut[0];
        y := y * m + m2 * xyzOut[1];
        z := z * m + m2 * xyzOut[2];
        R1 := R2 / Sqrt(Sqr(x) + Sqr(y) + Sqr(z) + 1e-40);
        x := x * R1;
        y := y * R1;
        z := z * R1;
      end;
    end
    else fHybridCube(x, y, z, w, PIteration3D);

{    if PIteration3D.Rout < PDouble(Integer(PIteration3D.PVar) - 80)^ then     //Bulbox, only RThreshold
      HybridItIntPow2scale(x, y, z, w, PIteration3D)                           //bscale5 vid=34s, 29.6s
    else
      fHybridCube(x, y, z, w, PIteration3D);  }
end;

procedure HybridFolding(var x, y, z, w: Double; PIteration3D: TPIteration3D);
asm
    push esi
    push edi
    push ebx
    mov  esi, [ebp + 8]        //PIteration3D
    mov  edi, [esi + 48]
    fld   qword [edi - 24]      //fold
    fld   qword [eax]           //x,fold
    fld   st(0)                 //x,x,fold     folding with x = abs(x+fold) - abs(x-fold) - x
    fsub  st(0), st(2)
    fabs
    fadd  st(0), st(1)          //abs(x-fold)+x,x,fold
    fxch                        //x,abs(x-fold)+x,fold
    fadd  st(0), st(2)
    fabs
    fsubrp                      //abs(x+fold)-(abs(x-fold)+x),fold
    fstp  qword [eax]
    fld   qword [edx]           //y,fold
    fld   st(0)
    fsub  st(0), st(2)
    fabs
    fadd  st(0), st(1)
    fxch
    fadd  st(0), st(2)
    fabs
    fsubrp
    fstp  qword [edx]
    fld   qword [ecx]           //z,fold
    fld   st(0)
    fsub  st(0), st(2)          //z-fold,z,fold
    fabs
    fadd  st(0), st(1)          //z+abs(z-fold),z,fold
    fxch  st(2)
    faddp                       //z+fold,z+abs(z-fold)
    fabs
    fsubrp                      //z'
    fstp  qword [ecx]
    mov  ebx, [ebp + 12]
    push ebx
    push esi
    call [edi - 52]
    pop  ebx
    pop  edi
    pop  esi
end;

procedure EmptyFormula(var x, y, z, w: Double; PIteration3D: TPIteration3D);
begin //not used formulas, itCount might be set to bigger 0 and executed!

end;

//########### from here: custom formulas generation, not at runtime -> use IFStest instead!

procedure HybridCustomIFS;   //for IFS, different calling convention!  esi+edi is @it3dext.x+128 and @Pvar
asm
end;

{function ArcSin(const X : Double) : Double; overload;
asm
  //Result := ArcTan2(X, Sqrt((1+X) * (1-X)))
  FLD   X              x
  FLD1                 1,x
  FADD  ST(0), ST(1)   1+x,x
  FLD1                 1,1+x,x
  FSUB  ST(0), ST(2)   1-x,1+x,x
  FMULP ST(1), ST(0)   (1-x)*(1+x),x
  FSQRT
  FPATAN
end;}
{  fld1                 1
  fld    X              x,1
  fst    st(2)          x,1,x
  fmul   st(0), st(0)   xx,1,x
  fsubp                 1-xx
  fsqrt
  fpatan}

{  fldln2   power function
  fxch
  fyl2x
  fxch
  fmulp
  fldl2e
  fmulp
  fld    st(0)
  frndint
  fsub   st(1), st(0)
  fxch
  f2xm1
  fld1
  faddp
  fscale
  fstp   st(1)
}
      //x:eax,y:edx,z:ecx,w:esp->ebp+12, PIt:ebp+8
{procedure HybridCustomRiemann(var x, y, z, w: Double; PIteration3D: TPIteration3D);
asm
  push   esi
  push   edi
  mov    esi, [ebp + 8]     //PIteration3D       //Riemann
  mov    edi, [esi + 48]
  fld    qword [eax]
  fld    qword [edx]
  fld    qword [ecx]
  fld    qword [esi + 56]   //Rout,z,y,x
  fsqrt
  fld1                      //1,sqrt(Rout),z,y,x
  fdivrp                    //1/sqrt(Rout),z,y,x
  fmul   st(3), st(0)
  fmul   st(2), st(0)
  fmulp                     //z,y,x  *rx
  fld1                      //1,z,y,x
  fsub   st(2), st(0)       //1,z,y-1,x
  fdivr  st(2), st(0)       //1,z,1/(y-1),x
  fxch   st(2)              //1/(y-1),z,1,x
  fmul   st(3), st(0)
  fmulp                     //z/(y-1),1,x/(y-1) =rz,1,rx
  fld    st(2)              //rx,rz,1,rx
  fmul   st(0), st(3)       //rxrx,rz,1,rx
  fsub   st(0), st(2)       //rxrx-1,rz,1,rx
  fxch                      //rz,rxrx-1,1,rx
  fxch   st(3)              //rx,rxrx-1,1,rz
  fadd   st(0), st(0)       //2rx,rxrx-1,1,rz
  fxch
  fpatan                    //atx,1,rz              arctan(st1/st0)  arctan2(y,x)  (2rx,rxrx-1)
  fld    st(2)              //rz,atx,1,rz
  fmul   st(0), st(3)
  fsub   st(0), st(2)       //rzrz-1,atx,1,rz
  fxch                      //atx,rzrz-1,1,rz
  fxch   st(3)              //rz,rzrz-1,1,atx
  fadd   st(0), st(0)       //2rz,rzrz-1,1,atx
  fxch
  fpatan                    //atz,1,atx
  fld    qword [edi - 16]   //p,atz,1,atx
  fmul   st(3), st(0)       //p,atz,1,p*atx
  fmulp                     //p*atz,1,p*atx
  fsincos                   //cosz,sinz,1,patx
  fadd   st(0), st(2)       //cosz+1,sinz,1,patx
  fdivp                     //rz,1,patx
  fxch   st(2)              //patx,1,rz
  fsincos                   //cosx,sinx,1,rz
  fadd   st(0), st(2)       //cosx+1,sinx,1,rz
  fdivp                     //rx,1,rz
  fld    st(0)              //rx,rx,1,rz
  fmul   st(0), st(1)       //rxrx,rx,1,rz
  fld    st(3)              //rz,rxrx,rx,1,rz
  fmul   st(0), st(4)
  faddp                     //rzrz+rxrx,rx,1,rz
  fld    st(0)              //rzrz+rxrx,rzrz+rxrx,rx,1,rz
  fadd   st(0), st(3)       //rzrz+rxrx+1,rzrz+rxrx,rx,1,rz
  fdivr  st(0), st(3)       //1/rzx1,rzx,rx,1,rz
  fxch                      //rzx,05c,rx,1,rz
  fsubrp st(3), st(0)       //05c,rx,rzx-1,rz
  fmul   st(3), st(0)       //05c,rx,rzx-1,rz*05c
  fmul   st(2), st(0)
  fmulp                     //05a,b,05c
  fld    qword [edi - 16]   //p,05a,b,05c
  fmul   qword [edi - 8]    //05p,05a,b,05c
  fld    qword [esi + 56]   //rout,05p,05a,b,05c

  fldln2                    //ln2,rout,05p,05a,b,05c    power function
  fxch
  fyl2x
  fxch
  fmulp
  fldl2e
  fmulp
  fld    st(0)
  frndint
  fsub   st(1), st(0)
  fxch
  f2xm1
  fld1
  faddp
  fscale
  fstp   st(1)

  fmul   st(3), st(0)       //pow(rout),05a,b,05c
  fmul   st(2), st(0)
  fmulp                     //05a,b,05c
  fadd   st(0), st(0)
  fadd   qword [esi + 24]
  fstp   qword [eax]        //2b,c
  fadd   qword [esi + 32]
  fstp   qword [edx]
  fadd   st(0), st(0)
  fadd   qword [esi + 40]
  fstp   qword [ecx]
  pop    edi
  pop    esi
end;   }
                     //x:eax,y:edx,z:ecx,w:esp->ebp+12, PIt:ebp+8
{procedure HybridCustomPas(var x, y, z, w: Double; PIteration3D: TPIteration3D);
var i: Integer;
    psi, psi2, cs, sn, a, xt, yt, zt: Double;
begin
    with PIteration3D^ do
    begin
      i  := Integer(PVar);
      asm
        fld qword [edi]
        fld qword [esi]
        fpatan
        fstp qword [ebp - $10]
      end;                                                           //  0    +8  +16 +24 +32
      psi  := psi + PDouble(i + 32)^;  //msltoe  Vars: Pi/8, Pi/4, 1,  2, 2*Pi
      psi2 := 0;
      while (psi > PDouble(i)^) do
      begin
        psi  := psi - PDouble(i + 8)^;
        psi2 := psi2 - PDouble(i + 8)^;
      end;
      asm
        fld qword [ebp - $18]
        fsincos
        fstp qword [ebp - $20]
        fstp qword [ebp - $28]
      end;
   //   cs := Cos(psi2);
   //   sn := Sin(psi2);
      yt := y*cs - z*sn;
      zt := y*sn + z*cs;
      y  := yt;
      z  := zt;
      a  := PDouble(i + 16)^ - z*z / (x*x + y*y + z*z);
      xt := (x*x - y*y) * a;
      yt := PDouble(i + 24)^ *x*y * a;
      zt := PDouble(i + 24)^ *z*Sqrt(x*x + y*y);
      x  := xt + J1;
      y  := yt*cs + zt*sn + J2;
      z  := zt*cs - yt*sn + J3;
    end;
end;

{function ArcTan2D(Y, X: Double): Double;
asm
    FLD     Y
    FLD     X
    FPATAN
    FWAIT
end;  }
                           //x:eax,y:edx,z:ecx,w:esp->ebp+12, PIt:ebp+8
procedure AexionC(var x, y, z, w: Double; PIteration3D: TPIteration3D);
{var ph, th, pp, r1, Sx, Cx, Sy, Cy: Double;
    pb: PByteArray;
    pd: PDouble;
begin
    with TPIteration3Dext(Integer(PIteration3D) - 56)^ do
    begin                                //Aexion rotate c   [Power, Z mul, Enable RotC (0,1), Cond Phi (0,1), Power C, Cz mul, Mod (0,1)]
      pb := Pointer(Integer(PVar) - 56);             ATth(1,2)  ATph(3,4)
      pd := @pb[56-16];                   Modus:  0:  J1|J3,J2      J3,J1           mod and 1 ->
      r1 := x*x + y*y + z*z;                      1:  J1|J2,J3      J2,J1    xch 2<>3
      th := ArcTan2D(Sqrt(x*x + z*z), y) * pd^;   2:  J2|J3,J1      J3,J2    xch 1<>2
      ph := ArcTan2D(z, x) * pd^;                 3:  J1|J3,J2      J3,J1   diffs
      SinCosD(ph, Sx, Cx);                        4:  J1|J2,J3      J2,J1    xch 2<>3
      SinCosD(th, Sy, Cy);                        5:  J2|J3,J1      J3,J2    xch 1<>2
      r1 := Power(r1, pd^ * 0.5);
      x := Cy * Cx * r1 + J1;
      y := Cy * Sx * r1 + J2;
      z := r1 * Sy * PDouble(@pb[56-24])^ + J3;
      if pb[56-28] <> 0 then  //rotate c
      begin
        if pb[56-52] <> 0 then
        begin
          pp := LengthOfVec(SubtractVectors(TPVec3D(@x), TPVec3D(@J1)^));
          pd := @pp;
        end
        else pd := @pb[56-40];
        r1 := Sqrt(J1*J1 + J2*J2 + J3*J3);
        if pb[56-56] = 1 then
        begin
          th := ArcTan2D(Sqrt(Sqr(x - J1) + Sqr(z - J3)), y - J2) * pd^;
          ph := ArcTan2D(z - J3, x - J1) * pd^;
        end else begin
          th := ArcTan2D(Sqrt(J1*J1 + J3*J3), J2) * pd^;
          ph := ArcTan2D(J3, J1) * pd^;
        end;
        if (pb[56-32] <> 0) and (x > 0) then ph := -ph; // conditional  phi1 := (x>0)?atan2(cz,cx)*8:-atan2(cz,cx)*8;
        SinCosD(ph, Sx, Cx);            // ph := ph xor ((UserInCond and 1) shl 31) and x) xor $80000000;
        SinCosD(th, Sy, Cy);
        J1 := Cy * Cx * r1;
        J2 := Cy * Sx * r1;
        J3 := r1 * Sy * PDouble(@pb[56-48])^;
      end;
    end; }
asm
    push esi
    push edi
    push ebx
    push ecx
    mov  esi, [ebp + 8]        //PIteration3D
    mov  edi, [esi + 48]
    fld  qword [ecx]
    fld  qword [edx]
    fld  qword [eax]   //x,y,z
    fld  st(1)
    fmul st, st        //yy,x,y,z
    fxch st(2)         //y,x,yy,z
    fld  st(3)
    fmul st, st        //zz,y,x,yy,z
    fld  st(2)
    fmul st, st        //xx,zz,y,x,yy,z
    fld  st(1)         //zz,xx,zz,y,x,yy,z
    fadd st, st(1)
    faddp st(5), st    //xx,zz,y,x,r1,z
    faddp
    fsqrt              //sqrt(xx+zz),y,x,r1,z
    fxch
    fpatan             //th,x,r1,z
    fxch st(3)
    fxch               //x,z,r1,th
    fpatan             //ph,r1,th
    fld qword [edi - 16] //pow,ph,r1,th
    fmul st(3), st
    fmul st(1), st
    fmul qword [edi - 8] //pow*0.5,ph,r1,th
    fxch               //ph,pow',r1,th
    fxch st(2)         //r1,pow',ph,th
  fldln2      //power function  base,expo  -> st, st(1)
  fxch
  fyl2x
  fxch
  fmulp
  fldl2e
  fmulp
  fld   st(0)
  frndint
  fsub  st(1), st(0)
  fxch
  f2xm1
  fld1
  faddp
  fscale
  fstp  st(1)          //r1',ph,th
    fxch st(2)         //th, ph, r1
    fsincos            //ct,st, ph, r1
    fxch st(2)         //ph, st,ct, r1
    fsincos            //cosP,sinP, sinT,cosT, r1
    fmul st, st(3)
    fmul st, st(4)
    fadd qword [esi + 24]
    fstp qword [eax]   //sinP, sinT,cosT, r1
    fmulp st(2), st    //sinT,cosT*SinP, r1
    fmul st, st(2)
    fmul qword [edi - 24]
    fadd qword [esi + 40]
    fstp qword [ecx]   //cosT*SinP, r1
    fmulp
    fadd qword [esi + 32]
    fstp qword [edx]

    cmp  dword [edi - 28], 0
    jz   @@1
    fld  qword [edi - 40]  //pd^
    cmp  dword [edi - 52], 0
    jz   @@2
    fld  qword [eax]
    fsub qword [esi + 24]
    fmul st, st
    fld  qword [edx]
    fsub qword [esi + 32]
    fmul st, st
    faddp
    fld  qword [ecx]
    fsub qword [esi + 40]
    fmul st, st
    faddp
    fsqrt
    fmulp
@@2:                       //pd^
    fld  qword [esi + 24]
    fmul st, st
    fld  qword [esi + 32]
    fmul st, st
    faddp
    fld  qword [esi + 40]
    fmul st, st
    faddp
    fsqrt             //r1, pd^
    mov  ebx, [edi - 56]
    test ebx, 16      //Modus Bit1: Flip atan theta, 2: Flip atan phi, 3: Flip theta and phi, 4: Flip CxCy, 5: diffs
    jz   @@4                   //           r,y              z,x                  y<>x/z            y<>x
    fld  qword [eax]
    fsub qword [esi + 24]
    fld  qword [ecx]
    fsub qword [esi + 40]
    fld  qword [edx]
    fsub qword [esi + 32]
    jmp  @@5
@@4:
    fld  qword [esi + 24]
    fld  qword [esi + 40]
    fld  qword [esi + 32]
@@5:                  //Cy, Cz, Cx, r1, pd^
    xor  eax, eax     //offset for cond phi test, normally x, or z if only flip-at2
    xor  ecx, ecx
    add  ecx, 8
    test ebx, 8       //Modus bit4: flip CYCX
    jz   @@6
    fxch //st(2)        //(Cx,Cz,Cy)
    add  ecx, 8      //(Cz,Cx,Cy)   test: Flip Cy<>Cz
 //   mov  eax, ecx
 //   xor  ecx, ecx
@@6:                  //y, z, x, r1, pd^
    fld  st(1)
    fmul st, st
    fld  st(3)
    fmul st, st
    faddp             //xx+zz, y, z, x, r1, pd^
    fsqrt             //sqrt(sqr(j1)+sqr(j3)), y, z, x, r1, pd
    test ebx, 1       //flip AT theta
    jnz  @@8
    fxch
@@8:
    fpatan            //th, Cz, Cx, r1, pd
    fxch st(2)        //Cx, Cz, th, r1, pd
    test ebx, 2       //flip AT phi
    jz   @@9
    fxch
    add  eax, 24
    sub  eax, ecx
  //  mov  eax, 16
@@9:
    fpatan            //ph, th, r1, pd
    test ebx, 4
    jz   @@7
    fxch
    mov  eax, ecx
@@7:
    cmp  dword [edi - 32], 0
    jz   @@10
    test dword [edx + eax - 4], $80000000
    jnz  @@10
    fchs
@@10:
    fmul st, st(3)
    fxch st(3)        //pd, th, r1, ph
    fmulp             //th, r1, ph
    fsincos           //costh,sinth,r1,ph
    fxch st(3)        //ph,sinth,r1,costh
    fsincos           //Cx,Sx,Sy,r1,Cy
    fmul st, st(4)
    fmul st, st(3)
    fstp qword [esi + 24]  //Sx,Sy,r1,Cy
    fmulp st(3), st   //Sy,r1,Cy*Sx
    fmul st, st(1)
    fmul qword [edi - 48]
    fstp qword [esi + 40] //r1,Cy*Sx
    fmulp
    fstp qword [esi + 32]
@@1:
    pop  ecx
    pop  ebx
    pop  edi
    pop  esi
end;

end.

