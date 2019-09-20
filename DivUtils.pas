unit DivUtils;

interface

uses FileHandling, TypeDefinitions, Math3D, StdCtrls, Types, Classes, Windows;

type
  TRegisters = record
    RegEAX, RegEBX, RegECX, RegEDX: Integer;
  end;
  TP6 = array[0..6] of Pointer;
procedure SaveHeaderPointers(Header: TPMandHeader10; var p6: TP6);
procedure InsertHeaderPointers(Header: TPMandHeader10; const p6: TP6);
procedure CPU_Supported;
function StrToIntTrim(s: String): Integer;
function ThreeBytesTo4Chars(PB: PByte): AnsiString;
function FourCharsTo3Bytes(s: AnsiString; var i: Integer): LongBool;
function StrToFloatK(S: String): Double;
function NonZero(d: Double): Double;
function StrLastWord(S: String): String;
function StrLastWords(S: String): String;
function StrFirstWord(S: String): String;
function StrFirstWordAfterEqual(S: String): String;
function FloatToStrSingle(s: Single): String;
function ShortFloatToStr(sf: ShortFloat): String;
function PhysikMemAvail: Cardinal;
procedure Delay(Milliseconds: Integer);
function getHiQmillis: Double;
function UpCaseN(s: String; n: Integer): String;
function SwapColor(C: Cardinal): Cardinal;
function StrSecondWord(S: String): String;
function IntToTimeStr(i: Integer): String;
function StrToFloatKtry(S: String; var d: Double): LongBool;
function CustomFtoStr(cf: array of Byte): AnsiString;
procedure PutStringInCustomF(var cf: array of Byte; s: AnsiString);
function NumberOfCPUs: Integer;
function StrOnlyNumbers(S: String): String;
function GetZPos(x, y: Integer; Header: TPMandHeader10; SL: TPSiLight5): Double;
function AllAutoProcessings(Header: TPMandHeader10): Integer;
function cIpol2colFlip(Col1, Col2: Cardinal; w1: Single): Cardinal;
procedure CalcStepWidth(Header: TPMandHeader10);
procedure CalcRealPosOffsetsFromImagePos(x, y: Integer; Header: TPMandHeader10; SL: TPSiLight5; Pos3: TPPos3D);
procedure CalcPPZvals(var Header: TMandHeader10; var Zcorr, ZcMul, ZZstmitDif: Double);
procedure PutStringInLightFilename(var fn: array of Byte; s: AnsiString);
function GetStringFromLightFilename(var fn: array of Byte): AnsiString;
function StepWidthFOV(zz: Double; Header: TPMandHeader10): Double;
function Zdistance(LiPos: TPVec3D; Header: TPMandHeader10): Double;
procedure CalcXYposOfPosLight(pos3: TPVec3D; Header: TPMandHeader10; var X, Y: Double);
function SameCustomFNames(PA1, PA2: PTHeaderCustomAddon; AltNr: Integer): Boolean;
function StrToIntTry(s: String; default: Integer): Integer;
function EditToInt(var E: TEdit; var i: Integer): Boolean;
procedure FastMove(const Source; var Dest; count: Integer);
//function MakeViewVecFromHeader(const x, y: Double; Header: TPMandHeader10): TVec3D;
procedure MinMaxClip15bit(var s: Single; var w: Word);
function CardinalToRGB(c: Cardinal): TRGB;
function RGBtoCardinal(rgb: TRGB): Cardinal;
function RGBtoSVecScale(rgb: TRGB; scale: Single): TSVec;
function SVecToCol(sv: TSVec): Cardinal;
function SVecToColSqrt(sv: TSVec): Cardinal;
function DiscFreeMB(disc: String; var FreeMB: Integer): LongBool;
function ColToSVec(c: Cardinal; bSqr: LongBool): TSVec;
function ColAToSVec(c: Cardinal; bSqr: LongBool): TSVec;
function ColToSVecFlipRBNoScale(c: Cardinal; bSqr: LongBool): TSVec;
function ColToSVecNoScale(c: Cardinal): TSVec;
function ColToSVecScale(c: Cardinal; scale: Single): TSVec;
function RGBColToSVecNoScaleSQR(rgb: TRGB): TSVec;
function RGBColToSVecNoScale(rgb: TRGB): TSVec;
function SVecToColNoScale(sv: TSVec): Cardinal;
function SVecToColNoScaleFlipXZ(var sv: TSVec): Cardinal;
function WordColToSVecScale(w3: TP3word; scale: Single): TSVec;
function WordColToSVecDownScale(w: TP3word): TSVec;
function WordColToSVecFlipRBScale(w3: TP3word; scale: Single; bSqr: LongBool): TSVec;
function SVecToWordCol(sv: TSVec): T3word;
function FlipRBCol(c: Cardinal): Cardinal;
function FlipXZsvec(sv: TSVec): TSVec;
function ColToSVecFlipRBc(c: Cardinal): TSVec;
function DoubleToMCRGB(const d: Double): TRGB;
procedure DoubleToMCRGBv(const d: Double; mcrgb: TPRGB);
procedure SVecToMCRGB(MCrecord: TPMCrecord; Light: TSVec);
function MCRGBToSVec(MCrecord: TPMCrecord): TSVec;
function MCRGBtoDouble(rgb: TPRGB): Double; //24bit to -1..7
function IntToStrL(i, l: Integer): String;
function DVecFromLightPos(var Light: TLight8): TVec3D;
procedure SetLightPosFromDVec(var Light: TLight8; var v: TVec3D);
procedure FlipInt(var i1, i2: Integer);
procedure FlipSingle(var i1, i2: Single);
function THreadPrioToByte(TP: TTHreadPriority): Byte;
function dDateTimeToStr(ms: TDateTime): String;
function ByteToThreadPrio(b: Byte): TTHreadPriority;
procedure BringToFront2(h1: HWND);
procedure GetTilingInfosFromHeader(Header: TPMandHeader10; var TileRect: TRect; var Crop: Integer);
procedure SetTilingInfosInHeader(Header: TPMandHeader10; var BigRenderData: TBigRenderData; TilePos: TPoint);
function GetTileSize(Header: TPMandHeader10): TPoint;
procedure DisableTiling(Header: TPMandHeader10);
procedure GetPaintTileSizes(Header: TPMandHeader10; var wid, hei, Xplus, Yplus: Integer);
function SetThreadExecutionState(esFlags: EXECUTION_STATE): EXECUTION_STATE;
function ProgramVersionStr(const sver: Single;const  subRevision: integer): String;
function D2ByteToStr(b: Byte): String; //0.00 to 2.50
function StrToD2Byte(s: String): Byte;
function DateToStrHistory(dt: TDateTime): String;
function TimeToStrHistory(dt: TDateTime): String;
procedure IniLVal(LVal: TPLightVals);
function MaxOfColor(c: Cardinal): Cardinal;
function TransparencyToColor(I: Cardinal): Cardinal;
function ColToSVecFlipRB_word(w3: TP3word): TSVec;
function CPchangeToDPI(i: Integer): Integer;
function ExtractAuthorsFromPara(para10: TPMandHeader10): AuthorStrings;
procedure InsertAuthorsToPara(Header: TPMandHeader10; var AStr: AuthorStrings);
function CheckAuthorValid(const AStr: String): LongBool;
procedure ConvertNewMCRtoOld(mcrO: TPMCrecord; mcrN: TPMCrecordNew);
function GetFirstNumberFromFilename(S: String): String;

var
    SupportMMX :  Boolean = False;
    SupportSSE :  Boolean = False;
    SupportSSE2:  Boolean = False;
    SupportSSE3:  Boolean = False;
    SupportSSSE3: Boolean = False;
    SupportSSE41: Boolean = False;
    hasSIMDlevel: Integer = 0;
    SIMDbuf: array[0..511] of Byte;
    PAligned16: Pointer;     //for aligned constants to use in SSE2 asm
    HiQCounterMul: Double;
    Fi64: Int64;

implementation

