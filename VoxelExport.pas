unit VoxelExport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, TypeDefinitions, ComCtrls;

type
  TM3Vfile = packed record
    Xoff, Yoff, Zoff: Double;
    Xscale, Yscale, Zscale: Double;
    Zslices: Integer;
    ObjectD: Integer;
    MaxIts: Integer; 
    iFree: Integer;
    DE: Double;
    OrigWidth: Integer;
    VoxelVersion: Integer;
    WhiteOutside: LongBool;
    OutputFormat: Integer; //0: 1bpp  1: 8bpp  2: rgb
    UseDefaultOrientation: LongBool;
    LeadingZeros: LongBool;
    MinDE: Double;
    MinIts: Integer;
    PlaceForFuturePars: array[0..23] of Integer;
    OutputFolderC: array[0..1023] of Byte;             //+$CC
    VHeader: TMandHeader11;                            //+$4CC
    VHAddon: THeaderCustomAddon;
  end;
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
  TFVoxelExport = class(TForm)
    Panel2: TPanel;
    Edit2: TEdit;
    Button3: TButton;
    Panel3: TPanel;
    Panel4: TPanel;
    Button2: TButton;
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Edit3: TEdit;
    Label2: TLabel;
    Edit4: TEdit;
    Label3: TLabel;
    Edit5: TEdit;
    Label4: TLabel;
    Edit6: TEdit;
    Label5: TLabel;
    Edit7: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Button4: TButton;
    RadioGroup1: TRadioGroup;
    Label8: TLabel;
    Label9: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    SpeedButton11: TSpeedButton;
    SpeedButton9: TSpeedButton;
    OpenDialog4: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label10: TLabel;
    Edit10: TEdit;
    Label11: TLabel;
    Image1: TImage;
    Button5: TButton;
    Label12: TLabel;
    Timer1: TTimer;
    Label13: TLabel;
    Timer2: TTimer;
    RadioGroup2: TRadioGroup;
    CheckBox1: TCheckBox;
    CheckBox3: TCheckBox;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    UpDown4: TUpDown;
    Label14: TLabel;
    UpDown5: TUpDown;
    UpDown6: TUpDown;
    UpDown7: TUpDown;
    Timer3: TTimer;
    UpDown8: TUpDown;
    UpDown9: TUpDown;
    CheckBox4: TCheckBox;
    RadioGroup3: TRadioGroup;
    Button6: TButton;
    CheckBox2: TCheckBox;
    Label15: TLabel;
    Edit11: TEdit;
    UpDown10: TUpDown;
    RadioGroup4: TRadioGroup;
    Label16: TLabel;
    Edit12: TEdit;
    UpDown11: TUpDown;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
  private
    { Private-Deklarationen }
  //  PreviewVoxel: array of Cardinal;   //buffer to not calc everything again if shifted position
    PVwid, PVhei, PVdep: Integer;
    VCalcThreadStats: TCalcThreadStats;
    PaintedYsofar, vActiveThreads, PreviewSize: Integer;
    CalcPreview{, PrCalcedAll}: LongBool; //to verify if PreviewVoxel array is complete
    VsiLight: array of Cardinal;  //just 0..255 for color
    procedure PutOutputFolder2record;
    procedure GetOutputFolderFromrecord;
    procedure MakeM3V;
    procedure SetFromM3V;
    procedure CalcImageSize;
    procedure PaintVoxRows(StartRow, EndRow: Integer);
    function StartSlice(nr: Integer): LongBool;
    function StartSlicePreview(nr: Integer): LongBool;
    procedure PaintNextPreviewSlice(nr: Integer);
    procedure SetProjectName(FileName: String);
    procedure UpdateVersion;
    procedure StartNewPreview;
    procedure CalcPreviewSizes;
  protected
    procedure WmThreadReady(var Msg: TMessage); message WM_ThreadReady;
  public
    { Public-Deklarationen }
    M3Vfile: TM3Vfile;
    bUserChange, bFirstShow, Benabled: LongBool;
    OutputFolder, VProjectName: String;
    FileNumber: Integer;
    HybridCustoms: array[0..MAX_FORMULA_COUNT - 1] of TCustomFormula;
  end;

var
  FVoxelExport: TFVoxelExport;
  iVoxelVersion: Integer = 4;
  bVoxelFormCreated: LongBool = False;
 // CalcVoxelPreviewIndex: Integer = 0;

implementation

