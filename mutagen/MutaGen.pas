unit MutaGen;

interface

uses
  Windows, SysUtils, Classes, Vcl.ExtCtrls, Vcl.Graphics, MB3DFacade;

type
  TMutaGenPanel=class
  private
    FRow, FCol: Integer;
    FPanel: TPanel;
    FImage: TImage;
    function GetImageWidth: Integer;
    function GetImageHeight: Integer;
    procedure SetImage(const Image: TBitmap);
  public
    constructor Create(const Row, Col: Integer;const Panel: TPanel;const Image: TImage);
    property Row: Integer read FRow;
    property Col: Integer read FCol;
    property ImageWidth: Integer read GetImageWidth;
    property ImageHeight: Integer read GetImageHeight;
    property Image: TBitMap write SetImage;
  end;

  TMutaGenPanelList=class
  private
    FPanels: TList;
    FPanelIdxList: TStringList;
    function MakeIndexKey(const Row, Col: Integer): String;
  public
    constructor Create;
    destructor Destroy;override;
    procedure AddPanel(const Panel: TMutaGenPanel);
    function GetPanel(const Index: Integer): TMutaGenPanel;overload;
    function GetPanel(const Row, Col: Integer): TMutaGenPanel;overload;
  end;

  TRandGen = class
  public
    function NextRandomDouble: Double;overload;
    function NextRandomInt(const MaxValue: Integer): Integer;overload;
  end;

  TMutation = class
  private
    FLocalStrength: Double;
    FRandGen: TRandGen;
    function GetNonEmptyFormulas(const Params: TMB3DParamsFacade): TStringList;
    function GetNonEmptyFormulasWithParams(const Params: TMB3DParamsFacade): TStringList;
  protected
    function MutationStrength(const GlobalStrength: Double): Double;
    function ChooseRandomFormula(const Params: TMB3DParamsFacade; const OnlyFormulasWithParams: Boolean): TMB3DFormulaFacade;
    procedure RandomizeParamValue(const Param: TMB3DParamFacade; const GlobalStrength: Double);
  public
    constructor Create;
    destructor Destroy;override;
    function CreateMutation(const Params: TMB3DParamsFacade; const GlobalStrength: Double): TMB3DParamsFacade;virtual;abstract;
    property LocalStrength: Double read FLocalStrength write FLocalStrength;
  end;

  TModifySingleParamMutation = class(TMutation)
  public
    function CreateMutation(const Params: TMB3DParamsFacade; const GlobalStrength: Double): TMB3DParamsFacade;override;
  end;

implementation

uses
  Contnrs;

{ ------------------------------ TMutaGenPanel ------------------------------- }
constructor TMutaGenPanel.Create(const Row, Col: Integer;const Panel: TPanel;const Image: TImage);
begin
  inherited Create;
  FRow := Row;
  FCol := Col;
  FPanel := Panel;
  FImage := Image;
  FPanel.Caption := '';
end;

function TMutaGenPanel.GetImageWidth: Integer;
begin
  Result := FImage.Width;
end;

function TMutaGenPanel.GetImageHeight: Integer;
begin
  Result := FImage.Height;
end;

procedure TMutaGenPanel.SetImage(const Image: TBitmap);
begin
  FImage.Picture.Bitmap := Image;
end;
{ ---------------------------- TMutaGenPanelList ----------------------------- }
constructor TMutaGenPanelList.Create;
begin
  inherited Create;
  FPanels := TObjectList.Create;
  FPanelIdxList := TStringList.Create;
  FPanelIdxList.Sorted := False;
end;

destructor TMutaGenPanelList.Destroy;
begin
  FPanels.Free;
  FPanelIdxList.Free;
  inherited Destroy;
end;

function TMutaGenPanelList.MakeIndexKey(const Row, Col: Integer): String;
begin
  Result := IntToStr(Row)+'#'+IntToStr(Col);
end;

procedure TMutaGenPanelList.AddPanel(const Panel: TMutaGenPanel);
var
  Key: String;
begin
  Key := MakeIndexKey(Panel.Row, Panel.Col);
  if FPanelIdxList.IndexOf(Key) >= 0 then
    raise Exception.Create('TMutaGenPanelList.AddPanel: A Panel at position <'+IntToStr(Panel.Row)+', '+IntToStr(Panel.Col)+'> already exists');
  FPanels.Add(Panel);
  FPanelIdxList.Add(Key);
end;

function TMutaGenPanelList.GetPanel(const Index: Integer): TMutaGenPanel;
begin
  if (Index<0) or (Index>=FPanels.Count) then
    raise Exception.Create('TMutaGenPanelList.GetPanel: Invalid panel index <'+IntToStr(Index)+'>');
  Result := TMutaGenPanel(FPanels[Index]);
