unit PostProcessForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, TypeDefinitions, ComCtrls, Vcl.ImgList,
  Vcl.Buttons;

type
  TPostProForm = class(TForm)
    GroupBox4: TGroupBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    Button17: TButton;
    CheckBox20: TCheckBox;
    Edit4: TEdit;
    GroupBox6: TGroupBox;
    Button12: TButton;
    CheckBox8: TCheckBox;
    GroupBox10: TGroupBox;
    Shape6: TShape;
    Button20: TButton;
    CheckBox26: TCheckBox;
    ImageList1: TImageList;
    PostProcessHintPnl: TPanel;
    Label3: TLabel;
    Button16: TButton;
    RecalcSectionPnl: TPanel;
    Button13: TButton;
    CheckBox19: TCheckBox;
    CheckBox21: TCheckBox;
    CheckBox30: TCheckBox;
    Edit12: TEdit;
    Label4: TLabel;
    UpDown4: TUpDown;
    NormalsOnZBufferPnl: TPanel;
    Button14: TButton;
    CheckBox23: TCheckBox;
    Label7: TLabel;
    HardShadowsPnl: TPanel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    CheckBox10: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox29: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox9: TCheckBox;
    Edit5: TEdit;
    Edit7: TEdit;
    Label6: TLabel;
    Label8: TLabel;
    AmbientShadowsPnl: TPanel;
    Button10: TButton;
    CheckBox11: TCheckBox;
    Label24: TLabel;
    TabControl1: TTabControl;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label20: TLabel;
    Label50: TLabel;
    CheckBox12: TCheckBox;
    CheckBox22: TCheckBox;
    Edit21: TEdit;
    Edit34: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    RadioGroup5: TRadioGroup;
    UpDown1: TUpDown;
    UpDown3: TUpDown;
    ReflTransparencyPnl: TPanel;
    Button15: TButton;
    CheckBox24: TCheckBox;
    CheckBox25: TCheckBox;
    CheckBox27: TCheckBox;
    CheckBox28: TCheckBox;
    Edit11: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit17: TEdit;
    Edit6: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    UpDown2: TUpDown;
    DepthOfFieldPnl: TPanel;
    Button1: TButton;
    Button18: TButton;
    Button19: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    NormalsOnZBufferBtn: TSpeedButton;
    HardShadowsBtn: TSpeedButton;
    AmbientShadowsBtn: TSpeedButton;
    ReflTransparencyBtn: TSpeedButton;
    DepthOfFieldBtn: TSpeedButton;
    RecalcSectionBtn: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure CheckBox8Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure RadioGroup3Click(Sender: TObject);
    procedure CheckBox21Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure CheckBox25Click(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure Button16Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure CategoryPanel1Collapse(Sender: TObject);
    procedure CategoryPanel1Expand(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure UpDown1ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Integer; Direction: TUpDownDirection);
    procedure RecalcSectionBtnClick(Sender: TObject);
    procedure NormalsOnZBufferBtnClick(Sender: TObject);
    procedure HardShadowsBtnClick(Sender: TObject);
    procedure AmbientShadowsBtnClick(Sender: TObject);
    procedure ReflTransparencyBtnClick(Sender: TObject);
    procedure DepthOfFieldBtnClick(Sender: TObject);
    procedure CheckBox23Click(Sender: TObject);
    procedure CheckBox11Click(Sender: TObject);
    procedure CheckBox24Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Private-Deklarationen }
    function ClipIRect: LongBool;
    procedure AlignPanels(Sender: TObject);
    procedure UpdateButtonCaption(Btn: TSpeedButton; const Checkbox: TCheckBox);
  public
    { Public-Deklarationen }
    iRect: TRect;
    function HSoptions: Integer;
    procedure PutAmbientParsToHeader(Header: TPMandHeader10);
    procedure PutDOFparsToHeader(Header: TPMandHeader10);
    procedure PutReflectionParsToHeader(Header: TPMandHeader10);
  end;

var
  PostProForm: TPostProForm;
  PPFormCreated: LongBool = False;
//  CPppFirstExpand: array[1..9] of LongBool = (True, True, True, True, True, True,
  //  True, True, True);

implementation

