////////////////////////////////////////////////////////////////////////////////
//
// Deflate.pas - Deflate compression unit
// --------------------------------------
// Changed:   2003-04-25
// Maintain:  Michael Vinther    |    mv@logicnet·dk
//
// Contains:
//   (TBaseStream)
//     (TFilterStream)
//       (TBitStream)
//         TDeflateStream
//

unit Deflate;

interface

uses
  Windows, SysUtils, Streams, BufStream, BitStream, Huffman, Monitor;

resourcestring
  rsErrorInCompressedData = 'Error in compressed data';
  rsBadCompFormat         = 'Bad compression parameters';
  rsWriteDenied           = 'Stream not open for write';

const
  MaxDeflateHashChain  = 64; // Must be integer power of 2

  MaxDeflateHashBuffer = 65536;
  LitLengthValue = -1;
  DistValue      = -2;

type
  TDeflateHashTable = array[0..65535] of record
                                           Chain : array[0..MaxDeflateHashChain-1] of LongInt; // 64kb*64k*4=16 MB!
                                           Next  : Byte;
                                         end;
  TDeflateCompressionMethod = (cmAutoHuffman,cmFixedHuffman,cmStore);

  TDeflateHuffmanBuffer = array[0..MaxDeflateHashBuffer] of record
                                                              Value : Word;
                                                              Info : SmallInt;
                                                            end;

  TDeflateStream = class(THuffmanBitStream)
    protected
      fCompressionMethod : TDeflateCompressionMethod;
      procedure SetCompressionMethod(Method: TDeflateCompressionMethod);

    public
      property CompressionMethod : TDeflateCompressionMethod read fCompressionMethod write SetCompressionMethod;

      constructor Create(NextStream: TBaseStream; Mode: Integer=-1); // fmRead, fmWrite or -1 for autodetect
      destructor Destroy; override;

      function Write(var Buf; Count: Integer): Integer; override;
      function Read(var Buf; Count: Integer): Integer; override;

      // Write data in look-ahead and reset 1-byte read/write buffer
      procedure Flush; override;

      // Return value is >0 if there is available data
      function Available: Integer; override;

    private
      LookBack : PByteArray;
      LookBackPtr, BufferPtr : Word;
      BufferSize : DWord;
      Final, FinishBlock, InBlock : Boolean;
      LittLengthCodes, DistCodes : THuffmanCodes;
      LittLengthTree, DistTree : THuffmanTree;

      // Decoder
      DecodeState : (dsNewBlock,dsBufferRead,dsDecodeSegment);

      // Encoder
      Position : Integer;
      HashTable : ^TDeflateHashTable;
      HuffmanBuffer : ^TDeflateHuffmanBuffer;
      HuffmanBufferPos : Integer;
    end;

const
  fmRead  = 0;
  fmWrite = 1;
// Open compressed, buffered file. Makes it unnessacary to include other stream units
function OpenDeflateFile(Name: string; Mode: Integer): TDeflateStream;

implementation

uses MemUtils;

// Open defalte compressed, buffered file
function OpenDeflateFile(Name: string; Mode: Integer): TDeflateStream;
begin
  if Mode=fmRead then Result:=TDeflateStream.Create(TBufferedStream.Create(-1,0,TFileStream.Create(Name,[fsRead,fsShareRead])))
  else Result:=TDeflateStream.Create(TBufferedStream.Create(0,-1,TFileStream.Create(Name,fsRewrite)));
end;

//=======================================================================================================
// TDeflateStream
//=======================================================================================================

procedure LogCodes(var CodeLength: array of Byte; CodeCount: Integer; const FileName: string);
var
  Log : TextFile;
  I : Integer;
begin
  AssignFile(Log,FileName);
  Rewrite(Log);
  WriteLn(Log,'Code count: ',CodeCount);
  for I:=0 to CodeCount-1 do WriteLn(Log,I:3,': ',CodeLength[I]:3);
  CloseFile(Log);
end;

const
  MaxHuffmanCodeLength = 15;

procedure SetFixedLittLengthCodes(var LittLengthCodes: THuffmanCodes);
var
  Value, Code, RevCode, Bits : Integer;
