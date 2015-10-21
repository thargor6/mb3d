unit FormulaCompiler;

interface

uses
  SysUtils, Classes, TypeDefinitions;

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
    function CompileFormula(const Formula: TStrings): TCompiledFormula;virtual;abstract;
  end;

  TFormulaCompilerRegistry = class
  public
    class function GetCompilerInstance(const FormulaLanguage: TFormulaLanguage): TFormulaCompiler;
  end;

implementation

uses
  Windows, Messages, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
{$ifdef USE_PAX_COMPILER}
  PaxCompiler, PaxProgram, PaxRegister,
{$endif}
  TypInfo;

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
    procedure Register_MathFunctions;
  public
    constructor Create;
    destructor Destroy; override;
    function CompileFormula(const Formula: TStrings): TCompiledFormula;override;
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
  {$endif}
begin
  H_FormulaRange := FPaxCompiler.RegisterSubrangeType(0, 'FormulaRange', _typeCHAR, 0, V18_FORMULA_COUNT - 1);

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
  FPaxCompiler.RegisterArrayType(H_TIteration3D, 'unused_nHybrid', H_FormulaRange, _typeINTEGER, true);
  FPaxCompiler.RegisterArrayType(H_TIteration3D, 'unused_fHPVar', H_FormulaRange, _typePOINTER, true);
  FPaxCompiler.RegisterArrayType(H_TIteration3D, 'unused_fHybrid', H_FormulaRange, _typePOINTER, true);
  {$else}
  FPaxCompiler.RegisterArrayType(H_TIteration3D, 'nHybrid', H_FormulaRange, _typeINTEGER, true);
  FPaxCompiler.RegisterArrayType(H_TIteration3D, 'fHPVar', H_FormulaRange, _typePOINTER, true);
  FPaxCompiler.RegisterArrayType(H_TIteration3D, 'fHybrid', H_FormulaRange, _typePOINTER, true);
  {$endif}
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'CalcSIT', _typeLONGBOOL);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'DoJulia', _typeLONGBOOL);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'LNRStop', _typeSINGLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'DEoption', _typeINTEGER);
  {$ifdef ENABLE_EXTENSIONS}
  FPaxCompiler.RegisterArrayType(H_TIteration3D, 'unused_fHln', H_FormulaRange, _typeSINGLE, true);
  {$else}
  FPaxCompiler.RegisterArrayType(H_TIteration3D, 'fHln', H_FormulaRange, _typeSINGLE, true);
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
  H_Range_0_35 := PaxCompiler1.RegisterSubrangeType(0, 'Range_0_35', _typeCHAR, 0, 35);
  FPaxCompiler.RegisterArrayType(H_TIteration3D, 'dummy', H_Range_0_35, _typeINTEGER, true);
  FPaxCompiler.RegisterArrayType(H_TIteration3D, 'nHybrid', H_FormulaRange, _typeINTEGER, true);
  FPaxCompiler.RegisterArrayType(H_TIteration3D, 'fHPVar', H_FormulaRange, _typePOINTER, true);
  FPaxCompiler.RegisterArrayType(H_TIteration3D, 'fHybrid', H_FormulaRange, _typePOINTER, true);
  FPaxCompiler.RegisterArrayType(H_TIteration3D, 'fHln', H_FormulaRange, _typeSINGLE, true);
  {$endif}
  {H_TPIteration3D :=} FPaxCompiler.RegisterPointerType(0, 'TPIteration3D', H_TIteration3D);
end;

procedure TPaxFormulaCompiler.Register_MathFunctions;
var
  H_ArcTan2: Integer;
begin
  H_ArcTan2 := FPaxCompiler.RegisterRoutine(0, 'ArcTan2', _typeDOUBLE, _ccREGISTER);
  FPaxCompiler.RegisterParameter(H_ArcTan2, _typeDOUBLE, _Unassigned);
  FPaxCompiler.RegisterParameter(H_ArcTan2, _typeDOUBLE, _Unassigned);
end;

procedure TPaxFormulaCompiler.Initialize;
begin
  Register_TypeTIteration3D;
  Register_MathFunctions;
end;

function TPaxFormulaCompiler.CompileFormula(const Formula: TStrings): TCompiledFormula;
const
  DfltModule = '1';
var
  ProcName: String;
  CodeLine: String;
  I, P1, P2:Integer;
  H_ProcName: Integer;
begin
  Result := TPaxCompiledFormula.Create;
  try
    TPaxCompiledFormula(Result).FPaxProgram := TPaxProgram.Create(nil);
    FPaxCompiler.ResetCompilation;
    FPaxCompiler.AddModule(DfltModule, FPaxPascalLanguage.LanguageName);
    // add formula-code (Delphi procedure) here
    ProcName := '';
    if Formula<>nil then begin
      for I := 0 to Formula.Count-1 do begin
        CodeLine := Formula[I];
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
    end;
    if ProcName = '' then begin
      Result.AddErrorMessage('No formula found');
      Result.AddErrorMessage('Should be something like <procedure MyFormula(var x, y, z, w: Double; PIteration3D: TPIteration3D);>');
      exit;
    end;
    // add main body
    FPaxCompiler.AddCode(DfltModule, 'begin');
    FPaxCompiler.AddCode(DfltModule, 'end.');

    if FPaxCompiler.Compile(TPaxCompiledFormula(Result).FPaxProgram) then begin
      H_ProcName := FPaxCompiler.GetHandle(0, ProcName, true);
      Result.FCodePointer := TPaxCompiledFormula(Result).FPaxProgram.GetAddress(H_ProcName);
      Result.FCodeSize := TPaxCompiledFormula(Result).FPaxProgram.CodeSize;
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
