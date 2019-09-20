unit Tiling;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, TypeDefinitions, Menus, Vcl.ComCtrls;

type
  TTilingForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Button1: TButton;
    SpeedButton11: TSpeedButton;
    SpeedButton9: TSpeedButton;
    Image1: TImage;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    RadioGroup1: TRadioGroup;
    CheckBox2: TCheckBox;
    Label6: TLabel;
    Button2: TButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    OpenDialog2: TOpenDialog;
    CheckBox3: TCheckBox;
    Button3: TButton;
    Label1: TLabel;
    Label12: TLabel;
    CheckBox4: TCheckBox;
    SpeedButton2: TSpeedButton;
    Label13: TLabel;
    PopupMenu1: TPopupMenu;
    ileXY1: TMenuItem;
    Renderthistile1: TMenuItem;
    Deletethistilesfiles1: TMenuItem;
    N1: TMenuItem;
    Label14: TLabel;
    Label24: TLabel;
    CheckBox5: TCheckBox;
    Label16: TLabel;
    Edit2: TEdit;
    CheckBox6: TCheckBox;
    Edit3: TEdit;
    CheckBox7: TCheckBox;
    Edit21: TEdit;
    UpDown3: TUpDown;
    Edit4: TEdit;
    UpDownSharp: TUpDown;
    Edit5: TEdit;
    UpDown1: TUpDown;
    Edit6: TEdit;
    UpDown2: TUpDown;
    Edit7: TEdit;
    UpDown4: TUpDown;
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure SpeedButton9Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Renderthistile1Click(Sender: TObject);
    procedure Deletethistilesfiles1Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CheckBox6Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
  private
    { Private-Deklarationen }
    OrigHeader: TMandHeader10;
    OrigHAddOn: THeaderCustomAddon;
    HybridCustoms: array[0..5] of TCustomFormula;
    TilesAlreadyRendered: array of array of Byte;
    SelectedTile: TPoint;
    AOm3iFile: String;
    bOnlyThisTile: LongBool;
    procedure MakeData;
    procedure SetData;
    procedure SetSizes;
    procedure PaintImageTiling;
    procedure SetHeader;
    procedure SetNames(FileName: String);
    procedure NewProject;
    function ExtractTilePos(FileName: String): TPoint;
    procedure ScanProjectFolder;
    function GetImageTilePos(x, y: Integer): TPoint;
    function TileRendered(x, y: Integer): LongBool;
    function GetNextTilePos(brActPos: TPoint): TPoint;
    procedure RenderActualTile;
    procedure SaveProject(FileName: String);
    procedure Import;
  public
    { Public-Deklarationen }
    BigRenderData: TBigRenderData;
    bUserChange, SaveThisTile: LongBool;
    brActTile: TPoint;
    ProjectName: String;
    SaveDirectory: String;
    TilingOutFile: TFileStream;
    TilingOutFileName: String;
    procedure NextTile;
    function LoadBig(FileName: String): LongBool;
    function OccupyDFile(Fname: String): LongBool;
    procedure CloseOutPutStream;
  end;
function MakeFilePointIndizes(P: TPoint; decimals: Integer; const BigRenderData: TBigRenderData): String;

var
  TilingForm: TTilingForm;
  bTilingFormCreated: LongBool = False;

implementation

uses FileHandling, Mand, HeaderTrafos, DivUtils, Math, LightAdjust, ImageProcess,
  BRInfoWindow;

{$R *.dfm}

function MakeFilePointIndizes(P: TPoint; decimals: Integer; const BigRenderData: TBigRenderData): String;
var s: String;
begin
    if BigRenderData.brSingleFilenumber then
    begin
      Result := IntToStr(P.X + (P.Y - 1) * BigRenderData.brTileCountH);
      if Length(Result) < decimals * 2 then Result := StringOfChar('0', decimals * 2 - Length(Result)) + Result;
    end else begin
      s := IntToStr(P.X);
      if Length(s) < decimals then s := StringOfChar('0', decimals - Length(s)) + s;
      Result := 'X' + s + 'Y';
      s := IntToStr(P.Y);
      if Length(s) < decimals then s := StringOfChar('0', decimals - Length(s)) + s;
      Result := Result + s;
    end;
