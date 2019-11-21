(*
  BulbTracer2 for MB3D
  Copyright (C) 2016-2019 Andreas Maschke

  This is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser
  General Public License as published by the Free Software Foundation; either version 2.1 of the
  License, or (at your option) any later version.

  This software is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
  even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  Lesser General Public License for more details.
  You should have received a copy of the GNU Lesser General Public License along with this software;
  if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
  02110-1301 USA, or see the FSF site: http://www.fsf.org.
*)
unit MeshIOUtil;

interface

uses Classes, VertexList;

type
  BytePos = (EndVal, ByteVal);
  PEndianCnvDblRec = ^EndianCnvDblRec;
  PEndianCnvSnglRec = ^EndianCnvSnglRec;
  EndianCnvDblRec = packed record
      case pos: BytePos of
        EndVal: (EndianVal: double);
        ByteVal: (Bytes: array[0..SizeOf(Double)-1] of byte);
  end;
  EndianCnvSnglRec = packed record
      case pos: BytePos of
        EndVal: (EndianVal: Single);
        ByteVal: (Bytes: array[0..SizeOf(Single)-1] of byte);
  end;

  TBTraceMainHeader = packed record
    VHeaderWidth, VHeaderHeight: Int32;
    VHeaderZoom, VHeaderZScale: double;
    VResolution, ThreadCount: Int32;
    WithColors: Int32;
    SurfaceDetail: Double;
    TraceXMin, TraceXMax: double;
    TraceYMin, TraceYMax: double;
    TraceZMin, TraceZMax: double;
    CloseMesh: Int32;
  end;
  TPBTraceMainHeader = ^TBTraceMainHeader;

  TBTraceDataHeader = packed record
    TraceOffset: Int32;
    TraceCount: Int32;
    TraceResolution: Int32;
    WithColors: Int32;
  end;
  TPBTraceDataHeader = ^TBTraceDataHeader;

  TBTraceData = packed record
    DE: Single;
    ColorIdx, ColorR, ColorG, ColorB: TColorValue;
  end;
  TPBTraceData = ^TBTraceData;

  TBTracer2Header = packed record
    XOff, YOff, ZOff: Double;
    Scale: Double;
    XAngle, YAngle, ZAngle: Double;
    SurfaceDetail: Double;
    VResolution: Int32;
    WithColors: boolean;
    SaveTypeIndex: Int32;
    MaxPreviewVertices: Int32;
    MandParamsAsString: AnsiString;
    WithOpenGlPreview: boolean;
    PreviewDEstop: double;
    PreviewSizeIdx: Int32;
    WithAutoPreview: boolean;
    OutputFilename: string;
    TraceXMin, TraceXMax: double;
    TraceYMin, TraceYMax: double;
    TraceZMin, TraceZMax: double;
    CloseMesh: boolean;
  end;
  TPBTracer2Header = ^TBTracer2Header;

function SwapEndianInt32(Value: Int32): Int32;
function SwapEndianInt16(Value: Int16): Int16;
procedure SwapBytesSingle( A, B: PEndianCnvSnglRec );

procedure InitBTraceFile(const OutputFilename: string; const PHeader: TPBTraceMainHeader);
procedure LoadMainHeader(const Filename: string; const PHeader: TPBTraceMainHeader );

function TraceDataExists(const Filename: string): boolean;

function CreateTraceFilename(const OutputFilename: string; const ThreadIdx, CurrFileIdx: integer): string;

procedure SaveTraceHeader(const BaseFilename: string; const PHeader: TPBTraceDataHeader);
procedure SaveTraceData(const BaseFilename: string; const BTraceData: TPBTraceData; const PHeader: TPBTraceDataHeader);

procedure LoadTraceHeader(const Filename: string; const PHeader: TPBTraceDataHeader );
procedure LoadTraceData(const Filename: string; var BTraceData: TPBTraceData; const PHeader: TPBTraceDataHeader );

procedure SaveBTracer2Header(const Filename: string; const PHeader: TPBTracer2Header);
procedure LoadBTracer2Header(const Filename: string; const PHeader: TPBTracer2Header );

