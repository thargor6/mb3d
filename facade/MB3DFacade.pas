{ ---------------------------------------------------------------------------- }
{ MB3D-Facade                                                                  }
{ Copyright (C) 2016-2017 Andreas Maschke                                      }
{ ---------------------------------------------------------------------------- }
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
    procedure SetFormulaName(const FormulaName: String);
    function GetParam(Index: Integer): TMB3DParamFacade;
    function GetParamCount: Integer;
    procedure SetIterationCount(const IterationCount: Integer);
    function GetIterationCount: Integer;
  public
    constructor Create(const FormulaIndex: Integer;const Owner: TMB3DParamsFacade);
    destructor Destroy;override;
    procedure Clear;
    function IsEmpty: Boolean;
    property FormulaName: String read GetFormulaName write SetFormulaName;
    property ParamCount: Integer read GetParamCount;
    property Params[Index: Integer]: TMB3DParamFacade read GetParam;
    property IterationCount: Integer read GetIterationCount write SetIterationCount;
  end;

  TMB3DCoreFacade = class
  private
    FHybridCustoms: array[0..5] of TCustomFormula;
    FHeader: TMandHeader10;
    FHAddOn: THeaderCustomAddon;
    function GetHeaderPointer: TPMandHeader10;
    function GetHAddonPointer: PTHeaderCustomAddon;
  public
    constructor Create(const Header: TMandHeader10;const HAddOn: THeaderCustomAddon);
    destructor Destroy;override;
    procedure ApplyToCore(DestHeader: TMandHeader10;DestHAddOn: THeaderCustomAddon);
    property PHeader: TPMandHeader10 read GetHeaderPointer;
    property PHAddOn: PTHeaderCustomAddon read GetHAddOnPointer;
  end;

  TMB3DRootFacade = class
  private
    FOwner: TMB3DParamsFacade;
  public
    constructor Create(const Owner: TMB3DParamsFacade);
  end;

  TMB3DIterationsFacade = class (TMB3DRootFacade)
  private
    function GetMinIterations: Integer;
    procedure SetMinIterations(const MinIterations: Integer);
    function GetIterations: Integer;
    procedure SetIterations(const Iterations: Integer);
    function GetRBailout: Double;
    procedure SetRBailout(const RBailout: Double);
  public
    property MinIterations: Integer read GetMinIterations write SetMinIterations;
    property Iterations: Integer read GetIterations write SetIterations;
    property RBailout: Double read GetRBailout write SetRBailout;
  end;

  TMB3DJuliaModeFacade = class(TMB3DRootFacade)
  private
    function GetIsJulia: Boolean;
    procedure SetIsJulia(const IsJulia: Boolean);
    function GetJx: Double;
    procedure SetJx(const Jx: Double);
    function GetJy: Double;
    procedure SetJy(const Jy: Double);
    function GetJz: Double;
    procedure SetJz(const Jz: Double);
    function GetJw: Double;
    procedure SetJw(const Jw: Double);
  public
    property IsJulia: Boolean read GetIsJulia write SetIsJulia;
    property Jx: Double read GetJx write SetJx;
    property Jy: Double read GetJy write SetJy;
    property Jz: Double read GetJz write SetJz;
    property Jw: Double read GetJw write SetJw;
  end;

  TMB3DParamsFacade = class
  private
    FUUID: String;
    FCore: TMB3DCoreFacade;
    FIterations: TMB3DIterationsFacade;
    FJuliaMode: TMB3DJuliaModeFacade;
    FFormulas: TList;
    function GetFormula(Index: Integer): TMB3DFormulaFacade;
    function GetFormulaCount: Integer;
  public
    constructor Create(const Header: TMandHeader10;const HAddOn: THeaderCustomAddon);
    destructor Destroy;override;
    function Clone: TMB3DParamsFacade;
    property Core: TMB3DCoreFacade read FCore;
    property Formulas[Index: Integer]: TMB3DFormulaFacade read GetFormula;
    property FormulaCount: Integer read GetFormulaCount;
    property JuliaMode: TMB3DJuliaModeFacade read FJuliaMode write FJuliaMode;
    property Iterations: TMB3DIterationsFacade read FIterations;
    property UUID: String read FUUID write FUUID;
  end;