uses SysUtils, Math, formulas, Forms, HeaderTrafos, Mand, Graphics, Maps;

{$CODEALIGN 16}

procedure SaveHeaderPointers(Header: TPMandHeader10; var p6: TP6);
var i: Integer;
begin
    for i := 0 to 5 do p6[i] := Header.PHCustomF[i];
    p6[6] := Header.PCFAddon;
end;

procedure InsertHeaderPointers(Header: TPMandHeader10; const p6: TP6);
var i: Integer;
begin
    for i := 0 to 5 do Header.PHCustomF[i] := p6[i];
    Header.PCFAddon := p6[6];
end;

function CheckAuthorValid(const AStr: String): LongBool;
var i, l, nv: Integer;
begin
    Result := True;
    l := Length(AStr);
    if l = 0 then Exit else if l > 16 then
    begin
      Result := False;
      Exit;
    end;
    nv := 0;
    for i := 1 to l do
      if Ord(AStr[i]) in [32, 48..57, 65..90, 97..122] then Inc(nv);
    Result := nv > (l div 2);
end;

function ExtractAuthorsFromPara(para10: TPMandHeader10): AuthorStrings;
var i, i2, n, bitoffset, byteoffset, bitrest: Integer;
    p: PByte;
begin
    Result[1] := '';
    if para10.MandId < 41 then
    begin
      Result[0] := '?';
      Exit;
    end;
    Result[0] := '';
    for n := 0 to 1 do
    begin
      p := @para10.PHCustomF[0];
      Inc(p, n * 14);
      for i := 0 to 15 do
      begin
        bitoffset := i * 7;
        byteoffset := bitoffset div 8;
        bitrest := bitoffset - byteoffset * 8;
        i2 := (PInteger(Integer(p) + byteoffset)^ shr bitrest) and $7F;
        if i2 = 0 then Break;
        Result[n] := Result[n] + Chr(i2);
      end;
    end;
    if (Result[0] = '') or not CheckAuthorValid(Result[0]) then Result[0] := '?';
    if not CheckAuthorValid(Result[1]) then Result[1] := '';
end;

procedure InsertAuthorsToPara(Header: TPMandHeader10; var AStr: AuthorStrings);
var i2, n, byteindex, ASindex, bitsleft, l: Integer;
    p: PByte;
begin
    Header.MandId := actMandId;
    Header.sM3dVersion := M3dVersion;
    for n := 0 to 1 do
    begin
      p := @Header.PHCustomF[0];
      Inc(p, n * 14);
      l := Length(AStr[n]);
      ASindex := 1;
      bitsleft := 0;
      i2 := 0;
      for byteindex := 0 to 13 do
      begin
        while bitsleft < 8 do
        begin
          if ASindex <= l then
          begin
            i2 := i2 or (Integer(Ord(AStr[n][ASindex]) and $7F) shl bitsleft);
            Inc(ASindex);
            Inc(bitsleft, 7);
          end
          else bitsleft := 200;
        end;
        p^ := i2 and $FF;
        Inc(p);
        i2 := i2 shr 8;
        Dec(bitsleft, 8);
      end;
    end;
end;

function CPchangeToDPI(i: Integer): Integer;
begin
    Result := (i * Screen.PixelsPerInch) div 96;
end;

function TransparencyToColor(I: Cardinal): Cardinal;
begin
    I := I shr 24;
    Result := I or (I shl 8) or (I shl 16);
end;

procedure IniLVal(LVal: TPLightVals);
var i: Integer;
begin
    LVal.iColOnOT := 0;
    for i := 0 to 5 do LVal.iLightOption[i] := 1;
    LVal.PLValigned := TPLValigned((Integer(@LVal.LColSbuf[0]) + 15) and $FFFFFFF0);
    LVal.DiffColLightMap := nil;
    for i := 0 to 5 do LVal.LLightMaps[i] := nil;
end;

function DateToStrHistory(dt: TDateTime): String;
begin
    Result := FormatDateTime('yyyy"-"mm"-"dd', dt);
end;

function TimeToStrHistory(dt: TDateTime): String;
begin
    Result := FormatDateTime('hh"h"nn"m"ss"s"', dt);
end;

function D2ByteToStr(b: Byte): String; //0.00 to 2.50
begin
    Result := IntToStr(b);
    if Length(Result) < 3 then Result := StringOfChar('0', 3 - Length(Result)) + Result;
    Result := Result[1] + '.' + Result[2] + Result[3];
end;

function StrToD2Byte(s: String): Byte;
var d: Double;
begin
    if not TryStrToFloat(Trim(s), d) then d := 0;
    Result := Round(Min0MaxCD(d, 2.5) * 100);
end;

function SetThreadExecutionState(esFlags: EXECUTION_STATE): EXECUTION_STATE;
var
 // _STES: SetThreadExecutionState(esFlags: EXECUTION_STATE): EXECUTION_STATE; stdcall;
  _STES: function(ESFlags: EXECUTION_STATE): EXECUTION_STATE; stdcall;
  K32: HMODULE;
begin
  K32 := GetModuleHandle(PChar('kernel32.dll'));
  @_STES := GetProcAddress(K32, PChar('SetThreadExecutionState'));
  if @_STES <> nil then Result := _STES(esFlags);
end;

procedure GetTilingInfosFromHeader(Header: TPMandHeader10; var TileRect: TRect; var Crop: Integer);
var i: Integer;
    Tcount, Tpos, Tsize: TPoint;
begin
    i := Header.TilingOptions;  //32bits: 1..7:TileCountH 8..14:TileCountW 15..21:TilePosH 22..28:TilePosV 29..30: Downscale(AA)
    Crop := Max(1, (i shr 28) and 3);  //downscale 1..3
    Tcount := Point(i and $7F, (i shr 7) and $7F);
    Tpos := Point((i shr 14) and $7F, (i shr 21) and $7F);
    Tsize := Point(Header.Width div Tcount.X, Header.Height div Tcount.Y);
    TileRect := Rect(Tpos.X * Tsize.X - Crop, Tpos.Y * Tsize.Y - Crop,
          (Tpos.X + 1) * Tsize.X + Crop - 1, (Tpos.Y + 1) * Tsize.Y + Crop - 1);
end;

procedure GetPaintTileSizes(Header: TPMandHeader10; var wid, hei, Xplus, Yplus: Integer);
var i, Crop: Integer;
    Tcount, Tpos, Tsize: TPoint;
begin
    if Header.TilingOptions = 0 then
    begin
      Xplus := 0;
      Yplus := 0;
      wid := Header.Width;
      hei := Header.Height;
    end else begin
      i := Header.TilingOptions;
      Crop := Max(1, (i shr 28) and 3);
      Tcount := Point(i and $7F, (i shr 7) and $7F);
      Tpos := Point((i shr 14) and $7F, (i shr 21) and $7F);
      Tsize := Point(Header.Width div Tcount.X, Header.Height div Tcount.Y);
      Xplus := Tpos.X * Tsize.X - Crop;
      Yplus := Tpos.Y * Tsize.Y - Crop;
      wid := Tsize.X + 2 * Crop;
      hei := Tsize.Y + 2 * Crop;
    end;
end;

function GetTileSize(Header: TPMandHeader10): TPoint;
var Tcount: TPoint;
    Crop: Integer;
begin
    if Header.TilingOptions = 0 then
      Result := Point(Header.Width, Header.Height)
    else
    begin
      Crop := Max(1, (Header.TilingOptions shr 28) and 3);
      Tcount := Point(Header.TilingOptions and $7F, (Header.TilingOptions shr 7) and $7F);
      Result := Point(Header.Width div Tcount.X + 2 * Crop, Header.Height div Tcount.Y + 2 * Crop);
    end;
    Result.X := Max(1, Min(30000, Result.X));
    Result.Y := Max(1, Min(30000, Result.Y));
end;

procedure DisableTiling(Header: TPMandHeader10);
var TileRect: TRect;
    Crop: Integer;