uses CalcVoxelSliceThread, FileHandling, Math, Math3D, Calc, DivUtils, Mand,
  HeaderTrafos, CustomFormulas, ImageProcess;

{$R *.dfm}
  {    d := 2.1345 * 0.5 / VHeader.dZoom;
      Xstart := VHeader.dXmid - d;
      Xend := VHeader.dXmid + d;
      Ystart := VHeader.dYmid - d; // * VHeader.Height / VHeader.Width;
      Yend := VHeader.dYmid + d;  // * VHeader.Height / VHeader.Width;
      Zstart := VHeader.dZmid - d;
      Zend := VHeader.dZmid + d; }

procedure TFVoxelExport.UpdateVersion;
var dtx, dty, dtz: Double;
begin
    with M3Vfile do
    begin
      if (VoxelVersion > 100) or (Xscale < 1e-10) or
             (Yscale < 1e-10) or (Zscale < 1e-10) then VoxelVersion := 0;
      if VoxelVersion < 2 then
      begin
        dtx := MaxCD(1e-30, Abs(Yoff - Xoff)); //Xend - Xstart    Xoff, Yoff, Zoff, Xscale, Yscale, Zscale: Double;
        dty := Abs(Xscale - Zoff);     //Yend - Ystart
        dtz := Abs(Zscale - Yscale);   //Zend - Zstart
        Xoff := 0;
        Yoff := 0;
        Zoff := 0;
        Xscale := 1;
        Yscale := dty / dtx;
        Zscale := dtz / dtx;
        LeadingZeros := True;
        WhiteOutside := False;
      end;
      if VoxelVersion < 3 then //abs offsets
      begin
        dtz := (VHeader.Width - 1) * 2.2 / (64 * VHeader.dZoom * Zscale * (Zslices - 1));
        Xoff := Xoff * dtz;
        Yoff := Yoff * dtz;
        Zoff := Zoff * dtz;
      end;
      if VoxelVersion < 4 then
      begin
        MinDE := DE * 0.254;
        MinIts := MinIts div 2;
      end;
      VoxelVersion := iVoxelVersion;
    end;
end;
 {     d := 2.2 / (M3Vfile.VHeader.dZoom * M3Vfile.Zscale * (M3Vfile.Zslices - 1)); //new stepwidth
      MCTparas.VGrads := NormaliseMatrixTo(d, @MCTparas.VGrads);
      d * xoff * (M3Vfile.VHeader.Width - 1) / 64 = absxoff }

procedure TFVoxelExport.PutOutputFolder2record;
var i, l: Integer;
begin
    l := Min(1023, Length(OutputFolder));
    for i := 1 to l do M3Vfile.OutputFolderC[i - 1] := Ord(OutputFolder[i]);
    M3Vfile.OutputFolderC[l] := 0;
end;

procedure TFVoxelExport.GetOutputFolderFromrecord;
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

procedure TFVoxelExport.Button1Click(Sender: TObject);
begin
    Visible := False;
end;

procedure TFVoxelExport.Button3Click(Sender: TObject);
begin
    OutputFolder := GetDirectory(OutputFolder, FVoxelExport);
    Edit2.Text := OutputFolder;
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

procedure TFVoxelExport.PaintVoxRows(StartRow, EndRow: Integer);
var x, y, wid: Integer;
    PC: PCardinal;
    PSL: TPsiLight5;
    PSLstart, PLoffset: Integer;
    ColA: array[0..1] of Cardinal;
begin
    if not Mand3DForm.SizeOK(False) then Exit;
    if M3Vfile.WhiteOutside then
    begin
      ColA[0] := $FFFFFF;
      ColA[1] := 0;
    end else begin
      ColA[0] := 0;
      ColA[1] := $FFFFFF;
    end;
    StartRow := Max(0, StartRow);
    wid := M3Vfile.VHeader.Width;
    EndRow := Min(EndRow, M3Vfile.VHeader.Height - 1);
    if (wid > 3) and (wid < 32767) then
    begin
      PSLstart := Integer(@Mand3DForm.siLight5[0]);
      PLoffset := wid * SizeOf(TsiLight5);
      for y := StartRow to EndRow do
      begin
        PSL := TPsiLight5(PSLstart + y * PLoffset);
        PC := PCardinal(mFSIstart + mFSIoffset * y);
        for x := 1 to wid do
        begin
          PC^ := ColA[PSL.SIgradient and 1];
          Inc(PSL);
          Inc(PC);
        end;
      end;
    end;
    if ImageScale = 1 then UpdateScaledImage(StartRow, EndRow);
