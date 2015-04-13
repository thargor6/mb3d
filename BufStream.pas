////////////////////////////////////////////////////////////////////////////////
//
// BufStream.pas - Stream buffer
// -----------------------------
// Changed:   2001-01-30
// Maintain:  Michael Vinther    |    mv@logicnet·dk
//
// Contains:
//   (TBaseStream)
//     (TFilterStream)
//       TBufferedStream
//
// Changes to DefaultBufferSize will only affect new buffers created after
// the change.
// NextStream.NoDataExcept is set to False on create and restored on destroy.
//

unit BufStream;

interface

uses
 Streams, SysUtils, Monitor;

resourcestring
 rsInvalidBufferSize = 'Invalid buffer size';

var
 DefaultBufferSize : Integer = 1024*64;

const
  DefaultBuffer = -1;
 
type
 TBufferedStream =
  class (TFilterStream)
    private
      NextNoDataExcept : Boolean;
    protected
      InBuffer : PByteArray;
      InBufPos, InBufSize, InBufMax : Integer;
      OutBuffer : PByteArray;
      OutBufPos, OutBufSize : Integer;
    public
      // A buffer size of -1 means use DefaultBufferSize
      constructor Create(InputBufSize,OutputBufSize: Integer; NextStream: TBaseStream);

      destructor Destroy; override;
      function Write(var Buf; Count: Integer): Integer; override;
      function Read(var Buf; Count: Integer): Integer; override;
      procedure Flush; override;
      function Available: integer; override;

      property NoDataExcept: Boolean read fNoDataExcept write fNoDataExcept;
  end;

 EStreamCreate =
   class (Exception)
   end;

 const
  fmRead  = 0;
  fmWrite = 1;
 function OpenBufferedFile(Name: string; Mode: Integer): TBufferedStream;

implementation

 constructor TBufferedStream.Create(InputBufSize,OutputBufSize: Integer; NextStream: TBaseStream);
 begin
  inherited Create(NextStream);
  fCanRead:=Next.CanRead;
  fCanWrite:=Next.CanWrite;

  fNoDataExcept:=Next.NoDataExcept;
  NextNoDataExcept:=fCanRead and (InputBufSize<>0) and fNoDataExcept;
  if NextNoDataExcept then
  begin
   if Next is TFilterStream then TFilterStream(Next).NoDataExcept:=False  // Clear NoDataExcept in filter chain
   else Next.NoDataExcept:=False;
  end;

  if InputBufSize=-1 then InputBufSize:=DefaultBufferSize;
  if fCanRead and (InputBufSize<>0) then
  begin
   if InputBufSize<2 then raise EStreamCreate.Create(rsInvalidBufferSize);
   InBufMax:=InputBufSize;
   GetMem(InBuffer,InBufMax);
  end
  else InBufMax:=0;
  InBufSize:=0; InBufPos:=0;

  if OutputBufSize=-1 then OutputBufSize:=DefaultBufferSize;
  if fCanWrite and (OutputBufSize<>0) then
  begin
   if OutputBufSize<2 then raise EStreamCreate.Create(rsInvalidBufferSize);
   OutBufSize:=OutputBufSize;
   GetMem(OutBuffer,OutBufSize);
  end
  else OutBufSize:=0;
  OutBufPos:=0;
 end;

 destructor TBufferedStream.Destroy;
 begin
  if OutBufSize<>0 then
  begin
   Flush;
   FreeMem(OutBuffer);
  end;
  if InBufMax<>0 then FreeMem(InBuffer);
  if NextNoDataExcept then
  begin
   if Next is TFilterStream then TFilterStream(Next).NoDataExcept:=True  // Set NoDataExcept in filter chain
   else Next.NoDataExcept:=True;
  end;
  inherited;
 end;

 function TBufferedStream.Read(var Buf; Count: Integer): Integer;
 var
  S : Integer;
 begin
   if InBufMax=0 then Result:=Next.Read(Buf,Count) // No buffer
   else if Count<=InBufSize-InBufPos then  // Requested data present in buffer
   begin
     Move(InBuffer^[InBufPos],Buf,Count);
     Inc(InBufPos,Count);
     Result:=Count;
   end
   else  // Not enough data in buffer
   begin
     Result:=InBufSize-InBufPos;
     Move(InBuffer^[InBufPos],Buf,Result); Dec(Count,Result);

     if Count>=InBufMax then  // Buffer too small, read data directly from file
     begin
       S:=Next.Read(TByteArray(Buf)[Result],Count);
       Inc(Result,S);
       InBufPos:=0; InBufSize:=0;
       if (Result<Count) and NoDataExcept then raise EInOutError.Create(rs_ReadLessError);
     end
     else  // Refill buffer
     begin
       S:=Next.Read(InBuffer^,InBufMax);
       if S<Count then // Too little read
       begin
         Move(InBuffer^,TByteArray(Buf)[Result],S);
         Inc(Result,S);
         InBufPos:=0; InBufSize:=0;
         if NoDataExcept then raise EInOutError.Create(rs_ReadLessError);
       end
       else
       begin
         Move(InBuffer^,TByteArray(Buf)[Result],Count);
         Inc(Result,Count);
         InBufSize:=S;
         InBufPos:=Count;
       end;
     end;
   end;
 end;

 function TBufferedStream.Write(var Buf; Count: Integer): Integer;
 var S : Integer;
 begin
  if OutBufSize=0 then Result:=Next.Write(Buf,Count) // No buffer
  else if Count<=OutBufSize-OutBufPos then  // Room for data in buffer
  begin
   Move(Buf,OutBuffer^[OutBufPos],Count);
   Inc(OutBufPos,Count);
   Result:=Count;
  end
  else  // Too much data, write buffer
  begin
   Result:=OutBufSize-OutBufPos;
   Move(Buf,OutBuffer^[OutBufPos],Result); Dec(Count,Result);
   S:=Next.Write(OutBuffer^,OutBufSize);
   if S<OutBufSize then Result:=-OutBufSize-Count  // Write error
   else if Count>=OutBufSize then  // Buffer too small, write data directly to file
   begin
    S:=Next.Write(TByteArray(Buf)[Result],Count);
    Inc(Result,S);
    OutBufPos:=0;
   end
   else
   begin
    Move(TByteArray(Buf)[Result],OutBuffer^,Count);
    OutBufPos:=Count;
    Inc(Result,Count);
   end;
  end;
 end;
 
 procedure TBufferedStream.Flush;
 begin
  //inherited Flush;
  if OutBufPos>0 then
  begin
   Next.Write(OutBuffer^,OutBufPos);
   OutBufPos:=0;
  end; 
 end;
 
 function TBufferedStream.Available;
 begin
  Available:=Next.Available+InBufSize-InBufPos;
 end;

 function OpenBufferedFile(Name: string; Mode: Integer): TBufferedStream;
 begin
   if Mode=fmRead then Result:=TBufferedStream.Create(DefaultBuffer,0,TFileStream.Create(Name,[fsRead,fsShareRead]))
   else Result:=TBufferedStream.Create(0,DefaultBuffer,TFileStream.Create(Name,fsRewrite+[fsShareRead]));
 end;

end.