begin
    if Header.TilingOptions <> 0 then
    begin
      GetTilingInfosFromHeader(Header, TileRect, Crop);
      Header.Width := TileRect.Right - TileRect.Left + 1 - 2 * Crop;
      Header.Height := TileRect.Bottom - TileRect.Top + 1 - 2 * Crop;
      Header.TilingOptions := 0;
    end;
end;

procedure SetTilingInfosInHeader(Header: TPMandHeader10; var BigRenderData: TBigRenderData; TilePos: TPoint);
begin
    with BigRenderData do
    begin
      Header.TilingOptions := (brTileCountH and $7F) or ((brTileCountV and $7F) shl 7) or
         ((TilePos.X and $7F) shl 14) or ((TilePos.Y and $7F) shl 21) or ((brDownScale and 3) shl 28);
      Header.Width := brWidth;
      Header.Height := brHeight;
      Header.bImageScale := Max(1, brDownScale);
    end;
end;

procedure BringToFront2(h1: HWND);
//begin
//    SwitchToThisWindow(h1, False);  {x = false: Size unchanged, x = true: normal size}
//function ForceForegroundWindow(h1wnd: THandle): Boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;
  b: LongBool;
begin
  if IsIconic(h1) then ShowWindow(h1, SW_RESTORE);
  if GetForegroundWindow <> h1 then
  begin
    SetFocus(h1);
   // if (Win32Platform = VER_PLATFORM_WIN32_NT)
    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus
    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
      ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
      (Win32MinorVersion > 0)))) then
    begin
      // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
      // Converted to Delphi by Ray Lischner
      // Published in The Delphi Magazine 55, page 16
      b := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID := GetWindowThreadPRocessId(h1, nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then
      begin
        BringWindowToTop(h1); // IE 5.5 related hack
        SetForegroundWindow(h1);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        b := (GetForegroundWindow = h1);
      end;
      if not b then
      begin
        // Code by Daniel P. Stasinski
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0),
          SPIF_SENDCHANGE);
        BringWindowToTop(h1); // IE 5.5 related hack
        SetForegroundWindow(h1);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
      end;
    end
    else
    begin
      BringWindowToTop(h1); // IE 5.5 related hack
      SetForegroundWindow(h1);
    end;
  end;{ ForceForegroundWindow }
end;


function THreadPrioToByte(TP: TTHreadPriority): Byte;
var i: Integer;
begin
    Result := 2;
    for i := 0 to 4 do if TP = cTPrio[i] then
    begin
      Result := i;
      Break;
    end;
end;

function ByteToThreadPrio(b: Byte): TTHreadPriority;
begin
    Result := cTPrio[Min(4, Max(0, b))];
end;

procedure FlipInt(var i1, i2: Integer);
var i: Integer;
begin
    i := i1;
    i1 := i2;
    i2 := i;
end;

procedure FlipSingle(var i1, i2: Single);
var i: Single;
begin
    i := i1;
    i1 := i2;
    i2 := i;
end;

function DVecFromLightPos(var Light: TLight8): TVec3D;
begin
    Result[0] := D7BtoDouble(Light.LXpos);
    Result[1] := D7BtoDouble(Light.LYpos);
    Result[2] := D7BtoDouble(Light.LZpos);
end;

procedure SetLightPosFromDVec(var Light: TLight8; var v: TVec3D);
begin
    Light.LXpos := DoubleToD7B(v[0]);
    Light.LYpos := DoubleToD7B(v[1]);
    Light.LZpos := DoubleToD7B(v[2]);
end;

function MCRGBtoDouble(rgb: TPRGB): Double; //24bit to -1..7  (~400 log)
begin
    Result := (PInteger(rgb)^ and $FFFFFF) * 4.7683718662483612447000291764754e-7 - 1;
    if Result > 2 then Result := Exp(Result - 1) - enat + 2;
end;

function DoubleToMCRGB(const d: Double): TRGB;
var c: Cardinal;
    dt: Double;
begin
    if d > 2 then dt := Ln(d - 2 + enat) + 2 else dt := d + 1;
    c := Round(Min0MaxCD(dt, 8) * 2097151.875);
    PWord(@Result)^ := c and $FFFF;
    Result[2] := (c shr 16) and $FF;
end;

procedure DoubleToMCRGBv(const d: Double; mcrgb: TPRGB);
var c: Cardinal;
    dt: Double;
begin
    if d > 2 then dt := Ln(d - 2 + enat) + 2 else dt := d + 1;
    c := Round(Min0MaxCD(dt, 8) * 2097151.875);
    PCardinal(mcrgb)^ := (PCardinal(mcrgb)^ and $FF000000) or (c and $FFFFFF);
end;

 { TMCrecord = packed record
    Red, Green, Blue: TRGB;   //Each of them 24 bit: float 0..4 (-1..7)? stretched to 24 bit int
    Ysum, Ysqr: TRGB;         //15 bytes  ..U,V,Ysum instead... 3 bytes left for Zdepth as Word + Options as word
    RayCount: Word;                        //u,v as smallint + Zdepth as Cardinal?
    Zbyte: Byte;              //18 bytes
  end;
  TPMCrecord = ^TMCrecord;
  TMCrecordNew = packed record
    U, V: SmallInt;           //4 bytes -32.768..32.767  (* 0.001)
    Ysum, Ysqr: TRGB;         //10 bytes
    wRayCount: Word;          //12 bytes
    cZpos: Cardinal;          //16 bytes
    wStats: Word;             //18 bytes
  end;  }

procedure ConvertNewMCRtoOld(mcrO: TPMCrecord; mcrN: TPMCrecordNew);
var vec: TVec3D;
begin
    mcrO.Ysum := mcrN.Ysum;
    mcrO.Ysqr := mcrN.Ysqr;
    mcrO.RayCount := mcrN.wRayCount;
    vec[0] := MCRGBtoDouble(@mcrN.Ysum);
    vec[1] := SignedSqr(mcrN.U * 0.001);
    vec[2] := SignedSqr(mcrN.V * 0.001);
    YUV2RGBd(@vec);
    DoubleToMCRGBv(vec[0], @mcrO.Red);
    DoubleToMCRGBv(vec[1], @mcrO.Green);
    DoubleToMCRGBv(vec[2], @mcrO.Blue);
    mcrO.Zbyte := 128;
    if mcrN.cZpos = $FFFFFFFF then mcrO.Zbyte := 0;
end;

function NoiseOfMCRGB(MCrecord: TPMCrecord): Double;
var dTmp: Double;
begin
    if MCrecord.RayCount = 0 then Result := 0 else
    begin
      dTmp := MCRGBtoDouble(@MCrecord.Ysum);
      Result := (MCRGBtoDouble(@MCrecord.Ysqr) - Sqr(dTmp)) / (MaxCD(0.01, dTmp) * MCrecord.RayCount);
    end;
end;

procedure SVecToMCRGB(MCrecord: TPMCrecord; Light: TSVec);
begin
    DoubleToMCRGBv(Light[0], @MCrecord.Red);
    DoubleToMCRGBv(Light[1], @MCrecord.Green);
    DoubleToMCRGBv(Light[2], @MCrecord.Blue);
end;

function MCRGBToSVec(MCrecord: TPMCrecord): TSVec;
begin
    Result[0] := MCRGBtoDouble(@MCrecord.Red);
    Result[1] := MCRGBtoDouble(@MCrecord.Green);
    Result[2] := MCRGBtoDouble(@MCrecord.Blue);
    Result[3] := 0;
end;

function dDateTimeToStr(ms: TDateTime): String;
var i: Integer;
begin
    i := Trunc(ms);
    if i >= 1 then
      Result := IntToStr(i) + FormatDateTime('"d"h"h"nn"m"', ms)
    else
      Result := FormatDateTime('h"h"nn"m"ss"s"', ms); // 'h:nn:ss'
end;

function ColToSVecFlipRBc(c: Cardinal): TSVec;
{begin
    Result[0] := ((c shr 16) and $FF);
    Result[1] := ((c shr 8) and $FF);
    Result[2] := (c and $FF);    }
