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
unit MeshPreview;

interface

uses
  SysUtils, Classes, Windows, dglOpenGL, Vcl.Graphics, VertexList, VectorMath,
  OpenGLPreviewUtil, ShaderUtil, Forms;

type
  TMeshAppearance = class
  private
    procedure InitColors;
  public
    WireframeColor: TS3Vector;
    SurfaceColor: TS3Vector;
    EdgesColor: TS3Vector;
    PointsColor: TS3Vector;

    LightingEnabled: Boolean;

    MatAmbient: TS3Vector;
    MatSpecular: TS3Vector;
    MatShininess: Single;
    MatDiffuse: TS3Vector;

    LightAmbient: TS3Vector;
    LightDiffuse: TS3Vector;
    LightPosition: TS3Vector;

    LightConstantAttenuation: Single;
    LightLinearAttenuation: Single;
    LightQuadraticAttenuation: Single;
    constructor Create;
  end;

  TOpenGLHelper = class( TBaseOpenGLHelper )
  private
    FForm: TForm;
    FMeshAppearance: TMeshAppearance;
    procedure SetupLighting;
    procedure DrawBackground; override;
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean); override;
  public
    constructor Create(const Form: TForm; const Canvas: TCanvas);
    destructor Destroy; override;
    procedure UpdateMesh(const NewFacesList: TFacesList; const MaxVerticeCount: integer); override;
    procedure UpdateMesh(const VertexList: TPS3VectorList; const ColorList: TPSMI3VectorList); override;
    property MeshAppearance: TMeshAppearance read FMeshAppearance;
  end;

implementation

uses
  Math, DateUtils, BulbTracer2;

const
  WindowTitle = 'Mesh Preview';

{ ------------------------------ TOpenGLHelper ------------------------------- }
constructor TOpenGLHelper.Create(const Form: TForm; const Canvas: TCanvas);
begin
  inherited Create( Canvas );
  FForm := Form;
  FMeshAppearance := TMeshAppearance.Create;
end;

destructor TOpenGLHelper.Destroy;
begin
  FMeshAppearance.Free;
  inherited Destroy;
end;

procedure TOpenGLHelper.DrawBackground;
begin
  //Gradient background
	glMatrixMode (GL_MODELVIEW);
	glPushMatrix ();
	glLoadIdentity ();
	glMatrixMode (GL_PROJECTION);
	glPushMatrix ();
	glLoadIdentity ();

	glDisable(GL_LIGHTING);
	glDisable(GL_DEPTH_TEST);

	glBegin (GL_QUADS);
	glColor3f(0.78039215686274509803921568627451, 0.65882352941176470588235294117647, 0.54509803921568627450980392156863);
	glVertex3f (-1.0, -1.0, -1.0);
	glColor3f(0.78039215686274509803921568627451, 0.65882352941176470588235294117647, 0.54509803921568627450980392156863);
	glVertex3f (1.0, -1.0, -1.0);
	glColor3f(0.21960784313725490196078431372549, 0.34509803921568627450980392156863, 0.56470588235294117647058823529412);
	glVertex3f (1.0, 1.0, -1.0);
	glColor3f(0.21960784313725490196078431372549, 0.34509803921568627450980392156863, 0.56470588235294117647058823529412);
	glVertex3f (-1.0, 1.0, -1.0);
	glEnd ();

	glEnable(GL_LIGHTING);
	glEnable(GL_DEPTH_TEST);
	glPopMatrix ();
	glMatrixMode (GL_MODELVIEW);
	glPopMatrix ();
end;

procedure TOpenGLHelper.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
const
  ZOffset: Double = -7.0;
var
  Error, I : LongInt;
  X, Y, Z: Double;

  V: TPS3Vector;
  Face: TPFace;
  Scl: Double;
