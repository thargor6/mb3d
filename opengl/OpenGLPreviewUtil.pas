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
unit OpenGLPreviewUtil;

interface

uses
  SysUtils, Classes, Windows, dglOpenGL, Vcl.Graphics, VertexList, VectorMath;

type
  TDisplayStyle = (dsPoints, dsWireframe, dsFlatSolid, dsFlatSolidWithEdges, dsSmoothSolid, dsSmoothSolidWithEdges);

  TSetCaptionEvent = procedure(const Msg: String) of object;

  TBaseOpenGLHelper = class
  protected
    FRC: HGLRC; //OpenGL Rendering Context
    FCanvas: TCanvas;
    FFaces, FVertices, FEdges, FNormals, FVertexColors: Pointer;
    FFullMeshFaceCount, FFullMeshVerticesCount: Integer;
    FFaceCount, FEdgeCount, FVerticesCount: Integer;
    FDisplayStyle: TDisplayStyle;
    FSetWindowCaptionEvent: TSetCaptionEvent;
    FFrames, FStartTick: Integer;
    FPosition, FAngle: TS3Vector;
    FScale: Double;
    FSizeMin, FSizeMax: TS3Vector;
    FFOV: Double;
    FMaxObjectSize: Double;
    procedure FreeVertices;
    procedure RaiseError(const Msg: String);
    procedure SetupPixelFormat;
    procedure SetupGL;
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

    procedure AfterInitGL; virtual;
    procedure DrawBackground; virtual;
    procedure ApplicationEventsIdle(Sender: TObject; var Done: Boolean); virtual;
  public
    constructor Create(const Canvas: TCanvas);
    destructor Destroy; override;
    procedure InitGL;
    procedure CleanupGL;
    procedure AfterResize(const ClientWidth, ClientHeight: Integer);
    procedure ResetPosition;
    procedure UpdateMesh(const NewFacesList: TFacesList; const MaxVerticeCount: integer); overload; virtual;
    procedure UpdateMesh(const VertexList: TPS3VectorList; const ColorList: TPSMI3VectorList); overload; virtual;
    procedure SetDisplayStyle(const DisplayStyle: TDisplayStyle);
    property XPosition: Double read GetXPosition write SetXPosition;
    property YPosition: Double read GetYPosition write SetYPosition;
    property XAngle: Double read GetXAngle write SetXAngle;
    property YAngle: Double read GetYAngle write SetYAngle;
    property Scale: Double read GetScale write SetScale;
    property FOV: Double read FFOV write FFOV;
    property SetWindowCaptionEvent: TSetCaptionEvent read FSetWindowCaptionEvent write FSetWindowCaptionEvent;
  end;

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

implementation

uses
  Forms;

constructor TBaseOpenGLHelper.Create(const Canvas: TCanvas);
begin
  inherited Create;
  FDisplayStyle := dsFlatSolidWithEdges;
  FCanvas := Canvas;
  TSVectorMath.Clear(@FPosition);
  TSVectorMath.Clear(@FAngle);
  FScale := 1.0;
  FFOV := 30.0;
end;

destructor TBaseOpenGLHelper.Destroy;
begin
  FreeVertices;
  CleanupGL;
  inherited Destroy;
end;

procedure TBaseOpenGLHelper.FreeVertices;
begin
  FFaceCount := 0;
  FEdgeCount := 0;
  FVerticesCount := 0;
  FFullMeshFaceCount := 0;
  FFullMeshVerticesCount := 0;

  if FVertices <> nil then begin
    FreeMem(FVertices);
    FVertices := nil;
  end;
  if FVertexColors <> nil then begin
    FreeMem(FVertexColors);
    FVertexColors := nil;
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

procedure TBaseOpenGLHelper.RaiseError(const Msg: String);
begin
  raise Exception.Create('OpenGL: '+Msg);
end;

procedure TBaseOpenGLHelper.SetupPixelFormat;
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

procedure TBaseOpenGLHelper.CleanupGL;
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

procedure TBaseOpenGLHelper.DrawBackground;
begin
  // EMPTY
end;

procedure TBaseOpenGLHelper.AfterInitGL;
begin
  // EMPTY
end;

procedure TBaseOpenGLHelper.ApplicationEventsIdle(Sender: TObject; var Done: Boolean);
begin
  // EMPTY
end;

procedure TBaseOpenGLHelper.InitGL;
begin
  if FRC = 0 then begin
    if not InitOpenGL then
      RaiseError('Error initializing OpenGL library');
    SetupPixelFormat;
    FRC := wglCreateContext(FCanvas.Handle);
    if FRC=0 then
      RaiseError('Failed to create rendering context');
    try
      if not wglMakeCurrent(FCanvas.Handle, FRC) then
        RaiseError('Error activating Rendering Context');
      ReadExtensions;

      AfterInitGL;

      SetupGL;
      Application.OnIdle := ApplicationEventsIdle;
    except
      wglDeleteContext(FRC);
      FRC := 0;
      raise;
    end;
  end;
end;

procedure TBaseOpenGLHelper.SetupGL;
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

procedure TBaseOpenGLHelper.AfterResize(const ClientWidth, ClientHeight: Integer);
const
  FarClipping: Double = 100.0;
  NearClipping: Double = 1.0;
begin
  glViewport(0, 0, ClientWidth, ClientHeight);
  glMatrixMode( GL_PROJECTION);
  glLoadIdentity();

  gluPerspective(FFOV, ClientWidth/ClientHeight, NearClipping, FarClipping);


  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
end;

procedure TBaseOpenGLHelper.ResetPosition;
begin
  FPosition.X := 0.0;
  FPosition.Y := 0.0;
  FPosition.Z := 0.0;
  FAngle.X := 0.0;
  FAngle.Y := 0.0;
  FAngle.Z := 0.0;
  FScale := 1.0;
end;


procedure TBaseOpenGLHelper.UpdateMesh(const NewFacesList: TFacesList; const MaxVerticeCount: integer);
begin
  // EMPTY
end;

procedure TBaseOpenGLHelper.UpdateMesh(const VertexList: TPS3VectorList; const ColorList: TPSMI3VectorList);
begin
  // EMPTY
end;

function TBaseOpenGLHelper.GetXPosition: Double;
begin
  Result := FPosition.X;
end;

procedure TBaseOpenGLHelper.SetXPosition(const X: Double);
begin
  FPosition.X := X;
end;

function TBaseOpenGLHelper.GetYPosition: Double;
begin
  Result := FPosition.Y;
end;

procedure TBaseOpenGLHelper.SetYPosition(const Y: Double);
begin
  FPosition.Y := Y;
end;

function TBaseOpenGLHelper.GetXAngle: Double;
begin
  Result := FAngle.X;
end;

procedure TBaseOpenGLHelper.SetXAngle(const X: Double);
begin
  FAngle.X := X;
end;

function TBaseOpenGLHelper.GetYAngle: Double;
begin
  Result := FAngle.Y;
end;

procedure TBaseOpenGLHelper.SetYAngle(const Y: Double);
begin
  FAngle.Y := Y;
end;

procedure TBaseOpenGLHelper.SetDisplayStyle(const DisplayStyle: TDisplayStyle);
begin
  FDisplayStyle := DisplayStyle;
end;

procedure TBaseOpenGLHelper.SetScale(const Scale: Double);
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

function TBaseOpenGLHelper.GetScale: Double;
begin
  Result := FScale;
end;


end.