asm
    add  esp, -4
    mov  ecx, eax
    shr  ecx, 16
    and  ecx, $FF
    mov  [esp], ecx
    fild dword [esp]
    fstp dword [edx]
    mov  ecx, eax
    shr  ecx, 8
    and  ecx, $FF
    mov  [esp], ecx
    fild dword [esp]
    fstp dword [edx + 4]
    and  eax, $FF
    mov  [esp], eax
    fild dword [esp]
    fstp dword [edx + 8]
    pop  edx  
end;

function ColToSVecFlipRB_word(w3: TP3word): TSVec;
begin
    Result[0] := w3[2];
    Result[1] := w3[1];
    Result[2] := w3[0];
end;
{asm
    add  esp, -4
    mov  ecx, eax
    shr  ecx, 16
    and  ecx, $FF
    mov  [esp], ecx
    fild dword [esp]
    fstp dword [edx]
    mov  ecx, eax
    shr  ecx, 8
    and  ecx, $FF
    mov  [esp], ecx
    fild dword [esp]
    fstp dword [edx + 4]
    and  eax, $FF
    mov  [esp], eax
    fild dword [esp]
    fstp dword [edx + 8]
    pop  edx
end;    }

function ColAToSVecFlipRBc(c: Cardinal): TSVec;
{begin
    Result[0] := (c shr 16) and $FF;
    Result[1] := (c shr 8) and $FF;
    Result[2] := c and $FF);
    Result[3] := c shr 24;   }
asm
    mov  ecx, eax
    shr  ecx, 24
    push ecx
    fild dword [esp]
    fstp dword [edx + 12]
    mov  ecx, eax
    shr  ecx, 16
    and  ecx, $FF
    mov  [esp], ecx
    fild dword [esp]
    fstp dword [edx]
    mov  ecx, eax
    shr  ecx, 8
    and  ecx, $FF
    mov  [esp], ecx
    fild dword [esp]
    fstp dword [edx + 4]
    and  eax, $FF
    mov  [esp], eax
    fild dword [esp]
    fstp dword [edx + 8]
    pop  edx
end;

function DiscFreeMB(disc: String; var FreeMB: Integer): LongBool;
var FreeAvailable,  TotalSpace, TotalFree: TLargeInteger;
    pc: array[0..2] of Char;
begin
    StrPCopy(pc, Copy(disc, 1, 2)); //'C:';
    Result := GetDiskFreeSpaceEx(pc, FreeAvailable,  TotalSpace, @TotalFree);
    if Result then
      FreeMB := TotalSpace div (1024 * 1024);
end;

function FlipXZsvec(sv: TSVec): TSVec;
begin
    Result[0] := sv[2];
    Result[1] := sv[1];
    Result[2] := sv[0];
    Result[3] := sv[3];
end;

function FlipRBCol(c: Cardinal): Cardinal;
begin
    Result := ((c and $FF) shl 16) or (c and $FF00) or ((c shr 16) and $FF);
end;

function ColToSVec(c: Cardinal; bSqr: LongBool): TSVec;
begin
    if bSqr then
    begin
      Result[0] := Sqr(c and $FF) * 0.0000153787;          // 0.0000304;
      Result[1] := Sqr((c shr 8) and $FF) * 0.0000153787;
      Result[2] := Sqr((c shr 16) and $FF) * 0.0000153787;
    end else begin
      Result[0] := (c and $FF) * s1d255;
      Result[1] := ((c shr 8) and $FF) * s1d255;
      Result[2] := ((c shr 16) and $FF) * s1d255;
    end;
    Result[3] := 0;
end;

function ColAToSVec(c: Cardinal; bSqr: LongBool): TSVec;
begin
    if bSqr then
    begin
      Result[0] := Sqr(c and $FF) * 0.0000153787;
      Result[1] := Sqr((c shr 8) and $FF) * 0.0000153787;
      Result[2] := Sqr((c shr 16) and $FF) * 0.0000153787;
      Result[3] := Sqr(c shr 24) * 0.0000153787;
    end else begin
      Result[0] := (c and $FF) * s1d255;
      Result[1] := ((c shr 8) and $FF) * s1d255;
      Result[2] := ((c shr 16) and $FF) * s1d255;
      Result[3] := (c shr 24) * s1d255;
    end;
end;

function ColToSVecScale(c: Cardinal; scale: Single): TSVec;
begin
    Result[0] := (c and $FF) * scale;
    Result[1] := ((c shr 8) and $FF) * scale;
    Result[2] := ((c shr 16) and $FF) * scale;
    Result[3] := 0;
end;

function ColToSVecFlipRBNoScale(c: Cardinal; bSqr: LongBool): TSVec;
begin
    if bSqr then
    begin
      Result[0] := Sqr((c shr 16) and $FF) * s1d255;
      Result[1] := Sqr((c shr 8) and $FF) * s1d255;
      Result[2] := Sqr(c and $FF) * s1d255;
    end else begin
      Result[0] := (c shr 16) and $FF;
      Result[1] := (c shr 8) and $FF;
      Result[2] := c and $FF;
    end;
    Result[3] := 0;
end;

function ColToSVecNoScale(c: Cardinal): TSVec;
begin
    Result[0] := c and $FF;
    Result[1] := (c shr 8) and $FF;
    Result[2] := (c shr 16) and $FF;
    Result[3] := 0;
end;

function WordColToSVecScale(w3: TP3word; scale: Single): TSVec;
begin
    Result[0] := w3[0] * scale;  //.. in x87
    Result[1] := w3[1] * scale;
    Result[2] := w3[2] * scale;
end;

function WordColToSVecFlipRBScale(w3: TP3word; scale: Single; bSqr: LongBool): TSVec;
begin
    if bSqr then
    begin
      Result[0] := Sqr(w3[2] * d1d65535) * scale;
      Result[1] := Sqr(w3[1] * d1d65535) * scale;
      Result[2] := Sqr(w3[0] * d1d65535) * scale;
    end
    else
    begin
      Result[0] := w3[2] * d1d65535 * scale;  //.. in x87
      Result[1] := w3[1] * d1d65535 * scale;
      Result[2] := w3[0] * d1d65535 * scale;
    end;
end;

function WordColToSVecDownScale(w: TP3word): TSVec;
begin
    Result[0] := w[0] * d1d256;
    Result[1] := w[1] * d1d256;
    Result[2] := w[2] * d1d256;
    Result[3] := 0;
end;

function RGBColToSVecNoScale(rgb: TRGB): TSVec;
begin
    Result[0] := rgb[0];
    Result[1] := rgb[1];
    Result[2] := rgb[2];
    Result[3] := 0;
end;

function RGBColToSVecNoScaleSQR(rgb: TRGB): TSVec;
begin
    Result[0] := Sqr(Integer(rgb[0])) * s1d255;
    Result[1] := Sqr(Integer(rgb[1])) * s1d255;
    Result[2] := Sqr(Integer(rgb[2])) * s1d255;
    Result[3] := 0;
end;

function SVecToWordCol(sv: TSVec): T3word;
begin
    Result[0] := Round(sv[0]);
    Result[1] := Round(sv[1]);
    Result[2] := Round(sv[2]);
end;

function SVecToColNoScale(sv: TSVec): Cardinal;
{begin                       // eax      eax
    sv := mMinMaxSVec(0, 255, sv);
    Result := Round(sv[0]) or (Round(sv[1]) shl 8) or (Round(sv[2]) shl 16);  }
asm
  add esp, -16
  push 0
  push $437f0000
  lea edx, [esp + 8]
  call [mMinMaxSVec]
  fld dword [esp]
  fistp word [esp]
  fld dword [esp + 4]
  fistp word [esp + 1]
  fld dword [esp + 8]
  fistp word [esp + 2]
  mov eax, [esp]
  add esp, 16
end;

function SVecToColNoScaleFlipXZ(var sv: TSVec): Cardinal;
{begin                            //eax           eax
    sv := mMinMaxSVec(0, 255, sv);
    Result := Round(sv[2]) or (Round(sv[1]) shl 8) or (Round(sv[0]) shl 16);}
