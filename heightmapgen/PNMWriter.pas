{ ---------------------------------------------------------------------------- }
{ HeightMapGenerator MB3D                                                      }
{ Copyright (C) 2017 Andreas Maschke                                           }
{ ---------------------------------------------------------------------------- }
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


