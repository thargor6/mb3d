(*
  MutaGen for MB3D
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
unit MutaGen;

interface

uses
  Windows, SysUtils, Classes, Vcl.ExtCtrls, Vcl.Graphics, MB3DFacade, FormulaNames;

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

  TPanelOrientation = (poLeft, poRight, poTop, poBottom);

  TPanelPosition=class
  private
    FPanel: TMutaGenPanel;
    FXPos, FYPos: Double;
    FOrientation: TPanelOrientation;
  public
    constructor Create(const Panel: TMutaGenPanel;const XPos, YPos: Double; const Orientation: TPanelOrientation);
    property Orientation: TPanelOrientation read FOrientation;
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
    procedure AddPanelLink(const FromX, FromY: Double; const FromOrientation: TPanelOrientation; const FromPanel: TMutaGenPanel; const ToX, ToY: Double; const ToOrientation: TPanelOrientation;const ToPanel: TMutaGenPanel);
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
    FModifyJuliaModeWeight: Double;
    FModifyJuliaModeStrength: Double;
    FModifyIterationCountWeight: Double;
    FModifyIterationCountStrength: Double;
    FProbing: Boolean;
    FProbingWidth: Integer;
    FProbingHeight: Integer;
    FProbingMaxCount: Integer;
    FProbingMinCoverage: Double;
    FProbingMinDifference: Double;
  public
    constructor Create;
    property ModifyFormulaWeight: Double read FModifyFormulaWeight write FModifyFormulaWeight;
    property ModifyParamsWeight: Double read FModifyParamsWeight write FModifyParamsWeight;
    property ModifyParamsStrength: Double read FModifyParamsStrength write FModifyParamsStrength;
    property ModifyJuliaModeWeight: Double read FModifyJuliaModeWeight write FModifyJuliaModeWeight;
    property ModifyJuliaModeStrength: Double read FModifyJuliaModeStrength write FModifyJuliaModeStrength;
    property ModifyIterationCountWeight: Double read FModifyIterationCountWeight write FModifyIterationCountWeight;
    property ModifyIterationCountStrength: Double read FModifyIterationCountStrength write FModifyIterationCountStrength;
    property Probing: Boolean read FProbing;
    property ProbingWidth: Integer read FProbingWidth;
    property ProbingHeight: Integer read FProbingHeight;
    property ProbingMaxCount: Integer read FProbingMaxCount;
    property ProbingMinCoverage: Double read FProbingMinCoverage;
    property ProbingMinDifference: Double read FProbingMinDifference;
  end;

  TMutationCreator = class
  public
    class function CreateMutations(const Config: TMutationConfig ): TList;
  end;

  TMutationParams = class
  private
    FParams: TMB3DParamsFacade;
    FBitmap: TBitmap;
    FProbingBitmap: TBitmap;
    procedure SetBitmap(const Bitmap: TBitmap);
    procedure SetProbingBitmap(const ProbingBitmap: TBitmap);
  public
    destructor Destroy; override;
    property Params: TMB3DParamsFacade read FParams write FParams;
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property ProbingBitmap: TBitmap read FProbingBitmap write SetProbingBitmap;
  end;

  TMutationParamsSet = class
  private
    FParams: Array [Low(TMutationIndex)..High(TMutationIndex)] of TMutationParams;
    function GetParam(Index: TMutationIndex): TMutationParams;
    procedure SetParam(Index: TMutationIndex; const Param: TMutationParams);
  public
    constructor Create;
    destructor Destroy;override;
    property Params[Index: TMutationIndex]: TMutationParams read GetParam write SetParam;
  end;

  TMutationCoverage = class
  private
    class function CalcFilteredCoverage24(const Bitmap: TBitmap): Double;
    class function CalcFilteredCoverage32(const Bitmap: TBitmap): Double;
    class function CreateFilteredImage24(const Bitmap: TBitmap): TBitmap;
    class function CreateFilteredImage32(const Bitmap: TBitmap): TBitmap;
  public
    class function CalcCoverage(const Bitmap: TBitmap): Double;
    class function CalcDiffCoverage(const Bitmap1, Bitmap2: TBitmap): Double;
    class function CalcFilteredCoverage(const Bitmap: TBitmap): Double;
    class function CreateFilteredImage(const Bitmap: TBitmap): TBitmap;
  end;

  TProbedParams = class
  private
    FParams: TMB3DParamsFacade;
    FProbingBitmap: TBitmap;
    FCoverage: Double;
    FDiffCoverage: Double;
  public
    constructor Create(const Params: TMB3DParamsFacade; const Coverage, DiffCoverage: Double; const ProbingBitmap: TBitmap);
    destructor Destroy;override;
    function ExtractParams: TMB3DParamsFacade;
    function ExtractProbingBitmap: TBitmap;
    property Coverage: Double read FCoverage;
    property DiffCoverage: Double read FDiffCoverage;
  end;

  TProbedParamsList = class
  private
    FConfig: TMutationConfig;
    FInvalidParams: TList;
    FValidParams: TList;
  public
    constructor Create(Config: TMutationConfig);
    destructor Destroy;override;
    procedure AddProbedParam(const Params: TProbedParams);
    function GetBestValidParam: TProbedParams;
    function GetBestInvalidParam: TProbedParams;
  end;

  TMutation = class
  private
    function GetNonEmptyFormulas(const Params: TMB3DParamsFacade): TStringList;
    function GetNonEmptyFormulaCount(const Params: TMB3DParamsFacade): Integer;
    function GetNonEmptyFormulasByCategory(const Params: TMB3DParamsFacade; const Category: TFormulaCategory): TStringList;
    function GetNonEmptyFormulasWithParams(const Params: TMB3DParamsFacade): TStringList;
  protected
    function ChooseRandomFormula(const Params: TMB3DParamsFacade; const OnlyFormulasWithParams: Boolean): TMB3DFormulaFacade;
    procedure RandomizeParamValue(Param: TMB3DParamFacade; const Strength: Double);
  public
    function MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;virtual;abstract;
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
  end;

  TAddFormulaMutation = class(TMutation)
  private
    function HasFormulaOfCategory(const Params: TMB3DParamsFacade; const Category: TFormulaCategory): Boolean;
    function GuessFormulaCategory(const FormulaIndex: Integer;const Params: TMB3DParamsFacade): TFormulaCategory;
  public
    function MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;override;
  end;

  TReplaceFormulaMutation = class(TMutation)
  public
    function MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;override;
  end;

  TRemoveFormulaMutation = class(TMutation)
  public
    function MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;override;
  end;

  TModifyJuliaModeMutation = class(TScalableMutation)
  public
    function MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;override;
  end;

  TModifyIterationCountMutation = class(TScalableMutation)
  public
    function MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;override;
  end;

implementation

uses
  Contnrs, Math, TypeDefinitions, Dialogs;

var
  RandGen: TRandGen;

const
  Epsilon = 1.0e-8;

{ ---------------------------- AllFormulaNames ------------------------------- }
var
  AllFormulaNames: TFormulaNames;

function GetAllFormulaNames: TFormulaNames;
begin
  if AllFormulaNames = nil then
    AllFormulaNames := TFormulaNamesLoader.LoadFormulas;
  Result := AllFormulaNames;
end;
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
  XI1, YI1, XI2, YI2: Integer;
  O1, O2: TPanelOrientation;
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
    O1 := Link.FFromPanel.Orientation;
    X2 := Link.FToPanel.FPanel.FPanel.Left + Round( Link.FToPanel.FXPos * Link.FToPanel.FPanel.FPanel.Width);
    Y2 := Link.FToPanel.FPanel.FPanel.Top + Round( (1.0 - Link.FToPanel.FYPos) * Link.FToPanel.FPanel.FPanel.Height);
    O2 := Link.FToPanel.Orientation;

    if ((O1 = poLeft) and (O2=poRight)) or ((O1 = poRight) and (O2=poLeft)) then begin
      XI1 := Round(X1 + (X2 - X1) * 0.5);
      YI1 := Y1;
      XI2 := XI1;
      YI2 := Y2;
      FLinkLinesList.Add(TPanelLinkLine.Create(X1, Y1, XI1, YI1));
      FLinkLinesList.Add(TPanelLinkLine.Create(XI1, YI1, XI2, YI2));
      FLinkLinesList.Add(TPanelLinkLine.Create(XI2, YI2, X2, Y2));
    end
    else if ((O1 = poTop) and (O2=poBottom)) or ((O1 = poBottom) and (O2=poTop)) then begin
      XI1 := X1;
      YI1 := Round(Y1 + (Y2 - Y1) * 0.5);
      XI2 := X2;
      YI2 := YI1;
      FLinkLinesList.Add(TPanelLinkLine.Create(X1, Y1, XI1, YI1));
      FLinkLinesList.Add(TPanelLinkLine.Create(XI1, YI1, XI2, YI2));
      FLinkLinesList.Add(TPanelLinkLine.Create(XI2, YI2, X2, Y2));
    end
    else
      FLinkLinesList.Add(TPanelLinkLine.Create(X1, Y1, X2, Y2));
  end;
end;

procedure TMutaGenPanelList.AddPanelLink(const FromX, FromY: Double; const FromOrientation: TPanelOrientation; const FromPanel: TMutaGenPanel; const ToX, ToY: Double; const ToOrientation: TPanelOrientation;const ToPanel: TMutaGenPanel);
begin
  FPanelLinkList.Add(TPanelLink.Create(TPanelPosition.Create(FromPanel, FromX, FromY, FromOrientation), TPanelPosition.Create(ToPanel, ToX, ToY, ToOrientation)));
end;

function TMutaGenPanelList.GetCount: Integer;
begin
  Result := FPanels.Count;
end;
{ ----------------------------- TPanelPosition ------------------------------- }
constructor TPanelPosition.Create(const Panel: TMutaGenPanel;const XPos, YPos: Double; const Orientation: TPanelOrientation);
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

  FOrientation := Orientation;
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
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Color := Color;
  Canvas.Pen.Width := 1;
  Canvas.MoveTo(FX1, FY1);
  Canvas.LineTo(FX2, FY2);
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
{ ---------------------------- TMutationParams ------------------------------- }
destructor TMutationParams.Destroy;
begin
  if FParams <> nil then
    FParams.Free;
  if FBitmap <> nil then
    FBitmap.Free;
  if FProbingBitmap <>nil then
    FProbingBitmap.Free;
  inherited Destroy;
end;

procedure TMutationParams.SetBitmap(const Bitmap: TBitmap);
begin
  if FBitmap <> nil then
    FBitmap.Free;
  FBitmap :=Bitmap;
end;

procedure TMutationParams.SetProbingBitmap(const ProbingBitmap: TBitmap);
begin
  if FProbingBitmap <>nil then
    FProbingBitmap.Free;
  FProbingBitmap := ProbingBitmap;
end;
{ --------------------------- TMutationParamsSet ------------------------------ }
constructor TMutationParamsSet.Create;
var
  I: TMutationIndex;
begin
  inherited Create;
  for I:=Low(FParams) to High(FParams) do
    FParams[I] := TMutationParams.Create;
end;

destructor TMutationParamsSet.Destroy;
var
  I: TMutationIndex;
begin
  for I:=Low(FParams) to High(FParams) do begin
    if FParams[I]<>nil then
      FParams[I].Free;
  end;
  inherited Destroy;
end;

function TMutationParamsSet.GetParam(Index: TMutationIndex): TMutationParams;
begin
  Result := FParams[Index];
end;

procedure TMutationParamsSet.SetParam(Index: TMutationIndex; const Param: TMutationParams);
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

function TMutation.GetNonEmptyFormulaCount(const Params: TMB3DParamsFacade): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Params.FormulaCount-1 do begin
    if not Params.Formulas[I].IsEmpty then
      Inc(Result);
  end;
end;

function TMutation.GetNonEmptyFormulasByCategory(const Params: TMB3DParamsFacade; const Category: TFormulaCategory): TStringList;
var
  I: Integer;
  FormulaNamesOfCategory: TStringList;
begin
  Result := TStringList.Create;
  FormulaNamesOfCategory := GetAllFormulaNames.GetFormulaNamesByCategory(Category);
  try
    for I := 0 to Params.FormulaCount-1 do begin
      if (not Params.Formulas[I].IsEmpty) and (FormulaNamesOfCategory.IndexOf(Params.Formulas[I].FormulaName)>=0) then
        Result.Add(IntToStr(I));
    end;
  finally
    FormulaNamesOfCategory.Free;
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

procedure TMutation.RandomizeParamValue(Param: TMB3DParamFacade; const Strength: Double);
var
  OldValue, Delta, Magnitude: Double;
begin
  OldValue := Param.Value;
  if Param.Datatype=ptInteger then begin
    Delta := (1.0+RandGen.NextRandomDouble * 1.5) * Strength;
    if RandGen.NextRandomDouble > 0.5 then
      Delta := 0.0 - Delta;
  end
  else begin
    if Abs(OldValue) > Epsilon then begin
      Magnitude := Log10(Abs(OldValue*0.1));
      Delta := Exp(Magnitude+(0.5+RandGen.NextRandomDouble))* (0.5-RandGen.NextRandomDouble) * Strength
    end
    else
      Delta := (0.5-RandGen.NextRandomDouble) * Strength;
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
  ModifyJuliaModeWeight := 0.5;
  ModifyJuliaModeStrength := 1.0;
  ModifyIterationCountWeight := 0.5;
  ModifyIterationCountStrength := 1.0;

  FProbing := True;
  FProbingWidth := 40;
  FProbingHeight := 32;
  FProbingMaxCount := 9;
  FProbingMinCoverage := 0.32;
  FProbingMinDifference := 0.16;
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

  if Config.ModifyJuliaModeWeight > RandGen.NextRandomDouble then begin
    Mutation := TModifyJuliaModeMutation.Create;
    Mutation.Strength := Config.ModifyJuliaModeStrength;
    Result.Add(Mutation);
  end;

  if Config.ModifyIterationCountWeight > RandGen.NextRandomDouble then begin
    Mutation := TModifyIterationCountMutation.Create;
    Mutation.Strength := Config.ModifyIterationCountStrength;
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
    if (Formula.ParamCount > 2) and (Strength > 0.25) then begin
      ParamIndex := RandGen.NextRandomInt(Formula.ParamCount);
      RandomizeParamValue(Formula.Params[ParamIndex], Strength);
    end;
    if (Formula.ParamCount > 3) and (Strength > 0.5) then begin
      ParamIndex := RandGen.NextRandomInt(Formula.ParamCount);
      RandomizeParamValue(Formula.Params[ParamIndex], Strength);
    end;
    if (Formula.ParamCount > 4) and (Strength > 0.75) then begin
      ParamIndex := RandGen.NextRandomInt(Formula.ParamCount);
      RandomizeParamValue(Formula.Params[ParamIndex], Strength);
    end;
    if (Formula.ParamCount > 5) and (Strength > 1.0) then begin
      ParamIndex := RandGen.NextRandomInt(Formula.ParamCount);
      RandomizeParamValue(Formula.Params[ParamIndex], Strength);
    end;
    if (Formula.ParamCount > 6) and (Strength > 1.25) then begin
      ParamIndex := RandGen.NextRandomInt(Formula.ParamCount);
      RandomizeParamValue(Formula.Params[ParamIndex], Strength);
    end;
    if (Formula.ParamCount > 7) and (Strength > 1.5) then begin
      ParamIndex := RandGen.NextRandomInt(Formula.ParamCount);
      RandomizeParamValue(Formula.Params[ParamIndex], Strength);
    end;
    if (Formula.ParamCount > 8) and (Strength > 1.75) then begin
      ParamIndex := RandGen.NextRandomInt(Formula.ParamCount);
      RandomizeParamValue(Formula.Params[ParamIndex], Strength);
    end;
  end;
end;
{ ---------------------------- TAddFormulaMutation --------------------------- }
function TAddFormulaMutation.HasFormulaOfCategory(const Params: TMB3DParamsFacade; const Category: TFormulaCategory): Boolean;
var
  IdxList: TStringList;
begin
  IdxList := GetNonEmptyFormulasByCategory( Params, Category);
  try
    Result := IdxList.Count > 0;
  finally
    IdxList.Free;
  end;
end;

function TAddFormulaMutation.GuessFormulaCategory(const FormulaIndex: Integer;const Params: TMB3DParamsFacade): TFormulaCategory;
const
  CategoriesForDIFS: array [0..1] of TFormulaCategory=(fc_dIFS, fc_dIFSa);
  CategoriesFor4D: array [0..1] of TFormulaCategory=(fc_4D, fc_4Da);
  CategoriesFor3D: array [0..2] of TFormulaCategory=(fc_3D, fc_Ads, fc_3Da);
begin
  if HasFormulaOfCategory(Params, fc_dIFS) or HasFormulaOfCategory(Params, fc_dIFSa) then begin
    if FormulaIndex > 0 then
      Result :=  CategoriesForDIFS[RandGen.NextRandomInt(High(CategoriesForDIFS))]
    else
      Result := fc_dIFS;
  end
  else if HasFormulaOfCategory(Params, fc_4D) or HasFormulaOfCategory(Params, fc_4Da) then begin
    if FormulaIndex > 0 then
      Result := CategoriesFor4D[ RandGen.NextRandomInt(High(CategoriesFor4D))]
    else
      Result := fc_4D;
  end
  else if HasFormulaOfCategory(Params, fc_3D) or HasFormulaOfCategory(Params, fc_3Da) or HasFormulaOfCategory(Params, fc_Ads) then begin
    if FormulaIndex > 0 then
      Result := CategoriesFor3D[ RandGen.NextRandomInt(High(CategoriesFor3D))]
    else
      Result := fc_3D;
  end
  else begin
    Result := fc_3D;
  end;
end;

function TAddFormulaMutation.MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;
var
  I, Idx, Attempts: Integer;
  FormulaNames: TFormulaNames;
  FormulaNamesForCategory: TStringList;
begin
  FormulaNames := GetAllFormulaNames;
  Result := Params.Clone;
  for I := 0 to 5 do begin
    if Result.Formulas[I].IsEmpty then begin
      FormulaNamesForCategory := FormulaNames.GetFormulaNamesByCategory(GuessFormulaCategory(I, Result));
      if FormulaNamesForCategory.Count > 0 then begin
        Attempts := 0;
        while(Attempts < 25) do begin
          Idx := RandGen.NextRandomInt(FormulaNamesForCategory.Count);
          if (Pos('_', FormulaNamesForCategory[Idx]) <> 1) then begin
            Result.Formulas[I].FormulaName := FormulaNamesForCategory[Idx];
            break;
          end;
          Inc(Attempts);
        end;
      end;
      break;
    end;
  end;
end;
{ -------------------------- TReplaceFormulaMutation ------------------------- }
function TReplaceFormulaMutation.MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;
var
  I, Idx, Attempts: Integer;
  FormulaNames: TFormulaNames;
  FormulaNamesOfSameCategory: TStringList;
  NewFormulaName: String;
  Category: TFormulaCategory;

  function StartsWithUnderScore(const Name: String): Boolean;
  begin
    Result := Pos('_', Name) = 1;
  end;

begin
  Result := Params.Clone;
  FormulaNames := GetAllFormulaNames;
  for I := 0 to 5 do begin
    if not Result.Formulas[I].IsEmpty then begin
      Category := FormulaNames.GetCategoryByFormulaName(Result.Formulas[I].FormulaName);
      FormulaNamesOfSameCategory := FormulaNames.GetFormulaNamesByCategory(Category);
      Attempts := 0;
      while(Attempts < 24) do begin
        Idx := RandGen.NextRandomInt(FormulaNamesOfSameCategory.Count);
        NewFormulaName := FormulaNamesOfSameCategory[Idx];
        if (NewFormulaName <> Result.Formulas[I].FormulaName) and (StartsWithUnderScore(NewFormulaName)=StartsWithUnderScore(Result.Formulas[I].FormulaName)) then begin
          Result.Formulas[I].FormulaName := NewFormulaname;
          break;
        end;
        Inc(Attempts);
      end;
      break;
    end;
  end;
end;
{ --------------------------- TRemoveFormulaMutation ------------------------- }
function TRemoveFormulaMutation.MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;
const
  CategoriesByPriority: array [0..6] of TFormulaCategory=(fc_dIFSa, fc_4Da, fc_3Da, fc_Ads, fc_dIFS, fc_4D, fc_3D);
var
  I, J, Pass, Idx, FCount: Integer;
  IdxList: TStringList;
begin
  Result := Params.Clone;
  FCount := GetNonEmptyFormulaCount(Result);
  if (FCount > 4) or ((FCount > 3) and (RandGen.NextRandomDouble > 0.5)) then begin
    for Pass := 0 to 1 do begin
      for I := Low(CategoriesByPriority) to High(CategoriesByPriority) do begin
        IdxList := GetNonEmptyFormulasByCategory( Result, CategoriesByPriority[I]);
        if Pass = 0 then begin
          J := 0;
          while J< IdxList.Count do begin
            Idx := StrToInt(IdxList[J]);
            if Pos('_', Result.Formulas[Idx].FormulaName) <> 1 then
              IdxList.Delete(J)
            else
              Inc(J);
          end;
        end;
        try
          if IdxList.Count > 0 then begin
            Idx := StrToInt(IdxList[RandGen.NextRandomInt(IdxList.Count)]);
            Result.Formulas[Idx].FormulaName := '';
            exit;
          end;
        finally
          IdxList.Free;
        end;
      end;
    end;
  end;
end;
{ -------------------------- TModifyJuliaModeMutation ------------------------ }
function TModifyJuliaModeMutation.MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;
const
  JuliaScale = 1.5;
begin
  Result := Params.Clone;
  Result.JuliaMode.IsJulia := (RandGen.NextRandomDouble > 0.25);
  if (Result.JuliaMode.IsJulia) then begin
    if RandGen.NextRandomDouble > 0.5 then
      Result.JuliaMode.Jx := Strength * (0.5-RandGen.NextRandomDouble) * JuliaScale;
    if RandGen.NextRandomDouble > 0.5 then
      Result.JuliaMode.Jy := Strength * (0.5-RandGen.NextRandomDouble) * JuliaScale;
    if RandGen.NextRandomDouble > 0.5 then
      Result.JuliaMode.Jz := Strength * (0.5-RandGen.NextRandomDouble) * JuliaScale;
    if RandGen.NextRandomDouble > 0.75 then
      Result.JuliaMode.Jw := Strength * (0.5-RandGen.NextRandomDouble) * JuliaScale;
    if (Abs(Result.JuliaMode.Jx)<Epsilon) and (Abs(Result.JuliaMode.Jy)<Epsilon) and (Abs(Result.JuliaMode.Jz)<Epsilon) then begin
      if RandGen.NextRandomDouble > 0.5 then begin
        if RandGen.NextRandomDouble > 0.5 then
          Result.JuliaMode.Jx := Strength * (0.5-RandGen.NextRandomDouble) * JuliaScale
        else
          Result.JuliaMode.Jz := Strength * (0.5-RandGen.NextRandomDouble) * JuliaScale;
      end
      else begin
        if RandGen.NextRandomDouble > 0.5 then
          Result.JuliaMode.Jy := Strength * (0.5-RandGen.NextRandomDouble) * JuliaScale
        else
          Result.JuliaMode.Jw := Strength * (0.5-RandGen.NextRandomDouble) * JuliaScale;
      end;
    end;
  end
  else begin
    Result.JuliaMode.Jx := 0.0;
    Result.JuliaMode.Jy := 0.0;
    Result.JuliaMode.Jz := 0.0;
    Result.JuliaMode.Jw := 0.0;
  end;
end;
{ ---------------------- TModifyIterationCountMutation ----------------------- }
function TModifyIterationCountMutation.MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;
var
  I, P, Idx, Passes: Integer;
  IdxList: TStringList;
begin
  Result := Params.Clone;
  IdxList := GetNonEmptyFormulas(Params);
  try
    if IdxList.Count > 1 then begin
      Passes := 1;
      if Strength > 0.5 then
        Inc(Passes);
      if Strength > 1.0 then
        Inc(Passes);
      if Strength > 1.5 then
        Inc(Passes);
      for I := 0 to IdxList.Count-1 do
        Result.Formulas[StrToInt(IdxList[I])].IterationCount := 1;
      for P := 1 to Passes do begin
        Idx := RandGen.NextRandomInt(IdxList.Count);
        Idx := StrToInt(IdxList[Idx]);
        Result.Formulas[Idx].IterationCount := 1+ RandGen.NextRandomInt(Round(2.0 + 2.0* Strength));
      end;
    end;
  finally
    IdxList.Free;
  end;
end;
{ ----------------------------- TMutationCoverage ---------------------------- }
class function TMutationCoverage.CalcCoverage(const Bitmap: TBitmap): Double;
const
  Threshold = 10;
var
  Scanline: PRGBTriple;
  X, Y, Count: Integer;
  Lum: Double;
begin
  Count := 0;
  for Y := 0 to Bitmap.Height - 1 do begin
    Scanline := Bitmap.ScanLine[Y];
    for X := 0 to Bitmap.Width - 1 do begin
      with Scanline^ do begin
        Lum := 0.299*rgbtRed + 0.587*rgbtGreen + 0.114*rgbtBlue;
        if Lum > Threshold then
          Inc(Count);
      end;
      Inc(Scanline);
    end;
  end;
  Result := Count/(Bitmap.Height*Bitmap.Width);
end;

class function TMutationCoverage.CalcDiffCoverage(const Bitmap1, Bitmap2: TBitmap): Double;
const
  Threshold = 5.0;
  RThreshold = Threshold * 0.299;
  GThreshold = Threshold * 0.587;
  BThreshold = Threshold * 0.114;
var
  Scanline1, Scanline2: PRGBTriple;
  X, Y, Count: Integer;
begin
  if (Bitmap1.Width <> Bitmap2.Width) or (Bitmap1.Height <> Bitmap2.Height) then
    raise Exception.Create('Non-matching bitmaps');
  Count := 0;
  for Y := 0 to Bitmap1.Height - 1 do begin
    Scanline1 := Bitmap1.ScanLine[Y];
    Scanline2 := Bitmap2.ScanLine[Y];
    for X := 0 to Bitmap1.Width - 1 do begin
      if (Abs(Scanline1^.rgbtRed - Scanline2.rgbtRed) > RThreshold) or
         (Abs(Scanline1^.rgbtGreen - Scanline2.rgbtGreen) > GThreshold) or
         (Abs(Scanline1^.rgbtBlue - Scanline2.rgbtBlue) > BThreshold) then
        Inc(Count);
      Inc(Scanline1);
      Inc(Scanline2);
    end;
  end;
  Result := Count/(Bitmap1.Height*Bitmap1.Width);
end;

class function TMutationCoverage.CalcFilteredCoverage(const Bitmap: TBitmap): Double;
begin
  if Bitmap.PixelFormat = pf24bit then
    Result := CalcFilteredCoverage24(Bitmap)
  else if Bitmap.PixelFormat = pf32bit then
    Result := CalcFilteredCoverage32(Bitmap)
  else
    raise Exception.Create('Invalid Bitmap Format <'+IntToSTr(Ord(Bitmap.PixelFormat))+'>');
end;

class function TMutationCoverage.CalcFilteredCoverage24(const Bitmap: TBitmap): Double;
const
  Threshold = 20.0;
  RThreshold = Threshold * 0.299;
  GThreshold = Threshold * 0.587;
  BThreshold = Threshold * 0.114;
var
  PScanline1, PScanline2, PScanline3: PRGBTriple;
  NScanline1, NScanline2, NScanline3: PRGBTriple;
  X, Y, Count: Integer;
  Lum: Double;
  FilteredRed, FilteredGreen, FilteredBlue: Double;
begin
  Count := 0;
  for Y := 1 to Bitmap.Height - 2 do begin
    PScanline1 := Bitmap.ScanLine[Y-1];
    PScanline2 := Bitmap.ScanLine[Y];
    PScanline3 := Bitmap.ScanLine[Y+1];
    NScanline1 := PScanline1; Inc(NScanline1, 2);
    NScanline2 := PScanline2; Inc(NScanline2, 2);
    NScanline3 := PScanline3; Inc(NScanline3, 2);
    for X := 1 to Bitmap.Width - 2 do begin
      FilteredRed := - PScanline1^.rgbtRed
                     + NScanline1^.rgbtRed
                     - 2 * PScanline2^.rgbtRed
                     + 2 * NScanline2^.rgbtRed
                     - PScanline3^.rgbtRed
                     + NScanline3^.rgbtRed;
      FilteredGreen := - PScanline1^.rgbtGreen
                     + NScanline1^.rgbtGreen
                     - 2 * PScanline2^.rgbtGreen
                     + 2 * NScanline2^.rgbtGreen
                     - PScanline3^.rgbtGreen
                     + NScanline3^.rgbtGreen;
      FilteredBlue := - PScanline1^.rgbtBlue
                     + NScanline1^.rgbtBlue
                     - 2 * PScanline2^.rgbtBlue
                     + 2 * NScanline2^.rgbtBlue
                     - PScanline3^.rgbtBlue
                     + NScanline3^.rgbtBlue;

      Lum := 0.299*FilteredRed + 0.587*FilteredGreen + 0.114*FilteredBlue;
      if Lum > Threshold then
        Inc(Count);
      Inc(PScanline1); Inc(PScanline2); Inc(PScanline3);
      Inc(NScanline1); Inc(NScanline2); Inc(NScanline3);
    end;
  end;
  Result := Count/((Bitmap.Height-2)*(Bitmap.Width-2));
end;

class function TMutationCoverage.CalcFilteredCoverage32(const Bitmap: TBitmap): Double;
const
  Threshold = 20.0;
  RThreshold = Threshold * 0.299;
  GThreshold = Threshold * 0.587;
  BThreshold = Threshold * 0.114;
var
  PScanline1, PScanline2, PScanline3: PRGBQuad;
  NScanline1, NScanline2, NScanline3: PRGBQuad;
  X, Y, Count: Integer;
  Lum: Double;
  FilteredRed, FilteredGreen, FilteredBlue: Double;
begin
  Count := 0;
  for Y := 1 to Bitmap.Height - 2 do begin
    PScanline1 := Bitmap.ScanLine[Y-1];
    PScanline2 := Bitmap.ScanLine[Y];
    PScanline3 := Bitmap.ScanLine[Y+1];
    NScanline1 := PScanline1; Inc(NScanline1, 2);
    NScanline2 := PScanline2; Inc(NScanline2, 2);
    NScanline3 := PScanline3; Inc(NScanline3, 2);
    for X := 1 to Bitmap.Width - 2 do begin
      FilteredRed := - PScanline1^.rgbRed
                     + NScanline1^.rgbRed
                     - 2 * PScanline2^.rgbRed
                     + 2 * NScanline2^.rgbRed
                     - PScanline3^.rgbRed
                     + NScanline3^.rgbRed;
      FilteredGreen := - PScanline1^.rgbGreen
                     + NScanline1^.rgbGreen
                     - 2 * PScanline2^.rgbGreen
                     + 2 * NScanline2^.rgbGreen
                     - PScanline3^.rgbGreen
                     + NScanline3^.rgbGreen;
      FilteredBlue := - PScanline1^.rgbBlue
                     + NScanline1^.rgbBlue
                     - 2 * PScanline2^.rgbBlue
                     + 2 * NScanline2^.rgbBlue
                     - PScanline3^.rgbBlue
                     + NScanline3^.rgbBlue;

      Lum := 0.299*FilteredRed + 0.587*FilteredGreen + 0.114*FilteredBlue;
      if Lum > Threshold then
        Inc(Count);
      Inc(PScanline1); Inc(PScanline2); Inc(PScanline3);
      Inc(NScanline1); Inc(NScanline2); Inc(NScanline3);
    end;
  end;
  Result := Count/((Bitmap.Height-2)*(Bitmap.Width-2));
end;

class function TMutationCoverage.CreateFilteredImage(const Bitmap: TBitmap): TBitmap;
begin
  if Bitmap.PixelFormat = pf24bit then
    Result := CreateFilteredImage24(Bitmap)
  else if Bitmap.PixelFormat = pf32bit then
    Result := CreateFilteredImage32(Bitmap)
  else
    raise Exception.Create('Invalid Bitmap Format <'+IntToSTr(Ord(Bitmap.PixelFormat))+'>');
end;

class function TMutationCoverage.CreateFilteredImage24(const Bitmap: TBitmap): TBitmap;
var
  PScanline1, PScanline2, PScanline3: PRGBTriple;
  NScanline1, NScanline2, NScanline3: PRGBTriple;
  DScanline: PRGBTriple;
  X, Y, Value: Integer;
  BValue: Byte;
  FilteredRed, FilteredGreen, FilteredBlue: Double;
begin
  Result := TBitmap.Create;
  Result.Assign(Bitmap);
  if Result.PixelFormat <> Bitmap.PixelFormat then
    raise Exception.Create('Invalid bitmap');
  for Y := 1 to Bitmap.Height - 2 do begin
    DScanline := Result.ScanLine[Y];
    PScanline1 := Bitmap.ScanLine[Y-1];
    PScanline2 := Bitmap.ScanLine[Y];
    PScanline3 := Bitmap.ScanLine[Y+1];
    NScanline1 := PScanline1; Inc(NScanline1, 2);
    NScanline2 := PScanline2; Inc(NScanline2, 2);
    NScanline3 := PScanline3; Inc(NScanline3, 2);
    Inc(DScanline);
    for X := 1 to Bitmap.Width - 2 do begin
      // Sobel filter
      FilteredRed := - PScanline1^.rgbtRed
                     + NScanline1^.rgbtRed
                     - 2 * PScanline2^.rgbtRed
                     + 2 * NScanline2^.rgbtRed
                     - PScanline3^.rgbtRed
                     + NScanline3^.rgbtRed;
      FilteredGreen := - PScanline1^.rgbtGreen
                     + NScanline1^.rgbtGreen
                     - 2 * PScanline2^.rgbtGreen
                     + 2 * NScanline2^.rgbtGreen
                     - PScanline3^.rgbtGreen
                     + NScanline3^.rgbtGreen;
      FilteredBlue := - PScanline1^.rgbtBlue
                     + NScanline1^.rgbtBlue
                     - 2 * PScanline2^.rgbtBlue
                     + 2 * NScanline2^.rgbtBlue
                     - PScanline3^.rgbtBlue
                     + NScanline3^.rgbtBlue;
      Value := Round(FilteredRed * 0.299 + FilteredGreen * 0.587 + FilteredBlue * 0.114);
      if Value < 0 then
        Value := 0
      else if Value > 255 then
        Value := 255;
      BValue := Byte(Value);

      DScanline^.rgbtRed := BValue;
      DScanline^.rgbtGreen := BValue;
      DScanline^.rgbtBlue := BValue;
      Inc(PScanline1); Inc(PScanline2); Inc(PScanline3);
      Inc(NScanline1); Inc(NScanline2); Inc(NScanline3);
      Inc(DScanline);
    end;
  end;
end;

class function TMutationCoverage.CreateFilteredImage32(const Bitmap: TBitmap): TBitmap;
var
  PScanline1, PScanline2, PScanline3: PRGBQuad;
  NScanline1, NScanline2, NScanline3: PRGBQuad;
  DScanline: PRGBQuad;
  X, Y, Value: Integer;
  BValue: Byte;
  FilteredRed, FilteredGreen, FilteredBlue: Double;
begin
  Result := TBitmap.Create;
  Result.Assign(Bitmap);
  if Result.PixelFormat <> Bitmap.PixelFormat then
    raise Exception.Create('Invalid bitmap');
  for Y := 1 to Bitmap.Height - 2 do begin
    DScanline := Result.ScanLine[Y];
    PScanline1 := Bitmap.ScanLine[Y-1];
    PScanline2 := Bitmap.ScanLine[Y];
    PScanline3 := Bitmap.ScanLine[Y+1];
    NScanline1 := PScanline1; Inc(NScanline1, 2);
    NScanline2 := PScanline2; Inc(NScanline2, 2);
    NScanline3 := PScanline3; Inc(NScanline3, 2);
    Inc(DScanline);
    for X := 1 to Bitmap.Width - 2 do begin
      FilteredRed := - PScanline1^.rgbRed
                     + NScanline1^.rgbRed
                     - 2 * PScanline2^.rgbRed
                     + 2 * NScanline2^.rgbRed
                     - PScanline3^.rgbRed
                     + NScanline3^.rgbRed;
      FilteredGreen := - PScanline1^.rgbGreen
                     + NScanline1^.rgbGreen
                     - 2 * PScanline2^.rgbGreen
                     + 2 * NScanline2^.rgbGreen
                     - PScanline3^.rgbGreen
                     + NScanline3^.rgbGreen;
      FilteredBlue := - PScanline1^.rgbBlue
                     + NScanline1^.rgbBlue
                     - 2 * PScanline2^.rgbBlue
                     + 2 * NScanline2^.rgbBlue
                     - PScanline3^.rgbBlue
                     + NScanline3^.rgbBlue;
      Value := Round(FilteredRed * 0.299 + FilteredGreen * 0.587 + FilteredBlue * 0.114);
      if Value < 0 then
        Value := 0
      else if Value > 255 then
        Value := 255;
      BValue := Byte(Value);

      DScanline^.rgbRed := BValue;
      DScanline^.rgbGreen := BValue;
      DScanline^.rgbBlue := BValue;
      Inc(PScanline1); Inc(PScanline2); Inc(PScanline3);
      Inc(NScanline1); Inc(NScanline2); Inc(NScanline3);
      Inc(DScanline);
    end;
  end;
end;
{ ------------------------------- TProbedParams ------------------------------ }
constructor TProbedParams.Create(const Params: TMB3DParamsFacade; const Coverage, DiffCoverage: Double; const ProbingBitmap: TBitmap);
begin
  inherited Create;
  FParams := Params;
  FCoverage := Coverage;
  FDiffCoverage := DiffCoverage;
  FProbingBitmap := ProbingBitmap;
end;

destructor TProbedParams.Destroy;
begin
  if FParams <> nil then
    FParams.Free;
  if FProbingBitmap <> nil then
    FProbingBitmap.Free;
end;

function TProbedParams.ExtractParams: TMB3DParamsFacade;
begin
  Result := FParams;
  FParams := nil;
end;

function TProbedParams.ExtractProbingBitmap: TBitmap;
begin
  Result := FProbingBitmap;
  FProbingBitmap := nil;
end;
{ ----------------------------- TProbedParamsList ---------------------------- }
constructor TProbedParamsList.Create(Config: TMutationConfig);
begin
  inherited Create;
  FConfig := Config;
  FValidParams := TObjectList.Create;
  FInvalidParams := TObjectList.Create;
end;

destructor TProbedParamsList.Destroy;
begin
  FValidParams.Free;
  FInvalidParams.Free;
  inherited Destroy;
end;

procedure TProbedParamsList.AddProbedParam(const Params: TProbedParams);
begin
  if Params.DiffCoverage >= FConfig.ProbingMinCoverage then
    FValidParams.Add(Params)
  else
    FInvalidParams.Add(Params);
end;

function CompareCoverage(Item1, Item2: Pointer): Integer;
var
  P1, P2: TProbedParams;
begin
  P1 := TProbedParams(Item1);
  P2 := TProbedParams(Item2);
  if P1.Coverage > P2.Coverage then
    Result := -1
  else if P1.Coverage < P2.Coverage then
    Result := 1
  else
    Result := 0;
end;

function TProbedParamsList.GetBestValidParam: TProbedParams;
begin
  if FValidParams.Count > 0 then begin
    FValidParams.Sort(CompareCoverage);
    Result := FValidParams[0];
  end
  else begin
    Result := nil;
  end;
end;

function TProbedParamsList.GetBestInvalidParam: TProbedParams;
begin
  if FInvalidParams.Count > 0 then begin
    FInvalidParams.Sort(CompareCoverage);
    Result := FInvalidParams[0];
  end
  else begin
    Result := nil;
  end;
end;
{ ----------------------------------- Main ----------------------------------- }
initialization
  AllFormulaNames := nil;
  RandGen := TRandGen.Create;
finalization
  if AllFormulaNames<>nil then
    AllFormulaNames.Free;
  RandGen.Free;
end.