uses Mand, DOF, DivUtils, ImageProcess, DoubleSize, CalcPart, HeaderTrafos,
 CalcMonteCarlo, CalcSR, Math3D, Tiling, LightAdjust, FileHandling;

{$R *.dfm}

procedure TPostProForm.HardShadowsBtnClick(Sender: TObject);
begin
  HardShadowsPnl.Top := HardShadowsBtn.Top+HardShadowsBtn.Height;
  HardShadowsPnl.Visible := not HardShadowsPnl.Visible;
  AlignPanels(Sender);
  CheckBox9Click(Sender);
end;

function TPostProForm.HSoptions: Integer;
var i: Integer;
begin
    Result := (Ord(CheckBox9.Checked) and 1) or ((Ord(CheckBox10.Checked) and 1) shl 1)
              or ((Ord(CheckBox29.Checked and CheckBox29.Enabled) and 1) shl 8);
    for i := 2 to 7 do
      Result := Result or (Ord((FindComponent('CheckBox'
        + IntToStr(i)) as TCheckBox).Checked) and 1) shl i;
end;

procedure TPostProForm.NormalsOnZBufferBtnClick(Sender: TObject);
begin
  NormalsOnZBufferPnl.Top := NormalsOnZBufferBtn.Top+NormalsOnZBufferBtn.Height;
  NormalsOnZBufferPnl.Visible := not NormalsOnZBufferPnl.Visible;
  AlignPanels(Sender);
  CheckBox23Click(Sender);
end;

procedure TPostProForm.AlignPanels(Sender: TObject);
var
  H: Integer;
begin
  H := 0;

  Inc(H, RecalcSectionBtn.Height);
  if RecalcSectionPnl.Visible then
    Inc(H, RecalcSectionPnl.Height);

  Inc(H, NormalsOnZBufferBtn.Height);
  if NormalsOnZBufferPnl.Visible then
    Inc(H, NormalsOnZBufferPnl.Height);

  Inc(H, HardShadowsBtn.Height);
  if HardShadowsPnl.Visible then
    Inc(H, HardShadowsPnl.Height);

  Inc(H, AmbientShadowsBtn.Height);
  if AmbientShadowsPnl.Visible then
    Inc(H, AmbientShadowsPnl.Height);

  Inc(H, PostProcessHintPnl.Height);

  Inc(H, ReflTransparencyBtn.Height);
  if ReflTransparencyPnl.Visible then
    Inc(H, ReflTransparencyPnl.Height);

  Inc(H, DepthOfFieldBtn.Height);
  if DepthOfFieldPnl.Visible then
    Inc(H, DepthOfFieldPnl.Height);

  ClientHeight := H;
end;

procedure TPostProForm.FormShow(Sender: TObject);
begin
    Mand3DForm.FormResize(Sender);
    if FormsSticky[2] = 0 then
      SetBounds(StrToIntTry(StrFirstWord(IniVal[28]), 844),
                StrToIntTry(StrLastWord(IniVal[28]), 100), Width, Height);
    Edit11.Hint := 'Depth of reflections: 1 to see only one reflection,' + #13#10 +
                   'with 2 you could see reflections in the reflected object, ... and so on.';
    Edit12.Hint := 'Divides the actual "Raystep multiplier" by this value,' + #13#10 +
                   'increase the value to reduce overstepping.';
    AlignPanels(Sender);
    UpdateButtonCaption(RecalcSectionBtn, CheckBox21);
    CheckBox23Click(Sender);
    CheckBox9Click(Sender);
    CheckBox11Click(Sender);
    CheckBox24Click(Sender);
    CheckBox1Click(Sender);
end;

procedure TPostProForm.CheckBox8Click(Sender: TObject);
begin
    Mand3DForm.SetImageCursor;
end;

procedure TPostProForm.PutDOFparsToHeader(Header: TPMandHeader10);
begin
    with Header^ do
    begin
      bCalcDOFtype := (Ord(CheckBox1.Checked) and 1) or (RadioGroup1.ItemIndex shl 1)
                       or (RadioGroup2.ItemIndex shl 3);
      sDOFZsharp   := StrToFloatK(Edit1.Text);
      sDOFclipR    := StrToFloatK(Edit2.Text);
      sDOFaperture := StrToFloatK(Edit3.Text);
      sDOFZsharp2  := StrToFloatK(Edit10.Text);
    end;
