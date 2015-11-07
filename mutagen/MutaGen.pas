unit MutaGen;

interface

uses
  Windows, SysUtils, Classes, Vcl.ExtCtrls, Vcl.Graphics, MB3DFacade;

type
  TMutaGenPanel=class
  private
    FParentPanel: TMutaGenPanel;
    FXPos, FYPos: Double;
    FXSize, FYSize: Double;
    FCaption: String;
    FPanel: TPanel;
    FImage: TImage;
    function GetImageWidth: Integer;
    function GetImageHeight: Integer;
    procedure SetImage(const Image: TBitmap);
  public
    constructor Create(ParentPanel: TMutaGenPanel;const XPos, YPos, XSize, YSize: Double;const Caption: String;const Panel: TPanel;const Image: TImage);
    property ImageWidth: Integer read GetImageWidth;
    property ImageHeight: Integer read GetImageHeight;
    property ParentPanel: TMutaGenPanel read FParentPanel;
    property Caption: String read FCaption;
    property Image: TBitMap write SetImage;
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
  public
    constructor Create(const RootPanel: TPanel; const XSize, YSize: Double);
    destructor Destroy;override;
    procedure AddPanel(const Panel: TMutaGenPanel);
    procedure AddPanelLink(const FromX, FromY: Double; const FromPanel: TMutaGenPanel; const ToX, ToY: Double; const ToPanel: TMutaGenPanel);
    function GetPanel(const Index: Integer): TMutaGenPanel;overload;
    function GetPanel(const Path: String): TMutaGenPanel;overload;
    procedure DoLayout;
    property LinkLinesList: TList read FLinkLinesList;
  end;

  TRandGen = class
  public
    function NextRandomDouble: Double;overload;
    function NextRandomInt(const MaxValue: Integer): Integer;overload;
  end;

  TMutationParamSet = class
  private
    FP_1: TMB3DParamsFacade;
    FP_1_1: TMB3DParamsFacade;
    FP_1_1_1: TMB3DParamsFacade;
    FP_1_1_1_1: TMB3DParamsFacade;
    FP_1_1_1_2: TMB3DParamsFacade;
    FP_1_1_2: TMB3DParamsFacade;
    FP_1_1_2_1: TMB3DParamsFacade;
    FP_1_1_2_2: TMB3DParamsFacade;
    FP_1_2: TMB3DParamsFacade;
    FP_1_2_1: TMB3DParamsFacade;
    FP_1_2_1_1: TMB3DParamsFacade;
    FP_1_2_1_2: TMB3DParamsFacade;
    FP_1_2_2: TMB3DParamsFacade;
    FP_1_2_2_1: TMB3DParamsFacade;
    FP_1_2_2_2: TMB3DParamsFacade;
  public
    destructor Destroy;override;
    property P_1: TMB3DParamsFacade read FP_1 write FP_1;
    property P_1_1: TMB3DParamsFacade read FP_1_1 write FP_1_1;
    property P_1_1_1: TMB3DParamsFacade read FP_1_1_1 write FP_1_1_1;
    property P_1_1_1_1: TMB3DParamsFacade read FP_1_1_1_1 write FP_1_1_1_1;
    property P_1_1_1_2: TMB3DParamsFacade read FP_1_1_1_2 write FP_1_1_1_2;
    property P_1_1_2: TMB3DParamsFacade read FP_1_1_2 write FP_1_1_2;
    property P_1_1_2_1: TMB3DParamsFacade read FP_1_1_2_1 write FP_1_1_2_1;
    property P_1_1_2_2: TMB3DParamsFacade read FP_1_1_2_2 write FP_1_1_2_2;
    property P_1_2: TMB3DParamsFacade read FP_1_2 write FP_1_2;
    property P_1_2_1: TMB3DParamsFacade read FP_1_2_1 write FP_1_2_1;
    property P_1_2_1_1: TMB3DParamsFacade read FP_1_2_1_1 write FP_1_2_1_1;
    property P_1_2_1_2: TMB3DParamsFacade read FP_1_2_1_2 write FP_1_2_1_2;
    property P_1_2_2: TMB3DParamsFacade read FP_1_2_2 write FP_1_2_2;
    property P_1_2_2_1: TMB3DParamsFacade read FP_1_2_2_1 write FP_1_2_2_1;
    property P_1_2_2_2: TMB3DParamsFacade read FP_1_2_2_2 write FP_1_2_2_2;
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
    function RequiresProbing: Boolean;virtual;abstract;
    property LocalStrength: Double read FLocalStrength write FLocalStrength;
  end;

  TModifySingleParamMutation = class(TMutation)
  public
    function CreateMutation(const Params: TMB3DParamsFacade; const GlobalStrength: Double): TMB3DParamsFacade;override;
    function RequiresProbing: Boolean;override;
  end;

  TAddFormulaMutation = class(TMutation)
  public
    function CreateMutation(const Params: TMB3DParamsFacade; const GlobalStrength: Double): TMB3DParamsFacade;override;
    function RequiresProbing: Boolean;override;
  end;