end;

function TTilingForm.OccupyDFile(Fname: String): LongBool;
begin  //Try to open OutFile in write access mode
    Result := False;
    CloseOutPutStream;
    TilingOutFileName := '';
    if Fname = '' then Exit;
    try
      TilingOutFile := TFileStream.Create(Fname, fmCreate or fmShareExclusive);
      Result := True;
    except
      Result := False;
    end;
    if not Result then FreeAndNil(TilingOutFile) else TilingOutFileName := Fname;
end;

procedure TTilingForm.CloseOutPutStream;
begin
    if not Assigned(TilingOutFile) then Exit;
    FreeAndNil(TilingOutFile);
    if (TilingOutFileName <> '') and not FileIsBigger1(TilingOutFileName) then
      DeleteFile(TilingOutFileName);
    TilingOutFileName := '';
end;

function TTilingForm.TileRendered(x, y: Integer): LongBool;
begin
    Result := True;
    if (Length(TilesAlreadyRendered) = BigRenderData.brTileCountV) and
       (Length(TilesAlreadyRendered[0]) = BigRenderData.brTileCountH) and
       (x > 0) and (y > 0) and (x <= BigRenderData.brTileCountH) and
       (y <= BigRenderData.brTileCountV) then
         Result := TilesAlreadyRendered[y - 1, x - 1] > 0;
end;

function TTilingForm.GetNextTilePos(brActPos: TPoint): TPoint;
var x, y, ya, ye, xa: Integer;
begin
    if CheckBox6.Checked then
    begin
      ya := Max(brActPos.Y, StrToIntTrim(Edit2.Text));
      ye := Min(BigRenderData.brTileCountV, StrToIntTrim(Edit3.Text));
    end else begin
      ya := brActPos.Y;
      ye := BigRenderData.brTileCountV;
    end;
    Result := Point(0, 0);
    for y := ya to ye do
    begin
      if y = ya then xa := brActPos.X else xa := 1;
      for x := xa to BigRenderData.brTileCountH do
        if not TileRendered(x, y) then
        begin
          Result := Point(x, y);
          Exit;
        end;
    end;
end;

procedure TTilingForm.NextTile;
begin
    ScanProjectFolder;
    if (not bOnlyThisTile) and (CheckBox4.Checked or CheckBox6.Checked) then  //auto render following tiles; render tiles in rows xx to yy
    begin
      brActTile := GetNextTilePos(brActTile);
      if brActTile.X > 0 then
      begin
        RenderActualTile;
        Exit;
      end;
    end;
    Mand3DForm.EnableButtons;
end;

procedure TTilingForm.NewProject;
begin
    SetNames(IncludeTrailingPathDelimiter(IniDirs[8]) + '(new)');
end;

function TTilingForm.GetImageTilePos(x, y: Integer): TPoint;
begin
    Result.X := (x * BigRenderData.brTileCountH) div Image1.Picture.Bitmap.Width + 1;
    Result.Y := (y * BigRenderData.brTileCountV) div Image1.Picture.Bitmap.Height + 1;
end;

function TTilingForm.ExtractTilePos(FileName: String): TPoint;   //filenameX01Y01
var l, i: Integer;
begin
    FileName := ChangeFileExt(ExtractFileName(FileName), '');
    l := Length(FileName);
    try
      if BigRenderData.brSingleFilenumber then
      begin
        i := StrToInt(Copy(FileName, l - 3, 4));
        Result.Y := ((i - 1) div BigRenderData.brTileCountH) + 1;
        Result.X := i - (Result.Y - 1) * BigRenderData.brTileCountH;
      end else begin
        Result.Y := StrToInt(Copy(FileName, l - 1, 2));
        Result.X := StrToInt(Copy(FileName, l - 4, 2));
      end;
    except
      Result := Point(0, 0);
    end;