end;

procedure TPostProForm.Button1Click(Sender: TObject);
var pass, z: Integer;
    DoFrec: TDoFrec;
begin
    if Mand3DForm.MHeader.TilingOptions <> 0 then
    begin
      ShowMessage('No DoF on tiles.');
      Exit;
    end;
    TilingForm.SaveThisTile := False;
    Mand3DForm.SaveM3IfileAuto := False;
    Mand3DForm.MakeHeader;
    Mand3DForm.DisableButtons;
    Mand3DForm.Button2.Caption := 'Stop';
    Mand3DForm.ProgressBar1.Max := Mand3DForm.MHeader.Height;
    Mand3DForm.ProgressBar1.Position := 0;
    Mand3DForm.ProgressBar1.Visible := True;
    MCalcStop := False;
    try
      DoFrec.SL := @Mand3DForm.siLight5[0];
      DoFrec.colSL := @fullSizeImage[0];
      DoFrec.MHeader := @Mand3DForm.MHeader;
      DoFrec.SLoffset := 4 * Mand3DForm.MHeader.Width;
      DoFrec.Verbose := True;
      z := (Mand3DForm.MHeader.bCalcDOFtype shr 1) and 3;
      for pass := 0 to z do
      if not MCalcStop then
      begin
        DoFrec.pass := pass;
        if z > 0 then
          Mand3DForm.Label6.Caption := 'DoF calculation pass ' + IntToStr(pass + 1) + ' of ' + IntToStr(z + 1)
        else Mand3DForm.Label6.Caption := 'DoF calculation';
        if ((Mand3DForm.MHeader.bCalcDOFtype shr 3) and 1) = 1 then
          doDOF(DoFrec)
        else
          doDOFsort(DoFrec);
      end;
    finally
      Mand3DForm.EnableButtons;
      Mand3DForm.ProgressBar1.Visible := False;
    end;
end;

procedure TPostProForm.Button20Click(Sender: TObject);
begin
    //Ambient light

end;

procedure TPostProForm.Button2Click(Sender: TObject);
var B: TButton;
begin
    B := Sender as TButton;
    if B.Caption = 'Click on image' then
    begin
      if B.Tag = 1 then B.Caption := 'Get Z1'
                   else B.Caption := 'Get Z2';
      Mand3DForm.iGetPosFromImage := 0;
      Mand3DForm.SetImageCursor;
    end
    else
    begin
      Mand3DForm.iGetPosFromImage := B.Tag;
      B.Caption := 'Click on image';
      Mand3DForm.MButtonsUp;
      Mand3DForm.Image1.Cursor := crCross;
    end;
end;

procedure TPostProForm.FormCreate(Sender: TObject);
begin
    PPFormCreated := True;
end;

procedure TPostProForm.Button3Click(Sender: TObject);      //calculate HardShadows checkbox2-7 = light1-6
var i, iLights, n: Integer;
    CB: TCheckBox;
begin
    Mand3DForm.CalcStart := GetTickCount;
    iLights := 0;
    n := 1;
    for i := 2 to 7 do
    begin
      CB := FindComponent('CheckBox' + IntToStr(i)) as TCheckBox;
      if CB.Enabled and CB.Checked then
        if (LightAdjustForm.LAtmpLight.Lights[i - 2].Loption and 2) = 0 then iLights := iLights or n;
      n := n shl 1;
    end;
    if iLights = 0 then ShowMessage('Please select the lights first.  No HS for lightmaps.') else
    begin
      TilingForm.SaveThisTile := False;
      Mand3DForm.SaveM3IfileAuto := False;
      Mand3DForm.MakeHeader;
  //test: usually not yet because if HS calc fails, val must be resetted!
      Mand3DForm.MHeader.bHScalculated := (Mand3DForm.MHeader.bHScalculated and $FD) or Mand3DForm.MHeader.bCalculateHardShadow;
      MakeLightValsFromHeaderLight(@Mand3DForm.MHeader, @Mand3DForm.HeaderLightVals, 1, Mand3DForm.MHeader.bStereoMode);
      Mand3DForm.MCalcThreadStats.iAllProcessingOptions := 4;
      Mand3DForm.CalcHardShadow;
    end;
end;