end;

function TFVoxelExport.StartSlice(nr: Integer): LongBool;
var VoxCalcThreads: array of TFVoxelExportCalcThread;
    x, ThreadCount: Integer;
    MCTparas: TMCTparameter;
    d: Double;
begin
  ThreadCount := Min(Mand3DForm.UpDown3.Position, M3Vfile.VHeader.Height);
  try
    M3Vfile.VHeader.TilingOptions := 0;
    bGetMCTPverbose := False;
    MCTparas := getMCTparasFromHeader(M3Vfile.VHeader, False);
    bGetMCTPverbose := True;
    Result := MCTparas.bMCTisValid;
    if Result then
    begin
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
      mAddVecWeight(@MCTparas.Ystart, @MCTparas.Vgrads[2], nr - M3Vfile.Zslices * 0.5 + M3Vfile.Zoff / d);
      MCTparas.iSliceCalc := M3Vfile.ObjectD;
      MCTparas.AOdither := M3Vfile.MinIts;
      MCTparas.DEAOmaxL := M3Vfile.MinDE;
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
      VCalcThreadStats.CTrecords[x].iActualXpos := 0;
      VCalcThreadStats.CTrecords[x].i64DEsteps  := 0;
      VCalcThreadStats.CTrecords[x].iDEAvrCount := 0;
      VCalcThreadStats.CTrecords[x].i64Its      := 0;
      VCalcThreadStats.CTrecords[x].iItAvrCount := 0;
      VCalcThreadStats.CTrecords[x].MaxIts      := 0;
      MCTparas.iThreadId := x;
      try
        VoxCalcThreads[x - 1] := TFVoxelExportCalcThread.Create(True);
        VoxCalcThreads[x - 1].FreeOnTerminate := True;
        VoxCalcThreads[x - 1].MCTparas        := MCTparas;
        VoxCalcThreads[x - 1].Priority        := cTPrio[Mand3DForm.ComboBox2.ItemIndex];
        VCalcThreadStats.CTrecords[x].isActive := 1;
      except
        ThreadCount := x - 1;
        Break;
      end;
    end;
    VCalcThreadStats.HandleType := 0;
    for x := 0 to ThreadCount - 1 do VoxCalcThreads[x].MCTparas.iThreadCount := ThreadCount;
    VCalcThreadStats.iTotalThreadCount := ThreadCount;
    VCalcThreadStats.cCalcTime         := GetTickCount;
    vActiveThreads := ThreadCount;
    PaintedYsofar := 0;
    for x := 0 to ThreadCount - 1 do VoxCalcThreads[x].Start;
    Mand3DForm.DisableButtons;
    Label13.Caption := 'Rendering slice: ' + IntToStr(nr);
    Timer1.Interval := 200;
    Timer1.Enabled := True;
  end
  else Mand3DForm.OutMessage('Error starting slice ' + IntToStr(nr));
end;

function TFVoxelExport.StartSlicePreview(nr: Integer): LongBool;
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
    Timer2.Interval := 50;
    Timer2.Enabled := True;
  end;
end;

procedure TFVoxelExport.Timer1Timer(Sender: TObject);   // proof if threads are still calculating
var y, ymin, hei, it, il: Integer;
begin
    Timer1.Enabled := False;
    ymin := 999999;
    hei := M3Vfile.VHeader.Height;
    it := 0;
    with VCalcThreadStats do
    begin
      for y := 1 to iTotalThreadCount do
      begin
        ymin := Min(ymin, CTrecords[y].iActualYpos);
        if CTrecords[y].isActive <> 0 then Inc(it);
      end;
    end;
    if ymin >= hei then ymin := hei - 1;
    if ImageScale <> 1 then
    begin
      ImageScale := 1;
      SetImageSize;
    end;
    PaintVoxRows(Max(0, PaintedYsofar), ymin);
    PaintedYsofar := Min(hei - 1, ymin + 1);
    if it = 0 then //ready, save png, start next slice
    begin
      if not VCalcThreadStats.pLBcalcStop^ then
      begin
        if M3Vfile.LeadingZeros then il := 6 else il := 0;
        Save1bitPNG(OutputFolder + VProjectName + IntToStrL(FileNumber, il) +'.png', Mand3dForm.Image1.Picture.Bitmap);
      end;
      Inc(FileNumber);
      if FileNumber > M3Vfile.Zslices then //ready with all slices
      begin
        Mand3DForm.EnableButtons;
        Mand3DForm.OutMessage('Finished rendering slices.');
        Label13.Caption := '';
      end
      else if VCalcThreadStats.pLBcalcStop^ or (not StartSlice(FileNumber)) then
      begin
        Mand3DForm.EnableButtons;
        Label13.Caption := '';
      end;
    end
    else Timer1.Enabled := True;