begin
  if ( FRC = 0 ) or ( FForm = nil ) or (not FForm.Visible) then
    Exit;

  glClearColor(0,0,0,0);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  if FFaces <> nil then
    DrawBackground();

  glLoadIdentity;
  glTranslatef( FPosition.X,  FPosition.Y,  ZOffset / FScale);
  glRotatef( FAngle.X, 0.0, 1.0, 0.0);
  glRotatef( - FAngle.Y, 1.0, 0.0, 1.0);
  Scl := (*FScale * *) 3.0/FMaxObjectSize;
  glScalef(Scl, Scl, Scl);
  glTranslatef( 0.0,  0.0,  FPosition.Z);

  glDisable(GL_LIGHTING);

  glDisableClientState (GL_VERTEX_ARRAY);
  glDisableClientState (GL_COLOR_ARRAY);

  if FFaces <> nil then begin
    glEnableClientState (GL_VERTEX_ARRAY);
    glVertexPointer( 3, GL_FLOAT, SizeOf(TGLVertex), FVertices);
    if FNormals <> nil then begin
      glEnableClientState( GL_NORMAL_ARRAY );
      glNormalPointer( GL_FLOAT, SizeOf(TGLVertex), FNormals);
    end;

    case FDisplayStyle of
      dsPoints:
        begin
          glShadeModel(GL_FLAT);
          glPointSize(2.0);
          if FVertexColors<>nil then begin
            glEnableClientState (GL_COLOR_ARRAY);
            glColorPointer( 3, GL_FLOAT, SizeOf(TGLVertex), FVertexColors);
          end
          else begin
            glColor3f(FMeshAppearance.PointsColor.X, FMeshAppearance.PointsColor.Y, FMeshAppearance.PointsColor.Z);
          end;
          glDrawElements( GL_POINTS, FFaceCount * 3, GL_UNSIGNED_INT, FFaces );
        end;
      dsWireframe:
        begin
          glShadeModel(GL_FLAT);
          if FEdges<>nil then begin
            glLineWidth(1.0);
            glColor3f(FMeshAppearance.WireframeColor.X, FMeshAppearance.WireframeColor.Y, FMeshAppearance.WireframeColor.Z);
            glDrawElements( GL_LINES, FEdgeCount * 2, GL_UNSIGNED_INT, FEdges );
          end;
        end;
      dsFlatSolid:
        begin
          SetupLighting;
          glShadeModel(GL_FLAT);
          glColor3f(FMeshAppearance.SurfaceColor.X, FMeshAppearance.SurfaceColor.Y, FMeshAppearance.SurfaceColor.Z);
          glDrawElements( GL_TRIANGLES, FFaceCount * 3, GL_UNSIGNED_INT, FFaces );
        end;
      dsFlatSolidWithEdges:
        begin
          SetupLighting;
          glShadeModel(GL_FLAT);
          glColor3f(FMeshAppearance.SurfaceColor.X, FMeshAppearance.SurfaceColor.Y, FMeshAppearance.SurfaceColor.Z);
          glDrawElements( GL_TRIANGLES, FFaceCount * 3, GL_UNSIGNED_INT, FFaces );
          if FEdges<>nil then begin
            glDisable(GL_LIGHTING);
            glLineWidth(1.5);
            glColor3f(FMeshAppearance.EdgesColor.X, FMeshAppearance.EdgesColor.Y, FMeshAppearance.EdgesColor.Z);
            glDrawElements( GL_LINES, FEdgeCount * 2, GL_UNSIGNED_INT, FEdges );
          end;
        end;
      dsSmoothSolid:
        begin
          SetupLighting;
          glShadeModel(GL_SMOOTH);
          glColor3f(FMeshAppearance.SurfaceColor.X, FMeshAppearance.SurfaceColor.Y, FMeshAppearance.SurfaceColor.Z);
          glDrawElements( GL_TRIANGLES, FFaceCount * 3, GL_UNSIGNED_INT, FFaces );
        end;
      dsSmoothSolidWithEdges:
        begin
          SetupLighting;
          glShadeModel(GL_SMOOTH);
          glColor3f(FMeshAppearance.SurfaceColor.X, FMeshAppearance.SurfaceColor.Y, FMeshAppearance.SurfaceColor.Z);
          glDrawElements( GL_TRIANGLES, FFaceCount * 3, GL_UNSIGNED_INT, FFaces );
          if FEdges<>nil then begin
            glDisable(GL_LIGHTING);
            glLineWidth(1.5);
            glColor3f(FMeshAppearance.EdgesColor.X, FMeshAppearance.EdgesColor.Y, FMeshAppearance.EdgesColor.Z);
            glDrawElements( GL_LINES, FEdgeCount * 2, GL_UNSIGNED_INT, FEdges );
          end;
        end;
    end;
  end
  else if FVertices <> nil then begin
    glEnableClientState (GL_VERTEX_ARRAY);
    if FVertexColors<>nil then
      glEnableClientState (GL_COLOR_ARRAY);

    glVertexPointer( 3, GL_FLOAT, SizeOf(TGLVertex), FVertices);
    if FVertexColors<>nil then
      glColorPointer( 3, GL_FLOAT, SizeOf(TGLVertex), FVertexColors);

    glShadeModel(GL_FLAT);
    glPointSize(1.25);
    glColor3f(FMeshAppearance.PointsColor.X, FMeshAppearance.PointsColor.Y, FMeshAppearance.PointsColor.Z);

    glDrawArrays (GL_POINTS, 0, FVerticesCount);
  end;

  //Error Handler
  Error := glgetError;
  if Error <> GL_NO_ERROR then begin
    if Assigned(FSetWindowCaptionEvent) then
      FSetWindowCaptionEvent( gluErrorString(Error) );
    Done := True;
    FlashWindow(FCanvas.Handle, True)
  end;
  //Frame Counter
  Inc(FFrames);
  if (GetTickCount - FStartTick >= 500) and (FFrames >= 10) and Assigned(FSetWindowCaptionEvent) then begin
    if FFullMeshFaceCount <> FFaceCount then
      FSetWindowCaptionEvent( Format('%s [%f FPS, %d of %d Vertices, %d of %d Faces]', [WindowTitle, FFrames/(GetTickCount - FStartTick)*1000, FVerticesCount, FFullMeshVerticesCount, FFaceCount, FFullMeshFaceCount]))
    else
      FSetWindowCaptionEvent( Format('%s [%f FPS, %d Vertices, %d Faces]', [WindowTitle, FFrames/(GetTickCount - FStartTick)*1000, FVerticesCount, FFaceCount]));
    FFrames := 0;
    FStartTick := GetTickCount;
  end;
  SwapBuffers(FCanvas.Handle);
