{ ---------------------------------------------------------------------------- }
{ BulbTracer for MB3D                                                          }
{ Copyright (C) 2016-2017 Andreas Maschke                                      }
{ ---------------------------------------------------------------------------- }
unit MeshReader;

interface

uses
  SysUtils, Classes, Contnrs, VectorMath, SyncObjs, Generics.Collections,
  VertexList;

type
  TAbstractFileReader = class
  end;

  TLightwaveObjFileReader = class( TAbstractFileReader )
  public
    procedure LoadFromFile(const Filename: String; Faces: TFacesList);
  end;

  TWavefrontObjFileReader = class( TAbstractFileReader )
  public
    procedure LoadFromFile(const Filename: String; Faces: TFacesList);
  end;

implementation

uses
  Windows, Math, DateUtils, MeshIOUtil;

{ -------------------------- TLightwaveObjFileReader ------------------------- }
procedure TLightwaveObjFileReader.LoadFromFile(const Filename: String; Faces: TFacesList);
var
  FileStream: TFileStream;
  Byte5: Array [0..4] of Byte;
  ChunkId, SubId: String;
  ChunkLen: Int32;
  ASRec, BSRec: EndianCnvSnglRec;
  I, J, VertexCount, Position, EdgeCount: Integer;
  V1, V2, V3: Int32;
  X, Y, Z: Single;
  EOF: Boolean;

  function ReadString4: AnsiString;
  var
    ReadLen: Integer;
  begin
    ReadLen := FileStream.Read(Byte5[0], 4);
    Result := PAnsiChar(@Byte5[0]);
    EOF := ReadLen < 4;
  end;

  procedure SkipBytes(const Length: Integer);
  var
    I, ReadLen: Integer;
  begin
    for I := 0 to Length - 1 do begin
      ReadLen := FileStream.Read(Byte5[0], 1);
      EOF := ReadLen < 1;
      if EOF then
        break;
    end;
  end;

  function ReadInt32: Int32;
  var
    Buf: Int32;
    PBuf: Pointer;
    ReadLen: Integer;
  begin
    PBuf := @Buf;
    ReadLen := FileStream.Read(PBuf^, 4);
    EOF := ReadLen < 4;
    if not EOF then
      Result := SwapEndianInt32( Buf )
    else
      Result := 0;
  end;

  function ReadInt16: Int16;
  var
    Buf: Int16;
    PBuf: Pointer;
    ReadLen: Integer;
  begin
    PBuf := @Buf;
    ReadLen := FileStream.Read(PBuf^, 2);
    EOF := ReadLen < 2;
    if not EOF then
      Result := SwapEndianInt16( Buf )
    else
      Result := 0;
  end;

  function ReadSingle: Single;
  var
    ReadLen: Integer;
    PBuf: Pointer;
  begin
    PBuf := @BSRec.EndianVal;
    ReadLen := FileStream.Read(PBuf^, 4);
    EOF := ReadLen < 4;
    if not EOF then begin
      SwapBytesSingle( @ASRec, @BSRec );
      Result := ASRec.EndianVal;
    end
    else
      Result := 0.0;
  end;

  function ReadVertexId( var Position: Integer ): Int32;
  var
    P1, P2: Word;
  begin
    P1 := ReadInt16;
    Position := Position + 2;
    if P1 < LW_MAXU2 then
      Result := P1
    else begin
      P2 := ReadInt16;
      Result := ( P1 shl 16 + P2 ) - Longword($FF000000);
      Position := Position + 2;
    end;
  end;