end;

procedure TTilingForm.ScanProjectFolder;
var tch, tcv, h, v: Integer;
    SR: TSearchRec;
    s: String;
    p: TPoint;
begin
    if (SaveDirectory <> '') and not DirectoryExists(SaveDirectory) then CreateDir(SaveDirectory);
    if DirectoryExists(SaveDirectory) then
    with BigRenderData do
    begin
      tch := Min(99, Max(2, brTileCountH));
      tcv := Min(99, Max(2, brTileCountV));
      SetLength(TilesAlreadyRendered, tcv, tch);
      for v := 0 to tcv - 1 do
        for h := 0 to tch - 1 do TilesAlreadyRendered[v, h] := 0;
      s := SaveDirectory + ProjectName;
      if FindFirst(s + '*.*', faAnyFile, SR) = 0 then
      try
        repeat
          p := ExtractTilePos(SR.Name);
          if (p.Y > 0) and (p.X > 0) and (p.Y <= tcv) and (p.X <= tch) then
            TilesAlreadyRendered[p.Y - 1, p.X - 1] := 1;
        until FindNext(SR) <> 0;
      finally
        FindClose(SR);
      end;
    end
    else SetLength(TilesAlreadyRendered, 0, 0);
    PaintImageTiling;
end;

procedure TTilingForm.SetNames(FileName: String);
begin
    ProjectName := ChangeFileExtSave(ExtractFileName(FileName), '');
    SaveDirectory := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(
                       ExtractFileDir(FileName)) + ProjectName);
    Label13.Caption := 'Project:  ' + ProjectName;
    ScanProjectFolder;
end;

procedure TTilingForm.SetHeader;
var i: Integer;
begin
    OrigHeader.PCFAddon := @OrigHAddon;
    for i := 0 to 5 do OrigHeader.PHCustomF[i] := @HybridCustoms[i];
end;

procedure TTilingForm.PaintImageTiling;
var w, h, i, j, wm, hm, tcH, tcV, x, y, tw, th: Integer;
    bTAR: LongBool;
begin
    if (BigRenderData.brWidth > 0) and (BigRenderData.brHeight > 0) then
    begin
      if BigRenderData.brWidth / BigRenderData.brHeight > 324/280 then
      begin
        w := 324;
        h := Round(324 * BigRenderData.brHeight / BigRenderData.brWidth);
      end else begin
        w := Round(280 * BigRenderData.brWidth / BigRenderData.brHeight);
        h := 280;
      end;
      if (Image1.Width <> w) or (Image1.Height <> h) then
        Image1.Picture.Bitmap.SetSize(w, h);
      tw := (BigRenderData.brTileWidth * w) div BigRenderData.brWidth;  //div by 0  when importing paras from main
      th := (BigRenderData.brTileHeight * h) div BigRenderData.brHeight;
      tcH := BigRenderData.brTileCountH;
      tcV := BigRenderData.brTileCountV;
      bTAR := (Length(TilesAlreadyRendered) = tcV) and (Length(TilesAlreadyRendered[0]) = tcH);
      wm := (w div tcH) div 2 + 10;
      hm := (h div tcV) div 2 + 5;
      with Image1.Canvas do
      begin
        Pen.Color := $404040;
        Brush.Color := $A0A0A0;
        FillRect(ClipRect);
        if bTAR then
        begin
          Brush.Color := $F0F0F0;
          for i := 1 to BigRenderData.brTileCountV do
            for j := 1 to BigRenderData.brTileCountH do
              if TilesAlreadyRendered[i - 1, j - 1] > 0 then
              begin
                x := ((j - 1) * w) div tcH;
                y := ((i - 1) * h) div tcV;
                FillRect(Rect(x, y, x + tw, y + th));
              end;
        end;
        Brush.Color := $404040;
        FrameRect(ClipRect);
        Brush.Color := $A0A0A0;
        for i := 1 to BigRenderData.brTileCountH - 1 do
        begin
          j := (i * w) div tcH;
          MoveTo(j, 0);
          LineTo(j, h);
        end;
        for i := 1 to BigRenderData.brTileCountV - 1 do
        begin
          j := (i * h) div tcV;
          MoveTo(0, j);
          LineTo(w, j);
        end;
        Font.Name := 'Microsoft Sans Serif';
        Font.Size := 6;
        Font.Color := 0;
        y := SetBkMode(Image1.Canvas.Handle, TRANSPARENT);
        for i := 1 to BigRenderData.brTileCountV do
          for j := 1 to BigRenderData.brTileCountH do
            TextOut((j * w) div tcH - wm, (i * h) div tcV - hm, '[' + IntToStr(j) + ',' + IntToStr(i) + ']');
        SetBkMode(Image1.Canvas.Handle, y);
      end;  
    end;
