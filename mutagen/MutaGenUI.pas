unit MutaGenUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, JvExForms,
  JvCustomItemViewer, JvImagesViewer, JvComponentBase, JvFormAnimatedIcon, MutaGen,
  Vcl.ComCtrls, JvExComCtrls, JvProgressBar, MB3DFacade, Vcl.Menus, JvComCtrls,
  JvxSlider, JvExControls, JvSlider, TrackBarEx, Vcl.Buttons;

type
  TMutaGenFrm = class(TForm)
    Panel1: TPanel;
    MainPnl: TPanel;
    Panel_1: TPanel;
    Image_1: TImage;
    Panel_1_2: TPanel;
    Image_1_2: TImage;
    Panel_1_1: TPanel;
    Image_1_1: TImage;
    Panel_1_2_2: TPanel;
    Image_1_2_2: TImage;
    Panel_1_2_1: TPanel;
    Image_1_2_1: TImage;
    Panel_1_1_2: TPanel;
    Image_1_1_2: TImage;
    Panel_1_1_1: TPanel;
    Image_1_1_1: TImage;
    Panel_1_2_2_2: TPanel;
    Image_1_2_2_2: TImage;
    Panel_1_2_2_1: TPanel;
    Image_1_2_2_1: TImage;
    Panel_1_1_2_2: TPanel;
    Image_1_1_2_2: TImage;
    Panel_1_1_2_1: TPanel;
    Image_1_1_2_1: TImage;
    Panel_1_1_1_1: TPanel;
    Image_1_1_1_1: TImage;
    Panel_1_1_1_2: TPanel;
    Image_1_1_1_2: TImage;
    Panel_1_2_1_2: TPanel;
    Image_1_2_1_2: TImage;
    Panel_1_2_1_1: TPanel;
    Image_1_2_1_1: TImage;
    MainPopupMenu: TPopupMenu;
    SendtoMainItm: TMenuItem;
    CategoryPanelGroup1: TCategoryPanelGroup;
    CategoryPanel2: TCategoryPanel;
    CategoryPanel3: TCategoryPanel;
    CategoryPanel1: TCategoryPanel;
    MutateBtn: TButton;
    ProgressBar: TProgressBar;
    GridPanel2: TGridPanel;
    MinIterLabel: TLabel;
    ModifyFormulaWeightTBar: TTrackBarEx;
    Label2: TLabel;
    Label3: TLabel;
    Panel2: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel3: TPanel;
    Label6: TLabel;
    Label8: TLabel;
    ModifyParamsWeightTBar: TTrackBarEx;
    ModifyParamsStrengthTBar: TTrackBarEx;
    Label9: TLabel;
    Panel4: TPanel;
    Label7: TLabel;
    Label10: TLabel;
    ModifyJuliaModeWeightTBar: TTrackBarEx;
    ModifyJuliaModeStrengthTBar: TTrackBarEx;
    Panel5: TPanel;
    DisableAllBtn: TButton;
    ToClipboardItm: TMenuItem;
    GenerationLbl: TLabel;
    GenerationBtn: TUpDown;
    ClearPrevGenerations: TButton;
    procedure MutateBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure MainPnlResize(Sender: TObject);
    procedure Panel_1DblClick(Sender: TObject);
    procedure SendtoMainItmClick(Sender: TObject);
    procedure DisableAllBtnClick(Sender: TObject);
    procedure ToClipboardItmClick(Sender: TObject);
    procedure ClearPrevGenerationsClick(Sender: TObject);
    procedure GenerationBtnClick(Sender: TObject; Button: TUDBtnType);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
    FForceAbort: Boolean;
    FIsRunning: Boolean;
    FPanelList: TMutaGenPanelList;
    FP_1, FP_1_1, FP_1_1_1, FP_1_1_1_1, FP_1_1_1_2, FP_1_1_2, FP_1_1_2_1, FP_1_1_2_2, FP_1_2, FP_1_2_1, FP_1_2_1_1, FP_1_2_1_2, FP_1_2_2, FP_1_2_2_1, FP_1_2_2_2: TMutaGenPanel;
    FMutationHistory: TList;
    FCurrGenerationIndex: Integer;
    function CreatePanelList: TMutaGenPanelList;
    procedure InitProgress;
    procedure RefreshMutateButtonCaption;
    procedure ProgressStep;
    procedure CreateInitialSet;
    procedure CreateMutation(Sender: TObject);
    function RenderParams(const Panel: TMutaGenPanel; const Params: TMB3DParamsFacade): TBitmap;
    function GetInitialParams(Sender: TObject): TMB3DParamsFacade;
    function GetInitialBitmap(Sender: TObject): TBitmap;
    function CreateParamsCaption(const Params: TMB3DParamsFacade): String;
    function CreateMutationConfig: TMutationConfig;
    function MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;
    procedure InitOptionsPanel;
    procedure RefreshGenerationLabel;
    function AddGeneration:TMutationParamSet;
    procedure ClearPanels;
    function CloneBitmap(const Src: TBitmap): TBitmap;
    procedure ReDisplayCurrGeneration;
    function CreateBlankBitmap(const Width, Height: Integer): TBitmap;
    procedure EnableControls;
  public
    { Public declarations }
    procedure RestartFromMain;
  end;

