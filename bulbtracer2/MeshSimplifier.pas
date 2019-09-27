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
unit MeshSimplifier;

interface

uses
  SysUtils, Classes, Contnrs, VectorMath, SyncObjs, Generics.Collections,
  VertexList;

type
  TVector3 = packed record
    X, Y, Z: Single
  end;
  TPVector3 = ^TVector3;

  TSymmetricMatrix = packed record
    M: Array[0..9] of Single;
  end;
  TPSymmetricMatrix = ^TSymmetricMatrix;

  TTriangle = packed record
    V: Array [0..2] of Integer;
    Err: Array [0..3] of Single;
    Deleted, Dirty: Boolean;
    N: TVector3;
  end;
  TPTriangle = ^TTriangle;

  TVertex = packed record
    P: TVector3;
    TStart, TCount: Integer;
    Q: TSymmetricMatrix;
    Border: Boolean;
  end;
  TPVertex = ^TVertex;

	TRef = packed record
    TId, TVertex: Integer;
  end;
  TPRef = ^TRef;

  TMeshSimplifier = class
  private
    FFaces: TFacesList;
    FTriangles: TList;
    FVertices: TList;
    FRefs: TList;
    procedure Clear;
    procedure ClearRefs;
    procedure MatrixInit( M: TPSymmetricMatrix; const C: Single ); overload;
    procedure MatrixInit( M: TPSymmetricMatrix; const A, B, C, D: Single ); overload;
    procedure MatrixAdd( Dest: TPSymmetricMatrix; const A, B: TPSymmetricMatrix );
    function MatrixDet(	const M: TPSymmetricMatrix; const A11, A12, A13, A21, A22, A23, A31, A32, A33: Integer): Single;
    procedure VecCross( Dest: TPVector3; const A, B: TPVector3 );
    procedure VecNormalize( Dest: TPVector3 );
    procedure VecSub( Dest: TPVector3; const A, B: TPVector3 );
    function VecDot( const A, B: TPVector3 ): Single;
    function VertexError(const Q: TPSymmetricMatrix; const X, Y, Z: Single): Single;
    function CalculateError( const Id_V1, Id_V2: Integer; const PResult: TPVector3 ): Single;
    function Flipped( const P: TPVector3; const I0, I1: Integer; const V0, V1: TPVertex; var Deleted: Array of Boolean ): Boolean;


    procedure MeshToTriangles;
    procedure TrianglesToMesh;
    procedure UpdateTriangles( const I0: Integer; const V:TPVertex; var Deleted: Array of Boolean; var DeletedTriangles: Integer);
    procedure UpdateMesh(const Iteration: Integer);

    procedure CompactMesh;
  public
    constructor Create( const Faces: TFacesList );
    destructor Destroy; override;
    procedure SimplifyMeshLossless(const Threshold: Double = 1.0E-4);
    procedure SimplifyMesh(const TargetCount: Integer; const Agressiveness: Double = 7.0 );
  end;


implementation

uses
  Math, Windows;
//  Mesh simplification roughly based on: Mesh Simplification Tutorial
//
// (C) by Sven Forstmann in 2014
//
// License : MIT
// http://opensource.org/licenses/MIT
//
//https://github.com/sp4cerat/Fast-Quadric-Mesh-Simplification

function TMeshSimplifier.VecDot( const A, B: TPVector3 ): Single;
begin
  Result := A^.X * B^.X + A^.Y * B^.Y + A^.Z * B^.Z;
end;

procedure TMeshSimplifier.VecCross( Dest: TPVector3; const A, B: TPVector3 );
begin
	Dest^.X := A^.Y * B^.Z - A^.Z * B^.Y;
	Dest^.Y := A^.Z * B^.X - A^.X * B^.Z;
	Dest^.Z := A^.X * B^.Y - A^.Y * B^.X;
end;

