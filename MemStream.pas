////////////////////////////////////////////////////////////////////////////////
//
// MemStream.pas - Seekable memory stream
// --------------------------------------
// Changed:   2003-06-11
// Maintain:  Michael Vinther   |   mv@logicnet·dk
//
// Contains:
//   (TBaseStream)
//     (TSeekableStream)
//       TMemStream
//         TChunkWriteStream
//       TMemBlockStream
//         TChunkReadStream
//
//  The memory buffer is a dynamic allocated linked list.
//  It allows seek and write to the beginning of the stream without truncating it.
//
//  Last changes:
//    TMemBlockStream and TMemChunkStream added

unit MemStream;

interface

uses
 Streams, SysUtils, Monitor;

resourcestring
 rs_SeekMemError = 'Error moving stream pointer';

var
 MemBlockSize : Integer = 1024*4;  // Size of each block in chain

type
 PMemBlock = ^TMemBlock;
 TMemBlock = packed record
               Size : Integer;
               Next : PMemBlock;
               Data : TByteArray;
             end;

 TMemStream = class(TSeekableStream)
   protected
     First, CurBlock : PMemBlock;
     BlockPos : Integer;
     fSize, fPosition : Integer;
     procedure FreeChain(var Start: PMemBlock);

     function GetPos: Integer; override;
     function GetSize: Integer; override;
   public
     constructor Create;
     destructor Destroy; override;
     function Write(var Buf; Count: Integer): Integer; override;
     function Read(var Buf; Count: Integer): Integer; override;
     procedure Seek(Loc: Integer); override;
     function Available: Integer; override;
     // Reset stream, Size=0
     procedure Reset;
     // Truncate stream, Size=Position
     procedure Truncate; override;
  end;

 TMemBlockStream = class(TSeekableStream)
   protected
     FSize, FPosition : Integer;
     FData : PByteArray;
     FOwnsData : Boolean;
     function GetPos: Integer; override;
     function GetSize: Integer; override;
   public
     constructor Create(Data: Pointer; Size: Integer=MaxInt; OwnsData: Boolean=False);
     destructor Destroy; override;
     function Write(var Buf; Count: Integer): Integer; override;
     function Read(var Buf; Count: Integer): Integer; override;
     procedure Seek(Loc: Integer); override;
     function Available: Integer; override;
     // Truncate stream, Size=Position
     procedure Truncate; override;
     property CanRead: boolean read fCanRead write fCanRead;
     property CanWrite: boolean read fCanWrite write fCanWrite;
   end;

// Stream for reading/writing a chunk in another stream
type
 TChunkReadStream = class(TMemBlockStream)
   public
     // Read 32 bit size from Source if not specified
     constructor Create(Source: TBaseStream; Size: Integer=-1);
   end;
 TChunkWriteStream = class(TMemStream)
   protected
     FDestStream  : TBaseStream;
     FIncludeSize : Boolean;
   public
     // Write size do Destination if IncludeSize=True
     constructor Create(Destination: TBaseStream; IncludeSize: Boolean);
     destructor Destroy; override;
   end;

implementation

//=========================================================================================================
// TChunkReadStream
//=========================================================================================================
constructor TChunkReadStream.Create(Source: TBaseStream; Size: Integer=-1);
var
  Data : Pointer;
begin
  if Size=-1 then // Read size from Source
    if Source.Read(Size,4)<>4 then raise EInOutError.CreateFmt(rs_ReadError,[ClassName]);

  GetMem(Data,Size);
  inherited Create(Data,Size,True);
  if Source.Read(Data^,Size)<>Size then raise EInOutError.CreateFmt(rs_ReadError,[ClassName]);
end;

//=========================================================================================================
// TChunkWriteStream
//=========================================================================================================
constructor TChunkWriteStream.Create(Destination: TBaseStream; IncludeSize: Boolean);
begin
  inherited Create;
  FDestStream:=Destination;
  FIncludeSize:=IncludeSize;
end;

destructor TChunkWriteStream.Destroy;
begin
  if FIncludeSize then // Write size to FDestStream
    FDestStream.Write(FSize,4);
  Position:=0;
  FDestStream.CopyFrom(Self);
  inherited;
end;

//=========================================================================================================
// TMemStream
//=========================================================================================================

var NullBlock : TMemBlock;

constructor TMemStream.Create;
begin
  inherited Create;
  fCanRead:=True; fCanWrite:=True;
  CurBlock:=@NullBlock;
end;

procedure TMemStream.FreeChain(var Start: PMemBlock);
var Block, P : PMemBlock;
begin
  Block:=Start;
  while Block<>nil do
  begin
   P:=Block;
   Block:=Block^.Next;
   FreeMem(P);
  end;
  Start:=nil;
end;

destructor TMemStream.Destroy;
begin
  FreeChain(First);
  inherited;
end;

function TMemStream.Available: integer;
begin
  Available:=fSize-fPosition;
end;