asm
  add esp, -16
  push 0
  push $437f0000
  lea edx, [esp + 8]     //2x pushed, +8 is esp..esp+16 for svec
  call [mMinMaxSVec]     //mMinMaxSVec(const smin, smax: Single; const V1: TSVec): TSVec;   ret8
  fld dword [esp + 8]    //                ebp+12, ebp+8,             eax           edx
  fistp word [esp + 8]
  fld dword [esp + 4]
  fistp word [esp + 9]
  fld dword [esp]
  fistp word [esp + 10]
  mov eax, [esp + 8]
  add esp, 16
end;

function SVecToCol(sv: TSVec): Cardinal;
begin
    Result := Round(Min0MaxCS(sv[2], s255)) or (Round(Min0MaxCS(sv[1], s255)) shl 8) or (Round(Min0MaxCS(sv[0], s255)) shl 16);
end;

function SVecToColSqrt(sv: TSVec): Cardinal;  //not in use
begin
    Result := Round(Sqrt(Min0MaxCS(sv[2], s255) * s255)) or
             (Round(Sqrt(Min0MaxCS(sv[1], s255) * s255)) shl 8) or
             (Round(Sqrt(Min0MaxCS(sv[0], s255) * s255)) shl 16);
end;

function MaxOfColor(c: Cardinal): Cardinal;
begin
    Result := Max(Max(c and 255, (c shr 8) and 255), (c shr 16) and 255);
end;

function CardinalToRGB(c: Cardinal): TRGB;
begin
    Result[0] := c and $FF;
    Result[1] := (c shr 8) and $FF;
    Result[2] := (c shr 16) and $FF;
end;

function RGBtoCardinal(rgb: TRGB): Cardinal;
begin
    Result := rgb[0] or (rgb[1] shl 8) or (rgb[2] shl 16);
end;

function RGBtoSVecScale(rgb: TRGB; scale: Single): TSVec;
begin
    Result[0] := rgb[0] * scale;
    Result[1] := rgb[1] * scale;
    Result[2] := rgb[2] * scale;
    Result[3] := 0;
end;

procedure MinMaxClip15bit(var s: Single; var w: Word);
const s32767: Single = 32767;
asm
   cmp   SupportSSE, 0
   jz    @@1
   movss  xmm0, [eax]
   xorps  xmm1, xmm1
   minss  xmm0, s32767
   maxss  xmm0, xmm1
   cvtss2si eax, xmm0
   mov   word [edx], ax
   ret
@@1:
   fld   dword [eax]
   ftst
   fnstsw ax
   and   ah, 41H
   jz    @biggerThanZero
   fstp  st(0)
   mov   word [edx], 0
   jmp   @e
@biggerThanZero:
   fcom  s32767
   fnstsw ax
   shr   ah, 1
   jc    @SmallerThanS3
   fstp  st(0)
   mov   word [edx], 32767
   jmp   @e
@SmallerThanS3:
   fistp word [edx]
@e:
end;

{function LnXP1(const X: Extended): Extended;
asm
        FLDLN2
        MOV     AX,WORD PTR X+8               // exponent
        FLD     X
        CMP     AX,$3FFD                      // .4225
        JB      @@1
        FLD1
        FADD
        FYL2X
        JMP     @@2
@@1:
        FYL2XP1
@@2:
        FWAIT
end;  }

         // bCalcAmbShadowAutomatic: Byte;    //#149
         // bCalcDOFtype: Byte;               //#181   bit1: calc or not, bit 2+3: passes bit4: function sorted/forward
         // bCalc3D: Byte;                    //#344
function AllAutoProcessings(Header: TPMandHeader10): Integer;  //fill in for each processingtype the bit if enabled
begin                  //bits:
    with Header^ do    //0: not calculating, 1: main calculation, 2: normals On Z, 3: hard shadow, 4: AO, 5: AO2, 6: SelfReflections, 7: DOF (8: repaint)
    begin              //nums:               1                    2                4               8      16      32                  64
      Result := 1;
      if bCalc3D > 0 then
      begin
        if (byCalcNsOnZBufAuto and 1) > 0 then Result := Result or 2;
        if ((bCalculateHardShadow and 1) > 0) and ((bCalculateHardShadow and $FC) > 0) then Result := Result or 4;
        if (bCalcAmbShadowAutomatic and 1) > 0 then Result := Result or 8; 
        if (bCalcSRautomatic and 1) > 0 then Result := Result or 32;
        if (bCalcDOFtype and 1) > 0 then Result := Result or 64;
      end;
    end;
end;

procedure CalcXYposOfPosLight(pos3: TPVec3D; Header: TPMandHeader10; var X, Y: Double);
var dS, dx, dy, dFOV, PlOpticZ: Double;
    n: Integer;
    M: TMatrix3;
    V0, V1, VFOV: TVec3D;
begin
    with Header^ do                  //not working yet
    begin
      dFOV := dFOVy * Pid180;// / Height;
      dx := Min(1.5, Max(0.01, dFOV * 0.5));
      PlOpticZ := Cos(dx) * dx / Sin(dx);
      dS := 2.1345 / (dZoom * Width);
      M := hVGrads;
      NormaliseMatrixTo(dS, @M);
      V0 := GetRealMidPos(Header);
     { V0[0] := dXmid;
      V0[1] := dYmid;
      V0[2] := dZmid; }
      mAddVecWeight(@V0, @M[2], dZstart - dZmid);  //StartPos0
      NormaliseMatrixTo(1, @M);
      X := 0;
      Y := 0;
      n := 50;
      repeat
        V1 := V0;
        mAddVecWeight(@V1, @M[0], X * dS);  //move to xy offsets
        mAddVecWeight(@V1, @M[1], Y * dS);
        V1[0] := pos3[0] - V1[0];          //new vec to light
        V1[1] := pos3[1] - V1[1];
        V1[2] := pos3[2] - V1[2];
        NormaliseVectorVar(V1);
        RotateVectorReverse(@V1, @M);      //rotate back, should then be equal to FOV vector
        if V1[2] < 0.01 then
        begin   //in back of viewer
          X := 0;
          Y := 0;
          Break;
        end;
        dx := Y * dFOV;
        dy := -X * dFOV;
        if (Header.bPlanarOptic and 1) > 0 then
        begin
          VFOV[0] := -dy;
          VFOV[1] := dx;
          VFOV[2] := PlOpticZ;
          NormaliseVectorVar(VFOV);
        end
        else BuildViewVectorDFOV(dx, dy, @VFOV);
        dx := ArcSinSafe(V1[0] - VFOV[0]) * dFOV;
        dy := ArcSinSafe(V1[1] - VFOV[1]) * dFOV;     // angleX := (0.5 * iMandWidth - ix) * FOVy / iMandHeight;  ->  ix := -angleX * Height / FOVy + 0.5 * Width;
        X := X + dx;
        Y := Y + dy;
        if X < -Width then X := -Width else if X > Width then X := Width;
        if Y < -Height then Y := -Height else if Y > Height then Y := Height;
        Dec(n);
      until (n = 0) or (Abs(dx) + Abs(dy) < 0.1);
    end;
end;
               //lightpos, rel. to mid vals!
function Zdistance(LiPos: TPVec3D; Header: TPMandHeader10): Double; // for poslight moving, returns ZZ
var d: Double;
    i: Integer;
    M: TMatrix3;
    V: TVec3D;
begin
    with Header^ do         
    begin
      d := 2.1345 / (dZoom * Width);   //todo: rotate M according to viewvec!
      M := hVGrads;
      NormaliseMatrixTo(d, @M);
     { V[0] := dXmid;
      V[1] := dYmid;
      V[2] := dZmid;  }
      V := cDVec0;
      mAddVecWeight(@V, @M[2], (dZstart - dZmid) / d);
  //    AddVecWeight(@V, @M[0], X);
    //  AddVecWeight(@V, @M[1], Y);
      if Abs(M[2, 1]) > Abs(M[2, 0]) then i := 1 else i := 0;
      if Abs(M[2, 2]) > Abs(M[2, i]) then i := 2;
      Result := MinCD(Max(Width, Height) * 10, MaxCD(1, (LiPos[i] - V[i]) / M[2, i]));
    end;