implementation

uses
  DivUtils, CustomFormulas, HeaderTrafos, Contnrs, SysUtils, Windows;

const
  FORMULA_PARAM_COUNT = 16;

{ ---------------------------- TMB3DParamFacade ------------------------------ }
constructor TMB3DParamFacade.Create(const ParamIndex: Integer;const Owner: TMB3DFormulaFacade);
begin
  inherited Create;
  FParamIndex := ParamIndex;
  FOwner := Owner;
end;

function TMB3DParamFacade.GetName: String;
begin
  with FOwner.FOwner.Core.PHeader^ do begin
    Result := PTCustomFormula(PHCustomF[FOwner.FFormulaIndex]).sOptionStrings[FParamIndex];
  end;
end;

function TMB3DParamFacade.GetDatatype: TMB3DParamType;
begin
  with FOwner.FOwner.Core.PHeader^ do begin
    if CustomFormulas.isIntType(PTCustomFormula(PHCustomF[FOwner.FFormulaIndex]).byOptionTypes[FParamIndex]) then
      Result := ptInteger
    else
      Result := ptFloat;
    end;
end;

function TMB3DParamFacade.GetValue: Double;
begin
  with FOwner.FOwner.Core.PHAddon^ do begin
    Result := Formulas[FOwner.FFormulaIndex].dOptionValue[FParamIndex];
  end;
end;

procedure TMB3DParamFacade.SetValue(const Value: Double);
begin
  with FOwner.FOwner.Core.PHAddon^ do begin
    if Datatype = ptInteger then
      Formulas[FOwner.FFormulaIndex].dOptionValue[FParamIndex] := Round(Value)
    else
      Formulas[FOwner.FFormulaIndex].dOptionValue[FParamIndex] := Value;
  end;
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
  for I := 0 to FORMULA_PARAM_COUNT - 1  do
    FParams.Add(TMB3DParamFacade.Create(I, Self));
end;

destructor TMB3DFormulaFacade.Destroy;
begin
  FParams.Free;
  inherited Destroy;
end;

function TMB3DFormulaFacade.GetFormulaName: String;
begin
  Result := CustomFtoStr(FOwner.Core.PHAddon^.Formulas[FFormulaIndex].CustomFname);
end;

procedure TMB3DFormulaFacade.SetFormulaName(const FormulaName: String);
var
  sName: String;
  InternIndex: Integer;
  success: Boolean;
  f: PTHAformula;
begin
  sName := Trim(FormulaName);
  success := False;
  if sName<>'' then begin
    if isInternFormula(sName, InternIndex) then begin
      GetHAddOnFromInternFormula(FOwner.Core.PHeader, InternIndex, FFormulaIndex);
      success := True;
    end
    else begin
      f := @FOwner.Core.PHAddon^.Formulas[FFormulaIndex];
      PutStringInCustomF(f^.CustomFname, sName);
      if LoadCustomFormulaFromHeader(f^.CustomFname,
        PTCustomFormula(FOwner.Core.PHeader^.PHCustomF[FFormulaIndex])^,
        f^.dOptionValue) then begin
//        if TabControl2.TabIndex <> 1 then
          if f^.iItCount < 1 then
            f^.iItCount := 1;
          CopyTypeAndOptionFromCFtoHAddon(FOwner.Core.PHeader^.PHCustomF[FFormulaIndex],
            FOwner.Core.PHAddon, FFormulaIndex);
          success := True;
          f^.iFnr := 20;    //for backward compatibilty reason
//        end;

      end;
    end;
  end;
  if not success then
    Clear
  else begin