procedure WriteInt16(const MemStream: TMemoryStream; const Value: Int16);
procedure WriteInt32(const MemStream: TMemoryStream; const Value: Int32);
procedure WriteAnsiString(const MemStream: TMemoryStream; const Value: AnsiString);
procedure WriteString(const MemStream: TMemoryStream; const Value: String);

function ReadInt16(const MemStream: TStream): Int16;
function ReadInt32(const MemStream: TStream): Int32;
function ReadAnsiString(const MemStream: TStream; const Len: Integer): AnsiString;
function ReadString(const MemStream: TStream;const Len: Integer): String;

const
  cBTracer2CacheFileExt = 'btr2cache';
  cBTracer2FileExt = 'btrace2';

implementation

uses
  Windows, Math, DateUtils, ShellApi, SysUtils;

procedure SwapBytesDouble( A, B: PEndianCnvDblRec );
var
  i: integer;
begin
  for i := high(A.Bytes) downto low(A.Bytes) do
    A.Bytes[i] := B.Bytes[High(A.Bytes) - i];
end;

procedure SwapBytesSingle( A, B: PEndianCnvSnglRec );
var
  i: integer;
begin
  for i := high(A.Bytes) downto low(A.Bytes) do
    A.Bytes[i] := B.Bytes[High(A.Bytes) - i];
end;

function SwapEndianInt32(Value: Int32): Int32;
begin
  Result := Swap(Value shr 16) or (longint(Swap(Value and $FFFF)) shl 16);
end;

function SwapEndianInt16(Value: Int16): Int16;
begin
  Result := Swap( Value );
end;

{ ------------------------- Creating Trace Files ----------------------------- }
function CreateTraceFilename(const OutputFilename: string; const ThreadIdx, CurrFileIdx: integer): string;
begin
  Result := IncludeTrailingBackslash(OutputFilename) + Format('part_%s_%s', [Format('%.*d',[2, ThreadIdx]), Format('%.*d',[4, CurrFileIdx])]);
end;

{ ----------------------- Writing  of primitive types ------------------------ }
procedure WriteAnsiString(const MemStream: TMemoryStream; const Value: AnsiString);
begin
  MemStream.WriteData(PAnsiChar(Value), Length(Value));
end;

procedure WriteString(const MemStream: TMemoryStream; const Value: String);
begin
  MemStream.WriteData(PChar(Value), Length(Value) * SizeOf(Char));
end;

procedure WriteNullTerminatedString(const MemStream: TMemoryStream; const Value: AnsiString);
begin
  MemStream.WriteData(PAnsiChar(Value), Length(Value));
  MemStream.WriteData(0, 1);
end;

procedure WriteInt32(const MemStream: TMemoryStream; const Value: Int32);
begin
  MemStream.WriteData(SwapEndianInt32(Value), 4);
end;

procedure WriteInt16(const MemStream: TMemoryStream; const Value: Int16);
begin
  MemStream.WriteData(SwapEndianInt16(Value), 2);
end;

procedure WriteSingle(const MemStream: TMemoryStream; const Value: Single);
var
  ASRec, BSRec: EndianCnvSnglRec;
begin
  BSRec.EndianVal := Value;
  SwapBytesSingle( @ASRec, @BSRec );
  MemStream.WriteData(ASRec.EndianVal, 4);
end;

procedure WriteDouble(const MemStream: TMemoryStream; const Value: Single);
var
  ADRec, BDRec: EndianCnvDblRec;
begin
  BDRec.EndianVal := Value;
  SwapBytesDouble( @ADRec, @BDRec );
  MemStream.WriteData(ADRec.EndianVal, 8);
end;

{ ----------------------- Reading  of primitive types ------------------------ }
function ReadAnsiString4(const MemStream: TStream): AnsiString;
var
  Byte5: Array [0..4] of Byte;
begin
  Byte5[4] := 0;
  MemStream.Read(Byte5[0], 4);
  Result := PAnsiChar(@Byte5[0]);
end;