procedure TPostProForm.Button4Click(Sender: TObject);
var t, i: Integer;
    pl: TPsiLight5;
    w, w2: Word;
begin
    t := (Sender as TButton).Tag;
    with Mand3DForm do
    begin
      if (MHeader.bCalc1HSsoft and 1) <> 0 then
      begin
        w := $3FF;
        w2 := $FC00;
        if (MHeader.bHScalculated and (2 shl t)) = 0 then Exit;
      end else begin
        w := ($200 shl t) xor $FFFF;
        w2 := 0;
      end;
      pl := @SiLight5[0];
      for i := 0 to High(SiLight5) do
      begin
        pl.Shadow := pl.Shadow and w or w2;
        Inc(pl);
      end;
      MHeader.bHScalculated := MHeader.bHScalculated and ((2 shl t) xor $FF);
      TriggerRepaint;
    end;
end;

procedure TPostProForm.PutAmbientParsToHeader(Header: TPMandHeader10);
begin
    with Header^ do
    begin
      sAmbShadowThreshold := MaxCS(0.01, StrToFloatK(Edit34.Text));
      bCalcAmbShadowAutomatic := (Byte(CheckBox11.Checked) and 1) or
                                ((Byte(CheckBox12.Checked) and 1) shl 1) or
                                 (TabControl1.TabIndex shl 2) or     //0..3    no place for videoSSAO
                                 (UpDown1.Position shl 4) or
                                 ((Byte(CheckBox22.Checked) and 1) shl 7);
      AODEdithering := RadioGroup5.ItemIndex;
      sDEAOmaxL := MinMaxCS(s1d255, StrToFloatK(Edit8.Text), 100);
      bSSAO24BorderMirrorSize := StrToD2Byte(Edit9.Text);
      SSAORcount := UpDown3.Position;
    end;
end;

procedure TPostProForm.AmbientShadowsBtnClick(Sender: TObject);
begin
  AmbientShadowsPnl.Top := AmbientShadowsBtn.Top+AmbientShadowsBtn.Height;
  AmbientShadowsPnl.Visible := not AmbientShadowsPnl.Visible;
  AlignPanels(Sender);
  CheckBox11Click(Sender);
end;

procedure TPostProForm.Button10Click(Sender: TObject); //AO calc
begin
    TilingForm.SaveThisTile := False;
    Mand3DForm.SaveM3IfileAuto := False;
    Mand3DForm.CalcStart := GetTickCount;
    Mand3DForm.MakeHeader;
    Mand3DForm.MCalcThreadStats.iAllProcessingOptions := 8;  //AllAutoProcessings(@Mand3DForm.MHeader);
    Mand3DForm.SSAORiteration := 0;
    MakeLightValsFromHeaderLight(@Mand3DForm.MHeader, @Mand3DForm.HeaderLightVals, 1, Mand3DForm.MHeader.bStereoMode);
    Mand3DForm.CalcAmbShadow;
end;

procedure TPostProForm.Button17Click(Sender: TObject);
begin
    CalcLightStrokes(StrToIntTrim(Edit4.Text));
end;

procedure TPostProForm.PutReflectionParsToHeader(Header: TPMandHeader10);
begin
    with Header^ do
    begin
      bCalcSRautomatic := (Byte(CheckBox24.Checked) and 1) or ((Byte(CheckBox27.Checked) shl 1) and 2) or
        ((Byte(CheckBox28.Checked) shl 2) and 4);
      SRamount := Min0MaxCS(StrToFloatK(Edit6.Text), 100);
      SRreflectioncount := UpDown2.Position;
      sTransmissionAbsorption := MinMaxCS(s1em30, StrToFloatK(Edit13.Text), 1e10);
      sTRIndex := MinMaxCS(0.1, StrToFloatK(Edit14.Text), 10);
      sTRscattering := Min0MaxCS(StrToFloatK(Edit17.Text), s1e30);
    end;
end;

procedure TPostProForm.Button11Click(Sender: TObject);   // Calc Reflection/MonteC
var SLoff, Moff: Integer;
    TSize: TPoint;
    tmpR: TRect;
