{ ---------------------------------------------------------------------------- }
{ BulbTracer for MB3D                                                          }
{ Copyright (C) 2016-2017 Andreas Maschke                                      }
{ ---------------------------------------------------------------------------- }
unit BulbTracerConfig;

interface

uses
  SysUtils, Classes, Generics.Collections, VertexList;

type
  TOversampling = (osNone, os2x2x2, os3x3x3);

  TDoubleWrapper = class
  private
    FValue: Double;
  public
    constructor Create( const PValue: Double );
    property Value: Double read FValue;
  end;

  TXYZWrapper = class
  private
    FX, FY, FZ: Double;
  public
    constructor Create( const PX, PY, PZ: Double );
    property X: Double read FX;
    property Y: Double read FY;
    property Z: Double read FZ;
  end;

  TRange = class
  private
    FRangeMin, FRangeMax: Double;
    FStepCount: Integer;
    function CalcStepSize: Double;
    procedure ValidateThreadId(const ThreadId, ThreadCount: Integer);
  public
    constructor Create;
    function CalcStepCount(const ThreadId, ThreadCount: Integer): Integer;
    function CalcRangeMin(const ThreadId, ThreadCount: Integer): Double;
    function CalcRangeMinIndex(const ThreadId, ThreadCount: Integer): Integer;
    property RangeMin: Double read FRangeMin write FRangeMin;
    property RangeMax: Double read FRangeMax write FRangeMax;
    property StepCount: Integer read FStepCount write FStepCount;
    property StepSize: Double read CalcStepSize;
  end;

  TMeshType = (mtMesh, mtPointCloud);

  TTraceRangeMode = (trInclude, trExclude);

  TTraceRange = class
  protected
    FMode: TTraceRangeMode;
    FIndicatorColorR, FIndicatorColorG, FIndicatorColorB: Double;
  public
    constructor Create;
    function Evaluate( const X, Y, Z: Double ): Boolean; virtual; abstract;
    procedure AddIndicatorSamples( VertexList: TPS3VectorList; NormalsList, ColorList: TPSMI3VectorList ); virtual; abstract;
    property Mode: TTraceRangeMode read FMode write FMode;
    property IndicatorColorR: Double read FIndicatorColorR write FIndicatorColorR;
    property IndicatorColorG: Double read FIndicatorColorG write FIndicatorColorG;
    property IndicatorColorB: Double read FIndicatorColorB write FIndicatorColorB;
  end;

  TSphereRange = class ( TTraceRange )
  private
    FCentreX, FCentreY, FCentreZ: Double;
    FRadius, FRadiusSquared: Double;
    procedure SetRadius( const Radius: Double );
  public
    constructor Create;
    function Evaluate( const X, Y, Z: Double ): Boolean; override;
    procedure AddIndicatorSamples( VertexList: TPS3VectorList; NormalsList, ColorList: TPSMI3VectorList ); override;
    property CentreX: Double read FCentreX write FCentreX;
    property CentreY: Double read FCentreY write FCentreY;
    property CentreZ: Double read FCentreZ write FCentreZ;
    property Radius: Double read FRadius write SetRadius;
  end;

  TBoxRange = class ( TTraceRange )
  private
    FCentreX, FCentreY, FCentreZ: Double;
    FSizeX, FSizeY, FSizeZ: Double;
    FMinX, FMaxX, FMinY, FMaxY, FMinZ, FMaxZ: Double;
    procedure SetSizeX( const SizeX: Double );
    procedure SetSizeY( const SizeY: Double );
    procedure SetSizeZ( const SizeZ: Double );
  public
    constructor Create;
    function Evaluate( const X, Y, Z: Double ): Boolean; override;
    procedure AddIndicatorSamples( VertexList: TPS3VectorList; NormalsList, ColorList: TPSMI3VectorList ); override;
    property CentreX: Double read FCentreX write FCentreX;
    property CentreY: Double read FCentreY write FCentreY;
    property CentreZ: Double read FCentreZ write FCentreZ;
    property SizeX: Double read FSizeX write SetSizeX;
    property SizeY: Double read FSizeY write SetSizeY;
    property SizeZ: Double read FSizeZ write SetSizeZ;
  end;

  TVertexGenConfig = class
  private
    FURange: TRange;
    FVRange: TRange;
    FCalcNormals: Boolean;
    FRemoveDuplicates: Boolean;
    FSphericalScan: Boolean;
    FCalcColors: Boolean;
    FMeshType: TMeshType;
    FOversampling: TOversampling;
    FISOValue: Double;
    FSharedWorkList: TList;
    FTraceRanges: TList;
    FSampleJitter: Double;
    FShowTraceRanges: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure AddSampledTraceRanges( VertexList: TPS3VectorList; NormalsList, ColorList: TPSMI3VectorList );
    property URange: TRange read FURange;
    property VRange: TRange read FVRange;
    property CalcNormals: Boolean read FCalcNormals write FCalcNormals;
    property RemoveDuplicates: Boolean read FRemoveDuplicates write FRemoveDuplicates;
    property MeshType: TMeshType read FMeshType write FMeshType;
    property Oversampling: TOversampling read FOversampling write FOversampling;
    property ISOValue: Double read FISOValue write FISOValue;
    property SharedWorkList: TList read FSharedWorkList write FSharedWorkList;
    property SphericalScan: Boolean read FSphericalScan write FSphericalScan;
    property CalcColors: Boolean read FCalcColors write FCalcColors;
    property ShowTraceRanges: Boolean read FShowTraceRanges write FShowTraceRanges;
    property TraceRanges: TList read FTraceRanges;
    property SampleJitter: Double read FSampleJitter write FSampleJitter;
  end;

