////////////////////////////////////////////////////////////////////////////////
//
// Streams.pas - Streams interface
// -------------------------------
// Version:   2003-02-07
// Maintain:  Michael Vinther   mv@logicnet·dk
//
// Original by Rune Møller and Michael Vinther
//
// Contains:
//   GetWin32ErrorText - returns a string with error text in native language
//   TBaseStream - basic input-output stream
//     TFilterStream - Filterstream, allows an object to perform actions on data
//     TSeekableStream - A stream, that supports a pointer and a seek-function
//       TFileStream - An interface to the Win32 file API
//     TDummyStream - a NUL-device
//
// Last changes:
//   CopyStream can now copy to nil
//
// Suggested improvements:
//
unit Streams;

interface

uses
  Monitor, Windows, SysUtils;

resourcestring
  rs_UnspecifiedError  = 'Error occured. Error description not available!';
  rs_ReadError         = 'Error reading from stream - %s';         // error text
  rs_WriteError        = 'Error writing to stream - %s';           // error text
  rs_ReadLessError     = 'Read less than expected';
  rs_IOError           = 'IO-error: %s';                           // error code
  rs_ReadDenied        = 'Cannot read from stream';
  rs_WriteDenied       = 'Cannot write to stream';
  // TFileStream error messages
  rs_CreateFileError   = 'Error opening "%s" - %s';                // filename, error text
  rs_CloseFileError    = 'Error closing "%s" - %s';                // filename, error text
  rs_DeleteFileError   = 'Error deleting "%s" - %s';               // filename, error text
  rs_TruncateFileError = 'Error truncating file "%s" - %s';        // filename, error text
  rs_SeekFileError     = 'Error moving file pointer - %s';         // error text
  rs_GetFileAttrError  = 'Could not read attríbutes - %s';         // error text
  rs_SetFileAttrError  = 'Could not change attributes - %s';       // error text
  rs_NoFileAccessSpec  = 'Either read, write or full access must be specified in call to CreateFile';

type
 { Array to access single bytes in memory. }

 { Basic stream implementation. Contains an input-output basic stream. Class is abstract. }
 TBaseStream =
  class(TMonitorObject)
    protected
      fCanWrite: boolean;
      fCanRead: boolean;
      fNoDataExcept: boolean;
      procedure SetNoDataExcept(Status: Boolean); virtual;
    public
      // Construct instance of stream
      constructor Create;
      // Write a block of data to the stream
      function Write(var Buf; Count: integer): integer; virtual; abstract;
      // Read a block of data from the stream
      function Read(var Buf; Count: integer): integer; virtual; abstract;
      // Has the stream reached the end of data
      function EOS: boolean; virtual;
      // How many bytes are available for reading
      function Available: integer; virtual; abstract;
      // Flush stream
      procedure Flush; virtual;
      // Copies the entire stream from Source into this stream
      procedure CopyFrom(Source: TBaseStream); virtual;
      // Can you read from this stream
      property CanRead: boolean read fCanRead;
      // Can you write to this stream
      property CanWrite: boolean read fCanWrite;
      // Should an exception be raised if not enough data is read, sometimes good to turn off
      property NoDataExcept: boolean read fNoDataExcept write SetNoDataExcept;
  end;

  { A FilterStream works as a layer on top of another stream. }
  TFilterStream =
    class (TBaseStream)
      protected
        Next: TBaseStream;
        procedure SetNoDataExcept(Status: Boolean); override;
      public
        constructor Create(InOutStream: TBaseStream );
        // Write a block of data to the stream
        function Write(var Buf; Count: integer): integer; override;
        // Read a block of data from the stream
        function Read(var Buf; Count: integer): integer; override;
        function Available: Integer; override;
        procedure FreeAll;
    end;

  { Slight extention of a BaseStream. This stream supports searching and has a size. }
  TSeekableStream =
    class (TBaseStream)
      protected
        function GetPos: integer; virtual; abstract;
        function GetSize: integer; virtual; abstract;
      public
         // Seek to a location in the stream
        procedure Seek(loc: integer); virtual; abstract;
        // Position in the stream
        property Position: integer read GetPos write Seek;
        // Length of datastream
        property Size: integer read GetSize;
        // Truncate stream at current position
        procedure Truncate; virtual; abstract;
    end;

  // Attributes
  TFileAttributes = set of (sfaArchive, sfaHidden, sfaSystem, sfaReadOnly, sfaTemporary, sfaCompressed, sfaDirectory);
  TfsModes = set of (fsRead,        // open with read-access
                     fsWrite,       // open with write-access
                     fsCreate,      // unconditionally rewrite file
                     fsShareRead,   // share file for read access
                     fsShareWrite); // share file for write access
