unit FormulaCompiler;

interface

uses
  SysUtils, Classes, TypeDefinitions, JITFormulas;

type
  TFormulaLanguage = (langDELPHI);

  TCompiledFormula = class
  private
    FErrorMessages: TStrings;
    FCodeSize: Integer;
    FCodePointer: Pointer;
  protected
    procedure AddErrorMessage(const Msg: String);
  public
    constructor Create;
    destructor Destroy;override;
    function IsValid: Boolean;
    property ErrorMessage: TStrings read FErrorMessages;
    property CodeSize: Integer read FCodeSize;
    property CodePointer: Pointer read FCodePointer;
  end;

  TFormulaCompiler = class
  public
    {$ifdef JIT_FORMULA_PREPROCESSING}
    function PreprocessCode(const Code: String; const Formula: TJITFormula): String; virtual;abstract;
    {$endif}
    function CompileFormula(const Formula: TJITFormula): TCompiledFormula;virtual;abstract;
  end;

  TFormulaCompilerRegistry = class
  public
    class function GetCompilerInstance(const FormulaLanguage: TFormulaLanguage): TFormulaCompiler;
  end;

implementation

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls,
{$ifdef USE_PAX_COMPILER}
  PaxCompiler, PaxProgram, PaxRegister,
{$endif}
  TypInfo, Math, Math3D;

{$ifdef USE_PAX_COMPILER}
type
  TPaxCompiledFormula = class (TCompiledFormula)
  private
    FPaxProgram: TPaxProgram;
  public
    destructor Destroy;override;
  end;

  TPaxFormulaCompiler = class (TFormulaCompiler)
  private
    FPaxCompiler: TPaxCompiler;
    FPaxPascalLanguage: TPaxPascalLanguage;
    procedure Initialize;
    procedure Register_TypeTIteration3D;
    procedure Register_TypeTIteration3Dext;
    procedure Register_MathFunctions;
    procedure Register_MiscFunctions;
  public
    constructor Create;
    destructor Destroy; override;
    {$ifdef JIT_FORMULA_PREPROCESSING}
    function PreprocessCode(const Code: String; const Formula: TJITFormula): String; override;
    {$endif}
    function CompileFormula(const Formula: TJITFormula): TCompiledFormula; override;
  end;
{$endif}
{ ----------------------------- TCompiledFormula ----------------------------- }
constructor TCompiledFormula.Create;
begin
  inherited Create;
  FErrorMessages := TStringList.Create;
end;

destructor TCompiledFormula.Destroy;
begin
  FreeAndNil(FErrorMessages);
  inherited Destroy;
end;

procedure TCompiledFormula.AddErrorMessage(const Msg: String);
begin
  FErrorMessages.Add(Msg)
end;

function TCompiledFormula.IsValid: Boolean;
begin
  Result := (FErrorMessages.Count = 0) and (FCodeSize > 0);
end;
{$ifdef USE_PAX_COMPILER}
{ --------------------------- TPaxFormulaCompiler ---------------------------- }
constructor TPaxFormulaCompiler.Create;
begin
  inherited Create;
  FPaxPascalLanguage := TPaxPascalLanguage.Create(nil);
  FPaxCompiler := TPaxCompiler.Create(nil);
  Initialize;
end;

destructor TPaxFormulaCompiler.Destroy;
begin
  FreeAndNil(FPaxPascalLanguage);
  FreeAndNil(FPaxCompiler);
  inherited Destroy;
end;

procedure TPaxFormulaCompiler.Register_TypeTIteration3D;
var
  H_FormulaRange: Integer;
  H_TIteration3D: Integer;
  { H_TPIteration3D: Integer; }
  {$ifdef ENABLE_EXTENSIONS}
  H_Range_0_35: Integer;
  H_FormulaRangeExt: Integer;
  {$endif}

  procedure RegisterArray(const ElemName: String; const ElemType, RangeType: Integer);
  var
    H_Type: Integer;
  begin
    H_Type := FPaxCompiler.RegisterArrayType(H_TIteration3D, 'H_T'+ElemName, RangeType, ElemType, true);
    FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, ElemName, H_Type);
  end;