implementation

uses Contnrs, System.Math;

{ --------------------------------- TRange ----------------------------------- }
constructor TRange.Create;
begin
  inherited Create;
  FRangeMin := 0.0;
  FRangeMax := 1.0;
  FStepCount := 32;
end;

function TRange.CalcStepSize: Double;
begin
  Result := (FRangeMax - FRangeMin) / (FStepCount - 1);
end;

procedure TRange.ValidateThreadId(const ThreadId, ThreadCount: Integer);
begin
  if ThreadCount < 1 then
    raise Exception.Create('Invaid ThreadCount <'+IntToStr(ThreadCount)+'>');
  // ThreadId starts with 1
  if (ThreadId < 1) or (ThreadId > ThreadCount) then
    raise Exception.Create('Invalid ThreadId <'+IntToStr(ThreadId)+'>');
end;

// ThreadId, unfortunately, starts with 1!
function TRange.CalcStepCount(const ThreadId, ThreadCount: Integer): Integer;
var
  d, m: Integer;
begin
  ValidateThreadId(ThreadId, ThreadCount);
  if ThreadCount > 1 then begin
    d := FStepCount div ThreadCount;
    if ( FStepCount mod ThreadCount ) <> 0 then
      Inc( d );
    if ThreadId < ThreadCount then
      Result := d
    else
      Result := FStepCount - d * ( ThreadCount - 1 );
  end
  else
    Result := FStepCount;
end;

function TRange.CalcRangeMin(const ThreadId, ThreadCount: Integer): Double;
var
  I, Steps: Integer;
begin
  ValidateThreadId(ThreadId, ThreadCount);
  if (ThreadId > 1) and (ThreadCount > 1) then begin
    Steps := 0;
    for I := 1 to ThreadId - 1 do
      Inc(Steps, CalcStepCount(I, ThreadCount) );
    Result := FRangeMin + Steps * CalcStepSize;
  end
  else
    Result := FRangeMin;
end;

function TRange.CalcRangeMinIndex(const ThreadId, ThreadCount: Integer): Integer;
var
  I, Steps: Integer;
begin
  ValidateThreadId(ThreadId, ThreadCount);
  if (ThreadId > 1) and (ThreadCount > 1) then begin
    Steps := 0;
    for I := 1 to ThreadId - 1 do
      Inc(Steps, CalcStepCount(I, ThreadCount) );
    Result := Steps;
  end
  else
    Result := 0;