var
  MutaGenFrm: TMutaGenFrm;

implementation

{$R *.dfm}
uses
  Mand, PreviewRenderer, TypeDefinitions, CustomFormulas, Contnrs, Math, FileHandling;

const
  TBAR_SCALE = 1000.0;

procedure TMutaGenFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := not FIsRunning;
end;

procedure TMutaGenFrm.FormCreate(Sender: TObject);
begin
  FMutationHistory := TObjectList.Create;
  FPanelList := CreatePanelList;
  FPanelList.DoLayout;
  RefreshMutateButtonCaption;
  InitProgress;
  InitOptionsPanel;
end;

procedure TMutaGenFrm.FormDestroy(Sender: TObject);
begin
  FMutationHistory.Free;
  FPanelList.Free;
end;

function TMutaGenFrm.CreatePanelList: TMutaGenPanelList;
const
  PnlXSize = 0.9;
  PnlYSize = 0.8;
  DLine = 0.05;
begin
  Result := TMutaGenPanelList.Create(MainPnl, 5.0, 4.0);
  FP_1 := TMutaGenPanel.Create(nil, miP_1, 0.0, -1.0, PnlXSize, PnlYSize, '1', Panel_1, Image_1);
  Result.AddPanel(FP_1);
    FP_1_1 := TMutaGenPanel.Create(FP_1, miP_1_1, -0.5, 0.0, PnlXSize, PnlYSize, '1', Panel_1_1, Image_1_1);
    Result.AddPanel(FP_1_1);
      FP_1_1_1 := TMutaGenPanel.Create(FP_1_1, miP_1_1_1, -1.5, -0.5, PnlXSize, PnlYSize, '1', Panel_1_1_1, Image_1_1_1);
      Result.AddPanel(FP_1_1_1);
        FP_1_1_1_1 := TMutaGenPanel.Create(FP_1_1_1, miP_1_1_1_1, -2.0, -1.5, PnlXSize, PnlYSize, '1', Panel_1_1_1_1, Image_1_1_1_1);
        Result.AddPanel(FP_1_1_1_1);
        FP_1_1_1_2 := TMutaGenPanel.Create(FP_1_1_1, miP_1_1_1_2, -1.0, -1.5, PnlXSize, PnlYSize, '2', Panel_1_1_1_2, Image_1_1_1_2);
        Result.AddPanel(FP_1_1_1_2);
      FP_1_1_2 := TMutaGenPanel.Create(FP_1_1, miP_1_1_2, -1.5, 0.5, PnlXSize, PnlYSize, '2', Panel_1_1_2, Image_1_1_2);
      Result.AddPanel(FP_1_1_2);
        FP_1_1_2_1 := TMutaGenPanel.Create(FP_1_1_2, miP_1_1_2_1, -2.0, 1.5, PnlXSize, PnlYSize, '1', Panel_1_1_2_1, Image_1_1_2_1);
        Result.AddPanel(FP_1_1_2_1);
        FP_1_1_2_2 := TMutaGenPanel.Create(FP_1_1_2, miP_1_1_2_2, -1.0, 1.5, PnlXSize, PnlYSize, '2', Panel_1_1_2_2, Image_1_1_2_2);
        Result.AddPanel(FP_1_1_2_2);
    FP_1_2 := TMutaGenPanel.Create(FP_1, miP_1_2, 0.5, 0.0, PnlXSize, PnlYSize, '2', Panel_1_2, Image_1_2);
    Result.AddPanel(FP_1_2);
      FP_1_2_1 := TMutaGenPanel.Create(FP_1_2, miP_1_2_1, 1.5, -0.5, PnlXSize, PnlYSize, '1', Panel_1_2_1, Image_1_2_1);
      Result.AddPanel(FP_1_2_1);
        FP_1_2_1_1 := TMutaGenPanel.Create(FP_1_2_1, miP_1_2_1_1, 1.0, -1.5, PnlXSize, PnlYSize, '1', Panel_1_2_1_1, Image_1_2_1_1);
        Result.AddPanel(FP_1_2_1_1);
        FP_1_2_1_2 := TMutaGenPanel.Create(FP_1_2_1, miP_1_2_1_2, 2.0, -1.5, PnlXSize, PnlYSize, '2', Panel_1_2_1_2, Image_1_2_1_2);
        Result.AddPanel(FP_1_2_1_2);
      FP_1_2_2 := TMutaGenPanel.Create(FP_1_2, miP_1_2_2, 1.5, 0.5, PnlXSize, PnlYSize, '2', Panel_1_2_2, Image_1_2_2);
      Result.AddPanel(FP_1_2_2);
        FP_1_2_2_1 := TMutaGenPanel.Create(FP_1_2_2, miP_1_2_2_1, 1.0, 1.5, PnlXSize, PnlYSize, '1', Panel_1_2_2_1, Image_1_2_2_1);
        Result.AddPanel(FP_1_2_2_1);
        FP_1_2_2_2 := TMutaGenPanel.Create(FP_1_2_2, miP_1_2_2_2, 2.0, 1.5, PnlXSize, PnlYSize, '2', Panel_1_2_2_2, Image_1_2_2_2);
        Result.AddPanel(FP_1_2_2_2);

   Result.AddPanelLink(0.5 - DLine, 1.0, FP_1, 0.5, 0.0, FP_1_1);
     Result.AddPanelLink(0.0, 0.5 - DLine, FP_1_1, 1.0, 0.5, FP_1_1_1);
       Result.AddPanelLink(0.5 - DLine, 0.0, FP_1_1_1, 0.5, 1.0, FP_1_1_1_1);
       Result.AddPanelLink(0.5 + Dline, 0.0, FP_1_1_1, 0.5, 1.0, FP_1_1_1_2);
     Result.AddPanelLink(0.0, 0.5 + DLine, FP_1_1, 1.0, 0.5, FP_1_1_2);
       Result.AddPanelLink(0.5 - DLine, 1.0, FP_1_1_2, 0.5, 0.0, FP_1_1_2_1);
       Result.AddPanelLink(0.5 + Dline, 1.0, FP_1_1_2, 0.5, 0.0, FP_1_1_2_2);
   Result.AddPanelLink(0.5 + DLine, 1.0, FP_1, 0.5, 0.0, FP_1_2);
     Result.AddPanelLink(1.0, 0.5 - DLine, FP_1_2, 0.0, 0.5, FP_1_2_1);
       Result.AddPanelLink(0.5 - DLine, 0.0, FP_1_2_1, 0.5, 1.0, FP_1_2_1_1);
       Result.AddPanelLink(0.5 + Dline, 0.0, FP_1_2_1, 0.5, 1.0, FP_1_2_1_2);
     Result.AddPanelLink(1.0, 0.5 + DLine, FP_1_2, 0.0, 0.5, FP_1_2_2);
       Result.AddPanelLink(0.5 - DLine, 1.0, FP_1_2_2, 0.5, 0.0, FP_1_2_2_1);
       Result.AddPanelLink(0.5 + Dline, 1.0, FP_1_2_2, 0.5, 0.0, FP_1_2_2_2);
 end;

