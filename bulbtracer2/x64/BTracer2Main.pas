unit BTracer2Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, JvExStdCtrls, JvGroupBox, Vcl.ExtCtrls,
  Contnrs, MeshIOUtil, BulbTracer2Config, ObjectScanner2x64;

type
  TThreadErrorStatus = packed record
    HasError: boolean;
    ErrorMessage: string;
  end;

  TBTracer2Frm = class(TForm)
    Panel2: TPanel;
    Label13: TLabel;
    Button1: TButton;
    CalculateBtn: TButton;
    ProgressBar: TProgressBar;
    CancelBtn: TButton;
    Panel1: TPanel;
    SmoothGBox: TJvGroupBox;
    Label11: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    TaubinSmoothLambaEdit: TEdit;
    TaubinSmoothLambaUpDown: TUpDown;
    TaubinSmoothMuEdit: TEdit;
    TaubinSmoothMuUpDown: TUpDown;
    TaubinSmoothPassesEdit: TEdit;
    TaubinSmoothPassesEditUpDown: TUpDown;
    LoadTraceDataBtn: TButton;
    PartsMemo: TMemo;
    OpenDialog: TOpenDialog;
    MeshReductionGBox: TJvGroupBox;
    Label25: TLabel;
    Label26: TLabel;
    MeshReductionRetainRatioEdit: TEdit;
    MeshReductionRetainRatioUpDown: TUpDown;
    MeshReductionAgressivenessEdit: TEdit;
    MeshReductionAgressivenessUpDown: TUpDown;
    FileOpenDialog: TFileOpenDialog;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LoadTraceDataBtnClick(Sender: TObject);
    procedure TaubinSmoothLambaUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TaubinSmoothMuUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TaubinSmoothPassesEditUpDownClick(Sender: TObject;
      Button: TUDBtnType);
    procedure FormCreate(Sender: TObject);
    procedure CalculateBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    T0: Int64;
    FCalculating, FForceAbort: boolean;
    FCurrFilename: string;
    FCurrMainHeader: TBTraceMainHeader;
    FThreadVertexLists, FThreadNormalsLists, FThreadColorsLists: TObjectList;
    FVertexGenConfig: TVertexGen2Config;
    FCalcThreadStats: TCalcThreadStats;
    FThreadErrorStatus: array[1..64] of TThreadErrorStatus;
    FCalcStop: LongBool;
    procedure MergeAndSaveMesh;
    procedure UpdateVertexGenConfig;
    procedure AnalyzeTraceData(const Filename: string);
    function GetOutputMeshFilename: string;
    procedure EnableControls;
    procedure FillPartsMemo;
  public
    { Public declarations }
  end;

var
  BTracer2Frm: TBTracer2Frm;

implementation

{$R *.dfm}

uses
  BulbTracerUITools, VertexList, DateUtils, Generics.Collections,
  MeshWriter, MeshReader, MeshSimplifier, IOUtils, Ole2;

const
  WM_ThreadReady = WM_USER + 1;
  WM_ThreadStat = WM_USER + 2;

type
  TPLYExportCalcThread = class(TThread)
    private
      FiThreadId: Integer;
      FOwner: TBTracer2Frm;
      FPrepared: Boolean;
      FObjectScanner: TObjectScanner2;
    protected
      procedure Prepare;
      procedure Execute; override;
    public
      FacesList: TFacesList;
      VertexGenConfig: TVertexGen2Config;
      destructor Destroy; override;
    end;


procedure TBTracer2Frm.Button1Click(Sender: TObject);
begin
  if not FCalculating then
    Close;
end;

function TBTracer2Frm.GetOutputMeshFilename: string;
var
  I: Integer;
  Filename, BasePath, BaseFilename: String;
begin
  Result := '';
  if PartsMemo.Lines.Count > 0 then begin
    Filename := PartsMemo.Lines[ 0 ];
    BasePath := ExtractFilePath( Filename );
    for I:=Length(BasePath) downto 1 do begin
      if BasePath[I] = '\' then begin
        BasePath := Copy( BasePath, 1, I - 1 );
        break;
      end;
    end;
    BaseFilename := ChangeFileExt(  ExtractFileName( BasePath ), '.obj' );
    Result :=  IncludeTrailingBackslash( TDirectory.GetParent(ExcludeTrailingPathDelimiter(BasePath)) ) + BaseFilename;
  end;
end;