begin
    CheckBox24Click(Sender);
    with Mand3DForm do
    begin
      CalcStart := GetTickCount;
      TilingForm.SaveThisTile := False;
      Mand3DForm.SaveM3IfileAuto := False;
      MakeHeader;
      if (MHeader.Width < 1) or (MHeader.Height < 1) then Exit;
      MakeLightValsFromHeaderLight(@MHeader, @HeaderLightVals, 1, MHeader.bStereoMode);
      MHeader.bSliceCalc := 0;
      MHeader.bCalc3D    := 1;
      TSize := GetTileSize(@MHeader);
      tmpR := GetCalcRect;
      if not CheckBox25.Checked then
      begin
        Shape1.Visible := False;
        SLoff := 0;
        Moff := 0;
      end
      else
      begin
        if not ClipIRect then Exit;
        tmpR := Rect(iRect.Left + tmpR.Left, iRect.Top + tmpR.Top,
                     iRect.Right + tmpR.Left, iRect.Bottom + tmpR.Top);
        SLoff := iRect.Left + iRect.Top * TSize.X;
        Moff := SLoff * 4;
      end;
      SetImageSize;
      if Length(siLight5) <> TSize.X * TSize.Y  then Exit;
      DisableButtons;
      MCalcThreadStats.pLBcalcStop := @MCalcStop;
      MCalcThreadStats.pMessageHwnd := Self.Handle;
      MCalcThreadStats.iProcessingType := 6;
      MCalcThreadStats.iAllProcessingOptions := 32;
      if CalcSRT(@MHeader, @HeaderLightVals, @MCalcThreadStats, @siLight5[SLoff],
                 mFSIstart + Moff, mFSIoffset, tmpR) then
      begin
        iActiveThreads       := MCalcThreadStats.iTotalThreadCount;
        CalcYact             := -1;  //for upgrading the image
        ProgressBar1.Max     := MHeader.Height;
        ProgressBar1.Visible := True;
        if CheckBox25.Checked then Timer4.Interval := 500 else Timer4.Interval := 1000;
        Label6.Caption := 'Reflections';
        Timer4.Enabled  := True;
      end
      else
      begin
        if CheckBox25.Checked then Button15.Enabled := True else EnableButtons;
        MCalcThreadStats.iProcessingType := 0;
      end;
    end;
end;

procedure TPostProForm.Button12Click(Sender: TObject);   // Double the imagesize
begin
    with Mand3DForm do
    begin
      DisableButtons;
      if DoubleImageSize then
      begin
        if ImageScale = 1 then ImageScale := 2 else
        if ImageScale = 2 then ImageScale := 4;
        MHeader.bImageScale := ImageScale;
        SetEditsFromHeader;
        SetImageSize;
        TriggerRepaint;
      end;
      EnableButtons;
    end;
end;

procedure TPostProForm.RadioGroup3Click(Sender: TObject);
var b: LongBool;
begin
    b := TabControl1.TabIndex < 3;
    RadioGroup5.Visible := not b;
    CheckBox22.Visible := not b;
    Label15.Visible := not b;
    Label16.Visible := not b;
    Label17.Visible := not b;
    Edit8.Visible := not b;
    UpDown1.Visible := not b;
    CheckBox12.Visible := b;
    Edit34.Visible := b;
    Label50.Visible := b;
    b := TabControl1.TabIndex = 2;
    UpDown3.Visible := b;
    Edit21.Visible := b;
    Label14.Visible := b;
    b := b or (TabControl1.TabIndex = 1);
    Label20.Visible := b;
    Edit9.Visible := b;
end;

procedure TPostProForm.RecalcSectionBtnClick(Sender: TObject);
begin
  RecalcSectionPnl.Top := RecalcSectionBtn.Top+RecalcSectionBtn.Height;
  RecalcSectionPnl.Visible := not RecalcSectionPnl.Visible;
  AlignPanels(Sender);
  UpdateButtonCaption(RecalcSectionBtn, CheckBox21);
end;

procedure TPostProForm.ReflTransparencyBtnClick(Sender: TObject);
begin
  ReflTransparencyPnl.Top := ReflTransparencyBtn.Top+ReflTransparencyBtn.Height;
  ReflTransparencyPnl.Visible := not ReflTransparencyPnl.Visible;
  AlignPanels(Sender);
  CheckBox24Click(Sender);
end;

procedure TPostProForm.UpDown1ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Integer; Direction: TUpDownDirection);
const ci: array[-1..4] of Integer = (3, 3, 7, 17, 33, 33);
begin
    Label17.Caption := IntToStr(ci[NewValue]);