procedure TMeshSimplifier.VecSub( Dest: TPVector3; const A, B: TPVector3 );
begin
	Dest^.X := A^.X - B^.X;
	Dest^.Y := A^.Y - B^.Y;
	Dest^.Z := A^.Z - B^.Z;
end;

procedure TMeshSimplifier.VecNormalize( Dest: TPVector3 );
var
  Square: Single;
begin
	Square := Sqrt( Dest^.X * Dest^.X + Dest^.Y * Dest^.Y + Dest^.Z * Dest^.Z );
  if Square <> 0 then begin
  	Dest^.X := Dest^.X / Square;
	  Dest^.Y := Dest^.Y / Square;
  	Dest^.Z := Dest^.Z / Square;
  end;
end;

// Error between vertex and Quadric
function TMeshSimplifier.VertexError(const Q: TPSymmetricMatrix; const X, Y, Z: Single): Single;
begin
 	Result := Q^.M[ 0 ] * X * X + 2 * Q^.M[ 1 ] * X * Y + 2 * Q^.M[ 2 ] * X * Z +
            2 * Q^.M[ 3 ] * X + Q^.M[ 4 ] * Y * Y + 2 * Q^.M[ 5 ] * Y * Z +
            2 * Q^.M[ 6 ] * Y + Q^.M[ 7 ] * Z * Z + 2 * Q^.M[ 8 ] * Z + Q^.M[ 9 ];
end;

// Error for one edge
function TMeshSimplifier.CalculateError( const Id_V1, Id_V2: Integer; const PResult: TPVector3 ): Single;
var
  Border: Boolean;
  Q: TSymmetricMatrix;
  Error, Det: Single;
  P1, P2: TPVector3;
  Error1, Error2, Error3: Single;
begin
  // compute interpolated vertex
  MatrixAdd( @Q, @(TPVertex( FVertices[ Id_V1 ] )^.Q), @( TPVertex( FVertices[ Id_V2 ] )^.Q ) );
  Border := TPVertex( FVertices[ Id_V1 ] )^.Border and TPVertex( FVertices[ Id_V2 ] )^.Border;
  Error := 0.0;
  Det := MatrixDet( @Q, 0, 1, 2, 1, 4, 5, 2, 5, 7 );
  if  ( Det <> 0 ) and ( not Border ) then begin
    // q_delta is invertible
    PResult^.X := -1.0 / Det *( MatrixDet( @Q, 1, 2, 3, 4, 5, 6, 5, 7 , 8) );	// vx = A41/det(q_delta)
    PResult^.Y :=  1.0 / Det *( MatrixDet( @Q, 0, 2, 3, 1, 5, 6, 2, 7 , 8) );	// vy = A42/det(q_delta)
    PResult^.Z := -1.0 / Det *( MatrixDet( @Q, 0, 1, 3, 1, 4, 6, 2, 5,  8) );	// vz = A43/det(q_delta)

    Error := VertexError( @Q, PResult^.X, PResult^.Y, PResult^.Z );
  end
  else begin
    // det = 0 -> try to find best result
    P1 := @( TPVertex( FVertices[ Id_V1 ] )^.P );
    P2 := @( TPVertex( FVertices[ Id_V2 ] )^.P );
    Error1 := VertexError( @Q, P1^.X, P1^.Y, P1^.Z );
    Error2 := VertexError( @Q, P2^.X, P2^.Y, P2^.Z );
    Error3 := VertexError( @Q, ( P1^.X + P2.X ) / 2.0, ( P1^.Y + P2.Y ) / 2.0, ( P1^.Z + P2.Z ) / 2.0 ); // P3
    Error := Min( Error1, Min( Error2, Error3 ) );
    if Error1 = Error then begin
      PResult^.X := P1^.X;
      PResult^.Y := P1^.Y;
      PResult^.Z := P1^.Z;
    end;
    if Error2 = Error then begin
      PResult^.X := P2^.X;
      PResult^.Y := P2^.Y;
      PResult^.Z := P2^.Z;
    end;
    if Error3 = Error then begin
      PResult^.X := ( P1^.X + P2^.X ) / 2.0;
      PResult^.Y := ( P1^.Y + P2^.Y ) / 2.0;
      PResult^.Z := ( P1^.Z + P2^.Z ) / 2.0;
    end;
  end;
  Result := Error;
