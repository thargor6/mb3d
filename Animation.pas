unit Animation;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, FileHandling, Mand, Buttons, StdCtrls,
  LightAdjust, HeaderTrafos, TypeDefinitions, Math3D;
type
  TKeyFrame = record
    KFcount, KFtime, KFsmooth: Integer;
    PrevBMP: TBitmap;
    HeaderParas: TMandHeader11;
    HAddOn: THeaderCustomAddon;
  end;
  TAnimationForm = class(TForm)
    Panel2: TPanel;
    Panel3: TPanel;
    Shape1: TShape;
    SpeedButton1: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    Edit2: TEdit;
    Button3: TButton;
    OpenDialog4: TOpenDialog;
    SpeedButton11: TSpeedButton;
    GroupBox1: TGroupBox;
    Button4: TButton;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    SpeedButton4: TSpeedButton;
    Timer2: TTimer;
    PaintBox1: TPaintBox;
    Shape2: TShape;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    Edit1: TEdit;
    Label19: TLabel;
    SpeedButton9: TSpeedButton;
    SaveDialog1: TSaveDialog;
    Label22: TLabel;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    GroupBox3: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    Label24: TLabel;
    Edit6: TEdit;
    Edit7: TEdit;
    Label6: TLabel;
    Edit8: TEdit;
    Label10: TLabel;
    Edit9: TEdit;
    Edit10: TEdit;
    Timer3: TTimer;
    SpeedButton10: TSpeedButton;
    Label16: TLabel;
    Label25: TLabel;
    RadioGroup2: TRadioGroup;
    CheckBox2: TCheckBox;
    RadioGroup3: TRadioGroup;
    GroupBox4: TGroupBox;
    Label20: TLabel;
    Label15: TLabel;
    Edit5: TEdit;
    CheckBox1: TCheckBox;
    Label21: TLabel;
    RadioGroup1: TRadioGroup;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    Label23: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Edit11: TEdit;
    SpeedButton12: TSpeedButton;
    Edit21: TEdit;
    UpDown3: TUpDown;
    Edit12: TEdit;
    UpDown1: TUpDown;
    Edit13: TEdit;
    UpDown2: TUpDown;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure SpeedButton10Click(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox4Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure SpeedButton14Click(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
  private
    { Private-Deklarationen }
    CalcThreadStats: TCalcThreadStats;
    bFirstRender: LongBool;
    MStartPos: TPoint;
    S1leftStart: Integer;
    FirstShow: LongBool;
    iTotalBMPsToRender: Integer;
    RenderedSoFar: Integer;
    PrevRenderNr: Integer;
    RenderStartTime, RenderTime: TDateTime;
    siLight5: array of TsiLight5;
    siLwid, siLhei: Integer;
    aFSIstart: Integer;
    aFSIoffset: Integer;
    bUserChange: LongBool;
    bLoopAni: LongBool;
    iActiveThreads: Integer;
    AniOutFileName: String;
    procedure IncKFabove(nr: Integer);
    function LUTpos(nr: Integer): Integer;
    procedure calcTimeForPreviewRender;
    procedure IncSubFrame;
    procedure SetScrollButton;
    procedure StartCalc;
    procedure ShowProjectName;
    procedure EndRendering;
  protected
    procedure WmThreadReady(var Msg: TMessage); message WM_ThreadReady;
  public
    { Public-Deklarationen }
    KFposLUT: array of Integer;
    KeyFrames: array of TKeyFrame;
    isCalculating: LongBool;
    AniWidth: Integer;
    AniHeight: Integer;
    AniScale: Integer;
    AniCalc3D: LongBool;
    bCalcStop: LongBool;
    AniStereoMode: LongBool;
    AniRightImage: LongBool;
    ActualKeyFrame: Integer;
    ActualKFsubframe: Integer;
    HeaderCount: Integer;
    CurrentNr: Integer;
    AniFileIndex: Integer;
    AniOption: Integer;
    AniIpolType: Integer;
    AniOutputFormat: Integer;
    AniOutputFolder: String;
    AniProjectName: String;
    AniOutFile: TFileStream;
    HybridCustoms: array[0..MAX_FORMULA_COUNT - 1] of TCustomFormula;
    procedure IniKFHeader(nr: Integer);
    procedure RenderPrevBMP(nr: Integer);
    procedure DisableButtons;
    procedure EnableButtons;
    procedure NextSubFrame;
    function LoadAni(FileName: String): Boolean;
    procedure WndProc(var Message: TMessage); override;
    function TotalBMPsToRender(StartKF, stopKF, Step: Integer): Integer;
    procedure InsertFromHeader(Header: TPMandHeader11);
    procedure InsertAniWidHei(Header: TPMandHeader11);
    function SubFramesToKF(KFnr: Integer): Integer;
    function OccupyDFile(Fname: String): LongBool;
    procedure CloseOutPutStream;
  end;

var
  AnimationForm: TAnimationForm;
  AFormCreated: LongBool = False;
  AniStartLoad: LongBool = False;

implementation

uses Math, DivUtils, AniPreviewWindow, Calc, ImageProcess, AniProcess, CalcSR,
     CustomFormulas, DOF, Paint, CalcHardShadow, Interpolation, PaintThread,
     Navigator, Maps, MapSequences;

{$R *.dfm}

procedure TAnimationForm.WmThreadReady(var Msg: TMessage);
begin
    Dec(iActiveThreads);
    if iActiveThreads = 0 then Timer3.Interval := 5; //Timer3Timer(Self);  //only for previewBMP
end;

procedure TAnimationForm.StartCalc;   //only for preview bmp, the animation uses the main calculation process
begin
    CalcVolLightMap(@InterpolHeader, @InterpolLightVals);
    siLwid := InterpolHeader.Width;
    siLhei := InterpolHeader.Height;
    SetLength(siLight5, siLwid * siLhei);
    CalcThreadStats.pLBcalcStop := @bCalcStop;
    CalcThreadStats.pMessageHwnd := Self.Handle;
    CalcThreadStats.iProcessingType := 1;
    CalcThreadStats.iAllProcessingOptions := AllAutoProcessings(@InterpolHeader);
    if CalcMandT(@InterpolHeader, @InterpolLightVals, @CalcThreadStats,
                 @siLight5[0], InterpolHeader.Width * 18, aFSIstart, aFSIoffset, Rect(0, 0, InterpolHeader.Width - 1, InterpolHeader.Height - 1)) then
    begin
      iActiveThreads := CalcThreadStats.iTotalThreadCount;
      Timer3.Enabled := True;
    end;
end;

function TAnimationForm.OccupyDFile(Fname: String): LongBool;
begin  //Try to open OutFile in write access mode
    Result := False;
    CloseOutPutStream;
    AniOutFileName := '';
    if Fname = '' then Exit;
    try
      AniOutFile := TFileStream.Create(Fname, fmCreate or fmShareExclusive);
      Result := True;
    except
      Result := False;
    end;
    if not Result then FreeAndNil(AniOutFile) else AniOutFileName := Fname;
end;

procedure TAnimationForm.CloseOutPutStream;
begin
    if not Assigned(AniOutFile) then Exit;
    FreeAndNil(AniOutFile);
    if (AniOutFileName <> '') and not FileIsBigger1(AniOutFileName) then
      DeleteFile(AniOutFileName);
    AniOutFileName := '';  
end;

procedure TAnimationForm.SetScrollButton;
begin
    if HeaderCount > 1 then
      Shape1.Left := Min(Panel3.Width - Shape1.Width,
        Max(0, Round((CurrentNr - 0.5) * (Panel3.Width - Shape1.Width) /
                     HeaderCount) - (Shape1.Width shr 1)));
end;

procedure TAnimationForm.WndProc(var Message: TMessage);
var xDif, yDif: Integer;
begin
    if Message.Msg = WM_Move then
    begin
      yDif  := Abs(Top - Mand3DForm.Top - Mand3DForm.Height);
      if yDif < 17 then
      begin
        xDif := Abs(Left - Mand3DForm.Left);
        if xDif < 17 then Mand3DForm.bAniFormStick := 1;
      end
      else Mand3DForm.bAniFormStick := 0;
    end;
    inherited WndProc(Message);
end;

function TAnimationForm.TotalBMPsToRender(StartKF, StopKF, Step: Integer): Integer;
var i, sf, t, ie: Integer;
begin
    bLoopAni := CheckBox2.Checked;
    Result := 0;
    sf := 0;
    if bLoopAni then ie := StopKF - 1 else ie := StopKF - 2;
    i := StartKF - 1;
    while i <= ie do
    begin
      t := (KeyFrames[KFposLUT[i]].KFcount - sf) div Step;
      Inc(Result, t);
      sf := sf + t * Step - KeyFrames[KFposLUT[i]].KFcount;
      Inc(i);
    end;
    if (not bLoopAni) and (sf = 0) and (KeyFrames[KFposLUT[StopKF - 1]].KFcount > 0) then Inc(Result);
end;

procedure TAnimationForm.calcTimeForPreviewRender;
var i, startKF, stopKF, t, ie: Integer;
    d, ds: Double;
begin
    if HeaderCount > 0 then
    begin
      bLoopAni := CheckBox2.Checked;
      Val(Trim(Edit9.Text), startKF, i);
      if i <> 0 then Edit9.Font.Color := clMaroon else Edit9.Font.Color := clWindowText;
      if startKF < 1 then startKF := 1;
      Val(Trim(Edit10.Text), stopKF, i);
      if i <> 0 then stopKF := HeaderCount;
      if (stopKF < 1) or (stopKF > HeaderCount) then stopKF := HeaderCount;
      d := 0;
      t := 0;                                                      //downscale
      ds := Sqr(AniWidth / Max(1, KeyFrames[KFposLUT[0]].prevBMP.Width * UpDown2.Position))   //fp error
            / (UpDown1.Position * (1.2 - Sqr(UpDown2.Position - 3) * 0.012));
      if bLoopAni then ie := stopKF - 1 else ie := stopKF - 2;
      for i := startKF - 1 to ie do
      begin
        d := d + KeyFrames[KFposLUT[i]].KFcount *
         ((KeyFrames[KFposLUT[i]].KFtime + KeyFrames[KFposLUT[(i + 1) mod HeaderCount]].KFtime) * ds * 0.5
                                                      + 0.08 / UpDown1.Position);
        t := t + KeyFrames[KFposLUT[i]].KFcount;             //every Nth frame
      end;
      if d >= 86400000 then
        Label14.Caption := '+d ' + FormatDateTime('h:nn:ss', d / 86400000)
      else
        Label14.Caption := FormatDateTime('h:nn:ss', d / 86400000);

      d := Round(t * 4.0 * AniWidth * AniHeight /
           (UpDown1.Position * Sqr(UpDown2.Position)));
      if d * 1.2 > PhysikMemAvail then Label25.Font.Color := clRed else
      if d * 1.5 > PhysikMemAvail then Label25.Font.Color := $60C0 else //orange, yellow is too bright
        Label25.Font.Color := clBlack;
      Label25.Caption := IntToStr(Round(d * 0.954e-6)) + ' MB';
    end
    else
    begin
      Label14.Caption := '0:00';
      Label25.Caption := '  MB';
    end;
end;

procedure TAnimationForm.DisableButtons;
begin
    isCalculating := True;             //must be set before, because aniform will be repainted on disabling!
    SpeedButton1.Enabled := False;
    SpeedButton2.Enabled := False;
    SpeedButton3.Enabled := False;
    SpeedButton4.Enabled := False;
    SpeedButton5.Enabled := False;
    SpeedButton8.Enabled := False;
    SpeedButton9.Enabled := False;
    SpeedButton10.Enabled := False;
    SpeedButton11.Enabled := False;
    SpeedButton12.Enabled := False;
    SpeedButton14.Enabled := False;
    UpDown3.Enabled := False;
    Edit1.Enabled   := False;
    Button2.Enabled := (Button2.Caption = 'Pause rendering');
    Button3.Enabled := False;
    Button4.Enabled := False;
    if AniOption > 0 then
    begin
      Mand3dForm.UpDown1.Enabled := False;
      Mand3dForm.SpeedButton3.Enabled  := False;
      Mand3dForm.SpeedButton13.Enabled := False;
      Mand3dForm.SpeedButton5.Enabled  := False;
      Mand3dForm.SpeedButton6.Enabled  := False;
    end;
    AniProcessForm.Visible := False;
end;

procedure TAnimationForm.EnableButtons;
begin
    SpeedButton1.Enabled := True;
    SpeedButton9.Enabled := True;
    SpeedButton10.Enabled := True;
    SpeedButton11.Enabled := True;
    Edit1.Enabled     := True;
    Button3.Enabled   := True;
    Button2.Enabled   := HeaderCount > 1;
    Button4.Enabled   := Button2.Enabled and not AniPreviewForm.Visible;
    UpDown3.Enabled := True;
    isCalculating     := False;
    Mand3dForm.UpDown1.Enabled := True;
    Mand3dForm.SpeedButton3.Enabled  := True;
    Mand3dForm.SpeedButton13.Enabled := True;
    Mand3dForm.SpeedButton5.Enabled  := True;
    Mand3dForm.SpeedButton6.Enabled  := True;
    SetScrollButton;
    Invalidate;
end;

procedure TAnimationForm.FormCreate(Sender: TObject);
var i: Integer;
begin
    HeaderCount := 0;
    AniOption   := 0;
    CurrentNr   := 1;
    FirstShow   := True;
    bUserChange := True;
    isCalculating := False;
    for i := 0 to MAX_FORMULA_COUNT - 1 do IniCustomF(@HybridCustoms[i]);
end;

procedure TAnimationForm.FormDestroy(Sender: TObject);
var i: Integer;
begin
    IniVal[7] := Edit5.Text;
    IniVal[9] := IntToStr(RadioGroup2.ItemIndex);
    for i := 0 to HeaderCount - 1 do FreeAndNil(KeyFrames[i].PrevBMP);
    for i := 0 to MAX_FORMULA_COUNT - 1 do FreeCF(@HybridCustoms[i]);
end;

procedure TAnimationForm.Button1Click(Sender: TObject);
begin
    Visible := False;
end;

procedure TAnimationForm.Shape1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbLeft then
    begin
      GetCursorPos(MStartPos);
      S1leftStart := Shape1.Left;
    end;
end;

procedure TAnimationForm.Shape1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var MPos: TPoint;
    cn: Integer;
begin
    if ssLeft in Shift then
    begin
      GetCursorPos(MPos);
      Shape1.Left := Max(0, Min(Panel3.Width - Shape1.Width, S1leftStart + MPos.X - MStartPos.X));
      cn := Max(0, Min(HeaderCount, Round(Shape1.Left * HeaderCount /
                                          (Panel3.Width - Shape1.Width)))) + 1;
      if cn <> CurrentNr then
      begin
        CurrentNr := cn;
        PaintBox1.Invalidate;
      end;
    end;
end;

procedure TAnimationForm.IniKFHeader(nr: Integer);
var i: Integer;
begin
    with KeyFrames[nr] do
    begin
      HeaderParas.PCFAddon := @HAddOn;
      for i := 0 to MAX_FORMULA_COUNT -1 do HeaderParas.PHCustomF[i] := @HybridCustoms[i];
      InsertAniWidHei(@HeaderParas);
      HeaderParas.bHScalculated := 0;
      HeaderParas.bStereoMode := 0;//StereoMode;
    end;
end;

procedure TAnimationForm.InsertFromHeader(Header: TPMandHeader11);
begin
    if CurrentNr = HeaderCount + 1 then
    begin
      Setlength(KeyFrames, CurrentNr);
      Setlength(KFposLUT, CurrentNr);
      KeyFrames[HeaderCount].PrevBMP := TBitmap.Create;
      KeyFrames[HeaderCount].KFcount := StrToIntTrim(Edit5.Text);
    //  KeyFrames[HeaderCount].KFsmooth := SpinEdit3.Value;
      KFposLUT[HeaderCount] := HeaderCount;
      HeaderCount := CurrentNr;
      Edit1.Text := Edit5.Text;
    end;
    IniKFHeader(KFposLUT[CurrentNr - 1]);
    AssignHeader(@KeyFrames[KFposLUT[CurrentNr - 1]].HeaderParas, Header);
    KeyFrames[KFposLUT[CurrentNr - 1]].HeaderParas.bCalc3D := Byte(RadioGroup1.ItemIndex = 0);
    if CurrentNr = 1 then
    begin
      AniScale   := Max(1, Header.bImageScale);
      AniWidth   := Header.Width div AniScale;
      AniHeight  := Header.Height div AniScale;
      Edit6.Text := IntToStr(AniWidth);
      Edit7.Text := IntToStr(AniHeight);
      UpDown3.Position := AniScale;
    end;
    RenderPrevBMP(KFposLUT[CurrentNr - 1]);
    if CheckBox1.Checked then Inc(CurrentNr);
end;

procedure TAnimationForm.SpeedButton1Click(Sender: TObject); // insert paras to this KF
begin
    Mand3DForm.MakeHeader;
    InsertFromHeader(@Mand3DForm.MHeader);
end;

procedure TAnimationForm.SpeedButton4Click(Sender: TObject);  //insert KF in between
begin
    Inc(HeaderCount);
    Setlength(KeyFrames, HeaderCount);
    Setlength(KFposLUT, HeaderCount);
    IncKFabove(CurrentNr + 1);
    KeyFrames[HeaderCount - 1].PrevBMP  := TBitmap.Create;
    KeyFrames[HeaderCount - 1].KFcount  := StrToIntTry(Edit5.Text, 50);
  //  KeyFrames[HeaderCount - 1].KFsmooth := SpinEdit3.Value;
    KFposLUT[CurrentNr] := HeaderCount - 1;
    Mand3DForm.MakeHeader;
    IniKFHeader(HeaderCount - 1);
    AssignHeader(@KeyFrames[HeaderCount - 1].HeaderParas, @Mand3DForm.MHeader);
    KeyFrames[HeaderCount - 1].HeaderParas.bCalc3D := Byte(RadioGroup1.ItemIndex = 0);
    RenderPrevBMP(HeaderCount - 1);
    Inc(CurrentNr);
end;

procedure TAnimationForm.IncKFabove(nr: Integer);
var i: Integer;
begin
    for i := HeaderCount - 1 downto nr do KFposLUT[i] := KFposLUT[i - 1];
end;

procedure TAnimationForm.ShowProjectName;
begin
    Caption := 'Animation maker   (' + AniProjectName + ')';
  //  Edit11.Text := AniProjectName;
end;

procedure TAnimationForm.FormShow(Sender: TObject);
var c: Integer;
begin
    if FirstShow then
    begin
      FirstShow := False;
      Edit21.Hint := '1:  none' + #13#10 + '2:  2x2' + #13#10 + '3:  3x3';
      SetDialogDirectory(SaveDialog1, IniDirs[4]);
      SetDialogDirectory(OpenDialog4, IniDirs[4]);
      if not AniStartLoad then
      begin
        RadioGroup2.ItemIndex := Min(2, StrToIntTry(IniVal[9], 1));
        AniOutputFolder := IniDirs[5];
        Edit2.Text := AniOutputFolder;
        AniProjectName := 'new';
        ShowProjectName;
      end;
      AniStartLoad := False;
      c := ColorToRGB(clBtnFace);
      if (c and $FF00) > $80 then c := $F04000 else c := $FFA040;
      Label29.Font.Color := c;
    end;
    Edit5.Text := IniVal[7];
    AFormCreated := True;
end;

procedure TAnimationForm.Edit1Change(Sender: TObject);
var i, c: Integer;
begin
    if bUserChange and (CurrentNr <= HeaderCount) then
    begin
      Val(Trim(Edit1.Text), i, c);
      if c = 0 then
      begin
        KeyFrames[KFposLUT[CurrentNr - 1]].KFcount := i;
        calcTimeForPreviewRender;
      end;
    end;
end;

procedure TAnimationForm.Edit1Exit(Sender: TObject);
begin
  if CurrentNr < HeaderCount then
    RenderPrevBMP(KFposLUT[CurrentNr]);
end;

procedure TAnimationForm.Button3Click(Sender: TObject);
begin
    AniOutputFolder := GetDirectory(IniDirs[5], AnimationForm);
    Edit2.Text := AniOutputFolder;
end;

function TAnimationForm.LoadAni(FileName: String): Boolean;          //Load Ani file
var i, n, y, x, HC, v: Integer;
    f: file;
    buf: array of Cardinal;
    pc: PCardinal;
    s: ShortString;
    tHeader: TMandHeader9;
begin
    Result := False;
    if FileExists(FileName) and not isCalculating then
    begin
      AssignFile(f, FileName);
      try
        Reset(f, 1);
        for i := 0 to HeaderCount - 1 do FreeAndNil(KeyFrames[i].PrevBMP);
        HeaderCount := 0;
        CurrentNr   := 1;
        BlockRead(f, v, 4);    //version
        if v > 5 then
        begin
          ShowMessage('The file version is to high, use a more actual program version');
          Exit;
        end;
        BlockRead(f, AniWidth, 4);
        BlockRead(f, AniHeight, 4);
        BlockRead(f, AniScale, 4);
        BlockRead(f, AniCalc3D, 4); //obs?
        BlockRead(f, s[0], 256);
        AniOutputFolder := s;
        CheckBox2.Checked := False;
        CheckBox4.Checked := False;  //Stereo
        CheckBox5.Checked := False;  //only left-eye
        CheckBox6.Checked := True;   //overwrite existing images
        CheckBox7.Checked := False;  //save z-buffer
        RadioGroup3.ItemIndex := 0;
        if v > 1 then
        begin
          BlockRead(f, i, 4);
          if v = 5 then
          begin
            RadioGroup2.ItemIndex := (i and 3);
            CheckBox2.Checked := (i and 4) <> 0;      // loop ani
            RadioGroup3.ItemIndex := (i shr 3) and 7;
            CheckBox4.Checked := (i and 64) <> 0;
            CheckBox5.Checked := (i and 128) <> 0;
            CheckBox6.Checked := (i and 256) = 0;
            CheckBox7.Checked := (i and 512) <> 0;
          end
          else
          begin
            if v < 3 then RadioGroup2.ItemIndex := 1
                     else RadioGroup2.ItemIndex := Min(1, (i and 3) div 2);
          end;
        end;
        BlockRead(f, HC, 4);                //HeaderCount
        if (HC < 1) or (HC > 4095) then Exit;
        SetLength(KeyFrames, HC);
        Setlength(KFposLUT, HC);
        for i := 0 to HC - 1 do
        begin
          KFposLUT[i] := i;
          BlockRead(f, KeyFrames[i].KFcount, 4);
          BlockRead(f, KeyFrames[i].KFtime, 4);
          BlockRead(f, KeyFrames[i].KFsmooth, 4);
          if v < 3 then KeyFrames[i].KFsmooth := RadioGroup2.ItemIndex;
          if v < 5 then BlockRead(f, tHeader, SizeOf(TMandHeader9))
                   else BlockRead(f, KeyFrames[i].HeaderParas, SizeOf(TMandHeader11));
          if v < 5 then
          begin
            tHeader.PCFAddon := @KeyFrames[i].HAddOn;
            for y := 0 to MAX_FORMULA_COUNT - 1 do tHeader.PHCustomF[y] := @HybridCustoms[y];
            if not ConvertHeaderFromOldParas(TMandHeader8(tHeader), True) then Exit;
            FastMove(tHeader, KeyFrames[i].HeaderParas, SizeOf(TMandHeader9) - SizeOf(TLightingParas8));
            ConvertLight8to9(tHeader.Light, KeyFrames[i].HeaderParas.Light);
          end;
          IniKFHeader(i);
          if v > 3 then LoadHAddon(f, @KeyFrames[i].HAddon);
          if KeyFrames[i].HeaderParas.MandId < 20 then
          begin
            UpdateFormulaOptionTo20(PTHeaderCustomAddon(KeyFrames[i].HeaderParas.PCFAddon));
          end
          else if (i = 0) then LoadBackgroundPicT(@KeyFrames[i].HeaderParas.Light);
          UpdateFormulaOptionAbove20(KeyFrames[i].HeaderParas);
          UpdateLightParasAbove3(KeyFrames[i].HeaderParas.Light);

        //  IniKFHeader(i);
          IniCFsFromHAddon(@KeyFrames[i].HAddon, KeyFrames[i].HeaderParas.PHCustomF);
          //  do it just before interpolating,or in interpolatefunc, no customF's here!
        end;
        for i := 0 to HC - 1 do
        begin
          KeyFrames[i].PrevBMP := TBitmap.Create;
          HeaderCount := i + 1;
          KeyFrames[i].PrevBMP.PixelFormat := pf32bit;
          BlockRead(f, n, 4);
        //  KeyFrames[i].PrevBMP.Width := n;
          SetLength(buf, n);
          BlockRead(f, y, 4);
          KeyFrames[i].PrevBMP.SetSize(n, y);
          while y > 0 do
          begin
            Dec(y);
            pc := KeyFrames[KFposLUT[i]].PrevBMP.ScanLine[y];
            BlockRead(f, buf[0], 4 * n);
            for x := 0 to n - 1 do
            begin
              pc^ := buf[x];
              Inc(pc);
            end;
          end;
        end;
        Result := True;
        AniProjectName := ChangeFileExtSave(ExtractFileName(FileName), '');
        ShowProjectName;
      finally
        CloseFile(f);
        Edit6.Text := IntToStr(AniWidth);
        Edit7.Text := IntToStr(AniHeight);
        Edit2.Text := AniOutputFolder;
        UpDown3.Position := AniScale;
        PaintBox1.Invalidate;
        Mand3DForm.EnableButtons;
        calcTimeForPreviewRender;
      end;
      SetDialogName(SaveDialog1, OpenDialog4.FileName);
    end;
end;

procedure TAnimationForm.SpeedButton11Click(Sender: TObject); //Load Ani file
begin
    if OpenDialog4.Execute then LoadAni(OpenDialog4.FileName);
end;

procedure TAnimationForm.RenderPrevBMP(nr: Integer);
var d: Double;
    w, h: Integer;
begin
    TMapSequenceFrameNumberHolder.SetCurrFrameNumber(TotalBMPsToRender(1, nr + 1, 1));

    if AniWidth >= AniHeight * 1.25 then d := 100 / AniWidth
                                    else d :=  80 / AniHeight;
    w := Round(AniWidth * d);
    h := Max(2, Round(AniHeight * d));
    KeyFrames[nr].PrevBMP.PixelFormat := pf32Bit;
    KeyFrames[nr].PrevBMP.Width  := w;
    KeyFrames[nr].PrevBMP.Height := h;
    KeyFrames[nr].HeaderParas.bCalc3D := Byte(RadioGroup1.ItemIndex = 0);
    aFSIstart  := Integer(KeyFrames[nr].PrevBMP.Scanline[0]);
    aFSIoffset := Integer(KeyFrames[nr].PrevBMP.Scanline[1]) - aFSIstart;
    PrevRenderNr := nr;
    IniInterpolHeader;
    AssignHeader(@InterpolHeader, @KeyFrames[nr].HeaderParas);
    IniCFsFromHAddon(@InterpolHAddon, InterpolHeader.PHCustomF);
    d := w / AniWidth;
    InterpolHeader.Width   := w;
    InterpolHeader.Height  := h;
    InterpolHeader.sDEstop := InterpolHeader.sDEstop * d;
    InterpolHeader.sDOFclipR := InterpolHeader.sDOFclipR * d;
    InterpolHeader.bSliceCalc := 2;
    InterpolHeader.bHScalculated := 0;
    MakeLightValsFromHeaderLight(@InterpolHeader, @InterpolLightVals, 1, 0);
    AniOption := 1;
    bCalcStop := False;
    Mand3DForm.DisableButtons;
    StartCalc;
end;

procedure TAnimationForm.SpeedButton7Click(Sender: TObject);  //scoll left by 1
begin
    if CurrentNr > 1 then
    begin
      Dec(CurrentNr);
      SetScrollButton;
      PaintBox1.Invalidate;
    end;
end;

procedure TAnimationForm.SpeedButton6Click(Sender: TObject);
begin
    if CurrentNr <= HeaderCount then
    begin
      Inc(CurrentNr);
      SetScrollButton;
      PaintBox1.Invalidate;
    end;
end;

function TAnimationForm.LUTpos(nr: Integer): Integer;
var i: Integer;
begin
    i := 0;
    while (i < HeaderCount) do
    begin
      if KFposLUT[i] = nr then Break;
      Inc(i);
    end;
    Result := Min(i, HeaderCount - 1);
end;

procedure TAnimationForm.SpeedButton5Click(Sender: TObject);  //delete KF
var i, i2: Integer;
begin
    if CurrentNr <= HeaderCount then
    begin
      i := KFposLUT[CurrentNr - 1];  //Frame to delete
      if i < HeaderCount - 1 then
      begin   //copy last frame to actpos and delete last frame
        KFposLUT[LUTpos(HeaderCount - 1)] := i;
        KeyFrames[i].PrevBMP.Assign(KeyFrames[HeaderCount - 1].PrevBMP);
        KeyFrames[i].KFcount     := KeyFrames[HeaderCount - 1].KFcount;
        KeyFrames[i].KFtime      := KeyFrames[HeaderCount - 1].KFtime;
        KeyFrames[i].KFsmooth    := KeyFrames[HeaderCount - 1].KFsmooth;
        AssignHeader(@KeyFrames[i].HeaderParas, @KeyFrames[HeaderCount - 1].HeaderParas);
      end;
      for i2 := CurrentNr - 1 to HeaderCount - 2 do
        KFposLUT[i2] := KFposLUT[i2 + 1];
      Dec(HeaderCount);
      KeyFrames[HeaderCount].PrevBMP.Free;
      PaintBox1.Invalidate;
      if HeaderCount < 2 then
      begin
        Button2.Enabled := False;
        Button4.Enabled := False;
      end;
      calcTimeForPreviewRender;
      SetScrollButton;
    end;
end;

procedure TAnimationForm.SpeedButton2Click(Sender: TObject);  //change with prev frame
var i1, i2: Integer;
begin
    i1 := KFposLUT[CurrentNr - 1];
    i2 := KFposLUT[CurrentNr - 2];
    KFposLUT[CurrentNr - 1] := i2;
    KFposLUT[CurrentNr - 2] := i1;
    PaintBox1.Invalidate;
end;

procedure TAnimationForm.SpeedButton3Click(Sender: TObject);  //change with next frame
var i1, i2: Integer;
begin
    i1 := KFposLUT[CurrentNr - 1];
    i2 := KFposLUT[CurrentNr];
    KFposLUT[CurrentNr - 1] := i2;
    KFposLUT[CurrentNr] := i1;
    PaintBox1.Invalidate;
end;

procedure TAnimationForm.SpeedButton8Click(Sender: TObject);  //copy Paras from KF to Mand3D
begin
    AssignHeader(@Mand3DForm.MHeader, @KeyFrames[KFposLUT[CurrentNr - 1]].HeaderParas);
    IniCFsFromHAddon(Mand3DForm.MHeader.PCFAddon, Mand3DForm.MHeader.PHCustomF);
    Mand3DForm.MHeader.Width := AniWidth * AniScale;
    Mand3DForm.MHeader.Height := AniHeight * AniScale;
    Mand3DForm.MHeader.bImageScale := AniScale;
    Mand3DForm.MHeader.bStereoMode := 0;
    Mand3DForm.Authors[0] := '?';
    Mand3DForm.Authors[1] := '';
    Mand3DForm.SetEditsFromHeader;
    LightAdjustForm.SetLightFromHeader(Mand3DForm.MHeader);
    Mand3DForm.Caption := 'Keyframe #' + IntToStr(CurrentNr);
    Mand3DForm.ParasChanged;
    SetFocus;
    //+paint2D?
end;

function TAnimationForm.SubFramesToKF(KFnr: Integer): Integer;
var i: Integer;
begin
    Result := 0;
    for i := 0 to Min(HeaderCount, KFnr) - 1 do
      Result := Result + KeyFrames[KFposLUT[i]].KFcount;
end;

procedure TAnimationForm.PaintBox1Paint(Sender: TObject);
var i, i2, i3, i4: Integer;
begin
    if CurrentNr <= HeaderCount + 1 then
    begin
      if CurrentNr > 2 then
      begin
        Label1.Caption := IntToStr(CurrentNr - 2);
        Label23.Caption := IntToStr(KeyFrames[KFposLUT[CurrentNr - 3]].KFcount);
      end else begin
        Label1.Caption := '';
        Label23.Caption := '';
      end;
      if CurrentNr > 1 then
      begin
        Label2.Caption := IntToStr(CurrentNr - 1);
        Label26.Caption := IntToStr(KeyFrames[KFposLUT[CurrentNr - 2]].KFcount);
      end else begin
        Label2.Caption := '';
        Label26.Caption := '';
      end;
      Label3.Caption := IntToStr(CurrentNr);
      Label29.Caption := IntToStr(SubFramesToKF(CurrentNr));
      if CurrentNr < HeaderCount then
      begin
        Label4.Caption := IntToStr(CurrentNr + 1);
        Label27.Caption := IntToStr(KeyFrames[KFposLUT[CurrentNr]].KFcount);
      end else begin
        Label4.Caption := '';
        Label27.Caption := '';
      end;
      if CurrentNr < HeaderCount - 1 then
      begin
        Label5.Caption := IntToStr(CurrentNr + 2);
        Label28.Caption := IntToStr(KeyFrames[KFposLUT[CurrentNr + 1]].KFcount);
      end else begin
        Label5.Caption := '';
        Label28.Caption := '';
      end;
      Edit1.Visible := HeaderCount >= CurrentNr;
      if Edit1.Visible then
      begin
        bUserChange := False;
        Edit1.Text  := IntToStr(KeyFrames[KFposLUT[CurrentNr - 1]].KFcount);
        bUserChange := True;
      end;
      if not isCalculating then
      begin
        SpeedButton2.Enabled := (CurrentNr > 1) and (CurrentNr <= HeaderCount);  //exchange KF with prev
        SpeedButton3.Enabled := CurrentNr < HeaderCount;                //exchange KF with next
        SpeedButton4.Enabled := CurrentNr < HeaderCount;                //insert Frame between
        SpeedButton5.Enabled := CurrentNr <= HeaderCount;               //delete KF
        SpeedButton8.Enabled := CurrentNr <= HeaderCount;               //Copy pars to main
        SpeedButton14.Enabled := CurrentNr <= HeaderCount;
        SpeedButton12.Enabled := CurrentNr < HeaderCount;
      end;
      if AniProcessForm.Visible then
      begin
        AniProcessForm.Button2.Enabled := HeaderCount > 0;
        AniProcessForm.Button5.Enabled := HeaderCount > 0;
        AniProcessForm.Button3.Enabled := CurrentNr <= HeaderCount;
        AniProcessForm.Button4.Enabled := CurrentNr <= HeaderCount;
        AniProcessForm.Button6.Enabled := CurrentNr <= HeaderCount;
      end;
      SpeedButton6.Enabled := CurrentNr <= HeaderCount;               //scroll by 1 higher
      SpeedButton7.Enabled := CurrentNr > 1;                          //scroll by 1 lower
      //draw bmp's
      PaintBox1.Canvas.Brush.Color := clBtnFace;
      i4 := SpeedButton5.Top + SpeedButton5.Height + 2;
    //  if HeaderCount > 0 then i4 := i4 + //bmp centering
      for i := 0 to 4 do
      begin
        i2 := i + CurrentNr - 3;
        i3 := i * (Label2.Left - Label1.Left) + 14;
        if (i2 >= 0) and (i2 < HeaderCount) then
          PaintBox1.Canvas.Draw(i3, i4, KeyFrames[KFposLUT[i2]].PrevBMP)
        else
          PaintBox1.Canvas.FillRect(Rect(i3, i4, i3 + 101, i4 + 80));
      end;
    end;
end;

procedure TAnimationForm.SpinEdit1Change(Sender: TObject);
begin
    calcTimeForPreviewRender;
end;

procedure TAnimationForm.Button2Click(Sender: TObject);  // start rendering
begin
    if Button2.Caption = 'Pause rendering' then
    begin
      Button2.Caption := 'Pausing on next frame...';
      Button2.Enabled := False;
    end
    else if Button2.Caption = 'Paused, press to continue' then
    begin
      Button2.Caption := 'Pause rendering';
    end else begin
   //   DummyFile := '';
      AniOption := 3;  //for DisableButtons to disable prevButtons etc.
      Mand3DForm.DisableButtons;
      Button2.Caption  := 'Pause rendering';
      Button2.Enabled  := True;
      RenderStartTime  := now;
      AniFileIndex     := StrToIntTrim(Edit3.Text);
      TMapSequenceFrameNumberHolder.SetCurrFrameNumber(AniFileIndex);
      iTotalBMPsToRender := TotalBMPsToRender(1, HeaderCount, 1);
      AniIpolType      := RadioGroup2.ItemIndex;
      AniOutputFormat  := RadioGroup3.ItemIndex;
      AniStereoMode    := CheckBox4.Checked;
      AniScale         := UpDown3.Position;
      AniRightImage    := True;
      if AniStereoMode and CheckBox5.Checked then AniRightImage := False;
      RenderedSoFar    := 0;
      ActualKeyFrame   := 0;
      ActualKFsubframe := 0;
      bCalcStop        := False;
      bFirstRender     := True;
      isCalculating    := True;
    //  if (not CheckBox6.Checked) and (not AniFileAlreadyExists(DummyFile)) then
      //  MakeDummyFile(DummyFile);
      Timer2.Enabled   := True;
    end;
end;

{
    TFileStream.Create(FileName, fmOpenWrite or fmShareExclusive)

}
{procedure TAnimationForm.MakeDummyFile(mDummyFile: String);
var f: file;
    buf: Byte;
begin
    if not FileExists(mDummyFile) then
    begin
      AssignFile(f, mDummyFile);
      Rewrite(f, 1);
      try
        buf := 0;
        BlockWrite(f, buf, 1);
      finally
        CloseFile(f);
      end;
      DummyFile := mDummyFile;
    end;
end;  }

procedure TAnimationForm.IncSubFrame;
begin
    Inc(AniFileIndex, StrToIntTrim(Edit4.Text));
    TMapSequenceFrameNumberHolder.SetCurrFrameNumber(AniFileIndex);
    Inc(RenderedSoFar);
    Inc(ActualKFsubframe);
    Label19.Caption := 'Done: ' + IntToStr(RenderedSoFar) + ' of ' + IntToStr(Min(iTotalBMPsToRender,
      StrToIntTry(Edit11.Text, 2000000000) div StrToIntTrim(Edit4.Text)));
    while (ActualKeyFrame < HeaderCount) and
       (ActualKFsubframe >= KeyFrames[KFposLUT[ActualKeyFrame]].KFcount) do //ommit KFs with count 0
    begin
      ActualKFsubframe := 0;
      Inc(ActualKeyFrame);
    end;
end;

procedure TAnimationForm.EndRendering;
var i: Integer;
begin
    Label19.Caption := '';
    AniOption := 0;
    for i := 1 to 9 do SetLength(ATrousWL[i], 0);
    Mand3DForm.EnableButtons;
    Button2.Caption := 'Start rendering animation images';
    Button2.Enabled := True;
    CloseOutPutStream;
end;

procedure TAnimationForm.NextSubFrame;
//var bs: LongBool;
begin
    RenderTime := now - RenderStartTime;
    Timer2.Enabled := False;
 //   bs := False;
    Label22.Caption := dDateTimeToStr(RenderTime);
    if AniStereoMode and not (bCalcStop or CheckBox5.Checked) then
    begin
      AniRightImage := not AniRightImage;
      if AniRightImage then IncSubFrame;
    end
    else IncSubFrame;
    if (StrToIntTry(Edit11.Text, 2000000000) >= AniFileIndex) and
       (ActualKeyFrame < HeaderCount) and (ActualKFsubframe < KeyFrames[KFposLUT[ActualKeyFrame]].KFcount) then
    begin
      if Button2.Caption = 'Pausing on next frame...' then
      begin
        Button2.Caption := 'Paused, press to continue';
        Button2.Enabled := True;
      end;
      while (Button2.Caption = 'Paused, press to continue') and (not bCalcStop) do Delay(500);
      if not bCalcStop then Timer2.Enabled := True;
    end;
    if not Timer2.Enabled then EndRendering;
end;

procedure TAnimationForm.InsertAniWidHei(Header: TPMandHeader11);
begin
    Header.Width := AniWidth * AniScale;
    Header.Height := AniHeight * AniScale;
    Header.bImageScale := AniScale;
end;

procedure TAnimationForm.Timer2Timer(Sender: TObject);     //main ani rendering timer, next frame
var i0, i1, i2, i3, StereoMode: Integer;
    PL0, PL1, PL2, PL3: TPLightVals;
    t: Double;
    L0, L1, L2, L3: TLightVals;
begin
    Timer2.Enabled := False;
    i0 := StrToIntTrim(Edit8.Text);       //skip upto startindex
    while (ActualKeyFrame < HeaderCount) and (AniFileIndex < i0) do IncSubFrame;
    if ActualKeyFrame >= HeaderCount then
    begin
      EndRendering;
      Exit;
    end;
    i1 := KFposLUT[ActualKeyFrame];             //render also last KFs subframecount???
    if bLoopAni then
    begin
      i0 := KFposLUT[(ActualKeyFrame - 1 + HeaderCount) mod HeaderCount];
      i2 := KFposLUT[(ActualKeyFrame + 1) mod HeaderCount];
      i3 := KFposLUT[(ActualKeyFrame + 2) mod HeaderCount];
    end else begin
      if ActualKeyFrame > 0 then i0 := KFposLUT[ActualKeyFrame - 1] else i0 := i1;
      if ActualKeyFrame < HeaderCount - 1 then i2 := KFposLUT[ActualKeyFrame + 1]
      else i2 := i1;
      if ActualKeyFrame < HeaderCount - 2 then i3 := KFposLUT[ActualKeyFrame + 2]
      else i3 := i2;
    end;
    t := ActualKFsubframe / Max(1, KeyFrames[i1].KFcount);
    StereoMode := 0;
    if AniStereoMode then
    begin
      if CheckBox5.Checked then StereoMode := 1 else
      if AniRightImage then StereoMode := 3 else StereoMode := 4;
    end;

      PL0 := @L0;
      PL1 := @L1;
      PL2 := @L2;
      PL3 := @L3;
      IniLVal(PL0);
      IniLVal(PL1);
      IniLVal(PL2);
      IniLVal(PL3);

      IniInterpolHeader;

      AnimationForm.IniKFHeader(i1);
      AssignHeader(@InterpolHeader, @KeyFrames[i1].HeaderParas);  //for all paras not to be interpolated     KF[0] Addons are all 0 on the 2nd assignment


      MakeLightValsFromHeaderLight(@KeyFrames[i1].HeaderParas, @L1, 1, StereoMode); //to ini pointer etc
      AssignLightVal(@InterpolLightVals, @L1);
      L0.iKFcount := Max(1, KeyFrames[i0].KFcount);
      L1.iKFcount := Max(1, KeyFrames[i1].KFcount);
      L2.iKFcount := Max(1, KeyFrames[i2].KFcount);
      L3.iKFcount := Max(1, KeyFrames[i3].KFcount);

      CopyRotMfromLightVals(PL1, @IPOLM1);
      if i0 = i1 then
      begin
        PL0 := PL1;
        CopyRotMatices(@IPOLM1, @IPOLM0);
      end
      else if AniIpolType > 0 then
      begin
        AnimationForm.IniKFHeader(i0);
        MakeLightValsFromHeaderLight(@KeyFrames[i0].HeaderParas, PL0, 1, StereoMode);  //imagescale?
        CopyRotMfromLightVals(PL0, @IPOLM0);
      end;
      if i2 = i1 then
      begin
        PL2 := PL1;
        CopyRotMatices(@IPOLM1, @IPOLM2);
      end
      else
      begin
        AnimationForm.IniKFHeader(i2);
        MakeLightValsFromHeaderLight(@KeyFrames[i2].HeaderParas, PL2, 1, StereoMode);
        CopyRotMfromLightVals(PL2, @IPOLM2);
      end;
      if i3 = i1 then
      begin
        PL3 := PL1;
        CopyRotMatices(@IPOLM1, @IPOLM3);
      end
      else if i3 = i2 then
      begin
        PL3 := PL2;
        CopyRotMatices(@IPOLM2, @IPOLM3);
      end
      else if AniIpolType > 0 then
      begin
        AnimationForm.IniKFHeader(i3);
        MakeLightValsFromHeaderLight(@KeyFrames[i3].HeaderParas, PL3, 1, StereoMode);
        CopyRotMfromLightVals(PL3, @IPOLM3);
      end;

      if AniIpolType = 0 then  //linear
      begin
        if i1 <> i2 then
          Interpolate2frames(@KeyFrames[i1].HeaderParas, @KeyFrames[i2].HeaderParas, PL1, PL2, t);
      end
      else // if AniIpolType = 1 then //bezier
      begin
        Interpolate3framesBezier(@KeyFrames[i0].HeaderParas, @KeyFrames[i1].HeaderParas,
            @KeyFrames[i2].HeaderParas, @KeyFrames[i3].HeaderParas, PL0, PL1, PL2, PL3, t);
   {   end
      else    //cubic
      begin
        Interpolate4framesCubic(@KeyFrames[i0].HeaderParas, @KeyFrames[i1].HeaderParas,
          @KeyFrames[i2].HeaderParas, @KeyFrames[i3].HeaderParas, PL0, PL1, PL2, PL3, t);  }
      end;
      AniCalc3D := KeyFrames[i1].HeaderParas.bCalc3D > 0;
      AssignHeader(@Mand3DForm.MHeader, @InterpolHeader);
      IniCFsFromHAddon(Mand3DForm.MHeader.PCFaddon, Mand3DForm.MHeader.PHCustomF);
      Mand3DForm.MHeader.bSliceCalc  := 2;
      Mand3DForm.MHeader.bCalc3D     := Byte(AniCalc3D);
      Mand3DForm.MHeader.Width       := AniWidth  * AniScale;
      Mand3DForm.MHeader.Height      := AniHeight * AniScale;
      Mand3DForm.MHeader.bImageScale := AniScale;
      Mand3DForm.MHeader.sDEstop     := Mand3DForm.MHeader.sDEstop * AniScale;
      Mand3DForm.MHeader.TilingOptions := 0;
      Mand3DForm.MHeader.bStereoMode := StereoMode;
      AssignLightVal(@Mand3DForm.HeaderLightVals, @InterpolLightVals);

      FreeLightMapsInLValsWithRestriction(Pl0, @InterpolLightVals);
      FreeLightMapsInLValsWithRestriction(Pl1, @InterpolLightVals);
      FreeLightMapsInLValsWithRestriction(Pl2, @InterpolLightVals);
      FreeLightMapsInLValsWithRestriction(Pl3, @InterpolLightVals);

      ImageScale := AniScale;
      Mand3DForm.CalcMand(False);
end;

procedure TAnimationForm.SpeedButton9Click(Sender: TObject);       //Save Ani pars
var i, n, y, x: Integer;
    f: file;
    buf: array of Cardinal;
    pc: PCardinal;
    s: ShortString;
begin
    AniScale := UpDown3.Position;
    if SaveDialog1.Execute then
    begin
      AssignFile(f, ChangeFileExtSave(SaveDialog1.FileName, '.m3a'));
      try
        Rewrite(f, 1);
        i := 5;                    //version  5 -> mandheader10    todo: make AniHeader record
        BlockWrite(f, i, 4);
        BlockWrite(f, AniWidth, 4);
        BlockWrite(f, AniHeight, 4);
        BlockWrite(f, AniScale, 4);
        BlockWrite(f, AniCalc3D, 4);
        s := Copy(AniOutputFolder, 1, 255);
        BlockWrite(f, s[0], 256);
        i := RadioGroup2.ItemIndex or ((Ord(CheckBox2.Checked) and 1) shl 2) or
         ((Ord(CheckBox4.Checked) and 1) shl 6) or (RadioGroup3.ItemIndex shl 3) or //ipol function: (0-linear, 1-bezier, 2-cubic)   ,was bezier smooth
         ((Ord(CheckBox5.Checked) and 1) shl 7) or (((Ord(CheckBox6.Checked) and 1) xor 1) shl 8) or
         ((Ord(CheckBox7.Checked) and 1) shl 9);

        BlockWrite(f, i, 4);                                          //bit1+2:ipolfunction, bit3: loopAni, bit4-6: output filetype
        BlockWrite(f, HeaderCount, 4);                                //bit7:stereo animation, bit8:only lefteye, bit9: overwrite existing images
        for i := 0 to HeaderCount - 1 do                              //bit10: save zbuffer
        begin
          BlockWrite(f, KeyFrames[KFposLUT[i]].KFcount, 4);
          BlockWrite(f, KeyFrames[KFposLUT[i]].KFtime, 4);
          BlockWrite(f, KeyFrames[KFposLUT[i]].KFsmooth, 4);
          KeyFrames[KFposLUT[i]].HeaderParas.MandId := actMandId;
          BlockWrite(f, KeyFrames[KFposLUT[i]].HeaderParas, SizeOf(TMandHeader11));
          KeyFrames[KFposLUT[i]].HAddOn.bHCAversion := 16; 
          BlockWrite(f, KeyFrames[KFposLUT[i]].HAddOn, SizeOf(THeaderCustomAddon));
        end;
        for i := 0 to HeaderCount - 1 do
        begin
          n := KeyFrames[KFposLUT[i]].PrevBMP.Width;
          BlockWrite(f, n, 4);
          SetLength(buf, n);
          y := KeyFrames[KFposLUT[i]].PrevBMP.Height;
          BlockWrite(f, y, 4);
          while y > 0 do
          begin
            Dec(y);
            pc := KeyFrames[KFposLUT[i]].PrevBMP.ScanLine[y];
            for x := 0 to n - 1 do
            begin
              buf[x] := pc^;
              Inc(pc);
            end;
            BlockWrite(f, buf[0], 4 * n);
          end;
        end;
      finally
        CloseFile(f);
      end;
      SetDialogName(OpenDialog4, SaveDialog1.FileName);
    //  AniProjectName := ExtractFileName(OpenDialog4.FileName);
      AniProjectName := ChangeFileExtSave(ExtractFileName(OpenDialog4.FileName), '');
      ShowProjectName;
    end;
end;

procedure TAnimationForm.Edit6Change(Sender: TObject);
var i: Integer;
    E: TEdit;
begin
    E := Sender as TEdit;
    if EditToInt(E, i) then
    begin
      if Sender = Edit6 then AniWidth := i else AniHeight := i;
      calcTimeForPreviewRender;
    end;
end;

procedure TAnimationForm.Edit3Change(Sender: TObject);
begin
    Edit8.Text := Edit3.Text;
    Edit3.Font.Color := Edit8.Font.Color
end;

procedure TAnimationForm.Button4Click(Sender: TObject);      // Render Preview
var c: Cardinal;
    v: Integer;
begin
    v := StrToIntTry(Edit10.Text, HeaderCount);
    if (v < 1) or (v > HeaderCount) then v := HeaderCount;
    c := Round(TotalBMPsToRender(StrToIntTry(Edit9.Text, 1), v, UpDown1.Position) * 4.0 * AniWidth * AniHeight /
               Sqr(UpDown2.Position));
    if c * 1.2 > PhysikMemAvail then
      ShowMessage('Not enough memory available')
    else
    begin
      isCalculating := True; //To disable Buttons;
      AniPreviewForm.FastNinaccurate := CheckBox3.Checked;
      AniPreviewForm.StartRendering;
    end;
end;

procedure TAnimationForm.Timer3Timer(Sender: TObject);    // look, if threads are still calculting prev BMP
var c, i, n, x, sloff: Integer;
    DoFrec: TDoFrec;
    R: TRect;
begin
    n := 0;
    for i := 1 to CalcThreadStats.iTotalThreadCount do
      if CalcThreadStats.CTrecords[i].isActive > 0 then Inc(n);
    if n = 0 then
    begin
      Timer3.Enabled := False;
      iActiveThreads := 0;
      CalcStepWidth(@InterpolHeader);
      c := CalcThreadStats.iProcessingType;
      if not bCalcStop then
      begin
        R := Rect(0, 0, InterpolHeader.Width - 1, InterpolHeader.Height - 1);
        sloff := 18 * InterpolHeader.Width;
        //after processings
        case c of  //0: not calculating, 1: main calculation, 2: hard shadow, 3: AO1, 4: AO2, 5: AO3, 6: Reflects, 7: DOF
          1:  KeyFrames[PrevRenderNr].KFtime := Max(10, GetTickCount - CalcThreadStats.cCalcTime);
          2:  KeyFrames[PrevRenderNr].KFtime := KeyFrames[PrevRenderNr].KFtime + Max(10, GetTickCount - CalcThreadStats.cCalcTime);
          6:  KeyFrames[PrevRenderNr].KFtime := KeyFrames[PrevRenderNr].KFtime + Max(10, GetTickCount - CalcThreadStats.cCalcTime);
        //  6:  CalcBGambI(CalcThreadStats.iTotalThreadCount, @siLight5[0], @bgsArrAni);
        end;

        x := 1 shl c;
        while (x < 256) and ((CalcThreadStats.iAllProcessingOptions and x) = 0) do x := x shl 1;

        if (CalcThreadStats.iAllProcessingOptions and x) > 0 then   //next processing step
        begin              
          CalcThreadStats.pLBcalcStop := @bCalcStop;
          CalcThreadStats.pMessageHwnd := Self.Handle;
          case x of        // 2: NsOnZBuf, 4: hard shadow postcalc, 8: AO, 16: free, 32: reflections, 64: DOF
            2:  begin
                  CalcThreadStats.iProcessingType := 2;
                  try
                    NormalsOnZbuf(@InterpolHeader, @siLight5[0]);
                  finally
                    CalcThreadStats.iTotalThreadCount := 0;
                    Timer3.Interval := 5;
                    Timer3.Enabled := True;
                  end;
                end;
            4:  begin
                  CalcThreadStats.iProcessingType := 3;
                  if CalcHardShadowT(@InterpolHeader, @CalcThreadStats, @siLight5[0], sloff, @InterpolLightVals, False, R) then
                    iActiveThreads := CalcThreadStats.iTotalThreadCount;
                end;
            8:  begin
                  CalcThreadStats.iProcessingType := 4;
                  if CalcAmbShadowT(@InterpolHeader, @siLight5[0], sloff, @CalcThreadStats, @ATrousWLAni, R) then
                    iActiveThreads := CalcThreadStats.iTotalThreadCount;
                end;
           32:  begin
                  CalcThreadStats.iProcessingType := 6;
                  PaintM(@InterpolHeader, @InterpolLightVals, @siLight5[0], aFSIstart, aFSIoffset);
                  if CalcSRT(@InterpolHeader, @InterpolLightVals, @CalcThreadStats,
                             @siLight5[0], aFSIstart, aFSIoffset, R) then
                    iActiveThreads := CalcThreadStats.iTotalThreadCount; 
                end;
           64:  begin
                  CalcThreadStats.iProcessingType := 7;
                  try
                    if (CalcThreadStats.iAllProcessingOptions and 32) = 0 then
                      PaintM(@InterpolHeader, @InterpolLightVals, @siLight5[0], aFSIstart, aFSIoffset);
                    DoFrec.SL := @siLight5[0];
                    DoFrec.colSL := PCArdinal(aFSIstart);
                    DoFrec.MHeader := @InterpolHeader;
                    DoFrec.SLoffset := aFSIoffset;
                    DoFrec.Verbose := False;
                    for n := 0 to (InterpolHeader.bCalcDOFtype shr 1) and 3 do
                    begin
                      DoFrec.pass := n;
                      if ((InterpolHeader.bCalcDOFtype shr 3) and 1) = 1 then doDOF(DoFrec)
                                                                         else doDOFsort(DoFrec);
                    end;
                  except end;  
                end;
          end;
        end;
      end;
      if iActiveThreads > 0 then Timer3.Enabled := True;
      if not Timer3.Enabled then
      begin
        if not bCalcStop then
        begin
          if CalcThreadStats.iProcessingType < 6 then PaintM(@InterpolHeader, @InterpolLightVals, @siLight5[0], aFSIstart, aFSIoffset);
          KeyFrames[PrevRenderNr].PrevBMP.Modified := True;
        end;
        if AniProcessForm.bRerenderPreviewImages then
        begin
          Inc(AniProcessForm.actKeyFame);
          if bCalcStop or (AniProcessForm.actKeyFame >= HeaderCount) then
          begin
            AniProcessForm.bRerenderPreviewImages := False;
            Screen.Cursor := crDefault;
          end
          else
            RenderPrevBMP(AnimationForm.KFposLUT[AniProcessForm.actKeyFame]);
        end;
        if not AniProcessForm.bRerenderPreviewImages then
        begin
          Mand3DForm.EnableButtons;
          AniOption := 0;
          Invalidate;
          calcTimeForPreviewRender;
        end;
      end;
    end;
    if CalcThreadStats.iProcessingType <> 2 then Timer3.Interval := 50;
end;

procedure TAnimationForm.SpeedButton10Click(Sender: TObject);
begin
    AniProcessForm.Visible := True;
end;

procedure TAnimationForm.Edit5Change(Sender: TObject);
var i, c: Integer;
begin
    Val(Trim((Sender as TEdit).Text), i, c);
    if c <> 0 then (Sender as TEdit).Font.Color := clMaroon
              else (Sender as TEdit).Font.Color := clWindowText;
end;

procedure TAnimationForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if (Key = #27) and (Screen.Cursor = crNone) then FNavigator.ChangeNaviMode;
end;

procedure TAnimationForm.CheckBox4Click(Sender: TObject);
begin
    CheckBox5.Enabled := CheckBox4.Checked;
end;

procedure TAnimationForm.SpeedButton12Click(Sender: TObject);
var sf, i, j, IHS, HS1, HS2: Integer;
    D1, D2, w1, w2: Double;
    Q1, Q2: TQuaternion;
    IH, H1, H2: TPMandHeader11;
    s: String;
begin   //Interpolate keyframe inbetween
    if CurrentNr < 1 then Exit;
    j := KFposLUT[CurrentNr - 1];
    i := KeyFrames[j].KFcount;
    s := IntToStr((i + 1) div 2);
    if InputQuery('Linear interpolate a keyframe inbetween', 'At which subframe:', s) then
      sf := StrToInt(s) - 1 else Exit;
    if (sf >= i) or (sf < 0) then
    begin
      ShowMessage('Value not guilty');
      Exit;
    end;
    Inc(HeaderCount);
    Setlength(KeyFrames, HeaderCount);
    Setlength(KFposLUT, HeaderCount);
    IncKFabove(CurrentNr + 1);
    KeyFrames[HeaderCount - 1].PrevBMP  := TBitmap.Create;
    KeyFrames[j].KFcount := sf;
    KeyFrames[HeaderCount - 1].KFcount := i - sf;
    KFposLUT[CurrentNr] := HeaderCount - 1;
    IniKFHeader(HeaderCount - 1);
    AssignHeader(@KeyFrames[HeaderCount - 1].HeaderParas, @KeyFrames[j].HeaderParas);
    //Interpolate midPos, Matrix...
    w2 := sf / Max(1, i);
    w1 := 1 - w2;
    IH := @KeyFrames[HeaderCount - 1].HeaderParas;
    H1 := @KeyFrames[j].HeaderParas;
    H2 := @KeyFrames[KFposLUT[CurrentNr + 1]].HeaderParas;
    if (H1.bCalcDOFtype and 1) = 0 then H1.sDOFaperture := 0;
    if (H2.bCalcDOFtype and 1) = 0 then H2.sDOFaperture := 0;
    IH.bDFogIt := Round(H1.bDFogIt * W1 + H2.bDFogIt * W2);
    IHS := Integer(IH);
    HS1 := Integer(H1);
    HS2 := Integer(H2);
    for i := 0 to High(IntParsToInterpolate) do
      PInteger(IHS + IntParsToInterpolate[i])^ :=
        Round(PInteger(HS1 + IntParsToInterpolate[i])^ * W1 +
              PInteger(HS2 + IntParsToInterpolate[i])^ * W2);
    for i := 0 to High(DoubleParsToInterpolate) do
      PDouble(IHS + DoubleParsToInterpolate[i])^ :=
              PDouble(HS1 + DoubleParsToInterpolate[i])^ * W1 +
              PDouble(HS2 + DoubleParsToInterpolate[i])^ * W2;
    for i := 0 to High(SingleParsToInterpolate) do
      PSingle(IHS + SingleParsToInterpolate[i])^ :=
              PSingle(HS1 + SingleParsToInterpolate[i])^ * W1 +
              PSingle(HS2 + SingleParsToInterpolate[i])^ * W2;
    for i := 0 to High(DoubleToInterpolateLog) do  //zoom + Rbailout
    begin
      D1 := Max(1e-10, PDouble(HS1 + DoubleToInterpolateLog[i])^);
      D2 := Max(1e-10, PDouble(HS2 + DoubleToInterpolateLog[i])^);
      PDouble(IHS + DoubleToInterpolateLog[i])^ :=
        Power(10, Log10(D1) * W1 + Log10(D2) * W2);
    end;
    for i := 0 to High(DoubleAnglesToInterpolate) do
    begin
      D1 := PDouble(HS1 + DoubleAnglesToInterpolate[i])^;
      D2 := PDouble(HS2 + DoubleAnglesToInterpolate[i])^;
      if Abs(D1) > 1000 then D1 := 0;
      if Abs(D2) > 1000 then D2 := 0;
      while Abs(D2 - D1) - 1e-8 > Pi do
      begin
        if D2 < D1 then D2 := D2 + piM2 else D2 := D2 - piM2;
      end;
      PDouble(IHS + DoubleAnglesToInterpolate[i])^ := D1 * W1 + D2 * W2;
    end;
    MatrixToQuat(NormaliseMatrixTo(1, @H1.hVGrads), Q1);
    MatrixToQuat(NormaliseMatrixTo(1, @H2.hVGrads), Q2);
    Q1 := InvertQuat(SlerpQuat(Q1, Q2, w2));
    CreateMatrixFromQuat(IH.hVGrads, Q1);
    for i := 0 to 5 do  //ipol some light values (position, colors, amplitude)
    begin
      IH.Light.Lights[i].Lcolor :=
        CardinalToRGB(InterpolateRGBColor(H1.Light.Lights[i].Lcolor, H2.Light.Lights[i].Lcolor, w1, w2));
      IH.Light.Lights[i].Lamp := Word(SingleToShortFloat(ShortFloatToSingle(@H1.Light.Lights[i].Lamp) * W1 +
                            ShortFloatToSingle(@H2.Light.Lights[i].Lamp) * W2));
      if ((H1.Light.Lights[i].Loption or H2.Light.Lights[i].Loption) and 1) = 0 then
      begin
        IH.Light.Lights[i].LXpos := DoubleToD7B(D7BToDouble(H1.Light.Lights[i].LXpos) * W1 +
                                                D7BToDouble(H2.Light.Lights[i].LXpos) * W2);
        IH.Light.Lights[i].LYpos := DoubleToD7B(D7BToDouble(H1.Light.Lights[i].LYpos) * W1 +
                                                D7BToDouble(H2.Light.Lights[i].LYpos) * W2);
        IH.Light.Lights[i].LZpos := DoubleToD7B(D7BToDouble(H1.Light.Lights[i].LZpos) * W1 +
                                                D7BToDouble(H2.Light.Lights[i].LZpos) * W2);
      end;
    end;
    //todo: some other colors

    //HAddon
    if (InterpolHAddon.bOptions1 and 3) = 1 then j := 1 else j := MAX_FORMULA_COUNT - 1;
    for i := 0 to j do if bInterpolateFormula(PTHeaderCustomAddon(H1.PCFAddon),
                            PTHeaderCustomAddon(H2.PCFAddon), i) then
    begin
      Ini1CFfromHAddon(H1.PCFAddon, H1.PHCustomF[i], i);
      for IHS := 0 to Min(16, PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].iOptionCount) - 1 do
        if isAngleType(PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].byOptionType[IHS]) then
        begin
          D1 := PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].dOptionValue[IHS];
          D2 := PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].dOptionValue[IHS];
          if Abs(D1) > 10000 then D1 := 0;
          if Abs(D2) > 10000 then D2 := 0;
          while Abs(D1 - D2) > 180.1 do
          begin
            if D2 < D1 then D2 := D2 + 360 else D2 := D2 - 360;
          end;
          PTHeaderCustomAddon(IH.PCFAddon).Formulas[i].dOptionValue[IHS] := D1 * W1 + D2 * W2;
        end
        else
        PTHeaderCustomAddon(IH.PCFAddon).Formulas[i].dOptionValue[IHS] :=
          PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].dOptionValue[IHS] * W1 +
          PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].dOptionValue[IHS] * W2;
      if j = 1 then
      begin
        PSingle(@PTHeaderCustomAddon(IH.PCFAddon).Formulas[i].iItCount)^ :=
          PSingle(@PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].iItCount)^ * W1 +
          PSingle(@PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].iItCount)^ * W2;
      end else begin
        PTHeaderCustomAddon(IH.PCFAddon).Formulas[i].iItCount := Round(
          PTHeaderCustomAddon(H1.PCFAddon).Formulas[i].iItCount * W1 +
          PTHeaderCustomAddon(H2.PCFAddon).Formulas[i].iItCount * W2);
      end;
    end;
    RenderPrevBMP(HeaderCount - 1);
    Inc(CurrentNr);