end;

function StepWidthFOV(ZZ: Double; Header: TPMandHeader10): Double;  //for posLight moving only
begin
    with Header^ do
    begin
      CalcStepWidth(Header);
      Result := dStepWidth * (1 + ZZ * GetDEstopFactor(Header));
    end;
end;

procedure CalcPPZvals(var Header: TMandHeader10; var Zcorr, ZcMul, ZZstmitDif: Double);
begin
    with Header do
    begin
      CalcStepWidth(@Header);
      Zcorr := Sin(Max(dFOVy * Pid180, 1.0) / Height);  //max 1??? = 57.3 deg! -> for nonlinearity of Zbuffer!
      ZcMul := 32767 * 256.0 / (Sqrt((dZend - dZstart) * Zcorr / dStepWidth + 1) - 0.999999999);
      ZZstmitDif := dZstart - dZmid;
    end;
end;

procedure CalcStepWidth(Header: TPMandHeader10);
begin
    with Header^ do dStepWidth := 2.1345 / (dZoom * Width);
end;

function cIpol2colFlip(Col1, Col2: Cardinal; w1: Single): Cardinal;
var w2: Single;
begin
    Clamp01Svar(w1);
    w2 := 1 - w1;
    Result := (Round((Col1 and $FF) * w1 + w2 * (Col2 and $FF)) shl 16) or
             (Round((Col1 and $FF00) * w1 + w2 * (Col2 and $FF00)) and $FF00) or
             (Round((Col1 and $FF0000) * w1 + w2 * (Col2 and $FF0000)) shr 16);
end;

function GetZPos(x, y: Integer; Header: TPMandHeader10; SL: TPSiLight5): Double;   //rel to zstart
var Zcorr, ZcMul, ZZstmitDif: Double;
begin
    CalcPPZvals(Header^, Zcorr, ZcMul, ZZstmitDif);
    with Header^ do
    begin
      if y >= Height then y := Height - 1 else if y < 0 then y := 0;
      if x >= Width then x := Width - 1 else if x < 0 then x := 0;
      Inc(SL, y * Width + x);
      if SL.Zpos > 32767 then Result := dZend - dZstart else
        Result := (Sqr((8388352 - (PInteger(@SL.RoughZposFine)^ shr 8)) / ZcMul + 1) - 1) * dStepWidth / Zcorr;
    end;
end;
                                     //for setting visposlights in image etc, position relativ to midpos
procedure CalcRealPosOffsetsFromImagePos(x, y: Integer; Header: TPMandHeader10; SL: TPSiLight5; Pos3: TPPos3D);
var Zcorr, ZcMul, ZZstmitDif, ZZ: Double;
    x1, y1, z1: Double;
    v: TVec3D;
    m2: TMatrix3;
begin
    CalcPPZvals(Header^, Zcorr, ZcMul, ZZstmitDif);
    with Header^ do
    begin
      if y >= Height then y := Height - 1 else if y < 0 then y := 0;
      if x >= Width then x := Width - 1 else if x < 0 then x := 0;
      Inc(SL, y * Width + x);
      if SL.Zpos > 32767 then ZZ := (dZend - dZstart) / dStepWidth
      else ZZ := (Sqr((8388352 - (PInteger(@SL.RoughZposFine)^ shr 8)) / ZcMul + 1) - 1) / Zcorr;
      m2 := NormaliseMatrixTo(dStepWidth, @hVgrads);
      x1 := x - Width * 0.5;
      y1 := y - Height * 0.5;
      v := CalcViewVecH(x / Width, y / Height, Header);//MakeViewVecFromHeader(x1, y1, Header);
      if bPlanarOptic = 2 then
      begin
        x1 := 0;
        y1 := 0;
      end;      //translate from midPos to startpos plus with viewvec towards ZZ
      z1 := (dZstart - dZmid) / dStepWidth;
      Pos3[0] := z1 * m2[2, 0] + y1 * m2[1, 0] + x1 * m2[0, 0] + ZZ * v[0];
      Pos3[1] := z1 * m2[2, 1] + y1 * m2[1, 1] + x1 * m2[0, 1] + ZZ * v[1];
      Pos3[2] := z1 * m2[2, 2] + y1 * m2[1, 2] + x1 * m2[0, 2] + ZZ * v[2];
    end;
end;

function NumberOfCPUs: Integer;
var si: TSystemInfo;
begin
    GetSystemInfo(si);
    Result := Max(1, si.dwNumberOfProcessors);
end;

function getHiQmillis: Double;
var tmpi64: Int64;
begin
    if (not QueryPerformanceCounter(tmpi64)) or (tmpi64 = 0) then
      Result := GetTickCount
    else
      Result := HiQCounterMul * tmpi64;
end;

{procedure Delay(Milliseconds: Integer);
var
  Tick: Double;
  Event: THandle;
begin
  Tick  := getHiQmillis + Milliseconds;
  Event := CreateEvent(nil, False, False, nil);
  try
    while (Milliseconds > 0) and
          (MsgWaitForMultipleObjects(1, Event, False, Milliseconds, QS_ALLINPUT)
           <> WAIT_TIMEOUT) do
    begin
      Application.ProcessMessages;
      if Application.Terminated then Exit;
      Milliseconds := Round(Tick - getHiQmillis); //timeGetTime
      if Milliseconds > 5000 then Exit;
    end;
  finally
    CloseHandle(Event);
  end;
end;  }

procedure Delay(Milliseconds: Integer);
var
  Tick: Double;
begin
  Tick  := getHiQmillis + Milliseconds;
  try
    while (Milliseconds > 0) and
          (MsgWaitForMultipleObjects(0, Pointer(nil)^, False, Milliseconds, QS_ALLINPUT)
           <> WAIT_TIMEOUT) do
    begin
      Application.ProcessMessages;
      if Application.Terminated then Exit;
      Milliseconds := Round(Tick - getHiQmillis); //timeGetTime
      if Milliseconds > 5000 then Exit;
    end;
  finally
  end;
end;

function SameCustomFNames(PA1, PA2: PTHeaderCustomAddon; AltNr: Integer): Boolean;
var i: Integer;
    pb1, pb2: PByte;
begin
    pb1 := @PA1.Formulas[AltNr].CustomFname[0];
    pb2 := @PA2.Formulas[AltNr].CustomFname[0];
    Dec(pb1);
    Dec(pb2);
    i := 0;
    repeat
      Inc(pb1);
      Inc(pb2);
      Result := pb1^ = pb2^;
      Inc(i);
    until (i > 31) or (pb1^ = 0) or not Result;
end;

function SwapColor(C: Cardinal): Cardinal;
begin
    Result := ((C and $FF) shl 16) or (C and $FF00) or (C shr 16);
end;

function PhysikMemAvail: Cardinal;
var stat: MEMORYSTATUS;
begin
    try
      GlobalMemoryStatus(stat);
      Result := stat.dwAvailPhys;
      if stat.dwAvailVirtual < Result then Result := stat.dwAvailVirtual;
    except
      Result := 0;
    end;
end;

function UpCaseN(s: String; n: Integer): String;
begin
    Result := UpperCase(Copy(s, 1, n));
end;

function EditToInt(var E: TEdit; var i: Integer): Boolean;
var c: Integer;
begin
    Val(Trim(E.Text), i, c);
    Result := c = 0;
    if Result then E.Font.Color := clWindowText else E.Font.Color := clMaroon;
end;

function StrToIntTry(s: String; default: Integer): Integer;
var c: Integer;
begin
    Val(Trim(s), Result, c);
    if c <> 0 then Result := default;
end;

function FloatToStrSingle(s: Single): String;
begin
    Result := FloatToStrF(s, ffGeneral, 6, 1);
end;

function ProgramVersionStr(const sver: Single;const  subRevision: integer): String;
var i: Integer;
    sleft, s: Single;
