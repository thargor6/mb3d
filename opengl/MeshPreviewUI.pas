{ ---------------------------------------------------------------------------- }
{ Mesh-Export for MB3D                                                         }
{ Copyright (C) 2016 Andreas Maschke                                           }
{ ---------------------------------------------------------------------------- }
unit MeshPreviewUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MeshPreview, VertexList, Vcl.ExtCtrls,
  Vcl.Buttons;

type
  TMeshPreviewFrm = class(TForm)
    Panel1: TPanel;
    TranslateUpBtn: TSpeedButton;
    TranslateDownBtn: TSpeedButton;
    TranslateRightBtn: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton23: TSpeedButton;
    TranslateLeftBtn: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TranslateLeftBtnClick(Sender: TObject);
    procedure TranslateRightBtnClick(Sender: TObject);
    procedure TranslateUpBtnClick(Sender: TObject);
    procedure TranslateDownBtnClick(Sender: TObject);
  private
    { Private declarations }
    FOpenGLHelper: TOpenGLHelper;
  public
    { Public declarations }
    procedure UpdateMesh(const FacesList: TFacesList);
  end;

var
  MeshPreviewFrm: TMeshPreviewFrm;

implementation

{$R *.dfm}
const
  MOVE_SCALE = 0.1;

procedure TMeshPreviewFrm.FormCreate(Sender: TObject);
begin
  FOpenGLHelper := TOpenGLHelper.Create(Canvas);
end;

procedure TMeshPreviewFrm.FormDestroy(Sender: TObject);
begin
  FOpenGLHelper.Free;
end;

procedure TMeshPreviewFrm.FormResize(Sender: TObject);
begin
  FOpenGLHelper.AfterResize(ClientWidth, ClientHeight);
end;

procedure TMeshPreviewFrm.FormShow(Sender: TObject);
begin
  FOpenGLHelper.InitGL;
end;

procedure TMeshPreviewFrm.TranslateDownBtnClick(Sender: TObject);
begin
  FOpenGLHelper.Translate(0.0, MOVE_SCALE * 1.0, 0.0);
end;

procedure TMeshPreviewFrm.TranslateLeftBtnClick(Sender: TObject);
begin
  FOpenGLHelper.Translate(-MOVE_SCALE, 0.0, 0.0);
end;

procedure TMeshPreviewFrm.TranslateRightBtnClick(Sender: TObject);
begin
  FOpenGLHelper.Translate(MOVE_SCALE, 0.0, 0.0);
end;

procedure TMeshPreviewFrm.TranslateUpBtnClick(Sender: TObject);
begin
  FOpenGLHelper.Translate(0.0, -MOVE_SCALE, 0.0);
end;

procedure TMeshPreviewFrm.UpdateMesh(const FacesList: TFacesList);
begin
  FOpenGLHelper.UpdateMesh(FacesList);
end;

end.