begin
  H_FormulaRange := FPaxCompiler.RegisterSubrangeType(0, 'FormulaRange', _typeBYTE, 0, V18_FORMULA_COUNT - 1);

  H_TIteration3D := FPaxCompiler.RegisterRecordType(0, 'TIteration3D', true);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'C1', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'C2', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'C3', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'J1', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'J2', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'J3', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'PVar', _typePOINTER);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'SmoothItD', _typeSINGLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'Rout', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'ItResultI', _typeINTEGER);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'maxIt', _typeINTEGER);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'RStop', _typeSINGLE);

  {$ifdef ENABLE_EXTENSIONS}
  RegisterArray('unused_nHybrid', _typeINTEGER, H_FormulaRange);
  RegisterArray('unused_fHPVar', _typePOINTER, H_FormulaRange);
  RegisterArray('unused_fHybrid', _typePOINTER, H_FormulaRange);
  {$else}
  RegisterArray('nHybrid', _typeINTEGER, H_FormulaRange);
  RegisterArray('fHPVar', _typePOINTER, H_FormulaRange);
  RegisterArray('fHybrid', _typePOINTER, H_FormulaRange);
  {$endif}
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'CalcSIT', _typeLONGBOOL);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'DoJulia', _typeLONGBOOL);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'LNRStop', _typeSINGLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'DEoption', _typeINTEGER);
  {$ifdef ENABLE_EXTENSIONS}
  RegisterArray('unused_fHln', _typeSINGLE, H_FormulaRange);
  {$else}
  RegisterArray('fHln', _typeSINGLE, H_FormulaRange);
  {$endif}
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'iRepeatFrom', _typeINTEGER);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'OTrap', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'VaryScale', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'bFirstIt', _typeINTEGER);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'bTmp', _typeINTEGER);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'Dfree1', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'Dfree2', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'Deriv1', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'Deriv2', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'Deriv3', _typeDOUBLE);
  {$ifdef ENABLE_EXTENSIONS}
  H_Range_0_35 := PaxCompiler1.RegisterSubrangeType(0, 'Range_0_35', _typeBYTE, 0, 35);
  H_FormulaRangeExt := FPaxCompiler.RegisterSubrangeType(0, 'FormulaRangeExt', _typeCHAR, 0, MAX_FORMULA_COUNT - 1);
  RegisterArray('dummy', _typeINTEGER, H_Range_0_35);
  RegisterArray('nHybrid', _typeINTEGER, H_FormulaRangeExt);
  RegisterArray('fHPVar', _typePOINTER, H_FormulaRangeExt);
  RegisterArray('fHybrid', _typePOINTER, H_FormulaRangeExt);
  RegisterArray('fHln', _typeSINGLE, H_FormulaRangeExt);
  {$endif}
  {H_TPIteration3D :=} FPaxCompiler.RegisterPointerType(0, 'TPIteration3D', H_TIteration3D);
end;

procedure TPaxFormulaCompiler.Register_TypeTIteration3Dext;
var
  H_FormulaRange: Integer;
  H_TIteration3Dext: Integer;
  { H_TPIteration3D: Integer; }
  {$ifdef ENABLE_EXTENSIONS}
  H_Range_0_35: Integer;
  H_FormulaRangeExt: Integer;
  {$endif}
  H_FormulaInitialization, H_TFormulaInitialization: Integer;
  H_Range_0_63, H_Range_0_2: Integer;
  H_TVec3D, H_TPVec3D: Integer;
  H_LMSfunction, H_TLMSfunction: Integer;

  procedure RegisterArray(const ElemName: String; const ElemType, RangeType: Integer);
  var
    H_Type: Integer;
  begin
    H_Type := FPaxCompiler.RegisterArrayType(H_TIteration3Dext, 'H_T'+ElemName, RangeType, ElemType, true);
    FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, ElemName, H_Type);
  end;

