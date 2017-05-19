{ ---------------------------------------------------------------------------- }
{ BulbTracer for MB3D                                                          }
{ Copyright (C) 2016 Andreas Maschke                                           }
{ ---------------------------------------------------------------------------- }
unit MeshPreview;

interface

uses
  SysUtils, Classes, Windows, OpenGL12, Vcl.Graphics, VertexList, VectorMath;

type
  TDisplayStyle = (dsPoints, dsWireframe, dsFlatSolid, dsFlatSolidWithEdges, dsSmoothSolid, dsSmoothSolidWithEdges);

  TSetCaptionEvent = procedure(const Msg: String) of object;

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

  TOpenGLHelper = class
  private
    FRC: HGLRC; //OpenGL Rendering Context
    FCanvas: TCanvas;
    FFaces, FVertices, FEdges, FNormals: Pointer;
    FFaceCount, FEdgeCount, FVerticesCount: Integer;
    FDisplayStyle: TDisplayStyle;
    FSetWindowCaptionEvent: TSetCaptionEvent;
    FFrames, FStartTick: Integer;
    FPosition, FAngle: TS3Vector;
    FScale: Double;
    FMeshAppearance: TMeshAppearance;
    FSizeMin, FSizeMax: TS3Vector;
    FMaxObjectSize: Double;
    procedure FreeVertices;
    procedure RaiseError(const Msg: String);
    procedure SetupPixelFormat;
    procedure SetupGL;
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
    function GetXPosition: Double;
    procedure SetXPosition(const X: Double);
    function GetYPosition: Double;
    procedure SetYPosition(const Y: Double);
    function GetXAngle: Double;
    procedure SetXAngle(const X: Double);
    function GetYAngle: Double;
    procedure SetYAngle(const Y: Double);
    function GetScale: Double;
    procedure SetScale(const Scale: Double);
    procedure SetupLighting;
    procedure DrawBackground;
  public
    constructor Create(const Canvas: TCanvas);
    destructor Destroy; override;
    procedure InitGL;
    procedure CleanupGL;
    procedure AfterResize(const ClientWidth, ClientHeight: Integer);
    procedure UpdateMesh(const FacesList: TFacesList); overload;
    procedure UpdateMesh(const VertexList: TPS3VectorList); overload;
    procedure SetDisplayStyle(const DisplayStyle: TDisplayStyle);
    property XPosition: Double read GetXPosition write SetXPosition;
    property YPosition: Double read GetYPosition write SetYPosition;
    property XAngle: Double read GetXAngle write SetXAngle;
    property YAngle: Double read GetYAngle write SetYAngle;
    property Scale: Double read GetScale write SetScale;
    property SetWindowCaptionEvent: TSetCaptionEvent read FSetWindowCaptionEvent write FSetWindowCaptionEvent;
    property MeshAppearance: TMeshAppearance read FMeshAppearance;
  end;

implementation

uses
  Forms, Math, DateUtils;

const
  WindowTitle = 'Mesh Preview';

type
  TGLFace = packed record
    V1, V2, V3: Cardinal;
  end;
  TPGLFace = ^TGLFace;

  TGLEdge = packed record
    V1, V2: Cardinal;
  end;
  TPGLEdge = ^TGLEdge;

  TGLVertex = packed record
    X, Y, Z : Single;
  end;
  TPGLVertex = ^TGLVertex;

{ ------------------------------ TOpenGLHelper ------------------------------- }
constructor TOpenGLHelper.Create(const Canvas: TCanvas);
begin
  inherited Create;
  FMeshAppearance := TMeshAppearance.Create;
  FDisplayStyle := dsFlatSolidWithEdges;
  FCanvas := Canvas;
  TSVectorMath.Clear(@FPosition);
  TSVectorMath.Clear(@FAngle);
  FScale := 1.0;
end;

destructor TOpenGLHelper.Destroy;
begin
  FreeVertices;
  CleanupGL;
  FMeshAppearance.Free;
  inherited Destroy;
end;

procedure TOpenGLHelper.FreeVertices;
begin
  FFaceCount := 0;
  FEdgeCount := 0;
  FVerticesCount := 0;
  if FVertices <> nil then begin
    FreeMem(FVertices);
    FVertices := nil;
  end;
  if FNormals <> nil then begin
    FreeMem(FNormals);
    FNormals := nil;
  end;
  if FFaces <> nil then begin
    FreeMem(FFaces);
    FFaces := nil;
  end;
  if FEdges <> nil then begin
    FreeMem(FEdges);
    FEdges := nil;
  end;
