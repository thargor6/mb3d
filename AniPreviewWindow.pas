unit AniPreviewWindow;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Animation, ComCtrls, FileHandling,
  HeaderTrafos, TypeDefinitions, Buttons, FTGifAnimate, Math3D;

type
  TAniPreviewForm = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    Timer2: TTimer;
    SpeedButton1: TSpeedButton;
    SaveDialog1: TSaveDialog;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    UpDown1: TUpDown;
    Edit1: TEdit;
    ScrollBar1: TScrollBar;
    CheckBox3: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ScrollBar1Scroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
  private
    PrevBMP: TBitmap;
    bRenderDone: LongBool;
    bNewTiming: LongBool;
    bFirstRender: LongBool;
 //   bNotStop: LongBool;
    iWidth, iHeight: Integer;
    iActKeyFrame, iActSubFrame: Integer;
    iFrameCount, iFStep, iFrendered: Integer;
    iBMPleft: Integer;
    Frames: array of array of Cardinal;
    siLight: array of TsiLight5;
    aFSIstart: Integer;
    aFSIoffset: Integer;
    CalcThreadStats: TCalcThreadStats;
  //  LastHeader: TMandHeader10;
 //   LHAddon: THeaderCustomAddon;
    MinClientWidth: Integer;
    FirstShow: LongBool;
    MakeAniGif: LongBool;
    bLoopAni: LongBool;
    iActiveThreads: Integer;
    APIpolType: Integer;
    PreviewStartFrame: Integer;
    iFrameNrDrawn: Integer;
    procedure FreeFrames;
    function FrameToPrevBMP(Fnr: Integer): LongBool;
    procedure StartCalc;
    procedure DrawFrameNr(Canvas: TCanvas; left, top, IFnr: Integer);
    procedure DrawFrame(Fnr: Integer);
  protected
    procedure WmThreadReady(var Msg: TMessage); message WM_ThreadReady;
  public
    bRenderCancel: LongBool;
    FastNinaccurate: LongBool;
    procedure StartRendering;
    procedure IncSubFrame;
  end;

var
  AniPreviewForm: TAniPreviewForm;

implementation

uses Mand, DivUtils, LightAdjust, Math, Calc, ImageProcess, MMSystem, CalcSR,
     CustomFormulas, DOF, Paint, CalcHardShadow, Interpolation, Maps, MapSequences;

{$R *.dfm}

procedure TAniPreviewForm.WmThreadReady(var Msg: TMessage);
begin
    Dec(iActiveThreads);
    if iActiveThreads = 0 then Timer2.Interval := 5;
end;

procedure TAniPreviewForm.StartCalc;
begin
    CalcVolLightMap(@InterpolHeader, @InterpolLightVals);
    SetLength(siLight, iWidth * iHeight);   //InterpolHeader.Width * ..
    CalcThreadStats.pLBcalcStop := @bRenderCancel;
    CalcThreadStats.pMessageHwnd := Self.Handle;
    CalcThreadStats.iProcessingType := 1;
    CalcThreadStats.iAllProcessingOptions := AllAutoProcessings(@InterpolHeader);
    if FastNinaccurate then CalcThreadStats.iAllProcessingOptions :=
      CalcThreadStats.iAllProcessingOptions and 1;
    bGetMCTPverbose := False;
    if CalcMandT(@InterpolHeader, @InterpolLightVals, @CalcThreadStats,
                 @siLight[0], InterpolHeader.Width * 18, aFSIstart, aFSIoffset, Rect(0, 0, InterpolHeader.Width - 1, InterpolHeader.Height - 1)) then
    begin
      iActiveThreads := CalcThreadStats.iTotalThreadCount;
      Timer2.Enabled := True;
    end;
end;

function TAniPreviewForm.FrameToPrevBMP(Fnr: Integer): LongBool;
var y, w4: Integer;
    b1, boff: Integer;
    pc1: PCardinal;
begin
    if (Fnr <= High(Frames)) and (Length(Frames[Fnr]) = (iWidth * iHeight)) then
    begin
      if PrevBMP.PixelFormat <> pf32Bit then PrevBMP.PixelFormat := pf32Bit;
      w4   := iWidth * 4;
      b1   := Integer(PrevBMP.ScanLine[0]);
      boff := Integer(PrevBMP.ScanLine[1]) - b1;
      pc1  := @Frames[Fnr][0];
      for y := 1 to iHeight do
      begin
        FastMove(pc1^, PCardinal(b1)^, w4);
        b1 := b1 + boff;
        Inc(pc1, iWidth);
      end;
      PrevBMP.Modified := True;
      iFrameNrDrawn := Fnr;
      Result := True;
    end
    else Result := False;
