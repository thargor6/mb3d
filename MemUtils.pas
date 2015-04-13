///////////////////////////////////////////////////////////////////////////////////////////////
//
// MemUtils.pas
// --------------------------
// Changed:   2005-01-27
// Maintain:  Michael Vinther    |    mv@logicnet·dk
//
// Assembler optimized routines requires minimum 486 processor
//
// Last change: ReplaceChar moved to StringUtils
//
unit MemUtils;

interface

uses Monitor, SysUtils;

type
  TIntegerArray = array[0..32767] of Integer;
  PIntegerArray = ^TIntegerArray;
  TCardinalArray = array[0..32767] of Cardinal;
  PCardinalArray = ^TCardinalArray;

  Int64Split = packed record
                 Lo : Cardinal;
                 Hi : Integer;
               end;

  TAssignObject = class(TMonitorObject)
    public
      // All descendants of Assign and AssignTo should call inherited if
      // supplied with an unsupported object type
      procedure Assign(Other: TObject); virtual;
      procedure AssignTo(Other: TObject); virtual;
    end;

// Find byte in buffer, return position or -1 if not found
function FastLocateByte(const Where; Start, BSize: Integer; What: Word): Integer; assembler; pascal;
// Find 2 bytes in buffer, return position or -1 if not found
function FastLocate2Bytes(const Where; Start, BSize: Integer; What: Word): Integer; assembler; pascal;
// Find 4 bytes in buffer at DWord boundaries. Return position or -1 if not found  >>>> UNTESTED <<<<
function FastLocateDWord(var Where; BSize: Integer; What: LongInt): Integer; assembler; register;

// Fill dest with sizeof zeros
procedure ZeroMem(var Dest; SizeOf: integer ); assembler; register;
procedure FillDWord(var Dest; Count: Integer; Value: Cardinal); assembler; register;

// Reverse byte order
function GetSwap2(A: Word): Word; assembler; register;
function GetSwap4(A: Cardinal): Cardinal; assembler; register;
procedure Swap4(var A: Cardinal); assembler; register;

procedure SwapDWords(var A,B); assembler; register;

function AllocMem(Size: Cardinal): Pointer;
// Like FreeMem, but checks for nil and set to nil after freeing
procedure FreeAndNilData(var P);

implementation

procedure FreeAndNilData(var P);
var
  Ptr : Pointer;
begin
  if Assigned(Pointer(P)) then
  begin
    Ptr:=Pointer(P);
    Pointer(P):=nil;
    FreeMem(Ptr);
  end;
end;

function AllocMem(Size: Cardinal): Pointer;
begin
  GetMem(Result,Size);
  ZeroMem(Result^,Size);
end;

// Find byte in buffer, return position or -1 if not found
function FastLocateByte(const Where; Start, BSize: Integer; What: Word): Integer; assembler; pascal;
asm
  push edi
  mov ecx, [bsize]
  sub ecx, [start]
  jz @notfound       // No data to search
  mov edi, [where]
  add edi, [start]
  mov ax, [what]
  @search:
  repne scasb
  je @found
  @notfound:
  mov eax, -1
  jmp @end
  @found:
  mov eax, edi
  dec eax
  sub eax, [where]
  @end:
  pop edi
end;

function FastLocate2Bytes(const where; start, bsize: integer; what: word):integer; assembler; pascal; far;
asm
 push edi
 mov ecx, [bsize]
 sub ecx, [start]
 jz @notfound       // No data to search
 mov edi, [where]
 add edi, [start]
 mov ax, [what]
 @search:
 repne scasb
 je @found
 @notfound:
 mov eax, -1
 jmp @end
 @found:
 cmp [edi], ah
 jne @search
 mov eax, edi
 dec eax
 sub eax, [where]
 @end:
 pop edi
end;

function FastLocateDWord(var Where; BSize: Integer; What: LongInt): Integer; assembler; register;
asm
 {eax=where; edx=bsize; ecx=what}
 push edi
 mov  edi, eax
 mov  eax, ecx
 mov  ecx, edx
 mov  edx, edi
 {edi=where; edx=where; eax=what; ecx=bsize}
 @search:
 repne scasd
 je @found
 @notfound:
 mov eax, -1
 jmp @end
 @found:
 mov eax, edi
 sub eax, edx
 shr eax, 2
 dec eax

 @end:
 pop  edi
end;

procedure ZeroMem( var dest; sizeof: integer ); assembler; register;
asm
  { eax=dest; edx=sizeof }
  push edi  { protect edi }

  mov  edi, eax  { edi=@dest }

  xor  eax, eax  { eax=0 }

  { calc. no. of dwords to store and store them }
  mov  ecx, edx
  shr  ecx, 2
  rep  stosd

  { calc. no. of missing words and store them (actually this is bit 1) }
  mov  ecx, edx
  bt   ecx, 1
  jnc  @stobyte
  stosw

  { calc. no. of missing bytes and store them (actually this is bit 0) }
  @stobyte:
  bt  ecx, 0
  jnc @ende
  stosb

 { memory block should be zeroed }
  @ende:
  pop edi
end;

// Like FillChar, just with DWords
procedure FillDWord(var Dest; Count: Integer; Value: Cardinal); assembler; register;
asm
  // eax=Dest; edx=Count; ecx=Value
  push edi  // protect edi
  mov  edi, eax  // edi=@dest
  mov  eax, ecx  // eax=Value
  mov  ecx, edx
  rep  stosd
  pop edi
end;

// Like standard fillchar
procedure FastFillChar( var dest; sizeof: integer; fill: byte ); assembler; register;
asm
  { eax=dest; edx=sizeof; cl=fill }
  push edi  { protect edi }

  mov  edi, eax  { edi=@dest }

  mov  ch, cl
  mov  ax, cx
  bswap eax
  mov  ax, cx

  { calc. no. of dwords to store and store them }
  mov  ecx, edx
  shr  ecx, 2
  rep  stosd

  { calc. no. of missing words and store them (actually this is bit 1) }
  mov  ecx, edx
  bt   ecx, 1
  jnc  @stobyte
  stosw

  { calc. no. of missing bytes and store them (actually this is bit 0) }
  @stobyte:
  bt  ecx, 0
  jnc @ende
  stosb

 { memory block should be zeroed }
 @ende:
  pop edi
end;

function GetSwap2(A: Word): Word; assembler; register;
asm
  mov cl, al
  mov al, ah
  mov ah, cl
end;

// Reverse byte order
procedure Swap4(var A: Cardinal); assembler; register;
asm
  mov   ecx, [eax]
  bswap ecx
  mov   [eax], ecx
end;

function GetSwap4(A: Cardinal): Cardinal; assembler; register;
asm
  bswap eax
end;

procedure SwapDWords(var A,B); assembler; register;
asm
  push  ebx
  mov   ebx, [eax]
  mov   ecx, [edx]
  mov   [eax], ecx
  mov   [edx], ebx
  pop   ebx
end;

//==============================================================================================================================
// TAssignObject
//==============================================================================================================================
procedure TAssignObject.Assign(Other: TObject);
begin
  if Other is TAssignObject then TAssignObject(Other).AssignTo(Self)
  else raise Exception.Create('Cannot assign '+Other.ClassName+' to '+ClassName);
end;

procedure TAssignObject.AssignTo(Other: TObject);
begin
  if Other is TAssignObject then TAssignObject(Other).Assign(Self)
  else raise Exception.Create('Cannot assign '+ClassName+' to '+Other.ClassName);
end;

end.

