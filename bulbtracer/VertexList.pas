{ ---------------------------------------------------------------------------- }
{ BulbTracer for MB3D                                                          }
{ Copyright (C) 2016-2017 Andreas Maschke                                      }
{ ---------------------------------------------------------------------------- }
unit VertexList;

interface

uses
  SysUtils, Classes, Contnrs, VectorMath, SyncObjs, Generics.Collections;

type
  TFace = packed record
    Vertex1, Vertex2, Vertex3: Integer;
  end;
  TPFace = ^TFace;
  TPSingle = PSingle;

  TPS3VectorList = class
  private
    FVertices: TList;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure AddVertex(const V: TD3Vector); overload;
    procedure AddVertex(const VX, VY, VZ: Double); overload;
    function GetVertex(const Idx: Integer): TPS3Vector;
    procedure MoveVertices(const Src: TPS3VectorList);
    procedure DoCenter(const MaxSize: Double);
    procedure DoScale(const ScaleX, ScaleY, ScaleZ: Double);
    procedure RemoveDuplicates;
    property Count: Integer read GetCount;
  end;

  TPSMI3VectorList = class
  private
    FVertices: TList;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    class function FloatToSMI(const Value: Double): Smallint;
    class function SMIToFloat(const Value: Smallint): Double;
    procedure AddVertex(const VX, VY, VZ: Double); overload;
    function GetVertex(const Idx: Integer): TPSMI3Vector;
    procedure MoveVertices(const Src: TPSMI3VectorList);
    property Count: Integer read GetCount;
  end;

  TPS4VectorList = class
  private
    FVertices: TList;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure AddVector(const VX, VY, VZ, VW: Double);
    function GetVector(const Idx: Integer): TPS4Vector;
    property Count: Integer read GetCount;
  end;

  TVertexNeighboursList = class;
  TFaceNeighboursList = class;

  TFacesList = class
  private
    FFaces: TList;
    FVertices: TPS3VectorList;
    FVertexColors: TList<Single>;
    FVertexKeys: TDictionary<string, integer>;
    function GetCount: Integer;
    function MakeVertexKey(const X, Y, Z: Double): String; overload;
    function ValidateFace(const V1, V2, V3: Integer): Boolean;
    procedure LaplaceSmooth(const NeighboursList: TVertexNeighboursList; const Strength: Double);
    procedure CompressPlanarVertices;
    procedure RemoveVertices(const VerticesToRemove: TList; const FaceNeighbours: TFaceNeighboursList);
    function CalculateFaceNormals: TPS4VectorList;
    function GetVertexCount: Integer;
    procedure CleanupRemovedFaces;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    property Vertices: TPS3VectorList read FVertices;
    procedure AddFace(const Vertex1, Vertex2, Vertex3: Integer); overload;
    procedure AddFace(const Vertex1, Vertex2, Vertex3: TPD3Vector); overload;
    procedure AddFace(const Vertex1, Vertex2, Vertex3: TPD4Vector); overload;
    procedure AddFaceWithoutColor(const Vertex1, Vertex2, Vertex3: TPD4Vector);
    function AddVertex(const X, Y, Z: Single): Integer; overload;
    function AddVertex(const V: TPS3Vector): Integer; overload;
    function AddVertex(const V: TPS3Vector; const ColorIdx: Single): Integer; overload;
    function AddVertex(const V: TPD4Vector): Integer; overload;
    function AddVertexWithoutColor(const V: TPD4Vector): Integer;
    function AddVertex(const V: TPS3Vector; const Sync: TCriticalSection ): Integer; overload;
    function AddVertex(const V: TPS4Vector; const Sync: TCriticalSection ): Integer; overload;
    function AddVertex(const V: TPD3Vector): Integer; overload;
    function GetFace(const Idx: Integer): TPFace;
    function GetVertex(const Idx: Integer): TPS3Vector;
    procedure MoveFaces(const Src: TFacesList); overload;
    procedure MoveFaces(const Src: TFacesList; const Sync: TCriticalSection ); overload;
    procedure RemoveDuplicates;
    procedure TaubinSmooth(const Lambda, Mu: Double; const Passes: Integer);
    procedure CompressFaces(const Passes: Integer);
    procedure DoCenter(const MaxSize: Double);
    procedure DoScale(const ScaleX, ScaleY, ScaleZ: Double);
    procedure RecalcVertexKeys;
    procedure AddUnvalidatedVertex(const X, Y, Z: Double);
    procedure AddUnvalidatedFace(const Vertex1, Vertex2, Vertex3: Integer);

    function CalculateVertexNormals: TPS3VectorList;
    class function MergeFacesLists(const FacesListsToMerge: TList; const MultiThreaded: boolean = false): TFacesList;
    property Count: Integer read GetCount;
    property VertexCount: Integer read GetVertexCount;
    property VertexColors: TList<Single> read FVertexColors;

  end;

  TNeighboursList = class
  protected
    FVertices: TList;
    function CreateNeighboursList(const Faces: TFacesList): TList; virtual; abstract;
  public
    constructor Create(const Faces: TFacesList);
    destructor Destroy; override;
    function GetNeighbours(const Idx: Integer): TList;
    procedure SaveToFile(const Filename: String);
  end;

  TVertexNeighboursList = class(TNeighboursList)
  protected
    function CreateNeighboursList(const Faces: TFacesList): TList; override;
  end;

  TFaceNeighboursList = class(TNeighboursList)
  protected
    function CreateNeighboursList(const Faces: TFacesList): TList; override;
  end;

  procedure ShowDebugInfo(const Msg: String; const RefTime: Int64);

implementation

uses
  Windows, Math, DateUtils;
{ ----------------------------------- Misc ----------------------------------- }
procedure ShowDebugInfo(const Msg: String; const RefTime: Int64);
var
  MillisNow: Int64;
begin
  MillisNow := DateUtils.MilliSecondsBetween(Now, 0);
  OutputDebugString(PChar(Msg+': '+IntToStr(MillisNow-RefTime)+' ms'))
end;
{ ----------------------------- TPS3VectorList ------------------------------- }
constructor TPS3VectorList.Create;
begin
  inherited Create;
  FVertices := TList.Create;
end;

destructor TPS3VectorList.Destroy;
begin
  Clear;
  FVertices.Free;
  inherited Destroy;
end;

procedure TPS3VectorList.Clear;
var
  I: Integer;
begin
  for I := 0 to FVertices.Count -1  do begin
    if FVertices[I] <> nil then
      FreeMem(FVertices[I]);
  end;
  FVertices.Clear;
end;

procedure TPS3VectorList.AddVertex(const V: TD3Vector);
var
  Vertex: TPS3Vector;
