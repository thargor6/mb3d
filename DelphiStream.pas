///////////////////////////////////////////////////////////////////////////////////
//
// DelphiStreams.pas - Delphi stream interface
// -------------------------------------------
// Version:   1999-09-27
// Maintain:  Michael Vinther   |   mv@logicnet·dk
//
//
// Contains:
//   TDelphiStream             Delphi stream to read from/write to MeeSoft stream
//     TSeekableDelphiStream
//
//   TDelphiFilterStream       MeeSoft seekable stream to read from/write to Delphi stream

unit DelphiStream;

interface

uses Classes, Streams, Monitor;

resourcestring
  rsUnknownSeekOrigin   = 'Unknown seek origin';
  rsSeekingNotSupported = 'Seeking not supported';

type
 TDelphiStream = class(TStream)
   protected
     fNext : TBaseStream;
   public
     constructor Create(InOutStream: TBaseStream);

     function Read(var Buffer; Count: Longint): Longint; override;
     function Write(const Buffer; Count: Longint): Longint; override;

     function Seek(Offset: Longint; Origin: Word): Longint; override;

     property Next: TBaseStream read fNext;

     // Free this class, Next and all streams below
     procedure FreeAll;
   end;

 TSeekableDelphiStream = class(TDelphiStream)
   protected
     procedure SetSize(NewSize: Longint); override;
   public
     constructor Create(InOutStream: TSeekableStream);
     function Seek(Offset: Longint; Origin: Word): Longint; override;
   end;

 TDelphiFilterStream = class(TSeekableStream)
   protected
     Next : TStream;

     function GetPos: Integer; override;
     function GetSize: Integer; override;
   public
     // Construct instance of stream
     constructor Create(InOutStream: TStream);
     // Write a block of data to the stream
     function Write(var Buf; Count: integer): integer; override;
     // Read a block of data from the stream
     function Read(var Buf; Count: integer): integer; override;
     // How many bytes are available for reading
     function Available: integer; override;
      // Seek to a location in the stream
     procedure Seek(loc: integer); override;
     // Truncate stream at current position
     procedure Truncate; override;

     // Free this class and Next. Note that FreeAll in a TFilterstream does not
     // call this method
     procedure FreeAll;
   end;

implementation

//==============================================================================================================================
// TDelphiStream
//==============================================================================================================================

constructor TDelphiStream.Create(InOutStream: TBaseStream);
begin
  inherited Create;
  fNext:=InOutStream;
  Next.NoDataExcept:=False;
end;

function TDelphiStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  raise EStreamError.Create(rsSeekingNotSupported);
end;

function TDelphiStream.Read(var Buffer; Count: Longint): Longint;
begin
  Result:=Next.Read(Buffer,Count);
end;

function TDelphiStream.Write(const Buffer; Count: Longint): Longint;
begin
  Result:=Next.Write(Pointer(@Buffer)^,Count);
end;

procedure TDelphiStream.FreeAll;
var N: TBaseStream;
begin
 if Self=nil then Exit;
 N:=Next;
 Destroy;
 if N is TFilterStream then with N as TFilterStream do FreeAll
 else N.Free;
end;

//===================================================================================
// TSeekableDelphiStream
//===================================================================================

constructor TSeekableDelphiStream.Create(InOutStream: TSeekableStream);
begin
  inherited Create(InOutStream);
end;

function TSeekableDelphiStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning : Result:=Offset;
    soFromEnd       : Result:=TSeekableStream(Next).Size+Offset;
    soFromCurrent   : Result:=TSeekableStream(Next).Position+Offset;
    else raise EStreamError.Create(rsUnknownSeekOrigin);
  end;
  TSeekableStream(Next).Position:=Result;
end;

procedure TSeekableDelphiStream.SetSize(NewSize: Longint);
var
  OrgPos : Integer;
begin
  if NewSize<TSeekableStream(Next).Size then
  begin
    OrgPos:=TSeekableStream(Next).Position;
    TSeekableStream(Next).Position:=NewSize;
    TSeekableStream(Next).Truncate;
    if OrgPos<NewSize then TSeekableStream(Next).Position:=OrgPos;
  end
  else
  begin
    OrgPos:=TSeekableStream(Next).Position;
    TSeekableStream(Next).Position:=NewSize;
    TSeekableStream(Next).Position:=OrgPos;
  end;
end;

//===================================================================================
// TDelphiFilterStream
//===================================================================================

constructor TDelphiFilterStream.Create(InOutStream: TStream);
begin
  inherited Create;
  Next:=InOutStream;
  fCanRead:=True;
  fCanWrite:=True;
end;

function TDelphiFilterStream.Read(var Buf; Count: Integer): Integer;
begin
  Result:=Next.Read(Buf,Count);
end;

function TDelphiFilterStream.Write(var Buf; Count: Integer): Integer;
begin
  Result:=Next.Write(Buf,Count);
end;

function TDelphiFilterStream.Available: Integer;
begin
  Result:=Next.Size-Next.Position;
end;

procedure TDelphiFilterStream.Seek(loc: integer);
begin
  Next.Seek(Loc,soFromBeginning);
end;

procedure TDelphiFilterStream.Truncate;
begin
  Next.Size:=Position;
end;

function TDelphiFilterStream.GetPos: Integer;
begin
  Result:=Next.Position;
end;

function TDelphiFilterStream.GetSize: Integer;
begin
  Result:=Next.Size;
end;

procedure TDelphiFilterStream.FreeAll;
begin
  if Self<>nil then
  begin
    Next.Free;
    Destroy;
  end;
end;

end.