function ReadAnsiString(const MemStream: TStream; const Len: Integer): AnsiString;
var
  Bytes: Array of Byte;
begin
  if Len > 0  then begin
    SetLength(Bytes, Len+1);
    Bytes[Len] := 0;
    MemStream.Read(Bytes[0], Len);
    Result := PAnsiChar(@Bytes[0]);
    SetLength(Bytes, 0);
  end
  else begin
    Result := PAnsiChar('');
  end;
end;

function ReadString4(const MemStream: TStream): String;
var
  Char5: Array [0..4] of Char;
begin
  Char5[4] := #0;
  MemStream.Read(Char5[0], 4 * SizeOf(Char));
  Result := PChar(@Char5[0]);
end;

function ReadString(const MemStream: TStream;const Len: Integer): String;
var
  Chars: Array of Char;
begin
  if Len > 0  then begin
    SetLength(Chars, Len+1);
    Chars[Len] := #0;
    MemStream.Read(Chars[0], Len * SizeOf(Char));
    Result := PChar(@Chars[0]);
    SetLength(Chars, 0);
  end
  else begin
    Result := '';
  end;
end;

procedure SkipBytes(const MemStream: TStream; const Length: Integer);
var
  I, ReadLen: Integer;
  Byte5: Array [0..4] of Byte;
  EOF: boolean;
begin
  for I := 0 to Length - 1 do begin
    ReadLen := MemStream.Read(Byte5[0], 1);
    EOF := ReadLen < 1;
    if EOF then
      break;
  end;
end;

function ReadInt32(const MemStream: TStream): Int32;
var
  Buf: Int32;
  PBuf: Pointer;
  ReadLen: Integer;
  EOF: boolean;
begin
  PBuf := @Buf;
  ReadLen := MemStream.Read(PBuf^, 4);
  EOF := ReadLen < 4;
  if not EOF then
    Result := SwapEndianInt32( Buf )
  else
    Result := 0;
end;

function ReadInt16(const MemStream: TStream): Int16;
var
  Buf: Int16;
  PBuf: Pointer;
  ReadLen: Integer;
  EOF: boolean;
begin
  PBuf := @Buf;
  ReadLen := MemStream.Read(PBuf^, 2);
  EOF := ReadLen < 2;
  if not EOF then
    Result := SwapEndianInt16( Buf )
  else
    Result := 0;
end;

function ReadSingle(const MemStream: TMemoryStream): Single;
var
  ReadLen: Integer;
  PBuf: Pointer;
  ASRec, BSRec: EndianCnvSnglRec;
  EOF: boolean;
begin
  PBuf := @BSRec.EndianVal;
  ReadLen := MemStream.Read(PBuf^, 4);
  EOF := ReadLen < 4;
  if not EOF then begin
    SwapBytesSingle( @ASRec, @BSRec );
    Result := ASRec.EndianVal;
  end
  else
    Result := 0.0;
end;

function ReadDouble(const MemStream: TMemoryStream): Double;
var
  ReadLen: Integer;
  PBuf: Pointer;
  ADRec, BDRec: EndianCnvDblRec;
  EOF: boolean;
begin
  PBuf := @BDRec.EndianVal;
  ReadLen := MemStream.Read(PBuf^, 8);
  EOF := ReadLen < 8;
  if not EOF then begin
    SwapBytesDouble( @ADRec, @BDRec );
    Result := ADRec.EndianVal;
  end
  else
    Result := 0.0;
end;

{ --------------------------- Saving Trace Data ------------------------------ }
function CreateHeaderFilename(const BaseFilename: string): string;
begin
  Result := BaseFilename;
end;

function CreateDataFilename(const BaseFilename: string): string;
begin
  Result := BaseFilename;
end;

procedure ForceRemoveFile(const Filename: string);
const
  MaxRetries = 10;
var
  I: Integer;
begin
  I := 0;
  while SysUtils.FileExists(Filename) and (I < MaxRetries ) do begin
    Sleep(100);
    SysUtils.DeleteFile( Filename );
    Inc(I);
  end;
  if SysUtils.FileExists(Filename) then
    raise Exception.Create('Could not delete file <' + Filename +'>');
