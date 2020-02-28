unit ZBuf16BitGen;

interface

uses
  Windows, SysUtils, Classes, Vcl.Graphics, Math;

type
  TZBufInfo = packed record
    MinRawZValue, MaxRawZValue: double;
    MinZValue, MaxZValue: Integer;
    MinClampedZValue, MaxClampedZValue: Integer;
  end;
  TPZBufInfo = ^TZBufInfo;

procedure MakeZbufPGM(const BMP: TBitmap;var PGMBuffer: PWord; const ZOffset, ZScale: double; const InvertZBuffer:boolean; const PInfo: TPZBufInfo);
procedure SaveZBufPNG16(const FileName: string; const ZOffset, ZScale: double; const InvertZBuffer:boolean);
function CreateZBuf8Bit(const ZOffset, ZScale: double): TBitmap;
function CreateZBuf16BitPreview(const ZOffset, ZScale: double; const InvertZBuffer:boolean; const PInfo: TPZBufInfo): TBitmap;
procedure ConvertPGMToPNG(const Filename: string);
procedure GuessParamsFromInfo(const PInfo: TPZBufInfo; var ZScale, ZOffset: double);

implementation

uses
  Types, Mand, DivUtils, PNMWriter, FileHandling, ImageProcess, HeaderTrafos,
  TypeDefinitions, Forms, ShellApi;

function CreateZBuf8Bit(const ZOffset, ZScale: double): TBitmap;
var
  TileRect: TRect;
  Crop: Integer;
begin
  Result := TBitmap.Create;
  try
    Result.PixelFormat := pf8Bit;
    if Mand3DForm.MHeader.TilingOptions <> 0 then
    begin
      GetTilingInfosFromHeader(@Mand3DForm.MHeader, TileRect, Crop);
      Result.SetSize((TileRect.Right - TileRect.Left + 1 - Crop * 2) div ImageScale,
        (TileRect.Bottom - TileRect.Top + 1 - Crop * 2) div ImageScale);
      Result.Canvas.CopyRect(Rect(0, 0, Result.Width, Result.Height), Mand3DForm.Image1.Picture.Bitmap.Canvas,
           Rect(Crop div ImageScale, Crop div ImageScale,
                Crop div ImageScale + Result.Width, Crop div ImageScale + Result.Height));
    end
    else Result.SetSize(Mand3DForm.Image1.Picture.Width, Mand3DForm.Image1.Picture.Height);
    Make8bitGreyscalePalette(Result);
    MakeZbufBMP(Result);
  except
    Result.Free;
    raise;
  end;
end;

function CreateZBuf16BitPreview(const ZOffset, ZScale: double; const InvertZBuffer:boolean; const PInfo: TPZBufInfo): TBitmap;
var
  PGMBuffer: PWord;
begin
  Result := CreateZBuf8Bit(ZOffset, ZScale);
  try
    MakeZbufPGM(Result, PGMBuffer, ZOffset, ZScale, InvertZBuffer, PInfo);
    FreeMem(PGMBuffer);
  except
    Result.Free;
    raise;
  end;
end;


procedure SaveZBufPNG16(const FileName: string; const ZOffset, ZScale: double; const InvertZBuffer:boolean);
var
  tbmp: TBitmap;
  PGMBuffer: PWord;
  Info: TZBufInfo;
begin
  tbmp := CreateZBuf8Bit(ZOffset, ZScale);
  try
    MakeZbufPGM(tbmp, PGMBuffer, ZOffset, ZScale, InvertZBuffer, @Info);
    try
      with TPGM16Writer.Create do try
        SaveToFile( PGMBuffer, tbmp.Width, tbmp.Height, ChangeFileExtSave(Filename, '.pgm') );
        if ChangeFileExtSave(Filename, '.png') = Filename then
          ConvertPGMToPNG(FileName);
      finally
        Free;
      end;
    finally
      FreeMem(PGMBuffer);
    end;
  finally
    tbmp.Free;
  end;
end;

function GetGrayValueFromZZ(const ZZ, ZScale, ZOffset: double): Integer;
begin
  Result :=  Round((ZZ * ZScale / 1000.0 + ZOffset) * 65535);
end;

procedure GuessParamsFromInfo(const PInfo: TPZBufInfo; var ZScale, ZOffset: double);
var
  MinRawZValue, MaxRawZValue: double;
  MinZValue, MaxZValue: Integer;