end;
{ ----------------------------- TVertexGenConfig ----------------------------- }
constructor TVertexGenConfig.Create;
begin
  inherited Create;
  FURange := TRange.Create;
  FVRange := TRange.Create;
  FTraceRanges := TObjectList.Create;

  CalcNormals := False;
  RemoveDuplicates := True;
  MeshType := mtPointCloud;
end;

destructor TVertexGenConfig.Destroy;
begin
  FURange.Free;
  FVRange.Free;
  FTraceRanges.Free;
  inherited Destroy;
end;

procedure TVertexGenConfig.Clear;
begin
  FTraceRanges.Clear;
end;

procedure TVertexGenConfig.AddSampledTraceRanges( VertexList: TPS3VectorList; NormalsList, ColorList: TPSMI3VectorList );
var
  I: Integer;
  Range: TTraceRange;
begin
  for I := 0 to FTraceRanges.Count - 1 do begin
    Range := FTraceRanges[ I ];
    Range.AddIndicatorSamples( VertexList, NormalsList, ColorList );
  end;
end;
{ ------------------------------- TTraceRange -------------------------------- }
constructor TTraceRange.Create;
begin
  inherited;
  FMode := trExclude;
  FIndicatorColorR := 0.86;
  FIndicatorColorG := 0.45;
  FIndicatorColorB := 0.12;
end;

{ ------------------------------ TSphereRange -------------------------------- }
constructor TSphereRange.Create;
begin
  inherited;
  Radius := 100.0;
end;

procedure TSphereRange.SetRadius( const Radius: Double );
begin
  FRadius := Radius;
  FRadiusSquared := Sqr( FRadius );
end;

function TSphereRange.Evaluate( const X, Y, Z: Double ): Boolean;
begin
  case Mode of
    trInclude: Result := Sqr( X - CentreX ) + Sqr( Y - CentreY ) + Sqr( Z - CentreZ ) > FRadiusSquared;
    trExclude: Result := Sqr( X - CentreX ) + Sqr( Y - CentreY ) + Sqr( Z - CentreZ ) <= FRadiusSquared;
  end;
end;

procedure TSphereRange.AddIndicatorSamples( VertexList: TPS3VectorList; NormalsList, ColorList: TPSMI3VectorList );
const
  Slices100 = 300;
var
  I, J, Slices: Integer;
  Theta, DTheta, SinTheta, CosTheta: Double;
  Phi, DPhi, SinPhi, CosPhi: Double;
  X, Y, Z: Double;
begin
  Slices := Round( Radius * Slices100 / 100.0 );

  DTheta := DegToRad(360.0) / (Slices);
  DPhi := DegToRad(360.0) / (Slices);

  for I := 0 to Slices - 1 do begin
    SinCos(Theta, SinTheta, CosTheta);
    Phi := 0.0;
    for J := 0 to Slices - 1 do begin
      SinCos(Phi, SinPhi, CosPhi);

      X := - SinTheta * CosPhi * Radius + CentreX;
      Y := - SinTheta * SinPhi * Radius + CentreY;
      Z :=   CosTheta * Radius + CentreZ;

      VertexList.AddVertex( X, Y, Z );
      if NormalsList <> nil then
        NormalsList.AddVertex( 0.0, 0.0, 0.0 );
      if ColorList <> nil then
        ColorList.AddVertex( IndicatorColorR, IndicatorColorG, IndicatorColorB );

      Phi := Phi + DPhi;
    end;
    Theta := Theta + DTheta;
  end;
end;
{ --------------------------------- TBoxRange -------------------------------- }
constructor TBoxRange.Create;
begin
  inherited;
  SizeX := 100.0;
  SizeY := 100.0;
  SizeZ := 50.0;
end;

procedure TBoxRange.SetSizeX( const SizeX: Double );
begin
  FSizeX := SizeX;
  FMinX := CentreX - FSizeX / 2.0;
  FMaxX := CentreX + FSizeX / 2.0;
end;

procedure TBoxRange.SetSizeY( const SizeY: Double );
begin
  FSizeY := SizeY;
  FMinY := CentreY - FSizeY / 2.0;
  FMaxY := CentreY + FSizeY / 2.0;