end;

function TMutaGenPanelList.GetPanel(const Row, Col: Integer): TMutaGenPanel;
var
  Index: Integer;
begin
  Index := FPanelIdxList.IndexOf(MakeIndexKey(Row, Col));
  if Index < 0 then
    raise Exception.Create('TMutaGenPanelList.GetPanel: Invalid panel index <'+IntToStr(Row)+', '+IntToStr(Col)+'>');
  Result := TMutaGenPanel(FPanels[Index]);
end;
{ -------------------------------- TRandGen ---------------------------------- }
function TRandGen.NextRandomDouble: Double;
begin
  Result := Random;
end;

function TRandGen.NextRandomInt(const MaxValue: Integer): Integer;
begin
  Result := Trunc( MaxValue * NextRandomDouble );
end;
{ ---------------------------------- TMutation ------------------------------- }
constructor TMutation.Create;
begin
  inherited Create;
  FLocalStrength := 1.0;
  FRandGen := TRandGen.Create;
  // TODO
  //FRandGen.Randomize();
end;

destructor TMutation.Destroy;
begin
  FRandGen.Free;
end;

function TMutation.MutationStrength(const GlobalStrength: Double): Double;
begin
  Result := FLocalStrength * GlobalStrength;
end;

function TMutation.GetNonEmptyFormulas(const Params: TMB3DParamsFacade): TStringList;
var
  I: Integer;
begin
  Result := TStringList.Create;
  for I := 0 to Params.FormulaCount-1 do begin
    if not Params.Formulas[I].IsEmpty then
      Result.Add(IntToStr(I));
  end;
end;

function TMutation.GetNonEmptyFormulasWithParams(const Params: TMB3DParamsFacade): TStringList;
var
  I: Integer;
begin
  Result := TStringList.Create;
  for I := 0 to Params.FormulaCount-1 do begin
    if (not Params.Formulas[I].IsEmpty) and (Params.Formulas[I].ParamCount > 0) then
      Result.Add(IntToStr(I));
  end;
end;

function TMutation.ChooseRandomFormula(const Params: TMB3DParamsFacade; const OnlyFormulasWithParams: Boolean): TMB3DFormulaFacade;
var
  Index: Integer;
  IdxList: TStringList;
begin
  Result := nil;
  if OnlyFormulasWithParams then
    IdxList := GetNonEmptyFormulasWithParams(Params)
  else
    IdxList := GetNonEmptyFormulas(Params);
  try
    if IdxList.Count > 0 then begin
      Index := StrToInt(IdxList[ FRandGen.NextRandomInt(IdxList.Count) ]);
      Result := Params.Formulas[Index];
    end;
  finally
    IdxList.Free;
  end;
end;

procedure TMutation.RandomizeParamValue(const Param: TMB3DParamFacade; const GlobalStrength: Double);
var
  OldValue, Delta: Double;
begin
  OldValue := Param.Value;
  if Param.Datatype=ptInteger then begin
    Delta := MutationStrength(GlobalStrength)*(0.5-Random)*2.0;
    if (Abs(OldValue) > 1.0) and (FRandGen.NextRandomDouble > 0.666) then begin
      Delta := Delta * OldValue / 2.0;
    end;
    if Round(Abs(Delta))<1.0 then
      if FRandGen.NextRandomDouble < 0.5 then
        Delta := Delta - 1.0
      else
        Delta := Delta + 1.0;
  end
  else begin
    Delta := MutationStrength(GlobalStrength)*(0.5-Random);
    if (Abs(OldValue) > 0.01) and (FRandGen.NextRandomDouble > 0.8333) then begin
      Delta := Delta * OldValue / 2.0;
    end;
  end;
  Param.Value := OldValue + Delta;
  Windows.OutputDebugString(PChar(Param.Name + ': ' + FloatToStr(OldValue) + '->' + FloatToStr(Param.Value)));
end;

{ ------------------------ TModifySingleParamMutation ------------------------ }
function TModifySingleParamMutation.CreateMutation(const Params: TMB3DParamsFacade; const GlobalStrength: Double): TMB3DParamsFacade;
var
  ParamIndex: Integer;
  Formula: TMB3DFormulaFacade;
begin
  Result := Params.Clone;
  (*
  Formula := ChooseRandomFormula(Params, True);
  if Formula<>nil then begin
    ParamIndex := FRandGen.NextRandomInt(Formula.ParamCount);
    RandomizeParamValue(Formula.Params[ParamIndex], GlobalStrength);
  end;
  *)
  Formula := Params.Formulas[0];
  Formula.Params[0].Value := Formula.Params[0].Value + 1;
  Formula.Params[0].Value := Formula.Params[0].Value + 1;
end;


end.