end;

procedure TAnimationForm.SpeedButton13Click(Sender: TObject);
var i: Integer;
begin
    if (HeaderCount > 0) and (MessageDlg('Do you really want to delete everything?',
      mtWarning, [mbYes, mbNo], 0) = mrNo) then Exit;
    for i := 0 to HeaderCount - 1 do
    begin
      KeyFrames[i].PrevBMP.Free;
      KeyFrames[i].KFcount := 0;
    end;
    HeaderCount := 0;
    CurrentNr := 1;
    Button2.Enabled := False;
    Button4.Enabled := False;
    Edit5.Text := IniVal[7];
    calcTimeForPreviewRender;
    SetScrollButton;
    PaintBox1.Invalidate;
end;

procedure TAnimationForm.SpeedButton14Click(Sender: TObject); //send view only to main
var pHeader: TPMandHeader11;
begin
    pHeader := @KeyFrames[KFposLUT[CurrentNr - 1]].HeaderParas;
 //   AssignHeader(@Mand3DForm.MHeader, @KeyFrames[KFposLUT[CurrentNr - 1]].HeaderParas);
    PTHeaderCustomAddon(Mand3DForm.MHeader.PCFAddon)^ := PTHeaderCustomAddon(pHeader.PCFAddon)^;
    FastMove(pHeader.dZstart, Mand3DForm.MHeader.dZstart, 72);
 //   Mand3DForm.MHeader.MinimumIterations := pHeader.MinimumIterations;
    FastMove(pHeader.bIsJulia, Mand3DForm.MHeader.bIsJulia, 33);
    FastMove(pHeader.hVGrads, Mand3DForm.MHeader.hVGrads, 72);
    IniCFsFromHAddon(Mand3DForm.MHeader.PCFAddon, Mand3DForm.MHeader.PHCustomF);
  //  Mand3DForm.MHeader.Width := AniWidth * AniScale;
  //  Mand3DForm.MHeader.Height := AniHeight * AniScale;
  //  Mand3DForm.MHeader.bImageScale := AniScale;
    Mand3DForm.MHeader.bStereoMode := 0;
    Mand3DForm.SetEditsFromHeader;
 //   LightAdjustForm.SetLightFromHeader(Mand3DForm.MHeader);
    Mand3DForm.Caption := 'View of keyframe #' + IntToStr(CurrentNr);
    Mand3DForm.ParasChanged;
    SetFocus;
end;

end.


