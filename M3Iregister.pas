{ Just enough to make the OpenPictureDialog work with M3I + M3C }

unit M3Iregister;

interface

uses Windows, SysUtils, Graphics, Classes, TypeDefinitions, ExtCtrls,
     Messages, Dialogs, StdCtrls, Controls;

type
  TOpenPictureDialogM3D = class(TOpenDialog)
  private
    FPicturePanel: TPanel;
    FPictureLabel: TLabel;
    FPaintPanel: TPanel;
    FImageCtrl: TImage;
    FSavedFilename: string;
    function IsFilterStored: Boolean;
  protected
    procedure DoClose; override;
    procedure DoSelectionChange; override;
    procedure DoShow; override;
    property ImageCtrl: TImage read FImageCtrl;
    property PictureLabel: TLabel read FPictureLabel;
  published
    property Filter stored IsFilterStored;
  public
    OrigFileSize: TPoint;
    constructor Create(AOwner: TComponent); override;
    function Execute(ParentWnd: HWND): Boolean; override;
  end;

  TM3IGraphic = Class(TBitmap)  //TGraphic.. image width <> bitmap width
  private
  protected
  public
    procedure LoadFromStream(Stream: TStream); override;
    procedure LoadFromFile(const Filename: String); override;
    procedure GetOriginalSize(const Filename: String; var ISize: TPoint);
  end;
  TM3CGraphic = Class(TBitmap)
  private
  protected
  public
    procedure LoadFromStream(Stream: TStream); override;
    procedure LoadFromFile(const Filename: String); override;
    procedure GetOriginalSize(const Filename: String; var ISize: TPoint);
  end;
var
  NoPreviewBMP: TBitMap;

implementation

uses FileHandling, Math3D, DivUtils;

{procedure Register;
begin
    RegisterComponents('Custom'' Dialogs', [TOpenPictureDialogM3D]);
end;  }

type
    TSilentPaintPanel = class(TPanel)
    protected
        procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    end;

procedure TSilentPaintPanel.WMPaint(var Msg: TWMPaint);
begin
    try
      inherited;
    except
      Caption := '';//'No preview';
    end;
end;

{ TOpenPictureDialogM3D }

{$R ExtDlgsM3D.res}

constructor TOpenPictureDialogM3D.Create(AOwner: TComponent);
begin
    inherited Create(AOwner);
    Filter := GraphicFilter(TGraphic);
    FPicturePanel := TPanel.Create(Self);
    with FPicturePanel do
    begin
      Name := 'PicturePanel';
      Caption := '';
      SetBounds(204, 5, 169, 200);
      BevelOuter := bvNone;
      BorderWidth := 6;
      TabOrder := 1;
      FPictureLabel := TLabel.Create(Self);
      with FPictureLabel do
      begin
        Name := 'PictureLabel';
        Caption := '';
        SetBounds(6, 6, 157, 23);
        Align := alTop;
        AutoSize := False;
        Parent := FPicturePanel;
      end;
      FPaintPanel := TSilentPaintPanel.Create(Self);
      with FPaintPanel do
      begin
        Name := 'PaintPanel';
        Caption := '';
        SetBounds(6, 29, 157, 145);
        Align := alClient;
        BevelInner := bvRaised;
        BevelOuter := bvLowered;
        TabOrder := 0;
        FImageCtrl := TImage.Create(Self);
        Parent := FPicturePanel;
        with FImageCtrl do
        begin
          Name := 'PaintBox';
          Align := alClient;
          Parent := FPaintPanel;
          Proportional := True;
          Stretch := True;
          Center := True;
          IncrementalDisplay := True;
        end;
      end;
    end;
end;

procedure TOpenPictureDialogM3D.DoSelectionChange;
var FullName: string;
    ValidPicture: Boolean;
function ValidFile(const FileName: string): Boolean;
begin
    Result := GetFileAttributes(PChar(FileName)) <> $FFFFFFFF;