begin
  H_FormulaRange := FPaxCompiler.RegisterSubrangeType(0, 'FormulaRange', _typeBYTE, 0, V18_FORMULA_COUNT - 1);

  // TFormulaInitialization
  H_FormulaInitialization := FPaxCompiler.RegisterRoutine(0, 'FormulaInitialization', _typeVOID, _ccREGISTER);
  FPaxCompiler.RegisterParameter(H_FormulaInitialization, _typePOINTER, _Unassigned);
  H_TFormulaInitialization := FPaxCompiler.RegisterProceduralType(0, 'TFormulaInitialization', H_FormulaInitialization);

  // TLMSfunction
  H_Range_0_2 := FPaxCompiler.RegisterSubrangeType(0, 'Range_0_2', _typeBYTE, 0, 2);
  H_TVec3D := FPaxCompiler.RegisterArrayType(0, 'TVec3D', H_Range_0_2, _typeDOUBLE);
  H_TPVec3D := FPaxCompiler.RegisterPointerType(0, 'TPVec3D', H_TVec3D);
  H_LMSfunction := FPaxCompiler.RegisterRoutine(0, 'LMSfunction', H_TVec3D, _ccREGISTER);
  FPaxCompiler.RegisterParameter(H_LMSfunction, H_TPVec3D, _Unassigned);
  FPaxCompiler.RegisterParameter(H_LMSfunction, _typeINTEGER, _Unassigned);
  H_TLMSfunction := FPaxCompiler.RegisterProceduralType(0, 'TLMSfunction', H_LMSfunction);

  H_TIteration3Dext := FPaxCompiler.RegisterRecordType(0, 'TIteration3Dext', true);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'J4', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'Rold', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'RStopD', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'x', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'y', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'z', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'w', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'C1', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'C2', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'C3', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'J1', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'J2', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'J3', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'PVar', _typePOINTER);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'SmoothItD', _typeSINGLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'Rout', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'ItResultI', _typeINTEGER);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'maxIt', _typeINTEGER);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'RStop', _typeSINGLE);
  {$ifdef ENABLE_EXTENSIONS}
  RegisterArray('unused_nHybrid', _typeINTEGER, H_FormulaRange);
  RegisterArray('unused_fHPVar', _typePOINTER, H_FormulaRange);
  RegisterArray('unused_fHybrid', _typePOINTER, H_FormulaRange);
  {$else}
  RegisterArray('nHybrid', _typeINTEGER, H_FormulaRange);
  RegisterArray('fHPVar', _typePOINTER, H_FormulaRange);
  RegisterArray('fHybrid', _typePOINTER, H_FormulaRange);
  {$endif}
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'CalcSIT', _typeBYTEBOOL);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'bFree', _typeBYTE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'EndTo', _typeWORD);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'DoJulia', _typeLONGBOOL);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'LNRStop', _typeSINGLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'DEoption', _typeINTEGER);
  {$ifdef ENABLE_EXTENSIONS}
  RegisterArray('unused_fHln', _typeSINGLE, H_FormulaRange);
  {$else}
  RegisterArray('fHln', _typeSINGLE, H_FormulaRange);
  {$endif}
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'iRepeatFrom', _typeWORD);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'iStartFrom', _typeWORD);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'OTrap', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'VaryScale', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'bFirstIt', _typeINTEGER);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'bTmp', _typeINTEGER);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'Dfree1', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'Dfree2', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'Deriv1', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'Deriv2', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'Deriv3', _typeDOUBLE);
  // TSMatrix4 = array[0..3, 0..3] of Single - no idea how to register multi-dimensional arrays -> now lets us just reserve the space
  H_Range_0_63 := FPaxCompiler.RegisterSubrangeType(0, 'Range_0_63', _typeCHAR, 0, 63);
  RegisterArray('SMatrix4', _typeBYTE, H_Range_0_63);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'Ju1', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'Ju2', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'Ju3', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'Ju4', _typeDOUBLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'PMapFunc', H_TLMSfunction);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'PMapFunc2', H_TLMSfunction);
  {$ifdef ENABLE_EXTENSIONS}
  RegisterArray('unused_pInitialization', H_TFormulaInitialization, H_FormulaRange);
  {$else}
  RegisterArray('pInitialization', H_TFormulaInitialization, H_FormulaRange);
  {$endif}
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'bIsInsideRender', _typeLONGBOOL);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'OTrapMode', _typeINTEGER);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'OTrapDE', _typeDOUBLE);
  {$ifdef ENABLE_EXTENSIONS}
  H_FormulaRangeExt := FPaxCompiler.RegisterSubrangeType(0, 'FormulaRangeExt', _typeCHAR, 0, MAX_FORMULA_COUNT - 1);
  RegisterArray('nHybrid', _typeINTEGER, H_FormulaRangeExt);
  RegisterArray('fHPVar', _typePOINTER, H_FormulaRangeExt);
  RegisterArray('fHybrid', _typePOINTER, H_FormulaRangeExt);
  RegisterArray('fHln', _typeSINGLE, H_FormulaRangeExt);
  RegisterArray('pInitialization', H_TFormulaInitialization, H_FormulaRangeExt);
  {$endif}
  {H_TPIteration3Dext :=} FPaxCompiler.RegisterPointerType(0, 'TPIteration3Dext', H_TIteration3Dext);