//    if FOwner.Core.HAddon.Formulas[FFormulaIndex].iItCount < 1 then
//      FOwner.Core.HAddon.Formulas[FFormulaIndex].iItCount := 1;
//    TabControl1Change(Self);
//    CalcRstop;
//    Check4DandInfo;
  end;
end;


function TMB3DFormulaFacade.GetParamCount: Integer;
begin
  Result := FOwner.Core.PHAddon^.Formulas[FFormulaIndex].iOptionCount;
end;

procedure TMB3DFormulaFacade.Clear;
begin
  with FOwner.Core.PHAddOn^.Formulas[FFormulaIndex] do begin
    iItCount := 0;
    iFnr := -1;
    iOptionCount := 0;
    CustomFname[0] := 0;
  end;
end;

function TMB3DFormulaFacade.IsEmpty: Boolean;
begin
  Result := FOwner.Core.PHAddOn^.Formulas[FFormulaIndex].iItCount = 0;
end;

function TMB3DFormulaFacade.GetParam(Index: Integer): TMB3DParamFacade;
begin
  if (Index < 0) or (Index >= FParams.Count) then
    raise Exception.Create('TMB3DFormulaFacade.GetParam: Invalid param index <'+IntToStr(Index)+'>');
  Result := TMB3DParamFacade(FParams[Index]);
end;

procedure TMB3DFormulaFacade.SetIterationCount(const IterationCount: Integer);
begin
  with FOwner.Core.PHAddOn^.Formulas[FFormulaIndex] do begin
    iItCount := IterationCount;
  end;
end;

function TMB3DFormulaFacade.GetIterationCount: Integer;
begin
  Result := FOwner.Core.PHAddOn^.Formulas[FFormulaIndex].iItCount;
end;
{ ----------------------------- TMB3DCoreFacade ------------------------------ }
constructor TMB3DCoreFacade.Create(const Header: TMandHeader10;const HAddOn: THeaderCustomAddon);
var
  I: Integer;
begin
  inherited Create;
  FastMove(Header, FHeader, SizeOf(TMandHeader10));
  FHeader.PCFAddon := @FHAddOn;
  FastMove(HAddOn, FHeader.PCFAddon^, SizeOf(THeaderCustomAddon));
  for i := 0 to 5 - 1 do
    FHeader.PHCustomF[i] := @FHybridCustoms[i];
  IniCFsFromHAddon(FHeader.PCFAddon, Header.PHCustomF);
end;

destructor TMB3DCoreFacade.Destroy;
var
  i: Integer;
begin
  for i := 0 to 5 do
    FreeCF(@FHybridCustoms[i]);
  inherited Destroy;
end;

procedure TMB3DCoreFacade.ApplyToCore(DestHeader: TMandHeader10;DestHAddOn: THeaderCustomAddon);
var
  AddOn: Pointer;
begin
  AddOn := DestHeader.PCFAddon;
  FastMove(FHeader, DestHeader, SizeOf(TMandHeader10));
  DestHeader.PCFAddon := AddOn;
  FastMove(FHAddOn, DestHeader.PCFAddon^, SizeOf(THeaderCustomAddon));
end;

function TMB3DCoreFacade.GetHeaderPointer: TPMandHeader10;
begin
  Result := @FHeader;
end;

function TMB3DCoreFacade.GetHAddonPointer: PTHeaderCustomAddon;
begin
  Result := @FHAddOn;
end;

{ ---------------------------- TMB3DParamsFacade ----------------------------- }
constructor TMB3DParamsFacade.Create(const Header: TMandHeader10;const HAddOn: THeaderCustomAddon);
var
  I: Integer;
  NewGUID: TGUID;

  function GUIDToShortString(const Guid: TGUID): string;
  begin
    SetLength(Result, 32);
    StrLFmt(PChar(Result), 32,'%.8x%.4x%.4x%.4x%',
      [Guid.D1, Guid.D2, Guid.D3, Integer(Guid.D4[0])+Integer(Guid.D4[1])+Integer(Guid.D4[2])+Integer(Guid.D4[3])+Integer(Guid.D4[4])+Integer(Guid.D4[5])+Integer(Guid.D4[6])+Integer(Guid.D4[7])]);
  end;

