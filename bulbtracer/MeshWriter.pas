{ ---------------------------------------------------------------------------- }
{ BulbTracer for MB3D                                                          }
{ Copyright (C) 2016-2017 Andreas Maschke                                      }
{ ---------------------------------------------------------------------------- }
unit MeshWriter;

interface

uses
  SysUtils, Classes, Contnrs, VectorMath, SyncObjs, Generics.Collections,
  VertexList;

type
  TAbstractFileWriter = class
    class procedure CreateDrawer(const Filename: String);
  end;

  TPlyFileWriter = class( TAbstractFileWriter )
  public
    class procedure SaveToFile(const Filename: String; const Vertices: TPS3VectorList; const Normals, Colors: TPSMI3VectorList);
  end;

  TObjFileWriter = class( TAbstractFileWriter )
  public
    class procedure SaveToFile(const Filename: String; const Faces: TFacesList);
  end;

  TUnprocessedMeshFileWriter = class( TAbstractFileWriter )
  public
    class procedure CreateFile( const Basefilename: String );
    class function CreatePartFilename( const Idx: integer): string;
    class procedure SaveToFile(const Filename: String; const Faces: TFacesList; const Idx: Integer);
  end;

  TLightwaveObjFileWriter = class( TAbstractFileWriter )
  public
    class procedure SaveToFile(const Filename: String; const Faces: TFacesList);
  end;

implementation

uses
  Windows, Math, DateUtils, MeshIOUtil, ShellApi, BulbTracer2;

{ --------------------------- TAbstractFileWriter ---------------------------- }
class procedure TAbstractFileWriter.CreateDrawer(const Filename: String);
var
  Folder: String;
begin
  Folder := ExtractFilePath(Filename);
  if (Folder <> '') and (not DirectoryExists(Folder)) then
    CreateDir(Folder);
  if not DirectoryExists(Folder) then
    raise Exception.Create('Can not access Folder <'+Folder+'>');
end;
{ ------------------------------ TPlyFileWriter ------------------------------ }
class procedure TPlyFileWriter.SaveToFile(const Filename: String; const Vertices: TPS3VectorList; const Normals, Colors: TPSMI3VectorList);
var
  I: Integer;
  FOut : TextFile;
  TmpBuf: Array[word] of Byte;
  WithColors: Boolean;
  FormatSettings: TFormatSettings;
  LastDecimalSeparator: Char;

  procedure WriteHeader;
  begin
    WriteLn(FOut, 'ply');
    WriteLn(FOut, 'format ascii 1.0');
    WriteLn(FOut, 'element vertex '+IntToStr(Vertices.Count));
    WriteLn(FOut, 'property float x');
    WriteLn(FOut, 'property float y');
    WriteLn(FOut, 'property float z');
    if Normals <> nil then begin
      WriteLn(FOut, 'property float nx');
      WriteLn(FOut, 'property float ny');
      WriteLn(FOut, 'property float nz');
    end;
    if Colors <> nil then begin
      WriteLn(FOut, 'property uchar red');
      WriteLn(FOut, 'property uchar green');
      WriteLn(FOut, 'property uchar blue');
      WriteLn(FOut, 'property uchar alpha');
    end;
    WriteLn(FOut, 'end_header');
  end;

  procedure WriteVertex(const Idx: Integer);
  var
    Vertex : TPS3Vector;
    N, Color: TPSMI3Vector;

    function RoundColor(const Value: Smallint): Integer;
    begin
      Result := Max(0, Min( 255, Round(255.0 * TPSMI3VectorList.SMIToFloat( Value ) ) ) );
    end;

  begin
    Vertex := Vertices.GetVertex(Idx);

    if Colors <> nil then begin
      Color := Colors.GetVertex(Idx);
      if Normals <> nil then begin
        N := Normals.GetVertex(Idx);
        WriteLn(FOut, FloatToStr(Vertex^.X)+' '+FloatToStr(Vertex^.Y, FormatSettings)+' '+FloatToStr(Vertex^.Z, FormatSettings)+' '+FloatToStr(TPSMI3VectorList.SMIToFloat(N^.X), FormatSettings)+' '+FloatToStr(TPSMI3VectorList.SMIToFloat(N^.Y), FormatSettings)+' '+FloatToStr(TPSMI3VectorList.SMIToFloat(N^.Z), FormatSettings)+' '+IntToStr(RoundColor(Color.X))+' '+IntToStr(RoundColor(Color.Y))+' '+IntToStr(RoundColor(Color.Z))+' '+IntToStr(255));
      end
      else begin
        WriteLn(FOut, FloatToStr(Vertex^.X, FormatSettings)+' '+FloatToStr(Vertex^.Y, FormatSettings)+' '+FloatToStr(Vertex^.Z, FormatSettings)+' '+IntToStr(RoundColor(Color.X))+' '+IntToStr(RoundColor(Color.Y))+' '+IntToStr(RoundColor(Color.Z))+' '+IntToStr(255));
      end;
    end
    else begin
      if Normals <> nil then begin
        N := Normals.GetVertex(Idx);
        WriteLn(FOut, FloatToStr(Vertex^.X, FormatSettings)+' '+FloatToStr(Vertex^.Y, FormatSettings)+' '+FloatToStr(Vertex^.Z, FormatSettings)+' '+FloatToStr(TPSMI3VectorList.SMIToFloat(N^.X), FormatSettings)+' '+FloatToStr(TPSMI3VectorList.SMIToFloat(N^.Y), FormatSettings)+' '+FloatToStr(TPSMI3VectorList.SMIToFloat(N^.Z), FormatSettings));
      end
      else begin
        WriteLn(FOut, FloatToStr(Vertex^.X, FormatSettings)+' '+FloatToStr(Vertex^.Y, FormatSettings)+' '+FloatToStr(Vertex^.Z, FormatSettings));
      end;
    end;
  end;

