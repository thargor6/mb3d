{ ---------------------------------------------------------------------------- }
{ Scripting for MB3D                                                          }
{ Copyright (C) 2017 Andreas Maschke                                      }
{ ---------------------------------------------------------------------------- }

unit ScriptCompiler;

interface

uses
  SysUtils, Classes, TypeDefinitions, JITFormulas,
{$ifdef USE_PAX_COMPILER}
  PaxCompiler, PaxProgram, PaxRegister,
{$endif}
  CompilerUtil;

type
{$ifdef USE_PAX_COMPILER}
  TPaxCompiledScript = class (TCompiledArtifact)
  private
    FPaxProgram: TPaxProgram;
  public
    destructor Destroy;override;
    property PaxProgram: TPaxProgram read FPaxProgram;
  end;

  TPaxScriptCompiler = class (TPaxArtifactCompiler)
  protected
    procedure RegisterFunctions; override;
  public
    function CompileScript(const Script: String): TPaxCompiledScript;
  end;
{$endif}

  TScriptCompiler = class
  private
{$ifdef USE_PAX_COMPILER}
    FDelegate: TPaxScriptCompiler;
{$endif}
  public
    constructor Create;
    destructor Destroy; override;
    function CompileScript(const Script: String): TCompiledArtifact;
  end;

  TScriptCompilerRegistry = class
  public
    class function GetCompilerInstance(const Language: TCompilerLanguage): TScriptCompiler;
  end;

implementation

uses
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls, TypInfo, Math, Math3D;

{$ifdef USE_PAX_COMPILER}
{ ---------------------------- TPaxScriptCompiler ---------------------------- }
procedure TPaxScriptCompiler.RegisterFunctions;
begin
  Register_MathFunctions;
  Register_MiscFunctions;
end;

function TPaxScriptCompiler.CompileScript(const Script: String): TPaxCompiledScript;
const
  DfltModule = '1';
var
  I:Integer;
begin
  Result := TPaxCompiledScript.Create;
  try
    TPaxCompiledScript(Result).FPaxProgram := TPaxProgram.Create(nil);
    FPaxCompiler.ResetCompilation;
    FPaxCompiler.AddModule(DfltModule, FPaxPascalLanguage.LanguageName);


    with TStringList.Create do begin
      Text := Script;
      for I := 0 to Count - 1 do
        FPaxCompiler.AddCode(DfltModule, Strings[ I ] );
    end;

    FPaxCompiler.DebugMode := False;
    if FPaxCompiler.Compile(TPaxCompiledScript(Result).FPaxProgram, False, False) then begin
      Result.CodePointer := TPaxCompiledScript(Result).FPaxProgram.GetProgPtr;
      Result.CodeSize := TPaxCompiledScript(Result).FPaxProgram.ProgramSize;
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
{ -------------------------- TPaxCompiledScript ------------------------------ }
destructor TPaxCompiledScript.Destroy;
begin
  if Assigned(FPaxProgram) then
    FreeAndNil(FPaxProgram);
  inherited Destroy;
end;
{$endif}
{ ------------------------- TScriptCompilerRegistry -------------------------- }
{$ifdef USE_PAX_COMPILER}
var
  PaxScriptCompiler : TScriptCompiler;
{$endif}

class function TScriptCompilerRegistry.GetCompilerInstance(const Language: TCompilerLanguage): TScriptCompiler;
begin
  case Language of
    langDELPHI:
      begin
        {$ifdef USE_PAX_COMPILER}
        if PaxScriptCompiler = nil then
          PaxScriptCompiler := TScriptCompiler.Create;
        Result := PaxScriptCompiler;
        exit;
        {$endif}
      end;
  end;

  raise Exception.Create('No compiler available for language <'+GetEnumName(TypeInfo(TCompilerLanguage), Ord(Language))+'>');
end;
{ ---------------------------- TScriptCompiler ------------------------------- }
constructor TScriptCompiler.Create;
begin
  inherited;
{$ifdef USE_PAX_COMPILER}
  FDelegate := TPaxScriptCompiler.Create;
{$endif}
end;

destructor TScriptCompiler.Destroy;
begin
{$ifdef USE_PAX_COMPILER}
  FDelegate.Free;
{$endif}
  inherited;
end;

function TScriptCompiler.CompileScript(const Script: String): TCompiledArtifact;
begin
{$ifdef USE_PAX_COMPILER}
   Result := FDelegate.CompileScript( Script );
{$endif}
end;

initialization
  {$ifdef USE_PAX_COMPILER}
  PaxScriptCompiler := nil;
  {$endif}
finalization
  {$ifdef USE_PAX_COMPILER}
  FreeAndNil(PaxScriptCompiler);
  {$endif}
end.

