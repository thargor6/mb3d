unit CustomFormulas;

interface

uses DivUtils, SysUtils, FileHandling, TypeDefinitions, JITFormulas;

function LoadCustomFormulaFromHeader(var CustomFname: array of Byte;
                                     var lCustomFormula: TCustomFormula;
                                     var dOptionVars: array of Double): Boolean;
function LoadCustomFormula(FileName: String; var lCustomFormula: TCustomFormula;
  var CustomFname: array of Byte; var dOptionValues: array of Double; bVerbose: LongBool; MinModTime: TDatetime; ParseResult: TJITFormula): Boolean;
function AssignCustomFormula(CF1, CF2: PTCustomFormula): LongBool;
procedure FillCustomVBufWithVars(CF1: PTCustomFormula; dOptionValues: array of Double{;isAlt: LongBool});
procedure IniCustomF(CF: PTCustomFormula);
procedure FreeCF(CF: PTCustomFormula);
procedure ParseCFfromOld(iFormula: Integer; CF: PTCustomFormula;
                         dOptionValues: array of Double);
procedure MakeCustomFsFromHeader(Header: TMandHeader11{; isAlt: LongBool});
procedure SetCFoptionsFromOldF(f: Integer; CF: PTCustomFormula);
procedure CopyTypeAndOptionFromCFtoHAddon(CF: PTCustomFormula; HA: PTHeaderCustomAddon; fnr: Integer{; bLoadedPars: LongBool});
function CanLoadCustomFormula(FileName: String; var DEfunction: Integer): Boolean;
function CanLoadF(FormulaName: String): Boolean;
function Is4Dtype(Header: TPMandHeader11): LongBool;
function isInternFormula(FName: String; var i: Integer): LongBool;
function DescrOfFName(FName: String): String;
function SameFName(Fn1, Fn2: String): LongBool;
procedure ResetFormulas(HAddon: PTHeaderCustomAddon);
function isIntType(ftype: Integer): LongBool;
function isAngleType(ftype: Integer): LongBool;
procedure CheckHybridOptions(pHCA: PTHeaderCustomAddon);


var CFdescription: String;
    CFdescriptionIntern: array[0..9] of String = (
    'The triplex math sine bulb, as suggested by Daniel White and Paul Nylander.  These are fast implementions of powers of 2,3,4,5,6,7 and 8.'+
     #13#10+#13#10+'If you want to make an animation with smooth power changings, please use the ''Real Power'' formula.',
    'The sine bulb where arbitrary power values can be used, the calculation is slower than of integer powers.'+#13#10+#13#10+
      'r  = sqrt(x*x + y*y + z*z)'+#13#10+
      'th = ArcTan2(y, x) * Float_power'+#13#10+
      'ph = ArcSin(z/r) * Float_power'+#13#10+
      'r  = Power(r, Float_power)'+#13#10+
      'x  = r * cos(ph) * cos(th) + Cx'+#13#10+
      'y  = r * cos(ph) * sin(th) + Cy'+#13#10+
      'z  = Z_multiplier * r * sin(ph) + Cz',
    'A 4d quaternion formula, one iteration:'+#13#10+#13#10+
      'x'' = x*x - y*y - z*z - w*w + Cx'+#13#10+
      'y'' = 2*(y*x + z*w) + Cy'+#13#10+
      'z'' = 2*(z*x + YW_multiplier*y*w) + Cz'+#13#10+
      'w'' = 2*(w*x + y*z) + W_add + Cw',
    '', //Tricorn
    'The ''Amazing Box'' aka Mandbox formula, invented by TGlad at fractalforums.com.'+#13#10+#13#10+
    'The formula for one iteration looks like this:'+#13#10+#13#10+
      'x = abs(x+Fold) - abs(x-Fold) - x'+#13#10+
      'y = abs(y+Fold) - abs(y-Fold) - y'+#13#10+
      'z = abs(z+Fold) - abs(z-Fold) - z'+#13#10+
      'rr = x*x + y*y + z*z'+#13#10+
      'if rr < sqr(Min_R) then m = Scale/sqr(Min_R) else'+#13#10+
      'if rr < 1 then m = Scale/rr else m = Scale'+#13#10+
      'x = x * m + Cx'+#13#10+
      'y = y * m + Cy'+#13#10+
      'z = z * m + Cz',
    'A hybrid of a sine power 2 bulb and the amazing box, the 3d vector length decides which formula is used:'+#13#10+
    'If it is bigger than ''Box/Bulb R threshold'' the amazing box is used, else if smaller than ''..threshold 2'' the sine bulb,'+#13#10+
    'inbetween both formulas will be interpolated.  Make the second threshold a little smaller than the first for more smoothness.',
    'A sine integer power bulb with foldings before, like in the amazing box.', '', '',
    'A bulb formula as suggested by Aexion:'+#13#10+  //Aexion rotate c   [Power, Z mul, Enable RotC (0,1), Cond Phi (0,1), Power C, Cz mul]
    'http://www.fractalforums.com/the-3d-mandelbulb/iterating-c/'+#13#10#13#10+
    'Added two options to power-rotate the Constant by the distance of the current vectors of Z and C (Cond Phi=1),'+#13#10+
    'and the following Mode options:' +#13#10+
    '(Bits of Mode value)' +#13#10+
    'Bit1: Flip atan theta components' +#13#10+
    'Bit2: Flip atan phi components' +#13#10+
    'Bit3: Flip theta and phi' +#13#10+
    'Bit4: Flip CyCz for angle calc' +#13#10+
    'Bit5: Multiply powerC by the distance of vector Z and C');
  InternFNames: String = '.Integer Power.Real Power.Quaternion.Tricorn..Amazing Box.Bulbox.Folding Int Pow.test..testIFS....Aexion C.';
                         //2             17         28         39       48          60     67             83     89        100
  Fdescription: array of String;  //div11  1         2          3        4           5      6              7      8         9
  FdescrName: array of String;
  FdescrModTime: array of TDateTime;
  FdescCount: Integer = 0;