procedure TMutaGenFrm.FormPaint(Sender: TObject);
var
  I: Integer;
begin
  if Assigned(FPanelList) then
    for I := 0 to FPanelList.LinkLinesList.Count -1 do
      TPanelLinkLine(FPanelList.LinkLinesList[I]).Draw(Canvas);
end;

procedure TMutaGenFrm.MainPnlResize(Sender: TObject);
begin
  if Assigned(FPanelList) then
    FPanelList.DoLayout;
end;

function TMutaGenFrm.RenderParams(const Panel: TMutaGenPanel; const Params: TMB3DParamsFacade): TBitmap;
var
  MB3DPreviewRenderer: TPreviewRenderer;
begin
  Result := TBitmap.Create;
  try
    MB3DPreviewRenderer := TPreviewRenderer.Create(Params);
    try
      MB3DPreviewRenderer.RenderPreview(Result, Panel.ImageWidth, Panel.ImageHeight);
    finally
      MB3DPreviewRenderer.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure TMutaGenFrm.MutateBtnClick(Sender: TObject);
begin
  CreateMutation(Panel_1);
end;

function TMutaGenFrm.GetInitialParams(Sender: TObject): TMB3DParamsFacade;
var
  I: Integer;
  PrevSet: TMutationParamSet;
  MutaGenPanel: TMutaGenPanel;