end;

procedure TOpenGLHelper.UpdateMesh(const VertexList: TPS3VectorList; const ColorList: TPSMI3VectorList);
var
  I: Integer;
  T0, T00: Int64;
  GLVertices, GLVertex: TPGLVertex;
  GLVertexColors, GLVertexColor: TPGLVertex;
  Vertex: TPS3Vector;

  procedure AddVertex(const Idx: Integer);
  var
    Vertex: TPS3Vector;
    VertexColor: TPSMI3Vector;
  begin
    Vertex := VertexList.GetVertex(Idx);
    if Vertex^.X < FSizeMin.X then
      FSizeMin.X := Vertex^.X
    else if Vertex^.X > FSizeMax.X then
      FSizeMax.X := Vertex^.X;
    if Vertex^.Y < FSizeMin.Y then
      FSizeMin.Y := Vertex^.Y
    else if Vertex^.Y > FSizeMax.Y then
      FSizeMax.Y := Vertex^.Y;
    if Vertex^.Z < FSizeMin.Z then
      FSizeMin.Z := Vertex^.Z
    else if Vertex^.Z > FSizeMax.Z then
      FSizeMax.Z := Vertex^.Z;
    GLVertex^.X := Vertex^.X;
    GLVertex^.Y := -Vertex^.Y;
    GLVertex^.Z := -Vertex^.Z;
    GLVertex := Pointer(Longint(GLVertex)+SizeOf(TGLVertex));

    if GLVertexColors <> nil then begin
      VertexColor := ColorList.GetVertex(Idx);
      GLVertexColor^.X := TPSMI3VectorList.SMIToFloat( VertexColor^.X );
      GLVertexColor^.Y := TPSMI3VectorList.SMIToFloat( VertexColor^.Y );
      GLVertexColor^.Z := TPSMI3VectorList.SMIToFloat( VertexColor^.Z );
      GLVertexColor := Pointer(Longint(GLVertexColor)+SizeOf(TGLVertex));
    end;
  end;

