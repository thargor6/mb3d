unit MutaGenGUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, JvExForms,
  JvCustomItemViewer, JvImagesViewer, JvComponentBase, JvFormAnimatedIcon, MutaGen,
  Vcl.ComCtrls, JvExComCtrls, JvProgressBar, MB3DFacade, Vcl.Menus, JvComCtrls,
  JvxSlider, JvExControls, JvSlider, TrackBarEx, Vcl.Buttons, PreviewRenderer,
  JvExStdCtrls, JvGroupBox, JvOutlookBar, JvExExtCtrls, JvExtComponent,
  JvCaptionPanel, JvPageList, JvNavigationPane, JvClipboardMonitor;

type
  TCategoryPanel = class(Vcl.ExtCtrls.TCategoryPanel)
  protected
    procedure DrawCollapsedPanel(ACanvas: TCanvas); override;
  end;

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
    ToClipboardItm: TMenuItem;
    PreviewRenderTimer: TTimer;
    GenerationsGrp: TJvGroupBox;
    Panel9: TPanel;
    GenerationBtn: TUpDown;
    ClearPrevGenerations: TButton;
    MutateGrp: TJvGroupBox;
    Panel8: TPanel;
    ProgressBar: TProgressBar;
    MutateBtn: TButton;
    OptionsGrp: TJvGroupBox;
    Panel7: TPanel;
    Panel5: TPanel;
    DisableAllBtn: TButton;
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
    Panel6: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    ModifyIterationCountWeightTBar: TTrackBarEx;
    ModifyIterationCountStrengthTBar: TTrackBarEx;
    GenerationEdit: TEdit;
    WarningPnl: TPanel;
    Label13: TLabel;
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
    FPreviewImageRenderer: TPreviewRenderer;
    FProbingImageRenderer: TPreviewRenderer;
    function CreatePanelList: TMutaGenPanelList;
    procedure InitProgress;
    procedure RefreshMutateButtonCaption;
    procedure ProgressStep;
    procedure CreateInitialSet;
    procedure CreateMutation(Sender: TObject);
    function CreatePreviewImage(const Panel: TMutaGenPanel; const Params: TMB3DParamsFacade): TBitmap;
    function CreateProbingImage(Config: TMutationConfig; const Params: TMB3DParamsFacade): TBitmap;
    function CreateParamsCaption(const Params: TMB3DParamsFacade): String;
    function CreateMutationConfig: TMutationConfig;
    function MutateParams(Config: TMutationConfig;const Params: TMB3DParamsFacade): TMB3DParamsFacade;
    procedure InitOptionsPanel;
    procedure RefreshGenerationLabel;
    function GetInitialParams(Sender: TObject): TMutationParams;
    function AddGeneration: TMutationParamsSet;
    procedure ClearPanels;
    function CloneBitmap(const Src: TBitmap): TBitmap;
    procedure ReDisplayCurrGeneration;
    function CreateBlankBitmap(const Width, Height: Integer): TBitmap;
    procedure EnableControls;
    procedure SignalCancel;
  public
    { Public declarations }
    procedure RestartFromMain;
  end;

var
  MutaGenFrm: TMutaGenFrm;

implementation

{$R *.dfm}
uses
  Mand, TypeDefinitions, CustomFormulas, Contnrs, Math, FileHandling;

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
  if FPreviewImageRenderer <> nil then
    FreeAndNil(FPreviewImageRenderer);
  if FProbingImageRenderer <> nil then
    FreeAndNil(FProbingImageRenderer);
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

   Result.AddPanelLink(0.5 - DLine, 1.0, poTop, FP_1, 0.5, 0.0, poBottom, FP_1_1);
     Result.AddPanelLink(0.0, 0.5 - DLine, poLeft, FP_1_1, 1.0, 0.5, poRight, FP_1_1_1);
       Result.AddPanelLink(0.5 - DLine, 0.0, poBottom, FP_1_1_1, 0.5, 1.0, poTop, FP_1_1_1_1);
       Result.AddPanelLink(0.5 + Dline, 0.0, poBottom, FP_1_1_1, 0.5, 1.0, poTop, FP_1_1_1_2);
     Result.AddPanelLink(0.0, 0.5 + DLine, poLeft, FP_1_1, 1.0, 0.5, poRight, FP_1_1_2);
       Result.AddPanelLink(0.5 - DLine, 1.0, poTop, FP_1_1_2, 0.5, 0.0, poBottom, FP_1_1_2_1);
       Result.AddPanelLink(0.5 + Dline, 1.0, poTop, FP_1_1_2, 0.5, 0.0, poBottom, FP_1_1_2_2);
   Result.AddPanelLink(0.5 + DLine, 1.0, poTop, FP_1, 0.5, 0.0, poBottom, FP_1_2);
     Result.AddPanelLink(1.0, 0.5 - DLine, poRight, FP_1_2, 0.0, 0.5, poLeft, FP_1_2_1);
       Result.AddPanelLink(0.5 - DLine, 0.0, poBottom, FP_1_2_1, 0.5, 1.0, poTop, FP_1_2_1_1);
       Result.AddPanelLink(0.5 + Dline, 0.0, poBottom, FP_1_2_1, 0.5, 1.0, poTop, FP_1_2_1_2);
     Result.AddPanelLink(1.0, 0.5 + DLine, poRight, FP_1_2, 0.0, 0.5, poLeft, FP_1_2_2);
       Result.AddPanelLink(0.5 - DLine, 1.0, poTop, FP_1_2_2, 0.5, 0.0, poBottom, FP_1_2_2_1);
       Result.AddPanelLink(0.5 + Dline, 1.0, poTop, FP_1_2_2, 0.5, 0.0, poBottom, FP_1_2_2_2);
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
  if Assigned(FPanelList) then begin
    FPanelList.DoLayout;
    MainPnl.Invalidate;
    MainPnl.Repaint;
  end;