begin
  Result := nil;
  if FMutationHistory.Count > 0 then begin
    PrevSet := TMutationParamSet(FMutationHistory[FCurrGenerationIndex]);
    for I := 0 to FPanelList.Count - 1 do begin
      MutaGenPanel := FPanelList.GetPanel(I);
      if ((Sender = MutaGenPanel.Panel) or (Sender=MutaGenPanel.Image)) and (PrevSet.Params[MutaGenPanel.MutationIndex]<>nil) then begin
        Result := PrevSet.Params[MutaGenPanel.MutationIndex].Clone;
        exit;
      end;
    end;
  end;
end;

function TMutaGenFrm.GetInitialBitmap(Sender: TObject): TBitmap;
var
  I: Integer;
  PrevSet: TMutationParamSet;
  MutaGenPanel: TMutaGenPanel;
begin
  Result := nil;
  if FMutationHistory.Count > 0 then begin
    PrevSet := TMutationParamSet(FMutationHistory[FCurrGenerationIndex]);
    for I := 0 to FPanelList.Count - 1 do begin
      MutaGenPanel := FPanelList.GetPanel(I);
      if ((Sender = MutaGenPanel.Panel) or (Sender=MutaGenPanel.Image)) and (PrevSet.Params[MutaGenPanel.MutationIndex]<>nil) then begin
        Result := PrevSet.Bitmaps[MutaGenPanel.MutationIndex];
        exit;
      end;
    end;
  end;
end;

procedure TMutaGenFrm.CreateMutation(Sender: TObject);
const
  MutationStrength = 1.0;
