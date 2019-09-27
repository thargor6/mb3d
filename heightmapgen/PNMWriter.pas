(*
  HeightMapGenerator for MB3D
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
unit PNMWriter;

interface

uses
  SysUtils, Classes, Windows;

type
  TPGM16Writer = class
  public
    procedure SaveToFile(  const Buffer: PWord; const Width, Height: Integer; const Filename: String);
  end;

implementation

procedure TPGM16Writer.SaveToFile(  const Buffer: PWord; const Width, Height: Integer; const Filename: String);
var
  FileStream: TFileStream;
  StrBuffer: AnsiString;
  I, J: Integer;
  Lst: TStringList;
  CurrPGMBuffer: PWord;
  ValStr: String;
  Histogram: TStringList;
begin
  FileStream := TFileStream.Create(Filename, fmCreate);
  try
    Lst := TStringList.Create;
    try
      Lst.Delimiter := ' ';
      StrBuffer := 'P2'#10+'# MB3D'#10 +IntTostr(Width)+' '+IntToStr(Height)+#10+'65535' +#10;
      FileStream.WriteData( PAnsiChar( StrBuffer ), Length( StrBuffer ) );
      CurrPGMBuffer := Buffer;

      Histogram := TStringList.Create;
      try
        Histogram.Sorted := True;
        Histogram.Duplicates := dupIgnore;

        for I := 0 to Height - 1 do begin
          Lst.Clear;
          for J := 0 to Width - 1 do begin
            ValStr := IntToStr( CurrPGMBuffer^ );
            Lst.Add( ValStr );
            Histogram.Add( ValStr );
            CurrPGMBuffer := PWord( Longint( CurrPGMBuffer ) + SizeOf( Word ) );
          end;
          StrBuffer := Lst.DelimitedText+#10;
          FileStream.WriteData( PAnsiChar( StrBuffer ), Length( StrBuffer ) );
        end;
        OutputDebugString(PChar('PGM: ' + IntToStr( Histogram.Count ) + ' distinct colors'));
      finally
        Histogram.Free;
      end;
    finally
      Lst.Free;
    end;
  finally
    FileStream.Free;
  end;
end;

end.