begin
  if Vertices=nil then
    raise Exception.Create('PlyFileWriter.SaveToFile: Vertices must not be null');
  if (Normals <> nil) and (Normals.Count <> Vertices.Count) then
    raise Exception.Create('PlyFileWriter.SaveToFile: Normals count <'+IntToStr(Normals.Count)+'> does not match <'+IntToStr(Vertices.Count)+'>');
  CreateDrawer( Filename );

  GetLocaleFormatSettings(GetUserDefaultLCID, FormatSettings);
  LastDecimalSeparator := FormatSettings.DecimalSeparator;
  try
    FormatSettings.DecimalSeparator := '.';
    {$I-}
    AssignFile(FOut, Filename);
    ReWrite(FOut);
    SetTextBuf(FOut,TmpBuf);
    WriteHeader;
    for I := 0 to Vertices.Count - 1 do begin
      WriteVertex(I);
    end;
    if IOResult<>0 then
      raise Exception.Create('PlyFileWriter.SaveToFile: Error writing file');
    CloseFile(fout);
    {$I+}
  finally
    FormatSettings.DecimalSeparator := LastDecimalSeparator;
  end;
end;
{ ----------------------------- TObjFileWriter ------------------------------- }
class procedure TObjFileWriter.SaveToFile(const Filename: String; const Faces: TFacesList);
var
  FOut : TextFile;
  TmpBuf: Array[word] of Byte;
  Normals: TPS3VectorList;
  LastDecimalSeparator: Char;
  FormatSettings: TFormatSettings;
  WithColors: Boolean;

  procedure WriteHeader;
  begin
    WriteLn(FOut, '####');
    WriteLn(FOut, '#');
    WriteLn(FOut, '# OBJ File Generated by Mandelbulb3D');
    WriteLn(FOut, '#');
    WriteLn(FOut, '####');
    WriteLn(FOut, '#');
    if Normals <> nil then
      WriteLn(FOut, '# Vertices (with normals): '+IntToStr(Faces.Vertices.Count))
    else
      WriteLn(FOut, '# Vertices: '+IntToStr(Faces.Vertices.Count));
    WriteLn(FOut, '# Faces: '+IntToStr(Faces.Count));
    WriteLn(FOut, '#');
    WriteLn(FOut, '####');
  end;

  procedure WriteFooter;
  begin
    WriteLn(FOut, '# End of File');
  end;

  procedure WriteVertices;
  var
    I: Integer;
    Vertex, N: TPS3Vector;
    ColorIdx1, MinColorIdx1, MaxColorIdx1, DeltaColorIdx1, MappedColorIdx1: double;
    ColorIdx2, MinColorIdx2, MaxColorIdx2, DeltaColorIdx2, MappedColorIdx2: double;
  begin
    for I := 0 to Faces.Vertices.Count - 1  do begin
      Vertex := Faces.Vertices.GetVertex(I);
      WriteLn(FOut, 'v '+FloatToStr(Vertex^.X, FormatSettings)+' '+FloatToStr(Vertex^.Y, FormatSettings)+' '+FloatToStr(Vertex^.Z, FormatSettings));
    end;
    if WithColors  then begin
      MinColorIdx1 := 1.0;
      MaxColorIdx1 := 0.0;
      MinColorIdx2 := 1.0;
      MaxColorIdx2 := 0.0;
      for I := 0 to Faces.Vertices.Count - 1  do begin
        TMCCubes.DecodeColorIdx( Faces.VertexColors[I], ColorIdx1, ColorIdx2 );
        if ColorIdx1 < MinColorIdx1 then
          MinColorIdx1 := ColorIdx1;
        if ColorIdx1 > MaxColorIdx1 then
          MaxColorIdx1 := ColorIdx1;
        if ColorIdx2 < MinColorIdx2 then
          MinColorIdx2 := ColorIdx2;
        if ColorIdx2 > MaxColorIdx2 then
          MaxColorIdx2 := ColorIdx2;
      end;
      DeltaColorIdx1 := MaxColorIdx1 - MinColorIdx1;
      if DeltaColorIdx1 < 0.0001 then
        DeltaColorIdx1 := 0.0001;
      DeltaColorIdx2 := MaxColorIdx2 - MinColorIdx2;
      if DeltaColorIdx2 < 0.0001 then
        DeltaColorIdx2 := 0.0001;
      for I := 0 to Faces.Vertices.Count - 1  do begin
        TMCCubes.DecodeColorIdx( Faces.VertexColors[I], ColorIdx1, ColorIdx2 );
        MappedColorIdx1 := (ColorIdx1 - MinColorIdx1) / DeltaColorIdx1;
        MappedColorIdx2 := (ColorIdx2 - MinColorIdx2) / DeltaColorIdx2;
        WriteLn(FOut, 'vt '+FloatToStr(MappedColorIdx1, FormatSettings)+' '+FloatToStr(MappedColorIdx2, FormatSettings));
      end;
    end;

    if Normals<> nil then begin
      for I := 0 to Faces.Vertices.Count - 1  do begin
        N := Normals.GetVertex(I);
        WriteLn(FOut, 'vn '+FloatToStr(N^.X, FormatSettings)+' '+FloatToStr(N^.Y, FormatSettings)+' '+FloatToStr(N^.Z, FormatSettings));
      end;
      WriteLn(FOut, '# '+IntToStr(Faces.Vertices.Count)+' vertices, '+IntToStr(Faces.Vertices.Count)+' vertices normals')
    end
    else begin
      WriteLn(FOut, '# '+IntToStr(Faces.Vertices.Count)+' vertices');
    end;
  end;

  procedure WriteFaces;
  var
    I, V1, V2, V3: Integer;
    Face: TPFace;
  begin
    for I := 0 to Faces.Count - 1 do begin
      Face := Faces.GetFace(I);
      V1 := Face^.Vertex1 + 1;
      V2 := Face^.Vertex2 + 1;
      V3 := Face^.Vertex3 + 1;
      if Normals<>nil then begin
        if WithColors then
          WriteLn(FOut, 'f '+IntToStr(V1)+'/'+IntToStr(V1)+'/'+IntToStr(V1)+' '+IntToStr(V2)+'/'+IntToStr(V2)+'/'+IntToStr(V2)+' '+IntToStr(V3)+'/'+IntToStr(V3)+'/'+IntToStr(V3))
        else
          WriteLn(FOut, 'f '+IntToStr(V1)+'//'+IntToStr(V1)+' '+IntToStr(V2)+'//'+IntToStr(V2)+' '+IntToStr(V3)+'//'+IntToStr(V3))
      end
      else
        if WithColors then
          WriteLn(FOut, 'f '+IntToStr(V1)+'/'+IntToStr(V1)+'/ '+IntToStr(V2)+'/'+IntToStr(V2)+'/ '+IntToStr(V3)+'/'+IntToStr(V3)+'/')
        else
          WriteLn(FOut, 'f '+IntToStr(V1)+' '+IntToStr(V2)+' '+IntToStr(V3));
    end;
    WriteLn(FOut, '# '+IntToStr(Faces.Count)+' faces');
  end;