end;

procedure TTilingForm.Button1Click(Sender: TObject);
begin
    Visible := False;
end;

procedure TTilingForm.SetSizes;
begin
    with BigRenderData do
    begin
      Label10.Caption := IntToStr(OrigHeader.Width) + ' x ' + IntToStr(OrigHeader.Height);
      Label11.Caption := IntToStr(brTileWidth div brDownScale) + ' x ' + IntToStr(brTileHeight div brDownScale);
      Label12.Caption := IntToStr(brWidth div brDownScale) + ' x ' + IntToStr(brHeight div brDownScale);
      if (brTileWidth * brTileHeight > 25000000) or (brTileWidth > 32000) or (brTileHeight > 32000) then
        Label11.Font.Color := clRed
      else
        Label11.Font.Color := clWindowText;
      PaintImageTiling;
    end;
end;

procedure TTilingForm.MakeData;
begin
    with BigRenderData do
    begin
      brScale := StrToFloatK(Edit1.Text);
      brTileCountH := UpDown3.Position;
      brTileCountV := UpDown2.Position;
      brDownScale := UpDown1.Position;
      brOutputType := RadioGroup1.ItemIndex;
      brScaleDEstop := CheckBox1.Checked;
      brSaveZBuf := CheckBox2.Checked;
      brSaveM3I := CheckBox3.Checked;
      brTileWidth := (Round(OrigHeader.Width * brScale / brTileCountH) div brDownScale) * brDownScale;
      brTileHeight := (Round(OrigHeader.Height * brScale / brTileCountV) div brDownScale) * brDownScale;
      brWidth := brTileWidth * brTileCountH;
      brHeight := brTileHeight * brTileCountV;
      brM3dVersion := M3dVersion;
      brJPEGqual := UpDown4.Position;
      brSharp := UpDownSharp.Position;
      brUseOrigAO := CheckBox5.Checked;
      brRenderRowsFrom := StrToIntTrim(Edit2.Text);
      brRenderRowsTo := StrToIntTrim(Edit3.Text);
      brRenderRows := CheckBox6.Checked;
      brSingleFilenumber := CheckBox7.Checked;
      FillChar(brFreeBuf, SizeOf(brFreeBuf), 0);
      brVersion := 3;
    end;
end;

procedure TTilingForm.SetData;
begin
    with BigRenderData do
    begin
      bUserChange := False;
      Edit1.Text := FloatToStr(brScale);
      UpDown3.Position := brTileCountH;
      UpDown2.Position := brTileCountV;
      UpDown1.Position := brDownScale;
      RadioGroup1.ItemIndex := brOutputType;
      CheckBox1.Checked := brScaleDEstop;
      CheckBox2.Checked := brSaveZBuf;
      CheckBox3.Checked := brSaveM3I;
      CheckBox5.Checked := brUseOrigAO;
      CheckBox6.Checked := brRenderRows;
      CheckBox7.Checked := brSingleFilenumber;
      UpDownSharp.Position := brSharp;
      UpDown4.Position := brJPEGqual;
      Edit2.Text := IntToStr(brRenderRowsFrom);
      Edit3.Text := IntToStr(brRenderRowsTo);
      bUserChange := True;
    end;
