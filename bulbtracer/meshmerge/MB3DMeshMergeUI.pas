unit MB3DMeshMergeUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  JvExStdCtrls, JvGroupBox, Vcl.ExtCtrls, Contnrs;

type
  TMB3DMeshMergeFrm = class(TForm)
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
    LoadPartsBtn: TButton;
    PartsMemo: TMemo;
    OpenDialog: TOpenDialog;
    MeshReductionGBox: TJvGroupBox;
    Label25: TLabel;
    Label26: TLabel;
    MeshReductionRetainRatioEdit: TEdit;
    MeshReductionRetainRatioUpDown: TUpDown;
    MeshReductionAgressivenessEdit: TEdit;
    MeshReductionAgressivenessUpDown: TUpDown;
    procedure Button1Click(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure CalculateBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LoadPartsBtnClick(Sender: TObject);
    procedure TaubinSmoothLambaUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TaubinSmoothMuUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TaubinSmoothPassesEditUpDownClick(Sender: TObject;
      Button: TUDBtnType);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FCalculating, FForceAbort: boolean;
    function GetOutputMeshFilename: string;
    procedure EnableControls;
    procedure FillPartsMemo( const Filename: string );
    function ReadParts: TObjectList;
  public
    { Public declarations }
  end;

var
  MB3DMeshMergeFrm: TMB3DMeshMergeFrm;

implementation

{$R *.dfm}

uses
  BulbTracerUITools, VertexList, DateUtils, Generics.Collections,
  MeshWriter, MeshReader,  MeshIOUtil, MeshSimplifier, IOUtils;

procedure TMB3DMeshMergeFrm.Button1Click(Sender: TObject);
begin
  if not FCalculating then
    Close;
end;

function TMB3DMeshMergeFrm.GetOutputMeshFilename: string;
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

procedure TMB3DMeshMergeFrm.LoadPartsBtnClick(Sender: TObject);
begin
  OpenDialog.DefaultExt := cMB3DMeshSegFileExt;
  OpenDialog.Filter := 'Mesh Part (*.lwo)|*.lwo';
  if OpenDialog.Execute(Self.Handle) then
    FillPartsMemo( OpenDialog.FileName );
end;

procedure TMB3DMeshMergeFrm.CalculateBtnClick(Sender: TObject);
const
  MergeRatio: Single = 0.1;
var
  T0: Int64;
  FacesList: TFacesList;
  DoPostProcessing: Boolean;
  FThreadVertexLists: TObjectList;
  MaxFaces: Integer;
begin
  FCalculating := True;
  try
    ProgressBar.Max := 5;
    ProgressBar.Step := 0;
    EnableControls;
    T0 := DateUtils.MilliSecondsBetween(Now, 0);
    FThreadVertexLists := ReadParts;
    ProgressBar.StepIt;
    try
      FacesList := TFacesList.MergeFacesLists( FThreadVertexLists, False );
      ProgressBar.StepIt;
      try
        DoPostProcessing := SmoothGBox.Checked;
        FacesList.DoCenter(1.0);

        MaxFaces := Round( FacesList.Count * MergeRatio );
        if FacesList.Count > MaxFaces then begin
          with TMeshSimplifier.Create(FacesList) do try
            SimplifyMesh( MaxFaces );
          finally
            Free;
          end;
        end;

        ProgressBar.StepIt;
        if SmoothGBox.Checked then begin
          FacesList.TaubinSmooth(StrToFloat(TaubinSmoothLambaEdit.Text), StrToFloat(TaubinSmoothMuEdit.Text), StrToInt(TaubinSmoothPassesEdit.Text));
        end;
        ProgressBar.StepIt;
        if not FForceAbort then begin
//          TLightwaveObjFileWriter.SaveToFile(GetOutputMeshFilename, FacesList);
          TObjFileWriter.SaveToFile(GetOutputMeshFilename, FacesList);
        end;
        ProgressBar.StepIt;
        FThreadVertexLists.Clear;
      finally
        FacesList.Free;
      end;
    finally
      FThreadVertexLists.Free;
    end;
    OutputDebugString(PChar('TOTAL: '+IntToStr(DateUtils.MilliSecondsBetween(Now, 0)-T0)+' ms'));
    if not FForceAbort then
      Label13.Caption := 'Elapsed time: ' + IntToStr(Round((DateUtils.MilliSecondsBetween(Now, 0)-T0)/1000.0))+' s';
  finally
    FCalculating := False;
    EnableControls;
  end;
end;

procedure TMB3DMeshMergeFrm.CancelBtnClick(Sender: TObject);
begin
  if FCalculating and (MessageDlg('Do you want to cancel?', mtConfirmation, mbYesNo, 0)=mrOK) then begin
    if FCalculating then begin
      FForceAbort := True;
    end;
  end;
end;

procedure TMB3DMeshMergeFrm.EnableControls;
var
  HasParts: boolean;
begin
  HasParts := ( PartsMemo.Lines.Count > 0 ) and ( Trim( PartsMemo.Text ) <> '' );
  CalculateBtn.Enabled := HasParts and ( not FCalculating );
end;

procedure TMB3DMeshMergeFrm.FormCreate(Sender: TObject);
begin
  TaubinSmoothLambaEdit.Text := FloatToStr(0.42);
  TaubinSmoothMuEdit.Text := FloatToStr(-0.45);
  TaubinSmoothPassesEdit.Text := IntToStr(12);
  MeshReductionRetainRatioEdit.Text := FloatToStr(0.25);
  MeshReductionAgressivenessEdit.Text := FloatToStr(7.0);
end;

procedure TMB3DMeshMergeFrm.FormShow(Sender: TObject);
begin
  EnableControls;
end;

procedure TMB3DMeshMergeFrm.FillPartsMemo( const Filename: string );
var
  BasePath, BaseFilename, CurrFilename: string;
  I: integer;
begin
  // mb3d_mesh_03.lwo
  BasePath := ExtractFilePath(  Filename );
  BaseFilename := ChangeFileExt( ExtractFileName( Filename ), '' );
  for I := Length( BaseFilename ) downto 1 do begin
    if BaseFilename[ I ] = '_' then begin
      BaseFilename := Copy( BaseFilename, 1, I - 1 );
      break;
    end;
  end;

  PartsMemo.Lines.Clear;
  EnableControls;
  I:=0;
  while( True ) do begin
    CurrFilename := IncludeTrailingBackslash( BasePath ) + TUnprocessedMeshFileWriter.CreatePartFilename( I );
    if FileExists( CurrFilename ) then
      PartsMemo.Lines.Add( CurrFilename )
    else
      break;
    Inc( I );
  end;
  EnableControls;
end;

procedure TMB3DMeshMergeFrm.TaubinSmoothLambaUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(TaubinSmoothLambaEdit.Text, 0.0) + UpDownBtnValue(Button, 0.1);
  TaubinSmoothLambaEdit.Text := FloatToStr(Value);
end;

procedure TMB3DMeshMergeFrm.TaubinSmoothMuUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(TaubinSmoothMuEdit.Text, 0.0) + UpDownBtnValue(Button, 0.1);
  TaubinSmoothMuEdit.Text := FloatToStr(Value);
end;

procedure TMB3DMeshMergeFrm.TaubinSmoothPassesEditUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(TaubinSmoothPassesEdit.Text, 0.0) + UpDownBtnValue(Button, 1);
  if Value < 0 then
    Value := 0.0;
  TaubinSmoothPassesEdit.Text := IntToStr(Round(Value));
end;

{ ---------------------------- TLoadPartThread ------------------------------- }
type
  TLoadPartThread = class(TThread)
  private
    FDone: boolean;
    FFilename: string;
    FFacesList: TFacesList;
    procedure ReadPart;
  public
    constructor Create( const Filename: string; FacesList: TFacesList );
  protected
    procedure Execute; override;
    function IsDone: boolean;
  end;

constructor TLoadPartThread.Create( const Filename: string; FacesList: TFacesList );
begin
  inherited Create( True );
  FFilename := Filename;
  FFacesList := FacesList;
end;

procedure TLoadPartThread.Execute;
begin
  ReadPart;
end;

procedure TLoadPartThread.ReadPart;
const
  HeaderMaxSize = 20;
var
  I: integer;
  Reader: TLightwaveObjFileReader;
begin
  FDone := false;
  try
    with TLightwaveObjFileReader.Create do try
      LoadFromFile( FFilename, FFacesList );
    finally
      Free;
    end;
  finally
    FDone := true;
  end;
end;

function TLoadPartThread.IsDone: boolean;
begin
  Result := FDone;
end;
{ ---------------------------- TLoadPartThread ------------------------------- }
function TMB3DMeshMergeFrm.ReadParts: TObjectList;
var
  I: integer;
  IsDone: boolean;
  CurrFacesList: TFacesList;
  CurrThread: TLoadPartThread;
  Threads: TObjectList;
begin
  Result := TObjectList.Create;
  try
    Threads := TObjectList.Create.Create;
    try
      for I := 0 to PartsMemo.Lines.Count - 1 do begin
        CurrFacesList := TFacesList.Create;
        Result.Add( CurrFacesList );
        CurrThread := TLoadPartThread.Create(  PartsMemo.Lines[I], CurrFacesList );
        Threads.Add( CurrThread );
        CurrThread.Start;
      end;
      IsDone := false;
      while( not IsDone ) do begin
        IsDone := true;
        for I := 0 to Threads.Count - 1 do begin
          if( not TLoadPartThread(Threads[I]).IsDone ) then begin
            IsDone := false;
            break;
          end;
          Sleep(10);
        end;
      end;
    finally
      Threads.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;



end.