const
  fsReset = [fsRead, fsWrite];      // standard reset
  fsRewrite = fsReset+[fsCreate];   // standard rewrite
  fsShared = [fsShareRead, fsShareWrite]; // share file fully
type
  { Implements a file. }
  TFileStream =
    class (TSeekableStream)
      protected
        Handle: THandle;
        name: string;
        function GetPos: integer; override;
        function GetSize: integer; override;
        function GetFileAttr: TFileAttributes;
        procedure SetFileAttr(fa: TFileAttributes);
        function GetLastWriteTime: TFileTime;
        procedure SetLastWriteTime(const Time: TFileTime);
      public
        constructor Create(filename: string; mode: TfsModes); overload;
        constructor Create(FileHandle: THandle); overload;
        destructor Destroy; override;
        procedure Delete; virtual;
        function Write(var Buf; Count: integer): integer; override;
        function Read(var Buf; Count: integer): integer; override;
        function Available: integer; override;
        procedure Flush; override;
        procedure Seek(loc: integer); override;
        procedure Truncate; override;
        // File attributes
        property Attributes: TFileAttributes read GetFileAttr write SetFileAttr;
        property LastWriteTime: TFileTime read GetLastWriteTime write SetLastWriteTime;
        // Name of file
        property FileName: string read name;
        property FileHandle: THandle read Handle;
    end;

  {Dummy stream. Reads nothing - writes nothing}
  TDummyStream =
    class (TBaseStream)
      constructor Create;
      function Write(var Buf; Count: integer): integer; override;
      function Read(var Buf; Count: integer): integer; override;
      function Available: integer; override;
    end;

// Copies Size bytes from Source to Dest. Dest can be nil
procedure CopyStream(Source, Dest: TBaseStream; const Size: Integer);

function GetLastErrorText:string;

implementation

//------------------------------------------------------------------------------
// Copies Size bytes from Source to Dest
procedure CopyStream(Source, Dest: TBaseStream; const Size: Integer);
const BufSize = 4096;
var
 BlokSize, Count : Integer;
 Buf : array[1..BufSize] of Byte;
begin
 Count:=0;
 if Assigned(Dest) then
   while (Count<Size) and not Source.EOS do
   begin
     BlokSize:=Size-Count;
     if BlokSize>BufSize then BlokSize:=BufSize;
     BlokSize:=Source.Read(Buf,BlokSize);
     Dest.Write(Buf,BlokSize);
     Inc(Count,BlokSize);
   end
 else // Just read
   while (Count<Size) and not Source.EOS do
   begin
     BlokSize:=Size-Count;
     if BlokSize>BufSize then BlokSize:=BufSize;
     Inc(Count,Source.Read(Buf,BlokSize));
   end
end;

function GetLastErrorText: string;
begin
  Result:=SysErrorMessage(GetLastError);
end;

//==================================================================================================
// TBaseStream
//==================================================================================================

//------------------------------------------------------------------------------
// Construct a new TBaseStream object
constructor TBaseStream.Create;
begin
  inherited Create;
  fNoDataExcept:=true;
end;


//------------------------------------------------------------------------------
// Has the stream reached its end
function TBaseStream.EOS: boolean;
begin
  EOS:=(Available=0);
end;

//------------------------------------------------------------------------------
procedure TBaseStream.Flush;
begin
 { Spluuuiisssssss }
end;

//------------------------------------------------------------------------------
procedure TBaseStream.SetNoDataExcept(Status: Boolean);
begin
 fNoDataExcept:=Status;
end;

//------------------------------------------------------------------------------
// Copies Src to Dest until Src.EOS and returns number of bytes copied
procedure TBaseStream.CopyFrom(Source: TBaseStream);
const BufSize = 4096;
var
 Siz : Integer;
 Buf : array[1..BufSize] of Byte;
 SrcExcept : Boolean;
begin
 SrcExcept:=Source.NoDataExcept;
 if SrcExcept then Source.NoDataExcept:=False;
 while not Source.EOS do
 begin
  Siz:=Source.Read(Buf,BufSize);
  Write(Buf,Siz);
 end;
 if SrcExcept then Source.NoDataExcept:=True;
end;