function TMemStream.Read(var Buf; Count: Integer): Integer;
var Get : Integer;
begin
  Result:=0;
  while (Count>0) and (fPosition<fSize) do
  begin
    if BlockPos=CurBlock^.Size then // Go to next block
    begin
      if CurBlock^.Next=nil then Break // End of chain
      else CurBlock:=CurBlock^.Next;
      BlockPos:=0;
    end;
    Get:=Count;
    if fPosition+Get>fSize then Get:=fSize-fPosition;
    if Get>CurBlock^.Size-BlockPos then Get:=CurBlock^.Size-BlockPos;
    Move(CurBlock^.Data[BlockPos],TByteArray(Buf)[Result],Get);
    Inc(BlockPos,Get); Inc(Result,Get); Dec(Count,Get);
    Inc(fPosition,Get);
  end;

  if NoDataExcept and (Count>0) then raise EInOutError.CreateFmt(rs_ReadError,[ClassName]);
end;

function TMemStream.Write(var Buf; Count: Integer): Integer;
var
 Put, NewSize : Integer;
 NewB : PMemBlock;
begin
 Result:=0;
 while Count>0 do
 begin
  if BlockPos=CurBlock^.Size then
  begin
    NewSize:=MemBlockSize;
    if NewSize<Count then NewSize:=Count;
    if CurBlock^.Next=nil then // Make new block
    begin
     GetMem(NewB,SizeOf(Integer)+SizeOf(PMemBlock)+NewSize);
     NewB^.Size:=NewSize;
     NewB^.Next:=nil;
     if First=nil then First:=NewB // First block
     else CurBlock^.Next:=NewB; // Add to end of chain
     CurBlock:=NewB;
    end
    else // Reuse next block
    begin
     CurBlock:=CurBlock^.Next;
    end;
    BlockPos:=0;
  end;
  Put:=Count;
  if Put>CurBlock^.Size-BlockPos then Put:=CurBlock^.Size-BlockPos;
  Move(TByteArray(Buf)[Result],CurBlock^.Data[BlockPos],Put);
  Inc(BlockPos,Put); Inc(Result,Put); Dec(Count,Put);
 end;
 Inc(fPosition,Result);
 if fSize<fPosition then fSize:=fPosition;
end;

procedure TMemStream.Seek(Loc: Integer);
var Get : Integer;
begin
  if Loc=fPosition then Exit;

  if (Loc<0) or (Loc>fSize) then raise EInOutError.Create(rs_SeekMemError);

  if Loc<fPosition then
  begin
    // Search from start
    fPosition:=0;
    CurBlock:=First; BlockPos:=0;
  end;

  // Search first block
  if BlockPos=CurBlock^.Size then // Go to next block
  begin
    if CurBlock^.Next=nil then raise Exception.Create('Error in MemStream.Seek');

    CurBlock:=CurBlock^.Next;
    BlockPos:=0;
  end;
  Get:=Loc-fPosition;
  if Get>CurBlock^.Size-BlockPos then Get:=CurBlock^.Size-BlockPos;
  Inc(BlockPos,Get); Inc(fPosition,Get);


  while fPosition<Loc do
  begin
    if CurBlock^.Next=nil then raise Exception.Create('Error in MemStream.Seek 2');

    CurBlock:=CurBlock^.Next;
    BlockPos:=Loc-fPosition;
    if BlockPos>CurBlock^.Size then BlockPos:=CurBlock^.Size;
    Inc(fPosition,BlockPos);
  end;
end;

procedure TMemStream.Reset;
begin
 FreeChain(First);
 fSize:=0; fPosition:=0; CurBlock:=@NullBlock; BlockPos:=0;
end;

procedure TMemStream.Truncate;
begin
 FreeChain(CurBlock.Next);
 fSize:=fPosition;
end;

function TMemStream.GetPos: Integer;
begin
  Result:=fPosition;
end;

function TMemStream.GetSize: Integer;
begin
  Result:=fSize;
end;

//=========================================================================================================
// TMemBlockStream
//=========================================================================================================

constructor TMemBlockStream.Create(Data: Pointer; Size: Integer; OwnsData: Boolean);
begin
  inherited Create;
  fCanRead:=True; fCanWrite:=True;
  FSize:=Size;
  FOwnsData:=OwnsData;
  FData:=Data;
end;

destructor TMemBlockStream.Destroy;
begin
  inherited;
  if Assigned(FData) and FOwnsData then FreeMem(FData);
end;

function TMemBlockStream.Available: Integer;
begin
  Available:=fSize-fPosition;
end;

function TMemBlockStream.Read(var Buf; Count: Integer): Integer;
begin
  Result:=FSize-FPosition;
  if Result>Count then Result:=Count;
  Move(FData^[FPosition],Buf,Result);
  Inc(FPosition,Result);
  if NoDataExcept and (Result<>Count) then raise EInOutError.CreateFmt(rs_ReadError,[ClassName]);
end;

function TMemBlockStream.Write(var Buf; Count: Integer): Integer;
begin
  Result:=Count;
  if Result>FSize-FPosition then raise EInOutError.CreateFmt(rs_WriteError,[ClassName]);
  Move(Buf,FData^[FPosition],Result);
  Inc(FPosition,Result);
end;

procedure TMemBlockStream.Seek(Loc: Integer);
begin
  if (Loc<0) or (Loc>fSize) then raise EInOutError.Create(rs_SeekMemError);
  FPosition:=Loc;
end;

procedure TMemBlockStream.Truncate;
begin
  fSize:=fPosition;
end;

function TMemBlockStream.GetPos: Integer;
begin
  Result:=fPosition;
end;

function TMemBlockStream.GetSize: Integer;
begin
  Result:=fSize;
end;

//=========================================================================================================

initialization
  NullBlock.Next:=nil;
  NullBlock.Size:=0;
end.

