{ ---------------------------------------------------------------------------- }
{ BulbTracer for MB3D                                                          }
{ Copyright (C) 2016-2017 Andreas Maschke                                      }
{ ---------------------------------------------------------------------------- }
unit BulbTracerUITools;

interface

uses
  Vcl.ComCtrls, BulbTracerConfig;

type
  TSaveType = (stMeshAsObj, stMeshAsLWO2, stUnprocessedMeshData, stNoSave);
  TCancelType = (ctCancelAndShowResult, ctCancelImmediately);

function Clamp255(i: Integer): Integer;
procedure Lighten(pc: PCardinal; b: Byte);
procedure Darken(pc: PCardinal);
procedure Solid2(pc: PCardinal; b1, b2: Integer);
procedure Solid4(pc: PCardinal; b1, b2: Integer);
procedure Solid8(pc: PCardinal; b1, b2: Integer);
procedure Solid16(pc: PCardinal; b1, b2: Integer);

function GetDefaultMeshFilename(const Filename: String; const SaveType: TSaveType): String;
function GetMeshFileExt(const SaveType: TSaveType): String;
function GetMeshFileFilter(const SaveType: TSaveType): String;
function MakeMeshRawFilename(const Filename: String): String;
function UpDownBtnValue(const  Button: TUDBtnType; const Scl: Double): Double;
function StrToFloatSafe(const Str: String; const DfltVal: Double): Double;

function GuessSequence( const FilenameWithPath: String; var SequenceBaseFilename, SequenceFileExt: String; var SequencePatternLength, SequenceFrom, SequenceTo, SequenceCurrFrame: Integer ): Boolean;
function GetSequenceFilename( const SequenceBaseFilename, SequenceFileExt: String; const SequencePatternLength, SequenceCurrFrame: Integer ): String;

implementation

uses
  SysUtils, MeshIOUtil;

procedure Darken(pc: PCardinal);
type ta = array[0..3] of Byte;
    pta = ^ta;
begin
    if pta(pc)[0] > 3 then Dec(pta(pc)[0], 4);
    if pta(pc)[1] > 3 then Dec(pta(pc)[1], 4);
    if pta(pc)[2] > 3 then Dec(pta(pc)[2], 4);
    Inc(pc);
    if pta(pc)[0] > 3 then Dec(pta(pc)[0], 4);
    if pta(pc)[1] > 3 then Dec(pta(pc)[1], 4);
    if pta(pc)[2] > 3 then Dec(pta(pc)[2], 4);
    Inc(pc);
    if pta(pc)[0] > 3 then Dec(pta(pc)[0], 4);
    if pta(pc)[1] > 3 then Dec(pta(pc)[1], 4);
    if pta(pc)[2] > 3 then Dec(pta(pc)[2], 4);
    Inc(pc);
    if pta(pc)[0] > 3 then Dec(pta(pc)[0], 4);
    if pta(pc)[1] > 3 then Dec(pta(pc)[1], 4);
    if pta(pc)[2] > 3 then Dec(pta(pc)[2], 4);
end;


function Clamp255(i: Integer): Integer;
asm
    cmp eax, 255
    jle @up
    mov eax, 255
@up:
end;

procedure Lighten(pc: PCardinal; b: Byte);
type ta = array[0..3] of Byte;
    pta = ^ta;
begin
{    pta(pc)[0] := Min(255, pta(pc)[0] + 64);
    pta(pc)[1] := Min(127, pta(pc)[1] + 32);
    pta(pc)[2] := Min(127, pta(pc)[2] + 32);
    Inc(pc);
    pta(pc)[0] := Min(255, pta(pc)[0] + 64);
    pta(pc)[1] := Min(127, pta(pc)[1] + 32);
    pta(pc)[2] := Min(127, pta(pc)[2] + 32);
    Inc(pc);
    pta(pc)[0] := Min(255, pta(pc)[0] + 64);
    pta(pc)[1] := Min(127, pta(pc)[1] + 32);
    pta(pc)[2] := Min(127, pta(pc)[2] + 32);
    Inc(pc);
    pta(pc)[0] := Min(255, pta(pc)[0] + 64);
    pta(pc)[1] := Min(127, pta(pc)[1] + 32);
    pta(pc)[2] := Min(127, pta(pc)[2] + 32);  }
    pta(pc)[0] := Clamp255(pta(pc)[0] + b);
    pta(pc)[1] := Clamp255(pta(pc)[1] + b);
    pta(pc)[2] := Clamp255(pta(pc)[2] + b);
    Inc(pc);
    pta(pc)[0] := Clamp255(pta(pc)[0] + b);
    pta(pc)[1] := Clamp255(pta(pc)[1] + b);
    pta(pc)[2] := Clamp255(pta(pc)[2] + b);
    Inc(pc);
    pta(pc)[0] := Clamp255(pta(pc)[0] + b);
    pta(pc)[1] := Clamp255(pta(pc)[1] + b);
    pta(pc)[2] := Clamp255(pta(pc)[2] + b);
 {   Inc(pc);
    pta(pc)[0] := Min(255, pta(pc)[0] + b);
    pta(pc)[1] := Min(127, pta(pc)[1] + b);
    pta(pc)[2] := Min(127, pta(pc)[2] + b);   }