end;

procedure TOpenGLHelper.RaiseError(const Msg: String);
begin
  raise Exception.Create('OpenGL: '+Msg);
end;

procedure TOpenGLHelper.SetupPixelFormat;
var
  PixelFormat: TGLuint;
  PFD: PIXELFORMATDESCRIPTOR;
begin
  with PFD do begin
    nSize:= SizeOf( PIXELFORMATDESCRIPTOR );
    nVersion:= 1;
    dwFlags:= PFD_DRAW_TO_WINDOW
      or PFD_SUPPORT_OPENGL
      or PFD_DOUBLEBUFFER;
    iPixelType:= PFD_TYPE_RGBA;
    cColorBits:= 16;
    cRedBits:= 0;
    cRedShift:= 0;
    cGreenBits:= 0;
    cBlueBits:= 0;
    cBlueShift:= 0;
    cAlphaBits:= 0;
    cAlphaShift:= 0;
    cAccumBits:= 0;
    cAccumRedBits:= 0;
    cAccumGreenBits:= 0;
    cAccumBlueBits:= 0;
    cAccumAlphaBits:= 0;
    cDepthBits:= 16;
    cStencilBits:= 0;
    cAuxBuffers:= 0;
    iLayerType:= PFD_MAIN_PLANE;
    bReserved:= 0;
    dwLayerMask:= 0;
    dwVisibleMask:= 0;
    dwDamageMask:= 0
  end;
  PixelFormat := ChoosePixelFormat(FCanvas.Handle, @PFD);
  if PixelFormat=0 then
    RaiseError('Error choosing PixelFormat');
  if not Windows.SetPixelFormat(FCanvas.Handle,PixelFormat,@PFD) then
    RaiseError('Error setting PixelFormat');
end;

procedure TOpenGLHelper.CleanupGL;
begin
  if FRC<>0 then begin
    try
      wglMakeCurrent(FCanvas.Handle,0);
      wglDeleteContext(FRC);
    finally
      FRC:=0;
    end;
  end;
end;

procedure TOpenGLHelper.InitGL;
begin
  if FRC = 0 then begin
    if not LoadOpenGL then
      RaiseError('Error initializing OpenGL library');
    SetupPixelFormat;
    FRC := wglCreateContext(FCanvas.Handle);
    if FRC=0 then
      RaiseError('Failed to create rendering context');
    try
      if not wglMakeCurrent(FCanvas.Handle, FRC) then
        RaiseError('Error activating Rendering Context');
      // ClearExtensions;
      // ReadExtensions;
      SetupGL;
      Application.OnIdle := ApplicationEventsIdle;
    except
      wglDeleteContext(FRC);
      FRC := 0;
      raise;
    end;
  end;
end;

procedure TOpenGLHelper.SetupGL;
begin
  glShadeModel(GL_FLAT);
  glPolygonMode( GL_FRONT, GL_FILL );
  glClearColor(0.0, 0.0, 0.0, 0.5);
  glClearDepth(1.0);
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LEQUAL);
  glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
  glEnableClientState( GL_VERTEX_ARRAY );
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
  if FRC = 0 then Exit;
  Done := False;

  glClearColor(0,0,0,0);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);

  DrawBackground();

  glLoadIdentity;
  glTranslatef( FPosition.X,  FPosition.Y,  ZOffset);
  glRotatef( FAngle.X, 0.0, 1.0, 0.0);
  glRotatef( - FAngle.Y, 1.0, 0.0, 1.0);
  Scl := FScale * 3.0/FMaxObjectSize;
  glScalef(Scl, Scl, Scl);
  glTranslatef( 0.0,  0.0,  FPosition.Z);

  glDisable(GL_LIGHTING);

  if FFaces <> nil then begin
    glVertexPointer( 3, GL_FLOAT, SizeOf(TGLVertex), FVertices);
    if FNormals <> nil then begin
      glEnableClientState( GL_NORMAL_ARRAY );
      glNormalPointer( GL_FLOAT, SizeOf(TGLVertex), FNormals);
    end;

    case FDisplayStyle of
      dsPoints:
        begin
          glShadeModel(GL_FLAT);
          glPointSize(5.0);
          glColor3f(FMeshAppearance.PointsColor.X, FMeshAppearance.PointsColor.Y, FMeshAppearance.PointsColor.Z);
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
    FSetWindowCaptionEvent( Format('%s [%f FPS, %d Vertices, %d Faces]', [WindowTitle, FFrames/(GetTickCount - FStartTick)*1000, FVerticesCount, FFaceCount]));
    FFrames := 0;
    FStartTick := GetTickCount;
  end;
  SwapBuffers(FCanvas.Handle);
  Sleep(1);