end;

type
  TStdDoubleMonadicFunc = function(const X: Double): Double;
  TDoubleBooleanMonadicFunc = function (const AValue: Double): Boolean;
  TDoubleIntegerMonadicFunc = function(const X: Double): Integer;
  TStdDoubleDyadicFunc = function(const X, Y: Double): Double;
  TSinCosProc = procedure(const Theta: Double; var Sin, Cos: Double);
  TIntPowerFunc = function(const Base: Double; const Exponent: Integer): Double;
  TRandGFunc = function(Mean, StdDev: Double): Double;

function IntFunc(const X: Double): Double;
begin
  Result := System.Int(X);
end;

function FracFunc(const X: Double): Double;
begin
  Result := System.Frac(X);
end;

function ExpFunc(const X: Double): Double;
begin
  Result := System.Exp(X);
end;

function CosFunc(const X: Double): Double;
begin
  Result := System.Cos(X);
end;

function SinFunc(const X: Double): Double;
begin
  Result := System.Sin(X);
end;

function LnFunc(const X: Double): Double;
begin
  Result := System.Ln(X);
end;

function ArcTanFunc(const X: Double): Double;
begin
  Result := System.ArcTan(X);
end;

function SqrtFunc(const X: Double): Double;
begin
  Result := System.Sqrt(X);
end;

procedure TPaxFormulaCompiler.Register_MathFunctions;
var
  StdMFunc: TStdDoubleMonadicFunc;
  StdDFunc: TStdDoubleDyadicFunc;
  DoubleBooleanMonadicFunc: TDoubleBooleanMonadicFunc;
  DoubleIntegerMFunc: TDoubleIntegerMonadicFunc;
  LSinCosProc: TSinCosProc;
  LIntPowerFunc: TIntPowerFunc;
  LRandGFunc: TRandGFunc;
