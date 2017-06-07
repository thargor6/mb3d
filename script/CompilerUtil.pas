unit CompilerUtil;

interface

uses
  SysUtils, Classes,
{$ifdef USE_PAX_COMPILER}
  PaxCompiler, PaxProgram, PaxRegister,
{$endif}
  Math;

type
  TCompilerLanguage = (langDELPHI);

  TCompiledArtifact = class
  protected
    FErrorMessages: TStrings;
    FCodeSize: Integer;
    FCodePointer: Pointer;
  public
    constructor Create;
    destructor Destroy;override;
    function IsValid: Boolean;
    procedure AddErrorMessage(const Msg: String);
    property ErrorMessage: TStrings read FErrorMessages;
    property CodeSize: Integer read FCodeSize write FCodeSize;
    property CodePointer: Pointer read FCodePointer write FCodePointer;
  end;

{$ifdef USE_PAX_COMPILER}
  TPaxArtifactCompiler = class
  protected
    FPaxCompiler: TPaxCompiler;
    FPaxPascalLanguage: TPaxPascalLanguage;
    procedure Register_MathFunctions;
    procedure Register_MiscFunctions;
    procedure RegisterFunctions; virtual; abstract;
  public
    constructor Create;
    destructor Destroy; override;
  end;
{$endif}

implementation

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls, Math3D;

{ ---------------------------- TCompiledArtifact ----------------------------- }
constructor TCompiledArtifact.Create;
begin
  inherited Create;
  FErrorMessages := TStringList.Create;
end;

destructor TCompiledArtifact.Destroy;
begin
  FreeAndNil(FErrorMessages);
  inherited Destroy;
end;

procedure TCompiledArtifact.AddErrorMessage(const Msg: String);
begin
  FErrorMessages.Add(Msg)
end;

function TCompiledArtifact.IsValid: Boolean;
begin
  Result := (FErrorMessages.Count = 0) and (FCodeSize > 0);
end;

{$ifdef USE_PAX_COMPILER}
{ --------------------------- TPaxArtifactCompiler --------------------------- }
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

constructor TPaxArtifactCompiler.Create;
begin
  inherited Create;
  FPaxPascalLanguage := TPaxPascalLanguage.Create(nil);
  FPaxCompiler := TPaxCompiler.Create(nil);
  RegisterFunctions;
end;

destructor TPaxArtifactCompiler.Destroy;
begin
  FreeAndNil(FPaxPascalLanguage);
  FreeAndNil(FPaxCompiler);
  inherited Destroy;
end;


procedure TPaxArtifactCompiler.Register_MathFunctions;
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

procedure TPaxArtifactCompiler.Register_MiscFunctions;
begin
  FPaxCompiler.RegisterHeader(0, 'function IntToStr(Value: Integer): String;', @LocalIntToStr);
  FPaxCompiler.RegisterHeader(0, 'function FloatToStr(Value: Double): String;', @LocalFloatToStr);
  FPaxCompiler.RegisterHeader(0, 'procedure OutputDebugString(const Msg: String)', @LocalOutputDebugString);
end;
{$endif}

end.