end;

procedure GetAOfromM3I(FileName, OutFile: String);
var f, f2: file;
    x, y: Integer;
    outBuf: array of TAObuf;
    POutBuf: TPAObuf;
    siL5: array of TsiLight5;
    PS5: TPsiLight5;
    tmpHeader: TMandHeader10;
begin
    AssignFile(f, FileName);
    Reset(f, 1);
    try
      BlockRead(f, tmpHeader, SizeOf(TMandHeader10));
      if tmpHeader.MandId < 20 then
      begin
        ShowMessage('The M3I file is to old, please render it again!');
        Exit;
      end;
      if not DirectoryExists(ExtractFileDir(OutFile)) then CreateDir(ExtractFileDir(OutFile));
      AssignFile(f2, OutFile);
      Rewrite(f2, 1);
      BlockWrite(f2, tmpHeader, 12); //MandId, Width, Height
      y := tmpHeader.bCalcAmbShadowAutomatic;   // bCalcAmbShadowAutomatic: Byte;
      BlockWrite(f2, y, 4);
      BlockWrite(f2, tmpHeader.sAmbShadowThreshold, 4);
      BRInfoForm.Show;
      try
        SetLength(siL5, tmpHeader.Width);
        SetLength(outBuf, tmpHeader.Width);
        for y := 1 to tmpHeader.Height do
        begin
          BlockRead(f, siL5[0], tmpHeader.Width * SizeOf(TsiLight5));
          PS5 := @siL5[0];
          POutBuf := @outBuf[0];
          for x := 1 to tmpHeader.Width do
          begin
            PInteger(POutBuf)^ := PInteger(Integer(PS5) + 7)^;
            POutBuf.AO := PS5.AmbShadow;
            Inc(PS5);
            Inc(POutBuf);
          end;
          BlockWrite(f2, outBuf[0], tmpHeader.Width * SizeOf(TAObuf));
          BRInfoForm.ProgressBar1.Position := (y * BRInfoForm.ProgressBar1.Max) div tmpHeader.Height;
          BRInfoForm.Repaint;
        end;
      finally
        CloseFile(f2);
        SetLength(siL5, 0);
        SetLength(outBuf, 0);
        BRInfoForm.Hide;
      end;
    finally
      CloseFile(f);
    end;
end;

procedure TTilingForm.Import;
begin
    UpDown1.Position := OrigHeader.bImageScale;
    MakeData;
    SetSizes;   //painttiling
    Panel2.Enabled := True;
    Button2.Enabled := True;
    Button3.Enabled := True;
    SpeedButton9.Enabled := True;
    if BigRenderData.brUseOrigAO then
    begin
      Showmessage('Please select the original M3I file now!');
      if Mand3DForm.OPD.Execute then
        AOm3iFile := Mand3DForm.OPD.FileName
      else
      begin
        BigRenderData.brUseOrigAO := False;
        CheckBox5.Checked := False;
      end;
    end;
    SetFocus;
    BringToFront;
    if (not BigRenderData.brUseOrigAO) and ((OrigHeader.bCalcAmbShadowAutomatic and 1) = 1) and
       ((OrigHeader.bCalcAmbShadowAutomatic and 12) <> 12) then //AmbShad not DEAO
    begin
      ShowMessage('Only DEAO ambient shadows available in tiling mode.' + #13#10 +
                  'Is now selected and set to 33 rays, please change it for your own needs.');
      OrigHeader.bCalcAmbShadowAutomatic := 13 or 48;  //33 rays
      OrigHeader.AODEdithering := 0;
    end;
    SetFocus;
    BringToFront;
    if OrigHeader.bCalcDOFtype > 0 then    //disable DoF
    begin
      ShowMessage('DoF calculation turned off, not possible in tiling mode.');
      SetFocus;
      BringToFront;
    end;
    OrigHeader.bCalcDOFtype := 0;
    OrigHeader.TilingOptions := 0;
    bUserChange := True;