begin
  // Set length codes
  for Value:=0 to 143 do
  begin
    Code:=Value+48;
    RevCode:=0;
    for Bits:=0 to 7 do RevCode:=(RevCode shl 1) or ((Code shr Bits) and 1);
    LittLengthCodes.List[Value].Code:=RevCode;
    LittLengthCodes.List[Value].Length:=8;
  end;
  for Value:=144 to 255 do
  begin
    Code:=Value+(-144+400);
    RevCode:=0;
    for Bits:=0 to 8 do RevCode:=(RevCode shl 1) or ((Code shr Bits) and 1);
    LittLengthCodes.List[Value].Code:=RevCode;
    LittLengthCodes.List[Value].Length:=9;
  end;
  for Value:=256 to 279 do
  begin
    Code:=Value+(-256+0);
    RevCode:=0;
    for Bits:=0 to 6 do RevCode:=(RevCode shl 1) or ((Code shr Bits) and 1);
    LittLengthCodes.List[Value].Code:=RevCode;
    LittLengthCodes.List[Value].Length:=7;
  end;
  for Value:=280 to 285 do
  begin
    Code:=Value+(-280+192);
    RevCode:=0;
    for Bits:=0 to 7 do RevCode:=(RevCode shl 1) or ((Code shr Bits) and 1);
    LittLengthCodes.List[Value].Code:=RevCode;
    LittLengthCodes.List[Value].Length:=8;
  end;
end;

//-----------------------------------------------------------------------------------
// Create a new deflate stream.
constructor TDeflateStream.Create(NextStream: TBaseStream; Mode: Integer);
begin
  inherited Create(NextStream);

  if Next.CanWrite and ((Mode=-1) or (Mode=fmWrite)) then
  begin
    fCanWrite:=True;
    GetMem(HashTable,SizeOf(TDeflateHashTable));
    FillChar(HashTable^,SizeOf(TDeflateHashTable),$80);
    New(HuffmanBuffer);
  end
  else if Next.CanRead and ((Mode=-1) or (Mode=fmRead)) then
  begin
    fCanRead:=True;
    LittLengthTree.Init(288);
    DistTree.Init(32);
  end;
  Assert(fCanWrite or fCanRead);

  LittLengthCodes.Init(288);
  DistCodes.Init(32);
  GetMem(LookBack,$10000);
end;

//-----------------------------------------------------------------------------------
// Flush and free memory
destructor TDeflateStream.Destroy;
begin
  Final:=True;
  Flush;
  inherited Flush;
  inherited Destroy;
  if CanWrite then
  begin
    FreeMem(HuffmanBuffer);
    FreeMem(HashTable);
  end;
  FreeMem(LookBack);
end;

//-----------------------------------------------------------------------------------
// Return value is >0 if there is available data
function TDeflateStream.Available;
begin
  Available:=inherited Available+Integer(BufferSize);
end;

const
  CodeOrder : array[0..18] of Integer = (16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15);

//-----------------------------------------------------------------------------------
function TDeflateStream.Read(var Buf; Count: Integer): Integer;
var
  Get : Integer;
  I, Code, CodePos : Cardinal;
  Len, NLen, Dist, CopyPtr : Word;
  BlockType, R : Byte;
  CodeLengthTree : THuffmanTree;
  LengthCodeCount : Cardinal;
  DistCodeCount, LastCodeLengthCode : Byte;
  CodeLength : array[0..285+32] of Byte;