begin
  GetMem(Vertex, SizeOf(TS3Vector));
  FVertices.Add(Vertex);
  Vertex^.X := V.X;
  Vertex^.Y := V.Y;
  Vertex^.Z := V.Z;
end;

procedure TPS3VectorList.AddVertex(const VX, VY, VZ: Double);
var
  Vertex: TPS3Vector;
begin
  GetMem(Vertex, SizeOf(TS3Vector));
  FVertices.Add(Vertex);
  Vertex^.X := VX;
  Vertex^.Y := VY;
  Vertex^.Z := VZ;
end;

function TPS3VectorList.GetVertex(const Idx: Integer): TPS3Vector;
begin
  Result := FVertices[Idx];
end;

function TPS3VectorList.GetCount: Integer;
begin
  Result := FVertices.Count;
end;

procedure TPS3VectorList.MoveVertices(const Src: TPS3VectorList);
var
  I: Integer;
begin
  if Src <> nil then begin
    for I := 0 to Src.FVertices.Count - 1 do begin
      FVertices.Add(Src.FVertices[I]);
      Src.FVertices[I] := nil;
    end;
    Src.FVertices.Clear;
    Src.Clear;
  end;
end;

procedure TPS3VectorList.RemoveDuplicates;
var
  I: Integer;
  Vertex: TPS3Vector;
  Key: String;
  KeyList: TStringList;
  NewList: TList;

  function MakeKey(const Vertex: TPS3Vector): String;
  begin
    with Vertex^ do begin
      Result := FloatToStr(X)+'#'+FloatToStr(Y)+'#'+FloatToStr(Z);
    end;
  end;

begin
  KeyList := TStringList.Create;
  try
    KeyList.Sorted := True;
    KeyList.Duplicates := dupIgnore;
    NewList := TList.Create;
    try
      for I := 0 to FVertices.Count - 1 do begin
        Vertex := FVertices[I];
        Key := MakeKey(Vertex);
        if KeyList.IndexOf(Key) < 0 then begin
          KeyList.Add(Key);
          NewList.Add(Vertex);
        end;
      end;
      {$ifdef DEBUG_MESHEXP}
      if FVertices.Count <> NewList.Count  then
        OutputDebugString(PChar('TVertexList.RemoveDuplicates: '+IntToStr(FVertices.Count)+' -> '+IntToStr(NewList.Count)));
      {$endif}
      FVertices.Free;
      FVertices := NewList;
    except
      NewList.Free;
      raise;
    end;
  finally
    KeyList.Free;
  end;
end;

procedure TPS3VectorList.DoScale(const ScaleX, ScaleY, ScaleZ: Double);
var
  I: Integer;
  Vertex: TPS3Vector;
begin
  for I := 0 to FVertices.Count - 1 do begin
    Vertex := FVertices[I];
    Vertex^.X := ScaleX * Vertex^.X;
    Vertex^.Y := ScaleY * Vertex^.Y;
    Vertex^.Z := ScaleZ * Vertex^.Z;
  end;
end;

procedure TPS3VectorList.DoCenter(const MaxSize: Double);
var
  I: Integer;
  Vertex: TPS3Vector;
  XMin, XMax, YMin, YMax, ZMin, ZMax: Double;
  SX, SY, SZ, DX, DY, DZ, SMAX, Scale: Double;
begin
  if FVertices.Count > 0 then begin
    Vertex := FVertices[0];
    XMin := Vertex^.X;
    XMax := XMin;
    YMin := Vertex^.Y;
    YMax := YMin;
    ZMin := Vertex^.Z;
    ZMax := ZMin;
    for I := 1 to FVertices.Count - 1 do begin
      Vertex := FVertices[I];
      if Vertex^.X < XMin then
        XMin := Vertex^.X
      else if Vertex^.X > XMax then
        XMax := Vertex^.X;
      if Vertex^.Y < YMin then
        YMin := Vertex^.Y
      else if Vertex^.Y > YMax then
        YMax := Vertex^.Y;
      if Vertex^.Z < ZMin then
        ZMin := Vertex^.Z
      else if Vertex^.Z > ZMax then
        ZMax := Vertex^.Z;
    end;
    SX := XMax - XMin;
    SY := YMax - YMin;
    SZ := ZMax - ZMin;
    SMAX := Max( Max( SX, SY ), SZ);
    Scale := MaxSize / SMAX;

    DX := -XMin - SX / 2.0;
    DY := -YMin - SY / 2.0;
    DZ := -ZMin - SZ / 2.0;
    for I := 0 to FVertices.Count - 1 do begin
      Vertex := FVertices[I];
      Vertex^.X := (Vertex^.X + DX) * Scale;
      Vertex^.Y := (Vertex^.Y + DY) * Scale;
      Vertex^.Z := (Vertex^.Z + DZ) * Scale;
    end;
  end;
end;
{ ----------------------------- TPSMI3VectorList ------------------------------- }
constructor TPSMI3VectorList.Create;
begin
  inherited Create;
  FVertices := TList.Create;
end;

destructor TPSMI3VectorList.Destroy;
begin
  Clear;
  FVertices.Free;
  inherited Destroy;
end;

procedure TPSMI3VectorList.Clear;
var
  I: Integer;
begin
  for I := 0 to FVertices.Count -1  do begin
    if FVertices[I] <> nil then
      FreeMem(FVertices[I]);
  end;
  FVertices.Clear;
end;

class function TPSMI3VectorList.FloatToSMI(const Value: Double): Smallint;
begin
  if ( Value < -1.0 ) or ( Value > 1.0 ) then
    raise Exception.Create('TPSMI3VectorList.FloatToSMI: Invalid value <' + FloatToStr( Value ) + '>');
  Result := Round( 32767 * Value );
end;


class function TPSMI3VectorList.SMIToFloat(const Value: Smallint): Double;
begin
  Result := Value / 32767.0;
end;

procedure TPSMI3VectorList.AddVertex(const VX, VY, VZ: Double);
var
  Vertex: TPS3Vector;
begin
  GetMem(Vertex, SizeOf(TSMI3Vector));
  FVertices.Add(Vertex);
  Vertex^.X := FloatToSMI( VX );
  Vertex^.Y := FloatToSMI( VY );
  Vertex^.Z := FloatToSMI( VZ );
end;

function TPSMI3VectorList.GetVertex(const Idx: Integer): TPSMI3Vector;
begin
  Result := FVertices[Idx];
end;

function TPSMI3VectorList.GetCount: Integer;
begin
  Result := FVertices.Count;
end;

procedure TPSMI3VectorList.MoveVertices(const Src: TPSMI3VectorList);
var
  I: Integer;
