////////////////////////////////////////////////////////////////////////////////
//
// BitStream.pas - Bit stream unit
// -------------------------------
// Changed:   2001-02-10
// Maintain:  Michael Vinther    |    mv@logicnet·dk
//
// Contains:
//   (TBaseStream)
//     (TFilterStream)
//       TBitStream
//

unit BitStream;

interface

uses Windows, Streams, SysUtils;

resourcestring
  rsWriteDenied   = 'Stream not open for write';

type
  TBitStream = class(TFilterStream)
    public
      destructor Destroy; override;

//      function Write(var Buf; Count: Integer): Integer; override;
//      function Read(var Buf; Count: Integer): Integer; override;

      procedure WriteBits(Str: DWord; Count: Integer);
      function ReadBits(var Str; Count: Integer): Integer;
      function ReadBit: Byte;

      // Write data in look-ahead and reset 1-byte read/write buffer
      procedure Flush; override;

      // Return value is >0 if there is available data
      function Available: Integer; override;
      
    protected
      WBitPos, RBitPos : Integer;
      Buffer : Byte;
    end;

implementation

uses MemUtils;

//=======================================================================================================
// TBitStream
//=======================================================================================================

//-----------------------------------------------------------------------------------
// Flush and free memory
destructor TBitStream.Destroy;
begin
  Flush;
  inherited;
end;

procedure TBitStream.WriteBits(Str: DWord; Count: Integer);
var
  OutBits : Integer;
  DataByte : Byte;
begin
  Assert(Count<=32);
  while Count>0 do // Write data one byte at a time
  begin
    OutBits:=Count;
    if OutBits>8 then OutBits:=8;

    DataByte:=Str and ((1 shl OutBits)-1); // Make sure only bits to be written can be set
    Buffer:=Buffer or (DataByte shl WBitPos); // Put first part of byte in buffer

    if WBitPos+OutBits>=8 then // Byte overlap
    begin
      Next.Write(Buffer,1);
      Buffer:=DataByte shr (8-WBitPos); // Put first part of byte in buffer
      Dec(WBitPos,8);
    end;
    Inc(WBitPos,OutBits);
    Str:=Str shr 8;
    Dec(Count,OutBits);
  end;
end;

function TBitStream.ReadBits(var Str; Count: Integer): Integer;
var
  InBits, Got : Integer;
  DataByte : Byte;
  StrPtr : ^Byte;
begin
  StrPtr:=@Str;
  Result:=0;
  while Count>0 do // Read data one byte at a time
  begin
    InBits:=Count;
    if InBits>8 then InBits:=8;

    if (RBitPos=0) and (Next.Read(Buffer,1)<>1) then Exit;

    DataByte:=Buffer shr RBitPos; // Read first part of byte

    if RBitPos+InBits>8 then // Byte overlap
    begin
      if Next.Read(Buffer,1)<>1 then Exit;
      Got:=8-RBitPos;

      DataByte:=(DataByte and ((1 shl Got)-1)) or (Buffer shl Got); // Read last part of byte

      Dec(RBitPos,8);
    end;

    StrPtr^:=DataByte and ((1 shl InBits)-1); // Make sure only bits to be read can be set
    Inc(StrPtr);
    Inc(RBitPos,InBits);
    Inc(Result,InBits);
    Dec(Count,InBits);
  end;
end;
 
function TBitStream.ReadBit: Byte;
begin
  if (RBitPos=0) or (RBitPos=8) then
  begin
    Next.Read(Buffer,1);
    RBitPos:=0;
  end;
  Result:=(Buffer shr RBitPos) and 1;
  Inc(RBitPos);
end;

//-----------------------------------------------------------------------------------
// Write data in look-ahead and reset 1-byte read/write buffer
procedure TBitStream.Flush;
begin
  if WBitPos>0 then Next.Write(Buffer,1);
  WBitPos:=0; RBitPos:=0;
  Buffer:=0;
end;

//-----------------------------------------------------------------------------------
// Return value is >0 if there is available data
function TBitStream.Available;
begin
  Available:=Next.Available+RBitPos;
end;

end.