begin
  fCanWrite:=False;
  Result:=0;
  while Count>0 do
  begin
    case DecodeState of
      dsNewBlock : begin
                     if Final then
                     begin
                       if NoDataExcept then raise EInOutError.Create(rs_ReadLessError)
                       else Break;
                     end;

                     ReadBits(Final,1);
                     ReadBits(BlockType,2);
                     case BlockType of
                       0 : begin // Read uncompressed block
                             inherited Flush;
                             Next.Read(Len,2);
                             Next.Read(NLen,2);
                             if Len<>not NLen then raise Exception.Create(rsErrorInCompressedData);

                             BufferSize:=Len;
                             BufferPtr:=LookBackPtr;
                             Get:=Len;
                             if Get>$10000-LookBackPtr then Get:=$10000-LookBackPtr;
                             Next.Read(LookBack^[LookBackPtr],Get);
                             Inc(LookBackPtr,Get);
                             Dec(Len,Get);
                             if Len>0 then
                             begin
                               Next.Read(LookBack^[LookBackPtr],Len);
                               Inc(LookBackPtr,Get);
                             end;
                             InBlock:=False;
                             DecodeState:=dsBufferRead;
                           end;
                       1 : begin // Compressed with fixed Huffman codes
                             SetFixedLittLengthCodes(LittLengthCodes);
                             LittLengthTree.Build(LittLengthCodes);

                             // Set distance codes
                             DistCodes.FixCodes(5);
                             DistTree.Build(DistCodes);

                             InBlock:=True;
                             DecodeState:=dsDecodeSegment;
                           end;
                       2 : begin // Compressed with dynamic Huffman codes
                             CodeLengthTree.Init(19);

                             LengthCodeCount:=0;
                             ReadBits(LengthCodeCount,5); Inc(LengthCodeCount,257);
                             ReadBits(DistCodeCount,5); Inc(DistCodeCount);

                             // Read Huffman codes for decompressing distance/length Huffman trees
                             ReadBits(LastCodeLengthCode,4); Inc(LastCodeLengthCode,3);
                             ZeroMem(CodeLength,SizeOf(CodeLength));
                             for I:=0 to LastCodeLengthCode do ReadBits(CodeLength[CodeOrder[I]],3);
                             //LogCodes(CodeLength,19,'x:\treecodes.txt');
                             CodeLengthTree.Build(CodeLength,7);

                             // Decompress length codes
                             CodePos:=0;
                             I:=LengthCodeCount+DistCodeCount;
                             while CodePos<I do
                             begin
                               Code:=GetSymbol(CodeLengthTree);
                               case Code of
                                 0..15 : begin // Code length 0-15
                                           CodeLength[CodePos]:=Code;
                                           Inc(CodePos);
                                         end;
                                 16    : begin // Repeat last length code 3-6 times
                                           ReadBits(R,2); Inc(R,3);
                                           FillChar(CodeLength[CodePos],R,CodeLength[CodePos-1]);
                                           Inc(CodePos,R);
                                         end;
                                 17    : begin // Repeat zero 3-10 times
                                           ReadBits(R,3); Inc(R,3);
                                           ZeroMem(CodeLength[CodePos],R);
                                           Inc(CodePos,R);
                                         end;
                                 18    : begin // Repeat zero 11-138 times
                                           ReadBits(R,7); Inc(R,11);
                                           ZeroMem(CodeLength[CodePos],R);
                                           Inc(CodePos,R);
                                         end;
                                 else raise Exception.Create(rsErrorInCompressedData);
                               end;
                             end;

                             //LogCodes(CodeLength[0],LengthCodeCount,'x:\LittLengthCodes.txt');
                             //LogCodes(CodeLength[LengthCodeCount],DistCodeCount,'x:\distcodes.txt');

                             DistTree.Build(CodeLength[LengthCodeCount],MaxHuffmanCodeLength);
                             ZeroMem(CodeLength[LengthCodeCount],33);
                             LittLengthTree.Build(CodeLength,MaxHuffmanCodeLength);

                             InBlock:=True;
                             DecodeState:=dsDecodeSegment;
                           end;
                       3 : raise Exception.Create(rsErrorInCompressedData);
                     end;            
                   end;
      dsDecodeSegment : begin
                          Code:=GetSymbol(LittLengthTree);
                          if Code<256 then // Litteral
                          begin
                            LookBack^[LookBackPtr]:=Code; // Store in look back
                            Inc(LookBackPtr);
                            TByteArray(Buf)[Result]:=Code; // Store in output buffer
                            Dec(Count);
                            Inc(Result);
                            DecodeState:=dsDecodeSegment
                          end
                          else if Code=256 then // End of block
                          begin
                            DecodeState:=dsNewBlock;
                          end
                          else // Look back reference
                          begin
                            case Code of  // Decode length
                              257..264 : Len:=Code-254;
                              265..268 : Len:=(Code-265) shl 1+ReadBit+11;
                              269..272 : begin
                                           ReadBits(R,2);
                                           Len:=(Code-269) shl 2+R+19;
                                         end;
                              273..276 : begin
                                           ReadBits(R,3);
                                           Len:=(Code-273) shl 3+R+35;
                                         end;
                              277..280 : begin
                                           ReadBits(R,4);
                                           Len:=(Code-277) shl 4+R+67;
                                         end;
                              281..284 : begin
                                           ReadBits(R,5);
                                           Len:=(Code-281) shl 5+R+131;
                                         end;
                              285      : Len:=258;
                            else raise Exception.Create(rsErrorInCompressedData);
                            end;{}

                            Code:=GetSymbol(DistTree); // Decode distance
                            if Code<=3 then Dist:=Code+1
                            else
                            begin
                              Get:=(Code-4) div 2+1; // Number of extra bits to read
                              Dist:=0;
                              ReadBits(Dist,Get);
                              Dist:=(Dist or ((Code and 1) shl Get))+1 shl (Get+1)+1;
                            end;

                            BufferSize:=Len;
                            BufferPtr:=LookBackPtr;

                            // Copy from look back
                            CopyPtr:=LookBackPtr-Dist;
                            for I:=1 to Len do
                            begin
                              LookBack^[LookBackPtr]:=LookBack^[CopyPtr];
                              Inc(LookBackPtr);
                              Inc(CopyPtr);
                            end;

                            DecodeState:=dsBufferRead;
                          end
                        end;
      dsBufferRead : begin  // Just read from buffer
                       Get:=Count;
                       if Get>Integer(BufferSize) then Get:=BufferSize;
                       if Get>$10000-BufferPtr then Get:=$10000-BufferPtr;
                       Move(LookBack^[BufferPtr],TByteArray(Buf)[Result],Get);
                       Dec(Count,Get);
                       Dec(BufferSize,Get);
                       Inc(Result,Get);
                       Inc(BufferPtr,Get);
                       if BufferSize=0 then // Buffer empty
                       begin
                         if InBlock then DecodeState:=dsDecodeSegment
                         else DecodeState:=dsNewBlock;
                       end;
                     end;
    end;
  end;