begin
  if Src <> nil then begin
    for I := 0 to Src.FVertices.Count - 1 do begin
      FVertices.Add(Src.FVertices[I]);
      Src.FVertices[I] := nil;
    end;
    Src.FVertices.Clear;
    Src.Clear;
  end;
end;

{ ----------------------------- TPS4VectorList ------------------------------- }
constructor TPS4VectorList.Create;
begin
  inherited Create;
  FVertices := TList.Create;
end;

destructor TPS4VectorList.Destroy;
begin
  Clear;
  FVertices.Free;
  inherited Destroy;
end;

procedure TPS4VectorList.Clear;
var
  I: Integer;
begin
  for I := 0 to FVertices.Count -1  do begin
    if FVertices[I] <> nil then
      FreeMem(FVertices[I]);
  end;
  FVertices.Clear;
end;

procedure TPS4VectorList.AddVector(const VX, VY, VZ, VW: Double);
var
  Vertex: TPS4Vector;
begin
  GetMem(Vertex, SizeOf(TS4Vector));
  FVertices.Add(Vertex);
  Vertex^.X := VX;
  Vertex^.Y := VY;
  Vertex^.Z := VZ;
  Vertex^.W := VW;
end;

function TPS4VectorList.GetVector(const Idx: Integer): TPS4Vector;
begin
  Result := FVertices[Idx];
end;

function TPS4VectorList.GetCount: Integer;
begin
  Result := FVertices.Count;
end;
{ -------------------------------- TFacesList -------------------------------- }
constructor TFacesList.Create;
begin
  inherited Create;
  FFaces := TList.Create;
  FVertices := TPS3VectorList.Create;
  FVertexKeys := TDictionary<string,integer>.Create;
  FVertexColors := TList<Single>.Create;
end;

destructor TFacesList.Destroy;
begin
  Clear;
  FFaces.Free;
  FVertices.Free;
  FVertexKeys.Free;
  FVertexColors.Free;
  inherited Destroy;
end;

procedure TFacesList.Clear;
var
  I: Integer;
begin
  for I := 0 to FFaces.Count - 1  do begin
    if FFaces[I] <> nil then
      FreeMem(FFaces[I]);
  end;
  FFaces.Clear;
  FVertices.Clear;
  FVertexKeys.Clear;
end;

function TFacesList.GetFace(const Idx: Integer): TPFace;
begin
  Result := FFaces[Idx];
end;

function TFacesList.GetVertex(const Idx: Integer): TPS3Vector;
begin
  Result := FVertices.GetVertex(Idx);
end;

function TFacesList.GetCount: Integer;
begin
  Result := FFaces.Count;
end;

function TFacesList.GetVertexCount: Integer;
begin
  Result := FVertices.Count;
end;

procedure TFacesList.AddFace(const Vertex1, Vertex2, Vertex3: Integer);
var
  Face: TPFace;
begin
  if ValidateFace(Vertex1, Vertex2, Vertex3) then begin
    GetMem(Face, SizeOf(TFace));
    FFaces.Add(Face);
    Face^.Vertex1 := Vertex1;
    Face^.Vertex2 := Vertex2;
    Face^.Vertex3 := Vertex3;
  end
end;

procedure TFacesList.AddUnvalidatedFace(const Vertex1, Vertex2, Vertex3: Integer);
var
  Face: TPFace;
begin
  GetMem(Face, SizeOf(TFace));
  FFaces.Add(Face);
  Face^.Vertex1 := Vertex1;
  Face^.Vertex2 := Vertex2;
  Face^.Vertex3 := Vertex3;
end;

procedure TFacesList.AddUnvalidatedVertex(const X, Y, Z: Double);
var
  Key: String;
//  VerticesCount: Integer;
begin
//  VerticesCount := FVertices.Count;
  Key := MakeVertexKey(X, Y, Z);
  FVertices.AddVertex(X, Y, Z);
  // Unvalidated Vertices have no keys
  //  FVertexKeys.Add(Key, VerticesCount);
end;

procedure TFacesList.AddFace(const Vertex1, Vertex2, Vertex3: TPD3Vector);
begin
  AddFace(AddVertex(Vertex1), AddVertex(Vertex2), AddVertex(Vertex3));
end;

procedure TFacesList.AddFace(const Vertex1, Vertex2, Vertex3: TPD4Vector);
begin
  AddFace(AddVertex(Vertex1), AddVertex(Vertex2), AddVertex(Vertex3));
end;

procedure TFacesList.AddFaceWithoutColor(const Vertex1, Vertex2, Vertex3: TPD4Vector);
begin
  AddFace(AddVertexWithoutColor(Vertex1), AddVertexWithoutColor(Vertex2), AddVertexWithoutColor(Vertex3));
end;

function TFacesList.MakeVertexKey(const X, Y, Z: Double): String;
const
  Prec: Double = 10000.0;
begin
//  Result := FloatToStr(X)+'#'+FloatToStr(Y)+'#'+FloatToStr(Z);
  Result := IntToStr(Round(X*Prec))+'#'+IntToStr(Round(Y*Prec))+'#'+IntToStr(Round(Z*Prec));
end;

procedure TFacesList.RecalcVertexKeys;
var
 I: Integer;
 Key: String;
 V: TPS3Vector;
begin
  FVertexKeys.Clear;
  for I := 0 to FVertices.Count - 1 do begin
    V := FVertices.GetVertex( I );
    Key := MakeVertexKey(V^.X, V^.Y, V^.Z);
    FVertexKeys.Add(Key, I);
  end;
end;

function TFacesList.AddVertex(const X, Y, Z: Single): Integer;
var
  Key: String;
begin
  Key := MakeVertexKey(X, Y, Z);
  if FVertexKeys.ContainsKey( Key )  then begin
    Result := FVertexKeys.Items[ Key ];
  end
  else begin
    Result := FVertices.Count;
    FVertices.AddVertex(X, Y, Z);
    FVertexKeys.Add(Key, Result);
  end;
end;

function TFacesList.AddVertex(const V: TPS3Vector): Integer;
var
  Key: String;
begin
  Key := MakeVertexKey(V^.X, V^.Y, V^.Z);
  if FVertexKeys.ContainsKey( Key )  then begin
    Result := FVertexKeys.Items[ Key ];
  end
  else begin
    Result := FVertices.Count;
    FVertices.AddVertex(V^.X, V^.Y, V^.Z);
    FVertexKeys.Add(Key, Result);
  end;
end;

function TFacesList.AddVertex(const V: TPS3Vector; const ColorIdx: Single): Integer;
var
  Key: String;