procedure TBTracer2Frm.LoadTraceDataBtnClick(Sender: TObject);
begin
  //OpenDialog.DefaultExt := cBTracer2FileExt;
  //OpenDialog.Filter := 'BTracer2 Trace-Data (*.'+cBTracer2FileExt+')|*.'+cBTracer2FileExt;
  if FileOpenDialog.Execute(Self.Handle) then begin
    AnalyzeTraceData( FileOpenDialog.FileName );
    FillPartsMemo;
    EnableControls;
  end;
end;

procedure TBTracer2Frm.CancelBtnClick(Sender: TObject);
var
  I: Integer;
begin
// Dialog sucks
//  if FCalculating and (MessageDlg('Do you want to cancel?', mtConfirmation, mbYesNo, 0)=mrOK) then begin
    if FCalculating then begin
      try
        FForceAbort := True;
        with FCalcThreadStats do  begin
          for I := 1 to iTotalThreadCount do
            CTrecords[I].iDEAvrCount := -1;
        end;
      except
        // Hide error
      end;
    end;
//  end;
end;

procedure TBTracer2Frm.EnableControls;
var
  HasParts: boolean;
begin
  HasParts := ( PartsMemo.Lines.Count > 0 ) and ( Trim( PartsMemo.Text ) <> '' );
  CalculateBtn.Enabled := HasParts and ( not FCalculating );
end;

procedure TBTracer2Frm.FormCreate(Sender: TObject);
begin
  FCalcThreadStats.pLBcalcStop := @FCalcStop;

  FThreadVertexLists := TObjectList.Create;
  FThreadNormalsLists := TObjectList.Create;
  FThreadColorsLists := TObjectList.Create;
  FVertexGenConfig := TVertexGen2Config.Create;

  TaubinSmoothLambaEdit.Text := FloatToStr(0.42);
  TaubinSmoothMuEdit.Text := FloatToStr(-0.45);
  TaubinSmoothPassesEdit.Text := IntToStr(12);
  MeshReductionRetainRatioEdit.Text := FloatToStr(0.25);
  MeshReductionAgressivenessEdit.Text := FloatToStr(7.0);
end;

procedure TBTracer2Frm.FormDestroy(Sender: TObject);
begin
  FThreadVertexLists.Free;
  FThreadNormalsLists.Free;
  FThreadColorsLists.Free;
  FVertexGenConfig.Free;
end;

procedure TBTracer2Frm.FormShow(Sender: TObject);
begin
  EnableControls;
end;

procedure TBTracer2Frm.FillPartsMemo;
begin
  PartsMemo.Text := 'Analyzing file <' + FCurrFilename + '>:' + #13#10 +
                    '  Thread count: ' + IntToStr(FCurrMainHeader.ThreadCount) +#13#10 +
                    '  Resolution: ' + IntToStr(FCurrMainHeader.VResolution) +'*' + IntToStr(FCurrMainHeader.VResolution) + '*' + IntToStr(FCurrMainHeader.VResolution)+#13#10;
end;

procedure TBTracer2Frm.TaubinSmoothLambaUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(TaubinSmoothLambaEdit.Text, 0.0) + UpDownBtnValue(Button, 0.1);
  TaubinSmoothLambaEdit.Text := FloatToStr(Value);
end;

procedure TBTracer2Frm.TaubinSmoothMuUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(TaubinSmoothMuEdit.Text, 0.0) + UpDownBtnValue(Button, 0.1);
  TaubinSmoothMuEdit.Text := FloatToStr(Value);
end;

procedure TBTracer2Frm.TaubinSmoothPassesEditUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(TaubinSmoothPassesEdit.Text, 0.0) + UpDownBtnValue(Button, 1);
  if Value < 0 then
    Value := 0.0;
  TaubinSmoothPassesEdit.Text := IntToStr(Round(Value));
end;

procedure TBTracer2Frm.Timer1Timer(Sender: TObject);
var
  y, it: Integer;
  Progress: Integer;
  HasError: boolean;
  ErrorMessage: string;
