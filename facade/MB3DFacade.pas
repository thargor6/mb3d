unit MB3DFacade;

interface

uses
  Classes, TypeDefinitions;

type
  TMB3DParamsFacade = class;

  TMB3DFormulaFacade = class
  private
    FOwner: TMB3DParamsFacade;
    FFormulaIndex: Integer;
    function GetFormulaName: String;
    function GetParamCount: Integer;
    function GetParamValue(Index: Integer): Double;
    procedure SetParamValue(Index: Integer;const Value: Double);
    function GetParamName(Index: Integer): String;
    constructor Create(const FormulaIndex: Integer;const Owner: TMB3DParamsFacade);
  public
    property FormulaName: String read GetFormulaName;
    property ParamCount: Integer read GetParamCount;
    property ParamNames[Index: Integer]: String read GetParamName;
    property ParamValues[Index: Integer]: Double read GetParamValue write SetParamValue;
  end;

  TMB3DCoreFacade = class
  private
    FHybridCustoms: array[0..MAX_FORMULA_COUNT - 1] of TCustomFormula;
    FHeader: TMandHeader11;
    FHAddOn: THeaderCustomAddon;
  public
    constructor Create(const Header: TMandHeader11;const HAddOn: THeaderCustomAddon);
    destructor Destroy;override;

    property Header: TMandHeader11 read FHeader;
    property HAddOn: THeaderCustomAddon read FHAddOn;
  end;

  TMB3DParamsFacade = class
  private
    FCore: TMB3DCoreFacade;
    FFormulas: TList;
    function GetFormula(Index: Integer): TMB3DFormulaFacade;
  public
    constructor Create(const Header: TMandHeader11;const HAddOn: THeaderCustomAddon);
    destructor Destroy;override;
    property Core: TMB3DCoreFacade read FCore;
    property Formulas[Index: Integer]: TMB3DFormulaFacade read GetFormula;
  end;

implementation

uses
  DivUtils, CustomFormulas, HeaderTrafos, Contnrs, SysUtils;

{ --------------------------- TMB3DFormulaFacade ----------------------------- }
constructor TMB3DFormulaFacade.Create(const FormulaIndex: Integer;const Owner: TMB3DParamsFacade);
begin
  inherited Create;
  FFormulaIndex := FormulaIndex;
  FOwner := Owner;
end;

function TMB3DFormulaFacade.GetFormulaName: String;
begin
  Result := CustomFtoStr(FOwner.Core.HAddon.Formulas[FFormulaIndex].CustomFname);
end;

function TMB3DFormulaFacade.GetParamCount: Integer;
begin
  Result := FOwner.Core.HAddon.Formulas[FFormulaIndex].iOptionCount;
end;

function TMB3DFormulaFacade.GetParamValue(Index: Integer): Double;
begin
  if (Index < 0) or (Index >= GetParamCount) then
    raise Exception.Create('GetParamValue: Invalid param index <'+IntToStr(Index)+'>');
  Result := FOwner.Core.HAddon.Formulas[FFormulaIndex].dOptionValue[Index]
end;

procedure TMB3DFormulaFacade.SetParamValue(Index: Integer;const Value: Double);
var
  f: PTHAformula;
begin
  if (Index < 0) or (Index >= GetParamCount) then
    raise Exception.Create('SetParamValue: Invalid param index <'+IntToStr(Index)+'>');
  f := @FOwner.Core.HAddon.Formulas[Index];
  if CustomFormulas.isIntType(PTCustomFormula(FOwner.Core.Header.PHCustomF[FFormulaIndex]).byOptionTypes[Index]) then
    f^.dOptionValue[Index] := Round(Value)
  else
    f^.dOptionValue[Index] := Value;
end;

function TMB3DFormulaFacade.GetParamName(Index: Integer): String;
begin
  if (Index < 0) or (Index >= GetParamCount) then
    raise Exception.Create('GetParamName: Invalid param index <'+IntToStr(Index)+'>');
  Result := PTCustomFormula(FOwner.Core.Header.PHCustomF[FFormulaIndex]).sOptionStrings[Index]
end;
{ ----------------------------- TMB3DCoreFacade ------------------------------ }
constructor TMB3DCoreFacade.Create(const Header: TMandHeader11;const HAddOn: THeaderCustomAddon);
var
  i: Integer;
begin
  inherited Create;
  for i := 0 to MAX_FORMULA_COUNT - 1 do
    FHeader.PHCustomF[i] := @FHybridCustoms[i];
  FHeader.PCFAddon := @FHAddOn;

  AssignHeader(@FHeader, @Header);
  IniCFsFromHAddon(FHeader.PCFAddon, FHeader.PHCustomF);
(*

  FastMove(Header, FHeader, SizeOf(TMandHeader11));
  FastMove(HAddOn, FHAddOn, SizeOf(THeaderCustomAddon));
  FHeader.PCFAddon := @FHAddOn;
  for i := 0 to MAX_FORMULA_COUNT - 1 do
    FHeader.PHCustomF[i] := @FHybridCustoms[i];
  for i := 0 to MAX_FORMULA_COUNT - 1 do
    IniCustomF(@FHybridCustoms[i]);*)
end;

destructor TMB3DCoreFacade.Destroy;
var
  i: Integer;
begin
  for i := 0 to MAX_FORMULA_COUNT - 1 do
    FreeCF(@FHybridCustoms[i]);
  inherited Destroy;
end;
{ ---------------------------- TMB3DParamsFacade ------------------------------ }
constructor TMB3DParamsFacade.Create(const Header: TMandHeader11;const HAddOn: THeaderCustomAddon);
var
  I: Integer;
begin
  inherited Create;
  FCore := TMB3DCoreFacade.Create(Header, HAddOn);
  FFormulas:=TObjectList.Create;
  for I := 0 to MAX_FORMULA_COUNT do
    FFormulas.Add(TMB3DFormulaFacade.Create(I, Self));
end;

destructor TMB3DParamsFacade.Destroy;
begin
  FFormulas.Free;
  FCore.Free;
  inherited Destroy;
end;

function TMB3DParamsFacade.GetFormula(Index: Integer): TMB3DFormulaFacade;
begin
  if (Index < 0) or (Index >= FFormulas.Count) then
    raise Exception.Create('GetFormula: Invalid formula index <'+IntToStr(Index)+'>');
  Result := TMB3DFormulaFacade(FFormulas[Index]);
end;


end.