var
  CurrSet: TMutationParamSet;
  InitialParams: TMB3DParamsFacade;

  function CreateAndRenderMutation(const ToPanel, FromPanel: TMutaGenPanel): Boolean;
  var
    NewParams: TMB3DParamsFacade;
    NewBitmap: TBitmap;
  begin
    if FromPanel = nil then begin
      NewParams := InitialParams;
      CurrSet.Params[ToPanel.MutationIndex] := NewParams;
      NewBitmap := GetInitialBitmap( Sender );
      if NewBitmap = nil then
        NewBitmap := RenderParams(ToPanel,  CurrSet.Params[ToPanel.MutationIndex])
      else
        NewBitmap := CloneBitmap( NewBitmap );
      CurrSet.Bitmaps[ToPanel.MutationIndex] := NewBitmap;
      ToPanel.Bitmap := CloneBitmap( NewBitmap );
      ProgressStep;
      Result := True;
    end
    else begin
      NewParams := MutateParams(CurrSet.Params[FromPanel.MutationIndex]);
      CurrSet.Params[ToPanel.MutationIndex] := NewParams;
      NewBitmap := RenderParams(ToPanel,  CurrSet.Params[ToPanel.MutationIndex]);
      CurrSet.Bitmaps[ToPanel.MutationIndex] := NewBitmap;
      ToPanel.Bitmap := CloneBitmap( NewBitmap );
      ProgressStep;
      Result := not FForceAbort;
    end;
  end;

begin
  if FIsRunning then begin
    FForceAbort := True;
    Exit;
  end;

  InitialParams := GetInitialParams( Sender );
  if InitialParams = nil then
    exit;

  FIsRunning := True;
  try
    EnableControls;
    RefreshMutateButtonCaption;
    ClearPanels;
    FForceAbort := False;

    CurrSet := AddGeneration;
    InitProgress;

    if not CreateAndRenderMutation(FP_1, nil) then
      exit;
    FP_1.Panel.Caption := CurrSet.Params[miP_1].UUID;

    if not CreateAndRenderMutation(FP_1_1, FP_1) then
      exit;
    if not CreateAndRenderMutation(FP_1_2, FP_1) then
      exit;
    if not CreateAndRenderMutation(FP_1_1_1, FP_1_1) then
      exit;
    if not CreateAndRenderMutation(FP_1_2_1, FP_1_2) then
      exit;
    if not CreateAndRenderMutation(FP_1_1_2, FP_1_1) then
      exit;
    if not CreateAndRenderMutation(FP_1_2_2, FP_1_2) then
      exit;
    if not CreateAndRenderMutation(FP_1_1_1_1, FP_1_1_1) then
      exit;
    if not CreateAndRenderMutation(FP_1_1_2_1, FP_1_1_2) then
      exit;
    if not CreateAndRenderMutation(FP_1_2_1_1, FP_1_2_1) then
      exit;
    if not CreateAndRenderMutation(FP_1_2_2_1, FP_1_2_2) then
      exit;
    if not CreateAndRenderMutation(FP_1_1_1_2, FP_1_1_1) then
      exit;
    if not CreateAndRenderMutation(FP_1_1_2_2, FP_1_1_2) then
      exit;
    if not CreateAndRenderMutation(FP_1_2_1_2, FP_1_2_1) then
      exit;
    if not CreateAndRenderMutation(FP_1_2_2_2, FP_1_2_2) then
      exit;
  finally
    FIsRunning := False;
    RefreshMutateButtonCaption;
    InitProgress;
    EnableControls;
  end;
end;

procedure TMutaGenFrm.InitProgress;
begin
  ProgressBar.Position := 0;
end;

procedure TMutaGenFrm.Panel_1DblClick(Sender: TObject);
begin
  CreateMutation(Sender);
end;

procedure TMutaGenFrm.ProgressStep;
begin
  ProgressBar.StepIt;
  ProgressBar.Repaint;
  Application.ProcessMessages;
end;

procedure TMutaGenFrm.RefreshMutateButtonCaption;
begin
  if FIsRunning then
    MutateBtn.Caption := 'Cancel'
  else
    MutateBtn.Caption := 'Mutate!';
  MutateBtn.Repaint;
end;