end;

procedure TTilingForm.SpeedButton2Click(Sender: TObject); //Import actual paras
begin
    Mand3DForm.MakeHeader;
    Mand3DForm.MHeader.TilingOptions := 0;
    bUserChange := False;
    SetHeader;
    AssignHeader(@OrigHeader, @Mand3DForm.MHeader);
    NewProject;
    Import;
end;

procedure TTilingForm.SpeedButton1Click(Sender: TObject);  //import parameter
begin
    SetHeader;
    if OpenDialog2.Execute and LoadParameter(OrigHeader, OpenDialog2.FileName, True) then
    begin
      bUserChange := False;
      SetNames(OpenDialog2.FileName);
      Import;
    end;
end;

procedure TTilingForm.FormShow(Sender: TObject);
begin
    OpenDialog2.InitialDir := IniDirs[1];
    OpenDialog1.InitialDir := IniDirs[8];
    SaveDialog1.InitialDir := IniDirs[8];
    SetHeader;
    Edit5.Hint := '1:  Full size, no anti aliasing' + #13#10 +
      '2:  2x2 anti aliasing' + #13#10 + '3:  3x3 anti aliasing';
    Edit4.Hint := 'Sharpen factor of the saved output image,' + #13#10 +
      'works only with downscales of 1:2 and 1:3 !' + #13#10 +
      '0: no sharpening ... 3: maximum sharpening';
    bUserChange := True;
end;

function TTilingForm.LoadBig(FileName: String): LongBool;
var f: File;
begin
    Result := False;
    if FileExists(FileName) then
    begin
      AssignFile(f, FileName);
      try
        Reset(f, 1);
        BlockRead(f, BigRenderData, SizeOf(BigRenderData));
        BlockRead(f, OrigHeader, SizeOf(OrigHeader));
        BlockRead(f, OrigHAddOn, SizeOf(OrigHAddOn));
        SetNames(FileName);
      finally
        CloseFile(f);
        SetHeader;
      end;
      UpdateFormulaOptionAbove20(OrigHeader);
      UpdateLightParasAbove3(OrigHeader.Light);
      bUserChange := False;
      if BigRenderData.brVersion < 2 then
      begin
        BigRenderData.brRenderRowsFrom := 1;
        BigRenderData.brRenderRowsTo := 999;
        BigRenderData.brRenderRows := False;
      end;
      if BigRenderData.brVersion < 3 then
      begin
        BigRenderData.brSingleFilenumber := False;
      end;
      try
        SetData;
        SetSizes;
        Panel2.Enabled := True;
        Button2.Enabled := True;
        Button3.Enabled := True;
        SpeedButton9.Enabled := True;
      finally
        bUserChange := True;
      end;
      Result := True;
      if OrigHeader.MandId < 42 then
      begin
        OrigHeader.bStereoMode := 0;
      end;
      //projectname := ...?
      if Abs(M3dVersion - BigRenderData.brM3dVersion) > 0.001 then
        ShowMessage('The project was made with M3D program version ' +
          ProgramVersionStr(BigRenderData.brM3dVersion, M3dSubRevision) + #13#10 +
          'The actual program version is ' + ProgramVersionStr(M3dVersion, M3dSubRevision) + #13#10 +
          'You should use the same program version to avoid' + #13#10 +
          'color or other changes in newer calculated tiles.');
    end;
end;

procedure TTilingForm.SpeedButton11Click(Sender: TObject);  //Open project
begin
    if OpenDialog1.Execute then LoadBig(OpenDialog1.FileName);
end;

