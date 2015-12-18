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
  TypInfo, Math;

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
begin
  FPaxCompiler.RegisterHeader(0, 'function ArcTan2(const Y, X: Extended): Extended;', @ArcTan2);
end;

procedure TPaxFormulaCompiler.Initialize;
begin
  Register_TypeTIteration3D;
  Register_MathFunctions;
end;

{$ifdef JIT_FORMULA_PREPROCESSING}
function TPaxFormulaCompiler.PreprocessCode(const Code: String; const Formula: TJITFormula): String;
var
  CodeLines: TStringList;
  VarSegment, CodeSegment: TStringList;
  I: Integer;
  ProcStartLine, VarStartLine, BeginStartLine: Integer;

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
      VarSegment.Add('  ' + Pair.Name + ': '+JITValueDatatypeToStr(Pair.Datatype)+';');
      CodeSegment.Add('  ' + Pair.Name + ' := P'+JITValueDatatypeToStr(Pair.Datatype)+'(Integer(PIteration3D^.PVar) + '+IntToStr(COffset)+')^;');
      Inc(COffset, JITValueDatatypeSize(Pair.Datatype));
    end;

    for I := 0 to Formula.GetValueCount(vtParam) - 1 do begin
      Pair := Formula.GetValue(vtParam, I);
      VarSegment.Add('  ' + Pair.Name + ': '+JITValueDatatypeToStr(Pair.Datatype)+';');
      CodeSegment.Add('  ' + Pair.Name + ' := P'+JITValueDatatypeToStr(Pair.Datatype)+'(Integer(PIteration3D^.PVar) - '+IntToStr(VOffset)+')^;');
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

