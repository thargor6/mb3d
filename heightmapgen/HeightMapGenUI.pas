{ ---------------------------------------------------------------------------- }
{ HeightMapGenerator MB3D                                                      }
{ Copyright (C) 2017 Andreas Maschke                                           }
{ ---------------------------------------------------------------------------- }
unit HeightMapGenUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VertexList, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.StdCtrls, VectorMath, Vcl.ComCtrls, JvExExtCtrls,
  JvExtComponent, JvOfficeColorButton, JvExControls, JvColorBox, JvColorButton,
  SpeedButtonEx, BulbTracerUITools, HeightMapGenPreview;

type
  THeightMapGenFrm = class(TForm)
    Panel1: TPanel;
    Label15: TLabel;
    Label16: TLabel;
    LoadMeshBtn: TButton;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure LoadMeshBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FDragging: Boolean;
    FXPosition, FYPosition: Double;
    FXAngle, FYAngle, FScale: Double;
    FStartMouseX, FStartMouseY: Integer;
    FOpenGLHelper: TOpenGLHelper;
    FRefreshing: Boolean;
    FFaces: TFacesList;
    procedure SetWindowCaption(const Msg: String);
  public
    { Public declarations }
    procedure UpdateMesh(const FacesList: TFacesList); overload;
    procedure UpdateMesh(const VertexList: TPS3VectorList); overload;
  end;

var
  HeightMapGenFrm: THeightMapGenFrm;

implementation

uses MeshReader;

{$R *.dfm}
const
  MOVE_SCALE: Double = 0.001;
  SIZE_SCALE: Double = 0.01;
  ROTATE_SCALE: Double = 0.2;

procedure THeightMapGenFrm.Button1Click(Sender: TObject);
begin
  FOpenGLHelper.SaveHeightMap(0, 0, ClientWidth, ClientHeight);
end;

procedure THeightMapGenFrm.FormCreate(Sender: TObject);
begin
  FOpenGLHelper := TOpenGLHelper.Create(Canvas);
  FOpenGLHelper.SetWindowCaptionEvent := SetWindowCaption;
  FFaces := TFacesList.Create;
end;

procedure THeightMapGenFrm.FormDestroy(Sender: TObject);
begin
  FOpenGLHelper.Free;
  FFaces.Free;
end;

procedure THeightMapGenFrm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FStartMouseX := X;
  FStartMouseY := Y;
  FDragging := True;
  FXPosition := FOpenGLHelper.XPosition;
  FYPosition := FOpenGLHelper.YPosition;
  FXAngle := FOpenGLHelper.XAngle;
  FYAngle := FOpenGLHelper.YAngle;
  FScale := FOpenGLHelper.Scale;
end;

procedure THeightMapGenFrm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FDragging then begin
    if ssMiddle in Shift then begin
      FOpenGLHelper.Scale := FScale - SIZE_SCALE * (FStartMouseX - X);
    end;
    if ssLeft in Shift then begin
      FOpenGLHelper.XPosition := FXPosition - MOVE_SCALE * (FStartMouseX - X);
      FOpenGLHelper.YPosition := FYPosition + MOVE_SCALE * (FStartMouseY - Y);
    end;
    if ssRight in Shift then begin
      FOpenGLHelper.XAngle := FXAngle - ROTATE_SCALE * (FStartMouseX - X);
      FOpenGLHelper.YAngle := FYAngle + ROTATE_SCALE * (FStartMouseY - Y);
    end;
  end;
end;

procedure THeightMapGenFrm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := False;
end;

procedure THeightMapGenFrm.FormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  FOpenGLHelper.Scale := FOpenGLHelper.Scale - SIZE_SCALE * 3.0;
end;

procedure THeightMapGenFrm.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  FOpenGLHelper.Scale := FOpenGLHelper.Scale + SIZE_SCALE * 3.0;
end;

procedure THeightMapGenFrm.FormResize(Sender: TObject);
begin
  FOpenGLHelper.AfterResize(ClientWidth, ClientHeight);
end;

procedure THeightMapGenFrm.FormShow(Sender: TObject);
begin
  FOpenGLHelper.InitGL;
end;

procedure THeightMapGenFrm.LoadMeshBtnClick(Sender: TObject);
begin
  with TLightwaveObjFileReader.Create do try
//    LoadFromFile('D:\TMP\LW_Dragon.lwo', FFaces);
    LoadFromFile('D:\TMP\Half_Ball.lwo', FFaces);
//    LoadFromFile('D:\insect2.lwo', FFaces);
    SetWindowCaption('Heightmap for LW_Dragon.lwo');
    FFaces.DoCenter(2.0);
    FFaces.DoScale(1,-1.0,-1.0);
    UpdateMesh( FFaces );
  finally
    Free;
  end;
end;

procedure THeightMapGenFrm.UpdateMesh(const FacesList: TFacesList);
begin
  FOpenGLHelper.UpdateMesh(FacesList);
end;

procedure THeightMapGenFrm.UpdateMesh(const VertexList: TPS3VectorList);
begin
  FOpenGLHelper.UpdateMesh(VertexList);
end;

procedure THeightMapGenFrm.SetWindowCaption(const Msg: String);
begin
  Caption := Msg;
end;

end.



