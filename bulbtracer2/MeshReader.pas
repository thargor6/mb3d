(*
  BulbTracer2 for MB3D
  Copyright (C) 2016-2019 Andreas Maschke

  This is free software; you can redistribute it and/or modify it under the terms of the GNU Lesser
  General Public License as published by the Free Software Foundation; either version 2.1 of the
  License, or (at your option) any later version.

  This software is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
  even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
  Lesser General Public License for more details.
  You should have received a copy of the GNU Lesser General Public License along with this software;
  if not, write to the Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
  02110-1301 USA, or see the FSF site: http://www.fsf.org.
*)
unit MeshReader;

interface

uses
  SysUtils, Classes, Contnrs, VectorMath, SyncObjs, Generics.Collections,
  VertexList;

type
  TAbstractFileReader = class
  end;

  TWavefrontObjFileReader = class( TAbstractFileReader )
  public
    procedure LoadFromFile(const Filename: String; Faces: TFacesList);
  end;

implementation

uses
  Windows, Math, DateUtils, MeshIOUtil;

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
        if ( TokenLst.Count in [4, 7] ) and ( TokenLst[ 0 ] = 'v' ) then begin
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