begin
  inherited Create;
  FCore := TMB3DCoreFacade.Create(Header, HAddOn);
  FFormulas:=TObjectList.Create;
  for I := 0 to 5 do
    FFormulas.Add(TMB3DFormulaFacade.Create(I, Self));
  FIterations := TMB3DIterationsFacade.Create(Self);
  FJuliaMode := TMB3DJuliaModeFacade.Create(Self);
  CreateGUID(NewGUID);
  FUUID := GUIDToShortString(NewGUID);
end;

destructor TMB3DParamsFacade.Destroy;
begin
  FJuliaMode.Free;
  FIterations.Free;
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
  Result := TMB3DParamsFacade.Create( Core.PHeader^, Core.PHAddOn^ );
end;

function TMB3DParamsFacade.GetFormulaCount: Integer;
begin
  Result := FFormulas.Count;
end;
{ ------------------------------ TMB3DRootFacade ----------------------------- }
constructor TMB3DRootFacade.Create(const Owner: TMB3DParamsFacade);
begin
  inherited Create;
  FOwner := Owner;
end;
{ -------------------------- TMB3DIterationsFacade --------------------------- }
function TMB3DIterationsFacade.GetMinIterations: Integer;
begin
  Result := FOwner.Core.PHeader^.MinimumIterations;
end;

procedure TMB3DIterationsFacade.SetMinIterations(const MinIterations: Integer);
begin
   FOwner.Core.PHeader^.MinimumIterations := MinIterations;
end;

function TMB3DIterationsFacade.GetIterations: Integer;
begin
  Result := FOwner.Core.PHeader^.Iterations;
end;

procedure TMB3DIterationsFacade.SetIterations(const Iterations: Integer);
begin
  FOwner.Core.PHeader^.Iterations := Iterations;
end;

function TMB3DIterationsFacade.GetRBailout: Double;
begin
  Result := FOwner.Core.PHeader^.RStop;
end;

procedure TMB3DIterationsFacade.SetRBailout(const RBailout: Double);
begin
  FOwner.Core.PHeader^.RStop := RBailout;
end;
{ --------------------------- TMB3DJuliaModeFacade --------------------------- }
function TMB3DJuliaModeFacade.GetIsJulia: Boolean;
begin
  Result := FOwner.Core.PHeader^.bIsJulia > 0;
end;

procedure TMB3DJuliaModeFacade.SetIsJulia(const IsJulia: Boolean);
begin
  FOwner.Core.PHeader^.bIsJulia := Byte(Ord(IsJulia));
end;

function TMB3DJuliaModeFacade.GetJx: Double;
begin
  Result := FOwner.Core.PHeader^.dJx;
end;

procedure TMB3DJuliaModeFacade.SetJx(const Jx: Double);
begin
  FOwner.Core.PHeader^.dJx := Jx;
end;

function TMB3DJuliaModeFacade.GetJy: Double;
begin
  Result := FOwner.Core.PHeader^.dJy;
end;

procedure TMB3DJuliaModeFacade.SetJy(const Jy: Double);
begin
  FOwner.Core.PHeader^.dJy := Jy;
end;

function TMB3DJuliaModeFacade.GetJz: Double;
begin
  Result := FOwner.Core.PHeader^.dJz;
end;

procedure TMB3DJuliaModeFacade.SetJz(const Jz: Double);
begin
  FOwner.Core.PHeader^.dJz := Jz;
end;

function TMB3DJuliaModeFacade.GetJw: Double;
begin
  Result := FOwner.Core.PHeader^.dJw;
end;

procedure TMB3DJuliaModeFacade.SetJw(const Jw: Double);
begin
  FOwner.Core.PHeader^.dJw := Jw;
end;

end.