end;

procedure TAniPreviewForm.DrawFrameNr(Canvas: TCanvas; left, top, IFnr: Integer);
begin
    with Canvas do
    begin
      SetBkMode(Handle, TRANSPARENT);
      if CheckBox2.Checked then Font.Color := clWhite else Font.Color := clBlack;
      TextOut(left, top, IntToStr(IFnr));
    end;
end;

procedure TAniPreviewForm.DrawFrame(Fnr: Integer);
begin
    if iFrameNrDrawn = Fnr then Exit;
    if FrameToPrevBMP(Fnr) then
    begin
      Canvas.Draw(iBMPleft, 8, PrevBMP);
      if CheckBox1.Checked then
        DrawFrameNr(Canvas, iBMPleft + 2, 10, Fnr * iFStep + PreviewStartFrame);
    end
    else
    begin
   //   SetBkMode(Handle, 0);
      Canvas.Brush.Color := clBtnFace; //still black??
      Canvas.FillRect(Rect(iBMPleft, 8, iBMPleft + iWidth + 1, iHeight + 9));
    end;
end;

procedure TAniPreviewForm.IncSubFrame;
var i, af: Integer;
    c, cn: Cardinal;
begin
    if IFrendered < iFrameCount then
    begin
      if CheckBox3.Checked then
      begin
        ScrollBar1.Position := IFrendered;
        DrawFrame(IFrendered);
      end;
      Inc(IFrendered);
      TMapSequenceFrameNumberHolder.SetCurrFrameNumber(IFrendered * iFStep + 1);
      ProgressBar1.Position := IFrendered;
      if iActKeyFrame < AnimationForm.HeaderCount then
      begin
        Inc(iActSubFrame, iFStep);
        i := AnimationForm.KeyFrames[AnimationForm.KFposLUT[iActKeyFrame]].KFcount;
        while (iActKeyFrame < AnimationForm.HeaderCount) and (iActSubFrame >= i) do
        begin
          Dec(iActSubFrame, i);
          Inc(iActKeyFrame);
          if (iActKeyFrame < AnimationForm.HeaderCount) then
            i := AnimationForm.KeyFrames[AnimationForm.KFposLUT[iActKeyFrame]].KFcount;
        end;
      end;
    end
    else iActKeyFrame := AnimationForm.HeaderCount;
    if bRenderCancel or (iActKeyFrame >= AnimationForm.HeaderCount) then
    begin
      AnimationForm.AniOption := 0;
      ProgressBar1.Visible := False;
      if bRenderCancel and (IFrendered < 3) then
      begin
        Mand3DForm.EnableButtons;
        Mand3DForm.Button2.Enabled := True;
        bRenderDone := True;
      end
      else
      begin
        SpeedButton1.Visible := True;
        MakeAniGif := False;
        if bRenderCancel then Dec(IFrendered);
        bRenderCancel := False;
        try
          bNewTiming := False;
          c := 1;
          while (c < 5) do
          begin
            if timeBeginPeriod(c) = TIMERR_NOERROR then
            begin
              cn := c;
              bNewTiming := True;
              c := 5;
            end;
            Inc(c);
          end;
          af := -1;
          while (not bRenderCancel) and Visible do
          begin
            Delay(Round(1000 / Max(1, UpDown1.Position)));
            if CheckBox3.Checked and not MakeAniGif then
            begin
              Inc(af);
              if af >= IFrendered then af := 0;
              ScrollBar1.Position := af;
              DrawFrame(af);
            end;
          end;
        finally
          Mand3DForm.EnableButtons;
          Mand3DForm.Button2.Enabled := True;
          bRenderDone := True;
          AnimationForm.isCalculating := False;
          Visible := False;
          FreeFrames;
          if bNewTiming then timeEndPeriod(cn);
        end;
      end;
    end
    else Timer1.Enabled := True;
end;

procedure TAniPreviewForm.Timer1Timer(Sender: TObject); //ani preview rendering timer, next frame
var i0, i1, i2, i3: Integer;
    PL0, PL1, PL2, PL3: TPLightVals;
    t: Double;
  //  bHeaderChanged: LongBool;
    L0, L1, L2, L3: TLightVals;
