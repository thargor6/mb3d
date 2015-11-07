unit FileHandling;

interface

uses Windows, LightAdjust, SysUtils, Graphics, jpeg, TypeDefinitions, pngimage,
     SyncObjs, Classes, Controls, Dialogs, vcl.ExtDlgs;

procedure LoadFullM3I(var Header: TMandHeader11; Filename: String);
function LoadParameter(var Para11: TMandHeader11; FileName: String; Verbose: LongBool): Boolean;
//function LoadParsFromStream(var Para10: TMandHeader10; var Stream: TStream): Boolean;
procedure ConvertFromOldLightParas(var Light8: TLightingParas8; fSize: Integer);
procedure SaveJPEGfromBMP(FileName: String; bmp: TBitmap; Quality: Integer);
procedure SaveBMP(FileName: String; bmp: TBitmap; pf: TPixelFormat);
procedure SavePNG(FileName: String; bmp: TBitmap; SaveTXTparas: Boolean);
procedure CopyHeaderAsTextToClipBoard(para: TPMandHeader11; Titel: String);
function GetHeaderFromText(Text: AnsiString; var para: TMandHeader11; var Titel: String): LongBool;
procedure LoadAccPreset(nr: Integer);
procedure SaveAccPreset(nr: Integer);
function LoadColPreset(nr: Integer): Boolean;
procedure SaveColPreset(nr: Integer);
procedure LoadIni;
procedure SaveIni(ForceSave: LongBool);
procedure SetSaveDialogNames(Name: String);
function ConvertHeaderFromOldParas(var Para8: TMandHeader8; LoadFs: LongBool): LongBool;
procedure LoadHAddon(var f: file; HA: PTHeaderCustomAddon);
procedure UpdateLightVersion8(var Light8: TLightingParas8);
function ConvertColPreset16To20(P16: TPLpreset16): TLpreset20;
function ConvertColPreset164To20(var P164: TLpreset164): TLpreset20;
procedure ConvertLight8to9(Light8: TLightingParas8; var Light9: TLightingParas9);
procedure UpdateFormulaOptionTo20(PCFAddon: PTHeaderCustomAddon);
//function LoadBackgroundPic(FileName: String; Smooth, Convert2Spherical: LongBool): LongBool;
procedure Make8bitGreyscalePalette(var ABmp: TBitmap);
function GetLightParaFile(FileName: String; var LightParas: TLightingParas9; bKeepLights: LongBool): LongBool;
procedure UpdateFormulaOptionAbove20(var para: TMandHeader11);
procedure ParseExternFormulas(PCFAddon: PTHeaderCustomAddon);
function GetFileModDate(filename: string): TDatetime;
function LoadBackgroundPicT(Light: TPLightingParas9): Boolean;
procedure UpdateLightParasAbove3(var Light: TLightingParas9);
procedure StoreFavouriteStatus(formulaname: String; Status: Integer);
procedure SaveZBuf(FileName: String; stype: Integer); //stype: 0=png, 1=bmp
procedure SdoAA;
function GetDirectory(IniDir: String; AOwner: TWinControl): String;
procedure Save1bitPNG(FileName: String; bmp: TBitmap);
function ChangeFileExtSave(FileName, Ext: String): String;
function FileIsBigger1(Fname: String): LongBool;
procedure SaveBMP2FStream(FileName: String; bmp: TBitmap; pf: TPixelFormat; FS: TFileStream);
procedure SavePNG2FStream(FileName: String; bmp: TBitmap; FS: TFileStream);
procedure SaveJPEGfromBMP2FStream(FileName: String; bmp: TBitmap; Quality: Integer; FS: TFileStream);
procedure StoreHistoryPars(var pars: TMandHeader11);
procedure UpdatePresetFrom20(var p20: TLpreset20);
procedure ChangeFName(SaveDialog: TSaveDialog; FName: String);
procedure SetDialogName(SaveDialog: TSaveDialog; Name: String);  overload;
procedure SetDialogName(OpenDialog: TOpenDialog; Name: String);  overload;
procedure SetDialogName(OpenPicDialog: TOpenPictureDialog; Name: String);  overload;
procedure SetDialogDirectory(SaveDialog: TSaveDialog; FDir: String);  overload;
procedure SetDialogDirectory(OpenDialog: TOpenDialog; FDir: String);  overload;
procedure SetDialogDirectory(OpenPicDialog: TOpenPictureDialog; FDir: String);  overload;

var IniVal: array[0..34] of String = ('81','5','20','5','30','30','60','50','10', '3','0','0:0','','0','1','1','0','','',
      'No','No','Auto','','No','65 100','779 671','844 100','844 100','844 100','-1','No','Yes','','','0');
    IniDirs: array[0..11] of String = ('','','','','','','','','','','',''); //M3Idir, M3Pdir, BMPdir, FormulaDir, M3Adir, AniOut, BGpic, Lightparas, BigRenders, LightMaps, voxel, M3C
    IniHigherVersion: array of String;
    IniFileDate: TDateTime;
    HistoryFolder: String;
    ACCPresetFutureAddons: array[0..3] of array[0..4] of String;
    ACCaddedStrings: array[0..3] of Integer = (0,0,0,0);
    LastHisParSaveTime: TDateTime;
    LHPSLight: TLightingParas9;
const
    IniMax: Integer = 34;
    IniItem: array[0..34] of String = ('StickOption','MandRotDeg','NavSlideStep',
      'NavLookAngle','NavFarPlane','NavFOVy','NavMaxIts','AniFrameCount','AniPrevFPS',  //NavFarPlane not used anymore
      'AniSmoothPar','NaviAZERTY','UserAspect','M3LFolder','ImageSharp','NavFkey',
      'ScaleDEstop','SaveImagePNG','BigRendersFolder','LightMapsFolder','NavHiQ',
      'NavDoubleClickMode','ThreadCount','VoxelFolder','SavePNGtextPars','m3dPos',
      'm3dSize','FormulaPos','LightPos','PostpPos','ThreadPriority','DisableTBoost',
      'SaveImgInM3I','M3CFolder','Author','NaviPanelShow');
    AccPresetFileNames: array[0..3] of String = ('preset_preview.txt',
      'preset_video.txt', 'preset_mid.txt', 'preset_high.txt');
    AccPresetItemNames: array[0..7] of String = ('SmoothNormals', 'DEstop',
      'DEaccuracy', 'BinSearch', 'ImageWidth', 'ImageScale', 'RayStepFactor', 'RayLimiter');

  {$ifdef ENABLE_EXTENSIONS}
  actMandId: Integer = 45;
  {$else}
  actMandId: Integer = 44;
  {$endif}
  actLightId: Integer = 7;    //0..7 only!
  actLightIdEx: Integer = 8;  //Byte 0..255 new Lightversion
  actPresetVersion: Integer = 5;

implementation

uses Mand, ImageProcess, Clipbrd, DivUtils, Math, CustomFormulas, HeaderTrafos,
     Animation, FormulaGUI, Navigator, AniPreviewWindow, Interpolation, Tiling,
     Math3D, Forms, Maps, Undo;

function FileIsBigger1(Fname: String): LongBool;
var F: TSearchRec;
begin
    Result := (FindFirst(Fname, faAnyFile, F) = 0) and (F.Size > 1);
    FindClose(F);
end;

function ChangeFileExtSave(FileName, Ext: String): String;
var se: String;
const cExtToCh: String = '.BMP.PNG.JPG.JPE.TXT.JPEG.TIF.TIFF.BIG.M3A.M3P.M3I.M3L.M3V.M3C';
begin
    se := UpperCase(ExtractFileExt(FileName));
    if Pos(se, cExtToCh) > 0 then Result := ChangeFileExt(FileName, Ext) else
    if Ext > '' then
    begin
      if (Length(FileName) > 0) and (FileName[Length(FileName)] = '.') then
        Delete(FileName, Length(FileName), 1);
      Result := FileName + Ext;
    end
    else Result := FileName;
end;

function GetDirectory(IniDir: String; AOwner: TWinControl): String;
var OD: TOpenDialog;
begin
 {   Result := IniDir;
    SelectDirectory('Select a directory', ExtractFileDrive(IniDir), Result, [], AOwner);
    Result := IncludeTrailingPathDelimiter(Result); }
    OD := TOpenDialog.Create(AOwner);
    try
      OD.InitialDir := IniDir;
      OD.FileName := {IncludeTrailingPathDelimiter(IniDir) +} 'Go to folder and press open';
      if OD.Execute then
        Result := IncludeTrailingPathDelimiter(ExtractFileDir(OD.FileName))
      else Result := IniDir;
    finally
      OD.Free;
    end;
end;

procedure UpdateFormulaOptionAbove20(var para: TMandHeader11); //+header update
var i, j: Integer;
    d: Double;
    Q: TQuaternion;
    tmpFormula: THAformula;
const M3dBeta1796: Single = 1.796;
begin
    with PTHeaderCustomAddon(para.PCFAddon)^ do
    begin
      for i := 0 to MAX_FORMULA_COUNT - 1 do
      begin
        j := Formulas[i].iFnr;
        if (j = 5) and (Formulas[i].iOptionCount < 6) then //bulbox, added second r parameter
        begin
          Formulas[i].dOptionValue[5] := Formulas[i].dOptionValue[4];
          Formulas[i].byOptionType[5] := 9;
          Formulas[i].iOptionCount := 6;
        end;
      end;
    end;
    with para do
    begin
      ParseExternFormulas(PTHeaderCustomAddon(PCFAddon));
      if MandId < 21 then
      begin
        if mZstepDiv < s001 then mZstepDiv := s03;
        bPlanarOptic := 0;
      end;
      if MandId < 22 then
      begin
        byColor2Option := 0;
        dXWrot := 0;
        dYWrot := 0;
        dZWrot := 0;
        sColorMul := 1;
        dJw := 0;
        Light.TBoptions := (Light.TBoptions and $E07FFFFF) or (((Light.TBoptions and $1F000000) shr 1) or $10000000);
       //light.TBoptions  bit 24..29 Gamma 0..63 -> -32..31 = gamma 0.5..2        bit21-23version
      end;
      if MandId < 23 then sRaystepLimiter := 1;
      if MandId < 24 then
      begin
        StereoScreenWidth := 1;
        StereoScreenDistance := 2;
        StereoMinDistance := s05;
      end;
      if MandId < 25 then HSmaxLengthMultiplier := 1;
      if MandId < 26 then AODEdithering := 0;
      if MandId < 27 then
      begin
        SRamount := s05;
        SRreflectioncount := 1;
        bCalcSRautomatic := 0;
        byCalcNsOnZBufAuto := 0;
      end;
      if MandId < 28 then SSAORcount := 1;
      if MandId < 29 then
      begin
        sDOFclipR := 25;
        sDOFaperture := 0.02;
      end;
      if MandId < 30 then sDEAOmaxL := 1;
      if MandId < 31 then sDEcombS := s05;
      if MandId < 32 then sDOFZsharp2 := sDOFZsharp;
      if MandId < 33 then iMaxItsF2 := Iterations;
      if MandId < 34 then DEmixColorOption := 0;
      if MandId < 35 then
      begin
        TilingOptions := 0;
        bDFogIt := 0;
      end;
      if MandId < 36 then
      begin
        iAmbCalcTime := 0;
        bSSAO24BorderMirrorSize := 0;
        iOptions := iOptions and $7FFFFFFB;
      end;
      bStereoMode := 0;  //?
      if sM3dVersion = M3dBeta1796 then
      begin
        Light.Lights[2].FreeByte := 1;
        Light.Lights[3].AdditionalByteEx := 77;
        Light.Lights[0].AdditionalByteEx := 3;
      end;
      if MandId < 37 then
      begin
        sTransmissionAbsorption := 0.2;
        sTRIndex := 1.5;
      end;
      if MandId < 38 then sTRscattering := 1;
      if MandId < 39 then
      begin
        sFmixPow := 2;
        iReflectsCalcTime := 0;
      end;
      if MandId < 40 then
      begin
        MCSoftShadowRadius := SingleToShortFloat(1);
        MCDepth := 3;
        MCcontrast := 128;
        bCalc1HSsoft := 0;
        MCoptions := 2;  //secantmode
        MCdiffReflects := 0;
        iOptions := iOptions and $7FFFFFFD; //turn off Shortdistance check DE
      end;
      if MandId < 42 then
      with PTHeaderCustomAddon(para.PCFAddon)^ do
      begin
        bNewOptions := 0;
        MCoptions := MCoptions or 16;   //bokeh2
        bVolLightNr := Min(5, bVolLightNr);  //was: repeatfrom
        j := 5;
        while (j > 0) and (Formulas[j].iItCount = 0) do Dec(j);
        if bOptions1 <> 0 then bHybOpt1 := 0
                          else bHybOpt1 := j or (bVolLightNr shl 4); //end1, repeat1 2x 4bit
        bHybOpt2 := $151;
        if bOptions1 = 2 then //DEcomb
        begin
          bHybOpt2 := 1 or (j shl 4) or (Max(1, bVolLightNr) shl 8);  //start2, end2, repeat2    3x 4bit
          Formulas[0].iItCount := 1;
        //  if (bOptions3 = 5) and (Formula[0] = dIFS) then make alternating...
          if not (bOptions3 in [2,6]) then FlipInt(iMaxItsF2, Iterations);
        end
        else bOptions3 := 0;
        if bOptions3 in [2,6] then  //invmax: inv F1 and comb max;  Mix2: first F2..F6 then F1
        begin
          tmpFormula := Formulas[0];
          for i := 0 to j - 1 do Formulas[i] := Formulas[i + 1];
          Formulas[j] := tmpFormula;
          if bOptions3 = 6 then bOptions3 := 5;
          bHybOpt1 := Max(0, j - 1) or (Max(0, bVolLightNr - 1) shl 4); //end1, repeat1 2x 4bit
          bHybOpt2 := j or (j shl 4) or (j shl 8);     //start2, end2, repeat2    3x 4bit
        end;
      end;
      if MandId < 43 then
      begin
        bMCSaturation := 32;
        bColorOnIt := 0;
        if byColor2Option = 5 then bColorOnIt := 1 else
        if byColor2Option = 6 then byColor2Option := 5;
      end;
      if (MandId > 43) and ((bNewOptions and 1) <> 0) then
      begin  //change Quaternion back to RotationMatrix
        Q := TPQuaternion(@hVGrads)^;
        CreateMatrixFromQuat(hVGrads, Q);
        d := 2.1345 / (dZoom * Width);  //StepWidth, not needed in header!
        hVGrads := NormaliseMatrixTo(d, @hVGrads);
      end;
      if MandId < 44 then
      begin
        bVolLightNr := 2 shl 4;
      end;

      if MandId > 35 then Mand3DForm.OutMessage('The parameters were made with program version ' + ProgramVersionStr(sM3dVersion))
      else if MandId > actMandId then Mand3DForm.OutMessage('A correct rendering could be not possible.');
      sM3dVersion := M3dVersion;
    end;
