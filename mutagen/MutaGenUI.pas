unit MutaGenUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, JvExForms,
  JvCustomItemViewer, JvImagesViewer, JvComponentBase, JvFormAnimatedIcon, MutaGen,
  Vcl.ComCtrls, JvExComCtrls, JvProgressBar;

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
    GridPanel1: TGridPanel;
    ProgressBar: TProgressBar;
    MutateBtn: TButton;
    procedure MutateBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure MainPnlResize(Sender: TObject);
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
  public
    { Public declarations }
  end;

var
  MutaGenFrm: TMutaGenFrm;

implementation

{$R *.dfm}
uses
  Mand, MB3DFacade, PreviewRenderer, TypeDefinitions, CustomFormulas, Contnrs, Math;

const
  MUTAGEN_SIZE = 5;

procedure TMutaGenFrm.FormCreate(Sender: TObject);
begin
  FMutationHistory := TObjectList.Create;
  FPanelList := CreatePanelList;
  FPanelList.DoLayout;
  RefreshMutateButtonCaption;
  InitProgress;
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
  FP_1 := TMutaGenPanel.Create(nil, 0.0, -1.0, PnlXSize, PnlYSize, '1', Panel_1, Image_1);
  Result.AddPanel(FP_1);
    FP_1_1 := TMutaGenPanel.Create(FP_1, -0.5, 0.0, PnlXSize, PnlYSize, '1', Panel_1_1, Image_1_1);
    Result.AddPanel(FP_1_1);
      FP_1_1_1 := TMutaGenPanel.Create(FP_1_1, -1.5, -0.5, PnlXSize, PnlYSize, '1', Panel_1_1_1, Image_1_1_1);
      Result.AddPanel(FP_1_1_1);
        FP_1_1_1_1 := TMutaGenPanel.Create(FP_1_1_1, -2.0, -1.5, PnlXSize, PnlYSize, '1', Panel_1_1_1_1, Image_1_1_1_1);
        Result.AddPanel(FP_1_1_1_1);
        FP_1_1_1_2 := TMutaGenPanel.Create(FP_1_1_1, -1.0, -1.5, PnlXSize, PnlYSize, '2', Panel_1_1_1_2, Image_1_1_1_2);
        Result.AddPanel(FP_1_1_1_2);
      FP_1_1_2 := TMutaGenPanel.Create(FP_1_1, -1.5, 0.5, PnlXSize, PnlYSize, '2', Panel_1_1_2, Image_1_1_2);
      Result.AddPanel(FP_1_1_2);
        FP_1_1_2_1 := TMutaGenPanel.Create(FP_1_1_2, -2.0, 1.5, PnlXSize, PnlYSize, '1', Panel_1_1_2_1, Image_1_1_2_1);
        Result.AddPanel(FP_1_1_2_1);
        FP_1_1_2_2 := TMutaGenPanel.Create(FP_1_1_2, -1.0, 1.5, PnlXSize, PnlYSize, '2', Panel_1_1_2_2, Image_1_1_2_2);
        Result.AddPanel(FP_1_1_2_2);
    FP_1_2 := TMutaGenPanel.Create(FP_1, 0.5, 0.0, PnlXSize, PnlYSize, '2', Panel_1_2, Image_1_2);
    Result.AddPanel(FP_1_2);
      FP_1_2_1 := TMutaGenPanel.Create(FP_1_2, 1.5, -0.5, PnlXSize, PnlYSize, '1', Panel_1_2_1, Image_1_2_1);
      Result.AddPanel(FP_1_2_1);
        FP_1_2_1_1 := TMutaGenPanel.Create(FP_1_2_1, 1.0, -1.5, PnlXSize, PnlYSize, '1', Panel_1_2_1_1, Image_1_2_1_1);
        Result.AddPanel(FP_1_2_1_1);
        FP_1_2_1_2 := TMutaGenPanel.Create(FP_1_2_1, 2.0, -1.5, PnlXSize, PnlYSize, '2', Panel_1_2_1_2, Image_1_2_1_2);
        Result.AddPanel(FP_1_2_1_2);
      FP_1_2_2 := TMutaGenPanel.Create(FP_1_2, 1.5, 0.5, PnlXSize, PnlYSize, '2', Panel_1_2_2, Image_1_2_2);
      Result.AddPanel(FP_1_2_2);
        FP_1_2_2_1 := TMutaGenPanel.Create(FP_1_2_2, 1.0, 1.5, PnlXSize, PnlYSize, '1', Panel_1_2_2_1, Image_1_2_2_1);
        Result.AddPanel(FP_1_2_2_1);
        FP_1_2_2_2 := TMutaGenPanel.Create(FP_1_2_2, 2.0, 1.5, PnlXSize, PnlYSize, '2', Panel_1_2_2_2, Image_1_2_2_2);
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

procedure TMutaGenFrm.MutateBtnClick(Sender: TObject);
const
  MutationStrength = 1.0;
