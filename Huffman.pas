////////////////////////////////////////////////////////////////////////////////
//
// Huffman.pas - Huffman compression unit
// --------------------------------------
// Changed:   2003-05-09
// Maintain:  Michael Vinther    |    mv@logicnet·dk
//
// Contains:
//   THuffmanCodes
//   THuffmanTree
//   (TBaseStream)
//     (TFilterStream)
//       (TBitStream)
//         THuffmanBitStream
//
// Suggested improvements:
//
unit Huffman;

interface

uses SysUtils, BitStream, Math, Monitor, MemUtils;

const
  MaxHuffmanCodes = 289;

  RightBit = 1;
  LeftBit  = 0;

  NoNode = $ffff;

type
  TTreeNode = record
                Right, Left, Parent : Word;
                Freq : Cardinal;
              end;

  THuffmanNodeList = array[0..MaxHuffmanCodes*2-1] of TTreeNode;

  PHuffmanTree = ^THuffmanTree;

  THuffmanCodes = object
    public
      LastCode : Cardinal;
      List : array[0..MaxHuffmanCodes-1] of record
                                              Code, Length : Cardinal;
                                            end;
      // Set symbol set size
      procedure Init(SymbolCount: Cardinal);
      // Find codes from list of symbol lengths
      procedure FindCodes(var LengthList; MaxBits: Integer); overload;
      // Get codes directly from tree
      procedure FindCodes(const Tree: PHuffmanTree); overload;
      // Get codes from statistics
      procedure FindCodesStat(FreqTable: PCardinalArray; MaxBits: Cardinal=32); // From Colosseum Builders C++ Image Library
      procedure FindCodesStat2(FreqTable: PCardinalArray; MaxBits: Cardinal=32);
      // Make codes of fixed bit length
      procedure FixCodes(Length: Cardinal);
    end;

  THuffmanTree = object
    public
      Tree : THuffmanNodeList;

      // Set symbol set size
      procedure Init(SymbolCount: Cardinal);
      // Build tree from list of codes
      procedure Build(const Codes: THuffmanCodes); overload;
      // Build tree from list of symbol lengths
      procedure Build(var LengthList; MaxBits: Integer); overload;
      // Build tree from symbol statistics
      procedure BuildStat(FreqTable: PCardinalArray);
      // Decode symbol from TBitStream
      function GetSymbol(Stream: TBitStream): Cardinal;
      // Code symbol and write to TBitStream
      procedure WriteSymbol(Symbol: Cardinal; Stream: TBitStream);
    protected
      LastCode, LastNode, Root : Cardinal;
    end;

  THuffmanBitStream = class(TBitStream)
    public
      function GetSymbol(const Tree: THuffmanTree): Cardinal;
    end;

procedure CalcHistogram(var Data; Length: Cardinal; var Stat: array of Cardinal);
procedure PrintCodes(const Codes: THuffmanCodes);

implementation

procedure CalcHistogram(var Data; Length: Cardinal; var Stat: array of Cardinal);
begin
  for Length:=0 to Length-1 do
    Inc(Stat[TByteArray(Data)[Length]]);
end;

procedure PrintCodes(const Codes: THuffmanCodes);
var
  N, C, B : Integer;
begin
  for N:=0 to Codes.LastCode do
  begin
    Write(N:5,': ');
    C:=Codes.List[N].Code;
    for B:=0 to Codes.List[N].Length-1 do Write((C shr B) and 1);
    for B:=Codes.List[N].Length to 32 do Write(' ');
  end;
end;

procedure PrintTreeCodes(var Tree: THuffmanTree);
var
  Codes: THuffmanCodes;
  N, C, B : Integer;
begin
  Codes.LastCode:=Tree.LastCode;
  Codes.FindCodes(@Tree);
  for N:=0 to Codes.LastCode do
  begin
    Write(N:3,': ');
    C:=Codes.List[N].Code;
    for B:=0 to Codes.List[N].Length-1 do Write((C shr B) and 1);
    WriteLn;
  end;
end;

//=======================================================================================================
// THuffmanCodes
//=======================================================================================================
procedure THuffmanCodes.Init(SymbolCount: Cardinal);
begin
  LastCode:=SymbolCount-1;