begin
  Application.ProcessMessages;
  Timer1.Enabled := False;
  it := 0;
  Progress := 0;
  HasError := false;
  ErrorMessage := 'An error has occured';
  with FCalcThreadStats do begin
    for y := 1 to iTotalThreadCount do begin
      Progress := Progress + CTrecords[y].iActualYpos;
      if CTrecords[y].isActive <> 0 then Inc(it);
      if FThreadErrorStatus[y].HasError then begin
        FCalcThreadStats.pLBcalcStop^ := True;
        HasError := true;
        if Trim( FThreadErrorStatus[y].ErrorMessage ) <> '' then
          ErrorMessage := Trim( FThreadErrorStatus[y].ErrorMessage );
        it := 0;
        break;
      end;
    end;
  end;
  if it = 0 then begin
    try
      if not FCalcThreadStats.pLBcalcStop^ then  begin
        MergeAndSaveMesh;
        ProgressBar.Position := ProgressBar.Max;
      end;
      // OutMessage('Finished tracing object.');
    finally
      FCalculating := False;
      EnableControls;
    end;
    if HasError then
      raise Exception.Create(ErrorMessage);
  end
  else begin
    ProgressBar.Position := Progress;
    Timer1.Enabled := True;
  end;
end;

procedure TBTracer2Frm.AnalyzeTraceData(const Filename: string);
var
  I, J : Integer;
  TraceFilename: string;
  Header: TBTraceDataHeader;
begin
  FCurrFilename := Filename;
  LoadMainHeader(FCurrFilename, @FCurrMainHeader);
end;


procedure TBTracer2Frm.CalculateBtnClick(Sender: TObject);
var
  PLYCalcThreads: array of TPLYExportCalcThread;
  x, ThreadCount: Integer;
  d: Double;
begin
  if FCalculating then
    exit;
  FForceAbort := False;
  T0 := DateUtils.MilliSecondsBetween(Now, 0);
  // TODO
  UpdateVertexGenConfig;
  // TODO
  ThreadCount := FCurrMainHeader.ThreadCount;
  FThreadVertexLists.Clear;
  FThreadNormalsLists.Clear;
  FThreadColorsLists.Clear;
  // FSaveType := TMeshSaveType( SaveTypeCmb.ItemIndex );

  SetLength(PLYCalcThreads, ThreadCount);
  FCalcThreadStats.pMessageHwnd := Self.Handle;
  for x := 1 to ThreadCount do begin
    FCalcThreadStats.CTrecords[x].iActualYpos := -1;
    FCalcThreadStats.CTrecords[x].iActualXpos := 0;
    FCalcThreadStats.CTrecords[x].i64DEsteps  := 0;
    FCalcThreadStats.CTrecords[x].iDEAvrCount := 0;
    FCalcThreadStats.CTrecords[x].i64Its      := 0;
    FCalcThreadStats.CTrecords[x].iItAvrCount := 0;
    FCalcThreadStats.CTrecords[x].MaxIts      := 0;
    PLYCalcThreads[x - 1] := TPLYExportCalcThread.Create(True);
    PLYCalcThreads[x - 1].FOwner := Self;
    PLYCalcThreads[x - 1].FreeOnTerminate := True;
    // PLYCalcThreads[x - 1].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
    PLYCalcThreads[x - 1].VertexGenConfig := FVertexGenConfig;
    PLYCalcThreads[x - 1].FacesList      := TFacesList.Create;
    PLYCalcThreads[x - 1].FiThreadId := x;
    FThreadVertexLists.Add(PLYCalcThreads[x - 1].FacesList);
    FCalcThreadStats.CTrecords[x].isActive := 1;
  end;
  FCalcThreadStats.HandleType := 0;
  ProgressBar.Min := 0;
  ProgressBar.Position := 0;
  ProgressBar.Max := ThreadCount * 100;
  FCalcThreadStats.iTotalThreadCount := ThreadCount;
  FCalcThreadStats.cCalcTime         := GetTickCount;
  //vActiveThreads := ThreadCount;
  //PaintedYsofar := 0;
  for x := 0 to ThreadCount - 1 do PLYCalcThreads[x].Prepare;
  for x := 0 to ThreadCount - 1 do PLYCalcThreads[x].Start;
  Label13.Caption := 'Tracing object...';
  FCalculating := True;
  Timer1.Interval := 200;
  Timer1.Enabled := True;
end;

destructor TPLYExportCalcThread.Destroy;
begin
  if Assigned( FObjectScanner ) then
    FreeAndNil( FObjectScanner );
  inherited Destroy;
end;

