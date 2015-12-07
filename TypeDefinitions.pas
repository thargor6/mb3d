unit TypeDefinitions;

interface

uses Windows, Classes, Math3D, Messages;

const
  V18_FORMULA_COUNT = 6;
  V18_FORMULA_PARAM_COUNT = 16;

  OFF_nHybrid_V18 = 76; //+76
  OFF_fHPVar_V18 = OFF_nHybrid_V18 + V18_FORMULA_COUNT * 4; //+100
  OFF_fHybrid_V18 = OFF_fHPVar_V18 + V18_FORMULA_COUNT * 4; //+124
  OFF_CalcSIT = OFF_fHybrid_V18 + V18_FORMULA_COUNT * 4; //+148
  OFF_fHln_V18 = OFF_CalcSIT + V18_FORMULA_COUNT * 4; //+148

  {$ifdef ENABLE_EXTENSIONS}
  MAX_FORMULA_COUNT = 8;
  OFF_nHybrid = 400;
  OFF_fHPVar = OFF_nHybrid + MAX_FORMULA_COUNT * 4;
  OFF_fHybrid = OFF_fHPVar + MAX_FORMULA_COUNT * 4;
  OFF_fHln = OFF_fHybrid + MAX_FORMULA_COUNT * 4;
  {$else}
  MAX_FORMULA_COUNT = V18_FORMULA_COUNT;
  OFF_nHybrid = OFF_nHybrid_V18;
  OFF_fHPVar = OFF_fHPVar_V18;
  OFF_fHybrid = OFF_fHybrid_V18;
  OFF_fHln = OFF_fHln_V18;
  {$endif}

type
  TSingleArray = array[0..$effffff] of Single;
  TPSingleArray = ^TSingleArray;

  TCardinalArray = array[0..$effffff] of Cardinal;
  TPCardinalArray = ^TCardinalArray;

  TSmallintArray = array[0..$effffff] of Smallint;
  TPSmallintArray = ^TSmallintArray;

  TATlevel = array[1..9] of array of Word;
  TPATlevel = ^TATlevel;

  TAngMaxArr = array of array[0..31] of Single;  //for HiQ ambshadow calculation
  TPAngMaxArr = ^TAngMaxArr;

  TAngMaxArrSI = array of array[0..31] of Smallint;
  TPAngMaxArrSI = ^TAngMaxArrSI;

  TSVecArray = array[0..$3ffffff] of TSVec;
  TPSVecArray = ^TSVecArray;

 { TBGlevel = array[1..4] of array of Single;
  TPBGlevel = ^TBGlevel;  }

  PLongBool = ^LongBool;
  TSPoint = array[0..1] of Single;
  TPSPoint = ^TSPoint;

  T3word = array[0..2] of Word;
  TP3word = ^T3word;

  TRGB = array[0..2] of Byte;
  TPRGB = ^TRGB;
  TRGBA = array[0..3] of Byte;
  TPRGBA = ^TRGBA;

  TAObuf = packed record
    Z: array[0..2] of Byte;
    AO: Word;
  end;
  TPAObuf = ^TAObuf;

  AuthorStrings = array[0..1] of AnsiString;

  TLightLSDAIs = array[0..5] of TSVec;
  TPLightLSDAIs = ^TLightLSDAIs;
  TLightSDA = array[0..2] of TSVec;
  TLightSD = array[0..1] of TSVec;
  TPLightSD = ^TLightSD;

  TCTrecord = packed record   //40 Bytes
    iItAvrCount, iDEAvrCount: Integer;
    iActualXpos, iActualYpos: Integer;
    isActive, MaxIts: Integer;
    i64Its, i64DEsteps: Int64;
  end;
  TPCTrecord = ^TCTrecord;
  TCalcThreadStats = packed record
    iProcessingType: Integer;          //0: not calculating, 1: main calculation, 2: hard shadow postcalc, 3: AO1, 4: AO2, 5: AO3, 6: BGshadow, 7: DOF
    iAllProcessingOptions: Integer;
    iTotalThreadCount: Integer;
    pLBcalcStop: PLongBool;
    pMessageHwnd: HWND;
    cCalcTime: Cardinal;
    ctCalcRect: TRect;    //40bytes to here
    HandleType: Integer;                  //+4   for threadboosting ..put it to iProcessingType?
    CTSid: Integer;                       //+4   to identify a specific record
    CTrecords: array[1..64] of TCTrecord; //40*64 bytes  2560
    CThandles: array[1..64] of Pointer;   //4*64 bytes   256       = 2864 Bytes total
  end;
  TPCalcThreadStats = ^TCalcThreadStats;

  TsingleIteration = procedure(var x, y, z: Double);
  ThybridIteration2 = procedure(var x, y, z, w: Double; PIteration3D: Pointer); //only because of dependencies to the original
  TFormulaInitialization = procedure(PIteration3D: Pointer);
  TPFormulaInitialization = ^TFormulaInitialization;
  TIFSIteration = procedure;
  TLMSfunction  = function (PVec3D: TPVec3D; MapNr: Integer): TVec3D;

  TIteration3Dext = packed record
    J4:         Double;     //-56   4d extension         FastMove(dJUx, It3Dex.J1, 168);
    Rold:       Double;     //-48   used by m3d, equals Rout
    RStopD:     Double;     //-40   used by m3d for sse2, not always a valid value in here, in IFS: absDEstop
    x:          Double;     //-32   vector to iterate   -120 in dIFS esi
    y:          Double;     //-24
    z:          Double;     //-16
    w:          Double;     //-8
    C1, C2, C3: Double;     //0     input start values before 4d rotation, C4 is 0.  Do Not Change!
    J1, J2, J3: Double;     //+24   julia start values or the pixelpos, these are the constants to add
    PVar:       Pointer;    //+48   pointer to the user input values (decreasing offset, -8 is always val 0.5) + constants (incr. offset, 0 and above)
    SmoothItD:  Single;     //+52
    Rout:       Double;     //+56   the square of the current vector length, calced in m3d, in dIFS: rel DEout
    ItResultI:  Integer;    //+64   integer iteration count, increased by loop function in m3d
    maxIt:      Integer;    //+68
    RStop:      Single;     //+72   for dIFS: bool for insiderendering -> DEcomb with usual bulb needs RStop!!
    {$ifdef ENABLE_EXTENSIONS}
    unused_nHybrid:    array[0..V18_FORMULA_COUNT - 1] of Integer;  //+76 Hybrid counts / weight in interpolhybrid
    unused_fHPVar:     array[0..V18_FORMULA_COUNT - 1] of Pointer;  //+100 pointer to constants+vars, PVars-8=0.5, PVars->fHPVar[0]! dOptions below -8
    unused_fHybrid:    array[0..V18_FORMULA_COUNT - 1] of ThybridIteration2; //+124       fcustomIt -> fHybrid[0]!
    {$else}
    nHybrid:    array[0..V18_FORMULA_COUNT - 1] of Integer;  //+76 Hybrid counts / weight in interpolhybrid
    fHPVar:     array[0..V18_FORMULA_COUNT - 1] of Pointer;  //+100 pointer to constants+vars, PVars-8=0.5, PVars->fHPVar[0]! dOptions below -8
    fHybrid:    array[0..V18_FORMULA_COUNT - 1] of ThybridIteration2; //+124       fcustomIt -> fHybrid[0]!
    {$endif}
    CalcSIT:    ByteBool;   //+148   Bool + more options
    bFree:      Byte;       //+149
    EndTo:      Word;       //+150
    DoJulia:    LongBool;   //+152
    LNRStop:    Single;     //+156
    DEoption:   Integer;    //+160
    {$ifdef ENABLE_EXTENSIONS}
    unused_fHln:       array[0..V18_FORMULA_COUNT - 1] of Single;  //+164  for SmoothIts
    {$else}
    fHln:       array[0..V18_FORMULA_COUNT - 1] of Single;  //+164  for SmoothIts
    {$endif}
    iRepeatFrom: Word;      //+188
    iStartFrom: Word;       //+190
    OTrap:      Double;     //+192    calced by m3d, minimum vector length in dIFS
    VaryScale:  Double;     //+200    to use in vary by its or in dIFS as absScale
    bFirstIt:   Integer;    //+208    used also as iteration count, is set to 0 on it-start
    bTmp:       Integer;    //+212    (used for formula count), dIFS: minDE iteration
    Dfree1:     Double;     //+216    OTrap coloring in dIFS: formula can store a value 0..8 (*4096=15bit)
    Dfree2:     Double;     //+224
    Deriv1:     Double;     //+232    for 4D first deriv or as full derivs   in 4D func with DE: parse old 3d DE from w to here and back in each it!
    Deriv2:     Double;     //+240
    Deriv3:     Double;     //+248
    SMatrix4:   TSMatrix4;  //+256    matrix for 4d rotation, used by m3d
    Ju1,Ju2,Ju3,Ju4: Double; //+320   original Julia values, in case J1 to J4 are changed     eax                edx            ecx
    PMapFunc:   TLMSfunction;//+352   pointer to a map function: function GetMapPixelSphere(PVec3D: TPVec3D; MapNr: Integer): TVec3D;
    PMapFunc2:  TLMSfunction;//+356   pointer to 2nd map function, PVec3D: X,Y double used to get direct pixel in range 0..1
    {$ifdef ENABLE_EXTENSIONS}
    unused_pInitialization: array[0..V18_FORMULA_COUNT - 1] of TFormulaInitialization; //+360  pointer to initialization function
    {$else}
    pInitialization: array[0..V18_FORMULA_COUNT - 1] of TFormulaInitialization; //+360  pointer to initialization function
    {$endif}
    bIsInsideRender: LongBool; //+384 for dIFS to calc always all iters when inside
    OTrapMode:  Integer; //+388
    OTrapDE:    Double;  //+392
    {$ifdef ENABLE_EXTENSIONS}
    nHybrid:    array[0..MAX_FORMULA_COUNT - 1] of Integer;  //+400 Hybrid counts / weight in interpolhybrid
    fHPVar:     array[0..MAX_FORMULA_COUNT - 1] of Pointer;  //+424 pointer to constants+vars, PVars-8=0.5, PVars->fHPVar[0]! dOptions below -8
    fHybrid:    array[0..MAX_FORMULA_COUNT - 1] of ThybridIteration2; //+448       fcustomIt -> fHybrid[0]!
    fHln:       array[0..MAX_FORMULA_COUNT - 1] of Single;  //+472  for SmoothIts
    pInitialization: array[0..MAX_FORMULA_COUNT - 1] of TFormulaInitialization; //+496  pointer to initialization function
    {$endif}

 //   maxIt2:     Integer;     //for DEcomb with different Maxits
 //   DEoption2:  Integer;
