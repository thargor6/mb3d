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

function SwapEndianInt32(Value: Int32): Int32;
function SwapEndianInt16(Value: Int16): Int16;
procedure SwapBytesSingle( A, B: PEndianCnvSnglRec );

const
  cMB3DMeshSegFileExt = 'mb3dmeshseg';
  LW_MAXU2: Int32 = $FF00;

implementation

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


end.