end;

constructor TMeshSimplifier.Create( const Faces: TFacesList );
begin
  inherited Create;
  FFaces := Faces;
  FVertices := TList.Create;
  FTriangles := TList.Create;
  FRefs :=  TList.Create;
end;

destructor TMeshSimplifier.Destroy;
begin
  Clear;
  if FTriangles <> nil then
    FTriangles.Free;
  if FVertices <> nil then
    FVertices.Free;
  if FRefs <> nil then
    FRefs.Free;
  inherited Destroy;
end;

procedure TMeshSimplifier.ClearRefs;
var
  I: Integer;
begin
  if FRefs <> nil then begin
    for I := 0 to FRefs.Count - 1 do begin
      if FRefs[ I ] <> nil then
        FreeMem( FRefs[ I ] );
    end;
    FRefs.Clear;
  end;
end;

procedure TMeshSimplifier.Clear;
var
  I: Integer;
begin
  if FTriangles <> nil then begin
    for I := 0 to FTriangles.Count - 1 do begin
      if FTriangles[ I ] <> nil  then
        FreeMem( FTriangles[ I ] );
    end;
    FTriangles.Clear;
  end;
  if FVertices <> nil then begin
    for I := 0 to FVertices.Count - 1 do begin
      if FVertices[ I ] <> nil then
        FreeMem( FVertices[ I ] );
    end;
    FVertices.Clear;
  end;
  ClearRefs;
end;

procedure TMeshSimplifier.TrianglesToMesh;
var
  I: Integer;
  V: TPVertex;
  T: TPTriangle;
begin
  FFaces.Clear;
  for I := 0 to FVertices.Count - 1 do begin
    V := FVertices[ I ];
    FFaces.AddUnvalidatedVertex( V^.P.X, V^.P.Y, V^.P.Z );
  end;
  for I := 0 to FTriangles.Count - 1 do begin
    T := FTriangles[ I ];
    FFaces.AddFace( T^.V[ 0 ], T^.V[ 1 ], T^.V[ 2 ] );
  end;
end;

procedure TMeshSimplifier.MeshToTriangles;
var
  I, J: Integer;
  PVertex: TPVertex;
  PTriangle: TPTriangle;
  SVertex: TPS3Vector;
  SFace: TPFace;
begin
  Clear;
  for I := 0 to FFaces.VertexCount - 1 do begin
    SVertex := FFaces.GetVertex( I );
    GetMem(PVertex, SizeOf(TVertex));
    FVertices.Add(PVertex);
    PVertex^.P.X := SVertex.X;
    PVertex^.P.Y := SVertex.Y;
    PVertex^.P.Z := SVertex.Z;
    PVertex^.TStart := 0;
    PVertex^.TCount := 0;
    for J := Low( PVertex^.Q.M ) to High( PVertex^.Q.M ) do
      PVertex^.Q.M[J] := 0.0;
  end;
  for I := 0 to FFaces.Count - 1 do begin
    SFace := FFaces.GetFace( I );
    GetMem( PTriangle, SizeOf( TTriangle ) );
    FTriangles.Add( PTriangle );
    PTriangle^.V[ 0 ] := SFace.Vertex1;
    PTriangle^.V[ 1 ] := SFace.Vertex2;
    PTriangle^.V[ 2 ] := SFace.Vertex3;
    PTriangle^.Err[ 0 ] := 0.0;
    PTriangle^.Err[ 1 ] := 0.0;
    PTriangle^.Err[ 2 ] := 0.0;
    PTriangle^.Err[ 3 ] := 0.0;
    PTriangle^.Deleted := False;
    PTriangle^.Dirty := False;
    PTriangle^.N.X := 0.0;
    PTriangle^.N.Y := 0.0;
    PTriangle^.N.Z := 0.0;
  end;
  OutputDebugString(PChar('Simplification Input: TCount = '+IntToStr(FVertices.Count)+', FCount = ' + IntToStr(FTriangles.Count)));
