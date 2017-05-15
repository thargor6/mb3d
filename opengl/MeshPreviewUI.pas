{ ---------------------------------------------------------------------------- }
{ BulbTracer for MB3D                                                          }
{ Copyright (C) 2016 Andreas Maschke                                           }
{ ---------------------------------------------------------------------------- }
unit MeshPreviewUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MeshPreview, VertexList, Vcl.ExtCtrls,
  Vcl.Buttons, Vcl.StdCtrls, VectorMath, Vcl.ComCtrls, JvExExtCtrls,
  JvExtComponent, JvOfficeColorButton, JvExControls, JvColorBox, JvColorButton,
  SpeedButtonEx, BulbTracerUITools;

type
  TMeshPreviewFrm = class(TForm)
    Panel1: TPanel;
    DisplayStyleGrp: TRadioGroup;
    GroupBox1: TGroupBox;
    AppearancePageCtrl: TPageControl;
    MaterialSheet: TTabSheet;
    LightSheet: TTabSheet;
    Label17: TLabel;
    SurfaceColorBtn: TJvOfficeColorButton;
    Label1: TLabel;
    EdgesColorBtn: TJvOfficeColorButton;
    Label2: TLabel;
    WireframeColorBtn: TJvOfficeColorButton;
    Label3: TLabel;
    PointsColorBtn: TJvOfficeColorButton;
    Label4: TLabel;
    MatAmbientColorBtn: TJvOfficeColorButton;
    MatDiffuseColorLbl: TLabel;
    MatDiffuseColorBtn: TJvOfficeColorButton;
    Label6: TLabel;
    MatSpecularColorBtn: TJvOfficeColorButton;
    Label7: TLabel;
    MatShininessEdit: TEdit;
    MatShininessBtn: TUpDown;
    Label8: TLabel;
    LightAmbientBtn: TJvOfficeColorButton;
    Label9: TLabel;
    LightDiffuseBtn: TJvOfficeColorButton;
    Label5: TLabel;
    LightPositionXEdit: TEdit;
    LightPositionXBtn: TUpDown;
    Label10: TLabel;
    LightPositionYEdit: TEdit;
    LightPositionYBtn: TUpDown;
    Label11: TLabel;
    LightPositionZEdit: TEdit;
    LightPositionZBtn: TUpDown;
    ConstAttenuationEdit: TEdit;
    QuadraticAttenuationBtn: TUpDown;
    QuadraticAttenuationEdit: TEdit;
    Label12: TLabel;
    LinearAttenuationBtn: TUpDown;
    LinearAttenuationEdit: TEdit;
    Label13: TLabel;
    ConstAttenuationBtn: TUpDown;
    Label14: TLabel;
    LightingEnabledCBx: TCheckBox;
    ColorDialog: TColorDialog;
    Label15: TLabel;
    Label16: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DisplayStyleGrpClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MatShininessBtnClick(Sender: TObject; Button: TUDBtnType);
    procedure MatShininessEditExit(Sender: TObject);
    procedure SurfaceColorBtnColorChange(Sender: TObject);
    procedure LightPositionXBtnClick(Sender: TObject; Button: TUDBtnType);
    procedure LightPositionYBtnClick(Sender: TObject; Button: TUDBtnType);
    procedure LightPositionZBtnClick(Sender: TObject; Button: TUDBtnType);
    procedure ConstAttenuationBtnClick(Sender: TObject; Button: TUDBtnType);
    procedure LinearAttenuationBtnClick(Sender: TObject; Button: TUDBtnType);
    procedure QuadraticAttenuationBtnClick(Sender: TObject; Button: TUDBtnType);
    procedure LightingEnabledCBxClick(Sender: TObject);
    procedure SurfaceColorBtnClick(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    { Private declarations }
    FDragging: Boolean;
    FXPosition, FYPosition: Double;
    FXAngle, FYAngle, FScale: Double;
    FStartMouseX, FStartMouseY: Integer;
    FOpenGLHelper: TOpenGLHelper;
    FRefreshing: Boolean;
    procedure SetWindowCaption(const Msg: String);
    procedure AppearanceToUI;
    procedure UIToAppearance;
  public
    { Public declarations }
    procedure UpdateMesh(const FacesList: TFacesList); overload;
    procedure UpdateMesh(const VertexList: TPS3VectorList); overload;
  end;

var
  MeshPreviewFrm: TMeshPreviewFrm;

implementation

{$R *.dfm}
const
  MOVE_SCALE: Double = 0.001;
  SIZE_SCALE: Double = 0.01;
  ROTATE_SCALE: Double = 0.2;

procedure TMeshPreviewFrm.ConstAttenuationBtnClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(ConstAttenuationEdit.Text, FOpenGLHelper.MeshAppearance.LightConstantAttenuation) + UpDownBtnValue(Button, 0.05);
  if Value < 0.0 then
    Value := 0.0;
  ConstAttenuationEdit.Text := FloatToStr(Value);
  UIToAppearance;
end;

procedure TMeshPreviewFrm.DisplayStyleGrpClick(Sender: TObject);
begin
  case DisplayStyleGrp.ItemIndex of
    0: FOpenGLHelper.SetDisplayStyle(dsPoints);
    1: FOpenGLHelper.SetDisplayStyle(dsWireframe);
    2: FOpenGLHelper.SetDisplayStyle(dsFlatSolid);
    3: FOpenGLHelper.SetDisplayStyle(dsFlatSolidWithEdges);
    4: FOpenGLHelper.SetDisplayStyle(dsSmoothSolid);
    5: FOpenGLHelper.SetDisplayStyle(dsSmoothSolidWithEdges);
  end;
end;

procedure TMeshPreviewFrm.FormCreate(Sender: TObject);
begin
  FOpenGLHelper := TOpenGLHelper.Create(Canvas);
  FOpenGLHelper.SetWindowCaptionEvent := SetWindowCaption;
  AppearancePageCtrl.ActivePage := MaterialSheet;
  AppearanceToUI;
  DisplayStyleGrpClick(Sender);
end;

procedure TMeshPreviewFrm.FormDestroy(Sender: TObject);
begin
  FOpenGLHelper.Free;
end;

procedure TMeshPreviewFrm.FormMouseDown(Sender: TObject; Button: TMouseButton;
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

procedure TMeshPreviewFrm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
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

procedure TMeshPreviewFrm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FDragging := False;
end;

procedure TMeshPreviewFrm.FormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  FOpenGLHelper.Scale := FOpenGLHelper.Scale - SIZE_SCALE * 3.0;
end;

procedure TMeshPreviewFrm.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  FOpenGLHelper.Scale := FOpenGLHelper.Scale + SIZE_SCALE * 3.0;
end;

procedure TMeshPreviewFrm.FormResize(Sender: TObject);
begin
  FOpenGLHelper.AfterResize(ClientWidth, ClientHeight);
end;

procedure TMeshPreviewFrm.FormShow(Sender: TObject);
begin
  FOpenGLHelper.InitGL;
  AppearanceToUI;
end;

procedure TMeshPreviewFrm.LightingEnabledCBxClick(Sender: TObject);
begin
  SurfaceColorBtnColorChange(Sender);
end;

procedure TMeshPreviewFrm.LightPositionXBtnClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(LightPositionXEdit.Text, FOpenGLHelper.MeshAppearance.LightPosition.X) + UpDownBtnValue(Button, 0.1);
  LightPositionXEdit.Text := FloatToStr(Value);
  UIToAppearance;
end;

procedure TMeshPreviewFrm.LightPositionYBtnClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(LightPositionYEdit.Text, FOpenGLHelper.MeshAppearance.LightPosition.Y) + UpDownBtnValue(Button, 0.1);
  LightPositionYEdit.Text := FloatToStr(Value);
  UIToAppearance;
end;

procedure TMeshPreviewFrm.LightPositionZBtnClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(LightPositionZEdit.Text, FOpenGLHelper.MeshAppearance.LightPosition.Z) + UpDownBtnValue(Button, 0.1);
  LightPositionZEdit.Text := FloatToStr(Value);
  UIToAppearance;
end;

procedure TMeshPreviewFrm.LinearAttenuationBtnClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(LinearAttenuationEdit.Text, FOpenGLHelper.MeshAppearance.LightLinearAttenuation) + UpDownBtnValue(Button, 0.0005);
  if Value < 0.0 then
    Value := 0.0;
  LinearAttenuationEdit.Text := FloatToStr(Value);
  UIToAppearance;
end;

procedure TMeshPreviewFrm.MatShininessBtnClick(Sender: TObject; Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(MatShininessEdit.Text, FOpenGLHelper.MeshAppearance.MatShininess) + UpDownBtnValue(Button, 1.0);
  if Value < 0.0 then
    Value := 0.0;
  MatShininessEdit.Text := FloatToStr(Value);
  UIToAppearance;
end;

procedure TMeshPreviewFrm.MatShininessEditExit(Sender: TObject);
begin
  UIToAppearance;
end;

procedure TMeshPreviewFrm.QuadraticAttenuationBtnClick(Sender: TObject;
  Button: TUDBtnType);
var
  Value: Double;
begin
  Value := StrToFloatSafe(QuadraticAttenuationEdit.Text, FOpenGLHelper.MeshAppearance.LightQuadraticAttenuation) + UpDownBtnValue(Button, 0.0005);
  if Value < 0.0 then
    Value := 0.0;
  QuadraticAttenuationEdit.Text := FloatToStr(Value);
  UIToAppearance;
end;

procedure TMeshPreviewFrm.UpdateMesh(const FacesList: TFacesList);
begin
  FOpenGLHelper.UpdateMesh(FacesList);
end;

procedure TMeshPreviewFrm.UpdateMesh(const VertexList: TPS3VectorList);
begin
  FOpenGLHelper.UpdateMesh(VertexList);
end;

procedure TMeshPreviewFrm.SetWindowCaption(const Msg: String);
begin
  Caption := Msg;
end;

procedure TMeshPreviewFrm.AppearanceToUI;

  function ToRGBSpace(const V: Double): Integer;
  begin
    Result := Round(255.0 * V);
    if Result < 0 then
      Result := 0
    else if Result > 255 then
      Result := 255;
  end;

  function VecToColor(const V: TPS3Vector): TColor;
  begin
    Result := ToRGBSpace(V^.X) + ToRGBSpace(V^.Y) shl 8 + ToRGBSpace(V^.Z) shl 16;
  end;

begin
  FRefreshing := True;
  try
    with FOpenGLHelper.MeshAppearance do begin
      SurfaceColorBtn.SelectedColor := VecToColor(@SurfaceColor);
      EdgesColorBtn.SelectedColor := VecToColor(@EdgesColor);
      WireframeColorBtn.SelectedColor := VecToColor(@WireframeColor);
      PointsColorBtn.SelectedColor := VecToColor(@PointsColor);

      MatAmbientColorBtn.SelectedColor := VecToColor(@MatAmbient);
      MatDiffuseColorBtn.SelectedColor := VecToColor(@MatDiffuse);
      MatSpecularColorBtn.SelectedColor := VecToColor(@MatSpecular);
      MatShininessEdit.Text := FloatToStr(MatShininess);
      LightAmbientBtn.SelectedColor := VecToColor(@LightAmbient);
      LightDiffuseBtn.SelectedColor := VecToColor(@LightDiffuse);

      LightPositionXEdit.Text := FloatToStr(LightPosition.X);
      LightPositionYEdit.Text := FloatToStr(LightPosition.Y);
      LightPositionZEdit.Text := FloatToStr(LightPosition.Z);

      ConstAttenuationEdit.Text := FloatToStr(LightConstantAttenuation);
      LinearAttenuationEdit.Text := FloatToStr(LightLinearAttenuation);
      QuadraticAttenuationEdit.Text := FloatToStr(LightQuadraticAttenuation);

      LightingEnabledCBx.Checked := LightingEnabled;
    end;
  finally
    FRefreshing := False;
  end;
end;

procedure TMeshPreviewFrm.SurfaceColorBtnClick(Sender: TObject);
begin
  if (Sender<>nil) and (Sender is TJvOfficeColorButton)  then begin
    ColorDialog.Color := TJvOfficeColorButton(Sender).SelectedColor;
    if ColorDialog.Execute(Self.Handle) then begin
      TJvOfficeColorButton(Sender).SelectedColor := ColorDialog.Color;
      UIToAppearance;
    end;
  end;
end;

procedure TMeshPreviewFrm.SurfaceColorBtnColorChange(Sender: TObject);
begin
  UIToAppearance;
end;

procedure TMeshPreviewFrm.UIToAppearance;

  procedure ColorToVec(const Color: TColor; const V: TPS3Vector);
  begin
    V^.X := (Color and $FF)/255.0;
    V^.Y := ((Color shr 8) and $FF)/255.0;
    V^.Z := ((Color shr 16) and $FF)/255.0;
  end;

begin
  if FRefreshing then
    Exit;
  with FOpenGLHelper.MeshAppearance do begin
    ColorToVec(SurfaceColorBtn.SelectedColor, @SurfaceColor);
    ColorToVec(EdgesColorBtn.SelectedColor, @EdgesColor);
    ColorToVec(WireframeColorBtn.SelectedColor, @WireframeColor);
    ColorToVec(PointsColorBtn.SelectedColor, @PointsColor);

    ColorToVec(MatAmbientColorBtn.SelectedColor, @MatAmbient);
    ColorToVec(MatDiffuseColorBtn.SelectedColor, @MatDiffuse);
    ColorToVec(MatSpecularColorBtn.SelectedColor, @MatSpecular);
    MatShininess := StrToFloatSafe(MatShininessEdit.Text, MatShininess);
    if MatShininess < 0.0 then
      MatShininess := 0.0
    else if MatShininess > 100.0 then
      MatShininess := 100.0;

    ColorToVec(LightAmbientBtn.SelectedColor, @LightAmbient);
    ColorToVec(LightDiffuseBtn.SelectedColor, @LightDiffuse);
    LightPosition.X := StrToFloatSafe(LightPositionXEdit.Text, LightPosition.X);
    LightPosition.Y := StrToFloatSafe(LightPositionYEdit.Text, LightPosition.Y);
    LightPosition.Z := StrToFloatSafe(LightPositionZEdit.Text, LightPosition.Z);

    LightConstantAttenuation := StrToFloatSafe(ConstAttenuationEdit.Text, LightConstantAttenuation);
    LightLinearAttenuation := StrToFloatSafe(LinearAttenuationEdit.Text, LightLinearAttenuation);
    LightQuadraticAttenuation := StrToFloatSafe(QuadraticAttenuationEdit.Text, LightQuadraticAttenuation);

    LightingEnabled := LightingEnabledCBx.Checked;
  end;
end;

end.