end;

procedure THuffmanCodes.FindCodes(var LengthList; MaxBits: Integer);
var
  LengthCount : array[0..32] of Cardinal;
  NextCode : array[1..32] of Cardinal;
  N, Code, RevCode, Bits : Cardinal;
begin
  ZeroMem(LengthCount,SizeOf(LengthCount));
  for N:=0 to LastCode do Inc(LengthCount[TByteArray(LengthList)[N]]);
  Code:=0;
  LengthCount[0]:=0;
  for Bits:=1 to MaxBits do
  begin
    Code:=(Code+LengthCount[Bits-1]) shl 1;
    NextCode[Bits]:=Code;
  end;
  for N:=0 to LastCode do
  begin
    Bits:=TByteArray(LengthList)[N];
    List[N].Length:=Bits;
    if Bits<>0 then
    begin
      Code:=NextCode[Bits];
      Inc(NextCode[Bits]);

      // Reverse bit order
      RevCode:=0;
      for Bits:=0 to Bits-1 do RevCode:=(RevCode shl 1) or ((Code shr Bits) and 1);
      List[N].Code:=RevCode;
    end;
  end;
end;

procedure THuffmanCodes.FindCodes(const Tree: PHuffmanTree);
var
  N, Node, Length, Code : Cardinal;
begin
  for N:=0 to Tree^.LastCode do
  begin
    Node:=N;
    Length:=0;
    Code:=0;
    while (Node<>Tree^.Root) and (Tree^.Tree[Node].Parent<>NoNode) do
    begin
      Inc(Length);
      if Tree^.Tree[Tree^.Tree[Node].Parent].Right=Node then Code:=(Code shl 1) or RightBit
      else Code:=(Code shl 1) or LeftBit;
      Node:=Tree^.Tree[Node].Parent;
    end;
    Assert(Length<=32);
    List[N].Code:=Code; // For reverse bit order
    List[N].Length:=Length;
  end;
end;

{$HINTS OFF}
{$WARNINGS OFF}

// Method from "Colosseum Builders C++ Image Library", based on
// "Compressed Image File Formats: JPEG, PNG, GIF, XBM and BMP"
// by John Miano
// Addison-Wesley-Longman 1999
procedure THuffmanCodes.FindCodesStat(FreqTable: PCardinalArray; MaxBits: Cardinal);
var
  CodesTooLong : Boolean;
  ii, jj, kk : Integer;
  Others : array[0..MaxHuffmanCodes-1] of Integer;
  CodeSize : array[0..MaxHuffmanCodes-1] of Cardinal;
  Done : Boolean;
  v1, v2 : Integer;
  HuffBits : array[0..2*31-1] of Integer;
  HuffValues : array[0..MaxHuffmanCodes-1] of Cardinal;
  HuffSizes : array[0..MaxHuffmanCodes-1] of Cardinal;
  HuffCodes : array[0..MaxHuffmanCodes-1] of Cardinal;
  Value, Code, Size, Bit : Cardinal;
  si : Cardinal;