end;

// Main simplification function
//
// target_count  : target nr. of triangles
// agressiveness : sharpness to increase the threashold.
//                 5..8 are good numbers
//                 more iterations yield higher quality
procedure TMeshSimplifier.SimplifyMesh(const TargetCount: Integer; const Agressiveness: Double = 7.0);
var
  I, J, K, Iteration, DeletedTriangles, TriangleCount: Integer;
  I0, I1, TStart, TCount: Integer;
  V0, V1: TPVertex;
  Deleted0, Deleted1: Array of Boolean;
  Threshold: Double;
  SRef, DRef: TPRef;
  T: TPTriangle;
  P: TVector3;
begin
  // init
  MeshToTriangles;
  // init
  for I := 0 to FTriangles.Count - 1 do
    TPTriangle( FTriangles[ I ] )^.Deleted := False;

  // main iteration loop
  DeletedTriangles := 0;
  TriangleCount := FTriangles.Count;
  //int iteration = 0;
  //loop(iteration,0,100)
  for Iteration := 0 to 99 do begin
    if TriangleCount - DeletedTriangles <= TargetCount then
      break;

    // update mesh once in a while
    if iteration mod 5 = 0 then
      UpdateMesh( Iteration );

    // clear dirty flag
    // clear dirty flag
    for I := 0 to FTriangles.Count - 1  do
      TPTriangle( FTriangles[ I ] )^.Dirty := False;

    //
    // All triangles with edges below the threshold will be removed
    //
    // The following numbers works well for most models.
    // If it does not, try to adjust the 3 parameters
    //
    Threshold := 0.000000001 * Power( Iteration + 3.0, Agressiveness);

    // remove vertices & mark deleted triangles
    for I := 0 to FTriangles.Count - 1 do begin
      T := FTriangles[ I ];
      if T.Err[3] > Threshold then
        Continue;
      if T.Deleted then
        Continue;
      if T.Dirty then
       Continue;

      for J := 0 to 2 do begin
        if T^.Err[ J ] < Threshold then begin
          I0 := T.V[ J ];
          V0 := FVertices[ I0 ];
          I1 := T.V[ ( J + 1) mod 3 ];
          V1 := FVertices[ I1 ];
          // Border check
          if V0.border <> V1.border then
            Continue;

          // Compute vertex to collapse to
          CalculateError( I0, I1, @P );
          SetLength( Deleted0, V0.TCount ); // normals temporarily
          SetLength( Deleted1, V1.TCount ); // normals temporarily

          // dont remove if flipped
          if( Flipped( @P, I0, I1, V0, V1, Deleted0 ) ) then
            Continue;
          if( Flipped( @P, I1, I0, V1, V0, Deleted1 ) ) then
            Continue;

          // not flipped, so remove edge
          V0.P := P;
          MatrixAdd( @( V0.Q ), @( V1.Q ), @( V0.Q ));
          TStart := FRefs.Count;

          UpdateTriangles( I0, V0, Deleted0, DeletedTriangles );
          UpdateTriangles( I0, V1, Deleted1, DeletedTriangles );

          TCount := FRefs.Count - TStart;

          if TCount <= V0.TCount then begin
            // save ram
            for K := 0 to TCount - 1  do begin
              DRef := FRefs[ V0.TStart + K ];
              SRef := FRefs[ TStart + K ];
              DRef^.TId := SRef^.TId;
              DRef^.TVertex := SRef^.TVertex;
            end;
          end
          else begin
            // append
            V0.TStart := TStart;
          end;

          V0.TCount := TCount;

          break;
        end;
      end;
      // done?
      if TriangleCount - DeletedTriangles <= TargetCount then
        break;
    end;
  end;
  // clean up mesh
  CompactMesh;
  TrianglesToMesh;
  OutputDebugString(PChar('Simplification Output: TCount = '+IntToStr(FVertices.Count)+', FCount = ' + IntToStr(FTriangles.Count)));