begin
  T0 := DateUtils.MilliSecondsBetween(Now, 0);
  T00 := T0;

  FreeVertices;
  if VertexList.Count > 0 then begin
    T0 := DateUtils.MilliSecondsBetween(Now, 0);
    GetMem(GLVertices, VertexList.Count * SizeOf(TGLVertex));
    try
      GLVertex := GLVertices;
      if ColorList <> nil then
        GetMem(GLVertexColors, VertexList.Count * SizeOf(TGLVertex))
      else
        GLVertexColors := nil;
      try
        GLVertexColor := GLVertexColors;

        Vertex := VertexList.GetVertex(0);
        FSizeMin.X := Vertex^.X;
        FSizeMax.X := FSizeMin.X;
        FSizeMin.Y := Vertex^.Y;
        FSizeMax.Y := FSizeMin.Y;
        FSizeMin.Z := Vertex^.Z;
        FSizeMax.Z := FSizeMin.Z;
        for I := 0 to VertexList.Count - 1 do
          AddVertex(I);
  ShowDebugInfo('OpenGL.AddVertices', T0);
  T0 := DateUtils.MilliSecondsBetween(Now, 0);

        FMaxObjectSize := Max(FSizeMax.X - FSizeMin.X, Max(FSizeMax.Y - FSizeMin.Y, FSizeMax.Z - FSizeMin.Z ));
  ShowDebugInfo('OpenGL.AddFaces', T0);
  T0 := DateUtils.MilliSecondsBetween(Now, 0);

        FFaceCount := 0;
        FFullMeshFaceCount := 0;
        FVerticesCount := VertexList.Count;
        FFullMeshVerticesCount := FVerticesCount;
        FEdgeCount := 0;
        FVertices := GLVertices;
        FVertexColors := GLVertexColors;
        FNormals := nil;
        FFaces := nil;
        FEdges := nil;
      except
        if GLVertexColors <> nil then
           FreeMem( GLVertexColors );
        raise;
      end;
    except
      FreeMem(GLVertices);
      raise;
    end;
  end;
  ShowDebugInfo('OpenGL.TOTAL', T00);
end;

procedure TOpenGLHelper.UpdateMesh(const NewFacesList: TFacesList; const MaxVerticeCount: integer);
var
  T0, T00: Int64;
  I: Integer;
  Key: String;
  GLVertices, GLVertex: TPGLVertex;
  GLNormals, GLNormal: TPGLVertex;
  GLEdges, GLEdge: TPGLEdge;
  GLFaces, GLFace: TPGLFace;
  EdgesList: TStringList;
  EdgeCount: Integer;
  Vertex: TPS3Vector;
  Face: TPFace;
  Normals: TPS3VectorList;
  WithColors: Boolean;
  GLVertexColors, GLVertexColor: TPGLVertex;
  FacesList: TFacesList;
  FreeFacesList: boolean;
  ColorIdx1, ColorIdx2: Single;

  procedure AddVertex(const Idx: Integer);
  var
    Vertex: TPS3Vector;
  begin
    Vertex := FacesList.GetVertex(Idx);
    if Vertex^.X < FSizeMin.X then
      FSizeMin.X := Vertex^.X
    else if Vertex^.X > FSizeMax.X then
      FSizeMax.X := Vertex^.X;
    if Vertex^.Y < FSizeMin.Y then
      FSizeMin.Y := Vertex^.Y
    else if Vertex^.Y > FSizeMax.Y then
      FSizeMax.Y := Vertex^.Y;
    if Vertex^.Z < FSizeMin.Z then
      FSizeMin.Z := Vertex^.Z
    else if Vertex^.Z > FSizeMax.Z then
      FSizeMax.Z := Vertex^.Z;
    GLVertex^.X := Vertex^.X;
    GLVertex^.Y := -Vertex^.Y;
    GLVertex^.Z := -Vertex^.Z;
    GLVertex := Pointer(Longint(GLVertex)+SizeOf(TGLVertex));


    if WithColors then begin
      TMCCubes.DecodeColorIdx(FacesList.VertexColors[Idx], ColorIdx1, ColorIdx2);
      if ColorIdx1 < 0.0 then
        ColorIdx1 := 0.0
      else if ColorIdx1 > 1.0 then
        ColorIdx1 := 1.0;

      GLVertexColor^.X := ColorIdx1;
      GLVertexColor^.Y := 1.0 - ColorIdx1;
      GLVertexColor^.Z := 0.0;
      GLVertexColor := Pointer(Longint(GLVertexColor)+SizeOf(TGLVertex));
    end;

  end;

  procedure AddNormal(const Idx: Integer);
  var
    Vertex: TPS3Vector;
  begin
    Vertex := Normals.GetVertex(Idx);
    GLNormal^.X := Vertex^.X;
    GLNormal^.Y := Vertex^.Y;
    GLNormal^.Z := -Vertex^.Z;
    GLNormal := Pointer(Longint(GLNormal)+SizeOf(TGLVertex));
  end;

  procedure AddFace(const Idx: Integer);
  var
    Face: TPFace;
  begin
    Face := FacesList.GetFace(Idx);
    GLFace^.V1 := Face^.Vertex1;
    GLFace^.V2 := Face^.Vertex2;
    GLFace^.V3 := Face^.Vertex3;
    GLFace := Pointer(Longint(GLFace)+SizeOf(TGLFace));
  end;

  procedure AddEdgeFromList(const Idx: Integer);
  var
    P: Integer;
    Key: String;
  begin
    Key := EdgesList[I];
    P := Pos('#', Key);
    GLEdge^.V1 := StrToInt(Copy(Key, 1, P - 1));
    GLEdge^.V2 := StrToInt(Copy(Key, P+1, Length(Key) - P));
    GLEdge := Pointer(Longint(GLEdge)+SizeOf(TGLEdge));
  end;

  procedure AddEdgesToList(const Idx: Integer);
  var
    Face: TPFace;