begin
  Key := MakeVertexKey(V^.X, V^.Y, V^.Z);
  if FVertexKeys.ContainsKey( Key )  then begin
    Result := FVertexKeys.Items[ Key ];
    FVertexColors[ Result ] := ColorIdx;
  end
  else begin
    Result := FVertices.Count;
    FVertices.AddVertex(V^.X, V^.Y, V^.Z);
    FVertexKeys.Add(Key, Result);
    FVertexColors.Add( ColorIdx );
  end;
end;

function TFacesList.AddVertex(const V: TPD4Vector): Integer;
var
  Key: String;
begin
  Key := MakeVertexKey(V^.X, V^.Y, V^.Z);
  if FVertexKeys.ContainsKey( Key )  then begin
    Result := FVertexKeys.Items[ Key ];
    FVertexColors[ Result ] := V^.W;
  end
  else begin
    Result := FVertices.Count;
    FVertices.AddVertex(V^.X, V^.Y, V^.Z);
    FVertexKeys.Add(Key, Result);
    FVertexColors.Add( V^.W );
  end;
end;

function TFacesList.AddVertexWithoutColor(const V: TPD4Vector): Integer;
var
  Key: String;
begin
  Key := MakeVertexKey(V^.X, V^.Y, V^.Z);
  if FVertexKeys.ContainsKey( Key )  then begin
    Result := FVertexKeys.Items[ Key ];
  end
  else begin
    Result := FVertices.Count;
    FVertices.AddVertex(V^.X, V^.Y, V^.Z);
    FVertexKeys.Add(Key, Result);
  end;
end;

function TFacesList.AddVertex(const V: TPS3Vector; const Sync: TCriticalSection ): Integer;
var
  Key: String;
begin
  Key := MakeVertexKey(V^.X, V^.Y, V^.Z);
  Sync.Acquire;
  try
    if FVertexKeys.ContainsKey(Key) then begin
      Result := FVertexKeys.Items[ Key ];
    end
    else begin
      Result := FVertices.Count;
      FVertices.AddVertex(V^.X, V^.Y, V^.Z);
      FVertexKeys.Add(Key, Result);
    end;
  finally
    Sync.Release;
  end;
end;

function TFacesList.AddVertex(const V: TPS4Vector; const Sync: TCriticalSection ): Integer;
var
  Key: String;
begin
  Key := MakeVertexKey(V^.X, V^.Y, V^.Z);
  Sync.Acquire;
  try
    if FVertexKeys.ContainsKey(Key) then begin
      Result := FVertexKeys.Items[ Key ];
      FVertexColors[Result] := V^.W;
    end
    else begin
      Result := FVertices.Count;
      FVertices.AddVertex(V^.X, V^.Y, V^.Z);
      FVertexKeys.Add(Key, Result);
      FVertexColors.Add( V^.W );
    end;
  finally
    Sync.Release;
  end;
end;

function TFacesList.AddVertex(const V: TPD3Vector): Integer;
var
  Key: String;
begin
  Key := MakeVertexKey(V^.X, V^.Y, V^.Z);
  if FVertexKeys.ContainsKey( Key ) then begin
    Result := FVertexKeys.Items[ Key ];
  end
  else begin
    Result := FVertices.Count;
    FVertices.AddVertex(V^.X, V^.Y, V^.Z);
    FVertexKeys.Add(Key, Result);
  end;
end;

function TFacesList.ValidateFace(const V1, V2, V3: Integer): Boolean;
begin
  Result := (V1 <> V2) and (V2 <> V3) and (V1 <> V3);
end;

procedure TFacesList.MoveFaces(const Src: TFacesList);
var
  I: Integer;
  Face: TPFace;
  V1, V2, V3: TPS3Vector;
  WithVertexColors: Boolean;
begin
  if Src <> nil then begin
    WithVertexColors := (Src.FVertexColors<> nil) and (Src.FVertexColors.Count = Src.FVertices.Count);
    for I := 0 to Src.FFaces.Count - 1 do begin
      Face := Src.FFaces[I];
      Src.FFaces[I] := nil;
      V1 := Src.FVertices.GetVertex(Face^.Vertex1);
      V2 := Src.FVertices.GetVertex(Face^.Vertex2);
      V3 := Src.FVertices.GetVertex(Face^.Vertex3);
      if WithVertexColors then begin
        Face^.Vertex1 := AddVertex(V1, Src.FVertexColors[Face^.Vertex1]);
        Face^.Vertex2 := AddVertex(V2, Src.FVertexColors[Face^.Vertex2]);
        Face^.Vertex3 := AddVertex(V3, Src.FVertexColors[Face^.Vertex3]);
      end
      else begin
        Face^.Vertex1 := AddVertex(V1);
        Face^.Vertex2 := AddVertex(V2);
        Face^.Vertex3 := AddVertex(V3);
      end;
      if ValidateFace(Face^.Vertex1, Face^.Vertex2, Face^.Vertex3) then
        FFaces.Add(Face)
      else
        FreeMem(Face);
    end;
    Src.FFaces.Clear;
    Src.Clear;
  end;
end;

procedure TFacesList.MoveFaces(const Src: TFacesList; const Sync: TCriticalSection );
var
  I: Integer;
  Face: TPFace;
begin
  if Src <> nil then begin
    for I := 0 to Src.FFaces.Count - 1 do begin
      Face := Src.FFaces[I];
      Src.FFaces[I] := nil;
      Face^.Vertex1 := AddVertex(Src.FVertices.GetVertex(Face^.Vertex1), Sync);
      Face^.Vertex2 := AddVertex(Src.FVertices.GetVertex(Face^.Vertex2), Sync);
      Face^.Vertex3 := AddVertex(Src.FVertices.GetVertex(Face^.Vertex3), Sync);
      if ValidateFace(Face^.Vertex1, Face^.Vertex2, Face^.Vertex3) then begin
        Sync.Acquire;
        try
          FFaces.Add(Face);
        finally
          Sync.Release;
        end;
      end
      else
        FreeMem(Face);
    end;
    Src.FFaces.Clear;
    Src.Clear;
  end;
end;


procedure TFacesList.RemoveDuplicates;
var
  I: Integer;
  OldFaces: TList;
  FacesIdxList: TStringList;
  Face: TPFace;

  function MakeFaceKey: String;
  var
    V1 , V2, V3: Integer;
  begin
    V1 :=Min(Min(Face^.Vertex1, Face^.Vertex2), Face^.Vertex3);
    V3 :=Max(Max(Face^.Vertex1, Face^.Vertex2), Face^.Vertex3);
    if (Face^.Vertex1 > V1) and (Face^.Vertex1 < V3) then
      V2 := Face^.Vertex1
    else if (Face^.Vertex2 > V1) and (Face^.Vertex2 < V3) then
      V2 := Face^.Vertex2
    else
      V2 := Face^.Vertex3;
    Result := IntToStr(V1)+' '+IntToStr(V2)+' '+IntToStr(V3);
  end;