end;

procedure TMeshSimplifier.SimplifyMeshLossless(const Threshold: Double = 1.0E-4);
  //
  // All triangles with edges below the threshold will be removed
  //
  // The following numbers works well for most models.
  // Threshold: Double = 1.0E-3
  // If it does not, try to adjust the 3 parameters
  //
var
  I, J, K, Iteration, DeletedTriangles, TriangleCount: Integer;
  Deleted0, Deleted1: Array of Boolean;
  I0, I1, TStart, TCount: Integer;
  T: TPTriangle;
  V0, V1: TPVertex;
  SRef, DRef: TPRef;
  P: TVector3;
begin
  // init
  MeshToTriangles;
  // main iteration loop
  DeletedTriangles := 0;
  TriangleCount := FTriangles.Count;
  for Iteration := 0 to 9999 do begin
    // update mesh constantly
    UpdateMesh( Iteration );
    // clear dirty flag
    for I := 0 to FTriangles.Count - 1  do
      TPTriangle( FTriangles[ I ] )^.Dirty := False;
    // remove vertices & mark deleted triangles
    for I := 0 to FTriangles.Count - 1 do begin
      T := FTriangles[ I ];
      if T.Err[3] > Threshold then
        Continue;
      if T.Deleted then
        Continue;
      if T.Dirty then
       Continue;

      for J := 0 to 2 do begin
        if T.err[j] < Threshold then begin
          I0 := T.V[ J ];
          V0 := FVertices[ I0 ];
          I1 := T.V[ ( J + 1) mod 3 ];
          V1 := FVertices[ I1 ];

          // Border check
          if V0.border <> V1.border then
            Continue;

          // Compute vertex to collapse to
          CalculateError( I0, I1, @P );
          SetLength( Deleted0, V0.TCount ); // normals temporarily
          SetLength( Deleted1, V1.TCount ); // normals temporarily

          // dont remove if flipped
          if( Flipped( @P, I0, I1, V0, V1, Deleted0 ) ) then
            Continue;
          if( Flipped( @P, I1, I0, V1, V0, Deleted1 ) ) then
            Continue;

          // not flipped, so remove edge
          V0.P := P;
          MatrixAdd( @( V0.Q ), @( V1.Q ), @( V0.Q ));
          TStart := FRefs.Count;

          UpdateTriangles( I0, V0, Deleted0, DeletedTriangles );
          UpdateTriangles( I0, V1, Deleted1, DeletedTriangles );

          TCount := FRefs.Count - TStart;

          if TCount <= V0.TCount then begin
            // save ram
            for K := 0 to TCount - 1  do begin
              DRef := FRefs[ V0.TStart + K ];
              SRef := FRefs[ TStart + K ];
              DRef^.TId := SRef^.TId;
              DRef^.TVertex := SRef^.TVertex;
            end;
          end
          else begin
            // append
            V0.TStart := TStart;
          end;

          V0.TCount := TCount;
          break;
        end;
      end;
    end;
    if DeletedTriangles <= 0 then
      break;
    DeletedTriangles := 0;
  end;
  // clean up mesh
  CompactMesh;
  TrianglesToMesh;
  OutputDebugString(PChar('Simplification Output: TCount = '+IntToStr(FVertices.Count)+', FCount = ' + IntToStr(FTriangles.Count)));
end;

	// Update triangle connections and edge error after a edge is collapsed
