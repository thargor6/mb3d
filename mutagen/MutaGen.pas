unit MutaGen;

interface

uses
  Windows, SysUtils, Classes, Vcl.ExtCtrls, Vcl.Graphics, MB3DFacade;

type

  TMutationIndex = (
    miP_1, miP_1_1, miP_1_1_1, miP_1_1_1_1, miP_1_1_1_2, miP_1_1_2,
    miP_1_1_2_1, miP_1_1_2_2, miP_1_2, miP_1_2_1, miP_1_2_1_1,
    miP_1_2_1_2, miP_1_2_2, miP_1_2_2_1, miP_1_2_2_2);

  TMutaGenPanel=class
  private
    FParentPanel: TMutaGenPanel;
    FXPos, FYPos: Double;
    FXSize, FYSize: Double;
    FCaption: String;
    FPanel: TPanel;
    FImage: TImage;
    FMutationIndex: TMutationIndex;
    function GetImageWidth: Integer;
    function GetImageHeight: Integer;
    procedure SetBitmap(const Image: TBitmap);
  public
    constructor Create(ParentPanel: TMutaGenPanel;const MutationIndex: TMutationIndex;const XPos, YPos, XSize, YSize: Double;const Caption: String;const Panel: TPanel;const Image: TImage);
    property ImageWidth: Integer read GetImageWidth;
    property ImageHeight: Integer read GetImageHeight;
    property ParentPanel: TMutaGenPanel read FParentPanel;
    property Caption: String read FCaption;
    property Bitmap: TBitMap write SetBitmap;
    property Panel: TPanel read FPanel;
    property Image: TImage read FImage;
    property MutationIndex: TMutationIndex read FMutationIndex;
  end;

  TPanelPosition=class
  private
    FPanel: TMutaGenPanel;
    FXPos, FYPos: Double;
  public
    constructor Create(const Panel: TMutaGenPanel;const XPos, YPos: Double);
  end;

  TPanelLink=class
  private
    FFromPanel, FToPanel: TPanelPosition;
  public
    constructor Create(FromPanel, ToPanel: TPanelPosition);
    destructor Destroy;override;
  end;

  TPanelLinkLine=class
  private
    FX1, FY1, FX2, FY2: Integer;
    procedure DrawAntialisedLine(Canvas: TCanvas; const AX1, AY1, AX2, AY2: real; const LineColor: TColor);
  public
    constructor Create(X1, Y1, X2, Y2: Integer);
    procedure Draw(Canvas: TCanvas);
  end;

  TMutaGenPanelList=class
  private
    FRootPanel: TPanel;
    FXSize, FYSize: Double;
    FPanels: TList;
    FPanelIdxList: TStringList;
    FPanelLinkList: TList;
    FLinkLinesList: TList;
    function GetPanelPath(const Panel: TMutaGenPanel): String;
    function GetCount: Integer;
  public
    constructor Create(const RootPanel: TPanel; const XSize, YSize: Double);
    destructor Destroy;override;
    procedure AddPanel(const Panel: TMutaGenPanel);
    procedure AddPanelLink(const FromX, FromY: Double; const FromPanel: TMutaGenPanel; const ToX, ToY: Double; const ToPanel: TMutaGenPanel);
    function GetPanel(const Index: Integer): TMutaGenPanel;overload;
    function GetPanel(const Path: String): TMutaGenPanel;overload;
    procedure DoLayout;
    property LinkLinesList: TList read FLinkLinesList;
    property Count: Integer read GetCount;
  end;

  TRandGen = class
  public
    function NextRandomDouble: Double;overload;
    function NextRandomInt(const MaxValue: Integer): Integer;overload;
  end;

  TMutationConfig = class
  private
    FModifyFormulaWeight: Double;
    FModifyParamsWeight: Double;
    FModifyParamsStrength: Double;
  public
    constructor Create;
    property ModifyFormulaWeight: Double read FModifyFormulaWeight write FModifyFormulaWeight;
    property ModifyParamsWeight: Double read FModifyParamsWeight write FModifyParamsWeight;
    property ModifyParamsStrength: Double read FModifyParamsStrength write FModifyParamsStrength;
  end;

  TMutationCreator = class
  public
    class function CreateMutations(const Config: TMutationConfig ): TList;
  end;

  TMutationParamSet = class
  private
    FParams: Array [Low(TMutationIndex)..High(TMutationIndex)] of TMB3DParamsFacade;
    function GetParam(Index: TMutationIndex): TMB3DParamsFacade;
    procedure SetParam(Index: TMutationIndex; const Param: TMB3DParamsFacade);
  public
    constructor Create;
    destructor Destroy;override;
    property Params[Index: TMutationIndex]: TMB3DParamsFacade read GetParam write SetParam;
  end;

  TMutation = class
  private
    function GetNonEmptyFormulas(const Params: TMB3DParamsFacade): TStringList;
    function GetNonEmptyFormulasWithParams(const Params: TMB3DParamsFacade): TStringList;
  protected
    function ChooseRandomFormula(const Params: TMB3DParamsFacade; const OnlyFormulasWithParams: Boolean): TMB3DFormulaFacade;
    procedure RandomizeParamValue(const Param: TMB3DParamFacade; const Strength: Double);
  public
    function MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;virtual;abstract;
    function RequiresProbing: Boolean;virtual;abstract;
  end;

  TScalableMutation = class(TMutation)
  private
    FStrength: Double;
  public
    constructor Create;
    property Strength: Double read FStrength write FStrength;
  end;

  TModifySingleParamMutation = class(TScalableMutation)
  public
    function MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;override;
    function RequiresProbing: Boolean;override;
  end;

  TAddFormulaMutation = class(TMutation)
  public
    function MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;override;
    function RequiresProbing: Boolean;override;
  end;

  TReplaceFormulaMutation = class(TMutation)
  public
    function MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;override;
    function RequiresProbing: Boolean;override;
  end;

  TRemoveFormulaMutation = class(TMutation)
  public
    function MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;override;
    function RequiresProbing: Boolean;override;
  end;