(*
    procedure AddEdge(const V1, V2: Integer);
    var
      Key: String;
    begin
      if V1 < V2 then
        Key := IntToStr(V1)+'#'+IntToStr(V2)
      else
        Key := IntToStr(V2)+'#'+IntToStr(V1);
      if EdgesList.IndexOf(Key) < 0 then
        EdgesList.Add(Key);
    end;
*)
    procedure FastAddEdge(const V1, V2: Integer);
    var
      Key: String;
    begin
      Key := IntToStr(V1)+'#'+IntToStr(V2);
      EdgesList.Add(Key);
    end;

  begin
    Face := FacesList.GetFace(Idx);
    FastAddEdge(Face^.Vertex1, Face^.Vertex2);

    if (EdgesList.Count mod 2) = 0 then
      FastAddEdge(Face^.Vertex2, Face^.Vertex3)
    else
      FastAddEdge(Face^.Vertex3, Face^.Vertex1);
(*
    FastAddEdge(Face^.Vertex1, Face^.Vertex2);
    FastAddEdge(Face^.Vertex2, Face^.Vertex3);
    FastAddEdge(Face^.Vertex3, Face^.Vertex1);
*)
  end;

begin
  T0 := DateUtils.MilliSecondsBetween(Now, 0);
  T00 := T0;
  FreeVertices;
  FacesList := nil;
  FreeFacesList := False;
  try
    WithColors := (NewFacesList.VertexColors.Count > 0) and (NewFacesList.VertexColors.Count = NewFacesList.VertexCount);
    if (MaxVerticeCount > 0) and (NewFacesList.VertexCount > MaxVerticeCount) then begin
      FacesList := TFacesList.Create;
      FreeFacesList := True;
      for I := 0 to MaxVerticeCount - 1 do begin
        Vertex := NewFacesList.GetVertex(I);
        if WithColors then
          FacesList.ForceAddVertex(Vertex.X, Vertex.Y, Vertex.Z, NewFacesList.VertexColors[ I ])
        else
          FacesList.ForceAddVertex(Vertex.X, Vertex.Y, Vertex.Z);
      end;
      for I := 0 to NewFacesList.Count - 1 do begin
        Face := NewFacesList.GetFace(I);
        if ( Face.Vertex1 < MaxVerticeCount ) and (Face.Vertex2 < MaxVerticeCount) and (Face.Vertex3 < MaxVerticeCount) then begin
          FacesList.AddFace(Face.Vertex1, Face.Vertex2, Face.Vertex3);
        end;
      end;
ShowDebugInfo('OpenGL.CreateReducesMesh('+IntToStr(MaxVerticeCount)+')', T0);
      T0 := DateUtils.MilliSecondsBetween(Now, 0);
    end
    else begin
      FacesList := NewFacesList;
      FreeFacesList := False;
    end;

    if FacesList.Count > 0 then begin
      EdgesList := TStringList.Create;
      try
        EdgesList.Duplicates := dupAccept;
        EdgesList.Sorted := False;
        for I := 0 to FacesList.Count - 1 do
          AddEdgesToList(I);
        EdgesList.Sorted := True;

        EdgeCount := EdgesList.Count;