const
  actFormulaId: Integer = 8;

implementation

uses Mand, Math, Dialogs, Windows, Math3D, formulas, FormulaGUI, HeaderTrafos, FormulaCompiler, Classes;

procedure CheckHybridOptions(pHCA: PTHeaderCustomAddon);
var x, end1, repeat1, start2, end2, repeat2: Integer;
begin
    if (pHCA.bOptions1 and 3) = 1 then
    begin   //ipol hybrid
      end1 := 0;
      repeat1 := 0;
      start2 := 1;
      end2 := MAX_FORMULA_COUNT - 1;
      repeat2 := 1;
    end
    else
    begin
      x := MAX_FORMULA_COUNT - 1;
      while (x > 0) and (pHCA.Formulas[x].iItCount = 0) do Dec(x);
      start2 := Max(1, Min(x, pHCA.bHybOpt2 and 7));
      if (pHCA.bOptions1 and 3) = 0 then end1 := x else end1 := start2 - 1;
      end2 := Max(start2, x);
      repeat2 := Max(start2, Min(end2, (pHCA.bHybOpt2 shr 8) and 7));  //start2, end2, repeat2    3x 4bit
      x := end1;
      while (x > 0) and (pHCA.Formulas[x].iItCount <= 0) do Dec(x);
      repeat1 := Min(x, pHCA.bHybOpt1 shr 4);
      if (pHCA.bOptions1 and 3) = 2 then
      begin
        x := MAX_FORMULA_COUNT - 1;
        while (x > start2) and (pHCA.Formulas[x].iItCount <= 0) do Dec(x);
        repeat2 := Min(x, repeat2);
      end;
    end;
    pHCA.bHybOpt1 := end1 or (repeat1 shl 4);
    pHCA.bHybOpt2 := start2 or (end2 shl 4) or (repeat2 shl 8);
end;

procedure InsertDescription(Fname, Fdescr: String; ModTime: TDateTime);
var i: Integer;
    bIn: LongBool;
begin
    bIn := False;
    for i := 0 to FdescCount - 1 do
    begin
      if SameText(Fname, FdescrName[i]) then
      begin
        if High(Fdescription) < i then SetLength(Fdescription, i + 1);
        Fdescription[i] := Fdescr;
        FdescrModTime[i] := ModTime;
        bIn := True;
        Break;
      end;
    end;
    if not bIn then
    begin
      Inc(FdescCount);
      i := FdescCount;
      SetLength(FdescrName, i);
      SetLength(Fdescription, i);
      SetLength(FdescrModTime, i);
      Dec(i);
      FdescrName[i] := Fname;
      Fdescription[i] := Fdescr;
      FdescrModTime[i] := ModTime;
    end;
end;

function SameFName(Fn1, Fn2: String): LongBool;
begin
    Result := UpperCase(Trim(Fn1)) = UpperCase(Trim(Fn2));
end;

function DescrOfFName(FName: String): String;
var i: Integer;
begin
    Result := '';
    if isInternFormula(FName, i) then
    begin
      Result := CFdescriptionIntern[i];
      Exit;
    end;
    for i := 0 to FdescCount - 1 do if SameFName(FName, FdescrName[i]) then
    begin
      Result := Fdescription[i];
      Break;
    end;
end;

procedure ResetFormulas(HAddon: PTHeaderCustomAddon);
var n: Integer;
begin       
    for n := 0 to MAX_FORMULA_COUNT - 1 do
    with HAddon.Formulas[n] do
    begin
      iItCount := 0;
      iFnr := -1;
      iOptionCount := 0;
      CustomFname[0] := 0;
    end;
end;

function isInternFormula(FName: String; var i: Integer): LongBool;
var s: String;
begin
    s := Trim(FName);
    Result := False;
    i := -1;
    if s <> '' then
    begin
      s := '.' + s + '.';
      i := Pos(s, InternFNames);
      if i > 0 then
      begin
        i := (i + 1) div 11;
        Result := True;
      end
      else i := -1;
    end;
end;

function isIntType(ftype: Integer): LongBool;
begin
    Result := ftype in [2, 10, 20];
end;

function isAngleType(ftype: Integer): LongBool;
begin
    Result := ftype in [3..6, 12];
end;

{function isAngleTypeIpol(ftype: Integer): LongBool;
begin
    Result := ftype in [3..6, 12, 18, 19];
end; }

procedure CopyTypeAndOptionFromCFtoHAddon(CF: PTCustomFormula; HA: PTHeaderCustomAddon; fnr: Integer{; bLoadedPars: LongBool});
var i: Integer;
begin
    for i := 0 to 15 do
      HA.Formulas[fnr].byOptionType[i] := CF.byOptionTypes[i];
 {   if bLoadedPars and (HA.Formulas[fnr].iOptionCount < CF.iCFOptionCount) then
    begin  // HA.Formulas[fnr].wOptionCountLoaded := HA.Formulas[fnr].wOptionCount; + fill all above loadedcount with defaults when loading formula?
      for i := HA.Formulas[fnr].iOptionCount to CF.iCFOptionCount - 1 do
        HA.Formulas[fnr].dOptionValue[i] := 0;    //not zero.. ini val, done in IniCFs...
    end; }
    HA.Formulas[fnr].iOptionCount := CF.iCFOptionCount;
end;

procedure SetCFoptionsFromOldF(f: Integer; CF: PTCustomFormula);
var i: Integer;
const
    sa: array[0..9, 0..1] of String = (('Integer power (2..8)','Z multiplier'),
      ('Float power','Z multiplier'),('YW multiplier','W add'),('Z multiplier','CZ multiplier'),
      ('Scale','Min R'),('Box Scale','Box Min R'),('Integer power (2..8)','Z multiplier'),('',''),('',''),
      ('Float power','Z multiplier'));