var

  CurrSet: TMutationParamSet;

  function GetMutations: TList;
  var
    Mutation: TMutation;
  begin
    Result := TObjectList.Create;

    Mutation := TAddFormulaMutation.Create;
    Mutation.LocalStrength := 1.0;
    Result.Add(Mutation);

    Mutation := TReplaceFormulaMutation.Create;
    Mutation.LocalStrength := 1.0;
    Result.Add(Mutation);

    Mutation := TModifySingleParamMutation.Create;
    Mutation.LocalStrength := 1.0;
    Result.Add(Mutation);
  end;

  function CreateMutation(const Params: TMB3DParamsFacade; const GlobalStrength: Double): TMB3DParamsFacade;
  var
    I: Integer;
    Mutations: TList;
  begin
    Mutations := GetMutations;
    try
      Result := Params;
      for I := 0 to Mutations.Count-1 do begin
        Result := TMutation(Mutations[I]).CreateMutation(Result, GlobalStrength);
      end;
    finally
      Mutations.Free;
    end;
  end;

  procedure RenderParams(const Panel: TMutaGenPanel; const Params: TMB3DParamsFacade);
  var
    MB3DPreviewRenderer: TPreviewRenderer;
    bmp: TBitmap;
  begin
    MB3DPreviewRenderer := TPreviewRenderer.Create(Params);
    try
      bmp := TBitmap.Create;
      MB3DPreviewRenderer.RenderPreview(bmp, Panel.ImageWidth, Panel.ImageHeight);
      Panel.Image := bmp;
    finally
      MB3DPreviewRenderer.Free;
    end;
  end;


begin
  if FIsRunning then begin
    FForceAbort := True;
    Exit;
  end;

  FIsRunning := True;
  try
    RefreshMutateButtonCaption;
    FForceAbort := False;
    CurrSet := TMutationParamSet.Create;
    FMutationHistory.Add(CurrSet);

    InitProgress;

    CurrSet.P_1 := TMB3DParamsFacade.Create(Mand3DForm.MHeader, Mand3DForm.HAddOn);
    RenderParams(FP_1, CurrSet.P_1);
    ProgressStep;
    if FForceAbort then
      Exit;

    CurrSet.P_1_1 := CreateMutation(CurrSet.P_1, MutationStrength);
    RenderParams(FP_1_1, CurrSet.P_1_1);
    ProgressStep;
    if FForceAbort then
      Exit;

    CurrSet.P_1_2 := CreateMutation(CurrSet.P_1, MutationStrength);
    RenderParams(FP_1_2, CurrSet.P_1_2);
    ProgressStep;
    if FForceAbort then
      Exit;

    CurrSet.P_1_1_1 := CreateMutation(CurrSet.P_1_1, MutationStrength);
    RenderParams(FP_1_1_1, CurrSet.P_1_1_1);
    ProgressStep;
    if FForceAbort then
      Exit;

    CurrSet.P_1_2_1 := CreateMutation(CurrSet.P_1_2, MutationStrength);
    RenderParams(FP_1_2_1, CurrSet.P_1_2_1);
    ProgressStep;
    if FForceAbort then
      Exit;

    CurrSet.P_1_1_2 := CreateMutation(CurrSet.P_1_1, MutationStrength);
    RenderParams(FP_1_1_2, CurrSet.P_1_1_2);
    ProgressStep;
    if FForceAbort then
      Exit;

    CurrSet.P_1_2_2 := CreateMutation(CurrSet.P_1_2, MutationStrength);
    RenderParams(FP_1_2_2, CurrSet.P_1_2_2);
    ProgressStep;
    if FForceAbort then
      Exit;

    CurrSet.P_1_1_1_1 := CreateMutation(CurrSet.P_1_1_1, MutationStrength);
    RenderParams(FP_1_1_1_1, CurrSet.P_1_1_1_1);
    ProgressStep;
    if FForceAbort then
      Exit;

    CurrSet.P_1_1_2_1 := CreateMutation(CurrSet.P_1_1_2, MutationStrength);
    RenderParams(FP_1_1_2_1, CurrSet.P_1_1_2_1);
    ProgressStep;
    if FForceAbort then
      Exit;

    CurrSet.P_1_2_1_1 := CreateMutation(CurrSet.P_1_2_1, MutationStrength);
    RenderParams(FP_1_2_1_1, CurrSet.P_1_2_1_1);
    ProgressStep;
    if FForceAbort then
      Exit;

    CurrSet.P_1_2_2_1 := CreateMutation(CurrSet.P_1_2_2, MutationStrength);
    RenderParams(FP_1_2_2_1, CurrSet.P_1_2_2_1);
    ProgressStep;
    if FForceAbort then
      Exit;

    CurrSet.P_1_1_1_2 := CreateMutation(CurrSet.P_1_1_1, MutationStrength);
    RenderParams(FP_1_1_1_2, CurrSet.P_1_1_1_2);
    ProgressStep;
    if FForceAbort then
      Exit;

    CurrSet.P_1_1_2_2 := CreateMutation(CurrSet.P_1_1_2, MutationStrength);
    RenderParams(FP_1_1_2_2, CurrSet.P_1_1_2_2);
    ProgressStep;
    if FForceAbort then
      Exit;

    CurrSet.P_1_2_1_2 := CreateMutation(CurrSet.P_1_2_1, MutationStrength);
    RenderParams(FP_1_2_1_2, CurrSet.P_1_2_1_2);
    ProgressStep;
    if FForceAbort then
      Exit;

    CurrSet.P_1_2_2_2 := CreateMutation(CurrSet.P_1_2_2, MutationStrength);
    RenderParams(FP_1_2_2_2, CurrSet.P_1_2_2_2);
    ProgressStep;
    if FForceAbort then
      Exit;
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


end.