begin
  FacesIdxList := TStringList.Create;
  try
    FacesIdxList.Duplicates := dupIgnore;
    FacesIdxList.Sorted := True;

    OldFaces := FFaces;
    FFaces := TList.Create;
    try
      for I := 0 to OldFaces.Count -1 do begin
        Face := OldFaces[I];
        if FacesIdxList.IndexOf( MakeFaceKey ) < 0 then begin
          OldFaces[I] := nil;
          FFaces.Add(Face);
        end;
      end;
    finally
      for I := 0 to OldFaces.Count - 1 do begin
        Face := OldFaces[I];
        if Face <> nil then begin
          OldFaces[I] := nil;
          FreeMem(Face);
        end;
      end;
      OldFaces.Clear;
      OldFaces.Free;
    end;
  finally
    FacesIdxList.Free;
  end;
end;

procedure TFacesList.TaubinSmooth(const Lambda, Mu: Double; const Passes: Integer);
var
  T0: Int64;
  I :Integer;
  NeighboursList: TVertexNeighboursList;
begin
  NeighboursList := TVertexNeighboursList.Create(Self);
  try
    T0 := DateUtils.MilliSecondsBetween(Now, 0);
    for I := 0 to Passes - 1  do begin
  		LaplaceSmooth(NeighboursList, Lambda);
	  	LaplaceSmooth(NeighboursList, Mu);
    end;
    ShowDebugInfo('TaubinSmooth', T0);
  finally
    NeighboursList.Free;
  end;
end;

const
  LUT_VERTICES_PER_CONFIGURATION_COUNT = 12;

type
  TCompressedFacesConfiguration = Array[0..LUT_VERTICES_PER_CONFIGURATION_COUNT - 1] of Integer;
  TPCompressedFacesConfiguration = ^TCompressedFacesConfiguration;

const
  COMPRESSED_FACES: Array[0..5, 0..LUT_VERTICES_PER_CONFIGURATION_COUNT - 1 ] of Integer = (
    (-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1),
    (-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1),
    (-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1),
    (0, 1, 2, 2, 3, 0, -1, -1, -1, -1, -1, -1),
    (0, 1, 2, 0, 2, 4, 4, 2, 3, -1, -1, -1),
    (1, 2, 3, 1, 3, 4, 1, 4, 0, 0, 4, 5)
  );

procedure TFacesList.RemoveVertices(const VerticesToRemove: TList; const FaceNeighbours: TFaceNeighboursList);
var
  I, J, V, V0, V1, V2, NextV, PrevV, PrevPrevV, Idx: Integer;
  VCount, MaxVCount, MaxIdx: Integer;
  SortedVertices: TList;
  Neighbours, RList: TList;
  Edges: TStringList;
  Face: TPFace;
  RemoveList: TStringList;
  FaceIdx: TPCompressedFacesConfiguration;
  RemoveVertexList, InvalidRemoveLists: TStringList;

  procedure GetBorderVertices(const Face: TPFace;const Center: Integer; var BorderV1, BorderV2: Integer);
  begin
    if Face^.Vertex1 = Center then begin
      BorderV1 := Face^.Vertex2;
      BorderV2 := Face^.Vertex3;
    end
    else if Face^.Vertex2 = Center then begin
      BorderV1 := Face^.Vertex3;
      BorderV2 := Face^.Vertex1;
    end
    else if Face^.Vertex3 = Center then begin
      BorderV1 := Face^.Vertex1;
      BorderV2 := Face^.Vertex2;
    end
    else
      raise Exception.Create('TFacesList.RemoveVertices.GetBorderVertices: Invalid Face <'+IntToStr(Face^.Vertex1)+'/'+IntToStr(Face^.Vertex2)+'/'+IntToStr(Face^.Vertex3)+'>: missing center <'+IntToStr(Center)+'>');
  end;

  procedure ClearEdges;
  var
    I: Integer;
  begin
    for I := 0 to Edges.Count -1 do
      TList(Edges.Objects[I]).Free;
    Edges.Clear;
  end;

  procedure AddEdge(const FromVertex, ToVertex: Integer);
  var
    Key: String;
    I, Idx: Integer;
    Found: Boolean;
    EdgesLst: TList;
  begin
    Key := IntToStr(FromVertex);
    Idx := Edges.IndexOf( Key );
    if Idx < 0 then begin
      EdgesLst := TList.Create;
      Edges.AddObject(Key, EdgesLst);
    end
    else
      EdgesLst := TList(Edges.Objects[Idx]);
    Found := False;
    for I := 0 to EdgesLst.Count - 1 do begin
      if Integer(EdgesLst[I]) = ToVertex then begin
        Found := True;
        break;
      end;
    end;
    if not Found then
      EdgesLst.Add(Pointer(ToVertex));
  end;

  function IsInnerVertex: Boolean;
  var
    I: Integer;
  begin
    Result := Edges.Count = Neighbours.Count;
    if Result then begin
      for I := 0 to Edges.Count -1 do begin
        if TList(Edges.Objects[I]).Count <> 2 then begin
          Result := False;
          break;
        end;
      end;
    end;
  end;

  function CreateRemoveVertexList: TStringList;
  var
    I, J: Integer;
    SortedVertices: TList;

    procedure AddKey(const Vertex, RemoveListIdx: Integer);
    var
      I, Idx: Integer;
      Key: String;
      RemoveLst: TList;
      Found: Boolean;
    begin
      Key := IntToStr(Vertex);
      Idx := Result.IndexOf(Key);
      if Idx < 0 then begin
        RemoveLst := TList.Create;
        Result.AddObject(Key, RemoveLst);
      end
      else
        RemoveLst := TList(Result.Objects[Idx]);
      Found := False;
      for I := 0 to RemoveLst.Count - 1 do begin
        if Integer(RemoveLst[I])=RemoveListIdx then begin
          Found := True;
          break;
        end;
      end;
      if not Found then
        RemoveLst.Add(Pointer(RemoveListIdx));
    end;

  begin
    Result := TStringList.Create;
    try
      Result.Duplicates := dupIgnore;
      Result.Sorted := True;
      for I := 0 to RemoveList.Count - 1 do begin
        SortedVertices := TList(RemoveList.Objects[I]);
        for J := 0 to SortedVertices.Count - 1 do begin
          AddKey(Integer(SortedVertices[J]), I);
        end;
      end;
    except
      for I := 0 to Result.Count - 1 do
        TList(Result.Objects[I]).Free;
      Result.Free;
    end;
  end;

