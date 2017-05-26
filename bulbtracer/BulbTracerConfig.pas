{ ---------------------------------------------------------------------------- }
{ BulbTracer for MB3D                                                          }
{ Copyright (C) 2016-2017 Andreas Maschke                                      }
{ ---------------------------------------------------------------------------- }
unit BulbTracerConfig;

interface

uses
  SysUtils, Classes;

type
  TOversampling = (osNone, os2x2x2, os3x3x3);

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
    property RangeMin: Double read FRangeMin write FRangeMin;
    property RangeMax: Double read FRangeMax write FRangeMax;
    property StepCount: Integer read FStepCount write FStepCount;
    property StepSize: Double read CalcStepSize;
  end;

  TMeshType = (mtMesh, mtPointCloud);

  TVertexGenConfig = class
  private
    FURange: TRange;
    FVRange: TRange;
    FCalculateNormals: Boolean;
    FRemoveDuplicates: Boolean;
    FMeshType: TMeshType;
    FOversampling: TOversampling;
    FISOValue: Double;
  public
    constructor Create;
    destructor Destroy; override;
    property URange: TRange read FURange;
    property VRange: TRange read FVRange;
    property CalculateNormals: Boolean read FCalculateNormals write FCalculateNormals;
    property RemoveDuplicates: Boolean read FRemoveDuplicates write FRemoveDuplicates;
    property MeshType: TMeshType read FMeshType write FMeshType;
    property Oversampling: TOversampling read FOversampling write FOversampling;
    property ISOValue: Double read FISOValue write FISOValue;
  end;

implementation

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

function TRange.CalcStepCount(const ThreadId, ThreadCount: Integer): Integer;
var
  d, m: Integer;
begin
  ValidateThreadId(ThreadId, ThreadCount);
  if ThreadCount > 1 then begin
    d := FStepCount div ThreadCount;
    m := FStepCount mod ThreadCount;
    if m <> 0 then
      Inc(d);
    if (m = 0) or (ThreadId <= m) then
      Result := d
    else
      Result := d - 1;
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
{ ----------------------------- TVertexGenConfig ----------------------------- }
constructor TVertexGenConfig.Create;
begin
  inherited Create;
  FURange := TRange.Create;
  FVRange := TRange.Create;
  CalculateNormals := True;
  RemoveDuplicates := True;
  MeshType := mtPointCloud;
end;

destructor TVertexGenConfig.Destroy;
begin
  FURange.Free;
  FVRange.Free;
  inherited Destroy;
end;

end.