end;

//-----------------------------------------------------------------------------------
procedure TDeflateStream.SetCompressionMethod(Method: TDeflateCompressionMethod);
begin
  if InBlock and (Method<>fCompressionMethod) then Flush;
  fCompressionMethod:=Method;
end;

//-----------------------------------------------------------------------------------
{$WARNINGS OFF}
function TDeflateStream.Write(var Buf; Count: Integer): Integer;
type
  THashValue = packed record
                 case Integer of
                   0 : (Index : Word);
                   1 : (V_1, V0 : Byte);
                 end;

  procedure MoveToLookBack(Count: Cardinal);
  var
    HashValue : THashValue;
    I : Cardinal;
    W : Word;
  begin
    if Position=0 then
    begin
      Inc(LookBackPtr);
      Dec(BufferSize);
      Dec(Count);
      Inc(Position);
    end;

    W:=LookBackPtr-1; HashValue.V0:=LookBack^[W];

    for I:=1 to Count do
    begin
      HashValue.V_1:=HashValue.V0;
      HashValue.V0:=LookBack^[LookBackPtr];
      with HashTable^[HashValue.Index] do
      begin
        Chain[Next and (MaxDeflateHashChain-1)]:=Position;
        Inc(Next);
      end;
      Inc(LookBackPtr);
      Inc(Position);
    end;
    Dec(BufferSize,Count);
  end;

  procedure WriteUncompressedBlock; // Write uncompressed data
  var
    NLEN : Word;
    Get : Cardinal;
  begin
    WriteBits(Cardinal(Final),1);
    WriteBits(0,2);
    inherited Flush;
    Next.Write(BufferSize,2);
    NLen:=not BufferSize;
    Next.Write(NLEN,2);

    Get:=$10000-LookBackPtr;
    if Get>BufferSize then Get:=BufferSize;
    Next.Write(LookBack^[LookBackPtr],Get); // Write first part of buffer
    MoveToLookBack(Get);
    if BufferSize>0 then // Write rest of buffer if anything left
    begin
      Next.Write(LookBack^[LookBackPtr],BufferSize);
      MoveToLookBack(BufferSize);
    end;
    FinishBlock:=False;
    Final:=False;
  end;

  procedure CompressDataFixed; // Compress data using fixed Huffman codes
  var
    I, Dist, BestDist, BestLength, Extra, Code : Integer;
    //BestLength1 : Integer;
    Length : DWord;
    HashValue : THashValue;
    LookAheadSearchPtr, LookBackSearchPtr : Word;
  begin
    if not InBlock then // Start new block
    begin
      WriteBits(Cardinal(Final),1); // Write Final bit
      Final:=False;
      WriteBits(1,2); // Signal compressed with fixed Huffman codes

      // Set length codes
      SetFixedLittLengthCodes(LittLengthCodes);

      // Set distance codes
      DistCodes.FixCodes(5);

      InBlock:=True;
    end;
    while (BufferSize>=258) or (FinishBlock and (BufferSize>=3)) do
    begin
      // Find hash value
      HashValue.V_1:=LookBack^[LookBackPtr];
      HashValue.V0:=LookBack^[Word(LookBackPtr+1) and $ffff];
      {HashValue.V_1:=LookBack^[LookBackPtr] xor ((LookBack^[Word(LookBackPtr+2) and $ffff]) shr 2);
      HashValue.V0:=LookBack^[Word(LookBackPtr+1) and $ffff] xor ((LookBack^[Word(LookBackPtr+2) and $ffff]) shl 2);{}

      // Find longest match in hash chain
      BestLength:=2;
      with HashTable^[HashValue.Index] do
        for I:=MaxDeflateHashChain-1 downto 0 do // Try nearest match first for shorter distance codes
        begin
          Dist:=Position-Chain[(I+Next) and (MaxDeflateHashChain-1)]+1;
          if (Dist>0) and (Dist<=32768) then
          begin
            if (LookBack^[(LookBackPtr-Dist+BestLength) and $ffff]<>LookBack^[(LookBackPtr+BestLength) and $ffff]) then Continue;

            Length:=2;
            LookAheadSearchPtr:=LookBackPtr+2;
            LookBackSearchPtr:=LookBackPtr-Dist+2;
            while (LookBack^[LookBackSearchPtr]=LookBack^[LookAheadSearchPtr]) and (Length<BufferSize) and (Length<258) do
            begin
              Inc(Length);
              Inc(LookAheadSearchPtr);
              Inc(LookBackSearchPtr);
            end;

            if Length>DWord(BestLength) then
            begin
              BestLength:=Length;
              BestDist:=Dist;
            end;
          end
          else Break;
        end;

      // Find hash value for next byte - does it pay off to lave a byte uncompressed?
      {BestLength1:=BestLength+1;
      HashValue.V_1:=HashValue.V0;
      HashValue.V0:=LookBack^[Word(LookBackPtr+2) and $ffff];
      // Find longest match in hash chain for next byte
      with HashTable^[HashValue.Index] do
        for I:=0 to MaxDeflateHashChain-1 do
        begin
          Dist:=Position-Chain[I]+1;
          if (Dist>0) and (Dist<=32768) then
          begin
            if (LookBack^[(LookBackPtr-Dist+BestLength1) and $ffff]<>LookBack^[(LookBackPtr+BestLength1) and $ffff]) then Continue;
            Length:=2;
            LookAheadSearchPtr:=LookBackPtr+3;
            LookBackSearchPtr:=LookBackPtr-Dist+3;
            while (LookBack^[LookBackSearchPtr]=LookBack^[LookAheadSearchPtr]) and (Length<BufferSize) and (Length<258) do
            begin
              Inc(Length);
              Inc(LookAheadSearchPtr);
              Inc(LookBackSearchPtr);
            end;
            if Length>BestLength1 then
            begin
              BestLength:=0;
              Break;
            end;
          end;
        end;{}

      if BestLength>=3 then // At least 3 characters found in look back
      begin
        // Write length code
        if BestLength<=10 then
        begin
          with LittLengthCodes.List[254+BestLength] do WriteBits(Code,Length);
        end
        else if BestLength<=257 then // 1-5 extra bits
        begin
          Extra:=(BestLength-3) shr 3;
          for I:=1 to 5 do // Count number of bits used
          begin
            Extra:=Extra shr 1;
            if Extra=0 then
            begin
              Extra:=I; // Number of extra bits found
              Break;
            end;
          end;
          I:=BestLength-(3+4 shl Extra);
          with LittLengthCodes.List[261+Extra*4+I shr Extra] do WriteBits(Code,Length);
          WriteBits(I and ((1 shl Extra)-1),Extra);
        end
        else // BestLength=258
        begin
          with LittLengthCodes.List[285] do WriteBits(Code,Length);
        end;

        // Write distance code
        Dec(BestDist);
        if BestDist<4 then
        begin
          with DistCodes.List[BestDist] do WriteBits(Code,Length);
        end
        else
        begin
          Extra:=BestDist shr 2;
          for I:=1 to 13 do // Count number of bits used
          begin
            Extra:=Extra shr 1;
            if Extra=0 then
            begin
              Extra:=I; // Number of extra bits found
              Break;
            end;
          end;
          Code:=(Extra+1) shl 1+(BestDist shr Extra) and 1;
          with DistCodes.List[Code] do WriteBits(Code,Length); // Write code
          WriteBits(BestDist and (1 shl Extra-1),Extra); // Write extra bits
        end;

        MoveToLookBack(BestLength); // Move bytes to look-back
      end
      else // Just Huffman compress next byte
      begin
        with LittLengthCodes.List[LookBack^[LookBackPtr]] do WriteBits(Code,Length);
        MoveToLookBack(1);
      end;
    end;

    if FinishBlock then
    begin
      while BufferSize>0 do
      begin
        with LittLengthCodes.List[LookBack^[LookBackPtr]] do WriteBits(Code,Length);
        MoveToLookBack(1);
      end;
      with LittLengthCodes.List[256] do WriteBits(Code,Length); // Write end-of-block marker
      FinishBlock:=False;
      InBlock:=False;
    end
  end;

  procedure CompressDataAuto; // Compress data using optimal Huffman codes

    procedure HuffmanCompressData;
    var
      LengthLittStat, DistStat : PCardinalArray;
      I, C, CompCodeCount, LittLengthCodeCount, DistCodeCount, LastCodeLengthCode, LastCode, CodeCount : Integer;
      CodeLength : array[0..288+32] of Byte;
      CompCodeLength : array[0..288+32-1] of record
                                               Value : Byte;
                                               Info : ShortInt;
                                             end;
      CodeLengthCodes : THuffmanCodes;
      CodeLengthStat : array[0..18] of Cardinal;

    begin
      // Write block header
      if (BufferSize=0) and Final then
      begin
        WriteBits(Cardinal(Final),1); // Write Final bit
        Final:=False;
      end
      else WriteBits(0,1); // Write Final bit
      WriteBits(2,2); // Signal compressed with dynamic Huffman codes

      // Add end-of-block marker to code buffer
      with HuffmanBuffer^[HuffmanBufferPos] do
      begin
        Value:=256;
        Info:=LitLengthValue;
      end;
      Inc(HuffmanBufferPos);

      // Find optimal Huffman codes
      GetMem(LengthLittStat,288*SizeOf(Integer));
      GetMem(DistStat,32*SizeOf(Integer));
      try
        // Calculate statistics
        ZeroMem(LengthLittStat^,288*SizeOf(Integer));
        ZeroMem(DistStat^,32*SizeOf(Integer));
        for I:=0 to HuffmanBufferPos-1 do // Calculate litt/length and dist statistics
          case HuffmanBuffer^[I].Info of
            LitLengthValue : Inc(LengthLittStat^[HuffmanBuffer^[I].Value]);
            DistValue      : Inc(DistStat^[HuffmanBuffer^[I].Value]);
          end;

        // Find Huffman codes
        LittLengthCodes.FindCodesStat(LengthLittStat,MaxHuffmanCodeLength);
        DistCodes.FindCodesStat(DistStat,MaxHuffmanCodeLength);
      finally
        FreeMem(DistStat);
        FreeMem(LengthLittStat);
      end;{}

      // Count number of codes used
      LittLengthCodeCount:=1;
      for I:=285 downto 1 do if LittLengthCodes.List[I].Length<>0 then
      begin
        LittLengthCodeCount:=I+1;
        Break;
      end;
      DistCodeCount:=1;
      for I:=29 downto 1 do if DistCodes.List[I].Length<>0 then
      begin
        DistCodeCount:=I+1;
        Break;
      end;

      // Combine code lengths in one array
      for I:=0 to LittLengthCodeCount-1 do CodeLength[I]:=LittLengthCodes.List[I].Length;
      for I:=0 to DistCodeCount-1 do CodeLength[LittLengthCodeCount+I]:=DistCodes.List[I].Length;

      // RLE compress code lengths
      ZeroMem(CodeLengthStat,SizeOf(CodeLengthStat)); // Reset histogram accumulator
      CompCodeCount:=0;
      CodeCount:=1;
      LastCode:=CodeLength[0];
      CodeLength[LittLengthCodeCount+DistCodeCount]:=$ff; // Insert a code to terminate run length
      for I:=1 to LittLengthCodeCount+DistCodeCount do if CodeLength[I]=LastCode then Inc(CodeCount)
      else
      begin
        if LastCode<>0 then
        begin
          CompCodeLength[CompCodeCount].Info:=-1;
          CompCodeLength[CompCodeCount].Value:=LastCode;
          Inc(CodeLengthStat[LastCode]);
          Inc(CompCodeCount);
          Dec(CodeCount);
        end;

        while CodeCount>=3 do
        begin
          if LastCode<>0 then // Repeat 3-6 times
          begin
            CompCodeLength[CompCodeCount].Info:=-1;
            CompCodeLength[CompCodeCount].Value:=16;
            Inc(CodeLengthStat[16]);
            Inc(CompCodeCount);

            C:=CodeCount;
            if C>6 then C:=6;
            CompCodeLength[CompCodeCount].Info:=2;                // 2 extra bits
            CompCodeLength[CompCodeCount].Value:=C-3;
            Inc(CompCodeCount);

            Dec(CodeCount,C);
          end
          else if CodeCount<=10 then // 3-10 x 0
          begin
            CompCodeLength[CompCodeCount].Info:=-1;
            CompCodeLength[CompCodeCount].Value:=17;
            Inc(CodeLengthStat[17]);
            Inc(CompCodeCount);

            CompCodeLength[CompCodeCount].Info:=3;                // 3 extra bits
            CompCodeLength[CompCodeCount].Value:=CodeCount-3;
            Inc(CompCodeCount);

            CodeCount:=0;
          end
          else // 11-138 x 0
          begin
            CompCodeLength[CompCodeCount].Info:=-1;
            CompCodeLength[CompCodeCount].Value:=18;
            Inc(CodeLengthStat[18]);
            Inc(CompCodeCount);

            C:=CodeCount;
            if C>138 then C:=138;
            CompCodeLength[CompCodeCount].Info:=7;                // 7 extra bits
            CompCodeLength[CompCodeCount].Value:=C-11;
            Inc(CompCodeCount);

            Dec(CodeCount,C);
          end
        end;

        for C:=1 to CodeCount do
        begin
          CompCodeLength[CompCodeCount].Info:=-1;
          CompCodeLength[CompCodeCount].Value:=LastCode;
          Inc(CodeLengthStat[LastCode]);
          Inc(CompCodeCount);
        end;

        // Write code length I
        LastCode:=CodeLength[I];
        CodeCount:=1;
      end;

      // Find Huffman tree for codes
      CodeLengthCodes.Init(19);
      CodeLengthCodes.FindCodesStat(@CodeLengthStat,7); // Find optimal codes

      // Find number of code length codes
      LastCodeLengthCode:=0;
      for I:=18 downto 1 do if CodeLengthCodes.List[CodeOrder[I]].Length<>0 then
      begin
        LastCodeLengthCode:=I;
        Break;
      end;
      //LastCodeLengthCode:=18;

      WriteBits(LittLengthCodeCount-257,5); // Number of literal/length codes
      WriteBits(DistCodeCount-1,5); // Number of distance codes
      WriteBits(LastCodeLengthCode+1-4,4); // Number of code length codes

      // Write Huffman trees
      for I:=0 to LastCodeLengthCode do WriteBits(CodeLengthCodes.List[CodeOrder[I]].Length,3); // Write 3 bit code lengths
      for I:=0 to CompCodeCount-1 do
      begin
        if CompCodeLength[I].Info=-1 then with CodeLengthCodes.List[CompCodeLength[I].Value] do WriteBits(Code,Length)
        else WriteBits(CompCodeLength[I].Value,CompCodeLength[I].Info);
      end;

      // Write data
      for I:=0 to HuffmanBufferPos-1 do with HuffmanBuffer^[I] do
        case Info of
          LitLengthValue : with LittLengthCodes.List[Value] do WriteBits(Code,Length);
          DistValue      : with DistCodes.List[Value] do WriteBits(Code,Length);
        else
          WriteBits(Value,Info);
        end;

      FinishBlock:=False;
      InBlock:=False;
    end;

  var
    I, Dist, BestDist, BestLength, Extra, Code, Length : Integer;
    //BestLength1 : Integer;
    HashValue : THashValue;
    LookAheadSearchPtr, LookBackSearchPtr : Word;
  begin
    if not InBlock then
    begin
      HuffmanBufferPos:=0;
      InBlock:=True;
    end;

    while InBlock and ((BufferSize>=258) or (FinishBlock and (BufferSize>=3))) do
    begin
      // Find hash value
      HashValue.V_1:=LookBack^[LookBackPtr];
      HashValue.V0:=LookBack^[Word(LookBackPtr+1) and $ffff];

      // Find longest match in hash chain
      BestLength:=2;
      with HashTable^[HashValue.Index] do
        for I:=MaxDeflateHashChain-1 downto 0 do // Try nearest match first for shorter distance codes
        begin
          Dist:=Position-Chain[(I+Next) and (MaxDeflateHashChain-1)]+1;
          if (Dist>0) and (Dist<=32768) then
          begin
            if (LookBack^[(LookBackPtr-Dist+BestLength) and $ffff]<>LookBack^[(LookBackPtr+BestLength) and $ffff]) then Continue;

            Length:=2;
            LookAheadSearchPtr:=LookBackPtr+2;
            LookBackSearchPtr:=LookBackPtr-Dist+2;
            while (LookBack^[LookBackSearchPtr]=LookBack^[LookAheadSearchPtr]) and (Length<Integer(BufferSize)) and (Length<258) do
            begin
              Inc(Length);
              Inc(LookAheadSearchPtr);
              Inc(LookBackSearchPtr);
            end;

            if Length>BestLength then
            begin
              BestLength:=Length;
              BestDist:=Dist;
            end;
          end
          else Break;
        end;

      {BestLength1:=BestLength;  // Does it pay off to lave a byte uncompressed?
      HashValue.V_1:=HashValue.V0;
      HashValue.V0:=LookBack^[Word(LookBackPtr+2) and $ffff];
      // Find longest match in hash chain
      with HashTable^[HashValue.Index] do
        for I:=0 to MaxDeflateHashChain-1 do
        begin
          Dist:=Position-Chain[I]+1;
          if (Dist>0) and (Dist<=32768) then
          begin
            if (LookBack^[(LookBackPtr-Dist+BestLength1) and $ffff]<>LookBack^[(LookBackPtr+BestLength1) and $ffff]) then Continue;
            Length:=2;
            LookAheadSearchPtr:=LookBackPtr+3;
            LookBackSearchPtr:=LookBackPtr-Dist+3;
            while (LookBack^[LookBackSearchPtr]=LookBack^[LookAheadSearchPtr]) and (Length<BufferSize) and (Length<258) do
            begin
              Inc(Length);
              Inc(LookAheadSearchPtr);
              Inc(LookBackSearchPtr);
            end;
            if Length>BestLength1 then
            begin
              BestLength:=0;
              Break;
            end;
          end;
        end;{}

      if BestLength>=3 then // At least 3 characters found in look-back
      begin
        // Write length code
        if BestLength<=10 then
        begin
          with HuffmanBuffer^[HuffmanBufferPos] do
          begin
            Value:=254+BestLength;
            Info:=LitLengthValue;
          end;
          Inc(HuffmanBufferPos);
        end
        else if BestLength<=257 then // 1-5 extra bits
        begin
          Extra:=(BestLength-3) shr 3;
          for I:=1 to 5 do // Count number of bits used
          begin
            Extra:=Extra shr 1;
            if Extra=0 then
            begin
              Extra:=I; // Number of extra bits found
              Break;
            end;
          end;
          I:=BestLength-(3+4 shl Extra);

          with HuffmanBuffer^[HuffmanBufferPos] do
          begin
            Value:=261+Extra*4+I shr Extra;
            Info:=LitLengthValue;
          end;
          Inc(HuffmanBufferPos);
          with HuffmanBuffer^[HuffmanBufferPos] do
          begin
            Value:=I and ((1 shl Extra)-1);
            Info:=Extra;
          end;
          Inc(HuffmanBufferPos);
        end
        else // BestLength=258
        begin
          with HuffmanBuffer^[HuffmanBufferPos] do
          begin
            Value:=285;
            Info:=LitLengthValue;
          end;
          Inc(HuffmanBufferPos);
        end;

        // Write distance code
        Dec(BestDist);
        if BestDist<4 then
        begin
          with HuffmanBuffer^[HuffmanBufferPos] do
          begin
            Value:=BestDist;
            Info:=DistValue;
          end;
          Inc(HuffmanBufferPos);
        end
        else
        begin
          Extra:=BestDist shr 2;
          for I:=1 to 13 do // Count number of bits used
          begin
            Extra:=Extra shr 1;
            if Extra=0 then
            begin
              Extra:=I; // Number of extra bits found
              Break;
            end;
          end;
          Code:=(Extra+1) shl 1+(BestDist shr Extra) and 1;
          with HuffmanBuffer^[HuffmanBufferPos] do
          begin
            Value:=Code;
            Info:=DistValue;
          end;
          Inc(HuffmanBufferPos);
          with HuffmanBuffer^[HuffmanBufferPos] do
          begin
            Value:=BestDist and (1 shl Extra-1);
            Info:=Extra;
          end;
          Inc(HuffmanBufferPos);
        end;

        MoveToLookBack(BestLength); // Move bytes to look-back
      end
      else // Just Huffman compress next byte
      begin
        with HuffmanBuffer^[HuffmanBufferPos] do
        begin
          Value:=LookBack^[LookBackPtr];
          Info:=LitLengthValue;
        end;
        Inc(HuffmanBufferPos);
        MoveToLookBack(1);
      end;

      if HuffmanBufferPos>MaxDeflateHashBuffer-10 then HuffmanCompressData;
    end;

    if FinishBlock then
    begin
      while BufferSize>0 do
      begin
        with HuffmanBuffer^[HuffmanBufferPos] do
        begin
          Value:=LookBack^[LookBackPtr];
          Info:=LitLengthValue;
        end;
        Inc(HuffmanBufferPos);
        MoveToLookBack(1);
      end;

      HuffmanCompressData;
    end
  end;

var
  Get : Integer;
  MaxBuffer : Cardinal;
begin
  if not fCanWrite then raise EInOutError.Create(rsWriteDenied);

  if CompressionMethod=cmStore then MaxBuffer:=65535
  else MaxBuffer:=32767;

  Result:=0;
  while (Count>0) or FinishBlock do
  begin
    Get:=MaxBuffer-BufferSize; // Try to fill buffer
    if Get>Count then Get:=Count; // Not enough data
    if Get>$10000-BufferPtr then Get:=$10000-BufferPtr; // BufferPtr too close to wrap-around

    Move(TByteArray(Buf)[Result],LookBack^[BufferPtr],Get); // Move from input to local buffer
    Inc(Result,Get); // Update counters/pointer
    Inc(BufferPtr,Get);
    Inc(BufferSize,Get);
    Dec(Count,Get);

    // Always write something when Final is set, and then reset it when BufferSize=0
    case CompressionMethod of
      cmAutoHuffman  : if (BufferSize>=258) or FinishBlock then CompressDataAuto;
      cmFixedHuffman : if (BufferSize>=258) or FinishBlock then CompressDataFixed;
      cmStore        : if (BufferSize=MaxBuffer) or FinishBlock then WriteUncompressedBlock;
    end;
  end;
end;
{$WARNINGS ON}

//-----------------------------------------------------------------------------------
// Write data in look-ahead and reset 1-byte read/write buffer
procedure TDeflateStream.Flush;
begin
  while CanWrite and ((BufferSize>0) or InBlock or Final) do
  begin
    FinishBlock:=True;
    Write(FinishBlock,0); // Write dummy
  end;
end;

end.

