{ ---------------------------------------------------------------------------- }
{ BulbTracer for MB3D                                                          }
{ Copyright (C) 2016-2017 Andreas Maschke                                      }
{ ---------------------------------------------------------------------------- }
unit BulbTracerUI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, TypeDefinitions, ComCtrls,
  Contnrs, VertexList, BulbTracerConfig, Vcl.Tabs, BulbTracerUITools,
  JvExStdCtrls, JvGroupBox, TrackBarEx, ObjectScanner, Generics.Collections,
  SyncObjs;

type
  TFVoxelExportCalcPreviewThread = class(TThread)
  private
    { Private-Deklarationen }
    Iteration3Dext: TIteration3Dext;
  public
    { Public-Deklarationen }
    MCTparas: TMCTparameter;
  protected
    procedure Execute; override;
  end;
  TFVoxelExportCalcThread = class(TThread)
  private
    { Private-Deklarationen }
    Iteration3Dext: TIteration3Dext;
  public
    { Public-Deklarationen }
    MCTparas: TMCTparameter;
  protected
    procedure Execute; override;
  end;

  TParamSource = (psMain, psSingleFile, psFileSequence);

  TBulbTracerFrm = class(TForm)
    Panel2: TPanel;
    Button1: TButton;
    SaveDialog: TSaveDialog;
    Timer1: TTimer;
    Label13: TLabel;
    Timer2: TTimer;
    Timer3: TTimer;
    CalculateBtn: TButton;
    ProgressBar: TProgressBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    PageControl2: TPageControl;
    TabSheet2: TTabSheet;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Edit1: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    ImportParamsFromMainBtn: TButton;
    RadioGroup1: TRadioGroup;
    Edit8: TEdit;
    Edit9: TEdit;
    CheckBox3: TCheckBox;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    UpDown4: TUpDown;
    UpDown5: TUpDown;
    UpDown6: TUpDown;
    UpDown7: TUpDown;
    UpDown8: TUpDown;
    UpDown9: TUpDown;
    RadioGroup3: TRadioGroup;
    Button6: TButton;
    Edit11: TEdit;
    UpDown10: TUpDown;
    RadioGroup4: TRadioGroup;
    Edit12: TEdit;
    UpDown11: TUpDown;
    PageControl3: TPageControl;
    TabSheet3: TTabSheet;
    Panel4: TPanel;
    Image1: TImage;
    Button5: TButton;
    RadioGroup2: TRadioGroup;
    CheckBox2: TCheckBox;
    CancelBtn: TButton;
    Panel7: TPanel;
    FilenameREd: TEdit;
    Button3: TButton;
    Panel8: TPanel;
    MeshPropertiesNBk: TNotebook;
    Panel6: TPanel;
    Label18: TLabel;
    MeshVResolutionEdit: TEdit;
    MeshVResolutionUpDown: TUpDown;
    Panel5: TPanel;
    Label17: TLabel;
    UStepsEdit: TEdit;
    UStepsUpDown: TUpDown;
    MeshTypeCmb: TComboBox;
    Label7: TLabel;
    MeshVResolutionLbl: TLabel;
    Label19: TLabel;
    CancelTypeCmb: TComboBox;
    Label20: TLabel;
    MeshOversamplingCmb: TComboBox;
    SaveTypeCmb: TComboBox;
    Label10: TLabel;
    SmoothGBox: TJvGroupBox;
    OpenGLPreviewCBx: TCheckBox;
    MeshPreviewBtn: TButton;
    Label11: TLabel;
    TaubinSmoothLambaEdit: TEdit;
    TaubinSmoothLambaUpDown: TUpDown;
    Label21: TLabel;
    TaubinSmoothMuEdit: TEdit;
    TaubinSmoothMuUpDown: TUpDown;
    Label22: TLabel;
    TaubinSmoothPassesEdit: TEdit;
    TaubinSmoothPassesEditUpDown: TUpDown;
    MeshISOValueEdit: TEdit;
    Label23: TLabel;
    MeshISOValueUpDown: TUpDown;
    Button2: TButton;
    Panel9: TPanel;
    Label24: TLabel;
    FrameEdit: TEdit;
    FrameUpDown: TUpDown;
    FrameTBar: TTrackBarEx;
    OpenDialog1: TOpenDialog;
    MeshReductionGBox: TJvGroupBox;
    Label25: TLabel;
    Label26: TLabel;
    MeshReductionRetainRatioEdit: TEdit;
    MeshReductionRetainRatioUpDown: TUpDown;
    MeshReductionAgressivenessEdit: TEdit;
    MeshReductionAgressivenessUpDown: TUpDown;
    GenCurrMeshBtn: TButton;
    MeshCalcColorsCBx: TCheckBox;
    JitterEdit: TEdit;
    CalculateNormalsCBx: TCheckBox;
    PreviewProgressBar: TProgressBar;
    Label12: TLabel;
    JitterUpDown12: TUpDown;
    Edit2: TEdit;
    Edit10: TEdit;
    Edit13: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure ImportParamsFromMainBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure UpDown4Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown5Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown6Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown7Click(Sender: TObject; Button: TUDBtnType);
    procedure Timer3Timer(Sender: TObject);
    procedure UpDown8Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown9Click(Sender: TObject; Button: TUDBtnType);
    procedure Edit10Change(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure Button6Click(Sender: TObject);
    procedure RadioGroup4Click(Sender: TObject);
    procedure UpDown10Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown11Click(Sender: TObject; Button: TUDBtnType);
    procedure CalculateBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure MeshPreviewBtnClick(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
    procedure SaveTypeCmbChange(Sender: TObject);
    procedure CancelTypeCmbChange(Sender: TObject);
    procedure MeshVResolutionEditChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TaubinSmoothLambaUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TaubinSmoothMuUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure TaubinSmoothPassesEditUpDownClick(Sender: TObject;
      Button: TUDBtnType);
    procedure MeshISOValueUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure Button2Click(Sender: TObject);
    procedure FrameUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure FrameEditExit(Sender: TObject);
    procedure FrameTBarChange(Sender: TObject);
    procedure FrameTBarMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MeshReductionRetainRatioUpDownClick(Sender: TObject;
      Button: TUDBtnType);
    procedure MeshReductionAgressivenessUpDownClick(Sender: TObject;
      Button: TUDBtnType);
    procedure MeshTypeCmbChange(Sender: TObject);
    procedure JitterUpDown12Click(Sender: TObject; Button: TUDBtnType);
  private
    { Private-Deklarationen }
  //  PreviewVoxel: array of Cardinal;   //buffer to not calc everything again if shifted position
    T0: Int64;
    PVwid, PVhei, PVdep: Integer;
    VCalcThreadStats: TCalcThreadStats;
    PaintedYsofar, vActiveThreads, PreviewSize: Integer;
    CalcPreview{, PrCalcedAll}: LongBool; //to verify if PreviewVoxel array is complete
    VsiLight: array of Cardinal;  //just 0..255 for color
    FThreadVertexLists, FThreadNormalsLists, FThreadColorsLists: TObjectList;
    FSavePartIdx: Integer;
    FSaveType: TMeshSaveType;
    FVertexGenConfig: TVertexGenConfig;
    FCalculating, FForceAbort: Boolean;
    FCancelType: TCancelType;
    FRefreshing: Boolean;
    FSavePartCriticalSection: TCriticalSection;
    procedure PutOutputFolder2record;
    procedure GetOutputFolderFromrecord;
    procedure MakeM3V;
    procedure SetFromM3V;
    procedure CalcImageSize;
    function StartSlicePreview(nr: Integer): LongBool;
    procedure PaintNextPreviewSlice(nr: Integer);
    procedure SetProjectName(FileName: String);
    procedure StartNewPreview;
    function  CalcPreviewSize: Integer;
    procedure CalcPreviewSizes;
    procedure UpdateSaveTypeCmb;
    procedure EnableMeshOptionControls;
    procedure CustomizeUI;

    function StartPLYRender: LongBool;
    procedure MergeAndSaveMesh;
    procedure UpdateVertexGenConfig;
    procedure SavePointCloud;
    procedure SaveMesh;
    function  MakeMeshSequenceFilename( const BaseFilename: String ): String;
    procedure WndProc(var Message: TMessage); override;
    function  IsPreviewCalculating: Boolean;
    procedure CancelPreview;
    procedure UpdateParamsRange;
    procedure UpdateFrameDisplay( const Frame: Integer );
    procedure ChangeFrame;
    procedure ShowTitle(const Caption: String);
    procedure StartCalc;
    procedure SetExportFilenameExt;
    procedure CheckSavePart(const Idx: Integer);
  protected
    procedure WmThreadReady(var Msg: TMessage); message WM_ThreadReady;
  public
    { Public-Deklarationen }
    FParamSource: TParamSource;
    FSingleFrame: Boolean;
    FParamFilename: String;
    FParamSequenceBaseFilename: String;
    FParamSequenceFileExt: String;
    FParamSequencePatternLength: Integer;
    FParamSequenceFrom: Integer;
    FParamSequenceTo: Integer;
    FParamSequenceCurrFrame: Integer;
    M3Vfile: TM3Vfile;
    bUserChange, bFirstShow, Benabled: LongBool;
    OutputFolder, VProjectName: String;
    FileNumber: Integer;
    HybridCustoms: array[0..5] of TCustomFormula;
    procedure EnableControls(const Enabled: Boolean);
    procedure ImportParams(const KeepScaleAndPosition: Boolean = False);
  end;

  TPLYExportCalcThread = class(TThread)
  private
    FOwner: TBulbTracerFrm;
    FPrepared: Boolean;
    FRayCaster: TRayCaster;
    FObjectScanner: TObjectScanner;
    Iteration3Dext: TIteration3Dext;
    FIterationCallback: TIterationCallback;
  public
    M3Vfile: TM3Vfile;
    MCTparas: TMCTparameter;
    VertexList: TPS3VectorList;
    NormalsList, ColorsList: TPSMI3VectorList;
    FacesList: TFacesList;
    VertexGenConfig: TVertexGenConfig;
  protected
    destructor Destroy; override;
    procedure Prepare;
    procedure Execute; override;
  end;
var
  BulbTracerFrm: TBulbTracerFrm;
  iVoxelVersion: Integer = 4;
  bBulbTracerFormCreated: LongBool = False;

implementation

uses CalcVoxelSliceThread, FileHandling, Math, Math3D, Calc, DivUtils, Mand,
  HeaderTrafos, CustomFormulas, ImageProcess, VectorMath, DateUtils, BulbTracer,
  MeshPreviewUI, MeshWriter, MeshReader, MeshIOUtil, MeshSimplifier;

{$R *.dfm}

procedure TBulbTracerFrm.PutOutputFolder2record;
var i, l: Integer;
begin
    l := Min(1023, Length(OutputFolder));
    for i := 1 to l do M3Vfile.OutputFolderC[i - 1] := Ord(OutputFolder[i]);
    M3Vfile.OutputFolderC[l] := 0;
end;

procedure TBulbTracerFrm.GetOutputFolderFromrecord;
var b: Byte;
    i: Integer;
begin
    OutputFolder := '';
    i := 0;
    repeat
      b := M3Vfile.OutputFolderC[i];
      if b > 0 then OutputFolder := OutputFolder + Chr(b);
      Inc(i);
    until (i > 1023) or (b = 0);
end;

procedure TBulbTracerFrm.Button1Click(Sender: TObject);
begin
    Visible := False;
end;

procedure TFVoxelExportCalcThread.Execute;
var d: Double;
    CC: TVec3D;
    cPsiLight: TPsiLight5;
    x, y: Integer;
begin
    with MCTparas do
    try
      IniIt3D(@MCTparas, @Iteration3Dext);
      y := CalcRect.Top + iThreadId - 1;
      while y <= CalcRect.Bottom do
      begin
        cPsiLight := TPsiLight5(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset);
        mCopyAddVecWeight(@CC, @Ystart, @Vgrads[1], y);
        for x := 0 to CalcRect.Right do
        begin
          Iteration3Dext.CalcSIT := False;
          mCopyAddVecWeight(@Iteration3Dext.C1, @CC, @Vgrads[0], x);

          if iSliceCalc = 0 then //on maxits , does not work in DEcomb mode!
          begin
            if DEoption > 19 then mMandFunctionDE(@Iteration3Dext.C1)
                             else mMandFunction(@Iteration3Dext.C1);
            if bInAndOutside then
            begin
              if (Iteration3Dext.ItResultI < iMaxIt) and
                 (Iteration3Dext.ItResultI >= AOdither) then cPsiLight.SIgradient := 1
                                                        else cPsiLight.SIgradient := 0;
            end
            else
            begin
              if Iteration3Dext.ItResultI < iMaxIt then cPsiLight.SIgradient := 0
                                                   else cPsiLight.SIgradient := 1;
              if bInsideRendering then cPsiLight.SIgradient := 1 - cPsiLight.SIgradient;
            end;
          end
          else
          begin
            d := CalcDE(@Iteration3Dext, @MCTparas);   //in+outside: only if d between dmin and dmax
            if d < DEstop then
            begin
              if bInAndOutside and (d < DEAOmaxL) then cPsiLight.SIgradient := 0
                                                  else cPsiLight.SIgradient := 1;
            end
            else cPsiLight.SIgradient := 0;
          end;
          Inc(cPsiLight);
          if PCalcThreadStats.pLBcalcStop^ then Break;
        end;
        PCalcThreadStats.CTrecords[iThreadID].iActualYpos := y;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        Inc(y, iThreadCount);
      end;
    finally
      PCalcThreadStats.CTrecords[iThreadID].isActive := 0;
      if not PCalcThreadStats.pLBcalcStop^ then
        PCalcThreadStats.CTrecords[iThreadID].iActualYpos := iMandHeight;
      PostMessage(PCalcThreadStats.pMessageHwnd, WM_ThreadReady, 0, 0);
    end;
end;

procedure TFVoxelExportCalcPreviewThread.Execute;
var d: Double;
    CC: TVec3D;
    cLi: PCardinal;
    x, y: Integer;
begin
    with MCTparas do
    try
      IniIt3D(@MCTparas, @Iteration3Dext);
      y := CalcRect.Top + iThreadId - 1;
      while y <= CalcRect.Bottom do
      begin
        cLi := PCardinal(Integer(pSiLight) + (y - CalcRect.Top) * SLoffset);
        mCopyAddVecWeight(@CC, @Ystart, @Vgrads[1], y);
        for x := 0 to CalcRect.Right do
        begin
          Iteration3Dext.CalcSIT := False;
          mCopyAddVecWeight(@Iteration3Dext.C1, @CC, @Vgrads[0], x);
          if iSliceCalc = 0 then //on maxits , does not work in DEcomb mode!
          begin
            if DEoption > 19 then mMandFunctionDE(@Iteration3Dext.C1)
                             else mMandFunction(@Iteration3Dext.C1);
            if bInAndOutside then
            begin
              if (Iteration3Dext.ItResultI < iMaxIt) and
                 (Iteration3Dext.ItResultI >= AOdither) then cLi^ := 1 else cLi^ := 0;
            end                              //minits
            else
            begin
              if Iteration3Dext.ItResultI < iMaxIt then cLi^ := 0 else cLi^ := 1;
              if bInsideRendering then cLi^ := 1 - cLi^;
            end;
          end
          else
          begin
            d := CalcDE(@Iteration3Dext, @MCTparas);   //in+outside: only if d between dmin and dmax
            if d < DEstop then
            begin
              if bInAndOutside and (d < DEAOmaxL) then cLi^ := 0 else cLi^ := 1;
            end                        //MinDE
            else cLi^ := 0;
          end;
          Inc(cLi);
          if PCalcThreadStats.pLBcalcStop^ then Break;
        end;
        if PCalcThreadStats.pLBcalcStop^ then Break;
        Inc(y, iThreadCount);
      end;
    finally
      PCalcThreadStats.CTrecords[iThreadID].isActive := 0;
      PostMessage(PCalcThreadStats.pMessageHwnd, WM_ThreadReady, 0, 0);
    end;
end;

function TBulbTracerFrm.StartSlicePreview(nr: Integer): LongBool;
var VoxCalcThreads: array of TFVoxelExportCalcPreviewThread;
    x, ThreadCount: Integer;
    MCTparas: TMCTparameter;
    d: Double;
begin
  ThreadCount := Min(Mand3DForm.UpDown3.Position, PreviewSize);
  try
    M3Vfile.VHeader.TilingOptions := 0;
    bGetMCTPverbose := False;
    MCTparas := getMCTparasFromHeader(M3Vfile.VHeader, False);
    bGetMCTPverbose := True;
    Result := MCTparas.bMCTisValid;
    if Result then
    begin
      MCTparas.pSiLight := @VsiLight[0];
      MCTparas.SLoffset := PVwid * SizeOf(Cardinal);
      MCTparas.PCalcThreadStats := @VCalcThreadStats;
      with M3Vfile do
      begin
        if UseDefaultOrientation then BuildRotMatrix(0, 0, 0, @MCTparas.VGrads);
        MCTparas.CalcRect := Rect(0, 0, PVwid - 1, PVhei - 1);
        d := 2.2 / (VHeader.dZoom * Zscale * Max(1, PVdep - 1));
        MCTparas.VGrads := NormaliseMatrixTo(d, @MCTparas.VGrads);
    //    d := (PVwid - 1) / 64;
        MCTparas.Ystart := TPVec3D(@VHeader.dXmid)^;
        mAddVecWeight(@MCTparas.Ystart, @MCTparas.Vgrads[0], PVwid * -0.5 + Xoff / d);
        mAddVecWeight(@MCTparas.Ystart, @MCTparas.Vgrads[1], PVhei * -0.5 + Yoff / d);
        mAddVecWeight(@MCTparas.Ystart, @MCTparas.Vgrads[2], nr - PVdep * 0.5 + Zoff / d);
        MCTparas.iSliceCalc := ObjectD;  //modus: on DE or on Its
        MCTparas.AOdither := MinIts;
        MCTparas.DEAOmaxL := MinDE;
      end;
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

procedure TBulbTracerFrm.TaubinSmoothLambaUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(TaubinSmoothLambaEdit.Text, 0.0) + UpDownBtnValue(Button, 0.1);
  TaubinSmoothLambaEdit.Text := FloatToStr(Value);
end;

procedure TBulbTracerFrm.TaubinSmoothMuUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(TaubinSmoothMuEdit.Text, 0.0) + UpDownBtnValue(Button, 0.1);
  TaubinSmoothMuEdit.Text := FloatToStr(Value);
end;

procedure TBulbTracerFrm.TaubinSmoothPassesEditUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(TaubinSmoothPassesEdit.Text, 0.0) + UpDownBtnValue(Button, 1);
  if Value < 0 then
    Value := 0.0;
  TaubinSmoothPassesEdit.Text := IntToStr(Round(Value));
end;

procedure TBulbTracerFrm.Timer1Timer(Sender: TObject);   // proof if threads are still calculating
var
  y, ymin, hei, it, il: Integer;
  Progress: Integer;
  FacesList: TFacesList;
begin
    Timer1.Enabled := False;
    ymin := 999999;
    hei := M3Vfile.VHeader.Height;
    it := 0;
    Progress := 0;
    with VCalcThreadStats do begin
      for y := 1 to iTotalThreadCount do begin
        Progress := Progress + CTrecords[y].iActualYpos;
        if CTrecords[y].isActive <> 0 then Inc(it);
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
//        Label13.Caption := '';
      finally
        FCalculating := False;
        EnableControls(True);

        if ( FParamSource = psFileSequence ) and ( not FSingleFrame ) then begin
          if ( not FForceAbort ) and  ( FParamSequenceCurrFrame < FParamSequenceTo ) then begin
            Inc( FParamSequenceCurrFrame );
            UpdateFrameDisplay( FParamSequenceCurrFrame );
            ImportParams( True );
            CancelPreview;
            StartCalc;
          end;
        end;
      end;
    end
    else begin
      ProgressBar.Position := Progress;
      Timer1.Enabled := True;
    end;
end;

procedure TBulbTracerFrm.WmThreadReady(var Msg: TMessage);
begin
    if Msg.LParam = 0 then begin
      Dec(vActiveThreads);
      if vActiveThreads = 0 then begin
        if CalcPreview then Timer2.Interval := 1
                       else Timer1.Interval := 5;
      end;
    end;
end;

procedure TBulbTracerFrm.MakeM3V;
begin
    with M3Vfile do  begin
      Xoff := StrToFloatK(Edit1.Text);
      Yoff := StrToFloatK(Edit3.Text);
      Zoff := StrToFloatK(Edit4.Text);
      Xscale := StrToFloatK(Edit5.Text);
      Yscale := StrToFloatK(Edit6.Text);
      Zscale := StrToFloatK(Edit7.Text);
      UseDefaultOrientation := CheckBox3.Checked;
      Zslices := 100;
      ObjectD := RadioGroup1.ItemIndex;
      MaxIts := StrToInt(Edit8.Text);
      DE := StrToFloatK(Edit9.Text);
      MinIts := StrToInt(Edit11.Text);
      MinDE := MaxCD(DE * 0.254, StrToFloatK(Edit12.Text));
      VoxelVersion := iVoxelVersion;
      FillChar(PlaceForFuturePars, SizeOf(PlaceForFuturePars), 0);
      OutputFolder := '';
      PutOutputFolder2record;
      VHAddon.bOptions2 := (VHAddon.bOptions2 and $F9) or (RadioGroup4.ItemIndex shl 1);
    end;
end;

procedure TBulbTracerFrm.CalcImageSize;
var d: Double;
begin
    with M3Vfile do
    begin
      d := Zslices / MaxCD(1e-40, Zscale);
      VHeader.Width := Round(Xscale * d);
      VHeader.Height := Round(Yscale * d);
    end;
end;

procedure TBulbTracerFrm.SetFromM3V;
var b: LongBool;
    i: Integer;
begin
    with M3Vfile do
    begin
      b := bUserChange;
      bUserChange := False;
      Edit1.Text := FloatToStr(Xoff);
      Edit5.Text := FloatToStr(Xscale);
      Edit3.Text := FloatToStr(Yoff);
      Edit6.Text := FloatToStr(Yscale);
      Edit4.Text := FloatToStr(Zoff);
      Edit7.Text := FloatToStr(Zscale);
      RadioGroup1.ItemIndex := ObjectD;
      Edit8.Text := IntToStr(MaxIts);
      Edit9.Text := FloatToStr(DE);
      Edit11.Text := IntToStr(MinIts);
      Edit12.Text := FloatToStrSingle(MinDE);
      RadioGroup4.ItemIndex := (VHAddon.bOptions2 shr 1) and 3;
      GetOutputFolderFromrecord;
      CheckBox3.Checked := UseDefaultOrientation;
      CalcImageSize;
      // Label12.Caption := IntToStr(VHeader.Width) + ' x ' + IntToStr(VHeader.Height);
      bUserChange := b;
      VHeader.PCFAddon := @VHAddon;
      for i := 0 to 5 do VHeader.PHCustomF[i] := @HybridCustoms[i];
    end;
end;

procedure TBulbTracerFrm.SetProjectName(FileName: String);
begin
    VProjectName := ChangeFileExtSave(ExtractFileName(FileName), '');
end;

procedure TBulbTracerFrm.ImportParamsFromMainBtnClick(Sender: TObject);
begin
  FParamSource := psMain;
  UpdateParamsRange;
  ImportParams;
  CustomizeUI;
end;

procedure TBulbTracerFrm.ImportParams(const KeepScaleAndPosition: Boolean = False);
var i: Integer;
    d: Double;
    CurrFilename: String;

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

    with M3Vfile do
    begin
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
      end
      else if FParamSource = psFileSequence then begin
        CurrFilename := GetSequenceFilename(
          FParamSequenceBaseFilename, FParamSequenceFileExt, FParamSequencePatternLength, FParamSequenceCurrFrame );
        LoadParamFromFile( CurrFilename );
        Mand3DForm.ParasChanged;
        Mand3DForm.ClearScreen;
        Mand3DForm.MakeHeader;
        AssignHeader(@VHeader, @Mand3DForm.MHeader);
        ShowTitle( ExtractFilename( CurrFilename ) );
      end;

      DisableTiling(@VHeader);
      VHeader.TilingOptions := 0;

      if not KeepScaleAndPosition then begin
        Xoff := 0;
        Yoff := 0;
        Zoff := 0;
        Xscale := 1;
        Yscale := 1;
        Zscale := 1;
      end;

      Zslices := 100;
      ObjectD := 1;
      OrigWidth := VHeader.Width;
      MaxIts := VHeader.Iterations;
      MinIts := MaxIts div 2;
      UseDefaultOrientation := True;
      if VHeader.bVaryDEstopOnFOV > 0 then    //calc DE @ Zmid when VaryDEstopOnFOV
        d := (1 + 0.3 / VHeader.sDEStop) * Max(0, VHeader.dFOVy * Pid180) *
             (VHeader.dZoom * VHeader.Width) / (VHeader.Height * 2.1345)
      else d := 0;
      DE := Max(0.2, VHeader.sDEstop * (1 + (VHeader.dZmid - VHeader.dZstart) * d) * Zslices / VHeader.Width);
      MinDE := DE * 0.254;
      FillChar(PlaceForFuturePars, SizeOf(PlaceForFuturePars), 0);
    end;
    SetProjectName('new');
    SetFromM3V;
    Benabled := True;
    EnableControls(True);
    StartNewPreview;
end;

procedure TBulbTracerFrm.FormShow(Sender: TObject);
begin
    bUserChange := True;
    if bFirstShow then
    begin
      RadioGroup1.Hint :=' Type of object determination, lowering Max its or increasing DE' + #13#10 +
'(dependend on the choosen option), will make the object thicker.' + #13#10 +
'Note:  DEcombinate formulas work only in the Distance estimation mode!';
      SaveDialog.InitialDir := IniDirs[12];
      bFirstShow := False;
      OutputFolder := IniDirs[12];
      PutOutputFolder2record;
      VProjectName := 'new';

      MeshTypeCmb.ItemIndex := 1;
      MeshTypeCmbChange(Sender);
      SaveTypeCmb.ItemIndex := 0;
      if(OutputFolder<>'') then begin
        FilenameREd.Text := IncludeTrailingPathDelimiter(OutputFolder)+GetDefaultMeshFilename('mb3d_mesh', TPointCloudSaveType(SaveTypeCmb.ItemIndex));
      end;
      CheckBox3.Checked := True;
    end;

end;

procedure TBulbTracerFrm.FrameEditExit(Sender: TObject);
begin
  ChangeFrame;
end;

procedure TBulbTracerFrm.FrameTBarChange(Sender: TObject);
begin
  FrameEdit.Text := IntToStr( FrameTBar.Position );
  ChangeFrame;
end;

procedure TBulbTracerFrm.FrameTBarMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FrameTBarChange( Sender );
end;

procedure TBulbTracerFrm.FrameUpDownClick(Sender: TObject; Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(FrameEdit.Text, 0.0) + UpDownBtnValue(Button, 1);
  if Value < FParamSequenceFrom then
    Value := FParamSequenceFrom;
  if Value > FParamSequenceTo then
    Value := FParamSequenceTo;
  FrameEdit.Text := IntToStr(Round(Value));
  ChangeFrame;
end;

procedure TBulbTracerFrm.Edit1Change(Sender: TObject);
begin
    if bUserChange then
    begin
      MakeM3V;
      CalcImageSize;
      // Label12.Caption := IntToStr(M3Vfile.VHeader.Width) + ' x ' + IntToStr(M3Vfile.VHeader.Height);
      StartNewPreview;
    end;
end;

procedure TBulbTracerFrm.FormCreate(Sender: TObject);
var i: Integer;
begin
  FRefreshing := True;
  try
    FSavePartCriticalSection := TCriticalSection.Create;
    FParamSource := psMain;
    UpdateParamsRange;
    FThreadVertexLists := TObjectList.Create;
    FThreadNormalsLists := TObjectList.Create;
    FThreadColorsLists := TObjectList.Create;
    FVertexGenConfig := TVertexGenConfig.Create;
    bFirstShow := True;
    Benabled := False;
    for i := 0 to 5 do IniCustomF(@HybridCustoms[i]);
    bBulbTracerFormCreated := True;
    Panel4.DoubleBuffered := True;

    FCancelType := ctCancelAndShowResult;
    CancelTypeCmb.ItemIndex := Ord(FCancelType);

    MeshTypeCmb.ItemIndex := 0;

    TaubinSmoothLambaEdit.Text := FloatToStr(0.42);
    TaubinSmoothMuEdit.Text := FloatToStr(-0.45);
    TaubinSmoothPassesEdit.Text := IntToStr(12);

    MeshReductionRetainRatioEdit.Text := FloatToStr(0.25);
    MeshReductionAgressivenessEdit.Text := FloatToStr(7.0);

  finally
    FRefreshing := False;
  end;
end;

procedure TBulbTracerFrm.FormDestroy(Sender: TObject);
begin
  FThreadVertexLists.Free;
  FThreadNormalsLists.Free;
  FThreadColorsLists.Free;
  FVertexGenConfig.Free;
  FSavePartCriticalSection.Free;
end;

procedure TBulbTracerFrm.CalcPreviewSizes;
var d: Double;
begin
    with M3Vfile do
    begin
      PreviewSize := CalcPreviewSize;
      d := 1 / MaxCD(MaxCD(Zscale, Yscale), Xscale);
      PVwid := Round(PreviewSize * Xscale * d);
      PVhei := Round(PreviewSize * Yscale * d);
      PVdep := Round(PreviewSize * Zscale * d);
    end;
end;

function TBulbTracerFrm.CalcPreviewSize: Integer;
begin
  Result := 16 shl RadioGroup2.ItemIndex;
end;

procedure TBulbTracerFrm.Button2Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
    if GuessSequence( OpenDialog1.FileName, FParamSequenceBaseFilename, FParamSequenceFileExt,
      FParamSequencePatternLength, FParamSequenceFrom, FParamSequenceTo, FParamSequenceCurrFrame ) then begin
      FParamSource := psFileSequence;
      UpdateParamsRange;
      ImportParams;
    end
    else begin
      FParamSource := psSingleFile;
      FParamFilename := OpenDialog1.FileName;
      UpdateParamsRange;
      ImportParams;
    end;
  end;
end;

procedure TBulbTracerFrm.Button3Click(Sender: TObject);
begin
  try
    UpdateSaveTypeCmb;
    if FVertexGenConfig.MeshType = mtMesh then begin
      SaveDialog.DefaultExt := GetMeshFileExt(TMeshSaveType(SaveTypeCmb.ItemIndex));
      SaveDialog.Filter := GetMeshFileFilter(TMeshSaveType(SaveTypeCmb.ItemIndex));
    end
    else begin
      SaveDialog.DefaultExt := GetMeshFileExt(TPointCloudSaveType(SaveTypeCmb.ItemIndex));
      SaveDialog.Filter := GetMeshFileFilter(TPointCloudSaveType(SaveTypeCmb.ItemIndex));
    end;
    SaveDialog.InitialDir := ExtractFilePath(FilenameREd.Text);
    SaveDialog.FileName := FilenameREd.Text;
    if SaveDialog.Execute(Self.Handle) then
      FilenameREd.Text := SaveDialog.FileName;
  except
    // Hide error
  end;
end;

procedure TBulbTracerFrm.Button5Click(Sender: TObject);  //calc preview
begin
    if Button5.Caption = 'Stop' then
    begin
      MCalcStop := True;
  //    Inc(CalcVoxelPreviewIndex);
    end
    else begin
      PreviewProgressBar.Position := 0;
      PreviewProgressBar.Max := CalcPreviewSize;
      MakeM3V;
      CalcPreviewSizes;
    //  Mand3DForm.bCalcTile := False;
      FileNumber := PVdep;
      SetLength(VsiLight, PreviewSize * PreviewSize);
      CalcPreview := True;
      Image1.Canvas.Brush.Color := $203040;
      Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
      Image1.Picture.Bitmap.PixelFormat := pf32bit;
      M3Vfile.VHeader.sDEstop := M3Vfile.DE * PVwid / M3Vfile.VHeader.Width;
      M3Vfile.VHeader.Iterations := M3Vfile.MaxIts;
      M3Vfile.VHeader.TilingOptions := 0;
      MCalcStop := False;  //because only in DisableButtons else, to late for first filenumber
      if StartSlicePreview(FileNumber) then
      begin
        Button5.Caption := 'Stop';
      end;
    end;
end;


procedure TBulbTracerFrm.PaintNextPreviewSlice(nr: Integer);
var x, y, y2, i, j, i2, i3, i4, im, ik: Integer;
    PSLstart, PLoffset, bmpSL, bmpOffset, bmpOffP: Integer;
    PC, PSL: PCardinal;
begin
    PreviewProgressBar.StepIt;
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
            if PSL^ > 0 then PC^ := i2;
            Inc(PSL);
            Inc(PC);
          end;
        end;
      end;
      Modified := True;
    end;
end;

procedure TBulbTracerFrm.Timer2Timer(Sender: TObject);  //preview threads
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

procedure TBulbTracerFrm.UpDown4Click(Sender: TObject; Button: TUDBtnType);
var d: Double;
    b: LongBool;
begin
    MakeM3V;
    if RadioGroup3.ItemIndex = 0 then d := 1.1 else d := 1.01;
    if Button <> btNext then d := 1 / d;
    ScaleVectorV(@M3Vfile.Xscale, d);
    b := bUserChange;
    bUserChange := False;
    Edit5.Text := FloatToStrSingle(M3Vfile.Xscale);
    Edit6.Text := FloatToStrSingle(M3Vfile.Yscale);
    Edit7.Text := FloatToStrSingle(M3Vfile.Zscale);
    bUserChange := b;
    if b then StartNewPreview;
end;

procedure TBulbTracerFrm.UpDown5Click(Sender: TObject; Button: TUDBtnType);
var d: Double;
begin
    d := 2.2 / (M3Vfile.VHeader.dZoom * M3Vfile.Zscale * Max(1, PVdep - 1));
    if Button = btNext then d := -d;
    M3Vfile.Xoff := M3Vfile.Xoff + d;
    Edit1.Text := FloatToStrSingle(M3Vfile.Xoff);
end;

procedure TBulbTracerFrm.UpDown6Click(Sender: TObject; Button: TUDBtnType);
var d: Double;
begin
    d := -2.2 / (M3Vfile.VHeader.dZoom * M3Vfile.Zscale * Max(1, PVdep - 1));
    if Button = btNext then d := -d;
    M3Vfile.Yoff := M3Vfile.Yoff + d;
    Edit3.Text := FloatToStrSingle(M3Vfile.Yoff);
end;

procedure TBulbTracerFrm.UpDown7Click(Sender: TObject; Button: TUDBtnType);
var d: Double;
begin
    d := 2.2 / (M3Vfile.VHeader.dZoom * M3Vfile.Zscale * Max(1, PVdep - 1));
    if Button = btNext then d := -d;
    M3Vfile.Zoff := M3Vfile.Zoff + d;
    Edit4.Text := FloatToStrSingle(M3Vfile.Zoff);
end;

procedure TBulbTracerFrm.StartNewPreview;
begin
    if CheckBox2.Checked then
    begin
      MCalcStop := True;
      Timer3.Enabled := True;
    end
    else Timer3.Enabled := False;
end;


procedure TBulbTracerFrm.Timer3Timer(Sender: TObject);
var y, it: Integer;
begin
    Timer3.Enabled := False;
    it := 0;
    with VCalcThreadStats do
      for y := 1 to iTotalThreadCount do
        if CTrecords[y].isActive <> 0 then Inc(it);
    if Button5.Enabled and (it = 0) and (Button5.Caption <> 'Stop') then //calc done
    begin
     // RadioGroup2.ItemIndex := 0;
      Button5Click(Self);
    end
    else Timer3.Enabled := True;
end;

procedure TBulbTracerFrm.UpDown8Click(Sender: TObject; Button: TUDBtnType);
begin
    if Button = btNext then Inc(M3Vfile.MaxIts) else Dec(M3Vfile.MaxIts);
    Edit8.Text := IntToStr(M3Vfile.MaxIts);
end;

procedure TBulbTracerFrm.UpDown9Click(Sender: TObject; Button: TUDBtnType);
var d: Double;
begin
    d := Sqrt(2);
    if Button <> btNext then d := 1 / d;
    M3Vfile.DE := M3Vfile.DE * d;
    M3Vfile.MinDE := MaxCD(M3Vfile.MinDE, M3Vfile.DE * 0.254);
    bUserChange := False;
    Edit12.Text := FloatToStrSingle(M3Vfile.MinDE);
    bUserChange := True;
    Edit9.Text := FloatToStrSingle(M3Vfile.DE);
end;

function TBulbTracerFrm.IsPreviewCalculating: Boolean;
begin
  Result := Button5.Caption = 'Stop';
end;

procedure TBulbTracerFrm.CancelBtnClick(Sender: TObject);
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

procedure TBulbTracerFrm.CancelPreview;
begin
  MCalcStop := True;
  Timer2.Enabled := False;
  Mand3DForm.EnableButtons;
end;

procedure TBulbTracerFrm.CancelTypeCmbChange(Sender: TObject);
begin
  if (not FRefreshing) then
    FCancelType := TCancelType(CancelTypeCmb.ItemIndex);
end;

procedure TBulbTracerFrm.RadioGroup2Click(Sender: TObject);
begin
  if CheckBox2.Checked then begin
    CancelPreview;
    Button5Click(nil);
  end;
end;

procedure TBulbTracerFrm.RadioGroup4Click(Sender: TObject);
var b, b2, bt: LongBool;
begin      //in/out option
    b := RadioGroup4.ItemIndex = 2;
    b2 := RadioGroup1.ItemIndex = 0;
    Label15.Visible := b and b2;
    Edit11.Visible := b and b2;
    UpDown10.Visible := b and b2;
    Label16.Visible := b and not b2;
    Edit12.Visible := b and not b2;
    UpDown11.Visible := b and not b2;
    if b then
    begin
      bt := bUserChange;
      bUserChange := False;
      Edit11.Text := IntToStr(M3Vfile.MinIts);
      Edit12.Text := FloatToStrSingle(M3Vfile.MinDE);
      bUserChange := bt;
    end;
    if bUserChange then StartNewPreview;
end;

procedure TBulbTracerFrm.Edit10Change(Sender: TObject);  //Zslices
begin
    if bUserChange then
    begin
      MakeM3V;
      CalcImageSize;
      // Label12.Caption := IntToStr(M3Vfile.VHeader.Width) + ' x ' + IntToStr(M3Vfile.VHeader.Height);
    end;                     
end;

procedure TBulbTracerFrm.UpDown10Click(Sender: TObject; Button: TUDBtnType);
begin
    if Button = btNext then Inc(M3Vfile.MinIts) else Dec(M3Vfile.MinIts);
    Edit11.Text := IntToStr(M3Vfile.MinIts);
end;

procedure TBulbTracerFrm.UpDown11Click(Sender: TObject; Button: TUDBtnType);
var d: Double;
begin
    d := Sqrt(2);
    if Button <> btNext then d := 1 / d;
    M3Vfile.MinDE := MaxCD(M3Vfile.MinDE * d, M3Vfile.DE * 0.254);
    Edit12.Text := FloatToStrSingle(M3Vfile.MinDE);
end;

procedure TBulbTracerFrm.JitterUpDown12Click(Sender: TObject; Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(JitterEdit.Text, 0.0) + UpDownBtnValue(Button, 0.05);
  if Value <= 0.0 then
    Value := 0.0
  else if Value > 1.0 then
    Value := 1.0;
  JitterEdit.Text := FloatToStr(Value);
end;

procedure TBulbTracerFrm.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var d: Double;
    t: Integer;
begin
    MakeM3V;
    if RadioGroup3.ItemIndex = 0 then d := 1.1 else d := 1.01;
    if Button <> btNext then d := 1 / d;
    t := (Sender as TUpDown).Tag;
    PDouble(Integer(@M3Vfile.Xscale) + t * 8)^ := PDouble(Integer(@M3Vfile.Xscale) + t * 8)^ * d;
    (FindComponent('Edit'+IntToStr(5 + t)) as TEdit).Text :=
      FloatToStrSingle(PDouble(Integer(@M3Vfile.Xscale) + t * 8)^);
end;

procedure TBulbTracerFrm.Button6Click(Sender: TObject);
begin
    bUserChange := False;
    Edit1.Text := '0';
    Edit3.Text := '0';
    Edit4.Text := '0';
    Edit5.Text := '1';
    Edit6.Text := '1';
    Edit7.Text := '1';
    bUserChange := True;
    Edit1Change(Sender);
end;

procedure TBulbTracerFrm.CalculateBtnClick(Sender: TObject);
var
  DoSave: boolean;
begin
  if not FCalculating then begin
    DoSave := ( ( FVertexGenConfig.MeshType = mtMesh ) and ( TMeshSaveType(SaveTypeCmb.ItemIndex) <> stNoSave ) ) or
              ( ( FVertexGenConfig.MeshType = mtPointCloud ) and ( TPointCloudSaveType(SaveTypeCmb.ItemIndex) <> pstNoSave ) );

    if DoSave and (FilenameREd.Text = '') then begin
      Button3Click(Sender);
      if FilenameREd.Text = '' then
        Exit;
    end;

    FSingleFrame := Sender = GenCurrMeshBtn;

    if ( FParamSource = psFileSequence ) and ( Sender <> GenCurrMeshBtn ) then begin
      FParamSequenceCurrFrame := FParamSequenceFrom;
      UpdateFrameDisplay( FParamSequenceCurrFrame );
      ImportParams( True );
      CancelPreview;
    end;

    StartCalc;
  end;
end;

procedure TBulbTracerFrm.StartCalc;
begin
  FForceAbort := False;
  FCalculating := True;
  CancelPreview;
  EnableControls(True);
  MakeM3V;
//   Mand3DForm.bCalcTile := False;
  ImageScale := 1;
  SetLength(Mand3DForm.siLight5, M3Vfile.VHeader.Width * M3Vfile.VHeader.Height);
  Mand3DForm.mSLoffset := M3Vfile.VHeader.Width * SizeOf(TsiLight5);
  Mand3DForm.MHeader.Width := M3Vfile.VHeader.Width;
  Mand3DForm.MHeader.Height := M3Vfile.VHeader.Height;
  SetImageSize;
  CalcPreview := False;
  M3Vfile.VHeader.sDEstop := M3Vfile.DE;
  M3Vfile.VHeader.Iterations := M3Vfile.MaxIts;
  UpdateVertexGenConfig;
  T0 := DateUtils.MilliSecondsBetween(Now, 0);
  StartPLYRender;
end;

function TBulbTracerFrm.StartPLYRender: LongBool;
var
  PLYCalcThreads: array of TPLYExportCalcThread;
  x, ThreadCount: Integer;
  MCTparas: TMCTparameter;
  d: Double;
begin
  try
    FSavePartIdx := 0;
    FThreadVertexLists.Clear;
    FThreadNormalsLists.Clear;
    FThreadColorsLists.Clear;
    ThreadCount := Min(Mand3DForm.UpDown3.Position, M3Vfile.VHeader.Height);
  ////
//   ThreadCount := 1;
  ////

    if FVertexGenConfig.MeshType = mtMesh then
      FSaveType := TMeshSaveType( SaveTypeCmb.ItemIndex );

    M3Vfile.VHeader.TilingOptions := 0;
    bGetMCTPverbose := False;
    MCTparas := getMCTparasFromHeader(M3Vfile.VHeader, False);
    bGetMCTPverbose := True;
    Result := MCTparas.bMCTisValid;
    if Result then begin
      MCTparas.pSiLight := @Mand3DForm.siLight5[0];
      MCTparas.PCalcThreadStats := @VCalcThreadStats;
      MCTparas.CalcRect := Rect(0, 0, M3Vfile.VHeader.Width - 1, M3Vfile.VHeader.Height - 1);
      //calc VGrads to get the desired slice:
      if M3Vfile.UseDefaultOrientation then BuildRotMatrix(0, 0, 0, @MCTparas.VGrads);
      d := 2.2 / (M3Vfile.VHeader.dZoom * M3Vfile.Zscale * (M3Vfile.Zslices - 1)); //new stepwidth
      MCTparas.VGrads := NormaliseMatrixTo(d, @MCTparas.VGrads);
  //    d := (M3Vfile.VHeader.Width - 1) / 64;
      MCTparas.Ystart := TPVec3D(@M3Vfile.VHeader.dXmid)^;                                   //abs offs!
      mAddVecWeight(@MCTparas.Ystart, @MCTparas.Vgrads[0], M3Vfile.VHeader.Width * -0.5 + M3Vfile.Xoff / d);
      mAddVecWeight(@MCTparas.Ystart, @MCTparas.Vgrads[1], M3Vfile.VHeader.Height * -0.5 + M3Vfile.Yoff / d);
      mAddVecWeight(@MCTparas.Ystart, @MCTparas.Vgrads[2], M3Vfile.Zslices * -0.5 + M3Vfile.Zoff / d);
      MCTparas.iSliceCalc := M3Vfile.ObjectD;
      MCTparas.AOdither := M3Vfile.MinIts;
      MCTparas.DEAOmaxL := M3Vfile.MinDE;
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
          PLYCalcThreads[x - 1].M3Vfile         := M3Vfile;
          PLYCalcThreads[x - 1].VertexGenConfig := FVertexGenConfig;
          case FVertexGenConfig.MeshType of
            mtPointCloud:
              begin
                PLYCalcThreads[x - 1].VertexList     := TPS3VectorList.Create;
                PLYCalcThreads[x - 1].NormalsList    := TPSMI3VectorList.Create;
                PLYCalcThreads[x - 1].ColorsList     := TPSMI3VectorList.Create;
                FThreadVertexLists.Add(PLYCalcThreads[x - 1].VertexList);
                FThreadNormalsLists.Add(PLYCalcThreads[x - 1].NormalsList);
                FThreadColorsLists.Add(PLYCalcThreads[x - 1].ColorsList);
              end;
            mtMesh:
              begin
                PLYCalcThreads[x - 1].FacesList      := TFacesList.Create;
                FThreadVertexLists.Add(PLYCalcThreads[x - 1].FacesList);
              end;
          end;
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
      for x := 0 to ThreadCount - 1 do PLYCalcThreads[x].Prepare;
      for x := 0 to ThreadCount - 1 do PLYCalcThreads[x].Start;
      Mand3DForm.DisableButtons;
      Label13.Caption := 'Tracing object...';
      Timer1.Interval := 200;
      Timer1.Enabled := True;
    except
      Result := False;
    end;
  end;
  if not Result then begin
    FCalculating := False;
    EnableControls(True);
    Mand3DForm.OutMessage('Error starting rendering');
  end;
end;
//################################################################################
destructor TPLYExportCalcThread.Destroy;
begin
  if Assigned( FObjectScanner ) then
    FreeAndNil( FObjectScanner );
  if Assigned( FRayCaster ) then
    FreeAndNil( FRayCaster );
  inherited Destroy;
end;

procedure TPLYExportCalcThread.Prepare;
var
  I, J: Integer;
  WorkList: TList;
begin
  case VertexGenConfig.MeshType of
    mtPointCloud:
      begin
        FRayCaster := TCreatePointCloudRayCaster.Create(VertexList, NormalsList, ColorsList);

        if VertexGenConfig.SphericalScan then
          FObjectScanner := TSphericalScanner.Create(VertexGenConfig, MCTparas, M3Vfile, FRayCaster)
        else
          FObjectScanner := TCubicScanner.Create(VertexGenConfig, MCTparas, M3Vfile, FRayCaster);
//          FObjectScanner := TParallelScanner.Create(VertexGenConfig, MCTparas, M3Vfile, FRayCaster);

        if ( MCTparas.iThreadID = 1 ) and ( FObjectScanner.UseShuffledWorkList  ) then begin
          WorkList := FObjectScanner.GetWorkList;
          for I := WorkList.Count - 1 downto 0 do begin
            J := I;
            while J = I do
              J := Random(  WorkList.Count );
            WorkList.Move( I, J );
          end;
          VertexGenConfig.SharedWorkList := WorkList;
        end;

      end;
    mtMesh:
      begin
        FRayCaster := TCreateMeshRayCaster.Create(FacesList, VertexGenConfig.ISOValue);
        FObjectScanner := TParallelScanner.Create(VertexGenConfig, MCTparas, M3Vfile, FRayCaster);
        if FOwner.FSaveType = stUnprocessedMeshData then begin
          FObjectScanner.IterationIdx := MCTparas.iThreadId - 1;
          FObjectScanner.IterationCallback := FOwner.CheckSavePart;
        end;
      end;
  end;


  FPrepared := True;
end;

procedure TPLYExportCalcThread.Execute;
begin
  if not FPrepared then
    raise Exception.Create('Call Prepare First');
  try
    FObjectScanner.Scan;
  finally
    with MCTparas do begin
      PCalcThreadStats.CTrecords[iThreadID].isActive := 0;
      PostMessage(PCalcThreadStats.pMessageHwnd, WM_ThreadReady, 0, 0);
    end;
  end;
end;

procedure TBulbTracerFrm.SavePointCloud;
var
  I: Integer;
  VertexList: TPS3VectorList;
  NormalsList, ColorsList: TPSMI3VectorList;
begin
  try
    if (not FForceAbort) or (FCancelType = ctCancelAndShowResult) then begin
      VertexList := TPS3VectorList.Create;
      try
        if FVertexGenConfig.CalcNormals then
          NormalsList := TPSMI3VectorList.Create
        else
          NormalsList := nil;

        if FVertexGenConfig.CalcColors then
          ColorsList := TPSMI3VectorList.Create
        else
          ColorsList := nil;

        try
          for I := 0 to FThreadVertexLists.Count - 1 do begin
            VertexList.MoveVertices(FThreadVertexLists[I] as TPS3VectorList);
            if NormalsList <> nil then
              NormalsList.MoveVertices(FThreadNormalsLists[I] as TPSMI3VectorList);
            if ColorsList <> nil then
              ColorsList.MoveVertices(FThreadColorsLists[I] as TPSMI3VectorList);
          end;
          if FVertexGenConfig.ShowTraceRanges then
            FVertexGenConfig.AddSampledTraceRanges( VertexList, NormalsList, ColorsList );
          VertexList.DoCenter(0.1);
         // VertexList.RemoveDuplicates;
          if not FForceAbort then begin
            TPlyFileWriter.SaveToFile(MakeMeshSequenceFilename( FilenameREd.Text ), VertexList, NormalsList, ColorsList)
          end;
          FThreadVertexLists.Clear;

          if not FForceAbort then
            Label13.Caption := 'Elapsed time: ' + IntToStr(Round((DateUtils.MilliSecondsBetween(Now, 0)-T0)/1000.0))+' s'
          else
            Label13.Caption := 'Operation cancelled';

          if OpenGLPreviewCBx.Checked then
            MeshPreviewFrm.UpdateMesh(VertexList, ColorsList);
        finally
          if NormalsList <> nil then
            NormalsList.Free;
          if ColorsList <> nil then
            ColorsList.Free;
        end;
      finally
        VertexList.Free;
      end;
    end;
  finally
    FThreadVertexLists.Clear;
    FThreadNormalsLists.Clear;
    FThreadColorsLists.Clear;
  end;
  if OpenGLPreviewCBx.Checked then
    MeshPreviewBtnClick(nil);
end;

procedure TBulbTracerFrm.SaveTypeCmbChange(Sender: TObject);
begin
  if (not FRefreshing) then begin
    SetExportFilenameExt;
  end;
end;

function TBulbTracerFrm.MakeMeshSequenceFilename( const BaseFilename: String ): String;
var
  I: Integer;
begin
  Result := BaseFilename;
  if FParamSource = psFileSequence then begin
    for I := Length( BaseFilename ) downto 1 do begin
      if BaseFilename[I] = '.' then begin
        Result := Copy( BaseFilename, 1, I - 1 ) + '_' + Format('%.5d', [ FParamSequenceCurrFrame ] ) + Copy( BaseFilename, I, Length( BaseFilename ) - I + 1) ;
        break;
      end;
    end;
  end;
end;

procedure TBulbTracerFrm.SaveMesh;
var
  FacesList: TFacesList;
  DoPostProcessing: Boolean;
  TargetFaceCount: Integer;
  Agressiveness: Double;
  I: Integer;
begin
  try
    if (not FForceAbort) or (FCancelType = ctCancelAndShowResult) then begin
      if( FSaveType = stUnprocessedMeshData ) then begin
        OutputDebugString(PChar('TOTAL: '+IntToStr(DateUtils.MilliSecondsBetween(Now, 0)-T0)+' ms'));
        for I := 0 to FThreadVertexLists.Count - 1 do begin
          FacesList := TFacesList( FThreadVertexLists[ I ] );
          if FacesList.Count > 0 then begin
            TUnprocessedMeshFileWriter.SaveToFile( MakeMeshSequenceFilename( FilenameREd.Text ), FacesList, FSavePartIdx);
            Inc( FSavePartIdx );
          end;
          FacesList.Clear;
        end;
        if not FForceAbort then
          Label13.Caption := 'Elapsed time: ' + IntToStr(Round((DateUtils.MilliSecondsBetween(Now, 0)-T0)/1000.0))+' s';
      end
      else begin
        FacesList := TFacesList.MergeFacesLists( FThreadVertexLists );
        try
          DoPostProcessing := SmoothGBox.Checked;
          FacesList.DoCenter(1.0);
          if ( not FForceAbort ) and SmoothGBox.Checked then begin
            FacesList.TaubinSmooth(StrToFloat(TaubinSmoothLambaEdit.Text), StrToFloat(TaubinSmoothMuEdit.Text), StrToInt(TaubinSmoothPassesEdit.Text));
          end;
          if ( not FForceAbort ) and MeshReductionGBox.Checked then begin
            TargetFaceCount := Round( FacesList.Count * StrToFloatSafe( MeshReductionRetainRatioEdit.Text, 1.0 ) );
            Agressiveness := StrToFloatSafe( MeshReductionAgressivenessEdit.Text, 7.0 );
            if ( TargetFaceCount > 0 ) and ( TargetFaceCount < FacesList.Count ) and ( Agressiveness >= 2.0 ) then begin
              with TMeshSimplifier.Create( FacesList ) do try
                SimplifyMesh(  TargetFaceCount, Agressiveness );
              finally
                Free;
              end;
            end;
          end;

          if not FForceAbort then begin
            if FSaveType = stMeshAsObj then
              TObjFileWriter.SaveToFile(MakeMeshSequenceFilename( FilenameREd.Text ), FacesList)
            else if FSaveType = stMeshAsLWO2 then
              TLightwaveObjFileWriter.SaveToFile(MakeMeshSequenceFilename( FilenameREd.Text ), FacesList);
          end;
          FThreadVertexLists.Clear;
          OutputDebugString(PChar('TOTAL: '+IntToStr(DateUtils.MilliSecondsBetween(Now, 0)-T0)+' ms'));
          if not FForceAbort then
            Label13.Caption := 'Elapsed time: ' + IntToStr(Round((DateUtils.MilliSecondsBetween(Now, 0)-T0)/1000.0))+' s';
          if OpenGLPreviewCBx.Checked then
            MeshPreviewFrm.UpdateMesh(FacesList);
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

  if OpenGLPreviewCBx.Checked and (  FSaveType <> stUnprocessedMeshData ) then
    MeshPreviewBtnClick(nil);
end;

procedure TBulbTracerFrm.MergeAndSaveMesh;
begin
  case FVertexGenConfig.MeshType of
    mtPointCloud:
      SavePointCloud;
    mtMesh:
      SaveMesh;
  end;
end;

procedure TBulbTracerFrm.MeshISOValueUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(MeshISOValueEdit.Text, 0.0) + UpDownBtnValue(Button, 0.05);
  if Value <= 0.0 then
    Value := 0.0
  else if Value > 1.0 then
    Value := 1.0;
  MeshISOValueEdit.Text := FloatToStr(Value);
end;

procedure TBulbTracerFrm.MeshPreviewBtnClick(Sender: TObject);
begin
  MeshPreviewFrm.Visible := True;
  BringToFront2(MeshPreviewFrm.Handle);
end;

procedure TBulbTracerFrm.MeshReductionAgressivenessUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(MeshReductionAgressivenessEdit.Text, 0.0) + UpDownBtnValue(Button, 1.0);
  if Value < 3.0 then
    Value := 3.0
  else if Value > 20.0 then
    Value := 20.0;
  MeshReductionAgressivenessEdit.Text := FloatToStr(Value);
end;

procedure TBulbTracerFrm.MeshReductionRetainRatioUpDownClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(MeshReductionRetainRatioEdit.Text, 0.0) + UpDownBtnValue(Button, 0.05);
  if Value < 0.01 then
    Value := 0.01
  else if Value > 0.99 then
    Value := 0.99;
  MeshReductionRetainRatioEdit.Text := FloatToStr(Value);
end;

procedure TBulbTracerFrm.MeshTypeCmbChange(Sender: TObject);
begin
  UpdateSaveTypeCmb;
  EnableMeshOptionControls;
end;

procedure TBulbTracerFrm.MeshVResolutionEditChange(Sender: TObject);
begin
  if not FRefreshing then
    MeshVResolutionLbl.Caption := ' x '+MeshVResolutionEdit.Text + ' x '+MeshVResolutionEdit.Text;
end;

procedure TBulbTracerFrm.WndProc(var Message: TMessage);
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


procedure TBulbTracerFrm.UpdateVertexGenConfig;
var
  SphereRange: TSphereRange;
  BoxRange: TBoxRange;
  VRes: Integer;
begin
  FVertexGenConfig.Clear;

  FVertexGenConfig.RemoveDuplicates := True;
  FVertexGenConfig.CalcNormals := CalculateNormalsCBx.Checked;

  FVertexGenConfig.MeshType := TMeshType( MeshTypeCmb.ItemIndex );
  FVertexGenConfig.Oversampling := TOversampling(MeshOversamplingCmb.ItemIndex);
  FVertexGenConfig.ISOValue := StrToFloat(MeshISOValueEdit.Text);
  FVertexGenConfig.SphericalScan := False;
  FVertexGenConfig.CalcColors := MeshCalcColorsCBx.Checked;
  FVertexGenConfig.SampleJitter := Max( 0.0, Min( 1.0, StrToFloat( JitterEdit.Text ) ) ) * 2.0;

  VRes := StrToInt( MeshVResolutionEdit.Text );
  FVertexGenConfig.URange.StepCount := VRes;
  FVertexGenConfig.VRange.StepCount := VRes;

  if ( FVertexGenConfig.MeshType = mtPointCloud ) then begin
    if FVertexGenConfig.SphericalScan then begin
      FVertexGenConfig.URange.StepCount := VRes;
      FVertexGenConfig.VRange.StepCount := VRes;
    end
    else begin
      if FVertexGenConfig.SampleJitter > JITTER_MIN then begin
        FVertexGenConfig.URange.StepCount := Round( VRes * 0.666 );
        FVertexGenConfig.VRange.StepCount := Round( VRes * 0.666 );
      end
      else begin
        FVertexGenConfig.URange.StepCount := Round( VRes * 0.75 );
        FVertexGenConfig.VRange.StepCount := Round( VRes * 0.75 );
      end;
    end;
  end
  else begin
    FVertexGenConfig.URange.StepCount := VRes;
    FVertexGenConfig.VRange.StepCount := VRes;
  end;

(*
  SphereRange := TSphereRange.Create;
  SphereRange.Radius := 44.0;
  SphereRange.Mode := trInclude;
  SphereRange.CentreX := 47.0;
  SphereRange.CentreY := 48.0;
  SphereRange.CentreZ := 60.0;
  SphereRange.IndicatorColorR := 0.0;
  SphereRange.IndicatorColorG := 1.0;
  SphereRange.IndicatorColorB := 1.0;
  FVertexGenConfig.TraceRanges.Add( SphereRange );


  SphereRange := TSphereRange.Create;
  SphereRange.Radius := 20.0;
  SphereRange.Mode := trExclude;
  SphereRange.CentreX := 47.0;
  SphereRange.CentreY := 48.0;
  SphereRange.CentreZ := 80.0;
  SphereRange.IndicatorColorR := 1.0;
  SphereRange.IndicatorColorG := 0.0;
  SphereRange.IndicatorColorB := 0.0;
  FVertexGenConfig.TraceRanges.Add( SphereRange );

  FVertexGenConfig.ShowTraceRanges := False;
*)
(*
  SphereRange := TSphereRange.Create;
  SphereRange.Radius := 20.0;
  SphereRange.IndicatorColorR := 1.0;
  SphereRange.IndicatorColorG := 0.0;
  SphereRange.IndicatorColorB := 0.0;
  SphereRange.Mode := trExclude;
//  FVertexGenConfig.TraceRanges.Add( SphereRange );


  BoxRange := TBoxRange.Create;
  BoxRange.CentreX := 0.0;
  BoxRange.CentreY := 0.0;
  BoxRange.CentreZ := 0.0;
  BoxRange.SizeX := 100.0;
  BoxRange.SizeY := 100.0;
  BoxRange.SizeZ := 50.0;
  BoxRange.Mode := trExclude;
//  FVertexGenConfig.TraceRanges.Add( BoxRange );

  FVertexGenConfig.ShowTraceRanges := True;
*)
end;

procedure TBulbTracerFrm.EnableControls(const Enabled: Boolean);
begin
  if Enabled then begin
    ImportParamsFromMainBtn.Enabled := True;
    Button5.Enabled := Benabled;
    Panel3.Enabled := True;
    Button5.Caption := 'Calculate preview';
  end
  else begin
    ImportParamsFromMainBtn.Enabled := False;
    Button5.Enabled := False;
    Panel3.Enabled := False;
  end;
  CancelBtn.Enabled := FCalculating;
 // CancelBtn.Visible := CancelBtn.Enabled;
  CalculateBtn.Enabled := Benabled and (not FCalculating);
//  CalculateBtn.Visible := not CancelBtn.Visible;
end;

procedure TBulbTracerFrm.UpdateParamsRange;
begin
  if FParamSource = psFileSequence then begin
    FrameUpDown.Min := FParamSequenceFrom;
    FrameUpDown.Max := FParamSequenceTo;
    FrameTBar.Min := FParamSequenceFrom;
    FrameTBar.Max := FParamSequenceTo;
    UpdateFrameDisplay( FParamSequenceCurrFrame );

    FrameEdit.Enabled := True;
    FrameUpDown.Enabled := True;
    FrameTBar.Enabled := True;

    CalculateBtn.Caption := 'Generate ' + IntToStr( FParamSequenceTo - FParamSequenceFrom + 1 )+ ' Meshes';
    GenCurrMeshBtn.Visible := True;
  end
  else begin
    FrameUpDown.Min := 1;
    FrameUpDown.Max := 1;
    FrameTBar.Min := 1;
    FrameTBar.Max := 1;
    UpdateFrameDisplay( 1 );

    FrameEdit.Enabled := False;
    FrameUpDown.Enabled := False;
    FrameTBar.Enabled := False;

    CalculateBtn.Caption := 'Generate Mesh';
    GenCurrMeshBtn.Visible := False;
  end;
end;

procedure TBulbTracerFrm.UpdateFrameDisplay( const Frame: Integer );
begin
  FrameEdit.Text := IntToStr( Frame );
  FrameTBar.Position := Frame;
end;

procedure TBulbTracerFrm.ChangeFrame;
var
  Frame: Integer;
begin
  if FParamSource = psFileSequence then begin
    Frame := Round( StrToFloatSafe(FrameEdit.Text, FParamSequenceCurrFrame) );
    if Frame < FParamSequenceFrom then
      Frame := FParamSequenceFrom;
    if Frame > FParamSequenceTo then
      Frame := FParamSequenceTo;
    FParamSequenceCurrFrame := Frame;
    ImportParams(True);
  end;
end;


procedure TBulbTracerFrm.ShowTitle(const Caption: String);
begin
  Self.Caption := 'Bulb Tracer [ ' + Caption + ' ]';
end;

procedure TBulbTracerFrm.SetExportFilenameExt;
var
  NewFileExt: String;
begin
  if Trim( FilenameREd.Text ) <> '' then begin
    UpdateVertexGenConfig;
    if FVertexGenConfig.MeshType = mtMesh then
      NewFileExt := GetMeshFileExt(TMeshSaveType(SaveTypeCmb.ItemIndex))
    else
      NewFileExt := GetMeshFileExt(TPointCloudSaveType(SaveTypeCmb.ItemIndex));

    if NewFileExt <> '' then
      NewFileExt := '.' + NewFileExt;
    FilenameREd.Text := ChangeFileExt( FilenameREd.Text, NewFileExt )
  end;
end;

procedure TBulbTracerFrm.UpdateSaveTypeCmb;
begin
  UpdateVertexGenConfig;
  SaveTypeCmb.Items.Clear;
  case FVertexGenConfig.MeshType of
    mtPointCloud:
      begin
        SaveTypeCmb.Items.Add('Mesh as PLY');
        SaveTypeCmb.Items.Add('Don''t save, only preview');
        SaveTypeCmb.ItemIndex := 0;
      end;
    mtMesh:
      begin
        SaveTypeCmb.Items.Add('Mesh as OBJ');
        SaveTypeCmb.Items.Add('Mesh as Lightwave3d Object');
        SaveTypeCmb.Items.Add('Unprocessed raw mesh (for huge meshes)');
        SaveTypeCmb.Items.Add('Don''t save, only preview');
        SaveTypeCmb.ItemIndex := 0;
      end;
  end;
  SaveTypeCmbChange( nil );
end;

procedure TBulbTracerFrm.EnableMeshOptionControls;
var
  IsPointCloud: Boolean;
begin
  IsPointCloud := FVertexGenConfig.MeshType = mtPointCloud;
  MeshISOValueEdit.Enabled := not IsPointCloud;
  SmoothGBox.Enabled := not IsPointCloud;
  MeshReductionGBox.Enabled := not IsPointCloud;
  MeshISOValueEdit.Enabled := not IsPointCloud;
  MeshISOValueUpDown.Enabled := not IsPointCloud;
  MeshOversamplingCmb.Enabled := not IsPointCloud;
  MeshCalcColorsCBx.Enabled := IsPointCloud;
  JitterEdit.Enabled := IsPointCloud;
  JitterUpDown12.Enabled := IsPointCloud;
end;


procedure TBulbTracerFrm.CustomizeUI;
begin
(*
  Edit1.Text := FloatToStr(-0.0181483);
  Edit3.Text := FloatToStr(-0.0318281);
  Edit4.Text := FloatToStr(0.0164771);
  Edit5.Text := FloatToStr(1.61051);
  Edit6.Text := FloatToStr(1.61051);
  Edit7.Text := FloatToStr(1.61051);

  Edit2.Text := FloatToStr(47);
  Edit10.Text := FloatToStr(48);
  Edit13.Text := FloatToStr(60);

  MeshVResolutionEdit.Text := IntToStr(128);
*)
end;

procedure TBulbTracerFrm.CheckSavePart(const Idx: Integer);
const
  VERTEX_CHUNKSIZE = 500000;
var
  FacesList: TFacesList;
begin
  FacesList := TFacesList( FThreadVertexLists[ Idx ] );
  if FacesList.Count > VERTEX_CHUNKSIZE then begin
    FSavePartCriticalSection.Enter;
    try
      TUnprocessedMeshFileWriter.SaveToFile( MakeMeshSequenceFilename( FilenameREd.Text ), FacesList, FSavePartIdx);
      Inc( FSavePartIdx );
      FacesList.Clear;
    finally
      FSavePartCriticalSection.Leave;
    end;
  end;
end;


end.


