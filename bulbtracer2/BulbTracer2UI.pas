(*
  BulbTracer2 for MB3D
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
unit BulbTracer2UI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, TypeDefinitions, ComCtrls,
  Contnrs, VertexList, BulbTracer2Config, Vcl.Tabs, BulbTracerUITools,
  JvExStdCtrls, JvGroupBox, TrackBarEx, ObjectScanner2, Generics.Collections,
  SyncObjs, MeshIOUtil;

type
  TParamSource = (psMain, psSingleFile);

  TThreadErrorStatus = packed record
    HasError: boolean;
    ErrorMessage: string;
  end;


  TBulbTracer2Frm = class(TForm)
    SaveDialog: TSaveDialog;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    Panel1: TPanel;
    BTracer2FileOpenDialog: TOpenDialog;
    ImportParamsFromMainBtn: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    XOffsetEdit: TEdit;
    YOffsetEdit: TEdit;
    ZOffsetEdit: TEdit;
    ResetOffsetAndScaleBtn: TButton;
    ScaleEdit: TEdit;
    GroupBox2: TGroupBox;
    SelectOutputFilenameBtn: TButton;
    FilenameREd: TEdit;
    Label18: TLabel;
    MeshVResolutionLbl: TLabel;
    Label23: TLabel;
    MeshVResolutionEdit: TEdit;
    SurfaceSharpnessEdit: TEdit;
    SurfaceSharpnessUpDown: TUpDown;
    MeshVResolutionUpDown: TUpDown;
    CalculateColorsCBx: TCheckBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    OpenGLPreviewCBx: TCheckBox;
    MeshPreviewBtn: TButton;
    Label5: TLabel;
    MaxVerticeCountEdit: TEdit;
    GroupBox6: TGroupBox;
    Panel2: TPanel;
    ProgressBar: TProgressBar;
    CloseButton: TButton;
    Label13: TLabel;
    CalculateBtn: TButton;
    CancelTypeCmb: TComboBox;
    Label19: TLabel;
    CancelBtn: TButton;
    SaveTypeCmb: TComboBox;
    Label10: TLabel;
    Panel3: TPanel;
    Image1: TImage;
    IncXOffsetBtn: TSpeedButton;
    DecXOffsetBtn: TSpeedButton;
    IncYOffsetBtn: TSpeedButton;
    DecYOffsetBtn: TSpeedButton;
    IncZOffsetBtn: TSpeedButton;
    DecZOffsetBtn: TSpeedButton;
    ScaleDownBtn: TSpeedButton;
    ScaleUpBtn: TSpeedButton;
    PreviewProgressBar: TProgressBar;
    VoxelPreviewSizeGrp: TRadioGroup;
    AutoCalcPreviewCbx: TCheckBox;
    RefreshPreviewBtn: TButton;
    Label6: TLabel;
    XRotateEdit: TEdit;
    YRotateEdit: TEdit;
    ZRotateEdit: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    EditModeCmb: TComboBox;
    PreviewDEAdjust: TEdit;
    Label12: TLabel;
    PreviewDEAdjustUpDown: TUpDown;
    TraceXMaxEdit: TEdit;
    Label14: TLabel;
    TraceXMinEdit: TEdit;
    Label15: TLabel;
    LoadBTracer2FileBtn: TButton;
    SaveBTracer2FileBtn: TButton;
    OpenDialog2: TOpenDialog;
    BTracer2FileSaveDialog: TSaveDialog;
    TraceYMinEdit: TEdit;
    TraceYMaxEdit: TEdit;
    TraceZMinEdit: TEdit;
    TraceZMaxEdit: TEdit;
    Label16: TLabel;
    CloseMeshCheckbox: TCheckBox;
    OpenGLPreviewCheckbox: TCheckBox;
    PreviewTimer: TTimer;
    OpenGLPreviewIndicatorTimer: TTimer;
    OpenGLPreviewSizeGrp: TRadioGroup;
    XOffsetUpDown: TUpDown;
    YOffsetUpDown: TUpDown;
    ZOffsetUpDown: TUpDown;
    ScaleEditUpDown: TUpDown;
    XRotateUpDown: TUpDown;
    YRotateUpDown: TUpDown;
    ZRotateUpDown: TUpDown;
    TraceXMaxUpDown: TUpDown;
    TraceYMaxUpDown: TUpDown;
    TraceZMaxEditUpDown: TUpDown;
    TraceXMinEditUpDown: TUpDown;
    TraceYMinEditUpDown: TUpDown;
    TraceZMinUpDown: TUpDown;
    procedure CloseButtonClick(Sender: TObject);
    procedure ImportParamsFromMainBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure XOffsetEditChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure RefreshPreviewBtnClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure UpDown5Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown6Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown7Click(Sender: TObject; Button: TUDBtnType);
    procedure Timer3Timer(Sender: TObject);
    procedure Edit10Change(Sender: TObject);
    procedure ResetOffsetAndScaleBtnClick(Sender: TObject);
    procedure CalculateBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MeshPreviewBtnClick(Sender: TObject);
    procedure VoxelPreviewSizeGrpClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure SaveTypeCmbChange(Sender: TObject);
    procedure CancelTypeCmbChange(Sender: TObject);
    procedure MeshVResolutionEditChange(Sender: TObject);
    procedure SelectOutputFilenameBtnClick(Sender: TObject);
    procedure SurfaceSharpnessUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure Button2Click(Sender: TObject);
    procedure IncXOffsetBtnClick(Sender: TObject);
    procedure IncYOffsetBtnClick(Sender: TObject);
    procedure IncZOffsetBtnClick(Sender: TObject);
    procedure ScaleDownBtnClick(Sender: TObject);
    procedure OpenGLPreviewCBxClick(Sender: TObject);
    procedure PreviewDEAdjustUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure SaveBTracer2FileBtnClick(Sender: TObject);
    procedure LoadBTracer2FileBtnClick(Sender: TObject);
    procedure OpenGLPreviewCheckboxClick(Sender: TObject);
    procedure PreviewTimerTimer(Sender: TObject);
    procedure SurfaceSharpnessEditExit(Sender: TObject);
    procedure TraceXMinEditExit(Sender: TObject);
    procedure TraceXMaxEditExit(Sender: TObject);
    procedure TraceYMinEditExit(Sender: TObject);
    procedure TraceYMaxEditExit(Sender: TObject);
    procedure TraceZMaxEditExit(Sender: TObject);
    procedure CloseMeshCheckboxClick(Sender: TObject);
    procedure OpenGLPreviewIndicatorTimerTimer(Sender: TObject);
    procedure TraceZMinEditExit(Sender: TObject);
    procedure XOffsetUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure YOffsetUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure ZOffsetUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure ScaleEditUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure XRotateUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure YRotateUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure ZRotateUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure MeshVResolutionUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TraceXMinEditUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TraceXMaxUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TraceYMinEditUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TraceYMaxUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TraceZMinUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TraceZMaxEditUpDownClick(Sender: TObject; Button: TUDBtnType);
  private
    { Private-Deklarationen }
  //  PreviewVoxel: array of Cardinal;   //buffer to not calc everything again if shifted position
    T0: Int64;
    PVwid, PVhei, PVdep: Integer;
    VCalcThreadStats: TCalcThreadStats;
    ThreadErrorStatus: array[1..64] of TThreadErrorStatus;
    PaintedYsofar, vActiveThreads, PreviewSize: Integer;
    CalcPreview{, PrCalcedAll}: LongBool; //to verify if PreviewVoxel array is complete
    VsiLight: array of Cardinal;  //just 0..255 for color
    FThreadVertexLists, FThreadNormalsLists, FThreadColorsLists: TObjectList;
    FSavePartIdx: Integer;
    FSaveType: TMeshSaveType;
    FVertexGenConfig: TVertexGen2Config;
    FCalculating, FForceAbort, FCalculatingPreview: Boolean;
    FCancelType: TCancelType;
    FRefreshing: Boolean;
    FSavePartCriticalSection: TCriticalSection;
    FOpenGLPreviewIndicator: integer;
    procedure ClearClassicPreview;
    procedure UpdateBTracer2HeaderFromUI;
    procedure UpdateUIFromBTracer2Header;
    procedure CalcImageSize;
    function StartSlicePreview(nr: Integer): LongBool;
    procedure PaintNextPreviewSlice(nr: Integer);
    procedure SetProjectName(FileName: String);
    procedure StartNewPreview;
    function  CalcVoxelPreviewSize: Integer;
    procedure CalcVoxelPreviewSizes;
    function  CalcOpenGLPreviewSize: Integer;

    function StartPLYRender(const ForPreview: boolean): LongBool;
    procedure MergeAndSaveMesh;
    procedure UpdateVertexGenConfig;
    procedure SaveMesh;
    procedure ShowPreviewMesh;
    procedure CancelPreview;
    procedure ShowTitle(const Caption: String);
    procedure StartCalc(const ForPreview: boolean);
    procedure SetExportFilenameExt;
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure WmThreadReady(var Msg: TMessage); message WM_ThreadReady;
  public
    { Public-Deklarationen }
    FParamSource: TParamSource;
    FParamFilename: String;
    FParamSequenceBaseFilename: String;
    FParamSequenceFileExt: String;
    FParamSequencePatternLength: Integer;
    FParamSequenceFrom: Integer;
    FParamSequenceTo: Integer;
    FParamSequenceCurrFrame: Integer;
    VHeader: TMandHeader10;
    VHAddon: THeaderCustomAddon;
    BTracer2Header: TBTracer2Header;
    bUserChange, bFirstShow, Benabled: LongBool;
    OutputFolder, VProjectName: String;
    FileNumber: Integer;
    HybridCustoms: array[0..5] of TCustomFormula;
    FLogger: TAbstractLogger;
    procedure UpdatePreviewSizeGrp;
    procedure EnableControls(const Enabled: Boolean);
    procedure ImportParams(const KeepScaleAndPosition: Boolean = True);
  end;

  TFVoxelExportCalcPreviewThread = class(TThread)
  private
    FOwner: TBulbTracer2Frm;
    { Private-Deklarationen }
    Iteration3Dext: TIteration3Dext;
  public
    { Public-Deklarationen }
    MCTparas: TMCTparameter;
  protected
    procedure Execute; override;
  end;


  TPLYExportCalcThread = class(TThread)
  private
    FOwner: TBulbTracer2Frm;
    FPrepared: Boolean;
    FObjectScanner: TObjectScanner2;
  protected
    procedure Prepare(const ForPreview: boolean);
    procedure Execute; override;
  public
    BTracer2Header: TBTracer2Header;
    MCTparas: TMCTparameter;
    FacesList: TFacesList;
    VertexGenConfig: TVertexGen2Config;
    destructor Destroy; override;
  end;
var
  BulbTracer2Frm: TBulbTracer2Frm;
  iVoxelVersion: Integer = 4;
  bBulbTracerFormCreated: LongBool = False;

implementation

uses CalcVoxelSliceThread, FileHandling, Math, Math3D, Calc, DivUtils, Mand,
  HeaderTrafos, CustomFormulas, ImageProcess, VectorMath, DateUtils, BulbTracer2,
  MeshPreviewUI, MeshWriter, MeshReader, Ole2, Clipbrd;

{$R *.dfm}

const
  OpenGLWindowTitleMesh = 'Generated Mesh';
  OpenGLWindowTitleBTracer2Preview = 'BTracer2 Preview';

procedure TBulbTracer2Frm.CloseButtonClick(Sender: TObject);
begin
    Visible := False;
end;

procedure TFVoxelExportCalcPreviewThread.Execute;
var d: Double;
    CC: TVec3D;
    cLi: PCardinal;
    x, y: Integer;
    AvgDEstop: double;
begin
    AvgDEstop := FOwner.BTracer2Header.PreviewDEstop;
    with MCTparas do
      try
      IniIt3D(@MCTparas, @Iteration3Dext);
      y := CalcRect.Top + iThreadId - 1;
      while y <= CalcRect.Bottom do
      begin
        cLi := PCardinal(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset);
        mCopyAddVecWeight(@CC, @Ystart, @Vgrads[1], y);
        for x := 0 to CalcRect.Right do begin
          Iteration3Dext.CalcSIT := False;
          mCopyAddVecWeight(@Iteration3Dext.C1, @CC, @Vgrads[0], x);
          begin
            d := CalcDE(@Iteration3Dext, @MCTparas);   //in+outside: only if d between dmin and dmax
            if d < AvgDEstop then
              cLi^ := 1
            else
              cLi^ := 0;
          end;
        Inc(cLi);
          if PCalcThreadStats^.pLBcalcStop^ then Break;
        end;
        if PCalcThreadStats^.pLBcalcStop^ then Break;
        Inc(y, iThreadCount);
      end;
    finally
      PCalcThreadStats^.CTrecords[iThreadID].isActive := 0;
      PostMessage(PCalcThreadStats^.pMessageHwnd, WM_ThreadReady, 0, 0);
    end;
end;

function TBulbTracer2Frm.StartSlicePreview(nr: Integer): LongBool;
var VoxCalcThreads: array of TFVoxelExportCalcPreviewThread;
    x, ThreadCount: Integer;
    MCTparas: TMCTparameter;
    d: Double;
begin
  ThreadCount := Min(Mand3DForm.UpDown3.Position, PreviewSize);
  try
    VHeader.TilingOptions := 0;
    bGetMCTPverbose := False;
    MCTparas := getMCTparasFromHeader(VHeader, False);
    bGetMCTPverbose := True;
    Result := MCTparas.bMCTisValid;
    if Result then begin
      MCTparas.pSiLight := @VsiLight[0];
      MCTparas.SLoffset := PVwid * SizeOf(Cardinal);
      MCTparas.PCalcThreadStats := @VCalcThreadStats;
      BuildRotMatrix(DegToRad(BTracer2Header.XAngle), DegToRad(BTracer2Header.YAngle), DegToRad(BTracer2Header.ZAngle), @MCTparas.VGrads);
      MCTparas.CalcRect := Rect(0, 0, PVwid - 1, PVhei - 1);
      d := 2.2 / (VHeader.dZoom * BTracer2Header.Scale * Max(1, PVdep - 1));
      MCTparas.VGrads := NormaliseMatrixTo(d, @MCTparas.VGrads);
      MCTparas.Ystart := TPVec3D(@VHeader.dXmid)^;
      mAddVecWeight(@MCTparas.Ystart, @MCTparas.Vgrads[0], PVwid * -0.5 + BTracer2Header.XOff / d);
      mAddVecWeight(@MCTparas.Ystart, @MCTparas.Vgrads[1], PVhei * -0.5 + BTracer2Header.YOff / d);
      mAddVecWeight(@MCTparas.Ystart, @MCTparas.Vgrads[2], nr - PVdep * 0.5 + BTracer2Header.ZOff / d);
      MCTparas.iSliceCalc := 1;
      MCTparas.DEAOmaxL := 0.75;
      MCTparas.iMandWidth := PreviewSize;
      SetLength(VoxCalcThreads, ThreadCount);
    end;
  except
    Result := False;
  end;
  if Result then
  begin
    VCalcThreadStats.ctCalcRect := MCTparas.CalcRect;
    VCalcThreadStats.pLBcalcStop := @MCalcStop;
    VCalcThreadStats.pMessageHwnd := Self.Handle;
    for x := 1 to ThreadCount do
    begin
      VCalcThreadStats.CTrecords[x].iActualYpos := -1;
      MCTparas.iThreadId := x;
      try
        VoxCalcThreads[x - 1] := TFVoxelExportCalcPreviewThread.Create(True);
        VoxCalcThreads[x - 1].FOwner := Self;
        VoxCalcThreads[x - 1].FreeOnTerminate := True;
        VoxCalcThreads[x - 1].MCTparas        := MCTparas;
        VoxCalcThreads[x - 1].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
        VCalcThreadStats.CTrecords[x].isActive := 1;
      except
        ThreadCount := x - 1;
        Break;
      end;
    end;
    for x := 0 to ThreadCount - 1 do VoxCalcThreads[x].MCTparas.iThreadCount := ThreadCount;
    VCalcThreadStats.iTotalThreadCount := ThreadCount;
    vActiveThreads := ThreadCount;
    for x := 0 to ThreadCount - 1 do VoxCalcThreads[x].Start;
    Timer2.Interval := 10;
    Timer2.Enabled := True;
  end;
end;

procedure TBulbTracer2Frm.Timer1Timer(Sender: TObject);   // proof if threads are still calculating
var
  y, it: Integer;
  Progress: Integer;
  HasError: boolean;
  ErrorMessage: string;
begin
  Timer1.Enabled := False;
  Application.ProcessMessages;
  it := 0;
  Progress := 0;
  HasError := false;
  ErrorMessage := 'An error has occured';
  with VCalcThreadStats do begin
    for y := 1 to iTotalThreadCount do begin
      Progress := Progress + CTrecords[y].iActualYpos;
      if CTrecords[y].isActive <> 0 then Inc(it);
      if ThreadErrorStatus[y].HasError then begin
        VCalcThreadStats.pLBcalcStop^ := True;
        HasError := true;
        if Trim( ThreadErrorStatus[y].ErrorMessage ) <> '' then
          ErrorMessage := Trim( ThreadErrorStatus[y].ErrorMessage );
        it := 0;
        break;
      end;
    end;
  end;
  if it = 0 then begin
    try
      if not VCalcThreadStats.pLBcalcStop^ then  begin
        MergeAndSaveMesh;
        ProgressBar.Position := ProgressBar.Max;
      end;
      Mand3DForm.EnableButtons;
      Mand3DForm.OutMessage('Finished tracing object.');
    finally
      FCalculating := False;
      EnableControls(True);
    end;
    if HasError then
      raise Exception.Create(ErrorMessage);
  end
  else begin
    ProgressBar.Position := Progress;
    Timer1.Enabled := True;
  end;
end;

procedure TBulbTracer2Frm.WmThreadReady(var Msg: TMessage);
begin
    if Msg.LParam = 0 then begin
      Dec(vActiveThreads);
      if vActiveThreads = 0 then begin
        if CalcPreview then Timer2.Interval := 1
                       else Timer1.Interval := 5;
      end;
    end;
end;

procedure TBulbTracer2Frm.UpdateBTracer2HeaderFromUI;
begin
  with BTracer2Header do begin
    XOff := StrToFloatK(XOffsetEdit.Text);
    YOff := StrToFloatK(YOffsetEdit.Text);
    ZOff := StrToFloatK(ZOffsetEdit.Text);
    Scale := StrToFloatK(ScaleEdit.Text);
    XAngle := StrToFloatK(XRotateEdit.Text);
    YAngle := StrToFloatK(YRotateEdit.Text);
    ZAngle := StrToFloatK(ZRotateEdit.Text);
    SurfaceDetail := StrToFloatK(SurfaceSharpnessEdit.Text);
    VResolution := StrToInt(MeshVResolutionEdit.Text);
    WithColors := CalculateColorsCBx.Checked;
    SaveTypeIndex := SaveTypeCmb.ItemIndex;
    MaxPreviewVertices := StrToInt(MaxVerticeCountEdit.Text);
    WithOpenGlPreview := OpenGLPreviewCBx.Checked;
    PreviewDEstop := StrToFloatK(PreviewDEAdjust.Text);
    VoxelPreviewSizeIdx := VoxelPreviewSizeGrp.ItemIndex;
    OpenGLPreviewSizeIdx := OpenGLPreviewSizeGrp.ItemIndex;
    WithAutoPreview := AutoCalcPreviewCbx.Checked;
    UseOpenGLForAutoPreview := OpenGLPreviewCheckbox.Checked;
    TraceXMin := StrToFloatK(TraceXMinEdit.Text);
    TraceXMax := StrToFloatK(TraceXMaxEdit.Text);
    TraceYMin := StrToFloatK(TraceYMinEdit.Text);
    TraceYMax := StrToFloatK(TraceYMaxEdit.Text);
    TraceZMin := StrToFloatK(TraceZMinEdit.Text);
    TraceZMax := StrToFloatK(TraceZMaxEdit.Text);
    CloseMesh := CloseMeshCheckbox.Checked;
    OutputFilename := FilenameREd.Text;
  end;
end;

procedure TBulbTracer2Frm.CalcImageSize;
var d: Double;
begin
    with BTracer2Header do
    begin
      d := Zslices / MaxCD(1e-40, Scale);
      VHeader.Width := Round(Scale * d);
      VHeader.Height := Round(Scale * d);
    end;
end;

procedure TBulbTracer2Frm.UpdateUIFromBTracer2Header;
var b: LongBool;
    i: Integer;
begin
    with BTracer2Header do  begin
      b := bUserChange;
      bUserChange := False;

      XOffsetEdit.Text := FloatToStr(XOff);
      ScaleEdit.Text := FloatToStr(Scale);
      YOffsetEdit.Text := FloatToStr(YOff);
      ZOffsetEdit.Text := FloatToStr(ZOff);
      XRotateEdit.Text := FloatToStr(XAngle);
      YRotateEdit.Text := FloatToStr(YAngle);
      ZRotateEdit.Text := FloatToStr(ZAngle);
      SurfaceSharpnessEdit.Text := FloatToStr(SurfaceDetail);
      MeshVResolutionEdit.Text := IntToStr(VResolution);
      CalculateColorsCBx.Checked := WithColors;
      SaveTypeCmb.ItemIndex := SaveTypeIndex;
      MaxVerticeCountEdit.Text := IntToStr(MaxPreviewVertices);
      OpenGLPreviewCBx.Checked := WithOpenGlPreview;
      PreviewDEAdjust.Text := FloatToStr(PreviewDEstop);
      VoxelPreviewSizeGrp.ItemIndex := VoxelPreviewSizeIdx;
      OpenGLPreviewSizeGrp.ItemIndex := OpenGLPreviewSizeIdx;
      AutoCalcPreviewCbx.Checked := WithAutoPreview;
      OpenGLPreviewCheckbox.Checked := UseOpenGLForAutoPreview;
      FilenameREd.Text := OutputFilename;
      TraceXMinEdit.Text := FloatToStr(TraceXMin);
      TraceXMaxEdit.Text := FloatToStr(TraceXMax);
      TraceYMinEdit.Text := FloatToStr(TraceYMin);
      TraceYMaxEdit.Text := FloatToStr(TraceYMax);
      TraceZMinEdit.Text := FloatToStr(TraceZMin);
      TraceZMaxEdit.Text := FloatToStr(TraceZMax);
      CloseMeshCheckbox.Checked := CloseMesh;

      UpdatePreviewSizeGrp;

      CalcImageSize;
      bUserChange := b;
    end;
    VHeader.PCFAddon := @VHAddon;
    for i := 0 to 5 do VHeader.PHCustomF[i] := @HybridCustoms[i];
end;

procedure TBulbTracer2Frm.UpdatePreviewSizeGrp;
begin
  VoxelPreviewSizeGrp.Visible := not OpenGLPreviewCheckbox.Checked;
  OpenGLPreviewSizeGrp.Visible := not VoxelPreviewSizeGrp.Visible;
end;

procedure TBulbTracer2Frm.SetProjectName(FileName: String);
begin
    VProjectName := ChangeFileExtSave(ExtractFileName(FileName), '');
end;

procedure TBulbTracer2Frm.ImportParamsFromMainBtnClick(Sender: TObject);
begin
  FParamSource := psMain;
  ImportParams;
end;

procedure TBulbTracer2Frm.ImportParams(const KeepScaleAndPosition: Boolean = True);
var i: Integer;

    procedure LoadParamFromFile(const ParamFilename: String);
    var
      OldNoSetFocus: Boolean;
    begin
      OldNoSetFocus := Mand3DForm.NoSetFocus;
      try
        Mand3DForm.NoSetFocus := True;
        LoadParameter( Mand3DForm.MHeader, ParamFilename, True);
      finally
        Mand3DForm.NoSetFocus := OldNoSetFocus;
      end;
    end;

begin
    CancelPreview;

   // OpenGLPreviewCheckbox.Checked := False;

    VHeader.PCFAddon := @VHAddon;
    for i := 0 to 5 do VHeader.PHCustomF[i] := @HybridCustoms[i];
    for i := 0 to 5 do IniCustomF(@HybridCustoms[i]);

    if FParamSource = psMain then begin
      Mand3DForm.MakeHeader;
      AssignHeader(@VHeader, @Mand3DForm.MHeader);
      ShowTitle( 'Imported from Main' );
    end
    else if FParamSource = psSingleFile then begin
      LoadParamFromFile( FParamFilename );
      Mand3DForm.ParasChanged;
      Mand3DForm.ClearScreen;
      Mand3DForm.MakeHeader;
      AssignHeader(@VHeader, @Mand3DForm.MHeader);
      ShowTitle( ExtractFilename( FParamFilename ) );
    end;

    BTracer2Header.MandParamsAsString := MakeTextparas(@Mand3DForm.MHeader, Mand3DForm.Caption);

    DisableTiling(@VHeader);
    VHeader.TilingOptions := 0;

    if not KeepScaleAndPosition then with BTracer2Header do begin
      Xoff := 0;
      Yoff := 0;
      Zoff := 0;
      Scale := 0.5;
      XAngle := 0;
      YAngle := 0;
      ZAngle := 0;
    end;
    SetProjectName('new');
    UpdateUIFromBTracer2Header;
    Benabled := True;
    EnableControls(True);

    BringToFront2(Self.Handle);
    if MeshPreviewFrm.Visible then
      BringToFront2(MeshPreviewFrm.Handle);

    //StartNewPreview;
    RefreshPreviewBtnClick(nil);
end;

procedure TBulbTracer2Frm.FormShow(Sender: TObject);
begin
    bUserChange := True;
    if bFirstShow then
    begin
      SaveDialog.InitialDir := IniDirs[12];
      bFirstShow := False;
      OutputFolder := IniDirs[12];
      VProjectName := 'new';

      SaveTypeCmb.ItemIndex := 0;
      if(OutputFolder<>'') then begin
        FilenameREd.Text := IncludeTrailingPathDelimiter(OutputFolder)+GetDefaultMeshFilename('mb3d_mesh', TMeshSaveType(SaveTypeCmb.ItemIndex));
      end;

      UpdateBTracer2HeaderFromUI;
    end;
  UpdatePreviewSizeGrp;
end;

procedure TBulbTracer2Frm.XOffsetEditChange(Sender: TObject);
begin
  if bUserChange then begin
    UpdateBTracer2HeaderFromUI;
    CalcImageSize;
    RefreshPreviewBtnClick(nil);
//    StartNewPreview;
  end;
end;

procedure TBulbTracer2Frm.XOffsetUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(XOffsetEdit.Text, 0.0) + UpDownBtnValue(Button, 0.05);
  XOffsetEdit.Text := FloatToStr(Value);
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.XRotateUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(XRotateEdit.Text, 0.0) + UpDownBtnValue(Button, 3.0);
  XRotateEdit.Text := FloatToStr(Value);
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.YOffsetUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(YOffsetEdit.Text, 0.0) + UpDownBtnValue(Button, 0.05);
  YOffsetEdit.Text := FloatToStr(Value);
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.YRotateUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(YRotateEdit.Text, 0.0) + UpDownBtnValue(Button, 3.0);
  YRotateEdit.Text := FloatToStr(Value);
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.ZOffsetUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(ZOffsetEdit.Text, 0.0) + UpDownBtnValue(Button, 0.05);
  ZOffsetEdit.Text := FloatToStr(Value);
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.ZRotateUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(ZRotateEdit.Text, 0.0) + UpDownBtnValue(Button, 3.0);
  ZRotateEdit.Text := FloatToStr(Value);
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.FormCreate(Sender: TObject);
var i: Integer;
begin
  FLogger := TDebugStringLogger.Create;
  FRefreshing := True;
  try
    FSavePartCriticalSection := TCriticalSection.Create;
    FParamSource := psMain;
    FThreadVertexLists := TObjectList.Create;
    FThreadNormalsLists := TObjectList.Create;
    FThreadColorsLists := TObjectList.Create;
    FVertexGenConfig := TVertexGen2Config.Create;
    bFirstShow := True;
    Benabled := False;
    for i := 0 to 5 do IniCustomF(@HybridCustoms[i]);
    bBulbTracerFormCreated := True;
    //Panel4.DoubleBuffered := True;

    FCancelType := ctCancelAndShowResult;
    CancelTypeCmb.ItemIndex := Ord(FCancelType);
  finally
    FRefreshing := False;
  end;
  MeshVResolutionEditChange(nil);
end;

procedure TBulbTracer2Frm.FormDestroy(Sender: TObject);
begin
  FThreadVertexLists.Free;
  FThreadNormalsLists.Free;
  FThreadColorsLists.Free;
  FVertexGenConfig.Free;
  FSavePartCriticalSection.Free;
  FLogger.Free;
end;

procedure TBulbTracer2Frm.CalcVoxelPreviewSizes;
var d: Double;
begin
    with BTracer2Header do begin
      PreviewSize := CalcVoxelPreviewSize;
      d := 1.0 / Scale;
      PVwid := Round(PreviewSize * Scale * d);
      PVhei := Round(PreviewSize * Scale * d);
      PVdep := Round(PreviewSize * Scale * d);
    end;
end;

function TBulbTracer2Frm.CalcVoxelPreviewSize: Integer;
begin
  Result := 16 shl VoxelPreviewSizeGrp.ItemIndex;
end;

function TBulbTracer2Frm.CalcOpenGLPreviewSize: Integer;
var
  SizeStr: String;
begin
  SizeStr := OpenGLPreviewSizeGrp.Items[OpenGLPreviewSizeGrp.ItemIndex];
  Result := StrToInt(Copy(SizeStr, 1, Length(SizeStr)-2));
end;

procedure TBulbTracer2Frm.Button2Click(Sender: TObject);
begin
  if OpenDialog2.Execute then begin
    FParamSource := psSingleFile;
    FParamFilename := OpenDialog2.FileName;
    ImportParams;
  end;
end;

procedure TBulbTracer2Frm.SelectOutputFilenameBtnClick(Sender: TObject);
begin
  try
    SaveDialog.DefaultExt := GetMeshFileExt(TMeshSaveType(SaveTypeCmb.ItemIndex));
    SaveDialog.Filter := GetMeshFileFilter(TMeshSaveType(SaveTypeCmb.ItemIndex));
    SaveDialog.InitialDir := ExtractFilePath(FilenameREd.Text);
    SaveDialog.FileName := FilenameREd.Text;
    if SaveDialog.Execute(Self.Handle) then
      FilenameREd.Text := SaveDialog.FileName;
  except
    // Hide error
  end;
end;

procedure TBulbTracer2Frm.ClearClassicPreview;
begin
  Image1.Canvas.Brush.Color := $222222;
  Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
  Image1.Picture.Bitmap.PixelFormat := pf32bit;
end;

procedure TBulbTracer2Frm.OpenGLPreviewIndicatorTimerTimer(Sender: TObject);
begin
  Inc(FOpenGLPreviewIndicator);
  if (FOpenGLPreviewIndicator mod 5) =0 then begin
    ClearClassicPreview;
  end
  else begin
    Image1.Canvas.Brush.Color := $666666;
    Image1.Canvas.TextOut(Image1.Canvas.ClipRect.Width div 2 - 32, Image1.Canvas.ClipRect.Height div 2 - 16, 'Calculating... >>');
  end;
end;

procedure TBulbTracer2Frm.RefreshPreviewBtnClick(Sender: TObject);  //calc preview
begin
  if OpenGLPreviewCheckbox.Checked then begin
    if not FCalculatingPreview then begin
      ClearClassicPreview;
      MeshPreviewFrm.Visible := True;
      FOpenGLPreviewIndicator := 0;
      OpenGLPreviewIndicatorTimer.Enabled := True;
      StartCalc(True);
    end;
  end
  else begin
    if RefreshPreviewBtn.Caption = 'Stop' then begin
      MCalcStop := True;
  //    Inc(CalcVoxelPreviewIndex);
    end
    else begin
      MeshPreviewFrm.Visible := False;
      PreviewProgressBar.Position := 0;
      PreviewProgressBar.Max := 10; //CalcPreviewSize;
      UpdateBTracer2HeaderFromUI;
      CalcVoxelPreviewSizes;
    //  Mand3DForm.bCalcTile := False;
      FileNumber := PVdep;
      SetLength(VsiLight, PreviewSize * PreviewSize);
      CalcPreview := True;
      Image1.Canvas.Brush.Color := $203040;
      Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
      Image1.Picture.Bitmap.PixelFormat := pf32bit;
      MCalcStop := False;  //because only in DisableButtons else, to late for first filenumber
      if StartSlicePreview(FileNumber) then
      begin
        RefreshPreviewBtn.Caption := 'Stop';
      end;
    end;
  end;
end;


procedure TBulbTracer2Frm.PaintNextPreviewSlice(nr: Integer);
var x, y, y2, i, j, i2, i3, i4, im, ik: Integer;
    PSLstart, PLoffset, bmpSL, bmpOffset, bmpOffP: Integer;
    PC, PSL: PCardinal;
begin
    //PreviewProgressBar.StepIt;
    PreviewProgressBar.Position := Round(10.0 * (CalcVoxelPreviewSize - nr + 1) / CalcVoxelPreviewSize);
    PSLstart := Integer(@VsiLight[0]);
    PLoffset := PVwid * SizeOf(Cardinal);
    i := Round((165 - (nr / PVdep) * 128) * 1.5);
    i2 := Round(165 - (nr / PVdep) * 128);
    if PreviewSize > 128 then i2 := Round(255 - (nr / PVdep) * 212);
    i4 := i shr 1;
    i3 := i2 shr 1;
    i3 := i3 or (i3 shl 8) or (i3 shl 16);
    i2 := i2 or (i2 shl 8) or (i2 shl 16);
    i := i or (i shl 8) or (i shl 16);
    i4 := i4 or (i4 shl 8) or (i4 shl 16);
    ik := PreviewSize div 16; //1,2,4,8,16
    (*
    im := 5 - ik;
    if im = 3 then im := 2;   //4,2,1
    *)
    case ik of
      1: im := 16;
      2: im := 8;
      4: im := 4;
      8: im := 2;
    else
      im := 1;
    end;
    with Image1.Picture.Bitmap do
    begin
      bmpSL := Integer(ScanLine[0]);
      bmpOffset := Integer(ScanLine[1]) - bmpSL;
      bmpOffP := (((PreviewSize - PVhei) * im) shr 1) * bmpOffset + (((PreviewSize - PVwid) * im) shr 1) shl 2;
      for y := 0 to PVhei - 1 do
      begin
        PSL := PCardinal(PSLstart + y * PLoffset);
        y2 := y * im + 65 - nr div ik;
        PC := PCardinal(bmpSL + bmpOffset * y2 + bmpOffP + ((nr * im) and $FFC));   //first is background
        if PreviewSize = 16 then
        begin
          for x := 0 to PVwid - 1 do
          begin
            if PSL^ > 0 then begin
              Solid4(PC, i, i4);
              for J := 0 to 10 do
                Solid16(PCardinal(Integer(PC) + bmpOffset * J), i2, i3);
            end;
            Inc(PSL);
            Inc(PC, 16);
          end;
        end
        else if PreviewSize = 32 then
        begin
          for x := 0 to PVwid - 1 do
          begin
            if PSL^ > 0 then begin
              Solid4(PC, i, i4);
              for J := 0 to 5 do
                Solid8(PCardinal(Integer(PC) + bmpOffset * J), i2, i3);
            end;
            Inc(PSL);
            Inc(PC, 8);
          end;
        end
        else if PreviewSize = 64 then
        begin
          for x := 0 to PVwid - 1 do
          begin
            if PSL^ > 0 then begin
              Solid4(PC, i, i4);
              Solid4(PCardinal(Integer(PC) + bmpOffset), i2, i3);
              Solid4(PCardinal(Integer(PC) + bmpOffset * 2), i2, i3);
              Solid4(PCardinal(Integer(PC) + bmpOffset * 3), i2, i3);
            end;
            Inc(PSL);
            Inc(PC, 4);
          end;
        end
        else if PreviewSize = 128 then
        begin
          for x := 0 to PVwid - 1 do
          begin
            if PSL^ > 0 then
            begin
              PC^ := i;
              PCardinal(Integer(PC) + bmpOffset)^ := i2;
              Inc(PC);
              PC^ := i;
              PCardinal(Integer(PC) + bmpOffset)^ := i3;
              Inc(PC);
            end
            else Inc(PC, 2);
            Inc(PSL);
          end;
        end
        else if PreviewSize = 256 then
        begin
          for x := 0 to PVwid - 1 do
          begin
            if PSL^ > 0 then
              PC^ := i2;
            Inc(PSL);
            Inc(PC);
          end;
        end;
      end;
      Modified := True;
    end;
end;

procedure TBulbTracer2Frm.PreviewTimerTimer(Sender: TObject);
var
  y, it: Integer;
  Progress: Integer;
  HasError: boolean;
  ErrorMessage: string;
begin
  PreviewTimer.Enabled := False;
  Application.ProcessMessages;
  it := 0;
  Progress := 0;
  HasError := false;
  ErrorMessage := 'An error has occured';
  with VCalcThreadStats do begin
    for y := 1 to iTotalThreadCount do begin
      Progress := Progress + CTrecords[y].iActualYpos;
      if CTrecords[y].isActive <> 0 then Inc(it);
      if ThreadErrorStatus[y].HasError then begin
        VCalcThreadStats.pLBcalcStop^ := True;
        HasError := true;
        if Trim( ThreadErrorStatus[y].ErrorMessage ) <> '' then
          ErrorMessage := Trim( ThreadErrorStatus[y].ErrorMessage );
        it := 0;
        break;
      end;
    end;
  end;
  if it = 0 then begin
    OpenGLPreviewIndicatorTimer.Enabled := False;
    try
      if not VCalcThreadStats.pLBcalcStop^ then  begin
        ShowPreviewMesh;
      end;
    //  Mand3DForm.EnableButtons;
    finally
      FCalculatingPreview := False;
      FCalculating := False;
      EnableControls(True);
      ClearClassicPreview;
    end;
    if HasError then
      raise Exception.Create(ErrorMessage);
  end
  else begin
    PreviewTimer.Enabled := True;
  end;
end;

procedure TBulbTracer2Frm.Timer2Timer(Sender: TObject);  //preview threads
var y, it: Integer;
begin
    Timer2.Enabled := False;
    it := 0;
    with VCalcThreadStats do
      for y := 1 to iTotalThreadCount do
        if CTrecords[y].isActive <> 0 then Inc(it);
    if it = 0 then //calc done
    begin
      if not VCalcThreadStats.pLBcalcStop^ then
        PaintNextPreviewSlice(FileNumber);
      Dec(FileNumber);
      if (FileNumber < 1) or VCalcThreadStats.pLBcalcStop^ or
         (not StartSlicePreview(FileNumber)) then
      begin
        Mand3DForm.EnableButtons;
      end;
    end
    else Timer2.Enabled := True;
end;

procedure TBulbTracer2Frm.PreviewDEAdjustUpDownClick(Sender: TObject; Button: TUDBtnType);
var d: Double;
begin
  d := 0.05;
  if Button = btPrev then d := -d;
  BTracer2Header.PreviewDEstop := BTracer2Header.PreviewDEstop + d;
  if BTracer2Header.PreviewDEstop < 0.05 then
    BTracer2Header.PreviewDEstop := 0.05;
  PreviewDEAdjust.Text := FloatToStrSingle(BTracer2Header.PreviewDEstop);
end;

procedure TBulbTracer2Frm.UpDown5Click(Sender: TObject; Button: TUDBtnType);
var d: Double;
begin
    d := 2.2 / (VHeader.dZoom * BTracer2Header.Scale * Max(1, PVdep - 1));
    if Button = btNext then d := -d;
    BTracer2Header.XOff := BTracer2Header.XOff + d;
    XOffsetEdit.Text := FloatToStrSingle(BTracer2Header.XOff);
end;

procedure TBulbTracer2Frm.UpDown6Click(Sender: TObject; Button: TUDBtnType);
var d: Double;
begin
    d := -2.2 / (VHeader.dZoom * BTracer2Header.Scale * Max(1, PVdep - 1));
    if Button = btNext then d := -d;
    BTracer2Header.YOff := BTracer2Header.YOff + d;
    YOffsetEdit.Text := FloatToStrSingle(BTracer2Header.YOff);
end;

procedure TBulbTracer2Frm.UpDown7Click(Sender: TObject; Button: TUDBtnType);
var d: Double;
begin
    d := 2.2 / (VHeader.dZoom * BTracer2Header.Scale * Max(1, PVdep - 1));
    if Button = btNext then d := -d;
    BTracer2Header.ZOff := BTracer2Header.ZOff + d;
    ZOffsetEdit.Text := FloatToStrSingle(BTracer2Header.ZOff);
end;

procedure TBulbTracer2Frm.StartNewPreview;
begin
 if AutoCalcPreviewCbx.Checked then begin
   MCalcStop := True;
   Timer3.Enabled := True;
   while(FCalculatingPreview) do begin
     Application.ProcessMessages;
     Sleep(1);
   end;
 end
 else Timer3.Enabled := False;
end;


procedure TBulbTracer2Frm.Timer3Timer(Sender: TObject);
var y, it: Integer;
begin
    Timer3.Enabled := False;
    it := 0;
    with VCalcThreadStats do
      for y := 1 to iTotalThreadCount do
        if CTrecords[y].isActive <> 0 then Inc(it);
    if RefreshPreviewBtn.Enabled and (it = 0) and (RefreshPreviewBtn.Caption <> 'Stop') then //calc done
    begin
     // RadioGroup2.ItemIndex := 0;
      RefreshPreviewBtnClick(Self);
    end
    else Timer3.Enabled := True;
end;

procedure TBulbTracer2Frm.TraceXMaxEditExit(Sender: TObject);
begin
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.TraceXMaxUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value :=  Max( Min( StrToFloatSafe(TraceXMaxEdit.Text, 0.0) + UpDownBtnValue(Button, 1.0), 100.0), 0.0);
  TraceXMaxEdit.Text := FloatToStr(Value);
  TraceXMaxEditExit(nil);
end;

procedure TBulbTracer2Frm.TraceXMinEditExit(Sender: TObject);
begin
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.TraceXMinEditUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value :=  Max( Min( StrToFloatSafe(TraceXMinEdit.Text, 0.0) + UpDownBtnValue(Button, 1.0), 100.0), 0.0);
  TraceXMinEdit.Text := FloatToStr(Value);
  TraceXMinEditExit(nil);
end;

procedure TBulbTracer2Frm.TraceYMaxEditExit(Sender: TObject);
begin
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.TraceYMaxUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value :=  Max( Min( StrToFloatSafe(TraceYMaxEdit.Text, 0.0) + UpDownBtnValue(Button, 1.0), 100.0), 0.0);
  TraceYMaxEdit.Text := FloatToStr(Value);
  TraceYMaxEditExit(nil);
end;

procedure TBulbTracer2Frm.TraceYMinEditExit(Sender: TObject);
begin
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.TraceYMinEditUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value :=  Max( Min( StrToFloatSafe(TraceYMinEdit.Text, 0.0) + UpDownBtnValue(Button, 1.0), 100.0), 0.0);
  TraceYMinEdit.Text := FloatToStr(Value);
  TraceYMinEditExit(nil);
end;

procedure TBulbTracer2Frm.TraceZMaxEditExit(Sender: TObject);
begin
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.TraceZMaxEditUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value :=  Max( Min( StrToFloatSafe(TraceZMaxEdit.Text, 0.0) + UpDownBtnValue(Button, 1.0), 100.0), 0.0);
  TraceZMaxEdit.Text := FloatToStr(Value);
  TraceZMaxEditExit(nil);
end;

procedure TBulbTracer2Frm.TraceZMinEditExit(Sender: TObject);
begin
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.TraceZMinUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value :=  Max( Min( StrToFloatSafe(TraceZMinEdit.Text, 0.0) + UpDownBtnValue(Button, 1.0), 100.0), 0.0);
  TraceZMinEdit.Text := FloatToStr(Value);
  TraceZMinEditExit(nil);
end;

procedure TBulbTracer2Frm.CancelBtnClick(Sender: TObject);
var
  I: Integer;
begin
// Dialog sucks
//  if FCalculating and (MessageDlg('Do you want to cancel?', mtConfirmation, mbYesNo, 0)=mrOK) then begin
    if FCalculating then begin
      try
        FForceAbort := True;
        with VCalcThreadStats do  begin
          for I := 1 to iTotalThreadCount do
            CTrecords[I].iDEAvrCount := -1;
        end;
      except
        // Hide error
      end;
    end;
//  end;
end;

procedure TBulbTracer2Frm.CancelPreview;
begin
  MCalcStop := True;
  Timer2.Enabled := False;
  Mand3DForm.EnableButtons;
end;

procedure TBulbTracer2Frm.CancelTypeCmbChange(Sender: TObject);
begin
  if (not FRefreshing) then
    FCancelType := TCancelType(CancelTypeCmb.ItemIndex);
end;

procedure TBulbTracer2Frm.VoxelPreviewSizeGrpClick(Sender: TObject);
begin
  if AutoCalcPreviewCbx.Checked then begin
    CancelPreview;
    RefreshPreviewBtnClick(nil);
  end;
end;

procedure TBulbTracer2Frm.Edit10Change(Sender: TObject);
begin
    if bUserChange then
    begin
      UpdateBTracer2HeaderFromUI;
      CalcImageSize;
    end;
end;

procedure TBulbTracer2Frm.ResetOffsetAndScaleBtnClick(Sender: TObject);
begin
    bUserChange := False;
    XOffsetEdit.Text := '0';
    YOffsetEdit.Text := '0';
    ZOffsetEdit.Text := '0';
    ScaleEdit.Text := '0.5';
    XRotateEdit.Text := '0';
    YRotateEdit.Text := '0';
    ZRotateEdit.Text := '0';
    bUserChange := True;
    XOffsetEditChange(Sender);
end;

procedure TBulbTracer2Frm.SaveBTracer2FileBtnClick(Sender: TObject);
begin
  if BTracer2FileSaveDialog.Execute then begin
    UpdateBTracer2HeaderFromUI;
    SaveBTracer2Header(BTracer2FileSaveDialog.Filename, @BTracer2Header);
  end;
end;

procedure TBulbTracer2Frm.CalculateBtnClick(Sender: TObject);
var
  DoSave: boolean;
begin
  if (not FCalculating) and (not FCalculatingPreview) then begin
    DoSave := ( ( TMeshSaveType(SaveTypeCmb.ItemIndex) <> stNoSave ) );

    if DoSave and (FilenameREd.Text = '') then begin
      SelectOutputFilenameBtnClick(Sender);
      if FilenameREd.Text = '' then
        Exit;
    end;

    StartCalc(False);
  end;
end;

procedure TBulbTracer2Frm.StartCalc(const ForPreview: boolean);
begin
  if not ForPreview then begin
    FForceAbort := False;
    FCalculating := True;
    CancelPreview;
    EnableControls(True);
  end;
  UpdateBTracer2HeaderFromUI;
  if ForPreview then begin
    BTracer2Header.VResolution := CalcOpenGLPreviewSize;
//    BTracer2Header.WithColors := False;
    BTracer2Header.SaveTypeIndex := 3;
  end;
  ImageScale := 1;
  SetLength(Mand3DForm.siLight5, VHeader.Width * VHeader.Height);
  Mand3DForm.mSLoffset := VHeader.Width * SizeOf(TsiLight5);
  Mand3DForm.MHeader.Width := VHeader.Width;
  Mand3DForm.MHeader.Height := VHeader.Height;
  SetImageSize;
  CalcPreview := False;
  UpdateVertexGenConfig;
  T0 := DateUtils.MilliSecondsBetween(Now, 0);
  StartPLYRender(ForPreview);
end;

function TBulbTracer2Frm.StartPLYRender(const ForPreview: boolean): LongBool;
var
  PLYCalcThreads: array of TPLYExportCalcThread;
  x, ThreadCount: Integer;
  MCTparas: TMCTparameter;
  d: double;
begin
  ThreadCount := Min(Mand3DForm.UpDown3.Position, VHeader.Height);
  try
    FSavePartIdx := 0;
    FThreadVertexLists.Clear;
    FThreadNormalsLists.Clear;
    FThreadColorsLists.Clear;
    FSaveType := TMeshSaveType( BTracer2Header.SaveTypeIndex );
    VHeader.TilingOptions := 0;
    bGetMCTPverbose := False;
    MCTparas := getMCTparasFromHeader(VHeader, False);
    bGetMCTPverbose := True;
    Result := MCTparas.bMCTisValid;
    if Result then begin
      MCTparas.pSiLight := @Mand3DForm.siLight5[0];
      MCTparas.PCalcThreadStats := @VCalcThreadStats;
      MCTparas.CalcRect := Rect(0, 0, VHeader.Width - 1, VHeader.Height - 1);
      BuildRotMatrix(DegToRad(BTracer2Header.XAngle), DegToRad(BTracer2Header.YAngle), DegToRad(BTracer2Header.ZAngle), @MCTparas.VGrads);
      d := 2.2 / (VHeader.dZoom * BTracer2Header.Scale * (ZSlices - 1)); //new stepwidth
      MCTparas.VGrads := NormaliseMatrixTo(d, @MCTparas.VGrads);
      MCTparas.Ystart := TPVec3D(@VHeader.dXmid)^;                                   //abs offs!
      mAddVecWeight(@MCTparas.Ystart, @MCTparas.Vgrads[0], VHeader.Width * -0.5 + BTracer2Header.XOff / d);
      mAddVecWeight(@MCTparas.Ystart, @MCTparas.Vgrads[1], VHeader.Height * -0.5 + BTracer2Header.YOff / d);
      mAddVecWeight(@MCTparas.Ystart, @MCTparas.Vgrads[2], Zslices * -0.5 + BTracer2Header.ZOff / d);
      SetLength(PLYCalcThreads, ThreadCount);
    end;
  except
    Result := False;
  end;
  if Result then begin
    try
      VCalcThreadStats.ctCalcRect := MCTparas.CalcRect;
      VCalcThreadStats.pLBcalcStop := @MCalcStop;
      VCalcThreadStats.pMessageHwnd := Self.Handle;
      for x := 1 to ThreadCount do begin

        VCalcThreadStats.CTrecords[x].iActualYpos := -1;
        VCalcThreadStats.CTrecords[x].iActualXpos := 0;
        VCalcThreadStats.CTrecords[x].i64DEsteps  := 0;
        VCalcThreadStats.CTrecords[x].iDEAvrCount := 0;
        VCalcThreadStats.CTrecords[x].i64Its      := 0;
        VCalcThreadStats.CTrecords[x].iItAvrCount := 0;
        VCalcThreadStats.CTrecords[x].MaxIts      := 0;
        MCTparas.iThreadId := x;
        try
          PLYCalcThreads[x - 1] := TPLYExportCalcThread.Create(True);
          PLYCalcThreads[x - 1].FOwner := Self;
          PLYCalcThreads[x - 1].FreeOnTerminate := True;
          PLYCalcThreads[x - 1].MCTparas        := MCTparas;
          PLYCalcThreads[x - 1].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
          PLYCalcThreads[x - 1].BTracer2Header  := BTracer2Header;
          PLYCalcThreads[x - 1].VertexGenConfig := FVertexGenConfig;
          PLYCalcThreads[x - 1].FacesList      := TFacesList.Create;
          FThreadVertexLists.Add(PLYCalcThreads[x - 1].FacesList);
          VCalcThreadStats.CTrecords[x].isActive := 1;
        except
          ThreadCount := x - 1;
          Break;
        end;
      end;
      VCalcThreadStats.HandleType := 0;
      for x := 0 to ThreadCount - 1 do PLYCalcThreads[x].MCTparas.iThreadCount := ThreadCount;
      ProgressBar.Min := 0;
      ProgressBar.Position := 0;
      ProgressBar.Max := ThreadCount * 100;
      VCalcThreadStats.iTotalThreadCount := ThreadCount;
      VCalcThreadStats.cCalcTime         := GetTickCount;
      vActiveThreads := ThreadCount;
      PaintedYsofar := 0;
      for x := 0 to ThreadCount - 1 do PLYCalcThreads[x].Prepare(ForPreview);
      for x := 0 to ThreadCount - 1 do PLYCalcThreads[x].Start;



      if ForPreview then begin
        FCalculatingPreview := True;
        Mand.MCalcStop := False;
        PreviewTimer.Interval := 20;
        PreviewTimer.Enabled := True;
      end
      else begin
        Mand3DForm.DisableButtons;
        Label13.Caption := 'Tracing object...';
        Timer1.Interval := 200;
        Timer1.Enabled := True;
      end;
    except
      Result := False;
    end;
  end;
  if not Result then begin
    FCalculating := False;
    EnableControls(True);
    Mand3DForm.OutMessage('Error starting rendering');
    OpenGLPreviewIndicatorTimer.Enabled := False;
  end;
end;
//################################################################################
destructor TPLYExportCalcThread.Destroy;
begin
  if Assigned( FObjectScanner ) then
    FreeAndNil( FObjectScanner );
  inherited Destroy;
end;

procedure TPLYExportCalcThread.Prepare(const ForPreview: boolean);
var
  PHeader: TPBTraceMainHeader;
begin
  FOwner.ThreadErrorStatus[MCTparas.iThreadId].HasError := False;
  try
    CoInitialize(nil);
    FObjectScanner := TParallelScanner2.Create(VertexGenConfig, MCTparas, BTracer2Header, FOwner.VHeader, FacesList, VertexGenConfig.SurfaceSharpness, FOwner.FSaveType = stBTracer2Data, '', FOwner.FLogger );
    FObjectScanner.ThreadIdx := MCTparas.iThreadId - 1;
    if (not ForPreview) and (FOwner.FSaveType = stBTracer2Data) then begin
      FObjectScanner.OutputFilename := FOwner.FilenameREd.Text;
      if FObjectScanner.ThreadIdx = 0 then begin
        GetMem(PHeader, SizeOf( TBTraceMainHeader ) );
        try
          PHeader^.VHeaderWidth := FOwner.VHeader.Width;
          PHeader^.VHeaderHeight := FOwner.VHeader.Height;
          PHeader^.VHeaderZoom := FOwner.VHeader.dZoom;
          PHeader^.VHeaderZScale := BTracer2Header.Scale;
          PHeader^.VResolution := VertexGenConfig.URange.StepCount;
          PHeader^.ThreadCount := FOwner.VCalcThreadStats.iTotalThreadCount;
          PHeader^.WithColors := Ord(VertexGenConfig.CalcColors);
          PHeader^.SurfaceDetail := VertexGenConfig.SurfaceSharpness;
          PHeader^.TraceXMin := VertexGenConfig.TraceXMin;
          PHeader^.TraceXMax := VertexGenConfig.TraceXMax;
          PHeader^.TraceYMin := VertexGenConfig.TraceYMin;
          PHeader^.TraceYMax := VertexGenConfig.TraceYMax;
          PHeader^.TraceZMin := VertexGenConfig.TraceZMin;
          PHeader^.TraceZMax := VertexGenConfig.TraceZMax;
          PHeader^.CloseMesh := Ord(VertexGenConfig.CloseMesh);
          InitBTraceFile( FObjectScanner.OutputFilename, PHeader );
        finally
          FreeMem(PHeader);
        end;
      end;
    end;
    FPrepared := True;
  except
    on E: Exception do begin
      FOwner.ThreadErrorStatus[MCTparas.iThreadId].HasError := True;
      FOwner.ThreadErrorStatus[MCTparas.iThreadId].ErrorMessage := E.Message;
    end;
  end;
end;

procedure TPLYExportCalcThread.Execute;
begin
  try
    try
      if FOwner.ThreadErrorStatus[MCTparas.iThreadId].HasError then
        raise Exception.Create(FOwner.ThreadErrorStatus[MCTparas.iThreadId].ErrorMessage);
      if not FPrepared then
        raise Exception.Create('Call Prepare First');
      FObjectScanner.Scan;
    except
      on E: Exception do begin
        FOwner.ThreadErrorStatus[MCTparas.iThreadId].HasError := True;
        FOwner.ThreadErrorStatus[MCTparas.iThreadId].ErrorMessage := E.Message;
      end;
    end;
  finally
    with MCTparas do begin
      PCalcThreadStats.CTrecords[iThreadID].isActive := 0;
      PostMessage(PCalcThreadStats.pMessageHwnd, WM_ThreadReady, 0, 0);
    end;
  end;
end;

procedure TBulbTracer2Frm.SaveTypeCmbChange(Sender: TObject);
begin
  if (not FRefreshing) then begin
    SetExportFilenameExt;
  end;
end;

procedure TBulbTracer2Frm.ScaleDownBtnClick(Sender: TObject);
var d: Double;
begin
    UpdateBTracer2HeaderFromUI;
    d := 1.1;
    if Sender <> ScaleUpBtn then d := 1 / d;
    BTracer2Header.Scale := BTracer2Header.Scale * d;
    ScaleEdit.Text := FloatToStrSingle( BTracer2Header.Scale );
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.ScaleEditUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(ScaleEdit.Text, 0.0) + UpDownBtnValue(Button, 0.05);
  ScaleEdit.Text := FloatToStr(Value);
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.SaveMesh;
var
  FacesList: TFacesList;
  MaxVerticeCount: Integer;
begin
  try
    if (not FForceAbort) or (FCancelType = ctCancelAndShowResult) then begin
      if( FSaveType = stBTracer2Data ) then begin
        // trace-data is already saved at this point
        OutputDebugString(PChar('TOTAL: '+IntToStr(DateUtils.MilliSecondsBetween(Now, 0)-T0)+' ms'));
        if not FForceAbort then
          Label13.Caption := 'Elapsed time: ' + IntToStr(Round((DateUtils.MilliSecondsBetween(Now, 0)-T0)/1000.0))+' s';
      end
      else begin
        FacesList := TFacesList.MergeFacesLists( FThreadVertexLists );
        try
          FacesList.DoCenter(1.0);
          if not FForceAbort then begin
            if FSaveType = stMeshAsObj then
              TObjFileWriter.SaveToFile(FilenameREd.Text, FacesList)
            else if FSaveType = stMeshAsPly then
              TPlyFileWriter.SaveToFile(FilenameREd.Text, FacesList);
          end;
          FThreadVertexLists.Clear;
          OutputDebugString(PChar('TOTAL: '+IntToStr(DateUtils.MilliSecondsBetween(Now, 0)-T0)+' ms'));
          if not FForceAbort then
            Label13.Caption := 'Elapsed time: ' + IntToStr(Round((DateUtils.MilliSecondsBetween(Now, 0)-T0)/1000.0))+' s';
          if OpenGLPreviewCBx.Checked then begin
            try
              MaxVerticeCount := StrToInt(MaxVerticeCountEdit.Text);
            except
              MaxVerticeCount := -1;
            end;
            MeshPreviewFrm.WindowTitle := OpenGLWindowTitleMesh;
            MeshPreviewFrm.UpdateMesh(FacesList, MaxVerticeCount, False, True);
          end;
        finally
          FacesList.Free;
        end;
      end;
    end;
  finally
    FThreadVertexLists.Clear;
  end;
  if not FForceAbort then
    Label13.Caption := 'Elapsed time: ' + IntToStr(Round((DateUtils.MilliSecondsBetween(Now, 0)-T0)/1000.0))+' s'
  else
    Label13.Caption := 'Operation cancelled';

  if OpenGLPreviewCBx.Checked and (  FSaveType <> stBTracer2Data )  then
    MeshPreviewBtnClick(nil);
end;

procedure TBulbTracer2Frm.ShowPreviewMesh;
var
  FacesList: TFacesList;
begin
  try
    FacesList := TFacesList.MergeFacesLists( FThreadVertexLists );
    try
      FacesList.DoMoveAndScale(-50.0, -50.0, -50.0, 0.01, 0.01, 0.01);
      FThreadVertexLists.Clear;
      MeshPreviewFrm.WindowTitle := OpenGLWindowTitleBTracer2Preview;
      MeshPreviewFrm.UpdateMesh(FacesList, -1, True, True);
    finally
      FacesList.Free;
    end;
  finally
    FThreadVertexLists.Clear;
  end;
end;

procedure TBulbTracer2Frm.MergeAndSaveMesh;
begin
  SaveMesh;
end;

procedure TBulbTracer2Frm.SurfaceSharpnessEditExit(Sender: TObject);
begin
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.SurfaceSharpnessUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(SurfaceSharpnessEdit.Text, 0.0) + UpDownBtnValue(Button, 0.05);
  SurfaceSharpnessEdit.Text := FloatToStr(Value);
  SurfaceSharpnessEditExit(nil);
end;

procedure TBulbTracer2Frm.MeshPreviewBtnClick(Sender: TObject);
begin
  MeshPreviewFrm.Visible := True;
  BringToFront2(MeshPreviewFrm.Handle);
end;

procedure TBulbTracer2Frm.MeshVResolutionEditChange(Sender: TObject);
begin
  if not FRefreshing then
    MeshVResolutionLbl.Caption := ' x '+MeshVResolutionEdit.Text + ' x '+MeshVResolutionEdit.Text;
end;

procedure TBulbTracer2Frm.MeshVResolutionUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: integer;
begin
  Value := StrToInt(MeshVResolutionEdit.Text) + Round( UpDownBtnValue(Button, 8) );
  MeshVResolutionEdit.Text := IntToStr(Value);
  MeshVResolutionEditChange(nil);
end;

procedure TBulbTracer2Frm.OpenGLPreviewCBxClick(Sender: TObject);
begin
  if not OpenGLPreviewCBx.Checked then
    MeshPreviewFrm.Visible := False;
end;

procedure TBulbTracer2Frm.OpenGLPreviewCheckboxClick(Sender: TObject);
var
  FacesList: TFacesList;
begin
  if bUserChange then begin
    UpdatePreviewSizeGrp;
    if OpenGLPreviewCheckbox.Checked then
      StartNewPreview
    else if MeshPreviewFrm.Visible then begin
      FacesList := TFacesList.Create;
      try
        MeshPreviewFrm.WindowTitle := OpenGLWindowTitleBTracer2Preview;
        FacesList.DoCenter(1.0);
        MeshPreviewFrm.UpdateMesh(FacesList, -1, True, True);
      finally
        FacesList.Free;
      end;
    end;
  end;
end;

procedure TBulbTracer2Frm.WndProc(var Message: TMessage);
begin
  if Message.Msg = WM_Move then begin
    if MeshPreviewFrm <> nil then begin
      if FormsSticky[0] = 1 then
        MeshPreviewFrm.SetBounds(Left + Width, Top, MeshPreviewFrm.Width,
                                 MeshPreviewFrm.Height)
      else if FormsSticky[0] = 2 then
        MeshPreviewFrm.SetBounds(Left - MeshPreviewFrm.Width, Top,
                                 MeshPreviewFrm.Width, MeshPreviewFrm.Height);
    end;
  end;
  inherited WndProc(Message);
end;


procedure TBulbTracer2Frm.UpdateVertexGenConfig;
begin
  FVertexGenConfig.Clear;

  FVertexGenConfig.RemoveDuplicates := True;

  FVertexGenConfig.SurfaceSharpness := BTracer2Header.SurfaceDetail;
  FVertexGenConfig.CalcColors := BTracer2Header.WithColors;

  FVertexGenConfig.URange.StepCount := BTracer2Header.VResolution;
  FVertexGenConfig.VRange.StepCount := BTracer2Header.VResolution;

  FVertexGenConfig.URange.StepCount := BTracer2Header.VResolution;
  FVertexGenConfig.VRange.StepCount := BTracer2Header.VResolution;

  FVertexGenConfig.TraceXMin := BTracer2Header.TraceXMin;
  FVertexGenConfig.TraceXMax := BTracer2Header.TraceXMax;
  FVertexGenConfig.TraceYMin := BTracer2Header.TraceYMin;
  FVertexGenConfig.TraceYMax := BTracer2Header.TraceYMax;
  FVertexGenConfig.TraceZMin := BTracer2Header.TraceZMin;
  FVertexGenConfig.TraceZMax := BTracer2Header.TraceZMax;
  FVertexGenConfig.CloseMesh := BTracer2Header.CloseMesh;

end;

procedure TBulbTracer2Frm.EnableControls(const Enabled: Boolean);

  procedure EnableFields;
  begin
    Panel3.Enabled := Enabled;
    ImportParamsFromMainBtn.Enabled := Enabled;
    Button2.Enabled := Enabled;
    XOffsetEdit.Enabled := Enabled;
    YOffsetEdit.Enabled := Enabled;
    ZOffsetEdit.Enabled := Enabled;
    ScaleEdit.Enabled := Enabled;
    VoxelPreviewSizeGrp.Enabled := Enabled;
    OpenGLPreviewSizeGrp.Enabled := Enabled;
    AutoCalcPreviewCbx.Enabled := Enabled;
    RefreshPreviewBtn.Enabled := Enabled;
    MeshVResolutionEdit.Enabled := Enabled;
    MeshVResolutionUpDown.Enabled := Enabled;
    SurfaceSharpnessEdit.Enabled := Enabled;
    SurfaceSharpnessUpDown.Enabled := Enabled;
    CalculateColorsCBx.Enabled := Enabled;
    SaveTypeCmb.Enabled := Enabled;
    SelectOutputFilenameBtn.Enabled := Enabled;
    FilenameREd.Enabled := Enabled;
    OpenGLPreviewCBx.Enabled := Enabled;
    MeshPreviewBtn.Enabled := Enabled;
    MaxVerticeCountEdit.Enabled := Enabled;
    CloseMeshCheckbox.Enabled := Enabled;
    EditModeCmb.Enabled := Enabled;
    TraceXMinEdit.Enabled := Enabled;
    TraceXMaxEdit.Enabled := Enabled;
    TraceYMinEdit.Enabled := Enabled;
    TraceYMaxEdit.Enabled := Enabled;
    TraceZMinEdit.Enabled := Enabled;
    TraceZMaxEdit.Enabled := Enabled;
    OpenGLPreviewCheckbox.Enabled := Enabled;
    PreviewDEAdjust.Enabled := Enabled;
    CloseButton.Enabled := Enabled;
    XRotateEdit.Enabled := Enabled;
    YRotateEdit.Enabled := Enabled;
    ZRotateEdit.Enabled := Enabled;
    ResetOffsetAndScaleBtn.Enabled := Enabled;
  end;

begin
  if Enabled then begin
    ImportParamsFromMainBtn.Enabled := True;
    RefreshPreviewBtn.Enabled := Benabled;
    RefreshPreviewBtn.Caption := 'Calculate preview';
  end
  else begin
    ImportParamsFromMainBtn.Enabled := False;
    RefreshPreviewBtn.Enabled := False;
  end;
  EnableFields;
  CancelBtn.Enabled := FCalculating;
  CalculateBtn.Enabled := Benabled and (not FCalculating);
end;

procedure TBulbTracer2Frm.CloseMeshCheckboxClick(Sender: TObject);
begin
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.ShowTitle(const Caption: String);
begin
  Self.Caption := 'Bulb Tracer 2 [ ' + Caption + ' ]';
end;

procedure TBulbTracer2Frm.IncZOffsetBtnClick(Sender: TObject);
var d: Double;
begin
  if EditModeCmb.ItemIndex = 0 then begin
    d := 2.2 / (VHeader.dZoom * BTracer2Header.Scale * Max(1, PVdep - 1));
    if Sender = IncZOffsetBtn then d := -d;
    BTracer2Header.ZOff := BTracer2Header.ZOff + d;
    ZOffsetEdit.Text := FloatToStrSingle(BTracer2Header.ZOff);
  end
  else begin
    d := 5.0;
    if Sender = IncZOffsetBtn then d := -d;
    ZRotateEdit.Text := FloatToStrSingle( StrToFloatK(ZRotateEdit.Text) + d );
  end;
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.LoadBTracer2FileBtnClick(Sender: TObject);
var
  ParamError: boolean;
begin
  if BTracer2FileOpenDialog.Execute then begin
    LoadBTracer2Header(BTracer2FileOpenDialog.Filename, @BTracer2Header);
    ParamError := False;
    if BTracer2Header.MandParamsAsString <> '' then begin
      try
        Clipboard.SetTextBuf(PWideChar(String(BTracer2Header.MandParamsAsString)));
        Mand3DForm.SpeedButton8Click(nil);
        ImportParamsFromMainBtnClick(nil);
      except
        ParamError := True;
      end;
    end;
    LoadBTracer2Header(BTracer2FileOpenDialog.Filename, @BTracer2Header);
    UpdateUIFromBTracer2Header;


    if ParamError then
      MessageDlg('Failed to import fractal parameters. All other settings where imported?', mtWarning, [mbOK], 0);
  end;
end;

procedure TBulbTracer2Frm.IncXOffsetBtnClick(Sender: TObject);
var d: Double;
begin
  if EditModeCmb.ItemIndex = 0 then begin
    d := 2.2 / (VHeader.dZoom * BTracer2Header.Scale * Max(1, PVdep - 1));
    if Sender = IncXOffsetBtn then d := -d;
    BTracer2Header.XOff := BTracer2Header.XOff + d;
    XOffsetEdit.Text := FloatToStrSingle(BTracer2Header.XOff);
  end
  else begin
    d := 5.0;
    if Sender = IncXOffsetBtn then d := -d;
    YRotateEdit.Text := FloatToStrSingle( StrToFloatK(YRotateEdit.Text) + d );
  end;
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.IncYOffsetBtnClick(Sender: TObject);
var d: Double;
begin
  if EditModeCmb.ItemIndex = 0 then begin
    d := -2.2 / (VHeader.dZoom * BTracer2Header.Scale * Max(1, PVdep - 1));
    if Sender = DecYOffsetBtn then d := -d;
    BTracer2Header.YOff := BTracer2Header.YOff + d;
    YOffsetEdit.Text := FloatToStrSingle(BTracer2Header.YOff);
  end
  else begin
    d := 5.0;
    if Sender = DecYOffsetBtn then d := -d;
    XRotateEdit.Text := FloatToStrSingle( StrToFloatK(XRotateEdit.Text) + d );
  end;
  XOffsetEditChange(nil);
end;

procedure TBulbTracer2Frm.SetExportFilenameExt;
var
  NewFileExt: String;
begin
  if Trim( FilenameREd.Text ) <> '' then begin
    NewFileExt := GetMeshFileExt(TMeshSaveType(SaveTypeCmb.ItemIndex));

    if NewFileExt <> '' then
      NewFileExt := '.' + NewFileExt;
    FilenameREd.Text := ChangeFileExt( FilenameREd.Text, NewFileExt )
  end;
end;

end.