begin
  OutputDebugString(PChar('Compress '+IntToStr(VerticesToRemove.Count)+' of '+IntToStr(FVertices.Count)));
  RemoveList := TStringList.Create;
  try
    Edges := TStringList.Create;
    try
      Edges.Duplicates := dupIgnore;
      Edges.Sorted :=True;

      for I := 0 to VerticesToRemove.Count - 1 do begin
        ClearEdges;
        V := Integer(VerticesToRemove[I]);
        Neighbours := FaceNeighbours.GetNeighbours( V );
        for J := 0 to Neighbours.Count -1 do begin
          GetBorderVertices(GetFace(Integer(Neighbours[J])), V, V1, V2);
          AddEdge(V1, V2);
          AddEdge(V2, V1);
        end;

        if IsInnerVertex then begin
          SortedVertices := TList.Create;
          try
            V0 := StrToInt(Edges[0]);
            PrevPrevV := V0;
            SortedVertices.Add(Pointer(V0));
            PrevV := Integer(TList(Edges.Objects[0])[0]);
            SortedVertices.Add(Pointer(PrevV));
            while(True) do begin
              Idx := Edges.IndexOf(IntToStr(PrevV));
              if Idx < 0 then
                raise Exception.Create('TFacesList.RemoveVertices: Vertex <'+IntToStr(V1)+'> not found');
              NextV := Integer(TList(Edges.Objects[Idx])[0]);
              if NextV = PrevPrevV then
                NextV := Integer(TList(Edges.Objects[Idx])[1]);
              if NextV = V0 then
                break;
              SortedVertices.Add(Pointer(NextV));
              PrevPrevV := PrevV;
              PrevV := NextV;
            end;
          except
            SortedVertices.Free;
            raise;
          end;
          if (SortedVertices.Count >= 4) and (SortedVertices.Count <= 6) then
            RemoveList.AddObject(IntToStr(V), SortedVertices)
          else
            SortedVertices.Free;
        end;
      end;
    finally
      ClearEdges;
      Edges.Free;
    end;

    if RemoveList.Count > 0 then begin
      InvalidRemoveLists := TStringList.Create;
      try
        InvalidRemoveLists.Duplicates := dupIgnore;
        InvalidRemoveLists.Sorted := True;
        RemoveVertexList := CreateRemoveVertexList;
        try
          for I := 0 to RemoveVertexList.Count - 1 do begin
            RList := TList(RemoveVertexList.Objects[I]);
            if RList.Count > 1 then begin
              MaxVCount := -1;
              MaxIdx := -1;
              for J := 0 to RList.Count - 1 do begin
                VCount :=  TList( RemoveList.Objects[Integer(RList[J])]).Count;
                if VCount > MaxVCount then begin
                  MaxVCount := VCount;
                  MaxIdx := J;
                end;
              end;
              for J := 0 to RList.Count - 1 do begin
                if J <> MaxIdx then begin
                  InvalidRemoveLists.Add(IntToStr( Integer(RList[J]) ));
                end;
              end;
            end;
          end;

        finally
          for I := 0 to RemoveVertexList.Count - 1 do
            TList(RemoveVertexList.Objects[I]).Free;
          RemoveVertexList.Free;
        end;

        for I := 0 to RemoveList.Count - 1 do begin
          if InvalidRemoveLists.IndexOf( IntToStr(I) ) < 1 then begin
            V := StrToInt(RemoveList[I]);
            SortedVertices := TList(RemoveList.Objects[I]);
            Neighbours := FaceNeighbours.GetNeighbours( V );
            for J := 0 to Neighbours.Count -1 do begin
              Face := GetFace(Integer(Neighbours[J]));
              Face^.Vertex1 := -1;
            end;
            FaceIdx := @COMPRESSED_FACES[ SortedVertices.Count - 1 ];
            J:=0;
            while J < LUT_VERTICES_PER_CONFIGURATION_COUNT do begin
              if FaceIdx[J] >= 0 then begin
                V0 := Integer(SortedVertices[FaceIdx[J]]);
                V1 := Integer(SortedVertices[FaceIdx[J + 1]]);
                V2 := Integer(SortedVertices[FaceIdx[J + 2]]);
                AddFace( V0, V2, V1);
              end;
              Inc(J, 3);
            end;
          end;
        end;
      finally
        InvalidRemoveLists.Free;
      end;
      CleanupRemovedFaces;
    end;
  finally
    RemoveList.Free;
  end;
end;

procedure TFacesList.CompressPlanarVertices;
const
  Tolerance: Double = 0.001;
var
  I, J, RefNIdx: Integer;
  Neighbours: TList;
  FaceNormals: TPS4VectorList;
  FaceNeighbours: TFaceNeighboursList;
  RefN, N: TPS4Vector;
  CompressVertex: Boolean;
  CosA, Area, MaxArea: Double;
  CompressList: TList;
begin
  CompressList := TList.Create;
  try
    FaceNeighbours := TFaceNeighboursList.Create(Self);
    try
      FaceNormals := CalculateFaceNormals;
      try
        for I := 0 to FVertices.Count - 1 do begin
          Neighbours := FaceNeighbours.GetNeighbours( I );
          if (Neighbours <> nil) and (Neighbours.Count > 2) then begin
            // Chose face with the largest area as reference
            MaxArea := -1.0;
            RefNIdx := -1;
            for J := 1 to Neighbours.Count -1  do begin
              Area := FaceNormals.GetVector(Integer(Neighbours[J])).W;
              if Area > MaxArea then begin
                MaxArea := Area;
                RefNIdx := J;
              end;
            end;
            // compare all normals of the neighbours against reference
            RefN := FaceNormals.GetVector(Integer(Neighbours[RefNIdx]));
            CompressVertex := True;
            for J := 0 to Neighbours.Count -1  do begin
              if J <> RefNIdx then begin
                N := FaceNormals.GetVector(Integer(Neighbours[J]));
                CosA := TSVectorMath.DotProduct(TPS3Vector(RefN), TPS3Vector(N));
                if Abs(1.0 - Abs(CosA)) > Tolerance then begin
                  CompressVertex := False;
                  break;
                end;
              end;
            end;
            // if all normals point into the same direction the vertex may be compressed
            if CompressVertex then begin
              CompressList.Add(Pointer(I));
            end;
          end;
        end;
      finally
        FaceNormals.Free;
      end;
      RemoveVertices(CompressList, FaceNeighbours);
    finally
      FaceNeighbours.Free;
    end;
  finally
    CompressList.Free;
  end;
end;

procedure TFacesList.CompressFaces(const Passes: Integer);
var
  T0: Int64;
  I, OldCount:Integer;