end;

procedure TFVoxelExport.WmThreadReady(var Msg: TMessage);
begin
    if Msg.LParam = 0 then
    begin
      Dec(vActiveThreads);
      if vActiveThreads = 0 then
      begin
        if CalcPreview then Timer2.Interval := 1
                       else Timer1.Interval := 5;
      end;
    end;
end;

procedure TFVoxelExport.MakeM3V;
begin
    with M3Vfile do
    begin
      Xoff := StrToFloatK(Edit1.Text);
      Yoff := StrToFloatK(Edit3.Text);
      Zoff := StrToFloatK(Edit4.Text);
      Xscale := StrToFloatK(Edit5.Text);
      Yscale := StrToFloatK(Edit6.Text);
      Zscale := StrToFloatK(Edit7.Text);
      UseDefaultOrientation := CheckBox3.Checked;
      LeadingZeros := CheckBox4.Checked;
      Zslices := StrToInt(Edit10.Text);
      ObjectD := RadioGroup1.ItemIndex;
      MaxIts := StrToInt(Edit8.Text);
      DE := StrToFloatK(Edit9.Text);
      MinIts := StrToInt(Edit11.Text);
      MinDE := MaxCD(DE * 0.254, StrToFloatK(Edit12.Text));
      VoxelVersion := iVoxelVersion;
      WhiteOutside := CheckBox1.Checked;
      FillChar(PlaceForFuturePars, SizeOf(PlaceForFuturePars), 0);
      OutputFolder := Edit2.Text;
      PutOutputFolder2record;
      VHAddon.bOptions2 := (VHAddon.bOptions2 and $F9) or (RadioGroup4.ItemIndex shl 1);
    end;
end;

procedure TFVoxelExport.CalcImageSize;
var d: Double;
begin
    with M3Vfile do
    begin
      d := Zslices / MaxCD(1e-40, Zscale);
      VHeader.Width := Round(Xscale * d);
      VHeader.Height := Round(Yscale * d);
    end;
end;

procedure TFVoxelExport.SetFromM3V;
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
      Edit10.Text := IntToStr(Zslices);
      RadioGroup1.ItemIndex := ObjectD;
      Edit8.Text := IntToStr(MaxIts);
      Edit9.Text := FloatToStr(DE);
      Edit11.Text := IntToStr(MinIts);
      Edit12.Text := FloatToStrSingle(MinDE);
      RadioGroup4.ItemIndex := (VHAddon.bOptions2 shr 1) and 3;
      GetOutputFolderFromrecord;
      Edit2.Text := OutputFolder;
      CheckBox1.Checked := WhiteOutside;
      CheckBox3.Checked := UseDefaultOrientation;
      CheckBox4.Checked := LeadingZeros;
      CalcImageSize;
      Label12.Caption := IntToStr(VHeader.Width) + ' x ' + IntToStr(VHeader.Height);
      bUserChange := b;
      VHeader.PCFAddon := @VHAddon;
      for i := 0 to MAX_FORMULA_COUNT - 1 do VHeader.PHCustomF[i] := @HybridCustoms[i];
    end;
end;

procedure TFVoxelExport.SetProjectName(FileName: String);
begin
    VProjectName := ChangeFileExtSave(ExtractFileName(FileName), '');
    Label7.Caption := 'Project: ' + VProjectName;
end;

procedure TFVoxelExport.SpeedButton9Click(Sender: TObject); //SaveM3V
var f: file;
begin
    MakeM3V;
    if SaveDialog1.Execute then
    begin
      AssignFile(f, ChangeFileExtSave(SaveDialog1.FileName, '.m3v'));
      try
        Rewrite(f, 1);
        BlockWrite(f, M3Vfile, SizeOf(M3Vfile));
      finally
        CloseFile(f);
      end;
      SetProjectName(SaveDialog1.FileName);
    end;
end;