begin
  ZeroMem(List,SizeOf(List));
  CodesTooLong := False;

  // Build the Huffman Code Length Lists
  FillChar(Others,(1+LastCode)*SizeOf(Cardinal),$ff);
  ZeroMem(CodeSize,(1+LastCode)*SizeOf(Cardinal));

  Done:=false;
  while not Done do
  begin
    // Find the two smallest non-zero values
    v1 := -1; v2 := -1;
    for ii := 0 to LastCode Do
    begin
      if FreqTable^[ii] <> 0 then
      begin
        if (v1 < 0) Or (FreqTable^[ii] <= FreqTable^[v1]) then
        begin
          v2 := v1;
          v1 := ii;
        end
        else if (v2 < 0) Or (FreqTable^[ii] <= FreqTable^[v2]) then v2 := ii;
      end;
    end;
    if v2 < 0 then
    begin
      if v1 < 0 then Exit; // No codes defined

      if codesize [v1] = 0 then codesize [v1] := 1;  // Only one code defined
      done := true;
    end
    else
    begin
      // Join the two tree nodes.
      FreqTable^[v1] := FreqTable^[v1] + FreqTable^[v2];
      FreqTable^[v2] := 0;

      Inc (codesize [v1]);
      while others [v1] >= 0 Do
      begin
        v1 := others [v1];
        Inc (codesize [v1]);
      end;

      others [v1] := v2;

      Inc (codesize [v2]);
      while others [v2] >= 0 Do
      begin
        v2 := others [v2];
        Inc (codesize [v2]);
      end;
    end;
  end;
  // Determine the number of codes of length [n]
  for ii := 0 to 2 * MaxBits - 1 do huffbits [ii] := 0;

  for ii := Low (codesize) to LastCode do
    if codesize [ii] <> 0 then Inc (huffbits [codesize [ii] - 1]);

  // Ensure that no code is longer than maxlength.
  for ii := 2 * MaxBits -  1 Downto MaxBits Do
  begin
    while huffbits [ii] <> 0 Do
    begin
      CodesTooLong := true; // Remember that we had to reorder the tree

      jj := ii - 1;
      repeat
        Dec (jj);
      until huffbits [jj] <> 0;

      Dec (huffbits [ii], 2);
      Inc (huffbits [ii - 1]);
      Inc (huffbits [jj + 1], 2);
      Dec (huffbits [jj]);
    end;
  end;

  // Sort the values in order of code length.
  // What might not be clear is that codesize [n] is the length
  // of the Huffman code for n before it was shortened to maxcodelength.
  // That the values in codesize may be too large does not matter. The
  // ordering of the values by code size remains correct. As soon as this
  // step is complete, the codesize[] array is no longer used anyway.
  ZeroMem(HuffValues,(1+LastCode)*SizeOf(Cardinal));

  kk := 0;
  for ii := 1 to 2 * MaxBits - 1 Do
    begin
    for jj := 0 to LastCode Do
      begin
      if codesize [jj] = ii then
        begin
        huffvalues [kk] := jj;
        Inc (kk);
        end;
      end;
    end;

  // Convert the array "huffbits" containing the count of codes for each
  // length 1..maxcodelength into an array containing the length for each code.
  ZeroMem(HuffSizes,(1+LastCode)*SizeOf(Cardinal));

  ii := 0;
  kk := 0;
  while (ii < MaxBits) And (kk <= LastCode) Do
    begin
    for jj := 0 to huffbits [ii] - 1 Do
    begin
      huffsizes [kk] := ii + 1;
      Inc (kk);
    end;
    Inc (ii);
  end;

  // Calculate the Huffman code for each Huffman value.
  code := 0;
  kk := 0;
  si := huffsizes [0];
  while (kk <= LastCode) And (huffsizes [kk] <> 0) Do
    begin
    while (kk <= LastCode) And (huffsizes [kk] = si) Do
      begin
      huffcodes [kk] := code;
      Inc (code);
      Inc (kk);
      end;
    Inc (si);
    code := code Shl 1;
    end;

  for kk := 0 to LastCode Do
  begin
    if huffsizes [kk] <> 0 then
    begin
      ii := huffvalues [kk];
      List[ii].Code := huffcodes [kk];
      List[ii].Length := huffsizes [kk];
    end;
  end;


  // If the pure Huffman code generation created codes longer than the
  // maximum the it is possible that the order got screwed up. Such a
  // situation could occur if the maximum code length is 15 and during the
  // pure process we the value 150 got assigned a length of 13, 100 a length
  // of 15 and 200 a length of 17. During the process of reducing the code
  // length for 200 it is possible that 150 would have its code length
  // increased to 14 and 100 would have its code length reduced to 14.
  // Unfortunately the Huffman codes would be assigned using the old
  // order so that 150 would get assigned a smaller Huffman code than
  // 100.  Here we fix that and ensure that if ehufsi [ii] == ehufsi [jj]
  // and ii < jj then ehufco [ii] < ehufco [jj].
  if codestoolong then
    for ii := 0 to LastCode - 1 Do
      for jj := ii + 1 to LastCode Do
        if (List[ii].Length = List[jj].Length) And (List[ii].Code > List[jj].Code) then SwapDWords(List[jj].Code,List[ii].Code);

  // If the decoder reads from the least significant bit to the most
  // significant bit, the codes need to be reversed.
  for ii := 0 to LastCode Do
  begin
    value := 0;
    code := List[ii].Code;
    size := List[ii].Length;
    for jj := 0 to Size-1 do
    begin
      bit := (code and (1 shl jj)) shr jj;
      value := value or (bit shl (size - jj - 1));
    end;
    List[ii].Code := value;
  end;
