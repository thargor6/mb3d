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

  TBTraceDataHeader = packed record
    TraceCount: Int32;
    XMin, XStepSize: double;
    XFromIdx, XToIdx, XSlices: Int32;
    YMin, YStepSize: double;
    YFromIdx, YToIdx, YSlices: Int32;
    ZMin, ZStepSize: double;
    ZFromIdx, ZToIdx, ZSlices: Int32;
  end;
  TPBTraceDataHeader = ^TBTraceDataHeader;


  TBTraceData = packed record
    DE: Single;
    ColorIdx, ColorR, ColorG, ColorB: TColorValue;
  end;

  TBTraceDataArray = array of TBTraceData;

function SwapEndianInt32(Value: Int32): Int32;
function SwapEndianInt16(Value: Int16): Int16;
procedure SwapBytesSingle( A, B: PEndianCnvSnglRec );
procedure CreateTraceFile( const OutputFilename: string );

procedure SaveTraceData( const BTraceData: TBTraceDataArray; const OutputFilename: string; const IterationIdx, CurrFileIdx: integer; const PHeader: TPBTraceDataHeader );
function LoadTraceData( const Filename: string; const PHeader: TPBTraceDataHeader ):  TBTraceDataArray;

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

procedure SaveTraceData( const BTraceData: TBTraceDataArray; const OutputFilename: string; const IterationIdx, CurrFileIdx: integer; const PHeader: TPBTraceDataHeader );
var
  Filename: String;
  ASRec, BSRec: EndianCnvSnglRec;
  ADRec, BDRec: EndianCnvDblRec;

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
  begin
    BSRec.EndianVal := Value;
    SwapBytesSingle( @ASRec, @BSRec );
    MemStream.WriteData(ASRec.EndianVal, 4);
  end;

  procedure WriteDouble(const MemStream: TMemoryStream; const Value: Single);
  begin
    BDRec.EndianVal := Value;
    SwapBytesDouble( @ADRec, @BDRec );
    MemStream.WriteData(ADRec.EndianVal, 8);
  end;

  procedure SaveHeader(const BaseFilename: string);
  var
    FileStream: TFileStream;
    MemStream: TMemoryStream;
  begin
    FileStream := TFileStream.Create(BaseFilename+'.h', fmCreate);
    try
      MemStream := TMemoryStream.Create;
      try
        WriteString(MemStream, 'BTH1');
        WriteInt32(MemStream, PHeader^.TraceCount);
        WriteDouble(MemStream, PHeader^.XMin);
        WriteDouble(MemStream, PHeader^.XStepSize);
        WriteInt32(MemStream, PHeader^.XFromIdx);
        WriteInt32(MemStream, PHeader^.XToIdx);
        WriteInt32(MemStream, PHeader^.XSlices);
        WriteDouble(MemStream, PHeader^.YMin);
        WriteDouble(MemStream, PHeader^.YStepSize);
        WriteInt32(MemStream, PHeader^.YFromIdx);
        WriteInt32(MemStream, PHeader^.YToIdx);
        WriteInt32(MemStream, PHeader^.YSlices);
        WriteDouble(MemStream, PHeader^.ZMin);
        WriteDouble(MemStream, PHeader^.ZStepSize);
        WriteInt32(MemStream, PHeader^.ZFromIdx);
        WriteInt32(MemStream, PHeader^.ZToIdx);
        WriteInt32(MemStream, PHeader^.ZSlices);
        MemStream.SaveToStream(FileStream);
      finally
        MemStream.Free;
      end;
    finally
      FileStream.Free;
    end;
  end;

  procedure SaveData(const BaseFilename: string);
  var
    I, TraceCount: Int32;
    FileStream: TFileStream;
    MemStream: TMemoryStream;
  begin
    FileStream := TFileStream.Create(BaseFilename+'.d', fmCreate);
    try
      MemStream := TMemoryStream.Create;
      try
        WriteString(MemStream, 'BTD1');
        for I:=0 to PHeader^.TraceCount - 1 do begin
          WriteSingle(MemStream,  BTraceData[ I ].DE );
          WriteInt16(MemStream,  BTraceData[ I ].ColorIdx );
          WriteInt16(MemStream,  BTraceData[ I ].ColorR );
          WriteInt16(MemStream,  BTraceData[ I ].ColorG );
          WriteInt16(MemStream,  BTraceData[ I ].ColorB );
        end;
        MemStream.SaveToStream(FileStream);
      finally
        MemStream.Free;
      end;
    finally
      FileStream.Free;
    end;
  end;