end;

procedure TMutaGenFrm.MutateBtnClick(Sender: TObject);
begin
  CreateMutation(Panel_1);
end;

function TMutaGenFrm.GetInitialParams(Sender: TObject): TMutationParams;
var
  I: Integer;
  PrevSet: TMutationParamsSet;
  MutaGenPanel: TMutaGenPanel;
begin
  Result := nil;
  if FMutationHistory.Count > 0 then begin
    PrevSet := TMutationParamsSet(FMutationHistory[FCurrGenerationIndex]);
    for I := 0 to FPanelList.Count - 1 do begin
      MutaGenPanel := FPanelList.GetPanel(I);
      if ((Sender = MutaGenPanel.Panel) or (Sender=MutaGenPanel.Image)) and (PrevSet.Params[MutaGenPanel.MutationIndex]<>nil) then begin
        Result := PrevSet.Params[MutaGenPanel.MutationIndex];
        exit;
      end;
    end;
  end;
end;

procedure TMutaGenFrm.CreateMutation(Sender: TObject);
var
  CurrSet: TMutationParamsSet;
  InitialParams: TMutationParams;
  Config: TMutationConfig;

  function CreateInitialSet(const ToPanel, FromPanel: TMutaGenPanel): Boolean;
  var
    NewParams: TMB3DParamsFacade;
    NewBitmap: TBitmap;
  begin
    NewParams := InitialParams.Params.Clone;
    CurrSet.Params[ToPanel.MutationIndex].Params := NewParams;

    if InitialParams.Bitmap = nil then
      NewBitmap := CreatePreviewImage(ToPanel, CurrSet.Params[ToPanel.MutationIndex].Params )
    else
      NewBitmap := CloneBitmap( InitialParams.Bitmap );
    CurrSet.Params[ToPanel.MutationIndex].Bitmap := NewBitmap;

    ToPanel.Bitmap := CloneBitmap( NewBitmap );

    if Config.Probing then begin
      if InitialParams.ProbingBitmap = nil then
        NewBitmap := CreateProbingImage(Config, CurrSet.Params[ToPanel.MutationIndex].Params )
      else
        NewBitmap := CloneBitmap( InitialParams.ProbingBitmap );
      CurrSet.Params[ToPanel.MutationIndex].ProbingBitmap := NewBitmap;
    end;

    ProgressStep;
    Result := True;
  end;

  function CreateMutation(const ToPanel, FromPanel: TMutaGenPanel): Boolean;
  var
    I: Integer;
    NewParams: TMB3DParamsFacade;
    NewBitmap: TBitmap;
    ProbedParams: TProbedParamsList;
    Coverage, DiffCoverage: Double;
    BestParams: TProbedParams;
  begin
    if Config.Probing then begin
      ProbedParams := TProbedParamsList.Create(Config);
      try
        OutputDebugString(PChar('Probing...'));
        for I := 0 to Config.ProbingMaxCount -1  do begin
          NewParams := MutateParams( Config, CurrSet.Params[FromPanel.MutationIndex].Params );
          NewBitmap := CreateProbingImage(Config,  NewParams );
          if (NewBitmap = nil) or FForceAbort then begin
            Result := False;
            Exit;
          end;
          Coverage := TMutationCoverage.CalcFilteredCoverage(NewBitmap);
          DiffCoverage := TMutationCoverage.CalcDiffCoverage(NewBitmap, CurrSet.Params[FromPanel.MutationIndex].ProbingBitmap);
          ProbedParams.AddProbedParam( TProbedParams.Create(NewParams, Coverage, DiffCoverage, NewBitmap ) );

          BestParams := ProbedParams.GetBestValidParam;
          if (BestParams <> nil) and (BestParams.Coverage >= Config.ProbingMinCoverage)  then
            break;
          OutputDebugString(PChar('  '+IntToStr(I)));
        end;
        OutputDebugString(PChar('Done...'));
        BestParams := ProbedParams.GetBestValidParam;
        if BestParams = nil then
          BestParams := ProbedParams.GetBestInvalidParam;

        NewParams := BestParams.ExtractParams;
        CurrSet.Params[ToPanel.MutationIndex].Params := NewParams;
        CurrSet.Params[ToPanel.MutationIndex].ProbingBitmap := BestParams.ExtractProbingBitmap;
        //// For Debugging
        // Probing Bitmap;
        //   NewBitmap := CloneBitmap(CurrSet.Params[ToPanel.MutationIndex].ProbingBitmap);
        // Filtered Bitmap:
        //   NewBitmap := TMutationCoverage.CreateFilteredImage(CurrSet.Params[ToPanel.MutationIndex].ProbingBitmap);
        //// Regular display
        NewBitmap := CreatePreviewImage(ToPanel,  CurrSet.Params[ToPanel.MutationIndex].Params );

        CurrSet.Params[ToPanel.MutationIndex].Bitmap := NewBitmap;

        if NewBitmap = nil then begin
          Result := False;
          Exit;
        end;
        ToPanel.Bitmap := CloneBitmap( NewBitmap );
      finally
        ProbedParams.Free;
      end;
    end
    else begin
      NewParams := MutateParams( Config, CurrSet.Params[FromPanel.MutationIndex].Params );
      CurrSet.Params[ToPanel.MutationIndex].Params := NewParams;

      NewBitmap := CreatePreviewImage(ToPanel,  CurrSet.Params[ToPanel.MutationIndex].Params );
      CurrSet.Params[ToPanel.MutationIndex].Bitmap := NewBitmap;
      if NewBitmap = nil then begin
        Result := False;
        Exit;
      end;

      ToPanel.Bitmap := CloneBitmap( NewBitmap );
    end;

    ProgressStep;
    Result := not FForceAbort;
  end;

  function CreateAndRenderMutation(const ToPanel, FromPanel: TMutaGenPanel): Boolean;
  begin
    if FromPanel = nil then
      Result := CreateInitialSet( ToPanel, FromPanel )
    else
      Result := CreateMutation( ToPanel, FromPanel );
  end;