procedure TMeshSimplifier.UpdateTriangles( const I0: Integer; const V:TPVertex; var Deleted: Array of Boolean; var DeletedTriangles: Integer);
var
  K: Integer;
  P: TVector3;
  SRef, R: TPRef;
  T: TPTriangle;
begin
	for K := 0 to V.TCount - 1 do begin
    SRef := FRefs[ V.TStart + K ];
    GetMem( R, SizeOf( TREf ));
    R^.TId := SRef^.TId;
    R^.TVertex := SRef^.TVertex;
    T := FTriangles[ R.TId ];
    if T^.Deleted then
      Continue;
    if Deleted[ K ] then begin
      T^.Deleted := True;
      Inc( DeletedTriangles );
      Continue;
    end;
    T^.V[ R^.TVertex ] := I0;
    T^.Dirty := True;
    T^.Err[0] := CalculateError( T.V[ 0 ], T.V[ 1 ], @P );
    T^.Err[1] := CalculateError( T.V[ 1 ], T.V[ 2 ], @P );
    T^.Err[2] := CalculateError( T.V[ 2 ], T.V[ 0 ], @P );
    T^.Err[3] := Min( T^.Err[ 0 ], Min( T.Err[ 1 ], T.err[ 2 ] ) );
    FRefs.Add( R );
  end;
end;

// Finally compact mesh before exiting
procedure TMeshSimplifier.CompactMesh;
var
  I, J, Dst: Integer;
  T: TPTriangle;
  NewTriangles: TList;
begin
  for I := 0 to FVertices.Count - 1 do begin
    TPVertex( FVertices[i] ).TCount := 0;
  end;

  NewTriangles := TList.Create;
  for I := 0 to FTriangles.Count - 1 do begin
    T := FTriangles[ I ];
    if not T^.Deleted then begin
      NewTriangles.Add( T );
      for J := 0 to 2 do
        TPVertex( FVertices[T^.V[ J ] ] )^.TCount := 1;
    end
    else
      FreeMem( T );
  end;
  FTriangles.Free;
  FTriangles := NewTriangles;

  Dst := 0;
  for I := 0 to FVertices.Count - 1 do begin
    if TPVertex( FVertices[ I ] )^.TCount > 0 then begin
      TPVertex( FVertices[ I ] )^.TStart := Dst;
      TPVertex( FVertices[ Dst ] )^.P := TPVertex( FVertices[ I ] )^.P;
      Inc( Dst );
    end;
  end;

  for I := 0 to FTriangles.Count - 1 do begin
    T := TPTriangle( FTriangles[ I ] );
    for J := 0 to 2 do
      T^.V[ J ] := TPVertex( FVertices[ T.V[ J ] ] )^.TStart;
  end;

  for I := Dst to FVertices.Count - 1 do begin
    FreeMem( FVertices[ FVertices.Count - 1 ] );
    FVertices.Delete( FVertices.Count - 1 );
  end;
end;


// compact triangles, compute edge error and build reference list
procedure TMeshSimplifier.UpdateMesh(const Iteration: Integer);
var
  I, J, K, TStart, Ofs, Id: Integer;
  NewTriangles: TList;
  T: TPTriangle;
  V: TPVertex;
  A, B, N: TVector3;
  P: Array [0..2] of TVector3;
  M: TSymmetricMatrix;
  Ref: TPRef;
  VCount, VIds: TList<Integer>;