begin
    sleft := Abs(sver);
    Result := '';
    i := 0;
    while (i < 2) or (sleft > 0.5) do
    begin
      s := Trunc(sleft);
      if (sleft - s) > 0.991 then
      begin
        sleft := sleft + 0.01;
        s := Trunc(sleft);
      end;
      Result := Result + IntToStr(Round(s)) + '.';
      sleft := (sleft - s) * 10;
      Inc(i);
    end;
    if ( Result[Length(Result)] = '.' ) and (subRevision < 1) then
      Delete(Result, Length(Result), 1);
    if subRevision >=1 then begin
      if ( Result[Length(Result)] <> '.' ) then
        Result := Result + '.';
      Result := Result + IntToStr( subRevision );
    end;
end;

function ShortFloatToStr(sf: ShortFloat): String;
begin
    if sf[0] = 0 then Result := '0.0' else
    Result := FormatFloat('#.#', sf[0] * 0.1) + 'e' + IntToStr(sf[1]);
end;

function IntToTimeStr(i: Integer): String;
begin
    if i >= 36000 then Result := FormatDateTime('h:nn:ss', i / 864000)
    else
    if i > 0 then Result := FormatDateTime('n:ss', i / 864000) + '.' + IntToStr(i mod 10)
    else
      Result := '-';
end;

function IntToStrL(i, l: Integer): String;
begin
    Result := IntToStr(i);
    Result := StringOfChar('0', l - Length(Result)) + Result;
end;

function CustomFtoStr(cf: array of Byte): AnsiString;
var i: Integer;
begin
    Result := '';
    i := 0;
    while (i < 32) and (cf[i] > 0) do
    begin
      Result := Result + AnsiChar(cf[i]);
      Inc(i);
    end;
end;

procedure PutStringInCustomF(var cf: array of Byte; s: AnsiString);
var i: Integer;
begin
    for i := 1 to Min(31, Length(s)) do
    begin
      cf[i - 1] := Ord(s[i]);
      cf[i] := 0;
    end;
end;

procedure PutStringInLightFilename(var fn: array of Byte; s: AnsiString);
var i: Integer;
begin
    for i := 1 to Min(24, Length(s)) do
    begin
      fn[i - 1] := Ord(s[i]);
      if i < 24 then fn[i] := 0;
    end;
    if Length(s) > 24 then Mand3DForm.OutMessage('The filename must be 24 or less characters long to be saved.');
end;

function GetStringFromLightFilename(var fn: array of Byte): AnsiString;
var i: Integer;
begin
    Result := '';
    i := 0;
    while (i < 24) and (fn[i] > 0) do
    begin
      Result := Result + AnsiChar(fn[i]);
      Inc(i);
    end;
end;

function NonZero(d: Double): Double;
begin
    if Abs(d) < 1e-40 then Result := 1e-3 else
    if Abs(d) < 1e-3  then Result := Sign(d) * 1e-3 else
    Result := d;
end;

function StrToFloatParsePhiTry(S: String; var dout: Double): LongBool;
var st: String;
    d: Double;
    bDiv: LongBool;
begin
    bDiv := pos('/', S) > 0;
    st := StringReplace(S, '/', '', [rfReplaceAll]);
    st := StringReplace(st, '*', '', [rfReplaceAll]);
    d := 1;
    if pos('PHI', UpperCase(st)) > 0 then
    begin
      d := 1.6180339887;
      st := StringReplace(st, 'phi', '', [rfReplaceAll, rfIgnoreCase]);
    end;
    if pos('PI', UpperCase(st)) > 0 then
    begin
      d := Pi;
      st := StringReplace(st, 'pi', '', [rfReplaceAll, rfIgnoreCase]);
    end;
    st := Trim(st);
    if Length(st) = 0 then
    begin
      Result := d <> 1;
      if Result then dout := d else dout := 0;
    end
    else
    begin
      FormatSettings.DecimalSeparator := '.';
      Result := TryStrToFloat(StringReplace(st, ',', '.', [rfReplaceAll]), dout);
      if not Result then dout := 0 else
      if bDiv then dout := dout / d else dout := dout * d;
    end;
end;

function StrToFloatKtry(S: String; var d: Double): LongBool;
begin
    Result := StrToFloatParsePhiTry(S, d);
end;

function StrToFloatK(S: String): Double;
begin
    StrToFloatParsePhiTry(S, Result);
end;

function StrLastWord(S: String): String;
begin
    Result := S;
    while Pos('=', Result) > 0 do Delete(Result, 1, Pos('=', Result));
    Result := Trim(Result);
    while Pos(' ', Result) > 0 do Delete(Result, 1, Pos(' ', Result));
end;

function StrFirstWordAfterEqual(S: String): String;
begin
    Result := S;
    while Pos('=', Result) > 0 do Delete(Result, 1, Pos('=', Result));
    Result := Trim(StrFirstWord(Result));
end;

function StrLastWords(S: String): String;
begin
    Result := Trim(S);
    Delete(Result, 1, Pos(' ', Result));
    Result := Trim(Result);
end;

function StrFirstWord(S: String): String;
begin
    Result := Trim(S);
    if Pos('=', Result) > 0 then Result := Copy(Result, 1, Pos('=', Result) - 1);
    if Pos(' ', Result) > 0 then Result := Copy(Result, 1, Pos(' ', Result) - 1);
    Result := Trim(Result);
end;

function StrSecondWord(S: String): String;
begin
    Result := Trim(S);
    if Pos(' ', Result) > 0 then Delete(Result, 1, Pos(' ', Result));
    if Pos('=', Result) > 0 then Result := Copy(Result, 1, Pos('=', Result) - 1);
    Result := Trim(Result);
end;

function StrOnlyNumbers(S: String): String;
var i: Integer;
begin
    Result := Trim(S);
    i := 1;
    while i <= Length(Result) do
    begin
      if not (Ord(Result[i]) in [48..57]) then Delete(Result, i, 1) else
      Inc(i);
    end;
end;

function GetFirstNumberFromFilename(S: String): String;
var i: Integer;
begin
    Result := ExtractFilename(S);
    i := 1;
    while i <= Length(Result) do
    begin
      if not (Ord(Result[i]) in [48..57]) then Break;
      Inc(i);
    end;
    Result := Copy(Result, 1, i - 1);
end;

function ThreeBytesTo4Chars(PB: PByte): AnsiString;
var i, j, c: Integer;
begin
    i := Integer(PB^) or (Integer(PByte(Integer(PB) + 1)^) shl 8) +
         (Integer(PByte(Integer(PB) + 2)^) shl 16);
    Result := '';
    for j := 1 to 4 do
    begin
      c := i and $3F;                                //0..63 ->
      if c < 12 then Inc(c, 46) else                 //46..57
      if c < 38 then Inc(c, 53) else Inc(c, 59);     //65..90  97..122
      Result := Result + AnsiChar(c);
      i := i shr 6;
    end;
end;

function FourCharsTo3Bytes(s: AnsiString; var i: Integer): LongBool;
var j, c: Integer;
begin
    i := 0;
    Result := False;
    if Length(s) < 4 then
      Exit;
    for j := 1 to 4 do
    begin
      c := Ord(s[j]);
      if not (c in [46..57, 65..90, 97..122]) then Exit;
      if c > 96 then Dec(c, 59) else
      if c > 64 then Dec(c, 53) else Dec(c, 46);
      i := i + c shl ((j - 1) * 6);
    end;
    Result := True;
end;

function StrToIntTrim(s: String): Integer;
begin
    Result := StrToInt(Trim(s));
end;

function CPUID_Supported: Boolean;
asm
  pushfd
  pop eax
  mov edx, eax
  xor eax, $200000
  push eax
  popfd
  pushfd
  pop eax
  xor eax, edx
  setnz al
end;

function GetCPUID(AInfoRequired: Integer): TRegisters;
asm
  push ebx
  push esi
  mov esi, edx
  cpuid
  mov TRegisters[esi].RegEAX, eax
  mov TRegisters[esi].RegEBX, ebx
  mov TRegisters[esi].RegECX, ecx
  mov TRegisters[esi].RegEDX, edx
  pop esi
  pop ebx