implementation

uses
  Contnrs, Math, FormulaNames, TypeDefinitions;

var
  RandGen: TRandGen;
{ ------------------------------ TMutaGenPanel ------------------------------- }
constructor TMutaGenPanel.Create(ParentPanel: TMutaGenPanel;const MutationIndex: TMutationIndex;const XPos, YPos, XSize, YSize: Double;const Caption: String;const Panel: TPanel;const Image: TImage);
begin
  inherited Create;
  FParentPanel := ParentPanel;
  FMutationIndex := MutationIndex;
  FCaption := Caption;
  FXPos := XPos;
  FYPos := YPos;
  FXSize := XSize;
  FYSize := YSize;
  FPanel := Panel;
  FImage := Image;
end;

function TMutaGenPanel.GetImageWidth: Integer;
begin
  Result := FImage.Width;
end;

function TMutaGenPanel.GetImageHeight: Integer;
begin
  Result := FImage.Height;
end;

procedure TMutaGenPanel.SetBitmap(const Image: TBitmap);
begin
  FImage.Picture.Bitmap := Image;
end;
{ ---------------------------- TMutaGenPanelList ----------------------------- }
constructor TMutaGenPanelList.Create(const RootPanel: TPanel; const XSize, YSize: Double);
begin
  inherited Create;
  FRootPanel := RootPanel;
  FXSize := XSize;
  FYSize := YSize;
  FPanels := TObjectList.Create;
  FPanelLinkList := TObjectList.Create;
  FLinkLinesList := TObjectList.Create;
  FPanelIdxList := TStringList.Create;
  FPanelIdxList.Sorted := False;
end;

destructor TMutaGenPanelList.Destroy;
begin
  FPanels.Free;
  FPanelLinkList.Free;
  FPanelIdxList.Free;
  FLinkLinesList.Free;
  inherited Destroy;
end;

function TMutaGenPanelList.GetPanelPath(const Panel: TMutaGenPanel): String;
var
  CurrPanel: TMutaGenPanel;
begin
  CurrPanel := Panel;
  Result := CurrPanel.Caption;
  while(CurrPanel.ParentPanel <> nil) do begin
    CurrPanel := CurrPanel.ParentPanel;
    Result := CurrPanel.Caption + '.' + Result;
  end;
end;