end;

procedure TOpenGLHelper.AfterResize(const ClientWidth, ClientHeight: Integer);
const
  FarClipping: Double = 100.0;
  NearClipping: Double = 1.0;
begin
  glViewport(0, 0, ClientWidth, ClientHeight);
  glMatrixMode( GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(30.0, ClientWidth/ClientHeight, NearClipping, FarClipping);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
end;

procedure TOpenGLHelper.UpdateMesh(const FacesList: TFacesList);
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
  Normals: TPS3VectorList;

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
    AddEdge(Face^.Vertex1, Face^.Vertex2);
    AddEdge(Face^.Vertex2, Face^.Vertex3);
    AddEdge(Face^.Vertex3, Face^.Vertex1);
    *)
  end;

begin
  // TODO downsample
  T0 := DateUtils.MilliSecondsBetween(Now, 0);
  T00 := T0;

  // TODO create data (e.g. edges) only on demand ?
  FreeVertices;
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
          FVerticesCount := FacesList.VertexCount;
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
      FreeMem(GLEdges);
      raise;
    end;
  end;
  ShowDebugInfo('OpenGL.AddNormals', T0);
  ShowDebugInfo('OpenGL.TOTAL', T00);
end;

procedure TOpenGLHelper.UpdateMesh(const VertexList: TPS3VectorList);
begin
  // TODO
end;

function TOpenGLHelper.GetXPosition: Double;
begin
  Result := FPosition.X;
end;

procedure TOpenGLHelper.SetXPosition(const X: Double);
begin
  FPosition.X := X;
end;

function TOpenGLHelper.GetYPosition: Double;
begin
  Result := FPosition.Y;
end;

procedure TOpenGLHelper.SetYPosition(const Y: Double);
begin
  FPosition.Y := Y;
end;

function TOpenGLHelper.GetXAngle: Double;
begin
  Result := FAngle.X;
end;

procedure TOpenGLHelper.SetXAngle(const X: Double);
begin
  FAngle.X := X;
end;

function TOpenGLHelper.GetYAngle: Double;
begin
  Result := FAngle.Y;
end;

procedure TOpenGLHelper.SetYAngle(const Y: Double);
begin
  FAngle.Y := Y;
end;

procedure TOpenGLHelper.SetDisplayStyle(const DisplayStyle: TDisplayStyle);
begin
  FDisplayStyle := DisplayStyle;
end;

procedure TOpenGLHelper.SetScale(const Scale: Double);
var
  V: Double;
begin
  V := Scale;
  if V < 0.01 then
    V := 0.01
  else if V > 100.0 then
    V := 100.0;
  FScale := V;
end;

function TOpenGLHelper.GetScale: Double;
begin
  Result := FScale;
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

//  TSVectorMath.SetValue(@MatAmbient, 65.0 / 255.0, 93.0 / 255.0, 144.0 / 255.0);
  TSVectorMath.SetValue(@MatAmbient, 0.0, 0.0, 0.0);
  TSVectorMath.SetValue(@MatSpecular, 0.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0);
  MatShininess := 10.0;
  TSVectorMath.SetValue(@MatDiffuse, 0.49, 0.49, 0.55);

  TSVectorMath.SetValue(@LightAmbient, 0.36, 0.36, 0.26);
  TSVectorMath.SetValue(@LightDiffuse, 0.8, 0.8, 0.8);
  TSVectorMath.SetValue(@LightPosition, 1.0, 11.0, 17.0);

  (*
  LightConstantAttenuation := 1.4;
  LightLinearAttenuation := 0.001;
  LightQuadraticAttenuation := 0.004;
    *)
  LightConstantAttenuation := 0.02;
  LightLinearAttenuation := 0.00;
  LightQuadraticAttenuation := 0.00;

  LightingEnabled := True;
end;


end.