end;
begin
    FullName := FileName;
    if FullName <> FSavedFilename then
    begin
      FSavedFilename := FullName;
      ValidPicture := FileExists(FullName) and ValidFile(FullName);
      if ValidPicture then
      try
        FImageCtrl.Picture.LoadFromFile(FullName);   //here load m3i m3c in bmp

        TM3IGraphic(FImageCtrl.Picture).GetOriginalSize(FullName, OrigFileSize);

        FPaintPanel.Caption := '';
        FPictureLabel.Caption := 'Size: ' + IntToStr(OrigFileSize.X) + 'x' +
                                            IntToStr(OrigFileSize.Y);
      except
        ValidPicture := False;
      end;
      if not ValidPicture then
      begin
        FPictureLabel.Caption := '';//SPictureLabel;
        FImageCtrl.Picture := nil;
        FPaintPanel.Caption := '';//No preview';
      end;
    end;
    inherited DoSelectionChange;
end;

procedure TOpenPictureDialogM3D.DoClose;
begin
    inherited DoClose;
 //   Application.HideHint;
end;

procedure TOpenPictureDialogM3D.DoShow;
var PreviewRect, StaticRect: TRect;
begin
    { Set preview area to entire dialog }
    GetClientRect(Handle, PreviewRect);
    StaticRect := GetStaticRect;
    { Move preview area to right of static area }
    PreviewRect.Left := StaticRect.Left + (StaticRect.Right - StaticRect.Left);
    Inc(PreviewRect.Top, 4);
    FPicturePanel.BoundsRect := PreviewRect;
    FImageCtrl.Picture := nil;
    FSavedFilename := '';
    FPaintPanel.Caption := '';//srNone;
    FPicturePanel.ParentWindow := Handle;
    inherited DoShow;
end;

function TOpenPictureDialogM3D.Execute(ParentWnd: HWND): Boolean;
begin
    if NewStyleControls and not (ofOldStyleDialog in Options) then
      Template := 'DLGTEMPLATEM3D' else Template := nil;
    Result := inherited Execute(ParentWnd);
end;

function TOpenPictureDialogM3D.IsFilterStored: Boolean;
begin
    Result := not (Filter = GraphicFilter(TGraphic));
end;


{procedure ConvertSiLight4To5(PSL4: TPsiLight4; PSL5: TPsiLight5; n: Integer);
var i: Integer;
    SinTab: array[0..32767] of Single;
type tt = array[0..11] of Byte;
     ptt = ^tt;
begin
    for i := 0 to 32767 do SinTab[i] := Sin(i * Pid16384);
    for i := 1 to n do
    begin
      PSL5.NormalX := Round(SinTab[PSL4.LightAngleX and $7FFF] * 32767);
      PSL5.NormalY := Round(SinTab[PSL4.LightAngleY and $7FFF] * 32767);
      PSL5.NormalZ := Round(SinTab[(PSL4.LightAngleX + 8192) and $7FFF] * SinTab[(PSL4.LightAngleY + 8192) and $7FFF] * 32767);
      ptt(@PSL5.RoughZposFine)^ := ptt(@PSL4.RoughZposFine)^;
      Inc(PSL4);
      Inc(PSL5);
    end;
end;   }

{function SVecToCol(sv: TSVec): Cardinal;
begin
    sv := mMinMaxSVec(0, 1, sv);
    Result := Round(sv[2] * 255) or (Round(sv[1] * 255) shl 8) or (Round(sv[0] * 255) shl 16);
end;

function AddSVecWeight(const SPos, SPosPlus: TSVec; const Step: Integer): TSVec;
asm
    push ecx
    push ebx
    mov  ebx, [ebp + 8]
    mov  [ebp - 4], ecx
    fld  dword [edx]
    fld  dword [edx + 4]
    fld  dword [edx + 8]
    fild dword [ebp - 4]
    fmul st(3), st
    fmul st(2), st
    fmulp
    fadd dword [eax + 8]
    fstp dword [ebx + 8]
    fadd dword [eax + 4]
    fstp dword [ebx + 4]
    fadd dword [eax]
    fstp dword [ebx]
    pop  ebx
    pop  ecx
end;       }