procedure TMutaGenPanelList.AddPanel(const Panel: TMutaGenPanel);
var
  Path: String;
begin
  Path:= GetPanelPath(Panel);
  if FPanelIdxList.IndexOf(Path) >= 0 then
    raise Exception.Create('TMutaGenPanelList.AddPanel: A Panel with the path <'+Path+'> already exists');
  FPanels.Add(Panel);
  FPanelIdxList.Add(Path);
end;

function TMutaGenPanelList.GetPanel(const Index: Integer): TMutaGenPanel;
begin
  if (Index<0) or (Index>=FPanels.Count) then
    raise Exception.Create('TMutaGenPanelList.GetPanel: Invalid panel index <'+IntToStr(Index)+'>');
  Result := TMutaGenPanel(FPanels[Index]);
end;

function TMutaGenPanelList.GetPanel(const Path: String): TMutaGenPanel;
var
  Index: Integer;
begin
  Index := FPanelIdxList.IndexOf(Path);
  if Index < 0 then
    raise Exception.Create('TMutaGenPanelList.GetPanel: Invalid panel path <'+Path+'>');
  Result := TMutaGenPanel(FPanels[Index]);
end;

procedure TMutaGenPanelList.DoLayout;
const
  OuterBorder = 10;
var
  I: Integer;
  RootWidth, RootHeight, RootCentreX, RootCentreY: Integer;
  ScaleX, ScaleY: Double;
  Panel: TMutaGenPanel;
  Link: TPanelLink;
  X1, Y1, X2, Y2: Integer;
  PanelPath: String;
begin
  RootWidth := FRootPanel.Width - 2 * OuterBorder;
  RootHeight := FRootPanel.Height - 2 * OuterBorder;
  RootCentreX := OuterBorder + RootWidth div 2;
  RootCentreY := OuterBorder + RootHeight div 2;
  ScaleX := RootWidth / FXSize;
  ScaleY := RootHeight / FYSize;
  for I := 0 to FPanels.Count - 1 do begin
    Panel := GetPanel(I);
    if Panel.ParentPanel = nil then
      Panel.FPanel.Caption := 'Root'
    else begin
      PanelPath := GetPanelPath(Panel);
      Panel.FPanel.Caption := 'Mutation '+Copy(PanelPath, 3, Length(PanelPath) - 2);
    end;
    Panel.FPanel.Width := Round( Panel.FXSize * ScaleX );
    Panel.FPanel.Height := Round( Panel.FYSize * ScaleY );
    Panel.FPanel.Left := Round( RootCentreX + Panel.FXPos * ScaleX ) - Panel.FPanel.Width div 2;
    Panel.FPanel.Top := Round( RootCentreY - Panel.FYPos * ScaleY ) - Panel.FPanel.Height div 2;
  end;

  FLinkLinesList.Clear;
  for I := 0 to FPanelLinkList.Count - 1 do begin
    Link := TPanelLink(FPanelLinkList[I]);
    X1 := Link.FFromPanel.FPanel.FPanel.Left + Round( Link.FFromPanel.FXPos * Link.FFromPanel.FPanel.FPanel.Width);
    Y1 := Link.FFromPanel.FPanel.FPanel.Top + Round( (1.0 - Link.FFromPanel.FYPos) * Link.FFromPanel.FPanel.FPanel.Height);
    X2 := Link.FToPanel.FPanel.FPanel.Left + Round( Link.FToPanel.FXPos * Link.FToPanel.FPanel.FPanel.Width);
    Y2 := Link.FToPanel.FPanel.FPanel.Top + Round( (1.0 - Link.FToPanel.FYPos) * Link.FToPanel.FPanel.FPanel.Height);
    FLinkLinesList.Add(TPanelLinkLine.Create(X1, Y1, X2, Y2));
  end;
end;

procedure TMutaGenPanelList.AddPanelLink(const FromX, FromY: Double; const FromPanel: TMutaGenPanel; const ToX, ToY: Double; const ToPanel: TMutaGenPanel);
begin
  FPanelLinkList.Add(TPanelLink.Create(TPanelPosition.Create(FromPanel, FromX, FromY), TPanelPosition.Create(ToPanel, ToX, ToY)));
end;

