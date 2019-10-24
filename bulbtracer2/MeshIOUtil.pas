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

  TBTraceData = packed record
    DE: Single;
    ColorIdx, ColorR, ColorG, ColorB: TColorValue;
  end;

  TBTraceDataArray = array of TBTraceData;

function SwapEndianInt32(Value: Int32): Int32;
function SwapEndianInt16(Value: Int16): Int16;
procedure SwapBytesSingle( A, B: PEndianCnvSnglRec );
procedure CreateTraceFile( const OutputFilename: string );

procedure SaveTraceData( const BTraceData: TBTraceDataArray; const OutputFilename: string; const IterationIdx, CurrFileIdx, BTGraceCount: integer );
function LoadTraceData( const Filename: string ):  TBTraceDataArray;

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

procedure CreateTraceFile( const OutputFilename: string );

  procedure DeleteDirectory(const DirName: string);
  var
    FileOp: TSHFileOpStruct;
  begin
    FillChar(FileOp, SizeOf(FileOp), 0);
    FileOp.wFunc := FO_DELETE;
    FileOp.pFrom := PChar(DirName+#0);//double zero-terminated
    FileOp.fFlags := FOF_SILENT or FOF_NOERRORUI or FOF_NOCONFIRMATION;
    SHFileOperation(FileOp);
  end;

begin
 if DirectoryExists( OutputFilename ) then
   DeleteDirectory( OutputFilename );
  if not ForceDirectories( OutputFilename ) then
    raise Exception.Create(Format('Could not create folder <%s>', [OutputFilename]));
end;

procedure SaveTraceData( const BTraceData: TBTraceDataArray; const OutputFilename: string; const IterationIdx, CurrFileIdx, BTGraceCount: integer );
var
  Filename: String;
  FileStream: TFileStream;
  MemStream: TMemoryStream;
  ASRec, BSRec: EndianCnvSnglRec;
  I: Int32;

  XXX: TBTraceDataArray;

  procedure WriteString(const Value: AnsiString);
  begin
    MemStream.WriteData(PAnsiChar(Value), Length(Value));
  end;

  procedure WriteNullTerminatedString(const Value: AnsiString);
  begin
    MemStream.WriteData(PAnsiChar(Value), Length(Value));
    MemStream.WriteData(0, 1);
  end;

  procedure WriteInt32(const Value: Int32);
  begin
    MemStream.WriteData(SwapEndianInt32(Value), 4);
  end;

  procedure WriteInt16(const Value: Int16);
  begin
    MemStream.WriteData(SwapEndianInt16(Value), 2);
  end;

  procedure WriteSingle(const Value: Single);
  begin
    BSRec.EndianVal := Value;
    SwapBytesSingle( @ASRec, @BSRec );
    MemStream.WriteData(ASRec.EndianVal, 4);
  end;

begin
  Filename := IncludeTrailingBackslash(OutputFilename) + Format('part_%s_%s', [Format('%.*d',[3, IterationIdx]), Format('%.*d',[3, CurrFileIdx])]);
  FileStream := TFileStream.Create(Filename, fmCreate);
  try
    MemStream := TMemoryStream.Create;
    try
      WriteString('BTR1');
      WriteInt32(BTGraceCount);
      for I:=0 to BTGraceCount - 1 do begin
        WriteSingle( BTraceData[ I ].DE );
        WriteInt16( BTraceData[ I ].ColorIdx );
        WriteInt16( BTraceData[ I ].ColorR );
        WriteInt16 ( BTraceData[ I ].ColorG );
        WriteInt16( BTraceData[ I ].ColorB );
      end;
      MemStream.SaveToStream(FileStream);
    finally
      MemStream.Free;
    end;
  finally
    FileStream.Free;
  end;
end;

function LoadTraceData( const Filename: string ):  TBTraceDataArray;
var
  MemStream: TMemoryStream;
  FileStream: TFileStream;
  Byte5: Array [0..4] of Byte;
  BTGraceCount, I: Int32;
  EOF: boolean;
  ASRec, BSRec: EndianCnvSnglRec;

  function ReadString4: AnsiString;
  var
    ReadLen: Integer;
  begin
    ReadLen := MemStream.Read(Byte5[0], 4);
    Result := PAnsiChar(@Byte5[0]);
    EOF := ReadLen < 4;
  end;

  procedure SkipBytes(const Length: Integer);
  var
    I, ReadLen: Integer;
  begin
    for I := 0 to Length - 1 do begin
      ReadLen := MemStream.Read(Byte5[0], 1);
      EOF := ReadLen < 1;
      if EOF then
        break;
    end;
  end;

  function ReadInt32: Int32;
  var
    Buf: Int32;
    PBuf: Pointer;
    ReadLen: Integer;
  begin
    PBuf := @Buf;
    ReadLen := MemStream.Read(PBuf^, 4);
    EOF := ReadLen < 4;
    if not EOF then
      Result := SwapEndianInt32( Buf )
    else
      Result := 0;
  end;

  function ReadInt16: Int16;
  var
    Buf: Int16;
    PBuf: Pointer;
    ReadLen: Integer;
  begin
    PBuf := @Buf;
    ReadLen := MemStream.Read(PBuf^, 2);
    EOF := ReadLen < 2;
    if not EOF then
      Result := SwapEndianInt16( Buf )
    else
      Result := 0;
  end;

  function ReadSingle: Single;
  var
    ReadLen: Integer;
    PBuf: Pointer;
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

begin
  FileStream := TFileStream.Create(Filename, fmOpenRead);
  try
    MemStream := TMemoryStream.Create;
    try
      MemStream.LoadFromStream(FileStream);
      MemStream.Seek(0, soFromBeginning);
      Byte5[4] := 0;

      if ReadString4<>'BTR1' then
        raise Exception.Create('Missing <BTR1>-header');
      BTGraceCount := ReadInt32;
      SetLength( Result, BTGraceCount );
      try
        for I:=0 to BTGraceCount - 1 do begin
          Result[ I ].DE := ReadSingle;
          Result[ I ].ColorIdx := ReadInt16;
          Result[ I ].ColorR := ReadInt16;
          Result[ I ].ColorG := ReadInt16;
          Result[ I ].ColorB := ReadInt16;
        end;
      except
        SetLength( Result, 0 );
        Result := nil;
        raise;
      end;
    finally
      MemStream.Free;
    end;
  finally
    FileStream.Free;
  end;
end;

end.