//    dWadd4dstep: Double;
  end;
  TPIteration3Dext = ^TIteration3Dext;
  TIteration3D = packed record
    C1, C2, C3: Double;     //
    J1, J2, J3: Double;     //+24    Julia start Values, now: C
    PVar:       Pointer;    //+48
    SmoothItD:  Single;     //+52          in IFS
    Rout:       Double;     //+56    DEout in IFS as Single? +60=minDE? SSE:minss
    ItResultI:  Integer;    //+64
    maxIt:      Integer;    //+68
    RStop:      Single;     //+72    DEstop in IFS
    {$ifdef ENABLE_EXTENSIONS}
    unused_nHybrid:    array[0..V18_FORMULA_COUNT - 1] of Integer;  //+76 Hybrid counts / weight in interpolhybrid
    unused_fHPVar:     array[0..V18_FORMULA_COUNT - 1] of Pointer;  //+100 pointer to constants+vars, PVars-8=0.5, PVars->fHPVar[0]! dOptions below -8
    unused_fHybrid:    array[0..V18_FORMULA_COUNT - 1] of ThybridIteration2; //+124       fcustomIt -> fHybrid[0]!
    {$else}
    nHybrid:    array[0..V18_FORMULA_COUNT - 1] of Integer;  //+76 Hybrid counts / weight in interpolhybrid
    fHPVar:     array[0..V18_FORMULA_COUNT - 1] of Pointer;  //+100 pointer to constants+vars, PVars-8=0.5, PVars->fHPVar[0]! dOptions below -8
    fHybrid:    array[0..V18_FORMULA_COUNT - 1] of ThybridIteration2; //+124       fcustomIt -> fHybrid[0]!
    {$endif}
    CalcSIT:    LongBool;   //+148
    DoJulia:    LongBool;   //+152
    LNRStop:    Single;     //+156
    DEoption:   Integer;    //+160     type of used DE function for analytic calculation, (or options for IFS like in/out rendering)
    {$ifdef ENABLE_EXTENSIONS}
    unused_fHln:       array[0..V18_FORMULA_COUNT - 1] of Single;  //+164  for SmoothIts
    {$else}
    fHln:       array[0..V18_FORMULA_COUNT - 1] of Single;  //+164  for SmoothIts
    {$endif}
    iRepeatFrom: Integer;   //+188
    OTrap:      Double;     //+192
    VaryScale:  Double;     //+200    to use in vary by its, in IFS: absScale in Single, set to 1 on start.. scale in it
    bFirstIt:   Integer;    //+208
    bTmp:       Integer;    //+212    tmpBuf, free of use.  To align following Double values
    Dfree1:     Double;     //+216
    Dfree2:     Double;     //+224
    Deriv1:     Double;     //+232    for 4d DE
    Deriv2:     Double;     //+240
    Deriv3:     Double;     //+248
    {$ifdef ENABLE_EXTENSIONS}
    dummy: array[0..35] of Integer; // 256
    nHybrid:    array[0..MAX_FORMULA_COUNT - 1] of Integer;  //+400 Hybrid counts / weight in interpolhybrid
    fHPVar:     array[0..MAX_FORMULA_COUNT - 1] of Pointer;  //+424 pointer to constants+vars, PVars-8=0.5, PVars->fHPVar[0]! dOptions below -8
    fHybrid:    array[0..MAX_FORMULA_COUNT - 1] of ThybridIteration2; //+448       fcustomIt -> fHybrid[0]!
    fHln:       array[0..MAX_FORMULA_COUNT - 1] of Single;  //+472  for SmoothIts
    {$endif}
  end;
  TPIteration3D = ^TIteration3D;
  ThybridIteration = procedure(var x, y, z, w: Double; PIteration3D: TPIteration3D);
  TPhybridIteration = ^ThybridIteration;
  TMandFunction = procedure(PIteration3D: TPIteration3D);
  TMandFunctionDE = function(PIteration3D: TPIteration3D): Double;

  TLightMap = packed record   //full geographic representation of ambient light, like background image
    LMnumber:     Integer;    //number of loaded Lightmap, no need to load it again if number is equal. Must be initialized with 0
    LMframe:      Integer;    //number of loaded frame of animated Lightmaps
    LMWidth:      Integer;    //+3 pixel for interpolation
    LMHeight:     Integer;    //..same
    sLMXfactor:   Single;     //to get the pixel coordinates from arcsin's etc
    sLMYfactor:   Single;
    iLMstart:     Integer;    //start address of lightmap (@LMa[LMWidth + 1])
    sIntensity:   Single;     //light intensity
    iMapType:     Integer;    //change to MapType: 0: 32bit, 1: 48bit word precision
    LMavrgCol:    TSVec;      //average color for roughness color calc
    LMavrgColSqr: TSVec;      //for paintthreadsqr, same in sqr (0..255)
    PicRotMatrix: TSMatrix3;  //rotation matrix to get orientation of lightmap
    LMfilename:   array[0..23] of Byte; //to not load again
    LMa:          array of Cardinal;  //the lightmap, twice as much for 64bit
  end;
  TPLightMap = ^TLightMap;
  TLCol8 = packed record
    Position: Word;
    ColorDif: Cardinal;
    ColorSpe: Cardinal;       //transparency on byte4
  end;
  TICol8 = packed record
    Position: Word;
    Color:    Cardinal;       //transparency+Spec on byte4
  end;
  TLight8 = packed record
    Loption:    Byte;              // bit1: 0: On  1: Off;  bit2: lightmap;  bit3 = bPosLight, bit4+5 = poslight visible+func, bit6 = global light rel to object, bit7 = HSon
    LFunction:  Byte;              // 4bit spec func + 2bit diff,  Spec expo = 8 shl (LFunction and $07), diff = (LFunction shr 4) and 3     ..+ 1 bit for extVisLight(s)?
    Lamp:       Word;              // Light amplitude for posLight -> exp 8bit shortint + 8bit byte mant for wide range! -> for all lights
    Lcolor:     TRGB;              // RGB 24bit
    LightMapNr: Word;              // 0: no LM, 1..32000: LMnr,  LM works as ambient light was byte, now with ..Ex as word!
    LXpos: Double7B;
    AdditionalByteEx: Byte;        // LVersionEx in Light[0] and DiffMapNrEx in Light[1], diffmap scale in Light[2], diff shadowing in Light[3], BGscale in Light[4]
    LYpos: Double7B;               //
    FreeByte: Byte;                // iColOnOT := 2 + (HLight.Lights[1].FreeByte and 3);  HLight.Lights[0].FreeByte for bgpic options
    LZpos: Double7B;               // HLight.Lights[2].FreeByte  iExModes   HLight.Lights[3].FreeByte: NoIpol
  end;                             // 32 Byte    (+72 byte for 4 lights, +136 byte for 6 lights, +200 byte for 8 lights)
  T6Lights = array[0..5] of TLight8;
  TP6Lights = ^T6Lights;
  TLight7 = packed record
    Loption:   Byte;               // 0: On  1: Off  2: BMP
    LFunction: Byte;               // 2bitLSB Spec + 2bit Diff msb   -> 4..255 Spec power 8LSB + 2bit diff
    Lcolor:    Cardinal;
    LXangle, LYangle: Integer;     // 14 Byte
  end;
  TLpreset20 = packed record
    AmbCol:    Cardinal;
    AmbCol2:   Cardinal;
    DepthCol:  Cardinal;
    DepthCol2: Cardinal;
    TB578pos:  array[0..2] of Integer;
    Version:   Integer;                 //
    Lights:    array[0..5] of TLight8;  //6*32 =192
    LCols:     array[0..9] of TLCol8;   //10*10=100
    ICols:     array[0..3] of TICol8;   //4*6  =24 = 316 +8*4=32 =348bytes
  end;
  TLpreset164 = packed record
    AmbTop, AmbBot, DepthCol, DepthCol2: Cardinal;
    ColDif:    array[0..3] of Cardinal;
    ColSpec:   array[0..3] of Cardinal;
    Lights:    array[0..1] of TLight7;
    TB578pos:  array[0..2] of Integer;
  end;
  TLpreset16 = packed record
    Cols:      array[1..9] of Cardinal;
    Lights:    array[0..3] of TLight7;
    DepthCol:  Cardinal;
    TB578pos:  array[0..2] of Integer;
    DepthCol2: Cardinal;
    Version:   Integer;              // v1: newAmbsh=fronttop+bot
  end;
  TPLpreset16 = ^TLpreset16;
  TLpreset15 = packed record
    Cols:      array[1..9] of Cardinal;
    Lights:    array[0..3] of TLight7;
    DepthCol:  Cardinal;
    TB578pos:  array[0..2] of Integer;
    DepthCol2: Cardinal;
  end;
  TLpreset14 = packed record
    Cols:     array[1..9] of Cardinal;
    Lights:   array[0..3] of TLight7;
    DepthCol: Cardinal;
    TB578pos: array[0..2] of Integer;
  end;
  TLightingParas9 = packed record     // 3: fog offset, 6: fog amplitude, 19:fog far offset->in tab[3] 2x Word    tbpos[7]: bit13+ 2bytes for diffmap offsetsXY
    VarColZpos:  Smallint;            // is trackbar -> smallint -32768..32767
    RoughnessFactor:          Byte;   // 0..255 = 0..1
    bColorMap:                Byte;   // colormap for diff, 0 = off ..MapNrEx: 2nd byte in: DiffMapNrEx@Light2                    use for BGscale?
    DynFogCol2:               TRGB;   //   vv bit2: DiffMap on normals  bit3: DiffMap relative to object bit 4: BGpic add light //bit4..8 free?
    AdditionalOptions:        Byte;   // bit1: Internal Gamma of 2;  bit8: convertBGpicTospherical (bit 5..7: fit border width on load 0..7) ->only 1 bit +1bits for ambient option small bgpic as ambient! +1
    TBpos: array[3..11] of Integer;   //.. use smallints instead = plus 18 bytes!     TBoptions: bit20: Smooth BGpic on load
    TBoptions:            Cardinal;   // 1-7.bit TB12pos; 8-14.bit TB13pos = interior col pos;  bit 15 = color cycling;  bit16: BGimageDirectCoord;  bit17 = fineAdjDown
    FineColAdj1, FineColAdj2: Byte;   // 2 bytes for 2 positions, \bit 21..23 = LVERSION;  bit 18 = Col on 2ndChoice;  bit19 = FarFog;  //Lver=3
    PicOffsetX, PicOffsetY:   Byte;   // 2 bytes BGPicOffsets     \bit 24..29 Gamma;  bit 30: AmbCol rel to object;  bit31+bit32: BackColFunction
    AmbCol:     TRGB;                 // LVersion=7 -> LVersionEx@Light[0]
    DynFogR:    Byte;
    AmbCol2:    TRGB;
    DynFogG:    Byte;
    DepthCol:   TRGB;                 // in Lights:
    DynFogB:    Byte;                 // AdditionalByteEx: LVersionEx in Light[0], DiffMapNrEx in Light[1], diffmap scale in Light[2], diff shadowing in Light[3], BGscale in Light[4]
    DepthCol2:  TRGB;                 // FreeByte: Lights[0].. for bgpic options, iColOnOT = 2+(Lights[1].. and 3), Lights[2].. for iExModes
    PicOffsetZ: Byte;                 //           BGscale in Lights[3] 0..255 = 1..256 (logarithmic: 256^(BGscale/255))?
    Lights: T6Lights;                 // Light sources                   6*32=192  260 bytes
    LCols: array[0..9] of TLCol8;     // Surface colors   100 bytes  (10 new cols with pos on palette, only spec and diff)
    ICols: array[0..3] of TICol8;     // Interior colors   24 bytes  (4 new cols)  384 bytes
    BGbmp: array[0..23] of Byte;      // Background image filename upto24chars     408 bytes!  todo: first byte=255 + seed + 0 for random generated intern images!
  end;
 { TLightingParas9o = packed record    // 3: fog offset, 6: fog amplitude, 19:fog far offset->in tab[3] 2x Word
    TBpos: array[1..11] of Integer;   // TBpos[2] ShortInt BGShadow;  TBpos[1]->ambCol[10]? -> Var col on Zpos! -1..3      ; bit20: Smooth BGpic on load
    TBoptions:           Cardinal;    // 1-7.bit TB12pos; 8-14.bit TB13pos = interior col pos;  bit 15 = color cycling;  bit16: BGimageDirectCoord;  bit17 = fineAdjDown
    TBfineColAdjust:     Cardinal;    // 2 bytes for 2 positions, + 2 bytes PicOffsets          bit 21..23 = Lversion;  bit 18 = Col on 2ndChoice;  bit19 = FarFog;  //Lver=3
    AmbCol, AmbCol2:     Cardinal;    // dynFogCol=bits25..32 of AC,AC2,DC     bit 24..29 Gamma;  bit 30: AmbCol rel to object;  bit31+bit32: BackColFunction
    DepthCol, DepthCol2: Cardinal;    // 17*4 = 68 bytes til here   ; picZoffset=bits25..32 of DC2
    Lights: array[0..5] of TLight8;   // Light sources                   6*32=192  260 bytes
    LCols: array[0..9] of TLCol8;     // Surface colors   100 bytes  (10 new cols with pos on palette, only spec and diff)
    ICols: array[0..3] of TICol8;     // Interior colors   24 bytes  (4 new cols)  384 bytes
    BGbmp: array[0..23] of Byte;      // Background image filename upto24chars     408 bytes!
  end;  }
  TPLightingParas9 = ^TLightingParas9;
  TLightingParas8 = packed record
    TBpos: array[1..11] of Integer;   // TBpos[2] ShortInt BGShadow;  TBpos[1]->ambCol[10]? -> Var col on Zpos! -1..3
    TBoptions: Integer;               // 1-7.bit TB12pos; 8-14.bit TB13pos = interior col pos;  bit 15 = color cycling; bit 16 = HScalculated; bit17 = fineAdjDown
    TBfineColAdjust: Cardinal;        // 2 bytes for 2 positions + 2 byte for depthcol2         bit 21..26 = Lversion?; bit 18 = Col on OTrap; bit19 = FarFog
    DepthCol: Cardinal;               //56byte                                  
    Cols: array[1..9] of Cardinal;    // Object Cols    (old paras)  (->9 new ambient cols?)       #92byte   or only 2 new ambient front colors!
    Lights: array[0..3] of TLight7;   // Light sources                                     4*14=56 #148byte
    LCols: array[0..9] of TLCol8;     // Surface colors   100 bytes  (10 new cols with pos on palette, only spec and diff)
    ICols: array[0..3] of TICol8;     // Interior colors   24 bytes  (4 new cols)                  #272byte
  end;                                // + make lookup tables for colors 0..32767
  TPLightingParas8 = ^TLightingParas8;
  TLightingParas7 = packed record
    TBpos: array[1..11] of Integer;
    TBoptions: Cardinal;              // 1+2.bit: SpecularFunction(^8,^16,^32,^64) 3+4.bit: DiffuseFunction + 5-11.bit TB12pos + 12-18:TB13 interior col)
    TBfineColAdjust: Cardinal;        // 2 Bytes for TBpos Start(8LSB) + Stop(8MSB) + Option fineDown(b17)
    DepthCol: Cardinal;
    Cols: array[1..9] of Cardinal;    // Object Cols
    Lights: array[0..3] of TLight7;
  end;
  TLightingParas = packed record
    TBpos: array[1..11] of Integer;   //-> 1..12 (11now)
    TBoptions: Cardinal;              // 1+2.bit: SpecularFunction(^8,^16,^32,^64) 3+4.bit: DiffuseFunction + 5-11.bit TB12pos + 12-18:TB13 interior col)
    TBfineColAdjust: Cardinal;        // 2 Bytes for TBpos Start(8LSB) + Stop(8MSB) + Option fineDown(b17)
    DepthCol: Cardinal;
    Cols: array[1..9] of Cardinal;    // diff1, spec1, amb1, diff2, spec2...
  end;
  TMCrecord = packed record
    Red, Green, Blue: TRGB;   //Each of them 24 bit: float 0..4 (-1..7)? stretched to 24 bit int
    Ysum, Ysqr: TRGB;         //15 bytes  ..U,V,Ysum instead... 3 bytes left for Zdepth as Word + Options as word
    RayCount: Word;                        //u,v as smallint + Zdepth as Cardinal?
    Zbyte: Byte;              //18 bytes
  end;
  TPMCrecord = ^TMCrecord;
  TMCrecordNew = packed record
    U, V: SmallInt;           //4 bytes -32.768..32.767  (* 0.001)
    Ysum, Ysqr: TRGB;         //10 bytes
    wRayCount: Word;          //12 bytes
    cZpos: Cardinal;          //16 bytes
    wStats: Word;             //18 bytes
  end;
  TPMCrecordNew = ^TMCrecordNew;
  TsiLight5 = packed record  //18 Byte
    NormalX:    SmallInt; // 3 normals
    NormalY:    SmallInt;
    NormalZ:    SmallInt;
    RoughZposFine: Word;  // 1 Byte Roughness + 1 Byte LSB Zpos for more precision
    Zpos:       Word;
    Shadow:     Word;     // DEcount 10bit + 6 Light HS only yes/no
    AmbShadow:  Word;
    SIgradient: Word;     // Smoothed Iteration gradient for coloring,  high bit set = inside color
    OTrap:      Word;     // coloring on OrbitTrap  todo: highest bit for in/outside marking?
  end; 
  TsiLight4 = packed record  //16 Byte (faster?)
    LightAngleX: Word;    // 3Ns->11bit+11bit+11bit(nx,ny,nz), Rough only 7bit
    LightAngleY: Word;
    RoughZposFine: Word;  // 1 Byte Roughness + 1 Byte LSB Zpos for more precision!
    Zpos:        Word;
    Shadow:      Word;    // Hard shadow or DEcount when not HScalced
    AmbShadow:   Word;
    SIgradient:  Word;    // Smoothed Iteration gradient for coloring
    OTrap:       Word;    // coloring on OrbitTrap
  end;
  TsiLight3 = packed record  //Navi light -> 3 normals + dotprod?
    LightAngleX: Word;
    LightAngleY: Word;
    Zpos:        Word;    // > 32767 = background
    Shadow:      Word;    // Hard shadow or DEcount when not HScalced
    AmbShadow:   Word;
    SIgradient:  Word;    // Smoothed Iteration gradient for coloring
  end;
  TsiLightOld = packed record
    LightAngleX: Single;
    LightAngleY: Single;
    Zpos:        Word;
    Shadow:      Word;
    AmbShadow:   Word;
    GSiteration: Word;
  end;
  TLValignedNavi = packed record
    sDepthCol, sDepthCol2: TSVec;
    sAmbCol: TSVec;                  //32
    sDynFogCol: TSVec;               //48
    sLCols:  array[0..2] of TSVec;   //64
    ColDif, ColSpe, ColInt: array[0..3] of TSVec;  //112  9svecs->12svecs +48 new 0..3  for more compatibility
  end;
  TPLValignedNavi = ^TLValignedNavi;
  TLValigned = packed record
    sDepthCol, sDepthCol2: TSVec;          // the only ones that do not urgently need to be aligned?
    sAmbCol, sAmbCol2: TSVec;        //32
    LN:     array[0..5] of TSVec;    //64      light vectors for global light, or  light positions for pos light
    sLCols: array[0..5] of TSVec;    //160
    ColDif, ColSpe: array[0..9] of TSVec; //256
    ColInt: array[0..3] of TSVec;    //576
    sDynFogCol: TSVec;               //640 + 16 = 656   ../4 = 164 single vals = 41 single vecs
    sDynFogCol2: TSVec;              //656 + 16 = 672   ../4 = 168 single vals = 42 single vecs
  end;
  TPLValigned = ^TLValigned;
  TPsiLightOld = ^TsiLightOld;
  TPsiLight3 = ^TsiLight3;
  TPsiLight4 = ^TsiLight4;
  TPsiLight5 = ^TsiLight5;

  TASCparameter = record
    aWidth, aHeight: Integer;
    aYStart, aYBlockStart: Integer;
    aYstep, aYEnd: Integer;
    aATlevelCount: Integer;
    aZScaleFactor: Single;
    aPsiLight: TPsiLight5;
    aThreadID: Integer;
    aZRThreshold: Single;
    aPCTS: TPCalcThreadStats;
    PATlevel: TPATlevel;
    PATmaxArr: TPAngMaxArrSI;
    aCurrentLevel: Integer;
    aCorrMul: Single;
    aZsub: Integer;
    aRcount: Integer;  //how many calculation times to reduce noise
    aBorderMirrorSize: Single;
  end;

  TPaintLightVals = packed record
    ViewVec: TSVec;        //for specLight calculation
    AbsViewVec: TSVec;     //16  for specLight and diff (poslight) calculation, posLight or absGlobalLights
    ObjPos: TSVec;         //32  rel to mid values as singles
    xPos, yPos: Single;    //48
    zPos, sFOVy: Single;   //56  rel Zpos to viewer for ColVar on Z
    PSmatrix: TPSMatrix3;  //64  points to normalizes SMatrix (vgrads) from paintparas
    iPlanarOptic: Integer; //68
    PlOpticZ: Single;      //72
    xOff: Single;          //76  0.5 or more for stereo left-eye
    CamPos: TSVec;         //80
    PreDepthCol: TSVec;    //96
 {   s1: Single; // = 1.0;   68 //constants for painting
    s2: Single; // = 0.00392156862745098;
    s3: Single; // = 0.01;  76
    s4: Single; // = -8191.0;
    s5: Single; // = 0.5;     84
    s255: Single; // = 255.0;
    s1em30: Single; // = 1e-30;   92
    d3: Double; // = 3.0518509476e-5;   96 }  
  end;
  TPPaintLightVals = ^TPaintLightVals;
  TLightValsNavi = packed record
    PLValignedNavi: TPLValignedNavi;  // 16 Bit aligned Pointer in the sObjectColBuffer at the end of record
    bColCycling: LongBool;       //
    bFarFog: LongBool;           //
    bGamma2: LongBool;           //
    bBlendDFog: LongBool;
    iBackBMP: Integer;           //new  bit1: use BGimage  bit2: direct coords
    BGLightMap: TPLightMap;
    pBGRotMatrix: TPSMatrix3;
    sColZmul: Single;            // var col on Z
    sZpos: Single;               // for var on Z, the corrected (linear) Zpos
    sDepth, sShadGr, sShad, sAmbShad: Single;    //   numbers for lightvals interpolation, -> 6 lights change
    sDiffuse, sCStart: Single;
    sCiStart, sCmul, sCimul: Single;   //72 bytes
    sXpos, sYpos: Single;
    iXangle: array[0..2] of Integer;
    iYangle: array[0..2] of Integer;
    bLightOption: array[0..2] of Byte;
    sLightFuncSpec: array[0..2] of Single;
    iLightFuncDiff: array[0..2] of Integer;
    AbsViewVec: TSVec;
    LColSbuf: array[0..20] of TSVec;         //18*16 bytes = 288 bytes +48
  end;
  TPLightValsNavi = ^TLightValsNavi;

  TCalcPixelColor = procedure(SL: PCardinal; PsiLight: TPsiLight5; PLVals: Pointer; PLV: TPPaintLightVals);
//  TCalcPixelColorWithoutSpec = function(SVcol: TPSVec; PsiLight: TPsiLight5; PLVals: Pointer; PLV: TPPaintLightVals): TSVec;

  TLightVals = packed record
    PLValigned:  TPLValigned;    // 16 Bit aligned Pointer to the LColBuffer at the end of record
    bColCycling: WordBool;       //#4
    bNoColIpol: WordBool;
    iColOnOT: Integer;           //#8 onOrbitTrap:1  onLightMap:2
    bFarFog:  WordBool;          //#12
    bVolLight: WordBool;
    sGamma:   Single;            //#16
    sColZmul: Single;            //#20 var col on Z
    sShadZ:   Single;            //#24
    sShadZmul: Single;           //#28
    sDepth, sShadGr, sShad, sAmbShad: Single; //#32
    sCStart, sCiStart, sCmul, sCimul: Single; //#48
    iLightOption: array[0..5] of Integer;     //#64    on/off
    sDiff, sSpec: Single;                     //#88
   // iBGpicAndDivOptions: Integer;           //#96    bit1: add the light, not blend BGpic  bit2: Blend DynFog, not add  bit6: BGforambientcol
    bDivOptions: Byte;            //used in calcSR for
    bAddBGlight: ByteBool;
    bDFogOptions: Byte;           //bit1: clampDFog  bit2: onlyAddLight
    bUseSmallBGpicForAmb: ByteBool;
    iHSenabled: array[0..5] of Integer;     //#100
    iHScalced: array[0..5] of Integer;      //#124
    iHSmask:   array[0..5] of Integer;      //#148
    iLightPos: array[0..5] of Integer;      //#172   bit1: posLight  bit2+3: visLsource func
    iLightAbs: array[0..5] of Integer;      //#196
    iLightPowFunc: array[0..5] of Integer;  //#220   new: changed to int again, ipol must be changed too!
    iLightFuncDiff: array[0..5] of Integer; //#244
    ColPos: array[0..9] of Integer;         //#268
    IColPos: array[0..3] of Integer;        //#308
    sCDiv: array[0..9] of Single;     //#324  for determining the lin ipol coeff to interpolate between colors at posX
    sICDiv: array[0..3] of Single;    //#364
    sLmaxL: array[0..5] of Single;    //#380  posLight lightstrength (for end of calculation)
    bBackBMP: LongBool;               //#404
    iGammaH: Integer;                 //#408  -1: gamma < 1  0: no gamma  1: gamma > 1
    bAmbRelObj: LongBool;             //#412
    sIndLightReflect: Single;         //#416
    sPosLightZpos: array[0..5] of Single;
    sPosLightXpos: array[0..5] of Single;
    sPosLightYpos: array[0..5] of Single;
    sPosLP:        array[0..5] of Single;        //todo: SoftShadows: array[0..5] of Single; //for each pixel calculation
    SortTab:       array[0..7] of Byte;
    LLightMaps:    array[0..5] of TPLightMap;
    BGLightMap: TPLightMap;
    BGsmallLM: TPLightMap;
    DiffColLightMap: TPLightMap;  //must be freed again...
    DCLMapOffX: Single;
    DCLMapOffY: Single;
    DCLMapRotSin: Single;
    DCLMapRotCos: Single;
    lvMapScale: Single;
    bYCcomb: LongBool;
    iKFcount: Integer;  //for interpolation purpose!
    iDfunc: Integer;    //Background color function
    bDirectImageCoord: LongBool;
    sDynFogMul: Single;
    lvCalcPixelColor: TCalcPixelColor;
    bCalcPixColSqr: LongBool;
    sRoughnessFactor: Single;
    sZZstmitDif: Single;
    ZposDynFog: Single;      //for SRcalculation, is different from plv.zpos, used by ColVarOnZ
    sObjLightDecreaser: Single;  //for SR calc, only decrease Object light, no fogs
    sAbsorpCoeff: Single;    //for SR calc, transmission absorption coeeficient for diffuse input color decreasing
    sStepWidth: Single;
    sDiffuseShadowing: Single;
    iExModes: Integer;     //mode2 for reflection simulation
    bScaleAmbDiffDown: LongBool; // for transmission inside calc, amb+diff downscaled by 1 - yofsvec(spec color)
    SRLightAmount: Single;
    lvMidPos: TVec3D;
    LColSbuf: array[0..42] of TSVec;
  end;
  TPLightVals = ^TLightVals;

  TPaintParameter = packed record
    ppWidth, ppHeight, ppYstart, ppYinc: Integer;
    ppSLstart, ppSLoffset: Integer;
    ppLocalCounter: Integer;
    ppThreadID:     Integer;
    PLVals:         TPLightVals;    //#32
    pPsiLight:      TPsiLight5;     //#36
    ppMessageHwnd:  Hwnd;           //#40
    ppPlanarOptic:  Integer;        //#44
    sFOVy:          Single;         //#48
    pVgrads:        TPMatrix3;      //#52
    Zcorr, ZcMul:   Double;         //#56
    ZZstmitDif, StepWidth: Double;  //#72
    BackDist:       Double;         //#88
    m:              TSMatrix3;      //#96   normalized rot matrix in Single
    ppPlOpticZ:     Single;         //#144
    ppPLoffset:     Integer;
    ppYplus, ppXplus: Integer;
    ppPaintWidth:   Integer;
    ppPaintHeight:  Integer;
    ppXOff:         Single;
  end;
  TMCPaintParameter = packed record
    pWidth, pHeight: Integer;
    pSLstart, pSLoffset: Integer;
    pPsiLight:     TPsiLight5;
    pSContrast:    Single;
    pSGamma:       Single;
    pSaturation:   Single;
    pIgamma:       Integer;
    pMessageHwnd:  Hwnd;
    pLocalCounter: Integer;
    pPLoffset:     Integer;
    pSoftClip:     LongBool;
    defCol:        Cardinal;
  end;
  TBufDEcomb = packed record
    bufIt3DItResultI: Integer;
    bufIt3DSmoothItD: Single;
    bufIt3DOtrap: Double;
    bufVec3D: TVec3D;
    bufMCTmaxItsResult: Integer;
    bufMCTdDEscale: Single;
    bufMCTCalcSIT: LongBool;
    bufMCTMandFunction: TMandFunction;
    bufMCTMandFunctionDE: TMandFunctionDE;
  end;
  TPBufDEcomb = ^TBufDEcomb;
  TCaldDEfunction = function (It3Dex: TPIteration3Dext; mctp: Pointer {PMCTparameter}): Double;
  TMCTparameter = packed record    //MainCalcThread values
    iMinIt:           Integer;
    iMandWidth:       Integer;
    iThreadId:        Integer;
    FOVy:             Double;      //#12
    Xmit, Ymit, Zmit: Double;
    iSmNormals:       Word;       //#44
    IsCustomDE:       WordBool;
    mPsiLight:        TPsiLight5;
    msDEstop:         Single;
    sZstepDiv:        Single;
    iDEAddSteps:      Integer;
    pIt3Dext:         TPIteration3Dext;  //#64
    iMandHeight:      Integer;
    CalcDE:           TCaldDEfunction;
    PLVals:           TPLightVals;
    mctDEstopFactor:  Single;
    mctDEoffset:      Single;
    mctMH04ZSD:       Single;
    DEstop:           Single;
    sStepWm103:       Single;
    mZZ:              Double;
    mMandFunction:    TMandFunction;
    mMandFunctionDE:  TMandFunctionDE;
    FormulaType:      Integer;     //DEcombination mode  0: disable  1: min  2: max  3: avg   6:
    dDEscale2:        Single;
    Vgrads:           TMatrix3;
    StepWidth, Zend:  Double;      //Single?
    dCOX, dCOY, dCOZ: Double;
    dDEscale:         Single;
    dColPlus:         Single;
    Ystart:           TVec3D;  //->Campos
    HSvecs:           array[0..5] of TVec3D;  //put into HS calc threads?   VGradsFOV instead here?  + pointer to Iteration3Dext
    CAFX, CAFY:       Double;     //$1A0?
    PCalcThreadStats: TPCalcThreadStats;
    bVaryDEstop:      WordBool;
    NormalsOnDE:      WordBool;   //-> pointer to RMCalcNormals procedure
    pSiLight:         Pointer;    //pointer to begin of the SiLight array
    IsCustomDE1:      LongBool;
    IsCustomDE2:      LongBool;  //new for DEcomb hybrid
    ColorOption:      Byte;      //was: Integer;
    ColorOnIt:        Byte;
    DFogOnIt:         Word;
    sRoughness:       Single;    //$1CC   for normals calculation
    DEoption2:        Integer;   //$1D0
    mMandFunction2:   TMandFunction; //$1D4 new for DEcomb hybrid + IFS  , UP TO HERE DO NOT CHANGE OR ADD PARAMETER!!!!
    mMandFunctionDE2: TMandFunctionDE;
    MaxItsResult:     Integer;
    iMaxitF2:         Integer;
    mVgradsFOV:       TVec3D;    //$1e0  
    DEoptionResult:   Integer;
    iSliceCalc:       Integer;
    FOVXoff:          Single;    //for FOV calc, replaces 0.5 * iMandWidth in: CAFX := (0.5 * iMandWidth - ix) * FOVy / iMandHeight;
    FOVXmul:          Single;
    msDEsub:          Single; //= MinCS(0.9,  Sqrt(sZstepDiv));
    calcHardShadow:   Integer;     //was:#76   -> + option for 1HSsoft
    NaviStep, SLwidMNpix: Integer;   //for Navigator
    PLValsNavi:       TPLightValsNavi;
    iCutOptions:      Integer;
    MCTCameraOptic:   Integer;
    bMCTFirstStepRandom: LongBool;
    mctPlOpticZ:      Single;
    mctsM:            Single;
    mctColVarDEstopMul: Single;
    mctColorMul:      Single;
    iThreadCount:     Integer;
    FSIstart:         Integer;    //points to start of intern image cardinal array
    FSIoffset:        Integer;
    bMCTisValid:      LongBool;
    pCalcNormals:     Pointer;//TCalculateNormalsFunc;
    calc3D:           LongBool;
    sHSmaxLengthMultiplier: Single;
    SoftShadowRadius: Single;
    sZZstmitDif:      Single;
    DEAOmaxL:         Single;
    AOdither:         Integer;
    bCalcAmbShadow:   LongBool;
    CalcRect:         TRect;      //rect of calculation, the calculation includes the corners of the rect.
    SLoffset:         Integer;    //one row byte offset for SiLight array, when tiling it is smaller than width of image
    ZcMul:            Double;
    Zcorr:            Double;
    sDEcombSmooth:    Single;
    bInsideRendering: LongBool;
    bCalcInside:      LongBool;
    bInAndOutside:    LongBool;
    bIsIFS:           LongBool;   //for calcAmbshDE + inside
    DEmixCol:         Integer;
    FmixPow:          Single;
    RepeatFrom2:      Word;
    StartFrom2:       Word;
    iEnd2:            Integer;
    VLmul:            Single;     //for volumic light maps
    VLstepmul:        Single;
    Rstop3D:          Single;     // Sqr(It3Dex.RStop) * 64
    mctDEoffset006:   Single;
   // sZstepDiv2:       Single;     //test

    dJUw:             Double;
    dJUx, dJUy, dJUz: Double;     //+24    Julia start Values  copy from here to RepeatFrom from MCTparas = 168 byte
    pAl16vars:        Pointer;    //+48
    sPlaceholder:     Single;     //+52
    sPlaceholder2:    Double;     //+56
    iPlaceHolder:     Integer;    //+64
    iMaxIt:           Integer;    //+68
    dRStop:           Single;     //+72
    nHybrid:          array[0..MAX_FORMULA_COUNT - 1] of Integer;  //+76 Hybrid counts
    fHPVar:           array[0..MAX_FORMULA_COUNT - 1] of Pointer;  //+100 + 104 pointer to constants+vars, PVars-8=0.5, PVars->fHPVar[0]! dOptions below -8
    fHybrid:          array[0..MAX_FORMULA_COUNT - 1] of ThybridIteration2; //+124  + 104 + 104     fcustomIt -> fHybrid[0]!
    bCalcSIT:         ByteBool;   //+148   Bool + more options
    bFree:            Byte;       //+149
    wEndTo:           Word;       //+150
    bDoJulia:         LongBool;   //+152
    dLNRStop:         Single;     //+156
    DEoption:         Integer;    //+160    RepeatFrom2, EndTo
    fHln:             array[0..MAX_FORMULA_COUNT - 1] of Single;  //esi+164
    RepeatFrom1:      Word;       //+188
    StartFrom1:       Word;
    Smatrix4d:        TSmatrix4;
    pInitialization:  array[0..MAX_FORMULA_COUNT - 1] of TFormulaInitialization;
  //  DEoption2:        Integer;
 //   dWadd4dstep:      Double;
  end;
  PMCTparameter = ^TMCTparameter;

  TCalculateNormalsFunc = procedure(pMCTparas: PMCTparameter; var NN: Single);

  TRaymarchRec = record
    PMCTparas: PMCTparameter;
    PIt3Dex: TPIteration3Dext;
    ActPos, MarchVec, VievVec: TVec3D;
    ActZpos, StartDEstop, ZZposMul, DEmulVary, DEmulConst, MaxRayLength, Zstepped: Double;
    BinSteps, seed, RMresult: Integer;         //result: 0: no object  1: object on DE 2: object on Itcount  3: Outside again?
    StepCount, StepForward: Single;  //on start: 0/1/2 = outside/insideConstStep/insideDIFSDE?
  end;
  TPRaymarchRec = ^TRaymarchRec;

  TMandHeader11 = packed record       //Main parameters for storing/loading
    MandId: Integer;                  //or byte + 3 free bytes
    Width, Height, Iterations: Integer; // MandId, Iterations could be Word?
    iOptions: Word;                   // iOptions: SmoothNs: (SpinEdit2.Value shl 6) or FirstStepRandom=bit1 or StepSubDEstop=bit3
    bNewOptions: Byte;                // bit1: Quaternion instead of RotationMatrix! bit2: color on it nr:
    bColorOnIt: Byte;                 //0: disabled 1: outputvec:=inputvec (1)2..255 iterate n-1 times + docolor
    dZstart, dZend: Double;           //#20
    dXmid, dYmid, dZmid: Double;      //#36
    dXWrot, dYWrot, dZWrot: Double;   //#60     4D rotation
    dZoom, RStop: Double;             //#84
    iReflectsCalcTime: Integer;       //#100  in MCmode: OldAvrgRayCount
    sFmixPow: Single;                 //#104  for formula DE Mix combs
    dFOVy: Double;                    //#108  in single? (added 4 bytes)
    sTRIndex: Single;                 //#116  for transmission calculation
    sTRscattering: Single;            //#120  light scattering amount
    MCoptions: Byte;                  //#124  bit1: HDR   bit2: bSecantSearch  bit3: autoclipS+D  bit5..7: DoFbokeh  bit8: newMCrecordYUV
    MCdiffReflects: Byte;             //#125  D2Byte 0.00 .. 2.50  reflects diffusity         bit4: aa box/gauss
    bStereoMode: Byte;                //#126  0: no  1: very left  3:right  4:left
    bSSAO24BorderMirrorSize: Byte;    //#127  0 to 0.5
    iAmbCalcTime: Integer;            //#128
    bNormalsOnDE: Byte;               //#132
    bCalculateHardShadow: Byte;       //#133  calc automatic=bit1,  setLdifFuncToCos=bit2   + 6 bits yes/no of light1-6
    bStepsafterDEStop: Byte;          //#134  = bin search
    MinimumIterations: Word;          //#135  -> word is enough + 2bytes (no down compatibility)
    MClastY: Word;                    //#137
    bCalc1HSsoft: Byte;               //#139  -> bCalc1HSsoft, option to calculate only 1 HS but 6 bit as amount
    iAvrgDEsteps, iAvrgIts: Integer;  //#140  val * 10
    bPlanarOptic: Byte;               //#148  camera planar optic:0/1  /2: spherePano  ..3: dome?
    bCalcAmbShadowAutomatic: Byte;    //#149  bit1: yes/no, bit2: kindof: threshold maxclip/thr. down to 0  bit3+4: type(0:15bit,1:24bit,2:24bit rand,3:DEAO)
    sNaviMinDist: Single;             //#150  necessary?                                                              bit5+6(+7): DE raycount (3,7,17,33),  bit8: FSR (first step random)
    dStepWidth: Double;               //#154  related to zoom
    bVaryDEstopOnFOV: Byte;           //#162
    bHScalculated: Byte;              //#163     if it was calculated,  6 bits yes/no of light1-6  = bit 3..8
    sDOFZsharp, sDOFclipR: Single;    //#164
    sDOFaperture: Single;             //#172
    bCutOption: Byte;                 //#176
    sDEstop: Single;                  //#177
    bCalcDOFtype: Byte;               //#181   0: dont calc, bit 2+3: passes bit4: function sorted/forward
    mZstepDiv: Single;                //#182
    MCDepth: Byte;                    //#186
    SSAORcount: Byte;                 //#187
    AODEdithering: Byte;              //#188
    bImageScale: Byte;                //#189
    bIsJulia: Byte;                   //#190
    dJx, dJy, dJz, dJw: Double;       //#191  Julia vals
    bDFogIt: Byte;                    //#223
    MCSoftShadowRadius: ShortFloat;   //#224
    HSmaxLengthMultiplier: Single;    //#226
    StereoScreenWidth: Single;        //#230
    StereoScreenDistance: Single;     //#234
    StereoMinDistance: Single;        //#238
    sRaystepLimiter: Single;          //#242
    hVGrads: TMatrix3;                //#246   complete 3x3 matrix for navigating, can change to Quaternion if wNewOptions and 1
    bMCSaturation: Byte;              //#318
    sAmbShadowThreshold: Single;      //#319   z/r
    iCalcTime: Integer;               //#323   Seconds * 10
    iCalcHStime: Integer;             //#327
    byCalcNsOnZBufAuto: Byte;         //#331
    SRamount: Single;                 //#332   Amount of reflection light
    bCalcSRautomatic: Byte;           //#336   bit1 auto,  bit2 trans, bit3 only dIFS
    SRreflectioncount: Byte;          //#337
    sColorMul: Single;                //#338   multiplier for color option 'last vectorlength increase'
    byColor2Option: Byte;             //#342
    bVolLightNr: Byte;                //#343   was: byRepeatFrom -> in HAddon  lower 3(4)bits: lightnr, upper 4 bits: mapsize +/-7 in 20% steps
    bCalc3D: Byte;                    //#344
    bSliceCalc: Byte;                 //#345
    dCutX, dCutY, dCutZ: Double;      //#346
    sTransmissionAbsorption: Single;  //#370
    sDEAOmaxL: Single;                //#374
    sDEcombS: Single;                 //#378  DEcombAvrg absolute smooth distance;  was: pointer to a custom formula.. obsolete
    PHCustomF: array[0..MAX_FORMULA_COUNT-1] of Pointer;//#382  must not be here, 24(28) bytes free - just 1 pointer to formulastruct would be enough
    PCFAddon: Pointer;                //#510  pointer to the Header Addon for the customF's data, must also not be here
    sDOFZsharp2: Single;              //#514  ->2nd focuspoint                  \.. be used to store username in here! 28Bytes
    iMaxIts: Integer;                 //#518  in statistics                     \.. 1 original author, 2nd author 14 bytes * 8/7bits
    iMaxItsF2: Integer;               //#522  DEcomb maxits for formula 2
    DEmixColorOption: Byte;           //#526
    MCcontrast: Byte;                 //#527
    sM3dVersion: Single;              //#528
    TilingOptions: Integer;           //#532  in MCmode: OldAvrgSqrNoise as Single
    Light: TLightingParas9;           //#536  +408 = 944 bytes
  end;
  TPMandHeader11 = ^TMandHeader11;
  TMandHeader10 = packed record       //Main parameters for storing/loading
    MandId: Integer;                  //or byte + 3 free bytes
    Width, Height, Iterations: Integer; // MandId, Iterations could be Word?
    iOptions: Word;                   // iOptions: SmoothNs: (SpinEdit2.Value shl 6) or FirstStepRandom=bit1 or StepSubDEstop=bit3
    bNewOptions: Byte;                // bit1: Quaternion instead of RotationMatrix! bit2: color on it nr:
    bColorOnIt: Byte;                 //0: disabled 1: outputvec:=inputvec (1)2..255 iterate n-1 times + docolor
    dZstart, dZend: Double;           //#20
    dXmid, dYmid, dZmid: Double;      //#36
    dXWrot, dYWrot, dZWrot: Double;   //#60     4D rotation
    dZoom, RStop: Double;             //#84
    iReflectsCalcTime: Integer;       //#100  in MCmode: OldAvrgRayCount
    sFmixPow: Single;                 //#104  for formula DE Mix combs
    dFOVy: Double;                    //#108  in single? (added 4 bytes)
    sTRIndex: Single;                 //#116  for transmission calculation
    sTRscattering: Single;            //#120  light scattering amount
    MCoptions: Byte;                  //#124  bit1: HDR   bit2: bSecantSearch  bit3: autoclipS+D  bit5..7: DoFbokeh  bit8: newMCrecordYUV
    MCdiffReflects: Byte;             //#125  D2Byte 0.00 .. 2.50  reflects diffusity         bit4: aa box/gauss
    bStereoMode: Byte;                //#126  0: no  1: very left  3:right  4:left
    bSSAO24BorderMirrorSize: Byte;    //#127  0 to 0.5
    iAmbCalcTime: Integer;            //#128
    bNormalsOnDE: Byte;               //#132
    bCalculateHardShadow: Byte;       //#133  calc automatic=bit1,  setLdifFuncToCos=bit2   + 6 bits yes/no of light1-6
    bStepsafterDEStop: Byte;          //#134  = bin search
    MinimumIterations: Word;          //#135  -> word is enough + 2bytes (no down compatibility)
    MClastY: Word;                    //#137
    bCalc1HSsoft: Byte;               //#139  -> bCalc1HSsoft, option to calculate only 1 HS but 6 bit as amount
    iAvrgDEsteps, iAvrgIts: Integer;  //#140  val * 10
    bPlanarOptic: Byte;               //#148  camera planar optic:0/1  /2: spherePano  ..3: dome?
    bCalcAmbShadowAutomatic: Byte;    //#149  bit1: yes/no, bit2: kindof: threshold maxclip/thr. down to 0  bit3+4: type(0:15bit,1:24bit,2:24bit rand,3:DEAO)
    sNaviMinDist: Single;             //#150  necessary?                                                              bit5+6(+7): DE raycount (3,7,17,33),  bit8: FSR (first step random)
    dStepWidth: Double;               //#154  related to zoom
    bVaryDEstopOnFOV: Byte;           //#162
    bHScalculated: Byte;              //#163     if it was calculated,  6 bits yes/no of light1-6  = bit 3..8
    sDOFZsharp, sDOFclipR: Single;    //#164
    sDOFaperture: Single;             //#172
    bCutOption: Byte;                 //#176
    sDEstop: Single;                  //#177
    bCalcDOFtype: Byte;               //#181   0: dont calc, bit 2+3: passes bit4: function sorted/forward
    mZstepDiv: Single;                //#182
    MCDepth: Byte;                    //#186
    SSAORcount: Byte;                 //#187
    AODEdithering: Byte;              //#188
    bImageScale: Byte;                //#189
    bIsJulia: Byte;                   //#190
    dJx, dJy, dJz, dJw: Double;       //#191  Julia vals
    bDFogIt: Byte;                    //#223
    MCSoftShadowRadius: ShortFloat;   //#224
    HSmaxLengthMultiplier: Single;    //#226
    StereoScreenWidth: Single;        //#230
    StereoScreenDistance: Single;     //#234
    StereoMinDistance: Single;        //#238
    sRaystepLimiter: Single;          //#242
    hVGrads: TMatrix3;                //#246   complete 3x3 matrix for navigating, can change to Quaternion if wNewOptions and 1
    bMCSaturation: Byte;              //#318
    sAmbShadowThreshold: Single;      //#319   z/r
    iCalcTime: Integer;               //#323   Seconds * 10
    iCalcHStime: Integer;             //#327
    byCalcNsOnZBufAuto: Byte;         //#331
    SRamount: Single;                 //#332   Amount of reflection light
    bCalcSRautomatic: Byte;           //#336   bit1 auto,  bit2 trans, bit3 only dIFS
    SRreflectioncount: Byte;          //#337
    sColorMul: Single;                //#338   multiplier for color option 'last vectorlength increase'
    byColor2Option: Byte;             //#342
    bVolLightNr: Byte;                //#343   was: byRepeatFrom -> in HAddon  lower 3(4)bits: lightnr, upper 4 bits: mapsize +/-7 in 20% steps
    bCalc3D: Byte;                    //#344
    bSliceCalc: Byte;                 //#345
    dCutX, dCutY, dCutZ: Double;      //#346
    sTransmissionAbsorption: Single;  //#370
    sDEAOmaxL: Single;                //#374
    sDEcombS: Single;                 //#378  DEcombAvrg absolute smooth distance;  was: pointer to a custom formula.. obsolete
    PHCustomF: array[0..5] of Pointer;//#382  must not be here, 24(28) bytes free - just 1 pointer to formulastruct would be enough
    PCFAddon: Pointer;                //#406  pointer to the Header Addon for the customF's data, must also not be here
    sDOFZsharp2: Single;              //#410  ->2nd focuspoint                  \.. be used to store username in here! 28Bytes
    iMaxIts: Integer;                 //#414  in statistics                     \.. 1 original author, 2nd author 14 bytes * 8/7bits
    iMaxItsF2: Integer;               //#418  DEcomb maxits for formula 2
    DEmixColorOption: Byte;           //#422
    MCcontrast: Byte;                 //#423
    sM3dVersion: Single;              //#424
    TilingOptions: Integer;           //#428  in MCmode: OldAvrgSqrNoise as Single
    Light: TLightingParas9;           //#432  +408 = 840 bytes
  end;
  TPMandHeader10 = ^TMandHeader10;
  TMandHeader9 = packed record
    MandId, Width, Height, Iterations, iOptions: Integer;
    dZstart, dZend      : Double;     //#20
    dXmid, dYmid, dZmid : Double;     //#36
    dXrot, dYrot, dZrot : Double;     //#60  obs..->VGrads
    dZoom, RStop, dPow  : Double;     //#84
    dFOVy: Double;                    //#108
    dHardLightZaxis, dHardLightXaxis: Double; //#116
    bColorOnGrad: Byte;               //#132
    bCalculateHardShadow: Byte;       //#133
    bStepsafterDEStop: Byte;          //#134 = smooth normals
    MinimumIterations: Integer;       //#135
    iThreadPriority: Byte;            //#139
    iAvrgDEsteps, iAvrgIts: Integer;  //#140  val * 10
    CalcBackgroundShadow: Shortint;   //#148  -128..127
    bCalcAmbShadowAutomatic: Byte;    //#149  bit1: yes/no, bit2: kindof: threshold maxclip/thr. down to 0
    sDEcolVar: Single;                //#150  //obs. now in Light.TBpos[1]
    dStepWidth: Double;               //#154
    bVaryDEstopOnFOV: Byte;           //#162
    bHScalculated: Byte;
    sDOFZsharp, sDOFradius, sDOFosize: Single;   //#164
    bCutOption: Byte;                 //#176
    sDEstop: Single;                  //#177
    bCalcDOFtype: Byte;               //#181   0: dont calc, bit 2+3: passes bit4: function sorted/forward
    newBuffer2: array[0..6] of Byte;  //#182
    bImageScale: Byte;                //#189
    bIsJulia: Byte;
    dJx, dJy, dJz: Double;            //#191
    newBuffer3: array[0..30] of Byte; //#215
    hVGrads: TMatrix3;                //#246   NEW: complete 3x3 matrix for navigating, no need to convert back
    BGSoffset: Shortint;              //#318
    sAmbShadowThreshold: Single;      //#319   z/r
    iCalcTime: Integer;               //#323   Seconds * 10   +3verschieben->+26bytes=153 bytes
    newBuffer4: array[0..15] of Byte; //#327
    byRepeatFrom: Byte;               //#343
    bCalc3D: Byte;                    //#344
    bSliceCalc: Byte;                 //#345
    dCutX, dCutY, dCutZ: Double;      //#346
    newBuffer5: array[0..7] of Byte;  //#370
    PCustomF: Pointer;                //#378  pointer to a custom formula   obsolete
    PHCustomF: array[0..5] of Pointer;//#382
    PCFAddon: Pointer;                //#406  pointer to the Header Addon for the customF's data
    newBuffer6: array[0..21] of Byte; //#410
    Light: TLightingParas8;           //#432   +272 = 704 bytes
  end;
  TPMandHeader9 = ^TMandHeader9;
  TMandHeader8 = packed record
    MandId, Width, Height, Iterations, iOptions: Integer;
    dZstart, dZend      : Double;    //#20
    dXmid, dYmid, dZmid : Double;    //#36
    dXrot, dYrot, dZrot : Double;    //#60   -> CamVec[0..2] + somewhere:UpAngle
    dZoom, RStop, dPow  : Double;    //#84
    dFOVy: Double;                   //#108
    dHardLightZaxis, dHardLightXaxis: Double; //#116
    bColorOnGrad: Byte;              //#132
    bCalculateHardShadow: Byte;      //#133
    bStepsafterDEStop: Byte;         //#134 = smooth normals
    MinimumIterations: Integer;      //#135
    iThreadPriority: Byte;           //#139
    iAvrgDEsteps, iAvrgIts: Integer; //val * 10  #140
    CalcBackgroundShadow: Shortint;  //-128..127 #148
    bCalcAmbShadowAutomatic: Byte;   //          #149
    sDEcolVar: Single;            //was:  sAniStart  #150
    sAniStop, sAniStep: Single;   // obsolete       154
    bVaryDEstopOnFOV: Byte;       //was: bAniOption   162
    bHScalculated: Byte;
    sCutX, sCutY, sCutZ: Single;  // obsolete!        164
    bCutOption: Byte;                               //176
    sDEstop: Single;                                //177
    sBBmulBulb: Single;           // obsolete!      181
    sBBRbulb: Single;             // obsolete!      185
    bImageScale: Byte;                            //189
    bIsJulia: Byte;                               //190
    dJx, dJy, dJz: Double;                        //191
    dZmul: Double;                // obsolete!      215
    dMinR: Double;                // obsolete!      223
    iHformula: array[0..2] of Byte;   // obsolete!  Alt. hybrid -> addon  231
    iHcount: array[0..2] of Integer;  // obsolete! 0..5                   234
    dHPow: array[0..2] of Double;     // obsolete! =scale in box-> VGrads! 246
    dHZmul: array[0..2] of Double;    // obsolete!                        270
    dHMinR: array[0..2] of Double;    // obsolete!                        294
    BGSoffset: Shortint;              //127 bytes free for TMandHeader9!  318
    sAmbShadowThreshold: Single;      //z/r                               319
    iCalcTime: Integer;               //#323 Seconds * 10   +3verschieben->+26bytes=153 bytes
    obsoletebAniFileIndex: Byte;      //#327
    CustomFname: array[0..15] of Byte; //#328obsolete stay because for oldpar parsing
    bCalc3D: Byte;                    //#344
    bSliceCalc: Byte;                 //#345
    dCutX, dCutY, dCutZ: Double;      //#346 // new Cutting pars in double
    dCustomOption1: Double;           //#370  obsolete
    PCustomF: Pointer;                //#378  pointer to a custom formula   obsolete
    PHCustomF: array[0..5] of Pointer;//#382
    PCFAddon: Pointer;                //#406  pointer to the Header Addon for the customF's data
    newBuffer: array[0..21] of Byte;  //#410
    Light: TLightingParas8;           //#432
  end;
  TPMandHeader8 = ^TMandHeader8;
  TMandHeader4 = packed record
    MandId, Width, Height, Iterations, iOptions: Integer;
    dZstart, dZend      : Double;
    dXmid, dYmid, dZmid : Double;
    dXrot, dYrot, dZrot : Double;
    dZoom, RStop, dPow  : Double;
    Light: TLightingParas;
    dFOVy: Double;
    dHardLightZaxis, dHardLightXaxis: Double;
    bColorOnGrad: Byte;
    bCalculateHardShadow: Byte;
    bStepsafterDEStop: Byte;
    MinimumIterations: Integer;
    iThreadPriority: Byte;
    iAvrgDEsteps, iAvrgIts: Integer;
    CalcBackgroundShadow: Shortint;
    bCalcAmbShadowAutomatic: Byte;
    sAniStart, sAniStop, sAniStep: Single;
    bAniOption: Byte;
    bHScalculated: Byte;
    sCutX, sCutY, sCutZ: Single;
    bCutOption: Byte;
    newBuffer: array[0..2] of Byte;
  end;
  TMandHeaderOld = packed record
    MandId, Width, Height, Iterations, iOptions: Integer;
    dZstart, dZend      : Double;
    dXmid, dYmid, dZmid : Double;
    dXrot, dYrot, dZrot : Double;
    dZoom, RStop, dPow  : Double;
    Light: TLightingParas;
  end;
  TCustomFormula = record
    SIMDlevel:       Integer;    // 0: no simd, 1: SSE2, 2: SSE3, 4: SSSE3, 8: SSE4.1
    sOptionStrings:  array[0..15] of String;
    byOptionTypes:   array[0..15] of Byte;
    iCFOptionCount:  Integer;
    dDEscale:        Double;
    dADEscale:       Double;
    dSIpow:          Double;
    dRstop:          Double;
    iConstCount:     Integer;
    iDEoption:       Integer;
    iVersion:        Integer;
    pConstPointer16: Pointer;
    VarBuffer:       array of Byte;
    bCPmemReserved:  LongBool;
    pCodePointer:    TPhybridIteration;
    LastModTime:     TDatetime;
  //  LastCFloaded:    String;
  end;
  PTCustomFormula = ^TCustomFormula;
  THeaderCustomAddonOld = packed record
    iHCAversion:   Integer;
    iCustomCount:  Integer;
    iItCounts:     array[0..5] of Integer;
    iFormula:      array[0..5] of Integer;
    CustomFname:   array[0..5] of array[0..31] of Byte;
    dOptionValues: array[0..5] of array[0..15] of Double;
  end;
  THAformula = packed record
    iItCount:     Integer;                 //4
    iFnr:         Integer;                 //4    intern < 20 nr of formula, extern 20 or higher: CustomFname for identification
    iOptionCount: Integer;                 //4
    CustomFname:  array[0..31] of Byte;    //32
    byOptionType: array[0..15] of Byte;    //16
    dOptionValue: array[0..15] of Double;  //128
  end;                                     //=188bytes
  PTHAformula = ^THAformula;
  THeaderCustomAddon = packed record  //will be obsolete when doing a general formula hybridization
    bHCAversion: Byte;   //total itcount still in header!
    bOptions1:   Byte;   //type of hybrid: 0:alt  1:interpolhybrid  2:DEcombinated  3: (K/L?)IFS
    bOptions2:   Byte;   //bit1: Disable analytical DE bit2+3: 0: outside, 1: inside, 2: in+outside rendering; bit4(+5): map interpolation cos/bicubic
    bOptions3:   Byte;   //bit1+2+3  type of DEcombination
    iFCount:     Byte;   //for save as txt to spare chars..only if one array[0..5] of TFaddon
    bHybOpt1:    Byte;   //end1, repeat1            2x 4bit
    bHybOpt2:    Word;   //start2, end2, repeat2    3x 4bit
    Formulas:    array[0..MAX_FORMULA_COUNT - 1] of THAformula;  //=8+188*6=1136bytes
  end;
  PTHeaderCustomAddon = ^THeaderCustomAddon;
  THeaderCustomAddon10 = packed record  //will be obsolete when doing a general formula hybridization
    bHCAversion: Byte;   //total itcount still in header!
    bOptions1:   Byte;   //type of hybrid: 0:alt  1:interpolhybrid  2:DEcombinated  3: (K/L?)IFS
    bOptions2:   Byte;   //bit1: Disable analytical DE bit2+3: 0: outside, 1: inside, 2: in+outside rendering; bit4(+5): map interpolation cos/bicubic
    bOptions3:   Byte;   //bit1+2+3  type of DEcombination
    iFCount:     Byte;   //for save as txt to spare chars..only if one array[0..5] of TFaddon
    bHybOpt1:    Byte;   //end1, repeat1            2x 4bit
    bHybOpt2:    Word;   //start2, end2, repeat2    3x 4bit
    Formulas:    array[0..V18_FORMULA_COUNT - 1] of THAformula;  //=8+188*6=1136bytes
  end;
  PTHeaderCustomAddon10 = ^THeaderCustomAddon10;
  TBigRenderData = packed record
    brScale: Double;
    brWidth: Integer;
    brHeight: Integer;
    brTileCountH: Integer;
    brTileCountV: Integer;
    brTileWidth: Integer;
    brTileHeight: Integer;
    brDownScale: Integer;
    brOutputType: Integer;
    brScaleDEstop: LongBool;
    brSaveZBuf: LongBool;
    brSaveM3I: LongBool;
    brM3dVersion: Single;
    brJPEGqual: Integer;
    brSharp: Integer;
    brUseOrigAO: LongBool;
    brVersion: Integer;
    brRenderRowsFrom: Integer;
    brRenderRowsTo: Integer;
    brRenderRows: LongBool;
    brSingleFilenumber: LongBool;
    brFreeBuf: array[0..41] of Integer;
  end;
  EXECUTION_STATE = DWORD;   {$EXTERNALSYM EXECUTION_STATE}

//{$ALIGN 8}
const
  ES_SYSTEM_REQUIRED   = DWORD($00000001);   {$EXTERNALSYM ES_SYSTEM_REQUIRED}
  ES_DISPLAY_REQUIRED  = DWORD($00000002);   {$EXTERNALSYM ES_DISPLAY_REQUIRED}
  ES_USER_PRESENT      = DWORD($00000004);   {$EXTERNALSYM ES_USER_PRESENT}
  ES_AWAYMODE_REQUIRED = DWORD($00000040);   {$EXTERNALSYM ES_AWAYMODE_REQUIRED}
  ES_CONTINUOUS        = DWORD($80000000);   {$EXTERNALSYM ES_CONTINUOUS}
  Pi1d:     Double = 1 / Pi;
  MPi1d:    Double = -1 / Pi;
  Pi05d:    Double = 0.5 / Pi;
  MPi05d:   Double = -0.5 / Pi;
  Pid180:   Double = Pi / 180;
  MPid180:  Double = -Pi / 180;
  M180dPi:  Double = -180 / Pi;
  Pid16384: Double = Pi / 16384;
  M16384dPi: Double = 16384 / Pi;
  M16383dPi: Double = 16383 / Pi;
  Mi16383dPi: Double = -16383 / Pi;
  Mi32767dPi: Double = -32767 / Pi;
  enat:     Double = 2.7182818284590452353602874713527;
  piM2:     Double = 2 * Pi;
  LogC21d:  Double = 1.4426950408889634073599246810019;
  d1d256:   Double = 1 / 256; //0.00390625;
  s1d255:   Single = 1 / 255; //0.00392156862745098;
  s1d32767: Single = 1 / 32767;
  s1d32768: Single = 1 / 32768;
  sPiM025:  Single = Pi * 0.25;
  s1em30:   Single = 1e-30;
  s1em20:   Single = 1e-20;
  s1em10:   Single = 1e-10;
  s0001:    Single = 0.001;
  s001:     Single = 0.01;
  s1d3:     Single = 1 / 3;
  s1d63:    Single = 1 / 63;
  s002:     Single = 0.02;
  s005:     Single = 0.05;
  s006:     Single = 0.06;
  s011:     Single = 0.11;
  s025:     Single = 0.25;
  s03:      Single = 0.3;
  sm05:     Single = -0.5;
  s05:      Single = 0.5;
  s055:     Single = 0.55;
  s059:     Single = 0.59;
  s07:      Single = 0.7;
  s1:       Single = 1;
  sM1:      Single = -1;
  s3:       Single = 3;
  s7:       Single = 7;
  s255:     Single = 255;
  s1e30:    Single = 1e30;
  d005:     Double = 0.05;
  d1p0:     Double = 1;
  d1em40:   Double = 1e-40;
  dm1e40:   Double = -1e40;
  d1em100:  Double = 1e-100;
  d1em200:  Double = 1e-200;
//  d005:     Double = 0.05;
 // d025:     Double = 0.25;
  d1:       Double = 1;
  d7:       Double = 7;
  d255:     Double = 255;
  d32767:   Double = 32767;
  d65535:   Double = 65535;
  d1d65535: Double = 1 / 65535;
  d1d6:     Double = 1 / 6;
  dSeedMul: Double = 1 / $7FFFFFFF;
  dNearOne: Double = 0.9999999;
  dNearMinusOne: Double = -0.9999999;
//  cNeg:     Cardinal = $80000000;
  cTPrio:   array[0..4] of TTHreadPriority = (tpIdle, tpLowest, tpLower, tpNormal, tpHigher);
  WM_ThreadReady = WM_USER + 1;
  WM_ThreadStat = WM_USER + 2;
  cAbsSVec: array[0..3] of Integer = ($7FFFFFFF, $7FFFFFFF, $7FFFFFFF, $7FFFFFFF);
  cSVec0:   TSVec = (0,0,0,0);
  cSVec1:   TSVec = (1,1,1,0);
  cSVec1c4: TSVec = (1,1,1,1);
  cSVecX:   TSVec = (1,0,0,0);
  cSVecY:   TSVec = (0,1,0,0);
  cSVecZ:   TSVec = (0,0,1,0);
  cSVec255: TSVec = (255,255,255,0);
  cDVec0:   TVec3D = (0,0,0);
  CDouble7B0: Double7B = (0,0,0,0,0,0,0);

implementation

end.