begin
  FPaxCompiler.RegisterHeader(0, 'function Int(const X: Double): Double;', @IntFunc);

  FPaxCompiler.RegisterHeader(0, 'function Frac(const X: Double): Double;', @FracFunc);

  FPaxCompiler.RegisterHeader(0, 'function Exp(const X: Double): Double;', @ExpFunc);

  FPaxCompiler.RegisterHeader(0, 'function Cos(const X: Double): Double;', @CosFunc);

  FPaxCompiler.RegisterHeader(0, 'function Sin(const X: Double): Double;', @SinFunc);

  FPaxCompiler.RegisterHeader(0, 'function Ln(const X: Double): Double;', @LnFunc);

  FPaxCompiler.RegisterHeader(0, 'function ArcTan(const X: Double): Double;', @ArcTanFunc);

  FPaxCompiler.RegisterHeader(0, 'function Sqrt(const X: Double): Double;', @SqrtFunc);

  StdMFunc := ArcCos; // To choose the right one of the overload variants
  FPaxCompiler.RegisterHeader(0, 'function ArcCos(const X : Double) : Double;', @StdMFunc);

  StdMFunc := ArcSin;
  FPaxCompiler.RegisterHeader(0, 'function ArcSin(const X : Double) : Double;', @StdMFunc);

  StdDFunc := ArcTan2;
  FPaxCompiler.RegisterHeader(0, 'function ArcTan2(const Y, X: Double): Double;', @StdDFunc);

  LSinCosProc := SinCos;
  FPaxCompiler.RegisterHeader(0, 'procedure SinCos(const Theta: Double; var Sin, Cos: Double);', @LSinCosProc);

  StdMFunc := Tan;
  FPaxCompiler.RegisterHeader(0, 'function Tan(const X: Double): Double;', @StdMFunc);

  StdMFunc := Cotan;
  FPaxCompiler.RegisterHeader(0, 'function Cotan(const X: Double): Double;', @StdMFunc);

  StdMFunc := Secant;
  FPaxCompiler.RegisterHeader(0, 'function Secant(const X: Double): Double;', @StdMFunc);

  StdMFunc := Cosecant;
  FPaxCompiler.RegisterHeader(0, 'function Cosecant(const X: Double): Double;', @StdMFunc);

  StdDFunc := Hypot;
  FPaxCompiler.RegisterHeader(0, 'function Hypot(const X, Y: Double): Double;', @StdDFunc);

  StdMFunc := RadToDeg;
  FPaxCompiler.RegisterHeader(0, 'function RadToDeg(const Radians: Double): Double;', @StdMFunc);

  StdMFunc := DegToRad;
  FPaxCompiler.RegisterHeader(0, 'function DegToRad(const Degrees: Double): Double;', @StdMFunc);

  StdMFunc := DegNormalize;
  FPaxCompiler.RegisterHeader(0, 'function DegNormalize(const Degrees: Double): Double;', @StdMFunc);

  StdMFunc := Cot;
  FPaxCompiler.RegisterHeader(0, 'function Cot(const X: Double): Double;', @StdMFunc);

  StdMFunc := Sec;
  FPaxCompiler.RegisterHeader(0, 'function Sec(const X: Double): Double;', @StdMFunc);

  StdMFunc := Csc;
  FPaxCompiler.RegisterHeader(0, 'function Csc(const X: Double): Double;', @StdMFunc);

  StdMFunc := Cosh;
  FPaxCompiler.RegisterHeader(0, 'function Cosh(const X: Double): Double;', @StdMFunc);

  StdMFunc := Sinh;
  FPaxCompiler.RegisterHeader(0, 'function Sinh(const X: Double): Double;', @StdMFunc);

  StdMFunc := Tanh;
  FPaxCompiler.RegisterHeader(0, 'function Tanh(const X: Double): Double;', @StdMFunc);

  StdMFunc := CotH;
  FPaxCompiler.RegisterHeader(0, 'function CotH(const X: Double): Double;', @StdMFunc);

  StdMFunc := SecH;
  FPaxCompiler.RegisterHeader(0, 'function SecH(const X: Double): Double;', @StdMFunc);

  StdMFunc := CscH;
  FPaxCompiler.RegisterHeader(0, 'function CscH(const X: Double): Double;', @StdMFunc);

  StdMFunc := ArcCot;
  FPaxCompiler.RegisterHeader(0, 'function ArcCot(const X: Double): Double;', @StdMFunc);

  StdMFunc := ArcSec;
  FPaxCompiler.RegisterHeader(0, 'function ArcSec(const X: Double): Double;', @StdMFunc);

  StdMFunc := ArcCsc;
  FPaxCompiler.RegisterHeader(0, 'function ArcCsc(const X: Double): Double;', @StdMFunc);

  StdMFunc := ArcCosh;
  FPaxCompiler.RegisterHeader(0, 'function ArcCosh(const X: Double): Double;', @StdMFunc);

  StdMFunc := ArcSinh;
  FPaxCompiler.RegisterHeader(0, 'function ArcSinh(const X: Double): Double;', @StdMFunc);

  StdMFunc := ArcTanh;
  FPaxCompiler.RegisterHeader(0, 'function ArcTanh(const X: Double): Double;', @StdMFunc);

  StdMFunc := ArcCotH;
  FPaxCompiler.RegisterHeader(0, 'function ArcCotH(const X: Double): Double;', @StdMFunc);

  StdMFunc := ArcSecH;
  FPaxCompiler.RegisterHeader(0, 'function ArcSecH(const X: Double): Double;', @StdMFunc);

  StdMFunc := ArcCscH;
  FPaxCompiler.RegisterHeader(0, 'function ArcCscH(const X: Double): Double;', @StdMFunc);

  StdMFunc := LnXP1;
  FPaxCompiler.RegisterHeader(0, 'function LnXP1(const X: Double): Double;', @StdMFunc);

  StdMFunc := Log10;
  FPaxCompiler.RegisterHeader(0, 'function Log10(const X: Double): Double;', @StdMFunc);

  StdMFunc := Log2;
  FPaxCompiler.RegisterHeader(0, 'function Log2(const X: Double): Double;', @StdMFunc);

  StdDFunc := LogN;
  FPaxCompiler.RegisterHeader(0, 'function LogN(const Base, X: Double): Double;', @StdDFunc);

  LIntPowerFunc := IntPower;
  FPaxCompiler.RegisterHeader(0, 'function IntPower(const Base: Double; const Exponent: Integer): Double;', @LIntPowerFunc);

  StdDFunc := Power;
  FPaxCompiler.RegisterHeader(0, 'function Power(const Base, Exponent: Double): Double;', @StdDFunc);

  DoubleIntegerMFunc := Ceil;
  FPaxCompiler.RegisterHeader(0, 'function Ceil(const X: Double): Integer;', @DoubleIntegerMFunc);

  DoubleIntegerMFunc := Floor;
  FPaxCompiler.RegisterHeader(0, 'function Floor(const X: Double): Integer;', @DoubleIntegerMFunc);

  StdDFunc := Min;
  FPaxCompiler.RegisterHeader(0, 'function Min(const A, B: Double): Double;', @StdDFunc);

  StdDFunc := Max;
  FPaxCompiler.RegisterHeader(0, 'function Max(const A, B: Double): Double;', @StdDFunc);

  LRandGFunc := RandG;
  FPaxCompiler.RegisterHeader(0, 'function RandG(Mean, StdDev: Double): Double;', @LRandGFunc);

  DoubleBooleanMonadicFunc := IsNan;
  FPaxCompiler.RegisterHeader(0, 'function IsNan(const AValue: Double): Boolean;', @DoubleBooleanMonadicFunc);

  DoubleBooleanMonadicFunc := IsInfinite;
  FPaxCompiler.RegisterHeader(0, 'function IsInfinite(const AValue: Double): Boolean;', @DoubleBooleanMonadicFunc);