begin
  Timer1.Enabled := False;
  with AnimationForm do
  begin
    if IFrendered < iFrameCount then
    begin
      i1 := KFposLUT[iActKeyFrame];
      if bLoopAni then
      begin
        i0 := KFposLUT[(iActKeyFrame - 1 + HeaderCount) mod HeaderCount];
        i2 := KFposLUT[(iActKeyFrame + 1) mod HeaderCount];
        i3 := KFposLUT[(iActKeyFrame + 2) mod HeaderCount];
      end else begin
        if iActKeyFrame > 0 then i0 := KFposLUT[iActKeyFrame - 1] else i0 := i1;
        if iActKeyFrame < HeaderCount - 1 then i2 := KFposLUT[iActKeyFrame + 1]
        else i2 := i1;
        if iActKeyFrame < HeaderCount - 2 then i3 := KFposLUT[iActKeyFrame + 2]
        else i3 := i2;
      end;
      t := iActSubFrame / Max(1, KeyFrames[i1].KFcount);

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
      MakeLightValsFromHeaderLight(@KeyFrames[i1].HeaderParas, @L1, 1, 0); //to ini pointer etc
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
      else if APIpolType > 0 then
      begin
        AnimationForm.IniKFHeader(i0);
        MakeLightValsFromHeaderLight(@KeyFrames[i0].HeaderParas, PL0, 1, 0);  //imagescale?
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
        MakeLightValsFromHeaderLight(@KeyFrames[i2].HeaderParas, PL2, 1, 0);
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
      else if APIpolType > 0 then
      begin
        AnimationForm.IniKFHeader(i3);
        MakeLightValsFromHeaderLight(@KeyFrames[i3].HeaderParas, PL3, 1, 0);
        CopyRotMfromLightVals(PL3, @IPOLM3);
      end;

      if APIpolType = 0 then  //linear
      begin
        if i1 <> i2 then
          Interpolate2frames(@KeyFrames[i1].HeaderParas, @KeyFrames[i2].HeaderParas, PL1, PL2, t);
      end
      else  //bezier
      begin
        Interpolate3framesBezier(@KeyFrames[i0].HeaderParas, @KeyFrames[i1].HeaderParas,
            @KeyFrames[i2].HeaderParas, @KeyFrames[i3].HeaderParas, PL0, PL1, PL2, PL3, t);
  {    end
      else    //cubic
      begin
        Interpolate4framesCubic(@KeyFrames[i0].HeaderParas, @KeyFrames[i1].HeaderParas,
          @KeyFrames[i2].HeaderParas, @KeyFrames[i3].HeaderParas, PL0, PL1, PL2, PL3, t);  }
      end;

      AniCalc3D := KeyFrames[i1].HeaderParas.bCalc3D > 0;

      aFSIstart  := Integer(@Frames[IFrendered][0]);
      aFSIoffset := iWidth * 4;

      if not FastNinaccurate then
      begin
        t := iWidth / AnimationForm.AniWidth;
        InterpolHeader.sDEstop := InterpolHeader.sDEstop * t;
        InterpolHeader.sDOFclipR := InterpolHeader.sDOFclipR * t;
      end;
      InterpolHeader.Width := iWidth;
      InterpolHeader.Height := iHeight;

   {   if InterpolHeader.bHScalculated = 0 then
      begin
        InterpolLightVals.sShadGr := InterpolLightVals.sShadGr * v;
        InterpolLightVals.sShad   := InterpolLightVals.sShad / v;
      end;  }

      IniCFsFromHAddon(@InterpolHAddon, InterpolHeader.PHCustomF);

      FreeLightMapsInLValsWithRestriction(Pl0, @InterpolLightVals);  //only in the end??
      FreeLightMapsInLValsWithRestriction(Pl1, @InterpolLightVals);
      FreeLightMapsInLValsWithRestriction(Pl2, @InterpolLightVals);
      FreeLightMapsInLValsWithRestriction(Pl3, @InterpolLightVals);

      startCalc;
    end
    else IncSubFrame;
  end;
end;

procedure TAniPreviewForm.FreeFrames;
var i: Integer;
begin
    for i := 0 to High(Frames) do SetLength(Frames[i], 0);
    SetLength(Frames, 0);
    iFrameCount := 0;
    for i := 1 to 9 do SetLength(ATrousWLprevAni[i], 0);
end;