end;

procedure THuffmanCodes.FindCodesStat2(FreqTable: PCardinalArray; MaxBits: Cardinal);
var
  Tree : THuffmanTree;
  N, Node, Length, Best1Freq, Best1N, Best2Freq, Best2N, IterCount : Cardinal;
  Ok : Boolean;
  LengthList : array[0..MaxHuffmanCodes] of Byte;
begin
  Tree.LastCode:=LastCode;
  IterCount:=0;
  repeat
    Tree.BuildStat(FreqTable);  // Build tree

    // Find code lengths
    Ok:=True;
    for N:=0 to LastCode do
      if FreqTable^[N]=0 then LengthList[N]:=0
      else
      begin
        Node:=N;
        Length:=0;
        while (Node<>Tree.Root) and (Tree.Tree[Node].Parent<>NoNode) do
        begin
          Inc(Length);
          Node:=Tree.Tree[Node].Parent;
        end;

        if Length>MaxBits then
        begin
          Ok:=False;
          Break;
        end;

        LengthList[N]:=Length;
      end;

    if not Ok then // A code was to long, change frequency table to make it shorter
    begin
      Inc(IterCount);

      {Assert(IterCount<32,'Too many codes for MaxBits');
      for N:=0 to LastCode do if FreqTable^[N]<>0 then FreqTable^[N]:=(FreqTable^[N] shr 1) or 1; {Half all frequencies}

      Assert(IterCount<Sqr(LastCode),'Too many codes for MaxBits');
      // Find the two lowest frequencies
      Best1Freq:=High(Best1Freq);
      for N:=0 to LastCode do if FreqTable^[N]>0 then
      begin
        if FreqTable^[N]<Best1Freq then
        begin
          Best2N:=Best1N; Best2Freq:=Best1Freq;
          Best1N:=N; Best1Freq:=FreqTable^[N];
        end
        else if (FreqTable^[N]<Best2Freq) and (FreqTable^[N]>Best1Freq) then
        begin
          Best2N:=N; Best2Freq:=FreqTable^[N];
        end
      end;
      // Modify lowest frequency to be equal to second-lowest
      FreqTable^[Best1N]:=FreqTable^[Best2N];{}
    end;
  until Ok;
  FindCodes(LengthList,MaxBits);
end;

{$HINTS ON}
{$WARNINGS ON}

procedure THuffmanCodes.FixCodes(Length: Cardinal);
var
  N, Bits, RevCode, Length_1 : Cardinal;
begin
  Length_1:=Length-1;
  for N:=0 to LastCode do
  begin
    RevCode:=0;
    for Bits:=0 to Length_1 do RevCode:=(RevCode shl 1) or ((N shr Bits) and 1);
    List[N].Code:=RevCode;
    List[N].Length:=Length;
  end;
end;

//=======================================================================================================
// THuffmanTree
//=======================================================================================================
procedure THuffmanTree.Init(SymbolCount: Cardinal);
begin
  LastCode:=SymbolCount-1;
end;

// Build tree from list of codes
procedure THuffmanTree.Build(const Codes: THuffmanCodes);
var
  Code, N, Node, NextNode : Cardinal;
  B : Integer;
  Bit : Cardinal;
begin
  LastCode:=Codes.LastCode;
  LastNode:=LastCode+1;
  for N:=LastNode to LastCode*2-1 do with Tree[N] do
  begin
    Left:=NoNode; Right:=NoNode; ///<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< = Root?
  end;
  Root:=LastNode;
  for N:=0 to LastCode do
  begin
    Code:=Codes.List[N].Code;
    if Codes.List[N].Length=0 then Tree[N].Parent:=NoNode
    else
    begin
      Node:=Root;
      for B:=1 to Codes.List[N].Length-1 do
      begin
        Bit:=Code and 1; Code:=Code shr 1;
        if Bit=RightBit then
        begin
          NextNode:=Tree[Node].Right;
          if NextNode=NoNode then
          begin
            Inc(LastNode);
            NextNode:=LastNode;
            Tree[Node].Right:=NextNode;
            Tree[NextNode].Parent:=Node;
          end;
          Node:=NextNode;
        end
        else
        begin
          NextNode:=Tree[Node].Left;
          if NextNode=NoNode then
          begin
            Inc(LastNode);
            NextNode:=LastNode;
            Tree[Node].Left:=NextNode;
            Tree[NextNode].Parent:=Node;
          end;
          Node:=NextNode;
        end;
      end;
      if Code and 1=RightBit then Tree[Node].Right:=N
      else Tree[Node].Left:=N;
      Tree[N].Parent:=Node;
    end;
  end;
end;

// Build tree from list of symbol lengths
procedure THuffmanTree.Build(var LengthList; MaxBits: Integer);
var
  Codes : THuffmanCodes;
begin
  Codes.LastCode:=LastCode;
  Codes.FindCodes(LengthList,MaxBits);
  Build(Codes);

//  PrintTreeCodes(Self);
end;

// Build tree with minimum variance code length from symbol statistics
procedure THuffmanTree.BuildStat(FreqTable: PCardinalArray);
var
  N : Integer;
  Low1, Low2, L1Freq, L2Freq : Cardinal;
begin
  for N:=0 to LastCode do with Tree[N] do
  begin
    Freq:=FreqTable^[N];
    Left:=NoNode; Right:=NoNode; Parent:=NoNode;
  end;
  LastNode:=LastCode;
  Low2:=0; L2Freq:=0;
  repeat
    // Find the two nodes with lowest frequency and no parents
    L1Freq:=High(L1Freq); Low1:=NoNode;
    for N:=0 to LastNode do with Tree[N] do if Parent=NoNode then
    begin
      if Freq<L1Freq then
      begin
        Low2:=Low1; L2Freq:=L1Freq;
        Low1:=N; L1Freq:=Freq;
      end
      else if Freq<L2Freq then
      begin
        Low2:=N; L2Freq:=Freq;
      end
    end;

    if Low2<>NoNode then // Two orphans found
    begin
      Inc(LastNode);
      Tree[Low1].Parent:=LastNode;
      Tree[Low2].Parent:=LastNode;
      with Tree[LastNode] do
      begin
        Left:=Low1; Right:=Low2;
        Freq:=L1Freq+L2Freq;
        Parent:=NoNode;
      end;
    end;
  until Low2=NoNode;
  Root:=LastNode;
end;

function THuffmanTree.GetSymbol(Stream: TBitStream): Cardinal;
begin
  Result:=Root;
  repeat
    Assert(Result<=LastNode);
    if Stream.ReadBit=RightBit then Result:=Tree[Result].Right
    else Result:=Tree[Result].Left;
  until Result<=LastCode;
end;

procedure THuffmanTree.WriteSymbol(Symbol: Cardinal; Stream: TBitStream);
var
  Length, Code : Cardinal;
begin
  Length:=0;
  Code:=0;
  while Symbol<>Root do
  begin
    Inc(Length);
    if Tree[Tree[Symbol].Parent].Right=Symbol then Code:=(Code shl 1) or RightBit
    else Code:=(Code shl 1) or LeftBit;
    Symbol:=Tree[Symbol].Parent;
  end;
  Stream.WriteBits(Code,Length); // Write in reverse bit order
end;

//=======================================================================================================
// THuffmanBitStream
//=======================================================================================================
function THuffmanBitStream.GetSymbol(const Tree: THuffmanTree): Cardinal;
begin
  with Tree do
  begin
    Result:=Root;
    repeat
      Assert(Result<=LastNode,'Invalid Huffman code');

      if (RBitPos=0) or (RBitPos=8) then
      begin
        Next.Read(Buffer,1);
        RBitPos:=0;
      end;

      if (Buffer shr RBitPos) and 1=RightBit then Result:=Tree[Result].Right
      else Result:=Tree[Result].Left;

      Inc(RBitPos);
    until Result<=LastCode;
  end;
end;

end.


