(*
  FormulaJIT for MB3D
  Copyright (C) 2016-2019 Andreas Maschke

  This is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser
  General Public License as published by the Free Software Foundation; either version 2.1 of the
  License, or (at your option) any later version.

  This software is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
  even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  Lesser General Public License for more details.
  You should have received a copy of the GNU Lesser General Public License along with this software;
  if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
  02110-1301 USA, or see the FSF site: http://www.fsf.org.
*)

unit FormulaCompiler;

interface

uses
  SysUtils, Classes, TypeDefinitions, JITFormulas,
{$ifdef USE_PAX_COMPILER}
  PaxCompiler, PaxProgram, PaxRegister,
{$endif}
  CompilerUtil;

type
{$ifdef USE_PAX_COMPILER}
  TPaxCompiledFormula = class (TCompiledArtifact)
  private
    FPaxProgram: TPaxProgram;
  public
    destructor Destroy;override;
  end;

  TPaxFormulaCompiler = class (TPaxArtifactCompiler)
  private
    procedure Register_TypeTIteration3D;
    procedure Register_TypeTIteration3Dext;
  protected
    procedure RegisterFunctions; override;
  public
    {$ifdef JIT_FORMULA_PREPROCESSING}
    function PreprocessCode(const Code: String; const Formula: TJITFormula): String;
    {$endif}
    function CompileFormula(const Formula: TJITFormula): TPaxCompiledFormula;
  end;
{$endif}


  TFormulaCompiler = class
  private
{$ifdef USE_PAX_COMPILER}
    FDelegate: TPaxFormulaCompiler;
{$endif}
  public
    constructor Create;
    destructor Destroy; override;
    {$ifdef JIT_FORMULA_PREPROCESSING}
    function PreprocessCode(const Code: String; const Formula: TJITFormula): String;
    {$endif}
    function CompileFormula(const Formula: TJITFormula): TCompiledArtifact;
  end;

  TFormulaCompilerRegistry = class
  public
    class function GetCompilerInstance(const Language: TCompilerLanguage): TFormulaCompiler;
  end;

implementation

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls,
  TypInfo, Math, Math3D;

{$ifdef USE_PAX_COMPILER}
{ --------------------------- TPaxFormulaCompiler ---------------------------- }
procedure TPaxFormulaCompiler.Register_TypeTIteration3D;
var
  H_FormulaRange: Integer;
  H_TIteration3D: Integer;
  { H_TPIteration3D: Integer; }

  procedure RegisterArray(const ElemName: String; const ElemType, RangeType: Integer);
  var
    H_Type: Integer;
  begin
    H_Type := FPaxCompiler.RegisterArrayType(H_TIteration3D, 'H_T'+ElemName, RangeType, ElemType, true);
    FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, ElemName, H_Type);
  end;

begin
  H_FormulaRange := FPaxCompiler.RegisterSubrangeType(0, 'FormulaRange', _typeBYTE, 0, 5);

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

  RegisterArray('nHybrid', _typeINTEGER, H_FormulaRange);
  RegisterArray('fHPVar', _typePOINTER, H_FormulaRange);
  RegisterArray('fHybrid', _typePOINTER, H_FormulaRange);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'CalcSIT', _typeLONGBOOL);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'DoJulia', _typeLONGBOOL);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'LNRStop', _typeSINGLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3D, 'DEoption', _typeINTEGER);
  RegisterArray('fHln', _typeSINGLE, H_FormulaRange);
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
  {H_TPIteration3D :=} FPaxCompiler.RegisterPointerType(0, 'TPIteration3D', H_TIteration3D);
end;

procedure TPaxFormulaCompiler.Register_TypeTIteration3Dext;
var
  H_FormulaRange: Integer;
  H_TIteration3Dext: Integer;
  { H_TPIteration3D: Integer; }
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
  H_FormulaRange := FPaxCompiler.RegisterSubrangeType(0, 'FormulaRange', _typeBYTE, 0, 5);

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
  RegisterArray('nHybrid', _typeINTEGER, H_FormulaRange);
  RegisterArray('fHPVar', _typePOINTER, H_FormulaRange);
  RegisterArray('fHybrid', _typePOINTER, H_FormulaRange);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'CalcSIT', _typeBYTEBOOL);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'bFree', _typeBYTE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'EndTo', _typeWORD);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'DoJulia', _typeLONGBOOL);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'LNRStop', _typeSINGLE);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'DEoption', _typeINTEGER);
  RegisterArray('fHln', _typeSINGLE, H_FormulaRange);
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
  RegisterArray('pInitialization', H_TFormulaInitialization, H_FormulaRange);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'bIsInsideRender', _typeLONGBOOL);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'OTrapMode', _typeINTEGER);
  FPaxCompiler.RegisterRecordTypeField(H_TIteration3Dext, 'OTrapDE', _typeDOUBLE);
  {H_TPIteration3Dext :=} FPaxCompiler.RegisterPointerType(0, 'TPIteration3Dext', H_TIteration3Dext);
end;


procedure TPaxFormulaCompiler.RegisterFunctions;
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

function TPaxFormulaCompiler.CompileFormula(const Formula: TJITFormula): TPaxCompiledFormula;
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
    Result.FPaxProgram := TPaxProgram.Create(nil);
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
      Result.CodePointer := TPaxCompiledFormula(Result).FPaxProgram.GetAddress(H_ProcName);
      Result.CodeSize := TPaxCompiledFormula(Result).FPaxProgram.ProgramSize;
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
  PaxFormulaCompiler : TFormulaCompiler;
{$endif}

class function TFormulaCompilerRegistry.GetCompilerInstance(const Language: TCompilerLanguage): TFormulaCompiler;
begin
  case Language of
    langDELPHI:
      begin
        {$ifdef USE_PAX_COMPILER}
        if PaxFormulaCompiler = nil then
          PaxFormulaCompiler := TFormulaCompiler.Create;
        Result := PaxFormulaCompiler;
        exit;
        {$endif}
      end;
  end;

  raise Exception.Create('No compiler available for language <'+GetEnumName(TypeInfo(TCompilerLanguage), Ord(Language))+'>');
end;

{ ---------------------------- TFormulaCompiler ------------------------------ }
constructor TFormulaCompiler.Create;
begin
  inherited;
{$ifdef USE_PAX_COMPILER}
  FDelegate := TPaxFormulaCompiler.Create;
{$endif}
end;

destructor TFormulaCompiler.Destroy;
begin
{$ifdef USE_PAX_COMPILER}
  FDelegate.Free;
{$endif}
  inherited;
end;

{$ifdef JIT_FORMULA_PREPROCESSING}
function TFormulaCompiler.PreprocessCode(const Code: String; const Formula: TJITFormula): String;
begin
{$ifdef USE_PAX_COMPILER}
  Result := FDelegate.PreprocessCode( Code, Formula );
{$endif}
end;
{$endif}

function TFormulaCompiler.CompileFormula(const Formula: TJITFormula): TCompiledArtifact;
begin
{$ifdef USE_PAX_COMPILER}
  Result := FDelegate.CompileFormula( Formula );
{$endif}
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