implementation

uses
  Contnrs, Math, FormulaNames, TypeDefinitions;
{ ------------------------------ TMutaGenPanel ------------------------------- }
constructor TMutaGenPanel.Create(ParentPanel: TMutaGenPanel;const XPos, YPos, XSize, YSize: Double;const Caption: String;const Panel: TPanel;const Image: TImage);
begin
  inherited Create;
  FParentPanel := ParentPanel;
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

procedure TMutaGenPanel.SetImage(const Image: TBitmap);
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
begin
  RootWidth := FRootPanel.Width - 2 * OuterBorder;
  RootHeight := FRootPanel.Height - 2 * OuterBorder;
  RootCentreX := OuterBorder + RootWidth div 2;
  RootCentreY := OuterBorder + RootHeight div 2;
  ScaleX := RootWidth / FXSize;
  ScaleY := RootHeight / FYSize;
  for I := 0 to FPanels.Count - 1 do begin
    Panel := GetPanel(I);
    Panel.FPanel.Caption := 'Mutation '+GetPanelPath(Panel);
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
destructor TMutationParamSet.Destroy;
begin
  if Assigned(FP_1) then
    FP_1.Free;
  if Assigned(FP_1_1) then
    FP_1_1.Free;
  if Assigned(FP_1_1_1) then
    FP_1_1_1.Free;
  if Assigned(FP_1_1_1_1) then
    FP_1_1_1_1.Free;
  if Assigned(FP_1_1_1_2) then
    FP_1_1_1_2.Free;
  if Assigned(FP_1_1_2) then
    FP_1_1_2.Free;
  if Assigned(FP_1_1_2_1) then
    FP_1_1_2_1.Free;
  if Assigned(FP_1_1_2_2) then
    FP_1_1_2_2.Free;
  if Assigned(FP_1_2) then
    FP_1_2.Free;
  if Assigned(FP_1_2_1) then
    FP_1_2_1.Free;
  if Assigned(FP_1_2_1_1) then
    FP_1_2_1_1.Free;
  if Assigned(FP_1_2_1_2) then
    FP_1_2_1_2.Free;
  if Assigned(FP_1_2_2) then
    FP_1_2_2.Free;
  if Assigned(FP_1_2_2_1) then
    FP_1_2_2_1.Free;
  if Assigned(FP_1_2_2_2) then
    FP_1_2_2_2.Free;
  inherited Destroy;
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
  Formula := ChooseRandomFormula(Result, True);
  if Formula<>nil then begin
    ParamIndex := FRandGen.NextRandomInt(Formula.ParamCount);
    RandomizeParamValue(Formula.Params[ParamIndex], GlobalStrength);
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

function TAddFormulaMutation.CreateMutation(const Params: TMB3DParamsFacade; const GlobalStrength: Double): TMB3DParamsFacade;
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
        Idx := FRandGen.NextRandomInt(Formula3DNames.Count);
        Result.Formulas[I].FormulaName := Formula3DNames[Idx];
        if (FRandGen.NextRandomDouble > 0.5) and (Result.Formulas[I].ParamCount > 0) then begin
          ParamIndex := FRandGen.NextRandomInt(Result.Formulas[I].ParamCount);
          RandomizeParamValue(Result.Formulas[I].Params[ParamIndex], GlobalStrength);
        end;
      end;
      break;
    end;
  end;
end;

function TAddFormulaMutation.RequiresProbing: Boolean;
begin
  Result := True;
end;

initialization
  AllFormulaNames := nil;
finalization
  if AllFormulaNames<>nil then
    AllFormulaNames.Free;
end.