procedure TFVoxelExport.SpeedButton11Click(Sender: TObject); //OpenM3V
var f: file;
begin
    if OpenDialog4.Execute then
    begin
      AssignFile(f, OpenDialog4.FileName);
      try
        Reset(f, 1);
        BlockRead(f, M3Vfile, SizeOf(M3Vfile));
      finally
        CloseFile(f);
      end;
      UpdateVersion;
      SetProjectName(OpenDialog4.FileName);
      SetFromM3V;
      Button2.Enabled := True;
      Button5.Enabled := True;
      SpeedButton9.Enabled := True;
      Benabled := True;
      StartNewPreview;
    end;
end;

procedure TFVoxelExport.Button4Click(Sender: TObject);  //Import pars from main
var i: Integer;
    d: Double;
begin
    with M3Vfile do       
    begin
      VHeader.PCFAddon := @VHAddon;
      for i := 0 to MAX_FORMULA_COUNT - 1 do VHeader.PHCustomF[i] := @HybridCustoms[i];
      Mand3DForm.MakeHeader;
      AssignHeader(@VHeader, @Mand3DForm.MHeader);
      DisableTiling(@VHeader);
      VHeader.TilingOptions := 0;
      Xoff := 0;
      Yoff := 0;
      Zoff := 0;
      Xscale := 1;
      Yscale := 1;
      Zscale := 1;
      Zslices := StrToInt(Edit10.Text);
      ObjectD := 1;
      OrigWidth := VHeader.Width;
      MaxIts := VHeader.Iterations;
      MinIts := MaxIts div 2;
      UseDefaultOrientation := False;
      LeadingZeros := CheckBox4.Checked;
      WhiteOutside := CheckBox1.Checked;
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
    Button2.Enabled := True;
    Button5.Enabled := True;
    SpeedButton9.Enabled := True;
    Benabled := True;
    StartNewPreview;
end;

procedure TFVoxelExport.FormShow(Sender: TObject);
begin
    bUserChange := True;
    if bFirstShow then
    begin
      RadioGroup1.Hint :=' Type of object determination, lowering Max its or increasing DE' + #13#10 +
'(dependend on the choosen option), will make the object thicker.' + #13#10 +
'Note:  DEcombinate formulas work only in the Distance estimation mode!';
      OpenDialog4.InitialDir := IniDirs[10];
      SaveDialog1.InitialDir := IniDirs[10];
      bFirstShow := False;
      OutputFolder := IniDirs[10]; 
      Edit2.Text := OutputFolder;
      PutOutputFolder2record;
      VProjectName := 'new';
    end;
end;

procedure TFVoxelExport.Edit1Change(Sender: TObject);
begin
    if bUserChange then
    begin
      MakeM3V;
      CalcImageSize;
      Label12.Caption := IntToStr(M3Vfile.VHeader.Width) + ' x ' +
                         IntToStr(M3Vfile.VHeader.Height);
      StartNewPreview;
    end;
end;

procedure TFVoxelExport.FormCreate(Sender: TObject);
var i: Integer;
begin
    bFirstShow := True;
    Benabled := False;
    for i := 0 to MAX_FORMULA_COUNT - 1 do IniCustomF(@HybridCustoms[i]);
    bVoxelFormCreated := True;
    Panel4.DoubleBuffered := True;
end;

procedure TFVoxelExport.Button2Click(Sender: TObject);   //start rendering slices
begin
    MakeM3V;
 //   Mand3DForm.bCalcTile := False;
    FileNumber := 1;
    ImageScale := 1;
    SetLength(Mand3DForm.siLight5, M3Vfile.VHeader.Width * M3Vfile.VHeader.Height);
    Mand3DForm.mSLoffset := M3Vfile.VHeader.Width * SizeOf(TsiLight5);
    Mand3DForm.MHeader.Width := M3Vfile.VHeader.Width;
    Mand3DForm.MHeader.Height := M3Vfile.VHeader.Height;
    SetImageSize;
    CalcPreview := False;
    M3Vfile.VHeader.sDEstop := M3Vfile.DE; 
    M3Vfile.VHeader.Iterations := M3Vfile.MaxIts;
    StartSlice(FileNumber);
end;

procedure TFVoxelExport.CalcPreviewSizes;
var d: Double;
begin
    with M3Vfile do
    begin
      PreviewSize := 64 shl RadioGroup2.ItemIndex;
      d := 1 / MaxCD(MaxCD(Zscale, Yscale), Xscale);
      PVwid := Round(PreviewSize * Xscale * d);
      PVhei := Round(PreviewSize * Yscale * d);
      PVdep := Round(PreviewSize * Zscale * d);
    end;