begin
  if Iteration > 0 then begin // compact triangles
    NewTriangles := TList.Create;
    for I := 0 to FTriangles.Count - 1 do begin
      T := FTriangles[ I ];
      if not T^.Deleted then
        NewTriangles.Add( T )
      else
        FreeMem( T );
    end;
    FTriangles.Free;
    FTriangles := NewTriangles;
  end;
  //
  // Init Quadrics by Plane & Edge Errors
  //
  // required at the beginning ( iteration == 0 )
  // recomputing during the simplification is not required,
  // but mostly improves the result for closed meshes
  //
  if Iteration = 0 then begin
    for I := 0 to FVertices.Count - 1 do begin
      V := FVertices[ I ];
      MatrixInit( @(V^.Q), 0.0 );
    end;
    for I := 0 to FTriangles.Count - 1 do begin
      T := FTriangles[ I ];
      for J := 0 to 2 do
        P[ J ] := TPVertex( FVertices[ T.V[ J ] ] )^.P;
      VecSub( @A, @(P[ 1 ]), @(P[ 0 ]) );
      VecSub( @B, @(P[ 2 ]), @(P[ 0 ]) );
      VecCross( @N, @A, @B );
      VecNormalize( @N );
      T^.N := N;
      for J := 0 to 2 do begin
        MatrixInit( @M, N.X, N.Y, N.Z, -VecDot( @N, @P[0] ) );
        MatrixAdd( @( TPVertex( FVertices[ T^.V[ J ] ])^.Q ), @( TPVertex( FVertices[ T^.V[ J ] ] )^.Q ), @M );
      end;
    end;
    for I := 0 to FTriangles.Count - 1 do begin
      // Calc Edge Error
      T := FTriangles[ I ];
      for J := 0 to 2 do
        T^.Err[ J ] := CalculateError( T^.V[ J ], T^.V[ (J + 1) mod 3 ], @A );
      T^.Err[ 3 ] := Min( T^.Err[ 0 ], Min( T^.Err[ 1 ], T^.Err[ 2 ] ) );
    end;
  end;

  // Init Reference ID list
  for I := 0 to FVertices.Count - 1 do begin
    TPVertex( FVertices[ I ] )^.TStart := 0;
    TPVertex( FVertices[ I ] )^.TCount := 0;
  end;
  for I := 0 to FTriangles.Count - 1 do begin
    T := FTriangles[ I ];
    for J := 0 to 2 do
      Inc( TPVertex( FVertices[ T^.V[ J ] ] )^.TCount );
  end;
  TStart := 0;
  for I := 0 to FVertices.Count - 1 do begin
    V := FVertices[ I ];
    V^.TStart := TStart;
    Inc( TStart, V^.TCount );
    V^.TCount := 0;
  end;

  // Write References
  ClearRefs;
  for I := 0 to 3 * FTriangles.Count - 1 do begin
    GetMem( Ref, SizeOf( TRef ) );
    Ref^.TId := 0;
    Ref^.TVertex := 0;
    FRefs.Add( Ref );
  end;

  for I := 0 to FTriangles.Count - 1 do begin
    T := FTriangles[ I ];
    for J := 0 to 2 do begin
      V := FVertices[ T^.V[ J ] ];
      TPRef( FRefs[ V^.TStart + V^.TCount ] )^.TId := I;
      TPRef( FRefs[ V^.TStart + V^.TCount ] )^.TVertex := J;
      Inc( V^.TCount );
    end;
  end;

  // Identify boundary : vertices[].border=0,1
  if Iteration = 0 then begin
    VCount := TList<Integer>.Create;
    try
      VIds := TList<Integer>.Create;
      try
        for I := 0 to FVertices.Count - 1 do
          TPVertex( FVertices[ I ] )^.Border := False;
        for I := 0 to FVertices.Count - 1 do begin
          V := FVertices[ I ];
          VCount.Clear;
          VIds.Clear;
          for J := 0 to V^.TCount - 1 do begin
            K := TPRef( FRefs[ V^.TStart + J ] )^.TId;
            T := FTriangles[ K ];
            for K := 0 to 2 do begin
              Ofs := 0;
              Id := T^.V[ K ];
              while Ofs < VCount.Count do begin
                if VIds[Ofs]=Id then
                  break;
                Inc( Ofs );
              end;
              if Ofs =VCount.Count then begin
                VCount.Add( 1 );
                VIds.Add( Id );
              end
              else
                VCount[ Ofs ] := VCount[ Ofs ] + 1;
            end;
          end;

          for J := 0 to VCount.Count - 1 do begin
            if VCount[ J ] =1 then
              TPVertex( FVertices[ VIds[ J ] ] )^.Border := True;
          end;
        end;
      finally
        VIds.Free;
      end;
    finally
      VCount.Free;
    end;
  end;
