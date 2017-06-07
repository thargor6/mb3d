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
  end;

  TPaxScriptCompiler = class (TPaxArtifactCompiler)
  protected
    procedure RegisterFunctions; override;
  public
    function CompileScript(const Script: String): TCompiledArtifact;
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

function TPaxScriptCompiler.CompileScript(const Script: String): TCompiledArtifact;
begin
  // TODO
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