begin
  Filename := IncludeTrailingBackslash(OutputFilename) + Format('part_%s_%s', [Format('%.*d',[3, IterationIdx]), Format('%.*d',[3, CurrFileIdx])]);
  SaveHeader(Filename);
  SaveData(Filename);
end;

function LoadTraceData( const Filename: string; const PHeader: TPBTraceDataHeader ):  TBTraceDataArray;
var
  Byte5: Array [0..4] of Byte;
  EOF: boolean;
  ASRec, BSRec: EndianCnvSnglRec;
  ADRec, BDRec: EndianCnvSnglRec;

  function ReadString4(const MemStream: TMemoryStream): AnsiString;
  var
    ReadLen: Integer;
  begin
    ReadLen := MemStream.Read(Byte5[0], 4);
    Result := PAnsiChar(@Byte5[0]);
    EOF := ReadLen < 4;
  end;

  procedure SkipBytes(const MemStream: TMemoryStream; const Length: Integer);
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

  function ReadInt32(const MemStream: TMemoryStream): Int32;
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

  function ReadInt16(const MemStream: TMemoryStream): Int16;
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

  function ReadSingle(const MemStream: TMemoryStream): Single;
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

  function ReadDouble(const MemStream: TMemoryStream): Double;
  var
    ReadLen: Integer;
    PBuf: Pointer;
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

  procedure LoadHeader(const BaseFilename: string);
  var
    MemStream: TMemoryStream;
    FileStream: TFileStream;
  begin
    FileStream := TFileStream.Create(Filename+'.h', fmOpenRead);
    try
      MemStream := TMemoryStream.Create;
      try
        MemStream.LoadFromStream(FileStream);
        MemStream.Seek(0, soFromBeginning);
        Byte5[4] := 0;
        if ReadString4(MemStream) <> 'BTH1' then
          raise Exception.Create('Missing <BTH1>-header');
        PHeader^.TraceCount := ReadInt32(MemStream);
        PHeader^.XMin := ReadDouble(MemStream);
        PHeader^.XStepSize := ReadDouble(MemStream);
        PHeader^.XFromIdx := ReadInt32(MemStream);
        PHeader^.XToIdx := ReadInt32(MemStream);
        PHeader^.XSlices := ReadInt32(MemStream);
        PHeader^.YMin := ReadDouble(MemStream);
        PHeader^.YStepSize := ReadDouble(MemStream);
        PHeader^.YFromIdx := ReadInt32(MemStream);
        PHeader^.YToIdx := ReadInt32(MemStream);
        PHeader^.YSlices := ReadInt32(MemStream);
        PHeader^.ZMin := ReadDouble(MemStream);
        PHeader^.ZStepSize := ReadDouble(MemStream);
        PHeader^.ZFromIdx := ReadInt32(MemStream);
        PHeader^.ZToIdx := ReadInt32(MemStream);
        PHeader^.ZSlices := ReadInt32(MemStream);
      finally
        MemStream.Free;
      end;
    finally
      FileStream.Free;
    end;
  end;

  procedure LoadData(const BaseFilename: string);
  var
    I: Int32;
    MemStream: TMemoryStream;
    FileStream: TFileStream;
  begin
    FileStream := TFileStream.Create(Filename+'.d', fmOpenRead);
    try
      MemStream := TMemoryStream.Create;
      try
        MemStream.LoadFromStream(FileStream);
        MemStream.Seek(0, soFromBeginning);
        Byte5[4] := 0;

        if ReadString4(MemStream) <> 'BTD1' then
          raise Exception.Create('Missing <BTD1>-header');
        SetLength( Result, PHeader^.TraceCount );
        try
          for I:=0 to PHeader^.TraceCount - 1 do begin
            Result[ I ].DE := ReadSingle(MemStream);
            Result[ I ].ColorIdx := ReadInt16(MemStream);
            Result[ I ].ColorR := ReadInt16(MemStream);
            Result[ I ].ColorG := ReadInt16(MemStream);
            Result[ I ].ColorB := ReadInt16(MemStream);
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

begin
  LoadHeader(Filename);
  LoadData(Filename);
end;

end.