end;

procedure CheckThatExistsFile(const Filename: string);
const
  MaxRetries = 10;
var
  I: Integer;
begin
  I := 0;
  while (not SysUtils.FileExists(Filename)) and (I < MaxRetries ) do begin
    Sleep(100);
    Inc(I);
  end;
  if not SysUtils.FileExists(Filename) then
    raise Exception.Create('Could not create file <' + Filename +'>');
end;

procedure SaveTraceHeader(const BaseFilename: string; const PHeader: TPBTraceDataHeader);
var
  Filename: string;
  FileStream: TFileStream;
  MemStream: TMemoryStream;
begin
  Filename := CreateHeaderFilename(BaseFilename);
  ForceRemoveFile(Filename);
  FileStream := TFileStream.Create(Filename, fmCreate);
  try
    MemStream := TMemoryStream.Create;
    try
      WriteAnsiString(MemStream, 'BTH1');
      WriteInt32(MemStream, PHeader^.TraceOffset);
      WriteInt32(MemStream, PHeader^.TraceCount);
      WriteInt32(MemStream, PHeader^.TraceResolution);
      WriteInt32(MemStream, PHeader^.WithColors);
      MemStream.SaveToStream(FileStream);
    finally
      MemStream.Free;
    end;
  finally
    FileStream.Free;
  end;
  CheckThatExistsFile(Filename);
end;

procedure SaveTraceData(const BaseFilename: string; const BTraceData: TPBTraceData; const PHeader: TPBTraceDataHeader);
var
  Filename: string;
  CurrBTraceData: TPBTraceData;
  I: Int32;
  FileStream: TFileStream;
  MemStream: TMemoryStream;
begin
  Filename := CreateDataFilename(BaseFilename);
  // ForceRemoveFile(Filename);
  // appending to the header
  FileStream := TFileStream.Create(Filename, fmOpenReadWrite);
  try
    FileStream.Seek(0, soFromEnd);
    MemStream := TMemoryStream.Create;
    try
      WriteAnsiString(MemStream, 'BTD1');
      CurrBTraceData := BTraceData;
      for I:=0 to PHeader^.TraceCount - 1 do begin
        WriteSingle(MemStream, CurrBTraceData^.DE );
        if PHeader^.WithColors = Ord(True) then begin
          WriteInt16(MemStream, CurrBTraceData^.ColorIdx );
          WriteInt16(MemStream, CurrBTraceData^.ColorR );
          WriteInt16(MemStream, CurrBTraceData^.ColorG );
          WriteInt16(MemStream, CurrBTraceData^.ColorB );
        end;
        Inc(CurrBTraceData);
      end;
      MemStream.SaveToStream(FileStream);
    finally
      MemStream.Free;
    end;
  finally
    FileStream.Free;
  end;
  // CheckThatExistsFile(Filename);
end;

{ --------------------------- Loading Trace Data ----------------------------- }
function TraceDataExists(const Filename: string): boolean;
begin
  Result := SysUtils.FileExists( CreateHeaderFilename( Filename ) );
end;

procedure LoadTraceHeader(const Filename: string; const PHeader: TPBTraceDataHeader );
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(CreateHeaderFilename(Filename), fmOpenRead);
  try
    if ReadAnsiString4(FileStream) <> 'BTH1' then
      raise Exception.Create('Missing <BTH1>-header');
    PHeader^.TraceOffset := ReadInt32(FileStream);
    PHeader^.TraceCount := ReadInt32(FileStream);
    PHeader^.TraceResolution := ReadInt32(FileStream);
    PHeader^.WithColors := ReadInt32(FileStream);
  finally
    FileStream.Free;
  end;
end;

procedure LoadTraceData(const Filename: string; var BTraceData: TPBTraceData; const PHeader: TPBTraceDataHeader);
var
  I, HeaderLen: Int32;
  CurrBTraceData: TPBTraceData;
  MemStream: TMemoryStream;
  FileStream: TFileStream;