ShowDebugInfo('OpenGL.AddEdgesPh1('+IntToStr(EdgeCount)+')', T0);
      T0 := DateUtils.MilliSecondsBetween(Now, 0);
        GetMem(GLEdges, EdgeCount * SizeOf(TGLEdge));
        try
          GLEdge := GLEdges;
          for I := 0 to EdgeCount - 1 do
            AddEdgeFromList(I);
        except
          FreeMem(GLEdges);
          raise;
        end;
      finally
        EdgesList.Free;
      end;
      ShowDebugInfo('OpenGL.AddEdgesPh2', T0);
      T0 := DateUtils.MilliSecondsBetween(Now, 0);


      if WithColors then begin
        GetMem(GLVertexColors, FacesList.VertexCount * SizeOf(TGLVertex));
        GLVertexColor := GLVertexColors;
      end
      else
        GLVertexColors := nil;
      try


        try
          GetMem(GLVertices, FacesList.VertexCount * SizeOf(TGLVertex));
          try
            GetMem(GLFaces, FacesList.Count * Sizeof(TGLFace));
            try
              GLVertex := GLVertices;

              Vertex := FacesList.GetVertex(0);
              FSizeMin.X := Vertex^.X;
              FSizeMax.X := FSizeMin.X;
              FSizeMin.Y := Vertex^.Y;
              FSizeMax.Y := FSizeMin.Y;
              FSizeMin.Z := Vertex^.Z;
              FSizeMax.Z := FSizeMin.Z;
              for I := 0 to FacesList.VertexCount - 1 do
                AddVertex(I);
      ShowDebugInfo('OpenGL.AddVertices', T0);
      T0 := DateUtils.MilliSecondsBetween(Now, 0);

              FMaxObjectSize := Max(FSizeMax.X - FSizeMin.X, Max(FSizeMax.Y - FSizeMin.Y, FSizeMax.Z - FSizeMin.Z ));
              GLFace := GLFaces;
              for I := 0 to FacesList.Count - 1 do
                AddFace(I);
      ShowDebugInfo('OpenGL.AddFaces', T0);
      T0 := DateUtils.MilliSecondsBetween(Now, 0);

              FFaceCount := FacesList.Count;
              FFullMeshFaceCount := NewFacesList.Count;
              FVerticesCount := FacesList.VertexCount;
              FFullMeshVerticesCount := NewFacesList.VertexCount;
              FEdgeCount := EdgeCount;
              FVertices := GLVertices;

              try
                GetMem(GLNormals, FVerticesCount * SizeOf(TGLVertex));
                try
                   GLNormal := GLNormals;
                   Normals := FacesList.CalculateVertexNormals;
                   try
                     if Normals.Count <> FVerticesCount then
                       raise Exception.Create('Invalid normals');
                     for I := 0 to Normals.Count - 1 do
                       AddNormal(I);
                   finally
                     Normals.Free;
                   end;
                except
                  FreeMem(GLNormals);
                  raise;
                end;
              except
                GLNormals := nil;
                // Hide error as normals are optional
              end;
              FNormals := GLNormals;
              FVertexColors := GLVertexColors;
              FFaces := GLFaces;
              FEdges := GLEdges;
            except
              FreeMem(GLFaces);
              raise;
            end;
          except
            FreeMem(GLVertices);
            raise;
          end;
        except
          if GLVertexColors <> nil then
             FreeMem( GLVertexColors );
          raise;
        end;
      except
        FreeMem(GLEdges);
        raise;
      end;
    end;
  finally
    if FreeFacesList and (FacesList <>nil) then
      FreeAndNil( FacesList );
  end;
  ShowDebugInfo('OpenGL.AddNormals', T0);
  ShowDebugInfo('OpenGL.TOTAL', T00);
end;