end;

function LocalIntToStr(Value: Integer): String;
begin
  Result := IntToStr(Value);
end;

function LocalFloatToStr(Value: Double): String;
begin
  Result := FloatToStr(Value);
end;

procedure LocalOutputDebugString(const Msg: String);
begin
  Windows.OutputDebugString(PWideChar(Msg));
end;

procedure TPaxFormulaCompiler.Register_MiscFunctions;
begin
  FPaxCompiler.RegisterHeader(0, 'function IntToStr(Value: Integer): String;', @LocalIntToStr);
  FPaxCompiler.RegisterHeader(0, 'function FloatToStr(Value: Double): String;', @LocalFloatToStr);
  FPaxCompiler.RegisterHeader(0, 'procedure OutputDebugString(const Msg: String)', @LocalOutputDebugString);
end;

procedure TPaxFormulaCompiler.Initialize;
begin
  Register_TypeTIteration3D;
  Register_TypeTIteration3Dext;
  Register_MathFunctions;
  Register_MiscFunctions;
end;

{$ifdef JIT_FORMULA_PREPROCESSING}
function TPaxFormulaCompiler.PreprocessCode(const Code: String; const Formula: TJITFormula): String;
var
  CodeLines: TStringList;
  VarSegment, CodeSegment: TStringList;
  I: Integer;
  ProcStartLine, VarStartLine, BeginStartLine: Integer;

  function NameToPascalName(const Name: String): String;
  var
    I: Integer;
  begin
    Result := Name;
    for I := 1 to Length(Result) do begin
      if (Result[I]=' ') or (Result[I]='-') or (Result[I]='+') or (Result[I]='/') or (Result[I]='*') or (Result[I]='') then
        Result[I] := '_';
    end;
  end;

  procedure CreateSegments(VarSegment, CodeSegment: TStringList);
  var
    I, COffSet, VOffset: Integer;
    Pair: TNameValuePair;
  begin
    VarSegment.Add('  // begin preprocessor');
    CodeSegment.Add('  // begin preprocessor');
    COffset := 0;
    VOffset := 16;
    for I := 0 to Formula.GetValueCount(vtConst) - 1 do begin
      Pair := Formula.GetValue(vtConst, I);
      VarSegment.Add('  ' + NameToPascalName(Pair.Name) + ': '+JITValueDatatypeToStr(Pair.Datatype)+';');
      CodeSegment.Add('  ' + NameToPascalName(Pair.Name) + ' := P'+JITValueDatatypeToStr(Pair.Datatype)+'(Integer(PIteration3D^.PVar) + '+IntToStr(COffset)+')^;');
      Inc(COffset, JITValueDatatypeSize(Pair.Datatype));
    end;

    for I := 0 to Formula.GetValueCount(vtParam) - 1 do begin
      Pair := Formula.GetValue(vtParam, I);
      VarSegment.Add('  ' + NameToPascalName(Pair.Name) + ': '+JITValueDatatypeToStr(Pair.Datatype)+';');
      CodeSegment.Add('  ' + NameToPascalName(Pair.Name) + ' := P'+JITValueDatatypeToStr(Pair.Datatype)+'(Integer(PIteration3D^.PVar) - '+IntToStr(VOffset)+')^;');
      Inc(VOffset, JITValueDatatypeSize(Pair.Datatype));
    end;

    VarSegment.Add('  // end preprocessor');
    CodeSegment.Add('  // end preprocessor');
  end;

  function IsWhiteSpace(const C: Char): Boolean;
  begin
    Result := (C=' ') or (C=#13) or (C=#10) or (C=#9);
  end;

  function FindLineWithTerm(const SearchTerm: String; const LineOffset: Integer): Integer;
  var
    I, P: Integer;
    LCLine, LCSearchTerm: String;
    CharBefore, CharAfter: Char;
  begin
    Result := -1;
    LCSearchTerm := AnsiLowerCase(SearchTerm);
    for I := LineOffset to CodeLines.Count - 1 do begin
      LCLine := AnsiLowerCase(CodeLines[I]);
      P := Pos(LCSearchTerm, LCLine);
      if P > 0 then begin
        if P > 1 then
          CharBefore := Copy(LCLine, P - 1, 1)[1]
        else
          CharBefore := ' ';
        if P + Length(LCSearchTerm) < Length(LCLine) then
          CharAfter := Copy(LCLine, P + Length(LCSearchTerm))[1]
        else
          CharAfter := ' ';
        if IsWhiteSpace(CharBefore) and IsWhiteSpace(CharAfter) then begin
          Result := I;
          break;
        end;
      end;
    end;
  end;

begin
  Result := Code;
  if (Formula.GetValueCount(vtConst) > 0) or (Formula.GetValueCount(vtParam) > 0) then begin
    CodeLines := TStringList.Create;
    try
      CodeLines.Text := Code;
      ProcStartLine := FindLineWithTerm('procedure', 0);
      if ProcStartLine >= 0 then begin
        BeginStartLine := FindLineWithTerm('begin', ProcStartLine + 1);
        if BeginStartLine < 0 then
          raise Exception.Create('Preprocessing error: <procedure> found, but no <begin>');
        VarStartLine := FindLineWithTerm('var', ProcStartLine + 1);
        if VarStartLine > BeginStartLine then
          VarStartLine := -1;


        VarSegment := TStringList.Create;
        try
          CodeSegment := TStringList.Create;
          try
            CreateSegments(VarSegment, CodeSegment);
            if VarStartLine >= 0 then begin
              for I := 0 to VarSegment.Count-1 do
                CodeLines.Insert(VarStartLine + 1 + I, VarSegment[I]);
              for I := 0 to CodeSegment.Count-1 do
                CodeLines.Insert(BeginStartLine + VarSegment.Count + 1 + I, CodeSegment[I]);
            end
            else begin
              CodeLines.Insert(BeginStartLine, 'var');
              for I := 0 to VarSegment.Count-1 do
                CodeLines.Insert(BeginStartLine + 1 + I, VarSegment[I]);
              for I := 0 to CodeSegment.Count-1 do
                CodeLines.Insert(BeginStartLine + VarSegment.Count + 2 + I, CodeSegment[I]);
            end;
          finally
            CodeSegment.Free;
          end;
        finally
          VarSegment.Free;
        end;
        Result := CodeLines.Text;
      end;
    finally
      CodeLines.Free;
    end;
  end
  else
end;
{$endif}

function TPaxFormulaCompiler.CompileFormula(const Formula: TJITFormula): TCompiledFormula;
const
  DfltModule = '1';
var
  ProcName: String;
  CodeLine: String;
  I, P1, P2:Integer;
  H_ProcName: Integer;
  CodeLines: TStringList;
  Code: String;
  // MemStream: TMemoryStream;
begin
  Result := TPaxCompiledFormula.Create;
  try
    TPaxCompiledFormula(Result).FPaxProgram := TPaxProgram.Create(nil);
    FPaxCompiler.ResetCompilation;
    FPaxCompiler.AddModule(DfltModule, FPaxPascalLanguage.LanguageName);
    // add formula-code (Delphi procedure) here
    ProcName := '';
    if (Formula <> nil) and (Trim(Formula.Code) <> '') then begin
      {$ifdef JIT_FORMULA_PREPROCESSING}
      Code := PreprocessCode(Formula.Code, Formula);
      {$else}
      Code := Formula.Code;
      {$endif}
      CodeLines := TStringList.Create;
      try
        CodeLines.Text := Code;
        for I := 0 to CodeLines.Count - 1 do begin
          CodeLine := CodeLines[I];
          FPaxCompiler.AddCode(DfltModule, CodeLine);
          if ProcName = '' then begin
            P1 := Pos('procedure ', CodeLine);
            if P1 > 0 then begin
              P2 := Pos('(', CodeLine, P1 + 1);
              if P2 > P1 then
                ProcName := Trim(Copy(CodeLine, P1 + 10, P2 - P1 - 10));
            end;
          end;
        end;
      finally
        CodeLines.Free;
      end;
    end;
    if ProcName = '' then begin
      Result.AddErrorMessage('No formula found');
      Result.AddErrorMessage('Should be something like <procedure MyFormula(var x, y, z, w: Double; PIteration3D: TPIteration3D);>');
      exit;
    end;
    // add main body
    FPaxCompiler.AddCode(DfltModule, 'begin');
    FPaxCompiler.AddCode(DfltModule, 'end.');

    FPaxCompiler.DebugMode := False;
    if FPaxCompiler.Compile(TPaxCompiledFormula(Result).FPaxProgram, False, False) then begin
      H_ProcName := FPaxCompiler.GetHandle(0, ProcName, true);
(*
      MemStream := TMemoryStream.Create;
      try
        TPaxCompiledFormula(Result).FPaxProgram.SaveToStream(MemStream);
        OutputDebugString(PChar('Saved: '+IntToStr(MemStream.Size)+' '+IntToStr( TPaxCompiledFormula(Result).FPaxProgram.ImageSize)));
        MemStream.Seek(0, soBeginning);
        TPaxCompiledFormula(Result).FPaxProgram.LoadFromStream(MemStream);
      finally
        MemStream.Free;
      end;
*)
      Result.FCodePointer := TPaxCompiledFormula(Result).FPaxProgram.GetAddress(H_ProcName);
      Result.FCodeSize := TPaxCompiledFormula(Result).FPaxProgram.ProgramSize;
    end
    else begin
      for I:=0 to FPaxCompiler.ErrorCount do
        Result.AddErrorMessage(FPaxCompiler.ErrorMessage[I]);
    end;
  except
    FreeAndNil(Result);
    raise;
  end;
end;
{ --------------------------- TPaxCompiledFormula ---------------------------- }
destructor TPaxCompiledFormula.Destroy;
begin
  if Assigned(FPaxProgram) then
    FreeAndNil(FPaxProgram);
  inherited Destroy;
end;
{$endif}
{ ------------------------ TFormulaCompilerRegistry -------------------------- }
{$ifdef USE_PAX_COMPILER}
var
  PaxFormulaCompiler : TPaxFormulaCompiler;
{$endif}

class function TFormulaCompilerRegistry.GetCompilerInstance(const FormulaLanguage: TFormulaLanguage): TFormulaCompiler;
begin
  case FormulaLanguage of
    langDELPHI:
      begin
        {$ifdef USE_PAX_COMPILER}
        if PaxFormulaCompiler = nil then
          PaxFormulaCompiler := TPaxFormulaCompiler.Create;
        Result := PaxFormulaCompiler;
        exit;
        {$endif}
      end;
  end;

  raise Exception.Create('No compiler available for language <'+GetEnumName(TypeInfo(TFormulaLanguage), Ord(FormulaLanguage))+'>');
end;

initialization
  {$ifdef USE_PAX_COMPILER}
  PaxFormulaCompiler := nil;
  {$endif}
finalization
  {$ifdef USE_PAX_COMPILER}
  FreeAndNil(PaxFormulaCompiler);
  {$endif}
end.