begin
  WarningPnl.Visible := False;
  if FIsRunning then begin
    SignalCancel;
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

    Config := CreateMutationConfig;
    try
      CurrSet := AddGeneration;
      InitProgress;

      if not CreateAndRenderMutation(FP_1, nil) then
        exit;
      FP_1.Panel.Caption := CurrSet.Params[miP_1].Params.UUID;

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
      Config.Free;
    end;
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
  Params: TMutationParams;
  Caller: TObject;
begin
  Caller := ((Sender as TMenuItem).GetParentMenu as TPopupMenu).PopupComponent;
  Params := GetInitialParams( Caller );
  if Params = nil then
    raise Exception.Create('No params to send to main editor');
  CopyHeaderAsTextToClipBoard(Params.Params.Core.PHeader, CreateParamsCaption(Params.Params));
end;

procedure TMutaGenFrm.SendtoMainItmClick(Sender: TObject);
begin
  if Mand3DForm.IsCalculating then
    raise Exception.Create('The main editor is still rendering. Please stop it first or wait until it is done.');
  ToClipboardItmClick(Sender);
  Mand3DForm.SpeedButton8Click(Sender);
end;

function TMutaGenFrm.CreateParamsCaption(const Params: TMB3DParamsFacade): String;
begin
  Result := 'MutaGen' + Params.UUID;
end;

function TMutaGenFrm.MutateParams(Config: TMutationConfig;const Params: TMB3DParamsFacade): TMB3DParamsFacade;
var
  I: Integer;
  Mutations: TList;
begin
  Mutations := TMutationCreator.CreateMutations(Config);
  try
    Result := Params.Clone;
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
  Result.ModifyIterationCountWeight := ModifyIterationCountWeightTBar.Position / TBAR_SCALE;
  Result.ModifyIterationCountStrength := ModifyIterationCountStrengthTBar.Position / TBAR_SCALE;
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
    ModifyIterationCountWeightTBar.Position := Round(TBAR_SCALE * Config.ModifyIterationCountWeight);
    ModifyIterationCountStrengthTBar.Position := Round(TBAR_SCALE * Config.ModifyIterationCountStrength);
  finally
    Config.Free;
  end;