procedure TOpenGLHelper.SetupLighting;
var
	mat_ambient	: Array[0..3] of GlFloat;

	mat_specular   : Array[0..3] of GlFloat;
	mat_shininess  : Array[0..0] of GlFloat;
	mat_diffuse    : Array[0..3] of GlFloat;

	light_position : Array[0..3] of GlFloat;
	light_ambient  : Array[0..3] of GlFloat;
	light_diffuse  : Array[0..3] of GlFloat;

  procedure SetValue(const Src: TS3Vector; const Dst: PGLfloat); overload;
  var
    P: PGLfloat;
  begin
    P := Dst;
    P^ := Src.X;
    P := Pointer(Integer(P)+SizeOf(GLfloat));
    P^ := Src.Y;
    P := Pointer(Integer(P)+SizeOf(GLfloat));
    P^ := Src.Z;
    P := Pointer(Integer(P)+SizeOf(GLfloat));
    P^ := 1.0;
  end;

  procedure SetValue(const Src: Double; const Dst: PGLfloat); overload;
  begin
    Dst^ := Src;
  end;

begin
  with FMeshAppearance do begin
    if LightingEnabled then begin
      glEnable(GL_LIGHTING);
      SetValue(MatAmbient, @mat_ambient[0]);
      glMaterialfv(GL_FRONT, GL_AMBIENT,   @mat_ambient[0]);

      SetValue(MatSpecular, @mat_specular[0]);
      mat_specular[3] := 0.5;
      glMaterialfv(GL_FRONT, GL_SPECULAR,  @mat_specular[0]);

      SetValue(MatShininess, @mat_shininess[0]);
      glMaterialfv(GL_FRONT, GL_SHININESS, @mat_shininess[0]);

      SetValue(MatDiffuse, @mat_diffuse[0]);
      glMaterialfv(GL_FRONT, GL_DIFFUSE,   @mat_diffuse[0]);

      glEnable(GL_LIGHT0);
      SetValue(LightAmbient, @light_ambient[0]);
      glLightfv(GL_LIGHT0, GL_AMBIENT,  @light_ambient[0]);
      SetValue(LightDiffuse, @light_diffuse[0]);
      glLightfv(GL_LIGHT0, GL_DIFFUSE,  @light_diffuse[0]);
      SetValue(LightPosition, @light_position[0]);
      light_position[3] := 1.0;
      glLightfv(GL_LIGHT0, GL_POSITION, @light_position[0]);
      glLightf(GL_LIGHT0, GL_CONSTANT_ATTENUATION, LightConstantAttenuation);
      glLightf(GL_LIGHT0, GL_LINEAR_ATTENUATION, LightLinearAttenuation);
      glLightf(GL_LIGHT0, GL_QUADRATIC_ATTENUATION, LightQuadraticAttenuation);
    end
    else begin
      glDisable(GL_LIGHTING);
    end;
  end;
end;
{ ----------------------------- TMeshAppearance ------------------------------ }
constructor TMeshAppearance.Create;
begin
  inherited Create;
  InitColors;
end;

procedure TMeshAppearance.InitColors;
begin
  TSVectorMath.SetValue(@WireframeColor, 0.2, 0.2, 0.7);
  TSVectorMath.SetValue(@SurfaceColor, 0.77647058823529411764705882352941, 0.76470588235294117647058823529412, 0.71764705882352941176470588235294);
  TSVectorMath.SetValue(@EdgesColor, 0.2, 0.2, 0.2);
  TSVectorMath.SetValue(@PointsColor, 0.2, 0.7, 0.2);

  TSVectorMath.SetValue(@MatAmbient, 32.0 / 255.0, 32.0 / 255.0, 36.0 / 255.0);
  TSVectorMath.SetValue(@MatSpecular, 255.0 / 255.0, 240.0 / 255.0, 230.0 / 255.0);
  MatShininess := 2.0;
  TSVectorMath.SetValue(@MatDiffuse, 0.49, 0.49, 0.49);

  TSVectorMath.SetValue(@LightAmbient, 0.36, 0.36, 0.36);
  TSVectorMath.SetValue(@LightDiffuse, 0.8, 0.8, 0.8);
  TSVectorMath.SetValue(@LightPosition, -1.3, 7.4, 17.0);

  LightConstantAttenuation := 0.12;
  LightLinearAttenuation := 0.0025;
  LightQuadraticAttenuation := 0.00002;

  LightingEnabled := True;
end;


end.