procedure TMutaGenFrm.RestartFromMain;
begin
  ClearPanels;
  CreateInitialSet;
end;

procedure TMutaGenFrm.ToClipboardItmClick(Sender: TObject);
var
  Params: TMB3DParamsFacade;
  Caller: TObject;
begin
  Caller := ((Sender as TMenuItem).GetParentMenu as TPopupMenu).PopupComponent;
  Params := GetInitialParams( Caller );
  if Params = nil then
    raise Exception.Create('No params to send to main editor');
  CopyHeaderAsTextToClipBoard(Params.Core.PHeader, CreateParamsCaption(Params));
end;

procedure TMutaGenFrm.SendtoMainItmClick(Sender: TObject);
begin
  ToClipboardItmClick(Sender);
  Mand3DForm.SpeedButton8Click(Sender);
end;

function TMutaGenFrm.CreateParamsCaption(const Params: TMB3DParamsFacade): String;
begin
  Result := 'MutaGen' + Params.UUID;
end;

function TMutaGenFrm.MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;
var
  I: Integer;
  Mutations: TList;
  Config: TMutationConfig;
begin
  Config := CreateMutationConfig;
  try
    Mutations := TMutationCreator.CreateMutations(Config)
  finally
    Config.Free;
  end;
  try
    Result := Params;
    for I := 0 to Mutations.Count-1 do begin
      Result := TMutation(Mutations[I]).MutateParams(Result);
    end;
  finally
    Mutations.Free;
  end;
end;

function TMutaGenFrm.CreateMutationConfig: TMutationConfig;
begin
  Result := TMutationConfig.Create;
  Result.ModifyFormulaWeight := ModifyFormulaWeightTBar.Position / TBAR_SCALE;
  Result.ModifyParamsWeight := ModifyParamsWeightTBar.Position / TBAR_SCALE;
  Result.ModifyParamsStrength := ModifyParamsStrengthTBar.Position / TBAR_SCALE;
  Result.ModifyJuliaModeWeight := ModifyJuliaModeWeightTBar.Position / TBAR_SCALE;
  Result.ModifyJuliaModeStrength := ModifyJuliaModeStrengthTBar.Position / TBAR_SCALE;
end;

procedure TMutaGenFrm.InitOptionsPanel;
var
  Config:TMutationConfig;
begin
  Config:=TMutationConfig.Create;
  try
    ModifyFormulaWeightTBar.Position := Round(TBAR_SCALE * Config.ModifyFormulaWeight);
    ModifyParamsWeightTBar.Position := Round(TBAR_SCALE * Config.ModifyParamsWeight);
    ModifyParamsStrengthTBar.Position := Round(TBAR_SCALE * Config.ModifyParamsStrength);
    ModifyJuliaModeWeightTBar.Position := Round(TBAR_SCALE * Config.ModifyJuliaModeWeight);
    ModifyJuliaModeStrengthTBar.Position := Round(TBAR_SCALE * Config.ModifyJuliaModeStrength);
  finally
    Config.Free;
  end;
end;

procedure TMutaGenFrm.DisableAllBtnClick(Sender: TObject);
begin
  ModifyFormulaWeightTBar.Position := 0;
  ModifyParamsWeightTBar.Position := 0;
  ModifyJuliaModeWeightTBar.Position := 0;
end;

procedure TMutaGenFrm.CreateInitialSet;
var
  CurrSet: TMutationParamSet;
  NewBitmap: TBitmap;
begin
  CurrSet := AddGeneration;
  CurrSet.Params[miP_1] := TMB3DParamsFacade.Create(Mand3DForm.MHeader, Mand3DForm.HAddOn);
  NewBitmap := RenderParams(FP_1, CurrSet.Params[miP_1]);
  CurrSet.Bitmaps[miP_1] := NewBitmap;
  FP_1.Bitmap := CloneBitmap( NewBitmap );
  FP_1.Panel.Caption := CurrSet.Params[miP_1].UUID;
end;