function TMutaGenPanelList.GetCount: Integer;
begin
  Result := FPanels.Count;
end;
{ ----------------------------- TPanelPosition ------------------------------- }
constructor TPanelPosition.Create(const Panel: TMutaGenPanel;const XPos, YPos: Double);
begin
  inherited Create;
  FPanel := Panel;

  FXPos := XPos;
  if(FXPos < 0.0) then
    FXPos := 0.0
  else if (FXPos > 1.0) then
    FXPos := 1.0;

  FYPos := YPos;
  if(FYPos < 0.0) then
    FYPos := 0.0
  else if (FYPos > 1.0) then
    FYPos := 1.0;
end;
{ -------------------------------- TPanelLink -------------------------------- }
constructor TPanelLink.Create(FromPanel, ToPanel: TPanelPosition);
begin
  inherited Create;
  FFromPanel := FromPanel;
  FToPanel := ToPanel;
end;

destructor TPanelLink.Destroy;
begin
  FFromPanel.Free;
  FToPanel.Free;
  inherited Destroy;
end;
{ ------------------------------ TPanelLinkLine ------------------------------ }
constructor TPanelLinkLine.Create(X1, Y1, X2, Y2: Integer);
begin
  inherited Create;
  FX1 := X1;
  FY1 := Y1;
  FX2 := X2;
  FY2 := Y2;
end;

procedure TPanelLinkLine.Draw(Canvas: TCanvas);
const
  Color = clRed;
begin
//   DrawAntialisedLine(Canvas, FX1, FY1, FX2, FY2, Color);
   Canvas.Pen.Style := psSolid;
   Canvas.Pen.Color := Color;
   Canvas.Pen.Width := 1;
   Canvas.MoveTo(FX1, FY1);
   Canvas.LineTo(FX2, FY2);
end;

// Taken from http://stackoverflow.com/questions/3613130/simple-anti-aliasing-function-for-delphi-7
procedure TPanelLinkLine.DrawAntialisedLine(Canvas: TCanvas; const AX1, AY1, AX2, AY2: real; const LineColor: TColor);
var
  swapped: boolean;

  procedure plot(const x, y, c: real);
  var
    resclr: TColor;
  begin
    if swapped then
      resclr := Canvas.Pixels[round(y), round(x)]
    else
      resclr := Canvas.Pixels[round(x), round(y)];
    resclr := RGB(round(GetRValue(resclr) * (1-c) + GetRValue(LineColor) * c),
                  round(GetGValue(resclr) * (1-c) + GetGValue(LineColor) * c),
                  round(GetBValue(resclr) * (1-c) + GetBValue(LineColor) * c));
    if swapped then
      Canvas.Pixels[round(y), round(x)] := resclr
    else
      Canvas.Pixels[round(x), round(y)] := resclr;
  end;

  function rfrac(const x: real): real; inline;
  begin
    rfrac := 1 - frac(x);
  end;

  procedure swap(var a, b: real);
  var
    tmp: real;
  begin
    tmp := a;
    a := b;
    b := tmp;
  end;

var
  x1, x2, y1, y2, dx, dy, gradient, xend, yend, xgap, xpxl1, ypxl1,
  xpxl2, ypxl2, intery: real;
  x: integer;
begin
  x1 := AX1;
  x2 := AX2;
  y1 := AY1;
  y2 := AY2;

  dx := x2 - x1;
  dy := y2 - y1;
  swapped := abs(dx) < abs(dy);
  if swapped then
  begin
    swap(x1, y1);
    swap(x2, y2);
    swap(dx, dy);
  end;
  if x2 < x1 then
  begin
    swap(x1, x2);
    swap(y1, y2);
  end;

  gradient := dy / dx;

  xend := round(x1);
  yend := y1 + gradient * (xend - x1);
  xgap := rfrac(x1 + 0.5);
  xpxl1 := xend;
  ypxl1 := floor(yend);
  plot(xpxl1, ypxl1, rfrac(yend) * xgap);
  plot(xpxl1, ypxl1 + 1, frac(yend) * xgap);
  intery := yend + gradient;

  xend := round(x2);
  yend := y2 + gradient * (xend - x2);
  xgap := frac(x2 + 0.5);
  xpxl2 := xend;
  ypxl2 := floor(yend);
  plot(xpxl2, ypxl2, rfrac(yend) * xgap);
  plot(xpxl2, ypxl2 + 1, frac(yend) * xgap);

  for x := round(xpxl1) + 1 to round(xpxl2) - 1 do
  begin
    plot(x, floor(intery), rfrac(intery));
    plot(x, floor(intery) + 1, frac(intery));
    intery := intery + gradient;
  end;
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
{ --------------------------- TMutationParamSet ------------------------------ }
constructor TMutationParamSet.Create;
var
  I: TMutationIndex;