//==================================================================================================
// TFilterStream
//==================================================================================================

//------------------------------------------------------------------------------
// Construct a new TFilterStream object - initializes
constructor TFilterStream.Create( InOutStream: TBaseStream );
begin
 inherited Create;
 Next:=InOutStream;
end;

//------------------------------------------------------------------------------
// Write a block of data to the stream
function TFilterStream.Write(var Buf; Count: integer): integer;
begin
  Result:=Next.Write(Buf,Count);
end;

//------------------------------------------------------------------------------
// Read a block of data from the stream
function TFilterStream.Read(var Buf; Count: integer): integer;
begin
  Result:=Next.Read(Buf,Count);
end;

//------------------------------------------------------------------------------
// Change NoDataExcept for this filter and all filters below it
procedure TFilterStream.SetNoDataExcept(Status: Boolean);
begin
 fNoDataExcept:=Status;
 Next.NoDataExcept:=Status;
end;

//------------------------------------------------------------------------------
// Free this filter and all filters below it
procedure TFilterStream.FreeAll;
var N: TBaseStream;
begin
 if Self=nil then Exit;
 N:=Next;
 Destroy;
 if N is TFilterStream then with N as TFilterStream do FreeAll
 else N.Free;
end;


//------------------------------------------------------------------------------
// Return Available from the Next stream in the chain
function TFilterStream.Available: Integer;
begin
  Available:=Next.Available;
end;


//==================================================================================================
// TFileStream
//==================================================================================================

//------------------------------------------------------------------------------
// Construct a new TFileStream object
// filename - name of the file to create
// mode - a set of modes to create this file with: faCreate means force rewrite
//        of file
constructor TFileStream.Create(filename: string; mode: TfsModes);
var
  access: DWord;
  shared: DWord;
  create: integer;
begin
  inherited Create;
  Handle:=INVALID_HANDLE_VALUE;
  name:=filename;

  access:=0;
  if fsRead in mode then access:=access+GENERIC_READ;
  if fsWrite in mode then access:=access+GENERIC_WRITE;
  if access=0 then raise EInOutError.Create(rs_NoFileAccessSpec);
  fCanRead:=fsRead in mode;
  fCanWrite:=fsWrite in mode;

  shared:=0;
  if fsShareRead in mode then shared:=shared+FILE_SHARE_READ;
  if fsShareWrite in mode then shared:=shared+FILE_SHARE_WRITE;

  if fsCreate in mode then create:=CREATE_ALWAYS else create:=OPEN_EXISTING;

  Handle:= CreateFile(pChar(name), access, shared, nil, create, FILE_ATTRIBUTE_NORMAL, 0);
  if Handle=INVALID_HANDLE_VALUE then raise EInOutError.CreateFmt( rs_CreateFileError, [ name, GetLastErrorText ] );
end;

constructor TFileStream.Create(FileHandle: THandle);
begin
  if Handle=INVALID_HANDLE_VALUE then RaiseLastWin32Error;
  inherited Create;
  Handle:=FileHandle;
  fCanRead:=True;
  fCanWrite:=True;
end;

//------------------------------------------------------------------------------
// Destroy the FileStream
destructor TFileStream.Destroy;
begin
  CloseHandle(Handle);
  inherited Destroy;
end;


//------------------------------------------------------------------------------
// Delete the associated file. This will _destroy_ the file!
procedure TFileStream.Delete;
begin
  if not CloseHandle( Handle ) then raise EInOutError.CreateFmt( rs_CloseFileError, [ name, GetLastErrorText ] );
  if not DeleteFile( name ) then raise EInOutError.CreateFmt( rs_DeleteFileError, [ name, GetLastErrorText ] );;
  Destroy;
end;



//------------------------------------------------------------------------------
// Write datablock to file
function TFileStream.Write(var Buf; Count: integer): integer;
var
  written: dword;
begin
  if not WriteFile( Handle, Buf, Count, written, nil ) then
    raise EInOutError.CreateFmt( rs_WriteError, [ GetLastErrorText ] );
  if NoDataExcept then
    if dword(Count)<>written then raise EInOutError.Create( rs_ReadLessError );
  Write:=written;
end;



//------------------------------------------------------------------------------
// Read a datablock from the file
function TFileStream.Read(var Buf; Count: integer): integer;
var
  readb: dword;