begin
  OldCount := FFaces.Count;
  T0 := DateUtils.MilliSecondsBetween(Now, 0);
  for I := 0 to Passes - 1  do begin
    CompressPlanarVertices;
  end;
  ShowDebugInfo('CompressFaces ('+IntToStr(OldCount)+'->'+IntToStr(FFaces.Count)+')', T0);
end;

procedure TFacesList.DoCenter(const MaxSize: Double);
begin
  FVertices.DoCenter(MaxSize);
end;

procedure TFacesList.DoScale(const ScaleX, ScaleY, ScaleZ: Double);
begin
  FVertices.DoScale(ScaleX, ScaleY, ScaleZ);
end;

procedure TFacesList.LaplaceSmooth(const NeighboursList: TVertexNeighboursList; const Strength: Double);
var
  I, J: Integer;
  Displacements: TList;
  D: TPD3Vector;
  Weight: Double;
  Neighbours: TList;
  V, VN: TPS3Vector;
begin
  Displacements := TList.Create;
  try
    // Calc displacements
    for I := 0 to FVertices.Count - 1 do begin
      GetMem(D, SizeOf(TD3Vector));
      D^.X := 0.0;
      D^.Y := 0.0;
      D^.Z := 0.0;
      Displacements.Add(D);

      Neighbours := NeighboursList.GetNeighbours( I );
      if (Neighbours <> nil) and (Neighbours.Count > 1) then begin
        Weight := 1.0 / Neighbours.Count;
        V := FVertices.GetVertex( I );
	      for J:=0 to Neighbours.Count - 1 do begin
          VN := FVertices.GetVertex( Integer(Neighbours[J]) );
          D^.X := D^.X + (VN.X - V.X)* Weight;
          D^.Y := D^.Y + (VN.Y - V.Y)* Weight;
          D^.Z := D^.Z + (VN.Z - V.Z)* Weight;
    		end;
      end;
    end;
    // Apply displacements
    for I := 0 to FVertices.Count - 1 do begin
      V := FVertices.GetVertex( I );
      D := Displacements[I];
      V^.X := V^.X + D^.X * Strength;
      V^.Y := V^.Y + D^.Y * Strength;
      V^.Z := V^.Z + D^.Z * Strength;
    end;
  finally
    for I := 0 to Displacements.Count -1  do begin
      if Displacements[I] <> nil then
        FreeMem(Displacements[I]);
    end;
    Displacements.Free;
  end;
end;

function TFacesList.CalculateVertexNormals: TPS3VectorList;
var
  T0: Int64;
  I: Integer;
  A, B, C: TS3Vector;
  V1, V2, V3: TPS3Vector;
  Face: TPFace;
begin
  T0 := DateUtils.MilliSecondsBetween(Now, 0);
  Result := TPS3VectorList.Create;
  try
    for I := 0 to FVertices.Count -1 do begin
      Result.AddVertex(0.0, 0.0, 0.0);
    end;
    for I := 0 to FFaces.Count - 1 do begin
      Face := FFaces[I];
      V1 := FVertices.GetVertex(Face^.Vertex1);
      V2 := FVertices.GetVertex(Face^.Vertex2);
      V3 := FVertices.GetVertex(Face^.Vertex3);
      TSVectorMath.Subtract(V2, V1, @A);
      TSVectorMath.Subtract(V3, V1, @B);
      TSVectorMath.CrossProduct(@A, @B, @C);
      TSVectorMath.AddTo(Result.GetVertex(Face^.Vertex1), @C);
      TSVectorMath.AddTo(Result.GetVertex(Face^.Vertex2), @C);
      TSVectorMath.AddTo(Result.GetVertex(Face^.Vertex3), @C);
    end;
    for I := 0 to FVertices.Count -1 do begin
      TSVectorMath.Normalize(Result.GetVertex(I));
    end;
  except
    Result.Free;
    raise;
  end;
  ShowDebugInfo('CalculateVertexNormals', T0);
end;

function TFacesList.CalculateFaceNormals: TPS4VectorList;
const
  EPS = 1e-50;
var
  T0: Int64;
  I: Integer;
  A, B, C: TS3Vector;
  V1, V2, V3: TPS3Vector;
  Face: TPFace;
  Area: Double;
begin
  T0 := DateUtils.MilliSecondsBetween(Now, 0);
  Result := TPS4VectorList.Create;
  try
    for I := 0 to FFaces.Count - 1 do begin
      Face := FFaces[I];
      V1 := FVertices.GetVertex(Face^.Vertex1);
      V2 := FVertices.GetVertex(Face^.Vertex2);
      V3 := FVertices.GetVertex(Face^.Vertex3);
      TSVectorMath.Subtract(V2, V1, @A);
      TSVectorMath.Subtract(V3, V1, @B);
      TSVectorMath.CrossProduct(@A, @B, @C);
      Area := TSVectorMath.Length(@C);
      TSVectorMath.ScalarMul(1.0/Area+EPS, @C, @C);
      // TVectorMath.SVNormalize(@C);
      Result.AddVector(C.X, C.Y, C.Z, Area);
    end;
  except
    Result.Free;
    raise;
  end;
  ShowDebugInfo('CalculateFaceNormals', T0);
end;

procedure TFacesList.CleanupRemovedFaces;
var
  T0: Int64;
  I: Integer;
  OldFaces: TList;
  Face: TPFace;
begin
  T0 := DateUtils.MilliSecondsBetween(Now, 0);
  OldFaces := FFaces;
  FFaces := TList.Create;
  try
    for I := 0 to OldFaces.Count -1 do begin
      Face := OldFaces[I];
      if (Face^.Vertex1 >= 0) and (Face^.Vertex2 >= 0) and (Face^.Vertex3 >= 0) then begin
        OldFaces[I] := nil;
        FFaces.Add(Face);
      end;
    end;
  finally
    for I := 0 to OldFaces.Count - 1 do begin
      Face := OldFaces[I];
      if Face <> nil then begin
        OldFaces[I] := nil;
        FreeMem(Face);
      end;
    end;
    OldFaces.Clear;
    OldFaces.Free;
  end;
  ShowDebugInfo('CleanupRemovedFaces', T0);
end;

type
  TMergeFacesThread = class(TThread)
  private
    FDest, FSrc: TFacesList;
    FDone: boolean;
    FSync: TCriticalSection;
  public
    constructor Create( const Dest, Src: TFacesList; const Sync: TCriticalSection );
  protected
    procedure Execute; override;
    function IsDone: boolean;
  end;

constructor TMergeFacesThread.Create( const Dest, Src: TFacesList; const Sync: TCriticalSection );
begin
  inherited Create(true);
  FDest := Dest;
  FSrc := Src;
  FSync := Sync;