begin
  MinRawZValue := PInfo^.MinRawZValue;
  MaxRawZValue := PInfo^.MaxRawZValue;
  MinZValue := 1000;
  MaxZValue := 65535 - 1000;
  ZOffset := (MaxRawZValue * MinZValue - MaxZValue * MinRawZValue) / (MaxRawZValue - MinRawZValue) / 0.65535e5;
  ZScale := 0.200e3 / 0.13107e5 * (MaxZValue - MinZValue) / (MaxRawZValue - MinRawZValue);
end;

procedure MakeZbufPGM(const BMP: TBitmap;var PGMBuffer: PWord; const ZOffset, ZScale: double; const InvertZBuffer:boolean; const PInfo: TPZBufInfo);
var x, y, xx, yy, wid, i, scale, add, add2, ww, ystart, xstart: Integer;
    PB: PByte;
    PW, PW2, PW3: PWord;
    TileRect: TRect;
    Crop: Integer;
    CurrPGMBuffer: PWord;

    iZ0, GrayValue, ClampedGrayValue: Integer;
    ZZ: Double;

    MCTp: TMCTparameter;


    function GetZPosFromSI(const iZ: Integer): Double;
    begin
      with MCTp do begin
        Result := (Sqr((8388351.5 - iZ) / ZcMul + 1) - 1) / Zcorr;
      end;
    end;

    function ClampGrayValue(const GrayValue:Integer):Word;
    begin
      if InvertZBuffer then
        Result := 65535 - Max( Min( GrayValue , 65535), 0)
      else
        Result := Max( Min( GrayValue , 65535), 0);
    end;

    procedure InitInfo;
    begin
      PInfo^.MinRawZValue := MaxDouble;
      PInfo^.MaxRawZValue := MinDouble;
      PInfo^.MinZValue := MAXWORD;
      PInfo^.MaxZValue := 0;
      PInfo^.MinClampedZValue := MAXWORD;
      PInfo^.MaxClampedZValue := 0;
    end;

    procedure UpdateInfo;
    begin
      if ZZ < PInfo^.MinRawZValue then
        PInfo^.MinRawZValue := ZZ
      else if ZZ > PInfo^.MaxRawZValue then
        PInfo^.MaxRawZValue := ZZ;
      if GrayValue < PInfo^.MinZValue then
        PInfo^.MinZValue := GrayValue
      else if GrayValue > PInfo^.MaxZValue then
        PInfo^.MaxZValue := GrayValue;
      if ClampedGrayValue < PInfo^.MinClampedZValue then
        PInfo^.MinClampedZValue := ClampedGrayValue
      else if ClampedGrayValue > PInfo^.MaxClampedZValue then
        PInfo^.MaxClampedZValue := ClampedGrayValue;
    end;

begin
  MCTp := GetMCTparasFromHeader(Mand3DForm.MHeader, True);

  InitInfo;

  GetMem( PGMBuffer, BMP.Width * BMP.Height * SizeOf( Word ) );
  try
    CurrPGMBuffer := PGMBuffer;

    scale := Max(2, Min(10, ImageScale));
    add := 16 * Sqr(scale);
    if Mand3DForm.MHeader.TilingOptions <> 0 then
    begin
      GetTilingInfosFromHeader(@Mand3DForm.MHeader, TileRect, Crop);
      ystart := Crop div ImageScale;
      xstart := Crop;
      add2 := (TileRect.Right - TileRect.Left + 1) * 9;
      ww := (TileRect.Right - TileRect.Left + 1) * ImageScale; //ok?
    end else begin
      ystart := 0;
      xstart := 0;
      add2 := Mand3DForm.MHeader.Width * 9;
      ww := Mand3DForm.MHeader.Width * ImageScale;
    end;
    wid := BMP.Width;
    for y := 0 to BMP.Height - 1 do
    begin
      PB := BMP.ScanLine[y];
      PW := @Mand3DForm.siLight5[(y + ystart) * ww + xstart];

      Inc(PW, 4); //Zpos word
      if ImageScale = 1 then
      begin
        for x := 1 to wid do begin
          if PW^ > 32767 then CurrPGMBuffer^ := 0
          else begin
            iZ0 := PInteger(Longint(PW)-Longint(2))^ shr 8;
            ZZ := GetZPosFromSI(iZ0);
            GrayValue := GetGrayValueFromZZ( ZZ, ZScale, ZOffset );
            ClampedGrayValue := ClampGrayValue(GrayValue);
            UpdateInfo;
            CurrPGMBuffer^ := ClampedGrayValue;
          end;
          PB^ := CurrPGMBuffer^ div 256;
          Inc(CurrPGMBuffer);
          Inc(PB);
          Inc(PW, 9);
        end;
      end else
      begin
        for x := 1 to wid do
        begin
          PW2 := PW;
          i := 0;
          for yy := 1 to scale do
          begin
            PW3 := PW2;
            for xx := 1 to scale do
            begin
              if PW3^ < 32768 then begin
                iZ0 := PInteger(Longint(PW3)-Longint(2))^ shr 8;
                ZZ := GetZPosFromSI(iZ0);
                GrayValue := GetGrayValueFromZZ( ZZ, ZScale, ZOffset );
                ClampedGrayValue := ClampGrayValue(GrayValue);
                UpdateInfo;
                i := i + ClampedGrayValue;
              end;
              Inc(PW3, 9);
            end;
            Inc(PW2, add2);
          end;
          CurrPGMBuffer^ := i div Sqr(scale);
          PB^ := CurrPGMBuffer^ div 256;
          Inc(PB);
          Inc(CurrPGMBuffer);
          Inc(PW, 9 * scale);
        end;
      end
    end;
  except
    FreeMem( PGMBuffer );
    raise;
  end;