procedure TPLYExportCalcThread.Prepare;
begin
  FOwner.FThreadErrorStatus[FiThreadId].HasError := False;
  try
    CoInitialize(nil);
    FObjectScanner := TParallelScanner2.Create(VertexGenConfig, FacesList, VertexGenConfig.SurfaceSharpness, 'D:\GFX\Mandelbulb3D\Meshes\mb3d_mesh.btracer2', @(FOwner.FCurrMainHeader), FiThreadId, @FOwner.FCalcThreadStats);
    FObjectScanner.ThreadIdx := FiThreadId - 1;
    FPrepared := True;
  except
    on E: Exception do begin
      FOwner.FThreadErrorStatus[FiThreadId].HasError := True;
      FOwner.FThreadErrorStatus[FiThreadId].ErrorMessage := E.Message;
    end;
  end;
end;

procedure TPLYExportCalcThread.Execute;
begin
  try
    try
      if FOwner.FThreadErrorStatus[FiThreadId].HasError then
        raise Exception.Create(FOwner.FThreadErrorStatus[FiThreadId].ErrorMessage);
      if not FPrepared then
        raise Exception.Create('Call Prepare First');
      FObjectScanner.Scan;
    except
      on E: Exception do begin
        FOwner.FThreadErrorStatus[FiThreadId].HasError := True;
        FOwner.FThreadErrorStatus[FiThreadId].ErrorMessage := E.Message;
        raise;
      end;
    end;
  finally
    FOwner.FCalcThreadStats.CTrecords[FiThreadID].isActive := 0;
    PostMessage(FOwner.FCalcThreadStats.pMessageHwnd, WM_ThreadReady, 0, 0);
  end;
end;

procedure TBTracer2Frm.UpdateVertexGenConfig;
var
  VRes: Integer;
begin
  FVertexGenConfig.Clear;

  FVertexGenConfig.RemoveDuplicates := True;

  FVertexGenConfig.SurfaceSharpness := 1.25; // StrToFloat(SurfaceSharpnessEdit.Text);
  FVertexGenConfig.CalcColors := True; // CalculateColorsCBx.Checked;

  VRes := FCurrMainHeader.VResolution ;
  FVertexGenConfig.URange.StepCount := VRes;
  FVertexGenConfig.VRange.StepCount := VRes;

  FVertexGenConfig.URange.StepCount := VRes;
  FVertexGenConfig.VRange.StepCount := VRes;
end;

procedure TBTracer2Frm.MergeAndSaveMesh;
const
  MergeRatio = 0.25;
var
  FacesList: TFacesList;
  MaxVerticeCount, MaxFaces: Integer;
begin
  try
    if (not FForceAbort) (* or (FCancelType = ctCancelAndShowResult) *) then begin
      FacesList := TFacesList.MergeFacesLists( FThreadVertexLists );
      try
        FacesList.DoCenter(1.0);
        (*
        MaxFaces := Round( FacesList.Count * MergeRatio );
        if FacesList.Count > MaxFaces then begin
          with TMeshSimplifier.Create(FacesList) do try
            SimplifyMesh( MaxFaces, 5.0 );
          finally
            Free;
          end;
        end;
          *)

          with TMeshSimplifier.Create(FacesList) do try
            SimplifyMeshLossless(0.00001);
          finally
            Free;
          end;


        if not FForceAbort then begin
          TPlyFileWriter.SaveToFile('D:\GFX\Mandelbulb3D\Meshes\mb3d_mesh2_x64.ply', FacesList);
(*
          if FSaveType = stMeshAsObj then
            TObjFileWriter.SaveToFile(MakeMeshSequenceFilename( FilenameREd.Text ), FacesList)
          else if FSaveType = stMeshAsPly then
            TPlyFileWriter.SaveToFile(MakeMeshSequenceFilename( FilenameREd.Text ), FacesList);
*)
        end;
        FThreadVertexLists.Clear;
        OutputDebugString(PChar('TOTAL: '+IntToStr(DateUtils.MilliSecondsBetween(Now, 0)-T0)+' ms'));
        if not FForceAbort then
          Label13.Caption := 'Elapsed time: ' + IntToStr(Round((DateUtils.MilliSecondsBetween(Now, 0)-T0)/1000.0))+' s';
      finally
        FacesList.Free;
      end;
    end;
  finally
    FThreadVertexLists.Clear;
  end;
  if not FForceAbort then
    Label13.Caption := 'Elapsed time: ' + IntToStr(Round((DateUtils.MilliSecondsBetween(Now, 0)-T0)/1000.0))+' s'
  else
    Label13.Caption := 'Operation cancelled';
end;


end.