begin
  inherited Create;
  for I:=Low(FParams) to High(FParams) do
    FParams[I] := nil;
end;

destructor TMutationParamSet.Destroy;
var
  I: TMutationIndex;
begin
  for I:=Low(FParams) to High(FParams) do begin
    if FParams[I]<>nil then
      FParams[I].Free;
  end;
  inherited Destroy;
end;

function TMutationParamSet.GetParam(Index: TMutationIndex): TMB3DParamsFacade;
begin
  Result := FParams[Index];
end;

procedure TMutationParamSet.SetParam(Index: TMutationIndex; const Param: TMB3DParamsFacade);
begin
  if FParams[Index] <>nil then
    FParams[Index].Free;
  FParams[Index] := Param;
end;
{ ---------------------------------- TMutation ------------------------------- }
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
      Index := StrToInt(IdxList[ RandGen.NextRandomInt(IdxList.Count) ]);
      Result := Params.Formulas[Index];
    end;
  finally
    IdxList.Free;
  end;
end;

procedure TMutation.RandomizeParamValue(const Param: TMB3DParamFacade; const Strength: Double);
var
  OldValue, Delta: Double;
begin
  OldValue := Param.Value;
  if Param.Datatype=ptInteger then begin
    Delta := Strength*(0.5-Random)*2.0;
    if (Abs(OldValue) > 1.0) and (RandGen.NextRandomDouble > 0.666) then begin
      Delta := Delta * OldValue / 2.0;
    end;
    if Round(Abs(Delta))<1.0 then
      if RandGen.NextRandomDouble < 0.5 then
        Delta := Delta - 1.0
      else
        Delta := Delta + 1.0;
  end
  else begin
    Delta := Strength*(0.5-Random);
    if (Abs(OldValue) > 0.01) and (RandGen.NextRandomDouble > 0.8333) then begin
      Delta := Delta * OldValue / 2.0;
    end;
  end;
  Param.Value := OldValue + Delta;
  Windows.OutputDebugString(PChar(Param.Name + ': ' + FloatToStr(OldValue) + '->' + FloatToStr(Param.Value)));
end;

{ --------------------------- TScalableMutation ------------------------------ }
constructor TScalableMutation.Create;
begin
  inherited Create;
  FStrength := 1.0;
end;
{ ----------------------------- TMutationConfig ------------------------------ }
constructor TMutationConfig.Create;
begin
  inherited Create;
  ModifyFormulaWeight := 0.75;
  ModifyParamsWeight := 1.0;
  ModifyParamsStrength := 1.0;
end;
{ ---------------------------- TMutationCreator ------------------------------ }
class function TMutationCreator.CreateMutations(const Config: TMutationConfig ): TList;
var
  Mutation: TScalableMutation;
begin
  Result := TObjectList.Create;

  if Config.ModifyFormulaWeight > RandGen.NextRandomDouble then begin
    Result.Add(TAddFormulaMutation.Create);
    Result.Add(TReplaceFormulaMutation.Create);
    Result.Add(TRemoveFormulaMutation.Create);
  end;

  if Config.ModifyParamsWeight > RandGen.NextRandomDouble then begin
    Mutation := TModifySingleParamMutation.Create;
    Mutation.Strength := Config.ModifyParamsStrength;
    Result.Add(Mutation);
  end;
end;
{ ------------------------ TModifySingleParamMutation ------------------------ }
function TModifySingleParamMutation.MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;
var
  ParamIndex: Integer;
  Formula: TMB3DFormulaFacade;
