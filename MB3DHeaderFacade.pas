unit MB3DHeaderFacade;

interface

uses
  TypeDefinitions;

type
  TMB3DHeaderFacade = class
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

implementation

uses
  DivUtils, CustomFormulas;

constructor TMB3DHeaderFacade.Create(const Header: TMandHeader11;const HAddOn: THeaderCustomAddon);
var
  i: Integer;
begin
  inherited Create;
  FastMove(Header, FHeader, SizeOf(TMandHeader11));
  FastMove(HAddOn, FHAddOn, SizeOf(THeaderCustomAddon));
  FHeader.PCFAddon := @FHAddOn;
  for i := 0 to MAX_FORMULA_COUNT - 1 do
    FHeader.PHCustomF[i] := @FHybridCustoms[i];
  for i := 0 to MAX_FORMULA_COUNT - 1 do
    IniCustomF(@FHybridCustoms[i]);
end;

destructor TMB3DHeaderFacade.Destroy;
var
  i: Integer;
begin
  for i := 0 to MAX_FORMULA_COUNT - 1 do
    FreeCF(@FHybridCustoms[i]);
  inherited Destroy;
end;

end.