begin
  CreateDrawer( Filename );

  WithColors := (Faces.VertexColors<>nil) and (Faces.VertexColors.Count = Faces.Vertices.Count);

  GetLocaleFormatSettings(GetUserDefaultLCID, FormatSettings);
  LastDecimalSeparator := FormatSettings.DecimalSeparator;
  try
    FormatSettings.DecimalSeparator := '.';
    {$I-}
    AssignFile(FOut, Filename);
    try
      ReWrite(FOut);
      SetTextBuf(FOut,TmpBuf);

      Normals := nil;
      try
        // Try to calculate normals
        try
          Normals := Faces.CalculateVertexNormals;
        except
          on E: Exception do begin
            OutputDebugString(PChar('Error creating normals: '+E.Message));
          end;
        end;
        // The file is written if normal calculation failed (due the lack of memory)
        WriteHeader;
        WriteVertices;
        WriteFaces;
        WriteFooter;
      finally
        if Normals <> nil then
          Normals.Free;
      end;
      if IOResult<>0 then
        raise Exception.Create('Error writing file');
    finally
      CloseFile(FOut);
    end;
    {$I+}
  finally
    FormatSettings.DecimalSeparator := LastDecimalSeparator;
  end;
end;
{ ------------------------ TUnprocessedMeshFileWriter ------------------------ }
class function TUnprocessedMeshFileWriter.CreatePartFilename( const Idx: integer): string;
begin
  Result := Format('%.3d', [Idx] )+'.lwo';