end;


procedure TMeshSimplifier.MatrixInit( M: TPSymmetricMatrix; const C: Single );
var
  I: Integer;
begin
  for I := Low( M^.M ) to High( M^.M ) do
    M^.M[ I ] := C;
end;

// Make plane
procedure TMeshSimplifier.MatrixInit( M: TPSymmetricMatrix; const A, B, C, D: Single );
begin
	M^.M[ 0 ] := A * A; M^.M[ 1 ] := A * B; M^.M[ 2 ] := A * C; M^.M[ 3 ] := A * D;
		                  M^.M[ 4 ] := B * B; M^.M[ 5 ] := B * C; M^.M[ 6 ] := B * D;
		                                      M^.M[ 7 ] := C * C; M^.M[ 8 ] := C * D;
                   		                                        M^.M[ 9 ] := D * D;
end;

procedure TMeshSimplifier.MatrixAdd( Dest: TPSymmetricMatrix; const A, B: TPSymmetricMatrix );
var
  I: Integer;
begin
  for I := Low( Dest^.M )  to High( Dest^.M ) do
    Dest^.M[ I ] := A^.M[ I ] + B^.M[ I ];
end;

	// Determinant

function TMeshSimplifier.MatrixDet(	const M: TPSymmetricMatrix; const A11, A12, A13, A21, A22, A23, A31, A32, A33: Integer): Single;
begin
	Result := M^.M[ A11 ] * M^.M[ A22 ] * M^.M[ A33 ] + M^.M[ A13 ] * M^.M[ A21 ] * M^.M[ A32 ] +
            M^.M[ A12 ] * M^.M[ A23 ] * M^.M[ A31 ] - M^.M[ A13 ] * M^.M[ A22 ] * M^.M[ A31 ] -
            M^.M[ A11 ] * M^.M[ A23 ] * M^.M[ A32 ] - M^.M[ A12 ] * M^.M[ A21 ] * M^.M[ A33 ];
end;

// Check if a triangle flips when this edge is removed
function TMeshSimplifier.Flipped( const P: TPVector3; const I0, I1: Integer; const V0, V1: TPVertex; var Deleted: Array of Boolean ): Boolean;
var
  K, S, Id1, Id2: Integer;
  T: TPTriangle;
  D1, D2, N: TVector3;
begin
  for K := 0 to V0^.TCount - 1 do begin
    T := FTriangles[ TPRef ( FRefs[ V0^.TStart + K ] )^.TId];
    if T.Deleted then
      Continue;

    S := TPRef( FRefs[ V0^.TStart + K ] )^.TVertex;
    Id1 := T^.V[ ( S + 1) mod 3 ];
    Id2 := T^.V[ ( S + 2) mod 3 ];

    if ( Id1 = I1 ) or ( Id2 = I1) then begin // delete ?
      Deleted[ K ] := True;
      continue;
    end;
    VecSub( @D1, @( TPVertex( FVertices[ Id1 ] )^.P ), P);
    VecNormalize( @D1 );
    VecSub( @D2, @( TPVertex( FVertices[ Id2 ] )^.P ), P);
    VecNormalize( @D2 );

    if( Abs( VecDot( @D1, @D2) ) > 0.999 ) then begin
      Result := True;
      Exit;
    end;

    VecCross( @N, @D1, @D2 );
    VecNormalize( @N );
    Deleted[ K ] := False;
    if VecDot( @N, @( T^.N ) ) < 0.2 then begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

end.