begin
  //    WriteAnsiString(MemStream, 'BTH1');
  //    WriteInt32(MemStream, PHeader^.TraceOffset);
  //    WriteInt32(MemStream, PHeader^.TraceCount);
  //    WriteInt32(MemStream, PHeader^.TraceResolution);
  //    WriteInt32(MemStream, PHeader^.WithColors);
  HeaderLen := 4 *SizeOf(Byte) + 4 * SizeOf(Int32);

  FileStream := TFileStream.Create(CreateDataFilename(Filename), fmOpenRead);
  try
    MemStream := TMemoryStream.Create;
    try
      MemStream.LoadFromStream(FileStream);
      MemStream.Seek(HeaderLen, soFromBeginning);

      if ReadAnsiString4(MemStream) <> 'BTD1' then
        raise Exception.Create('Missing <BTD1>-header');
      GetMem( BTraceData, PHeader^.TraceCount * SizeOf( TBTraceData ) );
      CurrBTraceData := BTraceData;
      try
        for I:=0 to PHeader^.TraceCount - 1 do begin
          CurrBTraceData^.DE := ReadSingle(MemStream);
          if PHeader^.WithColors = Ord(True) then begin
            CurrBTraceData^.ColorIdx := ReadInt16(MemStream);
            CurrBTraceData^.ColorR := ReadInt16(MemStream);
            CurrBTraceData^.ColorG := ReadInt16(MemStream);
            CurrBTraceData^.ColorB := ReadInt16(MemStream);
          end
          else begin
            CurrBTraceData^.ColorIdx := 0;
            CurrBTraceData^.ColorR := 0;
            CurrBTraceData^.ColorG := 0;
            CurrBTraceData^.ColorB := 0;
          end;
          Inc(CurrBTraceData);
        end;
      except
        FreeMem( BTraceData );
        raise;
      end;
    finally
      MemStream.Free;
    end;
  finally
    FileStream.Free;
  end;
end;

{ --------------------------- Init Trace Data -------------------------------- }
function CreateMainHeaderFilename(const OutputFilename: string): string;
begin
  Result := IncludeTrailingBackslash(OutputFilename)+'btracer2.h';
end;