procedure TAniPreviewForm.StartRendering;
var i, c: Integer;
begin
    Val(AnimationForm.Edit10.Text, i, c);
    if (i < 1) or (i > AnimationForm.HeaderCount) then i := AnimationForm.HeaderCount;
    bRenderDone   := False;
    bRenderCancel := False;
    bFirstRender  := True;
    APIpolType    := AnimationForm.RadioGroup2.ItemIndex;
    iActKeyFrame  := Max(0, StrToIntTrim(AnimationForm.Edit9.Text) - 1);
    iFStep        := AnimationForm.UpDown1.Position;
    iFrameCount   := AnimationForm.TotalBMPsToRender(iActKeyFrame + 1, i, iFStep); // div iFStep;
    iWidth        := AnimationForm.AniWidth  div AnimationForm.UpDown2.Position;
    iHeight       := AnimationForm.AniHeight div AnimationForm.UpDown2.Position;
    bLoopAni      := AnimationForm.CheckBox2.Checked;
    PreviewStartFrame := AnimationForm.SubFramesToKF(iActKeyFrame) + 1;
    iActSubFrame  := 0;
    IFrendered    := 0;
    TMapSequenceFrameNumberHolder.SetCurrFrameNumber(IFrendered * iFStep + 1);
    if iFrameCount > 1 then
    begin
      CheckBox3.Checked := True;
      if FirstShow then MinClientWidth := ClientWidth;
      SetLength(Frames, iFrameCount);
      for i := 0 to iFrameCount - 1 do SetLength(Frames[i], iWidth * iHeight);
      ClientWidth  := Max(MinClientWidth , iWidth);
      ClientHeight := iHeight + Panel1.Height + 16;
      iBMPleft     := (ClientWidth - iWidth) div 2;
      PrevBMP.Width  := iWidth;
      PrevBMP.Height := iHeight;
      ProgressBar1.Max      := iFrameCount;
      ProgressBar1.Position := 0;
      ProgressBar1.Visible  := True;
      ScrollBar1.Max := iFrameCount - 1;
      AnimationForm.AniOption := -1;
      iFrameNrDrawn := -1;
      Mand3DForm.DisableButtons;
      Mand3DForm.Button2.Caption := 'Calculate 3D';
      Mand3DForm.Button2.Enabled := False;
      Visible        := True;
      Timer1.Enabled := True;
    end;  
end;

procedure TAniPreviewForm.FormCreate(Sender: TObject);
begin
    PrevBMP := TBitmap.Create;
    PrevBMP.PixelFormat := pf32Bit;
    FirstShow := True;
    bRenderCancel := False;
end;

procedure TAniPreviewForm.FormDestroy(Sender: TObject);
begin
    PrevBMP.Free;
end;

procedure TAniPreviewForm.Button1Click(Sender: TObject);
begin
    if bRenderDone then
    begin
      Visible := False;
      Mand3DForm.EnableButtons;
      Mand3DForm.Button2.Enabled := True;
      FreeFrames;
    end
    else bRenderCancel := True;
end;

procedure TAniPreviewForm.SpinEdit1Change(Sender: TObject);
begin
    bNewTiming := True;
end;

procedure TAniPreviewForm.Timer2Timer(Sender: TObject);
var c, i, n, x, sloff: Integer;
    DoFrec: TDoFrec;
    R: TRect;