end;

procedure TPostProForm.CategoryPanel1Collapse(Sender: TObject);
begin
    CheckBox21.Checked := False;
    AlignPanels(Sender);
end;

procedure TPostProForm.CategoryPanel1Expand(Sender: TObject);
begin
    AlignPanels(Sender);
end;

procedure TPostProForm.CheckBox11Click(Sender: TObject);
begin
  UpdateButtonCaption(AmbientShadowsBtn, CheckBox11);
end;

procedure TPostProForm.CheckBox1Click(Sender: TObject);
begin
  UpdateButtonCaption(DepthOfFieldBtn, CheckBox1);
end;

procedure TPostProForm.CheckBox21Click(Sender: TObject);   //enable Recalc parts
begin
    UpdateButtonCaption(RecalcSectionBtn, CheckBox21);
    Button13.Enabled := CheckBox21.Checked;
    if CheckBox21.Checked then
    begin
      Mand3DForm.MButtonsUp;
      Mand3DForm.DisableButtons;
      Mand3DForm.Image1.Cursor := crCross;
    end else begin
      Mand3DForm.Shape1.Visible := False;
      if not Button3.Enabled then Mand3DForm.EnableButtons;
    end;
end;

procedure TPostProForm.CheckBox23Click(Sender: TObject);
begin
  UpdateButtonCaption(NormalsOnZBufferBtn, CheckBox23);
end;

procedure TPostProForm.CheckBox24Click(Sender: TObject);
begin
  UpdateButtonCaption(ReflTransparencyBtn, CheckBox24);
end;

procedure DelayDEAOT(ThreadCount: Integer; PCTS: TPCalcThreadStats);
var
  Tick: Double;
  Event: THandle;
  x, y, Milliseconds: Integer;
begin
  Milliseconds := 300;
  Tick  := getHiQmillis + Milliseconds;
  Event := CreateEvent(nil, False, False, nil);
  try
    while (Milliseconds > 0) and
          (MsgWaitForMultipleObjects(1, Event, False, Milliseconds, QS_ALLINPUT)
           <> WAIT_TIMEOUT) do
    begin
      Application.ProcessMessages;
      if Application.Terminated or PCTS.pLBcalcStop^ then Exit;
      x := 0;
      for y := 1 to ThreadCount do if PCTS.CTrecords[y].isActive > 0 then Inc(x);
      if x = 0 then Milliseconds := 0 else Milliseconds := Round(Tick - getHiQmillis);
      if Milliseconds > 500 then Exit;
    end;
  finally
    CloseHandle(Event);
  end;
end;

function TPostProForm.ClipIRect: LongBool;
var TSize: TPoint;
begin
    TSize := GetTileSize(@Mand3DForm.MHeader);
    if iRect.Top < 0 then iRect.Top := 0;
    if iRect.Left < 0 then iRect.Left := 0;
    if iRect.Right >= TSize.X then iRect.Right := TSize.X - 1;
    if iRect.Bottom >= TSize.Y then iRect.Bottom := TSize.Y - 1;
    Result := ((iRect.Right - iRect.Left) > 2) and ((iRect.Bottom - iRect.Top) > 2) and Mand3DForm.Shape1.Visible;
    if not Result then
    begin
      if not Mand3DForm.Shape1.Visible then Showmessage('Please make a selection in the image first.')
      else Showmessage('The selection must be bigger than 2 pixels in width and height.');
    end;
end;

procedure TPostProForm.DepthOfFieldBtnClick(Sender: TObject);
begin
  DepthOfFieldPnl.Top := DepthOfFieldBtn.Top+DepthOfFieldBtn.Height;
  DepthOfFieldPnl.Visible := not DepthOfFieldPnl.Visible;
  AlignPanels(Sender);
  CheckBox1Click(Sender);
end;

procedure TPostProForm.Button13Click(Sender: TObject); //Recalc parts
begin
    Mand3DForm.CalcStart := GetTickCount;
    if ClipIRect then
    begin
      Button13.Enabled := False;
      CalcPartT(iRect, CheckBox9.Checked, CheckBox19.Checked, CheckBox11.Checked
                and (TabControl1.TabIndex = 3), CheckBox30.Checked, UpDown4.Position);
      Button13.Enabled := True;
    end;