end;

//------------------------------------------------------------------------------
// https://stackoverflow.com/questions/1454501/how-do-i-run-a-command-line-program-in-delphi
function GetDosOutput(CommandLine: string; Work: string = 'C:\'): string;  { Run a DOS program and retrieve its output dynamically while it is running. }
var
  SecAtrrs: TSecurityAttributes;
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  pCommandLine: array[0..255] of AnsiChar;
  BytesRead: Cardinal;
  WorkDir: string;
  Handle: Boolean;
begin
  Result := '';
  with SecAtrrs do begin
    nLength := SizeOf(SecAtrrs);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  CreatePipe(StdOutPipeRead, StdOutPipeWrite, @SecAtrrs, 0);
  try
    with StartupInfo do
    begin
      FillChar(StartupInfo, SizeOf(StartupInfo), 0);
      cb := SizeOf(StartupInfo);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdin
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;
    WorkDir := Work;
    Handle := CreateProcess(nil, PChar('cmd.exe /C ' + CommandLine),
                            nil, nil, True, 0, nil,
                            PChar(WorkDir), StartupInfo, ProcessInfo);
    CloseHandle(StdOutPipeWrite);
    if Handle then
      try
        repeat
          WasOK := windows.ReadFile(StdOutPipeRead, pCommandLine, 255, BytesRead, nil);
          if BytesRead > 0 then
          begin
            pCommandLine[BytesRead] := #0;
            Result := Result + pCommandLine;
          end;
        until not WasOK or (BytesRead = 0);
        WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
      finally
        CloseHandle(ProcessInfo.hThread);
        CloseHandle(ProcessInfo.hProcess);
      end;
  finally
    CloseHandle(StdOutPipeRead);
  end;
end;
//------------------------------------------------------------------------------

procedure ConvertPGMToPNG(const Filename: string);
const
  SleepDuration = 100;
  MaxWait=6000;
var
  InputFilename, OutputFilename: string;
  Cmd, Path, CmdResult: string;
  Wait: integer;
begin
  InputFilename := ChangeFileExtSave(Filename, '.pgm');
  OutputFilename := Copy(InputFilename, 1, Length(InputFilename) - 3) + 'png';
  if SysUtils.FileExists(OutputFilename) then
    SysUtils.DeleteFile(OutputFilename);

  if SysUtils.FileExists(OutputFilename) then
    raise Exception.Create('Could not overwrite file <' + OutputFilename + '>');

  Path := IncludeTrailingBackslash( ExtractFilepath( Application.Exename) );
  Cmd := 'java -jar ' + Path +'PNG16Util-1.0-SNAPSHOT.jar ' + InputFilename;
  CmdResult := GetDosOutput(Cmd, Path);
  OutputDebugString(PChar(CmdResult));
  Wait := 0;
  while(Wait<MaxWait) do begin
    Sleep(SleepDuration);
    if SysUtils.FileExists(OutputFilename) then
      break
    else
      Inc(Wait, SleepDuration);
  end;
  if not SysUtils.FileExists(OutputFilename) then begin
    try
      with TStringList.Create do try
        Text := CmdResult;
        SaveToFile(Path+'png_convert_error.txt');
      finally
        Free;
      end;
    except
      // EMPTY
    end;
    raise Exception.Create('Could not execute java to convert pgm to png, so you must convert it manually (See png_convert_error.txt for details).');
  end
  else
    SysUtils.DeleteFile(InputFilename);
end;


end.
