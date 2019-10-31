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

uses VertexList;

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
  end;
  TPBTraceMainHeader = ^TBTraceMainHeader;

  TBTraceDataHeader = packed record
    TraceOffset, TraceCount, TraceResolution: Int32;
  end;
  TPBTraceDataHeader = ^TBTraceDataHeader;

  TBTraceData = packed record
    DE: Single;
    ColorIdx, ColorR, ColorG, ColorB: TColorValue;
  end;
  TPBTraceData = ^TBTraceData;

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

const
  cBTracer2FileExt = 'btracer2';

implementation

uses
  Windows, Math, DateUtils, ShellApi, SysUtils, Classes;

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
  Result := IncludeTrailingBackslash(OutputFilename) + Format('part_%s_%s', [Format('%.*d',[3, ThreadIdx]), Format('%.*d',[3, CurrFileIdx])]);
end;

{ ----------------------- Writing  of primitive types ------------------------ }
procedure WriteString(const MemStream: TMemoryStream; const Value: AnsiString);
begin
  MemStream.WriteData(PAnsiChar(Value), Length(Value));
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
function ReadString4(const MemStream: TMemoryStream): AnsiString;
var
  Byte5: Array [0..4] of Byte;
  // EOF: boolean;  ReadLen: Integer;
begin
  // ReadLen := MemStream.Read(Byte5[0], 4);
  Byte5[4] := 0;
  MemStream.Read(Byte5[0], 4);
  Result := PAnsiChar(@Byte5[0]);
  // EOF := ReadLen < 4;
end;

procedure SkipBytes(const MemStream: TMemoryStream; const Length: Integer);
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

function ReadInt32(const MemStream: TMemoryStream): Int32;
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

function ReadInt16(const MemStream: TMemoryStream): Int16;
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
  Result := BaseFilename+'.h';
end;

function CreateDataFilename(const BaseFilename: string): string;
begin
  Result := BaseFilename+'.d';
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
      WriteString(MemStream, 'BTH1');
      WriteInt32(MemStream, PHeader^.TraceOffset);
      WriteInt32(MemStream, PHeader^.TraceCount);
      WriteInt32(MemStream, PHeader^.TraceResolution);
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
  ForceRemoveFile(Filename);
  FileStream := TFileStream.Create(Filename, fmCreate);
  try
    MemStream := TMemoryStream.Create;
    try
      WriteString(MemStream, 'BTD1');
      CurrBTraceData := BTraceData;
      for I:=0 to PHeader^.TraceCount - 1 do begin
        WriteSingle(MemStream, CurrBTraceData^.DE );
        WriteInt16(MemStream, CurrBTraceData^.ColorIdx );
        WriteInt16(MemStream, CurrBTraceData^.ColorR );
        WriteInt16(MemStream, CurrBTraceData^.ColorG );
        WriteInt16(MemStream, CurrBTraceData^.ColorB );
        Inc(CurrBTraceData);
      end;
      MemStream.SaveToStream(FileStream);
    finally
      MemStream.Free;
    end;
  finally
    FileStream.Free;
  end;
  CheckThatExistsFile(Filename);
end;

{ --------------------------- Loading Trace Data ----------------------------- }
function TraceDataExists(const Filename: string): boolean;
begin
  Result := SysUtils.FileExists( CreateHeaderFilename( Filename ) );
end;

procedure LoadTraceHeader(const Filename: string; const PHeader: TPBTraceDataHeader );
var
  MemStream: TMemoryStream;
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(CreateHeaderFilename(Filename), fmOpenRead);
  try
    MemStream := TMemoryStream.Create;
    try
      MemStream.LoadFromStream(FileStream);
      MemStream.Seek(0, soFromBeginning);
      if ReadString4(MemStream) <> 'BTH1' then
        raise Exception.Create('Missing <BTH1>-header');
      PHeader^.TraceOffset := ReadInt32(MemStream);
      PHeader^.TraceCount := ReadInt32(MemStream);
      PHeader^.TraceResolution := ReadInt32(MemStream);
    finally
      MemStream.Free;
    end;
  finally
    FileStream.Free;
  end;
end;

procedure LoadTraceData(const Filename: string; var BTraceData: TPBTraceData; const PHeader: TPBTraceDataHeader);
var
  I: Int32;
  CurrBTraceData: TPBTraceData;
  MemStream: TMemoryStream;
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(CreateDataFilename(Filename), fmOpenRead);
  try
    MemStream := TMemoryStream.Create;
    try
      MemStream.LoadFromStream(FileStream);
      MemStream.Seek(0, soFromBeginning);

      if ReadString4(MemStream) <> 'BTD1' then
        raise Exception.Create('Missing <BTD1>-header');
      GetMem( BTraceData, PHeader^.TraceCount * SizeOf( TBTraceData ) );
      CurrBTraceData := BTraceData;
      try
        for I:=0 to PHeader^.TraceCount - 1 do begin
          CurrBTraceData^.DE := ReadSingle(MemStream);
          CurrBTraceData^.ColorIdx := ReadInt16(MemStream);
          CurrBTraceData^.ColorR := ReadInt16(MemStream);
          CurrBTraceData^.ColorG := ReadInt16(MemStream);
          CurrBTraceData^.ColorB := ReadInt16(MemStream);
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
      WriteString(MemStream, 'BTM1');
      WriteInt32(MemStream, PHeader^.VHeaderWidth);
      WriteInt32(MemStream, PHeader^.VHeaderHeight);
      WriteDouble(MemStream, PHeader^.VHeaderZoom);
      WriteDouble(MemStream, PHeader^.VHeaderZScale);
      WriteInt32(MemStream, PHeader^.VResolution);
      WriteInt32(MemStream, PHeader^.ThreadCount);
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
  MemStream: TMemoryStream;
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(CreateMainHeaderFilename(Filename), fmOpenRead);
  try
    MemStream := TMemoryStream.Create;
    try
      MemStream.LoadFromStream(FileStream);
      MemStream.Seek(0, soFromBeginning);
      if ReadString4(MemStream) <> 'BTM1' then
        raise Exception.Create('Missing <BTM1>-header');
      PHeader^.VHeaderWidth := ReadInt32(MemStream);
      PHeader^.VHeaderHeight := ReadInt32(MemStream);
      PHeader^.VHeaderZoom := ReadDouble(MemStream);
      PHeader^.VHeaderZScale := ReadDouble(MemStream);
      PHeader^.VResolution := ReadInt32(MemStream);
      PHeader^.ThreadCount := ReadInt32(MemStream);
    finally
      MemStream.Free;
    end;
  finally
    FileStream.Free;
  end;
end;

end.