procedure InitBTraceFile( const OutputFilename: string; const PHeader: TPBTraceMainHeader );
var
  Filename: string;
  FileStream: TFileStream;
  MemStream: TMemoryStream;

  procedure DeleteDirectory(const DirName: string);
  var
    FileOp: TSHFileOpStruct;
  begin
    FillChar(FileOp, SizeOf(FileOp), 0);
    FileOp.wFunc := FO_DELETE;
    FileOp.pFrom := PChar(DirName+#0);//double zero-terminated
    FileOp.fFlags := FOF_SILENT or FOF_NOERRORUI or FOF_NOCONFIRMATION;
    if SHFileOperation(FileOp) <> 0 then
      raise Exception.Create('Error cleaning up directory <'+DirName+'>');
  end;

begin
 if DirectoryExists( OutputFilename ) then
   DeleteDirectory( OutputFilename );
  if not ForceDirectories( OutputFilename ) then begin
    // another thread might have created the directory in the meanwhile
    if not DirectoryExists( OutputFilename ) then
      raise Exception.Create(Format('Could not create folder <%s>', [OutputFilename]));
  end;
  Filename := CreateMainHeaderFilename(OutputFilename);
  ForceRemoveFile(Filename);
  FileStream := TFileStream.Create(Filename, fmCreate);
  try
    MemStream := TMemoryStream.Create;
    try
      WriteAnsiString(MemStream, 'BTM2');
      WriteInt32(MemStream, PHeader^.VHeaderWidth);
      WriteInt32(MemStream, PHeader^.VHeaderHeight);
      WriteDouble(MemStream, PHeader^.VHeaderZoom);
      WriteDouble(MemStream, PHeader^.VHeaderZScale);
      WriteInt32(MemStream, PHeader^.VResolution);
      WriteInt32(MemStream, PHeader^.ThreadCount);
      WriteInt32(MemStream, PHeader^.WithColors);
      WriteDouble(MemStream, PHeader^.SurfaceDetail);
      WriteDouble(MemStream, PHeader^.TraceXMin);
      WriteDouble(MemStream, PHeader^.TraceXMax);
      WriteDouble(MemStream, PHeader^.TraceYMin);
      WriteDouble(MemStream, PHeader^.TraceYMax);
      WriteDouble(MemStream, PHeader^.TraceZMin);
      WriteDouble(MemStream, PHeader^.TraceZMax);
      WriteInt32(MemStream, Ord(PHeader^.CloseMesh));
      MemStream.SaveToStream(FileStream);
    finally
      MemStream.Free;
    end;
  finally
    FileStream.Free;
  end;
  CheckThatExistsFile(Filename);
end;


procedure LoadMainHeader(const Filename: string; const PHeader: TPBTraceMainHeader );
var
  HeaderId: AnsiString;
  MemStream: TMemoryStream;
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(CreateMainHeaderFilename(Filename), fmOpenRead);
  try
    MemStream := TMemoryStream.Create;
    try
      MemStream.LoadFromStream(FileStream);
      MemStream.Seek(0, soFromBeginning);
      HeaderId := ReadAnsiString4(MemStream);
      if ( HeaderId <> 'BTM1' ) and ( HeaderId <> 'BTM2' ) then
        raise Exception.Create('Missing <BTM1/2>-header');
      PHeader^.VHeaderWidth := ReadInt32(MemStream);
      PHeader^.VHeaderHeight := ReadInt32(MemStream);
      PHeader^.VHeaderZoom := ReadDouble(MemStream);
      PHeader^.VHeaderZScale := ReadDouble(MemStream);
      PHeader^.VResolution := ReadInt32(MemStream);
      PHeader^.ThreadCount := ReadInt32(MemStream);
      PHeader^.WithColors := ReadInt32(MemStream);
      PHeader^.SurfaceDetail := ReadDouble(MemStream);
      PHeader^.TraceXMin := ReadDouble(MemStream);
      PHeader^.TraceXMax := ReadDouble(MemStream);
      PHeader^.TraceYMin := ReadDouble(MemStream);
      PHeader^.TraceYMax := ReadDouble(MemStream);
      PHeader^.TraceZMin := ReadDouble(MemStream);
      PHeader^.TraceZMax := ReadDouble(MemStream);
      if HeaderId = 'BTM2' then
        PHeader^.CloseMesh := ReadInt32( MemStream )
      else
        PHeader^.CloseMesh := 0;
    finally
      MemStream.Free;
    end;
  finally
    FileStream.Free;
  end;
end;

{ -------------------------- Load/Save BTracer2Header ------------------------ }
procedure SaveBTracer2Header(const Filename: string; const PHeader: TPBTracer2Header);
var
  FileStream: TFileStream;
  MemStream: TMemoryStream;
begin
  ForceRemoveFile(Filename);
  FileStream := TFileStream.Create(Filename, fmCreate);
  try
    MemStream := TMemoryStream.Create;
    try
      WriteAnsiString(MemStream, 'BTR2');
      WriteDouble(MemStream, PHeader^.XOff);
      WriteDouble(MemStream, PHeader^.YOff);
      WriteDouble(MemStream, PHeader^.ZOff);
      WriteDouble(MemStream, PHeader^.Scale);
      WriteDouble(MemStream, PHeader^.XAngle);
      WriteDouble(MemStream, PHeader^.YAngle);
      WriteDouble(MemStream, PHeader^.ZAngle);
      WriteDouble(MemStream, PHeader^.SurfaceDetail);
      WriteInt32(MemStream, PHeader^.VResolution);
      WriteInt32(MemStream, Ord(PHeader^.WithColors));
      WriteInt32(MemStream, PHeader^.SaveTypeIndex);
      WriteInt32(MemStream, PHeader^.MaxPreviewVertices);
      WriteInt32(MemStream, Length(PHeader^.MandParamsAsString));
      if Length(PHeader^.MandParamsAsString) > 0 then
        WriteAnsiString(MemStream, PHeader^.MandParamsAsString);
      WriteInt32(MemStream, Ord(PHeader^.WithOpenGlPreview));
      WriteDouble(MemStream, PHeader^.PreviewDEstop);
      WriteInt32(MemStream, PHeader^.PreviewSizeIdx);
      WriteInt32(MemStream, Ord(PHeader^.WithAutoPreview));
      WriteInt32(MemStream, Length(PHeader^.OutputFilename));
      if Length(PHeader^.OutputFilename) > 0 then
        WriteString(MemStream, PHeader^.OutputFilename);
      WriteDouble(MemStream, PHeader^.TraceXMin);
      WriteDouble(MemStream, PHeader^.TraceXMax);
      WriteDouble(MemStream, PHeader^.TraceYMin);
      WriteDouble(MemStream, PHeader^.TraceYMax);
      WriteDouble(MemStream, PHeader^.TraceZMin);
      WriteDouble(MemStream, PHeader^.TraceZMax);
      WriteInt32(MemStream, Ord(PHeader^.CloseMesh));
      MemStream.SaveToStream(FileStream);
    finally
      MemStream.Free;
    end;
  finally
    FileStream.Free;
  end;
  CheckThatExistsFile(Filename);
end;

procedure LoadBTracer2Header(const Filename: string; const PHeader: TPBTracer2Header );
var
  StrLen: Int32;
  HeaderId: AnsiString;
  MemStream: TMemoryStream;
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(Filename, fmOpenRead);
  try
    MemStream := TMemoryStream.Create;
    try
      MemStream.LoadFromStream(FileStream);
      MemStream.Seek(0, soFromBeginning);
      HeaderId := ReadAnsiString4(MemStream);
      if  ( HeaderId <> 'BTR1' ) and ( HeaderId <> 'BTR2' ) then
        raise Exception.Create('Missing <BTR1/2>-header');
      PHeader^.XOff := ReadDouble(MemStream);
      PHeader^.YOff := ReadDouble(MemStream);
      PHeader^.ZOff := ReadDouble(MemStream);
      PHeader^.Scale := ReadDouble(MemStream);
      PHeader^.XAngle := ReadDouble(MemStream);
      PHeader^.YAngle := ReadDouble(MemStream);
      PHeader^.ZAngle := ReadDouble(MemStream);
      PHeader^.SurfaceDetail := ReadDouble(MemStream);
      PHeader^.VResolution := ReadInt32(MemStream);
      PHeader^.WithColors := Boolean(ReadInt32(MemStream));
      PHeader^.SaveTypeIndex := ReadInt32(MemStream);
      PHeader^.MaxPreviewVertices := ReadInt32(MemStream);
      StrLen := ReadInt32(MemStream);
      PHeader^.MandParamsAsString := ReadAnsiString(MemStream, StrLen);
      PHeader^.WithOpenGlPreview := Boolean(ReadInt32(MemStream));
      PHeader^.PreviewDEstop := ReadDouble(MemStream);
      PHeader^.PreviewSizeIdx := ReadInt32(MemStream);
      PHeader^.WithAutoPreview := Boolean(ReadInt32(MemStream));
      StrLen := ReadInt32(MemStream);
      PHeader^.OutputFilename := ReadString(MemStream, StrLen);
      PHeader^.TraceXMin := ReadDouble(MemStream);
      PHeader^.TraceXMax := ReadDouble(MemStream);
      PHeader^.TraceYMin := ReadDouble(MemStream);
      PHeader^.TraceYMax := ReadDouble(MemStream);
      PHeader^.TraceZMin := ReadDouble(MemStream);
      PHeader^.TraceZMax := ReadDouble(MemStream);
      if HeaderId = 'BTR2'  then
        PHeader^.CloseMesh := Boolean( ReadInt32( MemStream ) )
      else
        PHeader^.CloseMesh := False;
    finally
      MemStream.Free;
    end;
  finally
    FileStream.Free;
  end;
end;


end.

