(*
  HeightMapGenerator for MB3D
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
unit HeightMapGenUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VertexList, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.StdCtrls, VectorMath, Vcl.ComCtrls, JvExExtCtrls,
  JvExtComponent, JvOfficeColorButton, JvExControls, JvColorBox, JvColorButton,
  SpeedButtonEx, BulbTracerUITools, HeightMapGenPreview;

type
  TMapType = (mt8BitPNG, mt16BitPBM);

  THeightMapGenFrm = class(TForm)
    NavigatePnl: TPanel;
    Label15: TLabel;
    Label16: TLabel;
    LoadMeshBtn: TButton;
    SaveMapBtn: TButton;
    MapNumberUpDown: TUpDown;
    MapNumberEdit: TEdit;
    Label19: TLabel;
    MapTypeCmb: TComboBox;
    Label1: TLabel;
    SaveImgBtn: TButton;
    SaveImgDialog: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Label2: TLabel;
    ResetBtn: TButton;
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
    procedure SaveMapBtnClick(Sender: TObject);
    procedure SaveImgBtnClick(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure NavigatePnlClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
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
    function GetHeightMapFileExtension: String;
    procedure EnableControls;
  public
    { Public declarations }
    procedure UpdateMesh(const FacesList: TFacesList); overload;
    procedure UpdateMesh(const VertexList: TPS3VectorList; const ColorList: TPSMI3VectorList); overload;
  end;

var
  HeightMapGenFrm: THeightMapGenFrm;

implementation

uses MeshReader, Maps;

{$R *.dfm}
const
  MOVE_SCALE: Double = 0.001;
  SIZE_SCALE: Double = 0.01;
  ROTATE_SCALE: Double = 0.2;

function THeightMapGenFrm.GetHeightMapFileExtension: String;
begin
  case MapTypeCmb.ItemIndex of
    0: Result := 'png';
    1: Result := 'pgm';
  else
    raise Exception.Create('Invalid format');
  end;
end;

procedure THeightMapGenFrm.SaveImgBtnClick(Sender: TObject);
begin
  case MapTypeCmb.ItemIndex of
    0: begin
         SaveImgDialog.Filter := 'Portable Network Graphic|*.png';
         SaveImgDialog.DefaultExt := 'png';
       end;
    1: begin
         SaveImgDialog.Filter := 'Portable Gray Map|*.pgm';
         SaveImgDialog.DefaultExt := 'pgm';
       end;
  else
    raise Exception.Create('Invalid format');
  end;
  SaveImgDialog.InitialDir := GetHeighMapFolder;
  if SaveImgDialog.Execute then
    FOpenGLHelper.SaveHeightMap(0, 0, ClientWidth, ClientHeight, SaveImgDialog.FileName);
end;

procedure THeightMapGenFrm.SaveMapBtnClick(Sender: TObject);
var
  Filename: String;
begin
  Filename := MakeHeightMapFilename( MapNumberUpDown.Position, GetHeightMapFileExtension );
  if FileExists( Filename ) or ( FindHeightMap( MapNumberUpDown.Position ) <> '' ) then begin
    if MessageDlg('This file already exists. Do you really want to overwrite it?', mtConfirmation, mbYesNo, 0) <> mrOK  then
      exit;
  end;
  FOpenGLHelper.SaveHeightMap(0, 0, ClientWidth, ClientHeight, Filename);
end;

procedure THeightMapGenFrm.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  FOpenGLHelper := TOpenGLHelper.Create(Canvas);
  FOpenGLHelper.SetWindowCaptionEvent := SetWindowCaption;
  FFaces := TFacesList.Create;

  MapTypeCmb.Items.Clear;
  MapTypeCmb.Items.Add('8 Bit PNG');
  MapTypeCmb.Items.Add('16 Bit PGM');
  MapTypeCmb.ItemIndex := 1;
  I := 1;
  while FindHeightMap( I ) <> '' do begin
    Inc( I );
  end;
  MapNumberUpDown.Position := I;

  EnableControls;
end;

procedure THeightMapGenFrm.FormDblClick(Sender: TObject);
begin
  NavigatePnl.Visible := not NavigatePnl.Visible;
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
  if OpenDialog1.Execute  then begin
    with TWavefrontObjFileReader.Create do try
      LoadFromFile( OpenDialog1.Filename, FFaces);
    finally
      Free;
    end;
    FFaces.DoCenter(2.0);
    FFaces.DoScale(1,-1.0,1.0);
    UpdateMesh( FFaces );
    EnableControls;
  end;
end;

procedure THeightMapGenFrm.NavigatePnlClick(Sender: TObject);
begin
  NavigatePnl.Visible := False;
end;

procedure THeightMapGenFrm.ResetBtnClick(Sender: TObject);
begin
  FOpenGLHelper.ResetPosition;
  FOpenGLHelper.Scale := HeightMapGenPreview.DFLT_SCALE;
  FXPosition := FOpenGLHelper.XPosition;
  FYPosition := FOpenGLHelper.YPosition;
  FXAngle := FOpenGLHelper.XAngle;
  FYAngle := FOpenGLHelper.YAngle;
  FScale := FOpenGLHelper.Scale;
end;

procedure THeightMapGenFrm.UpdateMesh(const FacesList: TFacesList);
begin
  FOpenGLHelper.UpdateMesh(FacesList);
end;

procedure THeightMapGenFrm.UpdateMesh(const VertexList: TPS3VectorList; const ColorList: TPSMI3VectorList);
begin
  FOpenGLHelper.UpdateMesh(VertexList, ColorList);
end;

procedure THeightMapGenFrm.SetWindowCaption(const Msg: String);
begin
  Caption := Msg;
end;

procedure THeightMapGenFrm.EnableControls;
begin
  SaveMapBtn.Enabled := FFaces.Count > 0;
  SaveImgBtn.Enabled := FFaces.Count > 0;
end;

end.



