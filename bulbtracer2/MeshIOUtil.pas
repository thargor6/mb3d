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

  TColorValue = Int16;

  TBTraceData = packed record
    DE: Single;
    ColorIdx, ColorR, ColorG, ColorB: TColorValue;
  end;

function SwapEndianInt32(Value: Int32): Int32;
function SwapEndianInt16(Value: Int16): Int16;
procedure SwapBytesSingle( A, B: PEndianCnvSnglRec );
procedure CreateTraceFile( const OutputFilename: string );
procedure SaveTraceData( const BTraceData: Array of TBTraceData; const OutputFilename: string; const IterationIdx, CurrFileIdx, BTGraceCount: integer );

function FloatToColorValue( const Value: Single ): TColorValue; overload;
function FloatToColorValue( const Value: Double ): TColorValue; overload;
function ColorValueToFloat( const Value: TColorValue ): Single;

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

procedure SaveTraceData( const BTraceData: Array of TBTraceData; const OutputFilename: string; const IterationIdx, CurrFileIdx, BTGraceCount: integer );
var
  Filename: String;
  FileStream: TFileStream;
  MemStream: TMemoryStream;
  ASRec, BSRec: EndianCnvSnglRec;
  I: Int32;

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

function FloatToColorValue( const Value: Single ): TColorValue; overload;
begin
  Result := Min( Max( Round( 32767.0 * Value ), 0 ), 32767);
end;

function FloatToColorValue( const Value: Double ): TColorValue; overload;
begin
  Result := Min( Max( Round( 32767.0 * Value ), 0 ), 32767);
end;

function ColorValueToFloat( const Value: TColorValue ): Single;
begin
  Result := Min( Max( Value / 32767.0, 0 ), 1.0);
end;

end.