end;

procedure TFVoxelExport.Button5Click(Sender: TObject);  //calc preview
begin
    if Button5.Caption = 'Stop' then
    begin
      MCalcStop := True;
  //    Inc(CalcVoxelPreviewIndex);
    end
    else
    begin
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

procedure Darken(pc: PCardinal);
type ta = array[0..3] of Byte;
    pta = ^ta;
begin
    if pta(pc)[0] > 3 then Dec(pta(pc)[0], 4);
    if pta(pc)[1] > 3 then Dec(pta(pc)[1], 4);
    if pta(pc)[2] > 3 then Dec(pta(pc)[2], 4);
    Inc(pc);
    if pta(pc)[0] > 3 then Dec(pta(pc)[0], 4);
    if pta(pc)[1] > 3 then Dec(pta(pc)[1], 4);
    if pta(pc)[2] > 3 then Dec(pta(pc)[2], 4);
    Inc(pc);
    if pta(pc)[0] > 3 then Dec(pta(pc)[0], 4);
    if pta(pc)[1] > 3 then Dec(pta(pc)[1], 4);
    if pta(pc)[2] > 3 then Dec(pta(pc)[2], 4);
    Inc(pc);
    if pta(pc)[0] > 3 then Dec(pta(pc)[0], 4);
    if pta(pc)[1] > 3 then Dec(pta(pc)[1], 4);
    if pta(pc)[2] > 3 then Dec(pta(pc)[2], 4);  
end;


function Clamp255(i: Integer): Integer;
asm
    cmp eax, 255
    jle @up
    mov eax, 255
@up:
end;

procedure Lighten(pc: PCardinal; b: Byte);
type ta = array[0..3] of Byte;
    pta = ^ta;
begin
{    pta(pc)[0] := Min(255, pta(pc)[0] + 64);
    pta(pc)[1] := Min(127, pta(pc)[1] + 32);
    pta(pc)[2] := Min(127, pta(pc)[2] + 32);
    Inc(pc);
    pta(pc)[0] := Min(255, pta(pc)[0] + 64);
    pta(pc)[1] := Min(127, pta(pc)[1] + 32);
    pta(pc)[2] := Min(127, pta(pc)[2] + 32);
    Inc(pc);
    pta(pc)[0] := Min(255, pta(pc)[0] + 64);
    pta(pc)[1] := Min(127, pta(pc)[1] + 32);
    pta(pc)[2] := Min(127, pta(pc)[2] + 32);
    Inc(pc);
    pta(pc)[0] := Min(255, pta(pc)[0] + 64);
    pta(pc)[1] := Min(127, pta(pc)[1] + 32);
    pta(pc)[2] := Min(127, pta(pc)[2] + 32);  }
    pta(pc)[0] := Clamp255(pta(pc)[0] + b);
    pta(pc)[1] := Clamp255(pta(pc)[1] + b);
    pta(pc)[2] := Clamp255(pta(pc)[2] + b);
    Inc(pc);
    pta(pc)[0] := Clamp255(pta(pc)[0] + b);
    pta(pc)[1] := Clamp255(pta(pc)[1] + b);
    pta(pc)[2] := Clamp255(pta(pc)[2] + b);
    Inc(pc);
    pta(pc)[0] := Clamp255(pta(pc)[0] + b);
    pta(pc)[1] := Clamp255(pta(pc)[1] + b);
    pta(pc)[2] := Clamp255(pta(pc)[2] + b);
 {   Inc(pc);
    pta(pc)[0] := Min(255, pta(pc)[0] + b);
    pta(pc)[1] := Min(127, pta(pc)[1] + b);
    pta(pc)[2] := Min(127, pta(pc)[2] + b);   }
end;

procedure Solid(pc: PCardinal; b1, b2: Integer);
begin
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    Inc(pc);
    pc^ := b2;
end;

procedure Solid2(pc: PCardinal; b1, b2: Integer);
begin
    pc^ := b1;
    Inc(pc);
    pc^ := b2;
end;

procedure TFVoxelExport.PaintNextPreviewSlice(nr: Integer);
var x, y, y2, i, i2, i3, i4, im, ik: Integer;
    PSLstart, PLoffset, bmpSL, bmpOffset, bmpOffP: Integer;
    PC, PSL: PCardinal;