end;

procedure UpdateLightParasAbove3(var Light: TLightingParas9);
var ver, verex, i: Integer;
    sv: TSVec;
begin
    with Light do
    begin
      verex := 0;
      ver := (TBoptions shr 20) and 7;
      if ver < 4 then
      begin
        DynFogCol2[0] := DynFogR;
        DynFogCol2[1] := DynFogG;
        DynFogCol2[2] := DynFogB;
      end;
      if ver < 5 then
      begin                                                     //TB6: 53 dynFog   TB14: 0 colVaronZ
        TBpos[6] := Max(0, Min(159, (TBpos[6] - 53) * 2 + 53)); //0..159
        VarColZpos := Max(-120, Min(360, VarColZpos * 2));      //-120..360
      end;
      if ver < 6 then
      begin
        bColorMap := 0;
        RoughnessFactor := 255;
        PicOffsetZ := (Integer(PicOffsetZ) + 128) and 255;
        for i := 0 to 5 do Lights[i].Loption := Lights[i].Loption and $FD;   // bit2: lightmap;  -> no lightmaps in earlier versions
      end;
      if ver < 7 then
      begin   //Double7 + byte for map>255, initiate mapnrEx to 0
        for i := 0 to 5 do
        begin
          Lights[i].LightMapNr := Lights[i].LightMapNr and $FF;
          Lights[i].AdditionalByteEx := 0;   //diffnr ex in Lights[1]
          Lights[i].FreeByte := 0;
        end;
      end
      else verex := Lights[0].AdditionalByteEx;
      TBoptions := (TBoptions and $FF8FFFFF) or (actLightId shl 20);
      if verex < 1 then
      begin
        Lights[0].FreeByte := 0;   //used for blend dynfog option (bit1)!
      end;
      if verex < 2 then
      begin
        Lights[2].AdditionalByteEx := 30;  //diffmap scaling
        Lights[1].FreeByte := (AdditionalOptions shr 1) and 1; //diffmap optionsEx=RG1.itemindex, here just "on normals"
        AdditionalOptions := AdditionalOptions and $FB;  // ((Ord(CheckBox18.Checked) and 1) shl 2); was: rel to object, now: comb y + col
      end;
      if verex < 3 then
      begin
        Lights[3].AdditionalByteEx := 128;  //amount of diffuse shadowing
        Lights[2].FreeByte := 0;            //iExModes
      end;
      if verex < 5 then
      begin
        // spec colors with transparency amount, ini with 0
        for i := 0 to 3 do ICols[i].Color := ICols[i].Color and $FFFFFF;
        for i := 0 to 9 do LCols[i].ColorSpe := (LCols[i].ColorSpe and $FFFFFF) or
          (MaxOfColor(LCols[i].ColorSpe) shl 24);
      end;
      if verex < 6 then
      begin
        i := (AdditionalOptions shr 4) and 7;
        if i <> 0 then i := 16;
        AdditionalOptions := (AdditionalOptions and $8F) or i;  //fit-border width on bg image load
    //    showmessage(IntToStr(Lights[0].Loption and 6)+','+IntToStr(Lights[1].Loption and 6));
        for i := 0 to 5 do if (Lights[i].Loption and 6) <> 4 then
          Lights[i].Lamp := Word(SingleToShortFloat(1));
        Lights[4].AdditionalByteEx := 40; //BGscale = power(1.04, abe - 40);
        for i := 0 to 3 do
        begin
          sv := ColToSVec(ICols[i].Color, False);
          ICols[i].Color := (ICols[i].Color and $FFFFFF) or (Round(YofSVec(@sv) * 255) shl 24);
        end;
      end;
      if verex < 7 then
      begin
        for i := 0 to 5 do Lights[i].LFunction := Lights[i].LFunction and $3F;
      end;
      if verex < 8 then
      begin
        Light.Lights[0].FreeByte := Light.Lights[0].FreeByte and 1;
        Light.Lights[3].FreeByte := 0;   //No col-ipol
      end;
      Lights[0].AdditionalByteEx := actLightIdEx;
    end;
end;

procedure CopyLights(srcLights, destLights: TP6Lights);
var b1, b2: array[0..5] of Byte;
    i: Integer;
begin
    for i := 0 to 5 do b1[i] := destLights[i].FreeByte;    //save+restore additional bytes that are not related to the lights
    for i := 0 to 5 do b2[i] := destLights[i].AdditionalByteEx;
    FastMove(srcLights^, destLights^, SizeOf(T6Lights));
    for i := 0 to 5 do destLights[i].FreeByte := b1[i];
    for i := 0 to 5 do destLights[i].AdditionalByteEx := b2[i];
end;

function GetLightParaFile(FileName: string; var LightParas: TLightingParas9; bKeepLights: LongBool): LongBool;
var f: file;
    tLight: TLightingParas8;
    Lights: T6Lights;   // Light sources 6*32=192 bytes
begin
    Result := False;
    if FileExists(FileName) then
    begin
      FastMove(LightParas.Lights, Lights, SizeOf(T6Lights));
      AssignFile(f, FileName);
      try
        Reset(f, 1);
        if FileSize(f) < SizeOf(LightParas) then
        begin
          BlockRead(f, tLight, Min(FileSize(f), SizeOf(tLight)));
          ConvertFromOldLightParas(tLight, FileSize(f));
          UpdateLightVersion8(tLight);
          ConvertLight8to9(tLight, LightParas);
        end
        else BlockRead(f, LightParas, Min(FileSize(f), SizeOf(LightParas)));
        UpdateLightParasAbove3(LightParas);
        if bKeepLights then CopyLights(@Lights, @LightParas.Lights);
        Result := True;
      finally
        CloseFile(f);
      end;
    end;
end;

procedure SetDialogDirectory(SaveDialog: TSaveDialog; FDir: String);  overload;
begin
    SaveDialog.FileName := ExtractFileName(SaveDialog.FileName);
    SaveDialog.InitialDir := FDir;
end;

procedure SetDialogDirectory(OpenDialog: TOpenDialog; FDir: String);  overload;
begin
    OpenDialog.FileName := ExtractFileName(OpenDialog.FileName);
    OpenDialog.InitialDir := FDir;
end;

procedure SetDialogDirectory(OpenPicDialog: TOpenPictureDialog; FDir: String);  overload;
begin
    OpenPicDialog.FileName := ExtractFileName(OpenPicDialog.FileName);
    OpenPicDialog.InitialDir := FDir;
end;

function ExtractFileDirSave(FName: String): String;
begin
    if Length(FName) = 0 then Result := '' else
    begin
      Result := ExtractFileDir(FName);
      if Result > '' then Result := IncludeTrailingPathDelimiter(Result);
    end;
end;

procedure ChangeFName(SaveDialog: TSaveDialog; FName: String);
var s: String;
begin
    s := ExtractFileDirSave(SaveDialog.FileName);
    if s > '' then SaveDialog.InitialDir := s;
    SaveDialog.FileName := {ExtractFileDirSave(SaveDialog.FileName) +} FName;
end;

procedure SetSaveDialogNames(Name: String);
var s: String;
begin
    s := ChangeFileExtSave(ExtractFileName(Name), '');
    with Mand3DForm do
    begin
      ChangeFName(SaveDialog1, s);
      ChangeFName(SaveDialog2, s);
      ChangeFName(SaveDialog3, s);
      ChangeFName(SaveDialog4, s);
      ChangeFName(SaveDialog6, s);
      ChangeFName(LightAdjustForm.SaveDialog1, s);
      Caption := s;
    end;
end;

procedure SetDialogName(SaveDialog: TSaveDialog; Name: String);  overload;
begin
    ChangeFName(SaveDialog, ChangeFileExtSave(ExtractFileName(Name), ''));
end;

procedure SetDialogName(OpenDialog: TOpenDialog; Name: String);  overload;
var s: String;
begin
    s := ExtractFileDirSave(OpenDialog.FileName);
    if s > '' then OpenDialog.InitialDir := s;
    OpenDialog.FileName := ChangeFileExtSave(ExtractFileName(Name), '');
end;

procedure SetDialogName(OpenPicDialog: TOpenPictureDialog; Name: String);  overload;
var s: String;
begin
    s := ExtractFileDirSave(OpenPicDialog.FileName);
    if s > '' then OpenPicDialog.InitialDir := s;
    OpenPicDialog.FileName := ChangeFileExtSave(ExtractFileName(Name), '');
end;

procedure StoreFavouriteStatus(formulaname: String; Status: Integer);
var M: TStringList;
    i: Integer;
    bNotFound: LongBool;
begin
    M := TStringList.Create;
    try
  //    M.LoadFromFile(AppDataDir + IncludeTrailingPathDelimiter('Formulas') + 'FavouriteList.txt');
      M.LoadFromFile(IncludeTrailingPathDelimiter(IniDirs[3]) + 'FavouriteList.txt');
    except
      M.Clear;
    end;
    bNotFound := True;
    for i := 1 to M.Count do
      if SameText(StrLastWords(M.Strings[i - 1]), formulaname) then
      begin
        if Status = 1 then
        begin
          M.Delete(i - 1);
          Break;
        end
        else M.Strings[i - 1] := IntToStr(Status) + ' ' + formulaname;
        bNotFound := False;
      end;
    if bNotFound then M.Add(IntToStr(Status) + ' ' + formulaname);
  //  M.SaveToFile(AppDataDir + IncludeTrailingPathDelimiter('Formulas') + 'FavouriteList.txt');
    M.SaveToFile(IncludeTrailingPathDelimiter(IniDirs[3]) + 'FavouriteList.txt');
    M.Clear;
    M.Free;
end;

function GetFileModDate(filename: string): TDatetime;
var F: TSearchRec;
    sysTime: TSystemTime;
begin
    if (FindFirst(filename, faAnyFile, F) = 0) and
      FileTimeToSystemTime(F.FindData.ftLastWriteTime, sysTime) then
        Result := SystemTimeToDateTime(sysTime)
    else
      Result := 0;
    FindClose(F);
end;

procedure StoreHistoryPars(var pars: TMandHeader11);
var tmpHF: String;
    dt: TDateTime;
    f: file;
begin        //todo: store last header+haddon, comparemem of both if changed then save ... +verify every 5 minutes (lighting+postpro changes)
  try
    dt := Now;
    tmpHF := IncludeTrailingPathDelimiter(HistoryFolder) + DateToStrHistory(dt);
    if not DirectoryExists(tmpHF) then CreateDir(tmpHF);
    tmpHF := IncludeTrailingPathDelimiter(tmpHF) + TimeToStrHistory(dt);
    if Mand3DForm.Caption <> 'Mandelbulb 3D' then tmpHF := tmpHF + ' ' + ChangeFileExt(Mand3DForm.Caption, '');
    tmpHF := tmpHF + '.m3p';
    try
      AssignFile(f, tmpHF);
      Rewrite(f, 1);
      InsertAuthorsToPara(@pars, Mand3DForm.Authors);
      try
        BlockWrite(f, pars, SizeOf(pars));
      finally
        Mand3DForm.IniMHeader;
      end;
      PTHeaderCustomAddon(pars.PCFAddon)^.bHCAversion := 16;
      BlockWrite(f, PTHeaderCustomAddon(pars.PCFAddon)^, SizeOf(THeaderCustomAddon));
    finally
      CloseFile(f);
    end;
    LastHisParSaveTime := Now;
  except
  end;
end;

procedure LoadIni;
var i: Integer;
    s, sa: String;
    f: TextFile;
    bFound, bCopyFile: LongBool;