end;

procedure Solid4(pc: PCardinal; b1, b2: Integer);
begin
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    Inc(pc);
    pc^ := b2;
end;

procedure Solid8(pc: PCardinal; b1, b2: Integer);
begin
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    Inc(pc);
    pc^ := b2;
    Inc(pc);
    pc^ := b2;
end;

procedure Solid16(pc: PCardinal; b1, b2: Integer);
begin
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    Inc(pc);
    pc^ := b1;
    Inc(pc);
    pc^ := b2;
    Inc(pc);
    pc^ := b2;
    Inc(pc);
    pc^ := b2;
    Inc(pc);
    pc^ := b2;
end;

procedure Solid2(pc: PCardinal; b1, b2: Integer);
begin
    pc^ := b1;
    Inc(pc);
    pc^ := b2;
end;

function GetDefaultMeshFilename(const Filename: String; const SaveType: TSaveType): String;
var
  OldExt, NewExt: String;
begin
  OldExt := ExtractFileExt(Filename);
  NewExt := GetMeshFileExt(SaveType);
  if NewExt <> '' then
    NewExt := '.'+ NewExt;
  if OldExt='' then
    Result := Copy(Filename, 1, Length(Filename) - Length(OldExt)) + NewExt
  else
    Result := Filename + NewExt;
end;

function GetMeshFileFilter(const SaveType: TSaveType): String;
begin
  case SaveType of
    stMeshAsObj: Result := 'Wavefront OBJ (*obj)|*.obj';
    stMeshAsLWO2: Result := 'Lightwave3D Object (*lwo)|*.lwo';
    stUnprocessedMeshData: Result := 'Raw mesh data (*'+cMB3DMeshSegFileExt+')|*.'+cMB3DMeshSegFileExt;
  else
    Result := '';
  end;
end;

function GetMeshFileExt(const SaveType: TSaveType): String;
begin
  case SaveType of
    stMeshAsObj: Result := 'obj';
    stMeshAsLWO2: Result := 'lwo';
    stUnprocessedMeshData: Result := cMB3DMeshSegFileExt;
  else
    Result := '';
  end;
end;

function MakeMeshRawFilename(const Filename: String): String;
var
  Path, Name, Ext: String;
begin
  Path := ExtractFilePath(Filename);
  Name := ExtractFileName(Filename);
  Ext := ExtractFileExt(Filename);
  if Ext <> '' then
    Name := Copy(Name, 1, Length(Name) - Length(Ext));
  Result := Path + Name + '_raw'+ Ext;
end;

function UpDownBtnValue(const  Button: TUDBtnType; const Scl: Double): Double;
begin
  if btNext = Button then
    Result := Scl
  else
    Result := -Scl;
end;

function StrToFloatSafe(const Str: String; const DfltVal: Double): Double;
begin
  try
    Result := StrToFloat(Str);
  except
    Result := DfltVal;
  end;
end;

function GuessSequence( const FilenameWithPath: String; var SequenceBaseFilename, SequenceFileExt: String; var SequencePatternLength, SequenceFrom, SequenceTo, SequenceCurrFrame: Integer ): Boolean;
var
  I: Integer;
  Filename, BaseFilename, CurrFilename: String;
  Ch: Char;

  function IsNumeric(const Ch: Char): Boolean;
  begin
    Result := ( Ch >= '0' ) and ( Ch <= '9' );
  end;

begin
  Result := False;
  Filename := ExtractFileName( FilenameWithPath );
  SequenceFileExt := ExtractFileExt( Filename );
  BaseFilename := ChangeFileExt( Filename, '' );
  if ( BaseFilename <> '' ) and IsNumeric( BaseFilename[ Length( BaseFilename ) ] ) then begin
    I := Length( BaseFilename );
    while ( I > 0 ) and IsNumeric( BaseFilename[I] ) do
      Dec( I );

    SequencePatternLength := Length( BaseFilename ) - I;
    SequenceBaseFilename :=  IncludeTrailingBackslash( ExtractFilePath( FilenameWithPath  ) ) + Copy( BaseFilename, 1, I );
    SequenceCurrFrame := StrToInt( Copy( BaseFilename, I + 1, Length( BaseFilename ) - I ) );

    SequenceFrom := SequenceCurrFrame;
    SequenceTo := SequenceCurrFrame;
    while FileExists( GetSequenceFilename( SequenceBaseFilename, SequenceFileExt, SequencePatternLength, SequenceFrom - 1 ) ) do
      Dec( SequenceFrom );
    while FileExists( GetSequenceFilename( SequenceBaseFilename, SequenceFileExt, SequencePatternLength, SequenceTo + 1 ) ) do
      Inc( SequenceTo );

    Result := ( SequenceFrom <> SequenceTo );
  end;
end;

function GetSequenceFilename( const SequenceBaseFilename, SequenceFileExt: String; const SequencePatternLength, SequenceCurrFrame: Integer ): String;
var
  I: Integer;
begin
  Result := IntToStr( SequenceCurrFrame );
  while Length( Result ) < SequencePatternLength do
    Result := '0' + Result;
  Result := SequenceBaseFilename + Result + SequenceFileExt;
end;

end.