begin
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
    ik := PreviewSize div 64; //1,2,4
    im := 5 - ik;
    if im = 3 then im := 2;   //4,2,1
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
        if PreviewSize = 64 then
        begin
          for x := 0 to PVwid - 1 do
          begin
            if PSL^ > 0 then
            begin
             // if by or (x in [0, 63]) then Solid(PC, $FF0000, $800000)
             // else
              begin
                Solid(PC, i, i4);
                Solid(PCardinal(Integer(PC) + bmpOffset), i2, i3);
                Solid(PCardinal(Integer(PC) + bmpOffset * 2), i2, i3);
                Solid(PCardinal(Integer(PC) + bmpOffset * 3), i2, i3);
              end;
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

procedure TFVoxelExport.Timer2Timer(Sender: TObject);  //preview threads
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

procedure TFVoxelExport.UpDown4Click(Sender: TObject; Button: TUDBtnType);
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

procedure TFVoxelExport.UpDown5Click(Sender: TObject; Button: TUDBtnType);
var d: Double;
begin
    d := 2.2 / (M3Vfile.VHeader.dZoom * M3Vfile.Zscale * Max(1, PVdep - 1));
    if Button = btNext then d := -d;
    M3Vfile.Xoff := M3Vfile.Xoff + d;
    Edit1.Text := FloatToStrSingle(M3Vfile.Xoff);
end;

procedure TFVoxelExport.UpDown6Click(Sender: TObject; Button: TUDBtnType);
var d: Double;
begin
    d := -2.2 / (M3Vfile.VHeader.dZoom * M3Vfile.Zscale * Max(1, PVdep - 1));
    if Button = btNext then d := -d;
    M3Vfile.Yoff := M3Vfile.Yoff + d;
    Edit3.Text := FloatToStrSingle(M3Vfile.Yoff);
end;

procedure TFVoxelExport.UpDown7Click(Sender: TObject; Button: TUDBtnType);
var d: Double;
begin
    d := 2.2 / (M3Vfile.VHeader.dZoom * M3Vfile.Zscale * Max(1, PVdep - 1));
    if Button = btNext then d := -d;
    M3Vfile.Zoff := M3Vfile.Zoff + d;
    Edit4.Text := FloatToStrSingle(M3Vfile.Zoff);
end;

procedure TFVoxelExport.StartNewPreview;
begin
    if CheckBox2.Checked then
    begin
      MCalcStop := True;
      Timer3.Enabled := True;
    end
    else Timer3.Enabled := False;
end;


procedure TFVoxelExport.Timer3Timer(Sender: TObject);
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

procedure TFVoxelExport.UpDown8Click(Sender: TObject; Button: TUDBtnType);
begin
    if Button = btNext then Inc(M3Vfile.MaxIts) else Dec(M3Vfile.MaxIts);
    Edit8.Text := IntToStr(M3Vfile.MaxIts);
end;

procedure TFVoxelExport.UpDown9Click(Sender: TObject; Button: TUDBtnType);
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

procedure TFVoxelExport.RadioGroup4Click(Sender: TObject);
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

procedure TFVoxelExport.Edit10Change(Sender: TObject);  //Zslices
begin
    if bUserChange then
    begin
      MakeM3V;
      CalcImageSize;
      Label12.Caption := IntToStr(M3Vfile.VHeader.Width) + ' x ' +
                         IntToStr(M3Vfile.VHeader.Height);
    end;                     
end;

procedure TFVoxelExport.UpDown10Click(Sender: TObject; Button: TUDBtnType);
begin
    if Button = btNext then Inc(M3Vfile.MinIts) else Dec(M3Vfile.MinIts);
    Edit11.Text := IntToStr(M3Vfile.MinIts);
end;

procedure TFVoxelExport.UpDown11Click(Sender: TObject; Button: TUDBtnType);
var d: Double;
begin
    d := Sqrt(2);
    if Button <> btNext then d := 1 / d;
    M3Vfile.MinDE := MaxCD(M3Vfile.MinDE * d, M3Vfile.DE * 0.254);
    Edit12.Text := FloatToStrSingle(M3Vfile.MinDE);
end;

procedure TFVoxelExport.UpDown1Click(Sender: TObject; Button: TUDBtnType);
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

procedure TFVoxelExport.Button6Click(Sender: TObject);
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

end.
