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
    procedure MutateBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure MainPnlResize(Sender: TObject);
    procedure Panel_1DblClick(Sender: TObject);
    procedure SendtoMainItmClick(Sender: TObject);
  private
    { Private declarations }
    FForceAbort: Boolean;
    FIsRunning: Boolean;
    FPanelList: TMutaGenPanelList;
    FP_1, FP_1_1, FP_1_1_1, FP_1_1_1_1, FP_1_1_1_2, FP_1_1_2, FP_1_1_2_1, FP_1_1_2_2, FP_1_2, FP_1_2_1, FP_1_2_1_1, FP_1_2_1_2, FP_1_2_2, FP_1_2_2_1, FP_1_2_2_2: TMutaGenPanel;
    FMutationHistory: TList;
    function CreatePanelList: TMutaGenPanelList;
    procedure InitProgress;
    procedure RefreshMutateButtonCaption;
    procedure ProgressStep;
    procedure CreateInitialSet;
    procedure CreateMutation(Sender: TObject);
    procedure RenderParams(const Panel: TMutaGenPanel; const Params: TMB3DParamsFacade);
    function GetInitialParams(Sender: TObject): TMB3DParamsFacade;
    function CreateParamsCaption(const Params: TMB3DParamsFacade): String;
    function CreateMutationConfig: TMutationConfig;
    function MutateParams(const Params: TMB3DParamsFacade): TMB3DParamsFacade;
    procedure InitOptionsPanel;
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

procedure TMutaGenFrm.RenderParams(const Panel: TMutaGenPanel; const Params: TMB3DParamsFacade);
var
  MB3DPreviewRenderer: TPreviewRenderer;
  bmp: TBitmap;
begin
  MB3DPreviewRenderer := TPreviewRenderer.Create(Params);
  try
    bmp := TBitmap.Create;
    MB3DPreviewRenderer.RenderPreview(bmp, Panel.ImageWidth, Panel.ImageHeight);
    Panel.Bitmap := bmp;
  finally
    MB3DPreviewRenderer.Free;
  end;
end;

procedure TMutaGenFrm.CreateInitialSet;
var
  CurrSet: TMutationParamSet;
begin
  FMutationHistory.Clear;
  CurrSet := TMutationParamSet.Create;
  FMutationHistory.Add(CurrSet);
  CurrSet.Params[miP_1] := TMB3DParamsFacade.Create(Mand3DForm.MHeader, Mand3DForm.HAddOn);
  RenderParams(FP_1, CurrSet.Params[miP_1]);
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
    PrevSet := TMutationParamSet(FMutationHistory[FMutationHistory.Count - 1]);
    for I := 0 to FPanelList.Count - 1 do begin
      MutaGenPanel := FPanelList.GetPanel(I);
      if ((Sender = MutaGenPanel.Panel) or (Sender=MutaGenPanel.Image)) and (PrevSet.Params[MutaGenPanel.MutationIndex]<>nil) then begin
        Result := PrevSet.Params[MutaGenPanel.MutationIndex].Clone;
        exit;
      end;
    end;
    if PrevSet.Params[miP_1]<>nil then begin
      Result := PrevSet.Params[miP_1].Clone;
      exit;
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
  begin
    if FromPanel = nil then
      NewParams := InitialParams
    else
      NewParams := MutateParams(CurrSet.Params[FromPanel.MutationIndex]);
    CurrSet.Params[ToPanel.MutationIndex] := NewParams;
    RenderParams(ToPanel,  CurrSet.Params[ToPanel.MutationIndex]);
    ProgressStep;
    Result := not FForceAbort;
  end;

  procedure ClearPanels;
  var
    I: Integer;
  begin
    for I := 1 to FPanelList.Count-1 do
      FPanelList.GetPanel(I).Bitmap := nil;
  end;

begin
  if FIsRunning then begin
    FForceAbort := True;
    Exit;
  end;

  FIsRunning := True;
  try
    RefreshMutateButtonCaption;
//    ClearPanels;
    FForceAbort := False;
    InitialParams := GetInitialParams( Sender );
    if InitialParams = nil then
      raise Exception.Create('No params to mutate');

    CurrSet := TMutationParamSet.Create;
    FMutationHistory.Add(CurrSet);

    InitProgress;

    if not CreateAndRenderMutation(FP_1, nil) then
      exit;
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
  if FMutationHistory.Count > 0 then begin
    // TODO Display warning?
    FMutationHistory.Clear;
  end;
  CreateInitialSet;
end;

procedure TMutaGenFrm.SendtoMainItmClick(Sender: TObject);
var
  Params: TMB3DParamsFacade;
  Caller: TObject;
begin
  Caller := ((Sender as TMenuItem).GetParentMenu as TPopupMenu).PopupComponent;

  Params := GetInitialParams( Caller );
  if Params = nil then
    raise Exception.Create('No params to send to main editor');
  CopyHeaderAsTextToClipBoard(@Params.Core.Header, CreateParamsCaption(Params));
  Mand3DForm.SpeedButton8Click(Caller);
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
  finally
    Config.Free;
  end;
end;

end.