begin
    n := 0;
    for i := 1 to CalcThreadStats.iTotalThreadCount do
      if CalcThreadStats.CTrecords[i].isActive > 0 then Inc(n);

    if n = 0 then
    begin
      R := Rect(0, 0, InterpolHeader.Width - 1, InterpolHeader.Height - 1);
      sloff := InterpolHeader.Width * 18;
      Timer2.Enabled := False;
      iActiveThreads := 0;
      CalcStepWidth(@InterpolHeader);
      c := CalcThreadStats.iProcessingType;
      if not bRenderCancel then
      begin
        //after processings
      {  case c of  //0: not calculating, 1: main calculation, 2: hard shadow, 3: AO1, 4: AO2, 5: AO3, 6: BGshadow, 7: DOF
          6:  CalcBGambI(CalcThreadStats.iTotalThreadCount, @siLight[0], @bgsArrPAni);
        end; }

        x := 1 shl c;
        while (x < 256) and ((CalcThreadStats.iAllProcessingOptions and x) = 0) do x := x shl 1;

        if (CalcThreadStats.iAllProcessingOptions and x) > 0 then   //next processing step
        begin              
          CalcThreadStats.pLBcalcStop := @bRenderCancel;
          CalcThreadStats.pMessageHwnd := Self.Handle;
          case x of        // 4: hard shadow postcalc, 8: AO, 16: AO2, 32: BGshadow, 64: DOF
            2:  begin
                  CalcThreadStats.iProcessingType := 2;
                  try
                    NormalsOnZbuf(@InterpolHeader, @siLight[0]);
                  finally
                    CalcThreadStats.iTotalThreadCount := 0;
                    Timer2.Interval := 5;
                    Timer2.Enabled := True;
                  end;
                end;
            4:  begin
                  CalcThreadStats.iProcessingType := 3;
                  if CalcHardShadowT(@InterpolHeader, @CalcThreadStats, @siLight[0], sloff, @InterpolLightVals, False, R) then
                    iActiveThreads := CalcThreadStats.iTotalThreadCount;
                end;
            8:  begin
                  CalcThreadStats.iProcessingType := 4;
                  if CalcAmbShadowT(@InterpolHeader, @siLight[0], sloff, @CalcThreadStats, @ATrousWLprevAni, R) then
                    iActiveThreads := CalcThreadStats.iTotalThreadCount;
                end;
           32:  begin
                  CalcThreadStats.iProcessingType := 6;
                  PaintM(@InterpolHeader, @InterpolLightVals, @siLight[0], aFSIstart, aFSIoffset);
                  if CalcSRT(@InterpolHeader, @InterpolLightVals, @CalcThreadStats,
                             @siLight[0], aFSIstart, aFSIoffset, R) then
                    iActiveThreads := CalcThreadStats.iTotalThreadCount;
                end;
           64:  begin
                  CalcThreadStats.iProcessingType := 7;                
                  try
                    if (CalcThreadStats.iAllProcessingOptions and 32) = 0 then
                      PaintM(@InterpolHeader, @InterpolLightVals, @siLight[0], aFSIstart, aFSIoffset);
                    DoFrec.SL := @siLight[0];
                    DoFrec.colSL := PCArdinal(aFSIstart);
                    DoFrec.MHeader := @InterpolHeader;
                    DoFrec.SLoffset := aFSIoffset;
                    DoFrec.Verbose := False;
                    for n := 0 to (InterpolHeader.bCalcDOFtype shr 1) and 3 do
                    begin
                      DoFrec.pass := n;
                      if ((InterpolHeader.bCalcDOFtype shr 3) and 1) = 1 then
                        doDOF(DoFrec)
                      else
                        doDOFsort(DoFrec);
                    end;
                  except end;  
                end;
          end;
        end;
      end;
      if iActiveThreads > 0 then Timer2.Enabled := True;
      if not Timer2.Enabled then
      begin
        if CalcThreadStats.iProcessingType < 6 then
          PaintM(@InterpolHeader, @InterpolLightVals, @siLight[0], aFSIstart, aFSIoffset);
        //if FastNInaccurate then ipol bicubic x2  , aFSIstart, aFSIoffset
        IncSubFrame;
      end;
      if CalcThreadStats.iProcessingType <> 2 then Timer2.Interval := 50;
    end;
end;

procedure TAniPreviewForm.FormHide(Sender: TObject);
begin
    if bRenderDone then
    begin
      Visible := False;
      Mand3DForm.EnableButtons;
      Mand3DForm.Button2.Enabled := True;
      FreeFrames;
    end
    else bRenderCancel := True;
    IniVal[8] := IntToStr(UpDown1.Position);
end;

procedure TAniPreviewForm.FormShow(Sender: TObject);
begin
    SpeedButton1.Visible := False;
    if FirstShow then
    begin
      FirstShow := False;
      UpDown1.Position := StrToIntTry(IniVal[8], 15);
      SetDialogDirectory(SaveDialog1, IniDirs[2]);
    end;
end;

procedure TAniPreviewForm.ScrollBar1Scroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
    CheckBox3.Checked := False;
    DrawFrame(ScrollPos);
end;

procedure TAniPreviewForm.SpeedButton1Click(Sender: TObject);
var i: Integer;
    Picture: TPicture;
begin
    MakeAniGif := True;
    if SaveDialog1.Execute then
    try
      SpeedButton1.Enabled := False;
      Screen.Cursor := crHourGlass;
      ProgressBar1.Max := IFrendered;
      ProgressBar1.Position := 0;
      ProgressBar1.Visible := True;
      GifAnimateBegin;
      for i := 1 to IFrendered do
      begin
        FrameToPrevBMP(i - 1);
        if CheckBox1.Checked then DrawFrameNr(PrevBMP.Canvas, 2, 2, (i - 1) * iFStep + PreviewStartFrame);
        GifAnimateAddImage(PrevBMP, False, 1000 div UpDown1.Position);
        ProgressBar1.Position := i;
      end;
      Picture := GifAnimateEndPicture;
      Picture.SaveToFile(SaveDialog1.FileName); 
      Picture.Free;
    finally
      PrevBMP.PixelFormat := pf32Bit;
      ProgressBar1.Visible := False;
      Screen.Cursor := crDefault;
      SpeedButton1.Enabled := True;
    end;
    MakeAniGif := False;
end;

end.