end;

procedure TMutaGenFrm.DisableAllBtnClick(Sender: TObject);
begin
  ModifyFormulaWeightTBar.Position := 0;
  ModifyParamsWeightTBar.Position := 0;
  ModifyJuliaModeWeightTBar.Position := 0;
  ModifyIterationCountWeightTBar.Position := 0;
end;

procedure TMutaGenFrm.CreateInitialSet;
var
  CurrSet: TMutationParamsSet;
  NewBitmap: TBitmap;
begin
  CurrSet := AddGeneration;
  CurrSet.Params[miP_1].Params := TMB3DParamsFacade.Create(Mand3DForm.MHeader, Mand3DForm.HAddOn);
  NewBitmap := CreatePreviewImage(FP_1, CurrSet.Params[miP_1].Params );
  CurrSet.Params[miP_1].Bitmap := NewBitmap;
  if True then

  FP_1.Bitmap := CloneBitmap( NewBitmap );
  FP_1.Panel.Caption := CurrSet.Params[miP_1].Params.UUID;
end;

function TMutaGenFrm.AddGeneration:TMutationParamsSet;
begin
  Result := TMutationParamsSet.Create;
  FCurrGenerationIndex := FMutationHistory.Count;
  FMutationHistory.Add(Result);
  RefreshGenerationLabel;
end;

procedure TMutaGenFrm.RefreshGenerationLabel;
begin
  GenerationEdit.Text := 'Generation '+IntToStr(FCurrGenerationIndex+1)+' of '+IntToStr(FMutationHistory.Count);
end;

function TMutaGenFrm.CreateBlankBitmap(const Width, Height: Integer): TBitmap;
begin
  Result := TBitmap.Create;
  Result.PixelFormat := pf32Bit;
  Result.Width  := Width;
  Result.Height := Height;
  Result.Canvas.Brush.Color := ColorToRGB(clBackground);
  Result.Canvas.FillRect(Rect(0,0, Width, Height));
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
  CurrSet: TMutationParamsSet;
  bmp: TBitmap;
begin
  if (FCurrGenerationIndex >= 0) and (FCurrGenerationIndex < FMutationHistory.Count) then begin
    CurrSet := TMutationParamsSet( FMutationHistory[FCurrGenerationIndex] );
    for I := 0 to FPanelList.Count-1 do begin
      Panel := FPanelList.GetPanel(I);
      bmp := CurrSet.Params[Panel.MutationIndex].Bitmap;
      if bmp = nil then
        bmp := CreateBlankBitmap(Panel.ImageWidth, Panel.ImageHeight);
      Panel.Bitmap := bmp;
      if Panel.MutationIndex = miP_1 then begin
        Panel.Panel.Caption := CurrSet.Params[Panel.MutationIndex].Params.UUID;
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

function TMutaGenFrm.CreatePreviewImage(const Panel: TMutaGenPanel; const Params: TMB3DParamsFacade): TBitmap;
begin
  if FPreviewImageRenderer <> nil then
    FreeAndNil(FPreviewImageRenderer);
  Result := TBitmap.Create;
  try
    FPreviewImageRenderer := TPreviewRenderer.Create(Params);
    try
      FPreviewImageRenderer.RenderPreview(Result, Panel.ImageWidth, Panel.ImageHeight );
    finally
      FreeAndNil( FPreviewImageRenderer );
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TMutaGenFrm.CreateProbingImage(Config: TMutationConfig; const Params: TMB3DParamsFacade): TBitmap;
begin
  if FProbingImageRenderer <> nil then
    FreeAndNil(FProbingImageRenderer);
  Result := TBitmap.Create;
  try
    FProbingImageRenderer := TPreviewRenderer.Create(Params);
    try
      FProbingImageRenderer.BlankBackground := True;
      FProbingImageRenderer.RenderPreview(Result, Config.ProbingWidth, Config.ProbingHeight );
    finally
      FreeAndNil( FProbingImageRenderer );
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure TMutaGenFrm.SignalCancel;
begin
  FForceAbort := True;
  if FPreviewImageRenderer<>nil then
    FPreviewImageRenderer.SignalCancel;
  if FProbingImageRenderer<>nil then
    FProbingImageRenderer.SignalCancel;
end;

procedure TCategoryPanel.DrawCollapsedPanel(ACanvas: TCanvas);
var
  LRect: TRect;
begin
  LRect := ClientRect;
  LRect.Top := HeaderHeight;
  LRect.Bottom := GetCollapsedHeight;
  ACanvas.Brush.Color := Color;
  ACanvas.FillRect(LRect);
end;

end.