begin
  FileStream := TFileStream.Create(Filename, fmOpenRead);
  try
    Faces.Clear;
    Byte5[4] := 0;
    ChunkId := ReadString4;
    if ChunkId<>'FORM' then
      raise Exception.Create('Missing <FORM>-header');
    SkipBytes(4);
    ChunkId := ReadString4;
    if ChunkId<>'LWO2' then
      raise Exception.Create('Missing <LWO2>-header');
    while( not EOF ) do begin
      ChunkId := ReadString4;
      ChunkLen := ReadInt32;
      if EOF then
        break;
      if ChunkId = 'PNTS' then begin
        VertexCount := ChunkLen div 12;
        for I := 0 to VertexCount - 1 do begin
          X := ReadSingle;
          if EOF then
            break;
          Y := ReadSingle;
          if EOF then
            break;
          Z := ReadSingle;
          if EOF then
            break;
          Faces.AddUnvalidatedVertex(X, Y, Z);
        end
      end
      else if ChunkId = 'POLS' then begin
        SubId := ReadString4;
        if SubId <> 'FACE' then begin
//          raise Exception.Create('POLS-type <FACE> expected');
          SkipBytes( ChunkLen - 4 );
        end
        else begin
          Position := 4;
          while Position < ChunkLen do begin
            EdgeCount := ReadInt16;
            Position := Position + 2;
            if EdgeCount = 3 then begin
              V1 := ReadVertexId( Position );
              V2 := ReadVertexId( Position );
              V3 := ReadVertexId( Position );
              if EOF then
                 break;
              Faces.AddFace(V1, V2, V3);
            end
            else begin
              for J:=0 to EdgeCount - 1 do begin
                ReadVertexId( Position );
              end;
            end;
            if EOF then
               break;
          end;
        end;
      end
      else
        SkipBytes( ChunkLen );
    end;
  finally
    FileStream.Free;
  end;
end;

{ -------------------------- TWavefrontObjFileReader ------------------------- }
// Reads only the portions currently needed: vertices and polygons/faces
procedure TWavefrontObjFileReader.LoadFromFile(const Filename: String; Faces: TFacesList);
var
  Line: String;
  Lines, TokenLst: TStringList;
  FS: TFormatSettings;

  function GetVertexFromStr( const VertexStr: String): Integer;
  var
    P: Integer;
  begin
    P := Pos( '/', VertexStr );
    if P > 1  then
      Result := StrToInt( Copy( VertexStr, 1, P - 1 ) ) - 1
    else
      Result := StrToInt( VertexStr ) - 1;
  end;

begin
  FS := TFormatSettings.Create('en-US');
  Lines := TStringList.Create;
  try
    Lines.LoadFromFile( Filename );
    Faces.Clear;
    TokenLst := TStringList.Create;
    try
      TokenLst.Delimiter := ' ';
      TokenLst.StrictDelimiter := True;
      for Line in Lines do begin
        TokenLst.DelimitedText := Line;
        if ( TokenLst.Count = 4 ) and ( TokenLst[ 0 ] = 'v' ) then begin
          Faces.AddUnvalidatedVertex( StrToFloat( TokenLst[ 1 ], FS ), StrToFloat( TokenLst[ 2 ], FS ), StrToFloat( TokenLst[ 3 ], FS ) );
        end
        else if ( TokenLst.Count = 4 ) and ( TokenLst[ 0 ] = 'f' ) then begin
          Faces.AddFace( GetVertexFromStr( TokenLst[ 1 ] ), GetVertexFromStr( TokenLst[ 2 ] ), GetVertexFromStr( TokenLst[ 3 ] ) );
        end
        else if ( TokenLst.Count = 5 ) and ( TokenLst[ 0 ] = 'f' ) then begin
          Faces.AddFace( GetVertexFromStr( TokenLst[ 1 ] ), GetVertexFromStr( TokenLst[ 2 ] ), GetVertexFromStr( TokenLst[ 3 ] ) );
          Faces.AddFace( GetVertexFromStr( TokenLst[ 1 ] ), GetVertexFromStr( TokenLst[ 3 ] ), GetVertexFromStr( TokenLst[ 4 ] ) );
        end;
      end;
    finally
      TokenLst.Free;
    end;
  finally
    Lines.Free;
  end;
end;

end.