end;

{  TsiLight5 = packed record  //18 Byte
    NormalX:    SmallInt; // 3 normals
    NormalY:    SmallInt;
    NormalZ:    SmallInt;
    RoughZposFine: Word;  // 1 Byte Roughness + 1 Byte LSB Zpos for more precision
    Zpos:       Word;
    Shadow:     Word;     // DEcount 10bit + 6 Light HS only yes/no
    AmbShadow:  Word;
    SIgradient: Word;     // Smoothed Iteration gradient for coloring
    OTrap:      Word;     // coloring on OrbitTrap
  end; }

procedure calcCorrMul(Header: TPMandHeader10; PLight: TPsiLight5; var CorrMul: Single; var Zsub: Integer);
var x, w, h, zp, za: Integer;
    PATL: PWord;
begin
    w := Header.Width;
    h := Header.Height;
    PATL := PWord(Integer(PLight) + 8);
    za := 32767;
    zp := 0;
    for x := 1 to w * h do
    begin
      if PATL^ < 32768 then
      begin
        if PATL^ > zp then zp := PATL^;
        if PATL^ < za then za := PATL^;
      end;
      Inc(PATL, 9);
    end;
    if zp < za then
    begin
      zp := 32768;
      za := 0;
    end
    else Inc(zp);
    CorrMul := 128 / (zp - za);
    Zsub := za shl 8;
end;

procedure TPostProForm.Button14Click(Sender: TObject);   // normals on zbuf
begin
    if (Mand3DForm.MHeader.Width * Mand3DForm.MHeader.Height) =
       Length(Mand3DForm.siLight5) then
    begin
      Screen.Cursor := crHourGlass;
      try
        NormalsOnZbuf(@Mand3DForm.MHeader, @Mand3DForm.siLight5[0]);
      finally
        Screen.Cursor := crDefault;
      end;
      TriggerRepaint;
    end
    else Mand3DForm.OutMessage('Header size and image size are not the same.');
end;

procedure TPostProForm.CheckBox25Click(Sender: TObject);
begin
    if CheckBox25.Checked then
    begin
      Mand3DForm.MButtonsUp;
      Mand3DForm.DisableButtons;
      Button15.Enabled := True;
      Mand3DForm.Image1.Cursor := crCross;
    end else begin
      Mand3DForm.Shape1.Visible := False;
      if not Button3.Enabled then Mand3DForm.EnableButtons;
    end;
end;

procedure TPostProForm.CheckBox2Click(Sender: TObject);
var i, i2: Integer;
begin
    i2 := 0;
    for i := 2 to 7 do if (FindComponent('CheckBox' + IntToStr(i)) as TCheckBox).Checked then Inc(i2);
    CheckBox29.Enabled := i2 = 1;
    Edit7.Enabled := i2 = 1;
    Label6.Enabled := i2 = 1;
end;

procedure TPostProForm.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
    Mand3DForm.FormMouseWheel(Sender, Shift, WheelDelta, MousePos, Handled);
end;

procedure TPostProForm.Button16Click(Sender: TObject);
begin
    TriggerRepaint;
end;

procedure TPostProForm.Button19Click(Sender: TObject);
begin
    Edit10.Text := Edit1.Text;
end;

procedure TPostProForm.FormActivate(Sender: TObject);
begin
    Invalidate;//Repaint;
end;

procedure TPostProForm.FormHide(Sender: TObject);
begin
    IniVal[28] := IntToStr(Left) + ' ' + IntToStr(Top);
end;

procedure TPostProForm.UpdateButtonCaption(Btn: TSpeedButton; const Checkbox: TCheckBox);
var
  GlyphId: Integer;
begin
  if Btn.Down then
    if CheckBox.Checked then
      GlyphId := 0//3
    else
      GlyphId := -1 //1
  else
    if CheckBox.Checked then
      GlyphId := 0 //2
    else
      GlyphId := -1; //0
  Btn.Glyph := nil;
  ImageList1.GetBitmap(GlyphId,Btn.Glyph);
end;

procedure TPostProForm.CheckBox9Click(Sender: TObject);
begin
  UpdateButtonCaption(HardShadowsBtn, CheckBox9);
end;


end.