function TMutaGenFrm.AddGeneration:TMutationParamSet;
begin
  Result := TMutationParamSet.Create;
  FCurrGenerationIndex := FMutationHistory.Count;
  FMutationHistory.Add(Result);
  RefreshGenerationLabel;
end;

procedure TMutaGenFrm.RefreshGenerationLabel;
begin
  GenerationLbl.Caption := 'Generation '+IntToStr(FCurrGenerationIndex+1)+' of '+IntToStr(FMutationHistory.Count);
end;

function TMutaGenFrm.CreateBlankBitmap(const Width, Height: Integer): TBitmap;
begin
  Result := TBitmap.Create;
  Result.PixelFormat := pf32Bit;
  Result.Width  := Width;
  Result.Height := Height;
end;

procedure TMutaGenFrm.ClearPanels;
var
  I: Integer;
  Panel: TMutaGenPanel;
begin
  for I := 1 to FPanelList.Count-1 do begin
    Panel := FPanelList.GetPanel(I);
    Panel.Bitmap := CreateBlankBitmap(Panel.ImageWidth, Panel.ImageHeight);
  end;
end;

function TMutaGenFrm.CloneBitmap(const Src: TBitmap): TBitmap;
begin
  Result := TBitmap.Create;
  Result.Assign(Src);
end;

procedure TMutaGenFrm.ReDisplayCurrGeneration;
var
  I: Integer;
  Panel: TMutaGenPanel;
  CurrSet: TMutationParamSet;
  bmp: TBitmap;
begin
  if (FCurrGenerationIndex >= 0) and (FCurrGenerationIndex < FMutationHistory.Count) then begin
    CurrSet := TMutationParamSet( FMutationHistory[FCurrGenerationIndex] );
    for I := 0 to FPanelList.Count-1 do begin
      Panel := FPanelList.GetPanel(I);
      bmp := CurrSet.Bitmaps[Panel.MutationIndex];
      if bmp = nil then
        bmp := CreateBlankBitmap(Panel.ImageWidth, Panel.ImageHeight);
      Panel.Bitmap := bmp;
      if Panel.MutationIndex = miP_1 then begin
        Panel.Panel.Caption := CurrSet.Params[Panel.MutationIndex].UUID;
      end;
    end;
  end;
end;

procedure TMutaGenFrm.GenerationBtnClick(Sender: TObject; Button: TUDBtnType);
begin
  if (Button = btNext) and (FCurrGenerationIndex < FMutationHistory.Count - 1) then begin
    FCurrGenerationIndex := FCurrGenerationIndex + 1;
    ReDisplayCurrGeneration;
    RefreshGenerationLabel;
  end
  else if (Button = btPrev) and (FCurrGenerationIndex > 0) then begin
    FCurrGenerationIndex := FCurrGenerationIndex - 1;
    ReDisplayCurrGeneration;
    RefreshGenerationLabel;
  end;
end;

procedure TMutaGenFrm.EnableControls;
begin
  GenerationBtn.Enabled := not FIsRunning;
  ClearPrevGenerations.Enabled := not FIsRunning;
  DisableAllBtn.Enabled := not FIsRunning;
end;

procedure TMutaGenFrm.ClearPrevGenerationsClick(Sender: TObject);
var
  I, DeleteTo: Integer;
begin
  if (FCurrGenerationIndex > 0) and (FCurrGenerationIndex < FMutationHistory.Count) then begin
    if MessageDlg('Do you really want to clear all previous generations?', mtConfirmation, mbYesNo, 0) = mrYes then begin
      DeleteTo := FCurrGenerationIndex - 1;
      FCurrGenerationIndex := 0;
      try
        for I := 0 to DeleteTo do
          FMutationHistory.Delete(0);
      finally
        RefreshGenerationLabel;
      end;
    end;
  end;
end;

end.
(*
TODO
  - Strength -> more influence on modify param mutation
  - iter-count-mutation
  - enable cancel while rendering

*)