{procedure TM3IGraphic.LoadFromResourceName(Instance: HInst; const Name: String);
var ResStream: TResourceStream;
begin
    try
      ResStream := TResourceStream.Create(Instance, Name, RT_RCDATA);
    except
      exit;
    end;
    try
      LoadFromStream(ResStream);
    finally
      ResStream.Free;
    end;
end;

procedure TM3IGraphic.LoadFromResourceID(Instance: HInst; ResID: Integer);
begin
    LoadFromResourceName(Instance, String(ResID));
end;  }

procedure TM3IGraphic.GetOriginalSize(const Filename: String; var ISize: TPoint);
var FileStream: TFileStream;
begin
    if not FileExists(Filename) then
    begin
      ISize := Point(0, 0);
      Exit;
    end;
    FileStream := TFileStream.Create(Filename, fmOpenRead);
    FileStream.Seek(4, soBeginning);
    FileStream.Read(ISize.X, 4);
    FileStream.Read(ISize.Y, 4);
    FileStream.Free;
end;

procedure TM3IGraphic.LoadFromFile(const Filename: String);
var FileStream: TFileStream;
begin
    if not FileExists(Filename) then Exit;
    FileStream := TFileStream.Create(Filename, fmOpenRead);      {[fsmRead]}
    LoadFromStream(FileStream);
    FileStream.Free;
end;

procedure TM3IGraphic.LoadFromStream(Stream: TStream);    //only if preview image is contained?
var {SL5: TsiLight5;
    dx, dy, d: Double;
    nx, ny, xx, yy, SLsize, LineSize, MID, TopAdr, YAdr, Dfunc: Integer;
    pc, pcin: PCardinal;
    SVcol: TSVec;
    sdv: TLightSD;
    PLV: TPaintLightVals;
    aspect, sFOV, wid1d: Single;
    SPosX, SPosY, SPosXadd, SPosYadd, SPosYstart: TSVec;
    PaintVGrads: TMatrix3; }
    MID, Wid, Hei, iAdr, nx, ny, LineSize, xx, yy, YAdr: Integer;   // MandId, Width, Height
    dx, dy: Double;
    pc: PCardinal;
 //   buf: array of Cardinal;
label lab1;
begin
    try
      if PixelFormat <> pf32bit then PixelFormat := pf32bit;
      Stream.Seek(0, soBeginning);
      Stream.Read(MID, 4);
      if MID < 20 then goto lab1;
      Stream.Read(Wid, 4);
      Stream.Read(Hei, 4);
      if (Wid < 4) or (Hei < 4) or (Wid > 65000) or (Hei > 65000) then goto lab1;
      if Wid > Hei * 1.4 then SetSize(152, (Hei * 152) div Wid)
                         else SetSize((Wid * 210) div Hei, 210);
      LineSize := Wid * 4;
    //  SetLength(buf, Wid);
      dx := (Wid - 1) / (Width - 1);
      dy := (Hei - 1) / (Height - 1);

      iAdr := SizeOf(TMandHeader11) + Wid * Hei * SizeOf(TsiLight5) + SizeOf(THeaderCustomAddon);
      if Stream.Size < iAdr + LineSize * Hei then goto lab1;

      Stream.Seek(iAdr, soBeginning);
      for ny := 0 to Height - 1 do
      begin
        pc := ScanLine[ny];
        yy := Round(ny * dy);
        YAdr := yy * LineSize + iAdr;
        for nx := 0 to Width - 1 do
        begin
          xx := Round(nx * dx);
          Stream.Seek(YAdr + xx * 4, soBeginning);
          Stream.Read(pc^, 4);
          Inc(pc);
        end;
      end;
      Modified := true;
      Exit;
lab1: //SetSize(1, 1);
  //    Free;
      Assign(NoPreviewBMP);
   //   Modified := true;
    except
      raise Exception.Create('Unable to open M3I file');
    end;