begin
  if not ReadFile( Handle, Buf, Count, readb, nil ) then
    raise EInOutError.CreateFmt( rs_ReadError, [ GetLastErrorText ] );
  if NoDataExcept then
    if dword(Count)<>readb then raise EInOutError.Create( rs_ReadLessError );
  Read:=readb;
end;



//------------------------------------------------------------------------------
// Return number of bytes left in the file before EOF
function TFileStream.Available: integer;
begin
  Available:=GetSize-GetPos;
end;



//------------------------------------------------------------------------------
// Make Windows flush its buffers
procedure TFileStream.Flush;
begin
  FlushFileBuffers( Handle );
end;



//------------------------------------------------------------------------------
// Return the position in the file. (Internal protected method)
function TFileStream.GetPos:integer;
begin
  Result:= SetFilePointer(Handle,0,nil,FILE_CURRENT);
  if Result=-1 then raise EInOutError.CreateFmt( rs_IOError, [ GetLastErrorText ] );
end;



//------------------------------------------------------------------------------
// Return the size of the file. (Internal protected method)
function TFileStream.GetSize:integer;
begin
  Result:= GetFileSize( Handle, nil );
  if Result=-1 then raise EInOutError.CreateFmt( rs_IOError, [ GetLastErrorText ] );
end;



//------------------------------------------------------------------------------
// Return file attributes as a set. (Internal protected method)
function TFileStream.GetFileAttr: TFileAttributes;
var
  fa: integer;
begin
  result:=[];
  fa:= GetFileAttributes( pChar(name) );
  if fa=-1 then
    raise EInOutError.CreateFmt( rs_GetFileAttrError, [GetLastErrorText] );
  if fa and FILE_ATTRIBUTE_ARCHIVE >0 then result:=result+[sfaArchive];
  if fa and FILE_ATTRIBUTE_HIDDEN >0 then result:=result+[sfaHidden];
  if fa and FILE_ATTRIBUTE_SYSTEM >0 then result:=result+[sfaSystem];
  if fa and FILE_ATTRIBUTE_COMPRESSED >0 then result:=result+[sfaCompressed];
  if fa and FILE_ATTRIBUTE_DIRECTORY >0 then result:=result+[sfaDirectory];
  if fa and FILE_ATTRIBUTE_READONLY >0 then result:=result+[sfaReadOnly];
end;



//------------------------------------------------------------------------------
// Set the attributes of the file. (Internal protected method)
procedure TFileStream.SetFileAttr( fa: TFileAttributes);
var
  att: integer;
begin
  att:=0;
  if sfaArchive   in fa then att:=att or FILE_ATTRIBUTE_ARCHIVE;
  if sfaHidden    in fa then att:=att or FILE_ATTRIBUTE_HIDDEN;
  if sfaReadOnly  in fa then att:=att or FILE_ATTRIBUTE_READONLY;
  if sfaSystem    in fa then att:=att or FILE_ATTRIBUTE_SYSTEM;
  if sfaTemporary in fa then att:=att or FILE_ATTRIBUTE_TEMPORARY;
  if not SetFileAttributes( pChar(name), att ) then
    raise EInOutError.CreateFmt( rs_SetFileAttrError, [GetLastErrorText] );
end;

function TFileStream.GetLastWriteTime: TFileTime;
begin
  if not GetFileTime(Handle,nil,nil,@Result) then RaiseLastWin32Error;
end;

procedure TFileStream.SetLastWriteTime(const Time: TFileTime);
begin
  if not SetFileTime(Handle,nil,nil,@Time) then RaiseLastWin32Error;
end;


//------------------------------------------------------------------------------
// Seek to a location in the file.
procedure TFileStream.Seek(loc: integer);
begin
  if SetFilePointer(Handle,loc,nil,FILE_BEGIN)=DWord(-1) then
    raise EInOutError.CreateFmt( rs_SeekFileError, [GetLastErrorText]);
end;



procedure TFileStream.Truncate;
begin
  if not SetEndOfFile(Handle) then
    raise EInOutError.CreateFmt( rs_TruncateFileError, [GetLastErrorText]);
end;


//==================================================================================================
// TDummyStream
//==================================================================================================

constructor TDummyStream.Create;
begin
 inherited Create;
 fCanRead:=True; fCanWrite:=True;
end;

function TDummyStream.Read(var Buf; Count: integer): integer;
begin
 Result:=Count;
end;

function TDummyStream.Write(var Buf; Count: integer): integer;
begin
 Result:=Count;
end;

function TDummyStream.Available: Integer;
begin
 Result:=High(Integer);
end;

end.