begin
    if f in [0..9] then
    with CF^ do
    begin
      for i := 0 to 15 do byOptionTypes[i] := 0;  //Double       //write of in m3i load stream
      if f in [0, 6] then byOptionTypes[0] := 10; //IntPow=NoVar
      if f in [4, 5] then byOptionTypes[1] := 7;  //AmazBoxMinR
      iCFOptionCount := 2;
      for i := 0 to 1 do sOptionStrings[i] := sa[f][i];
      if f = 4 then
      begin
        iCFOptionCount := 3;
        sOptionStrings[2] := 'Fold';
        byOptionTypes[2] := 11;       //Folding16 R,R,-R,-R
      end
      else if f = 5 then   //BulBox
      begin
        iCFOptionCount := 6;
        sOptionStrings[2] := 'Box fold';
        sOptionStrings[3] := 'Bulb scaling';
        sOptionStrings[4] := 'Box/Bulb R threshold';
        sOptionStrings[5] := 'Box/Bulb R threshold 2';
        byOptionTypes[2] := 11; //Folding16 R,R,-R,-R
        byOptionTypes[3] := 0; //13: reciproc
        byOptionTypes[4] := 9;  //Squared
        byOptionTypes[5] := 9;
      end
      else if f = 6 then  //FoldInt
      begin
        iCFOptionCount := 3;
        byOptionTypes[2] := 8;
        sOptionStrings[2] := 'R fold';
      end
      else if f = 7 then
      begin
        iCFOptionCount := testhybridOptionCount;
        for i := 0 to iCFOptionCount - 1 do
        begin
          sOptionStrings[i] := testhybridOptionsStrings[i];
          byOptionTypes[i] := testhybridOptionTypes[i];
        end;
      end
      else if f = 8 then
      begin
        iCFOptionCount := testIFSOptionCount;
        for i := 0 to iCFOptionCount - 1 do
        begin
          sOptionStrings[i] := testIFSOptionsStrings[i];
          byOptionTypes[i] := testIFSOptionTypes[i];
        end;
      end
      else if f = 9 then //Aexion rotate c   [Power, Z mul, Enable RotC (0,1), Cond Phi (0,1), Power C, Cz mul, PowC on dist Z-C, Mod (0,1) ]
      begin
        iCFOptionCount := 8;
        sOptionStrings[2] := 'Enable rotate C (0,1)';
        sOptionStrings[3] := 'Condi. Phi (0,1)';
        sOptionStrings[4] := 'Float power C';
    //    sOptionStrings[5] := 'Pow C multiplier';
        sOptionStrings[5] := 'Cz multiplier';
        sOptionStrings[6] := 'PowC on dist Vec-C (0,1)';
        sOptionStrings[7] := 'Mode (0..31)';
        byOptionTypes[2] := 2;
        byOptionTypes[3] := 2;
        byOptionTypes[6] := 2;
        byOptionTypes[7] := 2;
      end;
    end;            
end;

procedure ParseCFfromOld(iFormula: Integer; CF: PTCustomFormula;
                         dOptionValues: array of Double);
var f: Integer;
const
    ds: array[0..9] of Double = (1,1,1,1,0.2,0.2,0.5,1,1,1);
