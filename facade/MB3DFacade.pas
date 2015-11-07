unit MB3DFacade;

interface

uses
  Classes, TypeDefinitions;

type
  TMB3DParamsFacade = class;
  TMB3DFormulaFacade = class;

  TMB3DParamType = (ptFloat, ptInteger);

  TMB3DParamFacade = class
  private
    FOwner: TMB3DFormulaFacade;
    FParamIndex: Integer;
    function GetName: String;
    function GetDatatype: TMB3DParamType;
    function GetValue: Double;
    procedure SetValue(const Value: Double);
    constructor Create(const ParamIndex: Integer;const Owner: TMB3DFormulaFacade);
  public
    property Name: String read GetName;
    property Datatype: TMB3DParamType read GetDatatype;
    property Value: Double read GetValue write SetValue;
  end;

  TMB3DFormulaFacade = class
  private
    FOwner: TMB3DParamsFacade;
    FFormulaIndex: Integer;
    FParams: TList;
    function GetFormulaName: String;
    function GetParam(Index: Integer): TMB3DParamFacade;
    function GetParamCount: Integer;
    constructor Create(const FormulaIndex: Integer;const Owner: TMB3DParamsFacade);
    destructor Destroy;override;
  public
    procedure Clear;
    function IsEmpty: Boolean;
    property FormulaName: String read GetFormulaName;
    property ParamCount: Integer read GetParamCount;
    property Params[Index: Integer]: TMB3DParamFacade read GetParam;
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
    function GetFormulaCount: Integer;
  public
    constructor Create(const Header: TMandHeader11;const HAddOn: THeaderCustomAddon);
    destructor Destroy;override;
    function Clone: TMB3DParamsFacade;
    property Core: TMB3DCoreFacade read FCore;
    property Formulas[Index: Integer]: TMB3DFormulaFacade read GetFormula;
    property FormulaCount: Integer read GetFormulaCount;
  end;

implementation

uses
  DivUtils, CustomFormulas, HeaderTrafos, Contnrs, SysUtils;

{ ---------------------------- TMB3DParamFacade ------------------------------ }
constructor TMB3DParamFacade.Create(const ParamIndex: Integer;const Owner: TMB3DFormulaFacade);
begin
  inherited Create;
  FParamIndex := ParamIndex;
  FOwner := Owner;
end;

function TMB3DParamFacade.GetName: String;
begin
  Result := PTCustomFormula(FOwner.FOwner.Core.Header.PHCustomF[FOwner.FFormulaIndex]).sOptionStrings[FParamIndex];
end;

function TMB3DParamFacade.GetDatatype: TMB3DParamType;
begin
  if CustomFormulas.isIntType(PTCustomFormula(FOwner.FOwner.Core.Header.PHCustomF[FOwner.FFormulaIndex]).byOptionTypes[FParamIndex]) then
    Result := ptInteger
  else
    Result := ptFloat;
end;

function TMB3DParamFacade.GetValue: Double;
begin
  Result := FOwner.FOwner.Core.HAddon.Formulas[FOwner.FFormulaIndex].dOptionValue[FParamIndex];
end;

procedure TMB3DParamFacade.SetValue(const Value: Double);
var
  f: PTHAformula;
begin
  f := @FOwner.FOwner.Core.HAddon.Formulas[FParamIndex];
  if Datatype = ptInteger then
    f^.dOptionValue[FParamIndex] := Round(Value)
  else
    f^.dOptionValue[FParamIndex] := Value;
end;
{ --------------------------- TMB3DFormulaFacade ----------------------------- }
constructor TMB3DFormulaFacade.Create(const FormulaIndex: Integer;const Owner: TMB3DParamsFacade);
var
  I: Integer;
begin
  inherited Create;
  FFormulaIndex := FormulaIndex;
  FOwner := Owner;
  FParams:=TObjectList.Create;
  for I := 0 to V18_FORMULA_PARAM_COUNT -1  do
    FParams.Add(TMB3DParamFacade.Create(I, Self));
end;

destructor TMB3DFormulaFacade.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

function TMB3DFormulaFacade.GetFormulaName: String;
begin
  Result := CustomFtoStr(FOwner.Core.HAddon.Formulas[FFormulaIndex].CustomFname);
end;

function TMB3DFormulaFacade.GetParamCount: Integer;
begin
  Result := FOwner.Core.HAddon.Formulas[FFormulaIndex].iOptionCount;
end;

procedure TMB3DFormulaFacade.Clear;
begin
  with FOwner.Core.FHAddOn.Formulas[FFormulaIndex] do begin
    iItCount := 0;
    iFnr := -1;
    iOptionCount := 0;
    CustomFname[0] := 0;
  end;
end;

function TMB3DFormulaFacade.IsEmpty: Boolean;
begin
  Result := FOwner.Core.FHAddOn.Formulas[FFormulaIndex].iItCount = 0;
end;

function TMB3DFormulaFacade.GetParam(Index: Integer): TMB3DParamFacade;
begin
  if (Index < 0) or (Index >= FParams.Count) then
    raise Exception.Create('TMB3DFormulaFacade.GetParam: Invalid param index <'+IntToStr(Index)+'>');
  Result := TMB3DParamFacade(FParams[Index]);
end;
{ ----------------------------- TMB3DCoreFacade ------------------------------ }
constructor TMB3DCoreFacade.Create(const Header: TMandHeader11;const HAddOn: THeaderCustomAddon);
var
  i: Integer;
begin
  inherited Create;
//  AssignHeader(@FHeader, @Header);
    FastMove(Header, FHeader, SizeOf(TMandHeader11));
    FHeader.PCFAddon := @FHAddOn;
    FastMove(HAddOn, FHeader.PCFAddon^, SizeOf(THeaderCustomAddon));


//  for i := 0 to MAX_FORMULA_COUNT - 1 do
//    FHeader.PHCustomF[i] := @FHybridCustoms[i];
//  IniCFsFromHAddon(FHeader.PCFAddon, Header.PHCustomF);
end;

destructor TMB3DCoreFacade.Destroy;
var
  i: Integer;
begin
  for i := 0 to MAX_FORMULA_COUNT - 1 do
    FreeCF(@FHybridCustoms[i]);
  inherited Destroy;
end;
{ ---------------------------- TMB3DParamsFacade ----------------------------- }
constructor TMB3DParamsFacade.Create(const Header: TMandHeader11;const HAddOn: THeaderCustomAddon);
var
  I: Integer;
begin
  inherited Create;
  FCore := TMB3DCoreFacade.Create(Header, HAddOn);
  FFormulas:=TObjectList.Create;
  for I := 0 to MAX_FORMULA_COUNT-1 do
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
    raise Exception.Create('TMB3DParamsFacade.GetFormula: Invalid formula index <'+IntToStr(Index)+'>');
  Result := TMB3DFormulaFacade(FFormulas[Index]);
end;

function TMB3DParamsFacade.Clone: TMB3DParamsFacade;
begin
  Result := TMB3DParamsFacade.Create( Core.Header, Core.HAddOn );
end;

function TMB3DParamsFacade.GetFormulaCount: Integer;
begin
  Result := FFormulas.Count;
end;


end.