begin
  Result := Params.Clone;
  Formula := ChooseRandomFormula(Result, True);
  if Formula<>nil then begin
    ParamIndex := RandGen.NextRandomInt(Formula.ParamCount);
    RandomizeParamValue(Formula.Params[ParamIndex], Strength);
  end;
end;

function TModifySingleParamMutation.RequiresProbing: Boolean;
begin
  Result := True;
end;
{ ---------------------------- TAddFormulaMutation --------------------------- }
var
  AllFormulaNames: TFormulaNames;

function GetAllFormulaNames: TFormulaNames;
begin
  if AllFormulaNames = nil then
    AllFormulaNames := TFormulaNamesLoader.LoadFormulas;
  Result := AllFormulaNames;
end;

function TAddFormulaMutation.MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;
var
  I, Idx: Integer;
  ParamIndex: Integer;
  FormulaNames: TFormulaNames;
  Formula3DNames: TStringList;
begin
  FormulaNames := GetAllFormulaNames;
  Result := Params.Clone;
  for I := 0 to MAX_FORMULA_COUNT -1 do begin
    if Result.Formulas[I].IsEmpty then begin
      // TODO choose category with more "intelligence"
      Formula3DNames := FormulaNames.GetFormulaNamesByCategory(fc_3D);
      if Formula3DNames.Count > 0 then begin
        Idx := RandGen.NextRandomInt(Formula3DNames.Count);
        Result.Formulas[I].FormulaName := Formula3DNames[Idx];
(*
        if (RandGen.NextRandomDouble > 0.5) and (Result.Formulas[I].ParamCount > 0) then begin
          ParamIndex := RandGen.NextRandomInt(Result.Formulas[I].ParamCount);
          RandomizeParamValue(Result.Formulas[I].Params[ParamIndex], Strength);
        end;
*)
      end;
      break;
    end;
  end;
end;

function TAddFormulaMutation.RequiresProbing: Boolean;
begin
  Result := True;
end;
{ -------------------------- TReplaceFormulaMutation ------------------------- }
function TReplaceFormulaMutation.MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;
var
  I, Idx: Integer;
  ParamIndex: Integer;
  FormulaNames: TFormulaNames;
  Formula3DNames: TStringList;
  Category: TFormulaCategory;
begin
  FormulaNames := GetAllFormulaNames;
  Result := Params.Clone;
  for I := 0 to MAX_FORMULA_COUNT - 1 do begin
    if not Result.Formulas[I].IsEmpty then begin
      Category := FormulaNames.GetCategoryByFormulaName(Result.Formulas[I].FormulaName);
      Formula3DNames := FormulaNames.GetFormulaNamesByCategory(Category);
      Idx := RandGen.NextRandomInt(Formula3DNames.Count);
      Result.Formulas[I].FormulaName := Formula3DNames[Idx];
(*
      if (RandGen.NextRandomDouble > 0.5) and (Result.Formulas[I].ParamCount > 0) then begin
        ParamIndex := RandGen.NextRandomInt(Result.Formulas[I].ParamCount);
        RandomizeParamValue(Result.Formulas[I].Params[ParamIndex], Strength);
      end;
*)
      break;
    end;
  end;
end;

function TReplaceFormulaMutation.RequiresProbing: Boolean;
begin
  Result := True;
end;
{ --------------------------- TRemoveFormulaMutation ------------------------- }
function TRemoveFormulaMutation.MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;
var
  I, Idx: Integer;
  IdxList: TStringList;
begin
  Result := Params.Clone;
  IdxList := TStringList.Create;
  try
    for I:=MAX_FORMULA_COUNT - 1 downto 1 do begin
      if not Result.Formulas[I].IsEmpty then begin
        IdxList.Add(IntToStr(I));
      end;
    end;
    if IdxList.Count > 3 then begin
      Idx := StrToInt(IdxList[ RandGen.NextRandomInt(IdxList.Count)]);
      Result.Formulas[Idx].FormulaName := '';
    end;
  finally
    IdxList.Free;
  end;
end;

function TRemoveFormulaMutation.RequiresProbing: Boolean;
begin
  Result := True;
end;

initialization
  AllFormulaNames := nil;
  RandGen := TRandGen.Create;
finalization
  if AllFormulaNames<>nil then
    AllFormulaNames.Free;
  RandGen.Free;
end.