end;

class procedure TUnprocessedMeshFileWriter.CreateFile( const Basefilename: String );

  procedure DeleteDirectory(const DirName: string);
  var
    FileOp: TSHFileOpStruct;
  begin
    FillChar(FileOp, SizeOf(FileOp), 0);
    FileOp.wFunc := FO_DELETE;
    FileOp.pFrom := PChar(DirName+#0);//double zero-terminated
    FileOp.fFlags := FOF_SILENT or FOF_NOERRORUI or FOF_NOCONFIRMATION;
    SHFileOperation(FileOp);
  end;

begin
  if DirectoryExists( Basefilename ) then
    DeleteDirectory( Basefilename );
  ForceDirectories( Basefilename );
end;

(*
class procedure TUnprocessedMeshFileWriter.SaveToFile(const Filename: String; const FacesLists: TObjectList);
var
  I: Integer;
  Faces: TFacesList;
  CurrFilename: String;
begin
  CreateFile( Filename );
  for I := 0 to FacesLists.Count - 1 do begin
    Faces := TFacesList( FacesLists[I] );
    CurrFilename := IncludeTrailingBackslash( Filename ) + CreatePartFilename( I );
    CreateDrawer( CurrFilename );
    TLightwaveObjFileWriter.SaveToFile(CurrFilename, Faces );
  end;
end;
*)

class procedure TUnprocessedMeshFileWriter.SaveToFile(const Filename: String; const Faces: TFacesList; const Idx: Integer);
var
  CurrFilename: String;
begin
  if Idx = 0 then
    CreateFile( Filename );
  CurrFilename := IncludeTrailingBackslash( Filename ) + CreatePartFilename( Idx );
  CreateDrawer( CurrFilename );
  TLightwaveObjFileWriter.SaveToFile(CurrFilename, Faces );
end;
{ -------------------------- TLightwaveObjFileWriter ------------------------- }


class procedure TLightwaveObjFileWriter.SaveToFile(const Filename: String; const Faces: TFacesList);
const
  HeaderSize: Int32 = 4;
  Surfacename: AnsiString = 'Default';

  colr_red: Single = 0.9;
  colr_green: Single = 0.5;
  colr_blue: Single = 0.1;
  diffuse: Single = 0.9;
var
  FileStream: TFileStream;
  ASRec, BSRec: EndianCnvSnglRec;
  Vertex: TPS3Vector;
  Face: TPFace;

  procedure WriteString(const Value: AnsiString);
  begin
    FileStream.WriteData(PAnsiChar(Value), Length(Value));
  end;

  procedure WriteNullTerminatedString(const Value: AnsiString);
  begin
    FileStream.WriteData(PAnsiChar(Value), Length(Value));
    FileStream.WriteData(0, 1);
  end;

  procedure WriteInt32(const Value: Int32);
  begin
    FileStream.WriteData(SwapEndianInt32(Value), 4);
  end;

  procedure WriteInt16(const Value: Int16);
  begin
    FileStream.WriteData(SwapEndianInt16(Value), 2);
  end;

  procedure WriteSingle(const Value: Single);
  begin
    BSRec.EndianVal := Value;
    SwapBytesSingle( @ASRec, @BSRec );
    FileStream.WriteData(ASRec.EndianVal, 4);
  end;

  function CalculateVertexIdxSize(const VertexIdx: Int32): Int32; overload;
  begin
    if VertexIdx < LW_MAXU2 then
      Result := 2
    else
      Result := 4;
  end;

  function CalculateVertexIdxSize: Int32; overload;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 0 to Faces.Count - 1 do begin
      Face := Faces.GetFace(I);
      Result := Result + CalculateVertexIdxSize(Face^.Vertex1) +
                         CalculateVertexIdxSize(Face^.Vertex2) +
                         CalculateVertexIdxSize(Face^.Vertex3);
    end;
  end;

  function CalcPTagSize: Int32;
  var
    I: Integer;
  begin
    Result := 0;
    for I := 0 to Faces.Count - 1 do
      Inc( Result, CalculateVertexIdxSize( I ) );
  end;

  procedure WriteVertexIdx(const Value: Int32);
  begin
    if Value < LW_MAXU2 then
      WriteInt16( Value )
    else
      WriteInt32( $FF000000 + Value );
  end;

  procedure WriteOnlyGeometry;
  var
    I: Integer;
    TotalSize, TagsSize, LayrSize, PointsSize, PolsSize: Int32;
  begin
    TagsSize := Length( Surfacename ) + 1;

    LayrSize := 18; // Fixed

    PointsSize := Faces.Vertices.Count * 3 * SizeOf( Single );

    PolsSize := HeaderSize + // FACE
                Faces.Count * 2 + // VerticeCount per Poly
                CalculateVertexIdxSize; // Actual Vertices

    TotalSize := HeaderSize + // LWO2
                 2 * HeaderSize + TagsSize + // TAGS + Size + Tags
                 2 * HeaderSize + LayrSize + // LAYR + Size + Layer
                 2 * HeaderSize + PointsSize + // PNTS + Size + Points
                 2 * HeaderSize + PolsSize; // POLS + Size + Pols

    // Header
    WriteString('FORM');
    WriteInt32(TotalSize);
    WriteString('LWO2');
    // Tags
    WriteString('TAGS');
    WriteInt32(TagsSize);
    WriteNullTerminatedString( Surfacename );
    WriteString('LAYR');
    WriteInt32(LayrSize);
    WriteInt16(0); // number
    WriteInt16(0); // flags
    WriteSingle(0.0); // pivot X
    WriteSingle(0.0); // pivot Y
    WriteSingle(0.0); // pivot Z
    WriteInt16(0); // parent

    // Points
    WriteString('PNTS');
    WriteInt32(PointsSize);

    for I := 0 to Faces.Vertices.Count - 1  do begin
      Vertex := Faces.Vertices.GetVertex(I);
      WriteSingle(Vertex^.X);
      WriteSingle(Vertex^.Y);
      WriteSingle(Vertex^.Z);
    end;
    // Faces
    WriteString('POLS');
    WriteInt32(PolsSize);
    WriteString('FACE');
    for I := 0 to Faces.Count - 1 do begin
      Face := Faces.GetFace(I);
      WriteInt16(3);
      WriteVertexIdx(Face^.Vertex1);
      WriteVertexIdx(Face^.Vertex2);
      WriteVertexIdx(Face^.Vertex3);
    end;
  end;

begin
  CreateDrawer( Filename );
  FileStream := TFileStream.Create(Filename, fmCreate);
  try
    WriteOnlyGeometry
  finally
    FileStream.Free;
  end;
end;


end.