procedure TTilingForm.SaveProject(FileName: String);
var f: File;
begin
    AssignFile(f, ChangeFileExt(FileName, '.big'));
    try
      OrigHeader.MandId := actMandId;
      Rewrite(f, 1);
      BlockWrite(f, BigRenderData, SizeOf(BigRenderData));
      BlockWrite(f, OrigHeader, SizeOf(OrigHeader));
      BlockWrite(f, OrigHAddOn, SizeOf(OrigHAddOn));
    finally
      CloseFile(f);
    end;
end;

procedure TTilingForm.SpeedButton9Click(Sender: TObject);   //Save project: data + origheader + haddon
var mo: Integer;
begin
    if ((OrigHeader.bCalcAmbShadowAutomatic and 1) = 1) and
       (((OrigHeader.AODEdithering and 3) + 1) <> UpDown1.Position) then
    begin   //proof DEAO settings according to downscale
      mo := mrNo;
      if UpDown1.Position = 1 then
      begin
        mo := MessageDlg('The DEAO settings are for downscaling, you would get moire patterns!' + #13#13 +
                         'Should i turn DEAO dithering off?', mtWarning, [mbYes, mbNo, mbAbort], 0);
        if mo = mrYes then OrigHeader.AODEdithering := 0;
      end
      else if UpDown1.Position > 1 then
      begin
        mo := MessageDlg('You could improve the DEAO settings for this downscaling' + #13#13 +
                         'by turning DEAO dithering on, should i do it for you?', mtInformation, [mbYes, mbNo, mbAbort], 0);
        if mo = mrYes then OrigHeader.AODEdithering := Min(2, Max(0, UpDown1.Position - 1));
      end;
      if mo = mrAbort then Exit;
    end;
    if ProjectName <> '(new)' then SaveDialog1.FileName := ProjectName;
    if SaveDialog1.Execute then
    begin
      MakeData;
      SetNames(SaveDialog1.FileName);
      SaveProject(SaveDialog1.FileName);
      if BigRenderData.brUseOrigAO then
      begin  //load m3i and store ao + zbuf (5bytes pp) in a seperate file + 3 bytes normal = 8 bytes pp!
        GetAOfromM3I(AOm3iFile, SaveDirectory + 'OriginalAO');
      end;
    end;
end;

procedure TTilingForm.Button3Click(Sender: TObject);  //send orig paras to main
begin
    OrigHeader.TilingOptions := 0;
 //   OrigHeader.bStereoMode := 0;
    AssignHeader(@Mand3DForm.MHeader, @OrigHeader);
    IniCFsFromHAddon(Mand3DForm.MHeader.PCFAddon, Mand3DForm.MHeader.PHCustomF);
    Mand3DForm.Authors[0] := '?';
    Mand3DForm.Authors[1] := '';
    Mand3DForm.SetEditsFromHeader;
    LightAdjustForm.SetLightFromHeader(OrigHeader);
    Mand3DForm.Caption := ProjectName;
    Mand3DForm.ParasChanged;
end;

procedure TTilingForm.SpinEdit2Change(Sender: TObject);
begin
    if bUserChange then
    begin
      NewProject;
      MakeData;
      SetSizes;
      if Sender = CheckBox7 then ScanProjectFolder;
    end;
    UpDownSharp.Enabled := UpDown1.Position > 1;
    Edit4.Enabled := UpDownSharp.Enabled;
end;