end;

procedure TMergeFacesThread.Execute;
begin
  FDone := false;
  try
    FDest.MoveFaces(FSrc, FSync);
    FSrc.Clear;
  finally
    FDone := true;
  end;
end;

function TMergeFacesThread.IsDone: boolean;
begin
  Result := FDone;
end;

class function TFacesList.MergeFacesLists(const FacesListsToMerge: TList; const MultiThreaded: boolean = false): TFacesList;
var
  T0: Int64;
  I: Integer;
  IsDone: boolean;
  FacesList: TFacesList;
  Sync: TCriticalSection;
  CurrThread: TMergeFacesThread;
  Threads: TObjectList;
begin
  T0 := DateUtils.MilliSecondsBetween(Now, 0);
  Result := TFacesList.Create;
  try
    if MultiThreaded then begin
      Sync:=TCriticalSection.Create;
      try
        Threads := TObjectList.Create;
        try
          for I := 0 to FacesListsToMerge.Count - 1 do begin
            FacesList := FacesListsToMerge[I];
            CurrThread := TMergeFacesThread.Create( Result, FacesList, Sync );
            Threads.Add( CurrThread );
            CurrThread.Start;
          end;

          IsDone := false;
          while( not IsDone ) do begin
            IsDone := true;
            for I := 0 to Threads.Count - 1 do begin
              if( not TMergeFacesThread(Threads[I]).IsDone ) then begin
                IsDone := false;
                break;
              end;
              Sleep(10);
            end;
          end;
        finally
          Threads.Free;
        end;
      finally
        Sync.Free;
      end;
    end
    else begin
      for I := 0 to FacesListsToMerge.Count - 1 do begin
        FacesList := FacesListsToMerge[I];
        Result.MoveFaces(FacesList);
        FacesList.Clear;
      end;
    end;
    ShowDebugInfo('MergeFaces', T0);
  except
    Result.Free;
    raise;
  end;
end;
{ ------------------------------ TNeighboursList ----------------------------- }
constructor TNeighboursList.Create(const Faces: TFacesList);
begin
  inherited Create;
  FVertices := CreateNeighboursList(Faces);
end;

destructor TNeighboursList.Destroy;
var
  I: Integer;
begin
  if FVertices<>nil then begin
    for I := 0 to FVertices.Count - 1 do begin
      if FVertices[I] <> nil then
        TList(FVertices[I]).Free;
    end;
    FVertices.Clear;
    FVertices.Free;
  end;
  inherited Destroy;
end;

function TNeighboursList.GetNeighbours(const Idx: Integer): TList;
var
  N: TList;
begin
  Result := nil;
  if (Idx >= 0) and (Idx < FVertices.Count) then begin
    N := FVertices[Idx];
    if (N<>nil) and (N.Count > 0) then
      Result := N;
  end;
end;

procedure TNeighboursList.SaveToFile(const Filename: String);
var
  I, J: Integer;
  S: String;
  NList: TList;
  Lst: TStringList;
begin
  Lst := TStringList.Create;
  try
    for I := 0 to FVertices.Count - 1 do begin
      NList := TList(FVertices[I]);
      S:=IntToStr(I)+': ';
      if NList <> nil then begin
        for J:=0 to NList.Count -1 do begin
          S := S + IntToStr(Integer(NList[J]))+' ';
        end;
      end;
      Lst.Add(S);
    end;
    Lst.SaveToFile(Filename);
  finally
    Lst.Free;
  end;
end;

{ ---------------------------- TVertexNeighboursList ------------------------- }
function TVertexNeighboursList.CreateNeighboursList(const Faces: TFacesList): TList;
var
  T0: Int64;
  I: Integer;
  Face: TPFace;

  procedure AddNeighbour(const FromVertex, ToVertex: Integer);
  var
    NList: TList;
    I: Integer;
    Found: Boolean;
  begin
    while Result.Count <= FromVertex do begin
      Result.Add(TList.Create);
    end;
    NList := TList( Result[FromVertex] );
    Found := False;
    for I := 0 to NList.Count - 1 do begin
      if Integer(NList[I]) = ToVertex then begin
        Found := True;
        break;
      end;
    end;
    if not Found then begin
      NList.Add(Pointer(ToVertex))
    end;
  end;

begin
  T0 := DateUtils.MilliSecondsBetween(Now, 0);
  Result := TList.Create;
  try
    for I := 0 to Faces.Count - 1 do begin
      Face := Faces.GetFace(I);
      AddNeighbour(Face^.Vertex1, Face^.Vertex2);
      AddNeighbour(Face^.Vertex1, Face^.Vertex3);
      AddNeighbour(Face^.Vertex2, Face^.Vertex1);
      AddNeighbour(Face^.Vertex2, Face^.Vertex3);
      AddNeighbour(Face^.Vertex3, Face^.Vertex1);
      AddNeighbour(Face^.Vertex3, Face^.Vertex2);
    end;
  except
    try
      for I := 0 to Result.Count - 1 do begin
        if Result[I] <> nil then
          TList(Result[I]).Free;
      end;
    except
      // Hide this error
    end;
    Result.Free;
    raise;
  end;
  ShowDebugInfo('CreateVertexNeighboursList', T0);
end;
{ ----------------------------- TFaceNeighboursList -------------------------- }
function TFaceNeighboursList.CreateNeighboursList(const Faces: TFacesList): TList;
var
  T0: Int64;
  I: Integer;
  Face: TPFace;

  procedure AddNeighbour(const FromVertex, ToFace: Integer);
  var
    NList: TList;
    I: Integer;
    Found: Boolean;
  begin
    while Result.Count <= FromVertex do begin
      Result.Add(TList.Create);
    end;
    NList := TList( Result[FromVertex] );
    Found := False;
    for I := 0 to NList.Count - 1 do begin
      if Integer(NList[I]) = ToFace then begin
        Found := True;
        break;
      end;
    end;
    if not Found then begin
      NList.Add(Pointer(ToFace))
    end;
  end;

begin
  T0 := DateUtils.MilliSecondsBetween(Now, 0);
  Result := TList.Create;
  try
    for I := 0 to Faces.Count - 1 do begin
      Face := Faces.GetFace(I);
      AddNeighbour(Face^.Vertex1, I);
      AddNeighbour(Face^.Vertex2, I);
      AddNeighbour(Face^.Vertex3, I);
    end;
  except
    try
      for I := 0 to Result.Count - 1 do begin
        if Result[I] <> nil then
          TList(Result[I]).Free;
      end;
    except
      // Hide this error
    end;
    Result.Free;
    raise;
  end;
  ShowDebugInfo('CreateFaceNeighboursList', T0);
end;

end.