begin
    if iFormula in [0..9] then
    with CF^ do
    begin
      f := iFormula;
      SetCFoptionsFromOldF(f, CF);
      SIMDlevel := 0;
      dDEscale  := ds[f];
      dADEscale := 1;
      if f = 0 then dSIpow := Min(8, Max(2, dOptionValues[0])) else
      if f in [1, 9] then dSIpow := NonZero(dOptionValues[0]) else dSIpow := 2;
      dRstop      := 16;
      iConstCount := 0;
      iDEoption   := 0;
      iVersion    := 3;
      if f in [4, 5, 6] then dRstop := 1024;
      SetLength(VarBuffer, 1024);
      pConstPointer16 := Pointer((Integer(@VarBuffer[0]) + 271) and $FFFFFFF0);
      FastMove(PAligned16^, pConstPointer16^, 216);
      if bCPmemReserved and (Pointer(pCodePointer) <> nil) then
        VirtualFree(pCodePointer, {0}4096, {MEM_RELEASE} MEM_DECOMMIT);
      bCPmemReserved := False;
      case f of
        0: ThybridIteration(pCodePointer) := fHIntFunctions[Round(dSIpow)];
        1: ThybridIteration(pCodePointer) := HybridFloatPow;
        2: begin
             ThybridIteration(pCodePointer) := fHybridQuat;
             iDEoption := 4;
           end;
        3: ThybridIteration(pCodePointer) := HybridItTricorn;
        4: begin
             ThybridIteration(pCodePointer) := fHybridCubeDE;
             iDEoption := 11;
           end;
        5: ThybridIteration(pCodePointer) := HybridSuperCube2; //todo: all powers with: ThybridIteration(pCodePointer) := fHIntFunctions[Round(dSIpow)];
        6: ThybridIteration(pCodePointer) := HybridFolding;
        7: begin
             ThybridIteration(pCodePointer) := TestHybrid;
             iDEoption := testhybridDEoption;
             dRstop := testhybridRstop;
             dDEscale := testhybridDEscale;
             dSIpow := testhybridPow;

          {   pCodePointer := VirtualAlloc(nil, 4096, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
             FastMove(TestHybrid, pCodePointer^, 4096);
             //ThybridIteration(pCodePointer) := TestHybrid;
             bCPmemReserved := True;   }
           end;
        8: begin
             TIFSIteration(pCodePointer) := HybridCustomIFStest;
             iDEoption := testIFSDEoption;
           end;
        9: ThybridIteration(pCodePointer) := AexionC;
      end;
    end;
end;

procedure IniCustomF(CF: PTCustomFormula);
begin
    CF.iCFOptionCount := 0;
    CF.iConstCount := 0;
    CF.pConstPointer16 := nil;
    CF.pCodePointer := nil;
    CF.LastModTime := 0;
 //   CF.LastCFloaded := '';
    CF.bCPmemReserved := False;
end;

procedure FreeCF(CF: PTCustomFormula);
begin
    if CF.bCPmemReserved and (Pointer(CF.pCodePointer) <> nil) then
      VirtualFree(CF.pCodePointer, {0}4096, {MEM_RELEASE} MEM_DECOMMIT);
    CF.bCPmemReserved := False;
    Pointer(CF.pCodePointer) := nil;
    SetLength(CF.VarBuffer, 0);
end;

procedure FillCustomVBufWithVars(CF1: PTCustomFormula; dOptionValues: array of Double);
var i, j, l: Integer;
    p, ps: PSingle;
    pd: PDouble;
    M: TMatrix3;
    MS4: TSMatrix4;
    da: array[0..5] of Double;
const MemNeeded: array[0..22] of Integer = (8,4,4,16,8,72,36,16,40,8,0,32,64,8,
                                            16,8,8,16,36,8,8,8,16);
begin
    with CF1^ do                                                                                        //10: Fold with only R and 2R
    begin    //iOptionTypes[i]     0      1       2         3          4            5              6         7 (MinR) 8  Rthr   9 Double, will be squared
      p := pConstPointer16;  //'.DOUBLE.SINGLE.INTEGER.DOUBLEANGLE.SINGLEANGLE.3DOUBLEANGLES.3SINGLEANGLES.BOXSCALE.FOLDING.DSQUARE.
      Dec(p, 2);             //  NOVARIABLE.FOLDING16.6SINGLEANGLES.DRECIPRO.2DOUBLES..DSQRRECI...2SINGLES.4SINGLES..3SCALESANGLES.SCALESROT.2INTEGER.SRECI2.DRECI2';
                             //      10         11        12         13        14        15        16         17          18          19        20      21     22
      PDouble(p)^ := 0.5;    //AmazingBox vars: scale=double, MinR=boxscale: Scale/Sqr(MinR), Sqr(MinR)
                             //BulBox: scale=double, MinR=boxscale, BulbScale=double, Rthreshold=double ^2
      i := 0;                //FoldInt: IntPow=novar, Zmul=double, FoldR=folding
      while i < Min(16, iCFOptionCount) do
      begin
        pd := @M[0, 0];
        if (Integer(pConstPointer16) - Integer(p) + MemNeeded[byOptionTypes[i]]) < 257 then
        case byOptionTypes[i] of
          0: begin
               Dec(p, 2);
               PDouble(p)^ := dOptionValues[i];
             end;
          1: begin
               Dec(p);
               p^ := dOptionValues[i];
             end;
          2: begin
               Dec(p);
               PInteger(p)^ := Round(dOptionValues[i]);
             end;
          3: begin
               Dec(p, 2);
               PDouble(p)^ := Sin(dOptionValues[i] * Pid180);
               Dec(p, 2);
               PDouble(p)^ := Cos(dOptionValues[i] * Pid180);
             end;
          4: begin
               Dec(p);
               p^ := Sin(dOptionValues[i] * Pid180);
               Dec(p);
               p^ := Cos(dOptionValues[i] * Pid180);
             end;
          5: begin
               BuildRotMatrix(dOptionValues[i] * Pid180, dOptionValues[i + 1] * Pid180,
                              dOptionValues[i + 2] * Pid180, @M);
               for j := 0 to 8 do
               begin
                 Dec(p, 2);
                 PDouble(p)^ := pd^;
                 Inc(pd);
               end;
               Inc(i, 2);
             end;
          6: begin   //3SINGLEANGLES
               BuildRotMatrix(dOptionValues[i] * Pid180, dOptionValues[i + 1] * Pid180,
                              dOptionValues[i + 2] * Pid180, @M);
               for j := 0 to 8 do
               begin
                 Dec(p);
                 p^ := pd^;
                 Inc(pd);
               end;
               Inc(i, 2);
             end;
          7: begin //Scale/Sqr(MinR), Sqr(MinR)
               Dec(p, 2);
               PDouble(p)^ := dOptionValues[i - 1] / Sqr(Max(1e-40, dOptionValues[i]));
               Dec(p, 2);
               PDouble(p)^ := Sqr(Max(1e-40, dOptionValues[i]));
             end;
          8: begin  //Folding R,2R,-R,-2R
               Dec(p, 2);
               PDouble(p)^ := dOptionValues[i];
               Dec(p, 2);
               PDouble(p)^ := 2 * dOptionValues[i];
               Dec(p, 2);
               PDouble(p)^ := -dOptionValues[i];
               Dec(p, 2);
               PDouble(p)^ := -2 * dOptionValues[i];
               Dec(p);
               if i > 1 then TPhybridIteration(p)^ := fHIntFunctions[Max(2, Min(8, Round(dOptionValues[i - 2])))];
             end;
          9: begin
               Dec(p, 2);
               PDouble(p)^ := Sqr(dOptionValues[i]);
             end;
         11: begin    //Folding16 R,R,-R,-R
               Dec(p, 2);
               PDouble(p)^ := dOptionValues[i];
               Dec(p, 2);
               PDouble(p)^ := dOptionValues[i];
               Dec(p, 2);
               PDouble(p)^ := -dOptionValues[i];
               Dec(p, 2);
               PDouble(p)^ := -dOptionValues[i];
             end;
         12: begin
               for j := 0 to 5 do da[j] := dOptionValues[i + j] * pid180;
               BuildRotMatrix4d(da, MS4);
               ps := @MS4[0];
               for j := 0 to 15 do
               begin
                 Dec(p);
                 p^ := ps^;
                 Inc(ps);
               end;
               Inc(i, 5);
             end;
         13: begin
               Dec(p, 2);
               PDouble(p)^ := 1 / MaxAbsCD(1e-40, dOptionValues[i]);
             end;
         14: begin //for SSE2
               Dec(p, 2);
               PDouble(p)^ := dOptionValues[i];
               Dec(p, 2);
               PDouble(p)^ := dOptionValues[i];
             end;
         15: begin
               Dec(p, 2);
               PDouble(p)^ := 1 / MaxCD(1e-40, Sqr(dOptionValues[i]));
             end;
      16,17: begin
               if byOptionTypes[i] = 17 then l := 4 else l := 2;
               repeat
                 Dec(p);
                 p^ := dOptionValues[i];
                 Dec(l)
               until l = 0;
             end;
         18: begin  //3SCALESANGLES
               BuildRotMatrix(dOptionValues[i + 1] * Pid180, dOptionValues[i + 2] * Pid180,
                              dOptionValues[i + 3] * Pid180, @M);
               ScaleMatrix(dOptionValues[i], @M);
               for j := 0 to 8 do
               begin
                 Dec(p);
                 p^ := pd^;
                 Inc(pd);
               end;
               Inc(i, 3);
             end;
         19: begin   //SCALESROT  2d scaled rotation , cos, sin
               Dec(p);
               p^ := Sin(dOptionValues[i + 1] * Pid180) * dOptionValues[i];
               Dec(p);
               p^ := Cos(dOptionValues[i + 1] * Pid180) * dOptionValues[i];
               Inc(i);
             end;
         20: begin
               Dec(p);
               PInteger(p)^ := Round(dOptionValues[i]);
               Dec(p);
               PInteger(p)^ := Round(dOptionValues[i]);
             end;
         21: begin  //.SRECI2 single + reciproc single
               Dec(p);
               p^ := dOptionValues[i];
               Dec(p);
               p^ := 1 / MaxCS(s1em30, dOptionValues[i]);
             end;
         22: begin //.DRECI2
               Dec(p, 2);
               PDouble(p)^ := dOptionValues[i];
               Dec(p, 2);
               PDouble(p)^ := 1 / MaxCD(d1em40, dOptionValues[i]);
             end;
        end;
        Inc(i);
      end;
   end;
end;

procedure MakeCustomFsFromHeader(Header: TMandHeader11);
var i, n: Integer;
    CF: PTCustomFormula;
    dOptionVtmp: array[0..15] of Double;
begin
    if (PTHeaderCustomAddon(Header.PCFAddon).bOptions1 and 3) = 1 then n := 1 else n := MAX_FORMULA_COUNT - 1;
    for i := 0 to n do
    with PTHeaderCustomAddon(Header.PCFAddon).Formulas[i] do
    if (n = 1) or (iItCount > 0) then
    begin
      CF := PTCustomFormula(Header.PHCustomF[i]);
      if iFnr < 20 then
      begin
        if iFnr < 0 then
        begin
          iItCount := 0;
          Break;
        end
        else ParseCFfromOld(iFnr, CF, dOptionValue);  //dOPtionVals only read for CF
      end
      else
      begin                                          //to not overwrite actual vars with defaults
        if not LoadCustomFormulaFromHeader(CustomFname, CF^, dOptionVtmp) then
        begin                                       
          iItCount := 0;
          Break;
        end;
      end;
      FillCustomVBufWithVars(CF, dOptionValue);
    end;
end;

function AssignCustomFormula(CF1, CF2: PTCustomFormula): LongBool; //only after filling with vars
var i: Integer;
begin
    if (CF2 <> nil) and (CF2.pCodePointer <> nil) then
    with CF1^ do
    begin
      for i := 0 to 15 do
      begin
        sOptionStrings[i] := CF2.sOptionStrings[i];
        byOptionTypes[i] := CF2.byOptionTypes[i];
      end;
      SIMDlevel    := CF2.SIMDlevel;
      iCFOptionCount := CF2.iCFOptionCount;
      dDEscale     := CF2.dDEscale;
      dADEscale    := CF2.dADEscale;
      dSIpow       := CF2.dSIpow;
      dRstop       := CF2.dRstop;
      iConstCount  := CF2.iConstCount;
      iDEoption    := CF2.iDEoption;
      iVersion     := CF2.iVersion;
      LastModTime  := CF2.LastModTime;
      SetLength(VarBuffer, 1024);
      pConstPointer16 := Pointer((Integer(@VarBuffer[0]) + 271) and $FFFFFFF0);
      FastMove(Pointer(Integer(CF2.pConstPointer16) - 256)^, Pointer(Integer(pConstPointer16) - 256)^, 1008);
      if (not bCPmemReserved) and CF2.bCPmemReserved then
        pCodePointer := VirtualAlloc(nil, 4096, {MEM_RESERVE} MEM_COMMIT, PAGE_EXECUTE_READWRITE);
      if bCPmemReserved and (not CF2.bCPmemReserved) then
        VirtualFree(pCodePointer, {0}4096, {MEM_RELEASE} MEM_DECOMMIT);
      bCPmemReserved := CF2.bCPmemReserved;
      if bCPmemReserved then FastMove(CF2.pCodePointer^, pCodePointer^, 4096)
      else pCodePointer := CF2.pCodePointer; //existing formula
      Result := True;
   end
   else Result := False;
end;

function CanLoadCustomFormula(FileName: String; var DEfunction: Integer): Boolean;
var n, iVersion, SIMDlevel: Integer;
    f: TextFile;
    s: String;
const
    cOptions: String = '.SSE2.DESC.SIPO.RSTO.SSE3.SSSE.SSE4.VERS.DEOPTION';
procedure LoadNextStr;
begin
    repeat
      Readln(f, s);
      s := Trim(s);
    until EOF(f) or (s > '');
end;
begin
    Result := False;
    AssignFile(f, FileName);  
    try
      SIMDlevel := 0;
      iVersion  := 0;
      DEfunction := 0;
      Reset(f);
      LoadNextStr;
      if s = '[OPTIONS]' then
      begin
        repeat
          LoadNextStr;
          n := Pos(UpCaseN(s, 5), cOPtions);
          case n of
            1:   SIMDlevel := SIMDlevel or 1;
            21:  SIMDlevel := SIMDlevel or 2;
            26:  SIMDlevel := SIMDlevel or 4;
            31:  SIMDlevel := SIMDlevel or 8;
            36:  iVersion  := StrToInt(StrLastWord(s));
            41:  DEfunction := StrToInt(StrLastWord(s));
          end;
        until EOF(f) or (s[1] = '[');
      end;
      Result := ((hasSIMDlevel and SIMDlevel) = SIMDlevel) and (iVersion in [2..actFormulaId]);
    finally
      CloseFile(f);
    end;
end;

function CanLoadF(FormulaName: String): Boolean;
var df: Integer;
begin
    Result := CanLoadCustomFormula(IncludeTrailingPathDelimiter(IniDirs[3]) + FormulaName + '.m3f', df);
end;

function LoadCustomFormula(FileName: String; var lCustomFormula: TCustomFormula;
                           var CustomFname: array of Byte; var dOptionValues: array of Double;
                           bVerbose: LongBool; MinModTime: TDatetime;
                           ParseResult: TJITFormula): Boolean;
var n, i, j: Integer;
    f: TextFile;
    s, s2, s3: String;
    pb: PByte;
    d: Double;
    EndOfSection: Boolean;
    Code: TStringList;
    CompiledFormula: TCompiledFormula;
    Formulaname: String;
    p: Pointer;


const                                                    //DEoption > 0 if analytic on X4
    cOptions: String = '.SSE2.DESC.SIPO.RSTO.SSE3.SSSE.SSE4.VERS.DEOP.DIFS.ADES.';
    cOptions2: String = '.DOUBLE.SINGLE.INTEGER.DOUBLEANGLE.SINGLEANGLE.3DOUBLEANGLES.3SINGLEANGLES.BOXSCALE.FOLDING.DSQUARE.'+
                        'NOVARIABLE.FOLDING16.6SINGLEANGLES.DRECIPRO.2DOUBLES..DSQRRECI..2SINGLES..4SINGLES..3SCALESANGLES.SCALESROT.2INTEGER..SRECI2....DRECI2.';
    cVars: String = 'DOUBLINTINT64SINGLE';
    sra: array[0..5] of String = (' YZ',' XZ',' XY',' XW',' YW',' ZW');

  procedure LoadNextStr;
  begin
    repeat
      Readln(f, s);
      s := Trim(s);
    until EOF(f) or (s > '');
  end;

begin
    Result := False;
    AssignFile(f, FileName);
    if FileExists(FileName) then with lCustomFormula do try
      if Assigned(ParseResult) then begin
        Formulaname := ExtractFilename( FileName );
        ParseResult.Formulaname := Copy(Formulaname, 1, Length(Formulaname) - Length('.m3f'));
      end;

      SetLength(VarBuffer, 1024);
      pConstPointer16 := Pointer((Integer(@VarBuffer[0]) + 271) and $FFFFFFF0);
      pb              := PByte(pConstPointer16);
      SIMDlevel       := 0;
      iCFOptionCount  := 0;
      iConstCount := 0;
      iDEoption   := 0;
      iVersion    := 0;
      dSIpow      := 0;
      dDEscale    := 1;
      dADEscale   := 1;
      dRstop      := 16;
      Reset(f);
      LoadNextStr;
      if s = '[OPTIONS]' then
      begin
        repeat
          LoadNextStr;
          n := Pos(UpCaseN(s, 5), cOPtions);
          case n of
            1:  begin
                  SIMDlevel := SIMDlevel or 1;
                  if Assigned(ParseResult) then
                    ParseResult.SetOption('SSE2', dtString, '');
                end;
            6:   begin
                   dDEscale  := StrToFloatK(StrLastWord(s));
                   if Assigned(ParseResult) then
                     ParseResult.SetOption('DEScale', dtDouble, dDEscale);
                 end;
            11:  begin
                   dSIpow    := StrToFloatK(StrLastWord(s));
                   if Assigned(ParseResult) then
                     ParseResult.SetOption('SIPow', dtDouble, dSIpow);
                 end;
            16:  begin
                   dRstop    := StrToFloatK(StrLastWord(s));
                   if Assigned(ParseResult) then
                     ParseResult.SetOption('RStop', dtDouble, dRstop);
                 end;
            21:  begin
                   SIMDlevel := SIMDlevel or 2;
                   if Assigned(ParseResult) then
                     ParseResult.SetOption('SSE3', dtString, '');
                 end;
            26:  begin
                   SIMDlevel := SIMDlevel or 4;
                   if Assigned(ParseResult) then
                     ParseResult.SetOption('SSEE', dtString, '');
                 end;
            31:  begin
                   SIMDlevel := SIMDlevel or 8;
                   if Assigned(ParseResult) then
                     ParseResult.SetOption('SSE4', dtString, '');
                 end;
            36:  begin
                   iVersion  := StrToInt(StrLastWord(s));
                   if Assigned(ParseResult) then
                     ParseResult.SetOption('Version', dtInteger, iVersion);
                 end;
            41:  begin
                   iDEoption := StrToInt(StrLastWord(s));
                   if Assigned(ParseResult) then
                     ParseResult.SetOption('DEoption', dtInteger, iDEoption);
                 end;
            51:  begin
                   dADEscale := StrToFloatK(StrLastWord(s));                //-6                                                                 -6
                   if Assigned(ParseResult) then
                     ParseResult.SetOption('ADEscale', dtDouble, dADEscale);
                 end;
                    //9      16     23      31          43          55            63            87       86      94      102       113         129           137
            else    //1      8      15      23          35          47            61            75       84      92      100       111         121           129      138      148
            begin   //.DOUBLE.SINGLE.INTEGER.DOUBLEANGLE.SINGLEANGLE.3DOUBLEANGLES.3SINGLEANGLES.BOXSCALE.FOLDING.DSQUARE.NOVARIABLE.FOLDING16.6SINGLEANGLES.DRECIPRO.2DOUBLES..DSQRRECI.'
              s2 := StrFirstWord(s);                                            //.2SINGLES..4SINGLES..3SCALESANGLES.SCALESROT.
              n := Pos(UpperCase(s2), cOPtions2);                               //158       168        178           192-4
              if n > 50 then Dec(n, 6);
              if n > 130 then Dec(n, 6);
              if n > 180 then Dec(n, 4);
              if (n > 0) and (iCFOptionCount < 16) then begin
                byOptionTypes[iCFOptionCount] := (n + 8) div 10;
                dOptionValues[iCFOptionCount] := StrToFloatK(StrLastWord(s));
                s3 := StrSecondWord(s);
                if byOptionTypes[iCFOptionCount] = 12 then  //6 singleangles
                begin
                  if Assigned(ParseResult) then
                    raise Exception.Create('Complex param type <'+IntToStr(byOptionTypes[iCFOptionCount])+'> not supported');
                  j := iCFOptionCount;
                  for i := 0 to 5 do
                  begin
                    byOptionTypes[iCFOptionCount] := 12;
                    dOptionValues[iCFOptionCount] := dOptionValues[j];
                    sOptionStrings[iCFOptionCount] := s3 + sra[i];
                    Inc(iCFOptionCount);
                  end;
                  Dec(iCFOptionCount);
                end
                else
                begin
                  sOptionStrings[iCFOptionCount] := s3;
                  if Assigned(ParseResult) then
                    ParseResult.SetParamValue(s3, dtDouble, dOptionValues[iCFOptionCount]);
                  if byOptionTypes[iCFOptionCount] in [5, 6] then begin
                    if Assigned(ParseResult) then
                      raise Exception.Create('Complex param type <'+IntToStr(byOptionTypes[iCFOptionCount])+'> not supported');
                    d := dOptionValues[iCFOptionCount];
                    sOptionStrings[iCFOptionCount] := s3 + ' X';
                    Inc(iCFOptionCount);
                    byOptionTypes[iCFOptionCount] := byOptionTypes[iCFOptionCount - 1];
                    dOptionValues[iCFOptionCount] := d;
                    sOptionStrings[iCFOptionCount] := s3 + ' Y';
                    Inc(iCFOptionCount);
                    byOptionTypes[iCFOptionCount] := byOptionTypes[iCFOptionCount - 1];
                    dOptionValues[iCFOptionCount] := d;
                    sOptionStrings[iCFOptionCount] := s3 + ' Z';
                  end
                  else if byOptionTypes[iCFOptionCount] = 18 then
                  begin
                    if Assigned(ParseResult) then
                      raise Exception.Create('Complex param type <'+IntToStr(byOptionTypes[iCFOptionCount])+'> not supported');
                    for i := 0 to 2 do
                    begin
                      Inc(iCFOptionCount);
                      byOptionTypes[iCFOptionCount] := 6;
                      sOptionStrings[iCFOptionCount] := 'Rotation ' + Chr(65 + i);
                      dOptionValues[iCFOptionCount] := 0;
                    end;
                  end
                  else if byOptionTypes[iCFOptionCount] = 19 then
                  begin
                    if Assigned(ParseResult) then
                      raise Exception.Create('Complex param type <'+IntToStr(byOptionTypes[iCFOptionCount])+'> not supported');
                    sOptionStrings[iCFOptionCount] := 'Scale ' + s3;
                    Inc(iCFOptionCount);
                    byOptionTypes[iCFOptionCount] := 6;
                    sOptionStrings[iCFOptionCount] := 'Rotation ' + s3;
                    dOptionValues[iCFOptionCount] := dOptionValues[iCFOptionCount - 1];
                    dOptionValues[iCFOptionCount - 1] := StrToFloatK(StrFirstWordAfterEqual(s));
                  end;
                end;
                Inc(iCFOptionCount);
              end;
            end;
          end;
        until n = 0;
        if (hasSIMDlevel and SIMDlevel) < SIMDlevel then
        begin
          s := '';
          if bVerbose then ShowMessage('This computer does not support the SIMD level required by this formula.')
          else Mand3DForm.OutMessage('This computer does not support the SIMD level required by this formula.');
        end;
      end;
      Result := (s > '') and (iVersion in [2..actFormulaId]);
      if s > '' then
      begin
        if iVersion < 2 then
        begin
          if bVerbose then ShowMessage('The formula is an old one, only versions 2 to ' +
                                       IntToStr(actFormulaId) + #13#10 + ' are allowed in this program version.')
          else Mand3DForm.OutMessage('The formula is an old one, only versions 2 to ' + IntToStr(actFormulaId) + ' are allowed in this program version.');
        end
        else if iVersion > actFormulaId then
        begin
          if bVerbose then ShowMessage('This formula was designed for a more actual version of Mandelbulb 3D')
          else Mand3DForm.OutMessage('This formula was designed for a more actual version of Mandelbulb 3D');
        end;
      end;
      if not Result then s := '';

      if s = '[CONSTANTS]' then
      begin
        repeat
          LoadNextStr;
          n := Pos(UpCaseN(s, 5), cVars);
          case n of
            1:  begin
                  PDouble(pb)^  := StrToFloatK(StrLastWord(s));
                  if Assigned(ParseResult) then
                    ParseResult.AddConstValue(dtDouble, PDouble(pb)^);
                end;
            6:  begin
                  PInteger(pb)^ := StrToInt(StrLastWord(s));
                  if Assigned(ParseResult) then
                    ParseResult.AddConstValue(dtInteger, PInteger(pb)^);
                end;
            9:  begin
                  PInt64(pb)^   := StrToInt64(StrLastWord(s));
                  if Assigned(ParseResult) then
                    ParseResult.AddConstValue(dtInt64, PInt64(pb)^);
                end;
            14: begin
                  PSingle(pb)^  := StrToFloatK(StrLastWord(s));
                  if Assigned(ParseResult) then
                    ParseResult.AddConstValue(dtSingle, PSingle(pb)^);
                end;
            else
            begin
               Dec(pb, 8);
               Dec(iConstCount);
            end;
          end;
          Inc(pb, 8);
          Inc(iConstCount);
        until (Length(s) > 0) and (s[1] = '[');
      end;

      if s = '[SOURCE]' then begin
        Code := TStringList.Create;
        try
          repeat
            Readln(f, s);
            s2 := Trim(s);
            EndOfSection := (Length(s2) > 0) and (s2[1] = '[') and (s2[Length(s2)]=']');
            if not EndOfSection then
              Code.Add(s);
          until EOF(f) or EndOfSection;
          if Code.Count > 0 then begin
            CompiledFormula := TFormulaCompilerRegistry.GetCompilerInstance(langDELPHI).CompileFormula(Code);
            if CompiledFormula.IsValid then begin

              ThybridIteration(pCodePointer) := CompiledFormula.CodePointer;
              bCPmemReserved := False;

              Result := True;
            end
            else
              raise Exception.Create(Code.Text+#13#10+ CompiledFormula.ErrorMessage.Text);
          end;
          if Assigned(ParseResult) then
            ParseResult.Code := Code.Text;
        finally
          Code.Free;
        end;
      end;

      if s = '[CODE]' then
      begin
        if (not bCPmemReserved) or (pCodePointer = nil) then
          pCodePointer := VirtualAlloc(nil, 4096, {MEM_RESERVE} MEM_COMMIT, PAGE_EXECUTE_READWRITE);
        bCPmemReserved := True;
        n := 0;
        pb := Pointer(pCodePointer);
        repeat
          LoadNextStr;
          if (Length(s) > 0) and (s[1] <> '[') then
          begin
            while (Length(s) > 1) and (n < 4095) do
            begin
              pb^ := StrToInt('$' + s[1] + s[2]);
              Inc(pb);
              Inc(n);
              Delete(s, 1, 2);
            end;
          end;
        until EOF(f) or (s = '[END]');
        Result := (n > 10);
      end;

      if Result and (s='[END]') then
      begin
        CFdescription := '';
        n := 0;     //load formula description
        repeat
          Readln(f, s);
          s := Trim(s);
        until (Length(s) > 0) or EOF(f);
        if Length(s) > 0 then
        repeat
          CFdescription := CFdescription + s + #13 + #10;
          if EOF(f) then n := 100 else Readln(f, s);
          Inc(n);
        until n > 100;
        LastModTime := GetFileModDate(FileName);
        s3 := ExtractFileName(FileName);
        n := 1;
        while (n < 32) and (s3[n] <> '.') do
        begin
          CustomFname[n - 1] := Ord(s3[n]);
          CustomFname[n] := 0;
          Inc(n);
        end;
        InsertDescription(CustomFtoStr(CustomFname), CFdescription, LastModTime);
        if Assigned(ParseResult) then
          ParseResult.Description := CFdescription;
      end;
    except
      Result := False;
    end;
    CloseFile(f);
end;

function LoadCustomFormulaFromHeader(var CustomFname: array of Byte;
                                     var lCustomFormula: TCustomFormula;
                                     var dOptionVars: array of Double): Boolean;
var s: String;
begin
    CFdescription := '';
    s := CustomFtoStr(CustomFname) + '.m3f';
    Result := LoadCustomFormula(IncludeTrailingPathDelimiter(IniDirs[3]) + s,
                            lCustomFormula, CustomFname, dOptionVars, False, 0, nil);
    if not Result then
    begin
      Mand3dForm.OutMessage(CustomFtoStr(CustomFname) + ' formula is missing! (Check Ini-dir for formulas)');
      CustomFname[0] := 0;
    end;
end;

function Is4Dtype(Header: TPMandHeader11): LongBool;
var n, DEopt: Integer;
    PCFA: PTHeaderCustomAddon;
begin
    PCFA := PTHeaderCustomAddon(Header.PCFAddon);
    Result := (PCFA.bOptions1 and 3) <> 1;
    if not Result then  //Ipolhybrid
    begin
      MakeCustomFsFromHeader(Header^);
      Result := (PTCustomFormula(Header.PHCustomF[0]).iDEoption in [4..6]) and
                (PTCustomFormula(Header.PHCustomF[1]).iDEoption in [4..6]);
      Exit;
    end;
    isSingleF(PCFA, n);
    Result := n >= 0;
    if not Result then Exit;
    MakeCustomFsFromHeader(Header^);
    CheckDEoption(0, PCFA.bHybOpt1 and 7, PCFA, Header.PHCustomF, DEopt);
    Result := DEopt in [4..6];
    if (PCFA.bOptions1 and 3) = 2 then
    begin
      CheckDEoption(PCFA.bHybOpt2 and 7, (PCFA.bHybOpt2 shr 4) and 7, PCFA,
                    Header.PHCustomF, DEopt);
      Result := Result or (DEopt in [4..6]);
    end;
end;

end.