end;

Procedure CPU_Supported;
var LReg: TRegisters;
begin
  try
    if CPUID_Supported then
    begin
      LReg := GetCPUID(1);
      SupportMMX   := (LReg.RegEDX and $800000)  <> 0;
      SupportSSE   := (LReg.RegEDX and $2000000) <> 0;
      SupportSSE2  := (LReg.RegEDX and $4000000) <> 0;
      SupportSSE3  := (LReg.RegECX and 1) <> 0;
      SupportSSSE3 := (LReg.RegECX and $200) <> 0;
      SupportSSE41 := (LReg.RegECX and $80000) <> 0;
      hasSIMDlevel := (Integer(SupportSSE2) and 1) or ((Integer(SupportSSE3) and 1) shl 1)
        or ((Integer(SupportSSSE3) and 1) shl 2) or ((Integer(SupportSSE41) and 1) shl 3);
    end;
  except
  end;
end;

procedure FastMove(const Source; var Dest; count: Integer);
asm
  cmp     eax, edx
  je      @@Exit
  cmp     ecx, 32
  ja      @@LargeMove  //Count > 32 or Count < 0
  sub     ecx, 8
  jg      @@SmallMove
@@TinyMove:            //0..8 Byte Move
  jmp     dword [@@JumpTable + 32 + ecx * 4]
@@SmallMove:           //9..32 Byte Move
  fild    qword [eax + ecx]
  fild    qword [eax]
  cmp     ecx, 8
  jle     @@Small16
  fild    qword [eax + 8]
  cmp     ecx, 16
  jle     @@Small24
  fild    qword [eax + 16]
  fistp   qword [edx + 16]
@@Small24:
  fistp   qword [edx + 8]
@@Small16:
  fistp   qword [edx]
  fistp   qword [edx + ecx]
@@Exit:
  ret
  nop                 //4-Byte Align JumpTable
  nop
@@JumpTable:
  dd      @@Exit, @@M01, @@M02, @@M03, @@M04, @@M05, @@M06, @@M07, @@M08
@@LargeForwardMove:
  push    edx
  fild    qword [eax]
  lea     eax, [eax + ecx - 8]
  lea     ecx, [ecx + edx - 8]
  fild    qword [eax]                        //fp stack check error
  push    ecx
  neg     ecx
  and     edx, -8
  lea     ecx, [ecx + edx + 8]
  pop     edx
@FwdLoop:
  fild    qword [eax + ecx]
  fistp   qword [edx + ecx]
  add     ecx, 8
  jl      @FwdLoop
  fistp   qword [edx]
  pop     edx
  fistp   qword [edx]
  ret
@@LargeMove:
  jng     @@LargeDone  // Count < 0
  cmp     eax, edx
  ja      @@LargeForwardMove
  sub     edx, ecx
  cmp     eax, edx
  lea     edx, [edx + ecx]
  jna     @@LargeForwardMove
  sub     ecx, 8
  push    ecx
  fild    qword [eax + ecx]
  fild    qword [eax]
  add     ecx, edx
  and     ecx, -8
  sub     ecx, edx
@BwdLoop:
  fild    qword [eax + ecx]
  fistp   qword [edx + ecx]
  sub     ecx, 8
  jg      @BwdLoop
  pop     ecx
  fistp   qword [edx]
  fistp   qword [edx + ecx]
@@LargeDone:
  ret
@@M01:
  movzx   ecx, [eax]
  mov     [edx], cl
  ret
@@M02:
  movzx   ecx, word [eax]
  mov     [edx], cx
  ret
@@M03:
  mov     cx, [eax]
  mov     al, [eax + 2]
  mov     [edx], cx
  mov     [edx + 2], al
  ret
@@M04:
  mov     ecx, [eax]
  mov     [edx], ecx
  ret
@@M05:
  mov     ecx, [eax]
  mov     al, [eax + 4]
  mov     [edx], ecx
  mov     [edx + 4], al
  ret
@@M06:
  mov     ecx, [eax]
  mov     ax, [eax + 4]
  mov     [edx], ecx
  mov     [edx + 4], ax
  ret
@@M07:
  mov     ecx, [eax]
  mov     eax, [eax + 3]
  mov     [edx], ecx
  mov     [edx + 3], eax
  ret
@@M08:
  fild    qword [eax]
  fistp   qword [edx]
end;


Initialization

  CPU_Supported;

 // SupportSSE := False; //for testing
  //SupportSSE2 := False; //for testing

  PAligned16 := Pointer((Cardinal(@SIMDbuf[0]) + 127) and $FFFFFFF0);
  PDouble(Cardinal(PAligned16) - 8)^    := 0.5;          //general SmoothIt calculation
  PInt64(PAligned16)^                   := $7FFFFFFFFFFFFFFF;  // AND mask for Abs(Double)
  PInt64(Cardinal(PAligned16) + 8)^     := $7FFFFFFFFFFFFFFF;
  PDouble(Cardinal(PAligned16) + 16)^   := -2.0;
  PDouble(Cardinal(PAligned16) + 24)^   := 1e-100;
  PDouble(Cardinal(PAligned16) + 32)^   := 1.0;          //all for cube
  PDouble(Cardinal(PAligned16) + 40)^   := 1.0;
  PDouble(Cardinal(PAligned16) + 48)^   := -1.0;
  PDouble(Cardinal(PAligned16) + 56)^   := -1.0;
  PDouble(Cardinal(PAligned16) + 64)^   := 2.0;
  PDouble(Cardinal(PAligned16) + 72)^   := 2.0;
  PInt64(Cardinal(PAligned16) + 80)^    := $8000000000000000;  // XOR mask for Inverting(Double)
  PInt64(Cardinal(PAligned16) + 88)^    := $8000000000000000;
  PDouble(Cardinal(PAligned16) + 96)^   := -1.0;         // for quats
  PDouble(Cardinal(PAligned16) + 104)^  := 2.0;
  PDouble(Cardinal(PAligned16) + 112)^  := 0.5;
  PDouble(Cardinal(PAligned16) + 120)^  := 3.0;
  PDouble(Cardinal(PAligned16) + 128)^  := 4.0;
  PDouble(Cardinal(PAligned16) + 136)^  := 5.0;
  PDouble(Cardinal(PAligned16) + 144)^  := 6.0;
  PDouble(Cardinal(PAligned16) + 152)^  := 7.0;
  PDouble(Cardinal(PAligned16) + 160)^  := 8.0;
  PDouble(Cardinal(PAligned16) + 168)^  := 10.0;
  PDouble(Cardinal(PAligned16) + 176)^  := 15.0;
  PDouble(Cardinal(PAligned16) + 184)^  := 21.0;
  PDouble(Cardinal(PAligned16) + 192)^  := 28.0;
  PDouble(Cardinal(PAligned16) + 200)^  := 35.0;
  PDouble(Cardinal(PAligned16) + 208)^  := 70.0;

  {$IFNDEF DEBUG}
    set8087cw($133F);  // mask floating point errors
  {$ENDIF}

  if SupportSSE2 then
  begin
    fIsMemberAlternating := doHybridSSE2;
    fIsMemberAlternatingDE := doHybridDESSE2;
    fIsMemberAlternating4D := doHybrid4DSSE2;
    fIsMemberIpol := doInterpolHybridSSE2;
    fIsMemberIpolDE := doInterpolHybridDESSE2;
    fHybridCubeDE := HybridCubeSSE2DE;
    fHybridCube := HybridCubeSSE2;
    fHybridQuat := HybridQuatSSE2;
    fHybridItIntPow2 := HybridItIntPow2SSE2;
    fHIntFunctions[2] := HybridItIntPow2SSE2;
  end;

  QueryPerformanceFrequency(Fi64);
  if Fi64 = 0 then HiQCounterMul := 1e-3 else
  HiQCounterMul := 1000 / Fi64;

end.