end;

procedure TBoxRange.SetSizeZ( const SizeZ: Double );
begin
  FSizeZ := SizeZ;
  FMinZ := CentreZ - FSizeZ / 2.0;
  FMaxZ := CentreZ + FSizeZ / 2.0;
end;

function TBoxRange.Evaluate( const X, Y, Z: Double ): Boolean;
begin
  case Mode of
    trInclude: Result := ( X < FMinX ) or ( X > FMaxX) or (  Y < FMinY ) or ( Y > FMaxY ) or ( Z < FMinZ ) or ( Z > FMaxZ );
    trExclude: Result := ( X >= FMinX ) and ( X <= FMaxX) and (  Y >= FMinY ) and ( Y <= FMaxY ) and ( Z >= FMinZ ) and ( Z <= FMaxZ );
  end;
end;

procedure TBoxRange.AddIndicatorSamples( VertexList: TPS3VectorList; NormalsList, ColorList: TPSMI3VectorList );
const
  Slices100 = 80;
var
  X, Y, Z, DX, DY, DZ, Radius: Double;
  I, J, Slices: Integer;
begin
  Radius := Sqrt( Sqr( FSizeX ) + Sqr( FSizeY ) + Sqr( FSizeZ ) );
  Slices := Round( Radius * Slices100 / 100.0 );

  DX := FSizeX / Slices;
  DY := FSizeY / Slices;
  DZ := FSizeZ / Slices;

  X := FMinX;
  for I := 0 to Slices - 1 do begin
    Y := FMinY;
    for J := 0 to Slices - 1 do begin

      VertexList.AddVertex( X, Y, FMinZ );
      if ColorList <> nil then
        ColorList.AddVertex( IndicatorColorR, IndicatorColorG, IndicatorColorB );

      VertexList.AddVertex( X, Y, FMaxZ );
      if ColorList <> nil then
        ColorList.AddVertex( IndicatorColorR, IndicatorColorG, IndicatorColorB );
      if NormalsList <> nil then
        NormalsList.AddVertex( 0.0, 0.0, 0.0 );

      Y := Y + DY;
    end;
    X := X + DX;
  end;


  Y := FMinY;
  for I := 0 to Slices - 1 do begin
    Z := FMinZ;
    for J := 0 to Slices - 1 do begin

      VertexList.AddVertex( FMinX, Y, Z );
      if ColorList <> nil then
        ColorList.AddVertex( IndicatorColorR, IndicatorColorG, IndicatorColorB );

      VertexList.AddVertex( FMaxX, Y, Z );
      if ColorList <> nil then
        ColorList.AddVertex( IndicatorColorR, IndicatorColorG, IndicatorColorB );
      if NormalsList <> nil then
        NormalsList.AddVertex( 0.0, 0.0, 0.0 );

      Z := Z + DZ;
    end;
    Y := Y + DY;
  end;

  Z := FMinZ;
  for I := 0 to Slices - 1 do begin
    X := FMinX;
    for J := 0 to Slices - 1 do begin

      VertexList.AddVertex( X, FMinY, Z );
      if ColorList <> nil then
        ColorList.AddVertex( IndicatorColorR, IndicatorColorG, IndicatorColorB );

      VertexList.AddVertex( X, FMaxY, Z );
      if ColorList <> nil then
        ColorList.AddVertex( IndicatorColorR, IndicatorColorG, IndicatorColorB );
      if NormalsList <> nil then
        NormalsList.AddVertex( 0.0, 0.0, 0.0 );

      X := X + DX;
    end;
    Z := Z + DZ;
  end;

end;
{ ------------------------------ TDoubleWrapper ------------------------------ }
constructor TDoubleWrapper.Create( const PValue: Double );
begin
  inherited Create;
  FValue := PValue;
end;

{ --------------------------------- TXYZWrapper ------------------------------ }
constructor TXYZWrapper.Create( const PX, PY, PZ: Double );
begin
  inherited Create;
  FX := PX;
  FY := PY;
  FZ := PZ;
end;

end.