{    Header.PCFAddon := @HAddon;
    for xx := 0 to 5 do Header.PHCustomF[xx] := @HybridCustoms[xx];
    if LoadParsFromStream(Header, Stream) then
  //  with Bitmap do
    begin
      PixelFormat := pf32bit;
      if Header.Width > Header.Height * 1.4 then
      begin
        Width  := 152;
        Height := (Header.Height * 152) div Header.Width;
      end else begin
        Height := 210;
        Width  := (Header.Width * 210) div Header.Height;
      end;
      dx := (Header.Width - 1) / (Width - 1);
      dy := (Header.Height - 1) / (Height - 1);
      // Make LightVals + PaintParameter
      MakeLightValsFromHeaderLight(@Header, @LightVals, 1, Header.bStereoMode);
      PaintParameter.ppPaintHeight := Header.Height;
      PaintParameter.ppPaintWidth := Header.Width;
      if Header.bPlanarOptic = 2 then sFOV := Pi else
        sFOV := Header.dFOVy * Pid180;
      Dfunc := Header.Light.TBoptions shr 30; // 2:dfunc=2 1:dfunc=0
      wid1d := 1 / Width;
      CalcStepWidth(@Header);
      PaintVGrads := NormaliseMatrixTo(Header.dStepWidth, @Header.hVGrads);
      PaintParameter.ppWidth  := Header.Width;
      PaintParameter.ppHeight := Header.Height;
      PaintParameter.ppYinc   := 1;
      PaintParameter.PLVals   := @LightVals;
      PaintParameter.pVgrads  := @PaintVGrads;
      PaintParameter.sFOVy    := sFOV;
      PaintParameter.ppXOff   := CalcXoff(@Header);
      CalcPPZvals(Header, PaintParameter.Zcorr, PaintParameter.ZcMul, PaintParameter.ZZstmitDif);
      PaintParameter.StepWidth := Header.dStepWidth;
      PaintParameter.ppPlanarOptic := Header.bPlanarOptic and 3;
      d := MinMaxCD(0.01, sFOv * 0.5, 1.5);
      PaintParameter.ppPlOpticZ := Cos(d) * d / Sin(d);
      if PaintParameter.ppPlanarOptic = 2 then aspect := 2 else
        aspect := width / height;
      GetStartSPosAndAddVecs(PLV, PaintParameter, SPosYstart, SPosYadd, SPosXadd);

      try
        Stream.Seek(0, soBeginning);
        Stream.Read(MID, 4);
        if MID <  4 then Stream.Seek(200, soBeginning) else
        if MID <  7 then Stream.Seek(272, soBeginning) else
        if MID <  8 then Stream.Seek(580, soBeginning) else
        if MID < 20 then Stream.Seek(SizeOf(TMandHeader9), soBeginning)
                    else Stream.Seek(SizeOf(TMandHeader10), soBeginning);
        TopAdr := Stream.Position;
    {    if MID < 19 then SetLength(SI4, j);
        if MID < 18 then
        begin
          SetLength(SI3, j);
          BlockRead(f, SI3[0], j * SizeOf(TsiLight3));
          PSI3 := @SI3[0];
          PSI4 := @SI4[0];
          for i := 1 to j do
          begin
            PSI4^ := PSI3^;
            Inc(PSI4);
            Inc(PSI3);
            PWord(PSI4)^ := 0;
            PSI4 := PInteger(Integer(PSI4) + 2);
            PSI4^ := PSI3^;
            Inc(PSI4);
            Inc(PSI3);
            PSI4^ := PSI3^;
            Inc(PSI4);
            Inc(PSI3);
            PWord(PSI4)^ := 0;
            PSI4 := PInteger(Integer(PSI4) + 2);
          end;
          SetLength(SI3, 0);
        end
        else if MID < 19 then BlockRead(f, SI4[0], j * SizeOf(TsiLight4));   }

 {       if MID < 18 then SLsize := SizeOf(TsiLight3) else
        if MID < 19 then SLsize := SizeOf(TsiLight4) else
                         SLsize := SizeOf(TsiLight5);
        LineSize := SLsize * Header.Width;

        for ny := 0 to Height - 1 do
        begin
          pc := ScanLine[ny];
          yy := Round(ny * dy);
          YAdr := yy * LineSize + TopAdr;
          SPosY := AddSVecWeight(SPosYstart, SPosYadd, yy);
          PLV.yPos := ny / Height;
          PreCalcDepthCol(Dfunc, @PLV, LightVals.PLValigned);

          for nx := 0 to Width - 1 do
          begin
            xx := Round(nx * dx);

            if PLV.iPlanarOptic = 2 then SPosX := SPosYstart else
              SPosX := AddSVecWeight(SPosY, SPosXadd, xx);
            PLV.xPos := nx * wid1d;
            CalcViewVec(@PLV, aspect);

            Stream.Seek(YAdr + xx * SLsize, soBeginning);
            Stream.Read(SL5, SLsize);
            if SLsize < 18 then     //convert type
            begin


            end;
            CalcObjPos(PLV, PaintParameter, @SL5, @SPosX);
            CalcPixelColorSvec(@SVcol, sdv, @SL5, @LightVals, @PaintParameter);
            pc^ := SVecToCol(SVcol);
            Inc(pc);
          end;
        end;
      {  if MID > 18 then
          BlockRead(f, Mand3DForm.siLight5[0], j * SizeOf(TsiLight5))
        else
          ConvertSiLight4To5(@SI4[0], @Mand3DForm.siLight5[0], j);

        if MID < 20 then
        begin
          PW := PWord(Integer(@Mand3DForm.siLight5[0]) + 10);  //@shadow
          if Header.bCalculateHardShadow > 0 then
          begin
            for i := 1 to j do
            begin
              PWord(Integer(PW) + 2)^ := PWord(Integer(PW) + 2)^ shr 1;
              PSmallint(Integer(PW) - 6)^ := -PSmallint(Integer(PW) - 6)^;
              if PW^ < 32767 then PW^ := $400 else PW^ := 0;
              Inc(PW, 9);
            end;
          end else begin
            for i := 1 to j do
            begin
              PWord(Integer(PW) + 2)^ := PWord(Integer(PW) + 2)^ shr 1;
              PSmallint(Integer(PW) - 6)^ := -PSmallint(Integer(PW) - 6)^;
              if PWord(Integer(PW) - 2)^ > 32767 then PW^ := 100 else
              PW^ := (32767 - (PW^ and $7FFF)) shr 5;
              Inc(PW, 9);
            end;
          end;
        end;   }

 {     finally
      end;
      Modified := true;

    end
    else raise Exception.Create('Unable to open M3I file');   }
end;

procedure TM3CGraphic.GetOriginalSize(const Filename: String; var ISize: TPoint);
var FileStream: TFileStream;
begin
    if not FileExists(Filename) then
    begin
      ISize := Point(0, 0);
      Exit;
    end;
    FileStream := TFileStream.Create(Filename, fmOpenRead);
    FileStream.Seek(4, soBeginning);
    FileStream.Read(ISize.X, 4);
    FileStream.Read(ISize.Y, 4);
    FileStream.Free;
end;

procedure TM3CGraphic.LoadFromStream(Stream: TStream);
var MID, Wid, Hei, iAdr, nx, ny, LineSize, xx, yy, YAdr: Integer;
    dx, dy, pSContrast: Double;
    pc: PCardinal;
    sMC: TMCrecord;
 //   buf: array of Cardinal;
    sv1: TSVec;
    MCcontrast: Byte;
label lab1;
begin
    try
      if PixelFormat <> pf32bit then PixelFormat := pf32bit;
      Stream.Seek(0, soBeginning);
      Stream.Read(MID, 4);
      if MID < 20 then goto lab1;
      Stream.Read(Wid, 4);
      Stream.Read(Hei, 4);
      if (Wid < 4) or (Hei < 4) or (Wid > 65000) or (Hei > 65000) then goto lab1;
      if Wid > Hei * 1.4 then SetSize(152, (Hei * 152) div Wid)
                         else SetSize((Wid * 210) div Hei, 210);
      Stream.Seek(423 {Off(TMandHeader10.MCcontrast)}, soBeginning);
      Stream.Read(MCcontrast, 1);
      pSContrast := (Sqr(MCcontrast + 128) * 2.25 / 65536 + 1.75) * 0.25;
      LineSize := Wid * SizeOf(TMCrecord);
    //  SetLength(buf, Wid);
      dx := (Wid - 1) / (Width - 1);
      dy := (Hei - 1) / (Height - 1);
      iAdr := SizeOf(TMandHeader11) + SizeOf(THeaderCustomAddon);
      if Stream.Size < iAdr + LineSize * Hei then goto lab1;
//BlockWrite(f, siLightMC[0], SizeOf(TMCrecord) * Length(siLightMC));
 //     Stream.Seek(iAdr, soBeginning);
      for ny := 0 to Height - 1 do
      begin
        pc := ScanLine[ny];
        yy := Round(ny * dy);
        YAdr := yy * LineSize + iAdr;
        for nx := 0 to Width - 1 do
        begin
          xx := Round(nx * dx);
          Stream.Seek(YAdr + xx * SizeOf(TMCrecord), soBeginning);
          Stream.Read(sMC, SizeOf(TMCrecord));
          if sMC.RayCount > 0 then
          begin
            sv1[0] := MCRGBtoDouble(@sMC.Red) * pSContrast;
            sv1[1] := MCRGBtoDouble(@sMC.Green) * pSContrast;
            sv1[2] := MCRGBtoDouble(@sMC.Blue) * pSContrast;
            sv1 := mMinMaxSVec(0, 1, sv1);
            pc^ := (Round(sv1[0] * 255) shl 16) or (Round(sv1[1] * 255) shl 8) or Round(sv1[2] * 255);
          end;
          Inc(pc);
        end;
      end;
      Modified := true;
      Exit;
lab1:// SetSize(1, 1);  // with 0,0 the image is not updated in dialog
      Assign(NoPreviewBMP);
    except
      raise Exception.Create('Unable to open M3C file');
    end;
end;

procedure TM3CGraphic.LoadFromFile(const Filename: String);
var FileStream: TFileStream;
begin
    if not FileExists(Filename) then exit;
    FileStream := TFileStream.Create(Filename, fmOpenRead);      {[fsmRead]}
    LoadFromStream(FileStream);
    FileStream.Free;
end;


{procedure TM3IGraphic.LoadFromFile(const FileName: String);   //recalc only header downsized...!?
var SL5: TsiLight5;
    dx, dy: Double;
    nx, ny, xx, yy, SLsize, LineSize, MID, TopAdr, YAdr: Integer;
    pc, pcin: PCardinal;
    SVcol: TSVec;
    sdv: TLightSD;
    f: file;
begin
    if LoadParameter(Header, FileName, False) then
    begin
      PixelFormat := pf32bit;
      if Header.Width > Header.Height * 1.4 then
      begin
        Width  := 152;
        Height := (Header.Height * 152) div Header.Width;
      end else begin
        Height := 210;
        Width  := (Header.Width * 210) div Header.Height;
      end;
      dx := (Header.Width - 1) / (Width - 1);
      dy := (Header.Height - 1) / (Height - 1);

      // Make LightVals + PaintParameter


      AssignFile(f, FileName);
      Reset(f, 1);
      try
        BlockRead(f, MID, 4);
        if MID <  4 then Seek(f, 200) else
        if MID <  7 then Seek(f, 272) else
        if MID <  8 then Seek(f, 580) else
        if MID < 20 then Seek(f, SizeOf(TMandHeader9))
                    else Seek(f, SizeOf(TMandHeader10));
        TopAdr := FilePos(f);
    {    if MID < 19 then SetLength(SI4, j);
        if MID < 18 then
        begin
          SetLength(SI3, j);
          BlockRead(f, SI3[0], j * SizeOf(TsiLight3));
          PSI3 := @SI3[0];
          PSI4 := @SI4[0];
          for i := 1 to j do
          begin
            PSI4^ := PSI3^;
            Inc(PSI4);
            Inc(PSI3);
            PWord(PSI4)^ := 0;
            PSI4 := PInteger(Integer(PSI4) + 2);
            PSI4^ := PSI3^;
            Inc(PSI4);
            Inc(PSI3);
            PSI4^ := PSI3^;
            Inc(PSI4);
            Inc(PSI3);
            PWord(PSI4)^ := 0;
            PSI4 := PInteger(Integer(PSI4) + 2);
          end;
          SetLength(SI3, 0);
        end
        else if MID < 19 then BlockRead(f, SI4[0], j * SizeOf(TsiLight4));   }
 {
        if MID < 18 then SLsize := SizeOf(TsiLight3) else
        if MID < 19 then SLsize := SizeOf(TsiLight4) else
                         SLsize := SizeOf(TsiLight5);
        LineSize := SLsize * Header.Width;

        for ny := 0 to Height - 1 do
        begin
          pc := ScanLine[ny];
          yy := Round(ny * dy);
          YAdr := yy * LineSize + TopAdr;
          for nx := 0 to Width - 1 do
          begin
            xx := Round(nx * dx);
            Seek(f, YAdr + xx * SLsize);
            BlockRead(f, SL5, SLsize);
            if SLsize < 18 then     //convert type
            begin


            end;
            CalcPixelColorSvec(@SVcol, sdv, @SL5, @LightVals, @PaintParameter);
            pc^ := SVecToCol(SVcol);
            Inc(pc);
          end;
        end;
      {  if MID > 18 then
          BlockRead(f, Mand3DForm.siLight5[0], j * SizeOf(TsiLight5))
        else
          ConvertSiLight4To5(@SI4[0], @Mand3DForm.siLight5[0], j);

        if MID < 20 then
        begin
          PW := PWord(Integer(@Mand3DForm.siLight5[0]) + 10);  //@shadow
          if Header.bCalculateHardShadow > 0 then
          begin
            for i := 1 to j do
            begin
              PWord(Integer(PW) + 2)^ := PWord(Integer(PW) + 2)^ shr 1;
              PSmallint(Integer(PW) - 6)^ := -PSmallint(Integer(PW) - 6)^;
              if PW^ < 32767 then PW^ := $400 else PW^ := 0;
              Inc(PW, 9);
            end;
          end else begin
            for i := 1 to j do
            begin
              PWord(Integer(PW) + 2)^ := PWord(Integer(PW) + 2)^ shr 1;
              PSmallint(Integer(PW) - 6)^ := -PSmallint(Integer(PW) - 6)^;
              if PWord(Integer(PW) - 2)^ > 32767 then PW^ := 100 else
              PW^ := (32767 - (PW^ and $7FFF)) shr 5;
              Inc(PW, 9);
            end;
          end;
        end;   }

 {     finally
        CloseFile(f);
      end;
    //  Modified := true; 

    end
    else raise Exception.Create('Unable to open M3I file');
end;   }

initialization
  TPicture.RegisterFileFormat('M3I', '', TM3IGraphic);
  TPicture.RegisterFileFormat('M3C', '', TM3CGraphic);
  NoPreviewBMP := TBitMap.Create;
  NoPreviewBMP.PixelFormat := pf32bit;
  NoPreviewBMP.SetSize(153, 80);
  NoPreviewBMP.Canvas.FillRect(NoPreviewBMP.Canvas.ClipRect);
  NoPreviewBMP.Canvas.Font.Height := 20;
  NoPreviewBMP.Canvas.TextOut(38, 29, 'no preview');
finalization
  TPicture.UnregisterGraphicClass(TM3IGraphic);
  TPicture.UnregisterGraphicClass(TM3CGraphic);
  NoPreviewBMP.Free;
end.