begin
    SetLength(IniHigherVersion, 0);
    for i := 0 to high(IniDirs) do IniDirs[i] := AppFolder;
    IniDirs[1] := AppFolder + 'M3Parameter';
    IniDirs[3] := AppFolder + 'M3Formulas';
    IniDirs[8] := AppFolder + 'BigRenders';
    IniDirs[9] := AppFolder + 'M3Maps';
    //new: local ini in appdata folder:
    s := AppFolder + 'Mandelbulb3D.ini';
    bCopyFile := False;
    HistoryFolder := AppFolder + 'History';
    if not DirectoryExists(HistoryFolder) then CreateDir(HistoryFolder);
    sa := AppDataDir + 'Mandelbulb3D.ini';
    if (not FileExists(s)) and FileExists(sa) then
    begin
      if MessageDlg('The m3d Ini-file is now stored in the application folder.' + #13#10 +
        'Do you want to copy the existing Ini-file from the appdata folder?' + #13#10 +
        'Note: If you want a completly new installation and access the folders' + #13#10 +
        'in the applications directory, select "No"', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        s := sa; //AppDataDir + 'Mandelbulb3D.ini';
        bCopyFile := True;
      end;
    end;
    if FileExists(s) then
    begin
      AssignFile(f, s);
      try
        IniFileDate := GetFileModDate(s);
        Reset(f);
        for i := 0 to 5 do Readln(f, IniDirs[i]);
        if not EOF(f) then Readln(f, IniDirs[6]);
        while not EOF(f) do
        begin
          bFound := False;
          Readln(f, s);
          for i := 0 to IniMax do
          if StrFirstWord(s) = IniItem[i] then
          begin
            IniVal[i] := StrLastWords(s);
            bFound := True;
            Break;
          end;
          if (not bFound) and (Length(Trim(s)) > 3) and (Length(IniHigherVersion) < 100) then
          begin
            SetLength(IniHigherVersion, Length(IniHigherVersion) + 1);
            IniHigherVersion[Length(IniHigherVersion) - 1] := s;
          end;
        end;
      finally
        CloseFile(f);
      end;
      if bCopyFile then
      begin
        CopyFile(PChar(AppDataDir + 'Mandelbulb3D.ini') , PChar(AppFolder + 'Mandelbulb3D.ini'), True);
        if FileExists(AppDataDir + IncludeTrailingPathDelimiter('Formulas') + 'FavouriteList.txt') then
          CopyFile(PChar(AppDataDir + IncludeTrailingPathDelimiter('Formulas') + 'FavouriteList.txt') ,
                   PChar(IncludeTrailingPathDelimiter(IniDirs[3]) + 'FavouriteList.txt'), True);
      end;
      if IniVal[12] <> '' then IniDirs[7] := IniVal[12];
      if IniVal[17] <> '' then IniDirs[8] := IniVal[17];
      if IniVal[18] <> '' then IniDirs[9] := IniVal[18];
      if IniVal[22] <> '' then IniDirs[10] := IniVal[22];
      if IniVal[32] <> '' then IniDirs[11] := IniVal[32];
      if not CheckAuthorValid(IniVal[33]) then IniVal[33] := '';
    end;
end;

procedure SaveIni(ForceSave: LongBool);
var i: Integer;
    f: TextFile;
    s: String;
begin
    s := AppFolder + 'Mandelbulb3D.ini';
    if (not ForceSave) and (IniFileDate < GetFileModDate(s)) then Exit;
    AssignFile(f, s);
    try
      IniVal[12] := IniDirs[7]; //m3l paras folder
      IniVal[17] := IniDirs[8]; //BigRenders folder
      IniVal[18] := IniDirs[9]; //LightMaps folder
      IniVal[22] := IniDirs[10]; //voxel folder
      IniVal[32] := IniDirs[11]; //m3c folder
      Rewrite(f);
      for i := 0 to 6 do Writeln(f, IniDirs[i]);
      for i := 0 to IniMax do
      begin
        if i = 0 then
          s := IntToStr(FormsSticky[1] +
                     (Mand3DForm.bAniFormStick shl 2) +
                     (FormsSticky[0] shl 4) +
                     (FormsSticky[2]) shl 6)
        else if i = 1 then s := Mand3DForm.Edit4.Text
        else if i = 23 then
        begin
          if Mand3DForm.CheckBox13.Checked then s := 'Yes' else s := 'No';
        end
        else if i = 30 then
        begin
          if Mand3DForm.CheckBox14.Checked then s := 'Yes' else s := 'No';
        end
        else if i = 31 then
        begin
          if Mand3DForm.CheckBox16.Checked then s := 'Yes' else s := 'No';
        end
        else s := IniVal[i];
        Writeln(f, IniItem[i] + '  ' + s);
      end;
      for i := 0 to Length(IniHigherVersion) - 1 do
        Writeln(f, IniHigherVersion[i]);
    finally
      CloseFile(f);
    end;
end;

procedure UpdatePresetFrom20(var p20: TLpreset20);
var i: Integer;
begin
    with p20 do
    begin
      if Version < 4 then
      begin
        for i := 0 to 5 do if (Lights[i].Loption and 6) <> 2 then
          Lights[i].Lamp := Word(SingleToShortFloat(1));
      end;
      if Version < 5 then Lights[3].FreeByte := 0;
      Version := actPresetVersion;
    end;
end;

function ConvertColPreset16To20(P16: TPLpreset16): TLpreset20;
var i: Integer;
begin
    with Result do
    begin
      if P16.Version = 0 then
      begin
        AmbCol  := InterpolateColorB(P16.Cols[3], P16.Cols[6], P16.Cols[9], 0.3333, 0.3333, 0.3333) or $FF000000;
        AmbCol2 := AmbCol or $FF000000;
      end else begin
        AmbCol  := P16.Cols[3] or $FF000000;
        AmbCol2 := P16.Cols[6] or $FF000000;
      end;
      DepthCol  := P16.DepthCol or $FF000000;
      DepthCol2 := P16.DepthCol2;
      for i := 0 to 2 do TB578pos[i] := P16.TB578pos[i];
      Version := 3;
      for i := 0 to 2 do
      begin
        LCols[i].Position := i * 10922;
        LCols[i].ColorDif := P16.Cols[i * 3 + 1];
        LCols[i].ColorSpe := P16.Cols[i * 3 + 2];
        ICols[i].Position := i * 10922;
        ICols[i].Color    := P16.Cols[i * 3 + 1];
      end;
      for i := 3 to 9 do
      begin
        LCols[i] := LCols[0];
        LCols[i].Position := 32200 + (i - 3) * 84;
      end;
      ICols[3] := ICols[0];
      ICols[3].Position := 32700;
      for i := 0 to 5 do Lights[i] := defaultLight8;
      for i := 0 to 3 do
      begin
        Lights[i].Loption   := P16.Lights[i].Loption;
        Lights[i].LFunction := P16.Lights[i].LFunction;
        Lights[i].Lcolor    := CardinalToRGB(P16.Lights[i].Lcolor);
        Lights[i].LightMapNr := 0;
        Lights[i].LXpos     := DoubleToD7B(P16.Lights[i].LXangle * Pid16384);
        Lights[i].LYpos     := DoubleToD7B(P16.Lights[i].LYangle * Pid16384);
      end;
      UpdatePresetFrom20(Result);
    end;
end;

function ConvertColPreset164To20(var P164: TLpreset164): TLpreset20;
var i: Integer;
begin
    with Result do
    begin
      AmbCol  := P164.AmbTop or $FF000000;
      AmbCol2 := P164.AmbBot or $FF000000;
      DepthCol  := P164.DepthCol or $FF000000;
      DepthCol2 := P164.DepthCol2;
      for i := 0 to 2 do TB578pos[i] := P164.TB578pos[i];
      Version := 3;
      for i := 0 to 3 do
      begin
        LCols[i].Position := i * 8191;
        LCols[i].ColorDif := P164.ColDif[i];
        LCols[i].ColorSpe := P164.ColSpec[i];
        ICols[i].Position := i * 8191;
        ICols[i].Color    := P164.ColDif[i];
      end;
      for i := 4 to 9 do
      begin
        LCols[i] := LCols[0];
        LCols[i].Position := 32200 + (i - 3) * 84;
      end;
      for i := 0 to 5 do Lights[i] := defaultLight8;
      for i := 0 to 1 do
      begin
        Lights[i].Loption   := P164.Lights[i].Loption;
        Lights[i].LFunction := P164.Lights[i].LFunction;
        Lights[i].Lcolor    := CardinalToRGB(P164.Lights[i].Lcolor);
        Lights[i].LightMapNr := 0;
        Lights[i].LXpos     := DoubleToD7B(P164.Lights[i].LXangle * Pid16384);
        Lights[i].LYpos     := DoubleToD7B(P164.Lights[i].LYangle * Pid16384);
      end;
      UpdatePresetFrom20(Result);
    end;
end;

function LoadColPreset(nr: Integer): Boolean;
var s: String;
    f: File;
    i: Integer;
    tP: TLpreset16;
begin
    Result := False;
    s := AppDataDir + 'color_preset_' + IntToStr(nr + 1) + '.bin';
    if FileExists(s) then
    begin
      AssignFile(f, s);
      try
        Reset(f, 1);
        if FileSize(f) < SizeOf(TLpreset20) then
        begin
          tP.Version := 0;
          if FileSize(f) = SizeOf(TLpreset14) then
          begin
            BlockRead(f, tP, SizeOf(TLpreset14));
            tP.DepthCol2 := tP.DepthCol;
          end
          else if FileSize(f) = SizeOf(TLpreset15) then
            BlockRead(f, tP, SizeOf(TLpreset15))
          else BlockRead(f, tP, SizeOf(TLpreset16));
          if FileSize(f) < SizeOf(TLpreset16) then
            for i := 0 to 3 do tP.Lights[i].LFunction :=
              (tP.Lights[i].LFunction and 3) or
              ((tP.Lights[i].LFunction shl 2) and $30);
          CustomPresets[nr + 6] := ConvertColPreset16To20(@tP);        
        end
        else BlockRead(f, CustomPresets[nr + 6], SizeOf(TLpreset20));
        UpdatePresetFrom20(CustomPresets[nr + 6]);
        Result := True;
      finally
        CloseFile(f);
      end;
    end;
end;

procedure SaveColPreset(nr: Integer); //0..9 = CustomPresets[6..15]
var s: String;
    f: File;
begin
    s := AppDataDir + 'color_preset_' + IntToStr(nr + 1) + '.bin';
    AssignFile(f, s);
    try
      Rewrite(f, 1);
      CustomPresets[nr + 6].Version := actPresetVersion;
      BlockWrite(f, CustomPresets[nr + 6], SizeOf(TLpreset20));
    finally
      CloseFile(f);
    end;
end;

procedure LoadAccPreset(nr: Integer);
var s: String;
    i: Integer;
    f: TextFile;
    P1: PInteger;
begin
    s := AppDataDir + AccPresetFileNames[nr];
    if FileExists(s) then
    begin
      AssignFile(f, s);
      Reset(f);
      try
        P1 := PInteger(@AccPreset[nr].SmoothNormals);
        for i := 0 to 5 do
        begin
          Readln(f, s);
          Delete(s, 1, Length(AccPresetItemNames[i]) + 1);
          if i = 1 then
          begin
            PDouble(P1)^ := StrToFloatK(s);
            Inc(P1);
          end
          else P1^ := StrToIntTrim(s);
          Inc(P1);
        end;
        if not EOF(f) then Readln(f, s) else s := '';
        if Length(s) > 14 then
        begin
          Delete(s, 1, Length(AccPresetItemNames[6]) + 1);
          AccPreset[nr].RayMultiplier := StrToFloatK(s);
        end
        else
        begin
          i := Max(2, Pinteger(@AccPreset[nr].RayMultiplier)^);
          AccPreset[nr].RayMultiplier := 2.2 / (i + 0.25 * Sqr(i));
        end;
        if not EOF(f) then
        begin
          Readln(f, s);
          Delete(s, 1, Length(AccPresetItemNames[7]) + 1);
          AccPreset[nr].RayLimiter := StrToFloatK(s);
        end;
        ACCaddedStrings[nr] := 0;
        while not EOF(f) do
        begin
          if ACCaddedStrings[nr] < 5 then
          begin
            Readln(f, ACCPresetFutureAddons[nr, ACCaddedStrings[nr]]);
            Inc(ACCaddedStrings[nr]);
          end;
        end;
      finally
        CloseFile(f);
      end;
    end;
end;

procedure SaveAccPreset(nr: Integer);
var s: String;
    i: Integer;
    f: TextFile;
    P1: PInteger;
begin
    s := AppDataDir + AccPresetFileNames[nr];
    AssignFile(f, s);
    Rewrite(f);
    try
      P1 := PInteger(@AccPreset[nr].SmoothNormals);
      for i := 0 to 5 do
      begin
        s := AccPresetItemNames[i] + ' ';
        if i = 1 then
        begin
          s := s + FloatToStr(PDouble(P1)^);
          Inc(P1);
        end                                                             
        else if i = 2 then s := s + IntToStr(Round(Sqrt(8.8 / AccPreset[nr].RayMultiplier + 4) - 2))
        else s := s + IntToStr(P1^);
        Inc(P1);
        Writeln(f, s);
      end;
      Writeln(f, AccPresetItemNames[6] + ' ' + FloatToStrSingle(AccPreset[nr].RayMultiplier));
      Writeln(f, AccPresetItemNames[7] + ' ' + FloatToStrSingle(AccPreset[nr].RayLimiter));
      for i := 0 to ACCaddedStrings[nr] - 1 do Writeln(f, ACCPresetFutureAddons[nr, i]);
    finally
      CloseFile(f);
    end;  
end;

function MakeTextparas(para: TPMandHeader11; Titel: String): AnsiString;
var PB: PByte;
    i, n: Integer;
    p: TP6;
begin
    SaveHeaderPointers(para, p);
    InsertAuthorsToPara(para, Mand3DForm.Authors);
    try
      Result := 'Mandelbulb3Dv18{' + #13#10;
      PB := @para.MandId;
      for i := 1 to 280 do  //280 * 3 = 840
      begin
        Result := Result + ThreeBytesTo4Chars(PB);
        if (i mod 20) = 0 then Result := Result + #13#10;
        Inc(PB, 3);
      end;
    finally
      InsertHeaderPointers(para, p);
    end;
    PB := PByte(para.PCFAddon);
    PTHeaderCustomAddon(PB).bHCAversion := 16;  //HaddonVersion
    if (PTHeaderCustomAddon(PB).bOptions1 and 3) = 1 then n := 1 else
    begin
      n := -1;
      for i := 0 to 5 do
        if PTHeaderCustomAddon(PB).Formulas[i].iItCount > 0 then n := i;
    end;
    PTHeaderCustomAddon(PB).iFCount := n + 1;
    for i := 1 to ((n + 1) * SizeOf(THAformula) + 10) div 3 do
    begin
      Result := Result + ThreeBytesTo4Chars(PB);
      if (i mod 20) = 0 then Result := Result + #13#10;
      Inc(PB, 3);
    end;
    Result := Result + '}' + #13#10 + '{Titel: ' + Titel + '}' + #13#10;
end;

procedure CopyHeaderAsTextToClipBoard(para: TPMandHeader11; Titel: String);
begin
    Clipboard.SetTextBuf(PWideChar(String(MakeTextparas(para, Titel))));
end;

function AnsiCopy(Text: AnsiString; Offset, Count: Integer): AnsiString;
var l: Integer;
begin
    Result := '';
    l := Length(Text);
    if Offset < 1 then Offset := 1 else if Offset > l then Offset := l;
    if Offset + Count > l + 1 then Count := l - Offset + 1;
    if Count < 1 then Exit;
    for l := 0 to Count - 1 do Result := Result + Text[Offset + l];
end;

function GetHeaderFromText(Text: AnsiString; var para: TMandHeader11; var Titel: String): LongBool;
var i, c, j, n, nup, l: Integer;
    ver: Single;
    PB: PByte;
    s: AnsiString;
    tmpHeader8: TMandHeader8;
    tmpHeader10: TMandHeader11;
begin
    Result := False;
    Titel := '';
    n  := 1;
    while n <= Length(Text) do  //empty chars or 3-dot chars replacement
    begin
      if Text[n] = '}' then Break;
      if Text[n] = ' ' then Delete(Text, n, 1) else
      if Ord(Text[n]) = 133 then
      begin
        Text[n] := '.';
        Insert('..', Text, n); //not ansi?
        Inc(n, 2);
      end
      else Inc(n);
    end;
    n  := 0;
    i  := 1;
    ver := 14;
    s  := '';
    l  := Length(Text);
    while (i <= l) and (Text[i] <> '{') do
    begin
      if Text[i] in ['.', '0'..'9'] then s := s + Text[i]
      else s := '';
      Inc(i);
    end;
    if Length(s) > 0 then if not TryStrToFloat(s, ver) then ver := 13;
    Inc(i);
    if (i < 30) and (i < l) then
    begin
      if ver < 16 then
      begin
        PB := @tmpHeader8.MandId;
        nup := 703;
      end else begin
        PB := @tmpHeader10.MandId;
        nup := 839;
      end;
      repeat
        while Ord(Text[i]) < 20 do Inc(i);
        if FourCharsTo3Bytes(AnsiCopy(Text, i, 4), c) then
        for j := 1 to 3 do
        begin
          PB^ := c and $FF;
          c   := c shr 8;
          Inc(PB);
        end;
        Inc(i, 4);
        Inc(n, 3);
        if (ver < 16) and (n > 701) then Dec(PB, 2);
      until (n > nup) or (l <= i);

      if ver < 16 then
      begin
        FastMove(para.sDEcombS, tmpHeader8.PCustomF, 32);
        Result := ConvertHeaderFromOldParas(tmpHeader8, True);
        FastMove(tmpHeader8, tmpHeader10, SizeOf(TMandHeader8));
        ConvertLight8to9(tmpHeader8.Light, tmpHeader10.Light);
      end
      else Result := True;
      with tmpHeader10 do Result := Result and (Width > 0) and (Width < 32768) and
                                    (Height > 0) and (Height < 32768);
      if Result then
      begin
        Mand3DForm.Authors := ExtractAuthorsFromPara(@tmpHeader10);
        tmpHeader10.PCFAddon := para.PCFAddon;
        AssignHeader(@para, @tmpHeader10);
        if ver > 14 then                            //HAddon: 8 bytes + 6 * 188 bytes
        begin
          PB := para.PCFAddon;
          ResetFormulas(para.PCFAddon);
          n := 0;
          while (n < SizeOf(THeaderCustomAddon)) and (l > i) and not (Text[i] in ['}','{']) do
          begin
            while (Ord(Text[i]) < 20) and (l > i) do Inc(i);
            if FourCharsTo3Bytes(AnsiCopy(Text, i, 4), c) then
            for j := 1 to 3 do
            begin
              if n < SizeOf(THeaderCustomAddon) then PB^ := c and $FF;
              c := c shr 8;
              Inc(PB);
              Inc(n);
            end;
            Inc(i, 4);
          end;
        end;
        if para.MandId < 20 then UpdateFormulaOptionTo20(PTHeaderCustomAddon(para.PCFAddon));
        UpdateFormulaOptionAbove20(para);  //must be before iniCFs
        UpdateLightParasAbove3(para.Light);
        IniCFsFromHAddon(para.PCFAddon, para.PHCustomF);
        s := '';
        Dec(i, 3);
        while (i <= l) and (Text[i] <> '{') do Inc(i);
        if i >= l then Exit;
        if Copy(Text, i, 8) = '{Titel: ' then
        begin
          Inc(i, 8);
          j := i;
          while (i <= l) and (not (Text[i] in ['}', #10, #13])) do Inc(i);
          Titel := Copy(Text, j, Min(48, i - j));
        end;
        if Titel <> '' then SetSaveDialogNames(Titel);
      end;
    end;
    if Titel = '' then Titel := 'Mandelbulb3D';
end;

procedure SdoAA;
var tp: TPoint;
begin
    if ImageScale in [2..3] then
    begin
      Mand3DForm.getI1BMPSLs;
      tp := GetTileSize(@Mand3DForm.MHeader);
      doAA(mFSIstart, I1BMPstartSL, mFSIoffset, I1BMPoffset,
           tp.X div ImageScale, tp.Y div ImageScale,
           ImageScale, StrToInt(Mand3DForm.Label23.Caption));
    end;
end;

procedure Make8bitGreyscalePalette(var ABmp: TBitmap);
type TFullPalette = array[0..255] of Longint;
var Stream   : TMemoryStream;
    Bfh      : PBitmapFileHeader;
    Bih      : PBitmapInfoHeader;
    PalCount : LongInt;
    p        : PByte;
    APal     : TFullPalette;
    x        : Integer;
begin
    Stream := TMemoryStream.Create;
    try
      ABmp.SaveToStream(Stream);
      p   := Stream.Memory;
      Bfh := PBitmapFileHeader(p);        // FileHeader
      if Bfh^.bfType <> $4D42 then Exit;  // is Bitmap?
      Inc(p, SizeOf(TBitmapFileHeader));
      Bih := PBitmapInfoHeader(p);        // get InfoHeader
      Inc(p, SizeOf(TBitmapInfoHeader));
      with Bih^ do
      begin
        if biSize <> SizeOf(TBitmapInfoHeader) then Exit;    // is InfoHeader?
        case biBitCount of
          1, 4, 8: PalCount := 1 shl biBitCount;
          else PalCount := 0;
        end;
      end;
      for x := 0 to 255 do APal[x] := x or (x shl 8) or (x shl 16);
      FastMove(APal, P^, PalCount * SizeOf(TRGBQuad));
      Stream.Seek(0, soFromBeginning);
      ABmp.LoadFromStream(Stream);
    finally
      Stream.free;
    end;
end;

procedure SaveBMP(FileName: String; bmp: TBitmap; pf: TPixelFormat);
var tmpBMP: TBitmap;
begin
    tmpBMP := TBitmap.Create;
    try
      tmpBMP.Assign(bmp);
      tmpBMP.PixelFormat := pf;
   //   if pf = pf8Bit then Make8bitGreyscalePalette(tmpBMP);
      tmpBMP.SaveToFile(ChangeFileExtSave(FileName, '.bmp'));
   //   if pf <> pf8Bit then SetSaveDialogNames(FileName);
    finally
      tmpBMP.Free;
    end;
end;

procedure SaveBMP2FStream(FileName: String; bmp: TBitmap; pf: TPixelFormat; FS: TFileStream);
var tmpBMP: TBitmap;
begin
    tmpBMP := TBitmap.Create;
    try
      tmpBMP.Assign(bmp);
      tmpBMP.PixelFormat := pf;
      tmpBMP.SaveToStream(FS);
    finally
      tmpBMP.Free;
    end;
end;

procedure SavePNG(FileName: String; bmp: TBitmap; SaveTXTparas: Boolean);
var// tmpPNG: TPngImage;
    tmpPNG: TPNGObject;
    s: AnsiString;
begin
  //  tmpPNG := TPngImage.Create;           // some PNG options: AddzTXt,  CreateAlpha, COLOR_GRAYSCALE, BitDepth = 1
    tmpPNG := TPNGObject.Create;
    try
      tmpPNG.Assign(bmp);
 //     tmpPNG.Bitmap.Assign(bmp);
 //     tmpPNG.Bitmap.PixelFormat := pf24bit;
      tmpPNG.CompressionLevel := 5;
      if SaveTXTparas then
      begin   //insert textparams, read in gimp with image information->comment
        s := MakeTextparas(@Mand3DForm.MHeader, Mand3DForm.Caption);
        tmpPNG.AddtEXt('Comment', s);
      end;
      tmpPNG.SaveToFile(ChangeFileExtSave(FileName, '.png'));
    finally
      tmpPNG.Free;
    end;
end;

procedure SavePNG2FStream(FileName: String; bmp: TBitmap; FS: TFileStream);
var //tmpPNG: TPngImage;
    tmpPNG: TPNGObject;
begin
 //   tmpPNG := TPngImage.Create;
    tmpPNG := TPNGObject.Create;
    try
      tmpPNG.Assign(bmp);
      tmpPNG.CompressionLevel := 5;
      tmpPNG.SaveToStream(FS);
    finally
      tmpPNG.Free;
    end;
end;

procedure Save1bitPNG(FileName: String; bmp: TBitmap);
var pal: PLogPalette;
    hpal: HPALETTE;
 //   tmpPNG: TPngImage;
    tmpPNG: TPNGObject;
    tmpBMP: TBitmap;
    i: Integer;
begin
 //   tmpPNG := TPngImage.Create;
    tmpPNG := TPNGObject.Create;
    tmpBMP := TBitmap.Create;
    try
      tmpBMP.Assign(bmp);
      GetMem(pal, sizeof(TLogPalette) + sizeof(TPaletteEntry));
      pal.palVersion := $300;
      pal.palNumEntries := 2;
      for i := 0 to 1 do
      begin
        pal.palPalEntry[i].peRed := i * 255;
        pal.palPalEntry[i].peGreen := i * 255;
        pal.palPalEntry[i].peBlue := i * 255;
      end;
      hpal := CreatePalette(pal^);
      if hpal <> 0 then tmpBMP.Palette := hpal;
      tmpBMP.PixelFormat := pf1bit;
  //    tmpBMP.Canvas.CopyRect(tmpBMP.Canvas.ClipRect, bmp.Canvas, bmp.Canvas.ClipRect);
    {  SysPal.lpal.palVersion := $300;
      SysPal.lpal.palNumEntries := 2;
      PCardinal(@SysPal.palEntries[0])^ := 0;
      PCardinal(@SysPal.palEntries[1])^ := $FFFFFF;
      tmpPNG.Palette := CreatePalette(SysPal.lpal);  }      //  AddzTXt,  CreateAlpha, COLOR_GRAYSCALE, BitDepth = 1
      tmpPNG.Assign(tmpBMP);
      tmpPNG.CompressionLevel := 5;
      tmpPNG.SaveToFile(ChangeFileExtSave(FileName, '.png'));
    finally
      tmpPNG.Free;
      tmpBMP.Free;
      FreeMem(pal);
    end;
end;

function CalcJpegSize(BMP: TBitmap; comp: Integer): Integer;
var jpg:    TJPEGimage;
    stream: TMemoryStream;
begin
    jpg    := TJPEGimage.Create;
    stream := TMemoryStream.Create;
    try
      jpg.Assign(BMP);
      jpg.ProgressiveEncoding := False;
      jpg.CompressionQuality  := comp;
      jpg.SaveToStream(stream);
      Result := stream.Size div 1024;
    finally
      stream.Free;
      jpg.Free;
    end;
end;

function calcMaxQualForSize(BMP: TBitmap; Size: Integer): Integer;
var cmin, cmax, s: Integer;
begin
    cmin   := 0;
    cmax   := 101;
    Result := 50;
    repeat
      s := CalcJpegSize(BMP, Result);
      if s > Size then cmax := Result else
      if s < Size then cmin := Result else Break;
      Result := (cmax + cmin) div 2;
    until cmax < cmin + 2;
end;

procedure SaveJPEGfromBMP(FileName: String; bmp: TBitmap; Quality: Integer);
var JPG: TJPEGImage;
    qtmp: Integer;
begin
    qtmp := Quality;
    if Quality > 100 then
    begin
      Screen.Cursor := crHourGlass;
      try
        Quality := calcMaxQualForSize(bmp, Quality);
      finally
        Screen.Cursor := crDefault;
      end;
    end;
    JPG := TJPEGImage.Create;
    try
      JPG.Assign(bmp);
      JPG.CompressionQuality := Quality;
      JPG.SaveToFile(ChangeFileExtSave(FileName, '.jpg'));
      SetSaveDialogNames(FileName);
    finally
      JPG.Free;
    end;
    if (qtmp > 100) and (AnimationForm.AniOption < 1) then
      ShowMessage('JPEG saved with quality: ' + IntToStr(Quality));
end;

procedure SaveJPEGfromBMP2FStream(FileName: String; bmp: TBitmap; Quality: Integer; FS: TFileStream);
var JPG: TJPEGImage;
    qtmp: Integer;
begin
    qtmp := Min(100, Quality);
    JPG := TJPEGImage.Create;
    try
      JPG.Assign(bmp);
      JPG.CompressionQuality := qtmp;
      JPG.SaveToStream(FS);
    finally
      JPG.Free;
    end;
end;

procedure SaveZBuf(FileName: String; stype: Integer);
var tbmp: TBitmap;
    TileRect: TRect;
    Crop: Integer;
begin
    tbmp := TBitmap.Create;
    try
      tbmp.PixelFormat := pf8Bit;
      if Mand3DForm.MHeader.TilingOptions <> 0 then
      begin
        GetTilingInfosFromHeader(@Mand3DForm.MHeader, TileRect, Crop);
        tbmp.SetSize((TileRect.Right - TileRect.Left + 1 - Crop * 2) div ImageScale,
          (TileRect.Bottom - TileRect.Top + 1 - Crop * 2) div ImageScale);
        tbmp.Canvas.CopyRect(Rect(0, 0, tbmp.Width, tbmp.Height), Mand3DForm.Image1.Picture.Bitmap.Canvas,
             Rect(Crop div ImageScale, Crop div ImageScale,
                  Crop div ImageScale + tbmp.Width, Crop div ImageScale + tbmp.Height));
      end
      else tbmp.SetSize(Mand3DForm.Image1.Picture.Width, Mand3DForm.Image1.Picture.Height);
      Make8bitGreyscalePalette(tbmp);
      MakeZbufBMP(tbmp); 
      if stype = 1 then
        SaveBMP(ChangeFileExtSave(Filename, '.bmp'), tbmp, pf8bit)
      else
        SavePNG(ChangeFileExtSave(Filename, '.png'), tbmp, False);
    finally
      tbmp.Free;
    end;
end;

procedure ConvertFromOldLightParas(var Light8: TLightingParas8; fSize: Integer);
var i: Integer;
begin
    if fSize < SizeOf(TLightingParas7) then
    begin
      for i := 0 to 3 do Light8.Lights[i] := defaultLight7;
      Light8.Lights[0].Loption := 0;
      Light8.Lights[0].LFunction := (Light8.TBoptions and $FF);
      Light8.Lights[0].LXangle := Round(Light8.TBpos[1] * -32768 / 360);
      Light8.Lights[0].LYangle := Round(Light8.TBpos[2] * 32768 / 360);
    end;
    UpdateLightVersion8(Light8);
end;

procedure Convert4to7paras(para4: TMandHeader4; var para8: TMandHeader8);
begin
    FastMove(para4.MandId, para8.MandId, 108); //up to Light
    FastMove(para4.Light.TBpos[1], para8.Light.TBpos[1], SizeOf(TLightingParas));
    FastMove(para4.dFOVy, para8.dFOVy, 72);
    ConvertFromOldLightParas(para8.Light, 92);
    para8.sDEstop := (((para4.iOptions shr 10) and 15) + 1) * 0.2;
end;
 {   NormalX:    SmallInt; // 3 normals
    NormalY:    SmallInt;
    NormalZ:    SmallInt;
    RoughZposFine: Word;  // 1 Byte Roughness + 1 Byte LSB Zpos for more precision
    Zpos:       Word;
    Shadow:     Word;     // DEcount 10bit + 6 Light HS only yes/no
    AmbShadow:  Word;
    SIgradient: Word;     // Smoothed Iteration gradient for coloring
    OTrap:      Word;     // coloring on OrbitTrap  }

procedure ConvertSiLight4To5(PSL4: TPsiLight4; PSL5: TPsiLight5; n: Integer);
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
end;

procedure UpdateLightVersion8(var Light8: TLightingParas8);
var i, v, n: Integer;
    w1, w2: Double;
begin
    Light8.TBpos[3] := $800080;
    Light8.TBpos[6] := 53;
    v := (Light8.TBoptions shr 20) and $7; //Lversion
    if v < 2 then  
    begin
      if v < 1 then
      begin
        w1 := Light8.TBpos[5];  //5-diff  8-amb
        w2 := Light8.TBpos[5] + Light8.TBpos[8];
        if w2 < 1 then w2 := 1;
        w1 := w1 / w2;
        w2 := 1 - w1;
        for i := 0 to 2 do   //average Diff cols with Amb cols
          Light8.Cols[i * 3 + 1] := InterpolateColor(Light8.Cols[i * 3 + 1],
                                      Light8.Cols[i * 3 + 3], w1, w2);
      end;
      for i := 0 to 2 do
      begin
        Light8.LCols[i].Position := i * 10922;
        Light8.LCols[i].ColorDif := Light8.Cols[i * 3 + 1];   //1-4-7
        Light8.LCols[i].ColorSpe := Light8.Cols[i * 3 + 2];   //2-5-8
        Light8.ICols[i].Position := i * 10922;
        Light8.ICols[i].Color    := Light8.Cols[i * 3 + 1];
      end;
      if (Light8.TBoptions and $4000) > 0 then n := 0 else n := 2;
      for i := 3 to 9 do
      begin
        Light8.LCols[i] := Light8.LCols[n];
        Light8.LCols[i].Position := 32200 + (i - 3) * 84;
      end;
      Light8.ICols[3] := Light8.ICols[n];
      Light8.ICols[3].Position := 32760;

      if v < 1 then
      begin   //calc 2 ambFrontColors of avrg amb colors
        Light8.Cols[3] := InterpolateColorB(Light8.Cols[3], Light8.Cols[6], Light8.Cols[9], 0.33333, 0.33333, 0.33333);
        Light8.Cols[6] := Light8.Cols[3];
        Light8.Cols[9] := Light8.Cols[3];
        //correct diffuse amount when new ambient amount is low?
      end;
      if v < 1 then                            //7F0FFFFF  $20000 is bColorOnOrbitTrap  $40000 is farFog
        Light8.TBoptions := (Light8.TBoptions and $3F09FFFF) or (2 shl 20)
      else
        Light8.TBoptions := (Light8.TBoptions and $3F0FFFFF) or (2 shl 20);  //light version = 2
    end;  
end;

{   TLightingParas9 = packed record
    TBpos: array[1..11] of Integer;   // TBpos[2] ShortInt BGShadow;  TBpos[1]->ambCol[10]? -> Var col on Zpos! -1..3
    TBoptions:           Integer;     // 1-7.bit TB12pos; 8-14.bit TB13pos = interior col pos;  bit 15 = color cycling; bit 16 = HScalculated; bit17 = fineAdjDown
    TBfineColAdjust:     Cardinal;    // 2 bytes for 2 positions + 2 byte for depthcol2         bit 21..26 = Lversion?; bit 18 = Col on OTrap; bit19 = FarFog
    AmbCol, AmbCol2:     Cardinal;    //
    DepthCol, DepthCol2: Cardinal;    // 17*4 = 68 bytes til here
    Lights: array[0..5] of TLight8;   // Light sources                    6*14=84  152 bytes
    LCols: array[0..9] of TLCol8;     // Surface colors   100 bytes  (10 new cols with pos on palette, only spec and diff)
    ICols: array[0..3] of TICol8;     // Interior colors   24 bytes  (4 new cols)  276 bytes
    BGbmp: array[0..23] of Byte;      // Background image filename upto24chars     300 bytes
  end;                               
  TLightingParas8 = packed record
    TBpos: array[1..11] of Integer;   // TBpos[2] ShortInt BGShadow;  TBpos[1]->ambCol[10]? -> Var col on Zpos! -1..3
    TBoptions: Integer;               // 1-7.bit TB12pos; 8-14.bit TB13pos = interior col pos;  bit 15 = color cycling; bit 16 = HScalculated; bit17 = fineAdjDown
    TBfineColAdjust: Cardinal;        // 2 bytes for 2 positions + 2 byte for depthcol2         bit 21..26 = Lversion?; bit 18 = Col on OTrap; bit19 = FarFog
    DepthCol: Cardinal;               //56byte                                  
    Cols: array[1..9] of Cardinal;    // Object Cols    (old paras)  (->9 new ambient cols?)       #92byte   or only 2 new ambient front colors!
    Lights: array[0..3] of TLight7;   // Light sources                                     4*14=56 #148byte
    LCols: array[0..9] of TLCol8;     // Surface colors   100 bytes  (10 new cols with pos on palette, only spec and diff)
    ICols: array[0..3] of TICol8;     // Interior colors   24 bytes  (4 new cols)                  #272byte
  end;                                // + make lookup tables for colors 0..32767    }
procedure ConvertLight8to9(Light8: TLightingParas8; var Light9: TLightingParas9);
var i, j: Integer;
begin
    FastMove(Light8, Light9, 48);
    with Light9 do
    begin
      TBoptions := Light8.TBoptions or (3 shl 20);
      FineColAdj1 := Light8.TBfineColAdjust and $FF;
      FineColAdj1 := (Light8.TBfineColAdjust shr 8) and $FF;
      PicOffsetX := 128;
      PicOffsetY := 128;
      PicOffsetZ := 128;
      AmbCol    := CardinalToRGB(Light8.Cols[3]); 
      AmbCol2   := CardinalToRGB(Light8.Cols[6]);
      DepthCol  := CardinalToRGB(Light8.DepthCol shr 8);
      DepthCol2 := CardinalToRGB(((Light8.DepthCol and $FF) shl 16) or (Light8.TBfineColAdjust shr 16));
      DynFogR := 255;
      DynFogG := 255;
      DynFogB := 255;
      DynFogCol2 := CardinalToRGB($FFFFFF);
      for i := 0 to 5 do Lights[i] := defaultLight8;
      for i := 0 to 3 do
      begin
        Lights[i].Loption   := Light8.Lights[i].Loption;
        Lights[i].LFunction := Light8.Lights[i].LFunction;
        Lights[i].Lcolor    := CardinalToRGB(Light8.Lights[i].Lcolor);
        Lights[i].LightMapNr := 0;
        Lights[i].LXpos     := DoubleToD7B(Light8.Lights[i].LXangle * Pid16384);
        Lights[i].LYpos     := DoubleToD7B(Light8.Lights[i].LYangle * Pid16384);
      end;
      FastMove(Light8.LCols, LCols, 124);
      BGbmp[0] := 0;

      i := Max(0, Sqr(TBpos[10] + 30));
      j := Max(0, Sqr(TBpos[9] + 30));
      if (TBoptions and $10000) > 0 then
      begin  //fine down
        TBpos[10] := Round(Sqrt(Max(0, i + i - j)) - 30);    //TB9=start TB10=endpos Objcol
        i := FineColAdj1;
        j := FineColAdj2;
        FineColAdj1 := (i div 2) + 15;
        FineColAdj2 := Max(0, Min(255, j - (j - i) div 4));
      //  TBfineColAdjust := (TBfineColAdjust and $FFFF0000) or
       //   ((i div 2) + 15) or (Max(0, Min(255, j - (j - i) div 4)) shl 8);
      end
      else
      begin
        TBpos[10] := Round(Sqrt(Max(0, i + ((i - j) * 7) div 4)) - 30);  //i + ((i - Light.TBpos[9]) * 7) div 4;
      end;
      i := Sqr(Sqr(TBoptions and 127));         //TB12
      j := Sqr(Sqr((TBoptions shr 7) and 127)); //TB13 icol end
      j := Round(Sqrt(Sqrt(Max(0, j + ((j - i) * 7) div 4))));
      if j > 120 then j := 120 else if j < 0 then j := 0;

      TBoptions := ((TBoptions) and $3FC07F) or (j shl 7); //  and $3FFFFF: Gamma = 1
      VarColZpos := VarColZpos * 2;
      TBpos[4] := TBpos[4] * 2;
    end;
end;

procedure ResetHybrid(Header: TMandHeader8);
var i: Integer;
begin
    with Header do
    begin
      for i := 0 to 2 do
      begin
        dHPow[i] := 8;  //=scale in box
        dHZmul[i] := -1;
        dHMinR[i] := 0.5;
        iHcount[i] := 0;
        iHformula[i] := 0;
      end;
      iHcount[0] := 1;
    end;
end;

function ConvertHeaderFromOldParas(var Para8: TMandHeader8; LoadFs: LongBool): LongBool;
var i, j, Fnr: Integer;
    s: AnsiString;
    p: array[0..6] of Pointer;
const
    cF: array[0..15] of Integer = (2,2,0,0,1,1,3,3,0,4,5,6,7,8,14,15);
    aF: array[0..8] of Integer = (0,0,2,2,3,3,4,4,20);
    nF: array[0..11] of Integer = (0,1,2,3,-1,4,-1,-1,5,-1,6,20);
begin
  with Para8 do
  begin
    Result := (Width > 0) and (Width < 32768) and (Height > 0) and (Height < 32768);
    if Result then
    begin
      for i := 0 to 5 do p[i] := PHCustomF[i];
      p[6] := PCFAddon;
      if MandId < 4 then bCalcAmbShadowAutomatic := 1;
      if MandId < 7 then
      begin
        bIsJulia := 0;
        dJx := 0;
        dJy := 0;
        dJz := 0;
      end;
      if MandId < 8 then
      begin
        ConvertFromOldLightParas(Para8.Light, 148);
        sBBmulBulb  := 1;
        sBBRbulb    := 2;
        bImageScale := ImageScale;
        if bHScalculated = 0 then
          Light.TBpos[6] := (Light.TBpos[6] - 53) div 3 + 53;
        i := iOptions and 15;
        iOptions := (iOptions and $7FFFFFE0) or cF[i];
        if i in [3, 8] then dZmul := -1 else dZmul := 1;
        if i in [0, 1, 6, 7] then
          iOptions := (iOptions and $3FFFF) or ((i and 1) shl 18);
        if i in [2, 3, 8] then
          iOptions := (iOptions and $3FFFF) or ((Integer(i > 3) * 6) shl 18);
      end
      else ImageScale := Min(10, Max(1, bImageScale));
      Fnr := iOptions and 31;
      if MandId < 9 then
      begin
        dMinR := 0.5;
        if ((Fnr = 5) and (((iOptions shr 18) and 4) > 0)) or
           ((Fnr = 8) and (((iOptions shr 18) and 3) = 1)) then
          dMinR := 0.25;
        ResetHybrid(Para8);
      end;
      if MandId < 10 then CustomFname[0] := 0;
      if MandId < 11 then
      begin
    //    sDEcolVar := 0.521;
        bVaryDEstopOnFOV := Byte(True);
      end;
      if MandId < 12 then
      begin
        dCutX := sCutX;
        dCutY := sCutY;
        dCutZ := sCutZ;
        if Fnr = 9 then RStop := 1024;
        if sAmbShadowThreshold < s0001 then sAmbShadowThreshold := 3;
      end;
      if MandId < 13 then
      begin
        dCustomOption1 := dPow;
        Light.TBpos[2] := CalcBackgroundShadow;  //not used anymore
      end;
      if MandId < 15 then
      begin
        Light.TBoptions := (Light.TBoptions shr 4) or (Light.TBfineColAdjust and $10000);
        Light.TBfineColAdjust := (Light.TBfineColAdjust and $FFFF) or
                                 ((Light.DepthCol and $FFFF) shl 16);
        Light.DepthCol := (Light.DepthCol shl 8) or ((Light.DepthCol shr 16) and $FF);
         // v := (Light8.TBoptions shr 20) and $7; //Lversion
      end;

      for i := 0 to 5 do PHCustomF[i] := p[i];

      PCFAddon := p[6];
      if MandId < 16 then
      begin
        for i := 0 to 3 do Light.Lights[i].LFunction :=
          (Light.Lights[i].LFunction and 3) or ((Light.Lights[i].LFunction shl 2) and $F0);

        s := CustomFtoStr(CustomFname);
        PTHeaderCustomAddon(PCFAddon).bHCAversion := 1;    //write off... stream read m3i
        PTHeaderCustomAddon(PCFAddon).bOptions1 := 0;
        PTHeaderCustomAddon(PCFAddon).bOptions2 := 0;
        PTHeaderCustomAddon(PCFAddon).iFCount := 1;
        for i := 1  to 5 do
        begin
          PTHeaderCustomAddon(PCFAddon).Formulas[i].iItCount := 0;
          PTHeaderCustomAddon(PCFAddon).Formulas[i].iFnr := -1;
        end;
        for j := 0  to 4 do PTHeaderCustomAddon(PCFAddon).Formulas[0].byOptionType[j] := 0;
        PTHeaderCustomAddon(PCFAddon).Formulas[0].iFnr := nf[Min(11, Fnr)];
        PTHeaderCustomAddon(PCFAddon).Formulas[0].iItCount := 1;
        if Fnr = 9 then  //alt hybrid nach addon parsen
        begin
          for i := 0  to 2 do
          begin
            for j := 0  to 4 do PTHeaderCustomAddon(PCFAddon).Formulas[i].byOptionType[j] := 0;
            PTHeaderCustomAddon(PCFAddon).Formulas[i].iItCount := iHcount[i];
            PTHeaderCustomAddon(PCFAddon).Formulas[i].iFnr := af[Max (0, Min(8, iHformula[i]))];
            if (iHcount[i] > 0) then
            begin
              PTHeaderCustomAddon(PCFAddon).Formulas[i].dOptionValue[0] := dHPow[i];
              PTHeaderCustomAddon(PCFAddon).Formulas[i].dOptionValue[1] := dHZmul[i];
              case PTHeaderCustomAddon(PCFAddon).Formulas[i].iFnr of
                2:  if iHformula[i] = 2 then                                                 //Quat
                         PTHeaderCustomAddon(PCFAddon).Formulas[i].dOptionValue[0] := 1
                    else PTHeaderCustomAddon(PCFAddon).Formulas[i].dOptionValue[0] := -1;
                3:  if iHformula[i] = 4 then                                                 //Tric
                    begin
                      PTHeaderCustomAddon(PCFAddon).Formulas[i].dOptionValue[0] := -2;
                      PTHeaderCustomAddon(PCFAddon).Formulas[i].dOptionValue[1] := 1;
                    end else begin
                      PTHeaderCustomAddon(PCFAddon).Formulas[i].dOptionValue[0] := 2;
                      PTHeaderCustomAddon(PCFAddon).Formulas[i].dOptionValue[1] := 0;
                    end;
                4:  begin  //Box
                      PTHeaderCustomAddon(PCFAddon).Formulas[i].dOptionValue[0] := dHPow[i];
                      PTHeaderCustomAddon(PCFAddon).Formulas[i].dOptionValue[1] := dHMinR[i];
                      PTHeaderCustomAddon(PCFAddon).Formulas[i].byOptionType[1] := 7; //MinR = type .BOXSCALE
                    end;
              end;
              if (iHformula[i] > 7) then  //extern
              begin
                FastMove(CustomFname, PTHeaderCustomAddon(PCFAddon).Formulas[i].CustomFname, 16);
                Result := (not LoadFs) or LoadCustomFormulaFromHeader(PTHeaderCustomAddon(PCFAddon).Formulas[i].CustomFname,
                  PTCustomFormula(PHCustomF[i])^, PTHeaderCustomAddon(PCFAddon).Formulas[i].dOptionValue);
                if not Result then Break;
                PTHeaderCustomAddon(PCFAddon).Formulas[i].dOptionValue[0] := dCustomOption1;
                PTHeaderCustomAddon(PCFAddon).Formulas[i].dOptionValue[1] := dZmul;
                PTHeaderCustomAddon(PCFAddon).Formulas[i].dOptionValue[2] := dMinR;
                PTHeaderCustomAddon(PCFAddon).Formulas[i].iFnr := 20; //FormulaGUIForm.ExternFormulaNr(CustomFname);
              end;
            end;
          end;
        end   //not alt
        else if Fnr = 11 then  //extern f
        begin
          FastMove(CustomFname, PTHeaderCustomAddon(PCFAddon).Formulas[0].CustomFname[0], 16);
          Result := (not LoadFs) or LoadCustomFormulaFromHeader(PTHeaderCustomAddon(PCFAddon).Formulas[0].CustomFname,
            PTCustomFormula(PHCustomF[0])^, PTHeaderCustomAddon(PCFAddon).Formulas[0].dOptionValue);
          if Result then
          begin
            PTHeaderCustomAddon(PCFAddon).Formulas[0].dOptionValue[0] := dCustomOption1;
            PTHeaderCustomAddon(PCFAddon).Formulas[0].dOptionValue[1] := dZmul;
            PTHeaderCustomAddon(PCFAddon).Formulas[0].dOptionValue[2] := dMinR;
            PTHeaderCustomAddon(PCFAddon).Formulas[0].iFnr := 20;//FormulaGUIForm.ExternFormulaNr(CustomFname);
          end;
        end
        else
        begin
          i := PTHeaderCustomAddon(PCFAddon).Formulas[0].iFnr;
          if i >= 0 then GetHAddOnFromInternFormula(@para8, i, 0); 
          PTHeaderCustomAddon(PCFAddon).Formulas[0].dOptionValue[0] := dPow;
          PTHeaderCustomAddon(PCFAddon).Formulas[0].dOptionValue[1] := dZmul;
          i := (iOptions shr 18) and 7;
          case Fnr of
        0, 10:  begin
                  PTHeaderCustomAddon(PCFAddon).Formulas[0].dOptionValue[0] := i + 2;  //int/foldingint
                  if Fnr = 10 then PTHeaderCustomAddon(PCFAddon).Formulas[0].dOptionValue[2] := sBBRbulb; //Rfold
                end;
            2:  PTHeaderCustomAddon(PCFAddon).Formulas[0].dOptionValue[0] := 1 - (i and 1) * 2; //quat
            3:  begin //tricorn
                  PTHeaderCustomAddon(PCFAddon).Formulas[0].dOptionValue[0] := (i and 1) * 4 - 2;
                  PTHeaderCustomAddon(PCFAddon).Formulas[0].dOptionValue[1] := 1 - (i and 1);
                end;
            4:  PutStringInCustomF(CustomFname, '_SinePow2');
         5, 8:  begin   //Box
                  PTHeaderCustomAddon(PCFAddon).Formulas[0].dOptionValue[1] := dMinR;
                  if Fnr = 8 then                                    //Bulbox Minr05/025,Alt
                  begin
                    PTHeaderCustomAddon(PCFAddon).Formulas[0].dOptionValue[2] := Max(0, sBBmulBulb);
                    PTHeaderCustomAddon(PCFAddon).Formulas[0].dOptionValue[3] := Max(0, sBBRbulb);
                  end;
                end;
            6:  PutStringInCustomF(CustomFname , 'Riemann');
            7:  PutStringInCustomF(CustomFname , 'Fuzzy');
          end;
          if Fnr in [4, 6, 7] then  //load extern formulas
          begin
            s := CustomFtoStr(CustomFname);
            FastMove(CustomFname, PTHeaderCustomAddon(PCFAddon).Formulas[0].CustomFname, 16);
            Result := (not LoadFs) or LoadCustomFormulaFromHeader(CustomFname, PTCustomFormula(PHCustomF[0])^,
                        PTHeaderCustomAddon(PCFAddon).Formulas[0].dOptionValue);
            if Result then
            with PTHeaderCustomAddon(PCFAddon)^ do
            begin
              Formulas[0].iFnr := 20; //FormulaGUIForm.ExternFormulaNr(CustomFname);
              Formulas[0].dOptionValue[0] := dPow;
              Formulas[0].dOptionValue[1] := 1 - 2 * (i and 1);  //fuzzy: power +  ymultiply 1/-1
              if Fnr = 4 then  //xyz to althybrid parsen...      read of @ programstart?
              begin  //load also additional  _SinePow2, IntP2, MaxClip
                Formulas[0].dOptionValue[0] := 1;
                Formulas[0].dOptionValue[1] := 1;
                Formulas[0].iOptionCount := 2;
                FastMove(CustomFname, PTHeaderCustomAddon(PCFAddon).Formulas[1].CustomFname, 16);
                if LoadFs then LoadCustomFormulaFromHeader(CustomFname,
                           PTCustomFormula(PHCustomF[1])^, Formulas[1].dOptionValue);
                Formulas[1].iFnr := Formulas[0].iFnr;
                Formulas[1].iItCount := 1;
                Formulas[1].dOptionValue[0] := 1 - ((i shr 1) and 1) * 2;
                Formulas[1].dOptionValue[1] := 1;
                Formulas[1].iOptionCount := 2;
                if LoadFs then ParseCFfromOld(0, PTCustomFormula(PHCustomF[2]), Formulas[2].dOptionValue);
                Formulas[2].iFnr := 0;
                Formulas[2].iItCount := 1;
                Formulas[2].dOptionValue[0] := 2;  //Int power
                Formulas[2].dOptionValue[1] := 1 - (i and 1) * 2;
                Formulas[2].iOptionCount := 2;
           //     CFdescriptions[2] := CFdescriptionIntern[0];
                // + maxclip...
              end;
            end;
          end;
      
        end;
     //   if not Result then
       //   Showmessage('The extern formula ''' + s + ''' is not available');

      end;
      if MandId < 17 then
      begin
        CalcVGradsFromHeader8rots(@Para8);
      end;
      if MandId < 18 then
      begin
        Light.TBpos[1] := 0;
        PByte(Integer(@Para8)+ 343)^ := 0;  //byRepeatFrom
      end;
      if MandId < 20 then
      begin
        UpdateLightVersion8(Light);

        PByte(Integer(@Para8) + 181)^ := 0;      // bCalcDOF   := 0;
        PInteger(Integer(@Para8) + 164)^ := 0;   // sDOFZsharp := 0;
        PSingle(Integer(@Para8) + 168)^ := 5;    // sDOFradius := 5;
        PSingle(Integer(@Para8) + 172)^ := s05;  // sDOFosize := 0.5
        PInteger(Integer(@Para8) + 327)^ := 0;   // iCalcHStime := 0;    +323 = iCalcTime

        if bCalculateHardShadow > 0 then bCalculateHardShadow := 5;
        bHScalculated := bHScalculated or bCalculateHardShadow;
        PByte(Integer(@Para8) + 132)^ := 0;      //bNormalsOnDE := 0;

        i := Max(2, ((iOptions shr 14) and 15) + 1);  //DEaccuracy   2..16
        PSingle(Integer(@Para8) + 182)^ := 2.2 / (i + 0.25 * Sqr(i)); //  mZstepDiv
        Para8.sDEcolVar := 0;   // =sNaviMinDist
      end;
    end;
  end;
end;

procedure LoadHAddon10(var f: file; HA: PTHeaderCustomAddon10);
var i, t: Integer;
    HAold: THeaderCustomAddonOld;
begin
    t := FilePos(f);
    BlockRead(f, i, 4);
    Seek(f, t);
    if not ((i and $FF) in [16..99]) then
    begin
      BlockRead(f, HAold, SizeOf(THeaderCustomAddonOld));
      for i := 0 to 5 do
      with HA.Formulas[i] do
      begin
        iItCount := HAold.iItCounts[i];
        iFnr := HAold.iFormula[i];
        FastMove(HAold.CustomFname[i], CustomFname, 32);
        for t := 0 to 15 do dOptionValue[t] := HAold.dOptionValues[i][t];
      end;
    end
    else BlockRead(f, HA^, SizeOf(THeaderCustomAddon10));   //read beyond eof
end;

procedure LoadHAddon(var f: file; HA: PTHeaderCustomAddon);
var i, t: Integer;
    HAold: THeaderCustomAddonOld;
begin
    t := FilePos(f);
    BlockRead(f, i, 4);
    Seek(f, t);
    if not ((i and $FF) in [16..99]) then
    begin
      BlockRead(f, HAold, SizeOf(THeaderCustomAddonOld));
      for i := 0 to 5 do
      with HA.Formulas[i] do
      begin
        iItCount := HAold.iItCounts[i];
        iFnr := HAold.iFormula[i];
        FastMove(HAold.CustomFname[i], CustomFname, 32);
        for t := 0 to 15 do dOptionValue[t] := HAold.dOptionValues[i][t];
      end;
    end
    else BlockRead(f, HA^, SizeOf(THeaderCustomAddon));   //read beyond eof
end;

procedure LoadHAddonFromStream(Stream: TStream; HA: PTHeaderCustomAddon);
var i, j: Integer;
    t: Int64;
    HAold: THeaderCustomAddonOld;
begin
    t := Stream.Position;
    Stream.Read(i, 4);
    Stream.Seek(t, soBeginning);
    if not ((i and $FF) in [16..99]) then
    begin
      Stream.Read(HAold, SizeOf(THeaderCustomAddonOld));
      for i := 0 to 5 do
      with HA.Formulas[i] do
      begin
        iItCount := HAold.iItCounts[i];
        iFnr := HAold.iFormula[i];
        FastMove(HAold.CustomFname[i], CustomFname, 32);
        for j := 0 to 15 do dOptionValue[j] := HAold.dOptionValues[i][j];
      end;
    end
    else Stream.Read(HA^, SizeOf(THeaderCustomAddon));
end;

procedure LoadHAddon10FromStream(Stream: TStream; HA: PTHeaderCustomAddon10);
var i, j: Integer;
    t: Int64;
    HAold: THeaderCustomAddonOld;
begin
    t := Stream.Position;
    Stream.Read(i, 4);
    Stream.Seek(t, soBeginning);
    if not ((i and $FF) in [16..99]) then
    begin
      Stream.Read(HAold, SizeOf(THeaderCustomAddonOld));
      for i := 0 to 5 do
      with HA.Formulas[i] do
      begin
        iItCount := HAold.iItCounts[i];
        iFnr := HAold.iFormula[i];
        FastMove(HAold.CustomFname[i], CustomFname, 32);
        for j := 0 to 15 do dOptionValue[j] := HAold.dOptionValues[i][j];
      end;
    end
    else Stream.Read(HA^, SizeOf(THeaderCustomAddon10));
end;

procedure ParseExternFormulas(PCFAddon: PTHeaderCustomAddon);
var i, j: Integer;
    s: AnsiString;
begin
    with PCFAddon^ do
      for i := 0 to MAX_FORMULA_COUNT -1 do if Formulas[i].iFnr > 19 then
      begin
        s := UpperCase(CustomFtoStr(Formulas[i].CustomFname));
        if s = '_AMAZINGBOXFSSE2' then
        begin
          PutStringInCustomF(Formulas[i].CustomFname, '_AmazingBoxSSE2');
        end
        else if s = 'AMAZINGBOXF' then
        begin
          Formulas[i].iFnr := 4;
          PutStringInCustomF(Formulas[i].CustomFname, 'Amazing Box');
        end
        else if (s = 'TRAFASSELQUAT') and CanLoadF('CommQuat') then
          PutStringInCustomF(Formulas[i].CustomFname, 'CommQuat')
        else if (s = '_FLIPXY') and CanLoadF('_FlipXYc') then
        begin
          PutStringInCustomF(Formulas[i].CustomFname, '_FlipXYc');
          Formulas[i].dOptionValue[0] := 0;
        end
        else if (s = '_FLIPXZ') and CanLoadF('_FlipXZc') then
        begin
          PutStringInCustomF(Formulas[i].CustomFname, '_FlipXZc');
          Formulas[i].dOptionValue[0] := 0;
        end
        else if (s = '_FLIPYZ') and CanLoadF('_FlipYZc') then
        begin
          PutStringInCustomF(Formulas[i].CustomFname, '_FlipYZc');
          Formulas[i].dOptionValue[0] := 0;
        end
        else if (s = 'ABOXMODKALIFIXED') and CanLoadF('ABoxModKali') then
        begin
          PutStringInCustomF(Formulas[i].CustomFname, 'ABoxModKali');
          for j := 2 to 4 do
            Formulas[i].dOptionValue[j] := Formulas[i].dOptionValue[j + 1];
          Formulas[i].iOptionCount := 5;
        end;
      end;
end;

procedure UpdateFormulaOptionTo20(PCFAddon: PTHeaderCustomAddon);
var i, j: Integer;
begin
    with PCFAddon^ do
    begin
      for i := 0 to 5 do
      begin
        j := Formulas[i].iFnr;
        if j = 2 then
        begin
          Formulas[i].dOptionValue[1] := 0; //quat w add
          Formulas[i].byOptionType[1] := 0;
        end
        else if j in [4, 5] then
        begin
          Formulas[i].iOptionCount := 3;
          if j = 5 then
          begin
            Formulas[i].dOptionValue[4] := Formulas[i].dOptionValue[3];
            Formulas[i].dOptionValue[3] := Formulas[i].dOptionValue[2];
            Formulas[i].byOptionType[3] := 0;
            Formulas[i].byOptionType[4] := 9;
            Formulas[i].iOptionCount := 5;
          end;
          Formulas[i].dOptionValue[2] := 1; //box fold
          Formulas[i].byOptionType[2] := 11;
        end;
      end;
  //    ParseExternFormulas(PCFAddon);
    end;
end;

function LoadBackgroundPicT(Light: TPLightingParas9): Boolean;
var s: AnsiString;
    bSmooth, bConvToSpherical: LongBool;
    iFitB: Integer;
begin
    if Light.BGbmp[0] <> 0 then
    begin
      s := GetStringFromLightFilename(Light.BGbmp);
      bSmooth := (Light.TBoptions and $80000) <> 0;
      bConvToSpherical := (Light.AdditionalOptions and $80) <> 0;
      iFitB := Light.AdditionalOptions and 16;
      if not LoadLightMap(M3DBackGroundPic, IncludeTrailingPathDelimiter(IniDirs[6]) + s, bSmooth, bConvToSpherical, True, iFitB) then
      begin
        if not LoadLightMap(M3DBackGroundPic, IncludeTrailingPathDelimiter(IniDirs[9]) + s, bSmooth, bConvToSpherical, True, iFitB) then
        begin
          if not LoadLightMap(M3DBackGroundPic, IncludeTrailingPathDelimiter(IniDirs[2]) + s, bSmooth, bConvToSpherical, True, iFitB) then
          begin
            Mand3DForm.OutMessage('The background picture: ' + s +
              ' could not be loaded. Put it in the picture directory specified with the "INI DIRS" button.');
            Light.BGbmp[0] := 0;
          end;
        end;
      end;
    end;
    Result := Light.BGbmp[0] <> 0;
    if Result then M3DBackGroundPic.LMnumber := 66000 else FreeLightMap(@M3DBackGroundPic);
end;

function LoadParameter(var Para11: TMandHeader11; FileName: String; Verbose: LongBool): Boolean;
var f: file;
    d: Double;
    MId, i: Integer;
    p: TP6;
    MandHeader4: TMandHeader4;
    para9: TMandHeader9;
    para10: TMandHeader10;
    TileSize: TPoint;

   procedure FillV11AddonFromV10(const Src: TMandHeader10; var Dst: TMandHeader11);
   var
     I: Integer;
     SrcAddOn: PTHeaderCustomAddon10;
     DstAddon: PTHeaderCustomAddon;
   begin
     SrcAddOn := PTHeaderCustomAddon10(Src.PCFAddon);
     DstAddon := PTHeaderCustomAddon(Dst.PCFAddon);
     DstAddOn^.bHCAversion := SrcAddOn^.bHCAversion;
     DstAddOn^.bOptions1 := SrcAddOn^.bOptions1;
     DstAddOn^.bOptions2 := SrcAddOn^.bOptions2;
     DstAddOn^.bOptions3 := SrcAddOn^.bOptions3;
     DstAddOn^.iFCount := SrcAddOn^.iFCount;
     DstAddOn^.bHybOpt1 := SrcAddOn^.bHybOpt1;
     DstAddOn^.bHybOpt2 := SrcAddOn^.bHybOpt2;
     for I := 0 to V18_FORMULA_COUNT - 1  do
       DstAddOn^.Formulas[I] := SrcAddOn^.Formulas[I];
   end;

   procedure FillV11HeaderFromV10(const Src: TMandHeader10; var Dst: TMandHeader11);
   var
     I: Integer;
   begin
     Dst.MandId := Src.MandId;
     Dst.Width := Src.Width;
     Dst.Height := Src.Height;
     Dst.Iterations := Src.Iterations;
     Dst.iOptions := Src.iOptions;
     Dst.bNewOptions := Src.bNewOptions;
     Dst.bColorOnIt := Src.bColorOnIt;
     Dst.dZstart := Src.dZstart;
     Dst.dZend := Src.dZend;
     Dst.dXmid := Src.dXmid;
     Dst.dYmid := Src.dYmid;
     Dst.dZmid := Src.dZmid;
     Dst.dXWrot := Src.dXWrot;
     Dst.dYWrot := Src.dYWrot;
     Dst.dZWrot := Src.dZWrot;
     Dst.dZoom := Src.dZoom;
     Dst.RStop := Src.RStop;
     Dst.iReflectsCalcTime := Src.iReflectsCalcTime;
     Dst.sFmixPow := Src.sFmixPow;
     Dst.dFOVy := Src.dFOVy;
     Dst.sTRIndex := Src.sTRIndex;
     Dst.sTRscattering := Src.sTRscattering;
     Dst.MCoptions := Src.MCoptions;
     Dst.MCdiffReflects := Src.MCdiffReflects;
     Dst.bStereoMode := Src.bStereoMode;
     Dst.bSSAO24BorderMirrorSize := Src.bSSAO24BorderMirrorSize;
     Dst.iAmbCalcTime := Src.iAmbCalcTime;
     Dst.bNormalsOnDE := Src.bNormalsOnDE;
     Dst.bCalculateHardShadow := Src.bCalculateHardShadow;
     Dst.bStepsafterDEStop := Src.bStepsafterDEStop;
     Dst.MinimumIterations := Src.MinimumIterations;
     Dst.MClastY := Src.MClastY;
     Dst.bCalc1HSsoft := Src.bCalc1HSsoft;
     Dst.iAvrgDEsteps := Src.iAvrgDEsteps;
     Dst.iAvrgIts := Src.iAvrgIts;
     Dst.bPlanarOptic := Src.bPlanarOptic;
     Dst.bCalcAmbShadowAutomatic := Src.bCalcAmbShadowAutomatic;
     Dst.sNaviMinDist := Src.sNaviMinDist;
     Dst.dStepWidth := Src.dStepWidth;
     Dst.bVaryDEstopOnFOV := Src.bVaryDEstopOnFOV;
     Dst.bHScalculated := Src.bHScalculated;
     Dst.sDOFZsharp := Src.sDOFZsharp;
     Dst.sDOFclipR := Src.sDOFclipR;
     Dst.sDOFaperture := Src.sDOFaperture;
     Dst.bCutOption := Src.bCutOption;
     Dst.sDEstop := Src.sDEstop;
     Dst.bCalcDOFtype := Src.bCalcDOFtype;
     Dst.mZstepDiv := Src.mZstepDiv;
     Dst.MCDepth := Src.MCDepth;
     Dst.SSAORcount := Src.SSAORcount;
     Dst.AODEdithering := Src.AODEdithering;
     Dst.bImageScale := Src.bImageScale;
     Dst.bIsJulia := Src.bIsJulia;
     Dst.dJx := Src.dJx;
     Dst.dJy := Src.dJy;
     Dst.dJz := Src.dJz;
     Dst.dJw := Src.dJw;
     Dst.bDFogIt := Src.bDFogIt;
     Dst.MCSoftShadowRadius := Src.MCSoftShadowRadius;
     Dst.HSmaxLengthMultiplier := Src.HSmaxLengthMultiplier;
     Dst.StereoScreenWidth := Src.StereoScreenWidth;
     Dst.StereoScreenDistance := Src.StereoScreenDistance;
     Dst.StereoMinDistance := Src.StereoMinDistance;
     Dst.sRaystepLimiter := Src.sRaystepLimiter;
     Dst.hVGrads := Src.hVGrads;
     Dst.bMCSaturation := Src.bMCSaturation;
     Dst.sAmbShadowThreshold := Src.sAmbShadowThreshold;
     Dst.iCalcTime := Src.iCalcTime;
     Dst.iCalcHStime := Src.iCalcHStime;
     Dst.byCalcNsOnZBufAuto := Src.byCalcNsOnZBufAuto;
     Dst.SRamount := Src.SRamount;
     Dst.bCalcSRautomatic := Src.bCalcSRautomatic;
     Dst.SRreflectioncount := Src.SRreflectioncount;
     Dst.sColorMul := Src.sColorMul;
     Dst.byColor2Option := Src.byColor2Option;
     Dst.bVolLightNr := Src.bVolLightNr;
     Dst.bCalc3D := Src.bCalc3D;
     Dst.bSliceCalc := Src.bSliceCalc;
     Dst.dCutX := Src.dCutX;
     Dst.dCutY := Src.dCutY;
     Dst.dCutZ := Src.dCutZ;
     Dst.sTransmissionAbsorption := Src.sTransmissionAbsorption;
     Dst.sDEAOmaxL := Src.sDEAOmaxL;
     Dst.sDEcombS := Src.sDEcombS;
     for I := Low(Dst.PHCustomF) to High(Dst.PHCustomF) do
       Dst.PHCustomF[I] := nil;
     for I := Low(Src.PHCustomF) to High(Src.PHCustomF) do
       Dst.PHCustomF[I] := Src.PHCustomF[I];
     Dst.PCFAddon := Src.PCFAddon;
     Dst.sDOFZsharp2 := Src.sDOFZsharp2;
     Dst.iMaxIts := Src.iMaxIts;
     Dst.iMaxItsF2 := Src.iMaxItsF2;
     Dst.DEmixColorOption := Src.DEmixColorOption;
     Dst.MCcontrast := Src.MCcontrast;
     Dst.sM3dVersion := Src.sM3dVersion;
     Dst.TilingOptions := Src.TilingOptions;
     Dst.Light := Src.Light;
   end;

begin
    SaveHeaderPointers(@Para11, p);
    Result := False;
    LastHisParSaveTime := Now;
    if FileExists(FileName) then
    try
      if Verbose then Mand3DForm.OutMessage('Loading: ' + ChangeFileExtSave(ExtractFileName(FileName), ''));
      AssignFile(f, FileName);
      Reset(f, 1);
      BlockRead(f, MId, 4);
      if (MId < 0) or (MId > 250) or (FileSize(f) < 100) then Exit;
      Seek(f, 0);
      if MId < 4 then
      begin
        BlockRead(f, MandHeader4, SizeOf(TMandHeaderOld));
        FillChar(MandHeader4.dFOVy, 72, 0);
      end
      else if MId < 7 then
        BlockRead(f, MandHeader4, SizeOf(TMandHeader4))
      else if MId < 8 then
        BlockRead(f, Para9, SizeOf(TMandHeader9) - 124)
      else if MId < 20 then
        BlockRead(f, Para9, SizeOf(TMandHeader9))
      {$ifdef ENABLE_EXTENSIONS}
      else if MId < 45 then begin
        BlockRead(f, Para10, SizeOf(TMandHeader10));
        FillV11HeaderFromV10(Para10, Para11);
      end
      {$endif}
      else
        BlockRead(f, Para11, SizeOf(TMandHeader11));
      if (MId < 5) and (MandHeader4.dZstart > MandHeader4.dZend) then
      begin
        MandHeader4.dZstart := - MandHeader4.dZstart;
        MandHeader4.dZend   := - MandHeader4.dZend;
        d                   := MandHeader4.dXrot;
        MandHeader4.dXrot   := MandHeader4.dYrot * Pid180;
        MandHeader4.dYrot   := d * Pid180;
        MandHeader4.Light.Cols[7] := MandHeader4.Light.Cols[4];
        MandHeader4.Light.Cols[8] := MandHeader4.Light.Cols[5];
        MandHeader4.Light.Cols[9] := MandHeader4.Light.Cols[6];
      end;
      if MId < 5 then
        MandHeader4.dZmid := (MandHeader4.dZstart + MandHeader4.dZend) * 0.5
      else if (MId = 5) and ((MandHeader4.iOptions and 15) = 10) then
      begin
        MandHeader4.dPow := (MandHeader4.iOptions shr 18) and 3;
        i := (MandHeader4.iOPtions and $38000) shr 1;
        MandHeader4.iOptions := (MandHeader4.iOptions and $7FFC3FFF) or i;
      end;
      if MId < 7 then
      begin
        if MId < 6 then MandHeader4.bHScalculated := 1;
        MandHeader4.Light.TBoptions := MandHeader4.Light.TBoptions or (43 shl 11);
        Convert4to7paras(MandHeader4, TMandHeader8(Para9));
      end
      else if MId < 8 then
        ConvertFromOldLightParas(Para9.Light, 148);

      Para11.MandId := MId;
      Mand3DForm.Authors := ExtractAuthorsFromPara(@Para11);   //if MId > 40
      InsertHeaderPointers(@Para11, p);

      if MId < 20 then begin
        for i := 0 to 5 do para9.PHCustomF[i] := p[i];
        Para9.PCFAddon := p[6];
        Result := ConvertHeaderFromOldParas(TMandHeader8(Para9), True);
        FastMove(Para9, Para11, SizeOf(TMandHeader9));
        ConvertLight8to9(Para9.Light, Para11.Light);
      end
      else begin
        Result := True;
        if Verbose then LoadBackgroundPicT(@Para11.Light);
      end;
      if Result and Verbose then  //not verbose only for canload test
      begin
        if MId > 15 then       //Load HAddon
        begin
          if MId > 17 then
          begin
            if MId > 18 then
            begin
              if MId < 35 then Para11.TilingOptions := 0;
              TileSize := GetTileSize(@Para11);
              i := TileSize.X * TileSize.Y * SizeOf(TsiLight5);
            end
            else
              i := Para11.Width * Para11.Height * SizeOf(TsiLight4);
          end
          else i := Para11.Width * Para11.Height * SizeOf(TsiLight3);
          if FileSize(f) >= FilePos(f) + i + SizeOf(THeaderCustomAddonOld) then
            Seek(f, FilePos(f) + i);

          {$ifdef ENABLE_EXTENSIONS}
          if MId<45 then begin
            GetMem(Para10.PCFAddon, SizeOf(THeaderCustomAddon10));
            LoadHAddon10(f, PTHeaderCustomAddon10(Para10.PCFAddon));
            FillV11AddonFromV10(Para10, Para11);
          end
          else begin
            LoadHAddon(f, PTHeaderCustomAddon(Para11.PCFAddon));
          end;
          {$else}
          LoadHAddon(f, PTHeaderCustomAddon(Para11.PCFAddon));
          {$endif}

        end;
        if MId < 20 then UpdateFormulaOptionTo20(PTHeaderCustomAddon(Para11.PCFAddon));
        UpdateFormulaOptionAbove20(Para11);
        UpdateLightParasAbove3(Para11.Light);
        IniCFsFromHAddon(PTHeaderCustomAddon(Para11.PCFAddon), Para11.PHCustomF);
      //  Mand3DForm.HAddOn.bHCAversion := 16;//test
        bSRVolLightMapCalculated := False;
        Mand3DForm.SetEditsFromHeader;
        Mand3DForm.allPreSetsUp;
        Mand3DForm.MButtonsUp;
        Mand3DForm.InternAspect := Para11.Width / Max(1, Para11.Height);
        FastMove(Mand3DForm.MHeader.Light, LHPSLight, SizeOf(TLightingParas9));
        LightAdjustForm.bUserChange := False;
        LightAdjustForm.CheckBox21.Checked := False;
        LightAdjustForm.SetLightFromHeader(Para11);
        StoreUndoLight;
        if Para11.Light.BGbmp[0] = 0 then LightAdjustForm.Image5.Visible := False else
          MakeLMPreviewImage(LightAdjustForm.Image5, @M3DBackGroundPic);
        SetSaveDialogNames(FileName);
  //      Mand3DForm.Caption := ExtractFileName(FileName);
        Mand3DForm.Label1.Caption := '';
      end;
    finally
      CloseFile(f);
    end;  
end;

{function LoadParsFromStream(var Para10: TMandHeader10; var Stream: TStream): Boolean;
var d: Double;
    MId, i: Integer;
    p: array[0..6] of Pointer;
    MandHeader4: TMandHeader4;
    para9: TMandHeader9;
    TileSize: TPoint;
begin
      for i := 0 to 5 do p[i] := Para10.PHCustomF[i];
      p[6] := Para10.PCFAddon;
      Result := False;
      Stream.Seek(0, soBeginning);
      Stream.Read(MId, 4);
      if (MId < 0) or (MId > 250) or (Stream.Size < 100) then Exit;
      Stream.Seek(0, soBeginning);
      if MId < 4 then
      begin
        Stream.Read(MandHeader4, SizeOf(TMandHeaderOld));
        FillChar(MandHeader4.dFOVy, 72, 0);
      end
      else if MId < 7 then
        Stream.Read(MandHeader4, SizeOf(TMandHeader4))
      else if MId < 8 then
        Stream.Read(Para9, SizeOf(TMandHeader9) - 124)
      else if MId < 20 then
        Stream.Read(Para9, SizeOf(TMandHeader9))
      else Stream.Read(Para10, SizeOf(TMandHeader10));
      if (MId < 5) and (MandHeader4.dZstart > MandHeader4.dZend) then
      begin
        MandHeader4.dZstart := - MandHeader4.dZstart;
        MandHeader4.dZend   := - MandHeader4.dZend;
        d                   := MandHeader4.dXrot;
        MandHeader4.dXrot   := MandHeader4.dYrot * Pid180;
        MandHeader4.dYrot   := d * Pid180;
        MandHeader4.Light.Cols[7] := MandHeader4.Light.Cols[4];
        MandHeader4.Light.Cols[8] := MandHeader4.Light.Cols[5];
        MandHeader4.Light.Cols[9] := MandHeader4.Light.Cols[6];
      end;
      if MId < 5 then
        MandHeader4.dZmid := (MandHeader4.dZstart + MandHeader4.dZend) * 0.5
      else if (MId = 5) and ((MandHeader4.iOptions and 15) = 10) then
      begin
        MandHeader4.dPow := (MandHeader4.iOptions shr 18) and 3;
        i := (MandHeader4.iOPtions and $38000) shr 1;
        MandHeader4.iOptions := (MandHeader4.iOptions and $7FFC3FFF) or i;
      end;
      if MId < 7 then
      begin
        if MId < 6 then MandHeader4.bHScalculated := 1;
        MandHeader4.Light.TBoptions := MandHeader4.Light.TBoptions or (43 shl 11);
        Convert4to7paras(MandHeader4, TMandHeader8(Para9));    //header pars not init?
      end
      else if MId < 8 then
        ConvertFromOldLightParas(Para9.Light, 148);

      for i := 0 to 5 do para10.PHCustomF[i] := p[i];
      Para10.PCFAddon := p[6];

      if MId < 20 then
      begin
        for i := 0 to 5 do para9.PHCustomF[i] := p[i];
        Para9.PCFAddon := p[6];
        Result := ConvertHeaderFromOldParas(TMandHeader8(Para9), False); //dont load formulas
        FastMove(Para9, Para10, SizeOf(TMandHeader9));
        ConvertLight8to9(Para9.Light, Para10.Light);
      end
      else
      begin
        Result := True;
   //     LoadBackgroundPicT(Para10);
      end;
      if Result then  //not verbose only for canload test
      begin
        if MId > 15 then       //Load HAddon
        begin
          if MId > 17 then
          begin
            if MId > 18 then
            begin
              if MId < 35 then para10.TilingOptions := 0;
              TileSize := GetTileSize(@para10);
              i := TileSize.X * TileSize.Y * SizeOf(TsiLight5);
            end
            else
              i := Para10.Width * Para10.Height * SizeOf(TsiLight4);
          end
          else i := Para10.Width * Para10.Height * SizeOf(TsiLight3);
          if Stream.Size >= Stream.Position + i + SizeOf(THeaderCustomAddonOld) then
            Stream.Seek(Stream.Position + i, soBeginning);
          LoadHAddonFromStream(Stream, PTHeaderCustomAddon(Para10.PCFAddon));
        end;
//        if MId < 20 then UpdateFormulaOptionTo20(PTHeaderCustomAddon(Para10.PCFAddon));
  //      UpdateFormulaOptionAbove20(para10);
        UpdateLightParasAbove3(para10.Light);
      end;
end;


{    LightAngleX: Word;
    LightAngleY: Word;
    RoughZposFine: Word;  // 1 Byte Roughness + 1 Byte LSB Zpos for more precision!
    Zpos:        Word;
    Shadow:      Word;    // Hard shadow or DEcount when not HScalced
    AmbShadow:   Word;
    SIgradient:  Word;    // Smoothed Iteration gradient for coloring
    OTrap:       Word;    // coloring on OrbitTrap
  end;
  TsiLight3 = packed record
    LightAngleX: Word;
    LightAngleY: Word;
    Zpos:        Word;    // > 32767 = background  --> 32Bit???!
    Shadow:      Word;    // Hard shadow or DEcount when not HScalced
    AmbShadow:   Word;
    SIgradient:  Word;    // Smoothed Iteration gradient for coloring
}
procedure LoadFullM3I(var Header: TMandHeader11; Filename: String);
var f: file;
    MID, i, j: Integer;
    SI3: array of TSiLight3;
    SI4: array of TSiLight4;
    PSI3, PSI4: PInteger;
    PW: PWord;
    tp: TPoint;
    bTrigRepaint: LongBool;
begin
  Screen.Cursor := crHourGlass;
  try
    Application.ProcessMessages;
    Mand3DForm.Timer1.Enabled := False;  //disable startup repaint
    if LoadParameter(Header, FileName, True) then
    begin
      bTrigRepaint := True;
      SetImageSize;
      tp := GetTileSize(@Header);
      j := tp.X * tp.Y;
      AssignFile(f, FileName);
      Reset(f, 1);
      try
        BlockRead(f, MID, 4);
        if MID <  4 then Seek(f, 200) else
        if MID <  7 then Seek(f, 272) else
        if MID <  8 then Seek(f, 580) else
        if MID < 20 then Seek(f, SizeOf(TMandHeader9)) else Seek(f, SizeOf(TMandHeader11)); // 840
        if MID < 19 then SetLength(SI4, j);
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
        else if MID < 19 then BlockRead(f, SI4[0], j * SizeOf(TsiLight4));
        try
          SetLength(Mand3DForm.siLight5, j);
        except
          Mand3DForm.OutMessage('Not enough memory to load this file.');
        end;
        if Length(Mand3DForm.siLight5) <> j then Exit;
        Mand3DForm.mSLoffset := tp.X * SizeOf(TsiLight5);
        if MID > 18 then
          BlockRead(f, Mand3DForm.siLight5[0], j * SizeOf(TsiLight5))
        else
          ConvertSiLight4To5(@SI4[0], @Mand3DForm.siLight5[0], j);
        if MID < 20 then
        begin
   { NormalZ:    SmallInt;  negate
    RoughZposFine: Word;  // 1 Byte Roughness + 1 Byte LSB Zpos for more precision
    Zpos:       Word;   }
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
        end
        else if (MID = 35) and (Header.bDFogIt > 0) then
        begin
          PW := PWord(Integer(@Mand3DForm.siLight5[0]) + 10);  //@shadow
          for i := 1 to j do
          begin
            PW^ := (PW^ and $FC00) or ((PW^ and $3FF) shr 2);
            Inc(PW, 9);
          end;
        end;
        Seek(f, FilePos(f) + SizeOf(THeaderCustomAddon));
        if (Length(fullSizeImage) = j) and (FileSize(f) - FilePos(f) >= j * 4) then
        begin
          BlockRead(f, fullSizeImage[0], j * 4);
          UpdateScaledImage(0, tp.Y);
          bTrigRepaint := False;
        end;
      finally
        SetLength(SI3, 0);
        SetLength(SI4, 0);
        CloseFile(f);
      end;
      LightAdjustForm.MakeHisto;
      if bTrigRepaint then TriggerRepaint;
    end;  
  finally
    Screen.Cursor := crDefault;
  end;
end;

Initialization

  SetLength(IniHigherVersion, 0);

end.