procedure TTilingForm.RenderActualTile;
begin
    with BigRenderData do
    begin
      if brActTile.X = 0 then
      begin
        ShowMessage('No tiles to render.');
        Exit;
      end;
      OrigHeader.bImageScale := brDownScale;
    end;
    if ProjectName = '(new)' then
    begin
      ShowMessage('Please save the project first.');
      Exit;
    end;
    if not FileExists(ExcludeTrailingPathDelimiter(SaveDirectory) + '.big') then
      SaveProject(ExcludeTrailingPathDelimiter(SaveDirectory) + '.big');

    with Mand3DForm do
    begin
      AssignHeader(@MHeader, @OrigHeader);
      SetTilingInfosInHeader(@MHeader, BigRenderData, Point(brActTile.X - 1, brActTile.Y - 1));
  //    MHeader.bStereoMode := 0;
      if TilingForm.CheckBox1.Checked then
        MHeader.sDEstop := MHeader.sDEstop * MHeader.Width / OrigHeader.Width;
      IniCFsFromHAddon(MHeader.PCFAddon, MHeader.PHCustomF);
      SetEditsFromHeader;
      LightAdjustForm.SetLightFromHeader(OrigHeader);
      MakeLightValsFromHeaderLight(@MHeader, @HeaderLightVals, 1, 0);
      Caption := ProjectName + '  Tile X=' + IntToStr(brActTile.X) + ' Y=' + IntToStr(brActTile.Y);
      Edit26.Text := IntToStr(BigRenderData.brJPEGqual);
      SaveThisTile := True;
      CalcMand(False);
    end;
end;

procedure TTilingForm.Button2Click(Sender: TObject);      //Render next tile
begin
    if not DirectoryExists(SaveDirectory) then
    begin
      CreateDir(SaveDirectory);
      ScanProjectFolder;
    end;
    brActTile := Point(0, 0);
    brActTile := GetNextTilePos(brActTile);
    bOnlyThisTile := False;
    RenderActualTile;
end;

procedure TTilingForm.FormCreate(Sender: TObject);
begin
    bTilingFormCreated := True;
    SaveThisTile := False;
end;

procedure TTilingForm.SpinEdit1Change(Sender: TObject);
begin
    if bUserChange then NewProject;
end;

procedure TTilingForm.Renderthistile1Click(Sender: TObject);  //Render selected tile
begin
    brActTile := SelectedTile;
    bOnlyThisTile := not CheckBox4.Checked;
    if not DirectoryExists(SaveDirectory) then
    begin
      CreateDir(SaveDirectory);
      ScanProjectFolder;
    end;
    RenderActualTile;
end;

procedure TTilingForm.Deletethistilesfiles1Click(Sender: TObject);   //Delete selected tiles files
var s: String;
    i: Integer;
    SR: TSearchRec;
const sc: array[0..1] of String = ('', 'ZBuf ');
begin
    for i := 0 to 1 do
    begin
      s := SaveDirectory + sc[i] + ProjectName + MakeFilePointIndizes(SelectedTile, 2, BigRenderData) + '.*';
      if FindFirst(s, faAnyFile, SR) = 0 then
      repeat
        if MessageDlg('You want to delete:' + #13#10 + SaveDirectory + SR.Name,
                      mtWarning, [mbYes, mbNo], 0) = mrYes then
        begin
          if not DeleteFile(SaveDirectory + SR.Name) then
            ShowMessage('Could not delete ' + SaveDirectory + SR.Name);
        end;
      until FindNext(SR) <> 0;
    end;
    ScanProjectFolder;
end;

procedure TTilingForm.Image1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var p2: TPoint;
begin
    if Button = mbRight then
    begin
      SelectedTile := GetImageTilePos(x, y);
      ileXY1.Caption := 'Tile: X=' + IntToStr(SelectedTile.X) +
                             ' Y=' + IntToStr(SelectedTile.Y);
      if TileRendered(SelectedTile.X, SelectedTile.Y) then
      begin
        Renderthistile1.Caption := 'Render this tile again';
        Deletethistilesfiles1.Enabled := True;
      end else begin
        Renderthistile1.Caption := 'Render this tile';
        Deletethistilesfiles1.Enabled := False;
      end;
      p2 := Image1.ClientToScreen(Point(X, Y));
      PopupMenu1.Popup(p2.X, p2.Y);
    end;
end;

procedure TTilingForm.CheckBox6Click(Sender: TObject);
begin
    if CheckBox6.Checked then CheckBox4.Checked := False;
end;

procedure TTilingForm.CheckBox4Click(Sender: TObject);
begin
    if CheckBox4.Checked then CheckBox6.Checked := False;
end;

end.
